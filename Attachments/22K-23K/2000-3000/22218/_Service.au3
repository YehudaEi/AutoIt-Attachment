#AutoIt3Wrapper_Change2CUI=y
#include-once
#include<WinApi.au3>

#region Defined Variables and Constants
Global $STANDARD_RIGHTS_REQUIRED = 0x000F0000

; Service Control Manager access types
Global Const $SC_MANAGER_CONNECT = 0x0001
Global Const $SC_MANAGER_CREATE_SERVICE = 0x0002
Global Const $SC_MANAGER_ENUMERATE_SERVICE = 0x0004
Global Const $SC_MANAGER_LOCK = 0x0008
Global Const $SC_MANAGER_QUERY_LOCK_STATUS = 0x0010
Global Const $SC_MANAGER_MODIFY_BOOT_CONFIG = 0x0020
Global Const $SC_MANAGER_ALL_ACCESS = BitOR($STANDARD_RIGHTS_REQUIRED, $SC_MANAGER_CONNECT, $SC_MANAGER_CREATE_SERVICE, $SC_MANAGER_ENUMERATE_SERVICE, $SC_MANAGER_LOCK, $SC_MANAGER_QUERY_LOCK_STATUS, $SC_MANAGER_MODIFY_BOOT_CONFIG)

; Service Access Types
Global Const  $SERVICE_QUERY_CONFIG = 0x0001
Global Const $SERVICE_CHANGE_CONFIG = 0x0002
Global Const $SERVICE_QUERY_STATUS = 0x0004
Global Const $SERVICE_ENUMERATE_DEPENDENTS = 0x0008
Global Const $SERVICE_START = 0x0010
Global Const $SERVICE_STOP = 0x0020
Global Const $SERVICE_PAUSE_CONTINUE = 0x0040
Global Const $SERVICE_INTERROGATE = 0x0080
Global Const $SERVICE_USER_DEFINED_CONTROL = 0x0100
Global $SERVICE_ALL_ACCESS = BitOR($STANDARD_RIGHTS_REQUIRED, $SERVICE_QUERY_CONFIG, $SERVICE_CHANGE_CONFIG, $SERVICE_QUERY_STATUS, $SERVICE_ENUMERATE_DEPENDENTS, $SERVICE_START, $SERVICE_STOP, $SERVICE_PAUSE_CONTINUE, $SERVICE_INTERROGATE, $SERVICE_USER_DEFINED_CONTROL)

; Service Controls
Global Const $SERVICE_CONTROL_STOP = 0x00000001
Global Const $SERVICE_CONTROL_PAUSE = 0x00000002
Global Const $SERVICE_CONTROL_CONTINUE = 0x00000003
Global Const $SERVICE_CONTROL_INTERROGATE = 0x00000004
Global Const $SERVICE_CONTROL_SHUTDOWN = 0x00000005
Global Const $SERVICE_CONTROL_PARAMCHANGE = 0x00000006
Global Const $SERVICE_CONTROL_NETBINDADD = 0x00000007
Global Const $SERVICE_CONTROL_NETBINDREMOVE = 0x00000008
Global Const $SERVICE_CONTROL_NETBINDENABLE = 0x00000009
Global Const $SERVICE_CONTROL_NETBINDDISABLE = 0x0000000A
Global Const $SERVICE_CONTROL_DEVICEEVENT = 0x0000000B
Global Const $SERVICE_CONTROL_HARDWAREPROFILECHANGE = 0x0000000C
Global Const $SERVICE_CONTROL_POWEREVENT = 0x0000000D
Global Const $SERVICE_CONTROL_SESSIONCHANGE = 0x0000000E

