#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=weather_icon.ico
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sfc
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global Const $WM_COMMAND = 0x0111
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_POPUPWINDOW = 0x80880000
Global Const $SS_CENTER = 1
Global Const $GUI_DOCKALL = 0x0322
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
Global Const $BS_CENTER = 0x0300
Global Const $BS_DEFPUSHBUTTON = 0x0001
Global Const $ES_RIGHT = 2
Global Const $ES_NUMBER = 8192
Global Const $EN_KILLFOCUS = 0x200
Global Const $EN_SETFOCUS = 0x100
Global Const $__EDITCONSTANT_WM_GETTEXTLENGTH = 0x000E
Global Const $IniDir = @AppDataDir & "\WeatherTray\Settings.ini"

Opt("GUIResizeMode", $GUI_DOCKALL)

Switch FileExists(@AppDataDir & "\WeatherTray")
	Case 0
		DirCreate(@AppDataDir & "\WeatherTray")
		For $i = 0 To 48
			InetGet("http://image.weather.com/web/common/wxicons/52/" & $i & ".gif?12122006", @AppDataDir & "\WeatherTray\Pic" & $i & ".gif")
		Next
EndSwitch

Switch FileExists(@AppDataDir & "\WeatherTray\Settings.ini")
	Case 0
		IniWrite($IniDir, "Settings", "Home", "West Chester, OH")
		IniWrite($IniDir, "Settings", "Refresh", 2)
		IniWrite($IniDir, "Settings", "Days", "7")
		Global $sHome = "West Chester, OH"
		Global $RefreshRate = 2
		Global $ExtendedDays = 7
	Case Else
		Global $sHome = IniRead($IniDir, "Settings", "Home", "West Chester, OH")
		Global $RefreshRate = IniRead($IniDir, "Settings", "Refresh", 2)
		Global $ExtendedDays = IniRead($IniDir, "Settings", "Days", 7)
EndSwitch

Global $Current = $sHome
Global $sZipCode

$Stats = Weather($sHome)
If $Stats = -1 Then
	MsgBox(262192, "ERROR", "The weather console could not be accessed. Make sure" & @CRLF & _
			"you are connected to the internet.", 15)
	IniWrite($IniDir, "Settings", "Home", "West Chester, OH")
	Exit
EndIf

$GUI = GUICreate("Weather", 217, 223, -1, -1, BitOR($WS_POPUPWINDOW, $WS_CAPTION))
GUISetBkColor(0xFFFFFF)

$FileMenu = GUICtrlCreateMenu("&File")
$File_Minimize = GUICtrlCreateMenuItem("&Minimize to Tray", $FileMenu)
$File_Settings = GUICtrlCreateMenuItem("&Settings", $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$File_Exit = GUICtrlCreateMenuItem("&Exit", $FileMenu)

GUICtrlCreateLabel("Weather Right Now For", 25, 8, 166, 17, $SS_CENTER)
GUICtrlSetFont(-1, 8.5, 800, 0, "Georgia")
$Link = GUICtrlCreateLabel($Stats[0], 25, 24, 166, 17, $SS_CENTER)
GUICtrlSetTip(-1, "http://www.weather.com/weather/local/" & $sZipCode)
GUICtrlSetFont(-1, 8, 400, 4, "")
GUICtrlSetColor(-1, 0x0000FF)
GUICtrlSetCursor(-1, 0)
$Temperature = GUICtrlCreateLabel($Stats[2], 95, 45, 95, 31, $SS_CENTER)
GUICtrlSetFont(-1, 19, 400, 0, "Georgia")
GUICtrlSetColor(-1, 0x565963)
$Condition = GUICtrlCreateLabel($Stats[1], 91, 78, 103, 38, $SS_CENTER)
GUICtrlSetFont(-1, 9, 400, 0, "Georgia")
$Pic = GUICtrlCreatePic(@AppDataDir & "\WeatherTray\Pic" & $Stats[10] & ".gif", 16, 40, 75, 75)
$Details = GUICtrlCreateLabel("Feels Like" & @TAB & $Stats[3] & @CRLF & _
		"Humidity" & @TAB & $Stats[6] & @CRLF & _
		"Wind" & @TAB & @TAB & $Stats[5] & @CRLF & _
		"UV Index" & @TAB & $Stats[4] & @CRLF & _
		"Pressure" & @TAB & $Stats[7] & @CRLF & _
		"Dew Point" & @TAB & $Stats[8] & @CRLF & _
		"Visibility" & @TAB & @TAB & $Stats[9], 16, 110, 184, 27)
$Input = GUICtrlCreateInput("", 14, 144, 160, 21)
GUICtrlSetData($Input, $sHome)
GUICtrlSetColor($Input, 0x808080)
$Go = GUICtrlCreateButton("Go", 177, 144, 27, 21, $BS_DEFPUSHBUTTON)
$Home = GUICtrlCreateButton("Home", 12, 171, 40, 23)
$More = GUICtrlCreateButton("More", 167, 171, 37, 23)
$Extended = GUICtrlCreateButton("Extended", 57, 171, 55, 23)
$Hourly = GUICtrlCreateButton("Hourly", 117, 171, 45, 23)
ControlFocus($GUI, "", $Go)
GUISetState()

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
$Timer = TimerInit()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $File_Exit
			Exit
		Case $Go
			$Stats = Weather(GUICtrlRead($Input))
			If Not @error Then
				GUICtrlSetData($Link, $Stats[0])
				GUICtrlSetData($Condition, $Stats[1])
				GUICtrlSetData($Temperature, $Stats[2])
				GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[10] & ".gif")
				GUICtrlSetTip($Link, "http://www.weather.com/weather/local/" & $sZipCode)
				GUICtrlSetData($Details, "Feels Like" & @TAB & $Stats[3] & @CRLF & _
						"Humidity" & @TAB & $Stats[6] & @CRLF & _
						"Wind" & @TAB & @TAB & $Stats[5] & @CRLF & _
						"UV Index" & @TAB & $Stats[4] & @CRLF & _
						"Pressure" & @TAB & $Stats[7] & @CRLF & _
						"Dew Point" & @TAB & $Stats[8] & @CRLF & _
						"Visibility" & @TAB & @TAB & $Stats[9])
				$Timer = TimerInit()
			EndIf
			$Current = GUICtrlRead($Input)
		Case $Home
			$Stats = Weather($sHome)
			If Not @error Then
				GUICtrlSetData($Link, $Stats[0])
				GUICtrlSetData($Condition, $Stats[1])
				GUICtrlSetData($Temperature, $Stats[2])
				GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[10] & ".gif")
				GUICtrlSetTip($Link, "http://www.weather.com/weather/local/" & $sZipCode)
				GUICtrlSetData($Details, "Feels Like" & @TAB & $Stats[3] & @CRLF & _
						"Humidity" & @TAB & $Stats[6] & @CRLF & _
						"Wind" & @TAB & @TAB & $Stats[5] & @CRLF & _
						"UV Index" & @TAB & $Stats[4] & @CRLF & _
						"Pressure" & @TAB & $Stats[7] & @CRLF & _
						"Dew Point" & @TAB & $Stats[8] & @CRLF & _
						"Visibility" & @TAB & @TAB & $Stats[9])
				$Timer = TimerInit()
			EndIf
			$Current = GUICtrlRead($Input)
		Case $More
			Expand()
		Case $Extended
			GUISetState(@SW_DISABLE, $GUI)
			Extended_Forecast($Current)
			GUISetState(@SW_ENABLE, $GUI)
			WinActivate($GUI)
		Case $Hourly
			GUISetState(@SW_DISABLE, $GUI)
			HourByHour($Current)
			GUISetState(@SW_ENABLE, $GUI)
			WinActivate($GUI)
		Case $Link
			ShellExecute("http://www.weather.com/weather/local/" & $sZipCode)
		Case $File_Settings
			Settings()
		Case $File_Minimize
			GUISetState(@SW_MINIMIZE, $GUI)
	EndSwitch
	If TimerDiff($Timer) > 60000 * $RefreshRate Then
		$Stats = Weather($Current)
		If Not @error Then
			GUICtrlSetData($Link, $Stats[0])
			GUICtrlSetData($Condition, $Stats[1])
			GUICtrlSetData($Temperature, $Stats[2])
			GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[10] & ".gif")
			GUICtrlSetData($Details, "Feels Like" & @TAB & $Stats[3] & @CRLF & _
					"Humidity" & @TAB & $Stats[6] & @CRLF & _
					"Wind" & @TAB & @TAB & $Stats[5] & @CRLF & _
					"UV Index" & @TAB & $Stats[4] & @CRLF & _
					"Pressure" & @TAB & $Stats[7] & @CRLF & _
					"Dew Point" & @TAB & $Stats[8] & @CRLF & _
					"Visibility" & @TAB & @TAB & $Stats[9])
		EndIf
		$Timer = TimerInit()
	EndIf
