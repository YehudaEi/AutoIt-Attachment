;; Created by nitekram on 9-11-08
;;
;; Used to determine the best hands to start with in Texas Holdem
;;
;;
;
;Special thanks to spudw2k for creating his deck of cards functions
;;;    http://www.autoitscript.com/forum/index.php?showtopic=80388&hl=


;_CheckCards()
;Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#NoTrayIcon

AutoItSetOption("TrayMenuMode", 1)
AutoItSetOption("MustDeclareVars", 1)

Global $iCard[26]
Global $aPic[26]
Global $aPic2[26]
Global $aLable[26]
Global $StatsGroup, $StatsLable[11], $StatsLableCount[11]
Global $WinGroup, $WinLable[11], $WinLableCount[11]
Global $CtrlGroup

Global $deck
Global $CardColorRed = "b2fv.gif" ;RedCard
Global $CardColorBlue = "b1fv.gif" ;BlueCard

; OPTIONS
Global $TotalPlayers = 8
Global $DealDelay = 100 ; 100 is good to see the cards for about a second
Global $Deals, $DealsDelay = 500
Global $Sounds = 1, $SoundsFast = 0
Global $SoundsFileShuffle = "cards\shuffle.wav"
Global $SoundsFileDeal = "cards\CardsDealing.wav"
Global $CardColor = $CardColorBlue
Global $BackGround = 0x00AA00;0xFFFFFF = white 00AA00 = Green
;end OPTIONS



Global $OptionsItem, $AboutItem, $ExitItem, $msg2, $SoundItem, $FastSoundItem

;Global $CardBlank = "cards\blank1.gif" ;Blank_white_clear.jpg"
Global $CardBlank = "cards\blank.jpg" ;Blank_white_clear.jpg"


Global $CardPoints_1, $CardPoints_2, $Distance
Global $Ace = 16, $King = 14, $Queen = 13, $Jack = 12, $Ten = 11, $Nine = 9, $Eight = 8
Global $Seven = 7, $Six = 6, $five = 5, $Four = 4, $Three = 3, $Two = 2
Global $Paired = 10, $Suited = 0, $Suiteds = 4, $Connected = 3, $Gap1 = 2, $Gap2 = 1, $Middle = 3, $Late = 5

Global $aPlayersHand[$TotalPlayers][2], $aPlayersTotalHand[8], $aTableCards[5], $BestHand = 0, $ShowBestHand, $BestPlayersHand

Global $Flusher = 0, $RoyalFlush = 9, $StraightFlush = 8, $4Kind = 7, $FullHouse = 6
Global $Flush = 5, $Straight = 4, $3Kind = 3, $2Pair = 2, $Pair = 1, $HighCard = 0, $BlankCards = 2
Global $RoyalFlushCount = 0, $StraightFlushCount = 0, $4KindCount = 0, $FullHouseCount = 0
Global $FlushCount = 0, $StraightCount = 0, $3KindCount = 0, $2PairCount = 0, $PairCount = 0, $HighCardCount = 0
Global $RoyalFlushCountWIN = 0, $StraightFlushCountWIN = 0, $4KindCountWIN = 0, $FullHouseCountWIN = 0
Global $FlushCountWIN = 0, $StraightCountWIN = 0, $3KindCountWIN = 0, $2PairCountWIN = 0, $PairCountWIN = 0, $HighCardCountWIN = 0



Global $FirstDeal = 1, $FirstRun = 1, $FirstFlop = 1, $FirstTurn = 1, $FirstRiver = 1, $CardsOpened = 1, $DealerCountCards = 0

Global $iTopPic = 15, $iLeftPic
Global $msg
Global $TexasHoldem

;Buttons and inputs and checkboxes
Global $DealsInput, $DealButton, $FlopDeal, $TurnDeal, $RiverDeal, $ClearButton, $ClearCheckbox, $StatsButton, $StatsInput

Global $bShow = 1






Global $Percent = 0, $Run = 1, $RunRandom = 0 ; else run deck of cards with 0

If Not $Run Then
	Global $TESTING = 1, $TestingTableCards = 1, $TESTINGTEMP = 1
Else
	Global $TESTING = 0, $TestingTableCards = 0, $TESTINGTEMP = 0
EndIf

#cs
	; TEST ONE with straight flush
	Global $test1 = 116
	Global $test2 = 114
	Global $test3 = 115
	Global $test4 = 117
	Global $test5 = 112
	Global $test6 = 113
	Global $test7 = 419
#ce


#cs
	; TEST TWO with Royal Straight Flush
Global $test1 = 120
Global $test2 = 124
Global $test3 = 121
Global $test4 = 122
Global $test5 = 112
Global $test6 = 123
Global $test7 = 419
#ce


Global $test1 = 112
Global $test2 = 124
Global $test3 = 113
Global $test4 = 114
Global $test5 = 115
Global $test6 = 123
Global $test7 = 419

;;;;;


HotKeySet("{ESC}", "MyExit");Exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_DrawGUI()
_ClearGUI(0)


While 1
	Sleep(10)
	$msg = GUIGetMsg()
	$msg2 = TrayGetMsg()
	
	If $msg = $ClearButton Then
		_ClearGUI(0)
		$FirstDeal = 0
		If GUICtrlRead($ClearCheckbox) = 1 Then
			;MsgBox('','','')
			_ClearGUI(1)
		EndIf

	EndIf
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $msg = $DealButton Then
		_RunGame(GUICtrlRead($DealsInput))
	Else
		;
	EndIf
	
	If $msg = $FlopDeal Then _Flop()
	If $msg = $TurnDeal Then _Turn()
	If $msg = $RiverDeal Then _River()

	If $msg = $StatsButton Then ; Used to determine what types of hands were dealt and then list the winning hands
		If GUICtrlRead($StatsInput) >= 1 Then
			$aPlayersTotalHand = _AddPlayers2TableCards(_PlayersHands(), _TableCards(), GUICtrlRead($StatsInput))
			If $aPlayersTotalHand[0] = '' Or $aPlayersTotalHand[2] = '' Or $aPlayersTotalHand[5] = '' Or $aPlayersTotalHand[6] = '' Then
				MsgBox('', '', 'blank cards ?')
			Else
				;_ArrayDisplay($aPlayersTotalHand, "STATS BUTTON")
				_BigHand($aPlayersTotalHand)
				_SetBestHand($BestHand)
			EndIf
		Else
			_TableCards()
			If GUICtrlRead($StatsInput) = 0 And $aTableCards[0] <> '' Or $aTableCards[3] <> '' Or $aTableCards[4] <> '' Then
				
				For $i = 1 To $TotalPlayers
					$aPlayersTotalHand = _AddPlayers2TableCards(_PlayersHands(), _TableCards(), GUICtrlRead($StatsInput) + $i)
					;_ArrayDisplay($aPlayersTotalHand, "STATS BUTTON")
					_BigHand($aPlayersTotalHand)
				Next
				_SetBestHand($BestHand)
			EndIf
			
		EndIf
	EndIf

	If $msg2 = $SoundItem Then $Sounds = 0
	If $msg2 = $FastSoundItem Then $SoundsFast = 0
	If $msg2 = $AboutItem Then MsgBox('', 'About - 1.0', 'Created by nitekram' & @CRLF & _
			'To test more than one hand change hands to more than 1, else deal then press stats.')
	If $msg2 = $ExitItem Then Exit

WEnd

GUIDelete($TexasHoldem)

Func MyExit()

	Exit

EndFunc   ;==>MyExit

;USED FOR TESTING - Checking different types of hands
Func _NewCard() ; taken from another program on texas holdem - credit Rizzet - USED FOR TESTING
	Local $Card, $Card1, $Card2
	Do
		$Card1 = Random(1, 4, 1) * 100
		$Card2 = Random(12, 24, 1)
		$Card = $Card1 + $Card2
		_ArraySearch($iCard, $Card)
		For $i = 1 To 5
			If @error = $i Then
				MsgBox(1, "error", "error = " & $i)
				ExitLoop
			EndIf
		Next
	Until @error = 6
	
	If Not $Run Then
		If $TESTINGTEMP Then
			$TESTINGTEMP = 0
			Return $test1
		ElseIf $TESTINGTEMP = 0 Then
			$TESTINGTEMP = 1
			Return $test2

		EndIf
	EndIf
	Return $Card
EndFunc   ;==>_NewCard

Func _DrawGUI() ; Creates MAIN gui plus section for Stats
	
	$TexasHoldem = GUICreate("Texas Holdem - Practice Stats", 685, 833, 50, 0)
	GUISetBkColor($BackGround) ;0xE0FFFF -
	
	$FlopDeal = GUICtrlCreateButton("Flop", 350, 334, 50)	
	$TurnDeal = GUICtrlCreateButton("Turn", 517, 334, 50)
	$RiverDeal = GUICtrlCreateButton("River", 609, 334, 50)
	$CtrlGroup = GUICtrlCreateGroup('Controls', 300, 720, 335, 98)
	$DealButton = GUICtrlCreateButton("Deal", 510, 780, 50)
	$DealsInput = GUICtrlCreateInput(1, 565, 782, 35, 20)
	$ClearButton = GUICtrlCreateButton("Clear", 510, 745, 50)
	$ClearCheckbox = GUICtrlCreateCheckbox('', 565, 750, 35, 20)
	$StatsButton = GUICtrlCreateButton("STATS", 340, 780, 50)
	$StatsInput = GUICtrlCreateInput(0, 395, 782, 35, 20, 0x0800) ;,0x0800 no user input allowed
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group
	; Stats HANDS Dealt
	$StatsGroup = GUICtrlCreateGroup('Stats HANDS Dealt', 300, 480, 160, 230)
	$StatsLable[1] = GUICtrlCreateLabel("Royal Flush", 310, 500)
	$StatsLableCount[1] = GUICtrlCreateLabel("", 415, 500, 35)
	$StatsLable[2] = GUICtrlCreateLabel("Straight Flush", 310, 520)
	$StatsLableCount[2] = GUICtrlCreateLabel("", 415, 520, 35)
	$StatsLable[3] = GUICtrlCreateLabel("4 of A Kind", 310, 540)
	$StatsLableCount[3] = GUICtrlCreateLabel("", 415, 540, 35)
	$StatsLable[4] = GUICtrlCreateLabel("Full House", 310, 560)
	$StatsLableCount[4] = GUICtrlCreateLabel("", 415, 560, 35)
	$StatsLable[5] = GUICtrlCreateLabel("Flush", 310, 580)
	$StatsLableCount[5] = GUICtrlCreateLabel("", 415, 580, 35)
	$StatsLable[6] = GUICtrlCreateLabel("Straight", 310, 600)
	$StatsLableCount[6] = GUICtrlCreateLabel("", 415, 600, 35)
	$StatsLable[7] = GUICtrlCreateLabel("3 of A Kind", 310, 620)
	$StatsLableCount[7] = GUICtrlCreateLabel("", 415, 620, 35)
	$StatsLable[8] = GUICtrlCreateLabel("2 Pair", 310, 640)
	$StatsLableCount[8] = GUICtrlCreateLabel("", 415, 640, 35)
	$StatsLable[9] = GUICtrlCreateLabel("Pair", 310, 660)
	$StatsLableCount[9] = GUICtrlCreateLabel("", 415, 660, 35)
	$StatsLable[10] = GUICtrlCreateLabel("High Card", 310, 680)
	$StatsLableCount[10] = GUICtrlCreateLabel("", 415, 680, 35)
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group
	; Stats WINS Dealt
	$WinGroup = GUICtrlCreateGroup('Stats WINS Dealt', 475, 480, 160, 230)
	$WinLable[1] = GUICtrlCreateLabel("Royal Flush", 485, 500)
	$WinLableCount[1] = GUICtrlCreateLabel("", 590, 500, 35)
	$WinLable[2] = GUICtrlCreateLabel("Straight Flush", 485, 520)
	$WinLableCount[2] = GUICtrlCreateLabel("", 590, 520, 35)
	$WinLable[3] = GUICtrlCreateLabel("4 of A Kind", 485, 540)
	$WinLableCount[3] = GUICtrlCreateLabel("", 590, 540, 35)
	$WinLable[4] = GUICtrlCreateLabel("Full House", 485, 560)
	$WinLableCount[4] = GUICtrlCreateLabel("", 590, 560, 35)
	$WinLable[5] = GUICtrlCreateLabel("Flush", 485, 580)
	$WinLableCount[5] = GUICtrlCreateLabel("", 590, 580, 35)
	$WinLable[6] = GUICtrlCreateLabel("Straight", 485, 600)
	$WinLableCount[6] = GUICtrlCreateLabel("", 590, 600, 35)
	$WinLable[7] = GUICtrlCreateLabel("3 of A Kind", 485, 620)
	$WinLableCount[7] = GUICtrlCreateLabel("", 590, 620, 35)
	$WinLable[8] = GUICtrlCreateLabel("2 Pair", 485, 640)
	$WinLableCount[8] = GUICtrlCreateLabel("", 590, 640, 35)
	$WinLable[9] = GUICtrlCreateLabel("Pair", 485, 660)
	$WinLableCount[9] = GUICtrlCreateLabel("", 590, 660, 35)
	$WinLable[10] = GUICtrlCreateLabel("High Card", 485, 680)
	$WinLableCount[10] = GUICtrlCreateLabel("", 590, 680, 35)
	GUICtrlCreateGroup("", -99, -99, 1, 1) ;close group
	;DEAL
	For $j = 0 To $TotalPlayers * 2 - 1 Step 2
		$aPic[$j] = GUICtrlCreatePic($CardBlank, 15, $iTopPic, 71, 96)
		$aPic[$j + 1] = GUICtrlCreatePic($CardBlank, 101, $iTopPic, 71, 96)
		$aPic2[$j] = GUICtrlCreatePic("", 15, $iTopPic, 71, 96)
		$aPic2[$j + 1] = GUICtrlCreatePic("", 101, $iTopPic, 71, 96)
		$aLable[$j] = GUICtrlCreateLabel("", 176, $iTopPic+20, 50, 25)
		$iTopPic += 101
	Next
	; FLOP
	$iTopPic = 365
	$iLeftPic = 265
	For $j = $TotalPlayers * 2 + 2 To $TotalPlayers * 2 + 4
		$aPic[$j] = GUICtrlCreatePic($CardBlank, $iLeftPic, $iTopPic, 71, 96)
		$aPic2[$j] = GUICtrlCreatePic("", $iLeftPic, $iTopPic, 71, 96)
		$iLeftPic += 75
	Next
	; TURN
	$iTopPic = 365
	$iLeftPic = 507
	For $j = $TotalPlayers * 2 + 5 To $TotalPlayers * 2 + 5
		$aPic[$j] = GUICtrlCreatePic($CardBlank, $iLeftPic, $iTopPic, 71, 96)
		$aPic2[$j] = GUICtrlCreatePic("", $iLeftPic, $iTopPic, 71, 96)
		$iLeftPic += 55
	Next
	; RIVER
	$iTopPic = 365
	$iLeftPic = 599
	For $j = $TotalPlayers * 2 + 7 To $TotalPlayers * 2 + 7
		$aPic[$j] = GUICtrlCreatePic($CardBlank, $iLeftPic, $iTopPic, 71, 96)
		$aPic2[$j] = GUICtrlCreatePic("", $iLeftPic, $iTopPic, 71, 96)
		$iLeftPic += 55
	Next
	; POKER HAND RANKINGS
	$iLeftPic = 280
	$iTopPic = 15
	GUICtrlCreatePic('cards\poker3.gif', $iLeftPic, $iTopPic, 334, 308)
	
	; Tray items
	$OptionsItem = TrayCreateMenu("Options")
	$SoundItem = TrayCreateItem("Sound", $OptionsItem)
	TrayItemSetState(-1, $TRAY_CHECKED)
	$FastSoundItem = TrayCreateItem("Quick Sound", $OptionsItem)
	TrayItemSetState(-1, $TRAY_CHECKED)
	TrayCreateItem("")
	$AboutItem = TrayCreateItem("About")
	TrayCreateItem("")
	$ExitItem = TrayCreateItem("Exit")

	TraySetState()

	GUISetState(@SW_SHOW)
EndFunc   ;==>_DrawGUI

