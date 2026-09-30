import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/upload_task.dart';
import 'cloud_storage_interface.dart';
import 'google_drive_service_account_service.dart';
import 'google_drive_oauth_service.dart';
import 'onedrive_service.dart';
import 'onedrive_account2_service.dart';
import '../models/cloud_file.dart';

class StorageOrchestrator extends ChangeNotifier {
  final GoogleDriveServiceAccountService googleServiceAccount = GoogleDriveServiceAccountService();
  final GoogleDriveOAuthService googleOAuth = GoogleDriveOAuthService();
  final OneDriveService oneDrive1 = OneDriveService();
  final OneDriveAccount2Service oneDrive2 = OneDriveAccount2Service();

  final List<UploadTask> _activeUploads = [];
  List<UploadTask> get activeUploads => List.unmodifiable(_activeUploads);

  ICloudStorageService _getServiceForProvider(CloudProvider provider) {
    switch (provider) {
      case CloudProvider.googleDriveServiceAccount:
        return googleServiceAccount;
      case CloudProvider.googleDriveOAuth:
        return googleOAuth;
      case CloudProvider.oneDrive1:
        return oneDrive1;
      case CloudProvider.oneDrive2:
        return oneDrive2;
    }
  }

  Future<void> uploadToSelected(
    String filePath, 
    String fileName, 
    String mimeType, 
    int fileSize,
    List<CloudProvider> providers
  ) async {
    final uuid = const Uuid();
    
    final tasks = providers.map((p) {
      final task = UploadTask(
        id: uuid.v4(),
        fileName: fileName,
        filePath: filePath,
        fileSize: fileSize,
        provider: p,
        status: UploadStatus.uploading,
      );
      _activeUploads.add(task);
      return task;
    }).toList();
    
    notifyListeners();

    await Future.wait(tasks.map((task) => _performUpload(task, mimeType)));
  }

  Future<void> _performUpload(UploadTask task, String mimeType) async {
    final service = _getServiceForProvider(task.provider);
    try {
      await service.uploadFile(
        filePath: task.filePath,
        fileName: task.fileName,
        mimeType: mimeType,
        onProgress: (progress, bytes) {
          task.updateProgress(progress, bytes);
          notifyListeners();
        },
        onComplete: () {
          task.updateStatus(UploadStatus.completed);
          notifyListeners();
        },
        onError: (error) {
          task.updateStatus(UploadStatus.failed, errorMessage: error);
          notifyListeners();
        }
      );
    } catch (e) {
      task.updateStatus(UploadStatus.failed, errorMessage: e.toString());
      notifyListeners();
    }
  }

  Future<int> getTotalAvailableSpace() async {
    int total = 0;
    
    final gSpace = await googleServiceAccount.getAvailableSpace();
    if (gSpace != null) total += gSpace;
    
    final oAuthSpace = await googleOAuth.getAvailableSpace();
    if (oAuthSpace != null) total += oAuthSpace;
    
    final oSpace1 = await oneDrive1.getAvailableSpace();
    if (oSpace1 != null) total += oSpace1;
    
    final oSpace2 = await oneDrive2.getAvailableSpace();
    if (oSpace2 != null) total += oSpace2;
    
    return total;
  }
}
