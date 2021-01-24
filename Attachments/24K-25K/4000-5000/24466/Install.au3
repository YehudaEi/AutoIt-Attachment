#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.13.13 (beta)
	Author:         Matthew McMullan
	
	Script Function:
	Automate Processes.
	
#ce ----------------------------------------------------------------------------

Opt("TrayIconHide", 1)
Opt("MustDeclareVars", 1)

Global $text
Global $Overhead=2
Global $OverheadX=2
Global $CheckBoxes[2]
Global $Buttons[2]
Global $Titles[2]
Global $Actions[2]
Global $ActionShow[2]
Global $ActionShowText[2]
Global $MasterGUI
Global $Go

ActionPopulate()
ActionSelect()

#Region ; GUI
Func GenerateGUI()
	$MasterGUI=GUICreate("Automated Instilation", 280, Int((UBound($CheckBoxes)-1) / 3 +1) * 80 + 50,IniRead("Install.ini","Refresh","X",-1),IniRead("Install.ini","Refresh","Y",-1))
	IniDelete("Install.ini","Refresh")
	Local $InstallText,$Menu
	$Go = GUICtrlCreateButton("Execute", 5, Int((UBound($CheckBoxes)-1) / 3) * 80 +80, 100)
	GUICtrlSetTip($Go, "Execute all Selected Commands")
	For $VBAR = 0 To UBound($CheckBoxes) - 1
		$InstallText = StringReplace($Titles[$VBAR], "Installing", "Install")
		$CheckBoxes[$VBAR] = GUICtrlCreateCheckbox("", Mod($VBAR, 3) * 90 + 10, Int($VBAR / 3) * 80 + 25, 10, 15)
		GUICtrlSetState($CheckBoxes[$VBAR], IniRead("Install.ini", "CheckBoxes", $Actions[$VBAR], 1))
		GUICtrlSetTip($CheckBoxes[$VBAR], $InstallText)
		$Buttons[$VBAR] = GUICtrlCreateButton($InstallText, Mod($VBAR, 3) * 90 + 30, Int($VBAR / 3) * 80 + 10, 52, 52, 0x0040)
		GUICtrlSetImage($Buttons[$VBAR], "Icons\" & $Actions[$VBAR] & ".ico")
		GUICtrlSetTip($Buttons[$VBAR], $InstallText)
	Next
	$Menu = GUICtrlCreateMenu("&Options")
	For $VBAR = 0 To UBound($ActionShow)-1
		$ActionShow[$VBAR] = GUICtrlCreateMenuItem("Show " & $ActionShowText[$VBAR],$Menu)
		$ActionShowText[$VBAR] = StringReplace(StringReplace($ActionShowText[$VBAR], " ", ""), "-", "")
		GUICtrlSetState($ActionShow[$VBAR],IniRead("Install.ini","Items",$ActionShowText[$VBAR],1))
	Next
	GUISetState(@SW_SHOW)
EndFunc

Func RefreshGUI()
	SaveGUI()
	Local $cursor = GUIGetCursorInfo($MasterGUI)
	$cursor[0]=MouseGetPos(0)-$cursor[0]
	$cursor[1]=MouseGetPos(1)-$cursor[1]-48
	IniWrite("Install.ini","Refresh","X",$cursor[0])
	IniWrite("Install.ini","Refresh","Y",$cursor[1])
	Run(@ScriptName)
	Exit
EndFunc

Func SaveGUI()
	For $i = 0 To UBound($CheckBoxes) - 1
		IniWrite("Install.ini", "CheckBoxes", $Actions[$i], GUICtrlRead($CheckBoxes[$i]))
	Next
	IniDelete("Install.ini","CheckBoxes","")
	For $i = 0 To UBound($ActionShow) - 1
		If BitAND(GUICtrlRead($ActionShow[$i]), 4) == 4 Then
			IniWrite("Install.ini", "Items", $ActionShowText[$i], 4)
		Else
			IniWrite("Install.ini", "Items", $ActionShowText[$i], 1)
		EndIf
	Next
EndFunc
#EndRegion

#Region ; Action Handling
Func ActionPopulate()
	ActionAdd("Adobe Flash Player")
	ActionAdd("Adobe Reader")
	ActionAdd("MediaPlayer")
	ActionAdd("Ad-Aware")
	ActionAdd("Avast")
	ActionAdd("Malware Bytes")
	ActionAdd("Nero")
	ActionAdd("Power DVD")
	ActionAdd("Open Office")
	ActionAdd("Service Pack 3")
	ActionAdd("Replace HOSTS File", False)
	ActionAdd("Check Disk", False)
	ActionAdd("Defragment", False)
	ActionAdd("Clean Autoruns", False)
	ActionAdd("Clean Up", False)
EndFunc   ;==>ActionPopulate

Func ActionAdd($Action, $AddInstall = True, $Reduce = -1)
	Local $ParsedAction = StringReplace(StringReplace($Action, " ", ""), "-", "")
	ReDim $ActionShow[UBound($ActionShow) +1 - $Overhead]
	ReDim $ActionShowText[UBound($ActionShowText) +1 - $Overhead]
	$ActionShowText[UBound($ActionShow) - 1] = $Action
	If Number(IniRead("Install.ini","Items",$ParsedAction,1))==1 Then
		ReDim $CheckBoxes[UBound($CheckBoxes) +1 - $OverheadX]
		ReDim $Titles[UBound($Titles) +1 - $OverheadX]
		ReDim $Actions[UBound($Actions) +1 - $OverheadX]
		ReDim $Buttons[UBound($Buttons) +1 - $OverheadX]
		If $AddInstall == True Then
			$Titles[UBound($Titles) - 1] = "Installing " & $Action
		Else
			$Titles[UBound($Titles) - 1] = $Action
		EndIf
		$Actions[UBound($Actions) - 1] = $ParsedAction
		$OverheadX=0
	Else
		IniWrite("Install.ini","Items",$ParsedAction,4)
	EndIf
	$Overhead=0
EndFunc   ;==>ActionAdd

Func ActionSelect()
	Local $Progress, $Current, $msg, $step, $steps, $GUI
	GenerateGUI()
	While 1
		$msg = GUIGetMsg(1)
		If $msg[0] == -3 Then
			If $msg[1] == $MasterGUI Then
				SaveGUI()
				Exit
			EndIf
		ElseIf $msg[0] == $Go Then
			$step = 0
			$steps = 0
			For $i = 0 To UBound($CheckBoxes) - 1
				$steps += Mod(GUICtrlRead($CheckBoxes[$i]), 4)
			Next
			$GUI = GUICreate("Automated Install", 300, 70, 0, 0)
			$Progress = GUICtrlCreateLabel("", 5, 5, 200, 20)
			$Current = GUICtrlCreateLabel("", 50, 20, 250, 20)
			GUISetState(@SW_SHOW)
			For $i = 0 To UBound($CheckBoxes) - 1
				If GUICtrlRead($CheckBoxes[$i]) == 1 Then
					$step += 1
					GUICtrlSetData($Progress, "Progress: Step " & String($step) & "/" & String($steps))
					GUICtrlSetData($Current, $Titles[$i])
					Execute($Actions[$i] & "()")
				EndIf
			Next
			GUICtrlSetData($Current, "Done")
			GUIDelete($GUI)
		Else
			For $VBAR = 0 To UBound($Buttons) - 1
				If $msg[0] == $Buttons[$VBAR] Then
					If GUICtrlRead($CheckBoxes[$VBAR]) == 4 Then
						GUICtrlSetState($CheckBoxes[$VBAR], 1)
					Else
						GUICtrlSetState($CheckBoxes[$VBAR], 4)
					EndIf
				EndIf
			Next
			For $VBAR = 0 To UBound($ActionShow) - 1
				If $msg[0] == $ActionShow[$VBAR] Then
					If BitAND(GUICtrlRead($ActionShow[$VBAR]), 4) == 4 Then
						GUICtrlSetState($ActionShow[$VBAR], 1)
						RefreshGUI()
					Else
						GUICtrlSetState($ActionShow[$VBAR], 4)
						RefreshGUI()
					EndIf
				EndIf
			Next
		EndIf
		Sleep(20)
	WEnd
EndFunc   ;==>ActionSelect
#EndRegion

#Region ; Actions
Func AdAware()
	Run("Other\aaw2008.exe /quiet")
	WinWaitActive("Ad-Aware")
	ControlClick("Ad-Aware", "", "OK")
	ProcessWaitClose("aaw2008.exe")
	FileDelete(@DesktopDir & "\Ad-Watch.lnk")
EndFunc   ;==>AdAware

Func AdobeFlashPlayer()
	Run("Other\FlashPlayer.exe /S")
	ProcessWait("FlashPlayer.exe")
	ProcessWaitClose("FlashPlayer.exe")
EndFunc   ;==>AdobeFlashPlayer

Func AdobeReader()
	Run("Other\AdobeReader.exe /sAll /rs")
	ProcessWait("AdobeReader.exe")
	ProcessWaitClose("AdobeReader.exe")
	FileDelete("C:\Documents and Settings\All Users\Desktop\Adobe Reader 9.LNK")
	FileDelete(@DesktopCommonDir & "Acrobat.com.lnk")
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "Adobe Reader Speed Launcher")
EndFunc   ;==>AdobeReader

