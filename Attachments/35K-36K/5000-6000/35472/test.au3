#include <IE.au3>
#include <Excel.au3>
#include <String.au3>

$oExcel = _ExcelBookAttach(@ScriptDir & "\gipshut.xlsx")
If @error Then
	MsgBox(0, "Error", "Failed to attach to the Excel file.")
	Exit
Else
	MsgBox(0, "test", "test")
	_ExcelWriteCell($oExcel, "test", 1, 6)
	$test = _ExcelReadCell($oExcel, 1, 5)
	ConsoleWrite($test)
	Exit
EndIf