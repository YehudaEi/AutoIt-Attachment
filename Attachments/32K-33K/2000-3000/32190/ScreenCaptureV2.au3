#include-once
#include <WinAPI.au3>
#include <ScreenCapture.au3>


; #FUNCTION# ====================================================================================================================
; Name...........: _ScreenCapture_CaptureWndV2
; Description ...: Captures a screen shot of a specified window. This function is an alternative to '_ScreenCapture_CaptureWnd'.
;                  It is able to take screenshots of layered windows (drawn by the graphic card). See 'remarks' below.
; Syntax.........: _ScreenCapture_CaptureWndV2($sFileName, $hWnd[, $iLeft = 0[, $iTop = 0[, $iRight = -1[, $iBottom = -1[, $fCursor = True]]]]])
; Parameters ....: $sFileName   - Full path and extension of the image file
;                  $hWnd        - Handle to the window to be captured
;                  $iLeft       - X coordinate of the upper left corner of the client rectangle
;                  $iTop        - Y coordinate of the upper left corner of the client rectangle
;                  $iRight      - X coordinate of the lower right corner of the rectangle
;                  $iBottom     - Y coordinate of the lower right corner of the rectangle
;                  $fCursor     - If True the cursor will be captured with the image
; Return values .: See remarks
; Author ........: Patryk Szczepankiewicz (pszczepa at gmail dot com)
; Modified.......:
; History .......: JAN 21, 2009 - Created
;                  OCT 18, 2010 - First release on the AutoIT forum
;                  OCT 28, 2010 - Cleaned the border code and fixed the capture of the cursor.
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
; Modified.......:
; Related .......: _WinAPI_DeleteObject
; Link ..........; http://www.autoitscript.com/forum/index.php?showtopic=65008
; Example .......; No
; Credits .......: Based on Paul Campbell's '_ScreenCapture_Capture' function and inspired by Jennico's '_WinGetBorderSize'.
; ===============================================================================================================================
Func _ScreenCapture_CaptureWndV2($sFileName, $hWnd, $iLeft = 0, $iTop = 0, $iRight = -1, $iBottom = -1, $fCursor = True)

	Local $tRect
	Local $iWndX, $iWndY, $iWndW, $iWndH

	Local $tClient
	Local $iBorderV, $iBorderT
	Local $iPicHeight, $iPicWidth
	Local $iPicCursorX, $iPicCursorY


	Local $hDDC, $hCDC, $hBMP, $aCursor, $aIcon, $hIcon

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
	_WinAPI_BitBlt($hCDC, 0, 0, $iPicWidth, $iPicHeight, $hDDC, $iLeft-$iBorderV, $iTop-$iBorderT, $SRCCOPY)

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

EndFunc
