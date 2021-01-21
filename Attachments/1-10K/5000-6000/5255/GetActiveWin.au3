;===============================================================================
;
; Function Name:    _GetActiveWin()
; Description:      Returns 2 element array containing the pid and handle of the
;					active window, respectively
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Returns $array[0] and $array[1] containing the 
;					pid and handle of the active window, respectively
;                   On Failure - 0  and sets @ERROR
; Author(s):        Ivan Perez
;
;===============================================================================

Func _GetActiveWin()
   Local $lAllWin
   Dim $ActiveWin[2]
   ; list all windows
   $lAllWin = WinList()
   If @error Then
      SetError(1)
      Return 0
   EndIf
   ; checks for active window
   For $i = 1 To $lAllWin[0][0] Step 1
      If $lAllWin[$i][0] <> "" And BitAND(WinGetState($lAllWin[$i][1]), 8) Then
         ; retreives the pid of the active window
         $ActiveWin[0] = $lAllWin[$i][0]
         $ActiveWin[1] = WinGetProcess($lAllWin[$i][1])
         ExitLoop
      EndIf
   Next
   If $ActiveWin[1]<>"" Then
      Return $ActiveWin
   Else
      Return 0
   EndIf
EndFunc   ;==>WinGetActive

