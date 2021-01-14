#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Process Management Functions.
; Version:        0.1 Alpha
; NOTES:          These functions have only been tested on Windows XP. Other versions of
;                 Windows have not been tested.
;
; ------------------------------------------------------------------------------

;===============================================================================
;
; Description:      Returns a 2 dimensional array of a given PID's children's PIDs and Names
; Syntax:           _processChildren( $pidItem [, $identifier] )
; Parameter(s):     $pidItem - PID or Name of process to check for children.
;                   $identifier (optional) - 0 = PID # (DEFAULT)
;                                            1 = Name of PID (e.g. explorer.exe)
;                                                - If more than one process exists with the same name, only the 
;                                                  first one will be returned.
; Requirement(s):   None
; Return Value(s):  On Success - Returns a 2 dimensional array of PID-x children. Does not return grandchildren and on.
;                                   $appArr[0][0] = PID Children Count -- Set to 0 if there are no children.
;                                   $appArr[$x][0] = PID Name
;                                   $appArr[$x][1] = Child PID
;                   On Failure - Returns 0
; Author(s):        Kaleb D. Tuimala
; Note(s):          If the given PID has no children $appArr[0][0] will equal 0
;
;===============================================================================

Func _processChildren($pidItem, $identifier = 0)
	Local $wbemFlagReturnImmediately = 0x10, _
		  $wbemFlagForwardOnly = 0x20
	
	Local $pidArr[1][2]
	$pidArr[0][0] = 0
	Local $objWMIService, $colItems, $pid
	
	Local $qStr = ""
	
	If $identifier == 0 Then
		$qStr = "SELECT Name, ProcessId FROM Win32_Process WHERE ParentProcessId = '" & $pidItem & "'"
	ElseIf $identifier == 1 Then
		$objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
		$colItems = $objWMIService.ExecQuery("SELECT ProcessId FROM Win32_Process WHERE Name = '" & $pidItem & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		
		If IsObj($colItems) Then
			For $objItem In $colItems
				$pid = $objItem.ProcessId
				ExitLoop
			Next
		Else
			return 0
		EndIf

		$qStr = "SELECT Name, ProcessId FROM Win32_Process WHERE ParentProcessId = '" & $pid & "'"
	EndIf
	
	$objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
	$colItems = $objWMIService.ExecQuery($qStr, "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $pidArr[UBound($pidArr)+1][2]
			
			$pidArr[UBound($pidArr)-1][0] = $objItem.Name
			$pidArr[UBound($pidArr)-1][1] = $objItem.ProcessId
			
			$pidArr[0][0] += 1
		Next
		
		return $pidArr
	Else
		return 0
	EndIf
EndFunc

;===============================================================================
;
; Description:      Terminates a given PID and all it's decendants.
; Syntax:           _processKillTree($pid)
; Parameter(s):     $pid - PID # of a given process.
; Requirement(s):   _processChildren($pidItem [, $identifier])
; Return Value(s):  On Success - Returns 1 or 2
;                                   1 = Decendants and given PID were terminated
;                                   2 = Given PID termintated, but no decendants were found.
;                   On Failure - Returns 0
; Author(s):        Kaleb D. Tuimala
; Note(s):          Use with caution. I haven't tested terminating deep level processes.
;
;===============================================================================

Func _processKillTree($pid)
	Local $wbemFlagReturnImmediately = 0x10, _
	      $wbemFlagForwardOnly = 0x20
	
	Local $appArr = _processChildren($pid)
	
	If $appArr[0][0] > 0 Then
		For $i = 1 to $appArr[0][0]
			_processKillTree($appArr[$i][1])

			ProcessClose($appArr[$i][1])
		Next
		
		ProcessClose($pid)
		
		return 1
	ElseIf $appArr[0][0] == 0 Or $appArr == 0 Then
		ProcessClose($pid)
		
		return 2
	Else
		return 0
	EndIf
EndFunc

;===============================================================================
;
; Description:      Returns the PID of a process by its name
; Syntax:           _processPidByName($pName)
; Parameter(s):     $pName - The name of given process.
; Requirement(s):   None
; Return Value(s):  On Success - Returns the PID of the process name
;                   On Failure - Returns 0
; Author(s):        Kaleb D. Tuimala
; Note(s):          None
;
;===============================================================================

Func _processPidByName($pName)
	Local $wbemFlagReturnImmediately = 0x10, _
	      $wbemFlagForwardOnly = 0x20

	Local $objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
	Local $colItems = $objWMIService.ExecQuery("SELECT ProcessId FROM Win32_Process WHERE Name = '" & $pName & "'", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	Local $pid = 0
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			$pid =  $objItem.ProcessId
			ExitLoop
		Next
		
		return $pid
	Else
		return 0
	EndIf
EndFunc