;BinaryClock
#include <GUIConstants.au3>
#include <Date.au3>
HotKeySet("{ESC}", "_Terminate")
Func _Terminate()
	Exit
EndFunc   ;==>_Terminate
Dim $hour[4][4], $minute[7][4]
$Clock = GUICreate("BinaryClock    <Escape> to Exit", 210, 105, -1, -1, $WS_BORDER)
For $x = 0 To (UBound($hour) - 1)
	$hour[$x][0] = GUICtrlCreateGraphic (20 + ($x * 15), 10, 20, 20)
Next
For $x = 0 To (UBound($minute) - 1)
	$minute[$x][0] = GUICtrlCreateGraphic (10 + ($x * 15), 25, 20, 20)
Next
GUISetState()
While 1
	_GetTime()
	Sleep(10000)
WEnd
Func _GetTime()
	Dim $hour = @HOUR, $Min = @MIN
	If $hour >= 13 Then
		$PM = 1
	EndIf
	#region hour
	If $hour >= 8 Then
		$hour[0][1] = 1
		$hour -= 8
	EndIf
	If $hour >= 4 Then
		$hour[1][1] = 1
		$hour -= 4
	EndIf
	If $hour >= 2 Then
		$hour[2][1] = 1
		$hour -= 2
	EndIf
	If $hour >= 1 Then
		$hour[3][1] = 1
		$hour -= 1
	EndIf
	#endregion
	#region minute
	If $Min >= 32 Then
		$minute[0][1] = 1
		$Min -= 32
	EndIf
	If $Min >= 16 Then
		$minute[1][1] = 1
		$Min -= 16
	EndIf
	If $Min >= 8 Then
		$minute[2][1] = 1
		$Min -= 8
	EndIf
	If $Min >= 4 Then
		$minute[3][1] = 1
		$Min -= 4
	EndIf
	If $Min >= 2 Then
		$minute[5][1] = 1
		$Min -= 2
	EndIf
	If $Min >= 1 Then
		$minute[6][1] = 1
	EndIf
	#endregion minute
	_SetGUIGraphics()
EndFunc   ;==>_GetTime
Func _SetHour()
EndFunc   ;==>_SetHour
Func _SetGUIGraphics()
	For $x = 0 To (UBound($hour) - 1)
		If $hour[$x][1] Then
			GUICtrlSetGraphic ($hour[$x][0], $GUI_GR_COLOR, 0xff0000, 0xff0000) ;specifies a Red Dot filled with Red fill
		Else
			GUICtrlSetGraphic ($hour[$x][0], $GUI_GR_COLOR, 0x000000, 0xD4D0C8) ;specifies a Red Dot filled with Red fill
		EndIf
		GUICtrlSetGraphic ($hour[$x][0], $GUI_GR_ELLIPSE, 20 + ($x * 15), 10, 15, 15) ;Specifies the X, Y, and size of dot
		GUICtrlSetGraphic ($hour[$x][0], $GUI_GR_REFRESH)
	Next
	For $x = 0 To (UBound($minute) - 1)
		If $minute[$x][1] Then
			GUICtrlSetGraphic ($minute[$x][0], $GUI_GR_COLOR, 0xff0000, 0xff0000)
		Else
			GUICtrlSetGraphic ($minute[$x][0], $GUI_GR_COLOR, 0x000000, 0xD4D0C8)
		EndIf
		GUICtrlSetGraphic ($minute[$x][0], $GUI_GR_ELLIPSE, 20 + ($x * 15), 10, 15);, 15)
		GUICtrlSetGraphic ($minute[$x][0], $GUI_GR_REFRESH)
	Next
EndFunc   ;==>_SetGUIGraphics