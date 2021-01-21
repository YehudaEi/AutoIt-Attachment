#include "md5.au3"
#include <GuiConstants.au3>

GuiCreate("MyGUI", 392, 322,(@DesktopWidth-392)/2, (@DesktopHeight-322)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$edit = GuiCtrlCreateEdit("", 10, 10, 370, 270)
$input = GuiCtrlCreateInput("", 10, 290, 270, 20, $ES_READONLY)
$button = GuiCtrlCreateButton("Generate", 290, 290, 90, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $button
		$in = GUICtrlRead($edit)
		GUICtrlSetData($input, _md5($in))
	EndSelect
WEnd
Exit