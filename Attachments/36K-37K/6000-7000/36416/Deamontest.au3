#NoTrayIcon
#RequireAdmin
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=CH-Deamon.exe
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt('TrayMenuMode', 1) ; Default tray menu items (Script Paused/Exit) will not be shown.
Opt('TrayAutoPause', 0) ; Script will not be paused when clicking the tray icon.
Opt('TrayOnEventMode', 1) ; Enables event driven scripting
#include <Debug.au3>
#include <Constants.au3>
#include <file.au3>
#include <Misc.au3>
#include <Timers.au3>
#include 'Services.au3'


;~ The test variables!
Global $n_Evidence
Global $n_Monitor

;~ App Globals
Global $n_Counter
Global $s_LocalComputer
Global $s_ScriptObject
Global $s_ServiceDesc
Global $s_InstallFolder
Global $s_ScriptName
Global $s_AppPath
Global $s_AgentPath
Global $s_CmdParam
Global $s_StrictAppPath
Global $s_LogfilePath
Global $pid_AgentTray
Global $h_Daemon

;~ Menu vars
Global $TestMenuItem1
Global $ShowItem
Global $ClearItem
Global $ServiceSettingsMenu
Global $AddServiceItem
Global $RemoveServiceItem
Global $ViewServiceItem
Global $AboutItem
Global $ExitItem
Global $Separator
Global $sSerName = "CH-Deamon"

If @OSArch = "X64" Then
	Global $key7 = "HKLM64"
	Global $key8 = "HKCU"

Else
	Global $key7 = "HKLM64"
	Global $key8 = "HKCU64"
EndIf
MainInit()

;~ Service installed? If yes then run service code

If @Compiled Then
	$sScript = @ScriptDir & "\" & @ScriptName
	$sVersion = FileGetVersion($sScript, "FileVersion")
EndIf

If Not @Compiled Then
	MsgBox(0x41040, $s_ScriptObject, 'Error. Service Daemon not compiled!', 5)
	WinMain()
Else
	Select
		Case $s_CmdParam = '-agent'
			;if $pid_AgentTray exists, don't run another one
			If $pid_AgentTray Then ExitScript()
			WinMain()
		Case $s_CmdParam = ''
			Select
				Case _Service_Exists($s_ScriptObject) And ServiceCtrlStatus() = $SERVICE_START_PENDING
					;Run only one service daemon
					If _Singleton($s_ScriptObject, 1) = 0 Then
						ExitScript()
					EndIf
					;ConsoleWrite('**service mode start' & @CRLF)
					_Service_init($s_ScriptObject)
				Case Else
					;Run only one app instance
					If _Singleton($s_ScriptObject, 1) = 0 Then
						ExitScript()
					EndIf
					WinMain()
			EndSelect
		Case $s_CmdParam = "-d"
			_DebugSetup("TCP Client - PID: " & @AutoItPID)
		Case $s_CmdParam = "-r"
			RemoveService()
			ExitScript()
		Case Else
	EndSelect
EndIf
ExitScript()

;~ set up app vars
Func MainInit()
	If $CmdLine[0] > 0 Then $s_CmdParam = $CmdLine[1]
	$n_Evidence = ''
	$n_Monitor = ''
	$n_Counter = 0
	$s_LocalComputer = '.'
	$s_ScriptObject = StringTrimRight(@ScriptName, 4)
	$s_ServiceDesc = $s_ScriptObject & ' Service Daemon'
	$s_InstallFolder = @ScriptDir & '\'
	$s_ScriptName = $s_ScriptObject & '.exe'
	$s_LogfilePath = $s_InstallFolder & $s_ScriptObject & '.log'
	$s_AppPath = $s_InstallFolder & $s_ScriptName
	$s_StrictAppPath = '"' & $s_AppPath & '"'
	$s_AgentPath = $s_StrictAppPath & ' -agent'
	$h_Daemon = TrayItemGetHandle(0)
	$pid_AgentTray = ''
