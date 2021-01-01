#cs
	A big thanks to AdmiralAlkex for giving allowing me to use his source as a guide
	The image and the SetBitmap functions are from Frank's Gadget by AdmiralAlkex
	The Restrain function is curtosy of Martin.
#ce
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <SendMessage.au3>
#include <StructureConstants.au3>
#include <WinAPI.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>

Global $Hour = Check_Hour()
Global $Time
Global $ClockControlGUI
Global $ClockGUI
Global Const $Bar_Width = 150
Global Const $RestrainTop = (($Bar_Width - 130) / 2)
Global Const $RestrainBottom = @DesktopHeight - (($Bar_Width - 130) / 2)
Global Const $RestrainLeft = @DesktopWidth - $Bar_Width + (($Bar_Width - 130) / 2)
Global Const $RestrainRight = @DesktopWidth - (($Bar_Width - 130) / 2)

HotKeySet("{ESC}", "OnAutoItExit")
SetWorkingArea(True)
$Bar = CreateWidgetBar($Bar_Width, 150)

CreateClock($RestrainLeft, (($Bar_Width - 130) / 2))
$Window_Position = WinGetPos($ClockGUI)
$Client_Position = WinGetClientSize($ClockGUI)
$Border = ($Window_Position[2] - $Client_Position[0]) / 2
$Title_Height = $Window_Position[3] - $Border - $Client_Position[1]
GUIRegisterMsg($WM_MOVE, "Restrain")

While 1
	$Msg = GUIGetMsg(1)
	If $Msg[0] = $GUI_EVENT_PRIMARYDOWN And $Msg[1] = $ClockControlGUI Then
		_SendMessage($ClockGUI, $WM_SYSCOMMAND, 0xF012, 0) ; SC_DRAGMOVE
		WinActivate($ClockControlGUI)
	EndIf
	GUICtrlSetData($Time, $Hour & ":" & @MIN & ":" & @SEC)
WEnd

Func OnAutoItExit()
	SetWorkingArea(False)
	While ProcessExists("Clock.exe")
		ProcessClose("Clock.exe")
		Sleep(500)
	WEnd
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>OnAutoItExit

Func Restrain($hWnd, $iMsg, $wp, $lP)

	Local $x, $y, $p, $z, $gp
	If $hWnd <> $Bar Then WinSetOnTop($hWnd, "", 1)
	$gp = WinGetPos($hWnd)

	$x = BitAND($lP, 0xFFFF)
	$y = BitAND($lP, 0xFFFF0000) / 0x10000
	If $x < $RestrainLeft Or $x + $gp[2] >= $RestrainRight Or _
			$y < $RestrainTop Or $y + $gp[3] > $RestrainBottom Then
		If $x < $RestrainLeft Then $x = $RestrainLeft
		If $x + $gp[2] >= $RestrainRight Then $x = -$gp[2] + $RestrainRight
		If $y < $RestrainTop + $Title_Height Then $y = $RestrainTop;+ $TitleHt
		If $y + $gp[3] > $RestrainBottom Then $y = $RestrainBottom - $gp[3]
		MouseUp("left")
		WinMove($hWnd, "", $x - $Border, $y - $Title_Height)

	EndIf
	Return $GUI_RUNDEFMSG


EndFunc   ;==>Restrain

#Region Clock Widget
Func Check_Hour()
	If @HOUR > 12 Then
		$Hour = @HOUR - 12
	Else
		$Hour = @HOUR
	EndIf
	Return $Hour
EndFunc   ;==>Check_Hour

Func CreateClock($Left, $Top)
	_GDIPlus_Startup()

	$ClockImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\Clock Background.png")
	$ImageWidth = _GDIPlus_ImageGetWidth($ClockImage) ;130
	$ImageHeight = _GDIPlus_ImageGetHeight($ClockImage) ;40

	$ClockGUI = GUICreate("DigitalClock", $ImageWidth, $ImageHeight, $Left, $Top, _
			$WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOOLWINDOW))
	GUISetState()
	WinSetOnTop($ClockGUI, "", 1)
	SetBitMap($ClockGUI, $ClockImage, 255)
	$ClockControlGUI = GUICreate("ControlGuiDigitalClock", $ImageWidth - 18, $ImageHeight - 8, Default + 8, Default + 4, _
			$WS_POPUP, BitOR($WS_CLIPCHILDREN, $WS_EX_LAYERED, $WS_EX_MDICHILD, $WS_EX_TOOLWINDOW), $ClockGUI)
	GUISetBkColor(0x000000)

	$Time = GUICtrlCreateLabel($Hour & ":" & @MIN & ":" & @SEC, -2, 2, $ImageWidth - 20, $ImageHeight - 8, $SS_CENTER)
	GUICtrlSetFont(-1, 16)
	GUICtrlSetColor(-1, 0x00ff00)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUISetState()
	AdlibEnable("Check_Hour", 60000)
	WinActivate($ClockGUI)
EndFunc   ;==>CreateClock

Func SetBitmap($hGUI, $hImage, $iOpacity)
	Local $AC_SRC_ALPHA = 1
	Local $ULW_ALPHA = 2
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap
#EndRegion Clock Widget

Func CreateWidgetBar($Width, $Trans)
	Local $GUI = GUICreate("Test", $Width, @DesktopHeight, @DesktopWidth - $Width, 0, $WS_POPUPWINDOW, BitOR($WS_EX_LAYERED, $WS_EX_TOOLWINDOW))
;~ 	_GDIPlus_Startup()
;~ 	$Background = _GDIPlus_ImageLoadFromFile("C:\Documents and Settings\Owner\Desktop\Franks Gadget\Graphics\Background2.png")
	GUISetState()
;~ 	SetBitmap($GUI, $Background, 255)
	GUISetState(@SW_DISABLE)
	WinSetTrans($GUI, "", $Trans)
	WinSetOnTop($GUI, "", 1)
	Return $GUI
EndFunc   ;==>CreateWidgetBar

Func SetWorkingArea($State = False)
	Local $SPIF_SENDCHANGE = 0x0002
	Local $SPI_SETWORKAREA = 0x002F
	Local $Structure = DllStructCreate("int Left;int Top;int Right;int Bottom")
	If $State = True Then
		DllStructSetData($Structure, "Left", 0)
		DllStructSetData($Structure, "Top", 0)
		DllStructSetData($Structure, "Right", @DesktopWidth - $Bar_Width)
		DllStructSetData($Structure, "Bottom", @DesktopHeight)
	Else
		DllStructSetData($Structure, "Left", 0)
		DllStructSetData($Structure, "Top", 0)
		DllStructSetData($Structure, "Right", @DesktopWidth)
		DllStructSetData($Structure, "Bottom", @DesktopHeight)
	EndIf
	DllCall("user32.dll", "int", "SystemParametersInfo", "uint", $SPI_SETWORKAREA, "uint", 0, "ptr", _
			DllStructGetPtr($Structure), "uint", $SPIF_SENDCHANGE)
EndFunc   ;==>SetWorkingArea