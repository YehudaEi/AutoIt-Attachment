;Example
Local $nPID = ProcessExists('explorer.exe')
Local $rtn = _WMI_IsProcessSuspended($nPID)
MsgBox(0, 'PID: ' & $nPID, 'Total Threads: ' & @extended & @CRLF & 'Suspended Threads: ' & $rtn)
;
;======================================================================
; Function: _WMI_IsProcessSuspended
; Released: October 27, 2012 by ripdad
; Modified: October 30, 2012
;
; Alternate Version: 0.2
;
; Resource: WMI_Query
; Link: http://www.autoitscript.com/forum/topic/139323-wmi-query-v104/
;
; Class Name: Win32_Thread
; Properties: ProcessHandle, ThreadState, ThreadWaitReason
;
; Example: Yes
;======================================================================
Func _WMI_IsProcessSuspended($nPID)
    If Not StringIsDigit($nPID) Then Return -1
    If Not ProcessExists($nPID) Then Return -2
    ;
    Local $objWMI = ObjGet('winmgmts:root\cimv2')
    If Not IsObj($objWMI) Then Return -3
    Local $objClass = $objWMI.InstancesOf('Win32_Thread Where ProcessHandle=' & $nPID)
    Local $count = $objClass.Count
    If Not $count Then Return -4
    Local $Value, $suspended = 0
    ;
    For $objItem In $objClass
        $Value = $objItem.ThreadState
        If ($Value == 5) Then
            $Value = $objItem.ThreadWaitReason
            If ($Value == 5) Or ($Value == 12) Then
                $suspended += 1
            EndIf
        EndIf
    Next
    Return SetError(0, $count, $suspended)
EndFunc
;
