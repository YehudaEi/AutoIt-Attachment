
#cs

_ReduceMemory UDF
by John Taylor (jftuga)
Jul-9-2005

This function, _ReduceMemory(), can reduce the amount of memory that an AutoIt compiled .exe uses by ~50%
Essentially written by several other UDFs coded by w0uter :-)

Usage: call _ReduceMemory() from your script.  If it is a GUI app, call it just before entering the event loop

See also:
http://msdn.microsoft.com/library/default.asp?url=/library/en-us/perfmon/base/emptyworkingset.asp

#ce


Global Const $PROCESS_ALL_ACCESS = 0x1f0fff

; from w0uter
; http://www.autoitscript.com/forum/index.php?showtopic=12651
Func _MemOpen($i_dwDesiredAccess, $i_bInheritHandle, $i_dwProcessId)
    Dim $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', $i_dwDesiredAccess, 'int', $i_bInheritHandle, 'int', $i_dwProcessId)
    If @error Then
        SetError(1)
        Return 0
    EndIf
    
    Return $ai_Handle[0]
EndFunc;==> _MemOpen()

; from w0uter
; http://www.autoitscript.com/forum/index.php?showtopic=13383
Func _GetPID()
	Dim $ai_GetCurrentProcessId = DllCall('kernel32.dll', 'int', 'GetCurrentProcessId')
	return $ai_GetCurrentProcessId[0]
EndFunc

; from w0uter
; http://www.autoitscript.com/forum/index.php?showtopic=13392
Func _ReduceMemory()
	Dim $Handle = _MemOpen($PROCESS_ALL_ACCESS, False, _GetPID())
	return DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $Handle)
EndFunc
