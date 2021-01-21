AutoItSetOption("MustDeclareVars", 1)

#include <Array.au3>

Global Const $STANDARD_RIGHTS_REQUIRED 		= 0x000F0000
Global Const $SC_STATUS_PROCESS_INFO 		= 0

; Service Control Manager access types
Global Const $SC_MANAGER_CONNECT 			= 0x0001
Global Const $SC_MANAGER_CREATE_SERVICE 	= 0x0002
Global Const $SC_MANAGER_ENUMERATE_SERVICE 	= 0x0004
Global Const $SC_MANAGER_LOCK 				= 0x0008
Global Const $SC_MANAGER_QUERY_LOCK_STATUS 	= 0x0010
Global Const $SC_MANAGER_MODIFY_BOOT_CONFIG = 0x0020
Global Const $SC_MANAGER_ALL_ACCESS 		= BitOR($STANDARD_RIGHTS_REQUIRED, _
													$SC_MANAGER_CONNECT, _
													$SC_MANAGER_CREATE_SERVICE, _
													$SC_MANAGER_ENUMERATE_SERVICE, _
													$SC_MANAGER_LOCK, _
													$SC_MANAGER_QUERY_LOCK_STATUS, _
													$SC_MANAGER_MODIFY_BOOT_CONFIG)

