#include <WinAPI.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <GuiSlider.au3>
#include <EditConstants.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <UpDownConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
Opt("GUIOnEventMode", 1)
;GUISetState(@SW_SHOW)
HotKeySet("{ESC}", "Beenden")
;declare
Dim $Pos
Dim $PosOld[2]
Dim $PosSlOld[4]
Local $hGUI, $hChild, $hWnd_Desktop, $menu1
Local $hDC_Dest, $hDC_Source, $backbuffer
Local $iX, $iY, $iW, $iH, $Lupe, $copyLupe
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
;GUI
$hGUI = GUICreate("Main", 300, 510, -1, -1, $WS_EX_LAYERED, $WS_EX_TOPMOST)
;$hGraphic = GUICreate("", 300, 485, -1, -1, $WS_EX_LAYERED, $hGUI)
$menu1 = GUICtrlCreateMenu("File")
$menuexit = GUICtrlCreateMenuitem("Beenden", $menu1)
$Slider1 = GUICtrlCreateSlider(5, 290, 160, 32, BitOR($TBS_AUTOTICKS, $TBS_BOTH, $TBS_NOTICKS, $TBS_FIXEDLENGTH, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$Slider2 = GUICtrlCreateSlider(5, 345, 160, 32, BitOR($TBS_AUTOTICKS, $TBS_BOTH, $TBS_NOTICKS, $TBS_FIXEDLENGTH, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$SliderOben = GUICtrlCreateSlider(37, 0, 226, 32, 0)
$SliderUnten = GUICtrlCreateSlider(37, 230, 226, 34, BitOR($TBS_TOP, $TBS_LEFT))
$SliderLinks = GUICtrlCreateSlider(15, 17, 34, 226, $TBS_VERT)
$SliderRechts = GUICtrlCreateSlider(250, 17, 34, 226, BitOR($TBS_VERT, $TBS_TOP, $TBS_LEFT))
$SliderOben = GUICtrlCreateSlider(37, 0, 226, 32, 0)
$SliderUnten = GUICtrlCreateSlider(37, 230, 226, 34, BitOR($TBS_TOP, $TBS_LEFT))
$SliderLinks = GUICtrlCreateSlider(15, 17, 34, 226, $TBS_VERT)
$SliderRechts = GUICtrlCreateSlider(250, 17, 34, 226, BitOR($TBS_VERT, $TBS_TOP, $TBS_LEFT))
$Input1 = GUICtrlCreateInput("", 4, 400, 184, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input2 = GUICtrlCreateInput("", 4, 420, 184, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input3 = GUICtrlCreateInput("", 4, 440, 184, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input4 = GUICtrlCreateInput("", 220, 400, 50, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input5 = GUICtrlCreateInput("", 60, 270, 30, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input6 = GUICtrlCreateInput("", 60, 325, 30, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Pixel = GUICtrlCreateUpdown($Input4)
$Label1 = GUICtrlCreateLabel("Koordinaten:", 5, 380, 64, 17)
$Label2 = GUICtrlCreateLabel('x - Achse = ', 10, 270, 48, 17)
$Label3 = GUICtrlCreateLabel('y - Achse = ', 10, 325, 48, 17)
$hPen = _GDIPlus_PenCreate()
GUISetState(@SW_SHOW, $hGUI)
GUICtrlSetState($Slider1, $GUI_DISABLE)
GUICtrlSetLimit($Slider1, @DesktopWidth, 0)
GUICtrlSetData($Slider1, $iX)
GUICtrlSetState($Slider2, $GUI_DISABLE)
GUICtrlSetLimit($Slider2, @DesktopHeight, 0)
GUICtrlSetData($Slider2, $iY)
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
;GUISetState(@SW_SHOW, $hGUI)
GUISetOnEvent($GUI_EVENT_CLOSE, "Beenden")
GUICtrlSetOnEvent($menuexit, "Beenden")
GUICtrlSetFont($Label1, 8, 400, 4, "MS Sans Serif")
GUICtrlSetData($Input4, $PixelDat)
$hLupe = GUICreate("", ($dist / 2), ($dist / 2), $Pos[0] + ($dist / 8), $Pos[1] + ($dist / 8), $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_STATICEDGE), $hGUI)
GUICtrlSetBkColor(GUICtrlCreateLabel("", 0, 0, ($dist / 2), ($dist / 2)), 0xFF0000)
GUICtrlSetBkColor(GUICtrlCreateLabel("", 2, 2, (($dist / 2) - $Border), (($dist / 2) - $Border)), 0xABCDEF)
GUISetState()
_GDIPlus_Startup()
_WinAPI_SetLayeredWindowAttributes($hLupe, 0xABCDEF, 255)


$hWnd_Desktop = _WinAPI_GetDesktopWindow()
$hDC_Source = _WinAPI_GetDC($hWnd_Desktop)
$hDC_Dest = _WinAPI_GetDC($hGUI)


;Backbuffer ?!?
;$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

;~ _GDIPlus_GraphicsDrawLine($hGraphic, 50, 30 + $SliderLinksPos, 248, 30 + $SliderLinksPos, $hPen); oben
;~ _GDIPlus_GraphicsDrawLine($hGraphic, 50, 30 + $SliderRechtsPos, 248, 30 + $SliderRechtsPos, $hPen); unten
;~ _GDIPlus_GraphicsDrawLine($hGraphic, 50 + $SliderObenPos, 30, 50 + $SliderObenPos, 230, $hPen); links
;~ _GDIPlus_GraphicsDrawLine($hGraphic, 50 + $SliderUntenPos, 30, 50 + $SliderUntenPos, 230, $hPen); rechts



;Schleife
While GUIGetMsg(1) <> $GUI_EVENT_CLOSE
	Sleep(75)
	;Mousposition abfragen
	$Pos = MouseGetPos()

	; Winposition abfragen
	$aWinPos = WinGetPos($hLupe)
	$iX = $aWinPos[0] ; x
	$iY = $aWinPos[1] ; y
	$iW = $aWinPos[2] ; width
	$iH = $aWinPos[3] ; height
	;Wenn sich Mausposition ändert
	If $Pos[0] <> $PosOld[0] Or $Pos[1] <> $PosOld[1] Then
		WinMove($hLupe, "", $Pos[0] + ($dist / 8), $Pos[1] + ($dist / 8))
		$PosOld = $Pos
		$countLR = 0
		$countHR = 0
		GUICtrlSetData($Slider1, $iX)
		GUICtrlSetData($Slider2, $iY)
		GUICtrlSetData($Input5, $iX + ($iW / 2))
		GUICtrlSetData($Input6, $iY + ($iH / 2))
	EndIf

	;Wenn Bewegungstaste gedrückt
	If _IsPressed('25', $dll) And $iX > $Sl1ScaleMin Then ;links gedrückt
		$countLR = $countLR + (-1)
		WinMove($hLupe, "", $iX - $Scale, $iY)
		GUICtrlSetData($Input5, $iX + ($iW / 2))
		GUICtrlSetData($Slider1, $iX)
		_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	ElseIf _IsPressed('27', $dll) And ($iX + $iW) < $Sl1ScaleMax Then ;rechts gedrückt
		$countLR = $countLR + 1
		WinMove($hLupe, "", $iX + $Scale, $iY)
		GUICtrlSetData($Input5, $iX + ($iW / 2))
		GUICtrlSetData($Slider1, $iX)
		_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	ElseIf _IsPressed('26', $dll) And $iY > $Sl2ScaleMin Then ;hoch gedrückt
		$countHR = $countHR + (-1)
		WinMove($hLupe, "", $iX, $iY - $Scale)
		GUICtrlSetData($Input6, $iY + ($iH / 2))
		GUICtrlSetData($Slider2, $iY)
		_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	ElseIf _IsPressed('28', $dll) And ($iY + $iH) < $Sl2ScaleMax Then ;runter gedrückt
		$countHR = $countHR + 1
		WinMove($hLupe, "", $iX, $iY + $Scale)
		GUICtrlSetData($Input6, $iY + ($iH / 2))
		GUICtrlSetData($Slider2, $iY)
		_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	EndIf

	;InfoPost
	ToolTip(($aWinPos[0] + ($aWinPos[2] / 2)) & ', ' & ($aWinPos[1] + ($aWinPos[3] / 2)), $iX, $iY + $iH)
	GUICtrlSetData($Input1, 'Maus:  x = ' & $Pos[0] & ' ,  y = ' & $Pos[1])
	GUICtrlSetData($Input2, 'Auswahl:  x = ' & $aWinPos[0] & ' ,  y = ' & $aWinPos[1])
	GUICtrlSetData($Input3, 'Horizontal:  ' & $countLR & ' ,  Vertikal:  ' & $countHR)


	;Pixelgrösse des zu kopierenden Objekts
	$PixelDat = 10
	GUICtrlSetData($Input4, $PixelDat)

	;Bild speichern
	If _IsPressed('10') Then
		$hBMP = _ScreenCapture_CaptureWnd(@DesktopDir & "\Image.jpg", $hLupe, $iX, $iY, $iX + $iW, $iY + $iH)
		_ScreenCapture_SaveImage(@DesktopDir & "\Image.jpg", $hBMP)
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
	;Auswahl Slider
	$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
	$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
	$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
	$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)

	If $SliderObenPos <> $PosSlOld[0] Or $SliderUntenPos <> $PosSlOld[1] Or $SliderLinksPos <> $PosSlOld[2] Or $SliderRechtsPos <> $PosSlOld[3] Then
		$PosSlOld[0] = $SliderObenPos
		$PosSlOld[1] = $SliderUntenPos
		$PosSlOld[2] = $SliderLinksPos
		$PosSlOld[3] = $SliderRechtsPos


;~ 		_GDIPlus_GraphicsDrawLine($hGraphic, 50, 30 + $SliderLinksPos, 248, 30 + $SliderLinksPos, $hPen); oben
;~ 		_GDIPlus_GraphicsDrawLine($hGraphic, 50, 30 + $SliderRechtsPos, 248, 30 + $SliderRechtsPos, $hPen); unten
;~ 		_GDIPlus_GraphicsDrawLine($hGraphic, 50 + $SliderObenPos, 30, 50 + $SliderObenPos, 230, $hPen); links
;~ 		_GDIPlus_GraphicsDrawLine($hGraphic, 50 + $SliderUntenPos, 30, 50 + $SliderUntenPos, 230, $hPen); rechts
		;_WinAPI_RedrawWindow($hGUI)
		;_WinAPI_UpdateLayeredWindow(
	EndIf




	; Bild per StretchBlt übertragen
	$Lupe = _WinAPI_StretchBlt( _
			$hDC_Dest, 50, 30, 200, 200, _
			$hDC_Source, $iX, $iY, $iW, $iH, _
			$SRCCOPY)
	;

WEnd

;Funktionen
Func _WinAPI_StretchBlt($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $iRop)
	; See _WinAPI_BitBlt
	Local $Ret = DllCall('gdi32.dll', 'int', 'StretchBlt', 'hwnd', $hDestDC, 'int', $iXDest, 'int', $iYDest, 'int', $iWidthDest, 'int', $iHeightDest, 'hwnd', $hSrcDC, 'int', $iXSrc, 'int', $iYSrc, 'int', $iWidthSrc, 'int', $iHeightSrc, 'dword', $iRop)
	If (@error) Or (Not IsArray($Ret)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_WinAPI_StretchBlt
Func Beenden()
	Exit
EndFunc   ;==>Beenden