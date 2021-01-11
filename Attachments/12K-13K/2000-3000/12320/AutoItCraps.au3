;"This function uses code developed by Paul Campbell (PaulIA) for the Auto3Lib project"
; Created by Kohr
#region --- include, Opt, Globals, HotKeySet ---
#include <GUIConstants.au3>
#include <Array.au3>
#include <GuiStatusBar.au3>
#include <GuiListView.au3>
#include <Misc.au3>
#include <GuiTreeView.au3>

Opt("GUIOnEventMode", 1)
;Globals for Auto3Lib
Global $gaLibDlls[64][2] = [[0, 0]]
Global Const $RECT = "int;int;int;int"
Global Const $RECT_LEFT = 1
Global Const $RECT_TOP = 2
Global Const $RECT_RIGHT = 3
Global Const $RECT_BOTTOM = 4

Global $GUIPayoutOdds
Global $GUIOptions
;~ Global $GUIAbout
Global $GUIHelp
Global $GUIStats
Global $DiceResults = _ArrayCreate(16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
Global $DiceRollNames = _ArrayCreate("16", "Snake Eyes", "Loose Deuce", "Hard Four", "Easy Four", "Fever Five", _
		"Easy Six", "Hard Six", "Seven Out", "Easy Eight", "Hard Eight", "Nina", _
		"Easy Ten", "Hard Ten", "Yo", "Boxcars")
Global $PassStatus = 0
Global $ComeStatus = 0
Global $PointNeeded = 0
Global $ComePointNeeded = 0
Global $GraphicDice1, $GraphicDice2
Global $Dice1Value, $Dice2Value
Global $labelPointMarker[7]
Global $labelComeMarker[7]
Global $labelOddsPoint[5]
Global $inputBet[24]

Global $aGrid1[1]
Global $aGrid2[1]
Global $aGrid3[1]
Global $aHouse1[1]
Global $aHouse2[1]
Global $aHouse3[1]
Global $aHouse4[1]
Global $aOptions[1]
Global $aRollStats[1]
Global $aHouseStats[42][4]

Global $BetBucket[1][1]

Global $ConsoleText
Global $treeviewHelp
Global $editHelp

HotKeySet("{F1}", "HideHelp")
#endregion --- include, Opt, Globals, HotKeySet ---

GUIStats()
GUIPayoutOdds()
GUIOptions()
GUIHelp()
RefreshStats()
#region --- GUI ---
$GUImain = GUICreate("AutoIt Craps", 805, 470, -1, -1, $WS_SYSMENU + $WS_MINIMIZEBOX)

;Menu Items
$menu1 = GUICtrlCreateMenu("&File")
$itemLoad = GUICtrlCreateMenuitem("Load History", $menu1)
GUICtrlSetOnEvent($itemLoad, "LoadHistory")
$itemSave = GUICtrlCreateMenuitem("Save History", $menu1)
GUICtrlSetOnEvent($itemSave, "SaveHistory")

$menu2 = GUICtrlCreateMenu("&Display")
$itemStatistics = GUICtrlCreateMenuitem("Statistics", $menu2)
GUICtrlSetOnEvent($itemStatistics, "HideStats")
$itemPayout = GUICtrlCreateMenuitem("Payout Odds", $menu2)
GUICtrlSetOnEvent($itemPayout, "HidePayoutOdds")
$itemOptions = GUICtrlCreateMenuitem("Options", $menu2)
GUICtrlSetOnEvent($itemOptions, "HideOptions")

$menu3 = GUICtrlCreateMenu("&Help")
$itemGameInfo = GUICtrlCreateMenuitem("How to Play @ Wikipedia", $menu3)
GUICtrlSetOnEvent($itemGameInfo, "OpenWiki")
$itemHelp = GUICtrlCreateMenuitem("Help", $menu3)
GUICtrlSetOnEvent($itemHelp, "HideHelp")

;Table Layout
$j = 0
For $i = 0 To 250 Step 50
	$j += 1
	GUICtrlCreateLabel("", 10 + $i, 10, 50, 20, $SS_BLACKFRAME)
	$labelPointMarker[$j] = GUICtrlCreateLabel("", 11 + $i, 11, 48, 18, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 800)
Next
UdfLabel("4", 10, 30, 50, 30, 20, 800)
UdfLabel("5", 60, 30, 50, 30, 20, 800)
UdfLabel("Six", 110, 30, 50, 30, 14, 800)
UdfLabel("8", 160, 30, 50, 30, 20, 800)
UdfLabel("Nine", 210, 30, 50, 30, 14, 800)
UdfLabel("10", 260, 30, 50, 30, 20, 800)
$BetCounter = 0
For $i = 0 To 250 Step 50
	$BetCounter += 1
	$inputBet[$BetCounter] = GUICtrlCreateCombo("", 10 + $i, 60, 50, 20, $CBS_DROPDOWNLIST)
	GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
Next
$BetCounter += 1	;7 here
UdfLabel("Don't" & @CRLF & "Come", 310, 10, 50, 50, 9, 800)
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 310, 60, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlSetState(-1, $GUI_DISABLE)

$j = 0
For $i = 0 To 250 Step 50
	$j += 1
	GUICtrlCreateLabel("", 10 + $i, 85, 50, 20, $SS_BLACKFRAME)
	$labelComeMarker[$j] = GUICtrlCreateLabel("", 11 + $i, 86, 48, 18, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 800)
Next
UdfLabel("Come", 10, 105, 300, 30, 20, 800)
$BetCounter += 1	;8 here
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 310, 105, 50, 30, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlSetState(-1, $GUI_DISABLE)
UdfLabel("2 3 4 9 10 11 12" & @CRLF & "Field", 10, 140, 120, 30, 9, 800)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 130, 140, 50, 30, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
UdfLabel("6 BIG 8", 210, 140, 100, 30, 18, 800)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 310, 140, 50, 30, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
UdfLabel("Don't Pass", 10, 175, 310, 20, 10, 800)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 310, 175, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
UdfLabel("Pass", 10, 200, 300, 20, 10, 800)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 310, 200, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
;One Time Bets
GUICtrlCreateLabel("", 380, 10, 110, 20, $SS_BLACKFRAME)
GUICtrlCreateLabel("5 for 1", 382, 18, 28, 10, $SS_CENTER)
GUICtrlSetFont(-1, 7, 400)
GUICtrlCreateLabel("Seven", 411, 11, 43, 17, $SS_CENTER)
GUICtrlSetFont(-1, 9, 800, 2)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlCreateLabel("5 for 1", 458, 18, 28, 10, $SS_CENTER)
GUICtrlSetFont(-1, 7, 400)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 490, 10, 40, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 380, 35, 75, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("10 for 1", 381, 55, 73, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(405, 40, 3)
SmallDice(420, 40, 3)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 380, 70, 75, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 455, 35, 75, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("8 for 1", 456, 55, 73, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(480, 40, 5)
SmallDice(495, 40, 5)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 455, 70, 75, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 380, 95, 75, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("10 for 1", 381, 115, 73, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(405, 100, 4)
SmallDice(420, 100, 4)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 380, 130, 75, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 455, 95, 75, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("8 for 1", 456, 115, 73, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(480, 100, 2)
SmallDice(495, 100, 2)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 455, 130, 75, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 380, 155, 50, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("15 for 1", 381, 175, 48, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(395, 160, 1)
SmallDice(410, 160, 2)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 380, 190, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 430, 155, 50, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("30 for 1", 431, 175, 48, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(445, 160, 1)
SmallDice(460, 160, 1)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 430, 190, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 480, 155, 50, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("30 for 1", 481, 175, 48, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(495, 160, 6)
SmallDice(510, 160, 6)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 480, 190, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 380, 215, 75, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("15 for 1", 381, 235, 73, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(405, 220, 6)
SmallDice(420, 220, 5)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 380, 250, 75, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 455, 215, 75, 40, $SS_BLACKFRAME)
GUICtrlCreateLabel("15 for 1", 456, 235, 73, 18, $SS_CENTER)
GUICtrlSetFont(-1, 8, 400)
SmallDice(480, 220, 6)
SmallDice(495, 220, 5)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 455, 250, 75, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")
GUICtrlCreateLabel("", 380, 275, 110, 20, $SS_BLACKFRAME)
GUICtrlCreateLabel("8 for 1", 382, 283, 28, 10, $SS_CENTER)
GUICtrlSetFont(-1, 6, 400)
GUICtrlCreateLabel("Any Craps", 399, 276, 70, 10, $SS_CENTER)
GUICtrlSetFont(-1, 7, 800, 2)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlCreateLabel("8 for 1", 458, 283, 28, 10, $SS_CENTER)
GUICtrlSetFont(-1, 6, 400)
$BetCounter += 1
$inputBet[$BetCounter] = GUICtrlCreateCombo("", 490, 275, 40, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent($inputBet[$BetCounter], "PlayerBet")

GUICtrlCreateLabel("Money:", 380, 310, 40, 20)
$labelPlayerMoney = GUICtrlCreateLabel("0", 460, 310, 50, 20)
$btnAdd100 = GUICtrlCreateButton("Buy 100", 380, 370, 70, 20)
GUICtrlSetOnEvent($btnAdd100, "Buy100")

GUICtrlCreateLabel("House:", 380, 340)
$labelHouseMoney = GUICtrlCreateLabel("0", 460, 340, 50, 20)


$btnRollDice = GUICtrlCreateButton("RollDice", 270, 320, 70, 20)
GUICtrlSetOnEvent($btnRollDice, "RollDice")
$labelMessage = GUICtrlCreateLabel("", 270, 270, 70, 40, $ES_CENTER)
GUICtrlSetFont(-1, 12, 800)

Local $a_PartsRightEdge[3] = [200, 400, -1]
$StatusBar1 = _GUICtrlStatusBarCreate($GUImain, $a_PartsRightEdge, "")
_GUICtrlStatusBarSetText($StatusBar1, "Come-Out Roll", 0)

;odds
GUICtrlCreateLabel("", 10, 230, 200, 20, $SS_BLACKFRAME)
GUICtrlCreateLabel("Odds", 11, 231, 198, 18, $SS_CENTER)
GUICtrlSetFont(-1, 10, 800)
$j = 0
For $i = 0 To 150 Step 50
	$j += 1
	GUICtrlCreateLabel("", 10 + $i, 250, 50, 40, $SS_BLACKFRAME)
Next
GUICtrlCreateLabel("Pass", 11, 251, 48, 38, $SS_CENTER)
GUICtrlSetFont(-1, 10, 800)
GUICtrlCreateLabel("Don't Pass", 61, 251, 48, 38, $SS_CENTER)
GUICtrlSetFont(-1, 10, 800)
GUICtrlCreateLabel("Come", 111, 251, 48, 38, $SS_CENTER)
GUICtrlSetFont(-1, 10, 800)
GUICtrlCreateLabel("Don't Come", 161, 251, 48, 38, $SS_CENTER)
GUICtrlSetFont(-1, 10, 800)
$j = 0
For $i = 0 To 150 Step 50
	$j += 1
	GUICtrlCreateLabel("", 10 + $i, 290, 50, 20, $SS_BLACKFRAME)
	$labelOddsPoint[$j] = GUICtrlCreateLabel("", 11 + $i, 291, 48, 18, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 800)
Next
$OddsBetPass = GUICtrlCreateCombo("", 10, 310, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetState(-1, $GUI_DISABLE)
$OddsBetDontPass = GUICtrlCreateCombo("", 60, 310, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetState(-1, $GUI_DISABLE)
$OddsBetCome = GUICtrlCreateCombo("", 110, 310, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetState(-1, $GUI_DISABLE)
$OddsBetDontCome = GUICtrlCreateCombo("", 160, 310, 50, 20, $CBS_DROPDOWNLIST)
GUICtrlSetState(-1, $GUI_DISABLE)

;dice
$x = 260
$y = 230
$GraphicDice1 = GUICtrlCreateGraphic($x, $y, 40, 40)
GUICtrlSetBkColor($GraphicDice1, 0xffffff)
$GraphicDice2 = GUICtrlCreateGraphic($x + 50, $y, 40, 40)
GUICtrlSetBkColor($GraphicDice2, 0xffffff)
Local $rRect
$rRect = _DllStructCreate($RECT)
_DllStructSetData($rRect, $RECT_TOP, $y)
_DllStructSetData($rRect, $RECT_LEFT, $x)
_DllStructSetData($rRect, $RECT_BOTTOM, $y + 45)
_DllStructSetData($rRect, $RECT_RIGHT, $x + 100)
Dice(1, 4)
Dice(2, 3)

$editConsole = GUICtrlCreateEdit("", 550, 10, 240, 370)
#endregion --- GUI ---

BuildBetValues()

GUISetState(@SW_SHOW, $GUImain)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseClicked")
While 1
	Sleep(200)
WEnd

Func RollDice()
	$ret = ""
	For $x = 1 To 50 Step GUICtrlRead($aOptions[3][2])
		Sleep($x)
		$Dice1Value = Random(1, 6, 1)
		$Dice2Value = Random(1, 6, 1)
		Dice(1, $Dice1Value)
		Dice(2, $Dice2Value)
		_InvalidateRect($GUImain, $rRect, True)
	Next
	RollName()
	
	_GUICtrlStatusBarSetText($StatusBar1, "", 1)
	_GUICtrlStatusBarSetText($StatusBar1, "", 2)
	
	$Dice = $Dice1Value & $Dice2Value
	$DiceTotal = $Dice1Value + $Dice2Value
	
	$ConsoleText = "Dice Roll: " & $Dice & @CRLF & $ConsoleText
	GUICtrlSetData($editConsole, $ConsoleText)

	;disable odds
	GUICtrlSetState($OddsBetPass, $GUI_DISABLE)
	GUICtrlSetState($OddsBetDontPass, $GUI_DISABLE)
	GUICtrlSetState($OddsBetCome, $GUI_DISABLE)
	GUICtrlSetState($OddsBetDontCome, $GUI_DISABLE)
	If $PassStatus = 0 Then
		Switch $Dice
			Case 16, 25, 34, 43, 52, 61, 56, 65
				$PassStatus = 0
				$PointNeeded = 0
				_GUICtrlStatusBarSetText($StatusBar1, "Come-Out Roll", 0)
				_GUICtrlStatusBarSetText($StatusBar1, "Come-Out Winner", 1)
				If GUICtrlRead($inputBet[12]) >= 1 Then
					PayBets($inputBet[12], $aGrid1[2][2], "WIN Pass Line:", 1, 0)
				EndIf
				If GUICtrlRead($inputBet[11]) >= 1 Then	;don't pass LOSER
					PayBets($inputBet[11], $aGrid1[6][2], "LOSE Don't Pass Line:", 5, 1, 0)
				EndIf
			Case 11, 12, 21, 66
				$PassStatus = 0
				$PointNeeded = 0
				_GUICtrlStatusBarSetText($StatusBar1, "Come-Out Roll", 0)
				_GUICtrlStatusBarSetText($StatusBar1, "Come-Out Loser", 1)
				If GUICtrlRead($inputBet[12]) >= 1 Then
					PayBets($inputBet[12], $aGrid1[2][2], "LOSE Pass Line:", 1, 1, 0)
				EndIf
				If GUICtrlRead($inputBet[11]) >= 1 Then	;don't pass WIN or PUSH
					If $Dice <> 66 Then
						PayBets($inputBet[11], $aGrid1[6][2], "WIN Don't Pass Line:", 5, 0)
					EndIf
				EndIf
			Case Else
;~ 				GUICtrlSetState($inputBet[7], $GUI_ENABLE)
;~ 				GUICtrlSetState($inputBet[8], $GUI_ENABLE)
				$PassStatus = 1
				$PointNeeded = $Dice1Value + $Dice2Value
				Switch $PointNeeded
					Case 4
						GUICtrlSetData($labelPointMarker[1], "On")
					Case 5
						GUICtrlSetData($labelPointMarker[2], "On")
					Case 6
						GUICtrlSetData($labelPointMarker[3], "On")
					Case 8
						GUICtrlSetData($labelPointMarker[4], "On")
					Case 9
						GUICtrlSetData($labelPointMarker[5], "On")
					Case 10
						GUICtrlSetData($labelPointMarker[6], "On")
				EndSwitch
				GUICtrlSetState($inputBet[11], $GUI_DISABLE)
				GUICtrlSetState($inputBet[12], $GUI_DISABLE)
				;odds - set point display and enable odds betting
				Switch $PointNeeded
					Case 4, 10
						If GUICtrlRead($inputBet[11]) >= 1 Then	;don't pass
							GUICtrlSetData($labelOddsPoint[2], $PointNeeded)
							GUICtrlSetState($OddsBetDontPass, $GUI_ENABLE)
							$array = StringSplit(GUICtrlRead($aGrid1[7][2]), ":")
							For $i = 1 To GUICtrlRead($aOptions[2][2])
								$ret = $ret & $array[2] * $i & "|"
							Next
							GUICtrlSetData($OddsBetDontPass, $ret)
							$ret = ""
						Else
							GUICtrlSetData($labelOddsPoint[2], "")
						EndIf
						If GUICtrlRead($inputBet[12]) >= 1 Then ;pass
							GUICtrlSetData($labelOddsPoint[1], $PointNeeded)
							GUICtrlSetState($OddsBetPass, $GUI_ENABLE)
							$array = StringSplit(GUICtrlRead($aGrid1[3][2]), ":")
							For $i = 1 To GUICtrlRead($aOptions[2][2])
								$ret = $ret & $array[2] * $i & "|"
							Next
							GUICtrlSetData($OddsBetPass, $ret)
							$ret = ""
						Else
							GUICtrlSetData($labelOddsPoint[1], "")
						EndIf
					Case 5, 9
						If GUICtrlRead($inputBet[11]) >= 1 Then	;don't pass
							GUICtrlSetData($labelOddsPoint[2], $PointNeeded)
							GUICtrlSetState($OddsBetDontPass, $GUI_ENABLE)
							$array = StringSplit(GUICtrlRead($aGrid1[8][2]), ":")
							For $i = 1 To GUICtrlRead($aOptions[2][2])
								$ret = $ret & $array[2] * $i & "|"
							Next
							GUICtrlSetData($OddsBetDontPass, $ret)
							$ret = ""
						Else
							GUICtrlSetData($labelOddsPoint[2], "")
						EndIf
						If GUICtrlRead($inputBet[12]) >= 1 Then ;pass
							GUICtrlSetData($labelOddsPoint[1], $PointNeeded)
							GUICtrlSetState($OddsBetPass, $GUI_ENABLE)
							$array = StringSplit(GUICtrlRead($aGrid1[4][2]), ":")
							For $i = 1 To GUICtrlRead($aOptions[2][2])
								$ret = $ret & $array[2] * $i & "|"
							Next
							GUICtrlSetData($OddsBetPass, $ret)
							$ret = ""
						Else
							GUICtrlSetData($labelOddsPoint[1], "")
						EndIf
					Case 6, 8
						If GUICtrlRead($inputBet[11]) >= 1 Then	;don't pass
							GUICtrlSetData($labelOddsPoint[2], $PointNeeded)
							GUICtrlSetState($OddsBetDontPass, $GUI_ENABLE)
							$array = StringSplit(GUICtrlRead($aGrid1[9][2]), ":")
							For $i = 1 To GUICtrlRead($aOptions[2][2])
								$ret = $ret & $array[2] * $i & "|"
							Next
							GUICtrlSetData($OddsBetDontPass, $ret)
							$ret = ""
						Else
							GUICtrlSetData($labelOddsPoint[2], "")
						EndIf
						If GUICtrlRead($inputBet[12]) >= 1 Then ;pass
							GUICtrlSetData($labelOddsPoint[1], $PointNeeded)
							GUICtrlSetState($OddsBetPass, $GUI_ENABLE)
							$array = StringSplit(GUICtrlRead($aGrid1[5][2]), ":")
							For $i = 1 To GUICtrlRead($aOptions[2][2])
								$ret = $ret & $array[2] * $i & "|"
							Next
							GUICtrlSetData($OddsBetPass, $ret)
							$ret = ""
						Else
							GUICtrlSetData($labelOddsPoint[1], "")
						EndIf
				EndSwitch
				$ConsoleText = "Pass Point: " & $PointNeeded & @CRLF & $ConsoleText
				GUICtrlSetData($editConsole, $ConsoleText)
				_GUICtrlStatusBarSetText($StatusBar1, "Point: " & $PointNeeded, 0)
				_GUICtrlStatusBarSetText($StatusBar1, "", 1)
		EndSwitch
	Else
		;Come Point
		If $ComeStatus = 0 Then
			
			If GUICtrlRead($inputBet[7]) + GUICtrlRead($inputBet[8]) >= 1 Then 	;come or don't come bet placed
				Switch $Dice
					Case 16, 25, 34, 43, 52, 61, 56, 65
						$ComeStatus = 0
						_GUICtrlStatusBarSetText($StatusBar1, "Come Winner", 2)
						GUICtrlSetState($inputBet[8], $GUI_ENABLE)
						If GUICtrlRead($inputBet[8]) >= 1 Then
							PayBets($inputBet[8], $aGrid2[2][2], "WIN Come Line:", 9, 0)
						EndIf
						If GUICtrlRead($inputBet[7]) >= 1 Then
							PayBets($inputBet[7], $aGrid2[6][2], "LOSE Don't Come Line:", 13, 1, 0)
						EndIf
					Case 11, 12, 21, 66
						$ComeStatus = 0
						_GUICtrlStatusBarSetText($StatusBar1, "Come Loser", 2)
						If GUICtrlRead($inputBet[8]) >= 1 Then
							PayBets($inputBet[8], $aGrid2[2][2], "LOSE Come Line:", 9, 1, 0)
						EndIf
						If GUICtrlRead($inputBet[7]) >= 1 Then	;don't come WIN or PUSH
							If $Dice <> 66 Then
								PayBets($inputBet[7], $aGrid2[6][2], "WIN Don't Come Line:", 13, 0)
							EndIf
						EndIf
					Case Else
						$ComeStatus = 1
						GUICtrlSetState($inputBet[7], $GUI_DISABLE)
						GUICtrlSetState($inputBet[8], $GUI_DISABLE)
						$ComePointNeeded = $Dice1Value + $Dice2Value
						Switch $ComePointNeeded
							Case 4
								GUICtrlSetData($labelComeMarker[1], "On")
							Case 5
								GUICtrlSetData($labelComeMarker[2], "On")
							Case 6
								GUICtrlSetData($labelComeMarker[3], "On")
							Case 8
								GUICtrlSetData($labelComeMarker[4], "On")
							Case 9
								GUICtrlSetData($labelComeMarker[5], "On")
							Case 10
								GUICtrlSetData($labelComeMarker[6], "On")
						EndSwitch
						
						Switch $ComePointNeeded	;odds for come and don't come
							Case 4, 10
								If GUICtrlRead($inputBet[7]) >= 1 Then	;don't come
									GUICtrlSetData($labelOddsPoint[4], $ComePointNeeded)
									GUICtrlSetState($OddsBetDontCome, $GUI_ENABLE)
									$array = StringSplit(GUICtrlRead($aGrid2[7][2]), ":")
									For $i = 1 To GUICtrlRead($aOptions[2][2])
										$ret = $ret & $array[2] * $i & "|"
									Next
									GUICtrlSetData($OddsBetDontCome, $ret)
									$ret = ""
								Else
									GUICtrlSetData($labelOddsPoint[4], "")
								EndIf
								If GUICtrlRead($inputBet[8]) >= 1 Then ;come
									GUICtrlSetData($labelOddsPoint[3], $ComePointNeeded)
									GUICtrlSetState($OddsBetCome, $GUI_ENABLE)
									$array = StringSplit(GUICtrlRead($aGrid2[3][2]), ":")
									For $i = 1 To GUICtrlRead($aOptions[2][2])
										$ret = $ret & $array[2] * $i & "|"
									Next
									GUICtrlSetData($OddsBetCome, $ret)
									$ret = ""
								Else
									GUICtrlSetData($labelOddsPoint[3], "")
								EndIf
							Case 5, 9
								If GUICtrlRead($inputBet[7]) >= 1 Then	;don't come
									GUICtrlSetData($labelOddsPoint[4], $ComePointNeeded)
									GUICtrlSetState($OddsBetDontCome, $GUI_ENABLE)
									$array = StringSplit(GUICtrlRead($aGrid2[8][2]), ":")
									For $i = 1 To GUICtrlRead($aOptions[2][2])
										$ret = $ret & $array[2] * $i & "|"
									Next
									GUICtrlSetData($OddsBetDontCome, $ret)
									$ret = ""
								Else
									GUICtrlSetData($labelOddsPoint[4], "")
								EndIf
								If GUICtrlRead($inputBet[8]) >= 1 Then ;come
									GUICtrlSetData($labelOddsPoint[3], $ComePointNeeded)
									GUICtrlSetState($OddsBetCome, $GUI_ENABLE)
									$array = StringSplit(GUICtrlRead($aGrid2[4][2]), ":")
									For $i = 1 To GUICtrlRead($aOptions[2][2])
										$ret = $ret & $array[2] * $i & "|"
									Next
									GUICtrlSetData($OddsBetCome, $ret)
									$ret = ""
								Else
									GUICtrlSetData($labelOddsPoint[3], "")
								EndIf
							Case 6, 8
								If GUICtrlRead($inputBet[7]) >= 1 Then	;don't come
									GUICtrlSetData($labelOddsPoint[4], $ComePointNeeded)
									GUICtrlSetState($OddsBetDontCome, $GUI_ENABLE)
									$array = StringSplit(GUICtrlRead($aGrid2[9][2]), ":")
									For $i = 1 To GUICtrlRead($aOptions[2][2])
										$ret = $ret & $array[2] * $i & "|"
									Next
									GUICtrlSetData($OddsBetDontCome, $ret)
									$ret = ""
								Else
									GUICtrlSetData($labelOddsPoint[4], "")
								EndIf
								If GUICtrlRead($inputBet[8]) >= 1 Then ;come
									GUICtrlSetData($labelOddsPoint[3], $ComePointNeeded)
									GUICtrlSetState($OddsBetCome, $GUI_ENABLE)
									$array = StringSplit(GUICtrlRead($aGrid2[5][2]), ":")
									For $i = 1 To GUICtrlRead($aOptions[2][2])
										$ret = $ret & $array[2] * $i & "|"
									Next
									GUICtrlSetData($OddsBetCome, $ret)
									$ret = ""
								Else
									GUICtrlSetData($labelOddsPoint[3], "")
								EndIf
						EndSwitch
						$ConsoleText = "Come Point: " & $ComePointNeeded & @CRLF & $ConsoleText
						GUICtrlSetData($editConsole, $ConsoleText)
				EndSwitch
			EndIf
		EndIf
;~ 		$i = 0
		Switch $DiceTotal 	;pay bets Pass and Don't Pass
			Case 7, 11
				_GUICtrlStatusBarSetText($StatusBar1, "Come-Out Roll", 0)
				_GUICtrlStatusBarSetText($StatusBar1, "Point: Loser", 1)
				GUICtrlSetState($inputBet[11], $GUI_ENABLE)
				GUICtrlSetState($inputBet[12], $GUI_ENABLE)
				If GUICtrlRead($inputBet[12]) >= 1 Then
					PayBets($inputBet[12], $aGrid1[2][2], "LOSE Pass Line Point:", 1, 1, 0)
				EndIf
				If GUICtrlRead($OddsBetPass) <> "" Then	;pass
					Switch $PointNeeded
						Case 4, 10
							PayBets($OddsBetPass, $aGrid1[2][2], "LOSE Pass Line Odds 4&10:", 2, 0, 0)
						Case 5, 9
							PayBets($OddsBetPass, $aGrid1[2][2], "LOSE Pass Line Odds 5&9:", 3, 0, 0)
						Case 6, 8
							PayBets($OddsBetPass, $aGrid1[2][2], "LOSE Pass Line Odds 6&8:", 4, 0, 0)
					EndSwitch
				EndIf
				If $DiceTotal = 7 Then
					If GUICtrlRead($inputBet[11]) >= 1 Then
						PayBets($inputBet[11], $aGrid1[6][2], "WIN Don't Pass Line Point:", 5, 1)
					EndIf
					If GUICtrlRead($OddsBetDontPass) <> "" Then	;don't pass
						Switch $PointNeeded
							Case 4, 10
								PayBets($OddsBetDontPass, $aGrid1[2][2], "WIN Don't Pass Line Odds 4&10:", 6, 0)
							Case 5, 9
								PayBets($OddsBetDontPass, $aGrid1[2][2], "WIN Don't Pass Line Odds 5&9:", 7, 0)
							Case 6, 8
								PayBets($OddsBetDontPass, $aGrid1[2][2], "WIN Don't Pass Line Odds 6&8:", 8, 0)
						EndSwitch
					EndIf
				EndIf
				$PassStatus = 0
				$PointNeeded = 0
				GUICtrlSetData($OddsBetPass, "")
				GUICtrlSetData($OddsBetDontPass, "")
				GUICtrlSetData($labelOddsPoint[1], "")
				GUICtrlSetData($labelOddsPoint[2], "")
				For $i = 1 To 6
					GUICtrlSetData($labelPointMarker[$i], "")
				Next
			Case $PointNeeded
				_GUICtrlStatusBarSetText($StatusBar1, "Come-Out Roll", 0)
				_GUICtrlStatusBarSetText($StatusBar1, "Point: Winner", 1)
				If GUICtrlRead($inputBet[12]) >= 1 Then
					GUICtrlSetState($inputBet[12], $GUI_ENABLE)
					PayBets($inputBet[12], $aGrid1[2][2], "WIN Pass Line Point:", 1, 0)
				EndIf
				If GUICtrlRead($inputBet[11]) >= 1 Then
					GUICtrlSetState($inputBet[11], $GUI_ENABLE)
					PayBets($inputBet[11], $aGrid1[6][2], "LOSE Don't Pass Line Point:", 5, 1, 0)
				EndIf
				Switch $PointNeeded
					Case 4, 10
						If GUICtrlRead($OddsBetPass) >= 1 Then	;pass
							PayBets($OddsBetPass, $aGrid1[3][2], "WIN Pass Line Odds 4&10:", 2, 1)
						EndIf
						If GUICtrlRead($OddsBetDontPass) >= 1 Then	;don't pass
							PayBets($OddsBetDontPass, $aGrid1[7][2], "LOSE Don't Pass Line Odds 4&10:", 62, 1, 0)
						EndIf
					Case 5, 9
						If GUICtrlRead($OddsBetPass) >= 1 Then	;pass
							PayBets($OddsBetPass, $aGrid1[4][2], "WIN Pass Line Odds 5&9:", 3, 1)
						EndIf
						If GUICtrlRead($OddsBetDontPass) >= 1 Then	;don't pass
							PayBets($OddsBetDontPass, $aGrid1[8][2], "LOSE Don't Pass Line Odds 5&9:", 7, 1, 0)
						EndIf
					Case 6, 8
						If GUICtrlRead($OddsBetPass) >= 1 Then	;pass
							PayBets($OddsBetPass, $aGrid1[5][2], "WIN Pass Line Odds 6&8:", 4, 1)
						EndIf
						If GUICtrlRead($OddsBetDontPass) >= 1 Then	;don't pass
							PayBets($OddsBetDontPass, $aGrid1[9][2], "LOSE Don't Pass Line Odds 6&8:", 8, 1, 0)
						EndIf
				EndSwitch
				GUICtrlSetData($OddsBetPass, "")
				GUICtrlSetData($OddsBetDontPass, "")
				GUICtrlSetData($labelOddsPoint[1], "")
				GUICtrlSetData($labelOddsPoint[2], "")
				GUICtrlSetState($inputBet[11], $GUI_ENABLE)
				GUICtrlSetState($inputBet[12], $GUI_ENABLE)
				For $i = 1 To 6
					GUICtrlSetData($labelPointMarker[$i], "")
				Next
				$PassStatus = 0
				$PointNeeded = 0
		EndSwitch
	EndIf
;~ 	ConsoleWrite("$ComeStatus: " & $ComeStatus & @CRLF)
;~ 	ConsoleWrite("$ComePointNeeded: " & $ComePointNeeded & @CRLF)
	;pay Come rolls
	If $ComeStatus = 2 Then
		Switch $DiceTotal
			Case 7, 11
				$ComeStatus = 0
				If GUICtrlRead($inputBet[8]) >= 1 Then
					GUICtrlSetState($inputBet[8], $GUI_ENABLE)
					PayBets($inputBet[8], $aGrid2[2][2], "LOSE Come Line Point:", 9, 1, 0)
				EndIf
				If GUICtrlRead($OddsBetCome) <> "" Then	;come
					Switch $ComePointNeeded
						Case 4, 10
							PayBets($OddsBetCome, $aGrid2[2][2], "LOSE Come Line Odds 4&10:", 10, 0, 0)
						Case 5, 9
							PayBets($OddsBetCome, $aGrid2[2][2], "LOSE Come Line Odds 5&9:", 11, 0, 0)
						Case 6, 8
							PayBets($OddsBetCome, $aGrid2[2][2], "LOSE Come Line Odds 6&8:", 12, 0, 0)
					EndSwitch
				EndIf
				If $DiceTotal = 7 Then
					If GUICtrlRead($inputBet[7]) >= 1 Then
						PayBets($inputBet[7], $aGrid2[6][2], "WIN Don't Come Line Point:", 13, 1)
					EndIf
					If GUICtrlRead($OddsBetDontCome) <> "" Then	;don't come
						Switch $ComePointNeeded
							Case 4, 10
								PayBets($OddsBetDontCome, $aGrid2[2][2], "WIN Don't Come Line Odds 4&10:", 14, 0)
							Case 5, 9
								PayBets($OddsBetDontCome, $aGrid2[2][2], "WIN Don't Come Line Odds 5&9:", 15, 0)
							Case 6, 8
								PayBets($OddsBetDontCome, $aGrid2[2][2], "WIN Don't Come Line Odds 6&8:", 16, 0)
						EndSwitch
					EndIf
				EndIf
				GUICtrlSetData($OddsBetCome, "")
				GUICtrlSetData($OddsBetDontCome, "")
				GUICtrlSetData($labelOddsPoint[3], "")
				GUICtrlSetData($labelOddsPoint[4], "")
				For $i = 1 To 6
					GUICtrlSetData($labelComeMarker[$i], "")
				Next
			Case $ComePointNeeded
				If GUICtrlRead($inputBet[8]) >= 1 Then
					PayBets($inputBet[8], $aGrid2[2][2], "WIN Come Line Point:", 9, 0)
				EndIf
				If GUICtrlRead($inputBet[7]) >= 1 Then
					PayBets($inputBet[7], $aGrid2[6][2], "LOSE Don't Come Line Point:", 13, 1, 0)
				EndIf
				Switch $ComePointNeeded
					Case 4, 10
						If GUICtrlRead($OddsBetCome) >= 1 Then	;come
							PayBets($OddsBetCome, $aGrid2[3][2], "WIN Come Line Odds 4&10:", 10, 1)
						EndIf
						If GUICtrlRead($OddsBetDontCome) >= 1 Then	;don't come
							PayBets($OddsBetDontCome, $aGrid2[7][2], "LOSE Don't Come Line Odds 4&10:", 14, 1, 0)
						EndIf
					Case 5, 9
						If GUICtrlRead($OddsBetCome) >= 1 Then	;pass
							PayBets($OddsBetCome, $aGrid2[4][2], "WIN Come Line Odds 5&9:", 11, 1)
						EndIf
						If GUICtrlRead($OddsBetDontCome) >= 1 Then	;don't pass
							PayBets($OddsBetDontCome, $aGrid2[8][2], "LOSE Don't Come Line Odds 5&9:", 15, 1, 0)
						EndIf
					Case 6, 8
						If GUICtrlRead($OddsBetCome) >= 1 Then	;pass
							PayBets($OddsBetCome, $aGrid2[5][2], "WIN Come Line Odds 6&8:", 12, 1)
						EndIf
						If GUICtrlRead($OddsBetDontCome) >= 1 Then	;don't pass
							PayBets($OddsBetDontCome, $aGrid2[9][2], "LOSE Don't Come Line Odds 6&8:", 16, 1, 0)
						EndIf
				EndSwitch
				$ComeStatus = 0
				$ComePointNeeded = 0
				GUICtrlSetData($OddsBetCome, "")
				GUICtrlSetData($OddsBetDontCome, "")
				GUICtrlSetData($labelOddsPoint[3], "")
				GUICtrlSetData($labelOddsPoint[4], "")
				For $i = 1 To 6
					GUICtrlSetData($labelComeMarker[$i], "")
				Next
		EndSwitch
	EndIf
	If $ComeStatus = 1 Then 	;used to bypass paying come point payout during the 1st time through
		$ComeStatus = 2
	EndIf
;~ 	ConsoleWrite("$PassStatus: " & $PassStatus & @CRLF)
;~ 	ConsoleWrite("$ComeStatus: " & $ComeStatus & @CRLF)
	;enable/disable come line bets based on if pass point is set
	If $PassStatus = 1 Then
		If $ComeStatus = 0 Then
			GUICtrlSetState($inputBet[7], $GUI_ENABLE)
			GUICtrlSetState($inputBet[8], $GUI_ENABLE)
		EndIf
	Else
		GUICtrlSetState($inputBet[7], $GUI_DISABLE)
		GUICtrlSetState($inputBet[8], $GUI_DISABLE)
	EndIf

	;pay one time bets
	If GUICtrlRead($inputBet[1]) > 0 Then	;place 4
		Switch $DiceTotal
			Case 4
				PayBets($inputBet[1], $aGrid2[10][2], "WIN Place 4:", 17, 1)
			Case 7
				PayBets($inputBet[1], $aGrid2[10][2], "LOSE Place 4:", 17, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[2]) > 0 Then	;place 5
		Switch $DiceTotal
			Case 5
				PayBets($inputBet[2], $aGrid2[11][2], "WIN Place 5:", 18, 1)
			Case 7
				PayBets($inputBet[2], $aGrid2[11][2], "LOSE Place 5:", 18, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[3]) > 0 Then	;place 6
		Switch $DiceTotal
			Case 6
				PayBets($inputBet[3], $aGrid2[12][2], "WIN Place 6:", 19, 1)
			Case 7
				PayBets($inputBet[3], $aGrid2[12][2], "LOSE Place 6:", 19, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[4]) > 0 Then	;place 8
		Switch $DiceTotal
			Case 4
				PayBets($inputBet[4], $aGrid2[12][2], "WIN Place 8:", 19, 1)
			Case 7
				PayBets($inputBet[4], $aGrid2[12][2], "LOSE Place 8:", 19, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[5]) > 0 Then	;place 9
		Switch $DiceTotal
			Case 5
				PayBets($inputBet[5], $aGrid2[11][2], "WIN Place 9:", 18, 1)
			Case 7
				PayBets($inputBet[5], $aGrid2[11][2], "LOSE Place 9:", 18, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[3]) > 0 Then	;place 10
		Switch $DiceTotal
			Case 6
				PayBets($inputBet[6], $aGrid2[10][2], "WIN Place 10:", 17, 1)
			Case 7
				PayBets($inputBet[6], $aGrid2[10][2], "LOSE Place 10:", 17, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[9]) > 0 Then	;field
		Switch $DiceTotal
			Case 2, 12 	;pays double here
				PayBets($inputBet[9], $aGrid3[10][2], "WIN Field:", 31, 1)
			Case 3, 4, 9, 10, 11
				PayBets($inputBet[9], $aGrid3[9][2], "WIN Field:", 30, 1)
			Case 5, 6, 7, 8
				PayBets($inputBet[9], $aGrid3[9][2], "LOSE Field:", 30, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[10]) > 0 Then	;Big 6/8
		Switch $DiceTotal
			Case 6, 8
				PayBets($inputBet[10], $aGrid3[8][2], "WIN Big 6/8:", 29, 1)
			Case 7
				PayBets($inputBet[10], $aGrid3[8][2], "LOSE Big 6/8:", 29, 1, 0)
		EndSwitch
	EndIf

	If GUICtrlRead($inputBet[13]) > 0 Then	;any 7
		Switch $DiceTotal
			Case 7
				PayBets($inputBet[13], $aGrid3[11][2], "WIN Any Seven:", 32, 1)
			Case Else
				PayBets($inputBet[13], $aGrid3[11][2], "LOSE Any Seven:", 32, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[14]) > 0 Then	;Hard 6
		Switch $Dice
			Case 33
				PayBets($inputBet[14], $aGrid3[18][2], "WIN Hard 6:", 39, 1)
			Case 15, 51, 24, 42, 16, 25, 34, 43, 52, 61
				PayBets($inputBet[14], $aGrid3[18][2], "LOSE Hard 6:", 39, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[15]) > 0 Then	;Hard 10
		Switch $Dice
			Case 55
				PayBets($inputBet[15], $aGrid3[20][2], "WIN Hard 10:", 41, 1)
			Case 14, 23, 32, 51, 16, 25, 34, 43, 52, 61
				PayBets($inputBet[15], $aGrid3[20][2], "LOSE Hard 10:", 41, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[16]) > 0 Then	;Hard 8
		Switch $Dice
			Case 44
				PayBets($inputBet[16], $aGrid3[19][2], "WIN Hard 8:", 40, 1)
			Case 26, 35, 53, 62, 16, 25, 34, 43, 52, 61
				PayBets($inputBet[16], $aGrid3[19][2], "LOSE Hard 8:", 40, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[17]) > 0 Then	;Hard 4
		Switch $Dice
			Case 22
				PayBets($inputBet[17], $aGrid3[17][2], "WIN Hard 4:", 38, 1)
			Case 13, 31, 16, 25, 34, 43, 52, 61
				PayBets($inputBet[17], $aGrid3[17][2], "LOSE Hard 4:", 38, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[18]) > 0 Then	;Horn 3
		Switch $Dice
			Case 12, 21
				PayBets($inputBet[18], $aGrid3[16][2], "WIN Horn 3:", 37, 1)
			Case Else
				PayBets($inputBet[18], $aGrid3[16][2], "LOSE Horn 3:", 37, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[19]) > 0 Then	;Horn 2
		Switch $Dice
			Case 11
				PayBets($inputBet[19], $aGrid3[14][2], "WIN Horn 2:", 35, 1)
			Case Else
				PayBets($inputBet[19], $aGrid3[14][2], "LOSE Horn 2:", 35, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[20]) > 0 Then	;Horn 12
		Switch $Dice
			Case 66
				PayBets($inputBet[20], $aGrid3[13][2], "WIN Horn 12:", 34, 1)
			Case Else
				PayBets($inputBet[20], $aGrid3[13][2], "LOSE Horn 12:", 34, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[21]) > 0 Then	;Horn 11
		Switch $Dice
			Case 56, 65
				PayBets($inputBet[21], $aGrid3[15][2], "WIN Horn 11:", 36, 1)
			Case Else
				PayBets($inputBet[21], $aGrid3[15][2], "LOSE Horn 11:", 36, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[22]) > 0 Then	;Horn 11
		Switch $Dice
			Case 56, 65
				PayBets($inputBet[22], $aGrid3[15][2], "WIN Horn 11:", 36, 1)
			Case Else
				PayBets($inputBet[22], $aGrid3[15][2], "LOSE Horn 11:", 36, 1, 0)
		EndSwitch
	EndIf
	If GUICtrlRead($inputBet[23]) > 0 Then	;any craps
		Switch $DiceTotal
			Case 2, 3, 12
				PayBets($inputBet[23], $aGrid3[12][2], "WIN Any Craps:", 33, 1)
			Case Else
				PayBets($inputBet[23], $aGrid3[12][2], "LOSE Any Craps:", 33, 1, 0)
		EndSwitch
	EndIf
	$ConsoleText = "-----------------------------" & @CRLF & $ConsoleText
	GUICtrlSetData($editConsole, $ConsoleText)
EndFunc   ;==>RollDice
Func PayBets($inputBetControl, $Odds, $text, $HouseHistory, $ClearBet = 1, $Win = 1)
	$font = "Courier New"
	If $Win = 1 Then
		$bet = GUICtrlRead($inputBetControl)
		$array = StringSplit(GUICtrlRead($Odds), ":")
		$ret = $bet / $array[2]
		$pay = $ret * $array[1]
		$ret = GUICtrlRead($labelPlayerMoney)
		GUICtrlSetData($labelPlayerMoney, $ret + $pay)
		$ConsoleText = $text & " $" & $pay & @CRLF & $ConsoleText
		$ret = GUICtrlRead($labelHouseMoney)
		GUICtrlSetData($labelHouseMoney, $ret - $pay)
		$aHouseStats[$HouseHistory][1] = $aHouseStats[$HouseHistory][1] - $pay
		$aHouseStats[$HouseHistory][3] += 1
	Else
		$bet = GUICtrlRead($inputBetControl)
		$ret = GUICtrlRead($labelHouseMoney)
		GUICtrlSetData($labelHouseMoney, $ret + $bet)
		$bet = GUICtrlRead($inputBetControl)
		$ret = GUICtrlRead($labelPlayerMoney)
		GUICtrlSetData($labelPlayerMoney, $ret - $bet)
		If $ClearBet = 1 Then
			GUICtrlSetState($inputBetControl, $GUI_FOCUS)
			Send("0")
		EndIf
		$ConsoleText = $text & " $" & $bet & @CRLF & $ConsoleText
		$aHouseStats[$HouseHistory][1] = $aHouseStats[$HouseHistory][1] + $bet
		$aHouseStats[$HouseHistory][2] += 1
	EndIf
	GUICtrlSetFont($editConsole, 8, 400, 0, $font)
	GUICtrlSetColor($editConsole, 0x000000)
	GUICtrlSetData($editConsole, $ConsoleText)
EndFunc   ;==>PayBets
Func RollName()
	$Dice = $Dice1Value & $Dice2Value
	Switch $Dice
		Case 11
			GUICtrlSetData($labelMessage, $DiceRollNames[1])
			$DiceResults[1] += 1
		Case 12, 21
			GUICtrlSetData($labelMessage, $DiceRollNames[2])
			$DiceResults[2] += 1
		Case 22
			GUICtrlSetData($labelMessage, $DiceRollNames[3])
			$DiceResults[3] += 1
		Case 13, 31
			GUICtrlSetData($labelMessage, $DiceRollNames[4])
			$DiceResults[4] += 1
		Case 14, 23, 32, 41
			GUICtrlSetData($labelMessage, $DiceRollNames[5])
			$DiceResults[5] += 1
		Case 15, 24, 42, 51
			GUICtrlSetData($labelMessage, $DiceRollNames[6])
			$DiceResults[6] += 1
		Case 33
			GUICtrlSetData($labelMessage, $DiceRollNames[7])
			$DiceResults[7] += 1
		Case 16, 25, 34, 43, 52, 61
			GUICtrlSetData($labelMessage, $DiceRollNames[8])
			$DiceResults[8] += 1
		Case 26, 35, 53, 62
			GUICtrlSetData($labelMessage, $DiceRollNames[9])
			$DiceResults[9] += 1
		Case 44
			GUICtrlSetData($labelMessage, $DiceRollNames[10])
			$DiceResults[10] += 1
		Case 36, 45, 54, 63
			GUICtrlSetData($labelMessage, $DiceRollNames[11])
			$DiceResults[11] += 1
		Case 46, 64
			GUICtrlSetData($labelMessage, $DiceRollNames[12])
			$DiceResults[12] += 1
		Case 55
			GUICtrlSetData($labelMessage, $DiceRollNames[13])
			$DiceResults[13] += 1
		Case 56, 65
			GUICtrlSetData($labelMessage, $DiceRollNames[14])
			$DiceResults[14] += 1
		Case 66
			GUICtrlSetData($labelMessage, $DiceRollNames[15])
			$DiceResults[15] += 1
	EndSwitch
EndFunc   ;==>RollName
Func Dice($Dice, $Number)
	$dotsize = 4
	$dicecolor = GUICtrlRead($aOptions[5][2])
	;$dicecolor = 0xffffff
	$spotcolor = 0x000000
	If $Dice = 1 Then
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_COLOR, $dicecolor, $dicecolor)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 20, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 20, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice1, $GUI_GR_COLOR, $spotcolor, $spotcolor)
		Switch $Number
			Case 1
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
			Case 2
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
			Case 3
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
			Case 4
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
			Case 5
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
			Case 6
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice1, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
		EndSwitch
	EndIf
	If $Dice = 2 Then
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_COLOR, $dicecolor, $dicecolor)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 20, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 20, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
		GUICtrlSetGraphic($GraphicDice2, $GUI_GR_COLOR, $spotcolor, $spotcolor)
		Switch $Number
			Case 1
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
			Case 2
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
			Case 3
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
			Case 4
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
			Case 5
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 20, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
			Case 6
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 10, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 20, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 10, 30, $dotsize, 0, 360)
				GUICtrlSetGraphic($GraphicDice2, $GUI_GR_PIE, 30, 30, $dotsize, 0, 360)
		EndSwitch
	EndIf
EndFunc   ;==>Dice
Func SmallDice($left, $top, $Number)
	$smallGraphicDice = GUICtrlCreateGraphic($left, $top, 12, 12)
	GUICtrlSetBkColor($smallGraphicDice, 0x000000)
	$dotsize = 1
	$dicecolor = 0x000000
	$spotcolor = 0xffffff
	$left = 3
	$center = 6
	$right = 9
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_COLOR, $dicecolor, $dicecolor)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $left, $dotsize, 0, 360)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $left, $dotsize, 0, 360)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $center, $dotsize, 0, 360)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $center, $center, $dotsize, 0, 360)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $center, $dotsize, 0, 360)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $right, $dotsize, 0, 360)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $right, $dotsize, 0, 360)
	GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_COLOR, $spotcolor, $spotcolor)
	Switch $Number
		Case 1
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $center, $center, $dotsize, 0, 360)
		Case 2
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $right, $dotsize, 0, 360)
		Case 3
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $center, $center, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $right, $dotsize, 0, 360)
		Case 4
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $right, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $right, $dotsize, 0, 360)
		Case 5
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $center, $center, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $right, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $right, $dotsize, 0, 360)
		Case 6
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $left, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $center, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $center, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $left, $right, $dotsize, 0, 360)
			GUICtrlSetGraphic($smallGraphicDice, $GUI_GR_PIE, $right, $right, $dotsize, 0, 360)
	EndSwitch
