;===============================================================================
;
; Function Name:    _Base64Encode(), _Base64Decode()
; Description:      Convert: String to Base64, Base64 to String
; Parameter(s):     $s_PlainText String to convert to Base64 String
;					$s_CypherText Base64 String to convert to String
; Requirement(s):   none
; Return Value(s):  On Success - Returns value
;                   On Failure - Returns -1  and sets ;Ony with _Base64Decode()
;											@ERROR = 1		-	Invalid Parameters
;
; Authors:        Original functions  						- http://minasi.com/64.htm AND                                                      
;					Conversion to AutoIt					- bkemmler's VBScript to AutoIt Converter
;					Edit for UDF and Cleanup Code			- Mikeytown2
;					Faster Dec & Bin Codes					- sylvanie
;					Speed Increases all around				- Mikeytown2
;
;===============================================================================

#include-once

Func _BinToDec($i_Bin)
	Local $i_End = StringLen($i_Bin)
	Local $i_DecOut = 0
	Local $i_Count
	For $i_Count = 1 To $i_End
		Select
			Case StringMid($i_Bin, $i_End + 1 - $i_Count, 1) = "1"
				$i_DecOut = BitXOR($i_DecOut, BitShift(1, - ($i_Count - 1)))
		EndSelect
	Next
	Return $i_DecOut
EndFunc   ;==>_BinToDec

Func _DecToBin($i_Dec)
	Local $s_Bin = ""
	While $i_Dec <> 0
		$s_Bin = BitAND($i_Dec, 1) & $s_Bin
		$i_Dec = BitShift($i_Dec, 1)
	WEnd
	Return $s_Bin
EndFunc   ;==>_DecToBin

Func _Base64Encode($s_PlainText) ;takes an arbitrary length string and base 64 encodes it
	Local $s_Reslt = "", $as_PlaTxt, $i_Count = 0
	$s_PlainText = StringStripWS($s_PlainText, 3)
	$as_PlaTxt = StringSplit($s_PlainText, "")
	
	$i_End = Int(Ceiling($as_PlaTxt[0] / 3) - 2) ;int is a bug fix when you enter in 11 digits into this function.
	
	If $as_PlaTxt[0] > 4 Then ;run big loop if string is longer then 4
		For $i_Count = 0 To $i_End Step + 1 ;the big loop 
			$s_Reslt = $s_Reslt & _ConvTo64(StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 1])), 8) & StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 2])), 8) & StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 3])), 8))
		Next
	EndIf
	
	Select ;final run
		Case $as_PlaTxt[0] - $i_Count * 3 = 1
			$s_Reslt = $s_Reslt & _ConvTo64(StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 1])), 8))
		Case $as_PlaTxt[0] - $i_Count * 3 = 2
			$s_Reslt = $s_Reslt & _ConvTo64(StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 1])), 8) & StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 2])), 8))
		Case $as_PlaTxt[0] - $i_Count * 3 = 3
			$s_Reslt = $s_Reslt & _ConvTo64(StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 1])), 8) & StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 2])), 8) & StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 3])), 8))
		Case $as_PlaTxt[0] = 4
			$s_Reslt = $s_Reslt & _ConvTo64(StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 1])), 8) & StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 2])), 8) & StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 3])), 8)) & _ConvTo64(StringRight("00000000" & _DecToBin(Asc($as_PlaTxt[$i_Count * 3 + 4])), 8))
		Case Else
			$s_Reslt = "==="
	EndSelect
	
	Return $s_Reslt
EndFunc   ;==>_Base64Encode

;This could be faster
Func _Base64Decode($s_CypherText) ;takes an arbitrary length base64 string and decodes it
	Local $s_Out, $s_StrOut
	
	$s_CypherText = StringStripWS($s_CypherText, 3) ;strip leading and trailing whitespaces
	If Mod(StringLen($s_CypherText), 4) Then
		;trim to be multiple of four
		$s_CypherText = StringLeft($s_CypherText, StringLen($s_CypherText) - ( Mod(StringLen($s_CypherText), 4)))
	EndIf
	
	While StringLen($s_CypherText) > 0
		;pluck the next piece
		$s_StrOut = _ConvFrom64(StringLeft($s_CypherText, 4))
		If @error Then
			SetError(1)
			Return -1
		EndIf
		$s_CypherText = StringMid($s_CypherText, 5)
		$s_Out = $s_Out & $s_StrOut
	WEnd
	Return $s_Out
EndFunc   ;==>_Base64Decode

