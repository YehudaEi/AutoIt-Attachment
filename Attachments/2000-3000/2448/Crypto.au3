#cs
vi:ts=4 sw=4:
crypto.au3
file encryption/decryption
Ejoc
#ce
#include-once
#include <DllStruct.au3>
Global Const $PROV_RSA_FULL			= 1
Global Const $CRYPT_NEWKEYSET		= 0x00000008
Global Const $CRYPT_STRING_BASE64	= 0x00000001
Global Const $CALG_MD5				= BitOr(3,BitShift(4,-13))
Global Const $CALG_RC4				= BitOr(1,BitShift(4,-9),BitShift(3,-13))

;=====================================================
;	_DecryptString($szString,$szPassword)
;	Decrypt an ASCII armoured string
;	$szString		string to decrypt
;	$szPassword		password to Decrypt it with
;	Return			Success New ASCII string, Failure @error is set
;	$plain = _DecryptString("HBukowWHoqGJ7QkfRnX8FbOGY/+sO3yq5aA=","PASSWORD")
;=====================================================
Func _DecryptString($szString,$szPassword)
	Local $p,$s,$binLen, $ret

	$binLen	= DllStructCreate("int;int;int")
	If @Error Then
		SetError(-1)
		Return ""
	EndIf

	;get the size of the binary data buffer that we need to create
	$ret	= DllCall("Crypt32.dll","int","CryptStringToBinary",_
						"str",$szString,_
						"int",StringLen($szString),_
						"int",$CRYPT_STRING_BASE64,_
						"ptr",0,_
						"ptr",DllStructGetPtr($binLen,1),_
						"ptr",DllStructGetPtr($binLen,2),_
						"ptr",DllStructGetPtr($binLen,3))

	If @error or Not $ret[0] Then
		_GetLastErrorMessage("CryptStringToBinary(1):")
		DllStructDelete($binLen)
		SetError(-2)
		Return ""
	EndIf

	;Create a DllStruct to Decrypt into
	$p	= DllStructCreate("char[" & DllStructGetData($binLen,1)+1 & "]")
	If @error Then
		DllStructDelete($binLen)
		SetError(-3)
		Return ""
	EndIf
	
	;Convert from ascii armormed to binary data
	$ret	= DllCall("Crypt32.dll","int","CryptStringToBinary",_
						"str",$szString,_
						"int",StringLen($szString),_
						"int",$CRYPT_STRING_BASE64,_
						"ptr",DllStructGetPtr($p),_
						"ptr",DllStructGetPtr($binLen,1),_
						"ptr",DllStructGetPtr($binLen,2),_
						"ptr",DllStructGetPtr($binLen,3))

	If @error or Not $ret[0] Then
		_GetLastErrorMessage("CryptStringToBinary(2):")
		DllStructDelete($p)
		DllStructDelete($binLen)
		SetError(-4)
		Return ""
	EndIf

	; decrypt it
	_DecryptDllStruct($p,$szPassword,DllStructGetSize($p)-1)
	If @error Then
		DllStructDelete($p)
		DllStructDelete($binLen)
		SetError(-5)
		return ""
	EndIf

	$s	= DllStructGetData($p,1)
	DllStructDelete($binLen)
	DllStructDelete($p)

	Return $s
EndFunc

;=====================================================
;	_EncryptString($szString,$szPassword)
;	encrypt a string and ASCII armour it
;	$szString		string to encrypt
;	$szPassword		password to encrypt it with
;	Return			Success New ASCII string, Failure @error is set
;	$encrypted = _EncryptString("A string","My password")
;=====================================================
Func _EncryptString($szString,$szPassword)
	Local $p,$s

	;Create a DllStruct to Encode
	$p	= _DllStructCreateFromString($szString)
	If @error Then
		SetError(-1)
		Return ""
	EndIf
	
	; encrypt it
	_EncryptDllStruct($p,$szPassword)
	If @error Then
		DllStructDelete($p)
		SetError(-2)
		return ""
	EndIf

	; convert it
	$s	= _CryptBinaryToString(DllStructGetPtr($p),DllStructGetSize($p))
	DllStructDelete($p)

	Return $s
