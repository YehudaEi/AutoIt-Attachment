#region --- Internal functions Au3Recorder Start ---

Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc

#endregion --- Internal functions Au3Recorder End ---

	_WinWaitActivate("Encrypting Key Request","")
		Send("password1")
		MouseClick("left",382,435,1)
		Send("password2")
		MouseClick("left",382,435,1)

;;I need a loop in here that cycles back and forth between the two passwords each time the window becomes active.
;;I also need a way to manually break the loop incase neither password/key works...so something else can be tried.