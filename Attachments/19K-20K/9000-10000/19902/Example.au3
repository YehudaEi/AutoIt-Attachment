#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <Color Variation.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Color Variations", 312, 219, 193, 125)
GUICtrlCreateLabel("RGX Hex #1:", 8, 11, 68, 17)
$1HEX = GUICtrlCreateInput("", 8, 32, 89, 21)
$1HEXColor = GUICtrlCreateLabel("", 24, 88, 33, 33)
GUICtrlCreateLabel("Color Preview:", 8, 56, 72, 17)

GUICtrlCreateLabel("Red: ", 8, 139, 30, 17)
$1Red = GUICtrlCreateInput("", 48, 136, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateLabel("Green:", 8, 163, 36, 17)
$1Green = GUICtrlCreateInput("", 48, 160, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateLabel("Blue:", 8, 187, 28, 17)
$1Blue = GUICtrlCreateInput("", 48, 184, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))

GUICtrlCreateGroup("", 104, 8, 1, 201)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateLabel("Red:", 112, 139, 27, 17)
$vRed = GUICtrlCreateInput("", 152, 136, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateLabel("Green:", 112, 163, 36, 17)
$vGreen = GUICtrlCreateInput("", 152, 160, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateLabel("Blue:", 112, 187, 28, 17)
$vBlue = GUICtrlCreateInput("", 152, 184, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))

GUICtrlCreateGroup("", 104, 120, 97, 9)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("", 208, 8, 1, 201)
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateLabel("Variation Hex:", 112, 11, 73, 17)
$vHEX = GUICtrlCreateInput("", 112, 32, 89, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateLabel("Color Preview:", 120, 56, 72, 17)
$vHEXColor = GUICtrlCreateLabel("", 134, 88, 33, 33)
GUICtrlSetBkColor(-1, 0xff0000)

GUICtrlCreateLabel("RGX Hex #2:", 216, 11, 68, 17)
$2HEX = GUICtrlCreateInput("", 216, 32, 89, 21)
GUICtrlCreateLabel("Color Preview:", 216, 56, 72, 17)
$2HEXColor = GUICtrlCreateLabel("", 240, 88, 33, 33)

GUICtrlCreateLabel("Red:", 216, 136, 27, 17)
$2Red = GUICtrlCreateInput("", 256, 136, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateLabel("Green:", 216, 160, 36, 17)
$2Green = GUICtrlCreateInput("", 256, 160, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlCreateLabel("Blue:", 216, 184, 28, 17)
$2Blue = GUICtrlCreateInput("", 256, 184, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUISetState(@SW_SHOW)

Local $1Color, $2Color, $vColor
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
	If $1Color <> GUICtrlRead($1HEX) Then
		$1Color = GUICtrlRead($1HEX)
		If StringLeft($1Color, 2) <> "0x" Then $1Color = "0x" & $1Color
		$1RGB = _ColorHexToRGB($1Color)
		GUICtrlSetData($1Red, $1RGB[0])
		GUICtrlSetData($1Green, $1RGB[1])
		GUICtrlSetData($1Blue, $1RGB[2])
		GUICtrlSetBkColor($1HEXColor, $1Color)
		$vColor = 1
	EndIf
	If $2Color <> GUICtrlRead($2HEX) Then
		$2Color = GUICtrlRead($2HEX)
		If StringLeft($2Color, 2) <> "0x" Then $2Color = "0x" & $2Color
		$2RGB = _ColorHexToRGB($2Color)
		GUICtrlSetData($2Red, $2RGB[0])
		GUICtrlSetData($2Green, $2RGB[1])
		GUICtrlSetData($2Blue, $2RGB[2])
		GUICtrlSetBkColor($2HEXColor, $2Color)
		$vColor = 1
	EndIf
	If $1Color <> "" AND $2Color <> "" And $vColor = 1 Then
		Local $vVari = _ColorGetVariation($1Color, $2Color, 0)
		GUICtrlSetData($vRed, $vVari[0])
		GUICtrlSetData($vGreen, $vVari[1])
		GUICtrlSetData($vBlue, $vVari[2])
		Local $nColor = _ColorRGBToHex($vVari[0], $vVari[1], $vVari[2]) 
		GUICtrlSetData($vHEX, $nColor)
		GUICtrlSetBkColor($vHEXColor, $nColor)
		$vColor = 0
	EndIf
		
WEnd
