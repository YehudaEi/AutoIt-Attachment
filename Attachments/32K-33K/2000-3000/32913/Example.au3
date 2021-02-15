_ThreadStart("_Thread1")
_ThreadStart("_Thread2")

MsgBox(0, "", "Mainscript")

Func _Thread1($vDummy)
	MsgBox(0, "", "Thread 1")
EndFunc   ;==>_Thread1

Func _Thread2($vDummy)
	MsgBox(0, "", "Thread 2")
EndFunc   ;==>_Thread2

Func _ThreadStart($sFunctionName)
	Local $h1, $h2, $h3 = DllStructCreate("hwnd[1]"), $h4 = DllStructGetPtr($h3)

	$h1 = DllCallbackRegister($sFunctionName, "int", "int")
	$h2 = DllStructCreate("int")
	$h3 = DllCall("Kernel32.dll", "hwnd", "CreateThread", "ptr", 0, _
			"int", 0, _
			"ptr", DllCallbackGetPtr($h1), _
			"int", 0, _
			"int", 0, _
			"ptr", DllStructGetPtr($h2))
	DllStructSetData($h3, 1, $h3[0], 1)
	DllCall("Kernel32.dll", "int", "CloseHandle", "hwnd", DllStructGetData($h3, 1, 1))
EndFunc   ;==>_ThreadStart