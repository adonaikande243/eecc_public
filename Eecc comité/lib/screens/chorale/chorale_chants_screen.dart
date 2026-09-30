import 'package:flutter/material.dart';

class ChoraleChantsScreen extends StatelessWidget {
  const ChoraleChantsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Répertoire des Chants')),
      body: const Center(
        child: Text('Liste des chants, partitions, audios de répétition et paroles.'),
      ),
    );
  }
}
