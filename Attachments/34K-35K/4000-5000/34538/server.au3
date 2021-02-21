#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

TCPStartup()
$TCPListen = TCPListen(@IPAddress1, 1000)

$Form1 = GUICreate("Server", 30, 14,@DesktopWidth - 31,0,$WS_POPUP)
$Label1 = GUICtrlCreateLabel("", 0, 0, 30, 17)
GUISetState(@SW_SHOW)
Do
	Do
		$TCPAccept = TCPAccept($TCPListen)
	Until $TCPAccept <> -1
	Do
		$TCPRecv = TCPRecv($TCPAccept, 255)
	Until $TCPRecv <> ""
	If $TCPRecv <> "" Then
		GUICtrlRead($TCPRecv)
		GUICtrlSetData($Label1, $TCPRecv)
		GUICtrlSetData($TCPAccept, -1)
		GUICtrlSetData($TCPRecv, "")
	EndIf
Until $GUI_EVENT_CLOSE

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd
