; includes / options
#include <GUIConstants.au3>
#include <Constants.au3>
Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Opt("MouseCoordMode", 0)
Global Const $e  = 2.71828182845905
Global Const $pi = 3.14159265358979

;declare Variables
Global $red = "0xff0000"
Global $green = "0x006633"
Global $blue = "0x0000ff"
Global $desktopx = 600
Global $desktopy = 600
Global $labelx[201]
Global $labely[201]
Global $draw_gui
Global $graphic

;create GUI and GUICtrl's
$gui = GUICreate("tmo's Plotting Tool", 600, 210)

$menu = GUICtrlCreateMenu("File")
$subclose = GUICtrlCreateMenuitem("Exit", $menu)
$menu2 = GUICtrlCreateMenu("Help")
$subcredits = GUICtrlCreateMenuitem("Credits", $menu2)

$check_f   = GUICtrlCreateCheckbox("", 10, 12)
$label_f   = GUICtrlCreateLabel("f(x) = ", 30, 12, 30, 20)
$input_f   = GUICtrlCreateInput("", 60, 10, 150, 20)
$preview_f = GUICtrlCreateLabel("", 220, 10, 20, 20)
GUICtrlSetBkColor($preview_f, $blue)
$color_f   = GUICtrlCreateCombo("Blue", 250, 10, 60, 20)
GUICtrlSetData($color_f, "Green|Red")
$label_fq = GUICtrlCreateLabel("q: from/to/step", 320, 12, 80, 20)
$from_fq = GUICtrlCreateInput("", 400, 10, 40, 20)
$to_fq = GUICtrlCreateInput("", 450, 10, 40, 20)
$step_fq = GUICtrlCreateInput("", 500, 10, 40, 20)

$check_g   = GUICtrlCreateCheckbox("", 10, 40)
$label_g   = GUICtrlCreateLabel("g(x) = ", 30, 42, 30, 20)
$input_g   = GUICtrlCreateInput("", 60, 40, 150, 20)
$preview_g = GUICtrlCreateLabel("", 220, 40, 20, 20)
GUICtrlSetBkColor($preview_g, $red)
$color_g   = GUICtrlCreateCombo("Red", 250, 40, 60, 20)
GUICtrlSetData($color_g, "Blue|Green")
$label_gq = GUICtrlCreateLabel("q: from/to/step", 320, 42, 80, 20)
$from_gq = GUICtrlCreateInput("", 400, 40, 40, 20)
$to_gq = GUICtrlCreateInput("", 450, 40, 40, 20)
$step_gq = GUICtrlCreateInput("", 500, 40, 40, 20)

$check_h   = GUICtrlCreateCheckbox("", 10, 68)
$label_h   = GUICtrlCreateLabel("h(x) = ", 30, 72, 30, 20)
$input_h   = GUICtrlCreateInput("", 60, 70, 150, 20)
$preview_h = GUICtrlCreateLabel("", 220, 70, 20, 20)
GUICtrlSetBkColor($preview_h, $green)
$color_h   = GUICtrlCreateCombo("Green", 250, 70, 60, 20)
GUICtrlSetData($color_h, "Red|Blue")
$label_hq = GUICtrlCreateLabel("q: from/to/step", 320, 72, 80, 20)
$from_hq = GUICtrlCreateInput("", 400, 70, 40, 20)
$to_hq = GUICtrlCreateInput("", 450, 70, 40, 20)
$step_hq = GUICtrlCreateInput("", 500, 70, 40, 20)

$check_fandg = GUICtrlCreateCheckbox("f + g", 10, 100, 40, 20)
$check_fminusg = GUICtrlCreateCheckbox("f - g", 10, 120, 40, 20)
$check_fmalg = GUICtrlCreateCheckbox("f * g", 10, 140, 40, 20)
$check_fdurchg = GUICtrlCreateCheckbox("f / g", 10, 160, 40, 20)
$check_fchaing = GUICtrlCreateCheckbox("f ° g", 60, 100, 40, 20)

$button = GUICtrlCreateButton("Draw!", 250, 150, 100, 30)

; set events
GUICtrlSetOnEvent($subcredits, "_credits")
GUICtrlSetOnEvent($subclose, "_exit")
GUICtrlSetOnEvent($button, "_start")
GUICtrlSetOnEvent($color_f, "_colorF")
GUICtrlSetOnEvent($color_g, "_colorG")
GUICtrlSetOnEvent($color_h, "_colorH")
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")

