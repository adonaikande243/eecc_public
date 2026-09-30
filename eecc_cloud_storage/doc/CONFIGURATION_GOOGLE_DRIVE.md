# GUIDE OFFICIEL DE CONFIGURATION GOOGLE DRIVE (TYPE BUREAU)
## Écosystème EECC — Stockage et Archivage des Cultes

Ce document détaille la configuration exacte de votre projet Google Cloud pour garantir un fonctionnement sans aucune erreur ni blocage d'autorisation.

---

### 1. VOS COMPTES CONFIGURÉS DANS L'APPLICATION

Les identifiants déclarés dans le projet Google Cloud Console sont configurés pour les deux comptes :

* **Google Drive 1 (Principal - Compte Culte)** :
  * **Type** : Bureau (Installed Application)
  * **Nom du projet** : `eecc-drive-1`
  * **Compte** : Actif et relié à la régie pour l'archivage principal des cultes.

* **Google Drive 2 (Secours / Quota supplémentaire)** :
  * **Type** : Bureau (Installed Application)
  * **Nom du projet** : `eecc-drive-2`
  * **Compte** : Actif en relai automatique si le quota du premier est atteint.

> ℹ️ Les clés complètes sont centralisées de manière sécurisée dans `eecc_api_config.dart`.

---

### 2. ÉTAPE INDISPENSABLE SUR GOOGLE CLOUD CONSOLE

Pour que Google accepte la connexion depuis l'ordinateur de régie sans afficher d'erreur **« Accès bloqué : application non vérifiée »**, effectuez ces 3 vérifications simples :

#### A. Activer les APIs dans la Bibliothèque
Rendez-vous sur [Google Cloud Console - Bibliothèque d'API](https://console.cloud.google.com/apis/library) :
1. Recherchez **Google Drive API** et cliquez sur **Activer**.
2. Recherchez **YouTube Data API v3** et cliquez sur **Activer** (utilisée pour les flux direct YouTube avec les mêmes identifiants).

#### B. Configurer l'Écran de consentement OAuth
Allez dans **APIs & Services** > **Écran de consentement OAuth** :
1. **Type d'utilisateur** : Sélectionnez **Externe** (ou Interne si vous utilisez Google Workspace d'église).
2. **Nom de l'application** : `EECC Régie Studio`
3. **E-mail d'assistance utilisateur** : Votre adresse Gmail.
4. **Champs d'application (Scopes)** :
   Ajoutez :
   - `https://www.googleapis.com/auth/drive.file` *(Permet à la régie de créer, téléverser et gérer les vidéos des cultes)*
   - `https://www.googleapis.com/auth/drive.metadata.readonly` *(Permet de vérifier les dossiers et l'espace restant)*
   - `https://www.googleapis.com/auth/youtube` *(Optionnel, pour YouTube Live)*

#### C. CRITIQUE : Ajouter les Utilisateurs Tests (Test Users)
Tant que l'application est en état de publication **« En cours de test »** (Testing) :
1. Dans l'onglet **Utilisateurs tests**, cliquez sur **+ ADD USERS**.
2. **Ajoutez l'adresse Gmail du compte qui sera connecté sur l'ordinateur de régie**.
3. Cliquez sur **Enregistrer**.

> ⚠️ **IMPORTANT** : Si cette adresse n'est pas ajoutée en tant qu'utilisateur test, Google refusera la connexion avec l'erreur `Error 403: access_denied`.

---

### 3. COMMENT SE PASSE LA CONNEXION SUR LE PC DE RÉGIE ?

1. Lors du premier lancement ou du premier archivage de culte sur `eecc_regie_studio`, le logiciel ouvre automatiquement une fenêtre de navigateur Chrome/Edge avec la page de connexion Google officielle.
2. Vous vous connectez avec votre compte Gmail d'église.
3. Google affiche : *« EECC Régie Studio souhaite accéder à vos fichiers Google Drive »*. Cliquez sur **Continuer**.
4. Le jeton d'accès sécurisé (**OAuth Refresh Token**) est automatiquement capturé et stocké localement de manière chiffrée via `FlutterSecureStorage`.
5. **Vous n'avez plus jamais besoin de vous reconnecter** : les renouvellements de jeton se font de manière transparente et silencieuse en arrière-plan à chaque culte.

---

### 4. ORGANISATION DES DOSSIERS CRÉÉS SUR GOOGLE DRIVE

Le service crée automatiquement la structure suivante sur votre compte Google Drive :

```
Google Drive/
└── EECC_Cultes_2026/
    ├── Culte_Dimanche_2026-03-29.mp4
    ├── Culte_Dimanche_2026-03-29.mp3
    └── Culte_Dimanche_2026-03-29_Resume.txt
```

Chaque fichier téléversé génère un `videoDriveId` et un lien web direct qui est immédiatement indexé dans la table Supabase `eecc_archives` pour que les fidèles et les pasteurs puissent le visionner depuis leurs applications mobiles.
