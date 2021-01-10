#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <WinApi.au3>

Global $STANDARD_RIGHTS_REQUIRED = 0x000F0000

; Service Control Manager access types
Global Const $SC_MANAGER_CONNECT = 0x0001
Global Const $SC_MANAGER_CREATE_SERVICE = 0x0002
Global Const $SC_MANAGER_ENUMERATE_SERVICE = 0x0004
Global Const $SC_MANAGER_LOCK = 0x0008
Global Const $SC_MANAGER_QUERY_LOCK_STATUS = 0x0010
Global Const $SC_MANAGER_MODIFY_BOOT_CONFIG = 0x0020

Global Const $SC_MANAGER_ALL_ACCESS = BitOR($STANDARD_RIGHTS_REQUIRED, _
                                      $SC_MANAGER_CONNECT, _
                                      $SC_MANAGER_CREATE_SERVICE, _
                                      $SC_MANAGER_ENUMERATE_SERVICE, _
                                      $SC_MANAGER_LOCK, _
                                      $SC_MANAGER_QUERY_LOCK_STATUS, _
                                      $SC_MANAGER_MODIFY_BOOT_CONFIG)

; Service access types
Global Const  $SERVICE_QUERY_CONFIG = 0x0001
Global Const $SERVICE_CHANGE_CONFIG = 0x0002
Global Const $SERVICE_QUERY_STATUS = 0x0004
Global Const $SERVICE_ENUMERATE_DEPENDENTS = 0x0008
Global Const $SERVICE_START = 0x0010
Global Const $SERVICE_STOP = 0x0020
Global Const $SERVICE_PAUSE_CONTINUE = 0x0040
Global Const $SERVICE_INTERROGATE = 0x0080
Global Const $SERVICE_USER_DEFINED_CONTROL = 0x0100

Global $SERVICE_ALL_ACCESS = BitOR($STANDARD_RIGHTS_REQUIRED, _
                                   $SERVICE_QUERY_CONFIG, _
                                   $SERVICE_CHANGE_CONFIG, _
                                   $SERVICE_QUERY_STATUS, _
                                   $SERVICE_ENUMERATE_DEPENDENTS, _
                                   $SERVICE_START, _
                                   $SERVICE_STOP, _
                                   $SERVICE_PAUSE_CONTINUE, _
                                   $SERVICE_INTERROGATE, _
                                   $SERVICE_USER_DEFINED_CONTROL)

; Service controls
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

; Service types
Global Const $SERVICE_KERNEL_DRIVER = 0x00000001
Global Const $SERVICE_FILE_SYSTEM_DRIVER = 0x00000002
Global Const $SERVICE_ADAPTER = 0x00000004
Global Const $SERVICE_RECOGNIZER_DRIVER = 0x00000008
Global Const $SERVICE_DRIVER = BitOR($SERVICE_KERNEL_DRIVER, _
                               $SERVICE_FILE_SYSTEM_DRIVER, _
                               $SERVICE_RECOGNIZER_DRIVER)
Global Const $SERVICE_WIN32_OWN_PROCESS = 0x00000010
Global Const $SERVICE_WIN32_SHARE_PROCESS = 0x00000020
Global Const $SERVICE_WIN32 = BitOR($SERVICE_WIN32_OWN_PROCESS, _
                              $SERVICE_WIN32_SHARE_PROCESS)
Global Const $SERVICE_INTERACTIVE_PROCESS = 0x00000100
Global Const $SERVICE_TYPE_ALL = BitOR($SERVICE_WIN32, _
                                 $SERVICE_ADAPTER, _
                                 $SERVICE_DRIVER, _
                                 $SERVICE_INTERACTIVE_PROCESS)

; Service start types
Global Const $SERVICE_BOOT_START = 0x00000000
Global Const $SERVICE_SYSTEM_START = 0x00000001
Global Const $SERVICE_AUTO_START = 0x00000002
Global Const $SERVICE_DEMAND_START = 0x00000003
Global Const $SERVICE_DISABLED = 0x00000004

; Service error control
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
Global $tService_Status = DllStructCreate("dword dwServiceType;" & _
		"dword dwCurrentState;dword dwControlsAccepted;dword dwWin32ExitCode;" & _
		"dword dwServiceSpecificExitCode;dword dwCheckPoint;dword dwWaitHint")
