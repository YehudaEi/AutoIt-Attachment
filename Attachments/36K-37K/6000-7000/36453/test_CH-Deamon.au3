#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\CH-Agent\logo.ico
#AutoIt3Wrapper_Outfile=CH-Deamon.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "Services.au3"
#include <Misc.au3>
#include <Debug.au3>

If @OSArch = "X64" Then
	Global $key7 = "HKLM64"
	Global $key8 = "HKCU64"

Else
	Global $key7 = "HKLM"
	Global $key8 = "HKCU"
EndIf

If @Compiled Then
	$sScript = @ScriptDir & "\" & @ScriptName
	$sVersion = FileGetVersion($sScript, "FileVersion")
EndIf
$sServiceName = "CH-Deamon"

;If Not @Compiled Then Exit
If $cmdline[0] > 0 Then
	Switch $cmdline[1]
		Case "-i"
			InstallService()
			_SelfRun($sServiceName, "start")
		Case "-r"
			RemoveService($sServiceName)
			_SelfRun($sServiceName, "stop")
			ProcessClose("CH-Agent.exe")
		Case "-d"
			_DebugSetup("TCP Client - PID: " & @AutoItPID)
			InstallService()
			_SelfRun($sServiceName, "start")
		Case Else
	EndSwitch
	_Service_Init($sServiceName)
Else
	_Service_Init($sServiceName)
EndIf

Func Main()
	While 1
		;Service Code Loop
		Local $pid = ProcessExists("CH-Agent.exe")
		If $pid Then
		Else
;			ShellExecute("CH-Agent.exe", " ", @WindowsDir)
		EndIf
		Sleep(10)
	WEnd

EndFunc   ;==>Main
ProcessClose("CH-Agent.exe")
Exit

Func InstallService()
	_DebugOut("Installing Service, Please Wait" & @CRLF)
;   _Service_Create($sServiceName, $sDisplayName, $iServiceType, $iStartType, $iErrorControl, $sBinaryPath [, $sLoadOrderGroup, $fTagId, $vDependencies, $sServiceUser, $sPassword, $sComputerName])
;	_Service_Create($sServiceName, $sServiceName, BitOR($SERVICE_INTERACTIVE_PROCESS,$SERVICE_WIN32_OWN_PROCESS), $SERVICE_AUTO_START, $SERVICE_ERROR_SEVERE, '"' & @WindowsDir & "\" & $sServiceName & ".exe" &  '"')
	_Service_Create($sServiceName, $sServiceName, BitOR($SERVICE_INTERACTIVE_PROCESS, $SERVICE_WIN32_OWN_PROCESS), $SERVICE_AUTO_START, $SERVICE_ERROR_SEVERE, '"' & @WindowsDir & '\' & @ScriptName & '"',"Tcpip")
;	_Service_Create($sServiceName, $sServiceName, BitOR($SERVICE_INTERACTIVE_PROCESS, $SERVICE_WIN32_OWN_PROCESS), $SERVICE_AUTO_START, $SERVICE_ERROR_NORMAL, '"' & @WindowsDir & '\' & @ScriptName & '"',"","","","",StringStripCR("Tcpip"))
;	_Service_Create($sServiceName, $sServiceName, $SERVICE_WIN32_SHARE_PROCESS, $SERVICE_AUTO_START, $SERVICE_ERROR_SEVERE, '"' & @WindowsDir & "\" & $sServiceName & ".exe" & '"')
	If @error Then
		_DebugOut("Problem Installing Service, Error number is " & @error & @CRLF & " message  : " & _WinAPI_GetLastErrorMessage())
		Return 0
	Else
		;			Local $RemoteServer = "192.168.58.17"
		Local $RemoteServer = "ref01.chargeclient.net"
		RegWrite($key7 & "\SOFTWARE\Charge\ChargeDeamon", "RemoteServer", "REG_SZ", $RemoteServer)
		RegWrite($key7 & "\SOFTWARE\Charge\ChargeDeamon", "RemoteServerPort", "REG_SZ", "8083")
		_DebugOut("Writing Regkeys...")

	;	ProcessClose("CH-Menu.exe")
	;	ProcessClose("CH-Agent.exe")
		_DebugOut("Terminating Processes..")
	;	FileDelete(@WindowsDir & "\CH-Menu.exe")
	;	FileDelete(@WindowsDir & "\CH-Agent.exe")
		_DebugOut("Deleteing files...")

	;	FileInstall("Connect.exe", @WindowsDir & "\Connect.exe", 1)
		_DebugOut("Installing files...")
	;	FileInstall("support.cer", @WindowsDir & "\support.cer", 1)
		_DebugOut("Installing files...")
	;	FileInstall("CertMgr.Exe", @WindowsDir & "\CertMgr.Exe", 1)
		_DebugOut("Installing files...")
	;	FileInstall("CH-Agent.exe", @WindowsDir & "\CH-Agent.exe", 1)
		_DebugOut("Installing files...")
	;	FileInstall("CH-Menu.exe", @WindowsDir & "\CH-Menu.exe", 1)
		_DebugOut("Installing files...")
	;	ShellExecute("certmgr.exe", ' -add -all support.cer -s -r localMachine root', @WindowsDir, "open", @SW_MINIMIZE)
		_DebugOut("Executing files...")
	   ;  ShellExecute("netsh.exe", ' firewall add allowedprogram program=' & @WindowsDir & '\CH-Agent.exe name="Support Charge"', @WindowsDir, "open", @SW_MINIMIZE)
		_DebugOut("Executing files...")
		FileCopy(@ScriptName, @WindowsDir & '\' & @ScriptName, 1)
		_DebugOut("Copying file..." & @ScriptName)
		_DebugOut("Installation of Service Successful")
	EndIf
	Return 1
EndFunc   ;==>InstallService

Func RemoveService($servicename)
	_Service_Delete($sServiceName)
	If Not @error Then
		_DebugOut("Service Removed Successfully")
	Else
		_DebugOut("Failed deleting service")
	EndIf

	Exit
EndFunc   ;==>RemoveService


Func _SelfRun($servicename, $action)
	$sCmdFile = 'sc ' & $action & ' "' & $servicename & '"'
	Run($sCmdFile, @TempDir, @SW_HIDE)
	_DebugOut($action & " "&$servicename)
	Exit
EndFunc   ;==>_SelfRun

