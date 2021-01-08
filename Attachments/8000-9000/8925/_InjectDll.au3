#include-once

Func _InjectDll($hWnd, $dllpath)
	;make sure the user passed valid parameters
	If $hWnd <= 0 Then
		SetError(-1)
		Return False
	ElseIf StringLen($dllpath) <= 4 Or StringRight($dllpath, 4) <> ".dll" Then
		SetError(-2)
		Return False
	EndIf
	
	Local $pid, $pHandle, $pLibRemote, $modHandle, $LoadLibraryA, $hThread
	
	;open dll that we'll be using
	Local $kernel32 = DllOpen("kernel32.dll")
	
	;get the pid from the window provided
	$pid = DllCall("user32.dll", "int", "GetWindowThreadProcessId", "hwnd", $hWnd, "int_ptr", 0)
	If IsArray($pid) Then
		$pid = $pid[2]
	Else
		SetError(-3)
		Return False
	EndIf
	
	;open the process for writing
	$pHandle = DllCall($kernel32, "int", "OpenProcess", "int", 0x1F0FFF, "int", 0, "int", $pid)
	If IsArray($pHandle) And $pHandle[0] > 0 Then
		$pHandle = $pHandle[0]
	Else
		SetError(-4)
		Return False
	EndIf
	
	$pLibRemote = DllCall($kernel32, "int", "VirtualAllocEx", "int", $pHandle, "short", 0, "int", 0x1000, "int", 0x1000, "int", 4)
	If IsArray($pLibRemote) Then
		If $pLibRemote[0] > 0 Then
			;debug
			ConsoleWrite("0x" & Hex($pLibRemote[0], 8) & @CR)
			$pLibRemote = $pLibRemote[0]
		Else
			SetError(-5)
			Return False
		EndIf
	Else
		SetError(-6)
		Return False
	EndIf
	
	For $i = 0 To StringLen($dllpath)
		$ret = DllCall("kernel32.dll", "int", "WriteProcessMemory", "int", $pHandle, "int", $pLibRemote + $i, "int_ptr", Asc(StringMid($dllpath, $i + 1, 1)), "int", 1, "int", 0)
		If IsArray($ret) Then
			If $ret[0] = 0 Then
				SetError(-7)
				Return False
			EndIf
		Else
			SetError(-8)
			Return False
		EndIf
	Next
	
	$modHandle = DllCall($kernel32, "long", "GetModuleHandle", "str", "kernel32.dll")
	If IsArray($modHandle) Then
		If $modHandle[0] > 0 Then
			$modHandle = $modHandle[0]
		Else
			SetError(-9)
			Return False
		EndIf
	Else
		SetError(-10)
		Return False
	EndIf
	
	$LoadLibraryA = DllCall($kernel32, "long", "GetProcAddress", "long", $modHandle, "str", "LoadLibraryA")
	If IsArray($LoadLibraryA) Then
		If $LoadLibraryA[0] > 0 Then
			$LoadLibraryA = $LoadLibraryA[0]
		Else
			SetError(-11)
			Return False
		EndIf
	Else
		SetError (-12)
		Return False
	EndIf
	
	$hThread = DllCall($kernel32, "int", "CreateRemoteThread", "int", $pHandle, "int", 0, "int", 0, "long", $LoadLibraryA, "long", $pLibRemote, "int", 0, "int", 0)
	If IsArray($hThread) Then
		ConsoleWrite($hThread[0] & @CR)
		If $hThread[0] > 0 Then
			$hThread = $hThread[0]
		Else
			SetError(-13)
			Return False
		EndIf
	Else
		SetError(-14)
		Return False
	EndIf
	
	DllCall($kernel32, "int", "VirtualFreeEx", "int", $pHandle, "int", $pLibRemote, "int", 0x1000, "int", 0x8000)
	DllCall($kernel32, "int", "CloseHandle", "int", $hThread)
	DllCall($kernel32, "int", "CloseHandle", "int", $pHandle)
	
	DllClose($kernel32)
	
	Return True
EndFunc