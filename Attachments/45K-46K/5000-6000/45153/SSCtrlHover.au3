;~ Simple and Stupid Control Hover
;~ Author			: 	binhnx
;~ Created			:	2014/09/20
;~ Last modified	:	2014/09/21

#include-once

Const $_NTIMER = 30
Const $_BEVENTMODE = False
Const $_BGUIGETCURSORINFOFIX = True

#Region Internal Global Variables
Const $_NCONTROLDATADIM = 11
Const $_NCONTROLGUIDIM = 5

Global $_aControlHoverData[10][$_NCONTROLDATADIM]
Global $_aControlGuiTrack[0][$_NCONTROLGUIDIM]
Global $_aControlHoverTrack[1] = [0]
#EndRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: _SSCtrlHover_Register
; Description ...: Register functions to be called when the mouse cursor is hover/down/leave the control.
; Syntax ........: SSCtrlHover_Register($idCtrl [, $aIdAttachedCtrl=0 [, $fnNormalCb="" [, $vNormalData=0
;					[, $fnHoverCb="" [, $vHoverData=0 [, $fnActiveCb="" [, $vActiveData=0 [, $fnClickCb="" [, $vClickData=0]]]]]]]]])
; Parameters ....: $idCtrl              - The Ctrl ID to set hovering for (-1 means the last created control)
;                  $aIdAttachedCtrl     - One or an array of controls attached with the control to set hover. This is effienct
;											when you want to retrieve it after. The attached control(s) are automatically
;											deleted when you delete the hover control.
;											Can be set to 0 to indicate that the control to set hover have no attached controls.
;                  $fnNormalCb          - Name or variable to a function which will be called
;											when the the mouse is leaving hovering the control.
;											Pass empty string if you do not need it
;                  $vNormalData         - A variant to pass when $fnNormalCb is called.
;											If you do not need it, pass zero or anything you want.
;                  $fnHoverCb           - Name or variable to a function which will be called
;											when the mouse is hovering the control.
;                  $vHoverData          - A variant to pass when $fnHoverCb is called.
;                  $fnActiveCb          - Name or variable to a function which will be called
;											when the mouse is press on the control.
;                  $vActiveData         - A variant to pass when $fnActiveCb is called.
;                  $fnActiveCb          - Name or variable to a function which will be called when the control is clicked
;                  $vActiveData         - A variant to pass when $fnActiveCb is called.
; Return values .: a "handle" to the registered control. Use that handle with any other function in this UDF. -1 if fail.
;										An @error = 1 will be set if you re-register a registered control.
; Author ........: binhnx
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SSCtrlHover_Register($idCtrl, $aIdAttachedCtrl=0, _
				$fnNormalCb="", $vNormalData=0, $fnHoverCb="", $vHoverData=0, $fnActiveCb="", $vActiveData=0, _
				$fnClickCb="", $vClickData=0)
	$hWnd = GUICtrlGetHandle($idCtrl)
	If (Not(IsHWnd($hWnd))) Then Return -1
	; _WinAPI_GetAncestor
	$hWnd = DllCall("user32.dll", "HWND", "GetAncestor", "HWND", $hWnd, "UINT", 2)[0]

	If (__SSCtrlHover_FindItem($idCtrl, $hWnd) <> -1) Then
		Return SetError(1, 0, -1)
	EndIf

	If ($_BEVENTMODE) Then GUICtrlSetOnEvent($idCtrl, "__SSCtrlHover_OnCtrlEvent")
	Local $iIndex = __SSCtrlHover_FindEmptyIndex()
	$_aControlHoverData[$iIndex][0] = $idCtrl
	$_aControlHoverData[$iIndex][1] = $hWnd
	$_aControlHoverData[$iIndex][2] = $aIdAttachedCtrl
	$_aControlHoverData[$iIndex][3] = $fnNormalCb
	$_aControlHoverData[$iIndex][4] = $vNormalData
	$_aControlHoverData[$iIndex][5] = $fnHoverCb
	$_aControlHoverData[$iIndex][6] = $vHoverData
	$_aControlHoverData[$iIndex][7] = $fnActiveCb
	$_aControlHoverData[$iIndex][8] = $vActiveData
	$_aControlHoverData[$iIndex][9] = $fnClickCb
	$_aControlHoverData[$iIndex][10] = $vClickData
	$_aControlHoverTrack[0] += 1
	__SSCtrlHover_AddGuiTrack($hWnd)
	Return $iIndex
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _SSCtrlHover_UnRegister
; Description ...: Un-register the registered hover control.
; Syntax ........: SSCtrlHover_UnRegister($idCtrl)
; Parameters ....: $idCtrl              - The Ctrl "handle" returned from SSCtrlHover_Register.
; Return values .: No
; Author ........: binhnx
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SSCtrlHover_UnRegister($zHoverCtrl)
	Local $bOnly = __SSCtrlHover_IsOnlyCtrlInGuiTrack($zHoverCtrl)

	If ($bOnly) Then
		__SSCtrlHover_RemoveGuiTrack($_aControlHoverData[$zHoverCtrl][1])
	Else
		; If we remove the current hover/active control, so first set the flag indicate that we no longer track it
		For $i = 0 To UBound($_aControlGuiTrack, 1)-1
			If ($_aControlGuiTrack[$i][0] = $_aControlHoverData[$zHoverCtrl][1]) Then
				If ($_aControlGuiTrack[$i][1] = $_aControlHoverData[$zHoverCtrl][0]) Then $_aControlGuiTrack[$i][1] = 0
				ExitLoop
			EndIf
		Next
	EndIf
	$_aControlHoverData[$zHoverCtrl][0] = 0
	$_aControlHoverTrack[0] -= 1
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _SSCtrlHover_Delete
; Description ...: Delete the registered hover control along with its attached controls.
; Syntax ........: SSCtrlHover_UnRegister($idCtrl)
; Parameters ....: $idCtrl              - The Ctrl "handle" returned from SSCtrlHover_Register.
; Return values .: No
; Author ........: binhnx
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SSCtrlHover_Delete($zHoverCtrl)
	Local $aIdAttachedCtrl = $_aControlHoverData[$zHoverCtrl][2]
	If (IsArray($aIdAttachedCtrl)) Then
		For $idAttachedCtrl In $aIdAttachedCtrl
			__SSCtrlHover_DeleteCtrl($idAttachedCtrl)
		Next
	Else
		__SSCtrlHover_DeleteCtrl($aIdAttachedCtrl)
	EndIf

	Local $idCtrl = $_aControlHoverData[$zHoverCtrl][0]
	SSCtrlHover_UnRegister($zHoverCtrl)
	GUICtrlDelete($idCtrl)
