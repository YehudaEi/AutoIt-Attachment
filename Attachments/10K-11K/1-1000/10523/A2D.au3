#include-once
#include <misc.au3>
Global Const $KEY_ALT			= "12"
Global Const $KEY_PAUSE			= "13"
Global Const $KEY_CAPSLOCK		= "14"
Global Const $KEY_ESC			= "1B"
Global Const $KEY_SPACEBAR		= "20"
Global Const $KEY_PAGEUP		= "21"
Global Const $KEY_PAGEDOWN		= "22"
Global Const $KEY_END			= "23"
Global Const $KEY_HOME			= "24"
Global Const $KEY_LEFTARROW		= "25"
Global Const $KEY_UPARROW		= "26"
Global Const $KEY_RIGHTARROW	= "27"
Global Const $KEY_DOWNARROW		= "28"
Global Const $KEY_SELECT		= "29"
Global Const $KEY_PRINT	 		= "2A"
Global Const $KEY_EXECUTE		= "2B"
Global Const $KEY_PRINTSCREEN   = "2C"
Global Const $KEY_INSERT		= "2D"
Global Const $KEY_DELETE		= "2E"
Global 		 Enum $KEY_0        = 30, $KEY_1, $KEY_2, $KEY_3, $KEY_4, $KEY_5, $KEY_6, $KEY_7, $KEY_8, $KEY_9, $KEY_A = 41, $KEY_B, $KEY_C, $KEY_D, $KEY_E, $KEY_F, $KEY_G, $KEY_H, $KEY_I, $KEY_J = "4A", $KEY_K = "4B", $KEY_L = "4C", $KEY_M = "4D", $KEY_N = "4E", $KEY_O = "4F", $KEY_P = 50, $KEY_Q, $KEY_R, $KEY_S, $KEY_T, $KEY_U, $KEY_V, $KEY_W, $KEY_X, $KEY_Y, $KEY_Z = "5A"
Global Const $KEY_LWINKEY       = "5B"
Global Const $KEY_RWINKEY 		= "5C"
Global 		 Enum $NUMPAD_0 	= 60, $NUMPAD_1, $NUMPAD_2, $NUMPAD_3, $NUMPAD_4, $NUMPAD_5, $NUMPAD_6, $NUMPAD_7, $NUMPAD_8, $NUMPAD_9
Global Const $KEY_MULTIPLY 		= "6A"
Global Const $KEY_ADD			= "6B"
Global Const $KEY_SEPERATOR		= "6C"
Global Const $KEY_SUBTRACT		= "6D"
Global Const $KEY_DECIMAL		= "6E"
Global Const $KEY_DIVIDE		= "6F"
Global 		 Enum $KEY_F1 = 70, $KEY_F2, $KEY_F3, $KEY_F4, $KEY_F5, $KEY_F6, $KEY_F7, $KEY_F8, $KEY_F9, $KEY_F10
Global Const $KEY_F11 = "7A"
Global Const $KEY_F12 = "7B"

Func GetLastKeyPressed()
	return $CHAR_LASTKEY
EndFunc

Func SetLastKeyPressed($LastKey)
	$CHAR_LASTKEY = $LastKey
