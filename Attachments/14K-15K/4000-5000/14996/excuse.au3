Global $reason, $because
Global $voice = ObjCreate("Sapi.SpVoice")


#region GUI
Global Const $GUI_EVENT_CLOSE = -3
GUICreate ( "Random Excuse Generator", 400, 100 )
GUISetState(@SW_SHOW)
$button = GUICtrlCreateButton ( "Create New Random Excuse", 10, 50 )
$close = GUICtrlCreateButton ( " Exit ", 160, 50, 52 )
$clipC = GUICtrlCreateButton ( "Copy to clipboard", 216, 50)
$voiceB = GUICtrlCreateButton (" Enable voice ", 310, 50)
$voiceEnabled = 0
$excuse = excuse()
$excuseh = GUICtrlCreateLabel ( $excuse , 10, 10 )
GUICtrlSetColor ($excuseh, 0x00FF00)
new()

GUISetState()

Do
$msg = GUIGetMsg()
If $msg = $button Then new()
If $msg = $clipC Then ClipPut ( $excuse )
If $msg = $voiceB Then
	If $voiceEnabled Then
		$voiceEnabled = 0
		GUICtrlSetData ($voiceB, " Enable voice ")
	Else
		$voiceEnabled = 1
		GUICtrlSetData ($voiceB, "Disable voice")
	EndIf
EndIf
Until $msg = $GUI_EVENT_CLOSE Or $msg = $close

Func randomize($type)
If $type = "v" Then
$excuse1 = Random (1, 100, 1)
Switch $excuse1
Case 1
$excuse1="eat"
Case 2
$excuse1="measure"
Case 3
$excuse1="attack"
Case 4
$excuse1="reply to"
Case 5
$excuse1="fire"
Case 6
$excuse1="infuriate"
Case 7
$excuse1="immobilize"
Case 8
$excuse1="rip"
Case 9
$excuse1="dry"
Case 10
$excuse1="call"
Case 11
$excuse1="run over"
Case 12
$excuse1="curse"
Case 13
$excuse1="break"
Case 14
$excuse1="smash"
Case 15
$excuse1="kiss"
Case 16
$excuse1="play with"
Case 17
$excuse1="plug in"
Case 18
$excuse1="paint"
Case 19
$excuse1="enlighten"
Case 20
$excuse1="burn"
Case 21
$excuse1="jump over"
Case 22
$excuse1="check on"
Case 23
$excuse1="catch"
Case 24
$excuse1="throw"
Case 25
$excuse1="wax"
Case 26
$excuse1="fix"
Case 27
$excuse1="avoid"
Case 28
$excuse1="smack"
Case 29
$excuse1="find"
Case 30
$excuse1="invest in"
Case 31
$excuse1="discuss"
Case 32
$excuse1="talk to"
Case 33
$excuse1="ignite"
Case 34
$excuse1="scold"
Case 35
$excuse1="congratulate"
Case 36
$excuse1="insult"
Case 37
$excuse1="study"
Case 38
$excuse1="ignore"
Case 39
$excuse1="elaborate on"
Case 40
$excuse1="sit on"
Case 41
$excuse1="feed"
Case 42
$excuse1="salt"
Case 43
$excuse1="fry"
Case 44
$excuse1="simplify"
Case 45
$excuse1="delete"
Case 46
$excuse1="bake"
Case 47
$excuse1="pay for"
Case 48
$excuse1="entertain"
Case 49
$excuse1="medicate"
Case 50
$excuse1="move"
Case 51
$excuse1="compute"
Case 52
$excuse1="destroy"
Case 53
$excuse1="discover"
Case 54
$excuse1="heat"
Case 55
$excuse1="freeze"
Case 56
$excuse1="liquify"
Case 57
$excuse1="shred"
Case 58
$excuse1="turn on"
Case 59
$excuse1="scratch"
Case 60
$excuse1="throw away"
Case 61
$excuse1="conquer"
Case 62
$excuse1="run over"
Case 63
$excuse1="blow up"
Case 64
$excuse1="banish"
Case 65
$excuse1="water"
Case 66
$excuse1="sharpen"
Case 67
$excuse1="perfect"
Case 68
$excuse1="argue with"
Case 69
$excuse1="cut off"
Case 70
$excuse1="pickle"
Case 71
$excuse1="tickle"
Case 72
$excuse1="sedate"
Case 73
$excuse1="KILL"
Case 74
$excuse1="annoy"
Case 75
$excuse1="redesign"
Case 76
$excuse1="design"
Case 77
$excuse1="brainstorm with"
Case 78
$excuse1="euthanize"
Case 79
$excuse1="maim"
Case 80
$excuse1="gouge"
Case 81
$excuse1="dine with"
Case 82
$excuse1="color"
Case 83
$excuse1="poke"
Case 84
$excuse1="solidify"
Case 85
$excuse1="evaporate"
Case 86
$excuse1="decorate"
Case 87
$excuse1="race"
Case 88
$excuse1="hypnotize"
Case 89
$excuse1="lie to"
Case 90
$excuse1="stare at"
Case 91
$excuse1="employ"
Case 92
$excuse1="sniff"
Case 93
$excuse1="barbecue"
Case 94
$excuse1="tilt"
Case 95
$excuse1="steady"
Case 96
$excuse1="knock out"
Case 97
$excuse1="hide"
Case 98
$excuse1="cover up"
Case 99
$excuse1="strech"
Case 100
$excuse1="fight"
EndSwitch

