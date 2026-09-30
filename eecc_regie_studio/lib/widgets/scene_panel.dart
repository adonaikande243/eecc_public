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
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).primaryColor,
          child: const Text('Scènes', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sceneManager.scenes.length,
            itemBuilder: (context, index) {
              final scene = sceneManager.scenes[index];
              return ListTile(
                title: Text(scene.nom),
                selected: scene.estActive,
                selectedTileColor: Colors.blue.withOpacity(0.2),
                onTap: () => sceneManager.activerScene(scene.id),
                trailing: scene.estActive ? const Icon(Icons.visibility, color: Colors.green) : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