EndFunc   ;==>SmallDice
Func UdfLabel($text, $left, $top, $width, $height, $fontsize, $fontweight)
	GUICtrlCreateLabel("", $left, $top, $width, $height, $SS_BLACKFRAME)
	GUICtrlCreateLabel($text, $left + 1, $top + 1, $width - 2, $height - 2, $SS_CENTER)
	GUICtrlSetFont(-1, $fontsize, $fontweight)
EndFunc   ;==>UdfLabel
Func OpenWiki()
	$link = "http://en.wikipedia.org/wiki/Craps"
	Run(@ComSpec & ' /c start ' & $link, '', @SW_HIDE)
EndFunc   ;==>OpenWiki
Func OpenAutoIt()
	$link = "http://www.autoitscript.com/"
	Run(@ComSpec & ' /c start ' & $link, '', @SW_HIDE)
EndFunc   ;==>OpenAutoIt
Func Buy100()
	$player = GUICtrlRead($labelPlayerMoney)
	$house = GUICtrlRead($labelHouseMoney)
	GUICtrlSetData($labelPlayerMoney, $player + 100)
	GUICtrlSetData($labelHouseMoney, $house - 100)
EndFunc   ;==>Buy100
Func _Grid($StartX, $StartY, $cellWidth, $cellHeight, $rows, $columns, $color = "")
	Local $tempX, $tempY
	Dim $Cell[$rows + 1][$columns + 1]
	$tempX += $StartX
	$tempY += $StartY
	For $i = 1 To $rows
		For $j = 1 To $columns
			If $cellWidth[$j] = "" Then
				$cellWidth[$j] = $cellWidth[$j - 1]
			EndIf
			If $cellHeight[$i] = "" Then
				$cellHeight[$i] = $cellHeight[$i - 1]
			EndIf
			$Cell[$i][$j] = GUICtrlCreateInput("", $tempX, $tempY, $cellWidth[$j], $cellHeight[$i])
			If $color > "" And $i = 1 Or $j = 1 Then
				GUICtrlSetBkColor($Cell[$i][$j], $color)
			Else
				GUICtrlSetBkColor($Cell[$i][$j], 0xffffff)
			EndIf
			$tempX += $cellWidth[$j]
		Next
		$tempX = $StartX
		$tempY += $cellHeight[$i]
	Next
	$Cell[0][0] = UBound($Cell) - 1
	Return $Cell
