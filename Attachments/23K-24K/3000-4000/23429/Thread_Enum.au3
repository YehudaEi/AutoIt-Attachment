#include <WinAPi.au3>
#include <array.au3>
Global Const $TH32CS_SNAPTHREAD = 0x00000004
Global Const $THREADENTRY32 = "dword dwSize;dword cntUsage;dword th32ThreadId;dword th32OwnerProcessID;long tpBasePri;long tpDeltaPri;dword dwFlags;"


;;; Example

$pid = ProcessExists("explorer.exe")
; Get all threads in explorer
$arr=_GetAllProcessThreads($pid)
; And display them
_ArrayDisplay($arr)

; Get all threads in the system
$arr=_GetAllThreads()
; And display them
_ArrayDisplay($arr)


;;; End of example



;;;;;;;;;;;;_GetAllThreads;;;;;;;;;;;;;;;;;;;;
; Returns info of all the threads on the system
; Reterns a 2D array with the following structure:
;
; [n][0] = th32ThreadId - Thread ID
; [n][1] = th32OwnerProcessID - Pid of owener process
; [n][2] = tpBasePri - Priority of Thread (range 0-31)
;
; More info about the function:
;
; http://msdn.microsoft.com/en-us/library/ms682489(VS.85).aspx
; http://msdn.microsoft.com/en-us/library/ms686728(VS.85).aspx
; http://msdn.microsoft.com/en-us/library/ms686735(VS.85).aspx
;
; © monoceres 2008
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Func _GetAllThreads()
	$call = DllCall("Kernel32.dll", "ptr", "CreateToolhelp32Snapshot", "dword", $TH32CS_SNAPTHREAD, "dword", 0)
	$handle = $call[0]
	Local $RetArr[1][3]
	ConsoleWrite("Handle: " & $handle & @CRLF)
	
	$te32=DllStructCreate($THREADENTRY32)
	DllStructSetData($te32,"dwSize",DllStructGetSize($te32))
	$call=DllCall("Kernel32.dll","int","Thread32First","ptr",$handle,"ptr",DllStructGetPtr($te32))
	_GetAllThreads_ArrHelper($RetArr,$te32)
	Do
		$call=DllCall("Kernel32.dll","int","Thread32Next","ptr",$handle,"ptr",DllStructGetPtr($te32))
		If Not $call[0] Then ExitLoop
		_GetAllThreads_ArrHelper($RetArr,$te32)
	Until True And False
	_ArrayDelete($RetArr,0)
	_WinAPI_CloseHandle($handle)
	Return $RetArr
EndFunc   ;==>GetAllThreads

; Same as _GetAllThreads, but with a simple pid filter
Func _GetAllProcessThreads($iPid)
		$call = DllCall("Kernel32.dll", "ptr", "CreateToolhelp32Snapshot", "dword", $TH32CS_SNAPTHREAD, "dword", 0)
	$handle = $call[0]
	Local $RetArr[1][3]
	ConsoleWrite("Handle: " & $handle & @CRLF)
	
	$te32=DllStructCreate($THREADENTRY32)
	DllStructSetData($te32,"dwSize",DllStructGetSize($te32))
	$call=DllCall("Kernel32.dll","int","Thread32First","ptr",$handle,"ptr",DllStructGetPtr($te32))
	If DllStructGetData($te32,"th32OwnerProcessID")=$iPid Then _GetAllThreads_ArrHelper($RetArr,$te32)
	Do
		$call=DllCall("Kernel32.dll","int","Thread32Next","ptr",$handle,"ptr",DllStructGetPtr($te32))
		If Not $call[0] Then ExitLoop
		If DllStructGetData($te32,"th32OwnerProcessID")=$iPid Then  _GetAllThreads_ArrHelper($RetArr,$te32)
	Until True And False
	_ArrayDelete($RetArr,0)
	_WinAPI_CloseHandle($handle)
	Return $RetArr
EndFunc


Func _GetAllThreads_ArrHelper(ByRef $Arr,$TE32_Struct)
	$ub=Ubound($Arr)
	ReDim $Arr[$ub+1][3]
	$Arr[$ub][0]=DllStructGetData($TE32_Struct,"th32ThreadId")
	$Arr[$ub][1]=DllStructGetData($TE32_Struct,"th32OwnerProcessID")
	$Arr[$ub][2]=DllStructGetData($TE32_Struct,"tpBasePri")
EndFunc
