@echo off

REM --add the following to the top of your bat file--
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
cls
@echo Checking ".minecraft" directory exists...
:MDIR
IF EXIST %appdata%\.minecraft GOTO MWARN
mkdir %appdata%\.minecraft
@echo You don't have ".minecraft" directory! I'll create a new one.
GOTO INSTALL

:MWARN
@echo WARNING! You already have ".minecraft" or "Minecraft Launcher" directory on your computer.
echo This batch file is intended for reinstalling Minecraft.
echo Enter b for backup (.minecraft directory), u to completely delete or uninstall and continue, or n to quit.
@echo =======================================
@echo     b. Backup .minecraft directory and delete ".minecraft" and "Minecraft Launcher".
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
rmdir /s /q "%appdata%\.minecraft"
rmdir /s /q "%windir%\..\Program Files (x86)\Minecraft Launcher"
cls
goto MDIR

:u
@echo Permanently deleting ".minecraft" and "Minecraft Launcher" files!!!
rmdir /s /q "%appdata%\.minecraft"
cd %userprofile%\Desktop
curl https://launcher.mojang.com/download/MinecraftInstaller.msi --output MinecraftLauncher.msi
msiexec /x MinecraftLauncher.msi /quiet /qn /passive
del MinecraftLauncher.msi /s /q
rmdir /s /q "%windir%\..\Program Files (x86)\Minecraft Launcher"
cls
goto MDIR

:INSTALL
@echo Changing directory to "Program Files (x86)"...
cd "%windir%\..\Program Files (x86)"
@echo Checking "Minecraft Launcher" directory exists...
IF EXIST ".\Minecraft Launcher" GOTO MWARN
@echo You don't have "Minecraft Launcher" directory! I'll create a new one.
mkdir ".\Minecraft Launcher"
@echo Changing directory to "Minecraft Launcher"...
cd "Minecraft Launcher"
echo Downloading Minecraft with curl...
curl https://launcher.mojang.com/download/Minecraft.exe --output Minecraft.exe
Running Minecraft.exe!
start Minecraft.exe
cls
GOTO INSTALLCHECK

:INSTALLCHECK

echo All Installation Step has been finished.
echo Does Minecraft Launcher showed up? If not, enter y for try again with another name.
echo If yes, you can enter n for quit.
@echo ===========================================================================
@echo               y. Try running Minecraft.exe with another name (피씨방 사용자분들은 이 방법을 사용해주세요.)                                        
@echo               n. Quit
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
echo URL="%windir%\..\Program Files (x86)\Minecraft Launcher\Minecraft.exe" >> "%userprofile%\Desktop\Minecraft Launcher.url"
echo IconFile="%windir%\..\Program Files (x86)\Minecraft Launcher\Minecraft.exe" >> "%userprofile%\Desktop\Minecraft Launcher.url"
echo IconIndex=0 >> "%userprofile%\Desktop\Minecraft Launcher.url"

taskkill /f /im Minecraft.exe
cls
exit

:MIL
IF NOT EXIST Minceraft.exe GOTO ERR

echo [InternetShortcut] >> "%userprofile%\Desktop\Minecraft Launcher.url"
echo URL="%windir%\..\Program Files (x86)\Minecraft Launcher\Minceraft.exe" >> "%userprofile%\Desktop\Minecraft Launcher.url"
echo IconFile="%windir%\..\Program Files (x86)\Minecraft Launcher\Minceraft.exe" >> "%userprofile%\Desktop\Minecraft Launcher.url"
echo IconIndex=0 >> "%userprofile%\Desktop\Minecraft Launcher.url"

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
goto MDIR

:q
echo Cleaning up before closing...
taskkill /f /im Minecraft.exe
taskkill /f /im Minceraft.exe
taskkill /f /im msiexec.exe
del %userprofile%\Desktop\MinecraftInstaller.msi
cls
exit