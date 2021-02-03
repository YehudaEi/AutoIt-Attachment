#Include <Excel.au3>
$sFilePath1 = "Y:\IN\PAYE1.CSV"
$oExcel = _ExcelBookOpen($sFilePath1)

#Include <Array.au3>
$aArray = _ExcelReadSheetToArray($oExcel) ;Using Default Parameters
_ExcelBookClose($oExcel) ; And finally we close out
_ArrayDisplay($aArray, "Array using Default Parameters")



$sSearch = "PAYE"
If @error Then Exit

$iIndex = _ArraySearch($aArray, $sSearch)

If @error Then
    MsgBox(0, "Not Found", '"' & $sSearch & '" was not found in the array.')
Else
    MsgBox(0, "Found", '"' & $sSearch & '" was found in the array at position ' & $iIndex & ".")


	$sEnd = 3
	$payeref = _ArrayToString($aArray,",",$iIndex,$sEnd)
	msgbox(0, "PAYE Ref", $payeref)

EndIf

