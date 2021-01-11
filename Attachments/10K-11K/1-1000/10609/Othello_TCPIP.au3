#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.0.1
 Author:         Donald Nelson - donnie@nelsagen.com

 Script Function:
	All of my TCP/IP Functions for Othello

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include-once


Func _RGB( $R, $G, $B )
	Return ( "0x" & StringRight( Hex( $R ), 2 ) & StringRight( Hex( $G ), 2 ) & StringRight( Hex( $B ), 2 ) )
EndFunc

Func _UpdateBanner( ByRef $oEdit, $i )
	GUICtrlSetPos( $oEdit, $i, 50 )
EndFunc

Func _Host()
	;Create the GUI
	$frmTemp = GUICreate( "Hosting a Game", 340, 100 )
	$lblTemp = GUICtrlCreateLabel( "Waiting for a Player to connect to your server", 10, 20, 320, 30 )
	GUICtrlSetFont( $lblTemp, "12" )
	
	$lblBack = GUICtrlCreateLabel( "",0,45,400,40 )
	GUICtrlSetBkColor( $lblBack, 0x000000 )	
	$lbl1 = GUICtrlCreateLabel( "We are still waiting for someone to play Othello.", 20, 50, 500, 30 )
	$lbl2 = GUICtrlCreateLabel( "We are still waiting for someone to play Othello.", 420, 50, 500, 30 )
	GUICtrlSetFont( $lbl1, "16" )
	GUICtrlSetFont( $lbl2, "16" )
	GUICtrlSetColor( $lbl1, 0xff0000 )
	GUICtrlSetColor( $lbl2, 0xff0000 )
	GUICtrlSetBkColor( $lbl1, 0x000000 )
	GUICtrlSetBkColor( $lbl2, 0x000000 )
	
	GUISetState()
	
	TCPStartup()
	$gMainSocket = TCPListen( $_IPADDRESS, $_PORT, 1 )
	Dim $iTemp = 0
	Dim $value = -1
	Do
		Sleep ( 10 )
		$iTemp += $value
		If $iTemp >= 225 Then
			$value = -3
		ElseIf $iTemp <= 0 Then
			$iTemp = 500
		EndIf
		_UpdateBanner( $lbl1, $iTemp )
		_UpdateBanner( $lbl2, $iTemp - 500 )
		$msg = GUIGetMsg()
		
		Select
			Case $msg = $GUI_EVENT_CLOSE
				TCPShutdown()
				$gConnectedSocket = -1
				ExitLoop
		EndSelect
		
		;Check to see if the Connection is establised
		$gConnectedSocket = TCPAccept( $gMainSocket )
	Until $gConnectedSocket <> -1
	
	If $gConnectedSocket <> -1 Then
		$IP_Accepted = SocketToIP($gConnectedSocket)
		_UpdateTxtRead( "Connection Established", 0 )
		_UpdateTxtRead( "You are the White Player", 0 )
		$bActive = True
		$Me = 1
		$Him = 2
		_NewGame()
		$gBoard = _ValidateBoard( $gBoard )
		$pTurn = 1
		GUICtrlSetState( $txtType, $GUI_FOCUS )
	Else
		TCPShutdown()
	EndIf
	
	GUIDelete( $frmTemp )
EndFunc

