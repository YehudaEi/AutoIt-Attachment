#include <GUIConstants.au3>
Dim $a
GUICreate("click me",150,65,200,100)
$b1 = GUICtrlCreateButton("",60,20,30,20)
;GUICtrlSetState($b1,$GUI_FOCUS)
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $b1 
			$a = $a +1
			If $a = 20 Then Exit	;close after 20 clicks received
		Case $msg = $GUI_EVENT_CLOSE 
			ExitLoop
	EndSelect	
WEnd