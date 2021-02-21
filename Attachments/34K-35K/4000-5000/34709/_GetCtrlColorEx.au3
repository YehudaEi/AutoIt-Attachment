;#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include-Once
#include <WinAPI.au3>

; #INDEX# =========================================================================================
; Title .........: _GetCtrlColorEx
; AutoIt Version : 3.3.++
; Language ..... : English
; Description ...: Functions for retrieving in-process standard control and gui form text colour, background colour and background mode
; Author(s) .....: Rover 2k11 - code portions and ideas from: Chris Boss, Prog@ndy, Malkey, Yashied, and Wraithdu.
;
;http://powerbasic.com/support/pbforums/showthread.php?t=9183
;PowerBASIC for Windows forum
;How do I find the colors of a subclassed control?
;
;GUICtrlGetColor() - Prog@ndy, Malkey, Yashied
;http://www.autoitscript.com/forum/topic/92587-guictrlgetcolor/
;
;References:
;Article ID: 130952 - Last Review: July 11, 2005 - Revision: 2.3
;INFO: WM_CTLCOLORxxx Message Changes
;http://support.microsoft.com/kb/130952
;
;
;Retrieve the RGB colours of visible, hidden or disabled Standard Controls
;on active, inactive, hidden, disabled, locked or minimized AutoIt GUI forms.
;
;The following form/control classes have been tested in XP x86 / VISTA x86:

;AutoIt v3 GUI, Static (Label), Edit(Edit/Input),
;Button (Ownerdrawn/Classic Theme PushButton**, Group, Radio, CheckBox), ListBox, ComboBox
;
;*This UDF only supports controls in the current script process. It does not work with external process controls.
;
;Nor does it support controls that are painted on (colour not set through WM_CTLCOLORSTATIC message to DC)
;themed controls or Common Controls (they have their own methods to retrieve colour)
;
;Does not return transparent layered window attributes, use _WinAPI_GetLayeredWindowAttributes()
;
;Disabled and/or hidden controls will still return their enabled colours,
;the WM_CTLCOLORSTATIC message does not return the system colours for disabled controls.
;
;
;**NOTE: ownerdrawn buttons with no set background color default to the COLOR_BTNFACE system colour,
;but the returned background mode is OPAQUE and the colour is the underlying colour of the gui,
;so GetPixel() is required in _GuiCtrlGetColorEx() to get the actual colour.
; =================================================================================================

; #CURRENT# =======================================================================================
;_GuiCtrlGetTextColorEx
;_GuiCtrlGetBkColorEx
;_GUIGetBkColorEx
;_GuiCtrlGetColorEx - _GuiCtrlGetTextColorEx and _GuiCtrlGetBkColorEx are derived from this all-in-one bloated testing version
; =================================================================================================


