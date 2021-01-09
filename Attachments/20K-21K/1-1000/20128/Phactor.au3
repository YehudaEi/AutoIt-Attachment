#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=reactos2.ico
#AutoIt3Wrapper_outfile=Phactor.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
HotKeySet("{ESC}", "esca")
HotKeySet("^c", "commandpanel")
HotKeySet("{SPACE}", "turbo")
HotKeySet("a", "left")
HotKeySet("d", "right")
HotKeySet("w", "up")
HotKeySet("s", "down")
HotKeySet("p", "Pause")
Dim $Achievment[9]
$Achievment[0] = False
$Achievment[1] = False
$Achievment[2] = False
$Achievment[3] = False
$Achievment[4] = False
$Achievment[5] = False
$Achievment[6] = False
$Achievment[7] = False
$Achievment[8] = False
$Achieve = "Your Achievements:" & @CRLF
$Res = 2
$Side = 0
$isPaused = False
$Walls = True
$Ent_Momentum = 0
$LCollective = 0
$Ent_Weight = 10
$Cont = 0
$Gravity = 2
$Ent_Speed = 1
$isFalling = True
$Collective = 0
$Points = 0
$Jumped = False
$Form1 = GUICreate("Phactor - By Vindicator", 776, 503, 193, 125)
$Pic1 = GUICtrlCreatePic("World.bmp", 0, 0, 550, 500, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
GUICtrlSetState(-1, $GUI_DISABLE)
$Entity = GUICtrlCreatePic("Entity.bmp", 275, 250, 20, 20)
$CEntity = GUICtrlCreatePic("Entity2.bmp", Random(5, 525, 1), Random(5, 480, 1), 40, 40)
$floos = GUICtrlCreatePic("Entity.bmp", 0, 320, 550, 5)
$Group1 = GUICtrlCreateGroup("Entity", 550, 0, 226, 81)
GUICtrlSetColor(-1,0xb3f3fc)
$Input1 = GUICtrlCreateInput("X", 575, 25, 56, 21, $ES_READONLY)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$Label1 = GUICtrlCreateLabel("A:", 555, 25, 14, 17)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$Label2 = GUICtrlCreateLabel("H:", 635, 25, 14, 17)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$Input2 = GUICtrlCreateInput("X", 650, 25, 56, 21, $ES_READONLY)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$Label3 = GUICtrlCreateLabel("Speed:", 555, 50, 38, 17)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$Input3 = GUICtrlCreateInput("X", 595, 50, 111, 21, $ES_READONLY)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Engine", 550, 85, 225, 145)
GUICtrlSetState(-1, $GUI_HIDE)
$Label4 = GUICtrlCreateLabel("Gravity:", 555, 110, 40, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$Input4 = GUICtrlCreateInput("2", 595, 110, 111, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$Label5 = GUICtrlCreateLabel("Floor Position:", 555, 140, 70, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$Input5 = GUICtrlCreateInput("480", 630, 140, 76, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$Label6 = GUICtrlCreateLabel("Walls:", 555, 170, 70, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$Input6 = GUICtrlCreateInput($Walls, 630, 170, 76, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$Label7 = GUICtrlCreateLabel("W. Resist.:", 555, 200, 70, 17)
GUICtrlSetState(-1, $GUI_HIDE)
$Input7 = GUICtrlCreateInput($Res, 630, 200, 76, 21)
GUICtrlSetState(-1, $GUI_HIDE)
$Time = GUICtrlCreateLabel("Time Left:", 555, 235, 70, 17)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$Timer = GUICtrlCreateInput("60 secs", 630, 235, 76, 21, $ES_READONLY)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$Pts = GUICtrlCreateLabel("Points:", 555, 265, 70, 17)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
$PtsCount = GUICtrlCreateInput("0", 630, 265, 76, 21, $ES_READONLY)
GUICtrlSetBkColor(-1,0x052268)
GUICtrlSetColor(-1,0xb3f3fc)
GUISetState(@SW_SHOW)
GUISetBkColor(0x052268)
Run("Background.exe")
MsgBox(0, "Ready?", "The timer will start right away! Collect as many [Yellow] Blocks as you can! Your are [Black]")
$Timers = TimerInit()
While 1
	$Left = 60 - Round((TimerDiff($Timers) - ($Points * 3000)) / 1000, 1)
	If $Left < 0 Then $Left = 0
	GUICtrlSetData($Timer, $Left & " secs")
	If $Left = 0 Then
		SoundPlay("Fanfare.wav")
		MsgBox(0, "TIME!", "Congratulations you got " & $Points & " Points in " & Round((TimerDiff($Timers) + ($Points * 3000)) / 1000, 1) & " seconds")
		If $Achievment[0] = True Then $Achieve = $Achieve & "You completed Double catch![Get 2 points without touching the ground]" & @CRLF
		If $Achievment[1] = True Then $Achieve = $Achieve & "You completed Triple catch![Get 3 points without touching the ground]" & @CRLF
		If $Achievment[2] = True Then $Achieve = $Achieve & "You completed Quadriple catch![Get 4 points without touching the ground]" & @CRLF
		If $Achievment[3] = True Then $Achieve = $Achieve & "You completed Master catcher![Get 5 points without touching the ground]" & @CRLF
		If $Achievment[4] = True Then $Achieve = $Achieve & "You completed Mission Impossible![Get 10 points without touching the ground]" & @CRLF
		If $Achievment[5] = True Then $Achieve = $Achieve & "You completed Speed Demon![Reach a speed of 70]" & @CRLF
		If $Achievment[6] = True Then $Achieve = $Achieve & "You completed Wall Jump![Stick to the wall for 8 bounces]" & @CRLF
		If $Achievment[7] = True Then $Achieve = $Achieve & "You completed Endurance![Get 75 points]" & @CRLF
		If $Achievment[8] = True Then $Achieve = $Achieve & "You completed Cheater![Opened the command window]" & @CRLF
		MsgBox(48, "Achievments!", $Achieve)
		ProcessClose("Background.exe")
		Exit
	EndIf
	Sleep(20)
	If $isPaused = True Then
		Do
			Sleep(500)
		Until $isPaused = False
	EndIf
	GUICtrlSetPos($floos, 0, GUICtrlRead($Input5) + 20)
	$Gravity = GUICtrlRead($Input4)
	$Floor = GUICtrlRead($Input5)
	$nMsg = GUIGetMsg()
	$Pos = ControlGetPos("Phactor - By Vindicator", "", $Entity)
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
	$Res = GUICtrlRead($Input7)
	$Pos = ControlGetPos("Phactor - By Vindicator", "", $Entity)
	If $LCollective <> 0 Then
		GUICtrlSetPos($Entity, $Pos[0] + $LCollective, $Pos[1], 20, 20)
	EndIf
	$Pos = ControlGetPos("Phactor - By Vindicator", "", $Entity)
	GUICtrlSetData($Input1, $LCollective)
	GUICtrlSetData($Input2, ($Pos[1] - $Floor) * - 1 & " ft")
	GUICtrlSetData($Input3, $Ent_Speed)
	If $Ent_Speed > 70 Then $Achievment[5] = True
	If $Side > 8 Then $Achievment[6] = True
	If $Walls = True Then
		If $Pos[0] < 5 Then
			$LCollective += $Res
			If $LCollective > 0 Then $LCollective = 0
			$LCollective *= -1
			SoundPlay("Bounce.wav")
			GUICtrlSetPos($Entity, 5, $Pos[1], 20, 20)
			$Side += 1
		EndIf
		If $Pos[0] > 525 Then
			$LCollective -= $Res
			If $LCollective < 0 Then $LCollective = 0
			$LCollective *= -1
			SoundPlay("Bounce.wav")
			GUICtrlSetPos($Entity, 525, $Pos[1], 20, 20)
			$Side += 1
		EndIf
		If $Pos[1] > $Floor Then
			$isFalling = False
			$Collective = Round($Collective * (2 / 3), 0)
			$Jumped = False
			SoundPlay("Bounce.wav")
			$Cont = 0
			$Side = 0
		EndIf
		If $Pos[1] < 5 Then
			$isFalling = True
			$Collective = Round($Collective * (2 / 3), 0)
			GUICtrlSetPos($Entity, $Pos[0], 8, 20, 20)
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
	Collector($CEntity, $Entity, "Phactor - By Vindicator")
	If $Collective = 0 Then
		$isFalling = True
	EndIf
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			ProcessClose("Background.exe")
			Exit

	EndSwitch
WEnd
Func reset()
	$mPos = MouseGetPos()
	$Pos = WinGetPos("Phactor - By Vindicator")
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
	$Pos = ControlGetPos("Phactor - By Vindicator", "", $Entity)
	$LCollective -= 1
	If $Pos[0] > 5 Then
		GUICtrlSetPos($Entity, $Pos[0] - 5, $Pos[1], 20, 20)
	EndIf
EndFunc   ;==>left
Func right()
	$Pos = ControlGetPos("Phactor - By Vindicator", "", $Entity)
	$LCollective += 1
	If $Pos[0] < 525 Then
		GUICtrlSetPos($Entity, $Pos[0] + 5, $Pos[1], 20, 20)
	EndIf
EndFunc   ;==>right
Func up()
	If $isFalling = True Then
		$Collective -= 2
	Else
		$Collective += 2
	EndIf
EndFunc   ;==>up
Func down()
	If $isFalling = True Then
		$Collective += 2
	Else
		$Collective -= 2
	EndIf
EndFunc   ;==>down
Func turbo()
	If $Jumped = False Then
		$isFalling = False
		$Collective += 15
		$Jumped = True
		SoundPlay("Jump.wav")
	EndIf
EndFunc   ;==>turbo
Func origin()
	$Collective = 0
	$LCollective = 0
	GUICtrlSetPos($Entity, 275, 30, 20, 20)
	SoundPlay("Origin.wav")
EndFunc   ;==>origin
Func fup()
	GUICtrlSetData($Input5, GUICtrlRead($Input5) - 10)
EndFunc   ;==>fup
Func fdown()
	GUICtrlSetData($Input5, GUICtrlRead($Input5) + 10)
EndFunc   ;==>fdown
Func tup()
	GUICtrlSetData($Input4, GUICtrlRead($Input4) + 1)
EndFunc   ;==>tup
Func tdown()
	If Not(GUICtrlRead($Input4) = 0) Then GUICtrlSetData($Input4, GUICtrlRead($Input4) - 1)
EndFunc   ;==>tdown
Func wup()
	GUICtrlSetData($Input7, GUICtrlRead($Input7) + 1)
EndFunc   ;==>wup
Func wdown()
	GUICtrlSetData($Input7, GUICtrlRead($Input7) - 1)
EndFunc   ;==>wdown
Func Rocket()
	SoundPlay("Rocket.wav", 1)
	$isFalling = False
	$Collective += 200
EndFunc   ;==>Rocket
Func Pause()
	If $isPaused = True Then
		$isPaused = False
	Else
		$isPaused = True
	EndIf
EndFunc   ;==>Pause
Func Collector($z_control, $z_first, $z_winname)
	$Pos = ControlGetPos($z_winname, "", $z_first) ; mouse position
	$Control = ControlGetPos($z_winname, "", $z_control); this is to find out window's button
	$win = WinGetPos($z_winname, "") ; you will need to add the window's coordinates to the checking
	If $Pos[0] + $win[0] + 15 > $Control[0] + $win[0] Then ;Check if the mouse is PAST the X position of the button
		If $Pos[0] + $win[0] + 15 < $Control[0] + $win[0] + $Control[2] Then ; Check now if its too far off ( after the button )
			If $Pos[1] + $win[1] + 15 > $Control[1] + $win[1] Then ; Check with the Y position
				If $Pos[1] + $win[1] + 15 < $Control[1] + $win[1] + $Control[3] Then ;once again, if its too far off
					$Cont += 1
					If $Cont = 2 Then $Achievment[0] = True
					If $Cont = 3 Then $Achievment[1] = True
					If $Cont = 4 Then $Achievment[2] = True
					If $Cont = 5 Then $Achievment[3] = True
					If $Cont = 10 Then $Achievment[4] = True
					GUICtrlSetImage($CEntity, "1UP.bmp")
					Sleep(50)
					GUICtrlDelete($CEntity)
					$LCollective *= -1
					$Collective = Round($Collective * (2 / 3), 1)
					If $isFalling = True Then
						$isFalling = False
					Else
						$isFalling = True
					EndIf
					SoundPlay("point.wav")
					;SoundPlay("Bounce.wav")
					If $Points < 10 Then
						$Ent = 38
					ElseIf $Points < 15 Then
						$Ent = 35
					ElseIf $Points < 20 Then
						$Ent = 32
					ElseIf $Points < 25 Then
						$Ent = 30
					ElseIf $Points < 30 Then
						$Ent = 28
					ElseIf $Points < 35 Then
						$Ent = 25
					ElseIf $Points < 40 Then
						$Ent = 22
					ElseIf $Points < 55 Then
						$Ent = 20
					ElseIf $Points < 75 Then
						$Ent = 18
						$Achievment[7] = True
					ElseIf $Points < 90 Then
						$Ent = 15
					ElseIf $Points < 115 Then
						$Ent = 12
					ElseIf $Points < 150 Then
						$Ent = 10
					Else
						$Ent = 10
					EndIf
					$CEntity = GUICtrlCreatePic("Entity2.bmp", Random(5, 450, 1), Random(5, 450, 1), $Ent, $Ent)
					GUICtrlSetState(-1, $GUI_SHOW)
					$Points += 1
					GUICtrlSetData($PtsCount, $Points)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Collector
Func esca()
	Exit
EndFunc   ;==>esca
Func points()
	$Points += 5
EndFunc   ;==>points
Func commandpanel()
	$Achievment[8] = True
	GUICtrlSetImage($Pic1,"PhysixWorld.bmp")
	GUICtrlSetState($Group2, $GUI_SHOW)
	GUICtrlSetState($Input4, $GUI_SHOW)
	GUICtrlSetState($Input5, $GUI_SHOW)
	GUICtrlSetState($Input6, $GUI_SHOW)
	GUICtrlSetState($Input7, $GUI_SHOW)
	GUICtrlSetState($Label4, $GUI_SHOW)
	GUICtrlSetState($Label5, $GUI_SHOW)
	GUICtrlSetState($Label6, $GUI_SHOW)
	GUICtrlSetState($Label7, $GUI_SHOW)
	HotKeySet("r", "fup")
	HotKeySet("f", "fdown")
	HotKeySet("t", "tup")
	HotKeySet("h", "wdown")
	HotKeySet("y", "wup")
	HotKeySet("g", "tdown")
	HotKeySet("e", "walls")
	HotKeySet("q", "origin")
	HotKeySet("{UP}", "Rocket")
	HotKeySet("{F1}", "reset")
	HotKeySet("v", "points")
EndFunc   ;==>commandpanel