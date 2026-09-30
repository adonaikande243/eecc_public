import 'package:flutter/material.dart';

class ChatPastoralScreen extends StatelessWidget {
  const ChatPastoralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Pastoral & Réunions')),
      body: const Center(
        child: Text('Liste des conversations avec les fidèles et liens de visioconférence.'),
      ),
    );
  }
}
