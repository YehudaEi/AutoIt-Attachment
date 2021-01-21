;===============================================================================
;
; Description:      Mounts a path as a drive
; Syntax:           _Mount($sPath, $sDrive)

; Parameter(s):     $sPath=Path to mount drive as
;					$sDrive=Drive To Mount as
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error = to a value depending on the error
;                   @Error=1 Drive already exists
;					@Error=2 Path does not exist
;					@Error=3 Error Mounting Drive
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):			$sDrive is in Format X: where X is the drive letter
;===============================================================================
Func _Mount($sPath, $sDrive)
	If FileExists($sDrive) Then
		SetError(1)
		Return 0
	EndIf
	If Not FileExists($sPath) Then
		
		SetError(2)
		Return 0
	EndIf
	RunWait("Subst " & $sDrive & ' "' & $sPath & '"', "", @SW_HIDE)
	If Not FileExists($sDrive) Then
		SetError(3)
		Return 0
	EndIf
EndFunc   ;==>_Mount
;===============================================================================
;
; Description:     UnMounts a drive mounted with _Mount()
; Syntax:           _Mount($sPath, $sDrive)

; Parameter(s):     $sDrive=Drive To UnMount
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @error = to a value depending on the error
;                   @Error=1 Drive does not exist
;					@Error=2 Error unmounting drive
;
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):			$sDrive is in Format X: where X is the drive letter
;===============================================================================
Func _UnMount($sDrive)
	If Not FileExists($sDrive) Then
		SetError(1)
		Return 0
	EndIf
	RunWait("Subst " & $sDrive & " /d", "", @SW_HIDE)
	If FileExists($sDrive) Then
		SetError(2)
		Return 0
	EndIf
EndFunc   ;==>_UnMount

;===============================================================================
;
; Description:      lists currently mounted drives
; Syntax:           _MountList()

; Parameter(s):    	None
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;					On Failure - Returns an empty string "" if no mounted drives are found
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):			The array returned is two-dimensional and is made up as follows:
;					$array[0][0] = Number of Drives\Paths returned
;					$array[1][0] = 1st Drive
;					$array[1][1] = 1st Path
;					$array[2][0] = 2nd Drive
;					$array[2][1] = 2nd Path
;					$array[n][0] = nth Drive
;					$array[n][1] = nth Path
;===============================================================================
Func _MountList()
	Local $hFile, $asDriveList[1][2], $iCurrentLine, $iLine, $sDriveLetter, $sPath, $asArray
	$asDriveList[0][0] = 0
	RunWait(@ComSpec & " /c SUBST > VDTEMP.DAT", @TempDir, @SW_HIDE)
	$hFile = FileOpen(@TempDir & "\VDTEMP.DAT", 0)
	If StringStripWS(FileReadLine($hFile, 1), 8) = "" Then
		FileClose($hFile)
		FileDelete(@TempDir & "\VDTEMP.DAT")
		Return ""
	EndIf
	While 1
		$iCurrentLine = $iCurrentLine + 1
		$sLine = FileReadLine($hFile, $iCurrentLine)
		If @error = -1 Then
			FileClose($hFile)
			FileDelete(@TempDir & "\VDTEMP.DAT")
			Return $asDriveList
		EndIf
		$sPath = StringStripWS(StringRight($sLine, StringLen($sLine) - StringInStr($sLine, "=>", 0, -1) - 1), 3)
		$sDriveLetter = StringStripWS(StringLeft($sLine, StringInStr($sLine, "=>", 0, 1) - 1), 3)
		ReDim $asDriveList[UBound($asDriveList) + 1][2]
		$asDriveList[0][0] = $asDriveList[0][0] + 1
		$asDriveList[UBound($asDriveList) - 1][0] = $sDriveLetter
		$asDriveList[UBound($asDriveList) - 1][1] = $sPath
	WEnd
EndFunc   ;==>_MountList





