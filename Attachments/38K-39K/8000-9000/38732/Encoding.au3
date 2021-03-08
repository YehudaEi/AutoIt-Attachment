#include-once

#CS Header
	; # UDF Info # ==================================================================================================
	; AutoIt.........:  3.3.0.0 +
	; UDF Version....:  1.5
	; Name...........:  Encoding.au3
	; Description....:  Collection of functions that is used to work with different string encoding.
	;
	; Author(s)......:  (Mr)CreatoR, amel27, LEX1, trancexx, Ward, Latoid, LazyCat (Loopback)
	; Remarks........:
	; Related........:
	; Link...........:
	; Example........:	Yes. See the attached examples.
	;
	; Version History:
	;                  [v1.5], 24.09.2012
	;                   * UDF encoding changed back to code page (ANSI), it was causing problems with syntax checking utility.
	;                   * _Encoding_HexSymbolsToANSI renamed to _Encoding_QuotedPrintableToANSI. _Encoding_HexSymbolsToANSI still supported (depracated).
	;
	;                  [v1.4], 26.01.2011
	;                   * Updated/Fixed _Encoding_Base64* functions.
	;
	;                  [v1.3], 20.07.2010
	;                   * Fixed _Encoding_Base64Decode function, wrong return on non-ANSI characters.
	;
	;                  [v1.2], 20.05.2010
	;                   + Added _Encoding_ISO8859To1251 function.
	;
	;                  [v1.1], 25.01.2010
	;                   * Global functions renaming, instead of "_String" prefix now used "_Encoding_" prefix.
	;                   * Fixed _StringIsUTF8Format (_Encoding_IsUTF8Format),
	;                     and added parameter $iCheckASCIICode (default is False) to check the special ASCII symbols (Char < 128).
	;                   + Added 7 more functions:
	;                       1) _Encoding_CyrillicTo1251 - Converts cyrillic string of any encoding to Microsoft 1251 codepage.
	;                       2) _Encoding_HexSymbolsToANSI - Converts HEX symbols in string (Ex.: "=D2=C1=C2=CF") to ANSI symbols.
	;                       3) _Encoding_GetCyrillicANSIEncoding - Finds out the ANSI encoding of cyrillic string.
	;                            Needs at least 3-4 proper Russian words for certain definition.
	;                       4) _Encoding_866To1251 - Converts cyrillic string from IBM 866 codepage to Microsoft 1251 codepage.
	;                       5) _Encoding_KOI8To1251 - Converts cyrillic string from KOI8-R to Microsoft 1251 codepage.
	;                       6) _Encoding_ISO8859To1251 - Converts cyrillic string from ISO-8859-5 to Microsoft 1251 codepage.
	;                       7) _Encoding_GetFileEncoding - Gets the encoding type of specified file.
	;
	;
	; ===============================================================================================================
	
	Functions List:
	
		_Encoding_866To1251
		_Encoding_ANSIToOEM
		_Encoding_ANSIToUTF8
		_Encoding_Base64Decode
		_Encoding_Base64Encode
		_Encoding_CyrillicTo1251
		_Encoding_GetCyrillicANSIEncoding
		_Encoding_GetFileEncoding
		_Encoding_QuotedPrintableToANSI
		_Encoding_HexToURL
		_Encoding_ISO88591To1251
		_Encoding_ISO8859To1251
		_Encoding_IsUTF8Format
		_Encoding_JavaUnicodeDecode
		_Encoding_JavaUnicodeEncode
		_Encoding_KOI8To1251
		_Encoding_OEM2ANSI
		_Encoding_StringToUTF8
		_Encoding_URIDecode
		_Encoding_URIEncode
		_Encoding_URLToHex
		_Encoding_UTF8BOMDecode
		_Encoding_UTF8ToANSI
		_Encoding_UTF8ToANSI_API
		_Encoding_UTF8ToUnicode_API
	
#CE

