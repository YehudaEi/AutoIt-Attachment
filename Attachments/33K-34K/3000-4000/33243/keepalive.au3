; keepalive.au3
#Include <Date.au3>
#Include <Timers.au3>
#Include <Misc.au3>
#Include "_CheckTimeBlock.au3"

; Make sure only one instance is running
if _Singleton("keepalive",1) = 0 Then
    Msgbox(0,"Warning","keepalive is already running")
    Exit
EndIf

; Code for tray
Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)
TraySetClick(16)
$infoitem = TrayCreateItem("Info")
TrayItemSetOnEvent(-1,"ShowInfo")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitScript")
TraySetState()

; Functions for tray menu items
Func ShowInfo()
    Msgbox(0,"Info","Prevents computer from idling during specified hours.")
EndFunc
Func ExitScript()
    Exit
EndFunc

; Specify start and end times
Global $timeblock
$timeblock = "7:45-17:30"
_FormatTimeBlock($timeblock)

While 1
	$chk = _CheckTimeBlock()
	If $chk=0 Then ; if we are within the timeblock, $chk will return 0.
		$idle = _Timer_GetIdleTime() ; check current idle time
		If $idle >= 240000 Then ; if idle time is greater than 4 minutes (1 second = 1000)
			$m = MouseGetPos() ; wiggle mouse
			MouseMove($m[0], $m[1]+2)
			MouseMove($m[0], $m[1])
		EndIf
	EndIf
	Sleep(240000) ; wait 4 minutes to check again
WEnd