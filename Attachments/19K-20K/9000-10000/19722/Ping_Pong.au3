#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Opt("MouseCoordMode", 0)
Opt("PixelCoordMode", 0)
Opt("MouseClickDelay", 0)
Opt("MouseClickDownDelay", 0)

Dim $Game, $MID
HotKeySet("{F9}", "Game_Bot")

Opt("MouseCoordMode", 0)
Opt("PixelCoordMode", 0)

GUICreate("Ping Pong Bot", 614, 370)
GUISetFont(9, 400, "MS Sans Serif")
$B_oIE3 = ObjCreate("Shell.Explorer.2")
$Breaktime = GUICtrlCreateObj($B_oIE3, -45, -140, 540, 510)
$html2 = "about:<br><text> This is only a test.</text></br>"
$B_oIE3.navigate ($html2)
GUICtrlCreateLabel ("Game Bot", 503, 80, 150)
GUICtrlSetFont( -1, 12, 700)
GUICtrlCreateLabel ("PixelSearch", 505, 120, 150)
GUICtrlSetFont (-1, 12, 700)
$BrkStart = GUICtrlCreateButton("Enter Game", 505, 300, 80, 25)
$BrkEnd = GUICtrlCreateButton("Exit", 505, 330, 80, 25)
GUISetState()

While 1
	$msg = GUIGetMsg()
	If $msg = $BrkEnd Then
		Exit
	EndIf
	If $msg = $BrkStart Then
		$B_oIE3.navigate ("file:///C:/Users/P/Desktop/pingpong.swf")
		Sleep(1500)
		$B_oIE3.navigate ("file:///C:/Users/P/Desktop/pingpong.swf")
		Sleep(1500)
		MsgBox(262208, "How to Play", "Move the racket to hit the ball" & @CRLF & "Or, press [F9] to use the Game Bot")
		ToolTip("Press F9 to use the Game Bot", 0, 0)
	EndIf
WEnd
Func Game_Bot()
	$Game = Not $Game
	if $Game then tooltip("Press F9 to exit the Game Bot", 0, 0)
		While $Game
			$ball = PixelSearch (49, 75, 430, 330, 0xFFFFFF, 50, 10)
			If Not @error Then MouseClick("left",  $ball[0], $ball[1], 1, 0)
			WEnd
			ToolTip("")
		EndFunc
		
		Func Get_coord()
			$MID = NOT $MID
			While $MID
				$pos = MouseGetPos()
				ToolTip("Mouse Coordinates" & @CRLF & " X = " & $pos[0] & " Y = " & $pos[1], 0, 0)
				Sleep(20)
			WEnd
			ToolTip("")
			EndFunc