; #FUNCTION# ======================================================================================
; Name...........: _GUICtrlGetTextColorEx
; Description ...: Get RGB text colour of in-process standard controls
; Syntax.........: _GUICtrlGetTextColorEx($hWnd, $iRType = 0)
; Parameters ....: $hWnd - Handle or Control ID of standard control: Static (Label), Edit(Edit/Input),
;                  Button (Ownerdrawn/Classic Theme PushButton**, Group, Radio, CheckBox), ListBox, ComboBox
; Parameters ....: $iRType - RGB return type: 0 = Integer / 1 = Hex String
; Return values .: Success - Returns the RGB value as Integer or Hex String
;                  Failure - $CLR_INVALID = 0xFFFFFFFF (-1), sets @error to integer indicating location in function.
; Author ........: rover 2k11 - code portions and ideas from: Chris Boss, Prog@ndy, Malkey, Yashied, and Wraithdu.
; Modified.......:
; Remarks .......: Returns text colour for visible, hidden or disabled in-process controls.
;                  on an active, inactive, hidden, locked, disabled or minimized gui.
; Related .......:
; Link ..........:
; Example .......: Yes
; =================================================================================================
Func _GUICtrlGetTextColorEx($hWnd, $iRType = 0)
	;Author: rover 2k11
	If Not IsDeclared("CLR_INVALID") Then Local Const $CLR_INVALID = 0xFFFFFFFF
	Local $iRet = $CLR_INVALID
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, $iRet)
	Local $hParent = _WinAPI_GetParent($hWnd)
	If Not IsHWnd($hParent) Then Return SetError(2, @error, $iRet)
	If Not IsDeclared("WM_CTLCOLORSTATIC") Then Local Const $WM_CTLCOLORSTATIC = 0x0138
	Local $hDC = _WinAPI_GetDC($hWnd)
	If @error Or $hDC = 0 Then Return SetError(3, @error, $iRet)
	Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC)
	If @error Or $hMemDC = 0 Then Return SetError(4, _WinAPI_ReleaseDC($hWnd, $hDC), $iRet)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	Local $hBrush = _SendMessage($hParent, $WM_CTLCOLORSTATIC, $hMemDC, $hWnd) ;do not delete returned brush
	If @error Or $hBrush = 0 Then Return SetError(5, _WinAPI_DeleteDC($hMemDC), $iRet)
	Local $BGR = DllCall('gdi32.dll', 'int', 'GetTextColor', 'ptr', $hMemDC)
	If @error Or $BGR[0] = $CLR_INVALID Then Return SetError(6, _WinAPI_DeleteDC($hMemDC), $iRet)
	_WinAPI_DeleteDC($hMemDC)
	;_BGR2RGB($iColor) Author: Wraithdu
	If $iRType = 0 Then $iRet = BitOR(BitShift(BitAND($BGR[0], 0x0000FF), -16), BitAND($BGR[0], 0x00FF00), BitShift(BitAND($BGR[0], 0xFF0000), 16))
	If $iRType = 1 Then $iRet = "0x" & StringRegExpReplace(Hex($BGR[0], 6), "(.{2})(.{2})(.{2})", "\3\2\1"); Author: Prog@ndy
	Return SetError(0, 0, $iRet)
EndFunc   ;==>_GUICtrlGetTextColorEx


; #FUNCTION# ======================================================================================
; Name...........: _GUICtrlGetBkColorEx
; Description ...: Get RGB background colour and background mode of in-process standard controls
; Syntax.........: _GUICtrlGetBkColorEx($hWnd, $iRType = 0)
; Parameters ....: $hWnd - Handle or Control ID of standard control: Static (Label), Edit(Edit/Input),
;                  Button (Ownerdrawn PushButton**), Group, Radio, CheckBox), ListBox, ComboBox
; Parameters ....: $iRType - RGB return type: 0 = Integer / 1 = Hex String
; Return values .: Success - Returns the RGB value as Integer or Hex String
;                  Returns background colour for $OPAQUE, returns 0xFFFFFFFF (-1) for $TRANSPARENT
;                  @Extended set to background mode: 1 = $TRANSPARENT - 2 = $OPAQUE
;                  Failure - $CLR_INVALID = 0xFFFFFFFF (-1), sets @error to integer indicating location in function.
; Author ........: rover 2k11 - code portions and ideas from: Chris Boss, Prog@ndy, Malkey, Yashied, and Wraithdu.
; Modified.......:
; Remarks .......: Returns background colour for visible, hidden or disabled in-process controls.
;                  on an active, inactive, hidden, locked, disabled or minimized gui.
; Note:          ; ** Use _GUIGetBkColorEx() on classic theme Buttons
; Related .......:
; Link ..........:
; Example .......: Yes
; =================================================================================================
Func _GUICtrlGetBkColorEx($hWnd, $iRType = 0)
	;Author: rover 2k11
	If Not IsDeclared("CLR_INVALID") Then Local Const $CLR_INVALID = 0xFFFFFFFF
	Local $iRet = $CLR_INVALID
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, $iRet)
	Local $hParent = _WinAPI_GetParent($hWnd)
	If Not IsHWnd($hParent) Then Return SetError(2, @error, $iRet)
	If Not IsDeclared("WM_CTLCOLORSTATIC") Then Local Const $WM_CTLCOLORSTATIC = 0x0138
	Local $hDC = _WinAPI_GetDC($hWnd)
	If @error Or $hDC = 0 Then Return SetError(3, @error, $iRet)
	Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC)
	If @error Or $hMemDC = 0 Then Return SetError(4, _WinAPI_ReleaseDC($hWnd, $hDC), $iRet)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	If @error Then Return SetError(5, _WinAPI_DeleteDC($hMemDC), $iRet)
	Local $hBrush = _SendMessage($hParent, $WM_CTLCOLORSTATIC, $hMemDC, $hWnd) ;do not delete returned brush
	If @error Or $hBrush = 0 Then Return SetError(6, _WinAPI_DeleteDC($hMemDC), $iRet)
	Local $iMode = _WinAPI_GetBkMode($hMemDC)
	If @error Then Return SetError(7, _WinAPI_DeleteDC($hMemDC), $iRet)
	Local $BGR = DllCall('gdi32.dll', 'int', 'GetBkColor', 'ptr', $hMemDC)
	If @error Or $BGR[0] = $CLR_INVALID Then Return SetError(8, _WinAPI_DeleteDC($hMemDC), $iRet)
	;_BGR2RGB($iColor) Author: Wraithdu
	If $iMode = 2 And $iRType = 0 Then $iRet = BitOR(BitShift(BitAND($BGR[0], 0x0000FF), -16), BitAND($BGR[0], 0x00FF00), BitShift(BitAND($BGR[0], 0xFF0000), 16))
	If $iMode = 2 And $iRType = 1 Then $iRet = "0x" & StringRegExpReplace(Hex($BGR[0], 6), "(.{2})(.{2})(.{2})", "\3\2\1"); Author: Prog@ndy
	_WinAPI_DeleteDC($hMemDC)
	Return SetError(0, $iMode, $iRet)
