;===============atbash===============
;$atbash_text = the textinput
;$atbash_advanced = the number of chars replaced
;0 = only letters (default)
;1 = all 256 chars
;===============atbash===============

func atbash($atbash_text, $atbash_advanced=0)
	if $atbash_advanced = 0 Then
		$atbash_letters = StringSplit(stringreplace($atbash_text, " ", ""), "")
		$atbash_max = $atbash_letters[0] + 1
		dim $atbash_convert[$atbash_max]
		dim $atbash_output[$atbash_max]
		$atbash = ""
		For $atbash_i = 1 To $atbash_letters[0] step 1
			$atbash_convert[$atbash_i] = asc ($atbash_letters[$atbash_i])
			if $atbash_convert[$atbash_i] > 64 and $atbash_convert[$atbash_i] < 91 Then
				$atbash_output[$atbash_i] = 91 - $atbash_convert[$atbash_i] + 64
			ElseIf $atbash_convert[$atbash_i] > 96 and $atbash_convert[$atbash_i] < 123 Then
				$atbash_output[$atbash_i] = 123 - $atbash_convert[$atbash_i] + 96
			Else
				$atbash_output[$atbash_i] = $atbash_convert[$atbash_i]
			EndIf
			$atbash_output[$atbash_i] = chr($atbash_output[$atbash_i])
			$atbash = $atbash & $atbash_output[$atbash_i]
		Next
		return $atbash
	ElseIf $atbash_advanced = 1 Then
		$atbash_letters = StringSplit($atbash_text, "")
		$atbash_max = $atbash_letters[0] + 1
		dim $atbash_convert[$atbash_max]
		dim $atbash_output[$atbash_max]
		$atbash = ""
		For $atbash_i = 1 To $atbash_letters[0] step 1
			$atbash_convert[$atbash_i] = asc ($atbash_letters[$atbash_i])
			$atbash_output[$atbash_i] = 255 - $atbash_convert[$atbash_i]
			$atbash_output[$atbash_i] = Chr ($atbash_output[$atbash_i])
			$atbash = $atbash & $atbash_output[$atbash_i]
		Next
		return $atbash
	EndIf
EndFunc