;show GUI
GUISetState()

While 1
    Sleep(1000)
WEnd

Func _colorF()
	$newcolor = GUICtrlRead($color_f)
	If $newcolor = "Blue" Then 
		GUICtrlSetBkColor($preview_f, $blue)
	ElseIf $newcolor = "Red" Then 
		GUICtrlSetBkColor($preview_f, $red)
    Else 
		GUICtrlSetBkColor($preview_f, $green)
	EndIf
EndFunc
	
Func _colorG()
	$newcolor = GUICtrlRead($color_g)
	If $newcolor = "Blue" Then 
		GUICtrlSetBkColor($preview_g, $blue)
	ElseIf $newcolor = "Red" Then 
		GUICtrlSetBkColor($preview_g, $red)
    Else 
		GUICtrlSetBkColor($preview_g, $green)
	EndIf
EndFunc
	
Func _colorH()
	$newcolor = GUICtrlRead($color_h)
	If $newcolor = "Blue" Then 
		GUICtrlSetBkColor($preview_h, $blue)
	ElseIf $newcolor = "Red" Then 
		GUICtrlSetBkColor($preview_h, $red)
    Else 
		GUICtrlSetBkColor($preview_h, $green)
	EndIf
EndFunc

;start drawing
Func _start()
	HotKeySet("{ESC}", "_closeDraw")
	$draw_gui = GUICreate("Press ESC to close", $desktopx, $desktopy)
	GUISetOnEvent($GUI_EVENT_MOUSEMOVE, "_showXY", $draw_gui)
	HotKeySet("{LEFT}", "_left")
	HotKeySet("{RIGHT}", "_right")
	HotKeySet("{UP}", "_up")
	HotKeySet("{DOWN}", "_down")
	GUISetBkColor("0xffffff")
	GUISetCursor(3,1)
	For $i = -100 To 100
		$labelx[$i+100] = GUICtrlCreateLabel($i, -3 + ($i+10) * $desktopx / 20, $desktopy-15, 15, 15)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	Next
	For $i = -100 To 100
		$labely[$i+100] = GUICtrlCreateLabel($i, 0, $desktopy - 5 - (($i+10)*$desktopy/20), 15, 15)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	Next
	$graphic = GUICtrlCreateGraphic(-5*$desktopx + $desktopx/2, -5*$desktopy + $desktopy/2, $desktopx*10, $desktopy*10)
	For $i = -100 To 100
		If $i = 0 Then
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, "0x000000")
		Else
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, "0x999999")
		EndIf
		GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $i * $desktopx / 20 + $desktopx *10/ 2, 0)
		GUICtrlSetGraphic(-1, $GUI_GR_LINE, $i * $desktopx / 20 + $desktopx *10/ 2, $desktopy*10)
	Next
	For $i = -100 To 100
		If $i = 0 Then
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, "0x000000")
		Else
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, "0x999999")
		EndIf
		GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 0, $i * $desktopy / 20 + $desktopy *10/ 2)
		GUICtrlSetGraphic(-1, $GUI_GR_LINE, $desktopx*10, $i * $desktopy / 20 + $desktopy *10/ 2)
	Next
	GUISetState()
	;draw f(x)
	If GUICtrlRead($check_f) = $GUI_CHECKED Then
		If StringinStr(GUICtrlRead($input_f), "q") <> 0 Then
			$from = Number(GUICtrlRead($from_fq))
			$to = Number(GUICtrlRead($to_fq))
			$step = Number(GUICtrlRead($step_fq))
			For $i = $from To $to Step $step
				$a = String($i)
				$schar = StringReplace(GUICtrlRead($input_f), "q", $a)
				_drawGraph($schar, GUICtrlRead($color_f), $desktopx, $desktopy)
			Next
		Else
		    _drawGraph(GUICtrlRead($input_f), GUICtrlRead($color_f), $desktopx, $desktopy)
		EndIf
	EndIf
	;draw g(x)
	If GUICtrlRead($check_g) = $GUI_CHECKED Then
		If StringinStr(GUICtrlRead($input_g), "q") <> 0 Then
			$from = Number(GUICtrlRead($from_gq))
			$to = Number(GUICtrlRead($to_gq))
			$step = Number(GUICtrlRead($step_gq))
			For $i = $from To $to Step $step
				$a = String($i)
				$schar = StringReplace(GUICtrlRead($input_g), "q", $a)
				_drawGraph($schar, GUICtrlRead($color_g), $desktopx, $desktopy)
			Next
		Else
		    _drawGraph(GUICtrlRead($input_g), GUICtrlRead($color_g), $desktopx, $desktopy)
		EndIf
	EndIf
	;draw h(x)
	If GUICtrlRead($check_h) = $GUI_CHECKED Then
		If StringinStr(GUICtrlRead($input_h), "q") <> 0 Then
			$from = Number(GUICtrlRead($from_hq))
			$to = Number(GUICtrlRead($to_hq))
			$step = Number(GUICtrlRead($step_hq))
			For $i = $from To $to Step $step
				$a = String($i)
				$schar = StringReplace(GUICtrlRead($input_h), "q", $a)
				_drawGraph($schar, GUICtrlRead($color_h), $desktopx, $desktopy)
			Next
		Else
		    _drawGraph(GUICtrlRead($input_h), GUICtrlRead($color_h), $desktopx, $desktopy)
		EndIf
	EndIf
	
	;draw Links
	If GUICtrlRead($check_fandg) = $GUI_CHECKED Then 
		_drawGraph(_linkFunction(GUICtrlRead($input_f), GUICtrlRead($input_g), "+"), GUICtrlRead($color_h), $desktopx, $desktopy)
	EndIf
	If GUICtrlRead($check_fminusg) = $GUI_CHECKED Then 
		_drawGraph(_linkFunction(GUICtrlRead($input_f), GUICtrlRead($input_g), "-"), GUICtrlRead($color_h), $desktopx, $desktopy)
	EndIf
	If GUICtrlRead($check_fmalg) = $GUI_CHECKED Then 
		_drawGraph(_linkFunction(GUICtrlRead($input_f), GUICtrlRead($input_g), "*"), GUICtrlRead($color_h), $desktopx, $desktopy)
	EndIf
	If GUICtrlRead($check_fdurchg) = $GUI_CHECKED Then 
		_drawGraph(_linkFunction(GUICtrlRead($input_f), GUICtrlRead($input_g), "/"), GUICtrlRead($color_h), $desktopx, $desktopy)
	EndIf
	If GUICtrlRead($check_fchaing) = $GUI_CHECKED Then 
		_drawGraph(_chainFunction(GUICtrlRead($input_f), GUICtrlRead($input_g)), GUICtrlRead($color_h), $desktopx, $desktopy)
	EndIf
