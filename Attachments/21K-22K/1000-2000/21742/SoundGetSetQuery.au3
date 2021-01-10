#cs
	
	Author:  Austin Beer
	Revised: 4/15/08
	
	CODE SOURCES:
	http://www.autohotkey.com/download/ (for AutoHotkey source code)
	http://www.autohotkey.com/docs/commands/SoundSet.htm (for soundcard analysis script)
	http://www.autoitscript.com/forum/index.php?showtopic=54038 (Volume control., Pls pls pls, AI needs something as easy as AHK solution.)
	http://www.autoitscript.com/forum/index.php?showtopic=21584 (Playing with Mixer Device, selecting input line and volume using Mixer device)
	http://www.autoitscript.com/forum/index.php?showtopic=54048 (Audio.au3)
	
	REFERENCE SOURCES:
	http://doc.ddart.net/msdn/header/include/mmsystem.h.html (for mmsystem.h file)
	http://msdn2.microsoft.com/en-us/library/ms712636%28VS.85%29.aspx (for multimedia functions)
	http://msdn2.microsoft.com/en-us/library/ms712703%28VS.85%29.aspx (for multimedia structures)
	http://msdn2.microsoft.com/en-us/library/aa383751(VS.85).aspx (for Windows data types)
	
	REGISTRY LOCATIONS:
	Controls: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceClasses\{6994AD04-93EF-11D0-A3CC-00A0C9223196}\##???{6994ad04-93ef-11d0-a3cc-00a0c9223196}\#???\Device Parameters\Mixer
	
	VISTA SUPPORT:
	- Due to changes in the way Vista handles audio contols such as volume and
	mute, the functions in this file are pretty much useless in Vista.
	
	- According to a comment in the following thread by Larry Osterman, a senior
	development engineer at Microsoft, the new per-application volume/mute
	controls in Vista make it impossible for one application (such as an AutoIt
	script) to change the volume/mute settings of another application. Thus writing
	sound functions for Vista doesn't seem to be an option at this time.
	http://forums.microsoft.com/MSDN/ShowPost.aspx?siteid=1&PostID=1458398
	
	- According to a response by Larry Osterman to a VBScript question in the
	following blog, it isn't possible for a VB script to change the master volume
	in Vista. Thus I don't believe it would be possible to do it with an AutoIt
	script either. However, as this blog entry also makes clear, it is possible
	to do it at the C++ level, so my guess is that any AutoIt function which
	controls the master volume in Vista will have to be built into the AutoIt
	Interpreter itself.
	http://blogs.msdn.com/larryosterman/archive/2007/03/06/how-do-i-change-the-master-volume-in-windows-vista.aspx
	
	MISSING MICROPHONE FUNCTIONS:
	- As you may have noticed, there are no generic microphone volume controls in
	this file. The reason these were left out is because the specific parameters
	for the microphone line of different computers seem to vary greatly, and so
	
	- I recommend using the _SoundQuery() function to determine your specific
	parameters and then using the _SoundGet() and _SoundSet() functions to get
	and set the microphone volume and mute controls.
	
	AVAILABLE FUNCTIONS:
	_SoundGet
	_SoundSet
	_SoundGetMasterVolume
	_SoundSetMasterVolume
	_SoundGetMasterMute
	_SoundSetMasterMute
	_SoundGetWaveVolume
	_SoundSetWaveVolume
	_SoundGetWaveMute
	_SoundSetWaveMute
	_SoundGetCDVolume
	_SoundSetCDVolume
	_SoundGetCDMute
	_SoundSetCDMute
	_SoundGetPhoneVolume
	_SoundSetPhoneVolume
	_SoundGetPhoneMute
	_SoundSetPhoneMute
	_SoundQuery
	
#ce

#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#include <GUIConstants.au3>

; Opt("MustDeclareVars", 1) ; enabled only when verifying code

;###############################################################################

; Data Structures

; MIXERCAPS
Const $MCA_WMID = 1 ; WORD, ushort
Const $MCA_WPID = 2 ; WORD, ushort
Const $MCA_VDRIVERVERSION = 3 ; MMVERSION, uint
Const $MCA_SZPNAME = 4 ; CHAR, char
Const $MCA_FDWSUPPORT = 5 ; DWORD, dword
Const $MCA_CDESTINATIONS = 6 ; DWORD, dword

Const $MCA_STRUCT_DEF = "ushort;ushort;uint;char[32];dword;dword"

; MIXERLINE
Const $ML_CBSTRUCT = 1 ; DWORD, dword
Const $ML_DWDESTINATION = 2 ; DWORD, dword
Const $ML_DWSOURCE = 3 ; DWORD, dword
Const $ML_DWLINEID = 4 ; DWORD, dword
Const $ML_FDWLINE = 5 ; DWORD, dword
Const $ML_DWUSER = 6 ; DWORD, dword
Const $ML_DWCOMPONENTTYPE = 7 ; DWORD, dword
Const $ML_CCHANNELS = 8 ; DWORD, dword
Const $ML_CCONNECTIONS = 9 ; DWORD, dword
Const $ML_CCONTROLS = 10 ; DWORD, dword
Const $ML_SZSHORTNAME = 11 ; CHAR[MIXER_SHORT_NAME_CHARS], char[16]
Const $ML_SZNAME = 12 ; CHAR[MIXER_LONG_NAME_CHARS], char[64]
Const $ML_DWTYPE = 13 ; DWORD, dword
Const $ML_DWDEVICEID = 14 ; DWORD, dword
Const $ML_WMID = 15 ; WORD, ushort
Const $ML_WPID = 16 ; WORD, ushort
Const $ML_VDRIVERVERSION = 17 ; MMVERSION, uint
Const $ML_SZPNAME = 18 ; CHAR[MAXPNAMELEN], char[32]

Const $ML_STRUCT_DEF = "dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;char[16];char[64];dword;dword;ushort;ushort;uint;char[32]"

; MIXERCONTROL
Const $MCO_CBSTRUCT = 1 ; DWORD, dword
Const $MCO_DWCONTROLID = 2 ; DWORD, dword
Const $MCO_DWCONTROLTYPE = 3 ; DWORD, dword
Const $MCO_FDWCONTROL = 4 ; DWORD, dword
Const $MCO_CMULTIPLEITEMS = 5 ; DWORD, dword
Const $MCO_SZSHORTNAME = 6 ; CHAR[MIXER_SHORT_NAME_CHARS], char[16]
Const $MCO_SZNAME = 7 ; CHAR[MIXER_LONG_NAME_CHARS], char[64]
Const $MCO_LMINIMUM = 8 ; LONG, long - part of the Bounds union
Const $MCO_LMAXIMUM = 9 ; LONG, long - part of the Bounds union
Const $MCO_DWMINIMUM = 8 ; DWORD, dword - part of the Bounds union
Const $MCO_DWMAXIMUM = 9 ; DWORD, dword - part of the Bounds union
Const $MCO_DWRESERVED_1 = 10 ; DWORD[6], dword[4] - part of the Bounds union
Const $MCO_CSTEPS = 11 ; DWORD, dword - part of the Metrics union
Const $MCO_CBCUSTOMDATA = 11 ; DWORD, dword - part of the Metrics union
Const $MCO_DWRESERVED_2 = 12 ; DWORD[6], dword[5] - part of the Metrics union

