import 'dart:io';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class FileUtils {
  static Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.length();
    }
    return 0;
  }

  static String formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = 0;
    double size = bytes.toDouble();
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }

  static String getMimeType(String filePath) {
    final mimeType = lookupMimeType(filePath);
    return mimeType ?? 'application/octet-stream';
  }

  static String generateArchiveName({
    required DateTime date,
    required String type,
    required String originalExtension,
  }) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dateStr = dateFormat.format(date);
    return 'EECC_Culte_${dateStr}_$type${originalExtension.startsWith('.') ? originalExtension : '.$originalExtension'}';
  }

  static bool isVideoFile(String filePath) {
    final mime = getMimeType(filePath);
    return mime.startsWith('video/');
  }

  static bool isAudioFile(String filePath) {
    final mime = getMimeType(filePath);
    return mime.startsWith('audio/');
  }
}
