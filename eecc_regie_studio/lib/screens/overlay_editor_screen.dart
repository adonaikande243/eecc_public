import 'package:flutter/material.dart';

class OverlayEditorScreen extends StatelessWidget {
  const OverlayEditorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Éditeur d\'Habillage Graphique')),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text('Outils d\'habillage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Bandeau Titre'),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.book),
                  label: const Text('Verset Biblique'),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Logo Filigrane'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Text('Prévisualisation Habillage (Canvas 16:9)', style: TextStyle(color: Colors.white54)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
