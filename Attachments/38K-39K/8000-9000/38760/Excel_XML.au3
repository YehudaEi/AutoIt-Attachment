#include-once

; #INDEX# =======================================================================================================================
; Title .........: Excel XML
; UDF Version ...: 1.0.0.1
; AutoIt Version : 3.3.8.1
; Description ...: Creates Excel XML files
; Author(s) .....: FireFox (d3mon)
; Dll ...........: None
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $sExcelXML_Header_Author = "AutoIt3"
Global $sExcelXML_Header_Created = @YEAR & "-" & @MON & "-" & @MDAY & "T" & @HOUR & ":" & @MIN & ":" & @SEC
Global $sExcelXML_Header_Compagny = "-"

Global $aExcelXML_Body_Cell[1][4], $iExcelXML_Body_RowCount = 0, $aExcelXML_Body_Column[1][2], $aExcelXML_CellStyle_Color[1], $aExcelXML_DefaultStyle[1]

Global $iExcelXML_RedimStep = 1000 ;if you are working with huge data, you should increase this value
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_ExcelXML_Row_Add
;_ExcelXML_Cell_Add
;_ExcelXML_Cell_SetColor
;_ExcelXML_Style_SetHorizontalAlign
;_ExcelXML_Column_SetWidth
;_ExcelXML_SetAuthor
;_ExcelXML_SetCreated
;_ExcelXML_SetCompagny
;_ExcelXML_Assemble
;_ExcelXML_Destroy
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_Row_Add
; Description ...: Adds a row
; Syntax.........: _ExcelXML_Row_Add()
; Parameters ....: None
; Return values .: Success      - Row index
;                  Failure      -
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......:
; Related .......: _ExcelXML_Cell_Add
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_Row_Add()
	$iExcelXML_Body_RowCount += 1

	Return $iExcelXML_Body_RowCount
EndFunc   ;==>_ExcelXML_Row_Add

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_Cell_Add
; Description ...: Adds a Cell
; Syntax.........: _ExcelXML_Cell_Add($iExcelXML_Param_Row, $sExcelXML_Param_CellContent)
; Parameters ....: $iExcelXML_Param_Row			- Row index (int)
;				   $sExcelXML_Param_CellContent	- Cell content (various)
; Return values .: Success      - Cell index
;                  Failure      -
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......:
; Related .......: _ExcelXML_Row_Add
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_Cell_Add($iExcelXML_Param_Row, $sExcelXML_Param_CellContent)
	Local $sExcelXML_ContentType, $iExcelXML_CellCount

	If StringIsInt($sExcelXML_Param_CellContent) Then
		$sExcelXML_ContentType = "Number"
	Else
		$sExcelXML_ContentType = "String"
	EndIf

	$iExcelXML_CellCount = $aExcelXML_Body_Cell[0][0]

	If $iExcelXML_CellCount = UBound($aExcelXML_Body_Cell) - 1 Then
		ReDim $aExcelXML_Body_Cell[$iExcelXML_CellCount + $iExcelXML_RedimStep][4]
	EndIf

	$aExcelXML_Body_Cell[$iExcelXML_CellCount + 1][0] = $iExcelXML_Param_Row
	$aExcelXML_Body_Cell[$iExcelXML_CellCount + 1][1] = $sExcelXML_Param_CellContent
	$aExcelXML_Body_Cell[$iExcelXML_CellCount + 1][2] = $sExcelXML_ContentType

	$aExcelXML_Body_Cell[0][0] += 1

	Return $iExcelXML_CellCount
EndFunc   ;==>_ExcelXML_Cell_Add

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_Cell_SetColor
; Description ...: Sets a cell color
; Syntax.........: _ExcelXML_Cell_SetColor($iExcelXML_Param_Cell, $iExcelXML_Param_Color)
; Parameters ....: $iExcelXML_Param_Cell	- Cell index (int)
;				   $iExcelXML_Param_Color	- Cell color (hex, dec)
; Return values .: None
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......:
; Related .......: _ExcelXML_Cell_Add
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_Cell_SetColor($iExcelXML_Param_Cell, $iExcelXML_Param_Color)
	Local $blExcelXML_ColorFound = False, $hexExcelXML_Color = Hex($iExcelXML_Param_Color, 6)

	For $iExcelXML_StyleColor = 1 To $aExcelXML_CellStyle_Color[0]
		If $aExcelXML_CellStyle_Color[$iExcelXML_StyleColor] = $hexExcelXML_Color Then
			$blExcelXML_ColorFound = True
			ExitLoop
		EndIf
	Next

	If Not $blExcelXML_ColorFound Then
		Local $iExcelXML_ColorCount = $aExcelXML_CellStyle_Color[0]

		If $iExcelXML_ColorCount = UBound($aExcelXML_CellStyle_Color) - 1 Then
			ReDim $aExcelXML_CellStyle_Color[$iExcelXML_ColorCount + $iExcelXML_RedimStep]
		EndIf

		$aExcelXML_CellStyle_Color[$iExcelXML_ColorCount + 1] = $hexExcelXML_Color

		$aExcelXML_CellStyle_Color[0] += 1
	EndIf

	$aExcelXML_Body_Cell[$iExcelXML_Param_Cell][3] = $hexExcelXML_Color
