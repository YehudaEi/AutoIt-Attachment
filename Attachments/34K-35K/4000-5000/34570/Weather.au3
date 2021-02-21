#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include "data\marquee.au3"
#include <ie.au3>

Global $hGUI, _
	   $hLocation, _
	   $hCurrPic, _
	   $hCurrTemp, _
	   $hCurrWeather, _
	   $hCurrHumidity, _
	   $hCurrWind, _
	   $hExit, _
	   $hRefresh, _
	   $hExit, _
	   $hConfig, _
	   $hStartup, _
	   $hSLocation, _
	   $hSLanguage, _
	   $hSCelFor, _
	   $hSFerFor, _
	   $hFIndLocStart, _
       $sPageCode, _
	   $sStartUrl, _
	   $sLoc

Global $sINI = @ScriptDir & "\data\options.ini"
GLobal $aINI = _LoadINI()

If $aINI[4] = 1 Then
	$sLoc = _GetLocation ()
	IniWrite($sINI, "Config", "Location", $sLoc)
	$sUrlLoc = StringReplace ($sLoc, " ", "+")
Else
	$sLoc = $aINI[1]
	$sUrlLoc = StringReplace ($sLoc, " ", "+")
EndIf

Global $sPageCode = _RefreshPage()
Global $aCurrent = _GetCurrent($sPageCode)
Global $aForecast = _GetForecast($sPageCode)

_Weather($sLoc)
_RefreshData ()

While 1
	Sleep (100)
	Global $Msg = GUIGetMsg()
	Switch $Msg
		Case $hExit
			_Exit()
		Case $hLocation
			_Config()
		Case $hRefresh
			_RefreshPage()
			_RefreshData()
	EndSwitch
WEnd

