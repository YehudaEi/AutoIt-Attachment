Opt ("WinTitleMatchMode",4)
#Include <Array.au3>
; thanks to SEO <locodarwin at yahoo dot com> for ideas in ExcelCOM_UDF.au3

#region Functions
;===============================================================================
;
; Function Name:    _OOoCalcAttach()
; Description:    	Attach to the first existing instance of OOo Calc
; Parameter(s):     $fn   = FileName of the open workbook with extension
;    				and without full UNC path
; Requirement(s):   AutoIt3 with COM support (post 3.1.1)
;               	On Success - Returns an object variable pointing to
; 			   				active com.sun.star.frame.Desktop Component object
;                   On Failure  - Returns 0 and sets @ERROR = 1
; Author(s):        Leagnus. Thanks to ms777
;
;===============================================================================
;
Func _OOoCalc_Attach($fn)
   Dim $oSM
   Local $oDesktop, $f_num
   $oSM = Objcreate("com.sun.star.ServiceManager")
   $oDesktop = $oSM.createInstance("com.sun.star.frame.Desktop")   ; Create a desktop object:
   ; кол-во окон, не подходит только дл€ цикла перебора окон: не отслеживаетс€ Extension Manager:
   $f_num = $oDesktop.Frames.Count ; number of frames opened for documents or developing
;  If few documents are open
   if $f_num > 1 then ; если несколько окон Ц сделаем активным нужное
	   $Sub_Wins = WinList("[CLASS:SALFRAME]", "") ; list of all windows titles ; список всех окон с титлами
	   for $a = 1 to $Sub_Wins[0][0]
		 $cur_Win = StringRegExp ($Sub_Wins[$a][0],'(.*?\.[A-z]{3}).*',1) ; ищу (им€_файла).всЄ остальное
; 		 MsgBox(1, "AutoIt", $cur_Win[0])
		 if not @error and $cur_Win[0] == $fn then
; 			 activating given one:
			 WinActivate ($Sub_Wins[$a][0]) ; the point is here ; вс€ фишка цикла в этом.
			 ExitLoop
		 EndIf
	   Next
   EndIf
   $Win_title = WinGetTitle ( "[CLASS:SALFRAME]") ; на случай, если одно окно
   $temp_title = StringRegExp ($Win_title,'(.*?\.[A-z]{3}).*',1)
   if not @error then $Win_title = $temp_title[0]
;    MsgBox(1, "AutoIt", $Win_title)
   if $Win_title <> $fn then Return SetError(1, 0, 0)
   ; если было несколько, то ссылка на активный док: теперь уже уверены, что тот, который нужно:
   $oCurCom = $oDesktop.getCurrentComponent()
   if @error or Not IsObj($oCurCom) then
	  Return SetError(1, 0, 0)
   else
	  Return $oCurCom
   EndIf
EndFunc   ;==>_OOoCalcAttach

;===============================================================================
;
; Function Name:    _OOoCalc_New()
; Description:    	Opens an existing workbook and returns its object identifier.
; Parameter(s):     $fn   = full UNC File Name of the workbook file
; Requirement(s):   AutoIt3 with COM support (post 3.1.1)
;               	On Success - Returns an object variable pointing to
; 			   				active com.sun.star.frame.Desktop Component object
;                   On Failure  - Returns 0 and sets @ERROR = 1
; Author(s):        Leagnus
;
;===============================================================================
;
Func _OOoCalc_New()
   Dim $OpenPar[1] ; параметры открыти€: потенциальные, но в реальности ещЄ не работают
   $OpenPar[0] = setProp("ReadOnly", True)
   Local $oDesktop, $f_num
   $oSM = Objcreate("com.sun.star.ServiceManager")
   $oDesktop = $oSM.createInstance("com.sun.star.frame.Desktop")   ; Create a desktop object:
   $oCurCom = $oDesktop.loadComponentFromURL( "private:factory/scalc", "_blank", 0, $OpenPar)
   if @error or Not IsObj($oCurCom) then
	  Return SetError(1, 0, 0)
   else
	  Return $oCurCom
   EndIf
