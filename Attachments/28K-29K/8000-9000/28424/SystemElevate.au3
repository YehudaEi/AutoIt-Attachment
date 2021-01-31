#NoTrayIcon
#RequireAdmin
#include "_Services_Mini.au3"

; usage
; 1) launch with optional command line params
; 2) installs itself as a service with '-service' parameter + optional command line params
; 3) start the service
; 4) service re-launches app under system account in current logon session with '-run <PID>' parameters + optional command line params
; 5) new app instance waits for service to end, removes the service, and continues

Global $sService = "SystemElevateService"
Global $sLog = @ScriptDir & "\SystemElevateService.log"
Global $SVC_DEBUG = True ; write debug log

If $CmdLine[0] > 0 Then
	Switch $CmdLine[1]
		Case "-service"
			; as service
			; elevate and run the app, exit
			_Service_Init($sService)
			Exit
		Case "-run"
			; as elevated app
			; stop and uninstall service (PID passed as $CmdLine[2])
			_Service_Stop($sService)
			If Not ProcessWaitClose(Number($CmdLine[2]), 5) Then ProcessClose(Number($CmdLine[2]))
			_RemoveService()
			; elevated main app continues
			; break
		Case "-error"
			; could not elevate, uninstall the service and exit
			_Service_Stop($sService)
			If Not ProcessWaitClose(Number($CmdLine[2]), 5) Then ProcessClose(Number($CmdLine[2]))
			_RemoveService()
			Exit
		Case Else
			; install with command line
			_InstallService($CmdLineRaw)
	EndSwitch
Else
	; install no command line
	_InstallService()
EndIf

#Region ; User Functions
; #FUNCTION# =======================================================================================================================================================
; Name...........: _CreateProcessAsUser
; Description ...: Creates a process as the user of a currently running process in the specified session.
; Syntax.........: _CreateProcessAsUser($sCmdLine, $sProcessAsUser [, $dwSessionId = -1])
; Parameters ....: $sCmdLine - Full command to launch the process, including any command line parameters
;				   $sProcessAsUser - Name of a process running under the desired user's session / account.
;				   $dwSessionId - [Optional] Session ID under which $sProcessAsUser is running.  Default is the current session.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
; Author ........: Erik Pilsits
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _CreateProcessAsUser($sCmdLine, $sProcessAsUser, $dwSessionId = -1)
	Return _ElevateAndRun($sCmdLine, False, False, $sProcessAsUser, $dwSessionId)
EndFunc   ;==>_CreateProcessAsUser

; #FUNCTION# =======================================================================================================================================================
; Name...........: _ImpersonateUserStart
; Description ...: Impersonates the security context of the logged on user
; Syntax.........: _ImpersonateUserStart([$sProcess = 'explorer.exe'])
; Parameters ....: $sProcess - [Optional] Name of a process running under the logged on user's session / account.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
; Author ........: Erik Pilsits
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _ImpersonateUserStart($sProcess = "explorer.exe")
	Local Const $MAXIMUM_ALLOWED = 0x02000000

	Local $ret = 0
	Local $dwSession = DllCall("kernel32.dll", "dword", "WTSGetActiveConsoleSessionId")
	If @error Or $dwSession[0] = 0xFFFFFFFF Then Return 0
	$dwSession = $dwSession[0]
	; get PID of process in current session
	Local $aProcs = ProcessList($sProcess), $processPID = -1, $ret
	For $i = 1 To $aProcs[0][0]
		$ret = DllCall("kernel32.dll", "int", "ProcessIdToSessionId", "dword", $aProcs[$i][1], "dword*", 0)
		If Not @error And $ret[0] And ($ret[2] = $dwSession) Then
			$processPID = $aProcs[$i][1]
			ExitLoop
		EndIf
	Next
	If $processPID = -1 Then Return 0 ; failed to get PID
	; open process
	Local $hProc = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", $MAXIMUM_ALLOWED, "int", 0, "dword", $processPID)
	If @error Or Not $hProc[0] Then Return 0
	$hProc = $hProc[0]
	; open process token
	$hToken = DllCall($ghADVAPI32, "int", "OpenProcessToken", "ptr", $hProc, "dword", $MAXIMUM_ALLOWED, "ptr*", 0)
	If @error Or Not $hToken[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
		Return 0
	EndIf
	$hToken = $hToken[3]
	; impersonate the logged on user
	$ret = DllCall($ghADVAPI32, "int", "ImpersonateLoggedOnUser", "ptr", $hToken)
	If @error Or Not $ret[0] Then
		_DebugLog("Error impersonating user.")
	Else
		_DebugLog("Successfully impersonated user.")
		$ret = 1
	EndIf
	DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hToken)
	DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
	Return $ret
