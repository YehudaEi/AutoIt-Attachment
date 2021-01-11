#include <guiconstants.au3>
;===============================================================================
;
; Description:      Converts 3 color values(red, green, blue) into a hex value.
; Syntax:           _RGBToHex($red_value, $green_value, $blue_value)
; Parameter(s):     $red_value - 0 - 255 RED.
;					$green_value - 0 - 255 GREEN.
;				    $blue_value - 0 - 255 BLUE.
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Hexadecimal value for the RGB color.
; Author(s):        Chris95219 <chris95219@gmail.com>
; Note(s):          None.
;
;===============================================================================
Func _RGBToHex($red_add, $green_add, $blue_add)
	$NEW =   Hex( $red_add ) & Hex( $green_add ) & Hex( $blue_add )
	$RED = StringTrimRight(StringTrimLeft($new, 6), 16)
	$GREEN = StringTrimRight(StringTrimLeft($new, 14), 8)
	$BLUE = StringTrimLeft($NEW, StringLen($NEW)-2)
	Return '0x' & $RED & $GREEN & $BLUE
EndFunc

;===============================================================================
;
; Description:      Converts a hexadecimal into its corresponding RGB values.
; Syntax:           _HexToRGB($color)
; Parameter(s):     $color - Hex value.
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array of 3 rgb values. [0] = red, [1] = green, [2] = blue.
; Author(s):        Chris95219 <chris95219@gmail.com>
; Note(s):          None.
;
;===============================================================================
Func _HexToRGB($color)
	$base        	= StringSplit(Hex($color, 6), "")
		    $RED 	= Dec( $base[1]&$base[2] )
			$GREEN 	= Dec( $base[3]&$base[4] )
			$BLUE 	= Dec( $base[5]&$base[6] )
			
	Local   $avColors[3]
		    $avColors[0] = $RED
		    $avColors[1] = $GREEN
		    $avColors[2] = $BLUE
	Return  $avColors
EndFunc


Func _CreateColor($rr, $gg, $bb)
	local $avcolor[3] = [$rr, $gg, $bb]
	Return $avcolor
EndFunc

Func _CreateAlpha($color1, $color2, $alpha)
	;$value = Hex( dec($color1)*(1.0-$alpha) + dec($color2)*($alpha), 6)
	$nRed = $color1[0] * $alpha + $color2[0] * (1.0 - $alpha)
	$nGreen = $color1[1] * $alpha + $color2[1] * (1.0 - $alpha)
	$nBlue = $color1[2] * $alpha + $color2[2] * (1.0 - $alpha)
	return (_RGBToHex($nRed, $nGreen, $nBlue))
EndFunc