EndFunc   ;==>_OOoCalcOpen

;===============================================================================
;
; Function Name:    _OOoCalc_Open()
; Description:    	Opens an existing workbook and returns its object identifier.
; Parameter(s):     $fn   = full UNC File Name of the workbook file
; Requirement(s):   AutoIt3 with COM support (post 3.1.1)
;               	On Success - Returns an object variable pointing to
; 			   				active com.sun.star.frame.Desktop Component object
;                   On Failure  - Returns 0 and sets @ERROR = 1
; Author(s):        Leagnus
;
;===============================================================================
;
Func _OOoCalc_Open($fn)
   Dim $OpenPar[1] ; параметры открыти€: потенциальные, но в реальности ещЄ не работают
   $OpenPar[0] = setProp("ReadOnly", True)
   Local $oDesktop, $f_num
   $oSM = Objcreate("com.sun.star.ServiceManager")
   $oDesktop = $oSM.createInstance("com.sun.star.frame.Desktop")   ; Create a desktop object:
   ; а если открыта только оболочка, а не нужный нам док (есть объект, но нет дока):
   ; MsgBox(1, "AutoIt", IsObj($oDesktop ))
   ;    MsgBox(1, "AutoIt", "OOo or the file is not opened")
	  $cURL = Convert2URL($fn)
	  $oCurCom = $oDesktop.loadComponentFromURL( $cURL, "_blank", 0, $OpenPar)
;~ 	  msgbox(0,"","7",1)
   if @error or Not IsObj($oCurCom) then
;~ 	   msgbox(0,"","71",1)
	  Return SetError(1, 0, 0)
;~ 	  msgbox(0,"","72",1)
  else
;~ 	  msgbox(0,"","81",1)
	  Return $oCurCom
   EndIf
EndFunc   ;==>_OOoCalcOpen

;===============================================================================
;
; Function Name:    _OOoCalc_Close()
; Description:    	Closes an existing workbook
; Parameter(s):     $Obj   = Object containing the workbook file
; Requirement(s):   AutoIt3 with COM support (post 3.1.1)
;               	On Success - Returns an object variable pointing to
; 			   				active com.sun.star.frame.Desktop Component object
;                   On Failure  - Returns 0 and sets @ERROR = 1
; Author(s):        Leagnus
;
;===============================================================================
;

Func _OOoCalc_Close($Obj)
	msgbox(0,"","31",1)
	$Obj.close(True)
	msgbox(0,"","32",1)
	if @error then
	   msgbox(0,"","71",1)
	   $obj.dispose()
	  Return SetError(1, 0, 0)
	  msgbox(0,"","72",1)
  else
	  msgbox(0,"","91",1)
   EndIf
EndFunc

;===============================================================================
;
; Description:      Returns a list of all sheets in workbook, by name, as an array.
; Syntax:           _OOoCalc_SheetList($oCurCom)
; Parameter(s):     $oCurCom - An Current Component opened by a preceding call to
; 				    _OOoCalc_Open() or by _OOoCalc_Attach()
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array of the sheet names in the workbook
;                   the first entry of the array indicates the array size
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        Leagnus
; Note(s):          Modified by Kris to be compatible with the Excel.au3 include.
;
;===============================================================================
Func _OOoCalc_SheetList($oCurCom)
	Local $WorksheetArray
	Local $ResultArray[1]
   	If NOT IsObj($oCurCom) Then Return SetError(1, 0, 0)
	$ResultArray[0] = $oCurCom.getSheets().count
    $WorksheetArray = $oCurCom.getSheets().ElementNames
	_ArrayConcatenate($ResultArray,$WorksheetArray)
	Return $ResultArray
EndFunc



