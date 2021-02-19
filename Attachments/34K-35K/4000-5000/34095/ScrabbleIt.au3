; #INDEX# =======================================================================================================================
; Title .........: ScrabbleIt
; AutoIt Version : 3.3.6.1+
; Version........: 1.28.15.15	- 5/27/2011
; Language ......: English
; Description ...: Srabble as built from the ground up in pure Auto It. A challenge for myself.
; Author(s) .....: Kris Mills <fett8802 at gmail dot com>
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; Includes
;	Array.au3
;	EditConstants.au3
;	KrisUDF.au3
;	GUIConstantsEx.au3
;	WindowsConstants.au3
; Variables
;	$aDButtons[1][5], $aPButtons[8], $aTButtons[16][16]
;	$aP1Tiles[8], $aP2Tiles[8]
;	$aScores
;	$aTiles
;	$aBottomRow
;	$aFisrtColumn
;	$aLastColumn
;	$aTopRow
;	$cLetter, $lLeft, $sColorTrigger, $sLetter, $sPassLimit, $sPlay
;	$gMain
;	$iPlayer, $iPlayer1, $iPlayer2
;	$lTurn
;	$aWordList
; Functions
;	Close
;	_Scrabble_ClickBoardTile
;	_Scrabble_ClickPlayerTile
;	_Scrabble_ConvertWord
;	_Scrabble_CreateBoard
;	_Scrabble_FindWord
;	_Scrabble_GetLetterScore
;	_Scrabble_GetTiles
;	_Scrabble_GetWordScore
;	_Scrabble_Pass
;	_Scrabble_Play
;	_Scrabble_RecallTiles
;	_Scrabble_SpecialTile
;	_Scrabble_UpdatePlayer
;	_Scrabble_VerifyWord
; ===============================================================================================================================

; #INCLUDES# ====================================================================================================================
#include <Array.au3>																								;For use with the many arrays in this program
#include <EditConstants.au3>																						;For use with the input controls
#include <KrisUDF.au3>																								;For use with the _Array2DClearBlanks function
#include <GUIConstantsEx.au3>																						;For use with the Main GUI
#include <WindowsConstants.au3>																						;For use with the Main GUI
; ===============================================================================================================================

FileInstall("ScrabbleWords.txt",@TempDir & "\ScrabbleWords.txt",1)													;Install the ScrabbleWords.txt file into the temp directory
OnAutoItExitRegister("Close")																						;When the program exits, perform the Close function
Opt("GUIOnEventMode",1)																								;Set the AutoIt GUI mode to On Event
_CreateBuild()																										;Creates a build upon each running of the program

; #VARIABLES# ===================================================================================================================
#Region
Global $aDButtons[1][5], $aPButtons[8], $aTButtons[16][16] 															;Declare the global button values, used first in _Scrabble_CreateBoard
		;$aDButtons is the array for the default button parameters
			;$aDButtons[$n][0] = The "state" of the button. 0 is default, 1 has a player tile on it that has not been "played", and 2 is "perminantly played"
			;$aDButtons[$n][1] = The default color of the button
			;$aDButtons[$n][2] = The default label of the button
			;$aDButtons[$n][3] = The default hint tip of the button
			;$aDButtons[$n][4] = The @GUI_CtrlID of the button
		;$aPButtons is the array used for the buttons representing the player's hands
			;$aPButtons[1] is the first button, etc.
		;$aTButtons is the array for the physical Control IDs of the buttons on the board. Coordinates are 1-15
			;$aTButtons[1][1] = Button Coord 1,1
Global $aP1Tiles[8], $aP2Tiles[8]																					;Declares the arrays used to store each player's tiles
Global $aScores[27][2] = [["_",0],["E",1],["A",1],["I",1],["O",1],["R",1],["N",1],["T",1],["L",1],["S",1], _		;Declares the two dimensional array containing
						  ["U",1],["D",2],["G",2],["B",3],["C",3],["M",3],["P",3],["F",4],["H",4],["V",4], _		;the scores for each tile in the game
						  ["W",4],["Y",4],["K",5],["J",8],["X",8],["Q",10],["Z",10]]
Global $aTiles[100] = ["_","_","J","K","Q","X","Z","B","B","C","C","F","F","H","H","M","M","P","P","V", _			;Declares the array containing each of the
					  "V","W","W","Y","Y","G","G","G","D","D","D","D","L","L","L","L","S","S","S","S", _			;tiles in the game
					  "U","U","U","U","N","N","N","N","N","N","R","R","R","R","R","R","T","T","T","T", _
					  "T","T","O","O","O","O","O","O","O","O","A","A","A","A","A","A","A","A","A","I", _
					  "I","I","I","I","I","I","I","I","E","E","E","E","E","E","E","E","E","E","E","E"]
Global $aBottomRow[15] = [18,33,48,63,78,93,108,123,138,153,168,183,198,213,228]									;Declare an array containing the Control ID's of the bottom row of buttons
Global $aFirstColumn[15] = [4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]													;Declare an array containing the Control ID's of the first column of buttons
Global $aLastColumn[15] = [214,215,216,217,218,219,220,221,222,223,224,225,226,227,228]								;Declare an array containing the Control ID's of the last column of buttons
Global $aTopRow[15] = [4,19,34,49,64,79,94,109,124,139,154,169,184,199,214]											;Declare an array containing the Control ID's of the top row of buttons
		;The above four declares ($aBottomRow, $aFirstColumn, $aLastColumn, and $aTopRow) are all used in the _Scrabble_FindWord function to set the limits on word plays
Global $cLetter, $lLeft, $sColorTrigger, $sLetter, $sPassLimit  = 0, $sPlay = 1										;Declare various other variables that need to be Global for various functions
		;$cLetter is Global as its the identifying "this tile has been selected by the user" variable
		;$lLeft is Global for the _Scrabble_GetTiles function
		;$sColorTrigger is Global for the _Scrabble__Scrabble_ClickBoardTile and _Scrabble_ClickPlayerTile functions
		;$sLetter is Global for the _Scrabble__Scrabble_ClickBoardTile and _ScrabbleClickPlayerTile functions
		;$sPassLimit is used to track consecutive passes. After 6 consecutive passes, the game is over
		;$sPlay is only used to force the first move to cross the X in _Scrabble_FindWord
Global $gMain																										;Declaring the main gui so that it can be created and destroyed in different functions
Global $iPlayer = 1, $iPlayer1, $iPlayer2																			;Declare the score input boxes for use in several functions
		;$iPlayer is initialized to 1 to indicate Player 1 goes first
Global $lTurn																										;Declare the labels used in the GUI
Global $sSize = RegRead("HKEY_LOCAL_MACHINE\Software\KM\ScrabbleIt","Size")											;Declare the $sSize variable as the Size value in the registry
		If $sSize = "" Then $sSize = 35																				;If there is no size value in the registry, default to 35
Global Const $sWordList = FileRead(@TempDir & "\ScrabbleWords.txt")													;Declare the word list string as the contents of the word list text file
#EndRegion
; ===============================================================================================================================

_Scrabble_CreateBoard($sSize)																						;Create the game board based on the user input size
_Scrabble_UpdatePlayer(0)																							;Perform the first player update function

While 1
	Sleep(100)
WEnd

