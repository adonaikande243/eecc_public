import 'package:flutter/material.dart';

class SauvegardesCloudScreen extends StatelessWidget {
  const SauvegardesCloudScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sauvegardes Cloud')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStorageGauge(
            'Google Drive Service Account (Vidéos HD)',
            0.75,
            '75 GB / 100 GB (75%)',
            true,
          ),
          _buildStorageGauge(
            'Google Drive OAuth2 (Audio MP3)',
            0.40,
            '6 GB / 15 GB (40%)',
            false,
          ),
          _buildStorageGauge(
            'OneDrive Compte 1 (Résumés & PDF)',
            0.15,
            '1.5 GB / 10 GB (15%) - OK',
            false,
          ),
          _buildStorageGauge(
            'OneDrive Compte 2 (Sauvegarde miroir)',
            0.90,
            '45 GB / 50 GB (90%) - Résilient, Reprise d\'upload en cours...',
            false,
            color: Colors.orange,
          ),
          const Divider(height: 40),
          const Text('Journal des derniers cultes archivés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildLogItem('Culte du 14 Sept', '3.5 GB', true),
          _buildLogItem('Culte du 7 Sept', '3.2 GB', true),
          _buildLogItem('Culte du 31 Août', '3.4 GB', false),
        ],
      ),
    );
  }

  Widget _buildStorageGauge(String title, double value, String label, bool syncButton, {Color color = Colors.blue}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: value, color: color, minHeight: 10),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(label)),
                if (syncButton)
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sync, size: 16),
                    label: const Text('Sync'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogItem(String date, String size, bool isReplicated) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(date),
      subtitle: Text('Taille: $size'),
      trailing: Icon(
        isReplicated ? Icons.cloud_done : Icons.cloud_upload,
        color: isReplicated ? Colors.green : Colors.grey,
      ),
    );
  }
}
