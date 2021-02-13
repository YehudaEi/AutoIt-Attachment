Global $hGui = GUICreate("GuiCtrlLCDNumber by funkey", 750, 550, -1, -1, -1, 0x2000000)

Global $LCDNum1 = _GuiCtrlLCDNumber_Create(10, 10, 20, 30, 10, 0xff0000, 0xff00)
Global $LCDNum2 = _GuiCtrlLCDNumber_Create(10, 60, 30, 40, 6, 0, 0xffffff)
Global $LCDNum3 = _GuiCtrlLCDNumber_Create(10, 120, 120, 240, 6, 0xffffa0, 0x0)

Global $hTime = _GuiCtrlLCDNumber_CreateTime(210, 60, 30, 40, 0xffff, 0xff)
Global $hDate = _GuiCtrlLCDNumber_CreateDate(10, 380, 50, 100, 0xff0000)
Global $hDate2 = _GuiCtrlLCDNumber_CreateDate(10, 500, 20, 30, 0x666666)

_GuiCtrlLCDNumber_SetValue($LCDNum1, "0123456789")
_GuiCtrlLCDNumber_SetValue($LCDNum3, "345678")

_GuiCtrlLCDNumber_SetDate($hDate)
_GuiCtrlLCDNumber_SetDate($hDate2, 1980, 12, 4)

GUISetState()

AdlibRegister("_Update", 1000)


Do
	Sleep(20)
Until GUIGetMsg() = -3

Func _Update()
	_GuiCtrlLCDNumber_SetTime($hTime)
EndFunc

