#cs
	MasterMind, played with two numbers, each of them 4 digits, are to be compared and evaluated.
	A digit present, but not correctly placed score a 0,  placed correctly brings up an X and not present at all makes =
	Results showing like = = 0 X
#ce
;
const $titel=".               Forum MasterMind"
; Input fixed number 	fx translated for Dutch use  vg=vast getal
;
$vg = inputbox($titel, @tab & "fixed number of 4 digits" & @CRLF & @tab & "without spaces!")
$len = StringLen($vg)
If $len > 4 Then
	MsgBox(48, $titel, @tab & "Wrong input:    start over")
	exit
Endif
; splitting number into 4 separate variables
;
$a = StringMid($vg, 1, 1)
$b = StringMid($vg, 2, 1)
$c = StringMid($vg, 3, 1)
$d = StringMid($vg, 4, 1)
;
; Input guessed number   gn translated to	rg=raad getal
;
$rg = inputbox($titel, @tab & "4 digits of guessed number" & @CRLF & @tab & "without spaces!")
$len = StringLen($rg)
If $len > 4 Then
	MsgBox(48, $titel, @tab & "Wrong input:    start over")
	exit
Endif
$k = StringMid($rg, 1, 1)
$l = StringMid($rg, 2, 1)
$m = StringMid($rg, 3, 1)
$n = StringMid($rg, 4, 1)
;
; evaluation: comparing with no match, makes value for $s as set in start of section:  so     "= "
;
$s = "="
If $k = $a Then $s = "X"
if $k = $b Then $s = "0"
if $k = $c Then $s = "0"
if $k = $d Then $s = "0"
;
$t = "="
if $l = $a Then $t = "0"
if $l = $b Then $t = "X"
if $l = $c Then $t = "0"
if $l = $d Then $t = "0"
;
$u = "="
if $m = $a Then $u = "0"
if $m = $b Then $u = "0"
if $m = $c Then $u = "X"
if $m = $d Then $u = "0"
;
$v = "="
if $n = $a Then $v = "0"
if $n = $b Then $v = "0"
if $n = $c Then $v = "0"
if $n = $d Then $v = "X"
;
;
SoundPlay(@WindowsDir & "\media\notify.wav",0)
;
$antw = MsgBox(64, $titel, @CRLF & @tab & $a & @tab & $b & @tab & $c & @tab & $d & @CRLF & @tab & $k & @tab & $l & @tab & $m & @tab & $n & @CRLF & @CRLF & @tab & @tab & @CRLF & @tab & $s & @tab & $t & @tab & $u & @tab & $v)
;
; MsgBox(0, @mday & "--" & @mon, @hour & ":" & @min, 5)
exit