EndFunc

#Region Compatibility methods
Func SSCtrlHover_Register($idCtrl, $aIdAttachedCtrl=0, _
				$fnNormalCb="", $vNormalData=0, $fnHoverCb="", $vHoverData=0, $fnActiveCb="", $vActiveData=0, _
				$fnClickCb="", $vClickData=0)
	Return _SSCtrlHover_Register($idCtrl, $aIdAttachedCtrl, _
				$fnNormalCb, $vNormalData, $fnHoverCb, $vHoverData, $fnActiveCb, $vActiveData, $fnClickCb, $vClickData)
	;
EndFunc

Func SSCtrlHover_UnRegister($zHoverCtrl)
	Return _SSCtrlHover_UnRegister($zHoverCtrl)
EndFunc

Func SSCtrlHover_Delete($zHoverCtrl)
	Return _SSCtrlHover_Delete($zHoverCtrl)
EndFunc




#EndRegion

Func __SSCtrlHover_SetNormalState($iIndexPrevInTrack)
	If ($iIndexPrevInTrack <> -1) Then
		__SSCtrlHover_Call(1, $iIndexPrevInTrack)
	EndIf
EndFunc

Func __SSCtrlHover_SetActiveState($hWnd, $idCtrl, ByRef $idCapturedTrack)
	Local $iIndex =  __SSCtrlHover_FindItem($idCtrl, $hWnd)
	If ($iIndex <> -1) Then
		__SSCtrlHover_Call(3, $iIndex)
		$idCapturedTrack = $idCtrl
	Else
		$idCapturedTrack = 0
	EndIf
	Return $iIndex
