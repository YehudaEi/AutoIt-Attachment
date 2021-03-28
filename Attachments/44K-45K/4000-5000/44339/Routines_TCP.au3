;*******************************************************************************************
;*** AUTOIT TCP ROUTINES by Geoff Buchanan *************************************************
;*** Created 20140611, Updated 20140617 ****************************************************
;*******************************************************************************************
;Routines:
;	_TCP_Initialize - SERVER/CLIENT: initialize/start TCP functionality
;
;	SERVER SPECIFIC:
;	_TCPServer_Listen - start/stop listening for new connections, or get status of listening port
;	_TCPServer_ConnectNewClients - check for and connect any new clients on the listen port.  returns array of new client elements
;	_TCPServer_SendPacket - send data to specified client, or broadcast to all clients
;	_TCPServer_SendKeepAlive - send keepalive packets to one, or all connected clients to prevent "stale" connection disconnects
;	_TCPServer_GetPacket - receive the next completed packet from client's queue
;	_TCPServer_Disconnect - disconnect from one or all clients, or disconnect "stale" connections
;	_TCPServer_EnableClientBroadcast - enable/disable specified client for broadcasting
;	_TCPServer_ClientBroadcastIsEnabled - receive 1/0 whether or not specified client is broadcast-enabled
;
;	CLIENT SPECIFIC:
;	_TCPClient_Connect - connect client to server
;	_TCPClient_SendPacket - send data from client to server
;	_TCPClient_SendKeepAlive - send keepalive packets to server to prevent "stale" connection disconnects
;	_TCPClient_GetPacket - receive the next completed packet from client's queue
;	_TCPClient_Disconnect - disconnect client from server
;
;	SERVER AND CLIENT:
;	_TCP_SetConnectString - set connection string to be sent when an initial connection is established
;	_TCP_ConnInfo - receive multiple different metrics for connected clients
;
;	OTHER:
;	_TCP_NameToIP - get IP address from computer/hostname
;	_TCP_IPToName - get computer/hostname from IP address
;	_TCP_IPV4IsValid - get whether IPV4 address is valid
;	_TCP_IPV4GetClass - get class of IPV4 address
;	_TCP_SocketToIP - get IP from connected socket
;*******************************************************************************************
#include-once
#include <Date.au3>
#include <Inet.au3>
#include <Crypt.au3> ;for use with _TCP_SocketToIP()
#include <GDIPlus.au3> ;for use with _TCP_SocketToIP()

