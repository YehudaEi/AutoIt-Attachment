#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GuiScrollBars.au3>
#include <ScrollBarConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
#Include <GDIPlus.au3>

Global $aSB_WindowInfo[1][10]
Global $aSB_WindowInfoEx[1][5]

Global Const $L = 1280
Global Const $H = 905
Global Const $PIC = @DesktopDir & "\img.jpg"
Global Const $iInterpolationMode = 7
Global Const $ConstH = Round(($H/@DesktopHeight), 0)+2
Global Const $DimL = Round(($L/$ConstH), 0)
Global Const $DimH = Round(($H/$ConstH), 0)

Pr()
Func Pr()

	$AdGUI = GUICreate("Zone Map", $DimL, $DimH, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU))
	GUISetState(@SW_SHOW)

	_GUIScrollbars_Generate($AdGUI, $L, $H, 0, 0, False)

	_GDIPlus_Startup()

	$hImage = _GDIPlus_ImageLoadFromFile($PIC)
	$hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $L, "int", $H, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]
	$hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	$aResult = DllCall($ghGDIPDll, "int", "GdipSetInterpolationMode", "handle", $hBmpCtxt, "int", $iInterpolationMode)
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $L, $H)

	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($AdGUI)
	_GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 0, 0)

	_GDIPlus_Shutdown()

	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	_GDIPlus_ImageDispose($PIC)

While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				Exit
		EndSelect
WEnd
EndFunc

