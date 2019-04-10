@Echo off
title Spotlight Image Converter v2
cls

:checkPrivileges
:: Check for Admin by accessing protected stuff. This calls net(#).exe and can stall if we don't kill it later.
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto menu) else ( goto getPrivileges ) 

:getPrivileges
:: Write vbs in temp to call batch as admin.
if '%1'=='ELEV' (shift & goto menu)                               
for /f "delims=: tokens=*" %%A in ('findstr /b ::- "%~f0"') do @Echo(%%A
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
Echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
Echo UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
"%temp%\OEgetPrivileges.vbs" 
exit /B

:menu
Echo Windows 10 Lock screen image converter
Echo.
Echo Brought to you by Solaris17 of TPU
Echo.
Echo This will make a folder on your desktop called "Spotlight"
Echo.
Echo It will copy the lockscreen images to the folder then convert them to JPEG format.
Echo.
Echo Let me know when you are ready.
Echo.
Pause

goto copy

:copy
@echo off
CLS
Echo.
Echo Converting and copy in progress...
Echo.
mkdir "%userprofile%\Desktop\Spotlight" > nul 2>&1
mkdir "%userprofile%\Desktop\Spotlight\Converted" > nul 2>&1
timeout 5 >nul
robocopy %userprofile%\appdata\local\packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\ "%userprofile%\Desktop\Spotlight" /copyall /E > nul 2>&1
ren %userprofile%\Desktop\Spotlight\* *.jpg > nul 2>&1
move "%userprofile%\Desktop\Spotlight\*.jpg" "%userprofile%\Desktop\Spotlight\Converted" > nul 2>&1
Echo Done!!
Echo.
pause
