;~  ===============================================================================================
;~ 
;~ IE Web Filter Alpha v.0.1
;~ -----------------------------------
;~ 
;~  Author Karl
;~ 
;~ Known Issues
;~ Having issues where sometimes there is no data in $recv, unsure why.  Seems to occur almost at Random
;~ 
;~  Refreshing a page doesn't trigger the filter again.  Need to look into the loop system
;~  ===============================================================================================



#include <GUIConstants.au3>

; Set Some reusable info
; Set your Public IP address (@IPAddress1) here.
Dim $szIPADDRESS = @IPAddress1
Dim $nPORT = 85
Dim $RouterIP = "192.168.1.1"
Dim $ConnectedSocket = -1
Dim $msg, $recv, $Domain

; Start The TCP Services
;==============================================
;TCPShutdown ( )
TCPStartUp()

; Create a Listening "SOCKET".
;   Using your IP Address and Port 33891.
;==============================================
$MainSocket = TCPListen($szIPADDRESS, $nPORT)

; If the Socket creation fails, exit.
If $MainSocket = -1 Then Exit


; Create a GUI for messages
;==============================================
Dim $GOOEY = GUICreate("My Server (IP: " & $szIPADDRESS & ")",300,200)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_SpecialEvents")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "_SpecialEvents")
	GUISetOnEvent($GUI_EVENT_RESTORE, "_SpecialEvents")
	
Dim $edit = GUICtrlCreateEdit("",10,10,280,180)
GUISetState(@SW_SHOW)

While 1

;Wait for and Accept a connection
;==============================================
Do
    $ConnectedSocket = TCPAccept($MainSocket)

	;GUICtrlSetData($edit, "Is Socket Connected? " & $ConnectedSocket & @CRLF & "==========================" & @CRLF & @CRLF, 1)

Until $ConnectedSocket <> -1


;GUICtrlSetData($edit, "Socket: " & $ConnectedSocket & @CRLF, 1)

   $msg = GUIGetMsg()

; GUI Closed
;--------------------
    If $msg = $GUI_EVENT_CLOSE Then Exit

; Try to receive (up to) 2048 bytes
;----------------------------------------------------------------
    $recv = TCPRecv( $ConnectedSocket, 2048 )
    
; If the receive failed with @error then the socket has disconnected
;----------------------------------------------------------------
    If @error Then Exit



; Get the Domain Name
;==========================
	If $recv <> "" Then
			GUICtrlSetData($edit, "Received Data" & @CRLF & $recv & @CRLF & "==========================" & @CRLF & @CRLF, 1)
			$text = StringReplace($recv, "GET ", "")
			$text = StringReplace($recv, "NNECT ", "")
			$LineEnd = StringInStr($text,@LF)	;Locate the 1st LINE FEED
			$URL = StringLeft($text, $LineEnd-1)
			
			
			
			$RootLocation = StringInStr($URL,".com", 0, 1)	;Locate where .com, .net, .org is
			
			If $RootLocation = 0 Then
				$RootLocation = StringInStr($URL,".net")	;Locate where .com, .net, .org is
			EndIf
			
			If $RootLocation = 0 Then
				$RootLocation = StringInStr($URL,".org")	;Locate where .com, .net, .org is
			EndIf
	
			$Domain = StringLeft ($URL, $RootLocation+3)
	
	
	
		;Find where the http:// -or- Https:// location is and remove it
		;======================================================
		$TrimDomain = StringInStr($Domain,"://") 
		$TrimmedDomain = StringTrimLeft($Domain, $TrimDomain+2)

		GUICtrlSetData($edit, "Domain: " & $TrimmedDomain & @CRLF, 1)
		
		;IP of Domain
		;=======================
		Dim $DomainIPAddress = TCPNameToIP($TrimmedDomain)
		GUICtrlSetData($edit, "IP: " & $DomainIPAddress & @CRLF & @CRLF & "==========================" & @CRLF, 1)
		$WebSiteConnected = TCPConnect($DomainIPAddress,80)
		GUICtrlSetData($edit, "Connected to Web Site?  -1 is error" & $WebSiteConnected & @CRLF & @CRLF & "==========================" & @CRLF, 1)
		
	EndIf





		
WEnd


;~ 			
;~ 			;GUICtrlSetData($edit, $text)
;~ 			;msgbox(0,"",$text)
;~ 			
;~ 			;Filter the content
;~ 			
;~ 			
;~ 			;Get the IP of the URL
;~ 			Dim $URL_ADDRESS = TCPNameToIP($URL)
;~ 			
;~ 			
;~ 			;Connect to the Router to send off the request
;~ 			$RouterSocket = TCPConnect($RouterIP,80)
;~ 			$Check = TCPSend($RouterSocket,$URL)
;~ 			;msgbox(0,"Checking router",$Check)
;~ 			
;~ 			GUICtrlSetData($edit, $URL & @LF & @LF & "IP: " & $URL_ADDRESS)
;~ 			Sleep(10000)
;~ 			Exit
;~ 	EndIf







If $ConnectedSocket <> -1 Then TCPCloseSocket( $ConnectedSocket )

TCPShutDown()


; Function to return IP Address from a connected socket.
;----------------------------------------------------------------------
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc


Func _SpecialEvents()
    Select
        Case @GUI_CTRLID = $GUI_EVENT_CLOSE
            MsgBox(0, "Close Pressed", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)
            Exit
        Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE
            MsgBox(0, "Window Minimized", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)
        Case @GUI_CTRLID = $GUI_EVENT_RESTORE
            MsgBox(0, "Window Restored", "ID=" & @GUI_CTRLID & " WinHandle=" & @GUI_WINHANDLE)
    EndSelect    
EndFunc