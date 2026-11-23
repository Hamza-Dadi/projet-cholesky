@echo off
title Solveur Cholesky Java Swing - ESISA 3A
cd /d "%~dp03_Application_Java"
echo [1/2] Verification et compilation Java...
javac -encoding UTF-8 -d bin Examples.java
echo [2/2] Lancement de l'application...
java -cp bin esisa.cholesky.Examples
pause
