#include <_Service.au3>
#NoTrayIcon
#RequireAdmin
#AutoIt3Wrapper_Change2CUI=y
If Not @Compiled Then Exit
If Not _Singleton(@ScriptName) Then 
	If $cmdline[0] > 0 Then
		If $cmdline[1] = "stop" or StringRight($cmdline[1],1) = "s" Then
		
		Else
			ConsoleWrite("Process is running.")
			Exit
		EndIf
	Else
		ConsoleWrite("Process is running.")
		Exit
	EndIf
EndIf

$Servicename = StringLeft(@ScriptName,StringInstr(@ScriptName,".")-1)
$sServiceName = "AutoIt_Service_" & $Servicename
If $cmdline[0] > 0 Then
	Switch $cmdline[1]
		Case "install", "-i", "/i"
			InstallService()
		Case "remove", "-u", "/u", "uninstall"
			RemoveService()
		Case "run", "-r", "/r", "start"
			_SelfRun($sServiceName,"start")
		Case "stop", "-s", "/s"
			_SelfRun($sServiceName,"stop")
		Case Else
			ConsoleWrite(" - - - Help - - - " & @crlf)
			ConsoleWrite(" Service Example Params : " & @crlf)
			ConsoleWrite("  -i : Installs service" & @crlf)
			ConsoleWrite("  -u : Removes service" & @crlf)
			ConsoleWrite("  -r : Runs the service" & @crlf)
			ConsoleWrite("  -s : Stops the service" & @crlf)
			ConsoleWrite(" - - - - - - - - " & @crlf)
			Exit
			;start service.
	EndSwitch
	_Service_Init($sServiceName)
Else	
	If Not _ServiceExists("", $sServiceName) Then 
		If Msgbox(20,"Service Not Installed.","Would you like to install this service?" & @CRLF & $sServiceName) = 6 Then
			If InstallService() Then 
				If Msgbox(4,$sServiceName,"Service Installed Successfully." & @CRLF & "Do you wish to start the process?") = 6 Then _SelfRun($sServiceName,"start")
			EndIf
		Else
			Exit
		EndIf
	Else
		_Service_Init($sServiceName)
	EndIf
EndIf

Func _Main()
	While 1
		;Service Code Loop
		sleep(10)
	WEnd
EndFunc   ;==>main

Func InstallService()
	ConsoleWrite("Installing Service, Please Wait" & @CRLF)
	_CreateService("", $sServiceName, $Servicename, '"' & @ScriptFullPath & '"')
	If @error Then
		ConsoleWrite("Problem Installing Service, Error number is " & @error & @CRLF & " message  : " & _WinAPI_GetLastErrorMessage())
		Return 0
	Else
		ConsoleWrite("Installation of Service Successful")
	EndIf
	Return 1
	Exit
EndFunc   ;==>InstallService

Func RemoveService()
	_StopService("", $sServiceName)
	_DeleteService("", $sServiceName)
	if not @error then ConsoleWrite("Service Removed Successfully" & @crlf)
	Exit
EndFunc   ;==>RemoveService

Func _SelfRun($servicename,$action)
    $sCmdFile = 'sc ' & $action & ' "' & $servicename & '"' & @CRLF & 'del ' & @TempDir & '\runsvc.bat'
    FileWrite(@TempDir & "\runsvc.bat", $sCmdFile)
    Run(@TempDir & "\runsvc.bat", @TempDir, @SW_HIDE)
	Exit
EndFunc