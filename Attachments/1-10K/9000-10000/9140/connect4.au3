;===============================================================================
;
; Program Name:   Connect 4
; Description::    2 Player Connect 4 game
; Requirement(s):  AutoIt Beta
; Author(s):       RazerM
;
;===============================================================================
;
#include <GUIConstants.au3>
#include <table.au3>
#include <string.au3>
#NoTrayIcon

GUICreate("Connect 4", 600, 330)
$table = _GUICtrlCreateTable(10, 10, 7, 6, 50, 50)
$stats = _GUICtrlCreateTable(465, 120, 3, 4, 40, 20)
TableSetData(2, 1, "  Red")
GUICtrlSetBkColor($stats[2][1], 0xff0000)
GUICtrlSetColor($stats[2][1], 0xffffff)
TableSetData(3, 1, " Blue")
GUICtrlSetBkColor($stats[3][1], 0x0000ff)
GUICtrlSetColor($stats[3][1], 0xffffff)
TableMultiSetData(1, 2, 1, 4, "Wins|Losses|Draws")
TableMultiSetData(2, 2, 3, 4, 0)


$new = GUICtrlCreateButton("New Players", 465, 210 , 127, 25, $BS_DEFPUSHBUTTON)
$undobtn = GUICtrlCreateButton("Undo", 465, 240, 127, 25)
GUICtrlCreateLabel("Red Player:", 400, 13)
$redinput = GUICtrlCreateInput("", 470, 10, 120, -1, $ES_READONLY+$ES_CENTER)
GUICtrlSetBkColor(-1, 0xff0000)
GUICtrlSetColor($redinput, 0xffffff)
GUICtrlCreateLabel("Blue Player:", 400, 43)
$blueinput = GUICtrlCreateInput("", 470, 40, 120, -1, $ES_READONLY+$ES_CENTER)
GUICtrlSetBkColor(-1, 0x0000ff)
GUICtrlSetColor($blueinput, 0xffffff)
$turn = GUICtrlCreateInput("", 470, 70, 120, -1, $ES_READONLY+$ES_CENTER)
GUICtrlSetBkColor(-1, 0xbbffbb)
GUISetState()
$temp = WinGetPos("Connect 4")
$temp2 = PixelGetColor($temp[0]+6, $temp[1]+32)
$bkcolor = "0x" & StringTrimLeft(Hex($temp2), 2)

$color = "r"
$oldcolor = 0
$game = 0
$undo = 0
While 1
	If $color <> $oldcolor Then
		If $color = "b" Then GUICtrlSetData($turn, "Blue Player's Turn")
		If $color = "r" Then GUICtrlSetData($turn, "Red Player's Turn")
	EndIf
	$oldcolor = $color
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $new
			$red = InputBox("Red Player", "What is your name?")
			While $red = ""
				$red = InputBox("Red Player", "What is your name?")
			WEnd
			$blue = InputBox("Blue Player", "What is your name?")
			While $blue = ""
				$blue = InputBox("Blue Player", "What is your name?")
			WEnd
			GUICtrlSetData($redinput, $red)
			GUICtrlSetData($blueinput, $blue)
			GUICtrlSetData($turn, "Red Player's Turn")
			$col = 0
			For $col = 1 To 6
				For $row = 1 To 7
					SetFilled($row, $col, 0x00ff00)
					Sleep(25)
				Next
			Next
			For $row = 1 To 7
				For $col = 1 To 6
					SetFilled($row, $col, $bkcolor)
					Sleep(25)
				Next
			Next
			TableMultiSetData(2, 2, 3, 4, 0)
			$game = 1
			$color = "r"
		Case $undobtn
			Undo($undo)
			$color = SwapColor($color)
			If $color = "b" Then GUICtrlSetData($turn, "Blue Player's Turn")
			If $color = "r" Then GUICtrlSetData($turn, "Red Player's Turn")
			GUICtrlSetState($undobtn, $GUI_DISABLE)
	EndSwitch
	For $row = 7 To 1 Step -1
		For $col = 6 To 1 Step -1
			If $msg = $table[$row][$col] Then
				If $game = 1 Then
					For $col2 = 6 To 1 Step -1
						If GUICtrlRead($table[$row][$col2]) <> "r" And GUICtrlRead($table[$row][$col2]) <> "b" Then
							AnimateDown($row, $col2, $color)
							GUICtrlSetState($undobtn, $GUI_ENABLE)
							$undo = $row & "," & $col2
							If CheckDraw() = 1 Then
								AddDraw()
								For $row = 1 To 7
									For $col = 1 To 6
										SetFilled($row, $col, $bkcolor)
									Next
								Next
								ExitLoop 3
							EndIf
							If CheckFour($row, $col2, $color) = 1 Then
								If $color = "r" Then
									MsgBox(0,"Win",$red & " got four in a row!")
									Addwin("r")
								Else
									MsgBox(0,"Win",$blue & " got four in a row!")
									AddWin("b")
								EndIf
								For $row = 1 To 7
									For $col = 1 To 6
										SetFilled($row, $col, $bkcolor)
									Next
								Next
							EndIf
							$color = SwapColor($color) ;set to other player
							ExitLoop 3
						EndIf
					Next
				EndIf
			EndIf
		Next
	Next
WEnd

Func Undo($undo)
	$coord = StringSplit($undo, ",")
	If $coord[0] = 1 Then Return 0
	AnimateUp($coord[1], $coord[2], SwapColor($color))
;~ 	SetFilled($coord[1], $coord[2], $bkcolor)
EndFunc

