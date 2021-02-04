
#region --- Au3Recorder generated code Start ---
_WinWaitActivate("(Untitled) - SciTE [2 of 2]","")
Send("{SHIFTDOWN}t{SHIFTUP}")
_WinWaitActivate("(Untitled) * SciTE [2 of 2]","")
Send("est{SPACE}for{SPACE}recorder{SHIFTDOWN}?{SHIFTUP}{ENTER}")
")

#region --- Internal functions Au3Recorder Start ---
Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc
#endregion --- Internal functions Au3Recorder End ---

#endregion --- Au3Recorder generated code End ---
#endregion --- Au3Recorder generated code End ---

