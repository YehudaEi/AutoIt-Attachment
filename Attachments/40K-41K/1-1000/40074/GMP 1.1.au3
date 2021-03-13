#include-once
#include <array.au3>
#cs
	Wrapper functions for 'GNU Multiple Precision Arithmetic Library'
	http://gmplib.org/

	Author: funkey
	Start date: 2012 November 12th

	Updated by Onichan
#ce
Global Const $tag_mpz_t = "int _mp_alloc;int _mp_size;ptr _mp_d"
Global Const $tag_mpf_t = "int _mp_prec;int _mp_size;int _mp_exp;ptr _mp_d"
Global $hDLL_GMP = DllOpen("gmp-5.1.1.dll")
If $hDLL_GMP = -1 Then Exit MsgBox(16, "Error", "gmp-5.1.1.dll not found!")
OnAutoItExitRegister("_CloseDLL")



; #FUNCTIONS# ====================================================================================================================
; _GMP_Parse
; _GMP_ParseInt
; _GMP_ParseFloat
; _GMP_HexToInt
; _GMP_IntToHex
; _GMP_AddInteger
; _GMP_SubInteger
; _GMP_MulInteger
; _GMP_DivInteger
; _GMP_PowInteger
; _GMP_SqrtInteger
; _GMP_AddFloat
; _GMP_SubFloat
; _GMP_MulFloat
; _GMP_DivFloat
; _GMP_PowFloat
; _GMP_SqrtFloat
; ===============================================================================================================================



; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_Parse
; Description ...: Attempts to calculate the result of the string
; Syntax.........: _GMP_Parse($sLine)
; Parameters ....: $sLine - e.g. "3^-4*2+(128/2+2^2)-3^2"
;                  ^ : Power
;                  * : Muliply
;                  + : Add
;                  - : Subtract
;                  If $sLine contains integers then
;                  % : Remainder
;                  / : Quotient
;                  Otherwise
;                  / : Divide
; Return values .: Calculated result
; Remarks .......: Just a front end to ParseFloat and ParseInt. It will attempt to decide which one is needed.
; ===============================================================================================================================
Func _GMP_Parse($sLine)
	If StringRegExp($sLine, "^-|\.") Then
		Return _GMP_ParseFloat($sLine)
	Else
		Return _GMP_ParseInt($sLine)
	EndIf
