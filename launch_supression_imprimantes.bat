REM Lanceur du script supression_imprimante: autorise l'execution de code powershell puis lance le script. 
@echo off
setlocal
cd /d %~dp0
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe -command (set-executionpolicy -scope LocalMachine -executionPolicy ByPass -force)
%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe  ./supression_imprimantes.ps1 

set /p id="Appuyez sur la touche Entree <3 ..."
