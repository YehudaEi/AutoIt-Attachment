;  records each track after increasing the note values
;  run requirements:
;  		eartraing.wrk must be open
;		track view is maximized
;		track 1 is active S
;		track 2 is INACTIVE S and R
;		must activate directory for wave export by running it manually first
;		notes in track 1 must start at C3
;		for the full run, $loopmax = 56
;		notes in track 1 are not selected (black)
;		wave destination directory must be empty with initialized
#region variables; options, includes, variable definitions and variable assignments
Opt("WinWaitDelay",250)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
; file includes
#include <Array.au3>
;#include <GuiConstants.au3>

; variable declarations
Global $solocolumn
Global $recordcolumn
Global $namecolumn
Global $rowvalue
Global $rowincrease
Global $loopmax
Global $loop
Global $loopNPos
Global $x							; temp - for testing
Global $noteposition
Global $loop2
Global $trackselectcolumn
Global $numberofnotes
Global $intervalArray
Global $answerColumnArray
Global $answerTimeArray			; array of amount of time added to NOW after applying the answer
Global $Now						; initial value for now
Global $nowConverted			; converted clock value of now
Global $nowAdd						; value to add to NOWadj
Global $nowAdj						; value to add to NOW
Global $nowCurrent					; current value for now
Global $answerRowValue
Global $answerPosition
Global $pause

; variable assignments
$solocolumn = 134
$recordcolumn = 151
$trackselectcolumn = 13
$namecolumn = 58
$rowincrease = 13
$rowvalue = 165
$loopmax = 56					; default value for full run is 56
$loop = 0
$Now = 9.3
$nowAdj = 0
$nowAdd = 0
$loop2 = 0
$intervalArray = _ArrayCreate (0, 4, 3) ; intervals of each note starting from lowest and up to 5 notes
$numberofnotes = 2				; up to 5 notes, minus 1.  Really the number of intervals
$loopNPos = $loop				; variant for the value of loop used in functions to return note position and NOW time offset

; answer positions for A,A#,B,C,C#,D,D#,E,F,F#,G,G#
$answerColumnArray = _ArrayCreate (740,770,810,840,880,930,960,1010,1040,1070,1100,1140)
$answerTimeArray = _ArrayCreate (.3,.5,.3,.4,.5,.3,.5,.3,.3,.5,.3,.5)
$answerRowValue = 900
#endregion
#region GUI
; put the GUI here
; GUI
#endregion
; user functions
Func activate_cakewalk ()		; makes cakewalk the active window
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
EndFunc   ;==>activate_cakewalk 

Func select_midi_events () 		; selects all events in midi track
	sleep (2000)
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	sleep (1000)
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	MouseMove(888,150,0)
	MouseDown("left")
	MouseUp("left")
	Sleep(500)
	Send("{SHIFTDOWN}")
	MouseMove(750,150,0)
	MouseDown("left")
	MouseUp("left")
	Sleep(500)
	Send("{SHIFTUP}")
EndFunc   ;==>select_midi_events 

Func record_active_track ()		; record the active track, pause and stop recording, rewind
	Sleep (250)
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	MouseMove($recordcolumn, $rowvalue,0)
	MouseDown("left")
	MouseUp("left")
	sleep (250)
	MouseMove($solocolumn, $rowvalue,0)
	MouseDown("left")
	MouseUp("left")
	sleep (250)
	send ("w") ;  rewind
	Send("{SHIFTDOWN}r{SHIFTUP}")
	Sleep(8300)
	send ("w")
EndFunc   ;==>record_active_track 

Func move_notes_up ()			; run the CAL script to move the notes up
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	sleep (500)
	send ("{CTRLDOWN}{F1}{CTRLUP}")
	WinWait("Open","Files of &type:")
	If Not WinActive("Open","Files of &type:") Then WinActivate("Open","Files of &type:")
	WinWaitActive("Open","Files of &type:")
	sleep (500)
	Send("cal1.cal{ENTER}")
EndFunc   ;==>move_notes_up 

