#include-once
#include <Misc.au3>
#include <Math.au3>
#include <Array.au3>

Local Const $sUEVer = "1.0"
Local $sTitle = "UpdateEngine v" & $sUEVer
Local $sVer = "0.0.0.0"
Local $iUpdate = 0
Local $iProgress = 1
Local $iUNC = 0
Local $iExit = 0
Local $sRemoteDir = ""
Local $sRemoteFile = ""
Local $sLocalDir = @DesktopDir
Local $sLocalFile = ""
Local $sIniFile = ""
Local $sIniID = "update"
Local $iUpInfo = 0
Local $sUpVer = $sVer
Local $sUpDo = $iUpdate
Local $sUpComments = ""
Local $aUpFile = $sRemoteDir

; #FUNCTION# ====================================================================================================================
; Name ..........: _UpdateEngine_FileCopy
; Description ...: Copies a file using the built-in Windows dialog.
; Syntax ........: _UpdateEngine_FileCopy($fromFile, $tofile)
; Parameters ....: $sFromFile            - The file/folder to copy.
;                  $sToDir               - The directory to copy the item into.
; Return values .: None
; Author ........: Yashied
; Modified ......: 08.08.13
; Remarks .......: According to Microsoft's documentation, multiple files may be copied using this method (using a FolderItems
;                  object), but I am not savvy enough to figure out the syntax for that operation.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UpdateEngine_FileCopy($sFromFile, $sToDir)
	Local $FOF_RESPOND_YES = 16
	Local $FOF_SIMPLEPROGRESS = 256
	$oWShell = ObjCreate("shell.application")
	$oWShell.namespace($sToDir).CopyHere($sFromFile, $FOF_RESPOND_YES)
EndFunc   ;==>_UpdateEngine_FileCopy

; #FUNCTION# ====================================================================================================================
; Name ..........: _UpdateEngine_ConvertFileSize
; Description ...: An analogue of StrFormatByteSize.
; Syntax ........: _UpdateEngine_ConvertFileSize($iBytes)
; Parameters ....: $iBytes              - A number of bytes.
; Return values .: The converted bytes with suffix added (KB, MB, GB, TB).
; Author ........: AZJIO
; Modified ......: 11.06.11
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/134562-convertfilesize/?p=938184
; Example .......: No
; ===============================================================================================================================
Func _UpdateEngine_ConvertFileSize($iBytes) ; by AZJIO
	Local Const $iConst = 0.0000234375 ; (1024 / 1000 - 1) / 1024
	Switch $iBytes
		Case 110154232090684 To 1125323453007766
			$iBytes = Round($iBytes / (1099511627776 + $iBytes * $iConst)) & ' TB'
		Case 1098948684577 To 110154232090683
			$iBytes = Round($iBytes / (1099511627776 + $iBytes * $iConst), 1) & ' TB'
		Case 107572492277 To 1098948684576
			$iBytes = Round($iBytes / (1073741824 + $iBytes * $iConst)) & ' GB'
		Case 1073192075 To 107572492276
			$iBytes = Round($iBytes / (1073741824 + $iBytes * $iConst), 1) & ' GB'
		Case 105156613 To 1073192074
			$iBytes = Round($iBytes / (1048576 + $iBytes * $iConst)) & ' MB'
		Case 1048040 To 105156612
			$iBytes = Round($iBytes / (1048576 + $iBytes * $iConst), 1) & ' MB'
		Case 102693 To 1048039
			$iBytes = Round($iBytes / (1024 + $iBytes * $iConst)) & ' KB'
		Case 1024 To 102692
			$iBytes = Round($iBytes / (1024 + $iBytes * $iConst), 1) & ' KB'
		Case 0 To 1023
			$iBytes = Int($iBytes / 1.024)
	EndSwitch
	Return $iBytes
EndFunc   ;==>_UpdateEngine_ConvertFileSize

