;ExcelCom.au3 		Version:	2_82;
; Version:			2_81;  Jan 31st ; fixed "CreatBlank" again!
; Version:			2_71;  Jan 11th change ame csvFile to csvFileView.cvs ; also chart type XLScatter now trendlines
;===============================================================================
; Requirement(s):   Windows XP SP2(?)/ Office 2003/ AutIt3 Beta latest (currently 87)[some may work with other office versions, but not all]
; Version:			Please note; this is provided "as is" and was only intended as a "stop-gap"
; Version:			It needs major re-writing, even from what I know, and errors are a problem; good luck!
; Revision			Oct 2005; 1_9_28; _XLGetActive (Returns ByRef or Array); -XLRead, _XLCalc [added $s_i_Visible] {** first Error Handler}
; Revision			Sept 29th 2005; More graph options; paste returns paste range now; blank improved?
; Instructions		;examples, update, http://www.autoitscript.com/forum/index.php?showtopic=14166&view=findpost&p=96727
; Description:      Various functions to communicate with Excel files via com
;					Turns off calculation to manual, and returns to auto/ manual which was preset if "Save" requested
;					Can display [/ or not] as it goes, save at end or not, and exit with /or without] save
;					Simple; Read, Add, Write("Into"), Run (macroRun) into a cell [or range (write only?)]
;					Complex; Write on a row (option column) a tab-delimited string (eg from text file)
;					Complex; Append after last row as option
; Syntax:           _ExcelCOM($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_MEExcelCom,$s_i_Save,$s_i_ExcelValue,$s_i_Visible,$s_i_Exit,$s_i_LastRow,$s_i_ToColumn)
; Syntax:           Short - see at end
; Parameter(s):     $s_FilePath - Path and filename of the excel file
;                   $s_i_Sheet - Worksheet number [or name]
;                   $s_i_Column -parameter allows column by letter(s) [or numbers], or range [then row is ignored]
;                   $i_Row - Row number
;                   $s_MEExcelCom - Type of action; Read, Add, Into, Run, Calc, Paste, Show, Ready, Close, Import
;                   $s_i_Save  - Saves after action  ["other"/"Save"] [0/1]
;								;[**NOTE - no worksheet update calculation occurs till save, unless also run "calc", whatever previous setting]
;                   $s_i_ExcelValue - Value to Insert;  dummy required otherwise [may be tab-delimited string
;								; [set $s_i_LastRow or $s_i_ToColumn if needed]
;                   $s_i_Visible - Set whether to show or not  [0/1 - or 0/"Visible"]
;                   $s_i_Exit - Set whether to Exit or not  [0/1 - or 0/"Exit"]
;                   $s_i_LastRow - Set whether to automatically select row after last as insertion row [0/1]- or 0/"LastRow"
;                   $s_i_ToColumn - Set whether to insert tab-delimited string as column (1) or not (otherwise)- or 0/"ToColumn"
; Requirement(s):   Windows XP SP2(?)/ Office 2003/ AutIt3 Beta after about 3.1.1.18 (currently 87)
; Return Value(s):  On Success - Returns value from index cell ]See  also some arrays, cell values for some short functions[
;					On Success - Returns "Lastrow" instead if $s_i_LastRow="LastRow"; use for row number to append for next command
;                   ** More to do; further swapping Error Handler}[On Failure - Returns 0 and sets @error = 1]
;                   ** More to do; Soon to come!!!; Now swaps Error handler already running and re-invokes it after each call to excelCom
;					;note - current ERROR still frequent is to try to open a worksheet already open [Use readOnly command first]
;					;note - current ERROR still frequent is to try to open a named worksheet which does not exist (FileOpenDialog opens)
;					;		(eg sheet2 , only 1 present)
; Author(s):        Randall  <randallc@ozemail.com.au>
; Related Functions: All short Syntax functions
; Short Options		Use short Syntax
;					_XLSearch($s_FilePath,$s_i_Sheet,$s_i_ExcelValue,$s_i_Visible)
;					_XLRead($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_i_Visible)
;					_XLWrite($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_i_ExcelValue,$s_i_Visible)		;If $s_TabString contains a tab, will write across row  using paste
;					_XLWriteCol($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_TabString,$s_i_Visible)		;If $s_TabString contains a tab, will write down column using paste
;					_XLAdd($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_i_ExcelValue,$s_i_Visible)			;format maintained, but will lose original value if not "General" value
;					_XLAddGeneral($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_i_ExcelValue,$s_i_Visible)	; will maintain value and add, and maintain format
;					_XLMacroRun($s_FilePath,$s_i_Sheet,$s_MacroName,$s_i_Visible)
;					_XLCalc($s_FilePath,$s_i_Visible,$s_i_Visible)
;					_XLSave($s_FilePath[,$s_i_Sheet],$s_i_Visible)
;					_XLClose($s_FilePath[,$s_i_Save],$s_i_Visible) 									; Default or "Save" [Saves changes and Closes workbook]["NOSave"); NO changes ; just Closes
;					_XLExit($s_FilePath[,$s_i_Save]) 								; Default or "Save" [Saves changes and exit Excel]["NOSave"); NO changes ; just exit Excel]
;					 $XLCopyRange=_XLCopy($s_cFilePath,$s_i_Sheet,$NamedRange,$s_i_Visible)      	; $XLCopyRange sets range to copy for "_XLCopyTo" to run
;					_XLCopyTo($FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$XLCopyRange,$s_i_Visible)    	; -PAIRED WITH _XLCopy ; uses "$XLCopyRange" for copying from range
;					_XLCsvPaste($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_i_Save,$csvPath,$s_i_Visible)	; gives flexible range rather than whole sheet to paste
;					_XLLastRow($s_FilePath,$s_i_Sheet,$s_i_Visible)
;					_XLPaste($s_FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_i_ExcelValue,$s_i_Save,$s_i_ToColumn,$s_i_Visible)
;					_XLShow($s_FilePath[,$s_i_Sheet,$s_i_Column,$i_Row])												;will show current sheet; needs messagebox to pause the show
;					_XLReady($s_FilePath,$s_i_Visible)													; return not significant; ensures Excel open , hidden
;					_XLSort($FilePath,$Column1,$Direction1,$Column2,$Direction2,$SortRange,$s_i_Visible)	; blank range gives "UsedRange"
;					_XLSaveAs($FilePath,$NewPath[,$FileType],$s_i_Visible)								; "csv"or "xls", or "txt" , or "csv"
;					 $WorkbookPropArray=_XLSheetProps($FilePath,$s_i_Visible)							; Returns all sheet Names and numbers to Array "$WorkbookPropArray"
;					_XLFormat($FilePath,$s_i_Sheet,$s_i_Column,$i_Row[,$CellFormat],$s_i_Visible)					; $CellFormat blank gives "General"; "A:A" for a column
;					 $s_XLArrayRange=_XLArrayWrite($XLArray,$FilePath,$s_i_Sheet,$s_i_Column,$i_Row,$s_i_Visible,$s_i_Transpose)	; returns the range used by the array
;					 $XLArray=_XLArrayRead($s_cFilePath,1,$s_XLArrayRange,$s_i_Visible)						; blank range gives "UsedRange"
;					_XLCreateBlank($FilePath)												;creates blank Execl sheet named "Blank.xls" in "@ScriptDir"
;					_XLRowToString($s_FilePath,$s_i_Sheet, $s_CopyRange,$Line,$s_i_Visible)
;					_WordCreateBlank($s_FilePath)
;					_WordClose($s_FilePath,$s_i_Save,$s_i_Exit)
;					_WordMacro($s_FilePath,$s_Macro,$s_WordValue)
;					_WordCOM($s_FilePath,$s_MEWordCom,$s_Macro,$s_WordValue,$s_i_Save,$s_i_Visible,$s_i_Exit)
;					_XLGetActive(ByRef $s_FilePath,ByRef $s_i_Sheet,ByRef $Address,ByRef $s_i_ExcelValue,ByRef $SheetsCount,ByRef $Name,ByRef $CurrentRange,ByRef $UsedRange,$s_i_Visible)
;					_XLFromListView(ByRef $s_FilePath,$h_Listview,$iListSelected=0,$s_i_Visible="NotVisible")
;					_SheetAdd(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "Sheet", $s_i_Visible = "NotVisible")
;					_GetSheetName(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "Sheet", $s_i_Visible = "NotVisible")
;					_NameSheet(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "Sheet", $s_i_Visible = "NotVisible")
;					_XLSheetProperties(ByRef $s_FilePath, $s_i_Visible = 0) ; to 2D array
;                   _XLSetColumnWidth(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $s_i_ColumnWidth, $s_i_Visible) ; $s_i_ColumnWidth can either be a number or "Autofit". For example: _XLSetColumnWidth($FilePath, 1, "A:J", "Autofit", 0)
;                   _XLShowColorCodes() ; Dont know the numbers for the color codes to set cell background color and font color? Simply call this function and it will lay them all out in an excel spreadsheet :)
;                   _XLSetCellFontName(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $s_FontName, $s_i_Visible) ; Set a cells font, ie _XLSetCellFontName($FilePath,1,"C",10,"Wingdings",0)
;                   _XLSetCellFontColor(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $i_FontColor, $s_i_Visible) ; _XLSetCellFontColor($FilePath,1,"C",10,5,0)           Note. '5' is the color code
;					_XLSetCellColor(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $i_FontColor, $s_i_Visible) ; Sets a cell's background color, use in the same way as _XLSetCellFontColor
;
;
;===============================================================================
;**************************************************FUNC follows *********************************
;global $LVS_EX_CHECKBOXES
;#include<GUIListView.au3>
#include-once
#include <GuiConstants.au3>
#include <GuiListView.au3>

