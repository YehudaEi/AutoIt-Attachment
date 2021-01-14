#include <GUIConstants.au3>
#include <Array.au3>
Opt("GUIOnEventMode", 1)
Global $sType = 1
Global $sCard[5][5]
Global $sChose[5][5]
$sChose[2][2] = 1
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("AForm1", 633, 535, 193, 115)
GUISetFont(28, 800, 0, "Tahoma", $Form1)
GUISetBkColor(0xFFFFFF, $Form1)
;-=-B-=-
GUICtrlCreateLabel("B", 104, 8, 48, 81)
GUICtrlSetFont(-1, 48, 800, 0, "Tahoma")
$sCard[0][0] = GUICtrlCreateLabel("", 88, 96, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[0][1] = GUICtrlCreateLabel("", 88, 176, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[0][2] = GUICtrlCreateLabel("", 88, 256, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[0][3] = GUICtrlCreateLabel("", 88, 336, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[0][4] = GUICtrlCreateLabel("", 88, 416, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
;-=-I-=-
GUICtrlCreateLabel("I", 192, 8, 35, 81)
GUICtrlSetFont(-1, 48, 800, 0, "Tahoma")
$sCard[1][0] = GUICtrlCreateLabel("", 168, 96, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[1][1] = GUICtrlCreateLabel("", 168, 176, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[1][2] = GUICtrlCreateLabel("", 168, 256, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[1][3] = GUICtrlCreateLabel("", 168, 336, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[1][4] = GUICtrlCreateLabel("", 168, 416, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
;-=-N-=-
GUICtrlCreateLabel("N", 264, 8, 53, 81)
GUICtrlSetFont(-1, 48, 800, 0, "Tahoma")
$sCard[2][0] = GUICtrlCreateLabel("", 248, 96, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[2][1] = GUICtrlCreateLabel("", 248, 176, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[2][2] = GUICtrlCreateLabel("FREE", 248, 256, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xFFFF00)
GUICtrlSetOnEvent(-1, "NumPick")
GUICtrlSetFont(-1, 20, 800, 0, "Tahoma")
$sCard[2][3] = GUICtrlCreateLabel("", 248, 336, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[2][4] = GUICtrlCreateLabel("", 248, 416, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
;-=-G-=-
GUICtrlCreateLabel("G", 344, 8, 52, 81)
GUICtrlSetFont(-1, 48, 800, 0, "Tahoma")
$sCard[3][0] = GUICtrlCreateLabel("", 328, 96, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[3][1] = GUICtrlCreateLabel("", 328, 176, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[3][2] = GUICtrlCreateLabel("", 328, 256, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[3][3] = GUICtrlCreateLabel("", 328, 336, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[3][4] = GUICtrlCreateLabel("", 328, 416, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
;-=-O-=-
GUICtrlCreateLabel("O", 421, 10, 53, 81)
GUICtrlSetFont(-1, 48, 800, 0, "Tahoma")
$sCard[4][0] = GUICtrlCreateLabel("", 408, 96, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[4][1] = GUICtrlCreateLabel("", 408, 176, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[4][2] = GUICtrlCreateLabel("", 408, 256, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[4][3] = GUICtrlCreateLabel("", 408, 336, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$sCard[4][4] = GUICtrlCreateLabel("", 408, 416, 80, 80, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUICtrlSetOnEvent(-1, "NumPick")
$i = 1
For $r = 0 To 4 Step 1
	For $c = 0 To 4 Step 1
		If $r = 2 AND $c = 2 Then ContinueLoop
		While 1
			$a = Round(Random($i, $i+14),0)
			For $z = 0 To 4 Step 1
				If GUICtrlRead($sCard[$r][$z]) = $a Then ContinueLoop 2
			Next
			ExitLoop
		WEnd
		GUICtrlSetData($sCard[$r][$c], $a)
	Next
	$i += 15
Next
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func NumPick ()
If @GUI_CtrlId = $sCard[2][2] Then Return
While 1
For $r = 0 To 4 Step 1
	For $c = 0 To 4 Step 1
		If $sCard[$r][$c] = @GUI_CtrlId Then
			Local $sP = _ArrayCreate($r, $c, GUICtrlRead(@GUI_CtrlId))
			ExitLoop 3
		EndIf
	Next
Next
Return 0
WEnd
If $sChose[$sP[0]][$sP[1]] = 0 Then
	GUICtrlSetBkColor(@GUI_CtrlId, 0xFFFF00)
	$sChose[$sP[0]][$sP[1]] = 1
ElseIf $sChose[$sP[0]][$sP[1]] = 1 Then
	GUICtrlSetBkColor(@GUI_CtrlId, 0xFFFFFF)
	$sChose[$sP[0]][$sP[1]] = 0
EndIf
Check ()
EndFunc

Func Check ()
	Local $sNum
			For $r = 0 To 4 Step 1
				For $c = 0 To 4 Step 1
					If $sChose[$r][$c] = 0 Then ExitLoop
					If $c = 4 Then
						For $i = 0 To 4
							GUICtrlSetBkColor($sCard[$r][$i], 0x0000FF)
							$sNum &= GUICtrlRead($sCard[$r][$i]) & ", "
						Next
						$sNum = StringTrimRight($sNum, 2)
						MsgBox(1, "BINGO", "You have a BINGO!" & @CRLF & "The numbers on row " & _NumToLet($r) & " Numbers " & $sNum)
						Reset ()
					EndIf
				Next
			Next
			For $c = 0 To 4 Step 1
				For $r = 0 To 4 Step 1
					If $sChose[$r][$c] = 0 Then ExitLoop
					If $r = 4 Then
						For $i = 0 To 4
							GUICtrlSetBkColor($sCard[$i][$c], 0x0000FF)
							$sNum &= GUICtrlRead($sCard[$i][$c]) & ", "
						Next
						$sNum = StringTrimRight($sNum, 2)
						MsgBox(1, "BINGO", "You have a BINGO!" & @CRLF & "The numbers on column " & $c+1 & " Numbers " & $sNum)
						Reset ()
					EndIf
				Next
			Next
			For $a = 0 To 4 Step 1
				If $sChose[$a][$a] = 0 Then ExitLoop
					If $a = 4 Then
						For $i = 0 To 4 Step 1
							GUICtrlSetBkColor($sCard[$i][$i], 0x0000FF)
							$sNum &= GUICtrlRead($sCard[$i][$i]) & ", "
						Next
						$sNum = StringTrimRight($sNum, 2)
						MsgBox(1, "BINGO", "You have a BINGO!" & @CRLF & "The numbers on diagonal Top-Left to Bottom-Right Numbers " & $sNum)
						Reset ()
					EndIf
				Next
		$q = 4
		For $a = 0 To 4 Step 1
				If $sChose[$a][$q] = 0 Then ExitLoop
					If $a = 4 Then
						$z = 4
						For $i = 0 To 4 Step 1
							GUICtrlSetBkColor($sCard[$i][$z], 0x0000FF)
							$sNum &= GUICtrlRead($sCard[$i][$z]) & ", "
							$z -= 1
						Next
						$sNum = StringTrimRight($sNum, 2)
						MsgBox(1, "BINGO", "You have a BINGO!" & @CRLF & "The numbers on diagonal Top-Left to Bottom-Right Numbers " & $sNum)
						Reset ()
					EndIf
			$q -= 1
		Next
EndFunc	

Func _NumToLet($i)
	Switch $i
		Case 0
			Return "B"
		Case 1
			Return "I"
		Case 2
			Return "N"
		Case 3
			Return "G"
		Case 4
			Return "O"
		Case Else
			Return $i
	EndSwitch
EndFunc
	
Func Reset ()
For $r = 0 To 4 Step 1
	For $c = 0 To 4 Step 1
		GUICtrlSetBkColor($sCard[$r][$c], 0xFFFFFF)
		GUICtrlSetData($sCard[$r][$c], "")
	Next
Next
ReDim $sChose[1][1]
ReDim $sChose[5][5]
$sChose[2][2] = 1
GUICtrlSetBkColor($sCard[2][2], 0xFFFF00)
GUICtrlSetData($sCard[2][2], "FREE")
	$i = 1
For $r = 0 To 4 Step 1
	For $c = 0 To 4 Step 1
		If $r = 2 AND $c = 2 Then ContinueLoop
		While 1
			$a = Round(Random($i, $i+14),0)
			For $z = 0 To 4 Step 1
				If GUICtrlRead($sCard[$r][$z]) = $a Then ContinueLoop 2
			Next
			ExitLoop
		WEnd
		GUICtrlSetData($sCard[$r][$c], $a)
	Next
	$i += 15
Next
EndFunc
			