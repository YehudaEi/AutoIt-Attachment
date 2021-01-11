#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.0.1
 Author:         Donald Nelson  donnie@nelsagen.com

 Script Function:
	Main Othello Functions

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <guiconstants.au3>
#include <Othello_Validate.au3>
#include <Othello_Global.au3>
#include <Othello_TCPIP.au3>
#include <ie.au3>

;Helper Variables
Dim $_width = 600
Dim $_height = 400

;GUI Variables
Dim $Form1
Dim $Result

;Game Board Variables
Global $picBoard[8][8]
Global $pTurn = 1
Dim $bActive = False


#region Create the Gui Interface
$Form1 = GUICreate( "Othello - Nelsagen Games", $_width, $_height )

;Create the Menu
$mnuFile = GUICtrlCreateMenu( "&File" )
;$mnuFileNew = GUICtrlCreateMenuitem( "&New", $mnuFile )
$mnuFileExit = GUICtrlCreateMenuitem( "E&xit", $mnuFile )
;///////////////
$mnuAction = GUICtrlCreateMenu( "&Action" )
$mnuActionHost = GUICtrlCreateMenuitem( "H&ost", $mnuAction )
$mnuActionConnect = GUICtrlCreateMenuitem( "&Connect", $mnuAction )
;//////////////
$mnuHelp = GUICtrlCreateMenu( "&Help" )
$mnuHelpAbout = GUICtrlCreateMenuitem( "About", $mnuHelp )

;Loop through and create the Boards Graphics
For $x = 0 To 7
	For $y = 0 To 7
		$picBoard[$x][$y] = GUICtrlCreateLabel( "", ( $y * 32 ) + 20, ($x * 32 ) + 20, 32, 32, $SS_SUNKEN )
	Next
Next

;Network Connection Onjects
$btnHost = GUICtrlCreateButton( "Host", 470, 345, 50, 30 )
$btnConnect = GUICtrlCreateButton( "Connect", 530, 345, 50, 30 )

;Instant Messaging Objects
$txtType = GUICtrlCreateInput( "", 20, 350, 216, 25 )
GUICtrlSetFont( $txtType, "12" )
$btnSend = GUICtrlCreateButton( "Send", 236, 350, 40, 25, $BS_DEFPUSHBUTTON )
$lblRead = GUICtrlCreateEdit( "Welcome to Othello ...", 310, 20, 270, 300, $ES_MULTILINE+$ES_READONLY+$WS_VSCROLL )

$chkBox = GUICtrlCreateCheckbox( "Show me the Way", 310, 350, 125, 25 )

;Count
$lblWhiteName = GUICtrlCreateLabel( "White", 20, 286, 50, 20, $SS_CENTER )
GUICtrlSetFont( $lblWhiteName, "12", "600" )
$lblWhiteCount = GUICtrlCreateEdit( "0", 20, 306, 50, 30, $ES_READONLY+$SS_CENTER )
GUICtrlSetFont( $lblWhiteCount, "12", "600" )
$lblBlackName = GUICtrlCreateLabel( "Black", 226, 286, 50, 20, $SS_CENTER )
GUICtrlSetFont( $lblBlackName, "12", "600" )
$lblBlackCount = GUICtrlCreateEdit( "0", 226, 306, 50, 30, $ES_READONLY+$SS_CENTER )
GUICtrlSetFont( $lblBlackCount, "12", "600" )
$lblTurn = GUICtrlCreateLabel( "Turn", 125, 286 ,50, 20, $SS_CENTER )
GUICtrlSetFont( $lblTurn, "12", "600" )
$lblTurnColor = GUICtrlCreateLabel( "", 136, 306, 32, 32, $SS_SUNKEN )

GUICtrlSetState( $txtType, $GUI_FOCUS )
GUISetState()
#endregion


_ClearBoard()

;Main Loop
While 1

;Setup Loop
While $bActive = False
	$msg = GUIGetMsg()
	Select
		Case $msg = $btnHost
			;MsgBox(0,"Begin Hosting a Game","Host")
			$Result = 1
			_Host()
		Case $msg = $mnuActionHost
			;MsgBox(0,"Begin Hosting a Game","Host")
			$Result = 1
			_Host()
		Case $msg = $btnConnect
			;MsgBox(0,"Connect to a Game - Nelsagen","Connect")
			$Result = 2
			_Connect()
		Case $msg = $mnuActionConnect
			;MsgBox(0,"Connect to a Game - Nelsagen","Connect")
			$Result = 2
			_Connect()
		Case $msg = $GUI_EVENT_CLOSE
			$result = -1
			ExitLoop
		Case $msg = $mnuFileExit
			$result = -1
			ExitLoop			
		Case $msg = $mnuHelpAbout
			_About()
	EndSelect
	
WEnd

