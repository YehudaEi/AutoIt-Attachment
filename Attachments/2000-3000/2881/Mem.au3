Global Const $MEM_O = 0x8
Global Const $MEM_R = 0x10
Global Const $MEM_W = 0x20

Func _MemOpen($i_dwDesiredAccess, $i_bInheritHandle, $i_dwProcessId)
	
	$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', $i_dwDesiredAccess, 'int', $i_bInheritHandle, 'int', $i_dwProcessId)
	If @error Then
		SetError(1)
		Return 0
	EndIf
	
	Return $ai_Handle[0]
EndFunc ;==> _MemOpen()

Func _MemRead($i_hProcess, $i_lpBaseAddress, $i_nSize, $v_lpNumberOfBytesRead = '')
	
	Local $v_Struct = DllStructCreate ('byte[' & $i_nSize & ']')
	DllCall('kernel32.dll', 'int', 'ReadProcessMemory', 'int', $i_hProcess, 'int', $i_lpBaseAddress, 'int', DllStructGetPtr ($v_Struct, 1), 'int', $i_nSize, 'int', $v_lpNumberOfBytesRead)
	
	Local $v_Return = DllStructGetData ($v_Struct, 1)
	
	DllStructDelete ($v_Struct)
	
	Return $v_Return
	
EndFunc ;==> _MemRead()

Func _MemWrite($i_hProcess, $i_lpBaseAddress, $v_Inject, $i_nSize, $v_lpNumberOfBytesRead = '')
	
	Local $v_Struct = DllStructCreate ('byte[' & $i_nSize & ']')
	DllStructSetData ($v_Struct, 1, $v_Inject)
	
	$i_Call = DllCall('kernel32.dll', 'int', 'WriteProcessMemory', 'int', $i_hProcess, 'int', $i_lpBaseAddress, 'int', DllStructGetPtr ($v_Struct, 1), 'int', $i_nSize, 'int', $v_lpNumberOfBytesRead)
	
	DllStructDelete ($v_Struct)
	
	Return $i_Call[0]
	
EndFunc ;==> _MemWrite()

Func _MemClose($i_hProcess)
	
	$av_CloseHandle = DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $i_hProcess)
	Return $av_CloseHandle[0]
	
EndFunc ;==> _MemClose()


#cs
$v_Open = _MemOpen($MEM_R, False, ProcessExists('winmine.exe'))
$v_Read = _MemRead($v_Open, 0x1005330, 1)
$v_Close = _MemClose($v_Open)

ConsoleWrite('$v_Open:  ' & $v_Open & @LF)
ConsoleWrite('$v_Read:  ' & $v_Read & @LF)
ConsoleWrite('$v_Close: ' & $v_Open & @CRLF)

$v_Open = _MemOpen($MEM_W + $MEM_O, False, ProcessExists('winmine.exe'))
$v_Read = _MemWrite($v_Open, 0x1005330, 0x20, 1)
$v_Close = _MemClose($v_Open)

ConsoleWrite('$v_Open:  ' & $v_Open & @LF)
ConsoleWrite('$v_Read:  ' & $v_Read & @LF)
ConsoleWrite('$v_Close: ' & $v_Open & @CRLF)

$v_Open = _MemOpen($MEM_R, False, ProcessExists('winmine.exe'))
$v_Read = _MemRead($v_Open, 0x1005330, 1)
$v_Close = _MemClose($v_Open)

ConsoleWrite('$v_Open:  ' & $v_Open & @LF)
ConsoleWrite('$v_Read:  ' & $v_Read & @LF)
ConsoleWrite('$v_Close: ' & $v_Open & @CRLF)
#ce