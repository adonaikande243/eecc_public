import 'package:flutter/material.dart';

class SermonsScreen extends StatelessWidget {
  const SermonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prédications'),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: const Color(0xFFF9A825),
      ),
      body: const Center(
        child: Text(
          'Liste des prédications et détails',
          style: TextStyle(color: Color(0xFF4A148C), fontSize: 18),
        ),
      ),
    );
  }
}
