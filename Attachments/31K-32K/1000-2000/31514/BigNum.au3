#include-once

; #INDEX# =======================================================================================================================
; Title .........: BigNum
; AutoIt Version : 3.2.12.1
; Language ......: English
; Description ...: Perform calculations with big numbers
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_BigNum_Parse
;_BigNum_Add
;_BigNum_Sub
;_BigNum_Mul
;_BigNum_Div
;_BigNum_Pow
;_BigNum_SQRT
;_BigNum_n_Root
;_BigNum_Mod
;_BigNum_Round
;_BigNum_Compare
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;__BigNum_Swap
;__BigNum_CheckNegative
;__BigNum_DivAdd
;__BigNum_DivComp
;__BigNum_DivSub
;__BigNum_Div_DivisorGreater14
;__BigNum_Div_DivisorMaxLen14
;__BigNum_InsertDecimalSeparator
;__BigNum_StringIsDecimal
;__BigNum_IsValid
; ===============================================================================================================================

; #FUNCTION# ;====================================================================================
; Name...........: _BigNum_Parse
; Description ...: Parses a line using bigNums
; Syntax.........: _BigNum_Parse($sLine)
; Parameters ....: $sLine -  e.g. "-1-(2-4*3^(2*5))/(-2.5)"
;                  ^ : Power
;                  % : Mod
;                  / : Div
;                  * : Mul
;                  + : Add
;                  - : Sub
; Return values .: Success - Result
;                  Failure - ?
; Remarks .......:
; Author ........: eukalyptus
; ;===============================================================================================

Func _BigNum_Parse($sLine)
	$sLine = StringStripWS($sLine, 8)
	$sLine = StringRegExpReplace($sLine, "([\^%/*+-])", "$1#")
	Local $aReg = StringRegExp($sLine, "\(([^()]+)\)", 3)
	If IsArray($aReg) Then
		$sLine = StringRegExpReplace($sLine, "\([^()]+\)", Chr(1))
		For $i = 0 To UBound($aReg) - 1
			$sLine = StringReplace($sLine, Chr(1), _BigNum_Parse($aReg[$i]), 1)
		Next
		$sLine = _BigNum_Parse($sLine)
	EndIf
	Local $aOp[6][2] = [["\^", "_BigNum_Pow"],["%", "_BigNum_Mod"],["/", "_BigNum_Div"],["\*", "_BigNum_Mul"],["\+", "_BigNum_Add"],["-", "_BigNum_Sub"]]
	Local $iCnt = 0
	While $iCnt < 6
		$aReg = StringRegExp($sLine, "(-*[0-9.]+)\#*" & $aOp[$iCnt][0] & "\#*(-*[0-9.]+)", 1)
		If IsArray($aReg) Then
			$sLine = StringRegExpReplace($sLine, "-*[0-9.]+\#*" & $aOp[$iCnt][0] & "\#*-*[0-9.]+", Call($aOp[$iCnt][1], $aReg[0], $aReg[1]), 1)
		Else
			$iCnt += 1
		EndIf
	WEnd
	$sLine = StringReplace($sLine, "#", "")
	$sLine = StringReplace($sLine, "--", "+")
	If StringRegExp($sLine, "^\+[0-9.]+$") Then $sLine = StringReplace($sLine, "+", "")
	Return $sLine
EndFunc   ;==>_BigNum_Parse

; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Add
; Description ...: Addition $sX + $sY
; Syntax.........: _BigNum_Add($sX, $sY)
; Parameters ....: $sX - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $sY - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
; Return values .: Success - Result $sX + $sY
;                  Failure - 0, sets @error to 1 if $sX/$sY not valid StringNumber
; Author ........: Eukalyptus www.autoit.de
;
; ;===============================================================================================
Func _BigNum_Add($sX, $sY)
	If Not __BigNum_IsValid($sX, $sY) Then Return SetError(1, 0, 0)
	Local $iNeg = __BigNum_CheckNegative($sX, $sY), $sNeg = ""
	Switch $iNeg
		Case 3
			$sNeg = "-"
		Case 1
			Return _BigNum_Sub($sY, $sX)
		Case 2
			Return _BigNum_Sub($sX, $sY)
	EndSwitch
	Local $iDec = __BigNum_StringIsDecimal($sX, $sY)
	Local $iTmp = StringLen($sX), $iLen = StringLen($sY), $iCar = 0, $sRet = ""
	If $iLen < $iTmp Then $iLen = $iTmp
	For $i = 1 To $iLen Step 18
		$iTmp = Int(StringRight($sX, 18)) + Int(StringRight($sY, 18)) + $iCar
		$sX = StringTrimRight($sX, 18)
		$sY = StringTrimRight($sY, 18)
		If ($iTmp > 999999999999999999) Then
			$iTmp = StringRight($iTmp, 18)
			$sRet = $iTmp & $sRet
			$iCar = 1
		Else
			$iTmp = StringRight("000000000000000000" & $iTmp, 18)
			$sRet = $iTmp & $sRet
			$iCar = 0
		EndIf
	Next
	$sRet = StringRegExpReplace($iCar & $sRet, "^0+([^0]|0$)", "\1", 1)
	If $iDec > 0 Then $sRet = __BigNum_InsertDecimalSeparator($sRet, $iDec, $iDec)
	If $sRet = "0" Then $sNeg = ""
	Return $sNeg & $sRet
EndFunc   ;==>_BigNum_Add



; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Sub
; Description ...: Subtraction $sX - $sY
; Syntax.........: _BigNum_Sub($sX, $sY)
; Parameters ....: $sX - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $sY - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
; Return values .: Success - Result $sX - $sY
;                  Failure - 0, sets @error to 1 if $sX/$sY not valid StringNumber
; Author ........: Eukalyptus www.autoit.de
;
; ;===============================================================================================
Func _BigNum_Sub($sX, $sY)
	If Not __BigNum_IsValid($sX, $sY) Then Return SetError(1, 0, 0)
	Local $iNeg = __BigNum_CheckNegative($sX, $sY), $bNeg = False
	Switch $iNeg
		Case 3
			Return _BigNum_Add("-" & $sX, $sY)
		Case 1
			Return "-" & _BigNum_Add($sX, $sY)
		Case 2
			Return _BigNum_Add($sX, $sY)
	EndSwitch
	Local $iDec = __BigNum_StringIsDecimal($sX, $sY)
	If _BigNum_Compare($sX, $sY) = -1 Then $bNeg = __BigNum_Swap($sX, $sY)
	Local $iTmp = StringLen($sX), $iLen = StringLen($sY), $iCar = 0, $sRet = ""
	If $iLen < $iTmp Then $iLen = $iTmp
	For $i = 1 To $iLen Step 18
		$iTmp = Int(StringRight($sX, 18)) - Int(StringRight($sY, 18)) - $iCar
		$sX = StringTrimRight($sX, 18)
		$sY = StringTrimRight($sY, 18)
		If $iTmp < 0 Then
			$iTmp = 1000000000000000000 + $iTmp
			$iCar = 1
		Else
			$iCar = 0
		EndIf
		$sRet = StringRight("0000000000000000000" & $iTmp, 18) & $sRet
	Next
	$sRet = StringRegExpReplace($iCar & $sRet, "^0+([^0]|0$)", "\1", 1)
	If $iDec > 0 Then $sRet = __BigNum_InsertDecimalSeparator($sRet, $iDec, $iDec)
	If $bNeg = True And $sRet <> "0" Then
		Return "-" & $sRet
	Else
		Return $sRet
	EndIf
EndFunc   ;==>_BigNum_Sub



; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Mul
; Description ...: Multiplication $sX * $sY
; Syntax.........: _BigNum_Mul($sX, $sY)
; Parameters ....: $sX - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $sY - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
; Return values .: Success - Result $sX * $sY
;                  Failure - 0, sets @error to 1 if $sX/$sY not valid StringNumber
; Author ........: Eukalyptus www.autoit.de
;
; ;===============================================================================================
Func _BigNum_Mul($sX, $sY)
	If Not __BigNum_IsValid($sX, $sY) Then Return SetError(1, 0, 0)
	Local $iNeg = __BigNum_CheckNegative($sX, $sY), $sNeg = ""
	Local $iDec = __BigNum_StringIsDecimal($sX, $sY)
	Local $aX = StringRegExp($sX, '\A.{' & 6 - (Ceiling(StringLen($sX) / 6) * 6 - StringLen($sX)) & '}|.{6}+', 3)
	Local $aY = StringRegExp($sY, '\A.{' & 6 - (Ceiling(StringLen($sY) / 6) * 6 - StringLen($sY)) & '}|.{6}+', 3)
	Local $aRet[UBound($aX) + UBound($aY) - 1]
	For $j = 0 To UBound($aX) - 1
		For $i = 0 To UBound($aY) - 1
			$aRet[$j + $i] += $aX[$j] * $aY[$i]
		Next
	Next
	Local $sRet = "", $iCar = 0, $iTmp
	For $i = UBound($aRet) - 1 To 0 Step -1
		$aRet[$i] += $iCar
		$iCar = Floor($aRet[$i] / 1000000)
		$iTmp = Mod($aRet[$i], 1000000)
		If $iTmp <= 1000000 Then $iTmp = StringRight("000000" & $iTmp, 6)
		$sRet = $iTmp & $sRet
	Next
	If $iCar > 0 Then $sRet = $iCar & $sRet
	$sRet = StringRegExpReplace($sRet, "^0+([^0]|0$)", "\1", 1)
	If ($iNeg = 1 Or $iNeg = 2) And $sRet <> "0" Then $sNeg = "-"
	If $iDec > 0 Then $sRet = __BigNum_InsertDecimalSeparator($sRet, $iDec * 2, $iDec * 2)
	Return $sNeg & $sRet
EndFunc   ;==>_BigNum_Mul



; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Div
; Description ...: Division $sX / $sY
; Syntax.........: _BigNum_Div($sX, $sY, [$iD = 0])
; Parameters ....: $sX - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $sY - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $iD [optional] - Number of Decimalplaces; if -1 then $iD = StringLen($sX) + StringLen($sY)
; Return values .: Success - Result $sX / $sY
;                  Failure - 0, sets @error to 1 if $sX/$sY not valid StringNumber
; Author ........: Eukalyptus www.autoit.de
;
; ;===============================================================================================
Func _BigNum_Div($sX, $sY, $iD = -1)
	If Not __BigNum_IsValid($sX, $sY) Then Return SetError(1, 0, 0)
	Local $iNeg = __BigNum_CheckNegative($sX, $sY), $sNeg = ""
	If $iD = -1 Then $iD = StringLen($sX) + StringLen($sY)
	Local $iDec = __BigNum_StringIsDecimal($sX, $sY), $sMod
	If $sX = 0 Or $sY = 0 Then Return "0"
	If $sY = "1" Then Return $sNeg & $sX
	While StringLeft($sX, 1) = "0"
		$sX = StringTrimLeft($sX, 1)
		$iDec += 1
	WEnd
	While StringLeft($sY, 1) = "0"
		$sY = StringTrimLeft($sY, 1)
		$iDec += 1
	WEnd
	Local $sRet = "", $iLnX = StringLen($sX), $iLnY = StringLen($sY), $iTmp, $iCnt, $sTmp, $iDe1 = 0
	If $iD > 0 Then $iDe1 += $iD
	If $iNeg = 1 Or $iNeg = 2 Then $sNeg = "-"
	$iTmp = _BigNum_Compare($sX, $sY)
	If $iTmp = -1 Then
		For $iCnt = $iLnX To $iLnY
			$sX &= 0
			$iDe1 += 1
		Next
	EndIf
	If $iTmp = 0 Then Return $sNeg & "1"
	If $iD = -1 Then $iD = $iDec * 2
	For $iCnt = 1 To $iD
		$sX &= "0"
	Next
	If $iLnY > 14 Then
		$sRet = __BigNum_Div_DivisorGreater14($sX, $sY, $sMod)
	Else
		$sRet = __BigNum_Div_DivisorMaxLen14($sX, $sY, $sMod)
	EndIf
	If $iDe1 > 0 Then $sRet = __BigNum_InsertDecimalSeparator($sRet, $iDe1, $iD)
	If $sRet = "0" Then
		Return "0"
	Else
		Return $sNeg & $sRet
	EndIf
EndFunc   ;==>_BigNum_Div


; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Pow
; Description ...: Exponentiation $n^$e
; Syntax.........: _BigNum_Pow($n [, $e = 2])
; Parameters ....: $n - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $e [optional] - Exponent (must be a positive 64-bit signed integer)
;                                  Default: $e = 2 means result = $n²
; Return values .: Success - Result $n^$e
;                  Failure - -1, sets @error to 1 if $n not valid StringNumber
;                            -1, sets @error to 2 if $e is not a positive Integer
; Author ........: jennicoattminusonlinedotde
; Date ..........: 9.12.09
; Remarks .......: Fractional exponents not allowed - use BigNum_n_root instead.
;                  _BigNum_Pow() offers a drastically better efficiency than looping _BigNum_Mul()
; Reference .....: http://en.wikipedia.org/wiki/Exponentiation_by_squaring
; ;===============================================================================================
Func _BigNum_Pow($n, $e = 2)
	$e = Number($e)
	If IsInt($e) = 0 Or $e < 0 Then Return SetError(2, 0, -1)
	;If $e < -2147483648 Or $e > 2147483647 Then Return SetError(-2, 0, -1)
	If Not __BigNum_IsValid($n, $n) Then Return SetError(1, 0, -1)

	Local $res = 1

	While $e
		;If BitAND($e, 1) Then  ; bitoperation is not faster !
		If Mod($e, 2) Then
			$res = _BigNum_Mul($res, $n)
			$e -= 1
		EndIf
		$n = _BigNum_Mul($n, $n)
		;$e = BitShift($e, 1)   ; bitoperation is not faster !
		$e /= 2
	WEnd

	Return $res
EndFunc   ;==>_BigNum_Pow


; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_SQRT
; Description ...: Square Root (BigNum)
; Syntax.........: _BigNum_SQRT($n [, $p = -1])
; Parameters ....: $n - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $p [optional] - Precision (Number of Decimalplaces) (must be positive Integer)
;                            Default: $p = -1 means automatic precision (stringlen of integer part of $n)
; Return values .: Success - Result SQRT($n)
;                            @extended = Precicion of result (if $p set to automatic precision)
;                            @error = Number of Iterations
;                  Failure - -1, sets @error to -1 if $n not valid StringNumber
;                            -1, sets @error to -2 if $p is out of valid range
;                            -1, sets @error to -3 if time-out (>100 iterations)
; Author ........: jennicoattminusonlinedotde
; Date ..........: 8.12.09
; Remarks .......: use Precision param when u want to obtain the square root of a small number with the desired decimal places.
; References ....:                                       
;                  "Newton's Method" - before: Heron of Alexandria
; ;===============================================================================================
Func _BigNum_SQRT($n, $p = -1)
	If Not __BigNum_IsValid($n, $n) Then Return SetError(-1, 0, -1)
	$p = Number($p)
	If IsInt($p) = 0 Or $p < -1 Then Return SetError(-2, 0, -1)
	Local $l = StringInStr($n, ".") - 1
	If $l = -1 Then $l = StringLen($n)
	If $p < 0 Then $p = $l
	Local $g = 1, $last

	For $i = 3 To $l Step 2
		$g = _BigNum_Mul($g, 10)
	Next

	For $i = 1 To 100
		$last = $g
		$g = _BigNum_Div(_BigNum_Add(_BigNum_Div($n, $g, $p), $g), 2, $p)
		If $last = $g Then Return SetError($i, $p, $g)
	Next
	Return SetError(-3, 0, -1)
EndFunc   ;==>_BigNum_SQRT



; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_n_Root
; Description ...: $e-th Root of $n
; Syntax.........: _n_Root($n [, $e=2])
; Parameters ....: $n - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $e - [optional] Multiplicity of root (power, exponent) (must be a positive 64-bit signed integer > 0)
;                            Default: $e = 2 (=SQRT)
;                  $p - [optional] Precision (Number of desired Decimalplaces) (must be positive Integer)
;                            Default: $p = -1 means automatic precision (stringlen of integer part of $n)
; Return values .: Success - Result $e-root($n)
;                            @extended = Number of Iterations
;                  Failure - -1 and sets @error to 1 if $n not valid StringNumber
;                            -1 and sets @error to 2 if $e out of valid range
;                            -1 and sets @error to 3 if $p out of valid range
; Author ........: jennicoattminusonlinedotde
; Date ..........: 9.12.09
; References ....: derived from "Newton's Method"
; ;===============================================================================================
Func _BigNum_n_Root($n, $e = 2, $p = -1)
	If Not __BigNum_IsValid($n, $n) Then Return SetError(1, 0, -1)
	$e = Number($e)
	If IsInt($e) = 0 Or $e < 1 Then Return SetError(2, 0, -1)
	$p = Number($p)
	If IsInt($p) = 0 Or $p < -1 Then Return SetError(3, 0, -1)

	Local $l = StringInStr($n, ".") - 1
	If $l = -1 Then $l = StringLen($n)
	If $p < 0 Then $p = $l
	Local $g = 1, $last, $i = 0

	For $i = 3 To $l Step 2
		$g = _BigNum_Mul($g, 10)
	Next

	While 1
		$i += 1
		$last = $g
		$g = _BigNum_Div(_BigNum_Add(_BigNum_Div($n, _BigNum_Pow($g, $e - 1), $p), _BigNum_Mul($g, $e - 1)), $e, $p)
		If $last = $g Then Return SetExtended($i, $g)
	WEnd
