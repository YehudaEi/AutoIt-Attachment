#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "Routines_TCP.au3"
_TCP_Initialize("CLIENT","127.0.0.1",54321)

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("TCPClient", 264, 195, -1, -1)
$Button1 = GUICtrlCreateButton("Connect", 8, 8, 89, 25)
$Button2 = GUICtrlCreateButton("Disconnect", 8, 40, 89, 25)
$Input1 = GUICtrlCreateInput("Input1", 8, 72, 105, 21)
$Input2 = GUICtrlCreateInput("Input2", 8, 96, 105, 21)
$Button3 = GUICtrlCreateButton("Send", 120, 96, 49, 25)
$Input3 = GUICtrlCreateInput("Input3", 68, 127, 153, 21)
$Label1 = GUICtrlCreateLabel("Received:", 12, 127, 53, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			_TCPClient_Connect()
		case $Button2
			_TCPClient_Disconnect()
		case $Button3
			_TCPClient_SendData(GUICtrlRead($Input2))
	EndSwitch

	GUICtrlSetData($Input1,$sTCPConnState)

	_TCPClient_ReceiveData()

	;process new packets
	$sReceivedData = ""
	if $sTCPConnState = "CONNECTED" Then $sReceivedData = _TCPClient_GetNextPacket()

	;process packets
	if $sReceivedData <> "" then
		GUICtrlSetData($Input3,$sReceivedData)
	EndIf

WEnd
