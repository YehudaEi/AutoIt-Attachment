#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <ScreenCapture.au3>
#include <GDIPlus.au3>
;=====================================================
; Script name:	FIFTEEN GAME
; Author: 		Mihai Iancu (taietel)
; Version: 		2.0
; Changes:		- Change numbers with image (my first attempt with GDI+)
;				- Save configuration (width/height/rows/columns/image)
;				- Reset game
;				- Fixed the shuffle algorithm to make the game always solvable (
;				- Name changed
; Thanks to:	- enaiman and JohnOne for the suggestion regarding the shuffle algorithm
;				- MrCreatoR for the game name
;				- UEZ for infecting me with the GDI+ bacteria :)
; Last rev.		Jan 20, 2011
;=====================================================
Opt("GUIOnEventMode", 1)
#region GLOBAL VARIABLES
Global $sINI = @ScriptDir & "\fifteen.cfg"
If Not FileExists($sINI) Then _WriteConfig($sINI)
Global $aINI = _ReadConfig($sINI)
Global $hGUI, $w, $h, $iGap = 2, $iLeft = 5, $iTop = 30
Global $Grid[$aINI[2]][$aINI[3]][3]
Global $hBtns[5], $aMenu[12], $hRows, $hCols, $hSbr
Global $iCounter = 0, $bShuf = False
#endregion GLOBAL VARIABLES
_GUI_Interface()

While 1
	Sleep(100)
WEnd

Func _About()
	Local $sRet = DllCall("shell32.dll", "long", "ShellAboutA", "ptr", $hGUI, "str", "AutoIt Fifteen Game", "str", "Mihai Iancu © 1973-" & @YEAR, "long", 0)
	If @error Then SetError(1, 0, 0)
	Return $sRet
EndFunc   ;==>_About

Func _CheckStatus()
	Local $sStatus
	For $i = 0 To $aINI[2] - 1
		For $j = 0 To $aINI[3] - 1
			If $Grid[$i][$j][1] = 0 Then
				If $Grid[$i][$j][2] = 0 Then
					$sStatus &= "0"
				EndIf
			EndIf
		Next
	Next
	If $bShuf = True Then
		If $iCounter > 10 Then
			If StringLen($sStatus) = $aINI[2] * $aINI[3] Then
				If StringReplace($sStatus, "0", "") = "" Then
					Local $play = MsgBox(4 + 64, "Congratulation!", "We have a winner with " & $iCounter & " moves." & @CRLF & "Play again?")
					Switch $play
						Case 6
							_ShuffleTiles()
						Case 7
							Return
					EndSwitch
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_CheckStatus

