#include-once
;===============================================================================
;
; Build lookup tables as global constants
;
;===============================================================================
#Region Build look-up tables

;The Base64 alphabet, in an array which can be used as a 6-bit lookup table
Global Const $gcac_Base64Alphabet[64] = [ _
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', _
		'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', _
		'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', _
		'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/']

;reverse look-up table to convert an ascii value to a 6-bit value
Global Const $gcai_Base64Reverse[256] = [ _
		 - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, _
		 - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, _
		 - 1, 00, 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, _
		 - 1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1, _
		 - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, _
		 - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, _
		 - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, _
		 - 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]

;A 12-bit to 16-bit lookup table for encoding to base64
Global Const $gcas_Base64Table12 = _Base64Table12()

;a 14-bit to 12-bit reverse lookup (basically a truncated 16-bit to 12-bit table, uses 7+7 instead of 8+8)
Global Const $gcai_Base64Table14 = _Base64Table14()

;Build a 12-bit to 16-bit lookup table
Func _Base64Table12()
	Dim $a_Out[4096], $i_Count1, $i_Count2
	;ProgressOn(@ScriptName, 'Base64 Lookup Tables','Building Encoder Table...',-1,-1,16)
	For $i_Count1 = 0 To 63
		For $i_Count2 = 0 To 63
			$a_Out[$i_Count1 * 64 + $i_Count2] = $gcac_Base64Alphabet[$i_Count1] & $gcac_Base64Alphabet[$i_Count2]
		Next
		;ProgressSet(100 * $i_Count1 / 63)
	Next
	;ProgressOff()
	Return $a_Out
EndFunc   ;==>_Base64Table12

;a 14-bit to 12-bit reverse lookup (basically a truncated "16-bit to 12-bit" table, uses 7+7 instead of 8+8)
;note: 12-bit values have been shifted to easier fit into the Big Edian style of the BinaryString() function
;The table has 2 columns.  The columns represent the 4-bit groups as 00C0AB and EF0D00 respectively
Func _Base64Table14()
	Dim $a_Out[16384][2], $i_Count1, $i_Count2, $i_Temp1, $i_Temp2
	;ProgressOn(@ScriptName, 'Base64 Lookup Tables','Building Decoder Table...',-1,-1,16)
	For $i_Count1 = 0 To 63
		For $i_Count2 = 0 To 63
			$i_Temp1 = Asc($gcac_Base64Alphabet[$i_Count1]) * 128 + Asc($gcac_Base64Alphabet[$i_Count2])
			$i_Temp2 = $i_Count1 * 64 + $i_Count2
			$a_Out[$i_Temp1][0] = BitShift($i_Temp2, 4) + BitAND($i_Temp2, 15) * 4096
			$a_Out[$i_Temp1][1] = BitAND($i_Temp2, 255) * 65536 + BitAND($i_Temp2, 3840)
		Next
		;ProgressSet(100 * $i_Count1 / 63)
	Next
	;ProgressOff()
	Return $a_Out
EndFunc   ;==>_Base64Table14

#endregion

