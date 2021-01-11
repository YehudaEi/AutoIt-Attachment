#include <GUIConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 2)

$gui = GUICreate("Light Beam", 500, 500)

$graphic = GUICtrlCreateGraphic(0, 0, 500, 500)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 250, 10)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x0000FF)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 50, 480)
GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)

$point_a = GUICtrlCreateLabel("", 250, 10, 12, 12)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlSetState(-1, $GUI_ONTOP)
GUICtrlSetOnEvent(-1, "_MovePoint")

$point_b = GUICtrlCreateLabel("", 50, 480, 12, 12)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlSetState(-1, $GUI_ONTOP)
GUICtrlSetOnEvent(-1, "_MovePoint")

$point_c = GUICtrlCreateLabel("", 0, 250, 12, 12)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetState(-1, $GUI_ONTOP)
GUICtrlSetOnEvent(-1, "_MovePoint")

$point_d = GUICtrlCreateLabel("", 488, 250, 12, 12)
GUICtrlSetBkColor(-1, 0xFF0000)
GUICtrlSetState(-1, $GUI_ONTOP)
GUICtrlSetOnEvent(-1, "_MovePoint")

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit", $gui)

GUISetState()

_TraceBeam()

While 1
   Sleep(10)
WEnd

Func _TraceBeam()
   ; ... find the point where the lines intersect ...
   Local $a = ControlGetPos($gui, "", $point_a), $b = ControlGetPos($gui, "", $point_b), $c = ControlGetPos($gui, "", $point_c), $d = ControlGetPos($gui, "", $point_d)
   Local $sect = _Intersect($a[0], 0 - $a[1], $b[0], 0 - $b[1], $c[0], 0 - $c[1], $d[0], 0 - $d[1])
   If @error or not IsArray($sect) Then
	  GUICtrlSetGraphic($graphic, $GUI_GR_MOVE, $c[0], $c[1])
	  GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, 0xFF0000)
	  GUICtrlSetGraphic($graphic, $GUI_GR_LINE, $d[0], $d[1])
	  GUICtrlSetGraphic($graphic, $GUI_GR_REFRESH)
	  Return
   EndIf
   $sect[1] *= -1
   ; ... draw line to intersection ...
   GUICtrlSetGraphic($graphic, $GUI_GR_MOVE, $sect[0], $sect[1])
   GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, 0xFF0000)
   GUICtrlSetGraphic($graphic, $GUI_GR_LINE, $d[0], $d[1])
   GUICtrlSetGraphic($graphic, $GUI_GR_REFRESH)
   ; ... reflect the beam endpoint across the mirror line ...
   Local $reflect = _Reflection($c[0], $c[1], $a[0], $a[1], $b[0], $b[1])
   ; ... trace the beam ...
   GUICtrlSetGraphic($graphic, $GUI_GR_MOVE, $reflect[0], $reflect[1])
   GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, 0xFF0000)
   GUICtrlSetGraphic($graphic, $GUI_GR_LINE, $sect[0], $sect[1])
   GUICtrlSetGraphic($graphic, $GUI_GR_REFRESH)
EndFunc

