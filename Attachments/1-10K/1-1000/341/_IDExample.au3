#include <GuiConstants.au3>
$IDC = 0
HotkeySet("{Esc}", "GetPos")

GuiCreate("Press Esc to Get Pos", 400, 400)
$x=GuiCtrlCreateLabel ("0", 10, 10,50)
$y=GuiCtrlCreateLabel ("0", 10, 30,50)
$ID=GuiCtrlCreateLabel ("0", 10, 60,50)
GuiSetState()

; Run the GUI until the dialog is closed
Do
$msg = GUIGetMsg()
Until $msg = $GUI_EVENT_CLOSE
Exit

Func GetPos()
    $a=GuiGetCursorInfo()
    GuictrlSetData($x,$a[0]) 
    GuictrlSetData($y,$a[1]) 
    GuictrlSetData($ID, "ID: " & $a[4]) 
EndFunc
Exit