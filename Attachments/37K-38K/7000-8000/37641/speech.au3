Global $h_Context = ObjCreate("SAPI.SpInProcRecoContext") 
Global $h_Recognizer = $h_Context.Recognizer 
Global $h_Grammar = $h_Context.CreateGrammar(1) 
$h_Grammar.Dictationload 
$h_Grammar.DictationSetState(1)
Global $voice = ObjCreate("SAPI.SpVoice")
global $text = 0
Global $times = 0
Global $times2 = 1
Global $PF = @ProgramFilesDir

;Create a token for the default audio input device and set it 
Global $h_Category = ObjCreate("SAPI.SpObjectTokenCategory") 
$h_Category.SetId("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\AudioInput\TokenEnums\MMAudioIn\") 
Global $h_Token = ObjCreate("SAPI.SpObjectToken") 
$h_Token.SetId("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech\AudioInput\TokenEnums\MMAudioIn\") 
$h_Recognizer.AudioInput = $h_Token 
Global $i_ObjInitialized = 0 
Global $h_ObjectEvents = ObjEvent($h_Context, "SpRecEvent_") 
If @error Then     
	ConsoleWrite("ObjEvent error: " & @error & @CRLF)     
$i_ObjInitialized = 0 
Else     
	ConsoleWrite("ObjEvent created Successfully!" & @CRLF)     
$i_ObjInitialized = 1 
EndIf 
While $i_ObjInitialized     
	Sleep(5000)     ;Allow the Audio In to finalize processing on the last 5 second capture     
	$h_Context.Pause     ;Resume audio in processing     
	$h_Context.Resume     ;Reset event function allocation (what is this? I think its garbage collection or something, needs clarification)     
	$h_ObjectEvents = ObjEvent($h_Context, "SpRecEvent_") 
WEnd 
Func SpRecEvent_Hypothesis($StreamNumber, $StreamPosition, $Result)     
	ConsoleWrite("Hypothesis(): Hypothized text is: " & $Result.PhraseInfo.GetText & @CRLF) 
EndFunc ;==>SpRecEvent_Hypothesis 

Func SpRecEvent_Recognition($StreamNumber, $StreamPosition, $RecognitionType, $Result)     
	ConsoleWrite($RecognitionType & "||" & $Result.PhraseInfo.GetText & @CRLF)
	if $Result.PhraseInfo.GetText = "jarvis" and $times = not 1 Then
	call("jarvis")
	EndIf
	if $times = 1 and $times2 = 0 Then
		$q1 = $Result.PhraseInfo.GetText;InputBox("question for jarvis", "")
		call("Aknowledge",$q1)
	EndIf
EndFunc ;==>SpRecEvent_Recognition 

Func SpRecEvent_SoundStart($StreamNumber, $StreamPosition)     
	ConsoleWrite("Sound Started" & @CRLF) 

EndFunc ;==>SpRecEvent_SoundStart 

Func SpRecEvent_SoundEnd($StreamNumber, $StreamPosition)     
	ConsoleWrite("Sound Ended" & @CRLF) 
EndFunc ;==>SpRecEvent_SoundEnd


func jarvis()
$string = "Sir?"
$Voice.Speak($string,11)
Sleep(500)
$times = 1
$times2 = 0
;$q1 = $Result.PhraseInfo.GetText;InputBox("question for jarvis", "")
;call("Aknowledge",$q1)
EndFunc

func aknowledge($q1)
Select
case $q1 = "Open mail"
   Call("open_mail")
case $q1 = "Close mail"
   call("close_mail")
case $q1 = "get time"
   $text = ", the time is " & @hour & " hours " & @min & " minutes"
   $times2 = 1
case $q1 = "get date"
   call("get_date")
case $q1 = "goodbye"
   call("Good_bye")
case $q1 = "go to sleep"
   $text = "going to sleep"
case $q1 = "start team speak"
	  call("open_teamspeak")
case $q1 = "close team speak"
	  call("close_teamspeak")
case $q1 = "lights on all"
		Call("Lights_on_all")
case $q1 = "lights off all"
		call("Lights_off_all") 	
case $q1 = ""
	 $text = "sorry you haven't specified what you wanted from me"
 EndSelect
if $text = not 0 then 
$string = "of course Sir " & $text
$Voice.Speak($string,11)
Sleep(2000)
$times = 0
endif
;select
;case $q1 = "good bye"
;exit
;case $q1 = "go to sleep"
;WinSetState("J.A.R.V.I.S 1.0 Beta","" ,@SW_MINIMIZE)
;EndSelect   
$q1 = 0
$text = 0
EndFunc

func good_bye()
$t1 = @HOUR
select
	case $t1 >= 12 and $t1 < 18
		$text = "have a nice afternoon"
	case	$t1 < 12 and $t1 > 5
		$text = "have a nice day"
	case $t1 > 18 and $t1 < 23	
		$text = "have a pleasant night"
EndSelect
$times2 = 1	
;MsgBox(0, "test", $text) ; encoutered problems with $text variable
; the variable doesn't get returned to the speech part
;made variable $text a global and this resolved the problem
   endfunc	
func open_mail()
	$text = "opening your'e mail now"
	run("C:\Program Files (x86)\Microsoft Office\Office14\OUTLOOK.exe")
	winwaitactive("Inbox")
	$times2 = 1
 EndFunc
 
func close_mail()
$p1 =ProcessExists("OUTLOOK.EXE")
if $p1 = 0 Then
	$text = ", you have no mail programm running"
else 
   $text = "closing your'e mail"
   ProcessClose("OUTLOOK.EXE")
EndIf
$times2 = 1
EndFunc

func open_teamspeak()
   $text = "starting Team Speak"
   ;run($PF &"\FalNET G19 Display Manager\FalNET G19 Display Manager.exe")
   WinWaitActive("FalNET G19 Display Manager", "")
   WinSetState("FalNET G19 Display Manager", "",@SW_MINIMIZE)
   run($PF &"\TeamSpeak 3 Client\ts3client_win64.exe")
   WinWaitActive("TeamSpeak 3", "")
   Send("^s")
   WinWaitActive("Connect", "")
   send("{enter}")
$times2 = 1
EndFunc

func close_teamspeak()
$text = "closing Team Speak"
$p1 = ProcessExists("ts3client_win64.exe")
$p2 = ProcessExists("FalNET G19 Display Manager.exe")
if $p1 = 0 Then
   $text = "no Team Speak running"
Else 
   ProcessClose("ts3client_win64.exe")
   ;WinSetState("TeamSpeak3", " ",@sw_show)
   
EndIf 
if $p2 = 0 then 
Else
   ProcessClose("FalNET G19 Display Manager.exe")
EndIf
$times2 = 1
EndFunc
func get_date()
$year = @YEAR	
$month1 =@MON 
$day1 = @MDAY
$day2 = @WDAY
; converting day number to the name of that day
Select 
Case $day2 = 1
   $day3 = "Sunday"
Case $day2 = 2
   $day3 = "monday"
case $day2 = 3
   $day3 = "Tuesday"
case $day2 = 4
   $day3 = "wensday"			
Case $day2 = 5
   $day3 = "Thursday"
Case $day2 = 6
   $day3 = "Friday"
case $day2 = 7
   $day3 = "Saturday"
EndSelect

;converting number of month to name of that month
Select
Case $month1 = 01
   $month2 = "January"
Case $month1 = 02
   $month2 = "February"
Case $month1 = 03
   $month2 = "March"
Case $month1 = 04
   $month2 = "April"
Case $month1 = 05
   $month2 = "May"
Case $month1 = 06
   $month2 = "June"
Case $month1 = 07
   $month2 = "July"
Case $month1 = 08
   $month2 = "August"
Case $month1 = 09
   $month2 = "September"
Case $month1 = 10
   $month2 = "October"
Case $month1 = 11
   $month2 = "November"
Case $month1 = 12
   $month2 = "December"
EndSelect   
$text = "The date is: " & $day3 & " "& $day1 & " of " & $month2 & " " & $year
$times2 = 1
EndFunc

; the Lights functions will grow when i figured out how to
; combine this programm with my lighting scheme
func Lights_on_all()
$text = " Turning all lights on" 
EndFunc	

func Lights_off_all()
$text = " turning all lights off"
EndFunc