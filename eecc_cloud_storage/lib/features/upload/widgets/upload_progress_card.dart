import 'package:flutter/material.dart';
import '../../core/models/upload_task.dart';
import '../../core/utils/file_utils.dart';

class UploadProgressCard extends StatelessWidget {
  final UploadTask task;

  const UploadProgressCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(task.fileName, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                _buildStatusIcon(task.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Provider: ${task.provider.toString().split('.').last}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: task.progress),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${(task.progress * 100).toStringAsFixed(1)}%'),
                Text('${FileUtils.formatFileSize(task.uploadedBytes)} / ${FileUtils.formatFileSize(task.fileSize)}'),
              ],
            ),
            if (task.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(task.errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(UploadStatus status) {
    switch (status) {
      case UploadStatus.pending: return const Icon(Icons.schedule, color: Colors.grey);
      case UploadStatus.uploading: return const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2));
      case UploadStatus.completed: return const Icon(Icons.check_circle, color: Colors.green);
      case UploadStatus.failed: return const Icon(Icons.error, color: Colors.red);
      case UploadStatus.cancelled: return const Icon(Icons.cancel, color: Colors.orange);
    }
  }
}
