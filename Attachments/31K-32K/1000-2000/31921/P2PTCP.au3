#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Hyperzap.
				 Design concepts were first coined by Kip in his "Event driven TCP UDF"
				 Zatorg's Asynchronous Sockets UDF is also used.
 Script Function:
 
	This UDF is a re-write of Kip's 'Event driven TCP UDF'. Thx Kip.
	It aims to generate simple TCP, event driven functionality for P2P programs, As
	opposed to client-server oriented communication as in Kip's UDF.
	Evidently, this functionality is not possible in Kips original releases.
	
	Apart from the obvious conponents of such a code, like Recv, Send, Connect,
	Listen, other important P2P routines have been coded. These include things 
	like; Universal identifiers, bootstrapping mechanisms, peers
	discovery, and message routing.
	
	MINOR DRAWBACKS:
	You can never use the string #8i8# or #8i8TERMINATE# in your communicatons.
	You cannot use the # (hash) symbol in either your Node ID or any part of a
	long range message.
#ce ----------------------------------------------------------------------------

$UDF_Version = "1.31 STABLE"
$console_out = True
$STANDARD_MESSAGE_LIFE = 6
#cs
Functions:

	_P2P_Start_Node( Node Identifier, Port, Max peers, Bootstrap mode, Boostrap max, local/global, IP)
	_P2P_Stop_Node()
	_P2P_Connect( IP)
	_P2P_Send( Socket, Data)
	_P2P_Disconnect_Peer( Socket)
	_P2P_Send_Message( Address, Data)
	
	_P2P_Register_Event($iEvent, $sFunction)


Register event values:

	$P2P_AUX_DATA			; Function ($hSocket, $DataType, $Data);When things like IP and Node identifier are discovered.
	$P2P_MESSAGE			; Function ($hSocket, $message, $iError) ;When long distance messages are recieved.
	$P2P_RECEIVE			; Function ($hSocket, $sReceived, $iError)
	$P2P_CONNECT			; Function ($hSocket, $iError)					
	$P2P_DISCONNECT			; Function ($hSocket, $iError)
	$P2P_NEWCONNECTION		; Function ($hSocket, $iError) 



   Also, please call the function  peer_broadcast() periodically in your program. Failing to do this will
   Seriously cripple the bootstrapping mechanism (unless you program is ALWAYS recieving data at least once
   every 40 seconds, In which case the mechanism will trigger automatically).
#ce

Global Const $FD_READ = 1
Global Const $FD_WRITE = 2
Global Const $FD_OOB = 4
Global Const $FD_ACCEPT = 8
Global Const $FD_CONNECT = 16
Global Const $FD_CLOSE = 32
Global $hWs2_32 = -1 ;Kip, What is this? (I left it in case it was something important)

Global Const $TCP_SEND = 1
Global Const $TCP_RECEIVE = 2
Global Const $TCP_CONNECT = 4
Global Const $TCP_DISCONNECT = 8
Global Const $TCP_NEWCLIENT = 16

Global Const $IPLOC_LOCAL = 64
Global Const $IPLOC_GLOBAL = 128

Global Const $P2P_MESSAGE = 256
Global Const $P2P_RECEIVE = 512
Global Const $P2P_CONNECT = 1024	
Global Const $P2P_DISCONNECT = 2048	
Global Const $P2P_NEWCONNECTION = 4096
Global Const $P2P_AUX_DATA = 8192

;NOTE - SOCKET ARRAYS & OTHER ARRAYS WILL BE DECLARED IN THE '_P2P_START_NODE' FUNCTION.
;       THIS IS BECAUSE I DO NOT KNOW HOW TO DECLARE AN ARRAY AT THE BEGINNING WITHOUT 
;		DEFINING A DIMENSION RANGE(I do not know max peers at this stage). 
;		I'M SURE THERE IS A WAY. WHEN I FIND IT OUT, I WILL PUT IT IN THE NEXT RELEASE. 

Global $total_connected = 0
Global $max_connections
Global $Listening_Socket
Global $node_IP
Global $node_Port
Global $node_Identifier
Global $node_ext_IP
Global $Bootstrap_mode
Global $Bootstrap_max
Global $peer_timer

Global $total_ID_known = 0
Global $Known_ID[200]

Global $connectfunc = ""
Global $recievefunc = ""
Global $disconnectfunc = ""
Global $newconnectionfunc = ""
Global $messagefunc = ""
global $auxfunc = ""

Global $Main_Socket_Address = ""
TCPStartup()
Global Const $__TCP_WINDOW = GUICreate("Async Sockets UDF") ;I know, Copy paste.