;Description: Converts cyrillic string from IBM 866 codepage to Microsoft 1251 codepage
;Author: Latoid
Func _Encoding_866To1251($sString)
	Local $sResult = "", $iCode
	Local $Var866Arr = StringSplit($sString, "")

	For $i = 1 To $Var866Arr[0]
		$iCode = Asc($Var866Arr[$i])

		Select
			Case $iCode >= 128 And $iCode <= 175
				$Var866Arr[$i] = Chr($iCode + 64)
			Case $iCode >= 224 And $iCode <= 239
				$Var866Arr[$i] = Chr($iCode + 16)
			Case $iCode = 240
				$Var866Arr[$i] = Chr(168)
			Case $iCode = 241
				$Var866Arr[$i] = Chr(184)
			Case $iCode = 252
				$Var866Arr[$i] = Chr(185)
		EndSelect

		$sResult &= $Var866Arr[$i]
	Next

	Return $sResult
EndFunc   ;==>_Encoding_866To1251

;Description: Converts ANSI string to OEM encoded string
;Author: amel27
Func _Encoding_ANSIToOEM($strText)
	Local $sBuffer = DllStructCreate("char[" & StringLen($strText) + 1 & "]")
	Local $aRet = DllCall("User32.dll", "int", "CharToOem", "str", $strText, "ptr", DllStructGetPtr($sBuffer))

	If Not IsArray($aRet) Then Return SetError(1, 0, '') ; DLL error
	If $aRet[0] = 0 Then Return SetError(2, $aRet[0], '') ; Function error

	Return DllStructGetData($sBuffer, 1)
EndFunc   ;==>_Encoding_ANSIToOEM

;Description: Converts ANSI string to UTF-8 encoding
;Author: CreatoR
Func _Encoding_ANSIToUTF8($sString)
	Return BinaryToString(StringToBinary($sString, 4))
EndFunc   ;==>_Encoding_ANSIToUTF8

;Description: Decode string from Base64 data format
;Author: trancexx
Func _Encoding_Base64Decode($sData)
	Local $struct = DllStructCreate("int")
	
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $sData, _
			"int", 0, _
			"int", 1, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)
	
	If @error Or Not $a_Call[0] Then
		Return SetError(1, 0, "") ; error calculating the length of the buffer needed
	EndIf
	
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", _
			"str", $sData, _
			"int", 0, _
			"int", 1, _
			"ptr", DllStructGetPtr($a), _
			"ptr", DllStructGetPtr($struct, 1), _
			"ptr", 0, _
			"ptr", 0)
	
	If @error Or Not $a_Call[0] Then
		Return SetError(2, 0, ""); error decoding
	EndIf
	
	Return BinaryToString(DllStructGetData($a, 1))
EndFunc   ;==>_Encoding_Base64Decode

;Description: Encode string to Base64 data format
;Author: trancexx
Func _Encoding_Base64Encode($sData)
	$sData = Binary($sData)
	
	Local $struct = DllStructCreate("byte[" & BinaryLen($sData) & "]")
	
	DllStructSetData($struct, 1, $sData)
	
	Local $strc = DllStructCreate("int")
	
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
			"ptr", DllStructGetPtr($struct), _
			"int", DllStructGetSize($struct), _
			"int", 1, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($strc))
	
	If @error Or Not $a_Call[0] Then
		Return SetError(1, 0, "") ; error calculating the length of the buffer needed
	EndIf
	
	Local $a = DllStructCreate("char[" & DllStructGetData($strc, 1) & "]")
	
	$a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
			"ptr", DllStructGetPtr($struct), _
			"int", DllStructGetSize($struct), _
			"int", 1, _
			"ptr", DllStructGetPtr($a), _
			"ptr", DllStructGetPtr($strc))
	
	If @error Or Not $a_Call[0] Then
		Return SetError(2, 0, ""); error encoding
	EndIf
	
	Return BinaryToString(DllStructGetData($a, 1))
EndFunc   ;==>_Encoding_Base64Encode

