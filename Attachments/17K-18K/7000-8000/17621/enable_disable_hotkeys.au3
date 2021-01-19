#NoTrayIcon
#include <GUIConstants.au3>

;Initially Set HotKeys
HotKeySet("{PGUP}", "Show")
HotKeySet("{PGDN}", "Hide")

$hGui = GUICreate("HotKeySet Enable/Disable", 375, 144, 193, 125) ; create the gui
; radio buttons...
$RadioButton1 = GUICtrlCreateRadio("Disable Hotkeys", 40, 32, 105, 17)
$RadioButton2 = GUICtrlCreateRadio("Enable Hotkeys", 40, 55, 105, 17)
GUICtrlSetState ($RadioButton2, $GUI_CHECKED); default radio checked
GUISetState(@SW_SHOW)

While 1
 $nMsg = GUIGetMsg()
 Switch $nMsg
  Case $GUI_EVENT_CLOSE
   Exit
		Case $RadioButton1
			Disable()	
		Case $RadioButton2
			Enable()	
 EndSwitch
WEnd

; function to unset hotkeys
Func Disable() 
    HotKeySet('{PGUP}') 
	HotKeySet('{PGDN}')
ToolTip("Hotkeys has been Disabled")
Sleep(600) ; Sleep to display tooltip
    ToolTIp('') ; clears tooltip
    Sleep(20) ; Sleep to make tooltip disapear
EndFunc ; Disable() 

; function to reset hotkeys
Func Enable() 
	HotKeySet("{PGUP}", "Show")
	HotKeySet("{PGDN}", "Hide")
    ToolTip('Hotkeys has been Enabled') 
    Sleep(600) ; Sleep to display tooltip
    ToolTIp('') ; clears tooltip
    Sleep(20) ; Sleep to make tooltip disapear
EndFunc ; Enable() 

; function to utilize hotkey once set to show GUI
Func Show()
		GUISetState(@SW_SHOW, $hGui)
	EndFunc 
; function to utilize hotkey once set to hide GUI
Func Hide()
		GUISetState(@SW_HIDE, $hGui)
	EndFunc

