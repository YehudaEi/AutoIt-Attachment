#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $IP

TCPStartup()

$Form1 = GUICreate("Client", 108, 23, 373, 441)
$Input1 = GUICtrlCreateInput("0.0.0.0", 0, 0, 66, 21)
$Button1 = GUICtrlCreateButton("Connect", 72, 0, 35, 21)
GUISetState(@SW_SHOW)

HotKeySet("{ENTER}", "DoButton")
$i = 0

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			If $i = 0 Then
				$i = 1
				$IP = GUICtrlRead($Input1)
				$TCPConnect = TCPConnect($IP, 5000)
				GUICtrlSetData($Input1, "")
				GUICtrlSetData($Button1, "Send")
			EndIf
			If $i = 1 Then
				TCPSend($TCPConnect, GUICtrlRead($Input1))
				GUICtrlSetData($Input1, "")
			EndIf
	EndSwitch
WEnd

Func DoButton()
	TCPSend($TCPConnect, GUICtrlRead($Input1))
	GUICtrlSetData($Input1, "")
EndFunc