Return $excuse1

ElseIf $type = "adj" Then

$excuse2 = Random (1, 100, 1)

Switch $excuse2
Case 1
$excuse2="rusty"
Case 2
$excuse2="crusty"
Case 3
$excuse2="crazy"
Case 4
$excuse2="angry"
Case 5
$excuse2="entertaining"
Case 6
$excuse2="hot"
Case 7
$excuse2="mad"
Case 8
$excuse2="dying"
Case 9
$excuse2="criminal"
Case 10
$excuse2="deadly"
Case 11
$excuse2="broken"
Case 12
$excuse2="lost"
Case 13
$excuse2="metalic"
Case 14
$excuse2="sharp"
Case 15
$excuse2="blue"
Case 16
$excuse2="frozen"
Case 17
$excuse2="telepathic"
Case 18
$excuse2="run-away"
Case 19
$excuse2="educational"
Case 20
$excuse2="scientific"
Case 21
$excuse2="perfect"
Case 22
$excuse2="imperfect"
Case 23
$excuse2="odd looking"
Case 24
$excuse2="smelly"
Case 25
$excuse2="cute"
Case 26
$excuse2="simple"
Case 27
$excuse2="sharp"
Case 28
$excuse2="superior"
Case 29
$excuse2="heavy"
Case 30
$excuse2="odd"
Case 31
$excuse2="fluffy"
Case 32
$excuse2="pointless"
Case 33
$excuse2="yellow"
Case 34
$excuse2="green"
Case 35
$excuse2="red"
Case 36
$excuse2="purple"
Case 37
$excuse2="sad"
Case 38
$excuse2="compressed"
Case 39
$excuse2="sqaure"
Case 40
$excuse2="round"
Case 41
$excuse2="evaporating"
Case 42
$excuse2="artistic"
Case 43
$excuse2="thin"
Case 44
$excuse2="thick"
Case 45
$excuse2="tall"
Case 46
$excuse2="short"
Case 47
$excuse2="miniature"
Case 48
$excuse2="pathetic"
Case 49
$excuse2="strict"
Case 50
$excuse2="titanium"
Case 51
$excuse2="stupid"
Case 52
$excuse2="2 year old"
Case 53
$excuse2="squeaking"
Case 54
$excuse2="spinning"
Case 55
$excuse2="radioactive"
Case 56
$excuse2="adorable"
Case 57
$excuse2="darkly anticipated"
Case 58
$excuse2="edible"
Case 59
$excuse2="56 year old"
Case 60
$excuse2="newborn"
Case 61
$excuse2="oddly colored"
Case 62
$excuse2="stuffed"
Case 63
$excuse2="fake"
Case 64
$excuse2="rad"
Case 65
$excuse2="realistic"
Case 66
$excuse2="stationary"
Case 67
$excuse2="spherical"
Case 68
$excuse2="cubic"
Case 69
$excuse2="sensitive"
Case 70
$excuse2="infuriated"
Case 71
$excuse2="intricate"
Case 72
$excuse2="mental"
Case 73
$excuse2="quarterback"
Case 74
$excuse2="loud"
Case 75
$excuse2="quiet"
Case 76
$excuse2="genius"
Case 77
$excuse2="thoughtful"
Case 78
$excuse2="thoughtless"
Case 79
$excuse2="clueless"
Case 80
$excuse2="cheerful"
Case 81
$excuse2="depressed"
Case 82
$excuse2="hysterical"
Case 83
$excuse2="sorcerous"
Case 84
$excuse2="accursed"
Case 85
$excuse2="pickled"
Case 86
$excuse2="nondescript"
Case 87
$excuse2="intriguing"
Case 88
$excuse2="opinionated"
Case 89
$excuse2="political"
Case 90
$excuse2="Canadian"
Case 91
$excuse2="intimidating"
Case 92
$excuse2="Puerto Rican"
Case 93
$excuse2="feline"
Case 94
$excuse2="painted"
Case 95
$excuse2="inferior"
Case 96
$excuse2="hypnotized"
Case 97
$excuse2="sick"
Case 98
$excuse2="healthy"
Case 99
$excuse2="immortal"
Case 100
$excuse2="unfortunate"
EndSwitch
return $excuse2
ElseIf $type = "n" Then
$excuse3 = Random (1, 100, 1)
Switch $excuse3
Case 1
$excuse3="chili"
Case 2
$excuse3="grandma"
Case 3
$excuse3="arm"
Case 4
$excuse3="computer"
Case 5
$excuse3="keyboard"
Case 6
$excuse3="grandpa"
Case 7
$excuse3="cracker"
Case 8
$excuse3="soup"
Case 9
$excuse3="TV"
Case 10
$excuse3="cat"
Case 11
$excuse3="lamp"
Case 11
$excuse3="plant"
Case 12
$excuse3="light"
Case 13
$excuse3="table"
Case 14
$excuse3="dad"
Case 15
$excuse3="mom"
Case 16
$excuse3="brother"
Case 17
$excuse3="sister"
Case 18
$excuse3="shoe"
Case 19
$excuse3="door"
Case 20
$excuse3="telephone"
Case 21
$excuse3="aunt"
Case 22
$excuse3="uncle"
Case 23
$excuse3="shark"
Case 24
$excuse3="lake"
Case 25
$excuse3="nuclear missle"
Case 26
$excuse3="candlestick"
Case 27
$excuse3="beached whale"
Case 28
$excuse3="wife"
Case 29
$excuse3="juice box"
Case 30
$excuse3="bunny"
Case 31
$excuse3="wall"
Case 32
$excuse3="perfume"
Case 33
$excuse3="Coca-cola"
Case 34
$excuse3="pepsi"
Case 35
$excuse3="soda"
Case 36
$excuse3="pencil"
Case 37
$excuse3="doughnut"
Case 38
$excuse3="Duct Tape"
Case 39
$excuse3="floppy disk"
Case 40
$excuse3="cd"
Case 41
$excuse3="dollar bill"
Case 42
$excuse3="paper"
Case 43
$excuse3="printer"
Case 44
$excuse3="mouse pad"
Case 45
$excuse3="rat"
Case 46
$excuse3="flowers"
Case 47
$excuse3="trash can"
Case 48
$excuse3="light bulb"
Case 49
$excuse3="pair of scissors"
Case 50
$excuse3="recipies"
Case 51
$excuse3="poo poo"
Case 52
$excuse3="wireless modem"
Case 53
$excuse3="microphone"
Case 54
$excuse3="spatula"
Case 55
$excuse3="milkshake"
Case 56
$excuse3="empire"
Case 57
$excuse3="Kit Kat bar"
Case 58
$excuse3="popsicle"
Case 59
$excuse3="left ear"
Case 60
$excuse3="colon"
Case 61
$excuse3="peanut butter"
Case 62
$excuse3="hammock"
Case 63
$excuse3="pillow"
Case 64
$excuse3="house"
Case 65
$excuse3="iPod"
Case 66
$excuse3="lava lamp"
Case 67
$excuse3="magician"
Case 68
$excuse3="butler"
Case 69
$excuse3="statue"
Case 70
$excuse3="dictionary"
Case 71
$excuse3="ceiling fan"
Case 72
$excuse3="hard drive"
Case 73
$excuse3="finger"
Case 74
$excuse3="modem"
Case 75
$excuse3="pinto bean"
Case 76
$excuse3="sofa"
Case 77
$excuse3="submarine"
Case 78
$excuse3="camera"
Case 79
$excuse3="elephant"
Case 80
$excuse3="bagel"
Case 81
$excuse3="dolphin"
Case 82
$excuse3="pickles"
Case 83
$excuse3="pig"
Case 84
$excuse3="toe"
Case 85
$excuse3="pinky finger"
Case 86
$excuse3="football"
Case 87
$excuse3="notebook"
Case 88
$excuse3="binder"
Case 89
$excuse3="burger"
Case 90
$excuse3="fries"
Case 91
$excuse3="milk"
Case 92
$excuse3="pie"
Case 93
$excuse3="blanket"
Case 94
$excuse3="tooth"
Case 95
$excuse3="paintbrush"
Case 96
$excuse3="tongue"
Case 97
$excuse3="flag"
Case 98
$excuse3="Mountain Dew"
Case 99
$excuse3="napkin"
Case 100
$excuse3="VCR"
EndSwitch
Return $excuse3
Else
Return "{ERROR: Invalid argument passed to function}"
EndIf
EndFunc

