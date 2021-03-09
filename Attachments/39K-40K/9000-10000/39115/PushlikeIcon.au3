#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>

Global $msg

GUICreate("GUI",130,80)

GUICtrlCreateButton('',10,20,50,50,$BS_ICON)
GUICtrlSetImage(-1, 'icon_48_Alpha.ico')

GUICtrlCreateCheckbox('',70,20,50,50,BitOR($BS_AUTOCHECKBOX,$BS_PUSHLIKE,$BS_ICON))
GUICtrlSetImage(-1, 'icon_48_Alpha.ico')

GUISetState()

While $msg<>$GUI_EVENT_CLOSE
	$msg = GUIGetMsg()
WEnd

