#include <GDIPlus.au3>


Opt("GUIOnEventMode", 1)

; General Constants
Global Const $Width = 800
Global Const $Height = 600
Global Const $PI = 3.14159

; Creating the GUI
Global $hWnd = GUICreate("Confused ASCII", $Width, $Height)

; Start GDI+ and init resources
_GDIPlus_Startup()

; Backbuffer stuff
Global $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hWnd)
Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphics)
Global $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 4)

; For realtime drawing
Global $hBrush = _GDIPlus_BrushCreateSolid(0x55FF00FF)
Global $hFontFamily = _GDIPlus_FontFamilyCreate("Georgia")
Global $hStringFormat = _GDIPlus_StringFormatCreate()
; Shit load of font size
Global $aFonts[500]
For $i = 0 To UBound($aFonts) - 1
	$aFonts[$i] = _GDIPlus_FontCreate($hFontFamily, ($i / 1.5) + 1)
Next

; GUI_EVENT_CLOSE
GUISetOnEvent(-3, "close")
; Show the GUI, yihoo!
GUISetState()

; The random set of chars that will be used in the animation
Global $charset = "0123456789abcdefghijklmnopqrstuvwxzABCDEFGHIJKLMNOPQRSTUVWXYZ!#¤%&/()=?`´'*¨^-.,;:_@£${[]}\§½<>|"
$charset = StringSplit($charset, "", 2)

; The sign 'object', the constants are for readability, sort of an associative array
Global Const $LIFE1 = 0
Global Const $SPEED1 = 1
Global Const $LIFE2 = 2
Global Const $SPEED2 = 3
Global Const $FONTSIZE = 4
Global Const $CHARACTER = 5
Global Const $MAXWIDTH = 6
Global Const $DIRECTION1 = 7
Global Const $DIRECTION2 = 8
Global Const $TANGENTINC = 9
Global $Signs[55][10]


; Set up start values for the array
For $i = 0 To UBound($Signs) - 1
	$Signs[$i][$LIFE1] = 0 ; This will be added by speed1
	$Signs[$i][$SPEED1] = Random(1, 3) / 100 ; Speed1
	$Signs[$i][$LIFE2] = 0 ; This will be added by speed2 
	$Signs[$i][$SPEED2] = Random(1, 3) / 100 ; Speed2
	$Signs[$i][$FONTSIZE] = Round(10 ^ Random(1, 2)) ; Font size, between 10-100, is exponential so smaller fonts are more common
	$Signs[$i][$CHARACTER] = $charset[Random(0, UBound($charset) - 1, 1)] ; Get a random char from the charset
	$Signs[$i][$MAXWIDTH] = $Width / 2 - 100 ; Radius of the area the 
	If Random(0, 1, 1) Then
		$Signs[$i][$DIRECTION1] = Random(0.5, 2)
	Else
		$Signs[$i][$DIRECTION1] = -Random(0.5, 2)
	EndIf
	If Random(0, 1, 1) Then
		$Signs[$i][$DIRECTION2] = Random(0.5, 2)
	Else
		$Signs[$i][$DIRECTION2] = -Random(0.5, 2)
	EndIf

	$Signs[$i][$TANGENTINC] = -1
Next


$timer = TimerInit()
$layout = _GDIPlus_RectFCreate(0, 0, 1000, 1000)
Do
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFF000000)

	If TimerDiff($timer) > 2500 Then
		$Signs[Random(0, UBound($Signs) - 1, 1)][$TANGENTINC] = 0
		$timer = TimerInit()
	EndIf

	$debug_active = 0
	For $i = 0 To UBound($Signs) - 1

		; Increase the lifes
		$Signs[$i][$LIFE1] += $Signs[$i][$SPEED1] * $Signs[$i][$DIRECTION1]
		$Signs[$i][$LIFE2] += $Signs[$i][$SPEED2] * $Signs[$i][$DIRECTION2]

		$size = (Sin($Signs[$i][$LIFE2]) * ($Signs[$i][$MAXWIDTH] - 25)) + 25

		$x = Cos($Signs[$i][$LIFE1]) * $size + $Width / 2 - $size / 2
		$y = Sin($Signs[$i][$LIFE1]) * $size + $Height / 2 - $size / 2

		DllStructSetData($layout, "x", $x)
		DllStructSetData($layout, "y", $y)

		If $Signs[$i][$TANGENTINC] <> -1 Then
			$debug_active += 1
			$Signs[$i][$TANGENTINC] += 0.01
			$fsize = $Signs[$i][$FONTSIZE] + Abs(Tan($Signs[$i][$TANGENTINC]) * 10)
			If $Signs[$i][$TANGENTINC] > $PI * 1.2 Then
				$fsize = 10
				$Signs[$i][$TANGENTINC] = -1

			EndIf

			If $fsize > 500 Then $fsize = 500

		Else

			$fsize = $Signs[$i][$FONTSIZE] + Abs(Tan($Signs[$i][$TANGENTINC]) * 10)

		EndIf




		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, $Signs[$i][$CHARACTER], $aFonts[$fsize - 1], $layout, $hStringFormat, $hBrush)
	Next




Until Not (Sleep(10) + _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $Width, $Height))




Func close()
	For $i = 0 To UBound($aFonts) - 1
		_GDIPlus_FontDispose($aFonts[$i])
	Next
	_GDIPlus_StringFormatDispose($hStringFormat)
	_GDIPlus_FontFamilyDispose($hFontFamily)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_ImageDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>close