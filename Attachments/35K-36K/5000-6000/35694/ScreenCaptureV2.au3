#include-once
#include "StdLib\WindowsConstants.au3" ; << MAKES A LOT OF SCREENCAPTURE.AU3 CONSTANTS USELESS (eg. $SM_CXSCREEN, $SRCCOPY, $CAPTUREBLT)
#include "StdLib\WinAPI.au3"
#include "StdLib\ScreenCapture.au3"

;Opt("MustDeclareVars", 1)

Global Const $__SCREENCAPTURECONSTANT_DEFAULT_BITBLT_FLAG = BitOR($SRCCOPY, $CAPTUREBLT)


; #FUNCTION# ====================================================================================================================
; Name...........: _ScreenCapture_CaptureV2
; Description ...: Captures a region of the screen
; Syntax.........: _ScreenCapture_Capture([$sFileName = ""[, $iLeft = 0[, $iTop = 0[, $iRight = -1[, $iBottom = -1[, $fCursor = True[, $iBitBltFlag = Default]]]]]]])
; Parameters ....: $sFileName   - Full path and extension of the image file
;                  $iLeft       - X coordinate of the upper left corner of the rectangle
;                  $iTop        - Y coordinate of the upper left corner of the rectangle
;                  $iRight      - X coordinate of the lower right corner of the rectangle.  If this is  -1,  the  current  screen
;                  +width will be used.
;                  $iBottom     - Y coordinate of the lower right corner of the rectangle.  If this is  -1,  the  current  screen
;                  +height will be used.
;                  $fCursor     - If True the cursor will be captured with the image
;                  $iBitBltFlag - Flag to pass to the _WinAPI_BitBlt operation (default it BitOR($SRCCOPY, $CAPTUREBLT))
; Return values .: See remarks
; Author ........: Paul Campbell (PaulIA)
; History .......: OCT 25, 2011 - Added $iBitBltFlag parameter. It uses $CAPTUREBLT by default in order to capture layered windows
; Remarks .......: If FileName is not blank this function will capture the screen and save it to file. If FileName is blank, this
;                  function will capture the screen and return a HBITMAP handle to the bitmap image.  In this case, after you are
;                  finished with the bitmap you must call _WinAPI_DeleteObject to delete the bitmap handle.
;+
;                  Requires GDI+: GDI+ requires a redistributable for applications  that
;                  run on the Microsoft Windows NT 4.0 SP6, Windows 2000, Windows 98, and Windows Me operating systems.
; Related .......: _WinAPI_DeleteObject, _ScreenCapture_SaveImage
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ScreenCapture_CaptureV2($sFileName = "", $iLeft = 0, $iTop = 0, $iRight = -1, $iBottom = -1, $fCursor = True, $iBitBltFlag = Default)
	If $iRight = -1 Then $iRight = _WinAPI_GetSystemMetrics($SM_CXSCREEN)
	If $iBottom = -1 Then $iBottom = _WinAPI_GetSystemMetrics($SM_CYSCREEN)
	If $iRight < $iLeft Then Return SetError(-1, 0, 0)
	If $iBottom < $iTop Then Return SetError(-2, 0, 0)
	If $iBitBltFlag = Default Then $iBitBltFlag = $__SCREENCAPTURECONSTANT_DEFAULT_BITBLT_FLAG

	Local $iW = ($iRight - $iLeft) + 1
	Local $iH = ($iBottom - $iTop) + 1
	Local $hWnd = _WinAPI_GetDesktopWindow()
	Local $hDDC = _WinAPI_GetDC($hWnd)
	Local $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
	Local $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iW, $iH)
	_WinAPI_SelectObject($hCDC, $hBMP)
	_WinAPI_BitBlt($hCDC, 0, 0, $iW, $iH, $hDDC, $iLeft, $iTop, $iBitBltFlag)

	If $fCursor Then
		Local $aCursor = _WinAPI_GetCursorInfo()
		If $aCursor[1] Then
			Local $hIcon = _WinAPI_CopyIcon($aCursor[2])
			Local $aIcon = _WinAPI_GetIconInfo($hIcon)
			_WinAPI_DeleteObject($aIcon[4]) ; delete bitmap mask return by _WinAPI_GetIconInfo()
			_WinAPI_DrawIcon($hCDC, $aCursor[3] - $aIcon[2] - $iLeft, $aCursor[4] - $aIcon[3] - $iTop, $hIcon)
			_WinAPI_DestroyIcon($hIcon)
		EndIf
	EndIf

	_WinAPI_ReleaseDC($hWnd, $hDDC)
	_WinAPI_DeleteDC($hCDC)
	If $sFileName = "" Then Return $hBMP

	_ScreenCapture_SaveImage($sFileName, $hBMP)
	_WinAPI_DeleteObject($hBMP)
