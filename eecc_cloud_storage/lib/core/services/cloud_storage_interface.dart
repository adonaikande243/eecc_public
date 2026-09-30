import 'package:flutter/foundation.dart';
import '../models/cloud_file.dart';

/// Interface abstraite commune à tous les providers cloud
abstract class ICloudStorageService {
  /// Nom du provider pour l'affichage
  String get providerName;
  
  /// Icône/logo du provider (chemin asset)
  String get providerLogo;
  
  /// Vérifie si le service est authentifié et prêt
  Future<bool> isAuthenticated();
  
  /// Upload d'un fichier avec suivi de progression
  Future<CloudFile> uploadFile({
    required String filePath,
    required String fileName,
    required String mimeType,
    void Function(double progress, int uploadedBytes)? onProgress,
    VoidCallback? onComplete,
    Function(String error)? onError,
  });
  
  /// Liste les fichiers dans le dossier EECC
  Future<List<CloudFile>> listFiles({int limit = 50});
  
  /// Supprime un fichier
  Future<bool> deleteFile(String fileId);
  
  /// Obtient l'espace disponible en bytes
  Future<int?> getAvailableSpace();
}
