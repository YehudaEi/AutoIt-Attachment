#include-once
#include <Constants.au3>
#include <APIRegConstants.au3> ; custom addition
; ===============================================================================================================================
; Title:	_RegFunc
; Author:	LWC
;(until 2.0.7 - Erik Pilsits)
; Version:	2.1.0
; ===============================================================================================================================

;~ Global Const $REG_NONE = 0
;~ Global Const $REG_SZ = 1
;~ Global Const $REG_EXPAND_SZ = 2
;~ Global Const $REG_BINARY = 3
;~ Global Const $REG_DWORD = 4
;~ Global Const $REG_DWORD_BIG_ENDIAN = 5
;~ Global Const $REG_LINK = 6
;~ Global Const $REG_MULTI_SZ = 7
;~ Global Const $REG_RESOURCE_LIST = 8
;~ Global Const $REG_FULL_RESOURCE_DESCRIPTOR = 9
;~ Global Const $REG_RESOURCE_REQUIREMENTS_LIST = 10
;Global Const $REG_QWORD = 11 ; custom code

#cs
Global Const $HKEY_CLASSES_ROOT = 0x80000000
Global Const $HKEY_CURRENT_USER = 0x80000001
Global Const $HKEY_LOCAL_MACHINE = 0x80000002
Global Const $HKEY_USERS = 0x80000003
Global Const $HKEY_PERFORMANCE_DATA = 0x80000004
Global Const $HKEY_PERFORMANCE_TEXT = 0x80000050
Global Const $HKEY_PERFORMANCE_NLSTEXT = 0x80000060
Global Const $HKEY_CURRENT_CONFIG = 0x80000005
#ce

Global Const $HKEY_DYN_DATA = 0x80000006

#cs
Global Const $KEY_QUERY_VALUE = 0x0001
Global Const $KEY_SET_VALUE = 0x0002
Global Const $KEY_ENUMERATE_SUB_KEYS = 0x0008
#ce

Global Const $KEY_WRITE_short = 0x20006
Global Const $KEY_READ_short = 0x20019
Global Const $REG_OPTION_NON_VOLATILE_short = 0x0000
Global Const $REG_OPTION_VOLATILE_short = 0x0001

#cs
Global Const $KEY_WOW64_64KEY = 0x0100
Global Const $KEY_WOW64_32KEY = 0x0200
#ce

Global Const $__g_RF_Is64BitOS = (StringInStr(@OSArch, "64") <> 0)

#cs
	x64 Platforms:

	For all registry functions, the root key may be suffixed with either 32 or 64 to specify the
	particular registry view on which to operate.

	For example, HKLM32 will unconditionally reference the 32-bit registry view, while HKLM64 will
	unconditionally reference the 64-bit registry view.

	Examples:
		HKEY_LOCAL_MACHINE32
		HKEY_CURRENT_USER64
		HKU32
#ce

; #FUNCTION# ====================================================================================================
; Name...........:	_RegRead
; Description....:	Read a registry value.
; Syntax.........:	_RegRead($szKey, $szValue)
; Parameters.....:	$szKey		- Source key
;					$szValue	- Source value (Empty string for Default value)
;
; Return values..:	Success - Requested data and value type in @extended
;							| Values with no formal type are returned as binary data
;							| REG_MULTI_SZ is returned as CRLF delimited substrings
;					Failure - 0 and sets @error
;							| 1 - Invalid root key
;							| 2 - Failed to open source key (@extended contains RegOpenKeyExW return value)
;							| 3 - Unsupported value type
;							| 4 - Failed to read source value (@extended contains RegQueryValueExW return value)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegRead($szKey, $szValue, $multiszAsBinary = False)
	Local $hKey = _RegOpenKey($szKey, $KEY_READ_short)
	If @error Then Return SetError(@error, @extended, 0)
	Local $ret = DllCall("advapi32.dll", "long", "RegQueryValueExW", "ulong_ptr", $hKey, "wstr", $szValue, "ptr", 0, "dword*", 0, "ptr", 0, "dword*", 0)
	If @error Or ($ret[0] <> 0) Then
		DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
		If IsArray($ret) Then
			Return SetError(4, $ret[0], 0)
		Else
			Return SetError(4, 0, 0)
		EndIf
	EndIf

	Local $iType = $ret[4], $iLen = $ret[6], $sType
	Switch $iType ; set type of value
		Case $REG_SZ, $REG_EXPAND_SZ
			$sType = "wchar"
			; iLen is byte length, if unicode string divide by 2
			; add terminating null for possibly incorrectly stored strings
			; handling of extra terminating NULLs is automatic by AutoIt 'wchar' type
			$iLen = ($iLen / 2) + 1
		Case $REG_MULTI_SZ
			; multiple string value, returned as binary data
			; iLen is byte length
			; returns binary data, post handling is necessary
			$sType = "byte"
		Case $REG_BINARY, $REG_NONE
			$sType = "byte"
		Case $REG_QWORD
			$sType = "int64"
			$iLen = $iLen / 8 ; int64 = 8 bytes
		Case $REG_DWORD
			$sType = "dword"
			$iLen = $iLen / 4 ; dword = 4 bytes
		Case 5, 6, 8, 9, 10
			; other uncommon value types, return as binary data
			$sType = "byte"
		Case Else
			; unknown type
			DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
			Return SetError(3, 0, 0)
	EndSwitch
	Local $lpData = DllStructCreate($sType & "[" & $iLen & "]")
	$ret = DllCall("advapi32.dll", "long", "RegQueryValueExW", "ulong_ptr", $hKey, "wstr", $szValue, "ptr", 0, "dword*", 0, _
			"ptr", DllStructGetPtr($lpData), "dword*", DllStructGetSize($lpData))
	DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
	If (Not IsArray($ret)) Or ($ret[0] <> 0) Then
		If IsArray($ret) Then
			Return SetError(4, $ret[0], 0)
		Else
			Return SetError(4, 0, 0)
		EndIf
	EndIf
	Local $data
	; special processing for REG_MULTI_SZ
	If $iType = $REG_MULTI_SZ Then
		; trim all terminating NULLs, convert to string
		; if no data, then return empty ""
		$data = _RegTrimBinary(DllStructGetData($lpData, 1), Binary("0x0000"))
		If $multiszAsBinary Then
			If $data Then $data &= Binary("0x00000000")
		Else
			If $data Then
				$data = StringReplace(BinaryToString($data, 2), ChrW(0), @CRLF)
			Else
				$data = ""
			EndIf
		EndIf
	Else
		; else just get our data
		$data = DllStructGetData($lpData, 1)
	EndIf
	Return SetError(0, $iType, $data)
