#include <array.au3>

;======================
;Midi UDFs by Eynstyne
;See Example in Comments
;======================

Const $Callback_NULL = 0
Const $callback_Window = 0x10000 
Const $callback_thread = 0x20000 
Const $callback_function = 0x30000 
Const $callback_event = 0x50000 

Const $MMSYSERR_BASE = 0
Const $MMSYSERR_ALLOCATED = ($MMSYSERR_BASE + 4)
Const $MMSYSERR_BADDEVICEID = ($MMSYSERR_BASE + 2)
Const $MMSYSERR_BADERRNUM = ($MMSYSERR_BASE + 9)
Const $MMSYSERR_ERROR = ($MMSYSERR_BASE + 1)
Const $MMSYSERR_HANDLEBUSY = ($MMSYSERR_BASE + 12)
Const $MMSYSERR_INVALFLAG = ($MMSYSERR_BASE + 10)
Const $MMSYSERR_INVALHANDLE = ($MMSYSERR_BASE + 5)
Const $MMSYSERR_INVALIDALIAS = ($MMSYSERR_BASE + 13)
Const $MMSYSERR_INVALPARAM = ($MMSYSERR_BASE + 11)
Const $MMSYSERR_LASTERROR = ($MMSYSERR_BASE + 13)
Const $MMSYSERR_NODRIVER = ($MMSYSERR_BASE + 6)
Const $MMSYSERR_NOERROR = 0
Const $MMSYSERR_NOMEM = ($MMSYSERR_BASE + 7)
Const $MMSYSERR_NOTENABLED = ($MMSYSERR_BASE + 3)
Const $MMSYSERR_NOTSUPPORTED = ($MMSYSERR_BASE + 8)

Const $MIDI_CACHE_ALL = 1
Const $MIDI_CACHE_BESTFIT = 2
Const $MIDI_CACHE_QUERY = 3
Const $MIDI_CACHE_VALID = ($MIDI_CACHE_ALL Or $MIDI_CACHE_BESTFIT Or $MIDI_CACHE_QUERY Or $MIDI_UNCACHE)
Const $MIDI_IO_STATUS = 0x20
Const $MIDI_UNCACHE = 4
Const $MIDICAPS_CACHE = 0x4
Const $MIDICAPS_LRVOLUME = 0x20
Const $MIDICAPS_STREAM = 0x8
Const $MIDICAPS_VOLUME = 0x1
Const $MIDIERR_BASE = 64
Const $MIDIERR_INVALIDSETUP = ($MIDIERR_BASE + 5)
Const $MIDIERR_LASTERROR = ($MIDIERR_BASE + 5)
Const $MIDIERR_NODEVICE = ($MIDIERR_BASE + 4)
Const $MIDIERR_NOMAP = ($MIDIERR_BASE + 2)
Const $MIDIERR_NOTREADY = ($MIDIERR_BASE + 3)
Const $MIDIERR_STILLPLAYING = ($MIDIERR_BASE + 1)
Const $MIDIERR_UNPREPARED = ($MIDIERR_BASE + 0)
Const $MIDIMAPPER = -1
Const $MIDIPROP_GET = 0x40000000
Const $MIDIPROP_SET = 0x80000000
Const $MIDIPROP_TEMPO = 0x2
Const $MIDIPROP_TIMEDIV = 0x1
Const $MIDISTRM_ERROR = -2
Const $MM_MPU401_MIDIOUT = 10
Const $MM_MPU401_MIDIIN = 11
Const $MM_MIDI_MAPPER = 1
Const $MIDIPATCHSIZE = 128

Const $MM_MIM_CLOSE = 0x3c2
Const $MM_MIM_DATA = 0x3c3
Const $MM_MIM_ERROR = 0x3c5
Const $MM_MIM_LONGDATA = 0x3c4
Const $MM_MIM_LONGERROR = 0x3c6
Const $MM_MIM_MOREDATA = 0x3cc
Const $MM_MIM_OPEN = 0x3c1
Const $MM_MOM_CLOSE = 0x3c8
Const $MM_MOM_DONE = 0x3c9
Const $MM_MOM_OPEN = 0x3c7
Const $MM_MOM_POSITIONCB = 0x3ca

Const $MIM_CLOSE = ($MM_MIM_CLOSE)
Const $MIM_DATA = ($MM_MIM_DATA)
Const $MIM_ERROR = ($MM_MIM_ERROR)
Const $MIM_LONGDATA = ($MM_MIM_LONGDATA)
Const $MIM_LONGERROR = ($MM_MIM_LONGERROR)
Const $MIM_MOREDATA = ($MM_MIM_MOREDATA)
Const $MIM_OPEN = ($MM_MIM_OPEN)
Const $MOM_CLOSE = ($MM_MOM_CLOSE)
Const $MOM_DONE = ($MM_MOM_DONE)
Const $MOM_OPEN = ($MM_MOM_OPEN)
Const $MOM_POSITIONCB = ($MM_MOM_POSITIONCB)

;Midi Notes
;==========

