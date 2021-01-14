;CLIENT! Start Me after starting the SERVER!!!!!!!!!!!!!!!
; see TCPRecv example
#include <GUIConstants.au3>
#NoTrayIcon
; Start The TCP Services
;==============================================
TCPStartUp()
$gui027 = GUICreate("My GUI radio", 200, 100); will create a dialog box that when displayed is centered
$radio1 = GUICtrlCreateRadio ("SERVER", 10, 10, 120, 20)
$radio2 = GUICtrlCreateRadio ("AOPEN", 10, 40, 120, 20)
$radio3 = GUICtrlCreateRadio ("HP", 10, 70, 120, 20)
GUISetState (@SW_SHOW)
; Run the GUI until the dialog is closed
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $radio1 And GUICtrlRead($radio1) = $GUI_CHECKED
            GUISetState(@SW_HIDE, $gui027)
   TCPConnect1("192.168.0.100")
  ; Set Some reusable info
;--------------------------
; Set $szIPADDRESS to wherever the SERVER is. We will change a PC name into an IP Address

        Case $msg = $radio2 And GUICtrlRead($radio2) = $GUI_CHECKED
            GUISetState(@SW_HIDE, $gui027)
   TCPConnect1("192.168.0.101")

  Case $msg = $radio3 And GUICtrlRead($radio2) = $GUI_CHECKED
            GUISetState(@SW_HIDE, $gui027)
   TCPConnect1("192.168.0.102")
    EndSelect
Wend

Func TCPConnect1($szIPADDRESS)

; Set Some reusable info
;--------------------------
; Set $szIPADDRESS to wherever the SERVER is. We will change a PC name into an IP Address
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
        $szData = InputBox("Data for Server", "Enter data to transmit to the SERVER:", "", "", 275, 75)
      
; If they cancel the InputBox or leave it blank we exit our forever loop
        If @error Or $szData = "" Then ExitLoop
      
; We should have data in $szData... lets attempt to send it through our connected socket.
        TCPSend($ConnectedSocket,$szData)
      
; If the send failed with @error then the socket has disconnected
;----------------------------------------------------------------
        If @error Then ExitLoop
  WEnd
  EndIf
  TCPSend($ConnectedSocket, "ENDING_BYE")
  GUISetState(@SW_SHOW, $gui027)
EndFunc