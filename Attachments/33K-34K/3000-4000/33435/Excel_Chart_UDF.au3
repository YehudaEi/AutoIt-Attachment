#include-once

#include <Excel.au3>
#include <Array.au3>

#Region ; === Charttypes ===
Global Const $xl3DArea = -4098
Global Const $xl3DLine = -4101
Global Const $xl3DPie = -4102
Global Const $xlDoughnut = -4120
Global Const $xlXYScatter = -4169
Global Const $xlArea = 1
Global Const $xlPie = 5
Global Const $xlBubble = 15
Global Const $xlColumnClustered = 51
Global Const $xlColumnStacked = 52
Global Const $xlColumnStacked100 = 53
Global Const $xl3DColumnClustered = 54
Global Const $xl3DColumnStacked = 55
Global Const $xl3DColumnStacked100 = 56
Global Const $xlBarClustered = 57
Global Const $xlBarStacked = 58
Global Const $xlBarStacked100 = 59
Global Const $xl3DBarClustered = 60
Global Const $xl3DBarStacked = 61
Global Const $xl3DBarStacked100 = 62
Global Const $xlLineStacked = 63
Global Const $xlLineStacked100 = 64
Global Const $xlLineMarkers = 65
Global Const $xlLineMarkersStacked = 66
Global Const $xlLineMarkersStacked100 = 67
Global Const $xlPieOfPie = 68
Global Const $xlPieExploded = 69
Global Const $xl3DPieExploded = 70
Global Const $xlBarOfPie = 71
Global Const $xlXYScatterSmooth = 72
Global Const $xlXYScatterSmoothNoMarkers = 73
Global Const $xlXYScatterLines = 74
Global Const $xlXYScatterLinesNoMarkers = 75
Global Const $xlAreaStacked = 76
Global Const $xlAreaStacked100 = 77
Global Const $xl3DAreaStacked = 78
Global Const $xl3DAreaStacked100 = 79
Global Const $xlDoughnutExploded = 80
Global Const $xlRadarMarkers = 81
Global Const $xlRadarFilled = 82
Global Const $xlSurface = 83
Global Const $xlSurfaceWireframe = 84
Global Const $xlSurfaceTopView = 85
Global Const $xlSurfaceTopViewWireframe = 86
Global Const $xlBubble3DEffect = 87
Global Const $xlStockHLC = 88
Global Const $xlStockOHLC = 89
Global Const $xlStockVHLC = 90
Global Const $xlStockVOHLC = 91
Global Const $xlCylinderColClustered = 92
Global Const $xlCylinderColStacked = 93
Global Const $xlCylinderColStacked100 = 94
Global Const $xlCylinderBarClustered = 95
Global Const $xlCylinderBarStacked = 96
Global Const $xlCylinderBarStacked100 = 97
Global Const $xlCylinderCol = 98
Global Const $xlConeColClustered = 99
Global Const $xlConeColStacked = 100
Global Const $xlConeColStacked100 = 101
Global Const $xlConeBarClustered = 102
Global Const $xlConeBarStacked = 103
Global Const $xlConeBarStacked100 = 104
Global Const $xlConeCol = 105
Global Const $xlPyramidColClustered = 106
Global Const $xlPyramidColStacked = 107
Global Const $xlPyramidColStacked100 = 108
Global Const $xlPyramidBarClustered = 109
Global Const $xlPyramidBarStacked = 110
Global Const $xlPyramidBarStacked100 = 111
Global Const $xlPyramidCol = 112
#EndRegion ; === Charttypes ===

Global Const $xlLegendPositionBottom = -4107
Global Const $xlLegendPositionRight = -4152
Global Const $xlLegendPositionTop = -4160
Global Const $xlLegendPositionCorner = 2
Global Const $xlRows = 2
Global Const $xlPrimary = 1
Global Const $xlSecondary = 2

