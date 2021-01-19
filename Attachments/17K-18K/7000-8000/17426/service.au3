#include-once

;===============================================================================
; Description:   Delete a Windows Service
; Syntax:   _ServDelete($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to delete
;									 $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Deletes the service
;										  Failure Sets @Error = -1 if service is not found
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   
;===============================================================================

Func _ServDelete($iName, $Computer = ".")
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service")
	For $objService in $sItems
		If $objService.Name == $iName Then
			$objService.StopService($objService.Name)
			$objService.Delete($objService.Name)
			Return
		EndIf
	Next
	Return SetError(-1)
EndFunc   ;<==> _ServDelete()

;===============================================================================
; Description:   Return the details of a Windows Service
; Syntax:   _ServGetDetails($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to check
;									 $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Returns an array of the service details where element (-1 = Yes, 0 = No)
;												[1] = Computer Network Name
;												[2] = Service Name
;												[3] = Service Type (Own Process, Share Process)
;												[4] = Service State (Stopped, Running, Paused)
;												[5] = Exit Code (0, 1077)
;												[6] = Process ID
;												[7] = Can Be Paused (-1, 0)
;												[8] = Can Be Stopped (-1, 0)
;												[9] = Caption
;												[10] = Description
;												[11] = Can Interact With Desktop (-1, 0)
;												[12] = Display Name
;												[13] = Error Control (Normal, Ignore)
;												[14] = Executable Path Name
;												[15] = Service Started (-1, 0)
;												[16] = Start Mode (Auto, Manual, Disabled)
;												[17] = Account Name (LocalSystem, NT AUTHORITY\LocalService, NT AUTHORITY\NetworkService)
;										  Failure Sets @Error = -1 if service not found
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   $Var = _ServGetDetails("ATI Smart")
;								 $Dtl = "System Name|Name|Type|State|ExitCode|Process ID|Can Pause|Can Stop|Caption|Description|"
;								 $Dtl = StringSplit($Dtl & "Interact With DskTop|Display Name|Error Control|Exec File Path|Started|Start Mode|Account", '|')
;								 For $I = 1 To $Var[0]
;								 MsgBox(4096,$Dtl[$I], $Var[$I])
;								 Next
;===============================================================================

Func _ServGetDetails($iName, $Computer = ".")
	Local $Rtn = ''
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service")
	For $objService in $sItems
		If $objService.Name == $iName Then
		$Rtn &= $objService.SystemName & '|' & $objService.Name & '|' & $objService.ServiceType & '|' & $objService.State & '|'
		$Rtn &= $objService.ExitCode & '|' & $objService.ProcessID & '|' & $objService.AcceptPause & '|' & $objService.AcceptStop & '|'
		$Rtn &= $objService.Caption & '|' & $objService.Description & '|' & $objService.DesktopInteract & '|' & $objService.DisplayName & '|'
		$Rtn &= $objService.ErrorControl & '|' & $objService.PathName & '|' &$objService.Started & '|' & $objService.StartMode & '|'
		$Rtn &= $objService.StartName
		Return StringSplit($Rtn, '|')
		EndIf
	Next
	Return SetError(-1)
EndFunc

;===============================================================================
; Description:   Return the current state of a Windows Service
; Syntax:   _ServGetState($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to check
;									 $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Returns the state of the service
;										  Failure Sets @Error = -1 if service not found
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   
;===============================================================================

Func _ServGetState($iName, $Computer = ".")
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service")
	For $objItem in $sItems
		If $objItem.Name == $iName Then Return $objItem.State
	Next
	Return SetError(-1)
EndFunc   ;<==> _ServGetState()

;===============================================================================
; Description:   List the currently installed services
; Syntax:   _ServListInstalled([,$Computer])
; Parameter(s):   $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Returns the state of the service
;										  Failure Sets @Error = -1 if service not found
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   
;===============================================================================

Func _ServListInstalled($Computer = ".")
	Local $Rtn = ''
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service")
	For $objService in $sItems
		$Rtn &= $objService.Name & '|'
	Next
	Return StringSplit(StringTrimRight($Rtn, 1), '|')
EndFunc

;===============================================================================
; Description:   Pause a Windows Service
; Syntax:   _ServPause($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to start
;									 $Computer - The network name of the computer (optional). The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Pauses the service
;										  Failure Sets @Error = -1 if service not found or service is already paused
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   
;===============================================================================

Func _ServPause($iName, $Computer = ".")
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service Where State = 'Running' ")
	For $objService in $sItems
		If $objService.Name == $iName Then
			$objService.PauseService($objService.Name)
			Return
		EndIf
	Next
	Return SetError(-1)
EndFunc   ;<==> _ServPause()

;===============================================================================
; Description:   Resumes a  previously paused Windows auto-start service
; Syntax:   _ServResume($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to start
;									 $Computer - The network name of the computer (optional). The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Resumes the service
;										  Failure Sets @Error = -1 if service not found
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   
;===============================================================================

Func _ServResume($iName, $Computer = ".")
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service Where State = 'Paused' and StartMode = 'Auto'")
	For $objService in $sItems
		If $objService.Name == $iName Then
			$objService.ResumeService($objService.Name)
			Return
		EndIf
	Next
	Return SetError(-1)
EndFunc   ;<==> _ServResume()

;===============================================================================
; Description:   Start a Windows Service
; Syntax:   _ServStart($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to start
;									 $Computer - The network name of the computer (optional). The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Starts the service
;										  Failure Sets @Error = -1 if service not found or service is already running
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   
;===============================================================================

Func _ServStart($iName, $Computer = ".")
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service Where State = 'Stopped' ")
	For $objService in $sItems
		If $objService.Name == $iName Then
			$objService.StartService($objService.Name)
			Return
		EndIf
	Next
	Return SetError(-1)
EndFunc   ;<==> _ServStart()

;===============================================================================
; Description:   Stop a Windows Service
; Syntax:   _ServStop($iName[, $Computer])
; Parameter(s):   $iName - The name of the service to stop
;									 $Computer - The network name of the computer (optional). The local computer is default
; Requirement(s):   None
; Return Value(s):   Success - Stops the service
;										  Failure Sets @Error = -1 if service not found or service state is already stopped
;															Sets @Error = -2 if service can not be stopped
; Author(s)   GEOSoft
; Modification(s):   
; Note(s):   
; Example(s):   
;===============================================================================

Func _ServStop($iName, $Computer = ".")
	$Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	$sItems = $Service.ExecQuery("Select * from Win32_Service Where State = 'Running' ")
	For $objService in $sItems
		If $objService.Name == $iName Then
			If $objService.AcceptStop = 0 Then Return SetError(-2)
			$objService.StopService($objService.Name)
			Return
		EndIf
	Next
	Return SetError(-1)
EndFunc   ;<==> _ServStop()