EndFunc   ;==>_ImpersonateUserStart

; #FUNCTION# =======================================================================================================================================================
; Name...........: _ImpersonateUserEnd
; Description ...: Terminates the impersonation of a user
; Syntax.........: _ImpersonateUserEnd()
; Parameters ....: none
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
; Author ........: Erik Pilsits
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _ImpersonateUserEnd()
	Local $ret = DllCall($ghADVAPI32, "int", "RevertToSelf")
	If @error Or Not $ret[0] Then
		_DebugLog("Error reverting to self.")
		Return 0
	Else
		_DebugLog("Successfully reverted to self.")
		Return 1
	EndIf
EndFunc   ;==>_ImpersonateUserEnd()
#EndRegion ; User Functions

#Region ; Service Functions
; ==============================================
; ;;;; INTERNAL ;;;;
; ==============================================
Func _DebugLog($sEvent)
	If $SVC_DEBUG Then FileWriteLine($sLog, @YEAR & @MON & @MDAY & " " & @HOUR & @MIN & @SEC & " [" & @AutoItPID & "] >> " & $sEvent)
EndFunc

Func _InstallService($sCmdLine = "")
	; install
	Local $sBinPath = '"' & @ScriptFullPath & '" -service'
	If $sCmdLine <> "" Then $sBinPath &= " " & $sCmdLine
	_DebugLog("_InstallService(): Installing service, please wait...")
	_Service_Create($sService, "System Elevate Service", $SERVICE_WIN32_OWN_PROCESS, $SERVICE_DEMAND_START, $SERVICE_ERROR_IGNORE, $sBinPath)
	If @error Then
		_DebugLog("_InstallService(): Problem installing service: Error: " & @error & " / Message: " & _WinAPI_GetLastErrorMessage())
	Else
		_DebugLog("_InstallService(): Installation of service successful.")
		_DebugLog("_InstallService(): Starting serivce...")
		; run
		_Service_Start($sService)
		If @error Then
			_DebugLog("_InstallService(): Problem starting service: Error: " & @error & " / Message: " & _WinAPI_GetLastErrorMessage())
		Else
			_DebugLog("_InstallService(): Started service successfully.")
		EndIf
	EndIf
	; this instance done
	Exit
EndFunc

Func _RemoveService()
	_DebugLog("_RemoveService(): Removing service, please wait...")
	_Service_Delete($sService)
	If @error Then
		_DebugLog("_RemoveService(): Problem removing service: Error: " & @error & " / Message: " & _WinAPI_GetLastErrorMessage())
	Else
		_DebugLog("_RemoveService(): Service removed successfully." & @CRLF)
	EndIf
EndFunc

Func _Svc_Main()
	_DebugLog("Starting service main.")
	Local $sCmdLine = "", $sElem
	For $i = 2 To $CmdLine[0]
		$sElem = $CmdLine[$i]
		If StringInStr($sElem, " ") Then $sElem = '"' & $sElem & '"' ; fix quoted params
		$sCmdLine &= $sElem & " "
	Next
	; ====================================================================
	; if you want to run the new process in Session 0 (like the service)
	; add a second parameter 'True' to the next function call
	; NOTE:  it will not be able to interact with the desktop or access
	; the current user's environment.
	; ====================================================================
	If Not _ElevateAndRun(StringTrimRight($sCmdLine, 1)) Then
		; could not create elevated process, remove service
		_DebugLog("Failed to create process.")
		Run('"' & @ScriptFullPath & '" -error ' & @AutoItPID)
	EndIf
	; done, wait for stop control/event
	; there are a few options here, but using a flag seems to be the most stable
	; the flag is set in _Service_Startup() and _Service_SetStopEvent()
;~ 	_WinAPI_WaitForSingleObject($service_stop_event)
;~ 	While _WinAPI_WaitForSingleObject($service_stop_event, 0)
;~ 		Sleep(250)
;~ 	WEnd
	While $gServiceStateRunning
		Sleep(250)
	WEnd
	_Service_Cleanup()