EndFunc
;Taken from: http://www.w3schools.com/tags/ref_colornames.asp
;A2D Colors
Global Const $C_AliceBlue  = 0xF0F8FF   
Global Const $C_AntiqueWhite  = 0xFAEBD7   
Global Const $C_Aqua  = 0x00FFFF   
Global Const $C_Aquamarine  = 0x7FFFD4   
Global Const $C_Azure  = 0xF0FFFF   
Global Const $C_Beige  = 0xF5F5DC   
Global Const $C_Bisque  = 0xFFE4C4   
Global Const $C_Black  = 0x000000   
Global Const $C_BlanchedAlmond  = 0xFFEBCD   
Global Const $C_Blue  = 0x0000FF   
Global Const $C_BlueViolet  = 0x8A2BE2   
Global Const $C_Brown  = 0xA52A2A   
Global Const $C_BurlyWood  = 0xDEB887   
Global Const $C_CadetBlue  = 0x5F9EA0   
Global Const $C_Chartreuse  = 0x7FFF00   
Global Const $C_Chocolate  = 0xD2691E   
Global Const $C_Coral  = 0xFF7F50   
Global Const $C_CornflowerBlue  = 0x6495ED   
Global Const $C_Cornsilk  = 0xFFF8DC   
Global Const $C_Crimson  = 0xDC143C   
Global Const $C_Cyan  = 0x00FFFF   
Global Const $C_DarkBlue  = 0x00008B   
Global Const $C_DarkCyan  = 0x008B8B   
Global Const $C_DarkGoldenRod  = 0xB8860B   
Global Const $C_DarkGray  = 0xA9A9A9   
Global Const $C_DarkGreen  = 0x006400   
Global Const $C_DarkKhaki  = 0xBDB76B   
Global Const $C_DarkMagenta  = 0x8B008B   
Global Const $C_DarkOliveGreen  = 0x556B2F   
Global Const $C_Darkorange  = 0xFF8C00   
Global Const $C_DarkOrchid  = 0x9932CC   
Global Const $C_DarkRed  = 0x8B0000   
Global Const $C_DarkSalmon  = 0xE9967A   
Global Const $C_DarkSeaGreen  = 0x8FBC8F   
Global Const $C_DarkSlateBlue  = 0x483D8B   
Global Const $C_DarkSlateGray  = 0x2F4F4F   
Global Const $C_DarkTurquoise  = 0x00CED1   
Global Const $C_DarkViolet  = 0x9400D3   
Global Const $C_DeepPink  = 0xFF1493   
Global Const $C_DeepSkyBlue  = 0x00BFFF   
Global Const $C_DimGray  = 0x696969   
Global Const $C_DodgerBlue  = 0x1E90FF   
Global Const $C_Feldspar  = 0xD19275   
Global Const $C_FireBrick  = 0xB22222   
Global Const $C_FloralWhite  = 0xFFFAF0   
Global Const $C_ForestGreen  = 0x228B22   
Global Const $C_Fuchsia  = 0xFF00FF   
Global Const $C_Gainsboro  = 0xDCDCDC   
Global Const $C_GhostWhite  = 0xF8F8FF   
Global Const $C_Gold  = 0xFFD700   
Global Const $C_GoldenRod  = 0xDAA520   
Global Const $C_Gray  = 0x808080   
Global Const $C_Green  = 0x008000   
Global Const $C_GreenYellow  = 0xADFF2F   
Global Const $C_HoneyDew  = 0xF0FFF0   
Global Const $C_HotPink  = 0xFF69B4   
Global Const $C_IndianRed   = 0xCD5C5C   
Global Const $C_Indigo   = 0x4B0082   
Global Const $C_Ivory  = 0xFFFFF0   
Global Const $C_Khaki  = 0xF0E68C   
Global Const $C_Lavender  = 0xE6E6FA   
Global Const $C_LavenderBlush  = 0xFFF0F5   
Global Const $C_LawnGreen  = 0x7CFC00   
Global Const $C_LemonChiffon  = 0xFFFACD   
Global Const $C_LightBlue  = 0xADD8E6   
Global Const $C_LightCoral  = 0xF08080   
Global Const $C_LightCyan  = 0xE0FFFF   
Global Const $C_LightGoldenRodYellow  = 0xFAFAD2   
Global Const $C_LightGrey  = 0xD3D3D3   
Global Const $C_LightGreen  = 0x90EE90   
Global Const $C_LightPink  = 0xFFB6C1   
Global Const $C_LightSalmon  = 0xFFA07A   
Global Const $C_LightSeaGreen  = 0x20B2AA   
Global Const $C_LightSkyBlue  = 0x87CEFA   
Global Const $C_LightSlateBlue  = 0x8470FF   
Global Const $C_LightSlateGray  = 0x778899   
Global Const $C_LightSteelBlue  = 0xB0C4DE   
Global Const $C_LightYellow  = 0xFFFFE0   
Global Const $C_Lime  = 0x00FF00   
Global Const $C_LimeGreen  = 0x32CD32   
Global Const $C_Linen  = 0xFAF0E6   
Global Const $C_Magenta  = 0xFF00FF   
Global Const $C_Maroon  = 0x800000   
Global Const $C_MediumAquaMarine  = 0x66CDAA   
Global Const $C_MediumBlue  = 0x0000CD   
Global Const $C_MediumOrchid  = 0xBA55D3   
Global Const $C_MediumPurple  = 0x9370D8   
Global Const $C_MediumSeaGreen  = 0x3CB371   
Global Const $C_MediumSlateBlue  = 0x7B68EE   
Global Const $C_MediumSpringGreen  = 0x00FA9A   
Global Const $C_MediumTurquoise  = 0x48D1CC   
Global Const $C_MediumVioletRed  = 0xC71585   
Global Const $C_MidnightBlue  = 0x191970   
Global Const $C_MintCream  = 0xF5FFFA   
Global Const $C_MistyRose  = 0xFFE4E1   
Global Const $C_Moccasin  = 0xFFE4B5   
Global Const $C_NavajoWhite  = 0xFFDEAD   
Global Const $C_Navy  = 0x000080   
Global Const $C_OldLace  = 0xFDF5E6   
Global Const $C_Olive  = 0x808000   
Global Const $C_OliveDrab  = 0x6B8E23   
Global Const $C_Orange  = 0xFFA500   
Global Const $C_OrangeRed  = 0xFF4500   
Global Const $C_Orchid  = 0xDA70D6   
Global Const $C_PaleGoldenRod  = 0xEEE8AA   
Global Const $C_PaleGreen  = 0x98FB98   
Global Const $C_PaleTurquoise  = 0xAFEEEE   
Global Const $C_PaleVioletRed  = 0xD87093   
Global Const $C_PapayaWhip  = 0xFFEFD5   
Global Const $C_PeachPuff  = 0xFFDAB9   
Global Const $C_Peru  = 0xCD853F   
Global Const $C_Pink  = 0xFFC0CB   
Global Const $C_Plum  = 0xDDA0DD   
Global Const $C_PowderBlue  = 0xB0E0E6   
Global Const $C_Purple  = 0x800080   
Global Const $C_Red  = 0xFF0000   
Global Const $C_RosyBrown  = 0xBC8F8F   
Global Const $C_RoyalBlue  = 0x4169E1   
Global Const $C_SaddleBrown  = 0x8B4513   
Global Const $C_Salmon  = 0xFA8072   
Global Const $C_SandyBrown  = 0xF4A460   
Global Const $C_SeaGreen  = 0x2E8B57   
Global Const $C_SeaShell  = 0xFFF5EE   
Global Const $C_Sienna  = 0xA0522D   
Global Const $C_Silver  = 0xC0C0C0   
Global Const $C_SkyBlue  = 0x87CEEB   
Global Const $C_SlateBlue  = 0x6A5ACD   
Global Const $C_SlateGray  = 0x708090   
Global Const $C_Snow  = 0xFFFAFA   
Global Const $C_SpringGreen  = 0x00FF7F   
Global Const $C_SteelBlue  = 0x4682B4   
Global Const $C_Tan  = 0xD2B48C   
Global Const $C_Teal  = 0x008080   
Global Const $C_Thistle  = 0xD8BFD8   
Global Const $C_Tomato  = 0xFF6347   
Global Const $C_Turquoise  = 0x40E0D0   
Global Const $C_Violet  = 0xEE82EE   
Global Const $C_VioletRed  = 0xD02090   
Global Const $C_Wheat  = 0xF5DEB3   
Global Const $C_White  = 0xFFFFFF   
Global Const $C_WhiteSmoke  = 0xF5F5F5   
Global Const $C_Yellow  = 0xFFFF00   
Global Const $C_YellowGreen  = 0x9ACD32 
Global $A2D_CUR_BGCOLOR = 0x0
Global $A2D_SURFACE_OBJECTS[10000] ;Playing it safe, using a 10,000 element array for all the objects.. this means you can only manipulate up to 10000 objects per Frame
Global $A2D_OBJECT_COUNT = 0
Global $A2D_SURFACE_INFO[4] ;[0] = Surface X, [1]Surface Y, [2]Surface Width, [3]Surface HEight
Func _A2DCreateSurface($nX, $nY, $nWidth, $nHeight, $C_BGCOLOR)
	$A2D_SURFACE_INFO[0] = $nX
	$A2D_SURFACE_INFO[1] = $nY
	$A2D_SURFACE_INFO[2] = $nWidth
	$A2D_SURFACE_INFO[3] = $nHeight
	$retVal = GUICtrlCreateGraphic($nX, $nY, $nWidth, $nHeight)
	GUICtrlSetBkColor($retVal, $C_BGCOLOR)
	$A2D_CUR_BGCOLOR	= $C_BGCOLOR
	Return $retVal
