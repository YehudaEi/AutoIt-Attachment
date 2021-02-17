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
#include <ButtonConstants.au3>
Opt("GUIOnEventMode", 1)
;GUISetState(@SW_SHOW)
HotKeySet("{ESC}", "Beenden")
;declare
Dim $Pos
Dim $PosOld[2]
Dim $PosSlOld[4]
Local $hGUI, $hChild, $hWnd_Desktop, $menu1
Local $hDC_Dest, $hDC_Source, $backbuffer, $X2, $Y2, $X, $Y
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
$PixelDat = 4
$Pos = MouseGetPos()
;GUI
$hGUI = GUICreate("Main", 300, 510, -1, -1, $WS_EX_LAYERED, $WS_EX_TOPMOST)
$menu1 = GUICtrlCreateMenu("File")
$menuexit = GUICtrlCreateMenuitem("Beenden", $menu1)
$Slider1 = GUICtrlCreateSlider(5, 290, 130, 32, BitOR($TBS_AUTOTICKS, $TBS_BOTH, $TBS_NOTICKS, $TBS_FIXEDLENGTH, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$Slider2 = GUICtrlCreateSlider(5, 345, 130, 32, BitOR($TBS_AUTOTICKS, $TBS_BOTH, $TBS_NOTICKS, $TBS_FIXEDLENGTH, $WS_BORDER), BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
$SliderOben = GUICtrlCreateSlider(37, 0, 226, 32, 0, $TBS_NOTICKS)
$SliderUnten = GUICtrlCreateSlider(37, 230, 226, 34, BitOR($TBS_TOP, $TBS_LEFT, $TBS_NOTICKS))
$SliderLinks = GUICtrlCreateSlider(15, 17, 34, 226, $TBS_VERT, $TBS_NOTICKS)
$SliderRechts = GUICtrlCreateSlider(250, 17, 34, 226, BitOR($TBS_VERT, $TBS_NOTICKS, $TBS_TOP, $TBS_LEFT))
$Input1 = GUICtrlCreateInput("", 4, 400, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input2 = GUICtrlCreateInput("", 4, 420, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input3 = GUICtrlCreateInput("", 4, 440, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input4 = GUICtrlCreateInput("", 210, 265, 40, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input5 = GUICtrlCreateInput("", 80, 270, 30, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input6 = GUICtrlCreateInput("", 80, 325, 30, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input7 = GUICtrlCreateInput("", 150, 365, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input8 = GUICtrlCreateInput("", 150, 390, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Pixel = GUICtrlCreateUpdown($Input4)
$Label1 = GUICtrlCreateLabel("Koordinaten:", 5, 383, 64, 17)
$Label2 = GUICtrlCreateLabel(' x - Achse = ', 20, 270, 48, 17)
$Label3 = GUICtrlCreateLabel(' y - Achse = ', 20, 325, 48, 17)
$Label4 = GUICtrlCreateLabel('Auswahl halten', 165, 295, 100, 17, $SS_CENTER)
$Label5 = GUICtrlCreateLabel(' Zoom ', 145, 267, 60, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Label6 = GUICtrlCreateLabel('Auswahl', 170, 348, 65, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Label7 = GUICtrlCreateLabel('Shift zum speichern', 160, 445, 100, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
GUICtrlSetFont($Label4, 9, 800, 4, "MS Sans Serif")
GUICtrlSetFont($Label5, 9, 800, "MS Sans Serif")
GUICtrlSetFont($Label6, 9, 800, 4, "MS Sans Serif")
$Checkbox1 = GUICtrlCreateCheckbox(" ALT + 1", 175, 312, 80, 17, BitOR($BS_CHECKBOX,$BS_AUTOCHECKBOX,$BS_RIGHTBUTTON,$BS_MULTILINE,$BS_FLAT,$WS_TABSTOP,$WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
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
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)



;Schleife
While GUIGetMsg(1) <> $GUI_EVENT_CLOSE
    Sleep(75)

	;Slider 'Auswahl Position'
	If $SliderLinksPos > $SliderRechtsPos Then
		$Ya = $SliderRechtsPos
		$Y = $SliderRechtsPos + $iY
		$height = $SliderLinksPos - $SliderRechtsPos
		$Y2 = $Y + $height
	Else
		$Ya = $SliderLinksPos
		$Y = $SliderLinksPos + $iY
		$height = $SliderRechtsPos - $SliderLinksPos
		$Y2 = $Y + $height
	EndIf
	If $SliderObenPos > $SliderUntenPos Then
		$Xa = $SliderUntenPos
		$X = $SliderUntenPos + $iX
		$width = $SliderObenPos - $SliderUntenPos
		$X2 = $X +$width
	Else
		$Xa = $SliderObenPos
		$X = $SliderObenPos + $iX
		$width = $SliderUntenPos - $SliderObenPos
		$X2 = $X + $width
	EndIf


	GUICtrlSetData($Input4, $PixelDat)
	GUICtrlSetData($Input7, ' x = ' & $X & ', y = ' & $Y)
	GUICtrlSetData($Input8, ' Breite = ' & $width & ', Höhe = ' & $height)


	;Checkbox1
	If _IsPressed('12', $dll) And _IsPressed('31', $dll) Then
		Sleep(50)
		If BitAnd(GUICtrlRead($Checkbox1),$GUI_CHECKED) = $GUI_CHECKED THEN
			GUICtrlSetState ($Checkbox1, $GUI_UNCHECKED)
		ElseIf BitAnd(GUICtrlRead($Checkbox1),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN
			GUICtrlSetState ($Checkbox1, $GUI_CHECKED)
		EndIf
    EndIf
	;wenn Checkbox1 'unchecked'
	If BitAnd(GUICtrlRead($Checkbox1),$GUI_UNCHECKED) = $GUI_UNCHECKED THEN
		;Mausposition abfragen
		$Pos = MouseGetPos()
		; MausAuswahlposition abfragen
		$aWinPos = WinGetPos($hLupe)
		$iX = $aWinPos[0] ; x
		$iY = $aWinPos[1] ; y
		$iW = $aWinPos[2] ; width
		$iH = $aWinPos[3] ; height
		;InfoPost
		ToolTip(($aWinPos[0] + ($aWinPos[2] / 2)) & ', ' & ($aWinPos[1] + ($aWinPos[3] / 2)), $iX, $iY + $iH)
		GUICtrlSetData($Input1, 'Maus:  x = ' & $Pos[0] & ' ,  y = ' & $Pos[1])
		GUICtrlSetData($Input2, 'Lupe:  x = ' & $aWinPos[0] & ' ,  y = ' & $aWinPos[1])
		GUICtrlSetData($Input3, 'Horizontal:  ' & $countLR & ' ,  Vertikal:  ' & $countHR)
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



		$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
		$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
		$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
		$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)
		If $SliderObenPos <> $PosSlOld[0] Or $SliderUntenPos <> $PosSlOld[1] Or $SliderLinksPos <> $PosSlOld[2] Or $SliderRechtsPos <> $PosSlOld[3] Then

			$PosSlOld[0] = $SliderObenPos
			$PosSlOld[1] = $SliderUntenPos
			$PosSlOld[2] = $SliderLinksPos
			$PosSlOld[3] = $SliderRechtsPos
		EndIf



		; Bild per StretchBlt übertragen
		$Lupe = _WinAPI_StretchBlt( _
				$hDC_Dest, 50, 30, 200, 200, _
				$hDC_Source, $iX, $iY, $iW, $iH, _
				$SRCCOPY)

		;Auswahl 'Auswahlslider'
		$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
		$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
		$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
		$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)
		;Auswahl zeichnen
		_GDIPlus_GraphicsDrawLine ($hGraphic, 50, 30 + $SliderLinksPos, 248, 30 + $SliderLinksPos, $hPen); oben
		_GDIPlus_GraphicsDrawLine ($hGraphic, 50, 30 + $SliderRechtsPos, 248, 30 + $SliderRechtsPos, $hPen); unten
		_GDIPlus_GraphicsDrawLine ($hGraphic, 50 + $SliderObenPos, 30, 50 + $SliderObenPos, 230, $hPen); links
		_GDIPlus_GraphicsDrawLine ($hGraphic, 50 + $SliderUntenPos, 30, 50 + $SliderUntenPos, 230, $hPen); rechts

	;wenn Checkbox1 'checked'
	ElseIf BitAnd(GUICtrlRead($Checkbox1),$GUI_CHECKED) = $GUI_CHECKED THEN
		$WinPosSave = WinGetPos($hLupe)
		$iX = $WinPosSave[0] ; x
		$iY = $WinPosSave[1] ; y
		$iW = $WinPosSave[2] ; width
		$iH = $WinPosSave[3] ; height
		$Lupe = _WinAPI_StretchBlt( _
				$hDC_Dest, 50, 30, 200, 200, _
				$hDC_Source, $iX, $iY, $iW, $iH, _
				$SRCCOPY)

				;Auswahl 'Auswahlslider'
				$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
				$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
				$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
				$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)
				;Auswahl zeichnen
				_GDIPlus_GraphicsDrawLine ($hGraphic, 50, 30 + $SliderLinksPos, 248, 30 + $SliderLinksPos, $hPen); oben
				_GDIPlus_GraphicsDrawLine ($hGraphic, 50, 30 + $SliderRechtsPos, 248, 30 + $SliderRechtsPos, $hPen); unten
				_GDIPlus_GraphicsDrawLine ($hGraphic, 50 + $SliderObenPos, 30, 50 + $SliderObenPos, 230, $hPen); links
				_GDIPlus_GraphicsDrawLine ($hGraphic, 50 + $SliderUntenPos, 30, 50 + $SliderUntenPos, 230, $hPen); rechts

	EndIf



    ;Bild speichern
    If _IsPressed('10') Then
        $hBMP = _ScreenCapture_CaptureWnd(@DesktopDir & "\Image.jpg", $hLupe, $iX, $iY, $iX + $iW, $iY + $iH)
		$hBMP2 = _ScreenCapture_CaptureWnd(@DesktopDir & '\Image2.jpg', $Lupe, $Xa, $Ya, $Xa + $width, $Ya + $height)
        _ScreenCapture_SaveImage(@DesktopDir & "\Image.jpg", $hBMP)
		_ScreenCapture_SaveImage(@DesktopDir & '\Image2.jpg', $hBMP2)
    EndIf
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
	_GDIPlus_PenDispose($hPen)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
    Exit
EndFunc   ;==>Beenden