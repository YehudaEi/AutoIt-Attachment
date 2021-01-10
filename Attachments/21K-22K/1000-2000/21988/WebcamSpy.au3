#include <Webcam.au3>
#NoTrayIcon
Opt('GuiOnEventMode', 1)
$Form = GUICreate('WebcamSpy', 320, 240, 0, 0)
WinSetOnTop($Form, '', 1)
$open = _WebcamOpen($Form, 0, 0, 320, 240)
GUISetState(@SW_SHOW, $Form)
$found = 0
GUISetOnEvent($GUI_EVENT_CLOSE, '_exit')
MouseMove(179, 161)
Tooltip('Point your webcam so that your mouse is pointing at a good point then press enter to start', @DesktopWidth/2-300, @DesktopHeight/2-17)
HotKeySet('{ENTER}', '_start')
$start = 1
While $start
	MouseMove(179, 161)
WEnd
$color = PixelGetColor(179, 161)
$timer = TimerInit()
While 1
	$search = PixelSearch(175,156,187,165,$color,15)
	If Not @error Then
	Else
		$found = $found + 1
		_BeepSong()
	EndIf
WEnd
Func _exit()
msgbox(0, 'WebcamSpy', 'Amount of people who walked by: '&$found)
exit
EndFunc
Func _start()
	HotkeySet('{ENTER}')
	Tooltip('')
	$start = 0
EndFunc

Func _BeepSong()
	For $i=1000 to 10000 step 1000
	    Beep($i, 100)
	Next
	For $i=10000 to 1000 step -1000
		Beep($i, 100)
	Next
EndFunc
