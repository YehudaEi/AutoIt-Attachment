#include <WinAPI.au3>

Global $tagHOOK = "ptr HookAddress;ubyte HookBak[7]"

Func _HookApi_Get($module, $function)
	Local $hook = DllStructCreate($tagHOOK)
	DllStructSetData($hook, "HookAddress", _GetProcAddress(_WinAPI_GetModuleHandle($module), $function))
	If DllStructGetData($hook, "HookAddress") == 0 Then Return SetError(1, 0, 1)
	Local $ret = DllCall("kernel32.dll", "int", "WriteProcessMemory", "ptr", -1, "ptr", DllStructGetPtr($hook, "HookBak"), "ptr", DllStructGetData($hook, "HookAddress"), "uint", 7, "uint*", 0)
	If $ret[5] <> 7 Then Return SetError(2, 0, 1)
	Return $hook
EndFunc

Func _HookApi_Set($hook, $newaddress)
	If Not IsDllStruct($hook) Then Return SetError(3, 0, 1)
	If Not $newaddress Then Return SetError(4, 0, 1)
	; create hook struct
	Local $_MFHook = DllStructCreate("ubyte[7]")
	DllStructSetData($_MFHook, 1, Binary("0xB8") + Binary("0x" & _ConvertAddress($newaddress)) + Binary("0xFFE0"))
	; set hook
	Local $ret = DllCall("kernel32.dll", "int", "WriteProcessMemory", "ptr", -1, "ptr", DllStructGetData($hook, "HookAddress"), "ptr", DllStructGetPtr($_MFHook), "uint", 7, "uint*", 0)
	If $ret[5] <> 7 Then Return SetError(2, 0, 1)
	
	Return 0
EndFunc

Func _HookApi_UnSet($hook)
	If Not IsDllStruct($hook) Then Return SetError(3, 0, 1)
	; unset hook
	Local $ret = DllCall("kernel32.dll", "int", "WriteProcessMemory", "ptr", -1, "ptr", DllStructGetData($hook, "HookAddress"), "ptr", DllStructGetPtr($hook, "HookBak"), "uint", 7, "uint*", 0)
	If $ret[5] <> 7 Then Return SetError(2, 0, 1)
	
	Return 0
EndFunc

Func _ConvertAddress($address)
	Local $lo = Hex(BitAND($address, 0xFFFF), 4)
	Local $hi = Hex(BitShift($address, 16), 4)
	$lo = StringRight($lo, 2) & StringLeft($lo, 2)
	$hi = StringRight($hi, 2) & StringLeft($hi, 2)
	Return $lo & $hi
EndFunc

Func _GetProcAddress($module, $function)
	Local $call = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $module, "str", $function)
	Return $call[0]
EndFunc


;;;;; ShellExecuteExW returns an int and has one param - a pointer to a SHELLEXECUTEINFO struct
$MyTest = DllCallbackRegister("MyTest", "int", "ptr")
$MyTestAddress = DllCallbackGetPtr($MyTest)

; Get the new hook structure
$hook = _HookApi_Get("shell32.dll", "ShellExecuteExW")
; Set the hook, passing the previous structure with the new address
_HookApi_Set($hook, $MyTestAddress)

;; Lets try ShellExecute something
ShellExecute(FileOpenDialog("All files", "", "All files (*.*)"))

; Change back to the original ShellExecute, stored in the struct
_HookApi_UnSet($hook)
; Free the callback
DllCallbackFree($MyTest)

;; Lets try ShellExecute something again
ShellExecute(FileOpenDialog("All files", "", "All files (*.*)"))

Func MyTest($ptr)
	; SHELLEXECUTEINFO struct
	Local $SHELLEXECUTEINFO = DllStructCreate("dword;ulong;hwnd;ptr;ptr;ptr;ptr;int;ptr;ptr;ptr;ptr;dword;ptr;ptr;", $ptr)
	Local $wstring = DllStructCreate("wchar[255]", DllStructGetData($SHELLEXECUTEINFO, 5))
	MsgBox(0, "Shellexecute hook", "AutoIt tried to shellexecute: " & DllStructGetData($wstring, 1) & @CRLF & "However we put a stop to that, didn't we?")
	Return 0
EndFunc   ;==>MyTest