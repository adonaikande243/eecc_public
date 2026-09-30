import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';

class PriereScreen extends StatelessWidget {
  const PriereScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requête de prière')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Sujet de la prière'),
            ),
            const SizedBox(height: 16),
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Détails',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: EeccTheme.violet, foregroundColor: Colors.white),
              child: const Text('Soumettre au Pasteur'),
            )
          ],
        ),
      ),
    );
  }
}
