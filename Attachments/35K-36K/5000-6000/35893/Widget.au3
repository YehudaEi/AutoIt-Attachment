#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#Include <WinAPI.au3>
#include "WeatherUDF.au3"

Opt("GUIOnEventMode", 1)

Global $ZipCode, $GUI, $hgraphic, $himage, $RightNowGui, $TodayGui, $TonightGui, $TomorrowGui

$ZipCode = InputBox("Zip code", "Please input your zip code")
$ZipCode2 = "http://www.zip-codes.com/zip-code/" & $ZipCode

Global $sSource = BinaryToString(InetRead($ZipCode2))
$City = StringRegExp($sSource,'(?i)(?s)<tr valign="top"><td id="rowB"><a href="/zip_database_fields.asp#city" class="rowL" target="_blank">City:</a></td><td id="rowB"><a href="(.*?)">(.*?)</a>',1)
$State = StringRegExp($sSource,'(?i)(?s)<tr valign="top"><td id="rowA"><a href="/zip_database_fields.asp#statecode" class="rowL" target="_blank">State:</a></td><td id="rowA"><a href="(.*?)">(.*?)</a>',1)
$Url = 'http://www.weather.com/weather/today/' & $City[1] & '+' & $State[1] & '+' & $Zipcode

Global $h_Desktop_SysListView32
_GetDesktopHandle()

$Width = @DesktopWidth
$Height = @DesktopHeight
	_GetOverViewTimes()
    _GetOverViewTemperature()
    _GetOverViewImages()
    _GetOverViewStatus()

_RightNowGUI()
Func _RightNowGUI()
    GuiDelete($RightNowGUI)
    GuiDelete($TodayGUI)
    GuiDelete($TonightGUI)
    GuiDelete($TomorrowGUI)
    $RightNowGUI = GUICreate("", 150, 300, $Width-151, $Height-600, BitOR($WS_POPUP,$WS_BORDER), Default, WinGetHandle(AutoItWinGetTitle()))
    GuiSetFont(13)
    GUICtrlSetDefColor(0xFFFFFF)
    GUISetBkColor(0x000000)
    WinSetTrans($RightNowGUI,"",200)
    GuiSetState()
    GuiCtrlCreateLabel($OverViewTime[1],38,10,200,50)
    GuiCtrlCreateLabel($OverViewStatus[1],48,190,200,40)
    GuiCtrlCreateLabel("Temperature",38,230,200,40)
    GuiCtrlCreateLabel($OverViewTemp[1] & "°F",64,250,200,40)
    $ContextMenu = GuiCtrlCreateContextMenu()
    $RightNowItem = GuiCtrlCreateMenuItem($OverViewTime[1], $ContextMenu)
    GUICtrlSetOnEvent($RightNowItem, "_RightNowGUI")
    $TodayItem = GuiCtrlCreateMenuItem($OverViewTime[2], $ContextMenu)
    GUICtrlSetOnEvent($TodayItem, "_TodayGUI")
    $TonightItem = GuiCtrlCreateMenuItem($OverViewTime[3], $ContextMenu)
    GUICtrlSetOnEvent($TonightItem, "_TonightGUI")
    $TomorrowItem = GuiCtrlCreateMenuItem($OverViewTime[4], $ContextMenu)
    GUICtrlSetOnEvent($TomorrowItem, "_TomorrowGUI")
    $RefreshItem = GuiCtrlCreateMenuItem("Refresh", $ContextMenu)
    GUICtrlSetOnEvent($RefreshItem, "_Refresh")
    $ExitItem = GuiCtrlCreateMenuItem("Close", $ContextMenu)
    GUICtrlSetOnEvent($ExitItem, "_Exit")
    DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $RightNowGUI, "hwnd", $h_Desktop_SysListView32)

    _GDIPlus_StartUp()
    $hImage   = _GDIPlus_ImageLoadFromFile(@ScriptDir & "/Images/Image1.png")
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($RightNowGUI)
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage, 13, 35, 130,160)
EndFunc

Func _TodayGUI()
    GuiDelete($RightNowGUI)
    GuiDelete($TodayGUI)
    GuiDelete($TonightGUI)
    GuiDelete($TomorrowGUI)
    $TodayGUI = GUICreate("", 150, 300, $Width-151, $Height-600, BitOR($WS_POPUP,$WS_BORDER), Default, WinGetHandle(AutoItWinGetTitle()))
    GuiSetFont(13)
    GUICtrlSetDefColor(0xFFFFFF)
    GUISetBkColor(0x000000)
    WinSetTrans($TodayGui,"",200)
	    GuiSetState()
			GuiCtrlCreateLabel($OverViewStatus[2],48,190,200,40)
	If $OverViewTime[2] = "Today" Then
    GuiCtrlCreateLabel($OverViewTime[2], 48,10,200,50)
