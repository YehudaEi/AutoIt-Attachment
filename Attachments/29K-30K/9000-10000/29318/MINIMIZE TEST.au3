#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
$Ripristina = TrayCreateItem("resume")
TrayItemSetOnEvent(-1, "resume")
$Escitray = TrayCreateItem("exit")
TrayItemSetOnEvent(-1, "exits")
TraySetClick(0)

$Form1 = GUICreate("Try", 116, 26, 268, 227)
$Label1 = GUICtrlCreateLabel("Simple Test", 24, 8, 63, 17)
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $GUI_EVENT_MINIMIZE
            Minimize()
    EndSwitch
WEnd

Func Minimize()
    GUISetState(@SW_HIDE)
    TraySetState(1)
    TraySetClick(16)
EndFunc   ;==>Minimize

Func resume()
    GUISetState(@SW_SHOW)
    GUISetState(@SW_RESTORE)
    TraySetClick(0)
EndFunc   ;==>resume

Func exits()
    Exit
EndFunc   ;==>exits
 