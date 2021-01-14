#include <Constants.au3>
#include <GUIConstants.au3>
FileInstall ("dll.dll","dll.dll")
GUICreate ("", 100 , 40)
GUICtrlCreateIcon ("dll.dll" , 0 , 5 , 5 )
GUICtrlCreateIcon ("dll.dll" , 0 , 60 , 5 )
GUISetState ()
While 1
	$msg = GUIGetMsg ()
	If $msg = $GUI_EVENT_CLOSE Then
		Exit
	EndIf
WEnd