EndFunc   ;==>_GMP_Parse


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_ParseInt
; Description ...: Attempts to calculate the result of the integer only string
; Syntax.........: _GMP_ParseInt($sLine)
; Parameters ....: $sLine - e.g. "3^5*2+84(128/2)"
;                  ^ : Power
;                  * : Muliply
;                  % : Remainder
;                  / : Quotient
;                  + : Add
;                  - : Subtract
; Return values .: Calculated result
; ===============================================================================================================================
Func _GMP_ParseInt($sLine)
	$sLine = StringStripWS($sLine, 8)
	If StringInStr($sLine, "(") Then
		$sParStart = StringInStr($sLine, "(")
		$sParEnd = StringInStr($sLine, ")", 0, -1)
		$sParMid = StringMid($sLine, $sParStart + 1, $sParEnd - $sParStart - 1)
		$sParNew = _GMP_ParseInt($sParMid)
		If StringRegExp(StringMid($sLine, $sParStart - 1, 1), "\d") Then $sParNew = "*" & $sParNew
		If StringRegExp(StringMid($sLine, $sParEnd + 1, 1), "\d") Then $sParNew &= "*"
		$sLine = StringReplace($sLine, "(" & $sParMid & ")", $sParNew)
	EndIf
	While StringInStr($sLine, "^")
		If StringInStr($sLine, "^-") Then Return "Negative exponent requires _GMP_PowFloat"
		$aRegex = StringRegExp($sLine, "(?:-)(-\d+\^\d+)|(?:\+)(-\d+\^\d+)|\d+\^\d+", 1)
		$aRegex2 = StringRegExp($aRegex[0], "(-?\d+)\^(\d+)", 1)
		$aRes = _GMP_PowInteger($aRegex2[0], $aRegex2[1])
		$sLine = StringReplace($sLine, $aRegex[0], $aRes)
	WEnd
	While StringRegExp($sLine, "\*|/|%")
		$aRegex = StringRegExp($sLine, "(?:-)(-\d+\*-?\d+)|(?:\+)(-\d+\*-?\d+)|\d+\*-?\d+|(?:-)(-\d+/-?\d+)|(?:\+)(-\d+/-?\d+)|\d+/-?\d+|(?:-)(-\d+%-?\d+)|(?:\+)(-\d+%-?\d+)|\d+%-?\d+", 1)
		If StringInStr($aRegex[0], "*") Then
			$aRegex2 = StringRegExp($aRegex[0], "(-?\d+)\*(-?\d+)", 1)
			$aRes = _GMP_MulInteger($aRegex2[0], $aRegex2[1])
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		ElseIf StringInStr($aRegex[0], "%") Then
			$aRegex2 = StringRegExp($aRegex[0], "(-?\d+)%(-?\d+)", 1)
			$aRes = _GMP_DivIntegerr($aRegex2[0], $aRegex2[1])
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		Else
			$aRegex2 = StringRegExp($aRegex[0], "(-?\d+)/(-?\d+)", 1)
			$aRes = _GMP_DivIntegerq($aRegex2[0], $aRegex2[1])
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		EndIf
	WEnd
	While StringRegExp($sLine, "\d+\+-?\d+|\d+-+\d+")
		$aRegex = StringRegExp($sLine, "-?\d+\+-?\d+|-?\d+-+\d+", 1)
		If StringInStr($aRegex[0], "+") Then
			$aRegex2 = StringRegExp($aRegex[0], "(-?\d+)\+(-?\d+)", 1)
			$aRes = _GMP_AddInteger($aRegex2[0], $aRegex2[1])
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		Else
			$aRegex2 = StringRegExp($aRegex[0], "(-?\d+)-(-?\d+)", 1)
			$aRes = _GMP_SubInteger($aRegex2[0], $aRegex2[1])
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		EndIf
	WEnd
	Return $sLine
