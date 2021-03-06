

$sDir = "C:\TestFolder\TestThis"
ShowSplash()
If @OSVersion = "WIN_7" Then
	_windows7()
	Exit
Else
	_windowsXP()
	Exit
Exit

EndIf

Func _windows7()

	$sFiles = "*.*"
	$aFiles = StringSplit($sFiles, ",")

	For $j = 1 To $aFiles[0]
		$i = 50
		While $i > 0
			If StringLeft($aFiles[$j], 1) = "\" Then

				If DirRemove($sDir & $aFiles[$j]) Then ExitLoop ;Exit the while loop

				If FileExists($sDir & $aFiles[$j] & "\*.*") Then

					If Not FileDelete($sDir & $aFiles[$j] & "\*.*") Then
						RemoveSplash()
						MsgBox(262160, "Program", "You do not have the correct permissions. (Please contact the Server Desk)")
						ExitLoop	;Exit the while loop
					EndIf	;==>FileDelete($sDir & $aFiles[$j] & "\*.*")

				EndIf	;==>FileExists($sDir & $aFiles[$j] & "\*.*")

			Else	;==>StringLeft($aFiles[$j], 1) = "\"

				If FileDelete($sDir & '\' & $aFiles[$j]) Then
					RemoveSplash()
					MsgBox(0, "Program", "Cache has been cleared.")
					ExitLoop	;Exit the while loop
				EndIf	;==>FileDelete($sDir & '\' & $aFiles[$j])

				Sleep(100)
				$i -= 1

				If $i = 0 Then
					RemoveSplash()
					MsgBox(262160, "Program", "You do not have the correct permissions. (Please contact the Server Desk)")
					ExitLoop	;Exit the while loop
				EndIf	;==>i = 0

			EndIf 	;==>StringLeft($aFiles[$j], 1) = "\"

		WEnd	;$i > 0

	Next	;==>$j = 1 To $aFiles[0]

EndFunc ;==>_windows7


Func _windowsXP()

	$sFiles = "*.*"
	$aFiles = StringSplit($sFiles, ",")

	For $j = 1 To $aFiles[0]
		$i = 50

		While $i > 0

			If StringLeft($aFiles[$j], 1) = "\" Then

				If DirRemove($sDir & $aFiles[$j]) Then ExitLoop ;Exit the while loop

				If FileExists($sDir & $aFiles[$j] & "\*.*") Then

					If Not FileDelete($sDir & $aFiles[$j] & "\*.*") Then
						RemoveSplash()
						MsgBox(262160, "Program", "You do not have the correct permissions. (Please contact the Server Desk)")
						ExitLoop	;Exit the while loop
					EndIf	;==>Not FileDelete($sDir & $aFiles[$j] & "\*.*")

				EndIf	;==>FileExists($sDir & $aFiles[$j] & "\*.*")

			Else	;==>StringLeft($aFiles[$j], 1) = "\"

				If FileDelete($sDir & '\' & $aFiles[$j]) Then
					RemoveSplash()
					MsgBox(0, "Program", "Cache has been cleared.")
					ExitLoop	;Exit the while loop
				EndIf	;==>FileDelete($sDir & '\' & $aFiles[$j])

				$i -= 1
				If $i = 0 Then
					RemoveSplash()
					MsgBox(262160, "Program", "You do not have the correct permissions. (Please contact the Server Desk)")
					ExitLoop
				EndIf	;==>$i = 0

			EndIf	;==>StringLeft($aFiles[$j], 1) = "\"

		WEnd	;==>$i > 0

	Next	;==>$j = 1 To $aFiles[0]

EndFunc ;==>_windowsXP

Exit

Func ShowSplash()
	SplashTextOn("Program", "Clearing Cache. Please Wait...", 325, 45, -1, -1, 2, "", 10)
	Sleep(3000)
EndFunc


Func RemoveSplash()
	SplashOff()
EndFunc