; #FUNCTION# ;===============================================================================================================
;
; Name...........: _P2P_Start_Node
; Description ...: Initializes the P2P Node. Starts listening for connections.
; Syntax.........: _P2P_Start_Node( $node_id, $Port, $Max_peers, $Bootstrapmode, $bootstrapmax, $location,  $IP="0.0.0.0")
; Parameters ....: 	$node_id        - The Unique Identifier assigned to you, as a user of the program. Should not change
;								      between excutions for a specific user. This ID is used as an address for long range messages.
;					$Port           - The port to listen for incoming connections on.
;					$Max_peers 		- The maximum number of peers that can be connected to your node at any one time.
;					$bootstrapmode 	- Either 0 or 1. If 0, this UDF will not automatically connect you to other nodes.
;					$bootstrapmax   - The number of peers connected before the UDF will stop bootstrapping. (autoconnecting)
;					$location		- Either 0 or 1. Put 0 if working on a LAN or WLAN. Put 1 if your node works over the
;									  Internet.
;					$IP				- (Optional) The IP address to host the node on. Really, the default value will work 99% 
;										of the time. You shouldn't change it unless you know exactly what your doing.
; Return values .: Err...Nothing.
; Author ........: Hyperzap and Kip.
; Modified.......:
; Remarks .......: Only 1 P2P node can be created per script. By why on earth would you need another?
; Related .......: 
; Link ..........;
; Example .......; See my 'example scripts' post. (If applicable)
;
; ;==========================================================================================================================


Func _P2P_Start_Node( $node_id, $Port, $Max_peers, $Bootstrapmode, $bootstrapmax, $location,  $IP="0.0.0.0")
		local $startuptimer = TimerInit()
		$Listening_Socket = ___ASocket()
		$Main_Socket_Address = $Listening_Socket
		___ASockSelect( $Listening_Socket, $__TCP_WINDOW, 0x0400, $FD_ACCEPT)
		GUIRegisterMsg( 0x0400, "Listensocket_data_" )
		___ASockListen( $Listening_Socket, $IP, $Port )
		
		if $Bootstrapmode = 0 then $Bootstrap_mode = $IPLOC_LOCAL
		if $Bootstrapmode = 1 then $Bootstrap_mode = $IPLOC_GLOBAL
		$bootstrap_max = $bootstrapmax
		$max_connections = $Max_peers
		$node_IP = $IP
		$node_Port = $Port
		$node_Identifier = $node_id
		$peer_timer = TimerInit()
		if $location = 1 then $node_ext_IP = _Get_IP() ;GetIP command.
		if $location = 0 then $node_ext_IP = @IPAddress1
		
		Global $Socket_Handle_array[$Max_peers + 1]
		Global $Node_Identifier_array[$Max_peers + 1]
		Global $Node_IP_array[$Max_peers + 1]
		Global $Node_Peer_Reachable_list[$Max_peers + 1]
		For $x = 0 to $Max_peers step 1
			$Socket_Handle_array[$x] = -1
			$Node_Identifier_array[$x] = -1
			$Node_IP_array[$x] = -1
			$Node_Peer_Reachable_list[$x] = -1
		Next
		if $console_out = True then ConsoleWrite( @CRLF & @CRLF & "P2P_: Node started")
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Port: " & $node_Port)
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Ext IP: " & $node_ext_IP)
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Max peers: " & $max_connections)
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Identifier: " & $node_Identifier)
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Engine Version: " & $UDF_version)
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Startup time: " & TimerDiff( $startuptimer) & "ms" & @CRLF)
EndFunc
	
	
; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Stop_Node
; Description ...: Stops the node, and closes all connections.
; Syntax.........: _P2P_Stop_Node()
; Parameters ....: 
; Return values .: None.
; Author ........: Hyperzap
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================
	
	
Func _P2P_Stop_Node()
	___ASockShutdown($Listening_Socket)
	TCPCloseSocket($Listening_Socket)
	
	For $x = 0 to $max_connections step 1
		$Socket_Handle_array[$x] = -1
		$Node_Identifier_array[$x] = -1
		$Node_IP_array[$x] = -1
		$Node_Peer_Reachable_list[$x] = -1
	Next
		
	$max_connections = 0
	$Listening_Socket = ""
	$node_IP = ""
	$node_Port = ""
	$node_Identifier = -1
	$node_ext_IP = ""
	$Bootstrap_mode = ""
	$Bootstrap_max = 0
	$connectfunc = ""
	$recievefunc = ""
	$disconnectfunc = ""
	$newconnectionfunc = ""
	$messagefunc = ""
	$auxfunc = ""
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Engine shutdown successful.")
EndFunc

