@echo off
title Solveur de Cholesky - Java Swing (ESISA 3A)
cd /d "%~dp0"
echo Compilation Java...
javac -encoding UTF-8 -d bin Examples.java
echo Lancement de l'application...
java -cp bin esisa.cholesky.Examples
pause
