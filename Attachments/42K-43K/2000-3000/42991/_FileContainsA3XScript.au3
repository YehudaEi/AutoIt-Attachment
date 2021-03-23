#include-once
; ===========================================================================================================================
; <_FileContainsA3XScript.au3>
;
; Function to determine whether an executable contains a compiled AutoIt script as a binary resource,
;	and optionally return it.
; AutoIt v.3.3.10.0+ use embedded A3X script resources, whereas previous versions used Overlays.
;  (See <FilePEOverlayExtract.au3> for detecting previous versions)
;
; NOTE: If compiled script is compressed with an Exe compressor (UPX, MPRESS, etc),
;  the script itself may also be compressed, and the signature would not be valid.
;  This is the reason for the simpler (but not certain) _FileContainsScriptResource() function
;
; REQUIREMENTS: Win2000 + AutoIt v3.3.6.0+
;	NOTE: Surprisingly, PE32+ (x64) executable resource-reading works correctly on Windows 2000
;
; Functions:
;	_FileContainsScriptResource()	; Determins if exe contains a script resource (*possibly* an AutoIt script)
;	_FileContainsAutoItScript()		; Determines if exe contains a compiled AutoItScript resource; optionally returns it
;
; See also:
;	<A3XFileExtract.au3>			; Example of using this UDF
;	<_FileReadManifest.au3>			; Reads manifest from PE file, and/or associated 'exe.manifest' file
;	<_FileCheckWinPEFormat.au3>		; Various information regarding an executable
;	<_FileGetExecutableFormat.au3>	; Returns .EXE, .COM, or .PIF executable type (one API call)
;	<FilePEOverlayExtract.au3>		; Detects overlays in PE files (and also AutoIt A3X overlays)
;	<PEFileExplorer.au3>			; Reads and reports on PE file structure and resources
;	<_IsExecutable.au3>
;
; Author: Ascend4nt
; ===========================================================================================================================