Const $MCO_STRUCT_DEF = "dword;dword;dword;dword;dword;char[16];char[64];dword;dword;dword[4];dword;dword[5]"

; MIXERLINECONTROLS
Const $MLC_CBSTRUCT = 1 ; DWORD, dword
Const $MLC_DWLINEID = 2 ; DWORD, dword
Const $MLC_DWCONTROLID = 3 ; DWORD, dword - part of union
Const $MLC_DWCONTROLTYPE = 3 ; DWORD, dword - part of union
Const $MLC_CCONTROLS = 4 ; DWORD, dword
Const $MLC_CBMXCTRL = 5 ; DWORD, dword
Const $MLC_PAMXCTRL = 6 ; LPMIXERCONTROLA, ptr

Const $MLC_STRUCT_DEF = "dword;dword;dword;dword;dword;ptr"

; MIXERCONTROLDETAILS
Const $MCD_CBSTRUCT = 1 ; DWORD, dword
Const $MCD_DWCONTROLID = 2 ; DWORD, dword
Const $MCD_CCHANNELS = 3 ; DWORD, dword
Const $MCD_HWNDOWNER = 4 ; HWND, hwnd - part of union
Const $MCD_CMULTIPLEITEMS = 4 ; DWORD, dword - part of union
Const $MCD_CBDETAILS = 5 ; DWORD, dword
Const $MCD_PADETAILS = 6 ; LPVOID, ptr

Const $MCD_STRUCT_DEF = "dword;dword;dword;dword;dword;ptr"

; MIXERCONTROLDETAILS_UNSIGNED
Const $MCDU_DWVALUE = 1 ; DWORD, dword

Const $MCDU_STRUCT_DEF = "dword"

;###############################################################################

; Component Type Definitions

Const $MIXERLINE_COMPONENTTYPE_DST_FIRST = 0x00000000
Const $MIXERLINE_COMPONENTTYPE_DST_UNDEFINED = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 0
Const $MIXERLINE_COMPONENTTYPE_DST_DIGITAL = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 1
Const $MIXERLINE_COMPONENTTYPE_DST_LINE = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 2
Const $MIXERLINE_COMPONENTTYPE_DST_MONITOR = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 3
Const $MIXERLINE_COMPONENTTYPE_DST_SPEAKERS = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 4
Const $MIXERLINE_COMPONENTTYPE_DST_HEADPHONES = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 5
Const $MIXERLINE_COMPONENTTYPE_DST_TELEPHONE = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 6
Const $MIXERLINE_COMPONENTTYPE_DST_WAVEIN = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 7
Const $MIXERLINE_COMPONENTTYPE_DST_VOICEIN = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 8
Const $MIXERLINE_COMPONENTTYPE_DST_LAST = $MIXERLINE_COMPONENTTYPE_DST_FIRST + 8
Const $MIXERLINE_COMPONENTTYPE_SRC_FIRST = 0x00001000
Const $MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 0
Const $MIXERLINE_COMPONENTTYPE_SRC_DIGITAL = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 1
Const $MIXERLINE_COMPONENTTYPE_SRC_LINE = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 2
Const $MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 3
Const $MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 4
Const $MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 5
Const $MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 6
Const $MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 7
Const $MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 8
Const $MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 9
Const $MIXERLINE_COMPONENTTYPE_SRC_ANALOG = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10
Const $MIXERLINE_COMPONENTTYPE_SRC_LAST = $MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10

Global $aiComponentTypes[20]
Global $asComponentTypes[20]

$aiComponentTypes[0] = $MIXERLINE_COMPONENTTYPE_DST_UNDEFINED
$aiComponentTypes[1] = $MIXERLINE_COMPONENTTYPE_DST_DIGITAL
$aiComponentTypes[2] = $MIXERLINE_COMPONENTTYPE_DST_LINE
$aiComponentTypes[3] = $MIXERLINE_COMPONENTTYPE_DST_MONITOR
$aiComponentTypes[4] = $MIXERLINE_COMPONENTTYPE_DST_SPEAKERS
$aiComponentTypes[5] = $MIXERLINE_COMPONENTTYPE_DST_HEADPHONES
$aiComponentTypes[6] = $MIXERLINE_COMPONENTTYPE_DST_TELEPHONE
$aiComponentTypes[7] = $MIXERLINE_COMPONENTTYPE_DST_WAVEIN
$aiComponentTypes[8] = $MIXERLINE_COMPONENTTYPE_DST_VOICEIN
$aiComponentTypes[9] = $MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED
$aiComponentTypes[10] = $MIXERLINE_COMPONENTTYPE_SRC_DIGITAL
$aiComponentTypes[11] = $MIXERLINE_COMPONENTTYPE_SRC_LINE
$aiComponentTypes[12] = $MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE
$aiComponentTypes[13] = $MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER
$aiComponentTypes[14] = $MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC
$aiComponentTypes[15] = $MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE
$aiComponentTypes[16] = $MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER
$aiComponentTypes[17] = $MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT
$aiComponentTypes[18] = $MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY
$aiComponentTypes[19] = $MIXERLINE_COMPONENTTYPE_SRC_ANALOG

$asComponentTypes[0] = "dUndefined"
$asComponentTypes[1] = "dDigital"
$asComponentTypes[2] = "dLine"
$asComponentTypes[3] = "dMonitor"
$asComponentTypes[4] = "dSpeakers"
$asComponentTypes[5] = "dHeadphones"
$asComponentTypes[6] = "dTelephone"
$asComponentTypes[7] = "dWave"
$asComponentTypes[8] = "dVoice"
$asComponentTypes[9] = "sUndefined"
$asComponentTypes[10] = "sDigital"
$asComponentTypes[11] = "sLine"
$asComponentTypes[12] = "sMicrophone"
$asComponentTypes[13] = "sSynthesizer"
$asComponentTypes[14] = "sCompactDisc"
$asComponentTypes[15] = "sTelephone"
$asComponentTypes[16] = "sPCSpeaker"
$asComponentTypes[17] = "sWave"
$asComponentTypes[18] = "sAuxiliary"
$asComponentTypes[19] = "sAnalog"

;###############################################################################

; Control Type Definitions

Const $MIXERCONTROL_CT_CLASS_CUSTOM = 0x00000000
Const $MIXERCONTROL_CT_CLASS_METER = 0x10000000
Const $MIXERCONTROL_CT_CLASS_SWITCH = 0x20000000
Const $MIXERCONTROL_CT_CLASS_NUMBER = 0x30000000
Const $MIXERCONTROL_CT_CLASS_SLIDER = 0x40000000
Const $MIXERCONTROL_CT_CLASS_FADER = 0x50000000
Const $MIXERCONTROL_CT_CLASS_TIME = 0x60000000
Const $MIXERCONTROL_CT_CLASS_LIST = 0x70000000

