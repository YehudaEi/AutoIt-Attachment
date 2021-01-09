#include-Once

; #INDEX# =========================================================================================
; Title .........: CoolColor
; AutoIt Version : 3.2.3++
; Language ..... : English
; Description ...: This module contains various functions that assist with color management.
;                  Use the current color.au3 include file except the input and output value
;                 is with 0 and 1.
; =================================================================================================

; #CURRENT# =======================================================================================
;_ColorConvertHSLtoRGB
;_ColorConvertRGBtoHSL
;_ColorConvertHSVtoRGB
;_ColorConvertRGBtoHSV
;_ColorConvertRGBtoCMYK
;_ColorGetBlue
;_ColorGetGreen
;_ColorGetRed
; =================================================================================================

; #INTERNAL_USE_ONLY#==============================================================================
; __ColorConvertHueToRGB
; =================================================================================================

; #FUNCTION# ======================================================================================
; Name...........: _ColorConvertHSLtoRGB
; Description ...: Converts HSL to RGB
; Syntax.........: _ColorConvertHSLtoRGB($avArray)
; Parameters ....: $avArray - An array containing HSL values [0, 1] in their respective positions
; Return values .: Success - The array containing the RGB values [0, 1] for the inputted HSL values
;                  Failure - 0, sets @error to 1
; Author ........: Ultima
; Modified.......:
; Remarks .......: See: <a href="                                               ">EasyRGB - Color mathematics and conversion formulas.</a>
; Related .......: _ColorConvertRGBtoHSL
; Link ..........;
; Example .......; Yes
; =================================================================================================
Func _ColorConvertHSLtoRGB($avArray)
	If UBound($avArray) <> 3 Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, 0)

	Local $nR, $nG, $nB
	Local $nH = Number($avArray[0])
	Local $nS = Number($avArray[1])
	Local $nL = Number($avArray[2])

	If $nS = 0 Then
		; Grayscale
		$nR = $nL
		$nG = $nL
		$nB = $nL
	Else
		; Chromatic
		Local $nValA, $nValB

		If $nL <= 0.5 Then
			$nValB = $nL * ($nS + 1)
		Else
			$nValB = ($nL + $nS) - ($nL * $nS)
		EndIf

		$nValA = 2 * $nL - $nValB
		$nR = __ColorConvertHueToRGB($nValA, $nValB, $nH + 1 / 3)
		$nG = __ColorConvertHueToRGB($nValA, $nValB, $nH)
		$nB = __ColorConvertHueToRGB($nValA, $nValB, $nH - 1 / 3)
	EndIf

	$avArray[0] = $nR
	$avArray[1] = $nG
	$avArray[2] = $nB

	Return $avArray
EndFunc   ;==>_ColorConvertHSLtoRGB

; #INTERNAL_USE_ONLY# =============================================================================
; Name...........: __ColorConvertHueToRGB
; Description ...: Helper function for converting HSL to RGB
; Syntax.........: __ColorConvertHueToRGB($nA, $nB, $nH)
; Parameters ....: $nA - Value A
;                  $nB - Value B
;                  $nH - Hue
; Return values .: A value based on value A and value B, dependent on the inputted hue
; Author ........: Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......: See: <a href="                                               ">EasyRGB - Color mathematics and conversion formulas.</a>
; Link ..........;
; Example .......;
; =================================================================================================
Func __ColorConvertHueToRGB($nA, $nB, $nH)
	If $nH < 0 Then $nH += 1
	If $nH > 1 Then $nH -= 1

	If (6 * $nH) < 1 Then Return $nA + ($nB - $nA) * 6 * $nH
	If (2 * $nH) < 1 Then Return $nB
	If (3 * $nH) < 2 Then Return $nA + ($nB - $nA) * 6 * (2 / 3 - $nH)
	Return $nA
EndFunc   ;==>__ColorConvertHueToRGB