Func Avast()
	Run("Other\AvastHome.exe /VERYSILENT /SP-")
	ProcessWait("AvastHome.exe")
	ProcessWaitClose("AvastHome.exe")
EndFunc   ;==>Avast

Func CheckDisk()
	Run("chkdsk C: /r")
	ProcessWait("chkdsk.exe")
	Sleep(300)
	Send("Y{ENTER}")
	ProcessWaitClose("chkdsk.exe")
EndFunc   ;==>CheckDisk

Func CleanAutoruns()
	Local $KEY = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
	RegDelete($KEY)
	RegWrite($KEY)
	$KEY = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
	RegDelete($KEY)
	RegWrite($KEY)
	RegWrite($KEY, "Avast", "REG_SZ", "C:\PROGRA~1\ALWILS~1\Avast4\ashDisp.exe")
	RegWrite($KEY, "KernelFaultCheck", "REG_EXPAND_SZ", "%systemroot%\system32\dumprep 0 -k")
	$KEY = $KEY & "\OptionalComponents"
	RegWrite($KEY)
	RegWrite($KEY & "\IMAIL")
	RegWrite($KEY & "\IMAIL", "Installed", "REG_SZ", 1)
	RegWrite($KEY & "\MAPI")
	RegWrite($KEY & "\MAPI", "Installed", "REG_SZ", 1)
	RegWrite($KEY & "\MAPI", "NoChange", "REG_SZ", 1)
	RegWrite($KEY & "\MSFS")
	RegWrite($KEY & "\MSFS", "Installed", "REG_SZ", 1)
