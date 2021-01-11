#include <guiconstants.au3>
#include "A2D.au3"
HotKeySet("{Esc}", "Close")
;Rainbow Test
GUICreate("test", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP)
GUISetBkColor(0x000000)
$surface = _A2DCreateSurface(0, 0, @DesktopWidth, @DesktopHeight, $C_BLACK)
GUISetState()
Global $x = @DesktopWidth/2, $y = @DesktopHeight/2
Local $diff = 0
Global $avShapes[5] = ["Rect", "Circle", "Tri", "Pix", "Line"]
$text = _A2DDrawText(@Hour & ":" & @Min &":" & @SEC, 0, @DesktopHeight-50, 300, 100, $c_yellow)
	GUICtrlSetFont($text, 32, -1, -1, "Comic Sans MS")
While 1
	$color = _A2DMakeGradient(random(0x0, 0xFFFFFF), $C_BLACK, 310)
	if _IsPressed($KEY_ESC) Then
		Exit
	Else
	EndIf
	$shape = $avShapes[random(0, 4, 1)]
	For $i = 100 to 300
	$diff += 1
	$x += (Sin($i)*3.14)*$diff/2
	$y += (Cos($i)*3.14)*$diff/2
	GUICtrlSetCOlor($text, $color[0])
Select
	Case $shape = "Rect"
		_A2DDrawRectangle($surface, $x, $y, 10, 10, 1, $color[$i])
	Case $shape = "Circle"
		_A2DDrawCircle($surface, $x, $y, 10, 10, 1, $color[$i])
	Case $shape = "Pix"
		_A2DDrawPixel($surface, $x, $y, $color[$i])
	Case $shape = "Line"
		_A2DDrawLine($surface, $x, $y, $x+5, $y+5, 2, $color[$i])
	Case Else
		_A2DDrawCircle($surface, $x, $y, 10, 10, 1, $color[$i])
EndSelect
$hour = @Hour
if @Hour >= 13 Then
	$Hour = ($hour-12)
EndIf
if $Hour == "00" Then
	$Hour = 12
EndIf

GUICtrlSetData($text, $Hour & ":" & @Min & ":" & @Sec)
	sleep(100)
	_A2DUpdate($surface)
Next
_A2DClearSurface($surface, $surface)
$diff = 0
$x = @DesktopWidth/2
$y = @DesktopHeight/2
WEnd

Func Close()
	Exit
EndFunc