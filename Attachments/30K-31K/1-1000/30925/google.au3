#region --- Au3Recorder generated code Start ---
_WinWaitActivate("D:\werk\google.au3 * SciTE","Source")
MouseClick("left",689,1045,1)
_WinWaitActivate("Microsoft Excel - allsoftware.xls  [Compatibiliteitsmodus]","allsoftware.xls  [Co")
MouseClick("left",89,260,1)
Send("{CTRLDOWN}c{CTRLUP}")
MouseClick("left",365,1044,1)
_WinWaitActivate("Google - Mozilla Firefox","")
MouseClick("left",176,67,1)
Send("{CTRLDOWN}v{CTRLUP}{ENTER}")
_WinWaitActivate("Christmas Sleigh Ridess - Google zoeken - Mozilla Firefox","")
MouseClick("left",332,309,1)
_WinWaitActivate("Sleigh Ride - Wikipedia, the free encyclopedia - Mozilla Firefox","")
MouseClick("left",323,64,1)
Send("{CTRLDOWN}c{CTRLUP}")
_WinWaitActivate("Program Manager","FolderView")
MouseClick("left",653,1037,1)
_WinWaitActivate("Microsoft Excel - allsoftware.xls  [Compatibiliteitsmodus]","allsoftware.xls  [Co")
Send("{RIGHT}{RIGHT}{CTRLDOWN}v{CTRLUP}{DOWN}{LEFT}{LEFT}")
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