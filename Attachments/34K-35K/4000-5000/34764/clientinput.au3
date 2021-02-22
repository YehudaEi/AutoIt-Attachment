#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $IP, $TCPConnect, $i = 0

TCPStartup()

$Form1 = GUICreate("Client", 108, 23, 373, 441, -1, $WS_EX_TOPMOST)
$Input1 = GUICtrlCreateInput("0.0.0.0", 0, 0, 66, 21)
$Button1 = GUICtrlCreateButton("Connect", 72, 0, 35, 21)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			If $i = 0 Then
				$IP = GUICtrlRead($Input1)
				$TCPConnect = TCPConnect($IP, 5000)
				GUICtrlSetData($Button1, "Send")
			EndIf
			$i = 1
			If $i = 1 Then
				TCPSend($TCPConnect, GUICtrlRead($Input1))
				GUICtrlSetData($Input1, "")
			EndIf
	EndSwitch
WEnd
