#NoTrayIcon
Run(@SystemDir & "\Rundll32.exe Shell32.dll Control_RunDLLA hotplug.dll, vbNormalFocus",@SystemDir, @SW_HIDE)
BlockInput(1)
WinWait("[CLASS:#32770; TITLE:Safely Remove Hardware]")
WinActivate("[CLASS:#32770; TITLE:Safely Remove Hardware]")
Send("!s")
WinWait("[CLASS:#32770; TITLE:Stop a Hardware device]")
WinActivate("[CLASS:#32770; TITLE:Stop a Hardware device]")
Send("{ENTER}")
WinWaitClose("[CLASS:#32770; TITLE:Stop a Hardware device]")
Send("!{F4}")
BlockInput(0)

