#cs
TODO:
-. make alarm integrate with volume control.
-. save-lists/load-lists.
BUGS:
-. move the elements with'in the table, use another mathode!
-. add-dir - also subdirs! (_GUICtrlListAddDir !?)
-. currently playing label (add abilities to use filename and so...)
-. Add tooltips to buttons.
-. Make the GUI look more nifty (:
-. 
CHANGE LOG:
-* V0.4
-. volume control. [SoundSetWaveVolume(50)[wave volume]]
-. [m] - mute button.
-* V0.3
-. Fixed Audio Control - Check integration with Alarm!
-. Fixed TimerLabel location - now in middle of Slider.
#ce

#include <Constants.au3>
#Include <Date.au3>
#include <Misc.au3>
#include <GUIConstants.au3>
#Include <GuiList.au3>
#Include <GuiSlider.au3>
#include <Sound.au3>
#Include <File.au3>
#Include <Array.au3>
#NoTrayIcon
Opt("TrayIconHide",1)
Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1)

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("SK's Alarm Clock V0.4", 421, 340, 193, 115)
$HH = GUICtrlCreateCombo("HH", 304, 56, 41, 25)
GUICtrlSetData(-1,"00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23","MM")
$MM = GUICtrlCreateCombo("MM", 344, 56, 41, 25)
GUICtrlSetData(-1,"00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59","MM")
$AlarmG = GUICtrlCreateGroup("Alarm Time Settings:", 288, 32, 113, 57)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$DateG = GUICtrlCreateGroup("Current Time & Date:", 16, 32, 249, 57)

$Time_Date = GUICtrlCreateLabel(_NowDate() & " " & _NowTime(5), 40, 56, 105, 17)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$MusicList = GUICtrlCreateList("", 24, 110, 369, 115,BitOr($WS_BORDER,$WS_VSCROLL,$LBS_USETABSTOPS,$LBS_NOTIFY))

$PlayB = GUICtrlCreateButton(">", 104, 223, 25,20)
$StopB = GUICtrlCreateButton("[]", 24, 223, 25,20)
$PouseB = GUICtrlCreateButton("||", 77, 223, 25,20)
$PrevB = GUICtrlCreateButton("<<", 51, 223, 25,20)
$NextB = GUICtrlCreateButton(">>", 129, 223, 25,20)
$SeekB = GUICtrlCreateSlider(155,223,100,20)
GUICtrlSetLimit($SeekB,100,0)
$TimerLable = GUICtrlCreateLabel("",190,247,60,20)

$AddFile = GUICtrlCreateButton("+File", 24, 246, 36,20)
$AddDir = GUICtrlCreateButton("+Dir", 61, 246, 36,20)
$ClearList = GUICtrlCreateButton("Clear List", 98, 246, 57,20)
$RepeatB = GUICtrlCreateButton("R", 373, 223, 20,20)
$ShuffelB = GUICtrlCreateButton("s", 353, 223, 20,20)

$MuteB = GUICtrlCreateButton("m", 260, 223, 20,20)
$WVolumeB = GUICtrlCreateSlider(279, 220,20,38,BitOR($TBS_VERT,$TBS_BOTH,$GUI_DOCKAUTO))
GUICtrlSetLimit($WVolumeB,100,0)
$VolumeL = GUICtrlCreateLabel("Volume",275,255,60,20)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
;$WVolumeB = GUICtrlCreateSlider(312, 220,20,38,BitOR($TBS_VERT,$GUI_DOCKAUTO))
;GUICtrlSetLimit($WVolumeB,100,0)

$AlarmSet = GUICtrlCreateButton("Alarm Set", 333, 246, 60,20)
$ProgressTimer = GUICtrlCreateProgress(24, 284, 369, 12)
GUICtrlSetData(-1, 0)
$ProgressTimerL = GUICtrlCreateLabel("", 24, 297, 369, 12)
$ListG = GUICtrlCreateGroup("Music Files Entery:", 16, 95, 385, 175)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Title = GUICtrlCreateLabel("SK's Alarm Clock", 104, 0, 181, 28)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000080)