;TCPTimeout Option (see http://www.autoitscript.com/forum/topic/162028-what-does-option-tcptimeout-do/)
AutoItSetOption("TCPTimeout",0) ;default value of 100ms causes TCPAccept and TCPRecv to run slow.  Setting to 1 to speed up processing, and currently does not appear to have issues.

;TCP SETTINGS
$sTCPEndPacketString = "[![/PKT]!]"
$iTCPReceiveChars = 512 ;number of characters to retrieve from received data each iteration
;$bTCPClientEnableSendComputerName = True ;enable/disable client sending of PC name to server
;$bTCPClientEnableSendUserName = True ;enable/disable client sending of PC name to server
;$sTCPServerConnectString = ""
;$sTCPCLientConnectString = "CNAME=" & @ComputerName & "|UNAME=" & @UserName

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_Initialize - Updated 20140611 -------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCP_Initialize($sServerClientMode,$sIPServerAddress,$iServerPort,$iMaxConnections = 1)
	;should be called at beginning of program to initialize TCP

	;configure TCP shutdown on program exit
	OnAutoItExitRegister("OnAutoItExit_StopTCP")
	;start TCP
	TCPStartup()

	;common values
	Global $sTCPServerClientMode = $sServerClientMode
	Global $sTCPServerIPAddress = $sIPServerAddress
		if Not _TCP_IPV4IsValid($sTCPServerIPAddress) then $sTCPServerIPAddress = _TCP_NameToIP($sTCPServerIPAddress) ;if the ip isn't valid, might be name.  attempt to convert name to ip.
	Global $iTCPServerPort = $iServerPort
	Global $iTCPConnectionsChanged = 1 ;holds 1/0 value to indicate if connection list has been changed

	Switch StringUpper($sServerClientMode)
		Case "SERVER"
			Global $iTCPServerMaxConnections = $iMaxConnections
			Global $iTCPServerListenSocket = 0 ;container for listen socket
			;initialize arrays to hold connection/client data
			Global $iTCPTotalConnectedClients = 0
			Global $aTCPClientState[$iTCPServerMaxConnections],$aTCPClientSocket[$iTCPServerMaxConnections]
			Global $aTCPClientIP[$iTCPServerMaxConnections],$aTCPClientPort[$iTCPServerMaxConnections]
			Global $aTCPClientComputerName[$iTCPServerMaxConnections]
			Global $aTCPClientUserName[$iTCPServerMaxConnections]
			Global $aTCPClientConnectDateTime[$iTCPServerMaxConnections]
			Global $aTCPClientPacketsProcessed[$iTCPServerMaxConnections]
			Global $aTCPClientPacketsSent[$iTCPServerMaxConnections]
			Global $aTCPClientBytesReceived[$iTCPServerMaxConnections]
			Global $aTCPClientBytesSent[$iTCPServerMaxConnections]
			Global $aTCPClientEnableBroadcasting[$iTCPServerMaxConnections]
			Global $aTCPClientReceivedData[$iTCPServerMaxConnections]
			Global $aTCPClientDataLastReceivedTimestamp[$iTCPServerMaxConnections]
			Global $aTCPClientDataLastSendTimestamp[$iTCPServerMaxConnections]
			for $iConn = 0 to $iTCPServerMaxConnections - 1
				_TCP_ResetConnectionValues($iConn)
			next
			;start special functions for use with _TCP_SocketToIP()
			_Crypt_Startup() ; Starts up Crypt
			_GDIPlus_Startup() ; Starts up GDIPlus
			Global $WS2_32 = DllOpen("Ws2_32.dll") ; Opens Ws2_32.dll to be used later.
			Global $NTDLL = DllOpen("ntdll.dll") ; Opens NTDll.dll to be used later.
		Case "CLIENT"
			_TCP_ResetConnectionValues()
	EndSwitch
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION (INTERNAL): _TCP_ResetConnectionValues - Updated 20140613 ---------------------
;-------------------------------------------------------------------------------------------
Func _TCP_ResetConnectionValues($iTCPClientElem = -1)
	;set/reset specific clients variables to initial state

	Switch $iTCPClientElem
		Case -1 ;client-side
			Global $iTCPServerSocket = 0 ;container for connection socket
			Global $sTCPConnState = "" ;container for connection state
			Global $sTCPConnDateTime = "" ;container for connection date/timestamp
			Global $iTCPPacketsProcessed = 0 ;holds number of packets processed by client
			Global $iTCPPacketsSent = 0 ;holds number of packets sent by client
			Global $iTCPBytesReceived = 0 ;holds number of bytes received by client
			Global $iTCPBytesSent = 0 ;holds number of bytes sent by client
			Global $sTCPReceivedData = "" ;container for client received data
			Global $sTCPDataLastReceivedTimestamp = ""
			Global $sTCPDataLastSendTimestamp = ""
		Case Else ;server-side
			$aTCPClientState[$iTCPClientElem] = ""
			$aTCPClientSocket[$iTCPClientElem] = 0
			$aTCPClientIP[$iTCPClientElem] = ""
			$aTCPClientPort[$iTCPClientElem] = 0
			$aTCPClientComputerName[$iTCPClientElem] = ""
			$aTCPClientUserName[$iTCPClientElem] = ""
			$aTCPClientConnectDateTime[$iTCPClientElem] = ""
			$aTCPClientPacketsProcessed[$iTCPClientElem] = 0
			$aTCPClientPacketsSent[$iTCPClientElem] = 0
			$aTCPClientBytesReceived[$iTCPClientElem] = 0
			$aTCPClientBytesSent[$iTCPClientElem] = 0
			$aTCPClientReceivedData[$iTCPClientElem] = ""
			$aTCPClientDataLastReceivedTimestamp[$iTCPClientElem] = ""
			$aTCPClientDataLastSendTimestamp[$iTCPClientElem] = ""
			$aTCPClientEnableBroadcasting[$iTCPClientElem] = 0
	EndSwitch
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCP_SetConnectString - Updated 20140616 -------------------------------------
;-------------------------------------------------------------------------------------------
Global $sTCPConnectString = ""
Func _TCP_SetConnectString($sConnString)
	;set the connection string to be sent when an initial connection has been established
	;you can indicate multiple packets by separating the "packets" by pipe (|)
	$sConnString = StringReplace($sConnString,"|",$sTCPEndPacketString)
	$sTCPConnectString = $sConnString
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_Listen - Updated 20140615 -----------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_Listen($iEnable = -1)
	;open or close listen port, or return listening port (or 0 if not listening)
	;$iEnable:
	;	1 - attempt to open listen port.
	;	0 - close listen port.
	;	nothing - just returns listening socket (0 if not listening).

	Switch $iEnable
		Case 1 ;start listening
			$iTCPServerListenSocket = TCPListen($sTCPServerIPAddress, $iTCPServerPort, $iTCPServerMaxConnections)
			if @error Then $iTCPServerListenSocket = 0
		Case 0 ;stop listening
			TCPCloseSocket($iTCPServerListenSocket)
			$iTCPServerListenSocket = 0
	EndSwitch

	Return $iTCPServerListenSocket
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_ConnectNewClients - Updated 20140611 -------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_ConnectNewClients()
	;check for and accept any new TCP connections.  adds all new connections to client arrays
	;returns pipe separated list of new connection elements

	;Local $iNewConnections = 0
	Local $aNewConnectionElems[0],$iNumNewConnectedElems = 0
	Do
		$iNewSocket = TCPAccept($iTCPServerListenSocket)
		if $iNewSocket <> -1 Then
			;maximum connections reached?
			if $iTCPTotalConnectedClients = $iTCPServerMaxConnections Then
				TCPSend($iNewSocket,"[TCP_TOOMANYCONNECTIONS]" & $sTCPEndPacketString)
				TCPCloseSocket($iNewSocket)
				Return 0
			EndIf
			;add to connection list
			for $iConn = 0 to $iTCPServerMaxConnections - 1
				if $aTCPClientState[$iConn] = "" Then
					$aTCPClientState[$iConn] = "CONNECTED"
					$aTCPClientSocket[$iConn] = $iNewSocket
					$aTCPClientIP[$iConn] = _TCP_SocketToIP($iNewSocket)
					$aTCPClientComputerName[$iConn] = _TCP_IPToName($aTCPClientIP[$iConn])
					;$aTCPClientPort[$iConn] = "..."
					$aTCPClientConnectDateTime[$iConn] = _NowCalc()
					$aTCPClientPacketsProcessed[$iConn] = 0
					$iTCPTotalConnectedClients = $iTCPTotalConnectedClients + 1
					;add new connection to connected elems array
					if UBound($aNewConnectionElems) = 0 then
						ReDim $aNewConnectionElems[UBound($aNewConnectionElems) + 1]
					Else
						ReDim $aNewConnectionElems[UBound($aNewConnectionElems)]
					EndIf
					$aNewConnectionElems[UBound($aNewConnectionElems) - 1] = $iConn
					;
					$iTCPConnectionsChanged = 1
					_TCPServer_SendPacket($iConn,$sTCPConnectString) ;send initial connection string
					ExitLoop
				EndIf
			Next
		EndIf
	Until $iNewSocket = -1 or $iTCPTotalConnectedClients = $iTCPServerMaxConnections

	Return $aNewConnectionElems
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_SendPacket - Updated 20140613 -------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_SendPacket($iTCPClientElem,$sDataToSend)
	;send data to specified client socket, or broadcast to all
	;returns number of successful client sends
	;$iTCPClientElem -
	;	-1 = broadcast to all connected clients
	;	>-1 = send to specified client element
	;$sDataToSend - string data to be sent.  If "", nothing will be sent.

	if $sDataToSend = "" then Return 0 ;nothing to send.  no need to waste resources.

	;broadcast to all connected clients
	if $iTCPClientElem = -1 Then
		Local $iSuccessfulSends = 0
		for $iConn = 0 to $iTCPServerMaxConnections - 1
			local $iSuccess = _TCPServer_SendPacket($iConn,$sDataToSend)
			if $iSuccess = 1 then $iSuccessfulSends = $iSuccessfulSends + 1
		Next
		Return $iSuccessfulSends
	EndIf

	;send to specified client
	if Not _TCP_ConnInfo("IsConnected",$iTCPClientElem) Then Return 0

	TCPSend($aTCPClientSocket[$iTCPClientElem],$sDataToSend & $sTCPEndPacketString)
	if @error Then ;TCP error.  disconnect
		_TCPServer_Disconnect($iTCPClientElem)
		Return 0
	Else
		$aTCPClientPacketsSent[$iTCPClientElem] = $aTCPClientPacketsSent[$iTCPClientElem] + 1 ;increment number of packets sent for this client
		$aTCPClientBytesSent[$iTCPClientElem] = $aTCPClientBytesSent[$iTCPClientElem] + StringLen($sDataToSend) ;add bytes sent for this client
		$aTCPClientDataLastSendTimestamp[$iTCPClientElem] = _NowCalc() ;update last send timestamp
		Return 1
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_SendKeepAlive - Updated 20140617 ----------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_SendKeepAlive($iSeconds,$iTCPClientElem = -1)
	;send keepalive packets at specified intervals if no other data is being sent

	;broadcast keepalive to all connected clients
	if $iTCPClientElem = -1 Then
		Local $iSuccessfulSends = 0
		for $iConn = 0 to $iTCPServerMaxConnections - 1
			local $iSuccess = _TCPServer_SendKeepAlive($iConn,"[TCP_KEEPALIVE]")
			if $iSuccess = 1 then $iSuccessfulSends = $iSuccessfulSends + 1
		Next
		Return $iSuccessfulSends
	EndIf

	;send keepalive to specified client
	if _DateDiff("s",$aTCPClientDataLastSendTimestamp[$iTCPClientElem],_NowCalc()) >= $iSeconds Then _TCPServer_SendPacket($iTCPClientElem,"[TCP_KEEPALIVE]")
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_GetPacket - Updated 20140611 --------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_GetPacket($iTCPClientElem)
	;parse specified client's data queue and retrieve next packet
	;returns full packet

	if Not _TCP_ConnInfo("IsConnected",$iTCPClientElem) then Return

	;first, see if there is any data in the TCP stack to add to the client's pre-process queue
	Local $sReceivedData = ""
	for $iIter = 1 to 5
		$sReceivedData = TCPRecv($aTCPClientSocket[$iTCPClientElem], $iTCPReceiveChars)
		Switch @error
			Case 0 ;no error.  process normally
				if $sReceivedData <> "" Then
					;add received data to client's data queue
					$aTCPClientReceivedData[$iTCPClientElem] = $aTCPClientReceivedData[$iTCPClientElem] & $sReceivedData
					$aTCPClientDataLastReceivedTimestamp[$iTCPClientElem] = _NowCalc() ;mark the last data received timestamp
				EndIf
			Case -1 ;if using AutoIt 3.3.10.0 or higher, this error is actually "no data received", not an error.  This error code does not exist in previous versions of AutoIt.
				$sReceivedData = ""
			Case Else ;TCP error.  disconnect
				_TCPServer_Disconnect($iTCPClientElem)
				$sReceivedData = ""
		EndSwitch
		if $sReceivedData = "" then ExitLoop
	Next

	;extract next packet from received data
	Local $sPacket = ""
	if StringInStr($aTCPClientReceivedData[$iTCPClientElem],$sTCPEndPacketString) > 0 Then
		$sPacket = StringLeft($aTCPClientReceivedData[$iTCPClientElem],StringInStr($aTCPClientReceivedData[$iTCPClientElem],$sTCPEndPacketString) - 1)
		$aTCPClientReceivedData[$iTCPClientElem] = StringRight($aTCPClientReceivedData[$iTCPClientElem],StringLen($aTCPClientReceivedData[$iTCPClientElem]) - (StringLen($sPacket & $sTCPEndPacketString)))
		$aTCPClientPacketsProcessed[$iTCPClientElem] = $aTCPClientPacketsProcessed[$iTCPClientElem] + 1 ;increment count of total packets processed from client
		$aTCPClientBytesReceived[$iTCPClientElem] = $aTCPClientBytesReceived[$iTCPClientElem] + StringLen($sPacket) ;add bytes received from this client
	EndIf

	;process special TCP packets
	Switch $sPacket
		Case "[TCP_DISCONNECT]" ;disconnect
			_TCPServer_Disconnect($iTCPClientElem)
			$sPacket = ""
		Case "[TCP_KEEPALIVE]" ;keepalive packet.  no need to do anything
			$sPacket = ""
	EndSwitch

	;if this client is broadcast-enabled, rebroadcast to other clients
	if $sPacket <> "" Then
		if _TCPServer_ClientBroadcastIsEnabled($iTCPClientElem) Then
			for $iBCClient = 0 to $iTCPServerMaxConnections - 1
				if $iBCClient <> $iTCPClientElem then _TCPServer_SendPacket($iBCClient,$sPacket)
			Next
		EndIf
	EndIf

	Return $sPacket
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_EnableClientBroadcast - Updated 20140613 --------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_EnableClientBroadcast($iTCPClientElem,$iEnable = 1)
	;enables/disables specified client broadcast
	if _TCP_ConnInfo("IsConnected",$iTCPClientElem) Then $aTCPClientEnableBroadcasting[$iTCPClientElem] = $iEnable
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_ClientBroadcastIsEnabled - Updated 20140613 -----------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_ClientBroadcastIsEnabled($iTCPClientElem)
	;returns 1/0 if specified client is broadcast-enabled
	Return $aTCPClientEnableBroadcasting[$iTCPClientElem]
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCP_ConnInfo - Updated 20140616 ---------------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCP_ConnInfo($sMetric,$iTCPClientElem = -1)
	;retrieve specified connection metrics

	Switch StringUpper($sMetric)
		Case "NUMCONNECTED"
			;returns number of current connections
			if $sTCPServerClientMode = "SERVER" Then Return $iTCPTotalConnectedClients
			if $sTCPServerClientMode = "CLIENT" Then
				if $sTCPConnState = "CONNECTED" Then
					Return 1
				Else
					Return 0
				EndIf
			EndIf
		Case "ISCONNECTED"
			;returns 1/0 whether specified client is connected
			if ($sTCPServerClientMode = "SERVER" and $aTCPClientState[$iTCPClientElem] = "CONNECTED") or _
			($sTCPServerClientMode = "CLIENT" and $sTCPConnState = "CONNECTED") Then
				Return 1
			Else
				Return 0
			EndIf
		Case "CONNECTIONSCHANGED"
			;returns 1/0 value to indicate if connection list has changed.  NOTE: resets to 0 when called
			;good for checking when you need to update a client list, or other functions related to changed connections
			Local $iTempValue = $iTCPConnectionsChanged
			$iTCPConnectionsChanged = 0 ;reset original value to 0
			Return $iTempValue
		Case "PACKETSINQUEUE"
			;returns count of packets still in pre-process queue
			if $sTCPServerClientMode = "SERVER" Then $sQueuedData = $aTCPClientReceivedData[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then $sQueuedData = $sTCPReceivedData
			;count number of full packets in queue
			Local $iPacketCount = 0
			While StringInStr($sQueuedData,$sTCPEndPacketString,0,$iPacketCount + 1) > 0
				$iPacketCount = $iPacketCount + 1
			WEnd
			Return $iPacketCount
		Case "PACKETSPROCESSED"
			;returns count of packets that have been processed from specified client
			if $sTCPServerClientMode = "SERVER" Then Return $aTCPClientPacketsProcessed[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then Return $iTCPPacketsProcessed
		Case "PACKETSSENT"
			;returns count of packets that have been sent to specified client
			if $sTCPServerClientMode = "SERVER" Then Return $aTCPClientPacketsSent[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then Return $iTCPPacketsSent
		Case "BYTESINQUEUE"
			;returns number of bytes of data waiting to be processed in the received queue
			if $sTCPServerClientMode = "SERVER" Then Return StringLen($aTCPClientReceivedData[$iTCPClientElem])
			if $sTCPServerClientMode = "CLIENT" Then Return StringLen($sTCPReceivedData)
		Case "BYTESSENT"
			;returns number of bytes that have been sent
			if $sTCPServerClientMode = "SERVER" Then Return $aTCPClientBytesSent[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then Return $iTCPBytesSent
		Case "BYTESPROCESSED"
			;returns number of bytes that have been sent
			if $sTCPServerClientMode = "SERVER" Then Return $aTCPClientBytesReceived[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then Return $iTCPBytesReceived
		Case "CONNTIME"
			;returns connection date/timestamp
			if $sTCPServerClientMode = "SERVER" and _TCP_ConnInfo("IsConnected",$iTCPClientElem) then Return $aTCPClientConnectDateTime[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" and _TCP_ConnInfo("IsConnected") then Return $sTCPConnDateTime
			Return 0
		Case "CONNTIMEELAPSED"
			;return elapsed connection time (in seconds)
			if $sTCPServerClientMode = "SERVER" and _TCP_ConnInfo("IsConnected",$iTCPClientElem) then Return _DateDiff("s",$aTCPClientConnectDateTime[$iTCPClientElem],_NowCalc())
			if $sTCPServerClientMode = "CLIENT" and _TCP_ConnInfo("IsConnected") then Return _DateDiff("s",$sTCPConnDateTime,_NowCalc())
			Return 0
		Case "LASTPACKETRECEIVETIME"
			;returns timestamp last data was received
			if $sTCPServerClientMode = "SERVER" Then Return $aTCPClientDataLastReceivedTimestamp[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then Return $sTCPDataLastReceivedTimestamp
		Case "LASTPACKETRECEIVETIMEELAPSED"
			;return elapsed time since last packet received (in seconds)
			if $sTCPServerClientMode = "SERVER" and _TCP_ConnInfo("IsConnected",$iTCPClientElem) then Return _DateDiff("s",$aTCPClientDataLastReceivedTimestamp[$iTCPClientElem],_NowCalc())
			if $sTCPServerClientMode = "CLIENT" and _TCP_ConnInfo("IsConnected") then Return _DateDiff("s",$sTCPDataLastReceivedTimestamp,_NowCalc())
			Return 0
		Case "LASTPACKETSENDTIME"
			;returns timestamp of last data send
			if $sTCPServerClientMode = "SERVER" Then Return $aTCPClientDataLastSendTimestamp[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then Return $sTCPDataLastSendTimestamp
		Case "LASTPACKETSENDTIMEELAPSED"
			;return elapsed time since last packet sent (in seconds)
			if $sTCPServerClientMode = "SERVER" and _TCP_ConnInfo("IsConnected",$iTCPClientElem) then Return _DateDiff("s",$aTCPClientDataLastSendTimestamp[$iTCPClientElem],_NowCalc())
			if $sTCPServerClientMode = "CLIENT" and _TCP_ConnInfo("IsConnected") then Return _DateDiff("s",$sTCPDataLastSendTimestamp,_NowCalc())
			Return 0
		Case "SOCKET"
			;returns socket number of connected client
			if $sTCPServerClientMode = "SERVER" Then Return $aTCPClientSocket[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" Then Return $iTCPServerSocket
		Case "IPADDRESS"
			;return ip address of connected client/server
			If $sTCPServerClientMode = "SERVER" then Return $aTCPClientIP[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" and _TCP_ConnInfo("IsConnected") then Return _TCP_SocketToIP($iTCPServerSocket)
		Case "COMPUTERNAME"
			;return computer name of connected client/server
			If $sTCPServerClientMode = "SERVER" then Return $aTCPClientComputerName[$iTCPClientElem]
			if $sTCPServerClientMode = "CLIENT" and _TCP_ConnInfo("IsConnected") then Return _TCP_IPToName(_TCP_SocketToIP($iTCPServerSocket))
		Case Else
			Return 0
	EndSwitch
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_Disconnect - Updated 20140611 -------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_Disconnect($iTCPClientElem = -1,$iStaleSeconds = -1)
	;disconnect specified, or all, client(s), and reset values
	;if $iTCPClientElem = -1 or is unspecified, will disconnect all clients
	;If you only want to disconnect "stale" connections, provide $iStaleSeconds.

	;disconnect all connected clients
	if $iTCPClientElem = -1 Then
		for $iConn = 0 to $iTCPServerMaxConnections - 1
			if $iStaleSeconds = -1 or ($iStaleSeconds > -1 and _TCP_ConnInfo("LASTPACKETRECEIVETIMEELAPSED",$iConn) >= $iStaleSeconds) Then
				_TCPServer_Disconnect($iConn)
			EndIf
		Next
		Return
	EndIf

	;disconnect specified client
	if _TCP_ConnInfo("IsConnected",$iTCPClientElem) then
		TCPSend($aTCPClientSocket[$iTCPClientElem],"[TCP_DISCONNECT]" & $sTCPEndPacketString)
		TCPCloseSocket($aTCPClientSocket[$iTCPClientElem])
		$iTCPConnectionsChanged = 1
		;reset client/socket specific values
		if $aTCPClientSocket[$iTCPClientElem] <> 0 then $iTCPTotalConnectedClients = $iTCPTotalConnectedClients - 1
		_TCP_ResetConnectionValues($iTCPClientElem)
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_Connect - Updated 20140611 ----------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_Connect()
	;connect client to server

	if _TCP_ConnInfo("IsConnected") Then Return 0 ;if already connected, don't try to connect again

	$iTCPServerSocket = TCPConnect($sTCPServerIPAddress,$iTCPServerPort)
	if $iTCPServerSocket <> -1 Then
		$sTCPConnState = "CONNECTED"
		$iTCPConnectionsChanged = 1
		$sTCPConnDateTime = _NowCalc()
		_TCPClient_SendPacket($sTCPConnectString) ;send client initial connection string
		Return 1
	Else
		_TCPClient_Disconnect()
		Return 0
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_GetPacket - Updated 20140611 --------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_GetPacket()
	;parse client data queue and retrieve next packet

	if Not _TCP_ConnInfo("IsConnected") Then Return ""

	;first, see if there is any data in the TCP stack to add to the client's pre-process queue
	Local $sReceivedData = ""
	for $iIter = 1 to 5
		$sReceivedData = TCPRecv($iTCPServerSocket,$iTCPReceiveChars)
		Switch @error
			Case 0 ;no error.  process normally
				if $sReceivedData <> "" Then
					$sTCPReceivedData = $sTCPReceivedData & $sReceivedData
					$sTCPDataLastReceivedTimestamp = _NowCalc() ;mark the last data received timestamp
				EndIf
			Case -1 ;if using AutoIt 3.3.10.0 or higher, this error is actually "no data received", not an error.  This error code does not exist in previous versions of AutoIt.
				$sReceivedData = ""
			Case Else ;TCP error.  disconnect
				_TCPClient_Disconnect()
				$sReceivedData = ""
		EndSwitch
		if $sReceivedData = "" then ExitLoop
	Next

	;extract next packet from received data
	Local $sPacket = ""
	if StringInStr($sTCPReceivedData,$sTCPEndPacketString) > 0 Then
		$sPacket = StringLeft($sTCPReceivedData,StringInStr($sTCPReceivedData,$sTCPEndPacketString) - 1)
		$sTCPReceivedData = StringRight($sTCPReceivedData,StringLen($sTCPReceivedData) - (StringLen($sPacket & $sTCPEndPacketString)))
		$iTCPPacketsProcessed = $iTCPPacketsProcessed + 1 ;increment number of packets processed by client
		$iTCPBytesReceived = $iTCPBytesReceived + StringLen($sPacket) ;add bytes received by client
	EndIf

	;process special packets
	Switch $sPacket
		Case "[TCP_DISCONNECT]","[TCP_TOOMANYCONNECTIONS]" ;disconnect
			_TCPClient_Disconnect()
			$sPacket = ""
		Case "[TCP_KEEPALIVE]" ;keepalive packet.  no need to do anything.
			$sPacket = ""
	EndSwitch

	Return $sPacket
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_SendPacket - Updated 20140611 -------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_SendPacket($sDataToSend)
	;send data to server

	if Not _TCP_ConnInfo("IsConnected") Then Return 0

	TCPSend($iTCPServerSocket,$sDataToSend & $sTCPEndPacketString)
	if @error Then ;TCP error.  disconnect
		_TCPClient_Disconnect()
		Return 0
	Else
		$iTCPPacketsSent = $iTCPPacketsSent + 1 ;update number of packets sent
		$iTCPBytesSent = $iTCPBytesSent + StringLen($sDataToSend) ;update number of bytes sent
		$sTCPDataLastSendTimestamp = _NowCalc() ;update last send timestamp
		Return 1
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_SendKeepAlive - Updated 20140611 ----------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_SendKeepAlive($iSeconds)
	;send keepalive packets at specified intervals if no other data is being sent

	if Not _TCP_ConnInfo("IsConnected") Then Return ""

	if _DateDiff("s",$sTCPDataLastSendTimestamp,_NowCalc()) >= $iSeconds Then _TCPClient_SendPacket("[TCP_KEEPALIVE]")
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_Disconnect - Updated 20140611 -------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_Disconnect()
	;disconnect client from server

	if Not _TCP_ConnInfo("IsConnected") Then Return

	TCPSend($iTCPServerSocket,"[TCP_DISCONNECT]" & $sTCPEndPacketString)
	TCPCloseSocket($iTCPServerSocket)
	$iTCPConnectionsChanged = 1
	_TCP_ResetConnectionValues()
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPSocketToIP - Updated 20140306 --------------------------------------------
;-- Taken from: http://www.autoitscript.com/forum/topic/137221-fast-multi-client-tcp-server/
;-------------------------------------------------------------------------------------------
Func _TCP_SocketToIP($iSocket)
	;return IP address of connected socket

	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	Local $aRet = DllCall($WS2_32, "int", "getpeername", "int", $iSocket, "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall($WS2_32, "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = "0.0.0.0"
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCP_NameToIP - Updated 20140616 ---------------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCP_NameToIP($sComputerName)
	;returns IP from computer name
	;Note: TCPStartup() must have been run beforehand for this function to work

	Return TCPNameToIP($sComputerName)
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCP_IPToName - Updated 20140616 ---------------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCP_IPToName($sIPAddress)
	;returns computer/hostname from IP address
	;Note: TCPStartup() must have been run beforehand for this function to work

	Return _TCPIpToName($sIPAddress)
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCP_IPV4IsValid - Updated 20140616 ------------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCP_IPV4IsValid($sIPAddress)
	;return 1/0 if IPV4 address is valid

	if _TCP_IPV4GetClass($sIPAddress) = "" Then Return 0
	Return 1
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCP_IPV4GetClass - Updated 20140616 -----------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCP_IPV4GetClass($sIPAddress)
	;returns network class to which an IP belongs.  "" if invalid.

	;split ip address into separate numbers
	Local $aIPParts = StringSplit($sIPAddress,".",2)

	;verify parts are valid
	if UBound($aIPParts) <> 4 then return "" ;was not valid ip (did not contain correct number of numbers)
	for $n in $aIPParts
		if Not StringIsDigit($n) or $n < 0 or $n > 255 then Return ""
	Next

	;determine class
	Switch $aIPParts[0]
		Case 0 ;???
		Case 1 to 126
			if $aIPParts[0] = 10 Then Return "A-PRIVATE"
			Return "A"
		Case 127
			Return "LOOPBACK"
		Case 128 to 191
			if $aIPParts[0] = 172 and ($aIPParts[1] >= 16 and $aIPParts[1] <= 31) then Return "B-PRIVATE"
			Return "B"
		Case 192 to 223
			If $aIPParts[0] = 192 and $aIPParts[1] = 168 Then Return "C-PRIVATE"
			Return "C"
		Case 224 to 239
			Return "D"
	EndSwitch
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: OnAutoItExit_StopTCP - Updated 20140611 --------------------------------------
;-------------------------------------------------------------------------------------------
Func OnAutoItExit_StopTCP()
	;shut down TCP when application is closed

	Switch StringUpper($sTCPServerClientMode)
		Case "SERVER"
			_TCPServer_Listen(0)
			_TCPServer_Disconnect()
			;special functions for use with _TCP_SocketToIP()
			_GDIPlus_Shutdown()
			_Crypt_Shutdown()
			DllClose($NTDLL)
			DllClose($WS2_32)
		Case "CLIENT"
			_TCPClient_Disconnect()
	EndSwitch

    TCPShutdown()
EndFunc