;===============================================================================
;
; Function Name:   _ProcessOpenHandle()
; Description::    Return the process handle of a ProcessID
; Parameter(s):    $i_pid    - ProcessID as returned from Run()
; Requirement(s):  AutoIt 3.1.1
; Return Value(s): On Success - Returns Process handle while Run() is executing
;                  On Failure - 0
;                  @error = 1 Error getting Process Handle
; Author(s):       MHz (Thanks to DaveF for posting these DllCalls in Support Forum)
;
;===============================================================================
;
Func _ProcessOpenHandle($i_Pid)
; Return the process handle of a PID
    $h_Process = DllCall('kernel32.dll', _
            'ptr', 'OpenProcess', _
            'int', 0x400, _
            'int', 0, _
            'int', $i_Pid)
    If Not @error Then Return $h_Process
    Return Not SetError(1)
EndFunc

;===============================================================================
;
; Function Name:   _ProcessGetExitCode()
; Description::    Return Process Exitcode of a Process Handle
; Parameter(s):    $i_Pid - ProcessID as returned from Run()
;                  $h_Process - Handle returned from _ProcessOpenHandle()
;                  $i_ProcessCloseHandle - Close Process Handle
; Requirement(s):  AutoIt 3.1.1
; Return Value(s): On Success - Return Process Exitcode of a Process Handle
;                   and will close Handle of Process as optional parameter
;                   (1 = Default, 0 = Retain Open Process Handle)
;                  On Failure - 0
;                             - @error 1 = GetExitCodeProcess failure
;                             - @error 2 = CloseHandle failure
;                             - @error 3 = Both above failed
;                             - @error 4 - Process is still active
;                             - @error 5 - Process is still active and Process Handle is Open
; Author(s):       MHz (Thanks to DaveF for posting these DllCalls in Support Forum)
;                      (Thanks to JPM for including CloseHandle as needed)
;
;===============================================================================
;
Func _ProcessGetExitCode($i_Pid, $h_Process, $i_ProcessCloseHandle = 1)
; Return Process Exitcode of a Process Handle and close Handle as default
    Local $i_ExitCode, $v_Placeholder, $i_Error = 0
    If ProcessExists($i_Pid) Then
        $i_Error = 3
    Else
        If IsArray($h_Process) Then
            $i_ExitCode = DllCall('kernel32.dll', _
                    'ptr', 'GetExitCodeProcess', _
                    'ptr', $h_Process[0], _
                    'int_ptr', $v_Placeholder)
            If @error Then $i_Error = 1
        EndIf
    EndIf
; Close the process handle of a PID
    If $i_Error = 3 Or $i_ProcessCloseHandle Then
        DllCall('kernel32.dll', _
                'ptr', 'CloseHandle', _
                'ptr', $h_Process)
        If @error Then $i_Error = $i_Error + 2
    EndIf
    If $i_Error Then Return Not SetError($i_Error)
    Return $i_ExitCode[2]
EndFunc