Func _Scrabble_Size()
	$sSure = MsgBox(52,"ScrabbleIt","Changing the game board size will end the current game. Are you sure you want to do this?")
	If $sSure = 7 Then Return
	$sInput = InputBox("ScrabbleIt","The current size is: " & $sSize & @CRLF & "Valid sizes are 25 - 45.",""," M",150,150)
	If $sInput < 25 Or $sInput > 45 Then
		MsgBox(16,"ScrabbleIt","The size you entered is not valid.")
		Return
	EndIf
	GUIDelete($gMain)
	_Scrabble_CreateBoard($sInput)
	_Scrabble_UpdatePlayer(0)
	$sPlay = 1
EndFunc

;Code the "blank" squares
;Finish the Size function
;The middle square is a "double word" square
;Add 50 points to the total score if the player uses all 7 tiles
;Still need to code swap and resign
;Problem with the middle X if a piece was placed on it then moved
;Problem with the X being the last letter of the word, won't work
;Problems with the Play button (may be related to NOT having horizontal coded yet)
;Won't allow a word to be played if the previously played letter it's attached to is the first or last letter


; #FUNCTION# ====================================================================================================================
; Name...........: Close
; Description ...: Performs resource clean up and exits the program
; Syntax.........: Close()
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func Close()
	RegWrite("HKEY_LOCAL_MACHINE\Software\KM\ScrabbleIt","Size","REG_SZ",$sSize)								;Write the size value to the registry
	Exit																										;Close the program
EndFunc   ;==>Close

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_ClickBoardTile
; Description ...: This function is run every time a player clicks one of the "Board Tiles"
; Syntax.........: _Scrabble_ClickBoardTile()
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Requires the following global variables to be declared at the beginning of the script:
;
;					Global $cLetter, $sColorTrigger, $sLetter
;
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_ClickBoardTile()
	Local $iBlank = ""
	If $sLetter = "_" Then
		$sLetter = InputBox("ScrabbleIt","Please enter the letter you wish to use.",""," M1",150,150)
		If StringIsAlpha($sLetter) <> 1 Then
			MsgBox(16,"ScrabbleIt","Please enter a valid letter.")
			Return
		EndIf
		$iBlank = 1
	EndIf
	If $sLetter <> "" and $aDButtons[@GUI_CtrlId][0] = 0 Then														;If a Player Tile is selected and the Board Tile does not have any other tiles on it, then
		GUICtrlSetData(@GUI_CtrlId,$sLetter)																		;Set the newly selected Board Tile's label to the given letter
		GUICtrlSetBkColor(@GUI_CtrlId,0xFFE500)																		;Set newly selected the Board Tile's color to a mustard yellow, indicating a tile has been placed but not played
		If $iBlank = 1 Then GUICtrlSetTip(@GUI_CtrlId, "A wildcard is worth 0 points.")
		If $iBlank = "" Then GUICtrlSetTip(@GUI_CtrlId, $sLetter & " is worth " & _Scrabble_GetLetterScore($sLetter)) ;Set newly selected the Board Tile's hint tip to the given value
		GUICtrlSetFont(@GUI_CtrlId,10,900)																			;Set newly selected the Board Tile's font to slightly larger than normal
		GUICtrlSetData($cLetter,"")																					;Erase the $cLetter variable, indicating no letter is currently selected
		If $sColorTrigger = 1 Then																					;If $sColorTrigger is 1, indicating a Player Tile is selected, then
			GUICtrlSetBkColor($cLetter,0xD4BFFE)																	;Change that Player Tile color to purple, indicating the tile that had been there has been played
		Else																										;If $sColorTrigger is not 1, indicating a Board Tile is selected, then
			GUICtrlSetFont($cLetter,8.5,400)																		;Set the originally selected Board Tile's font back to normal
			GUICtrlSetBkColor($aDButtons[$cLetter][4], $aDButtons[$cLetter][1])										;Set the originally selected Board Tile's color back to default
			GUICtrlSetData($aDButtons[$cLetter][4], $aDButtons[$cLetter][2])										;Set the originally selected Board Tile's label back to default
			GUICtrlSetTip($aDButtons[$cLetter][4], $aDButtons[$cLetter][3])											;Set the originally selected Board Tile's hint tip back to default
			$aDButtons[$cLetter][0] = 0																				;Set the originally selected Board Tile's state back to default (contains no tile)
		EndIf
		$aDButtons[@GUI_CtrlId][0] = 1																				;Set the newly selected Board Tile's state to 1 (a tile has been placed, but not played)
		$sLetter = ""																								;Erase the $sLetter variable, indicating no tile is currently selected
	EndIf
	If $aDButtons[@GUI_CtrlId][0] = 1 Then																			;If the state of the newly selected Board Tile is 1, indicating a tile has already been placed but not played, then
		If GUICtrlRead($cLetter) <> "" and StringLen(GUICtrlRead($cLetter)) < 2 Then GUICtrlSetBkColor($cLetter,0xFFE500) ;If the previously selected letter was a Player Tile that was not blank, change the Player Tile color back to a mustard yellow to reflect the change
		$cLetter = @GUI_CtrlId																						;Set the Tile that is on the newly selected Board Tile to the currently selected Tile
		$sLetter = GUICtrlRead($cLetter)																			;Set the $sLetter variable to the current label of the newly selected Board Tile
		$sColorTrigger = 0																							;Set the $sColorTrigger to 0, indicating a Board Tile, and not a Player Tile, is selected
	EndIf
EndFunc   ;==>_Scrabble_ClickBoardTile

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_ClickPlayerTile
; Description ...: This function is run every time a player clicks one of the "Player Tiles"
; Syntax.........: _Scrabble_ClickPlayerTile()
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Requires the following global variables to be declared at the beginning of the script:
;
;					Global $cLetter, $sColorTrigger, $sLetter
;
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_ClickPlayerTile()
	If @GUI_CtrlId <> $cLetter and GUICtrlRead($cLetter) <> "" and StringLen(GUICtrlRead($cLetter)) < 2 And @GUI_CtrlId > 230 Then GUICtrlSetBkColor($cLetter,0xFFE500) ;If the clicked tile is not the previous tile, then change the color back to normal
	If GUICtrlRead(@GUI_CtrlId) <> "" Then																			;If the user hasn't selected a blank player tile, then
		$sColorTrigger = 1																							;Set the $sColorTrigger variable to 1. This variable is used in the _Scrable__Scrabble_ClickBoardTile function to indicate wether or not a Player Tile is selected
		$cLetter = @GUI_CtrlId																						;Set the value of $cLetter (clicked letter) to the current @GUI_CtrlId
		$sLetter = GUICtrlRead($cLetter)																			;Read the clicked letter and get the string value of the letter
		GUICtrlSetTip($cLetter,"")																					;Set the hint tip of the selected tile to blank. This stops the "blank" player tiles from having old hint tips
		GUICtrlSetBkColor($cLetter,0xFE80B9)																		;Change the selected player tile's color to pink to notify the user of the selection
	EndIf
EndFunc   ;==>_Scrabble_ClickPlayerTile

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_ConvertWord
; Description ...: Converts the word array used in the ScrabbleIt program into the word's string value
; Syntax.........: _Scrabble_ConvertWord( $iaWord )
; Parameters.....: $iaWord - An array containing the word to be scored. This array must be in the following format:
;					$iaWord[0][0]  - The first letter of the word			$iaWord[0][1]  - The multiplier of the word (or blank if no multiplier)
;					$iaWord[$n][0] - The last letter of the word			$iaWord[$n][1] - The multiplier of the word (or blank if no multiplier)
;
;					An example would be the word DOG with a TL multiplier on D and a TW multiplier on G:
;						$aWord[3][2] = [["D","TL"],["O",""],["G","TW"]]
;
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 5/4/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_ConvertWord($iaWord)
	Local $isWord = ""																								;Declare the local word variable
	For $i = 0 To UBound($iaWord) - 1																				;Start a For loop. This will repeat for each letter in the array
		$isWord = $isWord & $iaWord[$i][0]																			;Concatenate the array letters together into a string
	Next																											;Start the next iteration of the For loop
	Return $isWord																									;Return the word