; #FUNCTION# ======================================================================================
; Name...........: _ColorConvertRGBtoHSL
; Description ...: Converts RGB to HSL
; Syntax.........: _ColorConvertRGBtoHSL($avArray)
; Parameters ....: $avArray - An array containing RGB values [0, 1] in their respective positions
; Return values .: Success - The array containing the HSL values [0, 1] for the inputted RGB values
;                  Failure - 0, sets @error to 1
; Author ........: Ultima
; Modified.......:
; Remarks .......: See: <a href="                                               ">EasyRGB - Color mathematics and conversion formulas.</a>
; Related .......: _ColorConvertHSLtoRGB
; Link ..........;
; Example .......;
; =================================================================================================
Func _ColorConvertRGBtoHSL($avArray)
	If UBound($avArray) <> 3 Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, 0)

	Local $nH, $nS, $nL
	Local $nR = Number($avArray[0])
	Local $nG = Number($avArray[1])
	Local $nB = Number($avArray[2])

	Local $nMax = $nR
	If $nMax < $nG Then $nMax = $nG
	If $nMax < $nB Then $nMax = $nB

	Local $nMin = $nR
	If $nMin > $nG Then $nMin = $nG
	If $nMin > $nB Then $nMin = $nB

	Local $nMinMaxSum = ($nMax + $nMin)
	Local $nMinMaxDiff = ($nMax - $nMin)

	; Lightness
	$nL = $nMinMaxSum / 2

	If $nMinMaxDiff = 0 Then
		; Grayscale
		$nH = 0
		$nS = 0
	Else
		; Saturation
		If $nL <= 0.5 Then
			$nS = $nMinMaxDiff / $nMinMaxSum
		Else
			$nS = $nMinMaxDiff / (2 - $nMinMaxSum)
		EndIf

		; Hue
		Switch $nMax
			Case $nR
				$nH = ($nG - $nB) / (6 * $nMinMaxDiff)
			Case $nG
				$nH = ($nB - $nR) / (6 * $nMinMaxDiff) + 1 / 3
			Case $nB
				$nH = ($nR - $nG) / (6 * $nMinMaxDiff) + 2 / 3
		EndSwitch
		If $nH < 0 Then $nH += 1
		If $nH > 1 Then $nH -= 1
	EndIf

	$avArray[0] = $nH
	$avArray[1] = $nS
	$avArray[2] = $nL

	Return $avArray
EndFunc   ;==>_ColorConvertRGBtoHSL

; #FUNCTION# ======================================================================================
; Name...........: _ColorConvertHSVtoRGB
; Description ...: Converts HSV to RGB
; Syntax.........: _ColorConvertHSVtoRGB($avArray)
; Parameters ....: $avArray - An array containing HSV values [0, 1] in their respective positions
; Return values .: Success - The array containing the RGB values [0, 1] for the inputted HSV values
;                  Failure - 0, sets @error to 1
; Author ........: Ultima
; Modified.......:
; Remarks .......: See: <a href="                                               ">EasyRGB - Color mathematics and conversion formulas.</a>
; Related .......: _ColorConvertRGBtoHSV
; Link ..........;
; Example .......; Yes
; =================================================================================================
Func _ColorConvertHSVtoRGB($avArray)
	If UBound($avArray) <> 3 Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, 0)

	Local $nR, $nG, $nB
	Local $nH = Number($avArray[0])
	Local $nS = Number($avArray[1])
	Local $nV = Number($avArray[2])

	If $nS = 0 Then
		; Grayscale
		$nR = $nV
		$nG = $nV
		$nB = $nV
	Else
		; Chromatic
		Local $nValA, $nValB, $nValC
		Local $nValh = $nH * 6

		if ($nValh = 6) Then $nValh = 0      					; H must be < 1

		Local $nVali = Int($nValh)
		
		$nValA = $nV * (1 - $nS)
		$nValB = $nV * (1 - ($nS * ($nValh - $nVali)))
		$nValC = $nV * (1 - ($nS * (1 - ($nValh - $nVali))))

		Switch ($nVali)
			Case 0
				$nR = $nV
				$nG = $nValC
				$nB = $nValA

			Case 1
				$nR = $nValB
				$nG = $nV
				$nB = $nValA

			Case 2
				$nR = $nValA
				$nG = $nV
				$nB = $nValC

			Case 3
				$nR = $nValA
				$nG = $nValB
				$nB = $nV

			Case 4
				$nR = $nValC
				$nG = $nValA
				$nB = $nV

			Case Else
				$nR = $nV
				$nG = $nValA
				$nB = $nValB
		EndSwitch
	EndIf

	$avArray[0] = $nR
	$avArray[1] = $nG
	$avArray[2] = $nB

	Return $avArray