EndFunc   ;==>_BigNum_n_Root



; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Mod
; Description ...: Modulo Mod($sX, $sY)
; Syntax.........: _BigNum_Mod($sX, $sY)
; Parameters ....: $sX - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $sY - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
; Return values .: Success - Result Mod($sX, $sY)
;                  Failure - 0, sets @error to 1 if $sX/$sY not valid StringNumber
; Author ........: Eukalyptus www.autoit.de
;
; ;===============================================================================================
Func _BigNum_Mod($sX, $sY)
	If Not __BigNum_IsValid($sX, $sY) Then Return SetError(1, 0, 0)
	If $sY = 0 Or $sY = 1 Then Return "0"
	Local $sRes = $sX
	Local $iNeg = __BigNum_CheckNegative($sX, $sY)
	Local $iDec = __BigNum_StringIsDecimal($sX, $sY)
	If _BigNum_Compare($sX, $sY) < 0 Then Return $sRes
	Local $sRet = "", $iLnX = StringLen($sX), $iLnY = StringLen($sY)
	If $iLnY > 14 Then
		__BigNum_Div_DivisorGreater14($sX, $sY, $sRet)
	Else
		__BigNum_Div_DivisorMaxLen14($sX, $sY, $sRet)
	EndIf
	$sRet = __BigNum_InsertDecimalSeparator($sRet, $iDec, StringLen($sRet))
	If ($iNeg = 3 Or $iNeg = 1) And $sRet <> "0" Then $sRet = "-" & $sRet
	Return $sRet
EndFunc   ;==>_BigNum_Mod



; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Round
; Description ...: Round $sX to $iD Decimalplaces
; Syntax.........: _BigNum_Round($sX, $iD)
; Parameters ....: $sX - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $iD - Number of Decimalplaces
; Return values .: Success - Result Round($sX, $iD)
;                  Failure - 0, sets @error to 1 if $sX not valid StringNumber
; Author ........: Eukalyptus www.autoit.de
;
; ;===============================================================================================
Func _BigNum_Round($sX, $iD)
	If Not __BigNum_IsValid($sX, $sX) Then Return SetError(1, 0, 0)
	Local $sTmp = 0, $sRet, $sRes = $sX
	Local $iNeg = __BigNum_CheckNegative($sX, $sTmp)
	Local $iDec = __BigNum_StringIsDecimal($sX, $sTmp)
	If $iD > $iDec Or $iDec = 0 Then Return $sRes
	$sTmp = StringLeft(StringRight($sX, $iDec - $iD), 1)
	$sRet = StringTrimRight($sRes, $iDec - $iD)
	If $sTmp >= 5 And $iD > 0 Then
		If $iNeg = 1 Then
			$sRet = _BigNum_Add($sRet, "-0." & StringFormat("%0" & String($iD) & "u", "1"))
		Else
			$sRet = _BigNum_Add($sRet, "0." & StringFormat("%0" & String($iD) & "u", "1"))
		EndIf
	ElseIf $sTmp >= 5 And $iD = 0 Then
		If $iNeg = 1 Then
			$sRet = _BigNum_Add($sRet, "-1")
		Else
			$sRet = _BigNum_Add($sRet, "1")
		EndIf
	Else
		If StringRight($sRet, 1) = "." Then $sRet = StringTrimRight($sRet, 1)
	EndIf
	Return $sRet
EndFunc   ;==>_BigNum_Round