EndFunc

Func _ElevateAndRun($sCmdLine, $fAsSession0 = False, $fromService = True, $sProcessAsUser = "winlogon.exe", $dwSessionId = -1)
	Local Const $MAXIMUM_ALLOWED = 0x02000000
	Local Const $TOKEN_DUPLICATE = 0x2
	Local Const $tagSTARTUPINFO = "dword cb;ptr lpReserved;ptr lpDesktop;ptr lpTitle;dword dwX;dword dwY;dword dwXSize;dword dwYSize;" & _
									"dword dwXCountChars;dword dwYCountChars;dword dwFillAttribute;dword dwFlags;ushort wShowWindow;" & _
									"ushort cbReserved2;ptr lpReserved2;ptr hStdInput;ptr hStdOutput;ptr hStdError"
	Local Const $tagPROCESSINFO = "ptr hProcess;ptr hThread;dword dwProcessId;dword dwThreadId"
	Local Const $SecurityIdentification = 1
	Local Const $TokenPrimary = 1
	Local Const $NORMAL_PRIORITY_CLASS = 0x00000020
	Local Const $CREATE_NEW_CONSOLE = 0x00000010
	Local Const $CREATE_UNICODE_ENVIRONMENT = 0x00000400

	; create app command line
	Local $sAppPath
	If $fromService Then
		$sAppPath = '"' & @ScriptFullPath & '" -run ' & @AutoItPID
		If $sCmdLine <> "" Then $sAppPath &= " " & $sCmdLine
	Else
		$sAppPath = $sCmdLine
	EndIf
	; launch as session 0?
	If $fAsSession0 Then Return Run($sAppPath)
	; launch as current user
	; get current session id
	If $dwSessionId = -1 Then
		$dwSessionId = DllCall("kernel32.dll", "dword", "WTSGetActiveConsoleSessionId")
		If @error Or $dwSessionId[0] = 0xFFFFFFFF Then Return 0
		$dwSessionId = $dwSessionId[0]
	EndIf
	_DebugLog("dwSessionId: " & $dwSessionId)
	; get PID of process in current session
	Local $aProcs = ProcessList($sProcessAsUser), $processPID = -1, $ret
	For $i = 1 To $aProcs[0][0]
		$ret = DllCall("kernel32.dll", "int", "ProcessIdToSessionId", "dword", $aProcs[$i][1], "dword*", 0)
		If Not @error And $ret[0] And ($ret[2] = $dwSessionId) Then
			$processPID = $aProcs[$i][1]
			ExitLoop
		EndIf
	Next
	_DebugLog("winlogonPID: " & $processPID)
	If $processPID = -1 Then Return 0 ; failed to get winlogon PID in current session
	; open winlogon process
	Local $hProc = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", $MAXIMUM_ALLOWED, "int", 0, "dword", $processPID)
	If @error Or Not $hProc[0] Then Return 0
	$hProc = $hProc[0]
	_DebugLog("hProcess: " & $hProc)
	; open process token
	$hToken = DllCall($ghADVAPI32, "int", "OpenProcessToken", "ptr", $hProc, "dword", $TOKEN_DUPLICATE, "ptr*", 0)
	If @error Or Not $hToken[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
		Return 0
	EndIf
	$hToken = $hToken[3]
	_DebugLog("hToken: " & $hToken)
	; duplicate token
	Local $hDupToken = DllCall($ghADVAPI32, "int", "DuplicateTokenEx", "ptr", $hToken, "dword", $MAXIMUM_ALLOWED, "ptr", 0, _
								"int", $SecurityIdentification, "int", $TokenPrimary, "ptr*", 0)
	If @error Or Not $hDupToken[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hToken)
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
		Return 0
	EndIf
	$hDupToken = $hDupToken[6]
	_DebugLog("hDupToken: " & $hDupToken)
	; get environment block
	Local $pEnvBlock
	If $fromService Then
		$pEnvBlock = _GetEnvironmentBlock("explorer.exe", $dwSessionId) ; logged on user
	Else
		$pEnvBlock = _GetEnvironmentBlock($sProcessAsUser, $dwSessionId) ; target process
	EndIf
	_DebugLog("pEnvBlock: " & $pEnvBlock)
	; create new process in user's session, with user's environment block
	Local $dwCreationFlags = BitOR($NORMAL_PRIORITY_CLASS, $CREATE_NEW_CONSOLE)
	If $pEnvBlock Then $dwCreationFlags = BitOR($dwCreationFlags, $CREATE_UNICODE_ENVIRONMENT)
	Local $SI = DllStructCreate($tagSTARTUPINFO)
	DllStructSetData($SI, "cb", DllStructGetSize($SI))
	Local $PI = DllStructCreate($tagPROCESSINFO)
	Local $sDesktop = "winsta0\default"
	Local $lpDesktop = DllStructCreate("wchar[" & StringLen($sDesktop) + 1 & "]")
	DllStructSetData($lpDesktop, 1, $sDesktop)
	DllStructSetData($SI, "lpDesktop", DllStructGetPtr($lpDesktop))
	$ret = DllCall($ghADVAPI32, "int", "CreateProcessAsUserW", "ptr", $hDupToken, "ptr", 0, "wstr", $sAppPath, "ptr", 0, "ptr", 0, "int", 0, _
					"dword", $dwCreationFlags, "ptr", $pEnvBlock, "ptr", 0, "ptr", DllStructGetPtr($SI), "ptr", DllStructGetPtr($PI))
	If Not @error And $ret[0] Then
		_DebugLog("New process created successfully: " & DllStructGetData($PI, "dwProcessId"))
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", DllStructGetData($PI, "hThread"))
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", DllStructGetData($PI, "hProcess"))
		$ret = 1
	Else
		$ret = 0
	EndIf
	If $pEnvBlock Then DllCall("userenv.dll", "int", "DestroyEnvironmentBlock", "ptr", $pEnvBlock)
	DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hDupToken)
	DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hToken)
	DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
	Return $ret
