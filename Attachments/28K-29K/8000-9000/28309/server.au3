#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include<Winapi.au3>
#include<Array.au3>
#include<Asock.au3>
#include"Stats.au3"
Global $TimeOut_Answer = 0
Global $GAME_STATUS = 0
#Region -- Cards --
Dim $CardsArray[52][2]
Global $CurrentCardArray
#EndRegion -- Cards --
#Region -- Blinds Variables --
;Global $MAX_BLIND ; No Limit Rules.
Global $WAIT_SCRIPT = 100
Global $MIN_BLIND = 1
Global $CURRENT_BLIND = 1
Global $START_MONEY = 100
#EndRegion -- Blinds Variables --
#Region -- Player Variables --
; $PlayersArray[x][0] = Player Socket
; $PlayersArray[x][1] = Player Name
; $PlayersArray[x][2] = Player Status
; $PlayersArray[x][3] = Player Money
; $PlayersArray[x][4] = Player Points
; $PlayersArray[x][5] = Player Cards
Global $Inqueue_Players[1]
$Inqueue_Players[0] = 0
Global $PlayersArray[10][6]
For $ii = 0 To 9
	$PlayersArray[$ii][0] = 0 ; No Players
Next
Global $FreePlaces[11]
$FreePlaces[0] = 10
For $i = 1 To 10
	$FreePlaces[$i] = $i
Next
Global $CurrentPlayerDealer
Global $CurrentPlayerBigBlind
Global $CurrentPlayerSmallBlind
Global $CurrentPlayerPlaying
Global $PlayersHasPlayed = False
Global $PlayerWaitForAnswer = False ; Test if the clients has well answered
Global $PlayerCount = 0
#EndRegion -- Player Variables --
Const $B_BEPOLITE = False
Const $N_MAXSOCKETS = 25
Const $N_DEFAULTPORT = 42775
Const $N_MAXRECV = 65536
Const $N_WAITCLOSE = 2000
Const $N_WAITWORK = 750
Global Const $MINPLAYERS = 4 ; Can't be < 4
Global Const $MAXPLAYERS = 10
Global $bDebugConn = True
Global $bDebugGame = True
Global $bDebugGlobal = True
Global $bTestGame = False
Global $NumberOfCardsGiven = 0
Global $TIME_COUNT = 0
Global $TIMEOUT_PLAY = 30 ; In seconds
;;;
Dim $hListenSocket
Dim $hSockets[$N_MAXSOCKETS]
Dim $hNotifyGUI
Dim $g_bExecExit = True
Dim $g_bSent = False
Opt("OnExitFunc", "ExitProgram")
$CardIndex = -1
For $TypeCard = 1 To 4
	
	For $CardNumber = 1 To 10
		$CardIndex += 1
		;ConsoleWrite($CardIndex & @crlf)
		$CardsArray[$CardIndex][0] = $CardNumber
		$CardsArray[$CardIndex][1] = $TypeCard
		
		
	Next
	; Valet
	$CardIndex += 1
	$CardsArray[$CardIndex][0] = "V"
	$CardsArray[$CardIndex][1] = $TypeCard
	; Queen
	$CardIndex += 1
	$CardsArray[$CardIndex][0] = "Q"
	$CardsArray[$CardIndex][1] = $TypeCard
	; King
	$CardIndex += 1
	$CardsArray[$CardIndex][0] = "K"
	$CardsArray[$CardIndex][1] = $TypeCard
	;$CardIndex += 1
Next
;_ArrayDisplay($CardsArray)
Dim $MixArray = $CardsArray
For $i = 0 To Random(1, 5, 1)
	ConsoleWrite("Mix n° " & $i & @CRLF)
	$MixArray = _mix_cards($MixArray)
Next
;_ArrayDisplay($MixArray)
$CurrentCardArray = $MixArray
main()
Func _mix_cards($CardsArrayToMix)
	Local $indexToTake, $MaxIndex = 51
	$tempCardArray = $CardsArrayToMix
	Local $NewCardArray[52][2]
	For $i = 0 To 51
		$indexToTake = Random(0, $MaxIndex, 1)
		;ConsoleWrite("IndexToTake" & $indexToTake & @tab & ubound($tempCardArray) & @crlf )
		$NewCardArray[$i][0] = $tempCardArray[$indexToTake][0]
		$NewCardArray[$i][1] = $tempCardArray[$indexToTake][1]
		$MaxIndex -= 1
		_ArrayDelete($tempCardArray, $indexToTake)
	Next
	
	
	Return $NewCardArray
	
	
EndFunc   ;==>_mix_cards
Func _setsmallblind()
EndFunc   ;==>_setsmallblind
Func _choose_position()
	Local $choice = $FreePlaces[Random(1, $FreePlaces[0], 1)]
	_ArrayDelete($FreePlaces, $choice)
	$FreePlaces[0] -= 1
	Return $choice - 1
EndFunc   ;==>_choose_position
Func _send_player($PlayerSocket, $message, $bWait = False)
	If $PlayerSocket = 0 Then
		If $bDebugConn Then Out("! Received invalid handle for message " & $message)
		
	Else
		$PlayerWaitForAnswer = $PlayerSocket
		If $bDebugConn Then Out("SEND to Socket >" & $PlayerSocket & @TAB & $message & "<")
		
		TCPSend($PlayerSocket, $message)
		If @error Then
			_tcp_send_error($PlayerSocket)
		Else
			Out("SUCCESS")
		EndIf
		
		If $bWait Then
			$TimeOut_Answer = 0
			While 1
				Sleep($WAIT_SCRIPT)
				If $PlayerWaitForAnswer = 0 Then ExitLoop
				If $TimeOut_Answer > 5 Then ExitLoop
				$TimeOut_Answer += 1
			WEnd
			
			If $TimeOut_Answer > 5 Then
				If $bDebugConn Then Out("Timeout while waiting success response from client " & $PlayerWaitForAnswer)
				;TCPCloseSocket($PlayerSocket) ; Kick Him (time out issues)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_send_player
Func _GetNewPlayer($NewPlayerSocket, $getData)
	;$getData = TCPRecv($NewPlayerSocket, 512)
	If $getData = "" Or @error <> 0 Then
		_Debug_("Error while getting client infos, discontinued.")
	Else
		If $bDebugGame Then Out("Player Connected")
		If $bDebugConn Then Out("GETDATA " & $getData)
		$getData = StringSplit($getData, ",,,", 1)
		$NewUserName = $getData[1]
		;Chech if user already exists
		For $ii = 0 To UBound($PlayersArray) - 1
			If $PlayersArray[$ii][1] = $NewUserName Then
				If $bDebugGame Then Out("Already exists Username")
				If $bDebugConn Then Out("New Socket was " & $NewPlayerSocket & @TAB & " and removing " & $hSockets[UBound($hSockets) - 1])
				_send_player($NewPlayerSocket, "KickedMe,,,SameUser", False)
				TCPCloseSocket($NewPlayerSocket) ;Force disconnect (kick)
				Return False ; Nope...
			EndIf
		Next
		Sleep($WAIT_SCRIPT)
		$MessageWhenentering = $getData[2]
		Local $NewPosition = _choose_position()
		$PlayerWaitForAnswer = $NewPlayerSocket
		_send_player($NewPlayerSocket, "Position,,," & $NewPosition)
		;sleep($WAIT_SCRIPT)
		If $bDebugGame Then Out("Choosen position is " & $NewPosition)
		Sleep($WAIT_SCRIPT)
		If $PlayerCount > 1 Then
			_sendtoall("NewPlaye", $NewUserName & "@@@" & $NewPosition)
			If $bDebugConn Then Out("Already one player, adding one more")
			;	ReDim $PlayersArray[UBound($PlayersArray) + 1][5]
		EndIf
		If $bDebugConn Then Out("+> New Socket " & $NewPlayerSocket)
		$PlayersArray[$NewPosition][0] = $NewPlayerSocket
		$PlayersArray[$NewPosition][1] = $NewUserName
		$PlayersArray[$NewPosition][2] = $MessageWhenentering
		If $bDebugGame Then Out(":> New Player " & $NewUserName & @CRLF & "+> /////// ________________ \\\\\\")
		
		If $bTestGame Then
			$NumberOfCardsGiven = Random(1, 41, 1)
			
			Local $FLOP = ""
			$FLOP = $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
			$NumberOfCardsGiven += 1
			$FLOP &= ";" & $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
			$NumberOfCardsGiven += 1
			$FLOP &= ";" & $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
			
			_sendtoall("SEE FLOP", $FLOP)
		EndIf
		$PlayerCount += 1
		Sleep($WAIT_SCRIPT)
		If $PlayerCount > 1 Then
			Local $ListPlayers = ""
			For $iii = 0 To UBound($PlayersArray) - 1
				If $PlayersArray[$iii][0] <> 0 And $iii <> $NewPosition Then
					$ListPlayers &= $PlayersArray[$iii][1] & "@@@" & $iii & ";;;"
				EndIf
			Next
			_send_player($NewPlayerSocket, "PlayList,,," & StringTrimRight($ListPlayers, 3))
			;_send_player($NewPlayerSocket, "GetMoney,,," & $START_MONEY & " &")
		EndIf
		
		If $PlayerCount >= $MINPLAYERS Then
			If $bDebugGame Then Out("Starting new game")
			$GAME_STATUS = 1 ;Start game
		Else
			If $bDebugGame Then Out("Not enough players to play")
		EndIf
		;_send_player($NewPlayerSocket, "Test  OK,,," & $NewPosition,True)
	EndIf
EndFunc   ;==>_GetNewPlayer
Func _Debug_($Infos)
	If $bDebugGlobal Then
		ConsoleWrite($Infos & @CRLF)
	EndIf
EndFunc   ;==>_Debug_
Func main()
	Dim $iPort
	Dim $i
	;;;
	If Not TCPStartup() Then Error("WSAStartup() failed.", False)
	
	$hListenSocket = _ASocket()
	If @error Then Error("Socket creation failed.", False)
	
	$hNotifyGUI = GUICreate("Dummy Notify Window / " & TimerInit())
	_ASockSelect($hListenSocket, $hNotifyGUI, $WM_USER, $FD_ACCEPT)
	If @error Then Error("Error selecting FD_ACCEPT event.")
	GUIRegisterMsg($WM_USER, "OnAccept")
	
	For $i = 0 To $N_MAXSOCKETS - 1
		$hSockets[$i] = -1
		GUIRegisterMsg($WM_USER + 1 + $i, "OnSocketEvent")
	Next
	
	$iPort = 8455
	If @error Then _Exit()
	
	_ASockListen($hListenSocket, "0.0.0.0", $iPort)
	If @error Then Error("Error trying to listen on port " & $iPort & ", INADDR_ANY." & @CRLF & "@error = " & @error & " @extended = " & @extended)
	
	Out("Have begun to listen on port " & $iPort & ", INADDR_ANY. Waiting...")
	
	; Place your code here.
	$GAME_STATUS = 0 ; Waiting more Players
	$i = 1
	While 1
		;Out("Doing serious work indeed... (" & $i & ")")
		;If Not $g_bSent Then
		;		For $j = 0 To $N_MAXSOCKETS - 1
		;		If $hSockets[$j] <> -1 Then
		;			;TCPSend( $hSockets[ $j ], "Zorgians are attacking from the ship #" & $i & "!" )
		;			$g_bSent = True
		;			TCPSend($hSockets[$j], $sBigDataBuffer)
		;		EndIf
		;	Next
		;EndIf
		;$i += 1
		;out("Nothing")
		While $Inqueue_Players[0] > 0
			_send_player($Inqueue_Players[UBound($Inqueue_Players) - 1], "UserInfo")
			_ArrayDelete($Inqueue_Players, UBound($Inqueue_Players) - 1)
			$Inqueue_Players[0] -= 1
		WEnd
		While $GAME_STATUS <> 0
			Switch $GAME_STATUS
				Case 1 ; First Turn (pré-flop)
					_startNewGame()
				Case 2 ; Second turn
					
				Case 3 ; Third turn
					
				Case 4
			EndSwitch
		WEnd
		;Sleep($N_WAITWORK)
		Sleep(1500)
	WEnd
	; I presume that this code will not be executed.
	; Correct me if I'm wrong.
	; - You're right -
EndFunc   ;==>main
Func OnAccept($hWnd, $iMsgID, $WParam, $LParam)
	Local $hSocket = $WParam
	Local $iError = _HiWord($LParam)
	Local $iEvent = _LoWord($LParam)
	
	Local $iFreeSock
	Local $hTempSock
	
	If $iMsgID = $WM_USER Then
		If $iError <> 0 Then
			Error("OnAccept: error while listening or trying to listen!")
		EndIf
		$iFreeSock = FreeSock()
		If $iFreeSock = -1 Then; No vacancies!
			$hTempSock = TCPAccept($hSocket)
			If $hTempSock <> -1 Then
				;TCPSend($hTempSock, "No vacancies!")
				_ASockShutdown($hTempSock)
				If $B_BEPOLITE Then
					Sleep($N_WAITCLOSE / 10)
				Else
					Sleep(1)
				EndIf
				TCPCloseSocket($hTempSock)
			EndIf
		Else
			$hSockets[$iFreeSock] = TCPAccept($hSocket)
			If $hSockets[$iFreeSock] = -1 Then; This shouldn't happen.
				Out("+> OnAccept: Hmm thought I'd catch a connection... Oh well.")
			Else
				Out("+> OnAccept: Accepted a connection on socket #" & $iFreeSock + 1 & " (socket " & $hSockets[$iFreeSock] & ")")
				;TrayTip( "Accepted a connection", "Socket #" & $iFreeSock + 1 & "; handle = " & $hSockets[ $iFreeSock ] & @CRLF & "IP address = " & SocketToIP( $hSockets[ $iFreeSock ] ), 30 )
				_ASockSelect($hSockets[$iFreeSock], $hNotifyGUI, $WM_USER + $iFreeSock + 1, _
						BitOR($FD_READ, $FD_WRITE, $FD_CLOSE))
				If @error Then Error("Error selecting events on socket #" & $iFreeSock + 1 & ".")
			EndIf
		EndIf
		
	EndIf
