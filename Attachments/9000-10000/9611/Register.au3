#include-once

#region main functions
;===============================================================================
; Function Name:    CheckRegister()
; Description:      Verifies if the specified product is registered
; Parameter(s):     $ProductName - The name of the product to verifu
; Return Value(s):  On Success - Returns True if the product is registered, or False if not.
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        CoePSX
;===============================================================================
Func CheckRegister($ProductName)
	$RegNumber = RegRead("HKEY_CURRENT_USER\Software\" & $ProductName, "Key")
	$RegMail = RegRead("HKEY_CURRENT_USER\Software\" & $ProductName, "Email")
	$RegName = RegRead("HKEY_CURRENT_USER\Software\" & $ProductName, "Name")
	If $RegName = "" Or $RegMail = "" Or $RegNumber = "" Then
		SetError(1)
		Return(0)
	EndIf	
	If $RegNumber = RegGetCode(1, $RegName, $RegMail, RegGetCode(0, $RegName, $RegMail)) Then
		Return(True)
	Else
		Return(False)
	EndIf
EndFunc

;===============================================================================
; Function Name:    OrderRegister()
; Description:      Creates a verification number to be sent with a name and an email as an order.
; Parameter(s):     $RegName - The person's full name
;					$RegMail - The person's email
; Return Value(s):  On Success - Returns the verification number. Format -> NNNNN-NNNNN-NNNNN-NNNNN
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        CoePSX
;===============================================================================
Func OrderRegister($RegName, $RegMail)
	If $RegName = "" Or $RegMail = "" Then
		SetError(1)
		Return(0)
	EndIf
	Return(RegGetCode(0, $RegName, $RegMail))
EndFunc

;===============================================================================
; Function Name:    RegisterGenerate()
; Description:      Generates the final register number.
; Parameter(s):     $RegName - The person's full name
;					$RegMail - The person's email
;					$RegNumber - The verification number
; Return Value(s):  On Success - Returns the final register number. Format -> NNNNN-NNNNN-NNNNN-NNNNN
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        CoePSX
;===============================================================================
Func RegisterGenerate($RegName, $RegMail, $RegNumber)
	If $RegName = "" Or $RegMail = "" Or $RegNumber = "" Then
		SetError(1)
		Return(0)
	EndIf
	Return(RegGetCode(1, $RegName, $RegMail, $RegNumber))
EndFunc

;===============================================================================
; Function Name:    RegisterProduct()
; Description:      Registers the product on that computer.
; Parameter(s):     $ProductName - The product name
;					$RegName - The person's full name
;					$RegMail - The person's email
;					$RegNumber - The final register number
; Return Value(s):  On Success - Returns True. Registers succesfully and writes the register information on the registry
;                   On Failure - Returns False. Sets @ERROR = 1 if there's a invalid argument, and @ERROR = 2 if the register is invalid
; Author(s):        CoePSX
;===============================================================================
Func RegisterProduct($ProductName, $RegName, $RegMail, $RegNumber)
	If $ProductName = "" Or $RegName = "" Or $RegMail = "" Or $RegNumber = "" Then
		SetError(1)
		Return(False)
	EndIf
	If $RegNumber = RegisterGenerate($RegName, $RegMail, RegGetCode(0, $RegName, $RegMail)) Then
		RegWrite("HKEY_CURRENT_USER\Software\" & $ProductName, "Key", "REG_SZ", $RegNumber)
		RegWrite("HKEY_CURRENT_USER\Software\" & $ProductName, "Name", "REG_SZ", $RegName)
		RegWrite("HKEY_CURRENT_USER\Software\" & $ProductName, "Email", "REG_SZ", $RegMail)
		Return(True)
	Else
		SetError(2)
		Return(False)
	EndIf	
EndFunc
#endregion

#region internal functions
;===============================================================================
;
; Function Name:    _StringEncrypt()
; Description:      RC4 Based string encryption
; Parameter(s):     $i_Encrypt - 1 to encrypt, 0 to decrypt
;                   $s_EncryptText - string to encrypt
;                   $s_EncryptPassword - string to use as an encryption password
;                   $i_EncryptLevel - integer to use as number of times to encrypt string
; Requirement(s):   None
; Return Value(s):  On Success - Returns the string encrypted (blank) times with (blank) password
;                   On Failure - Returns a blank string and sets @error = 1
; Author(s):        Wes Wolfe-Wolvereness <Weswolf at aol dot com>
;
;===============================================================================
;
Func _StringEncrypt($i_Encrypt, $s_EncryptText, $Mode, $i_EncryptLevel = 1)
	If $Mode = 1 Then
		$s_EncryptPassword = "In"
	Else
		$s_EncryptPassword = "Out"
	EndIf	
	If $i_Encrypt <> 0 And $i_Encrypt <> 1 Then
		SetError(1)
		Return ''
	ElseIf $s_EncryptText = '' Or $s_EncryptPassword = '' Then
		SetError(1)
		Return ''
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
		Local $v_EncryptCipher
		Local $v_EncryptCipherBy
		If $i_Encrypt = 1 Then
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
					$i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
					$v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
					$av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
					$av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
				Next
				For $i_EncryptCountA = 1 To StringLen($s_EncryptText)
					$i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
					$i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
					$i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256) ][0]
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
					$i_EncryptCountB = Mod(($i_EncryptCountB + $av_EncryptBox[$i_EncryptCountA][0] + $av_EncryptBox[$i_EncryptCountA][1]), 256)
					$v_EncryptSwap = $av_EncryptBox[$i_EncryptCountA][0]
					$av_EncryptBox[$i_EncryptCountA][0] = $av_EncryptBox[$i_EncryptCountB][0]
					$av_EncryptBox[$i_EncryptCountB][0] = $v_EncryptSwap
				Next
				For $i_EncryptCountA = 1 To StringLen($s_EncryptText) Step 2
					$i_EncryptCountC = Mod(($i_EncryptCountC + 1), 256)
					$i_EncryptCountD = Mod(($i_EncryptCountD + $av_EncryptBox[$i_EncryptCountC][0]), 256)
					$i_EncryptCountE = $av_EncryptBox[Mod(($av_EncryptBox[$i_EncryptCountC][0] + $av_EncryptBox[$i_EncryptCountD][0]), 256) ][0]
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
Func Stretch($Macro, $Mode, $Size = 5)
	If $Macro = "" Then Return(0)
	$Macro = _StringEncrypt(1, $Macro, $Mode, 1)
	Local $Length = StringLen($Macro)
	Local $Temp = $Macro
	If $Length > $Size Then
		$Array = StringSplit($Macro, "")
		Do
			$Temp = ""
			For $i = 1 To $Array[0]-1 Step 1
				$Temp = $Temp & Mod(($Array[$i] + $Array[$i+1]), 10)
			Next
			$Length = StringLen($Temp)
			$Array = StringSplit($Temp, "")
		Until $Length = $Size
	Else
		If $Length < $Size Then
			$Temp = $Macro
			Do
				$Temp = $Temp * 2
				$Length = StringLen($Temp)
			Until $Length = $Size
		EndIf
	EndIf
	Return $Temp
EndFunc
Func RegGetCode($Mode, $Name, $Email, $Number = 0)
	If $Name = "" Or $Email = "" Then
		Return(0)
	EndIf	
	If $Mode = 1 Then
		$Temp = StringReplace($Number, "-", "")
		$Temp = Stretch($Temp, 1, 10)
		$Temp = StringLeft($Temp, 5) & "-" & StringTrimLeft($Temp, 5)
		Return(Stretch($Name, 1) & "-" & Stretch($Email, 1) & "-" & $Temp)
	Else
		$Temp = Stretch(@UserName & @ComputerName, 0, 20)
		Return(StringLeft($Temp, 5) & "-" & StringMid($Temp, 6, 5) & "-" & StringMid($Temp, 11, 5) & "-" & StringRight($Temp, 5))
	EndIf	
EndFunc
#endregion

