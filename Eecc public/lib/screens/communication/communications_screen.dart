import 'package:flutter/material.dart';

class CommunicationsScreen extends StatelessWidget {
  const CommunicationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communications'),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: const Color(0xFFF9A825),
      ),
      body: const Center(
        child: Text(
          'Annonces et communications paroissiales',
          style: TextStyle(color: Color(0xFF4A148C), fontSize: 18),
        ),
      ),
    );
  }
}
