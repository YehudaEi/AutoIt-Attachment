#region ---Au3Recorder generated code Start (v3.3.7.0)  ---

#region --- Internal functions Au3Recorder Start ---
Func _Au3RecordSetup()
Opt('WinWaitDelay',100)
Opt('WinDetectHiddenText',1)
Opt('MouseCoordMode',0)
EndFunc

Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc

#AU3RecordSetup()
#endregion --- Internal functions Au3Recorder End ---


Run('Setup.exe')
_WinWaitActivate("Installer Language","Please select the la")
Send("{ENTER}")
_WinWaitActivate("pdfsam Setup","")
Send("{ALTDOWN}n{ALTUP}")
_WinWaitActivate("pdfsam Setup","")
Send("{ALTDOWN}a{ALTUP}")
_WinWaitActivate("pdfsam Setup","")
Send("{ALTDOWN}a{ALTUP}{ALTDOWN}n{ALTUP}")
_WinWaitActivate("pdfsam Setup ","")
Send("{ALTDOWN}n{ALTUP}{ALTDOWN}i{ALTUP}")
_WinWaitActivate("pdfsam Setup","")
Send("{ALTDOWN}n{ALTUP}")
_WinWaitActivate("pdfsam Setup","")
Send("{ALTDOWN}f{ALTUP}")
#endregion --- Au3Recorder generated code End ---
