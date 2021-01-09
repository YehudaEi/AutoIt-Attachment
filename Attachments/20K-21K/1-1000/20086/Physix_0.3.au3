#include <GUIConstants.au3>
HotKeySet("{F1}", "reset")
HotKeySet("e", "walls")
HotKeySet("q", "origin")
HotKeySet("{SPACE}", "turbo")
HotKeySet("{UP}", "Rocket")
HotKeySet("a", "left")
HotKeySet("d", "right")
HotKeySet("w", "up")
HotKeySet("s", "down")
HotKeySet("r", "fup")
HotKeySet("f", "fdown")
HotKeySet("t", "tup")
HotKeySet("g", "tdown")
$Walls = True
$Ent_Momentum = 0
$LCollective = 0
$Ent_Weight = 10
$Gravity = 2
$Ent_Speed = 1
$isFalling = True
$Collective = 0
$Form1 = GUICreate("Physix", 776, 503, 193, 125)
$Pic1 = GUICtrlCreatePic("PhysixWorld.bmp", 0, 0, 550, 500, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
GUICtrlSetState(-1, $GUI_DISABLE)
$Entity = GUICtrlCreatePic("Entity.bmp", 275, 250, 20, 20)
$floos = GUICtrlCreatePic("Entity.bmp", 0, 320, 550, 5)
$Group1 = GUICtrlCreateGroup("Entity", 550, 0, 226, 81)
$Input1 = GUICtrlCreateInput("Input1", 575, 25, 56, 21)
$Label1 = GUICtrlCreateLabel("A:", 555, 25, 14, 17)
$Label2 = GUICtrlCreateLabel("H:", 635, 25, 14, 17)
$Input2 = GUICtrlCreateInput("Input2", 650, 25, 56, 21)
$Label3 = GUICtrlCreateLabel("Speed:", 555, 50, 38, 17)
$Input3 = GUICtrlCreateInput("Input3", 595, 50, 111, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Engine", 550, 85, 226, 160)
$Label4 = GUICtrlCreateLabel("Gravity:", 555, 110, 40, 17)
$Input4 = GUICtrlCreateInput("2", 595, 110, 111, 21)
$Label5 = GUICtrlCreateLabel("Floor Position:", 555, 140, 70, 17)
$Input5 = GUICtrlCreateInput("300", 630, 140, 76, 21)
$Label6 = GUICtrlCreateLabel("Walls:", 555, 170, 70, 17)
$Input6 = GUICtrlCreateInput($Walls, 630, 170, 76, 21)
GUISetState(@SW_SHOW)
While 1
	Sleep(20)
	GUICtrlSetPos($floos, 0, GUICtrlRead($Input5) + 20)
	$Gravity = GUICtrlRead($Input4)
	$Floor = GUICtrlRead($Input5)
	$nMsg = GUIGetMsg()
	$Pos = ControlGetPos("Physix", "", $Entity)
	If $isFalling = True Then
		$Collective += $Gravity
		$Ent_Momentum = Round($Collective / 2, 0)
		$Ent_Speed = $Ent_Momentum
		If $Pos[1] + $Ent_Speed > $Floor Then
			If $Walls = True Then
				GUICtrlSetPos($Entity, $Pos[0], $Floor + 1, 20, 20)
			Else
				GUICtrlSetPos($Entity, $Pos[0], $Pos[1] + $Ent_Speed, 20, 20)
			EndIf
		Else
			GUICtrlSetPos($Entity, $Pos[0], $Pos[1] + $Ent_Speed, 20, 20)
		EndIf
	Else
		$Collective -= $Gravity
		$Ent_Momentum = $Collective
		$Ent_Speed = $Ent_Momentum
		If $Ent_Speed < 1 Then $Ent_Speed = 0
		If $Collective < 1 Then $Collective = 0
		GUICtrlSetPos($Entity, $Pos[0], $Pos[1] - $Ent_Speed, 20, 20)
	EndIf
	$Pos = ControlGetPos("Physix", "", $Entity)
	If $LCollective <> 0 Then
		GUICtrlSetPos($Entity, $Pos[0] + $LCollective, $Pos[1], 20, 20)
	EndIf
	$Pos = ControlGetPos("Physix", "", $Entity)
	GUICtrlSetData($Input1, $LCollective)
	GUICtrlSetData($Input2, ($Pos[1] - $Floor) * - 1 & " ft")
	GUICtrlSetData($Input3, $Ent_Speed)
	If $Walls = True Then
		If $Pos[0] < 5 Then
			$LCollective += 1
			$LCollective *= -1
			SoundPlay("Bounce.wav")
			GUICtrlSetPos($Entity, 5, $Pos[1], 20, 20)
		EndIf
		If $Pos[0] > 525 Then
			$LCollective -= 1
			$LCollective *= -1
			SoundPlay("Bounce.wav")
			GUICtrlSetPos($Entity, 525, $Pos[1], 20, 20)
		EndIf
		If $Pos[1] > $Floor Then
			$isFalling = False
			$Collective = Round($Collective * (2 / 3), 0)
			SoundPlay("Bounce.wav")
		EndIf
		If $Pos[1] > $Floor + 5 Then
			$isFalling = True
			GUICtrlSetPos($Entity, $Pos[0], 0, 20, 20)
		EndIf
	Else
		If $Pos[1] > 425 Then
			GUICtrlSetPos($Entity, $Pos[0], 0, 20, 20)
		EndIf
	EndIf
	If $Collective = 0 Then
		$isFalling = True
	EndIf
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			MsgBox(64, "Thank you!", "Thanks for trying out Physix!")
			Exit

	EndSwitch
WEnd
Func reset()
	$mPos = MouseGetPos()
	$Pos = WinGetPos("Physix")
	$x = $mPos[0] - $Pos[0]
	$y = $mPos[1] - $Pos[1]
	$isFalling = True
	$Collective = 0
	GUICtrlSetPos($Entity, $x, $y, 20, 20)
EndFunc   ;==>reset
Func walls()
	If $Walls = True Then
		$Walls = False
		GUICtrlDelete($floos)
	Else
		$Walls = True
		$floos = GUICtrlCreatePic("Entity.bmp", 0, 320, 550, 5)
	EndIf
	GUICtrlSetData($Input6, $Walls)
EndFunc   ;==>walls
Func left()
	$Pos = ControlGetPos("Physix", "", $Entity)
	$LCollective -= 1
	If $Pos[0] > 5 Then
		GUICtrlSetPos($Entity, $Pos[0] - 5, $Pos[1], 20, 20)
	EndIf
EndFunc   ;==>left
Func right()
	$Pos = ControlGetPos("Physix", "", $Entity)
	$LCollective += 1
	If $Pos[0] < 525 Then
		GUICtrlSetPos($Entity, $Pos[0] + 5, $Pos[1], 20, 20)
	EndIf
EndFunc   ;==>right
Func up()
	If $isFalling = True Then
		$Collective -= 1
	Else
		$Collective += 1
	EndIf
EndFunc   ;==>up
Func down()
	If $isFalling = True Then
		$Collective += 1
	Else
		$Collective -= 1
	EndIf
EndFunc   ;==>down
Func turbo()
	$isFalling = False
	$Collective += 15
EndFunc   ;==>turbo
Func origin()
	GUICtrlSetPos($Entity, 275, 0, 20, 20)
	SoundPlay("Origin.wav")
EndFunc   ;==>origin
Func fup()
	GUICtrlSetData($Input5,GUICtrlRead($Input5) - 10)
EndFunc
Func fdown()
	GUICtrlSetData($Input5,GUICtrlRead($Input5) + 10)
EndFunc
Func tup()
	GUICtrlSetData($Input4,GUICtrlRead($Input4) + 1)
EndFunc
Func tdown()
	GUICtrlSetData($Input4,GUICtrlRead($Input4) - 1)
EndFunc
Func Rocket()
	SoundPlay("Rocket.wav",1)
	$isFalling = False
	$Collective += 200
EndFunc