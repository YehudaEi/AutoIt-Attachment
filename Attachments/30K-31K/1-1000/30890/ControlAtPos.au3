; ==============================================================================
;
; Function Name:    _ControlGetHandleByPos()
; Description:      Retrieves the internal handle of a control that matches a
;                   given position.
; Parameter(s):     $sTitle -- the title of the window containing the control
;                   $sText  -- the text of the window containing the control
;                   $iX     -- the X coordinate of the control
;                   $IY     -- the Y coordinate of the control
; Requirement(s):   None
; Return Value(s):  On success -- returns the control's handle
;                   On failure -- return and sets @error:
;                                   1 -- could not find window
;                                   2 -- could not find control
; Author(s):        Alex Peters
;
; ==============================================================================

Func ControlAtPos($sTitle, $sText, $iX, $iY)

	Local $hWin, $hControl
	Local $iControls, $iLoop, $iUniqueControls
	Local $sClassList, $sClass, $sClassID
	Local $aiControlPos, $avUniqueControls[1][2]

	; Determine that the window exists
	$hWin = WinGetHandle($sTitle, $sText)
	If @error Then
		SetError(2)
		Return 0
	EndIf

	; Determine the control classes and total number of controls
	$sClassList = WinGetClassList($hWin)
	$iControls = StringLen($sClassList) - StringLen(StringReplace($sClassList, _
		@LF, ""))
	ReDim $avUniqueControls[$iControls][2]

	$iUniqueControls = 0
	While $sClassList
		$sClass = StringLeft($sClassList, StringInStr($sClassList, @LF) - 1)
		$sClassList = StringMid($sClassList, StringLen($sClass) + 2)
		$sClassID = ""
		For $iLoop = 0 To $iUniqueControls - 1
			If $avUniqueControls[$iLoop][0] = $sClass Then
				$avUniqueControls[$iLoop][1] += 1
				$sClassID = $sClass & $avUniqueControls[$iLoop][1]
				ExitLoop
			EndIf
		Next
		If Not($sClassID) Then
			$avUniqueControls[$iUniqueControls][0] = $sClass
			$avUniqueControls[$iUniqueControls][1] = 1
			$iUniqueControls += 1
			$sClassID = $sClass & "1"
		EndIf
		; Determine the position of the control in question
		$hControl = ControlGetHandle($hWin, "", $sClassID)
		$aiControlPos = ControlGetPos($hWin, "", $hControl)
		$visible = ControlCommand($hWin, "", $hControl, "IsVisible")
		If ($aiControlPos[0] = $iX And $aiControlPos[1] = $iY And $visible) Then _
			Return $hControl
	WEnd

	; If we reach this point then no matching control was found
	SetError(1)
	Return 0

EndFunc