ElseIf $OverViewTime[2] = "Tonight" Then
	GuiCtrlCreateLabel($OverViewTime[2], 45,10,200,50)
Else
	MsgBox(0, "Test", "Error")
EndIf
    GuiCtrlCreateLabel("Temperature",38,230,200,40)
    GuiCtrlCreateLabel($OverViewTemp[2] & "°F",64,250,200,40)
	    $ContextMenu = GuiCtrlCreateContextMenu()
    $RightNowItem = GuiCtrlCreateMenuItem($OverViewTime[1], $ContextMenu)
    GUICtrlSetOnEvent($RightNowItem, "_RightNowGUI")
    $TodayItem = GuiCtrlCreateMenuItem($OverViewTime[2], $ContextMenu)
    GUICtrlSetOnEvent($TodayItem, "_TodayGUI")
    $TonightItem = GuiCtrlCreateMenuItem($OverViewTime[3], $ContextMenu)
    GUICtrlSetOnEvent($TonightItem, "_TonightGUI")
    $TomorrowItem = GuiCtrlCreateMenuItem($OverViewTime[4], $ContextMenu)
    GUICtrlSetOnEvent($TomorrowItem, "_TomorrowGUI")
    $RefreshItem = GuiCtrlCreateMenuItem("Refresh", $ContextMenu)
    GUICtrlSetOnEvent($RefreshItem, "_Refresh")
    $ExitItem = GuiCtrlCreateMenuItem("Close", $ContextMenu)
    GUICtrlSetOnEvent($ExitItem, "_Exit")
    DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $RightNowGUI, "hwnd", $h_Desktop_SysListView32)

	    _GDIPlus_StartUp()
    $hImage   = _GDIPlus_ImageLoadFromFile(@ScriptDir & "/Images/Image2.png")
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($TodayGUI)
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage, 13, 35, 130,160)
EndFunc

Func _TonightGUI()
    GuiDelete($RightNowGUI)
    GuiDelete($TodayGUI)
    GuiDelete($TonightGUI)
    GuiDelete($TomorrowGUI)
    $TonightGUI = GUICreate("", 150, 300, $Width-151, $Height-600, BitOR($WS_POPUP,$WS_BORDER), Default, WinGetHandle(AutoItWinGetTitle()))
    GuiSetFont(13)
    GUICtrlSetDefColor(0xFFFFFF)
    GUISetBkColor(0x000000)
    WinSetTrans($TonightGui,"",200)
	GuiSetState()
		GuiCtrlCreateLabel($OverViewStatus[3],48,190,200,40)
	If $OverViewTime[3] = "Tonight" Then
    GuiCtrlCreateLabel($OverViewTime[3], 48,10,200,50)
ElseIf $OverViewTime[3] = "Tomorrow" Then
	GuiCtrlCreateLabel($OverViewTime[3], 43,10,200,50)
Else
	MsgBox(0, "Test", "Error")
EndIf
    GuiCtrlCreateLabel("Temperature",38,230,200,40)
    GuiCtrlCreateLabel($OverViewTemp[3] & "°F",64,250,200,40)
    $ContextMenu = GuiCtrlCreateContextMenu()
    $RightNowItem = GuiCtrlCreateMenuItem($OverViewTime[1], $ContextMenu)
    GUICtrlSetOnEvent($RightNowItem, "_RightNowGUI")
    $TodayItem = GuiCtrlCreateMenuItem($OverViewTime[2], $ContextMenu)
    GUICtrlSetOnEvent($TodayItem, "_TodayGUI")
    $TonightItem = GuiCtrlCreateMenuItem($OverViewTime[3], $ContextMenu)
    GUICtrlSetOnEvent($TonightItem, "_TonightGUI")
    $TomorrowItem = GuiCtrlCreateMenuItem($OverViewTime[4], $ContextMenu)
    GUICtrlSetOnEvent($TomorrowItem, "_TomorrowGUI")
    $RefreshItem = GuiCtrlCreateMenuItem("Refresh", $ContextMenu)
    GUICtrlSetOnEvent($RefreshItem, "_Refresh")
    $ExitItem = GuiCtrlCreateMenuItem("Close", $ContextMenu)
    GUICtrlSetOnEvent($ExitItem, "_Exit")
    DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $RightNowGUI, "hwnd", $h_Desktop_SysListView32)

	    _GDIPlus_StartUp()
    $hImage   = _GDIPlus_ImageLoadFromFile(@ScriptDir & "/Images/Image3.png")
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($TonightGUI)
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage, 13, 35, 130,160)
EndFunc