EndFunc   ;==>_GMP_ParseInt


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_ParseFloat
; Description ...: Attempts to calculate the result of the floating point string
; Syntax.........: _GMP_ParseFloat($sLine, $iDigits)
; Parameters ....: $sLine - e.g. "2^-6+34.2451*((128/3).23+22/7)"
;                  ^ : Power
;                  * : Muliply
;                  / : Divide
;                  + : Add
;                  - : Subtract
;                  $iDigits - Approximate precision, most significant.
; Return values .: Calculated result
; ===============================================================================================================================
Func _GMP_ParseFloat($sLine, $iDigits = 128)
	$sLine = StringStripWS($sLine, 8)
	If StringInStr($sLine, "(") Then
		$sParStart = StringInStr($sLine, "(")
		$sParEnd = StringInStr($sLine, ")", 0, -1)
		$sParMid = StringMid($sLine, $sParStart + 1, $sParEnd - $sParStart - 1)
		$sParNew = _GMP_ParseFloat($sParMid, $iDigits)
		If StringRegExp(StringMid($sLine, $sParStart - 1, 1), "\d") Then $sParNew = "*" & $sParNew
		If StringRegExp(StringMid($sLine, $sParEnd + 1, 1), "\d|\.") Then $sParNew &= "*"
		$sLine = StringReplace($sLine, "(" & $sParMid & ")", $sParNew)
	EndIf
	While StringInStr($sLine, "^")
		$aRegex = StringRegExp($sLine, "(?:-)(-[\d\.]*\d+\^-?[\d\.]*\d+)|(?:\+)(-[\d\.]*\d+\^-?[\d\.]*\d+)|[\d\.]*\d+\^-?[\d\.]*\d+", 1)
		$aRegex2 = StringRegExp($aRegex[0], "(-?[\d\.]*\d+)\^(-?[\d\.]*\d+)", 1)
		$aRes = _GMP_PowFloat($aRegex2[0], $aRegex2[1], $iDigits)
		$sLine = StringReplace($sLine, $aRegex[0], $aRes)
	WEnd
	While StringRegExp($sLine, "\*|/")
		$aRegex = StringRegExp($sLine, "(?:-)(-[\d\.]*\d+\*-?[\d\.]*\d+)|(?:\+)(-[\d\.]*\d+\*-?[\d\.]*\d+)|[\d\.]*\d+\*-?[\d\.]*\d+|(?:-)(-[\d\.]*\d+/-?[\d\.]*\d+)|(?:\+)(-[\d\.]*\d+/-?[\d\.]*\d+)|[\d\.]*\d+/-?[\d\.]*\d+", 1)
		If StringInStr($aRegex[0], "*") Then
			$aRegex2 = StringRegExp($aRegex[0], "(-?[\d\.]*\d+)\*(-?[\d\.]*\d+)", 1)
			$aRes = _GMP_MulFloat($aRegex2[0], $aRegex2[1], $iDigits)
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		Else
			$aRegex2 = StringRegExp($aRegex[0], "(-?[\d\.]*\d+)/(-?[\d\.]*\d+)", 1)
			$aRes = _GMP_DivFloat($aRegex2[0], $aRegex2[1], $iDigits)
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		EndIf
	WEnd
	While StringRegExp($sLine, "[\d\.]*\d+\+-?[\d\.]*\d+|[\d\.]*\d+-+[\d\.]*\d+")
		$aRegex = StringRegExp($sLine, "-?[\d\.]*\d+\+-?[\d\.]*\d+|-?[\d\.]*\d+-+[\d\.]*\d+", 1)
		If StringInStr($aRegex[0], "+") Then
			$aRegex2 = StringRegExp($aRegex[0], "(-?[\d\.]*\d+)\+(-?[\d\.]*\d+)", 1)
			$aRes = _GMP_AddFloat($aRegex2[0], $aRegex2[1], $iDigits)
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		Else
			$aRegex2 = StringRegExp($aRegex[0], "(-?[\d\.]*\d+)-(-?[\d\.]*\d+)", 1)
			$aRes = _GMP_SubFloat($aRegex2[0], $aRegex2[1], $iDigits)
			$sLine = StringReplace($sLine, $aRegex[0], $aRes)
		EndIf
	WEnd
	Return $sLine
EndFunc   ;==>_GMP_ParseFloat


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_HexToInt
; Description ...: Converts the hexadecimal input into an integer
; Syntax.........: _GMP_HexToInt($sValue)
; Parameters ....: $sValue - Any hex value e.g. "2B992DDFA23249D6"
; Return values .: Resulting integer
; ===============================================================================================================================
Func _GMP_HexToInt($sValue)
	Local $t_Value = DllStructCreate($tag_mpz_t)
	Local $p_Value = DllStructGetPtr($t_Value)
	_GMPz_Init_Set_Str($p_Value, $sValue, 16)
	Local $sRes = _GMPz_get_Str($p_Value)
	_GMPz_Clear($p_Value)
	$t_Value = 0
	Return $sRes
EndFunc   ;==>_GMP_HexToInt


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_IntToHex
; Description ...: Converts the integer input into a hexadecimal
; Syntax.........: _GMP_IntToHex($sValue)
; Parameters ....: $sValue - Any integer e.g. "3141592653589793238"
; Return values .: Resulting hexadecimal
; ===============================================================================================================================
Func _GMP_IntToHex($sValue)
	Local $t_Value = DllStructCreate($tag_mpz_t)
	Local $p_Value = DllStructGetPtr($t_Value)
	_GMPz_Init_Set_Str($p_Value, $sValue)
	Local $sRes = _GMPz_get_Str($p_Value, 16)
	_GMPz_Clear($p_Value)
	$t_Value = 0
	Return StringUpper($sRes)
EndFunc   ;==>_GMP_IntToHex


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_AddInteger
; Description ...: Adds $sValue1 and $sValue2
; Syntax.........: _GMP_AddInteger($sValue1, $sValue2)
; Parameters ....: $sValue's - Any integer e.g. "31415926535897932384626433832795"
; Return values .: Resulting integer
; ===============================================================================================================================
Func _GMP_AddInteger($sValue1, $sValue2)
	Local $t_Value1 = DllStructCreate($tag_mpz_t), $t_Value2 = DllStructCreate($tag_mpz_t)
	Local $p_Value1 = DllStructGetPtr($t_Value1), $p_Value2 = DllStructGetPtr($t_Value2)
	_GMPz_Init_Set_Str($p_Value1, $sValue1)
	_GMPz_Init_Set_Str($p_Value2, $sValue2)
	_GMPz_Add($p_Value1, $p_Value1, $p_Value2)
	Local $sRes = _GMPz_get_Str($p_Value1)
	_GMPz_Clear($p_Value1)
	_GMPz_Clear($p_Value2)
	$t_Value1 = 0
	$t_Value2 = 0
	Return $sRes
EndFunc   ;==>_GMP_AddInteger


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_SubInteger
; Description ...: Subtracts $sValue2 from $sValue1
; Syntax.........: _GMP_SubInteger($sValue1, $sValue2)
; Parameters ....: $sValue's - Any integer e.g. "59723833462648323979853562951413"
; Return values .: Resulting integer
; ===============================================================================================================================
Func _GMP_SubInteger($sValue1, $sValue2)
	Local $t_Value1 = DllStructCreate($tag_mpz_t), $t_Value2 = DllStructCreate($tag_mpz_t)
	Local $p_Value1 = DllStructGetPtr($t_Value1), $p_Value2 = DllStructGetPtr($t_Value2)
	_GMPz_Init_Set_Str($p_Value1, $sValue1)
	_GMPz_Init_Set_Str($p_Value2, $sValue2)
	_GMPz_Sub($p_Value1, $p_Value1, $p_Value2)
	Local $sRes = _GMPz_get_Str($p_Value1)
	_GMPz_Clear($p_Value1)
	_GMPz_Clear($p_Value2)
	$t_Value1 = 0
	$t_Value2 = 0
	Return $sRes
EndFunc   ;==>_GMP_SubInteger


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_MulInteger
; Description ...: Multiplies the two integers
; Syntax.........: _GMP_MulInteger($sValue1, $sValue2)
; Parameters ....: $sValue's - Any integer e.g. "4626483239798535"
; Return values .: Resulting integer
; ===============================================================================================================================
Func _GMP_MulInteger($sValue1, $sValue2)
	Local $t_Value1 = DllStructCreate($tag_mpz_t), $t_Value2 = DllStructCreate($tag_mpz_t)
	Local $p_Value1 = DllStructGetPtr($t_Value1), $p_Value2 = DllStructGetPtr($t_Value2)
	_GMPz_Init_Set_Str($p_Value1, $sValue1)
	_GMPz_Init_Set_Str($p_Value2, $sValue2)
	_GMPz_Mul($p_Value1, $p_Value1, $p_Value2)
	Local $sRes = _GMPz_get_Str($p_Value1)
	_GMPz_Clear($p_Value1)
	_GMPz_Clear($p_Value2)
	$t_Value1 = 0
	$t_Value2 = 0
	Return $sRes
EndFunc   ;==>_GMP_MulInteger


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_DivInteger
; Description ...: Divides $sDividend by $sDivisor
; Syntax.........: _GMP_DivInteger($sDividend, $sDivisor)
; Parameters ....: $sDividend - Any number e.g. "483239794626483239798535"
;                  $sDivisor - Any number e.g. "42"
; Return values .: Returns 0 base array of quotient and remainder
; ===============================================================================================================================
Func _GMP_DivInteger($sDividend, $sDivisor)
	Local $t_Dividend = DllStructCreate($tag_mpz_t), $t_Divisor = DllStructCreate($tag_mpz_t)
	Local $p_Dividend = DllStructGetPtr($t_Dividend), $p_Divisor = DllStructGetPtr($t_Divisor)
	Local $aRes[2]
	_GMPz_Init_Set_Str($p_Dividend, $sDividend)
	_GMPz_Init_Set_Str($p_Divisor, $sDivisor)
	_GMPz_Div_qr($p_Dividend, $p_Divisor, $p_Dividend, $p_Divisor)
	$aRes[0] = _GMPz_get_Str($p_Dividend)
	$aRes[1] = _GMPz_get_Str($p_Divisor)
	_GMPz_Clear($p_Dividend)
	_GMPz_Clear($p_Divisor)
	$t_Dividend = 0
	$t_Divisor = 0
	Return $aRes
