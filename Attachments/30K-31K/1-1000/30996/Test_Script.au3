#region ---Au3Recorder generated code Start ---
Opt("WinWaitDelay",100)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)

_WinWaitActivate("PVP.net-Client","")
MouseClick("left",251,68,1)
MouseClick("left",446,322,1)
MouseClick("left",644,530,1)
MouseClick("left",741,581,1)
MouseClick("left",741,581,1)
MouseClick("left",741,581,1)
MouseClick("right",316,559,1)
MouseMove(314,617)
MouseDown("right")
MouseMove(318,615)
MouseUp("right")
_WinWaitActivate("League of Legends (TM) Client","")
MouseClick("right",451,686,1)
MouseClick("right",237,611,1)
MouseClick("right",1162,740,1)
MouseClick("right",1133,724,1)
MouseClick("right",138,582,1)
MouseClick("left",713,616,1)
MouseClick("left",711,582,1)
MouseClick("left",706,557,1)
MouseClick("left",709,529,1)
MouseClick("left",708,512,1)
MouseClick("left",689,441,1)
MouseClick("left",684,378,1)
Send("{ALTDOWN}{TAB}{ALTUP}")

#region --- Internal functions Au3Recorder Start ---
Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc
#endregion --- Internal functions Au3Recorder End ---

#endregion --- Au3Recorder generated code End ---