Const $MIXERCONTROL_CT_SC_SWITCH_BOOLEAN = 0x00000000
Const $MIXERCONTROL_CT_SC_SWITCH_BUTTON = 0x01000000

Const $MIXERCONTROL_CT_SC_METER_POLLED = 0x00000000

Const $MIXERCONTROL_CT_SC_TIME_MICROSECS = 0x00000000
Const $MIXERCONTROL_CT_SC_TIME_MILLISECS = 0x01000000

Const $MIXERCONTROL_CT_SC_LIST_SINGLE = 0x00000000
Const $MIXERCONTROL_CT_SC_LIST_MULTIPLE = 0x01000000

Const $MIXERCONTROL_CT_UNITS_CUSTOM = 0x00000000
Const $MIXERCONTROL_CT_UNITS_BOOLEAN = 0x00010000
Const $MIXERCONTROL_CT_UNITS_SIGNED = 0x00020000
Const $MIXERCONTROL_CT_UNITS_UNSIGNED = 0x00030000
Const $MIXERCONTROL_CT_UNITS_DECIBELS = 0x00040000 ; in 10ths
Const $MIXERCONTROL_CT_UNITS_PERCENT = 0x00050000 ; in 10ths

Const $MIXERCONTROL_CONTROLTYPE_CUSTOM = BitOR($MIXERCONTROL_CT_CLASS_CUSTOM, $MIXERCONTROL_CT_UNITS_CUSTOM)
Const $MIXERCONTROL_CONTROLTYPE_BOOLEANMETER = BitOR($MIXERCONTROL_CT_CLASS_METER, $MIXERCONTROL_CT_SC_METER_POLLED, $MIXERCONTROL_CT_UNITS_BOOLEAN)
Const $MIXERCONTROL_CONTROLTYPE_SIGNEDMETER = BitOR($MIXERCONTROL_CT_CLASS_METER, $MIXERCONTROL_CT_SC_METER_POLLED, $MIXERCONTROL_CT_UNITS_SIGNED)
Const $MIXERCONTROL_CONTROLTYPE_PEAKMETER = $MIXERCONTROL_CONTROLTYPE_SIGNEDMETER + 1
Const $MIXERCONTROL_CONTROLTYPE_UNSIGNEDMETER = BitOR($MIXERCONTROL_CT_CLASS_METER, $MIXERCONTROL_CT_SC_METER_POLLED, $MIXERCONTROL_CT_UNITS_UNSIGNED)
Const $MIXERCONTROL_CONTROLTYPE_BOOLEAN = BitOR($MIXERCONTROL_CT_CLASS_SWITCH, $MIXERCONTROL_CT_SC_SWITCH_BOOLEAN, $MIXERCONTROL_CT_UNITS_BOOLEAN)
Const $MIXERCONTROL_CONTROLTYPE_ONOFF = $MIXERCONTROL_CONTROLTYPE_BOOLEAN + 1
Const $MIXERCONTROL_CONTROLTYPE_MUTE = $MIXERCONTROL_CONTROLTYPE_BOOLEAN + 2
Const $MIXERCONTROL_CONTROLTYPE_MONO = $MIXERCONTROL_CONTROLTYPE_BOOLEAN + 3
Const $MIXERCONTROL_CONTROLTYPE_LOUDNESS = $MIXERCONTROL_CONTROLTYPE_BOOLEAN + 4
Const $MIXERCONTROL_CONTROLTYPE_STEREOENH = $MIXERCONTROL_CONTROLTYPE_BOOLEAN + 5
Const $MIXERCONTROL_CONTROLTYPE_BUTTON = BitOR($MIXERCONTROL_CT_CLASS_SWITCH, $MIXERCONTROL_CT_SC_SWITCH_BUTTON, $MIXERCONTROL_CT_UNITS_BOOLEAN)
Const $MIXERCONTROL_CONTROLTYPE_DECIBELS = BitOR($MIXERCONTROL_CT_CLASS_NUMBER, $MIXERCONTROL_CT_UNITS_DECIBELS)
Const $MIXERCONTROL_CONTROLTYPE_SIGNED = BitOR($MIXERCONTROL_CT_CLASS_NUMBER, $MIXERCONTROL_CT_UNITS_SIGNED)
Const $MIXERCONTROL_CONTROLTYPE_UNSIGNED = BitOR($MIXERCONTROL_CT_CLASS_NUMBER, $MIXERCONTROL_CT_UNITS_UNSIGNED)
Const $MIXERCONTROL_CONTROLTYPE_PERCENT = BitOR($MIXERCONTROL_CT_CLASS_NUMBER, $MIXERCONTROL_CT_UNITS_PERCENT)
Const $MIXERCONTROL_CONTROLTYPE_SLIDER = BitOR($MIXERCONTROL_CT_CLASS_SLIDER, $MIXERCONTROL_CT_UNITS_SIGNED)
Const $MIXERCONTROL_CONTROLTYPE_PAN = $MIXERCONTROL_CONTROLTYPE_SLIDER + 1
Const $MIXERCONTROL_CONTROLTYPE_QSOUNDPAN = $MIXERCONTROL_CONTROLTYPE_SLIDER + 2
Const $MIXERCONTROL_CONTROLTYPE_FADER = BitOR($MIXERCONTROL_CT_CLASS_FADER, $MIXERCONTROL_CT_UNITS_UNSIGNED)
Const $MIXERCONTROL_CONTROLTYPE_VOLUME = $MIXERCONTROL_CONTROLTYPE_FADER + 1
Const $MIXERCONTROL_CONTROLTYPE_BASS = $MIXERCONTROL_CONTROLTYPE_FADER + 2
Const $MIXERCONTROL_CONTROLTYPE_TREBLE = $MIXERCONTROL_CONTROLTYPE_FADER + 3
Const $MIXERCONTROL_CONTROLTYPE_EQUALIZER = $MIXERCONTROL_CONTROLTYPE_FADER + 4
Const $MIXERCONTROL_CONTROLTYPE_SINGLESELECT = BitOR($MIXERCONTROL_CT_CLASS_LIST, $MIXERCONTROL_CT_SC_LIST_SINGLE, $MIXERCONTROL_CT_UNITS_BOOLEAN)
Const $MIXERCONTROL_CONTROLTYPE_MUX = $MIXERCONTROL_CONTROLTYPE_SINGLESELECT + 1
Const $MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT = BitOR($MIXERCONTROL_CT_CLASS_LIST, $MIXERCONTROL_CT_SC_LIST_MULTIPLE, $MIXERCONTROL_CT_UNITS_BOOLEAN)
Const $MIXERCONTROL_CONTROLTYPE_MIXER = $MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT + 1
Const $MIXERCONTROL_CONTROLTYPE_MICROTIME = BitOR($MIXERCONTROL_CT_CLASS_TIME, $MIXERCONTROL_CT_SC_TIME_MICROSECS, $MIXERCONTROL_CT_UNITS_UNSIGNED)
Const $MIXERCONTROL_CONTROLTYPE_MILLITIME = BitOR($MIXERCONTROL_CT_CLASS_TIME, $MIXERCONTROL_CT_SC_TIME_MILLISECS, $MIXERCONTROL_CT_UNITS_UNSIGNED)

Global $aiControlTypes[30]
Global $asControlTypes[30]

$aiControlTypes[0] = $MIXERCONTROL_CONTROLTYPE_CUSTOM
$aiControlTypes[1] = $MIXERCONTROL_CONTROLTYPE_BOOLEANMETER
$aiControlTypes[2] = $MIXERCONTROL_CONTROLTYPE_SIGNEDMETER
$aiControlTypes[3] = $MIXERCONTROL_CONTROLTYPE_PEAKMETER
$aiControlTypes[4] = $MIXERCONTROL_CONTROLTYPE_UNSIGNEDMETER
$aiControlTypes[5] = $MIXERCONTROL_CONTROLTYPE_BOOLEAN
$aiControlTypes[6] = $MIXERCONTROL_CONTROLTYPE_ONOFF
$aiControlTypes[7] = $MIXERCONTROL_CONTROLTYPE_MUTE
$aiControlTypes[8] = $MIXERCONTROL_CONTROLTYPE_MONO
$aiControlTypes[9] = $MIXERCONTROL_CONTROLTYPE_LOUDNESS
$aiControlTypes[10] = $MIXERCONTROL_CONTROLTYPE_STEREOENH
$aiControlTypes[11] = $MIXERCONTROL_CONTROLTYPE_BUTTON
$aiControlTypes[12] = $MIXERCONTROL_CONTROLTYPE_DECIBELS
$aiControlTypes[13] = $MIXERCONTROL_CONTROLTYPE_SIGNED
$aiControlTypes[14] = $MIXERCONTROL_CONTROLTYPE_UNSIGNED
$aiControlTypes[15] = $MIXERCONTROL_CONTROLTYPE_PERCENT
$aiControlTypes[16] = $MIXERCONTROL_CONTROLTYPE_SLIDER
$aiControlTypes[17] = $MIXERCONTROL_CONTROLTYPE_PAN
$aiControlTypes[18] = $MIXERCONTROL_CONTROLTYPE_QSOUNDPAN
$aiControlTypes[19] = $MIXERCONTROL_CONTROLTYPE_FADER
$aiControlTypes[20] = $MIXERCONTROL_CONTROLTYPE_VOLUME
$aiControlTypes[21] = $MIXERCONTROL_CONTROLTYPE_BASS
$aiControlTypes[22] = $MIXERCONTROL_CONTROLTYPE_TREBLE
$aiControlTypes[23] = $MIXERCONTROL_CONTROLTYPE_EQUALIZER
$aiControlTypes[24] = $MIXERCONTROL_CONTROLTYPE_SINGLESELECT
$aiControlTypes[25] = $MIXERCONTROL_CONTROLTYPE_MUX
$aiControlTypes[26] = $MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT
$aiControlTypes[27] = $MIXERCONTROL_CONTROLTYPE_MIXER
$aiControlTypes[28] = $MIXERCONTROL_CONTROLTYPE_MICROTIME
$aiControlTypes[29] = $MIXERCONTROL_CONTROLTYPE_MILLITIME

$asControlTypes[0] = "Custom"
$asControlTypes[1] = "BooleanMeter"
$asControlTypes[2] = "SignedMeter"
$asControlTypes[3] = "PeakMeter"
$asControlTypes[4] = "UnsignedMeter"
$asControlTypes[5] = "Boolean"
$asControlTypes[6] = "OnOff"
$asControlTypes[7] = "Mute"
$asControlTypes[8] = "Mono"
$asControlTypes[9] = "Loudness"
$asControlTypes[10] = "StereoEnh"
$asControlTypes[11] = "Button"
$asControlTypes[12] = "Decibels"
$asControlTypes[13] = "Signed"
$asControlTypes[14] = "Unsigned"
$asControlTypes[15] = "Percent"
$asControlTypes[16] = "Slider"
$asControlTypes[17] = "Pan"
$asControlTypes[18] = "QSoundPan"
$asControlTypes[19] = "Fader"
$asControlTypes[20] = "Volume"
$asControlTypes[21] = "Bass"
$asControlTypes[22] = "Treble"
$asControlTypes[23] = "Equalizer"
$asControlTypes[24] = "SingleSelect"
$asControlTypes[25] = "Mux"
$asControlTypes[26] = "MultipleSelect"
$asControlTypes[27] = "Mixer"
$asControlTypes[28] = "Microtime"
$asControlTypes[29] = "Millitime"

;###############################################################################

; Miscellaneous Definitions

Const $MIXER_GETLINEINFOF_DESTINATION = 0x00000000
Const $MIXER_GETLINEINFOF_SOURCE = 0x00000001
Const $MIXER_GETLINEINFOF_LINEID = 0x00000002
Const $MIXER_GETLINEINFOF_COMPONENTTYPE = 0x00000003
Const $MIXER_GETLINEINFOF_TARGETTYPE = 0x00000004

Const $MIXER_GETLINECONTROLSF_ALL = 0x00000000
Const $MIXER_GETLINECONTROLSF_ONEBYID = 0x00000001
Const $MIXER_GETLINECONTROLSF_ONEBYTYPE = 0x00000002

Const $MIXER_GETCONTROLDETAILSF_VALUE = 0x00000000
Const $MIXER_GETCONTROLDETAILSF_LISTTEXT = 0x00000001

Const $MIXER_SETCONTROLDETAILSF_VALUE = 0x00000000
Const $MIXER_SETCONTROLDETAILSF_CUSTOM = 0x00000001

;###############################################################################

; Internal Helper Functions

Func MixerOpen(ByRef $hMixer, $iMixerID, $hCallback, $iInstance, $iFlags)
	Local $hStruct = DllStructCreate("ptr")
	Local $iRet = DllCall("winmm.dll", "uint", "mixerOpen", "ptr", DllStructGetPtr($hStruct), "uint", $iMixerID, "dword", $hCallback, "dword", $iInstance, "dword", $iFlags)
	If @error Or $iRet[0] Then
		Return False
	Else
		$hMixer = DllStructGetData($hStruct, 1)
		Return True
	EndIf
EndFunc   ;==>MixerOpen

Func MixerClose($hMixer)
	Local $iRet = DllCall("winmm.dll", "uint", "mixerClose", "uint", $hMixer)
	If @error Or $iRet[0] Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>MixerClose

Func MixerGetDevCaps($hMixer, ByRef $hMxCaps)
	Local $iRet = DllCall("winmm.dll", "uint", "mixerGetDevCaps", "uint", $hMixer, "ptr", DllStructGetPtr($hMxCaps), "uint", DllStructGetSize($hMxCaps))
	If @error Or $iRet[0] Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>MixerGetDevCaps

Func MixerGetLineInfo($hMixer, ByRef $hMxLine, $iFlags)
	DllStructSetData($hMxLine, $ML_CBSTRUCT, DllStructGetSize($hMxLine))
	Local $iRet = DllCall("winmm.dll", "uint", "mixerGetLineInfo", "uint", $hMixer, "ptr", DllStructGetPtr($hMxLine), "dword", $iFlags)
	If @error Or $iRet[0] Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>MixerGetLineInfo

