#include <Date.au3>
#include <GuiConstants.au3>
#include <Constants.au3>

#NoTrayIcon

$gui = GuiCreate("Alarm", 250, 165, -1, -1)
GUISetBkColor(0x000000, $gui)
$font="Arial"
GUISetFont(9, 400, 0, $font)

$inihour = IniRead("alarm.ini", "hour", "key", "hour")
$iniminute = IniRead("alarm.ini", "minute", "key", "minute")
$iniAMPM = IniRead("alarm.ini", "AMPM", "key", "AMPM")
$inimessage = IniRead("alarm.ini", "message", "key", "message")

$hour = GuiCtrlCreateInput(($inihour), 20, 20, 50, 20)
$minute = GuiCtrlCreateInput(($iniminute), 100, 20, 50, 20)
$AMPM = GuiCtrlCreateInput(($iniAMPM), 180, 20, 50, 20)
$message = GuiCtrlCreateInput(($inimessage), 20, 75, 210, 20)
$timelabel = GuiCtrlCreatelabel("Current Time : " & _NowTime(), 20, 125, 200, 20)
GUICtrlSetColor(-1,0xff0000)
GuiSetState(@SW_SHOW)

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1) 
Opt("GUIOnEventMode", 1)

GUISetOnEvent($GUI_EVENT_CLOSE, "ExitScript")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_MinTray")

$restoreitem = TrayCreateItem("Restore")
TrayItemSetOnEvent(-1,"RestoreTray")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitScript")
TraySetState(2)

While 1
If _NowTime() = GUICtrlRead($hour) & ":" & GUICtrlRead($minute) & ":00 " & GUICtrlRead($AMPM) Then
Beep(500, 500)
sleep(500)
Beep(500, 500)
sleep(500)
Beep(500, 500)
sleep(500)
Beep(500, 500)
sleep(500)
MsgBox(0, "Alarm", "It is " & _NowTime() & ". " & GUICtrlRead($message))
Else
sleep(1000)
GuiCtrlSetData($timelabel, "Current Time : " & _NowTime())
EndIf

If GUICtrlRead($hour) <> $inihour then
IniWrite("alarm.ini", "hour", "key", GUICtrlRead($hour))
EndIf

If GUICtrlRead($minute) <> $iniminute then
IniWrite("alarm.ini", "minute", "key", GUICtrlRead($minute))
EndIf

If GUICtrlRead($AMPM) <> $iniAMPM then
IniWrite("alarm.ini", "AMPM", "key", GUICtrlRead($AMPM))
EndIf

If GUICtrlRead($message) <> $inimessage then
IniWrite("alarm.ini", "message", "key", GUICtrlRead($message))
EndIf
WEnd

Func _MinTray()
GuiSetState(@SW_HIDE)
TraySetState(1)
EndFunc

Func RestoreTray()
GuiSetState(@SW_SHOW)
GuiSetState(@SW_RESTORE)
TraySetState(2)
EndFunc

Func ExitScript()
    Exit
EndFunc














