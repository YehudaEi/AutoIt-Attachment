;;This is the UDP Client
;;Start the server first
#include<date.au3>
HotKeySet("{F9}", "hkQuit")
UDPStartup()
$uClient = UDPOpen("127.0.0.1", 65530)
MsgBox(0, "Client Socket#", $uClient)
If $uClient = -1 Then Exit

While 1
	Sleep(1000*3)
	$uStatus = UDPSend($uClient, _NowCalc(), "127.0.0.1", 65530)
	If $uStatus = 0 Then
		MsgBox(0, $ScriptName, "Error occured when sending UDP message" & @CRLF & @Error)
		Exit
	EndIf
WEnd
Func OnAutoItStart()
	Global Const $ScriptName = "UDP Test 0.2 - Client"
	If WinExists($ScriptName) Then Exit
	AutoItWinSetTitle($ScriptName)
EndFunc
Func OnAutoItExit()
	UDPCloseSocket($uClient)
	UDPShutdown()
EndFunc
Func hkQuit()
	Exit
EndFunc