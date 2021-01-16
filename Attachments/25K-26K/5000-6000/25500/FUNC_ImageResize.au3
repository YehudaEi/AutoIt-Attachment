; #FUNCTION# ====================================================================================================================
; Name...........: _ImageResize
; Description ...: Resizes image to values as given and saves to $sOutImage
; Syntax.........: _ImageResize($sInImage, $sOutImage, $iW = -1, $iH = -1, $bPreserveAR = True, $bStretch = False, $bUseExtensions = False)
; Parameters ....: $sInImage - Full path and filename of the image to be resized
; 				   $sOutImage - Full path and filename of the file to save to
; 				   $iW - Width in pixels (optional - Will default to $sInImage width)
; 				   $iH - Height in pixels (optional - Will default to $sInImage height)
;                  $bPreserveAR - Boolean, True to preserve aspect ratio, False to not (optional - Default True)
;                  $bStretch - Boolean, True increases small images to fit, False does not (optional - Default False)
;                  $bUseExtensions - Boolean, Indicates whether to use the extensions list or not (optional - Default False)
; Return values .: Success - Returns a 1
;                  Failure - Returns a 0
;                  @Error  - 0 = No error.
;                  |1 = Input file does not exist
;                  |2 = Not a recognized image format
;                  |3 = No resize performed
; Author ........: Original from n3nE
;                  Edited by Jason Webb (jasondexterwebb at gmail dot com)
; Modified.......: 04/06/2009
; Remarks .......: This function assumes that if a H and W are inputted then the user does not want an image bigger than either of
;                   those numbers. Aspect Ratio and Strectch are taken into account if required however the image will never be bigger
;                   in either dimension than what was requested.
; Related .......:
; Link ..........;
; Enhancements ..; add option to use a specify a ratio based resize eg. 0.5 would be half original size, 2.0 would be twize original etc.
;                  add more file extensions
;                  add ability to pass file extension array to function
; ===============================================================================================================================
Func _ImageResize($sInImage, $sOutImage, $iW = -1, $iH = -1, $bPreserveAR = True, $bStretch = False, $bUseExtensions = False)
	
	Local $hWnd, $hDC, $hBMP, $hImage1, $hImage2, $hGraphic, $CLSID, $i = 0
	Local $sOF, $Ext, $vAspectR
	Local $tPath, $tDir
	Local $aImageExtensions
	
	Dim $aImageExtensions[4] = ["jpg", "tif", "jpeg", "bmp"]
	_ArraySort($aImageExtensions)

;~ 	Process Defaults
	If $iW = Default Then $iW = -1
	If $iH = Default Then $iH = -1
;~ must use "==" below because False = Default resolves to TRUE..this causes errors in this code.
	If $bPreserveAR == Default Then $bPreserveAR = True
	If $bStretch == Default Then $bStretch = False
	If $bUseExtensions == Default Then $bUseExtensions = False

;~ 	check input image exists
	If Not FileExists($sInImage) Then Return SetError(1, 0, 0)

