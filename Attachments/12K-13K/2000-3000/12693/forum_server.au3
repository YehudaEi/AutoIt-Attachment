; TCP-Options
; =================
Global $ip = @IPAddress1
Global $MainSocket, $ConnectedSocket = -1
Global $port = IniRead(@DesktopDir&"\database.ini", "Data", "port", "--->Mistake<---")

; TCP-Functions
; ==============
TCPStartup()
$MainSocket = TCPListen($ip, $port, 100)
If $MainSocket = -1 Then
	MsgBox(16, "TCP-Problem", "Program closes!")
	Exit
EndIf
Global $ListenSocket = -1

Func Netzwerk()
	; => send TCP-Befehle
	Select
		Case @GUI_CtrlId = $lock_client
			If $ConnectedSocket > -1 Then
				$send = TCPSend($ConnectedSocket, "-LOCK-")				; Client LOCK
				If @error Then
					TCPCloseSocket($ConnectedSocket)
					$ConnectedSocket = -1
				EndIf
			EndIf
		Case @GUI_CtrlId = $unlock_client
			If $ConnectedSocket > -1 Then
				$send = TCPSend($ConnectedSocket, "-UNLOCK-")			; Client UNLOCK
				If @error Then
					TCPCloseSocket($ConnectedSocket)
					$ConnectedSocket = -1
				EndIf
			EndIf
		Case @GUI_CtrlId = $restart_client
			If $ConnectedSocket > -1 Then
				$send = TCPSend($ConnectedSocket, "-RESTART-")			; Client RESTART
				If @error Then
					TCPCloseSocket($ConnectedSocket)
					$ConnectedSocket = -1
				EndIf
			EndIf
		Case @GUI_CtrlId = $shutdown_client
			If $ConnectedSocket > -1 Then
				$send = TCPSend($ConnectedSocket, "-SHUTDOWN-")			; Client OFF
				If @error Then
					TCPCloseSocket($ConnectedSocket)
					$ConnectedSocket = -1
				EndIf
			EndIf
		Case @GUI_CtrlId = $message_client
			$message = InputBox("Send Message ...", "Message:", "", "", 300, 125)
			If $ConnectedSocket > -1 Then
				$send = TCPSend($ConnectedSocket, "-MESSAGE-"&$message)	; Client Message
				If @error Then
					TCPCloseSocket($ConnectedSocket)
					$ConnectedSocket = -1
				EndIf
			EndIf
		Case @GUI_CtrlId = $save_autostart
			load_pw()
			$save_autostart_pw = InputBox("Security", "Type in AdminPW!", "", "*M", 250, 140)
			If $save_autostart_pw == $passwort Then
				If $ConnectedSocket > -1 Then
					If GUICtrlRead($autostart) = $GUI_CHECKED Then
						$send = TCPSend($ConnectedSocket, "-AUTO~ON-")	; Client-Autostart ON
						If @error Then
							TCPCloseSocket($ConnectedSocket)
							$ConnectedSocket = -1
						EndIf
					ElseIf GUICtrlRead($autostart) = $GUI_UNCHECKED Then
						$send = TCPSend($ConnectedSocket, "-AUTO~OFF-")	; Client-Autostart OFF
						If @error Then
							TCPCloseSocket($ConnectedSocket)
							$ConnectedSocket = -1
						EndIf
					EndIf
				EndIf
			Else
				MsgBox(16, "Mistake", "Password wrong!")
			EndIf
		Case @GUI_CtrlId = $deinstall_client
			Dim $delete_question
			$delete_question = MsgBox(308,"Client deinstall", "Really deinstall "&GUICtrlRead($client)&" ?")
			Select
				Case $delete_question = 6 	; Yes
					load_pw()
					$delete_pw = InputBox("Security", "Type in AdminPW!", "", "*M", 250, 140)
					If $delete_pw == $passwort Then
						If $ConnectedSocket > -1 Then
							$send = TCPSend($ConnectedSocket, "-DELETE-") ; Client deinstall
							If @error Then
								TCPCloseSocket($ConnectedSocket)
								$ConnectedSocket = -1
							EndIf
						EndIf
					Else
						MsgBox(16, "Mistake", "Password wrong!")
					EndIf
				Case $delete_question = 7 	; No
					; do nothing!
			EndSelect
	EndSelect
EndFunc

While 1
	If $ListenSocket > 0 Then
		$receive = TCPRecv($ListenSocket, 512)
		If Not @error Then
			TCPCloseSocket($ListenSocket)
			$ListenSocket = -1
		EndIf
	EndIf
	
	; => TCP-Connection search
	If $ConnectedSocket = -1 Then
		$ConnectedSocket = TCPAccept($MainSocket)
	Else
		$receive = TCPRecv($ConnectedSocket, 512)
		If $receive <> "" And $receive <> "-CLOSE-" Then
			; Data for ListView
			If StringLeft($receive, 6) = "-DATA-" Then
				Dim $client_data = StringTrimLeft($receive, 6)
				GUICtrlCreateListViewItem($client_data, $list)
			EndIf
		ElseIf @error Or $receive = "-CLOSE-" Then
			; delete old!
			TCPCloseSocket($ConnectedSocket)
			$ConnectedSocket = -1
		EndIf
	EndIf
WEnd

Func OnAutoItExit()
	; close TCP-Socket, TCP-Service
	Local $ListenSocket
	Local $MainSocket
	If $ListenSocket > -1 Then
		TCPSend($ListenSocket, "-CLOSE-")
		Sleep(2000)
		TCPRecv($ListenSocket, 512)
		TCPCloseSocket($ListenSocket)
	EndIf
	TCPCloseSocket($MainSocket)
	TCPShutdown()
EndFunc ; ==>
