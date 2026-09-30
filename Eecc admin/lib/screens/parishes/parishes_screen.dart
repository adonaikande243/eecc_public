import 'package:flutter/material.dart';

class ParishesScreen extends StatelessWidget {
  const ParishesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paroisses'),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: const Color(0xFFF9A825),
      ),
      body: const Center(
        child: Text(
          'Gestion des paroisses',
          style: TextStyle(color: Color(0xFF4A148C), fontSize: 18),
        ),
      ),
    );
  }
}
