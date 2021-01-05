;left arrow                           25
;up arrow                             26
;right arrow                          27
;down arrow                           28
;space bar                            20
#include <GuiConstants.au3>
#include <Array.au3>
opt("GuiOnEventMode", 1)

MsgBox(0, "Directions", "Use the arrow keys to start the game, to guide the snake and unpause the game. Use the spacebar to pause the game.")

$gui = GUICreate("Snake", 400, 400)
GuiSetBkColor(0x000099) 
GUISetState()
GUISetOnEvent($gui_event_close, "_Exit")

Global $clientsize = WinGetClientSize($gui)
Global $speedder = 150
Global $food
Global $snakelength = 0
Dim $board[40][40]  ; tracks the board
Dim $snake[$snakelength + 1][3]  ; positions and parts of the snake
Dim $food_location[2]  ; not possible for multiple food locations?

DllOpen("user32.dll")
_start()
Global $dx = 1
Global $dy = 0
_sleep()
While 1
	Sleep($speedder)
	
	If _IsPressed(25) Then
		$dx = -1
		$dy = 0
	EndIf
	If _IsPressed(27) Then
		$dx = 1
		$dy = 0
	EndIf
	If _IsPressed(26) Then
		$dx = 0
		$dy = -1
	EndIf
	If _IsPressed(28) Then
		$dx = 0
		$dy = 1
	EndIf
	move()
	If _IsPressed(20) Then
		_sleep()
	EndIf
WEnd
Func _start()
	$snakelength = 0
	ReDim $snake[$snakelength + 1][3]
	Local $x, $y, $a, $b, $pos
	For $x = 0 To 39
		For $y = 0 To 39
			$board[$x][$y] = 1  ; empty
		Next
	Next
	$a = Int(Random(3, 36))
	$b = Int(Random(3, 36))
	$snake[0][2] = GUICtrlCreateLabel("", $a * 10, $b * 10, 10, 10)
	GUICtrlSetBkColor($snake[0][2], 16777215)
	$pos = ControlGetPos($gui, "", $snake[0][2])
	$snake[0][0] = Int($pos[0] / 10)
	$snake[0][1] = Int($pos[1] / 10)
	;MsgBox (0, "Diagnostic", $snake[0][0] & ", " & $snake[0][1])
	$board[$a][$b] = 0  ; snake  simplifies the "can I go there?" logic
	
	Do
		$a = Int(Random(0, 39))
		$b = Int(Random(0, 39))
	Until $board[$a][$b] = 1  ; empty
	$food = GUICtrlCreateLabel("", $a * 10, $b * 10, 10, 10)
	$pos2 = ControlGetPos($gui, "", $food)
	$food_location[0] = $pos2[0] / 10
	$food_location[1] = $pos2[1] / 10
	GUICtrlSetBkColor($food, 39219)
	$board[$a][$b] = 2  ; food
EndFunc   ;==>_start

Func move()
	
	Local $newhead[3]
	$newhead[0] = $snake[0][0] + $dx
	$newhead[1] = $snake[0][1] + $dy
	
	Local $oldtail[3]
	$oldtail[0] = $snake[$snakelength][0]
	$oldtail[1] = $snake[$snakelength][1]
	$oldtail[2] = $snake[$snakelength][2]
	
	Select
		Case $newhead[0] < 0 Or $newhead[0] > 39 Or $newhead[1] < 0 Or $newhead[1] > 39
			If $snakelength > 0 Then
				MsgBox(0, "Your snake ate the wall.", "Your snake was "& ($snakelength + 1) & " units long")
			Else
				MsgBox(0, "Your snake ate the wall.", "You should play with your snake more.")
			EndIf
			_cleanup()
			
		Case $board[$newhead[0]][$newhead[1]]  ; OK to go there
			$newhead[2] = GUICtrlCreateLabel("", $newhead[0] * 10, $newhead[1] * 10, 10, 10)
			GUICtrlSetBkColor($newhead[2], 16777215)
			If $board[$newhead[0]][$newhead[1]] = 2 Then  ; Ate Food
				; Move food
				Do
					$a = Int(Random(0, 39))
					$b = Int(Random(0, 39))
				Until $board[$a][$b] = 1  ; empty
				$board[$a][$b] = 2  ; food
				GUICtrlSetPos($food, $a * 10, $b * 10)
				$snakelength = $snakelength + 1
				ReDim $snake[$snakelength + 1][3]
			Else
				GUICtrlDelete($oldtail[2])
				$board[$oldtail[0]][$oldtail[1]] = 1
			EndIf
			$board[$newhead[0]][$newhead[1]] = 0
			For $i = $snakelength To 1 Step - 1 ; Array shift
				$snake[$i][0] = $snake[$i - 1][0]
				$snake[$i][1] = $snake[$i - 1][1]
				$snake[$i][2] = $snake[$i - 1][2]
			Next
			$snake[0][0] = $newhead[0]
			$snake[0][1] = $newhead[1]
			$snake[0][2] = $newhead[2]
		Case Else
			;eat self
			MsgBox(0, "Yor snake ate itself", "You snake was "& ($snakelength + 1) & " units long")
			_cleanup()
	EndSelect
EndFunc   ;==>move

Func _cleanup()
	For $x = 0 To 39
		For $y = 0 To 39
			$board[$x][$y] = 1  ; empty
		Next
	Next
	GUICtrlDelete($food)
	For $i = 0 To $snakelength
		GUICtrlDelete($snake[$i][2])
	Next
	_start()   ; This is going to choke after 300 something calls
	_sleep()
EndFunc   ;==>_cleanup

Func _Exit()
	DllClose("user32.dll")
	Exit
EndFunc   ;==>_Exit
Func _sleep()
	Do
		Do
			Sleep(100)
		Until _IsPressed(25) Or _IsPressed(26) Or _IsPressed(27) Or _IsPressed(28)
		If _IsPressed(25) Then
			$dx = -1
			$dy = 0
		EndIf
		If _IsPressed(27) Then
			$dx = 1
			$dy = 0
		EndIf
		If _IsPressed(26) Then
			$dx = 0
			$dy = -1
		EndIf
		If _IsPressed(28) Then
			$dx = 0
			$dy = 1
		EndIf
	Until _IsPressed(25) Or _IsPressed(26) Or _IsPressed(27) Or _IsPressed(28)
EndFunc   ;==>_sleep
Func _IsPressed($hexkey)
	Local $ar, $brv
	$hexkey = '0x' & $hexkey
	$ar = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexkey)
	
	If $ar[0] <> 0 Then
		$brv = 1
	Else
		$brv = 0
	EndIf
	
	Return $brv
EndFunc   ;==>_IsPressed
