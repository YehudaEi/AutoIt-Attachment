#include <GuiConstantsEx.au3>

; GUI
GuiCreate("Performance Perfect PC - OFFICIAL USE ONLY!", 550, 400)
GuiSetIcon(@SystemDir & "\mspaint.exe", 0)

; CHECKBOX
GuiCtrlCreateGroup("Network Tweaks", 30, 25)
GuiCtrlCreateCheckbox("Tweak 1", 50, 40)
GuiCtrlCreateCheckbox("Tweak 2", 50, 60)
GuiCtrlSetState(-1, $GUI_CHECKED)

; BUTTON
GuiCtrlCreateButton("Apply Tweaks", 65, 200, 100, 30)

; GUI MESSAGE LOOP
GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd
