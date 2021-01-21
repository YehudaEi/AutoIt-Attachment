#include <GUIConstants.au3>
#include <Misc.au3>
Global $message
$Co_Ord1 = IniRead(@ScriptDir & "\pong.ini", "extras", "left", "-1")
$Co_Ord2 = IniRead(@ScriptDir & "\pong.ini", "extras", "top", "-1")
$IP_Addr = IniRead(@ScriptDir & "\pong.ini", "functions", "IP", "-1")
GUICreate("Network Notifier 1.0", 240, 80, $Co_Ord1, $Co_Ord2)
GUISetState()
$Path1 = @scriptdir & "\null.bmp"
$te = GUICtrlCreateLabel("Status:",2,30,50,20)
$iplbl = GUICtrlCreateLabel("IP:",1,4,20,20)
$pic = GuiCtrlCreatePic($path1, 190, 30, 33, 33)
$ExitButton = GUICtrlCreateButton("Exit", 196,1,40,20)
$newp = MouseGetPos()
$i = GUICtrlCreateInput($IP_Addr, 15, 1, 180, 20)

While 1
    ;$msg = GUIGetMsg()
		$a = GUICtrlRead($i)
		$ping_result = ping($a, 5000)
		If $ping_result = 0 Then
			GuiCtrlSetImage($pic, @scriptdir & "\Off.bmp")
		Else
			GuiCtrlSetImage($pic, @scriptdir & "\On.bmp")
	EndIf
	;If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend

While 1
$msg = GUIGetMsg()
Select
Case $msg = $GUI_EVENT_PRIMARYDOWN
$mp = MouseGetPos()
$wp = WinGetPos("Network Notifier 1.0")
While _IsPressed("01")
$newp = MouseGetPos()
WinMove("Network Notifier 1.0", '', $wp[0] + $newp[0] - $mp[0], $wp[1] + $newp[1] - $mp[1])
WEnd
If $wp[0] + $newp[0] - $mp[0] <> $Co_Ord1 Then
IniWrite(@ScriptDir & "\pong.ini", "extras", "left", $wp[0] + $newp[0] - $mp[0])
IniWrite(@ScriptDir & "\pong.ini", "extras", "top", $wp[1] + $newp[1] - $mp[1])
EndIf
Case $msg = $ExitButton
GUIDelete()
PLExit()
EndSelect
WEnd

;Exit Routine
Func PLExit()
If $Co_Ord1 <> $wp[0] + $newp[0] - $mp[0] Or $Co_Ord2 <> $wp[1] + $newp[1] - $mp[1] Then
$message = " New Menu Position Saved"
DisplayMessage()
EndIf
Exit
EndFunc ;==>PLExit

;Message Box Subroutine
Func DisplayMessage()
SplashTextOn("Network Notifier 1.0", $message, 270, 50, 150, 350, 36, "Arial", 10, 600)
Sleep(1000)
SplashOff()
EndFunc ;==>DisplayMessage