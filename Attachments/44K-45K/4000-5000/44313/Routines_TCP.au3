;*******************************************************************************************
;*** AUTOIT TCP ROUTINES by Geoff Buchanan *************************************************
;*** Created 20140611, Updated 20140612 ****************************************************
;*******************************************************************************************
;Routines:
;	_TCP_Initialize - initialize/start TCP functionality
;	_TCPServer_StartListen - start listening for any new connections
;	_TCPServer_StopListen - stop listening for new connections
;	_TCPServer_CheckForNewConnections - check for any new connections on the listen port
;	_TCPServer_SendData - send data to client
;	_TCPServer_ReceiveData - check TCP for any received data into the specified client's pre-process queue
;	_TCPServer_GetNextPacket - receive the next completed packet from client's pre-process queue
;	_TCPServer_Disconnect - disconnect from one or all clients
;	_TCPClient_Connect - connect client to server
;	_TCPClient_ReceiveData - check TCP for any received data into the client's pre-process queue
;	_TCPClient_GetNextPacket - receive the next completed packet from client's pre-process queue
;	_TCPClient_SendData - send data from client to server
;	_TCPClient_Disconnect - disconnect client from server
;*******************************************************************************************

#include-once

#cs
	;SAMPLE TCP SERVER:
	#include "Routines_TCP.au3"
	Global $sServerIP = "127.0.0.1",$iServerPort = 54321
	Global $iTotalConnectionsAllowed = 5

	_TCP_Initialize("SERVER",$sServerIP,$iServerPort,$iTotalConnectionsAllowed)
	_TCPServer_StartListen()
	While 1
		_TCPServer_CheckForNewConnections() ;check for any new connections

		;retrieve any new data for connected clients
		for $iClient = 0 to $iTotalConnectionsAllowed - 1
			_TCPServer_ReceiveData($iClient) ;client-specific retrieval
			$sReceivedPacket = _TCPServer_GetNextPacket($iClient)
			... do stuff to process the packet ...
		Next

		;send data to clients
		for $iClient = 0 to $iTotalConnectionsAllowed - 1
			_TCPServer_SendData($iClient,"Here I am")
		Next

		sleep(10)

		;stop listening for new clients
		_TCPServer_StopListen()

		;disconnect all clients
		_TCPServer_Disconnect(-1)
	WEnd

	;SAMPLE TCP CLIENT:
	#include "Routines_TCP.au3"
	Global $sServerIP = "127.0.0.1",$iServerPort = 54321
	_TCP_Initialize("CLIENT",$sServerIP,$iServerPort)
	_TCPClient_Connect()
	While 1
		;retrieve any new data into client's TCP queue
		TCPClient_ReceiveData()

		;get next received packet
		$sReceivedPacket = _TCPClient_GetNextPacket()
		... do stuff to process the packet ...

		;send data to server
		_TCPClient_SendData("I'm here too")

		;disconnect from server
		_TCPClient_Disconnect()
	WEnd
#ce


;COMMON VALUES
$sTCPEndPacketString = "[ENDPACKET]"
$iTCPReceiveChars = 128 ;number of characters to retrieve from received data each iteration

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
	Global $iTCPServerPort = $iServerPort

	Switch StringUpper($sServerClientMode)
		Case "SERVER"
			Global $iTCPServerMaxConnections = $iMaxConnections
			Global $iTCPServerListenSocket = 0 ;container for listen socket
			;initialize arrays to hold connection/client data
			Global $iTCPTotalConnectedClients = 0
			Global $aTCPClientState[$iTCPServerMaxConnections],$aTCPClientSocket[$iTCPServerMaxConnections]
			Global $aTCPClientIP[$iTCPServerMaxConnections],$aTCPClientPort[$iTCPServerMaxConnections]
			Global $aTCPClientReceivedData[$iTCPServerMaxConnections]
			for $iConn = 0 to $iTCPServerMaxConnections - 1
				$aTCPClientState[$iConn] = ""
				$aTCPClientSocket[$iConn] = 0
				$aTCPClientIP[$iConn] = ""
				$aTCPClientPort[$iConn] = 0
				$aTCPClientReceivedData[$iConn] = ""
			next
		Case "CLIENT"
			Global $iTCPServerSocket = 0 ;container for connection socket
			Global $sTCPConnState = "" ;container for connection state
			Global $sTCPReceivedData = "" ;container for client received data
	EndSwitch
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_StartListen/StopListen - Updated 20140611 -------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_StartListen()
	;open TCP server listen port for listening
	;returns 0 if failure to open listen port, or socket number if successful

	$iTCPServerListenSocket = TCPListen($sTCPServerIPAddress, $iTCPServerPort, $iTCPServerMaxConnections)
	if @error Then return 0
	Return $iTCPServerListenSocket