#cs _Min, _Iif, and _VersionCompare - Pop back in when done with development (add _UpdateEngine to front)
	; #FUNCTION# ====================================================================================================================
	; Name...........: _Min()
	; Description ...: Evaluates which of the two numbers is lower.
	; Syntax.........: _Min( $nNum1, $nNum2 )
	; Parameters ....: $nNum1      = First number
	;                  $nNum2      = Second number
	; Return values .: On Success: = Returns the higher of the two numbers
	;                  On Failure: = Returns 0.
	;                  @ERROR:     = 0 = No error.
	;                                1 = $nNum1 isn't a number.
	;                                2 = $nNum2 isn't a number.
	; Author ........: Jeremy Landes <jlandes at landeserve dot com>
	; Remarks .......: Works with floats as well as integers
	; Example .......: MsgBox( 4096, "_Min() - Test", "_Min( 3.5, 10 )	= " & _Min( 3.5, 10 ) )
	; ===============================================================================================================================
	Func _Min($nNum1, $nNum2)
	; Check to see if the parameters are indeed numbers of some sort.
	If (Not IsNumber($nNum1)) Then Return SetError(1, 0, 0)
	If (Not IsNumber($nNum2)) Then Return SetError(2, 0, 0)
	
	If $nNum1 > $nNum2 Then
	Return $nNum2
	Else
	Return $nNum1
	EndIf
	EndFunc   ;==>_Min
	
	; #FUNCTION# ====================================================================================================================
	; Name...........: _Iif
	; Description ...: Perform a boolean test within an expression.
	; Syntax.........: _Iif($fTest, $vTrueVal, $vFalseVal)
	; Parameters ....: $fTest     - Boolean test.
	;                  $vTrueVal  - Value to return if $fTest is true.
	;                  $vFalseVal - Value to return if $fTest is false.
	; Return values .: True         - $vTrueVal
	;                  False        - $vFalseVal
	; Author ........: Dale (Klaatu) Thompson
	; Modified.......:
	; Remarks .......:
	; Related .......:
	; Link ..........:
	; Example .......: Yes
	; ===============================================================================================================================
	Func _Iif($fTest, $vTrueVal, $vFalseVal)
	If $fTest Then
	Return $vTrueVal
	Else
	Return $vFalseVal
	EndIf
	EndFunc   ;==>_Iif
	
	; #FUNCTION# ====================================================================================================================
	; Name...........: _VersionCompare
	; Description ...: Compares two file versions for equality
	; Syntax.........: _VersionCompare($sVersion1, $sVersion2)
	; Parameters ....: $sVersion1   - IN - The first version
	;                  $sVersion2   - IN - The second version
	; Return values .: Success      - Following Values:
	;                  | 0          - Both versions equal
	;                  | 1          - Version 1 greater
	;                  |-1          - Version 2 greater
	;                  Failure      - @error will be set in the event of a catasrophic error
	; Author ........: Valik
	; Modified.......:
	; Remarks .......: This will try to use a numerical comparison but fall back on a lexicographical comparison.
	;                  See @extended for details about which type was performed.
	; Related .......:
	; Link ..........:
	; Example .......:
	; ===============================================================================================================================
	Func _VersionCompare($sVersion1, $sVersion2)
	If $sVersion1 = $sVersion2 Then Return 0
	Local $sep = "."
	If StringInStr($sVersion1, $sep) = 0 Then $sep = ","
	Local $aVersion1 = StringSplit($sVersion1, $sep)
	Local $aVersion2 = StringSplit($sVersion2, $sep)
	If UBound($aVersion1) <> UBound($aVersion2) Or UBound($aVersion1) = 0 Then
	; Compare as strings
	SetExtended(1)
	If $sVersion1 > $sVersion2 Then
	Return 1
	ElseIf $sVersion1 < $sVersion2 Then
	Return -1
	EndIf
	Else
	For $i = 1 To UBound($aVersion1) - 1
	; Compare this segment as numbers
	If StringIsDigit($aVersion1[$i]) And StringIsDigit($aVersion2[$i]) Then
	If Number($aVersion1[$i]) > Number($aVersion2[$i]) Then
	Return 1
	ElseIf Number($aVersion1[$i]) < Number($aVersion2[$i]) Then
	Return -1
	EndIf
	Else ; Compare the segment as strings
	SetExtended(1)
	If $aVersion1[$i] > $aVersion2[$i] Then
	Return 1
	ElseIf $aVersion1[$i] < $aVersion2[$i] Then
	Return -1
	EndIf
	EndIf
	Next
	EndIf
	; This point should never be reached
	Return SetError(2, 0, 0)
	EndFunc   ;==>_VersionCompare
#ce

; #FUNCTION# ====================================================================================================================
; Name ..........: _UpdateEngine_Setup
; Description ...: Prepares the engine for updates. Remote directory and file are required.
; Syntax ........: _UpdateEngine_Setup($sRemoteDirSet, $sRemoteFileSet[, $sCurrentVersion = "0.0.0.0[,
;                  $sLocalDirSet = @DesktopDir[, $sLocalFileSet = ""[, $sIniFileSet = ""[, $sIniIDSet = ".generic"[,
;                  $iOptions = 0]]]]]])
; Parameters ....: $sRemoteDirSet       - The remote directory to access.
;                  $sRemoteFileSet      - The default remote file to download.
;                  $sCurrentVersion     - The version to compare against the update. Defualt is "0.0.0.0".
;                  $sLocalDirSet        - [optional] The local directory to download to. Default is @DesktopDir.
;                  $sLocalFileSet       - [optional] The local file to download to. Default is "".
;                  $sIniFileSet         - [optional] The remote settings file. Default is "".
;                  $sIniIDSet           - [optional] The remote settings ID. Default is ".generic".
;                  $iOptions            - [optional] Runtime options. Add to use multiple options. Default is 0.
;                                              1 - Force update
;                                              2 - Hide download progress
;                                              4 - Located on share (UNC)
;                                              8 - Exit on completion
; Return values .: Returns 0
; Author ........: cyberbit
; Modified ......: 08.08.13
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _UpdateEngine_Setup($sRemoteDirSet, $sRemoteFileSet, $sCurrentVersion = "0.0.0.0", $sLocalDirSet = @ScriptDir, $sLocalFileSet = $sRemoteFileSet, $sIniFileSet = "update.ini", $sIniIDSet = "update", $iOptions = 8)
	;Set all local variants
	$sRemoteDir = $sRemoteDirSet
	$sRemoteFile = $sRemoteFileSet
	$sVer = $sCurrentVersion
	$sLocalDir = $sLocalDirSet
	$sLocalFile = $sLocalFileSet
	$sIniFile = $sIniFileSet
	$sIniID = $sIniIDSet

	;Info needs to be updated!
	$iUpInfo = 0

	;Set options:
	;  1 - Force update
	;  2 - Hide download progress
	;  4 - Located on share (UNC)
	;  8 - Exit on completion
	If BitAND(1, $iOptions) Then $iUpdate = 1
	If BitAND(2, $iOptions) Then $iProgress = 0
	If BitAND(4, $iOptions) Then $iUNC = 1
	If BitAND(8, $iOptions) Then $iExit = 1
EndFunc   ;==>_UpdateEngine_Setup

