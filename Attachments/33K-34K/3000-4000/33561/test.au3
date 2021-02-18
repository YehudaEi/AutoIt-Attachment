#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GDIPlus.au3>
#include <GuiSlider.au3>
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <Misc.au3>
#include <ScreenCapture.au3>
#include <SliderConstants.au3>
#include <Timers.au3>
#include <UpDownConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <GuiMenu.au3>
#include <ListViewConstants.au3>
;declare
Dim $Pos
Dim $msg[5]
Dim $PosOld[2]
Dim $aPosOld[2]
Dim $PosSlOld[4]
Dim $FileLines
Dim $List
Dim $pMGr = 10
Dim $Haus[255][10]
Dim $dll = DllOpen("user32.dll")
Local $iX, $iY, $iW, $iH, $Lupe, $copyLupe, $LupeGUI, $hChild, $hWnd_Desktop, $menu1, $winLupeState, $menuMode, $auswPixCksm
Local $countLR, $countHR, $coordLR, $coordHR, $iXo, $iYo, $hDC_Dest, $hDC_Source, $backbuffer, $X2, $Y2, $X, $Y, $AuswAuswColMitte
Local $Sl1ScaleMin, $Sl1ScaleMax, $Sl2ScaleMin, $Sl2ScaleMax, $SliderObenPos, $SliderUntenPos, $SliderLinksPos, $SliderRechtsPos
Global $doc, $Anmelden, $oIE, $loggedin, $WinStat, $FaceStat, $maxi, $run, $menuopen, $fileopen, $save, $AuswColMitte, $AuswChksm, $hIE
Local $menu1, $n1, $bErst, $bHinz, $bBearb, $msg, $menustate, $menutext, $hinz, $countl, $num, $Pos, $MausCol, $oInputs, $oForm
Local $oPass, $oUser, $oDiv, $count, $datfile, $DatenGUI, $handle, $datasplit, $mill, $face, $menuexit, $savdat

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
;Opt('MustDeclareVars', 1)
Opt("MouseClickDelay", 250)
Opt("GUIOnEventMode", 1)
;GUI
$LupeGUI = GUICreate("Main", 275, 600, -1, -1, $WS_MINIMIZEBOX + $WS_EX_LAYERED, $WS_EX_TOPMOST);$WS_MINIMIZEBOX + $WS_EX_LAYERED + $WS_SIZEBOX + $WS_SYSMENU, $WS_EX_TOPMOST)
GUISetOnEvent($GUI_EVENT_CLOSE, 'Beenden')
$menu1 = GUICtrlCreateMenu("File")
$menuData = GUICtrlCreateMenuItem("Daten", $menu1)
GUICtrlSetOnEvent($menuData, 'Beenden')
$menuexit = GUICtrlCreateMenuItem("Beenden", $menu1)
GUICtrlSetOnEvent($menuexit, 'Beenden')
$menu2 = GUICtrlCreateMenu('Einstellungen')
$menuVoreinstl = GUICtrlCreateMenu('Voreinstellungen', $menu2, 1)
$menuVoreinstlLaden = GUICtrlCreateMenuItem('Voreinstellungen laden', $menuVoreinstl)
$menuVoreinstlBearb = GUICtrlCreateMenuItem('Voreinstellungen bearbeiten', $menuVoreinstl)
$menuEinst = GUICtrlCreateMenuItem('Einstellungen', $menu2)
$menu4 = GUICtrlCreateMenu('User')
$mHaus = GUICtrlCreateMenuItem('Häuserdaten', $menu4)
$mLaden = GUICtrlCreateMenuItem('Geschäftsdaten', $menu4)
$mUser = GUICtrlCreateMenuItem('User', $menu4)
;~ GUICtrlSetOnEvent($mLaden, 'speichernunter')
;~ GUICtrlSetOnEvent($mHaus, 'speichernunter')
;~ GUICtrlSetOnEvent($mUser, 'speichernunter')
$SliderOben = GUICtrlCreateSlider(20, 0, 218, 32, 0, $TBS_NOTICKS)
$SliderUnten = GUICtrlCreateSlider(20, 226, 218, 32, BitOR($TBS_TOP, $TBS_LEFT, $TBS_NOTICKS))
$SliderLinks = GUICtrlCreateSlider(5, 17, 32, 218, $TBS_VERT, $TBS_NOTICKS)
$SliderRechts = GUICtrlCreateSlider(230, 17, 34, 218, BitOR($TBS_VERT, $TBS_NOTICKS, $TBS_TOP, $TBS_LEFT))
$Input1 = GUICtrlCreateInput("", 4, 440, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input2 = GUICtrlCreateInput("", 4, 460, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input3 = GUICtrlCreateInput("", 4, 480, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input5 = GUICtrlCreateInput("", 80, 280, 30, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input6 = GUICtrlCreateInput("", 80, 295, 30, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input7 = GUICtrlCreateInput("", 4, 335, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input8 = GUICtrlCreateInput("", 4, 355, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Input9 = GUICtrlCreateInput("", 137, 440, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input10 = GUICtrlCreateInput("", 137, 460, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input11 = GUICtrlCreateInput("", 137, 480, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input12 = GUICtrlCreateInput("", 4, 380, 200, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input13 = GUICtrlCreateInput("", 4, 400, 200, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input14 = GUICtrlCreateInput("", 137, 500, 130, 20, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Label1 = GUICtrlCreateLabel("Koordinaten:", 8, 423, 64, 17)
$Label2 = GUICtrlCreateLabel(' x - Achse = ', 20, 280, 48, 17)
$Label3 = GUICtrlCreateLabel(' y - Achse = ', 20, 295, 48, 17)
$Label5 = GUICtrlCreateLabel('Auswahl', 25, 319, 65, 15, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Label6 = GUICtrlCreateLabel('Lupe', 20, 262, 65, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY, $ES_RIGHT))
$Label7 = GUICtrlCreateLabel("Farbwerte:", 140, 423, 64, 17)
GUICtrlSetFont($Label1, 8, 400, 4, "MS Sans Serif")
GUICtrlSetFont($Label7, 8, 400, 4, "MS Sans Serif")
GUICtrlSetFont($Label5, 9, 800, 4, "MS Sans Serif")
GUICtrlSetFont($Label6, 9, 800, 4, "MS Sans Serif")
$Checkbox1 = GUICtrlCreateCheckbox(' fixieren (ALT + 1)', 137, 280, 130, 17, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_RIGHTBUTTON, $BS_MULTILINE, $BS_FLAT, $WS_TABSTOP, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
$Checkbox2 = GUICtrlCreateCheckbox(' Modi Switch (ALT + 2)', 137, 297, 130, 17, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_RIGHTBUTTON, $BS_MULTILINE, $BS_FLAT, $WS_TABSTOP, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
$Checkbox3 = GUICtrlCreateCheckbox(' + Pic save (ALT + 3)', 137, 314, 130, 17, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_RIGHTBUTTON, $BS_MULTILINE, $BS_FLAT, $WS_TABSTOP, $WS_CLIPSIBLINGS), $WS_EX_STATICEDGE)
$Button1 = GUICtrlCreateButton(" A ", 157, 337, 90, 20, BitOR($BS_CENTER, $WS_GROUP, $WS_BORDER))
$Button2 = GUICtrlCreateButton(" B ", 157, 359, 90, 20, BitOR($BS_CENTER, $WS_GROUP, $WS_BORDER))
GUICtrlSetOnEvent($Button1, 'Beenden')
GUICtrlSetOnEvent($Button2, 'Beenden')
$hPen = _GDIPlus_PenCreate()
;GUICtrlSetResizing ($LupeGUI, $GUI_DOCKAUTO)
GUISetState(@SW_SHOW, $LupeGUI)
GUICtrlSetLimit($SliderOben, ($dist * 2), 0)
GUICtrlSetData($SliderOben, 45)
GUICtrlSetLimit($SliderUnten, ($dist * 2), 0)
GUICtrlSetData($SliderUnten, 80)
GUICtrlSetLimit($SliderLinks, ($dist * 2), 0)
GUICtrlSetData($SliderLinks, 80)
GUICtrlSetLimit($SliderRechts, ($dist * 2), 0)
GUICtrlSetData($SliderRechts, 120)
GUICtrlSetData($menu4, 'Userdaten')
$save = FileOpen(@ScriptDir & '\User.txt', 2)
$datfile = @ScriptDir & '\User.txt'
$savdat = 'Userdaten'
$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)
;
$hLupe = GUICreate("", ($dist / 2), ($dist / 2), $Pos[0] + ($dist / 4), $Pos[1] + ($dist / 4), $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST, $WS_EX_STATICEDGE), $LupeGUI)
GUICtrlSetBkColor(GUICtrlCreateLabel("", 0, 0, ($dist / 2), ($dist / 2)), 0xFF0000)
GUICtrlSetBkColor(GUICtrlCreateLabel("", 2, 2, (($dist / 2) - $Border), (($dist / 2) - $Border)), 0xABCDEF)
GUISetState()
GUISwitch($LupeGUI)
;
_GDIPlus_Startup()
_WinAPI_SetLayeredWindowAttributes($hLupe, 0xABCDEF, 255)
$hWnd_Desktop = _WinAPI_GetDesktopWindow()
$hDC_Source = _WinAPI_GetDC($hWnd_Desktop)
$hDC_Dest = _WinAPI_GetDC($LupeGUI)
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($LupeGUI)
WinActivate('Main')

While 1;GUIGetMsg(1) <> $GUI_EVENT_CLOSE

	Sleep(10)
	$Pos = MouseGetPos()

	;Checkbox1 check ' fixieren'
	If _IsPressed('12', $dll) And _IsPressed('31', $dll) Then
		Sleep(50)
		If BitAND(GUICtrlRead($Checkbox1), $GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($Checkbox1, $GUI_UNCHECKED)
		ElseIf BitAND(GUICtrlRead($Checkbox1), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
			GUICtrlSetState($Checkbox1, $GUI_CHECKED)
		EndIf
	EndIf
	;wenn Checkbox1 'unchecked' löse Lupe von Maus
	If BitAND(GUICtrlRead($Checkbox1), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		;Mausposition abfragen
		;$Pos = MouseGetPos()
		; MausAuswahlposition abfragen
		$aWinPos = WinGetPos($hLupe)
		$iX = $aWinPos[0] ; x
		$iY = $aWinPos[1] ; y
		$iW = $aWinPos[2] ; width
		$iH = $aWinPos[3] ; height
		;InfoPost

		;Input Zeilen
		GUICtrlSetData($Input1, 'Maus:  x = ' & $Pos[0] & ' ,  y = ' & $Pos[1])
		GUICtrlSetData($Input2, 'Lupe:  x = ' & Round($iX, 0) & ' ,  y = ' & Round($iY, 0))
		GUICtrlSetData($Input3, 'Horiz.:  ' & $countLR & ' ,  Vert.:  ' & $countHR)

		;Wenn sich Mausposition ändert
		If $Pos[0] <> $PosOld[0] Or $Pos[1] <> $PosOld[1] Then
			WinMove($hLupe, "", $Pos[0] + ($dist / 4), $Pos[1] + ($dist / 4))
			$PosOld = $Pos
			$countLR = 0
			$countHR = 0
			GUICtrlSetData($Input5, $iX + ($iW / 2))
			GUICtrlSetData($Input6, $iY + ($iH / 2))
		EndIf
		;Wenn Bewegungstaste gedrückt
		If _IsPressed('25', $dll) And $iX > $Sl1ScaleMin Then ;links gedrückt
			$countLR = $countLR + (-1)
			WinMove($hLupe, "", $iX - $Scale, $iY)
			GUICtrlSetData($Input5, $iX + ($iW / 2))
			_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
		ElseIf _IsPressed('27', $dll) And ($iX + $iW) < $Sl1ScaleMax Then ;rechts gedrückt
			$countLR = $countLR + 1
			WinMove($hLupe, "", $iX + $Scale, $iY)
			GUICtrlSetData($Input5, $iX + ($iW / 2))
			_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
		ElseIf _IsPressed('26', $dll) And $iY > $Sl2ScaleMin Then ;hoch gedrückt
			$countHR = $countHR + (-1)
			WinMove($hLupe, "", $iX, $iY - $Scale)
			GUICtrlSetData($Input6, $iY + ($iH / 2))
			_WinAPI_RedrawWindow(_WinAPI_GetDesktopWindow(), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
		ElseIf _IsPressed('28', $dll) And ($iY + $iH) < $Sl2ScaleMax Then ;runter gedrückt
			$countHR = $countHR + 1
			WinMove($hLupe, "", $iX, $iY + $Scale)
			GUICtrlSetData($Input6, $iY + ($iH / 2))
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
	;
	;Checkbox2 check ' Modi Switch'
	If _IsPressed('12', $dll) And _IsPressed('32', $dll) Then
		Sleep(50)
		If BitAND(GUICtrlRead($Checkbox2), $GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($Checkbox2, $GUI_UNCHECKED)
		ElseIf BitAND(GUICtrlRead($Checkbox2), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
			GUICtrlSetState($Checkbox2, $GUI_CHECKED)
		EndIf
	EndIf
	If BitAND(GUICtrlRead($Checkbox2), $GUI_CHECKED) = $GUI_CHECKED And $menuMode = 0 Then
		$menuMode = 1
		WinSetState($hLupe, '', @SW_HIDE)
		GUISetState(@SW_MINIMIZE, $LupeGUI)
		ToolTip('')
		;maximieren()
	ElseIf BitAND(GUICtrlRead($Checkbox2), $GUI_UNCHECKED) = $GUI_UNCHECKED And $menuMode = 1 Then
		$menuMode = 0
		WinSetState($hLupe, '', @SW_SHOW)
		GUISetState(@SW_RESTORE, $LupeGUI)
		ToolTip('')
	EndIf


	;Checkbox3 check ' + Pic Save'
	If _IsPressed('12', $dll) And _IsPressed('33', $dll) Then
		Sleep(50)
		If BitAND(GUICtrlRead($Checkbox3), $GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($Checkbox3, $GUI_UNCHECKED)
		ElseIf BitAND(GUICtrlRead($Checkbox3), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
			GUICtrlSetState($Checkbox3, $GUI_CHECKED)
		EndIf
	EndIf
	If BitAND(GUICtrlRead($Checkbox3), $GUI_CHECKED) = $GUI_CHECKED Then
		$PicSave = 1
	ElseIf BitAND(GUICtrlRead($Checkbox3), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		$PicSave = 0
	EndIf

	If $menuMode = 0 And BitAND(WinGetState($LupeGUI), 2) = 2 Then
		If BitAND(WinGetState($LupeGUI), 16) = 16 Then
			ToolTip('')
		ElseIf BitAND(WinGetState($LupeGUI), 1) = 1 Then
			ToolTip((Round($aWinPos[0] + ($aWinPos[2] / 2), 0)) & ', ' & Round(($aWinPos[1] + ($aWinPos[3] / 2)), 0), $iX, $iY + $iH)
		EndIf
		If $SliderLinksPos > $SliderRechtsPos Then
			$Ya = $SliderRechtsPos
			$Yb = $SliderLinksPos
			$Y = $Ya + $iY
			$height = Abs($Yb - $Ya)
			$Y2 = $Y + $height
		Else
			$Ya = $SliderLinksPos
			$Yb = $SliderRechtsPos
			$Y = $Ya + $iY
			$height = Abs($Yb - $Ya)
			$Y2 = $Y + $height
		EndIf
		If $SliderObenPos > $SliderUntenPos Then
			$Xa = $SliderUntenPos
			$Xb = $SliderObenPos
			$X = $Xa + $iX
			$width = Abs($Xb - $Xa)
			$X2 = $X + $width
		Else
			$Xa = $SliderObenPos
			$Xb = $SliderUntenPos
			$X = $Xa + $iX
			$width = Abs($Xb - $Xa)
			$X2 = $X + $width
		EndIf

	ElseIf $menuMode = 1 Then ;ToolTip
		ToolTip('Datensatz: ' & $savdat & @CRLF & 'Nr.: ' & $num + 1 & ', x=' & $Pos[0] & ' / y=' & $Pos[1] & @CRLF & 'col=' & $MausCol & @CRLF & 'MitteLupe.: ' & $AuswColMitte & @CRLF & 'MitteAusw.: ' & $AuswAuswColMitte & @CRLF & 'AuswChksm: ' & $auswPixCksm, $Pos[0] + 50, $Pos[1] - 10)
	EndIf

	;Fenster Animation 'Zusammenhang sichern'
	If WinGetState($LupeGUI) = 16 And WinGetState($hLupe) = 2 And $winLupeState = 1 Then
		$winLupeState = 0
		GUISetState(@SW_HIDE, $hLupe)
		WinSetState($hLupe, '', @SW_HIDE)
	ElseIf WinGetState($LupeGUI) = 3 And WinGetState($hLupe) <> 2 Then
		$winLupeState = 1
		GUISetState(@SW_SHOW, $hLupe)
		WinSetState($hLupe, '', @SW_SHOW)
	EndIf
	If _IsPressed('10', $dll) And _IsPressed('01', $dll) Then
		;If _IsPressed('01', $dll) Then
		$num = $num + 1
		$Haus[$num][0] = $num ;Position
		$Haus[$num][1] = $Pos[0] ;x-Pos
		$Haus[$num][2] = $Pos[1] ;y-Pos
		$Haus[$num][3] = $MausCol ;Mouse PixColor
		$Haus[$num][4] = $AuswColMitte ;Lupe Mitte Color (!)
		$Haus[$num][5] = $auswPixCksm ;Auswahl Mitte Color
;~ 		$Haus[$num][6] = ($iX + $X) ;x oben
;~ 		$Haus[$num][7] = ($iY + $Y) ;y oben
;~ 		$Haus[$num][8] = ($iX + $X + $w1) ;x unten
;~ 		$Haus[$num][9] = ($iY + $Y + $h1) ;y unten
		;Bild speichern?
;~ 		If $PicSave = 1 Then
;~ 			$sDir = 'C:\Dokumente und Einstellungen\Besitzer\Desktop\' & StringFormat('%s.%s.%s\%s', @MDAY, @MON, @YEAR, $num)
;~ 			DirCreate($sDir)
;~ 			$sFile1 = $sDir & "\mColors.txt"
;~ 			$sFile2 = $sDir & "\aColors.txt"
;~ 			$hFile1 = FileOpen($sFile1, 1) ; 1 = append (anhängen)
;~ 			$hFile2 = FileOpen($sFile2, 1) ; 1 = append (anhängen)
;~ 			$hBMP = _ScreenCapture_Capture($sDir & '\Lupe.jpg', $iX, $iY, $iX + $iW, $iY + $iH)
;~ 			$hBMP2 = _ScreenCapture_Capture($sDir & '\Auswahl.jpg', $iX + $X - 2, $iY + $Y - 2, $iX + $X + $w1, $iY + $Y + $h1)
;~ 			$hBMPm = _ScreenCapture_Capture($sDir & '\Maus.jpg', $Pos[0] - $pMGr, $Pos[1] - $pMGr, $Pos[0] + $pMGr, $Pos[1] + $pMGr)
;~ 			_ScreenCapture_SaveImage($sDir & '\Lupe.jpg', $hBMP)
;~ 			_ScreenCapture_SaveImage($sDir & '\Auswahl.jpg', $hBMP2)
;~ 			_ScreenCapture_SaveImage($sDir & '\Maus.jpg', $hBMPm)
;~ 			$colors_A = _getPixelColors($Pos[0] - 10, $Pos[1] - 10, $Pos[0] + 10, $Pos[1] + 10, $hFile1)
;~ 			$colors_B = _getPixelColors($iX + $X, $iY + $Y, $iX + $X + $w1, $iY + $Y + $h1, $hFile2)
;~ 		EndIf
		;Daten speichern
		FileWrite($save, $Haus[$num][0] & ',' & $Haus[$num][1] & ',' & $Haus[$num][2] & ',' & $Haus[$num][3] & ',' & $Haus[$num][4] & ',' & $Haus[$num][5] & ',' & $Haus[$num][6] & ',' & $Haus[$num][7] & ',' & $Haus[$num][8] & ',' & $Haus[$num][9] & @CRLF)
		Sleep(100)
		;EndIf
	EndIf
	$MausCol = PixelGetColor($Pos[0], $Pos[1])
	$AuswColMitte = PixelGetColor(Round($iX + ($iW / 2), 0), Round($iY + ($iH / 2), 0))
	$AuswAuswColMitte = PixelGetColor($iX + $Xa + Abs($Xa - $Xb), $iY + $Ya + Abs($Ya - $Yb))
	$auswPixCksm = PixelChecksum(($iX + $X), ($iY + $Y), ($iX + $X) + Abs($SliderLinksPos - $SliderRechtsPos), ($iY + $Y) + Abs($SliderObenPos - $SliderUntenPos)) ;Auswahlrechteck x1,y1,x2,y2

	GUICtrlSetData($Input9, 'Maus: ' & PixelGetColor($Pos[0], $Pos[1]))
	GUICtrlSetData($Input10, 'AuswahlMitte: ' & PixelGetColor($iX + ($iW / 2), $iY + ($iH / 2)))
	GUICtrlSetData($Input11, 'AAuswMitte: ' & $AuswAuswColMitte)
	GUICtrlSetData($Input14, 'AuswChksm: ' & $auswPixCksm)
	GUICtrlSetData($Input7, ' x = ' & Round($iX + ($Xa / 2), 0) & ', y = ' & Round($iY + ($Ya / 2), 0))
	GUICtrlSetData($Input8, 'Breite = ' & $width & ', Höhe = ' & $height)
	GUICtrlSetData($Input12, 'SlOben = ' & $SliderObenPos & ', SlUnten = ' & $SliderUntenPos & ', Diff: ' & Abs($SliderObenPos - $SliderUntenPos))
	GUICtrlSetData($Input13, 'SlLinks = ' & $SliderLinksPos & ', SlRechts = ' & $SliderRechtsPos & ', Diff: ' & Abs($SliderLinksPos - $SliderRechtsPos))
WEnd

Func draw()
	; Bild per StretchBlt übertragen
	$Lupe = _WinAPI_StretchBlt( _
			$hDC_Dest, 32, 30, 192, 192, _
			$hDC_Source, $iX, $iY, $iW, $iH, _
			$SRCCOPY)
	;Auswahl 'Auswahlslider'
	$SliderObenPos = _GUICtrlSlider_GetPos($SliderOben)
	$SliderUntenPos = _GUICtrlSlider_GetPos($SliderUnten)
	$SliderLinksPos = _GUICtrlSlider_GetPos($SliderLinks)
	$SliderRechtsPos = _GUICtrlSlider_GetPos($SliderRechts)
	;Auswahl zeichnen
	_GDIPlus_GraphicsDrawLine($hGraphic, 32, 30 + $SliderLinksPos, 222, 30 + $SliderLinksPos, $hPen); oben
	_GDIPlus_GraphicsDrawLine($hGraphic, 32, 30 + $SliderRechtsPos, 222, 30 + $SliderRechtsPos, $hPen); unten
	_GDIPlus_GraphicsDrawLine($hGraphic, 32 + $SliderObenPos, 30, 32 + $SliderObenPos, 220, $hPen); links
	_GDIPlus_GraphicsDrawLine($hGraphic, 32 + $SliderUntenPos, 30, 32 + $SliderUntenPos, 220, $hPen); rechts
EndFunc   ;==>draw

Func _WinAPI_StretchBlt($hDestDC, $iXDest, $iYDest, $iWidthDest, $iHeightDest, $hSrcDC, $iXSrc, $iYSrc, $iWidthSrc, $iHeightSrc, $iRop)
	Local $Ret = DllCall('gdi32.dll', 'int', 'StretchBlt', 'hwnd', $hDestDC, 'int', $iXDest, 'int', $iYDest, 'int', $iWidthDest, 'int', $iHeightDest, 'hwnd', $hSrcDC, 'int', $iXSrc, 'int', $iYSrc, 'int', $iWidthSrc, 'int', $iHeightSrc, 'dword', $iRop)
	If (@error) Or (Not IsArray($Ret)) Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_WinAPI_StretchBlt

Func SpecialEvents()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE, $DatenGUI)
			GUISetState(@SW_SHOW, $LupeGUI)
			WinSetState($hLupe, '', @SW_SHOW)
		Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
			;MsgBox(0, "Fenster minimiert", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
		Case @GUI_CtrlId = $GUI_EVENT_RESTORE
			;MsgBox(0, "Fenster wiederhergestellt", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
	EndSelect
EndFunc   ;==>SpecialEvents
Func schliessen()
	GUISetState(@SW_HIDE, $DatenGUI)
	GUISetState(@SW_SHOW, $LupeGUI)
	WinSetState($hLupe, '', @SW_SHOW)
EndFunc   ;==>schliessen
Func Beenden()
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	FileClose($save)
	DllClose($dll)
	Exit
EndFunc   ;==>Beenden
Func _getPixelColors($start_X, $start_Y, $end_X, $end_Y, $File)
	Local $coord[$end_X - $start_X][$end_Y - $start_Y]
	For $X = 0 To UBound($coord, 1) - 1
		For $Y = 0 To UBound($coord, 2) - 1
			$coord[$X][$Y] = PixelGetColor($X + $start_X, $Y + $start_Y)
			FileWrite($File, $X & ',' & $Y & ',' & $coord[$X][$Y] & @CRLF)
		Next
	Next
	Return $coord
EndFunc   ;==>_getPixelColors
