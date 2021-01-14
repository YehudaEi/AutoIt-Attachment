#include <ASock.au3>
Const $WM_USER = 1024
;;;
Const $B_BEPOLITE    = False
Const $N_MAXSOCKETS  = 25
Const $N_DEFAULTPORT = 42775
Const $N_MAXRECV     = 65536
Const $N_WAITCLOSE   = 2000
Const $N_WAITWORK    = 750
;;;
Dim $hListenSocket
Dim $hSockets[ $N_MAXSOCKETS ]
Dim $hNotifyGUI
Dim $g_bExecExit = True

Opt( "OnExitFunc", "ExitProgram" )
;;;
main( )
;;;
Func main( )
	Dim $iPort
	Dim $i
	;;;
	If Not TCPStartup( ) Then Error( "WSAStartup() failed.", False )
	
	$hListenSocket = _ASocket( )
	If @error Then Error( "Socket creation failed.", False )
	
	$hNotifyGUI = GUICreate( "Dummy Notify Window / " & TimerInit( ) )
	_ASockSelect( $hListenSocket, $hNotifyGUI, $WM_USER, $FD_ACCEPT )
	If @error Then Error( "Error selecting FD_ACCEPT event." )
	GUIRegisterMsg( $WM_USER, "OnAccept" )
	
	For $i = 0 To $N_MAXSOCKETS - 1
		$hSockets[ $i ] = -1
		GUIRegisterMsg( $WM_USER + 1 + $i, "OnSocketEvent" )
	Next
	
	$iPort = InputBox( "Listen Port", "Enter the port to listen to:", $N_DEFAULTPORT, " M5" )
	If @error Then _Exit( )
	
	_ASockListen( $hListenSocket, "0.0.0.0", $iPort )
	If @error Then Error( "Error trying to listen on port " & $iPort & ", INADDR_ANY." & @CRLF & "@error = " & @error & " @extended = " & @extended )
	
	Out( "Have begun to listen on port " & $iPort & ", INADDR_ANY. Waiting..." )
	
	; Place your code here.
	$i = 1
	While 1
		Out( "Doing serious work indeed... (" & $i & ")" )
		$i += 1
		For $j = 0 To $N_MAXSOCKETS - 1
			If $hSockets[ $j ] <> -1 Then
				TCPSend( $hSockets[ $j ], "Zorgians are attacking from the ship #" & $i & "!" )
			EndIf
		Next
		Sleep( $N_WAITWORK )
	WEnd
	; I presume that this code will not be executed.
	; Correct me if I'm wrong.	
EndFunc

Func OnAccept( $hWnd, $iMsgID, $WParam, $LParam )
	Local $hSocket = $WParam
	Local $iError = _HiWord( $LParam )
	Local $iEvent = _LoWord( $LParam )
	
	Local $iFreeSock
	Local $hTempSock
	
	If $iMsgID = $WM_USER Then
		If $iError <> 0 Then
			Error( "OnAccept: error while listening or trying to listen!" )
		EndIf
		$iFreeSock = FreeSock( )
		If $iFreeSock = -1 Then; No vacancies!
			$hTempSock = TCPAccept( $hSocket )
			If $hTempSock <> -1 Then
				TCPSend( $hTempSock, "No vacancies!" )
				_ASockShutdown( $hTempSock )
				If $B_BEPOLITE Then
					Sleep( $N_WAITCLOSE / 10 )
				Else
					Sleep( 1 )
				EndIf
				TCPCloseSocket( $hTempSock )
			EndIf
		Else
			$hSockets[ $iFreeSock ] = TCPAccept( $hSocket )
			If $hSockets[ $iFreeSock ] = -1 Then; This shouldn't happen.
				Out( "+> OnAccept: Hmm thought I'd catch a connection... Oh well." )
			Else
				Out( "+> OnAccept: Accepted a connection on socket #" & $iFreeSock + 1 & " (socket " & $hSockets[ $iFreeSock ] & ")" )
				TrayTip( "Accepted a connection", "Socket #" & $iFreeSock + 1 & "; handle = " & $hSockets[ $iFreeSock ] & @CRLF & "IP address = " & SocketToIP( $hSockets[ $iFreeSock ] ), 30 )
				_ASockSelect( $hSockets[ $iFreeSock ], $hNotifyGUI, $WM_USER + $iFreeSock + 1, _
				              BitOR( $FD_READ, $FD_WRITE, $FD_CLOSE ) )
				If @error Then Error( "Error selecting events on socket #" & $iFreeSock + 1 & "." )
			EndIf
		EndIf
	EndIf
