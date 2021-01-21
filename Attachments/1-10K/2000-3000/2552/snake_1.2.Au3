#region includes and option
#include <GuiConstants.au3>
Opt("GuiOnEventMode", 1)
#endregion
#region Options GUI
$opt_gui = GUICreate("Options", 188, 400, (@DesktopWidth - 188) / 2, (@DesktopHeight - 400) / 2);,$WS_CHILD )
$opt_label_mode = GUICtrlCreateLabel("Pick your Mode.", 20, 30, 150, 20)
$opt_combo_mode = GUICtrlCreateCombo("", 20, 50, 150, 21 * 6)
GUICtrlSetData($opt_combo_mode, "1", "1")
;GUICtrlSetData($opt_combo_mode, "1|2|3", "1")
$opt_label_speed = GUICtrlCreateLabel("Pick your speed.", 20, 80, 150, 20)
$opt_combo_speed = GUICtrlCreateCombo("", 20, 100, 150, 21 * 6)
GUICtrlSetData($opt_combo_speed, "Very Slow|Slow|Medium|Fast|Very Fast|Insane", "Medium")
$opt_group_speedtype = GUICtrlCreateGroup("", 20, 120, 150, 55)
$opt_radio_constantspeed = GUICtrlCreateRadio("Constant Speed.", 30, 130, 130, 20)
GUICtrlSetState($opt_radio_constantspeed, $gui_checked)
$opt_radio_acceleratingspeed = GUICtrlCreateRadio("Accelerating Speed", 30, 150, 130, 20)
$opt_label_level = GUICtrlCreateLabel("Pick your level.", 20, 180, 150, 20)
$opt_combo_level = GUICtrlCreateCombo("", 20, 200, 150, 21 * 6)
GUICtrlSetData($opt_combo_level, "Very Easy|Easy|Medium|Hard|Very Hard|Hardest", "Medium")

$opt_group_mazetype = GUICtrlCreateGroup("", 20, 220, 150, 55)
$opt_radio_mazesame = GUICtrlCreateRadio("Same Maze", 30, 230, 130, 20)
$opt_radio_mazechanging = GUICtrlCreateRadio("Changing Mazes", 30, 249, 130, 20)
GUICtrlSetState($opt_radio_mazechanging, $gui_checked)
$opt_label_maze = GUICtrlCreateLabel("Pick your starting maze or main maze.", 20, 284, 150, 30)
$opt_combo_maze = GUICtrlCreateCombo("", 20, 320, 150, 21 * 6)
GUICtrlSetData($opt_combo_maze, "Maze 0|Maze 1|Maze 2|Maze 3|Maze 4", "Maze 0")
$opt_button_start = GUICtrlCreateButton("&Start", 20, 360, 150, 30)
GUICtrlSetOnEvent($opt_button_start, "_OptStart")
GUISetOnEvent($gui_event_close, "_Exit")
GUISetState(@SW_SHOW, $opt_gui)
#endregion
#region Main GUI
Global $guititle = "Snake Game"
$gui = GUICreate($guititle, 490, 400);(@DesktopWidth-465)/2, (@DesktopHeight-400)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUISetState(@SW_HIDE, $gui)
GUISetBkColor(0x000099)

$button_exit = GUICtrlCreateButton("&Exit", 405, 375, 80, 20)
GUICtrlSetOnEvent($button_exit, "_Exit")
$button_reset = GUICtrlCreateButton("&ReSet", 405, 345, 80, 20)
GUICtrlSetOnEvent($button_reset, "_Reset")
$button_pause = GUICtrlCreateButton("&Pause", 405, 315, 80, 20)
GUICtrlSetOnEvent($button_pause, "_Pause")
GUICtrlSetState($button_pause, $GUI_DISABLE)
$button_go = GUICtrlCreateButton("&Go", 405, 285, 80, 20)
GUICtrlSetOnEvent($button_go, "_Go")
$label_5 = GUICtrlCreateLabel("", 405, 10, 70, 20)
GUICtrlSetColor($label_5, 0xDDDDFF)
$label_score = GUICtrlCreateLabel("", 405, 40, 80, 20)
GUICtrlSetColor($label_score, 0xDDDDFF)
$label_foodreq = GUICtrlCreateLabel("", 405, 70, 80, 40)
GUICtrlSetColor($label_foodreq, 0xDDDDFF)
$label_level = GUICtrlCreateLabel("", 405, 130, 80, 30)
GUICtrlSetColor($label_level, 0xDDDDFF)
GUISetOnEvent($gui_event_close, "_Exit")
Global $label_hs

