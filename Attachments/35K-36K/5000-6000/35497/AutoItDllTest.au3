
$dll = DllOpen("AutoItTestDll.dll")
if (@error) Then FatalError("Unable to open DLL")

$result = DllCall($dll, "int", "TestFunc", "int", 3, "int", 4)
if (@error) Then FatalError("Error calling DLL: " & @error)

DllClose($dll)

Func FatalError($msg)
    MsgBox(0, "Fatal Error", $msg)
    Exit
EndFunc