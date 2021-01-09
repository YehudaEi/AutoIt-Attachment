#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Outfile=..\DigitalMusic.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Digital Music Generator
#AutoIt3Wrapper_Res_Description=Digital Music Generator
#AutoIt3Wrapper_Res_Fileversion=.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=GNU
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <midi.au3>
#include<GUIConstantsEx.au3>
$form = GUICreate("Digital Music", 190, 55)
$RandomI = GUICtrlCreateButton("Random Instruments", 0, 0, 190, 25)
$RandomN = GUICtrlCreateButton("Grand Piano Only", 0, 25, 190, 25)
GUISetState()

;- Default is Grand Piano Only!
$RamdomInstruments = False

;- Dim default notes array
Dim $3RSArray[3][2]

;- Dim primary notes array
Dim $array[89][2]

;- Load array with the notes to turn on commands
$array[0][0] = $A0_NOTEON
$array[1][0] = $A0SHARP_NOTEON
$array[2][0] = $B0_NOTEON
$array[3][0] = $C1_NOTEON
$array[4][0] = $C1SHARP_NOTEON
$array[5][0] = $D1_NOTEON
$array[6][0] = $D1SHARP_NOTEON
$array[7][0] = $E1_NOTEON
$array[8][0] = $F1_NOTEON
$array[9][0] = $F1SHARP_NOTEON
$array[10][0] = $G1_NOTEON
$array[11][0] = $G1SHARP_NOTEON
$array[12][0] = $A1_NOTEON
$array[13][0] = $A1SHARP_NOTEON
$array[14][0] = $B1_NOTEON
$array[15][0] = $C2_NOTEON
$array[16][0] = $C2SHARP_NOTEON
$array[17][0] = $D2_NOTEON
$array[18][0] = $D2SHARP_NOTEON
$array[19][0] = $E2_NOTEON
$array[20][0] = $F2_NOTEON
$array[21][0] = $F2SHARP_NOTEON
$array[22][0] = $G2_NOTEON
$array[23][0] = $G2SHARP_NOTEON
$array[24][0] = $A2_NOTEON
$array[25][0] = $A2SHARP_NOTEON
$array[26][0] = $B2_NOTEON
$array[27][0] = $C3_NOTEON
$array[28][0] = $C3SHARP_NOTEON
$array[29][0] = $D3_NOTEON
$array[30][0] = $D3SHARP_NOTEON
$array[31][0] = $E3_NOTEON
$array[32][0] = $F3_NOTEON
$array[33][0] = $F3SHARP_NOTEON
$array[34][0] = $G3_NOTEON
$array[35][0] = $G3SHARP_NOTEON
$array[36][0] = $A3_NOTEON
$array[37][0] = $A3SHARP_NOTEON
$array[38][0] = $B3_NOTEON
$array[39][0] = $C4_NOTEON
$array[40][0] = $C4SHARP_NOTEON
$array[41][0] = $D4_NOTEON
$array[42][0] = $D4SHARP_NOTEON
$array[43][0] = $E4_NOTEON
$array[44][0] = $F4_NOTEON
$array[45][0] = $F4SHARP_NOTEON
$array[46][0] = $G4_NOTEON
$array[47][0] = $G4SHARP_NOTEON
$array[48][0] = $A4_NOTEON
$array[49][0] = $A4SHARP_NOTEON
$array[50][0] = $B4_NOTEON
$array[51][0] = $C5_NOTEON
$array[52][0] = $C5SHARP_NOTEON
$array[53][0] = $D5_NOTEON
$array[54][0] = $D5SHARP_NOTEON
$array[55][0] = $E5_NOTEON
$array[56][0] = $F5_NOTEON
$array[57][0] = $F5SHARP_NOTEON
$array[58][0] = $G5_NOTEON
$array[59][0] = $G5SHARP_NOTEON
$array[60][0] = $A5_NOTEON
$array[61][0] = $A5SHARP_NOTEON
$array[62][0] = $B5_NOTEON
$array[63][0] = $C6_NOTEON
$array[64][0] = $C6SHARP_NOTEON
$array[65][0] = $D6_NOTEON
$array[66][0] = $D6SHARP_NOTEON
$array[67][0] = $E6_NOTEON
$array[68][0] = $F6_NOTEON
$array[69][0] = $F6SHARP_NOTEON
$array[70][0] = $G6_NOTEON
$array[71][0] = $G6SHARP_NOTEON
$array[72][0] = $A6_NOTEON
$array[73][0] = $A6SHARP_NOTEON
$array[74][0] = $B6_NOTEON
$array[75][0] = $C7_NOTEON
$array[76][0] = $C7SHARP_NOTEON
$array[77][0] = $D7_NOTEON
$array[78][0] = $D7SHARP_NOTEON
$array[79][0] = $E7_NOTEON
$array[80][0] = $F7_NOTEON
$array[81][0] = $F7SHARP_NOTEON
$array[82][0] = $G7_NOTEON
$array[83][0] = $G7SHARP_NOTEON
$array[84][0] = $A7_NOTEON
$array[85][0] = $A7SHARP_NOTEON
$array[86][0] = $B7_NOTEON
$array[87][0] = $C8_NOTEON
$array[88][0] = ""