Dim $highscores[11][2]
$highscores[0][0] = "AAA"
$highscores[0][1] = 1440
$highscores[1][0] = "AAA"
$highscores[1][1] = 890
$highscores[2][0] = "AAA"
$highscores[2][1] = 550
$highscores[3][0] = "AAA"
$highscores[3][1] = 340
$highscores[4][0] = "AAA"
$highscores[4][1] = 210
$highscores[5][0] = "AAA"
$highscores[5][1] = 130
$highscores[6][0] = "AAA"
$highscores[6][1] = 80
$highscores[7][0] = "AAA"
$highscores[7][1] = 50
$highscores[8][0] = "AAA"
$highscores[8][1] = 30
$highscores[9][0] = "AAA"
$highscores[9][1] = 20
#endregion
#region Variables and start up
Global $speedder = 150
Global $food[5][4]  ; food locations, CtrlIDs, and types (regular/poison/bonus/maybe more?)
Global $foodqty = 1
Global $snakecolor = 0xFFFFFF  ; White
Global $foodcolor = 0x00FF00  ; Green
Global $wallcolor = 0x000000  ; Black
Global $poisoncolor = 0xFF0000  ; Red
Global $bonuscolor = 0x000000  ; ???
Dim $board[40][40]  ; tracks the board
Global $bempty = 0  ; note that even is good, odd is bad
Global $bsnake = 1
Global $bfood = 2
Global $bpoison = 3
Global $bbonus = 4
Global $bwall = 5
Global $snakelength = 0
Dim $snake[$snakelength + 1][3]  ; positions and parts of the snake
Dim $wall[300] ; extra just in case
Global $walllength  ; needed info for cleanup
Global $currentmaze = 0
Global $dx
Global $dy
Global $dt = 0
Global $pause = 0
Global $movessincefood = 0
Global $score = 0
Global $starting_food_required
Global $food_required
Global $mode
Global $level = 0
Global $speedselection
Global $levelselection
Global $mazeopt = 0
Global $gamelocked = 0
#endregion
#region Main Loop
While 1
	If WinActive($guititle) Then
		HotKeySet("{UP}", "_up")
		HotKeySet("{DOWN}", "_down")
		HotKeySet("{RIGHT}", "_right")
		HotKeySet("{LEFT}", "_left")
	
	Else
		$pause = 1
		HotKeySet("{UP}")
		HotKeySet("{DOWN}")
		HotKeySet("{RIGHT}")
		HotKeySet("{LEFT}")
	EndIf
	If $pause Or $gamelocked Then
		Sleep(20)
	Else
		_move()
		Sleep($speedder)
	EndIf
WEnd
#endregion
#region Functions
Func _OptStart()
	GUISetState(@SW_HIDE, $opt_gui)
	GUISetState(@SW_SHOW, $gui)
;	_clearBoard()
	_showHS()
	$gamelocked = 1
EndFunc   ;==>_OptStart

Func _Go()
	_HideHS()
	GUICtrlSetState($button_Go, $GUI_DISABLE)
	Local $x, $y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; I believe we need a better name for $dt
; $AccCheck or $Acc_Check or $accelerating_Check
;
; I agree, but I haven't done it yet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	$dt = 0
	_clearBoard()
	$snakelength = 0
	$walllength = 0
	$movessincefood = 0
	$score = 0
	$level = 1
	$gamelocked = 0
	$speedselection = GUICtrlRead($opt_combo_speed)
	$levelselection = GUICtrlRead($opt_combo_level)
	If GUICtrlRead($opt_radio_acceleratingspeed) = $gui_checked Then $dt = -1
	If GUICtrlRead($opt_radio_mazechanging) = $gui_checked Then $mazeopt = 1
	$mode = GUICtrlRead($opt_combo_mode)
	Select
		Case $mode = 1; current and only mode for the time
			$currentmaze = StringTrimLeft(GUICtrlRead($opt_combo_maze), 5)
			Select
				Case $speedselection = "very slow"
					$speedder = 250
				Case $speedselection = "slow"
					$speedder = 200
				Case $speedselection = "medium"
					$speedder = 150
				Case $speedselection = "fast"
					$speedder = 100
				Case $speedselection = "very fast"
					$speedder = 50
				Case $speedselection = "insane"
					$speedder = 20
			EndSelect
			Select
				Case $levelselection = "Very Easy"
					$starting_food_required = 10
				Case $levelselection = "Easy"
					$starting_food_required = 25
				Case $levelselection = "medium"
					$starting_food_required = 50
				Case $levelselection = "Hard"
					$starting_food_required = 100
				Case $levelselection = "very Hard"
					$starting_food_required = 200
				Case $levelselection = "Hardest"
					$starting_food_required = 300
			EndSelect
		Case $mode = 2
			MsgBox(0, "mode = " & $mode, "mode = " & $mode)
		Case $mode = 3
			MsgBox(0, "mode = " & $mode, "mode = " & $mode)
		Case Else
			MsgBox(0, "Unknown Mode", "mode = " & $mode)
			_Exit()  ; go back to options here?
	EndSelect
	_NewBoard()
EndFunc   ;==>_Go

Func _NewBoard()
	$dx = 0
	$dy = 0
	$pause = 1
	GUICtrlSetState($button_pause, $GUI_DISABLE)
	$food_required = $starting_food_required
	GUICtrlSetData($label_score, "Score: " & $score)
	GUICtrlSetData($label_level, "Level: " & $level)
	GUICtrlSetData($label_foodreq, "Food required for next level: " & $food_required)
	ReDim $snake[$snakelength + 1][3]
	_maze($currentmaze)
	Do
		$snake[0][0] = Int(Random(0, 39))
		$snake[0][1] = Int(Random(0, 39))
	Until $board[$snake[0][0]][$snake[0][1]] = $bempty
	$snake[0][2] = GUICtrlCreateLabel("", $snake[0][0] * 10, $snake[0][1] * 10, 10, 10)
	GUICtrlSetBkColor($snake[0][2], $snakecolor)
	$board[$snake[0][0]][$snake[0][1]] = $bsnake
	Do
		$food[0][0] = Int(Random(0, 39))
		$food[0][1] = Int(Random(0, 39))
	Until $board[$food[0][0]][$food[0][1]] = $bempty
	$food[0][2] = GUICtrlCreateLabel("", $food[0][0] * 10, $food[0][1] * 10, 10, 10)
	GUICtrlSetBkColor($food[0][2], $foodcolor)
	$board[$food[0][0]][$food[0][1]] = $bfood
EndFunc

Func _Pause()
	$pause = 1
	GUISetState(@SW_HIDE, $gui)
	GUICtrlSetState($button_pause, $GUI_DISABLE)
	GUICreate("Paused", 142, 70, (@DesktopWidth - 142) / 2, (@DesktopHeight - 70) / 2)
	GUICtrlCreateButton("&Resume Game", 10, 10, 120, 50)
	GUICtrlSetOnEvent(-1, "_ResumeGame")
	GUISetOnEvent($gui_event_close, "_Exit")
	GUISetState(@SW_SHOW, -1)
EndFunc   ;==>_Pause

Func _ResumeGame()
	GUIDelete(-1)
	GUISetState(@SW_SHOW, $gui)
	GUICtrlSetState($button_pause, $GUI_ENABLE)
	$pause = 0
EndFunc   ;==>_ResumeGame

Func _Reset()
	$pause = 1
	$level = 0
	GUISetState(@SW_HIDE, $gui)
	GUISetState(@SW_SHOW, $opt_gui)
	GUICtrlSetState($button_go, $GUI_ENABLE)
	GUICtrlSetState($button_Pause, $GUI_DISABLE)
	_clearboard()
	_HideHS()
	; Maybe Need to reset varables
EndFunc   ;==>_Reset

