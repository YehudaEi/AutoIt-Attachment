#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("TrayIconDebug", 1)
Opt("GUIOnEventMode", 1)
Global $Q1, $Q2, $Q3, $Q4, $Q5, $Q6, $Q7, $Q8, $Q9
Global $Player1, $Player2, $Player1_In, $Player2_In
Global $P1_Loses, $P1_Wins, $P2_Loses, $P2_Wins
Global $sPlayer1_Read, $sPlayer2_Read
Global $Turn_X = False, $Turn_O = False
Global $Pic_X = @ScriptDir & "\x.bmp"
Global $Pic_O = @ScriptDir & "\o.bmp"
Global $Q1_X, $Q2_X, $Q3_X, $Q4_X, $Q5_X, $Q6_X, $Q7_X, $Q8_X, $Q9_X 
Global $Q1_O, $Q2_O, $Q3_O, $Q4_O, $Q5_O, $Q6_O, $Q7_O, $Q8_O, $Q9_O
Global $X_Wins = 0, $X_Loses = 0
Global $O_Wins = 0, $O_Loses = 0
Global $Cats1 = False, $Cats2 = False, $Cats3 = False, $Cats4 = False 
Global $Cats5 = False, $Cats6 = False, $Cats7 = False, $Cats8 = False, $Cats9 = False
Global $aCats[9] = [$Q1, $Q2, $Q3, $Q4, $Q5, $Q6, $Q7, $Q8, $Q9]
Global $abCats[9] = [$Cats1, $Cats2, $Cats3, $Cats4, $Cats5, $Cats6, $Cats7, $Cats8, $Cats9]

;~  Main Game
$Main = GUICreate("Tic Tac Toe", 594, 609, 203, 117)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUICtrlCreateGraphic(192, 112, 17, 417, BitOR($SS_CENTER,$SS_RIGHT,$SS_BLACKRECT,$SS_GRAYRECT,$SS_WHITERECT,$SS_BLACKFRAME,$SS_NOTIFY))
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(384, 112, 17, 417, BitOR($SS_CENTER,$SS_RIGHT,$SS_BLACKRECT,$SS_GRAYRECT,$SS_WHITERECT,$SS_BLACKFRAME,$SS_NOTIFY))
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(8, 224, 553, 17)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(8, 392, 553, 17)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x000000)
$Q1 = GUICtrlCreateCheckbox("Q1", 72, 152, 17, 17)
	GUICtrlSetOnEvent(-1, "Q1Click")
$Q2 = GUICtrlCreateCheckbox("Q1", 285, 150, 17, 17)
	GUICtrlSetOnEvent(-1, "Q2Click")
$Q3 = GUICtrlCreateCheckbox("Q1", 469, 157, 17, 17)
	GUICtrlSetOnEvent(-1, "Q3Click")
$Q4 = GUICtrlCreateCheckbox("Q1", 80, 314, 17, 17)
	GUICtrlSetOnEvent(-1, "Q4Click")
$Q5 = GUICtrlCreateCheckbox("Q1", 288, 305, 17, 17)
	GUICtrlSetOnEvent(-1, "Q5Click")
$Q6 = GUICtrlCreateCheckbox("Q1", 483, 308, 17, 17)
	GUICtrlSetOnEvent(-1, "Q6Click")
$Q7 = GUICtrlCreateCheckbox("Q1", 93, 472, 17, 17)
	GUICtrlSetOnEvent(-1, "Q7Click")
$Q8 = GUICtrlCreateCheckbox("Q1", 297, 473, 17, 17)
	GUICtrlSetOnEvent(-1, "Q8Click")
$Q9 = GUICtrlCreateCheckbox("Q1", 483, 475, 17, 17)
	GUICtrlSetOnEvent(-1, "Q9Click")
