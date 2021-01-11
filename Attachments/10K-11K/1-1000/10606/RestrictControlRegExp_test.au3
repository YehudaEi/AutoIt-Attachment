#include <GUIConstants.au3>
#include "RestrictControlRegExp.au3"

Opt("GUIOnEventMode", 1)

_RegEx_RestrictControl_setup (20) ; prepare for up to 20 Controls to restrict

GUICreate("Test")
GUISetOnEvent(-3, "_quit")
$inp = GUICtrlCreateInput("", 10, 10, 100, 20)
_RegEx_RestrictControl_add ($inp, "^[a-z]{0,10}$") ; up to 10 letters
$inp2 = GUICtrlCreateInput("", 10, 100, 100, 20)
_RegEx_RestrictControl_add ($inp2, "^[0123]{1}[0-9]{1}.[01]{1}[0-9]{1}.[12]{1}[0-9]{3}$", "12.12.1222") ; German date DD.MM.YYYY
$inp3 = GUICtrlCreateInput("", 10, 200, 100, 20)
_RegEx_RestrictControl_add ($inp3, "^[a-zA-Z_0-9]{1,20}@[a-zA-Z_0-9]{2,20}.[a-z]{2,4}$", "g@gm.de") ; e-mail-address


GUISetState()


While 1
	Sleep(10)
WEnd



Func _quit()
	Exit
EndFunc   ;==>_quit