EndFunc   ;==>OnAccept
Func OnSocketEvent($hWnd, $iMsgID, $WParam, $LParam)
	ConsoleWrite("gne" & @CRLF)
	#forceref $hWnd, $iMsgID, $WParam
	Local $hSocket = $WParam
	Local $nSocket = $iMsgID - $WM_USER - 1
	Local $iError = _HiWord($LParam)
	Local $iEvent = _LoWord($LParam)
	
	Local $sDataBuff
	Local $iSent
	
	Out("+> Socket #" & $nSocket + 1 & " event #" & $iEvent & " with error #" & $iError)
	
	If $iMsgID > $WM_USER And $iMsgID <= $WM_USER + $N_MAXSOCKETS Then
		Switch $iEvent
			Case $FD_READ; Data has arrived!
				If $iError <> 0 Then
					BreakConn($nSocket, "FD_READ was received with the error value of " & $iError & ".")
				Else
					$sDataBuff = TCPRecv($hSocket, $N_MAXRECV)
					If @error Then
						BreakConn($nSocket, "Conn is down while recv()'ing, error = " & @error & ".")
					ElseIf $sDataBuff <> "" Then
						Out("<Data from socket #" & $nSocket + 1 & ">")
						Out($sDataBuff)
						Out("</Data from socket #" & $nSocket + 1 & ">" & @CRLF)
						If StringLeft($sDataBuff, 2) = "OK" And $PlayerWaitForAnswer = $hSocket Then
							$PlayerWaitForAnswer = 0
						Else
							Switch StringLeft($sDataBuff, 8)
								Case "UserInfo"
									_GetNewPlayer($hSocket, StringTrimLeft($sDataBuff, 11))
								Case "UserChoi"
									; Double Verification
									; Is the player that is playing is the player that is playing ? ... What Else ?
									If $hSocket = $PlayersArray[$CurrentPlayerPlaying][0] Then
										; Do nothing
									Else
										If $bDebugGame Then
											Out("Didn't wait a response from " & $hSocket & @CRLF)
											Out("I was waiting for " & $PlayersArray[$CurrentPlayerPlaying][0] & @CRLF)
											Exit
										EndIf
										TCPCloseSocket($hSocket) ; Kick Him....
										Return False
									EndIf
									;Next
									;$UserChoice = StringSplit($sDataBuff, ",,,")
									If $bDebugGame Then Out("User " & $PlayersArray[$CurrentPlayerPlaying][1] & " choose " & StringTrimLeft($sDataBuff, 11))
									Switch StringTrimLeft($sDataBuff, 11)
										Case "Check"
											$PlayersArray[$CurrentPlayerPlaying][3] = "Checked"
										Case "Fold"
											$PlayersArray[$CurrentPlayerPlaying][3] = "Fold"
										Case "Pay"
											$PlayersArray[$CurrentPlayerPlaying][3] = "Paid"
										Case "Call"
											$PlayersArray[$CurrentPlayerPlaying][3] = "Called"
										Case "Raise"
											_Player_Raised(StringTrimLeft($sDataBuff, 11))
										Case Else
											;Case "Raise"
											
											$PlayersArray[$CurrentPlayerPlaying][3] = "Raised"
									EndSwitch
									$PlayersHasPlayed = True
									
								Case "Disconct"
									
								Case "UserChat"
									
							EndSwitch
						EndIf
						;TrayTip("Data from socket #" & $nSocket + 1, $sDataBuff, 30)
					Else; This DEFINITELY shouldn't have happened
						Out("! FD_READ, but no data on socket #" & $nSocket + 1 & "!")
					EndIf
				EndIf
			Case $FD_WRITE
				Out("FD_WRITE")
				
				;$PlayerWaitForAnswer = $hSocket
				;_send_player($hSocket, " ")
				_ArrayAdd($Inqueue_Players, $hSocket)
				$Inqueue_Players[0] += 1
				If $iError <> 0 Then
					BreakConn($nSocket, "FD_SEND was received with the error value of " & $iError & ".")
				EndIf
			Case $FD_CLOSE; Bye bye
				_ASockShutdown($hSocket)
				Out("Connection was closed on socket #" & $nSocket + 1 & ".")
				If $B_BEPOLITE Then
					Sleep($N_WAITCLOSE / 10)
				Else
					Sleep(1)
				EndIf
				TCPCloseSocket($hSockets[$nSocket])
				$hSockets[$nSocket] = -1
				For $iii = 0 To UBound($PlayersArray) - 1
					If $PlayersArray[$iii][0] = $hSocket Then _Remove_Player_From_Array($iii)
				Next
		EndSwitch
	EndIf
EndFunc   ;==>OnSocketEvent
Func BreakConn($nSocket, $sError)
	_ASockShutdown($hSockets[$nSocket])
	Out("Connection has broken on socket #" & $nSocket + 1 & ".")
	Out("Cause: " & $sError)
	If $B_BEPOLITE Then
		Sleep($N_WAITCLOSE / 10)
	Else
		Sleep(1)
	EndIf
	TCPCloseSocket($hSockets[$nSocket])
	$hSockets[$nSocket] = -1
EndFunc   ;==>BreakConn
Func FreeSock()
	For $i = 0 To $N_MAXSOCKETS - 1
		If $hSockets[$i] = -1 Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>FreeSock
Func Error($sText, $bCloseSockets = True, $iExitCode = 1)
	Out("Server Error" & @TAB & $sText)
	_Exit($bCloseSockets, $iExitCode)
EndFunc   ;==>Error
Func _Exit($bCloseSockets = True, $iExitCode = 0)
	If $bCloseSockets Then
		TCPCloseSocket($hListenSocket)
		For $i = 0 To $N_MAXSOCKETS - 1
			_ASockShutdown($hSockets[$i]); Graceful shutdown.
		Next
		Sleep($N_WAITCLOSE)
		For $i = 0 To $N_MAXSOCKETS - 1
			TCPCloseSocket($hSockets[$i])
		Next
	EndIf
	TCPShutdown()
	$g_bExecExit = False
	Exit $iExitCode
EndFunc   ;==>_Exit
Func Out($sText)
	ConsoleWrite($sText & @CRLF)
EndFunc   ;==>Out
Func ExitProgram()
	If $g_bExecExit Then
		Out("+> ////////////////////////////// Closing... //////////////////////////////")
		Out("+> //////////////////////////// Exit method: " & @exitMethod & "////////////////////////////")
		_Exit(True, @exitCode)
	EndIf
EndFunc   ;==>ExitProgram
; AutoIt Help -> TCPRecv
Func SocketToIP($SHOCKET)
	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	Local $aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, _
			"ptr", DllStructGetPtr($sockaddr), "int_ptr", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = "(Could not get the address)"
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc   ;==>SocketToIP
Func _EndGame()
	For $iii = 0 To UBound($PlayersArray) - 1
		If $PlayersArray[$iii][2] = "Waiting" Then
			_send_player($PlayersArray[$iii][0], "JoinGame")
		EndIf
	Next
