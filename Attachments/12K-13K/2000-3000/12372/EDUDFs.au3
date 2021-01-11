;===============================================================================
;
; Description:      Encodes or Decodes a string using the R encoding algorithm
; Syntax:           _EDCodeR($sString)

; Parameter(s):    	$sString = The String to Encoded or Decoded
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns the contents of $sString after encoding\decoding with the R encoding algorithm.
;					On Failure - Returns an empty string "" if $sString = "" and Sets @Error to 1
;
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; Note(s):			Only letters and Numbers get encoded. Any other charters remain untouched.
;                 	Letters will always be replaced with letters and numbers will always be replaced with numbers.
;                   This Function is not a secure way to scramble data as anybody with the func can decode it and was intended to be used for fun only.
;
;===============================================================================
Func _EDCodeR($sString)
	Local $sC1, $sC2, $iCounter, $sChar, $iPos, $sReturn
	If $sString = "" Then
		SetError(1)
		Return ""
	EndIf
	$sC1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	$sC2 = "ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba9876543210"
	For $iCounter = 1 To StringLen($sString)
		$sChar = StringMid($sString, $iCounter, 1)
		$iPos = StringInStr($sC1, $sChar, 1)
		If $iPos = 0 Then
			$sReturn = $sReturn & $sChar
			ContinueLoop
		EndIf
		$sReturn = $sReturn & StringMid($sC2, $iPos, 1)
	Next
	SetError(0)
	Return $sReturn
EndFunc   ;==>_EDCodeR
Func _EDCodeX($sString, $iKey)
	Local $sC, $iCounter, $sChar, $iPos, $sReturn
	If $sString = "" Then
		SetError(1)
		Return ""
	EndIf
	If Not StringIsInt($iKey) Then
		SetError(2)
		Return ""
	EndIf
	$sC = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	For $iCounter = 1 To StringLen($sString)
		$sChar = StringMid($sString, $iCounter, 1)
		$iPos = StringInStr($sC, $sChar, 1)
		If $iPos = 0 Then
			$sReturn = $sReturn & $sChar
			ContinueLoop
		EndIf
		$iPos = $iPos + $iKey
		While $iPos > 62
			$iPos = $iPos - 62
		WEnd
		While $iPos < 1
			$iPos = $iPos + 62
		WEnd
		$sReturn = $sReturn & StringMid($sC, $iPos, 1)
	Next
	Return $sReturn
EndFunc   ;==>_EDCodeX
;===============================================================================
;
; Description:      Encodes or decodes a string using the RV encoding algorithm
; Syntax:           _EDCodeRV($sString)

; Parameter(s):    	$sString = The String to Encoded or Decoded
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns the contents of $sString after encoding\decoding with the RV encoding algorithm.
;					On Failure - Returns an empty string "" if $sString = "" and Sets @Error to 1
;
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; Note(s):			Only letters and Numbers get encoded. Any other charters remain untouched.
;                   Consonants are always replaced with consonants, vowels are always replaced with vowels,  and numbers are always replaced with numbers this means if you encoded a sentence it should still be able to be read out loud.
;                   This Function is not a secure way to scramble data as anybody with the func can decode it and was intended to be used for fun only.
;
;===============================================================================
Func _EDCodeRV($sString)
	Local $sC1, $sC2, $iCounter, $sChar, $iPos, $sReturn
	If $sString = "" Then
		SetError(1)
		Return ""
	EndIf
	$sC1 = "BCDFGHJKLMNPQRSTVWXYZAEIOUbcdfghjklmnpqrstvwxyzaeiou0123456789"
	$sC2 = "ZYXWVTSRQPNMLKJHGFDCBUOIEAzyxwvtsrqpnmlkjhgfdcbuoiea9876543210"
	For $iCounter = 1 To StringLen($sString)
		$sChar = StringMid($sString, $iCounter, 1)
		$iPos = StringInStr($sC1, $sChar, 1)
		If $iPos = 0 Then
			$sReturn = $sReturn & $sChar
			ContinueLoop
		EndIf
		$sReturn = $sReturn & StringMid($sC2, $iPos, 1)
	Next
	Return $sReturn
