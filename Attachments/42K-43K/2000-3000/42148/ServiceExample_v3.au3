#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("mustdeclarevars",1)
;~ #AutoIt3Wrapper_Version=beta
;~ Opt("MustDeclareVars", 1) ; just for self control  FPRIVATE "TYPE=PICT;ALT=smile.gif" dont to forget declare vars
Dim $MainLog = @ScriptDir & "\test_service.log"
;~ FileDelete($MainLog)
;~ If $bServiceRunning Then Exit
logprint("program started" & $cmdlineraw)

#include <Winapi.au3> ;just for constants
#include "services.au3"

;~ #include <Timers.au3> ; i used it for timers func
If $bAU3ServiceDebug Then logprint("script started")
If $cmdline[0] > 0 Then
	Switch $cmdline[1]
		Case "install", "-i", "/i"
;~ 			msgbox(0,"","toto")
			InstallService()
		Case "remove", "-u", "/u", "uninstall"
			RemoveService()

		Case Else
			ConsoleWrite(" - - - Help - - - " & @CRLF)
			ConsoleWrite("params : " & @CRLF)
			ConsoleWrite(" -i : install service" & @CRLF)
			ConsoleWrite(" -u : remove service" & @CRLF)
			ConsoleWrite(" - - - - - - - - " & @CRLF)
			Exit
			;start service.
	EndSwitch
Else
	_Service_init($sServiceName)
	Exit
EndIf

Func _main($iArg, $sArgs)
Sleep(1000)
;~ $bMainStopped = False
If Not _Service_ReportStatus($SERVICE_RUNNING, $NO_ERROR, 0) Then
	if $bAU3ServiceDebug then logprint("Erreur sending running status, exiting")
	_Service_ReportStatus($SERVICE_STOPPED, _WinAPI_GetLastError(), 0)
	Exit
EndIf
$bServiceRunning = True ; REQUIRED

#region --> insert your running code here
local $count = 0
Dim $tcpon = true
If $tcpon Then
	TCPStartup()
	Dim $tcpConn = TCPConnect("127.0.0.1",3585)
	TCPSend($tcpConn,"Hello " & @AutoItPID)
EndIf
While $bServiceRunning ; REQUIRED  ( dont change variable name ) ; there are several ways to find that service have to be stoped - $Running flag in loop is the first method
;~ 	if $count < 5 then
	logprint("main count" & $count & @crlf)
;~ 	If $tcpon Then TCPSend($tcpConn, "main count" & $count & @crlf)
;~ 	if $count < 5 then logprint("main count" & $count & @crlf)

	$count += 1
	Sleep(1000)
;~ 	if $count = 4 then
;~ 	while 1
;~ 		if not $bServiceRunning then
;~ 			logprint("stop loop 4")
;~ 			ExitLoop
;~ 		EndIf
;~ 	WEnd
;~ 	endif
WEnd
#endregion  --> insert your running code here
_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, 0)
logprint("seems service stopping")

;~ Sleep(2000)
;~ $bMainStopped = True

;~ If $tcpon Then TCPCloseSocket($tcpConn)
;~ If $tcpon Then TCPShutdown()
DllCallbackFree($tServiceMain)
DllCallbackFree($tServiceCtrl)


_Service_ReportStatus($SERVICE_STOPPED, $NO_ERROR, 0)
DllClose($hAdvapi32_DLL)
DllClose($hKernel32_DLL)
return
;~ _service_cleanup()
;~ exit
;~ return
EndFunc   ;==>main

;~ If $bDebug Then logprint("script started")
#cs
If $cmdline[0] > 0 Then
	Switch $cmdline[1]
		Case "install", "-i", "/i"
;~ 			msgbox(0,"","toto")
			InstallService()
		Case "remove", "-u", "/u", "uninstall"
			RemoveService()

		Case Else
			ConsoleWrite(" - - - Help - - - " & @CRLF)
			ConsoleWrite("params : " & @CRLF)
			ConsoleWrite(" -i : install service" & @CRLF)
			ConsoleWrite(" -u : remove service" & @CRLF)
			ConsoleWrite(" - - - - - - - - " & @CRLF)
			Exit
			;start service.
	EndSwitch
Else
	_Service_init($sServiceName)
	Exit
EndIf
#ce

