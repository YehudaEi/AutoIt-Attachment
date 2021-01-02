#Region Header

#cs

	Title:			Management of Caret Shape UDF Library for AutoIt3
	Filename:		Caret.au3
	Description:	Creating shape for the caret for Input (Edit) controls
	Author:			Yashied
	Version:		1.0
	Requirements:	AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
	Uses:			Constants.au3, EditConstants.au3, WinAPI.au3, WindowsConstants.au3
	Notes:			-

	Available functions:

	_Caret_CreateCaret
	_Caret_DeleteCaret

	Additional features:

	_Caret_CreateBitmapFromIcon
	_Caret_CreateSolidBitmap

	Example:

		#Include <Caret.au3>

		GUICreate('My GUI', 390, 261)

		$Edit = GUICtrlCreateEdit('', 10, 10, 370, 200)
		$Input1 = GUICtrlCreateInput('', 10, 225, 180, 19)
		$Input2 = GUICtrlCreateInput('', 200, 225, 180, 19)

		$hBitmap = _Caret_CreateBitmapFromIcon(@SystemDir & '\shell32.dll', 43, 16, 16)
		_Caret_CreateCaret($Edit, $hBitmap, -1)
		$hBitmap = _Caret_CreateSolidBitmap(0xAAAAAA, 8, 13)
		_Caret_CreateCaret($Input1, $hBitmap)
		$hBitmap = _Caret_CreateBitmapFromIcon(@ScriptFullPath & '\Caret.ico', 0, 8, 13)
		_Caret_CreateCaret($Input2, $hBitmap, 150)

		GUISetState()

		Do
		Until GUIGetMsg() = -3

		_Caret_DeleteCaret($Edit)
		_Caret_DeleteCaret($Input1)
		_Caret_DeleteCaret($Input2)

#ce

#Include-once

#Include <Constants.au3>
#Include <EditConstants.au3>
#Include <WinAPI.au3>
#Include <WindowsConstants.au3>

#EndRegion Header

#Region Local Variables and Constants

Dim $crId[1][3] = [[0, False]]

#cs
	
DO NOT USE THIS ARRAY IN THE SCRIPT, INTERNAL USE ONLY!

$crId[0][0] - Count item of array
     [0][1] - Previous caret blink time, ms
     [0][2] - Don`t used

$crId[i][0] - Handle of the given control ID
     [i][1] - Caret bitmap (hBitmap)
     [i][2] - Caret blink time, ms
	
#ce

Global $OnCaretExit = Opt('OnExitFunc', 'OnCaretExit')

#EndRegion Local Variables and Constants

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _Caret_CreateCaret
; Description ...: Creates a new shape for the system caret and assigns to the specified control.
; Syntax.........: _Caret_CreateCaret ( $hWnd, $hBitmap [, $iBlinkTime] )
; Parameters ....: $hWnd       - Handle or identifier (controlID) to the control.
;                  $hBitmap    - Handle to the bitmap.
;                  $iBlinkTime - Specifies the caret blink time (in milliseconds). (-1) - do not blinking, 0 - system default.
; Return values .: Success     - 1
;                  Failure     - 0 and sets the @error flag to non-zero.
; Author ........: Yashied
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _Caret_CreateCaret($hWnd, $hBitmap, $iBlinkTime = 0)

	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	If $crId[0][0] = 0 Then
		If Not GUIRegisterMsg($WM_COMMAND, '_WM_COMMAND') Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $n = 0, $Focus = _WinAPI_GetFocus()

	For $i = 1 To $crId[0][0]
		If $hWnd = $crId[$i][0] Then
			$n = $i
			ExitLoop
		EndIf
	Next
	If $n = 0 Then
		$n = $crId[0][0] + 1
		ReDim $crId[$n + 1][UBound($crId, 2)]
		$crId[0][0] = $n
	Else
		If $hWnd = $Focus Then
			_Caret_Delete($n)
		EndIf
	EndIf
	$crId[$n][0] = $hWnd
	$crId[$n][1] = $hBitmap
	$crId[$n][2] = $iBlinkTime
	If $hWnd = $Focus Then
		_Caret_Create($n)
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_Caret_CreateCaret

; #FUNCTION# ====================================================================================================================
; Name...........: _Caret_DeleteCaret
; Description ...: Deletes a caret shape to the specified control.
; Syntax.........: _Caret_DeleteCaret ( $hWnd [, $iFlag] )
; Parameters ....: $hWnd   - Handle or identifier (controlID) to the control.
;                  $iFlag  - Bitmap deleting control flag, valid values:
;                  |0 - Delete HBitmap (Default)
;                  |1 - Don`t delete
; Return values .: Success - 1
;                  Failure - 0 and sets the @error flag to non-zero.
; Author ........: Yashied
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _Caret_DeleteCaret($hWnd, $iFlag = 0)

	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	For $i = 1 To $crId[0][0]
		If $hWnd = $crId[$i][0] Then
			If $hWnd = _WinAPI_GetFocus() Then
				_Caret_Delete($i)
			EndIf
			If $iFlag Then
				_WinAPI_DeleteObject($crId[$i][1])
			EndIf
			For $j = $i To $crId[0][0] - 1
				For $k = 0 To UBound($crId, 2) - 1
					$crId[$j][$k] = $crId[$j + 1][$k]
				Next
			Next
			$crId[0][0] -= 1
			ReDim $crId[$crId[0][0] + 1][UBound($crId, 2)]
			If $crId[0][0] = 0 Then
				GUIRegisterMsg($WM_COMMAND, '')
			EndIf
			Return SetError(0, 0, 1)
		EndIf
	Next
	Return SetError(1, 0, 0)