EndFunc   ;==>_ColorConvertHSVtoRGB

; #FUNCTION# ======================================================================================
; Name...........: _ColorConvertRGBtoHSV
; Description ...: Converts RGB to HSV
; Syntax.........: _ColorConvertRGBtoHSV($avArray)
; Parameters ....: $avArray - An array containing RGB values [0, 1] in their respective positions
; Return values .: Success - The array containing the HSL values [0, 1] for the inputted RGB values
;                  Failure - 0, sets @error to 1
; Author ........: Ultima
; Modified.......:
; Remarks .......: See: <a href="                                               ">EasyRGB - Color mathematics and conversion formulas.</a>
; Related .......: _ColorConvertHSVtoRGB
; Link ..........;
; Example .......;
; =================================================================================================
Func _ColorConvertRGBtoHSV($avArray)
	If UBound($avArray) <> 3 Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, 0)

	Local $nH, $nS, $nL
	Local $nR = Number($avArray[0])
	Local $nG = Number($avArray[1])
	Local $nB = Number($avArray[2])

	Local $nMax = $nR
	If $nMax < $nG Then $nMax = $nG
	If $nMax < $nB Then $nMax = $nB

	Local $nMin = $nR
	If $nMin > $nG Then $nMin = $nG
	If $nMin > $nB Then $nMin = $nB

	Local $nMinMaxDiff = ($nMax - $nMin)

	; Value
	$nV = $nMax

	If ($nMinMaxDiff = 0) Then
		; Grayscale
		$nH = 0
		$nS = 0
	Else
		; Saturation
		$nS = $nMinMaxDiff / $nMax

		; Hue
		Switch $nMax
			Case $nR
				$nH = ($nG - $nB) / (6 * $nMinMaxDiff)
			Case $nG
				$nH = ($nB - $nR) / (6 * $nMinMaxDiff) + 1 / 3
			Case $nB
				$nH = ($nR - $nG) / (6 * $nMinMaxDiff) + 2 / 3
		EndSwitch
		If $nH < 0 Then $nH += 1
		If $nH > 1 Then $nH -= 1
	EndIf

	$avArray[0] = $nH
	$avArray[1] = $nS
	$avArray[2] = $nV

	Return $avArray
EndFunc   ;==>_ColorConvertRGBtoHSV

; #FUNCTION# ======================================================================================
; Name...........: _ColorConvertCMYKtoRGB
; Description ...: Converts CMYK to RGB
; Syntax.........: _ColorConvertCMYKtoRGB($avArray)
; Parameters ....: $avArray - An array containing CMYK values [0, 1] in their respective positions
; Return values .: Success - The array containing the RGB values [0, 1] for the inputted CMYK values
;                  Failure - 0, sets @error to 1
; Author ........: Ultima
; Modified.......:
; Remarks .......: See: <a href="                                               ">EasyRGB - Color mathematics and conversion formulas.</a>
; Related .......: _ColorConvertRGBtoCMYK
; Link ..........;
; Example .......;
; =================================================================================================
Func _ColorConvertCMYKtoRGB($avArray)
	If UBound($avArray) <> 4 Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, 0)

	Local $nR, $nG, $nB

	Local $nC = Number($avArray[0])
	Local $nM = Number($avArray[1])
	Local $nY = Number($avArray[2])
	Local $nK = Number($avArray[3])

	$nR = 1 - ($nC * (1 - $nK) + $nK)
	$nG = 1 - ($nM * (1 - $nK) + $nK)
	$nB = 1 - ($nY * (1 - $nK) + $nK)

	ReDim $avArray[3]

	$avArray[0] = $nR
	$avArray[1] = $nG
	$avArray[2] = $nB
	
	Return $avArray