; Service access types
Global Const $SERVICE_QUERY_CONFIG 			= 0x0001
Global Const $SERVICE_CHANGE_CONFIG 		= 0x0002
Global Const $SERVICE_QUERY_STATUS 			= 0x0004
Global Const $SERVICE_ENUMERATE_DEPENDENTS 	= 0x0008
Global Const $SERVICE_START 				= 0x0010
Global Const $SERVICE_STOP 					= 0x0020
Global Const $SERVICE_PAUSE_CONTINUE 		= 0x0040
Global Const $SERVICE_INTERROGATE 			= 0x0080
Global Const $SERVICE_USER_DEFINED_CONTROL 	= 0x0100
Global Const $SERVICE_ALL_ACCESS 			= BitOR($STANDARD_RIGHTS_REQUIRED, _
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
Global Const $SERVICE_CONTROL_STOP 					= 0x00000001
Global Const $SERVICE_CONTROL_PAUSE 				= 0x00000002
Global Const $SERVICE_CONTROL_CONTINUE 				= 0x00000003
Global Const $SERVICE_CONTROL_INTERROGATE 			= 0x00000004
Global Const $SERVICE_CONTROL_SHUTDOWN 				= 0x00000005
Global Const $SERVICE_CONTROL_PARAMCHANGE 			= 0x00000006
Global Const $SERVICE_CONTROL_NETBINDADD 			= 0x00000007
Global Const $SERVICE_CONTROL_NETBINDREMOVE 		= 0x00000008
Global Const $SERVICE_CONTROL_NETBINDENABLE 		= 0x00000009
Global Const $SERVICE_CONTROL_NETBINDDISABLE 		= 0x0000000A
Global Const $SERVICE_CONTROL_DEVICEEVENT 			= 0x0000000B
Global Const $SERVICE_CONTROL_HARDWAREPROFILECHANGE	= 0x0000000C
Global Const $SERVICE_CONTROL_POWEREVENT 			= 0x0000000D
Global Const $SERVICE_CONTROL_SESSIONCHANGE 		= 0x0000000E

; Service State -- for CurrentState
Global Const $SERVICE_STOPPED				= 0x00000001
Global Const $SERVICE_START_PENDING			= 0x00000002
Global Const $SERVICE_STOP_PENDING			= 0x00000003
Global Const $SERVICE_RUNNING				= 0x00000004
Global Const $SERVICE_CONTINUE_PENDING		= 0x00000005
Global Const $SERVICE_PAUSE_PENDING			= 0x00000006
Global Const $SERVICE_PAUSED				= 0x00000007

; Controls Accepted  (Bit Mask)
Global Const $SERVICE_ACCEPT_STOP			= 0x00000001
Global Const $SERVICE_ACCEPT_PAUSE_CONTINUE = 0x00000002
Global Const $SERVICE_ACCEPT_SHUTDOWN		= 0x00000004
Global Const $SERVICE_ACCEPT_PARAMCHANGE	= 0x00000008
Global Const $SERVICE_ACCEPT_NETBINDCHANGE	= 0x00000010

; Service types
Global Const $SERVICE_KERNEL_DRIVER 		= 0x00000001
Global Const $SERVICE_FILE_SYSTEM_DRIVER 	= 0x00000002
Global Const $SERVICE_ADAPTER 				= 0x00000004
Global Const $SERVICE_RECOGNIZER_DRIVER 	= 0x00000008
Global Const $SERVICE_DRIVER				= BitOR($SERVICE_KERNEL_DRIVER, _
													$SERVICE_FILE_SYSTEM_DRIVER, _
													$SERVICE_RECOGNIZER_DRIVER)
Global Const $SERVICE_WIN32_OWN_PROCESS 	= 0x00000010
Global Const $SERVICE_WIN32_SHARE_PROCESS 	= 0x00000020
Global Const $SERVICE_WIN32 				= BitOR($SERVICE_WIN32_OWN_PROCESS, _
													$SERVICE_WIN32_SHARE_PROCESS)
Global Const $SERVICE_INTERACTIVE_PROCESS 	= 0x00000100
Global Const $SERVICE_TYPE_ALL 				= BitOR($SERVICE_WIN32, _
													$SERVICE_ADAPTER, _
													$SERVICE_DRIVER, _
													$SERVICE_INTERACTIVE_PROCESS)

; Service start types
Global Const $SERVICE_BOOT_START 			= 0x00000000
Global Const $SERVICE_SYSTEM_START 			= 0x00000001
Global Const $SERVICE_AUTO_START 			= 0x00000002
Global Const $SERVICE_DEMAND_START 			= 0x00000003
Global Const $SERVICE_DISABLED 				= 0x00000004

; Service error control
Global Const $SERVICE_ERROR_IGNORE 			= 0x00000000
Global Const $SERVICE_ERROR_NORMAL 			= 0x00000001
Global Const $SERVICE_ERROR_SEVERE 			= 0x00000002
Global Const $SERVICE_ERROR_CRITICAL 		= 0x00000003

Global Enum $SERVICESTATUS_dwServiceType = 1, _ 
			$SERVICESTATUS_dwCurrentState, _ 
			$SERVICESTATUS_dwControlsAccepted, _ 
			$SERVICESTATUS_dwWin32ExitCode, _ 
			$SERVICESTATUS_dwServiceSpecificExitCode, _ 
			$SERVICESTATUS_dwCheckPoint, _ 
			$SERVICESTATUS_dwWaitHint, _ 
			$SERVICESTATUS_dwProcessId, _ 
			$SERVICESTATUS_dwServiceFlags

Global Enum $SERVICECONFIG_dwServiceType = 1, _ 
			$SERVICECONFIG_dwStartType, _ 
			$SERVICECONFIG_dwErrorControl, _ 
			$SERVICECONFIG_lpBinaryPathName, _ 
			$SERVICECONFIG_lpLoadOrderGroup, _ 
			$SERVICECONFIG_dwTagId, _ 
			$SERVICECONFIG_lpDependencies, _ 
			$SERVICECONFIG_lpServiceStartName, _ 
			$SERVICECONFIG_lpDisplayName

Dim $hSCM
Dim $hService
Dim $aStatus

$hSCM = _OpenSCManager(@ComputerName, $SC_MANAGER_ALL_ACCESS)
$hService = _OpenService($hSCM, "spooler", $SERVICE_ALL_ACCESS)
$aStatus = _QueryServiceConfig2($hService)
ConsoleWrite(@error & @LF)
_CloseServiceHandle($hService)
_CloseServiceHandle($hSCM)

Func _OpenSCManager($sMachineName, $dwDesiredAccess)
	Local $aDllRet
	
	$aDllRet = DllCall("advapi32.dll", "ptr", "OpenSCManager", _ 
		"str", $sMachineName, _ 
		"int", 0, _ 
		"long", $dwDesiredAccess)
	If Not @error And $aDllRet[0] <> 0 Then Return $aDllRet[0]
	$aDllRet = DllCall("kernel32.dll", "long", "GetLastError")
	If Not @error Then SetError($aDllRet[0])
	Return 0
EndFunc

Func _OpenService($hSCM, $sServiceName, $dwDesiredAccess)
	Local $aDllRet
	
	$aDllRet = DllCall("advapi32.dll", "ptr", "OpenService", _ 
		"ptr", $hSCM, _ 
		"str", $sServiceName, _ 
		"long", $dwDesiredAccess)
	If Not @error And $aDllRet[0] <> 0 Then Return $aDllRet[0]
	$aDllRet = DllCall("kernel32.dll", "long", "GetLastError")
	If Not @error Then SetError($aDllRet[0])
	Return 0
EndFunc

Func _QueryServiceConfig($hService)
	Local $aDllRet
	Local $QUERY_SERVICE_CONFIG
	Local $lpBinaryPathName
	Local $lpLoadOrderGroup
	Local $lpDependencies
	Local $lpServiceStartName
	Local $lpDisplayName
	Local $aServiceConfig[9]
	Local $nError = 0
#cs
typedef struct _QUERY_SERVICE_CONFIG {  
	DWORD dwServiceType;  
	DWORD dwStartType;  
	DWORD dwErrorControl;  
	LPTSTR lpBinaryPathName;  
	LPTSTR lpLoadOrderGroup;  
	DWORD dwTagId;  
	LPTSTR lpDependencies;  
	LPTSTR lpServiceStartName;  
	LPTSTR lpDisplayName;
} QUERY_SERVICE_CONFIG, *LPQUERY_SERVICE_CONFIG;
#ce
	$QUERY_SERVICE_CONFIG = DllStructCreate("dword;dword;dword;ptr;ptr;dword;ptr;ptr;ptr")
	If Not @error Then
		$lpBinaryPathName = DllStructCreate("char[256]")
		DllStructSet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpBinaryPathName, DllStructPtr($lpBinaryPathName))
		$lpLoadOrderGroup = DllStructCreate("char[3704]")
		DllStructSet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpLoadOrderGroup, DllStructPtr($lpLoadOrderGroup))
		$lpDependencies = DllStructCreate("char[3704]")
		DllStructSet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpDependencies, DllStructPtr($lpDependencies))
		$lpServiceStartName = DllStructCreate("char[256]")
		DllStructSet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpServiceStartName, DllStructPtr($lpServiceStartName))
		$lpDisplayName = DllStructCreate("char[256]")
		DllStructSet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpDisplayName, DllStructPtr($lpDisplayName))
		$aDllRet = DllCall("advapi32.dll", "int", "QueryServiceConfig", _ 
			"ptr", $hService, _ 
			"ptr", DllStructPtr($QUERY_SERVICE_CONFIG), _ 
			"int", 8192, _ 
			"long_ptr", 0)
		If Not @error And $aDllRet[0] <> 0 Then
			ConsoleWrite(DllStructGet($lpBinaryPathName, 1) & @LF)
			ConsoleWrite(DllStructGet($lpDisplayName, 1) & @LF)
			ConsoleWrite(DllStructGet($lpServiceStartName, 1) & @LF)
		Else
			$aDllRet = DllCall("kernel32.dll", "long", "GetLastError")
			If Not @error Then $nError = $aDllRet[0]
		EndIf
	EndIf
	DllStructFree($lpBinaryPathName)
	DllStructFree($lpLoadOrderGroup)
	DllStructFree($lpDependencies)
	DllStructFree($lpServiceStartName)
	DllStructFree($lpDisplayName)
	DllStructFree($QUERY_SERVICE_CONFIG)
	If $nError <> 0 Then SetError($nError)
	Return $aServiceConfig
