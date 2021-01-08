;
; AutoIt Version: 3.0
; Language:       English
; Platform:       WindowsXP
; Author:         ME
;
; Script Function:
;   Capture User Input and Save to a Report File.
;

#include <GuiConstants.au3>

GuiCreate("Arrow Electronics, INC.", 428, 190,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Name_1 = GuiCtrlCreateLabel("Scan Name:", 30, 50, 200, 20)
$Company_2 = GuiCtrlCreateLabel("Scan Company:", 30, 80, 210, 20)
$SN_3 = GuiCtrlCreateLabel("Scan Snum Number:", 30, 110, 220, 20)
$GetName_4 = GuiCtrlCreateInput("", 160, 50, 140, 20)
$GetCompany_5 = GuiCtrlCreateInput("", 160, 80, 140, 20)
$GetSN_6 = GuiCtrlCreateInput("", 160, 110, 140, 20)
$Group_7 = GuiCtrlCreateGroup("Customer Report Entry", 20, 20, 390, 140)
$ok = GUICtrlCreateButton ("Ok", 315,  50, 60, 20)
$exit = GUICtrlCreateButton ("Exit", 315, 80, 60, 20)

GUISetState () 

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
       $msg = GUIGetMsg()
       Select
           Case $msg = $ok
               exitloop
       EndSelect
Wend

MsgBox (4096, "Verify File", GUICtrlRead($GetName_4))
MsgBox (4096, "Verifyf File", GUICtrlRead($GetCompany_5))
MsgBox (4096, "Verify File", GUICtrlRead($GetSN_6))

;GuiSetState()
;While 1
;	$msg = GuiGetMsg()
;	Select
;	Case $msg = $GUI_EVENT_CLOSE
;		ExitLoop
;	Case Else
;		;;;
;	EndSelect
;WEnd
;Exit
#endregion --- GuiBuilder generated code End ---