$TM = GUICtrlCreateLabel("(TM) Shlomi Kalfa, Kishinev 2006", 0, 320, 160, 17)
GUICtrlSetFont(-1, 4, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x9DB9EB)

GUISetState(@SW_SHOW)
;================= TRAY MANUE ====================
$Exit = TrayCreateItem("Exit")
TraySetClick (8)
#EndRegion ### END Koda GUI section ###

Global $AlarmTimer = "Nil"
Global $AlarmOn = "Nil"
Global $timer = "Nil"
Global $TimerS = "Nil"
Global $ProgressBarInit = "Nil"
Global $ListItem1 = "Nil"
Global $ListItem2 = "Nil"
Global $Playinit = True
Global $FileLenghmili = "0"
Global $FileLengh = "NIL"
Global $FileTimer = 0
Global $Repeat = True
Global $Shuffel = False
Global $PlayFiles = 0
Global $IndexFile = 0
Global $NowPlaying = "NIL"
Global $PousedPlay = False
Global $FileLoading = False
Global $SliderBand,$MiliSeeked,$SongBand
Global $Muted = False
Global $WVolume = "%"
Global $changeVolume = False

While 1
	;deletes the marked list item by pressing delete key.
	If _IsPressed("2E") = 1 Then
		_GUICtrlListDeleteItem($MusicList, _GUICtrlListSelectedIndex($MusicList))
	EndIf
	
	;Changes the order of items inside the table. ;Hacked up script - think of something. (maybe use on event.)
	If _IsPressed("01") = 1 Then
		If $ListItem1 = "Nil" Then
			Global $ListItem1 = _GUICtrlListSelectedIndex($MusicList)
		Else
			Global $ListItem2 = _GUICtrlListSelectedIndex($MusicList)
			If $ListItem1<>"Nil" And $ListItem2<>"Nil" And $ListItem1<>$ListItem2 Then
				_GUICtrlListSwapString($MusicList,$ListItem1,$ListItem2)
				_GUICtrlListSelectIndex($MusicList,$ListItem2)
				Global $ListItem1 = "Nil"
				Global $ListItem2 = "Nil"
			EndIf
		EndIf
	Else
		Global $ListItem1 = "Nil"
		Global $ListItem2 = "Nil"
	EndIf
	
	$tMsg = TrayGetMsg()
	$nMsg = GUIGetMsg()

	Select
;================================================Player Controls.
		Case $tMsg = $Exit
			Exit
		Case $nMsg = $GUI_EVENT_CLOSE
			Exit
		Case $nMsg = $GUI_EVENT_MINIMIZE
			GUISetState(@SW_HIDE,$Form1)
			Opt("TrayIconHide",0)
			Traytip("Sk's Alarm Notification","Dear user i'm here",3)
			TraySetToolTip("Single click for details" & @CRLF & "Double Click To Maximize")
		Case $tMsg = $TRAY_EVENT_PRIMARYDOUBLE
			GUISetState(@SW_SHOW,$Form1)
			Opt("TrayIconHide",1)
		Case $tMsg = $TRAY_EVENT_PRIMARYDOWN
			Traytip("Sk's Alarm Notification:",GUICtrlRead($ProgressTimerL),7,1)
			;play - button has been pressed.
		Case $nMsg = $MuteB
			Send("{VOLUME_MUTE}")
				If ($Muted) Then
					GUICtrlSetData($MuteB,"m")
					$Muted = False
				Else
					GUICtrlSetData($MuteB,"M")
					$Muted = True
				EndIf

		Case $nMsg = $WVolumeB
			$changeVolume = True
			$WVolume = 100-(GUICtrlRead($WVolumeB))
			SoundSetWaveVolume($WVolume)
			GUICtrlSetData($VolumeL,"Vol' "&$WVolume&"%")
			$changeVolume = False
		
		Case $nMsg = $PlayB
			Playfile(_GUICtrlListSelectedIndex($MusicList))
		Case $nMsg = $StopB
			_SoundStop($NowPlaying)
		Case $nMsg = $PouseB
			If($PousedPlay) Then
				$PousedPlay = False
				_SoundResume($NowPlaying)
			Else
				$PousedPlay = True
				_SoundPause($NowPlaying)
			EndIf
		Case $nMsg = $NextB
			Playfile(_GUICtrlListSelectedIndex($MusicList)+1)
		Case $nMsg = $PrevB
			Playfile(_GUICtrlListSelectedIndex($MusicList)-1)
		Case $nMsg = $SeekB
			$Position = GUICtrlRead($SeekB)
			Seek($Position)
		Case $nMsg = $RepeatB
			If ($Repeat) Then
				$Repeat = False
				GUICtrlSetData($RepeatB,"r")
			Else
				$Repeat = True
				GUICtrlSetData($RepeatB,"R")
			EndIf
		Case $nMsg = $ShuffelB
			If ($Shuffel) Then
				$Shuffel = False
				GUICtrlSetData($ShuffelB,"s")
			Else
				$Shuffel = True
				GUICtrlSetData($ShuffelB,"S")
			EndIf