EndFunc

Func __SSCtrlHover_SetHoverState($hWnd, $idCtrl)
	Local $iIndex =  __SSCtrlHover_FindItem($idCtrl, $hWnd)
	If ($iIndex <> -1) Then
		__SSCtrlHover_Call(2, $iIndex)
	EndIf
	Return $iIndex
EndFunc




Func __SSCtrlHover_AdCheckHover()
	Local $nTime = TimerInit()
	Local $nLength = UBound($_aControlGuiTrack, 1)
	For $i = 0 To $nLength-1
		Local $hWnd = $_aControlGuiTrack[$i][0]
		If ($_BGUIGETCURSORINFOFIX) Then
			Local $aData[5] = [0,0, DllCall("user32.dll", "SHORT", "GetAsyncKeyState", "INT", 0x1)[0], 0, _
						__SSCtrlHover_CtrlIdFromPoint($hWnd)]
		Else
			Local $aData = GUIGetCursorInfo($hWnd)
		EndIf
		If @error Then ContinueLoop

		If ($aData[2]) Then
			; The mouse button has been still down since the last time we checked
			If ($_aControlGuiTrack[$i][3]) Then
				__SSCtrlHover_ProcessAdEventCapturedTracked($hWnd, $aData[4], _
							$_aControlGuiTrack[$i][1], $_aControlGuiTrack[$i][4], $_aControlGuiTrack[$i][2])
			; The mouse button was at normal state when we checked previous time
			Else
				If (Not($_BEVENTMODE)) Then __SSCtrlHover_ProcessAdEventDownTracked($hWnd, $aData[4],  _
							$_aControlGuiTrack[$i][1], $_aControlGuiTrack[$i][4], $_aControlGuiTrack[$i][2])
			EndIf
		Else
			__SSCtrlHover_ProcessAdEventHoverTracked($hWnd, $aData[4], _
						$_aControlGuiTrack[$i][1], $_aControlGuiTrack[$i][4], $_aControlGuiTrack[$i][2])
			; Release capture
			$_aControlGuiTrack[$i][4] = 0
		EndIf
		$_aControlGuiTrack[$i][1] = $aData[4]
		$_aControlGuiTrack[$i][3] = $aData[2]
	Next
	;ConsoleWrite(@CRLF & "Debug: " & TimerDiff($nTime))
EndFunc

Func __SSCtrlHover_ProcessAdEventCapturedTracked($hWnd, $idCurrent, $idPrev, $idCapturedTrack, _
				ByRef $iIndexPrevInTrack)
	If ($idCapturedTrack = 0) Then Return

	Local $iIndex = 0
	; Check if the current control under mouse cursor is the same control
	; with the one we tracked in mouse-down mode. If not, don't do anything.
	If ($idCurrent = $idCapturedTrack) Then
		; Set active
		If ($idCurrent <> $idPrev) Then
			$iIndexPrevInTrack = __SSCtrlHover_SetActiveState($hWnd, $idCurrent, $idCapturedTrack)
		EndIf
	Else
		; Set the tracked control to normal mode
		__SSCtrlHover_SetNormalState($iIndexPrevInTrack)
		$iIndexPrevInTrack = -1
	EndIf
EndFunc

