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

_AU3RecordSetup()
#endregion --- Internal functions Au3Recorder End ---


Run('C:\Windows\System32\cmd.exe')
_WinWaitActivate("C:\Windows\System32\cmd.exe","")
Send("ipconfig{ENTER}")
MouseClick("right",14,55,1)
MouseClick("left",68,73,1)
_WinWaitActivate("Mark C:\Windows\System32\cmd.exe","")
MouseMove(13,52)
MouseDown("left")
MouseMove(635,306)
MouseUp("left")
_WinWaitActivate("Select C:\Windows\System32\cmd.exe","")
Send("{Enter}")
Run('C:\Windows\System32\notepad.exe')
_WinWaitActivate("Untitled - Notepad","")
Send("{CTRLDOWN}v{CTRLUP}")
#endregion --- Au3Recorder generated code End ---
