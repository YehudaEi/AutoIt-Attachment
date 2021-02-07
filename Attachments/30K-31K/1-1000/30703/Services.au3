
;*******************************************************************************
;
;   Function List
;         _Service_Create()
;         _Service_Delete()
;         _Service_Description()
;         _Service_EnumAnticede()
;         _Service_EnumDepends()
;         _Service_Exists()
;         _Service_GetDetails()
;         _Service_GetFilePath()
;         _Service_GetPid()
;         _Service_GetStartMode()
;         _Service_GetState()
;         _Service_Pause()
;         _Service_PauseOK()
;         _Service_Resume()
;         _Service_Running()
;;         _Service_SetDescription()
;         _Service_SetStartMode()
;         _Service_SetStartModeA()
;         _Service_Start()
;         _Service_StartType()
;         _Service_Stop()
;         _Service_StopOK()
;         _Services_GetDetails()
;         _Services_List_FromPID()
;         _Services_ListInstalled()
;         _Services_ListRunning()
;
;*******************************************************************************

#include-once
Global Const $OWN_PROCESS = 16
Global Const $NOT_INTERACTIVE = False
Global Const $NORMAL_ERROR_CONTROL = 2
Global Const $SC_MANAGER_ALL_ACCESS = 0x0F003F
Global Const $SERVICE_INTERROGATE = 0x000080

Global _
		$oServiceErrorHandler, _
		$sServiceUserErrorHandler, _
		$_ServiceErrorNotify = True, _
		$__ServiceAU3Debug = True

Global Enum _
		$_ServiceStatus_Success = 0, _
		$_ServiceStatus_GeneralError = 1, _
		$_ServiceStatus_COMError

;===============================================================================
; Name:   _Service_Create()
; Description:   Creates a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to create
;                $sDisplayName - display name of the service
;                $sBinaryPath - fully qualified path to the service binary file
;                               The path can also include arguments for an auto-start service
;                $sServiceUser - [optional] default is LocalSystem
;                                name of the account under which the service should run
;                $sPassword - [optional] default is empty
;                                        password to the account name specified by $sServiceUser
;                                        Specify an empty string if the account has no password or if the service
;                                           runs in the LocalService, NetworkService, or LocalSystem account
;                 $nServiceType - [optional] default is $SERVICE_WIN32_OWN_PROCESS
;                 $nStartType - [optional] default is $SERVICE_AUTO_START
;                 $nErrorType - [optional] default is $SERVICE_ERROR_NORMAL
;                 $nDesiredAccess - [optional] default is $SERVICE_ALL_ACCESS
;                 $sLoadOrderGroup - [optional] default is empty
;                                    names the load ordering group of which this service is a member
; Requirements:  Administrative rights on the computer
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
; Author(s):   Unknown.  If it's yours then let me know.
; Note:          Dependencies cannot be specified using this function
;                Refer to the CreateService page on MSDN for more information
;===============================================================================

Func _Service_Create($sComputerName, $sServiceName, $sDisplayName, $sBinaryPath, _
		$sServiceUser = "LocalSystem", $sPassword = "", $nServiceType = 0x00000010, _
		$nStartType = 0x00000002, $nErrorType = 0x00000001, $nDesiredAccess = 0x000f01ff, _
		$sLoadOrderGroup = "")
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $lError = -1

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
			"str", $sComputerName, _
			"str", "ServicesActive", _
			"long", $SC_MANAGER_ALL_ACCESS)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", _
				"long", $hSC, _
				"str", $sServiceName, _
				"long", $SERVICE_INTERROGATE)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hAdvapi32, "long", "CreateService", _
					"long", $hSC, _
					"str", $sServiceName, _
					"str", $sDisplayName, _
					"long", $nDesiredAccess, _
					"long", $nServiceType, _
					"long", $nStartType, _
					"long", $nErrorType, _
					"str", $sBinaryPath, _
					"str", $sLoadOrderGroup, _
					"ptr", 0, _
					"str", "", _
					"str", $sServiceUser, _
					"str", $sPassword)
			If $arRet[0] = 0 Then
				$arRet = DllCall($hKernel32, "long", "GetLastError")
				$lError = $arRet[0]
			Else
				DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $arRet[0])
			EndIf
		Else
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $arRet[0])
		EndIf
		DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hSC)
	EndIf
	DllClose($hAdvapi32)
	DllClose($hKernel32)
	If $lError <> -1 Then
		SetError($lError)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>_Service_Create

