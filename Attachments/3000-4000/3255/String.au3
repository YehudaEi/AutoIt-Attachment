#include-once

;===============================================================================
;
; Function Name:    _HexToStr("hex")
; Description:      Convert a hex string of characters to ASCII Characters.
; Parameter(s):     $strHex is the hex string you want to convert.
; Requirement(s):   Hex Input.
; Return Value(s):  On Success - Returns the converted string of characters.
;                   On Failure - -1  and sets @ERROR = 1
; Author(s):        Jarvis Stubblefield 
;
;===============================================================================

Func _HexToString($strHex)
	Local $strChar, $aryHex, $i, $iDec, $Char, $file, $iOne, $iTwo
	
	$aryHex = StringSplit($strHex, "")
	
	For $i = 1 To $aryHex[0]
		$iOne = $aryHex[$i]
		$i = $i + 1
		$iTwo = $aryHex[$i]
		$iDec = Dec($iOne & $iTwo)
		$Char = Chr($iDec)
		$strChar = $strChar & $Char
	Next

	If $strChar = "" Then
		SetError(1)
		Return -1
	Else
		Return $strChar
	EndIf
EndFunc

;===============================================================================
;
; Function Name:    _StringEncryption()
; Description:      RC4 Based string encryption
; Parameter(s):     $i_Encrypt - 1 to encrypt, 0 to decrypt
;                   $s_EncryptText - string to encrypt
;                   $s_EncryptPassword - string to use as an encryption password
;                   $i_EncryptLevel - integer to use as number of times to encrypt string
; Requirement(s):   None
; Return Value(s):  On Success - Returns the string encrypted (blank) times with (blank) password
;                   On Failure - Returns a blank string and sets @error = 1
; Author(s):        Wes Wolfe-Wolvereness <Weswolf@aol.com>
;
;===============================================================================
;
Func _StringEncrypt($i_Encrypt, $s_EncryptText, $s_EncryptPassword, $i_EncryptLevel = 1)
   If $i_Encrypt <> 0 And $i_Encrypt <> 1 Then
      Return ''
      SetError(1)
   ElseIf $s_EncryptText = '' Or $s_EncryptPassword = '' Then
      Return ''
      SetError(1)
   Else
      If Number($i_EncryptLevel) <= 0 Or Int($i_EncryptLevel) <> $i_EncryptLevel Then $i_EncryptLevel = 1
      Local $v_EncryptModified
      Local $i_EncryptCountH
      Local $i_EncryptCountG
      Local $v_EncryptSwap
      Local $av_EncryptBox[256][2]
      Local $i_EncryptCountA
      Local $i_EncryptCountB
      Local $i_EncryptCountC
      Local $i_EncryptCountD
      Local $i_EncryptCountE
      Local $i_EncryptCountF
      Local $v_EncryptCipher
      Local $v_EncryptCipherBy
      If $i_Encrypt = 1 Then
         Local $i_EncryptCountC = 0
         For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
            $i_EncryptCountG = ''
            $i_EncryptCountH = ''
            $v_EncryptModified = ''
            For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
               If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
                  $i_EncryptCountH = 1
               Else
                  $i_EncryptCountH = $i_EncryptCountH + 1
               EndIf
               $v_EncryptModified = $v_EncryptModified & Chr(BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountG, 1)), Asc(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
            Next
            $s_EncryptText = $v_EncryptModified
            $i_EncryptCountA = ''
            $i_EncryptCountB = 0
            $i_EncryptCountC = ''
            $i_EncryptCountD = ''
            $i_EncryptCountE = ''
            $v_EncryptCipherBy = ''
            $v_EncryptCipher = ''
            $v_EncryptSwap = ''
            $av_EncryptBox = ''
            Local $av_EncryptBox[256][2]
            For $i_EncryptCountA = 0 To 255
               $av_EncryptBox[$i_EncryptCountA][1] = Asc(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
               $av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
            Next
            For $i_EncryptCountA = 0 To 255
               $i_EncryptCountB = Mod( ($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
               $v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
               $av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
               $av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
            Next
            For $i_EncryptCountA = 1 To StringLen($s_EncryptText)
               $i_EncryptCountC = Mod( ($i_EncryptCountC + 1), 256)
               $i_EncryptCountD = Mod( ($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
               $i_EncryptCountE = $av_EncryptBox[Mod( ($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256) ][0]
               $v_EncryptCipherBy = BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountA, 1)), $i_EncryptCountE)
               $v_EncryptCipher = $v_EncryptCipher & Hex($v_EncryptCipherBy, 2)
            Next
            $s_EncryptText = $v_EncryptCipher
         Next
      Else
         For $i_EncryptCountF = 0 To $i_EncryptLevel Step 1
            $i_EncryptCountB = 0
            $i_EncryptCountC = ''
            $i_EncryptCountD = ''
            $i_EncryptCountE = ''
            $v_EncryptCipherBy = ''
            $v_EncryptCipher = ''
            $v_EncryptSwap = ''
            $av_EncryptBox = ''
            Local $av_EncryptBox[256][2]
            For $i_EncryptCountA = 0 To 255
               $av_EncryptBox[$i_EncryptCountA][1] = Asc(StringMid($s_EncryptPassword, Mod($i_EncryptCountA, StringLen($s_EncryptPassword)) + 1, 1))
               $av_EncryptBox[$i_EncryptCountA][0] = $i_EncryptCountA
            Next
            For $i_EncryptCountA = 0 To 255
               $i_EncryptCountB = Mod( ($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
               $v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
               $av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
               $av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
            Next
            For $i_EncryptCountA = 1 To StringLen($s_EncryptText) Step 2
               $i_EncryptCountC = Mod( ($i_EncryptCountC + 1), 256)
               $i_EncryptCountD = Mod( ($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
               $i_EncryptCountE = $av_EncryptBox[Mod( ($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256) ][0]
               $v_EncryptCipherBy = BitXOR(Dec(StringMid($s_EncryptText, $i_EncryptCountA, 2)), $i_EncryptCountE)
               $v_EncryptCipher = $v_EncryptCipher & Chr($v_EncryptCipherBy)
            Next
            $s_EncryptText = $v_EncryptCipher
            $i_EncryptCountG = ''
            $i_EncryptCountH = ''
            $v_EncryptModified = ''
            For $i_EncryptCountG = 1 To StringLen($s_EncryptText)
               If $i_EncryptCountH = StringLen($s_EncryptPassword) Then
                  $i_EncryptCountH = 1
               Else
                  $i_EncryptCountH = $i_EncryptCountH + 1
               EndIf
               $v_EncryptModified = $v_EncryptModified & Chr(BitXOR(Asc(StringMid($s_EncryptText, $i_EncryptCountG, 1)), Asc(StringMid($s_EncryptPassword, $i_EncryptCountH, 1)), 255))
            Next
            $s_EncryptText = $v_EncryptModified
         Next
      EndIf
      Return $s_EncryptText
   EndIf
EndFunc   ;==>_StringEncrypt

;===============================================================================
;
; Description:      Changes a string to proper case, same a =Proper function in Excel
; Syntax:           _StringProper( $sString)
; Parameter(s):     $sString      - String to change to proper case.
; Requirement(s):   None
; Return Value(s):  On Success - Returns the proper string.
;                   On Failure - Returns an empty string and sets @error = 1
; Author(s):        Jos van der Zande <jdeb@autoitscript.com>
; Note(s):          None
;
;===============================================================================

Func _StringProper($s_Str)
   Local $iX = 0
   Local $CapNext = 1
   Local $s_nStr = ""
   Local $s_CurChar
   For $iX = 1 To StringLen($s_Str)
      $s_CurChar = StringMid($s_Str, $iX, 1)
      Select
         Case $CapNext = 1
            If __CharacterIsApha($s_CurChar) Then
               $s_CurChar = StringUpper($s_CurChar)
               $CapNext = 0
            EndIf
         Case Not __CharacterIsApha($s_CurChar)
            $CapNext = 1
         Case Else
            $s_CurChar = StringLower($s_CurChar)
      EndSelect
      $s_nStr = $s_nStr & $s_CurChar
   Next
   Return ($s_nStr)
EndFunc   ;==>_StringProper

;===============================================================================
;
; Description:      Repeats a string a specified number of times.
; Syntax:           _StringRepeat( $sString, $iRepeatCount )
; Parameter(s):     $sString      - String to repeat
;                   $iRepeatCount - Number of times to repeat the string
; Requirement(s):   None
; Return Value(s):  On Success - Returns string with specified number of repeats
;                   On Failure - Returns an empty string and sets @error = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _StringRepeat($sString, $iRepeatCount)
   ;==============================================
   ; Local Constant/Variable Declaration Section
   ;==============================================
   Local $sResult
   Local $iCount
   
   Select
      Case Not StringIsInt($iRepeatCount)
         SetError(1)
         Return ""
      Case StringLen($sString) < 1
         SetError(1)
         Return ""
      Case $iRepeatCount <= 0
         SetError(1)
         Return ""
      Case Else
         For $iCount = 1 To $iRepeatCount
            $sResult = $sResult & $sString
         Next
         
         Return $sResult
   EndSelect
EndFunc   ;==>_StringRepeat

;===============================================================================
;
; Description:      Reverses the contents of the specified string.
; Syntax:           _StringReverse( $sString )
; Parameter(s):     $sString - String to reverse
; Requirement(s):   None
; Return Value(s):  On Success - Returns reversed string
;                   On Failure - Returns an empty string and sets @error = 1
; Author(s):        Jonathan Bennett <jon at hiddensoft com>
; Note(s):          None
;
;===============================================================================
Func _StringReverse($sString)
   ;==============================================
   ; Local Constant/Variable Declaration Section
   ;==============================================
   Local $sReverse
   Local $iCount
   
   If StringLen($sString) >= 1 Then
      For $iCount = 1 To StringLen($sString)
         $sReverse = StringMid($sString, $iCount, 1) & $sReverse
      Next
      
      Return $sReverse
   Else
      SetError(1)
      Return ""
   EndIf
EndFunc   ;==>_StringReverse

;===============================================================================
;
; Function Name:    _StrToHex("string")
; Description:      Convert a string of characters to hexidecimal.
; Parameter(s):     $strChar is the string you want to convert.
; Requirement(s):   String Input.
; Return Value(s):  On Success - Returns the converted string in hexidecimal.
;                   On Failure - -1  and sets @ERROR = 1
; Author(s):        Jarvis Stubblefield 
;
;===============================================================================

Func _StringToHex($strChar)
	Local $aryChar, $i, $iDec, $hChar, $file, $strHex
	
	$aryChar = StringSplit($strChar, "")
	
	For $i = 1 To $aryChar[0]
		$iDec = Asc($aryChar[$i])
		$hChar = Hex($iDec, 2)
		$strHex = $strHex & $hChar
	Next
	
	If $strHex = "" Then
		SetError(1)
		Return -1
	Else
		Return $strHex
	EndIf
EndFunc

;=================================================================================
; Helper functions
Func __CharacterIsApha($s_Str)
   Local $a_Alpha = "abcdefghijklmnopqrstuvwxyz"
   Return ( StringInStr($a_Alpha, $s_Str))
EndFunc   ;==>__CharacterIsApha
