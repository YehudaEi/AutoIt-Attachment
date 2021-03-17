#include <array.au3>
#include <string.au3>
#include-once

;===============================================================================
;
;  Associative Array UDF(v1.0)
;
;
;Author: Daryl varghese
;last updated: 8-07-2013
;===============================================================================




Global $ARRAY_simple_glue = '[~]glue[~]'
Global $ARRAY_associative_key_value_glue = '[~]ass_key_value_glue[~]'
Global $ARRAY_associative_null = '[~]ass_null[~]'
Global $escaped_curly_brace_start = '(~)escaped_curly_brace_start(~)'
Global $escaped_curly_brace_end = '(~)escaped_curly_brace_end(~)'
Global $escaped_square_brace_start = '(~)escaped_square_brace_start(~)'
Global $escaped_square_brace_end = '(~)escaped_square_brace_end(~)'
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


Func Get_Ass_Array($myAssArray, $element_pack, $intend = 0, $output_string = False)
local $reyturn, $thestring,$element_pack_array, $temp1, $temp2
$reyturn = -1
;MsgBox(0,"elementpack=", "intend="&$intend)
$element_pack_array =  _StringExplode($element_pack, '->')
	;for $e = 0 to UBound($element_pack_array)- 1 Step +1
		If UBound($element_pack_array) - $intend = 1 Then
			;ConsoleWrite(UBound($element_pack_array) & " - " &$intend)
			$thestring = _StringExplode($myAssArray, $ARRAY_simple_glue)
			;msgbox(0,"", "hello")
			;_ArrayDisplay($thestring)
				for $k = 0 to UBound($thestring)- 1 Step +1
					If StringInStr($thestring[$k], $element_pack_array[$intend] & '[~]array[~]=>>') Then
						If $output_string = True Then
							$reyturn = get_key_value($thestring[$k])
						Else
							$reyturn = _StringExplode(get_key_value($thestring[$k]), $ARRAY_simple_glue)
						EndIf
					
						ExitLoop
					EndIf
			

				Next
			
		Else
			$thestring = _StringExplode($myAssArray, $ARRAY_simple_glue)
				for $k = 0 to UBound($thestring)- 1 Step +1
					If StringInStr($thestring[$k], $element_pack_array[$intend] & '[~]array[~]=>>') Then
						$reyturn = Get_Ass_Array(get_key_value($thestring[$k]), $element_pack, $intend + 1, $output_string)
						ExitLoop
					EndIf
			

				Next
		EndIf
	
If IsArray($reyturn) Then
	For $k = 0 to UBound($reyturn)- 1 Step +1
		If StringInStr($reyturn[$k], $ARRAY_associative_null) Then
			$reyturn[$k] = StringReplace($reyturn[$k],$ARRAY_associative_null ,'')
		EndIf
		
	Next
	
Else
		$reyturn = StringReplace($reyturn,$ARRAY_associative_null ,'')
EndIf
Return $reyturn
EndFunc

