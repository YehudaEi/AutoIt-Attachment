#Tidy_Parameters=/reel
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#AutoIt3Wrapper_Run_Before=Variable_list.exe %in%

#include <array.au3>
#include "DumpDebuging.au3"

Global $string = 'This is a string with a @TAB' & @TAB & 'and it ends with @CRLF' & @CRLF
Global $array[11]
Global $binary = StringToBinary($string)
Global $bool = True
Global $false = False
Global $float = 12.01
Global $hex = Hex(13)
Global $hwnd = WinGetHandle("[CLASS:Shell_TrayWnd]")
Global $int = 14
Global $keyword = Default
Global $number = Number(15.01)
Global $ptr = Ptr(16)
Global $struct = DllStructCreate('char[' & 65536 & ']')
Global $true = True

_Dump_Accident_OnOff(True)
_Dump_AccidentToFile_OnOff(True)

_Dump_OnExit_OnOff(True)
_Dump_OnExitToFile_OnOff(True)

_Dump_OnExitDisplayAllData_OnOff(True)

For $i = 0 To 3
	$int = $i
	$array[$i] = Chr(65 + $i)
	_Dump_ToMsgBox('Test $int changing:')
Next

_test_Main()

_Dump_ChangeLogFile(@ScriptFullPath & '___Accident.log')
MsgBox(0, 'Accident', $__aDump_FuncNames[40])
Exit

Func _test_Main()
	_Dump_ToMsgBox('_test_Main : 1')
	_Dump_ToConsole('_test_Main : 1')

	_test_Func_1()
	_Dump_ToMsgBox('_test_Func_1')
	_test_Func_2(True)
	_Dump_ToMsgBox('_test_Func_2:True')
	_test_Func_2(False)
	_Dump_ToMsgBox('_test_Func_2:False')
	_Dump_ToConsole('_test_Func_2:False')
	_test_Func_3()
	_Dump_ToMsgBox('_test_Func_3')
	_Dump_ToFile('_test_Func_3')
	_test_Func_4()
	_Dump_ToMsgBox('_test_Func_4')
EndFunc   ;==>_test_Main

Func _test_Func_1()
EndFunc   ;==>_test_Func_1

Func _test_Func_2($fTest)
	If $fTest Then
		Return
	Else
;~
	EndIf
	Return 'abc'
EndFunc   ;==>_test_Func_2

Func _test_Func_3()
EndFunc   ;==>_test_Func_3

Func _test_Func_4()
EndFunc   ;==>_test_Func_4
