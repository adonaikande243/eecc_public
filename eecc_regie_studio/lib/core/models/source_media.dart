import 'package:flutter/material.dart';

enum TypeSource { hdmi, webrtcTelephone, ecranCapture, image, video, texte, couleurSolide }

class SourceMedia {
  final String id;
  String nom;
  TypeSource type;
  double x;
  double y;
  double largeur;
  double hauteur;
  double opacite;
  bool estVisible;
  bool estMute;
  String? deviceId;
  String? cheminFichier;
  String? texte;
  Color? couleur;

  SourceMedia({
    required this.id,
    required this.nom,
    required this.type,
    this.x = 0.0,
    this.y = 0.0,
    this.largeur = 1920.0,
    this.hauteur = 1080.0,
    this.opacite = 1.0,
    this.estVisible = true,
    this.estMute = false,
    this.deviceId,
    this.cheminFichier,
    this.texte,
    this.couleur,
  });

  SourceMedia copyWith({
    String? nom,
    double? x,
    double? y,
    double? largeur,
    double? hauteur,
    double? opacite,
    bool? estVisible,
    bool? estMute,
  }) {
    return SourceMedia(
      id: id,
      nom: nom ?? this.nom,
      type: type,
      x: x ?? this.x,
      y: y ?? this.y,
      largeur: largeur ?? this.largeur,
      hauteur: hauteur ?? this.hauteur,
      opacite: opacite ?? this.opacite,
      estVisible: estVisible ?? this.estVisible,
      estMute: estMute ?? this.estMute,
      deviceId: deviceId,
      cheminFichier: cheminFichier,
      texte: texte,
      couleur: couleur,
    );
  }
}