Func _TomorrowGUI()
    GuiDelete($RightNowGUI)
    GuiDelete($TodayGUI)
    GuiDelete($TonightGUI)
    GuiDelete($TomorrowGUI)
    $TomorrowGUI = GUICreate("", 150, 300, $Width-151, $Height-600, BitOR($WS_POPUP,$WS_BORDER), Default, WinGetHandle(AutoItWinGetTitle()))
    GuiSetFont(13)
    GUICtrlSetDefColor(0xFFFFFF)
    GUISetBkColor(0x000000)
    WinSetTrans($TomorrowGui,"",200)
	GuiSetState()
	GuiCtrlCreateLabel($OverViewStatus[4],48,190,200,40)
	If $OverViewTime[4] = "Tomorrow" Then
    GuiCtrlCreateLabel($OverViewTime[4], 45,10,200,50)
ElseIf $OverViewTime[4] = "Tomorrow Night" Then
	GuiCtrlCreateLabel($OverViewTime[4], 22,10,200,50)
EndIf
    GuiCtrlCreateLabel("Temperature",38,230,200,40)
    GuiCtrlCreateLabel($OverViewTemp[4] & "°F",64,250,200,40)
    $ContextMenu = GuiCtrlCreateContextMenu()
    $RightNowItem = GuiCtrlCreateMenuItem($OverViewTime[1], $ContextMenu)
    GUICtrlSetOnEvent($RightNowItem, "_RightNowGUI")
    $TodayItem = GuiCtrlCreateMenuItem($OverViewTime[2], $ContextMenu)
    GUICtrlSetOnEvent($TodayItem, "_TodayGUI")
    $TonightItem = GuiCtrlCreateMenuItem($OverViewTime[3], $ContextMenu)
    GUICtrlSetOnEvent($TonightItem, "_TonightGUI")
    $TomorrowItem = GuiCtrlCreateMenuItem($OverViewTime[4], $ContextMenu)
    GUICtrlSetOnEvent($TomorrowItem, "_TomorrowGUI")
    $RefreshItem = GuiCtrlCreateMenuItem("Refresh", $ContextMenu)
    GUICtrlSetOnEvent($RefreshItem, "_Refresh")
    $ExitItem = GuiCtrlCreateMenuItem("Close", $ContextMenu)
    GUICtrlSetOnEvent($ExitItem, "_Exit")
    DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $RightNowGUI, "hwnd", $h_Desktop_SysListView32)

	_GDIPlus_StartUp()
    $hImage   = _GDIPlus_ImageLoadFromFile(@ScriptDir & "/Images/Image4.png")
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($TomorrowGUI)
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage, 13, 35, 130,160)
EndFunc

Func _Quit()
    Exit
EndFunc

While 1
    Sleep(10)
WEnd


Func _GetDesktopHandle()
    $h_Desktop_SysListView32 = 0

    Local Const $hDwmApiDll = DllOpen("dwmapi.dll")
    Local $sChkAero = DllStructCreate("int;")
    DllCall($hDwmApiDll, "int", "DwmIsCompositionEnabled", "ptr", DllStructGetPtr($sChkAero))
    Local $aero_on = DllStructGetData($sChkAero, 1)

    If Not $aero_on Then
        $h_Desktop_SysListView32 = WinGetHandle("Program Manager")
        Return 1
    Else
        Local $hCBReg = DllCallbackRegister("_GetDesktopHandle_EnumChildWinProc", "hwnd", "hwnd;lparam")
        If $hCBReg = 0 Then Return SetError(2)
        DllCall("user32.dll", "int", "EnumChildWindows", "hwnd", _WinAPI_GetDesktopWindow(), "ptr", DllCallbackGetPtr($hCBReg), "lparam", 101)
        Local $iErr = @error
        DllCallbackFree($hCBReg)
        If $iErr Then
            Return SetError(3, $iErr, "")
        EndIf
        Return 2
    EndIf
EndFunc

Func _Refresh()
	_GetOverViewTimes()
    _GetOverViewTemperature()
    _GetOverViewImages()
    _GetOverViewStatus()
    _RightNowGUI()
EndFunc

Func _Exit()
_GDIPlus_GraphicsDispose($hGraphic)
_GDIPlus_ImageDispose($hImage)
_GDIPlus_ShutDown()
    Exit
EndFunc