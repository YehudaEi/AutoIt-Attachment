#Region Header
; #INDEX# =======================================================================================================================
; Title .........: TIG
; AutoIt Version : 3.3.4.0
; Language ......: English
; Description ...: Functions to create and update a tray icon scrolling bar graph
; Author(s) .....: Beege
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_TIG_CreateTrayGraph
;_TIG_SetBarColor
;_TIG_SetBackGoundColor
;_TIG_SetRange
;_TIG_UpdateTrayGraph
; ===============================================================================================================================

#cs
	CallTips:
	_TIG_CreateTrayGraph($iMin = 0, $iMax = 100, $iBarColor = 0xFF00ACFF, $iBackColor = 0xFF000000) Default $iBarColor = Blue; $iBackColor = Black
	_TIG_SetBarColor($iBarColor = 0xFF00ACFF) Default $iBarColor = Blue
	_TIG_SetBackGoundColor($iBackColor = 0xFF000000) Default $iBackColor = Black
	_TIG_SetRange($iMin = 0, $iMax = 100)
	_TIG_UpdateTrayGraph($iValue)
#ce

#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#EndRegion Header
#Region Initialization

AutoItWinSetTitle(AutoItWinGetTitle() & '_TraYIcoNUdF')

#EndRegion Initialization
#Region Global Variables and Constants

Global Enum $g_hGUI, $g_hGraphics, $g_hBitmap, $g_hBuffer, $g_hPen, $g_iMin, $g_iMax, $g_iBackColor, $g_iBarColor, $g_hIcon, $g_sValues, $g_hShell32, $iMax
Global $aTI[$iMax]
$aTI[$g_hGUI] = WinGetHandle(AutoItWinGetTitle())

#cs

	$aTI[$g_hGUI]		= Autoit Window Handle
	$aTI[$g_hGraphics]	= Handle to Graphics object
	$aTI[$g_hBitmap]	= Handle to Bitmap Object
	$aTI[$g_hBuffer]	= Handle to Buffer
	$aTI[$g_hPen]		= Handle to Pen Object
	$aTI[$g_iMin]		= Minimum Y Range
	$aTI[$g_iMax]		= Maximum Y Range
	$aTI[$g_iBackColor]	= Background Color
	$aTI[$g_iBarColor]	= Bar Color
	$aTI[$g_hIcon]		= Handle to Icon Bitmap
	$aTI[$g_sValues]	= String Containing Y Value	History
	$aTI[$g_hShell32]	= Handle to Shell32 dll

#ce

#EndRegion Global Variables and Constants
#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _TIG_CreateTrayGraph
; Description ...: Creates Tray Icon Bar Graph
; Syntax.........: _TIG_CreateTrayGraph($iMin = 0, $iMax = 100, $iBarColor = 0xFF00ACFF, $iBackColor = 0xFF000000)
; Parameters ....: $iMin     	- Minimum Y Value. Must Not be less than 0.
;				   $iMax     	- Maximum Y Value
;				   $iBarColor 	- Alpha, Red, Green and Blue Hex Value. (0xAARRGGBB). Default = Blue
;                  $iBackColor  - Alpha, Red, Green and Blue Hex Value. (0xAARRGGBB). Default = Black
; Return values .: Success      - 1
;                  Failure      - 0  and sets @ERROR:
;								- 1 Minimum Value Less than zero
;								- <> 0 - Value returned from _WinAPI_GetLastERROR()
; Author ........: Beege
; Remarks .......:
; ===============================================================================================================================
Func _TIG_CreateTrayGraph($iMin = 0, $iMax = 100, $iBarColor = 0xFF00ACFF, $iBackColor = 0xFF000000)

	If $iMin < 0 Then Return SetError(1, @extended, 0)

	_GDIPlus_Startup()
	OnAutoItExitRegister('_GdiExit')

	If $iBarColor = -1 Or $iBarColor = Default Then $iBarColor = 0xFF00ACFF
	If $iBackColor = -1 Or $iBackColor = Default Then $iBackColor = 0xFF000000
	If $iMin = -1 Or $iMin = Default Then $iMin = 0
	If $iMax = -1 Or $iMax = Default Then $iMax = 100

	$aTI[$g_hGraphics] = _GDIPlus_GraphicsCreateFromHWND($aTI[$g_hGUI])
	$aTI[$g_hBitmap] = _GDIPlus_BitmapCreateFromGraphics(16, 16, $aTI[$g_hGraphics])
	$aTI[$g_hBuffer] = _GDIPlus_ImageGetGraphicsContext($aTI[$g_hBitmap])
	$aTI[$g_hPen] = _GDIPlus_PenCreate($iBarColor, 1)
	$aTI[$g_hIcon] = -1
	$aTI[$g_sValues] = 0
	$aTI[$g_iBackColor] = $iBackColor
	$aTI[$g_iMin] = $iMin
	$aTI[$g_iMax] = $iMax
	$aTI[$g_hShell32] = DllOpen('shell32.dll')

	_GDIPlus_GraphicsClear($aTI[$g_hBuffer], $iBackColor)
	_GDIPlus_GraphicsDrawImageRect($aTI[$g_hGraphics], $aTI[$g_hBitmap], 0, 0, 16, 16)

	_CreateTrayIcon()
	If @error Then Return SetError(@error, @extended, 0)

	Return 1