EndFunc   ;==>_GUICtrlGetBkColorEx


; #FUNCTION# ======================================================================================
; Name...........: _GUIGetBkColorEx
; Description ...: Get RGB background colour of in-process GUI forms
; Syntax.........: _GUIGetBkColorEx($hWnd, $iRType = 0)
; Parameters ....: $hWnd - Handle to GUI form
; Parameters ....: $iRType - RGB return type: 0 = Integer / 1 = Hex String
; Return values .: Success - Returns the RGB value as Integer or Hex String
;                  Failure - $CLR_INVALID = 0xFFFFFFFF (-1), sets @error to integer indicating location in function.
; Author ........: rover 2k11 - code portions and ideas from: Chris Boss, Prog@ndy, Malkey, Yashied, and Wraithdu.
; Modified.......:
; Remarks .......: Returns background colour for active, inactive, hidden, locked, disabled or minimized in-process forms.
; Related .......:
; Link ..........:
; Example .......: Yes
; =================================================================================================
Func _GUIGetBkColorEx($hWnd, $iRType = 0)
	;Author: rover 2k11
	If Not IsDeclared("CLR_INVALID") Then Local Const $CLR_INVALID = 0xFFFFFFFF
	Local $iRet = $CLR_INVALID
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, $iRet)
	If Not IsDeclared("WM_CTLCOLORDLG") Then Local Const $WM_CTLCOLORDLG = 0x0136
	Local $hDCGui = _WinAPI_GetDC($hWnd), $iError = 0, $Ret
	If @error Or $hDCGui = 0 Then Return SetError(2, @error, $iRet)
	Local $hMemDC = _WinAPI_CreateCompatibleDC($hDCGui)
	If @error Or $hMemDC = 0 Then Return SetError(3, _WinAPI_ReleaseDC($hWnd, $hDCGui), $iRet)
	$Ret = _SendMessage($hWnd, $WM_CTLCOLORDLG, $hMemDC, $hWnd)
	$iError = @error
	_WinAPI_ReleaseDC($hWnd, $hDCGui)
	If $iError Or $Ret = 0 Then Return SetError(4, _WinAPI_DeleteDC($hMemDC), $iRet)
	Local $BGR = DllCall("gdi32.dll", "int", "GetBkColor", "ptr", $hMemDC)
	If @error Or $BGR[0] = $CLR_INVALID Then Return SetError(5, _WinAPI_DeleteDC($hMemDC), $iRet)
	_WinAPI_DeleteDC($hMemDC)
	$iError = @error
	;_BGR2RGB($iColor) Author: Wraithdu
	If $iRType = 0 Then $iRet = BitOR(BitShift(BitAND($BGR[0], 0x0000FF), -16), BitAND($BGR[0], 0x00FF00), BitShift(BitAND($BGR[0], 0xFF0000), 16))
	If $iRType = 1 Then $iRet = "0x" & StringRegExpReplace(Hex($BGR[0], 6), "(.{2})(.{2})(.{2})", "\3\2\1"); Author: Prog@ndy
	Return SetError(0, $iError, $iRet)
