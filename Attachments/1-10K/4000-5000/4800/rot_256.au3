;rot-256
$a = InputBox ("Test", "Text eingeben")
$b = rot_256 ($a)
msgbox (0, $a, $b)

func rot_256($string)
	$letter = StringSplit ($string, "")
	$max = $letter[0] + 1
	dim $output[$max]
	dim $convert[$max]
	dim $rot_256 = ""
	for $i = 1 to $letter[0] step 1
		$convert[$i] = Asc($letter[$i])
		if $convert[$i] > -1 and $convert[$i] < 128 Then
			$convert[$i] = $convert[$i] + 128
			$output[$i] = Chr($convert[$i])
		ElseIf $convert[$i] > 127 and $convert[$i] < 256 Then
			$convert[$i] = $convert[$i] - 128
			$output[$i] = Chr($convert[$i])
		EndIf
		$rot_256 = $rot_256 & $output[$i]
	Next
	
	return $rot_256
			
EndFunc

	