EndFunc   ;==>_Scrabble_ConvertWord

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_CreateBoard
; Description ...: Creates the main Scrabble board, score boxes, and player tiles all based on the number entered by the user
; Syntax.........: _Scrabble_CreateBoard( $sButtonSize = 35 )
; Parameters ....: $sButtonSize - [optional] The size of the board to be created. Valid entries are 25-45. Default is 35
; Return values .: Failure - -1, indicates the user input a number outside the 25-45 range
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Requires the following global variable to be declared at the beginning of the script:
;
;					Global $aDButtons[1][5], $aTButtons[16][16], $aPButtons[8]
;
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_CreateBoard($sButtonSize = 35)
	If $sButtonSize < 25 or $sButtonSize > 45 Then Return -1													;If the user inputs a value less than 25 or greater than 45, return -1
	$gMain = GUICreate("ScrabbleIt - Game Board", (15 * $sButtonSize) + 1, (16 * $sButtonSize) + 92)			;Create the Main GUI window based on the entered value
		GUISetOnEvent($GUI_EVENT_CLOSE, "Close")																;Set the Close On Event for when the user exits the program
	$mMain = GUICtrlCreateMenu("&File")																			;Create the Main Menu control
	$mMain_Exit = GUICtrlCreateMenuItem("&Exit                    Esc",$mMain)									;Create the Exit entry under File in the Main Menu
		GUICtrlSetOnEvent(-1, "Close")																			;Set the On Event function for the Exit entry
	$mOptions = GUICtrlCreateMenu("&Options")																	;Create the Options Main Menu control
	$mOptions_Size = GUICtrlCreateMenuItem("&Size                    F5",$mOptions)								;Create the Size entry under Options in the Main Menu
		GUICtrlSetOnEvent(-1,"_Scrabble_Size")																	;Set the On Event for the Size entry
	;Create the buttons on the game board and give them their special labels/colors
	For $i = 1 to 15																							;Start a For loop. This loop will create the buttons on the game board and will repeat 15 times
		For $y = 1 to 15																						;Start a second For loop. This will repeat 15 times each time through the above loop
			$aTButtons[$i][$y] = GUICtrlCreateButton("", 8 + (($i-1) * ($sButtonSize - 1)), 8 + (($y-1) * ($sButtonSize - 1)), $sButtonSize, $sButtonSize) ;Create the next button in line using the loop variables as identifying numbers
				GUICtrlSetOnEvent(-1,"_Scrabble_ClickBoardTile")												;Set the On Event for each game board button
				GUICtrlSetFont($aTButtons[$i][$y],8.5,400)														;Set the universal font for the buttons
				GUICtrlSetBkColor(-1,0xffffff)																	;Set the background color of all the game board buttons to white
				ReDim $aDButtons[$aTButtons[$i][$y] + 1][5]														;Add one to the default button array
				$aDButtons[$aTButtons[$i][$y]][0] = 0															;Set the default state of the button to 0
				$aDButtons[$aTButtons[$i][$y]][1] = 0xffffff													;Set tje defailt color of the button to 0xffffff
				$aDButtons[$aTButtons[$i][$y]][2] = ""															;Set the default label of the button to blank
				$aDButtons[$aTButtons[$i][$y]][3] = ""															;Set the default tip hint of the button to blank
				$aDButtons[$aTButtons[$i][$y]][4] = $aTButtons[$i][$y]											;Set the default @GUI_CtrlID of the button to the @GUI_CtrlID
			If $i = 8 and $y = 8 Then																			;If the $i and $y values are both 8, then
				GUICtrlSetData($aTButtons[$i][$y],"+")															;Add a + to the square
				$aDButtons[$aTButtons[$i][$y]][2] = "+"															;Set the default label of the button to +
			EndIf
			If (($i = 1 or $i = 8 or $i = 15) and ($y = 1 or $y = 8 or $y = 15)) and not ($i = 8 and $y = 8) Then ;If the button is meant to be a Triple Word square, then
				_Scrabble_SpecialTile($i, $y, 0xFF3300, "TW", "Words placed over this tile will have a x3 multiplier applied to the score.") ;Apply the Triple Word color and label
			EndIf
			If (($i > 1 and $i < 6) or ($i > 10 and $i < 15)) and ($i = $y or $i = 16 - $y) Then				;If the button is meant to be a Double Word square, then
				_Scrabble_SpecialTile($i, $y, 0xFEBFDC, "DW", "Words placed over this tile will have a x2 multiplier applied to the score.") ;Apply the Double Word color and label
			EndIf
			If (($i = 2 or $i = 6 or $i = 10 or $i = 14) and ($y = 2 or $y = 6 or $y = 10 or $y = 14)) and not (($i = 2 and $y = 2) or ($i = 2 and $y = 14) or ($i = 14 and $y = 2) or ($i = 14 and $y = 14)) Then ;If the button is meant to be a Triple Letter square, then
				_Scrabble_SpecialTile($i,$y,0x80C8FE,"TL","Letters placed over this tile will have a x3 multiplier applied to the score.") ;Apply the Triple Letter color and label
			EndIf
			If (($i = 1 or $i = 4 or $i = 12 or $i = 15) and ($y = 1 or $y = 4 or $y = 12 or $y = 15) and ($i <> $y) and ($i <> 16 - $y)) or (($i = 7 or $i = 9) and ($i = $y or $i = 16 - $y)) or (($i = 3 or $i = 13) and ($y = 7 or $y = 9)) or (($y = 3 or $y = 13) and ($i = 7 or $i = 9)) or (($i = 4 or $i = 12) and $y = 8) or (($y = 4 or $y = 12) and $i = 8) Then ;If the button is meant to be a Double Letter square, then
				_Scrabble_SpecialTile($i,$y,0xCCFE80,"DL","Letters placed over this tile will have a x2 multiplier applied to the score.") ;Apply the Double Letter color and label
			EndIf
		Next																									;Perform the next iteration of the $y For loop
	Next																										;Perform the next iteration of the $i For loop
	;Create the score keeping section
	$lPlayer1 = GUICtrlCreateLabel("Player 1 Score:", 8, (15 * $sButtonSize), 110)								;Create the Player 1 Score label in its appropriate location
		GUICtrlSetFont(-1,Round(($sButtonSize/4.12),0),900)														;Set the font size based on the button size
	$iPlayer1 = GUICtrlCreateInput("0", $sButtonSize - (17+(($sButtonSize-20)/5)), (15 * $sButtonSize) + (17+(($sButtonSize-20)/5)), 70,"",BitOR($ES_CENTER,$ES_READONLY,$ES_AUTOHSCROLL), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE)) ;Create the Player 1 Score input in its appropriate location
	$lPlayer2 = GUICtrlCreateLabel("Player 2 Score:", 8, (15 * $sButtonSize) + 50, 110)							;Create the Player 2 Score label in its appropriate location
		GUICtrlSetFont(-1,Round(($sButtonSize/4.12),0),900)														;Set the font size based on the button size
	$iPlayer2 = GUICtrlCreateInput("0", $sButtonSize - (17+(($sButtonSize-20)/5)), (15 * $sButtonSize) + (67+(($sButtonSize-20)/5)), 70,"",BitOR($ES_CENTER,$ES_READONLY,$ES_AUTOHSCROLL), BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE)) ;Create the Player 1 Score input in its appropriate location
	$lTurn = GUICtrlCreateLabel("Player 1's Turn", $sButtonSize * 3.5, (15 * $sButtonSize),110)					;Create the Player Turn label in its appropriate location
		GUICtrlSetFont(-1,Round(($sButtonSize/4.12),0),900)														;Set the font size based on the button size
			GUICtrlSetColor(-1,0xB20000)																		;Set the color to maroon
	$lLeft = GUICtrlCreateLabel("There are " & UBound($aTiles) - 1 & " tiles left.", $sButtonSize * 3.5, 25 + (15 * $sButtonSize), 160)	;Create the Tiles Left label in its appropriate location
		GUICtrlSetFont(-1,Round(($sButtonSize/4.12),0),900)														;Set the font size based on the button size
			GUICtrlSetColor(-1,0xB20000)																		;Set the color to maroon
	;Create the player tile section
	For $i = 1 to 7																								;Start a For loop. This will create each player tile button
		$aPButtons[$i] = GUICtrlCreateButton("",(($i-1) * ($sButtonSize - 1)) + (8 * $sButtonSize), 5 + (15 * $sButtonSize), $sButtonSize, $sButtonSize) ;Create the player tile buttons
			GUICtrlSetOnEvent($aPButtons[$i],"_Scrabble_ClickPlayerTile")										;Set the On Event function for each player tile
				GUICtrlSetFont($aPButtons[$i],10,900)															;Set the font of the Player Tiles to bold
	Next																										;Perform the next iteration of the For loop
	;Create the four buttons used to play the game
	$bPPlay = GUICtrlCreateButton("Play", (8 * $sButtonSize), 13 + ($sButtonSize) + (15 * $sButtonSize), ((7 * $sButtonSize)/2) - 4) ;Create the Play button
		GUICtrlSetOnEvent(-1,"_Scrabble_Play")																	;Set the On Event function for the Play button
	$bPRecall = GUICtrlCreateButton("Recall", (8 * $sButtonSize) + ((7 * $sButtonSize)/2), 13 + ($sButtonSize) + (15 * $sButtonSize), ((7 * $sButtonSize)/2) - 4) ;Create the Recall button
		GUICtrlSetOnEvent(-1,"_Scrabble_RecallTiles")															;Set the On Event function for the Recall button
	$bPSwap = GUICtrlCreateButton("Swap", (8 * $sButtonSize), 40 + ($sButtonSize) + (15 * $sButtonSize), ((7 * $sButtonSize)/2) - 4) ;Create the Swap button
		;GUICtrlSetOnEvent(-1,"_EndTiles")
	$bPResign = GUICtrlCreateButton("Pass", (8 * $sButtonSize) + ((7 * $sButtonSize)/2), 40 + ($sButtonSize) + (15 * $sButtonSize), ((7 * $sButtonSize)/2) - 4) ;Create the Resign button
		GUICtrlSetOnEvent(-1,"_Scrabble_Pass")																	;Set the On Event function for the Pass button
	GUISetState(@SW_SHOW, $gMain)																				;Show the Main GUI
