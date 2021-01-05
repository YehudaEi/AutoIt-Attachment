;SERVER!! Start Me First !!!!!!!!!!!!!!!
#Compiler_Run_AU3Check=n
#include <GUIConstants.au3>

$g_IP = InputBox("Server address","EnterIP to connect to","127.0.0.1")
$port = InputBox("Port","Enter port","80")
$rootdir = "c:\temp\"
$log = "c:\temp\debug.txt"


; Start The TCP Services
;==============================================
TCPStartUp()

; Create a Listening "SOCKET"
;==============================================
$MainSocket = TCPListen($g_IP, $port,  100 )
If $MainSocket = -1 Then 
	MsgBox(1,"Debug","Error")
	Exit
EndIf
$RogueSocket = -1

; Create a GUI for chatting
;==============================================
$GOOEY = GUICreate("my server",300,200)
$edit = GUICtrlCreateEdit("",10,40,280,150,$WS_DISABLED)
$input = GUICtrlCreateInput("",10,10,200,20)
$butt = GUICtrlCreateButton("Send",210,10,80,20,$BS_DEFPUSHBUTTON)
GUISetState()

; Initialize a variable to represent a connection
;==============================================
Dim $ConnectedSocket = -1

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
         If GUICtrlRead($input) = "close" Then
			TCPCloseSocket( $ConnectedSocket )
            WinSetTitle($GOOEY,"","my server - Client Disconnected")
            $ConnectedSocket = -1 
			$ret = 0
		Else
			$ret = TCPSend( $ConnectedSocket,GUICtrlRead($input))
		EndIf
         If @ERROR Then
            ; ERROR OCCURRED, CLOSE SOCKET AND RESET ConnectedSocket to -1
            ;----------------------------------------------------------------
            TCPCloseSocket( $ConnectedSocket )
            WinSetTitle($GOOEY,"","my server - Client Disconnected")
            $ConnectedSocket = -1
         ElseIf $ret > 0 Then
            ; UPDATE EDIT CONTROL WITH DATA WE SENT
            ;----------------------------------------------------------------
            GUICtrlSetData($edit, GUICtrlRead($edit) & GUICtrlRead($input) & @CRLF )
         EndIf
      EndIf
      GUICtrlSetData($input,"")
   EndIf

   If $RogueSocket > 0 Then
      $recv = TCPRecv( $RogueSocket, 1024 )
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
          WinSetTitle($GOOEY,"","my server - Client Connected")
      EndIf

   ; If connected try to read some data
   ;--------------------
   Else
      ; EXECUTE AN UNCONDITIONAL ACCEPT IN CASE ANOTHER CLIENT TRIES TO CONNECT
      ;----------------------------------------------------------------
      $RogueSocket = TCPAccept( $MainSocket)
      If $RogueSocket > 0 Then 
          TCPSend( $RogueSocket, '<meta http-equiv="refresh" content="10">~~rejected')
      EndIf

      $recv = TCPRecv( $ConnectedSocket, 1024 )

      If $recv <> "" And $recv <> "~~bye" Then
		  FileWriteLine($log,"Received " & @CRLF & $recv & @CRLF)
         ; UPDATE EDIT CONTROL WITH DATA WE RECEIVED
         ;----------------------------------------------------------------
         GUICtrlSetData($edit, GUICtrlRead($edit) & ">" & $recv & @CRLF)
		  ;Msgbox(1,"debug",$recv)
		  If StringInStr($recv,"GET") > 0 Then
			  $requesteddoc=StringMid($recv,StringInStr($recv,"GET")+5,StringInStr($recv,"HTTP/1.1")-(StringInStr($recv,"GET")+5)) 
			  ;Msgbox(1,"debug","Requested file " & $requesteddoc,3)
			  If FileExists($rootdir & $requesteddoc) = 1 Then
				  ;MsgBox(1,"Debug","File found",3)
				  $requestarray=StringSplit($requesteddoc,".")
				  ;MsgBox(1,"debug",Ubound($requestarray) & " " & $requestarray[1] & " " & $requestarray[2])
				  If Ubound($requestarray) = 3 Then
					  $type = "type not recognized"
					  $requestarray[2] = StringStripWS($requestarray[2],8)
					  ;Msgbox(1,"Debug","Extenstion:" & $requestarray[2] & "<",5)
					  Select
						Case $requestarray[2] = "htm" or $requestarray[2] = "html" or $requestarray[2] = "txt"
							$type = "text/html"
						Case $requestarray[2] = "jpg"
							$type = "image/jpeg"
						Case $requestarray[2] = "gif"
							$type = "image/gif"
					  EndSelect
						
				   Else
					 $type = "no extention"
				   EndIf
						
				  $size=FileGetSize($rootdir&$requesteddoc)
				  $modified=FileGetTime($rootdir&$requesteddoc,0,1)
				  $webdoc=FileRead($rootdir & $requesteddoc,$size,)
				  $header="HTTP/1.0 200 OK"&@LF&"Date: "&@MON&"-"&@MDAY&"-"&@YEAR&" "&@HOUR&":"&@MIN&":"&@SEC&" EST"&@LF&"Server: AutoIT"&@LF&"Content-type: "&$type&@LF&"Content-length: "&$size&@LF&"Last-modified: "&$modified&@LF&@LF
			  Else
				 $webdoc="File not found"
				 $header="HTTP/1.0 404 Error"
			  endif
		  else
			  $webdoc="request error"
			  $header="Request error"
		  EndIf
		  ;Msgbox(1,"debug","Requested file:" & $requesteddoc & @CRLF & "Header:" &@CRLF &$header)
		  Sleep(2000)
		  FileWriteLine($log,"SENT" & @CRLF & $header&@CRLF&@CRLF&$webdoc)
		  $ret = TCPSend($ConnectedSocket,$header&@CRLF&@CRLF&$webdoc)
		  Sleep(2000)                   
		  TCPCloseSocket( $ConnectedSocket )
		  WinSetTitle($GOOEY,"","my server - Client Disconnected")
		  
		  GUICtrlSetData($edit,"")
		  $ConnectedSocket = -1 
		  $ret = 0
      ElseIf @error Or $recv = "~~bye" Then
         ; ERROR OCCURRED, CLOSE SOCKET AND RESET ConnectedSocket to -1
         ;----------------------------------------------------------------
         WinSetTitle($GOOEY,"","my server - Client Disconnected")
         TCPCloseSocket( $ConnectedSocket )
         $ConnectedSocket = -1
      EndIf
   EndIf
WEnd

GUIDelete($GOOEY)

Func OnAutoItExit()
   ;ON SCRIPT EXIT close opened sockets and shutdown TCP service
   ;----------------------------------------------------------------------
   If $ConnectedSocket > -1 Then 
      TCPSend( $ConnectedSocket, "~~bye" )
      Sleep(2000)
      TCPRecv( $ConnectedSocket,  512 )
      TCPCloseSocket( $ConnectedSocket )
   EndIf
   TCPCloseSocket( $MainSocket )
   TCPShutDown()
EndFunc
