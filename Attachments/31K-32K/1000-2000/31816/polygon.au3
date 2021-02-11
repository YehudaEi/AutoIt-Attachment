#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Math.au3>

$radius = 100
$n = 8
$polygon_angle = ($n - 2) * 180 / $n
$start_angle = (180 - $polygon_angle) / 2
$center_angle = 180 - $polygon_angle
$side = Sqrt(2 * $radius ^ 2 * (1 - _Cos($center_angle)))
;~ MsgBox(0, "", $side)

$main = GUICreate("Test")

GUICtrlCreateGraphic(0, 0, 200, 200)
GUICtrlSetGraphic(-1, $GUI_GR_ELLIPSE, 0, 0, 2 * $radius, 2 * $radius)
GUICtrlSetGraphic(-1, $GUI_GR_MOVE, $radius, 2 * $radius)

For $i = 1 To $n
	GUICtrlSetGraphic(-1, $GUI_GR_LINE, $radius + _Cos($start_angle) * $side, 2 * $radius - _Sin($start_angle) * $side)
	$start_angle = $start_angle + 180 - $polygon_angle
Next


GUISetState()


While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
	EndSwitch
WEnd

Func _Cos($angle)
	$cos = Cos(_Radian($angle))
	If ($angle = 90 Or $angle = 270) Then $cos = 0
	Return $cos
EndFunc   ;==>_Cos

Func _Sin($angle)
	$sin = Sin(_Radian($angle))
	If ($angle = 180 Or $angle = 360) Then $sin = 0
	Return $sin
EndFunc   ;==>_Sin