Global $tService_Status_handle
Global Const $NO_ERROR = 0
Global Const $NTSL_LOOP_WAIT = -1
Global $service_stop_event
Global $NTSL_ERROR_SERVICE_STATUS = 2
Global Const $WAIT_OBJECT_0 = 0x0


;Func _Service_init($sServiceName = "",$sServiceMainFunctionName = "_Service_ServiceMain")

Func _Service_init($sServiceName)	
	
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
	If $ret[0] = 0 Then MsgBox(16, "", " Error " & _WinAPI_GetLastError() & @CRLF)
	
EndFunc   ;==>_Service_init
;msgbox(0,"",$ret[0])
;EndFunc

Func _Service_Cleanup()
	$service_error = _WinAPI_GetLastError()
	If ($tService_Status_handle) Then _Service_ReportStatus($SERVICE_STOPPED, $service_error, 0);
EndFunc   ;==>cleanup
Func _Service_ServiceMain($iArg, $sArgs)
	;msgbox(0,"","service_main started")
	
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
	;goto cleanup;
	DllStructSetData($tService_Status, "dwServiceType", $SERVICE_WIN32_OWN_PROCESS)
	DllStructSetData($tService_Status, "dwServiceSpecificExitCode", 0);
	
	; report the status to the service control manager.
	If Not (_Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000)) Then
		;goto cleanup;
		_Service_Cleanup()
		Return
	EndIf
	_Service_Start($iArg, $sArgs);
	;cleanup:
	; try to report the stopped status to the service control manager.
	main()
	;Return;
EndFunc   ;==>Service_Main
;/*------------------------------[ service_ctrl ]------------------------------
; *  Called by the SCM whenever ControlService() is called for this service
; *
; *  Parameters:
; *		ctrlCode - type of control requested
; *
; *  Return value:
; *		none
; *----------------------------------------------------------------------------*/
Func _Service_Ctrl($ctrlCode)
	Switch ($ctrlCode)
		Case $SERVICE_CONTROL_PAUSE
			DllStructSetData($tService_Status, "dwCurrentState", $SERVICE_PAUSED)
		Case $SERVICE_CONTROL_CONTINUE
			DllStructSetData($tService_Status, "dwCurrentState", $SERVICE_RUNNING)
			;stop the service.
			;
			;SERVICE_STOP_PENDING should be reported before
			;setting the Stop Event - hServerStopEvent - in
			;service_stop().  This avoids a race condition
			;which may result in a 1053 - The Service did not respond...
			;error.
		Case $SERVICE_CONTROL_STOP
			;MsgBox(0,"","Service stop")
			_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, 0);
			_Service_SetStopEvent();
			_Service_Cleanup()
			Exit
			;return;
			
			; Update the service status.
			;
		Case $SERVICE_CONTROL_INTERROGATE
			;break;
			; invalid control code
			;
		Case Else
			;
	EndSwitch
	_Service_ReportStatus(DllStructGetData($tService_Status, "dwCurrentState"), $NO_ERROR, 0);
EndFunc   ;==>service_ctrl
;/*-----------------------------[ service_halting ]-----------------------------
; *  Service status
; *
; *  Returns:
; *		running		0
; *		halting		1
; *----------------------------------------------------------------------------*/
Func _Service_Halting()
	Return (_WinAPI_WaitForSingleObject($service_stop_event, $NTSL_LOOP_WAIT) == $WAIT_OBJECT_0);
EndFunc   ;==>service_halting
;/*--------------------------[ _Service_ReportStatus ]--------------------------
; *  Sets the current status and reports it to the Service Control Manager
; *
; *  Parameters:
; *		currentState	-  the state of the service
; *		exitCode		-  error code to report
; *		waitHint		-  worst case estimate to next checkpoint
; *
; *  Return value:
; *		true			-  success
; *		false			-  failure
; *----------------------------------------------------------------------------*/
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
		If Not ($rc = _Service_SetServiceStatus($tService_Status_handle, DllStructGetPtr($tService_Status))) Then
			ntsl_log_error($NTSL_ERROR_SERVICE_STATUS, _WinAPI_GetLastError());
		EndIf
	EndIf
	Return ($rc);
