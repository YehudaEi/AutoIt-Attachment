; THIS IS NOT ACTUAL CODE; THIS IS JUST AN EXAMPLE....

; initialize $x and $y and $height
; .....
;
$result = ''
While $x < 100 ;suppose the max x coordinate in our textbox is 100

	;six-pixel wide checksum	
	$checksum = PixelChecksum($x, $y, $x+6, $y+$HEIGHT)
	
	If $checksum = $DIGIT_ZERO Then
		$result = $result & "0"
		$x = $x + 6  ;advance x by the width of the character we just matched
		ContinueLoop ;we found a match, so don't bother computing three-pixel checksum
	ElseIf $checksum = $DIGIT_ONE Then
		$result = $result & "1"
		$x = $x + 6
		ContinueLoop
	;...
	ElseIf $checksum = $DIGIT_NINE Then
		$result = $result & "2"
		$x = $x + 6
		ContinueLoop
	EndIf
	
	
	;two-pixel wide checksum
	$checksum = PixelChecksum($x, $y, $x+2, $y+$HEIGHT)
	
	If $checksum = $PERIOD Then
		$result = $result & "."
		$x = $x + 3
		ContinueLoop
	ElseIf $checksum = $COLON Then
		$result = $result & ":"
		$x = $x + 3
		ContinueLoop
	EndIf
	
	;If we get to this part of the code, there was no match above, so increment x coordinate by just one
	$x = $x + 1
	
WEnd