WEnd


Func Expand()
	Local $Movement = 65
	Local $Pos = WinGetPos($GUI)
	Switch GUICtrlRead($More)
		Case "More" ;expand
			GUICtrlSetData($More, "Less")
			WinMove($GUI, "", $Pos[0], $Pos[1], $Pos[2], $Pos[3] + $Movement)
			ControlMove($GUI, "", $Details, 16, 110, 184, 27 + $Movement)
			ControlMove($GUI, "", $Input, 14, 144 + $Movement)
			ControlMove($GUI, "", $Go, 177, 144 + $Movement)
			ControlMove($GUI, "", $Home, 12, 171 + $Movement)
			ControlMove($GUI, "", $Extended, 57, 171 + $Movement)
			ControlMove($GUI, "", $Hourly, 117, 171 + $Movement)
			ControlMove($GUI, "", $More, 167, 171 + $Movement)
		Case Else ;contract
			GUICtrlSetData($More, "More")
			WinMove($GUI, "", $Pos[0], $Pos[1], $Pos[2], $Pos[3] - $Movement)
			ControlMove($GUI, "", $Details, 16, 110, 184, 27)
			ControlMove($GUI, "", $Input, 14, 144)
			ControlMove($GUI, "", $Go, 177, 144)
			ControlMove($GUI, "", $Home, 12, 171)
			ControlMove($GUI, "", $Extended, 57, 171)
			ControlMove($GUI, "", $Hourly, 117, 171)
			ControlMove($GUI, "", $More, 167, 171)
	EndSwitch
EndFunc   ;==>Expand

Func Extended_Forecast($sPlace = $sHome, $Day_Num = $ExtendedDays)
	Local $Day[$Day_Num + 1], $Image[$Day_Num + 1], $Condition[$Day_Num + 1], $High[$Day_Num + 1], $Low[$Day_Num + 1], $Precipitation[$Day_Num + 1], $Wind[$Day_Num + 1][2]

	;get zip code if "city, state" is entered
	If StringIsInt($sPlace) Then
		$sZipCode = $sPlace
	Else
		$sPlace = StringRegExpReplace($sPlace, "(?-i)[()1234567890]", "")
		$CityState = StringSplit($sPlace, ",")
		If @error Then
			MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
					"Make sure you entered the correct information.", 15, $GUI)
			Return SetError(1, 0, -1)
		EndIf
		$CityState[1] = StringReplace($CityState[1], " ", "+")
		$CityState[2] = StringReplace($CityState[2], " ", "")
		$ZIP = _INetGetSource("http://zipcodes.addresses.com/results.php?ReportType=42&qc=" & $CityState[1] & "&qs=" & $CityState[2])
		$ZIP = StringTrimLeft($ZIP, StringInStr($ZIP, '<td class="F1">') + 14)
		$ZIP = StringMid($ZIP, 1, StringInStr($ZIP, '</td>') - 1)
		If @error Then
			MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
					"Make sure you entered the correct information.", 15, $GUI)
			Return SetError(2, 0, -1)
		EndIf
		$sZipCode = $ZIP
	EndIf

	$GUI2 = GUICreate("Extended Forecast", $Day_Num * 105 + 15, 90 + 30 + 40 + 20 + 20 + 20 + 10, -1, -1, BitOR($WS_POPUPWINDOW, $WS_CAPTION), -1, $GUI)
	GUISetBkColor(0xFFFFFF)

	$Source = _INetGetSource("http://www.weather.com/weather/tenday/" & $sZipCode & "?dp=windsdp")
	If @error Then
		MsgBox(262192, "ERROR", "The weather console could not be accessed. Make sure" & @CRLF & _
				"you are connected to the internet. Press OK to exit.", 15)
		GUIDelete($GUI2)
		Return SetError(3, 0, -1)
	EndIf
	If StringInStr($Source, 'Search Results</TITLE>') Then
		MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
				"Make sure you entered the correct information.", 15, $GUI)
		Return SetError(4, 0, -1)
	EndIf
	$Left = 15
	For $x = 1 To $Day_Num
		$Source = StringTrimLeft($Source, StringInStr($Source, 'dayNum=' & $x & '">') + 9)
		$Day[$x] = StringReplace(StringMid($Source, 1, StringInStr($Source, "</p>") - 1), '</a><br>', ', ')
		$Source = StringTrimLeft($Source, StringInStr($Source, '<p><img src="http://i.imwx.com/web/common/wxicons/45/') + 52)
		$Image[$x] = StringMid($Source, 1, StringInStr($Source, '?12122006') - 1)
		$Source = StringTrimLeft($Source, StringInStr($Source, '<br>') + 3)
		$Condition[$x] = StringMid($Source, 1, StringInStr($Source, '</p>') - 1)
		$Source = StringTrimLeft($Source, StringInStr($Source, '<strong>') + 7)
		$High[$x] = StringMid($Source, 1, StringInStr($Source, '&') - 1) & Chr(176) & "F"
		$Source = StringTrimLeft($Source, StringInStr($Source, '<br>') + 3)
		$Low[$x] = StringMid($Source, 1, StringInStr($Source, '&') - 1) & Chr(176) & "F"
		$Source = StringTrimLeft($Source, StringInStr($Source, '<p>') + 2)
		$Precipitation[$x] = StringMid($Source, 1, StringInStr($Source, '&') - 1) & "%"
		$Source = StringTrimLeft($Source, StringInStr($Source, '<p>') + 2)
		$Wind[$x][0] = StringMid($Source, 1, StringInStr($Source, '</p>') - 1)
		$Source = StringTrimLeft($Source, StringInStr($Source, '<strong>') + 7)
		$Wind[$x][1] = StringMid($Source, 1, StringInStr($Source, '</strong>') - 1) & " mph"
		GUICtrlCreateLabel($Day[$x], $Left, 15, 90, 25, $SS_CENTER)
		GUICtrlSetFont(-1, 10, 600, 0, "Georgia")
		GUICtrlCreatePic(@AppDataDir & "\WeatherTray\Pic" & $Image[$x], $Left, 35, 90, 90)
		GUICtrlCreateLabel($Condition[$x], $Left, 35 + 90, 90, 30, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 10, 400, 0, "Georgia")
		GUICtrlCreateLabel($High[$x] & "/" & $Low[$x], $Left, 90 + 30 + 40, 90, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 12, 600, 0, "Georgia")
		GUICtrlCreateLabel("Precip: " & $Precipitation[$x], $Left, 90 + 30 + 40 + 20, 90, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 10, 400, 0, "Georgia")
		GUICtrlCreateLabel("Wind: " & $Wind[$x][1], $Left, 90 + 30 + 40 + 20 + 20, 90, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 9, 400, 0, "Georgia")
		$Left += 105
	Next

	GUISetState()

	While WinExists($GUI2)
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($GUI2)
		EndSwitch
	WEnd

