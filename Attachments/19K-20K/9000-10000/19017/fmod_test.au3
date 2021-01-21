#Region converted Directives from D:\snelheidscontrole\prospeed\fmod_test.au3.ini
#AutoIt3Wrapper_aut2exe=D:\Program Files\AutoIt3\Aut2Exe\Aut2Exe.exe
#AutoIt3Wrapper_outfile=D:\snelheidscontrole\prospeed\fmod_test.exe
#AutoIt3Wrapper_Res_Comment=                                               
#AutoIt3Wrapper_Res_Description=AutoIt v3 Compiled Script
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Run_AU3Check=4
#EndRegion converted Directives from D:\snelheidscontrole\prospeed\fmod_test.au3.ini
;
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
HotKeySet("{Esc}", "_exit")

Dim $RetValue2[1], $Is_playing[1], $file,$ext
$dll = DllOpen("fmod.dll")

GUICreate("fmod", 220, 220, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")

$load = GUICtrlCreateButton("Load", 10, 100, 60, 30)
$play = GUICtrlCreateButton("Play", 10, 140, 60, 30)
$stop = GUICtrlCreateButton("Stop", 10, 180, 60, 30)
GUICtrlSetOnEvent($load, "load")
GUICtrlSetOnEvent($play, "Play")
GUICtrlSetOnEvent($stop, "stop")

$lab1    = GUICtrlCreateLabel("Volume ", 80, 10, 100, 20)
$lab2    = GUICtrlCreateLabel("Time  0", 90, 55, 100, 20)

$slider1 = GUICtrlCreateSlider(10, 30, 200, 20)
GUICtrlSetLimit($slider1, 256, 0)
GUICtrlSetOnEvent($slider1, "volume")
GUICtrlSetData($slider1, 50)
$value = GUICtrlRead($slider1)

$slider2 = GUICtrlCreateSlider(10, 70, 200, 20)
GUICtrlSetLimit($slider2, 100, 0)
GUICtrlSetOnEvent($slider2, "setOrder")

GUICtrlSetData($lab1, "volume " & $value)

$infoTime = GUICtrlCreateLabel("Song time = ", 100, 160, 100, 20)
GUISetState()

$buffer   = DllCall($dll, "long", "_FSOUND_SetBufferSize@4", "long",200)
$RetValue = DllCall($dll, "long", "_FSOUND_Init@12", _
						  "long", 44100, _
						  "long", 32, _
						  "long", 0x0001)
While 1
	Sleep(1000)
	If $ext = "od" Or $ext = "3M" Or $ext = "ID" Or $ext = "XM" Or $ext = "IT" Then	
		$Is_playing = DllCall($dll, "long", "_FMUSIC_IsPlaying@4", _
									"long", $RetValue2[0])
		If $Is_playing[0] = True Then
			$songtime = DllCall($dll, "long", "_FMUSIC_GetTime@4", _
									  "long", $RetValue2[0])
			GUICtrlSetData($infoTime, "Song time = " & Round($songtime[0] / 1000))
		EndIf
		If $RetValue2[0] <> 0 Then getOrder()
	EndIf	
WEnd

Func load()
	stop()
	$file = FileOpenDialog("load music", "C:\", "Music (*.mod;*.S3M;*.XM;*.IT;*.MID;*.WAV;*.MP2;*.MP3;*.OGG;*.RAW;*.sam)", 1)
	$ext = StringRight($file, 2)
	If $ext = "od" Or $ext = "3M" Or $ext = "ID" Or $ext = "XM" Or $ext = "IT" Or $ext = "am" Then
		$RetValue2 = DllCall($dll, "long", "_FMUSIC_LoadSong@4", "str", $file)
		$value  = GUICtrlRead($slider1)
		$volume = DllCall($dll, "long", "_FMUSIC_SetMasterVolume@8", _
								"long", $RetValue2[0], _
								"long",$value)	
		$get = DllCall($dll, "long", "_FMUSIC_GetNumOrders@4", _
							 "long", $RetValue2[0])
		GUICtrlSetLimit($slider2, $get[0], 0)
		DllCall($dll, "long", "_FMUSIC_SetLooping@8", _
					  "long", $RetValue2[0], _
					  "long", "FALSE")
	Else 
		$RetValue2 = DllCall($dll, "long", "_FSOUND_Sample_Load@20", _
								   "long","FSOUND_UNMANAGED", _
								   "str",$file, _
								   "long", "FSOUND_16BITS", _
								   "long",0, _
								   "long",0)
	EndIf	
EndFunc

Func Play()
	$ext = StringRight($file,2)
	If $ext = "od" Or $ext = "3M" Or $ext = "ID" Or $ext = "XM" Or $ext = "IT" Then
		If $RetValue2[0] <> 0 Then
			DllCall($dll, "long", "_FMUSIC_PlaySong@4", _
						  "long", $RetValue2[0])
		EndIf
	Else
		DllCall($dll, "long", "_FSOUND_PlaySound@8", _
					  "long", "FSOUND_FREE", _
					  "long", $RetValue2[0])
	EndIf	
EndFunc

Func stop()
	If $ext = "od" Or $ext = "3M" Or $ext = "ID" Or $ext = "XM" Or $ext = "IT" Then
		DllCall($dll, "long", "_FMUSIC_StopSong@4", _
					  "long", $RetValue2[0])
		DllCall($dll, "long", "_FMUSIC_FreeSong@4", _
					  "long", $RetValue2[0])
		$RetValue2[0]  = 0
		$Is_playing[0] = False
	Else
		DllCall($dll,"long", "_FSOUND_StopSound@4", _
					 "long", "FSOUND_ALL")
		DllCall($dll,"long", "_FSOUND_Sample_Free@4", _
					 "long", $RetValue2[0])
	EndIf
EndFunc

Func volume()
	$value = GUICtrlRead($slider1)
	$volume = DllCall($dll, "long", "_FMUSIC_SetMasterVolume@8", _
							"long", $RetValue2[0], _
							"long", $value)
	GUICtrlSetData($lab1, "volume " & $value)
EndFunc

Func getOrder()
	$order = DllCall($dll, "long", "_FMUSIC_GetOrder@4", _
						   "long", $RetValue2[0])
	GUICtrlSetData($lab2, "Time " & $order[0])
	GUICtrlSetData($slider2,  $order[0])
EndFunc

Func setOrder()
	$read = GUICtrlRead($slider2)
	DllCall($dll,"long", "_FMUSIC_SetOrder@8", _
				 "long", $RetValue2[0], _
				 "long", $read)
	$order = DllCall($dll, "long", "_FMUSIC_GetOrder@4", _
						   "long", $RetValue2[0])
	GUICtrlSetData($lab2, "Time " &  $order[0])
	GUICtrlSetData($slider2, $order[0])
EndFunc

Func _exit()
   DllClose($dll)
   Exit
EndFunc