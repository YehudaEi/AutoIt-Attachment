#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

$c=Floor(Random()*0x1000000)

$speed = 3
$winW = 800
$winH = 600
$winMargin = 5

$greenscore = 0
$redscore = 0
$gscorew = 21
$rscorew = 21

$aLeft = 650
$aTop = 300
$aWidth = 25
$aHeight = 33

$bLeft = 50
$bTop = 300
$bWidth = 25
$bHeight = 33

$goalX = 700
$goalY = 275
$goalW = 75
$goalH = 75

$winMain = GUICreate("2 Player Game", $winW, $winH)
GUISetBkColor($c)
$lbl = GUICtrlCreateLabel("use wasd keys to move the green X into the goal without the red X touching you", 50, 50)
$lbl2 = GUICtrlCreateLabel("use arrow keys to move the red X into the green X", 50, 70)
$label1 = GUICtrlCreateLabel("X", $bLeft, $bTop, $bWidth, $bHeight)
GUICtrlSetFont($label1, 24, 1600)
GUICtrlSetBkColor($label1, 0x00bb00)
$label2 = GUICtrlCreateLabel("X", $aLeft, $aTop, $aWidth, $aHeight)
GUICtrlSetFont($label2, 24, 1600)
GUICtrlSetBkColor($label2, 0xff0000)
$label3 = GUICtrlCreateLabel(" GOAL ", $goalX, $goalY, $goalW, $goalH)
GUICtrlSetFont($label3, 12, 800)
GUICtrlSetBkColor($label3, 0xcc9999)
$label4 = GUICtrlCreateLabel($greenscore, 500, 50, $gscorew, 20)
GUICtrlSetFont($label4, 12, 800)
GUICtrlSetBkColor($label4, 0x00bb00)
$label5 = GUICtrlCreateLabel($redscore, 700, 50, $rscorew, 20)
GUICtrlSetFont($label5, 12, 800)
GUICtrlSetBkColor($label5, 0xff0000)
$label6 = GUICtrlCreateLabel("scores", 600, 50, 60, 20)
GUICtrlSetFont($label6, 12, 800)
$button = GUICtrlCreateButton( "Save Game", 727, 8)
$button2 = GUICtrlCreateButton( "Load Game", 727, 33)
WinSetTrans( "2 Player Game", "", 150)
GUISetState()


While 1
	$nMsg=GUIGetMsg()

	If $nMsg == $GUI_EVENT_CLOSE Then Exit

	If _IsPressed(25) Then _LEFT()
	If _IsPressed(26) Then _UP()
	If _IsPressed(27) Then _RIGHT()
	If _IsPressed(28) Then _DOWN()
	If _IsPressed(41) Then _LEFT2()
	If _IsPressed(57) Then _UP2()
	If _IsPressed(44) Then _RIGHT2()
	If _IsPressed(53) Then _DOWN2()
	If _IsPressed(70) Then _CHEAT()
	If _IsPressed(38) Then _CHEAT2()

	If $nMsg = $button Then _Save()
	If $nMsg = $button2 Then _Load()

	If $aLeft - 25 <= $bLeft And $bLeft <= $aLeft + 25 And $aTop - 33 <= $bTop And $bTop <= $aTop + 33 Then
		MsgBox(0, "results:", "green loses, red wins")
		$bLeft = 100
		$bTop = 100
		$aLeft = 650
		$aTop = 300
		$redscore += 1
		$c=Floor(Random()*0x1000000)
		GUISetBkColor($c)
	EndIf

	ControlSetText("", "", $label1, "X")
	GUICtrlSetBkColor($label1, 0x00bb00)
	ControlSetText("", "", $label2, "X")
	GUICtrlSetBkColor($label2, 0xff0000)

	ControlMove($winMain, "", $label1, $bLeft, $bTop)
	ControlMove($winMain, "", $label2, $aLeft, $aTop)
	ControlSetText($winMain, "", $label4, $greenscore)
	ControlSetText($winMain, "", $label5, $redscore)

	_check_goal()

WEnd

Func _LEFT()
	$aLeft -= $speed
	If $aLeft < $winMargin Then $aLeft = $winMargin
