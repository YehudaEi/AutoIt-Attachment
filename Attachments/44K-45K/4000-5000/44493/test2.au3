#include <Excel.au3>
#include <Array.au3>
#include <File.au3>

$sFilePath1 = @ScriptDir & "\rebindtest.xls"
$sFilePath2 = @ScriptDir & "\test.txt"
$oExcel = _ExcelBookOpen($sFilePath1)
$aArray = _ExcelReadSheetToArray($oExcel)


For $results = 0 To UBound($aArray) - 1
	$chain = $aArray[$results][1]
	$store = $aArray[$results][2]
	FileCopy(@ScriptDir & "\testsource\st" & $store & 'in.' & $chain, @ScriptDir & "\testinis\" & $chain & "-" & $store & ".ini")

Next

For $results = 0 To UBound($aArray) - 1
	$chain = $aArray[$results][1]
	$store = $aArray[$results][2]
Local $GS1 = IniReadSection(@ScriptDir & "\testinis\" & $chain & "-" & $store & ".ini", "Group1")
For $Group1 = 1 To $GS1[0][0]
FileWrite($sFilePath2 ,  $GS1[$Group1][0] & " " & $GS1[$Group1][1] & @LF)
Next
Next
_ExcelBookClose($oExcel)


;ConsoleWrite ($chain & "-" & $store & @LF)
;Next
 ; And finally we close out

;Func Group1()

;EndFunc