EndFunc   ;==>_Grid
Func GUIStats()
	GUIDelete($GUIStats)
	$GUIStats = GUICreate("AutoIt Craps Statistics", 855, 440, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SIZEBOX))

	$rows = 16
	$columns = 3
	Dim $aWidth[$columns + 1] = [0, 80, 40]
	Dim $aHeight[$rows + 1] = [0, 16]
	$aRollStats = _Grid(10, 10, $aWidth, $aHeight, $rows, $columns)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aRollStats[$i][$j], 1)
			GUICtrlSetFont($aRollStats[$i][$j], 8, 400)
			GUICtrlSetStyle($aRollStats[$i][$j], $WS_DISABLED)
			GUICtrlSetBkColor($aRollStats[$i][$j], 0xffffb3)
		Next
	Next
	For $i = 1 To $DiceRollNames[0] - 1
		GUICtrlSetData($aRollStats[$i][1], $DiceRollNames[$i])
	Next
	GUICtrlSetData($aRollStats[16][1], "TOTALS")
	
	$rows = 1
	$columns = 5
	Dim $aWidth[$columns + 1] = [0, 140, 50, 40]
	Dim $aHeight[$rows + 1] = [0, 16]
	$aHeading1 = _Grid(180, 10, $aWidth, $aHeight, $rows, $columns)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aHeading1[$i][$j], 1)
			GUICtrlSetFont($aHeading1[$i][$j], 8, 400)
			GUICtrlSetStyle($aHeading1[$i][$j], $WS_DISABLED)
			GUICtrlSetBkColor($aHeading1[$i][$j], 0xffffb3)
		Next
	Next
	GUICtrlSetData($aHeading1[1][1], "Name")
	GUICtrlSetData($aHeading1[1][2], "$$$")
	GUICtrlSetData($aHeading1[1][3], "Win")
	GUICtrlSetData($aHeading1[1][4], "Lose")
	GUICtrlSetData($aHeading1[1][5], "%%%")

	$rows = 9
	$columns = 5
	Dim $aWidth[$columns + 1] = [0, 140, 50, 40]
	Dim $aHeight[$rows + 1] = [0, 16]
	$aHouse1 = _Grid(180, 30, $aWidth, $aHeight, $rows, $columns)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aHouse1[$i][$j], 1)
			GUICtrlSetFont($aHouse1[$i][$j], 8, 400)
			GUICtrlSetStyle($aHouse1[$i][$j], $WS_DISABLED)
			GUICtrlSetBkColor($aHouse1[$i][$j], 0xffffb3)
		Next
	Next
	GUICtrlSetData($aHouse1[9][1], "TOTALS")

	$rows = 15
	$columns = 5
	Dim $aWidth[$columns + 1] = [0, 140, 50, 40]
	Dim $aHeight[$rows + 1] = [0, 16]
	$aHouse2 = _Grid(180, 185, $aWidth, $aHeight, $rows, $columns)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aHouse2[$i][$j], 1)
			GUICtrlSetFont($aHouse2[$i][$j], 8, 400)
			GUICtrlSetStyle($aHouse2[$i][$j], $WS_DISABLED)
			GUICtrlSetBkColor($aHouse2[$i][$j], 0xffffb3)
		Next
	Next
	GUICtrlSetData($aHouse2[15][1], "TOTALS")

	$rows = 1
	$columns = 5
	Dim $aWidth[$columns + 1] = [0, 140, 50, 40]
	Dim $aHeight[$rows + 1] = [0, 16]
	$aHeading1 = _Grid(500, 10, $aWidth, $aHeight, $rows, $columns)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aHeading1[$i][$j], 1)
			GUICtrlSetFont($aHeading1[$i][$j], 8, 400)
			GUICtrlSetStyle($aHeading1[$i][$j], $WS_DISABLED)
			GUICtrlSetBkColor($aHeading1[$i][$j], 0xffffb3)
		Next
	Next
	GUICtrlSetData($aHeading1[1][1], "Name")
	GUICtrlSetData($aHeading1[1][2], "$$$")
	GUICtrlSetData($aHeading1[1][3], "Win")
	GUICtrlSetData($aHeading1[1][4], "Lose")
	GUICtrlSetData($aHeading1[1][5], "%%%")

	$rows = 20
	$columns = 5
	Dim $aWidth[$columns + 1] = [0, 140, 50, 40]
	Dim $aHeight[$rows + 1] = [0, 16]
	$aHouse3 = _Grid(500, 30, $aWidth, $aHeight, $rows, $columns)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aHouse3[$i][$j], 1)
			GUICtrlSetFont($aHouse3[$i][$j], 8, 400)
			GUICtrlSetStyle($aHouse3[$i][$j], $WS_DISABLED)
			GUICtrlSetBkColor($aHouse3[$i][$j], 0xffffb3)
		Next
	Next
	GUICtrlSetData($aHouse3[20][1], "TOTALS")

	$rows = 1
	$columns = 5
	Dim $aWidth[$columns + 1] = [0, 140, 50, 40]
	Dim $aHeight[$rows + 1] = [0, 16]
	$aHouse4 = _Grid(500, 410, $aWidth, $aHeight, $rows, $columns)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aHouse4[$i][$j], 1)
			GUICtrlSetFont($aHouse4[$i][$j], 8, 400)
			GUICtrlSetStyle($aHouse4[$i][$j], $WS_DISABLED)
			GUICtrlSetBkColor($aHouse4[$i][$j], 0xffffb3)
		Next
	Next
	GUICtrlSetData($aHouse4[1][1], "GRAND TOTALS")

	GUISetState(@SW_HIDE, $GUIStats)
	GUISetOnEvent($GUI_EVENT_CLOSE, "HideStats")
	