;===============================================================================
;
; Description:      Activate the specified sheet by string name
; Syntax:           _OOoCalc_SheetActivate($oCurCom, $sSheet)
; Parameter(s):     $oCurCom - An Current Component object opened by a preceding call to
;                   _OOoCalc_Open() or by _OOoCalc_Attach()
;					$sSheet - The sheet to activate, by string name
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
;						@error=2 - Specified sheet name does not exist
; Author(s):        Leagnus
; Notes:			Modified by Kris to be compatible with the excel.au3 include
;					made the selection procedure more elegant (nothing gets selected)
;
;					Sheet name shouldn't be putted in quotes
; 					this func is only for visual aid for user and
; 				    is useless for other funcs: _OOoCalc_FindInRange,
; 					_OOoCalc_ReadCell, _OOoCalc_WriteCell, etc.
;===============================================================================
Func _OOoCalc_SheetActivate($oCurCom, $Worksheet)
	Local $WorksheetArray
	Local $Found = False

	If NOT IsObj($oCurCom) Then Return SetError(1, 0, 0)
	$WorksheetArray = _OOoCalc_SheetList($oCurCom)
	For $i = 1 To $WorksheetArray[0]
		If $WorksheetArray[$i] = $Worksheet Then
			;$oCurCom.getCurrentController.select($oCurCom.getSheets().getByName($Worksheet))
			;MsgBox(0,"Debug", $oCurCom.getCurrentController.setactivesheet($oCurCom.getSheets().getByName($Worksheet)))
			$oCurCom.getCurrentController.setactivesheet($oCurCom.getSheets().getByName($Worksheet))
			$Found = True
			Return 1
		EndIf
	Next
	MsgBox(0,"Debug", "Found = " & $Found & " But I am still here so the return did not throw me out of the loop")
	Return SetError(2, 0, 0)
	Return 1
EndFunc

;===============================================================================
;
; Description:      Read information from the specified worksheet cell in a workbook that was
; 					activated by calling _OOoCalc_Attach() or _OOoCalc_Open() funcs
; Syntax:           $val = _OOoCalc_ReadCell ($oCurCom, $oSheet, $sRow, $sColumn)
; Parameter(s):     $oCurCom Ц Component object returned by _OOoCalc_Attach() or _OOoCalc_Open()
; 					$sSheet - an integer: number of a worksheet starting 0
;					$sRow - an integer: row number to read from starting 0
;					$sColumn - an integer: column number to read from starting 0
; Requirement(s):   None
; Return Value(s):  On Success - Returns the data from the specified cell
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        Leagnus
; Note(s):          Thanks to WFC for UsedRange()
;
;===============================================================================
Func _OOoCalc_ReadCell ($oCurCom, $Worksheet, $sRow, $sColumn)
	$CellAddress = CHR($sColumn + 64) & $sRow

	If NOT IsObj($oCurCom) Then Return SetError(1, 0, 0)
	$Sheets = $oCurCom.GetSheets()
	$SheetComponent = $Sheets.GetByName($Worksheet)
	$CellComponent = $SheetComponent.GetCellRangeByName($CellAddress)
	$CellValue = $CellComponent.getstring()
	MsgBox(0,$CellAddress,$CellValue)
	Return $CellValue
EndFunc

;===============================================================================
;
; Description:      Write data to the specified worksheet cell in a workbook that was
; 					activated by calling _OOoCalc_Attach() or _OOoCalc_Open() funcs
; Syntax:           $val = _OOoCalc_WriteCell ($oCurCom, $oSheet, $sRow, $sColumn)
; Parameter(s):     $oCurCom Ц Component object returned by _OOoCalc_Attach() or _OOoCalc_Open()
; 					$sSheet - an integer: number of a worksheet starting 0
;					$sRow - an integer: row number to write to starting 0
;					$sColumn - an integer: column number to write to starting 0
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        Leagnus
; Note(s):          none
;
;===============================================================================
Func _OOoCalc_WriteCell($oCurCom, $Worksheet, $data, $sRow, $sColumn)
    $CellAddress = CHR($sColumn + 64) & $sRow

	If NOT IsObj($oCurCom) Then Return SetError(1, 0, 0)
	$Sheets = $oCurCom.GetSheets()
	$SheetComponent = $Sheets.GetByName($Worksheet)
	$CellComponent = $SheetComponent.GetCellRangeByName($CellAddress)
	$CellComponent.string() = $data
	$CellValue = $CellComponent.getstring()
	MsgBox(0,$CellAddress,$CellValue)
	Return
