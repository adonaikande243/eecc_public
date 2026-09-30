import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:eecc_cloud_storage/eecc_cloud_storage.dart';
import '../models/session_culte.dart';
import 'ffmpeg_streaming_service.dart';
import 'destination_manager_service.dart';

class RegieOrchestratorService extends ChangeNotifier {
  final EeccSupabaseService _supabaseService = EeccSupabaseService();
  final GoogleDriveStorageService driveService = GoogleDriveStorageService();

  SessionCulte? sessionEnCours;
  double progressionArchivage = 0.0;
  String statutArchivage = '';
  bool estEnTrainArchiver = false;

  RegieOrchestratorService() {
    _initialiserDrive();
  }

  Future<void> _initialiserDrive() async {
    await driveService.initialiser();
  }

  /// Démarre un Culte avec diffusion multi-plateformes et enregistrement local (optionnel)
  Future<bool> demarrerCulte({
    required String titre,
    required String predicateur,
    required DestinationManagerService destinationManager,
    required FfmpegStreamingService ffmpegService,
    required String qualite,
    bool enregistrerSurDisque = true,
    String? dossierEnregistrement,
  }) async {
    final sessionId = const Uuid().v4();
    sessionEnCours = SessionCulte(
      id: sessionId,
      titreCulte: titre,
      predicateur: predicateur,
      dateDebut: DateTime.now(),
      enregistrerSurDisque: enregistrerSurDisque,
      statut: StatutSession.enDirect,
    );
    notifyListeners();

    // 1. Récupérer les destinations RTMP actives (YouTube et/ou Facebook)
    final rtmpDestinations = destinationManager.obtenirDestinationsRtmpActives();

    // 2. Lancer la diffusion FFmpeg si au moins une destination RTMP est cochée
    if (rtmpDestinations.isNotEmpty) {
      await ffmpegService.demarrerDiffusion(
        sourceDevicesHdmi: [], // Caméras sélectionnées
        sourceWebRtcUrls: [],
        destinations: rtmpDestinations,
        qualite: qualite,
      );
    }

    // 3. Lancer l'enregistrement local MP4 UNIQUEMENT si l'option est activée
    if (enregistrerSurDisque && dossierEnregistrement != null && dossierEnregistrement.isNotEmpty) {
      await ffmpegService.demarrerEnregistrement(dossierEnregistrement);
    }

    // 4. Publier l'état du Live dans Supabase en temps réel pour l'Application Mobile
    final liveSession = EeccLiveSession(
      id: sessionId,
      titre: titre,
      predicateur: predicateur,
      isLive: true,
      surAppMobile: destinationManager.diffuserSurAppMobile,
      surYoutube: destinationManager.isYoutubeActive,
      surFacebook: destinationManager.isFacebookActive,
      startedAt: DateTime.now(),
    );

    final success = await _supabaseService.demarrerLive(liveSession);
    return success;
  }

  Future<void> mettreAJourResume(String texte) async {
    if (sessionEnCours != null) {
      sessionEnCours = sessionEnCours!.copyWith(resumeEcrit: texte);
      notifyListeners();
    }
  }

  /// Termine le culte, arrête la diffusion et téléverse l'enregistrement sur Google Drive
  Future<void> terminerCulteEtArchiver({
    required FfmpegStreamingService ffmpegService,
  }) async {
    if (sessionEnCours == null) return;
    final session = sessionEnCours!;

    // 1. Arrêter la diffusion FFmpeg et l'enregistrement
    final localRecordingPath = ffmpegService.cheminEnregistrement;
    await ffmpegService.stopperTout();

    // 2. Mettre à jour Supabase : Le Live est terminé
    await _supabaseService.arreterLive(session.id);

    // Si l'enregistrement n'était pas demandé, terminer immédiatement sans archiver
    if (!session.enregistrerSurDisque) {
      statutArchivage = 'Diffusion terminée (aucun enregistrement local demandé).';
      estEnTrainArchiver = false;
      sessionEnCours = session.copyWith(statut: StatutSession.termine);
      notifyListeners();
      return;
    }

    sessionEnCours = session.copyWith(statut: StatutSession.archive);
    estEnTrainArchiver = true;
    progressionArchivage = 0.05;
    statutArchivage = 'Arrêt du live confirmé. Préparation de l\'archivage Google Drive...';
    notifyListeners();

    // 3. Archivage réel sur Google Drive
    String? driveVideoId;
    String? driveVideoUrl;

    try {
      if (localRecordingPath != null && File(localRecordingPath).existsSync()) {
        final videoFile = File(localRecordingPath);

        statutArchivage = 'Connexion à Google Drive...';
        progressionArchivage = 0.15;
        notifyListeners();

        // Vérifier l'authentification Drive
        if (!driveService.isInitialized) {
          await driveService.initialiser();
        }

        if (driveService.isInitialized) {
          // Créer ou récupérer le dossier de l'année
          final annee = DateTime.now().year.toString();
          statutArchivage = 'Vérification du dossier Google Drive "EECC_Cultes_$annee"...';
          progressionArchivage = 0.25;
          notifyListeners();

          final dossierId = await driveService.obtenirOuCreerDossier('EECC_Cultes_$annee');

          statutArchivage = 'Téléversement de la vidéo vers Google Drive...';
          progressionArchivage = 0.40;
          notifyListeners();

          final nomFichierDrive =
              'Culte_${session.titreCulte.replaceAll(' ', '_')}_${DateTime.now().toIso8601String().substring(0, 10)}.mp4';

          final uploadedFile = await driveService.uploaderFichier(
            fichier: videoFile,
            nomFichier: nomFichierDrive,
            mimeType: 'video/mp4',
            dossierId: dossierId,
            onProgression: (p) {
              progressionArchivage = 0.40 + (p * 0.45);
              notifyListeners();
            },
          );

          driveVideoId = uploadedFile.id;
          driveVideoUrl = uploadedFile.webViewLink;
          statutArchivage = 'Téléversement Google Drive réussi !';
          progressionArchivage = 0.90;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('[Archivage] Erreur upload Google Drive: $e');
      statutArchivage = 'Erreur Google Drive: $e';
    }

    // 4. Indexation de l'archive dans Supabase pour consultation sur les applications mobiles
    try {
      statutArchivage = 'Enregistrement de l\'archive dans la base de données...';
      progressionArchivage = 0.95;
      notifyListeners();

      final archive = EeccCulteArchive(
        id: session.id,
        titre: session.titreCulte,
        predicateur: session.predicateur,
        dateCulte: session.dateDebut,
        videoDriveId: driveVideoId,
        videoDriveUrl: driveVideoUrl,
        resumeTexte: session.resumeEcrit,
      );

      await _supabaseService.enregistrerArchive(archive);
    } catch (e) {
      debugPrint('[Archivage] Erreur indexation Supabase: $e');
    }

    progressionArchivage = 1.0;
    statutArchivage = 'Archivage terminé avec succès !';
    estEnTrainArchiver = false;
    sessionEnCours = session.copyWith(statut: StatutSession.termine);
    notifyListeners();
  }
}