EndFunc

Func _TCPServer_StopListen()
	;stop listening for new connections

	TCPCloseSocket($iTCPServerListenSocket)
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_CheckForNewConnections - Updated 20140611 -------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_CheckForNewConnections()
	;check for and accept any new TCP connections.  adds all new connections to client arrays
	;returns number of new connections established

	Local $iNewConnections = 0
	Do
		$iNewSocket = TCPAccept($iTCPServerListenSocket)
		if $iNewSocket <> -1 Then
			;maximum connections reached?
			if $iTCPTotalConnectedClients = $iTCPServerMaxConnections Then
				TCPSend($iNewSocket,"[TCPTOOMANYCONNECTIONS]" & $sTCPEndPacketString)
				TCPCloseSocket($iNewSocket)
				Return 0
			EndIf
			;add to connection list
			for $iConn = 0 to $iTCPServerMaxConnections - 1
				if $aTCPClientState[$iConn] = "" Then
					$aTCPClientState[$iConn] = "CONNECTED"
					$aTCPClientSocket[$iConn] = $iNewSocket
					$aTCPClientIP[$iConn] = "..."
					$aTCPClientPort[$iConn] = "..."
					$iTCPTotalConnectedClients = $iTCPTotalConnectedClients + 1
					$iNewConnections = $iNewConnections + 1
					_TCPServer_SendData($iConn,"[TCPCONNECTED]")
					ExitLoop
				EndIf
			Next
		EndIf
	Until $iNewSocket = -1 or $iTCPTotalConnectedClients = $iTCPServerMaxConnections

	Return $iNewConnections
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_SendData - Updated 20140611 ---------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_SendData($iClientNum,$sDataToSend)
	;send data to specified client socket
	;returns 0 if failure, or 1 for success

	if $aTCPClientState[$iClientNum] = "CONNECTED" Then
		TCPSend($aTCPClientSocket[$iClientNum],$sDataToSend & $sTCPEndPacketString)
		if @error Then
			_TCPServer_Disconnect($iClientNum)
			Return 0
		Else
			Return 1
		EndIf
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_ReceiveData - Updated 20140611 ------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_ReceiveData($iClientNum)
    ;retrieve any new data from specified client socket and add to client's received data queue

    If $aTCPClientState[$iClientNum] = "CONNECTED" Then
        Local $sReceivedData
        ;Do
		for $iIter = 1 to 5
			$sReceivedData = TCPRecv($aTCPClientSocket[$iClientNum], $iTCPReceiveChars)
			Switch @error
				Case 0 ;no error.  process normally
					if $sReceivedData <> "" Then $aTCPClientReceivedData[$iClientNum] = $aTCPClientReceivedData[$iClientNum] & $sReceivedData
				Case -1 ;if using AutoIt 3.3.10.0 or higher, this error is actually "no data received", not an error.  This error code does not exist in previous versions of AutoIt.
					$sReceivedData = ""
				Case Else ;TCP error.  disconnect
					_TCPServer_Disconnect($iClientNum)
					$sReceivedData = ""
			EndSwitch
			Sleep(5)
			if $sReceivedData = "" then ExitLoop
		Next
        ;Until $sReceivedData = ""
    EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_GetNextPacket - Updated 20140611 ----------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_GetNextPacket($iClientNum)
	;parse specified client's data queue and retrieve next packet
	;returns full packet

	Local $sPacket = ""

	if StringInStr($aTCPClientReceivedData[$iClientNum],$sTCPEndPacketString) > 0 Then
		$sPacket = StringLeft($aTCPClientReceivedData[$iClientNum],StringInStr($aTCPClientReceivedData[$iClientNum],$sTCPEndPacketString) - 1)
		$aTCPClientReceivedData[$iClientNum] = StringRight($aTCPClientReceivedData[$iClientNum],StringLen($aTCPClientReceivedData[$iClientNum]) - (StringLen($sPacket & $sTCPEndPacketString)))
	EndIf

	;process special packets
	Switch $sPacket
		Case "[TCPDISCONNECT]"
			_TCPServer_Disconnect($iClientNum)
	EndSwitch

	Return $sPacket
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPServer_Disconnect - Updated 20140611 -------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPServer_Disconnect($iClientNum = -1)
	;disconnect specified, or all, client(s), and reset values
	;if $iClientNum = -1 or is unspecified, will disconnect all clients

	for $iConn = 0 to $iTCPServerMaxConnections - 1
		if $iClientNum = -1 or $iConn = $iClientNum Then
			if $aTCPClientState[$iConn] = "CONNECTED" then
				TCPSend($aTCPClientSocket[$iConn],"[TCPDISCONNECT]" & $sTCPEndPacketString)
				TCPCloseSocket($aTCPClientSocket[$iConn])
				;reset socket specific values
				if $aTCPClientSocket[$iConn] <> 0 then $iTCPTotalConnectedClients = $iTCPTotalConnectedClients - 1
				$aTCPClientState[$iConn] = ""
				$aTCPClientSocket[$iConn] = 0
				$aTCPClientIP[$iConn] = ""
				$aTCPClientPort[$iConn] = 0
				$aTCPClientReceivedData[$iConn] = ""
			EndIf
		EndIf
	next
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_Connect - Updated 20140611 ----------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_Connect()
	;connect client to server

	$iTCPServerSocket = TCPConnect($sTCPServerIPAddress,$iTCPServerPort)
	if $iTCPServerSocket <> -1 Then
		$sTCPConnState = "CONNECTED"
		Return 1
	Else
		_TCPClient_Disconnect()
		Return 0
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_ReceiveData - Updated 20140611 ------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_ReceiveData()
	;check for any data received from server

	if $sTCPConnState = "CONNECTED" Then
		Local $sReceivedData = ""
		;Do
		for $iIter = 1 to 5
			$sReceivedData = TCPRecv($iTCPServerSocket,$iTCPReceiveChars)
			Switch @error
				Case 0 ;no error.  process normally
					if $sReceivedData <> "" Then $sTCPReceivedData = $sTCPReceivedData & $sReceivedData
				Case -1 ;if using AutoIt 3.3.10.0 or higher, this error is actually "no data received", not an error.  This error code does not exist in previous versions of AutoIt.
					$sReceivedData = ""
				Case Else ;TCP error.  disconnect
					_TCPClient_Disconnect()
					$sReceivedData = ""
			EndSwitch
			Sleep(5)
			if $sReceivedData = "" then ExitLoop
		Next
		;Until $sReceivedData = ""
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_GetNextPacket - Updated 20140611 ----------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_GetNextPacket()
	;parse client data queue and retrieve next packet

	Local $sPacket = ""

	if StringInStr($sTCPReceivedData,$sTCPEndPacketString) > 0 Then
		$sPacket = StringLeft($sTCPReceivedData,StringInStr($sTCPReceivedData,$sTCPEndPacketString) - 1)
		$sTCPReceivedData = StringRight($sTCPReceivedData,StringLen($sTCPReceivedData) - (StringLen($sPacket & $sTCPEndPacketString)))
	EndIf

		;process special packets
	Switch $sPacket
		Case "[TCPDISCONNECT]","[TCPTOOMANYCONNECTIONS]"
			_TCPClient_Disconnect()
	EndSwitch


	Return $sPacket
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_SendData - Updated 20140611 ---------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_SendData($sDataToSend)
	;send data to server

	if $sTCPConnState = "CONNECTED" Then
		TCPSend($iTCPServerSocket,$sDataToSend & $sTCPEndPacketString)
		if @error Then _TCPClient_Disconnect()
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _TCPClient_Disconnect - Updated 20140611 -------------------------------------
;-------------------------------------------------------------------------------------------
Func _TCPClient_Disconnect()
	;disconnect client from server

	if $sTCPConnState = "CONNECTED" Then
		TCPSend($iTCPServerSocket,"[TCPDISCONNECT]" & $sTCPEndPacketString)
		TCPCloseSocket($iTCPServerSocket)
		$sTCPConnState = ""
		$iTCPServerSocket = 0
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: OnAutoItExit_StopTCP - Updated 20140611 --------------------------------------
;-------------------------------------------------------------------------------------------
Func OnAutoItExit_StopTCP()
	;shut down TCP when application is closed

	Switch StringUpper($sTCPServerClientMode)
		Case "SERVER"
			_TCPServer_StopListen()
			_TCPServer_Disconnect()
		Case "CLIENT"
			_TCPClient_Disconnect()
	EndSwitch

    TCPShutdown()
EndFunc