Func _CreateTiles($sImage = "")
	;my first attempt with GDI+
	Local $bNumbers = False, $tLayout[$aINI[2] * $aINI[3]], $hImage, $hClone[$aINI[2] * $aINI[3]]
	If $sImage = "" Then
		$bNumbers = True
	Else
		$bNumbers = False
	EndIf
	;here we go...
	_GDIPlus_Startup()
	If $bNumbers = True Then
		$hImage1 = _ScreenCapture_Capture("", 0, 0, $aINI[0], $aINI[1]) ; something to work on
		$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hImage1) ; get the bmp handle
		$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage) ; get the graphic context
		$hBrush1 = _GDIPlus_BrushCreateSolid(0xFF809880) ; create some brushes for the fonts/background
		$hBrush2 = _GDIPlus_BrushCreateSolid(0xFFFFFF00)
		_GDIPlus_GraphicsFillRect($hGraphic, 0, 0, $aINI[0], $aINI[1], $hBrush1)
		$hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFF1)
		$hFamily = _GDIPlus_FontFamilyCreate("Arial") ; create font
		$hFont = _GDIPlus_FontCreate($hFamily, _Iif($w <= $h, Int($w / 1.8), Int($h / 1.8)), 1, 2) ; and resize it according to the tile w/h
		$hFormat = _GDIPlus_StringFormatCreate()
		_GDIPlus_StringFormatSetAlign($hFormat, 1) ; align text to center
		For $i = 0 To $aINI[2] - 1
			For $j = 0 To $aINI[3] - 1 ; create global image
				$tLayout[$j + $i * $aINI[3]] = _GDIPlus_RectFCreate($j * $w, $i * $h + Int(_Iif($w <= $h, $w, $h) / 5), $w, $h) ; create rectangle
				_GDIPlus_GraphicsSetSmoothingMode($hGraphic, 1)
				If $i = 0 And $j = 0 Then
					_GDIPlus_GraphicsDrawStringEx($hGraphic, "X", $hFont, $tLayout[$j + $i * $aINI[3]], $hFormat, $hBrush2) ; fill the X mark
				Else
					_GDIPlus_GraphicsDrawStringEx($hGraphic, $j + $i * $aINI[3], $hFont, $tLayout[$j + $i * $aINI[3]], $hFormat, $hBrush);	and the numbers
				EndIf
				$hClone[$j + $i * $aINI[3]] = _GDIPlus_BitmapCloneArea($hImage, $j * $w, $i * $h, $w, $h, $GDIP_PXF24RGB) ; "cut" each tile from the global image
				_GDIPlus_ImageSaveToFile($hClone[$j + $i * $aINI[3]], @TempDir & "\Tile_" & $j + $i * $aINI[3] & ".jpg") ; and save it
				_GDIPlus_BitmapDispose($hClone[$j + $i * $aINI[3]]) ; then clean up
			Next
		Next
		_GDIPlus_FontDispose($hFont);
		_GDIPlus_FontFamilyDispose($hFamily);
		_GDIPlus_StringFormatDispose($hFormat);
		_GDIPlus_BrushDispose($hBrush);
		_GDIPlus_BrushDispose($hBrush1);
		_GDIPlus_BrushDispose($hBrush2);
		_GDIPlus_GraphicsDispose($hGraphic);
	Else
		$hImage = _GDIPlus_BitmapCreateFromFile($sImage) ; load the image
		$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
		Local $iiW = _GDIPlus_ImageGetWidth($hImage) ; get w/h
		Local $iiH = _GDIPlus_ImageGetHeight($hImage)
		Local $wi = Int($iiW / $aINI[3])
		Local $hi = Int($iiH / $aINI[2])
		Local $hMatrix = _GDIPlus_MatrixCreate() ; create a matrix
		Local $xRatio = Round($w / $wi, 1)
		Local $yRatio = Round($h / $hi, 1)

		_GDIPlus_MatrixScale($hMatrix, $xRatio, $yRatio) ;scale image to grid size
		_GDIPlus_GraphicsSetTransform($hGraphic, $hMatrix)
		For $i = 0 To $aINI[2] - 1
			For $j = 0 To $aINI[3] - 1
				If $i <> 0 Or $j <> 0 Then
					$hClone[$j + $i * $aINI[3]] = _GDIPlus_BitmapCloneArea($hImage, $j * $wi, $i * $hi, $wi, $hi, $GDIP_PXF24RGB)
					_GDIPlus_ImageSaveToFile($hClone[$j + $i * $aINI[3]], @TempDir & "\Tile_" & $j + $i * $aINI[3] & ".jpg")
					_GDIPlus_BitmapDispose($hClone[$j + $i * $aINI[3]])
				EndIf
			Next
		Next
		_GDIPlus_MatrixDispose($hMatrix)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_ImageDispose($hImage)
	EndIf
	_GDIPlus_Shutdown()
	For $i = 0 To $aINI[2] - 1
		For $j = 0 To $aINI[3] - 1
			GUICtrlSetImage($Grid[$i][$j][0], @TempDir & "\Tile_" & $j + $i * $aINI[3] & ".jpg")
		Next
	Next
EndFunc   ;==>_CreateTiles

Func _DeleteTempTiles()
	For $i = 0 To $aINI[2] - 1
		For $j = 0 To $aINI[3] - 1
			FileDelete(@TempDir & "\Tile_" & $j + $i * $aINI[3] & ".jpg")
		Next
	Next
EndFunc   ;==>_DeleteTempTiles

Func _Exit()
	_DeleteTempTiles()
	Exit
EndFunc   ;==>_Exit

Func _Grid($iLeft, $iTop, $iRight = "", $iBottom = "")
	If $iBottom = "" Then $iBottom = $iTop
	If $iRight = "" Then $iRight = $iLeft
	$w = Int(($aINI[0] - $iLeft - $iRight - ($aINI[3] - 1) * $iGap) / $aINI[3])
	$h = Int(($aINI[1] - $iTop - $iBottom - ($aINI[2] - 1) * $iGap) / $aINI[2])
	For $i = 0 To $aINI[2] - 1
		For $j = 0 To $aINI[3] - 1
			$Grid[$i][$j][0] = GUICtrlCreatePic("", $iLeft + $j * ($w + $iGap), $iTop + $i * ($h + $iGap), $w, $h, BitOR($GUI_SS_DEFAULT_PIC, $SS_CENTERIMAGE), $WS_EX_STATICEDGE)
			$Grid[$i][$j][1] = 0
			$Grid[$i][$j][2] = 0
			If BitOR($i <> 0, $j <> 0) Then
				GUICtrlSetOnEvent($Grid[$i][$j][0], "_Tile_Click")
				GUICtrlSetCursor(-1, 0)
			EndIf
		Next
	Next
	_CreateTiles($aINI[4])