EndFunc

;===============================================================================
;
; Description:      Creates an array from specified range of specified worksheet.
; Parameter(s):     $oCurCom Ц Component object returned by _OOoCalc_Attach() or _OOoCalc_Open()
; 					$sSheet - an integer: number of a worksheet starting from 0
; 					$i_column Ц optional: specifies how many columns should be read, starting from 0
; 					$i_row Ц optional: specifies how many rows should be read, starting from 0
; Requirement(s):   None
; Return Value(s):  On Success - Returns 2D array
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        Leagnus
; Note(s):          none
;
;===============================================================================
Func _OOoRead2Array($oCurCom, $sSheet, $i_row = "all", $i_column = "all")
   $oSheet = $oCurCom.getSheets().getByIndex($sSheet)
		 If NOT IsObj($oSheet) Then Return SetError(1, 0, 0)
   $Range = UsedRange($oSheet) 		; подсчитываем зан€тый диапазон в объект $Range
   $mydata = $Range.getdataarray() 	; указатель на весь диапазон
   local $row = $mydata[0] 		; массив €чеек 1-ой строки. ≈го размерность Ц это кол-во полей
   if Not isInt ($i_column) then ; если не переданное число, а строка "all" по дефолту
	  $i_column = UBound($row)-1
	  $i_col_dim = UBound($row)
   Else
	  $i_col_dim = $i_column + 1
   EndIf
   if Not isInt ($i_row) 	then ; если не переданное число, а строка "all" по дефолту
	  $i_row = 	  UBound($mydata)-1
	  $i_ro_dim = UBound($mydata)
   Else
	  $i_ro_dim = $i_row + 1
   EndIf
   Dim $av_csv [$i_ro_dim][$i_col_dim]    ; неизвестно, сколько [строк][полей/колонок] будет
   For $i_b = 0 to $i_column  ; дл€ каждого пол€
	  For $i_a = 0 to $i_row 	; по всем строкам снизу вверх
		 $av_row = $mydata[$i_a]	; массив каждой строки, начина€ с 0-ой строки сверху.
		 $av_csv[$i_a][$i_b] = $av_row[$i_b]	; заполн€ю 1-ое поле
	  Next
   Next
   Return $av_csv
EndFunc

;===============================================================================
;
; Description:      Finds all instances of a string in a range and returns their addresses as a two dimensional array.
; Syntax:           _OOoCalc_FindInRange($sString, $oSheet, $bWholeWord = "false", $RegExp = "false")
; Parameter(s):     $oCurCom - Component object returned by _OOoCalc_Attach() or _OOoCalc_Open()
; 					$sSheet - an integer: number of a worksheet starting 0
;					$sString - The string to search for
; 					$bWholeWord Ц optional. If "true", only complete words will be found.
;								  If "false", partial match is possible. Default is "false".
; 					$RegExp Ц optional. If "true", the search string is evaluated as a regular expression.
;					$fMatchCase - optional. Specify whether case should match in search (True or False) (default=False)
; Requirement(s):   AutoIt Beta 3.2.1.12
; Return Value(s):  On Success - Returns a two dimensional array with addresses of matching cells.
; 					If no matches found, returns null string
;						UBound($array) - The number of found cells
;						$array[x][0] - The row of found cell x as an integer
;						$array[x][1] - The column of found cell x as an integer
;						$array[x][3] - The value of found cell x
;                   On Failure - Returns 0 and sets @error on errors:
;						@error=1 - Specified object does not exist
; Author(s):        Leagnus
; Note(s):          None
;
;===============================================================================
Func _OOoCalc_FindInRange($sString, $oCurCom, $sSheet, $bWholeWord = "false", $fMatchCase = "false", $RegExp = "false")
    Local $oSheet = $oCurCom.getSheets().getByIndex($sSheet)
	Dim $oDescriptor
	Dim $oFound
	Local $iCount = 0 ; row index starts with 0
	  If NOT IsObj($oSheet) Then Return SetError(1, 0, 0) ; sets @error to 1, @extended=0, func returns 0
