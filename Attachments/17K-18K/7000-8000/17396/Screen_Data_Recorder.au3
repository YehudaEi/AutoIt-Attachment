HotkeySet('{ESC}', 'Terminate')
opt ("WinTitleMatchMode",2)

Run("C:\Program Files (x86)\CamStudio\Recorder.exe")
While 1
WinWaitActive("CamStudio")
Send("^{F8}")
	sleep(20000)
	Send("^{F9}")
	sleep(5)
	Send("Tacan")
	Sleep(10)
	Send("{ENTER}")
WinWaitActive("Save AVI File")
	Sleep(10)
	Send("Tacan")
	Sleep(10)
	Send("{ENTER}")

If WinWaitActive("Windows Media Player")then 
	sleep(10000)
	Send("^{F9}")
	sleep(5)
	Send("Tacan")
	Sleep(10)
	Send("{ENTER}")
EndIf

If WinWaitActive("Save AVI File")then 
	Sleep(10)
	Send("Tacan")
	Sleep(10)
	Send("{ENTER}")
	Sleep(100)
	WinActivate("Player")	
	processclose ("test.exe")
EndIf
Sleep (1000)
WEnd
	$TimeStamp = TimerInit ()

	;Check every minute if time difference is greater than or equal to 15 mins
	Do
		;Pause for 1 minute
		Sleep(1000 * 60)
	Until TimerDiff ( $TimeStamp) >= 1000 * 30 * 10 * 1

WEnd


Func Terminate()
    Exit
EndFunc