EndFunc


;=====================================================
;	_EncryptStringToFile($szString,$szPassword,$szFileName)
;	encrypt a string and save it to disk
;	$szString		string to encrypt
;	$szPassword		password to encrypt it with
;	$szFileName		name of the encrypted File
;	Return			Success 1, Failure 0
;=====================================================
Func _EncryptStringToFile($szString,$szPassword,$szFileName)
	Local $p

	;Create a DllStruct to Encode
	$p	= _DllStructCreateFromString($szString)
	If @error Then
		Return 0
	EndIf

	; encrypt it
	_EncryptDllStruct($p,$szPassword)
	If @error Then
		DllStructDelete($p)
		return 0
	EndIf

	;Save the file
	_FileWriteFromDllStruct($p,$szFileName)
	If @error Then
		DllStructDelete($p)
		return 0
	EndIf

	DllStructDelete($p)
	Return 1
EndFunc ; _EncryptStringToFile()

;=====================================================
;	_DecryptFileToString($szFileName,$szPassword)
;	Read a file that was encrypted, and decrypt
;	$szFileName		name of the encrypted File
;	$szPassword		password to decrypt it with
;	Return			Success a string that is the whole file, Failure ""
;=====================================================
Func _DecryptFileToString($szFileName,$szPassword)
	Local $read,$p,$s

	;read the file
	$read = _FileReadToDllStruct($szFileName)
	If @error Then
		Return ""
	EndIf
	$p		= DllStructCreate("char[" & DllStructGetData($read,2) & "]",DllStructGetPtr($read))	; Convert it to a string

	;decrypt
	_DecryptDllStruct($p,$szPassword)
	$s = DllStructGetData($p,1)
	DllStructDelete($read)
	Return $s
EndFunc ; _DecryptFileToString

;=====================================================
;	_EncryptFile($szSource,$szDest,$szPassword)
;	Encrypt a file using RSA and RC4 with an MD5 Hashed password
;	$szSource	Filename of the source file
;	$szDest		Filename of the new encrypted file
;	$szPassword	Password to use to encrypt
;	Return		Success 1, Failure 0 @ERROR is set
;				-2 Error opening the source file
;				-3 Error creating CryptProv
;				-4 Error creating HASH
;				-5 Error hashing password
;				-6 Error creating KEY
;				-7 Error encrypting data
;				-8 Error writing the new file
;=====================================================
Func _EncryptFile($szSource,$szDest,$szPassword)
	Local $lpSource,$hCryptProv,$hHash,$hKey

	SetError(0)

	; read the unencrypted file
	$lpSource	= _FileReadToDllStruct($szSource)
	If @error Then
		SetError(-2)
		Return 0
	EndIf
	
	;encrypt the data
	If Not _EncryptDllStruct($lpSource,$szPassword,DllStructGetData($lpSource,2)) Then
		DllStructDelete($lpSource)
		return 0
	EndIf

	;write the file
	_FileWriteFromDllStruct($lpSource,$szDest)
	If @error Then
		DllStructDelete($lpSource)
		SetError(-8)
		return 0
	EndIf

	DllStructDelete($lpSource)
	Return 1
EndFunc ; _EncryptFile()

;=====================================================
;	_DecryptFile($szSource,$szDest,$szPassword)
;	Decrypt a file using RSA and RC4 with an MD5 Hashed password
;	Just a wrapper to _FileEncrypt() as it decodes
;	$szSource	Filename of the encrypted file
;	$szDest		Filename of the new decrypted file
;	$szPassword	Password to use to decrypt
;	Return		Success 1, Failure 0 @ERROR is set
;				-2 Error opening the source file
;				-3 Error creating CryptProv
;				-4 Error creating HASH
;				-5 Error hashing password
;				-6 Error creating KEY
;				-7 Error decrypting data
;				-8 Error writing the new file
;=====================================================
Func _DecryptFile($szSource,$szDest,$szPassword)
	return _EncryptFile($szSource,$szDest,$szPassword)
