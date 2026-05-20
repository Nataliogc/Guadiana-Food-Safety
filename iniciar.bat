@echo off
title Servidor de Desarrollo - Guadiana Food Safety
cd /d "%~dp0"
echo ===================================================
echo   Iniciando el servidor y abriendo en el navegador
echo ===================================================
npm run dev -- --open
pause
