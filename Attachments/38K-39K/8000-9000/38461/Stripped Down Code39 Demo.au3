#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

Local $AllowedCode39 = StringSplit("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%", ""), $Code39HorInc = 1, $Code39Hor

$Code39 = "test of code39"

If _VerifyCode39($Code39) == True Then
	$BC = GUICreate("Label Image", 384, 155, 1, 1)
	GUISetBkColor(0xffffff, $BC)
	GUISetFont(Default, Default, Default, "Arial")
	$BarcodeDigitsDisplay = GUICtrlCreateLabel(StringUpper($Code39), 5, 105, 380, 20, $SS_CENTER)
	GUICtrlSetFont($BarcodeDigitsDisplay, 11, 400, 0, "Verdana")
	$BCBox = GUICtrlCreateGraphic(4, 75, 380, 33)
	GUICtrlSetGraphic($BCBox, $GUI_GR_PENSIZE, 1)
	GUICtrlSetGraphic($BCBox, $GUI_GR_COLOR, 0)
	_BarCode39($Code39)
	GUISetState(@SW_SHOW, $BC)
	Do
		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then Exit
	Until True == False
EndIf

Func _VerifyCode39($sCode39)
	If $sCode39 == "" Then
		MsgBox(48, "ERROR", "You have not provided a Code 39 code.")
		Return False
	EndIf
	$Break = StringSplit(StringUpper($sCode39), "")
	If $Break[0] > 16 Then
		MsgBox(48, "ERROR", "You have too many characters in the provided Code 39 code.  Maximum length is 16 characters.")
		Return False
	EndIf
	For $a = 1 To $Break[0]
		$GoodChar = False
		For $b = 1 To $AllowedCode39[0]
			If $Break[$a] == $AllowedCode39[$b] Then $GoodChar = True
		Next
		If $GoodChar == False Then
			MsgBox(48, "ERROR, Character " & $a & "-> " & Chr(34) & $Break[$a] & Chr(34), "You have an illegal character in the provided Code 39 code.  Allowed characters are:" & @CR & @CR & "0-9" & @TAB & "(numbers)" & @CR & "A-Z" & @TAB & "(letters)" & @CR & "-" & @TAB & "(hyphen, minus, dash)" & @CR & "." & @TAB & "(period)" & @CR & " " & @TAB & "(space)" & @CR & "$" & @TAB & "(dollar)" & @CR & "/" & @TAB & "(forward slash, divide)" & @CR & "+" & @TAB & "(plus)" & @CR & "%" & @TAB & "(percent)")
			Return False
		EndIf
	Next
	Return True
EndFunc   ;==>_VerifyCode39


