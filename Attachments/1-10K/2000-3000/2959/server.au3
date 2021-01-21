;;This is the UDP Server
;;Start this first
HotKeySet("{F10}", "hkQuit")
UDPStartup()
$uServer = UDPBind("127.0.0.1", 65530)
MsgBox(0, "Server Socket#", $uServer)
If $uServer = -1 Then Exit

While 1
	$uText = UDPRecv($uServer, 50)
	If $uText <> "" Then
		MsgBox(0, $ScriptName, $uText, 1)
	EndIf
WEnd
Func OnAutoItStart()
	Global Const $ScriptName = "UDP Test 0.2 - Server"
	If WinExists($ScriptName) Then Exit
	AutoItWinSetTitle($ScriptName)
EndFunc
Func OnAutoItExit()
	UDPCloseSocket($uServer)
	UDPShutdown()
EndFunc
Func hkQuit()
	Exit
EndFunc