import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/cloud_file.dart';
import 'cloud_storage_interface.dart';

class OneDriveService implements ICloudStorageService {
  final String _clientId = AppConfig.microsoftClientId1;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'onedrive_token_1';

  @override
  String get providerName => 'OneDrive (Compte 1)';

  @override
  String get providerLogo => 'assets/icons/onedrive.png';

  Future<String?> _getAccessToken() async {
    // En production, implémenter un vrai refresh token flow
    return await _storage.read(key: _tokenKey);
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _getAccessToken();
    return token != null;
  }

  Future<String?> _ensureFolder() async {
    final token = await _getAccessToken();
    if (token == null) throw Exception("Non authentifié");

    // Vérifier si le dossier existe
    final url = Uri.parse("https://graph.microsoft.com/v1.0/me/drive/root/children/${AppConfig.oneDriveFolderName}");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else if (response.statusCode == 404) {
      // Créer le dossier
      final createUrl = Uri.parse("https://graph.microsoft.com/v1.0/me/drive/root/children");
      final createResponse = await http.post(
        createUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "name": AppConfig.oneDriveFolderName,
          "folder": { },
          "@microsoft.graph.conflictBehavior": "rename"
        }),
      );
      if (createResponse.statusCode == 201) {
        return jsonDecode(createResponse.body)['id'];
      }
    }
    return null;
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
      final token = await _getAccessToken();
      if (token == null) throw Exception("Non authentifié");

      final file = File(filePath);
      final fileSize = await file.length();
      final folderId = await _ensureFolder();
      
      if (folderId == null) throw Exception("Impossible de créer le dossier cible");

      if (fileSize < AppConfig.maxSimpleUploadBytes) {
        // Simple Upload
        final url = Uri.parse("https://graph.microsoft.com/v1.0/me/drive/items/$folderId:/$fileName:/content");
        final request = http.Request('PUT', url);
        request.headers['Authorization'] = 'Bearer $token';
        request.headers['Content-Type'] = mimeType;
        request.bodyBytes = await file.readAsBytes();

        final response = await request.send();
        final responseData = await response.stream.bytesToString();

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(responseData);
          onProgress?.call(1.0, fileSize);
          onComplete?.call();
          return _parseGraphResponse(data, CloudProvider.oneDrive1);
        } else {
          throw Exception("Erreur upload simple: $responseData");
        }
      } else {
        // Resumable Upload
        final sessionUrl = Uri.parse("https://graph.microsoft.com/v1.0/me/drive/items/$folderId:/$fileName:/createUploadSession");
        final sessionRes = await http.post(sessionUrl, headers: {'Authorization': 'Bearer $token'});
        
        if (sessionRes.statusCode != 200) throw Exception("Impossible de créer la session d'upload");
        
        final uploadUrl = jsonDecode(sessionRes.body)['uploadUrl'];
        return await _uploadChunks(file, fileSize, uploadUrl, onProgress, onComplete, CloudProvider.oneDrive1);
      }
    } catch (e) {
      onError?.call(e.toString());
      rethrow;
    }
  }

  Future<CloudFile> _uploadChunks(
    File file, 
    int fileSize, 
    String uploadUrl,
    void Function(double, int)? onProgress,
    VoidCallback? onComplete,
    CloudProvider provider
  ) async {
    final randomAccessFile = await file.open();
    int bytesUploaded = 0;
    Map<String, dynamic>? finalData;

    try {
      while (bytesUploaded < fileSize) {
        final chunkSize = min(AppConfig.resumableChunkSize, fileSize - bytesUploaded);
        final chunk = await randomAccessFile.read(chunkSize);
        
        final url = Uri.parse(uploadUrl);
        final request = http.Request('PUT', url);
        request.headers['Content-Length'] = chunk.length.toString();
        request.headers['Content-Range'] = 'bytes $bytesUploaded-${bytesUploaded + chunk.length - 1}/$fileSize';
        request.bodyBytes = chunk;

        final response = await request.send();
        final responseData = await response.stream.bytesToString();

        if (response.statusCode == 202) {
          bytesUploaded += chunk.length;
          onProgress?.call(bytesUploaded / fileSize, bytesUploaded);
        } else if (response.statusCode == 201 || response.statusCode == 200) {
          bytesUploaded += chunk.length;
          onProgress?.call(1.0, fileSize);
          onComplete?.call();
          finalData = jsonDecode(responseData);
          break;
        } else {
          throw Exception("Erreur chunk upload: $responseData");
        }
      }
    } finally {
      await randomAccessFile.close();
    }

    if (finalData != null) {
      return _parseGraphResponse(finalData, provider);
    } else {
      throw Exception("Upload incomplet");
    }
  }

  CloudFile _parseGraphResponse(Map<String, dynamic> data, CloudProvider provider) {
    return CloudFile(
      id: data['id'],
      name: data['name'],
      size: data['size'],
      mimeType: data['file']?['mimeType'] ?? '',
      webUrl: data['webUrl'],
      downloadUrl: data['@microsoft.graph.downloadUrl'],
      provider: provider,
      createdAt: data['createdDateTime'] != null ? DateTime.parse(data['createdDateTime']) : null,
    );
  }

  @override
  Future<List<CloudFile>> listFiles({int limit = 50}) async {
    final token = await _getAccessToken();
    if (token == null) return [];

    final url = Uri.parse("https://graph.microsoft.com/v1.0/me/drive/root/children/${AppConfig.oneDriveFolderName}/children?\$top=$limit");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final items = data['value'] as List;
      return items.map((item) => _parseGraphResponse(item, CloudProvider.oneDrive1)).toList();
    }
    return [];
  }

  @override
  Future<bool> deleteFile(String fileId) async {
    final token = await _getAccessToken();
    if (token == null) return false;
    final url = Uri.parse("https://graph.microsoft.com/v1.0/me/drive/items/$fileId");
    final response = await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    return response.statusCode == 204;
  }

  @override
  Future<int?> getAvailableSpace() async {
    final token = await _getAccessToken();
    if (token == null) return null;
    final url = Uri.parse("https://graph.microsoft.com/v1.0/me/drive");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final quota = data['quota'];
      final remaining = quota['remaining'] as int?;
      return remaining;
    }
    return null;
  }
}
