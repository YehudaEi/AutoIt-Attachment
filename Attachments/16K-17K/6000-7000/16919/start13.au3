Opt ("TrayIconHide", 1)
Global $Timer = TimerInit()
Opt("OnExitFunc", "end_script")
AdlibEnable("_TimeCheck", 100)
While 1
    Sleep(1000)
WEnd

Func _TimeCheck()
	testFunc1()
    If TimerDiff($Timer) > 4000 Then
		testFunc2(); This only happens every 4sec
        $Timer = TimerInit()
    EndIf
EndFunc   ;==>_TimeCheck

Func TestFunc1()
	if ProcessExists("taskmgr.exe") Then
		processClose ("taskmgr.exe")
		endif
	$PID =""
	$PID = ProcessExists("notepad.exe")
		If $PID = 0 Then
		BlockInput(0); enable mouse and keyboard
		processClose ("prot13.Exe")
			    ;SplashTextOn("", "This is func1", 200, 25, -1, -1, 1)
    Sleep(500)
    SplashOff()
		exit
		endif
EndFunc
	
Func TestFunc2()
	$PID0 =""
	$PID1 =""
	$PID0 = ProcessExists("prot13.exe")
	$PID1 = ProcessExists("notepad.exe")
		If $PID1 <> 0 and $PID0 =0 Then
		run (@ScriptDir & "\" & "prot13.exe","","")
		    ;SplashTextOn("", "This is func2", 200, 25, -1, -1, 1)
    Sleep(500)
		endif
	EndFunc
	
	Func end_script()
		BlockInput(0); enable mouse and keyboard
		processClose ("notepad.Exe")
		    Sleep(1000)
		processClose ("prot13.Exe")
    Sleep(1000)
		exit

EndFunc