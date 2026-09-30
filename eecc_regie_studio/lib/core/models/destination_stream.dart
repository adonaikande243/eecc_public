enum TypePlateforme {
  appMobile,
  youtube,
  facebook,
  personnalise,
}

class DestinationStream {
  final String id;
  String nom;
  TypePlateforme plateforme;
  String urlRtmp;
  String cleStream;
  bool estActive;
  bool estConnecte;

  DestinationStream({
    required this.id,
    required this.nom,
    required this.plateforme,
    required this.urlRtmp,
    required this.cleStream,
    this.estActive = true,
    this.estConnecte = false,
  });

  /// Construit l'URL RTMP complète
  String get fullUrl {
    if (urlRtmp.endsWith('/')) {
      return '$urlRtmp$cleStream';
    }
    return '$urlRtmp/$cleStream';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'plateforme': plateforme.name,
        'urlRtmp': urlRtmp,
        'cleStream': cleStream,
        'estActive': estActive,
      };

  factory DestinationStream.fromJson(Map<String, dynamic> json) => DestinationStream(
        id: json['id'],
        nom: json['nom'],
        plateforme: TypePlateforme.values.firstWhere(
          (e) => e.name == json['plateforme'],
          orElse: () => TypePlateforme.personnalise,
        ),
        urlRtmp: json['urlRtmp'],
        cleStream: json['cleStream'] ?? '',
        estActive: json['estActive'] ?? true,
      );
}
