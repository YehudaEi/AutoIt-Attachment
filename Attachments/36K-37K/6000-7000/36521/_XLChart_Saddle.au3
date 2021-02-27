#include <ExcelChart.au3>
#include <Excel.au3>

Opt('MustDeclareVars', 1)

; Set Debug level. 0 = no debug information, 1 = to console, 2 = to MsgBox, 3 = into File
Global $iXLC_Debug = 0

; Create data and open Excel using _ExcelBookOpenTxt
Local $sSaddleCSV = @CRLF & _
			  ";-200;=+B2+50;=+C2+50;=+D2+50;=+E2+50;=+F2+50;=+G2+50;=H2+50;=+I2+50" & @CRLF & _
			  "-200;=(B$2^2-$A3^2)/100;=(C$2^2-$A3^2)/100;=(D$2^2-$A3^2)/100;=(E$2^2-$A3^2)/100;=(F$2^2-$A3^2)/100;=(G$2^2-$A3^2)/100;=(H$2^2-$A3^2)/100;=(I$2^2-$A3^2)/100;=(J$2^2-$A3^2)/100" & @CRLF & _
			  "=+A3+50;=(B$2^2-$A4^2)/100;=(C$2^2-$A4^2)/100;=(D$2^2-$A4^2)/100;=(E$2^2-$A4^2)/100;=(F$2^2-$A4^2)/100;=(G$2^2-$A4^2)/100;=(H$2^2-$A4^2)/100;=(I$2^2-$A4^2)/100;=(J$2^2-$A4^2)/100" & @CRLF & _
			  "=+A4+50;=(B$2^2-$A5^2)/100;=(C$2^2-$A5^2)/100;=(D$2^2-$A5^2)/100;=(E$2^2-$A5^2)/100;=(F$2^2-$A5^2)/100;=(G$2^2-$A5^2)/100;=(H$2^2-$A5^2)/100;=(I$2^2-$A5^2)/100;=(J$2^2-$A5^2)/100" & @CRLF & _
			  "=+A5+50;=(B$2^2-$A6^2)/100;=(C$2^2-$A6^2)/100;=(D$2^2-$A6^2)/100;=(E$2^2-$A6^2)/100;=(F$2^2-$A6^2)/100;=(G$2^2-$A6^2)/100;=(H$2^2-$A6^2)/100;=(I$2^2-$A6^2)/100;=(J$2^2-$A6^2)/100" & @CRLF & _
			  "=+A6+50;=(B$2^2-$A7^2)/100;=(C$2^2-$A7^2)/100;=(D$2^2-$A7^2)/100;=(E$2^2-$A7^2)/100;=(F$2^2-$A7^2)/100;=(G$2^2-$A7^2)/100;=(H$2^2-$A7^2)/100;=(I$2^2-$A7^2)/100;=(J$2^2-$A7^2)/100" & @CRLF & _
			  "=+A7+50;=(B$2^2-$A8^2)/100;=(C$2^2-$A8^2)/100;=(D$2^2-$A8^2)/100;=(E$2^2-$A8^2)/100;=(F$2^2-$A8^2)/100;=(G$2^2-$A8^2)/100;=(H$2^2-$A8^2)/100;=(I$2^2-$A8^2)/100;=(J$2^2-$A8^2)/100" & @CRLF & _
			  "=+A8+50;=(B$2^2-$A9^2)/100;=(C$2^2-$A9^2)/100;=(D$2^2-$A9^2)/100;=(E$2^2-$A9^2)/100;=(F$2^2-$A9^2)/100;=(G$2^2-$A9^2)/100;=(H$2^2-$A9^2)/100;=(I$2^2-$A9^2)/100;=(J$2^2-$A9^2)/100" & @CRLF & _
			  "=+A9+50;=(B$2^2-$A10^2)/100;=(C$2^2-$A10^2)/100;=(D$2^2-$A10^2)/100;=(E$2^2-$A10^2)/100;=(F$2^2-$A10^2)/100;=(G$2^2-$A10^2)/100;=(H$2^2-$A10^2)/100;=(I$2^2-$A10^2)/100;=(J$2^2-$A10^2)/100" & @CRLF & _
			  "=+A10+50;=(B$2^2-$A11^2)/100;=(C$2^2-$A11^2)/100;=(D$2^2-$A11^2)/100;=(E$2^2-$A11^2)/100;=(F$2^2-$A11^2)/100;=(G$2^2-$A11^2)/100;=(H$2^2-$A11^2)/100;=(I$2^2-$A11^2)/100;=(J$2^2-$A11^2)/100" & @CRLF

