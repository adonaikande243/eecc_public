# EECC Cloud Storage

Application Flutter permettant l'upload et la gestion des archives de cultes de l'EECC (Église Évangélique du Cameroun au Canada) sur de multiples plateformes de stockage Cloud simultanément (Google Drive, OneDrive).

## 🚀 Prérequis
- Flutter SDK (>=3.19.0)
- Un compte Google Cloud Console (pour Google Drive API)
- Un ou plusieurs comptes Microsoft Azure Portal (pour Microsoft Graph API / OneDrive)

## 🔑 Configuration des Services

### 1. Google Drive Service Account (Phase 1)
1. Allez sur Google Cloud Console
2. Créez un projet et activez "Google Drive API"
3. Créez des identifiants : "Compte de service"
4. Créez une clé au format JSON
5. Renommez le fichier en `service_account.json` et placez-le dans `assets/credentials/`
6. Partagez le dossier Google Drive cible avec l'email du compte de service.

### 2. Google Drive OAuth2 (Phase 2)
1. Sur le même projet Google Cloud, configurez l'écran de consentement OAuth
2. Créez des identifiants "ID client OAuth" (pour Android, iOS ou Web)
3. Ajoutez les certificats SHA-1 pour Android.

### 3. Microsoft OneDrive (Phase 3 & 4)
1. Allez sur Azure Portal (portal.azure.com)
2. Dans "Microsoft Entra ID" > "App registrations", créez une nouvelle application
3. Supported account types : "Accounts in any organizational directory and personal Microsoft accounts"
4. Configurez la "Redirect URI" : `msauth://com.eecc.cloud_storage/callback` (Mobile)
5. Dans "API permissions", ajoutez Microsoft Graph -> `Files.ReadWrite.All`, `Files.ReadWrite`, `offline_access`.

### 4. Remplacer les variables de configuration
Modifiez le fichier `lib/core/config/app_config.dart` avec vos IDs.

## 🛠️ Architecture
- **Phase 1 :** Google Drive Service Account (Upload B2B transparent)
- **Phase 2 :** Google Drive OAuth2 (Upload utilisateur)
- **Phase 3 :** Microsoft OneDrive Compte 1 (Upload standard < 4MB & Resumable)
- **Phase 4 :** Microsoft OneDrive Compte 2 (Upload resumable avec retry et reprise après coupure)

## ▶️ Lancement du projet
```bash
flutter pub get
flutter run
```
