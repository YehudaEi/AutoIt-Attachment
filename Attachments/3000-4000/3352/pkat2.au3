Dim $xuh = 1130, $yuh = 400
Dim $xplayer = 550, $yplayer = 435
Dim $Activation
Dim $Activation1
Dim $Activation2
Dim $aim
Dim $hitpointcoord
Dim $color_hitpoint
Dim $rune

HotkeySet ("{NUMPAD1}", "activate")
HotkeySet ("{NUMPAD2}", "activate1")
HotkeySet ("{NUMPAD3}", "activate2")
HotkeySet ("{NUMPAD5}", "use_uh")
HotkeySet ("{NUMPAD6}", "setminhp")
HotkeySet ("{NUMPAD4}", "Setrune")
HotkeySet ("{NUMPAD0}", "shoot")
HotkeySet ("{PGDN}", "use_uh")
HotkeySet ("{END}", "shoot")
HotkeySet ("{F5}", "Terminate")

MsgBox ( 32, "Configuration", "Move cursor to where the hitpoint indicator should be")
Sleep (5000)
$hitpointcoord = MouseGetPos ()
$color_hitpoint = PixelGetColor ($hitpointcoord[0], $hitpointcoord[1])
MsgBox ( 32, "Configuration", "Done")

Func setminhp ()
$hitpointcoord = MouseGetPos ()
$color_hitpoint = PixelGetColor ($hitpointcoord[0], $hitpointcoord[1])
EndFunc
While $Activation = 0
	Sleep (1000)

While $Activation = 1

	If $Activation1 < 3 And PixelGetColor ($hitpointcoord[0], $hitpointcoord[1]) <> $color_hitpoint Then
	BlockInput (1)
	$aim = MouseGetPos ()
	MouseClick ("Right", $xuh, $yuh, 1, 0)
	Sleep (10)
	MouseClick ("Left", $xplayer, $yplayer, 1 ,0)
	Sleep (10)
	MouseMove ($aim[0], $aim[1], 0)
	BlockInput (0)
	Else
EndIf

Wend
Wend
Func use_uh ()
	BlockInput (1)
	$aim = MouseGetPos ()	
	MouseClick ("Right", $xuh, $yuh, 1, 0)
	Sleep (10)
	MouseClick ("Left", $xplayer, $yplayer, 1 ,0)
	Sleep (10)
	MouseMove ($aim[0], $aim[1], 0)
	BlockInput (0)
EndFunc

Func Terminate()
    Exit 0
EndFunc

Func Setrune ()
	$rune = MouseGetPos()
EndFunc

Func activate ()
	$Activation = $Activation + 1
	If $Activation > 1 Then
	$Activation = 0
	$Activation1 = 0
	$Activation2 = 0
	Else

	EndIf
EndFunc
	

Func shoot ()
	BlockInput (1)
	$aim = MouseGetPos ()
	Sleep (10)
	MouseMove ($rune[0], $rune[1], 0)
	MouseDown ("right")
	MouseUp ("right")
	Sleep (10)
	MouseMove ($aim[0], $aim[1], 0)
	Sleep (10)
	MouseDown ("left")
	MouseUp ("Left")
	BlockInput (0)
EndFunc


Func activate1 ()
	$Activation1 = $Activation1 + 1
	If $Activation1 > 3 Then $Activation1 = 0
EndFunc

Func activate2 ()
	$Activation2 = $Activation2 + 1
	If $Activation2 > 3 Then $Activation2 = 0
EndFunc