;===============vigniere===============
;$vigniere_text = the textinput
;$vigniere_encode = ec-/decode
;0 = encode
;1 = decode
;$vigniere_code = a code to en-/decode (default="CODE")
;$vigniere_advanced = the number of chars replaced
;0 = only letters (default)
;1 = all 256 chars
;===============vigniere===============
func vigniere($vigniere_text, $vigniere_encode, $vigniere_code="CODE", $vigniere_advanced=0)
	if $vigniere_advanced = 0 Then
		if $vigniere_encode = 1 Then
			$vigniere_plain = StringReplace ($vigniere_text, " ", "")
			$vigniere_plain_letters = StringSplit ($vigniere_plain, "")
			$vigniere_plain_code = StringReplace ($vigniere_code, " ", "")
			$vigniere_code_letters = StringSplit ($vigniere_plain_code, "")
			$vigniere_max_code = $vigniere_code_letters[0] + 1
			dim $vigniere_convert[$vigniere_max_code]
			dim $vigniere_minus[$vigniere_max_code]
			for $vigniere_i = 1 to $vigniere_code_letters[0] step 1
				$vigniere_convert[$vigniere_i] = Asc ($vigniere_code_letters[$vigniere_i])
				if $vigniere_convert[$vigniere_i] > 64 and $vigniere_convert[$vigniere_i] < 90 Then
					$vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] - 65
				ElseIf $vigniere_convert[$vigniere_i] > 96 and $vigniere_convert[$vigniere_i] < 123 Then
					$vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] - 97
				EndIf
			Next
			$vigniere_max_plain = $vigniere_plain_letters[0] + 1
			dim $vigniere_plain_convert[$vigniere_max_plain]
			dim $vigniere_output[$vigniere_max_plain]
			$vigniere_i = 0
			$vigniere = ""
			For $vigniere_j = 1 to $vigniere_plain_letters[0] step 1
				$vigniere_i = $vigniere_i + 1
				$vigniere_plain_convert[$vigniere_j] = Asc ($vigniere_plain_letters[$vigniere_j])
				if $vigniere_i > $vigniere_code_letters[0] Then
					$vigniere_i = $vigniere_i - $vigniere_code_letters[0]
				EndIf
				$vigniere_test = $vigniere_plain_convert[$vigniere_j] - $vigniere_minus[$vigniere_i]
				if $vigniere_test < 65 Then
					$vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] + 26 - $vigniere_minus[$vigniere_i]
				ElseIf $vigniere_test > 89 and $vigniere_test < 97 Then
					$vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] + 26 - $vigniere_minus[$vigniere_i]
				ElseIf $vigniere_plain_convert[$vigniere_j] > 96 and $vigniere_test < 91 Then
					$vigniere_output[$vigniere_j] = $vigniere_test + 26
				Else
					$vigniere_output[$vigniere_j] = $vigniere_test
				EndIf
				$vigniere = $vigniere & chr($vigniere_output[$vigniere_j])
			Next
			return $vigniere
		ElseIf $vigniere_encode = 0 Then
			$vigniere_plain = StringReplace ($vigniere_text, " ", "")
			$vigniere_plain_letters = StringSplit ($vigniere_plain, "")
			$vigniere_plain_code = StringReplace ($vigniere_code, " ", "")
			$vigniere_code_letters = StringSplit ($vigniere_plain_code, "")
			$vigniere_max_code = $vigniere_code_letters[0] + 1
			dim $vigniere_convert[$vigniere_max_code]
			dim $vigniere_minus[$vigniere_max_code]
			for $vigniere_i = 1 to $vigniere_code_letters[0] step 1
				$vigniere_convert[$vigniere_i] = Asc ($vigniere_code_letters[$vigniere_i])
				if $vigniere_convert[$vigniere_i] > 64 and $vigniere_convert[$vigniere_i] < 90 Then
					$vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] - 65
				ElseIf $vigniere_convert[$vigniere_i] > 96 and $vigniere_convert[$vigniere_i] < 123 Then
					$vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] - 97
				EndIf
			Next
			$vigniere_max_plain = $vigniere_plain_letters[0] + 1
			dim $vigniere_plain_convert[$vigniere_max_plain]
			dim $vigniere_output[$vigniere_max_plain]
			$vigniere_i = 0
			$vigniere = ""
			For $vigniere_j = 1 to $vigniere_plain_letters[0] step 1
				$vigniere_i = $vigniere_i + 1
				$vigniere_plain_convert[$vigniere_j] = Asc ($vigniere_plain_letters[$vigniere_j])
				if $vigniere_i > $vigniere_code_letters[0] Then
					$vigniere_i = $vigniere_i - $vigniere_code_letters[0]
				EndIf
				$vigniere_test = $vigniere_plain_convert[$vigniere_j] + $vigniere_minus[$vigniere_i]
				if $vigniere_test > 122 Then
					$vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] - 26 + $vigniere_minus[$vigniere_i]
				ElseIf $vigniere_test > 90 and $vigniere_test < 97 Then
					$vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] - 26 + $vigniere_minus[$vigniere_i]
				Else
					$vigniere_output[$vigniere_j] = $vigniere_test
				EndIf
				$vigniere = $vigniere & chr($vigniere_output[$vigniere_j])
			Next
			return $vigniere
		EndIf
	ElseIf $vigniere_advanced = 1 Then
		if $vigniere_encode = 1 Then
			$vigniere_plain = $vigniere_text
			$vigniere_plain_letters = StringSplit ($vigniere_plain, "")
			$vigniere_plain_code = $vigniere_code
			$vigniere_code_letters = StringSplit ($vigniere_plain_code, "")
			$vigniere_max_code = $vigniere_code_letters[0] + 1
			dim $vigniere_convert[$vigniere_max_code]
			dim $vigniere_minus[$vigniere_max_code]
			for $vigniere_i = 1 to $vigniere_code_letters[0] step 1
				$vigniere_convert[$vigniere_i] = Asc ($vigniere_code_letters[$vigniere_i])
				$vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] + 1
				if $vigniere_minus[$vigniere_i] > 255 Then
					$vigniere_minus[$vigniere_i] = $vigniere_minus[$vigniere_i] - 256
				EndIf
			Next
			$vigniere_max_plain = $vigniere_plain_letters[0] + 1
			dim $vigniere_plain_convert[$vigniere_max_plain]
			dim $vigniere_output[$vigniere_max_plain]
			$vigniere_i = 0
			$vigniere = ""
			For $vigniere_j = 1 to $vigniere_plain_letters[0] step 1
				$vigniere_i = $vigniere_i + 1
				$vigniere_plain_convert[$vigniere_j] = Asc ($vigniere_plain_letters[$vigniere_j])
				if $vigniere_i > $vigniere_code_letters[0] Then
					$vigniere_i = $vigniere_i - $vigniere_code_letters[0]
				EndIf
				$vigniere_test = $vigniere_plain_convert[$vigniere_j] - $vigniere_minus[$vigniere_i]
				if $vigniere_test < 0 Then
					$vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] + 256 - $vigniere_minus[$vigniere_i]
				EndIf
				$vigniere_output[$vigniere_j] = $vigniere_test
				$vigniere = $vigniere & chr($vigniere_output[$vigniere_j])
			Next
			return $vigniere
		ElseIf $vigniere_encode = 0 Then
			$vigniere_plain = $vigniere_text
			$vigniere_plain_letters = StringSplit ($vigniere_plain, "")
			$vigniere_plain_code = $vigniere_code
			$vigniere_code_letters = StringSplit ($vigniere_plain_code, "")
			$vigniere_max_code = $vigniere_code_letters[0] + 1
			dim $vigniere_convert[$vigniere_max_code]
			dim $vigniere_minus[$vigniere_max_code]
			for $vigniere_i = 1 to $vigniere_code_letters[0] step 1
				$vigniere_convert[$vigniere_i] = Asc ($vigniere_code_letters[$vigniere_i])
				$vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] + 1
				if $vigniere_minus[$vigniere_i] > 255 Then
					$vigniere_minus[$vigniere_i] = $vigniere_minus[$vigniere_i] - 256
				EndIf
			Next
			$vigniere_max_plain = $vigniere_plain_letters[0] + 1
			dim $vigniere_plain_convert[$vigniere_max_plain]
			dim $vigniere_output[$vigniere_max_plain]
			$vigniere_i = 0
			$vigniere = ""
			For $vigniere_j = 1 to $vigniere_plain_letters[0] step 1
				$vigniere_i = $vigniere_i + 1
				$vigniere_plain_convert[$vigniere_j] = Asc ($vigniere_plain_letters[$vigniere_j])
				if $vigniere_i > $vigniere_code_letters[0] Then
					$vigniere_i = $vigniere_i - $vigniere_code_letters[0]
				EndIf
				$vigniere_test = $vigniere_plain_convert[$vigniere_j] + $vigniere_minus[$vigniere_i]
				if $vigniere_test > 255 Then
					$vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] - 256 + $vigniere_minus[$vigniere_i]
				EndIf
				$vigniere_output[$vigniere_j] = $vigniere_test
				$vigniere = $vigniere & chr($vigniere_output[$vigniere_j])
			Next
			return $vigniere
		EndIf
	EndIf