EndFunc   ;==>_ScreenCapture_CaptureV2

; #FUNCTION# ====================================================================================================================
; Name...........: _ScreenCapture_CaptureWndV2
; Description ...: Captures a screen shot of a specified window. This function is an alternative to '_ScreenCapture_CaptureWnd'.
;                  It is able to take screenshots of layered windows (drawn by the graphic card). See 'remarks' below.
; Syntax.........: _ScreenCapture_CaptureWndV2($sFileName, $hWnd[, $iLeft = 0[, $iTop = 0[, $iRight = -1[, $iBottom = -1[, $fCursor = True[, $iBitBltFlag = Default]]]]]])
; Parameters ....: $sFileName   - Full path and extension of the image file
;                  $hWnd        - Handle to the window to be captured
;                  $iLeft       - X coordinate of the upper left corner of the client rectangle
;                  $iTop        - Y coordinate of the upper left corner of the client rectangle
;                  $iRight      - X coordinate of the lower right corner of the rectangle
;                  $iBottom     - Y coordinate of the lower right corner of the rectangle
;                  $fCursor     - If True the cursor will be captured with the image
;                  $iBitBltFlag - Flag to pass to the _WinAPI_BitBlt operation (default it BitOR($SRCCOPY, $CAPTUREBLT))
; Return values .: See remarks
; Remarks .......: 1/ If FileName is not blank this function will capture the screen and save it to file. If FileName is blank, this
;                  function will capture the screen and return a HBITMAP handle to the bitmap image.  In this case, after you are
;                  finished with the bitmap you must call _WinAPI_DeleteObject to delete the bitmap handle.  All coordinates are  in
;                  client coordinate mode.
;
;                  2.1/ Layered windows do not appear on screenshots taken by '_ScreenCapture_Capture' because it uses the desktop's
;                  handle whereas the layered windows are drawn directly by the graphic card. 2.2/ '_ScreenCapture_CaptureWnd'
;                  is a wrapper of '_ScreenCapture_Capture' and, therefore, has the same limitations. 2.3/ Instead,
;                  '_ScreenCapture_CaptureWndV2', THIS FUNCTION, is using the handle of the targetted window to perfom its task
;                  (in a similar way than '_ScreenCapture_Capture'uses the Desktop's handle).
;
; Author ........: Patryk Szczepankiewicz (pszczepa at gmail dot com)
; History .......: JAN 21, 2009 - Created
;                  OCT 18, 2010 - First release on the AutoIT forum
;                  OCT 28, 2010 - Cleaned the border code and fixed the capture of the cursor.
;                  APR 06, 2011 - Updated for AutoIT 3.3.6.1
;                  OCT 25, 2011 - Added $iBitBltFlag parameter. It uses $CAPTUREBLT by default in order to capture layered windows
; Related .......: _WinAPI_DeleteObject
; Link ..........; http://www.autoitscript.com/forum/index.php?showtopic=65008
; Example .......; No
; Credits .......: Based on Paul Campbell's '_ScreenCapture_Capture' function and inspired by Jennico's '_WinGetBorderSize'.
; ===============================================================================================================================
Func _ScreenCapture_CaptureWndV2($sFileName, $hWnd, $iLeft = 0, $iTop = 0, $iRight = -1, $iBottom = -1, $fCursor = True, $iBitBltFlag = Default)

	Local $tRect
	Local $iWndX, $iWndY, $iWndW, $iWndH

	Local $tClient
	Local $iBorderV, $iBorderT
	Local $iPicHeight, $iPicWidth
	Local $iPicCursorX, $iPicCursorY


	Local $hDDC, $hCDC, $hBMP, $aCursor, $aIcon, $hIcon

	; Default parameters
	If $iBitBltFlag = Default Then $iBitBltFlag = $__SCREENCAPTURECONSTANT_DEFAULT_BITBLT_FLAG

	; Get the absolute coordinates of the window
	$tRect = _WinAPI_GetWindowRect($hWnd)

	; Get useful variables
	$iWndX = DllStructGetData($tRect, "Left")
	$iWndY = DllStructGetData($tRect, "Top")
	$iWndW = DllStructGetData($tRect, "Right")
	$iWndH = DllStructGetData($tRect, "Bottom")

	; Assign automatic values: the right and bottom are computed as
	; the width and height of the absolute coordinates of the window.
	If $iRight = -1 Then $iRight = $iWndW - $iWndX
	If $iBottom = -1 Then $iBottom = $iWndH - $iWndY

	; Check user values: check that caller is not putting the top-left
	; corner out of the window.
	If $iLeft > $iWndW Then $iLeft = $iWndX
	If $iTop > $iWndH Then $iTop = $iWndY

	; Check user values: check that caller is not asking for a
	; screenshot bigger than the window itelf.
	If $iRight > $iWndW Then $iRight = $iWndW
	If $iBottom > $iWndH Then $iBottom = $iWndH

	; Compute the size of the final picture.
	$iPicWidth = $iRight - $iLeft
	$iPicHeight = $iBottom - $iTop

	; Compute the borders sizes
	$tClient = _WinAPI_GetClientRect($hWnd)
	$iBorderV = (($iWndW - $iWndX) - DllStructGetData($tClient, "Right")) / 2
	$iBorderT = ($iWndH - $iWndY) - DllStructGetData($tClient, "Bottom") - $iBorderV

	; Transfert color data
	$hDDC = _WinAPI_GetDC($hWnd)
	$hCDC = _WinAPI_CreateCompatibleDC($hDDC)
	$hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iPicWidth, $iPicHeight)
	_WinAPI_SelectObject($hCDC, $hBMP)
	_WinAPI_BitBlt($hCDC, 0, 0, $iPicWidth, $iPicHeight, $hDDC, $iLeft - $iBorderV, $iTop - $iBorderT, $iBitBltFlag)

	; Add the cursor on the screenshot
	If $fCursor Then
		$aCursor = _WinAPI_GetCursorInfo()
		If $aCursor[1] Then
			$hIcon = _WinAPI_CopyIcon($aCursor[2])
			$aIcon = _WinAPI_GetIconInfo($hIcon)
			$iPicCursorX = $aCursor[3] - $aIcon[2] - $iWndX - $iLeft
			$iPicCursorY = $aCursor[4] - $aIcon[3] - $iWndY - $iTop
			_WinAPI_DrawIcon($hCDC, $iPicCursorX, $iPicCursorY, $hIcon)
		EndIf
	EndIf

	; Clean and save data
	_WinAPI_ReleaseDC($hWnd, $hDDC)
	_WinAPI_DeleteDC($hCDC)
	If $sFileName = "" Then Return $hBMP
	_ScreenCapture_SaveImage($sFileName, $hBMP)

EndFunc   ;==>_ScreenCapture_CaptureWndV2
