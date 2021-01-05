; Client script
;==============================================
#include <GUIConstants.au3>

; Define variables
;==============================================
$socket = -1
$failed = 1
$sz_ip = InputBox("Connect to:", "Type in the IP address you wish to connect to.", @IPAddress1)
If @ERROR Then Exit
$failed = 0
$n_port = 65432
$n_maxrecv = 1024

; Start The TCP Services
;==============================================
TCPStartUp()

; Connect to a listening "SOCKET"
;==============================================
$socket = TCPConnect($sz_ip, $n_port)
If $socket = -1 Then Exit

; Create a GUI
;==============================================
$GOOEY = GUICreate("Client - Looking For Connection",350,200)
$edit = GUICtrlCreateEdit("~~Looking For Connection",10,40,330,150,$WS_DISABLED + $WS_VSCROLL + $ES_AUTOVSCROLL)
$input = GUICtrlCreateInput("",10,10,250,20)
$butt = GUICtrlCreateButton("Send",260,10,80,20,$BS_DEFPUSHBUTTON)
GUISetState()

; Wait For Connection
;==============================================
$connection = -1
While $connection = -1
  Sleep(10)
  $connection = TCPAccept($socket)
Wend
$recv = ""
While $recv <> "~~accepted"
  Sleep(10)
  $recv = TCPRecv($socket, $n_maxrecv)
  If $recv = "~~rejected" Then
    GUICtrlSetData($edit, "~~Connection Rejected" & @CRLF, 1)
    WinSetTitle($GOOEY,"","Connection Rejected")
    Sleep(2000)
    $failed = 1
    Exit
  EndIf
Wend
GUICtrlSetData($edit, "~~Connection Accepted" & @CRLF, 1)
WinSetTitle($GOOEY,"","Client - Host Connected")

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
      If GUICtrlRead($input) = "~~bye" Then
         GUICtrlSetData($edit, "~~Logging Off" & @CRLF, 1)
         WinSetTitle($GOOEY,"","Logging Off...")
         Sleep(2000)
         ExitLoop
      EndIf
      $ret = TCPSend($socket, GUICtrlRead($input))
      If @ERROR Then ExitLoop
      ; Server Disconnected... we Outty...
      ;---------------------------------------

      If $ret > 0 Then GUICtrlSetData($edit, GUICtrlRead($input) & @CRLF, 1)
      GUICtrlSetData($input,"")
   EndIf

   $recv = TCPRecv($socket, $n_maxrecv )
   If @error Or $recv == "~~bye" Then   
      ; Server Disconnected... we Outty...
      ;---------------------------------------
      GUICtrlSetData($edit, "~~Connection Lost" & @CRLF, 1)
      WinSetTitle($GOOEY,"","Connection Lost")
      Sleep(2000)
      ExitLoop
   ElseIf $recv == "~~failed" Then
      GUICtrlSetData($edit, "~~Connection Failed" & @CRLF, 1)
      WinSetTitle($GOOEY,"","Connection Failed")
      Sleep(2000)
      ExitLoop
   EndIf

   If $recv <> "" Then GUICtrlSetData($edit, ">" & $recv & @CRLF, 1)
WEnd

Func OnAutoItExit()
   If $socket > -1 and $failed = 0 Then
      TCPSend( $socket, "~~bye" )
      TCPCloseSocket( $socket )
   EndIf
   TCPShutDown()
EndFunc