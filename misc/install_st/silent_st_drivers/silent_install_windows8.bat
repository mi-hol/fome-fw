rem @echo off

rem ~dp0 refers to the full path to the batch file's directory (static)
rem ~dpnx0 and ~f0 both refer to the full path to the batch directory and file name (static).

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    echo Requesting administrative privileges...
    powershell.exe -noprofile -c Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
    exit /b
)

:gotAdmin
	net file 1>NUL 2>NUL
	if not '%errorlevel%' == '0' (goto ErrorAdmin)
    echo Got administrative privileges..
	:: Change directory with passed argument. Processes started with
	:: "runas" start with forced C:\Windows\System32 workdir
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

cd "Virtual comport driver"
cd Win8

echo Current directory is: %cd%
echo Installing VCP driver silently
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" goto VCP_X64
start "" dpinst_x86.exe /s
if not '%errorlevel%' == '0' (goto ErrorInstall)
goto VCP_END
:VCP_X64
start "" dpinst_amd64.exe /s
:VCP_END

cd ../..
echo Done installing VCP silently
echo Current directory is: %cd%

echo Installing ST-Link driver silently
cd ST-LINK_USB_V2_1_Driver

@echo off
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" goto ST_X64
start "" dpinst_x86.exe /sw
goto ST_END
:ST_X64
start "" dpinst_amd64.exe /sw
:ST_END

cd ..
echo Done installing ST-Link silently


cd DFU_Driver
echo "Installing stm32bootloader driver"
install_elevated_STM32Bootloader.bat
cd ..

exit

:ErrorAdmin
echo Error: Failed to get administrative privileges..
exit
:ErrorInstall
echo Error: Failed to install driver..
exit