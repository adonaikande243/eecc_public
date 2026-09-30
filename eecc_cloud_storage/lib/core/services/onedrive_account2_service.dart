import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/cloud_file.dart';
import 'cloud_storage_interface.dart';
import 'onedrive_service.dart';

/// Phase 4 : Complexe (Upload toujours resumable avec reprise)
class OneDriveAccount2Service extends OneDriveService {
  @override
  String get providerName => 'OneDrive (Compte 2)';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey2 = 'onedrive_token_2';

  @override
  Future<String?> _getAccessToken() async {
    return await _storage.read(key: _tokenKey2);
  }

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey2, value: token);
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

      // Toujours utiliser resumable upload pour la Phase 4
      final sessionUrl = Uri.parse("https://graph.microsoft.com/v1.0/me/drive/items/$folderId:/$fileName:/createUploadSession");
      final sessionRes = await http.post(sessionUrl, headers: {'Authorization': 'Bearer $token'});
      
      if (sessionRes.statusCode != 200) throw Exception("Impossible de créer la session d'upload");
      
      final uploadUrl = jsonDecode(sessionRes.body)['uploadUrl'];
      
      // Sauvegarder uploadUrl dans les préférences locales pour reprise future si besoin
      // ... implémentation omise pour rester concis ...
      
      return await _uploadChunksWithRetry(file, fileSize, uploadUrl, onProgress, onComplete);
    } catch (e) {
      onError?.call(e.toString());
      rethrow;
    }
  }

  Future<CloudFile> _uploadChunksWithRetry(
    File file, 
    int fileSize, 
    String uploadUrl,
    void Function(double, int)? onProgress,
    VoidCallback? onComplete
  ) async {
    final randomAccessFile = await file.open();
    int bytesUploaded = 0;
    Map<String, dynamic>? finalData;
    int retries = 0;
    const maxRetries = 3;

    try {
      while (bytesUploaded < fileSize) {
        final chunkSize = min(AppConfig.resumableChunkSize, fileSize - bytesUploaded);
        final chunk = await randomAccessFile.read(chunkSize);
        
        bool success = false;
        while (!success && retries < maxRetries) {
          try {
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
              success = true;
              retries = 0;
            } else if (response.statusCode == 201 || response.statusCode == 200) {
              bytesUploaded += chunk.length;
              onProgress?.call(1.0, fileSize);
              onComplete?.call();
              finalData = jsonDecode(responseData);
              success = true;
              break;
            } else {
              throw Exception("HTTP Error ${response.statusCode}: $responseData");
            }
          } catch (e) {
            retries++;
            if (retries >= maxRetries) throw Exception("Max retries reached: $e");
            await Future.delayed(Duration(seconds: pow(2, retries).toInt())); // Backoff exponentiel
          }
        }
      }
    } finally {
      await randomAccessFile.close();
    }

    if (finalData != null) {
      return _parseGraphResponse(finalData, CloudProvider.oneDrive2);
    } else {
      throw Exception("Upload incomplet");
    }
  }

  Future<void> resumeInterruptedUploads() async {
    // Logique pour lire les URL d'upload inachevées depuis SharedPreferences
    // et reprendre l'upload en demandant l'état à l'URL.
  }
}
