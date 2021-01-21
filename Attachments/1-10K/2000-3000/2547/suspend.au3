;$letter equals the first letter of the process name.
;If the process will be the second, third etc... starting
;with that letter, enter the key n times to arrive at the
;correct process, e.g, _suspend('notepad.exe','nnn)

$process = 'notepad.exe'
$letter = 'n'

Run($process,'',@SW_HIDE)

_suspend($process,$letter)

Func _suspend($process,$letter)

	Run("procexp.exe",'',@SW_HIDE)
	WinActivate("Process")
	ControlSend("Process",'',101,$letter & "!p{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	ProcessClose("procexp.exe")

EndFunc