Func _GuiCtrlLCDNumber_Create($x, $y, $w = 20, $h = 40, $iCount = 1, $iCol = 0, $iBkCol = Default)
	Local $aRet[3] = [GUICtrlCreateDummy()]
	Local $iThick = $w / 8
	For $i = 0 To $iCount - 1
		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetBkColor(-1, $iBkCol)

		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetGraphic(-1, 24, $iThick)				;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 6, 1.5*$iThick, $iThick)		;$GUI_GR_MOVE
		GUICtrlSetGraphic(-1, 2, $w - 1.5*$iThick, $iThick)	;$GUI_GR_LINE
		GUICtrlSetGraphic(-1, 24, $iThick/2)			;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 14, $iThick, $iThick, $iThick/2, -30, 60)	;$GUI_GR_PIE
		GUICtrlSetGraphic(-1, 14, $w - $iThick, $iThick, $iThick/2, 150, 60)	;$GUI_GR_PIE

		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetGraphic(-1, 24, $iThick)				;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 6, 1.5*$iThick, $h/2)			;$GUI_GR_MOVE
		GUICtrlSetGraphic(-1, 2, $w - 1.5*$iThick, $h/2)	;$GUI_GR_LINE
		GUICtrlSetGraphic(-1, 24, $iThick/2)			;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 14, $iThick, $h/2, $iThick/2, -30, 60)	;$GUI_GR_PIE
		GUICtrlSetGraphic(-1, 14, $w - $iThick, $h/2, $iThick/2, 150, 60)	;$GUI_GR_PIE

		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetGraphic(-1, 24, $iThick)					;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)						;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 6, 1.5*$iThick, $h-$iThick)		;$GUI_GR_MOVE
		GUICtrlSetGraphic(-1, 2, $w - 1.5*$iThick, $h-$iThick)	;$GUI_GR_LINE
		GUICtrlSetGraphic(-1, 24, $iThick/2)				;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)						;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 14, $iThick, $h-$iThick, $iThick/2, -30, 60)	;$GUI_GR_PIE
		GUICtrlSetGraphic(-1, 14, $w - $iThick, $h-$iThick, $iThick/2, 150, 60)	;$GUI_GR_PIE

		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetGraphic(-1, 24, $iThick)				;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 6, $iThick/1.5, 2*$iThick)	;$GUI_GR_MOVE
		GUICtrlSetGraphic(-1, 2, $iThick/1.5, $h/2 - $iThick)	;$GUI_GR_LINE
		GUICtrlSetGraphic(-1, 24, $iThick/2)			;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 14, $iThick/1.5, 1.5*$iThick, $iThick/2, -120, 60)	;$GUI_GR_PIE
		GUICtrlSetGraphic(-1, 14, $iThick/1.5, $h/2 - $iThick/2, $iThick/2, 60, 60)	;$GUI_GR_PIE

		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetGraphic(-1, 24, $iThick)				;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 6, $w - $iThick/1.5, 2*$iThick)	;$GUI_GR_MOVE
		GUICtrlSetGraphic(-1, 2, $w - $iThick/1.5, $h/2 - $iThick)	;$GUI_GR_LINE
		GUICtrlSetGraphic(-1, 24, $iThick/2)			;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 14, $w - $iThick/1.5, 1.5*$iThick, $iThick/2, -120, 60)	;$GUI_GR_PIE
		GUICtrlSetGraphic(-1, 14, $w - $iThick/1.5, $h/2 - $iThick/2, $iThick/2, 60, 60)	;$GUI_GR_PIE

		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetGraphic(-1, 24, $iThick)				;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 6, $iThick/1.5, $h/2 + $iThick)	;$GUI_GR_MOVE
		GUICtrlSetGraphic(-1, 2, $iThick/1.5, $h - 2*$iThick)	;$GUI_GR_LINE
		GUICtrlSetGraphic(-1, 24, $iThick/2)			;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 14, $iThick/1.5, $h/2 + $iThick/2, $iThick/2, -120, 60)	;$GUI_GR_PIE
		GUICtrlSetGraphic(-1, 14, $iThick/1.5, $h - 1.5*$iThick, $iThick/2, 60, 60)	;$GUI_GR_PIE

		GUICtrlCreateGraphic($x + $i * $w, $y, $w, $h, 0)
		GUICtrlSetGraphic(-1, 24, $iThick)				;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 6, $w - $iThick/1.5, $h/2 + $iThick)	;$GUI_GR_MOVE
		GUICtrlSetGraphic(-1, 2, $w - $iThick/1.5, $h - 2*$iThick)	;$GUI_GR_LINE
		GUICtrlSetGraphic(-1, 24, $iThick/2)			;$GUI_GR_PENSIZE
		GUICtrlSetGraphic(-1, 8, $iCol)					;$GUI_GR_COLOR
		GUICtrlSetGraphic(-1, 14, $w - $iThick/1.5, $h/2 + $iThick/2, $iThick/2, -120, 60)	;$GUI_GR_PIE
		GUICtrlSetGraphic(-1, 14, $w - $iThick/1.5, $h - 1.5*$iThick, $iThick/2, 60, 60)	;$GUI_GR_PIE
	Next
	$aRet[1] = GUICtrlCreateDummy()
	Return $aRet
EndFunc


