#include <GUIConstants.au3>
$var = WinList()
GUICreate("Set Trancperency", 400, 100)

$combo_win = GUICtrlCreateCombo("Pick a Window", 10, 10, 380)
For $i = 1 To $var[0][0] - 1
	If $var[$i][0] <> "" And IsVisible($var[$i][1]) Then
		GUICtrlSetData(-1, $var[$i][0])
	EndIf
Next

$slider1 = GUICtrlCreateSlider(50, 40, 300, 20)
GUISetBkColor(0x00E0FFFF)
GUICtrlSetLimit(-1, 255, 0)
GUICtrlSetData($slider1, 255)
$last = 255
$button = GUICtrlCreateButton("Set", 150, 70, 100, 20)

GUISetState()

While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $msg = $button And GUICtrlRead($combo_win) <> "Pick a Window" Then
		WinSetTrans(GUICtrlRead($combo_win), "", GUICtrlRead($slider1))
	EndIf
	$now = GUICtrlRead($slider1)
	If $now <> $last Then
		GUICtrlSetData($button, "Transperancy (" & $now & ")")
		$last = $now
	EndIf
	
WEnd

Func IsVisible($handle)
	If BitAND( WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible