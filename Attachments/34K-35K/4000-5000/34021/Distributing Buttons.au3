#comments-start
Script's data:
	Name:		Distributing buttons
	Date:		18 may 2.011
Script's author
	Name:		Detefon
	e-mail:		herbivoro@ig.com.br

Inspired in the Fourier Series (wave saw tooth)
If you want a way to distribute many buttons in the window's AutoIt, that simple algorithm will be calculate the 'x' and 'y' position's button.
(0,0)(0,1)(0,2)(0,3)(0,4)(0,5)(0,6)(0,7)
(1,0)(1,1)(1,2)(1,3)(1,4)(1,5)(1,6)(1,7)
(2,0)(2,1)(2,2)(2,3)(2,4)(2,5)(2,6)(2,7)
(3,0)(3,1)(3,2)
#comments-end

;This script have 27 buttons
;Each line have only 8 buttons

$Step = 8
for $a = 0 to 26
	$x = int($a / $Step)
	$y =  $a - $x * $Step
	
	ConsoleWrite("(" & $x & "," & $y & ")")
	Next