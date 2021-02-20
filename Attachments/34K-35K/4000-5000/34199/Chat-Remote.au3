#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt('MustDeclareVars', 1)

Example()

Func Example()

    Local $IP = @IPAddress1
    Local $PORT = 33891
    Local $MainSocket, $Form1, $Edit1, $Input1, $send, $ipp, $close, $DATA, $ConnectedSocket, $szIP_Accepted
    Local $msg, $recv, $VIP, $COM

    TCPStartup()

    $MainSocket = TCPListen($IP, $PORT)


    If $MainSocket = -1 Then Exit


$Form1 = GUICreate("Remote Administrator", 450, 323, 248, 204)
$Input1 = GUICtrlCreateInput("", 24, 6, 105, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$Edit1 = GUICtrlCreateEdit("", 24, 32, 393, 201, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
$DATA = GUICtrlCreateInput("", 24, 248, 393, 21)
$send = GUICtrlCreateButton("Send", 368, 288, 57, 25)
$ipp = GUICtrlCreateInput("", 137, 6, 193, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
$close = GUICtrlCreateButton("Close Chat", 296, 288, 65, 25)
GUISetState(@SW_SHOW)



    $ConnectedSocket = -1

    Do
        $ConnectedSocket = TCPAccept($MainSocket)
    Until $ConnectedSocket <> -1



    $szIP_Accepted = SocketToIP($ConnectedSocket)


    While 1
        $msg = GUIGetMsg()

        If $msg = $GUI_EVENT_CLOSE Then ExitLoop


        $recv = TCPRecv($ConnectedSocket, 2048)



        If @error Then ExitLoop



				
				        If $recv <> "" Then GUICtrlSetData($ipp, _
				 $re & GUICtrlRead($ipp))
					        If $recv <> "" Then GUICtrlSetData($Input1, _
				 $re2 & GUICtrlRead($Input1))
    WEnd


    If $ConnectedSocket <> -1 Then TCPCloseSocket($ConnectedSocket)

    TCPShutdown()
EndFunc   


Func SocketToIP($SHOCKET)
    Local $sockaddr, $aRet
   
    $sockaddr = DllStructCreate("short;ushort;uint;char[8]")

    $aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, _
            "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet==>SocketToIP