; Host script
;==============================================
#include <GUIConstants.au3>

; Define variables
;==============================================
Global $sz_ip = @IPAddress1
Global $n_port = 65432
Global $n_connections = 100
Global $n_maxrecv = 1024
Global $ConnectedSocket = -1

; Start The TCP Services
;==============================================
TCPStartUp()

; Create a listening "SOCKET"
;==============================================
$listen = TCPListen($sz_ip, $n_port, $n_connections)
If $listen = -1 Then Exit
$RogueSocket = -1

; Create a GUI
;==============================================
$GOOEY = GUICreate("Host - " & $sz_ip,350,200)
$edit = GUICtrlCreateEdit("",10,40,330,150,$WS_DISABLED + $WS_VSCROLL + $ES_AUTOVSCROLL)
$input = GUICtrlCreateInput("",10,10,250,20)
$butt = GUICtrlCreateButton("Send",260,10,80,20,$BS_DEFPUSHBUTTON)
GUISetState()

; GUI Message Loop
;==============================================
While 1
   $msg = GUIGetMsg()

   ; GUI Closed
   ;--------------------
   If $msg = $GUI_EVENT_CLOSE Then ExitLoop

   ; User Pressed SEND
   ;--------------------
   If $msg = $butt Then
      If $ConnectedSocket > -1 Then
         $ret = TCPSend( $ConnectedSocket, GUICtrlRead($input))
         If @ERROR Then
            ; ERROR OCCURRED, CLOSE SOCKET AND RESET ConnectedSocket to -1
            ;----------------------------------------------------------------
            TCPCloseSocket( $ConnectedSocket )
            WinSetTitle($GOOEY,"","Host - " & $sz_ip)
            $ConnectedSocket = -1
         ElseIf $ret > 0 Then
            ; UPDATE EDIT CONTROL WITH DATA WE SENT
            ;----------------------------------------------------------------
            GUICtrlSetData($edit, GUICtrlRead($input) & @CRLF, 1)
         EndIf
      EndIf
      GUICtrlSetData($input,"")
   EndIf

   If $RogueSocket > 0 Then
      $recv = TCPRecv( $RogueSocket, $n_maxrecv )
      If NOT @error Then TCPCloseSocket( $RogueSocket )
      $RogueSocket = -1
   EndIf

   ; If no connection look for one
   ;--------------------
   If $ConnectedSocket = -1 Then
      $ConnectedSocket = TCPAccept( $listen)
   If $ConnectedSocket >= 0 and MsgBox(4 + 32 + 8192 + 262144, "Host - Connection Detected", SOCKET2IP($ConnectedSocket) & " is attempting to connect." & @CRLF & "Allow connection?") = 6 Then
      If $ConnectedSocket >= 0 Then
          WinSetTitle($GOOEY,"","Host - " & SOCKET2IP($ConnectedSocket) & ":" & $n_port)
          TCPSend( $ConnectedSocket, "~~accepted")
      EndIf
   ElseIf $ConnectedSocket >= 0 Then
      TCPSend( $ConnectedSocket, "~~rejected")
      GUICtrlSetData($edit, ">" & SOCKET2IP($ConnectedSocket) & " - Connection Rejected" & @CRLF, 1)
      WinSetTitle($GOOEY,"","Host - " & $sz_ip)
      TCPCloseSocket( $ConnectedSocket )
      $ConnectedSocket = -1
   EndIf
   
   ; If connected try to read some data
   ;--------------------
   Else
      ; EXECUTE AN UNCONDITIONAL ACCEPT IN CASE ANOTHER CLIENT TRIES TO CONNECT
      ;----------------------------------------------------------------
      $RogueSocket = TCPAccept( $listen)
      If $RogueSocket > 0 Then
        TCPSend( $RogueSocket, "~~failed" )
        GUICtrlSetData($edit, ">" & SOCKET2IP($RogueSocket) & " - Connection Failed" & @CRLF, 1)
      EndIf

      $recv = TCPRecv( $ConnectedSocket, $n_maxrecv )

      If $recv <> "" And $recv <> "~~bye" Then
         ; UPDATE EDIT CONTROL WITH DATA WE RECEIVED
         ;----------------------------------------------------------------
         GUICtrlSetData($edit, ">" & $recv & @CRLF, 1)

      ElseIf @error Or $recv = "~~bye" Then
         ; ERROR OCCURRED, CLOSE SOCKET AND RESET ConnectedSocket to -1
         ;----------------------------------------------------------------
         GUICtrlSetData($edit, "~~Client Logged Off" & @CRLF, 1)
         WinSetTitle($GOOEY,"","Host - " & $sz_ip)
         TCPCloseSocket( $ConnectedSocket )
         $ConnectedSocket = -1
      EndIf
   EndIf
WEnd

Func OnAutoItExit()
   ;ON SCRIPT EXIT close opened sockets and shutdown TCP service
   ;----------------------------------------------------------------------
   If $ConnectedSocket > -1 Then TCPSend( $ConnectedSocket, "~~failed" )
   If $ConnectedSocket > -1 Then TCPCloseSocket( $ConnectedSocket )
   If $listen > -1 Then TCPCloseSocket( $listen )
   TCPShutDown()
EndFunc

Func SOCKET2IP($SHOCKET)
   $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

   $a = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET,"ptr",DLLStructGetPtr($sockaddr),_
                                            "int_ptr",DLLStructGetSize($sockaddr))
   If Not @error And $a[0] = 0 Then
      $a = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
      If Not @error Then $a = $a[0]
   Else
      $a = 0
   EndIf

   DLLStructDelete($sockaddr)

   Return $a
EndFunc