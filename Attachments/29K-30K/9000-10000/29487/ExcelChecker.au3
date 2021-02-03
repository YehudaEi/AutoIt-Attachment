#include-once

Global Const $EXCEL_TEST_SCRIPT = @AppDataDir & "\ExcelCheck.au3"
_ExcelChecker_ExistsTest()

Func _ExcelChecker_ExistsTest ()
	If Not FileExists ($EXCEL_TEST_SCRIPT) Then 
		Local $msgString = _ 
		"In order to run correctly, I need to install the following file: " & @LF & _
		$EXCEL_TEST_SCRIPT & @LF & _
		"Can I continue?"
		
		Local $auth = MsgBox (1, "Notice", $msgString)
		If $auth = 1 Then
			_ExcelChecker_CreateFile ()
		Else
			MsgBox (0, "Understood", "No files will be installed"  & @LF & @LF & "Shutting Down")
			Exit
		EndIf
	EndIf
EndFunc

Func _ExcelChecker_CreateFile ()
	Local $source = _
	'Local $handle = ObjEvent("AutoIt.Error","dummyFunc")' & @LF & _ 
	'Local $oExcel = ObjGet("", "Excel.Application")' & @LF & _
	'$oExcel.Application.Ready' & @LF & _
	'Exit (1)' & @LF & _
	'Func dummyFunc ()' & @LF & _
	'$handle.clear()' & @LF & _
	'Exit (0)' & @LF & _
	'EndFunc' & @LF

	Local $handle = FileOpen ($EXCEL_TEST_SCRIPT, 2)
	FileWriteLine ($handle, $source)
	FileClose ($handle)
EndFunc

Func _ExcelIsOk ()
	Local $ok = (ShellExecuteWait ($EXCEL_TEST_SCRIPT) <> 0)
	If not $ok Then
		MsgBox (0, "ERROR", "You are currently editing a cell," & @LF & "and Excel doesn't like play well with others when that happens")
	EndIf
	Return $ok
EndFunc
