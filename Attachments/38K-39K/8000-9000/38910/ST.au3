#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=2012.11.1.23
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------
Fast TCP Server
Author: Petr Krstev
Based on "Fast multi-client TCP server" by Ken Piper
#ce ----------------------------------------------------------------------------
Opt("TCPTimeout", 0)
TCPStartup()

#region ;Safe-to-edit things are below
Global $BindIP = "0.0.0.0" ;Listen on all local addresses
Global $BindPort = 8080 ;Port to Listen to
Global $ClientTimeout = 15000 ;Max idle time is 15 seconds before calling a connection "dead"
Global $CleanupTimeout = 1000 ;Max ms between cleanup
Global $PacketSize = 2048 ;Max packet size per-check
Global $MaxClients = 1000 ;Max simultaneous clients
#endregion ;Stuff you shouldn't touch is below

Global $Listen
Global $Socket[$MaxClients] ; Rows of data
Global $RemoteIP[$MaxClients] ; Rows of data
Global $TimeStamp[$MaxClients] ; Rows of data
Global $Buffer[$MaxClients] ; Rows of data
Global $Stack[$MaxClients+2] ; Stack to hold numbers of the free rows of data
Global $SP = 0
Global $Ws2_32 = DllOpen("Ws2_32.dll") ;Open Ws2_32.dll, it might get used a lot
Global $NTDLL = DllOpen("ntdll.dll") ;Open ntdll.dll, it WILL get used a lot
Global $CleanupTimer = TimerInit() ;This is used to time when things should be cleaned up
Global $NeedExit = False

PreloadStack()

OnAutoItExitRegister("Close") ;Register this function to be called if the server needs to exit

$Listen = TCPListen($BindIP, $BindPort, $MaxClients) ;Start listening on the given IP/port
If @error Then Exit 1 ;Exit with return code 1 if something was already bound to that IP and port

While 1
	USleep(5000, $NTDLL) ;This is needed because TCPTimeout is disabled. Without this it will run one core at ~100%.
	;The USleep function takes MICROseconds, not milliseconds, so 1000 = 1ms delay.
	;When working with this granularity, you have to take in to account the time it takes to complete USleep().
	;1000us (1ms) is about as fast as this should be set. If you need more performance, set this from 5000 to 1000,
	;but doing so will make it consume a bit more CPU time to get that extra bit of performance.
	Local $iSock = TCPAccept($Listen) ;See if anything wants to connect
	If $iSock = -1 Then ;No connection request
		Check() ;Check recv buffers...
		DoIt() ; ...and do things
		If TimerDiff($CleanupTimer) > $CleanupTimeout Then ;If it has been more than 1000ms since Cleanup() was last called, call it now
			$CleanupTimer = TimerInit() ;Reset $CleanupTimer, so it is ready to be called again
			Cleanup() ;Clean up the dead connections
		EndIf
		if $NeedExit Then ExitLoop ;Exit demanded from client
	Else ;There is connection request
		If $SP = 0 Then ;If $SP = 0 then the max connection limit has been reached
			TCPCloseSocket($iSock) ;It has been reached, close the new connection and continue back at the top of the loop
		Else
			Local $FreeSock = Pop() ;Get the next free row in data
			$Socket[$FreeSock] = $iSock ;Set the socket ID of the connection
			$RemoteIP[$FreeSock] = SocketToIP($iSock, $Ws2_32) ;Set the IP Address the connection is from
			$TimeStamp[$FreeSock] = TimerInit() ;Set the timestamp for the last known activity timer
		$Buffer[$FreeSock] = "" ;Blank the recv buffer
		EndIf
	EndIf
WEnd

Func Check() ;for incoming data
	If $SP >= $MaxClients Then Return ;If there are no clients connected, stop the function right now
	For $i = 0 To $MaxClients-1 ;Loop through all rows
		If $Socket[$i] > 0 Then ;valid socket in the row
			Local $sRecv = TCPRecv($Socket[$i], $PacketSize) ;Read $PacketSize bytes from the current client's TCP buffer
			If @error Then ;Check if there was an error
				TCPCloseSocket($Socket[$i]) ;If yes, close the connection
				$Socket[$i] = -1 ;Set the socket ID to an invalid socket
				Push($i) ;Free this row
				ContinueLoop
			EndIf
			If $sRecv <> "" Then ;If there was data sent from the client
				$Buffer[$i] &= $sRecv ;add it to the buffer
				$TimeStamp[$i] = TimerInit() ;update the activity timer
			EndIf
		EndIf
	Next