;- Load array with the notes to turn off commands
$array[0][1] = $A0_NOTEOFF
$array[1][1] = $A0SHARP_NOTEOFF
$array[2][1] = $B0_NOTEOFF
$array[3][1] = $C1_NOTEOFF
$array[4][1] = $C1SHARP_NOTEOFF
$array[5][1] = $D1_NOTEOFF
$array[6][1] = $D1SHARP_NOTEOFF
$array[7][1] = $E1_NOTEOFF
$array[8][1] = $F1_NOTEOFF
$array[9][1] = $F1SHARP_NOTEOFF
$array[10][1] = $G1_NOTEOFF
$array[11][1] = $G1SHARP_NOTEOFF
$array[12][1] = $A1_NOTEOFF
$array[13][1] = $A1SHARP_NOTEOFF
$array[14][1] = $B1_NOTEOFF
$array[15][1] = $C2_NOTEOFF
$array[16][1] = $C2SHARP_NOTEOFF
$array[17][1] = $D2_NOTEOFF
$array[18][1] = $D2SHARP_NOTEOFF
$array[19][1] = $E2_NOTEOFF
$array[20][1] = $F2_NOTEOFF
$array[21][1] = $F2SHARP_NOTEOFF
$array[22][1] = $G2_NOTEOFF
$array[23][1] = $G2SHARP_NOTEOFF
$array[24][1] = $A2_NOTEOFF
$array[25][1] = $A2SHARP_NOTEOFF
$array[26][1] = $B2_NOTEOFF
$array[27][1] = $C3_NOTEOFF
$array[28][1] = $C3SHARP_NOTEOFF
$array[29][1] = $D3_NOTEOFF
$array[30][1] = $D3SHARP_NOTEOFF
$array[31][1] = $E3_NOTEOFF
$array[32][1] = $F3_NOTEOFF
$array[33][1] = $F3SHARP_NOTEOFF
$array[34][1] = $G3_NOTEOFF
$array[35][1] = $G3SHARP_NOTEOFF
$array[36][1] = $A3_NOTEOFF
$array[37][1] = $A3SHARP_NOTEOFF
$array[38][1] = $B3_NOTEOFF
$array[39][1] = $C4_NOTEOFF
$array[40][1] = $C4SHARP_NOTEOFF
$array[41][1] = $D4_NOTEOFF
$array[42][1] = $D4SHARP_NOTEOFF
$array[43][1] = $E4_NOTEOFF
$array[44][1] = $F4_NOTEOFF
$array[45][1] = $F4SHARP_NOTEOFF
$array[46][1] = $G4_NOTEOFF
$array[47][1] = $G4SHARP_NOTEOFF
$array[48][1] = $A4_NOTEOFF
$array[49][1] = $A4SHARP_NOTEOFF
$array[50][1] = $B4_NOTEOFF
$array[51][1] = $C5_NOTEOFF
$array[52][1] = $C5SHARP_NOTEOFF
$array[53][1] = $D5_NOTEOFF
$array[54][1] = $D5SHARP_NOTEOFF
$array[55][1] = $E5_NOTEOFF
$array[56][1] = $F5_NOTEOFF
$array[57][1] = $F5SHARP_NOTEOFF
$array[58][1] = $G5_NOTEOFF
$array[59][1] = $G5SHARP_NOTEOFF
$array[60][1] = $A5_NOTEOFF
$array[61][1] = $A5SHARP_NOTEOFF
$array[62][1] = $B5_NOTEOFF
$array[63][1] = $C6_NOTEOFF
$array[64][1] = $C6SHARP_NOTEOFF
$array[65][1] = $D6_NOTEOFF
$array[66][1] = $D6SHARP_NOTEOFF
$array[67][1] = $E6_NOTEOFF
$array[68][1] = $F6_NOTEOFF
$array[69][1] = $F6SHARP_NOTEOFF
$array[70][1] = $G6_NOTEOFF
$array[71][1] = $G6SHARP_NOTEOFF
$array[72][1] = $A6_NOTEOFF
$array[73][1] = $A6SHARP_NOTEOFF
$array[74][1] = $B6_NOTEOFF
$array[75][1] = $C7_NOTEOFF
$array[76][1] = $C7SHARP_NOTEOFF
$array[77][1] = $D7_NOTEOFF
$array[78][1] = $D7SHARP_NOTEOFF
$array[79][1] = $E7_NOTEOFF
$array[80][1] = $F7_NOTEOFF
$array[81][1] = $F7SHARP_NOTEOFF
$array[82][1] = $G7_NOTEOFF
$array[83][1] = $G7SHARP_NOTEOFF
$array[84][1] = $A7_NOTEOFF
$array[85][1] = $A7SHARP_NOTEOFF
$array[86][1] = $B7_NOTEOFF
$array[87][1] = $C8_NOTEOFF
$array[88][1] = ""