; internals routines----------------------------------
Func _ConvFrom64($s_TextIn)
	Local $s_Bytes
	Local $s_TextInMid = StringRight($s_TextIn, 1)
	
	$s_Bytes = _RLookUpB64(StringLeft($s_TextIn, 1)) & _RLookUpB64(StringMid($s_TextIn, 2, 1)) & _RLookUpB64(StringMid($s_TextIn, 3, 1)) & _RLookUpB64(StringRight($s_TextIn, 1))
	If @error Then
		SetError(1)
		Return -1
	EndIf
	; classify three, two or one byte
	Select
		;Case StringLeft($s_TextIn, 1) & StringMid($s_TextIn, 3, 1) & $s_TextInMid = "==="
			;return zero byte
		Case StringMid($s_TextIn, 3, 1) & $s_TextInMid = "=="
			Return Chr(_BinToDec(StringLeft($s_Bytes, 8)))
		Case $s_TextInMid = "="
			Return Chr(_BinToDec(StringLeft($s_Bytes, 8))) & Chr(_BinToDec(StringMid($s_Bytes, 9, 8)))
		Case Else
			Return Chr(_BinToDec(StringLeft($s_Bytes, 8))) & Chr(_BinToDec(StringMid($s_Bytes, 9, 8))) & Chr(_BinToDec(StringRight($s_Bytes, 8)))
	EndSelect
EndFunc   ;==>_ConvFrom64

Func _RLookUpB64($s_CharIn) ;given $a base 64 char $a-z $a-Z 0-9 +/ returns binary value of b64 "digit"
	$s_CharIn = Asc($s_CharIn) ;now we've got the decimal, make it binary
	Select 
		Case $s_CharIn >= 65 And $s_CharIn <= 90
			Return StringRight("000000" & _DecToBin($s_CharIn - 65), 6)
		Case $s_CharIn >= 97 And $s_CharIn <= 102
			Return "0" & _DecToBin($s_CharIn - 97 + 26)
		Case $s_CharIn >= 103 And $s_CharIn <= 122
			Return _DecToBin($s_CharIn - 97 + 26)
		Case $s_CharIn >= 48 And $s_CharIn <= 57
			Return _DecToBin($s_CharIn - 48 + 52)
		Case $s_CharIn = 43
			Return _DecToBin(62)
		Case $s_CharIn = 47
			Return _DecToBin(63)
		Case $s_CharIn = 61
			Return "000000"
		Case Else
			SetError(1)
			Return -1
	EndSelect
EndFunc   ;==>_RLookUpB64

Func _ConvTo64($s_BinStr)
	;Given 24 bits, produce four base64 characters
	;Given 16 bits, produce three base64 chars and an =
	;Given 8 bits, produce two base64 chars and two ==

	;Step one:  extract and convert the leftmost quad and pre-fill the third/fourth
	;Step two:  three different approaches
	Local $i_BinStrLen = StringLen($s_BinStr)
	Select
		Case $i_BinStrLen = 24
			Return _LookUp64(StringLeft($s_BinStr, 6)) & _LookUp64(StringMid($s_BinStr, 7, 6)) & _LookUp64(StringMid($s_BinStr, 13, 6)) & _LookUp64(StringRight($s_BinStr, 6))
		Case $i_BinStrLen = 16
			Return _LookUp64(StringLeft($s_BinStr, 6)) & _LookUp64(StringMid($s_BinStr, 7, 6)) & _LookUp64((StringMid($s_BinStr, 13, 4) & "00")) & "="
		Case Else
			Return _LookUp64(StringLeft($s_BinStr, 6)) & _LookUp64((StringMid($s_BinStr, 7, 2) & "0000")) & "=="
	EndSelect
EndFunc   ;==>_ConvTo64

Func _LookUp64($i_Bin6)
	;given $a six-bit string, look up and return a base64 character
	$i_Bin6 = _BinToDec($i_Bin6) + 1 ;convert to an integer
	Select
		Case $i_Bin6 <= 26
			Return Chr($i_Bin6 - 1 + 65)
		Case $i_Bin6 > 26 And $i_Bin6 <= 52
			Return Chr($i_Bin6 - 27 + 97)
		Case $i_Bin6 > 52 And $i_Bin6 <= 62
			Return Chr($i_Bin6 - 53 + 48) ;digits
		Case $i_Bin6 = 63
			Return "+"
		Case $i_Bin6 = 64
			Return "/"
		Case Else
			SetError(1)
			Return -1
	EndSelect
EndFunc   ;==>_LookUp64