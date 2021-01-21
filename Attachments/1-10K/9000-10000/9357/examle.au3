; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below h
func goo()
	while 1
MouseClickDrag("right", 443,350,524,300,)
send ( "  " )
MouseClickDrag("right", 450,300,524,300,)
MouseClickDrag("right", 443,200,524,300,)
send ( "  " )
MouseClickDrag("right", 516,324,524,300,)
send ( "  " )
WEnd
EndFunc()
func exx()
	sleep(1000)
	While 1
	WEnd
	EndFunc
HotKeySet( "f", "goo" )
HotKeySet( "p", "exx" )
while 1
	WEnd