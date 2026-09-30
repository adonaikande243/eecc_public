import 'package:flutter/foundation.dart';
import 'cloud_file.dart';

enum UploadStatus {
  pending,
  uploading,
  completed,
  failed,
  cancelled
}

class UploadTask extends ChangeNotifier {
  final String id;
  final String fileName;
  final String filePath;
  final int fileSize;
  final CloudProvider provider;
  
  UploadStatus _status;
  double _progress;
  int _uploadedBytes;
  String? _errorMessage;
  final DateTime _startedAt;
  DateTime? _completedAt;
  String? _resumeUrl;

  UploadTask({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.provider,
    UploadStatus status = UploadStatus.pending,
    double progress = 0.0,
    int uploadedBytes = 0,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
    String? resumeUrl,
  })  : _status = status,
        _progress = progress,
        _uploadedBytes = uploadedBytes,
        _errorMessage = errorMessage,
        _startedAt = startedAt ?? DateTime.now(),
        _completedAt = completedAt,
        _resumeUrl = resumeUrl;

  UploadStatus get status => _status;
  double get progress => _progress;
  int get uploadedBytes => _uploadedBytes;
  String? get errorMessage => _errorMessage;
  DateTime get startedAt => _startedAt;
  DateTime? get completedAt => _completedAt;
  String? get resumeUrl => _resumeUrl;

  void updateProgress(double progress, int uploadedBytes) {
    _progress = progress;
    _uploadedBytes = uploadedBytes;
    notifyListeners();
  }

  void updateStatus(UploadStatus status, {String? errorMessage, String? resumeUrl}) {
    _status = status;
    if (errorMessage != null) _errorMessage = errorMessage;
    if (resumeUrl != null) _resumeUrl = resumeUrl;
    if (status == UploadStatus.completed || status == UploadStatus.failed || status == UploadStatus.cancelled) {
      _completedAt = DateTime.now();
    }
    notifyListeners();
  }
}