EndFunc   ;==>_RegRead

Func _RegTrimBinary($data, $pattern)
	; trim a repeating binary pattern from the end of binary data
	; set starting point to pattern byte size from end (BinaryMid is 1-based, so decrement 1 byte less than pattern length)
	Local $pLen = BinaryLen($pattern)
	Local $start = BinaryLen($data) - ($pLen - 1)
	While 1
		If $start < 0 Then
			; if start is < 0, then there is no data left
			; set start to 0 (returns empty binary variant from BinaryMid) and exit loop
			$start = 0
			ExitLoop
		EndIf
		; test if a terminating null and decrement
		If BinaryMid($data, $start, $pLen) = $pattern Then
			$start -= $pLen
		Else
			; found data, increment one byte
			$start += ($pLen - 1)
			ExitLoop
		EndIf
	WEnd
	; get data
	Return BinaryMid($data, 1, $start)
EndFunc   ;==>_RegTrimBinary

; #FUNCTION# ====================================================================================================
; Name...........:	_RegWrite
; Description....:	Create a registry key or value.
; Syntax.........:	_RegWrite($szKey[, $szValue = ""[, $iType = -1[, $bData = Default[, $dwOptions = $REG_OPTION_NON_VOLATILE_short]]]])
; Parameters.....:	$szKey		- Destination key
;					$szValue	- [Optional] Destination value (Empty string for Default value, must also supply $iType and $bData)
;					$iType		- [Optional] Type of data to write to $szValue ($iType < 0 writes key only)
;					$bData		- [Optional] Data to write to $szValue ($bData = Default creates key only)
;					$dwOptions	- [Optional] Optional flags (can be $REG_OPTION_NON_VOLATILE_short or $REG_OPTION_VOLATILE_short)
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							| 1 - Invalid root key
;							| 2 - Failed to open / create destination key (@extended contains RegCreateKeyExW return value)
;							| 3 - Unsupported value type
;							| 4 - Failed to write data (@extended contains RegSetValueExW return value)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:	Provide REG_MULTI_SZ values as a single string made up of CRLF or LF separated substrings (as returned from
;					AutoIt native RegRead), or as UTF16LE binary data with NULL separated substrings.
;					Terminating NULLs for all string data types are correctly appended by the function.
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegWrite($szKey, $szValue = "", $iType = -1, $bData = Default, $dwOptions = $REG_OPTION_NON_VOLATILE_short)
	Local $hKey = _RegOpenKey($szKey, $KEY_WRITE_short, False, $dwOptions) ; open using RegCreateKeyExW
	If @error Then Return SetError(@error, @extended, 0)
	Local $lpData
	If $iType >= 0 And $bData <> Default Then
		Switch $iType
			; handle strings as binary data, make sure they are properly terminated
			Case $REG_SZ, $REG_EXPAND_SZ
				If VarGetType($bData) <> "Binary" Then $bData = StringToBinary($bData, 2) ; UTF16LE
				$bData = _RegTrimBinary($bData, "0x0000") & Binary("0x0000") ; add terminating null
				$lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
			Case $REG_MULTI_SZ
				If VarGetType($bData) <> "Binary" Then $bData = StringToBinary(StringReplace(StringStripCR($bData), @LF, ChrW(0)), 2) ; UTF16LE
				$bData = _RegTrimBinary($bData, "0x0000") & Binary("0x00000000") ; add 2 terminating nulls
				$lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
			Case $REG_DWORD
				$lpData = DllStructCreate("dword")
			Case $REG_QWORD
				$lpData = DllStructCreate("int64")
			Case $REG_BINARY, $REG_NONE
				$lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
			Case 5, 6, 8, 9, 10
				; other uncommon value types
				$lpData = DllStructCreate("byte[" & BinaryLen($bData) & "]")
			Case Else
				DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
				Return SetError(3, 0, 0)
		EndSwitch
		DllStructSetData($lpData, 1, $bData)
		Local $ret = DllCall("advapi32.dll", "long", "RegSetValueExW", "ulong_ptr", $hKey, "wstr", $szValue, "dword", 0, "dword", $iType, _
				"ptr", DllStructGetPtr($lpData), "dword", DllStructGetSize($lpData))
		If @error Or ($ret[0] <> 0) Then
			If IsArray($ret) Then
				Return SetError(4, $ret[0], 0)
			Else
				Return SetError(4, 0, 0)
			EndIf
		EndIf
	EndIf
	DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
	Return SetError(0, 0, 1)
