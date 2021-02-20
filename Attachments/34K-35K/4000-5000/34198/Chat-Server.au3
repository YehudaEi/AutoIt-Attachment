#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt('MustDeclareVars', 1)
Local $VIP = @IPAddress2
Local $COM = @ComputerName
Local $Form1, $Input1, $DATA, $send, $Edit1, $msg, $ConnectedSocket

$Form1 = GUICreate("Server", 450, 323, 229, 189)
$Input1 = GUICtrlCreateInput("", 24, 6, 105, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Edit1 = GUICtrlCreateEdit("", 24, 32, 393, 201, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
$DATA = GUICtrlCreateInput("", 24, 248, 393, 21)
$send = GUICtrlCreateButton("Send", 368, 288, 57, 25)
GUISetState(@SW_SHOW)
SERVER()

Func SERVER()

    Local $ConnectedSocket, $DATA
    Local $IP = @IPAddress1
    Local $PORT = 33891

    TCPStartup()

    $ConnectedSocket = -1


    $ConnectedSocket = TCPConnect($IP, $PORT)
	TCPSend($ConnectedSocket, $VIP)
	TCPSend($ConnectedSocket, $COM)

EndFunc   

While 1
	$msg = GUIGetMsg()
	Switch $msg

		Case $send
			TCPSend($ConnectedSocket, $DATA)
			
	EndSwitch
WEnd
