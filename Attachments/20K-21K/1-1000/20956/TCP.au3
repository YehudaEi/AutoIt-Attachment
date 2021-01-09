#include-once
;Server Functions
;_TCP_Server_Start(IP, Port)
;_TCP_Server_Stop()
;_TCP_Server_SetOnEvent(Event, Function)
;_TCP_Server_Send(Message, UsersID (send to all by default))
;_TCP_Server_GetConnections()
;
;Client Functions
;_TCP_Client_Start(IP, Port)
;_TCP_Client_Stop()
;_TCP_Client_SetOnEvent(Event, Function)
;_TCP_Client_Send(Message)
;
;Internal Functions
;_TCP_Server_Events
;_TCP_Client_Events

;The Variables you may use in your scripts
Global Const $Tcp_Client_Event_Open 	= 0
Global Const $Tcp_Client_Event_Close 	= 1
Global Const $Tcp_Client_Event_Recv		= 2

Global Const $Tcp_Server_Event_Open 	= 0
Global Const $Tcp_Server_Event_Close 	= 1
Global Const $Tcp_Server_Event_Recv		= 2

;Internal Variables
Global $TCP_SERVER_CLIENT[1]
Global $TCP_SERVER_CONNECTION

Global $TCP_SERVER_RECV_FUNCTION		= ""
Global $TCP_SERVER_CONN_FUNCTION		= ""
Global $TCP_SERVER_LOST_FUNCTION		= ""
Global $_TCP_SERVER_TIMER
Global $_TCP_SERVER_TIMERCALLBACK

Global $TCP_CLIENT_CONNECTION

Global $TCP_CLIENT_RECV_FUNCTION		= ""
Global $TCP_CLIENT_CONN_FUNCTION		= ""
Global $TCP_CLIENT_LOST_FUNCTION		= ""

Global $_TCP_CLIENT_TIMER
Global $_TCP_CLIENT_TIMERCALLBACK

;#####################################
;_TCP_Server_Start($s_Ip, $s_Port)
;		$s_Ip = The Ip you want to use
;		$s_Port = The Port you want to use
;
;Returns:
;			True on succsess
;			False on failure
;
;Description: Starts up a simple multi user TCP Server.
;#####################################
Func _TCP_Server_Start($s_Ip, $s_Port)
	TCPStartup()
	$TCP_SERVER_CONNECTION = TCPListen($s_Ip, $s_Port)
	If @error Then Return False
	
	$_TCP_SERVER_TIMERCALLBACK = DllCallbackRegister("_TCP_Server_Events", "none", "hwnd;int;int;dword")
	$pTimerFunc = DllCallbackGetPtr($_TCP_SERVER_TIMERCALLBACK)
	$iResult = DllCall("user32.dll", "int", "SetTimer", "hwnd", 0, "int", Random(2000,2200,1), "int", '100', "ptr", $pTimerFunc)
	$_TCP_SERVER_TIMER = $iResult[0]

	Return True
EndFunc

;#######################
;_TCP_Server_Stop()
;Stops the TCP Server.
;#######################
Func _TCP_Server_Stop()
	If $TCP_SERVER_CONNECTION = -1 Then
		TCPShutdown() 
		Return False
	EndIf
	
	For $x = 1 To UBound($TCP_SERVER_CLIENT)-1
		TCPCloseSocket($TCP_SERVER_CLIENT[$x])
	Next
	TCPShutdown()
	DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "int", $_TCP_SERVER_TIMER)
	DllCallbackFree($_TCP_SERVER_TIMERCALLBACK)
	Return True
EndFunc

;#############################################
;_TCP_Server_SetOnEvent($s_Event, $s_Func)
;		$s_Event = The event you want to the declear a function to
;		$s_Func = The function you want the event to be handeld in
;
;Returns:
;			True on succsess
;			False on failure
;
;Descriptiong: Sets the function to be called on certin events.
;#############################################
Func _TCP_Server_SetOnEvent($s_Event, $s_Func)
	Switch $s_Event
		Case $TCP_SERVER_event_open
			$TCP_SERVER_CONN_FUNCTION = $s_Func
		Case $TCP_SERVER_event_close
			$TCP_SERVER_LOST_FUNCTION = $s_Func
		Case $TCP_SERVER_event_recv
			$TCP_SERVER_RECV_FUNCTION = $s_Func
		Case Else
			Return False
	EndSwitch
	Return True
EndFunc

;Internal Function
Func _TCP_Server_Events($hWnd, $iMsg, $iIDTimer, $dwTime)
	
	Local $temp_conn, $temp_recv
	$temp_conn = TCPAccept($TCP_SERVER_CONNECTION)
	If $temp_conn <> -1 Then
		For $x = 1 To UBound($TCP_SERVER_CLIENT)-1
			If Not $TCP_SERVER_CLIENT[$x] Then 
				$TCP_SERVER_CLIENT[$x] = $temp_conn
				Call($TCP_SERVER_CONN_FUNCTION, $x)
				$TCP_SERVER_CLIENT[0] += 1
				$x = 0
				ExitLoop
			EndIf
		Next
		If $x <> 0 Then
			ReDim $TCP_SERVER_CLIENT[UBound($TCP_SERVER_CLIENT)+1]
			$TCP_SERVER_CLIENT[UBound($TCP_SERVER_CLIENT)-1] = $temp_conn
			If $TCP_SERVER_CONN_FUNCTION <> "" Then Call($TCP_SERVER_CONN_FUNCTION, UBound($TCP_SERVER_CLIENT)-1)
			$TCP_SERVER_CLIENT[0] += 1
		EndIf
	EndIf
	
	For $x = 1 To UBound($TCP_SERVER_CLIENT)-1
		If Not $TCP_SERVER_CLIENT[$x] Then ContinueLoop
		$temp_recv = TCPRecv($TCP_SERVER_CLIENT[$x],4096)
		If @error Then
			Call($TCP_SERVER_LOST_FUNCTION, $x)
			TCPCloseSocket($TCP_SERVER_CLIENT[$x])
			$TCP_SERVER_CLIENT[0] -= 1
			$TCP_SERVER_CLIENT[$x] = False
		ElseIf $temp_recv = "" Then 
			ContinueLoop
		ElseIf $TCP_SERVER_RECV_FUNCTION <> "" Then
			Call($TCP_SERVER_RECV_FUNCTION, $temp_recv, $x)
		EndIf
	Next
	
	Return True