EndFunc

Func OnSocketEvent( $hWnd, $iMsgID, $WParam, $LParam )
	Local $hSocket = $WParam
	Local $nSocket = $iMsgID - $WM_USER - 1
	Local $iError = _HiWord( $LParam )
	Local $iEvent = _LoWord( $LParam )
	
	Local $sDataBuff
	Local $iSent
	
	If $iMsgID > $WM_USER And $iMsgID <= $WM_USER + $N_MAXSOCKETS Then		
		Switch $iEvent
			Case $FD_READ; Data has arrived!
				If $iError <> 0 Then
					BreakConn( $nSocket, "FD_READ was received with the error value of " & $iError & "." )
				Else
					$sDataBuff = TCPRecv( $hSocket, $N_MAXRECV )
					If @error Then
						BreakConn( $nSocket, "Conn is down while recv()'ing, error = " & @error & "." )
					ElseIf $sDataBuff <> "" Then
						Out( "<Data from socket #" & $nSocket + 1 & ">" )
						Out( $sDataBuff )
						Out( "</Data from socket #" & $nSocket + 1 & ">" & @CRLF )
						TrayTip( "Data from socket #" & $nSocket + 1, $sDataBuff, 30 )
					Else; This DEFINITELY shouldn't have happened
						Out( "Warning: schizophrenia! FD_READ, but no data on socket #" & $nSocket + 1 & "!" )
					EndIf
				EndIf
			Case $FD_WRITE
				If $iError <> 0 Then
					BreakConn( $nSocket, "FD_SEND was received with the error value of " & $iError & "." )
				EndIf
			Case $FD_CLOSE; Bye bye
				_ASockShutdown( $hSocket )
				Out( "Connection was closed on socket #" & $nSocket + 1 & "." )
				If $B_BEPOLITE Then
					Sleep( $N_WAITCLOSE / 10 )
				Else
					Sleep( 1 )
				EndIf
				TCPCloseSocket( $hSockets[ $nSocket ] )
				$hSockets[ $nSocket ] = -1
		EndSwitch
	EndIf
EndFunc

Func BreakConn( $nSocket, $sError )
	_ASockShutdown( $hSockets[ $nSocket ] )
	Out( "Connection has broken on socket #" & $nSocket + 1 & "." )
	Out( "Cause: " & $sError )
	If $B_BEPOLITE Then
		Sleep( $N_WAITCLOSE / 10 )
	Else
		Sleep( 1 )
	EndIf
	TCPCloseSocket( $hSockets[ $nSocket ] )
	$hSockets[ $nSocket ] = -1
EndFunc

Func FreeSock( )
	For $i = 0 To $N_MAXSOCKETS - 1
		If $hSockets[ $i ] = -1 Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc

Func Error( $sText, $bCloseSockets = True, $iExitCode = 1 )
	MsgBox( 16, "Server Error", $sText )
	_Exit( $bCloseSockets, $iExitCode )
EndFunc

Func _Exit( $bCloseSockets = True, $iExitCode = 0 )
	If $bCloseSockets Then
		TCPCloseSocket( $hListenSocket )
		For $i = 0 To $N_MAXSOCKETS - 1
			_ASockShutdown( $hSockets[ $i ] ); Graceful shutdown.
		Next
		Sleep( $N_WAITCLOSE )
		For $i = 0 To $N_MAXSOCKETS - 1
			TCPCloseSocket( $hSockets[ $i ] )
		Next
	EndIf
	TCPShutdown( )
	$g_bExecExit = False
	Exit $iExitCode
EndFunc

Func Out( $sText )
	ConsoleWrite( $sText & @CRLF )
EndFunc

Func ExitProgram( )
	If $g_bExecExit Then
		Out( "+> ////////////////////////////// Closing... //////////////////////////////" )
		Out( "+> //////////////////////////// Exit method: " & @exitMethod & "////////////////////////////" )
		_Exit( True, @exitCode )
	EndIf
EndFunc

; AutoIt Help -> TCPRecv
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int_ptr",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = "(Could not resolve)"
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc


