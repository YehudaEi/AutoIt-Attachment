#include<Math.au3>
$x = 0.5
$y = 0.5
$pi = 3.14159265358979
$o = $x/$y 
If $x >= 0.0 And $x <= 1.0 And $y >= 0.0 And $y <= 1.0 Then ; 0 to 90
	$r = ATan($o) * 180 / $pi 
ElseIf $x >= 0.0 And $x <= 1.0 And $y >= -1.0 And $y <= -0.0 Then ; 90 to 180
	$r = ATan($o) * 180 / $pi + 180
ElseIf $x >= -1.0 And $x <= -0.0 And $y >= -1.0 And $y <= -0.0 Then ; 180 to 270
	$r = ATan($o) * 180 / $pi + 180
ElseIf $x >= -1.0 And $x <= -0.0 And $y >= 0.0 And $y <= 1.0 Then ; 270 to 360
	$r = ATan($o) * 180 / $pi + 360
EndIf
MsgBox(0, "Test", $r)