Func _GUIScrollbars_Generate($hWnd, $iH_Scroll = 0, $iV_Scroll = 0, $iH_Tight = 0, $iV_Tight = 0, $fBefore = False)

	; Check if valid window handle
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)
	If $aSB_WindowInfo[0][0] <> "" Then
		ReDim $aSB_WindowInfo[UBound($aSB_WindowInfo) + 1][10]
		ReDim $aSB_WindowInfoEx[UBound($aSB_WindowInfo) + 1][5]
	EndIf

	; If no scroll sizes set, return error
	If $iH_Scroll = 0 And $iV_Scroll = 0 Then Return SetError(2, 0, 0)

	; Confirm Tight values
	If $iH_Tight <> 0 Then $iH_Tight = 1
	If $iV_Tight <> 0 Then $iV_Tight = 1

	; Create structs
	Local $tTEXTMETRIC = DllStructCreate($tagTEXTMETRIC)
	Local $tSCROLLINFO = DllStructCreate($tagSCROLLINFO)
	DllStructSetData($tSCROLLINFO, "cbSize", DllStructGetSize($tSCROLLINFO))
	Local $tRect = DllStructCreate($tagRECT)

	; Declare local variables
	Local $iIndex = UBound($aSB_WindowInfo) - 1
	Local $iError, $iExtended

	; Save window handle
	$aSB_WindowInfo[$iIndex][0] = $hWnd

	; Determine text size
	Local $hDC = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If Not @error Then
		$hDC = $hDC[0]
		DllCall("gdi32.dll", "bool", "GetTextMetricsW", "handle", $hDC, "ptr", DllStructGetPtr($tTEXTMETRIC))
		If @error Then
			$iError = @error
			$iExtended = @extended
			DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
			Return SetError($iError, $iExtended, -2)
		EndIf
		DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	Else
		Return SetError(@error, @extended, -1)
	EndIf
	$aSB_WindowInfo[$iIndex][2] = DllStructGetData($tTEXTMETRIC, "tmAveCharWidth")
	$aSB_WindowInfo[$iIndex][3] = DllStructGetData($tTEXTMETRIC, "tmHeight") + DllStructGetData($tTEXTMETRIC, "tmExternalLeading")

	; Size aperture window without bars
	DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "ptr", DllStructGetPtr($tRect))
	If @error Then Return SetError(@error, @extended, -3)
	Local $iX_Client_Full = DllStructGetData($tRect, "Right") - DllStructGetData($tRect, "Left")
	Local $iY_Client_Full = DllStructGetData($tRect, "Bottom") - DllStructGetData($tRect, "Top")
	$aSB_WindowInfo[$iIndex][4] = $iX_Client_Full
	$aSB_WindowInfo[$iIndex][5] = $iY_Client_Full

	; Hide both scrollbars
	_GUIScrollBars_ShowScrollBar($hWnd, $SB_BOTH, False)
	; Show scrollbars and register scrollbar and mousewheel messages if required
	If $iH_Scroll Then
		_GUIScrollBars_ShowScrollBar($hWnd, $SB_HORZ)
		GUIRegisterMsg($WM_HSCROLL, "_Scrollbars_WM_HSCROLL")
		GUIRegisterMsg($WM_MOUSEHWHEEL, '_Scrollbars_WM_MOUSEHWHEEL')
	EndIf
	If $iV_Scroll Then
		_GUIScrollBars_ShowScrollBar($hWnd, $SB_VERT)
		GUIRegisterMsg($WM_VSCROLL, "_Scrollbars_WM_VSCROLL")
		GUIRegisterMsg($WM_MOUSEWHEEL, "_Scrollbars_WM_MOUSEWHEEL")
	EndIf

	; Size aperture window with bars
	DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "ptr", DllStructGetPtr($tRect))
	If @error Then Return SetError(@error, @extended, -3)
	Local $iX_Client_Bar = DllStructGetData($tRect, "Right") - DllStructGetData($tRect, "Left")
	Local $iY_Client_Bar = DllStructGetData($tRect, "Bottom") - DllStructGetData($tRect, "Top")

	; If horizontal scrollbar is required
	Local $iH_FullPage
	If $iH_Scroll Then
		If $fBefore Then
			; Use actual aperture width
			$aSB_WindowInfo[$iIndex][4] = $iX_Client_Bar
			; Determine page size (aperture width / text width)
			$iH_FullPage = Floor($aSB_WindowInfo[$iIndex][4] / $aSB_WindowInfo[$iIndex][2])
			; Determine max size (scroll width / text width - tight)
			$aSB_WindowInfo[$iIndex][6] = Floor($iH_Scroll / $aSB_WindowInfo[$iIndex][2]) - $iH_Tight
		Else
			; Use reduced aperture width only if other scrollbar exists
			If $iV_Scroll Then $aSB_WindowInfo[$iIndex][4] = $iX_Client_Bar
			; Determine page size (aperture width / text width)
			$iH_FullPage = Floor($aSB_WindowInfo[$iIndex][4] / $aSB_WindowInfo[$iIndex][2])
			; Determine max size (scroll width / text width * correction factor for V scrollbar if required - tight)
			$aSB_WindowInfo[$iIndex][6] = Floor($iH_Scroll / $aSB_WindowInfo[$iIndex][2] * $aSB_WindowInfo[$iIndex][4] / $iX_Client_Full) - $iH_Tight
		EndIf
	Else
		$aSB_WindowInfo[$iIndex][6] = 0
	EndIf

	; If vertical scrollbar required
	Local $iV_FullPage
	If $iV_Scroll Then
		If $fBefore Then
			; Use actual aperture height
			$aSB_WindowInfo[$iIndex][5] = $iY_Client_Bar
			; Determine page size (aperture width / text width)
			$iV_FullPage = Floor($aSB_WindowInfo[$iIndex][5] / $aSB_WindowInfo[$iIndex][3])
			; Determine max size (scroll width / text width - tight)
			$aSB_WindowInfo[$iIndex][7] = Floor($iV_Scroll / $aSB_WindowInfo[$iIndex][3]) - $iV_Tight
		Else
			; Use reduced aperture width only if other scrollbar exists
			If $iH_Scroll Then $aSB_WindowInfo[$iIndex][5] = $iY_Client_Bar
			; Determine page size (aperture width / text width)
			$iV_FullPage = Floor($aSB_WindowInfo[$iIndex][5] / $aSB_WindowInfo[$iIndex][3])
			; Determine max size (scroll width / text width * correction factor for H scrollbar if required - tight)
			$aSB_WindowInfo[$iIndex][7] = Floor($iV_Scroll / $aSB_WindowInfo[$iIndex][3] * $aSB_WindowInfo[$iIndex][5] / $iY_Client_Full) - $iV_Tight
		EndIf
	Else
		$aSB_WindowInfo[$iIndex][7] = 0
	EndIf

	Local $aRet[4]
	If $iV_Scroll Then
		$aRet[0] = $iX_Client_Bar
	Else
		$aRet[0] = $iX_Client_Full
	EndIf
	If $iH_Scroll Then
		$aRet[1] = $iY_Client_Bar
	Else
		$aRet[1] = $iY_Client_Full
	EndIf
	$aRet[2] = $iX_Client_Bar / $iX_Client_Full
	$aRet[3] = $iY_Client_Bar / $iY_Client_Full

	; Save extended window info
	$aSB_WindowInfoEx[$iIndex][0] = $iH_Scroll
	$aSB_WindowInfoEx[$iIndex][1] = $iV_Scroll
	$aSB_WindowInfoEx[$iIndex][2] = $aRet[2]
	$aSB_WindowInfoEx[$iIndex][3] = $aRet[3]
	$aSB_WindowInfoEx[$iIndex][4] = $fBefore

	Local $fSuccess = True
	If _GUIScrollBars_ShowScrollBar($hWnd, $SB_BOTH, False) = False Then $fSuccess = False
	If $iH_Scroll Then
		If _GUIScrollBars_SetScrollInfoMax($hWnd, $SB_HORZ, $aSB_WindowInfo[$iIndex][6]) = False Then $fSuccess = False
		_GUIScrollBars_SetScrollInfoPage($hWnd, $SB_HORZ, $iH_FullPage)
		If @error Then $fSuccess = False
		If _GUIScrollBars_ShowScrollBar($hWnd, $SB_HORZ, True) = False Then $fSuccess = False
	Else
		If _GUIScrollBars_ShowScrollBar($hWnd, $SB_HORZ, False) = False Then $fSuccess = False
	EndIf
	If $iV_Scroll Then
		If _GUIScrollBars_SetScrollInfoMax($hWnd, $SB_VERT, $aSB_WindowInfo[$iIndex][7]) = False Then $fSuccess = False
		_GUIScrollBars_SetScrollInfoPage($hWnd, $SB_VERT, $iV_FullPage)
		If @error Then $fSuccess = False
		If _GUIScrollBars_ShowScrollBar($hWnd, $SB_VERT, True) = False Then $fSuccess = False
	Else
		If _GUIScrollBars_ShowScrollBar($hWnd, $SB_VERT, False) = False Then $fSuccess = False
	EndIf

	If $fSuccess Then Return $aRet
	Return SetError(3, 0, 0)

