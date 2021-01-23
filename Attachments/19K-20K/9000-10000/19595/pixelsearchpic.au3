#include-once
;===============================================================================
; Description:            _PixelSearchPic
; Parameter(s):			$picture - A 2 dimensional array of the hex colors in your "picture"
;						$transparent - The HEX color used as a 'pallate' color. (i.e. the specified color becomes transparent... it skips that color.)
;						$ishade - Optional: 0-255 value of the tolerance for the search. WARNING: This magnifies the search time exponentially... use sparingly.
;						$xTop - Optional: The x-coord of the top-left corner of the search filed. Default is 0.
;						$yTop - Optional: The y-coord of the top-left corner of the search filed. Default is 0.
;						$xBottom - Optional: The x-coord of the bottom-right corner of the search filed. Default is @DesktopWidth.
;						$yBottom - Optional: The y-coord of the bottom-right corner of the search filed. Default is @DesktopHeight.

; Requirement:          ??-Don't know-??

; Return Value(s):    Success: Returns a 2 dimensional array - the x and y coordinates of the upper-left corner of the found picture.
;						(For example: If the picture is found starting on pixel 123,124 it will return 123,124 in a 2dim array.)
;					  Faliure: Returns 0
;							Sets @ERROR to:	1 - Picture not found on screen
;											2 - "Picture" passed to function is not array
;											3 - Failed to find beginning pixel in array
;                            
; Author(s):            Many. Compiler of code is Brickoneer... several snippets taken from various others.
;===============================================================================

Func _PixelSearchPic($picture, $transparent, $ishade = 0, $xTop = 0, $yTop = 0, $xBottom = @DesktopWidth, $yBottom = @DesktopHeight)
	$trans = $transparent
	$shade = $ishade
	Dim $beginpixel[3]
	$failed = 0
	If IsArray($picture) = 0 Then
		SetError(2)
		Return 0
	EndIf
	$xbound = UBound($picture, 1) - 1
	$ybound = UBound($picture, 2) - 1
	For $a = 0 To $xbound
		For $b = 0 To $ybound
			If $picture[$a][$b] <> $trans Then
				$beginpixel[0] = $picture[$a][$b]
				$beginpixel[1] = $a
				$beginpixel[2] = $b
				$foundbeginpixel = 1
				ExitLoop (2)
			EndIf
		Next
	Next
	If $foundbeginpixel = 0 Then
		SetError(3)
		Return 0
	EndIf
	$startingpixels = _PixelSearchEx($xTop, $yTop, $xBottom, $yBottom, $beginpixel[0], $ishade)
	For $pixel = 1 To UBound($startingpixels, 1) - 1
		$failed = 0
		$xpos = $startingpixels[$pixel][0] - $beginpixel[1]
		$ypos = $startingpixels[$pixel][1] - $beginpixel[2]
		$y = 0
		$x = 0
		
		For $xtest = $xpos To $xpos + $xbound
			For $ytest = $ypos To $ypos + $ybound
				$pixelcolor = PixelGetColor($xtest, $ytest)
				$mapcolor = $picture[$x][$y]
				If $pixelcolor <> $mapcolor Then
					$test = TestTrans($pixelcolor, $mapcolor, $ishade)
					If $test = 0 Then
						$nextpixel = 0
					ElseIf $test = 1 Then
						$nextpixel = 1
					Else
						MsgBox(0, "FATAL!", "FATAL ERROR!")
						Exit
					EndIf
				Else
					$nextpixel = 1
				EndIf
				
				If $nextpixel = 0 And $picture[$x][$y] <> $trans Then
					$failed = 1
					ExitLoop (2)
				EndIf
				$y += 1
			Next
			$y = 0
			$x += 1
		Next
		$x = 0
		If $failed = 0 Then
			Dim $returnpixel[2]
			$returnpixel[0] = $xpos
			$returnpixel[1] = $ypos
			Return $returnpixel
		EndIf
	Next
	SetError(1)
	Return 0
EndFunc   ;==>PixelSearchPic

Func _PixelSearchEx($xTop, $yTop, $xBottom, $yBottom, $nColor, $ishade = 0, $iStep = 1)
	Local $aPix, $aCoords, $nYAdd, $iAdd
	For $xCC = $xTop To $xBottom
		$nYAdd = 0
		While $nYAdd <= $yBottom
			$aPix = PixelSearch($xCC, $yTop + $nYAdd, $xCC, $yBottom, $nColor, $ishade, $iStep)
			If Not IsArray($aPix) Then ExitLoop
			If Not IsArray($aCoords) Then Local $aCoords[1][2]
			$nYAdd += ($aPix[1] - $yTop) + 1
			$iAdd += 1
			ReDim $aCoords[$iAdd + 1][2]
			$aCoords[$iAdd][0] = $aPix[0]
			$aCoords[$iAdd][1] = $aPix[1]
		WEnd
	Next
	If IsArray($aCoords) Then Return $aCoords
	Return SetError(1, 0, 0)
EndFunc   ;==>_PixelSearchEx

Func TestTrans($RBG, $pixel, $shade = 0) ; color on screen, color that is saved, shade differnece... 0-255
	$mask = BitAND($RBG, 0xff0000)
	$mask = BitShift($mask, 16)
	$pix = BitAND($pixel, 0xff0000)
	$pix = BitShift($pix, 16)
	$difference = Abs($mask - $pix)
	If $difference > $shade Then
		Return 0
	EndIf
	
	$mask = BitAND($RBG, 0x00ff00)
	$mask = BitShift($mask, 8)
	$pix = BitAND($pixel, 0x00ff00)
	$pix = BitShift($pix, 8)
	$difference = Abs($mask - $pix)
	If $difference > $shade Then
		Return 0
	EndIf
	
	
	$mask = BitAND($RBG, 0x0000ff)
	$pix = BitAND($pixel, 0x0000ff)
	$difference = Abs($mask - $pix)
	If $difference > $shade Then
		Return 0
	EndIf
	
	Return 1
EndFunc   ;==>TestTrans