EndFunc   ;==>_ColorConvertCMYKtoRGB

; #FUNCTION# ======================================================================================
; Name...........: _ColorConvertRGBtoCMYK
; Description ...: Converts RGB to CMYK
; Syntax.........: _ColorConvertRGBtoCMYK($avArray)
; Parameters ....: $avArray - An array containing RGB values [0, 1] in their respective positions
; Return values .: Success - The array containing the CMY values [0, 1] for the inputted RGB values
;                  Failure - 0, sets @error to 1
; Author ........: Ultima
; Modified.......:
; Remarks .......: See: <a href="                                               ">EasyRGB - Color mathematics and conversion formulas.</a>
; Related .......: _ColorConvertCMYKtoRGB
; Link ..........;
; Example .......;
; =================================================================================================
Func _ColorConvertRGBtoCMYK($avArray)
	If UBound($avArray) <> 3 Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, 0)

	Local $nK
	Local $nC, $nM, $nY, $nK

	Local $nR = Number($avArray[0])
	Local $nG = Number($avArray[1])
	Local $nB = Number($avArray[2])

	Local $nK = 1 - $nR
	If $nK > (1 - $nG) Then $nK = 1 - $nG
	If $nK > (1 - $nB) Then $nK = 1 - $nB

	If ($nK = 1) Then											; Black
		$nC = 0
		$nM = 0
		$nY = 0
	Else
		$nC = (1 - $nR - $nK) / (1 - $nK)
		$nM = (1 - $nG - $nK) / (1 - $nK)
		$nY = (1 - $nB - $nK) / (1 - $nK)
	EndIf

	ReDim $avArray[4]

	$avArray[0] = $nC
	$avArray[1] = $nM
	$avArray[2] = $nY
	$avArray[3] = $nK
	
	Return $avArray
EndFunc   ;==>_ColorConvertRGBtoCMYK

; #FUNCTION# ======================================================================================
; Name...........: _ColorGetBlue
; Description ...: Returns the blue component of a given color.
; Syntax.........: _ColorGetBlue($nColor)
; Parameters ....: $nColor - The RGB color to work with (hexadecimal code).
; Return values .: Success - The component color in the range 0-255
; Author ........: Jonathan Bennett <jon at hiddensoft dot com>
; Modified.......:
; Remarks .......:
; Related .......: _ColorGetGreen, _ColorGetRed
; Link ..........;
; Example .......; Yes
; =================================================================================================
Func _ColorGetBlue($nColor)
	Return BitAND($nColor, 0xFF)
EndFunc   ;==>_ColorGetBlue

; #FUNCTION# ======================================================================================
; Name...........: _ColorGetGreen
; Description ...: Returns the green component of a given color.
; Syntax.........: _ColorGetGreen($nColor)
; Parameters ....: $nColor - The RGB color to work with (hexadecimal code).
; Return values .: Success - The component color in the range 0-255
; Author ........: Jonathan Bennett <jon at hiddensoft dot com>
; Modified.......:
; Remarks .......:
; Related .......: _ColorGetBlue, _ColorGetRed
; Link ..........;
; Example .......; Yes
; =================================================================================================
Func _ColorGetGreen($nColor)
	Return BitAND(BitShift($nColor, 8), 0xFF)
EndFunc   ;==>_ColorGetGreen

; #FUNCTION# ======================================================================================
; Name...........: _ColorGetRed
; Description ...: Returns the red component of a given color.
; Syntax.........: _ColorGetRed($nColor)
; Parameters ....: $nColor - The RGB color to work with (hexadecimal code).
; Return values .: Success - The component color in the range 0-255
; Author ........: Jonathan Bennett <jon at hiddensoft dot com>
; Modified.......:
; Remarks .......:
; Related .......: _ColorGetBlue, _ColorGetGreen
; Link ..........;
; Example .......; Yes
; =================================================================================================
Func _ColorGetRed($nColor)
	Return BitAND(BitShift($nColor, 16), 0xFF)
EndFunc   ;==>_ColorGetRed