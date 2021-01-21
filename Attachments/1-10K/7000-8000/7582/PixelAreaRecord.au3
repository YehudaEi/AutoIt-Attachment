Global $msg = "Move the mouse to a pixel" & @LF & _
		"that is unique as possible." & @LF & _
		"I will record the area around" & @LF & _
		"into PixelSearch.ini. Press" & @LF & _
		"` (Tilda key) to record."
Global $xy,$pixel

HotKeySet("`","record")

While 1
	$xy = MouseGetPos()
	$pixel = PixelGetColor($xy[0],$xy[1])
	ToolTip("Pixel color = " & $pixel & @LF & $msg)
	Sleep(100)
WEnd

Func record()
	IniWrite(".\PixelSearch.ini","Main","PixelColor",$pixel)
	Local $chksum = PixelChecksum($xy[0] - 5,$xy[1] - 5,$xy[0] + 5,$xy[1] + 5)
	IniWrite(".\PixelSearch.ini","Main","PixelCheckSum",$chksum)
	MsgBox(4096,"","Pixel Area Recorded." & @LF & @LF & "See INI file for details.")
	Exit
EndFunc

