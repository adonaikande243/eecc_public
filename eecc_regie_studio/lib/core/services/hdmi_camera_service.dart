import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:flutter/foundation.dart';

class CameraDevice {
  final String id;
  final String nom;
  final String type;

  CameraDevice({required this.id, required this.nom, required this.type});
}

class HdmiCameraService extends ChangeNotifier {
  List<CameraDevice> _camerasDisponibles = [];
  List<CameraDevice> get camerasDisponibles => List.unmodifiable(_camerasDisponibles);
  
  final Map<String, Player> _players = {};
  final Map<String, VideoController> _controllers = {};
  
  Future<void> scannerCameras() async {
    // Détection simulée pour l'instant (FFmpeg -list_devices serait parsé ici)
    _camerasDisponibles = [
      CameraDevice(id: 'cam1', nom: 'Elgato HD60 S+', type: 'hdmi'),
      CameraDevice(id: 'cam2', nom: 'USB Video Device', type: 'usb'),
      CameraDevice(id: 'cam3', nom: 'Integrated Camera', type: 'integree'),
    ];
    notifyListeners();
  }
  
  Future<void> demarrerCapture(CameraDevice device) async {
    if (_players.containsKey(device.id)) return;
    
    final player = Player();
    // Sur Windows on utilise dshow://video=NomDuDevice
    final media = Media('dshow://video=${device.nom}'); 
    await player.open(media, play: true);
    final controller = VideoController(player);
    
    _players[device.id] = player;
    _controllers[device.id] = controller;
    notifyListeners();
  }
  
  VideoController? getController(String deviceId) => _controllers[deviceId];
  
  Future<void> stopperCapture(String deviceId) async {
    await _players[deviceId]?.dispose();
    _players.remove(deviceId);
    _controllers.remove(deviceId);
    notifyListeners();
  }
}
