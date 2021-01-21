;atbash
$a = InputBox ("Test", "Input Text")
$b = atbash($a)
msgbox (0, $a, $b)

func atbash($text)
	$letters = StringSplit(stringreplace($text, " ", ""), "")
	$max = $letters[0] + 1
	dim $convert[$max]
	dim $output[$max]
	$atbash = ""
	For $i = 1 To $letters[0] step 1
		$convert[$i] = asc ($letters[$i])
		if $convert[$i] > 64 and $convert[$i] < 91 Then
			$output[$i] = 91 - $convert[$i] + 64
		ElseIf $convert[$i] > 96 and $convert[$i] < 123 Then
			$output[$i] = 123 - $convert[$i] + 96
		Else
			$output[$i] = $convert[$i]
		EndIf
		$output[$i] = chr($output[$i])
		$atbash = $atbash & $output[$i]
	Next
	return $atbash
EndFunc
