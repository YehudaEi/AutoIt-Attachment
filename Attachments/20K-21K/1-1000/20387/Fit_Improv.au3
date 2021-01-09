;Fit Improvisation for Sonar Home Studio 6
;2008-05-27 _Steve_H
;
;This program uses the AutoIt Windows automation/keystroke program (freeware) to calculate
;and enter tempo changes in order to sync the midi beat to an audio track.
;---> works the same way as the 'Fit Improvisation' process in Sonar Studio/Producer
;---> It works well fitting the midi beat to an improvisational audio track
;---> BUT it doesn't work if you want to fit the midi beat to an improvisational midi track
;---> takes a few minutes longer to run BUT saved me the cost of an upgrade!
;
;AutoIt v3 Webpage: http://www.autoitscript.com/autoit3/
;
Fit_Improv_Info() ;#include "Fit Improv Info.au3"
AutoItSetOption("WinTitleMatchMode",2)
If WinExists("Help") then WinClose("Help") ;program mixes up Sonar Help window with Sonar progam
If WinExists("Synth Rack") then WinClose("Synth Rack") ;synth rack is always on top and gets in the way
WinActivate("SONAR")
If WinActive("SONAR")=0 Then
	MsgBox(16, "ERROR", "Unable to find SONAR")
	Exit
EndIf
$message=FileRead("Fit Improv ReadMe.txt")
If MsgBox(65, "Fit Improvisation Instructions:", $message)<>1 Then Exit
AutoItSetOption("SendKeyDelay", 50) ;increase value to slow down typing speed
Send("^{Home}") ;rewind to beginning
Send("!esn") ;unselect clips
;set variables...
Send("!op") ;open project options dialogue so user can verify 'Ticks per quarter note' = 960
$timebase = InputBox("TIMEBASE", "What is the TIMEBASE (Ticks per quarter note) ?", "960","",-1,-1,0,0)
If WinExists("Project Options") then WinClose("Project Options")
$events = InputBox("Number of Events to Process", "How many Events/Notes in Selected track ? (Don't know?... double click the track to open/view the track properties)", "0","",-1,-1,0,0)
If WinExists("Track Properties") then WinClose("Track Properties")
WinActivate("SONAR")
If $events = 0 Then Exit
If @OSVersion <> "WIN_98" And @OSVersion <> "WIN_ME" Then
    BlockInput(1) ;block user input while script running
EndIf
Send("!ik{TAB}^c{Enter}") ;open Meter/Key Signature dialogue and select/copy 'beats per measure'
$bpmeasure = ClipGet()
Send("!it^c{Enter}") ;open Tempo dialogue and select/copy baseline tempo
$basetempo = ClipGet()

ProgressOn("Progress Meter", "Fit to Improvisation", "Progress Meter: 0 percent",0,0,1)

for $time = 0 to (($events-1)*$timebase) Step $timebase
	
	Send("{F3}") ;move to next note
	Send("!gt^c{Enter}") ;open 'Go' dialogue and select/copy current transport time
	$transport=ClipGet()
	;convert transport from M:B:T to ticks
	$MBT = StringSplit( $transport , ":" )
	$tick = ($MBT[1]-1)*$bpmeasure*$timebase + ($MBT[2]-1)*$timebase + $MBT[3]
	
	if $time > 0 then

		$move=$tick-$mark ;number of ticks from last event
		$tempo=Round(($basetempo*$timebase/$move) , 2)
		;MsgBox(4096, "Tempo", $tempo , 10)
		$measure=INT(($time-$timebase)/($timebase*$bpmeasure))+1
		$beat=INT((($time-$timebase)-(($measure-1)*$timebase*$bpmeasure))/$timebase)+1
		If ($tempo < 8 or $tempo > 1000) then
			BlockInput(0)
			If MsgBox(17, "Tempo Error:", "The calculated tempo of " & $tempo & " (Measure " & $measure & ", Beat " & $beat & ") is out of range")<>1 Then Exit
			If @OSVersion <> "WIN_98" And @OSVersion <> "WIN_ME" Then
				BlockInput(1) ;block user input while script running
			EndIf
		Else ;enter new tempo at measure:beat	
			Send("!it")
			Send($tempo)
			Send("!it")
			Send($measure)
			Send(".")
			Send($beat)
			Send("{Enter}")
		EndIf

	EndIf
	
	$mark=$tick
	$i=Round($time/(($events-1)*$timebase)*100,0)
	ProgressSet( $i, "Progress Meter:  " & $i & "  percent")

next

Send("^{Home}") ;rewind to beginning
BlockInput(0) ;turn off block input
Exit

Func Fit_Improv_info()
	;make Fit Improv Info txt file if it doesn't exist
	If FileExists("Fit Improv ReadMe.txt")=0 Then
		$file=FileOpen("Fit Improv ReadMe.txt",1)
		FileWriteLine($file,"-record on a new midi track one note per beat of your audio track")
		FileWriteLine($file," (Fit Improv doesn't work with an improvised midi track yet)")
		FileWriteLine($file,"")
		FileWriteLine($file,"-close the synth rack, VST instrument windows, and Sonar help")
		FileWriteLine($file," (they get in the way)")
		FileWriteLine($file,"")
		FileWriteLine($file,"-select the midi track with the one note per beat that you recorded")
		FileWriteLine($file," (select the actual track, not just the clip)")
		FileWriteLine($file,"")
		FileWriteLine($file,"-run the 'Fit Improv' program")
		FileWriteLine($file,"")
		FileWriteLine($file,"-verify that the TIMEBASE (ticks per quarter note) = 960")
		FileWriteLine($file," --> check 'clock' tab in the project options dialogue, change value if required")
		FileWriteLine($file," --> project options dialogue will open & close itself")
		FileWriteLine($file,"")
		FileWriteLine($file,"-enter the number of Midi Events (Notes) that are to be processed")
		FileWriteLine($file,"")
		FileWriteLine($file,"To determine the number of midi events/notes:")
		FileWriteLine($file," --> double click the midi track to open the track properties dialogue")
		FileWriteLine($file," --> the number of events is noted on the top right")
		FileWriteLine($file," --> if used, the track properties dialogue will close itself")
		FileWriteLine($file,"")
		FileWriteLine($file,"-keyboard & mouse control will be blocked while the keystroke simulation is running")
		FileWriteLine($file,"")
		FileWriteLine($file,"Press OK if you are ready to proceed, CANCEL to quit")
		FileClose($file)
	EndIf
EndFunc


