#include-once

; #FUNCTION# ====================================================================================================================
;
; Name...........:	_SetDriverSigning
; Description ...:	Sets driver signing policy on Microsoft Windows operating systems
; Syntax.........:	_SetDriverSigning([$iLM, $iCU, $sComputer])
; Parameters ....:	$iLM - [Optional] Set at the machine level
;                           0 - Ignore
;                           1 - Warn
;                           2 - Block
;                           3 - Ignore only for current user
;                           Default is Ignore
;                   $iCU - [Optional] Set at the user level
;                           0 - $iLM setting takes precedence
;                           1 - Warn only for current user if greater than $iLM setting
;                           2 - Block only for current user if greater than $iLM setting
;					$sComputer - [Optional] Computer name
;								The local computer is default
; Return values .:	Success - Returns 1
;					Failure - Returns 0 and sets @error to:
;                           -1 - Failure to read the registry
;                           -2 - Failure to compute the cryptographic hash
;                           -3 - Failure to write to the registry
; Author ........:	engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
;
; ===============================================================================================================================

Func _SetDriverSigning($iLM = 0, $iCU = 0, $sComputer = @ComputerName)
	Local Const $PROV_RSA_FULL = 0x00000001
	Local Const $CRYPT_VERIFYCONTEXT = 0xf0000000
	Local Const $ALG_CLASS_HASH = 0x00008000
	Local Const $ALG_TYPE_ANY = 0x00000000
	Local Const $ALG_SID_MD5 = 0x00000003
	Local Const $CALG_MD5 = BitOR($ALG_CLASS_HASH, $ALG_TYPE_ANY, $ALG_SID_MD5)
	Local Const $HP_HASHVAL = 0x00000002
	
	Local $iSeed = RegRead("\\" & $sComputer & "\HKLM\SYSTEM\WPA\PnP", "seed")
	If @error Then Return SetError(-1, 0, 0)
	
	Local $hAdvapi32 = DllOpen("Advapi32.dll")
	
	; Acquire the CSP
	Local $avProv = DllCall( $hAdvapi32, "int", "CryptAcquireContext", _
		"hwnd*", 0, _
		"ptr", 0, _
		"ptr", 0, _
		"dword", $PROV_RSA_FULL, _
		"dword", $CRYPT_VERIFYCONTEXT )
	
	; Create a hash object
	Local $avHash = DllCall( $hAdvapi32, "int", "CryptCreateHash", _
		"hwnd", $avProv[1], _
		"dword", $CALG_MD5, _
		"hwnd", 0, _
		"dword", 0, _
		"hwnd*", 0 )
	
	; Compute the cryptographic hash on the data
	Local $tIMPUT = DllStructCreate("char[4]")
	DllStructSetData($tIMPUT, 1, $iLM, 2)
	DllCall( $hAdvapi32, "int", "CryptHashData", _
		"hwnd", $avHash[5], _
		"ptr", DllStructGetPtr($tIMPUT), _
		"dword", DllStructGetSize($tIMPUT), _
		"dword", 0 )
	DllCall( $hAdvapi32, "int", "CryptHashData", _
		"hwnd", $avHash[5], _
		"dword*", $iSEED, _
		"dword", 4, _
		"dword", 0 )
	Local $tDATA = DllStructCreate("byte[16]")
	DllCall( $hAdvapi32, "int", "CryptGetHashParam", _
		"hwnd", $avHash[5], _
		"dword", $HP_HASHVAL, _
		"ptr", DllStructGetPtr($tDATA), _
		"dword*", DllStructGetSize($tDATA), _
		"dword", 0 )
	
	; Destroy the hash object
	DllCall( $hAdvapi32, "int", "CryptDestroyHash", _
		"hwnd", $avHash[5] )
	
	; Release the CSP
	DllCall( $hAdvapi32, "int", "CryptReleaseContext", _
		"hwnd", $avProv[1], _
		"dword", 0 )
	
	DllClose($hAdvapi32)
	
	; Get last error
	Local $aiGLE = DllCall("Kernel32.dll", "dword", "GetLastError")
	If $aiGLE[0] <> 0 Then Return SetError(-2, 0, 0)
	
	If Not RegWrite( "\\" & $sComputer & "\HKLM\Software\Microsoft\Windows\CurrentVersion\Setup", "PrivateHash", "REG_BINARY", DllStructGetData($tDATA, 1) ) _
	Or Not RegWrite( "\\" & $sComputer & "\HKLM\SOFTWARE\Microsoft\Driver Signing", "Policy", "REG_BINARY", Binary($iLM) ) _
	Or Not RegWrite("\\" & $sComputer & "\HKCU\Software\Policies\Microsoft\Windows NT\Driver Signing", "BehaviorOnFailedVerify", "REG_DWORD", $iCU) _
	Then Return SetError(-3, 0, 0)
	Return 1
EndFunc ;==> _SetDriverSigning
