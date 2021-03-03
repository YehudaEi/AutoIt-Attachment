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

AU3RecordSetup()
#endregion --- Internal functions Au3Recorder End ---

_WinWaitActivate("Program Manager","")
MouseClick("left",161,1057,1)
_WinWaitActivate("Blank Page - Windows Internet Explorer","")
Send("www?cnn?com{ENTER}")
_WinWaitActivate("CNN.com International - Breaking, World, Business, Sports, Entertainment and Video News - Windows Internet Explorer","")
MouseClick("left",451,288,1)
_WinWaitActivate("Video - Breaking News Videos from CNN.com - Windows Internet Explorer","")
MouseClick("left",507,284,1)
_WinWaitActivate("World News - International Headlines, Stories and Video from CNN.com - Windows Internet Explorer","")
MouseClick("left",1892,23,1)
#endregion --- Au3Recorder generated code End ---