Const $ABASS_OCTAVEDOWN16_NOTEON = 0x00401590;1
Const $ASHARPBASS_OCTAVEDOWN16_NOTEON = 0x00401690;2
Const $BBASS_OCTAVEDOWN16_NOTEON = 0x00401790;3
Const $CBASS_OCTAVEDOWN8_NOTEON = 0x00401890;4
Const $CSHARPBASS_OCTAVEDOWN8_NOTEON = 0x00401990;5
Const $DBASS_OCTAVEDOWN8_NOTEON = 0x00401A90;6
Const $DSHARPBASS_OCTAVEDOWN8_NOTEON = 0x00401B90;7
Const $EBASS_OCTAVEDOWN8_NOTEON = 0x00401C90;8
Const $FBASS_OCTAVEDOWN8_NOTEON = 0x00401D90;9
Const $FSHARPBASS_OCTAVEDOWN8_NOTEON = 0x00401E90;10
Const $GBASS_OCTAVEDOWN8_NOTEON = 0x00401F90;11
Const $GSHARPBASS_OCTAVEDOWN8_NOTEON = 0x00402090;12
Const $ABASS_OCTAVEDOWN8_NOTEON = 0x00402190;13
Const $ASHARPBASS_OCTAVEDOWN8_NOTEON = 0x00402290;14
Const $BBASS_OCTAVEDOWN_NOTEON = 0x00402390;15
Const $CBASS_OCTAVEDOWN_NOTEON = 0x00402490;16
Const $CSHARPBASS_OCTAVEDOWN_NOTEON = 0x00402590;17
Const $DBASS_OCTAVEDOWN_NOTEON = 0x00402690;18
Const $DSHARPBASS_OCTAVEDOWN_NOTEON = 0x00402790;19
Const $EBASS_OCTAVEDOWN_NOTEON = 0x00402890;20
Const $FBASS_OCTAVEDOWN_NOTEON = 0x00402990;21
Const $FSHARPBASS_OCTAVEDOWN_NOTEON = 0x00402A90;22
Const $GBASS_OCTAVEDOWN_NOTEON = 0x00402B90;23
Const $GSHARPBASS_OCTAVEDOWN_NOTEON = 0x00402C90;24
Const $ABASS_OCTAVEDOWN_NOTEON = 0x00402D90;25
Const $ASHARPBASS_OCTAVEDOWN_NOTEON = 0x00402E90;26
Const $BBASS_NOTEON = 0x00402F90;27
Const $CBASS_NOTEON = 0x00403090;28
Const $CSHARPBASS_NOTEON = 0x00403190;29
Const $DBASS_NOTEON = 0x00403290;30
Const $DSHARPBASS_NOTEON = 0x00403390;31
Const $EBASS_NOTEON = 0x00403490;32
Const $FBASS_NOTEON = 0x00403590;33
Const $FSHARPBASS_NOTEON = 0x00403690;34
Const $GBASS_NOTEON = 0x00403790;35
Const $GSHARPBASS_NOTEON = 0x00403890;36
Const $ABASS_NOTEON = 0x00403990;37
Const $ASHARPBASS_NOTEON = 0x00403A90;38
Const $B_NOTEON = 0x00403B90;39
Const $C_NOTEON = 0x00403C90;40 - Middle C
Const $CSHARP_NOTEON = 0x00403D90;41
Const $D_NOTEON = 0x00403E90;42
Const $DSHARP_NOTEON = 0x00403F90;43
Const $E_NOTEON = 0x00404090;44
Const $F_NOTEON = 0x00404190;45
Const $FSHARP_NOTEON = 0x00404290;46
Const $G_NOTEON = 0x00404390;47
Const $GSHARP_NOTEON = 0x00404490;48
Const $A_NOTEON = 0x00404590;49
Const $ASHARP_NOTEON = 0x00404690;50
Const $B_OCTAVE_NOTEON = 0x00404790;51
Const $C_OCTAVEUP_NOTEON = 0x00404890;52
Const $CSHARP_OCTAVEUP_NOTEON = 0x00404990;53
Const $D_OCTAVEUP_NOTEON = 0x00404A90;54
Const $DSHARP_OCTAVEUP_NOTEON = 0x00404B90;55
Const $E_OCTAVEUP_NOTEON = 0x00404C90;56
Const $F_OCTAVEUP_NOTEON = 0x00404D90;57
Const $FSHARP_OCTAVEUP_NOTEON = 0x00404E90;58
Const $G_OCTAVEUP_NOTEON = 0x00404F90;59
Const $GSHARP_OCTAVEUP_NOTEON = 0x00405090;60
Const $A_OCTAVEUP_NOTEON = 0x00405190;61
Const $ASHARP_OCTAVEUP_NOTEON = 0x00405290;62
Const $B_OCTAVEUP_NOTEON = 0x00405390;63
Const $C_OCTAVEUP8_NOTEON = 0x00405490;64
Const $CSHARP_OCTAVEUP8_NOTEON = 0x00405590;65
Const $D_OCTAVEUP8_NOTEON = 0x00405690;66
Const $DSHARP_OCTAVEUP8_NOTEON = 0x00405790;67
Const $E_OCTAVEUP8_NOTEON = 0x00405890;68
Const $F_OCTAVEUP8_NOTEON = 0x00405990;69
Const $FSHARP_OCTAVEUP8_NOTEON = 0x00405A90;70
Const $G_OCTAVEUP8_NOTEON = 0x00405B90;71
Const $GSHARP_OCTAVEUP8_NOTEON = 0x00405C90;72
Const $A_OCTAVEUP8_NOTEON = 0x00405D90;73
Const $ASHARP_OCTAVEUP8_NOTEON = 0x00405E90;74
Const $B_OCTAVEUP8_NOTEON = 0x00405F90;75
Const $C_OCTAVEUP16_NOTEON = 0x00406090;76
Const $CSHARP_OCTAVEUP16_NOTEON = 0x00406190;77
Const $D_OCTAVEUP16_NOTEON = 0x00406290;78
Const $DSHARP_OCTAVEUP16_NOTEON = 0x00406390;79
Const $E_OCTAVEUP16_NOTEON = 0x00406490;80
Const $F_OCTAVEUP16_NOTEON = 0x00406590;81
Const $FSHARP_OCTAVEUP16_NOTEON = 0x00406690; 82
Const $G_OCTAVEUP16_NOTEON = 0x00406790; 83
Const $GSHARP_OCTAVEUP16_NOTEON = 0x00406890; 84
Const $A_OCTAVEUP16_NOTEON = 0x00406990 ;85
Const $ASHARP_OCTAVEUP16_NOTEON = 0x00406A90 ;86
Const $B_OCTAVEUP16_NOTEON = 0x00406B90 ;87
Const $C_OCTAVEUP32_NOTEON = 0x00406C90 ;88

;Turn Off the Notes

Const $ABASS_OCTAVEDOWN16_NOTEOFF = 0x00001590;1
Const $ASHARPBASS_OCTAVEDOWN16_NOTEOFF = 0x00001690;2
Const $BBASS_OCTAVEDOWN16_NOTEOFF = 0x00001790;3
Const $CBASS_OCTAVEDOWN8_NOTEOFF = 0x00001890;4
Const $CSHARPBASS_OCTAVEDOWN8_NOTEOFF = 0x00001990;5
Const $DBASS_OCTAVEDOWN8_NOTEOFF = 0x00001A90;6
Const $DSHARPBASS_OCTAVEDOWN8_NOTEOFF = 0x00001B90;7
Const $EBASS_OCTAVEDOWN8_NOTEOFF = 0x00001C90;8
Const $FBASS_OCTAVEDOWN8_NOTEOFF = 0x00001D90;9
Const $FSHARPBASS_OCTAVEDOWN8_NOTEOFF = 0x00001E90;10
Const $GBASS_OCTAVEDOWN8_NOTEOFF = 0x00001F90;11
Const $GSHARPBASS_OCTAVEDOWN8_NOTEOFF = 0x00002090;12
Const $ABASS_OCTAVEDOWN8_NOTEOFF = 0x00002190;13
Const $ASHARPBASS_OCTAVEDOWN8_NOTEOFF = 0x00002290;14
Const $BBASS_OCTAVEDOWN_NOTEOFF = 0x00002390;15
Const $CBASS_OCTAVEDOWN_NOTEOFF = 0x00002490;16
Const $CSHARPBASS_OCTAVEDOWN_NOTEOFF = 0x00002590;17
Const $DBASS_OCTAVEDOWN_NOTEOFF = 0x00002690;18
Const $DSHARPBASS_OCTAVEDOWN_NOTEOFF = 0x00002790;19
Const $EBASS_OCTAVEDOWN_NOTEOFF = 0x00002890;20
Const $FBASS_OCTAVEDOWN_NOTEOFF = 0x00002990;21
Const $FSHARPBASS_OCTAVEDOWN_NOTEOFF = 0x00002A90;22
Const $GBASS_OCTAVEDOWN_NOTEOFF = 0x00002B90;23
Const $GSHARPBASS_OCTAVEDOWN_NOTEOFF = 0x00002C90;24
Const $ABASS_OCTAVEDOWN_NOTEOFF = 0x00002D90;25
Const $ASHARPBASS_OCTAVEDOWN_NOTEOFF = 0x00002E90;26
Const $BBASS_NOTEOFF = 0x00002F90;27
Const $CBASS_NOTEOFF = 0x00003090;28
Const $CSHARPBASS_NOTEOFF = 0x00003190;29
Const $DBASS_NOTEOFF = 0x00003290;30
Const $DSHARPBASS_NOTEOFF = 0x00003390;31
Const $EBASS_NOTEOFF = 0x00003490;32
Const $FBASS_NOTEOFF = 0x00003590;33
Const $FSHARPBASS_NOTEOFF = 0x00003690;34
Const $GBASS_NOTEOFF = 0x00003790;35
Const $GSHARPBASS_NOTEOFF = 0x00003890;36
Const $ABASS_NOTEOFF = 0x00003990;37
Const $ASHARPBASS_NOTEOFF = 0x00003A90;38
Const $B_NOTEOFF = 0x00003B90;39
Const $C_NOTEOFF = 0x00003C90;00 - Middle C
Const $CSHARP_NOTEOFF = 0x00003D90;41
Const $D_NOTEOFF = 0x00003E90;42
Const $DSHARP_NOTEOFF = 0x00003F90;43
Const $E_NOTEOFF = 0x00000090;44
Const $F_NOTEOFF = 0x00004190;45
Const $FSHARP_NOTEOFF = 0x00004290;46
Const $G_NOTEOFF = 0x00004390;47
Const $GSHARP_NOTEOFF = 0x00004490;48
Const $A_NOTEOFF = 0x00004590;49
Const $ASHARP_NOTEOFF = 0x00004690;50
Const $B_OCTAVE_NOTEOFF = 0x00004790;51
Const $C_OCTAVEUP_NOTEOFF = 0x00004890;52
Const $CSHARP_OCTAVEUP_NOTEOFF = 0x00004990;53
Const $D_OCTAVEUP_NOTEOFF = 0x00004A90;54
Const $DSHARP_OCTAVEUP_NOTEOFF = 0x00004B90;55
Const $E_OCTAVEUP_NOTEOFF = 0x00004C90;56
Const $F_OCTAVEUP_NOTEOFF = 0x00004D90;57
Const $FSHARP_OCTAVEUP_NOTEOFF = 0x00004E90;58
Const $G_OCTAVEUP_NOTEOFF = 0x00004F90;59
Const $GSHARP_OCTAVEUP_NOTEOFF = 0x00005090;60
Const $A_OCTAVEUP_NOTEOFF = 0x00005190;61
Const $ASHARP_OCTAVEUP_NOTEOFF = 0x00005290;62
Const $B_OCTAVEUP_NOTEOFF = 0x00005390;63
Const $C_OCTAVEUP8_NOTEOFF = 0x00005490;64
Const $CSHARP_OCTAVEUP8_NOTEOFF = 0x00005590;65
Const $D_OCTAVEUP8_NOTEOFF = 0x00005690;66
Const $DSHARP_OCTAVEUP8_NOTEOFF = 0x00005790;67
Const $E_OCTAVEUP8_NOTEOFF = 0x00005890;68
Const $F_OCTAVEUP8_NOTEOFF = 0x00005990;69
Const $FSHARP_OCTAVEUP8_NOTEOFF = 0x00005A90;70
Const $G_OCTAVEUP8_NOTEOFF = 0x00005B90;71
Const $GSHARP_OCTAVEUP8_NOTEOFF = 0x00005C90;72
Const $A_OCTAVEUP8_NOTEOFF = 0x00005D90;73
Const $ASHARP_OCTAVEUP8_NOTEOFF = 0x00005E90;74
Const $B_OCTAVEUP8_NOTEOFF = 0x00005F90;75
Const $C_OCTAVEUP16_NOTEOFF = 0x00006090;76
Const $CSHARP_OCTAVEUP16_NOTEOFF = 0x00006190;77
Const $D_OCTAVEUP16_NOTEOFF = 0x00006290;78
Const $DSHARP_OCTAVEUP16_NOTEOFF = 0x00006390;79
Const $E_OCTAVEUP16_NOTEOFF = 0x00006490;80
Const $F_OCTAVEUP16_NOTEOFF = 0x00006590;81
Const $FSHARP_OCTAVEUP16_NOTEOFF = 0x00006690; 82
Const $G_OCTAVEUP16_NOTEOFF = 0x00006790; 83
Const $GSHARP_OCTAVEUP16_NOTEOFF = 0x00006890; 84
Const $A_OCTAVEUP16_NOTEOFF = 0x00006990 ;85
Const $ASHARP_OCTAVEUP16_NOTEOFF = 0x00006A90 ;86
Const $B_OCTAVEUP16_NOTEOFF = 0x00006B90 ;87
Const $C_OCTAVEUP32_NOTEOFF = 0x00006C90 ;88