Func Listensocket_data_($hWnd, $iMsgID, $WParam, $LParam)
	Local $Socketinquestion = $WParam
	Local $iError = ___HiWord( $LParam )
	Local $iEvent = ___LoWord( $LParam )
	Abs($hWnd) ; Stupid AU3Check...
	If $iMsgID = 0x400 Then
		If $iEvent = $FD_ACCEPT Then
			If Not $iError Then
				$arrayslot = Findfreearrayslot()
				if $arrayslot = "error" then ;No more spots for new peers. Connection dropped.
					$newsocket = TCPAccept($Socketinquestion)
					TCPSend( $newsocket, "#8i8#NOSLOT#8i8TERMINATE#")
					TCPCloseSocket( $newsocket)
				EndIf
				$newsocket = TCPAccept($Socketinquestion)
				___ASockSelect($newsocket, $__TCP_WINDOW, 0x0400 + $arrayslot, BitOR($FD_READ, $FD_CONNECT, $FD_CLOSE))
				GUIRegisterMsg( 0x0400 + $arrayslot, "Opensocket_data_" )
				$Socket_Handle_array[$arrayslot] = $newsocket
				$Node_Identifier_array[$arrayslot] = -1
				$Node_IP_array[$arrayslot] = -1
				TCPSend( $newsocket, "#8i8#IP#" & $node_ext_IP & "#8i8TERMINATE#")
				TCPSend( $newsocket, "#8i8#ID#" & $node_Identifier & "#8i8TERMINATE#")
				peer_broadcast_to_peer( $newsocket)
				$total_connected += 1
				Call( $newconnectionfunc, $newsocket, $iError)
			Else
				Call( $newconnectionfunc, 0, $iError)
			EndIf

		ElseIf $iEvent = $FD_CONNECT Then
			
			Call( $connectfunc, $newsocket, $iError)
			
			EndIf
		EndIf
EndFunc

Func Findfreearrayslot()
	$newConnNum = -1
	For $x = 1 To $max_connections
		If $Socket_Handle_array[$x] = -1 Then
			$newConnNum = $x
			ExitLoop
		EndIf
	Next
If $newConnNum = -1 Then Return "error";Didn't want it to be a number.
 Return $newConnNum
EndFunc
	
Func Opensocket_data_( $hWnd, $iMsgID, $WParam, $LParam )
	Local $iError = ___HiWord( $LParam )
	Local $iEvent = ___LoWord( $LParam )
	Abs($hWnd)
	local $Array_Slot = $iMsgID-0x400 ;No more loops to slow down message delievery!
	local $SocketID = $Socket_Handle_array[$Array_Slot]
	if $SocketID = -1 then return 0
	Switch $iEvent
		Case $FD_READ
				$rawrecv = TCPRecv($SocketID, 1024*5)
				recvprocess( $rawrecv, $SocketID, $Array_Slot, $iError)
		Case $FD_CLOSE
				___ASockShutdown($SocketID)
				TCPCloseSocket($SocketID)
				Call( $disconnectfunc, $SocketID, $iError)
				$Socket_Handle_array[$Array_Slot] = -1
				$Node_Identifier_array[$Array_Slot] = -1
				$Node_IP_array[$Array_Slot] = -1
				$Node_Peer_Reachable_list[$Array_Slot] = -1
				$total_connected -= 1
				if TimerDiff( $peer_timer) > 40000 Then
					peer_broadcast()
				EndIf
			Case $FD_CONNECT
			If $iError Then
				if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Connection failed: " & $SocketID)
				$Socket_Handle_array[$Array_Slot] = -1
				$Node_Identifier_array[$Array_Slot] = -1
				$Node_IP_array[$Array_Slot] = -1
				$Node_Peer_Reachable_list[$Array_Slot] = -1
				$total_connected -= 1
				Call( $connectfunc, $SocketID, $iError)
			Else
				Call( $connectfunc, $SocketID, $iError)
				if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Connection established: " & $SocketID)
				TCPSend( $Socket_Handle_array[$Array_Slot], "#8i8#IP#" & $node_ext_IP & "#8i8TERMINATE#")
				TCPSend( $Socket_Handle_array[$Array_Slot], "#8i8#ID#" & $node_Identifier & "#8i8TERMINATE#")
				peer_broadcast_to_peer( $Socket_Handle_array[$Array_Slot])
			EndIf
				if TimerDiff( $peer_timer) > 40000 Then
					peer_broadcast()
				EndIf
		EndSwitch
EndFunc

Func recvprocess( $rawrecv, $SocketID, $Array_Slot, $iError)
	if stringlen($rawrecv) < 1 then return 0
	local $Single_Data = StringSplit( $rawrecv, "#8i8TERMINATE#", 1)
	for $k = 1 to $Single_Data[0] step 1
		if $Single_Data[$k] = "" then ContinueLoop ;Probably isn't nessesary.
		if $Single_Data[$k] = " " then ContinueLoop ;Disregard noise and crappy coders.

		if StringInStr( $Single_Data[$k], "#8i8#", 1) > 0 Then
			node_data_process( $SocketID, $Single_Data[$k], $Array_Slot, $iError);must be node info to process.
		Else
		Call( $recievefunc, $SocketID, $Single_Data[$k], $iError) ;Sends to user script
		EndIf
	Next
	if TimerDiff( $peer_timer) > 40000 Then
		peer_broadcast()
	EndIf