Func CheckDraw()
	$counter = 0
	For $row = 1 To 7
		For $col = 1 To 6
			If GUICtrlRead($table[$row][$col]) = "r" Then $counter += 1
			If GUICtrlRead($table[$row][$col]) = "b" Then $counter += 1
		Next
	Next
	If $counter = 42 Then Return 1
EndFunc
Func AnimateUp($row, $col, $color)
	For $col2 = $col To 1 Step -1
		If $col2 <= $col Then SetFilled($row, $col2-1, $color)
		SetFilled($row, $col2, $bkcolor)
		Sleep(25)
	Next
EndFunc

Func AnimateDown($row, $col, $color)
	For $col2 = 1 To $col
		If $col2 >= 1 Then SetFilled($row, $col2-1, $bkcolor)
		SetFilled($row, $col2, $color)
		Sleep(25)
	Next
EndFunc   ;==>AnimateDown

Func CheckFour($row, $col, $color)
	Dim $filled = 0, $ignore = 0, $colors
	;horizontal
	For $row2 = $row - 3 To $row + 3
		$ignore = 0
		If $row2 > 7 Then $ignore = 1
		If $row2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row2][$col])
		EndIf
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
	
	;vertical
	For $col2 = $col - 3 To $col + 3
		$ignore = 0
		If $col2 > 6 Then $ignore = 1
		If $col2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row][$col2])
		EndIf
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
	
	;diagonal top right
	$row2 = $row - 3
	For $col2 = $col + 3 To $col - 3 Step -1
		$ignore = 0
		If $col2 > 6 Then $ignore = 1
		If $col2 < 1 Then $ignore = 1
		If $row2 > 7 Then $ignore = 1
		If $row2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row2][$col2])
		EndIf
		If $row2 = $row + 3 Then ExitLoop
		$row2 += 1
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
	
	;diagonal top left
	$row2 = $row + 3
	For $col2 = $col + 3 To $col - 3 Step -1
		$ignore = 0
		If $col2 > 6 Then $ignore = 1
		If $col2 < 1 Then $ignore = 1
		If $row2 > 7 Then $ignore = 1
		If $row2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row2][$col2])
		EndIf
		If $row2 = $row - 3 Then ExitLoop
		$row2 -= 1
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
EndFunc   ;==>CheckFour


Func SetFilled($row, $col, $color)
	If StringLen($color) = 1 Then
		GUICtrlSetcolor($table[$row][$col], GetColour($color))
		GUICtrlSetBkColor($table[$row][$col], GetColour($color))
	Else
		GUICtrlSetcolor($table[$row][$col], $color)
		GUICtrlSetBkColor($table[$row][$col], $color)
	EndIf
	GUICtrlSetData($table[$row][$col], $color)
EndFunc   ;==>SetFilled

Func SwapColor($color)
	If $color = "r" Then
		$color = "b"
	Else
		$color = "r"
	EndIf
	Return $color
EndFunc   ;==>SwapColor

Func ShrtColour($string)
	Return StringTrimLeft(StringTrimRight($string, 5), 2)
EndFunc   ;==>ShrtColour

Func GetColour($string)
	If $string = "r" Then Return 0xff0000
	If $string = "b" Then Return 0x0000ff
EndFunc   ;==>GetColour

Func StringBetween($s, $from, $to)
	$x = StringInStr($s, $from) + StringLen($from)
	$y = StringInStr(StringTrimLeft($s, $x), $to)
	Return StringMid($s, $x, $y)
EndFunc   ;==>StringBetween

Func NumOfOccurences($string, $substring)
	StringReplace($string, $substring, "")
	Return @extended
EndFunc   ;==>NumOfOccurences

Func TableSetData($row, $col, $data)
	GUICtrlSetData($stats[$row][$col], $data)
EndFunc

Func TableMultiSetData($row, $col, $endrow, $endcol, $data)
	If StringInStr($data, "|") <> 0 Then
		$sData = StringSplit($data, "|")
		$numdata = 1
		For $row2 = $row To $endrow
			For $col2 = $col To $endcol
				GUICtrlSetData($stats[$row2][$col2], $sData[$numdata])
				$numdata += 1
			Next
		Next
	Else
		For $row2 = $row To $endrow
			For $col2 = $col To $endcol
				GUICtrlSetData($stats[$row2][$col2], $data)
			Next
		Next
	EndIf
EndFunc

Func AddWin($type)
	If $type = "r" Then
		$oldwin = GUICtrlRead($stats[2][2])
		GUICtrlSetData($stats[2][2], $oldwin+1)
		GUICtrlSetData($stats[3][3], $oldwin+1)
	Else
		$oldwin = GUICtrlRead($stats[2][3])
		GUICtrlSetData($stats[2][3], $oldwin+1)
		GUICtrlSetData($stats[3][2], $oldwin+1)
	EndIf
EndFunc

Func AddDraw()
	$olddraw = GUICtrlRead($stats[2][4])
	GUICtrlSetData($stats[2][4], $olddraw+1)
	GUICtrlSetData($stats[3][4], $olddraw+1)
EndFunc

Func _GuiCtrlCreateButtonsCentered($text, $guiwidth, $top, $width, $height, $gap = 5, $delim = ",")
	$btntext = StringSplit($text, $delim)
	$totalwidth = ($width * $btntext[0]) + (5 * ($btntext[0]-1))
	Dim $buttons[$btntext[0]+1]
	For $i = 1 To $btntext[0]
		$buttons[$i-1] = GUICtrlCreateButton($btntext[$i], ($guiwidth/2) - ($totalwidth/2) + ($width * ($i-1)) + ($gap * ($i - 1)), $top, $width, $height)
	Next
	Return $buttons
EndFunc
