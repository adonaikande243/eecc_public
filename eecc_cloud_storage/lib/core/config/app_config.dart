/// Configuration centralisée pour toutes les APIs cloud EECC
class AppConfig {
  // ── Google Drive (Phase 1 & 2) ──────────────────────────────────────────
  /// ID du dossier Google Drive où seront stockées les archives
  static const String googleDriveFolderId = 'YOUR_GOOGLE_DRIVE_FOLDER_ID';
  
  /// Scopes OAuth2 pour Google Drive
  static const List<String> googleDriveScopes = [
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.metadata.readonly',
  ];
  
  /// Chemin du fichier JSON du service account (assets)
  static const String serviceAccountAssetPath = 'assets/credentials/service_account.json';
  
  // ── OneDrive / Microsoft Graph (Phase 3 & 4) ────────────────────────────
  /// Tenant ID Microsoft (utiliser 'common' pour multi-tenant)
  static const String microsoftTenantId = 'common';
  
  /// Client ID de l'app enregistrée sur Azure Portal
  static const String microsoftClientId1 = 'YOUR_AZURE_CLIENT_ID_1';
  static const String microsoftClientId2 = 'YOUR_AZURE_CLIENT_ID_2';
  
  /// Redirect URI configurée sur Azure Portal
  static const String msalRedirectUri = 'msauth://com.eecc.cloud_storage/callback';
  
  /// Scopes Microsoft Graph pour OneDrive
  static const List<String> oneDriveScopes = [
    'https://graph.microsoft.com/Files.ReadWrite',
    'https://graph.microsoft.com/Files.ReadWrite.All',
    'offline_access',
  ];
  
  /// Nom du dossier OneDrive pour les archives EECC
  static const String oneDriveFolderName = 'EECC_Archives_Cultes';
  
  // ── Upload settings ─────────────────────────────────────────────────────
  /// Taille max pour upload simple (4 MB = limite OneDrive non-resumable)
  static const int maxSimpleUploadBytes = 4 * 1024 * 1024;
  
  /// Taille des chunks pour upload resumable (320 KB multiple requis par Graph API)
  static const int resumableChunkSize = 5 * 320 * 1024; // 1.6 MB
}