; #FUNCTION# ;====================================================================================
;
; Name...........: _BigNum_Compare
; Description ...: Compares $sX $sY
; Syntax.........: _BigNum_Compare($sX, $sY)
; Parameters ....: $sX - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
;                  $sY - StringNumber: Minus"-" Digits"0"..."9" Separator"." ("-1234567890.12345")
; Return values .: Success - Return:
;                  |0  - $sX and $sY are equal
;                  |1  - $sX is greater than $sY
;                  |-1 - $sX is less than $sY
;                  Failure - sets @error to 1 if $sX/$sY not valid StringNumber
; Author ........:  eXirrah
;
; ;===============================================================================================
Func _BigNum_Compare($sX, $sY) ;Algorithm No.2
	Local $iNeg = __BigNum_CheckNegative($sX, $sY)
	Switch $iNeg
		Case 1 ; sX = negative
			Return -1
		Case 2 ; sY = negative
			Return 1
		Case 3 ; both negative
			__BigNum_Swap($sX, $sY)
	EndSwitch
	__BigNum_CompEqualizeLength($sX, $sY)
	Return StringCompare($sX, $sY)
EndFunc   ;==>_BigNum_Compare





; #INTERNAL_USE_ONLY#============================================================================================================



#Region Internal Functions

Func __BigNum_CompEqualizeLength(ByRef $sX, ByRef $sY)
	Local $iXDotPos = StringInStr($sX, ".")
	Local $iYDotPos = StringInStr($sY, ".")
	Local $iXLen = StringLen($sX)
	Local $iYLen = StringLen($sY)
	Local $iLeading, $iTrailing
	;Calculation leading and trailing zeroes
	If $iXDotPos == 0 And $iYDotPos <> 0 Then
		$iLeading = $iXLen - ($iYDotPos - 1)
		$iTrailing = -1 * ($iYLen - $iYDotPos)
		$sX &= "."
	ElseIf $iXDotPos <> 0 And $iYDotPos == 0 Then
		$iLeading = ($iXDotPos - 1) - $iYLen
		$iTrailing = $iXLen - $iXDotPos
		$sY &= "."
	ElseIf $iXDotPos == 0 And $iYDotPos == 0 Then
		$iLeading = $iXLen - $iYLen
	Else
		$iLeading = $iXDotPos - $iYDotPos
		$iTrailing = ($iXLen - $iXDotPos) - ($iYLen - $iYDotPos)
	EndIf
	;adding leading and trailing zeroes
	If $iLeading < 0 Then
		$sX = __BigNum_CompStringAddZeroes($sX, -1 * $iLeading, 0, 0)
	ElseIf $iLeading > 0 Then
		$sY = __BigNum_CompStringAddZeroes($sY, $iLeading, 0, 0)
	EndIf
	If $iTrailing < 0 Then
		$sX = __BigNum_CompStringAddZeroes($sX, -1 * $iTrailing, 1, 0)
	ElseIf $iTrailing > 0 Then
		$sY = __BigNum_CompStringAddZeroes($sY, $iTrailing, 1, 0)
	EndIf
EndFunc   ;==>__BigNum_CompEqualizeLength

Func __BigNum_CompStringAddZeroes($sString, $iCount, $bTrailing = 0, $bToLength = 1)
	;$bToLength is set when the user wants to add the nescessary amount
	;of zeroes to the string so it is with length $iCount (Default)
	If $bToLength Then
		$iCount -= StringLen($sString)
	EndIf
	Local $i = 0
	Local $s = ""
	While $i < $iCount
		$s &= "0"
		$i += 1
	WEnd
	;$bTrailing is set when the user wants the zeroes to be added at the
	;right side of the string. By defaut zeroes are added at the left side of the string
	If $bTrailing Then
		Return $sString & $s
	EndIf
	Return $s & $sString
EndFunc   ;==>__BigNum_CompStringAddZeroes


Func __BigNum_Swap(ByRef $sX, ByRef $sY)
	Local $sSwap = $sX
	$sX = $sY
	$sY = $sSwap
	Return True
EndFunc   ;==>__BigNum_Swap