Func _Weather($sLoc)
	Local $iW = 315, $iH = 166
	Local $iX, $iY
	$iX = @DesktopWidth - $iW - 1
	$iY = @DesktopHeight - $iH - 29
	$hGUI = GUICreate("Weather", $iW, $iH, $iX, $iY, BitOR($WS_SYSMENU, $WS_POPUP, $WS_BORDER), $WS_EX_TOOLWINDOW)
	_RoundCorners($hGUI, 0.6)
	GUISetBkColor(0x000000)
	GUICtrlSetDefBkColor($GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetDefColor(0xefefef)
	$hLocation = GUICtrlCreateLabel($sLoc, 40, 5, $iW - 115, 28)
	GUICtrlSetFont(-1, 12, 400, 0, "Arial", 5)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Click to Change Options")
	$hCurrPic = GUICtrlCreatePic("", 5, 5, 30, 30)
	$hCurrTemp = GUICtrlCreateLabel("", $iW - 100, 5, 95, 25, $SS_RIGHT)
	GUICtrlSetFont(-1, 14, 400, 0, "Arial", 5)
	$hCurrWeather = GUICtrlCreateLabel("", 50, 30, $iW - 55, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial", 5)
	$hCurrHumidity = GUICtrlCreateLabel("", $iW - 105, 47, 100, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial", 5)
	$hCurrWind = GUICtrlCreateLabel("", $iW / 2 - 5, 64, $iW / 2, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 10, 400, 0, "Arial", 5)
	For $i = 0 To 3
	$aForecast[$i][0] = GUICtrlCreateLabel("", 5 + 80 * $i, 85, 65, 17)
	$aForecast[$i][1] = GUICtrlCreateLabel("" & ChrW(176), 5 + 80 * $i, 102, 25, 17)
	$aForecast[$i][2] = GUICtrlCreateLabel("" & ChrW(176), 5 + 80 * $i, 119, 25, 17)
	$aForecast[$i][3] = GUICtrlCreatePic("", 30 + 80 * $i, 102, 40, 30)
	Next
	For $i = 0 To 2
	GUICtrlCreateLabel("", 75 + 80 * $i, 88, 1, 47)
	GUICtrlSetBkColor(-1, 0x808080)
	Next
	GUICtrlCreateLabel("", 5, 140, $iW - 10, 1)
	GUICtrlSetBkColor(-1, 0x808080)

	GUICtrlCreateLabel("Weather 2011 - v" & FileGetVersion(@ScriptName) & " beta", 5, $iH - 20, $iW - 50, 17)
	$hExit = GUICtrlCreateIcon("shell32.dll", -132, $iW - 22, $iH - 22, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Exit")
	$hRefresh = GUICtrlCreateIcon("shell32.dll", -147, $iW - 42, $iH - 22, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Refresh")
	GUICtrlCreatePic("", 0, 0, $iW, $iH, BitOR($GUI_SS_DEFAULT_PIC, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
	WinSetTrans($hGUI, "", 0)
	GUISetState()
	For $i = 0 To 220 Step 10
	WinSetTrans($hGUI, "", $i)
	Sleep(10)
	Next
EndFunc   ;==>_Weather

Func _RefreshData()
	$aINI = _LoadINI()
	Local $aCurrent[11], $aFore[4][4]
	$sPageCode = _RefreshPage ()
	$aCurrent = _GetCurrent ($sPageCode)
	If Not IsArray($aCurrent) Then
		Return
	Else
		GUICtrlSetData($hLocation, $sLoc)
		GUICtrlSetImage($hCurrPic, @ScriptDir & "\data\current.gif")
		If $aINI[3] = "F" Then
			GUICtrlSetData($hCurrTemp, $aCurrent[1] & " °F")
		Else
			GUICtrlSetData($hCurrTemp, $aCurrent[2] & " °C")
		EndIf
		GUICtrlSetData($hCurrWeather, $aCurrent[0])
		GUICtrlSetData($hCurrHumidity, $aCurrent[3])
		GUICtrlSetData($hCurrWind, $aCurrent[5])
		$aFore = _GetForecast($sPageCode)
		For $i = 0 To 3
			GUICtrlSetData($aForecast[$i][0], $aFore[$i][0])
			If $aINI[3] = "F" Then
				GUICtrlSetData($aForecast[$i][1], $aFore[$i][2])
				GUICtrlSetData($aForecast[$i][2], $aFore[$i][1])
			Else
				GUICtrlSetData($aForecast[$i][1], Round((($aFore[$i][2]-32)*5)/9, 0))
				GUICtrlSetData($aForecast[$i][2], Round((($aFore[$i][1]-32)*5)/9, 0))
			EndIf
			GUICtrlSetImage($aForecast[$i][3], @ScriptDir & "\data\day" & $i & ".gif")
			GUICtrlSetTip($aForecast[$i][3], $aFore[$i][4])
		Next
	EndIf
EndFunc   ;==>_Refresh

Func _RefreshPage()
    Local $s_PageCode
	$aINI = _LoadINI ()
	$sUrlLoc = StringReplace($aINI[1], " ", "+")
	$sLoc = $aINI[1]
	$sURL = "http://www.google.com/ig/api?weather=" & $sUrlLoc & "&hl=" & $aINI[2]
	$s_PageCode = BinaryToString(InetRead ($sURL))
    Return ($s_PageCode)
EndFunc

#cs
    ; _GetCurrent() ; Pass it the String from the page code. Use _RefreshPage() to get that.
    ; Array Elements
    ; [0] = Condition Data
    ; [1] = Temp F
    ; [2] = Temp C
    ; [3] = Humidity
    ; [4] = Image
    ; [5] = Wind
#ce
Func _GetCurrent($s_String)
    Local $a_Cur_Cond = StringRegExp(StringRegExpReplace($s_String, "(?i).+<current_conditions>(.+)</current_conditions>.+", "$1"), "(?i)data=\x22(.+?)\x22/>", 3)
    If @Error Then Return SetError(1)
	InetGet ("http://www.google.com/" & $a_Cur_Cond[4], @ScriptDir & "\data\current.gif")
    Return($a_Cur_Cond)
EndFunc

#cs
    ; _GetForecast() ; Pass it the String from the page code. Use _RefreshPage() to get that.
    ; Array Elements
    ; [n][0] = Weekday
    ; [n][1] = Lo Temp
    ; [n][2] = Hi Temp
    ; [n][3] = Image
    ; [n][4] = Conditions
#ce
Func _GetForecast($s_String)
    Local $a_Fcast_Cond = StringRegExp(StringRegExpReplace($s_String, "(?i).+?(<forecast_conditions>.+</forecast_conditions>).+", "$1"), "(?i)<forecast_conditions>(.+?)</forecast_conditions>", 3)

	Local $aHold
    Dim $aRtn[UBound($a_Fcast_Cond)][5]
    For $i = 0 To UBound($a_Fcast_Cond) -1
        $aHold = StringRegExp($a_Fcast_Cond[$i], "(?i)data=\x22(.+?)\x22/>", 3)
        $aHold[3] = StringRegExpReplace($aHold[3], "^.+/(.+)$", "$1");; You can remove this if you want to use InetGet() to download the image.
		InetGet ("http://www.google.com/ig/images/weather/" & $aHold[3], @ScriptDir & "\data\day" & $i & ".gif")
        For $j = 0 To UBound($aHold) -1
        $aRtn[$i][$j] = $aHold[$j]
        Next
    Next
    Return($aRtn)
EndFunc

Func _RoundCorners($hWnd, $iR = 1)
	Local $x, $pos
	$pos = WinGetPos($hWnd)
	If $pos[2] > $pos[3] Then
	 $x = 10 * $pos[2] / $pos[3]
	Else
	 $x = 10 * $pos[3] / $pos[2]
	EndIf
	Local $aResult = DllCall("gdi32.dll", "handle", "CreateRoundRectRgn", "int", 0, "int", 0, "int", $pos[2], "int", $pos[3], _
	  "int", $iR * $x, "int", $iR * $x)
	Local $aRet = DllCall("user32.dll", "int", "SetWindowRgn", "hwnd", $hWnd, "handle", $aResult[0], "bool", True)
	If @error Then Return SetError(@error, @extended, False)
	Return $aRet[0]
EndFunc   ;==>_RoundCorners

Func _LoadINI()
	Local $aRet[5]
	If Not FileExists($sINI) Then
		Local $ft = FileOpen($sINI, 2)
		Local $sText = "[Config]" & @CRLF
		$sText &= "StartWithWindows=4" & @CRLF
		$sText &= "Location=" & $sLoc & @CRLF
		$sText &= "Language=EN" & @CRLF
		$sText &= "FindLocationOnStart=1" & @CRLF
		$sText &= "TempDisp=F" & @CRLF
		FileWrite($ft, $sText)
		FileClose($ft)
	EndIf
	$aRet[0] = IniRead($sINI, "Config", "StartWithWindows", "4")
	$aRet[1] = IniRead($sINI, "Config", "Location", $sLoc)
	$aRet[2] = IniRead($sINI, "Config", "Language", "en")
	$aRet[3] = IniRead($sINI, "Config", "TempDisp", "F")
	$aRet[4] = IniRead($sINI, "Config", "FindLocationOnStart", "1")
	Return $aRet
EndFunc   ;==>_LoadINI

Func _Exit()
	For $i = 0 To 220 Step 10
		WinSetTrans($hGUI, "", 220 - $i)
		Sleep(10)
	Next
	GUIDelete($hGUI)
	Exit
EndFunc   ;==>_Exit

Func _GetLocation ()
	$fLoading = GUICreate("Loading", 205, 50, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP, $WS_BORDER), $WS_EX_TOOLWINDOW)
	GUISetBkColor(0x111111)
	GUICtrlCreateLabel("Loading Weather", 50, 6, 100, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0xfefefe)
	GUICtrlSetBkColor(-1, 0x202020)
	_RoundCorners($fLoading, 0.6)
	GUICtrlSetDefBkColor(0x111111)
	GUICtrlSetDefColor(0xefefef)
	$ID1 = _GUICtrlProgressMarqueeCreate(2,23, 200, 20)
	_GUICtrlProgressSetMarquee($ID1)
	GUISetState (@SW_SHOW, $fLoading)

	InetGet ("http://www.ipaddresslocation.org/", @ScriptDir & "\Data\location.html")

	$oIE = _IECreate ("http://www.ipaddresslocation.org/", 1, 0)
	$sRead = _IEBodyReadText ($oIE)
	_IEQuit ($oIE)
	$iLoc = StringInStr ($sRead, "My IP Location (Guessed City)")
	$sTrim = StringTrimLeft ($sRead, $iLoc-1)
	$aSplit = StringSplit ($sTrim, @CRLF)

	$sLocation = $aSplit[3]
	GUISetState (@SW_HIDE, $fLoading)
	Return $sLocation
EndFunc

Func _Config()
	GUISetState(@SW_DISABLE, $hGUI)
	Local $hBack
	Local $iX, $iY, $aPos, $iW = 218, $iH = 150, $nMsg
	DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
	$aPos = WinGetPos ($hGUI)
	$iX = $aPos[0]
	$iY = $aPos[1]
	$hConfig = GUICreate("Weather Gadget", $iW, $iH, $iX - $iW, $iY, BitOR($WS_SYSMENU, $WS_POPUP), $WS_EX_TOPMOST)
	GUISetBkColor(0x111111)
	GUICtrlCreateLabel("Configuration", 8, 6, $iW - 32, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0xfefefe)
	GUICtrlSetBkColor(-1, 0x202020)
	$hBack = GUICtrlCreateIcon("shell32.dll", -132, $iW - 22, 6, 16, 16, BitOR($SS_NOTIFY, $WS_GROUP))
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Save, Close and Refresh")
	_RoundCorners($hConfig, 0.6)
	GUICtrlSetDefBkColor(0x111111)
	GUICtrlSetDefColor(0xefefef)
	GUICtrlCreateLabel("Search location:", 8, 34, 100, 17)
	$hSLocation = GUICtrlCreateInput($aINI[1], 108, 32, 100, 18, -1, $WS_EX_STATICEDGE)
	GUICtrlCreateLabel("Weather language:", 8, 56, 100, 17)
	$hSLanguage = GUICtrlCreateInput($aINI[2], 108, 54, 100, 18, $ES_UPPERCASE, $WS_EX_STATICEDGE)
	GUICtrlSetTip(-1, "en - English," & @CRLF & "ro - Romanian" & @CRLF & "fr - French,  etc.")

	GUICtrlCreateLabel("°C / °F:", 8, 78, 100, 17)
	$hSCelFor = GUICtrlCreateRadio("°C", 108, 76, 40, 18, -1, $WS_EX_STATICEDGE)
	$hSFerFor = GUICtrlCreateRadio("°F", 149, 76, 40, 18, -1, $WS_EX_STATICEDGE)
	If $aINI[3] = "F" Then
		GUICtrlSetState (-1, $GUI_CHECKED)
	Else
		GUICtrlSetState ($hSCelFor, $GUI_CHECKED)
	EndIf
	$hFIndLocStart = GUICtrlCreateCheckbox("Find Location on Startup", 8, $iH - 44, $iW - 16, 17, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_MULTILINE, $WS_TABSTOP))
	GUICtrlSetState($hFIndLocStart, IniRead($sINI, "Config", "FindLocationOnStart", "1"))

	$hStartup = GUICtrlCreateCheckbox("Start with Windows", 8, $iH - 24, $iW - 16, 17, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_MULTILINE, $WS_TABSTOP))
	GUICtrlSetState($hStartup, IniRead($sINI, "Config", "StartWithWindows", "4"))

	GUICtrlCreatePic("", 0, 0, $iW, $iH, BitOR($GUI_SS_DEFAULT_PIC, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
	WinSetTrans($hConfig, "", 220)
	GUISetState()
	While 1
		Sleep(10)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $hBack
				_WriteConfig()
				_ChangeGui()
				_RefreshPage()
				_RefreshData()
				Return
			Case $hStartup
				IniWrite($sINI, "Config", "StartWithWindows", GUICtrlRead($hStartup))
				_CheckStartup()
		EndSwitch
	WEnd
EndFunc   ;==>_Config

Func _WriteConfig()
	IniWrite($sINI, "Config", "StartWithWindows", GUICtrlRead($hStartup))
	If GUICtrlRead($hSLocation) <> "" Then IniWrite($sINI, "Config", "Location", GUICtrlRead($hSLocation))
	If GUICtrlRead($hSLanguage) <> "" Then IniWrite($sINI, "Config", "Language", GUICtrlRead($hSLanguage))
	If GUICtrlRead ($hSCelFor) = $GUI_CHECKED Then IniWrite($sINI, "Config", "TempDisp", "C")
	If GUICtrlRead ($hSFerFor) = $GUI_CHECKED Then IniWrite($sINI, "Config", "TempDisp", "F")
	IniWrite($sINI, "Config", "FindLocationOnStart", GUICtrlRead($hFIndLocStart))
EndFunc   ;==>_WriteConfig

Func _ChangeGui()
	GUISetState(@SW_ENABLE, $hGUI)
	GUIDelete($hConfig)
EndFunc   ;==>_ChangeGui

Func _CheckStartup()
	$aINI = _LoadINI()
	If $aINI[0] = 1 Then
		RegWrite ("HKLU\Software\Microsoft\Windows\CurrentVersion\Run", "WeatherApp", "REG_SZ", @ScriptFullPath)
	Else
		RegDelete ("HKLU\Software\Microsoft\Windows\CurrentVersion\Run", "WeatherApp")
	EndIf
EndFunc   ;==>_CheckStartup