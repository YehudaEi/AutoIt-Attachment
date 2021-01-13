Func readCoord($Ax, $Ay, $Dx, $Dy)
	$minColor = "EAEAEA"
	$depth = 2

	$width = $Dx - $Ax
	$length = $Dy - $Ay
	Dim $result
	
	Dim $char[$width]
	
	;Creates a bit map of the desired text
	For $xwidth = 0 To $width - 1
		For $xlength = 0 To $length - 1
			If Hex(PixelGetColor($Ax, $Ay), 6) > $minColor Then
				$char[$xwidth] &= 1
			Else
				$char[$xwidth] &= 0
			EndIf
			$Ay += 1
		Next
		$Ax += 1
		$Ay -= $length
	Next
	
	;Converts array to string
	Dim $xwidth = 0
	While $xwidth < $width - 1
		;find start of next character
		While $char[$xwidth] = "000000000" AND $xwidth < $width - 1
			$xwidth += 1
		WEnd

		;find the character and append it to the end of the result string
		Switch $char[$xwidth]
			Case "000000000"
			
			Case "100000001"
				If $char[$xwidth + 1] = "011000110" Then
					$result &= 'X';
				EndIf

			Case "100000000"
				If $char[$xwidth + 1] = "011000000" Then
					$result &= 'Y';
				EndIf

			Case "001000001"
				$result &= ':';

			Case "011111110"
				If $char[$xwidth + 1] = "100000001" Then
					$result &= '0';
				ElseIf $char[$xwidth + 1] = "100010001" Then
					$result &= '6';
				EndIf

			Case "001000000"
				If $char[$xwidth + 1] = "010000000" Then
					$result &= '1';
				EndIf

			Case "010000001"
				If $char[$xwidth + 1] = "100000011" Then
					$result &= '2';
				EndIf

			Case "010000010"
				If $char[$xwidth + 1] = "100000001" Then
					$result &= '3';
				EndIf

			Case "000001100"
				If $char[$xwidth + 1] = "000110100" Then
					$result &= '4';
				EndIf

			Case "001110010"
				If $char[$xwidth + 1] = "110100001" Then
					$result &= '5';
				EndIf

			Case "100000000"
				If $char[$xwidth + 1] = "100000111" Then
					$result &= '7';
				EndIf

			Case "011101110"
				If $char[$xwidth + 1] = "100010001" Then
					$result &= '8';
				EndIf

			Case "011110010"
				If $char[$xwidth + 1] = "100001001" Then
					$result &= '9';
				EndIf
		EndSwitch

		;find end of this character
		While $char[$xwidth] <> "000000000" AND $xwidth < $width - 1
			$xwidth += 1
		WEnd
	WEnd
	
	Return $result

EndFunc 