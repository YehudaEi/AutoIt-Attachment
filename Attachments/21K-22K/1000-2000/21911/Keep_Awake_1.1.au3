#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#NoTrayIcon

If Not FileExists(@TempDir & "Settings.kaf") Then
	$File = FileOpen(@TempDir & "Settings.kaf", 1)
	FileWriteLine($File, "Regular")
	FileWriteLine($File, "1")
	FileWriteLine($File, "")
	FileWriteLine($File, "left")
	FileWriteLine($File, "1")
	FileWriteLine($File, "|")
	FileClose($File)
EndIf

$TimeSet = 0
$File = FileOpen(@TempDir & "Settings.kaf", 0)
$TimeUse = FileReadLine($File, 1)
$TimeSave = FileReadLine($File, 2)
$CustomTimeSave = FileReadLine($File, 3)
$RadSelected = FileReadLine($File, 4)
$PixelSave = FileReadLine($File, 5)
$KeySave = FileReadLine($File, 6)
FileClose($File)

$Main = GUICreate("Keep Awake", 200, 250)
GUICtrlCreateTab(0, 0, 202, 252)
$MainTab = GUICtrlCreateTabItem("Main")
$Time1Rad = GUICtrlCreateRadio("Regular Time", 30, 30)
$Start = GUICtrlCreateButton("Start", 26, 170, 60, 30, $BS_DEFPUSHBUTTON)
$Cancel = GUICtrlCreateButton("Cancel", 113, 170, 60, 30)
$Time = GUICtrlCreateSlider(26, 75, 150, 40)
GUICtrlSetData($Time, $TimeSave)
$TimeLab = GUICtrlCreateLabel(" minutes", 72, 55, 100)
$Time2Rad = GUICtrlCreateRadio("Custom Time", 30, 115)
$CustomTimeInp = GUICtrlCreateInput($CustomTimeSave, 30, 140, 50)
$SecondsLab = GUICtrlCreateLabel("seconds", 90, 142)
GUICtrlSetLimit($Time, 10, 1)
$AboutLab1 = GUICtrlCreateLabel("Keep Awake by Minikori", 40, 210, 165)
$AboutLab2 = GUICtrlCreateLabel("Special thanks to Szhlopp and zorphnog", 4, 230, 200)
$CustomizeTab = GUICtrlCreateTabItem("Customize")
$ActionLab = GUICtrlCreateLabel("Action:", 20, 30)
$LeftRad = GUICtrlCreateRadio("Mouse Moves Left", 20, 50)
$TopRad = GUICtrlCreateRadio("Mouse Moves Up", 20, 70)
$UpDown = GUICtrlCreateInput("1", 150, 80, 35, 20)
$PixelUpDown = GUICtrlCreateUpdown($UpDown)
$RightRad = GUICtrlCreateRadio("Mouse Moves Right", 20, 90)
$BottomRad = GUICtrlCreateRadio("Mouse Moves Down", 20, 110)
$KeyRad = GUICtrlCreateRadio("Key Is Pressed", 20, 130)
$KeyCom = GUICtrlCreateCombo("", 20, 155, 110)
$SaveChk = GUICtrlCreateCheckbox("Save Changes", 20, 185)
Select
	Case $RadSelected = "left"
		GUICtrlSetState($LeftRad, $GUI_CHECKED)
	Case $RadSelected = "right"
		GUICtrlSetState($RightRad, $GUI_CHECKED)
	Case $RadSelected = "top"
		GUICtrlSetState($TopRad, $GUI_CHECKED)
	Case $RadSelected = "bottom"
		GUICtrlSetState($BottomRad, $GUI_CHECKED)
	Case $RadSelected = "key"
		GUICtrlSetState($KeyRad, $GUI_CHECKED)
EndSelect
GUISetIcon("shell32.dll", -28, $Main)
GUICtrlSetLimit($PixelUpDown, 9, 1)
GUICtrlSetLimit($UpDown, 1)
GUICtrlSetData($KeyCom, "1|2|3|4|5|6|7|8|9|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|SPACE|ENTER|BACKSPACE|DELETE|UP|DOWN|LEFT|RIGHT|HOME|END|ESCAPE|INSERT|PGUP|PGDN|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|TAB|PRINTSCREEN|LWIN|RWIN|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9", $KeySave)
GUICtrlSetData($CustomTimeInp, $CustomTimeSave)
GUICtrlSetData($UpDown, $PixelSave)
GUICtrlSetState($KeyCom, $GUI_DISABLE)
If $TimeUse = "Regular" Then
	GUICtrlSetState($Time1Rad, $GUI_CHECKED)
	GUICtrlSetState($SecondsLab, $GUI_DISABLE)
	GUICtrlSetState($CustomTimeInp, $GUI_DISABLE)
