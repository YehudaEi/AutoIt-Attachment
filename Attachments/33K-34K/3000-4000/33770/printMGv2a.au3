
;	UDF for printing using PrintMG.dll

#include-once

Const $fpbold = 1, $fpitalic = 2, $fpunderline = 4, $fpstrikeout = 8;
Const $sUDFVersion = 'PrintMG.au3 V2.68'


;V2    add missing '$fPrinterOpen = false' to _PrintDllClose
;      added style to SetFont
;      added GetTextHeight, GetTextWidth, Line
;V2.1  added _PrintImage
;V2.2  added _printEllipse, _PrintArc, _PrintPie
;V2.3 fix error in _PrintRectangle
;     comment in _PrintPageOrientation added to reflect new behaviour of dll
;       which now ignores orientation if printing started and returns -2
;V2.4 Added _PrintSelectPrinter. Needs printmg.dll V2.42 or later
;V2.45 Added _PrinGetPrinter. Needs printmg.dll V2.45 or later
;V2.6 Added _PrintListPrinters. Needs printmg.dll V2.46
;V2.61 Added _PrintRoundedRectangle to have 2 extra parameters for rounded corners
;V2.62 Added _PrintSetTitle
;V2.63 Add $vPath parameter to _PrintDllStart. Thanks to ChrisL
;V2.64 Add _PrintBytesDirect thanks to DeDeep00
;V2.65 Add PrintImageFromDC thanks to YellowLab
;V2.66 Add _PrintGetPaperHeight, _PrintGetPaperWidth. Needs dll V2.52 or later
;V2.67 Add copies parameter to _PrintStartPrint. Thanks to YellowLab. Needs dll 2.53 or later
;V2.68 add para to _PrintSelectPrinter to decide if the selected printer becomes the default.
;          - needs dll v2.54 or later
#cs
	AutoIt Version: 3.2.3++

	Description:    Functions for printing using PrintMG.dll

	Functions available:
	_PrintVersion
	_PrintDllStart
	_PrintDllClose
	_PrintSetPrinter
	_PrintGetPageWidth
	_PrintGetPageHeight
	_PrintGetHorRes
	_PrintGetVertRes
	_PrintStartPrint
	_PrintSetFont
	_PrintNewPage
	_PrintEndPrint
	_PrintText
	_PrintGettextWidth
	_PrintGetTextHeight
	_PrintLine
	_PrintGetXOffset
	_PrintGetYOffset
	_PrintSetLineCol
	_PrintSetLineWid
	_PrintImage
	_PrintEllipse
	_PrintArc
	_PrintPie
	_PrintRectangle
	_PrintGetPageNumber
	_PrintPageOrientation
	_PrintSelectPrinter
	_PrintGetPrinter
	_printListPrinters
	_PrintBytesDirect
	_PrintImageFromDC
	_PrintSetTitle
	_PrintGetPaperHeight
	_PrintGetPaperWidth
	_PrintAbort
	Author: Martin Gibson
#ce

; #FUNCTION# ===========================================================================
; Name...........: PrintVersion
; Description ...: Returns version of PrintMG.dll
; Syntax.........: _PrintVersion($hDll, $type)
; Parameters ....: The handle to the DLL obtained from _PrintDllStart()
;                  2nd - If = 1, returns the version of printmg.dll
;                        If <> 1, returns the version of this UDF
; Return values .: on success: The version (as a string) and @error set to 0
;                  on failure: empty String and @error set to 1
; ====================================================================================================
Func _PrintVersion($hDll, $type)
	Local $vDllAns

	If $type <> 1 Then Return $sUDFVersion

	$vDllAns = DllCall($hDll, 'str', 'version');
	If @error = 0 Then
		Return $vDllAns[0] ; [0] = function return value
	Else
		SetError(1)
		Return ''
	EndIf
EndFunc   ;==>_PrintVersion

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetPrinter
; Description ...: Returns the default printer name
; Syntax.........: _PrintGetPrinter($hDll)
; Parameters ....: The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success: a string with the printer name that was selected
;                              (and @error is set to 0)
;                              (if no printer, then returns an empty string)
;                  on failure: an empty string
;                              (and @error is set to 1)
; Requirements ..: Needs PrintMG.dll V2.44 or later
; Note ..........: Can be used to check the result of _PrintSelectPrinter()
; ====================================================================================================
Func _PrintGetPrinter($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'str', 'GetPrinterName');
	If @error = 0 Then
		Return $vDllAns[0] ; [0] = function return value
	Else
		SetError(1)
		Return ''
	EndIf