EndFunc   ;==>Extended_Forecast

Func HourByHour($sPlace = $sHome)
	Local $Time[8], $Image[8], $Temperature[8], $Precipitation[8]

	;get zip code if "city, state" is entered
	If StringIsInt($sPlace) Then
		$sZipCode = $sPlace
	Else
		$sPlace = StringRegExpReplace($sPlace, "(?-i)[()1234567890]", "")
		$CityState = StringSplit($sPlace, ",")
		If @error Then
			MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
					"Make sure you entered the correct information.", 15, $GUI)
			Return SetError(1, 0, -1)
		EndIf
		$CityState[1] = StringReplace($CityState[1], " ", "+")
		$CityState[2] = StringReplace($CityState[2], " ", "")
		$ZIP = _INetGetSource("http://zipcodes.addresses.com/results.php?ReportType=42&qc=" & $CityState[1] & "&qs=" & $CityState[2])
		$ZIP = StringTrimLeft($ZIP, StringInStr($ZIP, '<td class="F1">') + 14)
		$ZIP = StringMid($ZIP, 1, StringInStr($ZIP, '</td>') - 1)
		If @error Then
			MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
					"Make sure you entered the correct information.", 15, $GUI)
			Return SetError(2, 0, -1)
		EndIf
		$sZipCode = $ZIP
	EndIf

	$Source = _INetGetSource("http://www.weather.com/weather/hourbyhour/graph/" & $sZipCode & "?from=dayDetails_topnav_undeclared")
	If @error Then Return SetError(3, 0, -1)
	If StringInStr($Source, 'Search Results</TITLE>') Then
		MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
				"Make sure you entered the correct information.", 15, $GUI)
		Return SetError(4, 0, -1)
	EndIf

	$GUI2 = GUICreate("8 Hour Forecast", 810, 90 + 50 + 10 + 28 + 10 + 25 + 10, -1, -1, BitOR($WS_POPUPWINDOW, $WS_CAPTION), -1, $GUI)
	GUISetBkColor(0xFFFFFF)

	$Source = StringTrimLeft($Source, StringInStr($Source, 'id="hbhWxHour0">'))

	$Left = 10
	For $x = 0 To 7
		$Source = StringTrimLeft($Source, StringInStr($Source, '"hbhWxTime"><div>') + 16)
		$Time[$x] = StringMid($Source, 1, StringInStr($Source, '</div>') - 1)
		$Source = StringTrimLeft($Source, StringInStr($Source, '<img src="http://i.imwx.com/web/common/wxicons/45/') + 49)
		$Image[$x] = StringMid($Source, 1, StringInStr($Source, '"') - 1)
		$Source = StringTrimLeft($Source, StringInStr($Source, '<div>') + 4)
		$Temperature[$x] = StringMid($Source, 1, StringInStr($Source, '&') - 1) & Chr(176) & "F"
		$Source = StringTrimLeft($Source, StringInStr($Source, '<br>') + 3)
		$Precipitation[$x] = StringMid($Source, 1, StringInStr($Source, '</div>') - 1)
		GUICtrlCreateLabel($Time[$x], $Left, 10, 90, 25, $SS_CENTER)
		GUICtrlSetFont(-1, 17, 800, 0, "Georgia")
		GUICtrlCreatePic(@AppDataDir & "\WeatherTray\Pic" & $Image[$x], $Left, 50, 90, 90)
		GUICtrlCreateLabel($Temperature[$x], $Left, 90 + 50 + 10, 90, 28, $SS_CENTER)
		GUICtrlSetFont(-1, 17, 400, 0, "Georgia")
		GUICtrlCreateLabel("Precip: " & $Precipitation[$x], $Left, 90 + 50 + 10 + 28 + 10, 90, 25, $SS_CENTER)
		GUICtrlSetFont(-1, 11, 500, 0, "Georgia")
		$Left += 100
	Next

	GUISetState()

	While WinExists($GUI2)
		$Msg = GUIGetMsg()
		Switch $Msg
			Case - 3
				GUIDelete($GUI2)
		EndSwitch
	WEnd
EndFunc   ;==>HourByHour

Func Settings()
	$Settings = GUICreate("Settings", 354, 176, -1, -1, -1, -1, $GUI)
	$Group1 = GUICtrlCreateGroup("Options", 15, 15, 321, 145, $BS_CENTER)
	GUICtrlCreateLabel("Refresh Rate:", 25, 40, 70, 17)
	$Refresh_Input = GUICtrlCreateInput($RefreshRate, 37, 62, 33, 21, BitOR($ES_RIGHT, $ES_NUMBER))
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel("Home Location:", 197, 40, 79, 17)
	$Label1 = GUICtrlCreateLabel($sHome, 202, 62, 120, 17)
	GUICtrlSetColor(-1, 0x0000FF)
	$Use_Current_Location = GUICtrlCreateButton("Use Current Location", 197, 80, 125, 18)
	GUICtrlCreateLabel("Current Location:", 197, 112, 85, 17)
	GUICtrlCreateLabel($Current, 202, 134, 120, 17)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("minute(s)", 76, 64, 46, 17)
	GUICtrlCreateLabel("Extended Forecast: ", 25, 95, 99, Default, $SS_CENTER)
	$Days_Input = GUICtrlCreateInput($ExtendedDays, 124, 91, 15, 20, BitOR($ES_NUMBER, $SS_CENTER))
	GUICtrlCreateLabel("day(s)", 140, 95, 30, Default, $SS_CENTER)
	$OK = GUICtrlCreateButton("&OK", 50, 125, 75, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_DISABLE, $GUI)
	GUISetState(@SW_SHOW, $Settings)
	While WinExists($Settings)
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Settings)
			Case $OK
				Global $RefreshRate = GUICtrlRead($Refresh_Input)
				Global $ExtendedDays = GUICtrlRead($Days_Input)
				IniWrite($IniDir, "Settings", "Refresh", $RefreshRate)
				IniWrite($IniDir, "Settings", "Days", $ExtendedDays)
				GUIDelete($Settings)
			Case $Use_Current_Location
				GUICtrlSetData($Label1, $Current)
				Global $sHome = $Current
				IniWrite($IniDir, "Settings", "Home", $sHome)
		EndSwitch
		Sleep(25)
	WEnd
	GUISetState(@SW_ENABLE, $GUI)
	WinActivate($GUI)
EndFunc   ;==>Settings

;===============================================================================
;Author:			DanTay9
;Description:		Retrieves weather info from weather.com
;Parameter(s):		$sPlace - Zip Code or City, State
;Requirement(s)		None
;Return Value(s):	Success - Returns the following array:
;						0 - Town
;						1 - Condition
;						2 - Temperature
;						3 - Feels Like
;						4 - UV Index
;						5 - Wind speed and direction
;						6 - Humidity
;						7 - Pressure
;						8 - Dew Point
;						9 - Visibility (Distance)
;						10 - Condition Picture
;					Failure - Returns -1 with the following errors
;						1 - Invalid City and State or Zip Code
;						2 - Could not convert city and state to zip code
;						3 - Cannot retrieve source
;						4 - Invalid data entered
;===============================================================================

Func Weather($sPlace)
	Local $Weather[11]

	;get zip code if "city, state" is entered
	If StringIsInt($sPlace) Then
		$sZipCode = $sPlace
	Else
		$sPlace = StringRegExpReplace($sPlace, "(?-i)[()1234567890]", "")
		$CityState = StringSplit($sPlace, ",")
		If @error Then
			MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
					"Make sure you entered the correct information.", 15, $GUI)
			Return SetError(1, 0, -1)
		EndIf
		$CityState[1] = StringReplace($CityState[1], " ", "+")
		$CityState[2] = StringReplace($CityState[2], " ", "")
		$ZIP = _INetGetSource("http://zipcodes.addresses.com/results.php?ReportType=42&qc=" & $CityState[1] & "&qs=" & $CityState[2])
		$ZIP = StringTrimLeft($ZIP, StringInStr($ZIP, '<td class="F1">') + 14)
		$ZIP = StringMid($ZIP, 1, StringInStr($ZIP, '</td>') - 1)
		If @error Then
			MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
					"Make sure you entered the correct information.", 15, $GUI)
			Return SetError(2, 0, -1)
		EndIf
		$sZipCode = $ZIP
	EndIf

	$Source = _INetGetSource("http://www.weather.com/weather/local/" & $sZipCode)
	If @error Then Return SetError(3, 0, -1)
	If StringInStr($Source, 'Search Results</TITLE>') Then
		MsgBox(262192, "ERROR", "The data you have entered is invalid." & @CRLF & _
				"Make sure you entered the correct information.", 15, $GUI)
		Return SetError(4, 0, -1)
	EndIf

	;decrease size of source code
	$Source = StringTrimLeft($Source, StringInStr($Source, '<B>Right Now for</B><BR>') + 23)
	$Source = StringMid($Source, 1, StringInStr($Source, 'Desktop'))

	;conditions
	$Weather[0] = StringMid($Source, 1, StringInStr($Source, "<BR>") - 1)
	$Source = StringTrimLeft($Source, StringInStr($Source, '<IMG SRC="http://image.weather.com/web/common/wxicons/52/') + 56)
	$Weather[10] = StringMid($Source, 1, StringInStr($Source, '.gif?12122006') - 1)
	$Source = StringTrimLeft($Source, StringInStr($Source, '<B CLASS=obsTextA>') + 17)
	$Weather[1] = StringMid($Source, 1, StringInStr($Source, '</B>') - 1)
	$Source = StringTrimLeft($Source, StringInStr($Source, '<B CLASS=obsTempTextA>') + 21)
	$Weather[2] = StringMid($Source, 1, StringInStr($Source, '&') - 1)
	$Source = StringTrimLeft($Source, StringInStr($Source, '<BR> ') + 4)
	$Weather[3] = StringMid($Source, 1, StringInStr($Source, '&') - 1)

	;clean up source code
	$Source = StringTrimLeft($Source, StringInStr($Source, 'UV Index') - 20)
	$Source = StringReplace($Source, '&nbsp;in.', "</td>")
	$Source = StringReplace($Source, ' WIDTH="75" ', "")

	;extract details
	For $x = 4 To 9
		$Source = StringTrimLeft($Source, StringInStr($Source, 'A">', 0, 2) + 2)
		$Weather[$x] = StringMid($Source, 1, StringInStr($Source, '</td>') - 1)
	Next

	;tidy up return values
	For $x = 2 To 3
		$Weather[$x] &= Chr(176) & "F"
	Next
	$Weather[7] = Round($Weather[7] * 33.86447501, 2) & " mb"
	$Weather[8] = StringReplace($Weather[8], "&deg;", Chr(176))

	Return $Weather
EndFunc   ;==>Weather

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode
	$hWndEdit1 = GUICtrlGetHandle($Input)
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $hWndEdit1
			Switch $iCode
				Case $EN_KILLFOCUS
					Switch _GUICtrlEdit_GetTextLen($Input)
						Case 0
							GUICtrlSetData($Input, $sHome)
							GUICtrlSetColor($Input, 0x808080)
					EndSwitch
				Case $EN_SETFOCUS
					Switch GUICtrlRead($Input)
						Case $sHome
							GUICtrlSetData($Input, "")
							GUICtrlSetColor($Input, 0x000000)
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
#Region Vista Buttons

