#include-once
#include <GUIConstants.au3>

Global $pb_progress[2] = [0, 0], $pb_lbl1[2] = [0, 0], $pb_lbl2[2] = [0, 0], $pb_lbl3[2] = [0, 0], $pb_lbl4[2] = [0, 0]
Global $pb_x1[2] = [0, 0], $pb_x2[2] = [0, 0], $pb_x3[2] = [0, 0], $pb_x4[2] = [0, 0], $pb_y[2] = [0, 0], $pb_move[2] = [0, 0]
Global $pb_invertColor[2] = [0, 0], $pb_Color[2] = [0, 0], $pb_textColor[2] = [0, 0]
Global $pb_lblCC1[2] = [0, 0], $pb_lblCC2[2] = [0, 0], $pb_lblCC3[2] = [0, 0], $pb_lblCC4[2] = [0, 0]
Global $pb_backColor[2] = [0, 0]
Global $ThemesTurnedOff = 0
Func _Progress_Create($i_x, $i_y, $i_width, $i_height, $v_style = -1, _
	$v_pbbkcolor = -1, $v_pcolor = -1, $v_textcolor = -1, $v_invertcolor = -1)
	If Not $ThemesTurnedOff Then
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
		$ThemesTurnedOff = 1
	EndIf
	Local $index = $pb_progress[0] + 1
	_ReSizeArrays($index + 1)
	$pb_invertColor[$index] = '0x' & Hex(StringUpper(String($v_invertcolor)), 6)
	$pb_Color[$index] = '0x' & Hex(StringUpper(String($v_pcolor)), 6)
	If $v_style == -1 Then $v_style = 1
	If $v_pbbkcolor == -1 Then $v_pbbkcolor = 0xBEBEBE
	$pb_backColor[$index] = '0x' & Hex(StringUpper(String($v_pbbkcolor)), 6)
	If $v_pcolor == -1 Then $v_pcolor = 0x0000FF
	If $v_textcolor == -1 Then $v_textcolor = 0x000000
	$pb_textColor[$index] = '0x' & Hex(StringUpper(String($v_textcolor)), 6)
	$pb_lblCC1[$index] = $pb_textColor[$index]
	$pb_lblCC2[$index] = $pb_textColor[$index]
	$pb_lblCC3[$index] = $pb_textColor[$index]
	$pb_lblCC4[$index] = $pb_textColor[$index]
	If $v_invertcolor == -1 Then $v_invertcolor = 0xFFFFFF
	$pb_x1[$index] = ($i_width / 2) + ($i_x / 2) - 2
	$pb_x2[$index] = $pb_x1[$index] + 6
	$pb_x3[$index] = $pb_x1[$index] + 12
	$pb_x4[$index] = $pb_x1[$index] + 18
	$pb_y[$index] = $i_y + 2
	$pb_move[$index] = 0
	$pb_progress[$index] = GUICtrlCreateProgress($i_x, $i_y, $i_width, $i_height, $v_style)
	GUICtrlSetColor($pb_progress[$index], $v_pcolor); not working with Windows XP Style
	GUICtrlSetBkColor($pb_progress[$index], $v_pbbkcolor)
	$pb_lbl1[$index] = GUICtrlCreateLabel("0", $pb_x1[$index], $pb_y[$index], 7, $i_height - 4, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetFont($pb_lbl1[$index], -1, 400)
	GUICtrlSetColor($pb_lbl1[$index], $pb_textColor[$index])
	$pb_lbl2[$index] = GUICtrlCreateLabel("0", $pb_x2[$index], $pb_y[$index], 7, $i_height - 4, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetFont($pb_lbl2[$index], -1, 400)
	GUICtrlSetColor($pb_lbl2[$index], $pb_textColor[$index])
	GUICtrlSetState($pb_lbl2[$index], $GUI_HIDE)
	$pb_lbl3[$index] = GUICtrlCreateLabel("0", $pb_x3[$index], $pb_y[$index], 7, $i_height - 4, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetFont($pb_lbl3[$index], -1, 400)
	GUICtrlSetColor($pb_lbl3[$index], $pb_textColor[$index])
	GUICtrlSetState($pb_lbl3[$index], $GUI_HIDE)
	$pb_lbl4[$index] = GUICtrlCreateLabel("%", $pb_x2[$index], $pb_y[$index], 12, $i_height - 4, -1, $WS_EX_TRANSPARENT)
	GUICtrlSetFont($pb_lbl4[$index], -1, 400)
	GUICtrlSetColor($pb_lbl4[$index], $pb_textColor[$index])
	Return $pb_progress[$index]
EndFunc   ;==>_Progress_Create


Func _Progress_Update($h_pbID, $i_percent)
	Local $i, $index
	For $i = 1 To $pb_progress[0]
		If $h_pbID = $pb_progress[$i] Then
			$index = $i
			ExitLoop
		EndIf
	Next
	If $i_percent >= 10 And $i_percent < 100 And $pb_move[$index] == 0 Then
;~ 		ConsoleWrite("Here 1" & @LF)
		$pb_move[$index] = 1
		GUICtrlSetState($pb_lbl2[$index], $GUI_SHOW)
		GUICtrlSetPos($pb_lbl4[$index], $pb_x3[$index], $pb_y[$index])
	ElseIf $i_percent == 100 And $pb_move[$index] == 1 Then
;~ 		ConsoleWrite("Here 2" & @LF)
		$pb_move[$index] = 2
		GUICtrlSetState($pb_lbl3[$index], $GUI_SHOW)
		GUICtrlSetPos($pb_lbl4[$index], $pb_x4[$index], $pb_y[$index])
	ElseIf $pb_move[$index] == 2 Then
;~ 		ConsoleWrite("Here 3" & @LF)
		$pb_move[$index] = 0
		GUICtrlSetState($pb_lbl2[$index], $GUI_HIDE)
		GUICtrlSetState($pb_lbl3[$index], $GUI_HIDE)
		GUICtrlSetColor($pb_lbl1[$index], $pb_textColor[$index])
		GUICtrlSetColor($pb_lbl2[$index], $pb_textColor[$index])
		GUICtrlSetColor($pb_lbl3[$index], $pb_textColor[$index])
		GUICtrlSetColor($pb_lbl4[$index], $pb_textColor[$index])
		GUICtrlSetPos($pb_lbl4[$index], $pb_x2[$index], $pb_y[$index])
	ElseIf $i_percent == 100 And $pb_move[$index] == 0 Then
;~ 		ConsoleWrite("Here 4" & @LF)
		$pb_move[$index] = 3
		GUICtrlSetState($pb_lbl2[$index], $GUI_SHOW)
		GUICtrlSetState($pb_lbl3[$index], $GUI_SHOW)
		GUICtrlSetPos($pb_lbl4[$index], $pb_x4[$index], $pb_y[$index])
	ElseIf $i_percent >= 10 And $i_percent < 100 And $pb_move[$index] == 3 Then
;~ 		ConsoleWrite("Here 5" & @LF)
		$pb_move[$index] = 4
		GUICtrlSetState($pb_lbl3[$index], $GUI_HIDE)
		GUICtrlSetPos($pb_lbl4[$index], $pb_x3[$index], $pb_y[$index])
	ElseIf $i_percent > 0 And $i_percent < 10 And $pb_move[$index] == 4 Then
;~ 		ConsoleWrite("Here 6" & @LF)
		$pb_move[$index] = 5
		GUICtrlSetState($pb_lbl2[$index], $GUI_HIDE)
		GUICtrlSetPos($pb_lbl4[$index], $pb_x2[$index], $pb_y[$index])
	ElseIf $pb_move[$index] == 5 Then
;~ 		ConsoleWrite("Here 7" & @LF)
		$pb_move[$index] = 0
	EndIf
	GUICtrlSetData($pb_progress[$index], $i_percent)
	$pcm = Opt ("PixelCoordMode", 2)
	$c1 = '0x' & Hex(PixelGetColor($pb_x1[$index], $pb_y[$index]), 6)
	$c2 = '0x' & Hex(PixelGetColor($pb_x2[$index], $pb_y[$index]), 6)
	$c3 = '0x' & Hex(PixelGetColor($pb_x3[$index], $pb_y[$index]), 6)
	$c4 = '0x' & Hex(PixelGetColor($pb_x4[$index], $pb_y[$index]), 6)
	If $c1 == $pb_Color[$index] And $pb_lblCC1[$index] <> $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 8" & @LF)
		GUICtrlSetColor($pb_lbl1[$index], $pb_invertColor[$index])
		$pb_lblCC1[$index] = $pb_invertColor[$index]
	ElseIf $c1 == $pb_backColor[$index] And $pb_lblCC1[$index] == $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 9" & @LF)
		GUICtrlSetColor($pb_lbl1[$index], $pb_textColor[$index])
		$pb_lblCC1[$index] = $pb_textColor[$index]
	EndIf
	If $c2 == $pb_Color[$index] And $pb_lblCC2[$index] <> $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 10" & @LF)
		GUICtrlSetColor($pb_lbl2[$index], $pb_invertColor[$index])
		$pb_lblCC2[$index] = $pb_invertColor[$index]
	ElseIf $c2 == $pb_backColor[$index] And $pb_lblCC2[$index] == $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 11" & @LF)
		GUICtrlSetColor($pb_lbl2[$index], $pb_textColor[$index])
		$pb_lblCC2[$index] = $pb_textColor[$index]
	EndIf
	If $c3 == $pb_Color[$index] And $pb_lblCC3[$index] <> $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 12" & @LF)
		GUICtrlSetColor($pb_lbl3[$index], $pb_invertColor[$index])
		$pb_lblCC3[$index] = $pb_invertColor[$index]
	ElseIf $c3 == $pb_backColor[$index] And $pb_lblCC3[$index] == $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 13" & @LF)
		GUICtrlSetColor($pb_lbl3[$index], $pb_textColor[$index])
		$pb_lblCC3[$index] = $pb_textColor[$index]
	EndIf
	If $c4 == $pb_Color[$index] And $pb_lblCC4[$index] <> $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 14" & @LF)
		GUICtrlSetColor($pb_lbl4[$index], $pb_invertColor[$index])
		$pb_lblCC4[$index] = $pb_invertColor[$index]
	ElseIf $c4 == $pb_backColor[$index] And $pb_lblCC4[$index] == $pb_invertColor[$index] Then
;~ 		ConsoleWrite("Here 15" & @LF)
		GUICtrlSetColor($pb_lbl4[$index], $pb_textColor[$index])
		$pb_lblCC4[$index] = $pb_textColor[$index]
	EndIf
	Opt ("PixelCoordMode", $pcm)
	Local $p = StringSplit(String($i_percent), "")
	Select
		Case $p[0] = 1
			GUICtrlSetData($pb_lbl1[$index], $p[1])
		Case $p[0] = 2
			GUICtrlSetData($pb_lbl1[$index], $p[1])
			GUICtrlSetData($pb_lbl2[$index], $p[2])
		Case $p[0] = 3
			GUICtrlSetData($pb_lbl1[$index], $p[1])
			GUICtrlSetData($pb_lbl2[$index], $p[2])
			GUICtrlSetData($pb_lbl3[$index], $p[3])
		EndSelect
		GUICtrlSetState($pb_lbl4[$index], $GUI_SHOW)
EndFunc   ;==>_Progress_Update

Func _ReSizeArrays($i_index)
	ReDim $pb_progress[$i_index]
	$pb_progress[0] = UBound($pb_progress) - 1
	ReDim $pb_invertColor[$i_index]
	ReDim $pb_lbl1[$i_index]
	ReDim $pb_lbl2[$i_index]
	ReDim $pb_lbl3[$i_index]
	ReDim $pb_lbl4[$i_index]
	ReDim $pb_x1[$i_index]
	ReDim $pb_x2[$i_index]
	ReDim $pb_x3[$i_index]
	ReDim $pb_x4[$i_index]
	ReDim $pb_y[$i_index]
	ReDim $pb_move[$i_index]
	ReDim $pb_textColor[$i_index]
	ReDim $pb_Color[$i_index]
	ReDim $pb_lblCC1[$i_index]
	ReDim $pb_lblCC2[$i_index]
	ReDim $pb_lblCC3[$i_index]
	ReDim $pb_lblCC4[$i_index]
	ReDim $pb_backColor[$i_index]
EndFunc   ;==>_ReSizeArrays

#include <Array.au3>

Func _Progress_Delete(ByRef $a_progress, $h_pbID)
		Local $i, $index
		For $i = 1 To $pb_progress[0]
			If $h_pbID = $pb_progress[$i] Then
				$index = $i
				ExitLoop
			EndIf
		Next
		_ArrayDelete($pb_invertColor, $index)
		_ArrayDelete($pb_x1, $index)
		_ArrayDelete($pb_x2, $index)
		_ArrayDelete($pb_x3, $index)
		_ArrayDelete($pb_x4, $index)
		_ArrayDelete($pb_y, $index)
		_ArrayDelete($pb_move, $index)
		_ArrayDelete($pb_Color, $index)
		_ArrayDelete($pb_textColor, $index)
		_ArrayDelete($pb_lblCC1, $index)
		_ArrayDelete($pb_lblCC2, $index)
		_ArrayDelete($pb_lblCC3, $index)
		_ArrayDelete($pb_lblCC4, $index)
		_ArrayDelete($pb_backColor, $index)
		GUICtrlDelete($pb_progress[$index])
		_ArrayDelete($pb_progress, $index)
		$pb_progress[0] = $pb_progress[0] - 1
		GUICtrlDelete($pb_lbl1[$index])
		_ArrayDelete($pb_lbl1, $index)
		GUICtrlDelete($pb_lbl2[$index])
		_ArrayDelete($pb_lbl2, $index)
		GUICtrlDelete($pb_lbl3[$index])
		_ArrayDelete($pb_lbl3, $index)
		GUICtrlDelete($pb_lbl4[$index])
		_ArrayDelete($pb_lbl4, $index)
	If IsArray($a_progress) Then
		For $i = 0 To UBound($a_progress) - 1
			If $h_pbID = $a_progress[$i] Then
				$index = $i
				ExitLoop
			EndIf
		Next
		_ArrayDelete($a_progress, $index)
		If @error == 2 Then $a_progress = 0
	EndIf
EndFunc   ;==>_Progress_Delete