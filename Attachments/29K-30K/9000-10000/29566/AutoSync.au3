;#NoTrayIcon
#include <get_dns.au3>; Get the current Local DNS Suffix
	
	While $dnsfullname = $dnsfullname; Always TRUE for the purposes of testing
		Sync()
	WEnd

Func Sync()
	;Run('"C:\Program Files\SyncToy 2.1\SyncToyCmd.exe" -R "H Drive Sync"')
	Run("notepad.exe")
	Sleep(300000)
EndFunc