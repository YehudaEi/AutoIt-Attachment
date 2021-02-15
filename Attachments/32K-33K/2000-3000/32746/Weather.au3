#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $Gui2, $Error

Opt("GUIOnEventMode", 1)

DirCreate(@TempDir & "\Weather")
InetGet("http://i.imwx.com/images/maps/current/acttemp_600x405.jpg", @TempDir & "\Weather\Temp.jpg", 1, 0)
InetGet("http://image.weather.com/images/maps/current/curwx_600x405.jpg", @TempDir & "\Weather\Current.jpg", 1, 0)
InetGet("http://image.weather.com/web/radar/us_radar_plus_usen.jpg", @TempDir & "\Weather\Doppler.jpg", 1, 0)
InetGet("http://image.weather.com/web/forecast/us_wxhi1_large_usen_600.jpg", @TempDir & "\Weather\Forecast.jpg", 1, 0)
InetGet("http://image.weather.com/images/sat/ussat_600x405.jpg", @TempDir & "\Weather\Infrared.jpg", 1, 0)
InetGet("http://i.imwx.com/images/maps/special/severe_us_600x405.jpg", @TempDir & "\Weather\Severe.jpg", 1, 0)
$TempImage = @TempDir & "\Weather\Temp.jpg"
$CurrentWeatherImage = @TempDir & "\Weather\Current.jpg"
$DopplerImage = @TempDir & "\Weather\Doppler.jpg"
$ForecastImage = @TempDir & "\Weather\Forecast.jpg"
$InfraredImage = @TempDir & "\Weather\Infrared.jpg"
$SevereImage = @TempDir & "\Weather\Severe.jpg"

$Gui = GuiCreate("Weather.com", 600,520,Default, Default,$WS_SIZEBOX + $WS_SYSMENU)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
$OptionsMenu = GuiCtrlCreateMenu("Options")
$CurrentWeather = GuiCtrlCreateMenuItem("Current Surface", $OptionsMenu)
GUICtrlSetOnEvent($CurrentWeather, "CurrentSurfaceImage")
$CurrentTemp = GuiCtrlCreateMenuItem("Current Temperatures", $OptionsMenu)
GUICtrlSetOnEvent($CurrentTemp, "CurrentTempImage")
$DopplerRadar = GuiCtrlCreateMenuItem("Doppler Radar", $OptionsMenu)
GUICtrlSetOnEvent($DopplerRadar, "DopplerRadarImage")
$Forecast = GuiCtrlCreateMenuItem("US Forecast", $OptionsMenu)
GUICtrlSetOnEvent($Forecast, "ForecastImage")
$Infrared = GuiCtrlCreateMenuItem("Infrared Satellite", $OptionsMenu)
GUICtrlSetOnEvent($Infrared, "InfraredImage")
$Severe = GuiCtrlCreateMenuItem("Severe Weather Alerts", $OptionsMenu)
GUICtrlSetOnEvent($Severe, "SevereImage")
$MainImage = GUICtrlCreatePic($CurrentWeatherImage, 0, 0, 600, 400)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$OverViewForecast = GuiCtrlCreateButton("Overview Forecast", 0,400)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKWIDTH)
GUICtrlSetOnEvent($OverViewForeCast, "OverView")
$HourlyForecast = GuiCtrlCreateButton("Hourly Forecast", 130,400)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKWIDTH)
GUICtrlSetOnEvent($HourlyForecast, "Hourly")
$TomorrowsForecast = GuiCtrlCreateButton("Tommorrow's Forecast", 245, 400)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKWIDTH)
GUICtrlSetOnEvent($TomorrowsForecast, "Tomorrow")
$WeekendForecast = GuiCtrlCreateButton("Weekend Forecast", 390, 400)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKWIDTH)
GUICtrlSetOnEvent($WeekendForecast, "Weekend")
$5DayForecast = GuiCtrlCreateButton("5-Day Forecast", 515, 400)
GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKWIDTH)
GUICtrlSetOnEvent($5DayForecast, "FiveDay")
$ZipCode = GuiCtrlCreateEdit("Enter your zip code here", 230, 440, 140,20)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
GuiSetState(@SW_SHOW)

While 1
	Switch GuiGetMsg()        
	Case -3
			Exit
		Case $GUI_EVENT_RESIZED
		$aPos = WinGetClientSize($Gui)
		ControlMove($Gui, "", $CurrentWeatherImage, 10, 10, $aPos[0], $aPos[1])
	EndSwitch
	WEnd