EndFunc   ;==>_RegWrite

; #FUNCTION# ====================================================================================================
; Name...........:	_RegDelete
; Description....:	Delete a key (recursively) or value
; Syntax.........:	_RegDelete($szKey[, $szValue = Default])
; Parameters.....:	$szKey		- Key to delete
;					$szValue	- [Optional] Value to delete (Default to recursively delete the key)
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							|-2 - Cannot delete a root key
;							|-1 - Target key / value does not exist
;							| 1 - Invalid root key
;							| 2 - Failed to open subkey (@extended contains RegOpenKeyExW return value)
;							| 3 - Failed to delete key / value (@extended contains RegDelete* return value)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegDelete($szKey, $szValue = Default)
	If $szValue = Default Then
		If Not _RegKeyExists($szKey) Then Return SetError(-1, 0, 0)
		; recursively delete keys
		Local $key
		While 1
			$key = _RegEnumKey($szKey, 0) ; removing keys, so always enum index 0
			If @error Then ExitLoop ; no more keys
			_RegDelete($szKey & "\" & $key) ; recurse
			If @error Then Return SetError(@error, @extended, 0) ; avoid infinite loop on recursion error
		WEnd
		_RegDeleteKey($szKey)
		If @error Then Return SetError(@error, @extended, 0)
		Return SetError(0, 0, 1)
	Else
		If Not _RegValueExists($szKey, $szValue) Then Return SetError(-1, 0, 0)
		; delete value
		_RegDeleteValue($szKey, $szValue)
		If @error Then Return SetError(@error, @extended, 0)
		Return SetError(0, 0, 1)
	EndIf
EndFunc   ;==>_RegDelete

Func _RegDeleteKey($szKey)
	Local $parentKey = StringLeft($szKey, StringInStr($szKey, "\", 0, -1) - 1)
	If $parentKey = "" Then Return SetError(-2, 0, 0) ; cannot delete root key
	Local $szSubkey = StringTrimLeft($szKey, StringLen($parentKey) + 1)
	Local $hKey = _RegOpenKey($parentKey, $KEY_READ_short)
	If @error Then Return SetError(@error, @extended, 0)
	; check compatibility
	; RegDeleteKeyExW does not exist on XP 32-bit and lower or lower than Server 2003 SP1
	; it is not needed at all on 32-bit OS's, so make decision based on that
	If $__g_RF_Is64BitOS Then
		Local $ret = DllCall("advapi32.dll", "long", "RegDeleteKeyExW", "ptr", $hKey, "wstr", $szSubkey, "long", @extended, "dword", 0)
	Else
		Local $ret = DllCall("advapi32.dll", "long", "RegDeleteKeyW", "ptr", $hKey, "wstr", $szSubkey)
	EndIf
	DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
	If (Not IsArray($ret)) Or ($ret[0] <> 0) Then
		If IsArray($ret) Then
			Return SetError(3, $ret[0], 0)
		Else
			Return SetError(3, 0, 0)
		EndIf
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_RegDeleteKey

Func _RegDeleteValue($szKey, $szValue)
	Local $hKey = _RegOpenKey($szKey, $KEY_WRITE_short)
	If @error Then Return SetError(@error, @extended, 0)
	Local $ret = DllCall("advapi32.dll", "long", "RegDeleteValueW", "ptr", $hKey, "wstr", $szValue)
	DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
	If (Not IsArray($ret)) Or ($ret[0] <> 0) Then
		If IsArray($ret) Then
			Return SetError(3, $ret[0], 0)
		Else
			Return SetError(3, 0, 0)
		EndIf
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_RegDeleteValue

; #FUNCTION# ====================================================================================================
; Name...........:	_RegEnumKey
; Description....:	Enumerate subkeys of the specified key
; Syntax.........:	_RegEnumKey($szKey, $iIndex)
; Parameters.....:	$szKey	- Parent key
;					$iIndex	- 0-based key instance to retrieve
;
; Return values..:	Success - Requested registry key name (name only, not full path)
;					Failure - 0 and sets @error
;							| 1 - Invalid root key
;							| 2 - Failed to open key (@extended contains RegOpenKeyExW return value)
;							| 3 - Key index out of range (@extended contains RegEnumKeyExW return value)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegEnumKey($szKey, $iIndex)
	Local $hKey = _RegOpenKey($szKey, $KEY_READ_short)
	If @error Then Return SetError(@error, @extended, 0)
	Local $ret = DllCall("advapi32.dll", "long", "RegEnumKeyExW", "ptr", $hKey, "dword", $iIndex, "wstr", "", "dword*", 1024, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0)
	DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
	If (Not IsArray($ret)) Or ($ret[0] <> 0) Then
		If IsArray($ret) Then
			Return SetError(3, $ret[0], 0)
		Else
			Return SetError(3, 0, 0)
		EndIf
	EndIf
	Return SetError(0, 0, $ret[3])
EndFunc   ;==>_RegEnumKey

; #FUNCTION# ====================================================================================================
; Name...........:	_RegEnumValue
; Description....:	Enumerate values of the specified key
; Syntax.........:	_RegEnumValue($szKey, $iIndex)
; Parameters.....:	$szKey	- Parent key
;					$iIndex	- 0-based value instance to retrieve
;
; Return values..:	Success - Requested registry value
;					Failure - 0 and sets @error
;							| 1 - Invalid root key
;							| 2 - Failed to open key (@extended contains RegOpenKeyExW return value)
;							| 3 - Value index out of range (@extended contains RegEnumValueW return value)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegEnumValue($szKey, $iIndex)
	Local $hKey = _RegOpenKey($szKey, $KEY_READ_short)
	If @error Then Return SetError(@error, @extended, 0)
	Local $ret = DllCall("advapi32.dll", "long", "RegEnumValueW", "ptr", $hKey, "dword", $iIndex, "wstr", "", "dword*", 1024, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0)
	DllCall("advapi32.dll", "long", "RegCloseKey", "ulong_ptr", $hKey)
	If (Not IsArray($ret)) Or ($ret[0] <> 0) Then
		If IsArray($ret) Then
			Return SetError(3, $ret[0], 0)
		Else
			Return SetError(3, 0, 0)
		EndIf
	EndIf
	Return SetError(0, 0, $ret[3])
EndFunc   ;==>_RegEnumValue

; #FUNCTION# ====================================================================================================
; Name...........:	_RegKeyExists
; Description....:	Test for the existence of a registry key
; Syntax.........:	_RegKeyExists($s_key)
; Parameters.....:	$s_key	- Key to test
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							| 1 - Root key does not exist
;							| 2 - Target key does not exist
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegKeyExists($s_key)
	_RegRead($s_key, "") ; try to read default value
	Switch @error
		Case 1, 2
			; invalid root key | failed to open key
			Return SetError(@error, 0, 0)
		Case Else
			; key exists
			Return SetError(0, 0, 1)
	EndSwitch
EndFunc   ;==>_RegKeyExists

; #FUNCTION# ====================================================================================================
; Name...........:	_RegValueExists
; Description....:	Test for the existence of a registry value
; Syntax.........:	_RegValueExists($s_key, $s_val)
; Parameters.....:	$s_key	- Source key
;					$s_val	- Value to test
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							| 1 - Root key does not exist
;							| 2 - Target key does not exist
;							| 4 - Target value does not exist
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegValueExists($s_key, $s_val)
	_RegRead($s_key, $s_val)
	; @error = 3 is 'unsupported value type', implying value still exists
	Switch @error
		Case 1, 2, 4
			; invalid root key | failed to open key | failed to read value
			Return SetError(@error, 0, 0)
		Case Else
			Return SetError(0, 0, 1)
	EndSwitch
EndFunc   ;==>_RegValueExists

; #FUNCTION# ====================================================================================================
; Name...........:	_RegCopyKey
; Description....:	Recursively copy a registry key, including all subkeys and values
; Syntax.........:	_RegCopyKey($s_key, $d_key)
; Parameters.....:	$s_key	- Source key
;					$d_key	- Destination key
;					$delete	- [Internal]
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							|-1 - Source and destination keys are the same
;							| 1 - Source does not exist
;							| 2 - Failed to write destination key (@extended contains _RegWrite error code)
;							| 3 - Failed to read one or more values from source key or subkey(s)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegCopyKey($s_key, $d_key, $delete = False)
	If $s_key = $d_key Then Return SetError(-1, 0, 0) ; destination is the same as source
	If Not _RegKeyExists($s_key) Then Return SetError(1, 0, 0)
	_RegWrite($d_key) ; write destination key in case source key empty
	If @error Then Return SetError(2, @error, 0)
	; value loop
	Local $i = 0, $val, $data, $err = 0
	While 1
		$val = _RegEnumValue($s_key, $i)
		If @error Then ExitLoop ; no more values
		_RegCopyValue($s_key, $val, $d_key)
		If @error Then
			$err = 3
			ContinueLoop ; some error reading value, skip it
		EndIf
		$i += 1
	WEnd
	; key loop
	Local $key
	$i = 0
	While 1
		$key = _RegEnumKey($s_key, $i)
		If @error Then ExitLoop ; no more keys
		_RegCopyKey($s_key & "\" & $key, $d_key & "\" & $key) ; recurse
		If @error = 3 Then $err = 3 ; test for errors reading subkey values
		$i += 1
	WEnd
	If $err Then Return SetError($err, 0, 0) ; error(s) reading value(s) or subkey value(s)
	; move key
	If $delete Then
		; delete source key only if copy was entirely successful
		_RegDelete($s_key)
		If @error Then Return SetError(4, @error, 0) ; error deleting source key
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_RegCopyKey

; #FUNCTION# ====================================================================================================
; Name...........:	_RegMoveKey
; Description....:	Move a registry key, including all subkeys and values
; Syntax.........:	_RegMoveKey($s_key, $d_key)
; Parameters.....:	$s_key	- Source key
;					$d_key	- Destination key
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							|-1 - Source and destination keys are the same
;							| 1 - Source does not exist
;							| 2 - Failed to write destination key (@extended contains _RegWrite error code)
;							| 3 - Failed to read one or more values from source key or subkey(s)
;							| 4 - Failed to delete source key (@extended contains _RegDelete error code)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegMoveKey($s_key, $d_key)
	Local $ret = _RegCopyKey($s_key, $d_key, True)
	Return SetError(@error, @extended, $ret)
EndFunc   ;==>_RegMoveKey

; #FUNCTION# ====================================================================================================
; Name...........:	_RegCopyValue
; Description....:	Copy a single registry value
; Syntax.........:	_RegCopyValue($s_key, $s_val[, $d_key = Default[, $d_val = Default]])
; Parameters.....:	$s_key	- Source key
;					$s_val	- Source value
;					$d_key	- [Optional] Destination key (Default to use Source key)
;					$d_val	- [Optional] Destination value (Default to use Source value)
;					$delete	- [Internal]
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							|-1 - Source and destination are the same
;							| 1 - Source value does not exist
;							| 2 - Failed to read source value (@extended contains _RegRead error code)
;							| 3 - Failed to write destination value (@extended contains _RegWrite error code)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegCopyValue($s_key, $s_val, $d_key = Default, $d_val = Default, $delete = False)
	If $d_key = Default Then $d_key = $s_key ; set destination key to source key
	If $d_val = Default Then $d_val = $s_val ; set destination value to source value
	If $s_key = $d_key And $s_val = $d_val Then Return SetError(-1, 0, 0) ; destination is the same as source
	If Not _RegValueExists($s_key, $s_val) Then Return SetError(1, 0, 0)
	Local $data = _RegRead($s_key, $s_val)
	If @error Then Return SetError(2, @error, 0) ; error reading value
	_RegWrite($d_key, $d_val, @extended, $data)
	If @error Then Return SetError(3, @error, 0) ; error writing destination value
	If $delete Then
		; delete source value only if copy was successful
		_RegDelete($s_key, $s_val)
		If @error Then Return SetError(4, @error, 0) ; error deleting source value
	EndIf
	Return SetError(0, 0, 1)
EndFunc   ;==>_RegCopyValue

; #FUNCTION# ====================================================================================================
; Name...........:	_RegMoveValue
; Description....:	Move a single registry value
; Syntax.........:	_RegMoveValue($s_key, $s_val[, $d_key = Default[, $d_val = Default]])
; Parameters.....:	$s_key	- Source key
;					$s_val	- Source value
;					$d_key	- [Optional] Destination key (Default to use Source key)
;					$d_val	- [Optional] Destination value (Default to use Source value)
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							|-1 - Source and destination are the same
;							| 1 - Source value does not exist
;							| 2 - Failed to read source value (@extended contains _RegRead error code)
;							| 3 - Failed to write destination value (@extended contains _RegWrite error code)
;							| 4 - Failed to delete source value (@extended contains _RegDelete error code)
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegMoveValue($s_key, $s_val, $d_key = Default, $d_val = Default)
	Local $ret = _RegCopyValue($s_key, $s_val, $d_key, $d_val, True)
	Return SetError(@error, @extended, $ret)
EndFunc   ;==>_RegMoveValue

; #FUNCTION# ====================================================================================================
; Name...........:	_RegKeyEmpty
; Description....:	Test if a registry key is empty of all subkeys and values
; Syntax.........:	_RegKeyEmpty($s_key)
; Parameters.....:	$s_key	- Key to test
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							| 1 - Key contains subkeys
;							| 2 - Key contains values
;							| 3 - Key contains subkeys and values
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegKeyEmpty($s_key)
	Local $err = 3
	; check for keys
	_RegEnumKey($s_key, 0)
	If @error Then $err -= 1
	; check for values
	_RegEnumValue($s_key, 0)
	If @error Then $err -= 2
	If $err Then
		; not empty
		Return SetError($err, 0, 0)
	Else
		Return SetError(0, 0, 1)
	EndIf
EndFunc   ;==>_RegKeyEmpty

; #FUNCTION# ====================================================================================================
; Name...........:	_RegSubkeySearch
; Description....:	Search the subkeys of a registry key for the search term and return the index
; Syntax.........:	_RegSubkeySearch($s_key, $s_search[, $s_mode = 0[, $s_case = 0]])
; Parameters.....:	$s_key		- Key to search
;					$s_search	- Searchterm
;					$s_mode		- [Optional] Search mode: 0 - substring search, 1 - search from beginning of key
;					$s_case		- [Optional] Search case sense: 0 - case insensitive, 1 - case sensitive
;
; Return values..:	Success - Index of the subkey
;					Failure - 0
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegSubkeySearch($s_key, $s_search, $s_mode = 0, $s_case = 0)
	; success returns subkey index
	; failure returns 0
	Local $i = 0, $key, $string
	Local $len = StringLen($s_search)
	While 1
		$key = _RegEnumKey($s_key, $i)
		If @error Then Return 0 ; no more keys
		Switch $s_mode
			Case 0 ; substring
				If StringInStr($key, $s_search, $s_case) Then Return $i
			Case 1 ; beginning of string
				$string = StringLeft($key, $len)
				Switch $s_case
					Case 0 ; case insensitive
						If $string = $s_search Then Return $i
					Case 1 ; case sensitive
						If $string == $s_search Then Return $i
				EndSwitch
		EndSwitch
		$i += 1
	WEnd
EndFunc   ;==>_RegSubkeySearch

; #FUNCTION# ====================================================================================================
; Name...........:	_RegExport
; Description....:	Export a key including all subkeys and values, or a single value to a MS compatible REG file
; Syntax.........:	_RegExport($d_file, $s_key[, $s_val = Default[, $fFirstKey = True[, $hFile = -1]]])
; Parameters.....:	$d_file		- Destination exported REG file
;					$s_key		- Source key to be exported
;					$s_val		- [Optional] Source value (Default for recursive export, otherwise single value export)
;					$fFirstKey	- [Internal]
;					$hFile		- [Internal]
;
; Return values..:	Success - 1
;					Failure - 0 and sets @error
;							| 1 - Source key does not exist
;							| 2 - Source value does not exist
;							| 3 - Unable to create destination REG file
;							| 4 - Error reading one or more values
; Author.........:	Erik Pilsits
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _RegExport($d_file, $s_key, $s_val = Default, $fFirstKey = True, $hFile = -1)
	If Not _RegKeyExists($s_key) Then Return SetError(1, 0, 0)
	Local $data, $err = 0
	If $fFirstKey Then
		; first iteration, create new file
		$hFile = FileOpen($d_file, 2 + 32) ; create a new UTF16LE file
		If $hFile = -1 Then Return SetError(3, 0, 0)
		FileWriteLine($hFile, "Windows Registry Editor Version 5.00" & @CRLF)
		If $s_val <> Default Then
			; exporting only one value
			If Not _RegValueExists($s_key, $s_val) Then
				FileClose($hFile)
				Return SetError(2, 0, 0)
			EndIf
			; write base key
			FileWriteLine($hFile, @CRLF & "[" & _RegFormatHeader($s_key) & "]")
			$data = _RegRead($s_key, $s_val, True)
			If @error Then
				FileClose($hFile)
				Return SetError(4, 0, 0) ; unsupported value type
			EndIf
			Switch @extended
				Case $REG_LINK
					; unsupported value type
					FileClose($hFile)
					Return SetError(4, 0, 0)
				Case Else
					; format value
					If $s_val = "" Then $s_val = "@"
					; write data
					_RegWriteFile($hFile, $s_val, $data, @extended)
					FileClose($hFile)
					Return SetError(0, 0, 1)
			EndSwitch
		EndIf
	EndIf
	; write base key
	FileWriteLine($hFile, @CRLF & "[" & _RegFormatHeader($s_key) & "]")
	; value loop
	Local $i = -1, $val
	While 1
		$i += 1
		$val = _RegEnumValue($s_key, $i)
		If @error Then ExitLoop ; no more values
		$data = _RegRead($s_key, $val, True)
		If @error Then
			; unsupported value type
			$err = 4
			ContinueLoop
		EndIf
		Switch @extended
			Case $REG_LINK
				; unsupported value type
				$err = 4
				ContinueLoop
			Case Else
				; format value
				If $val = "" Then $val = "@"
				; write data
				_RegWriteFile($hFile, $val, $data, @extended)
		EndSwitch
	WEnd
	; key loop
	Local $key
	$i = -1
	While 1
		$i += 1
		$key = _RegEnumKey($s_key, $i)
		If @error Then ExitLoop ; no more keys
		; recurse
		_RegExport("", $s_key & "\" & $key, Default, False, $hFile)
		If @error Then $err = 4 ; catch recursion errors
	WEnd
	If $fFirstKey Then FileClose($hFile)
	Return SetError($err, 0, Number(Not $err))
EndFunc   ;==>_RegExport

Func _RegWriteFile($hFile, $val, $data, $type)
	If $val <> "@" Then $val = '"' & _RegEscape($val) & '"'
	;
	Switch $type
		Case $REG_NONE
			; returned as binary
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex(0):')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex(0):', StringLower($data)))
			EndIf
		Case $REG_SZ
			; returned as string, not NULL terminated
			FileWriteLine($hFile, $val & '="' & _RegEscape($data) & '"')
		Case $REG_EXPAND_SZ
			; returned as string, not NULL terminated
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex(2):00,00')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex(2):', StringLower(StringToBinary($data, 2)) & "0000"))
			EndIf
		Case $REG_BINARY
			; returned as binary
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex:')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex:', StringLower($data)))
			EndIf
		Case $REG_DWORD
			; returned as dword
			FileWriteLine($hFile, $val & "=dword:" & StringLower(Hex($data, 8)))
		Case $REG_DWORD_BIG_ENDIAN
			; returned as binary
			FileWriteLine($hFile, _RegFormatData($val & '=hex(5):', StringLower($data)))
		Case $REG_MULTI_SZ
			; returned as binary, double NULL terminated
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex(7):00,00')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex(7):', StringLower($data)))
			EndIf
		Case $REG_RESOURCE_LIST
			; returned as binary
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex(8):')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex(8):', StringLower($data)))
			EndIf
		Case $REG_FULL_RESOURCE_DESCRIPTOR
			; returned as binary
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex(9):')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex(9):', StringLower($data)))
			EndIf
		Case $REG_RESOURCE_REQUIREMENTS_LIST
			; returned as binary
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex(a):')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex(a):', StringLower($data)))
			EndIf
		Case $REG_QWORD
			; returned as qword
			If Not $data Then
				FileWriteLine($hFile, $val & '=hex(b):00,00,00,00,00,00,00,00')
			Else
				FileWriteLine($hFile, _RegFormatData($val & '=hex(b):', StringLower(Binary($data))))
			EndIf
	EndSwitch