EndFunc

Func node_data_process( $SocketID, $Data, $Array_Slot, $iError)
	local $split = StringSplit( $Data, "#")
	if $split[3] = "IP" then 
		$Node_IP_array[$Array_Slot] = $split[4]
		Call( $auxfunc, $SocketID, "IP", $split[4])
	EndIf
	if $split[3] = "ID" then 
		$Node_Identifier_array[$Array_Slot] = $split[4]
		Call( $auxfunc, $SocketID, "ID", $split[4])
	EndIf
	if $split[3] = "PEER" then bootstrap( $SocketID, $split[4], $Array_Slot, $iError)
	if $split[3] = "IDLIST" then 
		$Node_Peer_Reachable_list[$Array_Slot] = $split[4]
		Call( $auxfunc, $SocketID, "NODE-REACHABLE", $split[4])
	EndIf
	if $split[3] = "MESSAGE" then ;#8i8#MESSAGE
		Route_Message( $SocketID, $Data, $Array_Slot)
	EndIf
EndFunc

Func bootstrap( $SocketID, $split, $Array_Slot, $iError)
	if $Bootstrap_mode = $IPLOC_LOCAL then return 9;Bootstrapping disabled.
	if $total_connected >= $Bootstrap_max then return 8;Already connected to enough peers.
	local $connectpeers = Round( ($Bootstrap_max/$total_connected/2), 0) ;calculate how many peers we should attempt to connect to.
	if $connectpeers < $Bootstrap_max and $connectpeers = 0 then $connectpeers = 1
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Bootstrap stats: " & $connectpeers & ":" & $total_connected & "/" & $Bootstrap_max)
	$peers = StringSplit( $split, ";")
	
	For $d = 1 to $connectpeers step 1
		$error = False
		$rndarray = Random( 1, $peers[0], 1)
		if $peers[$rndarray] = "" or $peers[$rndarray] = " " then ContinueLoop
		For $u = 0 to $max_connections step 1 ;checks to see if already connected
			if $peers[$rndarray] = $Node_IP_array[$u] then 
				if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Bootstrap: connectee already connected! reselecting...")
				$error = True
				ExitLoop
			EndIf
		Next
		if $error = True then ContinueLoop
		_P2P_Connect( $peers[$rndarray])
	Next
EndFunc

Func peer_broadcast()
	$peer_timer = TimerInit()
	local $peers = ""
	local $IDLIST = ""
	For $a = 0 to $max_connections step 1
		if $Node_IP_array[$a] <> -1 then $peers &= $Node_IP_array[$a] & ";"
		if $Node_Identifier_array[$a] <> -1 then $IDLIST &= $Node_Identifier_array[$a] & ";"
	Next
		_P2P_Broadcast( "#8i8#PEER#" & $peers)
		_P2P_Broadcast( "#8i8#IDLIST#" & $IDLIST)
EndFunc

Func peer_broadcast_to_peer( $socket)
	local $peers = ""
	local $IDLIST = ""
	For $a = 0 to $max_connections step 1
		if $Node_IP_array[$a] <> -1 then $peers &= $Node_IP_array[$a] & ";"
		if $Node_Identifier_array[$a] <> -1 then $IDLIST &= $Node_Identifier_array[$a] & ";"
	Next
	TCPSend( $socket, "#8i8#PEER#" & $peers & "#8i8TERMINATE#")
	TCPSend( $socket, "#8i8#IDLIST#" & $IDLIST & "#8i8TERMINATE#")
EndFunc

