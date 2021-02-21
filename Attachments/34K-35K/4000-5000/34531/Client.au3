#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

TCPStartup()
$TCPConnect = TCPConnect(@IPAddress1, 403)
If $TCPConnect = -1 Then Exit

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Client", 111, 97, -1, -1)
$Input1 = GUICtrlCreateInput("", 8, 40, 89, 21)
$Button1 = GUICtrlCreateButton("Send", 16, 64, 75, 25, $WS_GROUP)
$Label1 = GUICtrlCreateLabel("Please Send Your", 8, 0, 89, 17)
$Label2 = GUICtrlCreateLabel("Data to the Server", 8, 16, 91, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			$data = GUICtrlRead($Input1)
			TCPSend($TCPConnect, String($data))
	EndSwitch
WEnd