EndFunc   ;==>GUIStats
Func RefreshStats()
	$DiceResultsTotal = 0
	$House1Total = 0
	$House2Total = 0
	$House3Total = 0
	$House1Win = 0
	$House2Win = 0
	$House3Win = 0
	$House1Lose = 0
	$House2Lose = 0
	$House3Lose = 0
	
	For $i = 1 To $DiceResults[0] - 1
		GUICtrlSetData($aRollStats[$i][2], $DiceResults[$i])
		$DiceResultsTotal += $DiceResults[$i]
	Next
	GUICtrlSetData($aRollStats[16][2], $DiceResultsTotal)
	For $i = 1 To $DiceResults[0] - 1
		GUICtrlSetData($aRollStats[$i][3], StringLeft($DiceResults[$i] / $DiceResultsTotal, 5))
	Next
	For $i = 2 To 9
		GUICtrlSetData($aHouse1[$i - 1][1], GUICtrlRead($aGrid1[$i][1]))
	Next
	For $i = 2 To 15
		GUICtrlSetData($aHouse2[$i - 1][1], GUICtrlRead($aGrid2[$i][1]))
	Next
	For $i = 2 To 20
		GUICtrlSetData($aHouse3[$i - 1][1], GUICtrlRead($aGrid3[$i][1]))
	Next
	For $i = 1 To 8
		GUICtrlSetData($aHouse1[$i][2], $aHouseStats[$i][1])
		GUICtrlSetData($aHouse1[$i][3], $aHouseStats[$i][2])
		GUICtrlSetData($aHouse1[$i][4], $aHouseStats[$i][3])
		$House1Total += $aHouseStats[$i][1]
		$House1Win += $aHouseStats[$i][2]
		$House1Lose += $aHouseStats[$i][3]
	Next
	GUICtrlSetData($aHouse1[9][2], $House1Total)
	GUICtrlSetData($aHouse1[9][3], $House1Win)
	GUICtrlSetData($aHouse1[9][4], $House1Lose)
	For $i = 9 To 22
		GUICtrlSetData($aHouse2[$i - 8][2], $aHouseStats[$i][1])
		GUICtrlSetData($aHouse2[$i - 8][3], $aHouseStats[$i][2])
		GUICtrlSetData($aHouse2[$i - 8][4], $aHouseStats[$i][3])
		$House2Total += $aHouseStats[$i][1]
		$House2Win += $aHouseStats[$i][2]
		$House2Lose += $aHouseStats[$i][3]
	Next
	GUICtrlSetData($aHouse2[15][2], $House2Total)
	GUICtrlSetData($aHouse2[15][3], $House2Total)
	GUICtrlSetData($aHouse2[15][4], $House2Total)
	For $i = 23 To 41
		GUICtrlSetData($aHouse3[$i - 22][2], $aHouseStats[$i][1])
		GUICtrlSetData($aHouse3[$i - 22][3], $aHouseStats[$i][2])
		GUICtrlSetData($aHouse3[$i - 22][4], $aHouseStats[$i][3])
		$House3Total += $aHouseStats[$i][1]
		$House3Win += $aHouseStats[$i][2]
		$House3Lose += $aHouseStats[$i][3]
	Next
	GUICtrlSetData($aHouse3[20][2], $House3Total)
	GUICtrlSetData($aHouse3[20][3], $House3Total)
	GUICtrlSetData($aHouse3[20][4], $House3Total)

	$GrandTotal = $House1Total + $House2Total + $House3Total
	$GrandWin = $House1Win + $House2Win + $House3Win
	$GrandLose = $House1Lose + $House2Lose + $House3Lose
	GUICtrlSetData($aHouse4[1][2], $GrandTotal)
	GUICtrlSetData($aHouse4[1][3], $GrandWin)
	GUICtrlSetData($aHouse4[1][4], $GrandLose)
	For $i = 1 To 8
		GUICtrlSetData($aHouse1[$i][5], StringLeft($aHouseStats[$i][1] / $GrandTotal * 100, 5))
	Next
	For $i = 9 To 22
		GUICtrlSetData($aHouse2[$i - 8][5], StringLeft($aHouseStats[$i][1] / $GrandTotal * 100, 5))
	Next
	For $i = 23 To 41
		GUICtrlSetData($aHouse3[$i - 22][5], StringLeft($aHouseStats[$i][1] / $GrandTotal * 100, 5))
	Next