Func _GuiCtrlLCDNumber_SetValue(ByRef $hLCDNumber, $sValue)
	If Not StringIsInt($sValue) Then Return SetError(1)
	Local $iDigits = ($hLCDNumber[1] - $hLCDNumber[0] -1) / 8
	If StringLen($sValue) > $iDigits Then Return SetError(2)
	$sValue = StringFormat("%0" & $iDigits & "s", $sValue)
	Local $aValue = StringSplit($sValue, "", 2)
	For $i = 0 To $iDigits - 1
		If StringMid($hLCDNumber[2], $i + 1, 1) = $aValue[$i] Then ContinueLoop
		Local $aState[7]
		$aState[0] = BitAND(GUICtrlGetState($hLCDNumber[0] + 2 + $i*8), 16)
		$aState[1] = BitAND(GUICtrlGetState($hLCDNumber[0] + 3 + $i*8), 16)
		$aState[2] = BitAND(GUICtrlGetState($hLCDNumber[0] + 4 + $i*8), 16)
		$aState[3] = BitAND(GUICtrlGetState($hLCDNumber[0] + 5 + $i*8), 16)
		$aState[4] = BitAND(GUICtrlGetState($hLCDNumber[0] + 6 + $i*8), 16)
		$aState[5] = BitAND(GUICtrlGetState($hLCDNumber[0] + 7 + $i*8), 16)
		$aState[6] = BitAND(GUICtrlGetState($hLCDNumber[0] + 8 + $i*8), 16)
		Switch $aValue[$i]
			Case 0
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 32)
				If Not $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 16)
				If Not $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 16)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If Not $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 16)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 1
				If $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 32)
				If $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 32)
				If $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 32)
				If $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 32)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 32)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 2
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If Not $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 16)
				If Not $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 16)
				If $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 32)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If Not $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 16)
				If $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 32)
			Case 3
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If Not $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 16)
				If Not $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 16)
				If $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 32)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 32)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 4
				If $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 32)
				If Not $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 16)
				If $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 32)
				If Not $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 16)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 32)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 5
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If Not $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 16)
				If Not $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 16)
				If Not $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 16)
				If $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 32)
				If $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 32)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 6
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If Not $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 16)
				If Not $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 16)
				If Not $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 16)
				If $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 32)
				If Not $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 16)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 7
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 32)
				If $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 32)
				If $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 32)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 32)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 8
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If Not $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 16)
				If Not $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 16)
				If Not $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 16)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If Not $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 16)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
			Case 9
				If Not $aState[0] Then GUICtrlSetState($hLCDNumber[0] + 2 + $i*8, 16)
				If Not $aState[1] Then GUICtrlSetState($hLCDNumber[0] + 3 + $i*8, 16)
				If Not $aState[2] Then GUICtrlSetState($hLCDNumber[0] + 4 + $i*8, 16)
				If Not $aState[3] Then GUICtrlSetState($hLCDNumber[0] + 5 + $i*8, 16)
				If Not $aState[4] Then GUICtrlSetState($hLCDNumber[0] + 6 + $i*8, 16)
				If $aState[5] Then GUICtrlSetState($hLCDNumber[0] + 7 + $i*8, 32)
				If Not $aState[6] Then GUICtrlSetState($hLCDNumber[0] + 8 + $i*8, 16)
		EndSwitch
	Next
	$hLCDNumber[2] = $sValue
EndFunc

Func _GuiCtrlLCDNumber_CreateTime($x, $y, $w = 20, $h = 40, $iCol = 0, $iBkCol = Default)
	Local $Hour = _GuiCtrlLCDNumber_Create($x, $y, $w, $h, 2, $iCol, $iBkCol)
	Local $Min = _GuiCtrlLCDNumber_Create($x+2.5*$w, $y, $w, $h, 2, $iCol, $iBkCol)
	Local $Sec = _GuiCtrlLCDNumber_Create($x+ 5*$w, $y, $w, $h, 2, $iCol, $iBkCol)
	GUICtrlCreateLabel(":", $x+2*$w, $y, $w/2, $h, 0x201)
	GUICtrlSetFont(-1, $h/1.5)
	GUICtrlSetColor(-1, $iCol)
	GUICtrlSetBkColor(-1, $iBkCol)
	GUICtrlCreateLabel(":", $x+4.5*$w, $y, $w/2, $h, 0x201)
	GUICtrlSetFont(-1, $h/1.5)
	GUICtrlSetColor(-1, $iCol)
	GUICtrlSetBkColor(-1, $iBkCol)
	Local $aRet[9] = [$Hour[0], $Hour[1], "", $Min[0], $Min[1], "", $Sec[0], $Sec[1], ""]
	Return $aRet
EndFunc

Func _GuiCtrlLCDNumber_SetTime(ByRef $hLCDTime, $h = @HOUR, $m = @MIN, $s = @SEC)
	If UBound($hLCDTime) <> 9 Then Return SetError(1)	;only for times created with _GuiCtrlLCDNumber_CreateTime
	Local $aH[3] = [$hLCDTime[0], $hLCDTime[1], $hLCDTime[2]]
	Local $aM[3] = [$hLCDTime[3], $hLCDTime[4], $hLCDTime[5]]
	Local $aS[3] = [$hLCDTime[6], $hLCDTime[7], $hLCDTime[8]]
	_GuiCtrlLCDNumber_SetValue($aH, $h)
	_GuiCtrlLCDNumber_SetValue($aM, $m)
	_GuiCtrlLCDNumber_SetValue($aS, $s)
	$hLCDTime[2] = $h
	$hLCDTime[5] = $m
	$hLCDTime[8] = $s
EndFunc