EndFunc   ;==>_GUIScrollbars_Generate

Func _GUIScrollbars_Locate_Ctrl($hWnd, $iX, $iY)

	; Check $hWnd
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)

	; Find window info
	Local $iIndex = -1
	For $i = 0 To UBound($aSB_WindowInfo) - 1
		If $hWnd = $aSB_WindowInfo[$i][0] Then $iIndex = $i
	Next
	If $iIndex = -1 Then Return SetError(3, 0, 0)

	; Check if location is within scrollable area of the window
	If $iX < 0 Or $iX > $aSB_WindowInfoEx[$iIndex][0] Then Return SetError(2, 0, 0)
	If $iY < 0 Or $iY > $aSB_WindowInfoEx[$iIndex][1] Then Return SetError(2, 0, 0)

	; Calculate factored coordinates if needed
	If Not $aSB_WindowInfoEx[$iIndex][4] Then
		$iX *= $aSB_WindowInfoEx[$iIndex][2]
		$iY *= $aSB_WindowInfoEx[$iIndex][3]
	EndIf

	; Correct for any scrollbar movement
	$iX -= _GUIScrollBars_GetScrollInfoPos($hWnd, $SB_HORZ) * $aSB_WindowInfo[$iIndex][2]
	$iY -= _GUIScrollBars_GetScrollInfoPos($hWnd, $SB_VERT) * $aSB_WindowInfo[$iIndex][3]

	Local $aRet[2] = [$iX, $iY]

	Return $aRet

EndFunc   ;==>_GUIScrollbars_Locate_Ctrl

