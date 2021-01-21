#include <Media.au3>
MsgBox(0,"Media UDF by Svennie (sound record example)","When you click OK it starts with recording, when you press Escape it will stop recording and show a dialog to save your file.")
HotKeySet("{ESC}","StopRecording")
$Stop=1
Func StopRecording()
	$Stop=0
EndFunc
$Media=_MediaCreate(6)
_MediaRecord($Media)
While $Stop
WEnd
_MediaStop($Media)
$File=FileSaveDialog("","","Wave files (*.wav)")&".wav"
If @error Then
	_MediaClose($Media)
	Exit
EndIf
_MediaSave($Media,$File)
_MediaClose($Media)