Func Route_Message( $Socket, $Message, $array_slot) ;process long distance messages
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing started")
	local $timer = TimerInit()
	local $split = StringSplit( $Message, "#")
	if $split[0] < 6 then return 1
	Local $ttl = $split[4]
	Local $address = $split[5]
	Local $identifier = $split[6]
	Local $begin = "#8i8#MESSAGE#" & $ttl & "#" & $address & "#" & $identifier & "#"
	Local $cutlen = StringLen( $Message) - StringLen( $begin)
	
	if idknown( $split[6]) = True then ;Have we seen it before? if yes-Terminate.
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message-ID known.")
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing Finished: " & Round( TimerDiff( $timer), 1))
		return 1
	EndIf
	
	if $address = $node_Identifier then ;Is it for us? if yes-deliever.
		local $messagetrim = StringRight( $Message, $cutlen)
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message-Inbound")
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing Finished: " & Round( TimerDiff( $timer), 1))
		call( $messagefunc, $Socket, $messagetrim, 0)
		return 1
	EndIf
	
	if $ttl = 0	then ;Is it too old? if yes-Terminate.
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message-TTL Exceeded.")
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing Finished: " & Round( TimerDiff( $timer), 1))
		return 1
	EndIf
	;Time to route the message.
	$messagefull = "#8i8#MESSAGE#" & ($ttl-1) & "#" & $address & "#" & $identifier & "#" & StringRight( $Message, $cutlen)
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Starting First level Routing: " & $total_connected)
	For $qwe = 0 to $max_connections step 1 ;Send if we are directly connected to the destination.
		if $address = $Node_Identifier_array[$qwe] then
			_P2P_Send( $Socket_Handle_array[$qwe], $messagefull)
			if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message-Destination located.")
			if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing Finished: " & Round( TimerDiff( $timer), 1))
			return 1
		EndIf
	Next
	
	if $Socket = -1 Then ;If we created the message: Flood to all peers
		_P2P_Broadcast( $messagefull)
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing Finished: " & Round( TimerDiff( $timer), 1))
		return 1
	Else ;Or check every peer to see if it is connected to destination.
	For $qwe = 0 to $max_connections step 1 ;See if our peers are connected to the destination.
			if $Socket_Handle_array[$qwe] = -1 then ContinueLoop
			if StringInStr( $Node_Peer_Reachable_List[$qwe], $address) > 0 Then
				_P2P_Send( $Socket_Handle_array[$qwe], $messagefull)
				if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message-2nd Level destination located. ")
				if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing Finished: " & Round( TimerDiff( $timer), 1))
				return 1
			EndIf
		Next
	EndIf
	For $qwe = 0 to $max_connections step 1 ;So the destination is not reachable within two levels. Time to pass it on. Don't pass it on to sender or sender's peers.
			if $Socket_Handle_array[$qwe] = -1 then ContinueLoop
			if $node_Identifier_array[$qwe] = $node_Identifier_array[$array_slot] then ContinueLoop
			if StringInStr( $Node_Peer_Reachable_List[$array_slot], $node_Identifier_array[$qwe]) > 0 Then ContinueLoop
			_P2P_Send( $Socket_Handle_array[$qwe], $messagefull)
	Next
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message##########Routing Finished: " & Round( TimerDiff( $timer), 1))
EndFunc
	
	; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Send_Message
; Description ...: Sends a long range message to a peer somewhere in the network.
; Syntax.........: _P2P_Send_Message( $Identifier, $data)
; Parameters ....: 	$Identifier	- The node Identifier/ID/Address of the destination.
;					$Data		- Data/Message to send.
; Return values .: 
; Author ........: Hyperzap
; Modified.......: 
; Remarks .......: This, as opposed to the _P2P_Send function, will send a message to the
;					destination regardless of whether they are connected or not, That is, you need
;					not be directly TCP connected to someone for the message to reach them. This
;					System works making your message 'hop' from node to node until one knows where
;					your destination is. At that point, it is sent directly to the destination To
;					be unpacked and processed.Please note that there is no way to know if the message
;					reached it's destination, but if it is in range and online it will reach it
;					99.5% of the time.
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================

Func _P2P_Send_Message( $IDaddress, $INdata)
	local $messageID = Round( ((Random( 0, 99999999999, 1)*@YDAY)/@MIN)*(Random(5, 1376, 1)/(@SEC*100)), 0) ;As random as it'l ever get.
	local $ttl = $STANDARD_MESSAGE_LIFE
	local $fullmessage = "#8i8#MESSAGE#" & $ttl & "#" & $IDaddress & "#" & $messageID & "#" & $INdata & "#8i8TERMINATE#"
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Message generated: " & $messageID)
	Route_Message( -1, $fullmessage, -1)
EndFunc
	


Func idknown ($ID)
	for $IDcount = 0 to $total_ID_known step 1
		if $Known_ID[$IDcount] = $ID then Return True
	Next
	$total_ID_known += 1
	if $total_ID_known > 198 then $total_ID_known = 0
	$Known_ID[$total_ID_known] = $ID
		return False
		
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Send
; Description ...: Sends data to a peer.
; Syntax.........: _P2P_Send( $Socket, $Data)
; Parameters ....: 	$Socket	- peer socket handle.
;					$Data	- Data to send.
; Return values .: 
; Author ........: Hyperzap
; Modified.......: 
; Remarks .......: This UDF will automatically keep your individual messages separate, So
;					Don't worry about adding delays or message-split-buffer systems.
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================
Func _P2P_Send( $Socket, $Data)
	TCPSend( $Socket, $Data & "#8i8TERMINATE#")
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Disconnect_Peer
; Description ...: Disconnects a peer (someone your connected to) from the system.
; Syntax.........: _P2P_Disconnect_Peer($Socket)
; Parameters ....: $Socket	- Socket of peer.
; Return values .: Success	- True
;				   Failure	- False
; Author ........: Hyperzap
; Modified.......:
; Remarks .......: The peer socket ($Socket) is the socket handler of ANY peer connected.
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================