Func _ExcelCOM(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $s_MEExcelCom = "Read", $s_i_Save = "Save", $s_i_ExcelValue = 1, $s_i_Visible = 0, $s_i_Exit = 0, $s_i_LastRow = 0, $s_i_ToColumn = 0)
	;Opt("WinTitleMatchMode", 3)
	Local $numtabs, $ColLettStart, $Range, $Col1, $ColNum1, $Col2, $ColNum2, $oExcel, $Calculate, $var
	Local $AddressExcel, $i_RowExcel, $Close, $oCSV, $oCopyFrom, $sFuncNameOrg, $sListview,  $a
	$Range = $s_i_Column & $i_Row
	;	Msgbox (0,$s_MEExcelCom&"1","IsString($s_i_Visible)=" & IsString($s_i_Visible)&@CRLF&"Number($s_i_Visible)=" & Number($s_i_Visible)&@CRLF&"$s_i_Visible=" & $s_i_Visible&@CRLF&"IsNumber($s_i_Visible)=" & IsNumber($s_i_Visible))
	;These lines handle non-zero string number values
	If IsString($s_i_Sheet) And Number($s_i_Sheet) <> 0 Then $s_i_Sheet = Number($s_i_Sheet)
	If IsString($s_i_Column) And Number($s_i_Column) <> 0 Then $s_i_Column = Number($s_i_Column)
	If IsString($s_i_Save) And Number($s_i_Save) <> 0 Then $s_i_Save = Number($s_i_Save)
	If IsString($s_i_Visible) And Number($s_i_Visible) <> 0 Then $s_i_Visible = Number($s_i_Visible)
	If IsString($s_i_Exit) And Number($s_i_Exit) <> 0 Then $s_i_Exit = Number($s_i_Exit)
	If IsString($s_i_LastRow) And Number($s_i_LastRow) <> 0 Then $s_i_LastRow = Number($s_i_LastRow)
	If IsString($s_i_ToColumn) And Number($s_i_ToColumn) <> 0 Then $s_i_ToColumn = Number($s_i_ToColumn)
	;		Msgbox (0,$s_MEExcelCom&"2","IsString($s_i_Visible)=" & IsString($s_i_Visible)&@CRLF&"Number($s_i_Visible)=" & Number($s_i_Visible)&@CRLF&"$s_i_Visible=" & $s_i_Visible&@CRLF&"IsNumber($s_i_Visible)=" & IsNumber($s_i_Visible))
	;These lines handle string values not values
	If $s_i_Save = "Save" And IsString($s_i_Save) Then $s_i_Save = 1
	If IsString($s_i_Save) Then $s_i_Save = 0
	;=================================================
	If $s_i_Visible = "Visible" And IsString($s_i_Visible) Then $s_i_Visible = 1
	If IsString($s_i_Visible) Then $s_i_Visible = 0
	;=================================================
	If $s_i_Exit = "Exit" And IsString($s_i_Exit) Then $s_i_Exit = 1
	If IsString($s_i_Exit) Then $s_i_Exit = 0
	;=================================================
	If $s_i_LastRow = "LastRow" And IsString($s_i_LastRow) Then $s_i_LastRow = 1
	If IsString($s_i_LastRow) Then $s_i_LastRow = 0
	;=================================================
	If $s_i_ToColumn = "ToColumn" And IsString($s_i_ToColumn) Then $s_i_ToColumn = 1
	If IsString($s_i_ToColumn) Then $s_i_ToColumn = 0
	;=================================================
	;if $s_i_Save="Save" and IsString($s_i_Save) then $s_i_Save=1
	;if $s_i_Visible="Visible" and IsString($s_i_Visible) then $s_i_Visible=1
	;if $s_i_Exit="Exit" and IsString($s_i_Exit) then $s_i_Exit=1
	;if $s_i_LastRow="LastRow" and IsString($s_i_LastRow) then $s_i_LastRow=1
	;if $s_i_ToColumn="ToColumn" and IsString($s_i_ToColumn) then $s_i_ToColumn=1
	;Msgbox (0,$s_MEExcelCom&"3","IsString($s_i_Save)=" & IsString($s_i_Save)&@CRLF&"Number($s_i_Save)=" & Number($s_i_Save)&@CRLF&"$s_i_Save=" & $s_i_Visible&@CRLF&"IsNumber($s_i_Save)=" & IsNumber($s_i_Save))
	;==================================================if all numbers
	If StringIsDigit($s_i_Column) Then
		If $s_i_Column <= 26 Then
			$ColLettStart = Chr($s_i_Column + 64)
		Else
			$ColLettStart = Chr(Int($s_i_Column / 26) + 64) & Chr(Mod($s_i_Column, 26) + 64)
		EndIf
		$s_i_Column = $ColLettStart
		$Range = $s_i_Column & $i_Row
		;==================================================if all numbers
	Else
		;==================================================if some  numbers
		If StringRegExp($s_i_Column, "[0-9]", 0) Then
			$Range = $s_i_Column
			$ColLettStart = StringRegExpReplace($s_i_Column, "[0-9]", "", 0)
		Else
			;==================================================if no  numbersand string length too long
			If StringLen($s_i_Column) > 2 Then $Range = $s_i_Column
		EndIf
		$Col1 = StringLeft($s_i_Column, 1)
		$ColNum1= (Asc($Col1) - 64)
		If StringLen($s_i_Column) > 1 Then
			$Col2 = StringMid($s_i_Column, 2, 1)
			$ColNum2= (Asc($Col1) - 64)
			$ColNum1 = 26 * $ColNum1 + $ColNum2
		EndIf
		$ColLettStart = $ColNum1
	EndIf
	;==================================================
	;If $s_i_Sheet < 1 Then $s_i_Sheet = 1
	If $s_i_Visible <> 1 Then $s_i_Visible = 0
	If Not FileExists($s_FilePath) Or (Not StringInStr($s_FilePath, ".csv") And Not StringInStr($s_FilePath, ".xl") And Not StringInStr($s_FilePath, ".txt")) Then
		;msgbox (0,"$s_FilePath=",$s_FilePath)
		_XLCreateBlank($s_FilePath)
		;$s_FilePath = FileOpenDialog("[ExcelCom] ; Go", $s_FilePath, "Worksheet" & " (" & "*.xl*;*.csv;*.txt" & ")", 1);+ $Recurse+ $Recurse
	EndIf
	If Not IsObj ($oExcel) Then
		$oExcel = ObjGet ($s_FilePath) ; Get an Excel Object from an existing filename
	EndIf
	If IsObj ($oExcel) Then
		If $s_i_Sheet > $oExcel.Worksheets.count Then $s_i_Sheet = $oExcel.Worksheets.count
		With $oExcel
			.Windows (1).Visible = 1; Set the first worksheet in the workbook visible
			If $s_i_Sheet = "ActiveSheet" Then $s_i_Sheet = .ActiveSheet.Name
			;MsgBox(0,"","$s_i_Sheet="&$s_i_Sheet)
			.Worksheets ($s_i_Sheet).Activate
			.ActiveSheet.Visible = 1
			.Application.Visible = $s_i_Visible
			$xlCalculationManual = -4135
			$xlCalculationAutomatic = -4105
			$Calculation = .Application.Calculation
			.Application.Calculation = $xlCalculationManual
			$i_RowExcel = $i_Row
			;MsgBox(0,"","$s_i_ToColumn="&$s_i_ToColumn)
			if (StringInStr($s_i_ExcelValue, @TAB) And StringInStr($s_MEExcelCom, "Into") And StringInStr($Range, ":")) Or $s_i_ToColumn <> 0 And Not StringInStr($s_MEExcelCom, "Paste") Then
				$ExcelValueArr = StringSplit($s_i_ExcelValue, @TAB)
				If $s_i_ToColumn = 0 Then
					$MaxNum = 256
				Else
					$MaxNum = 63536
				EndIf
				If $s_i_ToColumn = 0 Then
					If $ExcelValueArr[0]> (1 + $MaxNum - $ColLettStart) Then $ExcelValueArr[0] = 1 + $MaxNum - $ColLettStart
					$ColLettEndValue = $ColLettStart + $ExcelValueArr[0]
					If $ColLettEndValue <= 26 Then
						$ColLettEnd = Chr($ColLettEndValue + 64)
					Else
						$FirstIntVal = Int(($ColLettEndValue) / 26)
						$DivBy26 = Mod($ColLettEndValue, 26) = 0
						$FirstIntVal = $FirstIntVal
						$SecondVal= ($ColLettEndValue - $FirstIntVal * 26) + 26 * $DivBy26
						$ColLettEnd = Chr($FirstIntVal - $DivBy26 + 64) & Chr($SecondVal + 64)
					EndIf
					$Range = $Range & ":" & $ColLettEnd & $i_RowExcel
				Else
					If $ExcelValueArr[0]> (1 + $MaxNum - $i_RowExcel) Then $ExcelValueArr[0] = 1 + $MaxNum - $i_RowExcel
					$Range = $Range & ":" & $s_i_Column& ($i_RowExcel + $ExcelValueArr[0])
				EndIf
				$numtabs = $ExcelValueArr[0]
				For $j = 0 To $numtabs - 1
					$ExcelValueArr[$j] = $ExcelValueArr[$j + 1]
				Next
			EndIf
			Select
				Case StringInStr($s_MEExcelCom, "ArrayWrite")
					If $s_i_LastRow = 1 Then _ArrayTranspose2D($s_i_ExcelValue)
					.activesheet.range ($Range).Activate
					.Application.ActiveCell.Offset (UBound($s_i_ExcelValue, 2) - 1, UBound($s_i_ExcelValue, 1) - 1).Activate
					$EndRange = .Application.activecell.address
					$EndRange = StringReplace($EndRange, "$", "")
					$var = $Range & ":" & $EndRange
					.activesheet.range ($var).select
					.activesheet.range ($var).value = $s_i_ExcelValue; Write the data back in one shot
				Case StringInStr($s_MEExcelCom, "ArrayRead")
					If $s_i_ExcelValue <> "" And $s_i_ExcelValue <> "UsedRange" Then
						$var = .activesheet.range ($s_i_ExcelValue).value    ; Retrieve the cell values from given range
					Else
						$var = .activesheet.UsedRange.value    ; Retrieve the cell values from given range
					EndIf
				Case StringInStr($s_MEExcelCom, "Search")
					Local $s_FirstAddress, $s_FoundObject
					;.Worksheets($s_i_Sheet).UsedRange
					$s_FoundList = "Nothing"
					$s_FoundObject = .Worksheets ($s_i_Sheet).UsedRange.Find ($s_i_ExcelValue)
					If isobj ($s_FoundObject) Then
						$s_FoundList = $s_FoundObject.Address
						$s_FirstAddress = $s_FoundObject.Address
						While 1
							$s_FoundObject = .Worksheets ($s_i_Sheet).UsedRange.FindNext ($s_FoundObject)
							If Not isobj ($s_FoundObject) Then ExitLoop
							If $s_FoundObject.Address = $s_FirstAddress Then ExitLoop
							$s_FoundList = $s_FoundList & "|" & $s_FoundObject.Address
						WEnd
					EndIf
					$var = $s_FoundList
					
				Case StringInStr($s_MEExcelCom, "Into")
					If $s_i_ToColumn <> 0 Then
						For $j = 0 To $numtabs - 1
							$Range = $s_i_Column& ($i_RowExcel + $j)
							.activesheet.range ($Range).value = $ExcelValueArr[$j]; Fill cell  numbers
						Next
					Else
						.activesheet.range ($Range).value = $s_i_ExcelValue  ; Fill cell  numbers +0
					EndIf
					$var = .activesheet.range ($Range).value
				Case StringInStr($s_MEExcelCom, "Paste")
					While 1
						If not (ClipGet() == "") Then
							ExitLoop
						Else
							$a = $a + 1
							If $a > 50 Then MsgBox(0, "", "in Paste  inside")
						EndIf
						Sleep(50)
					WEnd
					.activesheet.range ($Range).select
					.activesheet.paste ;(.range ($Range))
					$var = .Application.ActiveWindow.RangeSelection.Address
					$var = StringReplace($var, "$", "")
				Case StringInStr($s_MEExcelCom, "Show")
					.activesheet.range ($Range).select
					;MsgBox(0,"","$s_i_ExcelValue="&$s_i_ExcelValue)
					If $s_i_ExcelValue = 1 Or StringInStr($s_i_ExcelValue, "Chart") Then .Sheets ("Chart1").Select
				Case StringInStr($s_MEExcelCom, "Add1")
					$var = .activesheet.range ($Range).value
					.activesheet.range ($Range).value = Number($s_i_ExcelValue) + $var ; Fill cell  numbers
					$var = .activesheet.range ($Range).value
				Case StringInStr($s_MEExcelCom, "Add2")
					$selc = .activesheet.range ($Range).NumberFormat
					;.activesheet.range ($Range).Select
					;.Application.Selection.NumberFormat = "General"
					.activesheet.range ($Range).NumberFormat = "General"
					$var = .activesheet.range ($Range).value
					.activesheet.range ($Range).value = Number($s_i_ExcelValue) + $var ; Fill cell  numbers
					;.activesheet.range ($Range).Select
					;.Application.Selection.NumberFormat = $selc
					.activesheet.range ($Range).NumberFormat = $selc
					$var = .activesheet.range ($Range).value
				Case StringInStr($s_MEExcelCom, "Format")
					$selc = .activesheet.range ($Range).NumberFormat
					;.activesheet.range ($Range).Select
					;.Application.Selection.NumberFormat = "General"
					.activesheet.range ($Range).NumberFormat = "General"
					$FormatString = "General|yyyy/mm/dd;@|mm/dd/yyyy;@|dd/mm/yyyyy;@|0.00|$#,##0.00|[$-F800]dddd, mmmm dd, yyyy"
					$FormatString = $FormatString & "#,##0.00_ ;[Red]-#,##0.00 |$###0.00;-$###0.00|# ?/?|$#,##0.00_);[Red]($#,##0.00)|[$-C09]d mmmm yyyy;@"
					$FormatString = $FormatString & "[$-409]h:mm:ss AM/PM;@|0.00%|@"
					If StringInStr($FormatString, $s_i_ExcelValue, "") Then
						;.activesheet.range ($Range).Select
						;.Application.Selection.NumberFormat = $s_i_ExcelValue
						.activesheet.range ($Range).NumberFormat = $s_i_ExcelValue
					EndIf
					$selc2 = .activesheet.range ($Range).NumberFormat
					;MsgBox(0,"","$selc2="&$selc2)
				Case StringInStr($s_MEExcelCom, "Read")
					$var = .activesheet.range ($Range).value
				Case StringInStr($s_MEExcelCom, "SheetAdd")
					.Sheets.add
					$var = .ActiveSheet.Name
				Case StringInStr($s_MEExcelCom, "GetSheetName")
					$var = .ActiveSheet.Name
				Case StringInStr($s_MEExcelCom, "NameSheet")
					;MsgBox(0,"","$s_i_ExcelValue="&$s_i_ExcelValue)
					_NewSheetName($s_i_ExcelValue, $oExcel)
					.ActiveSheet.Name = $s_i_ExcelValue
					$var = .ActiveSheet.Name
				Case StringInStr($s_MEExcelCom, "Props")
					$BooksCount = .Application.Workbooks.count
					$var = "Number Workbooks=" & $BooksCount & "|"
					For $j = 1 To $BooksCount
						$SheetsCount = .Application.Workbooks ($j).Worksheets.count
						For $i = 1 To $SheetsCount
							$var = $var & " " & .Application.Workbooks ($j).Name & " " & .Application.Workbooks ($j).Sheets ($i).Name
							If not ($i = $SheetsCount And $j = $BooksCount) Then $var = $var & "|"
						Next
					Next
					$varsplit = StringSplit($var, "|")
				Case StringInStr($s_MEExcelCom, "Properties")
					$BooksCount = .Application.Workbooks.count
					;$var = "Number Workbooks=" & $BooksCount & "|"
					Dim $var[$BooksCount + 1][2], $j = 0, $i = 0
					$var[0][0] = "    Sheet"
					For $s_Workbook In .Application.Workbooks
						$j = $j + 1
						$var[$j][0] = "    " & $s_Workbook.Name
						$SheetsCount = $s_Workbook.Worksheets.count
						If UBound($var, 2) < $SheetsCount + 1 Then ReDim $var[$BooksCount + 1][$SheetsCount + 1]
						For $s_WorkSheet In $s_Workbook.Worksheets
							$i = $i + 1
							$var[0][$i] = StringRight("    " & $i, 4)
							$var[$j][$i] = $s_WorkSheet.Name
						Next
						$i = 0
					Next
				Case StringInStr($s_MEExcelCom, "Run")
					.Application.Run ($s_i_ExcelValue)  ;"Normal.NewMacros.Font4"
				Case StringInStr($s_MEExcelCom, "Ready")
					$var = .Application.Ready
				Case StringInStr($s_MEExcelCom, "Calc")
					.Application.Calculation = $xlCalculationAutomatic
				Case StringInStr($s_MEExcelCom, "Close")
					$Close = 1
				Case StringInStr($s_MEExcelCom, "SaveAs")
					If $i_Row = "xls" Then $i_Row = -4143
					If $i_Row = "csv" Then $i_Row = 24
					If $i_Row = "txt" Then $i_Row = 20
					.Application.DisplayAlerts = 0
					.Application.ScreenUpdating = 0
					If FileExists($s_i_ExcelValue) Then
						FileDelete($s_i_ExcelValue)
					EndIf
					.SaveAs ($s_i_ExcelValue, $i_Row)
					.Application.DisplayAlerts = 1
					.Application.ScreenUpdating = 1
				Case StringInStr($s_MEExcelCom, "Import")
					If Not FileExists($s_i_ExcelValue) Or (Not StringInStr($s_i_ExcelValue, ".csv") And Not StringInStr($s_i_ExcelValue, ".xl") And Not StringInStr($s_i_ExcelValue, ".txt")) Then
						$s_i_ExcelValue = FileOpenDialog("[Import] Go - Choose your input file as inbuilt one not exists", @ScriptDir, "Comma /XL* Files" & " (" & "*.csv;*.xl*;*.txt" & ")", 1);+ $Recurse+ $Recurse
					EndIf
					$oCSV = ObjGet ($s_i_ExcelValue) ; Get an Excel Object from an existing filename
					$oCSV.Application.Visible = $s_i_Visible
					$oCSV.Windows (1).Visible = 1; Set the first worksheet in the workbook visible			;msgbox(0,"",$s_FilePath&@CRLF
					ClipPut("")
					$oCSV.activesheet.UsedRange.Copy
					.Windows (1).Visible = 1; Set the first worksheet in the workbook visible			;msgbox(0,"",$s_FilePath&@CRLF
					.Worksheets ($s_i_Sheet).Activate
					.activesheet.range ($Range).select
					;Do not proceed until the clipboard is no longer 1
					While 1
						If not (ClipGet() == "") Then
							ExitLoop
						Else
							$a = $a + 1
							If $a > 50 Then MsgBox(0, "", "in Import")
						EndIf
						Sleep(50)
					WEnd
					.activesheet.paste
					;ClipPut("")
					$var = .Application.ActiveWindow.RangeSelection.Address
					$var = StringReplace($var, "$", "")
					$oCSV.Application.DisplayAlerts = 0
					;$oCSV.Application.ScreenUpdating = 0
					$oCSV.close (0)
					;$oCSV.Application.DisplayAlerts = 1
					;$oCSV.Application.ScreenUpdating = 1
				Case StringInStr($s_MEExcelCom, "CopyTo")
					;MsgBox(0,"","$s_MEExcelCom"&$s_MEExcelCom)
					$ExcelValuePass = StringSplit($s_i_ExcelValue, "|")
					$CopyFile = $ExcelValuePass[1]
					$CopySheet = $ExcelValuePass[2]
					$s_CopyRange = $ExcelValuePass[3]
					If Not FileExists($CopyFile) Or (Not StringInStr($CopyFile, ".csv") And Not StringInStr($CopyFile, ".xl")) And Not StringInStr($s_i_ExcelValue, ".txt") Then
						$CopyFile = FileOpenDialog("[CopyTo] Go - Choose your input file as inbuilt one not exists", @ScriptDir, "Comma /XL* Files" & " (" & "*.csv;*.xl*;*.txt" & ")", 1);+ $Recurse+ $Recurse
					EndIf
					$oCopyFrom = ObjGet ($CopyFile) ; Get an Excel Object from an existing filename
					$oCopyFrom.Windows (1).Visible = 1; Set the first worksheet in the workbook visible			;msgbox(0,"",$s_FilePath&@CRLF
					$oCopyFrom.Application.Visible = $s_i_Visible
					ClipPut("")
					If $s_CopyRange <> "" And $s_CopyRange <> "UsedRange" Then
						$oCopyFrom.activesheet.range ($s_CopyRange).copy
					Else
						$oCopyFrom.activesheet.UsedRange.copy
					EndIf
					.Windows (1).Visible = 1; Set the first worksheet in the workbook visible			;msgbox(0,"",$s_FilePath&@CRLF
					.Worksheets ($s_i_Sheet).Activate
					.activesheet.range ($Range).select
					While 1
						If not (ClipGet() == "") Then
							ExitLoop
						Else
							$a = $a + 1
							If $a > 50 Then MsgBox(0, "", "in CopyTo")
						EndIf
						Sleep(50)
					WEnd
					.activesheet.paste
					;ClipPut("")
					$var = .Application.ActiveWindow.RangeSelection.Address
					$var = StringReplace($var, "$", "")
				Case StringInStr($s_MEExcelCom, "Copy")
					ClipPut("")
					If $s_i_ExcelValue <> "" And $s_i_ExcelValue <> "UsedRange" Then
						$var = $s_i_ExcelValue
					Else
						$var = "UsedRange"
					EndIf
					$var = $s_FilePath & "|" & $s_i_Sheet & "|" & $var
				Case StringInStr($s_MEExcelCom, "SetColWidth")
					If $s_i_ExcelValue = "Autofit" Then
						.Application.Columns ($s_i_Column).Autofit
					Else
						.Application.Columns ($s_i_Column).ColumnWidth = $s_i_ExcelValue
					EndIf
				Case StringInStr($s_MEExcelCom, "SetCellFontName")
					If $s_i_ExcelValue <> "" Then
						.Application.Cells ($i_Row, $s_i_Column).Font.Name = $s_i_ExcelValue
					EndIf
				Case StringInStr($s_MEExcelCom, "SetCellFontColor")
					If IsInt($s_i_ExcelValue) = 1 Then
						.Application.Cells ($i_Row, $s_i_Column).Font.ColorIndex = $s_i_ExcelValue
					EndIf
				Case StringInStr($s_MEExcelCom, "SetCellColor")
					If IsInt($s_i_ExcelValue) = 1 Then
						.Application.Cells ($i_Row, $s_i_Column).Interior.ColorIndex = $s_i_ExcelValue
					EndIf
			EndSelect
			If $s_i_Save == "Save" Or $s_i_Save = 1 Then
				.Application.Calculation = $Calculation
				.Save
			EndIf
			.Application.Visible = $s_i_Visible; Set the application invisible (without this Excel will exit)
			If $Close = 1 And $s_i_Exit = 0 Then
				.saved = 1
				.close
			EndIf
			If $s_i_Exit = 1 Then
				;.saved=1
				.Application.Quit
				While ProcessExists('excel.exe')
					Sleep(10)
				WEnd
			EndIf
			If IsObj ($oCopyFrom) Then
				$oCopyFrom.Application.DisplayAlerts = 0
				;$oCopyFrom.Application.ScreenUpdating = 0
				$oCopyFrom.close (0)
				;$oCopyFrom.Application.DisplayAlerts = 1
				;$oCopyFrom.Application.ScreenUpdating = 1
			EndIf
			If $s_i_LastRow = 1 Then
				.Application.Selection.SpecialCells (11).Select;$xlCellTypeLastCell=11
				.Application.Visible = $s_i_Visible
				$AddressExcel = .Application.activecell.address ;;= $s_i_ExcelValue
				$AddressExcel = StringReplace($AddressExcel, "$", "")
				$i_RowExcel = StringRight($AddressExcel, StringLen($AddressExcel) - 1)
				While StringRegExp($i_RowExcel, "[A-Z]", 0)
					$i_RowExcel = StringRight($i_RowExcel, StringLen($i_RowExcel) - 1)
				WEnd
				$i_RowExcel = $i_RowExcel + 1
			EndIf
		EndWith
		;-----------------------------------------------------------------------------------------------------------------
		If $s_MEExcelCom = "FromList" Then
			$Fso = ObjCreate ( "Scripting.FileSystemObject")
			$sListview = $s_i_ExcelValue
			$iListSelected = $s_i_LastRow
			$oXLDummy = ObjCreate ("Excel.Application")
			_XLClose($s_FilePath, 0, 0)
			$CsvFileView = @ScriptDir & "\" & "ListView.csv"
			If Not WinExists("Microsoft Excel") Then
				$oXLDummy = ObjCreate ("Excel.Application")
			EndIf
			If FileExists($CsvFileView) Then
				_XLClose($CsvFileView, 0, 0)
				FileDelete($CsvFileView)
			EndIf
			If $iListSelected = 1 Then
				Local $a_indices = _GUICtrlListViewGetSelectedIndices ($sListview, 1)
				If (IsArray($a_indices)) Then
					Local $i
					;$sFile = $Fso.BuildPath( $Fso.GetSpecialFolder(2).Path, $Txtfile )
					$f = $Fso.CreateTextFile ($CsvFileView, 1, 1)
					;$f = FileOpen( $CsvFileView, 1)
					For $i = 1 To $a_indices[0]
						$ExcelLine = StringReplace(_GUICtrlListViewGetItemText ($sListview, $a_indices[$i]), "|", @TAB)
						$f.WriteLine ($ExcelLine)
						;FileWriteLine( $f,$ExcelLine)
					Next
					$f.Close ();
					;FileClose( $f );
				Else
					$f = $Fso.CreateTextFile ($CsvFileView, 1, 1)
					;$f = FileOpen( $CsvFileView, 1)
					For $i = 0 To _GUICtrlListViewGetItemCount ($sListview) - 1
						$ExcelLine = StringReplace(_GUICtrlListViewGetItemText ($sListview, $i), "|", @TAB)
						$f.WriteLine ($ExcelLine)
						;FileWriteLine( $f,$ExcelLine)
					Next
					$f.Close ();
					;FileClose( $f );
					;GUICtrlSetData($Status, "No Items Selected")
				EndIf
			Else
				$f = $Fso.CreateTextFile ($CsvFileView, 1, 1)
				;$f = FileOpen( $CsvFileView, 1)
				For $i = 0 To _GUICtrlListViewGetItemCount ($sListview) - 1
					$ExcelLine = StringReplace(_GUICtrlListViewGetItemText ($sListview, $i), "|", @TAB)
					$f.WriteLine ($ExcelLine)
					;FileWriteLine( $f,$ExcelLine)
				Next
				$f.Close ();
				;FileClose( $f );
			EndIf
			_XLSaveAs($CsvFileView, $s_FilePath, "xls", $s_i_Visible)
			If $s_i_Visible = 1 And WinExists("Microsoft Excel") Then
				$WinGetTitle = WinGetTitle("Microsoft Excel")
				WinActivate($WinGetTitle)
			EndIf
		EndIf
		;-----------------------------------------------------------------------------------------------------------------
		If $s_MEExcelCom = "Chart" Then
			$ExcelValuePass = StringSplit($s_i_ExcelValue, "|")
			$ChartType = $ExcelValuePass[1]
			$PlotBy = $ExcelValuePass[2]
			$Title = $ExcelValuePass[3]
			$Xaxis = $ExcelValuePass[4]
			$Yaxis = $ExcelValuePass[5]
			$Zdata = $ExcelValuePass[6]
			$SortRange = $ExcelValuePass[7]
			If $s_i_Sheet < 1 Then	$s_i_Sheet = '"' & $s_i_Sheet & '"'
			If IsObj ($oExcel) Then
				$oExcel.close (0)
			EndIf
			If $SortRange <> "" And $SortRange <> "UsedRange" Then
				$SortRange = "Range(" & '"' & $SortRange & '"' & ")"
			Else
				$SortRange = "UsedRange"
			EndIf
			$code = "Sub XLChart(FilePath, ChartType, PlotBy,Columns2,Direction2)"
			$code = $code & @CRLF & "Dim oXL"
			$code = $code & @CRLF & "Set oXL = GetObject(FilePath)"
			$code = $code & @CRLF & "oXL.Windows (1).Visible = 1"
			$code = $code & @CRLF & "oXL.Worksheets (" & $s_i_Sheet & ").Activate"
			$code = $code & @CRLF & "oXL.ActiveSheet.Visible = 1"
			$code = $code & @CRLF & "oXL.Application.Visible = 0"
			$code = $code & @CRLF & "oXL.Charts.add"
			$code = $code & @CRLF & "oXL.ActiveChart.ChartType = ChartType"
			$code = $code & @CRLF & "oXL.ActiveChart.SetSourceData oXL.Worksheets (1)." & $SortRange & ", PlotBy"
			$code = $code & @CRLF & "oXL.ActiveChart.Location 1"
			$code = $code & @CRLF & "With oXL.ActiveChart"
			$code = $code & @CRLF & ".HasTitle = 1"
			$code = $code & @CRLF & ".ChartTitle.Characters.Text = " & '"' & $Title & '"'
			$XaxisExclusions = StringSplit("2,-4099,5,-4102,70,69,68,-4111,71,9,-4132", ",")
			$X1axis = "Yes"
			For $Element In $XaxisExclusions
				If $ChartType = $Element Then $X1axis = "No"
			Next
			If $X1axis = "Yes" Then
				$code = $code & @CRLF & ".Axes(1,1).HasTitle = 1"
				$code = $code & @CRLF & ".Axes(1,1).AxisTitle.Characters.Text = " & '"' & $Xaxis & '"'
			EndIf
			$YaxisInclusions = StringSplit("-4101,-4100,-4098", ",")
			$Y1axis = "No"
			For $Element In $YaxisInclusions
				If $ChartType = $Element Then $Y1axis = "Yes"
			Next
			If $Y1axis = "Yes" Then
				$code = $code & @CRLF & ".Axes(3,1).HasTitle = 1"
				$code = $code & @CRLF & ".Axes(3,1).AxisTitle.Characters.Text = " & '"' & $Yaxis & '"'
			EndIf
			$code = $code & @CRLF & "if ChartType=-4101 then"
			$code = $code & @CRLF & ".Axes(2,1).HasTitle = 1"
			$code = $code & @CRLF & ".Axes(2,1).AxisTitle.Characters.Text = " & '"' & $Zdata & '"'
			$code = $code & @CRLF & ".HasDataTable = 1"
			$code = $code & @CRLF & ".DataTable.ShowLegendKey = 1"
			$code = $code & @CRLF & "end if"
			$code = $code & @CRLF & "if ChartType=74 then"
			$code = $code & @CRLF & ".Axes(2,1).HasTitle = 1"
			$code = $code & @CRLF & ".Axes(2,1).AxisTitle.Characters.Text = " & '"' & $Yaxis & '"'
			$code = $code & @CRLF & ".SeriesCollection(1).Name = " & '"' & $Zdata & '"'
			$code = $code & @CRLF & "end if"
			$code = $code & @CRLF & "End with"
			If $ChartType = 74 Then
				$code = $code & @CRLF & "oXL.ActiveChart.SeriesCollection(1).Select"
				$code = $code & @CRLF & "oXL.ActiveChart.SeriesCollection(1).Trendlines.Add(2).Select"
				$code = $code & @CRLF & "oXL.ActiveChart.SeriesCollection(1).Trendlines.Add(3,3).Select"
				$code = $code & @CRLF & "With oXL.Application.Selection.Border"
				$code = $code & @CRLF & ".ColorIndex = 3";red
				$code = $code & @CRLF & ".Weight = -4138"  ;'XLMedium
				$code = $code & @CRLF & ".LineStyle = 1"   ;'xlContinuous
				$code = $code & @CRLF & "End With"
			EndIf
			
			;$code=$code & @CRLF & "oXL.save"
			$code = $code & @CRLF & "End Sub"
			$vbs = ObjCreate ("ScriptControl")
			$vbs.language = "vbscript"
			;msgbox(0,"",$code)
			$vbs.addcode ($code)
			$retour = $vbs.run ("XLChart", $s_FilePath, $ChartType, $PlotBy, $ChartType, $PlotBy)
		EndIf
		;-----------------------------------------------------------------------------------------------------------------
		If $s_MEExcelCom = "Sort" Then
			$ExcelValuePass = StringSplit($s_i_ExcelValue, "|")
			$Columns1 = $ExcelValuePass[1]
			$Direction1 = $ExcelValuePass[2]
			$Columns2 = $ExcelValuePass[3]
			$Direction2 = $ExcelValuePass[4]
			$SortRange = $ExcelValuePass[5]
			If $s_i_Sheet < 1 Then	$s_i_Sheet = '"' & $s_i_Sheet & '"'
			If IsObj ($oExcel) Then
				$oExcel.close (0)
			EndIf
			$xlAscending = 1
			$xlDescending = 2
			$xlGuess = 0
			$xlTopToBottom = 1
			If $SortRange <> "" And $SortRange <> "UsedRange" Then
				$SortRange = "Range(" & '"' & $SortRange & '"' & ")"
			Else
				$SortRange = "UsedRange"
			EndIf
			$code = "Sub XLSort(FilePath, Columns1, Direction1,Columns2,Direction2)"
			$code = $code & @CRLF & "Dim oXL"
			$code = $code & @CRLF & "Set oXL = GetObject(FilePath)"
			$code = $code & @CRLF & "With oXL"
			$code = $code & @CRLF & ".Windows (1).Visible = 1"
			$code = $code & @CRLF & ".Worksheets (" & $s_i_Sheet & ").Activate"
			$code = $code & @CRLF & ".ActiveSheet.Visible = 1"
			$code = $code & @CRLF & ".Application.Visible = " & $s_i_Visible
			$code = $code & @CRLF & "Set objRange1 =.ActiveSheet.Range(Columns1)"
			$code = $code & @CRLF & "Set objRange2 =.ActiveSheet.Range(Columns2)"
			$code = $code & @CRLF & ".ActiveSheet." & $SortRange & ".Select"
			$code = $code & @CRLF & ".Application.Selection.Sort objrange1, Direction1,objRange2,,Direction2,,,2,2,False,,1"
			$code = $code & @CRLF & ".save"
			$code = $code & @CRLF & "End with"
			$code = $code & @CRLF & "End Sub"
			$vbs = ObjCreate ("ScriptControl")
			$vbs.language = "vbscript"
			$vbs.addcode ($code)
			$retour = $vbs.run ("XLSort", $s_FilePath, $Columns1, $Direction1, $Columns2, $Direction2)
		EndIf
	Else
		MsgBox(0, "Excel File Test", "Error: Could not open " & $s_FilePath & " as an Excel Object.")
	EndIf
	If $s_i_LastRow = 1 Then
		Return $i_RowExcel
	Else
		If $s_MEExcelCom = "Props" Then
			Return $varsplit
		Else
			Return $var
		EndIf
	EndIf
EndFunc   ;==>_ExcelCOM
Func _XLSearch($s_FilePath, $s_i_Sheet, $s_i_ExcelValue, $s_i_Visible)
	Return _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "Search", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
EndFunc   ;==>_XLSearch
Func _XLGetActive(ByRef $s_FilePath, ByRef $s_i_Sheet, ByRef $Address, ByRef $s_i_ExcelValue, ByRef $SheetsCount, ByRef $Name, ByRef $CurrentRange, ByRef $UsedRange, $s_i_Visible = 0)
	$oExcel = ObjGet ("", "Excel.Application")
	If IsObj ($oExcel) Then $WorkbooksCount = $oExcel.Application.Workbooks.count
	;Msgbox(0,"","$WorkbooksCount"&"$s_FilePath="&$s_FilePath&"$WorkbooksCount="&$WorkbooksCount)
	If IsObj ($oExcel) And $WorkbooksCount > 0 Then
		$s_FilePath = $oExcel.Application.ActiveWorkBook.fullname
		;EndIf
	Else
		;If not WinExists("Microsoft Excel") Then
		$s_FilePath = @ScriptDir & "\Blank.xls"
		_XLCreateBlank($s_FilePath)
		_XLRead($s_FilePath)
	EndIf
	;_XLExit($s_FilePath)
	$ssFilePath = $s_FilePath
	;$oExcel=""
	$oExcel = ObjGet ("", "Excel.Application")
	If Not IsObj ($oExcel) Then MsgBox(0, "", "what - no Excel!")
	$oExcel (1).Visible = 1; Set the first worksheet in the workbook visible
	$BooksCount = $oExcel.Application.Workbooks.count
	If $BooksCount = 0 Then $oExcel.Application.Workbooks.add
	$BooksCount = $oExcel.Application.Workbooks.count
	$oExcel.Application.ActiveWorkBook.Sheets.add
	$MyExtraSheet = $oExcel.ActiveWorkBook.ActiveSheet.name
	$SheetsCount = $oExcel.Application.ActiveWorkBook.Sheets.count
	_XLRead($s_FilePath)
	$oExcel = ObjGet ("", "Excel.Application")
	If Not IsObj ($oExcel) Then MsgBox(0, "", "what - no Excel!")
	$SheetsCount = $oExcel.Application.ActiveWorkBook.Sheets.count
	$Address = $oExcel.Application.activecell.address
	$s_i_ExcelValue = $oExcel.Application.activecell.value
	$Name = $oExcel.Application.ActiveWorkBook.name
	$s_i_Sheet = $oExcel.Application.ActiveWorkBook.ActiveSheet.name
	$s_FilePath = $oExcel.Application.ActiveWorkBook.fullname
	$UsedRange = $oExcel.Application.ActiveWorkBook.ActiveSheet.UsedRange.Address
	$CurrentRange = $oExcel.Application.ActiveWindow.RangeSelection.Address
	$FontBackground = $oExcel.Application.ActiveCell.Font.Background
	$FontColor = $oExcel.Application.ActiveCell.Font.Color
	$FontFontStyle = $oExcel.Application.ActiveCell.Font.FontStyle
	$FontName = $oExcel.Application.ActiveCell.Font.Name
	$FontSize = $oExcel.Application.ActiveCell.Font.Size
	If Not StringInStr($s_FilePath, "\") Then
		;Msgbox(0,"","Trying and retrying"&"$s_FilePath="&$s_FilePath&"$SheetsCount="&$SheetsCount)
		$s_FilePath = @ScriptDir & "\" & $s_FilePath
		$oExcel.Application.DisplayAlerts = 0
		$oExcel.Application.ScreenUpdating = 0
		If FileExists($s_FilePath) Then
			FileDelete($s_FilePath)
		EndIf
		$oExcel.ActiveWorkBook.SaveAs ($s_FilePath)
		$s_FilePath = $oExcel.Application.ActiveWorkBook.fullname
		$oExcel.Application.DisplayAlerts = 1
		$oExcel.Application.ScreenUpdating = 1
	EndIf
	$var = $Address & "|" & $s_i_ExcelValue & "|" & $s_FilePath & "|" & $SheetsCount & "|" & $Name & "|" & $s_i_Sheet & "|" & $CurrentRange & "|" & $UsedRange
	$var = $var & "|" & $FontBackground & "|" & $FontColor & "|" & $FontFontStyle & "|" & $FontName & "|" & $FontSize;&"|"&$s_i_Sheet&"|"&$CurrentRange&"|"&$UsedRange,"|")
	Return StringSplit($var, "|")
EndFunc   ;==>_XLGetActive
Func _XLChart(ByRef $s_FilePath, $ChartType = 1, $PlotBy = 1, $Title = 1, $Xaxis = 1, $Yaxis = 1, $Zdata = 1, $SortRange = "UsedRange", $s_i_Sheet = 1, $s_i_Visible = 0)
	$ExcelValuePass = $ChartType & "|" & $PlotBy & "|" & $Title & "|" & $Xaxis & "|" & $Yaxis & "|" & $Zdata & "|" & $SortRange
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "Chart", "NoSave", $ExcelValuePass, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
EndFunc   ;==>_XLChart
Func _XLFromListView(ByRef $s_FilePath, $h_Listview, $iListSelected = 0, $s_i_Visible = "NotVisible")
	$var = _ExcelCOM($s_FilePath, 1, 1, 1, "FromList", "NoSave", $h_Listview, $s_i_Visible, "NOTExit", $iListSelected, "NOTToColumn"); LastRow excel
EndFunc   ;==>_XLFromListView
Func _SheetAdd(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "Sheet", $s_i_Visible = "NotVisible")
	Return _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "SheetAdd", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "", "NOTToColumn"); LastRow excel
EndFunc   ;==>_SheetAdd
;Func _BookAdd(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "Sheet", $s_i_Visible = "NotVisible")
;	Return _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "BookAdd", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "", "NOTToColumn"); LastRow excel
;EndFunc   ;==>_BookAdd
Func _GetSheetName(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "Sheet", $s_i_Visible = "NotVisible")
	Return _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "GetSheetName", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "", "NOTToColumn"); LastRow excel
EndFunc   ;==>_GetSheetName
Func _NameSheet(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "Sheet", $s_i_Visible = "NotVisible")
	Return _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "NameSheet", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "", "NOTToColumn"); LastRow excel