ElseIf $TimeUse = "Custom" Then
	GUICtrlSetState($Time2Rad, $GUI_CHECKED)
	GUICtrlSetState($TimeLab, $GUI_DISABLE)
	GUICtrlSetState($Time, $GUI_DISABLE)
EndIf
GUICtrlSetState($SaveChk, $GUI_CHECKED)

GUICtrlSetBkColor($Time, 0xFCFCFE)
GUISetState()
$TimeSetMem = ""
$CustomTimeMem = ""
While 1
	$msg = GUIGetMsg()
	$TimeSet = GUICtrlRead($Time)
	$CustomTimeSet = GUICtrlRead($CustomTimeInp)
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Cancel
			ExitLoop
		Case $msg = $Start
			Go()
		Case $TimeSet <> $TimeSetMem
			If $TimeSet = 1 Then
				GUICtrlSetData($TimeLab, $TimeSet & " minute")
				$TimeSetMem = $TimeSet
			Else
				GUICtrlSetData($TimeLab, $TimeSet & " minutes")
				$TimeSetMem = $TimeSet
			EndIf
		Case $CustomTimeSet <> $CustomTimeMem
			If $CustomTimeSet = 1 Then
				GUICtrlSetData($SecondsLab, "second")
				$CustomTimeMem = $CustomTimeSet
			Else
				GUICtrlSetData($SecondsLab, "seconds")
				$CustomTimeMem = $CustomTimeSet
			EndIf
		Case $msg = $LeftRad
			$RadSelected = "left"
			GUICtrlSetState($KeyCom, $GUI_DISABLE)
			GUICtrlSetState($UpDown, $GUI_ENABLE)
		Case $msg = $TopRad 
			$RadSelected = "top"
			GUICtrlSetState($KeyCom, $GUI_DISABLE)
			GUICtrlSetState($UpDown, $GUI_ENABLE)
		Case $msg = $RightRad
			$RadSelected = "right"
			GUICtrlSetState($KeyCom, $GUI_DISABLE)
			GUICtrlSetState($UpDown, $GUI_ENABLE)

		Case $msg = $BottomRad
			$RadSelected = "bottom"
			GUICtrlSetState($KeyCom, $GUI_DISABLE)
			GUICtrlSetState($UpDown, $GUI_ENABLE)
		Case $msg = $KeyRad
			$RadSelected = "key"
			GUICtrlSetState($KeyCom, $GUI_ENABLE)
			GUICtrlSetState($UpDown, $GUI_DISABLE)
		Case $msg = $Time1Rad
			$TimeUse = "Regular"
			GUICtrlSetState($CustomTimeInp, $GUI_DISABLE)
			GUICtrlSetState($SecondsLab, $GUI_DISABLE)
			GUICtrlSetState($TimeLab, $GUI_ENABLE)
			GUICtrlSetState($Time, $GUI_ENABLE)
		Case $msg = $Time2Rad
			$TimeUse = "custom"
			GUICtrlSetState($TimeLab, $GUI_DISABLE)
			GUICtrlSetState($Time, $GUI_DISABLE)
			GUICtrlSetState($CustomTimeInp, $GUI_ENABLE)
			GUICtrlSetState($SecondsLab, $GUI_ENABLE)
	EndSelect
WEnd
Exit

;------------------Functions------------------;

