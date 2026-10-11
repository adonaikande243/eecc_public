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

    final isStreaming = streaming.estEnDirect || (orchestrator.sessionEnCours?.statut.name == 'enDirect');

    return Container(
      height: 38,
      color: const Color(0xFF020617),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Statut Streaming
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isStreaming ? const Color(0xFFDC2626) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  color: isStreaming ? Colors.white : Colors.grey,
                  size: 8,
                ),
                const SizedBox(width: 6),
                Text(
                  isStreaming ? 'STREAMING : ON AIR' : 'STREAMING : OFFLINE',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Statut Enregistrement
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: streaming.estEnregistrement ? const Color(0xFF991B1B) : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: streaming.estEnregistrement ? Colors.redAccent : Colors.grey,
                  size: 10,
                ),
                const SizedBox(width: 6),
                Text(
                  streaming.estEnregistrement ? 'REC : MP4 ACTIF' : 'REC : STANDBY',
                  style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Métriques Broadcast (FPS, Débit)
          Row(
            children: const [
              Icon(Icons.speed, size: 14, color: Colors.white38),
              SizedBox(width: 4),
              Text('1080p60 · 4500 kbps · 0% Drop', style: TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 14),

          // Archivage Cloud Google Drive en temps réel
          if (orchestrator.estEnTrainArchiver) ...[
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amberAccent),
            ),
            const SizedBox(width: 8),
            Text(
              '${orchestrator.statutArchivage} (${(orchestrator.progressionArchivage * 100).toInt()}%)',
              style: const TextStyle(color: Colors.amberAccent, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ] else if (orchestrator.statutArchivage.isNotEmpty) ...[
            const Icon(Icons.cloud_done, size: 14, color: Colors.greenAccent),
            const SizedBox(width: 6),
            Text(
              orchestrator.statutArchivage,
              style: const TextStyle(color: Colors.greenAccent, fontSize: 11),
            ),
          ],
          const Spacer(),

          // Session & Horodatage
          Text(
            orchestrator.sessionEnCours != null
                ? 'Session : ${orchestrator.sessionEnCours!.titreCulte}'
                : 'Session : Prêt pour le culte',
            style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
