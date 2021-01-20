#include <date.au3>
#include <File.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt ("TrayIconDebug", 1)

Global $standard, $military
Global $sPath, $amck, $pmck, $mil, $stan
Global $sCorrCode, $lpCnt = 0, $time
;~  main gui
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$main = GUICreate("Alarm Clock", 394, 214, 271, 185)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$hours = GUICtrlCreateCombo("", 24, 88, 41, 25)
	GUICtrlSetData(-1, "12|1|2|3|4|5|6|7|8|9|10|11")
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$AM = GUICtrlCreateCheckbox("AM", 176, 80, 97, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "AMClick")
$PM = GUICtrlCreateCheckbox("PM", 176, 112, 97, 17)
	GUICtrlSetOnEvent(-1, "PMClick")
$military = GUICtrlCreateCheckbox("24 Hour Time", 24, 32, 97, 17)
	GUICtrlSetOnEvent(-1, "militaryClick")
$standard = GUICtrlCreateCheckbox("12 Hour Time", 136, 32, 97, 17)
	GUICtrlSetOnEvent(-1, "standardClick")
	GUICtrlSetState(-1, $GUI_CHECKED)
$set = GUICtrlCreateButton("Set Alarm", 288, 104, 75, 25)
	GUICtrlSetOnEvent(-1, "setClick")
$Cancel = GUICtrlCreateButton("Cancel", 288, 144, 75, 25)
	GUICtrlSetOnEvent(-1, "Form1Close")
$folder = GUICtrlCreateButton("Select Folder", 288, 24, 75, 25)
	GUICtrlSetOnEvent(-1, "folderClick")
$min = GUICtrlCreateCombo("", 88, 89, 57, 25)
	GUICtrlSetData(-1, "00|05|10|15|20|25|30|35|40|45|50|55")
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel(":", 72, 88, 9, 24)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$setcode = GUICtrlCreateButton("Set Code", 288, 64, 75, 25, 0)
	GUICtrlSetOnEvent(-1, "setcodeClick")
	GUICtrlSetTip(-1, "Set the code to turn off the alarm")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep (10)
WEnd
;~  set the alarm
Func SetClick ()
	If $sPath = "" Then folderClick ()
	If $sCorrCode = "" Then setcodeClick ()
	GUISetState(@SW_HIDE, $main)
	$amck = GuiCtrlRead($am)
	$pmck = GUICtrlRead($pm)
	$hour = GUICtrlRead($hours)
	$mins = GUICtrlRead($min)
	$mil = GUICtrlRead($military)
	$stan = GUICtrlRead($standard)
	While 2
		If $stan = $GUI_CHECKED Then
			$CurrTime = _NowTime (3)
			If $amck = $GUI_CHECKED Then
				If $CurrTime >= $hour & ":" & $mins &  ":00 AM" And $CurrTime < $hour & ":" & $mins + 10 & ":00 AM"  Then
					$lpCnt += 1
					$Files = _FileListToArray ($sPath, "*.mp3")
					$Rand = Random (1, UBound($Files) - 1, 1)
					ShellExecute ($sPath & $Files[$Rand])
					_VolumeNOff ()
				EndIf
			Else
				If $CurrTime >= $hour & ":" & $mins &  ":00 PM" And $CurrTime < $hour & ":" & $mins + 10 & ":00 PM"  Then
					$lpCnt += 1
					$Files = _FileListToArray ($sPath, "*.mp3")
					$Rand = Random (1, UBound($Files) - 1, 1)
					ShellExecute ($sPath & $Files[$Rand])
					_VolumeNOff ()
				EndIf
			EndIf	
		ElseIf $mil = $GUI_CHECKED Then
			$CurrTime = _NowTime (5)
			If $CurrTime >= $hour & ":" & $mins &  ":00" And $CurrTime < $hour & ":" & $mins + 10 & ":00" Then
				$lpCnt += 1
				$Files = _FileListToArray ($sPath, "*.mp3")
				$Rand = Random (1, UBound($Files) - 1, 1)
				ShellExecute ($sPath & $Files[$Rand])
				_VolumeNOff ()
			EndIf
		EndIf
		Sleep (1000*30)
	WEnd	
