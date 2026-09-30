import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/models/cloud_file.dart';
import '../../../core/utils/file_utils.dart';
import '../../../shared/widgets/provider_badge.dart';

class ArchiveCard extends StatelessWidget {
  final CloudFile file;

  const ArchiveCard({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final isVideo = FileUtils.isVideoFile(file.mimeType);
    final dateStr = file.createdAt != null 
        ? DateFormat('dd MMMM yyyy HH:mm', 'fr_FR').format(file.createdAt!) 
        : 'Date inconnue';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: ListTile(
        leading: Icon(
          isVideo ? Icons.video_library : Icons.insert_drive_file,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          file.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(dateStr, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(FileUtils.formatFileSize(file.size), style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                ProviderBadge(provider: file.provider),
              ],
            )
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (val) {
            // Implémenter action
          },
          itemBuilder: (context) => [
            if (file.webUrl != null) const PopupMenuItem(value: 'open', child: Text('Ouvrir le lien')),
            const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
          ],
        ),
      ),
    );
  }
}
