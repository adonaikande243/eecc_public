import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/scene_manager.dart';

class SourcesPanel extends StatelessWidget {
  const SourcesPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sceneManager = context.watch<SceneManager>();
    final sceneActive = sceneManager.sceneActive;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Theme.of(context).primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sources', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () {
                  // Menu pour ajouter une source
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sceneActive.sources.length,
            itemBuilder: (context, index) {
              final source = sceneActive.sources[index];
              return ListTile(
                leading: Icon(source.estVisible ? Icons.visibility : Icons.visibility_off, size: 20),
                title: Text(source.nom),
                trailing: Icon(source.estMute ? Icons.volume_off : Icons.volume_up, size: 20),
              );
            },
          ),
        ),
      ],
    );
  }
}
