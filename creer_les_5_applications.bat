@echo off
setlocal enabledelayedexpansion
title EECC - Generation et Initialisation des 5 Applications
color 0B

:: 1. Se positionner dans le dossier racine du projet
cd /d "%~dp0"

echo ============================================================================
echo         EECC SUITE COMPLETE - GENERATION DES 5 APPLICATIONS
echo ============================================================================
echo Dossier racine : %CD%
echo.
echo Cette procedure va creer, configurer et initialiser les 5 projets Flutter :
echo   [1] Eecc public        (Mobile Android / iOS pour les fideles)
echo   [2] Eecc pasteur       (Mobile Android / iOS pour le corps pastoral)
echo   [3] Eecc admin         (Desktop Windows / Web pour l'administration)
echo   [4] Eecc comite        (Mobile Android / iOS pour les comites / chorales)
echo   [5] eecc_regie_studio  (Logiciel Desktop Windows pour la regie de diffusion)
echo   [*] eecc_cloud_storage (Module partage OneDrive / Google Drive / Maishapay)
echo ============================================================================
echo.

:: 2. Verification de Flutter dans l'environnement Windows
echo [VERIFICATION] Recherche du SDK Flutter...
where flutter >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [ERREUR] Flutter n'a pas ete trouve dans la variable d'environnement PATH.
    echo Veuillez installer Flutter ou ajouter son dossier 'bin' dans votre PATH Windows.
    echo Site officiel : https://docs.flutter.dev/get-started/install/windows
    echo.
    goto FIN
)

echo [OK] SDK Flutter detecte avec succes.
echo.

:: -----------------------------------------------------------------------------
:: MODULE PARTAGE : eecc_cloud_storage
:: -----------------------------------------------------------------------------
echo ============================================================================
echo [*] Initialisation du module partage : eecc_cloud_storage
echo ============================================================================
if not exist "eecc_cloud_storage\assets\credentials" (
    mkdir "eecc_cloud_storage\assets\credentials" >nul 2>&1
)
cd /d "%~dp0eecc_cloud_storage"
echo Resolution des dependances pour eecc_cloud_storage...
call flutter pub get
if errorlevel 1 (
    echo [AVERTISSEMENT] flutter pub get a rencontre un avertissement pour eecc_cloud_storage.
)
cd /d "%~dp0"
echo.

:: -----------------------------------------------------------------------------
:: APPLICATION 1 : Eecc public
:: -----------------------------------------------------------------------------
echo ============================================================================
echo [1/5] Creation et initialisation : Eecc public (Mobile)
echo ============================================================================
cd /d "%~dp0Eecc public"
if not exist "android" (
    echo Generation des composants Android et iOS pour Eecc public...
    call flutter create . --platforms=android,ios --project-name=eecc_public
)
echo Telechargement des packages pour Eecc public...
call flutter pub get
cd /d "%~dp0"
echo.

:: -----------------------------------------------------------------------------
:: APPLICATION 2 : Eecc pasteur
:: -----------------------------------------------------------------------------
echo ============================================================================
echo [2/5] Creation et initialisation : Eecc pasteur (Mobile)
echo ============================================================================
cd /d "%~dp0Eecc pasteur"
if not exist "android" (
    echo Generation des composants Android et iOS pour Eecc pasteur...
    call flutter create . --platforms=android,ios --project-name=eecc_pasteur
)
echo Telechargement des packages pour Eecc pasteur...
call flutter pub get
cd /d "%~dp0"
echo.

:: -----------------------------------------------------------------------------
:: APPLICATION 3 : Eecc admin
:: -----------------------------------------------------------------------------
echo ============================================================================
echo [3/5] Creation et initialisation : Eecc admin (Desktop / Web)
echo ============================================================================
cd /d "%~dp0Eecc admin"
if not exist "windows" (
    echo Generation des composants Windows et Web pour Eecc admin...
    call flutter create . --platforms=windows,web --project-name=eecc_admin
)
echo Telechargement des packages pour Eecc admin...
call flutter pub get
cd /d "%~dp0"
echo.

:: -----------------------------------------------------------------------------
:: APPLICATION 4 : Eecc comite
:: -----------------------------------------------------------------------------
echo ============================================================================
echo [4/5] Creation et initialisation : Eecc comite (Mobile)
echo ============================================================================
cd /d "%~dp0Eecc comit" 2>nul || cd /d "%~dp0Eecc comit*"
if not exist "android" (
    echo Generation des composants Android et iOS pour Eecc comite...
    call flutter create . --platforms=android,ios --project-name=eecc_comite
)
echo Telechargement des packages pour Eecc comite...
call flutter pub get
cd /d "%~dp0"
echo.

:: -----------------------------------------------------------------------------
:: APPLICATION 5 : eecc_regie_studio
:: -----------------------------------------------------------------------------
echo ============================================================================
echo [5/5] Creation et initialisation : eecc_regie_studio (Desktop)
echo ============================================================================
if not exist "eecc_regie_studio\assets\overlays" mkdir "eecc_regie_studio\assets\overlays" >nul 2>&1
if not exist "eecc_regie_studio\assets\sounds" mkdir "eecc_regie_studio\assets\sounds" >nul 2>&1
if not exist "eecc_regie_studio\assets\logos" mkdir "eecc_regie_studio\assets\logos" >nul 2>&1

cd /d "%~dp0eecc_regie_studio"
if not exist "windows" (
    echo Generation des composants Windows pour eecc_regie_studio...
    call flutter create . --platforms=windows --project-name=eecc_regie_studio
)
echo Telechargement des packages pour eecc_regie_studio...
call flutter pub get
cd /d "%~dp0"
echo.

:: -----------------------------------------------------------------------------
:: RECAPITULATIF FINAL
:: -----------------------------------------------------------------------------
color 0A
echo ============================================================================
echo                   INITIALISATION REUSSIE AVEC SUCCES !
echo ============================================================================
echo Les 5 applications sont creees et pretes a l'emploi :
echo.
echo   1. Eecc public        -> Pour lancer : cd "Eecc public" ^&^& flutter run
echo   2. Eecc pasteur       -> Pour lancer : cd "Eecc pasteur" ^&^& flutter run
echo   3. Eecc admin         -> Pour lancer : cd "Eecc admin" ^&^& flutter run -d windows
echo   4. Eecc comite        -> Pour lancer : cd "Eecc comit*" ^&^& flutter run
echo   5. eecc_regie_studio  -> Pour lancer : cd "eecc_regie_studio" ^&^& flutter run -d windows
echo.
echo Pour synchroniser toutes vos modifications vers GitHub :
echo   Double-cliquez sur : pousser_vers_github.bat
echo ============================================================================
echo.

:FIN
echo Cette fenetre restera ouverte pour vous permettre de lire les resultats.
echo Appuyez sur une touche pour la fermer.
pause >nul
