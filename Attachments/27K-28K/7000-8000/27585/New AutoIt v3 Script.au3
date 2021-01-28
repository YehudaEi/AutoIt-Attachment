#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         Not my script

 Script Function:
	Types some random numbers

#ce ----------------------------------------------------------------------------



Run ("Notepad.exe")

WinWaitActive ("Untitled - Notepad")

Global $sRandom
; How many numbers it types.
For $i = 1 to 2
$sRandom &= Random(0,9,1)
next
Send($sRandom)