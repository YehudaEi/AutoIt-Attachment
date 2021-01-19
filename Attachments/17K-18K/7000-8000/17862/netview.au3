#include <GuiConstants.au3>

; GUI
GuiCreate("Sample GUI", 300, 150)
GuiSetIcon(@SystemDir & "", 0)
guictrlcreatelabel("Net Send", 15, 30)
$input1 = guictrlcreateinput("Message", 90, 30, 200, 20)
guictrlcreatelabel("Recipient", 15, 75)
$input2 = GUICtrlCreateInput("Computer Name", 90, 75, 150, 20)

$netsend = guictrlread ($input1)
$compname = guictrlread ($input2)
$btn = guictrlcreatebutton ("Send", 200, 110, 50, 30)

$msg = guigetmsg()
if $msg = $btn Then
	run (@comspec & "Net Send" & $compname & $netsend)
	EndIf

; GUI MESSAGE LOOP
GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd
