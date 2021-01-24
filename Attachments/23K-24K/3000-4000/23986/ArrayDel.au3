
; Script Start - Add your code below here

Sleep (3000) 

$a=0
Do
	send ("{home}{del 10}{down}")
	$a=$a+1
until $a=10 ;0-9
$a=0
Do
	send ("{home}{del 11}{down}")
	$a=$a+1
Until $a=90 ;10-99
$a=0
Do
	send ("{home}{del 12}{down}")
	$a=$a+1
Until $a=42 ;100- array value +1