Func new()
GUICtrlDelete ($excuseh)
$verb = randomize("v")
$adj = randomize("adj")
$noun = randomize("n")
$excuse = "Sorry, but I have to " & $verb & " my " & $adj & " " & $noun & "!"
$excuseh = GUICtrlCreateLabel ( $excuse, 10, 10 )
If $voiceEnabled Then _Speak ("Sorry, but I have to " & $verb & " my " & $adj & " " & $noun & "!", 1)
EndFunc
Func Excuse()
$because = GUICtrlRead($reason)
If $because = "Reasons" Then
$because = ""
EndIf
Return "I'd love to " & $because & ", but I have to " & randomize("v") & " my " & randomize("adj") & " " & randomize("n") & "!"
EndFunc

Func _Speak($s_text, $s_voice = 3, $s_dont = "")
Local $quite = 0
Local $o_speech = ObjCreate ("SAPI.SpVoice")
Select
Case $s_voice == 1
$o_speech.Voice = $o_speech.GetVoices("Name=Microsoft Mary", "Language=409").Item(0)
TrayTip("Female Reader",$s_text,1)
Case $s_voice == 2
$o_speech.Voice = $o_speech.GetVoices("Name=Microsoft Mike", "Language=409").Item(0)
TrayTip("Male Reader",$s_text,1)
Case $s_voice == 3
$o_speech.Voice = $o_speech.GetVoices("Name=Microsoft Sam", "Language=409").Item(0)
TrayTip("OldMan Reader",$s_text,1)
EndSelect
if $s_dont <> "dont talk" then
$o_speech.Speak ($s_text)
$o_speech = ""
EndIf
EndFunc
#endregion