EndFunc   ;==>_NameSheet
Func _XLSheetProps(ByRef $s_FilePath, $s_i_Visible = 0)
	Return _ExcelCOM($s_FilePath, 1, 1, 1, "Props", "NoSave", 4, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn")
EndFunc   ;==>_XLSheetProps
Func _XLSheetProperties(ByRef $s_FilePath, $s_i_Visible = 0)
	Return _ExcelCOM($s_FilePath, 1, 1, 1, "Properties", "NoSave", 4, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn")
EndFunc   ;==>_XLSheetProperties
Func _XLCreateBlank($s_FilePath)
	$NewName = $s_FilePath
	If Not FileExists($NewName) Then
		$oXLNew1 = ObjCreate ("Excel.Application")
		$oXLNew1.workbooks.Add
		$oXLNew1.ActiveWorkbook.SaveAs ($NewName)
		$oXLNew1.ActiveWorkbook.Close (0)
		$oXLNew1.DisplayAlerts = 1
		$oXLNew1.ScreenUpdating = 1
		$oXLNew1.quit
	EndIf
	
	$oXLNew = ObjGet ($NewName)
	;if isobj ($oXLNew) then $oXLNew.Application.quit
	If IsObj ($oXLNew) Then $oXLNew.close (0)
	$oXLNew = ObjCreate ("Excel.Application")
	$oXLNew.workbooks.Add
	$oXLNew.DisplayAlerts = 0
	$oXLNew.ScreenUpdating = 0
	If FileExists($NewName) Then
		FileDelete($NewName)
		;MsgBox(0,"","deleted"&$NewName)
	EndIf
	$oXLNew.ActiveWorkbook.SaveAs ($NewName)
	$oXLNew.ActiveWorkbook.Close (0)
	$oXLNew.DisplayAlerts = 1
	$oXLNew.ScreenUpdating = 1
	$oXLNew.quit
EndFunc   ;==>_XLCreateBlank
Func _XLRead(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $s_i_Visible = "NotVisible")
	$varread = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Read", "NoSave", 4, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $varread
EndFunc   ;==>_XLRead
Func _XLReadOnly(ByRef $ssFilePath, $NewPath = "c:\booktemp.xls", $s_i_Visible = 0)
	$oXLApp = ObjCreate ("Excel.Application")
	$oNewPath = ObjGet ($NewPath)
	If IsObj ($oNewPath) Then _XLClose($NewPath, 0)
	If Not FileExists($ssFilePath) Or (Not StringInStr($ssFilePath, ".csv") And Not StringInStr($ssFilePath, ".xl") And Not StringInStr($ssFilePath, ".txt")) Then
		$ssFilePath = FileOpenDialog("[_XLReadOnly] Go - Choose your input file as inbuilt one not exists", @ScriptDir, "Comma /XL* Files" & " (" & "*.csv;*.xl*;*.txt" & ")", 1);+ $Recurse+ $Recurse
		$oTempPath = ObjGet ($ssFilePath)
		$oTempPath.close (0)
	EndIf
	$oXLApp.Workbooks.Open ($ssFilePath, 0)
	$oXLApp.Windows (1).Visible = 1; Set the first worksheet in the workbook visible
	$oXLApp.Worksheets (1).Activate
	$oXLApp.ActiveSheet.Visible = $s_i_Visible
	$oXLApp.Application.DisplayAlerts = 0
	$oXLApp.Application.ScreenUpdating = 0
	If FileExists($NewPath) Then
		FileDelete($NewPath)
	EndIf
	$oXLApp.ActiveWorkbook.SaveAs ($NewPath)
	$oXLApp.Application.DisplayAlerts = 1
	$oXLApp.Application.ScreenUpdating = 1
	$ssFilePath = $NewPath
EndFunc   ;==>_XLReadOnly
Func _XLWrite(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $ExcelValue1 = 1, $s_i_Visible = 0)
	$varwr = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Into", "NoSave", $ExcelValue1, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $varwr
EndFunc   ;==>_XLWrite
Func _XLPaste(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $ExcelValue1 = "", $s_i_Save = "Save", $s_i_ToColumn = "NOTToColumn", $s_i_Visible = 0)
	If $s_i_ToColumn <> 0 Or $s_i_ToColumn = "ToColumn" Then
		;MsgBox(0,"$s_i_ToColumn<>0 or $s_i_ToColumn","$s_i_ToColumn="&$s_i_ToColumn)
		$ExcelValue1 = StringReplace($ExcelValue1, @CRLF, ",")
		$ExcelValue1 = StringReplace($ExcelValue1, @TAB, @CRLF)
		;Else
		;MsgBox(0,"NOT $s_i_ToColumn<>0 or $s_i_ToColumn","$s_i_ToColumn="&$s_i_ToColumn)
	EndIf
	ClipPut("")
	Local $a = 0
	If $ExcelValue1 <> "" Then ClipPut($ExcelValue1)
	While 1
		If not (ClipGet() == "") Then
			ExitLoop
		Else
			$a = $a + 1
			If $a > 50 Then MsgBox(0, "", "in _XLpaste")
		EndIf
		Sleep(50)
	WEnd
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Paste", "Save", 1, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLPaste
Func _XLExit(ByRef $s_FilePath, $s_i_Save = 1)
	$var = _ExcelCOM($s_FilePath, 1, "A", 1, "calc", $s_i_Save, 1, "NOTVisible", "Exit", "NOTLastRow", "NOTToColumn"); Exit excel
	;return $var
EndFunc   ;==>_XLExit
Func _XLLastRow(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Visible = 0)
	$var2 = _ExcelCOM($s_FilePath, $s_i_Sheet, "A", 1, "Read", "NoSave", 1, $s_i_Visible, "NOTExit", "LastRow", "NOTToColumn"); LastRow excel
	Return $var2
EndFunc   ;==>_XLLastRow
Func _XLSave(ByRef $s_FilePath, $s_i_Save = 1, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, 1, "A", 1, "Read", "Save", 1, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	;return $var
EndFunc   ;==>_XLSave
Func _XLClose(ByRef $s_FilePath, $s_i_Save = 1, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, 1, "A", 1, "close", $s_i_Save, 1, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	;return $var
EndFunc   ;==>_XLClose
Func _XLShow(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $ExcelValue1 = 0)
	;$var=
	_ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Show", "NoSave", $ExcelValue1, "Visible", "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	;return $var
EndFunc   ;==>_XLShow
Func _XLMacroRun(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = "persoNAL.XLS!Macro1", $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, "A", 1, "Run", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLMacroRun
Func _XLSaveAs(ByRef $s_FilePath, $s_i_ExcelValue = "c:\test.xls", $csv = "xls", $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, 1, "A1", $csv, "SaveAs", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLSaveAs
Func _XLReady(ByRef $s_FilePath, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, 1, "A", 1, "Ready", "NoSave", 4, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLReady
Func _XLAdd(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $s_i_ExcelValue = 1, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Add1", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLAdd
Func _XLAddGeneral(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $s_i_ExcelValue = 1, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Add2", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLAddGeneral
Func _XLCalc(ByRef $s_FilePath, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, 1, "A", 1, "Calc", "NoSave", 1, $s_i_Visible, "NOTExit", "NOTLastRow", "NOTToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLCalc
Func _XLWriteCol(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = "A", $i_Row = 1, $s_i_ExcelValue = 1, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Into", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NOTLastRow", "ToColumn"); read cell "E7"
	Return $var
EndFunc   ;==>_XLWriteCol
Func _XLCsvPaste(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = 1, $i_Row = 1, $s_i_Save = "Save", $csvPath = "test.csv", $s_i_Visible = 0)
	; rem must save else may not paste (? calc?)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Import", "Save", $csvPath, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	Return $var
EndFunc   ;==>_XLCsvPaste
;func _XLCopyTo(ByRef $s_FilePath,$s_i_Sheet=1,$s_i_Column=1,$i_Row=1,$XLCopyRange=$s_FilePath&"|"&$s_i_Sheet&"|"&"A1:B2",$s_i_Visible=0)
Func _XLCopyTo(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = 1, $i_Row = 1, $XLCopyRange = "A1:B2", $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "CopyTo", "Save", $XLCopyRange, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	Return $var
EndFunc   ;==>_XLCopyTo
Func _XLArrayWrite($XLArray, ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = 1, $i_Row = 1, $s_i_Visible = 0, $s_i_Transpose = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "ArrayWrite", "Save", $XLArray, $s_i_Visible, "NOTExit", $s_i_Transpose, "NOTToColumn"); LastRow excel
	Return $var
EndFunc   ;==>_XLArrayWrite
Func _XLFormat(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_Column = 1, $i_Row = 1, $s_i_ExcelValue = "General", $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "Format", "Save", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	Return $var
EndFunc   ;==>_XLFormat
Func _XLCopy(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = 1, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "Copy", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	;$var=$s_FilePath&"|"&$s_i_Sheet&"|"&$var
	Return $var
EndFunc   ;==>_XLCopy
Func _XLArrayRead(ByRef $s_FilePath, $s_i_Sheet = 1, $s_i_ExcelValue = 1, $s_i_Visible = 0)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "ArrayRead", "NoSave", $s_i_ExcelValue, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
	;$var=$s_i_ExcelValue
	Return $var
EndFunc   ;==>_XLArrayRead
Func _XLSort(ByRef $s_FilePath, $Columns = 1, $Direction1 = 1, $Columns2 = 1, $Direction2 = 1, $SortRange = "UsedRange", $s_i_Sheet = 1, $s_i_Visible = 0)
	$ExcelValuePass = $Columns & "|" & $Direction1 & "|" & $Columns2 & "|" & $Direction2 & "|" & $SortRange
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, 1, 1, "Sort", "NoSave", $ExcelValuePass, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn"); LastRow excel
EndFunc   ;==>_XLSort
Func _XLChartType($Type = "Line", $Special = "", $3D = 1, $Clustered = 0, $Stacked = 0, $100 = 0, $Markers = 0, $Exploded = 0)
	;$Type options are"Line", "Pie","Column","Bar","XYScatter","Surface","Area"
	;$Special options are "BarOf","PieOf","Lines","Smooth"; all others are 0/1
	Local $ChartNumber
	Select
		Case $Type = "Line"
			$ChartNumber = 4; 3d/-4101;m65;ms/66;;ms100/67;s63;s100/64
			If $Stacked = 1 Then
				$ChartNumber = 63+ ($100 = 1) + 3* ($Markers = 1)
			ElseIf $Markers = 1 Then
				$ChartNumber = 65
			EndIf
			If $3D = 1 Then $ChartNumber = -4101
			;MsgBox(0,"","$ChartNumber="&$ChartNumber)
		Case $Type = "Pie"
			$ChartNumber = 5;$xlBarOfPie = 71;$xl3DPie = -4102;$xl3DPieExploded = 70;$xlPieExploded = 69;$xlPieOfPie = 68
		Case $Type = "Column"
			$ChartNumber = 51; unknown number really?
			Select
				Case $Clustered = 1;$xlColumnClustered=51;$xl3DColumnClustered = 54
					$ChartNumber = 51 + 3* ($3D = 1)
				Case $Stacked = 1 ;;$xlColumnStacked=52;;$xlColumnStacked100=53;;;;$xl3DColumnStacked = 55;$xl3DColumnStacked100 = 56;
					$ChartNumber = 52+ ($100 = 1) + 3* ($3D = 1)
				Case $3D = 1
					$ChartNumber = -4100;$xl3DColumn = -4100
			EndSelect
			MsgBox(0, "", "$ChartNumber=" & $ChartNumber)
		Case $Type = "Bar"
			$ChartNumber = 57;should be "2" but not working;$xlBar = 2
			Select
				Case $Clustered = 1;$xl3DBarClustered = 60;$xlBarClustered=57;
					$ChartNumber = 57 + 3* ($3D = 1)
				Case $Stacked = 1 ;;$xlBarStacked = 58;$xlBarStacked100 = 59;$xl3DBarStacked = 61;$xl3DBarStacked100 = 62;
					$ChartNumber = 58+ ($100 = 1) + 3* ($3D = 1)
				Case $3D = 1
					$ChartNumber = -4099;;$xl3DBar = -4099;
			EndSelect
			MsgBox(0, "", "$ChartNumber=" & $ChartNumber)
		Case $Type = "XYScatter"
			$ChartNumber = -4169;$xlXYScatter=-4169;
			If $Special = "Lines" Then $ChartNumber = 74 + ($Markers = 1);;$xlXYScatterLines = 74;;$xlXYScatterLinesNoMarkers = 75;
			If $Special = "Smooth" Then $ChartNumber = 72+ ($Markers = 1);$xlXYScatterSmooth = 72;$xlXYScatterSmoothNoMarkers = 73;
		Case $Type = "Surface";$xl3DSurface = -4103
			$ChartNumber = -4103
		Case $Type = "Area"
			$ChartNumber = -4098 ;;$xl3DArea = -4098;;s78;100-79
			If $Stacked = 1 Then $ChartNumber = 78 + ($100 = 1);$xl3DAreaStacked = 78;$xl3DAreaStacked100 = 79;
	EndSelect
	;$xlPrimary=1;$$xlBubble=15	;$xlBubble3DEffect = 87
	;$xlCombination = -4111;$xlLinear = -4132;$xlLinearTrend = 9;;$xlLineStyleNone = -4142
	Return $ChartNumber
EndFunc   ;==>_XLChartType
Func _WordCOM(ByRef $s_FilePath, $s_MEWordCom = "Macro", $s_Macro = "DestinationDirectory", $s_WordValue = "Hi", $s_i_Save = "NoSave", $s_i_Visible = "NotVisible", $s_i_Exit = "NotExit")
	Local $o_Word
	If $s_i_Save = "Save" Then $s_i_Save = 1
	If $s_i_Visible = "Visible" Then $s_i_Visible = 1
	If $s_i_Exit = "Exit" Then $s_i_Exit = 1
	;MsgBox(0,"","$s_i_Visible="&$s_i_Visible)
	;==================================================if all numbers
	If $s_i_Visible <> 1 Then $s_i_Visible = 0
	If Not FileExists($s_FilePath) Or Not StringInStr($s_FilePath, "doc") Then
		_WordCreateBlank($s_FilePath)
	EndIf
	If Not IsObj ($o_Word) Then
		$o_Word = ObjGet ($s_FilePath) ; Get anWord Object from an existing filename
		If Not IsObj ($o_Word) Then
			Sleep(500)
			$o_Word = ObjGet ($s_FilePath) ; Get anWord Object from an existing filename
			If Not IsObj ($o_Word) Then
				MsgBox(0, "Word File Test", "Error: Could not open " & $s_FilePath & " as an Word Object.")
			EndIf
		EndIf
	EndIf
	If IsObj ($o_Word) Then
		With $o_Word
			Select
				Case StringInStr($s_MEWordCom, "Macro")
					.Application.Visible = $s_i_Visible
					$Close = 0
					.Application.Run ($s_Macro)  ;"Normal.NewMacros.Font4"
				Case StringInStr($s_MEWordCom, "Close")
					$Close = 1
			EndSelect
		EndWith
		If $s_i_Save = 1 Then
			$o_Word.Save
		EndIf
		If $Close = 1 And $s_i_Exit = 0 Then
			;$oWord.saved=1
			$o_Word.close (0)
		EndIf
		If $s_i_Exit = 1 Then
			$o_Word.Application.Quit
			While ProcessExists('Winword.exe')
				Sleep(10)
			WEnd
		EndIf
	Else
		MsgBox(0, "Word File Test", "Error: Could not open " & $s_FilePath & " as an Word Object.")
	EndIf
	;return $var
EndFunc   ;==>_WordCOM
Func _WordMacro(ByRef $s_FilePath, $s_Macro = "DestinationDirectory", $s_WordValue = "Hi", $s_i_Visible = 0)
	_WordCOM($s_FilePath, "Macro", $s_Macro, $s_WordValue, "NOTSave", $s_i_Visible, "NOTExit")
EndFunc   ;==>_WordMacro
Func _WordClose(ByRef $s_FilePath, $s_i_Save = "NoSave", $s_i_Exit = "NotExit")
	_WordCOM($s_FilePath, "Close", "DestinationDirectory", "Hello", $s_i_Save, "NotVisible", $s_i_Exit)
EndFunc   ;==>_WordClose
Func _WordCreateBlank($s_FilePath)
	$NewName = $s_FilePath
	$WordNew = ObjGet ($NewName)
	If IsObj ($WordNew) Then $WordNew.Application.quit
	$WordNew = ObjCreate ("Word.Application")
	$WordNew.documents.Add
	$WordNew.DisplayAlerts = 0
	;$WordNew.ScreenUpdating = 0
	If FileExists($NewName) Then
		FileDelete($NewName)
	EndIf
	$WordNew.ActiveDocument.SaveAs ($NewName)
	$WordNew.DisplayAlerts = -1
	;$WordNew.ScreenUpdating = -1
	$WordNew.quit
EndFunc   ;==>_WordCreateBlank
Func _XLRowToString(ByRef $s_FilePath, $s_i_Sheet = 1, $s_CopyRange = "A1:B20", $Line = 1, $s_i_Visible = 0)
	$TempCSVPath = @ScriptDir & "\$TempCSVPath.csv"
	_XLCreateBlank($TempCSVPath)
	$XLCopyRange = _XLCopy($s_FilePath, $s_i_Sheet, $s_CopyRange, $s_i_Visible)
	_XLCopyTo($TempCSVPath, 1, "A", 1, $XLCopyRange, $s_i_Visible) ;copy as range into Temporary Sheet csv
	_XLSaveAs($TempCSVPath, $TempCSVPath, "csv", $s_i_Visible) ;save Sheet csv as Dos text csv
	_XLClose($TempCSVPath, 0, $s_i_Visible) ; no changes and close workbook; not  Excel
	Return FileReadLine($TempCSVPath, $Line)
EndFunc   ;==>_XLRowToString
Func _XLRowToArray(ByRef $s_FilePath, $s_i_Sheet = 1, $s_CopyRange = "A1:B20", $Line = 1, $s_i_Visible = 0)
	$XLArray = _XLArrayRead($s_FilePath, $s_i_Sheet, $s_CopyRange, $s_i_Visible)
	$var = _Array2DTo1D($XLArray, "XL Line" & $Line, 0, $Line - 1, 0)
	Return $var
EndFunc   ;==>_XLRowToArray
Func _XLColumnToArray(ByRef $s_FilePath, $s_i_Sheet = 1, $s_CopyRange = "A1:B20", $Line = 1, $s_i_Visible = 0)
	Local $XLArray
	$XLArray = _XLArrayRead($s_FilePath, $s_i_Sheet, $s_CopyRange, $s_i_Visible)
	$var = _Array2DTo1D($XLArray, "XL Line" & $Line, 0, $Line - 1, 1)
	Return $var
EndFunc   ;==>_XLColumnToArray
Func _Array2DTo1D(ByRef $ar_Array, $s_Title = "Array contents", $n_Index = 1, $Line = 0, $s_i_Column = 0)
	; Change Line "X" to 1 dimensional array; [Randallc - I have ***lifted it from Forum at some stage]
	Local $output = ""
	Local $r, $e, $Swap
	If $n_Index <> 0 Then $n_Index = 1; otherwise I can't cope!
	If $s_i_Column <> 0 Then $s_i_Column = 1; otherwise I can't cope!
	If $Line < 0 Then $Line = 0; otherwise I can't cope!
	;If $Line>UBound($ar_Array,1+($s_i_Column=0))+($n_Index=0)-2 then $Line=UBound($ar_Array,)+($n_Index=0)-2	; otherwise I can't cope!
	If $Line > UBound($ar_Array, 1+ ($s_i_Column = 0)) + ($n_Index = 0) - 2 Then $Line = UBound($ar_Array, 1+ ($s_i_Column = 0)) + ($n_Index = 0) - 2; otherwise I can't cope!
	Dim $Array[UBound($ar_Array, 1 + $s_i_Column) + ($n_Index = 0) ]
	$Array[0] = UBound($ar_Array, 1 + $s_i_Column) + ($n_Index = 0)
	If Not IsArray($ar_Array) Then Return -1
	For $r = $n_Index To UBound($ar_Array, 1 + $s_i_Column) - 1
		$e = $r
		$NewLine = $Line
		If $s_i_Column = 1 Then
			$NewLine = $r
			$e = $Line
		EndIf
		$Array[$r+ ($n_Index = 0) ] = $ar_Array[$e][$NewLine]
	Next
	;_ArrayDisplay($Array,$s_Title&"Line"&$Line)
	Return $Array
EndFunc   ;==>_Array2DTo1D
Func _StringSplit_0($s_String, $s_Delimiter = "|", $i_Flag = "0")
	; SYNTAX _StringSplit_0($s_String[,[$s_Delimiter="|"],[$i_Flag="0"]])
	$ar_Array = StringSplit($s_String, $s_Delimiter)
	Local $ar_Array_0[UBound($ar_Array) - 1]
	For $i = 0 To UBound($ar_Array) - 2
		$ar_Array_0[$i] = $ar_Array[$i + 1]
	Next
	Return $ar_Array_0
EndFunc   ;==>_StringSplit_0
Func _ArrayTranspose2D(ByRef $ar_Array)
	If IsArray($ar_Array) Then
		Dim $ar_ExcelValueTrans[UBound($ar_Array, 2) ][UBound($ar_Array, 1) ] ;ubound($s_i_ExcelValue,2)-1, ubound($s_i_ExcelValue,1)-1)
		For $j = 0 To UBound($ar_Array, 2) - 1
			For $numb = 0 To UBound($ar_Array, 1) - 1
				$ar_ExcelValueTrans[$j][$numb] = $ar_Array[$numb][$j]
			Next
		Next
		$ar_Array = $ar_ExcelValueTrans
	Else
		MsgBox(0, "", "No Array to transpose")
	EndIf
EndFunc   ;==>_ArrayTranspose2D
Func _NewSheetName(ByRef $s_i_ExcelValue, $o_Excel)
	Local $s_WorkSheet
	For $s_WorkSheet In $o_Excel.Application.ActiveWorkBook.Worksheets
		If $s_WorkSheet.Name == $s_i_ExcelValue Then
			$SheetsCount = $o_Excel.Application.ActiveWorkBook.Worksheets.count
			$s_i_ExcelValue = $s_i_ExcelValue & $SheetsCount + 1 & $o_Excel.ActiveSheet.Name
			_NewSheetName($s_i_ExcelValue, $o_Excel)
		EndIf
	Next
EndFunc   ;==>_NewSheetName
Func _XLSetColumnWidth(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $s_i_ColumnWidth, $s_i_Visible)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, 1, "SetColWidth", "NoSave", $s_i_ColumnWidth, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn")
EndFunc   ;==>_XLSetColumnWidth
Func _XLShowColorCodes()
	$oXLColor = ObjCreate ("Excel.Application")
	$oXLColor.Visible = True
	$oXLColor.workbooks.Add
	$oXLColor.worksheets (1)
	$oXLColor.Cells (1, 1).Value = "Excel Color Codes"
	For $i = 1 To 14
		$oXLColor.Cells ($i, 1).Value = $i
		$oXLColor.Cells ($i, 2).Interior.ColorIndex = $i
	Next
	For $i = 15 To 28
		$oXLColor.Cells ($i - 14, 3).Value = $i
		$oXLColor.Cells ($i - 14, 4).Interior.ColorIndex = $i
	Next
	For $i = 29 To 42
		$oXLColor.Cells ($i - 28, 5).Value = $i
		$oXLColor.Cells ($i - 28, 6).Interior.ColorIndex = $i
	Next
	For $i = 43 To 56
		$oXLColor.Cells ($i - 42, 7).Value = $i
		$oXLColor.Cells ($i - 42, 8).Interior.ColorIndex = $i
	Next
EndFunc   ;==>_XLShowColorCodes
Func _XLSetCellFontName(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $s_FontName, $s_i_Visible)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "SetCellFontName", "NoSave", $s_FontName, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn")
EndFunc   ;==>_XLSetCellFontName
Func _XLSetCellFontColor(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $i_FontColor, $s_i_Visible)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "SetCellFontColor", "NoSave", $i_FontColor, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn")
EndFunc   ;==>_XLSetCellFontColor
Func _XLSetCellColor(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $i_FontColor, $s_i_Visible)
	$var = _ExcelCOM($s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, "SetCellColor", "NoSave", $i_FontColor, $s_i_Visible, "NOTExit", "NotLastRow", "NOTToColumn")
EndFunc   ;==>_XLSetCellColor