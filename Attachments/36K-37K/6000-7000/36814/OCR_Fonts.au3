#include <Array.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <Fontconstants.au3>
#include <GDIPlus.au3>
#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListviewConstants.au3>
#include <ProgressConstants.au3>
;#include <RegFunc.au3>
#include <StaticConstants.au3>
#include <UpDownConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("PixelCoordMode", 0)
;Data
$dString = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,ä,ö,ü,1,2,3,4,5,6,7,8,9,0'
$aString = StringSplit($dString, ',')
Local $data[3][$aString[0] + 1]
Local $rLinks, $rRechts, $rOben, $rUnten, $rWidth, $rHeight
Local $aCoords1[100][100]
Local $aCoords2[100][100]
Local $aARect[1][5]

For $i = 1 To $aString[0]
	$data[0][$i] = $i
	$data[1][$i] = StringUpper($aString[$i])
	$data[2][$i] = StringLower($aString[$i])
Next
$cDataCount = 1 ;Letter Stellenzähler
$data[0][0] = (UBound($data, 2) - 1)

;Fonts
$FontList = _FileListToArray(@WindowsDir & '\Fonts', '*.ttf', 1);Schriftarten aus Windows Fonts Ordner holen
$var = _GetRegValues('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts');Schriftartennamen aus Windows Registry holen
Dim $aItems[($FontList[0] + 1)]
$x = 1
$sgrA = 50

#region ### START Koda GUI section ### Form=C:\Users\IBM\Desktop\AU3_OCR_new\Form1.kxf
$msg = GUICreate("Form1", 680, 245, 215, 124)
$Datei = GUICtrlCreateMenu("&Datei")
$MenuItem1 = GUICtrlCreateMenuItem("Optionen" & @TAB & "", $Datei)
$MenuItem2 = GUICtrlCreateMenuItem("Exit" & @TAB & "", $Datei)
$Hilfe = GUICtrlCreateMenu("&Hilfe")
$lLabel = GUICtrlCreateLabel('Speichern', 264, 10, 60, 20)
$lLabel2 = GUICtrlCreateLabel('Input:', 277, 66, 60, 20)
$listview = GUICtrlCreateListView("Nr.|Datei|Name", 337, 25, 335, 157)
GUICtrlCreateLabel('Suchen: ', 480, 4, 60, 20)
$sSuche = GUICtrlCreateInput('', 526, 1, 110, 20)
$iInput = GUICtrlCreateEdit('', 269, 83, 50, 50, BitOR($ES_CENTER, $ES_WANTRETURN, $WS_BORDER))

_GDIPlus_Startup()
Global $gWin1 = GUICtrlCreatePic('', 10, 32, 100, 100, $SS_SUNKEN)
Global $gWin2 = GUICtrlCreatePic('', 151, 32, 100, 100, $SS_SUNKEN)
Global $hPic1 = GUICtrlGetHandle($gWin1)
Global $hPic2 = GUICtrlGetHandle($gWin2)
Global $hGfx1 = _GDIPlus_GraphicsCreateFromHWND($hPic1)
Global $hGfx2 = _GDIPlus_GraphicsCreateFromHWND($hPic2)
$hPen = _GDIPlus_PenCreate(0xFF000000)

Global $hBrush = _GDIPlus_BrushCreateSolid(0xFF000000)

