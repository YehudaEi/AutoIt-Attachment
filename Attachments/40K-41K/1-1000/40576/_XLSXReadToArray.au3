#include-once

; #UDF# =======================================================================================================================
; Title .........: XLSX Read To Array
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: Fuction Reads the EXCEL XLSX Sheet into an Array
; Author(s) .....: DXRW4E
; Notes .........:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;~ _XLSXReadToArray
;~ _XLSXSheetGetColumnNumber
;~ _SSNToDate
;~ _DateToSSN
;~ _FileListToArrayEx
; ===============================================================================================================================

If Not ObjEvent("AutoIt.Error") Then Global Const $_XLSXZip_COMErrorFunc = ObjEvent("AutoIt.Error", "_XLSXZip_COMErrorFunc")
Global $DateSSN[27] = [0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31, 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335]

; #FUNCTION# ================================================================================================================================
; Name...........: _XLSXReadToArray
; Description ...: The _XLSXReadToArray Fuction Reads the EXCEL XLSX Sheet into an Array
; Syntax.........: _XLSXReadToArray($XLSXFilePath, $iFlag)
; Parameters ....: $XLSXFilePath - Path and filename of the XLSX file to be read.
;                  $iFlag   - Optional
;                  |$iFlag = 0 (Default) None
;                  |$iFlag = 1 if there are also add HyperLinks in the Array
;                    Strings\Test in Column\Rows will separate from HyperLink by @LF, example "Value" & @LF & http://www.autoitscript.com/forum/
;                  |$Cols   - Optional, Columns Number to Read (read only X column)
;                  |$Rows   - Optional, Rows Number to Read (read only X Row)
;                  |$iSheet - Optional, Number of Sheet*.xml to Read, Default is 1
; Return values .: Success  - Return
;                    Array ($Array[0][0] = Rows Number & @Extended = Column Nmmber)
;                    If Set $Cols and $Rows Return is String Data, if Return Strigs = "" @Extended is Set to 1
;                  @Error - Set Error
;                  |1 = XLSX file not found or invalid (Can not Read\Extract XLSX file)
;                  |2 = [Content_Types].xml not found or invalid
;                  |3 = sheet1.xml file not found or invalid
;                  |4 = Sheet Dimension Not found Or is Greater than 15999999 (Array Size Limit)
;                  |5 = No SheetDate (Columns & Rows) Found
; Author ........: DXRW4E
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: __XLSXReadToArray("C:\file.xlsx")
; Note ..........:
; ===========================================================================================================================================
Func _XLSXReadToArray($XLSXFilePath, $iFlag = 0, $Cols = 0, $Rows = 0, $iSheet = 1)
	If ($Cols * ($Rows + 1)) > 15999999 Then Return SetError(4, 0, "")
	Local $XLSXExtractDir = @WindowsDir & "\Temp\XLSX_" & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC & @MSEC, $XLSXZip, $oShell, $X

	$XLSXZip = FileCopy($XLSXFilePath, $XLSXExtractDir & "\__xlsx.zip", 9)
	If Not $XLSXZip Then Return SetError(1, DirRemove($XLSXExtractDir, 1), "")
	$oShell = ObjCreate("shell.application")
	$oShell.Namespace($XLSXExtractDir).CopyHere($oShell.Namespace($XLSXExtractDir & "\__xlsx.zip").items, 20)

	Local $ContentTypesXML = StringReplace(FileRead($XLSXExtractDir & "\[Content_Types].xml"), "/", "\", 0, 1)
	If Not $ContentTypesXML Then
		$ContentTypesXML = _FileListToArrayEx($XLSXExtractDir, "*Content*Types*.xml", 37)
		If Not @Error Then $ContentTypesXML = StringReplace(FileRead($XLSXExtractDir & "\" & $ContentTypesXML[0]), "/", "\", 0, 1)
		If Not $ContentTypesXML Then Return SetError(2, DirRemove($XLSXExtractDir, 1), "")
	EndIf
	Local $SharedStringsXMLPath = StringRegExp($ContentTypesXML, '(?si)<Override\s*PartName="([^"]*\\sharedStrings\.xml)"', 1)
	If @Error Then $SharedStringsXMLPath = _FileListToArrayEx($XLSXExtractDir, "sharedStrings.xml", 165)
	If Not @Error Then $SharedStringsXMLPath = $XLSXExtractDir & $SharedStringsXMLPath[0]
	Local $SheetXMLPath = StringRegExp($ContentTypesXML, '(?si)<Override\s*PartName="([^"]*\\sheet' & $iSheet & '\.xml)"', 1)
	If @Error Then $SheetXMLPath = _FileListToArrayEx($XLSXExtractDir, "sheet" & $iSheet & ".xml", 165)
	If @Error Then $SheetXMLPath = StringRegExp($ContentTypesXML, '(?si)<Override\s*PartName="([^"]*\\sheet[^"]*\.xml)"', 1)
	If @Error Then $SheetXMLPath = _FileListToArrayEx($XLSXExtractDir, "sheet*.xml", 165)
	If Not @Error Then $SheetXMLPath = $XLSXExtractDir & $SheetXMLPath[0]

	Local $WorkSheet = FileRead($SheetXMLPath)
	If Not $WorkSheet Then Return SetError(3, DirRemove($XLSXExtractDir, 1), "")
	Local $SharedStringsXML = FileRead($SharedStringsXMLPath)

	;;  	Example Get File Path using the StringRegExpReplace(), but more slowly than StringRegExp Mod.
	;;  Local $WorkBookXMLPath = $XLSXExtractDir & StringRegExpReplace($ContentTypesXML, '(?si).*<Override\s+PartName="([^"]*\\workbook\.xml)".*', "$1")
	;;  Local $StylesXMLPath = $XLSXExtractDir & StringRegExpReplace($ContentTypesXML, '(?si).*<Override\s+PartName="([^"]*\\styles\.xml)".*', "$1")
	;;  Local $SharedStringsXMLPath = $XLSXExtractDir & StringRegExpReplace($ContentTypesXML, '(?si).*<Override\s+PartName="([^"]*\\sharedStrings\.xml)".*', "$1")
	;;  Local $SheetXMLPath = $XLSXExtractDir & StringRegExpReplace($ContentTypesXML, '(?si).*<Override\s+PartName="([^"]*\\sheet1\.xml)".*', "$1")
	;;
	;;	  ;; read other ect ect ect
	;;  Local $WorkBookXMLPath = StringRegExp($ContentTypesXML, '(?si)<Override\s*PartName="([^"]*\\workbook\.xml)"', 1)
	;;  If @Error Then $WorkBookXMLPath = _FileListToArrayEx($XLSXExtractDir, "workbook.xml", 165)
	;; 	If Not @Error Then $WorkBookXMLPath = $XLSXExtractDir & $WorkBookXMLPath[0]
	;;  $WorkBookXML = FileRead($WorkBookXMLPath)
	;;    ;Example using the StringRegExpReplace()
	;;	Local $SheetName = $XLSXExtractDir & StringRegExpReplace($WorkBookXML, '(?si).*<sheet\s+name="([^"]*)".*', "$1")
	;;
	;;  Local $AppXMLPath = StringRegExp($ContentTypesXML, '(?si)<Override\s*PartName="([^"]*\\app\.xml)"', 1)
	;;  If @Error Then $AppXMLPath = _FileListToArrayEx($XLSXExtractDir, "app.xml", 165)
	;; 	If Not @Error Then $AppXMLPath = $XLSXExtractDir & $AppXMLPath[0]
	;;  $AppXML = FileRead($AppXMLPath)
	;;    ;Example using the StringRegExpReplace()
	;;	Local $AppVersion = $XLSXExtractDir & StringRegExpReplace($AppXML, '(?si).*<AppVersion>([^<]*)</AppVersion>.*', "$1")
	;;
	;;  Local $CoreXMLPath = StringRegExp($ContentTypesXML, '(?si)<Override\s*PartName="([^"]*\\core\.xml)"', 1)
	;;  If @Error Then $CoreXMLPath = _FileListToArrayEx($XLSXExtractDir, "core.xml", 165)
	;; 	If Not @Error Then $CoreXMLPath = $XLSXExtractDir & $CoreXMLPath[0]
	;;  $CoreXML = FileRead($CoreXMLPath)
	;;    ;Example using the StringRegExpReplace()
	;;	Local $Modified = $XLSXExtractDir & StringRegExpReplace($CoreXML, '(?si).*<dcterms\:modified[^>]([^<]*)</dcterms:modified>.*', "$1")
	;;
	;;  Local $StylesXMLPath = StringRegExp($ContentTypesXML, '(?si)<Override\s*PartName="([^"]*\\styles\.xml)"', 1)
	;;  If @Error Then $StylesXMLPath = _FileListToArrayEx($XLSXExtractDir, "styles.xml", 165)
	;;  If Not @Error Then $StylesXMLPath = $XLSXExtractDir & $StylesXMLPath[0]
	;;	$StylesXML = FileRead($StylesXMLPath)
	;;  ;ect ect ect ect
	;;
	;;  Local $SheetViews = StringRegExp($WorkSheet, '(?si)<sheetView\s+tabSelected="([^"]*)".*?\sworkbookViewId="([^"]*)".*?\stopLeftCell="([A-Z]{1,3})([0-9]+)".*?\sactiveCell="([A-Z]{1,3})([0-9]+)".*?\sdefaultRowHeight="([^"]*)"', 1)
	;;  If @Error Then Local $SheetViews[7]
	;;  $SheetViews[2] = _XLSXSheetGetColumnNumber($SheetViews[2])
	;;  $SheetViews[4] = _XLSXSheetGetColumnNumber($SheetViews[4])
	;;  ;;;;  $SheetViews....
	;;  ;;;;	$SheetViews[0] = tabSelected
	;;  ;;;;	$SheetViews[1] = workbookViewId
	;;  ;;;;	$SheetViews[2] = top Left Cell - Column Number
	;;  ;;;;	$SheetViews[3] = top Left Cell - Rows Nmmber
	;;  ;;;;	$SheetViews[4] = active Cell - Column Number
	;;  ;;;;	$SheetViews[5] = active Cell - Rows Nmmber
	;;  ;;;;	$SheetViews[6] = default Row Height
	DirRemove($XLSXExtractDir, 1)
	Local $nCols = Number($Cols), $nRows = "[0-9]+", $X = StringRegExp($WorkSheet, '(?si)<([^:><]*:?)?worksheet\s+', 1)
	If Not @Error Then $X = $X[0]
	If $Rows > 0 Then	;;;;	StringRegExp($WorkSheet, '(?s)<' & $X & 'row\s+r="' & $Rows  & '".*?</' & $X & 'row>', 1)
		$nRows = $Rows
		$Rows = 1
	EndIf
	Local $SheetDimension = StringRegExp($WorkSheet, '(?si)<' & $X & '(?:dimension|autoFilter)\s+ref="([A-Z]{1,3})([0-9]+):([A-Z]{1,3})(?i)([0-9]+)', 1)
	If Not @Error Then
		$Cols = _XLSXSheetGetColumnNumber($SheetDimension[2])
		If $nRows = "[0-9]+" Then $Rows = $SheetDimension[3]
	EndIf
	$SheetDimension = StringRegExp($WorkSheet, '(?si)<' & $X & 'col\s+min="?(\d+)[^>]*></' & $X & 'cols>', 1)
	If Not @Error And $SheetDimension[0] > $Cols Then $Cols = $SheetDimension[0]
	If $nRows = "[0-9]+" Then
		$SheetDimension = StringRegExp($WorkSheet, '(?si).*<' & $X & 'c\s+r="?[A-Z]*(\d+)', 1)
		If Not @Error And $SheetDimension[0] > $Rows Then $Rows = $SheetDimension[0]
	EndIf
	If $nCols > ($Cols + 1) Then Return SetError(5, 0, "")
	If $Cols < 1 Or $Rows < 1 Or ($Cols * ($Rows + 1)) > 15999999 Then Return SetError(4, 0, "")
	Local $SheetData = StringRegExp($WorkSheet, '(?s)<' & $X & 'c\s+r="([A-Z]{1,3})(?i)(' & $nRows & ')"\s*(?:s=")?([0-9]*)"?\s*(?:t=")?([^">]*)"?\s*><' & $X & 'v>([^<]*)\s*</' & $X & 'v>\s*</' & $X & 'c>', 3)
	If @Error Then Return SetError(5, 0, "")
	If $nCols Then $Cols = 1
	Local $SheetDataA[($Rows + 1)][$Cols] = [[UBound($SheetData) - 1]], $ColumnName, $ColumnNumber, $ColumnSize, $SharedStringsXMLSize
	If $SharedStringsXML Then
		Local $S = StringRegExp($SharedStringsXML, '(?si)<([^:><]*:?)?sst\s+', 1)
		If Not @Error Then $S = $S[0]
		$SharedStringsXML = StringRegExp($SharedStringsXML, '(?si)<' & $S & 'si>(?:<' & $S & 'r>.*?)?<' & $S & 't(?:/|\s[^>]*)?>(.*?)(?:</' & $S & 't>)?(?:</' & $S & 'r>)?</' & $S & 'si>', 3)
		If Not @Error Then
			$SharedStringsXMLSize = UBound($SharedStringsXML)
			For $i = 0 To $SharedStringsXMLSize - 1
				If StringInStr($SharedStringsXML[$i], "<", 1) Then $SharedStringsXML[$i] = StringRegExpReplace($SharedStringsXML[$i], '</' & $S & 't>.*?<' & $S & 't>', "")
				If StringInStr($SharedStringsXML[$i], "&", 1) Then $SharedStringsXML[$i] = StringReplace(StringReplace(StringReplace($SharedStringsXML[$i], "&lt;", "<", 0, 1), "&gt;", ">", 0, 1), "&amp;", "&", 0, 1)
			Next
		EndIf
	EndIf
	For $i = 0 To $SheetDataA[0][0] Step 5
		$ColumnSize = StringLen($SheetData[$i]) - 1
		If Not $ColumnSize Then
			$ColumnNumber = Asc($SheetData[$i]) - 65
		Else
			$ColumnName = StringToASCIIArray($SheetData[$i])
			$ColumnNumber = $ColumnName[$ColumnSize] - 65
			$ColumnNumber += 26 * ($ColumnName[$ColumnSize - 1] - 64)	;(26 ^ 1) * ($ColumnName[1] - 64)
			If $ColumnSize > 1 Then $ColumnNumber += 676 * ($ColumnName[0] - 64)	;(26 ^ 2) * ($ColumnName[0] - 64)
			;;;$ColumnNumber = _XLSXSheetGetColumnNumber($SheetData[$i], 1)
		EndIf
		If $nCols Then
			If $nCols <> ($ColumnNumber + 1) Then ContinueLoop
			$ColumnNumber = 0
		EndIf
		If $Rows = 1 Then $SheetData[$i + 1] = 1
		If $SheetData[$i + 3] = "s" And $SharedStringsXMLSize > $SheetData[$i + 4] Then
			$SheetDataA[$SheetData[$i + 1]][$ColumnNumber] = $SharedStringsXML[$SheetData[$i + 4]]
		ElseIf $SheetData[$i + 2] = 2 Then
			$SheetDataA[$SheetData[$i + 1]][$ColumnNumber] = _SSNToDate($SheetData[$i + 4])
		Else
			$SheetDataA[$SheetData[$i + 1]][$ColumnNumber] = $SheetData[$i + 4]
		EndIf
	Next
	$SheetDataA[0][0] = $Rows
	If $iFlag Then
		$HyperLinks = StringRegExp($WorkSheet, '(?si)<' & $X & 'hyperlink\s+ref="([A-Z]{1,3})(?i)(' & $nRows & ')".*?\s+display="([^"]*)"', 3)
		;;$HyperLinks = StringRegExp($WorkSheet, '(?si)<' & $X & 'hyperlink\s+ref="([A-Z]{1,3})(?i)' & $nRows & '"\s+r:id="([^"]*)"\s+display="([^"]*)"', 3)
		If Not @Error Then
			Local $HyperLinksSize = UBound($HyperLinks) - 1
			For $i = 0 To $HyperLinksSize Step 3
				$ColumnNumber = _XLSXSheetGetColumnNumber($HyperLinks[$i], 1)
				If $Rows = 1 Then $HyperLinks[$i + 1] = 1
				$SheetDataA[$HyperLinks[$i + 1]][$ColumnNumber] &= @LF & $HyperLinks[$i + 2]
			Next
		EndIf
	EndIf
	If $nCols And $Rows = 1 Then Return SetError(0, $SheetDataA[1][0] = "", $SheetDataA[1][0])
	Return SetError(0, UBound($SheetDataA, 2), $SheetDataA)
EndFunc   ;==>_XLSXReadToArray


; #FUNCTION# =================================================================================================================
; Name...........: _XLSXSheetGetColumnNumber
; Description ...: The _XLSXSheetGetColumnNumber Fuction return Column Number of EXCEL XLSX Sheet
; Syntax.........: _XLSXSheetGetColumnNumber($ColumnName)
; Parameters ....: $ColumnName - [A-Z] Uppercase Caracter\String, are not Supported line with more than 3 characters
;                  $iFlag      - Optional
;                  |$iFlag = 0 (Default) Column Number
;                  |$iFlag = 1 Column Number - 1 (for Array Index 0)
; Return values .: Success  - Return Column Number
;                  Failure - @Error
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: Limit is 18278 (A = 1 & AB = 27 & ZZZ = 18278)
; Related .......:
; Link ..........:
; Example .......: _XLSXSheetGetColumnNumber("ABC")
; Note ..........:
; ============================================================================================================================
Func _XLSXSheetGetColumnNumber($ColumnName, $iFlag = 0)
	If Not StringRegExp($ColumnName, '^[A-Z]{1,3}$') Or $iFlag < 0 Or $iFlag > 1 Then Return SetError(1, 0, 0)
	Local $ColumnNumber, $SheetDimension = StringLen($ColumnName) - 1
	If Not $SheetDimension Then
		$ColumnNumber = Asc($ColumnName) - 64 - $iFlag
	Else
		$ColumnName = StringToASCIIArray($ColumnName)
		$ColumnNumber = $ColumnName[$SheetDimension] - 64 - $iFlag
		$ColumnNumber += 26 * ($ColumnName[$SheetDimension - 1] - 64)	;(26 ^ 1) * ($ColumnName[1] - 64)
		If $SheetDimension > 1 Then $ColumnNumber += 676 * ($ColumnName[0] - 64)	;(26 ^ 2) * ($ColumnName[0] - 64)
	EndIf
	Return $ColumnNumber
EndFunc   ;==>_XLSXSheetGetColumnNumber


; #FUNCTION# =================================================================================================================
; Name...........: _SSNToDate
; Description ...: The _SSNToDate Fuction return Date from sequential serial number
; Syntax.........: _SSNToDate($iDay)
; Parameters ....: $iDay - sequential serial number (generated from DATE fuction on EXCEL, example 39637 = 7/8/2008)
; Return values .: Success  - Return DATE
;                  Failure - @Error
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: DATE String is Month/Day/Year, Year - is number is 1900 to 9999
; Related .......:
; Link ..........:
; Example .......: _SSNToDate(39637)
; Note ..........:
; ============================================================================================================================
Func _SSNToDate($iDay)
	If $iDay < 1 Or $iDay > 2958465 Then Return SetError(1, 0, "")
	$DateSSN[0] = Int($iDay / 365)
	$DateSSN[25] = $DateSSN[0] / 4
	$DateSSN[26] = IsFloat($DateSSN[25])
	$iDay = $iDay - ($DateSSN[0] * 365) - Int($DateSSN[25]) - $DateSSN[26]
	If $iDay < 1 Then
		$DateSSN[0] -= 1
		$DateSSN[25] = IsInt(($DateSSN[0] -1) / 4)
		$iDay += 365 + $DateSSN[25]
		$DateSSN[26] = Int($DateSSN[25] = 0)
	EndIf
	$DateSSN[2] -= $DateSSN[26]
	For $iMonth = 1 To 11
		If $DateSSN[$iMonth] >= $iDay Then ExitLoop
		$iDay -= $DateSSN[$iMonth]
	Next
	$DateSSN[2] += $DateSSN[26]
	Return $iMonth & "/" & $iDay & "/" & (1900 + $DateSSN[0])
EndFunc   ;==>_SSNToDate


; #FUNCTION# =================================================================================================================
; Name...........: _DateToSSN
; Description ...: The _DateToSSN Fuction return sequential serial number that represent a particular Date
; Syntax.........: _DateToSSN($iYear, $iMonth, $iDay)
; Parameters ....: $iYear  - Year  - is number is 1900 to 9999
;                      Required. The value of the year argument can include one to four digits. Excel interprets the year argument
;                      according to the date system your computer is using. By default, Microsoft Excel for Windows uses the 1900 date system.
;                      We recommend using four digits for the year argument to prevent unwanted results. For example, "07" could mean "1907" or "2007." Four digit years prevent confusion.
;                      If year is between 0 (zero) and 1899 (inclusive), Excel adds that value to 1900 to calculate the year. For example, DATE(108,1,2) returns January 2, 2008 (1900+108).
;                      If year is between 1900 and 9999 (inclusive), Excel uses that value as the year. For example, _DateToSSN((2008,1,2) returns January 2, 2008.
;                      If year is less than 0 or is 10000 or greater, _DateToSSN returns the @Error
;                  $iMonth - is number is 1 to 12, If Month is less than 0 or is 13 or greater, _DateToSSN returns the @Error
;                  $iDay   - Required. A positive or negative integer representing the day of the month from 1 to 31.
;                      If day is greater than the number of days in the month specified, day adds that number of days to the first day in the month.
;                        For example, _DateToSSN(2008,1,35) returns the serial number representing February 4, 2008.
;                      If day is less than 1, day subtracts the magnitude that number of days, plus one, from the first day of the month specified.
;                        For example, _DateToSSN(2008,1,-15) returns the serial number representing December 16, 2007.
; Return values .: Success  - Return Sequential Serial Number
;                  Failure - @Error
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: Sequential Serial Number, _DateToSSN(2008, 7, 8) Return 39637, that represent 7/8/2008
;
;                    NOTE - Excel stores dates as sequential serial numbers so that they can be used in calculations. January 1, 1900 is serial number 1,
;                      and January 1, 2008 is serial number 39448 because it is 39,447 days after January 1, 1900.
;
;                    _DateToSSN NOT SUPPORT FOR NOW, THIS
;                      $iMonth  Required. A positive or negative integer representing the month of the year from 1 to 12 (January to December).
;                        If month is greater than 12, month adds that number of months to the first month in the year specified. For example,
;                        DATE(2008,14,2) returns the serial number representing February 2, 2009.
;                      If month is less than 1, month subtracts the magnitude of that number of months, plus 1, from the first month in the
;                        year specified. For example, DATE(2008,-3,2) returns the serial number representing September 2, 2007.
; Related .......:
; Link ..........:
; Example .......: _DateToSSN(39637)
; Note ..........:
; ============================================================================================================================
Func _DateToSSN($iYear, $iMonth, $iDay)
	If $iYear < 1900 Or $iYear > 9999 Or $iMonth < 1 Or $iMonth > 12 Then Return SetError(1, 0, "")
	$iYear -= 1900
	$DateSSN[0] = $iYear / 4
	If IsFloat($DateSSN[0]) And $iMonth < 3 Then $iDay += 1
	Return ($iYear * 365) + Int($DateSSN[0]) + $DateSSN[$iMonth + 12] + $iDay
EndFunc   ;==>_DateToSSN


; #FUNCTION# =======================================================================================================================================================
; Name...........: _FileListToArrayEx
; Description ...: Lists files and\or folders in a specified path (Similar to using Dir with the /B Switch)
; Syntax.........: _FileListToArrayEx($sPath[, $sFilter = "*"[, $iFlag = 0]])
; Parameters ....: $sPath   - Path to generate filelist for.
;                  $sFilter - Optional the filter to use, default is *. (Multiple filter groups such as "All "*.png|*.jpg|*.bmp") Search the Autoit3 helpfile for the word "WildCards" For details.
;                  $iFlag   - Optional: specifies whether to return files folders or both Or Full Path (add the flags together for multiple operations):
;                  |$iFlag = 0 (Default) Return both files and folders
;                  |$iFlag = 1 Return files only
;                  |$iFlag = 2 Return Folders only
;                  |$iFlag = 4 Search SubDirectory
;                  |$iFlag = 8 Return Full Path
;                  |$iFlag = 16 $sFilter do Case-Sensitive matching (By Default $sFilter do Case-Insensitive matching)
;                  |$iFlag = 32 Disable the return the count in the first element - effectively makes the array 0-based (must use UBound() to get the size in this case).
;                    By Default the first element ($array[0]) contains the number of file found, the remaining elements ($array[1], $array[2], etc.)
;                  |$iFlag = 64 $sFilter is REGEXP Mod, See Pattern Parameters in StringRegExp (Can not be combined with flag 16)
;                  |$iFlag = 128 Return Backslash at the beginning of the file name, example Return "\Filename1.xxx" (Can not be combined with flag 8)
; Return values .: Failure - @Error
;                  |1 = Path not found or invalid
;                  |2 = Invalid $sFilter
;                  |3 = No File(s) Found
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: The array returned is one-dimensional and is made up as follows:
;                                $array[0] = Number of Files\Folders returned
;                                $array[1] = 1st File\Folder
;                                $array[2] = 2nd File\Folder
;                                $array[3] = 3rd File\Folder
;                                $array[n] = nth File\Folder
; Related .......:
; Link ..........:
; Example .......: Yes
; Note ..........: Special Thanks to SolidSnake & Tlem
; ==================================================================================================================================================================
Func _FileListToArrayEx($sPath, $sFilter = "*", $iFlag = 0)
    $sPath = StringRegExpReplace($sPath & "\", "[\\/]+", "\\")
    If Not FileExists($sPath) Then Return SetError(1, 1, "")
	If StringRegExp($sFilter, StringReplace('^\s*$|\v|[\\/:><"]|^\||\|\||\|$', "[" & Chr(BitAND($iFlag, 64) + 28) & '\/:><"]|^\||\|\||\|$', "\\\\")) Then Return SetError(2, 2, "")
	Local $hSearch, $sFile, $sFileList, $sSubDir = BitAND($iFlag, 4), $sDelim = "|", $sDirFilter = StringReplace($sFilter, "*", "")
    $hSearch = FileFindFirstFile($sPath & "*")
    If @Error Then Return SetError(3, 3, "")
	Local $hWSearch = $hSearch, $hWSTMP, $SearchWD, $Extended, $iFlags = StringReplace(BitAND($iFlag, 1) + BitAND($iFlag, 2), "3", "0")
	If BitAND($iFlag, 8) Then $sDelim &= $sPath
	If BitAND($iFlag, 128) Then $sDelim = "|\"
	If Not BitAND($iFlag, 64) Then $sFilter = StringRegExpReplace(BitAND($iFlag, 16) & "(?i)(", "16\(\?\i\)|\d+", "") & StringRegExpReplace(StringRegExpReplace(StringRegExpReplace(StringRegExpReplace($sFilter, "[^*?|]+", "\\Q$0\\E"), "\\E(?=\||$)", "$0\$"), "(?<=^|\|)\\Q", "^$0"), "\*+", ".*") & ")"
	While 1
        $sFile = FileFindNextFile($hWSearch)
        If @Error Then
            If $hWSearch = $hSearch Then ExitLoop
            FileClose($hWSearch)
            $hWSearch -= 1
            $SearchWD = StringLeft($SearchWD, StringInStr(StringTrimRight($SearchWD, 1), "\", 1, -1))
        ElseIf $sSubDir Then
            $Extended = @Extended
            If ($iFlags + $Extended <> 2) Then
                If $sDirFilter Then
                    If StringRegExp($sFile, $sFilter) Then $sFileList &= $sDelim & $SearchWD & $sFile
                Else
                    $sFileList &= $sDelim & $SearchWD & $sFile
                EndIf
            EndIf
            If Not $Extended Then ContinueLoop
            $hWSTMP = FileFindFirstFile($sPath & $SearchWD & $sFile & "\*")
            If $hWSTMP = -1 Then ContinueLoop
            $hWSearch = $hWSTMP
            $SearchWD &= $sFile & "\"
        Else
            If ($iFlags + @Extended = 2) Or StringRegExp($sFile, $sFilter) = 0 Then ContinueLoop
            $sFileList &= $sDelim & $sFile
        EndIf
    WEnd
    FileClose($hSearch)
    If Not $sFileList Then Return SetError(3, 3, "")
	Return StringSplit(StringTrimLeft($sFileList, 1), "|", StringReplace(BitAND($iFlag, 32), "32", 2))
EndFunc   ;==>_FileListToArrayEx


Func _XLSXZip_COMErrorFunc()
    Return SetError(1, 0, "")
EndFunc   ;==>_XLSXZip_COMErrorFunc

