
; #FUNCTION# ========================================================================================================================
; Name...........: _IntToBinaryEx
; Description ...: Converts a Int into Binary.
; Syntax.........: _IntToBinaryEx($iNumber[, $iFlags])
; Parameters ....: $iNumber - Int 32Bit Number
;                  $iFlags  - Optional, TrimLeft NULL Binary (Default = 7)
; Return values .: Success  - If the function succeeds, the return A String Binnary, If the function fails, the return value is None ''
; Author ........: DXRW4E
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _IntToBinaryEx(111) - Return "01101111"
; Note ..........:
; ===================================================================================================================================
Func _IntToBinaryEx(Const ByRef $iNumber, $iFlags = 7)
	Local $sBinary, $iBit = 2147483648
	For $y = 1 To 32
		$sBinary &= BitAND($iNumber, $iBit) ? "1" : "0"
		$iBit /= 2
	Next
	If $iFlags Then $sBinary = StringRegExpReplace($sBinary, "^(0000){1," & $iFlags & "}", "")
	Return $sBinary
EndFunc


; #FUNCTION# ========================================================================================================================
; Name...........: _BinaryToIntEx
; Description ...: Converts a binary variant into a Int.
; Syntax.........: _BinaryToIntEx($sBinary)
; Parameters ....: $sBinary - String Binary
; Return values .: Success  - If the function succeeds, the return A Int 32 Bit, If the function fails, the return value is 0
; Author ........: DXRW4E
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _BinaryToIntEx("01101111") - Return 111
; Note ..........:
; ===================================================================================================================================
Func _BinaryToIntEx($sBinary)
	Local $iNumber = 0, $iBit = 1
	$sBinary = StringSplit($sBinary, "", 1)
	If Not $sBinary[0] Then Return $iNumber
	For $i = $sBinary[0] To 1 Step -1
		If $sBinary[$i] == "1" Then $iNumber += $iBit
		$iBit *= 2
	Next
	Return $iNumber
EndFunc


; #FUNCTION# ========================================================================================================================
; Name...........: _StringToBinaryEx
; Description ...: Converts a string into Binary
; Syntax.........: _StringToBinaryEx($sString[, $iFlags])
; Parameters ....: $sString - String\Text\Data
;                  $iFlags  - Optional
;                  |0 (or False) - UTF-16
;                  |1 (or True)  - ANSI (Default)
; Return values .: Success  - If the function succeeds, the return A String Binnary, If the function fails, the return value is None ''
; Author ........: DXRW4E
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _StringToBinaryEx("DXRW4E") - Return "010001000101100001010010010101110011010001000101"
; Note ..........:
; ===================================================================================================================================
Func _StringToBinaryEx(Const ByRef $sString, $iFlags = 1)
	Local $sBinary, $iBit, $ieBit = ($iFlags ? 128 : 32768), $iEncoding = ($iFlags ? 8 : 16)
	Local $aArray = StringToASCIIArray($sString)  ;; StringToASCIIArray($sString, 0, Default, BitAND($iFlags, 1))
	For $i = 0 To UBound($aArray) - 1
		$iBit = $ieBit
		For $y = 1 To $iEncoding
			$sBinary &= BitAND($aArray[$i], $iBit) ? "1" : "0"
			$iBit /= 2
		Next
	Next
	Return $sBinary
EndFunc


; #FUNCTION# ========================================================================================================================
; Name...........: _BinaryToStringEx
; Description ...: Converts a Binary variant into a string.
; Syntax.........: _BinaryToStringEx($sBinary[, $iFlags])
; Parameters ....: $sBinary - String Binary
;                  $iFlags  - Optional
;                  |0 (or False) - UTF-16
;                  |1 (or True)  - ANSI (Default)
; Return values .: Success  - If the function succeeds, the return A String, If the function fails, the return value is None ''
; Author ........: DXRW4E
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: _BinaryToStringEx("010001000101100001010010010101110011010001000101") - Return "DXRW4E"
; Note ..........:
; ===================================================================================================================================
Func _BinaryToStringEx($sBinary, $iFlags = 1)
	Local $sString, $iBit, $iNumber, $iEncoding = ($iFlags ? 7 : 15)
	$sBinary = StringSplit($sBinary, "", 1)
	If Not $sBinary[0] Or Mod($sBinary[0], ($iEncoding + 1)) Then Return SetError(1, 0, "")
	For $i = 1 To $sBinary[0] Step ($iEncoding + 1)
		$iBit = 1
		$iNumber = 0
		For $y = $i + $iEncoding To $i Step -1
			If $sBinary[$y] == "1" Then $iNumber += $iBit
			$iBit *= 2
		Next
		$sString &= ($iFlags ? Chr($iNumber) : ChrW($iNumber))
	Next
	Return $sString
EndFunc

