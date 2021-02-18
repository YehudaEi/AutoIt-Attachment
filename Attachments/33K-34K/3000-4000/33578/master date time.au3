Global $D, $MD, $M, $H, $ND, $MIN, $FLAG = 0
$MD = @MDAY
Select
	Case $MD = "01"
		$MD = 1
	Case $MD = "02"
		$MD = 2
	Case $MD = "03"
		$MD = 3
	Case $MD = "04"
		$MD = 4
	Case $MD = "05"
		$MD = 5
	Case $MD = "06"
		$MD = 6
	Case $MD = "07"
		$MD = 7
	Case $MD = "08"
		$MD = 8
	Case $MD = "09"
		$MD = 9
EndSelect
$M = @MON
Select
	Case $M = "01"
		$M = "january"
	Case $M = "02"
		$M = "febuary"
	Case $M = "03"
		$M = "march"
	Case $M = "04"
		$M = "april"
	Case $M = "05"
		$M = "may"
	Case $M = "06"
		$M = "june"
	Case $M = "07"
		$M = "july "
	Case $M = "08"
		$M = "august"
	Case $M = "09"
		$M = "september"
	Case $M = "10"
		$M = "october"
	Case $M = "11"
		$M = "november"
	Case $M = "12"
		$M = "december"
EndSelect
$TIME = "the time is, "
$DATE = "today is , "
$H = @HOUR
$ND = "in the morning"
If $H >= 12 Then
	$H = $H - 12
	$ND = "in the evening"
EndIf
Select
	Case $H = "00"
		$H = 12
	Case $H = "01"
		$H = 1
	Case $H = "02"
		$H = 2
	Case $H = "03"
		$H = 3
	Case $H = "04"
		$H = 4
	Case $H = "05"
		$H = 5
	Case $H = "06"
		$H = 6
	Case $H = "07"
		$H = 7
	Case $H = "08"
		$H = 8
	Case $H = "09"
		$H = 9
EndSelect
$MIN = @MIN
Select
	Case $MIN = "00"
		$MIN = "oh clock"
	Case $MIN = "01"
		$MIN = "oh" & 1
	Case $MIN = "02"
		$MIN = "oh" & 2
	Case $MIN = "03"
		$MIN = "oh" & 3
	Case $MIN = "04"
		$MIN = "oh" & 4
	Case $MIN = "05"
		$MIN = "oh" & 5
	Case $MIN = "06"
		$MIN = "oh" & 6
	Case $MIN = "07"
		$MIN = "oh" & 7
	Case $MIN = "08"
		$MIN = "oh" & 8
	Case $MIN = "09"
		$MIN = "oh" & 9
EndSelect
If @HOUR = 0 And @MIN = 0 Then
	$H = "mid"
	$MIN = "night"
	$ND = ""
EndIf
If @HOUR = 12 And @MIN = 0 Then
	$H = "noon"
	$MIN = ""
	$ND = ""
EndIf
If @OSVersion <> "WIN_VISTA" Then
	If @OSVersion <> "WIN_XP" Then
		MsgBox(16, "Song", "You need Windows XP or above for this to work!" & @CRLF & "Sorry.")
		Exit
	EndIf
EndIf
Global $SPEACH = ObjCreate("Sapi.SPVoice")
$SPEACH.voice = $SPEACH.GetVoices("Name= Microsoft Mike" ).Item(0)
;$SPEACH.voice = $SPEACH.GetVoices("Name= Microsoft sam" ).Item(0)
Sleep(800)
$SPEACH.Rate = -6
$SPEACH.Speak($TIME & $H & " " & $MIN)
Sleep(100)
$SPEACH.Rate = 2
$SPEACH.Speak($ND)
Sleep(100)
$SPEACH.voice = $SPEACH.GetVoices("Name= Microsoft sam" ).Item(0)
$SPEACH.Rate = -4
$SPEACH.Speak( $DATE & $M & $MD )
$SPEACH.Speak("2011")
$SPEACH.SpeakCompleteEvent()