EndFunc

Func _drawGraph($sTerm, $cColor, $width, $height)
	Local $bool = false
	$newcolor = $cColor
	If $newcolor = "Blue" Then 
		$color = $blue
	ElseIf $newcolor = "Red" Then 
		$color = $red
	Else 
		$color = $green
	EndIf
	GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $color)
	$eval = StringReplace($sTerm, "x", "$x")
	$eval = StringReplace($eval, "e", $e)
	$eval = StringReplace($eval, "pi", $pi)
	$i = 0
	$pixelx = $i
	$x = ($i - $width*10/2) / ($width/20)
	$y = Execute($eval)
	$pixely = -1*$y*($height/20) + $height*10/2
	$move = true
	For $i = 1 To 6000
		If int($y) <> int(1/0) AND int($y) <> int(-1/0) AND int($y) <> int(0/0) AND _check($pixelx, $pixely, $x, $y) Then 
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $pixelx, $pixely)
		Else
			$bool = true
		EndIf
		$pixelx = $i
		$x = ($i - $width*10/2) / ($width/20)
		$y = Execute($eval)
		$pixely = -1*$y*($height/20) + $height*10/2
		If $x > 2 And $x < 3 Then ConsoleWrite($pixelx & "," & $pixely & @CRLF)
		If $bool Then
			If _check($pixelx, $pixely, $x, $y) Then GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $pixelx, $pixely)
			$bool = False
		EndIf
		If int($y) <> int(1/0) AND int($y) <> int(-1/0) AND int($y) <> int(0/0) Then 
			If _check($pixelx, $pixely, $x, $y) Then GUICtrlSetGraphic(-1, $GUI_GR_LINE, $pixelx, $pixely)
		EndIf
	Next
	GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
