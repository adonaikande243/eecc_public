import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/source_media.dart';
import '../core/models/scene.dart';
import '../core/services/scene_manager.dart';
import '../core/services/hdmi_camera_service.dart';
import 'package:media_kit_video/media_kit_video.dart';

enum CanvasMode { preview, program }

class PreviewCanvas extends StatelessWidget {
  final CanvasMode mode;
  const PreviewCanvas({Key? key, this.mode = CanvasMode.preview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sceneManager = context.watch<SceneManager>();
    final Scene scene = (mode == CanvasMode.preview)
        ? sceneManager.previewScene
        : sceneManager.programScene;

    return Container(
      color: const Color(0xFF020617),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Mire de test / Signal de fond studio broadcast si aucune source
          if (scene.sources.isEmpty || !scene.sources.any((s) => s.estVisible))
            _buildBroadcastTestPattern(scene.nom),

          ...scene.sources.map((source) {
            if (!source.estVisible) return const SizedBox.shrink();

            return Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: source.opacite,
                child: _buildSourceWidget(context, source),
              ),
            );
          }).toList(),

          // Overlay indicateur de résolution et fps pro
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                mode == CanvasMode.preview ? 'PREV · 1080p59.94' : 'PGM · 1080p60 · LIVE',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastTestPattern(String sceneNom) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: const Icon(Icons.videocam_outlined, size: 36, color: Colors.white54),
            ),
            const SizedBox(height: 12),
            Text(
              sceneNom,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Signal HDMI / Caméra Prêt',
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceWidget(BuildContext context, SourceMedia source) {
    if (source.type == TypeSource.hdmi && source.deviceId != null) {
      final hdmiService = context.watch<HdmiCameraService>();
      final controller = hdmiService.getController(source.deviceId!);
      if (controller != null) {
        return Video(controller: controller, fit: BoxFit.cover);
      }
      return Container(
        color: const Color(0xFF0A0F1D),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.sensors_off, color: Colors.white38, size: 36),
              const SizedBox(height: 8),
              Text(
                'Source Active : ${source.nom}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              const Text(
                'En attente du flux HDMI / WebRTC',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ),
      );
    } else if (source.type == TypeSource.couleurSolide) {
      return Container(
        color: source.couleur ?? const Color(0xFF0F172A),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book, color: Colors.amberAccent, size: 40),
              const SizedBox(height: 12),
              Text(
                source.nom,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              const Text(
                'Écran de projection prêt à être diffusé',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Center(
        child: Text(source.nom, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
