$hwd = ControlGetHandle("Select Test Cases", "", "[ID:5061]") ; Get listbox handle
$hwdwin = WinGetHandle("Select Test Cases") ; Get window handle

If $hwd = 0 Or $hwdwin = 0 Then
	Exit
EndIf

ConsoleWrite("window" & $hwdwin & $hwd & @CR)

If _GUICtrlListBox_GetAnchorIndex($hwd) Then
	ConsoleWrite("good" & @CR)
EndIf
$count = _GUICtrlListBox_GetCount($hwd)

;WinMove("Select Test Cases", "", 0, 0)

$isPass = 0
Local $posWin, $posChkBx
Local $ID1, $ID2
Local $color1, $color2, $data

$posWin = ControlGetPos("Select Test Cases", "", "[ID:5061]") ; Get window position
;ConsoleWrite($pos[0] &@CR & $pos[1]&@CR& $pos[2]&@CR& $pos[3]&@CR)

For $index = 0 To $count - 1 Step 0
	_GUICtrlListBox_SetCaretIndex($hwd, $index)
	$pos = _GUICtrlListBox_GetItemRect($hwd, $index)
	;ConsoleWrite($pos[0] & @CR & $pos[1] & @CR & $pos[2] & @CR & $pos[3] & @CR)
	
	$y1 = 328 + $index * 14
	$color1 = PixelGetColor(407, $y1, $hwdwin)
	$color1 = Hex($color1, 6)
	
	;$posChkBx = _GUICtrlListBox_GetItemRect($hwd, $index) ; Get check box postion
	If $color1 = "FFFFFF" Then ; Check state
		$data = _GUICtrlListBox_GetText($hwd, $index)
		
		#cs
			Remove cases belong to FAIL or INCONCLUSIVE
		#ce
		If StringRegExp($data, "PASS") = 0 Then
			MouseClick("left", 407, $y1, 1)
			
		#cs
			Remove repeat cases and keep latest one
		#ce
		Else
			ConsoleWrite("Pass" &@CR)
			For $new = $index + 1 To $count - 1 Step 0
				_GUICtrlListBox_SetCaretIndex($hwd, $new)
				$y2 = 328 + $new * 14
				$color2 = PixelGetColor(407, $y2, $hwdwin)
				$color2 = Hex($color1, 6)
				If $color2 = "FFFFFF" Then
					ConsoleWrite("Enter")
					$time1 = StringRegExp($data, "(\d+, \d+ \d+:\d+:\d+)", 1)
					$ID1 = StringRegExp($data, "(.*)\| Date", 1)
					$ID1 = StringStripWS($ID1[0], 2)
					ConsoleWrite($ID1 &@CR)
					
					$new_data = _GUICtrlListBox_GetText($hwd, $new)
					ConsoleWrite($new_data)
					$pos2 = _GUICtrlListBox_GetItemRect($hwd, $index)
					$time2 = StringRegExp($new_data, "(\d+, \d+ \d+:\d+:\d+)", 1)
					$ID2 = StringRegExp($new_data, "(.*)\| Date", 1)
					$ID2 = StringStripWS($ID2[0], 2)
					ConsoleWrite($ID2 & @CR)
					If StringRegExp($new_data, "PASS") = 1 And StringCompare($ID1, $ID2) = 0 Then
						If StringCompare($time1[0], $time2[0]) < 0 Then
							; Dis-select $index's case, and continue to find minium case
							MouseClick("left", 407, $y2, 1, "")
						Else
							; Dis-select temprary case and exit current loop: For
							MouseClick("left", 407, $y1, 1, "")
							ExitLoop
							
						EndIf
					EndIf
				EndIf
				$new += 1
			Next
		EndIf

	EndIf
	
	ConsoleWrite(@CR)
	$index += 1

Next