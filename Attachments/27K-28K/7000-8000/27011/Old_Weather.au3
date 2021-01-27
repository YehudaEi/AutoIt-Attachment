#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=weather_icon.ico
#AutoIt3Wrapper_Res_Fileversion=1.5.6.10
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sfc
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;WindowsConstants.au3
Global Const $WM_COMMAND = 0x0111
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_POPUPWINDOW = 0x80880000

;StaticConstants.au3
Global Const $SS_CENTER = 1

;GUIEdit.au3
Global Const $__EDITCONSTANT_WM_GETTEXTLENGTH = 0x000E

;GUIConstantsEx.au3
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_RUNDEFMSG = "GUI_RUNDEFMSG"
Global Const $GUI_DOCKALL = 0x0322
Global Const $GUI_BKCOLOR_TRANSPARENT = -2

;Constants.au3
Global Const $TRAY_EVENT_PRIMARYDOUBLE = -13

;EditConstants.au3
Global Const $ES_RIGHT = 2
Global Const $ES_NUMBER = 8192
Global Const $EN_CHANGE = 0x300
Global Const $EN_KILLFOCUS = 0x200
Global Const $EN_SETFOCUS = 0x100

;ButtonConstants.au3
Global Const $BS_FLAT = 0x8000
Global Const $BS_DEFPUSHBUTTON = 0x0001
Global Const $BS_CENTER = 0x0300

Global Const $IniDir = @AppDataDir & "\WeatherTray\Settings.ini"

Opt("GUIResizeMode", $GUI_DOCKALL)
Opt("TrayMenuMode", 1)

If Not FileExists(@AppDataDir & "\WeatherTray") Then
	DirCreate(@AppDataDir & "\WeatherTray")
	For $i = 0 To 48
		InetGet("http://image.weather.com/web/common/wxicons/52/" & $i & ".gif?12122006", @AppDataDir & "\WeatherTray\Pic" & $i & ".gif")
	Next
EndIf
If Not FileExists(@AppDataDir & "\WeatherTray\Settings.ini") Then
	IniWrite($IniDir, "Settings", "Current", "West Chester, OH")
	IniWrite($IniDir, "Settings", "Refresh", 2)
	IniWrite($IniDir, "Settings", "Days", "7")
EndIf
Global $ZipCode
Global $Home = "West Chester, OH"
Global $Current = IniRead($IniDir, "Settings", "Current", "West Chester, OH")
Global $Refresh_Rate = IniRead($IniDir, "Settings", "Refresh", 2)
Global $Days = IniRead($IniDir, "Settings", "Days", "7")

$Form1 = GUICreate("Weather Gadget", 200, 232)
GUISetBkColor(0xFFFFFF)

#Region Tray Menu
TraySetClick(16)
$Tray_Show = TrayCreateItem("Show Gadget")
$Tray_Minimize = TrayCreateItem("Minimize to Tray")
TrayCreateItem("")
$Tray_Exit = TrayCreateItem("Exit")
#EndRegion Tray Menu

#Region Menu
$FileMenu = GUICtrlCreateMenu("&File")
$File_Minimize = GUICtrlCreateMenuItem("&Minimize to Tray", $FileMenu)
$File_Settings = GUICtrlCreateMenuItem("&Settings", $FileMenu)
GUICtrlCreateMenuItem("", $FileMenu)
$File_Exit = GUICtrlCreateMenuItem("&Exit", $FileMenu)
#EndRegion Menu

GUICtrlCreateLabel("Weather Right Now For", 16, 8, 166, 14, $SS_CENTER)
GUICtrlSetFont(-1, 8.5, 600)
$Link = GUICtrlCreateLabel($Home, 16, 24, 166, 17, $SS_CENTER)
ControlFocus($Form1, "", $Link)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 8.5, 400, 4)
GUICtrlSetColor(-1, 0x0000FF)
$Temperature = GUICtrlCreateLabel("", 88, 45, 70, 31)
GUICtrlSetFont(-1, 18, 400, 0, "Georgia")
GUICtrlSetColor(-1, 0x565963)
$Condition = GUICtrlCreateLabel("", 80, 78, 100, 38)
GUICtrlSetFont(-1, 8.5, 400, 0, "Georgia")
$Info = GUICtrlCreateLabel("", 16, 110, 140, 27)
$Input = GUICtrlCreateInput("", 12, 144, 150, 21)
GUICtrlSetData(-1, $Home)
GUICtrlSetColor(-1, 0x808080)
$Pic = GUICtrlCreatePic("", 16, 48, 52, 52)
$Go_Button = GUICtrlCreateButton("Go", 164, 144, 26, 21, BitOR($BS_FLAT, $BS_DEFPUSHBUTTON))
;~ DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
$Home_Button = GUICtrlCreateButton("Go Home", 12, 166, 52, 20, $BS_FLAT)
;~ DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
$Expand_Button = GUICtrlCreateButton("Expand", 74, 166, 52, 20, $BS_FLAT)
;~ DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
$English_Metric_Button = GUICtrlCreateLabel("Metric", 160, 170, 100, 14)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 8.5, 400, 4)
GUICtrlSetColor(-1, 0x0000EE)
$Extended_Button = GUICtrlCreateButton("Extended", 12, 190, 52, 20, $BS_FLAT)
;~ DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
$Hourly_Button = GUICtrlCreateButton("Hourly", 74, 190, 52, 20, $BS_FLAT)
;~ DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

