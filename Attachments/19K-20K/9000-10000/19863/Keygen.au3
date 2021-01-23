#include-once
#include <String.au3>

;===============================================================================
;
; Function Name:    _Keygen($sProduct, $sConfirmCode, $sSecure = 2)
; Description:      Creates a random key, that can be decoded
; Parameter(s):     $sProduct 		- The encryption key, can be name of product
;					$sConfirmCode	- The code to check within the key
;					$sSecure		- Level of encryption
; Requirement(s):   String.au3
; Return Value(s):  On Success - A key
; Author(s):        McGod
;
;===============================================================================
Func _Keygen($sProduct, $sConfirmCode, $sSecure = 2)
	;==[Generate a random code]==
	Local $sCode
	For $i = 1 To 16 Step 1
		$sCode &= StringMid("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", Random(1, 36), 1)
	Next
	;==[Add Confirm code]==
	$sCode &= $sConfirmCode
	
	;==[Encrypt]==
	Return _StringEncrypt(1, $sCode, $sProduct, $sSecure)
EndFunc   ;==>_Keygen

;===============================================================================
;
; Function Name:    _Confirm($sKey, $sProduct, $sConfirmCode, $sSecure = 2)
; Description:      Checks if a given key is valid
; Parameter(s):     $sKey			- The key given by user
;					$sProduct 		- The encryption key, can be name of product
;					$sConfirmCode	- The code to check within the key
;					$sSecure		- Level of encryption
; Requirement(s):   String.au3
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets error
;					@error = 1 - Couldn't decrypt key
;					@error = 2 - Length of decrypted key incorrect
;					@error = 3 - Invalid confirm code
; Author(s):        McGod
;
;===============================================================================
Func _Confirm($sKey, $sProduct, $sConfirmCode, $sSecure = 2)
	Local $sCrypt = _StringEncrypt(0, $sKey, $sProduct, $sSecure)
	If @error Then Return SetError(1, 0, 0)
	
	;==[Confirm the length is correct]==
	If StringLen($sCrypt) <> (StringLen($sConfirmCode) + 16) Then Return SetError(2, 0, 0)
	
	;==[Check Confirm code]==
	If StringMid($sCrypt, 17) <> $sConfirmCode Then Return SetError(3, 0, 0)
	
	Return 1
EndFunc   ;==>_Confirm