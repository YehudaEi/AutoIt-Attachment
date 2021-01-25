#include-once
#include <Excel.au3>
#region Header
#cs
	Title:			Microsoft Excel COM UDF library for AutoIt v3
	Author(s):		SEO aka Locodarwin, DaLiMan, Stanley Lim, MikeOsdx, MRDev, big_daddy, PsaltyDS
	Date Began:		06-12-06
 	Current Ver:	1.4
	Last Update:	01-04-08
	
	Additional credits: Some code indirectly lifted from or inspired by randallc's ExcelCOM.au3
						Some code also indirectly lifted from or inspired by Dale Hohm's IE.au3 (with permission)
#ce
#endregion

#region List of Functions
#cs


#ce
#endregion


#region Functions

;===============================================================================
;
; Function Name:    _ExcelAttach()
; Description:    Attach to the first existing instance of Microsoft Excel where the
;               search string matches based on the selected mode.
; Parameter(s):     $s_string   - String to search for
;               $s_mode        - Optional: specifies search mode
;                           FileName   = Name of the open workbook
;                           FilePath   = (Default) Full path to the open workbook
;                           Title    = Title of the Excel window
; Requirement(s):   AutoIt3 with COM support (post 3.1.1)
;               On Success - Returns an object variable pointing to the Excel.Application object
;                   On Failure  - Returns 0 and sets @ERROR = 1
; Author(s):        Bob Anthony (big_daddy)
;
;===============================================================================
;
Func _ExcelAttach($s_string, $s_mode = "FilePath")
    $s_mode = StringLower($s_mode)

    Local $o_Result, $o_workbook, $o_workbooks

    $o_Result = ObjGet("", "Excel.Application")
    If @error Or Not IsObj($o_Result) Then
        ConsoleWrite("Unable to attach to existing Excel.Application object." & @CR)
        Return SetError(1, 0, 0)
    EndIf

    $o_workbooks = $o_Result.Application.Workbooks
    If Not IsObj($o_workbooks) Or $o_workbooks.Count = 0 Then
        ConsoleWrite("There were no open excel windows." & @CR)
        Return SetError(1, 0, 0)
    EndIf

;~  ConsoleWrite($o_workbooks.count & @CR)
    For $o_workbook In $o_workbooks

        Switch $s_mode
            Case "filename"
;~     ConsoleWrite($o_workbook.Name & @CR)
                If $o_workbook.Name = $s_string Then
                    $o_workbook.Activate
                    Return $o_workbook.Application
                EndIf
            Case "filepath"
;~     ConsoleWrite($o_workbook.FullName & @CR)
                If $o_workbook.FullName = $s_string Then
                    $o_workbook.Activate
                    Return $o_workbook.Application
                EndIf
            Case "title"
;~     ConsoleWrite($o_workbook.Application.Caption & @CR)
                If ($o_workbook.Application.Caption) = $s_string Then
                    $o_workbook.Activate
                    Return $o_workbook.Application
                EndIf
            Case Else
                ; Invalid Mode
                ConsoleWrite("You have specified an invalid mode." & @CR)
                Return SetError(1, 0, 0)
        EndSwitch
    Next
    Return SetError(1, 0, 0)
EndFunc   ;==>_ExcelAttach

