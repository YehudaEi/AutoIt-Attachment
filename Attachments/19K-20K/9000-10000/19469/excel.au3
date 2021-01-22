#include<ExcelCOM_UDF.au3>

$datei_1 = @ScriptDir & "\" & "Mappe1.xls"
$datei_2 = @ScriptDir & "\" & "Mappe2.xls"

$excel = _ExcelBookOpen($datei_1)
$excel = _ExcelBookOpen($datei_2)