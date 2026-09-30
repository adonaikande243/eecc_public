import 'package:flutter/material.dart';

class EcodimScreen extends StatelessWidget {
  const EcodimScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('École du Dimanche'),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: const Color(0xFFF9A825),
      ),
      body: const Center(
        child: Text(
          'Espace Ecodim',
          style: TextStyle(color: Color(0xFF4A148C), fontSize: 18),
        ),
      ),
    );
  }
}