;Instruments
#cs
Grand Piano;0
Bright Piano;1
Electric Grand Piano;2 	
Honky-Tonk Piano;3
Electric piano 1; 4	
Electric Piano 2; 5	
Harpsichord; 	6
Clavinet; 	7
Celesta; 	8
Glockenspiel; 	9
Music Box; 	10
Vibraphone; 	11
Marimba; 	12
Xylophone; 	13
Tubular bells; 	14
Dulcimer; 	15
Drawbar Organ; 	16
Percussive Organ;	17
Rock Organ; 	18
Church Organ; 	19
Reed Organ; 	20
Accordion; 	21
Harmonica; 	22
Tango Accordion; 	23
Nylon String Guitar; 	24
Steel String Guitar; 	25
Jazz Guitar; 	26
Clean Electric Guitar; 	27
Muted Electric Guitar; 	28
Overdrive Guitar; 	29
Distortion Guitar; 	30
Guitar Harmonics; 	31
Accoustic Bass;  	32
Fingered Bass; 	33
Picked Bass; 	34
Fretless Bass; 	35
Slap Bass 1; 	36
Slap Bass 2;	37
Synth Bass 1;	38
Synth Bass 2;	39
Violin; 	40
Viola; 	41
Cello; 	42
Contrabass; 	43
Tremolo Strings; 	44
Pizzicato Strings; 45
Orchestral Harp; 	46
Timpani; 	47
String Ensemble 1; 	48
String Ensemble 2; 49
Synth Strings 1; 	50
Synth Strings 2; 	51
Choir ahh; 	52
Choir oohh; 	53
Synth Voice; 	54
Orchestral Hit; 	55
Trumpet; 	56
Trombone; 57
Tuba;	58
Muted Trumpet; 	59
French Horn; 	60
Brass Section; 	61
Synth Brass 1; 	62
Synth Brass 2; 	63
Soprano Sax;  	 64
Alto Sax; 	65
Tenor Sax; 	66
Baritone Sax; 	67
Oboe; 	68
English Horn; 	69
Bassoon; 	70
Clarinet; 	71
Piccolo; 	72
Flute; 	73
Recorder; 	74
Pan flute; 	75
Blown Bottle; 	76
Shakuhachi; 	77
Whistle; 	78
Ocarina; 	79
Square Wave; 	80
Sawtooth Wave; 	81
Caliope;	82
Chiff; 	83
Charang; 	84
Voice; 	85
Fifths; 	86
Bass & Lead; 	87
New Age; 	88
Warm; 	89
PolySynth; 	90
Choir; 	91
Bowed; 	92
Metallic; 93
Halo; 	94
Sweep; 	95
FX: Rain;96
FX: Soundtrack;97
FX: Crystal;98
FX: Atmosphere;99
FX: Brightness;100
FX: Goblins;101
FX: Echo Drops;102
FX: Star Theme;103
Sitar;104
Banjo;105
Shamisen;106
Koto;107
Kalimba;108
Bagpipe;109
Fiddle;110
Shanai;111
Tinkle bell;112
Agogo;113
Steel Drums;114
Woodblock;115
Taiko Drum;116
Melodic Tom;117
Synth Drum;118
Reverse Cymbal;119
Guitar Fret Noise;120
Breath Noise;121
Seashore;122
Bird Tweet;123
Telephone Ring;124
Helicopter;125
Applause;126
Gunshot;127

