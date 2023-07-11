rem NOTE: Depends on ST Link and ST VCP being installed manually
set "TmpWorkDir=silent_st_drivers"
set "DirSep=\"
rem Just safer not to have the target folders at all
rmdir /S /Q "%TmpWorkDir%/ST-LINK_USB_V2_1_Driver"
rmdir /S /Q "%TmpWorkDir%/Virtual comport driver"
rmdir /S /Q "%TmpWorkDir%/DFU_Driver"

set "CheckDirName=C:\Program Files (x86)\STMicroelectronics\STM32 ST-LINK Utility\ST-LINK_USB_V2_1_Driver"
IF NOT exist "%CheckDirName%" ( goto ErrorDir )
xcopy /T /E  "%CheckDirName%" "%TmpWorkDir%%DirSep%"
dir "%TmpWorkDir%"

rem source is downloadable from https://github.com/rusefi/rusefi_external_utils/blob/master/stsw-stm32102_1_4_0.zip
set "CheckDirName=C:\Program Files (x86)\STMicroelectronics\Software\Virtual comport driver"
IF NOT exist "%CheckDirName%" ( goto ErrorDir )
xcopy /T /E  "%CheckDirName%" "%TmpWorkDir%%DirSep%"

set "CheckDirName=C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\Drivers\DFU_Driver"
IF NOT exist "%CheckDirName%" ( goto ErrorDir )
xcopy /T /E  "%CheckDirName%" "%TmpWorkDir%%DirSep%"

set "CheckFileName=install_elevated_STM32Bootloader.bat"
IF NOT exist "%CheckFileName%" ( goto ErrorFile )
copy "%CheckFileName%" "%TmpWorkDir%%DirSep%DFU_Driver"

rem compress 'silent_st_drivers' folder
"C:\Program Files\7-Zip\7z.exe" a silent_st_drivers2.exe -mmt -mx5 -sfx "%TmpWorkDir%"
exit

:ErrorDir
echo Error: Required source directory does not exist! Check: "%CheckDirName%"
exit 1

:ErrorFile
echo Error: Required source file does not exist! Check: "%CheckFileName%"
exit 2