Func _GUIScrollbars_Scroll_Page($hWnd, $iH_Scroll_Pos = 0, $iV_Scroll_Pos = 0)

	Local $iPos

	; Check $hWnd
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)

	; Check $iH/V_Scroll_Pos
	If Not (IsInt($iH_Scroll_Pos) And IsInt($iV_Scroll_Pos)) Then Return SetError(3, 0, 0)

	; Find window info
	Local $iIndex = -1
	For $i = 0 To UBound($aSB_WindowInfo) - 1
		If $hWnd = $aSB_WindowInfo[$i][0] Then $iIndex = $i
	Next
	If $iIndex = -1 Then Return SetError(2, 0, 0)

	; Get page sizes
	Local $iH_Page = Floor($aSB_WindowInfo[$iIndex][4] / $aSB_WindowInfo[$iIndex][2])
	Local $iV_Page = Floor($aSB_WindowInfo[$iIndex][5] / $aSB_WindowInfo[$iIndex][3])

	If $iH_Scroll_Pos > 0 Then
		$iPos = ($iH_Scroll_Pos - 1) * $iH_Page
		If $iPos > $aSB_WindowInfo[$iIndex][6] Then $iPos = $aSB_WindowInfo[$iIndex][6]
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, $iPos)
	EndIf
	If $iV_Scroll_Pos > 0 Then
		$iPos = ($iV_Scroll_Pos - 1) * $iV_Page
		If $iPos > $aSB_WindowInfo[$iIndex][7] Then $iPos = $aSB_WindowInfo[$iIndex][7]
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, $iPos)
	EndIf

EndFunc   ;==>_GUIScrollbars_Scroll_Page

Func _GUIScrollbars_Minimize($hWnd)

	; Check $hWnd
	If Not IsHWnd($hWnd) Then Return SetError(1, 0, 0)

	; Find window info
	Local $iIndex = -1
	For $i = 0 To UBound($aSB_WindowInfo) - 1
		If $hWnd = $aSB_WindowInfo[$i][0] Then $iIndex = $i
	Next
	If $iIndex = -1 Then Return SetError(1, 0, 0)

	; Show both scrollbars
	_GUIScrollBars_ShowScrollBar($hWnd, $SB_BOTH, True)
	; Get vertical current position and move to top
	$aSB_WindowInfo[$iIndex][8] = _GUIScrollBars_GetScrollPos($hWnd, $SB_VERT)
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, 0)
	; Get horizontal current position and move to left
	$aSB_WindowInfo[$iIndex][9] = _GUIScrollBars_GetScrollPos($hWnd, $SB_HORZ)
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, 0)

EndFunc

Func _GUIScrollbars_Restore($hWnd, $fVert = True, $fHorz = True)

	Local $nV_Pos, $nH_Pos

	_GUIScrollBars_ShowScrollBar($hWnd, $SB_BOTH, True)
	$nV_Pos = _GUIScrollBars_GetScrollPos($hWnd, $SB_VERT) ; Get current position
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, 0) ; Set the scroll to zero
	$nH_Pos = _GUIScrollBars_GetScrollPos($hWnd, $SB_HORZ) ; Get current position
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, 0) ; Set the scroll to zero
	If Not $fVert Then
		_GUIScrollBars_ShowScrollBar($hWnd,  $SB_VERT, False)
	EndIf
	If Not $fHorz Then
		_GUIScrollBars_ShowScrollBar($hWnd,  $SB_HORZ, False)
	EndIf
	If $fVert Then
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, $nV_Pos)
	EndIf
	If $fHorz Then
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, $nH_Pos)
	EndIf

EndFunc

Func _Scrollbars_WM_VSCROLL($hWnd, $iMsg, $wParam, $lParam)

	#forceref $iMsg, $wParam, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $iIndex = -1, $yChar, $yPos
	Local $Min, $Max, $Page, $Pos, $TrackPos

	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$iIndex = $x
			$yChar = $aSB_WindowInfo[$iIndex][3]
			ExitLoop
		EndIf
	Next
	If $iIndex = -1 Then Return 0

	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
	$Min = DllStructGetData($tSCROLLINFO, "nMin")
	$Max = DllStructGetData($tSCROLLINFO, "nMax")
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	$yPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $yPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")

	Switch $nScrollCode
		Case $SB_TOP
			DllStructSetData($tSCROLLINFO, "nPos", $Min)
		Case $SB_BOTTOM
			DllStructSetData($tSCROLLINFO, "nPos", $Max)
		Case $SB_LINEUP
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)
		Case $SB_LINEDOWN
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)
		Case $SB_PAGEUP
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)
		Case $SB_PAGEDOWN
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)
		Case $SB_THUMBTRACK
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)

	$Pos = DllStructGetData($tSCROLLINFO, "nPos")
	If ($Pos <> $yPos) Then
		_GUIScrollBars_ScrollWindow($hWnd, 0, $yChar * ($yPos - $Pos))
		$yPos = $Pos
	EndIf

	Return $GUI_RUNDEFMSG