Local $file = FileOpen(@ScriptDir & "\Saddle.csv", 2)
If $file = -1 Then Exit MsgBox(0, "Error", "Unable to open file.")
FileWrite($file,$sSaddleCSV)
FileClose($file)

Local $oExcel = _ExcelBookOpenTxt(@ScriptDir & "\Saddle.csv", ";")
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _ExcelBookOpenTxt!")

; *****************************************************************************
; Excel Version Check - exit if earlier than Excel 2007
; *****************************************************************************
If _XLChart_Version($oExcel) < 12 Then Exit MsgBox(16, "Excel Thermometer Chart Example Script", "The installed Excel version is not supported by this UDF!" & @CRLF & "Version must be >= 12 (Excel 2007).")

; New function to be developed
; Hide default gridlines
$oExcel.ActiveWindow.DisplayGridlines = False

; *****************************************************************************
; Set zoom to 70, so that all charts are visible
; *****************************************************************************
$oExcel.ActiveWindow.Zoom = 50
; *****************************************************************************
; Set title
; *****************************************************************************
Local $sCell = "A1"
_ExcelRowInsert($oExcel, 1, 1)
_ExcelWriteCell($oExcel, "Saddle Chart Example", $sCell)

; set row height
_ExcelRowHeightSet($oExcel, "1:1", 30)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelRowHeightSet' on line " & @ScriptLineNumber)

; set the font
_ExcelFontSet($oExcel, $sCell, 1, 1, 1, "Arial Rounded MT Bold")
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelFontSet' on line " & @ScriptLineNumber)

; set the font size
_ExcelFontSetSize($oExcel, $sCell, 1, 1, 1, 14)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelFontSetSize' on line " & @ScriptLineNumber)

; set font property
_ExcelFontSetProperties($oExcel, $sCell, 1, 1, 1, True, True, False)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelFontSetProperties' on line " & @ScriptLineNumber)

; set horizontal alignment of title only
_ExcelHorizontalAlignSet($oExcel, $sCell, 1, 1, 1, "center")
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelHorizontalAlignSet' on line " & @ScriptLineNumber)

; set vertical alignment
_ExcelVerticalAlignSet($oExcel, $sCell, 1, 1, 1 , "center")
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelVerticalAlignSet' on line " & @ScriptLineNumber)

; main  Title color
_ExcelFontSetColor($oExcel, $sCell, 1, 1, 1, 255, 0x8D1A1A)	; font color
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelFontSetColor' on line " & @ScriptLineNumber)

_ExcelCellColorSet($oExcel, $sCell, 1, 1, 1, 255, 0x7DFFFF)	; color the background
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelCellColorSet' on line " & @ScriptLineNumber)

; Now Merge the main title line
_ExcelCellMerge($oExcel, True, 1, 1, 1, 10)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelCellMerge' on line " & @ScriptLineNumber)

$sCell = "A2"
_ExcelWriteCell($oExcel, "By GreenCan", $sCell)

_ExcelFontSetProperties($oExcel, $sCell, 1, 1, 1, False, True, False)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelFontSetProperties' on line " & @ScriptLineNumber)

_ExcelCellColorSet($oExcel, $sCell, 1, 1, 1, 255, 0x00CEFF)	; color the background
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelCellColorSet' on line " & @ScriptLineNumber)

_ExcelCellMerge($oExcel, True, 2, 1, 2, 10)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelCellMerge' on line " & @ScriptLineNumber)

; draw borders
_ExcelCreateBorders($oExcel, $xlThin, 1, 1, 2, 10, 1, 1, 1, 1, 0, 1)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelCreateBorders' on line " & @ScriptLineNumber)

_ExcelCreateBorders($oExcel, $xlThin, 3, 1, 12, 10, 1, 1, 1, 1, 1, 1)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelCreateBorders' on line " & @ScriptLineNumber)

; Disable screen updating to enhance performance
_XLChart_ScreenUpdateSet($oExcel, 0) ; 2)