EndFunc

Func _linkFunction($f, $g, $type)
	Return "(" & $f & ")" & $type & "(" & $g & ")"
Endfunc

Func _chainFunction($f, $g)
	Return StringReplace($f, "x", "(" & $g & ")")
EndFunc

Func _getXY($x, $y, $width, $height, $posx, $posy)
	Local $coords[2]
	$coords[0] = ($x - $width/2) / ($width/20) - ($posx + 5*$width - $width/2) / ($width/20)
	$coords[1] = 1 - ($y - $height/2) / ($height/20) + ($posy + 5*$height - $height/2) / ($height/20)
	Return $coords
EndFunc

Func _showXY()
	$mouse = MouseGetPos()
	Local $cpos = ControlGetPos($draw_gui, "", $graphic)
	$array = _getXY($mouse[0], $mouse[1], $desktopx, $desktopy, $cpos[0], $cpos[1])
    toolTip ("Current Cursur Position:" & @CRLF & "x = " & StringFormat("%.3f", round($array[0]-0.1, 3)) & @CRLF & "y = " & StringFormat("%.3f", round($array[1]-0.033, 3)), 20, 20, "tmo's Plotting Tool", 1); 	
EndFunc

Func _left()
	Local $lpos
	Local $cpos = ControlGetPos($draw_gui, "", $graphic)
	GUICtrlSetPos($graphic, $cpos[0] + 30, $cpos[1])
	For $i = 0 to 200
		$lpos = ControlGetPos($draw_gui, "", $labelx[$i])
		GUICtrlSetPos($labelx[$i], $lpos[0] + 30, $lpos[1])
	Next
	_showXY()
EndFunc

Func _right()
	$cpos = ControlGetPos($draw_gui, "", $graphic)
	GUICtrlSetPos($graphic, $cpos[0] - 30, $cpos[1])
	For $i = 0 to 200
		$lpos = ControlGetPos($draw_gui, "", $labelx[$i])
		GUICtrlSetPos($labelx[$i], $lpos[0] - 30, $lpos[1])
	Next
	_showXY()
EndFunc

Func _up()
	$cpos = ControlGetPos($draw_gui, "", $graphic)
	GUICtrlSetPos($graphic, $cpos[0], $cpos[1] + 30)
	For $i = 0 to 200
		$lpos = ControlGetPos($draw_gui, "", $labely[$i])
		GUICtrlSetPos($labely[$i], $lpos[0], $lpos[1] + 30)
	Next
	_showXY()
EndFunc

Func _down()
	$cpos = ControlGetPos($draw_gui, "", $graphic)
	GUICtrlSetPos($graphic, $cpos[0], $cpos[1] - 30)
	For $i = 0 to 200
		$lpos = ControlGetPos($draw_gui, "", $labely[$i])
		GUICtrlSetPos($labely[$i], $lpos[0], $lpos[1] - 30)
	Next
	_showXY()
EndFunc

Func _check($px, $py, $ry, $rx)
	Return $px <= 6000 AND $py <= 6000 AND $px >= 0 AND $py >= 0 AND $ry >= -100 AND $ry <= 100 AND $rx >= -100 AND $rx <= 100
EndFunc

;exit the script
Func _exit()
    Exit
EndFunc

Func _closeDraw()
	ToolTip("", -100, -100)
	HotKeySet("{ESC}")
	HotKeySet("{LEFT}")
	HotKeySet("{RIGHT}")
	HotKeySet("{UP}")
	HotKeySet("{DOWN}")
	GUISetOnEvent($GUI_EVENT_MOUSEMOVE, "")
	GUIDelete()
EndFunc

;credits
Func _credits()
    $msgreturn = MsgBox(68, "Credits", "Written by: tmo" & @CRLF & "Questions/Feedback at http://www.autoitscript.com/forum/index.php?showforum=9", 10)
    If $msgreturn = 6 OR $msgreturn = -1 Then
         _visit("http://www.autoitscript.com/forum/index.php?showforum=9")
    EndIf
EndFunc

;visit URL
Func _visit($url)
    RunWait("rundll32.exe url.dll,FileProtocolHandler " & $url, @WorkingDir)
EndFunc