EndFunc   ;==>_ExcelXML_Cell_SetColor

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_Style_SetHorizontalAlign
; Description ...: Sets cells horinzontal align
; Syntax.........: _ExcelXML_Style_SetHorizontalAlign($sExcelXML_Param_HorizontalAlign)
; Parameters ....: $sExcelXML_Param_HorizontalAlign	- Cells horizontal align (string)
; Return values .: None
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......: Horizontal align can take the following values :
;				   Center, Left, Right, Fill, Justify, CenterAcrossSelection, Distributed
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_Style_SetHorizontalAlign($sExcelXML_Param_HorizontalAlign)
	$aExcelXML_DefaultStyle[0] = $sExcelXML_Param_HorizontalAlign
EndFunc   ;==>_ExcelXML_Style_SetHorizontalAlign

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_Column_SetWidth
; Description ...: Sets a column width
; Syntax.........: _ExcelXML_Column_SetWidth($iExcelXML_Param_Index, $iExcelXML_Param_Width)
; Parameters ....: $iExcelXML_Param_Index	- Column index (int)
;				   $iExcelXML_Param_Width	- Column width (int, float)
; Return values .: None
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_Column_SetWidth($iExcelXML_Param_Index, $iExcelXML_Param_Width)
	Local $blExcelXML_ColumnFound = False, $iExcelXML_ColumnCount = -1

	$iExcelXML_ColumnCount = $aExcelXML_Body_Column[0][0]

	For $iExcelXML_Column = 1 To $iExcelXML_ColumnCount
		If $aExcelXML_Body_Column[$iExcelXML_Column][0] = $iExcelXML_Param_Index Then
			$blExcelXML_ColumnFound = True
			ExitLoop
		EndIf
	Next

	If $blExcelXML_ColumnFound Then
		$aExcelXML_Body_Column[$iExcelXML_Column][1] = $iExcelXML_Param_Width
	Else
		If $iExcelXML_ColumnCount = UBound($aExcelXML_Body_Column) - 1 Then
			ReDim $aExcelXML_Body_Column[$iExcelXML_ColumnCount + $iExcelXML_RedimStep][2]
		EndIf

		$aExcelXML_Body_Column[$iExcelXML_ColumnCount + 1][0] = $iExcelXML_Param_Index
		$aExcelXML_Body_Column[$iExcelXML_ColumnCount + 1][1] = $iExcelXML_Param_Width

		$aExcelXML_Body_Column[0][0] += 1
	EndIf
EndFunc   ;==>_ExcelXML_Column_SetWidth

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_SetAuthor
; Description ...: Sets the author of the Excel XML
; Syntax.........: _ExcelXML_SetAuthor($sExcelXML_Param_Author)
; Parameters ....: $sExcelXML_Param_Author	- Author (various)
; Return values .: None
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_SetAuthor($sExcelXML_Param_Author)
	$sExcelXML_Header_Author = $sExcelXML_Param_Author
EndFunc   ;==>_ExcelXML_SetAuthor

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_SetCreated
; Description ...: Sets the creation date of the Excel XML
; Syntax.........: _ExcelXML_SetCreated($sExcelXML_Param_Created)
; Parameters ....: $sExcelXML_Param_Created	- Creation date (string)
; Return values .: None
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......: Creation date must take the following syntax : Year - Month - MDay T HOUR : MIN : SEC
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_SetCreated($sExcelXML_Param_Created)
	$sExcelXML_Header_Created = $sExcelXML_Param_Created
EndFunc   ;==>_ExcelXML_SetCreated

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_SetCompagny
; Description ...: Sets the compagny name of the Excel XML
; Syntax.........: _ExcelXML_SetCompagny($sExcelXML_Param_Compagny)
; Parameters ....: $sExcelXML_Param_Compagny	- Compagny name (string)
; Return values .: None
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_SetCompagny($sExcelXML_Param_Compagny)
	$sExcelXML_Header_Compagny = $sExcelXML_Param_Compagny
EndFunc   ;==>_ExcelXML_SetCompagny