;Description: Converts cyrillic string of any encoding to Microsoft 1251 codepage
;Author: Latoid
Func _Encoding_CyrillicTo1251($sString)
	If StringRegExp($sString, "(=[A-Fa-f0-9]{2}=[A-Fa-f0-9]{2})") Then
		$sString = _Encoding_HexSymbolsToANSI($sString)
	EndIf
	
	If _Encoding_IsUTF8Format($sString) Then
		$sString = BinaryToString(StringToBinary($sString), 4)
		
		If Asc(StringLeft($sString, 1)) = 63 Then
			$sString = StringTrimLeft($sString, 1)
		EndIf
	EndIf
	
	Local $Encoding = _Encoding_GetCyrillicANSIEncoding($sString)
	
	If $Encoding = "IBM-866" Then
		Return _Encoding_866To1251($sString)
	ElseIf $Encoding = "KOI8-R" Then
		Return _Encoding_KOI8To1251($sString)
	ElseIf $Encoding = "ISO-8859-5" Then
		Return _Encoding_ISO8859To1251($sString)
	Else
		Return $sString
	EndIf
EndFunc   ;==>_Encoding_CyrillicTo1251

;Description: Finds out the ANSI encoding of cyrillic string. Needs at least 3-4 proper Russian words for certain definition
;Author: Latoid
Func _Encoding_GetCyrillicANSIEncoding($sString)
	Local $iCode, $iWIN = 0, $iDOS = 0, $iKOI = 0, $iISO = 0
	Local $VarString = StringSplit($sString, "")

	For $i = 1 To $VarString[0]
		$iCode = Asc($VarString[$i])
		
		Select
			Case $iCode = 192 Or $iCode = 224 Or $iCode = 200 Or $iCode = 232 Or $iCode = 206 Or $iCode = 238 Or $iCode = 210 Or $iCode = 242
				$iWIN += 1
			Case $iCode = 128 Or $iCode = 160 Or $iCode = 136 Or $iCode = 168 Or $iCode = 142 Or $iCode = 174 Or $iCode = 146
				$iDOS += 1
			Case $iCode = 225 Or $iCode = 193 Or $iCode = 233 Or $iCode = 201 Or $iCode = 239 Or $iCode = 207 Or $iCode = 244 Or $iCode = 212
				$iKOI += 1
			Case $iCode = 176 Or $iCode = 208 Or $iCode = 184 Or $iCode = 216 Or $iCode = 190 Or $iCode = 222 Or $iCode = 194
				$iISO += 1
			Case $iCode = 226
				$iDOS += 1
				$iISO += 1
		EndSelect
	Next
	
	If $iKOI >= $iWIN And $iKOI > $iDOS And $iKOI > $iISO Then
		Return "KOI8-R"
	ElseIf $iWIN > $iKOI And $iWIN > $iDOS And $iWIN > $iISO Then
		Return "WINDOWS-1251"
	ElseIf $iDOS > $iKOI And $iDOS > $iWIN And $iDOS > $iISO Then
		Return "IBM-866"
	ElseIf $iISO > $iWIN And $iISO > $iDOS And $iISO > $iKOI Then
		Return "ISO-8859-5"
	Else
		Return False
	EndIf
EndFunc   ;==>_Encoding_GetCyrillicANSIEncoding