EndFunc   ;==>_Caret_DeleteCaret

; #FUNCTION# ====================================================================================================================
; Name...........: _Caret_CreateBitmapFromIcon
; Description ...: Creates a bitmap for the caret from the specified icon.
; Syntax.........: _Caret_CreateBitmapFromIcon ( $sIcon, $sIndex, $iWidth, $iHeight [, $iBackground] )
; Parameters ....: $sIcon       - Path and name of the file from which the icon are to be extracted.
;                  $sIndex      - Specifies the zero-based index of the icon to extract.
;                  $iWidth      - Specifies the icon width (in pixels).
;                  $iHeight     - Specifies the icon height (in pixels).
;                  $iBackground - The color of the background, stated in RGB.
; Return values .: Success      - The handle to the bitmap.
;                  Failure      - 0
; Author ........: Yashied
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _Caret_CreateBitmapFromIcon($sIcon, $iIndex, $iWidth, $iHeight, $iBackground = 0xFFFFFF)

	Local $hBitmap, $hIcon, $hInv, $hDC, $hBackDC, $hBackSv, $hFrontDC, $hFrontSv

	$hIcon = _Caret_PrivateExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)
	If @error Then
		Return 0
	EndIf

	$hDC = _WinAPI_GetDC(0)
	$hBackDC = _WinAPI_CreateCompatibleDC($hDC)
	$hBitmap = _WinAPI_CreateSolidBitmap(0, 0xFFFFFF - $iBackground, $iWidth, $iHeight)
	$hBackSv = _WinAPI_SelectObject($hBackDC, $hBitmap)
	$hFrontDC = _WinAPI_CreateCompatibleDC($hDC)
	$hInv = _WinAPI_CreateSolidBitmap(0, $iBackground, $iWidth, $iHeight)
	$hFrontSv = _WinAPI_SelectObject($hFrontDC, $hInv)

	_WinAPI_DrawIconEx($hFrontDC, 0, 0, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
	_WinAPI_BitBlt($hBackDC, 0, 0, $iWidth, $iHeight, $hFrontDC, 0, 0, $NOTSRCCOPY)

	_WinAPI_SelectObject($hFrontDC, $hFrontSv)
	_WinAPI_SelectObject($hBackDC, $hBackSv)
	_WinAPI_ReleaseDC(0, $hDC)
	_WinAPI_DeleteDC($hFrontDC)
	_WinAPI_DeleteDC($hBackDC)
	_WinAPI_DeleteObject($hIcon)
	_WinAPI_DeleteObject($hInv)

	Return $hBitmap
EndFunc   ;==>_Caret_CreateBitmapFromIcon

; #FUNCTION# ====================================================================================================================
; Name...........: _Caret_CreateSolidBitmap
; Description ...: Creates a solid color bitmap for the caret.
; Syntax.........: _Caret_CreateSolidBitmap ( $iRGB, $iWidth, $iHeight )
; Parameters ....: $iRGB        - The color of the bitmap, stated in RGB.
;                  $iWidth      - Specifies the bitmap width (in pixels).
;                  $iHeight     - Specifies the bitmap height (in pixels).
; Return values .: Success      - The handle to the bitmap.
;                  Failure      - 0
; Author ........: Yashied
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _Caret_CreateSolidBitmap($iRGB, $iWidth, $iHeight)
	Return _WinAPI_CreateSolidBitmap(0, 0xFFFFFF - $iRGB, $iWidth, $iHeight)
EndFunc   ;==>_Caret_CreateSolidBitmap

#EndRegion Public Functions

#Region Internal Functions

Func _Caret_Create($Index)
	If $crId[$Index][2] Then

		Local $Ret = DllCall('user32.dll', 'int', 'GetCaretBlinkTime')

		If $Ret[0] Then
			$crId[0][1] = $Ret[0]
			DllCall('user32.dll', 'int', 'SetCaretBlinkTime', 'uint', $crId[$Index][2])
		EndIf
	EndIf
	DllCall('user32.dll', 'int', 'CreateCaret', 'hwnd', $crId[$Index][0], 'ptr', $crId[$Index][1], 'int', 0, 'int', 0)
	DllCall('user32.dll', 'int', 'ShowCaret', 'hwnd', $crId[$Index][0])
EndFunc   ;==>_Caret_Create

Func _Caret_Delete($Index)
	DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', $crId[$Index][0])
	DllCall('user32.dll', 'int', 'DestroyCaret')
	If $crId[0][1] Then
		DllCall('user32.dll', 'int', 'SetCaretBlinkTime', 'uint', $crId[0][1])
		$crId[0][1] = False
	EndIf
EndFunc   ;==>_Caret_Delete

Func _Caret_Id($hWnd)
	For $i = 1 To $crId[0][0]
		If $crId[$i][0] = $hWnd Then
			Return $i
		EndIf
	Next
	Return 0
EndFunc   ;==>_Caret_Id

Func _Caret_PrivateExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)

	Local $hIcon, $tIcon = DllStructCreate('hwnd'), $tID = DllStructCreate('hwnd')
	Local $Ret = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)

	If (@error) Or ($Ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf

	$hIcon = DllStructGetData($tIcon, 1)

	If ($hIcon = Ptr(0)) Or (Not IsPtr($hIcon)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $hIcon
EndFunc   ;==>_Caret_PrivateExtractIcons

#EndRegion Internal Functions

#Region Windows Message Functions

Func _WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)

	Local $Code = BitShift($wParam, 16)

	Switch $Code
		Case $EN_SETFOCUS, $EN_KILLFOCUS

			Local $Index = _Caret_Id($lParam)

			If $Index > 0 Then
				Switch $Code
					Case $EN_SETFOCUS
						_Caret_Create($Index)
					Case $EN_KILLFOCUS
						_Caret_Delete($Index)
				EndSwitch
			EndIf
	EndSwitch
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>_WM_COMMAND

#EndRegion Windows Message Functions

#Region OnAutoItExit

Func OnCaretExit()
	If $crId[0][1] Then
		DllCall('user32.dll', 'int', 'SetCaretBlinkTime', 'uint', $crId[0][1])
	EndIf
	For $i = 1 To $crId[0][0]
		_WinAPI_DeleteObject($crId[$i][1])
	Next
	Call($OnCaretExit)
EndFunc   ;==>OnCaretExit

#EndRegion OnAutoItExit