EndFunc   ;==>_EndGame
Func _getnextplayer($IndexSrc)
	If $bDebugGlobal Then Out("+ Passing Index " & $IndexSrc)
	If $IndexSrc = 10 Then $IndexSrc = 0
	Local $IndexCount
	$IndexCount = $IndexSrc
	While 1
		If $PlayersArray[$IndexCount][0] = 0 Then
			If $IndexCount = 9 Then
				$IndexCount = 0
			Else
				$IndexCount += 1
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd
	If $bDebugGame Then Out("+ Next Player is " & $PlayersArray[$IndexCount][1])
	Return $IndexCount
EndFunc   ;==>_getnextplayer
Func _startNewGame()
	While 1
		$CurrentPlayerDealer = _getnextplayer(0)
		_send_player($PlayersArray[$CurrentPlayerDealer][0], "Dealer  ,,,You're the dealer")
		$CurrentPlayerSmallBlind = _getnextplayer($CurrentPlayerDealer + 1)
		_send_player($PlayersArray[$CurrentPlayerSmallBlind][0], "Smallbld,,,You're the Small Blind")
		$CurrentPlayerBigBlind = _getnextplayer($CurrentPlayerSmallBlind + 1)
		_send_player($PlayersArray[$CurrentPlayerBigBlind][0], "BigBlind,,,You're the Big Blind")
		$CurrentPlayerPlaying = _getnextplayer($CurrentPlayerBigBlind + 1) ; Player at the left of the Big Blind begins.
		; New game started !!
		Sleep($WAIT_SCRIPT)
		_sendtoall("New Game", "Dummy")
		;First Turn
		Sleep($WAIT_SCRIPT)
		_give_cards()
		;We "Burn" a card
		$NumberOfCardsGiven += 1
		;Now generate flop
		Local $FLOP
		$FLOP = $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
		$NumberOfCardsGiven += 1
		$FLOP &= ";" & $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
		$NumberOfCardsGiven += 1
		$FLOP &= ";" & $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
		;
		Sleep($WAIT_SCRIPT)
		_sendtoall("GetBlind", $CURRENT_BLIND)
		;
		$ii = $CurrentPlayerPlaying
		While 1
			If $bDebugGlobal Then Out("Debug --- Player[" & $ii & "][4] = " & $PlayersArray[$ii][4])
			Local $SplitCards = StringSplit($PlayersArray[$ii][5], ";")
			Local $ArrayCard1 = StringSplit($SplitCards[1], ",")
			Local $ArrayCard2 = StringSplit($SplitCards[2], ",")
			$PlayersArray[$ii][4] = _Calc_points($ArrayCard1, $ArrayCard2, $FLOP, 3)
			$ii = _getnextplayer($ii + 1)
			If $ii = $CurrentPlayerPlaying Then ExitLoop
		WEnd
		
		If $bDebugGame Then Out("First Player playing number = " & $CurrentPlayerPlaying)
		$ii = $CurrentPlayerPlaying
		Local $ExitLoopPlayer = $ii
		While 1
			If $GAME_STATUS = 0 Then ExitLoop
			_send_player($PlayersArray[$ii][0], "YourTurn,,,It's your turn to play")
			_sendtoall("Playing ", $ii, $ii)
			$PlayersHasPlayed = False
			$TIME_COUNT = 0
			While $TIME_COUNT < $TIMEOUT_PLAY
				If $PlayersHasPlayed Then ExitLoop
				$TIME_COUNT += 1
				Sleep(1000)
			WEnd
			If Not $PlayersHasPlayed Then
				_send_player($PlayersArray[$ii][0], "Timeout ,,," & $PlayersArray[$ii][1])
			EndIf
			$ii = _getnextplayer($ii + 1)
			If $ii = $ExitLoopPlayer Then ExitLoop
			$CurrentPlayerPlaying = $ii
			;Next
		WEnd
		If $GAME_STATUS = 0 Then ExitLoop
		; Chech if more than one user have checked / called / raised ....
		Local $HighestScore = 0, $PlayerWinner, $NumberOfPlayerPlaying = 0
		For $ii = 0 To UBound($PlayersArray) - 1
			If $PlayersArray[$ii][0] <> 0 Then
				If $bDebugGame Then Out("Player " & $PlayersArray[$ii][1] & " choose " & $PlayersArray[$ii][3] & " points : " & $PlayersArray[$ii][4])
				If $PlayersArray[$ii][3] = "Called" Or $PlayersArray[$ii][3] = "Raised" Or $PlayersArray[$ii][3] = "Checked" Then
					$NumberOfPlayerPlaying += 1
					If $PlayersArray[$ii][4] = $HighestScore Then
						$PlayerWinner &= ";" & $PlayerWinner
					ElseIf $PlayersArray[$ii][4] > $HighestScore Then
						$HighestScore = $PlayersArray[$ii][4]
						$PlayerWinner = $PlayersArray[$ii][1]
					EndIf
				EndIf
			EndIf
		Next
		; Who wins.
		$GAME_STATUS = 2 ; Continue the game
		If $HighestScore = 0 And $NumberOfPlayerPlaying = 0 Then ; No Players Played
			If $bDebugGame Then
				Out("No Players have played, start new game")
			EndIf
			$GAME_STATUS = 1
			ExitLoop
		EndIf
		If $GAME_STATUS = 0 Or $GAME_STATUS = 1 Then ExitLoop
		; Show them the FLOP
		_sendtoall("SEE FLOP", $FLOP)
		If $NumberOfPlayerPlaying = 1 Then
			If $bDebugGame Then Out("Player " & $PlayerWinner & " Won ")
			_sendtoall("GameInfo", "Player " & $PlayerWinner & " Won ")
			$GAME_STATUS = 1
			ExitLoop
		EndIf
		; Second  turn
		$NumberOfCardsGiven += 1
		$CurrentPlayerPlaying = $CurrentPlayerSmallBlind
		;
		
		If $bDebugGame Then Out("First Player playing number = " & $CurrentPlayerPlaying)
		$ii = $CurrentPlayerPlaying
		;Local $ExitLoopPlayer = $ii
		While 1
			While 1
				If $PlayersArray[$ii][3] = "Fold" Then
					If $bDebugGlobal Then Out("- Player " & $PlayersArray[$ii][1] &  " has fold, searching next player")
				Else
					ExitLoop
				EndIf
				$ii = _getnextplayer($ii + 1)
				$CurrentPlayerPlaying = $ii
			WEnd
			_send_player($PlayersArray[$ii][0], "YourTurn,,,It's your turn to play")
			_sendtoall("Playing ", $ii, $ii)
			$PlayersHasPlayed = False
			$TIME_COUNT = 0
			While $TIME_COUNT < $TIMEOUT_PLAY
				If $PlayersHasPlayed Then ExitLoop
				$TIME_COUNT += 1
				Sleep(1000)
			WEnd
			If Not $PlayersHasPlayed Then
				_send_player($PlayersArray[$ii][0], "Timeout ,,," & $PlayersArray[$ii][1])
			EndIf
			$ii = _getnextplayer($ii + 1)
			If $ii = $ExitLoopPlayer Then ExitLoop
			$CurrentPlayerPlaying = $ii
			;Next
		WEnd
		
		; Chech if more than one user have checked / called / raised ....
		Local $HighestScore = 0, $PlayerWinner, $NumberOfPlayerPlaying = 0
		For $ii = 0 To UBound($PlayersArray) - 1
			If $PlayersArray[$ii][0] <> 0 Then
				If $bDebugGame Then Out("Player " & $PlayersArray[$ii][1] & " choose " & $PlayersArray[$ii][3] & " points : " & $PlayersArray[$ii][4])
				If $PlayersArray[$ii][3] = "Called" Or $PlayersArray[$ii][3] = "Raised" Or $PlayersArray[$ii][3] = "Checked" Then
					$NumberOfPlayerPlaying += 1
					If $PlayersArray[$ii][4] = $HighestScore Then
						$PlayerWinner &= ";" & $PlayerWinner
					ElseIf $PlayersArray[$ii][4] > $HighestScore Then
						$HighestScore = $PlayersArray[$ii][4]
						$PlayerWinner = $PlayersArray[$ii][1]
					EndIf
				EndIf
			EndIf
		Next
		; Who wins.
		If $HighestScore = 0 And $NumberOfPlayerPlaying = 0 Then ; No Players Played
			If $bDebugGame Then
				Out("No Players have played, start new game")
			EndIf
			$GAME_STATUS = 1
			ExitLoop
		EndIf
		
			If $GAME_STATUS = 0 Or $GAME_STATUS = 1 Then ExitLoop
		; Show them the FLOP
		;_sendtoall("SEE FLOP", $FLOP)
		If $NumberOfPlayerPlaying = 1 Then
			If $bDebugGame Then Out("Player " & $PlayerWinner & " Won ")
			_sendtoall("GameInfo", "Player " & $PlayerWinner & " Won ")
			$GAME_STATUS = 1
			ExitLoop
		EndIf
		; Let's see the turn
		$NumberOfCardsGiven += 1
		$FLOP &= ";" & $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
		
		_sendtoall("SEE TURN", $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1])
		$ii = $CurrentPlayerPlaying
		While 1
			If $bDebugGlobal Then Out("Debug --- Player[" & $ii & "][5] = " & $PlayersArray[$ii][5])
			Local $SplitCards = StringSplit($PlayersArray[$ii][5], ";")
			Local $ArrayCard1 = StringSplit($SplitCards[1], ",")
			Local $ArrayCard2 = StringSplit($SplitCards[2], ",")
			$PlayersArray[$ii][4] = _Calc_points($ArrayCard1, $ArrayCard2, $FLOP, 4)
			$ii = _getnextplayer($ii + 1)
			If $ii = $CurrentPlayerPlaying Then ExitLoop
		WEnd
		
		$ii = $CurrentPlayerPlaying
		;Local $ExitLoopPlayer = $ii
		While 1
			While 1
				If $PlayersArray[$ii][3] = "Fold" Then
					If $bDebugGlobal Then Out("- Player " & $PlayersArray[$ii][1] &  " has fold, searching next player")
				Else
					ExitLoop
				EndIf
				$ii = _getnextplayer($ii + 1)
				$CurrentPlayerPlaying = $ii
			WEnd
			_send_player($PlayersArray[$ii][0], "YourTurn,,,It's your turn to play")
			_sendtoall("Playing ", $ii, $ii)
			$PlayersHasPlayed = False
			$TIME_COUNT = 0
			While $TIME_COUNT < $TIMEOUT_PLAY
				If $PlayersHasPlayed Then ExitLoop
				$TIME_COUNT += 1
				Sleep(1000)
			WEnd
			If Not $PlayersHasPlayed Then
				_send_player($PlayersArray[$ii][0], "Timeout ,,," & $PlayersArray[$ii][1])
			EndIf
			$ii = _getnextplayer($ii + 1)
			If $ii = $ExitLoopPlayer Then ExitLoop
			$CurrentPlayerPlaying = $ii
			;Next
		WEnd
		
		; Chech if more than one user have checked / called / raised ....
		Local $HighestScore = 0, $PlayerWinner, $NumberOfPlayerPlaying = 0
		For $ii = 0 To UBound($PlayersArray) - 1
			If $PlayersArray[$ii][0] <> 0 Then
				If $bDebugGame Then Out("Player " & $PlayersArray[$ii][1] & " choose " & $PlayersArray[$ii][3] & " points : " & $PlayersArray[$ii][4])
				If $PlayersArray[$ii][3] = "Called" Or $PlayersArray[$ii][3] = "Raised" Or $PlayersArray[$ii][3] = "Checked" Then
					$NumberOfPlayerPlaying += 1
					If $PlayersArray[$ii][4] = $HighestScore Then
						$PlayerWinner &= ";" & $PlayerWinner
					ElseIf $PlayersArray[$ii][4] > $HighestScore Then
						$HighestScore = $PlayersArray[$ii][4]
						$PlayerWinner = $PlayersArray[$ii][1]
					EndIf
				EndIf
			EndIf
		Next
		
		; Who wins.
		If $HighestScore = 0 And $NumberOfPlayerPlaying = 0 Then ; No Players Played
			If $bDebugGame Then
				Out("No Players have played, start new game")
			EndIf
			$GAME_STATUS = 1
			ExitLoop
		EndIf
		
			If $GAME_STATUS = 0 Or $GAME_STATUS = 1 Then ExitLoop
		; Show them the FLOP
		;_sendtoall("SEE FLOP", $FLOP)
		If $NumberOfPlayerPlaying = 1 Then
			If $bDebugGame Then Out("Player " & $PlayerWinner & " Won ")
			_sendtoall("GameInfo", "Player " & $PlayerWinner & " Won ")
			$GAME_STATUS = 1
			ExitLoop
		EndIf
		; Let's see the RIVER
		$NumberOfCardsGiven += 1
		$FLOP &= ";" & $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1]
		
		_sendtoall("SEERIVER", $CurrentCardArray[$NumberOfCardsGiven][0] & ":" & $CurrentCardArray[$NumberOfCardsGiven][1])
		$ii = $CurrentPlayerPlaying
		While 1
			If $bDebugGlobal Then Out("Debug --- Player[" & $ii & "][5] = " & $PlayersArray[$ii][5])
			Local $SplitCards = StringSplit($PlayersArray[$ii][5], ";")
			Local $ArrayCard1 = StringSplit($SplitCards[1], ",")
			Local $ArrayCard2 = StringSplit($SplitCards[2], ",")
			$PlayersArray[$ii][4] = _Calc_points($ArrayCard1, $ArrayCard2, $FLOP, 5)
			$ii = _getnextplayer($ii + 1)
			If $ii = $CurrentPlayerPlaying Then ExitLoop
		WEnd
		
		$ii = $CurrentPlayerPlaying
		Local $ExitLoopPlayer = $ii
		While 1
			While 1
				If $PlayersArray[$ii][3] = "Fold" Then
					If $bDebugGlobal Then Out("- Player " & $PlayersArray[$ii][1] & " has fold, searching next player")
				Else
					ExitLoop
				EndIf
				$ii = _getnextplayer($ii + 1)
				$CurrentPlayerPlaying = $ii
			WEnd
			_send_player($PlayersArray[$ii][0], "YourTurn,,,It's your turn to play")
			_sendtoall("Playing ", $ii, $ii)
			$PlayersHasPlayed = False
			$TIME_COUNT = 0
			While $TIME_COUNT < $TIMEOUT_PLAY
				If $PlayersHasPlayed Then ExitLoop
				$TIME_COUNT += 1
				Sleep(1000)
			WEnd
			If Not $PlayersHasPlayed Then
				_send_player($PlayersArray[$ii][0], "Timeout ,,," & $PlayersArray[$ii][1])
			EndIf
			$ii = _getnextplayer($ii + 1)
			If $ii = $ExitLoopPlayer Then ExitLoop
			$CurrentPlayerPlaying = $ii
			;Next
		WEnd
		
		; Chech if more than one user have checked / called / raised ....
		Local $HighestScore = 0, $PlayerWinner, $NumberOfPlayerPlaying = 0
		For $ii = 0 To UBound($PlayersArray) - 1
			If $PlayersArray[$ii][0] <> 0 Then
				If $bDebugGame Then Out("Player " & $PlayersArray[$ii][1] & " choose " & $PlayersArray[$ii][3] & " points : " & $PlayersArray[$ii][4])
				If $PlayersArray[$ii][3] = "Called" Or $PlayersArray[$ii][3] = "Raised" Or $PlayersArray[$ii][3] = "Checked" Then
					$NumberOfPlayerPlaying += 1
					If $PlayersArray[$ii][4] = $HighestScore Then
						$PlayerWinner &= ";" & $PlayerWinner
					ElseIf $PlayersArray[$ii][4] > $HighestScore Then
						$HighestScore = $PlayersArray[$ii][4]
						$PlayerWinner = $PlayersArray[$ii][1]
					EndIf
				EndIf
			EndIf
		Next
		
		
		If $GAME_STATUS = 0 Or $GAME_STATUS = 1 Then ExitLoop
		; Show them the FLOP
		_sendtoall("SEE FLOP", $FLOP)
		If $NumberOfPlayerPlaying = 1 Then
			If $bDebugGame Then Out("Player " & $PlayerWinner & " Won ")
			_sendtoall("GameInfo", "Player " & $PlayerWinner & " Won ")
			$GAME_STATUS = 1
			ExitLoop
		EndIf
		$GAME_STATUS = 1
		ExitLoop
	WEnd
	;
	;Let's see the flop
	; SHOWDOWN
	;_sendtoall("SEE FLOP", $FLOP)
	;Reinitiate State of all players
	
	; Now let's wait the choice of the players
	$ChoicesMade = 0
	
	;while $ChoicesMade < UBound($PlayersArray) - 1
	;	sleep(50)
	;WEnd
