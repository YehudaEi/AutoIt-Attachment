#include <GUIConstants.au3>
#include <Misc.au3>
opt("guioneventmode", 1)
opt("wintitlematchmode",4)
$clear = guicreate("INTERCEPTION",@DesktopWidth,@DesktopHeight,-1,-1,$WS_POPUP)
WinSetTrans("INTERCEPTION","",1)
GUISetState()
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN,"bleedthru")
GUISetOnEvent($GUI_EVENT_SECONDARYUP,"CLOSE")
while 1
	sleep(1)
WEnd

Func Close()
	Exit
EndFunc
Func bleedthru()
	$dll = DllOpen("user32.dll")
	
	if _IsPressed("41", $dll) then
		MsgBox(0,"","a")
	Else
		$pos = MouseGetPos()
		WinSetState("INTERCEPTION","",@SW_MINIMIZE)
		Sleep(1)
		MouseClick("primary",$pos[0],$pos[1])
		Sleep(1)
		WinSetState("INTERCEPTION","",@SW_MAXIMIZE)
	EndIf
EndFunc

