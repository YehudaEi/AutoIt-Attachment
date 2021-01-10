
#include <File.au3>
#include <Date.au3>

HotKeySet ( "^1", "EndProgram" ); CTRL+1

$npname = "window1.txt"
_FileCreate($npname)
Run("notepad.exe " & $npname)

While 1	
	WinActivate($npname & " - Notepad")
	WinWaitActive($npname & " - Notepad")
	ControlSend($npname & " - Notepad", "", "Edit1", _NowDate() & "  " & _NowTime() & " should be in window 1" & @CR)	;for notepad ClassnameNN = Edit1
WEnd

Func EndProgram()
	Send("Exiting at user request.")
	Exit
EndFunc