EndFunc   ;==>_EDCodeRV
;===============================================================================
;
; Description:      Encrypts or decrypts a string using the X encryption algorithm
; Syntax:           _EDCryptX($sString, $iKey)

; Parameter(s):    	$sString = The String to encrypted or decrypted
;				    $iKey = an integer to use a a key for encryption
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns the contents of $sString after Encyption\Decryption with the X encryption algorithm.
;					On Failure - Returns an empty string "" and sets @Error on Errors
;						@Error=1 $sString=""
;						@Error=2 $iKey is not an integer
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; Note(s):			Only letters and Numbers get encoded. Any other charters remain untouched.
;                   This Function is intended to be a moderately secure way to protect data but is mainly designed to be used for fun and not when security is of utmost importance.
;                   To decode just use the opposite sign for the number. for example if you encrypted with a positive number then make that number negative to decrypt and vice versa.
;===============================================================================
Func _EDCryptX($sString, $iKey)
	Local $sC, $iCounter, $sChar, $iPos, $sReturn
	If $sString = "" Then
		SetError(1)
		Return ""
	EndIf
	If Not StringIsInt($iKey) Then
		SetError(2)
		Return 0
	EndIf
	$sC = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	For $iCounter = 1 To StringLen($sString)
		$sChar = StringMid($sString, $iCounter, 1)
		$iPos = StringInStr($sC, $sChar, 1)
		If $iPos = 0 Then
			$sReturn = $sReturn & $sChar
			ContinueLoop
		EndIf
		$iPos = $iPos + $iKey
		While $iPos > 62
			$iPos = $iPos - 62
		WEnd
		While $iPos < 1
			$iPos = $iPos + 62
		WEnd
		$sReturn = $sReturn & StringMid($sC, $iPos, 1)
	Next
	Return $sReturn
EndFunc   ;==>_EDCryptX
;===============================================================================
;
; Description:      Encrypts or decrypts a string using the XV Encryption Algorithm
; Syntax:           _EDCryptXV($sString, $iKey)
;
; Parameter(s):    	$sString = The String to encrypted or decrypted
;				    $iKey = an integer to use a a key for encryption
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns the contents of $sString after encryption\decryption with the XV encryption algorithm.
;					On Failure - Returns an empty string "" and sets @Error on Errors
;						@Error=1 $sString=""
;						@Error=2 $iKey is not an integer
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; Note(s):			Only letters and Numbers get encoded. Any other charters remain untouched.
;                 	consonants are always replaced with consonants ,vowels are always replaced with vowels  ,and numbers are always replaced with numbers this means if you encoded a sentence it should still be able to be read out loud.
;                   This Function is intended to be a moderately secure way to protect data but is mainly designed to be used for fun and not when security is of utmost importance.
;                   To decode just use the opposite sign for the number. for example if you encrypted with a positive number then make that number negative to decrypt and vice versa.
;===============================================================================
Func _EDCryptXV($sString, $iKey)
	Local $sUC, $sLC, $sUV, $sLV, $sN, $sUCP, $sLCP, $sUVP, $sLVP, $sNP, $iCounter, $sChar, $iPos, $sReturn
	If $sString = "" Then
		SetError(1)
		Return ""
	EndIf
	If Not StringIsInt($iKey) Then
		SetError(2)
		Return 0
	EndIf
	$sUC = "BCDFGHJKLMNPQRSTVWXYZ"
	$sLC = "bcdfghjklmnpqrstvwxyz"
	$sUV = "AEIOU"
	$sLV = "aeiou"
	$sN = "0123456789"
	For $iCounter = 1 To StringLen($sString)
		$sChar = StringMid($sString, $iCounter, 1)
		$iUCP = StringInStr($sUC, $sChar, 1)
		$iLCP = StringInStr($sLC, $sChar, 1)
		$iUVP = StringInStr($sUV, $sChar, 1)
		$iLVP = StringInStr($sLV, $sChar, 1)
		$iNP = StringInStr($sN, $sChar, 1)
		Select
			Case $iUCP <> 0
				$iUCP = $iUCP + $iKey
				While $iUCP > 21
					$iUCP = $iUCP - 21
				WEnd
				While $iUCP < 1
					$iUCP = $iUCP + 21
				WEnd
				$sReturn = $sReturn & StringMid($sUC, $iUCP, 1)
				ContinueLoop
			Case $iLCP <> 0
				$iLCP = $iLCP + $iKey
				While $iLCP > 21
					$iLCP = $iLCP - 21
				WEnd
				While $iLCP < 1
					$iLCP = $iLCP + 21
				WEnd
				$sReturn = $sReturn & StringMid($sLC, $iLCP, 1)
				ContinueLoop
			Case $iUVP <> 0
				$iUVP = $iUVP + $iKey
				While $iUVP > 5
					$iUVP = $iUVP - 5
				WEnd
				While $iUVP < 1
					$iUVP = $iUVP + 5
				WEnd
				
				$sReturn = $sReturn & StringMid($sUV, $iUVP, 1)
				ContinueLoop
			Case $iLVP <> 0
				$iLVP = $iLVP + $iKey
				While $iLVP > 5
					$iLVP = $iLVP - 5
				WEnd
				While $iLVP < 1
					$iLVP = $iLVP + 5
				WEnd
				$sReturn = $sReturn & StringMid($sLV, $iLVP, 1)
				ContinueLoop
			Case $iNP <> 0
				$iNP = $iNP + $iKey
				While $iNP > 10
					$iNP = $iNP - 10
				WEnd
				While $iNP < 1
					$iNP = $iNP + 10
				WEnd
				$sReturn = $sReturn & StringMid($sN, $iNP, 1)
				ContinueLoop
			Case Else
				$sReturn = $sReturn & $sChar
		EndSelect
	Next
	Return $sReturn
