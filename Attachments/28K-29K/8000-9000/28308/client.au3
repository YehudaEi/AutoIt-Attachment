#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#AutoIt3Wrapper_Change2CUI=y
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include<Winapi.au3>
#include <ASock.au3>
#include<GuiEdit.au3>
#include<GuiListview.au3>
#include <FontConstants.au3>
;#include<GdiPLus.au3>
;;;
Global $MY_POSITION
Global $MY_USERNAME
Global $CURRENT_MONEY = 0
Global $CURRENT_BLIND = 0
Global $MIN_BLIND = 0
; Global $MAX_BLIND = 0 not used because no limit game.
Global $bBigBLind = False
Global $bSmallBlind = False
Global $bDealer = False
Global $ghA3LGDIPDll
;_GDIPlus_Startup()
Const $B_BEPOLITE = False
;Const $N_SOCKETS     = 1
Const $N_MAXRECV = 512
Const $N_WAITCLOSE = 2000
Const $N_WAITWORK = 750
;;;
Global $Game_Status = 0 ; Disconnected
Global $HostSocket, $DebugIt = False
Dim $hNotifyGUI
Dim $g_bExecExit = True
Opt("OnExitFunc", "ExitProgram")
Opt("GuiOnEventMode", 1) ; Full On Event client.
Dim $PlayersArray[10][6]
;    [0] =  Username
;    [1] =  Money
;    [2] =  Choice
;    [3] =  Ctrl Username
;    [4] =  Ctrl Money
;    [5] =  Ctrl Blind
#Region - Gui Controls -
$Form1 = GUICreate("AutoIt Poker", 802, 502, 188, 114)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")
$PlayersArray[0][3] = GUICtrlCreateLabel("- Player 1", 128, 288, 81, 17, BitOR($SS_CENTER, $SS_SUNKEN)) ; Player  1
$PlayersArray[1][3] = GUICtrlCreateLabel("- Player 2", 24, 216, 73, 17, $SS_RIGHT) ; Player 2
$PlayersArray[2][3] = GUICtrlCreateLabel("- Player 3", 24, 128, 89, 17, $SS_RIGHT)
$PlayersArray[3][3] = GUICtrlCreateLabel("- Player 4", 136, 64, 81, 17, $SS_RIGHT)
$PlayersArray[4][3] = GUICtrlCreateLabel("- Player 5", 272, 32, 81, 17, $SS_CENTER)
$PlayersArray[5][3] = GUICtrlCreateLabel("- Player 6", 416, 32, 81, 17, $SS_CENTER)
$PlayersArray[6][3] = GUICtrlCreateLabel("- Player 7", 560, 64, 81, 17)
$PlayersArray[7][3] = GUICtrlCreateLabel("- Player 8", 664, 128, 81, 17)
$PlayersArray[8][3] = GUICtrlCreateLabel("- Player 9", 664, 216, 81, 17)
$PlayersArray[9][3] = GUICtrlCreateLabel("- Player 10", 552, 288, 81, 17, $SS_CENTER)
$Group1 = GUICtrlCreateGroup("Your cards", 464, 368, 329, 129)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Action", 8, 368, 321, 129)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;$Graphic11 = GUICtrlCreateGraphic(312, 272, 41, 65, BitOR($SS_NOTIFY,$SS_SUNKEN))
;$Graphic12 = GUICtrlCreateGraphic(360, 272, 41, 65, BitOR($SS_NOTIFY,$SS_SUNKEN))
;$Graphic13 = GUICtrlCreateGraphic(408, 272, 41, 65, BitOR($SS_NOTIFY,$SS_SUNKEN))
;$Graphic14 = GUICtrlCreateGraphic(456, 272, 41, 65, BitOR($SS_NOTIFY,$SS_SUNKEN))
;$Graphic15 = GUICtrlCreateGraphic(264, 272, 41, 65, BitOR($SS_NOTIFY,$SS_SUNKEN))
$PlayersArray[0][5] = GUICtrlCreateLabel("1", 168, 256, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[1][5] = GUICtrlCreateLabel("2", 128, 200, 89, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[2][5] = GUICtrlCreateLabel("3", 144, 144, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[3][5] = GUICtrlCreateLabel("4", 176, 96, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[4][5] = GUICtrlCreateLabel("5", 280, 72, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[5][5] = GUICtrlCreateLabel("6", 420, 72, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[6][5] = GUICtrlCreateLabel("7", 512, 96, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[7][5] = GUICtrlCreateLabel("8", 544, 144, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[8][5] = GUICtrlCreateLabel("9", 552, 200, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
$PlayersArray[9][5] = GUICtrlCreateLabel("10", 512, 256, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFF00)
; Blinds
$PlayersArray[0][4] = GUICtrlCreateLabel("100 $", 128, 312, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[1][4] = GUICtrlCreateLabel("100 $", 16, 192, 81, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[2][4] = GUICtrlCreateLabel("100 $", 16, 112, 81, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[3][4] = GUICtrlCreateLabel("100 $", 136, 40, 81, 17, $SS_RIGHT)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[4][4] = GUICtrlCreateLabel("100 $", 416, 16, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[5][4] = GUICtrlCreateLabel("100 $", 272, 16, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[6][4] = GUICtrlCreateLabel("100 $", 560, 40, 81, 17)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[7][4] = GUICtrlCreateLabel("100 $", 656, 104, 81, 17)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[8][4] = GUICtrlCreateLabel("100 $", 664, 192, 81, 17)
GUICtrlSetColor(-1, 0x0000FF)
$PlayersArray[9][4] = GUICtrlCreateLabel("100 $", 552, 304, 81, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0x0000FF)
$MainPot = GUICtrlCreateLabel("2500 $", 280, 168, 176, 44, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetFont(-1, 20, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$PlayCard1 = GUICtrlCreateGraphic(500, 400, 57, 89, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState(-1, $Gui_hide)
$PlayCard1Number = GUICtrlCreateLabel("", 501, 400, 55, 25, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetState(-1, $Gui_hide)
$PlayCard1Type = GUICtrlCreateLabel("", 501, 450, 55, 30, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0, "Monotype Sorts")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetState(-1, $Gui_hide)
$UserName = GUICtrlCreateInput("UserName", 220, 150, 200, 20, $SS_SUNKEN)
$Server = GUICtrlCreateInput(@IPAddress1, 220, 170, 200, 20, $SS_SUNKEN)
$Port = GUICtrlCreateInput("8455", 220, 190, 200, 20, $SS_SUNKEN)
$MessageToEnter = GUICtrlCreateInput("Message at connect", 220, 210, 200, 20, $SS_SUNKEN)
GUICtrlCreateGraphic(320, 60, 50, 38)
GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 0, 0, 75, 75)
$PlayerInfo = GUICtrlCreateLabel("", 331, 80, 53, 38, $SS_CENTER)
GUICtrlSetFont(-1, 12, 800, 0, "Lucida Console")
$Connect = GUICtrlCreateButton("Connect", 430, 150, 60, 80)
GUICtrlSetOnEvent(-1, "_connect")
;$Icon2 = GUICtrlCreateLabel("test2", 0, 344, 104, 73, $SS_SUNKEN)
$PlayCard2 = GUICtrlCreateGraphic(600, 400, 57, 89, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetState(-1, $Gui_hide)
$PlayCard2Number = GUICtrlCreateLabel("", 601, 405, 55, 25, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetState(-1, $Gui_hide)
$PlayCard2Type = GUICtrlCreateLabel("", 601, 450, 55, 30, $SS_CENTER)
GUICtrlSetFont(-1, 25, 800, 0, "Monotype Sorts")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetState(-1, $Gui_hide)
$FlopCard1 = GUICtrlCreateGraphic(264, 272, 41, 65, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard1Number = GUICtrlCreateLabel("P", 265, 273, 39, 25, $SS_CENTER)
GUICtrlSetFont(-1, 16, 800, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard1Type = GUICtrlCreateLabel(Chr(171), 265, 310, 39, 20, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0, "Monotype Sorts")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard2 = GUICtrlCreateGraphic(312, 272, 41, 65, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard2Number = GUICtrlCreateLabel("O", 313, 273, 39, 25, $SS_CENTER)
GUICtrlSetFont(-1, 16, 800, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
$FlopCard2Type = GUICtrlCreateLabel(Chr(169), 313, 310, 39, 20, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0, "Monotype Sorts")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
$FlopCard3 = GUICtrlCreateGraphic(360, 272, 41, 65, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard3Number = GUICtrlCreateLabel("K", 361, 273, 39, 25, $SS_CENTER)
GUICtrlSetFont(-1, 16, 800, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetColor(-1,0xFF0000)
$FlopCard3Type = GUICtrlCreateLabel(Chr(168), 361, 310, 39, 20, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0, "Monotype Sorts")
GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetColor(-1,0xFF0000)
$FlopCard4 = GUICtrlCreateGraphic(408, 272, 41, 65, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard4Number = GUICtrlCreateLabel("E", 409, 273, 39, 25, $SS_CENTER)
GUICtrlSetFont(-1, 16, 800, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
$FlopCard4Type = GUICtrlCreateLabel(Chr(170), 409, 310, 39, 20, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0, "Monotype Sorts")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetColor(-1, 0xFF0000)
;GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard5 = GUICtrlCreateGraphic(456, 272, 41, 65, $SS_SUNKEN)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$FlopCard5Number = GUICtrlCreateLabel("R", 457, 273, 39, 25, $SS_CENTER)
GUICtrlSetFont(-1, 16, 800, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetColor(-1,0xFF0000)
$FlopCard5Type = GUICtrlCreateLabel(Chr(169), 457, 310, 39, 20, $SS_CENTER)
GUICtrlSetFont(-1, 20, 800, 0, "Monotype Sorts")
GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetColor(-1,0xFF0000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Check", 20, 400, 80, 41, 0)
GUICtrlSetOnEvent(-1, "Choice1")
GUICtrlSetState(-1, $gui_disable)
$Button2 = GUICtrlCreateButton("Call", 120, 400, 80, 41, 0)
GUICtrlSetOnEvent(-1, "Choice2")
GUICtrlSetState(-1, $gui_disable)
$Button3 = GUICtrlCreateButton("Pay", 220, 400, 80, 41, 0)
GUICtrlSetOnEvent(-1, "Choice3")
GUICtrlSetState(-1, $gui_disable)
$RaiseRangeMin = GUICtrlCreateLabel("_       <", 220, 454, 35, 20, 0)
$RaiseNumber = GUICtrlCreateInput("", 260, 452, 42, 20, 0)
;$Group2 = GUICtrlCreateGroup("Stats", 440, 8, 355, 321)
;$PlayersList = GUICtrlCreateListView("  |          Players                   | Money       ", 445, 25, 345, 150, _
;BitOR($LVS_REPORT, $LVS_SINGLESEL),$LVS_EX_FULLROWSELECT )
;$hListView = GUICtrlGetHandle($PlayersList)
;$CurrentGame = GUICtrlCreateListView("Players", 445, 175, 345, 150,$LVS_ICON)
;$hListviewGame = GUICtrlGetHandle($CurrentGame)
;Players
;GUICtrlCreateGroup("", -99, -99, 1, 1)
;GUISetState(@SW_SHOW)
;$Chat = GUICtrlCreateEdit("Chat Window" & @CRLF, 5, 340, 620, 180)
;$Chat = GUICtrlGetHandle($Chat)
;$UserSendChat = GUICtrlCreateInput("", 5, 530, 620, 30)
#EndRegion ### END Koda GUI section ###
;GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
Global $OK_SENDFLAG = False
If Not TCPStartup() Then Error("WSAStartup() failed.", False)
While 1
	;switch GUIGetMsg()
	
	;EndSwitch
	Sleep(50)
	;if $OK_SENDFLAG then
	;	ConsoleWrite($HostSocket)
	;if $HostSocket <> "" then
	;	_send_server("OK" & @SEC)
	;	$OK_SENDFLAG =  False
	;	;tcpsend($HostSocket,"Have begun to listen on port  INADDR_ANY. Waiting...")
	;EndIf
WEnd
Func _connect()
	Dim $iPort
	Dim $i
	While 1
		$HostSocket = _ASocket()
		If @error Then Error("Socket creation failed.")
		_ASockSelect($HostSocket, $Form1, $WM_USER + $i, BitOR($FD_READ, $FD_WRITE, $FD_CONNECT, $FD_CLOSE))
		GUIRegisterMsg($WM_USER + $i, "OnSocketEvent")
		_ASockConnect($HostSocket, GUICtrlRead($Server), GUICtrlRead($Port))
		If @extended Then Out("(This is interesting) connected immediately on socket #" & $i + 1)
		
		Out("Connecting NOW... " & @TAB & GUICtrlRead($Server))
		
		If @error <> 0 Then
			_Debug_("Error while connecting, error n°" & @error)
			ExitLoop
		EndIf
		for $ii = 0 to 9
		GUICtrlSetData($PlayersArray[$ii][3],"")
		GUICtrlSetData($PlayersArray[$ii][4],"")
		Next
		
		ExitLoop
	WEnd
EndFunc   ;==>_connect
Func _Debug_($InfoDebug)
	ConsoleWrite($InfoDebug & @CRLF)
EndFunc   ;==>_Debug_
Func OnSocketEvent($hWnd, $iMsgID, $WParam, $LParam)
	;:Local $HostSocket = $WParam
	Local $hSocket = $WParam
	Local $nSocket = $iMsgID - $WM_USER
	Local $iError = _WinAPI_HiWord($LParam)
	Local $iEvent = _WinAPI_LoWord($LParam)
	
	Local $sDataBuff
	Local $iSent
	
	If $iMsgID >= $WM_USER And $iMsgID < $WM_USER + 1 Then
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
						Out("</Data from socket #" & $nSocket + 1 & ">")
						Switch StringLeft($sDataBuff, 8)
							Case "UserInfo"
								$InfoServ = _send_server("UserInfo,,," & GUICtrlRead($UserName) & ",,," & GUICtrlRead($MessageToEnter))
								If @error <> 0 Or $InfoServ = 0 Then
									_Debug_("Error while sending player infos, error n°" & @error)
									;ExitLoop
								Else
									_Debug_("Message from server => " & $InfoServ)
									_Client_Connected()
								EndIf
							Case "BigBlind", "SmallBld", "Dealer  "
								_Player_Info(StringLeft($sDataBuff, 8))
							Case "YourTurn"
								_Player_Plays(StringTrimLeft($sDataBuff, 11))
								
							Case "Playing "
								_Player_Playing(StringTrimLeft($sDataBuff, 11))
								
							Case "SEE FLOP"
								_Player_Get_Flop(StringTrimLeft($sDataBuff, 11))
								
							Case "SEE TURN"
								_Player_Get_Turn(StringTrimLeft($sDataBuff, 11))
								
							Case "SEERIVER"
								_Player_Get_River(StringTrimLeft($sDataBuff, 11))
								
							Case "New Game"
								_new_game()
								
							Case "NewCard1"
								_NewCard1(StringTrimLeft($sDataBuff, 11))
								
							Case "NewCard2"
								_NewCard2(StringTrimLeft($sDataBuff, 11))
								
							Case "NewPlaye"
								_New_Player(StringTrimLeft($sDataBuff, 11))
								
							Case "DiscPlay"
								_Disconnect_Player(StringTrimLeft($sDataBuff, 11))
								
							Case "PlayList"
								_List_Players(StringTrimLeft($sDataBuff, 11))
								
							Case "KickedMe"
								_Client_Connected(False)
								_Kicked(StringTrimLeft($sDataBuff, 11))
							Case "GetBlind"
								_getBlind(StringTrimLeft($sDataBuff, 11))
								
							Case "GetMoney"
								_GetMoney(StringTrimLeft($sDataBuff, 11))
								
							Case "Position"
								_Me_Set_Position(StringTrimLeft($sDataBuff, 11))
								
							Case "GameInfo"
								_Game_Info(StringTrimLeft($sDataBuff, 11))
								
							Case Else
								; Clear the buffer to avoid issues
								$sDataBuff = TCPRecv($hSocket, $N_MAXRECV)
								$sDataBuff = ""
						EndSwitch
						;_send_server("OK")
						;TCPSend($hSocket,"Warning! FD_READ, but no data on socket " )
						;sleep(500)
						;$OK_SENDFLAG = True
						;sleep(1000)
						
						;TrayTip("Data from socket #" & $nSocket + 1, $sDataBuff, 2)
					Else; This DEFINITELY shouldn't have happened
						Out("Warning! FD_READ, but no data on socket #" & $nSocket + 1 & "!")
					EndIf
				EndIf
			Case $FD_WRITE
				;_send_server("OK")
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
				TCPCloseSocket($hSocket)
				$HostSocket = -1
				_Client_Connected(False)
			Case $FD_CONNECT
				If $iError <> 0 Then
					BreakConn($nSocket, "Error connecting on socket #" & $nSocket + 1 & "... :(")
				Else; Yay, connected!
					Out("+> Connected on socket " & " (socket " & $hSocket & ")")
					;TrayTip("Connected on socket ", "  Socket #" & "; handle = " & $HostSocket, 30)
				EndIf
		EndSwitch
	EndIf
EndFunc   ;==>OnSocketEvent
Func _Me_Set_Position($iPosition)
	$MY_POSITION = $iPosition
	$PlayersArray[$MY_POSITION][0] = $MY_USERNAME
	$PlayersArray[$MY_POSITION][1] = $CURRENT_MONEY
	$PlayersArray[$MY_POSITION][2] = 0
	GUICtrlSetData($PlayersArray[$MY_POSITION][3], $MY_USERNAME)
	GUICtrlSetData($PlayersArray[$MY_POSITION][4], $CURRENT_MONEY)
	GUICtrlSetData($PlayersArray[$MY_POSITION][5], 0)
	;sleep(500)
EndFunc   ;==>_Me_Set_Position
Func _reset_all()
	
EndFunc   ;==>_reset_all
Func _Player_Info($sData)
	Switch $sData
		Case "BigBlind"
			GUICtrlSetData($PlayerInfo, "Big Blind")
		Case "SmallBld"
			GUICtrlSetData($PlayerInfo, "Small Blind")
		Case "Dealer  "
			GUICtrlSetData($PlayerInfo, "   Dealer ")
	EndSwitch
EndFunc   ;==>_Player_Info
Func _Game_Info($sData)
	;_GUICtrlEdit_AppendText($Chat,$sData & @crlf)
EndFunc   ;==>_Game_Info
Func _getBlind($iBLind)
	GUICtrlSetData($RaiseRangeMin, $iBLind & " <")
	$CURRENT_BLIND = $iBLind
	$MIN_BLIND = $CURRENT_BLIND
	If $bSmallBlind Then
		$MIN_BLIND = $MIN_BLIND / 2
	ElseIf $bBigBLind Then
		$MIN_BLIND = $MIN_BLIND * 2
	EndIf
EndFunc   ;==>_getBlind
Func _GetMoney($iMoney)
	$CURRENT_MONEY = $iMoney
EndFunc   ;==>_GetMoney
Func _Player_Playing($iPosition)
	;ConsoleWrite("Set focus to >" & $sData & "<")
	;ConsoleWrite("Find text index "   & _GUICtrlListView_FindParam($hListView, $sData))
	;_GUICtrlListView_SetItemSelected($hListView,  _GUICtrlListView_FindParam($hListView, $sData))
	For $i = 0 To 9
		
		GUICtrlSetColor($PlayersArray[$i][3], 0)
	Next
	GUICtrlSetColor($PlayersArray[$iPosition][3], 0xFF0000)
	;local $IndexSearch= ControlListView($Form1, "", "SysListView321", "FindItem", $sData, 1)
	;_DebugPrint("Player to search => " & $sData & @crlf & " result " & $IndexSearch)
	;_GUICtrlListView_SetItemParam($hListView, $IndexSearch,2)
	;_GUICtrlListView_RedrawItems($hListView,$IndexSearch,$IndexSearch)
	GUICtrlSetState($Button1, $gui_disable)
	GUICtrlSetState($Button2, $gui_disable)
	GUICtrlSetState($Button3, $gui_disable)
EndFunc   ;==>_Player_Playing
Func _Player_Plays($iPosition)
	;for $i = 0 to _GUICtrlListView_GetItemCount($hListView) - 1
	;	_GUICtrlListView_SetItemParam($hListView, $i,"") ; Clear
	;Next
	For $i = 0 To 9
		
		GUICtrlSetColor($PlayersArray[$i][3], 0)
	Next
	GUICtrlSetColor($PlayersArray[$MY_POSITION][3], 0xFF0000)
	;local $IndexSearch= ControlListView($Form1, "", "SysListView321", "FindItem", $sData, 1)
	;_DebugPrint("Player to search => " & $sData & @crlf & " result " & $IndexSearch)
	;_GUICtrlListView_SetItemParam($hListView, $IndexSearch,2)
	;_GUICtrlListView_RedrawItems($hListView,$IndexSearch,$IndexSearch)
	GUICtrlSetState($Button1, $gui_enable)
	GUICtrlSetState($Button2, $gui_enable)
	GUICtrlSetState($Button3, $gui_enable)
	_WinAPI_FlashWindowEx($Form1)
EndFunc   ;==>_Player_Plays
Func _Kicked($sReason)
	Switch $sReason
		Case "SameUser"
			Local $sUsername = InputBox("Double Username", "There is already one player with this username." & @CRLF & "Please Select Another one.")
			If Not @error Then
				GUICtrlSetData($UserName, $sUsername)
				_connect()
			EndIf
			
		Case "IpDouble"
			;if $bIpDoubleTreat Then
			;Endif
		Case "ForceCon" ; Too many retrieves
			
			
	EndSwitch
EndFunc   ;==>_Kicked
Func _Disconnect_Player($iPosition)
	$PlayersArray[$iPosition][0] = 0
	$PlayersArray[$iPosition][1] = 0
	$PlayersArray[$iPosition][2] = 0
	GUICtrlSetData($PlayersArray[$iPosition][3], " _ O _ ")
	GUICtrlSetData($PlayersArray[$iPosition][4], 0)
	GUICtrlSetData($PlayersArray[$iPosition][5], 0)
	;_GUICtrlListView_DeleteItem($hListView, _GUICtrlListView_FindText($hListView, $sPlayer))
EndFunc   ;==>_Disconnect_Player
Func _List_Players($sPlayer)
	Local $PlayersList = StringSplit($sPlayer, ";;;", 1)
	Local $CurrentIndex
	Local $PlayerInfo
	
	For $ii = 1 To $PlayersList[0]
		;$PlayerInfo = stringsplit($PlayersList[$ii],"@@@",1)
		;ConsoleWrite("Adding Player >" & $PlayerInfo[1] & @tab & "in position " & $PlayerInfo[2] & "<" & @crlf)
		_New_Player($PlayersList[$ii])
		;ConsoleWrite("Player added " & @CRLF)
		;$CurrentIndex = _GUICtrlListView_AddItem($hListView, chr(11))
		;_GUICtrlListView_AddSubItem($hListView,$CurrentIndex,$PlayersList[$ii],1)
		;_GUICtrlListView_SetItemParam($hListView, $CurrentIndex, $PlayersList[$ii])
		;_GUICtrlListView_FindText(
	Next
EndFunc   ;==>_List_Players
Func _New_Player($sPlayerInfo)
	$sPlayerInfo = StringSplit($sPlayerInfo, "@@@", 1)
	ConsoleWrite("Adding Player >" & $sPlayerInfo[1] & @TAB & "in position " & $sPlayerInfo[2] & "<" & @CRLF)
	
	Local $PlayerName = $sPlayerInfo[1]
	Local $PlayerPosition = $sPlayerInfo[2]
	;local $CurrentIndex = _GUICtrlListView_AddItem($hListView,chr(11))
	;_GUICtrlListView_AddSubItem($hListView,$CurrentIndex,$sPlayer,1)
	$PlayersArray[$PlayerPosition][0] = $PlayerName
	$PlayersArray[$PlayerPosition][1] = 0
	$PlayersArray[$PlayerPosition][2] = 0
	GUICtrlSetData($PlayersArray[$PlayerPosition][3], $PlayerName)
	GUICtrlSetData($PlayersArray[$PlayerPosition][4], 0)
	GUICtrlSetData($PlayersArray[$PlayerPosition][5], 0)
EndFunc   ;==>_New_Player
Func _NewCard1($Cards)
	Local $NewCard = StringSplit($Cards, ",")
	GUICtrlSetData($PlayCard1Number, $NewCard[1])
	GUICtrlSetData($PlayCard1Type, Chr($NewCard[2] + 167))
	Switch $NewCard[2]
		Case 1, 4
			GUICtrlSetColor($PlayCard1Number, 0x0)
			GUICtrlSetColor($PlayCard1Type, 0x0)
		Case 2, 3
			GUICtrlSetColor($PlayCard1Number, 0xFF0000)
			GUICtrlSetColor($PlayCard1Type, 0xFF0000)
	EndSwitch
EndFunc   ;==>_NewCard1
Func _NewCard2($Cards)
	Local $NewCard = StringSplit($Cards, ",")
	GUICtrlSetData($PlayCard2Number, $NewCard[1])
	GUICtrlSetData($PlayCard2Type, Chr($NewCard[2] + 167))
	Switch $NewCard[2]
		Case 1, 4
			GUICtrlSetColor($PlayCard2Number, 0x0)
			GUICtrlSetColor($PlayCard2Type, 0x0)
		Case 2, 3
			GUICtrlSetColor($PlayCard2Number, 0xFF0000)
			GUICtrlSetColor($PlayCard2Type, 0xFF0000)
	EndSwitch
EndFunc   ;==>_NewCard2
Func _new_game()
	;_GUICtrlEdit_AppendText($Chat, ">>  New Game started  <<" & @CRLF)
	;_GUICtrlListView_CopyItems($hListview,$hListviewGame)
	;_GUICtrlListView_DeleteAllItems($hListviewGame)
	;for $ii = 1 to _GUICtrlListView_GetItemCount($hListView) - 1
	;	_guictrllistview_additem($hListviewGame,_GUICtrlListView_GetItemText($hListView,$ii,1))
	;Next
	$Game_Status = 1
	;GUICtrlSetState($Button1, $gui_enable)
	;GUICtrlSetState($Button2, $gui_enable)
	;GUICtrlSetState($Button3, $gui_enable)
EndFunc   ;==>_new_game
Func _send_server($Message)
	ConsoleWrite("Send Server " & $Message & @CRLF)
	$SentBytes = TCPSend($HostSocket, $Message)
	If @error Or $SentBytes = 0 Then
		MsgBox(0, "Erreur while sending data", "Exiting...." & @CRLF & "Erreur n°" & @error)
		Exit
	EndIf
	Return True
EndFunc   ;==>_send_server
Func Choice1()
	Switch $Game_Status
		Case 1
			If $bBigBLind Then
				_send_server("UserChoi,,,Check")
				
			Else
				_send_server("UserChoi,,,Check")
			EndIf
		Case 2
			_send_server("UserChoi,,,Check")
		Case 3
			_send_server("UserChoi,,,Check")
	EndSwitch
	GUICtrlSetState($Button1, $gui_disable)
	GUICtrlSetState($Button2, $gui_disable)
	GUICtrlSetState($Button3, $gui_disable)
EndFunc   ;==>Choice1
Func Choice2()
	Switch $Game_Status
		Case 1
			_send_server("UserChoi,,,Fold")
		Case 2
			_send_server("UserChoi,,,Check")
		Case 3
			_send_server("UserChoi,,,Check")
	EndSwitch
	GUICtrlSetState($Button1, $gui_disable)
	GUICtrlSetState($Button2, $gui_disable)
	GUICtrlSetState($Button3, $gui_disable)
EndFunc   ;==>Choice2
Func Choice3()
	Switch $Game_Status
		Case 1,2,3
			_send_server("UserChoi,,,Raise")
		;Case 2
		;	_send_server("UserChoi,,,raise")
		;Case 3
	;		_send_server("UserChoi,,,raise")
	EndSwitch
	GUICtrlSetState($Button1, $gui_disable)
	GUICtrlSetState($Button2, $gui_disable)
	GUICtrlSetState($Button3, $gui_disable)
EndFunc   ;==>Choice3
Func _Client_Connected($Connected = True)
	If $Connected Then
		$bClientConnected = True
		GUICtrlSetState($UserName, $Gui_hide)
		GUICtrlSetState($Server, $Gui_hide)
		GUICtrlSetState($Port, $Gui_hide)
		GUICtrlSetState($Connect, $Gui_hide)
		GUICtrlSetState($MessageToEnter, $Gui_hide)
		$MY_USERNAME = GUICtrlRead($UserName)
		;Local $iIndex = _GUICtrlListView_AddItem($hListView, Chr(228))
		;_GUICtrlListView_AddSubItem($hListView, $iIndex, GUICtrlRead($UserName), 1)
		;_GUICtrlListView_AddSubItem($hListView, $iIndex, "0 $", 2)
		;_GUICtrlListView_SetItemParam($hListView,0,1)
		;_GUICtrlListView_RedrawItems($hListView,0,0)
		;_GUICtrlListView_SetItemState($hListView, 0, bitor($LVIS_FOCUSED,$LVIS_SELECTED), bitor($LVIS_FOCUSED,$LVIS_SELECTED))
		
		;_GUICtrlListView_RedrawItems($hListView,0,0)
		GUICtrlSetState($PlayCard2, $gui_show)
		GUICtrlSetState($PlayCard2Number, $gui_show)
		GUICtrlSetState($PlayCard2Type, $gui_show)
		GUICtrlSetState($PlayCard1, $gui_show)
		GUICtrlSetState($PlayCard1Number, $gui_show)
		GUICtrlSetState($PlayCard1Type, $gui_show)
		$Game_Status = 1
	Else
		$bClientConnected = False
		GUICtrlSetState($UserName, $gui_show)
		GUICtrlSetState($Server, $gui_show)
		GUICtrlSetState($Port, $gui_show)
		GUICtrlSetState($Connect, $gui_show)
		GUICtrlSetState($MessageToEnter, $gui_show)
		;_GUICtrlListView_DeleteAllItems($hListView)
		GUICtrlSetState($PlayCard2, $Gui_hide)
		GUICtrlSetState($PlayCard2Number, $Gui_hide)
		GUICtrlSetState($PlayCard2Type, $Gui_hide)
		GUICtrlSetState($PlayCard1, $Gui_hide)
		GUICtrlSetState($PlayCard1Number, $Gui_hide)
		GUICtrlSetState($PlayCard1Type, $Gui_hide)
		$Game_Status = 1
	EndIf
EndFunc   ;==>_Client_Connected
Func _Player_Get_Turn($sCards)
	
	$CurrentCard = StringSplit($sCards, ":")
	Switch $CurrentCard[2]
		Case 1, 4
			GUICtrlSetColor($FlopCard4Number, 0x0)
			GUICtrlSetColor($FlopCard4Type, 0x0)
		Case 2, 3
			GUICtrlSetColor($FlopCard4Number, 0xFF0000)
			GUICtrlSetColor($FlopCard4Type, 0xFF0000)
	EndSwitch
	GUICtrlSetData($FlopCard4Number, $CurrentCard[1])
	GUICtrlSetData($FlopCard4Type, Chr($CurrentCard[2] + 167))
	GUICtrlSetState($FlopCard4, $gui_enable)
	GUICtrlSetState($FlopCard4Type, $gui_enable)
	GUICtrlSetState($FlopCard4Number, $gui_enable)
EndFunc   ;==>_Player_Get_Turn
Func _Player_Get_River($sCards)
	$CurrentCard = StringSplit($sCards, ":")
	Switch $CurrentCard[2]
		Case 1, 4
			GUICtrlSetColor($FlopCard5Number, 0x0)
			GUICtrlSetColor($FlopCard5Type, 0x0)
		Case 2, 3
			GUICtrlSetColor($FlopCard5Number, 0xFF0000)
			GUICtrlSetColor($FlopCard5Type, 0xFF0000)
	EndSwitch
	GUICtrlSetData($FlopCard5Number, $CurrentCard[1])
	GUICtrlSetData($FlopCard5Type, Chr($CurrentCard[2] + 167))
	GUICtrlSetState($FlopCard5, $gui_enable)
	GUICtrlSetState($FlopCard5Type, $gui_enable)
	GUICtrlSetState($FlopCard5Number, $gui_enable)
EndFunc   ;==>_Player_Get_River
Func _Player_Get_Flop($sCards)
	$sCards = StringSplit($sCards, ";")
	
	For $i = 1 To 3
		$CurrentCard = StringSplit($sCards[$i], ":")
		Switch $CurrentCard[2]
			Case 1, 4
				GUICtrlSetColor(Eval("FlopCard" & $i & "Number"), 0x0)
				GUICtrlSetColor(Eval("FlopCard" & $i & "Type"), 0x0)
			Case 2, 3
				GUICtrlSetColor(Eval("FlopCard" & $i & "Number"), 0xFF0000)
				GUICtrlSetColor(Eval("FlopCard" & $i & "Type"), 0xFF0000)
		EndSwitch
		GUICtrlSetData(Eval("FlopCard" & $i & "Number"), $CurrentCard[1])
		GUICtrlSetData(Eval("FlopCard" & $i & "Type"), Chr($CurrentCard[2] + 167))
	Next
	GUICtrlSetState($FlopCard4Number, $gui_disable)
	GUICtrlSetState($FlopCard5Number, $gui_disable)
	GUICtrlSetData($FlopCard4Number, "")
	GUICtrlSetData($FlopCard5Number, "")
	GUICtrlSetData($FlopCard4Type, Chr(53))
	GUICtrlSetData($FlopCard5Type, Chr(53))
	GUICtrlSetState($FlopCard4Type, $gui_disable)
	GUICtrlSetState($FlopCard5Type, $gui_disable)
	
	GUICtrlSetState($FlopCard4, $gui_disable)
	GUICtrlSetState($FlopCard5, $gui_disable)
	
	#cs
		; -----
		$CurrentCard = StringSplit($sCards[1],":")
		;GUICtrlSetState($FlopCard1,$gui_hide)
		;GUICtrlSetState($FlopCard2,$gui_hide)
		;GUICtrlSetState($FlopCard3,$gui_hide)
		switch $CurrentCard[2]
		case 1,4
		GUICtrlSetColor($FlopCard1Number,0xFFFFFF)
		GUICtrlSetColor($FlopCard1Type,0xFFFFFF)
		case 2,3
		GUICtrlSetColor($FlopCard1Number,0xFF0000)
		GUICtrlSetColor($FlopCard1Type,0xFF0000)
		EndSwitch
		GUICtrlSetData($FlopCard1Number,$CurrentCard[1] )
		GUICtrlSetData($FlopCard1Type,chr($CurrentCard[2] + 167))
		; -----
		$CurrentCard = StringSplit($sCards[2],":")
		switch $CurrentCard[2]
		case 1,4
		GUICtrlSetColor($FlopCard2Number,0xFFFFFF)
		GUICtrlSetColor($FlopCard2Type,0xFFFFFF)
		case 2,3
		GUICtrlSetColor($FlopCard2Number,0xFF0000)
		GUICtrlSetColor($FlopCard2Type,0xFF0000)
		EndSwitch
		GUICtrlSetData($FlopCard2Number,$CurrentCard[1] )
		GUICtrlSetData($FlopCard2Type,chr($CurrentCard[2] + 167))
		; -----
		$CurrentCard = StringSplit($sCards[3],":")
		switch $CurrentCard[2]
		case 1,4
		GUICtrlSetColor($FlopCard3Number,0xFFFFFF)
		GUICtrlSetColor($FlopCard3Type,0xFFFFFF)
		case 2,3
		GUICtrlSetColor($FlopCard3Number,0xFF0000)
		GUICtrlSetColor($FlopCard3Type,0xFF0000)
		EndSwitch
		GUICtrlSetData($FlopCard3Number,$CurrentCard[1] )
		GUICtrlSetData($FlopCard3Type,chr($CurrentCard[2] + 167))
	#ce
EndFunc   ;==>_Player_Get_Flop
Func BreakConn($nSocket, $sError)
	_ASockShutdown($HostSocket)
	Out("Connection has broken on socket #" & $nSocket + 1 & ".")
	Out("Cause: " & $sError)
	If $B_BEPOLITE Then
		Sleep($N_WAITCLOSE / 10)
	Else
		Sleep(1)
	EndIf
	TCPCloseSocket($HostSocket)
	$HostSocket = -1
EndFunc   ;==>BreakConn
Func FreeSock()
	
	If $HostSocket = -1 Then
		Return 1
	EndIf
	
	Return -1
EndFunc   ;==>FreeSock
Func Error($sText, $bCloseSockets = True, $iExitCode = 1)
	MsgBox(16, "Server Error", $sText)
	_Exit($bCloseSockets, $iExitCode)
EndFunc   ;==>Error
Func _Exit($bCloseSockets = True, $iExitCode = 0)
	If $bCloseSockets Then
		
		_ASockShutdown($HostSocket); Graceful shutdown.
		
		Sleep($N_WAITCLOSE)
		
		TCPCloseSocket($HostSocket)
		
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
		$aRet = "(Could not resolve)"
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc   ;==>SocketToIP
Func WM_NOTIFY($hWndGUI, $MsgID, $WParam, $LParam)
	#forceref $hWndGUI, $MsgID, $wParam
	#cs
		Local $tNMHDR, $code, $x, $y, $tNMLISTVIEW, $hwndFrom, $tDraw, $dwDrawStage, $dwItemSpec
		$tNMHDR = DllStructCreate($tagNMHDR, $LParam) ;NMHDR (hwndFrom, idFrom, code)
		If @error Then Return
		$code = DllStructGetData($tNMHDR, "Code")
		$hwndFrom = DllStructGetData($tNMHDR, "hWndFrom")
		Switch $hwndFrom
		
		Case $hListView
		Switch $code
		case $LVN_HOTTRACK
		; Do nothing..
		return False
		;case $LVN_ITEMCHANGING
		;	return False
		;case $LVN_ITEMCHANGED
		;		return False
		Case $NM_CUSTOMDRAW
		;  If $DebugIt Then _DebugPrint("$NM_CUSTOMDRAW")
		$tDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $LParam)
		$dwDrawStage = DllStructGetData($tDraw, "dwDrawStage")
		$dwItemSpec = DllStructGetData($tDraw, "dwItemSpec")
		Switch $dwDrawStage
		Case $CDDS_PREPAINT
		If $DebugIt Then _DebugPrint("$CDDS_PREPAINT")
		
		Return $CDRF_NOTIFYSUBITEMDRAW
		Case $CDDS_ITEMPREPAINT
		If $DebugIt Then _DebugPrint("$CDDS_ITEMPREPAINT")
		
		Return $CDRF_NOTIFYSUBITEMDRAW
		Case BitOR($CDDS_SUBITEM, $CDDS_ITEMPREPAINT)
		
		Local $iCol = DllStructGetData($tDraw, "iSubItem")
		
		Local $iRow = DllStructGetData($tDraw, "dwItemSpec")
		
		Local $sItem = _GUICtrlListView_GetItemText($hListView, $iRow, $iCol);
		;_DebugPrint($sItem)
		Local $tRectTemp = DllStructCreate($tagRECT)
		
		;if $iCol = 0 then
		;	_GUICtrlListView_GetItemRect2($hListView,$iRow,$tRectTemp,$LVIR_BOUNDS)
		;Else
		;	GetCellRect($hListView,$iRow,$iCol,$LVIR_BOUNDS,$tRectTemp)
		;Endif
		GetCellRect($hListView, $iRow, $iCol, $LVIR_BOUNDS, $tRectTemp);
		;_WinAPI_InvalidateRect($hListView,$tRectTemp,False)
		
		ConsoleWrite("+ _ _ _ _ _ _ _ _ _ _ _ _"  & @crlf)
		ConsoleWrite($iCol & @crlf)
		ConsoleWrite($iRow & @crlf)
		ConsoleWrite(DllStructGetData($tRectTemp,"Left") & @crlf)
		ConsoleWrite(DllStructGetData($tRectTemp,"Right") & @crlf)
		ConsoleWrite(DllStructGetData($tRectTemp,"Bottom") & @crlf)
		ConsoleWrite(DllStructGetData($tRectTemp,"Top") & @crlf)
		ConsoleWrite("+ _ _ _ _ _ _ _ _ _ _ _ _"  & @crlf)
		
		;ConsoleWrite(DllStructGetData($tRectTemp,"right") & @crlf)
		
		Local $CDC = DllStructGetData($tDraw, "hdc")
		
		Local $LOGPIXELSY = 90
		Local $lfHeight = _WinAPI_MulDiv(10, _WinAPI_GetDeviceCaps($CDC, $LOGPIXELSY), 72)
		;local $hFont = _WinAPI_CreateFont($lfHeight, 0, 0, 0, 0, False, 0, 0, $SYMBOL_CHARSET  , 0, 0, 0, 0, "Monotype Sorts");
		;_DebugPrint(BitAND($CDIS_FOCUS, DllStructGetData($tDraw, "uItemState")))
		If DllStructGetData($tDraw, "lItemlParam")  = 2 Then
		
		;$sItem
		If $iCol = 0 Then
		
		_GUICtrlListView_GetItemRect2($hListView, $iRow, $tRectTemp, $LVIR_BOUNDS) ; override...
		
		Local $hBrush = _GDIPlus_CreateLineBrush(0, 0, DllStructGetData($tRectTemp, 3), 14, 0, 0xFF00FF00, 1)
		;_DebugPrint("hBrush " & $hBrush)
		;_WinAPI_FillRect($CDC, DllStructGetPtr($tRectTemp), $hBrush)
		;_WinAPI_SelectObject($CDC, _WinAPI_CreateSolidBrush(0x0000FF))
		$hGraphic = _GDIPlus_GraphicsCreateFromHDC($CDC)
		;_DebugPrint("hGraphic " & $hBrush)
		_WinAPI_FillRect($CDC, DllStructGetPtr($tRectTemp), _WinAPI_CreateSolidBrush(0xFFFFFF))
		_GDIPlus_GraphicsFillRect($hGraphic, DllStructGetData($tRectTemp, 1), _
		DllStructGetData($tRectTemp, 2), _
		DllStructGetData($tRectTemp, 3), _
		14, _
		$hBrush)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_GraphicsClear($hGraphic)
		EndIf
		Local $aResult = DllCall("User32.dll", "int", "InflateRect", "ptr", DllStructGetPtr($tRectTemp), "int", -2, "int", 0)
		;If @error Or $aResult[0] = 0 Then _DebugPrint("Error")
		If $iCol = 0 Then
		Local $hFont = _WinAPI_CreateFont($lfHeight, 0, 0, 0, 0, False, 0, 0, $SYMBOL_CHARSET, 0, 0, 0, 0, "Monotype Sorts");
		_WinAPI_SelectObject($CDC, $hFont)
		$aResult = DllCall("User32.dll", "int", "DrawText", "hwnd", $CDC, "str", $sItem, "int", 1, "ptr", DllStructGetPtr($tRectTemp), "uint", $DT_LEFT)
		;If @error Or $aResult[0] = 0 Then _DebugPrint("Error")
		Else
		Local $hFont = _WinAPI_CreateFont($lfHeight, 0, 0, 0, 800, 0, 0, 0, 0, 0, 0, 0, 0, "Arial");
		_WinAPI_SelectObject($CDC, $hFont)
		$aResult = DllCall("User32.dll", "int", "DrawText", "hwnd", $CDC, "str", $sItem, "int", StringLen($sItem), "ptr", DllStructGetPtr($tRectTemp), "uint", $DT_LEFT)
		;If @error Or $aResult[0] = 0 Then _DebugPrint("Error")
		EndIf
		Else
		Local $hFont = _WinAPI_CreateFont($lfHeight, 0, 0, 0, 0, False, 0, 0, 0, 0, 0, 0, 0, "Arial");
		_WinAPI_FillRect($CDC, DllStructGetPtr($tRectTemp), _WinAPI_CreateSolidBrush(0xFFFFFF))
		;_WinAPI_SelectObject($CDC, _WinAPI_CreateSolidBrush(0x0000FF))
		If $iCol = 0 Then
		Local $hFont = _WinAPI_CreateFont($lfHeight, 0, 0, 0, 0, False, 0, 0, $SYMBOL_CHARSET, 0, 0, 0, 0, "Monotype Sorts");
		_WinAPI_SelectObject($CDC, $hFont)
		$aResult = DllCall("User32.dll", "int", "DrawText", "hwnd", $CDC, "str", $sItem, "int", 1, "ptr", DllStructGetPtr($tRectTemp), "uint", $DT_CENTER)
		;If @error Or $aResult[0] = 0 Then _DebugPrint("Error")
		Else
		Local $hFont = _WinAPI_CreateFont($lfHeight, 0, 0, 0, 800, 0, 0, 0, 0, 0, 0, 0, 0, "Arial");
		_WinAPI_SelectObject($CDC, $hFont)
		$aResult = DllCall("User32.dll", "int", "DrawText", "hwnd", $CDC, "str", $sItem, "int", StringLen($sItem), "ptr", DllStructGetPtr($tRectTemp), "uint", $DT_CENTER)
		;If @error Or $aResult[0] = 0 Then _DebugPrint("Error")
		EndIf
		EndIf
		
		
		
		_WinAPI_DeleteObject($hFont)
		
		Return $CDRF_SKIPDEFAULT
		Case $CDDS_ITEMPOSTPAINT
		
		;_DebugPrint("$CDDS_ITEMPOSTPAINT")
		Return $CDRF_DODEFAULT
		Case BitOR($CDDS_ITEMPOSTPAINT, $CDDS_SUBITEM)
		;_DebugPrint("$CDDS_SUBITEMPOSTPAINT")
		Return BitOR($CDRF_NOTIFYSUBITEMDRAW, $CDRF_NOTIFYPOSTPAINT)
		Case $CDDS_POSTPAINT
		;_DebugPrint("$CDDS_POSTPAINT")
		
		Return $CDRF_NOTIFYSUBITEMDRAW
		
		Case $CDDS_POSTERASE
		;_DebugPrint("$CDDS_POSTERASE")
		Return $CDRF_NOTIFYPOSTERASE
		;	case $CDDS_ITEMPOSTPAINT
		;		_DebugPrint("$CDDS_ITEMPOSTPAINT")
		;		return $CDRF_NOTIFYSUBITEMDRAW
		Case Else
		;_DebugPrint("0x" & Hex($dwDrawStage))
		Return $CDRF_DODEFAULT
		EndSwitch
		case Else
		_DebugPrint("Autre code " & $code)
		EndSwitch
		
		EndSwitch
	#ce
	Return $GUI_RUNDEFMSG
	
EndFunc   ;==>WM_NOTIFY
Func GetCellRect($hWnd, $iRow, $iCol, $nArea, ByRef $rect) ; we have to filter between Subitem and Item
	;_GUICtrlListView_GetSubItemRect2($hWnd, $iRow, $iCol, $nArea, $rect);
	;#cs
	If $iCol > 0 Then Return _GUICtrlListView_GetSubItemRect2($hWnd, $iRow, $iCol, $nArea, $rect);
	
	;If _GUICtrlListView_GetColumnCount($hWnd) = 1 Then Return _GUICtrlListView_GetItemRect2($hWnd, $iRow, $rect, $nArea);
	; We now that we have more than one column
	
	$iCol = 1;
	Local $rCol1 = DllStructCreate($tagRECT) ; We need it to get the first "SubItem" rect.
	If _GUICtrlListView_GetSubItemRect2($hWnd, $iRow, $iCol, $nArea, $rCol1) = False Then Return False;
	
	If _GUICtrlListView_GetItemRect2($hWnd, $iRow, $rect, $nArea) = False Then Return False;
	
	DllStructSetData($rect, "right", DllStructGetData($rCol1, "left"))
	If @error Then Return False
	Return True;
	;	#ce
EndFunc   ;==>GetCellRect
Func _GUICtrlListView_GetItemRect2($hWnd, $iIndex, ByRef $tRect, $iCode)
	DllStructSetData($tRect, "Left", $iCode)
	_SendMessage($hWnd, $LVM_GETITEMRECT, $iIndex, DllStructGetPtr($tRect), 0, "wparam", "ptr")
	Return @error = 0
EndFunc   ;==>_GUICtrlListView_GetItemRect2
Func _GUICtrlListView_GetSubItemRect2($hWnd, $iIndex, $iSubItem, $iCode, ByRef $tRect)
	
	DllStructSetData($tRect, "Top", $iSubItem)
	DllStructSetData($tRect, "Left", $iCode)
	_SendMessage($hWnd, $LVM_GETSUBITEMRECT, $iIndex, DllStructGetPtr($tRect), 0, "wparam", "ptr")
	Return @error = 0
EndFunc   ;==>_GUICtrlListView_GetSubItemRect2
Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "-->")
	ConsoleWrite("!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint
Func SpecialEvents()
	Switch @GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			Exit
		Case $GUI_EVENT_MINIMIZE
		Case $GUI_EVENT_RESTORE
	EndSwitch
EndFunc   ;==>SpecialEvents
#cs
	Func _GDIPlus_CreateLineBrush($point1, $point2, $point3, $point4, $hcolor1, $hcolor2, $wrapMode = 0)
	Local $aResult, $pPoints1, $ppoints2, $tPoints1, $tPoints2
	$tPoints1 = DllStructCreate("int[4]")
	$pPoints1 = DllStructGetPtr($tPoints1)
	For $ii = 1 To 2
	DllStructSetData($tPoints1, 1, $point1, (($ii - 1) * 2) + 1)
	DllStructSetData($tPoints1, 1, $point2, (($ii - 1) * 2) + 2)
	Next
	
	$tPoints2 = DllStructCreate("int[4]")
	$ppoints2 = DllStructGetPtr($tPoints2)
	For $ii = 1 To 2
	DllStructSetData($tPoints2, 1, $point3, (($ii - 1) * 2) + 1)
	DllStructSetData($tPoints2, 1, $point4, (($ii - 1) * 2) + 2)
	Next
	$aResult = DllCall($ghGDIPDll, "int", "GdipCreateLineBrushI", "ptr", $pPoints1, "ptr", $ppoints2, "int", $hcolor1, "int", $hcolor2, "int", $wrapMode, "int*", 0)
	Return SetError($aResult[0], 0, $aResult[6])
	EndFunc   ;==>_GDIPlus_CreateLineBrush
#ce