;===============================================================================
;
; Description:      Opens an existing text file, parses it into Excel, and returns its object identifier.
; Syntax:           $oExcel = _ExcelBookOpenTxt($sFilePath, $sDelimiter = "comma", $iStartRow = 1, $iDataType = 0, _
;											$iTextQualifier = 1, $fConsecDelim = False, $fVisible = 1)
; Parameter(s):     $sFilePath - Path and filename of the file to be opened
;					$sDelimiter - The string character to use as delimiter (default=",")
;					$iStartRow - The row within the file to start parsing (default=1)
;					$iDataType - How columns are delimited (1=delimited, 2=fixedwidth) (default=1)
;					$iTextQualifier - How text values are determined (1=double quote, -4142=delimited, 2=single quote) (default=1)
;					$fConsecDelim - Delimiters represent a single column of data (True or False) (default=False)
;					$fVisible - Flag, whether to show or hide the workbook (0=not visible, 1=visible) (default=1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns new object identifier
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Specified file does not exist
;						@error=3 - Delimiter invalid
;						@error=4 - Start row invalid
;						@error=5 - Data type invalid
;						@error=6 - Text qualifier invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================

Func _ExcelBookOpenTxt($sFilePath, $sDelimiter = ",", $iStartRow = 1, $iDataType = 1, $iTextQualifier = 1, $fConsecDelim = False, $fVisible = 1)
	Local $oExcel = ObjCreate("Excel.Application")
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT FileExists($sFilePath) Then Return SetError(2, 0, 0)
	If NOT IsString($sDelimiter) Then Return SetError(3, 0, 0)
	If StringLen($sDelimiter) <> 1 Then Return SetError(3, 0, 0)
	If NOT IsNumber($iStartRow) Or $iStartRow < 1 Then Return SetError(4, 0, 0)
	If NOT IsNumber($iDataType) Or $iDataType < 1 Or $iDataType > 2 Then Return SetError(5, 0, 0)
	If $iTextQualifier = -4142 Then $iTextQualifier = 0
	If $iTextQualifier < 0 Or $iTextQualifier > 2 Then Return SetError(6, 0, 0)
	If $iTextQualifier = 0 Then $iTextQualifier = -4142
	If $fVisible > 1 Then $fVisible = 1
	If $fVisible < 0 Then $fVisible = 0
	With $oExcel
		.Visible = $fVisible
		.WorkBooks.OpenText($sFilePath, Default, $iStartRow, $iDataType, $iTextQualifier, $fConsecDelim, False, _
							False, False, False, True, $sDelimiter)
		.ActiveWorkbook.Sheets(1).Select()
	EndWith
	Return $oExcel
EndFunc ;==>_ExcelBookOpenTxt

;===============================================================================
;
; Description:      Makes the specified Excel document object visible.
; Syntax:           _ExcelShow($oExcel)
; Parameter(s):     $oExcel - Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelShow($oExcel)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	$oExcel.Visible = TRUE
	Return 1
EndFunc ;==>_ExcelShow

;===============================================================================
;
; Description:      Makes the specified Excel document object invisible.
; Syntax:           _ExcelHide($oExcel)
; Parameter(s):     $oExcel - Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelHide($oExcel)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	$oExcel.Visible = FALSE
	Return 1
EndFunc ;==>_ExcelHide

;===============================================================================
;
; Description:      Send a specified range to the clipboard.
; Syntax:           _ExcelCopy($oExcel, $sRangeOrRowStart, $iColStart, $iRowEnd, $iColEnd)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the copy procedure (left)
;					$iRowEnd - The ending row for the copy procedure (bottom)
;					$iColEnd - The ending column for the copy procedure (right)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelCopy($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Copy
	Else
		$oExcel.Activesheet.Range($sRangeOrRowStart).Copy
	EndIf
	Return 1
EndFunc	;==>_ExcelCopy

;===============================================================================
;
; Description:      Send the clipboard data to a specified range.
; Syntax:           _ExcelPaste($oExcel, $iRangeOrRow, $iColumn)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColumn - The column to paste to if using R1C1 (default = 1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Row or column invalid
;							@extended=0 - Row invalid
;							@extended=1 - Column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelPaste($oExcel, $sRangeOrRow, $iColumn = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		If $sRangeOrRow < 1 Then Return SetError(2, 0, 0)
		If $iColumn < 1 Then Return SetError(2, 1, 0)
		$oExcel.Activesheet.Cells($sRangeOrRow, $iColumn).Select
		$oExcel.Activesheet.Paste
	Else
		$oExcel.Activesheet.Range($sRangeOrRow).Select
		$oExcel.Activesheet.Paste
	EndIf
	Return 1
EndFunc	;==>_ExcelPaste

;===============================================================================
;
; Description:      Insert the clipboard data at a specified cell.
; Syntax:           _ExcelInsert($oExcel, $sRangeOrRow, $iColumn = 1, $iShiftDirection = -4121)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRow - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColumn - The column to paste to if using R1C1 (default = 1)
;					$iShiftDirection - The direction to shift the existing text at insertion point ($xlShiftToRight|$xlShiftDown) (default=$xlShiftToRight)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Row or column invalid
;							@extended=0 - Row invalid
;							@extended=1 - Column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelInsert($oExcel, $sRangeOrRow, $iColumn = 1, $iShiftDirection = -4121)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		If $sRangeOrRow < 1 Then Return SetError(2, 0, 0)
		If $iColumn < 1 Then Return SetError(2, 1, 0)
		$oExcel.Activesheet.Cells($sRangeOrRow, $iColumn).Insert($iShiftDirection)
	Else
		$oExcel.Activesheet.Range($sRangeOrRow).Insert($iShiftDirection)
	EndIf
	Return 1
EndFunc	;==>_ExcelInsert

;===============================================================================
;
; Description:      Insert a picture from a separate file into the active sheet.
; Syntax:           _ExcelPictureInsert($oExcel, $sFilePath, $iLeft, $iTop, $iWidth, $iHeight, $fLinkToFile = False, $fSaveWithDoc = False)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sFilePath - The full path of the picture to be inserted
;					$fLinkToFile - "True" to link the picture to the file from which it was created. 
;								   "False" to make the picture an independent copy of the file. The default value is False.
;					$fSaveWithDoc - "True" to save the linked picture with the document. The default value is False.
;					$iLeft - The position (in points) of the upper-left corner of the picture relative to the upper-left corner of the worksheet
;					$iTop - The position (in points) of the upper-left corner of the picture relative to the top of the worksheet
;					$iWidth - The width of the picture, in points
;					$iHeight - The height of the picture, in points
; Requirement(s):   None
; Return Value(s):  On Success - Returns an object representing the inserted picture
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelPictureInsert($oExcel, $sFilePath, $iLeft, $iTop, $iWidth, $iHeight, $fLinkToFile = False, $fSaveWithDoc = False)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT FileExists($sFilePath) Then Return SetError(2, 0, 0)
	If $iLeft < 1 Then $iLeft = 1
	If $iTop < 1 Then $iTop = 1
	If $iWidth < 1 Then $iWidth = 1
	If $iHeight < 1 Then $iHeight = 1
	$oExcel.ActiveSheet.Shapes.AddPicture($sFilePath, $fLinkToFile, $fSaveWithDoc, $iLeft, $iTop, $iWidth, $iHeight).Select
	Return $oExcel.Selection.ShapeRange
EndFunc	;==>_ExcelPictureInsert

;===============================================================================
;
; Description:      Change the position or rotation of a picture object created with _ExcelPictureInsert().
; Syntax:           _ExcelPictureAdjust($oPicture, $iHorizontal, $iVertical, $iRotation = 0)
; Parameter(s):     $oPicture - An Excel picture object opened by a preceding call to _ExcelPictureInsert()
;					$iHorizontal - The number of points to move the picture left or right (positive numbers move the picture to the right)
;					$iVertical - The number of points to move the picture up or down (positive numbers move the picture down)
;					$iRotation - The number of degrees to rotate the picture clockwise (relative to current position)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Parameter incorrect
;									@extended=0 - $iHorizontal is not a number
;									@extended=1 - $iVertical is not a number
;									@extended=2 - $iRotation is not a number
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelPictureAdjust($oPicture, $iHorizontal, $iVertical, $iRotation = 0)
	If NOT IsObj($oPicture) Then Return SetError(1, 0, 0)
	If NOT IsNumber($iHorizontal) Then Return SetError(2, 0, 0)
	If NOT IsNumber($iVertical) Then Return SetError(2, 1, 0)
	If NOT IsNumber($iRotation) Then Return SetError(2, 2, 0)
	$oPicture.Select
	With $oPicture.Selection.ShapeRange
		.IncrementTop($iVertical)
		.IncrementLeft($iHorizontal)
		.IncrementRotation($iRotation)
	EndWith
	Return 1
EndFunc	;==>_ExcelPictureAdjust

;===============================================================================
;
; Description:      Scale a picture object created with _ExcelPictureInsert().
; Syntax:           _ExcelPictureScale($oPicture, $nScaleWidth = 1, $nScaleHeight = 1, $iScaleOrigWidth = True, $iScaleOrigHeight = True, $iScaleFrom = 0)
; Parameter(s):     $oPicture - An Excel picture object opened by a preceding call to _ExcelPictureInsert()
;					$nScaleWidth - The width scale factor to assign to the picture (1.0 = original size)
;					$nScaleHeight - The height scale factor to assign to the picture (1.0 = original size)
;					$fScaleOrigWidth - Scale based on original width (True or False)
;					$fScaleOrigHeight - Scale based on original height (True or False)
;					$iScaleFrom - Specifies which part of the shape retains its position when the shape is scaled
;									(0 = Scale from top left, 1 = Scale from middle, 2 = Scale from bottom right)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Parameter incorrect
;									@extended=0 - $nScaleWidth is not a number
;									@extended=1 - $nScaleHeight is not a number
;									@extended=2 - $fScaleOrigWidth is neither True nor False
;									@extended=3 - $fScaleOrigHeight is neither True nor False
;									@extended=4 - $iScaleFrom parameter incorrect (out of range)
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelPictureScale($oPicture, $nScaleWidth = 1, $nScaleHeight = 1, $fScaleOrigWidth = True, $fScaleOrigHeight = True, $iScaleFrom = 0)
	If NOT IsObj($oPicture) Then Return SetError(1, 0, 0)
	If NOT IsNumber($nScaleWidth) Then Return SetError(2, 0, 0)
	If NOT IsNumber($nScaleHeight) Then Return SetError(2, 1, 0)
	If $fScaleOrigWidth <> True Or $fScaleOrigWidth <> False Then Return SetError(2, 2, 0)
	If $fScaleOrigHeight <> True Or $fScaleOrigHeight <> False Then Return SetError(2, 3, 0)
	If NOT IsNumber($iScaleFrom) Then Return SetError(2, 4, 0)
	If NOT $iScaleFrom < 1 Or $iScaleFrom > 2 Then Return SetError(2, 4, 0)
	$oPicture.ScaleWidth($nScaleWidth, $fScaleOrigWidth, $iScaleFrom)
	$oPicture.ScaleHeight($nScaleHeight, $fScaleOrigHeight, $iScaleFrom)
	Return 1
EndFunc	;==>_ExcelPictureScale

;===============================================================================
;
; Description:      Create Borders around a range of cells
; Syntax:           _ExcelCreateBorders($oExcel, $sBorderStyle, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iEdgeLeft = 1, 
; 										$iEdgeTop = 1, $iEdgeBottom = 1, $iEdgeRight = 1, $iEdgeInsideV = 0, $iEdgeInsideH = 0)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;               $sBorderStyle - The type of border to use,  $xlThick, $xlThin, $xlDouble
;               $sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;               $iColStart - The starting column for the number format(left) (default=1)
;               $iRowEnd - The ending row for the number format (bottom) (default=1)
;               $iColEnd - The ending column for the number format (right) (default=1)
;               $iEdgeLeft - Specify if the left edge of the selected cells should have a border (default=1) Yes
;               $iEdgeTop  - Specify if the Top edge of the selected cells should have a border (default=1) Yes
;               $iEdgeBottom - Specify if the Bottom edge of the selected cells should have a border (default=1) Yes
;               $iEdgeRight - Specify if the Right edge of the selected cells should have a border (default=1) Yes
;               $iEdgeInsideV - Specify if the Inside Verticle edges of the selected cells should have a border (default=0) No
;               $iEdgeInsideH - Specify if the Inside Horizontal edges of the selected cells should have a border (default=0) No
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;                  @error=1 - Specified object does not exist
;                  @error=2 - Starting row or column invalid
;                     @extended=0 - Starting row invalid
;                     @extended=1 - Starting column invalid
;                  @error=3 - Ending row or column invalid
;                     @extended=0 - Ending row invalid
;                     @extended=1 - Ending column invalid
; Author(s):        MikeOsdx <Using Generic Excel functions from locodarwin>
; Note(s):          None
;
;===============================================================================
Func _ExcelCreateBorders($oExcel, $sBorderStyle, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, _
							$iEdgeLeft = 1, $iEdgeTop = 1, $iEdgeBottom = 1, $iEdgeRight = 1, $iEdgeInsideV = 0, $iEdgeInsideH = 0)
    If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
    If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
        If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
        If $iColStart < 1 Then Return SetError(2, 1, 0)
        If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
        If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
        if $iEdgeLeft = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlEdgeLeft)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeTop = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlEdgeTop)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeBottom = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlEdgeBottom)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeRight = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlEdgeRight)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideV = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlInsideVertical)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideH = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlInsideHorizontal)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
    Else
        if $iEdgeLeft = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeLeft)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeTop = 1 Then
            with $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeTop)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeBottom = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeBottom)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeRight = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeRight)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideV = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlInsideVertical)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideH = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlInsideHorizontal)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                .TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
    EndIf
    Return 1
EndFunc

;===============================================================================
;
; Description:      Performs a simplified sort on a range.
; Syntax:           _ExcelSort($oExcel, $sKey, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iDirection = 2)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sKey - The key column or row to sort by (a letter for column, a number for row)
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$iDirection - Sort direction (1=Ascending, 2=Descending) (default=descending)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>, many thanks to DaLiMan
; Note(s):          This sort routine will not function properly with pivot tables.  Please
;					use the pivot table sorting functions instead.
;
;===============================================================================
Func _ExcelSort($oExcel, $sKey, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iDirection = 2)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Sort _
					($oExcel.Range($sKey), $iDirection)
	Else
		$oExcel.Range($sRangeOrRowStart).Sort ($oExcel.Range($sKey), $iDirection)
	EndIf
	Return 1
EndFunc	;==>_ExcelSort

;===============================================================================
;
; Description:      Performs an advanced sort on a range.
; Syntax:           _ExcelSortExtended($oExcel, $sKey, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, _
;						$iDirection = 2, $iHeader = 0, $fMatchCase = False, $iOrientation = 2, $iDataOption = 0)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sKey - The key column or row to sort by (in A1 format)
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$iDirection - Sort direction (1=Ascending, 2=Descending) (default=descending)
;					$iHeader - Assume sort data has a header?  (1=yes, 2=No, 0=guess) (default=guess)
;					$fMatchCase - Match case when performing sort (True|False)
;					$iOrientation - Specify how sort data is arranged (1=sort columns, 2=sort rows) (default=sort rows)
;					$iDataOption - Specify how sort will treat data (0=sort normal, 1=sort text as numbers) (default = sort normal)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>, many thanks to DaLiMan
; Note(s):          This sort routine will not function properly with pivot tables.  Please
;					use the pivot table sorting functions instead.
;
;===============================================================================
Func _ExcelSortExtended($oExcel, $sKey, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iDirection = 2, $iHeader = 0, $fMatchCase = False, $iOrientation = 2, $iDataOption = 0)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Sort _
			($oExcel.Range($sKey), $iDirection, $oExcel.Range($sKey), Default, $iDirection,	$oExcel.Range($sKey), _
			$iDirection, $iHeader, True, $fMatchCase, $iOrientation, Default, $iDataOption)
	Else
		$oExcel.Range($sRangeOrRowStart).Sort ($oExcel.Range($sKey), $iDirection, $oExcel.Range($sKey), Default, _
			$iDirection, $oExcel.Range($sKey), $iDirection, $iHeader, True, $fMatchCase, $iOrientation, Default, $iDataOption)
	EndIf
	Return 1
