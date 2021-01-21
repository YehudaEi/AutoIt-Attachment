;
;This script will switch to explorer under an admin account
;without requiring user to log off completely
;
;
Dim $SwitchUser,$SwitchPswd,$SwitchDomain,$defaultDomain

$SwitchUser = @username & "adm"
$SwitchUser = InputBox ( "Context Switch - user", "User to switch control to:", $SwitchUser,"",-1,30)
$SwitchPswd = InputBox ( "Context Switch - password", "Password for " & $SwitchUser & ":","", "*",-1,30)
If $SwitchUser = "administrator" Then
	$defaultDomain=@computername
Else
	$defaultDomain="OurDomain"
EndIf
$SwitchDomain = InputBox ( "Context Switch - domain", "Domain for " & $SwitchUser & "?" & @CRLF & "<OurDomain> OR <" & @Computername & ">",$defaultDomain,"",-1,150)
ProcessClose("explorer.exe")
AutoItSetOption ( "WinTitleMatchMode", 2)
FileChangeDir ( @WindowsDir )
Run(@COMSPEC & " /c Runas /user:" & $SwitchDomain & "\" & $SwitchUser & " explorer.exe")
WinWait("cmd.exe")
Send($SwitchPswd)
Send("{ENTER}")

;;;takes longer on w2k
ProcessWait("explorer.exe")
;;;Now Working under admin account
;;;Hold up until user presses "OK"
MsgBox(0,"Context Switch","When you are finished working under " & $SwitchUser & " hit ok to be returned back to your logged in user context...")

;;;;Switch back to logged in user
ProcessClose("explorer.exe")
Sleep(500)
;;;don't know why ProcessClose doesn't work the second time in XP
If ProcessExists("explorer.exe") Then
    MsgBox(0, "Context Switch", "AutoIt was unable to close Explorer on its own." & @CRLF & "Open the process tab in Task Manager and end the explorer process")
    ProcessWaitClose("explorer.exe")
EndIf
;;;;;worked on w2k -- so rather check logged in user -- THAT didn't evaluate as thought
;If @Username = $SwitchUser Then
;    MsgBox(0, "Context Switch", "AutoIt was unable to close Explorer on its own." & @CRLF & "Open the process tab in Task Manager and end the explorer process")
;    ProcessWaitClose("explorer.exe")
;EndIf


FileChangeDir ( @WindowsDir )
Run(@COMSPEC & " /c explorer.exe")
WinClose("Task Manager")
WinClose(@COMSPEC)
WinClose("cmd.exe")

Exit