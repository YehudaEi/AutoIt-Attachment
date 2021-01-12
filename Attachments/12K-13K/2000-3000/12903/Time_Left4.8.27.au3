#CS
________________________________
	Adam1213™ -                   
	Release date: 14/1/07 (warning program one of my early programs, that has just been updated (reformated)  not re-written
________________________________
#CE
$lsnc=""
global $extrat="", $extrat2=""

#include <Process.au3>
#include <GUIConstants.au3>
#include <Date.au3>

Opt("GUIOnEventMode", 1)
;Opt("GUICloseOnESC", 0)         ;1=ESC  closes, 0=ESC won't close

$showp=10
$showp2=10

global $c=""
global $u11=-1

$disp111="|"

Dim $run
Dim $regplace

$runloop = "no"
$regplace = "HKEY_LOCAL_MACHINE\SOFTWARE\Adam1213 Software\Time Left"

HotKeySet("{f2}", "onkeyset2")
HotKeySet("^{F3}", "onhide")
HotKeySet("^{F4}", "restart")
$pause = "no"

$old_string = ""

$startprogad=50

$lhour = "00"
$lmin = "00"
$lsec = "00"

$state1 = ""
$left = ""

$up1 = ""
$up2 = ""

$settingsdisplayed = "no"

$defaultset = "12:00"
$defaultpod = "AM"

$startset = RegRead($regplace, "1 Default Time")
If "t" & $startset = "t" Then
	$startset = $defaultset
EndIf

$startpod = RegRead($regplace, "2 Default Part of day")
If "t" & $startpod = "t" Then
	$startpod = $defaultpod
EndIf
;____________________________________________________________________________-
$offset = RegRead($regplace, "3 Time Difference")
If "t" & $offset = "t" Then
	$offset = "no"
	RegWrite($regplace, "3 Time Difference", "REG_SZ", $offset)
EndIf

$trayi = RegRead($regplace, "4 Tray icon")
If "t" & $trayi = "t" Then
	$trayi = "yes"
	RegWrite($regplace, "4 Tray icon", "REG_SZ", $trayi)
EndIf

$guitop = RegRead($regplace, "5 GUI always on top")
If "t" & $guitop = "t" Then
	$guitop = "no"
	RegWrite($regplace, "5 GUI always on top", "REG_SZ", $guitop)
EndIf

$progad = 60 * $startprogad

If $offset = "yes" Then
	$up1 = "7"
	$up2 = "13"
EndIf

$tdiffm = RegRead($regplace, "Time Difference Mins")
If "t" & $tdiffm = "t" Then
	$tdiffm = "1"
	RegWrite($regplace, "Time Difference Mins", "REG_SZ", $tdiffm)
EndIf

$tdiffs = RegRead($regplace, "Time Difference Secs")
If "t" & $tdiffs = "t" Then
	$tdiffs = "21"
	RegWrite($regplace, "Time Difference Secs", "REG_SZ", $tdiffs)
EndIf

$tdiffas = RegRead($regplace, "Time Difference add or sub")
If "t" & $tdiffas = "t" Then
	$tdiffas = "add"
	RegWrite($regplace, "Time Difference add or sub", "REG_SZ", $tdiffas)
EndIf

$tdiff = $tdiffs + $tdiffm * 60
$tdiff = $tdiff * 1000

If $tdiffas = "add" Then $tdiff = -$tdiff

$timeoff = "0"
$lthour = "00"
$ltmin = "00"
$ltsec = "00"

;----------- valdadation variables -------------------
$last = "a"
$dtemp = ""

;GUICreate("Time Left",148,145,-1,-1, -1, $WS_EX_TOOLWINDOW,$WS_EX_TOOLWINDOW )
$MyGUI1 = GUICreate("Time Left", 148, 170)

onpicktime()

$progresslabel = GUICtrlCreateLabel("xx%", 1, 147, 25, 25,-1,$WS_EX_TRANSPARENT)
$progressbar1 = GUICtrlCreateProgress(25, 147, 120, 17,-1,$WS_EX_TRANSPARENT)

; ---------------- Title--------------------------
GUICtrlCreateLabel("Time left", 10, 5, 87, 25)
GUICtrlSetBkColor(-1, 0x00ff00) ; Green
GUICtrlSetFont(-1, 17, 40, 4)

;----------------------- Buttons and group ---------------------
$groupid = GUICtrlCreateGroup("Info", 3, 40 - $up1, 140, 70 + $up1)

$program2ID = GUICtrlCreateButton("Program", 100, 4, 45, 30)
GUICtrlSetOnEvent($program2ID, "Onprogram")

$nowid = GUICtrlCreateLabel("Current time:", 10, 60 - $up2, 130, 12)
GUICtrlSetTip(-1, "Current Time")
$nowofid = GUICtrlCreateLabel("Offset   time: ", 10, 61, 130, 12)
$waitforid = GUICtrlCreateLabel("Waiting for: ", 10, 75, 130, 12)
GUICtrlSetTip(-1, "Time to wait for")

$leftid = GUICtrlCreateLabel("Time left: ", 10, 87, 130, 20)
GUICtrlSetFont(-1, 12, 40, 0, "Times New Roman Bold")

$settingsID = GUICtrlCreateButton("Settings", 100, 4, 45, 30)
GUICtrlSetOnEvent($settingsID, "Onsettings")

$time2id = GUICtrlCreateInput($startset, 5, 120, 35, 20)
GUICtrlSetTip(-1, "Time to wait for")
GUICtrlSetLimit($time2id, 5)

$partofdid = GUICtrlCreateCombo("AM", 42, 120, 39, 20)
GUICtrlSetData(-1, "PM", $startpod)

GUICtrlSetLimit($partofdid, 1)

$setID = GUICtrlCreateButton("Set", 83, 120, 33, 20)
GUICtrlSetOnEvent($setID, "Onset")

$hideID = GUICtrlCreateButton("Hide", 115, 120, 30, 20)
GUICtrlSetOnEvent($hideID, "Onhide")

; --------------- Settings display --------------


$groupsid = GUICtrlCreateGroup("Settings", 3, 30, 140, 110)

$checkbox_topmost = GUICtrlCreateCheckbox("Always On Top", 10, 43, 100, 18)

If $guitop = "yes" Then
	$state = $GUI_CHECKED
Else
	$state = $GUI_UNCHECKED
EndIf
GUICtrlSetState($checkbox_topmost, $state);checkbox state
GUICtrlSetOnEvent($checkbox_topmost, "onsetontop")

$settray = GUICtrlCreateCheckbox("Tray icon", 10, 59, 60, 20)
GUICtrlSetOnEvent($settray, "onsettray")

$settimediff = GUICtrlCreateCheckbox("Time difference", 10, 76)
GUICtrlSetOnEvent($settimediff, "onsettimediff")

$settimeoffsetd = GUICtrlCreateLabel("Offset:", 10, 100, 30, 13)
$settimeoffset = GUICtrlCreateInput("1:01", 44, 97, 30, 20)

$setprogressd = GUICtrlCreateLabel("P Bar:", 10, 120, 30, 20)
$setprogressa = GUICtrlCreateInput("50", 44, 120, 20, 20)
;_______________________________________________

GUICtrlSetState($run, $GUI_DEFBUTTON)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

;________________________ Last GUI setup commands _________________________

GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")

If $CmdLine[0] > 0 Then
	If $CmdLine[1] = "hide" OR $cmdline[1]=16 Then onhide()
else
	GUISetState()       ; will display an empty dialog box
endif

If $offset = "no" Then GUICtrlSetState($nowofid, $GUI_HIDE)

;___________________ settings display cont____________________________________
$state1 = $GUI_SHOW
display1()

onsetontop()
If $trayi = "yes" Then GUICtrlSetState($settray, $GUI_CHECKED)
If $offset = "yes" Then GUICtrlSetState($settimediff, $GUI_CHECKED)


;-------------------- SETTINGS  ---------------------------------------------------
$waitingfor = "0"

$setup = "yes"
Onset()
$setup = "no"

global $wait = 1000
;_______________ update ________________________________--
While $runloop = "no"
	
	If $state1 = $GUI_SHOW Then
		insertif()
		;_GUICtrlComboAutoComplete ($partofdid, $old_string)
	EndIf
	
	If $pause = "no" Then
		
		If $state1 = $GUI_SHOW Then
			;_GUICtrlComboAutoComplete ($partofdid, $old_string)
			insertif()
		EndIf
		
		$now = _TimeToTicks(@HOUR, @MIN, @SEC)
		
		If $offset = "yes" Then
			$timeof = $now - $tdiff
			
			_TicksToTime($timeof, $lthour, $ltmin, $ltsec)
			If StringLen($ltmin) < 2 Then $ltmin = "0" & $ltmin
			
			If StringLen($ltsec) < 2 Then $ltsec = "0" & $ltsec
			
			If $lthour > "12" Then
				$partod2 = " PM"
				$lthour = $lthour - 12
			Else
				$partod2 = " AM"
			EndIf
			
			If $state1 = $GUI_SHOW Then
				$left1 = $lthour & ":" & $ltmin & ":" & $ltsec & $partod2
				$tleft = "Offset   time: " & $left1
				
				GUICtrlSetData($nowofid, $tleft)
			EndIf
			
			$now = $timeof
			
		EndIf
		
		
		$left1 = $waitingfor - $now

		If $left1 < 0 AND $left1>-3 Then done()
		
		$prog = $left1 / 1000 ; time left in mins
		$leftd = $prog

		$prog = $progad - $prog      ;  xx-mins left
		$prog = $prog/$progad*100 ; convert mins left	
		$progperc=Round($prog,1)

		If $state1 = $GUI_SHOW Then 
			GUICtrlSetData($progressbar1, $prog)
			GUICtrlSetData($progresslabel, $progperc  & "%")
		endif
		; ---------------------------time left--------------
		
		
		_TicksToTime($left1, $lhour, $lmin, $lsec)
		
		If StringLen($lmin) < 2 Then $lmin = "0" & $lmin
		
		If StringLen($lsec) < 2 Then $lsec = "0" & $lsec
		
		If $state1 = $GUI_SHOW Then
			$left1 = $lhour & ":" & $lmin & ":" & $lsec
			$tleft = "Time left: " & $left1
			GUICtrlSetData($leftid, $tleft)
		EndIf
		$dmin=$lmin+1-1
		If $dmin < 5 Then
		;	msgbox(0,$dmin,"",2)
			onflash(1000)
		endif

			onflash(1000)
		
		; ---------------------------
		Global $trayi = "yes"
		; -------------------------------
		
;		$flash = 0
		
		$left2 = $left1
		If $left2 = "" Then $left1 = "-"
		
;		onflash()
		
		If $trayi = "yes" Then TrayTip("Left " & $left2 & " " & $progperc & "%" ,$extrat2 & $leftd & " " & $extrat & "  " & $lsnc, 10, 16+1) ; 16 - no sound
		
	;	ToolTip ($disp ,900  , 690 , "a" , 1,0)

	Else
		
		TrayTip("-", "-", 10, 16) ; 16 - no sound
		
	EndIf ; ----- pause loop
	
	$wait=$wait
	if $wait<500 then $wait=1000
	sleep(1000)
	
WEnd


;--------------- Functions ---------------


;------------------- On set -----------------------------------
Func Onset()
	$pause = "yes"
	
	$set = GUICtrlRead($time2id)
	
	If $setup = "yes" Then $set = $startset
	
	$place = StringInStr($set, ":")
	
	$tplace = $place - 1
	$whour = StringLeft($set, $tplace)
	
	$tplace = StringLen($set) - $place
	$wmin = StringRight($set, $tplace)
	
	$wsec = "00"
	
	; ------------ valdations ------------
	
	$validt = "yes"
	
	If StringIsAlNum($whour) <> "1" Then $validt = "no"
	If StringIsAlNum($wmin) <> "1" Then $validt = "no"
	If StringIsAlNum($wsec) <> "1" Then $validt = "no"
	
	If $wmin > "59" Then $validt = "no"
	If $wmin < "0" Then $validt = "no"
	
	
	
	; ----------- Set displayed info -------------------------
	$pod = GUICtrlRead($partofdid)
	If $setup = "yes" Then $pod = $startpod
	If $pod = "PM" Then
		If $whour < 12 Then $whour = $whour + 12
	EndIf
	
	If $validt = "yes" Then $waitingfor = _TimeToTicks($whour, $wmin, $wsec)
	
	If $whour > 12 Then
		$partod2 = " PM"
		$whour = $whour - 12
	Else
		$partod2 = " AM"
	EndIf
	
	If StringLen($whour) < 2 Then $whour = "  " & $whour
	
	If $validt = "yes" Then
		GUICtrlSetData($waitforid, "Waiting for:   " & $whour & ":" & $wmin & ":" & $wsec & $partod2)
		
		RegWrite($regplace, "1 Default Time", "REG_SZ", $set)
		RegWrite($regplace, "2 Default Part of day", "REG_SZ", $pod)
	EndIf
	$pause = "no"
	
EndFunc   ;==>Onset


; ---------------------------------- Settings ---------------------

Func onsettings()
	
	$settingsdisplayed = "yes"
	
	$pause = "yes"
	
	$state1 = $GUI_HIDE
	
	display1()
	
	
	;$GUI_HIDE
	;$GUI_SHOW
	
	;GUICtrlSetState ($program2ID, $GUI_SHOW)
	;GUICtrlSetState ($settingsid, $GUI_HIDE)
	
	;GUICtrlSetState ($groupsid, $GUI_show)
	
EndFunc   ;==>onsettings

; --------------- Return to program

Func onprogram()
	$progad = GUICtrlRead($setprogressa) * 60
	$settingsdisplayed = "no"
	
	$state1 = $GUI_SHOW
	
	display1()
	
	;GUICtrlSetState ($program2ID, $GUI_HIDE)
	;GUICtrlSetState ($settingsid, $GUI_SHOW)
	;GUICtrlSetState ($groupsid, $GUI_HIDE)
	$pause = "no"
	
EndFunc   ;==>onprogram



Func display1()
	
	If $state1 = $GUI_HIDE Then $state2 = $GUI_SHOW
	If $state1 = $GUI_SHOW Then $state2 = $GUI_HIDE
	
	GUICtrlSetState($nowid, $state1)
	If $offset = "yes" Then GUICtrlSetState($nowofid, $state1)
	GUICtrlSetState($waitforid, $state1)
	GUICtrlSetState($leftid, $state1)
	GUICtrlSetState($time2id, $state1)
	GUICtrlSetState($groupid, $state1)
	GUICtrlSetState($setID, $state1)
	GUICtrlSetState($hideID, $state1)
	GUICtrlSetState($partofdid, $state1)
	GUICtrlSetState($settingsID, $state1)
	
	GUICtrlSetState($settimediff, $state2)
	GUICtrlSetState($settimeoffset, $state2)
	GUICtrlSetState($settimeoffsetd, $state2)
	GUICtrlSetState($settray, $state2)
	GUICtrlSetState($program2ID, $state2)
	GUICtrlSetState($settimeoffset, $state2)
	GUICtrlSetState($groupsid, $state2)
	GUICtrlSetState($checkbox_topmost, $state2)
	GUICtrlSetState($setprogressa, $state2)
	GUICtrlSetState($setprogressd, $state2)
EndFunc   ;==>display1



Func onhide()
	HotKeySet("^{F3}", "onshow")
	GUISetState(@SW_HIDE)
EndFunc   ;==>onhide
;_____________________________________
Func onshow()
	GUISetState(@SW_SHOW)
	;HotkeySet("{F2}")
	HotKeySet("^{F3}", "onhide")
EndFunc   ;==>onshow


Func insertif()
	; ----------- Check if ":" should be inserted and insert if needed -------------------
	$dtemp = "yes"
	$temp2 = GUICtrlRead($time2id)
	
	;------------ Check if : is already in it + replace space with : if it is not -------------------
	If StringInStr($temp2, ":") > "0" Then $dtemp = "no"
	If StringLen($temp2) < 2 Then $dtemp = "no"
	If $dtemp = "yes" Then
		$temp2 = StringReplace($temp2, " ", ":")
		If @extended > 0 Then
			If StringInStr($temp2, ":", 0, 2) < "1" Then GUICtrlSetData($time2id, $temp2)
			$dtemp = "no"
		EndIf
	EndIf
		
	
	$replace = "yes"
	$temp3 = StringStripWS($temp2, 8)
	If $temp3 = $temp2 Then $replace = "no"
	If $replace = "yes" Then
		If StringInStr($temp3, ":", 0, 2) < "1" Then GUICtrlSetData($time2id, $temp3)
		$dtemp = "no"
	EndIf
	
	If StringMid($temp2, 2, 1) = "" Then $dtemp = "no"
	
	$tempn = StringLeft($temp2, 2)
	If $last = $tempn Then $dtemp = "no"
	$last = $tempn
	If StringLen($temp2) = "0" Then $dtemp = "no"
	
	If $dtemp = "yes" Then
		If StringInStr($temp2, ":", 0, 2) < "1" Then GUICtrlSetData($time2id, $temp2 & ":")
	EndIf
	
	
	$nowtime = _DateTimeFormat( _NowCalc(), 3)
	
	
	$nowtimes = $nowtime
	$tthour = StringLeft($nowtimes, StringInStr($nowtimes, ":") + 1)
	If $tthour < 10 Then $nowtimes = "  " & $nowtimes
	
	$ctime = "Current time: " & $nowtimes
	;_NowTime()
	
	GUICtrlSetData($nowid, $ctime)
EndFunc   ;==>insertif


Func onkeyset2()
	
	If WinActive("Time Left") = "1" Then
		
		If $settingsdisplayed = "yes" Then
			onprogram()
		Else
			onsettings()
		EndIf
	Else
		HotKeySet("{f2}")
		Send("{f2}")
		HotKeySet("{f2}", "onkeyset2")
	EndIf
EndFunc   ;==>onkeyset2


;-------------------- settings ---------------------------
Func onsettimediff()
	$offset = GUICtrlRead($settimediff)
	If $offset = "1" Then $offset = "yes"
	If $offset = "4" Then $offset = "no"
	RegWrite($regplace, "3 Time Difference", "REG_SZ", $offset)
	
	If $offset = "yes" Then
		$up1 = "7"
		$up2 = "13"
	EndIf
	
	If $offset = "no" Then
		$up1 = ""
		$up2 = ""
	EndIf
	
	GUICtrlSetPos($groupid, 3, 40 - $up1, 140, 70 + $up1)
	GUICtrlSetPos($nowid, 10, 60 - $up2, 130, 12)
EndFunc   ;==>onsettimediff


Func onsettray()
	$trayi = GUICtrlRead($settray)
	If $trayi = "1" Then $trayi = "yes"
	If $trayi = "4" Then $trayi = "no"
	RegWrite($regplace, "4 Tray icon", "REG_SZ", $trayi)
EndFunc   ;==>onsettray


Func onsetontop()
	If GUICtrlRead($checkbox_topmost) = 1 Then
		WinSetOnTop($MyGUI1, "", 1);checked for 'always on-top' window
		$guitop = "yes"
	Else
		WinSetOnTop($MyGUI1, "", 0);unchecked for normal window
		$guitop = "no"
	EndIf
	
	RegWrite($regplace, "5 GUI always on top", "REG_SZ", $guitop)
	
EndFunc   ;==>onsetontop

Func done()
	SoundSetWaveVolume(100)
	SoundPlay("C:\Windows\media\Defsound.wav")
	Sleep(100)
	
	onpicktime()
EndFunc   ;==>done

; ---------------- pick time ---------

Func onpicktime()
	
			$now = @HOUR & @MIN
	Switch @WDAY
		Case 1 To 5 ; Monday, Thursday
			
			Switch $now
				
				Case 0850 To 0940
					$startset = "9:40"
					$startpod = "AM"
					$lsnc=1

				Case 0940 To 1030
					$startset = "10:30"
					$startpod = "AM"	
					$lsnc=2

				Case 1030 To 1050 
					$startset = "10:50"
					$startpod = "AM"
					$lsnc="R"

				Case 1050 To 1140
					$startset = "11:40"
					$startpod = "AM"
					$lsnc=3

				Case 1140 To 1230
					$startset = "12:30"
					$startpod = "PM"
					$lsnc=4

				Case 1230 To 1320
					$startset = "1:20"
					$startpod = "PM"
					$lsnc=5
					
				Case 1320 To 1400
					$startset = "2:00"
					$startpod = "PM"
					$lsnc="L"
					
				Case 1400 To 1450
					$startset = "2:50"
					$startpod = "PM"
					$lsnc=5

				Case 1450 To 1540
					$startset = "3:40"
					$startpod = "PM"
					$lsnc=7
					
				Case Else
					
			EndSwitch ; time

		Case 6 ; ============ FRIDAY==========
			
			Switch $now
				
				Case 0815 To 0940
					$startset = "9:40"
					$startpod = "AM"
					
				Case 0940 To 1030
					$startset = "10:30"
					$startpod = "AM"
					
				Case 1030 To 1100    ; 3
					$startset = "12:05"
					$startpod = "PM"
					
				Case 1100 To 1150 ; 4
					$startset = "11:50"
					$startpod = "AM"
					
				Case 1150 To 1230 ;5
					$startset = "1:20"
					$startpod = "PM"
					
				Case 1230 To 1320 ;6
					$startset = "1:20"
					$startpod = "PM"
					
				Case 1320 To 1410
					$startset = "2:10"
					$startpod = "PM"
					
				Case 1410 To 1500
					$startset = "3:00"
					$startpod = "PM"
					
				Case Else
					msgbox(0,"Day",@WDAY)
			EndSwitch ; time
		Case Else		
	EndSwitch
	
	;GUICtrlSetData ($waitforid, "Waiting for:   " & $whour & ":" & $wmin & ":" & $wsec & $partod2)
	
EndFunc   ;==>onpicktime

Func onflash($wait1 = -1, $waitp2 = -1)
	If $wait1 <> 0 Then $wait = $wait1
	
	If $waitp2 <> 0 Then
		$wait2 = $waitp2
	Else
		$wait2 = $wait1
	EndIf
	
	$flash = 1
;	TrayTip("", "", 10, 16)
	$eee="["
	$ut11=int($progperc/$showp2)
	if $ut11<>$u11 then
		$u11=$ut11

		for $tp1=1 to $u11
			$eee&="+"
		next

		for $tp1=1 to $showp-$u11
			$eee&="-"
		next
			
		$eee&="]"

		$extrat=$eee
		$extrat2=""
	endif
EndFunc   ;==>onflash

;____________________ RESTART ____________________________

Func restart()
	sleep(100)
	Run(@ComSpec & ' /c "' & @ScriptFullPath & '" ' &  $state1,"",@SW_HIDE)
	exit
endfunc

;___________ EXIT ___________________________________
Func OnExit()
	Exit
EndFunc   ;==>OnExit