import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/regie_orchestrator_service.dart';

class CloudArchiveScreen extends StatelessWidget {
  const CloudArchiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchestrator = context.watch<RegieOrchestratorService>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('Archivage Cloud')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statut global', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: orchestrator.progressionArchivage, minHeight: 10),
            const SizedBox(height: 8),
            Text('${(orchestrator.progressionArchivage * 100).toStringAsFixed(1)}%'),
            const Divider(height: 40),
            const Text('Détail des Clouds', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildCloudTile('Google Drive (SA)', 0.5),
            _buildCloudTile('Google Drive (OAuth)', 1.0),
            _buildCloudTile('OneDrive 1', 0.2),
            _buildCloudTile('OneDrive 2', 0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCloudTile(String name, double progress) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.cloud_upload),
        title: Text(name),
        subtitle: LinearProgressIndicator(value: progress),
        trailing: progress == 1.0 ? const Icon(Icons.check, color: Colors.green) : null,
      ),
    );
  }
}