GUICtrlCreateLabel('Daten: ', 264, 30, 50, 20)
GUICtrlCreateLabel('Bilder: ', 264, 45, 50, 20)
$cDaten = GUICtrlCreateCheckbox('', 312, 32, 10, 10)
$cBilder = GUICtrlCreateCheckbox('', 312, 47, 10, 10)
$SchriftG = GUICtrlCreateInput($sgrA, 113, 70, 35, 20, $ES_NUMBER)
$updwnSGR = GUICtrlCreateUpdown($SchriftG)
$bUp = GUICtrlCreateButton("Up", 113, 32, 35, 35, -1, $WS_EX_CLIENTEDGE)
$bDown = GUICtrlCreateButton("Dwn", 113, 97, 35, 35, -1, $WS_EX_CLIENTEDGE)
$bStart = GUICtrlCreateButton("Start", 20, 156, 80, 25, -1, $WS_EX_STATICEDGE)
$bAbbruch = GUICtrlCreateButton("Abbruch", 160, 156, 80, 25, -1, $WS_EX_STATICEDGE)
$bDaten = GUICtrlCreateButton("Alle Daten", 412, 188, 190, 30)
$bSetInput = GUICtrlCreateButton('Set', 274, 136, 40, 18)
$Progress1 = GUICtrlCreateProgress(11, 139, 238, 10, -1, $WS_EX_STATICEDGE)

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###
_GUICtrlListView_SetColumnWidth($listview, 0, 28)
_GUICtrlListView_SetColumnWidth($listview, 1, 40)
_GUICtrlListView_SetColumnWidth($listview, 2, 180)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUICtrlSetOnEvent($bStart, "start")
GUICtrlSetOnEvent($bUp, "UP")
GUICtrlSetOnEvent($bDown, "DOWN")
GUICtrlSetOnEvent($listview, "HandleClicks")
GUICtrlSetOnEvent($updwnSGR, "SchriftGR")
GUICtrlSetOnEvent($bDaten, "AlleDaten")
;GUICtrlSetOnEvent($bSetInput, "SetInput")
GUICtrlSetLimit($SchriftG, 99)
GUICtrlSetLimit($iInput, 1)
GUICtrlSetFont($iInput, 26)
GUICtrlSetFont($lLabel, 10, -1, 4)
GUICtrlSetFont($lLabel2, 10, -1, 4)
;GUICtrlSetData($iInput, StringUpper($aString[$cDataCount]))
GUICtrlSetState($cDaten, $GUI_CHECKED)
GUICtrlSetState($cBilder, $GUI_CHECKED)


;GUI Liste schreiben
For $a = 1 To UBound($var)
	If StringRight($var[$a - 1][2], 3) = 'ttf' Then
		If StringInStr($var[$a - 1][0], 'Bold', 1) = False And StringInStr($var[$a - 1][0], 'Italic', 1) = False _
				And StringInStr($var[$a - 1][0], 'MT Extra', 1) = False Then
			$nName = StringReplace($var[$a - 1][0], '(TrueType)', '', 1)
			$aItems[$x] = GUICtrlCreateListViewItem($x & '|' & $var[$a - 1][2] & '|' & $nName, $listview)
			GUICtrlSetOnEvent($aItems[$x], "HandleClicks")
			$x = $x + 1
		EndIf
	EndIf
Next

$x = 0
$cFonts = _GUICtrlListView_GetItemCount($listview)
_GUICtrlListView_SetSelectionMark($listview, 0)
$sTrim = _GUICtrlListView_GetSelectionMark($listview)
_GUICtrlListView_ClickItem($listview, 0, "left", False, 1)
$pList = _GUICtrlListView_GetSelectedColumn($listview)


While 1
	$rAktList = GUICtrlRead($listview)
	;MsgBox(0, '', $pList)
	$sgr = GUICtrlRead($SchriftG)
	If $sgr <> $sgrA Then
		Drawing()
		$sgrA = $sgr
	EndIf
	$input = GUICtrlRead($iInput)
	;Sleep(50)
WEnd

