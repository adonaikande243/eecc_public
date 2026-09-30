import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/source_media.dart';
import '../core/services/scene_manager.dart';
import '../core/services/hdmi_camera_service.dart';
import '../core/services/webrtc_camera_service.dart';
import 'package:media_kit_video/media_kit_video.dart';

class PreviewCanvas extends StatelessWidget {
  const PreviewCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sceneManager = context.watch<SceneManager>();
    final scene = sceneManager.sceneActive;
    
    return Stack(
      children: scene.sources.map((source) {
        if (!source.estVisible) return const SizedBox.shrink();
        
        return Positioned(
          left: source.x,
          top: source.y,
          width: source.largeur,
          height: source.hauteur,
          child: Opacity(
            opacity: source.opacite,
            child: _buildSourceWidget(context, source),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSourceWidget(BuildContext context, SourceMedia source) {
    if (source.type == TypeSource.hdmi) {
      final hdmiService = context.watch<HdmiCameraService>();
      final controller = hdmiService.getController(source.deviceId!);
      if (controller != null) {
        return Video(controller: controller);
      }
      return Container(color: Colors.grey, child: const Center(child: Text('Caméra déconnectée')));
    } else if (source.type == TypeSource.couleurSolide) {
      return Container(color: source.couleur ?? Colors.black);
    }
    // Gérer les autres types (WebRTC, Image, etc.)
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
      child: Center(child: Text(source.nom, style: const TextStyle(color: Colors.white))),
    );
  }
}
