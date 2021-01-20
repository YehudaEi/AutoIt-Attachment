#include-once
; #INDEX# =======================================================================================================================
; Title .........: StringFix
; AutoIt Version: 3.3.0.0+
; Language:       English, Korean
; Description:    Can String to ANSI Binary or ANSI Binary to String
; ===============================================================================================================================

;==============================================================================================================================
; #CURRENT# =====================================================================================================================
;_StringFix
;_StringUnFix
;==============================================================================================================================
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _StringFix
; Description ...: String to Perfect ANSI Binary
; Syntax.........: _StringFix($String[, $Flag = 0])
; Parameters ....: $String 		- To Fix the String
;                  $flag 		- Binary Return?
; Return values .: $flag = 0 	- Fixed String
;                  $flag <> 0 	- Fixed Binary
; Author ........: Green-Box (Admin at EcmaXp.PE.KR)
; Modified.......: 
; Remarks .......: Of a call to the string functions are available. ex) _StringFix(_StringFix("한국어")) [X]
; Related .......: x
; Link ..........;                                     
; Example .......; Yes
; ===============================================================================================================================
Func _StringFix($String, $Flag = 0)
	If IsBinary($String) Then $String = BinaryToString($String)
	If Not IsString($String) Or $String = "" Then Return ""
	Local $i, $sNULL, $nNULL
	
	For $i = 1 To StringLen($String) Step 1
		If Not StringIsASCII(StringMid($String, $i, 1)) Then $sNULL &= Chr(0)
	Next
	
	For $i = StringLen($String) to 1 Step -1
		If StringMid($String, $i, 1) <> Chr(0) Then ExitLoop
		$nNULL += 1
	Next
	
	$String = Binary($String & $sNULL)
	For $i = BinaryLen($String) to 1 Step -1
		If BinaryMid($String, $i, 1) <> 0x00 Then ExitLoop
		$String = BinaryMid($String, 1, BinaryLen($String) - 1)
	Next
	
	$String = String($String)
	For $i = 1 to $nNULL Step 1
		$String &= "00"
	Next
	
	$String = String(Binary($String))
	If $Flag <> 0 Then Return Binary($String)
	Return BinaryToString($String)
EndFunc   ;==>_StringFix

; #FUNCTION# ====================================================================================================================
; Name...........: _StringUnFix
; Description ...: Perfect ANSI Binary to String
; Syntax.........: _StringUnFix($String[, $Flag = 0])
; Parameters ....: $String 		- To Fix the Perfect ANSI Binary
;                  $flag 		- Binary Return?
; Return values .: $flag = 0 	- UnFixed String
;                  $flag <> 0 	- UnFixed Binary
; Author ........: Green-Box (Admin at EcmaXp.PE.KR)
; Modified.......: 
; Remarks .......: Of a call to the string functions are available. ex) _StringUnFix(_StringUnFix(_StringFix("한국어"))) [X]
; Related .......: x
; Link ..........;                                     
; Example .......; Yes
; ===============================================================================================================================
Func _StringUnFix($String, $Flag = 0)
	If IsBinary($String) Then $String = BinaryToString($String)
	If Not IsString($String) Or $String = "" Then Return ""
	
	$String = StringFromASCIIArray(StringToASCIIArray($String, Default, BinaryLen($String), 1), Default, Default, 1)
	If $Flag <> 0 Then Return Binary($String)
	Return $String
EndFunc   ;==>_StringUnFix