EndFunc   ;==>_Grid

Func _GUI_Interface()
	$hGUI = GUICreate("AutoIT Puzle Game", $aINI[0], $aINI[1], -1, -1, BitOR($WS_POPUP, $WS_BORDER))
	GUISetBkColor(0x203220)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	GUICtrlCreateLabel(StringUpper("fifteen game"), 8, 6, $aINI[0] - 199, 16, BitOR($SS_CENTER, $SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	GUICtrlSetColor(-1, 0xFFEE00)
	GUICtrlCreateLabel("Grid:", $aINI[0] - 186, 6, 24, 16, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, 8, 800, 0)
	GUICtrlSetColor(-1, 0xFEFECC)
	$hRows = GUICtrlCreateInput("", $aINI[0] - 160, 5, 25, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), 0)
	GUICtrlSetData(-1, $aINI[2])
	GUICtrlSetTip(-1, "Enter number of rows", "Info:", 1)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x880000)
	GUICtrlSetBkColor(-1, 0xdddd33)
	GUICtrlCreateLabel("x", $aINI[0] - 133, 5, 16, 16, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetFont(-1, 8, 800, 0)
	GUICtrlSetColor(-1, 0xFEFECC)
	$hCols = GUICtrlCreateInput("", $aINI[0] - 125, 5, 25, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $WS_BORDER), 0)
	GUICtrlSetData(-1, $aINI[3])
	GUICtrlSetTip(-1, "Enter number of columns", "Info:", 1)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, 0x880000)
	GUICtrlSetBkColor(-1, 0xdddd33)
	$hBtns[0] = GUICtrlCreateIcon("shell32.dll", -28, $aINI[0] - 22, 6, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "I had enough!...", "Info:", 1)
	GUICtrlSetOnEvent(-1, "_Exit")
	$hBtns[1] = GUICtrlCreateIcon("shell32.dll", -222, $aINI[0] - 42, 6, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "About...", "Info:", 1)
	GUICtrlSetOnEvent(-1, "_About")
	$hBtns[2] = GUICtrlCreateIcon("shell32.dll", -44, $aINI[0] - 98, 5, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Change the grid!", "Info:", 1)
	GUICtrlSetOnEvent(-1, "_ResetGrid")
	GUICtrlSetState(-1, $GUI_FOCUS)
	$hBtns[3] = GUICtrlCreateIcon("shell32.dll", -147, $aINI[0] - 82, 6, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Shuffle the tiles", "Info:", 1)
	GUICtrlSetOnEvent(-1, "_ShuffleTiles")
	$hBtns[4] = GUICtrlCreateIcon("shell32.dll", -5, $aINI[0] - 62, 6, 16, 16)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, "Open image...", "Info:", 1)
	GUICtrlSetOnEvent(-1, "_OpenImage")
	_Grid($iLeft, $iTop)
	$hSbr = GUICtrlCreateLabel("", 5, $aINI[1] - 24, $aINI[0] - 10, 20, $SS_CENTERIMAGE, BitOR($WS_EX_STATICEDGE, $GUI_WS_EX_PARENTDRAG))
	_Status("If you want to play, shuffle first...")
	GUICtrlSetColor($hSbr, 0xefefef)
	GUISetState(@SW_SHOW)
EndFunc   ;==>_GUI_Interface

Func _MoveTile($hControl)
	Local $p0, $p1, $bMoved = False
	$p0 = ControlGetPos($hGUI, "", $Grid[0][0][0])
	$p1 = ControlGetPos($hGUI, "", $hControl)
	If (Abs($p1[0] - $p0[0]) = $p0[2] + $iGap And $p1[1] = $p0[1]) Or ($p1[0] = $p0[0] And Abs($p1[1] - $p0[1]) = $p0[3] + $iGap) Then
		ControlMove($hGUI, "", $hControl, $p0[0], $p0[1])
		ControlMove($hGUI, "", $Grid[0][0][0], $p1[0], $p1[1])
		For $i = 0 To $aINI[2] - 1
			For $j = 0 To $aINI[3] - 1
				If $hControl = $Grid[$i][$j][0] Then
					Select
						Case $p1[0] < $p0[0] And $p1[1] = $p0[1]
							$Grid[$i][$j][1] -= 1
						Case $p1[0] > $p0[0] And $p1[1] = $p0[1]
							$Grid[$i][$j][1] += 1
						Case $p1[0] = $p0[0] And $p1[1] < $p0[1]
							$Grid[$i][$j][2] += 1
						Case $p1[0] = $p0[0] And $p1[1] > $p0[1]
							$Grid[$i][$j][2] -= 1
					EndSelect
				EndIf
			Next
		Next
		$iCounter += 1
		$bMoved = True
	EndIf
	_Status("Moves:" & @TAB & $iCounter)
	Return $bMoved
EndFunc   ;==>_MoveTile

Func _OpenImage()
	Local $sFsr = FileOpenDialog("Alegeti o imagine pentru sigla. Daca nu aveti inca o sigla, voi folosi sigla MECTS.", @ScriptDir & "\", "Imagine (*.jpg;*.bmp;*.gif)", 1)
	If @error Then
		$aINI[4] = ""
	Else
		$aINI[4] = $sFsr
	EndIf
	IniWrite($sINI, "FifteenConfig", "Image", $sFsr)
	_CreateTiles($aINI[4])
	Return $sFsr
EndFunc   ;==>_OpenImage

Func _ReadConfig($sINI)
	Local $aCfg[5]
	$aCfg[0] = IniRead($sINI, "FifteenConfig", "Width", 350)
	$aCfg[1] = IniRead($sINI, "FifteenConfig", "Height", 350)
	$aCfg[2] = IniRead($sINI, "FifteenConfig", "Rows", 4)
	$aCfg[3] = IniRead($sINI, "FifteenConfig", "Columns", 4)
	$aCfg[4] = IniRead($sINI, "FifteenConfig", "Image", "")
	Return $aCfg
EndFunc   ;==>_ReadConfig

Func _ResetGrid()
	_SaveConfig($sINI)
	GUIDelete($hGUI)
	$aINI = _ReadConfig($sINI)
	ReDim $Grid[$aINI[2]][$aINI[3]][3]
	_GUI_Interface()
EndFunc   ;==>_ResetGrid

Func _SaveConfig($sINI)
	IniWrite($sINI, "FifteenConfig", "Rows", GUICtrlRead($hRows))
	IniWrite($sINI, "FifteenConfig", "Columns", GUICtrlRead($hCols))
EndFunc   ;==>_SaveConfig

Func _ShuffleTiles()
	WinSetTrans($hGUI, "", 50)
	Local $pi = ControlGetPos($hGUI, "", $Grid[0][0][0]), $pf[2]
	Local $iMoves = 0
	Local $aArray[$aINI[2] * $aINI[3]]
	For $i = 0 To $aINI[2] - 1
		For $j = 0 To $aINI[3] - 1
			$aArray[$j + $i * $aINI[3]] = $Grid[$i][$j][0]
		Next
	Next
	While $iMoves <= Random(500, 1000, 1)
		Local $iRand = Random(0, $aINI[2] * $aINI[3] - 1, 1)
		Local $Moved = _MoveTile($aArray[$iRand])
		Local $pf = ControlGetPos($hGUI, "", $Grid[0][0][0])
		If $iRand <> $aINI[2] * $aINI[3] - 1 And BitOR($pf[0] <> 0, $pf[1] <> 0) Then $iMoves += 1
	WEnd
	WinSetTrans($hGUI, "", 255)
	$iCounter = 0
	$bShuf = True
EndFunc   ;==>_ShuffleTiles

Func _Status($sText)
	GUICtrlSetData($hSbr, "  " & $sText)
EndFunc   ;==>_Status
Func _Tile_Click()
	If $bShuf = False Then Return
	Switch @GUI_CtrlId
		Case $Grid[0][0][0]
			;do nothing
		Case Else
			_MoveTile(@GUI_CtrlId)
			_WinAPI_RedrawWindow($hGUI)
	EndSwitch
	_CheckStatus()
EndFunc   ;==>_Tile_Click

Func _WriteConfig($sINI)
	IniWrite($sINI, "FifteenConfig", "Width", "350")
	IniWrite($sINI, "FifteenConfig", "Height", "380")
	IniWrite($sINI, "FifteenConfig", "Rows", 4)
	IniWrite($sINI, "FifteenConfig", "Columns", 4)
	IniWrite($sINI, "FifteenConfig", "Image", "")
EndFunc   ;==>_WriteConfig