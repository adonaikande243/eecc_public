import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination_stream.dart';

class DestinationManagerService extends ChangeNotifier {
  static const _keyDestinations = 'eecc_streaming_destinations_v2';
  static const _keyAppMobileActive = 'eecc_diffuser_app_mobile';

  bool _diffuserSurAppMobile = true;
  bool get diffuserSurAppMobile => _diffuserSurAppMobile;

  final List<DestinationStream> _destinations = [];
  List<DestinationStream> get destinations => List.unmodifiable(_destinations);

  DestinationManagerService() {
    chargerDestinations();
  }

  Future<void> chargerDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    _diffuserSurAppMobile = prefs.getBool(_keyAppMobileActive) ?? true;

    final data = prefs.getString(_keyDestinations);
    _destinations.clear();

    if (data != null) {
      try {
        final List<dynamic> list = jsonDecode(data);
        for (var item in list) {
          _destinations.add(DestinationStream.fromJson(item));
        }
      } catch (e) {
        debugPrint('[Destinations] Erreur chargement: $e');
      }
    }

    // Si aucune destination n'est configurée, initialiser les configurations d'église
    if (_destinations.isEmpty) {
      _destinations.addAll([
        DestinationStream(
          id: 'yt_default',
          nom: 'YouTube Live',
          plateforme: TypePlateforme.youtube,
          urlRtmp: 'rtmp://a.rtmp.youtube.com/live2',
          cleStream: '',
          estActive: true,
        ),
        DestinationStream(
          id: 'fb_default',
          nom: 'Facebook Live (Clé permanente)',
          plateforme: TypePlateforme.facebook,
          urlRtmp: 'rtmps://live-api-s.facebook.com:443/rtmp/',
          cleStream: '',
          estActive: false,
        ),
      ]);
      await sauvegarderDestinations();
    }

    notifyListeners();
  }

  Future<void> setDiffuserSurAppMobile(bool active) async {
    _diffuserSurAppMobile = active;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAppMobileActive, active);
    notifyListeners();
  }

  Future<void> toggleDestinationActive(String id, bool active) async {
    final index = _destinations.indexWhere((d) => d.id == id);
    if (index != -1) {
      _destinations[index].estActive = active;
      await sauvegarderDestinations();
      notifyListeners();
    }
  }

  Future<void> mettreAJourDestination({
    required String id,
    required String nom,
    required String urlRtmp,
    required String cleStream,
    required bool estActive,
  }) async {
    final index = _destinations.indexWhere((d) => d.id == id);
    if (index != -1) {
      _destinations[index].nom = nom;
      _destinations[index].urlRtmp = urlRtmp;
      _destinations[index].cleStream = cleStream;
      _destinations[index].estActive = estActive;
      await sauvegarderDestinations();
      notifyListeners();
    }
  }

  Future<void> ajouterDestination(DestinationStream destination) async {
    _destinations.add(destination);
    await sauvegarderDestinations();
    notifyListeners();
  }

  Future<void> supprimerDestination(String id) async {
    _destinations.removeWhere((d) => d.id == id);
    await sauvegarderDestinations();
    notifyListeners();
  }

  Future<void> sauvegarderDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_destinations.map((d) => d.toJson()).toList());
    await prefs.setString(_keyDestinations, jsonString);
  }

  /// Retourne uniquement les destinations RTMP actives ayant une clé renseignée
  List<DestinationStream> obtenirDestinationsRtmpActives() {
    return _destinations
        .where((d) => d.estActive && d.cleStream.trim().isNotEmpty && d.urlRtmp.trim().isNotEmpty)
        .toList();
  }

  bool get isYoutubeActive => _destinations.any(
        (d) => d.plateforme == TypePlateforme.youtube && d.estActive && d.cleStream.isNotEmpty,
      );

  bool get isFacebookActive => _destinations.any(
        (d) => d.plateforme == TypePlateforme.facebook && d.estActive && d.cleStream.isNotEmpty,
      );
}
