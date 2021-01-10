#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         SetEnv

 Script Function:
	LogCheck server.

#ce ----------------------------------------------------------------------------


; Changes
; * Replaced created-function 'StringAddToken()' by '_ArrayAdd()'


Global $AnalyzeSocket, $AnalyzeData, $version = "0.1 (beta)", $addtok_item

MainThread()

Func MainThread()
	Local $szIPADDRESS = IniRead("config.ini", "server", "listen", "127.0.0.1:" & @IPAddress1)
	
	Local $myip = "127.0.0.1", $nPORT = IniRead("config.ini", "server", "port", "300")
	Local $MainSocket, $ConnectedSocket, $szIP_Accepted, $recv

	; Start The TCP Services
	;==============================================
	TCPStartup()

	; Create a Listening "SOCKET".
	;==============================================
	$MainSocket = TCPListen($myip, $nPORT, 500)

	If $MainSocket <> -1 Then
		TrayTip("LogCheck [server]","Waiting for connection...", 5, 1)
		
		; Initialize a variable to represent a connection
		;==============================================
		$ConnectedSocket = -1


		;Wait for and Accept a connection
		;==============================================
		Do
			$ConnectedSocket = TCPAccept($MainSocket)
		Until $ConnectedSocket <> -1


		; Get IP of client connecting
		$szIP_Accepted = SocketToIP($ConnectedSocket)
		
		TrayTip("LogCheck [server]","New connection from: "& $szIP_Accepted, 5, 1)
		
		; Try to receive (up to) 2048 bytes
		;====================================
		$recv = TCPRecv($ConnectedSocket, 2048)
		
		; If the receive failed with @error then the socket has disconnected
		; AND Removing socket from identified socket...
		;=====================================================================
		If @error Then 
			IniDelete("auth.ini", "logged", $ConnectedSocket)
			TrayTip("LogCheck [server]","Connection from: "& $szIP_Accepted &" closed", 5, 3)
		
		; Else
		Else
		
			; If client is not yet logged
			If IsLogged($ConnectedSocket) == "False" Then IsGoodAuth($ConnectedSocket, $recv)
			;If $IsGoodAuth == "True" Then TCPSend($ConnectedSocket, Crypt("300:WELCOME", $ConnectedSocket))
			;If $IsGoodAuth == "False" Then TCPCloseSocket($ConnectedSocket)
		
			; If client is logged
			If IsLogged($ConnectedSocket) == "True" Then 
				;Analyze sended string
				Analyze($ConnectedSocket, $szIP_Accepted, $recv)
			EndIf
		EndIf
	EndIf
EndFunc

Func IsGoodAuth($sockname,$datas)
	For $loop = _FileCountLines("passwd") To 0 Step -1
		
		$zRead = FileReadLine("passwd", $loop)
		$zReadSplit = StringSplit($zRead, ":")
		$zDecode = _StringEncrypt("0", $datas, $zReadSplit[2])
		
		If $zDecode <> $zReadSplit[1] Then 
			TCPCloseSocket($sockname)
		Else
			

; analyze ...
; =====================================================
; $AnalyzeSocket: Client Socket Identifier
; $AnalyzeSourceIp: Client's Ip
; $AnalyzeData: Data to analyze: 'ip1 ip2 ip3 ip4 ...'
; =====================================================

;[logip]
;Analyzeitem=ip1 ip2 ip3 ip4


Func Analyze($aSocket, $aSource, $aChain)
	
	For $aLoop = $aChain[0] To 0 Step -1
		$aItem = $aChain[$aLoop]
		$aRead = IniRead("items.db", "uIp", $aItem, "NULL")
		
		If $aRead == "NULL" Then 
			IniWrite("items.db", "uIp", $aItem, $aSource)
		Else
			Local $aNewChain = _ArrayAdd($aRead, $aItem)
			If $aNewChain <> $aRead Then
				$aTotalItemsInChain = $aNewChain[0]
				If $aTotalItemsInChain > 20 Then NeedAction($aItem)
				If $aTotalItemsInChain <= 20 Then IniWrite("items.db", "uIp", $aItem, $aNewChain)
			EndIf
		EndIf
	Next
	TCPSendCrypted($aSocket, "500:OK")
EndFunc