$Stats = _GetWeatherInfo($Home)
If $Stats <> -1 Then
	GUICtrlSetData($Condition, $Stats[0])
	GUICtrlSetData($Temperature, $Stats[1])
	GUICtrlSetData($Link, GUICtrlRead($Input))
	Global $Current = GUICtrlRead($Input)
	GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[8] & ".gif")
	GUICtrlSetData($Info, $Stats[2] & @CRLF & $Stats[3] & @CRLF & $Stats[4] & @CRLF & $Stats[5] & _
			@CRLF & $Stats[6] & @CRLF & $Stats[7])
	GUICtrlSetTip($Link, "http://www.weather.com/weather/local/" & $ZipCode)
EndIf

GUISetState()

$Timer = TimerInit()
_ReduceMemory()

While 1
	$Msg = GUIGetMsg()
	$TrayMsg = TrayGetMsg()
	Switch $TrayMsg
		Case $Tray_Exit
			_WinAnimate($Form1, 1, 1, 150, 0)
			Exit
		Case $Tray_Minimize
			_WinAnimate($Form1, Random(1, 9, 1), 1, 60, 0)
		Case $TRAY_EVENT_PRIMARYDOUBLE
			If WinGetState($Form1) < 7 Then
				_WinAnimate($Form1, Random(1, 9, 1), 0, 60, 0)
			Else
				_WinAnimate($Form1, Random(1, 9, 1), 1, 60, 0)
			EndIf
		Case $Tray_Show
			_WinAnimate($Form1, Random(1, 9, 1), 0, 60, 0)
	EndSwitch
	Switch $Msg
		Case $GUI_EVENT_CLOSE, $File_Exit
			_WinAnimate($Form1, 1, 1, 150, 0)
			Exit
		Case $File_Minimize
			_WinAnimate($Form1, Random(1, 9, 1), 1, 60, 0)
		Case $Home_Button
			If GUICtrlRead($English_Metric_Button) = "Metric" Then
				$Stats = _GetWeatherInfo($Home, "English")
			Else
				$Stats = _GetWeatherInfo($Home, "Metric")
			EndIf
			If $Stats <> -1 Then
				GUICtrlSetData($Condition, $Stats[0])
				GUICtrlSetData($Temperature, $Stats[1])
				GUICtrlSetData($Link, GUICtrlRead($Input))
				Global $Current = GUICtrlRead($Input)
				GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[8] & ".gif")
				GUICtrlSetData($Info, $Stats[2] & @CRLF & $Stats[3] & @CRLF & $Stats[4] & @CRLF & $Stats[5] & _
						@CRLF & $Stats[6] & @CRLF & $Stats[7])
				GUICtrlSetTip($Link, "http://www.weather.com/weather/local/" & $ZipCode)
			EndIf
			$Timer = TimerInit()
		Case $Go_Button
			If GUICtrlRead($English_Metric_Button) = "Metric" Then
				$Stats = _GetWeatherInfo(GUICtrlRead($Input), "English")
			Else
				$Stats = _GetWeatherInfo(GUICtrlRead($Input), "Metric")
			EndIf
			If $Stats <> -1 Then
				GUICtrlSetData($Condition, $Stats[0])
				GUICtrlSetData($Temperature, $Stats[1])
				GUICtrlSetData($Link, GUICtrlRead($Input))
				Global $Current = GUICtrlRead($Input)
				GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[8] & ".gif")
				GUICtrlSetData($Info, $Stats[2] & @CRLF & $Stats[3] & @CRLF & $Stats[4] & @CRLF & $Stats[5] & _
						@CRLF & $Stats[6] & @CRLF & $Stats[7])
				GUICtrlSetTip($Link, "http://www.weather.com/weather/local/" & $ZipCode)
			EndIf
			$Timer = TimerInit()
		Case $Link
			ShellExecute("http://www.weather.com/weather/local/" & $ZipCode)
		Case $File_Settings
			Settings()
		Case $Expand_Button
			If GUICtrlRead($Expand_Button) = "Expand" Then
				GUICtrlSetData($Expand_Button, "Hide")
			Else
				GUICtrlSetData($Expand_Button, "Expand")
			EndIf
			Expand()
		Case $English_Metric_Button
			If GUICtrlRead($English_Metric_Button) = "Metric" Then
				GUICtrlSetData($English_Metric_Button, "English")
				$Stats = _GetWeatherInfo(GUICtrlRead($Input), "Metric")
			Else
				GUICtrlSetData($English_Metric_Button, "Metric")
				$Stats = _GetWeatherInfo(GUICtrlRead($Input))
			EndIf
			If $Stats <> -1 Then
				GUICtrlSetData($Condition, $Stats[0])
				GUICtrlSetData($Temperature, $Stats[1])
				GUICtrlSetData($Link, GUICtrlRead($Input))
				Global $Current = GUICtrlRead($Input)
				GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[8] & ".gif")
				GUICtrlSetData($Info, $Stats[2] & @CRLF & $Stats[3] & @CRLF & $Stats[4] & @CRLF & $Stats[5] & _
						@CRLF & $Stats[6] & @CRLF & $Stats[7])
				GUICtrlSetTip($Link, "http://www.weather.com/weather/local/" & $ZipCode)
			EndIf
			$Timer = TimerInit()
		Case $Extended_Button
			GUISetState(@SW_DISABLE, $Form1)
			Extended_Forcast()
			GUISetState(@SW_ENABLE, $Form1)
			WinActivate($Form1)
		Case $Hourly_Button
			GUISetState(@SW_DISABLE, $Form1)
			HourByHour()
			GUISetState(@SW_ENABLE, $Form1)
			WinActivate($Form1)
	EndSwitch
	If TimerDiff($Timer) > 60000 * $Refresh_Rate Then
		If GUICtrlRead($English_Metric_Button) = "Metric" Then
			$Stats = _GetWeatherInfo(GUICtrlRead($Input), "English")
		Else
			$Stats = _GetWeatherInfo(GUICtrlRead($Input), "Metric")
		EndIf
		If $Stats <> -1 Then
			GUICtrlSetData($Condition, $Stats[0])
			GUICtrlSetData($Temperature, $Stats[1])
			GUICtrlSetData($Link, GUICtrlRead($Input))
			Global $Current = GUICtrlRead($Input)
			GUICtrlSetImage($Pic, @AppDataDir & "\WeatherTray\Pic" & $Stats[8] & ".gif")
			GUICtrlSetData($Info, $Stats[2] & @CRLF & $Stats[3] & @CRLF & $Stats[4] & @CRLF & $Stats[5] & _
					@CRLF & $Stats[6] & @CRLF & $Stats[7])
			GUICtrlSetTip($Link, "http://www.weather.com/weather/local/" & $ZipCode)
		EndIf
		$Timer = TimerInit()
	EndIf
	Sleep(10)