Drums
=====
Range from 27 - 87
#ce


;THE FOLLOWING IS AN EXAMPLE ON HOW TO USE THE CONSTANTS...
;PIECE - 12 VARIATIONS (K.265,Ah! vous dirai-je maman) THEME
;Composer : Wolfgang Amadeus Mozart
;Resequenced by Eynstyne

$open = _midiOutOpen()

for $i = 27 to 87
	_MidiOutShortMsg($open,0x99 + ($i * 256) + (127 * 0x10000)) ; Drums Bitch!
	sleep(200)
	Next
FOR $I = 1 TO 2
_MidiOutShortMsg($open,256 * 16 + 192)
$msg = _midioutshortmsg($open,$C_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$CBASS_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$C_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$E_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$A_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$F_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$A_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$E_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$D_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$B_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$A_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$FBASS_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$GBASS_NOTEON)
sleep(300)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
sleep(175)
$msg = _midioutshortmsg($open,$C_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$CBASS_NOTEON)
sleep(1000)
$msg = _midioutshortmsg($open,$CBASS_NOTEOFF)
NEXT

$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$E_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$GBASS_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$D_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$GBASS_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$GBASS_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$B_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$G_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$E_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$G_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$D_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$G_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(400)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)

sleep(50)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
sleep(50)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
sleep(50)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
sleep(250)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$D_NOTEON)
sleep(150)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
$msg = _midioutshortmsg($open,$GBASS_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$B_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$C_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$CBASS_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$C_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$E_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$A_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$F_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$A_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$E_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$G_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$D_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$F_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$B_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$C_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$A_NOTEON)
sleep(500)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$FBASS_NOTEON)
sleep(400)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
sleep(50)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
sleep(50)
$msg = _midioutshortmsg($open,$C_OCTAVEUP_NOTEON)
sleep(50)
$msg = _midioutshortmsg($open,$D_OCTAVEUP_NOTEON)
sleep(250)
$msg = _midioutshortmsg($open,$E_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$GBASS_NOTEON)
sleep(150)
$msg = _midioutshortmsg($open,$C_OCTAVEUP_NOTEON)
$msg = _midioutshortmsg($open,$CBASS_NOTEON)
sleep(1000)
_MidiOutClose($open)

;=======================================================
;Retrieves the number of Midi Output devices which exist
;Parameters - None
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

Func _midiOutGetNumDevs()
	$ret = Dllcall("winmm.dll","long","midiOutGetNumDevs")
	if not @error then Return $ret[0]
	EndFunc
	
;=======================================================
;Retrieves the number of Midi Input devices which exist
;Parameters - None
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

	Func _midiInGetNumDevs($ReturnErrorAsString=0) ;Working
	$ret = Dllcall("winmm.dll","long","midiInGetNumDevs")
	if not @error then Return $ret[0]
	EndFunc

;=======================================================
;Retrieves a MIDI handle and Opens the Device
;Parameters(Optional) - Device ID, Window Callback,
; instance, flags
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

Func _midiOutOpen($devid=0,$callback=0,$instance=0,$flags=0)

	$struct = DllStructCreate("udword")

	 $ret = Dllcall("winmm.dll","long","midiOutOpen","ptr",DllStructGetPtr($struct),"int",$devid,"long",$callback,"long",$instance,"long",$flags)
	  if not @error Then
		   $Get = Dllstructgetdata($struct,1)
		   Return $get
		   else
		    Return $ret[0]
	   EndIf	  
   EndFunc
 
;=======================================================
;Retrieves a MIDI handle and Opens the Device
;Parameters(Optional) - Device ID, Window Callback,
; instance, flags
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

  Func _midiInOpen($devid=0,$callback=0,$instance=0,$flags=0) 

	$struct = DllStructCreate("udword")
	 
	 $ret = Dllcall("winmm.dll","long","midiInOpen","ptr",DllStructGetPtr($struct),"int",$devid,"long",$callback,"long",$instance,"long",$flags)
	  if not @error Then
		   $Get = Dllstructgetdata($struct,1)
		   Return $get
		else
		   Return $ret[0]
	   EndIf	  
   EndFunc
   
;=======================================================
;Sets the Mixer Volume for MIDI
;Parameters - Volume (0 - 65535)
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

   Func _MidiOutSetVolume($volume,$devid=0)
   $ret = Dllcall("winmm.dll","long","midiOutSetVolume","long",$devid,"int",$volume)
   if not @error Then Return $ret[0]
   EndFunc
   
;=======================================================
;Gets the Mixer Volume for MIDI
;Parameters - None
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

   Func _MidiOutGetVolume($devid=0)
	   $struct = Dllstructcreate("ushort")
	   $ret = Dllcall("winmm.dll","long","midiOutGetVolume","long",$devid,"ptr",DllStructGetPtr($struct))
 if not @error Then
	 $get = Dllstructgetdata($struct,1)
	 Return $get
 EndIf
 EndFunc
 
;=======================================================
;Resets MIDI Output/Input
;Parameters - MidiHandle
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

 Func _MidiOutReset($hmidiout)
	 $ret = Dllcall("winmm.dll","long","midiOutReset","long",$hmidiout)
   if not @error Then Return $ret[0]
   EndFunc
  
   Func _MidiInReset($hmidiin)
	 $ret = Dllcall("winmm.dll","long","midiInReset","long",$hmidiin)
   if not @error Then Return $ret[0]
   EndFunc