EndFunc   ;==>_GMP_DivInteger


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_PowInteger
; Description ...: Raises $sBase to the power of $sExp
; Syntax.........: _GMP_PowInteger($sBase, $sExp)
; Parameters ....: $sBase - Any integer e.g. "24"
;                  $sExp - Any integer e.g. "42"
; Return values .: Resulting integer
; Remarks .......: Exponent must be a positive integer.
; ===============================================================================================================================
Func _GMP_PowInteger($sBase, $sExp)
	If $sExp = 0 Then Return 1
	Local $t_Base = DllStructCreate($tag_mpz_t)
	Local $p_Base = DllStructGetPtr($t_Base)
	_GMPz_Init_Set_Str($p_Base, $sBase)
	_GMPz_Pow_ui($p_Base, $p_Base, $sExp)
	Local $sRes = _GMPz_get_Str($p_Base)
	_GMPz_Clear($p_Base)
	$t_Base = 0
	Return $sRes
EndFunc   ;==>_GMP_PowInteger


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_SqrtInteger
; Description ...: Returns the squre root of $sValue
; Syntax.........: _GMP_SqrtInteger($sValue)
; Parameters ....: $sValue - Any integer e.g. "36"
; Return values .: Resulting integer
; Remarks .......: Result will be truncated at the decimal point.
; ===============================================================================================================================
Func _GMP_SqrtInteger($sValue)
	Local $t_Value = DllStructCreate($tag_mpz_t)
	Local $p_Value = DllStructGetPtr($t_Value)
	_GMPz_Init_Set_Str($p_Value, $sValue)
	_GMPz_Sqrt($p_Value, $p_Value)
	Local $sRes = _GMPz_get_Str($p_Value)
	_GMPz_Clear($p_Value)
	$t_Value = 0
	Return $sRes
EndFunc   ;==>_GMP_SqrtInteger


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_AddFloat
; Description ...: Adds $sValue1 and $sValue2
; Syntax.........: _GMP_AddFloat($sValue1, $sValue2[, $iDigits])
; Parameters ....: $sValue's - Any number e.g. "46264832.39798535"
;                  $iDigits - Approximate precision
; Return values .: Resulting floating point number
; ===============================================================================================================================
Func _GMP_AddFloat($sValue1, $sValue2, $iDigits = 128)
	Local $t_Value1 = DllStructCreate($tag_mpf_t), $t_Value2 = DllStructCreate($tag_mpf_t)
	Local $p_Value1 = DllStructGetPtr($t_Value1), $p_Value2 = DllStructGetPtr($t_Value2)
	_GMPf_Init2($p_Value1, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Value1, $sValue1)
	_GMPf_Init2($p_Value2, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Value2, $sValue2)
	_GMPf_Add($p_Value1, $p_Value1, $p_Value2)
	Local $sRes = _GMPf_get_Str($p_Value1)
	_GMPf_Clear($p_Value1)
	_GMPf_Clear($p_Value2)
	$t_Value1 = 0
	$t_Value2 = 0
	Return $sRes
EndFunc   ;==>_GMP_AddFloat


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_SubFloat
; Description ...: Subtracts $sValue2 from $sValue1
; Syntax.........: _GMP_SubFloat($sValue1, $sValue2[, $iDigits])
; Parameters ....: $sValue's - Any number e.g. "46264832.39798535"
;                  $iDigits - Approximate precision
; Return values .: Resulting floating point number
; ===============================================================================================================================
Func _GMP_SubFloat($sValue1, $sValue2, $iDigits = 128)
	Local $t_Value1 = DllStructCreate($tag_mpf_t), $t_Value2 = DllStructCreate($tag_mpf_t)
	Local $p_Value1 = DllStructGetPtr($t_Value1), $p_Value2 = DllStructGetPtr($t_Value2)
	_GMPf_Init2($p_Value1, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Value1, $sValue1)
	_GMPf_Init2($p_Value2, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Value2, $sValue2)
	_GMPf_Sub($p_Value1, $p_Value1, $p_Value2)
	Local $sRes = _GMPf_get_Str($p_Value1)
	_GMPf_Clear($p_Value1)
	_GMPf_Clear($p_Value2)
	$t_Value1 = 0
	$t_Value2 = 0
	Return $sRes