WEnd

Func _English_Metric($Value, $Option)
	If StringLower($Option) = "kilometer" Then
		$Value *= 1.6093
	ElseIf StringLower($Option) = "celcius" Then
		$Value = ((5 / 9) * ($Value - 32))
	EndIf
	Return $Value
EndFunc   ;==>_English_Metric

Func _GetWeatherInfo($Place, $Measurement = "English")
	Local $Pic

	$CityState = StringRegExpReplace($Place, "(?-i)[()1234567890]", "")
	$CityStateA = StringSplit($CityState, ",")
	If @error Then
		Return _SetError(1, $Place)
	Else
		$CityStateA[1] = StringReplace($CityStateA[1], " ", "+")
		$CityStateA[2] = StringReplace($CityStateA[2], " ", "")
		$GetZIP = _INetGetSource("http://zipcodes.addresses.com/results.php?ReportType=42&qc=" & $CityStateA[1] & "&qs=" & $CityStateA[2])
		$GetZip2 = _StringBetween($GetZIP, '<td class="F1">', '</td>')
		If @error Then
			Return _SetError(2, $Place)
		Else
			$ZipCode = $GetZip2[0]
		EndIf
	EndIf
	$source = "http://www.weather.com/weather/local/" & $ZipCode
	$File = _INetGetSource($source)
	$Town = _StringBetween($File, "<B>Right Now for</B><BR>", " (")
	$GetWVH = _StringBetween($File, '<TD VALIGN="top"  CLASS="obsTextA">', '</td>')
	If @error Then
		Return _SetError(3, $Place)
	Else
		$TemperatureArray = _StringBetween($File, "temp=", "&")
		$CondArray = _StringBetween($File, "<B CLASS=obsTextA>", "</B>")
		$PictArray = _StringBetween($File, '<IMG SRC="http://image.weather.com/web/common/wxicons/52/', _
				'.gif?12122006" WIDTH=52 HEIGHT=52 BORDER=0 ALT=>')
		If $TemperatureArray <> 0 Then
			$Cond = $CondArray[0]
			$Feel = $CondArray[1]
			$Feel = StringRegExpReplace($Feel, "(?-i)[FelsLik<BR>&deg; ]", "")
			$Temp = $TemperatureArray[0]
			$Humidity = "Humidity: " & $GetWVH[3]
			$UV = "UV: " & $GetWVH[0]
			If $Measurement = "English" Then
				$Temp = $TemperatureArray[0] & "°F"
				$Feel = "Feels Like " & $Feel & "°F"
				$Wind = "Wind: " & StringReplace($GetWVH[1], " <BR> ", @CRLF)
				$Visibility = "Visibility: " & $GetWVH[9]
				$DewPoint = "Dew Point: " & StringReplace($GetWVH[7], "&deg;F", Chr(176) & "F")
			Else
				$Temp = Round(_English_Metric($TemperatureArray[0], "celcius"), 0) & "°C"
				$Feel = "Feels Like " & Round(_English_Metric($Feel, "celcius"), 0) & "°C"
				Local $String = StringRegExp($GetWVH[1], "\d+", 1)
				If IsArray($String) Then
					$Wind = "Wind: " & StringReplace($GetWVH[1], $String[0] & " mph", Round(_English_Metric($String[0], "kilometer"), 1) & " kph")
				Else
					$Wind = "Wind: " & StringReplace($GetWVH[1], " <BR> ", @CRLF)
				EndIf
				$String = StringRegExp($GetWVH[7], "\d+", 1)
				$DewPoint = "Dew Point:" & Round(_English_Metric($String[0], "celcius"), 0) & Chr(176) & "C"
				$Visibility = "Visibility: " & Round(_English_Metric(StringRegExpReplace($GetWVH[9], "(?-i)[ miles]", ""), "kilometer"), 1) & " kilometers"
			EndIf
			Local $Weather[9] = [$Cond, $Temp, $Feel, $Visibility, $Wind, $Humidity, $UV, $DewPoint, $PictArray[0]]
			Return $Weather
		EndIf
	EndIf
