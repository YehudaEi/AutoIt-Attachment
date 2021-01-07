HotKeySet("{ESC}", "ENDKK")
MsgBox(0, "Start Client", "Press Escape to Quit")
TCPStartup()
$Socket = TCPListen("127.0.0.1", 1234, 100)
If $Socket = -1 Then
	MsgBox(0, "Error", "Could not connect to the client!")
Else
	$ConnectedSocket = TCPAccept($Socket)
	If $Socket = -1 Then 
		MsgBox(0, "Error", "Couldn't connect to server!")
		EndKK()
	EndIf
	MsgBox(0, "Success", "Successfully connected to server!")
EndIf
EndKK()

Func ENDKK()
	TCPCloseSocket($Socket)
	TCPShutdown()
	Exit
EndFunc