;Description: Gets the encoding type of specified file (Returns: 0 = ANSI, 1 = UTF-8, 2 = UTF-16, 4 = UTF-32).
;Author: Lazycat (Loopback).
Func _Encoding_GetFileEncoding($sFile, $nReadSize = -1)
	Local $hFile, $sRead, $iIs_UTF8 = 0, $sChar
	Local $nByte1, $nByte2, $nByte3, $nByte4
	
	Local $hFile = FileOpen($sFile, 16)
	Local $sRead = FileRead($hFile, 4)
	FileClose($hFile)
	
	Local $nByte1 = BinaryMid($sRead, 1, 1)
	Local $nByte2 = BinaryMid($sRead, 2, 1)
	Local $nByte3 = BinaryMid($sRead, 3, 1)
	Local $nByte4 = BinaryMid($sRead, 4, 1)
	
	Select
		Case ($nByte1 = 0xFF) And ($nByte2 = 0xFE) And ($nByte3 = 0) And ($nByte4 = 0)
			Return 4 ; Unicode UTF-32
		Case ($nByte1 = 0) And ($nByte2 = 0) And ($nByte3 = 0xFE) And ($nByte4 = 0xFF)
			Return 4 ; Unicode UTF-32
		Case (($nByte1 = 0xFF) And ($nByte2 = 0xFE)) Or (($nByte1 = 0xFE) And ($nByte2 = 0xFF))
			Return 2 ; Unicode UTF-16
		Case ($nByte1 = 0xEF) And ($nByte2 = 0xBB) And ($nByte3 = 0xBF)
			Return 1 ; Unicode UTF-8 with BOM
	EndSelect
	
	; If no BOMs found, try to check if text is UTF-8 without BOM...
	If $nReadSize = -1 Then $nReadSize = FileGetSize($sFile)
	$hFile = FileOpen($sFile, 16)
	$sRead = FileRead($hFile, $nReadSize)
	FileClose($hFile)
	
	For $i = 1 To $nReadSize
		$sChar = BinaryMid($sRead, $i, 1)
		If $sChar < 0x80 Then ContinueLoop
		
		$iIs_UTF8 = 1
		
		If BitAND($sChar, 0xE0) = 0xC0 Then
			If $nReadSize - $i < 2 Then Return 0
			$sChar = BinaryMid($sRead, $i + 1, 1)
			$iBit = BitShift($sChar, 6)
			If BitAND($sChar, 0xC0) <> 0x80 Then Return 0
			$iBit = BitNOT(BitAND($sChar, 0x3F))
			If $iBit < 0 Then $iBit = 0xFF - $iBit
			If $iBit < 0x80 Then Return 0
		ElseIf BitAND($sChar, 0xF0) = 0xE0 Then
			Return -1 ; ATM - 3-bytes symbols not supported
		EndIf
	Next
	
	Return $iIs_UTF8 ; ASCII
EndFunc   ;==>_Encoding_GetFileEncoding

;Description: Converts HEX symbols (quoted-printable) in string (Ex.: "=D2=C1=C2=CF") to ANSI symbols
;Author: Latoid
Func _Encoding_QuotedPrintableToANSI($sString)
	Return _Encoding_HexSymbolsToANSI($sString)
EndFunc

;Deprecated, linked to _Encoding_QuotedPrintableToANSI
Func _Encoding_HexSymbolsToANSI($sString)
	Local $symbolfound = 2, $decodedstring = ""
	$sString = StringRegExpReplace($sString, "=\r\n", "")

	For $i = 1 To StringLen($sString)
		If StringRegExp(StringMid($sString, $i, 3), "=[A-Fa-f0-9]{2}") Then
			$symbolfound = 0
			$decodedstring &= BinaryToString('0x' & StringMid($sString, $i + 1, 2))
		Else
			$symbolfound += 1
			If $symbolfound = 3 Then
				$symbolfound = 2
				$decodedstring &= StringMid($sString, $i, 1)
			EndIf
		EndIf
	Next

	Return $decodedstring
EndFunc   ;==>_Encoding_HexSymbolsToANSI

;Description: Converts HEX string to URL string (equivalent to _StringURIDecode function)
;Author: CreatoR
Func _Encoding_HexToURL($sURLHex)
	Local $aURLHexSplit = StringSplit($sURLHex, "")
	Local $sRetString = "", $iDec, $iUbound = UBound($aURLHexSplit)

	For $i = 1 To $iUbound - 1
		If $aURLHexSplit[$i] = "%" And $i + 2 <= $iUbound - 1 Then
			$i += 2
			$iDec = Dec($aURLHexSplit[$i - 1] & $aURLHexSplit[$i])

			If Not @error Then
				$sRetString &= Chr($iDec)
			Else
				$sRetString &= $aURLHexSplit[$i - 2]
			EndIf
		Else
			$sRetString &= $aURLHexSplit[$i]
		EndIf
	Next

	Return _Encoding_UTF8ToANSI($sRetString)
EndFunc   ;==>_Encoding_HexToURL

;Description: Converts cyrillic string from ISO-8859-5 to Microsoft 1251 codepage
;Author: Latoid
Func _Encoding_ISO8859To1251($sString)
	Local $sResult = "", $iCode
	Local $VarISOArr = StringSplit($sString, "")

	For $i = 1 To $VarISOArr[0]
		$iCode = Asc($VarISOArr[$i])

		Select
			Case $iCode >= 176 And $iCode <= 239
				$VarISOArr[$i] = Chr($iCode + 16)
			Case $iCode = 161
				$VarISOArr[$i] = Chr(168)
			Case $iCode = 241
				$VarISOArr[$i] = Chr(184)
			Case $iCode = 240
				$VarISOArr[$i] = Chr(185)
		EndSelect

		$sResult &= $VarISOArr[$i]
	Next

	Return $sResult
