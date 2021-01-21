#include <GuiConstants.au3>

; GUI
GuiCreate("Current Information", 340, 400)

; Display the GUI
GUISetState()

; Edit input to word
GUICtrlCreateLabel("Enter word below:", 20, 100, 200)
$InputText = GUICtrlCreateInput("", 20, 120, 200, 20)

; Button for input to word
$CheckSpell = GUICtrlCreateButton ("Send Now!",  240, 117, 80)

; Attempt to program button

Do
    $msg = GUIGetMsg()
   
    Select

        Case $msg = $CheckSpell
if WinExists("Untitled - Notepad") = 0 then
Run("notepad.exe")
$IText = GUICtrlRead($InputText) 
WinActivate("Untitled - Notepad")
Send($IText & "{Enter}")
Else 
$IText = GUICtrlRead($InputText) 
WinActivate("Untitled - Notepad")
Send($IText & "{Enter}")
; WinWaitActive("Document1 - Microsoft Word")
EndIf
EndSelect
Until $msg = $GUI_EVENT_CLOSE