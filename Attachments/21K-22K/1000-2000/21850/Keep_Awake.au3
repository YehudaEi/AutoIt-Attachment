#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

$TimeSet = 0

$Main = GUICreate("Keep Awake", 200, 185)
GUICtrlCreateTab(0, 0, 202, 187)
$MainTab = GUICtrlCreateTabItem("Main")
$Start = GUICtrlCreateButton("Start", 26, 100, 60, 30)
$Cancel = GUICtrlCreateButton("Cancel", 113, 100, 60, 30)
$Time = GUICtrlCreateSlider(26, 50, 150, 40)
$TimeLab = GUICtrlCreateLabel($TimeSet & " minutes", 72, 30)
GUICtrlSetLimit($Time, 10, 1)
$AboutLab1 = GUICtrlCreateLabel("Keep Awake by Minikori", 40, 140, 165)
$AboutLab2 = GUICtrlCreateLabel("Special thanks to Szhlopp", 36, 160, 165)
$CustomizeTab = GUICtrlCreateTabItem("Customize")
$ActionLab = GUICtrlCreateLabel("Action:", 20, 30)
$LeftRad = GUICtrlCreateRadio("Mouse Moves Left", 20, 50)
GUICtrlSetState($LeftRad, $GUI_CHECKED)
$TopRad = GUICtrlCreateRadio("Mouse Moves Up", 20, 70)
$RightRad = GUICtrlCreateRadio("Mouse Moves Right", 20, 90)
$BottomRad = GUICtrlCreateRadio("Mouse Moves Down", 20, 110)
$KeyRad = GUICtrlCreateRadio("Key Is Pressed", 20, 130)
$KeyCom = GUICtrlCreateCombo("", 20, 155, 110)
GUICtrlSetData($KeyCom, "1|2|3|4|5|6|7|8|9|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|ENTER|BACKSPACE|DELETE|UP|DOWN|LEFT|RIGHT|HOME|END|ESCAPE|INSERT|PGUP|PGDN|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|TAB|PRINTSCREEN|LWIN|RWIN|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9", "|")
GUICtrlSetState($KeyCom, $GUI_DISABLE)

GUICtrlSetBkColor($Time, 0xFCFCFE)
GUISetState()
$TimeSetMem = ""
$RadSelected = "left"
While 1
	$msg = GUIGetMsg()
	$TimeSet = GUICtrlRead($Time)
	If $msg = $GUI_EVENT_CLOSE Or $msg = $Cancel Then
		ExitLoop
	EndIf
	If $msg = $Start Then
		Call("Go")
	EndIf
	If $TimeSet<>$TimeSetMem Then
		If $TimeSet = 1 Then
			GUICtrlSetData($TimeLab, $TimeSet & " minute")
			$TimeSetMem = $TimeSet
		Else
			GUICtrlSetData($TimeLab, $TimeSet & " minutes")
			$TimeSetMem = $TimeSet
		EndIf
	EndIf
	If $msg = $LeftRad Then
		$RadSelected = "left"
		GUICtrlSetState($KeyCom, $GUI_DISABLE)
	EndIf
	If $msg = $TopRad Then 
		$RadSelected = "top"
		GUICtrlSetState($KeyCom, $GUI_DISABLE)
	EndIf
	If $msg = $RightRad Then
		$RadSelected = "right"
		GUICtrlSetState($KeyCom, $GUI_DISABLE)
	EndIf
	If $msg = $BottomRad Then
		$RadSelected = "bottom"
		GUICtrlSetState($KeyCom, $GUI_DISABLE)
	EndIf
	If $msg = $KeyRad Then
		GUICtrlSetState($KeyCom, $GUI_ENABLE)
		$RadSelected = "key"
	EndIf
WEnd
Exit

;------------------Functions------------------;

Func Go()
	If $RadSelected = "left" Or $RadSelected = "top" Or $RadSelected = "right" Or $RadSelected = "bottom" Then
		$TimeSet = GUICtrlRead($Time)
		If $TimeSet = 1 Then
			MsgBox(0, "Started", "The mouse will now move 1 pixel to the " & $RadSelected & " every minute. Press Ctrl+Shift+E to exit.")
		Else
			MsgBox(0, "Started", "The mouse will now move 1 pixel to the " & $RadSelected & " every " & $TimeSet & " minutes. Press Ctrl+Shift+E to exit.")
		EndIf
		GUIDelete($Main)
		HotKeySet("^+e", "Quit")
		$SleepTime = $TimeSet * 60000
		While 1
			Sleep($SleepTime)
			$MousePos = MouseGetPos()
			If $RadSelected = "left" Then MouseMove($MousePos[0] - 1, $MousePos[1])
			If $RadSelected = "top" Then MouseMove($MousePos[0], $MousePos[1] + 1)
			If $RadSelected = "right" Then MouseMove($MousePos[0] + 1, $MousePos[1])
			If $RadSelected = "bottom" Then MouseMove($MousePos[0], $MousePos[1] - 1)
		WEnd
	EndIf
	If $RadSelected = "key" Then
		$Split = StringSplit("1|2|3|4|5|6|7|8|9|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|ENTER|BACKSPACE|DELETE|UP|DOWN|LEFT|RIGHT|HOME|END|ESCAPE|INSERT|PGUP|PGDN|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|TAB|PRINTSCREEN|LWIN|RWIN|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9", "|")
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
EndFunc

While 1
	Sleep(100)
WEnd

While 1
	Sleep(100)
WEnd

Func Quit()
	Exit
EndFunc