Func _Points($i)
	#cs
		                                                   
		                                  
		
		STEP ONE:  Add the value of your two cards using the scale below:
		Ace= 16 pts.   King= 14 pts.   Queen= 13 pts.   Jack= 12 pts.  Ten= 11 pts.
		all other cards are worth their face value, e.g., a two is 2 pts., a nine is 9 pts.
		
		STEP TWO:  If your two cards are paired, add 10 points to the total.
		
		STEP THREE:  If your two cards are both of the same suit, add four points.
		
		STEP FOUR:  If your cards are connected (i.e., next to each other in rank, as with a Jack and Ten, a Jack and a Queen, etc.) add three points.
		
		STEP FIVE:  If your cards have a one card "gap" (e.g., a Queen and a Ten, a Jack and a Nine, or an Ace and a Queen, etc.) add two points.
		
		STEP SIX:  If your cards have a two-card "gap" (e.g., an Ace and a Jack, a Queen and a Nine, or a Jack and an Eight, etc.) add one point.
		
		STEP SEVEN:  If you are in middle position add three points, and if you are in late position or on the button, add five points.
		
		STEP EIGHT:  Call a bet with 30 points or more, and raise or call a raise with 34 points or more.
	#ce
	
	If Mod($i, 2) = 0 Or $i = 0 Then
		;MsgBox(0, "", $i & " is an even number.")
		Select
			;Check the value of the first card and give value
			Case StringRight($iCard[$i], 2) = 24
				$CardPoints_1 = 16
			Case StringRight($iCard[$i], 2) = 23
				$CardPoints_1 = 14
			Case StringRight($iCard[$i], 2) = 22
				$CardPoints_1 = 13
			Case StringRight($iCard[$i], 2) = 21
				$CardPoints_1 = 12
			Case StringRight($iCard[$i], 2) = 20
				$CardPoints_1 = 11
			Case StringRight($iCard[$i], 2) = 19
				$CardPoints_1 = 9
			Case StringRight($iCard[$i], 2) = 18
				$CardPoints_1 = 8
			Case StringRight($iCard[$i], 2) = 17
				$CardPoints_1 = 7
			Case StringRight($iCard[$i], 2) = 16
				$CardPoints_1 = 6
			Case StringRight($iCard[$i], 2) = 15
				$CardPoints_1 = 5
			Case StringRight($iCard[$i], 2) = 14
				$CardPoints_1 = 4
			Case StringRight($iCard[$i], 2) = 13
				$CardPoints_1 = 3
			Case StringRight($iCard[$i], 2) = 12
				$CardPoints_1 = 2
				
		EndSelect
		
	Else

		; check if cards are same suite for hand ranking
		$Suited = _CheckSuite($iCard[$i - 1], $iCard[$i])
		; check distance between cards for hand ranking
		$Distance = _DistanceCards($iCard[$i - 1], $iCard[$i])

		Select
			;Check value for second card - add all points and write the points to the GUI
			Case StringRight($iCard[$i], 2) = 24
				$CardPoints_2 = 16
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 23
				$CardPoints_2 = 14
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 22
				$CardPoints_2 = 13
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 21
				$CardPoints_2 = 12
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 20
				$CardPoints_2 = 11
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 19
				$CardPoints_2 = 9
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 18
				$CardPoints_2 = 8
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 17
				$CardPoints_2 = 7
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 16
				$CardPoints_2 = 6
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 15
				$CardPoints_2 = 5
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 14
				$CardPoints_2 = 4
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 13
				$CardPoints_2 = 3
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
			Case StringRight($iCard[$i], 2) = 12
				$CardPoints_2 = 2
				_PointsData($i, $CardPoints_1 + $CardPoints_2 + $Distance + $Suited, $iCard[$i])
				
		EndSelect
		; clear points for next hand dealt
		$Suited = 0
		$CardPoints_1 = 0
		$CardPoints_2 = 0
		$Distance = 0
		
	EndIf

EndFunc   ;==>_Points

Func _CheckSuite($LastCard, $CheckCard)
	; find the suit of the card and see if it matches the last card for points
	For $i = 1 To 4
		If StringLeft($LastCard, 1) = $i And StringLeft($CheckCard, 1) = $i Then
			;MsgBox('','','SUITED')
			$Suited = $Suiteds
			Return $Suited
		Else
			;MsgBox('','NOT','SUITED')
			$Suited = 0
		EndIf
	Next

	Return $Suited
EndFunc   ;==>_CheckSuite

Func _DistanceCards($LastCard, $CheckCard)
	; check distance between cards to determine points for best starting hands
	If $LastCard <> $CheckCard Then
		Select
			Case StringRight($LastCard, 2) = 24 ; ACE
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 12 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 11 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 10 Then Return $Gap2
			Case StringRight($LastCard, 2) = 23 ; KING
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 22 ; QUEEN
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 21 ; JACK
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 20 ; TEN
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 19 ; NINE
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 18 ; EIGHT
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 17 ; SEVEN
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 16 ; SIX
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 15 ; FIVE
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 3 Then Return $Gap2
			Case StringRight($LastCard, 2) = 14 ; FOUR
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -10 Then Return $Gap2
			Case StringRight($LastCard, 2) = 13 ; THREE
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -11 Then Return $Gap1
			Case StringRight($LastCard, 2) = 12 ; TWO
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -1 Then Return $Connected
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -2 Then Return $Gap1
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -3 Then Return $Gap2
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = 0 Then Return $Paired
				If StringRight($LastCard, 2) - StringRight($CheckCard, 2) = -12 Then Return $Connected
			Case $LastCard = 1000
				
			Case Else
				
				MsgBox('', 'NOT FOUND DISTANCE', 'NO TURNED CARD?')
		EndSelect
		
	Else
		;MsgBox('','','SAME CARD')
	EndIf
	
EndFunc   ;==>_DistanceCards


Func _PointsData($i, $CardPoints_1, $Dealt)
	; used for displaying stats
	;MsgBox('', $Percent & ' %', 'show ' & $Dealt)
	GUICtrlSetData($aLable[$i - 1], $CardPoints_1 & " Points")
EndFunc   ;==>_PointsData

