import 'package:flutter/material.dart';

class MaishapayAdminScreen extends StatelessWidget {
  const MaishapayAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de bord MaishaPay')),
      body: const Center(
        child: Text('Statistiques des offrandes, Historique des transactions et Rapprochement.'),
      ),
    );
  }
}
