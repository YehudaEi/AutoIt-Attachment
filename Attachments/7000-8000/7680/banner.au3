#include <Constants.au3>
#include <GuiConstants.au3>

GuiCreate("hi, i want to make a banner without scrollbars", 480, 450,-1, -1 ,BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$oIE = ObjCreate("Shell.Explorer.2")
$GUIActiveX = GUICtrlCreateObj($oIE, 10, 380, 460,60)
$oIE.navigate("                   ")
$oIE.document.body.scroll = "no"
$oIE = 0

GuiSetState()

while 1
	Sleep(50)
	$msg = GuiGetMsg()
	if $msg == $GUI_EVENT_CLOSE Then ExitLoop
wend