Func _ClearGUI($Pressed)
	; clears GUI of stats and blanks out cards - if pressed, other wise just blanks cards for next deal
	$FirstRun = 1
	$FirstDeal = 0
	$iCard = 0
	Global $iCard[26]
	;MsgBox('', 'NEW DECK', 'Dealing');, .25)
	$CardsOpened = 1
	
	For $i = 0 To $TotalPlayers * 2 - 1
		;MsgBox('', '', 'CLEARING AND BLANKING')
		GUICtrlSetImage($aPic2[$i], $CardBlank)
		GUICtrlSetImage($aPic2[$i], "Cards\" & $CardColor)
		GUICtrlSetData($aLable[$i], "")
		
	Next
	; FLOP
	For $i = $TotalPlayers * 2 + 2 To $TotalPlayers * 2 + 4
		GUICtrlSetImage($aPic2[$i], $CardBlank)
		GUICtrlSetImage($aPic2[$i], "Cards\" & $CardColor)
	Next
	; TURN
	For $i = $TotalPlayers * 2 + 5 To $TotalPlayers * 2 + 5
		GUICtrlSetImage($aPic2[$i], $CardBlank)
		GUICtrlSetImage($aPic2[$i], "Cards\" & $CardColor)
	Next
	; RIVER
	For $i = $TotalPlayers * 2 + 7 To $TotalPlayers * 2 + 7
		GUICtrlSetImage($aPic2[$i], $CardBlank)
		GUICtrlSetImage($aPic2[$i], "Cards\" & $CardColor)
	Next
	#cs
		If GUICtrlRead($ClearCheckbox) = 1 Then
		For $i = 1 To 10
		GUICtrlSetData($StatsLableCount[$i], '')
		
		Next
		; stats DEALT cards
		$RoyalFlushCount = 0
		$StraightFlushCount = 0
		$4KindCount = 0
		$FullHouseCount = 0
		$FlushCount = 0
		$StraightCount = 0
		$3KindCount = 0
		$2PairCount = 0
		$PairCount = 0
		$HighCardCount = 0
		EndIf
	#ce
	; create blank values for stats
	If $Pressed Then
		For $i = 1 To 10
			GUICtrlSetData($StatsLableCount[$i], '')
			GUICtrlSetData($WinLableCount[$i], '')
		Next
		; stats DEALT cards
		$RoyalFlushCount = 0
		$StraightFlushCount = 0
		$4KindCount = 0
		$FullHouseCount = 0
		$FlushCount = 0
		$StraightCount = 0
		$3KindCount = 0
		$2PairCount = 0
		$PairCount = 0
		$HighCardCount = 0
		; stats WIN Cards
		$RoyalFlushCountWIN = 0
		$StraightFlushCountWIN = 0
		$4KindCountWIN = 0
		$FullHouseCountWIN = 0
		$FlushCountWIN = 0
		$StraightCountWIN = 0
		$3KindCountWIN = 0
		$2PairCountWIN = 0
		$PairCountWIN = 0
		$HighCardCountWIN = 0
	EndIf
EndFunc   ;==>_ClearGUI

#Region
Func _RunGame($Deals)
	; used to make the deal once or many times
	If $Deals = 1 Then
		_Deal()
		
	Else
		For $r = 1 To $Deals
			_Deal()
			Sleep($DealsDelay)
			_Flop()
			Sleep($DealsDelay)
			_Turn()
			Sleep($DealsDelay)
			_River()
			Sleep($DealsDelay)
			For $i = 1 To $TotalPlayers
				$aPlayersTotalHand = _AddPlayers2TableCards(_PlayersHands(), _TableCards(), $i)
				;_ArrayDisplay($aPlayersTotalHand, "STATS BUTTON")
				_BigHand($aPlayersTotalHand)
				
			Next
			;MsgBox('', $BestHand & '   ' & $BestPlayersHand + 1, '$BestHand and player')
			_SetBestHand($BestHand) ; for each deal, must determine best hand
		Next
		
	EndIf
EndFunc   ;==>_RunGame
#EndRegion

#Region ;deal, flop, turn, river

Func _Deal()
	;MsgBox(0, "test", "_Deal")
	
	$BestHand = 0
	If @error Then MsgBox('', 'ERROR DEALING', @error)
	
	If $FirstDeal And Not $TESTING Then
		_ClearGUI(0)
	Else
		$FirstDeal = 0
	EndIf
	
	If $FirstRun Then
		If $Run And Not $RunRandom Then ; not testing code - call new functions with prebuilt deck of cards
			SoundPlay($SoundsFileShuffle, 1)
			
			For $i = 0 To $TotalPlayers * 2 - 1 Step 2
				$iCard[$i] = _NewCard2()
				ConsoleWrite($i & ' ' & $iCard[$i] & @CRLF)
				GUICtrlSetImage($aPic2[$i], $CardBlank)
				Sleep($DealDelay)
				;
				GUICtrlSetImage($aPic2[$i], "Cards\" & $iCard[$i] & ".gif")
				If $Sounds Then SoundPlay($SoundsFileDeal, $SoundsFast)
			Next
			
			For $i = 1 To $TotalPlayers * 2 - 1 Step 2
				$iCard[$i] = _NewCard2()
				ConsoleWrite($i & ' ' & $iCard[$i] & @CRLF)
				GUICtrlSetImage($aPic2[$i], $CardBlank)
				Sleep($DealDelay)
				;
				GUICtrlSetImage($aPic2[$i], "Cards\" & $iCard[$i] & ".gif")
				If $Sounds Then SoundPlay($SoundsFileDeal, $SoundsFast)
			Next
			
			
			For $i = 0 To $TotalPlayers * 2 - 1
				_Points($i)
			Next
			
			$FirstRun = 0
		Else ; testing code - used only for testing - using this until the functions for draw cards have been completed
			;
			;MsgBox('', '', 'TESTING')
			SoundPlay($SoundsFileShuffle, 1)
			
			For $i = 0 To $TotalPlayers * 2 - 1 Step 2
				$iCard[$i] = _NewCard()
				ConsoleWrite($i & ' ' & $iCard[$i] & @CRLF)
				GUICtrlSetImage($aPic2[$i], $CardBlank)
				Sleep($DealDelay)
				;
				GUICtrlSetImage($aPic2[$i], "Cards\" & $iCard[$i] & ".gif")
				If $Sounds Then SoundPlay($SoundsFileDeal, $SoundsFast)
			Next
			
			For $i = 1 To $TotalPlayers * 2 - 1 Step 2
				$iCard[$i] = _NewCard()
				ConsoleWrite($i & ' ' & $iCard[$i] & @CRLF)
				GUICtrlSetImage($aPic2[$i], $CardBlank)
				Sleep($DealDelay)
				;
				GUICtrlSetImage($aPic2[$i], "Cards\" & $iCard[$i] & ".gif")
				If $Sounds Then SoundPlay($SoundsFileDeal, $SoundsFast)
			Next
			
			For $i = 0 To $TotalPlayers * 2 - 1
				_Points($i)
			Next

			
			$FirstRun = 0
			
		EndIf
	Else
		
	EndIf

EndFunc   ;==>_Deal

Func _Flop()
	;MUCK TOP CARD
	If Not $TESTING And Not $TestingTableCards Then
		If $FirstFlop And Not $FirstRun Then
			$iCard[$TotalPlayers * 2] = _NewCard()
			$iCard[$TotalPlayers * 2] += 1000
			ConsoleWrite('MUCK           ' & $TotalPlayers * 2 & ' ' & $iCard[$TotalPlayers * 2] & @CRLF)
			For $i = $TotalPlayers * 2 + 1 To $TotalPlayers * 2 + 3
				If $RunRandom Then
					$iCard[$i] = _NewCard()
				Else
					$iCard[$i] = _NewCard2()
				EndIf
				ConsoleWrite($i & ' ' & $iCard[$i] & @CRLF)
				;;;;;;;;     MsgBox('', 'FLOP', $i + 1)
				GUICtrlSetImage($aPic2[$i + 1], $CardBlank)
				GUICtrlSetImage($aPic2[$i + 1], "Cards\" & $iCard[$i] & ".gif")
				If $Sounds Then SoundPlay($SoundsFileDeal, $SoundsFast)
			Next
			$FirstFlop = 0
		Else
			;
		EndIf
	Else
		If Not $TestingTableCards Then
			If $FirstFlop And Not $FirstRun Then
				;MsgBox('','','')
				$iCard[18] = -1 ; MUCK
				$iCard[19] = 214 ;First Card
				$iCard[20] = 215 ;Second Card
				$iCard[21] = 216 ; Third Card

				GUICtrlSetImage($aPic2[19 + 1], $CardBlank)
				GUICtrlSetImage($aPic2[19 + 1], "Cards\" & $iCard[19] & ".gif")
				GUICtrlSetImage($aPic2[20 + 1], $CardBlank)
				GUICtrlSetImage($aPic2[20 + 1], "Cards\" & $iCard[20] & ".gif")
				GUICtrlSetImage($aPic2[21 + 1], $CardBlank)
				GUICtrlSetImage($aPic2[21 + 1], "Cards\" & $iCard[21] & ".gif")
				$FirstFlop = 0
			EndIf
		Else
			;MsgBox('','','')
			$iCard[18] = -1 ; MUCK
			$iCard[19] = $test3;First Card
			$iCard[20] = $test4 ;Second Card
			$iCard[21] = $test5 ; Third Card

			GUICtrlSetImage($aPic2[19 + 1], $CardBlank)
			GUICtrlSetImage($aPic2[19 + 1], "Cards\" & $iCard[19] & ".gif")
			GUICtrlSetImage($aPic2[20 + 1], $CardBlank)
			GUICtrlSetImage($aPic2[20 + 1], "Cards\" & $iCard[20] & ".gif")
			GUICtrlSetImage($aPic2[21 + 1], $CardBlank)
			GUICtrlSetImage($aPic2[21 + 1], "Cards\" & $iCard[21] & ".gif")
		EndIf
	EndIf

EndFunc   ;==>_Flop

Func _Turn()
	;MUCK TOP CARD
	If Not $TESTING Or Not $TestingTableCards Then
		If $FirstTurn And Not $FirstFlop Then
			If $RunRandom Then
				$iCard[$TotalPlayers * 2 + 4] = _NewCard()
				$iCard[$TotalPlayers * 2 + 4] += 1000
			Else
				$iCard[$TotalPlayers * 2 + 4] = _NewCard2()
				$iCard[$TotalPlayers * 2 + 4] += 1000
			EndIf
			ConsoleWrite('MUCK           ' & $TotalPlayers * 2 + 4 & ' ' & $iCard[$TotalPlayers * 2 + 4] & @CRLF)
			For $i = $TotalPlayers * 2 + 5 To $TotalPlayers * 2 + 5
				If $RunRandom Then
					$iCard[$i] = _NewCard()
				Else
					$iCard[$i] = _NewCard2()
				EndIf
				ConsoleWrite($i & ' ' & $iCard[$i] & @CRLF)
				GUICtrlSetImage($aPic2[$i], $CardBlank)
				GUICtrlSetImage($aPic2[$i], "Cards\" & $iCard[$i] & ".gif")
				If $Sounds Then SoundPlay($SoundsFileDeal, $SoundsFast)
				
			Next
			$FirstTurn = 0
		Else
			;
		EndIf
	Else
		If Not $TestingTableCards Then
			If $FirstTurn And Not $FirstFlop Then
				$iCard[22] = -1
				$iCard[23] = 312
				GUICtrlSetImage($aPic2[22 + 1], $CardBlank)
				GUICtrlSetImage($aPic2[22 + 1], "Cards\" & $iCard[23] & ".gif")

			EndIf
		Else
			$iCard[22] = -1
			$iCard[23] = $test6
			GUICtrlSetImage($aPic2[22 + 1], $CardBlank)
			GUICtrlSetImage($aPic2[22 + 1], "Cards\" & $iCard[23] & ".gif")
			$FirstTurn = 0
		EndIf
		
	EndIf

EndFunc   ;==>_Turn

Func _River()
	;MUCK TOP CARD
	If Not $TESTING Or Not $TestingTableCards Then
		If $FirstRiver And Not $FirstTurn Then
			If $RunRandom Then
				$iCard[$TotalPlayers * 2 + 6] = _NewCard()
				$iCard[$TotalPlayers * 2 + 6] += 1000
			Else
				$iCard[$TotalPlayers * 2 + 6] = _NewCard2()
				$iCard[$TotalPlayers * 2 + 6] += 1000
			EndIf
			ConsoleWrite('MUCK           ' & $TotalPlayers * 2 + 6 & ' ' & $iCard[$TotalPlayers * 2 + 6] & @CRLF)
			For $i = $TotalPlayers * 2 + 7 To $TotalPlayers * 2 + 7
				If $RunRandom Then
					$iCard[$i] = _NewCard()
				Else
					$iCard[$i] = _NewCard2()
				EndIf
				ConsoleWrite($i & ' ' & $iCard[$i] & @CRLF)
				GUICtrlSetImage($aPic2[$i], $CardBlank)
				GUICtrlSetImage($aPic2[$i], "Cards\" & $iCard[$i] & ".gif")
				If $Sounds Then SoundPlay($SoundsFileDeal, $SoundsFast)
			Next
			$FirstDeal = 1
			$FirstRun = 1
			$FirstFlop = 1
			$FirstTurn = 1

		Else
			;
		EndIf
	Else
		If Not $TestingTableCards Then
			If $FirstRiver And Not $FirstTurn Then
				$iCard[24] = -1
				$iCard[25] = 215
				GUICtrlSetImage($aPic2[24 + 1], $CardBlank)
				GUICtrlSetImage($aPic2[24 + 1], "Cards\" & $iCard[25] & ".gif")
			EndIf
		Else
			$iCard[24] = -1
			$iCard[25] = $test7
			GUICtrlSetImage($aPic2[24 + 1], $CardBlank)
			GUICtrlSetImage($aPic2[24 + 1], "Cards\" & $iCard[25] & ".gif")
			
		EndIf
		
	EndIf
EndFunc   ;==>_River

#EndRegion 


Func _ArraySent($aArray, $CheckType)
	; used for testing to make sure array was sent to function
	If IsArray($aArray) Then
		;MsgBox('', $CheckType, 'array sent')
	Else
		MsgBox('', $CheckType, 'ERROR - No array sent.')
	EndIf
EndFunc   ;==>_ArraySent

Func _PlayersHands()
	; going to be used to determine best possible hand - so if both players have a pair, best pair wins
	Local $Count = 0
	
	;MsgBox('', '', 'in players hand ' & GUICtrlRead($StatsInput))
	ConsoleWrite(@CRLF)
	ConsoleWrite(@CRLF)
	ConsoleWrite(@CRLF)
	ConsoleWrite('Players Hands')
	ConsoleWrite(@CRLF)

	For $X = 0 To ($TotalPlayers * 2) - 1 Step 2
		;MsgBox('','',$count)
		$aPlayersHand[$Count][0] = $iCard[$X]
		$aPlayersHand[$Count][1] = $iCard[$X + 1]
		; call function add cards here to show an array of aPlayersTotalHand as an array and then send to checkstraight
		ConsoleWrite($Count & ' hand = ' & $aPlayersHand[$Count][0] & '  ' & $aPlayersHand[$Count][1] & @CRLF)
		ConsoleWrite($Count & '           hand = ' & $iCard[$X] & '  ' & $iCard[$X + 1] & @CRLF)
		$Count += 1

	Next

	; Different way to get hand - used for example only
	#cs
		For $i = 0 To 8
		For $j = 0 To 1
		$aPlayersHand[$i][$j] = $iCard[$count]
		ConsoleWrite(@CRLF)
		ConsoleWrite($i & '   ' & $aPlayersHand[$i][$j])
		ConsoleWrite(@CRLF)
		$count += 1
		Next
		Next
	#ce
	Return $aPlayersHand
EndFunc   ;==>_PlayersHands

Func _AddPlayers2TableCards($aPlayersHand, $aTableCards, $PlayerNumber = 1)
	; add the table cards to the players hand - last index in array is used for player number
	Local $aArrayTemp[7]

	_ArraySent($aPlayersHand, " adding players to table cards")
	
	If $PlayerNumber = 0 Then $PlayerNumber = 1
	$PlayerNumber -= 1
	;MsgBox('', $PlayerNumber, '$PlayerNumber')
	
	If $aTableCards = 0 Then
		;
	Else
		$aPlayersTotalHand[0] = $aPlayersHand[$PlayerNumber][0]
		$aPlayersTotalHand[1] = $aPlayersHand[$PlayerNumber][1]
		$aPlayersTotalHand[2] = $aTableCards[0]
		$aPlayersTotalHand[3] = $aTableCards[1]
		$aPlayersTotalHand[4] = $aTableCards[2]
		$aPlayersTotalHand[5] = $aTableCards[3]
		$aPlayersTotalHand[6] = $aTableCards[4]
		$aPlayersTotalHand[7] = $PlayerNumber
	EndIf
	
	;_ArrayDisplay($aPlayersTotalHand)
	
	;MsgBox('','',$aPlayersTotalHand[0] & $aPlayersTotalHand[1] & $aPlayersTotalHand[2] & $aPlayersTotalHand[3] & $aPlayersTotalHand[4] & $aPlayersTotalHand[5] & $aPlayersTotalHand[6])
	
	Return $aPlayersTotalHand

EndFunc   ;==>_AddPlayers2TableCards

Func _TableCards()
	;get table cards
	$aTableCards[0] = $iCard[$TotalPlayers * 2 + 1]
	$aTableCards[1] = $iCard[$TotalPlayers * 2 + 2]
	$aTableCards[2] = $iCard[$TotalPlayers * 2 + 3]
	$aTableCards[3] = $iCard[$TotalPlayers * 2 + 5]
	$aTableCards[4] = $iCard[$TotalPlayers * 2 + 7]
	
	Return $aTableCards
	
EndFunc   ;==>_TableCards

Func _SetBestHand($ShowBestHand)
	; used to show stats of best hand
	Select
		Case $ShowBestHand = $RoyalFlush
			$RoyalFlushCountWIN += 1
			GUICtrlSetData($WinLableCount[1], $RoyalFlushCountWIN)
			
		Case $ShowBestHand = $StraightFlush
			$StraightFlushCountWIN += 1
			GUICtrlSetData($WinLableCount[2], $StraightFlushCountWIN)
			
		Case $ShowBestHand = $4Kind
			$4KindCountWIN += 1
			GUICtrlSetData($WinLableCount[3], $4KindCountWIN)
			
		Case $ShowBestHand = $FullHouse
			$FullHouseCountWIN += 1
			GUICtrlSetData($WinLableCount[4], $FullHouseCountWIN)
			
		Case $ShowBestHand = $Flush
			$FlushCountWIN += 1
			GUICtrlSetData($WinLableCount[5], $FlushCountWIN)
			
		Case $ShowBestHand = $Straight
			$StraightCountWIN += 1
			GUICtrlSetData($WinLableCount[6], $StraightCountWIN)
			
		Case $ShowBestHand = $3Kind
			$3KindCountWIN += 1
			GUICtrlSetData($WinLableCount[7], $3KindCountWIN)

		Case $ShowBestHand = $2Pair
			$2PairCountWIN += 1
			GUICtrlSetData($WinLableCount[8], $2PairCountWIN)

		Case $ShowBestHand = $Pair
			$PairCountWIN += 1
			GUICtrlSetData($WinLableCount[9], $PairCountWIN)

		Case $ShowBestHand = $HighCard
			$HighCardCountWIN += 1
			GUICtrlSetData($WinLableCount[10], $HighCardCountWIN)
			
		Case Else
			;MsgBox('', '', 'not sure why it is not populating')
	EndSelect
EndFunc   ;==>_SetBestHand

Func _BestHand($Best, $aPlayersTotalHand)
	; later use of getting the best possible hand as winner
	;MsgBox('', ' best  besthand ', $Best & '  ' & $BestHand)
	If $Best >= $BestHand Then
		$BestHand = $Best
		$BestPlayersHand = $aPlayersTotalHand[7]
	EndIf
	; need to check the player coming in first compared to the last player to see who has the higher card value
	; this is going to take more time
	
EndFunc   ;==>_BestHand



#cs
	Func _FindFlush($aArray)
	Local $CountSuitSpades = 0, $CountSuitHearts = 0, $CountSuitDiamonds = 0, $CountSuitClubs = 0, $FlushCount = 0
	Local $aArrayTempSpades[7], $aArrayTempHearts[7], $aArrayTempDiamonds[7], $aArrayTempClubs[7], $CountTemp = 0
	
	;If IsArray($aArray) Then MsgBox('', '_FindFlush', 'array sent')
	For $i = 0 To UBound($aArray) - 1
	$CountTemp += 1
	;check flush
	; need to determin how many of each are in the same suit as if there is only one no flush
	If StringLeft($aArray[$i], 1) = 1 And $aArray[$i] > 100 Then
	$CountSuitSpades += 1
	;MsgBox('','',$CountSuitSpades)
	$aArrayTempSpades[$i] = $aArray[$i]
	;If $CountSuitSpades >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
	
	EndIf
	If StringLeft($aArray[$i], 1) = 2 And $aArray[$i] > 100 Then
	$CountSuitHearts += 1
	$aArrayTempHearts[$i] = $aArray[$i]
	;If $CountSuitHearts >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
	
	EndIf
	If StringLeft($aArray[$i], 1) = 3 And $aArray[$i] > 100 Then
	$CountSuitDiamonds += 1
	$aArrayTempDiamonds[$i] = $aArray[$i]
	;If $CountSuitDiamonds >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
	
	EndIf
	If StringLeft($aArray[$i], 1) = 4 And $aArray[$i] > 100 Then
	$CountSuitClubs += 1
	$aArrayTempClubs[$i] = $aArray[$i]
	;If $CountSuitClubs >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
	
	EndIf
	Next
	Select
	Case $CountSuitSpades >= 5
	$Flusher = 1
	Return $Flush
	Case $CountSuitHearts >= 5
	$Flusher = 1
	Return $Flush
	Case $CountSuitDiamonds >= 5
	$Flusher = 1
	Return $Flush
	Case $CountSuitClubs >= 5
	$Flusher = 1
	Return $Flush
	Case Else
	Return 0
	EndSelect
	
	EndFunc   ;==>_FindFlush
	
	
	Func _FindStraight($aArray)
	Dim $aArray2[8], $TempArray[8]
	Local $TempCount = 0
	
	_ArraySent($aArray, '_FindStraight')
	
	
	$aArray2 = $aArray
	For $i = 0 To UBound($aArray2) - 1
	
	If $aArray2[$i] < $TotalPlayers Then
	;MsgBox('', $i, $aArray2[$i])
	_ArrayDelete($aArray2, $i)
	
	EndIf
	Next
	
	
	For $i = 0 To UBound($aArray2) - 1
	$aArray2[$i] = StringRight($aArray2[$i], 2)
	
	Next
	
	;_ArrayDisplay($aArray2, " FIND STRAIGHT")
	
	;how many cards in each suit strip the suit first then check the number of cards in a row
	;if cards are the same then remove from new array that only has different cards
	
	$aArray2 = _ArrayUniqueLocal($aArray2)
	;_ArrayDisplay($aArray2, " FIND STRAIGHT")
	
	If _ArraySearch($aArray2, 24) <> -1 Then
	;MsgBox('', '$aArray2ace', $aArray2)
	$TempCount = 1
	For $j = 0 To UBound($aArray2) - 1
	If $aArray2[$j] = 12 Then $TempCount += 1
	If $aArray2[$j] = 13 Then $TempCount += 1
	If $aArray2[$j] = 14 Then $TempCount += 1
	If $aArray2[$j] = 15 Then $TempCount += 1
	
	
	If $TempCount >= 5 Then
	If _FindFlush($aArray) = $Flush Then
	
	;_ArrayDisplay($aArray, "straight flush")
	; ISSUE - figure out how to tell if the array is a flush or a straight
	; example - if A123 of spades and 4 of hearts and 6 of spades - returns Straight Flush
	Return $StraightFlush
	Else
	Return $Straight
	EndIf
	EndIf
	Next
	
	EndIf
	
	
	If _ArraySearch($aArray2, 24) <> -1 Then
	;MsgBox('', 'ace$aArray2', $aArray2)
	$TempCount = 1
	
	For $j = 0 To UBound($aArray2) - 1
	If $aArray2[$j] = 23 Then $TempCount += 1
	If $aArray2[$j] = 22 Then $TempCount += 1
	If $aArray2[$j] = 21 Then $TempCount += 1
	If $aArray2[$j] = 20 Then $TempCount += 1
	
	
	If $TempCount >= 5 Then
	If _FindFlush($aArray) = $Flush Then
	; ISSUE - figure out how to tell if the array is a flush or a straight
	; example if AKQJ of spades and 10 of hearts and 2 of spades - returns Royal Flush
	Return $RoyalFlush
	Else
	Return $Straight
	EndIf
	EndIf
	Next
	
	EndIf
	
	;_ArrayDisplay($aArray2, "after the removing dupes in straight")
	
	
	
	For $i = 0 To UBound($aArray2) - 2
	If $TempCount > 	UBound($aArray2) - 2 Then ExitLoop
	If $aArray2[$i] - $aArray2[$i + 1] = -1 Then
	;MsgBox('', $aArray2[$i] & '   ' & $aArray2[$i + 1], $aArray2[$i] - $aArray2[$i + 1])
	If $aArray2[$i + 1] - $aArray2[$i + 2] = -1 Then
	;MsgBox('', $aArray2[$i + 1] & '   ' & $aArray2[$i + 2], $aArray2[$i + 1] - $aArray2[$i + 2])
	If $aArray2[$i + 2] - $aArray2[$i + 3] = -1 Then
	;MsgBox('', $aArray2[$i + 2] & '   ' & $aArray2[$i + 3], $aArray2[$i + 2] - $aArray2[$i + 3])
	If $aArray2[$i + 3] - $aArray2[$i + 4] = -1 Then
	;	MsgBox('', $aArray2[$i + 3] & '   ' & $aArray2[$i + 4], $aArray2[$i + 3] - $aArray2[$i + 4])
	;	MsgBox('', 'yep', 'maybe straight')
	If _FindFlush($aArray) = $Flush Then
	; ISSUE - figure out how to tell if the array is a flush or a straight
	; example if AKQJ of spades and 10 of hearts and 2 of spades - returns Royal Flush
	Return $StraightFlush
	Else
	Return $Straight
	EndIf
	Else
	;
	EndIf
	Else
	;
	EndIf
	Else
	;
	EndIf
	Else
	;
	EndIf
	Next
	
	EndFunc   ;==>_FindStraight
#ce




Func _FindPairs($aArray)
	; depends on the size of array to determine how many cards match up
	Dim $aArray2[7], $TempArray[7]
	_ArraySent($aArray, '_FindPairs')
	
	For $i = 0 To UBound($aArray) - 2
		$aArray2[$i] = StringRight($aArray[$i], 2)
	Next
	;MsgBox('', 'Entering the find pairs', UBound($aArray2))
	;_ArrayDisplay($aArray2, " FIND PAIR")
	$aArray2 = _ArrayYesDupes($aArray2)
	If UBound($aArray2) = 8 Then
		;MsgBox('', '', 'DUMMY')
		$aArray2 = _ArrayNoDupes($aArray2)
		If UBound($aArray2) = 7 Then
			Return $2Pair
		Else
			Return $BlankCards
		EndIf
	EndIf

	If UBound($aArray2) = $3Kind + 1 Then ;4
		Return $3Kind
	EndIf
	
	If UBound($aArray2) = $4Kind - 2 Then ;5
		$TempArray = $aArray2
		$TempArray = _ArrayNoDupes($TempArray)
		If UBound($TempArray) = 1 Then Return $4Kind
	EndIf
	
	If UBound($aArray2) = $FullHouse Then ;6
		Return $FullHouse
	EndIf
	
	If UBound($aArray2) = $FullHouse Then ;6
		Return $FullHouse
	EndIf
	
	If UBound($aArray2) <= 7 Then
		
		$aArray2 = _ArrayNoDupes($aArray2)
		;MsgBox("", "UBound($aArray2) LESS THAN 7 MAY NOT MATCH", UBound($aArray2))
		;_ArrayDisplay($aArray2, "after no dupes in findpairs          ")
		
		Select
			Case UBound($aArray2) = 1
				;MsgBox('', '', 'High card')
				Return $HighCard
			Case UBound($aArray2) = 2
				;MsgBox('', '', 'pair')
				Return $Pair
			Case UBound($aArray2) = 3
				;MsgBox('', '', ' 2   pair')
				Return $2Pair
		EndSelect

	Else
		;
	EndIf
	;Exit
	
EndFunc   ;==>_FindPairs



Func _FindFlush($aArray, $checkstraight = 0)
	Local $CountSuitSpades = 0, $CountSuitHearts = 0, $CountSuitDiamonds = 0, $CountSuitClubs = 0, $FlushCount = 0
	Local $aArrayTempSpades[7], $aArrayTempHearts[7], $aArrayTempDiamonds[7], $aArrayTempClubs[7], $CountTemp = 0
	
	;If IsArray($aArray) Then MsgBox('', '_FindFlush', 'array sent')
	For $i = 0 To UBound($aArray) - 1
		$CountTemp += 1
		;check flush
		; need to determin how many of each are in the same suit as if there is only one no flush
		If StringLeft($aArray[$i], 1) = 1 And $aArray[$i] > 100 Then
			$CountSuitSpades += 1
			;MsgBox('','',$CountSuitSpades)
			$aArrayTempSpades[$i] = $aArray[$i]
			;If $CountSuitSpades >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
			
		EndIf
		If StringLeft($aArray[$i], 1) = 2 And $aArray[$i] > 100 Then
			$CountSuitHearts += 1
			$aArrayTempHearts[$i] = $aArray[$i]
			;If $CountSuitHearts >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
			
		EndIf
		If StringLeft($aArray[$i], 1) = 3 And $aArray[$i] > 100 Then
			$CountSuitDiamonds += 1
			$aArrayTempDiamonds[$i] = $aArray[$i]
			;If $CountSuitDiamonds >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
			
		EndIf
		If StringLeft($aArray[$i], 1) = 4 And $aArray[$i] > 100 Then
			$CountSuitClubs += 1
			$aArrayTempClubs[$i] = $aArray[$i]
			;If $CountSuitClubs >= 5 And $countTemp >= UBound($aArray) - 1 Then Return 1
			
		EndIf
	Next
	;MsgBox('','','one')
	Select
		Case $CountSuitSpades >= 5
			$Flusher = 1
			If $checkstraight Then
				;MsgBox('', '', 'straightflush')
				
				;_ArrayDisplay($aArrayTempSpades)
				For $i = UBound($aArrayTempSpades) - 1 To 0 Step -1
					If StringStripWS($aArrayTempSpades[$i], 8) = '' Then _ArrayDelete($aArrayTempSpades, $i)
				Next
				;_ArrayDisplay($aArrayTempSpades)
				
				
				
				Return $aArrayTempSpades
			Else
				Return $Flush
			EndIf
		Case $CountSuitHearts >= 5
			$Flusher = 1
			If $checkstraight Then
				;MsgBox('', '', 'straightflush')
				
				
				For $i = UBound($aArrayTempSpades) - 1 To 0 Step -1
					If StringStripWS($aArrayTempHearts[$i], 8) = '' Then _ArrayDelete($aArrayTempHearts, $i)
				Next
				
				
				
				
				Return $aArrayTempHearts
			Else
				Return $Flush
			EndIf
		Case $CountSuitDiamonds >= 5
			$Flusher = 1
			If $checkstraight Then
				;MsgBox('', '', 'straightflush')
				
				
				For $i = UBound($aArrayTempDiamonds) - 1 To 0 Step -1
					If StringStripWS($aArrayTempDiamonds[$i], 8) = '' Then _ArrayDelete($aArrayTempDiamonds, $i)
				Next
				
				
				
				
				Return $aArrayTempDiamonds
			Else
				Return $Flush
			EndIf
		Case $CountSuitClubs >= 5
			$Flusher = 1
			If $checkstraight Then
				;MsgBox('', '', 'straightflush')
				
				
				For $i = UBound($aArrayTempClubs) - 1 To 0 Step -1
					If StringStripWS($aArrayTempClubs[$i], 8) = '' Then _ArrayDelete($aArrayTempClubs, $i)
				Next
				
				
				
				
				Return $aArrayTempClubs
			Else
				Return $Flush
			EndIf
		Case Else
			Return 0
	EndSelect

EndFunc   ;==>_FindFlush

Func _FindStraight($aArray)
	Dim $aArray2 = $aArray, $TempCount
	Local $value, $previous = $aArray2[0], $temp[1] = [0], $return[1] = [0]
	
	; Used to find the last two digits of the card
	For $i = 0 To UBound($aArray2) - 1
		$aArray2[$i] = StringRight($aArray2[$i], 2)
	Next

	_ArraySort($aArray2)
	;_ArrayDisplay($aArray2, 'after sort')
	$aArray2 = _ArrayUniqueLocal($aArray2)
	;_ArrayDisplay($aArray2, 'no dupes')
	;_ArraySort($aArray2)
	;_ArrayDisplay($aArray2, 'after sort')


	;Thanks to PsaltyDS for th following code
	For $n = 0 To UBound($aArray2) - 1
		$value = $aArray2[$n]
		If ($value - $previous) = 1 Then
			_ArrayAdd($temp, $value)
			If UBound($temp) > UBound($return) Then
				$return = $temp
			EndIf
		Else
			Dim $temp[2] = [1, $value]
		EndIf
		$previous = $value
	Next
	$return[0] = UBound($return) - 1

	If $return[0] >= 5 Then
		; Look for small straight AKQJ10
		If _ArraySearch($return, 24) <> -1 Then
			;MsgBox('', '', 'contains ace and possible ROYAL STRAIGHT FLUSH')
			
			$TempCount = 1
			For $j = 0 To UBound($return) - 1
				;_ArrayDisplay($return, '   FOR')
				If StringRight($return[$j], 2) = 23 Then $TempCount += 1
				If StringRight($return[$j], 2) = 22 Then $TempCount += 1
				If StringRight($return[$j], 2) = 21 Then $TempCount += 1
				If StringRight($return[$j], 2) = 20 Then $TempCount += 1
				
				If $TempCount >= 5 Then Return 1
			Next
						
		Else
			;MsgBox('','','straight?')
			_ArrayDelete($return, 0)
			;_ArrayDisplay($return, 'straight?')
			Return $Straight
		EndIf
	Else
		;MsgBox('','','')
		;_ArrayDisplay($return)
		; Look for small straight A2345
		If _ArraySearch($aArray2, 24) <> -1 Then
			; STILL NEED TO WORK ON THIS
			;MsgBox('', 'check small straight', 'could be small straigth')
			$TempCount = 1
			For $j = 0 To UBound($return) - 1
				;_ArrayDisplay($return, '   FOR')
				If StringRight($return[$j], 2) = 12 Then $TempCount += 1
				If StringRight($return[$j], 2) = 13 Then $TempCount += 1
				If StringRight($return[$j], 2) = 14 Then $TempCount += 1
				If StringRight($return[$j], 2) = 15 Then $TempCount += 1
				
				If $TempCount >= 5 Then Return 2
			Next
			
		Else
			;_ArrayDisplay($return, "$return false no straight")
			Return 0
		EndIf
	EndIf
EndFunc   ;==>_FindStraight








Func _BigHand($aArray)
	; checks the type of hand and sets add it to the stat listings
	Local $CheckingPairs, $star
	;$CheckingPairs = _FindPairs($aArray)
	Select
		
		; need to do
		; create instance of A2345 and AKQJ10 for royal flush
		
		Case IsArray(_FindFlush($aArray, 1))
			;$HANDisFLUSH = 1
			;_FindStraight($hand)
			$star = _FindFlush($aArray, 1) ; calling twice - may need to fix this so it calls only once
			;_ArrayDisplay($star, "tell me why")
			If _FindStraight(_FindFlush($star, 1)) = $Straight Then
				
				;;;;;; not working as planned
				;If _ArraySearch($star, 124) <> -1 Then _ArrayDisplay($star, 'look for 24')
				If _ArraySearch($star, 124) <> -1 Or _
						_ArraySearch($star, 224) <> -1 Or _
						_ArraySearch($star, 324) <> -1 Or _
						_ArraySearch($star, 424) <> -1 And _
					(_ArraySearch($star, 123) <> -1 Or _
						_ArraySearch($star, 223) <> -1 Or _
						_ArraySearch($star, 323) <> -1 Or _
						_ArraySearch($star, 423) <> -1)  Then
					$RoyalFlushCount += 1
					GUICtrlSetData($StatsLableCount[1], $RoyalFlushCount)
					_BestHand($RoyalFlush, $aPlayersTotalHand)
					;MsgBox('', '', '$RoyalFlushCount')
					
					
					
				Else
					;If 1 = 1 then MsgBox('','','look for small straight')
					;MsgBox('', "$HANDisSTRAIGHTFLUSH", '')
					$StraightFlushCount += 1
					GUICtrlSetData($StatsLableCount[2], $StraightFlushCount)
					_BestHand($StraightFlush, $aPlayersTotalHand)
				EndIf
			EndIf
			#cs
				Else
				MsgBox('', "$HANDisFLUSH", '')
				EndIf
				;Case _FindFlush($hand) = $StraightFlush
				;MsgBox('', "$HANDisSTRAIGHTFLUSH", '')
				Case Not IsArray(_FindFlush($aArray, 1))
				If _FindStraight($aArray) Then
				MsgBox('', '', 'straight')
				Else
				MsgBox('', '', 'neither')
				EndIf
				
			#ce









			#cs
				Case _FindStraight($aArray) = $RoyalFlush And $Flusher
				$RoyalFlushCount += 1
				GUICtrlSetData($StatsLableCount[1], $RoyalFlushCount)
				_BestHand($RoyalFlush, $aPlayersTotalHand)
				MsgBox('', '', '$RoyalFlushCount', 1)
				
				Case _FindStraight($aArray) = $StraightFlush And $Flusher
				$StraightFlushCount += 1
				GUICtrlSetData($StatsLableCount[2], $StraightFlushCount)
				_BestHand($StraightFlush, $aPlayersTotalHand)
				MsgBox('', '', '$StraightFlush', 1)
			#ce
		Case _FindPairs($aArray) = $4Kind
			$4KindCount += 1
			GUICtrlSetData($StatsLableCount[3], $4KindCount)
			_BestHand($4Kind, $aPlayersTotalHand)
			;MsgBox('', '', '$4KindCount', 1)
		Case _FindPairs($aArray) = $FullHouse
			$FullHouseCount += 1
			GUICtrlSetData($StatsLableCount[4], $FullHouseCount)
			_BestHand($FullHouse, $aPlayersTotalHand)
			;MsgBox('', '', '$$FullHouseCount', 1)
		Case _FindFlush($aArray) = $Flush Or $Flusher
			$FlushCount += 1
			GUICtrlSetData($StatsLableCount[5], $FlushCount)
			_BestHand($Flush, $aPlayersTotalHand)
			;MsgBox('', '', 'Flush Wins', 1)
		Case _FindStraight($aArray) = $Straight
			$StraightCount += 1
			GUICtrlSetData($StatsLableCount[6], $StraightCount)
			_BestHand($Straight, $aPlayersTotalHand)
			MsgBox('', '', 'Straight Wins')
		Case _FindPairs($aArray) = $3Kind
			$3KindCount += 1
			GUICtrlSetData($StatsLableCount[7], $3KindCount)
			_BestHand($3Kind, $aPlayersTotalHand)
			;MsgBox('', '', '3 of a kind wins', 1)
		Case _FindPairs($aArray) = $2Pair
			$2PairCount += 1
			GUICtrlSetData($StatsLableCount[8], $2PairCount)
			_BestHand($2Pair, $aPlayersTotalHand)
			;MsgBox('', '', '2   pair Wins', 1)
		Case _FindPairs($aArray) = $Pair
			$PairCount += 1
			GUICtrlSetData($StatsLableCount[9], $PairCount)
			_BestHand($Pair, $aPlayersTotalHand)
			;MsgBox('', '', 'pair Wins', 1)
		Case _FindPairs($aArray) = $HighCard
			$HighCardCount += 1
			GUICtrlSetData($StatsLableCount[10], $HighCardCount)
			_BestHand($HighCard, $aPlayersTotalHand)
			;MsgBox('', '', '$HighCard', 1)
		Case _FindPairs($aArray) = $BlankCards ; need this for 3 pair
			;MsgBox('', '', 'DUMMY                TWO')
			;_ArrayDisplay($aArray, "  DUMMY TWO")
			$2PairCount += 1
			GUICtrlSetData($StatsLableCount[8], $2PairCount)
			_BestHand($BlankCards, $aPlayersTotalHand)
			;MsgBox('', '3 pairs showing', '2   pair Wins', 1)
		Case Else
			;MsgBox('', '', 'no hand found - ', 10)
	EndSelect
	
	$Flusher = 0
EndFunc   ;==>_BigHand

Func _ArrayNoDupes($aArray)
	Dim $TempArray[7]
	Dim $aArray2 = $aArray
	Local $Count = 0
	_ArraySort($aArray2)
	;_ArrayDisplay($aArray2)
	For $i = 0 To UBound($aArray) - 2
		For $j = 0 To UBound($aArray) - 2
			If _ArraySearch($TempArray, $aArray2[$i]) Then
				If @error = 6 Then
					$TempArray[$Count] = $aArray2[$i]
					$Count += 1
				EndIf
			EndIf
		Next
	Next
	ReDim $TempArray[$Count + 1] ; Remove the empty array elements

	Return $TempArray
EndFunc   ;==>_ArrayNoDupes

Func _ArrayYesDupes($aArray)
	Dim $TempArray[7]
	Local $Count = 0, $FIND
	For $INDEX = 0 To UBound($aArray) - 1
		$FIND = _ArrayFindAll($aArray, $aArray[$INDEX])
		If UBound($FIND) > 1 Then
			$TempArray[$Count] = $aArray[$INDEX]
			$Count += 1
		EndIf
	Next

	ReDim $TempArray[$Count + 1] ; Remove the empty array elements

	Return $TempArray
EndFunc   ;==>_ArrayYesDupes



;Thanks to SmOke_N for the code
Func _ArrayUniqueLocal(ByRef $aArray, $vDelim = '', $iBase = 0, $iCase = 0)
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)
	If $vDelim = '' Then $vDelim = Chr(1)
	Local $sHold = ""
	For $iCC = $iBase To UBound($aArray) - 1
		If Not StringInStr($vDelim & $sHold, $vDelim & $aArray[$iCC] & $vDelim, $iCase) Then
			$sHold &= $aArray[$iCC] & $vDelim
		EndIf
	Next
	$sHold = StringTrimRight($sHold, StringLen($vDelim))
	If $sHold And $iBase = 1 Then
		$aArray = StringSplit($sHold, $vDelim)
		Return SetError(0, 0, $aArray)
	ElseIf $sHold And $iBase = 0 Then
		$aArray = StringRegExp($sHold & $vDelim, "(?s)(.+?)" & $vDelim, 3)
		Return SetError(0, 0, $aArray)
	EndIf
	Return SetError(2, 0, 0)
EndFunc   ;==>_ArrayUniqueLocal













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Special thanks to spudw2k for creating his deck of cards functions
;;;    http://www.autoitscript.com/forum/index.php?showtopic=80388&hl=
#Region spudw2k
Func _InitializeDeck($faces = 0, $suits = 0, $decks = 1)
	;MsgBox('', '', 'NEW DECK')
	;If Not IsArray($faces) Then Dim $faces[13] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
	;If Not IsArray($suits) Then Dim $suits[4] = [0, 1, 2, 3]
	
	If Not IsArray($faces) Then Dim $faces[13] = [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
	If Not IsArray($suits) Then Dim $suits[4] = [1, 2, 3, 4]
	
	Dim $deck[4]
	Dim $Suit = 0
	Dim $Card = 0
	For $i = 1 To $decks
		;MsgBox('', '', UBound($faces))
		For $X = 0 To UBound($faces) - 1
			ReDim $deck[$Card + 4]
			Do
				$deck[$Card] = $suits[$Suit] & $faces[$X]
				$Card += 1
				$Suit += 1
			Until $Suit >= 4
			$Suit = 0
		Next
	Next
	;_ArrayDisplay($deck)
	;_ArraySort($deck)
	;_ArrayDisplay($deck)
	Return $deck
EndFunc   ;==>_InitializeDeck

Func _DrawCards(ByRef $deck, $Count)
	If UBound($deck) < $Count Or $CardsOpened Then $deck = _NewDeck()
	
	_ArrayReverse($deck)
	Dim $cards[$Count]
	For $i = 0 To $Count - 1
		$cards[$i] = $deck[UBound($deck) - 1]
		_ArrayPop($deck)
	Next
	_ArrayReverse($deck)
	$CardsOpened = 0
	Return $cards
EndFunc   ;==>_DrawCards

Func _ShuffleDeck($deck)
	;SRandom(Random(0, 10))
	For $X = 0 To 50
		_ArraySwap($deck[Random($X, 51, 1)], $deck[$X])
	Next
	For $X = 51 To 1 Step -1
		_ArraySwap($deck[Random(0, $X, 1)], $deck[$X])
	Next
	Return $deck
EndFunc   ;==>_ShuffleDeck

Func _CutDeck($deck, $Count = 0)
	If $Count <= 0 Or $Count >= UBound($deck) - 1 Then $Count = Random(13, 39, 1)
	For $i = 1 To $Count
		_ArrayPush($deck, $deck[UBound($deck) - 1], 1)
	Next
	Return $deck
EndFunc   ;==>_CutDeck

Func _NewDeck()
	Dim $faces[13] = [12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24]
	Dim $suits[4] = [1, 2, 3, 4]
	Return _CutDeck(_ShuffleDeck(_InitializeDeck($faces, $suits)))
	
EndFunc   ;==>_NewDeck

;Replace this function
Func _NewCard2()
	Local $Mycard
	$Mycard = _DrawCards($deck, 1)

	Return $Mycard[0]
EndFunc   ;==>_NewCard2


#EndRegion spudw2k