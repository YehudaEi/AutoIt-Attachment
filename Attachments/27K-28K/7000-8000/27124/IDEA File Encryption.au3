#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sfc
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;A Big Thanks To RazerM for his IDEA File Encryption Algorithm===================================================================
;http://www.autoitscript.com/forum/index.php?showtopic=33238&st=0&p=240202&hl=idea%20encryption&fromsearch=1&#entry240202
;
;	IDEA ENCRYPTION ALGORITHM RESOURCES
;		(INFO) http://en.wikipedia.org/wiki/IDEA_encryption_algorithm (info)
;		(DIAGRAM) http://upload.wikimedia.org/wikipedia/commons/a/af/International_Data_Encryption_Algorithm_InfoBox_Diagram.svg
;
;	RIJNDAEL ENCRYPTION ALGORITHM RESOURCES
;		(INFO) http://en.wikipedia.org/wiki/Rijndael
;		(CBC STEPS) http://en.wikipedia.org/wiki/Block_cipher_modes_of_operation
;		(PADDING METHODS) http://en.wikipedia.org/wiki/Padding_%28cryptography%29
;		(ENCRYPTION STEPS) http://en.wikipedia.org/wiki/Ciphertext_stealing
;
;	NOTES
;		Use Rijndael encryption algoritm (CBC method) to encrypt key
;		Use IDEA file encryption (for speed) to encrypt file using encrypted key
;
;================================================================================================================================

#Region Encrypt File