EndFunc   ;==>_GUIGetBkColorEx



; #FUNCTION# ======================================================================================
; Name...........: _GUICtrlGetColorEx
; Description ...: Get RGB text/background colour and background mode of in-process controls.
;                  Determines ownerdrawn/theme status of buttons
; Syntax.........: _GUICtrlGetColorEx($hWnd, $iRType = 0)
; Parameters ....: $hWnd - Handle or Control ID of standard control: Static (Label), Edit(Edit/Input),
;                  Button (Ownerdrawn/Classic Theme PushButton**, Group, Radio, CheckBox), ListBox, ComboBox
;                  Returns background colour for $OPAQUE, returns 0xFFFFFFFF (-1) for $TRANSPARENT
; Parameters ....: $iRType - RGB return type: 0 = Integer / 1 = Hex String
; Return values .: Success - An array containing the RGB values/background mode/ownerdrawn/theme status of buttons
;                  Failure - $CLR_INVALID = 0xFFFFFFFF, sets @error to integer indicating location in function.
; Author ........: rover 2k11 - code portions and ideas from: Chris Boss, Prog@ndy, Malkey, Yashied, and Wraithdu.
; Modified.......:
; Remarks .......: Returns text/background colour and mode for visible, hidden or disabled in-process controls.
;                  on an active, inactive, hidden, locked, disabled or minimized gui.
;
; NOTE:..........; Use the separate functions _GUICtrlGetTextColorEx() and_GUICtrlGetBkColorEx()
;                  instead of this testing version.
; Related .......:
; Link ..........:
; Example .......: Yes
; =================================================================================================
Func _GUICtrlGetColorEx($hWnd, $iRType = 0)
	;Author: rover 2k11
	If Not IsDeclared("CLR_INVALID") Then Local Const $CLR_INVALID = 0xFFFFFFFF
	If Not IsDeclared("GWL_STYLE") Then Local Const $GWL_STYLE = 0xFFFFFFF0
	Local $aRet[2][2] = [[$CLR_INVALID, $CLR_INVALID],[$CLR_INVALID, $CLR_INVALID]] ;set default return to $CLR_INVALID = -1 0xFFFFFFFF

	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, $aRet)
	Local $hParent = _WinAPI_GetParent($hWnd)
	If Not IsHWnd($hParent) Then Return SetError(2, @error, $aRet)

	Local $sClass = _WinAPI_GetClassName($hWnd), $fPushButton = False
	If $sClass == "Button" Then

		If Not IsDeclared("BS_OWNERDRAW") Then Local Const $BS_OWNERDRAW = 0xB
		If Not IsDeclared("BS_GROUPBOX") Then Local Const $BS_GROUPBOX = 0x0007
		If Not IsDeclared("BS_CHECKBOX") Then Local Const $BS_CHECKBOX = 0x0002
		If Not IsDeclared("BS_AUTOCHECKBOX") Then Local Const $BS_AUTOCHECKBOX = 0x0003
		If Not IsDeclared("BS_3STATE") Then Local Const $BS_3STATE = 0x0005
		If Not IsDeclared("BS_RADIOBUTTON") Then Local Const $BS_RADIOBUTTON = 0x4
		If Not IsDeclared("BS_AUTO3STATE") Then Local Const $BS_AUTO3STATE = 0x0006
		If Not IsDeclared("BS_AUTORADIOBUTTON") Then Local Const $BS_AUTORADIOBUTTON = 0x0009

		Local $iStyle = Binary(_WinAPI_GetWindowLong($hWnd, $GWL_STYLE))
		Select
			Case $iStyle <= 0
				Return SetError(3, 0, $aRet)
			Case BitAND($iStyle, $BS_OWNERDRAW) = $BS_OWNERDRAW
				$fPushButton = True
				$aRet[1][1] = "OWNERDRAWN"
			Case BitAND($iStyle, $BS_GROUPBOX) = $BS_GROUPBOX
			Case BitAND($iStyle, $BS_CHECKBOX) = $BS_CHECKBOX
			Case BitAND($iStyle, $BS_3STATE) = $BS_3STATE
			Case BitAND($iStyle, $BS_RADIOBUTTON) = $BS_RADIOBUTTON
			Case BitAND($iStyle, $BS_AUTORADIOBUTTON) = $BS_AUTORADIOBUTTON
			Case BitAND($iStyle, $BS_AUTO3STATE) = $BS_AUTO3STATE
			Case BitAND($iStyle, $BS_AUTOCHECKBOX) = $BS_AUTOCHECKBOX
			Case Else ;determine if default BS_PUSHBUTTON is themed
				;theme handle should not be deleted
				Local $Themed = DllCall('uxtheme.dll', 'ptr', 'GetWindowTheme', 'hwnd', $hWnd) ;Yashied - From WinAPIEx.au3
				If @error Or $Themed[0] <> 0 Then
					$aRet[1][1] = "THEMED"
					If @error Then $aRet[1][1] = "THEME ERROR"
					Return SetError(4, @error, $aRet)
				EndIf
				$aRet[1][1] = "UNTHEMED"
				$fPushButton = True
		EndSelect
	EndIf

	Local $iBkPix = $CLR_INVALID, $fVisible = False, $BGR
	If Not IsDeclared("WM_CTLCOLORSTATIC") Then Local Const $WM_CTLCOLORSTATIC = 0x0138
	If Not IsDeclared("COLOR_BTNFACE") Then Local Const $COLOR_BTNFACE = 15
	If Not IsDeclared("OBJ_BRUSH") Then Local Const $OBJ_BRUSH = 2
	If Not IsDeclared("OBJ_DC") Then Local Const $OBJ_DC = 3
	If Not IsDeclared("OBJ_MEMDC") Then Local Const $OBJ_MEMDC = 10

	Local $hDC = _WinAPI_GetDC($hWnd)
	If @error Or $hDC = 0 Then Return SetError(5, @error, $aRet)
	Local $Ret = DllCall('gdi32.dll', 'dword', 'GetObjectType', 'ptr', $hDC);Yashied - From WinAPIEx.au3
	If @error Or $Ret[0] <> $OBJ_DC Then Return SetError(6, @error, $aRet) ;no dc here

	If $fPushButton Then
		Local $fParentWin = BitAND(WinGetState($hParent), 8) = 8 ;enabled status
		Local $fCtrl = BitAND(WinGetState($hWnd), 2) = 2 ;visible status
		If $fParentWin = True And $fCtrl = True Then
			$fVisible = True
			;REAL BACKGROUND COLOUR - VISIBLE CONTROL ONLY - FOR CONFIRMING TRANSPARENT/OPAQUE unthemed/ownerdrawn BUTTONS
			$BGR = DllCall("gdi32.dll", "int", "GetPixel", "ptr", $hDC, "int", 6, "int", 6)
			If @error = 0 And $BGR[0] <> $CLR_INVALID Then
				;_BGR2RGB($iColor) Author: Wraithdu
				If $iRType = 0 Then $iBkPix = BitOR(BitShift(BitAND($BGR[0], 0x0000FF), -16), BitAND($BGR[0], 0x00FF00), BitShift(BitAND($BGR[0], 0xFF0000), 16))
				If $iRType = 1 Then $iBkPix = "0x" & StringRegExpReplace(Hex($BGR[0], 6), "(.{2})(.{2})(.{2})", "\3\2\1"); Author: Prog@ndy
			EndIf
		EndIf
	EndIf

	Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC) ;create memory DC to write colours to
	If @error Or $hMemDC = 0 Then Return SetError(7, _WinAPI_ReleaseDC($hWnd, $hDC), $aRet)

	_WinAPI_ReleaseDC($hWnd, $hDC)
	If @error Then Return SetError(8, @error, $aRet)

	$Ret = DllCall('gdi32.dll', 'dword', 'GetObjectType', 'ptr', $hMemDC);Yashied - From WinAPIEx.au3
	If @error Or $Ret[0] <> $OBJ_MEMDC Then Return SetError(9, _WinAPI_DeleteDC($hMemDC), $aRet) ;no mem dc here

	Local $hBrush = _SendMessage($hParent, $WM_CTLCOLORSTATIC, $hMemDC, $hWnd, 0, "wParam", "lParam", "ptr") ;do not delete returned brush
	If @error Or $hBrush = 0 Then Return SetError(10, _WinAPI_DeleteDC($hMemDC), $aRet)
	$Ret = DllCall('gdi32.dll', 'dword', 'GetObjectType', 'ptr', $hBrush);Yashied - From WinAPIEx.au3
	If @error Or $Ret[0] <> $OBJ_BRUSH Then Return SetError(11, _WinAPI_DeleteDC($hMemDC), $aRet) ;brush not returned
	;BACKGROUND MODE
	Local $iMode = _WinAPI_GetBkMode($hMemDC)
	If @error Then Return SetError(12, _WinAPI_DeleteDC($hMemDC), $aRet)
	;TEXT COLOUR
	$BGR = DllCall('gdi32.dll', 'int', 'GetTextColor', 'ptr', $hMemDC)
	If @error Then Return SetError(13, _WinAPI_DeleteDC($hMemDC), $aRet)
	If $BGR[0] <> $CLR_INVALID Then
		;_BGR2RGB($iColor) Author: Wraithdu
		If $iRType = 0 Then $aRet[0][0] = BitOR(BitShift(BitAND($BGR[0], 0x0000FF), -16), BitAND($BGR[0], 0x00FF00), BitShift(BitAND($BGR[0], 0xFF0000), 16))
		If $iRType = 1 Then $aRet[0][0] = "0x" & StringRegExpReplace(Hex($BGR[0], 6), "(.{2})(.{2})(.{2})", "\3\2\1"); Author: Prog@ndy
	EndIf
	;BACKGROUND COLOUR
	$BGR = DllCall('gdi32.dll', 'int', 'GetBkColor', 'ptr', $hMemDC)
	If @error Then Return SetError(14, _WinAPI_DeleteDC($hMemDC), $aRet)
	If $BGR[0] <> $CLR_INVALID Then
		;_BGR2RGB($iColor) Author: Wraithdu
		If $iRType = 0 Then $aRet[1][0] = BitOR(BitShift(BitAND($BGR[0], 0x0000FF), -16), BitAND($BGR[0], 0x00FF00), BitShift(BitAND($BGR[0], 0xFF0000), 16))
		If $iRType = 1 Then $aRet[1][0] = "0x" & StringRegExpReplace(Hex($BGR[0], 6), "(.{2})(.{2})(.{2})", "\3\2\1"); Author: Prog@ndy
	EndIf

	_WinAPI_DeleteDC($hMemDC)

	Switch $iMode
		Case 1
			If $aRet[1][1] <> $CLR_INVALID Then
				$aRet[1][1] &= "|TRANSPARENT"
			Else
				$aRet[1][1] = "TRANSPARENT"
			EndIf
			If $aRet[1][0] = 0xFFFFFF Then $aRet[1][0] = $CLR_INVALID
		Case 2
			If $aRet[1][1] <> $CLR_INVALID Then
				If ($aRet[1][1] = "OWNERDRAWN") Or ($aRet[1][1] = "UNTHEMED") Then
					If $iBkPix <> $CLR_INVALID And $fVisible = True And $aRet[1][0] <> $iBkPix Then $aRet[1][0] = $iBkPix
					If ($aRet[1][1] = "UNTHEMED") And ($iBkPix = $CLR_INVALID) Then
						$aRet[1][0] = _WinAPI_GetSysColor($COLOR_BTNFACE)
						;_BGR2RGB($iColor) Author: Wraithdu
						If $iRType = 0 Then $aRet[1][0] = BitOR(BitShift(BitAND($aRet[1][0], 0x0000FF), -16), BitAND($BGR[0], 0x00FF00), BitShift(BitAND($BGR[0], 0xFF0000), 16))
						If $iRType = 1 Then $aRet[1][0] = "0x" & StringRegExpReplace(Hex($aRet[1][0], 6), "(.{2})(.{2})(.{2})", "\3\2\1"); Author: Prog@ndy
					EndIf
				EndIf
				$aRet[1][1] &= "|OPAQUE"
				If ($fVisible = False) Then $aRet[1][1] &= "|HIDDEN"
			Else
				$aRet[1][1] = "OPAQUE"
			EndIf
		Case Else
			If $aRet[1][1] <> $CLR_INVALID Then
				$aRet[1][1] &= "|ERROR"
			Else
				$aRet[1][1] = "ERROR"
			EndIf
	EndSwitch

	Return SetError(0, @error, $aRet)
EndFunc   ;==>_GUICtrlGetColorEx