; *****************************************************************************
; prepare chart data
; *****************************************************************************
; set the data range
Local $DataRange = StringSplit("B4:J4;B5:J5;B6:J6;B7:J7;B8:J8;B9:J9;B10:J10;B11:J11;B12:J12",";")
For $_ii = 1 to $DataRange[0]
	$DataRange[$_ii] = "=Saddle!" & $DataRange[$_ii]
Next

; set the data names
Local $DataName = StringSplit("A4;A5;A6;A7;A8;A9;A10;A11;A12",";")
For $_ii = 1 to $DataName[0]
	$DataName[$_ii] = "=Saddle!" & $DataName[$_ii]
Next

; Create chart nr 1
Local $oChart1 = _XLChart_ChartCreate($oExcel, 1, $xlSurface, "L3:AA58", "Saddle1", "=Saddle!B3:J3", $DataRange, $DataName, True, "Saddle (by GreenCan)")
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ChartCreate!")

; bug Excel 2007, have to repeat charttype
_XLChart_ChartSet($oChart1, $xlSurface)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ChartSet!")

; remove gridlines
_XLChart_GridSet($oChart1.Axes($xlValue), False)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_GridSet!")

; Remove the border line on y-axis and x-axis
_XLChart_ObjectDelete($oChart1.Axes($xlValue))
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ObjectDelete!")

_XLChart_ObjectDelete($oChart1.Axes($xlCategory))
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ObjectDelete!")

; Remove Legend
_XLChart_ObjectDelete($oChart1.Legend)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ObjectDelete!")

; Change title to Arial, 24, bold, italic, red
_XLChart_FontSet($oChart1.ChartTitle, "Calibri", 20, True, True, False, 0xFF0000)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_FontSet!")

; Set the background color of chart 1 to gradient orange to white
_XLChart_FillSet($oChart1.ChartArea,  0xFFFFFF, 0xC8C8FF,Default, $msoGradientHorizontal, 1, Default)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_FillSet!")
; *****************************************************************************
; Create chart nr 2, transparently overlayed over chart 1
; *****************************************************************************
Local $oChart2 = _XLChart_ChartCreate($oExcel, 1, $xlSurfaceWireframe, "R5:W21", "Saddle2", "=Saddle!B3:J3", $DataRange, $DataName, True, "Saddle (by GreenCan)")
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ChartCreate!")

; bug Excel 2007, have to repeat charttype
_XLChart_ChartSet($oChart2, $xlSurfaceWireframe)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ChartSet!")

_XLChart_ObjectDelete($oChart2.Axes($xlCategory))
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ObjectDelete!")

; Remove Charttitle
_XLChart_ObjectDelete($oChart2.ChartTitle)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ObjectDelete!")

; Remove Legend
_XLChart_ObjectDelete($oChart2.Legend)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_ObjectDelete!")

; Set Border transparent
_XLChart_LineSet($oChart2.ChartArea, Default, Default, Default, Default, Default, $xlSheetHidden)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_LineSet!")

; Set chart area transparent
_XLChart_FillSet($oChart2.ChartArea, 0xCD0000, Default, Default, Default, Default, Default, 1)
If @error <> 0 Then Exit MsgBox(16, "Excel Chart Example Script", "Error " & @error & " returned by _XLChart_FillSet!")

; *****************************************************************************
; Now Demo rotation
; *****************************************************************************

$sCell = "B18"
_ExcelWriteCell($oExcel,  "Press Escape to quit", $sCell)
; set the font size
_ExcelFontSetSize($oExcel, "B18", 1, 1, 1, 14)
If @error Then MsgBox(64, "Excel Gauge Chart Example", "Error " & @error & " returned by function '_ExcelFontSetSize' on line " & @ScriptLineNumber)

; Now enable screen updating again so that we can see the result
_XLChart_ScreenUpdateSet($oExcel, 1)

HotKeySet("{ESC}", "Terminate")
Local $iRotation = 20
While 1
	$iRotation += 10
	If $iRotation = 370 Then $iRotation = 0
	ConsoleWrite( $iRotation & @CR)
	_XLChart_3D_PositionSet($oChart1, $iRotation, Default, Default)
WEnd

Func Terminate()
	_ExcelWriteCell($oExcel,  "", "B18")
	_XLChart_3D_PositionSet($oChart1, 20, Default, Default)
    Exit
EndFunc ;==>Terminate


#region ExcelCom udf extract (FOR THE PURPOSE OF THIS EXAMPLE ONLY)