; =================================================================================================================
; Func _FileContainsScriptResource($sFile)
;
; Function to determine whether an executable contains a binary-data script resource (RCDATA resource named "SCRIPT).
; Note that this function does NOT determine whether the script resource is a valid AutoIt-compiled A3X script
;  The primary reason this function exists is to do a simple surface test to determine if the resource
;  type that AutoIt uses happens to exist. It can be handy in cases where the entire executable
;  has been compressed with UPX, MPRESS, etc. This behavior is different from previous versions of
;  AutoIt in which the script was always an uncompressed Overlay regardless of executable compression.
;
; $sFile = full path/filename of .exe file to check for an embedded script resource.
;
; Returns:
;	Success: True/False with @error = 0
;	Failure: False with @error set:
;		@error =  1 = file does not exist
;		@error =  2 - 5 = DLLCall() return code
;		@error =  13+ = API call returned failure. See GetLastError
;
; Author: Ascend4nt
; =================================================================================================================

Func _FileContainsScriptResource($sFile)
	If Not FileExists($sFile) Then Return SetError(1, 0, False)
	Local $aRet, $hModule = 0, $bScriptResTypeFound = False

	; LOAD_LIBRARY_AS_DATAFILE = 0x02
	$aRet = DllCall('kernel32.dll', 'handle', 'LoadLibraryExW', 'wstr', $sFile, 'handle', 0, 'dword', 2)
	If @error Then Return SetError(@error, 0, False)
	If $aRet[0] = 0 Then Return SetError(13, 0, False)

	$hModule = $aRet[0]

	; Scripts in 3.3.10.0+ are stored as a raw data resource (RCDATA) with the name "SCRIPT". [RT_RCDATA = 10]
	$aRet = DllCall('kernel32.dll', 'handle', 'FindResourceW', 'handle', $hModule, "wstr", "SCRIPT", "ulong_ptr", 10)
	If Not @error And $aRet[0] <> 0 Then
		$bScriptResTypeFound = True
	EndIf

	Local $iErr = @error
	DllCall('kernel32.dll', 'bool', 'FreeLibrary', 'handle', $hModule)

	If $iErr Then Return SetError($iErr, 0, False)
	; API call returne failure. Resource-not-found?
	If $aRet[0] = 0 Then
		$aRet = DllCall('kernel32.dll', 'dword', 'GetLastError')
		If @error Then Return SetError(14, 0, False)

		; ERROR_RESOURCE_TYPE_NOT_FOUND = 1813, ERROR_RESOURCE_NAME_NOT_FOUND = 1814
		If $aRet[0] = 1813 Or $aRet[0] = 1814 Then Return False

		; Otherwise, unknown problem
		Return SetError(14, 0, False)
	EndIf

	Return True
EndFunc


; =================================================================================================================
; Func _FileContainsA3XScript($sFile, $bRetAsBinary = False)
;
; Function to determine whether an executable contains a compiled AutoIt script as a resource
;  Returns the A3X script if $bRetAsBinary is true.
;
; $sFile = full path/filename of .exe file to check for an embedded script resource.
; $bRetAsBinary = If True/non-zero, returns the A3X script resource as binary data
;
; Returns:
;	Success: Depends on setting of $bRetAsBinary:
;	  $bRetAsBinary = True/non-zero:
;		If script resource not found, returns ''
;		If script resource found, returns binary data containing the A3X script, @extended = size
;	  $bRetAsBinary = False/0:
;		returns True/False, @extended = size of A3X resource (or 0 if False)
;
;	Failure: '' with @error set:
;		@error =  1 = file does not exist
;		@error =  2 - 5 = DLLCall() return code
;		@error =  13+ = API call returned failure. See GetLastError
;
; Author: Ascend4nt
; =================================================================================================================

Func _FileContainsA3XScript($sFile, $bRetAsBinary = False)
	Local $aRet, $hModule = 0, $hResInfo, $hResource, $iResSz, $binResData
	Local $bIsA3X = False, $vFalseRet = False

	If $bRetAsBinary Then $vFalseRet = ''

	If Not FileExists($sFile) Then Return SetError(1, 0, $vFalseRet)

	; Once-over loop to deal with scope-exit issue (FreeLibrary call)
	Do
		; LOAD_LIBRARY_AS_DATAFILE = 0x02
		$aRet = DllCall('kernel32.dll', 'handle', 'LoadLibraryExW', 'wstr', $sFile, 'handle', 0, 'dword', 2)
		If @error Then ExitLoop
		If $aRet[0] = 0 Then
			SetError(13)
			ExitLoop
		EndIf

		$hModule = $aRet[0]

		; Scripts in 3.3.10.0+ are stored as a raw data resource (RCDATA) with the name "SCRIPT". [RT_RCDATA = 10]
		$aRet = DllCall('kernel32.dll', 'handle', 'FindResourceW', 'handle', $hModule, "wstr", "SCRIPT", "ulong_ptr", 10)
		If @error Then ExitLoop
		If $aRet[0] = 0 Then
			SetError(14)
			ExitLoop
		EndIf

		$hResInfo = $aRet[0]

		$aRet = DllCall('kernel32.dll', 'dword', 'SizeofResource', 'handle', $hModule, 'handle', $hResInfo)
		If @error Then ExitLoop
		If $aRet[0] = 0 Then
			SetError(15)
			ExitLoop
		EndIf

		$iResSz = $aRet[0]

		$aRet = DllCall('kernel32.dll', 'handle', 'LoadResource', 'handle', $hModule, 'handle', $hResInfo)
		If @error Then ExitLoop
		If $aRet[0] = 0 Then
			SetError(16)
			ExitLoop
		EndIf

		$hResource = $aRet[0]

		$aRet = DllCall('kernel32.dll', 'ptr', 'LockResource', 'handle', $hResource)
		If @error Then ExitLoop
		If $aRet[0] = 0 Then
			SetError(17)
			ExitLoop
		EndIf
		; !IS_INTRESOURCE() ; can't recall why this needs to be checked after LockResource?
		If Number($aRet[0]) < 65536 Then
			SetError(18)
			ExitLoop
		EndIf

;~ 		ConsoleWrite("SizeofResource:" & $iResSz & ", LockResource return:" & $aRet[0] & @LF)

		; Get access to the memory via DLLStruct, and copy the binary before the memory becomes invalid
		$binResData = DllStructGetData(DllStructCreate("byte[" & $iResSz & ']', $aRet[0]), 1)
	Until True

	; Preserve error/extended codes in case bad exit from loop
	Local $iErr = @error, $iExt = @extended

	; Free the library (scope exit guarantee)
	If $hModule <> 0 Then
		DllCall('kernel32.dll', 'bool', 'FreeLibrary', 'handle', $hModule)
	EndIf

	If $iErr Then
		; API call returne failure. Resource-not-found?
		If $iErr = 14 Then
			$aRet = DllCall('kernel32.dll', 'dword', 'GetLastError')
			If @error Then Return SetError(14, 0, $vFalseRet)
			; ConsoleWrite("GetLastError = " & $aRet[0] & @CRLF)

			; ERROR_RESOURCE_TYPE_NOT_FOUND = 1813, ERROR_RESOURCE_NAME_NOT_FOUND = 1814
			If $aRet[0] = 1813 Or $aRet[0] = 1814 Then Return $vFalseRet

			; Otherwise, unknown problem.. fall through to regular error-return
		EndIf
		Return SetError($iErr, $iExt, $vFalseRet)
	EndIf

;~ 	The data is good - one final check for signature..

	; AutoIt2, 3 & AutoHotkey signatures are the same initial 16 bytes,
	; but AutoIt3 signatures follow it with "AU3!".  Should check what AutoIt2/AutoHK use for next 4-8 bytes..
	If BinaryMid($binResData, 1, 16) = "0xA3484BBE986C4AA9994C530A86D6487D" Or _
	   BinaryMid($binResData, 1 + 16, 4) = "0x41553321" Then	; "AU3!"

		$bIsA3X = True
		;ConsoleWrite("AutoIt overlay file found" & @CRLF)
	EndIf

	; Sort out the type of data to return
	If $bIsA3X Then
		; Return size in @extended regardless of whether binary data was requested
		SetExtended($iResSz)

		If $bRetAsBinary Then
			Return $binResData
		Else
			Return True
		EndIf
	Else
		Return $vFalseRet
	EndIf
EndFunc