;===============================================================================
; Name...........: _CreateArrayHIcons
; Description ...: Create array of icon handles out of GIF binary or GIF file
; Syntax.........: _CreateArrayHIcons([$sFile])
; Parameters ....: $sFile - optional parameter. Full path to GIF file to be used for rendering. GIF is in the following format:
;                                                                          - frames 1 to 27: used for animation
;                                                                          - frame 28: used for 'no focus'
;                                                                          - frame 29: used for 'mouse hover'
;                                                                          - frame 30: used for 'left click'
;                                                                          - frame 31: used for 'button disabled'
; Return values .: Success: - Returns array of icon handles pulled out of GIF
;                           - Sets @error to 0
;                  Failure: Returns nothing and sets @error:
;                  |1 - Initial DllCall() failed
;                  |2 - gdiplus.dll could not be loaded
;                  |3 - GdiplusStartup function or call to it failed
;                  |4 - GdipLoadImageFromFile function or call to it failed
;                  |5 - GlobalAlloc function or call to it failed
;                  |6 - GlobalLock function or call to it failed
;                  |7 - CreateStreamOnHGlobal function or call to it failed
;                  |8 - GdipCreateBitmapFromStream function or call to it failed
;                  |9 - GdipImageGetFrameDimensionsCount function or call to it failed
;                  |10 - GdipImageGetFrameDimensionsList function or call to it failed
;                  |11 - GdipImageGetFrameCount function or call to it failed
; Remarks .......: Function uses inline GIF (binary) by default
; Author ........: trancexx (GDI+ part originally by ProgAndy)
;===============================================================================