;===============================================================================
;
; Description:		Convert String to Base64
; Syntax:			_Base64Encode($s_Input, $b_WordWrap, $s_ProgressTitle)
; Parameter(s):
;	$s_Input 			- String to convert to a Base64 String
;	$b_WordWrap 		- Add a @CRLF to the output every 76 Char. Default = True
;	$s_ProgressTitle	- Show a Progress Bar, This is the title of the progress bar. Default = "" = No progress bar.
;
; Requirement(s):	v3.2.4.0
;
; Return Value:		A Base64 encoded version of that string
;
; Authors:			Original functions  					- blindwig
;					Edit for UDF and Clean/Speedup Code		- Mikeytown2
;					Code Speedup/Standards					- blindwig
; Note(s):			
;					To encode a binary file, adapt this codeblock to your program
;					$file = "binaryfile.dat"
;					_Base64Encode (BinaryToString(FileRead(FileOpen($file, 16), FileGetSize($file))))
;					
;					Autoit will most likely crash if input is large (24+ MB)
;
;===============================================================================
Func _Base64Encode($s_Input, $b_WordWrap = '', $s_ProgressTitle = '')
	Local $i_Count, $i_Count2, $s_Out = '', $i_Temp
	
	If $b_WordWrap = '' Then $b_WordWrap = True
	
	;Initialize ProgressBar
	If $s_ProgressTitle Then ProgressOn($s_ProgressTitle, 'Base64 Encoding', 'Pre-Processing Input:')
	
	;Break the input up into bytes
	Local $as_Input = StringSplit($s_Input, "")
	
	;Main Processing Loop - handles 3-byte chunks
	If $s_ProgressTitle Then
		ProgressSet(0, 'Main Encode...', 'Base64 Encoding: ' & $as_Input[0] & ' bytes')
		If $b_WordWrap Then ;use ProgressBar and LineWrap
			;Handle data in a 57-byte chunck (which will be coded to a 76-byte line)
			For $i_Count2 = 1 To $as_Input[0] - Mod($as_Input[0], 57) Step 57
				For $i_Count = $i_Count2 To $i_Count2 + 54 Step 3
					$i_Temp = Asc($as_Input[$i_Count + 1])
					$s_Out &= $gcas_Base64Table12[Asc($as_Input[$i_Count + 0]) * 16 + BitShift($i_Temp, 4) ] _
							 & $gcas_Base64Table12[BitAND($i_Temp, 15) * 256 + Asc($as_Input[$i_Count + 2]) ]
				Next
				$s_Out &= @CRLF
				ProgressSet(100 * $i_Count2 / $as_Input[0])
			Next
			;Handle any left-over bytes (a final chunk less than 57 bytes but at least 3)
			For $i_Count = $i_Count2 To $as_Input[0] - Mod($as_Input[0], 3) Step 3
				$i_Temp = Asc($as_Input[$i_Count + 1])
				$s_Out &= $gcas_Base64Table12[Asc($as_Input[$i_Count + 0]) * 16 + BitShift($i_Temp, 4) ] _
						 & $gcas_Base64Table12[BitAND($i_Temp, 15) * 256 + Asc($as_Input[$i_Count + 2]) ]
			Next
		Else ;use ProgressBar only
			;Handle data in a 57-byte chunck (which will be coded to a 76-byte line)
			For $i_Count2 = 1 To $as_Input[0] - Mod($as_Input[0], 57) Step 57
				For $i_Count = $i_Count2 To $i_Count2 + 54 Step 3
					$i_Temp = Asc($as_Input[$i_Count + 1])
					$s_Out &= $gcas_Base64Table12[Asc($as_Input[$i_Count + 0]) * 16 + BitShift($i_Temp, 4) ] _
							 & $gcas_Base64Table12[BitAND($i_Temp, 15) * 256 + Asc($as_Input[$i_Count + 2]) ]
				Next
				ProgressSet(100 * $i_Count2 / $as_Input[0])
			Next
			;Handle any left-over bytes (a final chunk less than 57 bytes but at least 3)
			For $i_Count = $i_Count2 To $as_Input[0] - Mod($as_Input[0], 3) Step 3
				$i_Temp = Asc($as_Input[$i_Count + 1])
				$s_Out &= $gcas_Base64Table12[Asc($as_Input[$i_Count + 0]) * 16 + BitShift($i_Temp, 4) ] _
						 & $gcas_Base64Table12[BitAND($i_Temp, 15) * 256 + Asc($as_Input[$i_Count + 2]) ]
			Next
		EndIf
	Else ;No ProgressBar
		If $b_WordWrap Then ;use LineWrap only
			;Handle data in a 57-byte chunck (which will be coded to a 76-byte line)
			For $i_Count2 = 1 To $as_Input[0] - Mod($as_Input[0], 57) Step 57
				For $i_Count = $i_Count2 To $i_Count2 + 54 Step 3
					$i_Temp = Asc($as_Input[$i_Count + 1])
					$s_Out &= $gcas_Base64Table12[Asc($as_Input[$i_Count + 0]) * 16 + BitShift($i_Temp, 4) ] _
							 & $gcas_Base64Table12[BitAND($i_Temp, 15) * 256 + Asc($as_Input[$i_Count + 2]) ]
				Next
				$s_Out &= @CRLF
			Next
			;Handle any left-over bytes (a final chunk less than 57 bytes but at least 3)
			For $i_Count = $i_Count2 To $as_Input[0] - Mod($as_Input[0], 3) Step 3
				$i_Temp = Asc($as_Input[$i_Count + 1])
				$s_Out &= $gcas_Base64Table12[Asc($as_Input[$i_Count + 0]) * 16 + BitShift($i_Temp, 4) ] _
						 & $gcas_Base64Table12[BitAND($i_Temp, 15) * 256 + Asc($as_Input[$i_Count + 2]) ]
			Next
		Else ;use no ProgressBar or LineWrap
			For $i_Count = 1 To $as_Input[0] - Mod($as_Input[0], 3) Step 3
				$i_Temp = Asc($as_Input[$i_Count + 1])
				$s_Out &= $gcas_Base64Table12[Asc($as_Input[$i_Count + 0]) * 16 + BitShift($i_Temp, 4) ] _
						 & $gcas_Base64Table12[BitAND($i_Temp, 15) * 256 + Asc($as_Input[$i_Count + 2]) ]
			Next
		EndIf
	EndIf
	
	;Handle any left-over bytes (a final chunk less than 3 bytes)
	Switch Mod($as_Input[0], 3)
		Case 1
			$s_Out &= $gcac_Base64Alphabet[BitShift(Asc($as_Input[$as_Input[0]]), 2) ] _
					 & $gcac_Base64Alphabet[BitAND(Asc($as_Input[$as_Input[0]]), 3) * 16 ] & '=='
		Case 2
			$s_Out &= $gcac_Base64Alphabet[BitShift(Asc($as_Input[$as_Input[0] - 1]), 2) ] _
					 & $gcac_Base64Alphabet[BitAND(Asc($as_Input[$as_Input[0] - 1]), 3) * 16 + BitShift(Asc($as_Input[$as_Input[0]]), 4) ] _
					 & $gcac_Base64Alphabet[BitAND(Asc($as_Input[$as_Input[0]]), 15) * 4 ] & '='
	EndSwitch
	
	;Final line-wrap
	If $b_WordWrap And Mod($i_Count + 1, 19) = 0 Then $s_Out &= @CRLF
	
	;Final ProgrssBar
	If $s_ProgressTitle Then ProgressOff()
	
	;DONE!
	Return $s_Out
