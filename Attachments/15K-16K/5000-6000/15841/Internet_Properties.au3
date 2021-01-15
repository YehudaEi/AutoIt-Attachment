#Include <GuiTab.au3>
#include <GUIConstants.au3>



;; General Tab
Run("RunDll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,0")

WinWait("Internet Properties")
WinActivate("Internet Properties")

ControlFocus("Internet Properties", "Home page", "Button3")
ControlClick("Internet Properties", "Home page", "Button3")
ControlFocus("Internet Properties", "Home page", "Button14")
ControlClick("Internet Properties", "Home page", "Button14")
ControlFocus("Internet Properties", "Home page", "Button12")
ControlClick("Internet Properties", "Home page", "Button12")

sleep(1000)

;; Privacy Tab
Run("RunDll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,2")

WinWait("Internet Properties")
WinActivate("Internet Properties")

ControlFocus("Internet Properties", "Settings", "Button4")
ControlClick("Internet Properties", "Settings", "Button4")

ControlFocus("Internet Properties", "Settings", "Button5")
ControlCommand("Internet Properties", "Settings", "Button5", "Check")
$c_h = ControlGetHandle("Internet Properties", "Settings", "Button5")
$c_drive = _GUICtrlComboFindString ($c_h, "Check")
_GUICtrlComboSetCurSel ($c_h, $c_drive)
ControlClick("Internet Properties", "Settings", "Button5")
ControlFocus("Internet Properties", "Settings", "Check")
ControlClick("Internet Properties", "Settings", "Check")


ControlFocus("Internet Properties", "Settings", "Button9")
ControlClick("Internet Properties", "Settings", "Button9")
ControlFocus("Internet Properties", "Settings", "Button7")
ControlClick("Internet Properties", "Settings", "Button7")

sleep(1000)