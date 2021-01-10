#Include <Misc.au3>
_Singleton("LaunchLocker")
Opt ("TrayIconHide",1)
Opt ("RunErrorsFatal",0)

while 1
	if not (ProcessExists("locker.exe")) then
		Run ("locker.exe")
	endif
	Sleep (100)
WEnd

func OnAutoItExit()
	if not (ProcessExists("locker.exe")) then
		Run ("locker.exe")
	endif
EndFunc