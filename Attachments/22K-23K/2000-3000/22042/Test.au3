#include <GUIConstants.au3>

$StatusView = GUICreate("Window Title",600,400,-1,-1,$WS_SIZEBOX+$WS_SYSMENU,$WS_EX_TOPMOST) 
GUISetFont (14,400,-1,"Arial")
$CtrlStatus = GUICtrlCreateLabel("This is a test",0,0,600,150, $SS_Center)
GUICtrlSetResizing ($CtrlStatus,$GUI_DOCKAUTO)
GUICtrlSetColor($CtrlStatus,0x000000)
GUICtrlSetFont($CtrlStatus,10,400,-1,"Arial Black")
GUICtrlSetState($CtrlStatus,$GUI_Show)
GUISetState (@SW_SHOW,$StatusView)
While 1
	$Event = GUIGetMsg()
	If $Event = $GUI_EVENT_CLOSE Then
		ExitLoop
	EndIf
WEnd