EndFunc   ;==>_Encoding_ISO8859To1251

;Description: Converts cyrillic string from ISO-8859-1 to Microsoft 1251 codepage
;Author: CreatoR
Func _Encoding_ISO88591To1251($sString)
	Return StringFromASCIIArray(StringToASCIIArray($sString, 0, Default, 0), 0, Default, 2)
EndFunc   ;==>_Encoding_ISO88591To1251

;Description: Checks if a given string is stored in UTF-8 encoding
;Author: amel27
Func _Encoding_IsUTF8Format($sText, $iCheckASCIICode = False)
	Local $iAsc, $iExt, $iLen = StringLen($sText), $bLess128 = True

	For $i = 1 To $iLen
		$iAsc = Asc(StringMid($sText, $i, 1))

		If $iCheckASCIICode And $iAsc > 128 Then $bLess128 = False

		If Not BitAND($iAsc, 0x80) Then
			ContinueLoop
		ElseIf Not BitXOR(BitAND($iAsc, 0xE0), 0xC0) Then
			$iExt = 1
		ElseIf Not (BitXOR(BitAND($iAsc, 0xF0), 0xE0)) Then
			$iExt = 2
		ElseIf Not BitXOR(BitAND($iAsc, 0xF8), 0xF0) Then
			$iExt = 3
		Else
			Return False
		EndIf

		If $i + $iExt > $iLen Then Return False

		For $j = $i + 1 To $i + $iExt
			$iAsc = Asc(StringMid($sText, $j, 1))
			If BitXOR(BitAND($iAsc, 0xC0), 0x80) Then Return False
		Next

		$i += $iExt
	Next

	If $iCheckASCIICode Then Return ($bLess128 = False)
	Return True
EndFunc   ;==>_Encoding_IsUTF8Format

;Description: Encode string to Java Unicode format
;Author: amel27
Func _Encoding_JavaUnicodeEncode($sString)
	Local $iOld_Opt_EVS = Opt("ExpandVarStrings", 0)
	Local $iOld_Opt_EES = Opt("ExpandEnvStrings", 0)

	Local $iLen = StringLen($sString), $sChr, $iAsc
	Local $stChr = DllStructCreate("wchar[" & $iLen + 1 & "]"), $sOut = ""
	Local $stAsc = DllStructCreate("ushort[" & $iLen + 1 & "]", DllStructGetPtr($stChr))
	DllStructSetData($stChr, 1, $sString)

	For $i = 1 To StringLen($sString)
		$sChr = DllStructGetData($stChr, 1, $i)
		$iAsc = DllStructGetData($stAsc, 1, $i)

		If $sChr = "\" Or $sChr = "'" Then
			$sOut &= "\" & $sChr
		ElseIf $iAsc < 128 Then
			$sOut &= $sChr
		Else
			$sOut &= "\u" & Hex($iAsc, 4)
		EndIf
	Next

	Opt("ExpandVarStrings", $iOld_Opt_EVS)
	Opt("ExpandEnvStrings", $iOld_Opt_EES)

	Return $sOut
EndFunc   ;==>_Encoding_JavaUnicodeEncode

;Description: Decode string from Java Unicode format
;Author: amel27
Func _Encoding_JavaUnicodeDecode($sString)
	Local $iOld_Opt_EVS = Opt("ExpandVarStrings", 0)
	Local $iOld_Opt_EES = Opt("ExpandEnvStrings", 0)

	Local $sOut = "", $aString = StringRegExp($sString, "(\\\\|\\'|\\u[[:xdigit:]]{4}|[[:ascii:]])", 3)

	For $i = 0 To UBound($aString) - 1
		Switch StringLen($aString[$i])
			Case 1
				$sOut &= $aString[$i]
			Case 2
				$sOut &= StringRight($aString[$i], 1)
			Case 6
				$sOut &= ChrW(Dec(StringRight($aString[$i], 4)))
		EndSwitch
	Next

	Opt("ExpandVarStrings", $iOld_Opt_EVS)
	Opt("ExpandEnvStrings", $iOld_Opt_EES)

	Return $sOut