EndFunc

;#########################################
;_TCP_Server_Send($s_Msg, $s_Who=0)
;	$s_Msg = The message you want to send
;	$s_Who = the connection Id the client you want to send the data too
;	Sends message to everyone by default
;
;Returns:
;			True on succsess
;			False on failure
;
;Descriptiong: Sends Data from the server to the client(s)
;#########################################
Func _TCP_Server_Send($s_Msg, $s_Who=0)
	If $s_Who < 1 Then
		For $x = 1 To UBound($TCP_SERVER_CLIENT)-1
			If Not $TCP_SERVER_CLIENT[$x] Then ContinueLoop
			TCPSend($TCP_SERVER_CLIENT[$x], $s_Msg)
		Next
		Return True
	ElseIf $s_Who < UBound($TCP_SERVER_CLIENT) Then
		Return TCPSend($TCP_SERVER_CLIENT[$s_Who], $s_Msg)
	EndIf
	Return False
EndFunc

;#################################
;Returns: A array containing the TCP sockets
;	[0] = Socket count
;	[n] = Socket for userId n or false if not in use
;#################################
Func _TCP_Server_GetConnections()
	Return $TCP_SERVER_CLIENT
EndFunc

;#####################################
;_TCP_Client_Start($s_Ip, $s_Port)
;		$s_Ip = The Ip you want to connect to
;		$s_Port = The Port you want to use
;
;Returns:
;			True on succsess
;			False on failure
;######################################
Func _TCP_Client_Start($s_Ip, $s_Port)
	TCPStartup()
	$TCP_CLIENT_CONNECTION = TCPConnect($s_Ip, $s_Port)
	If @error Then Return False
	
	$_TCP_CLIENT_TIMERCALLBACK = DllCallbackRegister("_TCP_Client_Events", "none", "hwnd;int;int;dword")
	$pTimerFunc = DllCallbackGetPtr($_TCP_CLIENT_TIMERCALLBACK)
	$iResult = DllCall("user32.dll", "int", "SetTimer", "hwnd", 0, "int", Random(2000,2200,1), "int", '100', "ptr", $pTimerFunc)
	$_TCP_CLIENT_TIMER = $iResult[0]
	Return True
EndFunc

;#############################################
;_TCP_Client_SetOnEvent($s_Event, $s_Func)
;		$s_Event = The event you want to the declear a function to
;		$s_Func = The function you want the event to be handeld in
;
;Returns:
;			True on succsess
;			False on failure
;
;Descriptiong: Sets the function to be called on certin events.
;#############################################
Func _TCP_Client_SetOnEvent($s_Event, $s_Func)
	Switch $s_Event
		Case $Tcp_client_event_open
			$TCP_CLIENT_CONN_FUNCTION = $s_Func
		Case $Tcp_client_event_close
			$TCP_CLIENT_LOST_FUNCTION = $s_Func
		Case $Tcp_client_event_recv
			$TCP_CLIENT_RECV_FUNCTION = $s_Func
		Case Else
			Return False
	EndSwitch
	Return True
EndFunc

;######################
;_TCP_Client_Stop()
;Stops the TCP Stuff
;######################
Func _TCP_Client_Stop()
	If $TCP_CLIENT_CONNECTION = -1 Then 
		TCPShutdown()
		Return False
	EndIf
	
	TCPCloseSocket($TCP_CLIENT_CONNECTION)
	TCPShutdown()
	
	DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "int", $_TCP_CLIENT_TIMER)
	DllCallbackFree($_TCP_CLIENT_TIMERCALLBACK)
	Return True
EndFunc

;Internal Function
Func _TCP_Client_Events($hWnd, $iMsg, $iIDTimer, $dwTime)
	Local $temp_recv
	If $TCP_CLIENT_CONNECTION = -1 Then Return False
	
	$temp_recv = TCPRecv($TCP_CLIENT_CONNECTION,4096)
	If @error Then
		$TCP_CLIENT_CONNECTION = -1
		Call($TCP_CLIENT_LOST_FUNCTION)
		TCPCloseSocket($TCP_CLIENT_CONNECTION)
	ElseIf $TCP_CLIENT_RECV_FUNCTION <> '' And $temp_recv <> '' Then
		Call($TCP_CLIENT_RECV_FUNCTION, $temp_recv)
	EndIf
EndFunc

;#########################################
;_TCP_Client_Send($s_Msg)
;	$s_Msg = The message you want to send
;
;Returns:	See TCPSend
;			
;Descriptiong: Sends Data to the server
;#########################################
Func _TCP_Client_Send($s_Msg)
	Return TCPSend($TCP_CLIENT_CONNECTION, $s_Msg)
EndFunc