EndFunc   ;==>_Scrabble_CreateBoard

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_FindWord
; Description ...: Finds the word just played and returns the results in an array with the tile's type (Blank, TW, TL, DW, DL)
; Syntax.........: _Scrabble_FindWord()
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 5/27/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_FindWord()
	Local $sLoop = 0, $sPlayCheck = ""																			;Declare the local variables used in this function
	Dim $aFindWord[1][6], $aWordHandles[1], $aVertWord[1][2], $aHorWord[1][2]									;Declare the local arrays used in this function
			;$aFindWord is used to get all of the currently played letters that aren't permanent
			;$aWordHandles is used as a 1D array with the played tile's Control ID's in it
			;$aVertWord is used to house the letters and their default labels for the _Scrabble_VerifyWord function
;Get all the placed letters that have not been permanently played
	For $i = 1 to UBound($aDButtons) - 1																		;Start a For loop. This will repeat for each of the buttons on the board
		If $aDButtons[$i][0] = 1 Then																			;If the given button has been played (state is 1), then
			ReDim $aFindWord[1 + $sLoop][6]																		;Increase the size of the holding array
			For $y = 0 to 4																						;Start a For loop. This will repeat for each of the subsections of the array
				$aFindWord[$sLoop][$y] = $aDButtons[$i][$y]														;Write the given portion to the new array
			Next																								;Perform the next iteration of the For loop
			$aFindWord[$sLoop][5] = GUICtrlRead($aDButtons[$i][4])												;Add the Control ID to the new array
			$sLoop += 1																							;Add one to the loop counter
		EndIf
	Next																										;Perform the next iteration of the For loop
	If $aFindWord[0][0] = "" Then Return -2																		;If no tiles were placed, then return -2
;Get a 1D array with the GUI Ctrl IDs
	For $i = 0 To UBound($aFindWord) - 1																		;Start a For loop. This will repeat for each placed letter
		ReDim $aWordHandles[1 + $i]																				;Increase the holding array
		$aWordHandles[$i] = $aFindWord[$i][4]																	;Write the given Control ID to the new array
	Next																										;Perform the next iteration of the For loop
;Check to see if at least one of the letters has been permanently placed, I.E. the player is building on to previously placed tiles
;Also checks to see if the player, on the first turn, places the tiles over the X
	If $sPlay <> 1 Then																							;If this is NOT the first turn, then
		For $i = 0 To (_ArrayMax($aWordHandles,1) - _ArrayMin($aWordHandles,1)) - 1								;Start a For loop. This will repeat for each tile handle
			If $aDButtons[_ArraySearch($aDButtons,$aWordHandles[0] + $i,"","","","","",4)][0] = 2 Then $sPlayCheck = $sPlayCheck & 1 ;If the tile has been permanently placed, concatenate a 1 to the string
		Next																									;Perform the next iteration of the For loop
	ElseIf $sPlay = 1 Then																						;If this is the first play, then
		For $i = 0 To (_ArrayMax($aWordHandles,1) - _ArrayMin($aWordHandles,1)) - 1								;Start a For loop. This will repeat for each tile handle
			If $aDButtons[_ArraySearch($aDButtons,$aWordHandles[0] + $i,"","","","","",4)][2] = "+" Then $sPlayCheck = $sPlayCheck & 1
		Next																									;Perform the next iteration of the For loop
		If $sPlayCheck = "" Then																				;If the $sPlayCheck variable is blank, then
			MsgBox(48,"ScrabbleIt","Please place your first word over the star to begin.")						;Display the warning box notifying the player or the error
			Return -3																							;Return -3
		EndIf
	EndIf
	$sPlay += 1																									;Increase the turn count by one
