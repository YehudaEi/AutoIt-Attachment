Dim $sTexttoEncode, $sEncryptedText, $sDecryptedText
Dim $sDecodeKey

$sTexttoEncode = "try this one out - put your text HERE"

; Call the function with 0 in 2nd parameter to encode the text.
; The key to decode will be returned in 3rd parameter.
$sEncryptedText = _PerfectVigniere($sTexttoEncode, 0, $sDecodeKey)

; Call the function with 1 in the 2nd parameter to decode the text.
; Provide the decode key in the 3rd parameter
$sDecryptedText = _PerfectVigniere($sEncryptedText, 1, $sDecodeKey)

MsgBox(0, "Nuffilein805's Encryption Algorithm", "Original Text: " & $sTexttoEncode & @CRLF & _
        "Encrypted Text: " & $sEncryptedText & @CRLF & _
        "Decryped Text: " & $sDecryptedText & @CRLF & _
        "Decode Key: " & $sDecodeKey)


Func _PerfectVigniere($vigniere_text, $vigniere_encode, ByRef $vigniere_code)
    If $vigniere_encode = 1 Then
		
            $vigniere_plain = $vigniere_text
            $vigniere_plain_letters = StringSplit ($vigniere_plain, "")
            $vigniere_plain_code = $vigniere_code
            $vigniere_code_letters = StringSplit ($vigniere_plain_code, "")
            $vigniere_max_code = $vigniere_code_letters[0] + 1
            Dim $vigniere_convert[$vigniere_max_code]
            Dim $vigniere_minus[$vigniere_max_code]
            For $vigniere_i = 1 to $vigniere_code_letters[0] step 1
                $vigniere_convert[$vigniere_i] = Asc ($vigniere_code_letters[$vigniere_i])
                $vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] + 1
                If $vigniere_minus[$vigniere_i] > 255 Then
                    $vigniere_minus[$vigniere_i] = $vigniere_minus[$vigniere_i] - 256
                EndIf
            Next
            $vigniere_max_plain = $vigniere_plain_letters[0] + 1
            Dim $vigniere_plain_convert[$vigniere_max_plain]
            Dim $vigniere_output[$vigniere_max_plain]
            $vigniere_i = 0
            $vigniere = ""
            For $vigniere_j = 1 to $vigniere_plain_letters[0] step 1
                $vigniere_i = $vigniere_i + 1
                $vigniere_plain_convert[$vigniere_j] = Asc ($vigniere_plain_letters[$vigniere_j])
                If $vigniere_i > $vigniere_code_letters[0] Then
                    $vigniere_i = $vigniere_i - $vigniere_code_letters[0]
                EndIf
                $vigniere_test = $vigniere_plain_convert[$vigniere_j] - $vigniere_minus[$vigniere_i]
                If $vigniere_test < 0 Then
                    $vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] + 256 - $vigniere_minus[$vigniere_i]
                EndIf
                $vigniere_output[$vigniere_j] = $vigniere_test
                $vigniere = $vigniere & chr($vigniere_output[$vigniere_j])
            Next
	
		    Return $vigniere
        ElseIf $vigniere_encode = 0 Then
            
			$vigniere_plain = $vigniere_text
            $vigniere_plain_letters = StringSplit ($vigniere_plain, "")
            If $vigniere_code = "" then
                $vigniere_max = $vigniere_plain_letters[0] + 1
				
                Dim $vigniere_code_letters[$vigniere_max]
                For $vigniere_a = 1 to $vigniere_plain_letters[0] step 1
                    $vigniere_code_letters[$vigniere_a] = Chr (random(0, 255, 1))
                    $vigniere_code = $vigniere_code & $vigniere_code_letters[$vigniere_a]
                Next
            $vigniere_plain_code = $vigniere_code
            $vigniere_code_letters = StringSplit ($vigniere_plain_code, "")
            $vigniere_max_code = $vigniere_code_letters[0] + 1
            Dim $vigniere_convert[$vigniere_max_code]
            Dim $vigniere_minus[$vigniere_max_code]
            For $vigniere_i = 1 to $vigniere_code_letters[0] step 1
                $vigniere_convert[$vigniere_i] = Asc ($vigniere_code_letters[$vigniere_i])
                $vigniere_minus[$vigniere_i] = $vigniere_convert[$vigniere_i] + 1
                If $vigniere_minus[$vigniere_i] > 255 Then
                    $vigniere_minus[$vigniere_i] = $vigniere_minus[$vigniere_i] - 256
                EndIf
            Next
            $vigniere_max_plain = $vigniere_plain_letters[0] + 1
            Dim $vigniere_plain_convert[$vigniere_max_plain]
            Dim $vigniere_output[$vigniere_max_plain]
            $vigniere_i = 0
            $vigniere = ""
            For $vigniere_j = 1 to $vigniere_plain_letters[0] step 1
                $vigniere_i = $vigniere_i + 1
                $vigniere_plain_convert[$vigniere_j] = Asc ($vigniere_plain_letters[$vigniere_j])
                If $vigniere_i > $vigniere_code_letters[0] Then
                    $vigniere_i = $vigniere_i - $vigniere_code_letters[0]
                EndIf
                $vigniere_test = $vigniere_plain_convert[$vigniere_j] + $vigniere_minus[$vigniere_i]
                If $vigniere_test > 255 Then
                    $vigniere_output[$vigniere_j] = $vigniere_plain_convert[$vigniere_j] - 256 + $vigniere_minus[$vigniere_i]
                EndIf
                $vigniere_output[$vigniere_j] = $vigniere_test
                $vigniere = $vigniere & Chr($vigniere_output[$vigniere_j])
            Next
			$sDecryptedText = _errorcorrect($vigniere, 1, $vigniere_code)
			if $sDecryptedText = $vigniere_text Then
            Return $vigniere
		else 
			$sDecodeKey = ""
			$vigniere = _PerfectVigniere($sTexttoEncode, 0, $sDecodeKey)
			return $vigniere
		EndIf
		
        EndIf
    EndIf