Func OverView()
	$ZipCodeToUse = GuiCtrlRead($ZipCode)
	If $ZipCodeToUse = "Enter your zip code here" Then
		MsgBox(48, "Error", "Please type in your zip code")
		$Error = 1
	EndIf
	If $Error = 0 Then
	$PanTask = _IECreateEmbedded()
	$Gui2 = GUICreate("Overview Forecast", 620, 430)
	$PanGUI = GUICtrlCreateObj($PanTask,-40,-500,1024,1024)
	$CreateWindow = _IENavigate ($PanTask, "	http://www.weather.com/weather/today/" & $ZipCodeToUse, 0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	GUISetState(@SW_SHOW)
ElseIf $Error > 0 Then
	$Error = 0
	EndIf
	EndFunc

Func Hourly()
		$ZipCodeToUse = GuiCtrlRead($ZipCode)
	If $ZipCodeToUse = "Enter your zip code here" Then
		MsgBox(48, "Error", "Please type in your zip code")
		$Error = 1
	EndIf
	If $Error = 0 Then
	$PanTask = _IECreateEmbedded()
	$Gui2 = GUICreate("Hourly Forecast", 600, 430)
	$PanGUI = GUICtrlCreateObj($PanTask,-40,-600,1024,1024)
	$CreateWindow = _IENavigate ($PanTask, "http://www.weather.com/outlook/health/allergies/hourbyhour/graph/" & $ZipCodeToUse, 0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	GUISetState(@SW_SHOW)
ElseIf $Error > 0 Then
	$Error = 0
	EndIf
EndFunc

Func Tomorrow()
	$ZipCodeToUse = GuiCtrlRead($ZipCode)
	If $ZipCodeToUse = "Enter your zip code here" Then
		MsgBox(48, "Error", "Please type in your zip code")
		$Error = 1
	EndIf
	If $Error = 0 Then
	$PanTask = _IECreateEmbedded()
	$Gui2 = GUICreate("Tomorrow's Forecast", 450, 440)
	$PanGUI = GUICtrlCreateObj($PanTask,-120,-570,1024,1024)
	$CreateWindow = _IENavigate ($PanTask, "http://www.weather.com/outlook/health/allergies/wxdetail/" & $ZipCodeToUse & "?dayNum=1", 0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	GUISetState(@SW_SHOW)
ElseIf $Error > 0 Then
	$Error = 0
	EndIf
EndFunc

Func Weekend()
	$ZipCodeToUse = GuiCtrlRead($ZipCode)
	If $ZipCodeToUse = "Enter your zip code here" Then
		MsgBox(48, "Error", "Please type in your zip code")
		$Error = 1
	EndIf
	If $Error = 0 Then
	$PanTask = _IECreateEmbedded()
	$Gui2 = GUICreate("Weekend Forecast", 450, 240)
	$PanGUI = GUICtrlCreateObj($PanTask,-125,-497,1024,1024)
	$CreateWindow = _IENavigate ($PanTask, "http://www.weather.com/outlook/health/allergies/weekend/" & $ZipCodeToUse, 0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	GUISetState(@SW_SHOW)
ElseIf $Error > 0 Then
	$Error = 0
	EndIf
EndFunc

Func FiveDay()
	$ZipCodeToUse = GuiCtrlRead($ZipCode)
	If $ZipCodeToUse = "Enter your zip code here" Then
		MsgBox(48, "Error", "Please type in your zip code")
		$Error = 1
	EndIf
	If $Error = 0 Then
	$PanTask = _IECreateEmbedded()
	$Gui2 = GUICreate("5-Day Forecast", 600, 330)
	$PanGUI = GUICtrlCreateObj($PanTask,-40,-510,1024,1024)
	$CreateWindow = _IENavigate ($PanTask, "http://www.weather.com/weather/5-day/" & $ZipCodeToUse, 0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
	GUISetState(@SW_SHOW)
ElseIf $Error > 0 Then
	$Error = 0
	EndIf
EndFunc

Func CurrentSurfaceImage()
	GUICtrlSetImage($MainImage, $CurrentWeatherImage, 22)
	EndFunc

Func CurrentTempImage()
	GUICtrlSetImage($MainImage, $TempImage, 22)
EndFunc

Func DopplerRadarImage()
	GUICtrlSetImage($MainImage, $DopplerImage, 22)
EndFunc

Func ForecastImage()
	GUICtrlSetImage($MainImage, $ForecastImage, 22)
EndFunc

Func InfraredImage()
	GUICtrlSetImage($MainImage, $InfraredImage, 22)
EndFunc

Func SevereImage()
	GUICtrlSetImage($MainImage, $SevereImage, 22)
	EndFunc

While 1
Sleep(100)
	WEnd
	
Func CLOSEClicked()
	  If @GUI_WINHANDLE = $Gui Then
    Exit
	EndIf
If @GUI_WINHANDLE = $Gui2 Then
	GuiDelete($Gui2)
  EndIf 
EndFunc