import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/eecc_api_config.dart';

/// Modèle pour un fichier trouvé dans Google Drive
class DriveFileItem {
  final String id;
  final String name;
  final String mimeType;
  final int? size;
  final DateTime? modifiedTime;
  final String? webViewLink;
  final String? thumbnailLink;

  DriveFileItem({
    required this.id,
    required this.name,
    required this.mimeType,
    this.size,
    this.modifiedTime,
    this.webViewLink,
    this.thumbnailLink,
  });

  factory DriveFileItem.fromGoogleFile(drive.File file) {
    return DriveFileItem(
      id: file.id ?? '',
      name: file.name ?? 'Sans nom',
      mimeType: file.mimeType ?? 'application/octet-stream',
      size: file.size != null ? int.tryParse(file.size!) : null,
      modifiedTime: file.modifiedTime,
      webViewLink: file.webViewLink,
      thumbnailLink: file.thumbnailLink,
    );
  }
}

/// Service complet de gestion Google Drive v3 (Stockage & Recherche)
/// 
/// Utilise les identifiants OAuth Bureau (Desktop) avec renouvellement automatique des tokens.
class GoogleDriveStorageService extends ChangeNotifier {
  static const _scopes = [
    drive.DriveApi.driveFileScope,
    drive.DriveApi.driveMetadataReadonlyScope,
  ];

  static const _storage = FlutterSecureStorage();
  static const _keyTokenDrive1 = 'eecc_drive1_credentials_json';
  static const _keyTokenDrive2 = 'eecc_drive2_credentials_json';

  drive.DriveApi? _driveApi1;
  drive.DriveApi? _driveApi2;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  String? _currentUserEmailDrive1;
  String? get currentUserEmailDrive1 => _currentUserEmailDrive1;

  double _uploadProgress = 0.0;
  double get uploadProgress => _uploadProgress;

