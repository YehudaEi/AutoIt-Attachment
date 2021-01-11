Global $icons = "shell32.dll"
TraySetIcon($icons, 188)
#include <Array.au3>
#include <GUIConstants.au3>
#include <File.au3>
TraySetToolTip("CD Ejector v1")
Opt("TrayMenuMode", 1)
Global $disks = DriveGetDrive("CDROM")
Global $toclose = $disks[1]
Global $STR_DRIVECHR = StringUpper(StringTrimRight($toclose, 1))
Opt("OnExitFunc", "OnScriptExit")
If $CmdLine[0] <> 0 then
	If $CmdLine[1] = "/open" Then CDTray($CmdLine[2],"open")
	If $CmdLine[1] = "/close" Then CDTray($CmdLine[2],"closed")
	If $CmdLine[1] = "/openall" Then
		For $i = 1 To $disks[0]
				CDTray($disks[$i], "open")
		Next
	EndIf
	If $CmdLine[1] = "/closeall" Then
		For $i = 1 To $disks[0]
				CDTray($disks[$i], "closed")
		Next
	EndIf
EndIf
$gui = GUICreate("CD Ejector toolbox", 168, 80, 294, 175, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))

;Skipped 13. because it is not lucky one :)
$close = GUICtrlCreateButton("Close", 0, 28, 52, 29)
GUICtrlSetTip(-1, "Closes current opened drive", "Close drive", 1, 1)
$eject = GUICtrlCreateButton("Eject", 0, 0, 52, 28)
GUICtrlSetTip(-1, "Ejects current closed drive", "Open drive", 1, 1)
$nextdrive = GUICtrlCreateButton("Next drive", 52, 0, 55, 28)
GUICtrlSetTip(-1, "Switchs to the next drive", "Next drive", 1, 1)
$ejectall = GUICtrlCreateButton("Eject all", 52, 28, 55, 29)
GUICtrlSetTip(-1, "Eject all CD/DVD drives", "Eject all drives", 1, 1)
$closeall = GUICtrlCreateButton("Close all", 108, 0, 59, 27)
GUICtrlSetTip(-1, "Closes all CD trays", "Close tray", 1, 1)
$quitbox = GUICtrlCreateButton("Close box", 108, 28, 59, 29)
GUICtrlSetTip(-1, "Click here to temporary close toolbox." & @CRLF & "Toolbox can be opened again using ""Open CD " & @CRLF & "Ejector toolbox"" command.", "Closing toolbox", 1, 1)
$drive = GUICtrlCreateLabel("Current drive is " & $STR_DRIVECHR, 31, 61, 86, 17)
GUICtrlSetTip(-1, "If is this text red, it means there was no CD or DVD in drive. Else, it is coloured red.", "Selected drive info", 1, 1)
$iconstate = GUICtrlCreateIcon($icons, 27, 10, 61, 16, 16)
GUICtrlSetColor($drive, 0xFF0000)
GUISetState(@SW_SHOW)
$trayGUI = TrayCreateItem("Open CD Ejector toolbox")
$trayDetect = TrayCreateItem("Detect CD/DVD")
$trayTipOfTheDay = TrayCreateItem("Next Tip of the day")
TrayCreateItem("")
$trayOpen = TrayCreateItem("Open CD tray")
$trayClose = TrayCreateItem("Close CD tray")
TrayCreateItem("")
$trayOpenAll = TrayCreateItem("Open all trays")
$trayCloseAll = TrayCreateItem("Close all trays")
TrayCreateItem("")
$trayHelp = TrayCreateMenu("Help")
$trayGeneralH = TrayCreateItem("General help", $trayHelp)
$trayFeaturesH = TrayCreateItem("Features", $trayHelp)
$trayAboutH = TrayCreateItem("About", $trayHelp)
TrayCreateItem("")
$trayNext = TrayCreateItem("Next CD tray")
If $disks[0] = 1 Then TrayItemSetState($trayNext, 128)
$trayCurrent = TrayCreateItem("Current CD tray: " & $STR_DRIVECHR)
TrayItemSetState($trayCurrent, 128)
TrayCreateItem("")
$trayExit = TrayCreateItem("Exit CD Ejector")
_TipOfTheDay()
AdlibEnable("_WhereIsCD")
While 1
	$msg = TrayGetMsg()
	$gmsg = GUIGetMsg()
	$state = DriveStatus($toclose)
	Select
		;;;;;;;;;;;;;;Help;;;;;;;;;;;;;;;;;;;;;J
		Case $msg = $trayGeneralH
			MsgBox(4096, "CD Ejector help - General info", "Hi " & @UserName & "!" & @CRLF & "Welcome to CD Ejector." & @CRLF & "Version is 1.0" & @CRLF & "Program directory is " & @ScriptDir & @CRLF & "CD tray selected is " & $STR_DRIVECHR & "." & @CRLF & "Page 1 of 3")
		Case $msg = $trayFeaturesH
			MsgBox(4096, "CD Ejector help - Features", "CD Ejector has next features:" & @CRLF & "* Eject/close all drives" & @CRLF & "* Eject/close one drive" & @CRLF & "* Fast help" & @CRLF & "* Detecting CD\DVD in drive." & @CRLF & "* Blinking icon where is no CD\DVD in drive " & @CRLF & "Page 2 of 3")
		Case $msg = $trayAboutH
			MsgBox(4096, "CD Ejector help - About", "Idea by: eynstyne (AutoIt Forums)" & @CRLF & "Code writed by: i542 (AutoIt Forums)" & @CRLF & "Thanks to: Users of this program (e.g. " & @UserName & ")" & @CRLF & "Developed in: AutoIt v3.2.0.0" & @CRLF & "Page 3 of 3")
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Case $msg = $trayTipOfTheDay
			_TipOfTheDay()
		Case $msg = $trayDetect
			$drivestatus = DriveStatus($toclose)
			Switch $drivestatus
				Case "READY"
					MsgBox(64 + 4096, ":) CD Ejector :)", "There was ready CD/DVD in drive " & $STR_DRIVECHR & ".")
				Case "UNKNOWN"
					MsgBox(64 + 4096, ":| CD Ejector :|", "Seems there is something unknown in drive " & $STR_DRIVECHR & "!")
				Case "NOTREADY"
					MsgBox(64 + 4096, ":( CD Ejector :(", "Ooops! You aren't insert any CD/DVD in " & $STR_DRIVECHR & ".")
				Case "INVALID"
					MsgBox(64 + 4096, "o_o CD Ejector o_o", "Are you just destroy drive" & $STR_DRIVECHR & "?")
			EndSwitch
		Case $msg = $trayGUI
			GUISetState(@SW_SHOW, $gui)
		Case $msg = $trayOpen
			CDTray($toclose, "open")
			If @error Then
				TrayTip("Selected CD tray can not be opened", "CD tray " & $STR_DRIVECHR & " can not be opened. " & @LF & "This error is maybe showed because some object blocks CD tray" & @LF & _
						"to open or CD tray is removed from system.", 30, 3)
			EndIf
		Case $msg = $trayClose
			CDTray($toclose, "closed")
			If @error Then
				TrayTip("Selected CD tray can not be closed", "CD tray " & $STR_DRIVECHR & " can not be closed. " & @LF & "This error is maybe showed because some object blocks CD tray" & @LF & _
						"to close, CD tray is removed from system or" & @LF & "selected CD tray is a laptop-type tray which usually must be closed manually.", 30, 2)
			EndIf
		Case $msg = $trayOpenAll
			For $i = 1 To $disks[0]
				CDTray($disks[$i], "open")
			Next
		Case $msg = $trayCloseAll
			For $i = 1 To $disks[0]
				CDTray($disks[$i], "closed")
			Next
		Case $msg = $trayNext
			Global $STR_DRIVECHR = StringUpper(StringTrimRight($toclose, 1))
			$l = _ArrayMax($disks)
			$a = _ArraySearch($disks, $toclose)
			If $toclose = $disks[$l] Then
				For $i = 1 To $disks[0]
					$toclose = $disks[$a - 1]
				Next
			Else
				$toclose = $disks[$a + 1]
			EndIf
			Global $STR_DRIVECHR = StringUpper(StringTrimRight($toclose, 1))
			TrayItemSetText($trayCurrent, "Current CD tray: " & $STR_DRIVECHR)
			GUICtrlSetData($drive, "Current drive is " & $STR_DRIVECHR)
		Case $msg = $trayExit
			Exit
		;;;;;;;;;;;;;;;;;;
		Case $gmsg = $eject
			TraySetIcon($icons, 27)
			CDTray($toclose, "open")
			If @error Then
				TrayTip("Selected CD tray can not be opened", "CD tray " & $STR_DRIVECHR & " can not be opened. " & @LF & "This error is maybe showed because some object blocks CD tray" & @LF & _
						"to open or CD tray is removed from system.", 30, 3)
			EndIf
			TraySetIcon($icons, 188)
		Case $gmsg = $close
			TraySetIcon($icons, 266)
			CDTray($toclose, "closed")
			If @error Then
				TrayTip("Selected CD tray can not be closed", "CD tray " & $STR_DRIVECHR & " can not be closed. " & @LF & "This error is maybe showed because some object blocks CD tray" & @LF & _
						"to close, CD tray is removed from system or" & @LF & "selected CD tray is a laptop-type tray which usually must be closed manually.", 30, 2)
			EndIf
			TraySetIcon($icons, 188)
		Case $gmsg = $closeall
			TraySetIcon($icons, 266)
			For $i = 1 To $disks[0]
				CDTray($disks[$i], "closed")
			Next
			TraySetIcon($icons, 188)
		Case $gmsg = $ejectall
			TraySetIcon($icons, 27)
			For $i = 1 To $disks[0]
				CDTray($disks[$i], "open")
			Next
			TraySetIcon($icons, 188)
		Case $gmsg = $drive
			MsgBox(64 + 4096, "Detail info about " & $STR_DRIVECHR, "Disk letter: " & $STR_DRIVECHR & ":" & @CRLF & "Serial number: " & DriveGetSerial($toclose) & @CRLF & _
					"Used space: " & Round(DriveSpaceTotal($toclose), 1) & "/700 MB." & @CRLF & "Label of drive: " & DriveGetLabel($toclose))
		Case $gmsg = $nextdrive
			Global $STR_DRIVECHR = StringUpper(StringTrimRight($toclose, 1))
			$l = _ArrayMax($disks)
			$a = _ArraySearch($disks, $toclose)
			If $toclose = $disks[$l] Then
				For $i = 1 To $disks[0]
					$toclose = $disks[$a - 1]
				Next
			Else
				$toclose = $disks[$a + 1]
			EndIf
			Global $STR_DRIVECHR = StringUpper(StringTrimRight($toclose, 1))
			TrayItemSetText($trayCurrent, "Current CD tray: " & $STR_DRIVECHR)
			GUICtrlSetData($drive, "Current drive is " & $STR_DRIVECHR)
		Case $gmsg = $quitbox
			GUISetState(@SW_HIDE, $gui)
		Case $gmsg = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE, $gui)
	EndSelect
