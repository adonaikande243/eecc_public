import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/regie_orchestrator_service.dart';
import '../core/services/ffmpeg_streaming_service.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orchestrator = context.watch<RegieOrchestratorService>();
    final streaming = context.watch<FfmpegStreamingService>();

    return Container(
      height: 42,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: streaming.estEnDirect ? Colors.red : Colors.grey,
            size: 12,
          ),
          const SizedBox(width: 8),
          Text(
            streaming.estEnDirect ? 'EN DIRECT' : 'HORS LIGNE',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          Icon(
            Icons.fiber_manual_record,
            color: streaming.estEnregistrement ? Colors.red : Colors.grey,
            size: 12,
          ),
          const SizedBox(width: 8),
          Text(streaming.estEnregistrement ? 'ENR ACTIF' : 'PAS D\'ENR'),
          const SizedBox(width: 20),
          // Affichage de l'archivage Google Drive réel
          if (orchestrator.estEnTrainArchiver) ...[
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber),
            ),
            const SizedBox(width: 8),
            Text(
              '${orchestrator.statutArchivage} (${(orchestrator.progressionArchivage * 100).toInt()}%)',
              style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w600),
            ),
          ] else if (orchestrator.statutArchivage.isNotEmpty) ...[
            const Icon(Icons.cloud_done, size: 16, color: Colors.lightGreenAccent),
            const SizedBox(width: 6),
            Text(
              orchestrator.statutArchivage,
              style: const TextStyle(color: Colors.lightGreenAccent),
            ),
          ],
          const Spacer(),
          Text('Session: ${orchestrator.sessionEnCours?.titreCulte ?? "Aucun Culte"}'),
        ],
      ),
    );
  }
}