EndFunc   ;==>_Service_ReportStatus
Func ntsl_log_error($intCode, $sDescription)
	ConsoleWrite("+ " & $intCode & @TAB & $sDescription & @CRLF)
EndFunc   ;==>ntsl_log_error
Func _Service_SetServiceStatus($hServiceStatus, $lpServiceStatus)
	$ret = DllCall("advapi32.dll", "int", "SetServiceStatus", "hwnd", $hServiceStatus, "ptr", $lpServiceStatus)
	;__in  SERVICE_STATUS_HANDLE hServiceStatus,
	;__in  LPSERVICE_STATUS lpServiceStatus
	Return $ret[0]
EndFunc   ;==>SetServiceStatus
;/*-----------------------------[ service_remove ]-----------------------------
; *  Stops and removes the service
; *----------------------------------------------------------------------------*/~
#cs
	func service_remove()
	
	SC_HANDLE   service;
	SC_HANDLE   manager;
	
	manager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
	
	if (manager)
	{
	service = OpenService(manager, TEXT(SERVICE_NAME), SERVICE_ALL_ACCESS);
	
	if (service)
	{
	// try to stop the service
	if ( ControlService( service, SERVICE_CONTROL_STOP, &service_status ) )
	{
	_tprintf(TEXT("Stopping %s."), TEXT(SERVICE_NAME));
	Sleep(1000);
	
	while(QueryServiceStatus(service, &service_status))
	{
	if (service_status.dwCurrentState == SERVICE_STOP_PENDING)
	{
	_tprintf(TEXT("."));
	Sleep( 1000 );
	}
	else
	break;
	}
	
	if (service_status.dwCurrentState == SERVICE_STOPPED)
	_tprintf(TEXT("\n%s stopped.\n"), TEXT(SERVICE_NAME));
	else
	_tprintf(TEXT("\n%s failed to stop.\n"), TEXT(SERVICE_NAME));
	}
	
	// now remove the service
	if( DeleteService(service) )
	_tprintf(TEXT("%s removed.\n"), TEXT(SERVICE_NAME));
	else
	_tprintf(TEXT("DeleteService failed - %s\n"),
	GetLastErrorText(service_error_msg, NTSL_SYS_LEN));
	
	
	CloseServiceHandle(service);
	}
	else
	_tprintf(TEXT("OpenService failed - %s\n"),
	GetLastErrorText(service_error_msg, NTSL_SYS_LEN));
	
	CloseServiceHandle(manager);
	}
	else
	_tprintf(TEXT("OpenSCManager failed - %s\n"),
	GetLastErrorText(service_error_msg, NTSL_SYS_LEN));
	}
	
	
#ce
;/*------------------------------[ service_debug ]------------------------------
; *  Runs the service as a console application
; *
; *  Parameters:
; *		argc  -  number of command line arguments
; *		argv  -  array of command line arguments
; *----------------------------------------------------------------------------*/
;static void service_debug(int argc, char **argv)
;{
;    _tprintf(TEXT("Debugging %s.\n"), TEXT(SERVICE_NAME));
;
;   SetConsoleCtrlHandler( service_control_handler, TRUE );
;   service_start(argc, argv);
;}
;/*-------------------------[ service_control_handler ]-------------------------
; *  Handles console control events.
; *
; *  Parameters:
; *		crtlType  -  type of control event
; *
; *  Return value:
; *		true  - handled
; *      false - not handled
; *----------------------------------------------------------------------------*/
;static bool WINAPI service_control_handler(uint32 ctrlType)
;{
;    switch(ctrlType)
;    {
;        case CTRL_BREAK_EVENT:  // use Ctrl+C or Ctrl+Break to simulate
;        case CTRL_C_EVENT:      // SERVICE_CONTROL_STOP in debug mode
;            _tprintf(TEXT("Stopping %s.\n"), TEXT(SERVICE_NAME));
;            service_stop();
;            return true;
;            break;
;    }
;    return false;
;}
;/*------------------------------[ service_start ]------------------------------
; * Starts and runs the service
; *----------------------------------------------------------------------------*/
Func _Service_Start($argc, $argv)
	
	; report the status to the service control manager.
	If Not (_Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000)) Then Return
	
	; create the event object. The control handler function signals
	;this event when it receives the "stop" control code.
	$service_stop_event = _WinAPI_CreateEvent(0, True, False, 0);
	If Not ($service_stop_event) Then
		;msgbox(0,"","Service stop event handle = 0")
		Return;
	Else
		;msgbox(0,"","$service_stop_event" & $service_stop_event)
	EndIf
	
	;report the status to the service control manager.
	If Not _Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000) Then Return;
	;report the status to the service control manager.
	If Not _Service_ReportStatus($SERVICE_RUNNING, $NO_ERROR, 0) Then Return;
	
	;ntsl_run();
