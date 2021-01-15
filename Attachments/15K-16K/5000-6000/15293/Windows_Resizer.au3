#include<GUIConstants.au3>
#include<misc.au3>
If _Singleton("Windows Resizer", 1) = 0 Then
	Exit
EndIf
Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode", 2)
Opt("TrayMenuMode", 3)
Opt("GUICloseOnEsc", 0)
Global $Title = ""
Global $Value = 0
Global $Pos1, $Pos2, $w, $h
$gui = GUICreate("Windows Resizer", 215, 58, -1, -1, -1)
$input = GUICtrlCreateInput("Your Windows Title", 2, 3, 210, 20)
$button = GUICtrlCreateButton("Capture", 5, 25, 100, 30)
$button0 = GUICtrlCreateButton("Resize", 110, 25, 100, 30)
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
GUICtrlSetOnEvent($button, "_Capture")
GUICtrlSetOnEvent($button0, "_Resize")
GUICtrlSetLimit($input, 200)
GUICtrlSetTip($input, "Ctrl+Left Click to get Windows Title", "Help", 1, 1)
GUICtrlSetFont($button, 9, 400, 0, "Tahoma")
GUICtrlSetFont($button0, 9, 400, 0, "Tahoma")
GUICtrlSetFont($input, 9, 400, 0, "Tahoma")
GUISetFont(9, 400, 0, "Tahoma")
GUICtrlSetState($button0, $GUI_DISABLE)
GUISetState()
WinSetOnTop($gui, "", 1)
While 1
	_Check()
	If _IsPressed("01") And _IsPressed("A2") Then
		$Winlist = WinList()
		For $list = 1 To $Winlist[0][0]
			If WinActive($Winlist[$list][1]) Then
				$WinTitle = $Winlist[$list][0]
			EndIf
		Next
		ControlFocus($gui, "", "Edit1")
		ControlSetText($gui, "", "Edit1", $WinTitle)
	EndIf
	Sleep(100)
WEnd
Func Quit()
	Exit
EndFunc   ;==>Quit
Func _ToolTip()
	ToolTip($Title & " was not found", Default, Default, "Windows Resizer", 1, 1)
	Sleep(500)
	ToolTip("")
EndFunc   ;==>_ToolTip
Func _Check()
	$Title = GUICtrlRead($input)
	Return $Title
EndFunc   ;==>_Check
Func _Capture()
	GUICtrlSetState($button, $GUI_DISABLE)
	GUICtrlSetState($button0, $GUI_DISABLE)
	Do
		Sleep(1)
	Until _IsPressed("01")
	If _IsPressed("01") Then
		$Pos1 = MouseGetPos()
		Do
			$currentpos = MouseGetPos()
			ToolTip($currentpos[0] & "," & $currentpos[1])
		Until Not _IsPressed("01")
		ToolTip("")
		$Pos2 = MouseGetPos()
		If $Pos2[0] < $Pos1[0] Then
			_Reverse()
			$Value = 0
		Else
			_Normal()
			$Value = 1
		EndIf
	EndIf
	GUICtrlSetState($button, $GUI_ENABLE)
	GUICtrlSetState($button0, $GUI_ENABLE)
EndFunc   ;==>_Capture
Func _Normal()
	$w = $Pos2[0] - $Pos1[0]
	$h = $Pos2[1] - $Pos1[1]
EndFunc   ;==>_Normal
Func _Reverse()
	$w = $Pos1[0] - $Pos2[0]
	$h = $Pos1[1] - $Pos2[1]
EndFunc   ;==>_Reverse
Func _Resize()
	If Not WinExists($Title, "") Then
		_ToolTip()
		Return
	EndIf
	If Not $Value Then
		WinMove($Title, "", $Pos2[0], $Pos2[1], $w, $h)
	Else
		WinMove($Title, "", $Pos1[0], $Pos1[1], $w, $h)
	EndIf
EndFunc   ;==>_Resize