Func MixerGetLineControls($hMixer, ByRef $hMxLineCtrls, $iFlags)
	DllStructSetData($hMxLineCtrls, $MLC_CBSTRUCT, DllStructGetSize($hMxLineCtrls))
	Local $iRet = DllCall("winmm.dll", "uint", "mixerGetLineControls", "uint", $hMixer, "ptr", DllStructGetPtr($hMxLineCtrls), "dword", $iFlags)
	If @error Or $iRet[0] Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>MixerGetLineControls

Func MixerGetControlDetails($hMixer, ByRef $hMxCtrlDetails, $iFlags)
	DllStructSetData($hMxCtrlDetails, $MCD_CBSTRUCT, DllStructGetSize($hMxCtrlDetails))
	Local $iRet = DllCall("winmm.dll", "uint", "mixerGetControlDetails", "uint", $hMixer, "ptr", DllStructGetPtr($hMxCtrlDetails), "dword", $iFlags)
	If @error Or $iRet[0] Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>MixerGetControlDetails

Func MixerSetControlDetails($hMixer, ByRef $hMxCtrlDetails, $iFlags)
	DllStructSetData($hMxCtrlDetails, $MCD_CBSTRUCT, DllStructGetSize($hMxCtrlDetails))
	Local $iRet = DllCall("winmm.dll", "uint", "mixerSetControlDetails", "uint", $hMixer, "ptr", DllStructGetPtr($hMxCtrlDetails), "dword", $iFlags)
	If @error Or $iRet[0] Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>MixerSetControlDetails

;###############################################################################

; Main Internal Helper Function