Func _Connect()
	Dim $done = -1
	
	Do
		$Result = InputBox( "Server Address", "Enter the Computer Name or IP Address of the server you wish to connect to." )
	
		If @error = 1 Then
			;cancel Button was pushed
			Return 1
		ElseIf $Result <> "" Then
			$done = 1
		EndIf
	Until $done <> -1
	
	
	
	;Create the GUI
	$frmTemp = GUICreate( "Searching for a Game", 300, 100 )
	$lblTemp = GUICtrlCreateLabel( "Looking for a Server to connect to", 20, 20, 280, 30 )
	GUICtrlSetFont( $lblTemp, "12" )
	$prgBar = GUICtrlCreateProgress( 20, 50, 260, 30 )
	GUISetState()
	
	TCPStartup()
	Dim $IPADDRESS = TCPNameToIP( $Result )
	$done = 0
	Dim $Nothing = 0
	
	Do
		Sleep ( 10 )
		
		;Try the connection 10 times before quiting
		$done = $done + 1
	
		;Attempt the connection (Default timeout is 100 milliseconds)
		$gConnectedSocket = TCPConnect( $IPADDRESS, $_PORT )
		If @error = 1 Then
			;Problem with the IP Address
			MsgBox( 64, "Error", "The IP Address is the problem. Try it again.", 3 )
			$gConnectedSocket = -1
			GUIDelete( $frmTemp )
			Return 1
		EndIf
		
		$msg = GUIGetMsg()
		If $gConnectedSocket <> -1 Then
			_UpdateTxtRead( "Connection Established", 0 )
			_UpdateTxtRead( "You are the Black Player", 0 )
			$Me = 2
			$Him = 1
			$bActive = True
			GUIDelete( $frmTemp )
			_NewGame()
			$gBoard = _ValidateBoard( $gBoard )
			$pTurn = 1
			GUICtrlSetState( $txtType, $GUI_FOCUS )
			Return 1
		Else
			Select
				Case $msg = $GUI_EVENT_CLOSE
					TCPShutdown()
					$gConnectedSocket = -1
					GUIDelete( $frmTemp )
					ExitLoop					
				Case $done = 10
					TCPShutdown()
					$gConnectedSocket = -1
					GUIDelete( $frmTemp )
					ExitLoop
			EndSelect
		EndIf
	Until $Nothing = 1
	MsgBox(64,"Lost and Found","No Server Found.", 3 )
EndFunc

; Function to return IP Address from a connected socket.
;----------------------------------------------------------------------
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int_ptr",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc

Func _SendBoard( $gBoard )
	Dim $sTemp = $Me & $enumGameBoard
	
	;Cycle through the game board and save the board to a string to send via TCP/IP
	For $x = 0 to 7
		For $y=0 To 7
			$sTemp = $sTemp & $gBoard[$x][$y][0]
		Next
	Next
		TCPSend( $gConnectedSocket, $sTemp )
EndFunc

Func _RecieveData()
	Dim $recv = TCPRecv( $gConnectedSocket, 2048 )
	
	If @error Then
		Return -99
	EndIf
	
	$Who = StringMid( $recv, 1, 1 )
	$What = StringMid( $recv, 2, 1 )
	$Remaining = StringMid( $recv, 3 )
	
	Select
		Case $What = $enumGameBoard
			Dim $iTemp
			Dim $tBoard[8][8][3]
			
			;Cycle through and get new board data
			For $x = 0 to 7
				For $y = 0 To 7
					$iTemp += 1
					$tBoard[$x][$y][0] = StringMid( $Remaining, $iTemp, 1 )
				Next
			Next
			
			;Replace my old gameboard with the new gameboard
			$gBoard = _ValidateBoard( $tBoard )
			_UpdateBoard()
			Dim $Result = WhoCanMove( $gBoard )
			If $Result = $me Then
				;I can't move
				$pTurn = _OtherPlayer( $Me )
				$gBoard = _ValidateBoard( $gBoard )
				_sendboard( $gBoard )
			Else
				$pTurn = $me
			EndIf
			_UpdateCount()
		Case $What = $enumText
			_UpdateTxtRead( $Remaining, $Who )
		Case $What = $enumQuit
			_UpdateTxtRead( $Remaining, $Who )
			_ClearBoard()
			TCPShutdown()
			$bActive = False
			$gConnectedSocket = -1
		case $What = $enumGameOver
			_UpdateTxtRead( $recv, $Who )
			$bGameOver = True
			$bActive = False
	EndSelect
	
EndFunc

Func _SendMessage( $sValue )
	Dim $sTemp = $me & $enumText & $sValue
	TCPSend( $gConnectedSocket, $sTemp )
EndFunc