EndFunc


;===============rot===============
;$rot_text = the textinput
;$rot_advanced = the number of chars replaced
;0 = only letters (default) - rot_13
;1 = all 256 chars - rot_128
;===============rot===============

func rot($rot_text, $rot_advanced)
	$rot_letter = StringSplit ($rot_text, "")
	$rot_max = $rot_letter[0] + 1
	dim $rot_output[$rot_max]
	dim $rot_convert[$rot_max]
	if $rot_advanced = 1 Then
		dim $rot_128 = ""
		for $rot_i = 1 to $rot_letter[0] step 1
			$rot_convert[$rot_i] = Asc($rot_letter[$rot_i])
			if $rot_convert[$rot_i] > -1 and $rot_convert[$rot_i] < 128 Then
				$rot_convert[$rot_i] = $rot_convert[$rot_i] + 128
				$rot_output[$rot_i] = Chr($rot_convert[$rot_i])
			ElseIf $rot_convert[$rot_i] > 127 and $rot_convert[$rot_i] < 256 Then
				$rot_convert[$rot_i] = $rot_convert[$rot_i] - 128
				$rot_output[$rot_i] = Chr($rot_convert[$rot_i])
			EndIf
			$rot_128 = $rot_128 & $rot_output[$rot_i]
		Next
		return $rot_128
	ElseIf $rot_advanced = 0 Then
		dim $rot_13 = ""
		for $rot_i = 1 to $rot_letter[0] step 1
			$rot_convert[$rot_i] = Asc($rot_letter[$rot_i])
			if $rot_convert[$rot_i] > 64 and $rot_convert[$rot_i] < 78 Then
				$rot_convert[$rot_i] = $rot_convert[$rot_i] + 13
			ElseIf $rot_convert[$rot_i] > 77 and $rot_convert[$rot_i] < 91 Then
				$rot_convert[$rot_i] = $rot_convert[$rot_i] - 13
			ElseIf $rot_convert[$rot_i] > 96 and $rot_convert[$rot_i] < 110 Then
				$rot_convert[$rot_i] = $rot_convert[$rot_i] + 13
			ElseIf $rot_convert[$rot_i] > 109 and $rot_convert[$rot_i] < 123 Then
				$rot_convert[$rot_i] = $rot_convert[$rot_i] - 13
			ElseIf $rot_convert[$rot_i] = 0 Then
				$rot_convert[$rot_i] = 126
			ElseIf $rot_convert[$rot_i] = 126 Then
				$rot_convert[$rot_i] = 0
			EndIf
			$rot_output[$rot_i] = Chr($rot_convert[$rot_i])
			$rot_13 = $rot_13 & $rot_output[$rot_i]
		Next
		return $rot_13
	EndIf
