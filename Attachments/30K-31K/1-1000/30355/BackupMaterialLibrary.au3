Global $OSbit, $progress,$Edit ;Refferenced from main script
Func BackupMaterialLibrary()
	$Backup = (@ScriptDir & "\Saved\MaterialLibrary")
	DirCreate ($Backup)
		$MaterialLibraryPath = (@HomeDrive & "\Program Files (x86)")
		$CMD = Run (@ComSpec & ' /c xcopy /E/D/Y/H/R/C  "' & $MaterialLibraryPath & '" "' & $Backup & '"')
		$Size = DirGetSize ($MaterialLibraryPath)
			For $i = 1 to $Size step 1
				$GetBackupSize = DirGetSize ($Backup)
				$RoundResult = Round ($GetBackupSize*100/$Size)
				GUICtrlSetData ($progress,$RoundResult)
				GUICtrlSetData ($Edit,"Saving/Updating Material library" & @CRLF & Round($GetBackupSize / 1024 / 1024) & "MB out of " & Round($size / 1024 / 1024) & "MB copied. Done" & $RoundResult & "%")
				If $RoundResult = 100 Then
					ExitLoop ;Exit loop Due to 100%
				ElseIf $RoundResult < 100 Then ;If its not 100% then check for CMD process ID (PID) to exist
					$CheckCMDRunStatus = ProcessExists ($CMD)
					If $CheckCMDRunStatus = 0 Then
						MsgBox(0,'','CMD = 0')
						ExitLoop ;Exit loop Due to CMD no longer exist.
					ElseIf $CheckCMDRunStatus > 0 Then
						MsgBox(0,'','CMD = 1')
						;Nothing, Continue processing "For" Statement.
 					EndIf
				ElseIf $RoundResult = 0 Then ;If saved data = 0, exitloop due to error.
					MsgBox(16,'ERROR','Error executing Xcopy command and/or getting saved data size')
					ExitLoop
				EndIf
			Next
EndFunc