EndFunc	;==>_ExcelSortExtended

;===============================================================================
;
; Description:      Finds all instances of a string in a range and returns their addresses as a two dimensional array.
; Syntax:           _ExcelFindInRange($oExcel, $sFindWhat, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, _
;					$iDataType = 0, $iWholeOrPart = 1, $iSearchOrder = 1, $iSearchDirection = 1, $fMatchCase = False, _
;					$fMatchFormat = False)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sFindWhat - The string to search for
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$iDataType - Limit the search to a certain kind of data (0=all, $xlFormulas(-4123), $xlValues(-4163), or $xlNotes(-4144)) (default=0)
;					$iWholeOrPart - Whole or part of cell must match search string (1=Whole, 2=Part) (default=2)
;					$fMatchCase - Specify whether case should match in search (True or False) (default=False)
;					$fMatchFormat - Specify whether cell formatting should match in search (True, False, or empty string) (default=empty string=do not use parameter)
; Requirement(s):   AutoIt Beta 3.2.1.12
; Return Value(s):  On Success - Returns a two dimensional array with addresses of matching cells.  If no matches found, returns null string
;						$array[0][0] - The number of found cells
;						$array[x][0] - The address of found cell x in A1 format
;						$array[x][1] - The address of found cell x in R1C1 format
;						$array[x][2] - The row of found cell x as an integer
;						$array[x][3] - The column of found cell x as an integer
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
;						@error=4 - Data type parameter invalid
;						@error=5 - Whole or part parameter invalid
; Author(s):        SEO <locodarwin at yahoo dot com> and MRDev, many thanks to DaLiMan
; Note(s):          None
;
;===============================================================================
Func _ExcelFindInRange($oExcel, $sFindWhat, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iDataType = 0, $iWholeOrPart = 2, $fMatchCase = False, $fMatchFormat = "")
	Local $iCount, $sA1, $sR1C1, $sFound, $Temp1, $Temp2, $sFirst
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $iDataType <> 0 Then
		If $iDataType <> -4163 Or $iDataType <> -4123 Or $iDataType <> -4144 Then
			Return SetError(4, 0, 0)
		EndIf
	EndIf
	If $iWholeOrPart < 1 Or $iWholeOrPart > 2 Then Return SetError(5, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Select
	Else
		$oExcel.Range($sRangeOrRowStart).Select
	EndIf
	If $iDataType = 0 Then
		If $fMatchFormat = "" Then
			$oFound = $oExcel.Selection.Find($sFindWhat, $oExcel.ActiveCell, Default, $iWholeOrPart, Default, Default, $fMatchCase, Default)
		Else
			$oFound = $oExcel.Selection.Find($sFindWhat, $oExcel.ActiveCell, Default, $iWholeOrPart, Default, Default, $fMatchCase, Default, $fMatchFormat)
		EndIf
	Else
		If $fMatchFormat = "" Then
			$oFound = $oExcel.Selection.Find($sFindWhat, $oExcel.ActiveCell, $iDataType, $iWholeOrPart, Default, Default, $fMatchCase, Default)
		Else
			$oFound = $oExcel.Selection.Find($sFindWhat, $oExcel.ActiveCell, $iDataType, $iWholeOrPart, Default, Default, $fMatchCase, Default, $fMatchFormat)
		EndIf
	EndIf
	If IsObj($oFound) Then
		$oFound.Activate
	Else
		Local $aFound[1][1]
		$aFound[0][0] = 0
		Return $aFound
	EndIf
	While 1
		If $iCount > 0 And $iCount < 2 Then $sFirst = $sA1
		$Temp1 = $oExcel.ActiveCell.Address
		$Temp2 = $oExcel.ActiveCell.Address(True, True, $xlR1C1)
		If $Temp1 = $sFirst Then ExitLoop
		If $iCount > 0 Then
			$sA1 = $sA1 & "*" & $Temp1
			$sR1C1 = $sR1C1 & "*" & $Temp2
		Else
			$sA1 = $Temp1
			$sR1C1 = $Temp2
		EndIf
		$iCount += 1
		$oExcel.Selection.FindNext($oExcel.ActiveCell).Activate
	WEnd
	Local $aFound[$iCount + 1][4]
	$sA1 = StringReplace($sA1, "$", "")
	Local $aA1 = StringSplit($sA1, "*")
	Local $aR1C1 = StringSplit($sR1C1, "*")
	$aFound[0][0] = $iCount
	For $xx = 1 To $iCount
		$aFound[$xx][0] = $aA1[$xx]
		$aFound[$xx][1] = $aR1C1[$xx]
		$Temp1 = StringRegExp($aR1C1[$xx], "[RZ]([^CS]*)[CS](.*)",3)
        $aFound[$xx][2] = Number($Temp1[1])
        $aFound[$xx][3] = Number($Temp1[0])
	Next
	Return $aFound
EndFunc	;==>_ExcelFindInRange

;===============================================================================
;
; Description:      Finds all instances of a string in a range and replace them with the replace string.
; Syntax:           _ExcelReplaceInRange($oExcel, $sFindWhat, $sReplaceWith, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1,  _
;										$iWholeOrPart = 2, $fMatchCase = False, $fMatchFormat = False, $fReplaceFormat = False)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sFindWhat - The string to search for
;					$sReplaceWith - The string to replace the search string with
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$iWholeOrPart - Whole or part of cell must match search string (1=Whole, 2=Part) (default=2)
;					$fMatchCase - Specify whether case should match in search (True or False) (default=False)
;					$fMatchFormat - Specify whether cell formatting should match in search (True or False) (default=False)
;					$fReplaceFormat - Specify whether cell format will be reset (True Or False) (default=False)
; Requirement(s):   AutoIt Beta 3.2.1.12
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
;						@error=4 - Whole or part parameter invalid
; Author(s):        SEO <locodarwin at yahoo dot com>, many thanks to DaLiMan
; Note(s):          None
;
;===============================================================================
Func _ExcelReplaceInRange($oExcel, $sFindWhat, $sReplaceWith, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iWholeOrPart = 2, $fMatchCase = False, $fMatchFormat = "", $fReplaceFormat = False)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $iWholeOrPart < 1 Or $iWholeOrPart > 2 Then Return SetError(4, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Select
	Else
		$oExcel.Range($sRangeOrRowStart).Select
	EndIf
	If $fMatchFormat = "" Then
		$oExcel.Selection.Replace($sFindWhat, $sReplaceWith, $iWholeOrPart, Default, $fMatchCase, Default, Default, $fReplaceFormat)
	Else
		$oExcel.Selection.Replace($sFindWhat, $sReplaceWith, $iWholeOrPart, Default, $fMatchCase, Default, $fMatchFormat, $fReplaceFormat)
	EndIf
	Return 1
EndFunc	;==>_ExcelReplaceInRange

;===============================================================================
;
; Description:      Add a comment.
; Syntax:           _ExcelCommentAdd($oExcel, $sComment, $sRangeOrRow, $iColumn = 1, $fVisible = 0)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sComment - The comment text
;					$sRangeOrRow - Either an A1 range, or an integer row number to write to if using R1C1
;					$iColumn - The column to write to if using R1C1 (default = 1)
;					$fVisible - Specify if the comment is to be displayed in entirety (True|False)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          A non-visible comment will show up as a red, earmarked corner of the affected cell(s). 
;
;===============================================================================
Func _ExcelCommentAdd($oExcel, $sComment, $sRangeOrRow, $iColumn = 1, $fVisible = 0)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $fVisible < 0 Then $fVisible = 0
	If $fVisible > 1 Then $fVisible = 1
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		With $oExcel.Cells($sRangeOrRow, $iColumn)
			.AddComment
			.Comment.Visible = $fVisible
			.Comment.Text($sComment)
		EndWith
	Else
		With $oExcel.Range($sRangeOrRow)
			.AddComment
			.Comment.Visible = $fVisible
			.Comment.Text($sComment)
		EndWith
	EndIf
	Return 1
EndFunc	;==>_ExcelCommentAdd

;===============================================================================
;
; Description:      Delete a range of comments.
; Syntax:           _ExcelCommentDelete($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          A non-visible comment will show up as a red, earmarked corner of the affected cell(s). 
;
;===============================================================================
Func _ExcelCommentDelete($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).ClearComments
	Else
		$oExcel.Range($sRangeOrRowStart).ClearComments
	EndIf
	Return 1
EndFunc	;==>_ExcelCommentDelete

;===============================================================================
;
; Description:      Show/hide a range of comments.
; Syntax:           _ExcelCommentShow($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $fVisible = False)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$fVisible - Show or hide the specified range of comments (True|False) (default=false)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          A non-visible comment will show up as a red, earmarked corner of the affected cell(s). 
;
;===============================================================================
Func _ExcelCommentShow($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $fVisible = False)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $fVisible < 0 Then $fVisible = 0
	If $fVisible > 1 Then $fVisible = 1
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Comment.Visible = $fVisible
	Else
		$oExcel.Range($sRangeOrRowStart).Comment.Visible = $fVisible
	EndIf
	Return 1
EndFunc	;==>_ExcelCommentShow

;===============================================================================
;
; Description:      Read a comment from a cell.
; Syntax:           $var = _ExcelCommentRead($oExcel, $sRangeOrRow, $iColumn = 1)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRow - Either an A1 range, or an integer row number to read from if using R1C1
;					$iColumn - The column to read from if using R1C1 (default = 1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns the string contents of the comment
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          A non-visible comment will show up as a red, earmarked corner of the affected cell(s). 
;
;===============================================================================
Func _ExcelCommentRead($oExcel, $sRangeOrRow, $iColumn = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		Return $oExcel.Cells($sRangeOrRow, $iColumn).Comment.Text
	Else
		Return $oExcel.Range($sRangeOrRow).Comment.Text
	EndIf
EndFunc	;==>_ExcelCommentRead

;===============================================================================
;
; Description:      Split the active window into 2 or 4 sections.
; Syntax:           _ExcelSplitWindow($oExcel, $iSplitRow, $iSplitColumn)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$iSplitRow - The row to begin the split
;					$iSplitColumn - The column to begin the split
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None. 
;
;===============================================================================
Func _ExcelSplitWindow($oExcel, $iSplitRow, $iSplitColumn)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $iSplitRow < 0 Then $iSplitRow = 0
	If $iSplitColumn < 0 Then $iSplitColumn = 0
	$oExcel.ActiveWindow.SplitColumn = $iSplitColumn
    $oExcel.ActiveWindow.SplitRow = $iSplitRow
EndFunc	;==>_ExcelSplitWindow

;===============================================================================
;
; Description:      Set the font face property of a range in an Excel object.
; Syntax:           _ExcelFontSet($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $sFontName = "Arial")
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$sFontName - The font name to set the range to (default = "Arial")
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelFontSet($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $sFontName = "Arial")
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Font.Name = $sFontName
	Else
		$oExcel.Activesheet.Range($sRangeOrRowStart).Font.Name = $sFontName
	EndIf
	Return 1
EndFunc ;==>_ExcelFontSet

;===============================================================================
;
; Description:      Get the font face property of a range in an Excel object.
; Syntax:           $var = _ExcelFontGet($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRow - Either an A1 range, or an integer row number to read from if using R1C1
;					$iColumn - The column to read from if using R1C1 (default = 1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns the name of the font face as a string
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          Ranges more than one cell will return only the value of the top left cell
;
;===============================================================================
Func _ExcelFontGet($oExcel, $sRangeOrRow, $iColumn = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		Return $oExcel.Activesheet.Cells($sRangeOrRow, $iColumn).Font.Name
	Else
		Return $oExcel.Activesheet.Range($sRangeOrRow).Font.Name
	EndIf
EndFunc ;==>_ExcelFontGet

;===============================================================================
;
; Description:      Set the font size property of a range in an Excel object.
; Syntax:           _ExcelFontSetSize($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iFontSize = 10)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$sFontSize - The font size in points to set the range to (default = 10 points)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelFontSetSize($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iFontSize = 10)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Font.Size = $iFontSize
	Else
		$oExcel.Activesheet.Range($sRangeOrRowStart).Font.Size = $iFontSize
	EndIf
	Return 1
EndFunc ;==>_ExcelFontSetSize

;===============================================================================
;
; Description:      Get the font size property of a range in an Excel object.
; Syntax:           $var = _ExcelFontGetSize($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRow - Either an A1 range, or an integer row number to read from if using R1C1
;					$iColumn - The column to read from if using R1C1 (default = 1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns the font size in points as an integer
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          Ranges more than one cell will return only the size value of the top left cell
;
;===============================================================================
Func _ExcelFontGetSize($oExcel, $sRangeOrRow, $iColumn = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		Return $oExcel.Activesheet.Cells($sRangeOrRow, $iColumn).Font.Size
	Else
		Return $oExcel.Activesheet.Range($sRangeOrRow).Font.Size
	EndIf
EndFunc ;==>_ExcelFontGetSize

;===============================================================================
;
; Description:      Set the font color value of a range in an Excel object.
; Syntax:           _ExcelFontSetColor($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, _
;									$iColorIndex = 1, $hColor = 0x000000)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$iColorIndex - The font color index (default = 1, if > 254 then $hColor is used instead)
;					$hColor - Hex value of color used when colorindex > 254
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelFontSetColor($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iColorIndex = 1, $hColor = 0x000000)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		If $iColorIndex < 255 Then
			$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Font.ColorIndex = $iColorIndex
		Else
			$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Font.Color = $hColor
		EndIf
	Else
		If $iColorIndex < 255 Then
			$oExcel.Activesheet.Range($sRangeOrRowStart).Font.ColorIndex = $iColorIndex
		Else
			$oExcel.Activesheet.Range($sRangeOrRowStart).Font.Color = $hColor
		EndIf
	EndIf
	Return 1
EndFunc ;==>_ExcelFontSetColor

;===============================================================================
;
; Description:      Get the font color value of a range in an Excel object.
; Syntax:           $var = _ExcelFontGetColor($oExcel, $sRangeOrRow, $iColumn = 1)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRow - Either an A1 range, or an integer row number to read from if using R1C1
;					$iColumn - The column to read from if using R1C1 (default = 1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns color value of the range as an integer
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          Ranges more than one cell will return only the color value of the top left cell
;
;===============================================================================
Func _ExcelFontGetColor($oExcel, $sRangeOrRow, $iColumn = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		Return $oExcel.Activesheet.Cells($sRangeOrRow, $iColumn).Font.Color
	Else	
		Return $oExcel.Activesheet.Range($sRangeOrRow).Font.Color
	EndIf
EndFunc ;==>_ExcelFontGetColor

;===============================================================================
;
; Description:      Set the cell interior color value of a range in an Excel object.
; Syntax:           _ExcelCellColorSet($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, _
;										$iColorIndex = 1, $hColor = 0x000000)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$iColorIndex - The interior color index (default = 1, if > 254 then $hColor is used instead)
;					$hColor - Hex value of color used when colorindex > 254
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelCellColorSet($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iColorIndex = 1, $hColor = 0x000000)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		If $iColorIndex < 255 Then
			$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Interior.ColorIndex = $iColorIndex
		Else
			$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Interior.Color = $hColor
		EndIf
	Else
		If $iColorIndex < 255 Then
			$oExcel.Activesheet.Range($sRangeOrRowStart).Interior.ColorIndex = $iColorIndex
		Else
			$oExcel.Activesheet.Range($sRangeOrRowStart).Interior.Color = $hColor
		EndIf
	EndIf
	Return 1
EndFunc ;==>_ExcelCellColorSet

;===============================================================================
;
; Description:      Get the cell interior color value of a range in an Excel object.
; Syntax:           $var = _ExcelCellColorGet($oExcel, $sRangeOrRow, $iColumn = 1)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRow - Either an A1 range, or an integer row number to read from if using R1C1
;					$iColumn - The column to read from if using R1C1 (default = 1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns cell interior color value of the range as integer
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          Ranges more than one cell will return only the cell color value of the top left cell
;
;===============================================================================
Func _ExcelCellColorGet($oExcel, $sRangeOrRow, $iColumn = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRow, "[A-Z,a-z]", 0) Then
		Return $oExcel.Activesheet.Cells($sRangeOrRow, $iColumn).Interior.ColorIndex
	Else
		Return $oExcel.Activesheet.Range($sRangeOrRow).Interior.ColorIndex
	EndIf
EndFunc ;==>_ExcelCellColorGet

;===============================================================================
;
; Description:      Set the vertical alignment of each cell in a range.
; Syntax:           _ExcelVerticalAlignSet($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $sVertAlign = "bottom")
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$sVertAlign - Vertical alignment ("top"|"center"|"bottom") (default="bottom")
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelVerticalAlignSet($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $sVertAlign = "bottom")
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)	
		Switch ($sVertAlign)
			Case "bottom"
				$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).VerticalAlignment = $xlVAlignBottom
			Case "center", "centre"
				$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).VerticalAlignment = $xlVAlignCenter
			Case "top"
				$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).VerticalAlignment = $xlVAlignTop
		EndSwitch
	Else
		Switch ($sVertAlign)
			Case "bottom"
				$oExcel.Activesheet.Range ($sRangeOrRowStart).VerticalAlignment = $xlVAlignBottom
			Case "center", "centre"
				$oExcel.Activesheet.Range ($sRangeOrRowStart).VerticalAlignment = $xlVAlignCenter
			Case "top"
				$oExcel.Activesheet.Range ($sRangeOrRowStart).VerticalAlignment = $xlVAlignTop
		EndSwitch
	EndIf
	Return 1
EndFunc ;==>_ExcelVerticalAlignSet

;===============================================================================
;
; Description:      Set the column width of the specified column.
; Syntax:           _ExcelColWidthSet($oExcel, $vColumn, $vWidth)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sColumn - A valid Excel column, either a number or an A1 string (i.e. 5, or "C")
;					$vWidth - The width of the column in points, or the string "autofit"
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelColWidthSet($oExcel, $vColumn, $vWidth)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $vWidth = "autofit" Then
		$oExcel.Activesheet.Columns($vColumn).Autofit
	Else
		$oExcel.Activesheet.Columns($vColumn).ColumnWidth = $vWidth
	EndIf
	Return 1
EndFunc ;==>_ExcelColWidthSet

;===============================================================================
;
; Description:      Get the column width of the specified column.
; Syntax:           $var = _ExcelColWidthGet($oExcel, $sColumn)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$vColumn - A valid Excel column, either a number or an A1 string (i.e. 5, or "C")
; Requirement(s):   None
; Return Value(s):  On Success - Returns the column width in points
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelColWidthGet($oExcel, $vColumn)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	Return $oExcel.Activesheet.Columns($vColumn).ColumnWidth
EndFunc ;==>_ExcelColWidthGet

;===============================================================================
;
; Description:      Set the row height of the specified row.
; Syntax:           _ExcelRowHeightSet($oExcel, $sRow, $vHeight)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$iRow - The integer representation of a valid Excel row (i.e. 45)
;					$vHeight - The height of the row in points, or the string "autofit"
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelRowHeightSet($oExcel, $iRow, $vHeight)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $vHeight = "autofit" Then
		$oExcel.Activesheet.Rows($iRow).Autofit
	Else
		$oExcel.Activesheet.Rows($iRow).RowHeight = $vHeight
	EndIf
EndFunc ;==>_ExcelRowHeightSet

;===============================================================================
;
; Description:      Get the row height of the specified row.
; Syntax:           $var = _ExcelRowHeightGet($oExcel, $sRow)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$iRow - The integer representation of a valid Excel row (i.e. 45)
; Requirement(s):   None
; Return Value(s):  On Success - Returns the row height in points
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelRowHeightGet($oExcel, $iRow)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	Return $oExcel.Activesheet.Rows($iRow).RowHeight
EndFunc ;==>_ExcelRowHeightGet

;===============================================================================
;
; Description:      Return the last cell of the used range in the specified worksheet.
; Syntax:           $array = _ExcelSheetUsedRangeGet($oExcel, $vSheet)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;                   $vSheet - The sheet name or number to be checked.
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array of used range values:
;						$array[0] - The last cell used, in A1 format (if 0 is returned, worksheet is blank)
;						$array[1] - The last cell used, in R1C1 format
;						$array[2] - The last column used, as an integer
;						$array[3] - The last row used, as an integer
;                   On Failure - Returns 0 (as non-array numeric value) and sets @error on errors:
;                   	@error=1 - Specified object does not exist
;                   	@error=2 - Invalid sheet number
;                   	@error=3 - Invalid sheet name
; Author(s):        DaLiMan, MRDev, SEO <locodarwin at yahoo dot com>
; Note(s):          Upon return, $array[0] will equal numeric value 0 if the worksheet is blank
;
;===============================================================================
Func _ExcelSheetUsedRangeGet($oExcel, $vSheet)
    Local $aSendBack[4], $sTemp, $aSheetList, $fFound = 0
    If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If IsNumber($vSheet) Then
		If $oExcel.ActiveWorkbook.Sheets.Count < $vSheet Then Return SetError(2, 0, 0)
	Else
		$aSheetList = _ExcelSheetList($oExcel)
		For $xx = 1 To $aSheetList[0]
			If $aSheetList[$xx] = $vSheet Then $fFound = 1
		Next
		If NOT $fFound Then Return SetError(3, 0, 0)
	EndIf
	$oExcel.ActiveWorkbook.Sheets($vSheet).Select
	$aSendBack[0] = $oExcel.Application.Selection.SpecialCells($xlCellTypeLastCell).Address
    $aSendBack[1] = $oExcel.Application.Selection.SpecialCells($xlCellTypeLastCell).Address(True, True, $xlR1C1)
	$aSendBack[0] = StringReplace($aSendBack[0], "$", "")
	$sTemp = StringRegExp($aSendBack[1], "[RZ]([^CS]*)[CS](.*)",3)
    $aSendBack[2] = Number($sTemp[1])
    $aSendBack[3] = Number($sTemp[0])
    If $aSendBack[0] = "A1" And $oExcel.Activesheet.Range($aSendBack[0]).Value = "" Then $aSendBack[0] = 0
    Return $aSendBack
EndFunc	;==>_ExcelSheetUsedRangeGet

;===============================================================================
;
; Description:      Set/Reset some common cell/range formatting parameters.
; Syntax:           _ExcelCellFormat($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, _
;						$fWrapText = False, $iOrientation = 0, $fAddIndent = False, $iIndentLevel = 0, $fShrinkToFit = False)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$fWrapText - Perform word wrap on the cells in the range (True or False) (default=False)
;					$iOrientation - Text orientation in degrees (-90 to 90) (default=0)
;					$fAddIndent - Perform indentation on the cells in the range (True or False) (default=False)
;					$iIndentLevel - How deep to indent the contents of the cells in the range, in points (default=0)
;					$fShrinkToFit - Shrink the contents of the cells in the range to fit the cells' dimensions (True or False) (default = False)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelCellFormat($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $fWrapText = False, $iOrientation = 0, $fAddIndent = False, $iIndentLevel = 0, $fShrinkToFit = False)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $iOrientation < -90 or $iOrientation > 90 Then $iOrientation = 0
	If NOT IsNumber($iIndentLevel) Then $iIndentLevel = 0
	If $iIndentLevel < 0 Then $iIndentLevel = 0
	If $iIndentLevel > 15 Then $iIndentLevel = 15
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd))
			.WrapText = $fWrapText
			.Orientation = $iOrientation
			.AddIndent = $fAddIndent
			.IndentLevel = $iIndentLevel
			.ShrinkToFit = $fShrinkToFit
		EndWith
	Else
		With $oExcel.Activesheet.Range($sRangeOrRowStart)
			.WrapText = $fWrapText
			.Orientation = $iOrientation
			.AddIndent = $fAddIndent
			.IndentLevel = $iIndentLevel
			.ShrinkToFit = $fShrinkToFit
		EndWith
	EndIf
	Return 1
EndFunc	;==>_ExcelCellFormat

;===============================================================================
;
; Description:      Merge/UnMerge cell(s) in a range.
; Syntax:           _ExcelCellMerge($oExcel, $fDoMerge, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$fDoMerge - Flag, True performs a merge on the range, False reverses an existing merge in the range (True or False) (default=False)
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
;						@error=4 - $fDoMerge is not set as True or False
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelCellMerge($oExcel, $fDoMerge, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $fDoMerge <> False Or $fDoMerge <> True Then Return SetError(4, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).MergeCells = $fDoMerge
	Else
		$oExcel.Activesheet.Range($sRangeOrRowStart).MergeCells = $fDoMerge
	EndIf
	Return 1
EndFunc ;==>_ExcelCellMerge

;===============================================================================
;
; Description:      Print a range of cells to a printer or a file.
; Syntax:           _ExcelPrintRange($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iCopies = 1, 
;										$sActivePrinter = "", $fPrintToFile = False, $fCollate = False, $sPrToFileName = "")
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sRangeOrRowStart - Either an A1 range, or an integer row number to start from if using R1C1
;					$iColStart - The starting column for the number format(left) (default=1)
;					$iRowEnd - The ending row for the number format (bottom) (default=1)
;					$iColEnd - The ending column for the number format (right) (default=1)
;					$iCopies - How many copies to print (default = 1)
;					$sActivePrinter - The URL and port of the printer to make active (default = "")
;					$fPrintToFile - Flag, print to file instead of printer (default = False)
;					$fCollate - Flag, to collate mutiple copies (default = False)
;					$sPrToFileName - String filename to print to when printing to file (default = "")
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Starting row or column invalid
;							@extended=0 - Starting row invalid
;							@extended=1 - Starting column invalid
;						@error=3 - Ending row or column invalid
;							@extended=0 - Ending row invalid
;							@extended=1 - Ending column invalid
;						@error=4 - $fPrintToFile out of range
;						@error=5 - $fCollate out of range
;						@error=6 - $iCopies must be between 1 and 255
;						@error=7 - Trying to print to filename that is unspecified
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelPrintRange($oExcel, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1, $iCopies = 1, $sActivePrinter = "", _
						$fPrintToFile = False, $fCollate = False, $sPrToFileName = "")
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $fPrintToFile < 0 Or $fPrintToFile > 1 Then Return SetError(4, 0, 0)
	If $fCollate < 0 Or $fCollate > 1 Then Return SetError(5, 0, 0)
	If $iCopies < 1 Or $iCopies > 255 Then Return SetError(6, 0, 0)
	If NOT StringRegExp($sRangeOrRowStart, "[A-Z,a-z]", 0) Then
		If $sRangeOrRowStart < 1 Then Return SetError(2, 0, 0)
		If $iColStart < 1 Then Return SetError(2, 1, 0)
		If $iRowEnd < $sRangeOrRowStart Then Return SetError(3, 0, 0)
		If $iColEnd < $iColStart Then Return SetError(3, 1, 0)
		$oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Select
	Else
		$oExcel.Activesheet.Range($sRangeOrRowStart).Select
	EndIf
	If $sActivePrinter = "" Then $sActivePrinter = $oExcel.ActivePrinter
	If $sPrToFileName = "" Then
		If $fPrintToFile = True Then Return SetError(7, 0, 0)
	EndIf
	$oExcel.Selection.PrintOut(Default, Default, $iCopies, False, $sActivePrinter, $fPrintToFile, $fCollate, $sPrToFileName)
	Return 1
EndFunc ;==>_ExcelPrintRange

;===============================================================================
;
; Description:      Print a worksheet.
; Syntax:           _ExcelPrintSheet($oExcel, $vSheet, $iCopies = 1, $sActivePrinter = "", $fPrintToFile = False, _
;										$fCollate = False, $sPrToFileName = "")
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$vSheet - Either an A1 range, or an integer row number to start from if using R1C1
;					$iCopies - How many copies to print (default = 1)
;					$sActivePrinter - The URL and port of the printer to make active (default = "")
;					$fPrintToFile - Flag, print to file instead of printer (default = False)
;					$fCollate - Flag, to collate mutiple copies (default = False)
;					$sPrToFileName - String filename to print to when printing to file (default = "")
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Specified sheet number doesn't exist
;						@error=3 - Specified sheet name doesn't exist
;						@error=4 - $fPrintToFile out of range
;						@error=5 - $fCollate out of range
;						@error=6 - $iCopies must be between 1 and 255
;						@error=7 - Trying to print to filename that is unspecified
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelPrintSheet($oExcel, $vSheet, $iCopies = 1, $sActivePrinter = "", $fPrintToFile = False, _
						$fCollate = False, $sPrToFileName = "")
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $fPrintToFile < 0 Or $fPrintToFile > 1 Then Return SetError(4, 0, 0)
	If $fCollate < 0 Or $fCollate > 1 Then Return SetError(5, 0, 0)
	If $iCopies < 1 Or $iCopies > 255 Then Return SetError(6, 0, 0)
	If $sActivePrinter = "" Then $sActivePrinter = $oExcel.ActivePrinter
	If $sPrToFileName = "" Then
		If $fPrintToFile = True Then Return SetError(7, 0, 0)
	EndIf
	If IsNumber($vSheet) Then
		If $oExcel.ActiveWorkbook.Sheets.Count < $vSheet Then Return SetError(2, 0, 0)
	Else
		Local $fFound = 0
		Local $aSheetList = _ExcelSheetList($oExcel)
		For $xx = 1 To $aSheetList[0]
			If $aSheetList[$xx] = $vSheet Then $fFound = 1
		Next
		If NOT $fFound Then Return SetError(3, 0, 0)
	EndIf
	$oExcel.Sheets($vSheet).Activate
	$oExcel.ActiveSheet.PrintOut(Default, Default, $iCopies, False, $sActivePrinter, $fPrintToFile, $fCollate, $sPrToFileName)
	Return 1
EndFunc ;==>_ExcelPrintSheet


;===============================================================================
;
; Description:      Return an array of workbook properties.
; Syntax:           $array = _ExcelBookPropertiesGet($oExcel)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array of properties:
;						$array[0] = Workbook author
;						$array[1] = Workbook title
;						$array[2] = Workbook subject
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelBookPropertiesGet($oExcel)
	Local $aReturnArray[3]
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	$aReturnArray[0] = $oExcel.ActiveWorkbook.Author
	$aReturnArray[1] = $oExcel.ActiveWorkbook.Title
	$aReturnArray[2] = $oExcel.ActiveWorkbook.Subject
	Return $aReturnArray
EndFunc ;==>_ExcelBookPropertiesGet

;===============================================================================
;
; Description:      Set workbook properties.
; Syntax:           _ExcelBookPropertiesSet($oExcel, $sAuthor = "", $sTitle = "", $sSubject = "")
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sAuthor - A string to be assigned to the Author property of the workbook (default = empty string = no change)
;					$sTitle - A string to be assigned to the Title property of the workbook (default = empty string = no change)
;					$sSubject - A string to be assigned to the Author property of the workbook (default = empty string = no change)
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
;===============================================================================
Func _ExcelBookPropertiesSet($oExcel, $sAuthor = "", $sTitle = "", $sSubject = "")
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $sAuthor <> "" Then $oExcel.ActiveWorkbook.Author = $sAuthor
	If $sTitle <> "" Then $oExcel.ActiveWorkbook.Title = $sTitle
	If $sSubject <> "" Then $oExcel.ActiveWorkbook.Subject = $sSubject
	Return 1
EndFunc ;==>_ExcelBookPropertiesSet



#endregion


#region Notes, Future Plans, Etc.
#cs

To be written:

	_ExcelPrintSetup()

#ce
#endregion