Func _AssociativeArray($myAssArray, $hash_pack = '', $element = '')
	Local $reyturn, $element_counter, $temp
	$reyturn = -1
	$element_counter = 0
	;If $hash_pack = '' Then SetError(
	$element = StringReplace($element, ' ', '')
	
		If $hash_pack = '' Then
			If $element = '' Then
				$reyturn = _StringExplode($myAssArray, $ARRAY_simple_glue)
			Else
				$temp = _StringExplode($myAssArray, $ARRAY_simple_glue)
				$temp1 = get_all_numbered_element_keys($temp)
				If StringRegExp($element,'(\D{1,})',0) = 0 And StringRegExp($element,'(\d{1,})',0)  = 1 And $element < UBound($temp)Then
					For $k = 0 To UBound($temp) - 1 step +1
						If StringInStr($temp[$k], '[~]array[~]=>>')=0 Then
							If In_Array($temp1, $element_counter) = -1 Then
								If $element = $element_counter Then 
								$reyturn = $temp[$k]
								EndIf				
								
								$element_counter += 1
							Else
								$temp4 = get_appropriate_place($temp1, $element_counter + 1, UBound($temp)-1)
								
									If $element = $temp4 Then 
										$reyturn = $temp[$k]
									EndIf				
								
								$element_counter = $temp4 + 1
							EndIf

							
						EndIf
						
					Next
					
				EndIf
	
			EndIf
		Else
			If $element = '' Then
				$reyturn = _StringExplode(Get_Ass_Array($myAssArray, $hash_pack, 0, True), $ARRAY_simple_glue)
			Else
				
				$temp = _StringExplode(Get_Ass_Array($myAssArray, $hash_pack, 0, True), $ARRAY_simple_glue)
				$temp1 = get_all_numbered_element_keys($temp)
				If StringRegExp($element,'(\D{1,})',0) = 0 And StringRegExp($element,'(\d{1,})',0)  = 1 And $element < UBound($temp)Then
					For $k = 0 To UBound($temp) - 1 step +1
						If StringInStr($temp[$k], '[~]array[~]=>>')=0 Then
							If In_Array($temp1, $element_counter) = -1 Then
								If $element = $element_counter Then 
								$reyturn = $temp[$k]
								EndIf				
								
								$element_counter += 1
							Else
								
								$temp4 = get_appropriate_place($temp1, $element_counter + 1, UBound($temp)-1)
								
									If $element = $temp4 Then 
										$reyturn = $temp[$k]
									EndIf				
								
								$element_counter = $temp4 + 1
							EndIf

							
						EndIf
						
					Next
					
				EndIf
	
			EndIf
		EndIf
		If $reyturn = -1 Then SetError(1)
	
	Return $reyturn
	
EndFunc

;
;
Func Set_Ass_Array(ByRef $myAssArray, $element_pack, $change = '', $intend = 0, $append = 0, $create_if_not_exist = False)
local $reyturn, $thestring,$element_pack_array, $reyturn1, $k, $e,$temp_value, $found, $temp1, $temp2
$reyturn = -1
$found = -1
If $change = '' Then $change = $ARRAY_associative_null


If $element_pack <> '' Then
	$element_pack_array =  _StringExplode($element_pack, '->')
	;for $e = 0 to UBound($element_pack_array)- 1 Step +1
	
		If UBound($element_pack_array) - $intend = 1 Then
			;ConsoleWrite(UBound($element_pack_array) & " - " &$intend)
			$thestring = _StringExplode($myAssArray, $ARRAY_simple_glue)
			;msgbox(0,"", "hello")
			;_ArrayDisplay($thestring)
				for $k = 0 to UBound($thestring)- 1 Step +1
					If StringInStr($thestring[$k], $element_pack_array[$intend] & '[~]array[~]=>>') Then
						$found = 1;just to make known that the key actually exists
						If $append = 1 Then
							If StringInStr(get_key_value($thestring[$k]), '[~]array[~]=>>') Then
								$temp1 = get_key_value($thestring[$k])
								$temp2 = _StringExplode($temp1, $ARRAY_simple_glue)
								$change = $temp1 &  $ARRAY_simple_glue & UBound($temp2) & '[~]array[~]=>>' & $change
								$thestring[$k] = $element_pack_array[$intend] & '[~]array[~]=>>' & _Base64Encode($change, False)								
								
							Else
								
								$change = get_key_value($thestring[$k]) &  $ARRAY_simple_glue & $change
								$thestring[$k] = $element_pack_array[$intend] & '[~]array[~]=>>' & _Base64Encode($change, False)
										
									
							EndIf
							
						Else
							
							$thestring[$k] = $element_pack_array[$intend] & '[~]array[~]=>>' & _Base64Encode($change, False)
						EndIf
						$myAssArray = _ArrayToString($thestring, $ARRAY_simple_glue)
							If $intend = 0 Then 
								
								$reyturn = $myAssArray
							Else
								$reyturn = _Base64Encode($myAssArray, False)
							EndIf
						ExitLoop
						

						
					EndIf
			

				Next
				If $found < 1 And $create_if_not_exist = True Then
							If $thestring[0] = '' Then
								$thestring[0] =  $element_pack_array[$intend] & '[~]array[~]=>>' & _Base64Encode($change, False)
							Else
								;_ArrayDisplay($thestring, 'from inside')
								_ArrayAdd($thestring, $element_pack_array[$intend] & '[~]array[~]=>>' & _Base64Encode($change, False))
					
							EndIf

					
							
							$myAssArray = _ArrayToString($thestring, $ARRAY_simple_glue)
							If $intend = 0 Then 
								$reyturn = $myAssArray
							Else
							
								$reyturn = _Base64Encode($myAssArray, False)
							EndIf


					
				EndIf
			
		Else
			$thestring = _StringExplode($myAssArray, $ARRAY_simple_glue)
				for $k = 0 to UBound($thestring)- 1 Step +1
					If StringInStr($thestring[$k], $element_pack_array[$intend] & '[~]array[~]=>>') Then
						$found = 1;just to make known that the key actually exists
						$temp_value = get_key_value($thestring[$k]);just to convince the syntax checker, it will work even if passed as expression
						$reyturn1 = Set_Ass_Array($temp_value, $element_pack, $change, $intend + 1, $append, $create_if_not_exist)
							If $reyturn1 <> -1 Then
								$thestring[$k] = $element_pack_array[$intend] & '[~]array[~]=>>' & $reyturn1
								$myAssArray = _ArrayToString($thestring, $ARRAY_simple_glue)
									If $intend = 0 Then 
										$reyturn = $myAssArray
									Else							
										$reyturn = _Base64Encode($myAssArray, False)
									EndIf
							EndIf
						ExitLoop
					EndIf
			

				Next
				If $found < 1 And $create_if_not_exist = True Then				
					$temp_value = ''; because it is null in our case
					$reyturn1 = Set_Ass_Array($temp_value, $element_pack, $change, $intend + 1, $append, $create_if_not_exist)
						If $reyturn1 <> -1 Then
						
							If $thestring[0] = '' Then
								$thestring[0] = $element_pack_array[$intend] & '[~]array[~]=>>' & $reyturn1
							Else
								;_ArrayDisplay($thestring)
								_ArrayAdd($thestring, $element_pack_array[$intend] & '[~]array[~]=>>' & $reyturn1)
					
							EndIf
							$myAssArray = _ArrayToString($thestring, $ARRAY_simple_glue)
							If $intend = 0 Then 
								$reyturn = $myAssArray
							Else
							
								$reyturn = _Base64Encode($myAssArray, False)
							EndIf
							
						EndIf


					
				EndIf
		EndIf
	
EndIf
Return $reyturn
EndFunc

Func _SetAssociativeArray(ByRef $myAssArray, $hash_pack = '', $element = -1, $change = '', $create_if_not_exist = False)
		Local $reyturn, $element_counter, $temp, $non_existing_root_array
	$reyturn = -1
	$element_counter = 0
	$non_existing_root_array = -1
	If $element <> -1 and IsString($element) And $element == '' Then $element = -1
	If IsArray($change) = 0 And $change = '' Then $change = $ARRAY_associative_null
	;If $create_if_not_exist = True And 
	
	If $hash_pack == '' Then
		$temp = _StringExplode($myAssArray, $ARRAY_simple_glue)
		If $element = -1 Then
			If IsArray($change) Then
				$myAssArray = _ArrayToString($change, $ARRAY_simple_glue)
			Else
				$myAssArray = $change
			EndIf
			
		Else
			$temp1 = get_all_numbered_element_keys($temp)
			If Is_number($element) Then
				For $k = 0 To UBound($temp) - 1 step +1
						If StringInStr($temp[$k], '[~]array[~]=>>')=0 Then
							If In_Array($temp1, $element_counter) = -1 Then
								If $element = $element_counter Then
									If IsArray($change) Then
										$temp[$k] = '[~]array[~]=>>' & _Base64Encode(_ArrayToString($change, $ARRAY_simple_glue), False)
										$myAssArray = _ArrayToString($temp, $ARRAY_simple_glue)
										$reyturn = $myAssArray
										ExitLoop
									Else
										$temp[$k] = $change
										$myAssArray = _ArrayToString($temp, $ARRAY_simple_glue)
										$reyturn = $myAssArray
										ExitLoop										
									EndIf
									
									
									
								EndIf				
								
								$element_counter += 1
							Else
								
								$temp4 = get_appropriate_place($temp1, $element_counter + 1, UBound($temp)-1)
								
									If $element = $temp4 Then 
										If IsArray($change) Then
											$temp[$k] = '[~]array[~]=>>' & _Base64Encode(_ArrayToString($change, $ARRAY_simple_glue), False)
											$myAssArray = _ArrayToString($temp, $ARRAY_simple_glue)
											$reyturn = $myAssArray
											ExitLoop
										Else
											$temp[$k] = $change
											$myAssArray = _ArrayToString($temp, $ARRAY_simple_glue)
											$reyturn = $myAssArray
											ExitLoop										
										EndIf
									
									
									
									EndIf				
								
								$element_counter = $temp4 + 1
							EndIf

							
						EndIf
											
					
				Next
				
			EndIf
		EndIf
		
	Else
		$temp = _AssociativeArray($myAssArray, $hash_pack)
		If IsArray($change) Then $change = _ArrayToString($change, $ARRAY_simple_glue)
		If $create_if_not_exist = True And $temp[0] = -1 Then
			Set_Ass_Array($myAssArray, $hash_pack, $change, 0, 0, $create_if_not_exist)
			$reyturn = 1
		EndIf
		If $temp[0] <> -1 Then
			If $element = -1 Then
				If IsArray($change) Then
					$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($change, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
				
				Else
					$reyturn = Set_Ass_Array($myAssArray, $hash_pack, $change, 0, 0, $create_if_not_exist)
				EndIf
			
			Else
				
					$temp1 = get_all_numbered_element_keys($temp)
					If Is_number($element) Then
						For $k = 0 To UBound($temp) - 1 step +1
								If StringInStr($temp[$k], '[~]array[~]=>>')=0 Then
									If In_Array($temp1, $element_counter) = -1 Then
										If $element = $element_counter Then
											If IsArray($change) Then
												$temp[$k] = '0' & '[~]array[~]=>>' & _Base64Encode(_ArrayToString($change, $ARRAY_simple_glue), False)
												$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($temp, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
										
												ExitLoop
											Else
												$temp[$k] = $change
												$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($temp, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
												ExitLoop										
											EndIf
									
									
									
										EndIf				
								
										$element_counter += 1
									Else
								
										$temp4 = get_appropriate_place($temp1, $element_counter + 1, UBound($temp)-1)
								
											If $element = $temp4 Then 
												If IsArray($change) Then
													$temp[$k] = '0' & '[~]array[~]=>>' & _Base64Encode(_ArrayToString($change, $ARRAY_simple_glue), False)
													$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($temp, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
											
													ExitLoop
												Else
													$temp[$k] = $change
													$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($temp, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
													ExitLoop										
												EndIf
									
									
									
									
											EndIf				
								
										$element_counter = $temp4 + 1
									EndIf

							
							EndIf
											
					
						Next
				
					EndIf
		
			EndIf
		Else
			
			SetError(2)
			;element mentioned with non existing array
		EndIf
				
	EndIf
	
	return $reyturn
EndFunc

Func _AddAssociativeArray(ByRef $myAssArray, $hash_pack = '', $position = -1, $change = '', $create_if_not_exist = True)
			Local $reyturn, $element_counter, $temp, $non_existing_root_array
	$reyturn = -1
	$element_counter = 0
	$non_existing_root_array = -1
	If IsArray($change) = 0 And $change = '' Then $change = $ARRAY_associative_null
	;If $create_if_not_exist = True And 
	
	If $hash_pack = '' Then
		$temp = _StringExplode($myAssArray, $ARRAY_simple_glue)
		If IsArray($change) Then $change = _ArrayToString($change, $ARRAY_simple_glue)
		If $position = -1 Then
			
				_ArrayInsert($temp, UBound($temp) - 1, $change)
				$reyturn = 1
		ElseIf $position >= UBound($temp) Then
				SetError(2, 0, -1)

			
			
		Else
			$temp1 = get_all_numbered_element_keys($temp)
			If Is_number($position) Then
				For $k = 0 To UBound($temp) - 1 step +1
						If StringInStr($temp[$k], '[~]array[~]=>>')=0 Then
							If In_Array($temp1, $element_counter) = -1 Then
								If $position = $element_counter Then
									_ArrayInsert($temp, $k, $change)
									
								EndIf				
								
								$element_counter += 1
							Else
								
								$temp4 = get_appropriate_place($temp1, $element_counter + 1, UBound($temp)-1)
								
									If $position = $temp4 Then 
										_ArrayInsert($temp, $k, $change)
									
									EndIf				
								
								$element_counter = $temp4 + 1
							EndIf

							
						EndIf
											
					
				Next
				
			EndIf
			
		EndIf
		$myAssArray = _ArrayToString($temp, $ARRAY_simple_glue)
		$reyturn = $myAssArray
	Else
		$temp = _AssociativeArray($myAssArray, $hash_pack)
		If IsArray($change) Then $change = _ArrayToString($change, $ARRAY_simple_glue)
			
		If $create_if_not_exist = True And $temp[0] = -1 Then 
			Set_Ass_Array($myAssArray, $hash_pack, $change, 0, 0, $create_if_not_exist)
			$reyturn = 1
			EndIf
		If $temp[0] <> -1 Then
			If $position = -1 Then
					;_ArrayDisplay($temp)
					_ArrayInsert($temp, UBound($temp) - 1, $change)
					$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($temp, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
			Else
			
					$temp1 = get_all_numbered_element_keys($temp)
					If Is_number($position) Then
						For $k = 0 To UBound($temp) - 1 step +1
								If StringInStr($temp[$k], '[~]array[~]=>>')=0 Then
									If In_Array($temp1, $element_counter) = -1 Then
										If $position = $element_counter Then
												_ArrayInsert($temp, $k, $change)
												$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($temp, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
												ExitLoop
										EndIf				
								
										$element_counter += 1
									Else
								
										$temp4 = get_appropriate_place($temp1, $element_counter + 1, UBound($temp)-1)
								
											If $position = $temp4 Then 
												_ArrayInsert($temp, $k, $change)
												$reyturn = Set_Ass_Array($myAssArray, $hash_pack, _ArrayToString($temp, $ARRAY_simple_glue), 0, 0, $create_if_not_exist)
												ExitLoop										
											EndIf				
								
										$element_counter = $temp4 + 1
									EndIf

							
								EndIf
											
					
						Next
				
					EndIf
			
			EndIf
		Else
				
				SetError(1)
				;array not existing
		EndIf
				
	EndIf
	
	Return $reyturn
EndFunc


Func Is_number($string)
	$reyturn = -1
	If StringRegExp($string,'(\D{1,})',0) = 0 And StringRegExp($string,'(\d{1,})',0)  = 1 Then
		$reyturn = 1
	EndIf
	
	return $reyturn
	EndFunc

Func In_Array($array, $string, $complete = True)
	$reyturn = -1
	If StringLen($string) > 0 Then
	For $i = 0 To UBound($array) - 1 Step +1
		If $complete = True Then
			;MsgBox(0,"from in array", $string)
			If $string == $array[$i] Then
				$reyturn = 1
				;MsgBox(0,"from inarray complete ", $string)
			EndIf
			
		Else
			If StringInStr($array[$i], $string) Then $reyturn = 1
				
		EndIf
		
	Next
	EndIf
return $reyturn
EndFunc

Func get_all_numbered_element_keys($array, $string_input = False)
	Local $reyturn, $temp, $reyturn_text
	$reyturn_text = ''
	$reyturn = -1
	If $string_input = False And IsArray($array) Then
		
		For $i = 0 To UBound($array) - 1 Step +1
			If StringInStr($array[$i], '[~]array[~]=>>') Then
				$temp = get_key($array[$i])
				;
				If StringRegExp($temp,'(\D{1,})',0) = 0 And StringRegExp($temp,'(\d{1,})',0)  = 1 Then		
					
					If $reyturn_text <> '' Then
						$reyturn_text = $reyturn_text & $ARRAY_simple_glue & $temp
					Else
						$reyturn_text = $temp
					EndIf
				EndIf
			EndIf
		Next
		
	EndIf
	If $reyturn_text <> '' Then
		$reyturn = _StringExplode($reyturn_text, $ARRAY_simple_glue)
		_ArraySort($reyturn)
	EndIf
	
	return $reyturn
EndFunc


Func get_key_value($string)
	Local $arraysr, $reyturn
	$arraysr = _StringExplode($string, '[~]array[~]=>>')
	;If UBound($arraysr) = 1 Then MsgBox(0,"", $string)
	$reyturn = _Base64Decode($arraysr[UBound($arraysr) - 1])
	return $reyturn 
EndFunc

Func get_key($string)
	Local $arraysr, $reyturn
	$arraysr = _StringExplode($string, '[~]array[~]=>>')
	$reyturn = StringReplace($arraysr[0], $ARRAY_associative_key_value_glue, '')
	return $reyturn 
EndFunc

Func print_tabs($times, $return = False)
	Local $reyturn
	$reyturn = ''
	For $e = 1 to $times Step +1
		If $return = True Then
			$reyturn = $reyturn & @TAB
		Else
			ConsoleWrite(@TAB)	
		EndIf
	Next
return $reyturn	
EndFunc

Func print_space($times, $return = False)
	Local $reyturn
	$reyturn = ''
	For $e = 1 to $times Step +1
		If $return = True Then
			$reyturn = $reyturn & ' '
		Else
			ConsoleWrite(' ')	
		EndIf						
	Next
return $reyturn		
EndFunc
Func get_appropriate_place($search_array, $start_position, $total_count)
	$reyturn = -1
	For $i = $start_position To $total_count
		If In_Array($search_array, $i) = -1 Then 
			$reyturn = $i
			ExitLoop
		EndIf
		
	Next
	return $reyturn
EndFunc

Func _isAssociativeArray($string)
	Local $reyturn
	$reyturn = -1
	If IsArray($string) Then
		SetError(1, 1, -1)
	Else
		If StringInStr($string, '[~]array[~]=>>') > 0 Or StringInStr($string, '[~]glue[~]') > 0 Then
			$reyturn = 1
		EndIf
	EndIf
	
	
	
	Return $reyturn
	
EndFunc

;print_r without sorting is more fast
Func print_r(ByRef $myAssArray, $level=1, $enable_sorting = True)
	Local $temp, $temp1, $temp2, $elements, $k, $e, $current_element_position_resgister, $output, $thesortarray
	$output = ''
	$current_element_position_resgister = 0
		If $level = 1 Then
			ConsoleWrite(@CRLF&"Array"&@CRLF&"(")
		EndIf
	$elements = _StringExplode($myAssArray, $ARRAY_simple_glue)
	;_ArrayDisplay($elements)
	Dim $thesortarray[UBound($elements)][2]
	$temp1 = get_all_numbered_element_keys($elements)
	;_ArrayDisplay($temp1)
		For $k = 0 to UBound($elements)-1 Step +1
			If StringInStr($elements[$k], '[~]array[~]=>>') And StringRegExp($elements[$k],'\[~\]ass_key_value_glue\[~\]',0) = 0 Then
				$output = $output & @CRLF
				$output = $output & print_tabs($level, True)
				$output = $output & "[" & get_key($elements[$k]) & "] => Array" & @CRLF
				 
				$output = $output & print_tabs($level, True)
				$output = $output & print_space(stringlen(get_key($elements[$k])) + 2, True)
				$output = $output & "(" 
				$temp2 = get_key_value($elements[$k])
				$output = $output & print_r($temp2, $level + 1, $enable_sorting)

				$output = $output & @CRLF
				$output = $output & print_tabs($level, True)
				$output = $output & print_space(stringlen(get_key($elements[$k])) + 2, True)
				$output = $output & ")"
				$thesortarray[$k][0] = $output
				If Is_number(get_key($elements[$k])) And $enable_sorting = True Then
					$thesortarray[$k][1] = Int(get_key($elements[$k]))
				Else
					
					$thesortarray[$k][1] = get_key($elements[$k])
				EndIf
				$output = ''
			ElseIf StringInStr($elements[$k], '[~]array[~]=>>') And StringRegExp($elements[$k],'\[~\]ass_key_value_glue\[~\]',0) = 1 Then
					;MsgBox(0,"","moma")
					$output = $output & @CRLF
					$output = $output & print_tabs($level, True)
					$output = $output & '[' & get_key($elements[$k]) & '] => ' & StringReplace(get_key_value($elements[$k]), $ARRAY_associative_null, '')
					$thesortarray[$k][0] = $output
				If Is_number(get_key($elements[$k])) And $enable_sorting = True Then
					$thesortarray[$k][1] = Int(get_key($elements[$k]))
				Else
					
					$thesortarray[$k][1] = get_key($elements[$k])
				EndIf
					$current_element_position_resgister += 1
					$output = ''
			Else
				;other place
				;MsgBox(0,"register ", $current_element_position_resgister)
				If In_Array($temp1, $current_element_position_resgister) = -1 Then
					$output = $output & @CRLF
					$output = $output & print_tabs($level, True)
					$output = $output & '[' & $current_element_position_resgister & '] => ' & StringReplace($elements[$k], $ARRAY_associative_null, '')
					$thesortarray[$k][0] = $output
					$thesortarray[$k][1] = $current_element_position_resgister
					$current_element_position_resgister += 1
					$output = ''
				Else
						;MsgBox(0,"", $current_element_position_resgister)
						$output = $output & @CRLF
						$output = $output & print_tabs($level, True)
						$temp4 = get_appropriate_place($temp1, $current_element_position_resgister + 1, UBound($elements)-1)
						$output = $output & '[' & $temp4 & '] => ' & StringReplace($elements[$k], $ARRAY_associative_null, '')
						$thesortarray[$k][0] = $output
						$thesortarray[$k][1] = $temp4
						$output = ''
						$current_element_position_resgister = $temp4 + 1
				EndIf
				
				
			EndIf
			
	
Next
;_ArrayDisplay($thesortarray, 'before sorting')
If $enable_sorting = True Then _ArraySort($thesortarray,0,0,0,1)

;_ArrayDisplay($thesortarray, 'after sorting')
For $i = 0 To UBound($thesortarray) - 1
	$output = $output & $thesortarray[$i][0]
Next
;ConsoleWrite($output)
If $level = 1 Then 
	
ConsoleWrite($output & @CRLF &")" &@CRLF)
	
	EndIf
Return $output
EndFunc


Func array2json(ByRef $myAssArray, $level=1)
	Local $temp, $temp1, $temp2, $elements, $k, $e, $current_element_position_resgister, $output, $thesortarray
	$output = ''
	$current_element_position_resgister = 0

	$elements = _StringExplode($myAssArray, $ARRAY_simple_glue)
	Dim $thesortarray[UBound($elements)][2]
	$temp1 = get_all_numbered_element_keys($elements)
		For $k = 0 to UBound($elements)-1 Step +1
			If StringInStr($elements[$k], '[~]array[~]=>>') And StringRegExp($elements[$k],'\[~\]ass_key_value_glue\[~\]',0) = 0 Then
				;$output = $output & @CRLF
				;$output = $output & print_tabs($level, True)
				$temp2 = get_key_value($elements[$k])
				If $output = '' Then
					$output = $output & '"' &json_encode(get_key($elements[$k])) & '":'
				Else
					$output = $output & ',"' & json_encode(get_key($elements[$k])) & '":'
				EndIf
				
				
				 If StringRegExp($temp2,'\[~\]array\[~\]',0) > 0 Then
					$output = $output & "{" 
				 Else
					 $output = $output & "[" 
				 EndIf
				 
				;$temp2 = get_key_value($elements[$k])
				$output = $output & array2json($temp2, $level + 1)
				 If StringRegExp($temp2,'\[~\]array\[~\]',0) > 0 Then
					$output = $output & "}" 
				 Else
					 $output = $output & "]" 
				 EndIf
				 

			ElseIf StringInStr($elements[$k], '[~]array[~]=>>') And StringRegExp($elements[$k],'\[~\]ass_key_value_glue\[~\]',0) = 1 Then
					;MsgBox(0,"","moma")
				If $output = '' Then
					$output = $output & '"'&json_encode(get_key($elements[$k])) & '":"' & json_encode(get_key_value($elements[$k])) & '"'
				Else
					$output = $output & ',"' & json_encode(get_key($elements[$k])) & '":"' & json_encode(get_key_value($elements[$k])) & '"'
				EndIf

			Else
				;other place
				If $output = '' Then
					$output = $output & '"'& json_encode($elements[$k]) & '"'
				Else
					$output = $output & ',"' & json_encode($elements[$k]) & '"'
				EndIf				
				
				
			EndIf
			
	
Next

If $level = 1 Then 
	
$output = "{" & $output &"}"
	
	EndIf
Return $output
EndFunc
Func Json2Array(ByRef $myAssArray, $json,  $array_path = '')
	Local $reyturn, $temp
	If $array_path = '' Then 
		
		$json = json_decode_main($json)
	EndIf
	
	$json = get_the_json_inner_elements($json)
	Do
		If $json <> '' Then
			If StringRegExp($json,'^(?-i:("[^\:"]{1,}"\:"[^\:"]{0,}",{0,}))',0)  = 1 Then
				;MsgBox(0,"from 1 before",$json)
				$temp = StringRegExp($json,'^(?s)(?-i:"([^\:"]{1,})"\:"([^\:"]{0,})",{0,})',3)
				If $array_path = '' Then
					$array_supply_path = $ARRAY_associative_key_value_glue&json_reconstruct_main($temp[0])
				Else
					$array_supply_path = $array_path & '->' & $ARRAY_associative_key_value_glue&json_reconstruct_main($temp[0])
				EndIf
				
				_AddAssociativeArray($myAssArray, $array_supply_path,  -1, json_reconstruct_main($temp[1]), True)
				$json = StringRegExpReplace($json,'^(?-i:("[^\:"]{1,}"\:"[^\:"]{0,}",{0,}))','')
				;_ArrayDisplay($temp, $array_path)
				;MsgBox(0,"from 1 after",$json)
				$array_supply_path = $array_path
			ElseIf StringRegExp($json,'^(?-i:("[^\:"]{1,}"\:[{|\[]))',0)  = 1 Then
				$temp = StringRegExp($json,'^(?-i:"([^\:"]{1,})"\:([{|\[]))',3);0 gives the element and 1 gives the brace type
				;MsgBox(0,"from 2 before",$json)
				$extracted =  find_brace_pack_the_lame_way($json, $temp[1])
				If $array_path = '' Then
					$array_supply_path = json_reconstruct_main($temp[0])
				Else
					$array_supply_path = $array_path & '->' & json_reconstruct_main($temp[0])
				EndIf
				;MsgBox(0,"me",StringRegExpReplace($extracted,'^("[^\:"]{1,}"\:)',''))
				Json2Array($myAssArray, StringRegExpReplace($extracted,'^("[^\:"]{1,}"\:)',''),  $array_supply_path)
				$json = StringReplace($json,$extracted,'', 1)
				If StringInStr($json, ',', 0, 1, 1, 1) Then $json = StringReplace($json,',','', 1)
				;_ArrayDisplay($temp, $array_path)
				;MsgBox(0,"from 2 after",$json)
				$array_supply_path = $array_path
			ElseIf StringRegExp($json,'^(?-i:([{|\[]))',0)  = 1 Then
				;MsgBox(0,"from 3 before",$json)
				$extracted =  find_brace_pack_the_lame_way($json, StringLeft($json, 1));will give the $brace_type
				$temp2 = _AssociativeArray($myAssArray, $array_path)
				If $temp2[0] = -1 Then
					If $array_path = '' Then
						$array_supply_path = '0'
					Else
						$array_supply_path = $array_path & '->' & '0'
					EndIf
					Json2Array($myAssArray, $extracted,  $array_supply_path)
					$json = StringReplace($json,$extracted,'', 1)
					If StringInStr($json, ',', 0, 1, 1, 1) Then $json = StringReplace($json,',','', 1)
				
				Else
					If $array_path = '' Then
						$array_supply_path = UBound($temp2)
					Else
						$array_supply_path = $array_path & '->' & UBound($temp2)
					EndIf
					Json2Array($myAssArray, $extracted,  $array_supply_path)
					$json = StringReplace($json,$extracted,'', 1)
					If StringInStr($json, ',', 0, 1, 1, 1) Then $json = StringReplace($json,',','', 1)
					;_AssociativeArray($myAssArray, $array_path) will give the no of elements which will be set ...if return is -1 then set it in the array_path and overwrite
				
					
				EndIf
				;MsgBox(0,"from 3 after",$json)
				$array_supply_path = $array_path
			ElseIf StringRegExp($json,'^(?-i:".*?",)',0)  = 1 Or StringRegExp($json,'^(?-i:".*?")$',0)  = 1 Then
				;MsgBox(0,"from 4b efore",$json)
				$temp = StringRegExp($json,'^(?-i:"(.*?)",{0,})',3)
				_AddAssociativeArray($myAssArray, $array_path,  -1, json_reconstruct_main($temp[0]), True)
				$json = StringRegExpReplace($json,'^(?-i:(".*?",{0,}))','')
				;_ArrayDisplay($temp, $array_path)
				;MsgBox(0,"from 4afterrrrr",$json)
				$array_supply_path = $array_path
			Else
				
			EndIf
		EndIf
		;MsgBox(0,$array_path ,$json)
	Until $json = ''
	;MsgBox(0,$json, $array_path)
EndFunc
Func json_encode($string)
	$string = StringReplace($string, '"', '\"')
	$string = StringReplace($string, @CR, '\r')
	$string = StringReplace($string, @LF, '\n')
	$string = StringReplace($string, @TAB, '\t')
	Return $string
EndFunc

Func json_decode_main($json)
	Local $temp, $temp1
	$json = StringRegExpReplace($json,'[^\\](\\")','(~)escapedquote(~)')
	$temp = StringRegExp($json,'[,|\[|{|\:]{1,}("(?:[^{|}|\[|\]|"|\^"\:{"]{0,}[{|}|\[|\]]{1,}[^{|}|\[|\]|"]{0,}){1,}")(?:[,|\]|}]{1,})',3)
	If IsArray($temp) Then
		For $i = 0 To UBound($temp) - 1 Step +1
			
			$temp1 = StringReplace($temp[$i], '{', $escaped_curly_brace_start)
			$temp1 = StringReplace($temp1, '}', $escaped_curly_brace_end)
			$temp1 = StringReplace($temp1, '[', $escaped_square_brace_start)
			$temp1 = StringReplace($temp1, ']', $escaped_square_brace_end)
			$json = StringReplace($json, $temp[$i], $temp1, 1)
			$temp1 = ''
		Next
		
	EndIf
	Return $json
EndFunc
Func json_reconstruct_main($json)
	$json = StringReplace($json, $escaped_curly_brace_start, '{')
	$json = StringReplace($json, $escaped_curly_brace_end, '}')
	$json = StringReplace($json, $escaped_square_brace_start, '[')
	$json = StringReplace($json, $escaped_square_brace_end, ']')
	$json = StringReplace($json, '(~)escapedquote(~)', '\"')
	$json = StringRegExpReplace($json,'([^\\])([\\]r)', '${1}' &@CR)
	$json = StringRegExpReplace($json,'([^\\])([\\]n)', '${1}' &@LF)
	$json = StringRegExpReplace($json,'([^\\])([\\]t)', '${1}' &@TAB)

	Return $json
EndFunc


Func get_the_json_inner_elements($json)
	
	If StringRegExp($json,'^([{|\[])',0)  = 1 And StringRegExp($json,'([}|\]])$',0)  = 1 Then
		$json = StringRegExpReplace($json,'^([{|\[])','')
		$json = StringRegExpReplace($json,'([}|\]])$','')
	EndIf
	
	Return $json
EndFunc
Func find_brace_pack_the_lame_way($json, $brace_type)
	$started = 0
	Local $no_of_openbraces ,$no_of_closedbraces, $reyturn, $brace_type2
	$reyturn = -1
	$no_of_openbraces = 0
	$no_of_closedbraces = 0
	$length = StringLen($json)
	If $brace_type = "{" Then $brace_type2 = "}"
	If $brace_type = "[" Then $brace_type2 = "]"
	;MsgBox(0,$json,$length)
	For $i = 1 To $length Step +1
		If StringInStr($json, $brace_type, 0, 1, $i ,1) Then
			$started = 1
			$no_of_openbraces += 1
		EndIf
		If StringInStr($json, $brace_type2, 0, 1, $i ,1) Then
			;$started = 1
			$no_of_closedbraces += 1
		EndIf
		If $started = 1 And $no_of_openbraces - $no_of_closedbraces = 0 Then
			$reyturn = StringLeft($json, $i)
			;MsgBox(0,$json,$reyturn)
			ExitLoop
		EndIf
		
	Next
Return $reyturn
EndFunc
Func html2array(ByRef $DOCobject, ByRef $array, $whole_document = False)
	Local $reyturn,$head,$body
	$reyturn = -1
	If IsObj($DOCobject) Then
		$head = $DOCobject.document.getElementsByTagName('head')
		For $var in $head
			$head = $var
			ExitLoop
		Next
		$body = $DOCobject.document.getElementsByTagName('body')
		For $var in $body
			$body = $var
			ExitLoop
		Next
		
		If $whole_document = True Then 
			$body = $DOCobject.document.body
			If IsObj($body) Then html2arraymain($body, $array, 'html')
		Else
			If IsObj($head) Then html2arraymain($head, $array, 'html->head')
			If IsObj($body) Then html2arraymain($body, $array, 'html->body')
		EndIf
		
	EndIf
	
	EndFunc
Func html2arraymain(ByRef $object, ByRef $array, $intend = '')
	Local $length, $start_position, $var, $outerhtml_parts
	If IsInt($object.childNodes.length) Then
		$length = $object.childNodes.length
		;ConsoleWrite($intend& "and" &$length& @CR)

		If $length >= 1 Then
			
			For $i = 1 To $length Step +1
				If IsObj($object) Then
					If $i = 1 Then 
						$start_position = $object.firstChild
					Else
						$start_position = $start_position.nextSibling
					EndIf
						If IsObj($start_position) Then 
							;ConsoleWrite($start_position.nodeName& @TAB & $start_position.nodeType&@CR)
								If $start_position.nodeType <> 1 Then
									If $intend = '' Then
										_AddAssociativeArray($array, $i& '->' & $ARRAY_associative_key_value_glue & 'nodetype',  -1, $start_position.nodeType, True)
										_AddAssociativeArray($array, $i& '->' & $ARRAY_associative_key_value_glue & 'innertext',  -1, $start_position.nodevalue, True)
									else
										_AddAssociativeArray($array, $intend & '->' & $i& '->' & $ARRAY_associative_key_value_glue & 'nodetype',  -1, $start_position.nodeType, True)
										_AddAssociativeArray($array, $intend & '->' & $i& '->' & $ARRAY_associative_key_value_glue & 'innertext',  -1, $start_position.nodevalue, True)
									EndIf									
									
								Else
									$outerhtml_parts = _StringExplode(StringReplace($start_position.outerHtml, $start_position.innerHtml, $ARRAY_simple_glue), $ARRAY_simple_glue)
									;_ArrayDisplay($outerhtml_parts, $intend)
									If $intend = '' Then
										_AddAssociativeArray($array, $i& '->' & $ARRAY_associative_key_value_glue & 'nodetype',  -1, $start_position.nodeType, True)
										_AddAssociativeArray($array, $i& '->' & $ARRAY_associative_key_value_glue & 'tagname',  -1, $start_position.tagname, True)
										_AddAssociativeArray($array, $i& '->' & $ARRAY_associative_key_value_glue & 'outerHtml_start',  -1, $outerhtml_parts[0], True)
										If UBound($outerhtml_parts) > 1 Then 
											_AddAssociativeArray($array, $i& '->' & $ARRAY_associative_key_value_glue & 'outerHtml_stop',  -1, $outerhtml_parts[1], True)
										Else
											_AddAssociativeArray($array, $i& '->' & $ARRAY_associative_key_value_glue & 'outerHtml_stop',  -1, '', True)
										EndIf
										
									else
										_AddAssociativeArray($array, $intend & '->' & $i& '->' & $ARRAY_associative_key_value_glue & 'nodetype',  -1, $start_position.nodeType, True)
										_AddAssociativeArray($array, $intend & '->' & $i& '->' & $ARRAY_associative_key_value_glue & 'tagname',  -1, $start_position.tagname, True)
										_AddAssociativeArray($array, $intend & '->' & $i& '->' & $ARRAY_associative_key_value_glue & 'outerHtml_start',  -1, $outerhtml_parts[0], True)
										If UBound($outerhtml_parts) > 1 Then 
											_AddAssociativeArray($array, $intend & '->' & $i& '->' & $ARRAY_associative_key_value_glue & 'outerHtml_stop',  -1, $outerhtml_parts[1], True)
										Else
											_AddAssociativeArray($array, $intend & '->' & $i& '->' & $ARRAY_associative_key_value_glue & 'outerHtml_stop',  -1, '', True)
										EndIf
										
									EndIf
									
									
									
									For $var In $start_position.Attributes
										If $var.value <> '' Then 
											If $intend = '' Then
												_AddAssociativeArray($array, $i& '->'  &  'attributes->' & $ARRAY_associative_key_value_glue & $var.name,  -1, $var.value, True)
											else
												_AddAssociativeArray($array, $intend & '->' & $i& '->' &  'attributes->' &$ARRAY_associative_key_value_glue & $var.name,  -1, $var.value, True)
											EndIf
										EndIf
									Next
									If $intend = '' Then
										html2arraymain($start_position, $array, $i)
									else
										html2arraymain($start_position, $array, $intend & '->' & $i)
									EndIf
									;
								EndIf
						EndIf
						
				EndIf
			Next	
		EndIf
		
	EndIf
EndFunc
