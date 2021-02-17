;TRIG HELPER PROGRAM - SINE
;vars = x,y,z angX, angY,angZ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Vars
$x = InputBox ("Trig Helper - Sine","input value of side 'x' (opposite angle X)"&@CRLF&"If there is no value, input 'x'")
$y = InputBox ("Trig Helper - Sine","input value of side 'y' (opposite angle Y)"&@CRLF&"If there is no value, input 'x'")
$z = InputBox ("Trig Helper - Sine","input value of side 'z' (opposite angle Z)"&@CRLF&"If there is no value, input 'x'")
$angX = InputBox ("Trig Helper - Sine","input value of angle 'X' (opposite side x)"&@CRLF&"If there is no value, input 'x'")
$angY = InputBox ("Trig Helper - Sine","input value of angle 'Y' (opposite side y)"&@CRLF&"If there is no value, input 'x'")
$angZ = InputBox ("Trig Helper - Sine","input value of angle 'Z' (opposite side z)"&@CRLF&"If there is no value, input 'x'")
;Vars end

MsgBox (1,"Trig Helper - Sine","The following info is what was input"&@CRLF&"side x = "&$x&" / "&"Angle X = "&$angX&@CRLF&"side y = "&$y&" / "&"Angle Y = "&$angY&@CRLF&"side z = "&$z&" / "&"Angle Z = "&$angZ)

;COMPUTATION SECTION
$pi = 3.14159265358979
$degToRad = $pi / 180


if $x = "x" Then
$valx1 = (($y * Sin ($angX * $degToRad)/Sin($angY * $degToRad)))
$valx2 = (($z * Sin ($angX * $degToRad)/Sin($angZ * $degToRad)))
EndIf

if $y = "x" Then
$valy1 = (($x * Sin ($angY * $degToRad)/Sin($angX * $degToRad)))
$valy2 = (($z * Sin ($angY * $degToRad)/Sin($angZ * $degToRad)))
EndIf

if $z = "x" Then
$valz1 = (($x * Sin ($angZ * $degToRad)/Sin($angX * $degToRad)))
$valz2 = (($y * Sin ($angZ * $degToRad)/Sin($angY * $degToRad)))
EndIf
;COMPUTATION SECTION END

MsgBox (1,"Trig Helper - Sine","The following has been solved"&@CRLF&"If there are two values for any side/angle, then the non-zero value is the correct one"&@CRLF&"side x = "&$valx1&" / "&$valx2&" /~\ "&"Angle X = "&$angX&@CRLF&"side y = "&$valy1&" / "&$valy2&" /~\ "&"Angle Y = "&$angY&@CRLF&"side z = "&$valz1&" / "&$valz2&" /~\ "&"Angle Z = "&$angZ)

Exit