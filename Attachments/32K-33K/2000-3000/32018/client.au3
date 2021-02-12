Local $TCPMainSocket
Local $ServerIP = "192.168.10.146"
Local $ServerUp = False

TCPStartup()

Do
	Sleep(100)
	$TCPMainSocket = TCPConnect($ServerIP, 1081)
	If $TCPMainSocket = -1 Then
	Else
		$ServerIp = True
	EndIf
Until $ServerIp = True

While 1
    $TCPRecv = TCPRecv($TCPMainSocket, 2048)
    If $TCPRecv <> "" Then
		ConsoleWrite($TCPRecv & @CRLF)
        _CheckFunc($TCPRecv)
    EndIf
WEnd

Func _CheckFunc($tFunc)
	If $tFunc = "action" Then
		;action
	EndIf

	;Thing Im focusssing on
	If $tFunc = "controlmouse" Then
		;code to control the mouse
	EndIf
	;Thing Im focussing on
EndFunc