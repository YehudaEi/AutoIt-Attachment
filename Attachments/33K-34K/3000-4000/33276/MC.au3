#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include <IE.au3>
#include <Misc.au3>
#include <ScreenCapture.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <Timers.au3>
#include <UpDownConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>

Dim $Pos
Dim $msg[5]
Dim $PosOld[2]
Dim $PosSlOld[4]
Dim $dll = DllOpen("user32.dll")
Global $save, $chksm, $chksmext, $hIE, $oIE, $doc, $Anmelden, $datasplit, $loggedin, $WinStat, $FaceStat, $maxi, $run, $SliderOben
Global $bErst, $bHinz, $bBearb, $hinz, $countl, $num, $Pos, $col, $oInputs, $oForm, $menuopen, $fileopen, $msg, $menustate
Global $oPass, $oUser, $oDiv, $count, $datfile, $Form1, $handle, $datasplit, $menuexit, $menu1, $n1, $Button1, $Button2, $Button3
Global $menutext, $mill, $face, $iX, $iY, $iW, $iH, $Lupe, $copyLupe, $hGUI, $hChild, $hWnd_Desktop, $menu1, $hPen, $SliderLinks
Global $hDC_Dest, $hDC_Source, $backbuffer, $X2, $Y2, $X, $Y, $countLR, $countHR, $coordLR, $coordHR, $iXo, $iYo, $SliderRechts
Global $Sl1ScaleMin, $Sl1ScaleMax, $Sl2ScaleMin, $Sl2ScaleMax, $SliderObenPos, $SliderUntenPos, $SliderLinksPos, $SliderRechtsPos
Global $SliderUnten, $menuErwLaden, $Checkbox1, $hLupe, $Input1, $Input2, $Input3, $Input4, $Input5, $Input6, $Slider1, $Slider2
Global $Input7, $Input8, $mDaten
Local $sUser = 'jimmy.d@gmx.net'
Local $sPass = 'ernstFK'
Local $url = 'www.google.de'
Local $loginurl = 'www.google.de'
Local $stateface = WinGetState('Google')
Local $statemill = WinGetState('Google')
Local $Anmelden = WinExists('Google')
Local $TIMER = TimerInit()
Global Const $TIMEOUT = 180000; 10 seconds
Global $speed = 20
Dim $Haus[255][9]
$Haus[0][0] = 'Nr.'
$Haus[0][1] = 'x'
$Haus[0][2] = 'y'
$Haus[0][3] = 'FarbeMAUS'
$Haus[0][4] = 'chksmMAUS'
$Haus[0][5] = 'FarbeWIN'
$Haus[0][6] = 'chksmWIN'
$Haus[0][5] = 'FarbeAUSW'
$Haus[0][5] = 'chksmAUSW'
$Scale = 10
$Sl1ScaleMin = 0
$Sl1ScaleMax = @DesktopWidth
$Sl2ScaleMin = 0
$Sl2ScaleMax = @DesktopHeight
$dist = 96
$Border = 4
$PixelDat = 4
$Pos = MouseGetPos()
HotKeySet("{ESC}", "Beenden")
Opt("MouseClickDelay", 500)
Opt("MustDeclareVars", 0)
;Opt("GUIEventAdvancedMode", 1)

