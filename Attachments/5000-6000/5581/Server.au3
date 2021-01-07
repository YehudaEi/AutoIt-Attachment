#Include <Constants.au3>
Global $MainSocket, $ConnectedSocket = -1
Global $g_IP = @IPADDRESS1
Global $g_port = 33891
Opt("TrayMenuMode",1)
$exititem = TrayCreateItem("Exit")
; Start The TCP Services
;==============================================
TCPStartUp()

; Create a Listening "SOCKET"
;==============================================
$MainSocket = TCPListen($g_IP, $g_port,  100 )
If $MainSocket = -1 Then Exit
$RogueSocket = -1

While 1
;special commands
$recv = TCPRecv( $ConnectedSocket, 512 )

If $recv = "~~test1" Then
TCPSend($ConnectedSocket, "Command test1 was received and executed!")
EndIf

If $recv = "~~test2" Then
TCPSend($ConnectedSocket, "Command test2 was received and executed!")
EndIf

If $recv = "~~test3" Then
TCPSend($ConnectedSocket, "Command test3 was received and executed!")
EndIf

If $recv = "~~test4" Then
TCPSend($ConnectedSocket, "Command test4 was received and executed!")
EndIf

;end special commands
$msg = TrayGetMsg()
	Select
		Case $msg = $exititem
			ExitLoop
	EndSelect
   If $RogueSocket > 0 Then
      $recv = TCPRecv( $RogueSocket, 512 )
      If NOT @error Then
         TCPCloseSocket( $RogueSocket )
         $RogueSocket = -1
      EndIf
   EndIf

   ; If no connection look for one
   ;--------------------
   If $ConnectedSocket = -1 Then
      $ConnectedSocket = TCPAccept( $MainSocket)
      If $ConnectedSocket >= 0 Then
          TCPSend($ConnectedSocket, "We are now connected!")
      EndIf
   Else

      $RogueSocket = TCPAccept( $MainSocket)
      If $RogueSocket > 0 Then 
          TCPSend( $RogueSocket, "~~rejected" )
      EndIf
      $recv = TCPRecv( $ConnectedSocket, 512 )
      If @error Or $recv = "~~bye" Then
         TCPCloseSocket( $ConnectedSocket )
         $ConnectedSocket = -1
      EndIf
   EndIf
WEnd
Func OnAutoItExit()
   If $ConnectedSocket > -1 Then 
      TCPSend( $ConnectedSocket, "~~bye" )
      Sleep(2000)
      TCPRecv( $ConnectedSocket,  512 )
      TCPCloseSocket( $ConnectedSocket )
   EndIf
   TCPCloseSocket( $MainSocket )
   TCPShutDown()
EndFunc

Func SOCKET2IP($SHOCKET)
   $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

   $a = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET,"ptr",DLLStructGetPtr($sockaddr), _
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