EndFunc   ;==>_startNewGame
Func _Player_Raised($iRaise)
	$CURRENT_BLIND = $iRaise
EndFunc   ;==>_Player_Raised
Func _sendtoall($MessageType, $MessageData, $ExcludedIndex = 100)
	If $ExcludedIndex = 100 Then
		For $iii = 0 To UBound($PlayersArray) - 1
			Sleep($WAIT_SCRIPT)
			If $PlayersArray[$iii][0] <> 0 Then _send_player($PlayersArray[$iii][0], $MessageType & ",,," & $MessageData)
		Next
	Else
		If $bDebugGlobal Then Out("Exclude index n°" & $ExcludedIndex)
		For $iii = 0 To UBound($PlayersArray) - 1
			Sleep($WAIT_SCRIPT)
			If $PlayersArray[$iii][0] <> 0 And $iii <> $ExcludedIndex Then _send_player($PlayersArray[$iii][0], $MessageType & ",,," & $MessageData)
		Next
	EndIf
EndFunc   ;==>_sendtoall
Func _give_cards()
	If $bDebugGame Then Out("Giving Cards")
	Local $IndexOfCard = 0
	;for $kk= 1 to 2
	Local $CardArray[2][2]
	For $ii = 0 To UBound($PlayersArray) - 1
		
		If $PlayersArray[$ii][0] <> 0 Then
			$PlayersArray[$ii][5] = $CurrentCardArray[$NumberOfCardsGiven][0] & "," & $CurrentCardArray[$NumberOfCardsGiven][1]
			If $bDebugGame Then Out("Giving Card 1 to " & $PlayersArray[$ii][1])
			_send_player($PlayersArray[$ii][0], "NewCard1,,," & $CurrentCardArray[$NumberOfCardsGiven][0] & "," & $CurrentCardArray[$NumberOfCardsGiven][1])
			$NumberOfCardsGiven += 1
		EndIf
	Next
	Sleep($WAIT_SCRIPT)
	For $ii = 0 To UBound($PlayersArray) - 1
		If $PlayersArray[$ii][0] <> 0 Then
			$PlayersArray[$ii][5] &= ";" & $CurrentCardArray[$NumberOfCardsGiven][0] & "," & $CurrentCardArray[$NumberOfCardsGiven][1]
			If $bDebugGame Then Out("Giving Card 2 to " & $PlayersArray[$ii][1])
			_send_player($PlayersArray[$ii][0], "NewCard2,,," & $CurrentCardArray[$NumberOfCardsGiven][0] & "," & $CurrentCardArray[$NumberOfCardsGiven][1])
			$NumberOfCardsGiven += 1
		EndIf
	Next
	
	;Next
EndFunc   ;==>_give_cards
Func _tcp_send_error($hSocketError)
	_ASockShutdown($hSocketError)
	For $iii = 0 To UBound($PlayersArray[$iii][0])
		If $PlayersArray[$iii][0] = $hSocketError Then
			If $bDebugConn Then Out("Error with player " & $PlayersArray[$iii][1] & @TAB & "Kicked him...")
			_Remove_Player_From_Array($iii)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>_tcp_send_error
Func _Remove_Player_From_Array($IndexToRemove)
	;Local $TempArrayPlayer = $PlayersArray
	
	;If UBound($PlayersArray) = 1 Then
	;	$PlayersArray[0][0] = 0
	;Else
	;	If $IndexToRemove < UBound($PlayersArray) - 1 Then
	;For $iii = $IndexToRemove To UBound($PlayersArray) - 1
	$PlayersArray[$IndexToRemove][0] = 0
	$PlayersArray[$IndexToRemove][1] = 0
	$PlayerCount -= 1
	;$PlayersArray[$iii + 1][2]
	;$PlayersArray[$iii + 1][3]
	;$PlayersArray[$iii + 1][1]
	;Next
	;	EndIf
	;	ReDim $PlayersArray[UBound($PlayersArray) - 1][5]
	;	$PlayersArray = $TempArrayPlayer
	;EndIf
	;$TempArrayPlayer = 0
	If $PlayerCount < $MINPLAYERS Then
		$GAME_STATUS = 0 ;Stop Game
	EndIf
EndFunc   ;==>_Remove_Player_From_Array