$hGUI = GUICreate("Main", 300, 510, -1, -1, $WS_EX_LAYERED, $WS_EX_TOPMOST)
$menu1 = GUICtrlCreateMenu("File")
$menuexit = GUICtrlCreateMenuitem("Beenden", $menu1)
$mDaten = GUICtrlCreateMenuitem('Daten', $menu1)
;$menuhinz = GUICtrlCreateMenu("Erstellen")
;$menuErw = GUICtrlCreateMenu("Erweitern")
;$menuErwLaden = GUICtrlCreateMenuitem("Geschäfte", $menuErw)
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
$Checkbox1 = GUICtrlCreateCheckbox(" ALT + 1", 175, 312, 80, 17, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_RIGHTBUTTON, $BS_MULTILINE, $BS_FLAT, $WS_TABSTOP, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
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
GUICtrlSetFont($Label1, 8, 400, 4, "MS Sans Serif")
GUICtrlSetData($Input4, $PixelDat)
$hLupe = GUICreate("", ($dist / 2), ($dist / 2), $Pos[0] + ($dist / 8), $Pos[1] + ($dist / 8), $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_STATICEDGE), $hGUI)
GUICtrlSetBkColor(GUICtrlCreateLabel("", 0, 0, ($dist / 2), ($dist / 2)), 0xFF0000)
GUICtrlSetBkColor(GUICtrlCreateLabel("", 2, 2, (($dist / 2) - $Border), (($dist / 2) - $Border)), 0xABCDEF)
GUISetState()
;
;GUI Erfassen
$Form1 = GUICreate("Daten erfassen", 220, 110, -1, -1) ; (220x x 180y) will create a dialog box that when displayed is centered
$menu2 = GUICtrlCreateMenu("File")
$menuopen = GUICtrlCreateMenuitem("Öffnen", $menu2)
$menuexit = GUICtrlCreateMenuitem("Beenden", $menu2)
$n1 = GUICtrlCreateList("", 10, 3, -1, 50)
$bErst = GUICtrlCreateButton("Erstellen", 10, 55, 50, 25)
$bHinz = GUICtrlCreateButton("Hinzufügen", 70, 55, 65, 25)
$bBearb = GUICtrlCreateButton("Bearbeiten", 145, 55, 65, 25)
GUICtrlSetData($n1, 'Geschäfte|Wohnhäuser|User', 'Geschäfte')
GUICtrlSetState($bHinz, $GUI_FOCUS) ; the focus is on this button
GUISetState(@SW_HIDE, $Form1)
;ENDE GUI Erfassen
;
_GDIPlus_Startup()
$hWnd_Desktop = _WinAPI_GetDesktopWindow()
$hDC_Source = _WinAPI_GetDC($hWnd_Desktop)
$hDC_Dest = _WinAPI_GetDC($hGUI)
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)




;Schleife
While 1;GUIGetMsg(1) <> $GUI_EVENT_CLOSE
	$msg = GUIGetMsg(1)
	;Fensterfunktionen
	Switch $msg[1] ; window-handle
		Case $hGUI
			Switch $msg[0] ; event/control-handle
				Case $GUI_EVENT_CLOSE
					Beenden()
				Case $menuexit
					Beenden()
				Case $mDaten
					WinSetState($Form1, "", @SW_SHOW)
			EndSwitch
		Case $Form1
			Switch $msg[0]
				Case $GUI_EVENT_CLOSE
					GUISetState(@SW_HIDE, $Form1)
					;Case 'Erstellen'
				Case $bErst
					erfassenGUI()
;~                     Switch MsgBox(4, "Angaben Korrekt?", 'Sie wollen die Daten für' & @CRLF & GUICtrlRead($n1) & @CRLF & 'neu erstellen?')
;~ 						Case 6 ; JA
;~ 							If GUICtrlRead($n1) = 'Geschäfte' Then
;~ 								$save = FileOpen(@ScriptDir & '\Geschäftsdaten.txt', 2)
;~ 							ElseIf GUICtrlRead($n1) = 'Wohnhäuser' Then
;~ 								$save = FileOpen(@ScriptDir & '\Häuserdaten.txt', 2)
;~ 							ElseIf GUICtrlRead($n1) = 'User' Then
;~ 								$save = FileOpen(@ScriptDir & '\User.txt', 2)
;~ 							EndIf
;~ 							Einloggen()
;~ 							erfassen($save, $datfile)
;~ 						Case 7 ; NEIN
;~ 							WinSetState($Form1, "", @SW_SHOW)
;~ 							;ExitLoop
;~ 					EndSwitch
					;Case 'Hinzufügen'
				Case $bHinz
					erfassenGUI()
