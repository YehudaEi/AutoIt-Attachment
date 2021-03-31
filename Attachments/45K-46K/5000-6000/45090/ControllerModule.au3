Global $Profile, $Letters, $LetterCount, $KeyMaps, $LetterCount, $Down = 0, $Websites, $WebsiteCount, $WebsiteURL

Func _Triangle()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		SplashOff()
		$CurrentLetterCount = $LetterCount
		$LetterCount = $CurrentLetterCount - 1
		If $LetterCount > 67 Then
			$LetterCount = 0
		ElseIf $LetterCount < 0 Then
			$LetterCount = 0
		EndIf
		Sleep(200)
		SplashTextOn("", $Letters[$LetterCount][1], 40, 40, $MousePos[0], $MousePos[1], BitOR(1, 32), Default, 20)
	EndIf
	If $Profile = 2 Then
		Send("{CTRLDOWN}")
		Sleep(100)
		MouseClick("Left")
		Sleep(200)
		Send("{CTRLUP}")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "Triangle - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "Triangle - 4")
	EndIf
EndFunc   ;==>_Triangle

Func _Circle()
	If $Profile = 1 Then
		Send($KeyMaps[5][1])
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		Send("{CTRLDOWN}")
		Sleep(100)
		Send("{w}")
		Sleep(200)
		Send("{CTRLUP}")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "Circle - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "Circle - 4")
	EndIf
EndFunc   ;==>_Circle

Func _X()
	If $Profile = 1 Then
		Send($KeyMaps[7][1])
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		Send("{Home}")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "X - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "X - 4")
	EndIf
EndFunc   ;==>_X

Func _Square()
	If $Profile = 1 Then
		Send($KeyMaps[6][1])
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		If $Down = 0 Then
			MouseDown("Left")
			Sleep(200)
			$Down = 1
		Else
			MouseUp("Left")
			Sleep(200)
			$Down = 0
		EndIf
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "Square - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "Square - 4")
	EndIf
EndFunc   ;==>_Square

Func _L1()
	If $Profile = 1 Then
		MouseClick("Left")
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		MouseClick("Left")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MouseClick("Left")
		Sleep(200)
	EndIf
	If $Profile = 4 Then
		MouseClick("Left")
		Sleep(200)
	EndIf
EndFunc   ;==>_L1

Func _L2()
	If $Profile = 1 Then
		Sleep(10)
		For $i = 1 To 67 Step +1
			If $LetterCount = $Letters[$i][0] Then
				Send($Letters[$i][1])
				SplashOff()
				Sleep(200)
				ExitLoop
			EndIf
		Next
		$LetterCount = 0
	EndIf
	If $Profile = 2 Then
		ShellExecute($WebsiteURL)
		$WebsiteCount = 0
		SplashOff()
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "L2 - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "L2 - 4")
	EndIf
EndFunc   ;==>_L2

Func _R1()
	If $Profile = 1 Then
		MouseClick("Right")
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		MouseClick("Right")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MouseClick("Right")
		Sleep(200)
	EndIf
	If $Profile = 4 Then
		MouseClick("Right")
		Sleep(200)
	EndIf
EndFunc   ;==>_R1

Func _R2()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		If $LetterCount > 67 Then
			$LetterCount = 0
		EndIf
		$LetterCount += 1
		SplashTextOn("", $Letters[$LetterCount][1], 40, 40, $MousePos[0], $MousePos[1], BitOR(1, 32), Default, 20)
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		$MousePos = MouseGetPos()
		If $WebsiteCount > $Websites[0][0] - 1 Then
			$WebsiteCount = 0
		EndIf
		$WebsiteCount += 1
		$WebsiteURL = $Websites[$WebsiteCount][1]
		SplashTextOn("", $Websites[$WebsiteCount][1], 300, 40, $MousePos[0], $MousePos[1], BitOR(1, 32), Default, 10)
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "R2 - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "R2 - 4")
	EndIf
EndFunc   ;==>_R2

Func _DPadLeft()
	If $Profile = 1 Then
		Send($KeyMaps[4][1])
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		Send($KeyMaps[4][1])
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "DPadLeft - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "DPadLeft - 4")
	EndIf
EndFunc   ;==>_DPadLeft

Func _DPadUp()
	If $Profile = 1 Then
		Send($KeyMaps[1][1])
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		Send($KeyMaps[1][1])
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "DPadUp - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "DPadUp - 4")
	EndIf
EndFunc   ;==>_DPadUp

Func _DPadRight()
	If $Profile = 1 Then
		Send($KeyMaps[2][1])
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		Send($KeyMaps[2][1])
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "DPadRight - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "DPadRight - 4")
	EndIf
