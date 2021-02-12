
Local $val_pid = 0
Local $PID = 0, $PID_Len = 0
OnAutoItExitRegister('ExitClient')
$PID = @AutoItPID
$PID_Len = StringLen($PID)
If WinExists("Form1IPC1234567890") == 1 Then
	$spid = ControlGetText("Form1IPC1234567890", '', 3)
	ControlSetText("Form1IPC1234567890", '', 3, $spid & ',' & $PID & ',')
	ControlSetText("Form1IPC1234567890", '', 4, ControlGetText("Form1IPC1234567890", '', 5) & $PID & '-' & 'ok')
Else
	MsgBox(0, 'Error', 'Please start the master Application')
	Exit
EndIf

While 1
	$ctrlread = StringReplace(ControlGetText("Form1IPC1234567890", '', 4), ',', '') ;decrypt
	$val_pid = StringLeft($ctrlread, $PID_Len)
	$ctrlread = StringTrimLeft($ctrlread, $PID_Len)
	If $val_pid == $PID Then ; for client
		$ctrlread = StringSplit(StringReplace($ctrlread, ',', ''), '-', 1)
		If IsArray($ctrlread) == 1 Then
			Select
				Case StringLower($ctrlread[2]) == 'end'
					Exit
				Case Else
					If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
					$sInputBoxAnswer = InputBox($PID & ' Received', "Received message : " & @CRLF & $ctrlread[2] & @CRLF & 'from Process PID :' & _
							$ctrlread[1] & @CRLF & "Send a Reply", "", " M")
					If StringStripWS($sInputBoxAnswer, 8) <> '' Then
						ControlSetText("Form1IPC1234567890", '', 4, $ctrlread[1] & $PID & '-' & $sInputBoxAnswer) ;encrypt the string
					EndIf
			EndSelect
		EndIf
	EndIf
	Sleep(100)
WEnd
Func ExitClient()
	$replace = ControlGetText("Form1IPC1234567890", '', 3)
	$replace = StringReplace($replace, ',' & $PID & ',', '')
	ControlSetText("Form1IPC1234567890", '', 3, $replace)
EndFunc   ;==>ExitClient