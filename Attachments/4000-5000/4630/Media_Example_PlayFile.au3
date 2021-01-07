#include <Media.au3>
MsgBox(0,"Media UDF by Svennie (sound record example)","When you click OK you can choose a file to play, press Escape if you want to stop.")
$File=FileOpenDialog("","","Media files (*.avi;*.mp3;*.wav;*.mpg)")
If @error Then Exit
$Media=_MediaOpen($File)
_MediaPlay($Media)
HotKeySet("{ESC}","StopRecording")
$Stop=1
Func StopRecording()
	$Stop=0
EndFunc
While $Stop
WEnd
_MediaStop($Media)
_MediaClose($Media)