Func _MovePoint()
   Local $user32 = DllOpen("user32.dll"), $aR = DllCall('user32.dll', 'int', 'GetAsyncKeyState', 'int', 1), $pos[2], $tmp[2], $a, $b
   Switch @GUI_CtrlId
	  Case $point_a
		 While $aR[0] <> 0
			Sleep(10)
			$aR = DllCall($user32, 'int', 'GetAsyncKeyState', 'int', 1)
			$pos = MouseGetPos()
			$tmp = ControlGetPos($gui, "", $point_a)
			If $pos[0] = $tmp[0] and $pos[1] = $tmp[1] Then ContinueLoop
			GUICtrlSetPos($point_a, $pos[0], $pos[1])
			$tmp = ControlGetPos($gui, "", $point_b)
			GUICtrlDelete($graphic)
			$graphic = GUICtrlCreateGraphic(0, 0, 500, 500)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $tmp[0], $tmp[1])
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x0000FF)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $pos[0], $pos[1])
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			_TraceBeam()
		 WEnd
	  Case $point_b
		 While $aR[0] <> 0
			Sleep(10)
			$aR = DllCall($user32, 'int', 'GetAsyncKeyState', 'int', 1)
			$pos = MouseGetPos()
			$tmp = ControlGetPos($gui, "", $point_b)
			If $pos[0] = $tmp[0] and $pos[1] = $tmp[1] Then ContinueLoop
			GUICtrlSetPos($point_b, $pos[0], $pos[1])
			$tmp = ControlGetPos($gui, "", $point_a)
			GUICtrlDelete($graphic)
			$graphic = GUICtrlCreateGraphic(0, 0, 500, 500)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $tmp[0], $tmp[1])
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x0000FF)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $pos[0], $pos[1])
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			_TraceBeam()
		 WEnd
	  Case $point_c
		 While $aR[0] <> 0
			Sleep(10)
			$aR = DllCall($user32, 'int', 'GetAsyncKeyState', 'int', 1)
			$pos = MouseGetPos()
			$tmp = ControlGetPos($gui, "", $point_c)
			If $pos[0] = $tmp[0] and $pos[1] = $tmp[1] Then ContinueLoop
			GUICtrlSetPos($point_c, $pos[0], $pos[1])
			$tmp = ControlGetPos($gui, "", $point_d)
			$a = ControlGetPos($gui, "", $point_a)
			$b = ControlGetPos($gui, "", $point_b)
			GUICtrlDelete($graphic)
			$graphic = GUICtrlCreateGraphic(0, 0, 500, 500)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $a[0], $a[1])
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x0000FF)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $b[0], $b[1])
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			_TraceBeam()
		 WEnd
	  Case $point_d
		 While $aR[0] <> 0
			Sleep(10)
			$aR = DllCall($user32, 'int', 'GetAsyncKeyState', 'int', 1)
			$pos = MouseGetPos()
			$tmp = ControlGetPos($gui, "", $point_d)
			If $pos[0] = $tmp[0] and $pos[1] = $tmp[1] Then ContinueLoop
			GUICtrlSetPos($point_d, $pos[0], $pos[1])
			$tmp = ControlGetPos($gui, "", $point_c)
			$a = ControlGetPos($gui, "", $point_a)
			$b = ControlGetPos($gui, "", $point_b)
			GUICtrlDelete($graphic)
			$graphic = GUICtrlCreateGraphic(0, 0, 500, 500)
			GUICtrlSetBkColor(-1, 0xFFFFFF)
			GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $a[0], $a[1])
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x0000FF)
			GUICtrlSetGraphic(-1, $GUI_GR_LINE, $b[0], $b[1])
			GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
			_TraceBeam()
		 WEnd
   EndSwitch
   DllClose($user32)
EndFunc

Func _Exit()
   Exit
EndFunc

;Reflects point (u,v) over line segment (a,b)(c,d)
Func _Reflection( $u, $v, $a, $b, $c, $d )
   Local $m1 = ($b - $d) / ($a - $c), $m2 = ($c - $a) / ($b - $d)
   Local $k1 = $b - $a * $m1, $k2 = $v - $u * $m2
   Local $x = ($k2 - $k1) / ($m1 - $m2), $d0 = $x - $u, $ret[2]
   $ret[0] = ($u + 2 * $d0)
   $ret[1] = ($m2 * $ret[0] + $k2)
   Return $ret
EndFunc

;Find the point of intersection between two line segments (x0,y0)(x1,y1) and (x2,y2)(x3,y3)
Func _Intersect( $x0, $y0, $x1, $y1, $x2, $y2, $x3, $y3 )
   Local $d = ( $x1 - $x0 ) * ( $y3 - $y2 ) - ( $y1 - $y0 ) * ( $x3 - $x2 )
   If Abs($d) < 0.001 Then Return SetError(1, 0, 0)
   Local $ab = (( $y0 - $y2 ) * ( $x3 - $x2 ) - ( $x0 - $x2 ) * ( $y3 - $y2 )) / $d
   If $ab > 0 and $ab < 1 Then
	  Local $cd = (( $y0 - $y2 ) * ( $x1 - $x0 ) - ( $x0 - $x2 ) * ( $y1 - $y0 )) / $d
	  If $cd > 0 and $cd < 1 Then
		 Local $pos[2] = [ $x0 + $ab * ( $x1 - $x0 ), $y0 + $ab * ( $y1 - $y0 ) ]
		 Return $pos
	  EndIf
   EndIf
   Return SetError(2, 0, 0)
EndFunc