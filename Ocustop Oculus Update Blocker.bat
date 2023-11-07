@echo off

net session >nul 2>&1
    if %errorLevel% == 0 (
    FOR /F "usebackq tokens=3*" %%A IN (`REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Oculus VR, LLC\Oculus" /v Base`) DO (
		set mypath=%%A %%BSupport\
    )
    ) else (
        goto noadmin
    )

echo.%mypath%| FIND /I "Oculus">Nul && ( 
		goto menu
	) || (
		goto wrongdir
	)

:menu
echo Ocustop Update Blocker v2
echo =========================
echo.
echo 1) Block Oculus Updates
echo 2) Allow Oculus Updates
echo 3) Exit
echo.
set /p op=Choose Action:
if "%op%"=="1" goto add
if "%op%"=="2" goto remove
if "%op%"=="3" goto exit
echo.
echo Incorrect Option
echo.
goto menu

:add
echo =========================
echo.
echo Blocking Oculus Updates
echo.
if exist "%cd%\hostsbackup\hosts" (
	echo FAILURE
    echo Oculus Updates Already Blocked
	echo Press any key to exit
	pause >nul
	goto exit
) else (
	echo Creating Backup of Hosts File
    xcopy /D /I "%windir%\System32\drivers\etc\hosts" "%cd%\hostsbackup\" > nul
	echo Backup Created in %cd%\hostsbackup\
	echo 127.0.0.1 graph.oculus.com >> "%windir%\System32\drivers\etc\hosts"
rem	echo 127.0.0.1 edge-mqtt.facebook.com >> "%windir%\System32\drivers\etc\hosts"
rem	echo 127.0.0.1 scontent.oculuscdn.com >> "%windir%\System32\drivers\etc\hosts"
rem	echo 127.0.0.1 securecdn.oculus.com >> "%windir%\System32\drivers\etc\hosts"
rem	echo 127.0.0.1 graph.facebook.com >> "%windir%\System32\drivers\etc\hosts"
	echo.
	echo SUCCESS
	echo Oculus Updates Blocked
	echo Press any key to exit
	pause >nul
	goto exit
)

:remove
echo =========================
echo.
echo Enabling Oculus Updates
echo.
if exist "%cd%\hostsbackup\hosts" (
    echo Restoring Hostfile
	copy "%cd%\hostsbackup" "%windir%\System32\drivers\etc\hosts" /y > nul
	echo Hostfile Restored from %cd%\hostsbackup\
	echo.
	echo Removing Backup
	del "%cd%\hostsbackup\hosts"
	echo Backup Removed from %cd%\hostsbackup\
	echo.
	echo SUCCESS	
	echo Oculus Updates Enabled
	echo Press any key to exit
	pause >nul
	goto exit
) else (
	echo FAILURE
	echo No backup found or Oculus Updates already Enabled
	echo Press any key to exit
	pause >nul
	goto exit
)

:noadmin
echo.
echo FAILURE
echo You must run this file as 'Administrator'
echo Press any key to exit
pause >nul
goto exit

:wrongdir
echo.
echo FAILURE
echo Error locating Oculus Install
echo Press any key to exit
pause >nul
goto exit

:exit
@exit