EndFunc

Func _QueryServiceConfig2($hService)
	Local $aDllRet
	Local $QUERY_SERVICE_CONFIG
	Local $pConfigBuffer
	Local $aServiceConfig[9]
	Local $nError = 0

	$QUERY_SERVICE_CONFIG = DllStructCreate("dword;dword;dword;ptr;ptr;dword;ptr;ptr;ptr")
	If Not @error Then
		$aDllRet = DllCall("advapi32.dll", "int", "QueryServiceConfig", _ 
			"ptr", $hService, _ 
			"ptr", 0, _ 
			"int", 0, _ 
			"long_ptr", 0)
		If Not @error And $aDllRet[4] > 0 Then
			$pConfigBuffer = DllStructCreate("byte[" & $aDllRet[4] & "]")
			$aDllRet = DllCall("advapi32.dll", "int", "QueryServiceConfig", _ 
				"ptr", $hService, _ 
				"ptr", DllStructPtr($pConfigBuffer), _ 
				"int", DllStructSize($pConfigBuffer), _ 
				"long_ptr", 0)
			If Not @error And $aDllRet[0] <> 0 Then
				$aDllRet = DllCall("kernel32.dll", "none", "RtlMoveMemory", _ 
					"ptr", DllStructPtr($QUERY_SERVICE_CONFIG), _ 
					"ptr", DllStructPtr($pConfigBuffer), _ 
					"int", DllStructSize($QUERY_SERVICE_CONFIG))
				If Not @error Then
					ConsoleWrite(DllStructGet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpBinaryPathName) & @LF)
				Else
					$aDllRet = DllCall("kernel32.dll", "long", "GetLastError")
					If Not @error Then $nError = $aDllRet[0]
				EndIf
			Else
				$aDllRet = DllCall("kernel32.dll", "long", "GetLastError")
				If Not @error Then $nError = $aDllRet[0]
			EndIf
		Else
			$aDllRet = DllCall("kernel32.dll", "long", "GetLastError")
			If Not @error Then $nError = $aDllRet[0]
		EndIf
	EndIf
	DllStructFree($pConfigBuffer)
	DllStructFree($QUERY_SERVICE_CONFIG)
	If $nError <> 0 Then SetError($nError)
	Return $aServiceConfig
