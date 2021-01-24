#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

sleep(3000)

$a=0
Do
	send("{home}$Array[")
	send($a)
	send("]={down}")
	$a=$a+1
Until  $a=140  