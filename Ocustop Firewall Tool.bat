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
echo Ocustop Firewall Tool v1
echo ========================
echo.
echo 1) Add Firewall Rules
echo 2) Remove Firewall Rules
echo 3) Exit
echo.
set /p op=Choose Action:
if "%op%"=="1" goto add
if "%op%"=="2" goto remove
if "%op%"=="3" goto exit

goto begin

:add
echo Adding Firewall Rules
echo.
for %%G in ("%mypath%oculus-librarian\OVRLibrarian.exe" "%mypath%oculus-librarian\OVRLibraryService.exe" "%mypath%oculus-runtime\OVRRedir.exe" "%mypath%oculus-runtime\OVRServer_x64.exe" "%mypath%oculus-runtime\OVRServiceLauncher.exe" "%mypath%oculus-redistributable-installer\OVRRedistributableInstaller.exe") do (

echo Creating Rule %%G Inbound
netsh advfirewall firewall add rule name=""%%G"" program=""%%G"" dir=in enable=yes action=block profile=any
echo Creating Rule %%G Outbound
netsh advfirewall firewall add rule name=""%%G"" program=""%%G"" dir=out enable=yes action=block profile=any
)
echo.
echo Firewall Rules Added press any key to exit
pause >nul
goto exit

:remove
echo Removing Firewall Rules
echo.
for %%G in ("%mypath%oculus-librarian\OVRLibrarian.exe" "%mypath%oculus-librarian\OVRLibraryService.exe" "%mypath%oculus-runtime\OVRRedir.exe" "%mypath%oculus-runtime\OVRServer_x64.exe" "%mypath%oculus-runtime\OVRServiceLauncher.exe" "%mypath%oculus-redistributable-installer\OVRRedistributableInstaller.exe") do (

echo Removing Rule %%G Inbound
netsh advfirewall firewall delete rule name=""%%G"" dir=in
echo Removing Rule %%G Outbound
netsh advfirewall firewall delete rule name=""%%G"" dir=out
)
echo. 
echo Firewall Rules Removed press any key to exit
pause >nul
goto exit

:noadmin
echo.
echo You must run this file as 'Administrator'
echo Press any key to exit
pause >nul
goto exit

:wrongdir
echo.
echo Error locating Oculus Install
echo Press any key to exit
pause >nul
goto exit

:exit
@exit
