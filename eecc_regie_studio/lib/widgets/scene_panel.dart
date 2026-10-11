import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/scene_manager.dart';

class ScenePanel extends StatelessWidget {
  const ScenePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sceneManager = context.watch<SceneManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          color: const Color(0xFF0F172A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SCÈNES DE RÉGIE',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 0.8,
                  color: Colors.white70,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${sceneManager.scenes.length}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(6),
            itemCount: sceneManager.scenes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final scene = sceneManager.scenes[index];
              final isPreview = (sceneManager.selectedPreviewSceneIndex == index);
              final isProgram = (sceneManager.programSceneIndex == index);

              Color borderColor = Colors.transparent;
              Color bgColor = const Color(0xFF1E293B);

              if (isProgram) {
                borderColor = const Color(0xFFDC2626);
                bgColor = const Color(0xFF7F1D1D).withOpacity(0.4);
              } else if (isPreview) {
                borderColor = const Color(0xFF059669);
                bgColor = const Color(0xFF065F46).withOpacity(0.3);
              }

              return InkWell(
                onTap: () => sceneManager.selectionnerPreview(index),
                onDoubleTap: () => sceneManager.executeCut(index),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isProgram
                              ? const Color(0xFFDC2626)
                              : (isPreview ? const Color(0xFF059669) : Colors.white24),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          scene.nom,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: (isProgram || isPreview) ? FontWeight.bold : FontWeight.w500,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isProgram)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text('PGM', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        )
                      else if (isPreview)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF059669),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Text('PRV', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