EndFunc ; _DecryptFile()

;=====================================================
;	_EncryptDllStruct($lpSource,$szPassword,$iLen=-1)
;	Encrypt a DllStruct using RSA and RC4 with an MD5 Hashed password
;	$lpSource	Struct to encrypt
;	$szPassword	Password to use to encrypt
;	$iLen		Bytes to Encrypt, -1 = DllStructGetSize($lpSource)
;	Return		Success 1, Failure 0 @ERROR is set
;				-3 Error creating CryptProv
;				-4 Error creating HASH
;				-5 Error hashing password
;				-6 Error creating KEY
;				-7 Error encrypting data
;=====================================================
Func _EncryptDllStruct($lpSource,$szPassword,$iLen=-1)
	Local $hCryptProv,$hHash,$hKey

	SetError(0)

	If $iLen = -1 Then $iLen = DllStructGetSize($lpSource)
	If @Error Then Return 0	; could not get $lpSource Size

	;create the default Crypto context
	$hCryptProv	= _CryptAcquireContext()
	If Not $hCryptProv Then
		SetError(-3)
		Return 0
	EndIf

	;create the hash for the password
	$hHash		= _CryptCreateHash($hCryptProv)
	If Not $hHash Then
		_CryptReleaseContext($hCryptProv)
		SetError(-4)
		Return 0
	EndIf

	;create the password hash
	If Not _CryptHashData($hHash,$szPassword) Then
		_CryptDestroyHash($hHash)
		_CryptReleaseContext($hCryptProv)
		SetError(-5)
		Return 0
	EndIf

	;create the key
	$hKey		= _CryptDeriveKey($hCryptProv,$hHash)
	If Not $hKey Then
		_CryptDestroyHash($hHash)
		_CryptReleaseContext($hCryptProv)
		SetError(-6)
		Return 0
	EndIf

	;encrypt the data
	If Not _CryptEncrypt($hKey,DllStructGetPtr($lpSource),$iLen) Then
		_CryptReleaseContext($hCryptProv)
		_CryptDestroyKey($hKey)
		SetError(-7)
		return 0
	EndIf

	;Close the opened/created Crypto Items
	_CryptDestroyHash($hHash)
	_CryptDestroyKey($hKey)
	_CryptReleaseContext($hCryptProv)

	Return 1
EndFunc ; _EncryptDllStruct()

;=====================================================
;	_DecryptDllStruct($lpSource,$szPassword,$iLen=-1)
;	Wrapper for _EncryptDllStruct
;=====================================================
Func _DecryptDllStruct($lpSource,$szPassword,$iLen=-1)
	Return _EncryptDllStruct($lpSource,$szPassword,$iLen)
EndFunc ; _DecryptDllStruct()

;=====================================================
;	_CryptBinaryToString($lpSource,$iLen)
;	Convert the Binary Encrypted Data into an ASCII string to display
;	$lpSource	Pointer to the memory to encrypt: DllStructGetPtr($data)
;	$iLen		Length of the Binary Data
;	Return		
;=====================================================
Func _CryptBinaryToString($lpSource,$iLen)
	Local $strLen,$p,$ret,$s
	
	$strLen	= DllStructCreate("int")
	If @error Then
		SetError(-1)
		Return ""
	EndIf

;Get string length to create
	$ret	= DllCall("Crypt32.dll","int","CryptBinaryToString",_
						"ptr",$lpSource,_
						"int",$iLen,_
						"int",$CRYPT_STRING_BASE64,_
						"ptr",0,_
						"ptr",DllStructGetPtr($strLen))

	If @error or Not $ret[0] Then
		_GetLastErrorMessage("CryptBinaryToString(1):")
		DllStructDelete($strLen)
		SetError(-2)
		Return ""
	EndIf

	$p	= DllStructCreate("char[" & DllStructGetData($strLen,1) + 1 & "]")
	If @Error Then
		DllStructDelete($strLen)
		SetError(-3)
		Return ""
	EndIf