;Funktionen
Func start()
	$sgr = GUICtrlRead($SchriftG)
	$File1 = FileOpen(@ScriptDir & "\coords\" & $sTrim & "_" & $sgr & "_Upper_coords.txt", 10)
	$File2 = FileOpen(@ScriptDir & "\coords\" & $sTrim & "_" & $sgr & "_Lower_coords.txt", 10)
	;Fenster Farbwert auslesen
	Local $wh1, $wh2
	;_ArrayDisplay($rect)
	$wh1 = StringSplit($aARect[0][4], '/')
	$wh2 = StringSplit($aARect[1][4], '/')

	For $iX = 0 To $wh1[1]
		For $iY = 0 To $wh1[2]
			$iPixelColor1 = PixelGetColor($iX, $iY, GUICtrlGetHandle($gWin1))
			If Dec($iPixelColor1) < Dec('999999') Then
				FileWrite($File1, $iX & "," & $iY & @CRLF)
			EndIf
		Next
	Next
	For $iX = 0 To $wh2[1]
		For $iY = 0 To $wh2[2]
			$iPixelColor2 = PixelGetColor($iX, $iY, GUICtrlGetHandle($gWin2))
			If Dec($iPixelColor2) < Dec('999999') Then
				FileWrite($File2, $iX & "," & $iY & @CRLF)
			EndIf
		Next
	Next

;~ 	For $iX = 0 To 100 - 1
;~ 		For $iY = 0 To 100 - 1
;~ 			$iPixelColor1 = PixelGetColor($iX, $iY, GUICtrlGetHandle($gWin1))
;~ 			$iPixelColor2 = PixelGetColor($iX, $iY, GUICtrlGetHandle($gWin2))
;~ 			If Dec($iPixelColor1) < Dec('999999') Then
;~ 				FileWrite($File1, $iX & "," & $iY & @CRLF)
;~ 			EndIf
;~ 			If Dec($iPixelColor2) < Dec('999999') Then
;~ 				FileWrite($File2, $iX & "," & $iY & @CRLF)
;~ 			EndIf
;~ 		Next
;~ 	Next
	FileClose($File1)
	FileClose($File1)
	Drawing()
EndFunc   ;==>start
Func Drawing()
	Local $iRectWidth, $iRectHeight, $aCtrlPos1
	GUICtrlSetColor($gWin1, 0)
	GUICtrlSetColor($gWin2, 0)
	$rInput = $aString[$cDataCount]
	$rInput1 = StringUpper($rInput)
	$rInput2 = StringLower($rInput)
	$sgr = GUICtrlRead($SchriftG)
	; Größe des Graphic-Controls ermitteln (Noch 100x100, aber wer weiß, wann sich das ändert)
	$aCtrlPos1 = ControlGetPos($msg, '', $gWin1)
	$aCtrlPos2 = ControlGetPos($msg, '', $gWin2)
	$iRectWidth = $aCtrlPos1[2]
	$iRectHeight = $aCtrlPos1[3]
	_GDIPlus_GraphicsClear($hGfx1, 0xFFFFFFFF)
	_GDIPlus_GraphicsClear($hGfx2, 0xFFFFFFFF)

	Global $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics(100, 100, $hGfx1)
	Global $hBitmap2 = _GDIPlus_BitmapCreateFromGraphics(100, 100, $hGfx2)
	Global $hBackbuffer1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
	Global $hBackbuffer2 = _GDIPlus_ImageGetGraphicsContext($hBitmap2)

	_GDIPlus_GraphicsDrawString($hBackbuffer1, $rInput1, 0, 0, $sTrim, $sgr)
	_GDIPlus_GraphicsDrawString($hBackbuffer2, $rInput2, 0, 0, $sTrim, $sgr)

	_Zentriere($rInput1, 50, 50, $sgr, $sTrim, $hBackbuffer1)
	_Zentriere($rInput2, 50, 50, $sgr, $sTrim, $hBackbuffer2)

	_GDIPlus_GraphicsDrawImage($hGfx1, $hBitmap1, 0, 0)
	_GDIPlus_GraphicsDrawImage($hGfx2, $hBitmap2, 0, 0)


EndFunc   ;==>Drawing
;SpecialEvents
Func SpecialEvents()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			cleanup()
			Exit
	EndSelect
EndFunc   ;==>SpecialEvents
Func _Zentriere($sString, $iX, $iY, $fSize, $sFont, $hGfxBuffer)
    Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0)
    Local $hPath = $aResult[2]

    Local $hFormat = _GDIPlus_StringFormatCreate()
    Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
    Local $tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
    Local $tBounds = _GDIPlus_RectFCreate(0, 0, 0, 0)

    DllCall($ghGDIPDll, "uint", "GdipAddPathString", "hwnd", $hPath, "wstr", $sString, "int", -1, "hwnd", $hFamily, "int", 0, "float", $fSize, "ptr", DllStructGetPtr($tLayout), "hwnd", $hFormat)
    DllCall($ghGDIPDll, "uint", "GdipGetPathWorldBounds", "hwnd", $hPath, "ptr", DllStructGetPtr($tBounds), "hwnd", 0, "hwnd", 0)

    Local $fRectX = DllStructGetData($tBounds, "X")
    Local $fRectY = DllStructGetData($tBounds, "Y")
    Local $fRectW = DllStructGetData($tBounds, "Width")
    Local $fRectH = DllStructGetData($tBounds, "Height")

    Local $hMatrix = _GDIPlus_MatrixCreate()
    _GDIPlus_MatrixTranslate($hMatrix, -$fRectX - $fRectW / 2 + $iX, -$fRectY - $fRectH / 2 + $iY)
    DllCall($ghGDIPDll, "uint", "GdipTransformPath", "hwnd", $hPath, "hwnd", $hMatrix)
    _GDIPlus_MatrixDispose($hMatrix)

    DllCall($ghGDIPDll, "uint", "GdipFillPath", "hwnd", $hGfxBuffer, "hwnd", $hBrush, "hwnd", $hPath)

    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)

    DllCall($ghGDIPDll, "uint", "GdipDeletePath", "hwnd", $hPath)
