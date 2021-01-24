; #INDEX#    ====================================================================================================================
;	Author.........: Lynie
;	Library name...: ColorLib
;	Library version: 1.0 BETA
; 	Include file: <ColorLib.au3>
;
;	Comment applet: Found in include files of AutoIt.
; ===============================================================================================================================


; #INCLUDES# ====================================================================================================================
#Include <Color.au3>

; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _GetCorrectColor
; Description ...: Returns the closest array color of the color you specify.
; Syntax.........: GetCorrectColor($strColor, $strColorCollection[])
; Parameters ....: $color				- The color that needs to be corrected
;                  |Accepts both hex as string
;                  $colorCollection[]	- An array whith the colors the function should choose of
;                  |Accepts both hex as string arrays
; Return values .: $correctColor		- The correct color
; Author ........: Lynie
; Locals ........: $redDiff
;				   $greenDiff
;				   $blueDiff
;				   $correctColor
; ===============================================================================================================================
Func _GetCorrectColor($color, $colorCollection)
	Local $redDiff = 255, $greenDiff = 255, $blueDiff = 255
	Local $correctColor = "0xFFFFFF"
	
	For $i = 0 To UBound($colorCollection) - 1
		If($redDiff < ( _ColorGetRed($colorCollection[$i]) - _ColorGetRed($color))) Or _
			($greenDiff < (_ColorGetGreen($colorCollection[$i]) - _ColorGetGreen($color))) Or _
			($blueDiff < (_ColorGetBlue($colorCollection[$i]) - _ColorGetBlue($color))) Then
				$correctColor 	= 	$colorCollection[$i]
				;DEBUG - MsgBox(64, "ColorLib" & $colorCollection[$i], "Value: " & $colorCollection[$i] & " Index: " & $i & " Reach: " & UBound($colorCollection))
				;DEBUG - MsgBox(64, "ColorLib" & $colorCollection[$i], "Red: " & _ColorGetRed($color) & " Green: " & _ColorGetGreen($color) & " Blue: " & _ColorGetBlue($color))
				;DEBUG - MsgBox(64, "ColorLib" & $colorCollection[$i], "RedDiff: " & $redDiff & " GreenDiff: " & $greenDiff & " BlueDiff: " & $blueDiff)
		EndIf
		$redDiff 		= 	 _ColorGetRed($colorCollection[$i]) 	- _ColorGetRed($color)
		$greenDiff 		= 	 _ColorGetGreen($colorCollection[$i]) 	- _ColorGetGreen($color)
		$blueDiff 		=	 _ColorGetBlue($colorCollection[$i]) 	- _ColorGetBlue($color)
	Next
	Return $correctColor
EndFunc ;==>_GetCorrectColor