;Check if the word is vertical or horizontal
;Vertical
	If _ArrayMax($aWordHandles,1) - _ArrayMin($aWordHandles,1) < 15 Then										;If the word is a veritical word, then
		If $aDButtons[_ArraySearch($aDButtons,$aWordHandles[0] - 1,"","","","","",4)][0] = 2 Then $sPlayCheck = $sPlayCheck & 1 ;If the letter directly before the first placed letter has been played, then concatenate a 1 onto the $sPlayCheck variable
		If $aDButtons[_ArraySearch($aDButtons,$aWordHandles[UBound($aWordHandles) - 1] + 1,"","","","","",4)][0] = 2 Then $sPlayCheck = $sPlayCheck & 1 ;If the letter directly after the last placed letter has been played, then concatenate a 1 onto the $sPlayCheck variable
		If $sPlayCheck = "" Then																				;If the $sPlayCheck variable is blank, then
			MsgBox(48,"ScrabbleIt","Please attach your word to a previously played word.")						;Display the warning box notifying the player or the error
			Return -2																							;Return -2
		EndIf
		$sVertTotal = _ArrayMax($aWordHandles,1) - _ArrayMin($aWordHandles,1)									;Get the total number of letters in the word
	;Get the valid user tiles, including all in between the first and last and one on either side, if edge tile is not on the top or bottom row
		If _ArraySearch($aTopRow,$aWordHandles[0]) = -1 Then													;If the top tile is NOT in the top row, then
			$aVertWord[0][0] = GUICtrlRead($aWordHandles[0] - 1)												;Write the current label to the array
			$aVertWord[0][1] = $aDButtons[_ArraySearch($aDButtons,$aWordHandles[0] - 1,"","","","","",4)][2]	;Write the default label to the array
		EndIf
		For $i = 1 To $sVertTotal + 1																			;Start a For loop. This will repeat for all the MIDDLE letters of the word
			ReDim $aVertWord[$i + 2][2]																			;Increase the holding array size
			$aVertWord[$i][0] = GUICtrlRead(_ArrayMin($aWordHandles,1) + ($i - 1))								;Write the current label to the array
			$aVertWord[$i][1] = $aDButtons[_ArraySearch($aDButtons,_ArrayMin($aWordHandles,1) + ($i - 1),"","","","","",4)][2] ;Write the default label to the array
		Next																									;Perform the next iteration of the For loop
		If _ArraySearch($aBottomRow,_ArrayMax($aWordHandles,1)) = -1 Then 										;If the bottom tile is NOT in the bottom row, then
			$aVertWord[$sVertTotal + 2][0] = GUICtrlRead(_ArrayMax($aWordHandles,1) + 1)						;Write the current label to the array
			$aVertWord[$sVertTotal + 2][1] = $aDButtons[_ArraySearch($aDButtons,_ArrayMax($aWordHandles,1) + 1,"","","","","",4)][2] ;Write the default label to the array
		EndIf
	;Check for, and remove TW, DW, TL, DL from the array
		For $i = 0 To UBound($aVertWord) - 1																	;Start a For loop. This will repeat for each letter in the array
			If $aVertWord[$i][0] = "TW" Or $aVertWord[$i][0] = "DW" Or $aVertWord[$i][0] = "TL" Or $aVertWord[$i][0] = "DL" Then $aVertWord[$i][0] = "" ;If the array contains TW, DW, TL, or DW, erase it
		Next																									;Perform the next iteration of the For loop
	;Check for blanks in the middle of the word
		For $i = 1 To UBound($aVertWord) - 2																	;Start a For loop. This will repeat for each middle letter in the array
			If $aVertWord[$i][0] = "" Then																		;If the current label is blank, then
				MsgBox(48,"ScrabbleIt","Your word has blank spaces in it. Please correct and hit play again!")	;Report the error to the user
				Return -1																						;If there are blanks in the middle of the word, return -1
			EndIf
		Next																									;Perform the next iteration of the For loop
	;Remove the blanks from the array and return the result
		$aVertWord = _Array2DClearBlanks($aVertWord,2)															;Remove all blank lines from the array
		Return $aVertWord																						;Return the word array
	Else																										;If the word is a horizontal word, then
;Horizonal
		If $aDButtons[_ArraySearch($aDButtons,$aWordHandles[0] - 15,"","","","","",4)][0] = 2 Then $sPlayCheck = $sPlayCheck & 1 ;If the letter directly before the first placed letter has been played, then concatenate a 1 onto the $sPlayCheck variable
		If $aDButtons[_ArraySearch($aDButtons,$aWordHandles[UBound($aWordHandles) - 1] + 15,"","","","","",4)][0] = 2 Then $sPlayCheck = $sPlayCheck & 1 ;If the letter directly after the last placed letter has been played, then concatenate a 1 onto the $sPlayCheck variable
		If $sPlayCheck = "" Then																				;If the $sPlayCheck variable is blank, then
			MsgBox(48,"ScrabbleIt","Please attach your word to a previously played word.")						;Display the warning box notifying the player or the error
			Return -2																							;Return -2
		EndIf
		$sHorTotal = ((_ArrayMax($aWordHandles,1) - _ArrayMin($aWordHandles,1))/15) + 1							;Get the total number of letters in the word
	;Get the valid user tiles, including all in between the first and last and one on either side, if edge tile is not on the first or last column
		If _ArraySearch($aFirstColumn,$aWordHandles[0]) = -1 Then												;If the top tile is NOT in the first column, then
			$aHorWord[0][0] = GUICtrlRead($aWordHandles[0] - 15)													;Write the current label to the array
			$aHorWord[0][1] = $aDButtons[_ArraySearch($aDButtons,$aWordHandles[0] - 15,"","","","","",4)][2]	;Write the default label to the array
		EndIf
		For $i = 1 To $sHorTotal																				;Start a For loop. This will repeat for all the MIDDLE letters of the word
			ReDim $aHorWord[$i + 2][2]																			;Increase the holding array size
			$aHorWord[$i][0] = GUICtrlRead(_ArrayMin($aWordHandles,1) + (($i - 1) * 15))						;Write the current label to the array
			$aHorWord[$i][1] = $aDButtons[_ArraySearch($aDButtons,_ArrayMin($aWordHandles,1) + (($i - 1) * 15),"","","","","",4)][2] ;Write the default label to the array
		Next																									;Perform the next iteration of the For loop
		If _ArraySearch($aLastColumn,_ArrayMax($aWordHandles,1)) = -1 Then 										;If the last tile is NOT in the last row, then
			$aHorWord[$sHorTotal + 1][0] = GUICtrlRead(_ArrayMax($aWordHandles,1) + 15)							;Write the current label to the array
			$aHorWord[$sHorTotal + 1][1] = $aDButtons[_ArraySearch($aDButtons,_ArrayMax($aWordHandles,1) + 15,"","","","","",4)][2] ;Write the default label to the array
		EndIf
	;Check for, and remove TW, DW, TL, DL from the array
		For $i = 0 To UBound($aHorWord) - 1																		;Start a For loop. This will repeat for each letter in the array
			If $aHorWord[$i][0] = "TW" Or $aHorWord[$i][0] = "DW" Or $aHorWord[$i][0] = "TL" Or $aHorWord[$i][0] = "DL" Then $aHorWord[$i][0] = "" ;If the array contains TW, DW, TL, or DW, erase it
		Next																									;Perform the next iteration of the For loop
	;Check for blanks in the middle of the word
		For $i = 1 To UBound($aHorWord) - 2																		;Start a For loop. This will repeat for each middle letter in the array
			If $aHorWord[$i][0] = "" Then																		;If the current label is blank, then
				MsgBox(48,"ScrabbleIt","Your word has blank spaces in it. Please correct and hit play again!")	;Report the error to the user
				Return -1																						;If there are blanks in the middle of the word, return -1
			EndIf
		Next																									;Perform the next iteration of the For loop
	;Remove the blanks from the array and return the result
		$aHorWord = _Array2DClearBlanks($aHorWord,2)															;Remove all blank lines from the array
		Return $aHorWord																						;Return the horizontal word
	EndIf