Func _maze($lm)
	Local $i
	Select
		Case $lm = 0
			$walllength = 0
			;;;;;;;;;;;;;;;;;;
		Case $lm = 1
			$walllength = 160
			For $i = 0 To 39
				$board[39][$i] = $bwall
				$wall[$i] = GUICtrlCreateLabel("", 390, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[0][$i] = $bwall
				$wall[40 + $i] = GUICtrlCreateLabel("", 0, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][39] = $bwall
				$wall[80 + $i] = GUICtrlCreateLabel("", $i * 10, 390, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][0] = $bwall
				$wall[120 + $i] = GUICtrlCreateLabel("", $i * 10, 00, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
			Next
			;;;;;;;;;;;;;;;;;;
		Case $lm = 2
			$walllength = 120
			For $i = 0 To 9
				$board[39][$i] = $bwall
				$wall[$i] = GUICtrlCreateLabel("", 390, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[0][$i] = $bwall
				$wall[10 + $i] = GUICtrlCreateLabel("", 0, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][39] = $bwall
				$wall[20 + $i] = GUICtrlCreateLabel("", $i * 10, 390, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][0] = $bwall
				$wall[30 + $i] = GUICtrlCreateLabel("", $i * 10, 00, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
			Next
			For $i = 30 To 39
				$board[39][$i] = $bwall
				$wall[10 + $i] = GUICtrlCreateLabel("", 390, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[0][$i] = $bwall
				$wall[20 + $i] = GUICtrlCreateLabel("", 0, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][39] = $bwall
				$wall[30 + $i] = GUICtrlCreateLabel("", $i * 10, 390, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][0] = $bwall
				$wall[40 + $i] = GUICtrlCreateLabel("", $i * 10, 00, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
			Next
			For $i = 10 To 29
				$board[$i][14] = $bwall
				$wall[70 + $i] = GUICtrlCreateLabel("", $i * 10, 140, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][24] = $bwall
				$wall[90 + $i] = GUICtrlCreateLabel("", $i * 10, 240, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
			Next
			;;;;;;;;;;;;;;
		Case $lm = 3
			$walllength = 80
			For $i = 0 To 19
				$board[7][$i] = $bwall
				$wall[$i] = GUICtrlCreateLabel("", 70, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][32] = $bwall
				$wall[20 + $i] = GUICtrlCreateLabel("", $i * 10, 320, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
			Next
			For $i = 20 To 39
				$board[32][$i] = $bwall
				$wall[20 + $i] = GUICtrlCreateLabel("", 320, $i * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$i][7] = $bwall
				$wall[40 + $i] = GUICtrlCreateLabel("", $i * 10, 70, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
			Next
		Case $lm = 4
			$walllength = 180
			For $y = 0 To 14
				$wall[$y] = GUICtrlCreateLabel("", 0, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[0][$y] = $bwall
			Next
			For $y = 0 To 14
				$wall[15 + $y ] = GUICtrlCreateLabel("", 390, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[39][$y] = $bwall
			Next
			For $y = 24 To 39
				$wall[6+$y ] = GUICtrlCreateLabel("", 0, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[0][$y] = $bwall
			Next
			For $y = 24 To 39
				$wall[22+$y ] = GUICtrlCreateLabel("", 390, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[39][$y] = $bwall
			Next
			For $y = 9 To 29
				$wall[53 +$y ] = GUICtrlCreateLabel("", 120, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[12][$y] = $bwall
			Next
			For $y = 9 To 29
				$wall[74 + $y  ] = GUICtrlCreateLabel("", 260, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[26][$y] = $bwall
			Next
			For $x = 1 To 38
				$wall[ 103 + $x] = GUICtrlCreateLabel("", $x * 10, 0, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][0] = $bwall
			Next
			For $x = 1 To 38
				$wall[141 + $x  ] = GUICtrlCreateLabel("", $x * 10, 390, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][39] = $bwall
			Next
		;;;;;;;;;;;;;;;;;;;
#cs
		Case $lm = 5
			$walllength = 0; need length
			For $x = 1 To 4
				$wall[$x  ] = GUICtrlCreateLabel("", $x * 10, 0, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][0] = $bwall
			Next
			For $x = 14 To 29
				$wall[$x ] = GUICtrlCreateLabel("", $x * 10, 0, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][0] = $bwall
			Next
			For $x = 0 To 19
				$wall[$x ] = GUICtrlCreateLabel("", $x * 10, 130, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][13] = $bwall
			Next
			For $x = 29 To 39
				$wall[$x ] = GUICtrlCreateLabel("", $x * 10, 130, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][13] = $bwall
			Next
			For $x = 0 To 39
				$wall[$x ] = GUICtrlCreateLabel("", $x * 10, 260, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][26] = $bwall
			Next
			For $y = 0 To 4
				$wall[$y] = GUICtrlCreateLabel("", 0, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[0][$y] = $bwall
			Next
			For $y = 1 To 12
				$wall[$y] = GUICtrlCreateLabel("", 190, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[19][$y] = $bwall
			Next
			For $y = 27 To 39
				$wall[$y] = GUICtrlCreateLabel("", 290, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[29][$y] = $bwall
			Next
		Case $lm = 6
			$x = 1
			For $y = 2 To 37
				$x = $x + 1
				If $y = 18 Or $y = 19 Or $y = 20 Or $y = 21 Then ContinueLoop
				$wall[$y] = GUICtrlCreateLabel("", $x * 10, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][$y] = $bwall
			Next
			$x = 38
			For $y = 2 To 37
				$x = $x -1
				If $y = 18 Or $y = 19 Or $y = 20 Or $y = 21 Then ContinueLoop
				$wall[$y] = GUICtrlCreateLabel("", $x * 10, $y * 10, 10, 10)
				GUICtrlSetBkColor(-1, $wallcolor)
				$board[$x][$y] = $bwall
			Next
#ce
		Case Else
			MsgBox(0, "Diagnostic", "Unknown maze: " & $lm)
	EndSelect
EndFunc   ;==>_maze

Func _clearBoard()
	GUICtrlDelete($food[0][2])
	For $i = 0 To $snakelength
		GUICtrlDelete($snake[$i][2])
	Next
	For $i = 0 To $walllength - 1
		GUICtrlDelete($wall[$i])
	Next
	For $x = 0 To 39
		For $y = 0 To 39
			$board[$x][$y] = $bempty
		Next
	Next
EndFunc   ;==>_clearBoard

Func _up()
	If $gamelocked Then Return
	$dx = 0
	$dy = -1
	GUICtrlSetState($button_pause, $GUI_ENABLE)
	$pause = 0
EndFunc   ;==>_up

Func _down()
	If $gamelocked Then Return
	$dx = 0
	$dy = 1
	GUICtrlSetState($button_pause, $GUI_ENABLE)
	$pause = 0
EndFunc   ;==>_down

Func _left()
	If $gamelocked Then Return
	$dx = -1
	$dy = 0
	GUICtrlSetState($button_pause, $GUI_ENABLE)
	$pause = 0
EndFunc   ;==>_left

Func _right()
	If $gamelocked Then Return
	$dx = 1
	$dy = 0
	GUICtrlSetState($button_pause, $GUI_ENABLE)
	$pause = 0
EndFunc   ;==>_right

Func _move()
	Local $newhead[3]
	$newhead[0] = Mod($snake[0][0] + $dx + 40, 40)
	$newhead[1] = Mod($snake[0][1] + $dy + 40, 40)
	If BitAND($board[$newhead[0]][$newhead[1]], 1) Then  ; Bad place to go
		Select
			Case $board[$newhead[0]][$newhead[1]] = $bsnake
				MsgBox(0, "Your snake ate itself", "Your snake was "& ($snakelength + 1) & " units long")
			Case $board[$newhead[0]][$newhead[1]] = $bpoison
				MsgBox(0, "Your snake ate poison", "Your snake was "& ($snakelength + 1) & " units long")
			Case $board[$newhead[0]][$newhead[1]] = $bwall
				MsgBox(0, "Your snake ran into the wall", "Your snake was "& ($snakelength + 1) & " units long")
		EndSelect
		$score = $score + $snakelength + 1
		_EndGame()
	Else  ; empty or food or bonus
		Local $oldtail[3]
		$oldtail[0] = $snake[$snakelength][0]
		$oldtail[1] = $snake[$snakelength][1]
		$oldtail[2] = $snake[$snakelength][2]
		If $board[$newhead[0]][$newhead[1]] = $bfood Then  ; Ate Food
			$score = $score + $level
			If $mode = 1 Then
				$food_required = $food_required - 1
				GUICtrlSetData($label_foodreq, "Food required for next level: " & $food_required)
				If $food_required = 0 Then
					$score = $score + $level*10
					$level = $level + 1
					GUICtrlSetData($label_score, "Score: " & $score)
					MsgBox(0, "Boo-Yah!", "Advancing to Level " & $level)
					_LevelUp()
					Return
				EndIf
			EndIf
			GUICtrlDelete($food[0][2])
			Do
				$food[0][0] = Int(Random(0, 39))
				$food[0][1] = Int(Random(0, 39))
			Until $board[$food[0][0]][$food[0][1]] = $bempty
			$food[0][2] = GUICtrlCreateLabel("", $food[0][0] * 10, $food[0][1] * 10, 10, 10)
			GUICtrlSetBkColor($food[0][2], $foodcolor)
			$board[$food[0][0]][$food[0][1]] = $bfood
			$snakelength = $snakelength + 1
			GUICtrlSetData($label_5, $snakelength + 1)
			ReDim $snake[$snakelength + 1][3]
			$movessincefood = 0
			$speedder = $speedder + $dt
		Else
			GUICtrlDelete($oldtail[2])
			$board[$oldtail[0]][$oldtail[1]] = $bempty
			$movessincefood = $movessincefood + 1
		EndIf
		$newhead[2] = GUICtrlCreateLabel("", $newhead[0] * 10, $newhead[1] * 10, 10, 10)
		GUICtrlSetBkColor($newhead[2], $snakecolor)
		$board[$newhead[0]][$newhead[1]] = $bsnake
		For $i = $snakelength To 1 Step - 1 ; Array shift
			$snake[$i][0] = $snake[$i - 1][0]
			$snake[$i][1] = $snake[$i - 1][1]
			$snake[$i][2] = $snake[$i - 1][2]
		Next
		$snake[0][0] = $newhead[0]
		$snake[0][1] = $newhead[1]
		$snake[0][2] = $newhead[2]
;		$score = $score + 1
		GUICtrlSetData($label_score, "Score: " & $score)
	EndIf
EndFunc   ;==>_move

Func _LevelUp()
	_clearBoard()
	GUICtrlSetData($label_score, "Score: " & $score)
	$currentmaze = Mod($currentmaze + $mazeopt, 5)
	$starting_food_required = $starting_food_required + 5
;	$snakelength = 0
	_NewBoard()
EndFunc

Func _EndGame()
	GUICtrlSetData($label_score, "Score: " & $score)
	For $i = 0 To 9
		If $score > $highscores[$i][1] Then
			HotKeySet("{UP}")
		HotKeySet("{DOWN}")
		HotKeySet("{RIGHT}")
		HotKeySet("{LEFT}")
			If Not $i Then
				$msg = "All time high score!!!"
			Else
				$msg = "Congratulations!  You ranked!"
			EndIf
			
			$initials = StringUpper(InputBox($msg, "Enter Your Initials", "", " 3"))
			For $j = 9 To $i + 1 Step - 1
				$highscores[$j][0] = $highscores[$j - 1][0]
				$highscores[$j][1] = $highscores[$j - 1][1]
			Next
			$highscores[$i][0] = $initials
			$highscores[$i][1] = $score
			ExitLoop
		EndIf
	Next
	_ShowHS()
	GUICtrlSetState($button_Go, $GUI_ENABLE)
	$gamelocked = 1
EndFunc

Func _showHS()
	Local $hslist = ""
	Local $spacer = " "
	Local $maxhslength = Int(Log($highscores[0][1]) / Log(10) + 1)
	For $i = 0 To 9
		Local $thishslength = Int(Log($highscores[$i][1]) / Log(10) + 1)
		If $i = 9 Then $spacer = ""
		$hslist = $hslist & @CRLF & $i + 1 & ". " & $spacer & $highscores[$i][0] & " - "
		For $j = 1 To $maxhslength - $thishslength
			$hslist = $hslist & " "
		Next
		$hslist = $hslist & $highscores[$i][1]
	Next
	$label_hs = GUICtrlCreateLabel("", 90, 60, 220, 300)
	GUICtrlSetColor($label_hs, 0xDDDDFF)
	GUICtrlSetFont($label_hs, 18, 800, 1, "lucida console")
	GUICtrlSetState($label_hs, $GUI_ENABLE)
	GUICtrlSetData($label_hs, " High Scores" & @CRLF & $hslist)
EndFunc   ;==>_showHS

Func _HideHS()
	GUICtrlDelete($label_hs)
EndFunc

Func _Exit()
	; write INI file here?
	Exit
EndFunc   ;==>_Exit
#endregion