; some loging func
Func logprint($text, $nolog = 0)
	If $nolog Then
		MsgBox(0, "MyService", $text, 1)
	Else
		If Not FileExists($MainLog) Then FileWriteLine($MainLog, "Log created: " & @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
		FileWriteLine($MainLog, @YEAR & @MON & @MDAY & " " & @HOUR & @MIN & @SEC & " [" & @AutoItPID & "] >> " & $text)
	EndIf
	Return 0
;~ ConsoleWrite($text & @CRLF)
EndFunc   ;==>logprint
Func InstallService()
	#RequireAdmin
	Local $bDebug = True
;~ 	If $bDebug Then ConsoleWrite("InstallService(): Installing service, please wait")
	If $cmdline[0] > 1 Then

		$sServiceName = $cmdline[2]
	EndIf
	If $bDebug Then ConsoleWrite("InstallService("&$sServiceName &"): Installing service, please wait")
	_Service_Create($sServiceName, "Au3Service " & $sServiceName, $SERVICE_WIN32_OWN_PROCESS, $SERVICE_DEMAND_START, $SERVICE_ERROR_SEVERE, '"' & @ScriptFullPath & '"')
	If @error Then

		If $bDebug Then ConsoleWrite("InstallService(): Problem installing service, Error number is " & @error & @CRLF & " message : " & _WinAPI_GetLastErrorMessage())
	Else
		If $bDebug Then ConsoleWrite("InstallService(): Installation of service successful")
	EndIf
	Exit
EndFunc   ;==>InstallService
Func RemoveService()
	_Service_Stop($sServiceName)
	_Service_Delete($sServiceName)
	If Not @error Then
;~ 		If $bDebug Then logprint("RemoveService(): service removed successfully" & @CRLF)
	EndIf
	Exit
EndFunc   ;==>RemoveService

Func _exit()
;~ 	if $bDebug  then logprint("Exiting")
	; Clean opened dll
;~ 	DllClose($hKernel32_DLL)
;~ 	DllClose($hAdvapi32_DLL)
	_Service_ReportStatus($SERVICE_STOPPED, $NO_ERROR, 0);
;~ _service_cleanup("END")

;~ _Service_Cleanup("END")
EndFunc   ;==>_exit
#cs
	...from MSDN:
	The ServiceMain function should perform the following tasks:

	Initialize all global variables.
	Call the RegisterServiceCtrlHandler function immediately to register a Handler function to handle control requests for the service. The return value of RegisterServiceCtrlHandler is a service status handle that will be used in calls to notify the SCM of the service status.
	Perform initialization. If the execution time of the initialization code is expected to be very short (less than one second), initialization can be performed directly in ServiceMain.
	If the initialization time is expected to be longer than one second, call the SetServiceStatus function, specifying the SERVICE_START_PENDING service state and a wait hint in the SERVICE_STATUS structure.

	If your service's initialization code performs tasks that are expected to take longer than the initial wait hint value, your code must call the SetServiceStatus function periodically (possibly with a revised wait hint) to indicate that progress is being made. Be sure to call SetServiceStatus only if the initialization is making progress. Otherwise, the Service Control Manager can wait for your service to enter the SERVICE_RUNNING state assuming that your service is making progress and block other services from starting. Do not call SetServiceStatus from a separate thread unless you are sure the thread performing the initialization is truly making progress.

	When initialization is complete, call SetServiceStatus to set the service state to SERVICE_RUNNING.
	Perform the service tasks, or, if there are no pending tasks, return control to the caller. Any change in the service state warrants a call to SetServiceStatus to report new status information.
	If an error occurs while the service is initializing or running, the service should call SetServiceStatus to set the service state to SERVICE_STOP_PENDING if cleanup will be lengthy. After cleanup is complete, call SetServiceStatus to set the service state to SERVICE_STOPPED from the last thread to terminate. Be sure to set the dwServiceSpecificExitCode and dwWin32ExitCode members of the SERVICE_STATUS structure to identify the error.
#ce




; emulating your program init() function
;~ Func main_init()
;~ 	$hGUI = GUICreate("Timers Using CallBack Function(s)")
;~ GUISetState($hGUI,@SW_HIDE) ; unneeded - timers run exelent without guisetstate.
;~ 	$MainLog = @ScriptDir & "\test_service.log"
;~ 	$sServiceName = "Autoit_Service"
;~ 	$Running = 1
;~ 	if $bDebug  then logprint("main_init. Stop event=" & $service_stop_event)
;~ EndFunc   ;==>main_init
; stop timer function. its said SCM that service is in the process of $SERVICE_STOP_PENDING
;~ Func myStopTimer($hWnd, $Msg, $iIDTimer, $dwTime)
;~ 	if $bDebug  then logprint("timer = " & $counter)
;~ 	_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, $counter)
;~ 	$counter += -100
;~ EndFunc   ;==>myStopTimer

Func StopTimer()
;~ 	if $bDebug  then logprint("timer = " & $counter)
	_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, $iServiceCounter)
	$iServiceCounter += -100
EndFunc   ;==>StopTimer
; emulate your program main function with while loop (may be gui loop & so on)
Func _Stopping()
	_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, 3000)
EndFunc   ;==>_Stopping
