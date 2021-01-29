#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.1.1 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;;This is the UDP Server
;;Start this first

; Start The UDP Services
;==============================================

UDPStartup()

; Bind to a SOCKET
;==============================================
$socket = UDPBind(@IPAddress1, 65532)
If @error <> 0 Then Exit

While 1
    $data = UDPRecv($socket, 50)
    If $data <> "" Then
        MsgBox(0, "UDP DATA", $data, 1)
    EndIf
    sleep(100)
WEnd

Func OnAutoItExit()
    UDPCloseSocket($socket)
    UDPShutdown()
EndFunc
