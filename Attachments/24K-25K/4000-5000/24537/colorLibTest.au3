#include <ColorLib.au3>

_Main()

Func _Main()
	Local $colorApplet[3]
	
	$colorApplet[0] = "0xFFFFFF"
	$colorApplet[1] = "0x000000"
	$colorApplet[2] = "0xFFFFF9"
	MsgBox(64, "ColorLib Test", String(_GetCorrectColor("0xFFFFF9", $colorApplet)))
EndFunc ;==>_Main