; #FUNCTION# ====================================================================================================================
; Name...........: _ExcelXML_Assemble
; Description ...: Assembles the Excel XML
; Syntax.........: _ExcelXML_Assemble()
; Parameters ....: None
; Return values .: Assembled Excel XML
; Author ........: FireFox (d3mon)
; Modified.......:
; Remarks .......:
; Related .......: _ExcelXML_Destroy
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ExcelXML_Assemble()
	Local $sExcelXML_Assembly = '<?xml version="1.0"?>' & @CRLF & _
			'<?mso-application progid="Excel.Sheet"?>' & @CRLF & _
			'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' & @CRLF & _
			'xmlns:o="urn:schemas-microsoft-com:office:office"' & @CRLF & _
			'xmlns:x="urn:schemas-microsoft-com:office:excel"' & @CRLF & _
			'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' & @CRLF & _
			'xmlns:html="http://www.w3.org/TR/REC-html40">' & @CRLF & _
			'<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' & @CRLF & _
			'<Author>' & $sExcelXML_Header_Author & '</Author>' & @CRLF & _
			'<LastAuthor>' & $sExcelXML_Header_Author & '</LastAuthor>' & @CRLF & _
			'<Created>' & $sExcelXML_Header_Created & '</Created>' & @CRLF & _
			'<Company>' & $sExcelXML_Header_Compagny & '</Company>' & @CRLF & _
			'<Version>12.00</Version>' & @CRLF & _
			'</DocumentProperties>' & @CRLF & _
			'<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' & @CRLF & _
			'<WindowHeight>8640</WindowHeight>' & @CRLF & _
			'<WindowWidth>18735</WindowWidth>' & @CRLF & _
			'<WindowTopX>240</WindowTopX>' & @CRLF & _
			'<WindowTopY>30</WindowTopY>' & @CRLF & _
			'<ProtectStructure>False</ProtectStructure>' & @CRLF & _
			'<ProtectWindows>False</ProtectWindows>' & @CRLF & _
			'</ExcelWorkbook>' & @CRLF & _
			'<Styles>' & @CRLF & _
			'<Style ss:ID="Default" ss:Name="Normal">'

	If $aExcelXML_DefaultStyle[0] <> "" Then
		$sExcelXML_Assembly &= '<Alignment ss:Horizontal="' & $aExcelXML_DefaultStyle[0] & '" ss:Vertical="Bottom"/>' & @CRLF
	Else
		$sExcelXML_Assembly &= '<Alignment ss:Vertical="Bottom"/>' & @CRLF
	EndIf

	$sExcelXML_Assembly &= _
			'<Borders/>' & @CRLF & _
			'<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' & @CRLF & _
			'<Interior/>' & @CRLF & _
			'<NumberFormat/>' & @CRLF & _
			'<Protection/>' & @CRLF & _
			'</Style>'

	For $iStyleColor = 1 To $aExcelXML_CellStyle_Color[0]
		$sExcelXML_Assembly &= '<Style ss:ID="' & $aExcelXML_CellStyle_Color[$iStyleColor] & '">' & @CRLF & _
				'<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#' & $aExcelXML_CellStyle_Color[$iStyleColor] & '"/>' & @CRLF & _
				'</Style>' & @CRLF
	Next

	$sExcelXML_Assembly &= '</Styles>' & @CRLF & _
			'<Worksheet ss:Name="Feuil1">' & @CRLF & _
			'<Table ss:ExpandedColumnCount="' & $aExcelXML_Body_Cell[0][0] & '" ss:ExpandedRowCount="' & $iExcelXML_Body_RowCount & '"' & @CRLF & _
			'x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="60" ss:DefaultRowHeight="15">' & @CRLF

	For $iExcelXML_Column = 1 To $aExcelXML_Body_Column[0][0]
		$sExcelXML_Assembly &= '<Column ss:Index="' & $aExcelXML_Body_Column[$iExcelXML_Column][0] & '" ss:Width="' & $aExcelXML_Body_Column[$iExcelXML_Column][1] & '"/>' & @CRLF
	Next

	For $iExcelXML_BodyRow = 1 To $iExcelXML_Body_RowCount
		$sExcelXML_Assembly &= '<Row ss:AutoFitHeight="0">' & @CRLF

		For $iExcelXML_BodyCell = 1 To $aExcelXML_Body_Cell[0][0]
			If $aExcelXML_Body_Cell[$iExcelXML_BodyCell][0] = $iExcelXML_BodyRow Then
				If $aExcelXML_Body_Cell[$iExcelXML_BodyCell][3] <> "" Then
					$sExcelXML_Assembly &= '<Cell ss:StyleID="' & $aExcelXML_Body_Cell[$iExcelXML_BodyCell][3] & '"><Data ss:Type="' & $aExcelXML_Body_Cell[$iExcelXML_BodyCell][2] & '">' & $aExcelXML_Body_Cell[$iExcelXML_BodyCell][1] & '</Data></Cell>' & @CRLF
				Else
					$sExcelXML_Assembly &= '<Cell><Data ss:Type="' & $aExcelXML_Body_Cell[$iExcelXML_BodyCell][2] & '">' & $aExcelXML_Body_Cell[$iExcelXML_BodyCell][1] & '</Data></Cell>' & @CRLF
				EndIf
			EndIf
		Next

		$sExcelXML_Assembly &= '</Row>' & @CRLF
	Next

	$sExcelXML_Assembly &= '</Table>' & @CRLF & _
			'</Worksheet>' & @CRLF & _
			'</Workbook>'

	Return $sExcelXML_Assembly
EndFunc   ;==>_ExcelXML_Assemble

Func _ExcelXML_Destroy()
	Dim $aExcelXML_Body_Cell[1][4]
	$iExcelXML_Body_Row = 0
	Dim $aExcelXML_Body_Column[1][2]
	Dim $aExcelXML_CellStyle_Color[1]
EndFunc   ;==>_ExcelXML_Destroy