EndFunc   ;==>RefreshStats
Func GUIPayoutOdds()
	$GUIPayoutOdds = GUICreate("Payout Odds", 455, 440, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SIZEBOX), $WS_EX_TOPMOST)

	$rows = 9
	$columns = 2
	Dim $aWidth[$columns + 1] = [0, 140, 60]
	Dim $aHeight[$rows + 1] = [0, 20, 16]
	$aGrid1 = _Grid(10, 10, $aWidth, $aHeight, $rows, $columns, 0xffffb3)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aGrid1[$i][$j], 1)
			GUICtrlSetFont($aGrid1[$i][$j], 8, 400)
			If $i = 1 Then
				GUICtrlSetStyle($aGrid1[1][$j], $WS_DISABLED)
			EndIf
			If $j = 1 Then
				GUICtrlSetStyle($aGrid1[$i][1], $WS_DISABLED)
			EndIf
		Next
	Next
	
	GUICtrlSetData($aGrid1[1][1], "Type")
	GUICtrlSetFont($aGrid1[1][1], 8, 800, 4)
	GUICtrlSetData($aGrid1[1][2], "Get:Give")
	GUICtrlSetFont($aGrid1[1][2], 8, 800, 4)

	GUICtrlSetData($aGrid1[2][1], "Pass Line")
	GUICtrlSetData($aGrid1[2][2], "1:1")
	GUICtrlSetData($aGrid1[3][1], "Pass Line Odds - 4&10")
	GUICtrlSetData($aGrid1[3][2], "2:1")
	GUICtrlSetData($aGrid1[4][1], "Pass Line Odds - 5&9")
	GUICtrlSetData($aGrid1[4][2], "3:2")
	GUICtrlSetData($aGrid1[5][1], "Pass Line Odds - 6&8")
	GUICtrlSetData($aGrid1[5][2], "6:5")
	GUICtrlSetData($aGrid1[6][1], "Don't Pass")
	GUICtrlSetData($aGrid1[6][2], "1:1")
	GUICtrlSetData($aGrid1[7][1], "Don't Pass Odds - 4&10")
	GUICtrlSetData($aGrid1[7][2], "1:2")
	GUICtrlSetData($aGrid1[8][1], "Don't Pass Odds - 5&9")
	GUICtrlSetData($aGrid1[8][2], "2:3")
	GUICtrlSetData($aGrid1[9][1], "Don't Pass Odds - 6&8")
	GUICtrlSetData($aGrid1[9][2], "5:6")

	$rows = 15
	$columns = 2
	Dim $aWidth[$columns + 1] = [0, 140, 60]
	Dim $aHeight[$rows + 1] = [0, 20, 16]
	$aGrid2 = _Grid(10, 170, $aWidth, $aHeight, $rows, $columns, 0xffffb3)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aGrid2[$i][$j], 1)
			GUICtrlSetFont($aGrid2[$i][$j], 8, 400)
			If $i = 1 Then
				GUICtrlSetStyle($aGrid2[1][$j], $WS_DISABLED)
			EndIf
			If $j = 1 Then
				GUICtrlSetStyle($aGrid2[$i][1], $WS_DISABLED)
			EndIf
		Next
	Next
	GUICtrlSetData($aGrid2[1][1], "Type")
	GUICtrlSetFont($aGrid2[1][1], 8, 800, 4)
	GUICtrlSetData($aGrid2[1][2], "Get:Give")
	GUICtrlSetFont($aGrid2[1][2], 8, 800, 4)

	GUICtrlSetData($aGrid2[2][1], "Come")
	GUICtrlSetData($aGrid2[2][2], "1:1")
	GUICtrlSetData($aGrid2[3][1], "Come Odds - 4&10")
	GUICtrlSetData($aGrid2[3][2], "2:1")
	GUICtrlSetData($aGrid2[4][1], "Come Odds - 5&9")
	GUICtrlSetData($aGrid2[4][2], "3:2")
	GUICtrlSetData($aGrid2[5][1], "Come Odds - 6&8")
	GUICtrlSetData($aGrid2[5][2], "6:5")
	GUICtrlSetData($aGrid2[6][1], "Don't Come")
	GUICtrlSetData($aGrid2[6][2], "1:1")
	GUICtrlSetData($aGrid2[7][1], "Don't Come Odds - 4&10")
	GUICtrlSetData($aGrid2[7][2], "1:2")
	GUICtrlSetData($aGrid2[8][1], "Don't Come Odds - 5&9")
	GUICtrlSetData($aGrid2[8][2], "2:3")
	GUICtrlSetData($aGrid2[9][1], "Don't Come Odds - 6&8")
	GUICtrlSetData($aGrid2[9][2], "5:6")
	GUICtrlSetData($aGrid2[10][1], "Place - 4&10")
	GUICtrlSetData($aGrid2[10][2], "9:8")
	GUICtrlSetData($aGrid2[11][1], "Place - 5&9")
	GUICtrlSetData($aGrid2[11][2], "7:5")
	GUICtrlSetData($aGrid2[12][1], "Place - 6&8")
	GUICtrlSetData($aGrid2[12][2], "7:6")
	GUICtrlSetData($aGrid2[13][1], "Don't Place - 4&10")
	GUICtrlSetData($aGrid2[13][2], "5:9")
	GUICtrlSetBkColor($aGrid2[13][2], 0xff0000)
	GUICtrlSetData($aGrid2[14][1], "Don't Place - 5&9")
	GUICtrlSetData($aGrid2[14][2], "5:7")
	GUICtrlSetBkColor($aGrid2[14][2], 0xff0000)
	GUICtrlSetData($aGrid2[15][1], "Don't Place - 6&8")
	GUICtrlSetData($aGrid2[15][2], "6:7")
	GUICtrlSetBkColor($aGrid2[15][2], 0xff0000)

	$rows = 20
	$columns = 2
	Dim $aWidth[$columns + 1] = [0, 140, 60]
	Dim $aHeight[$rows + 1] = [0, 20, 16]
	$aGrid3 = _Grid(240, 10, $aWidth, $aHeight, $rows, $columns, 0xffffb3)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aGrid3[$i][$j], 1)
			GUICtrlSetFont($aGrid3[$i][$j], 8, 400)
			If $i = 1 Then
				GUICtrlSetStyle($aGrid3[1][$j], $WS_DISABLED)
			EndIf
			If $j = 1 Then
				GUICtrlSetStyle($aGrid3[$i][1], $WS_DISABLED)
			EndIf
		Next
	Next
	GUICtrlSetData($aGrid3[1][1], "Type")
	GUICtrlSetFont($aGrid3[1][1], 8, 800, 4)
	GUICtrlSetData($aGrid3[1][2], "Get:Give")
	GUICtrlSetFont($aGrid3[1][2], 8, 800, 4)

	GUICtrlSetData($aGrid3[2][1], "Buy - 4&10")
	GUICtrlSetData($aGrid3[2][2], "2:1")
	GUICtrlSetBkColor($aGrid3[2][2], 0xff0000)
	GUICtrlSetData($aGrid3[3][1], "Buy - 5&9")
	GUICtrlSetData($aGrid3[3][2], "3:2")
	GUICtrlSetBkColor($aGrid3[3][2], 0xff0000)
	GUICtrlSetData($aGrid3[4][1], "Buy - 6&8")
	GUICtrlSetData($aGrid3[4][2], "6:5")
	GUICtrlSetBkColor($aGrid3[4][2], 0xff0000)
	GUICtrlSetData($aGrid3[5][1], "Lay - 4&10")
	GUICtrlSetData($aGrid3[5][2], "1:2")
	GUICtrlSetBkColor($aGrid3[5][2], 0xff0000)
	GUICtrlSetData($aGrid3[6][1], "Lay - 5&9")
	GUICtrlSetData($aGrid3[6][2], "2:3")
	GUICtrlSetBkColor($aGrid3[6][2], 0xff0000)
	GUICtrlSetData($aGrid3[7][1], "Lay - 6&8")
	GUICtrlSetData($aGrid3[7][2], "5:6")
	GUICtrlSetBkColor($aGrid3[7][2], 0xff0000)
	GUICtrlSetData($aGrid3[8][1], "Big 6 / Big 8")
	GUICtrlSetData($aGrid3[8][2], "1:1")
	GUICtrlSetData($aGrid3[9][1], "Field - 3,4,9,10,11")
	GUICtrlSetData($aGrid3[9][2], "1:1")
	GUICtrlSetData($aGrid3[10][1], "Field - 2,12")
	GUICtrlSetData($aGrid3[10][2], "2:1")
	GUICtrlSetData($aGrid3[11][1], "Any Seven")
	GUICtrlSetData($aGrid3[11][2], "5:1")
	GUICtrlSetData($aGrid3[12][1], "Any Craps")
	GUICtrlSetData($aGrid3[12][2], "8:1")
	GUICtrlSetData($aGrid3[13][1], "Horn Twelve")
	GUICtrlSetData($aGrid3[13][2], "30:1")
	GUICtrlSetData($aGrid3[14][1], "Horn Two")
	GUICtrlSetData($aGrid3[14][2], "30:1")
	GUICtrlSetData($aGrid3[15][1], "Horn Eleven")
	GUICtrlSetData($aGrid3[15][2], "15:1")
	GUICtrlSetData($aGrid3[16][1], "Horn Three")
	GUICtrlSetData($aGrid3[16][2], "15:1")
	GUICtrlSetData($aGrid3[17][1], "Hard 4")
	GUICtrlSetData($aGrid3[17][2], "8:1")
	GUICtrlSetData($aGrid3[18][1], "Hard 6")
	GUICtrlSetData($aGrid3[18][2], "10:1")
	GUICtrlSetData($aGrid3[19][1], "Hard 8")
	GUICtrlSetData($aGrid3[19][2], "10:1")
	GUICtrlSetData($aGrid3[20][1], "Hard 10")
	GUICtrlSetData($aGrid3[20][2], "8:1")

	GUICtrlCreateLabel("Red Boxes not yet implemented", 240, 350, 160, 20)

	$aGrid1[0][0] = UBound($aGrid1) - 1
	$aGrid2[0][0] = UBound($aGrid2) - 1
	$aGrid3[0][0] = UBound($aGrid3) - 1

	GUISetState(@SW_HIDE, $GUIPayoutOdds)
	GUISetOnEvent($GUI_EVENT_CLOSE, "HidePayoutOdds")