EndFunc   ;==>_RegWriteFile

Func _RegEscape($string)
	Return StringRegExpReplace($string, '([\\"])', "\\${1}")
EndFunc   ;==>_RegEscape

Func _RegFormatData($prefix, $data)
	Local $temp = "", $temp2 = $prefix
	Local $j = 3, $len = StringLen($data)
	While $j < $len
		While $j < $len And StringLen($temp2) < 77
			$temp2 &= StringMid($data, $j, 2) & ","
			$j += 2
		WEnd
		$temp &= $temp2 & "\" & @CRLF
		$temp2 = "  "
	WEnd
	Return StringTrimRight($temp, 4)
EndFunc   ;==>_RegFormatData

Func _RegFormatHeader($szHeader)
	Local $szRoot = StringLeft($szHeader, StringInStr($szHeader, "\") - 1)
	If $szRoot = "" Then $szRoot = $szHeader ; passed root key
	$szHeader = StringTrimLeft($szHeader, StringLen($szRoot))
	Switch $szRoot
		Case "HKEY_LOCAL_MACHINE", "HKLM", "HKEY_LOCAL_MACHINE32", "HKLM32", "HKEY_LOCAL_MACHINE64", "HKLM64"
			$szRoot = "HKEY_LOCAL_MACHINE"
		Case "HKEY_USERS", "HKU", "HKEY_USERS32", "HKU32", "HKEY_USERS64", "HKU64"
			$szRoot = "HKEY_USERS"
		Case "HKEY_CURRENT_USER", "HKCU", "HKEY_CURRENT_USER32", "HKCU32", "HKEY_CURRENT_USER64", "HKCU64"
			$szRoot = "HKEY_CURRENT_USER"
		Case "HKEY_CLASSES_ROOT", "HKCR"
			$szRoot = "HKEY_CLASSES_ROOT"
		Case "HKEY_CURRENT_CONFIG", "HKCC"
			$szRoot = "HKEY_CURRENT_CONFIG"
		Case Else
			;
	EndSwitch
	Return $szRoot & $szHeader
EndFunc   ;==>_RegFormatHeader

Func _RegOpenKey($szKey, $iAccess, $fOpen = True, $dwOptions = $REG_OPTION_NON_VOLATILE_short)
	; $iView is set and returned because RegDeleteKeyEx takes the 32/64 registry view flag determined in this function
	Local $iView = 0
	Local $hRoot = StringLeft($szKey, StringInStr($szKey, "\") - 1)
	If $hRoot = "" Then $hRoot = $szKey ; passed a root key
	Switch $hRoot
		Case "HKEY_LOCAL_MACHINE", "HKLM"
			$hRoot = $HKEY_LOCAL_MACHINE
		Case "HKEY_LOCAL_MACHINE32", "HKLM32"
			$hRoot = $HKEY_LOCAL_MACHINE
			$iAccess = BitOR($iAccess, $KEY_WOW64_32KEY)
			$iView = $KEY_WOW64_32KEY
		Case "HKEY_LOCAL_MACHINE64", "HKLM64"
			$hRoot = $HKEY_LOCAL_MACHINE
			$iAccess = BitOR($iAccess, $KEY_WOW64_64KEY)
			$iView = $KEY_WOW64_64KEY
		Case "HKEY_USERS", "HKU"
			$hRoot = $HKEY_USERS
		Case "HKEY_USERS32", "HKU32"
			$hRoot = $HKEY_USERS
			$iAccess = BitOR($iAccess, $KEY_WOW64_32KEY)
			$iView = $KEY_WOW64_32KEY
		Case "HKEY_USERS64", "HKU64"
			$hRoot = $HKEY_USERS
			$iAccess = BitOR($iAccess, $KEY_WOW64_64KEY)
			$iView = $KEY_WOW64_64KEY
		Case "HKEY_CURRENT_USER", "HKCU"
			$hRoot = $HKEY_CURRENT_USER
		Case "HKEY_CURRENT_USER32", "HKCU32"
			$hRoot = $HKEY_CURRENT_USER
			$iAccess = BitOR($iAccess, $KEY_WOW64_32KEY)
			$iView = $KEY_WOW64_32KEY
		Case "HKEY_CURRENT_USER64", "HKCU64"
			$hRoot = $HKEY_CURRENT_USER
			$iAccess = BitOR($iAccess, $KEY_WOW64_64KEY)
			$iView = $KEY_WOW64_64KEY
		Case "HKEY_CLASSES_ROOT", "HKCR"
			$hRoot = $HKEY_CLASSES_ROOT
		Case "HKEY_CURRENT_CONFIG", "HKCC"
			$hRoot = $HKEY_CURRENT_CONFIG
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	Local $szSubkey = StringTrimLeft($szKey, StringInStr($szKey, "\"))
	If $szSubkey = $szKey Then $szSubkey = "" ; root key
	Local $ret
	If $fOpen Then
		; RegOpenKeyExW
		$ret = DllCall("advapi32.dll", "long", "RegOpenKeyExW", "ulong_ptr", $hRoot, "wstr", $szSubkey, "dword", 0, "ulong", $iAccess, "ulong_ptr*", 0)
		If @error Or ($ret[0] <> 0) Then
			If IsArray($ret) Then
				Return SetError(2, $ret[0], 0)
			Else
				Return SetError(2, 0, 0)
			EndIf
		EndIf
		Return SetError(0, $iView, $ret[5])
	Else
		; RegCreateKeyExW, really just for _RegWrite
		$ret = DllCall("advapi32.dll", "long", "RegCreateKeyExW", "ulong_ptr", $hRoot, "wstr", $szSubkey, "dword", 0, "ptr", 0, "dword", $dwOptions, _
				"ulong", $iAccess, "ptr", 0, "ulong_ptr*", 0, "ptr*", 0)
		If @error Or ($ret[0] <> 0) Then
			If IsArray($ret) Then
				Return SetError(2, $ret[0], 0)
			Else
				Return SetError(2, 0, 0)
			EndIf
		EndIf
		Return SetError(0, $iView, $ret[8])
	EndIf
EndFunc   ;==>_RegOpenKey

Func _TypeToString($iType)
	Local $sType
	Switch $iType
		Case $REG_NONE
			$sType = "REG_NONE"
		Case $REG_SZ
			$sType = "REG_SZ"
		Case $REG_EXPAND_SZ
			$sType = "REG_EXPAND_SZ"
		Case $REG_BINARY
			$sType = "REG_BINARY"
		Case $REG_DWORD
			$sType = "REG_DWORD"
		Case $REG_DWORD_BIG_ENDIAN
			$sType = "REG_DWORD_BIG_ENDIAN"
		Case $REG_LINK
			$sType = "REG_LINK"
		Case $REG_MULTI_SZ
			$sType = "REG_MULTI_SZ"
		Case $REG_RESOURCE_LIST
			$sType = "REG_RESOURCE_LIST"
		Case $REG_FULL_RESOURCE_DESCRIPTOR
			$sType = "REG_FULL_RESOURCE_DESCRIPTOR"
		Case $REG_RESOURCE_REQUIREMENTS_LIST
			$sType = "REG_RESOURCE_REQUIREMENTS_LIST"
		Case $REG_QWORD
			$sType = "REG_QWORD"
		Case Else
			$sType = "UNKNOWN"
	EndSwitch
	Return $sType
EndFunc   ;==>_TypeToString

;~ ;; EXAMPLE
;~ ; just create a key
;~ _RegWrite("HKCU\Software\AAB Test")
;~ ; sets the default value
;~ _RegWrite("HKCU\Software\AAA Test", "", $REG_SZ, "default value")
;~ $read = _RegRead("HKCU\Software\AAA Test", "")
;~ ConsoleWrite("Type:  " & _TypeToString(@extended) & @CRLF)
;~ ConsoleWrite("Data:  " & $read & @CRLF)
;~ ; writes an empty reg_none value
;~ _RegWrite("HKCU\Software\AAA Test", "value1", $REG_NONE, "")
;~ $read = _RegRead("HKCU\Software\AAA Test", "value1")
;~ ConsoleWrite("Type:  " & _TypeToString(@extended) & @CRLF)
;~ ConsoleWrite("Data:  " & $read & @CRLF)
;~ ; writes some string data as binary
;~ _RegWrite("HKCU\Software\AAA Test", "value2", $REG_BINARY, "test data")
;~ $read = _RegRead("HKCU\Software\AAA Test", "value2")
;~ ConsoleWrite("Type:  " & _TypeToString(@extended) & @CRLF)
;~ ConsoleWrite("Data:  " & $read & " (" & BinaryToString($read) & ")" & @CRLF)
;~ ; writes some binary data
;~ _RegWrite("HKCU\Software\AAA Test", "value3", $REG_BINARY, Binary("0x02000000"))
;~ $read = _RegRead("HKCU\Software\AAA Test", "value3")
;~ ConsoleWrite("Type:  " & _TypeToString(@extended) & @CRLF)
;~ ConsoleWrite("Data:  " & $read & @CRLF)
;~ ; write a string
;~ _RegWrite("HKCU\Software\AAA Test", "value4", $REG_SZ, "here is a string")
;~ $read = _RegRead("HKCU\Software\AAA Test", "value4")
;~ ConsoleWrite("Type:  " & _TypeToString(@extended) & @CRLF)
;~ ConsoleWrite("Data:  " & $read & @CRLF)
;~ ; write an integer
;~ _RegWrite("HKCU\Software\AAA Test", "value5", $REG_DWORD, 123456)
;~ $read = _RegRead("HKCU\Software\AAA Test", "value5")
;~ ConsoleWrite("Type:  " & _TypeToString(@extended) & @CRLF)
;~ ConsoleWrite("Data:  " & $read & @CRLF)
;~ ; delete the keys
;~ _RegDelete("HKCU\Software\AAB Test")
;~ _RegDelete("HKCU\Software\AAA Test")
