import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/scene_manager.dart';

class SourcesPanel extends StatelessWidget {
  const SourcesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sceneManager = context.watch<SceneManager>();
    final previewScene = sceneManager.previewScene;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          color: const Color(0xFF0F172A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SOURCES (${previewScene.nom})',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10.5,
                  letterSpacing: 0.8,
                  color: Colors.white70,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const Icon(Icons.tune, size: 16, color: Colors.white54),
            ],
          ),
        ),
        Expanded(
          child: previewScene.sources.isEmpty
              ? const Center(
                  child: Text(
                    'Aucune source dans cette scène',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(6),
                  itemCount: previewScene.sources.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final source = previewScene.sources[index];

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              source.estVisible ? Icons.visibility : Icons.visibility_off,
                              size: 18,
                              color: source.estVisible ? const Color(0xFF38BDF8) : Colors.white30,
                            ),
                            onPressed: () => sceneManager.basculerVisibiliteSource(source.id),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              source.nom,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: source.estVisible ? Colors.white : Colors.white38,
                                fontWeight: source.estVisible ? FontWeight.w600 : FontWeight.normal,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              source.estMute ? Icons.volume_off : Icons.volume_up,
                              size: 16,
                              color: source.estMute ? Colors.redAccent : Colors.greenAccent,
                            ),
                            onPressed: () {
                              source.estMute = !source.estMute;
                              // Force redraw
                              (context as Element).markNeedsBuild();
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