EndFunc   ;==>GUIPayoutOdds
Func GUIOptions()
	$GUIOptions = GUICreate("Craps Options", 350, 100, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SIZEBOX))

	$rows = 5
	$columns = 2
	Dim $aWidth[$columns + 1] = [0, 140, 80]
	Dim $aHeight[$rows + 1] = [0, 20, 16]
	$aOptions = _Grid(10, 10, $aWidth, $aHeight, $rows, $columns, 0xffffb3)
	For $i = 1 To $rows
		For $j = 1 To $columns
			GUICtrlSetResizing($aOptions[$i][$j], 1)
			GUICtrlSetFont($aOptions[$i][$j], 8, 400)
			If $i = 1 Then
				GUICtrlSetStyle($aOptions[1][$j], $WS_DISABLED)
			EndIf
			If $j = 1 Then
				GUICtrlSetStyle($aOptions[$i][1], $WS_DISABLED)
			EndIf
		Next
	Next
	GUICtrlSetData($aOptions[1][1], "Option")
	GUICtrlSetFont($aOptions[1][1], 8, 800, 4)
	GUICtrlSetData($aOptions[1][2], "Value")
	GUICtrlSetFont($aOptions[1][2], 8, 800, 4)
	GUICtrlSetData($aOptions[2][1], "Odds Multiplier")
	GUICtrlSetData($aOptions[2][2], "5")
	GUICtrlSetData($aOptions[3][1], "Dice Roll Speed")
	GUICtrlSetData($aOptions[3][2], "5")
	GUICtrlSetData($aOptions[4][1], "Table Color")
	GUICtrlSetData($aOptions[4][2], "")
	GUICtrlSetData($aOptions[5][1], "Dice Color")
	GUICtrlSetData($aOptions[5][2], "0xffffff")

	$btnTableColor = GUICtrlCreateButton("Table Color", 250, 40, 60, 20)
	GUICtrlSetOnEvent(-1, "TableColor")
	$btnDiceColor = GUICtrlCreateButton("Dice Color", 250, 70, 60, 20)
	GUICtrlSetOnEvent(-1, "DiceColor")

	$aOptions[0][0] = UBound($aOptions) - 1

	GUISetState(@SW_HIDE, $GUIOptions)
	GUISetOnEvent($GUI_EVENT_CLOSE, "HideOptions")

