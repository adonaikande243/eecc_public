import 'package:flutter/material.dart';

class PastorMeetingsScreen extends StatelessWidget {
  const PastorMeetingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réunions Pastorales'),
        backgroundColor: const Color(0xFF4A148C),
        foregroundColor: const Color(0xFFF9A825),
      ),
      body: const Center(
        child: Text(
          'Organisation des réunions',
          style: TextStyle(color: Color(0xFF4A148C), fontSize: 18),
        ),
      ),
    );
  }
}