EndFunc   ;==>_GetWeatherInfo

Func _SetError($Error, $Data)
	Switch $Error
		Case 0
			Return 0
		Case 1
			$ErrorTitle = "Error: Comma"
			$ErrorMsg = "'" & $Data & "'" & " was not found." & @CRLF & _
					"Please put city and state with a comma between them."
		Case 2
			$ErrorTitle = "Error: Spelling"
			$ErrorMsg = "'" & $Data & "'" & " was not found." & @CRLF & _
					"Unable to find either city, state, or zip." & @CRLF & _
					"Please check your spelling of both city and state."
		Case 3
			$ErrorTitle = "Error: Zip Code"
			$ErrorMsg = "'" & $Data & "'" & " was not found." & @CRLF & _
					"No matches found. Try another zip. U.S. zips" & @CRLF & _
					" are 5 digits long. Try typing 'city, state'" & @CRLF & _
					"if you can not find zip."
	EndSwitch

	MsgBox(0, $ErrorTitle, $ErrorMsg)
	Return -1
EndFunc   ;==>_SetError

Func _WinAnimate($Xwnd, $Xstyle = 0, $Xstate = 0, $Xdistance = 100, $Xdelay = 10)
	; $Xstate  - 0 = Show, 1 = Hide,
	; $Xstyle  - 1=Fade, 2=L-Slide, 3=R-Slide, 4=T-Slide, 5=B-Slide, 6=TL-Diag-Slide, 7=BL-Diag-Slide, 8=TR-Diag-Slide, 9=BR-Diag-Slide

	; Error checking...
	If Not WinExists($Xwnd) Then Return SetError(1, -1, "window does not exist")
	If Not $Xstate == 0 Or Not $Xstate == 1 Then Return SetError(2, -1, "State is not Show or Hide")
	If $Xstyle == 0 Or $Xstyle >= 10 Then Return SetError(3, -1, "Style is out-of-range")

	; Find Window location and Centered...
	Local $XPos = WinGetPos($Xwnd), $X_Move = 0, $Y_Move = 0, $MoveIt = 0
	$X_Start = $XPos[0]
	$Y_Start = $XPos[1]
	$X_Final = (@DesktopWidth - $XPos[2]) / 2
	$Y_Final = (@DesktopHeight - $XPos[3]) / 2

	If $Xstate == 0 Then ; to Show the GUI
		WinSetTrans($Xwnd, "", 0)
		GUISetState(@SW_SHOW, $Xwnd)
		$Xtrans = 255 / $Xdistance
		If $Xstyle = 2 Or $Xstyle = 6 Or $Xstyle = 7 Then
			$X_Move = 1
			$X_Final = $X_Final - $Xdistance
		ElseIf $Xstyle = 3 Or $Xstyle = 8 Or $Xstyle = 9 Then
			$X_Move = -1
			$X_Final = $X_Final + $Xdistance
		EndIf
		If $Xstyle = 4 Or $Xstyle = 6 Or $Xstyle = 8 Then
			$Y_Move = 2
			$Y_Final = $Y_Final - ($Xdistance * 2)
		ElseIf $Xstyle = 5 Or $Xstyle = 7 Or $Xstyle = 9 Then
			$Y_Move = -2
			$Y_Final = $Y_Final + ($Xdistance * 2)
		EndIf
	Else ; to hide the GUI
		$Xtrans = -1 * (255 / $Xdistance)
		$X_Final = $X_Start
		$Y_Final = $Y_Start
		If $Xstyle = 2 Or $Xstyle = 6 Or $Xstyle = 7 Then $X_Move = -1
		If $Xstyle = 3 Or $Xstyle = 8 Or $Xstyle = 9 Then $X_Move = 1
		If $Xstyle = 4 Or $Xstyle = 6 Or $Xstyle = 8 Then $Y_Move = -2
		If $Xstyle = 5 Or $Xstyle = 7 Or $Xstyle = 9 Then $Y_Move = 2
	EndIf
	If $Y_Move <> 0 Or $X_Move <> 0 Then $MoveIt = 1
	WinMove($Xwnd, "", $X_Final, $Y_Final)
	For $x = 1 To $Xdistance
		$XPos = WinGetPos($Xwnd)
		WinSetTrans($Xwnd, "", $x * $Xtrans)
		If $MoveIt = 1 Then WinMove($Xwnd, "", $XPos[0] + $X_Move, $XPos[1] + $Y_Move)
		Sleep($Xdelay)
	Next
	If $Xstate = 1 Then GUISetState(@SW_HIDE, $Xwnd)
EndFunc   ;==>_WinAnimate

Func Expand()
	Local $Move = 50
	Local $Pos = WinGetPos($Form1)
	If $Pos[3] = 262 Then
		WinMove($Form1, "", $Pos[0], $Pos[1], 206, 262 + $Move)
		ControlMove($Form1, "", $Info, 16, 110, 140, 27 + $Move)
		ControlMove($Form1, "", $Extended_Button, 12, 190 + $Move)
		ControlMove($Form1, "", $Hourly_Button, 74, 190 + $Move)
		ControlMove($Form1, "", $Input, 12, 144 + $Move)
		ControlMove($Form1, "", $Go_Button, 164, 144 + $Move)
		ControlMove($Form1, "", $English_Metric_Button, 160, 170 + $Move)
		ControlMove($Form1, "", $Expand_Button, 74, 166 + $Move)
		ControlMove($Form1, "", $Home_Button, 12, 166 + $Move)
	Else
		WinMove($Form1, "", $Pos[0], $Pos[1], 206, 262)
		ControlMove($Form1, "", $Info, 16, 110, 140, 27)
		ControlMove($Form1, "", $Extended_Button, 12, 190)
		ControlMove($Form1, "", $Hourly_Button, 74, 190)
		ControlMove($Form1, "", $Input, 12, 144)
		ControlMove($Form1, "", $Go_Button, 164, 144)
		ControlMove($Form1, "", $English_Metric_Button, 160, 170)
		ControlMove($Form1, "", $Expand_Button, 74, 166)
		ControlMove($Form1, "", $Home_Button, 12, 166)
	EndIf
EndFunc   ;==>Expand

Func Extended_Forcast($Day_Num = $Days, $Place = $Current)
	Local $Temp[1], $Day[11], $Image[11], $Condition[11], $HighTemp[11], $LowTemp[11], $Precipitation[11], $Direction[11], $Wind[11]
	Local $CityState, $CityStateA, $GetZIP, $GetZip2, $Zip, $source, $Left, $Msg, $GUI

	$CityState = StringRegExpReplace($Place, "(?-i)[()1234567890]", "")
	$CityStateA = StringSplit($CityState, ",")
	If @error Then
		Return SetError(1, $Place, -1)
	Else
		$CityStateA[1] = StringReplace($CityStateA[1], " ", "+")
		$CityStateA[2] = StringReplace($CityStateA[2], " ", "")
		$GetZIP = _INetGetSource("http://zipcodes.addresses.com/results.php?ReportType=42&qc=" & $CityStateA[1] & "&qs=" & $CityStateA[2])
		$GetZip2 = _StringBetween($GetZIP, '<td class="F1">', '</td>')
		If @error Then
			Return SetError(2, $Place, -1)
		Else
			$Zip = $GetZip2[0]
		EndIf
	EndIf

	If $Day_Num > 9 Then Return SetError(1, 0, -1)
	$source = _INetGetSource("http://www.weather.com/weather/tenday/" & $Zip & "?dp=windsdp")
	If @error Then Return SetError(2, 0, -1)
	$GUI = GUICreate("Extended Forecast", $Day_Num * 105 + 15, 90 + 30 + 40 + 20 + 20 + 20 + 10, -1, -1, BitOR($WS_POPUPWINDOW, $WS_CAPTION), -1, $Form1)
	$source = StringTrimLeft($source, StringInStr($source, '<P class="tdBarChartBot"></P>'))
	$Left = 15
	For $x = 2 To $Day_Num + 1
		$Temperary = _StringBetween($source, '<!-- day ' & $x & ' -->', '</div><!-- wrapper for row -->')
		$Temp = _StringBetween($Temperary[0], 'Num=' & ($x - 1) & '">', '</p>')
		$Day[$x] = StringReplace($Temp[0], "</a><br>", ", ")
		$Temp = _StringBetween($Temperary[0], '<p><img src="', '""')
		$Temp = StringRegExp($Temp[0], "\d{1,2}.gif", 2)
		$Image[$x] = $Temp[0]
		$Temp = _StringBetween($Temperary[0], 'alt="', '"><br>')
		$Condition[$x] = $Temp[0]
		$Temp = _StringBetween($Temperary[0], '<p><strong>', '</strong><br>')
		$HighTemp[$x] = StringReplace($Temp[0], '&deg;', Chr(176))
		$Temp = _StringBetween($Temperary[0], '</strong><br>', '</p>')
		$LowTemp[$x] = StringReplace($Temp[0], '&deg;', Chr(176))

		$Temperary[0] = StringTrimLeft($Temperary[0], StringInStr($Temperary[0], "<!-- precip -->"))
		$Temp = _StringBetween($Temperary[0], '<p>', '</p>')
		$Precipitation[$x] = StringReplace($Temp[0], "&#37;", Chr(37))
		$Temp = _StringBetween($Temperary[0], '<td><p>', '</p></td>')
		$Direction[$x] = $Temp[0]
		$Temp = _StringBetween($Temperary[0], '<strong>', '</strong>')
		$Wind[$x] = $Temp[0] & " mph"
		GUICtrlCreateLabel($Day[$x], $Left, 15, 90, 25, $SS_CENTER)
		GUICtrlSetFont(-1, 10, 600, 0, "Georgia")
		GUICtrlCreatePic(@AppDataDir & "\WeatherTray\Pic" & $Image[$x], $Left, 35, 90, 90)
		GUICtrlCreateLabel($Condition[$x], $Left, 35 + 90, 90, 30, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 10, 400, 0, "Georgia")
		GUICtrlCreateLabel($HighTemp[$x] & "/" & $LowTemp[$x], $Left, 90 + 30 + 40, 90, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 12, 600, 0, "Georgia")
		GUICtrlCreateLabel("Precip: " & $Precipitation[$x], $Left, 90 + 30 + 40 + 20, 90, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 10, 400, 0, "Georgia")
		GUICtrlCreateLabel("Wind: " & $Wind[$x], $Left, 90 + 30 + 40 + 20 + 20, 90, 20, $SS_CENTER)
		GUICtrlSetFont(-1, 9, 400, 0, "Georgia")
		$Left += 105
	Next

	GUISetState()

	While WinExists($GUI)
		$Msg = GUIGetMsg()
		Switch $Msg
			Case - 3
				GUIDelete($GUI)
		EndSwitch
	WEnd
	$Msg = 0
	Return 1
