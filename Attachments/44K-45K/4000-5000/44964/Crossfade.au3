#include "Bass.au3"
#include "BassMix.au3"

Opt("GUIOnEventMode", 1)

Global $NotDone = 0, $hMixer, $hStream1, $hStream2, $sTrack_1, $sTrack_2

_BASS_Startup()
_BASS_MIX_Startup()

$hGui = GUICreate("Crossfade Test", 350, 200)
$Button_1 = GUICtrlCreateButton("Open Files", 20, 15, 80, 20)
GUICtrlSetOnEvent(-1, "_OpenFiles")
$Label_0 = GUICtrlCreateLabel("The File Open dialog will open twice so you can select 2 seperate tracks.", 120, 10, 210, 35)
$Label_1 = GUICtrlCreateLabel("Track 1:", 10, 50, 330, 30)
$Label_2 = GUICtrlCreateLabel("Track 2:", 10, 90, 330, 30)
$Label_3 = GUICtrlCreateLabel("Nowplaying:", 10, 130, 330, 30)
$Button_2 = GUICtrlCreateButton("Exit", 280, 170, 60, 20)
GUICtrlSetOnEvent(-1, "_Exit")

GUISetOnEvent(-3, "_Exit")

GUISetState()

_BASS_Init(0, -1, 44100, 0, "")


While 1
	If $NotDone = 1 Then
		_GetPos()
	EndIf
	Sleep(100)
WEnd

Func _OpenFiles()
	Local $iLen
	If _BASS_ChannelIsActive($hMixer) Then
		_BASS_ChannelStop($hMixer)
		_BASS_StreamFree($hMixer)
	EndIf
	$file_1 = FileOpenDialog("Open...", "..\audiofiles", "MP3 files (*.MP3)")
	If @error Or Not FileExists($file_1) Then _Exit()
	$sTrack_1 = StringTrimLeft($file_1, StringInStr($file_1, "\", 0, -1))
	$sTrack_1 = StringTrimRight($sTrack_1, 4)
	GUICtrlSetData($Label_1, "Track 1: " & $sTrack_1)
	$file_2 = FileOpenDialog("Open...", "..\audiofiles", "MP3 files (*.MP3)")
	If @error Or Not FileExists($file_2) Then _Exit()
	$sTrack_2 = StringTrimLeft($file_2, StringInStr($file_2, "\", 0, -1))
	$sTrack_2 = StringTrimRight($sTrack_2, 4)
	GUICtrlSetData($Label_2, "Track 2: " & $sTrack_2)

	$hMixer = _BASS_Mixer_StreamCreate(44100, 2, $BASS_SAMPLE_FLOAT)

	$hStream1 = _BASS_StreamCreateFile(False, $file_1, 0, 0, $BASS_STREAM_DECODE)
	$hStream2 = _BASS_StreamCreateFile(False, $file_2, 0, 0, $BASS_STREAM_DECODE)
	$song_length = _BASS_ChannelGetLength($hStream1, $BASS_POS_BYTE)
	$iLen = _Bass_ChannelBytes2Seconds($hStream1, $song_length) - 35; Track lenth in seconds minus 35 seconds
	$iLen = _BASS_ChannelSeconds2Bytes($hStream1, $iLen)
	_BASS_ChannelSetPosition($hStream1, $iLen, $BASS_POS_BYTE); Set the start position at the last 35 seconds of the first track.

	_BASS_Mixer_StreamAddChannel($hMixer, $hStream1, BitOR($BASS_MIXER_FILTER, $BASS_STREAM_AUTOFREE, $BASS_STREAM_DECODE)); Add the first track
	_BASS_Mixer_StreamAddChannelEx($hMixer, $hStream2, BitOR($BASS_MIXER_FILTER, $BASS_STREAM_AUTOFREE, $BASS_STREAM_DECODE), _
			_BASS_ChannelSeconds2Bytes($hMixer, 10), 0); Add the second track and start playing the second track after 10 seconds.  I've set this
			;value because it suits the amount of silence at the beginning of most of my mp3's, but not all sadly :(  Adjust to your preference.
	_BASS_ChannelSetVolume($hStream2, 0); Set the volume of track 2 to off
	_BASS_ChannelPlay($hMixer, True)
	GUICtrlSetData($Label_3, "Now Playing: " & $sTrack_1)
	$NotDone = 1
EndFunc   ;==>_OpenFiles

Func _GetPos()
	If $NotDone = 1 Then
		$Pos = _BASS_Mixer_ChannelGetPosition($hStream2, $BASS_POS_BYTE); Check for track 2 starting.
		If $Pos > 0 Then ;and if it has
			_SlideVol() ; adjust the volumes
			$NotDone = 0
		EndIf
	EndIf
EndFunc   ;==>_GetPos

Func _SlideVol()
	_BASS_ChannelSlideAttribute($hStream2, $BASS_ATTRIB_VOL, 1, 12000); Adjust the times (ms) to your preference
	_BASS_ChannelSlideAttribute($hStream1, $BASS_ATTRIB_VOL, 0, 18000);
	GUICtrlSetData($Label_3, "Now Playing: " & $sTrack_2)
EndFunc   ;==>_SlideVol

Func _Exit()
	_BASS_FREE()
	Exit
EndFunc   ;==>_Exit
