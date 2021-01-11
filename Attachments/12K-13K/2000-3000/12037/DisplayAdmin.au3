$Ans = MsgBox (3, "Display Administrator", "Display Computer's Administrator Account on Login Screen ?")
If $Ans = 6 Then
	$Reg = RegWrite ("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList\", _
	"Administrator", "REG_DWORD", "1")
	If $Reg = 1 Then
		MsgBox (4096, "Display Admin", "Successful!" & @CRLF & "Please Restart your computer to update" & @CRLF & _
		"changes made to your computer")
	Else
		MsgBox (4096, "Display Admin", "Failed")
	EndIf
ElseIf $Ans = 7 Then
	$Reg = RegWrite ("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList\", _
	"Administrator", "REG_DWORD", "0")
	If $Reg = 1 Then
		MsgBox (4096, "Hide Admin", "Successful!" & @CRLF & "Please Restart your computer to update" & @CRLF & _
		"changes made to your computer")
	Else
		MsgBox (4096, "Hide Admin", "Failed")
	EndIf
ElseIf $Ans = 2 Then
	Exit
EndIf