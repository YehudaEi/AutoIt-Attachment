#include <winapi.au3>
#include <Memory.au3>

Global Const $PROCESS_CREATE_THREAD = (0x0002)
Global Const $PROCESS_VM_OPERATION = (0x0008)
Global Const $PROCESS_VM_WRITE = (0x0020)


$processname = InputBox("Victim", "Name/PID of process to inject the code into")
If $processname = "" Then Exit
$hProcess = _WinAPI_OpenProcess(BitOR($PROCESS_CREATE_THREAD, $PROCESS_VM_OPERATION, $PROCESS_VM_WRITE),False,ProcessExists($processname))


$ret = RemoteMsgBox($hProcess, 65, "Hello World!", "I'm executing from " & $processname & @CRLF & ":)")

MsgBox(0, "Call completed", "The code was executed." & @CRLF & "Return code: " & $ret)

Func RemoteMsgBox($hProcess, $iFlag, $sTitle, $sBody, $hWnd = 0)

	; This holds the strings that's going to be used in the calls.
	$DataBuffer = DllStructCreate("wchar modulename[11];char function[12];" & _
			"wchar title[" & StringLen($sTitle) + 1 & "];wchar body[" & StringLen($sBody) + 1 & "]")

	DllStructSetData($DataBuffer, "modulename", "User32.dll")
	DllStructSetData($DataBuffer, "function", "MessageBoxW")
	DllStructSetData($DataBuffer, "title", $sTitle)
	DllStructSetData($DataBuffer, "body", $sBody)

	; Allocate memory in target process with READWRITE access (for the strings)
	$RemoteData = _MemVirtualAllocEx($hProcess, 0, sizeof($DataBuffer), $MEM_COMMIT, $PAGE_READWRITE)
	If Not $RemoteData Then Return MsgBox(16, "Epic Failure", "Failed to allocate memory in process!")

	; These two functions have the same address in all processes. Therefor we can query them in our process first.
	$Loadlibrary = DllCall("Kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("Kernel32.dll"), "str", "LoadLibraryW")
	$Loadlibrary = $Loadlibrary[0]

	$GetProcAddress = DllCall("Kernel32.dll", "ptr", "GetProcAddress", "ptr", _WinAPI_GetModuleHandle("Kernel32.dll"), "str", "GetProcAddress")
	$GetProcAddress = $GetProcAddress[0]


	; Buffer to store the actual machine code in. Exactly 48 bytes is needed for this call.
	$CodeBuffer = DllStructCreate("byte[48]")

	; Allocate memory for the machine code, we need execute access as well.
	$RemoteCode = _MemVirtualAllocEx($hProcess, 0, sizeof($CodeBuffer), $MEM_COMMIT, $PAGE_EXECUTE_READWRITE)

	; Build the code, for opcode reference see: http://www.intel.com/design/PentiumII/manuals/243191.htm
	DllStructSetData($CodeBuffer, 1, _
			"0x" & _
			"68" & SwapEndian($RemoteData) & _ 														; push RemoteData.modulename
			"B8" & SwapEndian($Loadlibrary) & _ 													; mov eax,LoadLibrary
			"FFD0" & _ 																				; call eax
			"68" & SwapEndian($RemoteData + (_ptr($DataBuffer, "function") - _ptr($DataBuffer))) & _ 	; push RemoteData.function
			"50" & _ 																				; push eax
			"B8" & SwapEndian($GetProcAddress) & _	 												; mov eax,GetProcAddress
			"FFD0" & _ 																				; call eax
			"68" & SwapEndian($iFlag) & _ 															; push iFlag
			"68" & SwapEndian($RemoteData + (_ptr($DataBuffer, "title") - _ptr($DataBuffer))) & _ 		; push sTitle
			"68" & SwapEndian($RemoteData + (_ptr($DataBuffer, "body") - _ptr($DataBuffer))) & _ 		; push sBody
			"68" & SwapEndian($hWnd) & _ 															; push hWnd
			"FFD0" & _ 																				; call eax
			"C3") ; Ret


	; Write the code & data to the target process.
	Local $written
	_WinAPI_WriteProcessMemory($hProcess, $RemoteCode, _ptr($CodeBuffer), sizeof($CodeBuffer), $written)
	_WinAPI_WriteProcessMemory($hProcess, $RemoteData, _ptr($DataBuffer), sizeof($DataBuffer), $written)

	; Create thread in the target process. The start address is of course our injected code
	$call = DllCall("Kernel32.dll", "int", "CreateRemoteThread", "ptr", $hProcess, "ptr", 0, "int", 0, "ptr", $RemoteCode, "ptr", 0, "int", 0, "dword*", 0)
	$hThread = $call[0]

	; Wait for the code to finish executing.
	_WinAPI_WaitForSingleObject($hThread)

	; We're polite guests so we clean up after ourselves.
	_MemVirtualFreeEx($hProcess, $RemoteCode, sizeof($CodeBuffer), $MEM_RELEASE)

	; Get the return value and return. Mission Successful
	$call = DllCall("Kernel32.dll", "ptr", "GetExitCodeThread", "ptr", $hThread, "dword*", 0)
	Return $call[2]
EndFunc   ;==>RemoteMsgBox


Func sizeof($s)
	Return DllStructGetSize($s)
EndFunc   ;==>sizeof

Func _ptr($s, $e = "")
	If $e <> "" Then Return DllStructGetPtr($s, $e)
	Return DllStructGetPtr($s)
EndFunc   ;==>_ptr

Func SwapEndian($hex)
	Return Hex(BitOR(BitOR(BitOR(BitShift($hex, 24), _
			BitAND(BitShift($hex, -8), 0x00FF0000)), _
			BitAND(BitShift($hex, 8), 0x0000FF00)), _
			BitShift($hex, -24)), 8)
EndFunc   ;==>SwapEndian