EndFunc

Func _QueryServiceConfig3($hService)
	Local $aDllRet
	Local $QUERY_SERVICE_CONFIG
	Local $aServiceConfig[9]
	Local $nError = 0

	$QUERY_SERVICE_CONFIG = DllStructCreate("dword;dword;dword;char[256];char[2048];dword;char[2048];char[256];char[256]")
	If Not @error Then
		ConsoleWrite(DllStructSize($QUERY_SERVICE_CONFIG) & @LF)
		$aDllRet = DllCall("advapi32.dll", "int", "QueryServiceConfig", _ 
			"ptr", $hService, _ 
			"ptr", DllStructPtr($QUERY_SERVICE_CONFIG), _ 
			"int", DllStructSize($QUERY_SERVICE_CONFIG), _ 
			"long_ptr", 0)
		If Not @error And $aDllRet[0] <> 0 Then
			ConsoleWrite(DllStructGet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpBinaryPathName) & @LF)
			ConsoleWrite(DllStructGet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpServiceStartName) & @LF)
			ConsoleWrite(DllStructGet($QUERY_SERVICE_CONFIG, $SERVICECONFIG_lpDisplayName) & @LF)
		Else
			$aDllRet = DllCall("kernel32.dll", "long", "GetLastError")
			If Not @error Then $nError = $aDllRet[0]
		EndIf
	EndIf
	DllStructFree($QUERY_SERVICE_CONFIG)
	If $nError <> 0 Then SetError($nError)
	Return $aServiceConfig
EndFunc

Func _CloseServiceHandle($hSCObject)
	DllCall("advapi32.dll", "int", "CloseServiceHandle", "ptr", $hSCObject)
EndFunc
