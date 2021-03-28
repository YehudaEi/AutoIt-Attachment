#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("TCPClient", 264, 281, -1, -1)
$Button1 = GUICtrlCreateButton("Connect", 8, 8, 89, 25)
$Button2 = GUICtrlCreateButton("Disconnect", 104, 8, 89, 25)
$txtConnStatus = GUICtrlCreateInput("txtConnStatus", 48, 40, 105, 21)
$txtDataToSend = GUICtrlCreateInput("txtDataToSend", 8, 80, 105, 21)
$Button3 = GUICtrlCreateButton("Send", 120, 80, 49, 25)
$txtDataReceived = GUICtrlCreateInput("txtDataReceived", 68, 119, 153, 21)
$Label1 = GUICtrlCreateLabel("Received:", 12, 119, 53, 17)
$Label2 = GUICtrlCreateLabel("Status:", 8, 40, 37, 17)
$Label3 = GUICtrlCreateLabel("Packets received:", 8, 152, 90, 17)
$txtNumPacketsReceived = GUICtrlCreateInput("txtNumPacketsReceived", 104, 152, 41, 21)
$Label5 = GUICtrlCreateLabel("Packets sent:", 8, 184, 69, 17)
$txtNumPacketsSent = GUICtrlCreateInput("", 80, 184, 41, 21)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#include "Routines_TCP.au3"

;*** TCP INITIALIZATION AS CLIENT ***
$sTCPMode = "CLIENT" ;set as either "SERVER" or "CLIENT"
$sServerIP = "127.0.0.1" ;can be either ip address or computer name
$iServerPort = 54321 ;server port
_TCP_Initialize($sTCPMode,$sServerIP,$iServerPort)

;*** SET INITIAL CONNECTION STRING (OPTIONAL) ***
;set the connection string as the first packet of data to be sent upon successful connection to server
_TCP_SetConnectString("UNAME=" & @UserName)



While 1

	;*** ATTEMPT TO RETRIEVE NEW PACKETS FROM QUEUE ***
	for $iPacket = 1 to 10
		$sReceivedData = _TCPClient_GetPacket() ;retrieve next full packet from queue
		if $sReceivedData <> "" then GUICtrlSetData($txtDataReceived,$sReceivedData) ;update text received display
		if $sReceivedData = "" then ExitLoop ;no more packets to retrieve?  Exit the loop
	Next

	;*** SEND KEEPALIVE TO PREVENT DISCONNECTION FROM SERVER ***
	_TCPClient_SendKeepAlive(15)

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			_TCPClient_Connect()
		case $Button2
			_TCPClient_Disconnect()
		case $Button3
			_TCPClient_SendPacket(GUICtrlRead($txtDataToSend))
	EndSwitch

	GUICtrlSetData($txtConnStatus,_TCP_ConnInfo("IsConnected"))

	;process new packets (up to 10 at a time)
	$sReceivedData = ""
	if _TCP_ConnInfo("IsConnected") Then
		for $iPacket = 1 to 10
			$sReceivedData = _TCPClient_GetPacket()
			if $sReceivedData <> "" then
				GUICtrlSetData($txtDataReceived,$sReceivedData)
			EndIf
			if $sReceivedData = "" then ExitLoop
		Next
		GUICtrlSetData($txtNumPacketsReceived,_TCP_ConnInfo("PacketsProcessed"))
		GUICtrlSetData($txtNumPacketsSent,_TCP_ConnInfo("PacketsSent"))
	EndIf

	Sleep(10)
WEnd