EndFunc   ;==>_Encoding_JavaUnicodeDecode

;Description: Converts cyrillic string from KOI8-R to Microsoft 1251 codepage
;Author: Latoid
Func _Encoding_KOI8To1251($sString)
	Local $sResult = "", $iCode
	Local $VarKOIArr = StringSplit($sString, "")

	For $i = 1 To $VarKOIArr[0]
		$iCode = Asc($VarKOIArr[$i])

		Select
			Case $iCode = 63
				$VarKOIArr[$i] = Chr(185)
			Case $iCode = 163
				$VarKOIArr[$i] = Chr(184)
			Case $iCode = 179
				$VarKOIArr[$i] = Chr(168)
			Case $iCode >= 233 And $iCode <= 240
				$VarKOIArr[$i] = Chr($iCode - 33)
			Case $iCode >= 242 And $iCode <= 245
				$VarKOIArr[$i] = Chr($iCode - 34)
			Case $iCode >= 201 And $iCode <= 208
				$VarKOIArr[$i] = Chr($iCode + 31)
			Case $iCode >= 210 And $iCode <= 213
				$VarKOIArr[$i] = Chr($iCode + 30)
			Case $iCode >= 225 And $iCode <= 226
				$VarKOIArr[$i] = Chr($iCode - 33)
			Case $iCode >= 228 And $iCode <= 229
				$VarKOIArr[$i] = Chr($iCode - 32)
			Case $iCode >= 193 And $iCode <= 194
				$VarKOIArr[$i] = Chr($iCode + 31)
			Case $iCode = 247
				$VarKOIArr[$i] = Chr(194)
			Case $iCode = 231
				$VarKOIArr[$i] = Chr(195)
			Case $iCode = 246
				$VarKOIArr[$i] = Chr(198)
			Case $iCode = 250
				$VarKOIArr[$i] = Chr(199)
			Case $iCode = 230
				$VarKOIArr[$i] = Chr(212)
			Case $iCode = 232
				$VarKOIArr[$i] = Chr(213)
			Case $iCode = 227
				$VarKOIArr[$i] = Chr(214)
			Case $iCode = 254
				$VarKOIArr[$i] = Chr(215)
			Case $iCode = 251
				$VarKOIArr[$i] = Chr(216)
			Case $iCode = 253
				$VarKOIArr[$i] = Chr(217)
			Case $iCode = 255
				$VarKOIArr[$i] = Chr(218)
			Case $iCode = 249
				$VarKOIArr[$i] = Chr(219)
			Case $iCode = 248
				$VarKOIArr[$i] = Chr(220)
			Case $iCode = 252
				$VarKOIArr[$i] = Chr(221)
			Case $iCode = 224
				$VarKOIArr[$i] = Chr(222)
			Case $iCode = 241
				$VarKOIArr[$i] = Chr(223)
			Case $iCode = 215
				$VarKOIArr[$i] = Chr(226)
			Case $iCode = 199
				$VarKOIArr[$i] = Chr(227)
			Case $iCode = 196
				$VarKOIArr[$i] = Chr(228)
			Case $iCode = 197
				$VarKOIArr[$i] = Chr(229)
			Case $iCode = 214
				$VarKOIArr[$i] = Chr(230)
			Case $iCode = 218
				$VarKOIArr[$i] = Chr(231)
			Case $iCode = 198
				$VarKOIArr[$i] = Chr(244)
			Case $iCode = 200
				$VarKOIArr[$i] = Chr(245)
			Case $iCode = 195
				$VarKOIArr[$i] = Chr(246)
			Case $iCode = 222
				$VarKOIArr[$i] = Chr(247)
			Case $iCode = 219
				$VarKOIArr[$i] = Chr(248)
			Case $iCode = 221
				$VarKOIArr[$i] = Chr(249)
			Case $iCode = 223
				$VarKOIArr[$i] = Chr(250)
			Case $iCode = 217
				$VarKOIArr[$i] = Chr(251)
			Case $iCode = 216
				$VarKOIArr[$i] = Chr(252)
			Case $iCode = 220
				$VarKOIArr[$i] = Chr(253)
			Case $iCode = 192
				$VarKOIArr[$i] = Chr(254)
			Case $iCode = 209
				$VarKOIArr[$i] = Chr(255)
		EndSelect

		$sResult &= $VarKOIArr[$i]
	Next

	Return $sResult
