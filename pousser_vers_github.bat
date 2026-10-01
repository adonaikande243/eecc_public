@echo off
title EECC - Synchronisation GitHub
color 0A

:: Se positionner de maniere certaine dans le dossier du script
cd /d "%~dp0"

echo ============================================================================
echo               SYNCHRONISATION EECC VERS GITHUB
echo ============================================================================
echo Dossier de travail : %CD%
echo Depot cible        : https://github.com/adonaikande243/eecc_public.git
echo ============================================================================
echo.

:: 1. Verification de Git
where git >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [ERREUR CRITIQUE] Git n'est pas detecte sur cet ordinateur.
    echo Veuillez installer Git depuis : https://git-scm.com/
    goto FIN
)

:: 2. Indexation de tous les fichiers
echo [1/4] Indexation de tous les fichiers (Public, Pasteur, Admin, Comite, Regie)...
git add -A
echo Indexation terminee.
echo.

:: 3. Creation du Commit
echo [2/4] Enregistrement du commit de mise a jour...
git commit -m "Refonte complete visuelle conforme aux maquettes PNG"
echo.

:: 4. Configuration de la branche et du remote GitHub
echo [3/4] Configuration du depot distant...
git branch -M main
git remote remove origin >nul 2>&1
git remote add origin https://github.com/adonaikande243/eecc_public.git
echo Remote origin configure sur https://github.com/adonaikande243/eecc_public.git
echo.

:: 5. Envoi vers GitHub
echo [4/4] Envoi des fichiers vers GitHub (git push)...
echo Veuillez patienter pendant l'envoi...
echo.
git push -u origin main --force
if errorlevel 1 (
    echo.
    echo [AVIS] Tentative secondaire de push standard...
    git push -u origin main
)

echo.
echo ============================================================================
echo                         SYNCHRONISATION TERMINEE
echo ============================================================================
echo Suivez la compilation de vos APKs et du logiciel Studio ici :
echo https://github.com/adonaikande243/eecc_public/actions
echo ============================================================================
echo.

:FIN
echo.
echo Cette fenetre ne se fermera pas automatiquement.
pause