EndFunc   ;==>_EDCryptXV
;===============================================================================
;
; Description:      Encodes a string using the ASCII encoding algorithm
; Syntax:           _ASCIIfy($sString)

; Parameter(s):    	$sString = The string to encoded
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns the contents of $sString after encoding with the ASCII encoding algorithm.
;					On Failure - Returns an empty string "" if $sString = "" and Sets @Error to 1
;
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; Note(s):			This function will replace each charter in the string with it s ASCII value so for example A would become 065.
;                 	This Function is not a secure way to scramble data as anybody with the func can decode it and was intended to be used for fun only.
;
;
;===============================================================================

Func _ASCIIfy($sString)
	Local $iCounter, $sReturn
	If $sString = "" Then
		SetError(1)
		Return ""
	EndIf
	For $iCounter = 1 To StringLen($sString)
		$sReturn = $sReturn & StringFormat("%.3d", Asc(StringMid($sString, $iCounter, 1)))
	Next
	SetError(0)
	Return $sReturn
EndFunc   ;==>_ASCIIfy
;===============================================================================
;
; Description:      Decodes a string that was encoded using the ASCII encoding algorithm
; Syntax:           _DeASCIIfy($sString)

; Parameter(s):    	$sString = The string to decoded
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns the contents of $sString after encoding with the ASCII encoding algorithm.
;					On Failure - Returns an empty string "" and Sets @Error
;									@Error=1 $sString=""
;									@Error=2 $sString contains non numeric charcters
;									@Error=3 StringLen($sString) is not evenly divisible by string. (_ASCIIfy() always returns strings which are evenly divisible by 3.)
;									@Error=4 Invalid ASCII value encountered. @Extended is also set to the offset where the invalid ASCII value was encountered.
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; Note(s): None
;
;===============================================================================
Func _DeASCIIfy($sString)
	Local $iCounter, $iASC, $sReturn
	If $sString = "" Then
		SetError(1)
		Return ""
	EndIf
	If Not StringIsDigit($sString) Then
		SetError(2)
		Return ""
	EndIf
	If Not StringIsInt(StringLen($sString) / 3) Then
		SetError(3)
		Return 0
	EndIf
	For $iCounter = 1 To StringLen($sString) Step 3
		$iASC = StringMid($sString, $iCounter, 3)
		If ($iASC < 0) or ($iASC > 255) Then
			SetError(4)
			SetExtended($iCounter)
			Return ""
		EndIf
		$sReturn = $sReturn & Chr($iASC)
	Next
	SetError(0)
	SetExtended(0)
	Return $sReturn
EndFunc   ;==>_DeASCIIfy