EndFunc   ;==>_Encoding_KOI8To1251

;Description: Converts OEM encoded string to ANSI string
;Author: amel27
Func _Encoding_OEM2ANSI($strText)
	Local $sBuffer = DllStructCreate("char[" & StringLen($strText) + 1 & "]")
	Local $aRet = DllCall("User32.dll", "int", "OemToChar", "str", $strText, "ptr", DllStructGetPtr($sBuffer))

	If Not IsArray($aRet) Then Return SetError(1, 0, '') ; DLL error
	If $aRet[0] = 0 Then Return SetError(2, $aRet[0], '') ; Function error

	Return DllStructGetData($sBuffer, 1)
EndFunc   ;==>_Encoding_OEM2ANSI

;Description: Converts any string to UTF-8 encoding
;Author: LEX1
Func _Encoding_StringToUTF8($sString)
	Local $Result = "", $Code
	Local $VarUTFArr = StringSplit($sString, "")

	For $i = 1 To $VarUTFArr[0]
		$Code = Asc($VarUTFArr[$i])

		Select
			Case $Code >= 192 And $Code <= 239
				$VarUTFArr[$i] = Chr(208) & Chr($Code - 48)
			Case $Code >= 240 And $Code <= 255
				$VarUTFArr[$i] = Chr(209) & Chr($Code - 112)
			Case $Code = 168
				$VarUTFArr[$i] = Chr(208) & Chr(129)
			Case $Code = 184
				$VarUTFArr[$i] = Chr(209) & Chr(145)
			Case Else
				$VarUTFArr[$i] = Chr($Code)
		EndSelect

		$Result &= $VarUTFArr[$i]
	Next

	Return $Result
EndFunc   ;==>_Encoding_StringToUTF8

;Description: Decode string from URI format (Uniform Resource Identifier)
;Author: CreatoR
Func _Encoding_URIDecode($sString)
	Local $oSC = ObjCreate("ScriptControl")
	$oSC.Language = "JavaScript"
	Local $Encode_URI = $oSC.Eval("decodeURI('" & $sString & "');")

	$oSC = 0

	Return $Encode_URI
EndFunc   ;==>_Encoding_URIDecode

;Description: Encode string to URI format (Uniform Resource Identifier)
;Author: CreatoR
Func _Encoding_URIEncode($sString)
	Local $oSC = ObjCreate("ScriptControl")
	$oSC.Language = "JavaScript"
	Local $Encode_URI = $oSC.Eval("encodeURI('" & $sString & "');")

	$oSC = 0

	Return $Encode_URI
EndFunc   ;==>_Encoding_URIEncode

;Description: Converts URL string to HEX string (equivalent to _StringURIEncode function)
;Author: CreatoR
Func _Encoding_URLToHex($sURLString)
	$sURLString = _Encoding_ANSIToUTF8($sURLString)
	
	Local $aURLStrSplit = StringSplit($sURLString, "")
	Local $sRetString = ""
	
	For $i = 1 To UBound($aURLStrSplit) - 1
		If Not StringRegExp($aURLStrSplit[$i], '(?i)[a-z]|\.|-|_') Then
			$aURLStrSplit[$i] = "%" & Hex(Asc($aURLStrSplit[$i]), 2)
		EndIf
		
		$sRetString &= $aURLStrSplit[$i]
	Next
	
	Return $sRetString
EndFunc   ;==>_Encoding_URLToHex