EndFunc   ;==>_DPadRight

Func _DPadDown()
	If $Profile = 1 Then
		Send($KeyMaps[3][1])
		Sleep(200)
	EndIf
	If $Profile = 2 Then
		Send($KeyMaps[3][1])
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "DPadDown - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "DPadDown - 4")
	EndIf
EndFunc   ;==>_DPadDown

Func _LeftAnalogUp()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] - $KeyMaps[8][1], 1)
	EndIf
	If $Profile = 2 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] - $KeyMaps[8][1], 1)
	EndIf
	If $Profile = 3 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] - $KeyMaps[8][1], 1)
	EndIf
	If $Profile = 4 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] - $KeyMaps[8][1], 1)
	EndIf
EndFunc   ;==>_LeftAnalogUp

Func _LeftAnalogRight()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] + $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
	If $Profile = 2 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] + $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
	If $Profile = 3 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] + $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
	If $Profile = 4 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] + $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
EndFunc   ;==>_LeftAnalogRight

Func _LeftAnalogDown()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] + $KeyMaps[8][1], 1)
	EndIf
	If $Profile = 2 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] + $KeyMaps[8][1], 1)
	EndIf
	If $Profile = 3 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] + $KeyMaps[8][1], 1)
	EndIf
	If $Profile = 4 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] + $KeyMaps[8][1], 1)
	EndIf
EndFunc   ;==>_LeftAnalogDown

Func _LeftAnalogLeft()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] - $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
	If $Profile = 2 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] - $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
	If $Profile = 3 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] - $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
	If $Profile = 4 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] - $KeyMaps[8][1], $MousePos[1], 1)
	EndIf
EndFunc   ;==>_LeftAnalogLeft

Func _RightAnalogUp()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] - $KeyMaps[9][1], 1)
	EndIf
	If $Profile = 2 Then
		MouseWheel("Up")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "RightAnaglogUp - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "RightAnaglogUp - 4")
	EndIf
EndFunc   ;==>_RightAnalogUp

Func _RightAnalogRight()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] + $KeyMaps[9][1], $MousePos[1], 1)
	EndIf
	If $Profile = 2 Then
		Send("{Right}")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "RightAnaglogRight - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "RightAnaglogRight - 4")
	EndIf
EndFunc   ;==>_RightAnalogRight

Func _RightAnalogDown()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0], $MousePos[1] + $KeyMaps[9][1], 1)
	EndIf
	If $Profile = 2 Then
		MouseWheel("Down")
		Sleep(100)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "RightAnaglogDown - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "RightAnaglogDown - 4")
	EndIf
EndFunc   ;==>_RightAnalogDown

Func _RightAnalogLeft()
	If $Profile = 1 Then
		$MousePos = MouseGetPos()
		MouseMove($MousePos[0] - $KeyMaps[9][1], $MousePos[1], 1)
	EndIf
	If $Profile = 2 Then
		Send("{Left}")
		Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "RightAnaglogLeft - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "RightAnaglogLeft - 4")
	EndIf
EndFunc   ;==>_RightAnalogLeft

Func _LeftAnalogPressed()
	If $Profile = 1 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "Profile", "Profile", "2")
		MsgBox(0, "", "Profile selection complete!")
;~ 		_SelectNewProfile()
Sleep(200)
	EndIf
			If $Profile = 2 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "Profile", "Profile", "1")
		MsgBox(0, "", "Profile selection complete!")
;~ 		_SelectNewProfile()
Sleep(200)
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "RightAnaglogLeft - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "RightAnaglogLeft - 4")
	EndIf
EndFunc   ;==>_LeftAnalogPressed

Func _RightAnalogPressed()
	If $Profile = 1 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "Profile", "Profile", "2")
		MsgBox(0, "", "Profile selection complete!")
		$Profile = 2
	EndIf
	If $Profile = 2 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "Profile", "Profile", "1")
		MsgBox(0, "", "Profile selection complete!")
		$Profile = 1
	EndIf
	If $Profile = 3 Then
		MsgBox(0, "Test", "RightAnaglogLeft - 3")
	EndIf
	If $Profile = 4 Then
		MsgBox(0, "Test", "RightAnaglogLeft - 4")
	EndIf
EndFunc   ;==>_RightAnalogPressed

;~ Func _SelectNewProfile()
;~ 	$NewProfile = IniRead(@ScriptDir & "/data/Config.ini", "Profile", "Profile", "NA")
;~ 	$Profile = $NewProfile
;~ EndFunc