; 	Create a descriptor from a searchable document:
	$oDescriptor = $oSheet.createSearchDescriptor()
; 	Set the text for which to search and other
; 	http://api.openoffice.org/docs/common/ref/com/sun/star/util/SearchDescriptor.html
	With $oDescriptor
       .SearchString = $sString
;    	These all default to false
	   .SearchBackwards = False
;    	SearchWords forces the entire cell to contain only the search string:
       .SearchWords = $bWholeWord
	   .SearchStyles = False
       .SearchCaseSensitive = $fMatchCase
	   .SearchRegularExpression = $RegExp
	   .SearchSimilarity = False
;      .SearchType = 1
	EndWith
   Dim $aFound[$iCount + 1][3] ; 1 row 2 columns
; 	Find the first one:
   $oCell = $oSheet.findFirst($oDescriptor)
   if IsObj($oCell) then
	  $a = 0
	  $aFound[$a][0] = $oCell.CellAddress.Row
	  $aFound[$a][1] = $oCell.CellAddress.Column
	  $aFound[$a][2] = $oCell.getString()
   else
	  Return SetError(1, 0, 0)
   EndIf
; 	Find all next instances:
   while IsObj($oCell)
	  $oCell = $oSheet.findNext($oCell,$oDescriptor)
	  if IsObj($oCell) then
		 $iCount+=1
		 ReDim $aFound[$iCount+1][3] 	; +1 because ReDim starts not with 0 like indices
		 $aFound[$iCount][0] = $oCell.CellAddress.Row
		 $aFound[$iCount][1] = $oCell.CellAddress.Column
		 $aFound[$iCount][2] = $oCell.getString()
	  EndIf
   WEnd
	return $aFound
EndFunc	;==>_OOoCalc_FindInRange

Func setProp($cName, $uValue)
; Dim $oPropertyValue
; Dim $oSM
  $oSM = Objcreate("com.sun.star.ServiceManager")
  $oPropertyValue = $oSM.Bridge_GetStruct("com.sun.star.beans.PropertyValue")
  $oPropertyValue.Name = $cName
  $oPropertyValue.Value = $uValue
  $setOOoProp = $oPropertyValue
  Return $setOOoProp
EndFunc

Func Convert2URL($fname) ; замен€ет символы
    $fname = StringReplace($fname, ":", "|") 	; двухиточие Ц на |
    $fname = StringReplace($fname, " ", "%20")  ; пробел Ц на %20
    $fname = "file:///" & StringReplace($fname, "\", "/")
    Return $fname
EndFunc ;=== Convert2URL

Func UsedRange($Sheet) ; возвращает зан€тый диапазон Ц объект, а не числа
   $oCursor = $Sheet.createCursor()
   MsgBox(0,"","CreatCursor")
   $oCursor.gotoStartOfUsedArea(False)
   MsgBox(0,"","StartofArea")
   $oStart = $oCursor.getRangeAddress() ; объект
   MsgBox(0,"","rangeaddress")
   $oCursor.gotoEndOfUsedArea(False)
   MsgBox(0,"","CreatCursor")
   $oEnd = $oCursor.getRangeAddress()	; объект
   $Range = $Sheet.getCellRangeByPosition($oStart.EndColumn, $oStart.EndRow, $oEnd.EndColumn, $oEnd.EndRow)
   return $Range ; объект
EndFunc ;=== UsedRange
#endregion