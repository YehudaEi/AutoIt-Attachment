#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=WDC.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "TCP.au3"
#Include <Constants.au3>
     
Global $IP
Global $hClient
Global $hSocket
Global $Paused
Global $delay
Global $CameraSource
Global $trayShutdown
Global $Conn3ct3d

$IP = IniRead (@ScriptDir&"\settings.ini", "IP", "IP", "none")
$Conn3ct3d = 0
	
Opt ("TrayMenuMode", 1)
$trayShutdown = TrayCreateItem("Shutdown")
$trayStartPause = TraycreateItem("Start")
TrayCreateItem ("")
$trayIP = TrayCreateItem ("IP")
$trayCameraDesktop = TraycreateItem("Desktop")
TrayCreateItem ("")
$trayDelay5 = TrayCreateItem("Delay 5")
$trayDelay3 = TrayCreateItem("Delay 3")
TrayItemSetState($trayDelay3,$TRAY_CHECKED)
$trayDelay1 = TrayCreateItem("Delay 1")
TrayCreateItem ("")
$trayExit = TrayCreateItem ("Exit")
TraySetIcon("Shell32.dll",240)

$Paused = 1
$CameraSource = 1
$delay = 3

$hClient = _TCP_Client_Create($IP, 88)

_TCP_RegisterEvent($hClient, $TCP_RECEIVE, "Received")
_TCP_RegisterEvent($hClient, $TCP_CONNECT, "Connected")
_TCP_RegisterEvent($hClient, $TCP_DISCONNECT, "Disconnected")

While 1
	Sleep(100)
	If $Paused Then
		TrayItemSetText($trayStartPause, "Start")
	Else
		TrayItemSetText($trayStartPause, "Pause")
	EndIf
	If $CameraSource Then
		TrayItemSetText($trayCameraDesktop, "Desktop")
	Else
		TrayItemSetText($trayCameraDesktop, "Webcam")
	EndIf
	$tray = TrayGetMsg ()
	If $tray = $trayIP Then
		$newip = InputBox ("IP", "Please input a new IP", $IP, "", 190, 115)
		If Not @error Then
			IniDelete (@ScriptDir&"\settings.ini", "IP")
			IniWrite (@Scriptdir&"\settings.ini", "IP", "IP", $newip)
			Run (@ScriptFullPath)
			Exit
		EndIf
	ElseIf $tray = $trayStartPause Then
		If $Paused Then
			_TCP_Send($hSocket, "/GO " & $delay); Sending to the server.
			$Paused = 0
			TraySetIcon("Shell32.dll",246)
		Else
			_TCP_Send($hSocket, "/PAUSE")
			$Paused = 1
			TraySetIcon("Shell32.dll",255)
		EndIf
	ElseIf $tray = $trayShutdown Then
		If $Conn3ct3d Then
			_TCP_Send($hSocket, "/SHUTDOWN"); Sending to the server.
		EndIf
	ElseIf $tray = $trayCameraDesktop Then
		If $CameraSource Then
			$CameraSource = 0
			_TCP_Send($hSocket, "/SOURCE " & $CameraSource); Sending to the server.
		Else
			$CameraSource = 1
			_TCP_Send($hSocket, "/SOURCE " & $CameraSource); Sending to the server.
		EndIf
		ConsoleWrite("Source: " & $CameraSource & @CRLF)
	Elseif $tray = $trayDelay5 Then
		TrayItemSetState($trayDelay5,$TRAY_CHECKED)
		TrayItemSetState($trayDelay3,$TRAY_UNCHECKED)
		TrayItemSetState($trayDelay1,$TRAY_UNCHECKED)
		$delay = 5
		If Not $Paused Then _TCP_Send($hSocket, "/GO " & $delay); Sending to the server.
	ElseIf $tray = $trayDelay3 Then
		TrayItemSetState($trayDelay3,$TRAY_CHECKED)
		TrayItemSetState($trayDelay5,$TRAY_UNCHECKED)
		TrayItemSetState($trayDelay1,$TRAY_UNCHECKED)
		$delay = 3
		If Not $Paused Then _TCP_Send($hSocket, "/GO " & $delay); Sending to the server.
	ElseIf $tray = $trayDelay1 Then
		TrayItemSetState($trayDelay1,$TRAY_CHECKED)
		TrayItemSetState($trayDelay5,$TRAY_UNCHECKED)
		TrayItemSetState($trayDelay3,$TRAY_UNCHECKED)
		$delay = 1
		If Not $Paused Then _TCP_Send($hSocket, "/GO " & $delay); Sending to the server.
	ElseIf $tray = $trayExit Then
		Exit
	EndIf
WEnd
     
Func Connected($hSocket, $iError)
	If not $iError Then; If there is no error...
		TraySetIcon("Shell32.dll",255)
		$Conn3ct3d = 1
	Else; ,else...
		TraySetIcon("Shell32.dll",240)
		$Conn3ct3d = 0
	EndIf
EndFunc
     
     
Func Received($hSocket, $sReceived, $iError)
;~     ToolTip("CLIENT: We received this: "& $sReceived, 10,10); (and we'll display it)
EndFunc
     
Func Disconnected($hSocket, $iError)
	For $i = 1 To 6
		If Mod($i, 2) = 0 Then
			TraySetIcon("Shell32.dll",240)
		Else
			TraySetIcon("Shell32.dll",255)
		EndIf
		Sleep(300)
	Next
	
	$Conn3ct3d = 1
EndFunc