EndFunc   ;==>_Scrabble_FindWord

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_GetLetterScore
; Description ...: Reads the score of the given letter from the score array and returns it
; Syntax.........: _Scrabble_GetLetterScore( $sLetter )
; Parameters ....: $sLetter - The given letter to find the score of
; Return values .: The score of the letter
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Requires the following global variable to be declared at the beginning of the script:
;
;					Global $aScores[27][2] = [["_",0],["E",1],["A",1],["I",1],["O",1],["R",1],["N",1],["T",1],["L",1],["S",1], _
;											  ["U",1],["D",2],["G",2],["B",3],["C",3],["M",3],["P",3],["F",4],["H",4],["V",4], _
;											  ["W",4],["Y",4],["K",5],["J",8],["X",8],["Q",10],["Z",10]]
;
; Modified.......: 4/20/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_GetLetterScore($sLetter)
	Return $aScores[_ArraySearch($aScores,$sLetter)][1]															;Reads the score of the given letter from the score array and returns it
EndFunc   ;==>_Scrabble_GetLetterScore

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_GetTiles
; Description ...: Returns a given amount of tiles randomly from the $aTiles array, while also removing them from play
; Syntax.........: _Scrabble_GetTiles( $sAmount )
; Parameters ....: $sAmount - The number of tiles to return from the $aTiles array
; Return values .: An array with the new tiles
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Requires #include <Array.au3> and the following variable declared at the beginning of the script:
;
;					Global $lLeft
;
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_GetTiles($sAmount)
	Local $sRadom																								;Declare the local variable $sRandom to be used internally in this function
	Dim $aNewTiles[2]																							;Declare the array to be used internally in this function
	If $sAmount = 0 Then Return																					;If the player needs no new tiles, return
	For $i = 1 to $sAmount																						;Start a For loop. This will repeat for each of the tiles
		ReDim $aNewTiles[2 + $i]																				;Increase the $aNewTiles array by one
		$sRandom = Random(0,UBound($aTiles)- 1,1)																;Pick a random tile from the $aTiles array and write to
			$aNewTiles[$i] = $aTiles[$sRandom]																	;Write the random tile from the $aTiles array to the $aNewTiles array
		_ArrayDelete($aTiles,$sRandom)																			;Delete the random tile from the $aTiles array, removing it from future play
	Next																										;Perform the next iteration of the For loop
	GUICtrlSetData($lLeft,"There are " & UBound($aTiles) - 1 & " tiles left.")									;Set the "Tiles Left" label to the new number
	Return $aNewTiles																							;Return the given number of new tiles
EndFunc   ;==>_Scrabble_GetTiles

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_GetWordScore
; Description ...: Calculates the score for the given word, including multipliers
; Syntax.........: _Scrabble_GetWordScore( $aWord )
; Parameters ....: $aWord - An array containing the word to be scored. This array must be in the following format:
;					$aWord[0][0]  - The first letter of the word		$aWord[0][1]  - The multiplier of the word (or blank if no multiplier)
;					$aWord[$n][0] - The last letter of the word			$aWord[$n][1] - The multiplier of the word (or blank if no multiplier)
;
;					An example would be the word DOG with a TL multiplier on D and a TW multiplier on G:
;						$aWord[3][2] = [["D","TL"],["O",""],["G","TW"]]
;
; Return values .: The score of the word
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 4/20/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_GetWordScore($aWord)
	Local $sScore = 0, $sTW = 1, $sDW = 1															;Declare the local variables for use in this function
	For $i = 0 to UBound($aWord) - 1																;Start a For loop. This will repeat for each letter given
		$sLetterScore = _Scrabble_GetLetterScore($aWord[$i][0])										;Get the letter score of the given letter
		If $aWord[$i][1] = "TW" Then $sTW = $sTW * 3												;If the qualifier of the letter is TW, multiply $sTW by 3
		If $aWord[$i][1] = "DW" Then $sDW = $sDW * 2												;If the qualifier of the letter is DW, multiply $sDW by 2
		If $aWord[$i][1] = "TL" Then $sLetterScore = $sLetterScore * 3								;If the qualifier of the letter is TL, multiply the current letter score by 3
		If $aWord[$i][1] = "DL" Then $sLetterScore = $sLetterScore * 2								;If the qualifier of the letter is DL, multiply the current letter score by 2
		$sScore = $sScore + $sLetterScore															;Add the letter score to the overall word score
	Next																							;Perform the next iteration of the For loop
	Return $sScore * $sTW * $sDW																	;Return the word score including the triple and double word multipliers
EndFunc   ;==>_Scrabble_GetWordScore

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_Pass
; Description ...: Performs the pass function in Scrabble. Swaps players and adds one to the pass limit variable
; Syntax.........: _Scrabble_Pass()
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 5/27/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_Pass()
	$sPass = MsgBox(36,"ScrabbleIt","Are you sure you wish to pass?")												;Prompt the user to be sure they want to pass
	If $sPass = 7 Then Return																						;If they don't, then return
	If $sPassLimit = 6 Then																							;If the $sPassLimit variable is 6, then
		MsgBox(48,"ScrabbleIt","There have been six consecutive passes. The game is a draw.")						;Notify the users the game has ended
		Return																										;Return out of the function
	EndIf
	If $iPlayer = 1 Then																							;If it is player one's turn, then
		For $i = 0 to 6																								;Start a For loop. This will repeat for each player tile
			$aP1Tiles[$i] = GUICtrlRead($aPButtons[$i + 1])															;Read the values of each player tile
		Next																										;Perform the next iteration of the For loop
		$aP1Tiles = _Array2DClearBlanks($aP1Tiles,0)																;Clear all blank entries from the tile list
		_Scrabble_UpdatePlayer(1)																					;Run the _Scrabble_UpdatePlayer function for player 1
		For $i = 1 to 7																								;Start a For loop. This will repeat for each player tile
			GUICtrlSetData($aPButtons[$i],"")																		;Set the player tile labels to blank
			GUICtrlSetBkColor($aPButtons[$i],0xFE80B9)																;set the player tile colors to a pink color
		Next																										;Perform the next iteration of the For loop
		MsgBox(64,"ScrabbleIt","Please swap players")																;Prompt the users to swap places
		_Scrabble_UpdatePlayer(2)																					;Run the _Scrabble_UpdatePlayer function for player 2
		GUICtrlSetData($lTurn,"Player 2's Turn")																	;Change the player label to show Player 2's turn
		$iPlayer = 2																								;Set the turn variable $iPlayer to 2
	ElseIf $iPlayer = 2 Then																						;If it is player two's turn, then
		For $i = 0 to 6																								;Start a For loop. This will repeat for each player tile
			$aP2Tiles[$i] = GUICtrlRead($aPButtons[$i + 1])															;Read the values of each player tile
		Next																										;Perform the next iteration of the For loop
		$aP2Tiles = _Array2DClearBlanks($aP2Tiles,0)																;Clear all blank entries from the tile list
		_Scrabble_UpdatePlayer(2)																					;Run the _Scrabble_UpdatePlayer function for player 2
		For $i = 1 to 7																								;Start a For loop. This will repeat for each player tile
			GUICtrlSetData($aPButtons[$i],"")																		;Set the player tile labels to blank
			GUICtrlSetBkColor($aPButtons[$i],0xFE80B9)																;set the player tile colors to a pink color
		Next																										;Perform the next iteration of the For loop
		MsgBox(64,"ScrabbleIt","Please swap players")																;Prompt the users to swap places
		_Scrabble_UpdatePlayer(1)																					;Run the _Scrabble_UpdatePlayer function for player 1
		GUICtrlSetData($lTurn,"Player 1's Turn")																	;Change the player label to show Player 1's turn
		$iPlayer = 1																								;Set the turn variable $iPlayer to 1
	EndIf
	$cLetter = ""																									;Set the $cLetter to blank, indicating no letter is chosen
	$sLetter = ""																									;Set the $sLetter to blank, indicating no letter is chosen
	$sPassLimit += 1																								;Increase the $sPassLimit by 1
