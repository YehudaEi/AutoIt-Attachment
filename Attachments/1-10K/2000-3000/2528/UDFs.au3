;===============================================================================
;
; Description:      lists all files and folders in a specified path (Similar to using Dir with the /B Switch)
; Syntax:           _FileList($sPath)

; Parameter(s):    	$sPath = Path to generate filelist for
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array containing the list of files and folders in the specified path
;					On Failure - Returns an empty string "" if no files are found and sets @Error to 1 if the path is not found
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):			The array returned is one-dimensional and is made up as follows:
;					$array[0] = Number of Files\Folders returned
;					$array[1] = 1st File\Folder
;					$array[2] = 2nd File\Folder
;					$array[3] = 3rd File\Folder
;					$array[n] = nth File\Folder
;===============================================================================
Func _FileList($sPath)
	Local $hSearch, $sFile, $asFileList[1]
	If Not FileExists($sPath) Then
		SetError(1)
		Return ""
	EndIf
	$asFileList[0] = 0
	$hSearch = FileFindFirstFile($sPath & "\*")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If $sFile = "." Or $sFile = ".." Then ContinueLoop
		ReDim $asFileList[UBound($asFileList) + 1]
		$asFileList[0] = $asFileList[0] + 1
		$asFileList[UBound($asFileList) - 1] = $sFile
	WEnd
	FileClose($hSearch)
	If $asFileList[0] = 0 Then Return ""
	Return $asFileList
EndFunc   ;==>_FileList

;===============================================================================
;
; Description:      lists all subkeys in a specified key
; Syntax:           _RegKeyList($sKey)

; Parameter(s):    	$sKey = Key to generate keylist for
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array containing the list of subkeys in the specified path
;					On Failure - Returns an empty string "" if no Keys are found and sets @Error to 1 if the key is not found
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):			The array returned is one-dimensional and is made up as follows:
;					$array[0] = Number of Keys returned
;					$array[1] = 1st Key
;					$array[2] = 2nd Key
;					$array[3] = 3rd Key
;					$array[n] = nth Key
;===============================================================================
Func _RegKeyList($sKey)
	Local $asKeys[1], $iN, $sCurrentKey
	$asKeys[0] = 0
	RegRead($sKey, "")
	If @error = 1 Then
		SetError(1)
		Return ""
	EndIf
	$asKeys[0] = 0
	While 1
		$iN = $iN + 1
		$sCurrentKey = RegEnumKey($sKey, $iN)
		If @error = -1 Then ExitLoop
		ReDim $asKeys[UBound($asKeys) + 1]
		$asKeys[0] = $asKeys[0] + 1
		$asKeys[UBound($asKeys) - 1] = $sCurrentKey
	WEnd
	If $asKeys[0] = 0 Then Return ""
	Return $asKeys
EndFunc   ;==>_RegKeyList

;===============================================================================
;
; Description:      lists the names of all values in a specified key
; Syntax:           _RegValueList($sKey)

; Parameter(s):    	$sKey = Key to generate valuelist for
; Requirement(s):   None
; Return Value(s):  On Success - Returns an array containing the list of values in the specified path
;					On Failure - Returns an empty string "" if no values are found and sets @Error to 1 if the key is not found
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):			The array returned is one-dimensional and is made up as follows:
;					$array[0] = Number of values returned
;					$array[1] = 1st value
;					$array[2] = 2nd value
;					$array[3] = 3rd value
;					$array[n] = nth value
;===============================================================================
Func _RegValueList($sKey)
	Local $asValues[1], $iN, $sCurrentValue
	$asValues[0] = 0
	RegRead($sKey, "")
	If @error = 1 Then
		SetError(1)
		Return ""
	EndIf
	$asValues[0] = 0
	While 1
		$iN = $iN + 1
		$sCurrentValue = RegEnumVal($sKey, $iN)
		If @error = -1 Then ExitLoop
		ReDim $asValues[UBound($asValues) + 1]
		$asValues[0] = $asValues[0] + 1
		$asValues[UBound($asValues) - 1] = $sCurrentValue
	WEnd
	If $asValues[0] = 0 Then Return ""
	Return $asValues
EndFunc   ;==>_RegValueList

