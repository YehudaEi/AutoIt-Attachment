HotKeySet("{F6}", "close")

Func close()
	Exit
EndFunc



; TCP-Options
; =================
Global $ip_admin = "192.168.0.55"								
Global $port = 33890											


; TCP-Functions
; ==============
TCPStartup()
$Socket = TCPConnect($ip_admin, $port)
If $Socket = -1 Then
	MsgBox(16, "Mistake", "No connection to server!")
	Exit
EndIf

; => send Client Data
Dim $client_data = "test|gesperrt|"&@IPAddress1&"|"&@ComputerName&"|ja"
$send = TCPSend($Socket, "-DATA-"&$client_data)
; ==>


While 1
	$receive = TCPRecv($Socket, 512)
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
	
	If StringLeft($receive, 9) = "-MESSAGE-" Then				; Client Message
		$message = StringTrimLeft($receive, 9)
		MsgBox(0, "Message from Admin", $message)
	EndIf
	If StringLeft($receive, 9) = "-AUTO~ON-" Then
		MsgBox(0, "works", "AUTO ON")							
	EndIf
	If StringLeft($receive, 10) = "-AUTO~OFF-" Then
		MsgBox(0, "works", "AUTO OFF")							
	EndIf
	If @error <> 0 Then ExitLoop
WEnd


Func OnAutoItExit()
	; close TCP-Socket, TCP-Service
	TCPSend($Socket, "-CLOSE-")
	TCPCloseSocket($Socket)
	TCPShutdown()
EndFunc ; ==>