EndFunc   ;==>_Scrabble_Pass

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_Play
; Description ...: Run when the player hits the "Play" button. Checks the given word for validty, scores it, and swaps players
; Syntax.........: _Scrabble_Play()
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 5/27/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_Play()
	Local $sPlayWord																								;Declare the local variables for use in this function
	Dim $aPlayWord																									;Initialize the $aPlayWord array
	$aPlayWord = _Scrabble_FindWord()																				;Run the _Scrabble_FindWord function and save the result
	If $aPlayWord = -1 or $aPlayWord = -2 or $aPlayWord = -3 Then Return -1											;If the above function errored out, then return -1
	$sPlayWord = _Scrabble_ConvertWord($aPlayWord)																	;Convert the arrayed word into a string for verification
	If _Scrabble_VerifyWord($sPlayWord) = True Then																	;If the word is an acceptable word, then
		$sPoints = _Scrabble_GetWordScore($aPlayWord)																;Get the score of the word using the word array
		MsgBox(64,"ScrabbleIt","You played " & $sPlayWord & " for a total of " & $sPoints & " points.")				;Notify the user of the play and the points
		If $iPlayer = 1 Then GUICtrlSetData($iPlayer1,GUICtrlRead($iPlayer1) + $sPoints)							;Add the points to player one's score as needed
		If $iPlayer = 2 Then GUICtrlSetData($iPlayer2,GUICtrlRead($iPlayer2) + $sPoints)							;Add the points to player two's score as needed
		;Change the tile to permenantly played
		For $i = 1 to UBound($aDButtons) - 1																		;Start a For loop. This will repeat for each of the buttons on the board
			If $aDButtons[$i][0] = 1 Then																			;If the given button has been played (state is 1), then
				$aDButtons[$i][0] = 2																				;Set the state of the button to 2 (permenantly played)
				GUICtrlSetBkColor($aDButtons[$i][4],0xFFCC00)														;Change the color to a darker yellow/orange to indicate its state
			EndIf
		Next																										;Perform the next iteration of the For loop
		;Change the player turn and update the tile arrays and buttons
		If $iPlayer = 1 Then																						;If it is player one's turn, then
			For $i = 0 to 6																							;Start a For loop. This will repeat for each player tile
				$aP1Tiles[$i] = GUICtrlRead($aPButtons[$i + 1])														;Read the values of each player tile
			Next																									;Perform the next iteration of the For loop
			$aP1Tiles = _Array2DClearBlanks($aP1Tiles,0)															;Clear all blank entries from the tile list
			_Scrabble_UpdatePlayer(1)																				;Run the _Scrabble_UpdatePlayer function for player 1
			For $i = 1 to 7																							;Start a For loop. This will repeat for each player tile
				GUICtrlSetData($aPButtons[$i],"")																	;Set the player tile labels to blank
				GUICtrlSetBkColor($aPButtons[$i],0xFE80B9)															;set the player tile colors to a pink color
			Next																									;Perform the next iteration of the For loop
			MsgBox(64,"ScrabbleIt","Please swap players")															;Prompt the users to swap places
			_Scrabble_UpdatePlayer(2)																				;Run the _Scrabble_UpdatePlayer function for player 2
			GUICtrlSetData($lTurn,"Player 2's Turn")																;Change the player label to show Player 2's turn
			$iPlayer = 2																							;Set the turn variable $iPlayer to 2
		ElseIf $iPlayer = 2 Then																					;If it is player two's turn, then
			For $i = 0 to 6																							;Start a For loop. This will repeat for each player tile
				$aP2Tiles[$i] = GUICtrlRead($aPButtons[$i + 1])														;Read the values of each player tile
			Next																									;Perform the next iteration of the For loop
			$aP2Tiles = _Array2DClearBlanks($aP2Tiles,0)															;Clear all blank entries from the tile list
			_Scrabble_UpdatePlayer(2)																				;Run the _Scrabble_UpdatePlayer function for player 2
			For $i = 1 to 7																							;Start a For loop. This will repeat for each player tile
				GUICtrlSetData($aPButtons[$i],"")																	;Set the player tile labels to blank
				GUICtrlSetBkColor($aPButtons[$i],0xFE80B9)															;set the player tile colors to a pink color
			Next																									;Perform the next iteration of the For loop
			MsgBox(64,"ScrabbleIt","Please swap players")															;Prompt the users to swap places
			_Scrabble_UpdatePlayer(1)																				;Run the _Scrabble_UpdatePlayer function for player 1
			GUICtrlSetData($lTurn,"Player 1's Turn")																;Change the player label to show Player 1's turn
			$iPlayer = 1																							;Set the turn variable $iPlayer to 1
		EndIf
		$cLetter = ""																								;Set the $cLetter to blank, indicating no letter is chosen
		$sLetter = ""																								;Set the $sLetter to blank, indicating no letter is chosen
		$sPassLimit = 0																								;Initialize the $sPassLimit variable
	ElseIf _Scrabble_VerifyWord($sPlayWord) = False Then															;If the word is not an acceptable word, then
		$sPlay -= 1																									;Remove one from the play count
		MsgBox(64,"ScrabbleIt",$sPlayWord & " is not a valid word.")												;Notify the user of the invalidity of the word
	EndIf
EndFunc   ;==>_Scrabble_Play

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_RecallTiles
; Description ...: Recalls all tiles that have been placed, but not played (in state 1) from the game board
; Syntax.........: _Scrabble_RecallTiles()
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_RecallTiles()
	For $i = 1 to UBound($aDButtons) - 1																		;Start a For loop. This will repeat for every button on the game board
		If $aDButtons[$i][0] = 1 Then																			;If the current button's state is 1, indicating there is a tile that has been placed but not played on it, then
			For $y = 1 to 7																						;Start a For loop. This will repeat for each of the Player Tiles
				If GUICtrlRead($aPButtons[$y]) = "" Then														;If the current button is blank (no tile is on it), then
					GUICtrlSetData($aPButtons[$y],GUICtrlRead($aDButtons[$i][4]))								;Set the label of the "blank Player Tile" to the label of the current Board Tile
					GUICtrlSetTip($aPButtons[$y], GUICtrlRead($aDButtons[$i][4]) & " is worth " & _Scrabble_GetLetterScore(GUICtrlRead($aDButtons[$i][4]))) ;Set the hint tip of the "blank Player Tile" to the hint tip of the current Board Tile
					GUICtrlSetBkColor($aPButtons[$y],0xFFE500)													;Set the color of the "blank Player Tile" to a mustard yellow, to indicate a tile is now on it
					ExitLoop																					;Exit the For loop early
				EndIf
			Next																								;Perform the next iteration of the For loop
			GUICtrlSetFont($aDButtons[$i][4],8.5,400)															;Set the Board Tile back to it's default font
			GUICtrlSetBkColor($aDButtons[$i][4], $aDButtons[$i][1])												;Set the Board Tile back to it's default color
			GUICtrlSetData($aDButtons[$i][4], $aDButtons[$i][2])												;Set the Board Tile back to it's default label
			GUICtrlSetTip($aDButtons[$i][4], $aDButtons[$i][3])													;Set the Board Tile back to it's default hint tip
			$aDButtons[$i][0] = 0																				;Set the Board Tile's state back to 0, indicating it has no tile on it
		EndIf
	Next																										;Perform the next iteration of the For loop
	$sLetter = ""																								;Initialize the $sLetter variable
	$cLetter = ""																								;Initialize the $cLetter variable
