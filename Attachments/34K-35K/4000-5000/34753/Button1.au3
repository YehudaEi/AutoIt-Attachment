#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

TCPStartup()
$TCPConnect = TCPConnect(@IPAddress1, 5000)

$Form1 = GUICreate("Test", 105, 37, 192, 114)
$Button1 = GUICtrlCreateButton("Click Me!", 8, 8, 83, 17)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			TCPSend($TCPConnect, "channel1"&@crlf&"freq="&@crlf&"9.426686e+010"&@crlf&"1.923659e+010"&@crlf&"1.190006e+010"&@crlf&"1.557381e+010"&@crlf&"channel2"&@crlf&"freq="&@crlf&"1.300763e+011"&@crlf&"2.108867e+009")
	EndSwitch
WEnd