EndFunc   ;==>_Scrollbars_WM_VSCROLL

Func _Scrollbars_WM_HSCROLL($hWnd, $iMsg, $wParam, $lParam)

	#forceref $iMsg, $lParam
	Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
	Local $iIndex = -1, $xChar, $xPos
	Local $Page, $Pos, $TrackPos

	For $x = 0 To UBound($aSB_WindowInfo) - 1
		If $aSB_WindowInfo[$x][0] = $hWnd Then
			$iIndex = $x
			$xChar = $aSB_WindowInfo[$iIndex][2]
			ExitLoop
		EndIf
	Next
	If $iIndex = -1 Then Return 0

	Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_HORZ)
	$Page = DllStructGetData($tSCROLLINFO, "nPage")
	$xPos = DllStructGetData($tSCROLLINFO, "nPos")
	$Pos = $xPos
	$TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")
	Switch $nScrollCode
		Case $SB_LINELEFT
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)
		Case $SB_LINERIGHT
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)
		Case $SB_PAGELEFT
			DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)
		Case $SB_PAGERIGHT
			DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)
		Case $SB_THUMBTRACK
			DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
	EndSwitch

	DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
	_GUIScrollBars_SetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)
	_GUIScrollBars_GetScrollInfo($hWnd, $SB_HORZ, $tSCROLLINFO)

	$Pos = DllStructGetData($tSCROLLINFO, "nPos")
	If ($Pos <> $xPos) Then _GUIScrollBars_ScrollWindow($hWnd, $xChar * ($xPos - $Pos), 0)

	Return $GUI_RUNDEFMSG

EndFunc   ;==>_Scrollbars_WM_HSCROLL

Func _Scrollbars_WM_MOUSEWHEEL($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $lParam
	Local $iDirn, $iDelta = BitShift($wParam, 16) ; Mouse wheel movement

	If BitAND($wParam, 0x0000FFFF) Then ; If Ctrl or Shft pressed move Horz scrollbar
		$iDirn = $SB_LINERIGHT
		If $iDelta > 0 Then $iDirn = $SB_LINELEFT
		For $i = 1 To 7
			_SendMessage($hWnd, $WM_HSCROLL, $iDirn)
		Next
	Else ; Move Vert scrollbar
		$iDirn = $SB_LINEDOWN
		If $iDelta > 0 Then $iDirn = $SB_LINEUP
		_SendMessage($hWnd, $WM_VSCROLL, $iDirn)
	EndIf

	Return $GUI_RUNDEFMSG

EndFunc   ;==>_Scrollbars_WM_MOUSEWHEEL

Func _Scrollbars_WM_MOUSEHWHEEL($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $lParam
	Local $iDirn = $SB_LINERIGHT
	If BitShift($wParam, 16) > 0 Then $iDirn = $SB_LINELEFT ; Mouse wheel movement
	For $i = 1 To 7
		_SendMessage($hWnd, $WM_HSCROLL, $iDirn)
	Next

	Return $GUI_RUNDEFMSG

EndFunc   ;==>_Scrollbars_WM_MOUSEHWHEEL

Func _GSB_Size_Text($hWnd)

	Local $tagTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & _
			"long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & _
			"wchar tmFirstChar;wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & _
			"byte tmPitchAndFamily;byte tmCharSet"
	Local $tTEXTMETRIC = DllStructCreate($tagTEXTMETRIC)

	Local $hDC = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If Not @error Then
		$hDC = $hDC[0]
		DllCall("gdi32.dll", "bool", "GetTextMetricsW", "handle", $hDC, "ptr", DllStructGetPtr($tTEXTMETRIC))
		If @error Then
			Local $iError = @error
			Local $iExtended = @extended
			DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
			Return SetError($iError, $iExtended, -2)
		EndIf
		DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	Else
		Return SetError(@error, @extended, -1)
	EndIf

	Local $aRet[2] = [ _
			DllStructGetData($tTEXTMETRIC, "tmAveCharWidth"), _
			DllStructGetData($tTEXTMETRIC, "tmHeight") + DllStructGetData($tTEXTMETRIC, "tmExternalLeading")]
	Return $aRet

EndFunc   ;==>_GSB_Size_Text