; #FUNCTION# ====================================================================================================
; Function:		_ExcelBookOpenTxt
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
; #FUNCTION# ====================================================================================================
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

; #FUNCTION# ====================================================================================================
; Function:		_ExcelCellMerge
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
; #FUNCTION# ====================================================================================================
Func _ExcelCellMerge($oExcel, $fDoMerge, $sRangeOrRowStart, $iColStart = 1, $iRowEnd = 1, $iColEnd = 1)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $fDoMerge <> False and $fDoMerge <> True Then Return SetError(4, 0, 0)
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

; #FUNCTION# ====================================================================================================
; Function:		_ExcelCellColorSet
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
; #FUNCTION# ====================================================================================================
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

; #FUNCTION# ====================================================================================================
; Function:		_ExcelColWidthSet
; Description:      Set the column width of the specified column(s).
; Syntax:           _ExcelColWidthSet($oExcel, $vColumn, $vWidth)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$sColumn - A valid Excel column, either a number or an A1 string (i.e. 5, or "C" or a range "A:K")
;					$vWidth - The width of the column in points, or the string "autofit"
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
; #FUNCTION# ====================================================================================================
Func _ExcelColWidthSet($oExcel, $vColumn, $vWidth)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $vWidth = "autofit" Then
		$oExcel.Activesheet.Columns($vColumn).Autofit
	Else
		$oExcel.Activesheet.Columns($vColumn).ColumnWidth = $vWidth
	EndIf
	Return 1
EndFunc ;==>_ExcelColWidthSet

; #FUNCTION# ====================================================================================================
; Function:		_ExcelCreateBorders
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
; #FUNCTION# ====================================================================================================
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
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeTop = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlEdgeTop)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeBottom = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlEdgeBottom)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeRight = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlEdgeRight)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideV = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlInsideVertical)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideH = 1 Then
            With $oExcel.Activesheet.Range($oExcel.Cells($sRangeOrRowStart, $iColStart), $oExcel.Cells($iRowEnd, $iColEnd)).Borders($xlInsideHorizontal)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
    Else
        if $iEdgeLeft = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeLeft)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeTop = 1 Then
            with $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeTop)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeBottom = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeBottom)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeRight = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlEdgeRight)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideV = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlInsideVertical)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
        if $iEdgeInsideH = 1 Then
            With $oExcel.Activesheet.Range($sRangeOrRowStart).Borders($xlInsideHorizontal)
                .LineStyle = $xlContinuous
                .ColorIndex = $xlAutomatic
                ;.TintAndShade = 0
                .Weight = $sBorderStyle
            EndWith
        EndIf
    EndIf
    Return 1
EndFunc

; #FUNCTION# ====================================================================================================
; Function:		_ExcelFontSet
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
; #FUNCTION# ====================================================================================================
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

; #FUNCTION# ====================================================================================================
; Function:		_ExcelFontSetSize
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
; #FUNCTION# ====================================================================================================
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

; #FUNCTION# ====================================================================================================
; Function:		_ExcelFontSetColor
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
; #FUNCTION# ====================================================================================================
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

; #FUNCTION# ====================================================================================================
; Function:		_ExcelRowHeightSet
; Description:      Set the row height of the specified row(s).
; Syntax:           _ExcelRowHeightSet($oExcel, $sRow, $vHeight)
; Parameter(s):     $oExcel - An Excel object opened by a preceding call to _ExcelBookOpen() or _ExcelBookNew()
;					$iRow - The integer representation of a valid Excel row (i.e. 45 or a range "1:10")
;					$vHeight - The height of the row in points, or the string "autofit"
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        SEO <locodarwin at yahoo dot com>
; Note(s):          None
;
; #FUNCTION# ====================================================================================================
Func _ExcelRowHeightSet($oExcel, $iRow, $vHeight)
	If NOT IsObj($oExcel) Then Return SetError(1, 0, 0)
	If $vHeight = "autofit" Then
		$oExcel.Activesheet.Rows($iRow).Autofit
	Else
		$oExcel.Activesheet.Rows($iRow).RowHeight = $vHeight
	EndIf
EndFunc ;==>_ExcelRowHeightSet

; #FUNCTION# ====================================================================================================
; Function:		_ExcelVerticalAlignSet
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
; #FUNCTION# ====================================================================================================
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

#endregion