;- Create MIDI Socket
$open = _midiOutOpen()
While 1
	$c = Int(Random(1, 4)) ;- Create itteration Count
	$d = Int(Random(1, 4)) ;- Create Cleanup Count
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			_MidiOutClose($open) ;- Close Midi Socket
			Exit
		Case $RandomI ;- Enable Random Instruments
			$RamdomInstruments = True
			
		Case $RandomN ;- Enable Only Grand Piano
			$RamdomInstruments = False
		Case Else
			If $c = $d Then ;- Remove Stuck Notes/Adds dynamics, Doesn't play any Notes however.  It's a good spacer.
				$c = 0
				For $z = 0 To UBound($array) - 1
					$msg = _midioutshortmsg($open, $array[$z][1])
				Next
			Else ;- Start playing notes!
				$3RS = Int(Random(1, 4)) ;- How big will the array be, ie how many notes
				ReDim $3RSArray[$3RS][2] ;- Dim the array
				Call("_Play") ;- Play them
			EndIf
	EndSwitch
WEnd
Func _Play()
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			_MidiOutClose($open)
			Exit
		Case $RandomI
			$RamdomInstruments = True
			
		Case $RandomN
			$RamdomInstruments = False

		Case Else
			$Process = ProcessList() ;- Grab Processes
			If $3RS = 1 Then ;- Only if 1 note
				ReDim $3RSArray[1][2] ;- redims the array as needed
				$pmem = ProcessGetStats($Process[0][1], 0) ;- Sets to the System PID
				If IsArray($pmem) Then
					$Pio = ProcessGetStats($Process[0][1], 1)
					If IsArray($Pio) Then
						$trimme = Int(StringTrimLeft(((($pmem[0] / $pmem[1]) / ($Pio[1] / $Pio[4])) * Random(10, 30)), Int(Random(1, 3)))) ;- Creates the random instrument # if necessary
						If $trimme > 160 Then $trimme = StringTrimLeft($trimme, Random(1, 2)) ;- If it's over than 160 (# of instruments defined), then truncate it
						$randomNote = Random(0, 87) ;- Defines what note to pull from the array
						If $RamdomInstruments = True Then ;- If it's random then
							$instrument = $trimme ;- define the instrument as the instrument # defined above
						Else
							$instrument = 0 ;- else if not random, define only as Grand Piano
						EndIf
						$3RSArray[0][0] = $array[$randomNote][0] ;- Adds notes to array
						$3RSArray[0][1] = $array[$randomNote][1] ;- Adds notes to array
						_MidiOutShortMsg($open, 256 * $instrument + 192) ;- Select Instrument
						$msg = _midioutshortmsg($open, $3RSArray[0][0]) ;- play the Array
						Sleep(Random(Int(Random(200, 400)), Int(Random(400, 900))))
					EndIf
				EndIf
			ElseIf $3RS = 2 Then ;- if there will be 2 notes to be played
				ReDim $3RSArray[2][2]
				$pid = $Process[0][1]
				$pmem = ProcessGetStats($Process[0][1], 0)
				If IsArray($pmem) Then
					$Pio = ProcessGetStats($Process[0][1], 1)
					If IsArray($Pio) Then
						$trimme = Int(StringTrimLeft(((($pmem[0] / $pmem[1]) / ($Pio[1] / $Pio[4])) * Random(10, 30)), Int(Random(1, 3))))
						If $trimme > 160 Then $trimme = StringTrimLeft($trimme, Random(1, 2))
						If $RamdomInstruments = True Then
							$instrument = $trimme
						Else
							$instrument = 0
						EndIf
						For $n = 0 To 1
							$randomNote = Random(0, 87)
							$3RSArray[$n][0] = $array[$randomNote][0]
							$3RSArray[$n][1] = $array[$randomNote][1]
						Next
						_MidiOutShortMsg($open, 256 * $instrument + 192) ;- Select Instrument At Random
						$msg = _midioutshortmsg($open, $3RSArray[0][0]) ;- play a note
						Sleep($trimme) ;- wait a quick amount of time ***** THIS IS NOT NECESSARY ***** But it does add dynamic to thes ound
						$msg = _midioutshortmsg($open, $3RSArray[1][0]) ;- play second note
						Sleep(Random(Int(Random(200, 400)), Int(Random(400, 900))))
					EndIf
				EndIf
			ElseIf $3RS = 3 Then ;- if there will be 3 notes to be played
				ReDim $3RSArray[3][2]
				$pid = $Process[0][1]
				$pmem = ProcessGetStats($Process[0][1], 0)
				If IsArray($pmem) Then
					$Pio = ProcessGetStats($Process[0][1], 1)
					If IsArray($Pio) Then
						$trimme = Int(StringTrimLeft(((($pmem[0] / $pmem[1]) / ($Pio[1] / $Pio[4])) * Random(10, 30)), Int(Random(1, 3))))
						If $trimme > 160 Then $trimme = StringTrimLeft($trimme, Random(1, 2))
						If $RamdomInstruments = True Then
							$instrument = $trimme
						Else
							$instrument = 0
						EndIf
						For $n = 0 To 2
							$randomNote = Random(0, 87)
							$3RSArray[$n][0] = $array[$randomNote][0]
							$3RSArray[$n][1] = $array[$randomNote][1]
						Next
						_MidiOutShortMsg($open, 256 * $instrument + 192) ;- Select Instrument At Random
						$msg = _midioutshortmsg($open, $3RSArray[0][0])
;~ 						Sleep($trimme)
						$msg = _midioutshortmsg($open, $3RSArray[1][0])
;~ 						Sleep($trimme)
						$msg = _midioutshortmsg($open, $3RSArray[2][0])
						Sleep(Random(Int(Random(200, 400)), Int(Random(400, 900))))
					EndIf
				EndIf
			Else
			EndIf
	EndSwitch
EndFunc   ;==>_Play