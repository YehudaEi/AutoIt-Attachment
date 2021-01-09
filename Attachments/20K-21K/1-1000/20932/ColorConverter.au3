#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Description=Converter color in different color system
#AutoIt3Wrapper_Res_Fileversion=1.5.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Dominique Uhlmann
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include-once

#include <CoolColor.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <array.au3>

AutoItSetOption("MustDeclareVars", 0)       					; 0 = no, 1 = require pre-declare
AutoItSetOption("GUIOnEventMode", 1)        					; 0 = disabled, 1 = OnEvent mode enabled

Global Const $_COLORCONSTANTS_RGBMAX = 255
Global Const $INITFILE = @ScriptDir & "\ColorConverter.ini"

Global Enum $RGB2HSL = 0x01, $RGB2HSV = 0x02, $RGB2CMYK = 0x04, $RGB2WEB = 0x08


Dim $RGBValue[3][2], $RGBUnit[3][2]
Dim $HSLValue[3][2], $HSLUnit[3][2]
Dim $HSVValue[3][2], $HSVUnit[3][2]
Dim $CMYKValue[4][2]
Dim $WebHex
Dim $Convert


#Region ### START Koda GUI section ### Form=c:\my download\test\colorconverter.kxf
$Form1 = GUICreate("Color Converter", 363, 378, 196, 128)

