@echo off
if not "%1"=="am_admin" (@echo Requesting administrative privileges... & powershell start -verb runas '%0' am_admin & exit /B)
:MAIN
cls
@echo Welcome to Reinstall Minecraft Batch File! (Created by BaeHyeonWoo)
@echo This batch file is for Reinstalling Minecraft for crash, lags, etc...
@echo This batch file will also download a Minecraft as a portable version, which actually "NOT RECOMMENDED."
@echo If you just want to backup the Minecraft and uninstall Minecraft and exit, you can enter "o" for that.
@echo or, if you just want to fully enter the reinstallation progress, type "r" for that.
@echo Thank you for using the ReinstallMinecraftBat. I hope you solve your problem with this batch file. Good Luck!

@echo =======================================
@echo     o. Backup ".minecraft" directory, uninstall Minecraft, and exit!
@echo     r. Start full reinstallation progress.
@echo     s. Show "Minecraft Launcher" directory (Also shows on your desktop!)
@echo     q. Quit
@echo =======================================

set /p choice=Options :  

goto %choice%

:s
attrib "%userprofile%\Desktop\Minecraft Launcher" -s -h -r
goto MAIN

:o
@echo Copying ".minecraft" directory to %userprofile%\Desktop for backup...
cd %userprofile%\Desktop
mkdir dotMinecraftDirBackup
cd dotMinecraftDirBackup
xcopy "%appdata%\.minecraft" .\ /E /Y
@echo Uninsitalling Minecraft Launcher with .msi!
curl https://launcher.mojang.com/download/MinecraftInstaller.msi --output MinecraftLauncher.msi
msiexec /x MinecraftLauncher.msi /quiet /qn /passive
del MinecraftLauncher.msi /s /q
cls
@echo All Done!
@echo Type "q" for quit or "!" for start the full reinstallation progress!

set /p choice=Options :  

goto %choice%

:!
cls
GOTO MDIR


:MDIR
@echo Checking if ".minecraft" directory exists...
IF EXIST %appdata%\.minecraft GOTO MWARN
mkdir %appdata%\.minecraft
@echo You don't have ".minecraft" directory! I'll create a new one.
GOTO INSTALL

:MWARN
@echo WARNING! You already have ".minecraft" directory on your computer.
echo This batch file is intended for reinstalling Minecraft.
echo Enter "b" for backup (.minecraft directory), "u" to completely delete or uninstall and continue, or "n" to quit.
@echo =======================================
@echo     b. Backup ".minecraft" directory and delete ".minecraft".
@echo     u. Just completely delete or uninstall Minecraft.                          
@echo     q. Quit
@echo =======================================

set /p choice=Options :  

goto %choice%

:b
@echo Copying ".minecraft" directory to %userprofile%\Desktop for backup purpose...
cd %userprofile%\Desktop
mkdir dotMinecraftDirBackup
cd dotMinecraftDirBackup
xcopy "%appdata%\.minecraft" .\ /E /Y
@echo Removing ".minecraft" directory...
rmdir /s /q "%appdata%\.minecraft"
cls
goto MDIR

:u
@echo Permanently deleting ".minecraft" files!!!
rmdir /s /q "%appdata%\.minecraft"
cd %userprofile%\Desktop
@echo Uninsitalling Minecraft Launcher with .msi! This is for preventing crash!
curl https://launcher.mojang.com/download/MinecraftInstaller.msi --output MinecraftLauncher.msi
msiexec /x MinecraftLauncher.msi /quiet /qn /passive
del MinecraftLauncher.msi /s /q
cls
goto MDIR

:INSTALL
@echo Changing directory to your Desktop...
cd %userprofile%\Desktop
@echo Checking "Minecraft Launcher" directory exists...
IF EXIST ".\Minecraft Launcher" GOTO MWARN
@echo You don't have "Minecraft Launcher" directory! I'll create a new one.
mkdir ".\Minecraft Launcher"
attrib "%userprofile%\Desktop\Minecraft Launcher" +s +h +r
@echo Changing directory to "Minecraft Launcher"...
cd "Minecraft Launcher"
echo Downloading Minecraft with curl...
curl https://launcher.mojang.com/download/Minecraft.exe --output Minecraft.exe
echo Running Minecraft.exe!
start Minecraft.exe
cls
GOTO INSTALLCHECK

:INSTALLCHECK

echo All Installation Step has been finished.
echo Does Minecraft Launcher showed up? If not, enter "y" for try again with another name.
echo If yes, you can enter "n" for quit.
@echo ===========================================================================
@echo               y. Try running Minecraft.exe with another name. (피씨방 사용자분들은 이 방법을 사용해주세요.)
@echo               n. Quit!
@echo               f. I have tried "y" option but didn't work.
@echo ===========================================================================

set /p choice=Options :  

goto %choice%

:y
taskkill /f /im Minecraft.exe
move Minecraft.exe Minceraft.exe
start Minceraft.exe
cls
goto INSTALLCHECK

:n
echo Exiting after creating link file of your Minecraft...
IF NOT EXIST Minecraft.exe GOTO MIL

echo [InternetShortcut] >> "%userprofile%\Desktop\Minecraft Launcher.url"
echo URL=".\Minecraft.exe" >> "..\Minecraft Launcher.url"
echo IconFile=".\Minecraft.exe" >> "..\Minecraft Launcher.url"
echo IconIndex=0 >> "..\Minecraft Launcher.url"


taskkill /f /im Minecraft.exe
cls
exit

:MIL
IF NOT EXIST Minceraft.exe GOTO ERR

echo [InternetShortcut] >> "%userprofile%\Desktop\Minecraft Launcher.url"
echo URL=".\Minceraft.exe" >> "..\Minecraft Launcher.url"
echo IconFile=".\Minceraft.exe" >> "..\Minecraft Launcher.url"
echo IconIndex=0 >> "..\Minecraft Launcher.url"

taskkill /f /im Minceraft.exe
cls
exit

:f
echo Sorry, but it looks like this batch file cannot fix Minecraft to run on your system.
echo Please check your current system first, then run the official installer or this batch file.
goto q

:ERR
echo Something went wrong while installation!
echo Do you want to try again? If so, enter r for start the whole process.
echo If not, please enter q for quit.

set /p choice=Options :  

goto %choice%

:r
cls
goto MDIR

:q
echo Cleaning up before closing...
taskkill /f /im Minecraft.exe
taskkill /f /im Minceraft.exe
taskkill /f /im msiexec.exe
del .\MinecraftInstaller.msi
cls
exit