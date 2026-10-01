@echo off
cd /d "%~dp0"

echo ============================================================================ > git_log.txt
echo SYNCHRONISATION EECC VERS GITHUB >> git_log.txt
echo Date: %date% %time% >> git_log.txt
echo ============================================================================ >> git_log.txt

echo [1/3] Indexation des dossiers d'assets et correctifs workflows...
git add -A >> git_log.txt 2>&1
git commit -m "Correctif assets pubspec et creation des dossiers requis pour GitHub Actions" >> git_log.txt 2>&1

echo [2/3] Verification de la branche et du remote...
git branch -M main >> git_log.txt 2>&1
git remote remove origin >> git_log.txt 2>&1
git remote add origin https://github.com/adonaikande243/eecc_public.git >> git_log.txt 2>&1

echo.
echo ============================================================================
echo [3/3] ENVOI DU CODE VERS GITHUB (git push)...
echo ============================================================================
echo.

git push -u origin main >> git_log.txt 2>&1

echo.
echo ============================================================================
echo RAPPORT DU TERMINAL :
echo ============================================================================
type git_log.txt
echo ============================================================================
echo.

echo Suivez l'avancement des compilations automatiques en direct sur :
echo https://github.com/adonaikande243/eecc_public/actions
echo.
pause