;===============================================================================
; Name:   _Service_Delete()
; Description:   Delete a Windows Service
; Syntax:   _Service_Delete($sServiceName[, $Computer])
; Parameter(s):   $sServiceName - The name of the service to delete
;                 $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Deletes the service
;                    Failure Sets @Error = 1 if service is not found
; Author(s)   George (GEOSoft) Gedye
; Modification(s):   ReCoder-- added  "where name like" to the query string to
;                               prevent an array loop in AutoIt.
;                    engine - Added the ProcessWaitClose
;
; Note(s):
; Example(s):
;===============================================================================

Func _Service_Delete($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service where name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		If $objService.AcceptStop Then
			$objService.StopService($objService.Name)
			ProcessWaitClose($objService.ProcessID)
		EndIf
		$objService.Delete($objService.Name)
		Return
	Next
	Return SetError(1)
EndFunc   ;==>_Service_Delete

;===============================================================================
; Function Name:   _Service_Description()
; Description:     Return the Description of a Service
; Syntax:          _Service_Description("Service Name"[, "Computer"])
; Parameter(s):    $sServiceName - The name of the service to stop
;                  $Computer - The network name of the computer (optional).
;                               The local computer is default
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - The description of the given service.
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

Func _Service_Description($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2"), $Rtn
	Local $sQuery = "Select * from Win32_Service Where State = 'Running' And " & _
			"name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$Rtn = $objService.Description
	Next
	Return $Rtn
EndFunc   ;==>_Service_Description

;===============================================================================
; Function Name:   _Service_EnumAnticede()
; Description:     Enumerate the services that must be running before a service can be started
; Syntax:          _Service_EnumAnticede("Service Name", "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer (optional) - Computer name (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - An Array of the services on which $sServiceName depends
;                            Array[0] contains the number of array elements.
;                  Returns False if the service has no anticedents
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):    Services which depend on another service can not be started until
;              the services on which they depend have been started.
; Example(s):
;===============================================================================

Func _Service_EnumAnticede($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $sQuery = "Associators of " _
			 & "{Win32_Service.Name='" & $sServiceName & "'} Where " _
			 & "AssocClass=Win32_DependentService " & "Role=Dependent"
	Local $Service = ObjGet("winmgmts:" _
			 & "{impersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sItems = $Service.ExecQuery($sQuery), $rArray = False
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$rArray = $objService.Name & @LF
	Next
	If $rArray <> "" Then $rArray = StringSplit(StringTrimRight($rArray, 1), @LF)
	Return $rArray

EndFunc   ;==>_Service_EnumAnticede

;===============================================================================
; Function Name:   _Service_EnumDepends()
; Description:     Enumerates all the services that depend on a given service.
; Syntax:          _Service_EnumDepends("Service Name", "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer (optional) - Computer name (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): An Array of the services which depend on $sServiceName
;                  Array[0] contains the number of array elements.
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):    Services which depend on another service can not be started until
;              the services on which they depend have been started.
; Example(s):
;===============================================================================

Func _Service_EnumDepends($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $sQuery = "Associators of " _
			 & "{Win32_Service.Name='" & $sServiceName & "'} Where " _
			 & "AssocClass=Win32_DependentService " & "Role=Antecedent"
	Local $Service = ObjGet("winmgmts:" _
			 & "{impersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sItems = $Service.ExecQuery($sQuery), $rArray = ""
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$rArray = $objService.Name & @LF
	Next
	If $rArray <> "" Then $rArray = StringSplit(StringTrimRight($rArray, 1), @LF)
	Return $rArray
EndFunc   ;==>_Service_EnumDepends

;===============================================================================
; Name:   _Service_Exists()
; Function:      _Service_Exists()
; Description:      Checks to see if a service is installed
; Syntax:           _Service_Exists($sServiceName)
; Parameter(s):     $sServiceName - Name of service to check
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):  Success - Returns 1
;                   Failure - Returns 0
; Author(s):        engine
; Modification(s):   Total rewite of this function by engine June 10, 2008
;===============================================================================

Func _Service_Exists($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service where name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		Return True
	Next
	Return False
EndFunc   ;==>_Service_Exists

;===============================================================================
; Name:   _Service_GetDetails()
; Description:   Return the details of a Windows Service
; Syntax:   _Service_GetDetails($sServiceName[, $Computer])
; Parameter(s):   $sServiceName - The name of the service to check
;                            $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Returns an array of the service details where element (-1 = Yes, 0 = No)
;          [1] = Computer Network Name
;          [2] = Service Name
;          [3] = Service Type (Own Process, Share Process)
;          [4] = Service State (Stopped, Running, Paused)
;          [5] = Exit Code (0, 1077)
;          [6] = Process ID
;          [7] = Can Be Paused (-1, 0)
;          [8] = Can Be Stopped (-1, 0)
;          [9] = Caption
;          [10] = Description
;          [11] = Can Interact With Desktop (-1, 0)
;          [12] = Display Name
;          [13] = Error Control (Normal, Ignore)
;          [14] = Executable Path Name
;          [15] = Service Started (-1, 0)
;          [16] = Start Mode (Auto, Manual, Disabled)
;          [17] = Account Name (LocalSystem, NT AUTHORITY\LocalService, NT AUTHORITY\NetworkService)
;                               Failure Sets @Error = -1 if service not found
; Author(s):   George (GEOSoft) Gedye
; Modification(s):   ReCoder-- added  "where name like" to the query string to
;                                 prevent an array loop in AutoIt
;
; Note(s):
; Example(s):   $Var = _Service_GetDetails("ATI Smart")
;               $Dtl = "System Name|Name|Type|State|ExitCode|Process ID|Can Pause|Can Stop|"
;               $Dtl &= "Caption|Description|Interact With DeskTop|Display Name|Error Control|"
;               $Dtl = StringSplit($Dtl & "Exec File Path|Started|Start Mode|Account", '|')
;                      For $I = 1 To $Var[0]
;                         MsgBox(4096,$Dtl[$I], $Var[$I])
;                      Next
;===============================================================================

Func _Service_GetDetails($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Rtn
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service where name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems ;# Take the first object from the collection and return details
		$Rtn = $objService.SystemName & '|' & $objService.Name & '|'
		$Rtn &= $objService.ServiceType & '|' & $objService.State & '|'
		$Rtn &= $objService.ExitCode & '|' & $objService.ProcessID & '|'
		$Rtn &= $objService.AcceptPause & '|' & $objService.AcceptStop & '|'
		$Rtn &= $objService.Caption & '|' & $objService.Description & '|'
		$Rtn &= $objService.DesktopInteract & '|' & $objService.DisplayName & '|'
		$Rtn &= $objService.ErrorControl & '|' & $objService.PathName & '|'
		$Rtn &= $objService.Started & '|' & $objService.StartMode & '|'
		$Rtn &= $objService.StartName
		Return StringSplit($Rtn, '|')
	Next
	Return SetError(-1)
EndFunc   ;==>_Service_GetDetails

;===============================================================================
; Function Name:   _Service_GetFilePath()
; Description:     Return  the full path to the associated file.
; Syntax:          _Service_GetFilePath("Service name"[, "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer - Network name of the computer (Default is localhost)
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - The full path of the file that is running the service
;                  Failure - Sets @Error = 1 if process does not exist or is not running
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

Func _Service_GetFilePath($sServiceName, $Computer = "localhost")
	If (Not _Service_Exists($sServiceName)) Or _
			(_Service_GetState($sServiceName) <> "Running") Then Return SetError(1)
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service where name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		Return $objService.PathName
	Next
EndFunc   ;==>_Service_GetFilePath

;===============================================================================
; Function Name:   _Service_GetPid()
; Description:     Return the Process ID of a service
; Syntax:          _Service_GetPid(Process Name[, Computer])
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer - Network name of the computer (Default is localhost)
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - Returns the PID of the specified process
;                  Failure - Sets @Error = 1 if process does not exist or is not running
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

Func _Service_GetPid($sServiceName, $Computer = "localhost")
	If (Not _Service_Exists($sServiceName)) Or _
			(_Service_GetState($sServiceName) <> "Running") Then Return SetError(1)
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service where name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		Return $objService.ProcessID
	Next
EndFunc   ;==>_Service_GetPid

;===============================================================================
; Function Name:   _Service_GetStartMode()
; Description:     Get the current start mode for a service
; Syntax:          _Service_GetStartMode("Service Name", "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer (optional) - Computer name (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - The current start mode of $sServiceName
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

Func _Service_GetStartMode($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:" _
			 & "{impersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service Where name like '" & $sServiceName & "'"
	Local $sItem = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItem
		Return $objService.StartMode
	Next
EndFunc   ;==>_Service_GetStartMode

;===============================================================================
; Name:   _Service_GetState()
; Description:   Return the current state of a Windows Service
; Syntax:   _Service_GetState($sServiceName[, $Computer])
; Parameter(s):   $sServiceName - The name of the service to check
;        $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Returns the state of the service
;                                Failure Sets @Error = -1 if service not found
; Author(s):   George (GEOSoft) Gedye
; Modification(s):   ReCoder-- added  "where name like" to the query string
;                               to prevent an array loop in AutoIt.
;
; Note(s):
; Example(s):
;===============================================================================

Func _Service_GetState($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service where name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objItem In $sItems
		Return $objItem.State
	Next
	Return SetError(-1)
EndFunc   ;==>_Service_GetState

;===============================================================================
; Name:   _Service_Pause()
; Description:   Pause a Windows Service
; Syntax:   _Service_Pause($sServiceName[, $Computer])
; Parameter(s):   $sServiceName - The name of the service to start
;                 $Computer - The network name of the computer (optional).
;                              The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Pauses the service
;           Failure Sets @Error = -1 if service not found or service is already paused
; Author(s)   George (GEOSoft) Gedye
; Modification(s):   ReCoder-- added  "where name like" to the query string to prevent an array loop in AutoIt
;
; Note(s):   I recommend that you call _Service_PauseOK() prior to using this function
; Example(s):
;===============================================================================

Func _Service_Pause($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service Where State = 'Running' And " & _
			"name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$objService.PauseService($objService.Name)
		Return
	Next
	Return SetError(-1)
EndFunc   ;==>_Service_Pause

;===============================================================================
; Function Name:   _Service_PauseOK()
; Description:     Determine if a service can be paused
; Syntax:          _Service_PauseOK("Service Name", "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer (optional) - Computer name (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - True = Service can be paused
;                            False = Service can not be paused
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):    This function will return False if the service is not running
; Example(s):   If _Service_PauseOK("MyService") Then ........
;===============================================================================

Func _Service_PauseOK($sServiceName, $Computer = "localhost")
	Local $sQuery = "Select * from Win32_Service Where AcceptPause = True AND name like '" & $sServiceName & "'"
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:" _
			 & "{impersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sItem = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItem
		If $objService.AcceptPause Then Return True
	Next
	Return False
EndFunc   ;==>_Service_PauseOK

;===============================================================================
; Name:   _Service_Resume()
; Description:   Resumes a  previously paused Windows auto-start service
; Syntax:   _Service_Resume($sServiceName[, $Computer])
; Parameter(s):   $sServiceName - The name of the service to start
;                 $Computer - The network name of the computer (optional).
;                             The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Resumes the service
;                    Failure Sets @Error = -1 if service not found
; Author(s):           George (GEOSoft) Gedye
; Modification(s):   ReCoder-- added  "where name like" to the query string to
;                                       prevent an array loop in AutoIt
;
; Note(s):
; Example(s):
;===============================================================================

Func _Service_Resume($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service Where State = 'Paused' And " & _
			"StartMode = 'Auto' And name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$objService.ResumeService($objService.Name)
		Return
	Next
	Return SetError(-1)
EndFunc   ;==>_Service_Resume

;===============================================================================
; Function Name:   _Service_Running($sServiceName, $Computer = "localhost")
; Description:     Determine if a service is currently running
; Syntax:          _Service_Running("Service Name", "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer (optional) - Computer name (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - True if the service is running
;                          - False if the service is not running
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

Func _Service_Running($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $sQuery = "Select * from Win32_Service Where State = 'Running' AND name like '" & $sServiceName & "'"
	Local $Service = ObjGet("winmgmts:" _
			 & "{impersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sItem = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItem
		Return True
	Next
	Return False
EndFunc   ;==>_Service_Running

;===============================================================================
; Function Name:   _Service_SetDescription()
; Description:     Modify the description of a service
; Syntax:          _Service_SetDescription("service Name"[, "Computer Name"])
; Parameter(s):    $sServiceName - The name of the service to stop
;                  $sDesc - New service description
;                  $strComputer - [optional] The network name of the computer
;                                 The local computer is default
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - 1
;                  Failure - 0
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

;;Func _Service_SetDescription($sServiceName, $sDesc, $Computer = "localhost")
;;   _sServErrorHandlerRegister()
;;   Local $sQuery = "Select * from Win32_Service where name like '"& $sServiceName &"'"
;;  Local $Service = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
;;   Local $sItems = $Service.ExecQuery($sQuery)
;;   _sServErrorHandlerDeRegister()
;;   For $objService In $sItems
;;      If $objService.Description <> $sDesc Then
;;      $error = RegWrite("\\" & $strComputer & "\HKLM\SYSTEM\CurrentControlSet\Services\" & _
;;      $sServiceName, "Description", "REG_SZ", $sDesc)
;;      If $error = 0 Then Return 1
;;   Next
;;   Return SetError($error, 0, 0)
;;EndFunc   ;<==> _Service_SetDescription()

;===============================================================================
; Name:   _Service_SetStartMode()
; Description:      Sets StartMode of a service on a computer
; Syntax:         _Service_ChangeStartMode($sServiceName, $sStatus [, $strComputer])
; Parameters:      $sServiceName - Name of the service to set start type for
;                 $sMode - Status of the service to set
;                     Possible options are "Boot", "System", "Automatic", "Manual", "Disabled"
;                 $strComputer - [Optional] Name of the target computer
;                        The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Values:   On Success - 1
;                 On Failure - Returns 0 and sets
;                               @error - See table on top of this file for possible values
; Author(s):      engine
; Modification(s):
;
; Note:            This function does not stop/start service
; Example(s):      MsgBox(0, "Test", _Service_SetStartMode("CarbonCopy32", "Disabled"))
;===============================================================================

Func _Service_SetStartMode($sServiceName, $sMode, $Computer = @ComputerName)
	Local $Service = ObjGet("winmgmts:{ImpersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service where name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	For $objService In $sItems
		Local $error = $objService.ChangeStartMode($sMode)
		If $error = 0 Then Return 1
	Next
	Return SetError($error, 0, 0)
EndFunc   ;==>_Service_SetStartMode

;===============================================================================
; Function Name:   _Service_SetStartMode()
; Description:     Set the start mode of a service.
; Syntax:          _Service_EnumAnticede("Service Name", "Mode", "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $sMode - New mode -- Valid values are ("Manual" And "Auto"
;                  $Computer (optional) - Computer name (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - Sets the new start mode
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):    Some applications (anti-virus etc) will not allow the registry change
;             on all Services
; Example(s):
;===============================================================================

Func _Service_SetStartModeA($sServiceName, $sMode, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:" _
			 & "{impersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service Where  name like '" & $sServiceName & "'"
	Local $sItem = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItem
		If $objService.StartMode <> $sMode Then $objService.Change(Default, Default, Default, Default, $sMode)
	Next
EndFunc   ;==>_Service_SetStartModeA

;===============================================================================
; Name:   _Service_Start()
; Description:   Start a Windows Service
; Syntax:   _Service_Start($sServiceName[, $Computer])
; Parameter(s):   $sServiceName - The name of the service to start
;                 $Computer - The network name of the computer (optional).
;                             The local computer is default
; Requirement(s):    WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Starts the service
;                    Failure Sets @Error = -1 if service not found or service is already running
; Author(s):         George (GEOSoft) Gedye
; Modification(s):   Added  "where name like" to the query string to prevent an array loop in AutoIt
;
; Note(s):
; Example(s):
;===============================================================================

Func _Service_Start($sServiceName, $Computer = "localhost")
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sQuery = "Select * from Win32_Service Where State = 'Stopped' And " & _
			"name like '" & $sServiceName & "'"
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$objService.StartService($objService.Name)
		Return
	Next
	Return SetError(-1)
EndFunc   ;==>_Service_Start

;===============================================================================
; Name:          _Service_StartType()
; Description:   This function is now just a stub for _Service_SetStartMode()
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sStatus - status of the service to set. Possible options are "Auto", "Manual", "Disabled".
;                $sServiceName - name of the service to set start type for
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Values: On Success - 1
;                On Failure - 0
; Author(s):
; Note:        Will be removed in a future release. Please use _Service_SetStartMode()
; Example(s):
;===============================================================================

Func _Service_StartType($sServiceName, $sMode, $sComputerName = "localhost")
	Local $Rtn = _Service_SetStartMode($sServiceName, $sMode, $sComputerName)
	Return $Rtn
EndFunc   ;==>_Service_StartType

;===============================================================================
; Name:   _Service_Stop()
; Description:   Stop a Windows Service
; Syntax:   _Service_Stop($sServiceName[, $Computer])
; Parameter(s):   $sServiceName - The name of the service to stop
;                 $Computer - The network name of the computer (optional).
;                             The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Stops the service
;                    Failure Sets @Error = -1 if service not found or service state is already stopped
;                            Sets @Error = -2 if service can not be stopped
; Author(s)   George (GEOSoft) Gedye
; Modification(s):   Added  "where name like" to the query string to prevent an array loop in AutoIt
;                    engine - added ProcessWaitClose.
;
; Note(s):   I recommend that you call _Service_StopOK() prior to using this function
; Example(s):
;===============================================================================

Func _Service_Stop($sServiceName, $Computer = "localhost")
	Local $sQuery = "Select * from Win32_Service Where State = 'Running' And " & _
			"name like '" & $sServiceName & "'"
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		If Not $objService.AcceptStop Then Return SetError(-2)
		$objService.StopService($objService.Name)
		ProcessWaitClose($objService.ProcessID)
		Return
	Next
	Return SetError(-1)
EndFunc   ;==>_Service_Stop

;===============================================================================
; Function Name:   _Service_StopOK()
; Description:     Determine if a service can be stopped
; Syntax:          _Service_StopOK("Service Name", "Computer")
; Parameter(s):    $sServiceName - Name of the service
;                  $Computer (optional) - Computer name (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - True = Service can be stopped
;                            False = Service can not be stopped
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):    This function will return False if the service is not running
; Example(s):
;===============================================================================

Func _Service_StopOK($sServiceName, $Computer = "localhost")
	Local $sQuery = "Select * from Win32_Service Where AcceptStop = True AND name like '" & $sServiceName & "'"
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:" _
			 & "{impersonationLevel=impersonate}!\\" & $Computer & "\root\cimv2")
	Local $sItem = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItem
		If $objService.AcceptStop Then Return True
	Next
	Return False
EndFunc   ;==>_Service_StopOK

;===============================================================================
; Name:           _Services_GetDetails()
; Description:     Returns a list of details of all currently defined Windows Services
; Syntax:          _Services_GetDetails([$Computer])
; Parameter(s):    $Computer - The network name of the computer (optional) The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - Returns an array of the details of Services.
;                  A servicedetail is a string and has elements separated by "|", exam. "MyPC|svchost|..."
;                  Array[0]     contains the number N of Services
;                  Array[1..N]  contains the Strings of servicedetails
;                  Meaning:     (-1 = Yes, 0 = No)
;                  Pos. in string    [1] = Computer Network Name
;                                    [2] = Service Name
;                                    [3] = Service Type (Own Process, Share Process)
;                                    [4] = Service State (Stopped, Running, Paused)
;                                    [5] = Exit Code (0, 1077)
;                                    [6] = Process ID
;                                    [7] = Can Be Paused (-1, 0)
;                                    [8] = Can Be Stopped (-1, 0)
;                                    [9] = Caption
;                                    [10] = Description
;                                    [11] = Can Interact With Desktop (-1, 0)
;                                    [12] = Display Name
;                                    [13] = Error Control (Normal, Ignore)
;                                    [14] = Executable Path Name
;                                    [15] = Service Started (-1, 0)
;                                    [16] = Start Mode (Auto, Manual, Disabled)
;                                    [17] = Account Name (LocalSystem, NT AUTHORITY\LocalService, NT AUTHORITY\NetworkService)
;                  Failure Sets @Error = -1 if services not found
; Author(s):        GEOSoft, ReCoder
; Modification(s):
; Note(s):
; Example(s):
;~ #include <GuiConstants.au3>
;~ #include <GuiListView.au3>
;~ ;#include <services.au3>
;~
;~ Local $sDtl = "System Name|Name|Type|State|ExitCode|Process ID|Can Pause|Can Stop" & _
;~              "|Caption|Description|Interact With DskTop|Display Name" & _
;~              "|Error Control|Exec File Path|Started|Start Mode|Account"
;~ Local $aDtl = StringSplit($sDtl, '|')
;~ #region GUI definitions
;~ GuiCreate("MyGUI", 810, 487,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
;~ Dim $process_list_view = GUICtrlCreateListView( $sDtl, 10, 10, 790, 440, _
;~                                    $LVS_SHOWSELALWAYS, $LVS_EX_GRIDLINES )
;~ $btnRefresh = GuiCtrlCreateButton("Refresh", 20, 460, 150, 20)
;~ GetServicesInfos($process_list_view)
;~ GuiSetState()
;~
;~ While 1
;~  $msg = GuiGetMsg()
;~  Select
;~    Case $msg = $GUI_EVENT_CLOSE
;~   ExitLoop
;~      Case $msg = $btnRefresh
;~         GetServicesInfos($process_list_view)
;~    Case Else
;~   ;;;
;~  EndSelect
;~ WEnd
;~ Exit
;~
;~ Func GetServicesInfos(ByRef $ListView)
;~     Local $aServices = _ServicesGetDetails() ;# n Services, Array[1..n]
;~     Local $Top_Item = _GUICtrlListViewGetTopIndex($ListView)
;~     _GUICtrlListViewDeleteAllItems($ListView)
;~     For $i = 1 To $aServices[0]
;~         GUICtrlCreateListViewItem($aServices[$i], $Listview)
;~     Next
;~     _GUICtrlListViewEnsureVisible($ListView, $Top_Item, 1)
;~ EndFunc
;===============================================================================

Func _Services_GetDetails($Computer = "localhost")
	Local $Rtn, $aRet[1] = [0]
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sItems = $Service.ExecQuery("Select * from Win32_Service")
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		Local $i = UBound($aRet)
		ReDim $aRet[$i + 1]
		$Rtn = $objService.SystemName & '|' & $objService.Name & '|'
		$Rtn &= $objService.ServiceType & '|' & $objService.State & '|'
		$Rtn &= $objService.ExitCode & '|' & $objService.ProcessID & '|'
		$Rtn &= $objService.AcceptPause & '|' & $objService.AcceptStop & '|'
		$Rtn &= $objService.Caption & '|' & $objService.Description & '|'
		$Rtn &= $objService.DesktopInteract & '|' & $objService.DisplayName & '|'
		$Rtn &= $objService.ErrorControl & '|' & $objService.PathName & '|'
		$Rtn &= $objService.Started & '|' & $objService.StartMode & '|'
		$Rtn &= $objService.StartName
		$aRet[$i] = $Rtn ;# Service[$i].Infos
		$aRet[0] = $i ;# Anzahl Services
	Next
	Return $aRet
EndFunc   ;==>_Services_GetDetails

;===============================================================================
; Function Name:   _Services_List_FromPID()
; Description:     List the services running under a given PID
; Syntax:          _Services_List_FromPID("PID Number", "Computer")
; Parameter(s):    $nPid - PID
;                  $Computer - Computer to check (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - Array of services running under $nPid
;                             where array[0] = number of services
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):   ProcessID
;===============================================================================

Func _Services_List_FromPID($nPid, $Computer = "localhost")
	$nPid = Number($nPid)
	Local $Rtn = ""
	Local $sQuery = "Select * from Win32_Service where ProcessID = '" & $nPid & "'"
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$Rtn &= $objService.name & @LF
	Next
	Return StringSplit(StringStripWS($Rtn, 2), @LF)
EndFunc   ;==>_Services_List_FromPID

;===============================================================================
; Name:   _Services_ListInstalled()
; Description:   List the currently installed services
; Syntax:   _Services_ListInstalled([,$Computer])
; Parameter(s):   $Computer - The network name of the computer (optional)
;                              The local computer is default
; Requirement(s):   WMI capable operating system and administrator rights on the computer
; Return Value(s):   Success - Returns an Array of the installed services
; Author(s)   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

Func _Services_ListInstalled($Computer = "localhost")
	Local $Rtn = '', $sQuery = "Select * from Win32_Service"
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$Rtn &= $objService.Name & '|'
	Next
	Return StringSplit(StringTrimRight($Rtn, 1), '|')
EndFunc   ;==>_Services_ListInstalled

;===============================================================================
; Function Name:   _Services_ListRunning()
; Description:     List the running services on a computer
; Syntax:          _Services_ListRunning("Computer")
; Parameter(s):    $Computer (optional) - The computer to check (default is localhost)
; Requirement(s):  WMI capable operating system and administrator rights on the computer
; Return Value(s): Success - an array of the running services
;                            where array[0] = number of running services
; Author(s):   George (GEOSoft) Gedye
; Modification(s):
; Note(s):
; Example(s):
;===============================================================================

Func _Services_ListRunning($Computer = "localhost")
	Local $Rtn = "", $sQuery = "Select * from Win32_Service where State = 'Running'"
	_sServErrorHandlerRegister()
	Local $Service = ObjGet("winmgmts:\\" & $Computer & "\root\cimv2")
	Local $sItems = $Service.ExecQuery($sQuery)
	_sServErrorHandlerDeRegister()
	For $objService In $sItems
		$Rtn &= $objService.name & @LF
	Next
	Return StringSplit(StringStripWS($Rtn, 2), @LF)
EndFunc   ;==>_Services_ListRunning

Func _sServInternalErrorHandlerRegister()
	Local $sCurrentErrorHandler = ObjEvent("AutoIt.Error")
	If $sCurrentErrorHandler <> "" And Not IsObj($oServiceErrorHandler) Then
		; We've got trouble... User COM Error handler assigned without using _ServiceUserErrorHandlerRegister
		SetError($_ServiceStatus_GeneralError)
		Return 0
	EndIf
	$oServiceErrorHandler = ""
	$oServiceErrorHandler = ObjEvent("AutoIt.Error", "_sServInternalErrorHandler")
	If IsObj($oServiceErrorHandler) Then
		SetError($_ServiceStatus_Success)
		Return 1
	Else
		SetError($_ServiceStatus_GeneralError)
		Return 0
	EndIf
EndFunc   ;==>_sServInternalErrorHandlerRegister

;;  Private Functions

Func _sServErrorHandlerDeRegister()
	$sServiceUserErrorHandler = ""
	$oServiceErrorHandler = ""
	SetError($_ServiceStatus_Success)
	Return 1
EndFunc   ;==>_sServErrorHandlerDeRegister

Func _sServErrorHandlerRegister($s_functionName = "_sServInternalErrorHandler")
	$sServiceUserErrorHandler = $s_functionName
	$oServiceErrorHandler = ""
	$oServiceErrorHandler = ObjEvent("AutoIt.Error", $s_functionName)
	If IsObj($oServiceErrorHandler) Then
		SetError($_ServiceStatus_Success)
		Return 1
	Else
		SetError($_ServiceStatus_GeneralError, 1)
		Return 0
	EndIf
EndFunc   ;==>_sServErrorHandlerRegister

Func _sServInternalErrorHandler()
	$ServiceComErrorScriptline = $oServiceErrorHandler.scriptline
	$ServiceComErrorNumber = $oServiceErrorHandler.number
	$ServiceComErrorNumberHex = Hex($oServiceErrorHandler.number, 8)
	$ServiceComErrorDescription = StringStripWS($oServiceErrorHandler.description, 2)
	$ServiceComErrorWinDescription = StringStripWS($oServiceErrorHandler.WinDescription, 2)
	$ServiceComErrorSource = $oServiceErrorHandler.Source
	$ServiceComErrorHelpFile = $oServiceErrorHandler.HelpFile
	$ServiceComErrorHelpContext = $oServiceErrorHandler.HelpContext
	$ServiceComErrorLastDllError = $oServiceErrorHandler.LastDllError
	$ServiceComErrorOutput = ""
	$ServiceComErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorScriptline = " & $ServiceComErrorScriptline & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorNumberHex = " & $ServiceComErrorNumberHex & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorNumber = " & $ServiceComErrorNumber & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorWinDescription = " & $ServiceComErrorWinDescription & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorDescription = " & $ServiceComErrorDescription & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorSource = " & $ServiceComErrorSource & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorHelpFile = " & $ServiceComErrorHelpFile & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorHelpContext = " & $ServiceComErrorHelpContext & @CR
	$ServiceComErrorOutput &= "----> $ServiceComErrorLastDllError = " & $ServiceComErrorLastDllError & @CR
	If $_ServiceErrorNotify Or $__ServiceAU3Debug Then ConsoleWrite($ServiceComErrorOutput & @CR)
	SetError($_ServiceStatus_COMError)
	Return
EndFunc   ;==>_sServInternalErrorHandler

Func _sServInternalErrorHandlerDeRegister()
	$oServiceErrorHandler = ""
	If $sServiceUserErrorHandler <> "" Then
		$oServiceErrorHandler = ObjEvent("AutoIt.Error", $sServiceUserErrorHandler)
	EndIf
	SetError($_ServiceStatus_Success)
	Return 1
EndFunc   ;==>_sServInternalErrorHandlerDeRegister