;convert the string
	$ret	= DllCall("Crypt32.dll","int","CryptBinaryToString",_
						"ptr",$lpSource,_
						"int",$iLen,_
						"int",$CRYPT_STRING_BASE64,_
						"ptr",DllStructGetPtr($p),_
						"ptr",DllStructGetPtr($strLen))

	If @error or Not $ret[0] Then
		_GetLastErrorMessage("CryptBinaryToString(2):")
		DllStructDelete($strLen)
		DllStructDelete($p)
		SetError(-4)
		Return ""
	EndIf

	$s	= DllStructGetData($p,1)
	DllStructDelete($strLen)
	DllStructDelete($p)

	Return $s
EndFunc

;=====================================================
;	_CryptEncrypt($hKey,$lpSource,$iLen)
;	Encrypt the memory at $lpSource which is $iLen bytes using the key $hKey
;	$hKey		Key to use to encrypt
;	$lpSource	Pointer to the memory to encrypt: DllStructGetPtr($data)
;	$iLen		Length of the data: DllStructGetSize($data)
;	Return		Success Length of encrypted bytes, should = $iLen, Failure 0
;=====================================================
Func _CryptEncrypt($hKey,$lpSource,$iLen)
	Local $ret,$p,$written

	$p	= DllStructCreate("int")
	If @error Then Return 0

	DllStructSetData($p,1,$iLen)

	$ret	= DllCall("Advapi32.dll","int","CryptEncrypt",_
						"int",$hKey,_
						"ptr",0,_
						"int",1,_
						"int",0,_
						"ptr",$lpSource,_
						"ptr",DllStructGetPtr($p),_
						"int",$iLen)
	If @error or not $ret[0] Then
		_GetLastErrorMessage("CryptDeriveKey:")
		DllStructDelete($p)
		Return 0
	EndIf

	$written = DllStructGetData($p,1)
	DllStructDelete($p)
	Return $written
EndFunc ; _CryptEncrypt()

;=====================================================
;	_CryptDestroyKey($hKey)
;	free the key
;	$hKey		the return from _CryptDeriveKey()
;	Return		Success 1, Failure 0
;=====================================================
Func _CryptDestroyKey($hKey)
	Local $ret

	$ret	= DllCall("Advapi32.dll","int","CryptDestroyKey",_
						"int",$hKey,_
						"int",0)
	If @error Or Not $ret[0] Then
		_GetLastErrorMessage("CryptDestroyKey:")
		Return 0
	EndIf

	Return 1
EndFunc ; _CryptDestroyKey()

;=====================================================
;	_CryptDeriveKey($hCryptProv,$hHash)
;	Generate the key derived from the password hash($hHash) and 
;	CryptProvider($hCryptProv) using RC4
;	$hCryptProv	Return from _CryptAcquireContext()
;	$hHash		Return from _CryptHashData()
;	Return		Succes The New Key, failure 0
;=====================================================
Func _CryptDeriveKey($hCryptProv,$hHash)
	Local $ret,$p,$hKey

	$p	= DllStructCreate("uint")
	If @error Then Return 0

	$ret	= DllCall("Advapi32.dll","int","CryptDeriveKey",_
						"int",$hCryptProv,_
						"int",$CALG_RC4,_
						"int",$hHash,_
						"int",0x00800000,_
						"ptr",DllStructGetPtr($p))

	If @error Or Not $ret[0] Then
		_GetLastErrorMessage("CryptDeriveKey:")
		DllStructDelete($p)
		return 0
	EndIf

	$hKey	= DllStructGetData($p,1)
	DllStructDelete($p)
	return $hKey
EndFunc ; _CryptDeriveKey()