EndFunc   ;==>_Base64Encode

;===============================================================================
;
; Description:		Decodes a given base64 string
; Syntax:			_Base64Decode($as_CypherText, $s_ProgressTitle)
; Parameter(s):
;	$as_CypherText		- Base64 String
;	$s_ProgressTitle	- (optional) Show a Progress Bar, This is the title of the progress bar. Default ("") ;No progress bar.
;
; Requirement(s):	v3.2.4.0
;
; Return Value(s):	On Success - Returns decoded Base64 string
;
; Authors:			Original functions  					- blindwig
;					Edit for UDF and Clean/Speedup Code		- Mikeytown2
;					Code Speedup/Standards					- blindwig
; Note(s):			
;					will always strip all @CRLF, @CR, @LF characters before processing and any non Base64 characters
;					
;					Will most likely crash if input is large (32+ MB)
;
;===============================================================================
Func _Base64Decode($s_CypherText, $s_ProgressTitle = '')
	Local $i_Count = 0, $i_Count2, $s_Out = '', $i_CypMod, $i_Temp
	
	If $s_ProgressTitle Then ProgressOn($s_ProgressTitle, 'Base64 Decoding', 'Pre-processing input:', -1, -1, 16)
	
	;first filter EOL characters
	If $s_ProgressTitle Then ProgressSet(18, 'Pre-processing input: Filtering EOL...')
	$s_CypherText = StringReplace(StringStripCR($s_CypherText), @LF, "")
	;check for non-base64 characters, filter if needed
	If $s_ProgressTitle Then ProgressSet(25, 'Pre-processing input: Checking for junk...')
	If StringRegExp($s_CypherText, '[^0-9a-zA-Z/+=]', 0) Then
		If $s_ProgressTitle Then ProgressSet(50, 'Pre-processing input: Filtering junk...')
		$s_CypherText = StringRegExpReplace($s_CypherText, '[^0-9a-zA-Z/+=]', '')
	EndIf
	
	;Break the input up into bytes
	If $s_ProgressTitle Then ProgressSet(75, 'Pre-processing input: Building array...')
	$as_CypherText = StringSplit($s_CypherText, "")
	
	;Pad the input to a multiple of four characters
	If $s_ProgressTitle Then ProgressSet(95, 'Pre-processing input: Padding array...')
	$i_CypMod = Mod($as_CypherText[0], 4)
	If $i_CypMod Then
		ReDim $as_CypherText[$as_CypherText[0] + 5 - $i_CypMod]
		For $i_Count = $as_CypherText[0] + 1 To UBound($as_CypherText) - 1
			$as_CypherText[$i_Count] = '='
		Next
		$as_CypherText[0] = UBound($as_CypherText) - 1
	EndIf
	
	
	;Main decoding loop - process all but the last 4 bytes
	If $s_ProgressTitle Then
		ProgressSet(0, 'Main Decode Loop...', 'Base64 Decoding ' & $as_CypherText[0] & ' bytes')
		For $i_Count2 = 1 To $as_CypherText[0] - Mod($as_CypherText[0], 100) - 4 Step + 100
			For $i_Count = $i_Count2 To $i_Count2 + 96 Step + 4
				$i_Temp = $gcai_Base64Table14[Asc($as_CypherText[$i_Count + 0]) * 128 + Asc($as_CypherText[$i_Count + 1]) ][0] _
						 + $gcai_Base64Table14[Asc($as_CypherText[$i_Count + 2]) * 128 + Asc($as_CypherText[$i_Count + 3]) ][1]
				$s_Out &= StringLeft(BinaryToString($i_Temp), 3)
			Next
			ProgressSet(100 * $i_Count / $as_CypherText[0])
		Next
		For $i_Count = $i_Count To $as_CypherText[0] - 4 Step + 4
			$i_Temp = $gcai_Base64Table14[Asc($as_CypherText[$i_Count + 0]) * 128 + Asc($as_CypherText[$i_Count + 1]) ][0] _
					 + $gcai_Base64Table14[Asc($as_CypherText[$i_Count + 2]) * 128 + Asc($as_CypherText[$i_Count + 3]) ][1]
			$s_Out &= StringLeft(BinaryToString($i_Temp), 3)
		Next
	Else
		For $i_Count = 1 To $as_CypherText[0] - 4 Step + 4
			$i_Temp = $gcai_Base64Table14[Asc($as_CypherText[$i_Count + 0]) * 128 + Asc($as_CypherText[$i_Count + 1]) ][0] _
					 + $gcai_Base64Table14[Asc($as_CypherText[$i_Count + 2]) * 128 + Asc($as_CypherText[$i_Count + 3]) ][1]
			$s_Out &= StringLeft(BinaryToString($i_Temp), 3)
		Next
	EndIf

	;last run - left over bytes (4 or less, if any)
	If $as_CypherText[0] Then ;make sure there is some input (not zero).
		If $as_CypherText[0] > $i_Count Then
			Local $ai_Bytes[4]

			$ai_Bytes[0] = $gcai_Base64Reverse[Asc($as_CypherText[$i_Count + 0]) ]
			$ai_Bytes[1] = $gcai_Base64Reverse[Asc($as_CypherText[$i_Count + 1]) ]
			$ai_Bytes[2] = $gcai_Base64Reverse[Asc($as_CypherText[$i_Count + 2]) ]
			$ai_Bytes[3] = $gcai_Base64Reverse[Asc($as_CypherText[$i_Count + 3]) ]
			
			Select
				Case $ai_Bytes[0] = -1;File ended on a perfect octet
				Case $ai_Bytes[1] = -1;This should never happen
					SetError(-1)
				Case $ai_Bytes[2] = -1;Only the first 2 bytes to be considered
					$s_Out &= Chr($ai_Bytes[0] * 4 + BitShift($ai_Bytes[1], 4))
				Case $ai_Bytes[3] = -1;Only the first 3 bytes to be considered
					$s_Out &= Chr($ai_Bytes[0] * 4 + BitShift($ai_Bytes[1], 4)) _
							 & Chr(BitAND($ai_Bytes[1] * 16 + BitShift($ai_Bytes[2], 2), 255))
				Case Else;All 4 bytes to be considered
					$s_Out &= Chr($ai_Bytes[0] * 4 + BitShift($ai_Bytes[1], 4)) _
							 & Chr(BitAND($ai_Bytes[1] * 16 + BitShift($ai_Bytes[2], 2), 255)) _
							 & Chr(BitAND($ai_Bytes[2] * 64 + $ai_Bytes[3], 255))
			EndSelect
		EndIf
	EndIf
	
	;Finish ProgressBar
	If $s_ProgressTitle Then ProgressOff()
	
	;DONE!
	Return $s_Out
EndFunc   ;==>_Base64Decode