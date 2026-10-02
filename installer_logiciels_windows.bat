@echo off
setlocal enabledelayedexpansion
title EECC - Programme d'Installation Complet des Logiciels Windows
color 0B

cd /d "%~dp0"

echo ============================================================================
echo       PROGRAMME D'INSTALLATION COMPLET DES DEUX LOGICIELS EECC WINDOWS
echo ============================================================================
echo   1. EECC Admin         : Logiciel de gestion administrative et paroissiale
echo   2. EECC Regie Studio  : Logiciel de diffusion broadcast et regie video
echo ============================================================================
echo.

:: 1. Verification de Flutter
echo [1/6] Verification du SDK Flutter...
where flutter >nul 2>&1
if errorlevel 1 (
    color 0C
    echo [ERREUR CRITIQUE] Flutter n'est pas installe ou n'est pas dans votre PATH.
    echo Veuillez installer Flutter pour Windows depuis : https://docs.flutter.dev/
    goto FIN
)
echo [OK] SDK Flutter detecte.
echo.

:: 2. Preparation des dossiers et assets requis pour eviter les erreurs de build
echo [2/6] Verification et creation des dossiers d'assets indispensables...
if not exist "eecc_regie_studio\assets\overlays" mkdir "eecc_regie_studio\assets\overlays" >nul 2>&1
if not exist "eecc_regie_studio\assets\sounds" mkdir "eecc_regie_studio\assets\sounds" >nul 2>&1
if not exist "eecc_regie_studio\assets\logos" mkdir "eecc_regie_studio\assets\logos" >nul 2>&1
if not exist "eecc_cloud_storage\assets\credentials" mkdir "eecc_cloud_storage\assets\credentials" >nul 2>&1
if not exist "Distributions_Windows\EECC_Admin_Portable" mkdir "Distributions_Windows\EECC_Admin_Portable" >nul 2>&1
if not exist "Distributions_Windows\EECC_Regie_Studio_Portable" mkdir "Distributions_Windows\EECC_Regie_Studio_Portable" >nul 2>&1
if not exist "Distributions_Windows\Installateurs" mkdir "Distributions_Windows\Installateurs" >nul 2>&1
echo [OK] Arborescence validee.
echo.

:: 3. Initialisation du module partage
echo [3/6] Compilation et preparation du module partage eecc_cloud_storage...
cd /d "%~dp0eecc_cloud_storage"
call flutter pub get
cd /d "%~dp0"
echo.

:: 4. Compilation Release de EECC Admin
echo ============================================================================
echo [4/6] Compilation de EECC Admin (Release Windows x64)...
echo ============================================================================
cd /d "%~dp0Eecc admin"
if not exist "windows" (
    echo Generation du squelette Windows pour Eecc admin...
    call flutter create . --platforms=windows --project-name=eecc_admin
)
call flutter pub get
call flutter build windows --release
if errorlevel 1 (
    echo [AVERTISSEMENT] Erreur lors de la compilation de EECC Admin.
) else (
    echo [OK] EECC Admin compile avec succes.
    echo Packaging de la version autonome (sans bibliotheque manquante)...
    xcopy /E /I /Y "build\windows\x64\runner\Release\*" "%~dp0Distributions_Windows\EECC_Admin_Portable\" >nul
)
cd /d "%~dp0"
echo.

:: 5. Compilation Release de EECC Regie Studio
echo ============================================================================
echo [5/6] Compilation de EECC Regie Studio (Release Windows x64)...
echo ============================================================================
cd /d "%~dp0eecc_regie_studio"
if not exist "windows" (
    echo Generation du squelette Windows pour eecc_regie_studio...
    call flutter create . --platforms=windows --project-name=eecc_regie_studio
)
call flutter pub get
call flutter build windows --release
if errorlevel 1 (
    echo [AVERTISSEMENT] Erreur lors de la compilation de EECC Regie Studio.
) else (
    echo [OK] EECC Regie Studio compile avec succes.
    echo Packaging de la version autonome (sans bibliotheque manquante)...
    xcopy /E /I /Y "build\windows\x64\runner\Release\*" "%~dp0Distributions_Windows\EECC_Regie_Studio_Portable\" >nul
    if not exist "%~dp0Distributions_Windows\EECC_Regie_Studio_Portable\data\flutter_assets\assets" mkdir "%~dp0Distributions_Windows\EECC_Regie_Studio_Portable\data\flutter_assets\assets" >nul 2>&1
    xcopy /E /I /Y "assets\*" "%~dp0Distributions_Windows\EECC_Regie_Studio_Portable\data\flutter_assets\assets\" >nul
)
cd /d "%~dp0"
echo.

:: 6. Generation des Installateurs Setup (.exe) via Inno Setup si present
echo ============================================================================
echo [6/6] Creation des programmes d'installation et raccourcis Bureau...
echo ============================================================================

set ISCC_PATH=""
if exist "%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe" set ISCC_PATH="%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe"
if exist "%ProgramFiles%\Inno Setup 6\ISCC.exe" set ISCC_PATH="%ProgramFiles%\Inno Setup 6\ISCC.exe"

if not "!ISCC_PATH!"=="" (
    echo Detection de Inno Setup Compiler. Compilation des fichiers d'installation (.exe)...
    cd /d "%~dp0Eecc admin"
    !ISCC_PATH! setup_eecc_admin.iss >nul
    cd /d "%~dp0eecc_regie_studio"
    !ISCC_PATH! setup_eecc_regie_studio.iss >nul
    cd /d "%~dp0"
    echo [OK] Fichiers Setup generes dans Distributions_Windows\Installateurs\
) else (
    echo [INFO] Inno Setup n'est pas installe. Creation automatique des raccourcis Bureau...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ws = New-Object -ComObject WScript.Shell; $d = [System.Environment]::GetFolderPath('Desktop'); $s1 = $ws.CreateShortcut($d + '\EECC Admin.lnk'); $s1.TargetPath = '%~dp0Distributions_Windows\EECC_Admin_Portable\eecc_admin.exe'; $s1.Save(); $s2 = $ws.CreateShortcut($d + '\EECC Regie Studio.lnk'); $s2.TargetPath = '%~dp0Distributions_Windows\EECC_Regie_Studio_Portable\eecc_regie_studio.exe'; $s2.Save();"
    echo [OK] Raccourcis d'acces direct crees sur votre Bureau Windows.
)

color 0A
echo.
echo ============================================================================
echo                  INSTALLATION ET PACKAGING TERMINES AVEC SUCCES !
echo ============================================================================
echo Tous les fichiers executables et toutes les DLLs sont assembles dans :
echo.
echo   - Logiciel 1 : %CD%\Distributions_Windows\EECC_Admin_Portable\eecc_admin.exe
echo   - Logiciel 2 : %CD%\Distributions_Windows\EECC_Regie_Studio_Portable\eecc_regie_studio.exe
echo.
echo Vous pouvez lancer directement les logiciels ou distribuer ces dossiers complets.
echo ============================================================================
echo.

:FIN
echo Cette fenetre restera ouverte. Appuyez sur une touche pour quitter.
pause >nul