;~ extract image name and extension
	$Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))
	$sOF = StringMid($sOutImage, StringInStr($sOutImage, "\", 0, -1) + 1)

;~ check file extension
	If $bUseExtensions Then
		If _ArrayBinarySearch($aImageExtensions, StringLower($Ext)) = -1 Then Return SetError(2, 0, 0)
	EndIf

;~ start GDI plus to get aspect ratio
	_GDIPlus_Startup()
	$hImage2 = _GDIPlus_ImageLoadFromFile($sInImage)

;~ find current aspect ratio (using width / height)
	$iActW = _GDIPlus_ImageGetWidth($hImage2)
	$iActH = _GDIPlus_ImageGetHeight($hImage2)
	$vAspectR = $iActW / $iActH

;~ populate values if defaults used. Use "<0" to capture incorrect size entries.
	If $iH < 0 And $iW < 0 Then
		$iH = $iActH
		$iW = $iActW
	ElseIf $iH < 0 Then
		$iH = $iW / $vAspectR
	ElseIf $iW < 0 Then
		$iW = $iH * $vAspectR
	EndIf

;~ process all options and combinations (36 in total)
	If $bPreserveAR = True And (($iActW >= $iW Or $iActH >= $iH) Or ($iActW <= $iW And $iActH <= $iH And $bStretch = True)) Then
;~ captures the following cases (17)
;~ 		$iActW > $iW, $iActH > $iH, $bPreserveAR = True, $bStretch = True	; reduce to largest image that will fit in H and W with Aspect Ratio (see remarks)
;~ 		$iActW > $iW, $iActH > $iH, $bPreserveAR = True, $bStretch = False	; reduce to largest image that will fit in H and W with Aspect Ratio (see remarks)
;~ 		$iActW = $iW, $iActH > $iH, $bPreserveAR = True, $bStretch = True	; reduce to largest image that will fit in H and W with Aspect Ratio (see remarks)
;~ 		$iActW = $iW, $iActH > $iH, $bPreserveAR = True, $bStretch = False	; reduce to largest image that will fit in H and W with Aspect Ratio (see remarks)
;~ 		$iActW > $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = True	; reduce to largest image that will fit in H and W with Aspect Ratio (see remarks)
;~ 		$iActW > $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = False	; reduce to largest image that will fit in H and W with Aspect Ratio (see remarks)
;~ 		$iActW > $iW, $iActH < $iH, $bPreserveAR = True, $bStretch = True	; reduce W to max, calc H with Aspect Ratio
;~ 		$iActW > $iW, $iActH < $iH, $bPreserveAR = True, $bStretch = False	; reduce W to max, calc H with Aspect Ratio
;~ 		$iActW < $iW, $iActH > $iH, $bPreserveAR = True, $bStretch = True	; reduce H to max, calc W with Aspect Ratio
;~ 		$iActW < $iW, $iActH > $iH, $bPreserveAR = True, $bStretch = False	; reduce H to max, calc W with Aspect Ratio
;~ 		$iActW = $iW, $iActH < $iH, $bPreserveAR = True, $bStretch = True	; no resize due to Aspect Ratio constraint, $iW = $iActW and $iH = $iActH
;~ 		$iActW = $iW, $iActH < $iH, $bPreserveAR = True, $bStretch = False	; no resize due to Aspect Ratio constraint, $iW = $iActW and $iH = $iActH
;~ 		$iActW < $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = True	; no resize due to Aspect Ratio constraint, $iW = $iActW and $iH = $iActH
;~ 		$iActW < $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = False	; no resize due to Aspect Ratio constraint, $iW = $iActW and $iH = $iActH
;~ 		$iActW = $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = True	; don't need to capture this here but it does anyway, no resize required
;~ 		$iActW = $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = False	; don't need to capture this here but it does anyway, no resize required
;~ 		$iActW < $iW, $iActH < $iH, $bPreserveAR = True, $bStretch = True	; increase to largest image that will fit in H and W with Aspect Ratio (see remarks)

		If $iH * $vAspectR <= $iW Then
			$iW = $iH * $vAspectR
		Else
			$iH = $iW / $vAspectR
		EndIf

	ElseIf $bPreserveAR = False And (($bStretch = True And ($iActW <= $iW Or $iActH <= $iH)) Or ($iActW >= $iW And $iActH >= $iH)) Then
;~ for all cases below since aspect ratio is false the image will be resized to requested amount and potentially deformed
;~ no action required $iW = $iW and $iH = $iH
;~ captures the following cases (13)
;~ 		$iActW < $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW > $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW > $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW > $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW < $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW = $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW < $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW = $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW = $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW = $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW = $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW > $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = True
;~ 		$iActW > $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = False

	ElseIf $bStretch = False And ($iActW <= $iW And $iActH <= $iH) Then
;~ all cases below no resize is available because stretch is false and the original has all dimensions smaller than or equal to the request.
;~ captures the following cases (4)
;~ 		$iActW < $iW, $iActH < $iH, $bPreserveAR = True, $bStretch = False
;~ 		$iActW < $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW < $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW = $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = False
		
;~ these cases are captured earlier but also make the above true
;~ 		$iActW = $iW, $iActH < $iH, $bPreserveAR = True, $bStretch = False
;~ 		$iActW < $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = False
;~ 		$iActW = $iW, $iActH = $iH, $bPreserveAR = True, $bStretch = False
		
		$iH = $iActH
		$iW = $iActW
	ElseIf $bStretch = False And $bPreserveAR = False Then
;~ captures the following cases (2)
;~ 		$iActW < $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = False	; resize to requested H and original W
;~ 		$iActW > $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = False ; resize to requested W and original H

;~ these cases are captured earlier but also make the above true
;~ 		$iActW < $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW < $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW = $iW, $iActH < $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW > $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW = $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW = $iW, $iActH > $iH, $bPreserveAR = False, $bStretch = False
;~ 		$iActW > $iW, $iActH = $iH, $bPreserveAR = False, $bStretch = False

		If $iActW < $iW Then
			$iW = $iActW
		ElseIf $iActH < $iH Then
			$iH = $iActH
		EndIf
	EndIf
	
	If Not ($iW = $iActW And $iH = $iActH) Then
		; resize picture
		$hWnd = _WinAPI_GetDesktopWindow()
		$hDC = _WinAPI_GetDC($hWnd)
		$hBMP = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
		_WinAPI_ReleaseDC($hWnd, $hDC)
		$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)
		$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)
		_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage2, 0, 0, $iW, $iH)
		$CLSID = _GDIPlus_EncodersGetCLSID($Ext)
		_GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID)
		_GDIPlus_ImageDispose($hImage1)
		_GDIPlus_ImageDispose($hImage2)
		_GDIPlus_GraphicsDispose($hGraphic)
		_WinAPI_DeleteObject($hBMP)
		_GDIPlus_Shutdown()
		Return SetError(0, 0, 1)
	EndIf
	_GDIPlus_Shutdown()
	Return SetError(3, 0, 0)
EndFunc   ;==>_ImageResize