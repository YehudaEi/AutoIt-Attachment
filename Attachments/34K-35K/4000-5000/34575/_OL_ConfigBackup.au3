#RequireAdmin
_OL_ConfigBackup("x", "C:\temp\OutlookBU")
MsgBox(64, "Outlook Config Backup","The backup returned with @error: " & @error)
ConsoleWrite(@error & @CRLF)

; #FUNCTION# ====================================================================================================================
; Name ..........: _OL_ConfigBackup
; Description ...: Backup the Outlook configuration (files, registry keys ...) to a specified location.
; Syntax.........: _OL_ConfigBackup($oOL, $sOL_BULocation[, $bOL_BUProfiles = True])
; Parameters ....: $oOL            - Outlook object returned by a preceding call to _OL_Open()
;                  $sOL_BULocation - Drive/Directory where the configuration should be written to. Will be created if necessary
;                  $bOL_BUReplace  - Optional: Deletes/recreates the backup location if it already exists (default = True)
;                  $bOL_BUProfiles - Optional: Backup all Outlook profiles with account information (default = True)
; Return values .: Success - 1
;                  Failure - Returns 0 and sets @error:
;                  |1 - Error creating directory $sOL_BULocation
;                  |2 - $sOL_BULocation already exists and $bOL_BUReplace is set to False
;                  |3 - Error removing directory $sOL_BULocation if $bOL_BUReplace is set to True
;                  |4 - Error creatingg directory $sOL_BULocation if $bOL_BUReplace is set to True
;                  |5 - Error running regedit.exe. Please see @extended for the exit code of regedit.exe
;                  |6 - No profile with a registry subkey "9375CFF0413111d3B88A00104B2A6676" could be found
; Author ........: water
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _OL_ConfigBackup($oOL, $sOL_BULocation, $bOL_BUReplace = True, $bOL_BUProfiles = True)

	Local $iOL_Result, $sOL_RegKey, $sOL_BUSubDir

	; Check backup location
	If Not FileExists($sOL_BULocation) Then
		If DirCreate($sOL_BULocation) = 0 Then Return SetError(1, 0, 0)
	ElseIf $bOL_BUReplace = False Then
		Return SetError(2, 0, 0)
	Else
		If DirRemove($sOL_BULocation, 1) = 0 Then Return SetError(3, 0, 0)
		If DirCreate($sOL_BULocation) = 0 Then Return SetError(4, 0, 0)
	EndIf

	; Backup Outlook profiles - http://social.msdn.microsoft.com/Forums/en-AU/vsto/thread/2F5E092B-B407-438D-88E1-BC5B99194007
	If $bOL_BUProfiles = True Then
		; Create subdirectory
		$sOL_BUSubDir = $sOL_BULocation & "\Profiles"
		DirCreate($sOL_BUSubDir)
		; Determine the registry key
		$sOL_RegKey = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles"
		$bOL_KEyFound = False
		For $iOL_Index = 1 To 99999
			$sOL_SubKey = RegEnumKey($sOL_RegKey, $iOL_Index)
			If @error <> 0 Then ExitLoop
			For $iOL_Index2 = 1 To 99999
				$sOL_SubSubKey = RegEnumKey($sOL_RegKey & "\" & $sOL_SubKey, $iOL_Index2)
				If @error <> 0 Then ExitLoop
				If $sOL_SubSubKey = "9375CFF0413111d3B88A00104B2A6676" Then
					$bOL_KEyFound = True
					$sOL_BUKey = $sOL_RegKey & "\" & $sOL_SubKey & "\" & $sOL_SubSubKey
					; Backup Outlook profile
					$iOL_Result = ShellExecuteWait('regedit.exe', '/e ' & $sOL_BUSubDir & '\' & $sOL_SubKey & '.reg "' & $sOL_BUKey & '"', @DesktopDir)
					If @error <> 0 Then Return SetError(5, $iOL_Result, 0)
					ExitLoop
				EndIf
			Next
		Next
		If $bOL_KEyFound = False Then Return SetError(6, 0, 0)
	EndIf

EndFunc   ;==>_OL_ConfigBackup