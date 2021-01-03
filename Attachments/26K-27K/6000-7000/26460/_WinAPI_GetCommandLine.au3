#include <WinAPI.au3>   ; _GetPrivilege_SEDEBUG() uses this include. My function needs none.
#include <array.au3>    ; Needed to display array in example. Not needed by Func.

#RequireAdmin ; Reported to be of use on Vista, getting more info from protected processes...

; ############# Needed Constants ###################
Global Const $PROCESS_VM_READ=0x10
Global Const $PROCESS_QUERY_INFORMATION = 0x400

; ############ Example code #######################
;_GetPrivilege_SEDEBUG() ; I need this for tricky processes. Not needed for most...
;$list=ProcessList()
;Redim $list[ubound($list,1)][3]
;for $i=1 to ubound($list,1)-1
;    $list[$i][2]=_WinAPI_GetCommandLineFromPID($list[$i][1])
;Next
;_ArrayDisplay($list)
;Exit
; ###############################################



; ############ Here be func! ####################

Func _WinAPI_GetCommandLineFromPID($PID)
    $ret1=DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', $PROCESS_VM_READ+$PROCESS_QUERY_INFORMATION, 'int', False, 'int', $PID)
    $tag_PROCESS_BASIC_INFORMATION = "int ExitStatus;" & _
                                     "ptr PebBaseAddress;" & _
                                     "ptr AffinityMask;" & _
                                     "ptr BasePriority;" & _
                                     "ulong UniqueProcessId;" & _
                                     "ulong InheritedFromUniqueProcessId;"
    $PBI=DllStructCreate($tag_PROCESS_BASIC_INFORMATION)
    DllCall("ntdll.dll", "int", "ZwQueryInformationProcess", "hwnd", $ret1[0], "int", 0, "ptr", DllStructGetPtr($PBI), "int", _
                                                                                                DllStructGetSize($PBI), "int",0)
    $dw=DllStructCreate("ptr")
    DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
                            "ptr", DllStructGetData($PBI,2)+0x10, _ ; PebBaseAddress+16 bytes <-- ptr _PROCESS_PARAMETERS
                            "ptr", DllStructGetPtr($dw), "int", 4, "ptr", 0)
    $unicode_string = DllStructCreate("ushort Length;ushort MaxLength;ptr String")
    DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
                                 "ptr", DllStructGetData($dw, 1)+0x40, _ ; _PROCESS_PARAMETERS+64 bytes <-- ptr CommandLine Offset (UNICODE_STRING struct) - Win XP / Vista.
                                 "ptr", DllStructGetPtr($unicode_string), "int", DllStructGetSize($unicode_string), "ptr", 0)
    $ret=DllCall("kernel32.dll", "int", "ReadProcessMemory", "hwnd", $ret1[0], _
                                 "ptr", DllStructGetData($unicode_string, "String"), _ ; <-- ptr Commandline Unicode String
                                 "wstr", 0, "int", DllStructGetData($unicode_string, "Length") + 2, "int*", 0) ; read Length + terminating NULL (2 bytes in unicode)
    DllCall("kernel32.dll", 'int', 'CloseHandle', "hwnd", $ret1[0])
    If $ret[5] Then Return $ret[3]   ; If bytes returned, return commandline...
    Return ""                     ; Getting empty string is correct behaviour when there is no commandline to be had...
EndFunc



; ####################### Below Func is Part of example - Needed to get commandline from more processes. ############
; ####################### Thanks for this function, wraithdu! (Didn't know it was your.) smile.gif #########################

Func _GetPrivilege_SEDEBUG()
    Local $tagLUIDANDATTRIB = "int64 Luid;dword Attributes"
    Local $count = 1
    Local $tagTOKENPRIVILEGES = "dword PrivilegeCount;byte LUIDandATTRIB[" & $count * 12 & "]" ; count of LUID structs * sizeof LUID struct
    Local $TOKEN_ADJUST_PRIVILEGES = 0x20
    Local $call = DllCall("advapi32.dll", "int", "OpenProcessToken", "ptr", _WinAPI_GetCurrentProcess(), "dword", $TOKEN_ADJUST_PRIVILEGES, "ptr*", "")
    Local $hToken = $call[3]
    $call = DllCall("advapi32.dll", "int", "LookupPrivilegeValue", "str", Chr(0), "str", "SeDebugPrivilege", "int64*", "")
    ;msgbox(0,"",$call[3] & " " & _WinAPI_GetLastErrorMessage())
    Local $iLuid = $call[3]
    Local $TP = DllStructCreate($tagTOKENPRIVILEGES)
    Local $LUID = DllStructCreate($tagLUIDANDATTRIB, DllStructGetPtr($TP, "LUIDandATTRIB"))
    DllStructSetData($TP, "PrivilegeCount", $count)
    DllStructSetData($LUID, "Luid", $iLuid)
    DllStructSetData($LUID, "Attributes", $SE_PRIVILEGE_ENABLED)
    $call = DllCall("advapi32.dll", "int", "AdjustTokenPrivileges", "ptr", $hToken, "int", 0, "ptr", DllStructGetPtr($TP), "dword", 0, "ptr", Chr(0), "ptr", Chr(0))
    Return ($call[0] <> 0) ; $call[0] <> 0 is success
EndFunc   ;==>_GetPrivilege_SEDEBUG