;
; _regClone()
; Clones an entire registry key to another location.
;
; Requirements:
;   AutoIt v3.1.1.56 or later
;
; Syntax:
;   _regClone($srcKey, $tgtKey)
;
; Parameters:
;   *  $srcKey: location of key to clone.
;   *  $tgtKey: location of cloned key.
;
; Examples:
;   *  _regClone("HKLM\Software\AutoIt v3", "HKLM\Software\AutoIt v3 Backup")
;   *  _regClone("HKCU\Software\Adobe", "HKCU\Software\AdobeBackup")
;
; @error return values:
;   *  0: success
;   *  1: could not write to target sub/key
;   *  2: could not read from source sub/key
;
; Author:
;   Alex Peters, 9/7/2005
;
; Notes:
;   *  The _regClone() function calls itself recursively to clone subkeys. If
;      renaming the function then be sure to update the function's code to
;      reflect this name change.
; ____________________________________________________________________________

func _regClone($srcKey, $tgtKey)

	; Create target key (necessary if source key is empty).
	if (regWrite($tgtKey) = 0) then
		setError(1)
		return
	endIf

	; Enumerate source key's values and write them to the target key.
	local $valIdx = 1
	while (1)
		local $valName = regEnumVal($srcKey, $valIdx)
		; There are no more values if @error = -1.
		if (@error = -1) then exitLoop
		; The source key could not be read if @error = 1.
		if (@error = 1) then
			setError(2)
			return
		endIf
		local $valData = regRead($srcKey, $valName)
		local $valType
		select
			case @extended = 1
				$valType = "REG_SZ"
			case @extended = 2
				$valType = "REG_EXPAND_SZ"
			case @extended = 3
				$valType = "REG_BINARY"
			case @extended = 4
				$valType = "REG_DWORD"
			case @extended = 7
				$valType = "REG_MULTI_SZ"
		endSelect
		if (regWrite($tgtKey, $valName, $valType, $valData) = 0) then
			setError(1)
			return
		endIf
		$valIdx = $valIdx + 1
	wEnd

	; Enumerate source key's subkeys and write them to the target key.
	local $subkeyIdx = 1
	while (1)
		local $subkey = "\" & regEnumKey($srcKey, $subkeyIdx)
		; @error = -1 if there are no more subkeys.
		if (@error = -1) then exitLoop
		; @error = 1 if the key could not be read.
		if (@error = 1) then
			setError(2)
			return
		endIf
		_regClone($srcKey & $subkey, $tgtKey & $subkey)
		; Propagate any error back to the caller.
		if (@error) then
			setError(@error)
			return
		endIf
		$subkeyIdx = $subkeyIdx + 1
	wEnd

endFunc