EndFunc   ;==>service_start
;
;/*------------------------------[ service_stop ]------------------------------
; * Stops the service.
; *
; * NOTE: If this service will take longer than 3 seconds,
; * spawn a thread to execute the stop code and return.
; * Otherwise the SCM will think the service has stopped responding.
; *----------------------------------------------------------------------------*/
Func _Service_SetStopEvent()
	If ($service_stop_event) Then
		
		 _WinAPI_SetEvent($service_stop_event) 
		
	EndIf
EndFunc   ;==>service_stop


;===============================================================================
; Description:   Creates a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to create
;                $sDisplayName - display name of the service
;                $sBinaryPath - fully qualified path to the service binary file
;                               The path can also include arguments for an auto-start service
;                $sServiceUser - [optional] default is LocalSystem
;                                name of the account under which the service should run
;                $sPassword - [optional] default is empty
;                             password to the account name specified by $sServiceUser
;                             Specify an empty string if the account has no password or if the service 
;                             runs in the LocalService, NetworkService, or LocalSystem account
;                 $nServiceType - [optional] default is $SERVICE_WIN32_OWN_PROCESS
;                 $nStartType - [optional] default is $SERVICE_AUTO_START
;                 $nErrorType - [optional] default is $SERVICE_ERROR_NORMAL
;                 $nDesiredAccess - [optional] default is $SERVICE_ALL_ACCESS
;                 $sLoadOrderGroup - [optional] default is empty
;                                    names the load ordering group of which this service is a member
; Requirements:  Administrative rights on the computer
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
; Note:          Dependencies cannot be specified using this function
;                Refer to the CreateService page on MSDN for more information
;===============================================================================
Func _Service_Create($sComputerName, _
                    $sServiceName, _
                    $sDisplayName, _
                    $sBinaryPath, _
                    $sServiceUser = "LocalSystem", _
                    $sPassword = "", _
                    $nServiceType = 0x00000010, _
                    $nStartType = 0x00000002, _
                    $nErrorType = 0x00000001, _
                    $nDesiredAccess = 0x000f01ff, _
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
EndFunc

;===============================================================================
; Description:   Deletes a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to delete
; Requirements:  Administrative rights on the computer
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
;===============================================================================
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
                       "long", $SERVICE_ALL_ACCESS)
      If $arRet[0] = 0 Then
         $arRet = DllCall($hKernel32, "long", "GetLastError")
         $lError = $arRet[0]
      Else
         $hService = $arRet[0]
         $arRet = DllCall($hAdvapi32, "int", "DeleteService", _
                          "long", $hService)
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
;===============================================================================
; Description:   Stops a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to stop
; Requirements:  None
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
; Note:          This function does not check to see if the service has stopped successfully
;===============================================================================
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
   $arRet = DllCall($hAdvapi32, "long", "OpenSCManager", _
                    "str", $sComputerName, _
                    "str", "ServicesActive", _
                    "long", $SC_MANAGER_CONNECT)
   If $arRet[0] = 0 Then
      $arRet = DllCall($hKernel32, "long", "GetLastError")
      $lError = $arRet[0]
   Else
      $hSC = $arRet[0]
      $arRet = DllCall($hAdvapi32, "long", "OpenService", _
                       "long", $hSC, _
                       "str", $sServiceName, _
                       "long", $SERVICE_STOP)
      If $arRet[0] = 0 Then
         $arRet = DllCall($hKernel32, "long", "GetLastError")
         $lError = $arRet[0]
      Else
         $hService = $arRet[0]
         $arRet = DllCall($hAdvapi32, "int", "ControlService", _
                          "long", $hService, _
                          "long", $SERVICE_CONTROL_STOP, _
                          "str", "")
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
