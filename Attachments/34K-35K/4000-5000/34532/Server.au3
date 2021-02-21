#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

TCPStartup()

$TCPListen = TCPListen(@IPAddress1, 403)

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Server", 121, 81)
$Label1 = GUICtrlCreateLabel("Data Recieved:", 0, 0, 79, 17)
$Label2 = GUICtrlCreateLabel("", 0, 16, 116, 57)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Do
	$TCPAccept = TCPAccept($TCPListen)
Until $TCPAccept <> -1

Do
	$TCPRecive = TCPRecv($TCPAccept, 1000000)
Until $TCPRecive <> ""

GUICtrlSetData($Label2, $TCPRecive)



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