Func _P2P_Disconnect_Peer( $socket)
	
	local $it_socket = ""
	local $array_slot = ""
	For $count = 0 to $max_connections step 1
		if $Socket_Handle_array[$count] = $socket then
			$it_socket = $socket
			$array_slot = $count
			ExitLoop
		EndIf
	Next
	if $it_socket = "" then return False
	___ASockShutdown($it_socket)
	TCPCloseSocket($it_socket)
	$Socket_Handle_array[$Array_Slot] = -1
	$Node_Identifier_array[$Array_Slot] = -1
	$Node_IP_array[$Array_Slot] = -1
	$Node_Peer_Reachable_list[$Array_Slot] = -1
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Peer " & $it_socket & " closed.")
	return true
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Connect
; Description ...: Initiates a new connection to another node.
; Syntax.........: __P2P_Connect( $Conn_IP)
; Parameters ....: 	$Conn_IP	- The IP address to connect to.
; Return values .: 0, 1, 2, 3 indicate failure due to criteria. Listen to the 
;					_P2P_Register_Event( $P2P_CONNECT etc to determine if it connected or not.
; Author ........: Hyperzap
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================

Func _P2P_Connect( $Conn_IP)
	For $u = 0 to $max_connections step 1 ;checks to see if already connected
		if $Conn_IP = $Node_IP_array[$u] then 
			if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Unable to connect-IP is already connected!")
			return 1
		EndIf
	Next
	
	if $Conn_IP = "" then Return 0
	if $Conn_IP = " " then Return 0
	if $Conn_IP = "0" then Return 0	
	if $Conn_IP = ";" then Return 0
	if $Conn_IP = @CRLF then Return 0

	$arrayslot = Findfreearrayslot()
	if $arrayslot = "error" then 
		if $Listening_Socket = "" Then
			if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Unable to connect-node services offline!")
			Return 3
		EndIf
		if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Unable to connect-peer limit reached!")
		return 2 ;no free slots to put your new connection!
	EndIf
	if $console_out = True then ConsoleWrite( @CRLF & "P2P_: Attempting Connection: " & $Conn_IP)
	local $SocketID = ___ASocket()
	___ASockSelect( $SocketID, $__TCP_WINDOW, 0x400 + $arrayslot, BitOR( $FD_CONNECT, $FD_READ, $FD_CLOSE))
	GUIRegisterMsg( 0x400 + $arrayslot, "Opensocket_data_" )
	$Socket_Handle_array[$arrayslot] = $SocketID
	$Node_Identifier_array[$arrayslot] = -1
	$Node_IP_array[$arrayslot] = $Conn_IP
	$return = ___ASockConnect( $SocketID, $Conn_IP, $node_Port )
	$total_connected += 1
	If @extended Then 
		if $console_out = True then ConsoleWrite( @CRLF & "_P2P: Connection Established.")
		Call( $connectfunc, $SocketID, 0);connected immediately!
	EndIf
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Broadcast
; Description ...: Sends data to all connected peers.
; Syntax.........: _P2P_Broadcast($Data)
; Parameters ....: 	$Data	- The data to send.
; Return values .: True
; Author ........: Hyperzap
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================

Func _P2P_Broadcast($Data)
	Local $i
	For $i = 0 to $max_connections step 1
		If $Socket_Handle_array[$i] <> -1 Then TCPSend($Socket_Handle_array[$i], $Data & "#8i8TERMINATE#")
	Next
	Return True
EndFunc


; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Peerlist
; Description ...: Returns the sockets, IDs, and IPs of all connected peers.
; Syntax.........: _P2P_Peerlist()
; Parameters ....: 	
; Return values .: A 3 dimensional array of all connected peers. The first spot in the array,
;					AKA [0][0] defines the number of connected peers. The remaining spots
;					In the array are the actual peers in the format of dimension [0] socket
;					handle, [1] ID, and [2] IP. So the first peer will be [1][0], [1][1]. [1][2]
;					and the second [2][0], [2][1], [2][2] etc.
; Author ........: Hyperzap
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================
Func _P2P_Peerlist()
	
	Local $aList[$max_connections+1][3], $alist_count = 1
	For $i = 1 to $max_connections
		If $Socket_Handle_array[$i] <> -1 Then
			$aList[$alist_count][0] = $Socket_Handle_array[$i]
			$aList[$alist_count][1] = $Node_Identifier_array[$i]
			$aList[$alist_count][2] = $Node_IP_array[$i]
			$alist_count += 1
		EndIf
	Next
	
	$aList[0][0] = $alist_count
	
	Return $alist
	
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _P2P_Register_Event
; Description ...: Registers an event.So, if I register my function "ant" with the event
;					$P2P_RECEIVE, it will look like: _P2P_Register_Event($P2P_RECEIVE, "ant").
;					It will mean my function 'ant' will get called with the specified parameters
;					(see below) when data is recieved.
; Syntax.........: _P2P_Register_Event($iEvent, $sFunction)
; Parameters ....: 	$iEvent		- Event number. It can be any these values:

;							Event number			This is the required syntax of YOUR called function

;							$P2P_AUX_DATA			; Function ($hSocket, $DataType, $Data)
								;When things like IP and Node identifier are discovered.
;							$P2P_MESSAGE			; Function ($hSocket, $message, $from, $iError) 
								;When long distance messages are recieved.
;							$P2P_RECEIVE			; Function ($hSocket, $sReceived, $iError)
								;When data is recieved directly from a connected peer.
;							$P2P_CONNECT			; Function ($hSocket, $iError)			
								;This is called when an attempted connection is successful or unsuccessful.
;							$P2P_DISCONNECT			; Function ($hSocket, $iError)
								;This is called whenever a peer disconnects from you.
;							$P2P_NEWCONNECTION		; Function ($hSocket, $iError) 
								;This is called whenever a peer connects to you.
; Return values .: Success	- True
;				   Failure	- False
; Author ........: Kip
; Modified.......: Hyperzap
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; 
;
; ;==========================================================================================


Func _P2P_Register_Event($iEvent, $sFunction)
	if $iEvent = $P2P_AUX_DATA then $auxfunc = $sFunction
	if $iEvent = $P2P_RECEIVE then $recievefunc = $sFunction
	if $iEvent = $P2P_CONNECT then $connectfunc = $sFunction
	if $iEvent = $P2P_DISCONNECT then $disconnectfunc = $sFunction
	if $iEvent = $P2P_NEWCONNECTION then $newconnectionfunc = $sFunction
	if $iEvent = $P2P_MESSAGE then $messagefunc = $sFunction
EndFunc
;==================================================================================================================
; 
; Zatorg's Asynchronous Sockets UDF Starts from here.
; 
;==================================================================================================================


Func ___ASocket($iAddressFamily = 2, $iType = 1, $iProtocol = 6)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $hSocket = DllCall($hWs2_32, "uint", "socket", "int", $iAddressFamily, "int", $iType, "int", $iProtocol)
	If @error Then
		SetError(1, @error)
		Return -1
	EndIf
	If $hSocket[ 0 ] = -1 Then
		SetError(2, ___WSAGetLastError())
		Return -1
	EndIf
	Return $hSocket[ 0 ]
EndFunc   ;==>_ASocket

Func ___ASockShutdown($hSocket)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall($hWs2_32, "int", "shutdown", "uint", $hSocket, "int", 2)
	If @error Then
		SetError(1, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	Return True
EndFunc   ;==>_ASockShutdown

Func ___ASockClose($hSocket)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall($hWs2_32, "int", "closesocket", "uint", $hSocket)
	If @error Then
		SetError(1, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	Return True
EndFunc   ;==>_ASockClose

Func ___ASockSelect($hSocket, $hWnd, $uiMsg, $iEvent)
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall( _
			$hWs2_32, _
			"int", "WSAAsyncSelect", _
			"uint", $hSocket, _
			"hwnd", $hWnd, _
			"uint", $uiMsg, _
			"int", $iEvent _
			)
	If @error Then
		SetError(1, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	Return True
EndFunc   ;==>_ASockSelect

; Note: you can see that $iMaxPending is set to 5 by default.
; IT DOES NOT MEAN THAT DEFAULT = 5 PENDING CONNECTIONS
; 5 == SOMAXCONN, so don't worry be happy
Func ___ASockListen($hSocket, $sIP, $uiPort, $iMaxPending = 5); 5 == SOMAXCONN => No need to change it.
	Local $iRet
	Local $stAddress

	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )

	$stAddress = ___SockAddr($sIP, $uiPort)
	If @error Then
		SetError(@error, @extended)
		Return False
	EndIf
	
	$iRet = DllCall($hWs2_32, "int", "bind", "uint", $hSocket, "ptr", DllStructGetPtr($stAddress), "int", DllStructGetSize($stAddress))
	If @error Then
		SetError(3, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		$stAddress = 0; Deallocate
		SetError(4, ___WSAGetLastError())
		Return False
	EndIf
	
	$iRet = DllCall($hWs2_32, "int", "listen", "uint", $hSocket, "int", $iMaxPending)
	If @error Then
		SetError(5, @error)
		Return False
	EndIf
	If $iRet[ 0 ] <> 0 Then
		$stAddress = 0; Deallocate
		SetError(6, ___WSAGetLastError())
		Return False
	EndIf
	
	Return True
EndFunc   ;==>_ASockListen

Func ___ASockConnect($hSocket, $sIP, $uiPort)
	Local $iRet
	Local $stAddress
	
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	
	$stAddress = ___SockAddr($sIP, $uiPort)
	If @error Then
		SetError(@error, @extended)
		Return False
	EndIf
	
	$iRet = DllCall($hWs2_32, "int", "connect", "uint", $hSocket, "ptr", DllStructGetPtr($stAddress), "int", DllStructGetSize($stAddress))
	If @error Then
		SetError(3, @error)
		Return False
	EndIf
	
	$iRet = ___WSAGetLastError()
	If $iRet = 10035 Then; WSAEWOULDBLOCK
		Return True; Asynchronous connect attempt has been started.
	EndIf
	SetExtended(1); Connected immediately
	Return True
EndFunc   ;==>_ASockConnect

; A wrapper function to ease all the pain in creating and filling the sockaddr struct
Func ___SockAddr($sIP, $iPort, $iAddressFamily = 2)
	Local $iRet
	Local $stAddress
	
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	
	$stAddress = DllStructCreate("short; ushort; uint; char[8]")
	If @error Then
		SetError(1, @error)
		Return False
	EndIf
	
	DllStructSetData($stAddress, 1, $iAddressFamily)
	$iRet = DllCall($hWs2_32, "ushort", "htons", "ushort", $iPort)
	DllStructSetData($stAddress, 2, $iRet[ 0 ])
	$iRet = DllCall($hWs2_32, "uint", "inet_addr", "str", $sIP)
	If $iRet[ 0 ] = 0xffffffff Then; INADDR_NONE
		$stAddress = 0; Deallocate
		SetError(2, ___WSAGetLastError())
		Return False
	EndIf
	DllStructSetData($stAddress, 3, $iRet[ 0 ])
	
	Return $stAddress
EndFunc   ;==>__SockAddr

Func ___WSAGetLastError()
	If $hWs2_32 = -1 Then $hWs2_32 = DllOpen( "Ws2_32.dll" )
	Local $iRet = DllCall($hWs2_32, "int", "WSAGetLastError")
	If @error Then
		;if $console_out = True then ConsoleWrite("+> _WSAGetLastError(): WSAGetLastError() failed. Script line number: " & @ScriptLineNumber & @CRLF)
		SetExtended(1)
		Return 0
	EndIf
	Return $iRet[ 0 ]
EndFunc   ;==>_WSAGetLastError


; Got these here:
; http://www.autoitscript.com/forum/index.php?showtopic=5620&hl=MAKELONG
Func ___MakeLong($LoWord, $HiWord)
	Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF)); Thanks Larry
EndFunc   ;==>_MakeLong

Func ___HiWord($Long)
	Return BitShift($Long, 16); Thanks Valik
EndFunc   ;==>_HiWord

Func ___LoWord($Long)
	Return BitAND($Long, 0xFFFF); Thanks Valik
EndFunc   ;==>_LoWord




;----------------------------------OTHER AUTOIT INBUILT FUNCS----##

;===============================================================================
;
; Function Name:    _GetIP()
; Description:      Get public IP address of a network/computer.
; Parameter(s):     None
; Requirement(s):   Internet access.
; Return Value(s):  On Success - Returns the public IP Address
;                   On Failure - -1  and sets @ERROR = 1
; Author(s):        Larry/Ezzetabi & Jarvis Stubblefield
;
;===============================================================================
Func _Get_IP()
	Local $ip, $t_ip
	If InetGet("http://checkip.dyndns.org/?rnd1=" & Random(1, 65536) & "&rnd2=" & Random(1, 65536), @TempDir & "\~ip.tmp") Then
		$ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
		$ip = StringTrimLeft($ip, StringInStr($ip, ":") + 1)
		$ip = StringTrimRight($ip, StringLen($ip) - StringInStr($ip, "/") + 2)
		$t_ip = StringSplit($ip, '.')
		If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
			Return $ip
		EndIf
	EndIf
	If InetGet("http://www.whatismyip.com/?rnd1=" & Random(1, 65536) & "&rnd2=" & Random(1, 65536), @TempDir & "\~ip.tmp") Then
		$ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
		$ip = StringTrimLeft($ip, StringInStr($ip, "Your ip is") + 10)
		$ip = StringLeft($ip, StringInStr($ip, " ") - 1)
		$ip = StringStripWS($ip, 8)
		$t_ip = StringSplit($ip, '.')
		If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
			Return $ip
		EndIf
	EndIf
	SetError(1)
	Return -1
EndFunc   ;==>_Get_IP