; #FUNCTION# ====================================================================================================================
; Name ..........: _UpdateEngine_GetUpdateInfo
; Description ...: Gets information about an update from the remote settings file.
; Syntax ........: _UpdateEngine_GetUpdateInfo()
; Parameters ....: None
; Return values .: Success: An array of data:
;                           [0] - version
;                           [1] - update
;                           [2] - comments
;                           [3] - file
;                  Failure: 0 and sets @error/@extended:
;                           1 - Remote data not initialized (@extended added together):
;                                1 - Blank remote directory
;                                2 - Blank INI file path
;                                4 - Blank INI ID
;                           2 - INI download failed (sets @extended to non-zero)
; Author ........: cyberbit
; Modified ......: 08.06.13
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UpdateEngine_GetUpdateInfo()
	;Set errors:
	;  1 - Blank remote directory
	;  2 - Blank INI file path
	;  4 - Blank INI ID
	$iErrors = BitAND(_Iif($sRemoteDir = "", 1, 0), _Iif($sIniFile = "", 2, 0), _Iif($sIniID = "", 4, 0))
	If $iErrors Then Return SetError(1, $iErrors, 0)
	$sIniPath = FileGetLongName(@TempDir & "\" & $sIniFile)

	;Grab INI file from remote directory
	Switch $iUNC
		Case 0
			InetGet($sRemoteDir & $sIniFile, $sIniPath)
			If @error Then Return SetError(2, @error, 0)
		Case 1
			_UpdateEngine_FileCopy($sRemoteDir & $sIniFile, @TempDir)
	EndSwitch

	;Parse data from settings file
	$sUpVer = IniRead($sIniPath, $sIniID, "version", $sVer)
	$sUpDo = IniRead($sIniPath, $sIniID, "update", $iUpdate)
	$sUpComments = IniRead($sIniPath, $sIniID, "comments", "")
	$sUpFile = IniRead($sIniPath, $sIniID, "file", $sRemoteFile)
	$aUpFile = StringSplit($sUpFile, "|")

	;Info has been updated
	$iUpInfo = 1

	;Collect data
	Dim $aData[4] = [$sUpVer, $sUpDo, $sUpComments, $sUpFile]
	Return $aData
EndFunc   ;==>_UpdateEngine_GetUpdateInfo

; #UNUSED# ====================================================================================================================
; Name ..........: _UpdateEngine_CompareVersions
; Description ...: Compares file versions.
; Syntax ........: _UpdateEngine_CompareVersions($sVer1, $sVer2)
; Parameters ....: $sVer1               - The current program version.
;                  $sVer2               - The comparable program version.
; Return values .: Success: 0 - Both versions are equal
;                           1 - Current version is greater
;                           2 - Comparable version is greater
;                  Failure: -1 and sets @error to 1
; Author ........: cyberbit
; Modified ......: 08.07.13
; Remarks .......: Currently using _VersionCompare
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#cs Func _UpdateEngine_CompareVersions($sVer1, $sVer2)
	;Convert versions to arrays
	$sVer1 = StringSplit($sVer1, ".", 2)
	$sVer2 = StringSplit($sVer2, ".", 2)
	
	;Compare versions
	For $i = 0 To _Min(UBound($sVer1), UBound($sVer2)) - 1
	If Int($sVer1[$i]) > Int($sVer2[$i]) Then      ; Current version is greater
	Return 1
	ElseIf Int($sVer1[$i]) < Int ($sVer2[$i]) Then ; Remote version is greater
	Return 2
	Else                                           ; Both versions are equal
	Return 0
	EndIf
	Next
	
	;Something went wrong
	Return SetError(1, 0, -1)
#ce EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _UpdateEngine_ShouldUpdate
; Description ...: Checks if an update should be performed. _UpdateEngine_GetUpdateInfo MUST be called before!
; Syntax ........: _UpdateEngine_ShouldUpdate()
; Parameters ....: None
; Return values .: Returns 1 if update should be performed, 0 if not, and -1 on error
; Author ........: cyberbit
; Modified ......: 08.07.13
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _UpdateEngine_ShouldUpdate()
	;Compare versions
	$iVerComp = _VersionCompare($sVer, $sUpVer)
	If @error Then Return -1

	;If remote settings reccommend an update and the
	;remote version is greater than the current version,
	;or an update is being forced, do the update
	If (Int($sUpDo) = 1 And $iVerComp = -1) Or $iUpdate Then Return 1

	;Otherwise, don't do the update
	Return 0
EndFunc   ;==>_UpdateEngine_ShouldUpdate

; #FUNCTION# ====================================================================================================================
; Name ..........: _UpdateEngine_Update
; Description ...: Performs an update.
; Syntax ........: _UpdateEngine_Update([$iFlag = 0[, $iEXEIX = -1[, $sEXEParams = ""]]])
; Parameters ....: $iFlag               - [optional] An options flag (Default is 0):
;                                              1 - Execute downloaded file, as defined by $iEXEIX
;                  $iEXEIX              - [optional] Index of executable file in remote file string. -1 will execute the last
;                                         file downloaded. Default is -1.
;                  $sEXEParams          - [optional] Parameters passed to the executable file. Be sure to quote paths!
;                                         Default is "".
; Return values .: Success: 1
;                  Failure: 0 and sets @error:
;                       1 - Failed to retrieve update information
;                       2 - Update cancelled by settings
;                       3 - Update cancelled by user
;                       4 - Update timed out
; Author ........: cyberbit
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _UpdateEngine_Update($iFlag = 0, $iEXEIX = -1, $sEXEParams = "")
	;If info has not been updated, update it
	If Not $iUpInfo Then _UpdateEngine_GetUpdateInfo()
	If @error Then Return SetError(1, @error, 0)

	;If I should update, do
	If _UpdateEngine_ShouldUpdate() = 1 Then
		;Initiate check message, confirming update
		$iMsg = MsgBox(12356, $sTitle, "There is a new version (" & $sUpVer & ") of this program available. You currently have version " & $sVer & "." & @CRLF & "Do you want to update now?" & @CRLF & @CRLF & "Comments: " & $sUpComments, 30)

		;If update accepted, proceed
		If $iMsg = 6 Then
			;If not on a share, use InetXxx methods
			If Not $iUNC Then
				;Create progress GUI
				GUICreate($sTitle, 300, 75, -1, -1, 0xC00000)
				$lblUpdate = GUICtrlCreateLabel("Downloading update...", 0, 5, 300, 45, 1)
				GUICtrlSetFont($lblUpdate, 14)
				$progress = GUICtrlCreateProgress(5, 30, 290, 20, 1)
				$lblData = GUICtrlCreateLabel("0 bytes downloaded", 0, 55, 300, 30, 1)
				;If showing progress, show gui
				If $iProgress Then GUISetState()

				;Loop through remote update files
				For $iFile = 1 To $aUpFile[0]
					;Make sure progress restarts!
					GUICtrlSetData($progress, 0)

					;Start download of file in background, so I can get progress information
					$hDownload = InetGet($sRemoteDir & $aUpFile[$iFile], $sLocalDir & "\" & $aUpFile[$iFile], 1, 1)
					GUICtrlSetData($lblUpdate, "Downloading update " & $iFile & " of " & $aUpFile[0] & "...") ;Update top label

					$hTimer = TimerInit() ;Start update timer

					;Keep going until download is complete
					While Not InetGetInfo($hDownload, 2) = True
						$iBytes = InetGetInfo($hDownload, 0)
						$iTotalBytes = InetGetInfo($hDownload, 1)
						$iPercent = ($iBytes / $iTotalBytes) * 100
						GUICtrlSetData($progress, $iPercent)
						If TimerDiff($hTimer) > 50 Then
							GUICtrlSetData($lblData, _UpdateEngine_ConvertFileSize(InetGetInfo($hDownload, 0)) & _Iif(Number(InetGetInfo($hDownload, 1)) > 0, " of" & _UpdateEngine_ConvertFileSize(InetGetInfo($hDownload, 1)), "") & " downloaded")
							$hTimer = TimerInit()
						EndIf
					WEnd

					GUICtrlSetData($progress, 100)
					InetClose($hDownload)

					;Sleep to avoid download overlaps (bug?)
					Sleep(750)
				Next

				;All done, make it look like it
				GUICtrlSetData($lblUpdate, "Finished!")
				GUICtrlSetData($lblData, "")
				Sleep(1700) ;Rest a bit
				GUIDelete()

				;Execute downloaded file after update
				If BitAND(1, $iFlag) Then
					If $iEXEIX > $aUpFile[0] Or $iEXEIX < -1 Then Return SetError(1, $iEXEIX, 0)
					If $iEXEIX = -1 Then
						Run(@ScriptDir & "\" & $aUpFile[$aUpFile[0]] & " " & $sEXEParams)
					Else
						Run(@ScriptDir & "\" & $aUpFile[$iEXEIX] & " " & $sEXEParams)
					EndIf
				EndIf

				;Probably wont get here with self-deleting script run above, but just in case, maybe...?
				Exit
			Else ;I'm on a share, use FileCopy
				;Create progress GUI
				GUICreate($sTitle, 300, 55, -1, -1, 0xC00000)
				$lblUpdate = GUICtrlCreateLabel("Downloading update...", 0, 5, 300, 45, 1)
				GUICtrlSetFont($lblUpdate, 14)
				$progress = GUICtrlCreateProgress(5, 30, 290, 20, 8)
				If $iProgress Then GUISetState()

				;Because we can't really show real progress, set it to marquee
				GUICtrlSendMsg($progress, 0x40A, 1, 128)

				;Loop through remote update files
				For $iFile = 1 To $aUpFile[0]
					;Set label data
					GUICtrlSetData($lblUpdate, "Downloading update " & $iFile & " of " & $aUpFile[0] & "...") ;Update top label

					;Download file - this is a script-halting function!
					_UpdateEngine_FileCopy($sRemoteDir & $aUpFile[$iFile], $sLocalDir)
				Next

				;All done, make it look like it
				GUICtrlSetData($lblUpdate, "Finished!")
				Sleep(1700) ;Rest a bit
				GUIDelete()

				;Execute downloaded file after update
				If BitAND(1, $iFlag) Then
					If $iEXEIX > $aUpFile[0] Or $iEXEIX < -1 Then Return SetError(1, $iEXEIX, 0)
					If $iEXEIX = -1 Then
						Run($sLocalDir & "\" & $aUpFile[$aUpFile[0]] & " " & $sEXEParams)
					Else
						Run($sLocalDir & "\" & $aUpFile[$iEXEIX] & " " & $sEXEParams)
					EndIf
				EndIf

				;Probably wont get here with self-deleting script run above, but just in case, maybe...?
				Exit
			EndIf
		Else
			;Update rejected/timed out :(
			If $iMsg = -1 Then Return SetError(4, 0, 0)
			Return SetError(3, 0, 0)
		EndIf
	Else
		;Don't update
		Return SetError(2, 0, 0)
	EndIf

	;Update succeeded (won't get here with default settings)
	Return 0
EndFunc   ;==>_UpdateEngine_Update