$Pic1 = GUICtrlCreatePic("", 8, 112, 177, 113, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic2 = GUICtrlCreatePic("", 208, 112, 177, 113, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic3 = GUICtrlCreatePic("", 408, 120, 153, 105, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic4 = GUICtrlCreatePic("", 8, 248, 177, 137, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic5 = GUICtrlCreatePic("", 216, 248, 161, 137, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic6 = GUICtrlCreatePic("", 408, 248, 153, 137, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic7 = GUICtrlCreatePic("", 8, 416, 177, 121, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic8 = GUICtrlCreatePic("", 216, 416, 161, 121, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Pic9 = GUICtrlCreatePic("", 408, 416, 153, 121, BitOR($SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS))
$Player1 = GUICtrlCreateLabel("", 80, 8, 74, 26)
	GUICtrlSetFont(-1, 14, 800, 0, "Arial")
$Player2 = GUICtrlCreateLabel("", 296, 8, 74, 26)
	GUICtrlSetFont(-1, 14, 800, 0, "Arial")
GUICtrlCreateLabel("Wins:", 8, 40, 48, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlCreateLabel("Wins:", 222, 40, 48, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlCreateLabel("Loses:", 8, 72, 57, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlCreateLabel("Loses:", 221, 72, 57, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$P1_Wins = GUICtrlCreateLabel("0", 80, 40, 71, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$P1_Loses = GUICtrlCreateLabel("0", 80, 72, 71, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$P2_Wins = GUICtrlCreateLabel("0", 297, 37, 71, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$P2_Loses = GUICtrlCreateLabel("0", 300, 67, 71, 23)
	GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$Menu = GUICtrlCreateMenu("&File")
GUICtrlCreateMenuItem("&New Game", $Menu)
	GUICtrlSetOnEvent(-1, "_PlayAgain")
GUICtrlCreateMenuItem("&About", $Menu)
;~ 	GUICtrlSetOnEvent(-1, "About")
GUICtrlCreateMenuItem("&Exit", $Menu)
	GUICtrlSetOnEvent(-1, "Form1Close")
GUISetState (@SW_SHOW)


;~  New Game screen
$NewGame = GUICreate("New Game", 345, 206, 307, 214)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUICtrlCreateLabel("Playing X:", 16, 56, 68, 22)
	GUICtrlSetFont(-1, 10, 800, 0, "Sylfaen")
GUICtrlCreateLabel("Playing O:", 16, 104, 70, 22)
	GUICtrlSetFont(-1, 10, 800, 0, "Sylfaen")
GUICtrlCreateLabel("Who's playing this round?", 88, 8, 201, 26)
	GUICtrlSetFont(-1, 12, 800, 0, "Sylfaen")
$Player1_In = GUICtrlCreateInput("Player 1", 96, 56, 177, 21)
$Player2_In = GUICtrlCreateInput("Player 2", 96, 96, 177, 21)
$Start_btn = GUICtrlCreateButton("Start", 40, 152, 105, 33, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, "Start_btnClick")
$Exit_btn = GUICtrlCreateButton("Exit", 197, 153, 105, 33, 0)
	GUICtrlSetOnEvent(-1, "Form1Close")
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func Form1Close()
	Exit
EndFunc

Func Start_btnClick ()
	$sPlayer1_Read = GUICtrlRead ($Player1_In, 1)
	$sPlayer2_Read = GUICtrlRead ($Player2_In, 1)
	GUICtrlSetData ($Player1, $sPlayer1_Read)
	GUICtrlSetData ($Player2, $sPlayer2_Read)
	$Turn_X = True
	GUISetState (@SW_HIDE)
	MsgBox (32, "Turn", $sPlayer1_Read & " goes first.")
EndFunc

Func MenuItem1Click()
	
EndFunc

Func Q1Click()
	GuiCtrlSetState ($Q1, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic1, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q1_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic1, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q1_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q2Click()
	GuiCtrlSetState ($Q2, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic2, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q2_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic2, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q2_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q3Click()
	GuiCtrlSetState ($Q3, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic3, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q3_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic3, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q3_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q4Click()
	GuiCtrlSetState ($Q4, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic4, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q4_X = True
		_WinnerO ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic4, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q4_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q5Click()
	GuiCtrlSetState ($Q5, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic5, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q5_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic5, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q5_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q6Click()
	GuiCtrlSetState($Q6, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic6, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q6_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic6, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q6_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q7Click()
	GuiCtrlSetState ($Q7, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic7, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q7_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic7, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q7_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q8Click()
	GuiCtrlSetState ($Q8, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic8, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q8_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic8, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q8_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func Q9Click()
	GuiCtrlSetState ($Q9, $GUI_HIDE)
	If $Turn_X = True Then
		GUICtrlSetImage ($Pic9, $Pic_X)
		$Turn_X = False
		$Turn_O = True
		$Q9_X = True
		_WinnerX ()
	Else
		If $Turn_O = True Then
			GUICtrlSetImage ($Pic9, $Pic_O)
			$Turn_X = True
			$Turn_O = False
			$Q9_O = True
			_WinnerO ()
		EndIf
	EndIf
EndFunc

Func _WinnerX ()
	Select
		Case $Q1_X And $Q2_X And $Q3_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q1_X And $Q4_X And $Q7_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q1_X And $Q5_X And $Q9_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q2_X And $Q5_X And $Q8_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q3_X And $Q6_X And $Q9_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q4_X And $Q5_X And $Q6_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q7_X And $Q5_X And $Q3_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q7_X And $Q8_X And $Q9_X = True
			$Again = MsgBox (52, "Winner!", $sPlayer1_Read & " wins! Play again?")
				IF $Again = 6 Then
					$X_Wins = $X_Wins + 1
					$O_Loses = $O_Loses + 1
					GUICtrlSetData ($P1_Wins, $X_Wins)
					GUICtrlSetData ($P2_Loses, $O_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		EndSelect
	
	For $n = 0 To UBound ($aCats) - 1
		If BitAND(GUICtrlRead ($aCats[$n]), $GUI_CHECKED) = $GUI_CHECKED Then $abCats[$n] = True
	Next
	
	If $abCats[0] And $abCats[1] And $abCats[2] And $abCats[3] And _
	$abCats[4]And $abCats[5] And $abCats[6] And $abCats[7] And $abCats[8] = True Then
		$Msg = MsgBox (52, "Cats Game!", "Cats Games! No one wins!" & @LF & _
					"Would you like to play again?") 
			If $Msg = 6 Then
				_PlayAgain ()
			EndIF
	EndIF		
EndFunc

Func _WinnerO ()
	Select
		Case $Q1_O And $Q2_O And $Q3_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q1_O And $Q4_O And $Q7_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q1_O And $Q5_O And $Q9_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q2_O And $Q5_O And $Q8_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q3_O And $Q6_O And $Q9_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q4_O And $Q5_O And $Q6_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q7_O And $Q5_O And $Q3_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		Case $Q7_O And $Q8_O And $Q9_O = True
			$Again = MsgBox (52, "Winner!", $sPlayer2_Read & " wins! Play again?")
				IF $Again = 6 Then
					$O_Wins = $O_Wins + 1
					$X_Loses = $X_Loses + 1
					GUICtrlSetData ($P2_Wins, $O_Wins)
					GUICtrlSetData ($P1_Loses, $X_Loses)
					_PlayAgain ()
				Else
					MsgBox (32, "Thanks!", "Thanks for playing!")
				EndIf
		EndSelect
	
	For $n = 0 To UBound ($aCats) - 1
		If BitAND(GUICtrlRead ($aCats[$n]), $GUI_CHECKED) = $GUI_CHECKED Then $abCats[$n] = True
	Next
	
	If $abCats[0] And $abCats[1] And $abCats[2] And $abCats[3] And _
	$abCats[4]And $abCats[5] And $abCats[6] And $abCats[7] And $abCats[8] = True Then
		$Msg = MsgBox (52, "Cats Game!", "Cats Games! No one wins!" & @LF & _
					"Would you like to play again?") 
			If $Msg = 6 Then
				_PlayAgain ()
			EndIF
	EndIF			
EndFunc
	
Func _PlayAgain ()
	Global $Q1_X = False, $Q2_X = False, $Q3_X = False, $Q4_X = False, $Q5_X = False 
	Global $Q6_X = False, $Q7_X = False, $Q8_X = False, $Q9_X = False
	Global $Q1_O = False, $Q2_O = False, $Q3_O = False, $Q4_O = False, $Q5_O = False
	Global $Q6_O = False, $Q7_O = False, $Q8_O = False, $Q9_O = False
	Local $aPics [9] = [$Pic1, $Pic2, $Pic3, $Pic4, $Pic5, $Pic6, $Pic7, $Pic8, $Pic9]
	Local $aBtns [9] = [$Q1, $Q2, $Q3, $Q4, $Q5, $Q6, $Q7, $Q8, $Q9]
	
	For $n = 0 To UBound ($aPics) - 1
		GUICtrlSetImage ($aPics[$n], "")
	Next
	
	For $n = 0 To UBound ($aBtns) - 1
		GuiCtrlSetState ($aBtns[$n] ,Bitor($GUI_SHOW , $GUI_UNCHECKED))
	Next
	
	$NewPlayers = MsgBox (36, "Players", "Would you like to use the same players?")
		If $NewPlayers = 7 Then
			$O_Wins = 0
			$O_Loses = 0
			$X_Loses = 0
			$X_Wins = 0
			
			GUICtrlSetData ($P2_Wins, $O_Wins)
			GUICtrlSetData ($P2_Loses, $O_Loses)
			GUICtrlSetData ($P1_Loses, $X_Loses)
			GUICtrlSetData ($P1_Wins, $X_Wins)
					
			$NewGame = GUICreate("New Game", 345, 206, 307, 214)
				GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
			GUICtrlCreateLabel("Playing X:", 16, 56, 68, 22)
				GUICtrlSetFont(-1, 10, 800, 0, "Sylfaen")
			GUICtrlCreateLabel("Playing O:", 16, 104, 70, 22)
				GUICtrlSetFont(-1, 10, 800, 0, "Sylfaen")
			GUICtrlCreateLabel("Who's playing this round?", 88, 8, 201, 26)
				GUICtrlSetFont(-1, 12, 800, 0, "Sylfaen")
			$Player1_In = GUICtrlCreateInput("Player 1", 96, 56, 177, 21)
			$Player2_In = GUICtrlCreateInput("Player 2", 96, 96, 177, 21)
			$Start_btn = GUICtrlCreateButton("Start", 40, 152, 105, 33, $BS_DEFPUSHBUTTON)
				GUICtrlSetOnEvent(-1, "Start_btnClick")
			$Exit_btn = GUICtrlCreateButton("Exit", 197, 153, 105, 33, 0)
				GUICtrlSetOnEvent(-1, "Form1Close")
			GUISetState(@SW_SHOW)
		EndIF	
EndFunc	