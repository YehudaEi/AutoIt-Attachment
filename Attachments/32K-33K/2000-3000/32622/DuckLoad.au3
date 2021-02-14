Opt("WinTitleMatchMode", 2)

;~ FileDelete("C:\Atsisiuntimai\Transformers720p.avi")
;~ FileDelete("C:\Atsisiuntimai\Transformers720p.avi.part")

While 1
	Do
		Run("Conexion.cmd")
		WinWaitActive("AOL 9.5 - Connected, Signed-On", "", 60)
		If WinExists("AOL 9.5 - Connected, Signed-On") Then $x = 1
	Until $x = 1
	If WinExists("Download Error") then
		WinActivate("Download Error") 
	EndIf
	WinActivate("Download Error") 
	WinActivate("Opening")
	Send("{ENTER}")
;~ Download part
	WinActivate("Mozilla")
	Sleep(2000)
	MouseClick("left", 166, 64, 1, 0)
		MouseClick("left", 166, 64, 1, 0)
	Sleep(1500)
	WinActivate("Confirm")
	Send("{ENTER}")
	Sleep(10000)
	MouseMove(442, 585)
	MouseMove(784, 586)
		Sleep(5000)
	MouseClick("left", 480, 404, 1, 0)
		WinWaitActive("Opening")
	Send("{ENTER}")
	Sleep(1000)
	MouseClick("left", 480, 404, 1, 0)
		Sleep(100)
	$tinit = TimerInit()
	Do
		Sleep(1000)
	Until TimerDiff($tinit) > 10 * 200
	MouseClick("left", 781, 61, 1, 0) ;cancel dl
	Send("!c") ;clear dl
	Sleep(100)
	WinClose("Downloads")
WEnd