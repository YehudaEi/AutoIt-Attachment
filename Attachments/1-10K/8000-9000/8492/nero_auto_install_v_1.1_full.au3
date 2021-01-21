; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         RnJ (rnjayaus@gmail.com)
;
; Script Function:
;	NERO OEM + NERO BURN SOFTWARE AUTO INSTALL
;
; ----------------------------------------------------------------------------
; Script Start - Add your code below here

SplashTextOn("NERO AUTO INSTALL Version.1.7", "This is an automated install of NERO OEM and Burn Rights!",200,150)
Sleep(7000)
SplashOff()

If FileExists("C:\Program Files\Ahead") Then
SplashTextOn("NERO AUTO INSTALL", "Previous version of NERO found, Deleting previous version...",200,75)
Sleep(5000)
SplashOff()
DirRemove("C:\Program Files\Ahead", 1)
Sleep(5000)
SplashTextOn("NERO AUTO INSTALL", "Installing NERO OEM...",100,75)
Sleep(5000)
SplashOff()
$pid=Run("\\Network Path\Nero 6 OEM\Nero OEM\Setup.exe")
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","",1042)
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","",1047)
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","",1042)
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","Customer information.",1042)
WinWait("Nero OEM Installation Wizard","Nero OEM installation in progress")
WinWait("Nero OEM Installation Wizard","The Wizard has completed the installation successfully",180)
ControlClick("Nero OEM Installation Wizard","",1040)

ProcessWaitClose($pid)
	
Else
SplashTextOn("NERO AUTO INSTALL", "Installing NERO OEM...",100,75)
Sleep(5000)
SplashOff()
$pid=Run("\\Network Path\Nero 6 OEM\Nero OEM\Setup.exe")
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","",1042)
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","",1047)
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","",1042)
WinWait("Nero OEM Installation Wizard")
ControlClick("Nero OEM Installation Wizard","Customer information.",1042)
WinWait("Nero OEM Installation Wizard","Nero OEM installation in progress")
WinWait("Nero OEM Installation Wizard","The Wizard has completed the installation successfully",180)
ControlClick("Nero OEM Installation Wizard","",1040)

ProcessWaitClose($pid)

EndIf

Sleep(5000)

If FileExists("C:\Program Files\Ahead\NeroBurnRights") Then
SplashTextOn("NERO AUTO INSTALL", "NERO Burn Rights already installed,install aborted...",150,100)
Sleep(5000)
SplashOff()    
Exit
Else
SplashTextOn("NERO AUTO INSTALL", "Burn Rights will install in 5 seconds...",100,75)
Sleep(5000)
SplashOff()    
$sid=Run("\\Network Path\CD Burn Software\Nero 6 OEM\Nero BurnRights\setup.exe")
WinWait("Nero BurnRights Installation Wizard")
ControlClick("Nero BurnRights Installation Wizard","",1042)
WinWait("Nero BurnRights Installation Wizard","Nero BurnRights installation in progress")
Sleep(5000)
WinWait("Nero BurnRights Installation Wizard")
ControlClick("Nero BurnRights Installation Wizard","",1040)
Sleep(5000)
Send("{DOWN}")
Send("{TAB}")
Send("{SPACE}")
Sleep(1000)
Send("{SPACE}")
ProcessWaitClose($sid)
EndIf
Exit
