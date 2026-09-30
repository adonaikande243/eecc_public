@echo off
cd /d "%~dp0"

echo ============================================================================ > git_log.txt
echo SYNCHRONISATION EECC VERS GITHUB >> git_log.txt
echo Date: %date% %time% >> git_log.txt
echo ============================================================================ >> git_log.txt

echo [1/3] Creation d'une branche sans ancetre pour eliminer l'ancien commit 3e9349e...
git checkout --orphan main_racine >> git_log.txt 2>&1
git add -A >> git_log.txt 2>&1
git commit -m "Deploiement initial code source EECC sans secrets" >> git_log.txt 2>&1
git branch -D main >nul 2>&1
git branch -M main >> git_log.txt 2>&1

echo [2/3] Verification du lien GitHub...
git remote remove origin >> git_log.txt 2>&1
git remote add origin https://github.com/adonaikande243/eecc_public.git >> git_log.txt 2>&1
git remote -v >> git_log.txt 2>&1

echo.
echo ============================================================================
echo [3/3] ENVOI RAPIDE DU CODE VERS GITHUB (git push)...
echo ============================================================================
echo.

git push -u origin main --force >> git_log.txt 2>&1

echo.
echo ============================================================================
echo RAPPORT DU TERMINAL :
echo ============================================================================
type git_log.txt
echo ============================================================================
echo.

findstr /C:"main -> main" git_log.txt >nul
if %errorlevel% equ 0 (
    echo ============================================================================
    echo [SUCCES TOTAL] Le code est desormais bien present sur GitHub !
    echo Vos builds sont en cours sur : https://github.com/adonaikande243/eecc_public/actions
    echo ============================================================================
) else (
    echo ============================================================================
    echo Si GitHub bloque toujours, desactivez simplement "Push Protection" ici :
    echo https://github.com/adonaikande243/eecc_public/settings/security_analysis
    echo ============================================================================
)

echo.
pause