Func _GuiCtrlLCDNumber_CreateDate($x, $y, $w = 20, $h = 40, $iCol = 0, $iBkCol = Default)
	Local $Year = _GuiCtrlLCDNumber_Create($x, $y, $w, $h, 4, $iCol, $iBkCol)
	Local $Month = _GuiCtrlLCDNumber_Create($x+4.5*$w, $y, $w, $h, 2, $iCol, $iBkCol)
	Local $Day = _GuiCtrlLCDNumber_Create($x+ 7*$w, $y, $w, $h, 2, $iCol, $iBkCol)
	GUICtrlCreateLabel(".", $x+4*$w, $y, $w/2, $h, 0x201)
	GUICtrlSetFont(-1, $h)
	GUICtrlSetColor(-1, $iCol)
	GUICtrlSetBkColor(-1, $iBkCol)
	GUICtrlCreateLabel(".", $x+6.5*$w, $y, $w/2, $h, 0x201)
	GUICtrlSetFont(-1, $h)
	GUICtrlSetColor(-1, $iCol)
	GUICtrlSetBkColor(-1, $iBkCol)
	Local $aRet[9] = [$Year[0], $Year[1], "", $Month[0], $Month[1], "", $Day[0], $Day[1], ""]
	Return $aRet
EndFunc

Func _GuiCtrlLCDNumber_SetDate(ByRef $hLCDDate, $y = @YEAR, $m = @MON, $d = @MDAY)
	If UBound($hLCDDate) <> 9 Then Return SetError(1)
	Local $aY[3] = [$hLCDDate[0], $hLCDDate[1], $hLCDDate[2]]
	Local $aM[3] = [$hLCDDate[3], $hLCDDate[4], $hLCDDate[5]]
	Local $aD[3] = [$hLCDDate[6], $hLCDDate[7], $hLCDDate[8]]
	_GuiCtrlLCDNumber_SetValue($aY, $y)
	_GuiCtrlLCDNumber_SetValue($aM, $m)
	_GuiCtrlLCDNumber_SetValue($aD, $d)
	$hLCDDate[2] = $y
	$hLCDDate[5] = $m
	$hLCDDate[8] = $d
EndFunc

Func _GuiCtrlLCDNumber_SetBkColor($hLCDNumber, $iBkCol)
	If UBound($hLCDNumber) <> 3 Then Return SetError(1)
	For $i = $hLCDNumber[0] + 1 To 	$hLCDNumber[1] - 8 Step 8
		GUICtrlSetBkColor($i, $iBkCol)
	Next
EndFunc

Func _GuiCtrlLCDNumber_Hide(ByRef $hLCDNumber)
	If UBound($hLCDNumber) = 9 Then
		For $i = $hLCDNumber[0] To $hLCDNumber[7] + 2
			If BitAND(GUICtrlGetState($i), 16) Then GUICtrlSetState($i, 32)
		Next
		$hLCDNumber[5] = ""
		$hLCDNumber[8] = ""
	Else
		For $i = $hLCDNumber[0] To $hLCDNumber[1]
			If BitAND(GUICtrlGetState($i), 16) Then GUICtrlSetState($i, 32)
		Next
	EndIf
	$hLCDNumber[2] = ""
EndFunc

Func _GuiCtrlLCDNumber_Show(ByRef $hLCDNumber, $sValue)
	If UBound($hLCDNumber) <> 3 Then Return SetError(1)
	For $i = $hLCDNumber[0] + 1 To 	$hLCDNumber[1] - 8 Step 8
		If BitAND(GUICtrlGetState($i), 32) Then GUICtrlSetState($i, 16)
	Next
	_GuiCtrlLCDNumber_SetValue($hLCDNumber, $sValue)
EndFunc

Func _GuiCtrlLCDNumber_Destroy(ByRef $hLCDNumber)
	If UBound($hLCDNumber) = 9 Then
		For $i = $hLCDNumber[0] To $hLCDNumber[7] + 2
			GUICtrlDelete($i)
		Next
	Else
		For $i = $hLCDNumber[0] To $hLCDNumber[1]
			GUICtrlDelete($i)
		Next
	EndIf
	$hLCDNumber = ""
EndFunc