EndFunc   ;==>_Zentriere
Func AlleDaten()
	;_tRect()
;~ 	$sgr = GUICtrlRead($SchriftG)
;~ 	$File1 = FileOpen(@ScriptDir & "\coords\" & $sTrim & "_" & $sgr & "_Upper_coords.txt", 10)
;~ 	$File2 = FileOpen(@ScriptDir & "\coords\" & $sTrim & "_" & $sgr & "_Lower_coords.txt", 10)
;~ 	For $z = 1 To $data[0][0]
;~ 		For $iX = 0 To 100 - 1
;~ 			For $iY = 0 To 100 - 1
;~ 				$iPixelColor1 = PixelGetColor($iX, $iY, GUICtrlGetHandle($gWin1))
;~ 				$iPixelColor2 = PixelGetColor($iX, $iY, GUICtrlGetHandle($gWin2))
;~ 				If Dec($iPixelColor1) < Dec('999999') Then
;~ 					FileWrite($File1, $iX & "," & $iY & @CRLF)
;~ 				EndIf
;~ 				If Dec($iPixelColor2) < Dec('999999') Then
;~ 					FileWrite($File2, $iX & "," & $iY & @CRLF)
;~ 				EndIf
;~ 			Next
;~ 		Next
;~ 	Next
;~ 	FileClose($File1)
;~ 	FileClose($File1)
EndFunc   ;==>AlleDaten
;HandleClicks
Func HandleClicks()
	$aktSel = GUICtrlRead(GUICtrlRead($listview))
	$aList = StringSplit($aktSel, '|')
	$sTrim = StringTrimRight($aList[3], 1)
	;_ArrayDisplay($aList)
	Drawing()
EndFunc   ;==>HandleClicks
Func _GDIPlus_GetPixel($hBitmap, $x, $Y)
	Local $result = DllCall($ghGDIPDLL, "int", "GdipBitmapGetPixel", "ptr", $hBitmap, "int", $x, "int", $Y, "dword*", 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetError($result[0], 1, $result[4])
EndFunc   ;==>_GDIPlus_GetPixel
;UP()
Func UP()
	If $cDataCount < $aString[0] Then
		$cDataCount = $cDataCount + 1
	EndIf
	Drawing()
EndFunc   ;==>UP
;DOWN()
Func DOWN()
	If $cDataCount >= 2 Then
		$cDataCount = $cDataCount - 1
	EndIf
	Drawing()
EndFunc   ;==>DOWN
Func SchriftGR()
	$sgr = GUICtrlRead($SchriftG)
	If $sgr <= 8 Then
		GUICtrlSetData($SchriftG, 8)
	EndIf
	If $sgr >= 99 Then
		GUICtrlSetData($SchriftG, 99)
	EndIf
	Drawing()
EndFunc   ;==>SchriftGR
Func _GetRegValues($HKEY)
	Local $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
	If StringInStr($HKEY, '\') Then
		If StringRight($HKEY, 1) = '\' Then
			$HKEY = StringTrimRight($HKEY, 1)
			Local $strKeyPath = ''
		Else
			Local $strKeyPath = StringRight($HKEY, StringLen($HKEY)-StringInStr($HKEY, '\') )
			$HKEY = StringLeft($HKEY, StringInStr($HKEY, '\')-1)
		EndIf
	Else
		Local $strKeyPath = ''
	EndIf
	Select
		Case $HKEY = "HKEY_LOCAL_MACHINE" Or $HKEY = "HKLM"
			$HKEY = 0x80000002
		Case $HKEY = "HKEY_USERS" Or $HKEY = "HKU"
			$HKEY = 0x80000003
		Case $HKEY = "HKEY_CURRENT_USER" Or $HKEY = "HKCU"
			$HKEY = 0x80000001
		Case $HKEY = "HKEY_CLASSES_ROOT" Or $HKEY = "HKCR"
			$HKEY = 0x80000000
		Case $HKEY = "HKEY_CURRENT_CONFIG" Or $HKEY = "HKCC"
			$HKEY = 0x80000005
	EndSelect
	Local $oReg = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
	Local $arrValueNames, $arrValueTypes, $strValue
	$oReg.EnumValues($HKEY, $strKeyPath, $arrValueNames, $arrValueTypes)
	$OEvent = ObjEvent($oReg, "EnumValues")
	If Not IsArray($arrValueNames) Then Return ''
	Local $arOut[UBound($arrValueNames)][3]
	For $i = 0 To UBound($arrValueNames) -1
		$arOut[$i][0] = $arrValueNames[$i]
		Switch $arrValueTypes[$i]
			Case 1
				$arOut[$i][1] = 'REG_SZ'
				$oReg.GetStringValue($HKEY, $strKeyPath, $arrValueNames[$i], $strValue)
			Case 2
				$arOut[$i][1] = 'REG_EXPAND_SZ'
				$oReg.GetExpandedStringValue($HKEY, $strKeyPath, $arrValueNames[$i], $strValue)
			Case 3
				$arOut[$i][1] = 'REG_BINARY'
				$oReg.GetBinaryValue($HKEY, $strKeyPath, $arrValueNames[$i], $strValue)
			Case 4
				$arOut[$i][1] = 'REG_DWORD'
				$oReg.GetStringValue($HKEY, $strKeyPath, $arrValueNames[$i], $strValue)
			Case 7
				$arOut[$i][1] = 'REG_MULTI_SZ'
				$oReg.GetMultiStringValue($HKEY, $strKeyPath, $arrValueNames[$i], $strValue)
		EndSwitch
		$arOut[$i][2] = $strValue
	Next
	Return $arOut
EndFunc  ;==>_GetRegValues
Func MyErrFunc()
   Return
Endfunc
Func cleanup()
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hGfx1)
	_GDIPlus_GraphicsDispose($hGfx2)
	_GDIPlus_Shutdown()
EndFunc   ;==>cleanup