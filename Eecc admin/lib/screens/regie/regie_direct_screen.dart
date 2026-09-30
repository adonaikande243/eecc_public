import 'package:flutter/material.dart';

class RegieDirectScreen extends StatelessWidget {
  const RegieDirectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Régie Principale du Direct')),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(height: 300, color: Colors.black, child: const Center(child: Text('Prévisualisation Vidéo', style: TextStyle(color: Colors.white)))),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        labelText: 'Preneur de notes (Résumé en direct)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                const Text('Habillage & Médias', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(),
                ListTile(leading: const Icon(Icons.title), title: const Text('Bandeau Texte (Lower Third)')),
                ListTile(leading: const Icon(Icons.book), title: const Text('Afficher Verset (Bible)')),
                ListTile(leading: const Icon(Icons.image), title: const Text('Insérer Logo/Image')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