EndFunc   ;==>_Scrabble_RecallTiles

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_SpecialTile
; Description ...: Creates the special tiles (TW, DW, TL, DL), sets their default values, and changes their physical look
; Syntax.........: _Scrabble_SpecialTile( $sI, $sY, $sColor, $sCaption, $sTip )
; Parameters ....: $sI 			- The $i column value of the button
;				   $sY			- The $y column value of the button
;				   $sColor		- The hex color of the button
;				   $sCaption	- The label to be shown on the button
;				   $sTip		- The hint tip for the button
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_SpecialTile($sI, $sY, $sColor, $sCaption, $sTip)
	$aDButtons[$aTButtons[$sI][$sY]][1] = $sColor																;Set the given button's default color to the given color
	$aDButtons[$aTButtons[$sI][$sY]][2] = $sCaption																;Set the given button's default label to the given label
	$aDButtons[$aTButtons[$sI][$sY]][3] = $sTip																	;Set the given button's default hint tip to the given hint tip
	GUICtrlSetBkColor($aTButtons[$sI][$sY],$sColor)																;Set the button's color to the given color
	GUICtrlSetData($aTButtons[$sI][$sY],$sCaption)																;Set the button's label to the given label
	GUICtrlSetTip($aTButtons[$sI][$sY],$sTip)																	;Set the button's hint tip to the given hint tip
EndFunc   ;==>_Scrabble_SpecialTile

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_UpdatePlayer
; Description ...: Updates the player's tile arrays as well as the "Player Tiles"
; Syntax.........: _Scrabble_UpdatePlayer( $sPlayer )
; Parameters ....: $sPlayer - The current player to update. 0 is for the start of the game, 1 is player 1, and 2 is player 2. Default is 0
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Requires #include <Array.au3> and the following variables declared at the beginning of the script:
;
;					Global $aP1Tiles[8], $aP2Tiles[8]
;
; Modified.......: 4/23/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_UpdatePlayer($sPlayer = 0)
	Dim $aNTiles																								;Initialize the $aNTiles array
	;This section updates both players at the beginning of the game
	If $sPlayer = 0 Then																						;If the given player number is 0, then
		$aNTiles = _Scrabble_GetTiles(7)																		;Get all 7 new tiles
			For $i = 1 To 7																						;Start a For loop. Will repeat 7 times
				$aP1Tiles[$i] = $aNTiles[$i]																	;Assign the new tile values to Player 1's tiles
			Next																								;Perform the next iteration of the For loop
		$aNTiles = _Scrabble_GetTiles(7)																		;Get all 7 new tiles
			For $i = 1 To 7																						;Start a For loop. Will repeat 7 times
				$aP2Tiles[$i] = $aNTiles[$i]																	;Assign the new tile values to Player 2's tiles
			Next																								;Perform the next iteration of the For loop
		$sPlayer = 1																							;Set the $sPlayer value to 1, thus running Player 1's update as well
	EndIf
	;This section updates player 1's tiles only
	If $sPlayer = 1 Then																						;If the given player number is 1, then
		$aP1Tiles = _Array2DClearBlanks($aP1Tiles,0)															;Clear the blank spaces out of Player 1's tile array
		If UBound($aP1Tiles) <> 8 Then																			;If the player tiles aren't full, then
			$aNTiles = _Scrabble_GetTiles(7 - UBound($aP1Tiles))												;Get the remainder of the tiles from the main tile group
			For $i = 1 to UBound($aNTiles) - 1																	;Start a For loop. This will repeat for each of the new tiles
				_ArrayAdd($aP1Tiles,$aNTiles[$i])																;Add any new tiles needed to Player 1's tile array
			Next																								;Perform the next iteration of the For loop
		EndIf
		For $i = 0 to 6																							;Start a For loop. This will repeat 7 times
			GUICtrlSetData($aPButtons[$i + 1],$aP1Tiles[$i])													;Set the given button's label to the tile letter
			GUICtrlSetTip($aPButtons[$i + 1],$aP1Tiles[$i] & " is worth " & _Scrabble_GetLetterScore($aP1Tiles[$i])) ;Set the given button's hint tip to the given letter's score
			GUICtrlSetBkColor($aPButtons[$i + 1],0xFFE500)														;Set the background color of the given button to a mustard yellow color
		Next																									;Perform the next iteration of the For loop
		Return																									;Exit the function
	EndIf
	;This section updates player 2's tiles only
	If $sPlayer = 2 Then																						;If the given player number is 2, then
		$aP2Tiles = _Array2DClearBlanks($aP2Tiles,0)															;Clear the blank spaces out of Player 2's tile array
		If UBound($aP2Tiles) <> 8 Then																			;If the player tiles aren't full, then
			$aNTiles = _Scrabble_GetTiles(7 - UBound($aP2Tiles))												;Get the remainder of the tiles from the main tile group
			For $i = 1 to UBound($aNTiles) - 1																	;Start a For loop. This will repeat for each of the new tiles
				_ArrayAdd($aP2Tiles,$aNTiles[$i])																;Add any new tiles needed to Player 1's tile array
			Next																								;Perform the next iteration of the For loop
		EndIf
		For $i = 0 to 6 																						;Start a For loop. This will repeat 7 times
			GUICtrlSetData($aPButtons[$i + 1],$aP2Tiles[$i])													;Set the given button's label to the tile letter
			GUICtrlSetTip($aPButtons[$i + 1],$aP2Tiles[$i] & " is worth " & _Scrabble_GetLetterScore($aP2Tiles[$i])) ;Set the given button's hint tip to the given letter's score
			GUICtrlSetBkColor($aPButtons[$i + 1],0xFFE500)														;Set the background color of the given button to a mustard yellow color
		Next																									;Perform the next iteration of the For loop
		;$aP1Tiles[7] = ""																						;Set the $aP2Tiles to blank, as the spot is needed but not used
		Return																									;Exit the function
	EndIf
EndFunc   ;==>_Scrabble_UpdatePlayer

; #FUNCTION# ====================================================================================================================
; Name...........: _Scrabble_VerifyWord
; Description ...: Checks the veracity of the given word against a list of legal Scrabble words
; Syntax.........: _Scrabble_VerifyWord ( $sWord )
; Parameters ....: $sWord - The word to check the veracity of
; Return values .: True  - The word was found and is a legal Scrabble word
;				   False - The word was not found and is not a legal Scrabble word
; Author ........: Kris Mills <fett8802 at gmail dot com>
; Remarks .......: Requires the ScrabbleWords.txt text file containing the complete list of legal Scrabble words
;				   Also requires the following global variable declared at the top of the script:
;
;					Global $sWordList = FileRead("ScrabbleWords.txt")
;
; Modified.......: 4/20/2011 - Created, commented, and added function header
; ===============================================================================================================================
Func _Scrabble_VerifyWord($sWord)
	If StringInStr($sWordList,$sWord) <> 0 Then Return True														;If the word is found in the word list, then return True
	If StringInStr($sWordList,$sWord) = 0 Then Return False														;If the word is not found in the word list, then return False
EndFunc   ;==>_Scrabble_VerifyWord
