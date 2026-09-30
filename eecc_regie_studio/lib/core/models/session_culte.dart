enum StatutSession { enAttente, enDirect, termine, archive }

class SessionCulte {
  final String id;
  String titreCulte;
  String predicateur;
  DateTime dateDebut;
  DateTime? dateFin;
  String? resumeEcrit;
  String? cheminVideo;
  String? cheminAudio;
  bool enregistrerSurDisque;
  StatutSession statut;
  Map<String, String> referencesCloud;

  SessionCulte({
    required this.id,
    required this.titreCulte,
    required this.predicateur,
    required this.dateDebut,
    this.dateFin,
    this.resumeEcrit,
    this.cheminVideo,
    this.cheminAudio,
    this.enregistrerSurDisque = true,
    this.statut = StatutSession.enAttente,
    Map<String, String>? referencesCloud,
  }) : referencesCloud = referencesCloud ?? {};

  SessionCulte copyWith({
    String? titreCulte,
    String? predicateur,
    DateTime? dateFin,
    String? resumeEcrit,
    String? cheminVideo,
    String? cheminAudio,
    bool? enregistrerSurDisque,
    StatutSession? statut,
    Map<String, String>? referencesCloud,
  }) {
    return SessionCulte(
      id: id,
      titreCulte: titreCulte ?? this.titreCulte,
      predicateur: predicateur ?? this.predicateur,
      dateDebut: dateDebut,
      dateFin: dateFin ?? this.dateFin,
      resumeEcrit: resumeEcrit ?? this.resumeEcrit,
      cheminVideo: cheminVideo ?? this.cheminVideo,
      cheminAudio: cheminAudio ?? this.cheminAudio,
      enregistrerSurDisque: enregistrerSurDisque ?? this.enregistrerSurDisque,
      statut: statut ?? this.statut,
      referencesCloud: referencesCloud ?? this.referencesCloud,
    );
  }
}