EndFunc   ;==>_GMP_SubFloat


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_MulFloat
; Description ...: Multiplies $sValue1 by $sValue2
; Syntax.........: _GMP_MulFloat($sValue1, $sValue2[, $iDigits])
; Parameters ....: $sValue's - Any number e.g. "46264832.39798535"
;                  $iDigits - Approximate precision
; Return values .: Resulting floating point number
; ===============================================================================================================================
Func _GMP_MulFloat($sValue1, $sValue2, $iDigits = 128)
	Local $t_Value1 = DllStructCreate($tag_mpf_t), $t_Value2 = DllStructCreate($tag_mpf_t)
	Local $p_Value1 = DllStructGetPtr($t_Value1), $p_Value2 = DllStructGetPtr($t_Value2)
	_GMPf_Init2($p_Value1, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Value1, $sValue1)
	_GMPf_Init2($p_Value2, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Value2, $sValue2)
	_GMPf_Mul($p_Value1, $p_Value1, $p_Value2)
	Local $sRes = _GMPf_get_Str($p_Value1)
	_GMPf_Clear($p_Value1)
	_GMPf_Clear($p_Value2)
	$t_Value1 = 0
	$t_Value2 = 0
	Return $sRes
EndFunc   ;==>_GMP_MulFloat


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_DivFloat
; Description ...: Dividies $sDividend by $sDivisor
; Syntax.........: _GMP_DivFloat($sDividend, $sDivisor[, $iDigits])
; Parameters ....: $sDividend - Any number e.g. "32281.2"
;                  $sDivisor - Any number e.g. "42"
;                  $iDigits - Approximate precision
; Return values .: Resulting floating point number
; ===============================================================================================================================
Func _GMP_DivFloat($sDividend, $sDivisor, $iDigits = 128)
	Local $t_Dividend = DllStructCreate($tag_mpf_t), $t_Divisor = DllStructCreate($tag_mpf_t)
	Local $p_Dividend = DllStructGetPtr($t_Dividend), $p_Divisor = DllStructGetPtr($t_Divisor)
	_GMPf_Init2($p_Dividend, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Dividend, $sDividend)
	_GMPf_Init2($p_Divisor, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Divisor, $sDivisor)
	_GMPf_Div($p_Dividend, $p_Dividend, $p_Divisor)
	Local $sRes = _GMPf_get_Str($p_Dividend)
	_GMPf_Clear($p_Dividend)
	_GMPf_Clear($p_Divisor)
	$t_Dividend = 0
	$t_Divisor = 0
	Return $sRes
EndFunc   ;==>_GMP_DivFloat


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_PowFloat
; Description ...: Raises $sBase to the power of $sExp
; Syntax.........: _GMP_PowFloat($sBase, $sExp[, $iDigits])
; Parameters ....: $sBase - Any number e.g. "24.3"
;                  $sExp - Any integer e.g. "42"
;                  $iDigits - Approximate precision
; Return values .: Resulting floating point number
; Remarks .......: Exponent must be an integer.
; ===============================================================================================================================
Func _GMP_PowFloat($sBase, $sExp, $iDigits = 128)
	If StringLeft($sExp, 1) = "-" Then
		$sExp = StringTrimLeft($sExp, 1)
		$sBase = _GMP_DivFloat("1", $sBase)
	EndIf
	Local $t_Base = DllStructCreate($tag_mpf_t), $t_Result = DllStructCreate($tag_mpf_t)
	Local $p_Base = DllStructGetPtr($t_Base), $p_Result = DllStructGetPtr($t_Result)
	_GMPf_Init2($p_Base, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Base, $sBase)
	_GMPf_Init2($p_Result, Round($iDigits * 3.25))
	_GMPf_Pow_ui($p_Result, $p_Base, $sExp)
	Local $sRes = _GMPf_get_Str($p_Result)
	_GMPf_Clear($p_Base)
	_GMPf_Clear($p_Result)
	$t_Base = 0
	$t_Result = 0
	Return $sRes