; Service Types
Global Const $SERVICE_KERNEL_DRIVER = 0x00000001
Global Const $SERVICE_FILE_SYSTEM_DRIVER = 0x00000002
Global Const $SERVICE_ADAPTER = 0x00000004
Global Const $SERVICE_RECOGNIZER_DRIVER = 0x00000008
Global Const $SERVICE_DRIVER = BitOR($SERVICE_KERNEL_DRIVER, $SERVICE_FILE_SYSTEM_DRIVER, $SERVICE_RECOGNIZER_DRIVER)
Global Const $SERVICE_WIN32_OWN_PROCESS = 0x00000010
Global Const $SERVICE_WIN32_SHARE_PROCESS = 0x00000020
Global Const $SERVICE_WIN32 = BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_WIN32_SHARE_PROCESS)
Global Const $SERVICE_INTERACTIVE_PROCESS = 0x00000100
Global Const $SERVICE_TYPE_ALL = BitOR($SERVICE_WIN32, $SERVICE_ADAPTER, $SERVICE_DRIVER, $SERVICE_INTERACTIVE_PROCESS)

; Service Start Types
Global Const $SERVICE_BOOT_START = 0x00000000
Global Const $SERVICE_SYSTEM_START = 0x00000001
Global Const $SERVICE_AUTO_START = 0x00000002
Global Const $SERVICE_DEMAND_START = 0x00000003
Global Const $SERVICE_DISABLED = 0x00000004

; Service Error Control
Global Const $SERVICE_ERROR_IGNORE = 0x00000000
Global Const $SERVICE_ERROR_NORMAL = 0x00000001
Global Const $SERVICE_ERROR_SEVERE = 0x00000002
Global Const $SERVICE_ERROR_CRITICAL = 0x00000003
Global Const $SERVICE_ACCEPT_HARDWAREPROFILECHANGE = 0x20
Global Const $SERVICE_ACCEPT_NETBINDCHANGE = 0x10
Global Const $SERVICE_ACCEPT_PARAMCHANGE = 0x8
Global Const $SERVICE_ACCEPT_PAUSE_CONTINUE = 0x2
Global Const $SERVICE_ACCEPT_POWEREVENT = 0x40
Global Const $SERVICE_ACCEPT_SESSIONCHANGE = 0x80
Global Const $SERVICE_ACCEPT_PRESHUTDOWN = 0x100
Global Const $SERVICE_ACCEPT_SHUTDOWN = 0x4
Global Const $SERVICE_ACCEPT_STOP = 0x1
Global Const $SERVICE_ACTIVE = 0x1
Global Const $SERVICE_INACTIVE = 0x2
Global Const $SERVICE_PAUSE_PENDING = 0x6
Global Const $SERVICE_PAUSED = 0x7
Global Const $SERVICE_RUNNING = 0x4
Global Const $SERVICE_START_PENDING = 0x2
Global Const $SERVICE_STOP_PENDING = 0x3
Global Const $SERVICE_STOPPED = 0x1
Global Const $SERVICE_CONTINUE_PENDING = 0x5

;
Global $tServiceName,$tServiceCtrl,$tServiceMain,$service_debug_mode = False
Global $tService_Status = DllStructCreate("dword dwServiceType;dword dwCurrentState;dword dwControlsAccepted;dword dwWin32ExitCode;dword dwServiceSpecificExitCode;dword dwCheckPoint;dword dwWaitHint")
Global $tService_Status_handle
Global Const $NO_ERROR = 0
Global Const $NTSL_LOOP_WAIT = -1
Global $service_stop_event
Global $NTSL_ERROR_SERVICE_STATUS = 2
Global Const $WAIT_OBJECT_0 = 0x0
#endregion

#region Functions
Func _CreateService($sComputerName, $sServiceName, $sDisplayName, $sBinaryPath, $sServiceUser = "LocalSystem", $sPassword = "", $nServiceType = 0x00000010, $nStartType = 0x00000002, $nErrorType = 0x00000001, $nDesiredAccess = 0x000f01ff, $sLoadOrderGroup = "")
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $lError = -1   
	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", "str", $sComputerName, "str", "ServicesActive", "long", $SC_MANAGER_ALL_ACCESS)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", "long", $hSC, "str", $sServiceName, "long", $SERVICE_INTERROGATE)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hAdvapi32, "long", "CreateService", "long", $hSC, "str", $sServiceName, "str", $sDisplayName, "long", $nDesiredAccess, "long", $nServiceType, "long", $nStartType, "long", $nErrorType, "str", $sBinaryPath, "str", $sLoadOrderGroup, "ptr", 0, "str", "", "str", $sServiceUser, "str", $sPassword)
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
EndFunc

