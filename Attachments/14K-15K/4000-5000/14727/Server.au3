;SERVER!! Start Me First !!!!!!!!!!!!!!!
#NoTrayIcon
Dim $szIPADDRESS = @IPAddress1, $nPORT = 33891, $ConnectedSocket = -1, $MainSocket, $msg, $recv, $szIP_Accepted
; Start The TCP Services
;==============================================
TCPStartUp()
; Create a GUI for messages
;Wait for connection and convert socket into IP
Listen()
; GUI Message Loop
;==============================================
; Try to receive (up to) 2048 bytes
;----------------------------------------------------------------
While 1
$recv = TCPRecv( $ConnectedSocket, 2048 )
; If the receive failed with @error then the socket has disconnected
;----------------------------------------------------------------
    If @error Then ExitLoop
; Update the edit control with what we have received
;----------------------------------------------------------------
Select
Case $recv = "ENDING_BYE"
        TCPCloseSocket($ConnectedSocket)
        TCPCloseSocket($MainSocket)
    Listen()
$recv = ""
Case $recv = "#shutdown"
shutdown(1)
Case $recv = "#reboot"
shutdown(2)
Case $recv = "#blocky"
BlockInput(1)
$recv = ""
Case $recv = "#blockn"
BlockInput(0)
$recv = ""
Case $recv <> ""
MsgBox(64, "Bericht van " & $szIP_Accepted, $recv)
EndSelect
WEnd
If $ConnectedSocket <> -1 Then TCPCloseSocket($ConnectedSocket)
TCPShutDown()
; Function to return IP Address from a connected socket.
;----------------------------------------------------------------------
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")
Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int_ptr",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf
$sockaddr = 0
Return $aRet
EndFunc
Func Listen()
; Create a Listening "SOCKET".
;   Using your IP Address and Port 33891.
;==============================================
$MainSocket = TCPListen($szIPADDRESS, $nPORT)
; If the Socket creation fails, exit.
If $MainSocket = -1 Then Exit
;Wait for and Accept a connection
;==============================================
Do
    $ConnectedSocket = TCPAccept($MainSocket)
Until $ConnectedSocket <> -1
; Get IP of client connecting
Dim $szIP_Accepted = SocketToIP($ConnectedSocket)
EndFunc