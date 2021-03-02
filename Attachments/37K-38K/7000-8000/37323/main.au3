#include <Array.au3>
#include <GuiStatusBar.au3>
Dim $button[4][4]
Dim $vals[4][4]
$c = 0
Dim $gvals[5] = [0,Random(1,9,1),0,0,0]
$win = 0
$lost = 0
$vers = "v0.3"
While 1
	init($button)
	init($vals)
	$i = 2
	While $i<=4
		$rand = Random(1,9,1)
		If _ArraySearch($gvals,$rand) = -1 Then
			$gvals[$i] = $rand
			$i += 1
		EndIf
	WEnd
	For $i = 1 to 3 Step 1
		For $j = 1 to 3 Step 1
			If $vals[$i][$j] = 1 Then $q= 1
		Next
	Next
	$ar = _array2D_1D($vals)

	ReDim $ar[10]
	For $i = 1 to 4 Step 1
		$ar[$gvals[$i]] = 1
	Next
	;~ _ArrayDisplay($ar)

	Global $arr = _Array1D_2D($ar)
	ReDim $arr[5][5]
;~ 	_ArrayDisplay($arr) ;show right buttons
	Dim $button[4][4]
	Dim $games[2] = ["Games win : "&$win,"Games lost : "&$lost]

	$form = GUICreate("PuzzleGame",171,210)
	$menu1 = GUICtrlCreateMenu("Game")
	$menu2 = GUICtrlCreateMenu("Help")
	$menu1_1 = GUICtrlCreateMenuItem("New Game",$menu1)
	GUICtrlCreateMenuItem("",$menu1)
	$menu1_2 = GUICtrlCreateMenuItem("Exit Game",$menu1)
	$menu2_1 = GUICtrlCreateMenuItem("Help",$menu2)
	GUICtrlCreateMenuItem("",$menu2)
	$menu2_2 = GUICtrlCreateMenuItem("About",$menu2)
	$stsbar = _GUICtrlStatusBar_Create($form,90,$games)
	$x = 3
	$y = 5
	Global $wrongs = 0
	Global $good = 0
	For $i = 1 to 3 Step 1
		For $j = 1 to 3 Step 1
			$n = 0
			$button[$i][$j] = GUICtrlCreateButton("",$x,$y,51,51)
			If $arr[$i-1][$j] = 1 Then $n += 1
			If $arr[$i+1][$j] = 1 Then $n += 1
			If $arr[$i][$j-1] = 1 Then $n += 1
			If $arr[$i][$j+1] = 1 Then $n += 1
			GUICtrlSetData(-1,$n)
			$x += 55
		Next
		$y += 55
		$x = 3
	Next
	GUISetState()
	While 1
		If $wrongs = 2 Then
			If MsgBox(52,"PuzzleGame","To many wrongs"&@LF&"You wana play again?",0,$form) = 6 Then
				$lost += 1
				GUIDelete()
				ExitLoop
			Else
				Exit 3
			EndIf
		EndIf
		If $good = 4 Then
			If MsgBox(68,"PuzzleGame","Good Game"&@LF&"You wana play again?",0,$form) = 6 Then
				$win += 1
				GUIDelete()
				ExitLoop
			Else
				Exit 1
			EndIf
		EndIf
		$msg = GUIGetMsg()
		Switch $msg
			Case $button[1][1]
				_test_button(1,1)
			Case $button[1][2]
				_test_button(1,2)
			Case $button[1][3]
				_test_button(1,3)
			Case $button[2][1]
				_test_button(2,1)
			Case $button[2][2]
				_test_button(2,2)
			Case $button[2][3]
				_test_button(2,3)
			Case $button[3][1]
				_test_button(3,1)
			Case $button[3][2]
				_test_button(3,2)
			Case $button[3][3]
				_test_button(3,3)
			Case $menu1_1
				GUIDelete()
				ExitLoop
			Case $menu1_2, -3
				Exit 2
			Case $menu2_1
				MsgBox(64,"Help","Number indicators for each button indicate how many of"&@LF&"button's adjacent buttons are correct buttons, excluding diagonals and itself."&@lf&"(e.g. 0 means all buttons adjacent to that button are incorrect)",0,$form)
			Case $menu2_2
				MsgBox(64,"About","Programated by Ababei Andrei (PlayHD) in AutoIt3"&@lf&"PuzzleGame "&$vers&@lf&@LF&"All right reserved.",0,$form)
		EndSwitch
	WEnd
WEnd
Func init(ByRef $array)
	Local $i, $j
	For $i = 1 to 3 Step 1
		For $j = 1 to 3 Step 1
			$array[$i][$j] = 0
		Next
	Next
EndFunc

func _array2D_1D($2dArray)
	Dim $1darray[10]
	Local $i, $j, $k = 1
	For $i = 1 to 3 Step 1
		For $j = 1 to 3 Step 1
			$1darray[$k] = $2dArray[$i][$j]
			$k += 1
		Next
	Next
	Return $1darray
EndFunc

Func _Array1D_2D($1darray)
	Dim $2dArray[4][4]
	Local $k = 1
	For $i = 1 to 3 Step 1
		For $j = 1 to 3 Step 1
			$2dArray[$i][$j] = $1darray[$k]
			$k += 1
		Next
	Next
	Return $2dArray
EndFunc

Func _test_button($i,$j)
	If $arr[$i][$j] = 1 Then
		$good +=1
		GUICtrlSetBkColor($button[$i][$j],0x228B22)
	Else
		$wrongs +=1
		GUICtrlSetBkColor($button[$i][$j],0xEE3B3B)
	EndIf
	GUICtrlSetState($button[$i][$j],128)
EndFunc