;=======================================================
;Starts Midi Input
;Parameters - MidiHandle
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

    Func _MidiInStart($hmidiIn)
	 $ret = Dllcall("winmm.dll","long","midiInStart","long",$hmidiIn)
   if not @error Then Return $ret[0]
   EndFunc
   
;=======================================================
;Stops Midi Input
;Parameters - MidiHandle
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

   Func _MidiInStop($hmidiIn)
	 $ret = Dllcall("winmm.dll","long","midiInStop","long",$hmidiIn)
   if not @error Then Return $ret[0]
 EndFunc
 
;=======================================================
;Closes Midi Output/Input devices
;Parameters - MidiHandle
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================
 Func _MidiOutClose($hmidiout)
	 $ret = Dllcall("winmm.dll","long","midiOutClose","long",$hmidiout)
   if not @error Then Return $ret[0]
   EndFunc

    Func _MidiInClose($hmidiIn)
	 $ret = Dllcall("winmm.dll","long","midiInClose","long",$hmidiIn)
   if not @error Then Return $ret[0]
 EndFunc
   
;=======================================================
;Cache Drum Patches for Output
;Parameters - MidiHandle,Patch,Keynumber,Flag
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================  

   Func _MidiOutCacheDrumPatches($Hmidiout,$Patch,$keynumber,$flags=0)
	  $struct = Dllstructcreate("short")
	  $keyarray = _ArrayCreate($keynumber)
	  DllStructSetData($struct,1,$keynumber)
	  
	  $ret = Dllcall("winmm.dll","long","midiOutCacheDrumPatches","long",$hmidiout,"int",$patch,"ptr",dllstructgetptr($struct),"int",$flags)
   if not @error Then return $ret[0]

   EndFunc

;=======================================================
;Caches MIDI Patches
;Parameters - MidiHandle, Bank, PatchNumber, Flags
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

 Func _MidiOutCachePatches($hmidiout,$bank,$patchnumber,$flags=0)
	 $struct = Dllstructcreate("short")
	 $patcharray = _ArrayCreate($patchnumber)
	 Dllstructsetdata($struct,1,$patchnumber)
	 
	 $ret = Dllcall("winmm.dll","long","midiOutCachePatches","long",$hmidiout,"int",$bank,"ptr",dllstructgetptr($struct),"int",$flags)
	 if not @error then return $ret[0]
	 EndFunc
	 
	 
;=======================================================
;Gets MIDI DeviceID
;Parameters - MidiHandle
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

   Func _MidiInGetID($Hmidiin)
	    $struct = Dllstructcreate("uint")
   $ret = Dllcall("winmm.dll","long","midiInGetID","long",$Hmidiin,"ptr",DllStructGetPtr($struct))
   
   if not @error Then
		$get = DllStructGetData($struct,1)
		 Return $get
	 EndIf
 EndFunc


   Func _MidiOutGetID($Hmidiout)
	    $struct = Dllstructcreate("uint")
   $ret = Dllcall("winmm.dll","long","midiInGetID","long",$Hmidiout,"ptr",DllStructGetPtr($struct))

   if not @error Then
		$get = DllStructGetData($struct,1)
		 Return $get
	 EndIf
 EndFunc
 
;=======================================================
;Translates Error codes into Plaintext
;Parameters - Error number
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

   Func _MidiInGetErrorText($error)
	   $struct = Dllstructcreate("char[128]")
	$ret = Dllcall("winmm.dll","long","midiInGetErrorText","int",$error,"ptr",DllStructGetPtr($struct),"int",999)
	$get = DllStructGetData($struct,1)
	msgbox(0,"",$get)
EndFunc

Func _MidiOutGetErrorText($error)
	   $struct = Dllstructcreate("char[128]")
	$ret = Dllcall("winmm.dll","long","midiOutGetErrorText","int",$error,"ptr",DllStructGetPtr($struct),"int",999)
	$get = DllStructGetData($struct,1)
	msgbox(0,"",$get)
EndFunc

;=======================================================
;MIDI Message Send Function
;Parameters - Message as Hexcode or Constant
;Author : Eynstyne
;Library : Microsoft winmm.dll
;=======================================================

Func _MidiOutShortMsg($hmidiout,$msg)
	$ret = Dllcall("winmm.dll","long","midiOutShortMsg","long",$Hmidiout,"long",$msg)
	 if not @error Then Return $ret[0]
	 EndFunc
	 
	Func _MidiOutLongMsg($hmidiout,$data,$bufferlength,$bytesrecorded,$user,$flags,$next,$getmmsyserr=0)
	$struct = dllstructcreate("char[128];udword;udword;udword;udword;ushort;ushort")
	dllstructsetdata($struct,1,$data)
	dllstructsetdata($struct,2,$bufferlength)
	dllstructsetdata($struct,3,$bytesrecorded)
	dllstructsetdata($struct,4,$user)
	dllstructsetdata($struct,5,$flags)
	dllstructsetdata($struct,6,$next)
	dllstructsetdata($struct,7,0)
	
	$ret = DllCall("winmm.dll","long","midiInPrepareHeader","long",$hmidiout,"ptr",Dllstructgetptr($struct),"long",999)
	if not @error Then
		if $getmmsyserr = 1 Then
			return $ret[0]
			Elseif $getmmsyserr <> 1 then
		$array = _ArrayCreate($hmidiout,DllStructGetData($struct,1),DllStructGetData($struct,2),DllStructGetData($struct,3),DllStructGetData($struct,4),DllStructGetData($struct,5),DllStructGetData($struct,6),DllStructGetData($struct,7))
		return $array
	endif