; #FUNCTION# ====================================================================================================================
; Name...........: 	_CreateExcelSheetWithChart
; Description ...: 	Creates an Excel File with a chart.
; Syntax.........: 	_CreateExcelWithChart($aData, $sFilename, $sSheetname, $iCharttype, [$iLabels = 0, [$sExtraaxis = 0, [$sHeadline = "", [$sXHeadline = "", [$sY1Headline = "", [$sY2Headline = ""]]]]]])
; Parameters ....: 	$aData 		-	A 2-dimenional array containing the data from [1][1] to [n1][n2]; the value for "n1" should be stored in [0][0]; the value for "n2" should be stored in [0][1]
;					$sFilename	-	Path and name of the file that should be created. Existing files will be overwritten!
;					$sSheetname	-	Name of the sheet that will be created. If the sheet already exists, the action will fail!
;					$iCharttype	-	Type of chart that should be created; see global constants for a list
;					$iLabels	-	Set to 1 to show labels next to datapoints
;					$sExtraaxis	-	List of colum IDs that should be added to a secondary (extra) axis. Set to 0 for unconfigured. Example: "2|4" => columns 2 and 4 will be associated with secondary axis
;					$sHeadline	-	Headline of the chart. Set to 0 fo unconfigured.
;					$sXHeadline	-	Headline of the X-Axis of the chart. Set to 0 fo unconfigured.
;					$sY1Headline	-	Headline of the Primary Y-Axis of the chart. Set to 0 fo unconfigured.
;					$sY3Headline	-	Headline of the Secondary Y-Axis of the chart. Set to 0 fo unconfigured.
; Return values .: 	1 - Success; 2 - Excel object could not be created (probably file is in use); 3 - Excel COM object could not be created
; Author ........: 	Hannes
; Related .......: 	Excel.au3
;
; ===============================================================================================================================

