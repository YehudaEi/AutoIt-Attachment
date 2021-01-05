#include-once
; version 2005/10/04 
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    High-speed registry access functions.
; Todo:		  	  Better error checking.
;

; Fixed registry keys
Const $HKEY_CLASSES_ROOT = 0x80000000
Const $HKEY_CURRENT_USER = 0x80000001
Const $HKEY_LOCAL_MACHINE = 0x80000002
Const $HKEY_USERS = 0x80000003
Const $HKEY_PERFORMANCE_DATA = 0x80000004
Const $HKEY_CURRENT_CONFIG = 0x80000005
Const $HKEY_DYN_DATA = 0x80000006

; Error codes
Const $ERROR_SUCCESS = 0
Const $ERROR_ACCESS_DENIED = 5
Const $ERROR_NO_MORE_ITEMS = 259
Const $ERROR_FILE_NOT_FOUND = 2

Global $advapi_dll = 0
Global $advapi_dll_count = 0

;===============================================================================
;
; Description:      Opens and returns a handle to a registry key.
; Parameter(s):     $sKey    - Key to Open, in same format as RegEnumKey
; Requirement(s):   None
; Return Value(s):  On Success - Returns the key handle
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Will Mooar
; Note(s):          None
;
;===============================================================================
Func _RegOpenKey( $sKey )
	Local $hParentKey, $sParentKey, $sSubKey
	Local $i = StringInStr($sKey, "\", 1)
	if $i = 0 then $i = StringLen($skey)+1
	$sParentKey = StringLeft($skey, $i-1)
	$sSubKey = StringMid($skey, $i+1)

	switch StringUpper($sParentKey)
		case "HKEY_CLASSES_ROOT", "HKCR"
			$hParentKey = $HKEY_CLASSES_ROOT
		case "HKEY_CURRENT_USER", "HKCU"
			$hParentKey = $HKEY_CURRENT_USER
		case "HKEY_LOCAL_MACHINE", "HKLM"
			$hParentKey = $HKEY_LOCAL_MACHINE
		case "HKEY_USERS", "HKU"
			$hParentKey = $HKEY_USERS
		case "HKEY_PERFORMANCE_DATA"
			$hParentKey = $HKEY_PERFORMANCE_DATA
		case "HKEY_CURRENT_CONFIG", "HKCC"
			$hParentKey = $HKEY_CURRENT_CONFIG
		case "HKEY_DYN_DATA"
			$hParentKey = $HKEY_DYN_DATA
		case Else
			SetError(1)
			Return(0)
	endswitch

	if $advapi_dll_count = 0 then
		$advapi_dll = DllOpen("advapi32.dll")
	endif
	$advapi_dll_count += 1

	Local $ret
	$ret = DllCall( _
		$advapi_dll, "int", "RegOpenKeyW", _
		"int", $hParentKey, _
		"wstr", $sSubKey, _
		"int_ptr", 0)
	if $ret[0] <> $ERROR_SUCCESS Then
		SetError(1)
		return 0
	EndIf
	
	SetError(0)
	Return($ret[3])
EndFunc

;===============================================================================
;
; Description:      Closes an open registry key, from an earlier _RegOpenKey call.
; Parameter(s):     $hKey    - Handle of key to close.
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Will Mooar
; Note(s):          None
;
;===============================================================================
Func _RegCloseKey( $hKey )
	Local $ret
	$ret = DllCall( _
		$advapi_dll, "int", "RegCloseKey", _
		"int", $hKey)

	if $ret[0] <> $ERROR_SUCCESS Then
		SetError(1)
		return 0
	EndIf
	
	if $advapi_dll_count>0 Then
		$advapi_dll_count -= 1
		if $advapi_dll_count = 0 then
			DllClose($advapi_dll)
		endif
	EndIf

	SetError(0)
	Return 1
EndFunc

;===============================================================================
;
; Description:      Retrieves a single SubKey name.
; Parameter(s):     $hKey    - Handle of parent key, from an earlier _RegOpenKey call.
;					$dwIndex - Index of subkey to retrieve.
; Requirement(s):   None
; Return Value(s):  On Success - Returns subkey name (or parent name if dwIndex=0)
;                   On Failure - ""  and sets @ERROR = 1
; Author(s):        Will Mooar
; Note(s):          You must call routine with $dwIndex=0 to start with to build
;					the list of subkeys.
;
;===============================================================================
Func _RegEnumKey( $hKey, $dwIndex )

	Local $strKey = ""
	Local $cbKeyLen = 256
	Local $i
	$strKey = "                "	;16 spaces
	While StringLen($strKey) < $cbKeyLen
		$strKey &= $strKey
	WEnd

	Local $ret
	$ret = DllCall( _
		$advapi_dll, "int", "RegEnumKeyW", _
		"int", $hKey, _
		"int", $dwIndex, _
		"wstr", $strKey, _
		"int", $cbKeyLen)

	if $ret[0] <> $ERROR_SUCCESS Then
		SetError(1)
		return ""
	EndIf

	$strKey = $ret[3]
	Return($strKey)
EndFunc

;===============================================================================
;
; Description:      Retrieves a list of all subkeys into an array (non-recursive).
; Parameter(s):     $sKey    - Parent Key to query, in same format as RegEnumKey.
; Requirement(s):   None
; Return Value(s):  On Success - Returns array containing subkeys, or 0 if none.
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Will Mooar
; Note(s):          None
;
;===============================================================================
Func _RegEnumKeys( $sKey )
	local $a[32], $ac = 0

	local $key = _RegOpenKey( $skey )
	Local $i = 0
	While 1
		Local $name = _RegEnumKey($key, $i)
		if $name = "" then ExitLoop
		
		if $i>0 then ;entry 0 is name of parent key
			if $ac >= ubound($a) Then
				redim $a[$ac*2]
			EndIf
			$a[$ac] = $name
			$ac += 1
		EndIf
	
		$i += 1
	WEnd
	_RegCloseKey($key)
	
	if $ac = 0 Then
		return 0
	EndIf
	
	redim $a[$ac]	;chop off unused portion of array
	return $a
EndFunc
