#include <GUIConstants.au3>

SoundPlay("Inspector Gadget Theme.mp3")
$Form2 = GUICreate("Game Installer V0.9.1 BETA", 706, 548, -1, -1)
$Close = GUICtrlCreateButton("Close", 600, 496, 75, 25, 0)
$Install = GUICtrlCreateButton("Install", 496, 496, 75, 25, 0)
$COD2 = GUICtrlCreateCheckbox("Call of Duty 2", 184, 200, 97, 17)
$FO2 = GUICtrlCreateCheckbox("FlatOut 2", 184, 224, 97, 17)
$CS = GUICtrlCreateCheckbox("Counter Strike 1.6", 184, 248, 129, 17)
$CSS = GUICtrlCreateCheckbox("Counter Strike Source", 184, 272, 145, 17)
$HL2DM = GUICtrlCreateCheckbox("Half Life 2 Deatch Match", 184, 296, 145, 17)
$TF2 = GUICtrlCreateCheckbox("Team Fortress 2", 184, 320, 161, 17)
$FTPC = GUICtrlCreateCheckbox("FileZilla Client", 392, 200, 97, 17)
$FTPS = GUICtrlCreateCheckbox("FileZilla Server", 392, 224, 97, 17)
$TS = GUICtrlCreateCheckbox("Team Speak Client", 392, 248, 129, 17)
$IMG = GUICtrlCreateCheckbox("ImgBurn", 392, 272, 97, 17)
$PIC = GUICtrlCreatePic("logo.jpg" , 520, 48, 100, 100)
$LabelGAMES = GUICtrlCreateLabel("Games", 184, 168, 56, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$LabelSOFT = GUICtrlCreateLabel("Software", 392, 168, 68, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$LabelCOD2 = GUICtrlCreateLabel("Info", 344, 200, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelCOD4 = GUICtrlCreateLabel("Info", 344, 224, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelFO2 = GUICtrlCreateLabel("Info", 344, 248, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelCS16 = GUICtrlCreateLabel("Info", 344, 272, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelTF2 = GUICtrlCreateLabel("Info", 344, 296, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelDOW = GUICtrlCreateLabel("Info", 344, 320, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelFZC = GUICtrlCreateLabel("Info", 520, 200, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelFZS = GUICtrlCreateLabel("Info", 520, 224, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelTS = GUICtrlCreateLabel("Info", 520, 248, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$LabelIMG = GUICtrlCreateLabel("Info", 520, 272, 22, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
GUISetState(@SW_SHOW)

While 1

	$nMsg = GUIGetMsg()
	Switch $nMsg
		
		Case $LabelCOD2
			COD2BANNER()
		Case $LabelCOD4
			COD4BANNER()
		Case $LabelFO2
			FO2BANNER()
		Case $Install
			Installeren()
		Case $GUI_EVENT_CLOSE, $Close
			DriveMapDel("Z:")
			Exit

	EndSwitch
WEnd

Func Installeren()
	
	DriveMapAdd("Z:" , "\\192.168.1.25\Games" , 0 , "Lan" , "getin")
	
	; Games
	
	; Call of Duty 2
		If GUICtrlRead($COD2)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($COD2)=$GUI_CHECKED Then 
		Run("Z:\FPS\Call of Duty 2\setup.exe")
	$TITLE = "Call of Duty(R) 2"
	$SUB = "Welcome to the InstallShield Wizard for Call of Duty(R) 2"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Key Code Check"
		WinWait($TITLE, $SUB)
		Run("Z:\Keygens\Call of Duty 2.exe")
	$TITLE = "LAN games project +20 by TSRh"
	$SUB = "by BUBlic"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
		ControlClick($TITLE, $SUB, "Button1")
		ControlClick($TITLE, $SUB, "Button1")
		ControlClick($TITLE, $SUB, "Button1")
		ControlClick($TITLE, $SUB, "Button1")
		WinClose($TITLE, $SUB)
	$TITLE = "Call of Duty(R) 2"
	$SUB = "Key Code Check"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$TITLE = "Key Code Check"
	$SUB = "The Key Code you entered appears to be valid.  Activision will never ask you for your Key Code.  Don't tell it to anyone!  Don't lose your Key Code!"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$TITLE = "Call of Duty(R) 2"
	$SUB = "License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button5")
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Minimum System Requirements"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Setup Type"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button4")
	WinWaitClose($TITLE)
	Run("Z:\Updates\cod2intelpatch_101.exe")
	$TITLE = "Call of Duty(R) 2 Patch 1.01"
	$SUB = "Welcome to the InstallShield Wizard for Call of Duty(R) 2 Patch 1.01"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button5")
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Minimum System Requirements"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Readme"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Choose Destination Location"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button3")
	$SUB = "InstallShield Wizard Complete"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button4")
		WinWaitClose($TITLE)
	Sleep(500)
	Run("Z:\Updates\CallofDuty2Patchv1_2.exe")
	$TITLE = "Call of Duty(R) 2 Patch 1.2"
	$SUB = "Welcome to the InstallShield Wizard for Call of Duty(R) 2 Patch 1.2"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button5")
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "PunkBuster(TM) End User License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button5")
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Minimum System Requirements"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Readme"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Choose Destination Location"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "InstallShield Wizard Complete"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button4")
		WinWaitClose($TITLE)
	Run("Z:\Updates\CallofDuty2Patchv1_3.exe")
	$TITLE = "Call of Duty(R) 2 Patch 1.3"
	$SUB = "Welcome to the InstallShield Wizard for Call of Duty(R) 2 Patch 1.3"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button5")
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "PunkBuster(TM) End User License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button5")
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Minimum System Requirements"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Readme"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Choose Destination Location"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "InstallShield Wizard Complete"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button4")
		WinWaitClose($TITLE)
	EndIf
	
	; Call of Duty 4
	;	If GUICtrlRead($COD4)=$GUI_CHECKED Then Sleep(1000)
;	If GUICtrlRead($COD4)=$GUI_CHECKED Then 
;		Run("Z:\FPS\Call of Duty 4\setup.exe")
;	$TITLE = "Call of Duty(R) 4 - Modern Warfare(TM)"
;	$SUB = "Welcome to the InstallShield Wizard for Call of Duty(R) 4 - Modern Warfare(TM)"
;		WinWait($TITLE, $SUB)
;		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
;		ControlClick($TITLE, $SUB, "Button1")
;	Run("Z:\Keygens\Call of Duty 4.exe")
;	$TITLE = "  ::: Call Of Duty 4: MW - Keygen :::"
;	$SUB = "Game Key:"
;		WinWait($TITLE, $SUB)
;		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
;		ControlClick($TITLE, $SUB, "Button1")
;		ControlClick($TITLE, $SUB, "Button1")
;		ControlClick($TITLE, $SUB, "Button1")
;		ControlClick($TITLE, $SUB, "Button1")
;		ControlClick($TITLE, $SUB, "Button1")
;		;WinClose($TITLE)
;	EndIf
	
	;FlatOut 2	
		If GUICtrlRead($FO2)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($FO2)=$GUI_CHECKED Then 
	Run("Z:\Race\Flatout 2\setup.exe")
	$TITLE = "FlatOut 2"
	$SUB   = "Welcome to the InstallShield Wizard for FlatOut 2"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button3")
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Choose Destination Location"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Please select your START menu path."
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Ready to Install the Program"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$TITLE = "Setup Needs The Next Disk"
	$SUB = "Please insert FlatOut 2 disk 1"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$TITLE = "FlatOut 2"
	$SUB = "FlatOut 2 Setup is almost complete"
	WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
		ControlClick($TITLE, $SUB, "Button2")
		ControlClick($TITLE, $SUB, "Button4")
		WinWaitClose($TITLE)
	$TITLE = "Installeren van Microsoft(R) DirectX(R)"
	$SUB = "DirectX Setup"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
		ControlClick($TITLE, $SUB, "Button4")
	$SUB = "DirectX Runtime-installatie:"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button4")
	$SUB = "Installatie voltooid"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button5")
		WinWaitClose($TITLE)
		Sleep(500)
	IF GUICtrlRead($FO2)=$GUI_CHECKED Then FileCopy("Z:\Race\Flatout 2\Crack\FlatOut2.exe" , "C:\Program Files\Empire Interactive\FlatOut 2\" , 1)
	EndIf
	
	; Counter Strike 1.6
		If GUICtrlRead($CS)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($CS)=$GUI_CHECKED Then 
		Run("Z:\FPS\CS 1.6 NON-STEAM\CS 1.6 no steam.exe")
	$TITLE = "Counter-Strike 1.6 Install Program"
	$SUB = "Welcome to the Counter-Strike 1.6 Install program."
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Information"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Quality"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Directory"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "The destination directory doesn't exist. Do you want it to be created?"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "Confirmation"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$SUB = "End"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
		WinWaitClose($TITLE)
	EndIf
	
	; Counter Strike Source
		If GUICtrlRead($CSS)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($CSS)=$GUI_CHECKED Then 
	Run("Z:\FPS\Counter Strike Source NON-STEAM\files\install.part1.exe")
	$TITLE = "Counter-Strike Source Full Game V1.0.0.3.4 by Guidonline"
	$SUB = "&Doelmap"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	WinWaitClose($TITLE)
	EndIf
	
	; Half Life 2 Deatch Match
		If GUICtrlRead($HL2DM)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($HL2DM)=$GUI_CHECKED Then
	Run("Z:\FPS\Half Life 2 Deathmatch NON-STEAM\files\install.part1.exe")
	$TITLE = "Half-Life 2 - Deathmatch"
	$SUB = "&Doelmap"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	WinWaitClose($TITLE)
	EndIf
	
	; Team Fortress 2
		If GUICtrlRead($TF2)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($TF2)=$GUI_CHECKED Then 
	Run("Z:\FPS\Team Fortress 2\Team Fortress 2 Setup.exe")
	$TITLE = "Installer Language"
	$SUB = "Please select a language."
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$TITLE = "Team Fortress 2 Setup"
	$SUB = "Welkom bij de Team Fortress 2-installatiewizard"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Installatielocatie kiezen"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Startmenumap kiezen"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Onderdelen kiezen"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Voltooien van de Team Fortress 2-installatiewizard"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
		WinWaitClose($TITLE)
	EndIf
	
	; Software
	
	; FileZilla Client
		If GUICtrlRead($FTPC)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($FTPC)=$GUI_CHECKED Then
	Run("Z:\Software\FileZilla-Client.exe")
	$TITLE = "FileZilla Client"
	$SUB   = "License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Installation Options"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Components"		
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Install Location"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Start Menu Folder"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Click Finish to close Setup"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
		WinWaitClose($TITLE)
	Endif
	
	; FileZilla Server
		If GUICtrlRead($FTPS)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($FTPS)=$GUI_CHECKED Then 
	Run("Z:\Software\FileZilla-Server.exe")
	$TITLE = "FileZilla Server"
	$SUB   = "License Agreement"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Components"		
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Install Location"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Please choose how FileZilla Server should be started:"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Please choose how the server &interface should be started:"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Installation Complete"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
		WinWaitClose($TITLE)
	$TITLE = "Connect to Server"
	$SUB = "&Server Address"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
		ControlClick($TITLE, $SUB, "Button2")
	$TITLE = "FileZilla server"
	$SUB = "FileZilla Server version"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
	WinClose($TITLE)
	EndIf
	
	; TeamSpeak Client
		If GUICtrlRead($TS)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($TS)=$GUI_CHECKED Then 
	Run("Z:\Software\TeamSpeak Client.exe")
	$TITLE = "Setup"
	$SUB = "This will install Teamspeak 2 RC2. Do you wish to continue?"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button1")
	$TITLE = "Setup - Teamspeak 2 RC2"
	$SUB = "Welcome"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "TEAMSPEAK CLIENT LICENSE"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TRadioButton2")
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "SelectDir"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "SelectProgramGroup"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "SelectTasks"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "Ready"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$TITLE = "TeamSpeak Codec Installer"
	$SUB = "page1"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "Page2"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "Finish"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton1")
	WinWaitClose($TITLE)
	$TITLE = "Setup - Teamspeak 2 RC2"
	$SUB = "Bugfixes"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TButton2")
	$SUB = "Finished"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "TCheckBox1")
		ControlClick($TITLE, $SUB, "TButton2")
	WinWaitClose($TITLE)
	EndIf

	; ImgBurn
		If GUICtrlRead($IMG)=$GUI_CHECKED Then Sleep(1000)
	If GUICtrlRead($IMG)=$GUI_CHECKED Then 
	Run("Z:\Software\SetupImgBurn.exe")
	;$TITLE = "Bestand openen - beveiligingswaarschuwing"
	;$SUB = "Kan de uitgever niet bevestigen. Weet u zeker dat u deze software wilt uitvoeren?"
	;	WinWait($TITLE, $SUB)
	;	If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
	;	WinWaitActive($TITLE, $SUB)
	;	ControlClick($TITLE, $SUB, "Button1")
	$TITLE = "ImgBurn"
	$SUB = "&Next >"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Components"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Install Location"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Choose Start Menu Folder"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Would you like ImgBurn to periodically check if a newer version is available?"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button2")
	$SUB = "Completing the ImgBurn Setup Wizard"
		WinWait($TITLE, $SUB)
		If Not WinActive($TITLE, $SUB) Then WinActivate($TITLE, $SUB)
		WinWaitActive($TITLE, $SUB)
		ControlClick($TITLE, $SUB, "Button4")
		ControlClick($TITLE, $SUB, "Button2")
	WinWaitClose($TITLE)
	EndIf
Sleep(1000)
#include <GUIConstants.au3>

$Form1 = GUICreate("Completed", 304, 159, -1, -1 )
$Label1 = GUICtrlCreateLabel("Alles succesvol geïnstalleerd", 48, 56, 205, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)

Do
	$var = GUIGetMsg()
Until $var = $GUI_EVENT_CLOSE
	GUIDelete($Form1)
	GUISetState($Form2, @SW_RESTORE)

EndFunc

Func COD2BANNER()
	#include <GUIConstants.au3>


$Form1 = GUICreate("Call of Duty 2 Information", 731, 251, -1, -1)
$Label1 = GUICtrlCreateLabel("Call of Duty 2 is een first-person shooter van Activision, uitgebracht op 25 oktober 2005 (voor Windows). ", 24, 144, 497, 17)
$Label2 = GUICtrlCreateLabel("Het spel speelt zich af tijdens de Tweede Wereldoorlog. De speler vecht mee met de geallieerden; voor het Sovjetse Rode Leger als Vasili Koslov,", 24, 168, 692, 17)
$Label3 = GUICtrlCreateLabel("voor het Engelse leger onder andere als John Davis en voor het Amerikaanse US Army als Bill Taylor.", 24, 184, 480, 17)
$Label4 = GUICtrlCreateLabel("In de multiplayermodus (LAN of online) is het ook mogelijk met de Duitsers mee te vechten.", 24, 216, 430, 17)
$Pic1 = GUICtrlCreatePic("cod2.jpg", 152, 24, 412, 100)
GUISetState(@SW_SHOW)


Do
	$var = GUIGetMsg()
Until $var = $GUI_EVENT_CLOSE
	GUIDelete($Form1)
	GUISetState($Form2, @SW_RESTORE)
EndFunc

Func COD4BANNER()
	#include <GUIConstants.au3>


$Form1 = GUICreate("Call of Duty 4 Information", 731, 251, -1, -1)
$Label1 = GUICtrlCreateLabel("Call of Duty 4: Modern Warfare, aangekondigd op 25 april 2007, voor de PC, Xbox 360, PlayStation 3,", 24, 136, 496, 17)
$Label2 = GUICtrlCreateLabel("en Nintendo DS, is het vierde deel in de Call of Duty-computerspelreeks.", 24, 152, 344, 17)
$Label3 = GUICtrlCreateLabel("Daarbij is het ook het eerste deel in de Call of Duty reeks dat zich niet tijdens de Tweede Wereldoorlog afspeelt,", 24, 176, 530, 17)
$Label4 = GUICtrlCreateLabel("maar in het heden. Het spel bevat daarom veel moderne wapens en technieken, zoals de M203 granaat werper, ", 24, 192, 535, 17)
$Pic1 = GUICtrlCreatePic("COD4.jpg", 192, 8, 375, 117)
$Label5 = GUICtrlCreateLabel("IR laser richters in combinatie met nachtzichtapparatuur, de FGM-148 Javelin, een geleid pantserafweerwapen en onbemande luchtvaartuigen. ", 24, 208, 679, 17)
$Label6 = GUICtrlCreateLabel("Het spel speelt zich af in het Midden-Oosten, de Kaukasus en Rusland.", 24, 232, 340, 17)
GUISetState(@SW_SHOW)

Do
	$var = GUIGetMsg()
Until $var = $GUI_EVENT_CLOSE
	GUIDelete($Form1)
	GUISetState($Form2, @SW_RESTORE)
EndFunc

Func FO2BANNER()
	#include <GUIConstants.au3>


$Form1 = GUICreate("FlatOut 2 Information", 731, 251, -1, -1)
$Label1 = GUICtrlCreateLabel("FlatOut 2 is a racing video game developed by Bugbear Entertainment and published by Empire Interactive and", 8, 96, 526, 17)
$Label2 = GUICtrlCreateLabel("Vivendi Universal Games. It is the sequel to the 2004-2005 release FlatOut.", 8, 112, 357, 17)
$Label3 = GUICtrlCreateLabel("This game is themed more on the street racing/import tuner scene than its predecessor.", 8, 136, 414, 17)
$Label4 = GUICtrlCreateLabel("Another notable change is the tire grip; players can now take more control of their car, ", 8, 152, 410, 17)
$Pic1 = GUICtrlCreatePic("flatout2.jpg", 536, 40, 190, 158)
$Label6 = GUICtrlCreateLabel("worrying less about skidding in tight turns. The game has three car classes: derby, race and street.", 8, 168, 465, 17)
GUISetState(@SW_SHOW)


Do
	$var = GUIGetMsg()
Until $var = $GUI_EVENT_CLOSE
	GUIDelete($Form1)
	GUISetState($Form2, @SW_RESTORE)
EndFunc