Func Go()
	$SaveVer = GUICtrlRead($SaveChk)
	If $SaveVer = $GUI_CHECKED Then
		$TimeSet = GUICtrlRead($Time)
		$CustomTimeSet = GUICtrlRead($CustomTimeInp)
		$Pixels = GUICtrlRead($UpDown)
		$KeySave = GUICtrlRead($KeyCom)
		_FileCreate(@TempDir & "Settings.kaf")
		$File = FileOpen(@TempDir & "Settings.kaf", 1)
		FileWriteLine($File, $TimeUse)
		FileWriteLine($File, $TimeSet)
		FileWriteLine($File, $CustomTimeSet)
		FileWriteLine($File, $RadSelected)
		FileWriteLine($File, $Pixels)
		FileWriteLine($File, $KeySave)
		FileClose($File)
	EndIf
	If $TimeUse = "Regular" Then
		If $RadSelected = "left" Or $RadSelected = "top" Or $RadSelected = "right" Or $RadSelected = "bottom" Then
			$TimeSet = GUICtrlRead($Time)
			$Pixels = GUICtrlRead($UpDown)
			If $TimeSet = 1 Then
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixel to the " & $RadSelected & " every minute. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixels to the " & $RadSelected & " every minute. Press Ctrl+Shift+E to exit.")
				EndIf
			Else
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixel to the " & $RadSelected & " every " & $TimeSet & " minutes. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixels to the " & $RadSelected & " every " & $TimeSet & " minutes. Press Ctrl+Shift+E to exit.")
				EndIf
			EndIf
			GUIDelete($Main)
			HotKeySet("^+e", "Quit")
			$SleepTime = $TimeSet * 60000
			While 1
				Sleep($SleepTime)
				$MousePos = MouseGetPos()
				If $RadSelected = "left" Then MouseMove($MousePos[0] - $Pixels, $MousePos[1])
				If $RadSelected = "top" Then MouseMove($MousePos[0], $MousePos[1] + $Pixels)
				If $RadSelected = "right" Then MouseMove($MousePos[0] + $Pixels, $MousePos[1])
				If $RadSelected = "bottom" Then MouseMove($MousePos[0], $MousePos[1] - $Pixels)
			WEnd
		EndIf
		If $RadSelected = "key" Then
			$Split = StringSplit("1|2|3|4|5|6|7|8|9|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|SPACE|ENTER|BACKSPACE|DELETE|UP|DOWN|LEFT|RIGHT|HOME|END|ESCAPE|INSERT|PGUP|PGDN|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|TAB|PRINTSCREEN|LWIN|RWIN|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9", "|")
			For $x = 1 To $Split[0]
				If GUICtrlRead($KeyCom) = $Split[$x] Then
					$KeyPress1 = StringLower($Split[$x])
					ExitLoop
				EndIf
			Next
			$TimeSet = GUICtrlRead($Time)
			If $TimeSet = 1 Then
				MsgBox(0, "Started", "The " & $KeyPress1 & " key will now be pressed every minute. Press Ctrl+Shift+E to exit.")
			Else
				MsgBox(0, "Started", "The " & $KeyPress1 & " key will now be pressed every " & $TimeSet & " minutes. Press Ctrl+Shift+E to exit.")
			EndIf
			GUIDelete($Main)
			HotKeySet("^+e", "Quit")
			$SleepTime = $TimeSet * 60000
			$KeyPress2 = "{" & $KeyPress1 & "}"
			While 1
				Sleep($SleepTime)
				Send($KeyPress2)
			WEnd
		EndIf
	EndIf
	If $TimeUse = "custom" Then
		If $RadSelected = "left" Or $RadSelected = "top" Or $RadSelected = "right" Or $RadSelected = "bottom" Then
			$TimeSet = GUICtrlRead($CustomTimeInp)
			$Pixels = GUICtrlRead($UpDown)
			If $TimeSet = 1 Then
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixel to the " & $RadSelected & " every second. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixels to the " & $RadSelected & " every second. Press Ctrl+Shift+E to exit.")
				EndIf
			Else
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixel to the " & $RadSelected & " every " & $TimeSet & " seconds. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now move " & $Pixels & " pixels to the " & $RadSelected & " every " & $TimeSet & " seconds. Press Ctrl+Shift+E to exit.")
				EndIf
			EndIf
			GUIDelete($Main)
			HotKeySet("^+e", "Quit")
			$SleepTime = $TimeSet * 1000
			While 1
				Sleep($SleepTime)
				$MousePos = MouseGetPos()
				If $RadSelected = "left" Then MouseMove($MousePos[0] - $Pixels, $MousePos[1])
				If $RadSelected = "top" Then MouseMove($MousePos[0], $MousePos[1] + $Pixels)
				If $RadSelected = "right" Then MouseMove($MousePos[0] + $Pixels, $MousePos[1])
				If $RadSelected = "bottom" Then MouseMove($MousePos[0], $MousePos[1] - $Pixels)
			WEnd
		EndIf
		If $RadSelected = "key" Then
			$Split = StringSplit("1|2|3|4|5|6|7|8|9|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|SPACE|ENTER|BACKSPACE|DELETE|UP|DOWN|LEFT|RIGHT|HOME|END|ESCAPE|INSERT|PGUP|PGDN|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|TAB|PRINTSCREEN|LWIN|RWIN|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9", "|")
			For $x = 1 To $Split[0]
				If GUICtrlRead($KeyCom) = $Split[$x] Then
					$KeyPress1 = StringLower($Split[$x])
					ExitLoop
				EndIf
			Next
			$TimeSet = GUICtrlRead($CustomTimeInp)
			If $TimeSet = 1 Then
				MsgBox(0, "Started", "The " & $KeyPress1 & " key will now be pressed every second. Press Ctrl+Shift+E to exit.")
			Else
				MsgBox(0, "Started", "The " & $KeyPress1 & " key will now be pressed every " & $TimeSet & " seconds. Press Ctrl+Shift+E to exit.")
			EndIf
			GUIDelete($Main)
			HotKeySet("^+e", "Quit")
			$SleepTime = $TimeSet * 1000
			$KeyPress2 = "{" & $KeyPress1 & "}"
			While 1
				Sleep($SleepTime)
				Send($KeyPress2)
			WEnd
		EndIf
	EndIf
EndFunc

While 1
	Sleep(100)
WEnd

Func Quit()
	Exit
EndFunc