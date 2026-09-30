import 'package:flutter/foundation.dart';

enum StatutArchivage {
  enCours,
  archivePartiel,
  archiveComplet,
  echec,
}

class CulteArchive {
  final String id;
  final String titre;
  final String theme;
  final String predicateur;
  final DateTime dateCulte;
  final Duration duree;
  final String? videoFileRef;
  final String? audioFileRef;
  final String? resumeEcrit;
  final String? documentResumeFileRef;
  final StatutArchivage statutArchivage;
  final Map<String, String> listeDiffusionReferences;

  CulteArchive({
    required this.id,
    required this.titre,
    required this.theme,
    required this.predicateur,
    required this.dateCulte,
    required this.duree,
    this.videoFileRef,
    this.audioFileRef,
    this.resumeEcrit,
    this.documentResumeFileRef,
    this.statutArchivage = StatutArchivage.enCours,
    this.listeDiffusionReferences = const {},
  });

  factory CulteArchive.fromJson(Map<String, dynamic> json) {
    return CulteArchive(
      id: json['id'],
      titre: json['titre'],
      theme: json['theme'],
      predicateur: json['predicateur'],
      dateCulte: DateTime.parse(json['dateCulte']),
      duree: Duration(seconds: json['dureeSeconds']),
      videoFileRef: json['videoFileRef'],
      audioFileRef: json['audioFileRef'],
      resumeEcrit: json['resumeEcrit'],
      documentResumeFileRef: json['documentResumeFileRef'],
      statutArchivage: StatutArchivage.values.firstWhere(
        (e) => e.toString() == 'StatutArchivage.${json['statutArchivage']}',
        orElse: () => StatutArchivage.enCours,
      ),
      listeDiffusionReferences: Map<String, String>.from(json['listeDiffusionReferences'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'theme': theme,
      'predicateur': predicateur,
      'dateCulte': dateCulte.toIso8601String(),
      'dureeSeconds': duree.inSeconds,
      'videoFileRef': videoFileRef,
      'audioFileRef': audioFileRef,
      'resumeEcrit': resumeEcrit,
      'documentResumeFileRef': documentResumeFileRef,
      'statutArchivage': statutArchivage.toString().split('.').last,
      'listeDiffusionReferences': listeDiffusionReferences,
    };
  }
}