Func _BarCode39($ThisCode)
	;		B = 3 black
	;		b = 1 black
	;		W = 3 white
	;		w = 1 white
	$Code39Hor = 5
	$CodeBreak = StringSplit(StringUpper($ThisCode), "")
	$Diff = (16 - $CodeBreak[0]) * 10 ;		max char = 16, find diff and * 10 since each char is 19.8 pixels
	$Code39Hor += $Diff

	_Draw39("bWbwBwBwb") ;		start (*)
	$Code39Hor += $Code39HorInc * 2
	For $a = 1 To $CodeBreak[0]
		If $CodeBreak[$a] == "0" Then _Draw39("bwbWBwBwb")
		If $CodeBreak[$a] == "1" Then _Draw39("BwbWbwbwB")
		If $CodeBreak[$a] == "2" Then _Draw39("bwBWbwbwB")
		If $CodeBreak[$a] == "3" Then _Draw39("BwBWbwbwb")
		If $CodeBreak[$a] == "4" Then _Draw39("bwbWBwbwB")
		If $CodeBreak[$a] == "5" Then _Draw39("BwbWBwbwb")
		If $CodeBreak[$a] == "6" Then _Draw39("bwBWBwbwb")
		If $CodeBreak[$a] == "7" Then _Draw39("bwbWbwBwB")
		If $CodeBreak[$a] == "8" Then _Draw39("BwbWbwBwb")
		If $CodeBreak[$a] == "9" Then _Draw39("bwBWbwBwb")
		If $CodeBreak[$a] == "A" Then _Draw39("BwbwbWbwB")
		If $CodeBreak[$a] == "B" Then _Draw39("bwBwbWbwB")
		If $CodeBreak[$a] == "C" Then _Draw39("BwBwbWbwb")
		If $CodeBreak[$a] == "D" Then _Draw39("bwbwBWbwB")
		If $CodeBreak[$a] == "E" Then _Draw39("BwbwBWbwb")
		If $CodeBreak[$a] == "F" Then _Draw39("bwBwBWbwb")
		If $CodeBreak[$a] == "G" Then _Draw39("bwbwbWBwB")
		If $CodeBreak[$a] == "H" Then _Draw39("BwbwbWBwb")
		If $CodeBreak[$a] == "I" Then _Draw39("bwBwbWBwb")
		If $CodeBreak[$a] == "J" Then _Draw39("bwbwBWBwb")
		If $CodeBreak[$a] == "K" Then _Draw39("BwbwbwbWB")
		If $CodeBreak[$a] == "L" Then _Draw39("bwBwbwbWB")
		If $CodeBreak[$a] == "M" Then _Draw39("BwBwbwbWb")
		If $CodeBreak[$a] == "N" Then _Draw39("bwbwBwbWB")
		If $CodeBreak[$a] == "O" Then _Draw39("BwbwBwbWb")
		If $CodeBreak[$a] == "P" Then _Draw39("bwBwBwbWb")
		If $CodeBreak[$a] == "Q" Then _Draw39("bwbwbwBWB")
		If $CodeBreak[$a] == "R" Then _Draw39("BwbwbwBWb")
		If $CodeBreak[$a] == "S" Then _Draw39("bwBwbwBWb")
		If $CodeBreak[$a] == "T" Then _Draw39("bwbwBwBWb")
		If $CodeBreak[$a] == "U" Then _Draw39("BWbwbwbwB")
		If $CodeBreak[$a] == "V" Then _Draw39("bWBwbwbwB")
		If $CodeBreak[$a] == "W" Then _Draw39("BWBwbwbwb")
		If $CodeBreak[$a] == "X" Then _Draw39("bWbwBwbwB")
		If $CodeBreak[$a] == "Y" Then _Draw39("BWbwBwbwb")
		If $CodeBreak[$a] == "Z" Then _Draw39("bWBwBwbwb")
		If $CodeBreak[$a] == "-" Then _Draw39("bWbwbwBwB")
		If $CodeBreak[$a] == "." Then _Draw39("BWbwbwBwb")
		If $CodeBreak[$a] == " " Then _Draw39("bWBwbwBwb")
		If $CodeBreak[$a] == "$" Then _Draw39("bWbWbWbwb")
		If $CodeBreak[$a] == "/" Then _Draw39("bWbWbwbWb")
		If $CodeBreak[$a] == "+" Then _Draw39("bWbwbWbWb")
		If $CodeBreak[$a] == "%" Then _Draw39("bwbWbWbWb")
		$Code39Hor += $Code39HorInc * 2
	Next
	_Draw39("bWbwBwBwb") ;		finish (*)
EndFunc   ;==>_BarCode39
Func _Draw39($Pattern)
	$PatternBreak = StringSplit($Pattern, "")
	For $a = 1 To $PatternBreak[0]
		If $PatternBreak[$a] == "B" Then
			GUICtrlSetGraphic($BCBox, $GUI_GR_MOVE, $Code39Hor, 2)
			GUICtrlSetGraphic($BCBox, $GUI_GR_LINE, $Code39Hor, 29)
			$Code39Hor += $Code39HorInc
			GUICtrlSetGraphic($BCBox, $GUI_GR_MOVE, $Code39Hor, 2)
			GUICtrlSetGraphic($BCBox, $GUI_GR_LINE, $Code39Hor, 29)
			$Code39Hor += $Code39HorInc
			GUICtrlSetGraphic($BCBox, $GUI_GR_MOVE, $Code39Hor, 2)
			GUICtrlSetGraphic($BCBox, $GUI_GR_LINE, $Code39Hor, 29)
			$Code39Hor += $Code39HorInc
		EndIf
		If $PatternBreak[$a] == "b" Then
			GUICtrlSetGraphic($BCBox, $GUI_GR_MOVE, $Code39Hor, 2)
			GUICtrlSetGraphic($BCBox, $GUI_GR_LINE, $Code39Hor, 29)
			$Code39Hor += $Code39HorInc
		EndIf
		If $PatternBreak[$a] == "W" Then
			$Code39Hor += $Code39HorInc
			$Code39Hor += $Code39HorInc
			$Code39Hor += $Code39HorInc
		EndIf
		If $PatternBreak[$a] == "w" Then
			$Code39Hor += $Code39HorInc
			$Code39Hor += $Code39HorInc
		EndIf
	Next
EndFunc   ;==>_Draw39