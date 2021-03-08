;Example
Local $nPID = ProcessExists('explorer.exe')
Local $rtn = _WMI_IsProcessSuspended($nPID)
MsgBox(0, '', $rtn)
;
;======================================================================
; Function: _WMI_IsProcessSuspended
; Released: October 27, 2012 by ripdad
; Modified: October 29, 2012
;
; Resource: WMI_Query
; Link: http://www.autoitscript.com/forum/topic/139323-wmi-query-v104/
;
; Class Name: Win32_Thread
; Properties: ProcessHandle, ThreadState, ThreadWaitReason
;
; $nCheckAll: 0 = check if at least one thread is suspended. (default)
;             1 = check if all threads are suspended. (strict)
;                 Returns 0 if one thread fails this check.
;
; Example: Yes
;======================================================================
Func _WMI_IsProcessSuspended($nPID, $nCheckAll = 0)
    If Not StringIsDigit($nPID) Then Return -1
    If Not ProcessExists($nPID) Then Return -2
    ;
    Local $objWMI = ObjGet('winmgmts:root\cimv2')
    If Not IsObj($objWMI) Then Return -3
    Local $objClass = $objWMI.InstancesOf('Win32_Thread Where ProcessHandle=' & $nPID)
    Local $Value, $count = $objClass.Count
    If Not $count Then Return -4; PID Not Found
    ;
    For $objItem In $objClass
        $Value = $objItem.ThreadState; must be in "Wait State" to continue...
        If ($Value <> 5) Then Return 0; if not, then thread is not suspended.
        ;
        $Value = $objItem.ThreadWaitReason; must be 5 or 12 for a suspended condition.
        If ($Value == 5) Or ($Value == 12) Then
            If ($nCheckAll = 0) Then Return 1; <-- at least one thread is suspended.
        Else
            If ($nCheckAll = 1) Then Return 0; <-- at least one thread is not suspended.
        EndIf
    Next
    If ($nCheckAll = 1) Then Return 2; <-- All Threads Suspended
    Return 0; <-- Not Suspended
EndFunc
;