Func SoundSetGet($iMixerID, $sComponentType, $iComponentInstance, $sControlType, $fIsSet, $iNewParamValue)

	; Check the mixer ID.
	If Not IsInt($iMixerID) Or $iMixerID < 0 Then
		SetError(1)
		Return 0
	EndIf

	; Determine the component type.
	Local $iComponentType = -1
	For $iIndex = 0 To UBound($asComponentTypes) - 1
		If StringCompare($sComponentType, $asComponentTypes[$iIndex]) = 0 Then
			$iComponentType = $aiComponentTypes[$iIndex]
			ExitLoop
		EndIf
	Next
	
	; Check the component type.
	If $iComponentType = -1 Then
		SetError(2)
		Return 0
	EndIf
	
	; Check the component instance.
	If Not IsInt($iComponentInstance) Or $iComponentInstance <= 0 Then
		SetError(3)
		Return 0
	EndIf

	; Determine the control type.
	Local $iControlType = -1
	For $iIndex = 0 To UBound($asControlTypes) - 1
		If StringCompare($sControlType, $asControlTypes[$iIndex]) = 0 Then
			$iControlType = $aiControlTypes[$iIndex]
			ExitLoop
		EndIf
	Next
	
	If $iControlType = -1 Then
		SetError(4)
		Return 0
	EndIf

	; Open the specified mixer ID.
	Local $hMixer
	If Not MixerOpen($hMixer, $iMixerID, 0, 0, 0) Then
		SetError(5)
		Return 0
	EndIf

	; Find out how many destinations are available on this mixer (should always be at least one).
	Local $iDestCount
	Local $hMxCaps = DllStructCreate($MCA_STRUCT_DEF)
	If MixerGetDevCaps($hMixer, $hMxCaps) Then
		$iDestCount = DllStructGetData($hMxCaps, $MCA_CDESTINATIONS)
	Else
		$iDestCount = 1 ; Assume it has one so that we can try to proceed anyway.
	EndIf

	; Find the specified line (componentType + componentInstance).
	Local $hMxLine = DllStructCreate($ML_STRUCT_DEF)
	If $iComponentInstance = 1 Then ; Just get the first line of this type, the easy way.
		DllStructSetData($hMxLine, $ML_DWCOMPONENTTYPE, $iComponentType)
		If Not MixerGetLineInfo($hMixer, $hMxLine, $MIXER_GETLINEINFOF_COMPONENTTYPE) Then
			MixerClose($hMixer)
			SetError(6)
			Return 0
		EndIf
	Else
		; Search through each source of each destination, looking for the indicated
		; instance number for the indicated component type.
		Local $fFound = False
		Local $iCurDest = 0
		Local $iInstanceFound = 0
		While $iCurDest < $iDestCount And Not $fFound ; For each destination of this mixer.
			DllStructSetData($hMxLine, $ML_DWDESTINATION, $iCurDest)
			If Not MixerGetLineInfo($hMixer, $hMxLine, $MIXER_GETLINEINFOF_DESTINATION) Then
				$iCurDest = $iCurDest + 1
				ContinueLoop ; Keep trying in case the others can be retrieved.
			EndIf
			Local $iSrcCount = DllStructGetData($hMxLine, $ML_CCONNECTIONS) ; Make a copy of this value so that the struct can be reused.
			Local $iCurSrc = 0
			While $iCurSrc < $iSrcCount And Not $fFound ; For each source of this destination.
				DllStructSetData($hMxLine, $ML_DWDESTINATION, $iCurDest) ; Set it again in case it was changed.
				DllStructSetData($hMxLine, $ML_DWSOURCE, $iCurSrc)
				If Not MixerGetLineInfo($hMixer, $hMxLine, $MIXER_GETLINEINFOF_SOURCE) Then
					$iCurSrc = $iCurSrc + 1
					ContinueLoop ; Keep trying in case the others can be retrieved.
				EndIf
				If DllStructGetData($hMxLine, $ML_DWCOMPONENTTYPE) = $iComponentType Then
					$iInstanceFound = $iInstanceFound + 1
					If $iInstanceFound = $iComponentInstance Then
						$fFound = True
					EndIf
				EndIf
				$iCurSrc = $iCurSrc + 1
			WEnd
			$iCurDest = $iCurDest + 1
		WEnd
		If Not $fFound Then
			MixerClose($hMixer)
			SetError(7)
			Return 0
		EndIf
	EndIf

	; Find the mixer control for the above component.
	Local $hMxLineCtrls = DllStructCreate($MLC_STRUCT_DEF)
	Local $hMxCtrl = DllStructCreate($MCO_STRUCT_DEF) ; MSDN: "No initialization of the buffer pointed to by [pamxctrl below] is required"
	DllStructSetData($hMxLineCtrls, $MLC_CBSTRUCT, DllStructGetSize($hMxLineCtrls))
	DllStructSetData($hMxLineCtrls, $MLC_DWLINEID, DllStructGetData($hMxLine, $ML_DWLINEID))
	DllStructSetData($hMxLineCtrls, $MLC_DWCONTROLTYPE, $iControlType)
	DllStructSetData($hMxLineCtrls, $MLC_CCONTROLS, 1)
	DllStructSetData($hMxLineCtrls, $MLC_CBMXCTRL, DllStructGetSize($hMxCtrl))
	DllStructSetData($hMxLineCtrls, $MLC_PAMXCTRL, DllStructGetPtr($hMxCtrl))
	If Not MixerGetLineControls($hMixer, $hMxLineCtrls, $MIXER_GETLINECONTROLSF_ONEBYTYPE) Then
		MixerClose($hMixer)
		SetError(8)
		Return 0
	EndIf
	
	; Get the min and max values of the current control.
	Local $iMin = DllStructGetData($hMxCtrl, $MCO_DWMINIMUM)
	Local $iMax = DllStructGetData($hMxCtrl, $MCO_DWMAXIMUM)

	; Determine if the control is on/off or something else.
	Local $fControlTypeIsBoolean
	Switch $iControlType
		Case $MIXERCONTROL_CONTROLTYPE_ONOFF
			$fControlTypeIsBoolean = True
		Case $MIXERCONTROL_CONTROLTYPE_MUTE
			$fControlTypeIsBoolean = True
		Case $MIXERCONTROL_CONTROLTYPE_MONO
			$fControlTypeIsBoolean = True
		Case $MIXERCONTROL_CONTROLTYPE_LOUDNESS
			$fControlTypeIsBoolean = True
		Case $MIXERCONTROL_CONTROLTYPE_STEREOENH
			$fControlTypeIsBoolean = True
		Case Else ; For all others, assume the control can have more than just on/off as its allowed states.
			$fControlTypeIsBoolean = False
	EndSwitch

	; Does user want to adjust the current setting by a certain amount?
	Local $fAdjustCurrentSettings = False
	If $fIsSet And (StringLeft($iNewParamValue, 1) = "+" Or StringLeft($iNewParamValue, 1) = "-") Then
		$fAdjustCurrentSettings = True
	EndIf

	; These are used in more than once place, so always initialize them here.
	Local $hMxCtrlDetails = DllStructCreate($MCD_STRUCT_DEF)
	Local $hMxCtrlValue = DllStructCreate($MCDU_STRUCT_DEF)
	DllStructSetData($hMxCtrlDetails, $MCD_CBSTRUCT, DllStructGetSize($hMxCtrlDetails))
	DllStructSetData($hMxCtrlDetails, $MCD_DWCONTROLID, DllStructGetData($hMxCtrl, $MCO_DWCONTROLID))
	DllStructSetData($hMxCtrlDetails, $MCD_CCHANNELS, 1) ; MSDN: "when an application needs to get and set all channels as if they were uniform"
	DllStructSetData($hMxCtrlDetails, $MCD_CBDETAILS, DllStructGetSize($hMxCtrlValue))
	DllStructSetData($hMxCtrlDetails, $MCD_PADETAILS, DllStructGetPtr($hMxCtrlValue))

	; Get the current setting of the control for adjusting the control's value.
	Local $iCurValue = 0
	If $fAdjustCurrentSettings Then
		If Not MixerGetControlDetails($hMixer, $hMxCtrlDetails, $MIXER_GETCONTROLDETAILSF_VALUE) Then
			MixerClose($hMixer)
			SetError(9)
			Return 0
		EndIf
		$iCurValue = DllStructGetData($hMxCtrlValue, $MCDU_DWVALUE)
	EndIf

	; Set the control's value if this is being called by SoundSet.
	If $fIsSet Then
		If $fControlTypeIsBoolean Then
			If $fAdjustCurrentSettings Then ; The user wants this toggleable control to be toggled to its opposite state.
				If $iCurValue > $iMin Then
					DllStructSetData($hMxCtrlValue, $MCDU_DWVALUE, $iMin)
				Else
					DllStructSetData($hMxCtrlValue, $MCDU_DWVALUE, $iMax)
				EndIf
			Else ; Set the value according to whether the user gave us a setting that is greater than zero.
				If $iNewParamValue > 0 Then
					DllStructSetData($hMxCtrlValue, $MCDU_DWVALUE, $iMax)
				Else
					DllStructSetData($hMxCtrlValue, $MCDU_DWVALUE, $iMin)
				EndIf
			EndIf
		Else ; Assume the control can have more than just on/off as its allowed states.
			Local $iNewActualValue = ($iMax - $iMin) * ($iNewParamValue / 100.0)
			If $fAdjustCurrentSettings Then
				$iNewActualValue = $iNewActualValue + $iCurValue
			EndIf
			If $iNewActualValue < $iMin Then
				$iNewActualValue = $iMin
			ElseIf $iNewActualValue > $iMax Then
				$iNewActualValue = $iMax
			EndIf
			DllStructSetData($hMxCtrlValue, $MCDU_DWVALUE, $iNewActualValue)
		EndIf

		If Not MixerSetControlDetails($hMixer, $hMxCtrlDetails, $MIXER_SETCONTROLDETAILSF_VALUE) Then
			MixerClose($hMixer)
			SetError(10)
			Return 0
		EndIf
	EndIf

	; Get the control value - do this even for Set in order to pass back what it was actually set to.
	If Not MixerGetControlDetails($hMixer, $hMxCtrlDetails, $MIXER_GETCONTROLDETAILSF_VALUE) Then
		MixerClose($hMixer)
		SetError(9)
		Return 0
	EndIf
	$iCurValue = DllStructGetData($hMxCtrlValue, $MCDU_DWVALUE)
	MixerClose($hMixer)
	SetError(0)

	If $fControlTypeIsBoolean Then
		If $iCurValue Then
			Return 1
		Else
			Return 0
		EndIf
	Else ; Assume the control can have more than just ON/OFF as its allowed states.
		; The MSDN docs imply that values fetched via the above method do not distinguish
		; between left and right volume levels, unlike waveOutGetVolume().
		Return Round(100.0 * ($iCurValue - $iMin) / ($iMax - $iMin), 2)
	EndIf

EndFunc   ;==>SoundSetGet

;###############################################################################


; User Defined Functions


; The following error codes apply to all of the functions listed below:
;     1 - Invalid Mixer ID
;     2 - Invalid Component Type String
;     3 - Invalid Component Instance
;     4 - Invalid Control Type String
;     5 - Can't Open The Specified Mixer
;     6 - Mixer Doesn't Support The Specified Component Type
;     7 - Mixer Doesn't Have That Many Of The Specified Component Type
;     8 - Component Doesn't Support The Specified Control Type
;     9 - Can't Get The Current Setting
;     10 - Can't Change The Setting