Func _DeleteService($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $hService
	Local $lError = -1   

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", "str", $sComputerName, "str", "ServicesActive", "long", $SC_MANAGER_ALL_ACCESS)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", "long", $hSC, "str", $sServiceName, "long", $SERVICE_ALL_ACCESS)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hKernel32, "long", "GetLastError")
			$lError = $arRet[0]
		Else
			$hService = $arRet[0]
			$arRet = DllCall($hAdvapi32, "int", "DeleteService", "long", $hService)
			If $arRet[0] = 0 Then
				$arRet = DllCall($hKernel32, "long", "GetLastError")
				$lError = $arRet[0]
			EndIf
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hService)
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
EndFunc

Func _StopService($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $hService
	Local $lError = -1

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", "str", $sComputerName, "str", "ServicesActive", "long", $SC_MANAGER_CONNECT)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", "long", $hSC, "str", $sServiceName, "long", $SERVICE_STOP)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hKernel32, "long", "GetLastError")
			$lError = $arRet[0]
		Else
			$hService = $arRet[0]
			$arRet = DllCall($hAdvapi32, "int", "ControlService", "long", $hService, "long", $SERVICE_CONTROL_STOP, "str", "")
			If $arRet[0] = 0 Then
				$arRet = DllCall($hKernel32, "long", "GetLastError")
				$lError = $arRet[0]
			EndIf
			DllCall($hAdvapi32, "int", "CloseServiceHandle", "long", $hService)         
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
EndFunc

Func _ServiceExists($sComputerName, $sServiceName)
	Local $hAdvapi32
	Local $hKernel32
	Local $arRet
	Local $hSC
	Local $hService
	Local $lError = -1

	$hAdvapi32 = DllOpen("advapi32.dll")
	If $hAdvapi32 = -1 Then Return 0
	$hKernel32 = DllOpen("kernel32.dll")
	If $hKernel32 = -1 Then Return 0
	$arRet = DllCall($hAdvapi32, "long", "OpenSCManager", "str", $sComputerName, "str", "ServicesActive", "long", $SC_MANAGER_CONNECT)
	If $arRet[0] = 0 Then
		$arRet = DllCall($hKernel32, "long", "GetLastError")
		$lError = $arRet[0]
	Else
		$hSC = $arRet[0]
		$arRet = DllCall($hAdvapi32, "long", "OpenService", "long", $hSC, "str", $sServiceName, "long", $SERVICE_STOP)
		If $arRet[0] = 0 Then
			$arRet = DllCall($hKernel32, "long", "GetLastError")
			$lError = $arRet[0]    
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
EndFunc

Func _Service_Cleanup()
	$service_error = _WinAPI_GetLastError()
	If ($tService_Status_handle) Then _Service_ReportStatus($SERVICE_STOPPED, $service_error, 0);
EndFunc

Func _Service_Ctrl($ctrlCode)
	Switch ($ctrlCode)
		Case $SERVICE_CONTROL_PAUSE
			DllStructSetData($tService_Status, "dwCurrentState", $SERVICE_PAUSED)
		Case $SERVICE_CONTROL_CONTINUE
			DllStructSetData($tService_Status, "dwCurrentState", $SERVICE_RUNNING)
		Case $SERVICE_CONTROL_STOP
			_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, 0);
			_Service_SetStopEvent();
			_Service_Cleanup()
			Exit
		Case $SERVICE_CONTROL_INTERROGATE
			;break;
			; invalid control code
			;
		Case Else
			;
	EndSwitch
	_Service_ReportStatus(DllStructGetData($tService_Status, "dwCurrentState"), $NO_ERROR, 0);
EndFunc

Func _Service_Halting()
	Return (_WinAPI_WaitForSingleObject($service_stop_event, $NTSL_LOOP_WAIT) == $WAIT_OBJECT_0);
EndFunc

