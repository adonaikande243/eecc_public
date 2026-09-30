import 'package:flutter/material.dart';

class ComiteDashboard extends StatelessWidget {
  const ComiteDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Comités')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ListTile(leading: Icon(Icons.group), title: Text('Gestion des Membres')),
          ListTile(leading: Icon(Icons.music_note), title: Text('Chorales & Chants')),
          ListTile(leading: Icon(Icons.checklist), title: Text('Présences & Répétitions')),
          ListTile(leading: Icon(Icons.assignment), title: Text('Workflow de soumission')),
        ],
      ),
    );
  }
}
