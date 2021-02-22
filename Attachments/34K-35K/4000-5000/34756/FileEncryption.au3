#include<File.au3>
;===============================================================================
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
;===============================================================================
;
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

;===============================================================================
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
;===============================================================================
;
Func _FileDecrypt($FileInput, $FileOutput, $sKey)
	Select
		Case Not FileExists(@TempDir & "\encrypt.com")
			_WriteEncryptCom()
		Case Not FileExists($FileInput)
			Return SetError(1, 0, 0)
	EndSelect
	If Not FileExists(@TempDir & "\encrypt.com") Then _WriteEncryptCom()
	$FileTemp = __FileCopy($FileInput, $FileOutput)
	If @extended = 0 Then Return SetError(2, 0, 0)
	RunWait(@ComSpec & " /c echo " & $sKey & "|" & FileGetShortName(@TempDir & "\encrypt.com") & " - " & FileGetShortName($FileOutput), "", @SW_HIDE)
	FileDelete(@TempDir & "\encrypt.com")
	FileDelete($FileTemp)
EndFunc   ;==>_FileDecrypt

Func __FileCopy($FileInput, $FileOutput)
	Local $NULL, $szDrive, $szDir, $szFName, $szExt
	_PathSplit($FileInput, $szDrive, $szDir, $szFName, $szExt)
	FileCopy($FileInput, @TempDir, 9)
	Return SetError(0, FileMove(@TempDir & "\" & $szFName & $szExt, $FileOutput, 9), @TempDir & "\" & $szFName & $szExt)
EndFunc   ;==>__FileCopy

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
	$hEncryptCom = FileOpen(@TempDir & "\encrypt.com", 2+16)
	FileWrite($hEncryptCom, Binary($com))
	FileClose($hEncryptCom)
EndFunc   ;==>_WriteEncryptCom