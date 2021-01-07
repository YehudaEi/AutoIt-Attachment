HotKeySet("{ESC}", "ENDKK")
MsgBox(0, "Start Server", "Press Escape to Quit")
TCPStartup()
While(1)
	$Socket = TCPConnect("127.0.0.1", 1234)
	If $Socket > -1 Then
		ExitLoop
	EndIf
WEnd
MsgBox(0, "Successfully connected to client!", "YAY!")
ENDKK()

Func ENDKK()
	TCPCloseSocket($Socket)
	TCPShutdown()
	Exit
EndFunc