EndFunc
;~  turns volume up every 5 secs until correct code is entered
Func _VolumeNOff ()
		For $n = 75 To 500 Step 10
			$i = $n
			If $lpCnt > 1 Then $i = 100
			SoundSetWaveVolume ($i)
			$code = InputBox ("Enter Alarm Code", "Enter the alarm code to shut this alarm off.", "", "", "", "", "", "", 5)
			If $code = $sCorrCode Then
				SoundSetWaveVolume (50)
				Exit
			EndIf
		Next
		SetClick ()
EndFunc 	

Func standardClick ()
	$read = GUICtrlRead($standard)
	If $read = $GUI_CHECKED Then 
		GUICtrlSetState ($military, $GUI_UNCHECKED)
		GUICtrlSetData ($hours, "")
		GUICtrlSetData ($hours, "12|1|2|3|4|5|6|7|8|9|10|11")
		GuiCtrlSetState ($am, $GUI_ENABLE)
		GuiCtrlSetState ($pm, $GUI_ENABLE)
	EndIf	
EndFunc

Func militaryClick ()
	$read = GUICtrlRead($military)
		If $read = $GUI_CHECKED Then 
			GUICtrlSetState ($standard, $GUI_UNCHECKED)
			GUICtrlSetData ($hours, "")
			GUICtrlSetData ($hours, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23")
			GuiCtrlSetState ($am, $GUI_DISABLE)
			GuiCtrlSetState ($pm, $GUI_DISABLE)
		EndIf
EndFunc		

Func AMClick ()
	$read = GUICtrlRead($am)
	If $read = $GUI_CHECKED Then GUICtrlSetState($pm, $GUI_UNCHECKED)
EndFunc

Func PMClick ()
	$read = GUICtrlRead($pm)
	If $read = $GUI_CHECKED Then GUICtrlSetState($am, $GUI_UNCHECKED)
EndFunc
;~  select folder for music
Func folderClick ()
	$sPath = FileSelectFolder("Select Where Your Music Folder Is Located", "",2) & "\"
	If $sPath = "\" Then 
		Do 
			$sPath = FileSelectFolder("Select Folder", "",2) & "\"
		Until $sPath > "\"	
	EndIf	
EndFunc	
;~  set code gui
Func setcodeClick ()
	#Region ### START Koda GUI section ### Form=
	Global $spc = GUICreate("Set Pass Code", 316, 212, 197, 133, -1, -1, $main)
		GUISetOnEvent($GUI_EVENT_CLOSE, "spcClose")
	Global $pi = GUICtrlCreateCheckbox("Pi to the Hundreth Digit", 32, 24, 137, 17)
		GUICtrlSetOnEvent(-1, "piClick")
	Global $prime = GUICtrlCreateCheckbox("11 Digit Prime Number", 32, 56, 129, 17)
		GUICtrlSetOnEvent(-1, "primeClick")
	Global $customcode = GUICtrlCreateInput("", 88, 96, 201, 21)
	GUICtrlCreateLabel("Custom:", 32, 96, 42, 17)
	Global $ok = GUICtrlCreateButton("OK", 120, 152, 75, 25, 0)
		GUICtrlSetOnEvent(-1, "okClick")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
EndFunc	

Func primeClick ()
	$read = GUICtrlRead($prime)
	If $read = $GUI_CHECKED Then GUICtrlSetState($pi, $GUI_UNCHECKED)
EndFunc

Func piClick ()
	$read = GUICtrlRead($pi)
	If $read = $GUI_CHECKED Then GUICtrlSetState($prime, $GUI_UNCHECKED)
EndFunc

Func okClick ()
	If GUICtrlRead($pi) = $GUI_CHECKED Then $sCorrCode = "3." & _
				"14159265358979323846264338327950288419716939937510" & _
				"58209749445923078164062862089986280348253421170679"
	If GUICtrlRead($prime) = $GUI_CHECKED Then $sCorrCode = "99999999977"
	If GUICtrlRead($customcode) <> "" Then $sCorrCode = GUICtrlRead($customcode)
	GUISetState(@SW_HIDE, $spc)
EndFunc	

Func spcClose ()
	GUISetState(@SW_HIDE, $spc)
EndFunc

Func Form1Close ()
	Exit
EndFunc	