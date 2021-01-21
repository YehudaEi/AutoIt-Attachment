#include <GUIConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 2)

Global Const $PI = 3.14159265358979

$gui = GUICreate("Light Beam", 500, 500)

$graphic = GUICtrlCreateGraphic(0, 0, 500, 500)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 250, 10)
GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x0000FF)
GUICtrlSetGraphic(-1, $GUI_GR_LINE, 50, 480)
GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)

$point_a = GUICtrlCreateLabel("", 250, 10, 12, 12)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetState(-1, $GUI_ONTOP)
GUICtrlSetOnEvent(-1, "_MovePoint")

$point_b = GUICtrlCreateLabel("", 50, 480, 12, 12)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetState(-1, $GUI_ONTOP)
GUICtrlSetOnEvent(-1, "_MovePoint")

$point_c = GUICtrlCreateLabel("", 0, 250, 12, 12)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetState(-1, $GUI_ONTOP)
GUICtrlSetOnEvent(-1, "_MovePoint")

$point_d = GUICtrlCreateLabel("", 488, 250, 12, 12)
GUICtrlSetBkColor(-1, 0)
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
   GUICtrlSetGraphic($graphic, $GUI_GR_MOVE, $sect[0] + $reflect[0], $sect[1] + $reflect[1])
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

;Converts degrees to radians
Func _Radian( $deg )
   Return $deg / 57.2957795130823
EndFunc

;Converts radians to degrees
Func _Degree( $rad )
   Return $rad * 57.2957795130823
EndFunc

;Reflects point ($x,$y) over line segment ($a,$b)($c,$d)
Func _Reflection( $x, $y, $a, $b, $c, $d )
   ;Two lines are perpendicular if their slopes are negative reciprocals of each other.
   Local $x_delta = 0 - ($d - $b), $y_delta = ($c - $a), $ret = _Intersect($a, $b, $c, $d, $x - $x_delta * 500, $y - $y_delta * 500, $x + $x_delta * 500, $y + $y_delta * 500)
   $ret[0] += Abs($ret[0] - $x)
   $ret[1] += Abs($ret[1] - $y)
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

;Find the angle at point 2 between line segment 1-2 and line segment 2-3
;returns radians
Func GetAnglePPP( $x1, $y1, $x2, $y2, $x3, $y3 )
   Local $A1 = GetAnglePP($x2, $y2, $x1, $y1), $A2 = GetAnglePP($x2, $y2, $x3, $y3)
   Return GetAngleAA($A1, $A2)
EndFunc

;Find the angle of a point relative to the first point
Func GetAnglePP( $x1, $y1, $x2, $y2 )
   Return GetAnglePO($x2 - $x1, $y2 - $y1)
EndFunc

;Find the difference between the two angles
Func GetAngleAA( $A1, $A2 )
   Local $A3 = $A2 - $A1
   While $A3 > $pi
	  $A3 -= 2 * $PI
   WEnd
   While $A3 < -$pi
	  $A3 += 2 * $PI
   WEnd
   Return $A3
EndFunc

;Find the angle of a point relative to the origin
Func GetAnglePO($x, $y)
   Select
	  Case $x > 0
		 If $y >= 0 Then
			Return ATan($y / $x)
		 Else
			Return ATan($y / $x) + 2 * $pi
		 EndIf
	  Case $x = 0
		 If $y = 0 Then
			Return 0
		 ElseIf $y > 0 Then
			Return $pi / 2
		 Else
			Return 3 * $pi / 2
		 EndIf
	  Case $x < 0
		 Return ATan($y / $x) + $pi
   EndSelect
EndFunc