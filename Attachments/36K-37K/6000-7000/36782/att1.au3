#region ---Au3Recorder generated code Start ---
Opt("WinWaitDelay",100)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",2)


Run('D:\Documents and Settings\phanik\My Documents\Pengala\Venus_Course1\abc.exe')
_WinWaitActivate("course name","")
MouseClick("left",351,76,1)
Send("abc@hotmail.com{TAB}abc{ENTER}")
MouseClick("left",10,149,1)
MouseClick("left",25,169,1)
MouseClick("left",82,190,1)
MouseClick("left",99,210,1)
MouseClick("left",308,286,1)
MouseClick("left",740,416,1)
MouseClick("left",719,371,1)
MouseClick("left",397,672,1)
MouseClick("left",650,264,1)
MouseClick("left",410,665,1)
MouseClick("left",605,281,1)
MouseClick("left",1244,715,1)
_WinWaitActivate("abc","")
MouseClick("left",93,103,1)
_WinWaitActivate("course name","")
MouseClick("left",170,193,1)
MouseClick("left",57,151,1)
MouseClick("left",13,151,1)
MouseClick("left",1338,13,1)

#region --- Internal functions Au3Recorder Start ---
Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc
#endregion --- Internal functions Au3Recorder End ---

#endregion --- Au3Recorder generated code End ---