EndFunc   ;==>_GMP_PowFloat


; #FUNCTION# ====================================================================================================================
; Name...........: _GMP_SqrtFloat
; Description ...: Returns the squre root of $sValue
; Syntax.........: _GMP_SqrtFloat($sValue[, $iDigits])
; Parameters ....: $sValue - Any number e.g. "22"
;                  $iDigits - Approximate precision
; Return values .: Resulting floating point number
; ===============================================================================================================================
Func _GMP_SqrtFloat($sValue, $iDigits = 128)
	Local $t_Value = DllStructCreate($tag_mpf_t)
	Local $p_Value = DllStructGetPtr($t_Value)
	_GMPf_Init2($p_Value, Round($iDigits * 3.25))
	_GMPf_Set_Str($p_Value, $sValue)
	_GMPf_Sqrt($p_Value, $p_Value)
	Local $sRes = _GMPf_get_Str($p_Value)
	_GMPf_Clear($p_Value)
	$t_Value = 0
	Return $sRes
EndFunc   ;==>_GMP_SqrtFloat





#region Begin Internal Functions
#region Begin Integer Fuctions
Func _GMPz_Init_Set_Str($pVal, $sVal, $iBase = 10)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_init_set_str", "ptr", $pVal, "str", $sVal, "int", $iBase)
EndFunc   ;==>_GMPz_Init_Set_Str