Func _CreateArrayHIcons($sFile = "")

	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "GetModuleHandleW", "wstr", "gdiplus.dll")

	If @error Then Return SetError(1, 0, "")

	If Not $a_hCall[0] Then
		Local $hDll = DllOpen("gdiplus.dll")
		If @error Or $hDll = -1 Then Return SetError(2, 0, "")
	EndIf

	Local $tGdiplusStartupInput = DllStructCreate("dword GdiplusVersion;ptr DebugEventCallback;int SuppressBackgroundThread;int SuppressExternalCodecs")

	DllStructSetData($tGdiplusStartupInput, "GdiplusVersion", 1)

	Local $a_iCall = DllCall("gdiplus.dll", "dword", "GdiplusStartup", "dword*", 0, "ptr", DllStructGetPtr($tGdiplusStartupInput), "ptr", 0)

	If @error Or $a_iCall[0] Then Return SetError(3, 0, "")

	Local $hGDIplus = $a_iCall[1]

	Local $hMemory
	Local $pBitmap

	If $sFile Then

		$a_iCall = DllCall("gdiplus.dll", "dword", "GdipLoadImageFromFile", "wstr", $sFile, "ptr*", 0)

		If @error Or $a_iCall[0] Then
			DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
			Return SetError(4, 0, "")
		EndIf

		$pBitmap = $a_iCall[2]

	Else

		Local $bBinary = "0x474946383961010015008780002C628B9EB0BACFCFCFCEE9F899D4E6C3D8E3CC" & _
				"DCE4B6DEF525CFFBEBEBEB68B3DBCDD8DDB5EBF9E9F5FBC0DCEC39CDF270D7F7" & _
				"D8D8D8C7D6DDCCE4F3DEEFF5E8F1F6CDD3D6D4DFE630CEF6C1E4F8C4DAE699E8" & _
				"FCD6D9DABBE1F6E9F0F3C9E0EC85D5EEE7F4FBD4D4D4C2ECF8B4D2DBD2E4EE7F" & _
				"C2E5CDE2EEF4F4F4C0E2F5D9E0E3E5F0F4CED4D7C8E4F5D7EFF5A7D3E0BCDBED" & _
				"2FD4FFE8EFF3CDDBE1C1E1F238D6FDDBDFE1C7D8E131D4FFC4DCEA92E7FDC2D1" & _
				"D5BEDAEBD0E0E92FCEF778BDE2E9F6FCD9DDDFF0F3F4D6E1E7A7E9FBD4DEE393" & _
				"CEEDD2D5D641D7FC707070CFD2D3D0EEF698D1EFD1DFE7EAEDEE72B9DFD2D8DA" & _
				"ECF4F77ED6F1C9D7DED0E6F2DDF0FAEDF3F637CDF3C4E5F6D7DCDEBEE0F3F0F0" & _
				"F18CCAEBE4F3FCCAE9FABEDDEEC7E1EFCADDE6C9D0D2D8E1E53C7FB1ADB2B5A0" & _
				"D3E3C2D8E5CCDEE8B8DDF228CFFA6DB6DDBCECF8C5DFEE77D6F4D9DBDCC5D7E0" & _
				"CDE7F6E8F3F9D0D3D4C8DBE5A0E9FBD4DADCECF1F3CAE3F28BD5ECE5F4FCD4D7" & _
				"D8C9EDF7BBD1D886C6E8D0E2ECFCFCFCAED2DD92D4E9C9D5DBAEEAFA44D8FBD8" & _
				"EEFAD0DCE3E5F2FBCCD5D9C8E7F9ECEFF03DD6FDCADAE234D5FEC0D9E82DCEF8" & _
				"DCDEDFD4E3EBD0D6D9D1D1D1D3ECF9ECEDEDD1D9DDECF4F8E1F2FB34CEF4C5E6" & _
				"F9BEE3F7BDDEF1C4E2F3C8DDE9DADADAF2F2F2CFD7DBEFEFEFEAF1F4BBDFF3CB" & _
				"DFEAC3E3F6C1DEEFC9E7F7C7E5F73AD6FDEEF0F2EFEFF0D2E1EAD6DDE0E6F1F7" & _
				"2BCEF9CFDADFD6D6D6D3DBDFC6DEEBC2DBE9CEDDE6C6DBE7CFE3EEBFDFF133D5" & _
				"FE3FD7FCEBF5FBEEF4F7EFF3F646D8FB36D5FE3BCDF132CEF5EAF1F3EAEFF1E6" & _
				"F3FBCEE4F036CDF4EBF3F7C9E6F7C3E0F0D3DEE5CBD6DCF1F2F2BADCF0C6E1F1" & _
				"CBD4D8C3DDECCBE5F5E9F2F7EBEEEFD2D2D2EDEEEEDBDBDBF3F3F3EFF1F3D6DF" & _
				"E3E6F5FCE7F0F6EDF4F9EAF6FC42D7FCEDF1F33BD6FDEAF5FAEEF3F529CFF9CB" & _
				"E3F0D1DCE1EBF0F2E9F0F4C5D9E4CEE1ECE9EEF1DADCDDEBECECD1E5F0CBE8F8" & _
				"CEE6F4CBD9E0DDDDDDD5E2E9ECEFEFD3E0E8E7F0F5E7F2F9D7DEE1E6F1F8E7F2" & _
				"F7EEF1F4ECF5FAF0F1F200000021FF0B4E45545343415045322E300301000000" & _
				"21F904050000FF002C000000000100150000081A00C900BBE36CCB9656D72CB9" & _
				"8BD4EE0D873D47E62811238C4C400021F904050000FF002C0000010001001300" & _
				"000818000BAD10A28D15AB7AD59CD80892C50E94492C2CEC7810100021F90405" & _
				"0000FF002C000001000100130000081800C151F82744DBBF45FFFEA9C8F78AD6"
		$bBinary &= "255189A2F5B912100021F904050000FF002C00000100010013000008170091B8" & _
				"20C7AF20BA62ECC66C2B724ED682668348200B080021F904050000FF002C0000" & _
				"01000100130000081700792DF945EE5FB87F08875C60766886BC291202690A08" & _
				"0021F904050000FF002C00000100010013000008180019F1F165855C14621E64" & _
				"D0B3D7E496814637E0BC1816100021F904050000FF002C000001000100130000" & _
				"081800C58DF817C5CA3F52E9FE4972D5034D183AEA0A98C110100021F9040500" & _
				"00FF002C00000100010013000008170057B1C114A520B50AF74AFC5967EA132E" & _
				"0D6708F808080021F904050000FF002C0000010001001300000817006B30F086" & _
				"09D3BF83DDDEE53AF1A1560E5B8F04410A080021F904050000FF002C00000100" & _
				"01001300000817008311EA87A9A09C7DB0A81C3307A68D34073CF2C40A080021" & _
				"F904050000FF002C0000010001001300000818001D11F9D7ABD7BF7FF8F4C59B" & _
				"8007DA32545F60802817100021F904050000FF002C0000010001001300000818" & _
				"0077D5E9356E5C8310C610C599D6C2130D5D9D9E495113100021F904050000FF" & _
				"002C000001000100130000081700716CF8F7EDDBBF83FFE02953752A85965269" & _
				"DC2008080021F904050000FF002C00000100010012000008160063E8F806A420" & _
				"376E5DBC28DA948153870E072004040021F904050000FF002C00000100010012" & _
				"0000081700716CE8F5ED5B8310C610C153A6EA540A2DA5D2B809080021F90405" & _
				"0000FF002C00000100010013000008170077D5F9376EDCBF83FFE24C6BE18986" & _
				"AE4ECFA4A809080021F904050000FF002C0000010001001300000818001D11E9" & _
				"D7ABD73839F8F4C59B8007DA32545F60802817100021F904050000FF002C0000" & _
				"010001001300000818008311FA8709D3BF7FFB605139660E4C1B690E78E48915" & _
				"100021F904050000FF002C0000010001001300000818006B30F0F6EF5F326A15" & _
				"BABDCB75E243AD1CB61E098214100021F904050000FF002C0000010001001300"
		$bBinary &= "0008170057B1C11425CABF83F74AFC5967EA132E0D6708F808080021F9040500" & _
				"00FF002C000001000100130000081800C58DF0F5CF4A1452E9644872D5034D18" & _
				"3AEA0A98C110100021F904050000FF002C00000100010013000008180019F1F9" & _
				"6785DC3F621EFED1B3D7E496814637E0BC1816100021F904050000FF002C0000" & _
				"01000100130000081800792DF9458E5F3874C5D80DB9C0ECD00C79532404D214" & _
				"100021F904050000FF002C00000100010013000008160091B820C7EF9F418363" & _
				"B61539276B41B341249005040021F904050000FF002C00000100010013000008" & _
				"1800C1511022441BAB45D59CA8C8F78AD6255189A2F5B912100021F904050000" & _
				"FF002C0000010001001300000818000BADF8A78DD5BF7AFFFED90892C50E94492" & _
				"C2CEC7810100021F904050000FF002C00000100010013000008180081DD71B665" & _
				"4BAB6B96DC456AF786C39E237394881116100021F904050A00FF002C000000000" & _
				"100150000081A0093000A15EADFBF5196DC2598870D54845922AC5112902D4940" & _
				"0021F904050A00FF002C000000000100150000081A00C900BBE3CCDFBF56D72CB" & _
				"98BD4EE0D873D47E62811238C4C400021F904050A00FF002C0000000001001500" & _
				"00081A000104D0A3275315439506A4C2C2C408173F267E3C59A30040400021F90" & _
				"4050A00FF002C000000000100150000080E00CB004241B0A0C183040195090800" & _
				"3B"

		Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
		DllStructSetData($tBinary, 1, $bBinary)

		$a_hCall = DllCall("kernel32.dll", "hwnd", "GlobalAlloc", "dword", 2, "dword", DllStructGetSize($tBinary))

		If @error Or Not $a_hCall[0] Then
			DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
			Return SetError(5, 0, "")
		EndIf

		$hMemory = $a_hCall[0]

		Local $a_pCall = DllCall("kernel32.dll", "ptr", "GlobalLock", "hwnd", $hMemory)

		If @error Or Not $a_pCall[0] Then
			DllCall("kernel32.dll", "int", "GlobalFree", "hwnd", $hMemory)
			DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
			Return SetError(6, 0, "")
		EndIf

		Local $pMemory = $a_pCall[0]

		DllCall("kernel32.dll", "none", "RtlMoveMemory", "ptr", $pMemory, "ptr", DllStructGetPtr($tBinary), "dword", DllStructGetSize($tBinary))

		DllCall("kernel32.dll", "int", "GlobalUnlock", "hwnd", $hMemory)

		$a_iCall = DllCall("ole32.dll", "int", "CreateStreamOnHGlobal", "ptr", $pMemory, "int", 1, "ptr*", 0)

		If @error Or $a_iCall[0] Then
			DllCall("kernel32.dll", "int", "GlobalFree", "hwnd", $hMemory)
			DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
			Return SetError(7, 0, "")
		EndIf

		Local $pStream = $a_iCall[3]

		$a_iCall = DllCall("gdiplus.dll", "dword", "GdipCreateBitmapFromStream", "ptr", $pStream, "ptr*", 0)

		If @error Or $a_iCall[0] Then
			DllCall("kernel32.dll", "int", "GlobalFree", "hwnd", $hMemory)
			DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
			Return SetError(8, 0, "")
		EndIf

		$pBitmap = $a_iCall[2]

	EndIf

	$a_iCall = DllCall("gdiplus.dll", "dword", "GdipImageGetFrameDimensionsCount", "ptr", $pBitmap, "dword*", 0)

	If @error Or $a_iCall[0] Then
		DllCall("gdiplus.dll", "dword", "GdipDisposeImage", "ptr", $pBitmap)
		DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
		If $hMemory Then DllCall("kernel32.dll", "int", "GlobalFree", "hwnd", $hMemory)
		Return SetError(9, 0, "")
	EndIf

	Local $iFrameDimensionsCount = $a_iCall[2]

	Local $tGUID = DllStructCreate("int;short;short;byte[8]")

	$a_iCall = DllCall("gdiplus.dll", "dword", "GdipImageGetFrameDimensionsList", "ptr", $pBitmap, "ptr", DllStructGetPtr($tGUID), "dword", $iFrameDimensionsCount)

	If @error Or $a_iCall[0] Then
		DllCall("gdiplus.dll", "dword", "GdipDisposeImage", "ptr", $pBitmap)
		DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
		If $hMemory Then DllCall("kernel32.dll", "int", "GlobalFree", "hwnd", $hMemory)
		Return SetError(10, 0, "")
	EndIf

	$a_iCall = DllCall("gdiplus.dll", "dword", "GdipImageGetFrameCount", "ptr", $pBitmap, "ptr", DllStructGetPtr($tGUID), "dword*", 0)

	If @error Or $a_iCall[0] Then
		DllCall("gdiplus.dll", "dword", "GdipDisposeImage", "ptr", $pBitmap)
		DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
		If $hMemory Then DllCall("kernel32.dll", "int", "GlobalFree", "hwnd", $hMemory)
		Return SetError(11, 0, "")
	EndIf

	Local $iFrameCount = $a_iCall[3]

	Local $aHBitmaps[$iFrameCount]

	For $i = 0 To $iFrameCount - 1

		$a_iCall = DllCall("gdiplus.dll", "dword", "GdipImageSelectActiveFrame", "ptr", $pBitmap, "ptr", DllStructGetPtr($tGUID), "dword", $i)

		If @error Or $a_iCall[0] Then
			$aHBitmaps[$i] = 0
			ContinueLoop
		EndIf

		$a_iCall = DllCall("gdiplus.dll", "dword", "GdipCreateHICONFromBitmap", "ptr", $pBitmap, "hwnd*", 0)

		If @error Or $a_iCall[0] Then
			$aHBitmaps[$i] = 0
			ContinueLoop
		EndIf

		$aHBitmaps[$i] = $a_iCall[2]

	Next

	DllCall("gdiplus.dll", "dword", "GdipDisposeImage", "ptr", $pBitmap)
	DllCall("gdiplus.dll", "none", "GdiplusShutdown", "dword*", $hGDIplus)
	If $hMemory Then DllCall("kernel32.dll", "int", "GlobalFree", "hwnd", $hMemory) ; free memory

	Return SetError(0, 0, $aHBitmaps)

