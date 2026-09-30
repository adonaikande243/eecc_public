import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/cloud_file.dart';
import 'cloud_storage_interface.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleDriveOAuthService implements ICloudStorageService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: AppConfig.googleDriveScopes,
  );

  @override
  String get providerName => 'Google Drive (Personnel)';

  @override
  String get providerLogo => 'assets/icons/google_drive.png';

  Future<drive.DriveApi?> _getDriveApi() async {
    final account = _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    if (account == null) return null;
    
    final auth = await account.authentication;
    if (auth.accessToken == null) return null;

    final authenticateClient = GoogleAuthClient({'Authorization': 'Bearer ${auth.accessToken}'});
    return drive.DriveApi(authenticateClient);
  }

  Future<void> signIn() async {
    await _googleSignIn.signIn();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  @override
  Future<bool> isAuthenticated() async {
    final account = _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
    return account != null;
  }

  @override
  Future<CloudFile> uploadFile({
    required String filePath,
    required String fileName,
    required String mimeType,
    void Function(double progress, int uploadedBytes)? onProgress,
    VoidCallback? onComplete,
    Function(String error)? onError,
  }) async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) throw Exception('Non authentifié');

      final file = File(filePath);
      final length = await file.length();
      
      final driveFile = drive.File();
      driveFile.name = fileName;
      driveFile.parents = [AppConfig.googleDriveFolderId];

      final media = drive.Media(file.openRead(), length);

      // Pour la progression, on estime comme l'API standard googleapis ne permet pas 
      // de stream progress event nativement pour le Media upload sans un client custom
      onProgress?.call(0.1, (length * 0.1).toInt());

      final result = await driveApi.files.create(
        driveFile,
        uploadMedia: media,
      );

      onProgress?.call(1.0, length);
      onComplete?.call();

      return CloudFile(
        id: result.id ?? '',
        name: result.name ?? fileName,
        size: length,
        mimeType: mimeType,
        provider: CloudProvider.googleDriveOAuth,
        createdAt: result.createdTime,
      );
    } catch (e) {
      onError?.call(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<CloudFile>> listFiles({int limit = 50}) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return [];

    final fileList = await driveApi.files.list(
      q: "'${AppConfig.googleDriveFolderId}' in parents",
      $fields: "files(id, name, size, mimeType, createdTime, webViewLink, webContentLink)",
      pageSize: limit,
    );

    return fileList.files?.map((f) => CloudFile(
      id: f.id ?? '',
      name: f.name ?? '',
      size: int.tryParse(f.size ?? '0') ?? 0,
      mimeType: f.mimeType ?? '',
      webUrl: f.webViewLink,
      downloadUrl: f.webContentLink,
      provider: CloudProvider.googleDriveOAuth,
      createdAt: f.createdTime,
    )).toList() ?? [];
  }

  @override
  Future<bool> deleteFile(String fileId) async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return false;
    await driveApi.files.delete(fileId);
    return true;
  }

  @override
  Future<int?> getAvailableSpace() async {
    final driveApi = await _getDriveApi();
    if (driveApi == null) return null;
    
    final about = await driveApi.about.get($fields: "storageQuota");
    final limit = int.tryParse(about.storageQuota?.limit ?? '0') ?? 0;
    final usage = int.tryParse(about.storageQuota?.usage ?? '0') ?? 0;
    
    return limit > 0 ? (limit - usage) : null;
  }
}