EndIf

EndFunc 

;=======================================================
;Get the Capabilities of the MIDI Device
;Parameters - DeviceID
;Author : Eynstyne
;Library : Microsoft winmm.dll
;First Value - Manufacturer ID
;Second Value - Product ID
;Third Value - Driver Version
;Fourth Value - Driver Name
;Fifth Value - Type of Device
;Sixth Value - Voices
;Seventh Value - Notes
;eighth Value - Channel Mask
;Ninth Value - Capabilities
;=======================================================

Func _MidiOutGetDevCaps($deviceid=0,$getmmsyserr=0)
	$struct = DllStructCreate("ushort;ushort;uint;char[128];ushort;ushort;ushort;ushort;uint")
	$ret = Dllcall("winmm.dll","long","midiOutGetDevCapsA","long",$deviceid,"ptr",Dllstructgetptr($struct),"int",999)
	if not @error Then
		if $getmmsyserr = 1 Then
			Return $ret[0]
			elseif $getmmsyserr <> 1 then
		$array = _ArrayCreate(DllStructGetData($struct,1),DllStructGetData($struct,2),DllStructGetData($struct,3),DllStructGetData($struct,4),DllStructGetData($struct,5),DllStructGetData($struct,6),DllStructGetData($struct,7),DllStructGetData($struct,8),DllStructGetData($struct,9))
		return $array
	EndIf
	endif
EndFunc

;=======================================================
;Get the Capabilities of the MIDI Device Input
;Parameters - DeviceID
;Author : Eynstyne
;Library : Microsoft winmm.dll
;First Value - Manufacturer ID
;Second Value - Product ID
;Third Value - Driver Version
;Fourth Value - Driver Name
;=======================================================

Func _MidiInGetDevCaps($deviceid=0,$getmmsyserr=0)
	$struct = DllStructCreate("ushort;ushort;uint;char[128]")
	$ret = Dllcall("winmm.dll","long","midiInGetDevCapsA","long",$deviceid,"ptr",Dllstructgetptr($struct),"int",999)
	if not @error Then
		if $getmmsyserr = 1 Then
			Return $ret[0]
			elseif $getmmsyserr <> 1 Then
		$array = _ArrayCreate(DllStructGetData($struct,1),DllStructGetData($struct,2),DllStructGetData($struct,3),DllStructGetData($struct,4))
		return $array
	EndIf
	endif
EndFunc

;========================================================
;Connect/Disconnect the MIDI Device to Application Source
; / Dest.
;Parameters - MidiHandleIn, MidiHandleOut
;Author: Eynstyne
;Library : Microsoft winmm.dll
;========================================================

Func _MidiConnect($Hmidiin,$hmidiout)
	$ret = Dllcall("winmm.dll","long","midiConnect","long",$hmidiin,"long",$hmidiout,"int",0)
	if not @error Then Return $ret[0]
	EndFunc

Func _MidiDisconnect($Hmidiin,$hmidiout)
	$ret = Dllcall("winmm.dll","long","midiDisconnect","long",$hmidiin,"long",$hmidiout,"int",0)
	if not @error Then Return $ret[0]
	EndFunc

;========================================================
;Prepare/Unprepare the MIDI header
;Parameters - MidiInHandle,Data,Bufferlength,
; BytesRecorded,User,Flags,Next,Getmmsystemerror
;Author:Eynstyne
;Library:Microsoft winmm.dll
;========================================================

	Func _MidiInPrepareHeader($hmidiin,$data,$bufferlength,$bytesrecorded,$user,$flags,$next,$getmmsyserr=0)
	$struct = dllstructcreate("char[128];udword;udword;udword;udword;ushort;ushort")
	dllstructsetdata($struct,1,$data)
	dllstructsetdata($struct,2,$bufferlength)
	dllstructsetdata($struct,3,$bytesrecorded)
	dllstructsetdata($struct,4,$user)
	dllstructsetdata($struct,5,$flags)
	dllstructsetdata($struct,6,$next)
	dllstructsetdata($struct,7,0)
	
	$ret = DllCall("winmm.dll","long","midiInPrepareHeader","long",$hmidiin,"ptr",Dllstructgetptr($struct),"long",999)
	if not @error Then
		if $getmmsyserr = 1 Then
			return $ret[0]
			Elseif $getmmsyserr <> 1 then
		$array = _ArrayCreate($hmidiin,DllStructGetData($struct,1),DllStructGetData($struct,2),DllStructGetData($struct,3),DllStructGetData($struct,4),DllStructGetData($struct,5),DllStructGetData($struct,6),DllStructGetData($struct,7))
		return $array
	endif
EndIf

EndFunc

    Func _MidiInUnprepareHeader($hmidiin,$data,$bufferlength,$bytesrecorded,$user,$flags,$next,$getmmsyserr=0)
$struct = dllstructcreate("char[128];udword;udword;udword;udword;ushort;ushort")
	dllstructsetdata($struct,1,$data)
	dllstructsetdata($struct,2,$bufferlength)
	dllstructsetdata($struct,3,$bytesrecorded)
	dllstructsetdata($struct,4,$user)
	dllstructsetdata($struct,5,$flags)
	dllstructsetdata($struct,6,$next)
	dllstructsetdata($struct,7,0)