EndFunc

Func DoIt() ;Processing incoming data
	For $i = 0 To $MaxClients-1 ;Loop through all rows
		If $Buffer[$i] <> "" Then ;Data buffer in the row is not empty
			#region ;Example data processing stuff here. This is handling for a simple "echo" server with line handling
			Local $sLine = StringSplit($Buffer[$i], @CRLF, 1) ;Split up the data in to an array,...
			For $j = 1 To $sLine[0]-1 ; ...so it is easy to loop through each line
				If $sLine[$j] = "terminate" Then $NeedExit = True ;Client want terminate the server itself (not just connection)
				TCPSend($Socket[$i], "Echoing line: '" & $sLine[$j] & "'" & @CRLF) ;Echo back the line the client sent
			Next
			$Buffer[$i] = $sLine[$sLine[0]] ;Put last incomplete line back in the buffer
			#endregion ;Example
		EndIf
	Next
EndFunc

Func Cleanup() ;Clean up any disconnected clients to regain resources
	If $SP >= $MaxClients Then Return ;If no clients are connected then return
	For $i = 0 To $MaxClients-1 ;Loop through all rows
		If $Socket[$i] > 0 Then ;valid socket in the row
			$Buffer[$i] &= TCPRecv($Socket[$i], $PacketSize) ;Dump any data not-yet-seen in to their recv buffer
			If TimerDiff($TimeStamp[$i]) > $ClientTimeout Then ;Check to see if the connection has been inactive for a while
				TCPCloseSocket($Socket[$i]) ;If yes, close the connection
				$Socket[$i] = -1 ;Set the socket ID to an invalid socket
				Push($i) ;Free this row
			EndIf
		EndIf
	Next
EndFunc

Func Close()
	DllClose($Ws2_32) ;Close the open handle to Ws2_32.dll
	DllClose($NTDLL) ;Close the open handle to ntdll.dll
	For $i = 0 To $MaxClients-1 ;Loop through all rows
		If $Socket[$i] > 0 Then TCPCloseSocket($Socket[$i]) ;Force the client's connection closed
	Next
	TCPCloseSocket($Listen) ;Force the server's binded connection closed
	TCPShutdown() ;Shut down networking stuff
EndFunc

Func SocketToIP($iSock, $hDLL = "Ws2_32.dll") ;A rewrite of that _SocketToIP function that has been floating around for ages
	Local $structName = DllStructCreate("short;ushort;uint;char[8]")
	Local $sRet = DllCall($hDLL, "int", "getpeername", "int", $iSock, "ptr", DllStructGetPtr($structName), "int*", DllStructGetSize($structName))
	If Not @error Then
		$sRet = DllCall($hDLL, "str", "inet_ntoa", "int", DllStructGetData($structName, 3))
		If Not @error Then Return $sRet[0]
	EndIf
	Return "0.0.0.0" ;Something went wrong, return an invalid IP
EndFunc

Func USleep($iUsec, $hDLL = "ntdll.dll") ;A rewrite of the _HighPrecisionSleep function made by monoceres (Thanks!)
	Local $hStruct = DllStructCreate("int64")
	DllStructSetData($hStruct, 1, -1 * ($iUsec * 10))
	DllCall($hDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", DllStructGetPtr($hStruct))
EndFunc

Func PreloadStack()
Local $i
	For $i = 0 to $MaxClients-1
		Push($i)
	Next
EndFunc

Func Push($Value)
	if $SP < $MaxClients Then
		$Stack[$SP] = $Value
		$SP += 1
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func Pop()
	if $SP > 0 Then
		$SP -= 1
		Return $Stack[$SP]
	Else
		Return -1
	EndIf
EndFunc