  /// Initialise la connexion Google Drive en chargeant les jetons existants
  Future<bool> initialiser() async {
    try {
      final savedCreds1 = await _storage.read(key: _keyTokenDrive1);
      if (savedCreds1 != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(savedCreds1);
        final accessCredentials = AccessCredentials(
          AccessToken(
            jsonMap['token_type'] ?? 'Bearer',
            jsonMap['data'] ?? '',
            DateTime.parse(jsonMap['expiry'] ?? DateTime.now().toIso8601String()),
          ),
          jsonMap['refresh_token'],
          _scopes,
        );

        final clientId = ClientId(
          EeccApiConfig.googleDrive1ClientId,
          EeccApiConfig.googleDrive1ClientSecret,
        );

        final client = autoRefreshingClient(clientId, accessCredentials, http.Client());
        _driveApi1 = drive.DriveApi(client);

        // Tester la validité
        final about = await _driveApi1!.about.get($fields: 'user(emailAddress)');
        _currentUserEmailDrive1 = about.user?.emailAddress;
        _isInitialized = true;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('[GoogleDrive] Erreur chargement jetons sauvegardés: $e');
    }
    return false;
  }

  /// Lance l'authentification OAuth2 Bureau (Desktop loopback)
  /// Ouvre le navigateur par défaut pour validation par l'utilisateur
  Future<bool> authentifierDrive1({Function(String url)? onAuthUrl}) async {
    try {
      final clientId = ClientId(
        EeccApiConfig.googleDrive1ClientId,
        EeccApiConfig.googleDrive1ClientSecret,
      );

      final client = await clientViaUserConsent(
        clientId,
        _scopes,
        (url) async {
          debugPrint('[GoogleDrive] URL d\'authentification: $url');
          if (onAuthUrl != null) {
            onAuthUrl(url);
          } else {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          }
        },
      );

      _driveApi1 = drive.DriveApi(client);

      // Sauvegarde sécurisée du refresh token et access token
      final credsJson = jsonEncode({
        'token_type': client.credentials.accessToken.type,
        'data': client.credentials.accessToken.data,
        'expiry': client.credentials.accessToken.expiry.toIso8601String(),
        'refresh_token': client.credentials.refreshToken,
      });

      await _storage.write(key: _keyTokenDrive1, value: credsJson);

      final about = await _driveApi1!.about.get($fields: 'user(emailAddress)');
      _currentUserEmailDrive1 = about.user?.emailAddress;
      _isInitialized = true;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[GoogleDrive] Échec authentification: $e');
      return false;
    }
  }

  /// Récupère ou crée un dossier par nom à la racine ou dans un parent
  Future<String> obtenirOuCreerDossier(String nomDossier, {String? parentFolderId}) async {
    _verifierInitialisation();
    
    // Rechercher si le dossier existe déjà
    String q = "mimeType = 'application/vnd.google-apps.folder' and name = '$nomDossier' and trashed = false";
    if (parentFolderId != null) {
      q += " and '$parentFolderId' in parents";
    }

    final result = await _driveApi1!.files.list(q: q, $fields: 'files(id, name)');
    if (result.files != null && result.files!.isNotEmpty) {
      return result.files!.first.id!;
    }

    // Créer le dossier s'il n'existe pas
    final folderMetadata = drive.File()
      ..name = nomDossier
      ..mimeType = 'application/vnd.google-apps.folder';
    
    if (parentFolderId != null) {
      folderMetadata.parents = [parentFolderId];
    }

    final createdFolder = await _driveApi1!.files.create(folderMetadata, $fields: 'id');
    return createdFolder.id!;
  }

  /// Upload d'un fichier réel (Vidéo, Audio ou PDF de résumé)
  Future<DriveFileItem> uploaderFichier({
    required File fichier,
    required String nomFichier,
    required String mimeType,
    String? dossierId,
    Function(double progression)? onProgression,
  }) async {
    _verifierInitialisation();

    final fileLength = await fichier.length();
    final stream = fichier.openRead();
    final media = drive.Media(stream, fileLength);

    final driveFile = drive.File()
      ..name = nomFichier
      ..description = "Archive culte EECC générée par Régie Studio";

    if (dossierId != null) {
      driveFile.parents = [dossierId];
    }

    _uploadProgress = 0.0;
    notifyListeners();

    final uploaded = await _driveApi1!.files.create(
      driveFile,
      uploadMedia: media,
      $fields: 'id, name, mimeType, size, webViewLink, thumbnailLink, modifiedTime',
    );

    _uploadProgress = 1.0;
    if (onProgression != null) onProgression(1.0);
    notifyListeners();

    return DriveFileItem.fromGoogleFile(uploaded);
  }

  /// Recherche avancée de fichiers dans Google Drive
  Future<List<DriveFileItem>> rechercherFichiers({
    String? termeRecherche,
    String? dossierId,
    String? typeMime,
    int maxResultats = 30,
  }) async {
    _verifierInitialisation();

    List<String> conditions = ["trashed = false"];

    if (termeRecherche != null && termeRecherche.trim().isNotEmpty) {
      conditions.add("name contains '${termeRecherche.replaceAll("'", "\\'")}'");
    }

    if (dossierId != null) {
      conditions.add("'$dossierId' in parents");
    }

    if (typeMime != null) {
      conditions.add("mimeType = '$typeMime'");
    }

    final q = conditions.join(" and ");

    final response = await _driveApi1!.files.list(
      q: q,
      pageSize: maxResultats,
      orderBy: 'modifiedTime desc',
      $fields: 'files(id, name, mimeType, size, webViewLink, thumbnailLink, modifiedTime)',
    );

    return (response.files ?? []).map((f) => DriveFileItem.fromGoogleFile(f)).toList();
  }

  /// Récupère l'espace de stockage consommé et total
  Future<Map<String, dynamic>> obtenirEspaceDisque() async {
    _verifierInitialisation();

    final about = await _driveApi1!.about.get($fields: 'storageQuota, user');
    final quota = about.storageQuota;

    final used = int.tryParse(quota?.usage ?? '0') ?? 0;
    final total = int.tryParse(quota?.limit ?? '0') ?? 0;

    return {
      'usedBytes': used,
      'totalBytes': total,
      'user': about.user?.emailAddress ?? 'Inconnu',
      'usedGo': (used / (1024 * 1024 * 1024)).toStringAsFixed(2),
      'totalGo': total > 0 ? (total / (1024 * 1024 * 1024)).toStringAsFixed(2) : 'Illimité',
    };
  }

  void _verifierInitialisation() {
    if (_driveApi1 == null) {
      throw StateError(
        'Google Drive n\'est pas encore authentifié. Appelez d\'abord initialiser() ou authentifierDrive1().',
      );
    }
  }
}