EndFunc   ;==>_PrintGetPrinter

; #FUNCTION# ===========================================================================
; Name...........: _PrintAbort
; Description ...: Cancels the current print page without printing anything
; Syntax.........: _PrintAbort($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: 0 on success
;                 -1 if not already printing
;                 -2 if could not execute the dll call
;                 Also on failure:
;                    @error = 1 unable to use the DLL file,
;                             2 unknown "return type",
;                             3 "function" not found in the DLL file,
;                             4 bad number of parameters.
; ====================================================================================================
Func _PrintAbort($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'AbortPrint');
	If @error = 0 Then
		Return $vDllAns[0] ; [0] = function return value
	Else
		Return -2
	EndIf
EndFunc   ;==>_PrintAbort

; #FUNCTION# ===========================================================================
; Name...........: _PrintBytesDirect
; Description ...: Sends the bytes from array directly to the printer
; Syntax.........: _PrintBytesDirect($hDll, $sPrinter,$aData)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - The name of the printer (see _PrintGetPrinter())
;                  3rd - The array to print of bytes to be sent
;                        (the first byte is $aData[0])
; Return values .: on success: 1 (Return value from the PrintBytesDirect DLL call)
;                  on failure: 0 (Return value from the PrintBytesDirect DLL call)
;                             -1 - $aData is not an array
; Notes .........: To print a raw file to a printer use
;                     copy fullfilepath /b prn   # if not on usb
;                     copy fullfilepath /b //computername/printersharename
;                  If on the local pc then can use 127.0.0.1 instead of computername
;                  get printername from control panel, printers and faxes
; ====================================================================================================
Func _PrintBytesDirect($hDll, $sPrinter, $aData)
	Local $vDllAns, $n, $iNum, $structCodes, $pData, $vDllAns
	If Not IsArray($aData) Then Return -1;error
	Local $n, $iNum = UBound($aData)
	Local $structCodes = DllStructCreate("byte[" & $iNum & "]")
	Local $pData = DllStructGetPtr($structCodes)

	For $n = 1 To $iNum
		DllStructSetData($structCodes, $n, $aData[$n - 1])
	Next

	$vDllAns = DllCall($hDll, 'int', 'PrintBytesDirect', 'str', $sPrinter, 'ptr', $pData, 'int', $iNum)
	Return $vDllAns[0] ; [0] = function return value
EndFunc   ;==>_PrintBytesDirect

; #FUNCTION# ===========================================================================
; Name...........: _PrintDllStart
; Description ...: Opens the PrintMG.dll DLL
; Syntax.........: _PrintDllStart(ByRef $sErr, $vPath = 'printmg.dll')
; Parameters ....: 1st - Caller's error string (modified by this function if
;                        an error was detected; otherwise not modified at all)
;                  2nd - DLL name (Optional - The default is "PrintMG.dll")
;                        The DLL must be in the csript folder or one of the
;                        folders searched by Windows
; Return values .: on success: Returns a dll "handle" to be used with
;                              subsequent Dll functions
;                              (and @error is set to 0)
;                  on failure: -1 - Caller's error string contains an error message
;                                   (and @error is set to 1)
; ====================================================================================================
Func _PrintDllStart(ByRef $sErr, $vPath = 'printmg.dll')
	Local $hDll

	$hDll = DllOpen($vPath)
	If $hDll = -1 Then
		SetError(1)
		$sErr = 'Failed to open ' & $vPath
		Return -1 ; FAILED
	EndIf

	Return $hDll ; OK
EndFunc   ;==>_PrintDllStart