EndFunc

Func _errorcorrect($error_text, $error_encode, ByRef $error_code)
    If $error_encode = 1 Then
		
            $error_plain = $error_text
            $error_plain_letters = StringSplit ($error_plain, "")
            $error_plain_code = $error_code
            $error_code_letters = StringSplit ($error_plain_code, "")
            $error_max_code = $error_code_letters[0] + 1
            Dim $error_convert[$error_max_code]
            Dim $error_minus[$error_max_code]
            For $error_i = 1 to $error_code_letters[0] step 1
                $error_convert[$error_i] = Asc ($error_code_letters[$error_i])
                $error_minus[$error_i] = $error_convert[$error_i] + 1
                If $error_minus[$error_i] > 255 Then
                    $error_minus[$error_i] = $error_minus[$error_i] - 256
                EndIf
            Next
            $error_max_plain = $error_plain_letters[0] + 1
            Dim $error_plain_convert[$error_max_plain]
            Dim $error_output[$error_max_plain]
            $error_i = 0
            $error = ""
            For $error_j = 1 to $error_plain_letters[0] step 1
                $error_i = $error_i + 1
                $error_plain_convert[$error_j] = Asc ($error_plain_letters[$error_j])
                If $error_i > $error_code_letters[0] Then
                    $error_i = $error_i - $error_code_letters[0]
                EndIf
                $error_test = $error_plain_convert[$error_j] - $error_minus[$error_i]
                If $error_test < 0 Then
                    $error_output[$error_j] = $error_plain_convert[$error_j] + 256 - $error_minus[$error_i]
                EndIf
                $error_output[$error_j] = $error_test
                $error = $error & chr($error_output[$error_j])
            Next
	
		    Return $error
		EndIf
		
EndFunc