EndFunc


;===============caesar===============
;$caesar_text = the textinput
;$caesar_encode = en-/decode
;0 = encode
;1 = decode
;===============caesar===============

func caesar($caesar_text, $caesar_encode)
	if $caesar_encode = 0 Then
		$caesar_len = StringLen ($caesar_text)
		$caesar_min = $caesar_len + 1
		$caesar_diff = Sqrt ($caesar_len)
		if not IsInt ($caesar_diff) Then
			$caesar_diff = int ($caesar_diff) + 1
		EndIf
		$caesar_square = $caesar_diff * $caesar_diff
		if $caesar_square > $caesar_len Then
			for $caesar_i = $caesar_min to $caesar_square step 1
				$caesar_text = $caesar_text & " "
			Next
		EndIf
		for $caesar_loop = $caesar_diff to $caesar_diff step 1
			$caesar_letter = StringSplit ($caesar_text, "")
			$caesar_max = $caesar_letter[0] + 1
			$caesar = ""
			dim $caesar_output[$caesar_max]
			$caesar_j = 1
			for $caesar_i = 1 to $caesar_letter[0]
				if $caesar_j > $caesar_letter[0] Then
					$caesar_j = $caesar_j - $caesar_letter[0] + 1
				EndIf
				$caesar_output[$caesar_j] = $caesar_letter[$caesar_i]
				$caesar_j = $caesar_j + $caesar_diff
			Next
			for $caesar_j = 1 to $caesar_letter[0] step 1
				$caesar = $caesar & $caesar_output[$caesar_j]
			Next
		Next
		return $caesar
	ElseIf $caesar_encode = 1 Then
		$caesar_len = StringLen ($caesar_text)
		$caesar_min = $caesar_len + 1
		$caesar_diff = Sqrt ($caesar_len)
		if not IsInt ($caesar_diff) Then
			$caesar_diff = int ($caesar_diff) + 1
		EndIf
		$caesar_square = $caesar_diff * $caesar_diff
		if $caesar_square > $caesar_len Then
			for $caesar_i = $caesar_min to $caesar_square step 1
				$caesar_text = $caesar_text & " "
			Next
		EndIf
		for $caesar_loop = 3 to $caesar_diff step 1
			$caesar_letter = StringSplit ($caesar_text, "")
			$caesar_max = $caesar_letter[0] + 1
			$caesar = ""
			dim $caesar_output[$caesar_max]
			$caesar_j = 1
			for $caesar_i = 1 to $caesar_letter[0]
				if $caesar_j > $caesar_letter[0] Then
					$caesar_j = $caesar_j - $caesar_letter[0] + 1
				EndIf
				$caesar_output[$caesar_j] = $caesar_letter[$caesar_i]
				$caesar_j = $caesar_j + $caesar_diff
			Next
			for $caesar_j = 1 to $caesar_letter[0] step 1
				$caesar = $caesar & $caesar_output[$caesar_j]
			Next
			$caesar_text = $caesar
		Next
		return $caesar
	EndIf
EndFunc

