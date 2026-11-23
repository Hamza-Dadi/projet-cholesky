@echo off
title Deploiement GitHub - Projet Cholesky ESISA 3A
cd /d "%~dp0"
echo ======================================================================
echo   DEPLOIEMENT DU PROJET CHOLESKY SUR GITHUB (Hamza DADI)
echo ======================================================================
echo.
echo 1. Assurez-vous d'avoir cree un depot vide sur https://github.com/new
echo    (Par exemple nomme : projet-cholesky)
echo.
set /p REPO_URL="Entrez l'URL HTTPS de votre depot GitHub [ex: https://github.com/Hamza-dadi/projet-cholesky.git] : "

if "%REPO_URL%"=="" (
    echo Aucune URL saisie. Annulation.
    pause
    exit /b
)

echo.
echo [1/3] Configuration de l'origine distante (remote origin)...
git remote remove origin 2>nul
git remote add origin %REPO_URL%

echo [2/3] Verification de la branche main...
git branch -M main

echo [3/3] Envoi du projet sur GitHub (git push)...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ======================================================================
    echo   SUCCES ! Le projet a ete publie sur GitHub avec succes !
    echo ======================================================================
    echo.
    echo Pour activer l'Application Web en ligne gratuitement (GitHub Pages) :
    echo   1. Ouvrez votre depot sur GitHub
    echo   2. Allez dans Settings > Pages
    echo   3. Sous 'Build and deployment', choisissez Branch: main et /(root)
    echo   4. Cliquez sur 'Save'
    echo   Votre site sera accessible mondialement !
) else (
    echo.
    echo [!] Une erreur est survenue lors du push. Verifiez vos identifiants GitHub.
)

pause