Func copy_track_name_export ()	; copy name of track to clipboard and export
	sleep (250)
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	MouseMove($namecolumn,$rowvalue,0)
	MouseClick("left",$namecolumn,$rowvalue,2)
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	; export track to wave
	Send("{CTRLDOWN}c{CTRLUP}{ALTDOWN}o{ALTUP}xe")
	WinWait("Mixdown Audio/Export to File(s)","")
	If Not WinActive("Mixdown Audio/Export to File(s)","") Then WinActivate("Mixdown Audio/Export to File(s)","")
	WinWaitActive("Mixdown Audio/Export to File(s)","")
	Send("{CTRLDOWN}v{CTRLUP}{ENTER}")  ; copies track name to filename and starts export to wave process
	Sleep (2000)
	While PixelGetColor (153, 1013) <> 15723486 ; waits until export is done by checking pixel color
		Sleep(100)
	WEnd
EndFunc   ;==>copy_track_name_export 

Func deactivate_track () 		; deactivate current track and increase value of $loop
	WinWait("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	If Not WinActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","") Then WinActivate("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	WinWaitActive("Cakewalk Pro Audio - [eartraining.wrk* - Track]","")
	Sleep (100)
	MouseMove($recordcolumn, $rowvalue,0)
	MouseDown("left")
	MouseUp("left")
	sleep (100)
	MouseMove($solocolumn, $rowvalue,0)
	MouseDown("left")
	MouseUp("left")
	sleep (100)
EndFunc   ;==>deactivate_track 

Func track_select ()			; selects the current track
	activate_cakewalk ()
	MouseMove($trackselectcolumn, $rowvalue,0)
	MouseDown("left")
	MouseUp("left")
	Sleep (500)
endFunc   ;==>track_select 

Func get_answer_position ()		; returns the x coordinanate of the position of the correct answer
	Select
		Case $loopNPos-9 = 0 or $loopNPos-9 = 12 or $loopNPos-9 = 24 or $loopNPos-9 = 36 or $loopNPos-9 = 48 or $loopNPos-9 = 60		; answer A
			$AnswerPosition = $answerColumnArray [0]
		Case $loopNPos-10 = 0 or $loopNPos-10 = 12 or $loopNPos-10 = 24 or $loopNPos-10= 36 or $loopNPos-10 = 48 or $loopNPos-10= 60	; answer A#
			$AnswerPosition = $answerColumnArray [1]
		Case $loopNPos-11 = 0 or $loopNPos-11 = 12 or $loopNPos-11 = 24 or $loopNPos-11 = 36 or $loopNPos-11= 48 or $loopNPos-11= 60	; answer B
			$AnswerPosition = $answerColumnArray [2]
		Case $loopNPos = 0 or $loopNPos = 12 or $loopNPos = 24 or $loopNPos = 36 or $loopNPos = 48 or $loopNPos = 60 					; answer C
			$AnswerPosition = $answerColumnArray [3]
		Case $loopNPos-1 = 0 or $loopNPos-1 = 12 or $loopNPos-1 = 24 or $loopNPos-1 = 36 or $loopNPos-1 = 48 or $loopNPos-1= 60			; answer C#
			$AnswerPosition = $answerColumnArray [4]
		Case $loopNPos-2 = 0 or $loopNPos-2 = 12 or $loopNPos-2 = 24 or $loopNPos-2 = 36 or $loopNPos-2 = 48 or $loopNPos-2= 60 		; answer D
			$AnswerPosition = $answerColumnArray [5]
		Case $loopNPos-3 = 0 or $loopNPos-3 = 12 or $loopNPos-3 = 24 or $loopNPos-3 = 36 or $loopNPos-3 = 48 or $loopNPos-3= 60 		; answer D#
			$AnswerPosition = $answerColumnArray [6]
		Case $loopNPos-4 = 0 or $loopNPos-4 = 12 or $loopNPos-4 = 24 or $loopNPos-4 = 36 or $loopNPos-4 = 48 or $loopNPos-4= 60 		; answer E
			$AnswerPosition = $answerColumnArray [7]
		Case $loopNPos-5 = 0 or $loopNPos-5 = 12 or $loopNPos-5 = 24 or $loopNPos-5 = 36 or $loopNPos-5 = 48 or $loopNPos-5= 60			; answer F
			$AnswerPosition = $answerColumnArray [8]
		Case $loopNPos-6 = 0 or $loopNPos-6 = 12 or $loopNPos-6 = 24 or $loopNPos-6 = 36 or $loopNPos-6 = 48 or $loopNPos-6= 60 		; answer F#
			$AnswerPosition = $answerColumnArray [9]
		Case $loopNPos-7 = 0 or $loopNPos-7 = 12 or $loopNPos-7 = 24 or $loopNPos-7 = 36 or $loopNPos-7 = 48 or $loopNPos-7= 60 		; answer G
			$AnswerPosition = $answerColumnArray [10]
		Case $loopNPos-8 = 0 or $loopNPos-8 = 12 or $loopNPos-8 = 24 or $loopNPos-8 = 36 or $loopNPos-8 = 48 or $loopNPos-8= 60 		; answer G#
			$AnswerPosition = $answerColumnArray [11]
	EndSelect
	Return ($AnswerPosition)
EndFunc   ;==>get_answer_position 

Func get_answer_now_adj ()		; returns the adjustment to now for an answer
	Select
		Case $loopNPos-9 = 0 or $loopNPos-9 = 12 or $loopNPos-9 = 24 or $loopNPos-9 = 36 or $loopNPos-9 = 48  or $loopNPos-9 = 60		; answer A
			$nowAdd = $answerTimeArray [0]
		Case $loopNPos-10 = 0 or $loopNPos-10 = 12 or $loopNPos-10 = 24 or $loopNPos-10= 36 or $loopNPos-10 = 48 or $loopNPos-10 = 60  	; answer A#
			$nowAdd = $answerTimeArray [1]
		Case $loopNPos-11 = 0 or $loopNPos-11 = 12 or $loopNPos-11 = 24 or $loopNPos-11 = 36 or $loopNPos-11= 48 or $loopNPos-11= 48  	; answer B
			$nowAdd = $answerTimeArray [2]
		Case $loopNPos = 0 or $loopNPos = 12 or $loopNPos = 24 or $loopNPos = 36 or $loopNPos = 48 or $loopNPos = 60  					; answer C
			$nowAdd = $answerTimeArray [3]
		Case $loopNPos-1 = 0 or $loopNPos-1 = 12 or $loopNPos-1 = 24 or $loopNPos-1 = 36 or $loopNPos-1 = 48 or $loopNPos-1 = 60 		; answer C#
			$nowAdd = $answerTimeArray [4]
		Case $loopNPos-2 = 0 or $loopNPos-2 = 12 or $loopNPos-2 = 24 or $loopNPos-2 = 36 or $loopNPos-2 = 48 or $loopNPos-2 = 60 		; answer D
			$nowAdd = $answerTimeArray [5]
		Case $loopNPos-3 = 0 or $loopNPos-3 = 12 or $loopNPos-3 = 24 or $loopNPos-3 = 36 or $loopNPos-3 = 48 or $loopNPos-3 = 60 		; answer D#
			$nowAdd = $answerTimeArray [6]
		Case $loopNPos-4 = 0 or $loopNPos-4 = 12 or $loopNPos-4 = 24 or $loopNPos-4 = 36 or $loopNPos-4 = 48 or $loopNPos-4 = 60  		; answer E
			$nowAdd = $answerTimeArray [7]
		Case $loopNPos-5 = 0 or $loopNPos-5 = 12 or $loopNPos-5 = 24 or $loopNPos-5 = 36 or $loopNPos-5 = 48 or $loopNPos-5 = 60		; answer F
			$nowAdd = $answerTimeArray [8]
		Case $loopNPos-6 = 0 or $loopNPos-6 = 12 or $loopNPos-6 = 24 or $loopNPos-6 = 36 or $loopNPos-6 = 48 or $loopNPos-6 = 60 		; answer F#
			$nowAdd = $answerTimeArray [9]
		Case $loopNPos-7 = 0 or $loopNPos-7 = 12 or $loopNPos-7 = 24 or $loopNPos-7 = 36 or $loopNPos-7 = 48 or $loopNPos-7 = 60 		; answer G
			$nowAdd = $answerTimeArray [10]
		Case $loopNPos-8 = 0 or $loopNPos-8 = 12 or $loopNPos-8 = 24 or $loopNPos-8 = 36 or $loopNPos-8 = 48 or $loopNPos-8 = 60 		; answer G#
			$nowAdd = $answerTimeArray [11]
	EndSelect
	Return ($nowAdd)
EndFunc   ;==>get_answer_now_adj 

Func convert_now ()				; converts $now to its clock value
	If $Now = 9.3 Then
			$nowConverted = "9.3"
		ElseIf $Now = 9.4 Then 
			$nowConverted = "9.4"
		ElseIf $Now = 9.5 Then
			$nowConverted = "10.1"
		ElseIf $Now = 9.6 Then
			$nowConverted = "10.2"
		ElseIf $Now = 9.7 Then
			$nowConverted = "10.3"
		ElseIf $Now = 9.8 Then
			$nowConverted = "10.4"
		ElseIf $Now = 9.9 Then
			$nowConverted = "11.1"
		ElseIf $Now = 10.0 Then
			$nowConverted = "11.2"
		ElseIf $Now = 10.1 Then
			$nowConverted = "11.3"
		ElseIf $Now = 10.2 Then
			$nowConverted = "11.4"
		ElseIf $Now = 10.3 Then
			$nowConverted = "12.1"
		ElseIf $Now = 10.4 Then
			$nowConverted = "12.2"
		ElseIf $Now = 10.5 Then
			$nowConverted = "12.3"
		ElseIf $Now = 10.6 Then
			$nowConverted = "12.4"
		ElseIf $Now = 10.7 Then
			$nowConverted = "13.1"
		ElseIf $Now = 10.8 Then
			$nowConverted = "13.2"
	EndIf
	Return ($nowConverted)
EndFunc   ;==>convert_now 

;Func convert_now ()				; converts $now to its clock value
;	Select
;		Case $Now = 9.3
;			$NowConverted = 9.3
;		Case $Now = 9.4
;			$NowConverted = 9.4
;		Case $Now = 9.5
;			$NowConverted = 10.1
;		Case $Now = 9.6
;			$NowConverted = 10.2
;		Case $Now = 9.7
;			$NowConverted = 10.3
;		Case $Now = 9.8
;			$NowConverted = 10.4
;		Case $Now = 9.9
;			$NowConverted = 11.1
;		Case $Now = 10.0
;			$NowConverted = 11.2
;		Case $Now = 10.1
;			$NowConverted = 11.3
;		Case $Now = 10.2
;			$NowConverted = 11.4
;		Case $Now = 10.3
;			$NowConverted = 12.1
;		Case $Now = 10.4
;			$NowConverted = 12.2
;		Case $Now = 10.5
;			$NowConverted = 12.3
;		Case $Now = 10.6
;			$NowConverted = 12.4
;		Case $Now = 10.7
;			$NowConverted = 13.1
;		Case $Now = 10.8
;			$NowConverted = "13:02"
			;		Case $Now = 10.9
			;			$NowConverted = "13:03"
			;		Case $Now = 11.0
			;			$NowConverted = "13:04"
			;		Case $Now = 11.1
			;			$NowConverted = "14:01"
			;		Case $Now = 11.2
			;			$NowConverted = "14:02"
			;		Case $Now = 11.3
			;			$NowConverted = "14:03"
			;		Case $Now = 11.4
			;			$NowConverted = "14:04"
			;		Case $Now = 11.5
			;			$NowConverted = "15:01"
			;		Case $Now = 11.6
			;			$NowConverted = "15:02"
			;		Case $Now = 11.7
			;			$NowConverted = "15:03"
			;		Case $Now = 11.8
			;			$NowConverted = "15:04"
;	EndSelect
;	Return ($nowConverted)
;EndFunc   ;==>convert_now 

Func copy_answer ()
	activate_cakewalk ()
	MouseClick ("left", get_answer_position (), $answerRowValue,1,0)
	Sleep(250)
	Send("{CTRLDOWN}c{CTRLUP}")
	WinWait("Copy","")
	If Not WinActive("Copy","") Then WinActivate("Copy","")
	WinWaitActive("Copy","")
	Send("{ENTER}")
	Sleep (250)
	;activate_cakewalk ()
	set_position ()
	Send("{CTRLDOWN}v{CTRLUP}")
	WinWait("Paste","")
	If Not WinActive("Paste","") Then WinActivate("Paste","")
	WinWaitActive("Paste","")
	Send("{ENTER}")
	Sleep (250)
EndFunc   ;==>copy_answer 

Func set_position () 			; sets the position of NOW in cakewalk to the insertion point for the next answer
	activate_cakewalk ()
	Sleep (500)
	$Now = $Now + $nowAdj
																	MsgBox(262144,'Debug line ~353','Selection:' & @lf & '$nowAdj' & @lf & @lf & 'Return:' & @lf & $nowAdj & @lf & @lf & '@Error:' & @lf & @Error) ;### Debug MSGBOX
																	MsgBox(262144,'Debug line ~312','Selection:' & @lf & '$Now' & @lf & @lf & 'Return:' & @lf & $Now & @lf & @lf & '@Error:' & @lf & @Error) ;### Debug MSGBOX
	Sleep (500)
	activate_cakewalk ()
	ClipPut (convert_now())				; copy value of converted NOW to clipboard
																	MsgBox(262144,'Debug line ~316','Selection:' & @lf & 'convert_now()' & @lf & @lf & 'Return:' & @lf & convert_now() & @lf & @lf & '@Error:' & @lf & @Error) ;### Debug MSGBOX
																	MsgBox(262144,'Debug line ~316','Selection:' & @lf & '$nowConverted' & @lf & @lf & 'Return:' & @lf & $nowConverted & @lf & @lf & '@Error:' & @lf & @Error) ;### Debug MSGBOX
	
	Sleep (500)
	ControlClick ( "Cakewalk Pro Audio - [eartraining.wrk* - Track]", "", 50)
	Sleep (500)
	send ("{CTRLDOWN}v{CTRLUP}{ENTER}")
	Sleep (500)
	$nowAdj = $nowAdj + get_answer_now_adj ()  ; get $nowadd from array and add it to $nowadj
																	MsgBox(262144,'Debug line ~324','Selection:' & @lf & '$nowAdj' & @lf & @lf & 'Return:' & @lf & $nowAdj & @lf & @lf & '@Error:' & @lf & @Error) ;### Debug MSGBOX
EndFunc   ;==>set_position 

Func add_answers_to_track () 	; adds all answers to track
	activate_cakewalk ()
	track_select ()
	While $loop2 <= $numberofnotes
		$loopNPos = $loopNPos + $intervalArray [$loop2]
		activate_cakewalk ()
		;set_position ()
		copy_answer ()
		$loop2 = $loop2 + 1
		$now = 9.3
		send ("w")
	WEnd
	$Now = 9.3
	$loop2 = 0
	$Nowadj = 0
	$nowAdd = 0
EndFunc   ;==>add_answers_to_track 

; PROGRAM
While $loop < $loopmax
	select_midi_events ()
	record_active_track ()
	move_notes_up ()
	add_answers_to_track ()
	select_midi_events ()
	;copy_track_name_export ()
	deactivate_track ()
	$loop=$loop + 1
	$loopNPos = $loop
	$rowvalue=$rowvalue+$rowincrease
WEnd
exit

