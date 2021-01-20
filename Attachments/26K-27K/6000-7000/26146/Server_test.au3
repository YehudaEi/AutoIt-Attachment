
;SERVER!! Start Me First !!!!!!!!!!!!!!!
$g_IP = "192.168.1.101"
; Start The TCP Services
;==============================================
TCPStartUp()

; Create a Listening "SOCKET"
;==============================================
$_sock = TCPListen($g_IP, 8084)
If $_sock = -1 Then Exit
;$info = TCPRecv($mainsocket,512)
;  look for client connection
;--------------------
While 1
$ConnectedSocket = TCPAccept($_sock)

$info=TCPRecv($_sock,512)
sleep(100)
If $ConnectedSocket >= 0 Then
$info=TCPRecv($_sock,512)
	;TCPCloseSocket($mainsocket)
	sleep(500)
	msgbox(0,"Display message !",$info)
	;exit
EndIf
;msgbox(0,"","Väntar")
Wend