;================================================Alarm Controls.
		Case $nMsg = $AddDir
			$Dir = FileSelectFolder("Add files to playlist", "", 1+2+4,"")
			$Subfolders = _FileListToArray($Dir,"*.*",2)
			$FileList=_FileListToArray($Dir,"*.mp3",1)
			AddToPlaylist($FileList,$Dir)
		;Add File - button has been pressed.
		Case $nMsg = $AddFile
			$FileLoading = True
			$files = StringSplit(FileOpenDialog("Add files to playlist", "", "Music Files (*.mp3;*.wav)",1+2+4),"|")
			AddToPlaylist($files,$files[1])
			$FileLoading = False
			
		;Clean List - button has been pressed.
		Case $nMsg = $ClearList
			_GUICtrlListClear($MusicList)
			
		;Alarm Set - button has been pressed.
		Case $nMsg = $AlarmSet
			;checks to see if there are any files to play, if not abort.
			If _GUICtrlListCount($MusicList)<1 Then
				GUICtrlSetData($ProgressTimerL, "There are no files to play!")
			Else
				GUICtrlSetData($AlarmSet,"Re-Set!")
				Global $AlarmTimer = GUICtrlRead($HH) & ":" & GUICtrlRead($MM)
				Global $ProgressBarInit = "Nil"
				Call("UpdatetimeDiff")
			EndIf

