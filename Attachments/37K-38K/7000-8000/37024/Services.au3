#include-once
#include <SecurityConstants.au3>
#include ".\SecurityEx.au3"

; #INDEX# ==========================================================================================================================================================
; Title .........: Services
; AutoIt Version : 3.3.8.0++
; Language ......: English
; Description ...: Windows service management for AutoIt.
; ==================================================================================================================================================================

; #CURRENT# ========================================================================================================================================================
;_Service_Change
;_Service_Create
;_Service_Delete
;_Service_Enum
;_Service_EnumDependent
;_Service_Exists
;_Service_Pause
;_Service_Resume
;_Service_QueryAccount
;_Service_QueryBinaryPath
;_Service_QueryConfig
;_Service_QueryDependencies
;_Service_QueryDesc
;_Service_QueryDisplayName
;_Service_QueryErrorControl
;_Service_QueryFailureActions
;_Service_QueryGroup
;_Service_QueryStartType
;_Service_QueryStatus
;_Service_QueryType
;_Service_SetAccount
;_Service_SetBinaryPath
;_Service_SetDependencies
;_Service_SetDesc
;_Service_SetDisplayName
;_Service_SetErrorControl
;_Service_SetFailureActions
;_Service_SetGroup
;_Service_SetStartType
;_Service_SetType
;_Service_Start
;_Service_Stop
; ==================================================================================================================================================================

; #INTERNAL_USE_ONLY#===============================================================================================================================================
;ChangeServiceConfig
;CloseServiceHandle
;ControlService
;GetLastError
;OpenSCManager
;OpenService
;QueryServiceConfig
; ==================================================================================================================================================================

; Access rights for the Service Control Manager
Global Const $SC_MANAGER_CONNECT = 0x0001
Global Const $SC_MANAGER_CREATE_SERVICE = 0x0002
Global Const $SC_MANAGER_ENUMERATE_SERVICE = 0x0004
Global Const $SC_MANAGER_LOCK = 0x0008
Global Const $SC_MANAGER_QUERY_LOCK_STATUS = 0x0010
Global Const $SC_MANAGER_MODIFY_BOOT_CONFIG = 0x0020

Global Const $SC_MANAGER_ALL_ACCESS = BitOR( $STANDARD_RIGHTS_REQUIRED, _
									$SC_MANAGER_CONNECT, _
									$SC_MANAGER_CREATE_SERVICE, _
									$SC_MANAGER_ENUMERATE_SERVICE, _
									$SC_MANAGER_LOCK, _
									$SC_MANAGER_QUERY_LOCK_STATUS, _
									$SC_MANAGER_MODIFY_BOOT_CONFIG )

; Access rights for a service
Global Const $SERVICE_QUERY_CONFIG = 0x0001
Global Const $SERVICE_CHANGE_CONFIG = 0x0002
Global Const $SERVICE_QUERY_STATUS = 0x0004
Global Const $SERVICE_ENUMERATE_DEPENDENTS = 0x0008
Global Const $SERVICE_START = 0x0010
Global Const $SERVICE_STOP = 0x0020
Global Const $SERVICE_PAUSE_CONTINUE = 0x0040
Global Const $SERVICE_INTERROGATE = 0x0080
Global Const $SERVICE_USER_DEFINED_CONTROL = 0x0100

Global Const $SERVICE_ALL_ACCESS = BitOR( $STANDARD_RIGHTS_REQUIRED, _
								$SERVICE_QUERY_CONFIG, _
								$SERVICE_CHANGE_CONFIG, _
								$SERVICE_QUERY_STATUS, _
								$SERVICE_ENUMERATE_DEPENDENTS, _
								$SERVICE_START, _
								$SERVICE_STOP, _
								$SERVICE_PAUSE_CONTINUE, _
								$SERVICE_INTERROGATE, _
								$SERVICE_USER_DEFINED_CONTROL )

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

; Service config
Global Const $SERVICE_NO_CHANGE = -1
Global Const $SERVICE_CONFIG_DESCRIPTION = 1
Global Const $SERVICE_CONFIG_FAILURE_ACTIONS = 2

; Service types
Global Const $SERVICE_KERNEL_DRIVER = 0x00000001
Global Const $SERVICE_FILE_SYSTEM_DRIVER = 0x00000002
Global Const $SERVICE_ADAPTER = 0x00000004
Global Const $SERVICE_RECOGNIZER_DRIVER = 0x00000008
Global Const $SERVICE_DRIVER = BitOR( $SERVICE_KERNEL_DRIVER, _
							$SERVICE_FILE_SYSTEM_DRIVER, _
							$SERVICE_RECOGNIZER_DRIVER )
Global Const $SERVICE_WIN32_OWN_PROCESS = 0x00000010
Global Const $SERVICE_WIN32_SHARE_PROCESS = 0x00000020
Global Const $SERVICE_WIN32 = BitOR( $SERVICE_WIN32_OWN_PROCESS, _
							$SERVICE_WIN32_SHARE_PROCESS )
Global Const $SERVICE_INTERACTIVE_PROCESS = 0x00000100
Global Const $SERVICE_TYPE_ALL = BitOR( $SERVICE_WIN32, _
								$SERVICE_ADAPTER, _
								$SERVICE_DRIVER, _
								$SERVICE_INTERACTIVE_PROCESS )

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

; Service state
Global Const $SERVICE_STOPPED = 0x00000001
Global Const $SERVICE_START_PENDING = 0x00000002
Global Const $SERVICE_STOP_PENDING = 0x00000003
Global Const $SERVICE_RUNNING = 0x00000004
Global Const $SERVICE_CONTINUE_PENDING = 0x00000005
Global Const $SERVICE_PAUSE_PENDING = 0x00000006
Global Const $SERVICE_PAUSED = 0x00000007

; Service accept control codes
Global Const $SERVICE_ACCEPT_STOP = 0x00000001
Global Const $SERVICE_ACCEPT_PAUSE_CONTINUE = 0x00000002
Global Const $SERVICE_ACCEPT_SHUTDOWN = 0x00000004
Global Const $SERVICE_ACCEPT_PARAMCHANGE = 0x00000008
Global Const $SERVICE_ACCEPT_NETBINDCHANGE = 0x00000010
Global Const $SERVICE_ACCEPT_HARDWAREPROFILECHANGE = 0x00000020
Global Const $SERVICE_ACCEPT_POWEREVENT = 0x00000040
Global Const $SERVICE_ACCEPT_SESSIONCHANGE = 0x00000080
Global Const $SERVICE_ACCEPT_PRESHUTDOWN = 0x00000100

; Service enumerate
Global Const $SERVICE_ACTIVE = 0x00000001
Global Const $SERVICE_INACTIVE = 0x00000002
Global Const $SERVICE_STATE_ALL = BitOR( $SERVICE_ACTIVE, _
								$SERVICE_INACTIVE )

; Service info
Global Const $SC_STATUS_PROCESS_INFO = 0
Global Const $SC_ENUM_PROCESS_INFO = 0

; Service specific system error codes
Global Const $ERROR_SERVICE_DISABLED = 1058
Global Const $ERROR_SERVICE_SPECIFIC_ERROR = 1066
Global Const $ERROR_SERVICE_DEPENDENCY_FAIL = 1068
Global Const $ERROR_SERVICE_NEVER_STARTED = 1077
Global Const $NO_ERROR = 0

; SC_ACTION_TYPE enumeration type
Global Enum $SC_ACTION_NONE, $SC_ACTION_RESTART, $SC_ACTION_REBOOT, $SC_ACTION_RUN_COMMAND

