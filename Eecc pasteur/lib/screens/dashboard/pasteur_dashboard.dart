import 'package:flutter/material.dart';

class PasteurDashboard extends StatelessWidget {
  const PasteurDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Pasteur')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: const [
          Card(child: Center(child: Text('Validation des Résumés'))),
          Card(child: Center(child: Text('Chat Pastoral'))),
          Card(child: Center(child: Text('Membres & Profils'))),
          Card(child: Center(child: Text('Réunions & Visio'))),
        ],
      ),
    );
  }
}
