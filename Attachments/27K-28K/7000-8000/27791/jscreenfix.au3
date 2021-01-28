#include <IE.au3>

Opt('GUIOnEventMode', 1)
TraySetToolTip('jscreenfix')

Local $x = 1600, $y = 1200 ;dimentions of the html page
; (put it smaller if you want to repair a little zone or if your screen is smaller)

#Region GUI
$GUI = GUICreate('jscreenfix', 50, 50, -1, -1, 0x80880000, 0x00000008)
GUISetOnEvent(-7, '_Resize')

$o_Em = _IECreateEmbedded( )
$o_IE = GUICtrlCreateObj($o_Em, -2, -2, $x, $y)
_IENavigate($o_Em, 'http://www.jscreenfix.com/applet.php?width=' & $x & '&height=' & $y)

GUISetState(@SW_SHOW, $GUI)
#EndRegion
;

While Sleep(5000)

WEnd

Func _Resize( )
	$f_gc = GUIGetCursorInfo($GUI)
	$f_wp = WinGetPos($GUI)

	If $f_gc[0] > $f_wp[2] - 5 Or $f_gc[1] > $f_wp[3] - 5 Then
		While $f_gc[2] = 1
			Sleep(50) ;CPU
			$f_wp = WinGetPos($GUI)
			$f_mp = MouseGetPos( )
			WinMove($GUI, "", $f_wp[0], $f_wp[1], $f_mp[0] - $f_wp[0], $f_mp[1] - $f_wp[1])
			$f_gc = GUIGetCursorInfo($GUI)
			TrayTip('jscreenfix', 'Winsize : ' & $f_wp[2] & 'x' & $f_wp[3], 1)
		WEnd
	ElseIf $f_gc[0] < 5 Or $f_gc[1] < 5 Then
		While $f_gc[2] = 1
			Sleep(50) ;CPU
			$f_mp = MouseGetPos( )
			WinMove($GUI, "", $f_mp[0], $f_mp[1], $f_wp[2], $f_wp[3])
			$f_gc = GUIGetCursorInfo($GUI)
			TrayTip('jscreenfix', 'Winpos : ' & $f_mp[0] & 'x' & $f_mp[1], 1)
		WEnd
	EndIf
	TrayTip("", "", 0)
EndFunc
