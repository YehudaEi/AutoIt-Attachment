#include <GUIConstantsEx.au3>

HotKeySet(".", "f1")
HotKeySet("+.", "f2")
HotKeySet(",", "f3")

$g_1 = GUICreate("Example", 800, 500)
GUISetState()
While 1
   $msg = GUIGetMsg()
   Select
	  Case $msg == $GUI_EVENT_CLOSE
		 ExitLoop
   EndSelect
WEnd
Func f1()
   ;Do something like for example
   MsgBox(0, "", "Hello World")
EndFunc
Func f2()
   ;Do something else like for example
   MsgBox(0, "", "Hello World 2")
EndFunc
Func f3()
   ;Do something else like for example
   MsgBox(0, "", "Hello World 3")
   ;This is the only one that works
EndFunc