#include "Routines_TCP.au3"
_TCP_Initialize("SERVER","127.0.0.1",54321,2)
_TCPServer_StartListen()

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>



#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("TCPServer", 237, 150, -1, -1)
$Input1 = GUICtrlCreateInput("Input1", 80, 8, 57, 21)
$lbl_Connections = GUICtrlCreateLabel("Connections:", 8, 8, 66, 17)
$Input2 = GUICtrlCreateInput("Input2", 8, 48, 129, 21)
$Button1 = GUICtrlCreateButton("Send", 144, 48, 65, 25)
$Label1 = GUICtrlCreateLabel("Received:", 16, 104, 53, 17)
$Input3 = GUICtrlCreateInput("Input3", 72, 104, 153, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
ConsoleWrite("|")

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			for $iConn = 0 to $iTCPServerMaxConnections - 1
				if $aTCPClientState[$iConn] = "CONNECTED" Then
					ConsoleWrite($aTCPClientSocket[$iConn])
					_TCPServer_SendData($iConn,GUICtrlRead($Input2))
				EndIf
			Next
	EndSwitch

	;check for new connections
	_TCPServer_CheckForNewConnections()
	GUICtrlSetData($Input1,$iTCPTotalConnectedClients)

	;retrieve new data
	for $iConn = 0 to $iTCPServerMaxConnections - 1
		if $aTCPClientState[$iConn] = "CONNECTED" Then _TCPServer_ReceiveData($iConn)
	Next

	;process new packets
	for $iConn = 0 to $iTCPServerMaxConnections - 1
		$sReceivedData = ""
		if $aTCPClientState[$iConn] = "CONNECTED" Then $sReceivedData = _TCPServer_GetNextPacket($iConn)

		;process packets
		if $sReceivedData <> "" then
			GUICtrlSetData($Input3,$sReceivedData)
		EndIf
	Next

	Sleep(50)

WEnd