If $bActive = True Then
;Main Game Loop
While $bActive = True
	;MsgBox( 0,"",$Me & " " & $pTurn )
	_WhereCanIMove()
	$msg = GUIGetMsg()
	If $bActive = True And $pTurn = $Me Then
		For $x = 0 To 7
			For $y = 0 To 7
				If $msg = $picBoard[$x][$y] Then
					;MsgBox( 0,"",$Me & " " & $pTurn )
					$Result = _ValidateChoice( $x, $y, $Me )
					If $Result = -1 Then
						MsgBox( 64, "oops!", "That square has already been choosen. Please choose another.", 1 )
					ElseIf $Result = -2 Then
						MsgBox( 64, "oops!", "This is not a valid move.", 1 )
					ElseIf $result = -3 Then
						MsgBox( 64, "oops!", "This is not a valid move. Choose again.", 1 )
					ElseIf $Result = 1 Then
						$pTurn = _OtherPlayer( $Me )
						_UpdateCount()
					EndIf
				EndIf
			Next
		Next
	EndIf

	If $gConnectedSocket <> -1 Then
		$tcpResult = _RecieveData()
		If $tcpResult = -99 Then
			;There is no Socket Connection
			$gConnectedSocket = -1
			MsgBox( 0, "Connection Lost", "We have lost our connection ... we must start again.", 5 )
			_ClearBoard()
			$bActive = False
			$bGameOver = False
			TCPShutdown()
		EndIf
	EndIf
	$tcpResult = 0
	
	Select
		Case $msg = $GUI_EVENT_CLOSE
			TCPSend( $gConnectedSocket, $Me & $enumQuit & "I Quit" )
			TCPShutdown()
			$result = -1
			ExitLoop
		Case $msg = $mnuActionConnect
			MsgBox( 0, "Unable to process request.", "You already have an active game.", 2 )
		Case $msg = $mnuActionHost
			MsgBox( 0, "Unable to process request.", "You already have an active game.", 2 )
		Case $msg = $mnuFileExit
			TCPSend( $gConnectedSocket, $Me & $enumQuit & "I Quit" )
			TCPShutdown()
			$result = -1
			ExitLoop
		Case $msg = $btnSend
			_SendMessage( GUICtrlRead( $txtType ) )
			_UpdateTxtRead( GUICtrlRead( $txtType ), $Me )
			GUICtrlSetData( $txtType, "" )
	EndSelect
	
	
WEnd
	If $bGameOver = True Then
		If GUICtrlRead( $lblWhiteCount ) > GUICtrlRead( $lblBlackCount ) Then
			MsgBox( 64, "Game Over", "White Won" & @CRLF & @CRLF & GUICtrlRead( $lblWhiteCount ) & " TO " & GUICtrlRead( $lblBlackCount ) )
		ElseIf GUICtrlRead( $lblWhiteCount ) < GUICtrlRead( $lblBlackCount ) Then
			MsgBox( 64, "Game Over", "Black Won" & @CRLF & @CRLF & GUICtrlRead( $lblBlackCount ) & " TO " & GUICtrlRead( $lblWhiteCount ) )
		ElseIf GUICtrlRead( $lblWhiteCount ) = GUICtrlRead( $lblBlackCount ) Then
			MsgBox( 64, "Game Over", "It's a Tie" & @CRLF & @CRLF & GUICtrlRead( $lblBlackCount ) & " TO " & GUICtrlRead( $lblWhiteCount ) )
		EndIf
	EndIf
	TCPShutdown()
EndIf
	
	
	If $Result = -1 Then
		ExitLoop
	EndIf

WEnd

Func _UpdateTxtRead( $sValue, $iWho = 0 )
	;Get the comments from the Label
	Dim $sTemp = GUICtrlRead( $lblRead )
	
	;If the Label is filling up, trim it down
	If StringLen( $sTemp ) > 1024 Then
		$sTemp = StringLeft( $sTemp, 1024 )
	EndIf
	
	If $iWho = 0 Then
		$sTemp = "Server Says: " & $sValue & @CRLF & @CRLF & $sTemp
	ElseIf $iWho = 1 Then
		$sTemp = "White Says: " & $sValue & @CRLF & @CRLF & $sTemp
	ElseIf $iWho = 2 Then
		$sTemp = "Black Says: " & $sValue & @CRLF & @CRLF & $sTemp
	Else
		$sTemp = "Casper Says: " & $sValue & @CRLF & @CRLF & $sTemp
	EndIf
	
	;Put the Text Back in the Label
	GUICtrlSetData( $lblRead, $sTemp )
EndFunc

Func _SetColor( $x, $y, $turn )
	Select
		Case $turn = 0
			GUICtrlSetBkColor( $picBoard[$x][$y], 0xb0e0e6 ) ;Light Blue
			GUICtrlSetBkColor( $picBoard[$x][$y], 0x00688b ) ;Dark Blue
		Case $turn = 1
			GUICtrlSetBkColor( $picBoard[$x][$y], 0xffffff )
			$gBoard[$x][$y][0] = 1
		Case $turn = 2
			GUICtrlSetBkColor( $picBoard[$x][$y], 0x000000 )
			$gBoard[$x][$y][0] = 2
	EndSelect
