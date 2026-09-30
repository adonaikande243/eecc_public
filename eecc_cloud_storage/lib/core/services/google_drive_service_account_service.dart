import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/cloud_file.dart';
import '../utils/jwt_helper.dart';
import 'cloud_storage_interface.dart';

class GoogleDriveServiceAccountService implements ICloudStorageService {
  @override
  String get providerName => 'Google Drive (Service Account)';

  @override
  String get providerLogo => 'assets/icons/google_drive.png';

  String? _accessToken;
  DateTime? _tokenExpiry;

  Future<String> _getAccessToken() async {
    if (_accessToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    try {
      final jsonString = await rootBundle.loadString(AppConfig.serviceAccountAssetPath);
      final credentials = jsonDecode(jsonString) as Map<String, dynamic>;
      final jwtToken = JwtHelper.createServiceAccountJwt(credentials);

      final response = await http.post(
        Uri.parse(credentials['token_uri']),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': jwtToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
        _tokenExpiry = DateTime.now().add(Duration(seconds: data['expires_in'] - 60));
        return _accessToken!;
      } else {
        throw Exception('Erreur authentification Service Account: ${response.body}');
      }
    } catch (e) {
      throw Exception('Impossible de lire ou parser le fichier credentials: $e');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      await _getAccessToken();
      return true;
    } catch (_) {
      return false;
    }
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
      final file = File(filePath);
      final totalSize = await file.length();

      final metadata = {
        'name': fileName,
        'parents': [AppConfig.googleDriveFolderId]
      };
      
      final uri = Uri.parse('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart');
      final request = http.MultipartRequest('POST', uri);
      
      request.headers['Authorization'] = 'Bearer $token';
      
      request.files.add(
        http.MultipartFile.fromString(
          'metadata',
          jsonEncode(metadata),
          contentType: http.MediaType('application', 'json'),
        ),
      );
      
      final fileStream = http.ByteStream(file.openRead());
      request.files.add(
        http.MultipartFile(
          'file',
          fileStream,
          totalSize,
          filename: fileName,
        ),
      );

      // Simulation de progression car MultipartRequest ne supporte pas onProgress nativement de manière simple en pur http
      onProgress?.call(0.1, (totalSize * 0.1).toInt());
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        onProgress?.call(1.0, totalSize);
        onComplete?.call();
        final data = jsonDecode(response.body);
        return CloudFile(
          id: data['id'],
          name: fileName,
          size: totalSize,
          mimeType: mimeType,
          provider: CloudProvider.googleDriveServiceAccount,
          createdAt: DateTime.now(),
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      onError?.call(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<CloudFile>> listFiles({int limit = 50}) async {
    final token = await _getAccessToken();
    final url = Uri.parse(
        "https://www.googleapis.com/drive/v3/files?q='${AppConfig.googleDriveFolderId}'+in+parents&fields=files(id,name,mimeType,size,createdTime,webViewLink,webContentLink)&pageSize=$limit");
    
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final files = data['files'] as List;
      return files.map((f) => CloudFile(
        id: f['id'],
        name: f['name'],
        size: int.tryParse(f['size'] ?? '0') ?? 0,
        mimeType: f['mimeType'] ?? '',
        webUrl: f['webViewLink'],
        downloadUrl: f['webContentLink'],
        provider: CloudProvider.googleDriveServiceAccount,
        createdAt: f['createdTime'] != null ? DateTime.parse(f['createdTime']) : null,
      )).toList();
    } else {
      throw Exception('Erreur listFiles: ${response.body}');
    }
  }

  @override
  Future<bool> deleteFile(String fileId) async {
    final token = await _getAccessToken();
    final url = Uri.parse("https://www.googleapis.com/drive/v3/files/$fileId");
    final response = await http.delete(url, headers: {'Authorization': 'Bearer $token'});
    return response.statusCode == 204;
  }

  @override
  Future<int?> getAvailableSpace() async {
    try {
      final token = await _getAccessToken();
      final url = Uri.parse("https://www.googleapis.com/drive/v3/about?fields=storageQuota");
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quota = data['storageQuota'];
        final limit = int.tryParse(quota['limit'] ?? '0') ?? 0;
        final usage = int.tryParse(quota['usage'] ?? '0') ?? 0;
        return limit - usage;
      }
    } catch (_) {}
    return null;
  }
}