Func _GMPz_Add($pResult, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_add", "ptr", $pResult, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPz_Add

Func _GMPz_Sub($pResult, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_sub", "ptr", $pResult, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPz_Sub

Func _GMPz_Mul($pResult, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_mul", "ptr", $pResult, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPz_Mul

Func _GMPz_Div_qr($pResultq, $pResultr, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_tdiv_qr", "ptr", $pResultq, "ptr", $pResultr, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPz_Div_qr

Func _GMPz_Pow_ui($pResult, $pVal, $iExp)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_pow_ui", "ptr", $pResult, "ptr", $pVal, "ULONG", $iExp)
EndFunc   ;==>_GMPz_Pow_ui

Func _GMPz_Sqrt($pResult, $pVal)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_sqrt", "ptr", $pResult, "ptr", $pVal)
EndFunc   ;==>_GMPz_Sqrt

Func _GMPz_get_Str($pVal1, $iBase = 10)
	Local $aRet = DllCall($hDLL_GMP, "str:cdecl", "__gmpz_get_str", "ptr", 0, "int", $iBase, "ptr", $pVal1)
	Return $aRet[0]
EndFunc   ;==>_GMPz_get_Str

Func _GMPz_Clear($pVal)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_clear", "ptr", $pVal)
EndFunc   ;==>_GMPz_Clear
#endregion Begin Integer Fuctions

#region Begin Floating Point Fuctions
Func _GMPf_Init2($pVal, $iPrec)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_init2", "ptr", $pVal, "ULONG", $iPrec)
EndFunc   ;==>_GMPf_Init2

Func _GMPf_Set_Str($pVal, $sVal, $iBase = 10)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_set_str", "ptr", $pVal, "str", $sVal, "int", $iBase)
EndFunc   ;==>_GMPf_Set_Str

Func _GMPf_Add($pResult, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_add", "ptr", $pResult, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPf_Add

Func _GMPf_Sub($pResult, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_sub", "ptr", $pResult, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPf_Sub

Func _GMPf_Mul($pResult, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_mul", "ptr", $pResult, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPf_Mul

Func _GMPf_Div($pResult, $pVal1, $pVal2)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_div", "ptr", $pResult, "ptr", $pVal1, "ptr", $pVal2)
EndFunc   ;==>_GMPf_Div

Func _GMPf_Pow_ui($pResult, $pVal, $iExp)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_pow_ui", "ptr", $pResult, "ptr", $pVal, "ULONG", $iExp)
EndFunc   ;==>_GMPf_Pow_ui

Func _GMPf_Sqrt($pResult, $pVal)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_sqrt", "ptr", $pResult, "ptr", $pVal)
EndFunc   ;==>_GMPf_Sqrt

Func _GMPf_get_Str($pVal1, $iBase = 10)
	Local $aRet = DllCall($hDLL_GMP, "str:cdecl", "__gmpf_get_str", "str", "", "int*", 0, "int", $iBase, "int", 0, "ptr", $pVal1)
	$sCleaned = StringReplace($aRet[1], "-", "")
	Select
		Case StringLen($sCleaned) < $aRet[2]
			$sValue = _ZeroAppend($sCleaned, $aRet[2])
		Case StringLen($sCleaned) = $aRet[2]
			$sValue = $sCleaned
		Case $aRet[2] < 1
			$sValue = _ZeroPrepend($sCleaned, StringTrimLeft($aRet[2], 1))
		Case Else
			$sValue = StringLeft($sCleaned, $aRet[2]) & "." & StringTrimLeft($sCleaned, $aRet[2])
	EndSelect
	If StringInStr($aRet[1], "-") Then
		Return "-" & $sValue
	Else
		Return $sValue
	EndIf
EndFunc   ;==>_GMPf_get_Str

Func _GMPf_Clear($pVal)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_clear", "ptr", $pVal)
EndFunc   ;==>_GMPf_Clear
#endregion Begin Floating Point Fuctions

#region Begin Other Functions
Func _GMP_DivIntegerq($sDividend, $sDivisor)
	$aRes = _GMP_DivInteger($sDividend, $sDivisor)
	Return $aRes[0]
EndFunc   ;==>_GMP_DivIntegerq

Func _GMP_DivIntegerr($sDividend, $sDivisor)
	$aRes = _GMP_DivInteger($sDividend, $sDivisor)
	Return $aRes[1]
EndFunc   ;==>_GMP_DivIntegerr

Func _ZeroAppend($zInput, $zTotal)
	For $z = 1 To $zTotal - StringLen($zInput)
		$zInput &= "0"
	Next
	Return $zInput
EndFunc   ;==>_ZeroAppend

Func _ZeroPrepend($zInput, $zTotal)
	For $z = 1 To $zTotal
		$zInput = "0" & $zInput
	Next
	Return "0." & $zInput
EndFunc   ;==>_ZeroPrepend

Func _CloseDLL()
	DllClose($hDLL_GMP)
EndFunc   ;==>_CloseDLL
#endregion Begin Other Functions

#region Begin Unused Functions
Func _GMPz_Init($pVal)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpz_init", "ptr", $pVal)
EndFunc   ;==>_GMPz_Init

Func _GMPf_Init($pVal)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_init", "ptr", $pVal)
EndFunc   ;==>_GMPf_Init

Func _GMPf_Init_Set_Str($pVal, $sVal, $iBase = 10)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_init_set_str", "ptr", $pVal, "str", $sVal, "int", $iBase)
EndFunc   ;==>_GMPf_Init_Set_Str

Func _GMPf_SetDefaultPrec($iPrec)
	DllCall($hDLL_GMP, "none:cdecl", "__gmpf_set_default_prec", "ULONG", $iPrec)
EndFunc   ;==>_GMPf_SetDefaultPrec

Func _GMPf_GetDefaultPrec()
	Local $aRet = DllCall($hDLL_GMP, "ULONG:cdecl", "__gmpf_get_default_prec")
	Return $aRet[0]
EndFunc   ;==>_GMPf_GetDefaultPrec

Func _GMPf_GetPrec($pVal)
	Local $aRet = DllCall($hDLL_GMP, "ULONG:cdecl", "__gmpf_get_prec", "ptr", $pVal)
	Return $aRet[0]
EndFunc   ;==>_GMPf_GetPrec
#endregion Begin Unused Functions
#endregion Begin Internal Functions