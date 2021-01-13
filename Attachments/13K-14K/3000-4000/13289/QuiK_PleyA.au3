#include <GUIConstants.au3>
#include <Sound.au3>

Opt("GUIOnEventMode", 1)
Opt("TrayIconHide", 1)
$message = "Choose zee song"
$LAB1 = HotKeySet("{F2}", "Choose")
$LAB2 = HotKeySet("{F3}", "Play")
$LAB3 = HotKeySet("{F4}", "Stop")
$LAB4 = HotKeySet("{ESC}", "Kill")
$lee = GUICreate("QuiK PleyA", 200, 150, 190, 100)
GUICtrlCreateLabel("****Press Esc to Quit****", 40, 10)
GUICtrlSetColor(-1, 0x006CD9)
GUICtrlCreateLabel("****Press F2 to Choose****", 40, 40)
GUICtrlSetColor(-1, 0x006CD9)
GUICtrlCreateLabel("****Press F3 to Play****", 40, 70)
GUICtrlSetColor(-1, 0x006CD9)
GUICtrlCreateLabel("****Press F4 to Stop****", 40, 100)
GUICtrlSetColor(-1, 0x006CD9)
$slider1 = GUICtrlCreateSlider (10,125,175,20,$TBS_NOTICKS)
GUICtrlSetLimit(-1,100,0)
GUISetState(@SW_SHOW)
GUICtrlSetOnEvent($LAB2, "Play")
GUICtrlSetOnEvent($LAB3, "Stop")
GUICtrlSetOnEvent($LAB4, "Kill")
GUISetOnEvent($GUI_EVENT_CLOSE, "Kill")
$file = FileOpenDialog($message, "", "Songs (*.mp3;*.mid;*.wav;*.wma)", 1)
If @error Then
	MsgBox(4096,"","No File is chosen")
	Exit
EndIf
$op = _SoundOpen ($file)
$pl = _SoundPlay ($op)
_SoundStop ($op)

While 1
	Sleep(50)
WEnd

Func Choose()
	$pl = False
	_SoundStop ($op)
	_SoundClose ($op)
	keys()
	$file = FileOpenDialog($message, "", "Songs (*.mp3;*.mid;*.wav;*.wma)", 1)
	If @error Then
		MsgBox(4096,"","No File is chosen")
		keys()
		Exit
	EndIf
	$op = _SoundOpen ($file)
EndFunc

Func Play()
	_SoundPlay ($op)
	$pl = True
	Sleep(200)
	While $pl = True
		$alfa = Random(0, 2, 1)
		$i = Random(1, 100, 1)
		GUICtrlSetData($slider1,$i)
		If $alfa = 0 Then Send("{NUMLOCK toggle}")
		If $alfa = 1 Then Send("{CAPSLOCK toggle}")
		If $alfa = 2 Then Send("{SCROLLLOCK toggle}")
		Sleep(75) ; or Sleep(Random(50, 100, 1))
		If _SoundPos($op, 2) = _SoundLength($op, 2) Then ExitLoop
	WEnd
EndFunc

Func Stop()
	$pl = False
	_SoundStop ($op)
	keys()
EndFunc

Func keys()
	Send("{NUMLOCK off}")
	Send("{CAPSLOCK off}")
	Send("{SCROLLLOCK off}")
EndFunc

Func Kill()
	_SoundClose ($op)
	keys()
	Exit
EndFunc