EndFunc   ;==>CleanAutoruns

Func CleanUp()
	Run("CCleaner\CCleaner.exe /AUTO")
	ProcessWaitClose("CCleaner.exe")
	FileDelete(@DesktopCommonDir & "\Acrobat.com.lnk")
	FileDelete(@DesktopCommonDir & "\Adobe Reader 9.lnk")
	Local $KEY = "HKCU\Control Panel\Desktop"
	RegWrite($KEY, "AutoEndTasks", "REG_SZ", 1)
	RegWrite($KEY, "WaitToKillAppTimeout", "REG_SZ", 1000)
	RegWrite($KEY, "HungAppTimeout", "REG_SZ", 1000)
	RegWrite("HKLM\SYSTEM\CurrentControlSet\Control", "WaitToKillServiceTimeout", "REG_SZ", 1000)
	RegWrite("HKCR\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\ShellFolder", "CallForAttributes", "REG_DWORD", 0)
EndFunc   ;==>CleanUp

Func Defragment()
	Run("defrag C: -f")
	ProcessWait("defrag.exe")
	ProcessWaitClose("defrag.exe")
EndFunc   ;==>Defragment

Func MalwareBytes()
	Run("Other\MBAM.exe /verysilent")
	ProcessWait("MBAM.exe")
	ProcessWaitClose("MBAM.exe")
EndFunc   ;==>MalwareBytes

Func MediaPlayer()
	Run("Other\WMP11.exe /Q")
	ProcessWait("WMP11.exe")
	ProcessWaitClose("WMP11.exe")
EndFunc   ;==>MediaPlayer

Func Nero()
	Run("Nero\Setup.exe /silent")
	ProcessWaitClose("Setup.exe")
	FileMove(@DesktopCommonDir & "\Nero StartSmart.lnk", @DesktopCommonDir & "\Burn CDs and DVDs.lnk", 1)
EndFunc   ;==>Nero

Func OpenOffice()
	Run("Other\OOo_301.exe /S")
	ProcessWait("OOo_301.exe")
	ProcessWaitClose("OOo_301.exe")
EndFunc   ;==>OpenOffice

Func PowerDVD()
	Local $Setup = "PowerDVD Setup"
	Run("PowerDVD\Setup.exe")
	WinWaitActive($Setup)
	Sleep(2)
	ControlClick($Setup, "", "&Next >")
	Wait()
	ControlClick($Setup, "", "&Yes")
	Wait()
	ControlClick($Setup, "", "&Next >")
	Wait()
	ControlClick($Setup, "", "&Next >")
	Wait()
	ControlClick($Setup, "", "&Next >")
	Wait()
	While 1
		Sleep(20)
		$text = StringSplit(WinGetText($Setup), "&Next >", 1)
		If $text[0] > 1 Then ExitLoop
	WEnd
	$text = WinGetText($Setup)
	Sleep(250)

	ControlClick($Setup, "", "&Next >")
	Wait()
	ControlClick($Setup, "", "View the Readme file")
	ControlClick($Setup, "", "Finish")
EndFunc   ;==>PowerDVD

Func ReplaceHOSTSFile()
	FileCopy(@ScriptDir & "\Other\hosts", @WindowsDir & "\system32\drivers\etc", 1)
	Run("sc stop dnscache")
	Sleep(300)
	ProcessClose("sc.exe")
	ProcessWaitClose("sc.exe")
	RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DNSCache", "Start", "REG_DWORD", 4)
EndFunc   ;==>ReplaceHOSTSFile

Func ServicePack3()
	Run("Other\XP SP3.exe /quiet")
	ProcessWait("XP SP3.exe")
	ProcessWaitClose("XP SP3.exe")
EndFunc   ;==>ServicePack3

Func Wait()
	While $text == WinGetText("PowerDVD Setup")
		Sleep(20)
	WEnd
	$text = WinGetText("PowerDVD Setup")
	Sleep(250)
EndFunc   ;==>Wait
#EndRegion