EndFunc   ;==>_CreateArrayHIcons
;===============================================================================
;
; Name...........: _VistaLikeRenderButton
; Description ...: Forming the effect on buttons similar to Vista OS
; Syntax.........: _VistaLikeRenderButton($hButton, ByRef $tBUTTON_IMAGELIST, ByRef $aImagesHandles)
; Parameters ....: $hButton - button controlID
;                  $tBUTTON_IMAGELIST - variable that receives structure used by this function
;                  $aImagesHandles - variable that receives array of icon handles
; Return values .: Success: - Returns handle to the new thread in which button is handled
;                           - Sets @error to 0
;                  Failure: Returns nothing and sets @eror:
;                  |1 - Could not get button handle
;                  |2 - Failed determining the size of button
;                  |3 - _CreateArrayHIcons() function from this script failed. @extended will have error value of that function.
;                  |4 - ImageList_Create function or call to it failed
;                  |5 - kernel32.dll used functions problem
;                  |6 - comctl32.dll used functions problem
;                  |7 - user32.dll used functions problem
;                  |8 - VirtualAlloc function or call to it failed
;                  |9 - CreateThread function or call to it failed
; Remarks .......: $aImagesHandles can be shared. You are responsible for disposing handles after not needed. You may leave the job to OS though.
; Author ........: trancexx
;===============================================================================

