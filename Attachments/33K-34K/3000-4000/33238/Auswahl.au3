#include <WinAPI.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#Include <GuiSlider.au3>
#include <EditConstants.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <UpDownConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
Opt("GUIOnEventMode", 1)
HotKeySet("{ESC}", "Beenden")
Dim $Pos
Dim $PosOld[4]
Local $hGUI, $hChild, $hWnd_Desktop, $menu1
Local $hDC_Dest, $hDC_Source, $var
Local $iX, $iY, $iW, $iH, $Lupe, $copyLupe, $X, $Y, $width, $height
Local $countLR, $countHR, $coordLR, $coordHR, $iXo, $iYo
Local $Sl1ScaleMin, $Sl1ScaleMax, $Sl2ScaleMin, $Sl2ScaleMax, $SliderObenPos, $SliderUntenPos, $SliderLinksPos, $SliderRechtsPos
$Scale = 10
$Sl1ScaleMin = 0
$Sl1ScaleMax = @DesktopWidth
$Sl2ScaleMin = 0
$Sl2ScaleMax = @DesktopHeight
$dll = DllOpen("user32.dll")
$dist = 96
$Border = 4
$PixelDat = 10
$Pos = MouseGetPos()

$hGUI = GUICreate("Main", 300, 485, -1, -1, Default, $WS_EX_TOPMOST)
$SliderOben = GUICtrlCreateSlider(37, 0, 226, 32, 0)
$SliderUnten = GUICtrlCreateSlider(37, 230, 226, 34, BitOR($TBS_TOP,$TBS_LEFT))
$SliderLinks = GUICtrlCreateSlider(15, 17, 34, 226, $TBS_VERT)
$SliderRechts = GUICtrlCreateSlider(250, 17, 34, 226, BitOR($TBS_VERT,$TBS_TOP,$TBS_LEFT))
GUISetState(@SW_SHOW, $hGUI)
GUISetOnEvent($GUI_EVENT_CLOSE, "Beenden")
GUICtrlSetLimit($SliderOben, 200, 0)
GUICtrlSetData($SliderOben, 80)
GUICtrlSetLimit($SliderUnten, 200, 0)
GUICtrlSetData($SliderUnten, 120)
GUICtrlSetLimit($SliderLinks, 200, 0)
GUICtrlSetData($SliderLinks, 80)
GUICtrlSetLimit($SliderRechts, 200, 0)
GUICtrlSetData($SliderRechts, 120)

$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)
GUISetState()


_GDIPlus_Startup()
$hPen = _GDIPlus_PenCreate()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI)

While GUIGetMsg(1) <> $GUI_EVENT_CLOSE

	$Pos = MouseGetPos()

	$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
	$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
	$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
	$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)

	_GDIPlus_GraphicsDrawLine ($hGraphic, 50, 30 + $SliderLinksPos, 248, 30 + $SliderLinksPos, $hPen); oben
	_GDIPlus_GraphicsDrawLine ($hGraphic, 50, 30 + $SliderRechtsPos, 248, 30 + $SliderRechtsPos, $hPen); unten
	_GDIPlus_GraphicsDrawLine ($hGraphic, 50 + $SliderObenPos, 30, 50 + $SliderObenPos, 230, $hPen); links
	_GDIPlus_GraphicsDrawLine ($hGraphic, 50 + $SliderUntenPos, 30, 50 + $SliderUntenPos, 230, $hPen); rechts

	If $SliderObenPos <> $PosOld[0] Or $SliderUntenPos <> $PosOld[1] Or $SliderLinksPos <> $PosOld[2] Or $SliderRechtsPos <> $PosOld[3] Then
		$PosOld[0] = $SliderObenPos
		$PosOld[1] = $SliderUntenPos
		$PosOld[2] = $SliderLinksPos
		$PosOld[3] = $SliderRechtsPos
		_WinAPI_RedrawWindow($hGUI)
	EndIf


	If $SliderLinksPos > $SliderRechtsPos Then
 		$Y = $SliderRechtsPos
		$height = $SliderLinksPos - $SliderRechtsPos
	Else
		$Y = $SliderLinksPos
		$height = $SliderRechtsPos - $SliderLinksPos
	EndIf

	If $SliderObenPos > $SliderUntenPos Then
		$X = $SliderUntenPos
		$width = $SliderObenPos - $SliderUntenPos
	Else
		$X = $SliderObenPos
		$width = $SliderUntenPos - $SliderObenPos
	EndIf

	ToolTip('o: ' & $PosOld[0] & ', u: ' & $PosOld[1] & ', l: ' & $PosOld[2] & ', r: ' & $PosOld[3] & ' /  x: ' & $X & ', y: ' & $Y & ', w: ' & $width & ', h: ' & $height)

WEnd


Func Beenden()
	Exit
EndFunc   ;==>Beenden