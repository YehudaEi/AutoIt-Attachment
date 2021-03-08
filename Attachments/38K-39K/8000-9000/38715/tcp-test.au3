
;script to open TCP port 33441
;Creat a socket connected to an existing server.

;CLIENT!!!!!!!! Start SERVER First... dummy!!
Local $g_IP = "192.168.1.1"

; Start The TCP Services
;==============================================
TCPStartup()
; Connect to a Listening "SOCKET"
;==============================================
Local $socket = TCPConnect($g_IP, 33441)
If $socket = -1 Then Exit

While (1)
    $status = TCPSend($socket, "ap_ca_version")
    If $status = 0 then
        MsgBox(0, "ERROR", "Error: " & @error)
	Else
        MsgBox(0, "Sent", "Test sent: " @CR)
        Exit
    EndIf

    $srcv = TCPRecv($Socket, 256)
    If ($srcv <> "") Then
        ConsoleWrite("status,RUNNING" & @CR)
        ConsoleWrite($srcv & @CR)
        ExitLoop
    EndIf
    sleep(100)
WEnd
TCPCloseSocket($socket)
TCPShutdown()