EndFunc   ;==>_TIG_CreateTrayGraph

; #FUNCTION# ====================================================================================================================
; Name...........: _TIG_SetBarColor
; Description ...: Sets Bar Color for tray icon
; Syntax.........: _TIG_SetBarColor($iBarColor = 0xFF00ACFF)
; Parameters ....: $iBarColor 	- Alpha, Red, Green and Blue Hex Value. (0xAARRGGBB). Default = Blue
; Return values .: Success      - 1
;                  Failure      - 0  and sets @ERROR:
;								- 1
; Author ........: Beege
; Remarks .......: None
; ===============================================================================================================================
Func _TIG_SetBarColor($iBarColor = 0xFF00ACFF)

	If $iBarColor = -1 Or $iBarColor = Default Then $iBarColor = 0xFF00ACFF

	_GDIPlus_PenSetColor($aTI[$g_hPen], $iBarColor)
	If @error Then Return SetError(1, @extended, 0)

	Return 1

EndFunc   ;==>_TIG_SetBarColor

; #FUNCTION# ====================================================================================================================
; Name...........: _TIG_SetBackGoundColor
; Description ...: Sets BackGround Color for tray icon
; Syntax.........: _TIG_SetBackGoundColor($iBackColor = 0xFF000000)
; Parameters ....: $iBarColor 	- Alpha, Red, Green and Blue Hex Value. (0xAARRGGBB). Default = Black
; Return values .: Success      - 1
; Author ........: Beege
; Remarks .......: None
; ===============================================================================================================================
Func _TIG_SetBackGoundColor($iBackColor = 0xFF000000)

	If $iBackColor = -1 Or $iBackColor = Default Then $iBackColor = 0xFF000000

	$aTI[$g_iBackColor] = $iBackColor

	Return 1

EndFunc   ;==>_TIG_SetBackGoundColor

; #FUNCTION# ====================================================================================================================
; Name...........: _TIG_UpdateTray
; Description ...: Update Tray Bar Graph with new Value
; Syntax.........: _TIG_UpdateTray($iValue)
; Parameters ....: $iValue     	- Value to update graph with
; Return values .: Success      - 1
;                  Failure      - 0  and sets @ERROR:
;								- Value returned from _WinAPI_GetLastERROR()
; Author ........: Beege
; Remarks .......: None
; ===============================================================================================================================
Func _TIG_UpdateTrayGraph($iValue)

	$aTI[$g_sValues] = $iValue & '|' & $aTI[$g_sValues]
	Local $iX = 15, $split = StringSplit($aTI[$g_sValues], '|')

	_GDIPlus_GraphicsClear($aTI[$g_hBuffer], $aTI[$g_iBackColor])
	For $y = 1 To $split[0]
		_GDIPlus_GraphicsDrawLine($aTI[$g_hBuffer], $iX, (16 - _CalcValue($split[$y])), $iX, 16, $aTI[$g_hPen])
		$iX -= 1
	Next
	_GDIPlus_GraphicsDrawImageRect($aTI[$g_hGraphics], $aTI[$g_hBitmap], 0, 0, 16, 16)

	If $split[0] = 16 Then $aTI[$g_sValues] = StringLeft($aTI[$g_sValues], StringInStr($aTI[$g_sValues], '|', 0, -1) - 1)

	_CreateTrayIcon()
	If @error Then Return SetError(@error, @extended, 0)

	Return 1