EndFunc   ;==>_LEFT

Func _UP()
	$aTop -= $speed
	If $aTop < $winMargin Then $aTop = $winMargin
EndFunc   ;==>_UP

Func _RIGHT()
	$aLeft += $speed
	If $aLeft > $winW - ($aWidth + $winMargin) Then $aLeft = $winW - ($aWidth + $winMargin)
EndFunc   ;==>_RIGHT

Func _DOWN()
	$aTop += $speed
	If $aTop > $winH - ($aHeight + $winMargin) Then $aTop = $winH - ($aHeight + $winMargin)
EndFunc   ;==>_DOWN

Func _LEFT2()
	$bLeft -= $speed
	If $bLeft < $winMargin Then $bLeft = $winMargin
EndFunc   ;==>_LEFT2

Func _UP2()
	$bTop -= $speed
	If $bTop < $winMargin Then $bTop = $winMargin
EndFunc   ;==>_UP2

Func _RIGHT2()
	$bLeft += $speed
	If $bLeft > $winW - ($bWidth + $winMargin) Then $bLeft = $winW - ($bWidth + $winMargin)
EndFunc   ;==>_RIGHT2

Func _DOWN2()
	$bTop += $speed
	If $bTop > $winH - ($bHeight + $winMargin) Then $bTop = $winH - ($bHeight + $winMargin)
EndFunc   ;==>_DOWN2

Func _check_goal()

	If $bTop > $goalY And $bLeft > $goalX Then
		If $bTop + $bHeight < $goalY + $goalH And $bLeft + $bWidth < $goalX + $goalW Then
			MsgBox(0, "Goal", "GOOOOOOOAAAAAAAAAAAAAAAAAAAAAAAAAL!!!")
			$bLeft = 100
			$bTop = 100
			$aLeft = 650
			$aTop = 300
			$greenscore += 1
			$c=Floor(Random()*0x1000000)
			GUISetBkColor($c)
		EndIf
	EndIf

EndFunc   ;==>_check_goal

Func _CHEAT()
	$speed = 10
EndFunc   ;==>_CHEAT

Func _CHEAT2()
	$bLeft = $goalX + 5
	$bTop = $goalY + 5
EndFunc   ;==>_CHEAT2

Func _Save()
	$saveRx=ControlGetPos("","",$label2)
	$saveGx=ControlGetPos("","",$label1)
	$saveGscore=ControlGetText("","",$label4)
	$saveRscore=ControlGetText("","",$label5)
	IniWrite("2 player game save.ini", "red position", $saveRx[0], $saveRx[1])
	IniWrite("2 player game save.ini", "green position", $saveGx[0], $saveGx[1])
	IniWrite("2 player game save.ini", "green score", "green score ", " " & $saveGscore)
	IniWrite("2 player game save.ini", "red score", "red score ", " " & $saveRscore)
EndFunc

Func _Load()
	BlockInput(1)
	$gp=IniReadSection("2 player game save.ini", "green position")
	If $gp = 1 Then
		MsgBox(0, "Error", "there is no save file.")
		_Save()
		Exit
	EndIf
	$bLeft=$gp[1][0]
	$bTop=$gp[1][1]
	ControlMove("","",$label2, $gp[1][0], $gp[1][1])
	$rp=IniReadSection("2 player game save.ini", "red position")
	If $rp = 1 Then
		MsgBox(0, "Error", "there is no save file.")
		_Save()
		Exit
	EndIf
	$aLeft=$rp[1][0]
	$aTop=$rp[1][1]
	ControlMove( "", "", $label1, $rp[1][0], $rp[1][1])
	$gs=IniReadSection("2 player game save.ini", "green score")
	$greenscore=$gs[1][1]
	ControlSetText("","",$label4,$gs[1][1])
	$rs=IniReadSection("2 player game save.ini", "red score")
	$redscore=$rs[1][1]
	ControlSetText("","",$label5,$rs[1][1])
	IniDelete("2 player game save.ini", "red position")
	IniDelete("2 player game save.ini", "green position")
	IniDelete("2 player game save.ini", "red score")
	IniDelete("2 player game save.ini", "green score")
	BlockInput(0)
EndFunc