@echo off
title EECC - Synchronisation GitHub
color 0B

:: 1. Se positionner dans le dossier du script
cd /d "%~dp0"

echo ============================================================================
echo               SYNCHRONISATION EECC VERS GITHUB
echo ============================================================================
echo Dossier local  : %CD%
echo Depot distant  : https://github.com/adonaikande243/eecc_public.git
echo ============================================================================
echo.

:: 2. Verification de Git
echo [1/5] Verification de l'installation de Git...
where git >nul 2>&1
if errorlevel 1 (
    color 0C
    echo.
    echo [ERREUR CRITIQUE] Git n'a pas ete detecte sur cet ordinateur.
    echo Veuillez installer Git depuis : https://git-scm.com/
    echo.
    goto FIN
)
echo [OK] Git est installe.
echo.

:: 3. Creation des dossiers d'assets requis pour eviter les erreurs de build
echo [2/5] Verification des dossiers d'assets requis...
if not exist "eecc_regie_studio\assets\overlays" mkdir "eecc_regie_studio\assets\overlays" >nul 2>&1
if not exist "eecc_regie_studio\assets\sounds" mkdir "eecc_regie_studio\assets\sounds" >nul 2>&1
if not exist "eecc_regie_studio\assets\logos" mkdir "eecc_regie_studio\assets\logos" >nul 2>&1
if not exist "eecc_cloud_storage\assets\credentials" mkdir "eecc_cloud_storage\assets\credentials" >nul 2>&1
echo [OK] Arborescence des assets validee.
echo.

:: 4. Indexation de tous les fichiers
echo [3/5] Indexation des fichiers modifies (git add -A)...
git add -A
echo [OK] Tous les fichiers ont ete indexes.
echo.

:: 5. Commit des modifications
echo [4/5] Enregistrement du commit...
git commit -m "Integration complete de toutes les maquettes PNG (5 apps) et programme d'installation autonome des 2 logiciels Windows"
if errorlevel 1 (
    echo [INFO] Aucun changement supplementaire a enregistrer.
)
echo.

:: 6. Configuration du depot distant et Envoi
echo [5/5] Envoi vers GitHub (git push)...
git branch -M main
git remote remove origin >nul 2>&1
git remote add origin https://github.com/adonaikande243/eecc_public.git

echo Envoi en cours vers la branche main...
git push -u origin main --force
if errorlevel 1 (
    echo.
    echo [AVERTISSEMENT] Nouvelle tentative avec git push standard...
    git push -u origin main
)

echo.
color 0A
echo ============================================================================
echo                         SYNCHRONISATION TERMINEE
echo ============================================================================
echo Vos 5 applications sont maintenant a jour sur GitHub :
echo https://github.com/adonaikande243/eecc_public
echo.
echo Suivez la compilation automatique des APKs et executables ici :
echo https://github.com/adonaikande243/eecc_public/actions
echo ============================================================================
echo.

:FIN
echo Cette fenetre restera ouverte pour vous permettre de lire les resultats.
echo Appuyez sur une touche pour la fermer.
pause >nul
