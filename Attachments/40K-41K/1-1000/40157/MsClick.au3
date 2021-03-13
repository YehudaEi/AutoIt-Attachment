Opt("MouseCoordMode", 2)


Sleep(2000)
MsClick("Window tittle","","","left",1,398, 349) ;Set window tittle for controlclick
Sleep(2000)
MsClick("Window tittle","","","left",1,398, 349) ;            >>


Func MsClick($tittle, $text, $controlid, $clickType, $clicks = 1, $x = 1, $y = 1)
	$coord = UiRatio($x, $y)
	ControlClick($tittle, $text, $controlid, $clickType, $clicks, $coord[0], $coord[1])
EndFunc   ;==>MsClick

Func UiRatio($_x, $_y)
	Dim $return[2]
	$size = WinGetClientSize("[CLASS:Window tittle]") ; Must set so we can get windows' size
	$return[0] = $size[1] * ($_x / $size[0])
	$return[1] = $size[1] * ($_y / $size[1])
	Return $return
EndFunc   ;==>UiRatio

#cs
Sleep(2000)
_MsClick(318, 542)
Sleep(2000)
_MsClick(318, 542)

Func _MsClick($x, $y, $button = "left")
	$coord = UiRatio($x, $y)
	MouseClick($button, $coord[0], $coord[1])
EndFunc   ;==>_randomclick
#ce