Func __SSCtrlHover_ProcessAdEventDownTracked($hWnd, $idCurrent, $idPrev, _
				ByRef $idCapturedTrack, ByRef $iIndexPrevInTrack)
	If ($idCurrent = $idPrev) Then
		If ($idCurrent <> 0) Then
			$iIndexPrevInTrack = __SSCtrlHover_SetActiveState($hWnd, $idCurrent, $idCapturedTrack)
		Else
			$iIndexPrevInTrack = -1
			$idCapturedTrack = 0
		EndIf
	Else
		If ($idCurrent = 0) Then
			__SSCtrlHover_SetNormalState($iIndexPrevInTrack)
			$idCapturedTrack = 0
			$iIndexPrevInTrack = -1
		ElseIf ($idPrev = 0) Then
			$iIndexPrevInTrack = __SSCtrlHover_SetActiveState($hWnd, $idCurrent, $idCapturedTrack)
		Else
			__SSCtrlHover_SetNormalState($iIndexPrevInTrack)
			$iIndexPrevInTrack = __SSCtrlHover_SetActiveState($hWnd, $idCurrent, $idCapturedTrack)
		EndIf
	EndIf
EndFunc

Func __SSCtrlHover_ProcessAdEventHoverTracked($hWnd, $idCurrent, $idPrev, _
				$idCapturedTrack, ByRef $iIndexPrevInTrack)
	Local $iIndex

	; If has capture
	If ($idCapturedTrack <> 0) Then
		If ($idCapturedTrack = $idCurrent) Then
			If ($idCapturedTrack <> -1) Then
				__SSCtrlHover_Call(2, $iIndexPrevInTrack)
				__SSCtrlHover_Call(4, $iIndexPrevInTrack)
			EndIf
		Else
			__SSCtrlHover_SetNormalState($iIndexPrevInTrack)
			$iIndexPrevInTrack = __SSCtrlHover_SetHoverState($hWnd, $idCurrent)
		EndIf
	Else
		If ($idCurrent <> $idPrev) Then
			__SSCtrlHover_SetNormalState($iIndexPrevInTrack)
			$iIndexPrevInTrack = __SSCtrlHover_SetHoverState($hWnd, $idCurrent)
		EndIf
	EndIf
EndFunc

Func __SSCtrlHover_Call($iCallType, $iIndex)
	Local $sFn = $_aControlHoverData[$iIndex][$iCallType*2+1]
	Local $vData = $_aControlHoverData[$iIndex][$iCallType*2+2]
	Call($sFn, $_aControlHoverData[$iIndex][0], $_aControlHoverData[$iIndex][1], $vData)
EndFunc

Func __SSCtrlHover_AddGuiTrack($hWndTrack)
	Local $nLength = UBound($_aControlGuiTrack, 1)

	If ($nLength = 0) Then
		ReDim $_aControlGuiTrack[1][$_NCONTROLGUIDIM]
		$_aControlGuiTrack[0][0] = $hWndTrack
		$_aControlGuiTrack[0][2] = -1
		AdlibRegister("__SSCtrlHover_AdCheckHover", $_NTIMER)
	Else
		For $i = 0 To $nLength-1
			If ($_aControlGuiTrack[$i][0] = $hWndTrack) Then Return
		Next
		ReDim $_aControlGuiTrack[$nLength+1][$_NCONTROLGUIDIM]
		$_aControlGuiTrack[$nLength][0] = $hWndTrack
		$_aControlGuiTrack[$nLength][2] = -1
	EndIf
EndFunc