Func _VistaLikeRenderButton($hButton, ByRef $tBUTTON_IMAGELIST, ByRef $aImagesHandles)

	$hButton = GUICtrlGetHandle($hButton)
	If Not $hButton Then Return SetError(1, 0, 0)

	Local $aButtonSize = WinGetClientSize($hButton)
	If @error Then Return SetError(2, 0, 0)

	If Not UBound($aImagesHandles) = 31 Then
		$aImagesHandles = _CreateArrayHIcons()
		If @error Then Return SetError(3, @error, 0)
	EndIf

	Local $aCall = DllCall("comctl32.dll", "hwnd", "ImageList_Create", "int", $aButtonSize[0] - 6, "int", $aButtonSize[1], "dword", 32, "int", 31, "int", 1)

	If @error Or Not $aCall[0] Then Return SetError(4, 0, 0)

	Local $hImageListInThread = $aCall[0]

	DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "hwnd", $hImageListInThread, "int", -1, "hwnd", $aImagesHandles[27])
	DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "hwnd", $hImageListInThread, "int", -1, "hwnd", $aImagesHandles[28])
	DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "hwnd", $hImageListInThread, "int", -1, "hwnd", $aImagesHandles[29])
	DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "hwnd", $hImageListInThread, "int", -1, "hwnd", $aImagesHandles[30])
	DllCall("comctl32.dll", "int", "ImageList_ReplaceIcon", "hwnd", $hImageListInThread, "int", -1, "hwnd", $aImagesHandles[0])

	$tBUTTON_IMAGELIST = DllStructCreate("hwnd ImageList;int Left;int Top;int Right;int Bottom;dword Align")

	DllStructSetData($tBUTTON_IMAGELIST, "Align", 4)
	DllStructSetData($tBUTTON_IMAGELIST, "ImageList", $hImageListInThread)

	Local $pBUTTON_IMAGELIST = DllStructGetPtr($tBUTTON_IMAGELIST)

	$aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "kernel32.dll")
	If @error Or Not $aCall[0] Then Return SetError(5, 0, 0)

	Local $hHandle = $aCall[0]

	Local $aSleep = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $hHandle, "str", "Sleep")
	If @error Or Not $aCall[0] Then Return SetError(5, 0, 0)
	Local $pSleep = $aSleep[0]

	$aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "comctl32.dll")
	If @error Or Not $aCall[0] Then Return SetError(6, 0, 0)

	$hHandle = $aCall[0]

	Local $aImLReplaceIcon = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $hHandle, "str", "ImageList_ReplaceIcon")
	If @error Or Not $aCall[0] Then Return SetError(6, 0, 0)
	Local $pImLReplaceIcon = $aImLReplaceIcon[0]

	$aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "user32.dll")
	If @error Or Not $aCall[0] Then Return SetError(7, 0, 0)

	$hHandle = $aCall[0]

	Local $aSendMessageW = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $hHandle, "str", "SendMessageW")
	If @error Or Not $aCall[0] Then Return SetError(7, 0, 0)
	Local $pSendMessageW = $aSendMessageW[0]

	Local $aGetWindowLongW = DllCall("kernel32.dll", "ptr", "GetProcAddress", "ptr", $hHandle, "str", "GetWindowLongW")
	If @error Or Not $aCall[0] Then Return SetError(7, 0, 0)
	Local $pGetWindowLongW = $aGetWindowLongW[0]

	Local $tHandles = DllStructCreate("hwnd[27]")
	For $i = 1 To 27
		DllStructSetData($tHandles, 1, $aImagesHandles[$i - 1], $i)
	Next

	Local $pHandles = DllStructGetPtr($tHandles)

	$aCall = DllCall("kernel32.dll", "ptr", "VirtualAlloc", "ptr", 0, "dword", 512, "dword", 4096, "dword", 64)

	If @error Or Not $aCall[0] Then Return SetError(8, 0, 0)

	Local $pRemoteCode = $aCall[0]

	Local $tCodeBuffer = DllStructCreate("byte[512]", $pRemoteCode)

	DllStructSetData($tCodeBuffer, 1, _
			"0x" & _
			"" & _
			"BB" & SwapEndian($pHandles) & _
			"" & _
			"8B03" & _
			"" & _
			"50" & _
			"68" & SwapEndian(4) & _
			"68" & SwapEndian($hImageListInThread) & _
			"B8" & SwapEndian($pImLReplaceIcon) & _
			"FFD0" & _
			"" & _
			"68" & SwapEndian($pBUTTON_IMAGELIST) & _
			"68" & SwapEndian(0) & _
			"68" & SwapEndian(5634) & _
			"68" & SwapEndian($hButton) & _
			"B8" & SwapEndian($pSendMessageW) & _
			"FFD0" & _
			"" & _
			"68" & SwapEndian(0) & _
			"68" & SwapEndian(1) & _
			"68" & SwapEndian(10) & _
			"68" & SwapEndian($hButton) & _
			"B8" & SwapEndian($pSendMessageW) & _
			"FFD0" & _
			"" & _
			"68" & SwapEndian(150) & _
			"B8" & SwapEndian($pSleep) & _
			"FFD0" & _
			"" & _
			"68" & SwapEndian(-16) & _
			"68" & SwapEndian($hButton) & _
			"B8" & SwapEndian($pGetWindowLongW) & _
			"FFD0" & _
			"" & _
			"A9" & SwapEndian(7) & _
			"74" & Hex(-36, 2) & _
			"" & _
			"68" & SwapEndian(0) & _
			"68" & SwapEndian(0) & _
			"68" & SwapEndian(242) & _
			"68" & SwapEndian($hButton) & _
			"B8" & SwapEndian($pSendMessageW) & _
			"FFD0" & _
			"" & _
			"83F8" & Hex(8, 2) & _
			"75" & Hex(-68, 2) & _
			"" & _
			"83C3" & Hex(4, 2) & _
			"81FB" & SwapEndian($pHandles + 27 * 4) & _
			"" & _
			"72" & Hex(5, 2) & _
			"" & _
			"E9" & SwapEndian(-163) & _
			"" & _
			"E9" & SwapEndian(-163) & _
			"C3" _
			)

	$aCall = DllCall("kernel32.dll", "ptr", "CreateThread", "ptr", 0, "dword", 0, "ptr", $pRemoteCode, "ptr", 0, "dword", 0, "dword*", 0)

	If @error Or Not $aCall[0] Then Return SetError(9, 0, 0)

	Local $hRenderingThread = $aCall[0]

	Return SetError(0, 0, $hRenderingThread)

EndFunc   ;==>_VistaLikeRenderButton

;===============================================================================
;
; Name...........: SwapEndian
; Description ...: 4 byte endian swapper
; Syntax.........: SwapEndian($iValue)
; Remarks .......: This function if for internal useage by this script
; Author ........: trancexx
;===============================================================================

Func SwapEndian($iValue)
	Return Hex(BinaryMid($iValue, 1, 4))
EndFunc   ;==>SwapEndian
#EndRegion Vista Buttons;### Tidy Error -> switch is never closed in your script.

#Region Included Functions

Func _GUICtrlEdit_GetTextLen($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)

	Return _SendMessage($hWnd, $__EDITCONSTANT_WM_GETTEXTLENGTH)
EndFunc   ;==>_GUICtrlEdit_GetTextLen
Func _INetGetSource($s_URL, $s_Header = '')

	If StringLeft($s_URL, 7) <> 'http://' And StringLeft($s_URL, 8) <> 'https://' Then $s_URL = 'http://' & $s_URL

	Local $h_DLL = DllOpen("wininet.dll")

	Local $ai_IRF, $s_Buf = ''

	Local $ai_IO = DllCall($h_DLL, 'int', 'InternetOpen', 'str', "AutoIt v3", 'int', 0, 'int', 0, 'int', 0, 'int', 0)
	If @error Or $ai_IO[0] = 0 Then
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf

	Local $ai_IOU = DllCall($h_DLL, 'int', 'InternetOpenUrl', 'int', $ai_IO[0], 'str', $s_URL, 'str', $s_Header, 'int', StringLen($s_Header), 'int', 0x80000000, 'int', 0)
	If @error Or $ai_IOU[0] = 0 Then
		DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
		DllClose($h_DLL)
		SetError(1)
		Return ""
	EndIf

	Local $v_Struct = DllStructCreate('udword')
	DllStructSetData($v_Struct, 1, 1)

	While DllStructGetData($v_Struct, 1) <> 0
		$ai_IRF = DllCall($h_DLL, 'int', 'InternetReadFile', 'int', $ai_IOU[0], 'str', '', 'int', 256, 'ptr', DllStructGetPtr($v_Struct))
		$s_Buf &= StringLeft($ai_IRF[2], DllStructGetData($v_Struct, 1))
	WEnd

	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IOU[0])
	DllCall($h_DLL, 'int', 'InternetCloseHandle', 'int', $ai_IO[0])
	DllClose($h_DLL)
	Return $s_Buf
EndFunc   ;==>_INetGetSource

Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lparam")
	Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessage", "hwnd", $hWnd, "int", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
	Return $aResult
EndFunc   ;==>_SendMessage

Func _WinAPI_HiWord($iLong)
	Return BitShift($iLong, 16)
EndFunc   ;==>_WinAPI_HiWord

Func _WinAPI_LoWord($iLong)
	Return BitAND($iLong, 0xFFFF)
EndFunc   ;==>_WinAPI_LoWord
#EndRegion Included Functions