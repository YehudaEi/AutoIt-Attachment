#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1
	Author:         Foxhound

	Script Function:
	Get instant weather data using Google's Weather API query string.
	You're free to copy and modify this code as much as you like.

	Changelog

	v.0.1
	-Project Started


#ce ----------------------------------------------------------------------------
#NoTrayIcon
#include <IE.au3>
#include <String.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Global $oIE, $wData[5]
#region------GUI
$Form1 = GUICreate("GetWeather - By Foxhound", 282, 192)
	$tempLabel = GUICtrlCreateLabel("", 160, 32, 112, 115)
	GUICtrlSetFont(-1, 75, 400, 0, "Arial")
	$cityLabel = GUICtrlCreateLabel("", 8, 40, 141, 28)
	GUICtrlSetFont(-1, 15, 400, 0, "Arial")
	$windLabel = GUICtrlCreateLabel("", 8, 64, 140, 24)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial")
	$Pic1 = GUICtrlCreatePic("", 72, 88, 40, 40)
	$Group1 = GUICtrlCreateGroup("Current Conditions", 4, 8, 273, 161)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
	$Input1 = GUICtrlCreateInput("", 24, 144, 105, 21)
	$Button1 = GUICtrlCreateButton("Search", 131, 141, 75, 25, $WS_GROUP)
#EndRegion------------
$oIE = _IECreate("about:blank", 0, 0, 1, 0)
OnAutoItExitRegister("cleanExit")
_gui()
Func _getData($location)
	Local $queryURL = "http://www.google.com/ig/api?weather=" & $location
	_IENavigate($oIE, $queryURL)
	$xmlData = _IEBodyReadText($oIE)
	$city = _StringBetween($xmlData, '<city data="', "/>")
	$tempData = _StringBetween($xmlData, 'temp_f data="', "/>")
	$windData = _StringBetween($xmlData, '<wind_condition data="', "/>")
	$iconData1 = _StringBetween($xmlData, 'temp_c data="', '<wind_condition')
		If Not IsArray($iconData1) Then
		MsgBox(0, "", "Error", _gui())
	EndIf
	$iconData2 = _StringBetween($iconData1[0], '<icon data="', "/>")

	;-------- Proper Format------------
	$city[0] = StringTrimRight($city[0], 2)
	$wData[0] = $city[0] ; City
	$tempData[0] = StringTrimRight($tempData[0], 2)
	$wData[1] = $tempData[0] ;Temp
	$windData[0] = StringTrimRight($windData[0], 2)
	$wData[2] = $windData[0] ;Wind
	$iconData2[0] = StringTrimRight($iconData2[0], 2)
	$wData[3] = $iconData2[0] ;Icon
	;MsgBox(0,"",$wData[3])

	If IsArray($wData) Then
		Return ($wData)
	Else
		Return (1)
	EndIf
EndFunc   ;==>_getData

Func cleanExit()
	FileDelete(@TempDir & "\tempWDatagif.gif")
	_IEQuit($oIE)
EndFunc   ;==>cleanExit
Func _gui()
			_GUICtrlStatusBar_SetText($StatusBar1, "Enter your ZIP/CITY to get weather data.")
	GUISetState(@SW_SHOW,$Form1)
	While 1
		$msg = GUIGetMsg()
		If $msg == $GUI_EVENT_CLOSE Then Exit
		If $msg == $Button1 Then
			FileDelete(@TempDir & "\tempWDatagif.gif")
			$tData = GUICtrlRead($Input1)
			If StringLen($tData) == 0 Then
				MsgBox(0, "", "Please enter a valid Zip code or city name")
				$tData = ""
			EndIf
			$weather = _getData($tData)
			_GUICtrlStatusBar_SetText($StatusBar1, "Getting weather data...")
			If $weather == 1 Then
				MsgBox(0, "", "An error has occured")
				Exit
			EndIf
			;0city, 1temp,2wind,3icon url
			GUICtrlSetData($cityLabel, $weather[0])
			GUICtrlSetData($tempLabel, $weather[1])
			GUICtrlSetData($windLabel, $weather[2])

			$imgurl = "http://www.google.com" & $weather[3]
			$imgurl = StringStripWS($imgurl, 8)
			;MsgBox(0,"weather 3",$imgurl)
			InetGet($imgurl, @TempDir & "\tempWDatagif.gif")
			GUICtrlSetImage($Pic1, @TempDir & "\tempWDatagif.gif")
			_GUICtrlStatusBar_SetText($StatusBar1, "Done.")

		EndIf

	WEnd
EndFunc   ;==>_gui