Func __BigNum_Div_DivisorGreater14($sX, $sY, ByRef $sM)
	$sM = "0"
	If $sY = "1" Then Return $sX
	If $sX = "0" Or $sY = "0" Or $sX = "" Or $sY = "" Then Return "0"

	Local $iLnY = StringLen($sY), $bRed = False
	Local $sRet = "", $sRem = StringLeft($sX, $iLnY), $sTmp = "", $sTm2 = "", $iCnt, $iLen = 1
	$sX = StringTrimLeft($sX, $iLnY)
	Do
		If __BigNum_DivComp($sRem, $sY) = -1 Then
			$sTmp = StringLeft($sX, 1)
			$sRem &= $sTmp
			$sX = StringTrimLeft($sX, 1)
			If StringLen($sTmp) > 0 Then $iLen += 1
		EndIf
		$sTmp = $sY
		$sTm2 = "0"
		If __BigNum_DivComp($sRem, $sY) >= 0 Then
			For $iCnt = 1 To 9
				$sTm2 = $sTmp
				$sTmp = __BigNum_DivAdd($sTmp, $sY)
				If __BigNum_DivComp($sRem, $sTmp) < 0 Then ExitLoop
			Next
		Else
			$iCnt = 0
		EndIf

		If StringLen($sX) = 0 Then $bRed = True
		$sM = $sRem
		$sRem = __BigNum_DivSub($sRem, $sTm2)
		If $iCnt > 0 Then $sM = $sRem
		$sRet &= StringFormat("%0" & String($iLen) & "u", $iCnt)
		$iTrm = $iLnY - StringLen($sRem)
		$sTmp = StringLeft($sX, $iTrm)
		$sX = StringTrimLeft($sX, $iTrm)
		$iLen = StringLen($sTmp)
		$sRem &= $sTmp
	Until $bRed
	$sM = StringRegExpReplace($sM, "^0+([^0]|0$)", "\1", 1)

	Return StringRegExpReplace($sRet, "^0+([^0]|0$)", "\1", 1)
EndFunc   ;==>__BigNum_Div_DivisorGreater14

Func __BigNum_Div_DivisorMaxLen14($sX, $sY, ByRef $sM)
	$sM = "0"
	If $sY = "1" Then Return $sX
	If $sX = "0" Or $sY = "0" Or $sX = "" Or $sY = "" Then Return "0"

	Local $sRet = "", $iRem = StringLeft($sX, 15), $iTmp = 0, $iTrm = 6, $iLen
	$sX = StringTrimLeft($sX, 15)
	$iTmp = Floor($iRem / $sY)
	$sRet &= $iTmp

	$iRem -= $iTmp * $sY
	While StringLen($sX) > 0
		$iTrm = 15 - StringLen($iRem)
		$iTmp = StringLeft($sX, $iTrm)
		$iLen = StringLen($iTmp)
		$iRem &= $iTmp
		$sX = StringTrimLeft($sX, $iTrm)
		$iTmp = Floor($iRem / $sY)
		$iTmp = StringRight("000000000000000" & $iTmp, $iLen)

		$sRet &= $iTmp
		$iRem -= $iTmp * $sY
	WEnd
	$sM = String($iRem)

	Return StringRegExpReplace($sRet, "^0+([^0]|0$)", "\1", 1)
EndFunc   ;==>__BigNum_Div_DivisorMaxLen14

Func __BigNum_DivComp($sX, $sY)
	$sX = StringRegExpReplace($sX, "^0+([^0]|0$)", "\1", 1)
	$sY = StringRegExpReplace($sY, "^0+([^0]|0$)", "\1", 1)
	Local $iLnX = StringLen($sX), $iLnY = StringLen($sY)
	If $iLnX < $iLnY Then
		Return -1
	ElseIf $iLnX > $iLnY Then
		Return 1
	Else
		If $sX < $sY Then
			Return -1
		ElseIf $sX > $sY Then
			Return 1
		Else
			Return 0
		EndIf
	EndIf
EndFunc   ;==>__BigNum_DivComp

Func __BigNum_DivAdd($sX, $sY)
	Local $iTmp = StringLen($sX), $iLen = StringLen($sY), $iCar = 0, $sRet = ""
	If $iLen < $iTmp Then $iLen = $iTmp
	For $i = 1 To $iLen Step 18
		$iTmp = Int(StringRight($sX, 18)) + Int(StringRight($sY, 18)) + $iCar
		$sX = StringTrimRight($sX, 18)
		$sY = StringTrimRight($sY, 18)
		If ($iTmp > 999999999999999999) Then
			$sRet = StringRight($iTmp, 18) & $sRet
			$iCar = 1
		Else
			$iTmp = StringRight("000000000000000000" & $iTmp, 18)
			$sRet = $iTmp & $sRet
			$iCar = 0
		EndIf
	Next
	$sRet = StringRegExpReplace($iCar & $sRet, "^0+([^0]|0$)", "\1", 1)
	Return $sRet