; RGB
$Red_L = GUICtrlCreateLabel("R", 85, 16, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Green_L = GUICtrlCreateLabel("G", 173, 16, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Blue_L = GUICtrlCreateLabel("B", 261, 16, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$RGBValue[0][0] = GUICtrlCreateInput("0", 75, 32, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "RGBKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$RGBValue[1][0] = GUICtrlCreateInput("0", 163, 32, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "RGBKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$RGBValue[2][0] = GUICtrlCreateInput("0", 251, 32, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "RGBKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

; HSL
$HueL_L = GUICtrlCreateLabel("H", 26, 72, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$SaturationL_L = GUICtrlCreateLabel("S", 146, 72, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$LightnessL_L = GUICtrlCreateLabel("L", 266, 72, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSLValue[0][0] = GUICtrlCreateInput("0", 16, 88, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "HSLKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSLUnit[0][0] = GUICtrlCreateCombo("", 56, 90, 49, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "°|255|240", "°")
GUICtrlSetOnEvent(-1, "HSLUnits")
$HSLValue[1][0] = GUICtrlCreateInput("0", 136, 88, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "HSLKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSLUnit[1][0] = GUICtrlCreateCombo("", 176, 90, 49, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "%|255|240", "%")
GUICtrlSetOnEvent(-1, "HSLUnits")
$HSLValue[2][0] = GUICtrlCreateInput("0", 256, 88, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "HSLKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSLUnit[2][0] = GUICtrlCreateCombo("", 296, 90, 49, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "%|255|240", "%")
GUICtrlSetOnEvent(-1, "HSLUnits")

; HSV
$HueV_L = GUICtrlCreateLabel("H", 26, 128, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$SaturationV_L = GUICtrlCreateLabel("S", 146, 128, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Value_L = GUICtrlCreateLabel("V", 266, 128, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSVValue[0][0] = GUICtrlCreateInput("0", 16, 144, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "HSVKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSVUnit[0][0] = GUICtrlCreateCombo("", 56, 146, 49, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "°|255", "°")
GUICtrlSetOnEvent(-1, "HSVUnits")
$HSVValue[1][0] = GUICtrlCreateInput("0", 136, 144, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "HSVKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSVUnit[1][0] = GUICtrlCreateCombo("", 176, 146, 49, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "%|255", "%")
GUICtrlSetOnEvent(-1, "HSVUnits")
$HSVValue[2][0] = GUICtrlCreateInput("0", 256, 144, 33, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "HSVKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$HSVUnit[2][0] = GUICtrlCreateCombo("", 296, 146, 49, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, "%|255", "%")
GUICtrlSetOnEvent(-1, "HSVUnits")

; CMYK
$Cyan_L = GUICtrlCreateLabel("C", 50, 192, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Magenta_L = GUICtrlCreateLabel("M", 130, 192, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Yellow_L = GUICtrlCreateLabel("Y", 210, 192, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Key_L = GUICtrlCreateLabel("K", 288, 192, 15, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$CMYKValue[0][0] = GUICtrlCreateInput("0.000", 32, 208, 49, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "CMYKKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$CMYKValue[1][0] = GUICtrlCreateInput("0.000", 112, 208, 49, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "CMYKKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$CMYKValue[2][0] = GUICtrlCreateInput("0.000", 192, 208, 49, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "CMYKKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$CMYKValue[3][0] = GUICtrlCreateInput("0.000", 272, 208, 49, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "CMYKKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

; Color
$Color = GUICtrlCreateLabel("", 96, 272, 164, 33, $WS_BORDER)

; WEB
$Web_L = GUICtrlCreateLabel("HTML Code", 96, 336, 86, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Web = GUICtrlCreateInput("#000000", 184, 334, 73, 24, $ES_CENTER)
GUICtrlSetOnEvent(-1, "WebKeyIn")
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetBkColor($Color, "0x000000")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

Initialize()

While 1
	Sleep(500)  												; Idle around
WEnd

;
;
;
Func CLOSEClicked()
	WrInitFile($INITFILE)

	Exit
EndFunc	; CLOSEClicked()

;
;
;
Func Initialize()
	RdInitFile($INITFILE)

	GetUnits($HSLUnit)
	GetUnits($HSVUnit)
EndFunc	; Initialize()

;
;
;
Func RdInitFile($sIni)
	Local $aIni

	If (FileExists($sIni)) Then
		$aIni = IniReadSection($sIni, "RGB")
		If @error Then
			IniWriteSection($sIni, "RGB", "Red=255" & @LF & "Green=255" & @LF & "Blue=255")
		Else
			For $i = 1 To $aIni[0][0]
				$RGBUnit[$i-1][1] = $aIni[$i][1]
			Next
		EndIf

		$aIni = IniReadSection($sIni, "HSL")
		If @error Then
			IniWriteSection($sIni, "HSL", "Hue=360" & @LF & "Sat=100" & @LF & "Lit=100")
		Else
			For $i = 1 To $aIni[0][0]
				$HSLUnit[$i-1][1] = $aIni[$i][1]
			Next
		EndIf

		$aIni = IniReadSection($sIni, "HSV")
		If @error Then
			IniWriteSection($sIni, "HSV", "Red=360" & @LF & "Green=100" & @LF & "Blue=100")
		Else
			For $i = 1 To $aIni[0][0]
				$HSVUnit[$i-1][1] = $aIni[$i][1]
			Next
		EndIf
	Else
		IniWriteSection($sIni, "RGB", "Red=255" & @LF & "Green=255" & @LF & "Blue=255")
		IniWriteSection($sIni, "HSL", "Hue=360" & @LF & "Sat=100" & @LF & "Lit=100")
		IniWriteSection($sIni, "HSV", "Red=360" & @LF & "Green=100" & @LF & "Blue=100")
	EndIf
EndFunc	; RdInitFile()

;
;
;
Func WrInitFile($sIni)
	IniWriteSection($sIni, "HSL", "Hue=" & $RGBUnit[0][1] & @LF & "Sat=" & $RGBUnit[1][1] & @LF & "Lit=" & $RGBUnit[2][1])
	IniWriteSection($sIni, "HSL", "Hue=" & $HSLUnit[0][1] & @LF & "Sat=" & $HSLUnit[1][1] & @LF & "Lit=" & $HSLUnit[2][1])
	IniWriteSection($sIni, "HSV", "Hue=" & $HSVUnit[0][1] & @LF & "Sat=" & $HSVUnit[1][1] & @LF & "Lit=" & $HSVUnit[2][1])
EndFunc	; WrInitFile()

;
;
;
Func SetUnits(ByRef $avArray)
	If (UBound($avArray) <> 3) Or (UBound($avArray, 0) <> 2) Then Return SetError(1, 1, 0)

	Local $Val

	For $i = 0 To 2
		$Val = GUICtrlRead($avArray[$i][0])
		Select
			Case $Val = "255"
				$avArray[$i][1] = 255

			Case $Val = "240"
				$avArray[$i][1] = 240

			Case $Val = "%"
				$avArray[$i][1] = 100

			Case $Val = "°"
				$avArray[$i][1] = 360

			Case Else
				$avArray[$i][1] = -1
		EndSelect
	Next
EndFunc	; SetUnits()

;
;
;
Func GetUnits(ByRef $avArray)
	If (UBound($avArray) <> 3) Or (UBound($avArray, 0) <> 2) Then Return SetError(1, 2, 0)

	For $i = 0 To 2
		Select
			Case $avArray[$i][1] = 255
				GUICtrlSetData($avArray[$i][0], "255")

			Case $avArray[$i][1] = 240
				GUICtrlSetData($avArray[$i][0], "240")

			Case $avArray[$i][1] = 100
				GUICtrlSetData($avArray[$i][0], "%")

			Case $avArray[$i][1] = 360
				GUICtrlSetData($avArray[$i][0], "°")

			Case Else
				GUICtrlSetData($avArray[$i][0], -1)
		EndSelect
	Next
EndFunc	; GetUnits()

;
;
;
Func Convert()
	Local $RGB[3], $Var[4]

	ValueA2DToA1D($RGBValue, $RGB)
	ConsoleWrite("RGB: " & $RGB[0] & ", " & $RGB[1] & ", " & $RGB[2] & @CRLF)

	If (BitAND($Convert, $RGB2HSL)) Then
		$Var = _ColorConvertRGBtoHSL($RGB)
	ConsoleWrite("Var: " & $Var[0] & ", " & $Var[1] & ", " & $Var[2] & @CRLF)
		ValueA1DToA2D($Var, $HSLValue)
	EndIf

	If (BitAND($Convert, $RGB2HSV)) Then
		$Var = _ColorConvertRGBtoHSV($RGB)
		ValueA1DToA2D($Var, $HSVValue)
	EndIf

	If (BitAND($Convert, $RGB2CMYK)) Then
		$Var = _ColorConvertRGBtoCMYK($RGB)
		ValueA1DToA2D($Var, $CMYKValue)
	EndIf

	If (BitAND($Convert, $RGB2WEB)) Then $WebHex = "#" & _ColorConvertRGBtoWeb($RGB)

	GUICtrlSetBkColor($Color, "0x" & Hex(Round($RGBValue[0][1] * $RGBUnit[0][1]), 2) & Hex(Round($RGBValue[1][1] * $RGBUnit[1][1]), 2) & Hex(Round($RGBValue[2][1] * $RGBUnit[2][1]), 2))

	RGBUpdate()
	HSLUpdate()
	HSVUpdate()
	CMYKUpdate()
	WebUpdate()

	$Convert = 0
EndFunc ; Convert()

; --------------------------------------------- RGB ---------------------------------------------
;
;
;
Func RGBKeyIn()
	For $i = 0 To 2
		$RGBValue[$i][1] = Number(GUICtrlRead($RGBValue[$i][0])) / $RGBUnit[$i][1]
	Next
;	ConsoleWrite("RGB: " & $RGBValue[0][1] & ", " & $RGBValue[1][1] & ", " & $RGBValue[2][1] & @CRLF)

	$Convert = BitOR($RGB2HSL, $RGB2HSV, $RGB2CMYK, $RGB2WEB)

	Convert()
EndFunc	; RGBKeyIn()

;
;
;
Func RGBUpdate()
	For $i = 0 To 2
		GUICtrlSetData($RGBValue[$i][0], Round($RGBValue[$i][1] * $RGBUnit[$i][1]))
	Next
EndFunc ; RGBUpdate()

;
;
;
Func HSLKeyIn()
	Local $Var[3]

	For $i = 0 To 2
		$HSLValue[$i][1] = Number(GUICtrlRead($HSLValue[$i][0])) / $HSLUnit[$i][1]
	Next
;	ConsoleWrite("HSL: " & $HSLValue[0][1] & ", " & $HSLValue[1][1] & ", " & $HSLValue[2][1] & @CRLF)

	ValueA2DToA1D($HSLValue, $Var)
	$Var = _ColorConvertHSLtoRGB($Var)
	$Convert = BitOR($RGB2HSV, $RGB2CMYK, $RGB2WEB)

	Convert()
EndFunc	; HSLKeyIn()

; --------------------------------------------- HSL ---------------------------------------------
;
;
;
Func HSLUpdate()
	For $i = 0 To 2
		GUICtrlSetData($HSLValue[$i][0], Round($HSLValue[$i][1] * $HSLUnit[$i][1]))
	Next
EndFunc ; HSLUpdate()

;
;
;
Func HSLUnits()
	SetUnits($HSLUnit)
	
	HSLUpdate()
EndFunc ; HSLUnits()

; --------------------------------------------- HSV ---------------------------------------------
;
;
;
Func HSVKeyIn()
	Local $Var[3]

	For $i = 0 To 2
		$HSVValue[$i][1] = Number(GUICtrlRead($HSVValue[$i][0])) / $HSVUnit[$i][1]
	Next
;	ConsoleWrite("HSV: " & $HSVValue[0][1] & ", " & $HSVValue[1][1] & ", " & $HSVValue[2][1] & @CRLF)

	ValueA2DToA1D($HSVValue, $Var)
	$Var = _ColorConvertHSVtoRGB($Var)
	$Convert = BitOR($RGB2HSL, $RGB2CMYK, $RGB2WEB)

	Convert()
EndFunc	; HSVKeyIn()

;
;
;
Func HSVUpdate()
	For $i = 0 To 2
		GUICtrlSetData($HSVValue[$i][0], Round($HSVValue[$i][1] * $HSVUnit[$i][1]))
	Next
EndFunc ; HSVUpdate()

;
;
;
Func HSVUnits()
	SetUnits($HSVUnit)
	
	HSVUpdate()
EndFunc ; HSVUnits()

; --------------------------------------------- CMYK ---------------------------------------------
;
;
;
Func CMYKKeyIn()
	Local $Var[4]

	For $i = 0 To 3
		$CMYKValue[$i][1] = Number(GUICtrlRead($CMYKValue[$i][0]))
	Next
;	ConsoleWrite("CMYK: " & $CMYKValue[0][1] & ", " & $CMYKValue[1][1] & ", " & $CMYKValue[2][1] & ", " & $CMYKValue[3][1] & @CRLF)

	ValueA2DToA1D($CMYKValue, $Var)
	$Var = _ColorConvertCMYKtoRGB($Var)
	$Convert = BitOR($RGB2HSL, $RGB2HSV, $RGB2WEB)

	Convert()
EndFunc	; CMYKKeyIn()

;
;
;
Func CMYKUpdate()
	For $i = 0 To 3
		GUICtrlSetData($CMYKValue[$i][0], StringFormat("%0.3f",$CMYKValue[$i][1]))
	Next
EndFunc ; CMYKUpdate()

; --------------------------------------------- Web ---------------------------------------------
;
;
;
Func WebKeyIn()
	$WebHex = GUICtrlRead($Web)
;	ConsoleWrite($WebHex & @CRLF)

	$RGB = _ColorConvertWebtoRGB($WebHex)
	$Convert = BitOR($RGB2HSL, $RGB2HSV, $RGB2CMYK)

	Convert()
EndFunc	; WebKeyIn()

;
;
;
Func WebUpdate()
	GUICtrlSetData($Web, $WebHex)
EndFunc ; WebUpdate()

;
;
;
Func _ColorConvertRGBtoWeb($avArray)
	If UBound($avArray) <> 3 Or UBound($avArray, 0) <> 1 Then Return SetError(1, 10, 0)

	for $i = 0 to 2
		$avArray[$i] *= $_COLORCONSTANTS_RGBMAX
	Next

	Return Hex($avArray[0], 2) & Hex($avArray[1], 2) & Hex($avArray[2], 2)
EndFunc	; _ColorConvertRGBtoWeb()

;
;
;
Func _ColorConvertWebtoRGB($WebHex)
	If (StringLeft($WebHex, 1) <> "#") Then Return SetError(1, 11, 0)

	Local $avArray[3]

	$WebHex = StringTrimLeft($WebHex, 1)

	$avArray[0] = Dec(StringLeft($WebHex, 2)) / $_COLORCONSTANTS_RGBMAX
	$avArray[1] = Dec(StringMid($WebHex, 3, 2)) / $_COLORCONSTANTS_RGBMAX
	$avArray[2] = Dec(StringRight($WebHex, 2)) / $_COLORCONSTANTS_RGBMAX

	Return $avArray
EndFunc	; _ColorConvertWebtoRGB()

;
;
;
Func ValueA1DToA2D($avArrayI, ByRef $avArrayO)
	If (UBound($avArrayI) < UBound($avArrayO)) Or ((UBound($avArrayI, 0) <> 1) And (UBound($avArrayO, 0) <> 2)) Then Return SetError(1, 20, 0)

	For $i = 0 To UBound($avArrayO)-1
		$avArrayO[$i][1] = $avArrayI[$i]
	Next
EndFunc	; ValueA1DToA2D()

;
;
;
Func ValueA2DToA1D($avArrayI, ByRef $avArrayO)
	If (UBound($avArrayI) > UBound($avArrayO)) Or (UBound($avArrayI, 0) <> 2) Or (UBound($avArrayO, 0) <> 1) Then Return SetError(1, 30, 0)

	For $i = 0 To UBound($avArrayO)-1
		$avArrayO[$i] = $avArrayI[$i][1]
	Next
EndFunc ; ValueA2DToA1D()
