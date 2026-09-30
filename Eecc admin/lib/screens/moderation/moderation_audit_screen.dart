import 'package:flutter/material.dart';

class ModerationAuditScreen extends StatelessWidget {
  const ModerationAuditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modération & Audit')),
      body: const Center(
        child: Text('Journal des activités, Gestion des utilisateurs et Modération des commentaires directs.'),
      ),
    );
  }
}