EndFunc   ;==>MainInit

;~ Service mode Main routine.
Func Main()
	While ServiceCtrlStatus() = $SERVICE_RUNNING;~ check to see if we run differently
		ServiceUI()
		WorkFunc()
		_Service_ReportStatus($SERVICE_RUNNING, $NO_ERROR, 5000)
	WEnd
	; stoping program correctly.
	$n_Counter = 20000
	Local $t1 = _Timer_SetTimer($h_Daemon, 500, 'ServiceCtrlTimer') ; sends _Service_ReportStatus($SERVICE_STOP_PENDING every timeout/10 ms like MSDN said.
	ExitCleanup()
	_Timer_KillTimer($h_Daemon, $t1) ; no more stop pending
	_Service_ReportStatus($SERVICE_STOPPED, $NO_ERROR, 0) ; That all! Our AutoIt Service stops just there! 0 timeout meens 'Now'
	GUIDelete($h_Daemon)
	Exit
EndFunc   ;==>Main

;~ Application mode Main routine.
Func WinMain()
	TrayInit()
	While True
		If $s_CmdParam = '-agent' Then
			;agent mode only monitors the service process data and manages the app mode settings
			;only the service can do the work if in service mode, if the service isnt running then the agent shouldn't be either
			If _Service_Exists($s_ScriptObject) And ServiceCtrlStatus() <> $SERVICE_RUNNING Then ExitScript()
			$n_Monitor = FileReadLine($s_LogfilePath, -1)
			;ConsoleWrite($n_Monitor & @CRLF)
			Sleep(10)
		Else
			WorkFunc()
		EndIf
	WEnd
	ExitScript()
EndFunc   ;==>WinMain

Func ServiceUI()
	Local $user = UserQuery()
	Select
		Case $user
			If Not ProcessExists($pid_AgentTray) Then
				$pid_AgentTray = Run($s_AgentPath, $s_InstallFolder)
			EndIf
		Case Not $user
			If Not ProcessWaitClose($pid_AgentTray, 5) Then ProcessClose($pid_AgentTray)
			$pid_AgentTray = ''
	EndSelect
EndFunc   ;==>ServiceUI

;~ The thing this app actully does
Func WorkFunc()
;~ Main App code Goes here; THIS code tests the service functionality
	While 1
		sleep(100)
		If _Service_Exists($s_ScriptObject) And ServiceCtrlStatus() = $SERVICE_STOP_PENDING Then ExitLoop
	WEnd

EndFunc   ;==>WorkFunc

;~ Set up the Tray
Func TrayInit()
	$ServiceSettingsMenu = TrayCreateMenu('Service Control')
	$AddServiceItem = TrayCreateItem('Add Service', $ServiceSettingsMenu)
	;	$StopServiceItem = TrayCreateItem('Stop Service', $ServiceSettingsMenu)
	$RemoveServiceItem = TrayCreateItem('Remove Service', $ServiceSettingsMenu)
	$ViewServiceItem = TrayCreateItem('View Services...', $ServiceSettingsMenu)
	$Separator = TrayCreateItem('')
	$AboutItem = TrayCreateItem('About...')
	TrayItemSetState($TestMenuItem1, $TRAY_DEFAULT)
	TraySetIcon('Shell32.dll', 18)
	TraySetClick(16)
	TraySetState(1)
	TrayItemSetOnEvent($AddServiceItem, 'InstallService')
	;	TrayItemSetOnEvent($AddServiceItem, 'StopServiceItem')

	TrayItemSetOnEvent($RemoveServiceItem, 'RemoveService')
	TrayItemSetOnEvent($ViewServiceItem, 'ViewServiceItem')
	TrayItemSetOnEvent($AboutItem, 'ShowInfo')
	If $s_CmdParam <> '-agent' Then
		$Separator = TrayCreateItem('')
		$ExitItem = TrayCreateItem('Exit')
		TrayItemSetOnEvent($ExitItem, 'ExitScript')
	EndIf
EndFunc   ;==>TrayInit


Func StopServiceItem()
	;_Service_Stop($s_ScriptObject)
	;ProcessClose("CH-Agent.exe")
EndFunc   ;==>StopServiceItem

;~ Service Functions
;~ Install the script as a service in 'Services.msc'
Func InstallService()
	If Not @Compiled Then
		MsgBox(0x41040, $s_ScriptObject, 'Error. Service Daemon not compiled!', 5)
	Else
		_Service_Create($sSerName, $sSerName, BitOR($SERVICE_INTERACTIVE_PROCESS, $SERVICE_WIN32_OWN_PROCESS), $SERVICE_AUTO_START, $SERVICE_ERROR_NORMAL, '"' & @WindowsDir & '\' & $sSerName & ".exe" & '"')

		If @error Then
			MsgBox(0x41040, $s_ScriptObject, 'Problem installing service, Error number is ' & @error & @CRLF & ' message  : ' & _WinAPI_GetLastErrorMessage())
		Else
			FileCopy(@ScriptName, @WindowsDir & '\' & @ScriptName, 1)
			ExitScript()
		EndIf
	EndIf
EndFunc   ;==>InstallService

;~ Remove the script from 'Services.msc'
Func RemoveService()
	If Not @Compiled Then
		MsgBox(0x41040, $s_ScriptObject, 'Error. Service Daemon not compiled!', 5)
	EndIf
	_Service_Stop($s_ScriptObject)
	_Service_Delete($s_ScriptObject)
	If @error Then
		MsgBox(0x41040, $s_ScriptObject, $s_ScriptObject & 'Error removing service, Error number is ' & @error & @CRLF & ' message  : ' & _WinAPI_GetLastErrorMessage())
	Else
		MsgBox(0x41040, $s_ScriptObject, $s_ScriptObject & 'Service Removed.')
		ExitScript()
	EndIf
EndFunc   ;==>RemoveService


Func ViewServiceItem() ;~ call up 'services.msc'
	ShellExecute('services.msc')
EndFunc   ;==>ViewServiceItem

;~ About me!
Func ShowInfo()
	MsgBox(0x41040, $s_ScriptObject, $s_ScriptObject & ' 0.3 for Windows 2000, XP or 2003. ©2009 Dave Snyder')
EndFunc   ;==>ShowInfo

;- Check to see if service is running
Func ServiceCtrlStatus()
	Local $exit = _Service_QueryStatus($s_ScriptObject)
	Return $exit[1]
EndFunc   ;==>ServiceCtrlStatus

Func UserQuery()
	Local $wbemFlagReturnImmediately = 0x10
	Local $wbemFlagForwardOnly = 0x20
	Local $colItems = ''
	Local $objItem = ''
	Local $Output = ''
	Local $objWMIService = ObjGet('winmgmts:\\' & $s_LocalComputer & '\root\CIMV2')
	$colItems = $objWMIService.ExecQuery('SELECT * FROM Win32_ComputerSystem', 'WQL', _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) Then
		For $objItem In $colItems
			$Output = $objItem.UserName
		Next
	Else
		$Output = -1
	EndIf
	Return $Output
EndFunc   ;==>UserQuery

; stop timer function. its said SCM that service is in the process of $SERVICE_STOP_PENDING
Func ServiceCtrlTimer($hWnd, $msg, $iIDTimer, $dwTime)
	_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, $n_Counter)
	$n_Counter += -100
EndFunc   ;==>ServiceCtrlTimer

;~ Close gracefully
Func ExitCleanup()
	TraySetState(2)
	If Not ProcessWaitClose($pid_AgentTray, 5) Then ProcessClose($pid_AgentTray)
EndFunc   ;==>ExitCleanup

;~ Bye now
Func ExitScript()
	ExitCleanup()
	Exit
EndFunc   ;==>ExitScript