WEnd
;=======UDF's====================
Func OnScriptExit()
	For $i = 1 To $disks[0]
		If DriveStatus($disks[$i]) = "READY" Then
			If MsgBox(48 + 4 + 4096, 'Warning', 'There was CD left in drive ' & StringUpper(StringTrimRight($disks[$i], 1)) & '.' & @CRLF & "Do you want to eject this drive?") = 6 Then CDTray($disks[$i], "open")
		EndIf
	Next
	If @exitCode >= 1 Then MsgBox(16, "CD Ejector", "Abnormal program termination")
EndFunc   ;==>OnScriptExit
Func _TipOfTheDay()
	Switch Random(1, 14, 1)
		Case 1
			$tip = "Playing with scissors can be dangerous!"
		Case 2
			$tip = "Most importrant product of creative mind is inventition."
		Case 3
			$tip = "CD Ejector will warn you if you forgot to take CD from the drive."
		Case 4
			$tip = "Try avoid reading boring books."
		Case 5
			$tip = "Make sure you're shut down your mobile phone before you enter airplane."
		Case 6
			$tip = "If you run too many processes, PC will slow down."
		Case 7
			$tip = "Don't skip breakfast"
		Case 8
			$tip = "Always make sure you saved file before closing MS Word/Talk2Me."
		Case 9
			$tip = "Your work will give best results if you close Office Assistant's help."
		Case 10
			$tip = "How to decide what is hardware? Simple. Take something and kick it. If you hear 'Hardware destroyed' sound from Windows, you know it is hardware."
		Case 11
			$tip = "For better sleeping, drink hot milk before you go to bed."
		Case 12
			$tip = "This is tip #12."
		Case 13
			$tip = "If you start fighting, you can go to jail"
		Case 14
			$tip = "If is text 'Current drive is: x' in red, it means there was no CD in drive. Else, text is coloured red."
	EndSwitch
	TrayTip("Tip of the day", $tip, 20, 1)
EndFunc   ;==>_TipOfTheDay
Func _WhereIsCD()
	If $state = "NOTREADY" Or $state = "UNKNOWN" Or $state = "INVALID" Then
		GUICtrlSetColor($drive, 0xFF0000)
		GUICtrlSetImage($iconstate, $icons, 27)
	Else
		GUICtrlSetColor($drive, 0x048041)
		$filesystem = DriveGetFileSystem($toclose)
		If $filesystem = "UDF" Then
			GUICtrlSetImage($iconstate, $icons, 113)
		Else
			GUICtrlSetImage($iconstate, $icons, 12)
		EndIf
	EndIf
EndFunc   ;==>_WhereIsCD