EndFunc   ;==>Extended_Forcast

Func HourByHour($Place = $Current)
	Local $Time[9], $Image[9], $Temperature[9], $Precipitation[9], $Temp[1]
	Local $Left, $Msg, $CityState, $CityStateA, $GetZIP, $GetZip2, $Zip, $GUI, $source

	$CityState = StringRegExpReplace($Place, "(?-i)[()1234567890]", "")
	$CityStateA = StringSplit($CityState, ",")
	If @error Then
		Return SetError(1, $Place, -1)
	Else
		$CityStateA[1] = StringReplace($CityStateA[1], " ", "+")
		$CityStateA[2] = StringReplace($CityStateA[2], " ", "")
		$GetZIP = _INetGetSource("http://zipcodes.addresses.com/results.php?ReportType=42&qc=" & $CityStateA[1] & "&qs=" & $CityStateA[2])
		$GetZip2 = _StringBetween($GetZIP, '<td class="F1">', '</td>')
		If @error Then
			Return SetError(2, $Place, -1)
		Else
			$Zip = $GetZip2[0]
		EndIf
	EndIf

	$GUI = GUICreate("8 Hour Forecast", 810, 90 + 50 + 10 + 28 + 10 + 25 + 10, -1, -1, BitOR($WS_POPUPWINDOW, $WS_CAPTION), -1, $Form1)
	GUISetBkColor(0xFFFFFF)
	$source = _INetGetSource("http://www.weather.com/weather/hourbyhour/graph/" & $ZipCode & "?from=dayDetails_topnav_undeclared")
	If @error Then Return -1

	$Left = 10
	For $x = 0 To 7
		$Temperary = _StringBetween($source, 'id="hbhWxHour' & $x & '">', '</div><!-- hbhWxHour -->')
		$Temp = _StringBetween($Temperary[0], '"hbhWxTime"><div>', '</div>')
		$Time[$x + 1] = $Temp[0]
		$Temp = _StringBetween($Temperary[0], '<img src=', ' alt=')
		$Temp = StringRegExp($Temp[0], "\d{1,2}.gif", 2)
		$Image[$x + 1] = $Temp[0]
		$Temp = _StringBetween($Temperary[0], '<div class="hbhWxTemp"><div>', '</div>')
		$Temperature[$x + 1] = StringReplace($Temp[0], "&deg; ", Chr(176))
		$Temp = _StringBetween($Temperary[0], '</span><br>', '</div>')
		$Precipitation[$x + 1] = $Temp[0]
		GUICtrlCreateLabel($Time[$x + 1], $Left, 10, 90, 25, $SS_CENTER)
		GUICtrlSetFont(-1, 17, 800, 0, "Georgia")
		GUICtrlCreatePic(@AppDataDir & "\WeatherTray\Pic" & $Image[$x + 1], $Left, 50, 90, 90)
		GUICtrlCreateLabel($Temperature[$x + 1], $Left, 90 + 50 + 10, 90, 28, $SS_CENTER)
		GUICtrlSetFont(-1, 17, 400, 0, "Georgia")
		GUICtrlCreateLabel("Precip: " & $Precipitation[$x + 1], $Left, 90 + 50 + 10 + 28 + 10, 90, 25, $SS_CENTER)
		GUICtrlSetFont(-1, 11, 500, 0, "Georgia")
		$Left += 100
	Next

	GUISetState()

	While WinExists($GUI)
		$Msg = GUIGetMsg()
		Switch $Msg
			Case - 3
				GUIDelete($GUI)
		EndSwitch
	WEnd
	Return 1
EndFunc   ;==>HourByHour