Func __SSCtrlHover_RemoveGuiTrack($hWndTrack)
	Local $bFlagFound = False
	Local $nLength = UBound($_aControlGuiTrack, 1)
	For $i = 0 To $nLength-1
		If ($_aControlGuiTrack[$i][0] = $hWndTrack) Then
			$bFlagFound = True
		EndIf
		If ($bFlagFound And $i<$nLength-1) Then
			$_aControlGuiTrack[$i][0] = $_aControlGuiTrack[$i+1][0]
			$_aControlGuiTrack[$i][1] = $_aControlGuiTrack[$i+1][1]
		EndIf
	Next

	If ($bFlagFound) Then
		$nLength -= 1
		ReDim $_aControlGuiTrack[$nLength][$_NCONTROLGUIDIM]
		If ($nLength = 0) Then AdlibUnRegister("__SSCtrlHover_AdCheckHover")
		Return True
	Else
		Return False
	EndIf
EndFunc

Func __SSCtrlHover_FindItem($idKey, $hWnd)
	If ($idKey = 0) Then Return -1
	For $i = 0 To $_aControlHoverTrack[0]-1
		If ($_aControlHoverData[$i][0] = $idKey And $_aControlHoverData[$i][1] = $hWnd) Then Return $i
	Next
	Return -1
EndFunc

Func __SSCtrlHover_FindEmptyIndex()
	Local $nLength = UBound($_aControlHoverData, 1)
	For $i = 0 To $nLength-1
		If ($_aControlHoverData[$i][0] = 0) Then Return $i
	Next

	ReDim $_aControlHoverData[$nLength*2][$_NCONTROLDATADIM]
	Return $nLength
EndFunc

Func __SSCtrlHover_IsOnlyCtrlInGuiTrack($zHoverCtrl)
	; Check if we have another tracked control in the same gui with the given control
	For $i = 0 To UBound($_aControlHoverData, 1)-1
		If ($zHoverCtrl <> $i And $_aControlHoverData[$i][1] = $_aControlHoverData[$zHoverCtrl][1]) Then
			Return False
		EndIf
	Next
	Return True
EndFunc

Func __SSCtrlHover_DeleteCtrl($idCtrl)
	If (IsHWnd(GUICtrlGetHandle($idCtrl))) Then
		Return GUICtrlDelete($idCtrl)
	EndIf
	Return 0
EndFunc

Func __SSCtrlHover_CtrlIdFromPoint($hWnd)
	Local $iMode = Opt("MouseCoordMode", 1)
	Local $tPoint = DllStructCreate("LONG;LONG")
	DllStructSetData($tPoint, 1, MouseGetPos(0))
	DllStructSetData($tPoint, 2, MouseGetPos(1))
	Opt("MouseCoordMode", $iMode)
	DllCall("user32.dll", "BOOL", "ScreenToClient", "HWND", $hWnd, "STRUCT*", $tPoint)
	Local $hWndChild = DllCall("user32.dll", "HWND", "ChildWindowFromPoint", "HWND", $hWnd, "STRUCT", $tPOINT)[0]
	Return DllCall("user32.dll", "INT", "GetDlgCtrlID", "HWND", $hWndChild)[0]
EndFunc

; Mouse down!
Func __SSCtrlHover_OnCtrlEvent()
	Local $nLength = UBound($_aControlGuiTrack, 1)
	Local $hWnd = 0
	For $i = 0 To $nLength-1
		$hWnd = $_aControlGuiTrack[$i][0]
		If (@GUI_WinHandle = $hWnd) Then
				__SSCtrlHover_ProcessAdEventDownTracked($hWnd, @GUI_CtrlId,  _
							$_aControlGuiTrack[$i][1], $_aControlGuiTrack[$i][4], $_aControlGuiTrack[$i][2])
				$_aControlGuiTrack[$i][3] = True
			ExitLoop
		EndIf
	Next
EndFunc

Func __SSCtrlHover_CheckClickCondition($idCtrl, $hWnd)
	Local $nLength = UBound($_aControlGuiTrack, 1)
	Local $hWnd = 0
	For $i = 0 To $nLength-1
		$hWnd = $_aControlGuiTrack[$i][0]
		If (@GUI_WinHandle = $hWnd) Then Return ($_aControlGuiTrack[$i][3] = $idCtrl)
	Next
	Return False
EndFunc