Func _CreateExcelSheetWithChart($a_data, $s_filename, $s_sheetname, $i_charttype, $labels = 0, $extraaxis = 0, $headline = "", $x_headline = "", $y1_headline = "", $y2_headline = "")
	$debug = 0
	$debugc = 1
	$OffLang = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Office\9.0\Common\LanguageResources","UILanguage")
	If $OffLang = 1031 Then
		$s_Hfont = "&Arial,Fett&"
	Else
		$s_Hfont = "&Arial,Bold&"
	EndIf

	If Not FileExists($s_filename) Then
		cw($debugc, "File does not exist! => " & $s_filename)
		Local $oExcel = _ExcelBookNew($debug)
		If $oExcel = 0 Then
			SetError(@error)
			cw($debugc, "_ExcelBookNew() returned error: " & @error)
			Return 2
		EndIf
		$a_sheet = _ExcelSheetList($oExcel)
		cw($debugc, "Result of listing of sheets was " & IsArray($a_sheet))
		cw($debugc, "List of sheets: " & @TAB & _ArrayToString($a_sheet, "|", 1))
		$rc = _ExcelSheetAddNew($oExcel, $s_sheetname)
		cw($debugc, "Result of adding of new sheet " & $s_sheetname & " was " & $rc)
		For $i = 1 To $a_sheet[0]
			$rc = _ExcelSheetDelete($oExcel, $a_sheet[$i])
			cw($debugc, "Result of deleting sheet " & $a_sheet[$i] & " was " & $rc)
		Next
		$a_sheet = _ExcelSheetList($oExcel)
		cw($debugc, "Result of listing of sheets was " & IsArray($a_sheet))
		cw($debugc, "List of sheets: " & @TAB & _ArrayToString($a_sheet, "|", 1))
	Else
		cw($debugc, "File does already exist! Adding...")
		Local $oExcel = _ExcelBookOpen($s_filename, $debug)
		If $oExcel = 0 Then
			SetError(@error)
			cw($debugc, "_ExcelBookOpen() returned error: " & @error)
			Return 2
		EndIf
		$a_sheet = _ExcelSheetList($oExcel)
		cw($debugc, "Result of listing of sheets was " & IsArray($a_sheet))
		cw($debugc, "List of sheets: " & @TAB & _ArrayToString($a_sheet, "|", 1))
		If _ArraySearch($a_sheet, $s_sheetname) > 0 Then
			SetError(@error)
			cw($debugc, "There is already a sheet called " & $s_sheetname)
			_ExcelBookClose($oExcel)
			Return 3
		EndIf
		$rc = _ExcelSheetAddNew($oExcel, $s_sheetname)
		cw($debugc, "Result of adding of new sheet " & $s_sheetname & " was " & $rc)
		$a_sheet = _ExcelSheetList($oExcel)
		cw($debugc, "Result of listing of sheets was " & IsArray($a_sheet))
		cw($debugc, "List of sheets: " & @TAB & _ArrayToString($a_sheet, "|", 1))
	EndIf
	Local $i = 0

	$k = 1
	$rc = ""
	For $i = 1 To $a_data[0][0]
		For $j = 1 To $a_data[0][1]
			_ExcelWriteCell($oExcel, $a_data[$i][$j], $i, $j)
			$rc &= $k & ":" & @error & "| "
			$k += 1
		Next
	Next
	cw($debugc, "Results of writing data to sheet: " & $rc)

	$oExcel.ActiveSheet.Range(_calcColumn(1) & 1 & ":" & _calcColumn($a_data[0][1]) & $a_data[0][0] ).Select

	cw($debugc, "Range marked")
	For $i = 1 To $a_data[0][1]
		$oExcel.Columns( _calcColumn($i) & ":" & _calcColumn($i) ).EntireColumn.AutoFit
		cw($debugc, "Column " & _calcColumn($i) & " autofitted")
	Next

	Dim $a_borders[7] = [6, $xlEdgeLeft, $xlEdgeTop, $xlEdgeRight, $xlEdgeBottom, $xlInsideVertical, $xlInsideHorizontal]
	For $i = 1 To $a_borders[0]
		With $oExcel.Selection.Borders($a_borders[$i])
			.LineStyle = $xlContinuous
			.Weight = $xlThin
			.ColorIndex = $xlAutomatic
		EndWith
	Next

	cw($debugc, "Painted borders")

	$oExcel.Charts.Add
	cw($debugc, "Added Chart")
	$oExcel.ActiveChart.Location($xlLocationAsObject, $a_sheet[1])
	cw($debugc, "Moved Chart as inlied object ti sheet: " & $a_sheet[1])
	$oExcel.ActiveChart.ChartType = $i_charttype
	cw($debugc, "Assigned charttype: " & $i_charttype)
	$oExcel.ActiveChart.SetSourceData($oExcel.Sheets($a_sheet[1] ).Range(_CalcColumn(1) & 1 & ":" & _calcColumn($a_data[0][1]) & $a_data[0][0]), $xlRows)
	cw($debugc, "Set source data for chart")
	$oExcel.ActiveChart.Axes($xlCategory).Select
	cw($debugc, "Select ""X"" axis")
	With $oExcel.Selection.TickLabels
		.Alignment = $xlCenter
		.Offset = 100
		.Orientation = 60
	EndWith
	cw($debugc, "Alligned chars in X-Axis to 60°")

	If $labels = 1 Then
		$oExcel.ActiveChart.ApplyDataLabels(2, False)
		cw($debugc, "Applied labels to data")
	EndIf
	$a_temp = StringSplit($extraaxis, "|")
	For $i = 1 To $a_temp[0]
		If $a_temp[$i] > 0 And $a_temp[$i] <= $a_data[0][1] Then
			$axis = $a_temp[$i] + 1 - 1
			$oExcel.ActiveChart.SeriesCollection($axis).Select
			$oExcel.ActiveChart.SeriesCollection($axis).AxisGroup = 2
			cw($debugc, "Moved data in column " & $a_temp[$i] & " to secondary ""Y"" axis")
		EndIf
	Next

	With $oExcel.ActiveChart.Axes($xlValue)
		.MinimumScale = 0
		.MaximumScale = 100
	EndWith
	cw($debugc, "Setted maximum scale of first ""Y"" axis to 100")

	$oExcel.ActiveChart.ChartArea.Select

	With $oExcel.ActiveChart
		If $headline <> "" Then
			.HasTitle = True
			.ChartTitle.Characters.Text = $headline
			cw($debugc, "Added headline to chart")
		EndIf
		If $x_headline <> "" Then
			.Axes($xlCategory, $xlPrimary).HasTitle = True
			.Axes($xlCategory, $xlPrimary).AxisTitle.Characters.Text = $x_headline
			cw($debugc, "Added headline to ""X"" axis")
		EndIf
		If $y1_headline <> "" Then
			.Axes($xlValue, $xlPrimary).HasTitle = True
			.Axes($xlValue, $xlPrimary).AxisTitle.Characters.Text = $y1_headline
			cw($debugc, "Added headline to ""Y1"" axis")
		EndIf
		If $y2_headline <> "" Then
			.Axes($xlValue, $xlSecondary).HasTitle = True
			.Axes($xlValue, $xlSecondary).AxisTitle.Characters.Text = $y2_headline
			cw($debugc, "Added headline to ""Y2"" axis")
		EndIf
	EndWith

	$oExcel.ActiveChart.ChartArea.Select
	$oExcel.ActiveSheet.Shapes(1).IncrementLeft(-500)
	cw($debugc, "Move chart on sheet leftmost")
	$oExcel.ActiveSheet.Shapes(1).IncrementTop(-500)
	cw($debugc, "Move chart on sheet topmost")

	$oExcel.ActiveSheet.Shapes(1).IncrementTop(12.75 * $a_data[0][0] + 20)
	cw($debugc, "Move chart on sheet under data printed earlier")

	$oExcel.ActiveSheet.Shapes(1).Width = (9.8 * 72)
    $oExcel.ActiveSheet.Shapes(1).Height = (5.4 * 72)
	cw($debugc, "Scale width...")

	With $oExcel.ActiveSheet.PageSetup
		cw($debugc, "Page setup")
		If $headline <> "" Then
			.CenterHeader = $s_Hfont & 18 & "&" & $headline
			cw($debugc, "Format headline")
		EndIf
		.LeftFooter = "&F" & @CRLF & "&A"
		.CenterFooter = "Page &P of &N"
		.RightFooter = "&D&T"
		.PrintHeadings = False
		.PrintGridlines = False