EndFunc

Func _UpdateCount()
	Dim $_WhiteCount = 0
	Dim $_BlackCount = 0
	
	For $x = 0 To 7
		For $y = 0 To 7
			Select
				Case $gBoard[$x][$y][0] = 1
					$_WhiteCount += 1
				Case $gBoard[$x][$y][0] = 2
					$_BlackCount += 1
			EndSelect
		Next
	Next
	
	GUICtrlSetData( $lblBlackCount, $_BlackCount )
	GUICtrlSetData( $lblWhiteCount, $_WhiteCount )
	If $pTurn = 1 Then
		GUICtrlSetBkColor( $lblTurnColor, 0xffffff )
	ElseIf $pTurn = 2 Then
		GUICtrlSetBkColor( $lblTurnColor, 0x000000 )
	EndIf
	
EndFunc

Func _ClearBoard()
	For $x = 0 To 7
		For $y = 0 To 7
			$gBoard[$x][$y][0] = 0
			$gBoard[$x][$y][1] = 0
			$gBoard[$x][$y][2] = 0
			_SetColor( $x, $y, 0 )
		Next
	Next
	
EndFunc

Func _UpdateBoard()
	For $x = 0 To 7
		For $y = 0 To 7
			Select
				Case $gBoard[$x][$y][0] = 0
					GUICtrlSetBkColor( $picBoard[$x][$y], 0x00688b ) ;Dark Blue
				Case $gBoard[$x][$y][0] = 1
					GUICtrlSetBkColor( $picBoard[$x][$y], 0xffffff ) ;White
				Case $gBoard[$x][$y][0] = 2
					GUICtrlSetBkColor( $picBoard[$x][$y], 0x000000 ) ;Black
			EndSelect
			
		Next
	Next
	
EndFunc

Func _NewGame()
	_ClearBoard()
	$bActive = True
	$bGameOver = False
	$gBoard[3][3][0] = 1
	GUICtrlSetBkColor( $picBoard[3][3], 0xffffff )
	$gBoard[4][4][0] = 1
	GUICtrlSetBkColor( $picBoard[4][4], 0xffffff )
	$gBoard[3][4][0] = 2
	GUICtrlSetBkColor( $picBoard[3][4], 0x000000 )
	$gBoard[4][3][0] = 2
	GUICtrlSetBkColor( $picBoard[4][3], 0x000000 )
	_UpdateCount()
EndFunc

Func _WhereCanIMove()
	$Help = GUICtrlRead( $chkBox )
	
	If $Help = $GUI_CHECKED Then
		For $x = 0 To 7
			For $y = 0 To 7
				If $gBoard[$x][$y][$Me] = $Me Then
					GUICtrlSetBkColor( $picBoard[$x][$y], 0xb0e0e6 ) ;Light Blue
				ElseIf	$gBoard[$x][$y][$Me] = 0 And $gBoard[$x][$y][0] = 0 Then
					GUICtrlSetBkColor( $picBoard[$x][$y], 0x00688b ) ;Dark Blue
				EndIf
			Next
		Next
	Else
		For $x = 0 To 7
			For $y = 0 To 7
				If $gBoard[$x][$y][0] = 0 Then
					GUICtrlSetBkColor( $picBoard[$x][$y], 0xb0e0e6 ) ;Light Blue
				EndIf
			Next
		Next
	EndIf
EndFunc

Func _About()
	Local $sTemp = '<html><body><table align="center"><tr><td align="center">This adaption of Othello was created by<br>Donald Nelson<br><br>Powered by</td></tr>'
	$sTemp = $sTemp & '<tr><td align="center"><a href="http://www.autoitscript.com" target="_blank"><img src="http://www.autoitscript.com/images/autoit_6_240x100.jpg" name="AutoItImage" alt="AutoIt Homepage Image"></a></td></tr>'
	$sTemp = $sTemp & '<tr><td align="center"><br><br>Version 1.0<br>Aug 26, 2006</td></tr></table></body></html>'
	$frmTemp = GUICreate( "About", 310, 310, $DS_SETFOREGROUND, $WS_EX_TOPMOST )
	GUISetBkColor( 0xb3b3b3 ,$frmTemp )
	$oIE = _IECreateEmbedded()
	$guiActivex = GUICtrlCreateObj( $oIE, 5, 5, 300, 300 )
	_IENavigate( $oIE, "about:blank" )
	
	Sleep( 10 )
	If IsObj($oIE) Then
		$result = _IEDocWriteHTML( $oIE, $sTemp )
		$oIE.document.execCommand ("Refresh")
	EndIf
	GUISetState()
	
	While 1
		Sleep( 10 )
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then
			GUIDelete( $frmTemp )
			ExitLoop
		EndIf
	WEnd
	
EndFunc