EndFunc

Func _A2DSetSurfaceColor($surface, $c_color)
	$A2D_CUR_BGCOLOR = $c_color
	GUICtrlSetBkColor($surface, $c_color)
EndFunc
;=========================STATIC DRAWINGS================================----> 2D SHAPES ONLY!
Func _A2DDrawPixel($A2D_SURFACE, $nX, $nY, $C_COLOR)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_COLOR, $C_COLOR)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_PIXEL, $nX, $nY)
	$length_WIDTH = 1
	$length_HEIGHT = 1
	$A2D_OBJECT_COUNT += 1
EndFunc

Func _A2DDrawLine($A2D_SURFACE, $nX, $nY, $nX2, $nY2, $nSize, $C_COLOR)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_MOVE, $nX, $nY)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_PENSIZE, $nSize)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_COLOR, $C_COLOR)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_LINE, $nX2, $nY2)
	$A2D_OBJECT_COUNT += 1
EndFunc

Func _A2DDrawRectangle($A2D_SURFACE, $nX, $nY, $length_WIDTH, $height_HEIGHT, $nSize, $C_COLOR, $C_FILLCOLOR = -2)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_PENSIZE, $nSize)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_COLOR, $C_COLOR, $C_FILLCOLOR)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_RECT, $nX, $nY, $length_Width, $height_Height)
	$A2D_OBJECT_COUNT += 1
	Return $A2D_OBJECT_COUNT
	;_A2DDrawLine($A2D_SURFACE, $nX, $nY, $nX+$length_WIDTH, $nY, $nSize, $C_COLOR)
	;_A2DDrawLine($A2D_SURFACE, $nX, $nY, $nX, $nY+$height_HEIGHT, $nSize, $C_COLOR)
	;_A2DDrawLine($A2D_SURFACE, $nX, $nY+$height_HEIGHT, $nX+$length_WIDTH, $nY+$height_HEIGHT, $nSize, $C_COLOR)
	;_A2DDrawLine($A2D_SURFACE, $nX+$length_WIDTH, $nY, $nX+$length_WIDTH, $nY+$height_HEIGHT, $nSize, $C_COLOR)
EndFunc

Func _A2DDrawText($text, $nX, $nY, $nWidth, $nHeight, $C_COLOR)
	$retVal = GUICtrlCreateLabel($text, $nX, $nY, $nWidth, $nHeight)
	GUICtrlSetBkColor($retVal, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor($retVal, $C_COLOR)
	$A2D_OBJECT_COUNT += 1
	return $retVal
EndFunc

Func _A2DDrawImage($filename, $nX, $nY, $nWidth, $nHeight)
	$retVal = GUICtrlCreatePic($filename, $nX, $nY, $nWidth, $nHeight)
	GUICtrlSetBkColor($retVal, $GUI_BKCOLOR_TRANSPARENT)
	$A2D_OBJECT_COUNT += 1
	return $retVal
EndFunc

Func _A2DDrawCircle($A2D_SURFACE, $nX, $nY, $nWidth, $nHeight, $nSize, $C_COLOR, $C_FILLCOLOR = -2) ;width=height = circle ;)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_PENSIZE, $nSize)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_COLOR, $C_COLOR, $C_FILLCOLOR)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_ELLIPSE, $nX, $nY, $nWidth, $nHeight)
	$A2D_OBJECT_COUNT += 1
	Return $A2D_OBJECT_COUNT
EndFunc

Func _A2DDrawTriangle($A2D_SURFACE, $nX1, $nY1, $nX2, $nY2, $nX3, $nY3, $nSize, $C_COLOR)
	_A2DDrawLine($A2D_SURFACE, $nX1, $nY1, $nX2, $nY2, $nSize, $C_COLOR)
	_A2DDrawLine($A2D_SURFACE, $nX2, $nY2, $nX3, $nY3, $nSize, $C_COLOR)
	_A2DDrawLine($A2D_SURFACE, $nX3, $nY3, $nX1, $nY1, $nSize, $C_COLOR)
	$A2D_OBJECT_COUNT += 1
	Return $A2D_OBJECT_COUNT