; #FUNCTION# ===========================================================================
; Name...........: _PrintDllClose
; Description ...: Closes the dll
; Syntax.........:  _PrintDllClose($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success:  0 (and @error is set to 0)
;                  on failure: -1 if $hDll is invalid
;                              -2 if could not execute _PrintDllClose
; Note ..........: Script will terminate if it fails to close printmg.dll
; ====================================================================================================
Func _PrintDllClose($hDll)
	If $hDll = -1 Then Return -1

	DllCall($hDll, 'int', 'ClosePrinter');
	If @error <> 0 Then Return -2
	DllClose($hDll)
	Return 0
EndFunc   ;==>_PrintDllClose

; #FUNCTION# ===========================================================================
; Name...........: _PrintSetPrinter
; Description ...: Brings up a dialog box for choosing the printer
; Syntax.........: _PrintSetPrinter($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success: 1 (Return value from the PrintBytesDirect DLL call)
;                  on failure: 0 (Return value from the PrintBytesDirect DLL call)
; ====================================================================================================
Func _PrintSetPrinter($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'SetPrinter')
	If @error = 0 Then
		Return $vDllAns[0] ; [0] = function return value
	Else
		Return -1
	EndIf
EndFunc   ;==>_PrintSetPrinter

; #FUNCTION# ===========================================================================
; Name...........: _PrintSelectPrinter
; Description ...: Selects the printer to use
; Syntax.........: _PrintSelectPrinter($hDll, $PrinterName, $fSetAsDefault=false)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - name as in WIndows printer list
; Return values .: 1 = OK
;                 -1 = FAIL
; Requirements ..: Needs PrintMG.dll V2.42 or later
; Notes .........: Selction does not alter the default printer but selects
;                  $PrinterName for the current print job.
;                  _PrintGetPrinter will return the selected printer and can
;                  be used to check the result of _PrintSelectPrinter
; ====================================================================================================
Func _PrintSelectPrinter($hDll, $PrinterName, $fSetAsDefault = False)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'SelectPrinter', 'str', $PrinterName, 'int', $fSetAsDefault)
	If @error = 0 Then
		Return $vDllAns[0]
	Else
		Return -1
	EndIf
EndFunc   ;==>_PrintSelectPrinter

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetHorRes
; Description ...: Returns the number of pixels across the printer page
; Syntax.........: _PrintGetHorRes($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: The #of pixels across the page
;                  (and @error = 0)
;                 -1 (and @error = 1)
; =======================================================================================
Func _PrintGetHorRes($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'GetHorRes')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetHorRes


; #FUNCTION# ===========================================================================
; Name...........: _PrintGetVertRes
; Description ...: Returns the number of pixels down the printer page
; Syntax.........: _PrintGetVertRes($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: The #of pixels down the page
;                  (and @error = 0)
;                 -1 (and @error = 1)
; ====================================================================================================
Func _PrintGetVertRes($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'GetVertRes')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1

EndFunc   ;==>_PrintGetVertRes

; #FUNCTION# ===========================================================================
; Name...........: _PrintSetBrushCol
; Description ...: Set the bruse color
; Syntax.........: _PrintSetBrushCol($hDll, $bcol)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - The color to set the brush to (this is the the color used for
;                        filling enclosed shapes
; Return values .: 1 on success and @error = 0
;                 -1 on failure And @error = 1
; ====================================================================================================
Func _PrintSetBrushCol($hDll, $bcol)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'SetBrushCol', 'int', $bcol)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintSetBrushCol

; #FUNCTION# ===========================================================================
; Name...........: _PrintEllipse
; Description ...: Prints an enclosed (ie full) ellipse in the current line colour and
;                  width, filled with the current brush colour.
; Syntax.........: _PrintEllipse($hDll, $iTopx, $iTopy, $iBotX, $iBotY)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Upper left corner X-position
;                  3rd - Upper left corner Y-position
;                  4th - Lower right corner X-position
;                  5th - Lower right corner Y-position
; Return values .: 1 on success and @error = 0
;                 -1 on failure And @error = 1
; Notes .........: The ellipse is drawn within the rectangle described by the upper
;                  left and lower right points. If the rectangle is a square then the
;                  ellipse is a circle
; ====================================================================================================
Func _PrintEllipse($hDll, $iTopx, $iTopy, $iBotX, $iBotY)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'Ellipse', 'int', $iTopx, 'int', $iTopy, 'int', $iBotX, 'int', $iBotY)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintEllipse

; #FUNCTION# ===========================================================================
; Name...........: _PrintRectangle
; Description ...: Prints an enclosed (ie full) rectangle in the current line colour and
;                  width, filled with the current brush colour.
; Syntax.........: _PrintRectangle($hDll, $iTopx, $iTopy, $iBotX, $iBotY)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Upper left corner X-position
;                  3rd - Upper left corner Y-position
;                  4th - Lower right corner X-position
;                  5th - Lower right corner Y-position
; Return values .: 1 on success and @error = 0
;                 -1 on failure And @error = 1
; Notes .........: The ellipse is drawn within the rectangle described by the upper
;                  left and lower right points. If the rectangle is a square then the
;                  ellipse is a circle
; ====================================================================================================
Func _PrintRectangle($hDll, $iTopx, $iTopy, $iBotX, $iBotY)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'Rectangle', 'int', $iTopx, 'int', $iTopy, 'int', $iBotX, 'int', $iBotY)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintRectangle

; #FUNCTION# ===========================================================================
; Name...........: _PrintRoundedRectangle
; Description ...: Prints an enclosed (ie full) rectangle in the current line colour and
;                  width, filled with the current brush colour and with the corners
;                  rounded.
; Syntax.........: _PrintRoundedRectangle($hDll, $iTopx, $iTopy, $iBotX, $iBotY, _
;                                         $iCornerx = 0, $iCornery = 0)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Upper left corner X-position
;                  3rd - Upper left corner Y-position
;                  4th - Lower right corner X-position
;                  5th - Lower right corner Y-position
;                  6th - Width of the corner elipse
;                  7th - Height of the corner elipse
; Return values .: 1 on success and @error = 0
;                 -1 on failure And @error = 1
; Notes .........: If $Icornerx and $iCornery are both greater than zero the corners will
;                  be elliptical curves with height $iCornery and width $iCornerx.
;                  (This means the full ellipse would have height $iCornery * 2, and
;                   width $iCornerx * 2)
;                  If both $iCornerx and $iCornery are zero then this function is equivalent
;                  to _PrintRectangle().
; ====================================================================================================
Func _PrintRoundedRectangle($hDll, $iTopx, $iTopy, $iBotX, $iBotY, $iCornerx = 0, $iCornery = 0)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'RoundedRectangle', 'int', $iTopx, 'int', $iTopy, 'int', $iBotX, 'int', $iBotY, 'int', $iCornerx, 'int', $iCornery)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintRoundedRectangle

; #FUNCTION# ===========================================================================
; Name...........: _PrintPie
; Description ...: Prints an enclosed ie elliptical segment in the current line colour
;                  and width, filled with the current brush colour
; Syntax.........: _PrintPie($hDll, $iTopx, $iTopy, $iBotX, $iBotY, $iAx, $iAy, $iBx, $iBy)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Upper left corner X-position
;                  3rd - Upper left corner Y-position
;                  4th - Lower right corner X-position
;                  5th - Lower right corner Y-position
;                  6th - Y-position for the start point of the curve
;                  7th - X-position for the start point of the curve
;                  8th - Y-position for the end point of the curve
;                  9th - X-position for the end point of the curve
; Return values .: 1 on success and @error = 0
;                 -1 on failure And @error = 1
; Notes .........: The elliptical curve is drawn on the rectangle $iTopx,$iTopy at the
;                  top left, $iBotx,$iBoty at the bottom right
;                  If the rectangle is a square then the ellipse is a circle.
;                  The start of the ellipse is at the point where the line from the center
;                  of the rectangle through the point $iAx,$iAy intersects the ellipse.
;                  The ellipse is drawn clockwise untill the point is reached where the line
;                  from the centre of the rectangle through the point $iAx,$iAy intersects
;                  the ellipse.
;                  If the end point is also the start point then a full ellipse is drawn.
;                  If the rectangle is a square then the ellipse is a circle
; ====================================================================================================
Func _PrintPie($hDll, $iTopx, $iTopy, $iBotX, $iBotY, $iAx, $iAy, $iBx, $iBy)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'Pie', 'int', $iTopx, 'int', $iTopy, 'int', $iBotX, 'int', $iBotY, 'int', $iAx, 'int', $iAy, 'int', $iBx, 'int', $iBy)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintPie

; #FUNCTION# ===========================================================================
; Name...........: _PrintArc
; Description ...: Prints an enclosed (elliptical) arc in the current line colour and width.
; Syntax.........: _PrintArc($hDll, $iTopx, $iTopy, $iBotX, $iBotY, $iAx, $iAy, $iBx, $iBy)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Upper left corner X-position
;                  3rd - Upper left corner Y-position
;                  4th - Lower right corner X-position
;                  5th - Lower right corner Y-position
;                  6th - Y-position for the start point of the curve
;                  7th - X-position for the start point of the curve
;                  8th - Y-position for the end point of the curve
;                  9th - X-position for the end point of the curve
; Return values .: 1 on success and @error = 0
;                 -1 on failure And @error = 1
; Notes .........: The ellipse is drawn on the rectangle $iTopx,$iTopy at the top left,
;                  and $iBotx,$iBoty at the bottom right
;                  If the rectangle is a square then the ellipse is a circle
;                  The start of the ellipse is at the point where the line from the center
;                  of the rectangle through the point $iAx,$iAy intersects the ellipse.
;                  The ellipse is drawn clockwise untill the point is reached where the line
;                  from the center of the rectangle through the point $iAx,$iAy intersects
;                  the ellipse.
;                  If the end point is also the start point then a full ellipse is drawn.
;                  If the rectangle is a square then the ellipse is a circle
; ====================================================================================================
Func _PrintArc($hDll, $iTopx, $iTopy, $iBotX, $iBotY, $iAx, $iAy, $iBx, $iBy)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'Arc', 'int', $iTopx, 'int', $iTopy, 'int', $iBotX, 'int', $iBotY, 'int', $iAx, 'int', $iAy, 'int', $iBx, 'int', $iBy)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintArc

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetPageHeight
; Description ...: Returns page height in tenths of a millimeter
; Syntax.........: _PrintGetPageHeight($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success: The page height in tenths of a millimeter
;                              (and @error = 0)
;                  on failure: -1
;                              (and @error = 1)
; Related: ......: _PrintGetPaperHeight()
; Note ..........: The PAGE height is the printable height which will not be
;                  greater than the PAPER height.
; ====================================================================================================
Func _PrintGetPageHeight($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'GetPageHeight')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetPageHeight

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetPaperHeight
; Description ...: Returns physical paper height in tenths of a millimeter
; Syntax.........: _PrintGetPageHeight($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success: The Paper height in tenths of a millimeter
;                              (and @error = 0)
;                  on failure: -1
;                              (and @error = 1)
; Related: ......: _PrintGetPageHeight()
; Note ..........: The PAGE height is the printable height which will not be
;                  greater than the PAPER height.
; ====================================================================================================
Func _PrintGetPaperHeight($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'GetPaperHeight')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetPaperHeight

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetPageWidth
; Description ...: Returns page width in tenths of a millimeter
; Syntax.........: _PrintGetPageWidth($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success: The page width in tenths of a millimeter
;                              (and @error = 0)
;                  on failure: -1
;                              (and @error = 1)
; Note ..........: The PAGE width is the printable width
; ====================================================================================================
Func _PrintGetPageWidth($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'GetPageWidth')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetPageWidth

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetPaperWidth
; Description ...: Returns physical paper width in tenths of a millimeter
; Syntax.........: _PrintGetPaperWidth($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success: The physical paper width in tenths of a millimeter
;                              (and @error = 0)
;                  on failure: -1
;                              (and @error = 1)
; Note ..........: The PAGE width is the printable width which will not be
;                  more than the PAPER width
; ====================================================================================================
Func _PrintGetPaperWidth($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'GetPaperWidth')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetPaperWidth

; #FUNCTION# ===========================================================================
; Name...........: _PrintStartPrint
; Description ...: Initializes the printer ready to print.
; Syntax.........: _PrintStartPrint($hDll, $printCopies = 1)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - The Number of copies (default is 1)
; Return values .: 1 on success
;                  (and sets @error = 0)
;                 -1 if failed to start printer
;                  (and sets @error to 1)
;                 -2 if number of copies is set to less than 1
;                  (and sets @error = 2)
; Note: .........: Must be called before any printing functions
; ====================================================================================================
Func _PrintStartPrint($hDll, $printCopies = 1)
	Local $vDllAns

	If $printCopies < 1 Then Return SetError(-2, 0, -2)
	$vDllAns = DllCall($hDll, 'int', 'PrinterBegin', 'int', $printCopies)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintStartPrint

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetPageNumber
; Description ...: Returns the current page number
; Syntax.........: _PrintGetPageNumber($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: The page number if printing in progress ie the page being
;                  created which is not the page actually being printed.
;                  (and @error = 0)
;                  0 if not printing
;                  -1 for a failure
;                  (and @error = 1)
; ====================================================================================================
Func _PrintGetPageNumber($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'GetPageNumber')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1

EndFunc   ;==>_PrintGetPageNumber

; #FUNCTION# ===========================================================================
; Name...........: _PrintEndPrint
; Description ...: Ends the printing operations
; Syntax.........: _PrintEndPrint($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd -
;                  3rd -
; Return values .: on success: 1 (and @error = 0)
;                  on failure: -1 (and @error = 1)
; ====================================================================================================
Func _PrintEndPrint($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'PrinterEnd')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintEndPrint

; #FUNCTION# ===========================================================================
; Name...........: _PrintNewPage
; Description ...: Ends the last page; any further printing will be done on the next page
; Syntax.........: _PrintNewPage($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd -
;                  3rd -
; Return values .: on success: 1 (and @error = 0)
;                  on failure: -1 (and @error = 1)
; Note ..........: If you use this function there will be another page printed even
;                  if it is blank!
; ====================================================================================================
Func _PrintNewPage($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'NewPage')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintNewPage

; #FUNCTION# ===========================================================================
; Name...........: _PrintSetFont
; Description ...: Set the printer font for the next print operations
; Syntax.........: _PrintSetFont($hDll, $FontName, $FontSize, $FontCol = 0, $Fontstyle = '')
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - The font name (e.g "Times New Roman")
;                  3rd - The font size
;                  4th = The font color (default = 0 (black).
;                        -1 is taken as the default color.
;                  5th = The font style (default is "" which means regular)
;                        A string which contains any of 'bold', 'underline', 'italic',
;                        'strikeout'. In any Order and case independant
; Return values .: The return value from the call to SetFont in the DLL
; Note ..........: A value for $FontCol must be given if $FontStyle is used.
; ====================================================================================================
Func _PrintSetFont($hDll, $FontName, $FontSize, $FontCol = 0, $Fontstyle = '')
	Local $iStyle = 0, $vDllAns

	If $FontCol = -1 Then $FontCol = 0
	If $Fontstyle = -1 Then $Fontstyle = ''
	If $Fontstyle <> '' Then
		If StringInStr($Fontstyle, "bold", 0) Then $iStyle = 1
		If StringInStr($Fontstyle, "italic", 0) Then $iStyle += 2
		If StringInStr($Fontstyle, "underline", 0) Then $iStyle += 4
		If StringInStr($Fontstyle, "strikeout", 0) Then $iStyle += 8
	EndIf

	$vDllAns = DllCall($hDll, 'int', 'SetFont', 'str', $FontName, 'int', $FontSize, 'int', $FontCol, 'int', $iStyle)
	Return $vDllAns[0]
EndFunc   ;==>_PrintSetFont

; #FUNCTION# ===========================================================================
; Name...........: _PrintImage
; Description ...: Print an image on the print page
; Syntax.........: _PrintImage($hDll, $sImagePath, $TopX, $TopY, $wid, $ht)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Full path to prints bmp, jpg or ico file to print
;                  3rd - Upper left X-position of the rectagular area to print in
;                  4th - Upper left Y-position of the rectagular area to print in
;                  5th - Width of the rectagular area to print in
;                  6th - Height of the rectagular area to print in
; Return values .: on success: 1  (and @error is set to 0)
;                  on failure: @error is set to 1 and the value returned is:
;                              -1 if error calling dll
;                              -2 If file not found
;                              -3 if file is not jpg or bmp
;                              -4 if unsupported icon file
; Note: .........: The file type is determined purely by file extension ie .bmp
;                  or .jpg or .ico
; ====================================================================================================
Func _PrintImage($hDll, $sImagePath, $TopX, $TopY, $wid, $ht)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'Image', 'str', $sImagePath, 'int', $TopX, 'int', $TopY, 'int', $wid, 'Int', $ht)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1

EndFunc   ;==>_PrintImage

; #FUNCTION# ===========================================================================
; Name...........: _PrintImageFromDC
; Description ...:
; Syntax.........: _PrintImageFromDC($hDll, $hDC, $TopX, $TopY, $wid, $ht, $printTopX, $printTopY, $printWidth, $printHeight)
; Parameters ....: 1st - A handle to a bitmap
;                  2nd - The handle to the DLL obtained from _PrintDllStart()
;                  3rd - X-position of the top left corner of the bitmap to copy from
;                  4th - Y-position of the top left corner of the bitmap to copy from
;                  5th - The width of the rectangle to copy from the bitmap
;                  6th - The height of the rectangle to copy from the bitmap
;                  7th - X-position of the topleft corner on the page for the picture in units of 0.1mm
;                  8th - Y-position of the topleft corner on the page for the picture in units of 0.1mm
;                  9th - The width of the image on the paper in units of 0.1mm
;                 10th - The height of the image on the paper in units of 0.1mm
; Return values .: on success: 1 (and @error is set to 0)
;                  on failure: @error is set to 1 and the value returned will be -1 if
;                              there was an error calling the function in the DLL.
; ====================================================================================================
Func _PrintImageFromDC($hDll, $hDC, $TopX, $TopY, $wid, $ht, $printTopX, $printTopY, $printWidth, $printHeight)
	;_PrintImageFomDC($hDll, $hDC, $TopX, $TopY,$Width, $Height,$PrintTopX,$PrintTopY,$PrintWidth,$PrintHeight)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'ImageFromHandle', 'hwnd', $hDC, 'int', $TopX, 'int', $TopY, 'int', $wid, 'Int', $ht, 'Int', $printTopX, 'Int', $printTopY, 'Int', $printWidth, 'Int', $printHeight)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintImageFromDC

; #FUNCTION# ===========================================================================
; Name...........: _PrintPageOrientation
; Description ...: Set the printer to portrait or landscape
; Syntax.........: _PrintPageOrientation($hDll, $iPortrait = 1)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - 0 = Portrait mode
;                        1 = Landscape mode (the default mode)
; Return values .: on success:  1 (@error = 0)
;                  on failure: -1 if orientation cannot be changed (@error = 1)
; ====================================================================================================
Func _PrintPageOrientation($hDll, $iPortrait = 1)
	Local $vDllAns

	ConsoleWrite("+++: $hDll = 0x" & Hex($hDll) & @CRLF)
	$vDllAns = DllCall($hDll, 'int', 'Portrait', 'int', $iPortrait)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
	ConsoleWrite("ppoend" & @CRLF)
EndFunc   ;==>_PrintPageOrientation

; #FUNCTION# ===========================================================================
; Name...........: _PrintText
; Description ...: Prints text at a specified location and angle using the last set
;                  font, size,style and color.
; Syntax.........: _PrintText($hDll, $sText, $ix = -1, $iy = -1, $iAngle = 0)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - The text string to be printed
;                  3rd - X-Position to start the printing at
;                  4th = Y-position to start the printing at
;                  5th - The angle (in degrees) to print the text
;                        0 = (default) - normal left to right
;                       90 = vertically up,
;                      270 = vertically down
; Return values .:
; Notes .........: 180 degrees bug which is overcome by changing 180 to 179 until a
;                  solution is found.
;                  To check that the text will fit a space use _PrintGEtTextHeight
;                  and _PrintGetTextWidth
; ====================================================================================================
Func _PrintText($hDll, $sText, $ix = -1, $iy = -1, $iAngle = 0)
	Local $vDllAns

	If $iAngle = 180 Then
		$iAngle = 179; 180 doesn't work so maybe this won't get noticed
	EndIf

	$vDllAns = DllCall($hDll, 'int', 'printText', 'str', $sText, 'int', $ix, 'int', $iy, 'int', $iAngle)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1

EndFunc   ;==>_PrintText

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetXOffset
; Description ...: Returns the width of a margin at the side of the page in
;				   tenths of millimeter which will cannot be printed on.
; Syntax.........: Func _PrintGetXOffset($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: The X-offset in tenths of millimeter
; Note: .........: The X-offset can be 0 for some printers.
; ====================================================================================================
Func _PrintGetXOffset($hDll)
	Local $vDllAns = DllCall($hDll, 'int', 'GetXOffset')

	If @error = 0 Then
		Return $vDllAns[0];tenths of mm
	EndIf
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetXOffset

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetYOffset
; Description ...: Returns the height of a margin at the top of the page in
;				   tenths of millimeter which will cannot be printed on.
; Syntax.........: Func _PrintGetYOffset($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: The Y-offset in tenths of millimeter
; Note: .........: The Y-offset can be 0 for some printers.
; ====================================================================================================
Func _PrintGetYOffset($hDll)
	Local $vDllAns = DllCall($hDll, 'int', 'GetYOffset')

	If @error = 0 Then Return $vDllAns[0];tenths of mm
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetYOffset

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetTextWidth
; Description ...: Returns the width in tenths of millimeter taken by the text if
;                  printed using the current font settings.
; Syntax.........: _PrintGetTextWidth($hDll, $sWText)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Sample text
; Return values .: on success: The width of te sample text (in tenths of a millimeter) if
;                              it was printed. ($error = 0)
;                  on failure: -1 (@error = 1)
; ====================================================================================================
Func _PrintGetTextWidth($hDll, $sWText)
	Local $vDllAns = DllCall($hDll, 'int', 'TextWidth', 'str', $sWText)

	If @error = 0 Then Return $vDllAns[0] ; tenths of mm
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetTextWidth

; #FUNCTION# ===========================================================================
; Name...........: _PrintGetTextHeight
; Description ...: Returns the height in tenths of millimeter taken by the text if
;                  printed using the current font settings.
; Syntax.........: _PrintGetTextHeight($hDll, $sWText)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - Sample text
; Return values .: on success: The height of the sample text (in tenths of a millimeter) if
;                              it was printed. ($error = 0)
;                  on failure: -1 (@error = 1)
; Note ..........: Actually, the height is only determined by the font settings not by
;                 the text in $sHText
; ====================================================================================================
Func _PrintGetTextHeight($hDll, $sHText)
	Local $vDllAns = DllCall($hDll, 'int', 'TextHeight', 'str', $sHText)

	If @error = 0 Then Return $vDllAns[0];tenths of mm
	SetError(1)
	Return -1
EndFunc   ;==>_PrintGetTextHeight

; #FUNCTION# ===========================================================================
; Name...........: _PrintSetLineWid
; Description ...: _PrintSetLineWid($hDll, $iWid)
; Syntax.........: Sets the line width for all future line draws on the printer.
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - The width (in tenths of a millimeter)
; Return values .: on success: The return value from the call to SetLineWid in the DLL
;                              ($error = 0)
;                  on failure: -1 (@error = 1)
; Note ..........:
; ====================================================================================================
Func _PrintSetLineWid($hDll, $iWid)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'SetLineWid', 'int', $iWid)
	If @error = 0 Then Return $vDllAns[0] ; tenths of mm
	SetError(1)
	Return -1
EndFunc   ;==>_PrintSetLineWid

; #FUNCTION# ===========================================================================
; Name...........: _PrintSetLineCol
; Description ...: Sets th color for all future line draws on the printer.
; Syntax.........: _PrintSetLineCol($hDll, $iCol)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - The color to set
; Return values .: on success: 1 (@error = 0)
;                  on failure: 0 (@error = 1)
; ====================================================================================================
Func _PrintSetLineCol($hDll, $iCol)
	Local $vDllAns = DllCall($hDll, 'int', 'SetLineCol', 'int', $iCol)

	;ConsoleWrite("set line col to " & $iCol & @CRLF)
	If @error = 0 Then Return $vDllAns[0];
	SetError(1)
	Return -1

EndFunc   ;==>_PrintSetLineCol

; #FUNCTION# ===========================================================================
; Name...........: _PrintLine
; Description ...: Prints a line on the printer.
; Syntax.........: _PrintLine($hDll, $iXStart, $iYStart, $iXEnd, $iYEnd);start x,y, end x,y in tenths of mm
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - X-position to start the line at
;                  3rd - Y-position to start the line at
;                  4th - X-position to end the line at
;                  5th - Y-position to end the line at
; Return values .: on success: Returns the return value from the call to "Line" in the DLL
;                              (@error = 0)
;                  on failure: -1 ($error = 1)
; Note ..........: All x,y values are expressed in tenths of a millimeter.
; ====================================================================================================
Func _PrintLine($hDll, $iXStart, $iYStart, $iXEnd, $iYEnd);start x,y, end x,y in tenths of mm
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'Line', 'int', $iXStart, 'int', $iYStart, 'int', $iXEnd, 'int', $iYEnd)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1


EndFunc   ;==>_PrintLine

; #FUNCTION# ===========================================================================
; Name...........: _PrintListPrinters
; Description ...: Returns a "|" separated list of installed printers
; Syntax.........: _PrintListPrinters($hDll)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
; Return values .: on success: A "|" separated list of installed printers
;                              (@error = 0)
;                  on failure: An empty string
;	                           (@error = 1)
; ====================================================================================================
Func _PrintListPrinters($hDll)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'str', 'ListPrinters')
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return ''

EndFunc   ;==>_PrintListPrinters

; #FUNCTION# ===========================================================================
; Name...........: _PrintSetDocTitle
; Description ...: Sets the document title.
; Syntax.........: _PrintSetDocTitle($hDll, $sTitle)
; Parameters ....: 1st - The handle to the DLL obtained from _PrintDllStart()
;                  2nd - String containing the title to use.
;                  3rd -
; Return values .:
; Note ..........: Must be used before _PrintStartPrint or after _PrintEndPrint
;                  Requires PrintMG.dll v
; ====================================================================================================
Func _PrintSetDocTitle($hDll, $sTitle)
	Local $vDllAns

	$vDllAns = DllCall($hDll, 'int', 'SetTitle', 'str', $sTitle)
	If @error = 0 Then Return $vDllAns[0]
	SetError(1)
	Return -1
EndFunc   ;==>_PrintSetDocTitle

;