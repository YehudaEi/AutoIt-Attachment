$aimove = 2.5
$moved = 0
$smove = 0
$boost = 0
$btime = TimerInit()
HotKeySet("w", "fc")
HotKeySet("s", "fc")
#include <Misc.au3>
#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Banana Pong", 209, 205, 193, 115)
$Label1 = GUICtrlCreateLabel("Pong Setup", 8, 8, 60, 17)
$Label2 = GUICtrlCreateLabel("Player 1 Controls:", 8, 32, 86, 17)
$Radio1 = GUICtrlCreateRadio("Keys", 8, 56, 97, 17)
$Radio2 = GUICtrlCreateRadio("Mouse", 112, 56, 81, 17)
$Checkbox1 = GUICtrlCreateCheckbox("AI Player", 8, 80, 97, 17)
$Combo1 = GUICtrlCreateInput("", 80, 104, 65, 25)
$Label3 = GUICtrlCreateLabel("Points to Win:", 8, 105, 70, 17)
GUIStartGroup()
$rad1 = GUICtrlCreateRadio("Easy AI", 8, 135)
$rad2 = GUICtrlCreateRadio("Hard AI", 70, 135)
GUIStartGroup()
$Button1 = GUICtrlCreateButton("Start!", 16, 165, 177, 33, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
$inittime = TimerInit()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		
	Case $Button1
		If StringIsAlNum(GUICtrlRead($Combo1)) = 1 Then
			If GUICtrlRead($Radio1) = $GUI_CHECKED Then
				$keys = 1
			Else
				$keys = 0
			EndIf
			If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
				$ai = 1
			Else
				$ai = 0
			EndIf
			If GUICtrlRead($rad2) = $GUI_CHECKED Then
				$aimove = 4
			Else
				$aimove = 3
			EndIf
			$plim = GUICtrlRead($Combo1)
			ExitLoop
		Else
			MsgBox(0, "Pong", "The Points To Win Value needs to be a number.")
		EndIf
	EndSwitch
WEnd

$gui = GUICreate("Pong", 300, 200)
$p1 = GUICtrlCreateLabel("", 5, 85, 10, 30)
$points = GUICtrlCreateLabel("", 10, 10, 50)
$p1t = 85
$p2 = GUICtrlCreateLabel("", 285, 85, 10, 30)
$p2t = 85
$ball = GUICtrlCreateLabel("", 145, 95, 10, 10)
$pl1points = 0
$pl2points = 0
$hit = 0
GUICtrlSetBkColor($p1, 0x000000)
GUICtrlSetBkColor($p2, 0x000000)
GUICtrlSetBkColor($ball, 0x990000)
$bl = 145
$bt = 95
	$movel = -3
	$movet = 3
GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	EndSelect
	If TimerDiff($inittime) > 10 Then
	Select
	Case _IsOn(5, $p1t, 10, 30, $bl, $bt, 10, 10) = 1
		If $hit = 0 Then
			If BitAND($bt + 5 < $p1t + 27, $bt + 5 > $p1t + 3) Then
				If _IN($movel) = 1 Then
					$movel = 3
				Else
					$movel = -3
				EndIf
				If _IN($movet) = 1 Then
					$movet = -3
				Else
					$movet = 3
				EndIf
			Else
				;If _IN($movel) = 1 Then
					$movel = 2
				;Else
				;	$movel = -2
				;EndIf

					If $bt + 5 > $p1t + 15 Then
						$movet = 4
					Else
						$movet = -4
					EndIf
			EndIf
			$hit = 1
		EndIf
	Case BitAND($bl + 10 > 285, $bt < $p2t + 30, $bt + 10 > $p2t) = 1
		If $hit = 0 Then
			If BitAND($bt + 5 < $p2t + 27, $bt + 5 > $p2t + 3) Then
				If _IN($movel) = 1 Then
					$movel = 3
				Else
					$movel = -3
				EndIf
				If _IN($movet) = 1 Then
					$movet = -3
				Else
					$movet = 3
				EndIf
			Else
				;If _IN($movel) = 1 Then
				;	$movel = 2
				;Else
					$movel = -2
				;EndIf
					If $bt + 5 > $p2t + 15 Then
						$movet = 4
					Else
						$movet = -4
					EndIf
				EndIf
			$hit = 1
		EndIf
	Case _IsOn(5, $p1t, 10, 30, $bl, $bt, 10, 10) = 0
		$hit = 0
	Case BitAND($bl + 10 > 285, $bt < $p2t + 30, $bt + 10 > $p2t) = 0
		$hit = 0
EndSelect
	Select
	Case _IsPressed("26")
		$p1t = $p1t - 3
	Case _IsPressed("28")
		$p1t = $p1t + 3
	EndSelect
	If $ai = 0 Then
		Select
		Case _IsPressed("53")
			$p2t = $p2t + 3
		Case _IsPressed("57")
			$p2t = $p2t - 3
		EndSelect
	Else
		If $moved > 17 Then
			If $p2t + 30 > $bt + 5 Then
				$smove = _NT($aimove)
			ElseIf $p2t < $bt + 5 Then
				$smove = $aimove
			EndIf
		$moved = 0
		EndIf
		$p2t = $p2t + $smove
		$moved = $moved + $aimove
	EndIf
	If $pl1points = $plim Then
		MsgBox(0, "Game Over", "Player 1 Won!")
		If @Compiled = 1 Then
			Run(@ScriptFullPath)
		Else
			Run(@AutoItExe & " " & @ScriptName)
		EndIf
		Exit
	ElseIf $pl2points = $plim Then
		MsgBox(0, "Game Over", "Player 2 Won!")
		If @Compiled = 1 Then
			Run(@ScriptFullPath)
		Else
			Run(@AutoItExe & " " & @ScriptName)
		EndIf
		Exit
	EndIf
	$coords = GUIGetCursorInfo()
	If $keys = 0 Then
		$p1t = $coords[1]
	EndIf
	If TimerDiff($inittime) < 20 Then
	GUICtrlSetPos($p1, 5, $p1t)
	GUICtrlSetPos($p2, 285, $p2t)
	EndIf
	If $bl < 0 Then
		If $wall = 0 Then
			$movel = _Rev($movel)
			$pl2points += 1
			$wall = 1
		EndIf
	ElseIf $bl > 290 Then
		If $wall = 0 Then
			$movel = _Rev($movel)
			$pl1points += 1
			$wall = 1
		EndIf
	Else
		$wall = 0
	EndIf
	If $bt < 0 Then
		$movet = _Rev($movet)
	ElseIf $bt > 190 Then
		$movet =_Rev($movet)
	EndIf
	$bl = $movel + $bl
	$bt = $bt + $movet
	GUICtrlSetPos($ball, $bl, $bt)
	GUICtrlSetData($points, $pl1points & " - " & $pl2points)
	$inittime = TimerInit()
	EndIf
WEnd
Func _IsOn ($left1, $top1, $width1, $height1, $left2, $top2, $width2, $height2)
	If StringIsAlNum($left1 & $top1 & $width1 & $height1 & $left2 & $top2 & $width2 & $height2) = 0 Then
		Return -1
	EndIf
	$lewi1 = $left1 + $width1
	$tohi1 = $height1 + $top1
	$lewi2 = $left2 + $width2
	$tohi2 = $height2 + $top2
	If BitAND($left1 < $lewi2, $lewi1 > $left2, $tohi1 > $top2, $top1 < $tohi2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc
Func _IsBetween ($min, $max, $num)
	If BitAND($num > $min - 1, $num < $max + 1) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc
Func _Around ($numin, $around, $numbase)
	If BitAND($numin < $numbase + $around, $numin > $numbase - $around) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func _Rev ($num)
	If $num < 0 Then
		$num = $num + StringReplace(($num * 2), "-", "")
	ElseIf $num > 0 Then
		$num = $num - ($num * 2)
	EndIf
	Return $num
EndFunc

Func _IN ($num)
	If $num < 0 Then
		Return 1
	ElseIf $num > 0 Then
		Return 0
	EndIf
EndFunc

Func _NT($num)
	If $num < 0 Then Return $num
	Return "-" & $num
EndFunc

Func fc ()
EndFunc