;~ 					Switch MsgBox(4, "Angaben Korrekt?", 'Sie wollen die Daten für' & @CRLF & GUICtrlRead($n1) & @CRLF & 'erweitern?')
;~ 						Case 6 ; JA
;~ 							$hinz = 1
;~ 							If GUICtrlRead($n1) = 'Geschäfte' Then
;~ 								$save = FileOpen(@ScriptDir & '\Geschäftsdaten.txt', 1)
;~ 								$datfile = @ScriptDir & '\Geschäftsdaten.txt'
;~ 							ElseIf GUICtrlRead($n1) = 'Wohnhäuser' Then
;~ 								$save = FileOpen(@ScriptDir & '\Häuserdaten.txt', 1)
;~ 								$datfile = @ScriptDir & '\Häuserdaten.txt'
;~ 							ElseIf GUICtrlRead($n1) = 'User' Then
;~ 								$save = FileOpen(@ScriptDir & '\User.txt', 1)
;~ 								$datfile = @ScriptDir & '\User.txt'
;~ 							EndIf
;~ 							Einloggen()
;~ 							erfassen($save, $datfile)
;~ 						Case 7 ; NEIN
;~ 							WinSetState($Form1, "", @SW_SHOW)
;~ 							;ExitLoop
;~ 					EndSwitch
					;Case 'Bearbeiten'
				Case $bBearb
					If GUICtrlRead($n1) = 'Geschäfte' Then
						$run = 'Notepad.exe ' & @ScriptDir & '\Geschäftsdaten.txt'
						Run($run)
					ElseIf GUICtrlRead($n1) = 'Wohnhäuser' Then
						$run = 'Notepad.exe ' & @ScriptDir & '\Häuserdaten.txt'
						Run($run)
					ElseIf GUICtrlRead($n1) = 'User' Then
						$run = 'Notepad.exe ' & @ScriptDir & '\User.txt'
						Run($run)
					EndIf
				Case $menuopen
					$fileopen = FileOpenDialog("Wählen Sie eine Datei aus...", @TempDir, "Alle (*.*)")
					If @error Then
						MsgBox(4096, "Fehler!", 'Abbruch' & @CRLF & @CRLF & 'Keine Datei ausgewählt!')
					Else
						$run = 'Notepad.exe ' & $fileopen
						Run($run)
					EndIf
				Case $menuexit
					GUISetState(@SW_HIDE, $Form1)
			EndSwitch
	EndSwitch



	;Ende Fensterfunktionen
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
		$X2 = $X + $width
	Else
		$Xa = $SliderObenPos
		$X = $SliderObenPos + $iX
		$width = $SliderUntenPos - $SliderObenPos
		$X2 = $X + $width
	EndIf
	$msg = GUIGetMsg(1)
	;Checkbox1
	If _IsPressed('12', $dll) And _IsPressed('31', $dll) Then
		Sleep(50)
		If BitAND(GUICtrlRead($Checkbox1), $GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
		ElseIf BitAND(GUICtrlRead($Checkbox1), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
			GUICtrlSetState($Checkbox1, $GUI_CHECKED)
		EndIf
	EndIf
	;wenn Checkbox1 'unchecked'
	If BitAND(GUICtrlRead($Checkbox1), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
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

		draw()

		;wenn Checkbox1 'checked'
	ElseIf BitAND(GUICtrlRead($Checkbox1), $GUI_CHECKED) = $GUI_CHECKED Then
		$WinPosSave = WinGetPos($hLupe)
		$iX = $WinPosSave[0] ; x
		$iY = $WinPosSave[1] ; y
		$iW = $WinPosSave[2] ; width
		$iH = $WinPosSave[3] ; height

		draw()

	EndIf
	;Bild speichern
	If _IsPressed('10') Then
		$x1 = $SliderObenPos / 200 * $iW
		$X2 = $SliderUntenPos / 200 * $iW
		$X = Round(Min($x1, $X2), 0)
		$y1 = $SliderLinksPos / 200 * $iW
		$Y2 = $SliderRechtsPos / 200 * $iW
		$Y = Round(Min($y1, $Y2), 0)
		$y1 = Round($SliderLinksPos / 200 * $iW, 0)
		$Y2 = Round($SliderRechtsPos / 200 * $iW, 0)
		$w1 = Floor(Abs($SliderObenPos - $SliderUntenPos) / 200 * $iH)
		$h1 = Floor(Abs($SliderLinksPos - $SliderRechtsPos) / 200 * $iW)
		$hBMP = _ScreenCapture_Capture(@DesktopDir & "\Image.jpg", $iX, $iY, $iX + $iW, $iY + $iH)
		$hBMP2 = _ScreenCapture_Capture(@DesktopDir & '\Image2.jpg', $iX + $X - 2, $iY + $Y - 2, $iX + $X + $w1, $iY + $Y + $h1)
		_ScreenCapture_SaveImage(@DesktopDir & "\Image.jpg", $hBMP)
		_ScreenCapture_SaveImage(@DesktopDir & '\Image2.jpg', $hBMP2)
	EndIf
	$msg = GUIGetMsg(1)
	GUICtrlSetData($Input4, $PixelDat)
	GUICtrlSetData($Input7, ' x = ' & $X & ', y = ' & $Y)
	GUICtrlSetData($Input8, ' Breite = ' & $width & ', Höhe = ' & $height)
WEnd
;Ende Schleife

;Funktionen
;~ Func GUIErfassen()
;~ 	;GUI Erfassen
;~ 	$Form1 = GUICreate("Daten erfassen", 220, 110, -1, -1) ; (220x x 180y) will create a dialog box that when displayed is centered
;~ 	$menu1 = GUICtrlCreateMenu("File")
;~ 	$menuopen = GUICtrlCreateMenuitem("Öffnen", $menu1)
;~ 	$menuexit = GUICtrlCreateMenuitem("Beenden", $menu1)
;~ 	$n1 = GUICtrlCreateList("", 10, 3, -1, 50)
;~ 	$bErst = GUICtrlCreateButton("Erstellen", 10, 55, 50, 25)
;~ 	$bHinz = GUICtrlCreateButton("Hinzufügen", 70, 55, 65, 25)
;~ 	$bBearb = GUICtrlCreateButton("Bearbeiten", 145, 55, 65, 25)
;~ 	GUICtrlSetData($n1, 'Geschäfte|Wohnhäuser|User', 'Geschäfte')
;~ 	GUICtrlSetState($bHinz, $GUI_FOCUS) ; the focus is on this button
;~ 	GUISetState()
;~ 	GUISetState(@SW_HIDE, $n1)
;~ 	;ENDE GUI Erfassen
;~ EndFunc
Func ErfassenGUI()
	GUISetState(@SW_SHOW, $n1)
	Do
		$msg = GUIGetMsg()
		;Datendatei neu anlegen
		If $msg = $bErst Then
			WinSetState($Form1, "", @SW_HIDE)
			Switch MsgBox(4, "Angaben Korrekt?", 'Sie wollen die Daten für' & @CRLF & GUICtrlRead($n1) & @CRLF & 'neu erstellen?')
				Case 6 ; JA
					If GUICtrlRead($n1) = 'Geschäfte' Then
						$save = FileOpen(@ScriptDir & '\Geschäftsdaten.txt', 2)
					ElseIf GUICtrlRead($n1) = 'Wohnhäuser' Then
						$save = FileOpen(@ScriptDir & '\Häuserdaten.txt', 2)
					ElseIf GUICtrlRead($n1) = 'User' Then
						$save = FileOpen(@ScriptDir & '\User.txt', 2)
					EndIf
					Einloggen()
					erfassen($save, $datfile)
				Case 7 ; NEIN
					WinSetState($Form1, "", @SW_SHOW)
					erfassenGUI()
					ExitLoop
			EndSwitch
			;Daten zur Datendatei hinzufügen
		ElseIf $msg = $bHinz Then
			WinSetState($Form1, "", @SW_HIDE)
			Switch MsgBox(4, "Angaben Korrekt?", 'Sie wollen die Daten für' & @CRLF & GUICtrlRead($n1) & @CRLF & 'erweitern?')
				Case 6 ; JA
					$hinz = 1
					If GUICtrlRead($n1) = 'Geschäfte' Then
						$save = FileOpen(@ScriptDir & '\Geschäftsdaten.txt', 1)
						$datfile = @ScriptDir & '\Geschäftsdaten.txt'
					ElseIf GUICtrlRead($n1) = 'Wohnhäuser' Then
						$save = FileOpen(@ScriptDir & '\Häuserdaten.txt', 1)
						$datfile = @ScriptDir & '\Häuserdaten.txt'
					ElseIf GUICtrlRead($n1) = 'User' Then
						$save = FileOpen(@ScriptDir & '\User.txt', 1)
						$datfile = @ScriptDir & '\User.txt'
					EndIf
					Einloggen()
					erfassen($save, $datfile)
				Case 7 ; NEIN
					WinSetState($Form1, "", @SW_SHOW)
					erfassenGUI()
					ExitLoop
			EndSwitch
			;Daten Datei öffnen
		ElseIf $msg = $bBearb Then
			If GUICtrlRead($n1) = 'Geschäfte' Then
				$run = 'Notepad.exe ' & @ScriptDir & '\Geschäftsdaten.txt'
				Run($run)
			ElseIf GUICtrlRead($n1) = 'Wohnhäuser' Then
				$run = 'Notepad.exe ' & @ScriptDir & '\Häuserdaten.txt'
				Run($run)
			ElseIf GUICtrlRead($n1) = 'User' Then
				$run = 'Notepad.exe ' & @ScriptDir & '\User.txt'
				Run($run)
			EndIf
		ElseIf $msg = $menuopen Then
			$fileopen = FileOpenDialog("Wählen Sie eine Datei aus...", @TempDir, "Alle (*.*)")
			If @error Then
				MsgBox(4096, "Fehler!", 'Abbruch' & @CRLF & @CRLF & 'Keine Datei ausgewählt!')
			Else
				$run = 'Notepad.exe ' & $fileopen
				Run($run)
			EndIf
		ElseIf $msg = $menuexit Then
			Beenden()
		EndIf

	Until $msg = $GUI_EVENT_CLOSE
EndFunc   ;==>ErfassenGUI
Func erfassen($save, $datfile)
	_FileReadToArray($datfile, $count)
	If $hinz = 1 Then
		$num = $num + $count[0]
	EndIf
	$dll = DllOpen("user32.dll")
	While 1
		Sleep(10)
		$Pos = MouseGetPos()
		$col = PixelGetColor($Pos[0], $Pos[1])
		$chksm = PixelChecksum($Pos[0] - 5, $Pos[1] - 5, $Pos[0] + 5, $Pos[1] + 5)
		$chksmext = PixelChecksum($Pos[0] + 15, $Pos[1] + 33, $Pos[0] + 31, $Pos[1] + 49)
		ToolTip('Nr.: ' & $num + 1 & ', x=' & $Pos[0] & ' / y=' & $Pos[1] & @CRLF & 'col=' & $col & @CRLF & 'Chksm: ' & $chksm & @CRLF & 'ChksmExt: ' & $chksmext, $Pos[0] + 50, $Pos[1] - 10)
		If _IsPressed('10', $dll) Then
			If _IsPressed('01', $dll) Then
				$num = $num + 1
				$Haus[$num][0] = $num
				$Haus[$num][1] = $Pos[0]
				$Haus[$num][2] = $Pos[1]
				$Haus[$num][3] = $col
				$Haus[$num][4] = $chksm
				$Haus[$num][5] = $chksmext
				FileWrite($save, $Haus[$num][0] & ',' & $Haus[$num][1] & ',' & $Haus[$num][2] & ',' & $Haus[$num][3] & ',' & $Haus[$num][4] & @CRLF)
				Sleep(100)
			EndIf
		EndIf
	WEnd
	FileClose($save)
	DllClose($dll)
EndFunc   ;==>erfassen
Func Laden()
	Local $Pos = MouseGetPos()
	Local $chksmext = PixelChecksum($Pos[0] + 15, $Pos[1] + 33, $Pos[0] + 31, $Pos[1] + 49)
	If Not _FileReadToArray(@ScriptDir & '\Geschäftsdaten.txt', $doc) Then
		Dim $nofile = 0
		MsgBox(4096, "Fehler", "Keine Koordinaten vorhanden.     error:" & @error)
	ElseIf _FileReadToArray(@ScriptDir & '\Geschäftsdaten.txt', $doc) Then
		$nofile = 1
	EndIf
	Sleep(100)
	If $nofile = 1 Then
		For $X = 1 To $doc[0]
			$datasplit = StringSplit($doc[$X], ',', 1)
			MouseMove($datasplit[2], $datasplit[3], 0)
			Sleep(600)
			MouseClick("left", $datasplit[2], $datasplit[3])
			Sleep(600)
		Next
	ElseIf $nofile = 0 Then
		Local $mbox = MsgBox(4, 'Geschäftskoordinaten', 'Wollen Sie die Koordinatenliste jetzt erstellen?')
		Select
			Case $mbox = 6
				;GUI()
				;ErfassenGUI()
			Case $mbox = 7
				;Exit
				Exit
		EndSelect
	EndIf
EndFunc   ;==>Laden
Func Miete()
	Local $Pos = MouseGetPos()
	Local $chksmext = PixelChecksum($Pos[0] + 15, $Pos[1] + 33, $Pos[0] + 31, $Pos[1] + 49)
	If Not _FileReadToArray(@ScriptDir & '\Häuserdaten.txt', $doc) Then
		Dim $nofile = 0
		MsgBox(4096, "Fehler", "Keine Koordinaten vorhanden.     error:" & @error)
	ElseIf _FileReadToArray(@ScriptDir & '\Häuserdaten.txt', $doc) Then
		$nofile = 1
	EndIf
	If $nofile = 1 Then
		For $X = 1 To $doc[0]
			$datasplit = StringSplit($doc[$X], ',', 1)
			MouseMove($datasplit[2], $datasplit[3], 0)
			Sleep(600)
			MouseClick("left", $datasplit[2], $datasplit[3])
			Sleep(600)
		Next
	ElseIf $nofile = 0 Then
		Local $mbox = MsgBox(4, 'Häuserkoordinaten', 'Wollen Sie die Koordinatenliste jetzt erstellen?')
		Select
			Case $mbox = 6
				;erfassen
			Case $mbox = 7
				;Exit
				Exit
		EndSelect
	EndIf
EndFunc   ;==>Miete
Func Vermieten()
	Local $Pos = MouseGetPos()
	Local $checksumVertrag = PixelChecksum(415, 315, 385, 285)
	Local $chksmext = PixelChecksum($Pos[0] + 15, $Pos[1] + 33, $Pos[0] + 31, $Pos[1] + 49)
	If Not _FileReadToArray(@ScriptDir & '\Häuserdaten.txt', $doc) Then
		Dim $nofile = 0
		MsgBox(4096, "Fehler", "Keine Koordinaten vorhanden.     error:" & @error)
	ElseIf _FileReadToArray(@ScriptDir & '\Häuserdaten.txt', $doc) Then
		$nofile = 1
	EndIf
	If $nofile = 1 Then
		For $X = 1 To $doc[0]
			$datasplit = StringSplit($doc[$X], ',', 1)
			MouseMove($datasplit[2], $datasplit[3], 1)
			Sleep(650)
			MouseClick("left", $datasplit[2], $datasplit[3])
			Sleep(650)
			MouseMove(397, 294, 1)
			Sleep(650)
			MouseClick("left", 397, 294)
			Sleep(350)
		Next
	ElseIf $nofile = 0 Then
		Local $mbox = MsgBox(4, 'Häuserkoordinaten', 'Wollen Sie die Koordinatenliste jetzt erstellen?')
		Select
			Case $mbox = 6
				;erfassen
			Case $mbox = 7
				;Exit
				Exit
		EndSelect
	EndIf
EndFunc   ;==>Vermieten
Func Einloggen()
	If BitAND($stateface, 1) Then
		$handle = WinGetHandle('Facebook')
		WinSetState($handle, "", @SW_MAXIMIZE)
		$face = 1
		$oIE = _IEAttach('Facebook')
		$hIE = _IEPropertyGet($oIE, "hwnd")
		WinSetState($hIE, "", @SW_MAXIMIZE)
		_IENavigate($oIE, $url, 1)
		WinActivate($oIE)
		_IELoadWait($oIE)
	ElseIf BitAND($statemill, 1) And $face = 0 Then
		$mill = 1
		$handle = WinGetHandle('Millionaire City auf Facebook')
		WinSetState($handle, "", @SW_MAXIMIZE)
		$oIE = _IEAttach('Facebook')
		$hIE = _IEPropertyGet($oIE, "hwnd")
		WinSetState($hIE, "", @SW_MAXIMIZE)
		WinActivate($oIE)
	ElseIf $mill = 0 Then
		$oIE = _IECreate($loginurl, 1, 1, 1, 1); $url, $f_tryAttach=0, $f_visible=1, $f_wait=1, $f_takeFocus=1
		$hIE = _IEPropertyGet($oIE, "hwnd")
		WinSetState($hIE, "", @SW_MAXIMIZE)
		_IELoadWait($oIE)
		$oInputs = _IETagNameGetCollection($oIE, "input")
		$oForm = _IEFormGetCollection($oIE, 0)
		$oUser = _IEGetObjByName($oIE, "email")
		$oPass = _IEGetObjByName($oIE, "pass")
		$oDiv = _IEGetObjById($oIE, "buttons")
		_IEFormElementSetValue($oUser, $sUser)
		_IEFormElementSetValue($oPass, $sPass)
		_IEFormSubmit($oForm)
		_IENavigate($oIE, $url)
		_IELoadWait($oIE)
		Sleep(500)
		_IELoadWait($oIE)
		;
		Sleep(5000)
		WinActivate("Millionaire City auf Facebook")
		WinWaitActive('Millionaire City auf Facebook')
		Sleep(500)
		MouseClick("left", 1010, 165, 1)
		MouseMove(1010, 256, 1)
		MouseDown("left")
		MouseMove(1010, 350, 20)
		MouseUp("left")
		MouseClick("left", 769, 500, 2, 5)
		MouseClick("left", 771, 530, 1)
		Sleep(300)
		MouseMove(737, 544, 1)
		Sleep(200)
		MouseDown("left")
		MouseMove(749, 408, 10)
		MouseUp("left")
		Sleep(250)
	EndIf
EndFunc   ;==>Einloggen
Func draw()
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
	_GDIPlus_GraphicsDrawLine($hGraphic, 50, 30 + $SliderLinksPos, 248, 30 + $SliderLinksPos, $hPen); oben
	_GDIPlus_GraphicsDrawLine($hGraphic, 50, 30 + $SliderRechtsPos, 248, 30 + $SliderRechtsPos, $hPen); unten
	_GDIPlus_GraphicsDrawLine($hGraphic, 50 + $SliderObenPos, 30, 50 + $SliderObenPos, 230, $hPen); links
	_GDIPlus_GraphicsDrawLine($hGraphic, 50 + $SliderUntenPos, 30, 50 + $SliderUntenPos, 230, $hPen); rechts
EndFunc   ;==>draw
Func Min($i, $j)
	If $i > $j Then Return $j
	Return $i
EndFunc   ;==>Min
Func _WinAPI_StretchBlt($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $iRop)
	; See _WinAPI_BitBlt
	Local $Ret = DllCall('gdi32.dll', 'int', 'StretchBlt', 'hwnd', $hDestDC, 'int', $iXDest, 'int', $iYDest, 'int', $iWidthDest, 'int', $iHeightDest, 'hwnd', $hSrcDC, 'int', $iXSrc, 'int', $iYSrc, 'int', $iWidthSrc, 'int', $iHeightSrc, 'dword', $iRop)
	If (@error) Or (Not IsArray($Ret)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_WinAPI_StretchBlt
Func Beenden()
	MsgBox(0, "Millionaire City Klicker", "Millionaire City Klicker wurde beendet!", 5)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>Beenden