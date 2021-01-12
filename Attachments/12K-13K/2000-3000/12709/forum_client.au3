; Client
;Opt("TrayMenuMode", 1)								; No Paused/Stopped Tray
HotKeySet("{F6}", "close")

Func close()
	Exit
EndFunc



; TCP-Prefences
; =================
Global $ip_admin = "192.168.0.55"								
Global $port = 33890											


; TCP-Functions
; ==============
TCPStartup()
$MainSocket = TCPConnect($ip_admin, $port)
If $MainSocket = -1 Then
	MsgBox(16, "Mistake", "No connection!")
	Exit
EndIf

; => send Client Data
Dim $client_data = "Papa|gesperrt|"&@IPAddress1&"|"&@ComputerName&"|nein"
$send = TCPSend($MainSocket, "-DATA-"&$client_data)
; ==>


While 1
	$receive = TCPRecv($MainSocket, 512)
	Switch $receive
		Case "-LOCK-"
			MsgBox(0, "works", "LOCK")							
		Case "-UNLOCK-"
			MsgBox(0, "works", "UNLOCK")						
		Case "-RESTART-"
			MsgBox(0, "works", "RESTART")						
		Case "-SHUTDOWN-"
			MsgBox(0, "works", "SHUTDOWN")						
		Case "-DELETE-"
			MsgBox(0, "works", "DELETE")						
	EndSwitch
	
	If StringLeft($receive, 9) = "-MESSAGE-" Then				; Client message
		$message = StringTrimLeft($receive, 9)
		MsgBox(0, "Message from admin", $message)
	EndIf
	If StringLeft($receive, 9) = "-AUTO~ON-" Then
		MsgBox(0, "works", "AUTO ON")							
	EndIf
	If StringLeft($receive, 10) = "-AUTO~OFF-" Then
		MsgBox(0, "works", "AUTO OFF")							
	EndIf
WEnd


Func OnAutoItExit()
	; ???????
	; ???????
	; show logoff to Admin ???????????
	; ???????
	; ??????? Please HELP
	TCPSend($MainSocket, "-CLOSE-")
	TCPCloseSocket($MainSocket)
	TCPShutdown()
EndFunc ; ==>