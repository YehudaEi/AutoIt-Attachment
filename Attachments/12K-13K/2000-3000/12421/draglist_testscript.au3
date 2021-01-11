#include "Draglist.au3"

#region Main
$Parent = GUICreate("draglist test", 600, 300)
$list1 = GUICtrlCreateList("my draglist", 40, 30, Default, Default, $WS_VSCROLL)
$list2 = GUICtrlCreateList("my draglist", 300, 30, Default, Default, $WS_VSCROLL)
$Hlb = ControlGetHandle($Parent,"",$list2)
GUICtrlSetFont($list1, 16, 600)
GUICtrlSetColor($list1, 0xff0000)
GUICtrlSetBkColor($list1, 0x00ff00)
GUICtrlSetFont($list2, 12, 900)
GUICtrlSetColor($list2, 0x0000ff)
GUICtrlSetBkColor($list2, 0xf0000f)
GUICtrlSetData($list1, "you|me|them|us|cool|shit|maynerd|damn|fuck|wow|bitchin|yada|nada|oh yeah")
GUICtrlSetData($list2, "you|me|them|us|cool|shit|maynerd|damn|fuck|wow|bitchin|yada|nada|oh yeah")
GUISetState (@SW_SHOW)       
_Makedraglist($Parent,"", $list1); can use standard ControlGetHandle() params...
_Makedraglist($Hlb); or simply specify the controls handle...
While 1
	Dim $msg = GUIGetMsg()

	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	
Wend
#endregion