;~ 		.PrintQuality = 600
		.CenterHorizontally = False
		.CenterVertically = False
;~         .Orientation = $xlLandscape
		.Draft = False
;~         .PaperSize = $xlPaperA4
		.Zoom = False
		.FitToPagesWide = 1
		.FitToPagesTall = 1
	EndWith
	cw($debugc, "Page setup")

	$rc = _ExcelBookSaveAs($oExcel, $s_filename, "xls", 0, 1)
	cw($debugc, "Error on SaveAs: " & @TAB & @error )
	If $rc <> 1 Then
		SetError(@error)
		Return 4
	EndIf
	$rc = _ExcelBookClose($oExcel)
	cw($debugc, "Error on Close: " & @TAB & @error )
	If $rc <> 1 Then
		SetError(@error)
		Return 5
	EndIf
	Return 1
EndFunc   ;==>_CreateExcelSheetWithChart


; #FUNCTION# ====================================================================================================================
; Name...........: 	_CalcColumn
; Description ...: 	Calculates / Transforms integers to excel columntitles (e.g. 1 => A; 27 => AA).
; Syntax.........: 	_CalcColumn($iColumn)
; Parameters ....: 	$iColumn	-	An integer between 1 and 702 (Range "A" to "ZZ")
; Return values .:	A 1 to 2-character string
; Author ........: 	Hannes Reinauer <info at hannes08 dot de>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: 	No
; ===============================================================================================================================

Func _CalcColumn($int)
	$j = 0
	$k = 0
	$l = 0
	$m = 0
	For $i = 1 To $int
		$j += 1
		If $j = 27 Then
			$j = 1
			$k += 1
			If $k = 27 Then
				$k = 1
				$l += 1
				If $l = 27 Then
					$l = 1
					$m += 1
				EndIf
			EndIf
		EndIf
	Next
	Select
		Case $m > 0
			Return Chr(64 + $m) & Chr(64 + $l) & Chr(64 + $k) & Chr(64 + $j)
		Case $l > 0
			Return Chr(64 + $l) & Chr(64 + $k) & Chr(64 + $j)
		Case $k > 0
			Return Chr(64 + $k) & Chr(64 + $j)
		Case $j > 0
			Return Chr(64 + $j)
	EndSelect

EndFunc   ;==>_CalcColumn

; #FUNCTION# ====================================================================================================================
; Name...........: 	cw
; Description ...: 	Prints Messages to the console depending on the loglevel.
; Syntax.........: 	cw($iLoglevel, $sMessage)
; Parameters ....: 	$iLoglevel	-	An integer valued 0 or 1; 0 - no message will be printed; 1 - message will be printed
;					$sMessage	-	A String that will be printed.
; Return values .:	none
; Author ........: 	Hannes Reinauer <info at hannes08 dot de>
; Modified.......:
; Remarks .......:
; Related .......:  ConsoleWrite
; Link ..........:
; Example .......: 	No
; ===============================================================================================================================
Func cw($loglevel, $message)
	If $loglevel > 0 Then ConsoleWrite($message & @CRLF)
EndFunc   ;==>cw
