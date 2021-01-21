; CyberSlug - 1 Feb 2005
;-----------------------
;Put a space between each note and rest
;Use uppercase letters to denote the pitches
;Use "r" to denote rest
;Follow pitch with "#" or "+" to denote sharp; use "b" or "-" to denote flat
;Precede the pitch with a number to denote duration 1=whole, 2=half, 4=quarter(DEFAULT), 8=eight, 16=sixteenth
;Specify octave in the format "o7"; default octave is "o4"
;Specify tempo in the format "t100"; that means 100 quarter notes per minute; range 32 - 255

Play("t240 E D C D E E E r D D D r E G G r")
Play("t240 E D C D E E E E D D E D C")
Play("2r")
Play("o5 E E 2E E E 2E E G C D 2E")
Play("2r")
Play("C D E F G A B o5 C o4 B A G F E D C")
Play("2r")
Play("t255 C C# D D# E F F# G G# A A# B B# < C")
Play("2r")
Play("t255 o4 C > Cb B Bb A Ab G Gb F E Eb D Db C")

Func Play($music)
	; the very last entry in $octave_four should be out of most people's hearing range
	; and is used to simulate a rest
	Local $octave_0 = "16.35 17.32 18.35 19.45 20.60 21.83 23.12 24.50 25.96 27.50 29.14 30.87 32767"               ;TOO LOW TO PLAY!!!
	Local $octave_1 = "32.70 34.65 36.71 38.89 41.20 43.65 46.25 49.00 51.91 55.00 58.27 61.74 32767"               ;C1 thru B1
	Local $octave_2 = "65.41 69.30 73.42 77.78 82.41 87.31 92.50 98.00 103.83 110.00 116.54 123.47 32767"           ;C2 thru B2
	Local $octave_3 = "130.81 138.59 146.83 155.56 164.81 174.61 185.00 196.00 207.65 220.00 233.08 246.94 32767"   ;C3 thru B3
	Local $octave_4 = "261.63 277.18 293.66 311.13 329.63 349.23 369.99 392.00 415.30 440.00 466.16 493.88 32767"   ;C4 thru B4
	Local $octave_5 = "523.25 554.37 587.33 622.25 659.26 698.46 739.99 783.99 830.61 880.00 932.33 987.77 32767"   ;etc.
	Local $octave_6 = "1046.50 1108.73 1174.66 1244.51 1318.51 1396.91 1479.98 1567.98 1661.22 1760.00 1864.66 32767"
	Local $octave_7 = "2093.00 2217.46 2349.32 2489.02 2637.02 2793.83 2959.96 3135.96 3322.44 3520.00 3729.31 3951.07 32767"
	Local $octave_8 = "4186.01 4434.92 4698.64 4978.03"                                                              ;C8 thru D#8
	
    Local $C=1, $D=3, $E=5, $F=6, $G=8, $A=10, $B=12, $r=13
	Local $Csharp=2, $Dsharp=4, $Fsharp=7, $Gsharp=9, $Asharp=11
	Local $Dflat=2,  $Eflat=4,  $Gflat=7,  $Aflat=9,  $Bflat=11
    Local $i
	Local $duration, $frequency
	Local $currentOctave = 4
	Local $tempo = 120
	Local $octave_array = StringSplit( Eval("octave_" & $currentOctave) , " ")
	
	$music = StringReplace($music, "#", "sharp")
	$music = StringReplace($music, "b", "flat", 0, 1) ;case-sensitive
	
	$music = StringReplace($music, "+", "sharp")
	$music = StringReplace($music, "-", "flat", 0, 1) ;case-sensitive
	
	; To split "16C" into duration and frequency:
	; $duration = Number("16C")
	; $frequency = StringReplace("16C", String(Number("16C")), " "))
	
	; duration 1=whole, 2=half, 4=quarter, 8=eight, 16=sixteenth
	; currently, set quarter note to be a half-second; hence the 2000 / $duration formula 
	
    $music = StringSplit($music, " ")
    For $i = 1 to $music[0]
		If StringLeft($music[$i],1) = "o" Then
			$currentOctave = Number(StringTrimLeft($music[$i], 1))
		ElseIf StringLeft($music[$i],1) = "<" Then ;up an octave
			$currentOctave = $currentOctave + 1
		ElseIf StringLeft($music[$i],1) = ">" Then ;down an octave
			$currentOctave = $currentOctave - 1
		EndIf

		If $currentOctave > 8 Then $currentOctave = 8
		If $currentOctave < 1 Then $currentOctave = 1
		$octave_array = StringSplit( Eval("octave_" & $currentOctave) , " ")

		If StringLeft($music[$i],1) = "t" Then
			$tempo = Number(StringTrimLeft($music[$i], 1))
			If $tempo > 255 Then $tempo = 255
			If $tempo < 32 Then $temo = 32
		EndIf
			
		$duration = Number($music[$i])
		If $duration = 0 Then $duration = 4
		$frequency = Eval(StringStripWS( StringReplace($music[$i], String(Number($music[$i])), " ") ,8))
		;MsgBox(4096,$duration,$frequency)
        DLLCall("kernel32.dll","int","Beep","long", $octave_array[$frequency],"long", 30000 * (4/$duration) / $tempo)
		DLLCall("kernel32.dll","int","Beep","long", 32767, "long", 10)
    Next
EndFunc


#cs --- might be useful info

;http://www.phy.mtu.edu/~suits/notefreqs.html
;                                                                               

;freq range in hertz:  37 and 32,767
;duration range in millisecs: 0 and 65,535

;;;  C  C#/Db  D  D#/Eb  E  F  F#/Gb  G  G#/Ab  A  A#/Bb  B
;;;  1    2    3    4    5  6   7     8    9   10   11   12

#ce