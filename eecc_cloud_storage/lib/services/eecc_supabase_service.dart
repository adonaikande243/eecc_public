import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/eecc_api_config.dart';

/// Modèle d'un Culte en direct
class EeccLiveSession {
  final String id;
  final String titre;
  final String predicateur;
  final bool isLive;
  final bool surAppMobile;
  final bool surYoutube;
  final bool surFacebook;
  final String? youtubeUrl;
  final String? facebookUrl;
  final String? streamUrlApp;
  final DateTime startedAt;
  final DateTime? endedAt;

  EeccLiveSession({
    required this.id,
    required this.titre,
    required this.predicateur,
    required this.isLive,
    this.surAppMobile = true,
    this.surYoutube = false,
    this.surFacebook = false,
    this.youtubeUrl,
    this.facebookUrl,
    this.streamUrlApp,
    required this.startedAt,
    this.endedAt,
  });

  factory EeccLiveSession.fromJson(Map<String, dynamic> json) {
    return EeccLiveSession(
      id: json['id']?.toString() ?? '',
      titre: json['titre'] ?? 'Culte en direct',
      predicateur: json['predicateur'] ?? 'Pasteur',
      isLive: json['is_live'] ?? false,
      surAppMobile: json['sur_app_mobile'] ?? true,
      surYoutube: json['sur_youtube'] ?? false,
      surFacebook: json['sur_facebook'] ?? false,
      youtubeUrl: json['youtube_url'],
      facebookUrl: json['facebook_url'],
      streamUrlApp: json['stream_url_app'],
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at']) ?? DateTime.now()
          : DateTime.now(),
      endedAt: json['ended_at'] != null ? DateTime.tryParse(json['ended_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'predicateur': predicateur,
      'is_live': isLive,
      'sur_app_mobile': surAppMobile,
      'sur_youtube': surYoutube,
      'sur_facebook': surFacebook,
      'youtube_url': youtubeUrl,
      'facebook_url': facebookUrl,
      'stream_url_app': streamUrlApp,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
    };
  }
}

/// Modèle d'une archive de culte stockée dans Google Drive et indexée dans Supabase
class EeccCulteArchive {
  final String id;
  final String titre;
  final String predicateur;
  final DateTime dateCulte;
  final String? videoDriveId;
  final String? videoDriveUrl;
  final String? audioDriveId;
  final String? audioDriveUrl;
  final String? resumeDriveUrl;
  final String? resumeTexte;

  EeccCulteArchive({
    required this.id,
    required this.titre,
    required this.predicateur,
    required this.dateCulte,
    this.videoDriveId,
    this.videoDriveUrl,
    this.audioDriveId,
    this.audioDriveUrl,
    this.resumeDriveUrl,
    this.resumeTexte,
  });

  factory EeccCulteArchive.fromJson(Map<String, dynamic> json) {
    return EeccCulteArchive(
      id: json['id']?.toString() ?? '',
      titre: json['titre'] ?? '',
      predicateur: json['predicateur'] ?? '',
      dateCulte: DateTime.tryParse(json['date_culte'] ?? '') ?? DateTime.now(),
      videoDriveId: json['video_drive_id'],
      videoDriveUrl: json['video_drive_url'],
      audioDriveId: json['audio_drive_id'],
      audioDriveUrl: json['audio_drive_url'],
      resumeDriveUrl: json['resume_drive_url'],
      resumeTexte: json['resume_texte'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'predicateur': predicateur,
      'date_culte': dateCulte.toIso8601String(),
      'video_drive_id': videoDriveId,
      'video_drive_url': videoDriveUrl,
      'audio_drive_id': audioDriveId,
      'audio_drive_url': audioDriveUrl,
      'resume_drive_url': resumeDriveUrl,
      'resume_texte': resumeTexte,
    };
  }
}

/// Service réel Supabase pour synchronisation des Lives et Archives
class EeccSupabaseService {
  static final EeccSupabaseService _instance = EeccSupabaseService._internal();
  factory EeccSupabaseService() => _instance;
  EeccSupabaseService._internal();

  final String _baseUrl = EeccApiConfig.supabaseUrl;
  final String _anonKey = EeccApiConfig.supabaseAnonKey;
  final String _serviceKey = EeccApiConfig.supabaseServiceRoleKey;

  Map<String, String> _headers({bool useServiceRole = false}) => {
        'Content-Type': 'application/json',
        'apikey': useServiceRole ? _serviceKey : _anonKey,
        'Authorization': 'Bearer ${useServiceRole ? _serviceKey : _anonKey}',
        'Prefer': 'return=representation',
      };

  // ===========================================================================
  // GESTION DU LIVE (Régie & Application Mobile)
  // ===========================================================================

  /// Publie le statut du Live depuis la Régie Studio
  Future<bool> demarrerLive(EeccLiveSession live) async {
    try {
      final url = Uri.parse('$_baseUrl/rest/v1/eecc_lives');
      final response = await http.post(
        url,
        headers: _headers(useServiceRole: true),
        body: jsonEncode(live.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('[Supabase] Live publié avec succès: ${live.titre}');
        return true;
      } else {
        // En cas d'existence préalable, tenter un upsert
        final updateUrl = Uri.parse('$_baseUrl/rest/v1/eecc_lives?id=eq.${live.id}');
        final updateRes = await http.patch(
          updateUrl,
          headers: _headers(useServiceRole: true),
          body: jsonEncode(live.toJson()),
        );
        return updateRes.statusCode == 200 || updateRes.statusCode == 204;
      }
    } catch (e) {
      debugPrint('[Supabase] Erreur démarrage Live: $e');
      return false;
    }
  }

  /// Arrête le Live en cours
  Future<bool> arreterLive(String liveId) async {
    try {
      final url = Uri.parse('$_baseUrl/rest/v1/eecc_lives?id=eq.$liveId');
      final response = await http.patch(
        url,
        headers: _headers(useServiceRole: true),
        body: jsonEncode({
          'is_live': false,
          'ended_at': DateTime.now().toIso8601String(),
        }),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      debugPrint('[Supabase] Erreur arrêt Live: $e');
      return false;
    }
  }

  /// Récupère le culte actuellement en direct (s'il y en a un)
  Future<EeccLiveSession?> obtenirLiveEnCours() async {
    try {
      final url = Uri.parse(
        '$_baseUrl/rest/v1/eecc_lives?is_live=eq.true&order=started_at.desc&limit=1',
      );
      final response = await http.get(url, headers: _headers());

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        if (list.isNotEmpty) {
          return EeccLiveSession.fromJson(list.first);
        }
      }
    } catch (e) {
      debugPrint('[Supabase] Erreur vérification Live en cours: $e');
    }
    return null;
  }

  /// Stream périodique pour notifier les mobiles en temps réel du statut du culte
  Stream<EeccLiveSession?> ecouterLiveEnCours({Duration intervalle = const Duration(seconds: 5)}) async* {
    while (true) {
      yield await obtenirLiveEnCours();
      await Future.delayed(intervalle);
    }
  }

  // ===========================================================================
  // GESTION DES ARCHIVES DE CULTE (Google Drive Index)
  // ===========================================================================

  /// Enregistre une archive de culte après upload sur Google Drive
  Future<bool> enregistrerArchive(EeccCulteArchive archive) async {
    try {
      final url = Uri.parse('$_baseUrl/rest/v1/eecc_archives');
      final response = await http.post(
        url,
        headers: _headers(useServiceRole: true),
        body: jsonEncode(archive.toJson()),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      debugPrint('[Supabase] Erreur enregistrement archive: $e');
      return false;
    }
  }

  /// Récupère la liste de toutes les archives pour l'app mobile
  Future<List<EeccCulteArchive>> obtenirArchives({int limite = 50}) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/rest/v1/eecc_archives?order=date_culte.desc&limit=$limite',
      );
      final response = await http.get(url, headers: _headers());

      if (response.statusCode == 200) {
        final List<dynamic> list = jsonDecode(response.body);
        return list.map((item) => EeccCulteArchive.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('[Supabase] Erreur récupération archives: $e');
    }
    return [];
  }
}