;Description: Converts UTF-8 (with BOM) string to ANSI encoding
;Author: amel27 (mod. by AZJIO)
Func _Encoding_UTF8BOMDecode($sString)
	Local $sRetStr, $iMidleStr, $iMidleStr_Pos, $iMidleStr_Chck
	
	Local $sDecodeStr = BinaryToString('0xC3A0C3A1C3A2C3A3C3A4C3A5C3A6C3A7C3A8C3A9C3AAC3ABC3ACC3ADC3AEC3AFC3B0C3B1C3B2C3B3C3B4C3B5C3B6C3B7C3B8C3B9C3BCC3BBC3BDC3BEC3BF', 4)
	Local $sEncodeStr = 'абвгдежзийклмнопрстуфхцчшщьыэю€'
	
	For $i = 1 To StringLen($sString)
		$iMidleStr = StringMid($sString, $i, 1)
		$iMidleStr_Pos = StringInStr($sDecodeStr, $iMidleStr)
		
		If $iMidleStr_Pos Then
			$iMidleStr_Chck = StringMid($sEncodeStr, $iMidleStr_Pos, 1)
			
			If StringIsUpper($iMidleStr) Then
				$iMidleStr_Chck = StringUpper($iMidleStr_Chck) ; актуально только дл€ изменЄнного символа
			EndIf
		Else
			$iMidleStr_Chck = $iMidleStr
		EndIf
		
		$sRetStr &= $iMidleStr_Chck
	Next
	
	Return $sRetStr
EndFunc   ;==>_Encoding_UTF8BOMDecode

;Description: Converts UTF-8 string to ANSI encoding
;Author: CreatoR
Func _Encoding_UTF8ToANSI($sString)
	Return BinaryToString(StringToBinary($sString), 4)
EndFunc   ;==>_Encoding_UTF8ToANSI

;Description: Converts UTF-8 string to ANSI encoding
;Author: amel27
Func _Encoding_UTF8ToANSI_API($sUTF8_String)
	Local $iLen = StringLen($sUTF8_String)
	Local $stBuf = DllStructCreate("byte[" & $iLen * 2 & "];byte[2]")

	Local $aRet = DllCall("Kernel32.dll", "int", "MultiByteToWideChar", _
			"int", 65001, "int", 0, _
			"str", $sUTF8_String, "int", -1, _
			"ptr", DllStructGetPtr($stBuf), "int", $iLen * 2 + 2)

	Local $stOut = DllStructCreate("char[" & $iLen & "];char")

	$aRet = DllCall("kernel32.dll", "int", "WideCharToMultiByte", _
			"int", 0, "int", 0, _
			"ptr", DllStructGetPtr($stBuf), "int", -1, _
			"ptr", DllStructGetPtr($stOut), "int", $iLen + 1, _
			"int", 0, "int", 0)

	Local $sRet = DllStructGetData($stOut, 1)
	If $sRet = 0 Then Return ""

	Return $sRet
EndFunc   ;==>_Encoding_UTF8ToANSI_API

;Description: Converts UTF-8 string to Unicode encoding
;Author: amel27
Func _Encoding_UTF8ToUnicode_API($sUTF8_String)
	Local $BufferSize = StringLen($sUTF8_String) * 2
	Local $Buffer = DllStructCreate("byte[" & $BufferSize & "]")

	Local $Return = DllCall("Kernel32.dll", "int", "MultiByteToWideChar", _
			"int", 65001, _
			"int", 0, _
			"str", $sUTF8_String, _
			"int", StringLen($sUTF8_String), _
			"ptr", DllStructGetPtr($Buffer), _
			"int", $BufferSize)

	Local $UnicodeBinary = DllStructGetData($Buffer, 1)
	Local $UnicodeHex1 = StringReplace($UnicodeBinary, "0x", "")
	Local $StrLen = StringLen($UnicodeHex1)
	Local $UnicodeString, $UnicodeHex2, $UnicodeHex3

	For $i = 1 To $StrLen Step 4
		$UnicodeHex2 = StringMid($UnicodeHex1, $i, 4)
		$UnicodeHex3 = StringMid($UnicodeHex2, 3, 2) & StringMid($UnicodeHex2, 1, 2)
		$UnicodeString &= ChrW(Dec($UnicodeHex3))
	Next

	$Buffer = 0

	Return $UnicodeString
EndFunc   ;==>_Encoding_UTF8ToUnicode_API
