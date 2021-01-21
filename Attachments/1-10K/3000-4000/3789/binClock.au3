;BinaryClock
#include <GUIConstants.au3>
#include <Date.au3>

HotKeySet("{ESC}", "_Terminate")
Func _Terminate()
	Exit
EndFunc

$Clock = GUICreate("BinaryClock    <Escape> to Exit", 150, 80, -1, -1, $WS_BORDER)
Dim $oldHour, $oldMin, $oldSec, $i
Dim $hSecElli[8], $hMinElli[8], $hHourElli[8]
$oldHour = -1
$oldMin = -1
$oldSec = -1
GUISetState()
Dim $loc
For $i = 0 to 7
	$loc = (-15 * $i) + 115
	$hHourElli[$i] = GUICtrlCreateGraphic($loc, 5, 20, 20)
	$hMinElli[$i] = GUICtrlCreateGraphic($loc, 20, 20, 20)
	$hSecElli[$i] = GUICtrlCreateGraphic($loc, 35, 20, 20)
Next


While 1
	_GetTime()
	Sleep(100)
WEnd


Func _GetTime()
	Dim $hour, $min, $sec
	$hour = @HOUR
	$min = @MIN
	$sec = @SEC
	_SetHour($hour)
	_SetMinute($min)
	_SetSec($sec)
EndFunc

Func _SetHour($hour)
	If $hour <> $oldHour Then
		$oldHour = $hour
		For $i = 0 to 7
			;$hHourElli[$i] = GUICtrlCreateGraphic((-15 * $i) + 450, 10, 20, 20)
			;MsgBox(0, "Debug", "Hour handle " & $i & ": " & $hHourElli[$i])
			If BitAND($hour, 1) = 0 Then
				GUICtrlSetGraphic($hHourElli[$i], $GUI_GR_COLOR, 0x000000, 0xD4D0C8)
			Else
				GUICtrlSetGraphic($hHourElli[$i], $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
			EndIf
			GUICtrlSetGraphic($hHourElli[$i], $GUI_GR_ELLIPSE, 5, 5, 10, 10)
			;GUICtrlSetGraphic($hHourElli[$i], $GUI_GR_REFRESH)	
			$hour = BitShift($hour, 1)
		Next
	EndIf
EndFunc

Func _SetMinute($min)
	If $min <> $oldMin Then
		$oldMin = $min
		For $i = 0 to 7
			;$hMinElli[$i] = GUICtrlCreateGraphic((-15 * $i) + 450, 25, 20, 20)
			If BitAND($min, 1) = 0 Then
				GUICtrlSetGraphic($hMinElli[$i], $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
			Else
				GUICtrlSetGraphic($hMinElli[$i], $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
			EndIf
			GUICtrlSetGraphic($hMinElli[$i], $GUI_GR_ELLIPSE, 5, 5, 10, 10) ;Specifies the X, Y, and size of dot
			;GUICtrlSetGraphic($hMinElli[$i], $GUI_GR_REFRESH)	
			$min = BitShift($min, 1)
		Next
	EndIf
EndFunc

Func _SetSec($sec)
	If $sec <> $oldSec Then
		$oldSec = $sec
		For $i = 0 to 7
			;$hSecElli[$i] = GUICtrlCreateGraphic((-15 * $i) + 450, 40, 20, 20)
			;MsgBox(0, "Debug", "sec handle " & $i & ": " & $hSecElli[$i])
			If BitAND($sec, 1) = 0 Then
				GUICtrlSetGraphic($hSecElli[$i], $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
			Else
				GUICtrlSetGraphic($hSecElli[$i], $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
			EndIf
			GUICtrlSetGraphic($hSecElli[$i], $GUI_GR_ELLIPSE, 5, 5, 10, 10) ;Specifies the X, Y, and size of dot
			$sec = BitShift($sec, 1)
		Next
		GUICtrlSetGraphic($hSecElli[$i-1], $GUI_GR_REFRESH)	
	EndIf
EndFunc