; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>
;
; Script Function: Mouse move around
;
; ----------------------------------------------------------------------------

$maxX = 1024
$maxY = 768

HotKeySet("{end}", "end")

While 1
	MouseMove(Random(0, $maxX, 1), Random(0, $maxY, 1))
	sleep(500)
WEnd

Func end()
	exit(0)
EndFunc