EndFunc

Func _A2DClearSurface($A2D_SURFACE, ByRef $NewSurface)
	GUICtrlDelete($A2D_SURFACE)
	$NewSurface = GUICtrlCreateGraphic($A2D_SURFACE_INFO[0], $A2D_SURFACE_INFO[1], $A2D_SURFACE_INFO[2], $A2D_SURFACE_INFO[3])
	GUICtrlSetBkColor($NewSurface, $A2D_CUR_BGCOLOR)
	$A2D_OBJECT_COUNT = 0
EndFunc

Func _A2DMakeGradient($hInitialColor, $hFinalColor, $iReturnSize) ;Gradient Function done by: 
    $hInitialColor = Hex($hInitialColor, 6)
    $hFinalColor = Hex($hFinalColor, 6)
    
    Local $iRed1 	     = Dec (StringLeft($hInitialColor, 2))
    Local $iGreen1 		 = Dec (StringMid($hInitialColor, 3, 2))
    Local $iBlue1 		 = Dec (StringMid($hInitialColor, 5, 2))
    
    Local $iRed2 		 = Dec (StringLeft($hFinalColor, 2))
    Local $iGreen2 		 = Dec (StringMid($hFinalColor, 3, 2))
    Local $iBlue2 		 = Dec (StringMid($hFinalColor, 5, 2))
    
    Local $iPlusRed 	 = ($iRed2-$iRed1)/($iReturnSize-1)
    Local $iPlusBlue 	 = ($iBlue2-$iBlue1)/($iReturnSize-1)
    Local $iPlusGreen 	 = ($iGreen2-$iGreen1)/($iReturnSize-1)
    
    Dim $iColorArray[$iReturnSize]
    For $i = 0 To $iReturnSize-1
        $iNowRed 		 = Floor($iRed1 + ($iPlusRed*$i))
        $iNowBlue		 = Floor($iBlue1 + ($iPlusBlue*$i))
        $iNowGreen 		 = Floor($iGreen1 + ($iPlusGreen*$i))
        $iColorArray[$i] = Dec (Hex($iNowRed, 2) & Hex($iNowGreen, 2) & Hex($iNowBlue, 2))
    Next
    Return ($iColorArray)
EndFunc

Func _A2DUpdate($A2D_SURFACE)
	GUICtrlSetGraphic($A2D_SURFACE, $GUI_GR_REFRESH)
EndFunc