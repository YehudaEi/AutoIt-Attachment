;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Unit:		  Keep_Awake 1.2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Posted: 		  23 AUG 2008
;; Author: 		  Minikori
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Last Modified: 08 MAR 2011
;; Modified By:	  bspkrs
;; Comments:	  Redesigned GUI for conciseness, usability, and formatting.
;;				  Replaced mouse direction options with a single option to
;;				  "jiggle" the mouse by a selected number of pixels.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#NoTrayIcon

If Not FileExists(@TempDir & "Settings.kaf") Then
	$File = FileOpen(@TempDir & "Settings.kaf", 1)
	FileWriteLine($File, "Regular")
	FileWriteLine($File, "1")
	FileWriteLine($File, "")
	FileWriteLine($File, "jiggle")
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

#Region ### START Koda GUI section ### Form=ka_1.2.kxf
$Main = GUICreate("Keep Awake", 346, 210, 272, 236)
$grpTime = GUICtrlCreateGroup("Time", 4, 0, 169, 169)
$TimeLab = GUICtrlCreateLabel("minutes", 64, 47, 100, 12)
$Time = GUICtrlCreateSlider(18, 67, 150, 40)
GUICtrlSetLimit($Time, 10, 1)
GUICtrlSetData($Time, $TimeSave)
$Time2Rad = GUICtrlCreateRadio("Custom Time", 20, 107, 113, 17)
$SecondsLab = GUICtrlCreateLabel("seconds", 76, 135, 44, 17)
$CustomTimeInp = GUICtrlCreateInput("CustomTimeSave", 22, 132, 50, 21)
$Time1Rad = GUICtrlCreateRadio("Regular Time", 20, 22, 113, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grpAction = GUICtrlCreateGroup("Action", 180, 0, 161, 169)
$JiggleRad = GUICtrlCreateRadio("Mouse Jiggles", 196, 22, 113, 17)
$UpDown = GUICtrlCreateInput("0", 214, 48, 50, 21)
$PixelUpDown = GUICtrlCreateUpdown($UpDown)
$labPx = GUICtrlCreateLabel("px", 268, 52, 15, 17)
$KeyRad = GUICtrlCreateRadio("Key Is Pressed", 196, 82, 113, 17)
$KeyCom = GUICtrlCreateCombo("", 196, 107, 110, 25)
$SaveChk = GUICtrlCreateCheckbox("Save Changes", 196, 137, 105, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$AboutLab1 = GUICtrlCreateLabel("Keep Awake by Minikori (modded by bspkrs)", 4, 173, 213, 16)
$AboutLab2 = GUICtrlCreateLabel("Special thanks to Szhlopp and zorphnog", 4, 190, 200, 16)
$Start = GUICtrlCreateButton("Start", 218, 172, 60, 30, $BS_DEFPUSHBUTTON)
$Cancel = GUICtrlCreateButton("Cancel", 281, 172, 60, 30, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Select
	Case $RadSelected = "jiggle"
		GUICtrlSetState($JiggleRad, $GUI_CHECKED)
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
		Case $msg = $JiggleRad
			$RadSelected = "jiggle"
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
		If $RadSelected = "jiggle" Then
			$TimeSet = GUICtrlRead($Time)
			$Pixels = GUICtrlRead($UpDown)
			If $TimeSet = 1 Then
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixel every minute. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixels every minute. Press Ctrl+Shift+E to exit.")
				EndIf
			Else
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixel every " & $TimeSet & " minutes. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixels every " & $TimeSet & " minutes. Press Ctrl+Shift+E to exit.")
				EndIf
			EndIf
			GUIDelete($Main)
			HotKeySet("^+e", "Quit")
			$SleepTime = $TimeSet * 60000
			While 1
				Sleep($SleepTime)
				$MousePos = MouseGetPos()
				MouseMove($MousePos[0] + $Pixels, $MousePos[1] + $Pixels, 2)
				MouseMove($MousePos[0] - $Pixels, $MousePos[1] - $Pixels, 2)
				MouseMove($MousePos[0], $MousePos[1], 2)
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
		If $RadSelected = "jiggle" Then
			$TimeSet = GUICtrlRead($CustomTimeInp)
			$Pixels = GUICtrlRead($UpDown)
			If $TimeSet = 1 Then
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixel every second. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixels every second. Press Ctrl+Shift+E to exit.")
				EndIf
			Else
				If $Pixels = 1 Then
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixel every " & $TimeSet & " seconds. Press Ctrl+Shift+E to exit.")
				Else
					MsgBox(0, "Started", "The mouse will now jiggle " & $Pixels & " pixels every " & $TimeSet & " seconds. Press Ctrl+Shift+E to exit.")
				EndIf
			EndIf
			GUIDelete($Main)
			HotKeySet("^+e", "Quit")
			$SleepTime = $TimeSet * 1000
			While 1
				Sleep($SleepTime)
				$MousePos = MouseGetPos()
				MouseMove($MousePos[0] + $Pixels, $MousePos[1] + $Pixels, 2)
				MouseMove($MousePos[0] - $Pixels, $MousePos[1] - $Pixels, 2)
				MouseMove($MousePos[0], $MousePos[1], 2)
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