Func __FileCopy($FileInput, $FileOutput)
	Local $NULL, $szDrive, $szDir, $szFName, $szExt
	_PathSplit($FileInput, $szDrive, $szDir, $szFName, $szExt)
	FileCopy($FileInput, @TempDir, 9)
	Return SetError(0, FileMove(@TempDir & "\" & $szFName & $szExt, $FileOutput, 9), @TempDir & "\" & $szFName & $szExt)
EndFunc   ;==>__FileCopy

;================================================================================================================================
;
; Function Name:    _FileDecrypt()
; Description:      Decrypt a file using the IDEA Algorithm
; Parameter(s):     $FileInput - File to decrypt
;					$FileOutput - Where to save decrypted file
;					$sKey - Key to decrypt file with
; Requirement(s):   File.au3
; Return Value(s):  On Success - Returns 1
;                   On Failure - Sets @error to 1 if input file does not exist
;							   - Sets @error to 2 if writing new file fails
; Author(s):        RazerM
;================================================================================================================================

Func _FileDecrypt($FileInput, $FileOutput, $sKey)
	Select
		Case Not FileExists(@TempDir & "\encrypt.com")
			_WriteEncryptCom()
		Case Not FileExists($FileInput)
			Return SetError(1, 0, 0)
	EndSelect
	$FileTemp = __FileCopy($FileInput, $FileOutput)
	If @extended = 0 Then Return SetError(2, 0, 0)
	RunWait(@ComSpec & " /c echo " & $sKey & "|" & FileGetShortName(@TempDir & "\encrypt.com") & " - " & FileGetShortName($FileOutput), "", @SW_HIDE)
	FileDelete(@TempDir & "\encrypt.com")
	FileDelete($FileTemp)
EndFunc   ;==>_FileDecrypt
;================================================================================================================================
;
; Function Name:    _FileEncrypt()
; Description:      Encrypts a file using the IDEA Algorithm
; Parameter(s):     $FileInput - File to encrypt
;					$FileOutput - Where to save encrypted file
;					$sKey - Key to encrypt file with
; Requirement(s):   File.au3
; Return Value(s):  On Success - Returns 1
;                   On Failure - Sets @error to 1 if input file does not exist
;							   - Sets @error to 2 if writing new file fails
; Author(s):        RazerM
;================================================================================================================================

Func _FileEncrypt($FileInput, $FileOutput, $sKey)
	Select
		Case Not FileExists(@TempDir & "\encrypt.com")
			_WriteEncryptCom()
		Case Not FileExists($FileInput)
			Return SetError(1, 0, 0)
	EndSelect
	$FileTemp = __FileCopy($FileInput, $FileOutput)
	If @extended = 0 Then Return SetError(2, 0, 0)
	RunWait(@ComSpec & " /c echo " & $sKey & "|" & FileGetShortName(@TempDir & "\encrypt.com") & " + " & FileGetShortName($FileOutput), "", @SW_HIDE)
	FileDelete(@TempDir & "\encrypt.com")
	FileDelete($FileTemp)
EndFunc   ;==>_FileEncrypt

Func _PathSplit($szPath, ByRef $szDrive, ByRef $szDir, ByRef $szFName, ByRef $szExt)
	; Set local strings to null (We use local strings in case one of the arguments is the same variable)
	Local $drive = ""
	Local $dir = ""
	Local $fname = ""
	Local $ext = ""
	Local $pos

	; Create an array which will be filled and returned later
	Local $array[5]
	$array[0] = $szPath; $szPath can get destroyed, so it needs set now

	; Get drive letter if present (Can be a UNC server)
	If StringMid($szPath, 2, 1) = ":" Then
		$drive = StringLeft($szPath, 2)
		$szPath = StringTrimLeft($szPath, 2)
	ElseIf StringLeft($szPath, 2) = "\\" Then
		$szPath = StringTrimLeft($szPath, 2) ; Trim the \\
		$pos = StringInStr($szPath, "\")
		If $pos = 0 Then $pos = StringInStr($szPath, "/")
		If $pos = 0 Then
			$drive = "\\" & $szPath; Prepend the \\ we stripped earlier
			$szPath = ""; Set to null because the whole path was just the UNC server name
		Else
			$drive = "\\" & StringLeft($szPath, $pos - 1) ; Prepend the \\ we stripped earlier
			$szPath = StringTrimLeft($szPath, $pos - 1)
		EndIf
	EndIf

	; Set the directory and file name if present
	Local $nPosForward = StringInStr($szPath, "/", 0, -1)
	Local $nPosBackward = StringInStr($szPath, "\", 0, -1)
	If $nPosForward >= $nPosBackward Then
		$pos = $nPosForward
	Else
		$pos = $nPosBackward
	EndIf
	$dir = StringLeft($szPath, $pos)
	$fname = StringRight($szPath, StringLen($szPath) - $pos)

	; If $szDir wasn't set, then the whole path must just be a file, so set the filename
	If StringLen($dir) = 0 Then $fname = $szPath

	$pos = StringInStr($fname, ".", 0, -1)
	If $pos Then
		$ext = StringRight($fname, StringLen($fname) - ($pos - 1))
		$fname = StringLeft($fname, $pos - 1)
	EndIf

	; Set the strings and array to what we found
	$szDrive = $drive
	$szDir = $dir
	$szFName = $fname
	$szExt = $ext
	$array[1] = $drive
	$array[2] = $dir
	$array[3] = $fname
	$array[4] = $ext
	Return $array
EndFunc   ;==>_PathSplit

Func _WriteEncryptCom()
	Local $com
	$com = "0xE81A01BAE402BE8000AC0AC0740AACAC3C2D74073C2B7407E9FE00FE06DD"
	$com &= "01ADAC3C2077FB884CFFB2F0B409CD21B2F6B40ACD21B110BEF8025156B1"
	$com &= "04BE8203BF9A03F3A55E56E8DC00BE9A03568BFEE8E600B104BE7A03BF8A"
	$com &= "0357F3A55F5E56E802018BF7BF7A03E8C3005F5E5657E8B300B104BE8A03"
	$com &= "F3A55E8BFEE8B900B104BE8203BF92035657F3A55F57BE9A03E8D2005E5F"
	$com &= "E896005E83C60859E299BF7A03E89300BA8400B8023DCD21720B93B90080"
	$com &= "BA0A04B43FCD2172590BC0745C5250538BFA050700B103D3E891BE7A0351"
	$com &= "57BF0204E88D00B904005EF8720FAD86E03305AB86E08944FEE2F3EB0F8B"
	$com &= "1DAD86E0AB33D886FB895CFEE2F18BFE59E2CB5B5A52F7DA49B80142CD21"
	$com &= "595AB440CD21739BBADE02B409CD21BFF702B91381F3AAC3B104AD86E0AB"
	$com &= "E2FAC3B90400AD3305ABE2FAC383C710B3088BC324073C068B45F28B55F4"
	$com &= "72088B55E474038B45E2B109D3E0B107D3EA0BC2AB4380FB3475D9C3C606"
	$com &= "780308578B158B4D028B6D048B7D06E8500093AD03C8AD03E88BD7E84400"
	$com &= "97515533EB33CF8BD5E8380003C8958BD1E8300003E89133D933FD5A5833"
	$com &= "CA33E88BD3FE0E780375C8E8180093AD03E8AD03C88BD7E80C005F5793AB"
	$com &= "95AB91AB93AB5FC352ADF7E22BC25A7507402B44FE2BC2C3150000C34572"
	$com &= "726F72094944454120F12046696C65244B65793A202480"
	$hEncryptCom = FileOpen(@TempDir & "\encrypt.com", 2 + 16)
	FileWrite($hEncryptCom, Binary($com))
	FileClose($hEncryptCom)
EndFunc   ;==>_WriteEncryptCom
#EndRegion Encrypt File

#Region Encrypt Password

Func _Bin($decimal)
	Return Binary('0x' & Hex($decimal))
EndFunc   ;==>_Bin

Func _Dec($binary)
	Return Dec(StringTrimLeft($binary, 2))
EndFunc   ;==>_Dec

;================================================================================================================================
;
; Name:	            _rijndaelCipher
; Description:      Encrypts data using the rijndael (AES) algorithm
; Parameter(s):     $key - String or binary that is used as the key for the encryption
;                          Can be 16, 20, 24, 28, or 32 in length
;                   $message - The data to be encrypted, can be a string or binary
;                   $BlockSize - The size of data blocks to be encrypted. Values can be:
;                          128 (Default, also the actual size used by AES)
;                          160
;                          192
;                          224
;                          256
;                   $mode - Which encryption mode to use. Values can be:
;                          0 - ECB mode (Default)
;                          1 - CBC mode
;                          2 - CBF mode
;                          3 - OBF mode
;                          4 - CTR mode
;                   $iv - The initialization vector, only used in modes 1-4, defaults to ''
;                          Can be a string or binary with length equal to $BlockSize / 8
;                   $padding - Which padding scheme to use if the message length isn't a multiple of BlockSize / 8
;                          Doesn't apply to modes 2-4. Values can be:
;                              0 - Null byte padding (Default)
;                              1 - Pad with a number of bytes, whose value equals the number used, to fill in the block
;                              2 - Pad with 80 & Null bytes
;                              3 - Ciphertext Stealing
; Requirement(s):   None
; Return Value(s):  On Success - Binary containing the encrypted data
;                   On Failure - 0  and Set
;                           @ERROR to:  1 - Invalid $BlockSize
;                                       2 - Invalid Key Length
;                                       3 - Invalid $mode
;                                       4 - @EXTENDED: 0 - $padding out of Range
;                                                      1 - $message not long enough for $padding = 3 (See Notes)
;                                       5 - Invalid $iv size
; Author(s):        Matthew Robinson (SkinnyWhiteGuy)
; Note(s):          For @Error 4, @Extended 1, the Message should be longer than one block
;                       (Len($message) should be greater than $BlockSize / 8)
;                   Padding schemes 0 - 2 may produce output longer than the input
;                   Padding scheme 3 produces output the same length as the input
;                   For more information, visit these links:
;                       http://en.wikipedia.org/wiki/Rijndael
;                       http://en.wikipedia.org/wiki/Block_cipher_modes_of_operation
;                       http://en.wikipedia.org/wiki/Padding_%28cryptography%29
;                       http://en.wikipedia.org/wiki/Ciphertext_stealing
;
;================================================================================================================================

Func _rijndaelCipher($Key, $message, $BlockSize = 128, $mode = 0, $IV = '', $padding = 0)
	Switch $BlockSize
		Case 128, 160, 192, 224, 256
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch
	Switch BinaryLen($Key)
		Case 16, 20, 24, 28, 32
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch
	If $mode < 0 Or $mode > 4 Then Return SetError(3, 0, 0)
	If $padding < 0 Or $padding > 3 Then Return SetError(4, 0, 0)

	If $padding = 3 Then
		If $mode > 1 Then
			Return SetError(4, 1, 0)
		Else
			If BinaryLen($message) <= ($BlockSize / 8) Then
				Return SetError(4, 2, 0)
			EndIf
		EndIf
	EndIf

	If $IV <> "" Then
		If BinaryLen($IV) <> ($BlockSize / 8) Then Return SetError(5, 0, 0)
	EndIf
	Local $m = 0, $fill, $plainNow, $plainNext
	Local $Result, $tempresult, $ct, $d, $P, $temp, $Cn, $i
	Local $BlockBytes = $BlockSize / 8
	If Not IsBinary($message) Then $message = StringToBinary($message)
	If Not IsBinary($Key) Then $Key = StringToBinary($Key)
	If Not IsBinary($IV) Then $IV = StringToBinary($IV)
	Local $Nb = $BlockSize / 32 ; 128 bits per message block divided into 32-bit words
	Local $Nk = BinaryLen($Key) / 4
	Local $Nr = 6 + _Max($Nb, $Nk)
	Local $S[$Nb]
	Local $w = expand_key($Key, $Nb, $Nk, $Nr)

	Local $zeros = Binary('0x0000000000000000000000000000000000000000000000000000000000000000')
	If $IV = "" Then $IV = BinaryMid($zeros, 1, $BlockBytes)

	; If Mode is ECB(0) or CBC(1), and not CTS, then Make sure the message is a multiple of the State Size
	If $mode < 2 And $padding <> 3 Then
		Switch $padding
			Case 0
				If Mod(BinaryLen($message), $BlockBytes) <> 0 Then
					$message &= BinaryMid($zeros, 1, $BlockBytes - Mod(BinaryLen($message), $BlockBytes))
				EndIf
			Case 1
				$fill = $BlockBytes
				If Mod(BinaryLen($message), $BlockBytes) <> 0 Then
					$fill = $BlockBytes - Mod(BinaryLen($message), $BlockBytes)
				EndIf
				For $i = 1 To $fill
					$message &= Binary('0x' & Hex($fill, 2))
				Next
			Case 2
				$message &= Binary('0x80')
				If Mod(BinaryLen($message), $BlockBytes) <> 0 Then
					$message &= BinaryMid($zeros, 1, $BlockBytes - Mod(BinaryLen($message), $BlockBytes))
				EndIf
		EndSwitch
	EndIf
	Local $len = BinaryLen($message) ; Number of bytes in $message
	Local $blocks = Ceiling($len / $BlockBytes) ; Number of blocks in $message

	; For each plaintext block, run the encryption
	For $m = 1 To $blocks
		$plainNow = BinaryMid($message, ($m - 1) * $BlockBytes + 1, $BlockBytes)
		If $m < $blocks Then
			$plainNext = BinaryMid($message, $m * $BlockBytes + 1, $BlockBytes)
		EndIf
		; This is where I need to start checking for the different modes, that pass different values
		; on to be encrypted for s and all that
		For $i = 0 To $Nb - 1
			Switch $mode
				Case 0 ; ECB mode
					If $padding <> 3 Or $m < $blocks Then
						$S[$i] = _Dec(BinaryMid($plainNow, $i * 4 + 1, 4))
					Else
						$S[$i] = _Dec(BinaryMid($d, $i * 4 + 1, 4)) ; Use $d, which we will setup after encryption of the previous block
					EndIf
				Case 1 ; CBC mode
					If $padding <> 3 Then
						If $m = 1 Then ; If we are still on the first block
							$S[$i] = BitXOR(_Dec(BinaryMid($plainNow, $i * 4 + 1, 4)), _Dec(BinaryMid($IV, $i * 4 + 1, 4))) ; XOR the plaintext with the IV
						Else ; Otherwise, use the previous ciphertext block made
							$S[$i] = BitXOR(_Dec(BinaryMid($plainNow, $i * 4 + 1, 4)), _Dec(BinaryMid($tempresult, $i * 4 + 1, 4))) ; XOR the plaintext with the previous cipher block
						EndIf
					Else
						; Check for correct round to modify, otherwise continue as normal
						If $m = 1 Then ; First block uses IV
							$S[$i] = BitXOR(_Dec(BinaryMid($plainNow, $i * 4 + 1, 4)), _Dec(BinaryMid($IV, $i * 4 + 1, 4))) ; XOR the plaintext with the IV
						ElseIf $m < $blocks Then ; From there till the last 2, use the previous cipher block as normal
							$S[$i] = BitXOR(_Dec(BinaryMid($plainNow, $i * 4 + 1, 4)), _Dec(BinaryMid($tempresult, $i * 4 + 1, 4))) ; XOR the plaintext with the previous cipher block
						Else ; Now is where we start mixing things up
							$S[$i] = BitXOR(_Dec(BinaryMid($P, $i * 4 + 1, 4)), _Dec(BinaryMid($Cn, $i * 4 + 1, 4))) ; Use the adjusted values from before
						EndIf
					EndIf
				Case 2 ; CFB mode
					; Use the IV for the State array input at first, then use the ciphertext from the last round
					If $m = 1 Then
						$S[$i] = _Dec(BinaryMid($IV, $i * 4 + 1, 4))
					Else
						$S[$i] = _Dec(BinaryMid($tempresult, $i * 4 + 1, 4))
					EndIf
				Case 3 ; OFB mode
					; Use the IV for the first round, then use the results from the Cipher last time in the rest
					If $m = 1 Then
						$S[$i] = _Dec(BinaryMid($IV, $i * 4 + 1, 4))
					EndIf
					; No need to set the state, it should still hold the value it did from the last loop :)
				Case 4 ; CTR mode
					; Use the IV XOR'd with a Counter (probably round #) as the state
					$S[$i] = BitXOR(_Dec(BinaryMid($IV, $i * 4 + 1, 4)), $m - 1)
			EndSwitch
		Next

		; After loading the State ,Run the Encryption on it
		$S = Cipher($w, $S, $Nb, $Nk, $Nr)

		; Read the now encrypted state into the ciphertext array
		For $i = 0 To $Nb - 1
			Switch $mode
				Case 0, 1 ; ECB & CBC mode
					If $padding <> 3 Or $m < $blocks - 1 Then
						$tempresult = Binary($tempresult) & _Bin($S[$i])
					Else ; CTS
						$temp = Binary($temp) & _Bin($S[$i])
						If $i = $Nb - 1 Then ; Wait till we have all the cipherblock from the state written
							If $mode = 0 Then
								If $m = $blocks - 1 Then ; Next to last cipherblock
									$MBytes = BinaryLen($plainNext) ; Number of blocks to get from the beginning of the cipherblock
									$Cn = $temp ; Store this until the last cipherblock is found, so they can be switched properly
									$d = Binary($plainNext) & BinaryMid($temp, $MBytes + 1, $BlockBytes - $MBytes) ; Setup $d for the next round
									$temp = '' ; Clear $temp for next round
								ElseIf $m = $blocks Then ; Last cipherblock
									$Result = Binary($Result) & Binary($temp); add this cipher block as the next to last
									$tempresult = $Cn ; setup $Cn to be added as the last block
								EndIf
							ElseIf $mode = 1 Then
								If $m = $blocks - 1 Then ; Next to last cipherblock
									$MBytes = BinaryLen($plainNext) ; Number of blocks in the last plaintext block
									$Cn = $temp ; Store this for the next round
									$P = Binary($plainNext) & BinaryMid(Binary($zeros), 1, $BlockBytes - $MBytes)
									$temp = '' ; Clear $temp for next round
								ElseIf $m = $blocks Then ; Last cipherblock
									$Result = Binary($Result) & Binary($temp); Insert this block before the one before
									$tempresult = $Cn ; setup $Cn to be added as the last block
								EndIf
							EndIf
						EndIf
					EndIf
				Case 2, 3, 4 ; CFB, OFB, & CTR mode
					$tempresult = Binary($tempresult) & _Bin(BitXOR($S[$i], _Dec(BinaryMid($plainNow, $i * 4 + 1, 4))))
			EndSwitch
		Next

		$Result = Binary($Result) & Binary($tempresult)
		$tempresult = ''
	Next

	If $mode < 2 And $padding = 3 Then
		$Result = BinaryMid($Result, 1, BinaryLen($message))
	EndIf

	Return $Result
EndFunc   ;==>_rijndaelCipher

; #FUNCTION# ====================================================================================================================
; Name...........: _StringReverse
; Description ...: Reverses the contents of the specified string.
; Syntax.........: _StringReverse($sString)
; Parameters ....: $sString - String to reverse
; Return values .: Success - Returns reversed string
;                  Failure - Returns an empty string and sets @error = 1
;                  |@Error  - 0 = No error.
;                  |@Error  - 1 = One of the parameters is invalid
; Author ........: Jonathan Bennett <jon at hiddensoft com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
;================================================================================================================================

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

; #FUNCTION# ====================================================================================================================
; Name...........: _StringToHex
; Description ...: Convert a string to a hex string.
; Syntax.........: _StringToHex($strChar)
; Parameters ....: $strChar - string to be converted.
; Return values .: Success - Returns an hex string.
;                  Failure - Returns -1 and sets @error to 1.
; Author ........: Jarvis Stubblefield
; Modified.......: 2005/09/04 jpm error checking
; Remarks .......:
; Related .......: _HexToString
; Link ..........;
; Example .......; Yes
;================================================================================================================================

Func _StringToHex($strChar)
	Local $aryChar, $i, $iDec, $hChar, $strHex

	$aryChar = StringSplit($strChar, "")

	For $i = 1 To $aryChar[0]
		$iDec = Asc($aryChar[$i])
		$hChar = Hex($iDec, 2)
		$strHex &= $hChar
	Next

	Return $strHex

EndFunc   ;==>_StringToHex

Func Cipher($w, $S, $Nb, $Nk, $Nr)
	Local $Te0[256]
	$Te0[0] = 0xC66363A5
	$Te0[1] = 0xF87C7C84
	$Te0[2] = 0xEE777799
	$Te0[3] = 0xF67B7B8D
	$Te0[4] = 0xFFF2F20D
	$Te0[5] = 0xD66B6BBD
	$Te0[6] = 0xDE6F6FB1
	$Te0[7] = 0x91C5C554
	$Te0[8] = 0x60303050
	$Te0[9] = 0x02010103
	$Te0[10] = 0xCE6767A9
	$Te0[11] = 0x562B2B7D
	$Te0[12] = 0xE7FEFE19
	$Te0[13] = 0xB5D7D762
	$Te0[14] = 0x4DABABE6
	$Te0[15] = 0xEC76769A
	$Te0[16] = 0x8FCACA45
	$Te0[17] = 0x1F82829D
	$Te0[18] = 0x89C9C940
	$Te0[19] = 0xFA7D7D87
	$Te0[20] = 0xEFFAFA15
	$Te0[21] = 0xB25959EB
	$Te0[22] = 0x8E4747C9
	$Te0[23] = 0xFBF0F00B
	$Te0[24] = 0x41ADADEC
	$Te0[25] = 0xB3D4D467
	$Te0[26] = 0x5FA2A2FD
	$Te0[27] = 0x45AFAFEA
	$Te0[28] = 0x239C9CBF
	$Te0[29] = 0x53A4A4F7
	$Te0[30] = 0xE4727296
	$Te0[31] = 0x9BC0C05B
	$Te0[32] = 0x75B7B7C2
	$Te0[33] = 0xE1FDFD1C
	$Te0[34] = 0x3D9393AE
	$Te0[35] = 0x4C26266A
	$Te0[36] = 0x6C36365A
	$Te0[37] = 0x7E3F3F41
	$Te0[38] = 0xF5F7F702
	$Te0[39] = 0x83CCCC4F
	$Te0[40] = 0x6834345C
	$Te0[41] = 0x51A5A5F4
	$Te0[42] = 0xD1E5E534
	$Te0[43] = 0xF9F1F108
	$Te0[44] = 0xE2717193
	$Te0[45] = 0xABD8D873
	$Te0[46] = 0x62313153
	$Te0[47] = 0x2A15153F
	$Te0[48] = 0x0804040C
	$Te0[49] = 0x95C7C752
	$Te0[50] = 0x46232365
	$Te0[51] = 0x9DC3C35E
	$Te0[52] = 0x30181828
	$Te0[53] = 0x379696A1
	$Te0[54] = 0x0A05050F
	$Te0[55] = 0x2F9A9AB5
	$Te0[56] = 0x0E070709
	$Te0[57] = 0x24121236
	$Te0[58] = 0x1B80809B
	$Te0[59] = 0xDFE2E23D
	$Te0[60] = 0xCDEBEB26
	$Te0[61] = 0x4E272769
	$Te0[62] = 0x7FB2B2CD
	$Te0[63] = 0xEA75759F
	$Te0[64] = 0x1209091B
	$Te0[65] = 0x1D83839E
	$Te0[66] = 0x582C2C74
	$Te0[67] = 0x341A1A2E
	$Te0[68] = 0x361B1B2D
	$Te0[69] = 0xDC6E6EB2
	$Te0[70] = 0xB45A5AEE
	$Te0[71] = 0x5BA0A0FB
	$Te0[72] = 0xA45252F6
	$Te0[73] = 0x763B3B4D
	$Te0[74] = 0xB7D6D661
	$Te0[75] = 0x7DB3B3CE
	$Te0[76] = 0x5229297B
	$Te0[77] = 0xDDE3E33E
	$Te0[78] = 0x5E2F2F71
	$Te0[79] = 0x13848497
	$Te0[80] = 0xA65353F5
	$Te0[81] = 0xB9D1D168
	$Te0[82] = 0x00000000
	$Te0[83] = 0xC1EDED2C
	$Te0[84] = 0x40202060
	$Te0[85] = 0xE3FCFC1F
	$Te0[86] = 0x79B1B1C8
	$Te0[87] = 0xB65B5BED
	$Te0[88] = 0xD46A6ABE
	$Te0[89] = 0x8DCBCB46
	$Te0[90] = 0x67BEBED9
	$Te0[91] = 0x7239394B
	$Te0[92] = 0x944A4ADE
	$Te0[93] = 0x984C4CD4
	$Te0[94] = 0xB05858E8
	$Te0[95] = 0x85CFCF4A
	$Te0[96] = 0xBBD0D06B
	$Te0[97] = 0xC5EFEF2A
	$Te0[98] = 0x4FAAAAE5
	$Te0[99] = 0xEDFBFB16
	$Te0[100] = 0x864343C5
	$Te0[101] = 0x9A4D4DD7
	$Te0[102] = 0x66333355
	$Te0[103] = 0x11858594
	$Te0[104] = 0x8A4545CF
	$Te0[105] = 0xE9F9F910
	$Te0[106] = 0x04020206
	$Te0[107] = 0xFE7F7F81
	$Te0[108] = 0xA05050F0
	$Te0[109] = 0x783C3C44
	$Te0[110] = 0x259F9FBA
	$Te0[111] = 0x4BA8A8E3
	$Te0[112] = 0xA25151F3
	$Te0[113] = 0x5DA3A3FE
	$Te0[114] = 0x804040C0
	$Te0[115] = 0x058F8F8A
	$Te0[116] = 0x3F9292AD
	$Te0[117] = 0x219D9DBC
	$Te0[118] = 0x70383848
	$Te0[119] = 0xF1F5F504
	$Te0[120] = 0x63BCBCDF
	$Te0[121] = 0x77B6B6C1
	$Te0[122] = 0xAFDADA75
	$Te0[123] = 0x42212163
	$Te0[124] = 0x20101030
	$Te0[125] = 0xE5FFFF1A
	$Te0[126] = 0xFDF3F30E
	$Te0[127] = 0xBFD2D26D
	$Te0[128] = 0x81CDCD4C
	$Te0[129] = 0x180C0C14
	$Te0[130] = 0x26131335
	$Te0[131] = 0xC3ECEC2F
	$Te0[132] = 0xBE5F5FE1
	$Te0[133] = 0x359797A2
	$Te0[134] = 0x884444CC
	$Te0[135] = 0x2E171739
	$Te0[136] = 0x93C4C457
	$Te0[137] = 0x55A7A7F2
	$Te0[138] = 0xFC7E7E82
	$Te0[139] = 0x7A3D3D47
	$Te0[140] = 0xC86464AC
	$Te0[141] = 0xBA5D5DE7
	$Te0[142] = 0x3219192B
	$Te0[143] = 0xE6737395
	$Te0[144] = 0xC06060A0
	$Te0[145] = 0x19818198
	$Te0[146] = 0x9E4F4FD1
	$Te0[147] = 0xA3DCDC7F
	$Te0[148] = 0x44222266
	$Te0[149] = 0x542A2A7E
	$Te0[150] = 0x3B9090AB
	$Te0[151] = 0x0B888883
	$Te0[152] = 0x8C4646CA
	$Te0[153] = 0xC7EEEE29
	$Te0[154] = 0x6BB8B8D3
	$Te0[155] = 0x2814143C
	$Te0[156] = 0xA7DEDE79
	$Te0[157] = 0xBC5E5EE2
	$Te0[158] = 0x160B0B1D
	$Te0[159] = 0xADDBDB76
	$Te0[160] = 0xDBE0E03B
	$Te0[161] = 0x64323256
	$Te0[162] = 0x743A3A4E
	$Te0[163] = 0x140A0A1E
	$Te0[164] = 0x924949DB
	$Te0[165] = 0x0C06060A
	$Te0[166] = 0x4824246C
	$Te0[167] = 0xB85C5CE4
	$Te0[168] = 0x9FC2C25D
	$Te0[169] = 0xBDD3D36E
	$Te0[170] = 0x43ACACEF
	$Te0[171] = 0xC46262A6
	$Te0[172] = 0x399191A8
	$Te0[173] = 0x319595A4
	$Te0[174] = 0xD3E4E437
	$Te0[175] = 0xF279798B
	$Te0[176] = 0xD5E7E732
	$Te0[177] = 0x8BC8C843
	$Te0[178] = 0x6E373759
	$Te0[179] = 0xDA6D6DB7
	$Te0[180] = 0x018D8D8C
	$Te0[181] = 0xB1D5D564
	$Te0[182] = 0x9C4E4ED2
	$Te0[183] = 0x49A9A9E0
	$Te0[184] = 0xD86C6CB4
	$Te0[185] = 0xAC5656FA
	$Te0[186] = 0xF3F4F407
	$Te0[187] = 0xCFEAEA25
	$Te0[188] = 0xCA6565AF
	$Te0[189] = 0xF47A7A8E
	$Te0[190] = 0x47AEAEE9
	$Te0[191] = 0x10080818
	$Te0[192] = 0x6FBABAD5
	$Te0[193] = 0xF0787888
	$Te0[194] = 0x4A25256F
	$Te0[195] = 0x5C2E2E72
	$Te0[196] = 0x381C1C24
	$Te0[197] = 0x57A6A6F1
	$Te0[198] = 0x73B4B4C7
	$Te0[199] = 0x97C6C651
	$Te0[200] = 0xCBE8E823
	$Te0[201] = 0xA1DDDD7C
	$Te0[202] = 0xE874749C
	$Te0[203] = 0x3E1F1F21
	$Te0[204] = 0x964B4BDD
	$Te0[205] = 0x61BDBDDC
	$Te0[206] = 0x0D8B8B86
	$Te0[207] = 0x0F8A8A85
	$Te0[208] = 0xE0707090
	$Te0[209] = 0x7C3E3E42
	$Te0[210] = 0x71B5B5C4
	$Te0[211] = 0xCC6666AA
	$Te0[212] = 0x904848D8
	$Te0[213] = 0x06030305
	$Te0[214] = 0xF7F6F601
	$Te0[215] = 0x1C0E0E12
	$Te0[216] = 0xC26161A3
	$Te0[217] = 0x6A35355F
	$Te0[218] = 0xAE5757F9
	$Te0[219] = 0x69B9B9D0
	$Te0[220] = 0x17868691
	$Te0[221] = 0x99C1C158
	$Te0[222] = 0x3A1D1D27
	$Te0[223] = 0x279E9EB9
	$Te0[224] = 0xD9E1E138
	$Te0[225] = 0xEBF8F813
	$Te0[226] = 0x2B9898B3
	$Te0[227] = 0x22111133
	$Te0[228] = 0xD26969BB
	$Te0[229] = 0xA9D9D970
	$Te0[230] = 0x078E8E89
	$Te0[231] = 0x339494A7
	$Te0[232] = 0x2D9B9BB6
	$Te0[233] = 0x3C1E1E22
	$Te0[234] = 0x15878792
	$Te0[235] = 0xC9E9E920
	$Te0[236] = 0x87CECE49
	$Te0[237] = 0xAA5555FF
	$Te0[238] = 0x50282878
	$Te0[239] = 0xA5DFDF7A
	$Te0[240] = 0x038C8C8F
	$Te0[241] = 0x59A1A1F8
	$Te0[242] = 0x09898980
	$Te0[243] = 0x1A0D0D17
	$Te0[244] = 0x65BFBFDA
	$Te0[245] = 0xD7E6E631
	$Te0[246] = 0x844242C6
	$Te0[247] = 0xD06868B8
	$Te0[248] = 0x824141C3
	$Te0[249] = 0x299999B0
	$Te0[250] = 0x5A2D2D77
	$Te0[251] = 0x1E0F0F11
	$Te0[252] = 0x7BB0B0CB
	$Te0[253] = 0xA85454FC
	$Te0[254] = 0x6DBBBBD6
	$Te0[255] = 0x2C16163A
	Local $Te1[256]
	$Te1[0] = 0xA5C66363
	$Te1[1] = 0x84F87C7C
	$Te1[2] = 0x99EE7777
	$Te1[3] = 0x8DF67B7B
	$Te1[4] = 0x0DFFF2F2
	$Te1[5] = 0xBDD66B6B
	$Te1[6] = 0xB1DE6F6F
	$Te1[7] = 0x5491C5C5
	$Te1[8] = 0x50603030
	$Te1[9] = 0x03020101
	$Te1[10] = 0xA9CE6767
	$Te1[11] = 0x7D562B2B
	$Te1[12] = 0x19E7FEFE
	$Te1[13] = 0x62B5D7D7
	$Te1[14] = 0xE64DABAB
	$Te1[15] = 0x9AEC7676
	$Te1[16] = 0x458FCACA
	$Te1[17] = 0x9D1F8282
	$Te1[18] = 0x4089C9C9
	$Te1[19] = 0x87FA7D7D
	$Te1[20] = 0x15EFFAFA
	$Te1[21] = 0xEBB25959
	$Te1[22] = 0xC98E4747
	$Te1[23] = 0x0BFBF0F0
	$Te1[24] = 0xEC41ADAD
	$Te1[25] = 0x67B3D4D4
	$Te1[26] = 0xFD5FA2A2
	$Te1[27] = 0xEA45AFAF
	$Te1[28] = 0xBF239C9C
	$Te1[29] = 0xF753A4A4
	$Te1[30] = 0x96E47272
	$Te1[31] = 0x5B9BC0C0
	$Te1[32] = 0xC275B7B7
	$Te1[33] = 0x1CE1FDFD
	$Te1[34] = 0xAE3D9393
	$Te1[35] = 0x6A4C2626
	$Te1[36] = 0x5A6C3636
	$Te1[37] = 0x417E3F3F
	$Te1[38] = 0x02F5F7F7
	$Te1[39] = 0x4F83CCCC
	$Te1[40] = 0x5C683434
	$Te1[41] = 0xF451A5A5
	$Te1[42] = 0x34D1E5E5
	$Te1[43] = 0x08F9F1F1
	$Te1[44] = 0x93E27171
	$Te1[45] = 0x73ABD8D8
	$Te1[46] = 0x53623131
	$Te1[47] = 0x3F2A1515
	$Te1[48] = 0x0C080404
	$Te1[49] = 0x5295C7C7
	$Te1[50] = 0x65462323
	$Te1[51] = 0x5E9DC3C3
	$Te1[52] = 0x28301818
	$Te1[53] = 0xA1379696
	$Te1[54] = 0x0F0A0505
	$Te1[55] = 0xB52F9A9A
	$Te1[56] = 0x090E0707
	$Te1[57] = 0x36241212
	$Te1[58] = 0x9B1B8080
	$Te1[59] = 0x3DDFE2E2
	$Te1[60] = 0x26CDEBEB
	$Te1[61] = 0x694E2727
	$Te1[62] = 0xCD7FB2B2
	$Te1[63] = 0x9FEA7575
	$Te1[64] = 0x1B120909
	$Te1[65] = 0x9E1D8383
	$Te1[66] = 0x74582C2C
	$Te1[67] = 0x2E341A1A
	$Te1[68] = 0x2D361B1B
	$Te1[69] = 0xB2DC6E6E
	$Te1[70] = 0xEEB45A5A
	$Te1[71] = 0xFB5BA0A0
	$Te1[72] = 0xF6A45252
	$Te1[73] = 0x4D763B3B
	$Te1[74] = 0x61B7D6D6
	$Te1[75] = 0xCE7DB3B3
	$Te1[76] = 0x7B522929
	$Te1[77] = 0x3EDDE3E3
	$Te1[78] = 0x715E2F2F
	$Te1[79] = 0x97138484
	$Te1[80] = 0xF5A65353
	$Te1[81] = 0x68B9D1D1
	$Te1[82] = 0x00000000
	$Te1[83] = 0x2CC1EDED
	$Te1[84] = 0x60402020
	$Te1[85] = 0x1FE3FCFC
	$Te1[86] = 0xC879B1B1
	$Te1[87] = 0xEDB65B5B
	$Te1[88] = 0xBED46A6A
	$Te1[89] = 0x468DCBCB
	$Te1[90] = 0xD967BEBE
	$Te1[91] = 0x4B723939
	$Te1[92] = 0xDE944A4A
	$Te1[93] = 0xD4984C4C
	$Te1[94] = 0xE8B05858
	$Te1[95] = 0x4A85CFCF
	$Te1[96] = 0x6BBBD0D0
	$Te1[97] = 0x2AC5EFEF
	$Te1[98] = 0xE54FAAAA
	$Te1[99] = 0x16EDFBFB
	$Te1[100] = 0xC5864343
	$Te1[101] = 0xD79A4D4D
	$Te1[102] = 0x55663333
	$Te1[103] = 0x94118585
	$Te1[104] = 0xCF8A4545
	$Te1[105] = 0x10E9F9F9
	$Te1[106] = 0x06040202
	$Te1[107] = 0x81FE7F7F
	$Te1[108] = 0xF0A05050
	$Te1[109] = 0x44783C3C
	$Te1[110] = 0xBA259F9F
	$Te1[111] = 0xE34BA8A8
	$Te1[112] = 0xF3A25151
	$Te1[113] = 0xFE5DA3A3
	$Te1[114] = 0xC0804040
	$Te1[115] = 0x8A058F8F
	$Te1[116] = 0xAD3F9292
	$Te1[117] = 0xBC219D9D
	$Te1[118] = 0x48703838
	$Te1[119] = 0x04F1F5F5
	$Te1[120] = 0xDF63BCBC
	$Te1[121] = 0xC177B6B6
	$Te1[122] = 0x75AFDADA
	$Te1[123] = 0x63422121
	$Te1[124] = 0x30201010
	$Te1[125] = 0x1AE5FFFF
	$Te1[126] = 0x0EFDF3F3
	$Te1[127] = 0x6DBFD2D2
	$Te1[128] = 0x4C81CDCD
	$Te1[129] = 0x14180C0C
	$Te1[130] = 0x35261313
	$Te1[131] = 0x2FC3ECEC
	$Te1[132] = 0xE1BE5F5F
	$Te1[133] = 0xA2359797
	$Te1[134] = 0xCC884444
	$Te1[135] = 0x392E1717
	$Te1[136] = 0x5793C4C4
	$Te1[137] = 0xF255A7A7
	$Te1[138] = 0x82FC7E7E
	$Te1[139] = 0x477A3D3D
	$Te1[140] = 0xACC86464
	$Te1[141] = 0xE7BA5D5D
	$Te1[142] = 0x2B321919
	$Te1[143] = 0x95E67373
	$Te1[144] = 0xA0C06060
	$Te1[145] = 0x98198181
	$Te1[146] = 0xD19E4F4F
	$Te1[147] = 0x7FA3DCDC
	$Te1[148] = 0x66442222
	$Te1[149] = 0x7E542A2A
	$Te1[150] = 0xAB3B9090
	$Te1[151] = 0x830B8888
	$Te1[152] = 0xCA8C4646
	$Te1[153] = 0x29C7EEEE
	$Te1[154] = 0xD36BB8B8
	$Te1[155] = 0x3C281414
	$Te1[156] = 0x79A7DEDE
	$Te1[157] = 0xE2BC5E5E
	$Te1[158] = 0x1D160B0B
	$Te1[159] = 0x76ADDBDB
	$Te1[160] = 0x3BDBE0E0
	$Te1[161] = 0x56643232
	$Te1[162] = 0x4E743A3A
	$Te1[163] = 0x1E140A0A
	$Te1[164] = 0xDB924949
	$Te1[165] = 0x0A0C0606
	$Te1[166] = 0x6C482424
	$Te1[167] = 0xE4B85C5C
	$Te1[168] = 0x5D9FC2C2
	$Te1[169] = 0x6EBDD3D3
	$Te1[170] = 0xEF43ACAC
	$Te1[171] = 0xA6C46262
	$Te1[172] = 0xA8399191
	$Te1[173] = 0xA4319595
	$Te1[174] = 0x37D3E4E4
	$Te1[175] = 0x8BF27979
	$Te1[176] = 0x32D5E7E7
	$Te1[177] = 0x438BC8C8
	$Te1[178] = 0x596E3737
	$Te1[179] = 0xB7DA6D6D
	$Te1[180] = 0x8C018D8D
	$Te1[181] = 0x64B1D5D5
	$Te1[182] = 0xD29C4E4E
	$Te1[183] = 0xE049A9A9
	$Te1[184] = 0xB4D86C6C
	$Te1[185] = 0xFAAC5656
	$Te1[186] = 0x07F3F4F4
	$Te1[187] = 0x25CFEAEA
	$Te1[188] = 0xAFCA6565
	$Te1[189] = 0x8EF47A7A
	$Te1[190] = 0xE947AEAE
	$Te1[191] = 0x18100808
	$Te1[192] = 0xD56FBABA
	$Te1[193] = 0x88F07878
	$Te1[194] = 0x6F4A2525
	$Te1[195] = 0x725C2E2E
	$Te1[196] = 0x24381C1C
	$Te1[197] = 0xF157A6A6
	$Te1[198] = 0xC773B4B4
	$Te1[199] = 0x5197C6C6
	$Te1[200] = 0x23CBE8E8
	$Te1[201] = 0x7CA1DDDD
	$Te1[202] = 0x9CE87474
	$Te1[203] = 0x213E1F1F
	$Te1[204] = 0xDD964B4B
	$Te1[205] = 0xDC61BDBD
	$Te1[206] = 0x860D8B8B
	$Te1[207] = 0x850F8A8A
	$Te1[208] = 0x90E07070
	$Te1[209] = 0x427C3E3E
	$Te1[210] = 0xC471B5B5
	$Te1[211] = 0xAACC6666
	$Te1[212] = 0xD8904848
	$Te1[213] = 0x05060303
	$Te1[214] = 0x01F7F6F6
	$Te1[215] = 0x121C0E0E
	$Te1[216] = 0xA3C26161
	$Te1[217] = 0x5F6A3535
	$Te1[218] = 0xF9AE5757
	$Te1[219] = 0xD069B9B9
	$Te1[220] = 0x91178686
	$Te1[221] = 0x5899C1C1
	$Te1[222] = 0x273A1D1D
	$Te1[223] = 0xB9279E9E
	$Te1[224] = 0x38D9E1E1
	$Te1[225] = 0x13EBF8F8
	$Te1[226] = 0xB32B9898
	$Te1[227] = 0x33221111
	$Te1[228] = 0xBBD26969
	$Te1[229] = 0x70A9D9D9
	$Te1[230] = 0x89078E8E
	$Te1[231] = 0xA7339494
	$Te1[232] = 0xB62D9B9B
	$Te1[233] = 0x223C1E1E
	$Te1[234] = 0x92158787
	$Te1[235] = 0x20C9E9E9
	$Te1[236] = 0x4987CECE
	$Te1[237] = 0xFFAA5555
	$Te1[238] = 0x78502828
	$Te1[239] = 0x7AA5DFDF
	$Te1[240] = 0x8F038C8C
	$Te1[241] = 0xF859A1A1
	$Te1[242] = 0x80098989
	$Te1[243] = 0x171A0D0D
	$Te1[244] = 0xDA65BFBF
	$Te1[245] = 0x31D7E6E6
	$Te1[246] = 0xC6844242
	$Te1[247] = 0xB8D06868
	$Te1[248] = 0xC3824141
	$Te1[249] = 0xB0299999
	$Te1[250] = 0x775A2D2D
	$Te1[251] = 0x111E0F0F
	$Te1[252] = 0xCB7BB0B0
	$Te1[253] = 0xFCA85454
	$Te1[254] = 0xD66DBBBB
	$Te1[255] = 0x3A2C1616
	Local $Te2[256]
	$Te2[0] = 0x63A5C663
	$Te2[1] = 0x7C84F87C
	$Te2[2] = 0x7799EE77
	$Te2[3] = 0x7B8DF67B
	$Te2[4] = 0xF20DFFF2
	$Te2[5] = 0x6BBDD66B
	$Te2[6] = 0x6FB1DE6F
	$Te2[7] = 0xC55491C5
	$Te2[8] = 0x30506030
	$Te2[9] = 0x01030201
	$Te2[10] = 0x67A9CE67
	$Te2[11] = 0x2B7D562B
	$Te2[12] = 0xFE19E7FE
	$Te2[13] = 0xD762B5D7
	$Te2[14] = 0xABE64DAB
	$Te2[15] = 0x769AEC76
	$Te2[16] = 0xCA458FCA
	$Te2[17] = 0x829D1F82
	$Te2[18] = 0xC94089C9
	$Te2[19] = 0x7D87FA7D
	$Te2[20] = 0xFA15EFFA
	$Te2[21] = 0x59EBB259
	$Te2[22] = 0x47C98E47
	$Te2[23] = 0xF00BFBF0
	$Te2[24] = 0xADEC41AD
	$Te2[25] = 0xD467B3D4
	$Te2[26] = 0xA2FD5FA2
	$Te2[27] = 0xAFEA45AF
	$Te2[28] = 0x9CBF239C
	$Te2[29] = 0xA4F753A4
	$Te2[30] = 0x7296E472
	$Te2[31] = 0xC05B9BC0
	$Te2[32] = 0xB7C275B7
	$Te2[33] = 0xFD1CE1FD
	$Te2[34] = 0x93AE3D93
	$Te2[35] = 0x266A4C26
	$Te2[36] = 0x365A6C36
	$Te2[37] = 0x3F417E3F
	$Te2[38] = 0xF702F5F7
	$Te2[39] = 0xCC4F83CC
	$Te2[40] = 0x345C6834
	$Te2[41] = 0xA5F451A5
	$Te2[42] = 0xE534D1E5
	$Te2[43] = 0xF108F9F1
	$Te2[44] = 0x7193E271
	$Te2[45] = 0xD873ABD8
	$Te2[46] = 0x31536231
	$Te2[47] = 0x153F2A15
	$Te2[48] = 0x040C0804
	$Te2[49] = 0xC75295C7
	$Te2[50] = 0x23654623
	$Te2[51] = 0xC35E9DC3
	$Te2[52] = 0x18283018
	$Te2[53] = 0x96A13796
	$Te2[54] = 0x050F0A05
	$Te2[55] = 0x9AB52F9A
	$Te2[56] = 0x07090E07
	$Te2[57] = 0x12362412
	$Te2[58] = 0x809B1B80
	$Te2[59] = 0xE23DDFE2
	$Te2[60] = 0xEB26CDEB
	$Te2[61] = 0x27694E27
	$Te2[62] = 0xB2CD7FB2
	$Te2[63] = 0x759FEA75
	$Te2[64] = 0x091B1209
	$Te2[65] = 0x839E1D83
	$Te2[66] = 0x2C74582C
	$Te2[67] = 0x1A2E341A
	$Te2[68] = 0x1B2D361B
	$Te2[69] = 0x6EB2DC6E
	$Te2[70] = 0x5AEEB45A
	$Te2[71] = 0xA0FB5BA0
	$Te2[72] = 0x52F6A452
	$Te2[73] = 0x3B4D763B
	$Te2[74] = 0xD661B7D6
	$Te2[75] = 0xB3CE7DB3
	$Te2[76] = 0x297B5229
	$Te2[77] = 0xE33EDDE3
	$Te2[78] = 0x2F715E2F
	$Te2[79] = 0x84971384
	$Te2[80] = 0x53F5A653
	$Te2[81] = 0xD168B9D1
	$Te2[82] = 0x00000000
	$Te2[83] = 0xED2CC1ED
	$Te2[84] = 0x20604020
	$Te2[85] = 0xFC1FE3FC
	$Te2[86] = 0xB1C879B1
	$Te2[87] = 0x5BEDB65B
	$Te2[88] = 0x6ABED46A
	$Te2[89] = 0xCB468DCB
	$Te2[90] = 0xBED967BE
	$Te2[91] = 0x394B7239
	$Te2[92] = 0x4ADE944A
	$Te2[93] = 0x4CD4984C
	$Te2[94] = 0x58E8B058
	$Te2[95] = 0xCF4A85CF
	$Te2[96] = 0xD06BBBD0
	$Te2[97] = 0xEF2AC5EF
	$Te2[98] = 0xAAE54FAA
	$Te2[99] = 0xFB16EDFB
	$Te2[100] = 0x43C58643
	$Te2[101] = 0x4DD79A4D
	$Te2[102] = 0x33556633
	$Te2[103] = 0x85941185
	$Te2[104] = 0x45CF8A45
	$Te2[105] = 0xF910E9F9
	$Te2[106] = 0x02060402
	$Te2[107] = 0x7F81FE7F
	$Te2[108] = 0x50F0A050
	$Te2[109] = 0x3C44783C
	$Te2[110] = 0x9FBA259F
	$Te2[111] = 0xA8E34BA8
	$Te2[112] = 0x51F3A251
	$Te2[113] = 0xA3FE5DA3
	$Te2[114] = 0x40C08040
	$Te2[115] = 0x8F8A058F
	$Te2[116] = 0x92AD3F92
	$Te2[117] = 0x9DBC219D
	$Te2[118] = 0x38487038
	$Te2[119] = 0xF504F1F5
	$Te2[120] = 0xBCDF63BC
	$Te2[121] = 0xB6C177B6
	$Te2[122] = 0xDA75AFDA
	$Te2[123] = 0x21634221
	$Te2[124] = 0x10302010
	$Te2[125] = 0xFF1AE5FF
	$Te2[126] = 0xF30EFDF3
	$Te2[127] = 0xD26DBFD2
	$Te2[128] = 0xCD4C81CD
	$Te2[129] = 0x0C14180C
	$Te2[130] = 0x13352613
	$Te2[131] = 0xEC2FC3EC
	$Te2[132] = 0x5FE1BE5F
	$Te2[133] = 0x97A23597
	$Te2[134] = 0x44CC8844
	$Te2[135] = 0x17392E17
	$Te2[136] = 0xC45793C4
	$Te2[137] = 0xA7F255A7
	$Te2[138] = 0x7E82FC7E
	$Te2[139] = 0x3D477A3D
	$Te2[140] = 0x64ACC864
	$Te2[141] = 0x5DE7BA5D
	$Te2[142] = 0x192B3219
	$Te2[143] = 0x7395E673
	$Te2[144] = 0x60A0C060
	$Te2[145] = 0x81981981
	$Te2[146] = 0x4FD19E4F
	$Te2[147] = 0xDC7FA3DC
	$Te2[148] = 0x22664422
	$Te2[149] = 0x2A7E542A
	$Te2[150] = 0x90AB3B90
	$Te2[151] = 0x88830B88
	$Te2[152] = 0x46CA8C46
	$Te2[153] = 0xEE29C7EE
	$Te2[154] = 0xB8D36BB8
	$Te2[155] = 0x143C2814
	$Te2[156] = 0xDE79A7DE
	$Te2[157] = 0x5EE2BC5E
	$Te2[158] = 0x0B1D160B
	$Te2[159] = 0xDB76ADDB
	$Te2[160] = 0xE03BDBE0
	$Te2[161] = 0x32566432
	$Te2[162] = 0x3A4E743A
	$Te2[163] = 0x0A1E140A
	$Te2[164] = 0x49DB9249
	$Te2[165] = 0x060A0C06
	$Te2[166] = 0x246C4824
	$Te2[167] = 0x5CE4B85C
	$Te2[168] = 0xC25D9FC2
	$Te2[169] = 0xD36EBDD3
	$Te2[170] = 0xACEF43AC
	$Te2[171] = 0x62A6C462
	$Te2[172] = 0x91A83991
	$Te2[173] = 0x95A43195
	$Te2[174] = 0xE437D3E4
	$Te2[175] = 0x798BF279
	$Te2[176] = 0xE732D5E7
	$Te2[177] = 0xC8438BC8
	$Te2[178] = 0x37596E37
	$Te2[179] = 0x6DB7DA6D
	$Te2[180] = 0x8D8C018D
	$Te2[181] = 0xD564B1D5
	$Te2[182] = 0x4ED29C4E
	$Te2[183] = 0xA9E049A9
	$Te2[184] = 0x6CB4D86C
	$Te2[185] = 0x56FAAC56
	$Te2[186] = 0xF407F3F4
	$Te2[187] = 0xEA25CFEA
	$Te2[188] = 0x65AFCA65
	$Te2[189] = 0x7A8EF47A
	$Te2[190] = 0xAEE947AE
	$Te2[191] = 0x08181008
	$Te2[192] = 0xBAD56FBA
	$Te2[193] = 0x7888F078
	$Te2[194] = 0x256F4A25
	$Te2[195] = 0x2E725C2E
	$Te2[196] = 0x1C24381C
	$Te2[197] = 0xA6F157A6
	$Te2[198] = 0xB4C773B4
	$Te2[199] = 0xC65197C6
	$Te2[200] = 0xE823CBE8
	$Te2[201] = 0xDD7CA1DD
	$Te2[202] = 0x749CE874
	$Te2[203] = 0x1F213E1F
	$Te2[204] = 0x4BDD964B
	$Te2[205] = 0xBDDC61BD
	$Te2[206] = 0x8B860D8B
	$Te2[207] = 0x8A850F8A
	$Te2[208] = 0x7090E070
	$Te2[209] = 0x3E427C3E
	$Te2[210] = 0xB5C471B5
	$Te2[211] = 0x66AACC66
	$Te2[212] = 0x48D89048
	$Te2[213] = 0x03050603
	$Te2[214] = 0xF601F7F6
	$Te2[215] = 0x0E121C0E
	$Te2[216] = 0x61A3C261
	$Te2[217] = 0x355F6A35
	$Te2[218] = 0x57F9AE57
	$Te2[219] = 0xB9D069B9
	$Te2[220] = 0x86911786
	$Te2[221] = 0xC15899C1
	$Te2[222] = 0x1D273A1D
	$Te2[223] = 0x9EB9279E
	$Te2[224] = 0xE138D9E1
	$Te2[225] = 0xF813EBF8
	$Te2[226] = 0x98B32B98
	$Te2[227] = 0x11332211
	$Te2[228] = 0x69BBD269
	$Te2[229] = 0xD970A9D9
	$Te2[230] = 0x8E89078E
	$Te2[231] = 0x94A73394
	$Te2[232] = 0x9BB62D9B
	$Te2[233] = 0x1E223C1E
	$Te2[234] = 0x87921587
	$Te2[235] = 0xE920C9E9
	$Te2[236] = 0xCE4987CE
	$Te2[237] = 0x55FFAA55
	$Te2[238] = 0x28785028
	$Te2[239] = 0xDF7AA5DF
	$Te2[240] = 0x8C8F038C
	$Te2[241] = 0xA1F859A1
	$Te2[242] = 0x89800989
	$Te2[243] = 0x0D171A0D
	$Te2[244] = 0xBFDA65BF
	$Te2[245] = 0xE631D7E6
	$Te2[246] = 0x42C68442
	$Te2[247] = 0x68B8D068
	$Te2[248] = 0x41C38241
	$Te2[249] = 0x99B02999
	$Te2[250] = 0x2D775A2D
	$Te2[251] = 0x0F111E0F
	$Te2[252] = 0xB0CB7BB0
	$Te2[253] = 0x54FCA854
	$Te2[254] = 0xBBD66DBB
	$Te2[255] = 0x163A2C16
	Local $Te3[256]
	$Te3[0] = 0x6363A5C6
	$Te3[1] = 0x7C7C84F8
	$Te3[2] = 0x777799EE
	$Te3[3] = 0x7B7B8DF6
	$Te3[4] = 0xF2F20DFF
	$Te3[5] = 0x6B6BBDD6
	$Te3[6] = 0x6F6FB1DE
	$Te3[7] = 0xC5C55491
	$Te3[8] = 0x30305060
	$Te3[9] = 0x01010302
	$Te3[10] = 0x6767A9CE
	$Te3[11] = 0x2B2B7D56
	$Te3[12] = 0xFEFE19E7
	$Te3[13] = 0xD7D762B5
	$Te3[14] = 0xABABE64D
	$Te3[15] = 0x76769AEC
	$Te3[16] = 0xCACA458F
	$Te3[17] = 0x82829D1F
	$Te3[18] = 0xC9C94089
	$Te3[19] = 0x7D7D87FA
	$Te3[20] = 0xFAFA15EF
	$Te3[21] = 0x5959EBB2
	$Te3[22] = 0x4747C98E
	$Te3[23] = 0xF0F00BFB
	$Te3[24] = 0xADADEC41
	$Te3[25] = 0xD4D467B3
	$Te3[26] = 0xA2A2FD5F
	$Te3[27] = 0xAFAFEA45
	$Te3[28] = 0x9C9CBF23
	$Te3[29] = 0xA4A4F753
	$Te3[30] = 0x727296E4
	$Te3[31] = 0xC0C05B9B
	$Te3[32] = 0xB7B7C275
	$Te3[33] = 0xFDFD1CE1
	$Te3[34] = 0x9393AE3D
	$Te3[35] = 0x26266A4C
	$Te3[36] = 0x36365A6C
	$Te3[37] = 0x3F3F417E
	$Te3[38] = 0xF7F702F5
	$Te3[39] = 0xCCCC4F83
	$Te3[40] = 0x34345C68
	$Te3[41] = 0xA5A5F451
	$Te3[42] = 0xE5E534D1
	$Te3[43] = 0xF1F108F9
	$Te3[44] = 0x717193E2
	$Te3[45] = 0xD8D873AB
	$Te3[46] = 0x31315362
	$Te3[47] = 0x15153F2A
	$Te3[48] = 0x04040C08
	$Te3[49] = 0xC7C75295
	$Te3[50] = 0x23236546
	$Te3[51] = 0xC3C35E9D
	$Te3[52] = 0x18182830
	$Te3[53] = 0x9696A137
	$Te3[54] = 0x05050F0A
	$Te3[55] = 0x9A9AB52F
	$Te3[56] = 0x0707090E
	$Te3[57] = 0x12123624
	$Te3[58] = 0x80809B1B
	$Te3[59] = 0xE2E23DDF
	$Te3[60] = 0xEBEB26CD
	$Te3[61] = 0x2727694E
	$Te3[62] = 0xB2B2CD7F
	$Te3[63] = 0x75759FEA
	$Te3[64] = 0x09091B12
	$Te3[65] = 0x83839E1D
	$Te3[66] = 0x2C2C7458
	$Te3[67] = 0x1A1A2E34
	$Te3[68] = 0x1B1B2D36
	$Te3[69] = 0x6E6EB2DC
	$Te3[70] = 0x5A5AEEB4
	$Te3[71] = 0xA0A0FB5B
	$Te3[72] = 0x5252F6A4
	$Te3[73] = 0x3B3B4D76
	$Te3[74] = 0xD6D661B7
	$Te3[75] = 0xB3B3CE7D
	$Te3[76] = 0x29297B52
	$Te3[77] = 0xE3E33EDD
	$Te3[78] = 0x2F2F715E
	$Te3[79] = 0x84849713
	$Te3[80] = 0x5353F5A6
	$Te3[81] = 0xD1D168B9
	$Te3[82] = 0x00000000
	$Te3[83] = 0xEDED2CC1
	$Te3[84] = 0x20206040
	$Te3[85] = 0xFCFC1FE3
	$Te3[86] = 0xB1B1C879
	$Te3[87] = 0x5B5BEDB6
	$Te3[88] = 0x6A6ABED4
	$Te3[89] = 0xCBCB468D
	$Te3[90] = 0xBEBED967
	$Te3[91] = 0x39394B72
	$Te3[92] = 0x4A4ADE94
	$Te3[93] = 0x4C4CD498
	$Te3[94] = 0x5858E8B0
	$Te3[95] = 0xCFCF4A85
	$Te3[96] = 0xD0D06BBB
	$Te3[97] = 0xEFEF2AC5
	$Te3[98] = 0xAAAAE54F
	$Te3[99] = 0xFBFB16ED
	$Te3[100] = 0x4343C586
	$Te3[101] = 0x4D4DD79A
	$Te3[102] = 0x33335566
	$Te3[103] = 0x85859411
	$Te3[104] = 0x4545CF8A
	$Te3[105] = 0xF9F910E9
	$Te3[106] = 0x02020604
	$Te3[107] = 0x7F7F81FE
	$Te3[108] = 0x5050F0A0
	$Te3[109] = 0x3C3C4478
	$Te3[110] = 0x9F9FBA25
	$Te3[111] = 0xA8A8E34B
	$Te3[112] = 0x5151F3A2
	$Te3[113] = 0xA3A3FE5D
	$Te3[114] = 0x4040C080
	$Te3[115] = 0x8F8F8A05
	$Te3[116] = 0x9292AD3F
	$Te3[117] = 0x9D9DBC21
	$Te3[118] = 0x38384870
	$Te3[119] = 0xF5F504F1
	$Te3[120] = 0xBCBCDF63
	$Te3[121] = 0xB6B6C177
	$Te3[122] = 0xDADA75AF
	$Te3[123] = 0x21216342
	$Te3[124] = 0x10103020
	$Te3[125] = 0xFFFF1AE5
	$Te3[126] = 0xF3F30EFD
	$Te3[127] = 0xD2D26DBF
	$Te3[128] = 0xCDCD4C81
	$Te3[129] = 0x0C0C1418
	$Te3[130] = 0x13133526
	$Te3[131] = 0xECEC2FC3
	$Te3[132] = 0x5F5FE1BE
	$Te3[133] = 0x9797A235
	$Te3[134] = 0x4444CC88
	$Te3[135] = 0x1717392E
	$Te3[136] = 0xC4C45793
	$Te3[137] = 0xA7A7F255
	$Te3[138] = 0x7E7E82FC
	$Te3[139] = 0x3D3D477A
	$Te3[140] = 0x6464ACC8
	$Te3[141] = 0x5D5DE7BA
	$Te3[142] = 0x19192B32
	$Te3[143] = 0x737395E6
	$Te3[144] = 0x6060A0C0
	$Te3[145] = 0x81819819
	$Te3[146] = 0x4F4FD19E
	$Te3[147] = 0xDCDC7FA3
	$Te3[148] = 0x22226644
	$Te3[149] = 0x2A2A7E54
	$Te3[150] = 0x9090AB3B
	$Te3[151] = 0x8888830B
	$Te3[152] = 0x4646CA8C
	$Te3[153] = 0xEEEE29C7
	$Te3[154] = 0xB8B8D36B
	$Te3[155] = 0x14143C28
	$Te3[156] = 0xDEDE79A7
	$Te3[157] = 0x5E5EE2BC
	$Te3[158] = 0x0B0B1D16
	$Te3[159] = 0xDBDB76AD
	$Te3[160] = 0xE0E03BDB
	$Te3[161] = 0x32325664
	$Te3[162] = 0x3A3A4E74
	$Te3[163] = 0x0A0A1E14
	$Te3[164] = 0x4949DB92
	$Te3[165] = 0x06060A0C
	$Te3[166] = 0x24246C48
	$Te3[167] = 0x5C5CE4B8
	$Te3[168] = 0xC2C25D9F
	$Te3[169] = 0xD3D36EBD
	$Te3[170] = 0xACACEF43
	$Te3[171] = 0x6262A6C4
	$Te3[172] = 0x9191A839
	$Te3[173] = 0x9595A431
	$Te3[174] = 0xE4E437D3
	$Te3[175] = 0x79798BF2
	$Te3[176] = 0xE7E732D5
	$Te3[177] = 0xC8C8438B
	$Te3[178] = 0x3737596E
	$Te3[179] = 0x6D6DB7DA
	$Te3[180] = 0x8D8D8C01
	$Te3[181] = 0xD5D564B1
	$Te3[182] = 0x4E4ED29C
	$Te3[183] = 0xA9A9E049
	$Te3[184] = 0x6C6CB4D8
	$Te3[185] = 0x5656FAAC
	$Te3[186] = 0xF4F407F3
	$Te3[187] = 0xEAEA25CF
	$Te3[188] = 0x6565AFCA
	$Te3[189] = 0x7A7A8EF4
	$Te3[190] = 0xAEAEE947
	$Te3[191] = 0x08081810
	$Te3[192] = 0xBABAD56F
	$Te3[193] = 0x787888F0
	$Te3[194] = 0x25256F4A
	$Te3[195] = 0x2E2E725C
	$Te3[196] = 0x1C1C2438
	$Te3[197] = 0xA6A6F157
	$Te3[198] = 0xB4B4C773
	$Te3[199] = 0xC6C65197
	$Te3[200] = 0xE8E823CB
	$Te3[201] = 0xDDDD7CA1
	$Te3[202] = 0x74749CE8
	$Te3[203] = 0x1F1F213E
	$Te3[204] = 0x4B4BDD96
	$Te3[205] = 0xBDBDDC61
	$Te3[206] = 0x8B8B860D
	$Te3[207] = 0x8A8A850F
	$Te3[208] = 0x707090E0
	$Te3[209] = 0x3E3E427C
	$Te3[210] = 0xB5B5C471
	$Te3[211] = 0x6666AACC
	$Te3[212] = 0x4848D890
	$Te3[213] = 0x03030506
	$Te3[214] = 0xF6F601F7
	$Te3[215] = 0x0E0E121C
	$Te3[216] = 0x6161A3C2
	$Te3[217] = 0x35355F6A
	$Te3[218] = 0x5757F9AE
	$Te3[219] = 0xB9B9D069
	$Te3[220] = 0x86869117
	$Te3[221] = 0xC1C15899
	$Te3[222] = 0x1D1D273A
	$Te3[223] = 0x9E9EB927
	$Te3[224] = 0xE1E138D9
	$Te3[225] = 0xF8F813EB
	$Te3[226] = 0x9898B32B
	$Te3[227] = 0x11113322
	$Te3[228] = 0x6969BBD2
	$Te3[229] = 0xD9D970A9
	$Te3[230] = 0x8E8E8907
	$Te3[231] = 0x9494A733
	$Te3[232] = 0x9B9BB62D
	$Te3[233] = 0x1E1E223C
	$Te3[234] = 0x87879215
	$Te3[235] = 0xE9E920C9
	$Te3[236] = 0xCECE4987
	$Te3[237] = 0x5555FFAA
	$Te3[238] = 0x28287850
	$Te3[239] = 0xDFDF7AA5
	$Te3[240] = 0x8C8C8F03
	$Te3[241] = 0xA1A1F859
	$Te3[242] = 0x89898009
	$Te3[243] = 0x0D0D171A
	$Te3[244] = 0xBFBFDA65
	$Te3[245] = 0xE6E631D7
	$Te3[246] = 0x4242C684
	$Te3[247] = 0x6868B8D0
	$Te3[248] = 0x4141C382
	$Te3[249] = 0x9999B029
	$Te3[250] = 0x2D2D775A
	$Te3[251] = 0x0F0F111E
	$Te3[252] = 0xB0B0CB7B
	$Te3[253] = 0x5454FCA8
	$Te3[254] = 0xBBBBD66D
	$Te3[255] = 0x16163A2C
	Local $Te4[256]
	$Te4[0] = 0x63636363
	$Te4[1] = 0x7C7C7C7C
	$Te4[2] = 0x77777777
	$Te4[3] = 0x7B7B7B7B
	$Te4[4] = 0xF2F2F2F2
	$Te4[5] = 0x6B6B6B6B
	$Te4[6] = 0x6F6F6F6F
	$Te4[7] = 0xC5C5C5C5
	$Te4[8] = 0x30303030
	$Te4[9] = 0x01010101
	$Te4[10] = 0x67676767
	$Te4[11] = 0x2B2B2B2B
	$Te4[12] = 0xFEFEFEFE
	$Te4[13] = 0xD7D7D7D7
	$Te4[14] = 0xABABABAB
	$Te4[15] = 0x76767676
	$Te4[16] = 0xCACACACA
	$Te4[17] = 0x82828282
	$Te4[18] = 0xC9C9C9C9
	$Te4[19] = 0x7D7D7D7D
	$Te4[20] = 0xFAFAFAFA
	$Te4[21] = 0x59595959
	$Te4[22] = 0x47474747
	$Te4[23] = 0xF0F0F0F0
	$Te4[24] = 0xADADADAD
	$Te4[25] = 0xD4D4D4D4
	$Te4[26] = 0xA2A2A2A2
	$Te4[27] = 0xAFAFAFAF
	$Te4[28] = 0x9C9C9C9C
	$Te4[29] = 0xA4A4A4A4
	$Te4[30] = 0x72727272
	$Te4[31] = 0xC0C0C0C0
	$Te4[32] = 0xB7B7B7B7
	$Te4[33] = 0xFDFDFDFD
	$Te4[34] = 0x93939393
	$Te4[35] = 0x26262626
	$Te4[36] = 0x36363636
	$Te4[37] = 0x3F3F3F3F
	$Te4[38] = 0xF7F7F7F7
	$Te4[39] = 0xCCCCCCCC
	$Te4[40] = 0x34343434
	$Te4[41] = 0xA5A5A5A5
	$Te4[42] = 0xE5E5E5E5
	$Te4[43] = 0xF1F1F1F1
	$Te4[44] = 0x71717171
	$Te4[45] = 0xD8D8D8D8
	$Te4[46] = 0x31313131
	$Te4[47] = 0x15151515
	$Te4[48] = 0x04040404
	$Te4[49] = 0xC7C7C7C7
	$Te4[50] = 0x23232323
	$Te4[51] = 0xC3C3C3C3
	$Te4[52] = 0x18181818
	$Te4[53] = 0x96969696
	$Te4[54] = 0x05050505
	$Te4[55] = 0x9A9A9A9A
	$Te4[56] = 0x07070707
	$Te4[57] = 0x12121212
	$Te4[58] = 0x80808080
	$Te4[59] = 0xE2E2E2E2
	$Te4[60] = 0xEBEBEBEB
	$Te4[61] = 0x27272727
	$Te4[62] = 0xB2B2B2B2
	$Te4[63] = 0x75757575
	$Te4[64] = 0x09090909
	$Te4[65] = 0x83838383
	$Te4[66] = 0x2C2C2C2C
	$Te4[67] = 0x1A1A1A1A
	$Te4[68] = 0x1B1B1B1B
	$Te4[69] = 0x6E6E6E6E
	$Te4[70] = 0x5A5A5A5A
	$Te4[71] = 0xA0A0A0A0
	$Te4[72] = 0x52525252
	$Te4[73] = 0x3B3B3B3B
	$Te4[74] = 0xD6D6D6D6
	$Te4[75] = 0xB3B3B3B3
	$Te4[76] = 0x29292929
	$Te4[77] = 0xE3E3E3E3
	$Te4[78] = 0x2F2F2F2F
	$Te4[79] = 0x84848484
	$Te4[80] = 0x53535353
	$Te4[81] = 0xD1D1D1D1
	$Te4[82] = 0x00000000
	$Te4[83] = 0xEDEDEDED
	$Te4[84] = 0x20202020
	$Te4[85] = 0xFCFCFCFC
	$Te4[86] = 0xB1B1B1B1
	$Te4[87] = 0x5B5B5B5B
	$Te4[88] = 0x6A6A6A6A
	$Te4[89] = 0xCBCBCBCB
	$Te4[90] = 0xBEBEBEBE
	$Te4[91] = 0x39393939
	$Te4[92] = 0x4A4A4A4A
	$Te4[93] = 0x4C4C4C4C
	$Te4[94] = 0x58585858
	$Te4[95] = 0xCFCFCFCF
	$Te4[96] = 0xD0D0D0D0
	$Te4[97] = 0xEFEFEFEF
	$Te4[98] = 0xAAAAAAAA
	$Te4[99] = 0xFBFBFBFB
	$Te4[100] = 0x43434343
	$Te4[101] = 0x4D4D4D4D
	$Te4[102] = 0x33333333
	$Te4[103] = 0x85858585
	$Te4[104] = 0x45454545
	$Te4[105] = 0xF9F9F9F9
	$Te4[106] = 0x02020202
	$Te4[107] = 0x7F7F7F7F
	$Te4[108] = 0x50505050
	$Te4[109] = 0x3C3C3C3C
	$Te4[110] = 0x9F9F9F9F
	$Te4[111] = 0xA8A8A8A8
	$Te4[112] = 0x51515151
	$Te4[113] = 0xA3A3A3A3
	$Te4[114] = 0x40404040
	$Te4[115] = 0x8F8F8F8F
	$Te4[116] = 0x92929292
	$Te4[117] = 0x9D9D9D9D
	$Te4[118] = 0x38383838
	$Te4[119] = 0xF5F5F5F5
	$Te4[120] = 0xBCBCBCBC
	$Te4[121] = 0xB6B6B6B6
	$Te4[122] = 0xDADADADA
	$Te4[123] = 0x21212121
	$Te4[124] = 0x10101010
	$Te4[125] = 0xFFFFFFFF
	$Te4[126] = 0xF3F3F3F3
	$Te4[127] = 0xD2D2D2D2
	$Te4[128] = 0xCDCDCDCD
	$Te4[129] = 0x0C0C0C0C
	$Te4[130] = 0x13131313
	$Te4[131] = 0xECECECEC
	$Te4[132] = 0x5F5F5F5F
	$Te4[133] = 0x97979797
	$Te4[134] = 0x44444444
	$Te4[135] = 0x17171717
	$Te4[136] = 0xC4C4C4C4
	$Te4[137] = 0xA7A7A7A7
	$Te4[138] = 0x7E7E7E7E
	$Te4[139] = 0x3D3D3D3D
	$Te4[140] = 0x64646464
	$Te4[141] = 0x5D5D5D5D
	$Te4[142] = 0x19191919
	$Te4[143] = 0x73737373
	$Te4[144] = 0x60606060
	$Te4[145] = 0x81818181
	$Te4[146] = 0x4F4F4F4F
	$Te4[147] = 0xDCDCDCDC
	$Te4[148] = 0x22222222
	$Te4[149] = 0x2A2A2A2A
	$Te4[150] = 0x90909090
	$Te4[151] = 0x88888888
	$Te4[152] = 0x46464646
	$Te4[153] = 0xEEEEEEEE
	$Te4[154] = 0xB8B8B8B8
	$Te4[155] = 0x14141414
	$Te4[156] = 0xDEDEDEDE
	$Te4[157] = 0x5E5E5E5E
	$Te4[158] = 0x0B0B0B0B
	$Te4[159] = 0xDBDBDBDB
	$Te4[160] = 0xE0E0E0E0
	$Te4[161] = 0x32323232
	$Te4[162] = 0x3A3A3A3A
	$Te4[163] = 0x0A0A0A0A
	$Te4[164] = 0x49494949
	$Te4[165] = 0x06060606
	$Te4[166] = 0x24242424
	$Te4[167] = 0x5C5C5C5C
	$Te4[168] = 0xC2C2C2C2
	$Te4[169] = 0xD3D3D3D3
	$Te4[170] = 0xACACACAC
	$Te4[171] = 0x62626262
	$Te4[172] = 0x91919191
	$Te4[173] = 0x95959595
	$Te4[174] = 0xE4E4E4E4
	$Te4[175] = 0x79797979
	$Te4[176] = 0xE7E7E7E7
	$Te4[177] = 0xC8C8C8C8
	$Te4[178] = 0x37373737
	$Te4[179] = 0x6D6D6D6D
	$Te4[180] = 0x8D8D8D8D
	$Te4[181] = 0xD5D5D5D5
	$Te4[182] = 0x4E4E4E4E
	$Te4[183] = 0xA9A9A9A9
	$Te4[184] = 0x6C6C6C6C
	$Te4[185] = 0x56565656
	$Te4[186] = 0xF4F4F4F4
	$Te4[187] = 0xEAEAEAEA
	$Te4[188] = 0x65656565
	$Te4[189] = 0x7A7A7A7A
	$Te4[190] = 0xAEAEAEAE
	$Te4[191] = 0x08080808
	$Te4[192] = 0xBABABABA
	$Te4[193] = 0x78787878
	$Te4[194] = 0x25252525
	$Te4[195] = 0x2E2E2E2E
	$Te4[196] = 0x1C1C1C1C
	$Te4[197] = 0xA6A6A6A6
	$Te4[198] = 0xB4B4B4B4
	$Te4[199] = 0xC6C6C6C6
	$Te4[200] = 0xE8E8E8E8
	$Te4[201] = 0xDDDDDDDD
	$Te4[202] = 0x74747474
	$Te4[203] = 0x1F1F1F1F
	$Te4[204] = 0x4B4B4B4B
	$Te4[205] = 0xBDBDBDBD
	$Te4[206] = 0x8B8B8B8B
	$Te4[207] = 0x8A8A8A8A
	$Te4[208] = 0x70707070
	$Te4[209] = 0x3E3E3E3E
	$Te4[210] = 0xB5B5B5B5
	$Te4[211] = 0x66666666
	$Te4[212] = 0x48484848
	$Te4[213] = 0x03030303
	$Te4[214] = 0xF6F6F6F6
	$Te4[215] = 0x0E0E0E0E
	$Te4[216] = 0x61616161
	$Te4[217] = 0x35353535
	$Te4[218] = 0x57575757
	$Te4[219] = 0xB9B9B9B9
	$Te4[220] = 0x86868686
	$Te4[221] = 0xC1C1C1C1
	$Te4[222] = 0x1D1D1D1D
	$Te4[223] = 0x9E9E9E9E
	$Te4[224] = 0xE1E1E1E1
	$Te4[225] = 0xF8F8F8F8
	$Te4[226] = 0x98989898
	$Te4[227] = 0x11111111
	$Te4[228] = 0x69696969
	$Te4[229] = 0xD9D9D9D9
	$Te4[230] = 0x8E8E8E8E
	$Te4[231] = 0x94949494
	$Te4[232] = 0x9B9B9B9B
	$Te4[233] = 0x1E1E1E1E
	$Te4[234] = 0x87878787
	$Te4[235] = 0xE9E9E9E9
	$Te4[236] = 0xCECECECE
	$Te4[237] = 0x55555555
	$Te4[238] = 0x28282828
	$Te4[239] = 0xDFDFDFDF
	$Te4[240] = 0x8C8C8C8C
	$Te4[241] = 0xA1A1A1A1
	$Te4[242] = 0x89898989
	$Te4[243] = 0x0D0D0D0D
	$Te4[244] = 0xBFBFBFBF
	$Te4[245] = 0xE6E6E6E6
	$Te4[246] = 0x42424242
	$Te4[247] = 0x68686868
	$Te4[248] = 0x41414141
	$Te4[249] = 0x99999999
	$Te4[250] = 0x2D2D2D2D
	$Te4[251] = 0x0F0F0F0F
	$Te4[252] = 0xB0B0B0B0
	$Te4[253] = 0x54545454
	$Te4[254] = 0xBBBBBBBB
	$Te4[255] = 0x16161616
	Local $t[$Nb]
	Local $keypos = 0
	If $Nb < 8 Then
		Local $C[4] = [0, 1, 2, 3]
	Else
		Local $C[4] = [0, 1, 3, 4]
	EndIf

	For $i = 0 To $Nb - 1
		$S[$i] = BitXOR($S[$i], $w[$keypos]) ; The Initial Round Key
		$keypos += 1
	Next

	For $i = 1 To $Nr - 1
		$t = $S

		For $j = 0 To $Nb - 1
			$S[$j] = BitXOR($Te0[BitAND(BitShift($t[Mod($j + $C[0], $Nb)], 24), 0xFF)], $Te1[BitAND(BitShift($t[Mod($j + $C[1], $Nb)], 16), 0xFF)], $Te2[BitAND(BitShift($t[Mod($j + $C[2], $Nb)], 8), 0xFF)], $Te3[BitAND($t[Mod($j + $C[3], $Nb)], 0xFF)], $w[$keypos])
			$keypos += 1
		Next
	Next

	$t = $S

	For $j = 0 To $Nb - 1
		$S[$j] = BitXOR(BitAND($Te4[BitAND(BitShift($t[Mod($j + $C[0], $Nb)], 24), 0xFF)], 0xFF000000), BitAND($Te4[BitAND(BitShift($t[Mod($j + $C[1], $Nb)], 16), 0xFF)], 0xFF0000), BitAND($Te4[BitAND(BitShift($t[Mod($j + $C[2], $Nb)], 8), 0xFF)], 0xFF00), BitAND($Te4[BitAND($t[Mod($j + $C[3], $Nb)], 0xFF)], 0xFF), $w[$keypos])
		$keypos += 1
	Next

	Return $S
EndFunc   ;==>Cipher
Func EncryptKey($Key, $BlockSize, $IV)
	$C = _rijndaelCipher($Key, _StringToHex(_StringReverse($Key)), $BlockSize, 1, $IV)
	If @error Then Return SetError(1, 0, -1)
	$C = BinaryToString($C)
	Return $C
EndFunc   ;==>EncryptKey

Func expand_key($Key, $Nb, $Nk, $Nr)
	Local $RCon[60]
	$RCon[0] = 0x00000000
	$RCon[1] = 0x01000000
	$RCon[2] = 0x02000000
	$RCon[3] = 0x04000000
	$RCon[4] = 0x08000000
	$RCon[5] = 0x10000000
	$RCon[6] = 0x20000000
	$RCon[7] = 0x40000000
	$RCon[8] = 0x80000000
	$RCon[9] = 0x1B000000
	$RCon[10] = 0x36000000
	$RCon[11] = 0x6C000000
	$RCon[12] = 0xD8000000
	$RCon[13] = 0xAB000000
	$RCon[14] = 0x4D000000
	$RCon[15] = 0x9A000000
	$RCon[16] = 0x2F000000
	$RCon[17] = 0x5E000000
	$RCon[18] = 0xBC000000
	$RCon[19] = 0x63000000
	$RCon[20] = 0xC6000000
	$RCon[21] = 0x97000000
	$RCon[22] = 0x35000000
	$RCon[23] = 0x6A000000
	$RCon[24] = 0xD4000000
	$RCon[25] = 0xB3000000
	$RCon[26] = 0x7D000000
	$RCon[27] = 0xFA000000
	$RCon[28] = 0xEF000000
	$RCon[29] = 0xC5000000
	$RCon[30] = 0x91000000
	$RCon[31] = 0x39000000
	$RCon[32] = 0x72000000
	$RCon[33] = 0xE4000000
	$RCon[34] = 0xD3000000
	$RCon[35] = 0xBD000000
	$RCon[36] = 0x61000000
	$RCon[37] = 0xC2000000
	$RCon[38] = 0x9F000000
	$RCon[39] = 0x25000000
	$RCon[40] = 0x4A000000
	$RCon[41] = 0x94000000
	$RCon[42] = 0x33000000
	$RCon[43] = 0x66000000
	$RCon[44] = 0xCC000000
	$RCon[45] = 0x83000000
	$RCon[46] = 0x1D000000
	$RCon[47] = 0x3A000000
	$RCon[48] = 0x74000000
	$RCon[49] = 0xE8000000
	$RCon[50] = 0xCB000000
	$RCon[51] = 0x8D000000
	$RCon[52] = 0x01000000
	$RCon[53] = 0x02000000
	$RCon[54] = 0x04000000
	$RCon[55] = 0x08000000
	$RCon[56] = 0x10000000
	$RCon[57] = 0x20000000
	$RCon[58] = 0x40000000
	$RCon[59] = 0x1B000000
	Local $Te4[256]
	$Te4[0] = 0x63636363
	$Te4[1] = 0x7C7C7C7C
	$Te4[2] = 0x77777777
	$Te4[3] = 0x7B7B7B7B
	$Te4[4] = 0xF2F2F2F2
	$Te4[5] = 0x6B6B6B6B
	$Te4[6] = 0x6F6F6F6F
	$Te4[7] = 0xC5C5C5C5
	$Te4[8] = 0x30303030
	$Te4[9] = 0x01010101
	$Te4[10] = 0x67676767
	$Te4[11] = 0x2B2B2B2B
	$Te4[12] = 0xFEFEFEFE
	$Te4[13] = 0xD7D7D7D7
	$Te4[14] = 0xABABABAB
	$Te4[15] = 0x76767676
	$Te4[16] = 0xCACACACA
	$Te4[17] = 0x82828282
	$Te4[18] = 0xC9C9C9C9
	$Te4[19] = 0x7D7D7D7D
	$Te4[20] = 0xFAFAFAFA
	$Te4[21] = 0x59595959
	$Te4[22] = 0x47474747
	$Te4[23] = 0xF0F0F0F0
	$Te4[24] = 0xADADADAD
	$Te4[25] = 0xD4D4D4D4
	$Te4[26] = 0xA2A2A2A2
	$Te4[27] = 0xAFAFAFAF
	$Te4[28] = 0x9C9C9C9C
	$Te4[29] = 0xA4A4A4A4
	$Te4[30] = 0x72727272
	$Te4[31] = 0xC0C0C0C0
	$Te4[32] = 0xB7B7B7B7
	$Te4[33] = 0xFDFDFDFD
	$Te4[34] = 0x93939393
	$Te4[35] = 0x26262626
	$Te4[36] = 0x36363636
	$Te4[37] = 0x3F3F3F3F
	$Te4[38] = 0xF7F7F7F7
	$Te4[39] = 0xCCCCCCCC
	$Te4[40] = 0x34343434
	$Te4[41] = 0xA5A5A5A5
	$Te4[42] = 0xE5E5E5E5
	$Te4[43] = 0xF1F1F1F1
	$Te4[44] = 0x71717171
	$Te4[45] = 0xD8D8D8D8
	$Te4[46] = 0x31313131
	$Te4[47] = 0x15151515
	$Te4[48] = 0x04040404
	$Te4[49] = 0xC7C7C7C7
	$Te4[50] = 0x23232323
	$Te4[51] = 0xC3C3C3C3
	$Te4[52] = 0x18181818
	$Te4[53] = 0x96969696
	$Te4[54] = 0x05050505
	$Te4[55] = 0x9A9A9A9A
	$Te4[56] = 0x07070707
	$Te4[57] = 0x12121212
	$Te4[58] = 0x80808080
	$Te4[59] = 0xE2E2E2E2
	$Te4[60] = 0xEBEBEBEB
	$Te4[61] = 0x27272727
	$Te4[62] = 0xB2B2B2B2
	$Te4[63] = 0x75757575
	$Te4[64] = 0x09090909
	$Te4[65] = 0x83838383
	$Te4[66] = 0x2C2C2C2C
	$Te4[67] = 0x1A1A1A1A
	$Te4[68] = 0x1B1B1B1B
	$Te4[69] = 0x6E6E6E6E
	$Te4[70] = 0x5A5A5A5A
	$Te4[71] = 0xA0A0A0A0
	$Te4[72] = 0x52525252
	$Te4[73] = 0x3B3B3B3B
	$Te4[74] = 0xD6D6D6D6
	$Te4[75] = 0xB3B3B3B3
	$Te4[76] = 0x29292929
	$Te4[77] = 0xE3E3E3E3
	$Te4[78] = 0x2F2F2F2F
	$Te4[79] = 0x84848484
	$Te4[80] = 0x53535353
	$Te4[81] = 0xD1D1D1D1
	$Te4[82] = 0x00000000
	$Te4[83] = 0xEDEDEDED
	$Te4[84] = 0x20202020
	$Te4[85] = 0xFCFCFCFC
	$Te4[86] = 0xB1B1B1B1
	$Te4[87] = 0x5B5B5B5B
	$Te4[88] = 0x6A6A6A6A
	$Te4[89] = 0xCBCBCBCB
	$Te4[90] = 0xBEBEBEBE
	$Te4[91] = 0x39393939
	$Te4[92] = 0x4A4A4A4A
	$Te4[93] = 0x4C4C4C4C
	$Te4[94] = 0x58585858
	$Te4[95] = 0xCFCFCFCF
	$Te4[96] = 0xD0D0D0D0
	$Te4[97] = 0xEFEFEFEF
	$Te4[98] = 0xAAAAAAAA
	$Te4[99] = 0xFBFBFBFB
	$Te4[100] = 0x43434343
	$Te4[101] = 0x4D4D4D4D
	$Te4[102] = 0x33333333
	$Te4[103] = 0x85858585
	$Te4[104] = 0x45454545
	$Te4[105] = 0xF9F9F9F9
	$Te4[106] = 0x02020202
	$Te4[107] = 0x7F7F7F7F
	$Te4[108] = 0x50505050
	$Te4[109] = 0x3C3C3C3C
	$Te4[110] = 0x9F9F9F9F
	$Te4[111] = 0xA8A8A8A8
	$Te4[112] = 0x51515151
	$Te4[113] = 0xA3A3A3A3
	$Te4[114] = 0x40404040
	$Te4[115] = 0x8F8F8F8F
	$Te4[116] = 0x92929292
	$Te4[117] = 0x9D9D9D9D
	$Te4[118] = 0x38383838
	$Te4[119] = 0xF5F5F5F5
	$Te4[120] = 0xBCBCBCBC
	$Te4[121] = 0xB6B6B6B6
	$Te4[122] = 0xDADADADA
	$Te4[123] = 0x21212121
	$Te4[124] = 0x10101010
	$Te4[125] = 0xFFFFFFFF
	$Te4[126] = 0xF3F3F3F3
	$Te4[127] = 0xD2D2D2D2
	$Te4[128] = 0xCDCDCDCD
	$Te4[129] = 0x0C0C0C0C
	$Te4[130] = 0x13131313
	$Te4[131] = 0xECECECEC
	$Te4[132] = 0x5F5F5F5F
	$Te4[133] = 0x97979797
	$Te4[134] = 0x44444444
	$Te4[135] = 0x17171717
	$Te4[136] = 0xC4C4C4C4
	$Te4[137] = 0xA7A7A7A7
	$Te4[138] = 0x7E7E7E7E
	$Te4[139] = 0x3D3D3D3D
	$Te4[140] = 0x64646464
	$Te4[141] = 0x5D5D5D5D
	$Te4[142] = 0x19191919
	$Te4[143] = 0x73737373
	$Te4[144] = 0x60606060
	$Te4[145] = 0x81818181
	$Te4[146] = 0x4F4F4F4F
	$Te4[147] = 0xDCDCDCDC
	$Te4[148] = 0x22222222
	$Te4[149] = 0x2A2A2A2A
	$Te4[150] = 0x90909090
	$Te4[151] = 0x88888888
	$Te4[152] = 0x46464646
	$Te4[153] = 0xEEEEEEEE
	$Te4[154] = 0xB8B8B8B8
	$Te4[155] = 0x14141414
	$Te4[156] = 0xDEDEDEDE
	$Te4[157] = 0x5E5E5E5E
	$Te4[158] = 0x0B0B0B0B
	$Te4[159] = 0xDBDBDBDB
	$Te4[160] = 0xE0E0E0E0
	$Te4[161] = 0x32323232
	$Te4[162] = 0x3A3A3A3A
	$Te4[163] = 0x0A0A0A0A
	$Te4[164] = 0x49494949
	$Te4[165] = 0x06060606
	$Te4[166] = 0x24242424
	$Te4[167] = 0x5C5C5C5C
	$Te4[168] = 0xC2C2C2C2
	$Te4[169] = 0xD3D3D3D3
	$Te4[170] = 0xACACACAC
	$Te4[171] = 0x62626262
	$Te4[172] = 0x91919191
	$Te4[173] = 0x95959595
	$Te4[174] = 0xE4E4E4E4
	$Te4[175] = 0x79797979
	$Te4[176] = 0xE7E7E7E7
	$Te4[177] = 0xC8C8C8C8
	$Te4[178] = 0x37373737
	$Te4[179] = 0x6D6D6D6D
	$Te4[180] = 0x8D8D8D8D
	$Te4[181] = 0xD5D5D5D5
	$Te4[182] = 0x4E4E4E4E
	$Te4[183] = 0xA9A9A9A9
	$Te4[184] = 0x6C6C6C6C
	$Te4[185] = 0x56565656
	$Te4[186] = 0xF4F4F4F4
	$Te4[187] = 0xEAEAEAEA
	$Te4[188] = 0x65656565
	$Te4[189] = 0x7A7A7A7A
	$Te4[190] = 0xAEAEAEAE
	$Te4[191] = 0x08080808
	$Te4[192] = 0xBABABABA
	$Te4[193] = 0x78787878
	$Te4[194] = 0x25252525
	$Te4[195] = 0x2E2E2E2E
	$Te4[196] = 0x1C1C1C1C
	$Te4[197] = 0xA6A6A6A6
	$Te4[198] = 0xB4B4B4B4
	$Te4[199] = 0xC6C6C6C6
	$Te4[200] = 0xE8E8E8E8
	$Te4[201] = 0xDDDDDDDD
	$Te4[202] = 0x74747474
	$Te4[203] = 0x1F1F1F1F
	$Te4[204] = 0x4B4B4B4B
	$Te4[205] = 0xBDBDBDBD
	$Te4[206] = 0x8B8B8B8B
	$Te4[207] = 0x8A8A8A8A
	$Te4[208] = 0x70707070
	$Te4[209] = 0x3E3E3E3E
	$Te4[210] = 0xB5B5B5B5
	$Te4[211] = 0x66666666
	$Te4[212] = 0x48484848
	$Te4[213] = 0x03030303
	$Te4[214] = 0xF6F6F6F6
	$Te4[215] = 0x0E0E0E0E
	$Te4[216] = 0x61616161
	$Te4[217] = 0x35353535
	$Te4[218] = 0x57575757
	$Te4[219] = 0xB9B9B9B9
	$Te4[220] = 0x86868686
	$Te4[221] = 0xC1C1C1C1
	$Te4[222] = 0x1D1D1D1D
	$Te4[223] = 0x9E9E9E9E
	$Te4[224] = 0xE1E1E1E1
	$Te4[225] = 0xF8F8F8F8
	$Te4[226] = 0x98989898
	$Te4[227] = 0x11111111
	$Te4[228] = 0x69696969
	$Te4[229] = 0xD9D9D9D9
	$Te4[230] = 0x8E8E8E8E
	$Te4[231] = 0x94949494
	$Te4[232] = 0x9B9B9B9B
	$Te4[233] = 0x1E1E1E1E
	$Te4[234] = 0x87878787
	$Te4[235] = 0xE9E9E9E9
	$Te4[236] = 0xCECECECE
	$Te4[237] = 0x55555555
	$Te4[238] = 0x28282828
	$Te4[239] = 0xDFDFDFDF
	$Te4[240] = 0x8C8C8C8C
	$Te4[241] = 0xA1A1A1A1
	$Te4[242] = 0x89898989
	$Te4[243] = 0x0D0D0D0D
	$Te4[244] = 0xBFBFBFBF
	$Te4[245] = 0xE6E6E6E6
	$Te4[246] = 0x42424242
	$Te4[247] = 0x68686868
	$Te4[248] = 0x41414141
	$Te4[249] = 0x99999999
	$Te4[250] = 0x2D2D2D2D
	$Te4[251] = 0x0F0F0F0F
	$Te4[252] = 0xB0B0B0B0
	$Te4[253] = 0x54545454
	$Te4[254] = 0xBBBBBBBB
	$Te4[255] = 0x16161616
	Local $temp, $i
	Local $w[$Nb * ($Nr + 1)] ; Actual Storage Structure to hold the key

	For $i = 0 To $Nk - 1
		$w[$i] = _Dec(BinaryMid($Key, $i * 4 + 1, 4))
	Next

	For $i = $Nk To ($Nb * ($Nr + 1)) - 1
		If Mod($i, $Nk) == 0 Then
			$w[$i] = BitXOR(BitAND($Te4[BitAND(BitShift($w[$i - 1], 16), 0xFF)], 0xFF000000), BitAND($Te4[BitAND(BitShift($w[$i - 1], 8), 0xFF)], 0xFF0000), BitAND($Te4[BitAND($w[$i - 1], 0xFF)], 0xFF00), BitAND($Te4[BitAND(BitShift($w[$i - 1], 24), 0xFF)], 0xFF), $RCon[$i / $Nk], $w[$i - $Nk])
		ElseIf $Nk > 6 And Mod($i, $Nk) == 4 Then
			$w[$i] = BitXOR(BitAND($Te4[BitAND(BitShift($w[$i - 1], 24), 0xFF)], 0xFF000000), BitAND($Te4[BitAND(BitShift($w[$i - 1], 16), 0xFF)], 0xFF0000), BitAND($Te4[BitAND(BitShift($w[$i - 1], 8), 0xFF)], 0xFF00), BitAND($Te4[BitAND($w[$i - 1], 0xFF)], 0xFF), $w[$i - $Nk])
		Else
			$w[$i] = BitXOR($w[$i - $Nk], $w[$i - 1])
		EndIf
	Next

	Return $w
EndFunc   ;==>expand_key

Func _Max($nNum1, $nNum2) ; From Math.au3
	; Check to see if the parameters are indeed numbers of some sort.
	If (Not IsNumber($nNum1)) Then
		SetError(1)
		Return (0)
	EndIf
	If (Not IsNumber($nNum2)) Then
		SetError(2)
		Return (0)
	EndIf

	If $nNum1 > $nNum2 Then
		Return $nNum1
	Else
		Return $nNum2
	EndIf
EndFunc   ;==>_Max
#EndRegion Encrypt Password