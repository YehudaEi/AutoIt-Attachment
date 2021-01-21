;Opt("OnExitFunc", "Close_DLL2")

$F_DLL = DllOpen("fmod.dll")

#cs
	FModInit()
	initalise Fmod Dll
	need this before you can load a mod or sound file
#ce
Func FModInit()	
	DllCall($F_dll, "long", "_FSOUND_SetBufferSize@4", _
				    "long", 200)
	DllCall($F_dll, "long", "_FSOUND_Init@12", _
				    "long", 44100, _
				    "long", 32, _
				    "long", 0x0001)
EndFunc

#cs
	$mod1 = loadMod($FmodFile)
	loads .mod ; .S3M ; .XM ; .IT files
#ce
Func loadMod($F_ModFile)
	$F_RetValue = DllCall($F_dll, "long", "_FMUSIC_LoadSong@4", _
							      "str" , $F_ModFile)
	Return $F_RetValue[0]
EndFunc

#cs
	$sound1 = loadsound($Fmodsound)
	loads .MID ; .WAV ; .MP2 ; .MP3 ; .OGG ; .RAW files
#ce
Func loadsound($F_Modsound)
	$F_RetValue = DllCall($F_dll, "long", "_FSOUND_Sample_Load@20", _
								  "long", "FSOUND_UNMANAGED", _
								  "str" , $F_Modsound, _
								  "long", "FSOUND_16BITS", _
								  "long", 0, _
								  "long", 0)
	Return $F_RetValue[0]							   
EndFunc

#cs
	PlayMod($FModAlias)
	plays mod file loaded with loadmod() function
	needs return string from loadmod() function
#ce
Func PlayMod($F_ModAlias)
	DllCall($F_dll, "long", "_FMUSIC_PlaySong@4", _
				    "long", $F_ModAlias)
EndFunc

func SetLooping($F_ModAlias, $F_Value)
	DllCall($F_dll, "long", "_FMUSIC_SetLooping@8", _
					"long", $F_ModAlias, _
					"long", $F_Value) 		
EndFunc

Func Isplaying($F_ModAlias)
	$Is_pl = DllCall($F_dll, "long", "_FMUSIC_IsPlaying@4", _
							 "long", $F_ModAlias)
	Return $Is_pl[0]
EndFunc

#cs
	Playsound($FModAlias)
	plays soundfile loaded with loadsound() function
	needs return string from loadsound() function
#ce
Func Playsound($F_ModAlias)
	DllCall($F_dll, "int", "_FSOUND_PlaySound@8", _
				    "int", "FSOUND_FREE", _
				    "int", $F_ModAlias)
EndFunc

#cs
	stop($FModAlias)
	stops sound or mod file from playing
	needs return string from loadsound() or loadmod() function
#ce
Func stop($F_ModAlias)
	DllCall($F_dll, "long", "_FMUSIC_StopSong@4", _
				    "long", $F_ModAlias)
	DllCall($F_dll, "long", "_FMUSIC_FreeSong@4", _
				    "long", $F_ModAlias)
EndFunc

#cs
	volume($FModAlias, $value)
	sets volume for loaded mod or soundfile
	needs return string from loadsound() or loadmod() function
	$value = 1 to 100
#ce
Func volume($F_ModAlias, $F_Value)
	DllCall($F_dll, "long", "_FMUSIC_SetMasterVolume@8", _
				    "long", $F_ModAlias, _
				    "long", $F_Value)
EndFunc

#cs
	$GetTime = GetOrder($F_ModAlias)
	Get Time/Track from playing mod or soundfile
	needs return string from loadsound() or loadmod() function
	Returns Current Track/Time
#ce
Func GetOrder($F_ModAlias)
	$F_Getorder = DllCall($F_dll, "long", "_FMUSIC_GetOrder@4", _
						          "long", $F_ModAlias)
	Return $F_Getorder[0]
EndFunc

#cs
	$SetTime = SetOrder($F_ModAlias, Guictrlread_Value)
	Set Time/Track for playing mod or soundfile
	needs return string from loadsound() or loadmod() function
	needs return string from Guictrlread slider or progressbar
#ce
Func SetOrder($F_ModAlias, $F_ControlRead)
	DllCall($F_dll,"long", "_FMUSIC_SetOrder@8", _
				   "long", $F_ModAlias, _
				   "long", $F_ControlRead)
EndFunc

Func Close_DLL2()
	DllClose($F_DLL)
EndFunc			   