EndFunc   ;==>_TIG_UpdateTrayGraph

; #FUNCTION# ====================================================================================================================
; Name...........: _TIG_SetRange
; Description ...: Sets Minimum and Maximum Y values of the Graph
; Syntax.........: _TIG_SetRange($iMin = 0, $iMax = 100)
; Parameters ....: $iMin     	- Minimum Y Value. Must be Greater than 0.
;				   $iMax     	- Maximum Y Value
; Return values .: Success      - 1
;                  Failure      - 0  and sets @ERROR:
;								- 1 Minimum Value Less than zero
; Author ........: Beege
; Remarks .......: None
; ===============================================================================================================================
Func _TIG_SetRange($iMin = 0, $iMax = 100)

	If $iMin < 0 Then Return SetError(1, @extended, 0)

	If $iMin = -1 Or $iMin = Default Then $iMin = 0
	If $iMax = -1 Or $iMax = Default Then $iMax = 100

	$aTI[$g_iMin] = $iMin
	$aTI[$g_iMax] = $iMax

	Return 1

EndFunc   ;==>_TIG_SetRange

#EndRegion Public Functions
#Region Internel Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _TraySetIcon
; Author ........: Yashied
; Modified ......: Beege
; ===============================================================================================================================
Func _TraySetIcon()

	Static $tNOTIFYICONDATA = DllStructCreate('dword Size;hwnd hWnd;uint ID;uint Flags;uint CallbackMessage;ptr hIcon;')
	Static $p_tNOTIFYICONDATA = DllStructGetPtr($tNOTIFYICONDATA)

	DllStructSetData($tNOTIFYICONDATA, 'Size', DllStructGetSize($tNOTIFYICONDATA))
	DllStructSetData($tNOTIFYICONDATA, 'hWnd', $aTI[$g_hGUI])
	DllStructSetData($tNOTIFYICONDATA, 'ID', 1)
	DllStructSetData($tNOTIFYICONDATA, 'Flags', 2) ; NIF_ICON
	DllStructSetData($tNOTIFYICONDATA, 'hIcon', $aTI[$g_hIcon])

	Local $Ret = DllCall($aTI[$g_hShell32], 'int', 'Shell_NotifyIcon', 'dword', 1, 'ptr', $p_tNOTIFYICONDATA)
	If @error Or $Ret[0] = 0 Then Return SetError(_WinAPI_GetLastError(), 0, 0)

	Return 1

EndFunc   ;==>_TraySetIcon

Func _CreateTrayIcon()

	Local $hclone = _GDIPlus_BitmapCloneArea($aTI[$g_hBitmap], 0, 0, 16, 16)
	Local $hIcon = DllCall($ghGDIPDll, 'int', 'GdipCreateHICONFromBitmap', 'ptr', $hclone, 'int*', 0)
	If $aTI[$g_hIcon] <> -1 Then _WinAPI_DestroyIcon($aTI[$g_hIcon])
	$aTI[$g_hIcon] = $hIcon[2]
	_GDIPlus_BitmapDispose($hclone)

	_TraySetIcon()
	If @error Then Return SetError(@error, @extended, 0)

EndFunc   ;==>_CreateTrayIcon

Func _CalcValue($iValue)

	If $iValue >= $aTI[$g_iMax] Then Return 16
	If $iValue <= $aTI[$g_iMin] Then Return 0

	Local $fPercent = $iValue / $aTI[$g_iMax]

	Switch Int($fPercent * 100)
		Case 8 To 98
			Return Int($fPercent * 16)
		Case 98 To 100
			Return 16
		Case 1 To 7
			Return 1
	EndSwitch

EndFunc   ;==>_CalcValue

Func _GdiExit()
	If $aTI[$g_hIcon] <> -1 Then _WinAPI_DestroyIcon($aTI[$g_hIcon])
	_GDIPlus_GraphicsDispose($aTI[$g_hGraphics])
	_GDIPlus_GraphicsDispose($aTI[$g_hBuffer])
	_GDIPlus_BitmapDispose($aTI[$g_hBitmap])
	_GDIPlus_PenDispose($aTI[$g_hPen])
	DllClose($aTI[$g_hShell32])
	_GDIPlus_Shutdown()
EndFunc   ;==>_GdiExit

#EndRegion Internel Functions