EndFunc

Func _GetEnvironmentBlock($sProcess, $dwSession)
	Local Const $MAXIMUM_ALLOWED = 0x02000000
	Local Const $dwAccess = BitOR(0x2, 0x8) ; TOKEN_DUPLICATE | TOKEN_QUERY

	; get PID of process in current session
	Local $aProcs = ProcessList($sProcess), $processPID = -1, $ret = 0
	For $i = 1 To $aProcs[0][0]
		$ret = DllCall("kernel32.dll", "int", "ProcessIdToSessionId", "dword", $aProcs[$i][1], "dword*", 0)
		If Not @error And $ret[0] And ($ret[2] = $dwSession) Then
			$processPID = $aProcs[$i][1]
			ExitLoop
		EndIf
	Next
	If $processPID = -1 Then Return 0 ; failed to get PID
	; open process
	Local $hProc = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", $MAXIMUM_ALLOWED, "int", 0, "dword", $processPID)
	If @error Or Not $hProc[0] Then Return 0
	$hProc = $hProc[0]
	; open process token
	$hToken = DllCall($ghADVAPI32, "int", "OpenProcessToken", "ptr", $hProc, "dword", $dwAccess, "ptr*", 0)
	If @error Or Not $hToken[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
		Return 0
	EndIf
	$hToken = $hToken[3]
	; create a new environment block
	Local $pEnvBlock = DllCall("userenv.dll", "int", "CreateEnvironmentBlock", "ptr*", 0, "ptr", $hToken, "int", 1)
	If Not @error And $pEnvBlock[0] Then $ret = $pEnvBlock[1]
	; close handles
	DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hToken)
	DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hProc)
	Return $ret
EndFunc
#EndRegion ; Service Functions


; =============================
;	ELEVATED MAIN SCRIPT HERE
; =============================
; !!! if passing command line parameters, your params now start at $CmdLine[3] !!!
; $CmdLine[1] = '-run', $CmdLine[2] = PID of service
TraySetState()
MsgBox(0, "Elevated Process", "Here I am!" & @CRLF & @LogonDomain & "\" & @UserName)
_ImpersonateUserStart()
MsgBox(0, "Elevated Process", "Impersonating:" & @CRLF & @LogonDomain & "\" & @UserName)
_ImpersonateUserEnd()
MsgBox(0, "Elevated Process", "Reverted:" & @CRLF & @LogonDomain & "\" & @UserName)
MsgBox(0, "_CreateProcessAsUser", "Launching notepad as currently logged on user when you press OK...")
_CreateProcessAsUser("notepad.exe", "explorer.exe")

Exit