EndFunc   ;==>GUIOptions
Func GUIHelp()
	$GUIHelp = GUICreate("Help AutoIt Craps", 600, 400, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SIZEBOX))
	$treeviewHelp = GUICtrlCreateTreeView(10, 10, 180, 380, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
	$generalitem = GUICtrlCreateTreeViewItem("General", $treeviewHelp)
	GUICtrlSetColor(-1, 0x0000ff)
	GUICtrlCreateTreeViewItem("About", $generalitem)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Object of the Game", $generalitem)
	GUICtrlSetOnEvent(-1, "HelpText")
	$generalitem2 = GUICtrlCreateTreeViewItem("How to Play", $treeviewHelp)
	GUICtrlSetColor(-1, 0x0000ff)
	GUICtrlCreateTreeViewItem("Come Out Roll / Pass Line", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Don't Pass", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Come and Don't Come", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Odds Bets", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Place Bets and Don't Place", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Buy Bets", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Lay Bets", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Big 6 or Big 8", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Field Bet", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Any Seven", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Any Craps", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Horn Twelve", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Horn Two", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Horn Eleven", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Horn Three", $generalitem2)
	GUICtrlSetOnEvent(-1, "HelpText")
	$generalitem3 = GUICtrlCreateTreeViewItem("Hard Ways", $treeviewHelp)
	GUICtrlSetColor(-1, 0x0000ff)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Hard 4", $generalitem3)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Hard 10", $generalitem3)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Hard 6", $generalitem3)
	GUICtrlSetOnEvent(-1, "HelpText")
	GUICtrlCreateTreeViewItem("Hard 8", $generalitem3)
	GUICtrlSetOnEvent(-1, "HelpText")
	$editHelp = GUICtrlCreateEdit("", 200, 10, 390, 380, BitOR($WS_VSCROLL, $ES_MULTILINE))

	GUISetState(@SW_HIDE, $GUIHelp)
	GUISetOnEvent($GUI_EVENT_CLOSE, "HideHelp")
EndFunc   ;==>GUIHelp
Func HelpText()
	$treeItem = GUICtrlSendMsg($treeviewHelp, $TVM_GETNEXTITEM, $TVGN_CARET, 0)
	$ret = _GUICtrlTreeViewGetText($treeviewHelp, $treeItem)
	Switch $ret
		Case "About"
			$text = "Created with AutoIt @ http://www.autoitscript.com/" & _
					@CRLF & @CRLF & "Version 1.2" & _
					@CRLF & @CRLF & "Created by Kohr"
			GUICtrlSetData($editHelp, $text)
		Case "Object of the Game"
			$text = "The object of the game is for the player (called the shooter) to roll a pair of dice and bet on the outcome of that roll." & @CRLF & @CRLF & _
					"Payoffs are made based on the number combination displayed when the dice come to rest." & @CRLF & @CRLF & _
					"Most bets are based on one of two things:" & @CRLF & @CRLF & _
					"The number combination of the next roll." & @CRLF & @CRLF & _
					"That a particular total of the dice turns up before another total."
			GUICtrlSetData($editHelp, $text)
		Case "Come Out Roll / Pass Line"
			$text = "A new game in Craps always begins with what is called a come out roll, which is the shooter's first throw." & @CRLF & @CRLF & _
					"The most basic and common bet in Craps is the pass line bet (or its opposite, the don't pass bet)." & @CRLF & @CRLF & _
					"On the come out roll, a pass line bet wins if the shooter rolls a 7 or an 11 (called a natural), and loses his or her bet" & _
					" if the roll is a 2, 3, or 12 (called craps)." & @CRLF & @CRLF & _
					"If the shooter rolls a 4, 5, 6, 8, 9, or 10 on the come out roll, this number becomes the shooter's point" & _
					" which the dealer marks on the table with a puck -- a black and white marker placed white side up in that numbered space." & @CRLF & @CRLF & _
					"The shooter's new goal is to roll this same number again to win (called a pass) before rolling the number 7 (which would lose the bet)."
			GUICtrlSetData($editHelp, $text)
		Case "Don't Pass"
			$text = "The don't pass bet, being opposite to the pass line bet, loses on a 7 or 11, and wins on a 2 or 3." & @CRLF & @CRLF & _
					"A 12 is considered a 'push' (tie) for a don't pass so the bet is neither won nor lost." & @CRLF & @CRLF & _
					"If the shooter rolls a 4, 5, 6, 8, 9, or 10, this becomes the new point and the shooter must now roll a 7 " & _
					"(to win) before rolling the point number again (which would lose the bet)."
			GUICtrlSetData($editHelp, $text)
		Case "Come and Don't Come"
			$text = "A come bet is practically the same bet as a pass line bet." & @CRLF & @CRLF & _
					"Likewise, the don't come bet is similar to the don't pass bet." & @CRLF & @CRLF & _
					"The only difference is that pass line and don't pass bets can only be made on the come out roll, while come and don't come" & _
					" bets can only be made after a point has been established." & @CRLF & @CRLF & _
					"If the shooter rolls a 4, 5, 6, 8, 9 or 10 on the come out roll, play continues but the shooter can no longer" & _
					"place any pass line or don't pass bets." & @CRLF & @CRLF & _
					"This is when come bets and don't come bets can made." & @CRLF & @CRLF & _
					"A come bet wins if the next roll is a 7 or 11, just as on the first roll for a pass line bet." & @CRLF & @CRLF & _
					"The bet loses if the shooter rolls a 2, 3, or 12." & @CRLF & @CRLF & _
					"Any other number causes the bet to be moved from the large 'come' area on the table to the smaller box" & _
					" containing that number located just above the 'come' area." & @CRLF & @CRLF & _
					"Once a bet has been moved to one of these smaller boxes, the bet wins when the shooter rolls that number again or loses if a 7 is rolled first." & @CRLF & @CRLF & _
					"The don't come bet is opposite to the come bet, losing on a 7 or 11, and winning on a 2 or 3. Just like " & _
					"the don't pass bet, a 12 is considered a push (tie) and the don't come bet is neither won nor lost. Any " & _
					"other number causes the bet to be moved behind the box containing that number into the don't come box." & @CRLF & @CRLF & _
					"This bet will now win if you roll a seven before rolling this number again, or lose the bet if the number turns up first."
			GUICtrlSetData($editHelp, $text)
		Case "Odds Bets"
			$text = "The odds bet can only be made after you've made a pass line bet, don't pass bet, come bet, or don't bet and a point is established." & @CRLF & @CRLF & _
					"Once the point is established for your pass line or come bet, you can place an odds bet up to an additional two times your original bet." & @CRLF & @CRLF & _
					"The odds bet is won or lost whenever the associated pass line, don't pass, come or don't come bet wins or loses." & @CRLF & @CRLF & _
					"The difference is that player is paid true odds on the odds bet when it wins." & @CRLF & @CRLF & _
					"For example, the true odds for a 4 and 10 are 2:1 (read 2 to 1)." & @CRLF & @CRLF & _
					"Suppose that the shooter has a point of 4 established with a $1 passline bet and a $10 odds bet on the pass line." & @CRLF & @CRLF & _
					"If the point is made by rolling another 4, he or she would win even money (1:1) on the pass line bet ($5) but would" & _
					" win true 2:1 on the odds bet ($20)." & @CRLF & @CRLF & @CRLF & _
					"Odds on the Don't Come or Don't Pass Bets" & @CRLF & @CRLF & _
					"When a player wants odds on a don't come or don't pass bet, it is called laying odds as opposed to taking odds with a come or pass line bet." & @CRLF & @CRLF & _
					"However, because don't come and don't pass bets want a seven to roll before the point, the true odds " & _
					"for don't come and don't pass bets are	opposite those of come and pass line bets." & @CRLF & @CRLF & _
					"For example, the true odds for a 4 and 10 are 2:1, which means the odds on don't come and don't pass bets will pay 1:2." & @CRLF & @CRLF & _
					"Suppose that the shooter has a point of 4 established with a $5 don't pass bet and a $10 odds bet on the don't pass." & @CRLF & @CRLF & _
					"If the shooter rolls a seven before rolling another 4, he or she would win even money (1:1) on the don't " & _
					"pass bet ($5) and would win 1:2 on the odds bet ($5)."
			GUICtrlSetData($editHelp, $text)
		Case "Place Bets and Don't Place"
			$text = "Place bets allow the player to bet that the number will be rolled before a 7." & @CRLF & @CRLF & _
					"If a 7 is rolled first, the bet is lost." & @CRLF & @CRLF & _
					"This is similar to a come bet or pass line bet except the number is chosen by the player (as opposed to the " & _
					"outcome of the following roll) and there is no chance to win on a 7 or 11 with the next roll, or lose it on a 2, 3, or 12." & @CRLF & @CRLF & _
					"The only numbers that the player can place are the possible point numbers: 4, 5, 6, 8, 9 and 10." & @CRLF & @CRLF & _
					"Place bets are made in the box just below the box marked with the number you want to place." & @CRLF & @CRLF & _
					"Place bets must be made in increments of $5 on the 4, 5, 9 and 10, and $6 increments on the 6 and 8." & @CRLF & @CRLF & _
					"The reason for this is that the odds are 9:5 for the 4 and 10, 7:5 for the 5 and 9, and 7:6 for the 6 and 8."
			GUICtrlSetData($editHelp, $text)
		Case "Buy Bets"
			$text = "A buy bet is similar to a place bet." & @CRLF & @CRLF & _
					"The buy bet says that the number bet on will be rolled before a 7." & @CRLF & @CRLF & _
					"However, the buy bet offers the player true odds on his or her bet by having the player pay a 5% vigorish (a commission)." & @CRLF & @CRLF & _
					"The commission is paid at the time the bet is made." & @CRLF & @CRLF & _
					"For example, if the player wants to make a buy bet for $20 on the 10, he or she must actually make the bet for $21 -- $20 plus $1 (5% of $21)." & @CRLF & @CRLF & _
					"If the roll wins, he or she is paid true odds (2:1 for the 10) on $20 which would equal $40." & @CRLF & @CRLF & _
					"This version of craps assumes that every buy bet made includes the 5% commission, which his calculated by dividing the amount bet by 1.05 ($21 / 1.05 = $20)."
			GUICtrlSetData($editHelp, $text)
		Case "Lay Bets"
			$text = "A lay bet is the opposite of a buy bet." & @CRLF & @CRLF & _
					"With a lay bet, the player is hoping that a seven will be rolled before the number bet on." & @CRLF & @CRLF & _
					"If a 7 is rolled before that number turns up again, the bet is won." & @CRLF & @CRLF & _
					"If the number bet on rolls before a 7, the bet is lost." & @CRLF & @CRLF & _
					"If any other number is rolled, nothing happens to the bet." & @CRLF & @CRLF & _
					"However, just like a buy bet, a lay bet pays true odds, and the player must pay a 5% vigorish (commission) to make this bet." & @CRLF & @CRLF & _
					"One difference is that the vigorish for a lay bet is 5 percent of the amount the player wins if the lay bet is successful." & @CRLF & @CRLF & _
					"Remember that true odds when betting against the number are opposite to the true odds when betting for the number." & @CRLF & @CRLF & _
					"For example, assume the player has a lay bet of $40 on the ten." & @CRLF & @CRLF & _
					"If the player rolls a ten before a 7, he or she wins true odds (1:2) on the bet for a total of $20." & @CRLF & @CRLF & _
					"The 5% commission is then charged on the winning amount (5% of $20 = $1) so the player is given $19."
			GUICtrlSetData($editHelp, $text)
		Case "Big 6 or Big 8"
			$text = "The Big 6 and Big 8 bets are made in lower right hand corner of the table marked with a big red 6 and 8." & @CRLF & @CRLF & _
					"The bet works the same as a place bet on the 6 or 8 except that the minimum bet on the Big 6 and Big 8 is " & _
					"simply the table minimum, and the Big 6 and Big 8 pay even money." & @CRLF & @CRLF & _
					"Just like a place bet, this bet wins if whichever of the two the player selects is rolled before a 7." & @CRLF & @CRLF & _
					"If a 7 is rolled first, the bet is lost."
			GUICtrlSetData($editHelp, $text)
		Case "Field Bet"
			$text = "This is a bet that on the next roll, one of the following seven numbers with turn up: 2, 3, 4, 9, 10, 11, or 12." & @CRLF & @CRLF & _
					"The bet is lost if a 5, 6, 7, or 8 is rolled. If the winning roll is a 2 or 12, the bet pays 2:1." & @CRLF & @CRLF & _
					"All other winning rolls pay even money (1:1)." & @CRLF & @CRLF & _
					"The bet is made by simply placing an amount in the area marked 'field' between the don't pass bar and the come area."
			GUICtrlSetData($editHelp, $text)
		Case "Any Seven"
			$text = "This is a one-roll bet that the shooter will roll a 7 on the next roll." & @CRLF & @CRLF & _
					"If the next roll is a 7, the player wins 4:1 on his or her bet." & @CRLF & @CRLF & _
					"If any other number is rolled, the bet is lost."
			GUICtrlSetData($editHelp, $text)
		Case "Any Craps"
			$text = "This is a one-roll bet that the shooter will roll a 2, 3, or 12 on the next roll." & @CRLF & @CRLF & _
					"If the next roll is a 2, 3 or 12, the player wins 7:1 on his or her bet." & @CRLF & @CRLF & _
					"If any other number is rolled, the bet is lost."
			GUICtrlSetData($editHelp, $text)
		Case "Horn Twelve"
			$text = "This is a one-roll bet that the shooter will roll a 12 on the next roll." & @CRLF & @CRLF & _
					"If the next roll is a 12, the player wins an exciting 30:1 on his or her bet." & @CRLF & @CRLF & _
					"If any other number is rolled, the bet is lost."
			GUICtrlSetData($editHelp, $text)
		Case "Horn Two"
			$text = "This is a one-roll bet that the shooter will roll a 2 on the next roll." & @CRLF & @CRLF & _
					"If the next roll is a 2, the player wins an exciting 30:1 on his or her bet." & @CRLF & @CRLF & _
					"If any other number is rolled, the bet is lost."
			GUICtrlSetData($editHelp, $text)
		Case "Horn Eleven"
			$text = "This is a one-roll bet that the shooter will roll an 11 (nicknamed 'yo' to limit the confusion of yelling 'seven' and 'eleven') " & _
					"on the next roll." & @CRLF & @CRLF & _
					"If the next roll is an 11, the player wins a 15:1 on his or her bet." & @CRLF & @CRLF & _
					"If any other number is rolled, the bet is lost."
			GUICtrlSetData($editHelp, $text)
		Case "Horn Three"
			$text = "This is a one-roll bet that the shooter will roll a 3 on the next roll." & @CRLF & @CRLF & _
					"If the next roll is a 3, the player wins 15:1 on his or her bet." & @CRLF & @CRLF & _
					"If any other number is rolled, the bet is lost."
			GUICtrlSetData($editHelp, $text)
		Case "Hard Ways"
			$text = "When the shooter rolls and both dice turn up with the same number, it's called a hard way." & @CRLF & @CRLF & _
					"Rolls of 2 and 12 are not considered hard ways because either total can only be rolled by one combination (two ones or two sixes)." & @CRLF & @CRLF & _
					"In the case of other hard way bets, the total can be rolled by other combinations of the dice." & @CRLF & @CRLF & _
					"For example, a hard way 10 (or hard 10) means two 5's were rolled on the dice for a total of 10." & @CRLF & @CRLF & _
					"However, a 10 can also be achieved by a 6 and 4."
			GUICtrlSetData($editHelp, $text)
		Case "Hard 4"
			$text = "When the player bets a hard 4, he or she is hoping for a 2 to come up on both dice before any other 4 combination or a 7 turns up." & @CRLF & @CRLF & _
					"If the shooter rolls a 1 and 3, or a 7, the bet is lost. The payout for a hard 4 is 7:1."
			GUICtrlSetData($editHelp, $text)
		Case "Hard 10"
			$text = "When the player bets a hard 10, he or she is hoping for a 5 to come up on both dice before any other 10 combination or a 7	turns up." & @CRLF & @CRLF & _
					"If the shooter rolls a 6 and 4, or a 7, the bet is lost. The payout for a hard 10 is 7:1."
			GUICtrlSetData($editHelp, $text)
		Case "Hard 6"
			$text = "When the player bets a hard 6, he or she is hoping for a 3 to come up on both dice before any other 6 combination or a 7 turns up." & @CRLF & @CRLF & _
					"If the shooter rolls a 1 and 5, 2 and 4, or a 7, the bet is lost. The payout for a hard 6 is 9:1."
			GUICtrlSetData($editHelp, $text)
		Case "Hard 8"
			$text = "When the player bets a hard 8, he or she is hoping for a 4 to come up on both dice before any other 8 combination or a 7 turns up." & @CRLF & @CRLF & _
					"If the shooter rolls a 2 and 6, 3 and 5, or a 7, the bet is lost. The payout for a hard 8 is 9:1."
			GUICtrlSetData($editHelp, $text)
	EndSwitch
EndFunc   ;==>HelpText
Func TableColor()
	$color = _ChooseColor(2, $aOptions[4][1])
	GUICtrlSetData($aOptions[4][2], $color)
	GUISetBkColor($color, $GUImain)
EndFunc   ;==>TableColor
Func DiceColor()
	$color = _ChooseColor(2, $aOptions[5][1])
	GUICtrlSetData($aOptions[5][2], $color)
	GUICtrlSetBkColor($GraphicDice1, $color)
	GUICtrlSetBkColor($GraphicDice2, $color)
	Dice(1, 4)
	Dice(2, 3)
	_InvalidateRect($GUImain, $rRect, True)
EndFunc   ;==>DiceColor
Func BuildBetValues()
	Dim $BetIncrement[$BetCounter + 1]
	For $i = 1 To $BetCounter
		Switch $i
			Case 1, 6
				$array = StringSplit(GUICtrlRead($aGrid2[10][2]), ":")
			Case 2, 5
				$array = StringSplit(GUICtrlRead($aGrid2[11][2]), ":")
			Case 3, 4
				$array = StringSplit(GUICtrlRead($aGrid2[12][2]), ":")
			Case 7
				$array = StringSplit(GUICtrlRead($aGrid2[6][2]), ":")
			Case 8
				$array = StringSplit(GUICtrlRead($aGrid2[2][2]), ":")
			Case 9
				$array = StringSplit(GUICtrlRead($aGrid3[9][2]), ":")
			Case 10
				$array = StringSplit(GUICtrlRead($aGrid3[8][2]), ":")
			Case 11
				$array = StringSplit(GUICtrlRead($aGrid1[6][2]), ":")
			Case 12
				$array = StringSplit(GUICtrlRead($aGrid1[2][2]), ":")
			Case 13
				$array = StringSplit(GUICtrlRead($aGrid3[11][2]), ":")
			Case 14
				$array = StringSplit(GUICtrlRead($aGrid3[18][2]), ":")
			Case 15
				$array = StringSplit(GUICtrlRead($aGrid3[20][2]), ":")
			Case 16
				$array = StringSplit(GUICtrlRead($aGrid3[19][2]), ":")
			Case 17
				$array = StringSplit(GUICtrlRead($aGrid3[17][2]), ":")
			Case 18
				$array = StringSplit(GUICtrlRead($aGrid3[16][2]), ":")
			Case 19
				$array = StringSplit(GUICtrlRead($aGrid3[14][2]), ":")
			Case 20
				$array = StringSplit(GUICtrlRead($aGrid3[13][2]), ":")
			Case 21, 22
				$array = StringSplit(GUICtrlRead($aGrid3[15][2]), ":")
			Case 23
				$array = StringSplit(GUICtrlRead($aGrid3[12][2]), ":")
			Case Else
				$array[2] = ""
		EndSwitch
		$text = ""
		For $j = 1 To 10
			$ret = $array[2] * $j
			$text &= $ret & "|"
		Next
		$text &= "0"
		$BetIncrement[$i] = $text
	Next
	For $i = 1 To $BetCounter
		GUICtrlSetData($inputBet[$i], $BetIncrement[$i], "")
	Next
EndFunc   ;==>BuildBetValues
Func PlayerBet()
	ReDim $BetBucket[$BetCounter][3]
	For $i = 1 To $BetCounter
		If $BetBucket[$i][1] = "" Then
			$BetBucket[$i][1] = @GUI_CtrlId
			$BetBucket[$i][2] = GUICtrlRead(@GUI_CtrlId)
			GUICtrlSetData($labelPlayerMoney, GUICtrlRead($labelPlayerMoney) - $BetBucket[$i][2])
			ExitLoop
		EndIf
		If $BetBucket[$i][1] = @GUI_CtrlId Then
			GUICtrlSetData($labelPlayerMoney, GUICtrlRead($labelPlayerMoney) - GUICtrlRead(@GUI_CtrlId) + $BetBucket[$i][2])
			$BetBucket[$i][2] = GUICtrlRead(@GUI_CtrlId)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>PlayerBet
Func SaveHistory()
	$var = FileSaveDialog("Craps History", @WorkingDir, "ini File (*.ini)", 2, "CrapsHistory.ini")
	IniWrite($var, "Money", "House Money", GUICtrlRead($labelHouseMoney))
	IniWrite($var, "Money", "Player Money", GUICtrlRead($labelPlayerMoney))
	For $i = 2 To $aOptions[0][0]
		IniWrite($var, "Options", GUICtrlRead($aOptions[$i][1]), GUICtrlRead($aOptions[$i][2]))
	Next
	For $i = 2 To $aGrid1[0][0]
		IniWrite($var, "Bet Odds", GUICtrlRead($aGrid1[$i][1]), GUICtrlRead($aGrid1[$i][2]))
	Next
	For $i = 2 To $aGrid2[0][0]
		IniWrite($var, "Bet Odds", GUICtrlRead($aGrid2[$i][1]), GUICtrlRead($aGrid2[$i][2]))
	Next
	For $i = 2 To $aGrid3[0][0]
		IniWrite($var, "Bet Odds", GUICtrlRead($aGrid3[$i][1]), GUICtrlRead($aGrid3[$i][2]))
	Next
	For $i = 1 To $DiceResults[0] - 1
		IniWrite($var, "Dice Results", $DiceRollNames[$i], $DiceResults[$i])
	Next

	For $i = 1 To 8
		IniWrite($var, "House Money", GUICtrlRead($aHouse1[$i][1]), GUICtrlRead($aHouse1[$i][2]))
		IniWrite($var, "House Win Count", GUICtrlRead($aHouse1[$i][1]), GUICtrlRead($aHouse1[$i][3]))
		IniWrite($var, "House Lose Count", GUICtrlRead($aHouse1[$i][1]), GUICtrlRead($aHouse1[$i][4]))
	Next
	For $i = 1 To 14
		IniWrite($var, "House Money", GUICtrlRead($aHouse2[$i][1]), GUICtrlRead($aHouse2[$i][2]))
		IniWrite($var, "House Win Count", GUICtrlRead($aHouse2[$i][1]), GUICtrlRead($aHouse2[$i][3]))
		IniWrite($var, "House Lose Count", GUICtrlRead($aHouse2[$i][1]), GUICtrlRead($aHouse2[$i][4]))
	Next
	For $i = 1 To 19
		IniWrite($var, "House Money", GUICtrlRead($aHouse3[$i][1]), GUICtrlRead($aHouse3[$i][2]))
		IniWrite($var, "House Win Count", GUICtrlRead($aHouse3[$i][1]), GUICtrlRead($aHouse3[$i][3]))
		IniWrite($var, "House Lose Count", GUICtrlRead($aHouse3[$i][1]), GUICtrlRead($aHouse3[$i][4]))
	Next
EndFunc   ;==>SaveHistory
Func LoadHistory()
	$path = FileOpenDialog("Find History File.", @WorkingDir, "ini File (*.ini)", 2)
	If @error Then
		MsgBox(4096, "", "No File(s) chosen")
		Return 0
	EndIf
	$var = IniReadSection($path, "Money")
	GUICtrlSetData($labelHouseMoney, $var[1][1])
	GUICtrlSetData($labelPlayerMoney, $var[2][1])
	$var = IniReadSection($path, "Options")
	For $i = 2 To $var[0][0] + 1
		GUICtrlSetData($aOptions[$i][2], $var[$i - 1][1])
	Next
	If (GUICtrlRead($aOptions[4][2])) <> "" Then
		GUISetBkColor(GUICtrlRead($aOptions[4][2]), $GUImain)
	EndIf
	GUICtrlSetBkColor($GraphicDice1, GUICtrlRead($aOptions[5][2]))
	GUICtrlSetBkColor($GraphicDice2, GUICtrlRead($aOptions[5][2]))
	Dice(1, 4)
	Dice(2, 3)
	_InvalidateRect($GUImain, $rRect, True)
	$var = IniReadSection($path, "Bet Odds")
	For $i = 2 To 8
		GUICtrlSetData($aGrid1[$i][2], $var[$i - 1][1])
	Next
	For $i = 2 To 15
		GUICtrlSetData($aGrid2[$i][2], $var[$i + 7][1])
	Next
	For $i = 2 To 20
		GUICtrlSetData($aGrid3[$i][2], $var[$i + 21][1])
	Next
	$var = IniReadSection($path, "Dice Results")
	For $i = 1 To $var[0][0]
		$DiceResults[$i] = $var[$i][1]
	Next
	$var = IniReadSection($path, "House Money")
	For $i = 1 To 41
		$aHouseStats[$i][1] = $var[$i][1]
	Next
	$var = IniReadSection($path, "House Win Count")
	For $i = 1 To 41
		$aHouseStats[$i][2] = $var[$i][1]
	Next
	$var = IniReadSection($path, "House Lose Count")
	For $i = 1 To 41
		$aHouseStats[$i][3] = $var[$i][1]
	Next
EndFunc   ;==>LoadHistory
#region --- Functions for closing ---
Func CloseClicked()
	Exit
EndFunc   ;==>CloseClicked
Func HidePayoutOdds()
	$state = WinGetState("Payout Odds")
	If $state = 5 Then
		GUISetState(@SW_SHOW, $GUIPayoutOdds)
	Else
		GUISetState(@SW_HIDE, $GUIPayoutOdds)
	EndIf
EndFunc   ;==>HidePayoutOdds
Func HideOptions()
	$state = WinGetState("Craps Options")
	If $state = 5 Then
		GUISetState(@SW_SHOW, $GUIOptions)
	Else
		GUISetState(@SW_HIDE, $GUIOptions)
	EndIf
EndFunc   ;==>HideOptions
Func HideHelp()
	$state = WinGetState("Help AutoIt Craps")
	If $state = 5 Then
		GUISetState(@SW_SHOW, $GUIHelp)
	Else
		GUISetState(@SW_HIDE, $GUIHelp)
	EndIf
EndFunc   ;==>HideHelp
Func HideStats()
	$state = WinGetState("AutoIt Craps Statistics")
	If $state = 5 Then
		RefreshStats()
		GUISetState(@SW_SHOW, $GUIStats)
	Else
		GUISetState(@SW_HIDE, $GUIStats)
	EndIf
EndFunc   ;==>HideStats

#endregion --- Functions for closing ---
#region --- Auto3Lib START ---
Func _DllOpen($sFileName)
	Local $hDLL
	Local $iIndex

	$sFileName = StringUpper($sFileName)
	For $iIndex = 1 To $gaLibDlls[0][0]
		If $sFileName = $gaLibDlls[$iIndex][0] Then
			Return $gaLibDlls[$iIndex][1]
		EndIf
	Next

	$hDLL = DllOpen($sFileName)
	$iIndex = $gaLibDlls[0][0] + 1
	$gaLibDlls[0][0] = $iIndex
	$gaLibDlls[$iIndex][0] = $sFileName
	$gaLibDlls[$iIndex][1] = $hDLL
	Return $hDLL
EndFunc   ;==>_DllOpen
Func _DllStructCreate($sStruct, $pPointer = 0)
	Local $rResult

	If $pPointer = 0 Then
		$rResult = DllStructCreate($sStruct)
	Else
		$rResult = DllStructCreate($sStruct, $pPointer)
	EndIf
	Return $rResult
EndFunc   ;==>_DllStructCreate
Func _DllStructSetData($rStruct, $iElement, $vValue, $iIndex = -1)
	Local $rResult

	If $iIndex = -1 Then
		$rResult = DllStructSetData($rStruct, $iElement, $vValue)
	Else
		$rResult = DllStructSetData($rStruct, $iElement, $vValue, $iIndex)
	EndIf
	Return $rResult
EndFunc   ;==>_DllStructSetData
Func _DllStructGetPtr($rStruct, $iElement = 0)
	Local $rResult

	If $iElement = 0 Then
		$rResult = DllStructGetPtr($rStruct)
	Else
		$rResult = DllStructGetPtr($rStruct, $iElement)
	EndIf
	Return $rResult
EndFunc   ;==>_DllStructGetPtr
Func _InvalidateRect($hWnd, $rRect = 0, $bErase = True)
	Local $pRect
	Local $aResult
	Local $hUser32

	If $rRect <> 0 Then $pRect = _DllStructGetPtr($rRect)
	$hUser32 = _DllOpen("User32.dll")
	$aResult = DllCall($hUser32, "int", "InvalidateRect", "hwnd", $hWnd, "ptr", $pRect, "int", $bErase)
	Return ($aResult[0] <> 0)
EndFunc   ;==>_InvalidateRect
#endregion --- Auto3Lib END ---