;=====================================================
;	_CryptHashData($hHash,$szString)
;	Create an MD5 hash of the string $szString used to create the key
;	$hHash		Return from _CryptCreateHash()
;	$szString	the string to HASH
;	Return		Succes 1, failure 0
;=====================================================
Func _CryptHashData($hHash,$szString)
	Local $ret

	$ret	= DllCall("Advapi32.dll","int","CryptHashData",_
						"int",$hHash,_
						"str",$szString,_
						"int",StringLen($szString),_
						"int",0)
	If @error or not $ret[0] Then
		_GetLastErrorMessage("CryptHashData:")
		Return 0
	endif
	return 1
EndFunc ; _CryptHashData()

;=====================================================
;	_CryptDestroyHash($hHash)
;	Free the hash
;	$hHash		HASH to free
;	Return		Success 1, Failure 0
;=====================================================
Func _CryptDestroyHash($hHash)
	Local $ret
	$ret	= DllCall("Advapi32.dll","int","CryptDestroyHash",_
						"int",$hHash)
	if @error or not $ret[0] Then
		_GetLastErrorMessage("CryptDestroyHash:")
		Return 0
	EndIf
	return 1
EndFunc ; _CryptDestroyHash()

;=====================================================
;	_CryptCreateHash($hCryptProv)
;	Create a HASH using the Crypt Provider $hCryptProv
;	$hCryptProv		Crypt Provider to make a HASH from
;	Return			Success The new HASH, Failure 0
;=====================================================
Func _CryptCreateHash($hCryptProv)
	Local $ret,$p,$hHash

	$p	= DllStructCreate("uint")
	If @error Then Return 0

	$ret	= DllCall("Advapi32.dll","int","CryptCreateHash",_
						"int",$hCryptProv,_
						"int",$CALG_MD5,_
						"int",0,_
						"int",0,_
						"ptr",DllStructGetPtr($p))
	if @error or Not $ret[0] Then;error
		_GetLastErrorMessage("CryptCreateHash:")
		DllStructDelete($p)
		return 0
	EndIf

	$hHash	= DllStructGetData($p,1)
	DllStructDelete($p)
	return $hHash
EndFunc ; _CryptCreateHash()

;=====================================================
;	_CryptReleaseContext($hCryptProv)
;	Free the Crypt Provider $hCryptProv
;	$hCryptProv		Crypt Provider to free
;	Return			Success 1, Failure 0
;=====================================================
Func _CryptReleaseContext($hCryptProv)
	Local $ret

	$ret	= DllCall("Advapi32.dll","int","CryptReleaseContext",_
						"int",$hCryptProv,_
						"int",0)
	If @error Or Not $ret[0] Then
		_GetLastErrorMessage("CryptReleaseContext:")
		Return 0
	EndIf

	Return 1
EndFunc	; _CryptReleaseContext()

;=====================================================
;	_CryptAcquireContext()
;	Create a Crypt Provider
;	Return			Success A CryptProvider, Failure 0
;=====================================================
Func _CryptAcquireContext()
	Local $ret,$hCryptProv,$p

	$p	= DllStructCreate("uint")
	If @error Then Return 0

	$ret	= DllCall("Advapi32.dll","int","CryptAcquireContext",_
						"ptr",DllStructGetPtr($p),_
						"ptr",0,_
						"ptr",0,_
						"int",$PROV_RSA_FULL,_
						"int",0)

	if Not $ret[0] Then ; context Does not exists, create one
		$ret	= DllCall("Advapi32.dll","int","CryptAcquireContext",_
							"ptr",DllStructGetPtr($p),_
							"ptr",0,_
							"ptr",0,_
							"int",$PROV_RSA_FULL,_
							"int",$CRYPT_NEWKEYSET)
		If @error Or Not $ret[0] Then
			_GetLastErrorMessage("CryptAcquireContext:")
			DllStructDelete($p)
			Return 0
		EndIf
	EndIf

	$hCryptProv	= DllStructGetData($p,1)
	DllStructDelete($p)
	Return $hCryptProv
EndFunc ; _CryptAcquireContext()
