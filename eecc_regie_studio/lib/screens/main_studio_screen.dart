import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/scene_manager.dart';
import '../widgets/preview_canvas.dart';
import '../widgets/scene_panel.dart';
import '../widgets/sources_panel.dart';
import '../widgets/audio_mixer_panel.dart';
import '../core/services/ffmpeg_streaming_service.dart';
import '../widgets/stream_destinations_dialog.dart';
import 'camera_manager_screen.dart';

class MainStudioScreen extends StatelessWidget {
  const MainStudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streaming = context.watch<FfmpegStreamingService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EECC Régie Studio'),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: streaming.estEnDirect ? Colors.red.shade700 : Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: Icon(streaming.estEnDirect ? Icons.stop_circle : Icons.sensors),
            label: Text(
              streaming.estEnDirect ? 'EN DIRECT (GÉRER)' : 'LANCER LE DIRECT',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const StreamDestinationsDialog(),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraManagerScreen())),
            tooltip: 'Gérer les Caméras',
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Panneau de gauche (Scènes et Sources)
                SizedBox(
                  width: 300,
                  child: Column(
                    children: const [
                      Expanded(flex: 1, child: ScenePanel()),
                      Divider(height: 1),
                      Expanded(flex: 1, child: SourcesPanel()),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                
                // Zone centrale (Prévisualisation)
                Expanded(
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade800, width: 2),
                          ),
                          child: const PreviewCanvas(),
                        ),
                      ),
                    ),
                  ),
                ),
                
                const VerticalDivider(width: 1),
                
                // Panneau de droite (Audio)
                SizedBox(
                  width: 250,
                  child: const AudioMixerPanel(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Barre de statut
          const StatusBar(),
        ],
      ),
    );
  }
}
