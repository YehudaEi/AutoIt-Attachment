;vigniere
$a = InputBox ("Test", "Insert text")
$b = InputBox ("Test", "Insert code", "CODE")
$c = vigniere($a, $b)
msgbox (0, $a, $c)
$d = unvigniere($c, $b)
msgbox (0, $c, $d)

func unvigniere($text, $code)
	$plain = StringReplace ($text, " ", "")
	$plain_letters = StringSplit ($plain, "")
	$plain_code = StringReplace ($code, " ", "")
	$code_letters = StringSplit ($plain_code, "")
	$max_code = $code_letters[0] + 1
	dim $convert[$max_code]
	dim $minus[$max_code]
	for $i = 1 to $code_letters[0] step 1
		$convert[$i] = Asc ($code_letters[$i])
		if $convert[$i] > 64 and $convert[$i] < 90 Then
			$minus[$i] = $convert[$i] - 65
		ElseIf $convert[$i] > 96 and $convert[$i] < 123 Then
			$minus[$i] = $convert[$i] - 97
		EndIf
	Next
	$max_plain = $plain_letters[0] + 1
	dim $plain_convert[$max_plain]
	dim $output[$max_plain]
	$i = 0
	$vigniere = ""
	For $j = 1 to $plain_letters[0] step 1
		$i = $i + 1
		$plain_convert[$j] = Asc ($plain_letters[$j])
		if $i > $code_letters[0] Then
			$i = $i - $code_letters[0]
		EndIf
		$test = $plain_convert[$j] - $minus[$i]
		if $test < 65 Then
			$output[$j] = $plain_convert[$j] + 26 - $minus[$i]
		ElseIf $test > 89 and $test < 97 Then
			$output[$j] = $plain_convert[$j] + 26 - $minus[$i]
		ElseIf $plain_convert[$j] > 96 and $test < 91 Then
			$output[$j] = $test + 26
		Else
			$output[$j] = $test
		EndIf
		$vigniere = $vigniere & chr($output[$j])
	Next
	return $vigniere
EndFunc

func vigniere($text, $code)
		$plain = StringReplace ($text, " ", "")
	$plain_letters = StringSplit ($plain, "")
	$plain_code = StringReplace ($code, " ", "")
	$code_letters = StringSplit ($plain_code, "")
	$max_code = $code_letters[0] + 1
	dim $convert[$max_code]
	dim $minus[$max_code]
	for $i = 1 to $code_letters[0] step 1
		$convert[$i] = Asc ($code_letters[$i])
		if $convert[$i] > 64 and $convert[$i] < 90 Then
			$minus[$i] = $convert[$i] - 65
		ElseIf $convert[$i] > 96 and $convert[$i] < 123 Then
			$minus[$i] = $convert[$i] - 97
		EndIf
	Next
	$max_plain = $plain_letters[0] + 1
	dim $plain_convert[$max_plain]
	dim $output[$max_plain]
	$i = 0
	$vigniere = ""
	For $j = 1 to $plain_letters[0] step 1
		$i = $i + 1
		$plain_convert[$j] = Asc ($plain_letters[$j])
		if $i > $code_letters[0] Then
			$i = $i - $code_letters[0]
		EndIf
		$test = $plain_convert[$j] + $minus[$i]
		if $test > 122 Then
			$output[$j] = $plain_convert[$j] - 26 + $minus[$i]
		ElseIf $test > 90 and $test < 97 Then
			$output[$j] = $plain_convert[$j] - 26 + $minus[$i]
		Else
			$output[$j] = $test
		EndIf
		$vigniere = $vigniere & chr($output[$j])
	Next
	return $vigniere
EndFunc