EndFunc   ;==>__BigNum_DivAdd

Func __BigNum_DivSub($sX, $sY)
	Local $iTmp = StringLen($sX), $iLen = StringLen($sY), $iCar = 0, $sRet = ""
	If $iLen < $iTmp Then $iLen = $iTmp
	For $i = 1 To $iLen Step 18
		$iTmp = Int(StringRight($sX, 18)) - Int(StringRight($sY, 18)) - $iCar
		$sX = StringTrimRight($sX, 18)
		$sY = StringTrimRight($sY, 18)
		If $iTmp < 0 Then
			$iTmp = 1000000000000000000 + $iTmp
			$iCar = 1
		Else
			$iCar = 0
		EndIf
		$sRet = StringRight("0000000000000000000" & $iTmp, 18) & $sRet
	Next
	$sRet = StringRegExpReplace($iCar & $sRet, "^0+([^0]|0$)", "\1", 1)
	Return $sRet
EndFunc   ;==>__BigNum_DivSub

Func __BigNum_IsValid($sX, $sY)
	If StringRegExp($sX, "[^0-9.-]") Or StringRegExp($sY, "[^0-9.-]") Then Return False
	Return True
EndFunc   ;==>__BigNum_IsValid

Func __BigNum_InsertDecimalSeparator($sX, $iDec, $iD = 18)
	If $iD = 0 And $iDec = 0 Then Return $sX
	Local $sRet = StringRegExpReplace(StringRight(StringFormat("%0" & String($iDec) & "u", "") & $sX, $iDec), "0+$", "\1", 1)
	$sX = StringTrimRight($sX, $iDec)
	If $sX = "" Then $sX = "0"
	$sRet = StringLeft($sRet, $iD)
	If $sRet = "" Or $sRet = "0" Then Return $sX
	Return $sX & "." & $sRet
EndFunc   ;==>__BigNum_InsertDecimalSeparator

Func __BigNum_StringIsDecimal(ByRef $sX, ByRef $sY)
	If StringLeft($sX, 1) = "." Then $sX = "0" & $sX
	If StringLeft($sY, 1) = "." Then $sY = "0" & $sY
	Local $iPsX = StringInStr($sX, ".", 0, 1) - 1, $iPsY = StringInStr($sY, ".", 0, 1) - 1
	$sX = StringRegExpReplace($sX, "\D", "")
	$sY = StringRegExpReplace($sY, "\D", "")
	Local $iLnX = StringLen($sX), $iLnY = StringLen($sY)
	If $iPsX <= 0 Then $iPsX = $iLnX
	If $iPsY <= 0 Then $iPsY = $iLnY
	If $iLnX - $iPsX > $iLnY - $iPsY Then
		For $iCnt = $iLnY - $iPsY To $iLnX - $iPsX - 1
			$sY &= "0"
		Next
		Return $iLnX - $iPsX
	ElseIf $iLnX - $iPsX < $iLnY - $iPsY Then
		For $iCnt = $iLnX - $iPsX To $iLnY - $iPsY - 1
			$sX &= "0"
		Next
		Return $iLnY - $iPsY
	EndIf
	Return $iLnX - $iPsX
EndFunc   ;==>__BigNum_StringIsDecimal

Func __BigNum_CheckNegative(ByRef $sX, ByRef $sY)
	Local $bNgX = False, $bNgY = False
	While StringLeft($sX, 1) = "-"
		$bNgX = Not $bNgX
		$sX = StringTrimLeft($sX, 1)
	WEnd
	While StringLeft($sY, 1) = "-"
		$bNgY = Not $bNgY
		$sY = StringTrimLeft($sY, 1)
	WEnd
	$sX = StringRegExpReplace($sX, "^0+([^0]|0$)", "\1", 1)
	$sY = StringRegExpReplace($sY, "^0+([^0]|0$)", "\1", 1)
	If $sX = "" Then $sX = "0"
	If $sY = "" Then $sY = "0"
	If $bNgX = True And $bNgY = True Then
		Return 3
	ElseIf $bNgX = True And $bNgY = False Then
		Return 1
	ElseIf $bNgX = False And $bNgY = True Then
		Return 2
	Else
		Return 0
	EndIf
EndFunc   ;==>__BigNum_CheckNegative
#EndRegion Internal Functions