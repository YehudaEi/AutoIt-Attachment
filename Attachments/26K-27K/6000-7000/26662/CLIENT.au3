;CLIENT! Start Me after starting the SERVER!!!!!!!!!!!!!!!
; see TCPRecv example
#include <GUIConstants.au3>
Dim $IP = "192.168.5.1"
; Start The TCP Services
;==============================================
TCPStartUp()

; Set Some reusable info
;--------------------------
Dim $szIPADDRESS = $IP
Dim $nPORT = 33891


; Initialize a variable to represent a connection
;==============================================
Dim $ConnectedSocket = -1


;Attempt to connect to SERVER at its IP and PORT 33891
;=======================================================
$ConnectedSocket = TCPConnect($szIPADDRESS,$nPORT)


Dim $szData

; If there is an error... show it
If @error Then
    MsgBox(4112,"Error","TCPConnect failed with WSA error: " & @error)
; If there is no error loop an inputbox for data
;   to send to the SERVER.
Else
;Loop forever asking for data to send to the SERVER
    While 1
    ; InputBox for data to transmit
        $szData = InputBox("Data for Server",@LF & @LF & "Enter data to transmit to the SERVER:")

    ; If they cancel the InputBox or leave it blank we exit our forever loop
        If @error Or $szData = "" Then ExitLoop

    ; We should have data in $szData... lets attempt to send it through our connected socket.
        TCPSend($ConnectedSocket,$szData)

    ; If the send failed with @error then the socket has disconnected
    ;----------------------------------------------------------------
        If @error Then ExitLoop
    WEnd
EndIf