Func _Service_Init($sServiceName)	
	$tServiceCtrl = DllCallbackRegister("_Service_Ctrl", "int", "uint")
	$tServiceMain = DllCallbackRegister("_Service_ServiceMain", "int", "int;str")	
	$tdispatchTable = DllStructCreate("ptr[2];ptr[2]")
	$tServiceName = DllStructCreate("char[128]")
	DllStructSetData($tServiceName, 1, $sServiceName)
	DllStructSetData($tdispatchTable, 1, DllStructGetPtr($tServiceName), 1)
	DllStructSetData($tdispatchTable, 1, DllCallbackGetPtr($tServiceMain), 2)
	DllStructSetData($tdispatchTable, 2, 0, 1)
	DllStructSetData($tdispatchTable, 2, 0, 2)
	$ret = DllCall("advapi32.dll", "int", "StartServiceCtrlDispatcher", "ptr", DllStructGetPtr($tdispatchTable))
	;If $ret[0] = 0 Then MsgBox(0, "", " Error " & _WinAPI_GetLastError() & @CRLF)
EndFunc 

Func _Service_ReportStatus($currentState, $exitCode, $waitHint)
	Local $checkPoint = 1;
	Local $rc = True;
	If Not ($service_debug_mode) Then ;when debugging we don't report to the SCM
		If ($currentState == $SERVICE_START_PENDING) Then
			DllStructSetData($tService_Status, "dwControlsAccepted", 0);
		Else
			DllStructSetData($tService_Status, "dwControlsAccepted", $SERVICE_ACCEPT_STOP)
		EndIf
		
		DllStructSetData($tService_Status, "dwCurrentState", $currentState)
		DllStructSetData($tService_Status, "dwWin32ExitCode", $exitCode)
		DllStructSetData($tService_Status, "dwWaitHint", $waitHint)
		If $currentState == $SERVICE_RUNNING Or $currentState == $SERVICE_STOPPED Then
			DllStructSetData($tService_Status, "dwCheckPoint", 0)
		Else
			DllStructSetData($tService_Status, "dwCheckPoint", $checkPoint + 1);
		EndIf
		; report the status of the service to the service control manager.
		If Not ($rc = _Service_SetServiceStatus($tService_Status_handle, DllStructGetPtr($tService_Status))) Then ConsoleWrite("+ " & $NTSL_ERROR_SERVICE_STATUS & @TAB & _WinAPI_GetLastError() & @CRLF)
	EndIf
	Return ($rc);
EndFunc

Func _Service_ServiceMain($iArg, $sArgs)
	$ret = DllCall("advapi32.dll", "hwnd", "RegisterServiceCtrlHandler", "ptr", DllStructGetPtr($tServiceName), "ptr", DllCallbackGetPtr($tServiceCtrl));register service
	If $ret[0] = 0 Then
		MsgBox(0, "Error", _WinAPI_GetLastError())
		Exit
	EndIf
	$tService_Status_handle = $ret[0]
	If Not ($tService_Status_handle) Then
		_Service_Cleanup()
		Return
	EndIf

	DllStructSetData($tService_Status, "dwServiceType", $SERVICE_WIN32_OWN_PROCESS)
	DllStructSetData($tService_Status, "dwServiceSpecificExitCode", 0);
	; report the status to the service control manager.
	If Not (_Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000)) Then
		_Service_Cleanup()
		Return
	EndIf
	_Service_Start($iArg, $sArgs);
	_Main()
	Return;
EndFunc

Func _Service_SetServiceStatus($hServiceStatus, $lpServiceStatus)
	$ret = DllCall("advapi32.dll", "int", "SetServiceStatus", "hwnd", $hServiceStatus, "ptr", $lpServiceStatus)
	Return $ret[0]
EndFunc

Func _Service_SetStopEvent()
	If ($service_stop_event) Then _WinAPI_SetEvent($service_stop_event) 
EndFunc 

Func _Service_Start($argc, $argv)
	If Not (_Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000)) Then Return
	$service_stop_event = _WinAPI_CreateEvent(0, True, False, 0);
	If Not ($service_stop_event) Then Return;
	;report the status to the service control manager.
	If Not _Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000) Then Return;
	;report the status to the service control manager.
	If Not _Service_ReportStatus($SERVICE_RUNNING, $NO_ERROR, 0) Then Return;
EndFunc

#endregion