;================================================Functional Cases.
		;Alarm Time is reached (sets it on so it won't stop after 1 minute).
		Case $AlarmTimer == _NowTime(4)
			;MsgBox(1,"debug","AlarmTimer")
			Global $AlarmOn = 1
			
		;Refreshes every 1 second.
		Case StringRight(_NowTime(5), 2)<> $timerS
			$timerS = StringRight(_NowTime(5), 2)
			GUICtrlSetData($Time_Date,_NowDate() & " " & _NowTime(5))
			;MsgBox(1,"debug",$NowPlaying)
			If $NowPlaying <> "NIL" Then
				UpdateSlider(_SoundPos($NowPlaying,2))
			EndIf
			If $changeVolume = False Then GUICtrlSetData($VolumeL,"Volume")
			
		;Refreshes every 1 minute.
		Case _NowTime(4) <> $timer
			Global $timer = _NowTime(4)
			if $AlarmTimer <> "Nil" Then
				Call("UpdatetimeDiff")
			EndIf
			
		;Checks if the alarm in on, if so plays the music.
		Case $AlarmOn = 1
			;MsgBox(1,"debug","AlarmOn")
			$PlayFiles = _GUICtrlListCount($MusicList)
			;MsgBox(1,"debug","number of files: " & $PlayFiles)
			
			If $PlayFiles>0 Then
				;checks if it's first file play.
				If ($Playinit) Then
					$Playinit = False
					$IndexFile = 0
					Playfile($IndexFile)
				Else
					;Checks if previous song is finished playing.
					If TimerDiff($FileTimer)>$FileLenghmili Then
						CloseSession()
						$IndexFile = $IndexFile+1
						;Makes sure it won't try playing songs that arn't in list.
						If $IndexFile>$Playfiles Then
							;Enables the use of 'Repeat'.
							If ($Repeat) Then
								$Playinit=True
								Playfile($IndexFile)
							Else
								$AlarmOn=0
							EndIf
						EndIf
						Playfile($IndexFile)
					EndIf
				EndIf
			Else
				GUICtrlSetData($ProgressTimerL, "Alarm Play-list is empty. Alarm Canceled !")
				Global $AlarmOn = "Nil"
				Global $AlarmTimer = "Nil"
			EndIf
			;
	EndSelect
WEnd

Func UpdatetimeDiff()
	;Calculates the time diffrence using:
	;first 2 letters of clock format: HH:MM, (eg. 02-13)
	$NowHH = StringLeft(_NowTime(4),2)
	$AlarmHH = GUICtrlRead($HH)
	$NowMM = StringRight(_NowTime(4),2)
	$AlarmMM = GUICtrlRead($MM)
	
	;Will calculate exactly how many hours between current time and the alarm time.
	If $NowHH > $AlarmHH Then
		$timedifHH = $NowHH - $AlarmHH
		$HHwait = 24 - $timedifHH
	Else
		$timedifHH = $AlarmHH - $NowHH
		$HHwait = $timedifHH
	EndIf
	
	;Will calculate exactly how many minutes between current time and the alarm time.
	If $NowMM > $AlarmMM Then
		$timedifMM = $NowMM - $AlarmMM
		$MMwait = 60 - $timedifMM
		;Will substract/add hours to the HHwait according to minutes diffrences.
		If $HHwait = 0 Then
			$HHwait = 23
		Else
			$HHwait = $HHwait-1
		EndIf
	Else
		$timedifMM = $AlarmMM - $NowMM
		$MMwait = $timedifMM
	EndIf

	;Refreshes the "Progress Timer Label" accourdingly.
	If $HHwait<>0 And $MMwait<>0 Then
		GUICtrlSetData($ProgressTimerL, "Alarm starts in " & $HHwait & " hours and " & $MMwait & " minutes")
	ElseIf $HHwait<> 0  And $MMwait == 0 Then
		GUICtrlSetData($ProgressTimerL, "Alarm starts in " & $HHwait & " hours")
	ElseIf $HHwait==0 And $MMwait<>0 Then
		GUICtrlSetData($ProgressTimerL, "Alarm starts in " & $MMwait & " minutes")
	EndIf
	
	;sets the initial 100% of progress bar OR changes the data on progress bar.
	If $ProgressBarInit = "Nil" Then
		GUICtrlSetData($ProgressTimer,0)
		Global $ProgressBarInit = ($HHwait * 60) + $MMwait
	Else
		$NowT2M = ($HHwait * 60) + $MMwait
		$precent = ($NowT2M*100)/$ProgressBarInit
		If $precent = 0 Then
			$precent = 1
		Else
			$precent = 100 - $precent
		EndIf
		GUICtrlSetData($ProgressTimer,$precent)
	EndIf
EndFunc

Func Playfile($i)
	CloseSession()
	If ($Shuffel) Then
		$i = Random(0,$PlayFiles,1)
	EndIf
	If (FileExists(_GUICtrlListGetText($MusicList, $i))) Then
		$NowPlaying = _SoundOpen(_GUICtrlListGetText($MusicList, $i))
		$FileLenghmili = _SoundLength($NowPlaying,2)
		$SongBand = $FileLenghmili/100
		$FileLengh = _SoundLength($NowPlaying,1)
		$FileTimer = TimerInit()
		$Playing = _SoundPlay($NowPlaying,0)
		If $Playing = 1 Then
			GUICtrlSetData($ProgressTimerL, "Currently Playing: " & _GUICtrlListGetText($MusicList, $i))
		Else
			GUICtrlSetData($ProgressTimerL, "Error; Can't Play File! '_SoundPlay' issue.")
		EndIf
	EndIf
EndFunc

;Seeking Through The Song.
;Param- Seeking Slider Location (1-100)
Func Seek($SliderBand)
	Dim $STime
	$MiliSeeked = $SongBand * $SliderBand
	$LabledTime = Mili2Time($MiliSeeked)
	$STime = stringsplit($LabledTime,":")
	;MSG($LabledTime,0)
	$Seeked = _SoundSeek($NowPlaying,$STime[1],$STime[2],$STime[3])
	_SoundPlay($NowPlaying,0)
	$CurrentmiliTime = _SoundPos($NowPlaying,2)
	UpdateSlider($CurrentmiliTime)
EndFunc

Func UpdateSlider($CurrentmiliTime)
	$LabledTime = _SoundPos($NowPlaying,1)
	If stringleft($LabledTime,2) = 00 Then
		GUICtrlSetData($TimerLable,stringright($LabledTime,5))
	Else
		GUICtrlSetData($TimerLable,$LabledTime)
	EndIf
	If (( Not $FileLoading) And (_IsPressed("01")= 0)) Then
		GUICtrlSetData($SeekB,$CurrentmiliTime/$SongBand)
	EndIf
EndFunc

Func CloseSession()
	_SoundClose($NowPlaying)
	$SongBand = 0
	$FileTimer = 0
	$FileLenghmili = 0
	$FileLengh = 0
	$SeekedTimer = 0
	$NowPlaying = "NIL"
	$PousedPlay = False
	$FileLoading = False
	$SliderBand = 0
	$MiliSeeked = 0
EndFunc
#cs
	$iMs += $iSec*1000
	$iMs += $iMin*60*1000
	$iMs += $iHour*60*60*1000
#ce

;Transforms time from mili secs into real time HH,MM,SS Format
;Use: $VAR = stringsplit(Mili2Time($MiliVAR),"|") ;to get the data as $VAR[1]=HH,$VAR[2]=MM,$VAR[3]=SS
Func Mili2Time($MiliTime)
	$RTimeS = Int($MiliTime / 1000)
	$RTimeM = 0
	$RTimeH = 0
	While ($RTimeS/60)>1
		$RTimeS = $RTimeS - 60
		$RTimeM = $RTimeM + 1
	WEnd
	While ($RTimeM/60)>1
		$RTimeM = $RTimeM - 60
		$RTimeH = $RTimeH + 1
	WEnd
	If $RTimeS < 10 Then
		$RTimeS = "0" & $RTimeS
	EndIf
	If $RTimeM < 10 Then
		$RTimeM = "0" & $RTimeM
	EndIf
	If $RTimeH < 10 Then
		$RTimeH = "0" & $RTimeH
	EndIf
	return $RTimeH & ":" & $RTimeM & ":" & $RTimeS
EndFunc

Func AddToPlaylist($Filestoadd,$Directory)
	if $Filestoadd[0]>1 Then
		$i = 1
		Do
			If (Not $Filestoadd[$i+1] = "") Then
				_GUICtrlListAddItem($MusicList,$Directory & "\" & $Filestoadd[$i+1])
			EndIf
			$i = $i+1
		Until $i = $Filestoadd[0]
	ElseIf $Filestoadd[0] = 1 Then
		_GUICtrlListAddItem($MusicList,$Filestoadd[1])
	EndIf
EndFunc

Func MSG($MESSAGE,$Wait)
	if ($Wait) Then
		MsgBox(64 + 262144, "", $MESSAGE, 3)
	Else
		MsgBox(64 + 262144, "", $MESSAGE)
	EndIf
EndFunc   ;==>Message