Global Const $SERVICE_RUNS_IN_SYSTEM_PROCESS = 0x00000001

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Change
; Description ...: Changes an existing service's configuration.
; Syntax.........: _Service_Change($sServiceName, $iServiceType _
;                  [, $iStartType, $iErrorControl, $sBinaryPath, $sLoadOrderGroup, $fTagId, $vDependencies, $sServiceUser, $sPassword, $sDisplayName, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $iServiceType - The type of service. Specify $SERVICE_NO_CHANGE if you are not changing the existing service type;
;                                  otherwise, specify one of the following service types:
;                                  $SERVICE_KERNEL_DRIVER - Driver service.
;                                  $SERVICE_FILE_SYSTEM_DRIVER - File system driver service.
;                                  $SERVICE_WIN32_OWN_PROCESS - Service that runs in its own process.
;                                  $SERVICE_WIN32_SHARE_PROCESS - Service that shares a process with other services.
;                                  If you specify either $SERVICE_WIN32_OWN_PROCESS or $SERVICE_WIN32_SHARE_PROCESS,
;                                  and the service is running in the context of the LocalSystem account, you can also specify the following type:
;                                  $SERVICE_INTERACTIVE_PROCESS - The service can interact with the desktop.
;                  $iStartType - [Optional] The service start options. Specify $SERVICE_NO_CHANGE if you are not changing the existing start type;
;                                otherwise, specify one of the following start types:
;                                $SERVICE_BOOT_START - A device driver started by the system loader. This value is valid only for driver services.
;                                $SERVICE_SYSTEM_START - A device driver started by the IoInitSystem function. This value is valid only for driver services.
;                                $SERVICE_AUTO_START - A service started automatically by the service control manager during system startup.
;                                $SERVICE_DEMAND_START - A service started by the service control manager when a process calls the StartService function.
;                                $SERVICE_DISABLED - A service that cannot be started.
;                  $iErrorControl - [Optional] The severity of the error, and action taken, if this service fails to start.
;                                   Specify $SERVICE_NO_CHANGE if you are not changing the existing error control; otherwise, specify one of the following values:
;                                   $SERVICE_ERROR_IGNORE - The startup program ignores the error and continues the startup operation.
;                                   $SERVICE_ERROR_NORMAL - The startup program logs the error in the event log but continues the startup operation.
;                                   $SERVICE_ERROR_SEVERE - The startup program logs the error in the event log.
;                                                           If the last-known-good configuration is being started, the startup operation continues.
;                                                           Otherwise, the system is restarted with the last-known-good configuration.
;                                   $SERVICE_ERROR_CRITICAL - The startup program logs the error in the event log, if possible.
;                                                             If the last-known-good configuration is being started, the startup operation fails.
;                                                             Otherwise, the system is restarted with the last-known good configuration.
;                  $sBinaryPath - [Optional] The fully-qualified path to the service binary file. Specify "Default" if you are not changing the existing path.
;                                 If the path contains a space, it must be quoted so that it is correctly interpreted.
;                                 For example, "d:\\my share\\myservice.exe" should be specified as "\"d:\\my share\\myservice.exe\"".
;                                 The path can also include arguments for an auto-start service. For example, "d:\\myshare\\myservice.exe arg1 arg2".
;                                 These arguments are passed to the service entry point (typically the main function).
;                  $sLoadOrderGroup - [Optional] The name of the load ordering group of which this service is a member.
;                                     Specify "Default" if you are not changing the existing load ordering group.
;                                     Specify an empty string if the service does not belong to a group.
;                  $fTagId - [Optional] Specify "True" if you desire a tag value that is unique in the group specified in the $sLoadOrderGroup parameter.
;                            Specify "False" or "Default" if you are not changing the existing tag.
;                            The tag value is stored in @extended macro.
;                            You can use a tag for ordering service startup within a load ordering group by specifying a tag order vector in the
;                            GroupOrderList value of the following registry key:
;                            HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control
;                            Tags are only evaluated for driver services that have $SERVICE_BOOT_START or $SERVICE_SYSTEM_START start types.
;                  $vDependencies - [Optional] An array of services or load ordering groups that the system must start before this service can be started.
;                                   (Dependency on a group means that this service can run if at least one member of the group is running after an attempt to
;                                   start all members of the group.) Specify an empty string if the service has no dependencies.
;                                   You must prefix group names with a plus sign ("+") so that they can be distinguished from a service name,
;                                   because services and service groups share the same name space.
;                                   Specify "Default" if you are not changing the existing dependencies.
;                  $sServiceUser - [Optional] The name of the account under which the service should run.
;                                  Specify "Default" if you are not changing the existing account name.
;                                  If the service type is $SERVICE_WIN32_OWN_PROCESS, use an account name in the form DomainName\UserName.
;                                  The service process will be logged on as this user. If the account belongs to the built-in domain,
;                                  you can specify .\UserName . A shared process can run as any user.
;                                  If the service type is $SERVICE_KERNEL_DRIVER or $SERVICE_FILE_SYSTEM_DRIVER,
;                                  the name is the driver object name that the system uses to load the device driver.
;                  $sPassword - [Optional] The password to the account name specified by the $sServiceUser parameter.
;                               Specify "Default" if you are not changing the existing password.
;                               Specify an empty string if the account has no password or if the service runs in the LocalService, NetworkService,
;                               or LocalSystem account. Passwords are ignored for driver services.
;                  $sDisplayName - [Optional] The display name to be used by applications to identify the service for its users.
;                                  Specify "Default" if you are not changing the existing display name; otherwise,
;                                  this string has a maximum length of 256 characters. The name is case-preserved in the service control manager.
;                                  Display name comparisons are always case-insensitive.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Change( $sServiceName, _
		$iServiceType, _
		$iStartType = $SERVICE_NO_CHANGE, _
		$iErrorControl = $SERVICE_NO_CHANGE, _
		$sBinaryPath = Default, _
		$sLoadOrderGroup = Default, _
		$fTagId = Default, _
		$vDependencies = Default, _
		$sServiceUser = Default, _
		$sPassword = Default, _
		$sDisplayName = Default, _
		$sComputerName = "" )
	Local $tBinaryPath, $tLoadOrderGroup, $tTagId, $tDepend, $tServiceUser, $tPassword, $tDisplayName, $hSC, $hService, $iSCh, $iSChE
	$tBinaryPath = DllStructCreate("char[" & Number($sBinaryPath <> Default) * ( StringLen($sBinaryPath) + 1 ) & "]")
	DllStructSetData($tBinaryPath, 1, $sBinaryPath)
	$tLoadOrderGroup = DllStructCreate("char[" & Number($sLoadOrderGroup <> Default) * ( StringLen($sLoadOrderGroup) + 1 ) & "]")
	DllStructSetData($tLoadOrderGroup, 1, $sLoadOrderGroup)
	$tTagId = DllStructCreate("dword[" & Number($fTagId) & "]")
	If IsArray($vDependencies) Then
		Local $iDepend, $tagDepend
		$iDepend = UBound($vDependencies) - 1
		For $i = 0 To $iDepend
			$tagDepend &= "char[" & StringLen($vDependencies[$i]) + 1 & "];"
		Next
		$tDepend = DllStructCreate( StringTrimRight($tagDepend, 1) )
		For $i = 0 To $iDepend
			DllStructSetData($tDepend, $i + 1, $vDependencies[$i])
		Next
	Else
		$tDepend = DllStructCreate("char[" & Number($vDependencies <> Default) * ( StringLen($vDependencies) + 1 ) & "]")
		DllStructSetData($tDepend, 1, $vDependencies)
	EndIf
	$tServiceUser = DllStructCreate("char[" & Number($sServiceUser <> Default) * ( StringLen($sServiceUser) + 1 ) & "]")
	DllStructSetData($tServiceUser, 1, $sServiceUser)
	$tPassword = DllStructCreate("char[" & Number($sPassword <> Default) * ( StringLen($sPassword) + 1 ) & "]")
	DllStructSetData($tPassword, 1, $sPassword)
	$tDisplayName = DllStructCreate("char[" & Number($sDisplayName <> Default) * ( StringLen($sDisplayName) + 1 ) & "]")
	DllStructSetData($tDisplayName, 1, $sDisplayName)
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSCh = ChangeServiceConfig( $hService, _
		$iServiceType, _
		$iStartType, _
		$iErrorControl, _
		DllStructGetPtr($tBinaryPath), _
		DllStructGetPtr($tLoadOrderGroup), _
		DllStructGetPtr($tTagId), _
		DllStructGetPtr($tDepend), _
		DllStructGetPtr($tServiceUser), _
		DllStructGetPtr($tPassword), _
		DllStructGetPtr($tDisplayName) )
	If $iSCh = 0 Then $iSChE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSChE, DllStructGetData($tTagId, 1), $iSCh)
EndFunc ;==> _Service_Change

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Create
; Description ...: Creates a service.
; Syntax.........: _Service_Create($sServiceName, $sDisplayName, $iServiceType, $iStartType, $iErrorControl, $sBinaryPath _
;                  [, $sLoadOrderGroup, $fTagId, $vDependencies, $sServiceUser, $sPassword, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sDisplayName - The display name to be used by user interface programs to identify the service. The maximum string length is 256 characters.
;                                  The service control manager database preserves the case of the characters,
;                                  but service name comparisons are always case insensitive.
;                                  Forward-slash (/) and back-slash (\) are invalid service name characters.
;                  $iServiceType - The type of service. Specify one of the following service types:
;                                  $SERVICE_KERNEL_DRIVER - Driver service.
;                                  $SERVICE_FILE_SYSTEM_DRIVER - File system driver service.
;                                  $SERVICE_WIN32_OWN_PROCESS - Service that runs in its own process.
;                                  $SERVICE_WIN32_SHARE_PROCESS - Service that shares a process with other services.
;                                  If you specify either $SERVICE_WIN32_OWN_PROCESS or $SERVICE_WIN32_SHARE_PROCESS,
;                                  and the service is running in the context of the LocalSystem account, you can also specify the following type:
;                                  $SERVICE_INTERACTIVE_PROCESS - The service can interact with the desktop.
;                  $iStartType - The service start options. Specify one of the following start types:
;                                $SERVICE_BOOT_START - A device driver started by the system loader. This value is valid only for driver services.
;                                $SERVICE_SYSTEM_START - A device driver started by the IoInitSystem function. This value is valid only for driver services.
;                                $SERVICE_AUTO_START - A service started automatically by the service control manager during system startup.
;                                $SERVICE_DEMAND_START - A service started by the service control manager when a process calls the StartService function.
;                                $SERVICE_DISABLED - A service that cannot be started.
;                  $iErrorControl - The severity of the error, and action taken, if this service fails to start. Specify one of the following values:
;                                   $SERVICE_ERROR_IGNORE - The startup program ignores the error and continues the startup operation.
;                                   $SERVICE_ERROR_NORMAL - The startup program logs the error in the event log but continues the startup operation.
;                                   $SERVICE_ERROR_SEVERE - The startup program logs the error in the event log.
;                                                           If the last-known-good configuration is being started, the startup operation continues.
;                                                           Otherwise, the system is restarted with the last-known-good configuration.
;                                   $SERVICE_ERROR_CRITICAL - The startup program logs the error in the event log, if possible.
;                                                             If the last-known-good configuration is being started, the startup operation fails.
;                                                             Otherwise, the system is restarted with the last-known good configuration.
;                  $sBinaryPath - The fully-qualified path to the service binary file. If the path contains a space,
;                                 it must be quoted so that it is correctly interpreted.
;                                 For example, "d:\\my share\\myservice.exe" should be specified as "\"d:\\my share\\myservice.exe\"".
;                                 The path can also include arguments for an auto-start service. For example, "d:\\myshare\\myservice.exe arg1 arg2".
;                                 These arguments are passed to the service entry point (typically the main function).
;                  $sLoadOrderGroup - [Optional] The name of the load ordering group of which this service is a member.
;                                     Specify "Default" or an empty string if the service does not belong to a group.
;                  $fTagId - [Optional] Specify "True" if you desire a tag value that is unique in the group specified in the $sLoadOrderGroup parameter.
;                            Specify "False" or "Default" if you do not desire a tag value.
;                            The tag value is stored in @extended macro.
;                            You can use a tag for ordering service startup within a load ordering group by specifying a tag order vector in the
;                            GroupOrderList value of the following registry key:
;                            HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control
;                            Tags are only evaluated for driver services that have $SERVICE_BOOT_START or $SERVICE_SYSTEM_START start types.
;                  $vDependencies - [Optional] An array of services or load ordering groups that the system must start before this service can be started.
;                                   (Dependency on a group means that this service can run if at least one member of the group is running after an attempt to
;                                   start all members of the group.) Specify "Default" or an empty string if the service has no dependencies.
;                                   You must prefix group names with a plus sign ("+") so that they can be distinguished from a service name,
;                                   because services and service groups share the same name space.
;                  $sServiceUser - [Optional] The name of the account under which the service should run.
;                                  If the service type is $SERVICE_WIN32_OWN_PROCESS, use an account name in the form DomainName\UserName.
;                                  The service process will be logged on as this user. If the account belongs to the built-in domain,
;                                  you can specify .\UserName . A shared process can run as any user.
;                                  If the service type is $SERVICE_KERNEL_DRIVER or $SERVICE_FILE_SYSTEM_DRIVER,
;                                  the name is the driver object name that the system uses to load the device driver.
;                                  Specify "Default" if the driver is to use a default object name created by the I/O system.
;                  $sPassword - [Optional] The password to the account name specified by the $sServiceUser parameter.
;                               Specify "Default" or an empty string if the account has no password or if the service runs in the LocalService, NetworkService,
;                               or LocalSystem account. Passwords are ignored for driver services.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Create( $sServiceName, _
		$sDisplayName, _
		$iServiceType, _
		$iStartType, _
		$iErrorControl, _
		$sBinaryPath, _
		$sLoadOrderGroup = Default, _
		$fTagId = Default, _
		$vDependencies = Default, _
		$sServiceUser = Default, _
		$sPassword = Default, _
		$sComputerName = "" )
	Local $tLoadOrderGroup, $tTagId, $tDepend, $tServiceUser, $tPassword, $hSC, $avSC, $iSC
	$tLoadOrderGroup = DllStructCreate("char[" & Number($sLoadOrderGroup <> Default) * ( StringLen($sLoadOrderGroup) + 1 ) & "]")
	DllStructSetData($tLoadOrderGroup, 1, $sLoadOrderGroup)
	$tTagId = DllStructCreate("dword[" & Number($fTagId) & "]")
	If IsArray($vDependencies) Then
		Local $iDepend, $tagDepend
		$iDepend = UBound($vDependencies) - 1
		For $i = 0 To $iDepend
			$tagDepend &= "char[" & StringLen($vDependencies[$i]) + 1 & "];"
		Next
		$tDepend = DllStructCreate( StringTrimRight($tagDepend, 1) )
		For $i = 0 To $iDepend
			DllStructSetData($tDepend, $i + 1, $vDependencies[$i])
		Next
	Else
		$tDepend = DllStructCreate("char[" & Number($vDependencies <> Default) * ( StringLen($vDependencies) + 1 ) & "]")
		DllStructSetData($tDepend, 1, $vDependencies)
	EndIf
	$tServiceUser = DllStructCreate("char[" & Number($sServiceUser <> Default) * ( StringLen($sServiceUser) + 1 ) & "]")
	DllStructSetData($tServiceUser, 1, $sServiceUser)
	$tPassword = DllStructCreate("char[" & Number($sPassword <> Default) * ( StringLen($sPassword) + 1 ) & "]")
	DllStructSetData($tPassword, 1, $sPassword)
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CREATE_SERVICE)
	$avSC = DllCall( "advapi32.dll", "hwnd", "CreateService", _
		"hwnd", $hSC, _
		"str", $sServiceName, _
		"str", $sDisplayName, _
		"dword", $SERVICE_ALL_ACCESS, _
		"dword", $iServiceType, _
		"dword", $iStartType, _
		"dword", $iErrorControl, _
		"str", $sBinaryPath, _
		"ptr", DllStructGetPtr($tLoadOrderGroup), _
		"ptr", DllStructGetPtr($tTagId), _
		"ptr", DllStructGetPtr($tDepend), _
		"ptr", DllStructGetPtr($tServiceUser), _
		"ptr", DllStructGetPtr($tPassword) )
	If $avSC[0] = 0 Then
		$iSC = GetLastError()
	Else
		CloseServiceHandle($avSC[0])
	EndIf
	CloseServiceHandle($hSC)
	Return SetError( $iSC, DllStructGetData($tTagId, 1), Number($avSC[0] <> 0) )
EndFunc ;==> _Service_Create

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Delete
; Description ...: Deletes a service.
; Syntax.........: _Service_Delete($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Delete($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avDS, $iDS
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $RIGHTS_DELETE)
	CloseServiceHandle($hSC)
	$avDS = DllCall( "advapi32.dll", "int", "DeleteService", _
		"hwnd", $hService )
	If $avDS[0] = 0 Then $iDS = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iDS, 0, $avDS[0])
EndFunc ;==> _Service_Delete

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Enum
; Description ...: Enumerates services in the specified service control manager database. The name and status of each service are provided,
;                  along with additional data based on the specified information level.
; Syntax.........: _Service_Enum($iServiceType [, $iServiceState, $sLoadOrderGroup, $sComputerName])
; Parameters ....: $iServiceType - The type of services to be enumerated. This parameter can be one or more of the following values:
;                                  $SERVICE_DRIVER - Enumerates services of type $SERVICE_KERNEL_DRIVER and $SERVICE_FILE_SYSTEM_DRIVER.
;                                  $SERVICE_WIN32 - Enumerates services of type $SERVICE_WIN32_OWN_PROCESS and $SERVICE_WIN32_SHARE_PROCESS.
;                  $iServiceState - [Optional] The state of the services to be enumerated. This parameter can be one of the following values:
;                                   $SERVICE_ACTIVE - Enumerates services that are in the following states: $SERVICE_START_PENDING, $SERVICE_STOP_PENDING,
;                                                     $SERVICE_RUNNING, $SERVICE_CONTINUE_PENDING, $SERVICE_PAUSE_PENDING, and $SERVICE_PAUSED.
;                                   $SERVICE_INACTIVE - Enumerates services that are in the $SERVICE_STOPPED state.
;                                   $SERVICE_STATE_ALL - Combines the following states: $SERVICE_ACTIVE and $SERVICE_INACTIVE.
;                                   Default is $SERVICE_STATE_ALL.
;                  $sLoadOrderGroup - [Optional] The load-order group name. If this parameter is a string,
;                                     the only services enumerated are those that belong to the group that has the name specified by the string.
;                                     If this parameter is an empty string, only services that do not belong to any group are enumerated.
;                                     If this parameter is "Default", group membership is ignored and all services are enumerated.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - An array of service names and their respective status:
;                            $Array[0][0] - The number of services reported.
;                            $Array[n][0] - Service name.
;                            $Array[n][1] - Service display name.
;                            $Array[n][2] - The type of service. Can be one of the following values:
;                                           $SERVICE_KERNEL_DRIVER - The service is a device driver.
;                                           $SERVICE_FILE_SYSTEM_DRIVER - The service is a file system driver.
;                                           $SERVICE_WIN32_OWN_PROCESS - The service runs in its own process.
;                                           $SERVICE_WIN32_SHARE_PROCESS - The service shares a process with other services.
;                                           BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service runs in its own process
;                                                                                                             and can interact with the desktop.
;                                           BitOR($SERVICE_WIN32_SHARE_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service shares a process with other services
;                                                                                                               and can interact with the desktop.
;                            $Array[n][3] - The current state of the service. Can be one of the following values:
;                                           $SERVICE_STOPPED - The service has stopped.
;                                           $SERVICE_START_PENDING - The service is starting.
;                                           $SERVICE_STOP_PENDING - The service is stopping.
;                                           $SERVICE_RUNNING - The service is running.
;                                           $SERVICE_CONTINUE_PENDING - The service is about to continue.
;                                           $SERVICE_PAUSE_PENDING - The service is pausing.
;                                           $SERVICE_PAUSED - The service is paused.
;                            $Array[n][4] - The control codes the service accepts and processes in its handler function (see Handler and HandlerEx).
;                                           A user interface process can control a service by specifying a control command in the ControlService or
;                                           ControlServiceEx function. By default, all services accept the $SERVICE_CONTROL_INTERROGATE value.
;                                           Can be one of the following values:
;                                           $SERVICE_ACCEPT_STOP - The service can be stopped.
;                                           $SERVICE_ACCEPT_PAUSE_CONTINUE - The service can be paused and continued.
;                                           $SERVICE_ACCEPT_SHUTDOWN - The service is notified when system shutdown occurs.
;                                           $SERVICE_ACCEPT_PARAMCHANGE - The service can reread its startup parameters without being stopped and restarted.
;                                           $SERVICE_ACCEPT_NETBINDCHANGE - The service is a network component that can accept changes
;                                                                           in its binding without being stopped and restarted.
;                                           $SERVICE_ACCEPT_HARDWAREPROFILECHANGE - The service is notified when the computer's hardware profile has changed.
;                                           $SERVICE_ACCEPT_POWEREVENT - The service is notified when the computer's power status has changed.
;                                           $SERVICE_ACCEPT_SESSIONCHANGE - The service is notified when the computer's session status has changed.
;                                           $SERVICE_ACCEPT_PRESHUTDOWN - The service can perform preshutdown tasks.
;                            $Array[n][5] - The error code that the service uses to report an error that occurs when it is starting or stopping.
;                                           To return an error code specific to the service, the service must set this value to $ERROR_SERVICE_SPECIFIC_ERROR
;                                           to indicate that the next value ($Array[n][6]) returns the error code.
;                                           The service should set this value to $NO_ERROR when it is running and when it terminates normally.
;                            $Array[n][6] - The service-specific error code that the service returns when an error occurs while the service is
;                                           starting or stopping. This value is ignored unless the previous value ($Array[n][5]) reports $ERROR_SERVICE_SPECIFIC_ERROR.
;                            $Array[n][7] - The check-point value that the service increments periodically to report its progress during a lengthy start,
;                                           stop, pause, or continue operation.
;                                           For example, the service should increment this value as it completes each step of its initialization when it is starting up.
;                                           The user interface program that invoked the operation on the service uses this value to track the progress
;                                           of the service during a lengthy operation.
;                                           This value is not valid and should be zero when the service does not have a start, stop, pause, or continue operation pending.
;                            $Array[n][8] - The estimated time required for a pending start, stop, pause, or continue operation, in milliseconds.
;                            $Array[n][9] - The process identifier of the service (PID).
;                            $Array[n][10] - Can be one of the following values:
;                                            0 - The service is running in a process that is not a system process, or it is not running.
;                                            $SERVICE_RUNS_IN_SYSTEM_PROCESS - The service runs in a system process that must always be running.
;                            Where "n" is an integer between 1 and $Array[0][0]. This number is the service's index in the array.
;                  Failure - Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Enum($iServiceType, $iServiceState = $SERVICE_STATE_ALL, $sLoadOrderGroup = Default, $sComputerName = "")
	Local $tLoadOrderGroup, $pLoadOrderGroup, $hSC, $avEA, $tEB, $avEB, $iEE, $iES, $tagEC, $tEC, $tED
	$tLoadOrderGroup = DllStructCreate("char[" & Number($sLoadOrderGroup <> Default) * ( StringLen($sLoadOrderGroup) + 1 ) & "]")
	DllStructSetData($tLoadOrderGroup, 1, $sLoadOrderGroup)
	$pLoadOrderGroup = DllStructGetPtr($tLoadOrderGroup)
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_ENUMERATE_SERVICE)

	; Determine needed size of the struct in bytes
	$avEA = DllCall( "advapi32.dll", "int", "EnumServicesStatusEx", _
		"hwnd", $hSC, _
		"dword", $SC_ENUM_PROCESS_INFO, _
		"dword", $iServiceType, _
		"dword", $iServiceState, _
		"ptr", 0, _
		"dword", 0, _
		"dword*", 0, _
		"dword*", 0, _
		"dword*", 0, _
		"ptr", $pLoadOrderGroup )

	; Get Service data
	$tEB = DllStructCreate("ubyte[" & $avEA[7] & "]")
	$avEB = DllCall( "advapi32.dll", "int", "EnumServicesStatusEx", _
		"hwnd", $hSC, _
		"dword", $SC_ENUM_PROCESS_INFO, _
		"dword", $iServiceType, _
		"dword", $iServiceState, _
		"ptr", DllStructGetPtr($tEB), _
		"dword", DllStructGetSize($tEB), _
		"dword*", 0, _
		"dword*", 0, _
		"dword*", 0, _
		"ptr", $pLoadOrderGroup )

	; Get last error and close service control manager database handle
	If $avEB[0] = 0 Then $iEE = GetLastError()
	CloseServiceHandle($hSC)

	; Decode the ubyte structure
	While $iES < $avEB[8]
		$iES += 1
		$tagEC &= "uint_ptr[2];dword[9];"
	WEnd
	$tEC = DllStructCreate( StringTrimRight($tagEC, 1), $avEB[5] )
	Local $aiEC[$avEB[8] + 1][2]
	For $i = 1 To $avEB[8]
		$aiEC[$i][0] = DllStructGetData($tEC, 2 * ($i - 1) - 1, 2) - DllStructGetData($tEC, 2 * $i - 1, 1)
		$aiEC[$i][1] = DllStructGetData($tEC, 2 * $i - 1, 1) - DllStructGetData($tEC, 2 * $i - 1, 2)
	Next
	If $avEB[8] > 0 Then $aiEC[1][0] = Execute($avEB[5]) + $avEB[6] - DllStructGetData($tEC, 1, 1)
	Local $asED[$avEB[8] + 1][11]
	$asED[0][0] = $avEB[8]
	For $i = 1 To $avEB[8]
		For $k = 0 To 1
			$tED = DllStructCreate( "char[" & $aiEC[$i][$k] & "]", DllStructGetData($tEC, 2 * $i - 1, $k + 1) )
			$asED[$i][$k] = DllStructGetData($tED, 1)
		Next
		For $k = 2 To UBound($asED, 2) - 1
			$asED[$i][$k] = DllStructGetData($tEC, 2 * $i, $k - 1)
		Next
	Next

	Return SetError($iEE, 0, $asED)
EndFunc ;==> _Service_Enum

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_EnumDependent
; Description ...: Retrieves the name and status of each service that depend on the specified service;
;                  that is, the specified service must be running before the dependent services can run.
; Syntax.........: _Service_EnumDependent($sServiceName [, $iServiceState, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $iServiceState - [Optional] The state of the services to be enumerated. This parameter can be one of the following values:
;                                   $SERVICE_ACTIVE - Enumerates services that are in the following states: $SERVICE_START_PENDING, $SERVICE_STOP_PENDING,
;                                                     $SERVICE_RUNNING, $SERVICE_CONTINUE_PENDING, $SERVICE_PAUSE_PENDING, and $SERVICE_PAUSED.
;                                   $SERVICE_INACTIVE - Enumerates services that are in the $SERVICE_STOPPED state.
;                                   $SERVICE_STATE_ALL - Combines the following states: $SERVICE_ACTIVE and $SERVICE_INACTIVE.
;                                   Default is $SERVICE_STATE_ALL.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - An array of service names and their respective status:
;                            $Array[0][0] - The number of services reported.
;                            $Array[n][0] - Service name.
;                            $Array[n][1] - Service display name.
;                            $Array[n][2] - The type of service. Can be one of the following values:
;                                           $SERVICE_KERNEL_DRIVER - The service is a device driver.
;                                           $SERVICE_FILE_SYSTEM_DRIVER - The service is a file system driver.
;                                           $SERVICE_WIN32_OWN_PROCESS - The service runs in its own process.
;                                           $SERVICE_WIN32_SHARE_PROCESS - The service shares a process with other services.
;                                           BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service runs in its own process
;                                                                                                             and can interact with the desktop.
;                                           BitOR($SERVICE_WIN32_SHARE_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service shares a process with other services
;                                                                                                               and can interact with the desktop.
;                            $Array[n][3] - The current state of the service. Can be one of the following values:
;                                           $SERVICE_STOPPED - The service has stopped.
;                                           $SERVICE_START_PENDING - The service is starting.
;                                           $SERVICE_STOP_PENDING - The service is stopping.
;                                           $SERVICE_RUNNING - The service is running.
;                                           $SERVICE_CONTINUE_PENDING - The service is about to continue.
;                                           $SERVICE_PAUSE_PENDING - The service is pausing.
;                                           $SERVICE_PAUSED - The service is paused.
;                            $Array[n][4] - The control codes the service accepts and processes in its handler function (see Handler and HandlerEx).
;                                           A user interface process can control a service by specifying a control command in the ControlService or
;                                           ControlServiceEx function. By default, all services accept the $SERVICE_CONTROL_INTERROGATE value.
;                                           Can be one of the following values:
;                                           $SERVICE_ACCEPT_STOP - The service can be stopped.
;                                           $SERVICE_ACCEPT_PAUSE_CONTINUE - The service can be paused and continued.
;                                           $SERVICE_ACCEPT_SHUTDOWN - The service is notified when system shutdown occurs.
;                                           $SERVICE_ACCEPT_PARAMCHANGE - The service can reread its startup parameters without being stopped and restarted.
;                                           $SERVICE_ACCEPT_NETBINDCHANGE - The service is a network component that can accept changes
;                                                                           in its binding without being stopped and restarted.
;                                           $SERVICE_ACCEPT_HARDWAREPROFILECHANGE - The service is notified when the computer's hardware profile has changed.
;                                           $SERVICE_ACCEPT_POWEREVENT - The service is notified when the computer's power status has changed.
;                                           $SERVICE_ACCEPT_SESSIONCHANGE - The service is notified when the computer's session status has changed.
;                                           $SERVICE_ACCEPT_PRESHUTDOWN - The service can perform preshutdown tasks.
;                            $Array[n][5] - The error code that the service uses to report an error that occurs when it is starting or stopping.
;                                           To return an error code specific to the service, the service must set this value to $ERROR_SERVICE_SPECIFIC_ERROR
;                                           to indicate that the next value ($Array[n][6]) returns the error code.
;                                           The service should set this value to $NO_ERROR when it is running and when it terminates normally.
;                            $Array[n][6] - The service-specific error code that the service returns when an error occurs while the service is
;                                           starting or stopping. This value is ignored unless the previous value ($Array[n][5]) reports $ERROR_SERVICE_SPECIFIC_ERROR.
;                            $Array[n][7] - The check-point value that the service increments periodically to report its progress during a lengthy start,
;                                           stop, pause, or continue operation.
;                                           For example, the service should increment this value as it completes each step of its initialization when it is starting up.
;                                           The user interface program that invoked the operation on the service uses this value to track the progress
;                                           of the service during a lengthy operation.
;                                           This value is not valid and should be zero when the service does not have a start, stop, pause, or continue operation pending.
;                            $Array[n][8] - The estimated time required for a pending start, stop, pause, or continue operation, in milliseconds.
;                            Where "n" is an integer between 1 and $Array[0][0]. This number is the service's index in the array.
;                  Failure - Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_EnumDependent($sServiceName, $iServiceState = $SERVICE_STATE_ALL, $sComputerName = "")
	Local $hSC, $hService, $avA, $tB, $avB, $iE, $iS, $tagC, $tC, $tD
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_ENUMERATE_DEPENDENTS)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avA = DllCall( "advapi32.dll", "int", "EnumDependentServices", _
		"hwnd", $hService, _
		"dword", $iServiceState, _
		"ptr", 0, _
		"dword", 0, _
		"dword*", 0, _
		"dword*", 0 )

	; Get Service data
	$tB = DllStructCreate("ubyte[" & $avA[5] & "]")
	$avB = DllCall( "advapi32.dll", "int", "EnumDependentServices", _
		"hwnd", $hService, _
		"dword", $iServiceState, _
		"ptr", DllStructGetPtr($tB), _
		"dword", DllStructGetSize($tB), _
		"dword*", 0, _
		"dword*", 0 )

	; Get last error and close service handle
	If $avB[0] = 0 Then $iE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	While $iS < $avB[6]
		$iS += 1
		$tagC &= "uint_ptr[2];dword[7];"
	WEnd
	$tC = DllStructCreate( StringTrimRight($tagC, 1), $avB[3] )
	Local $aiC[$avB[6] + 1][2]
	For $i = 1 To $avB[6]
		$aiC[$i][0] = DllStructGetData($tC, 2 * ($i - 1) - 1, 2) - DllStructGetData($tC, 2 * $i - 1, 1)
		$aiC[$i][1] = DllStructGetData($tC, 2 * $i - 1, 1) - DllStructGetData($tC, 2 * $i - 1, 2)
	Next
	If $avB[6] > 0 Then $aiC[1][0] = Execute($avB[3]) + $avB[4] - DllStructGetData($tC, 1, 1)
	Local $asD[$avB[6] + 1][9]
	$asD[0][0] = $avB[6]
	For $i = 1 To $avB[6]
		For $k = 0 To 1
			$tD = DllStructCreate( "char[" & $aiC[$i][$k] & "]", DllStructGetData($tC, 2 * $i - 1, $k + 1) )
			$asD[$i][$k] = DllStructGetData($tD, 1)
		Next
		For $k = 2 To UBound($asD, 2) - 1
			$asD[$i][$k] = DllStructGetData($tC, 2 * $i, $k - 1)
		Next
	Next

	Return SetError($iE, 0, $asD)
EndFunc ;==> _Service_EnumDependent

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Exists
; Description ...: Checks if a service exists.
; Syntax.........: _Service_Exists($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - 1
;                  Failure - 0
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Exists($sServiceName, $sComputerName = "")
	Local $hSC, $hService
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_INTERROGATE)
	CloseServiceHandle($hSC)
	CloseServiceHandle($hService)
	Return Number($hService <> 0)
EndFunc ;==> _Service_Exists

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Pause
; Description ...: Pauses a service.
; Syntax.........: _Service_Pause($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Pause($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $iCSP, $iCSPE
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_PAUSE_CONTINUE)
	CloseServiceHandle($hSC)
	$iCSP = ControlService($hService, $SERVICE_CONTROL_PAUSE)
	If $iCSP = 0 Then $iCSPE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iCSPE, 0, $iCSP)
EndFunc ;==> _Service_Pause

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Resume
; Description ...: Resumes a service.
; Syntax.........: _Service_Resume($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Resume($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $iCSR, $iCSRE
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_PAUSE_CONTINUE)
	CloseServiceHandle($hSC)
	$iCSR = ControlService($hService, $SERVICE_CONTROL_CONTINUE)
	If $iCSR = 0 Then $iCSRE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iCSRE, 0, $iCSR)
EndFunc ;==> _Service_Resume

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryAccount
; Description ...: Retrieves the name of the account under which a given service runs.
; Syntax.........: _Service_QueryAccount($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - The name of the account under which the service runs.
;                  Failure - An empty string.
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryAccount($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC, $pServiceUser, $pDisplayName, $pEnd, $sServiceUser
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])
	$pServiceUser = DllStructGetData($tQC, 4, 2)
	$pDisplayName = DllStructGetData($tQC, 4, 3)
	$pEnd = Execute($avQB[2] + $avQB[3])
	If $pServiceUser > 0 Then
		Local $tServiceUser = DllStructCreate("char[" & Number($pDisplayName = 0) * $pEnd + $pDisplayName - $pServiceUser & "]", $pServiceUser)
		$sServiceUser = DllStructGetData($tServiceUser, 1)
	EndIf

	Return SetError($iQE, 0, $sServiceUser)
EndFunc ;==> _Service_QueryAccount

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryBinaryPath
; Description ...: Retrieves the fully-qualified path to the binary file of a given service.
; Syntax.........: _Service_QueryBinaryPath($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - The fully-qualified path to the service binary file.
;                  Failure - An empty string.
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryBinaryPath($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC, $pBinaryPath, $pGroup, $pDep, $pServiceUser, $pDisplayName, $pEnd, $p0, $p1, $p2, $p3, $sBinaryPath
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])
	$pBinaryPath = DllStructGetData($tQC, 2, 1)
	$pGroup = DllStructGetData($tQC, 2, 2)
	$pDep = DllStructGetData($tQC, 4, 1)
	$pServiceUser = DllStructGetData($tQC, 4, 2)
	$pDisplayName = DllStructGetData($tQC, 4, 3)
	$pEnd = Execute($avQB[2] + $avQB[3])
	$p0 = Number($pDisplayName = 0) * $pEnd + $pDisplayName
	$p1 = Number($pServiceUser = 0) * $p0 + $pServiceUser
	$p2 = Number($pDep = 0) * $p1 + $pDep
	$p3 = Number($pGroup = 0) * $p2 + $pGroup
	If $pBinaryPath > 0 Then
		Local $tBinaryPath = DllStructCreate("char[" & $p3 - $pBinaryPath & "]", $pBinaryPath)
		$sBinaryPath = DllStructGetData($tBinaryPath, 1)
	EndIf

	Return SetError($iQE, 0, $sBinaryPath)
EndFunc ;==> _Service_QueryBinaryPath

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryConfig
; Description ...: Retrieves the configuration of a service.
; Syntax.........: _Service_QueryConfig($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - An array where:
;                            $Array[0] - The type of service. Can be one of the following values:
;                                        $SERVICE_KERNEL_DRIVER - The service is a device driver.
;                                        $SERVICE_FILE_SYSTEM_DRIVER - The service is a file system driver.
;                                        $SERVICE_WIN32_OWN_PROCESS - The service runs in its own process.
;                                        $SERVICE_WIN32_SHARE_PROCESS - The service shares a process with other services.
;                                        BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service runs in its own process
;                                                                                                          and can interact with the desktop.
;                                        BitOR($SERVICE_WIN32_SHARE_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service shares a process with other services
;                                                                                                            and can interact with the desktop.
;                            $Array[1] - The service start options. Can be one of the following values:
;                                        $SERVICE_BOOT_START - A device driver started by the system loader. This value is valid only for driver services.
;                                        $SERVICE_SYSTEM_START - A device driver started by the IoInitSystem function. This value is valid only for driver services.
;                                        $SERVICE_AUTO_START - A service started automatically by the service control manager during system startup.
;                                        $SERVICE_DEMAND_START - A service started by the service control manager when a process calls the StartService function.
;                                        $SERVICE_DISABLED - A service that cannot be started.
;                            $Array[2] - The severity of the error, and action taken, if this service fails to start. Can be one of the following values:
;                                        $SERVICE_ERROR_IGNORE - The startup program ignores the error and continues the startup operation.
;                                        $SERVICE_ERROR_NORMAL - The startup program logs the error in the event log but continues the startup operation.
;                                        $SERVICE_ERROR_SEVERE - The startup program logs the error in the event log.
;                                                                If the last-known-good configuration is being started, the startup operation continues.
;                                                                Otherwise, the system is restarted with the last-known-good configuration.
;                                        $SERVICE_ERROR_CRITICAL - The startup program logs the error in the event log, if possible.
;                                                                  If the last-known-good configuration is being started, the startup operation fails.
;                                                                  Otherwise, the system is restarted with the last-known good configuration.
;                            $Array[3] - The fully-qualified path to the service binary file.
;                            $Array[4] - The name of the load ordering group to which this service belongs. If this element is an empty string,
;                                        the service does not belong to a load ordering group.
;                            $Array[5] - A unique tag value for this service in the group returned by $Array[4].
;                                        A value of zero indicates that the service has not been assigned a tag.
;                            $Array[6] - An array of service or load ordering group names:
;                                        $array[0] - 1st service or load ordering group name.
;                                        $array[1] - 2nd service or load ordering group name.
;                                        ...
;                                        $array[n] - (n + 1) th service or load ordering group name.
;                                        In case there are no dependencies, this element is an empty string.
;                                        Load ordering group names are prefixed with a plus sign ("+"). While service names are not.
;                            $Array[7] - The name of the account under which the service runs.
;                            $Array[8] - The service's display name.
;                  Failure - Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryConfig($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC, $pBinaryPath, $pGroup, $pDep, $pServiceUser, $pDisplayName, $pEnd, _
		$p0, $p1, $p2, $p3, $sBinaryPath, $sGroup, $tDep, $sFull, $sStrip, $vDep, $sServiceUser, $sDisplayName, $avConfig[9]
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])
	$pBinaryPath = DllStructGetData($tQC, 2, 1)
	$pGroup = DllStructGetData($tQC, 2, 2)
	$pDep = DllStructGetData($tQC, 4, 1)
	$pServiceUser = DllStructGetData($tQC, 4, 2)
	$pDisplayName = DllStructGetData($tQC, 4, 3)
	$pEnd = Execute($avQB[2] + $avQB[3])
	$p0 = Number($pDisplayName = 0) * $pEnd + $pDisplayName
	$p1 = Number($pServiceUser = 0) * $p0 + $pServiceUser
	$p2 = Number($pDep = 0) * $p1 + $pDep
	$p3 = Number($pGroup = 0) * $p2 + $pGroup
	If $pBinaryPath > 0 Then
		Local $tBinaryPath = DllStructCreate("char[" & $p3 - $pBinaryPath & "]", $pBinaryPath)
		$sBinaryPath = DllStructGetData($tBinaryPath, 1)
	EndIf
	If $pGroup > 0 Then
		Local $tGroup = DllStructCreate("char[" & $p2 - $pGroup & "]", $pGroup)
		$sGroup = DllStructGetData($tGroup, 1)
	EndIf
	$tDep = DllStructCreate("ubyte[" & $p1 - $pDep & "]", $pDep)
	$sFull = BinaryToString( DllStructGetData($tDep, 1), 1 )
	$sStrip = StringMid( $sFull, 1, StringInStr( $sFull, Chr(0) & Chr(0) ) - 1 )
	If $sStrip <> "" Then
		Local $asSplit = StringSplit( $sStrip, Chr(0) ), $vDep[$asSplit[0]]
		For $i = 1 To $asSplit[0]
			$vDep[$i - 1] = $asSplit[$i]
		Next
	EndIf
	If $pServiceUser > 0 Then
		Local $tServiceUser = DllStructCreate("char[" & $p0 - $pServiceUser & "]", $pServiceUser)
		$sServiceUser = DllStructGetData($tServiceUser, 1)
	EndIf
	If $pDisplayName > 0 Then
		Local $tDisplayName = DllStructCreate("char[" & $pEnd - $pDisplayName & "]", $pDisplayName)
		$sDisplayName = DllStructGetData($tDisplayName, 1)
	EndIf
	$avConfig[0] = DllStructGetData($tQC, 1, 1)
	$avConfig[1] = DllStructGetData($tQC, 1, 2)
	$avConfig[2] = DllStructGetData($tQC, 1, 3)
	$avConfig[3] = $sBinaryPath
	$avConfig[4] = $sGroup
	$avConfig[5] = DllStructGetData($tQC, 3)
	$avConfig[6] = $vDep
	$avConfig[7] = $sServiceUser
	$avConfig[8] = $sDisplayName

	Return SetError($iQE, 0, $avConfig)
EndFunc ;==> _Service_QueryConfig

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryDependencies
; Description ...: Retrieves the names of services or load ordering groups that must start before a service.
; Syntax.........: _Service_QueryDependencies($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - An array of service or load ordering group names:
;                            $Array[0] - 1st service or load ordering group name.
;                            $Array[1] - 2nd service or load ordering group name.
;                            ...
;                            $Array[n] - (n + 1) th service or load ordering group name.
;                            In case there are no dependencies, an empty string is returned.
;                  Failure - An empty string.
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: Load ordering group names are prefixed with a plus sign ("+"). While service names are not.
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryDependencies($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC, $pDep, $pServiceUser, $pDisplayName, $pEnd, $tDep, $sFull, $sStrip, $vDep
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])
	$pDep = DllStructGetData($tQC, 4, 1)
	$pServiceUser = DllStructGetData($tQC, 4, 2)
	$pDisplayName = DllStructGetData($tQC, 4, 3)
	$pEnd = Execute($avQB[2] + $avQB[3])
	$tDep = DllStructCreate("ubyte[" & Number($pServiceUser = 0) * ( Number($pDisplayName = 0) * $pEnd + $pDisplayName ) + $pServiceUser - $pDep & "]", $pDep)
	$sFull = BinaryToString( DllStructGetData($tDep, 1), 1 )
	$sStrip = StringMid( $sFull, 1, StringInStr( $sFull, Chr(0) & Chr(0) ) - 1 )
	If $sStrip <> "" Then
		Local $asSplit = StringSplit( $sStrip, Chr(0) ), $vDep[$asSplit[0]]
		For $i = 1 To $asSplit[0]
			$vDep[$i - 1] = $asSplit[$i]
		Next
	EndIf

	Return SetError($iQE, 0, $vDep)
EndFunc ;==> _Service_QueryDependencies

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryDesc
; Description ...: Retrieves the description of a service.
; Syntax.........: _Service_QueryDesc($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - The service's description.
;                  Failure - An empty string.
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryDesc($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQ2A, $tQ2B, $avQ2B, $iQ2E, $tQ2C, $pDesc, $sDesc
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQ2A = DllCall( "advapi32.dll", "int", "QueryServiceConfig2", _
		"hwnd", $hService, _
		"dword", $SERVICE_CONFIG_DESCRIPTION, _
		"ptr", 0, _
		"dword", 0, _
		"dword*", 0 )

	; Get Service data
	$tQ2B = DllStructCreate("ubyte[" & $avQ2A[5] & "]")
	$avQ2B = DllCall( "advapi32.dll", "int", "QueryServiceConfig2", _
		"hwnd", $hService, _
		"dword", $SERVICE_CONFIG_DESCRIPTION, _
		"ptr", DllStructGetPtr($tQ2B), _
		"dword", DllStructGetSize($tQ2B), _
		"dword*", 0 )

	; Get last error and close service handle
	If $avQ2B[0] = 0 Then $iQ2E = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQ2C = DllStructCreate("uint_ptr", $avQ2B[3])
	$pDesc = DllStructGetData($tQ2C, 1)
	If $pDesc > 0 Then
		Local $tDesc = DllStructCreate("char[" & $avQ2A[5] - DllStructGetSize($tQ2C) & "]", $pDesc)
		$sDesc = DllStructGetData($tDesc, 1)
	EndIf

	Return SetError($iQ2E, 0, $sDesc)
EndFunc ;==> _Service_QueryDesc

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryDisplayName
; Description ...: Retrieves the display name of a service.
; Syntax.........: _Service_QueryDisplayName($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - The service's display name.
;                  Failure - An empty string.
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryDisplayName($sServiceName, $sComputerName = "")
	Local $hSC, $avSDA, $tSDB, $avSDB, $iSD
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$avSDA = DllCall( "advapi32.dll", "int", "GetServiceDisplayName", _
		"hwnd", $hSC, _
		"str", $sServiceName, _
		"ptr", 0, _
		"dword*", 0 )
	$tSDB = DllStructCreate("char[" & $avSDA[4] & "]")
	$avSDB = DllCall( "advapi32.dll", "int", "GetServiceDisplayName", _
		"hwnd", $hSC, _
		"str", $sServiceName, _
		"ptr", DllStructGetPtr($tSDB), _
		"dword*", $avSDA[4] )
	If $avSDB[0] = 0 Then $iSD = GetLastError()
	CloseServiceHandle($hSC)
	Return SetError( $iSD, 0, DllStructGetData($tSDB, 1) )
EndFunc ;==> _Service_QueryDisplayName

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryErrorControl
; Description ...: Retrieves the severity of the error, and action taken, if the given service fails to start.
; Syntax.........: _Service_QueryErrorControl($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - Returns the severity of the error, and action taken, if this service fails to start. Can be one of the following values:
;                            $SERVICE_ERROR_IGNORE - The startup program ignores the error and continues the startup operation.
;                            $SERVICE_ERROR_NORMAL - The startup program logs the error in the event log but continues the startup operation.
;                            $SERVICE_ERROR_SEVERE - The startup program logs the error in the event log.
;                                                    If the last-known-good configuration is being started, the startup operation continues.
;                                                    Otherwise, the system is restarted with the last-known-good configuration.
;                            $SERVICE_ERROR_CRITICAL - The startup program logs the error in the event log, if possible.
;                                                      If the last-known-good configuration is being started, the startup operation fails.
;                                                      Otherwise, the system is restarted with the last-known good configuration.
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryErrorControl($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])

	Return SetError( $iQE, 0, DllStructGetData($tQC, 1, 3) )
EndFunc ;==> _Service_QueryErrorControl

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryFailureActions
; Description ...: Retrieves failure action settings of a service.
; Syntax.........: _Service_QueryFailureActions($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - An array where:
;                            $Array[0] - The time after which to reset the failure count to zero if there are no failures, in days.
;                            $Array[1] - The message to be broadcast to server users before rebooting in response to the $SC_ACTION_REBOOT service controller action.
;                            $Array[2] - The command line of the process for the CreateProcess function to execute in response to the
;                                        $SC_ACTION_RUN_COMMAND service controller action. This process runs under the same account as the service.
;                            $Array[3] - An array of SC_ACTION_TYPE and respective delay in minutes. The array is of the form:
;                                        $Array[n][2] = [[Type 1, Delay 1], [Type 2, Delay 2], ... [Type n, Delay n]]
;                                        "Type" represents the action to be performed. It can be one of the following values from the SC_ACTION_TYPE enumeration type:
;                                        $SC_ACTION_NONE - No action.
;                                        $SC_ACTION_RESTART - Restart the service.
;                                        $SC_ACTION_REBOOT - Reboot the computer.
;                                        $SC_ACTION_RUN_COMMAND - Run a command.
;                                        "Delay" represents the time to wait before performing the specified action, in minutes.
;                  Failure - Sets @error
; Author ........: engine
;                  The ANSI version was returning unexpected results. So I had to force the unicode version.
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryFailureActions($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQ2A, $tQ2B, $avQ2B, $iQ2E, $tQ2C, $pRebootMsg, $pCommand, $iActions, $pEnd, $sRebootMsg, $sCommand, $vActions, $avActions[4]
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQ2A = DllCall( "advapi32.dll", "int", "QueryServiceConfig2W", _
		"hwnd", $hService, _
		"dword", $SERVICE_CONFIG_FAILURE_ACTIONS, _
		"ptr", 0, _
		"dword", 0, _
		"dword*", 0 )

	; Get Service data
	$tQ2B = DllStructCreate("ubyte[" & $avQ2A[5] & "]")
	$avQ2B = DllCall( "advapi32.dll", "int", "QueryServiceConfig2W", _
		"hwnd", $hService, _
		"dword", $SERVICE_CONFIG_FAILURE_ACTIONS, _
		"ptr", DllStructGetPtr($tQ2B), _
		"dword", DllStructGetSize($tQ2B), _
		"dword*", 0 )

	; Get last error and close service handle
	If $avQ2B[0] = 0 Then $iQ2E = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQ2C = DllStructCreate("dword;uint_ptr[2];dword;uint_ptr", $avQ2B[3])
	$pRebootMsg = DllStructGetData($tQ2C, 2, 1)
	$pCommand = DllStructGetData($tQ2C, 2, 2)
	$iActions = DllStructGetData($tQ2C, 3)
	$pEnd = Execute($avQ2B[3] + $avQ2B[4])
	If $pRebootMsg > 0 Then
		Local $tRebootMsg = DllStructCreate("wchar[" & ( Number($pCommand = 0) * $pEnd + $pCommand - $pRebootMsg ) / 2 - 1 & "]", $pRebootMsg)
		$sRebootMsg = DllStructGetData($tRebootMsg, 1)
	EndIf
	If $pCommand > 0 Then
		Local $tCommand = DllStructCreate("wchar[" & ($pEnd - $pCommand) / 2 - 1 & "]", $pCommand)
		$sCommand = DllStructGetData($tCommand, 1)
	EndIf
	If $iActions > 0 Then
		Local $tActions, $vActions[$iActions][2]
		$tActions = DllStructCreate( "dword[" & 2 * $iActions & "]", DllStructGetData($tQ2C, 4) )
		For $i = 0 To $iActions - 1
			$vActions[$i][0] = DllStructGetData($tActions, 1, 2 * $i + 1)
			$vActions[$i][1] = DllStructGetData($tActions, 1, 2 * $i + 2) / 6E+4
		Next
	EndIf
	$avActions[0] = DllStructGetData($tQ2C, 1) / 86400
	$avActions[1] = $sRebootMsg
	$avActions[2] = $sCommand
	$avActions[3] = $vActions

	Return SetError($iQ2E, 0, $avActions)
EndFunc ;==> _Service_QueryFailureActions

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryGroup
; Description ...: Retrieves the name of the load ordering group to which a service belongs.
; Syntax.........: _Service_QueryGroup($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - The name of the load ordering group to which the given service belongs.
;                            @extended stores the tag value for the service in the group returned.
;                            A value of zero indicates that the service has not been assigned a tag.
;                  Failure - An empty string.
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryGroup($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC, $pGroup, $pDep, $pServiceUser, $pDisplayName, $pEnd, $p0, $p1, $p2, $sGroup
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])
	$pGroup = DllStructGetData($tQC, 2, 2)
	$pDep = DllStructGetData($tQC, 4, 1)
	$pServiceUser = DllStructGetData($tQC, 4, 2)
	$pDisplayName = DllStructGetData($tQC, 4, 3)
	$pEnd = Execute($avQB[2] + $avQB[3])
	$p0 = Number($pDisplayName = 0) * $pEnd + $pDisplayName
	$p1 = Number($pServiceUser = 0) * $p0 + $pServiceUser
	$p2 = Number($pDep = 0) * $p1 + $pDep
	If $pGroup > 0 Then
		Local $tGroup = DllStructCreate("char[" & $p2 - $pGroup & "]", $pGroup)
		$sGroup = DllStructGetData($tGroup, 1)
	EndIf

	Return SetError($iQE, DllStructGetData($tQC, 3), $sGroup)
EndFunc ;==> _Service_QueryGroup

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryStartType
; Description ...: Retrieves a service's start options.
; Syntax.........: _Service_QueryStartType($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - Returns the service start options. Can be one of the following values:
;                            $SERVICE_BOOT_START - A device driver started by the system loader. This value is valid only for driver services.
;                            $SERVICE_SYSTEM_START - A device driver started by the IoInitSystem function. This value is valid only for driver services.
;                            $SERVICE_AUTO_START - A service started automatically by the service control manager during system startup.
;                            $SERVICE_DEMAND_START - A service started by the service control manager when a process calls the StartService function.
;                            $SERVICE_DISABLED - A service that cannot be started.
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryStartType($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])

	Return SetError( $iQE, 0, DllStructGetData($tQC, 1, 2) )
EndFunc ;==> _Service_QueryStartType

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryStatus
; Description ...: Retrieves the current status of the specified service.
; Syntax.........: _Service_QueryStatus($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - Returns an array as follows:
;                            $Array[0] - The type of service. Can be one of the following values:
;                                        $SERVICE_KERNEL_DRIVER - The service is a device driver.
;                                        $SERVICE_FILE_SYSTEM_DRIVER - The service is a file system driver.
;                                        $SERVICE_WIN32_OWN_PROCESS - The service runs in its own process.
;                                        $SERVICE_WIN32_SHARE_PROCESS - The service shares a process with other services.
;                                        BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service runs in its own process
;                                                                                                          and can interact with the desktop.
;                                        BitOR($SERVICE_WIN32_SHARE_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service shares a process with other services
;                                                                                                            and can interact with the desktop.
;                            $Array[1] - The current state of the service. Can be one of the following values:
;                                        $SERVICE_STOPPED - The service has stopped.
;                                        $SERVICE_START_PENDING - The service is starting.
;                                        $SERVICE_STOP_PENDING - The service is stopping.
;                                        $SERVICE_RUNNING - The service is running.
;                                        $SERVICE_CONTINUE_PENDING - The service is about to continue.
;                                        $SERVICE_PAUSE_PENDING - The service is pausing.
;                                        $SERVICE_PAUSED - The service is paused.
;                            $Array[2] - The control codes the service accepts and processes in its handler function (see Handler and HandlerEx).
;                                        A user interface process can control a service by specifying a control command in the ControlService or ControlServiceEx
;                                        function. By default, all services accept the $SERVICE_CONTROL_INTERROGATE value. Can be one of the following values:
;                                        $SERVICE_ACCEPT_STOP - The service can be stopped.
;                                        $SERVICE_ACCEPT_PAUSE_CONTINUE - The service can be paused and continued.
;                                        $SERVICE_ACCEPT_SHUTDOWN - The service is notified when system shutdown occurs.
;                                        $SERVICE_ACCEPT_PARAMCHANGE - The service can reread its startup parameters without being stopped and restarted.
;                                        $SERVICE_ACCEPT_NETBINDCHANGE - The service is a network component that can accept changes
;                                                                        in its binding without being stopped and restarted.
;                                        $SERVICE_ACCEPT_HARDWAREPROFILECHANGE - The service is notified when the computer's hardware profile has changed.
;                                        $SERVICE_ACCEPT_POWEREVENT - The service is notified when the computer's power status has changed.
;                                        $SERVICE_ACCEPT_SESSIONCHANGE - The service is notified when the computer's session status has changed.
;                                        $SERVICE_ACCEPT_PRESHUTDOWN - The service can perform preshutdown tasks.
;                            $Array[3] - The error code that the service uses to report an error that occurs when it is starting or stopping.
;                                        To return an error code specific to the service, the service must set this value to $ERROR_SERVICE_SPECIFIC_ERROR
;                                        to indicate that the next element ($Array[4]) stores the error code.
;                                        The service should set this value to $NO_ERROR when it is running and when it terminates normally.
;                            $Array[4] - The service-specific error code that the service returns when an error occurs while the service is
;                                        starting or stopping. This value is ignored unless the previous element ($Array[3]) reports $ERROR_SERVICE_SPECIFIC_ERROR.
;                            $Array[5] - The check-point value that the service increments periodically to report its progress during a lengthy start,
;                                        stop, pause, or continue operation.
;                                        For example, the service should increment this value as it completes each step of its initialization when it is starting up.
;                                        The user interface program that invoked the operation on the service uses this value to track the progress
;                                        of the service during a lengthy operation.
;                                        This value is not valid and should be zero when the service does not have a start, stop, pause, or continue operation pending.
;                            $Array[6] - The estimated time required for a pending start, stop, pause, or continue operation, in milliseconds.
;                            $Array[7] - The process identifier of the service (PID).
;                            $Array[8] - Can be one of the following values:
;                                        0 - The service is running in a process that is not a system process, or it is not running.
;                                        $SERVICE_RUNS_IN_SYSTEM_PROCESS - The service runs in a system process that must always be running.
;                  Failure - Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryStatus($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $tSERVICE_STATUS_PROCESS, $avQSSE, $iQSSE, $aiStatus[9]
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_STATUS)
	CloseServiceHandle($hSC)
	$tSERVICE_STATUS_PROCESS = DllStructCreate("dword[9]")
	$avQSSE = DllCall( "advapi32.dll", "int", "QueryServiceStatusEx", _
		"hwnd", $hService, _
		"dword", $SC_STATUS_PROCESS_INFO, _
		"ptr", DllStructGetPtr($tSERVICE_STATUS_PROCESS), _
		"dword", DllStructGetSize($tSERVICE_STATUS_PROCESS), _
		"dword*", 0 )
	If $avQSSE[0] = 0 Then $iQSSE = GetLastError()
	CloseServiceHandle($hService)
	For $i = 0 To 8
		$aiStatus[$i] = DllStructGetData($tSERVICE_STATUS_PROCESS, 1, $i + 1)
	Next
	Return SetError($iQSSE, 0, $aiStatus)
EndFunc ;==> _Service_QueryStatus

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryType
; Description ...: Retrieves a service's type.
; Syntax.........: _Service_QueryType($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - Returns the type of service. Can be one of the following values:
;                            $SERVICE_KERNEL_DRIVER - The service is a device driver.
;                            $SERVICE_FILE_SYSTEM_DRIVER - The service is a file system driver.
;                            $SERVICE_WIN32_OWN_PROCESS - The service runs in its own process.
;                            $SERVICE_WIN32_SHARE_PROCESS - The service shares a process with other services.
;                            BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service runs in its own process
;                                                                                              and can interact with the desktop.
;                            BitOR($SERVICE_WIN32_SHARE_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service shares a process with other services
;                                                                                                and can interact with the desktop.
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryType($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)
	CloseServiceHandle($hSC)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig( $hService, DllStructGetPtr($tQB), DllStructGetSize($tQB) )

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = GetLastError()
	CloseServiceHandle($hService)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])

	Return SetError( $iQE, 0, DllStructGetData($tQC, 1, 1) )
EndFunc ;==> _Service_QueryType

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetAccount
; Description ...: Sets or changes a service's account and password.
; Syntax.........: _Service_SetAccount($sServiceName, $sServiceUser [, $sPassword, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sServiceUser - The name of the account under which the service should run. Specify "Default" if you are not changing the existing account name.
;                                  If the service type is $SERVICE_WIN32_OWN_PROCESS, use an account name in the form DomainName\UserName.
;                                  The service process will be logged on as this user. If the account belongs to the built-in domain,
;                                  you can specify .\UserName . A shared process can run as any user.
;                                  If the service type is $SERVICE_KERNEL_DRIVER or $SERVICE_FILE_SYSTEM_DRIVER,
;                                  the name is the driver object name that the system uses to load the device driver.
;                                  Specify "Default" if the driver is to use a default object name created by the I/O system.
;                  $sPassword - [Optional] The password to the account name specified by the $sServiceUser parameter.
;                               Specify "Default" if you are not changing the existing password.
;                               Specify an empty string if the account has no password or if the service runs in the LocalService, NetworkService,
;                               or LocalSystem account. Passwords are ignored for driver services.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetAccount($sServiceName, $sServiceUser, $sPassword = Default, $sComputerName = "")
	Local $tServiceUser, $tPassword, $hSC, $hService, $iSSP, $iSSPE
	$tServiceUser = DllStructCreate("char[" & Number($sServiceUser <> Default) * ( StringLen($sServiceUser) + 1 ) & "]")
	DllStructSetData($tServiceUser, 1, $sServiceUser)
	$tPassword = DllStructCreate("char[" & Number($sPassword <> Default) * ( StringLen($sPassword) + 1 ) & "]")
	DllStructSetData($tPassword, 1, $sPassword)
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSSP = ChangeServiceConfig( $hService, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		0, 0, 0, 0, _
		DllStructGetPtr($tServiceUser), _
		DllStructGetPtr($tPassword), _
		0 )
	If $iSSP = 0 Then $iSSPE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSSPE, 0, $iSSP)
EndFunc ;==> _Service_SetAccount

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetBinaryPath
; Description ...: Sets or changes the path to the service binary file.
; Syntax.........: _Service_SetBinaryPath($sServiceName, $sBinaryPath [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sBinaryPath - The fully-qualified path to the service binary file.
;                                 If the path contains a space, it must be quoted so that it is correctly interpreted.
;                                 For example, "d:\\my share\\myservice.exe" should be specified as "\"d:\\my share\\myservice.exe\"".
;                                 The path can also include arguments for an auto-start service. For example, "d:\\myshare\\myservice.exe arg1 arg2".
;                                 These arguments are passed to the service entry point (typically the main function).
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetBinaryPath($sServiceName, $sBinaryPath, $sComputerName = "")
	Local $tBinaryPath, $hSC, $hService, $iSCh, $iSChE
	$tBinaryPath = DllStructCreate("char[" & StringLen($sBinaryPath) + 1 & "]")
	DllStructSetData($tBinaryPath, 1, $sBinaryPath)
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSCh = ChangeServiceConfig( $hService, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		DllStructGetPtr($tBinaryPath), _
		0, 0, 0, 0, 0, 0 )
	If $iSCh = 0 Then $iSChE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSChE, 0, $iSCh)
EndFunc ;==> _Service_SetBinaryPath

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetDependencies
; Description ...: Sets or changes a service's dependencies.
; Syntax.........: _Service_SetDependencies($sServiceName, $vDependencies [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $vDependencies - An array of services or load ordering groups that the system must start before this service can be started.
;                                   (Dependency on a group means that this service can run if at least one member of the group is running after an attempt to
;                                   start all members of the group.) Specify an empty string if the service has no dependencies.
;                                   You must prefix group names with a plus sign ("+") so that they can be distinguished from a service name,
;                                   because services and service groups share the same name space.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetDependencies($sServiceName, $vDependencies, $sComputerName = "")
	Local $iDepend, $tagDepend, $tDepend, $hSC, $hService, $iSSD, $iSSDE
	If IsArray($vDependencies) Then
		Local $asDepend = $vDependencies
	Else
		Local $asDepend[1] = [$vDependencies]
	EndIf
	$iDepend = UBound($asDepend) - 1
	For $i = 0 To $iDepend
		$tagDepend &= "char[" & StringLen($asDepend[$i]) + 1 & "];"
	Next
	$tDepend = DllStructCreate( StringTrimRight($tagDepend, 1) )
	For $i = 0 To $iDepend
		DllStructSetData($tDepend, $i + 1, $asDepend[$i])
	Next
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSSD = ChangeServiceConfig( $hService, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		0, 0, 0, _
		DllStructGetPtr($tDepend), _
		0, 0, 0 )
	If $iSSD = 0 Then $iSSDE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSSDE, 0, $iSSD)
EndFunc ;==> _Service_SetDependencies

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetDesc
; Description ...: Sets or changes a service's description.
; Syntax.........: _Service_SetDesc($sServiceName, $sDescription [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sDescription - The description of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetDesc($sServiceName, $sDescription, $sComputerName = "")
	Local $hSC, $hService, $avCSC2, $iCSC2
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$avCSC2 = DllCall( "advapi32.dll", "int", "ChangeServiceConfig2", _
		"hwnd", $hService, _
		"dword", $SERVICE_CONFIG_DESCRIPTION, _
		"str*", $sDescription )
	If $avCSC2[0] = 0 Then $iCSC2 = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iCSC2, 0, $avCSC2[0])
EndFunc ;==> _Service_SetDesc

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetDisplayName
; Description ...: Sets or changes the display name of a service.
; Syntax.........: _Service_SetDisplayName($sServiceName, $sDisplayName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sDisplayName - The display name to be used by user interface programs to identify the service. The maximum string length is 256 characters.
;                                  The service control manager database preserves the case of the characters,
;                                  but service name comparisons are always case insensitive.
;                                  Forward-slash (/) and back-slash (\) are invalid service name characters.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetDisplayName($sServiceName, $sDisplayName, $sComputerName = "")
	Local $tDisplayName, $hSC, $hService, $iSCh, $iSChE
	$tDisplayName = DllStructCreate("char[" & StringLen($sDisplayName) + 1 & "]")
	DllStructSetData($tDisplayName, 1, $sDisplayName)
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSCh = ChangeServiceConfig( $hService, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		0, 0, 0, 0, 0, 0, _
		DllStructGetPtr($tDisplayName) )
	If $iSCh = 0 Then $iSChE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSChE, 0, $iSCh)
EndFunc ;==> _Service_SetDisplayName

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetErrorControl
; Description ...: Sets or changes a service's error control.
; Syntax.........: _Service_SetErrorControl($sServiceName, $iErrorControl [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $iErrorControl - The severity of the error, and action taken, if this service fails to start. Specify one of the following values:
;                                   $SERVICE_ERROR_IGNORE - The startup program ignores the error and continues the startup operation.
;                                   $SERVICE_ERROR_NORMAL - The startup program logs the error in the event log but continues the startup operation.
;                                   $SERVICE_ERROR_SEVERE - The startup program logs the error in the event log.
;                                                           If the last-known-good configuration is being started, the startup operation continues.
;                                                           Otherwise, the system is restarted with the last-known-good configuration.
;                                   $SERVICE_ERROR_CRITICAL - The startup program logs the error in the event log, if possible.
;                                                             If the last-known-good configuration is being started, the startup operation fails.
;                                                             Otherwise, the system is restarted with the last-known good configuration.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetErrorControl($sServiceName, $iErrorControl, $sComputerName = "")
	Local $hSC, $hService, $iSEC, $iSECE
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSEC = ChangeServiceConfig( $hService, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		$iErrorControl, _
		0, 0, 0, 0, 0, 0, 0 )
	If $iSEC = 0 Then $iSECE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSECE, 0, $iSEC)
EndFunc ;==> _Service_SetErrorControl

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetFailureActions
; Description ...: Sets or changes service failure action settings.
; Syntax.........: _Service_SetFailureActions($sServiceName, $iResetPeriod [, $sRebootMsg, $sCommand, $aiActions, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $iResetPeriod - The time after which to reset the failure count to zero if there are no failures, in days.
;                  $sRebootMsg - [Optional] The message to be broadcast to server users before rebooting in response to the $SC_ACTION_REBOOT
;                                service controller action.
;                                If this value is "Default", the reboot message is unchanged. If the value is an empty string (""),
;                                the reboot message is deleted and no message is broadcast.
;                  $sCommand - [Optional] The command line of the process for the CreateProcess function to execute in response to the
;                              $SC_ACTION_RUN_COMMAND service controller action. This process runs under the same account as the service.
;                              If this value is "Default", the command is unchanged. If the value is an empty string (""),
;                              the command is deleted and no program is run when the service fails.
;                  $aiActions - [Optional] An array of SC_ACTION_TYPE and respective delay in minutes. The array must be of the form:
;                               $Array[n][2] = [[Type 1, Delay 1], [Type 2, Delay 2], ... [Type n, Delay n]]
;                               "Type" represents the action to be performed. It can be one of the following values from the SC_ACTION_TYPE enumeration type:
;                               $SC_ACTION_NONE - No action.
;                               $SC_ACTION_RESTART - Restart the service.
;                               $SC_ACTION_REBOOT - Reboot the computer.
;                               $SC_ACTION_RUN_COMMAND - Run a command.
;                               "Delay" represents the time to wait before performing the specified action, in minutes.
;                               If this parameter is "Default", the service's actions remain unchanged. If the parameter is an empty string (""),
;                               the service's actions are deleted.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: $Service = "ALG"
;                  $ResetPeriod = 1
;                  $RebootMsg = "System is going to reboot now."
;                  $Command = @SystemDir & "\alg.exe /?"
;                  Dim $aiActions[3][2] = [[$SC_ACTION_RUN_COMMAND, 1], [$SC_ACTION_RESTART, 1], [$SC_ACTION_REBOOT, 1]]
;                  $iResult = _Service_SetFailureActions($Service, $ResetPeriod, $RebootMsg, $Command, $aiActions)
;                  MsgBox(0, "", $iResult & @CRLF & @error)
; ==================================================================================================================================================================

Func _Service_SetFailureActions($sServiceName, $iResetPeriod, $sRebootMsg = Default, $sCommand = Default, $aiActions = Default, $sComputerName = "")
	Local $tRebootMsg, $tCommand, $iDim, $iActions, $tSC_ACTION, $tSERVICE_FAILURE_ACTIONS, $hSC, $hService, $avPrev, $avCSC2, $iCSC2
	$tRebootMsg = DllStructCreate("char[" & Number($sRebootMsg <> Default) * ( StringLen($sRebootMsg) + 1 ) & "]")
	DllStructSetData($tRebootMsg, 1, $sRebootMsg)
	$tCommand = DllStructCreate("char[" & Number($sCommand <> Default) * ( StringLen($sCommand) + 1 ) & "]")
	DllStructSetData($tCommand, 1, $sCommand)
	$iDim = UBound($aiActions, 0)
	While 1
		If $aiActions = Default Or $aiActions = "" Then ExitLoop
		If Not ( $iDim <= 2 And UBound($aiActions, $iDim) = 2 ) Then Return SetError(-1, 0, 0)
		ExitLoop
	WEnd
	If $iDim = 1 Then
		Local $aiTemp[1][2]
		$aiTemp[0][0] = $aiActions[0]
		$aiTemp[0][1] = $aiActions[1]
		$aiActions = $aiTemp
		$aiTemp = 0
	EndIf
	$iActions = UBound($aiActions, 1)
	$tSC_ACTION = DllStructCreate("dword[" & 2 * ( $iActions + Number($aiActions = "") ) & "]")
	For $i = 0 To $iActions - 1
		DllStructSetData($tSC_ACTION, 1, $aiActions[$i][0], 2 * $i + 1)
		DllStructSetData($tSC_ACTION, 1, $aiActions[$i][1] * 6E+4, 2 * $i + 2)
	Next
	$tSERVICE_FAILURE_ACTIONS = DllStructCreate("dword;uint_ptr[2];dword;uint_ptr")
	DllStructSetData($tSERVICE_FAILURE_ACTIONS, 1, $iResetPeriod * 86400)
	DllStructSetData($tSERVICE_FAILURE_ACTIONS, 2, DllStructGetPtr($tRebootMsg), 1)
	DllStructSetData($tSERVICE_FAILURE_ACTIONS, 2, DllStructGetPtr($tCommand), 2)
	DllStructSetData($tSERVICE_FAILURE_ACTIONS, 3, $iActions)
	DllStructSetData( $tSERVICE_FAILURE_ACTIONS, 4, DllStructGetPtr($tSC_ACTION) )
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService( $hSC, $sServiceName, BitOR($SERVICE_CHANGE_CONFIG, $SERVICE_START) )
	CloseServiceHandle($hSC)
	Local $avCurr[2] = [$SE_SHUTDOWN_NAME, $SE_PRIVILEGE_ENABLED]
	$avPrev = _SetPrivilege($avCurr)
	$avCSC2 = DllCall( "advapi32.dll", "int", "ChangeServiceConfig2", _
		"hwnd", $hService, _
		"dword", $SERVICE_CONFIG_FAILURE_ACTIONS, _
		"ptr", DllStructGetPtr($tSERVICE_FAILURE_ACTIONS) )
	If $avCSC2[0] = 0 Then $iCSC2 = GetLastError()
	_SetPrivilege($avPrev)
	CloseServiceHandle($hService)
	Return SetError($iCSC2, 0, $avCSC2[0])
EndFunc ;==> _Service_SetFailureActions

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetGroup
; Description ...: Sets or changes the load ordering group of which a service is member.
; Syntax.........: _Service_SetGroup($sServiceName, $sLoadOrderGroup [, $fTagId, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sLoadOrderGroup - The name of the load ordering group of which this service is a member.
;                                     Specify an empty string if the service does not belong to a group.
;                  $fTagId - [Optional] Specify "True" if you desire a tag value that is unique in the group specified in the $sLoadOrderGroup parameter.
;                            Specify "False" or "Default" if you are not changing the existing tag. This is the default.
;                            The tag value is stored in @extended macro.
;                            You can use a tag for ordering service startup within a load ordering group by specifying a tag order vector in the
;                            GroupOrderList value of the following registry key:
;                            HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control
;                            Tags are only evaluated for driver services that have $SERVICE_BOOT_START or $SERVICE_SYSTEM_START start types.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetGroup($sServiceName, $sLoadOrderGroup, $fTagId = False, $sComputerName = "")
	Local $tLoadOrderGroup, $tTagId, $hSC, $hService, $iSSG, $iSSGE
	$tLoadOrderGroup = DllStructCreate("char[" & StringLen($sLoadOrderGroup) + 1 & "]")
	DllStructSetData($tLoadOrderGroup, 1, $sLoadOrderGroup)
	$tTagId = DllStructCreate("dword[" & Number($fTagId) & "]")
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSSG = ChangeServiceConfig( $hService, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		0, _
		DllStructGetPtr($tLoadOrderGroup), _
		DllStructGetPtr($tTagId), _
		0, 0, 0, 0 )
	If $iSSG = 0 Then $iSSGE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSSGE, DllStructGetData($tTagId, 1), $iSSG)
EndFunc ;==> _Service_SetGroup

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetStartType
; Description ...: Sets or changes a service's start type.
; Syntax.........: _Service_SetStartType($sServiceName, $iStartType [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $iStartType - The service start options. Specify one of the following values:
;                                $SERVICE_BOOT_START - A device driver started by the system loader. This value is valid only for driver services.
;                                $SERVICE_SYSTEM_START - A device driver started by the IoInitSystem function. This value is valid only for driver services.
;                                $SERVICE_AUTO_START - A service started automatically by the service control manager during system startup.
;                                $SERVICE_DEMAND_START - A service started by the service control manager when a process calls the StartService function.
;                                $SERVICE_DISABLED - A service that cannot be started.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetStartType($sServiceName, $iStartType, $sComputerName = "")
	Local $hSC, $hService, $iSSM, $iSSME
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSSM = ChangeServiceConfig( $hService, _
		$SERVICE_NO_CHANGE, _
		$iStartType, _
		$SERVICE_NO_CHANGE, _
		0, 0, 0, 0, 0, 0, 0 )
	If $iSSM = 0 Then $iSSME = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSSME, 0, $iSSM)
EndFunc ;==> _Service_SetStartType

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_SetType
; Description ...: Sets or changes the type of service.
; Syntax.........: _Service_SetType($sServiceName, $iServiceType [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $iServiceType - The type of service. Specify one of the following service types:
;                                  $SERVICE_KERNEL_DRIVER - Driver service.
;                                  $SERVICE_FILE_SYSTEM_DRIVER - File system driver service.
;                                  $SERVICE_WIN32_OWN_PROCESS - Service that runs in its own process.
;                                  $SERVICE_WIN32_SHARE_PROCESS - Service that shares a process with other services.
;                                  If you specify either $SERVICE_WIN32_OWN_PROCESS or $SERVICE_WIN32_SHARE_PROCESS,
;                                  and the service is running in the context of the LocalSystem account, you can also specify the following type:
;                                  $SERVICE_INTERACTIVE_PROCESS - The service can interact with the desktop.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_SetType($sServiceName, $iServiceType, $sComputerName = "")
	Local $hSC, $hService, $iSST, $iSSTE
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_CHANGE_CONFIG)
	CloseServiceHandle($hSC)
	$iSST = ChangeServiceConfig( $hService, _
		$iServiceType, _
		$SERVICE_NO_CHANGE, _
		$SERVICE_NO_CHANGE, _
		0, 0, 0, 0, 0, 0, 0 )
	If $iSST = 0 Then $iSSTE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSSTE, 0, $iSST)
EndFunc ;==> _Service_SetType

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Start
; Description ...: Starts a service.
; Syntax.........: _Service_Start($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Start($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avSS, $iSS
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_START)
	CloseServiceHandle($hSC)
	$avSS = DllCall( "advapi32.dll", "int", "StartService", _
		"hwnd", $hService, _
		"dword", 0, _
		"ptr", 0 )
	If $avSS[0] = 0 Then $iSS = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iSS, 0, $avSS[0])
EndFunc ;==> _Service_Start

; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Stop
; Description ...: Stops a service.
; Syntax.........: _Service_Stop($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Stop($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $iCSS, $iCSSE
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_STOP)
	CloseServiceHandle($hSC)
	$iCSS = ControlService($hService, $SERVICE_CONTROL_STOP)
	If $iCSS = 0 Then $iCSSE = GetLastError()
	CloseServiceHandle($hService)
	Return SetError($iCSSE, 0, $iCSS)
EndFunc ;==> _Service_Stop

Func ChangeServiceConfig( $hService, _
		$iServiceType, _
		$iStartType, _
		$iErrorType, _
		$pBinaryPath, _
		$pLoadOrderGroup, _
		$pTagId, _
		$pDependencies, _
		$pServiceUser, _
		$pPassword, _
		$pDisplayName )
	Local $avCSC = DllCall( "advapi32.dll", "int", "ChangeServiceConfig", _
		"hwnd", $hService, _
		"dword", $iServiceType, _
		"dword", $iStartType, _
		"dword", $iErrorType, _
		"ptr", $pBinaryPath, _
		"ptr", $pLoadOrderGroup, _
		"ptr", $pTagId, _
		"ptr", $pDependencies, _
		"ptr", $pServiceUser, _
		"ptr", $pPassword, _
		"ptr", $pDisplayName )
	Return $avCSC[0]
EndFunc ;==> ChangeServiceConfig

Func CloseServiceHandle($hSCObject)
	Local $avCSH = DllCall( "advapi32.dll", "int", "CloseServiceHandle", _
		"hwnd", $hSCObject )
	Return $avCSH[0]
EndFunc ;==> CloseServiceHandle

Func ControlService($hService, $iControl)
	Local $avCS = DllCall( "advapi32.dll", "int", "ControlService", _
		"hwnd", $hService, _
		"dword", $iControl, _
		"str", "" )
	Return $avCS[0]
EndFunc ;==> ControlService

Func GetLastError()
	Local $aiE = DllCall("kernel32.dll", "dword", "GetLastError")
	Return $aiE[0]
EndFunc ;==> GetLastError

Func OpenSCManager($sComputerName, $iAccess)
	Local $avOSCM = DllCall( "advapi32.dll", "hwnd", "OpenSCManager", _
		"str", $sComputerName, _
		"str", "ServicesActive", _
		"dword", $iAccess )
	Return $avOSCM[0]
EndFunc ;==> OpenSCManager

Func OpenService($hSC, $sServiceName, $iAccess)
	Local $avOS = DllCall( "advapi32.dll", "hwnd", "OpenService", _
		"hwnd", $hSC, _
		"str", $sServiceName, _
		"dword", $iAccess )
	Return $avOS[0]
EndFunc ;==> OpenService

Func QueryServiceConfig($hService, $pServiceConfig, $iBufSize)
	Local $avQSC = DllCall( "advapi32.dll", "int", "QueryServiceConfig", _
		"hwnd", $hService, _
		"ptr", $pServiceConfig, _
		"dword", $iBufSize, _
		"dword*", 0 )
	Return $avQSC
EndFunc ;==> QueryServiceConfig