Func Settings()
	$Settings = GUICreate("Settings", 354, 176, -1, -1, -1, -1, $Form1)
	$Group1 = GUICtrlCreateGroup("Options", 15, 15, 321, 145, $BS_CENTER)
	GUICtrlCreateLabel("Refresh Rate:", 25, 40, 70, 17)
	$Refresh_Input = GUICtrlCreateInput($Refresh_Rate, 37, 62, 33, 21, BitOR($ES_RIGHT, $ES_NUMBER))
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateLabel("Home Location:", 197, 40, 79, 17)
	$Label1 = GUICtrlCreateLabel($Home, 202, 62, 120, 17)
	GUICtrlSetColor(-1, 0x0000FF)
	$Use_Current_Location = GUICtrlCreateButton("Use Current Location", 197, 80, 125, 18, 0)
	GUICtrlCreateLabel("Current Location:", 197, 112, 85, 17)
	GUICtrlCreateLabel($Current, 202, 134, 120, 17)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("minute(s)", 76, 64, 46, 17)
	GUICtrlCreateLabel("Extended Forecast: ", 25, 95, 99, Default, $SS_CENTER)
	$Days_Input = GUICtrlCreateInput($Days, 124, 91, 15, 20, BitOR($ES_NUMBER, $SS_CENTER))
	GUICtrlCreateLabel("day(s)", 140, 95, 30, Default, $SS_CENTER)
	$OK = GUICtrlCreateButton("&OK", 50, 125, 75, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_DISABLE, $Form1)
	_WinAnimate($Settings, Random(1, 9, 1), 0, 40, 0)
	While WinExists($Settings)
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($Settings)
			Case $OK
				Global $Refresh_Rate = GUICtrlRead($Refresh_Input)
				Global $Days = GUICtrlRead($Days_Input)
				GUIDelete($Settings)
			Case $Use_Current_Location
				GUICtrlSetData($Label1, $Current)
				Global $Home = $Current
		EndSwitch
		Sleep(25)
	WEnd
	GUISetState(@SW_ENABLE, $Form1)
	WinActivate($Form1)
EndFunc   ;==>Settings

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
					If _GUICtrlEdit_GetTextLen($Input) = 0 Then
						GUICtrlSetData($Input, $Home)
						GUICtrlSetColor($Input, 0x808080)
					EndIf
				Case $EN_SETFOCUS
					If GUICtrlRead($Input) = $Home Then
						GUICtrlSetData($Input, "")
						GUICtrlSetColor($Input, 0x000000)
					EndIf
				Case $EN_CHANGE
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func _ReduceMemory($i_PID = -1);w0uter created this ABSOLUTELY AMAZING bit of code.  Put into every script you write!
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory
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

Func _StringBetween($sString, $sStart, $sEnd, $vCase = -1, $iSRE = -1)
	If $iSRE = -1 Or $iSRE = Default Then
		If $vCase = -1 Or $vCase = Default Then
			$vCase = 0
		Else
			$vCase = 1
		EndIf
		Local $sHold = '', $sSnSStart = '', $sSnSEnd = ''
		While StringLen($sString) > 0
			$sSnSStart = StringInStr($sString, $sStart, $vCase)
			If Not $sSnSStart Then ExitLoop
			$sString = StringTrimLeft($sString, ($sSnSStart + StringLen($sStart)) - 1)
			$sSnSEnd = StringInStr($sString, $sEnd, $vCase)
			If Not $sSnSEnd Then ExitLoop
			$sHold &= StringLeft($sString, $sSnSEnd - 1) & Chr(1)
			$sString = StringTrimLeft($sString, $sSnSEnd)
		WEnd
		If Not $sHold Then Return SetError(1, 0, 0)
		$sHold = StringSplit(StringTrimRight($sHold, 1), Chr(1))
		Local $avArray[UBound($sHold) - 1]
		For $iCC = 1 To UBound($sHold) - 1
			$avArray[$iCC - 1] = $sHold[$iCC]
		Next
		Return $avArray
	Else
		If $vCase = Default Or $vCase = -1 Then
			$vCase = '(?i)'
		Else
			$vCase = ''
		EndIf
		Local $aArray = StringRegExp($sString, '(?s)' & $vCase & $sStart & '(.*?)' & $sEnd, 3)
		If IsArray($aArray) Then Return $aArray
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_StringBetween

Func _WinAPI_HiWord($iLong)
	Return BitShift($iLong, 16)
EndFunc   ;==>_WinAPI_HiWord

Func _WinAPI_LoWord($iLong)
	Return BitAND($iLong, 0xFFFF)
EndFunc   ;==>_WinAPI_LoWord
#EndRegion Included Functions