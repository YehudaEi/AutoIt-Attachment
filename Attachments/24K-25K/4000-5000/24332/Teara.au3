#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.2.13.13 (beta)
	Author:         Will88
#ce ----------------------------------------------------------------------------
;-----------Includes-----------
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <Constants.au3>
#include <IE.au3>
$ini = @ScriptDir & "\Settings.ini"
If Not FileExists($ini) Then
	$Name = InputBox("Name?", "What is your name?")
	IniWrite($ini, "Settings", "User", $Name & ":")
	IniWrite($ini, "Settings", "Username", $Name)
	$Ai = InputBox("Name?", "The thing that talks to you")
	IniWrite($ini, "Settings", "Ai", $Ai)
	IniWrite($ini, "Settings", "OpenNote", "")
	IniWrite($ini, "Settings", "Shutdown", "")
	IniWrite($ini, "Settings", "RingTime", "")
	IniWrite($ini, "Settings", "TheSong", "")
	IniWrite($ini, "Settings", "Zipcode", "")
EndIf
;-----------Hotkey-------------
HotKeySet("{Enter}", "SendCheck")
;--------------INI-------------
;--------------Vars------------
Global $User = IniRead($ini, "Settings", "User", "")
Global $Ai = IniRead($ini, "Settings", "Ai", "")
Global $Username = IniRead($ini, "Settings", "Username", "")
Global $OpenNote = IniRead($ini, "Settings", "OpenNote", "")
Global $STime = IniRead($ini, "Settings", "Shutdown", "")
Global $ATime = IniRead($ini, "Settings", "RingTime", "")
Global $loops = 0
Global $blank = 1
Global $HotkeySet = True
Global $TimedShutdown = False
Global $ringring = False
Global $GameActive = False
Global $trys = 0
Global $GameOver = False
Global $ExitGame = False
$Title = "::Teara::"
;--------------GUI-------------
If WinExists($Title) Then Exit
GUICreate($Title, 500, 500)
GUISetState()
$Edit_Field = GUICtrlCreateEdit("", 0, 0, 500, 470, BitOR($ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
$Input_Field = GUICtrlCreateInput("", 0, 477, 500, 20)
;------------------------------
If Not $OpenNote = "" Then
	ViewNote()
	$msg = ""
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
EndIf
Greet()
Send('{tab}')

While 1
If $GameActive = True Then GameTime()
	If WinActive($Title) Then
		HotKeySet("{Enter}", "SendCheck")
	ElseIf Not WinActive($Title) Then
		HotKeySet("{Enter}")
	EndIf
	$msg = GUIGetMsg()
	If $msg = -3 Then Exiting()

	If $ringring = True Then
		$iHour = @HOUR
		$iMin = @MIN
		$sAMPM = "AM"
		If $iHour >= 12 Then $sAMPM = "PM"
		If $iHour = 00 Then $iHour = 12
		If $iHour > 12 Then $iHour -= 12
		If $ATime = $iHour & ":" & $iMin Then
			RingIt()
			IniWrite($ini, "Settings", "RingTime", "")
			$ringring = False
		EndIf
	EndIf

	If $TimedShutdown = True Then
		$iHour = @HOUR
		$iMin = @MIN
		$sAMPM = "AM"
		If $iHour >= 12 Then $sAMPM = "PM"
		If $iHour = 00 Then $iHour = 12
		If $iHour > 12 Then $iHour -= 12
		If $STime = $iHour & ":" & $iMin Then
			IniWrite($ini, "Settings", "Shutdown", "")
			shutdownpc()
		EndIf
	EndIf
WEnd
Func Greet()
	$ran = Random(0, 2, 1)
	Select
		Case $ran = 0
			$Hour = @HOUR
			$Min = @MIN
			$AMorPM = "AM"
			If $Hour >= 12 Then $AMorPM = "PM"
			If $Hour = 00 Then $Hour = 12
			If $Hour > 12 Then $Hour -= 12
			Select
				Case $AMorPM = "PM"
					$msg = $Ai & ": Good Evening " & $Username & "."
					GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
				Case Else
					$msg = $Ai & ": Good Morning " & $Username & "."
					GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			EndSelect
			
		Case $ran = "1"
			$msg = $Ai & ": Hello " & $Username
			GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
		Case $ran = "2"
			$msg = $Ai & ": Hey " & $Username
			GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	EndSelect
EndFunc   ;==>Greet

Func SendCheck()
	$read = GUICtrlRead($Input_Field)
	Global $a = StringInStr($read, "*", 0)
	Global $b = StringInStr($read, "+", 0)
	Global $c = StringInStr($read, "-", 0)
	Global $d = StringInStr($read, "/", 0)
	$check1 = StringLeft($read, 1)
	If $check1 = "/" Then commands()
	If Not $a > 0 Or $b > 0 Or $c > 0 Or $d > 0 Or Not $check1 = "/" Then chitchat()
	
	If $a > 0 Then
		$a2 = $a + "1"
		Global $right = StringMid($read, $a2)
		$a3 = $a - "1"
		Global $left = StringLeft($read, $a3)
		$check1 = StringIsDigit($right)
		$check2 = StringIsDigit($left)
		If $check1 = 1 And $check2 = 1 Then
			GUICtrlSetData($Input_Field, "")
			math()
		EndIf
	ElseIf $b > 0 Then
		$b2 = $b + "1"
		Global $right = StringMid($read, $b2)
		$b3 = $b - "1"
		Global $left = StringLeft($read, $b3)
		$check1 = StringIsDigit($right)
		$check2 = StringIsDigit($left)
		If $check1 = 1 And $check2 = 1 Then
			GUICtrlSetData($Input_Field, "")
			math()
		EndIf
	ElseIf $c > 0 Then
		$c2 = $c + "1"
		Global $right = StringMid($read, $c2)
		$c3 = $c - "1"
		Global $left = StringLeft($read, $c3)
		$check1 = StringIsDigit($right)
		$check2 = StringIsDigit($left)
		If $check1 = 1 And $check2 = 1 Then
			GUICtrlSetData($Input_Field, "")
			math()
		EndIf
	ElseIf $d > 0 Then
		$d2 = $d + "1"
		Global $right = StringMid($read, $d2)
		$d3 = $d - "1"
		Global $left = StringLeft($read, $d3)
		$check1 = StringIsDigit($right)
		$check2 = StringIsDigit($left)
		If $check1 = 1 And $check2 = 1 Then
			GUICtrlSetData($Input_Field, "")
			math()
		EndIf
	EndIf
EndFunc   ;==>SendCheck
Func chitchat();talking to AI
	$read = GUICtrlRead($Input_Field)
	Select
		
		Case $read = "" ;prevents blank text from being sent
		
	Case $read = "Lets play a game" Or $read = "Do you wan't to play a game?" Or $read = "Lets play a game!"
		GUICtrlSetData($Input_Field, "")
		;1)Ok
		;2)Sure
		$ran = Random(1,2,1)
						If $ran = "1" Then
		GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
					$msg = $Ai & ": Ok, Lets play the guessing game"
					Global $GameActive = True
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			ElseIf $ran = "2" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				$msg = $Ai & ": Sure, Lets play the guessing game"
				Global $GameActive = True
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
				Global $GameActive = True
				EndIf
		Case $read = "Hi" Or $read = "Hello" Or $read = "Hey"
				GUICtrlSetData($Input_Field, "")
				;1)Hello, How are you?
				;2)Hi, How are you?
				;3)Hey, How are you?
				$ran = Random(1,3,1)
				If $ran = "1" Then
					GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				Sleep(500)
				$msg = $Ai & ": Hello, How are you?"
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
				ElseIf $ran = "2" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)	
				Sleep(500)
				$msg = $Ai & ": Hi, How are you? "
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
				ElseIf $ran = "3" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				Sleep(500)
				$msg = $Ai & ": Hey, How are you? "
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			EndIf
			Case $read = "Not Good" Or $read = "Bad" ;bad
			    ;1) I'm sorry to hear that :(
				;2) Sorry to hear that
				;3) :(
				$ran = Random(1,3,1)
				If $ran = "1" Then
					GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				Sleep(500)
				$msg = $Ai & ": I'm sorry to hear that :( "
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			ElseIf $ran = "2" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
								Sleep(500)
				$msg = $Ai & ": Sorry to hear that"
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			ElseIf $ran = "3" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
								Sleep(500)
				$msg = $Ai & ": :("
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
				EndIf
				
			Case $read = "How are you?"		
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				$msg = $Ai & ": ...I'm an AutoitScript"
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
		Case $read = "Thanks" Or $read = "Thank You" Or $read = "ty"
			GUICtrlSetData($Input_Field, "")
			$rannp = Random(1, 3, 1)
			If $rannp = "1" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				Sleep(500)
				$msg = $Ai & ": Your welcome :) "
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			ElseIf $rannp = "2" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				Sleep(500)
				$msg = $Ai & ": No problem :) "
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			ElseIf $rannp = "3" Then
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
				Sleep(500)
				$msg = $Ai & ": Np :) "
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			EndIf
		Case $read = "lol"
			Sleep(500)
				$msg = $Ai & ": Whats so funny?"
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
		Case Else
			GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
			GUICtrlSetData($Input_Field, "")
	EndSelect
EndFunc   ;==>chitchat
Func commands()
	$read = GUICtrlRead($Input_Field)
	$check = StringMid($read, 2, 4)
	$check1 = StringMid($read, 2, 9)
	$check2 = StringMid($read, 2, 5)
	Select
		
		
		Case $check1 = "Tshutdown"
			$Time = StringMid($read, 12)
			IniWrite($ini, "Settings", "Shutdown", $Time)
			Global $TimedShutdown = True
			Global $STime = IniRead($ini, "Settings", "Shutdown", "")
		Case $check2 = "Alarm"
			$Time = StringMid($read, 8)
			IniWrite($ini, "Settings", "RingTime", $Time)
			Global $ringring = True
			Global $ATime = IniRead($ini, "Settings", "RingTime", "")
			$msg = $Ai & ": Alarm was set"
			GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			$songread = IniRead($ini, "Settings", "TheSong", "")
			If $songread = "" Then
				picksong()
			EndIf
		Case $check = "Note"
			$NoteWhat = StringMid($read, 7)
			IniWrite($ini, "Settings", "OpenNote", $NoteWhat)
			$msg = $Ai & ": Note saved, and will be displayed when " & $Title & " is opened. Or by typing '/Vnote'"
			GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
		Case $check = "Ping"
			$PingWhat = StringMid($read, 7)
			$msg = $Ai & ": Pinging " & $PingWhat
			GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			GUICtrlSetData($Input_Field, "")
			Local $foo = Run(@ComSpec & " /c " & "Ping " & $PingWhat, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
			Local $line
			Do
				$line = StdoutRead($foo)
				If $line = "" Then
					$blank += 1
				EndIf
				$msg = $line
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
				Sleep(5000)
			Until $blank = 3
			$read = ""
		Case $read = "/Game" 
			Global $GameActive = True
		Case $read = "/SetSong"
			picksong()
		Case $read = "/Cancel alarm"
			alarmcancel()
		Case $read = "/weather"
			GUICtrlSetData($Input_Field, "")
			Weather()
		Case $read = "/Vnote"
			ViewNote()
		Case $read = "/Cls"
			GUICtrlSetData($Edit_Field, "")
		Case $read = "/Time"
			Time()
		Case $read = "/Date"
			Date()
		Case $read = "/Shutdown"
			shutdownpc()
		Case $read = "/logoff"
			logoff()
		Case $read = "/restart"
			reboot()
		Case $read = "/reboot"
			reboot()
		Case $read = "/Run Notepad"
			notepad()
		Case $read = "/Run Calc"
			calc()
		Case $read = "/quit"
			Exiting()
		Case $read = "/exit"
			Exiting()
		Case "/Video"
			Video()
		Case Else
			$msg = $Ai & ": Command '" & $read & "' does not exist"
			GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	EndSelect
	GUICtrlSetData($Input_Field, "")
EndFunc   ;==>commands

Func Exiting()
	$msg = $Ai & ": Bye!"
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	Sleep(500)
	Exit
EndFunc   ;==>Exiting
Func Time()
	$iHour = @HOUR
	$iMin = @MIN
	$sAMPM = "AM"
	If $iHour >= 12 Then $sAMPM = "PM"
	If $iHour = 00 Then $iHour = 12
	If $iHour > 12 Then $iHour -= 12
	$msg = $Ai & ": The time is: " & $iHour & ":" & $iMin & $sAMPM
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
EndFunc   ;==>Time
Func Date()
	$date = @MON & "/" & @MDAY & "/" & @YEAR
	$msg = $Ai & ": The date is: " & $date
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
EndFunc   ;==>Date
Func shutdownpc()
	$msg = $Ai & ": Shutting down your pc... "
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	Sleep(1500)
	Shutdown(1)
EndFunc   ;==>shutdownpc
Func logoff()
	$msg = $Ai & ": Logging off your pc... "
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	Sleep(1500)
	Shutdown(0)
EndFunc   ;==>logoff
Func notepad()
	$msg = $Ai & ": Opening Notepad... "
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	Run("notepad")
EndFunc   ;==>notepad
Func reboot()
	$msg = $Ai & ": Restarting your pc... "
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	Sleep(1500)
	Shutdown(2)
EndFunc   ;==>reboot
Func calc()
	$msg = $Ai & ": Opening Calculator... "
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	Run("calc")
EndFunc   ;==>calc
Func ViewNote()
	$OpenNote=IniRead($ini,"Settings","OpenNote","")
	If Not $OpenNote = "" Then
		$msg = "Note: " & $OpenNote
		GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	Else
		$msg = $Ai & ": You do not have a note set, type '/note Message Here' to set one"
		GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	EndIf
EndFunc   ;==>ViewNote
Func math()
	Select
		Case $a
			$answer = $left * $right
		Case $b
			$answer = $left + $right
		Case $c
			$answer = $left - $right
		Case $d
			$answer = $left / $right
	EndSelect
	$msg = $Ai & ": The answer is " & $answer & "."
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
EndFunc   ;==>math
Func picksong()
	$open = FileOpenDialog("Pick Alarm Song", @ScriptDir, "")
	IniWrite($ini, "Settings", "TheSong", $open)
	$msg = $Ai & ": Alarm song was set"
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
EndFunc   ;==>picksong
Func RingIt()
	$ringy = IniRead($ini, "Settings", "TheSong", "")
	$msg = $Ai & ": Alarm is playing!"
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	SoundPlay($ringy)
EndFunc   ;==>RingIt
Func alarmcancel()
	Global $ringring = False
	IniWrite($ini, "Settings", "RingTime", "")
	$msg = $Ai & ": Alarm was canceled"
	GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
EndFunc   ;==>alarmcancel
Func Weather()
	$zip = IniRead($ini, "Settings", "Zipcode", "")
	If Not $zip = "" Then
		$IE = _IECreate("http://www.weather.com/weather/local/" & $zip & "?lswe=04862&lwsa=WeatherLocalUndeclared&from=searchbox_localwx", 0, 0, 1)
		$sHTML = _IEDocReadHTML($IE)
		FileWrite(@ScriptDir & "\Temp.txt", $sHTML)
		_IEQuit($IE)
		ProcessClose("iexplore.exe")
		$line = "5"
		Do
			$wstring = FileReadLine(@ScriptDir & "\Temp.txt", $line)
			$look = StringInStr($wstring, "temp=", 1)
			If $look > 0 Then
				$degree = StringMid($wstring, 53, 2)
				$humid = StringMid($wstring, 67, 2)
				$dew = StringMid($wstring, 74, 2)
				$wind = StringMid($wstring, 82, 2)
				$cond = StringMid($wstring, 89, 5)
				
				$deg=StringReplace($degree,"&","")
				$hum=StringReplace($humid,"&","")
				$dew2=StringReplace($dew,"&","")
				$win=StringReplace($wind,"&","")
				$con=StringReplace($cond,"&","")

$msg = $Ai & ":" & @CRLF & "Condition:" & $con & @CRLF & "Temp:" & $deg & @CRLF & "Wind:" & $win & @CRLF & "Humid:" & $hum & @CRLF & "Dew:" & $dew2

				;$msg = $Ai & ":" & @CRLF & "Condition:" & $cond & @CRLF & "Temp:" & $degree & @CRLF & "Wind:" & $wind & @CRLF & "Humid:" & $humid & @CRLF & "Dew:" & $dew
				GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
			EndIf
			$line += 1
		Until $look > 0
		FileDelete(@ScriptDir & "\Temp.txt")
	Else
		$msg = $Ai & ": A zipcode must be set in Settings.ini before using '/Weather'"
		GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
	EndIf
EndFunc   ;==>Weather

Func GameTime()
HotKeySet("{Enter}")
$input = InputBox("Range of guess","type in the maximum number")
Global $GuessNumber = Random(0,$input,1)
MsgBox(0,$GuessNumber,"")
Global $trys = ""
$msg = $Ai & ": Im thinking of a number between 1 and " &$input
GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
HotKeySet("{Enter}","CheckAnswer")
Do
If $GameOver = True Then
	HotKeySet("{enter}")
		$answermsg=MsgBox(4,"Message from " &$Ai,"Would you like to play again?")
		If $answermsg = 7 Then
			Global $ExitGame = True
			Else
			Global $GameOver = False
			GameTime()
		EndIf
		EndIf	

	$msg = GUIGetMsg()
	If $msg = -3 Then GameExit()
	If WinActive($Title) Then
		HotKeySet("{Enter}", "CheckAnswer")
	ElseIf Not WinActive($Title) Then
		HotKeySet("{Enter}")
	EndIf
	
	
Until $ExitGame = True
HotKeySet("{Enter}","SendCheck")
Global $GuessNumber = ""
Global $GameActive = False
Global $GameOver = False
Global $ExitGame = False
Global $trys = 0
;Main()
EndFunc
Func GameExit()
$answer=MsgBox(4,"Message from " & $Ai,"Giving up?")
If $answer = 6 Then
Global $ExitGame = True
EndIf
EndFunc

Func CheckAnswer()
$read = GUICtrlRead($Input_Field)	
GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $User & " " & $read & @CRLF)
$trys += 1
GUICtrlSetData($Input_Field,"")
If $read = $GuessNumber Then
$msg = $Ai & ": You got it! On " & $trys & " try's"
HotKeySet("{enter}")
Global $GameOver = True
GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
ElseIf $read > $GuessNumber Then
$msg = $Ai & ": Too high"
GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
ElseIf $read < $GuessNumber Then
$msg = $Ai & ": Too low"
GUICtrlSetData($Edit_Field, GUICtrlRead($Edit_Field) & $msg & @CRLF)
EndIf
EndFunc