$ret = DllCall("winmm.dll","long","midiInUnprepareHeader","long",$hmidiin,"ptr",Dllstructgetptr($struct),"long",999)
	if not @error Then
		if $getmmsyserr = 1 Then
			return $ret[0]
			Elseif $getmmsyserr <> 1 then
		$array = _ArrayCreate($hmidiin,DllStructGetData($struct,1),DllStructGetData($struct,2),DllStructGetData($struct,3),DllStructGetData($struct,4),DllStructGetData($struct,5),DllStructGetData($struct,6),DllStructGetData($struct,7))
		return $array
	endif
EndIf

EndFunc
	
;========================================================
;Add buffer to Midi Header
;Parameters - MidiInHandle,Data,Bufferlength,
; BytesRecorded,User,Flags,Next,Getmmsystemerror
;Author:Eynstyne
;Library:Microsoft winmm.dll
;========================================================

	Func _MidiInAddBuffer($hmidiin,$data,$bufferlength,$bytesrecorded,$user,$flags,$next,$getmmsyserr=0)
	$struct = dllstructcreate("char[128];udword;udword;udword;udword;ushort;ushort")
	dllstructsetdata($struct,1,$data)
	dllstructsetdata($struct,2,$bufferlength)
	dllstructsetdata($struct,3,$bytesrecorded)
	dllstructsetdata($struct,4,$user)
	dllstructsetdata($struct,5,$flags)
	dllstructsetdata($struct,6,$next)
	dllstructsetdata($struct,7,0)
	
	$ret = DllCall("winmm.dll","long","midiInAddBuffer","long",$hmidiin,"ptr",Dllstructgetptr($struct),"long",999)
	if not @error Then
		if $getmmsyserr = 1 Then
			return $ret[0]
			Elseif $getmmsyserr <> 1 then
		$array = _ArrayCreate($hmidiin,DllStructGetData($struct,1),DllStructGetData($struct,2),DllStructGetData($struct,3),DllStructGetData($struct,4),DllStructGetData($struct,5),DllStructGetData($struct,6),DllStructGetData($struct,7))
		return $array
	endif
	endif
EndFunc

;========================================================
;Sends Internal MIDI Info to Input / Output device
;Parameters - MidiInHandle,message, parameter1, parameter2
;Author:Eynstyne
;Library:Microsoft winmm.dll
;========================================================

Func _MidiInMessage($hmidiin,$msg,$dw1=0,$dw2=0)
	$ret = Dllcall("winmm.dll","long","midiInMessage","long",$hmidiIn,"long",$msg,"long",$dw1,"long",$dw2)
	if not @error then Return $ret[0]
	EndFunc
	
Func _MidiOutMessage($hmidiout,$msg,$dw1=0,$dw2=0)
	$ret = Dllcall("winmm.dll","long","midiOutMessage","long",$hmidiout,"long",$msg,"long",$dw1,"long",$dw2)
	if not @error then Return $ret[0]
	EndFunc
	

;====================
;Stream Functions
;====================

Func _midiStreamClose($hmidiStream)
	$ret = Dllcall("winmm.dll","long","midiStreamClose","long",$hmidiStream)
	if not @error then Return $ret[0]
	EndFunc
	
Func _midiStreamOpen($cMidi=0,$callback=0,$instance=0,$fdwopen=0,$getmmsyserr=0)
	$struct = Dllstructcreate("udword;uint")
	$ret = Dllcall("winmm.dll","long","midiStreamOpen","ptr",Dllstructgetptr($struct,1),"ptr",Dllstructgetptr($struct,2),"long",$cmidi,"long",$callback,"long",$instance,"long",$fdwopen)
	if not @error Then
		if $getmmsyserr = 1 Then
			Return $ret[0]
		elseif $getmmsyserr <> 1 Then
		$array = _ArrayCreate(DllStructGetData($struct,1),DllStructGetData($struct,2))
		return $array
	EndIf
EndIf
EndFunc

Func _midiStreamPause($hmidiStream)
	$ret = Dllcall("winmm.dll","long","midiStreamPause","long",$hmidiStream)
	if not @error then Return $ret[0]
	EndFunc
	
	
Func _midiStreamPos($hmidiStream,$cbmmt=0)
	$struct = dllstructcreate("ushort;ushort")
	$ret = Dllcall("winmm.dll","long","midiStreamPause","long",$hmidiStream,"ptr",Dllstructgetptr($struct),"long",$cbmmt)
	if not @error then 

		if $getmmsyserr = 1 Then
			Return $ret[0]
		elseif $getmmsyserr <> 1 Then
		$array = _ArrayCreate(DllStructGetData($struct,1),DllStructGetData($struct,2))
		return $array
	EndIf
EndIf
	EndFunc
		
	
	Func _midiStreamRestart($hmidiStream)
	$ret = Dllcall("winmm.dll","long","midiStreamRestart","long",$hmidiStream)
	if not @error then Return $ret[0]
	EndFunc
	
	Func _midiStreamStop($hmidiStream)
	$ret = Dllcall("winmm.dll","long","midiStreamStop","long",$hmidiStream)
	if not @error then Return $ret[0]
	EndFunc
	
	Func _midiStreamProperty($hmidiStream,$property=0,$getmmsyserr=0)
		$struct = DllStructCreate("byte")
		$ret = Dllcall("winmm.dll","long","midiStreamProperty","long",$hmidiStream,"ptr",Dllstructgetptr($struct),"long",$property)
		if not @error then 
		if $getmmsyserr = 1 Then
			Return $ret[0]
		elseif $getmmsyserr <> 1 Then
		$get = Dllstructgetdata($struct)
		return $get
	EndIf
EndIf
endfunc
	
	
	



	

