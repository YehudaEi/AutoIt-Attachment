Local $TCPMainSocket
HotKeySet("{NUMPADADD}", "_action")
HotKeySet("{NUMPADSUB}", "_mouse")

TCPStartup()

$TCPListenSocket = TCPListen(@IPAddress1, 1081)

While 1
    $TCPMainSocket = TCPAccept($TCPListenSocket)
    If $TCPMainSocket >= 0 Then
        ExitLoop
    EndIf
WEnd

While 1
    $TCPRecv = TCPRecv($TCPMainSocket, 2048)
    If $TCPRecv <> "" Then
        ConsoleWrite($TCPRecv & @CRLF)
    EndIf
WEnd

Func _action()
    If $TCPMainSocket >= 0 Then
		TCPSend($TCPMainSocket, "action")
    EndIf
EndFunc


;thing Im focussing on
Func _mouse()
    If $TCPMainSocket >= 0 Then
		TCPSend($TCPMainSocket, "controlmouse")
    EndIf
EndFunc
;Thing Im focussing on