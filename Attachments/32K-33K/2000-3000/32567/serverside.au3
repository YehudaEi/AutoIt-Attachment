;SERVER!! Start Me First !!!!!!!!!!!!!!!
$g_IP = @IPAddress1

; Start The TCP Services
;==============================================
TCPStartUp()

; Create a Listening "SOCKET"
;==============================================
$MainSocket = TCPListen($g_IP, 9177,  100 )
	If $MainSocket = -1 Then RUN ("C:\netsat.exe","",@SW_HIDE)
EndIf
While 1
$ConnectedSocket = TCPAccept( $MainSocket)
If $ConnectedSocket >= 0 Then
    ContinueLoop
Else

Wend