; FUNCTION =====================================================================
;
; Name:             _SoundGet
; Description:      Gets the value of the requested control from the requested audio line.
; Syntax:           _SoundGet($iMixerID, $sComponentType, $iComponentInstance, $sControlType)
; Parameters:       $iMixerID - The ID of the mixer. The first and most common mixer ID is 0.
;                   $sComponentType - One of the following text strings. The values that
;                       AutoHotkey's version of this function defines are in parantheses.
;                       As you can see, they definitely missed a few options.
;                       - dUndefined
;                       - dDigital
;                       - dLine
;                       - dMonitor
;                       - dSpeakers    (Master, Speakers)
;                       - dHeadphones  (Headphones)
;                       - dTelephone
;                       - dWave
;                       - dVoice
;                       - sUndefined   (N/A)
;                       - sDigital     (Digital)
;                       - sLine        (Line)
;                       - sMicrophone  (Microphone)
;                       - sSynthesizer (Synth)
;                       - sCompactDisc (CD)
;                       - sTelephone   (Telephone)
;                       - sPCSpeaker   (PCSpeaker)
;                       - sWave        (Wave)
;                       - sAuxiliary   (Aux)
;                       - sAnalog      (Analog)
;                   $iComponentInstance - The instance of the component type to use.
;                       Instance numbers start at 1.
;                   $sControlType - One of the following text strings. The values that
;                       AutoHotkey's version of this function defines are in parantheses.
;                       As you can see, they missed a few options.
;                       - Custom
;                       - BooleanMeter
;                       - SignedMeter
;                       - PeakMeter
;                       - UnsignedMeter
;                       - Boolean
;                       - OnOff          (OnOff)
;                       - Mute           (Mute)
;                       - Mono           (Mono)
;                       - Loudness       (Loudness)
;                       - StereoEnh      (StereoEnh)
;                       - Button
;                       - Decibels
;                       - Signed
;                       - Unsigned
;                       - Percent
;                       - Slider
;                       - Pan            (Pan)
;                       - QSoundPan      (QSoundPan)
;                       - Fader
;                       - Volume         (Vol, Volume)
;                       - Bass           (Bass)
;                       - Treble         (Treble)
;                       - Equalizer      (Equalizer)
;                       - SingleSelect
;                       - Mux
;                       - MultipleSelect
;                       - Mixer
;                       - Microtime
;                       - Millitime
;                   $iNewParamValue - The value to set the control to. For boolean
;                       controls zero = Off and non-zero = On. For most other controls
;                       (such as volume) this is a percent ranging from 0 to 100.
; Return Values:    Success - Sets @error to 0 and returns the requested control value.
;                       Boolean controls return either 0 or 1.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGet($iMixerID, $sComponentType, $iComponentInstance, $sControlType)
	Local $iRet = SoundSetGet($iMixerID, $sComponentType, $iComponentInstance, $sControlType, False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGet

; FUNCTION =====================================================================
;
; Name:             _SoundSet
; Description:      Gets the value of the requested control from the requested audio line.
; Syntax:           _SoundSet($iMixerID, $sComponentType, $iComponentInstance, $sControlType, $iNewParamValue)
; Parameters:       $iMixerID - See _SoundGet above.
;                   $sComponentType - See _SoundGet above.
;                   $iComponentInstance - See _SoundGet above.
;                   $sControlType - See _SoundGet above.
;                   $iNewParamValue - The value to set the control to. For boolean
;                       controls zero = Off and non-zero = On. For most other controls
;                       (such as volume) this is a percent ranging from 0 to 100.
; Return Values:    Success - Sets @error to 0 and returns the value that the control
;                       was actually set to (setting volume to 110 would return 100).
;                       Boolean controls return either 0 or 1.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSet($iMixerID, $sComponentType, $iComponentInstance, $sControlType, $iNewParamValue)
	Local $iRet = SoundSetGet($iMixerID, $sComponentType, $iComponentInstance, $sControlType, True, $iNewParamValue)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSet




; FUNCTION =====================================================================
;
; Name:             _SoundGetMasterVolume
; Description:      Gets the current master playback volume level.
; Syntax:           _SoundGetMasterVolume()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the volume level.
;                       This is a percent value that ranges from 0 to 100.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetMasterVolume()
	Local $iRet = SoundSetGet(0, "dSpeakers", 1, "Volume", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetMasterVolume

; FUNCTION =====================================================================
;
; Name:             _SoundSetMasterVolume
; Description:      Sets the master playback volume level.
; Syntax:           _SoundSetMasterVolume($iVolume)
; Parameters:       $iVolume - The value to set the volume level to. This is a
;                       percent value that ranges from 0 to 100.
; Return Values:    Success - Sets @error to 0 and returns the volume level
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetMasterVolume($iVolume)
	Local $iRet = SoundSetGet(0, "dSpeakers", 1, "Volume", True, $iVolume)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetMasterVolume

; FUNCTION =====================================================================
;
; Name:             _SoundGetMasterMute
; Description:      Gets the current master playback mute status.
; Syntax:           _SoundGetMasterMute()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the mute status.
;                       0 = mute disabled, 1 = mute enabled.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetMasterMute()
	Local $iRet = SoundSetGet(0, "dSpeakers", 1, "Mute", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetMasterMute

; FUNCTION =====================================================================
;
; Name:             _SoundSetMasterMute
; Description:      Sets the master playback mute control.
; Syntax:           _SoundSetMasterMute($fMute)
; Parameters:       $iVolume - The value to set the mute control to.
;                       0 = disable mute, 1 = enable mute.
; Return Values:    Success - Sets @error to 0 and returns the mute status
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetMasterMute($fMute)
	Local $iRet = SoundSetGet(0, "dSpeakers", 1, "Mute", True, $fMute)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetMasterMute




; FUNCTION =====================================================================
;
; Name:             _SoundGetWaveVolume
; Description:      Gets the current wave playback volume level.
; Syntax:           _SoundGetWaveVolume()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the volume level.
;                       This is a percent value that ranges from 0 to 100.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetWaveVolume()
	Local $iRet = SoundSetGet(0, "sWave", 1, "Volume", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetWaveVolume

; FUNCTION =====================================================================
;
; Name:             _SoundSetWaveVolume
; Description:      Sets the wave playback volume level.
; Syntax:           _SoundSetWaveVolume($iVolume)
; Parameters:       $iVolume - The value to set the volume level to. This is a
;                       percent value that ranges from 0 to 100.
; Return Values:    Success - Sets @error to 0 and returns the volume level
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetWaveVolume($iVolume)
	Local $iRet = SoundSetGet(0, "sWave", 1, "Volume", True, $iVolume)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetWaveVolume

; FUNCTION =====================================================================
;
; Name:             _SoundGetWaveMute
; Description:      Gets the current wave playback mute status.
; Syntax:           _SoundGetWaveMute()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the mute status.
;                       0 = mute disabled, 1 = mute enabled.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetWaveMute()
	Local $iRet = SoundSetGet(0, "sWave", 1, "Mute", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetWaveMute

; FUNCTION =====================================================================
;
; Name:             _SoundSetWaveMute
; Description:      Sets the wave playback mute control.
; Syntax:           _SoundSetWaveMute($fMute)
; Parameters:       $iVolume - The value to set the mute control to.
;                       0 = disable mute, 1 = enable mute.
; Return Values:    Success - Sets @error to 0 and returns the mute status
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetWaveMute($fMute)
	Local $iRet = SoundSetGet(0, "sWave", 1, "Mute", True, $fMute)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetWaveMute





; FUNCTION =====================================================================
;
; Name:             _SoundGetCDVolume
; Description:      Gets the current CD playback volume level.
; Syntax:           _SoundGetCDVolume()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the volume level.
;                       This is a percent value that ranges from 0 to 100.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetCDVolume()
	Local $iRet = SoundSetGet(0, "sCompactDisc", 1, "Volume", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetCDVolume

; FUNCTION =====================================================================
;
; Name:             _SoundSetCDVolume
; Description:      Sets the CD playback volume level.
; Syntax:           _SoundSetCDVolume($iVolume)
; Parameters:       $iVolume - The value to set the volume level to. This is a
;                       percent value that ranges from 0 to 100.
; Return Values:    Success - Sets @error to 0 and returns the volume level
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetCDVolume($iVolume)
	Local $iRet = SoundSetGet(0, "sCompactDisc", 1, "Volume", True, $iVolume)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetCDVolume

; FUNCTION =====================================================================
;
; Name:             _SoundGetCDMute
; Description:      Gets the current CD playback mute status.
; Syntax:           _SoundGetCDMute()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the mute status.
;                       0 = mute disabled, 1 = mute enabled.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetCDMute()
	Local $iRet = SoundSetGet(0, "sCompactDisc", 1, "Mute", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetCDMute

; FUNCTION =====================================================================
;
; Name:             _SoundSetCDMute
; Description:      Sets the CD playback mute control.
; Syntax:           _SoundSetCDMute($fMute)
; Parameters:       $iVolume - The value to set the mute control to.
;                       0 = disable mute, 1 = enable mute.
; Return Values:    Success - Sets @error to 0 and returns the mute status
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetCDMute($fMute)
	Local $iRet = SoundSetGet(0, "sCompactDisc", 1, "Mute", True, $fMute)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetCDMute





; FUNCTION =====================================================================
;
; Name:             _SoundGetPhoneVolume
; Description:      Gets the current telephone/modem playback volume level.
; Syntax:           _SoundGetPhoneVolume()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the volume level.
;                       This is a percent value that ranges from 0 to 100.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetPhoneVolume()
	Local $iRet = SoundSetGet(0, "sTelephone", 1, "Volume", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetPhoneVolume

; FUNCTION =====================================================================
;
; Name:             _SoundSetPhoneVolume
; Description:      Sets the telephone/modem playback volume level.
; Syntax:           _SoundSetPhoneVolume($iVolume)
; Parameters:       $iVolume - The value to set the volume level to. This is a
;                       percent value that ranges from 0 to 100.
; Return Values:    Success - Sets @error to 0 and returns the volume level
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetPhoneVolume($iVolume)
	Local $iRet = SoundSetGet(0, "sTelephone", 1, "Volume", True, $iVolume)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetPhoneVolume

; FUNCTION =====================================================================
;
; Name:             _SoundGetPhoneMute
; Description:      Gets the current telephone/modem playback mute status.
; Syntax:           _SoundGetPhoneMute()
; Parameters:       None
; Return Values:    Success - Sets @error to 0 and returns the mute status.
;                       0 = mute disabled, 1 = mute enabled.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundGetPhoneMute()
	Local $iRet = SoundSetGet(0, "sTelephone", 1, "Mute", False, 0)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundGetPhoneMute

; FUNCTION =====================================================================
;
; Name:             _SoundSetPhoneMute
; Description:      Sets the telephone/modem playback mute control.
; Syntax:           _SoundSetPhoneMute($fMute)
; Parameters:       $iVolume - The value to set the mute control to.
;                       0 = disable mute, 1 = enable mute.
; Return Values:    Success - Sets @error to 0 and returns the mute status
;                       that the control was actually set to.
;                   Failure - Returns 0 and sets @error to one of the values
;                       listed at the beginning of this section.
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundSetPhoneMute($fMute)
	Local $iRet = SoundSetGet(0, "sTelephone", 1, "Mute", True, $fMute)
	SetError(@error) ; errors don't pass through without this
	Return $iRet
EndFunc   ;==>_SoundSetPhoneMute




; FUNCTION =====================================================================
;
; Name:             _SoundQuery
; Description:      Queries the sound system of the current computer and finds all
;                       of the controls that exist on the computer and that the
;                       _SoundGet and _SoundSet functions are capable of interacting
;                       with. This function brings up a list detailing the parameters
;                       needed to access each control as well as each control's
;                       current value.
; Syntax:           _SoundQuery()
; Parameters:       None
; Return Values:    None
; Author:           Austin Beer
; Modified:         4/15/08
; Remarks:          N/A
; Example:          Yes
;
; ==============================================================================
Func _SoundQuery()

	SplashTextOn("Processing", "Querying Sound System...", 400, 50, -1, -1, 48)
	
	GUICreate("SoundQuery Results", 400, 550) ; fits on an 800 x 600 screen, not that it probably matters
	Local $hListView = GUICtrlCreateListView("MixerID|ComponentType|CompInst|ControlType|Value", 10, 10, 380, 530, BitOR($LVS_REPORT, $LVS_NOSORTHEADER))

	; Loop through each mixer that exists.
	Local $iMixer = 0
	While True
		_SoundGet($iMixer, "dSpeakers", 1, "Volume")
		If @error = 5 Then
			; No more mixers exist. Any error other than this indicates that the mixer exists.
			ExitLoop
		EndIf

		; Check each possible component type in the current mixer.
		Local $iComponentType = 0
		While $iComponentType < UBound($asComponentTypes)
			_SoundGet($iMixer, $asComponentTypes[$iComponentType], 1, "Volume")
			If @error = 6 Then
				; This particular component type doesn't exist in this mixer.
				; Start a new iteration to move on to the next component type.
				$iComponentType = $iComponentType + 1
				ContinueLoop
			EndIf

			; Check each possible instance of the current component type.
			Local $iComponentInstance = 1
			While True
				_SoundGet($iMixer, $asComponentTypes[$iComponentType], $iComponentInstance, "Volume")
				If @error = 7 Then
					; No more instances of this component type exist.
					ExitLoop
				EndIf

				; Get the current setting of each control type that exists in this instance of this component.
				Local $iControlType = 0
				While $iControlType < UBound($asControlTypes)
					Local $iCurValue = _SoundGet($iMixer, $asComponentTypes[$iComponentType], $iComponentInstance, $asControlTypes[$iControlType])
					If @error Then
						$iControlType = $iControlType + 1
						ContinueLoop
					Else
						GUICtrlCreateListViewItem($iMixer & "|" & $asComponentTypes[$iComponentType] & "|" & $iComponentInstance & "|" & $asControlTypes[$iControlType] & "|" & $iCurValue, $hListView)
					EndIf
					$iControlType = $iControlType + 1
				WEnd ; For each control type.

				$iComponentInstance = $iComponentInstance + 1
			WEnd ; For each component instance.

			$iComponentType = $iComponentType + 1
		WEnd ; For each component type.

		$iMixer = $iMixer + 1
	WEnd ; For each mixer.
	
	SplashOff()
	
	GUISetState()

	Local $iMsg
	Do
		$iMsg = GUIGetMsg()
	Until $iMsg = $GUI_EVENT_CLOSE

EndFunc   ;==>_SoundQuery


;###############################################################################