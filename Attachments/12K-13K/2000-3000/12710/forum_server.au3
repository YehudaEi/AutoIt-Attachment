; TCP-Prefences
; =================
Global $ip = @IPAddress1
Global $port = IniRead(@DesktopDir&"\database.ini", "Daten", "port", "--->Fehler<---")
Global $MaxConc = 100								; max clients
Global Const $MaxLength = 512						; max data-length

Global $MainSocket = TCPStartServer($port, $MaxConc)
If @error <> 0 Then
	MsgBox(16, "TCP-Mistake", "Program closes!")
	Exit
EndIf
Global $ConnectedSocket[$MaxConc]
Global $CurrentSocket = 0
Local $track = 0
Global Const $MaxConnection = ($MaxConc - 1)

; TCP-Functions
; ==============
For $track = 0 To $MaxConnection Step 1
	$ConnectedSocket[$track] = -1
Next

While 1
	$ConnectedSocket[$CurrentSocket] = TCPAccept($MainSocket)
	If $ConnectedSocket[$CurrentSocket] <> -1 Then
		$CurrentSocket = SocketSearch()
	EndIf
	$track = 0
	For $track = 0 To $MaxConnection Step 1
		; => get
		If $ConnectedSocket[$track] <> -1 Then
			$data = TCPRecv($ConnectedSocket[$track], $MaxLength)
			If $data <> "" And $data <> "-CLOSE-" Then
				; Data - ListView
				If StringLeft($data, 6) = "-DATA-" Then
					Dim $client_data = StringTrimLeft($data, 6)
					GUICtrlCreateListViewItem($client_data, $list)
				EndIf
			ElseIf @error Or $data = "-CLOSE-" Then
				TCPCloseSocket($ConnectedSocket[$track])
				$ConnectedSocket[$track] = -1
				$CurrentSocket = SocketSearch()
				; ?????????
				; ?????????
				; delete old client in list view?????
				; ?????????
				; ????????? Please HELP
			EndIf
		EndIf
	Next
WEnd

Func SocketSearch()
	Local $track = 0
	For $track = 0 To $MaxConnection Step 1
		If $ConnectedSocket[$track] = -1 Then
			Return $track
		Else
			; Socket is ok!
		EndIf
	Next
EndFunc

Func TCPStartServer($port, $MaxConnect = 1)
	Local $socket
	$socket = TCPStartup()
	Select
		Case $socket = 0
			SetError(@error)
			Return -1
	EndSelect
	$socket = TCPListen($ip, $port, $MaxConnect)
	Select
		Case $socket = -1
			SetError(@error)
			Return 0
	EndSelect
	SetError(0)
	Return $socket
EndFunc

Func Netzwerk()
	; => send
	Local $track = 0
	For $track = 0 To $MaxConnection Step 1
		If $ConnectedSocket[$track] <> -1 Then
			Select
				Case @GUI_CtrlId = $lock_client
					$send = TCPSend($ConnectedSocket[$track], "-LOCK-")				; Client lock
				Case @GUI_CtrlId = $unlock_client
					$send = TCPSend($ConnectedSocket[$track], "-UNLOCK-")			; Client unlock
				Case @GUI_CtrlId = $restart_client
					$send = TCPSend($ConnectedSocket[$track], "-RESTART-")			; Client restart
				Case @GUI_CtrlId = $shutdown_client
					$send = TCPSend($ConnectedSocket[$track], "-SHUTDOWN-")			; Client shutdown
				Case @GUI_CtrlId = $message_client
					$message = InputBox("Send a message ...", "Message:", "", "", 300, 125)
					$send = TCPSend($ConnectedSocket[$track], "-MESSAGE-"&$message)	; Client message
				Case @GUI_CtrlId = $save_autostart
					load_pw()
					$save_autostart_pw = InputBox("Security", "Type in admin-pw!", "", "*M", 250, 140)
					If $save_autostart_pw == $passwort Then
						If GUICtrlRead($autostart) = $GUI_CHECKED Then
							$send = TCPSend($ConnectedSocket[$track], "-AUTO~ON-")	; Client-Autostart ON
						ElseIf GUICtrlRead($autostart) = $GUI_UNCHECKED Then
							$send = TCPSend($ConnectedSocket[$track], "-AUTO~OFF-")	; Client-Autostart OFF
						EndIf
					Else
						MsgBox(16, "Mistake", "Password wrong!")
					EndIf
				Case @GUI_CtrlId = $deinstall_client
					Dim $delete_question
					$delete_question = MsgBox(308,"Client deinstall", "Delete client "&GUICtrlRead($client)&" ?")
					Select
						Case $delete_question = 6 	; Yes
							load_pw()
							$delete_pw = InputBox("Security", "Type in admin-pw!", "", "*M", 250, 140)
							If $delete_pw == $passwort Then
								$send = TCPSend($ConnectedSocket[$track], "-DELETE-") ; Client deinstall
							Else
								MsgBox(16, "Mistake", "Password wrong!")
							EndIf
						Case $delete_question = 7 	; No
							; do nothing!
					EndSelect
			EndSelect
		EndIf
	Next
EndFunc

Func OnAutoItExit()
	; close TCP-Socket, TCP-Service
	Local $MainSocket
	TCPCloseSocket($MainSocket)
	TCPShutdown()
EndFunc ; ==>