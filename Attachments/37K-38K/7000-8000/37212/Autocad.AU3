#include <BlockInputEx.au3>
Global $MouseSpeed = 0

; Set the quit key sequence
HotKeySet("^!+{ESC}", "Quit") ;crtl-alt-shift-esc
HotKeySet("{F1}", "Drawing")
HotKeySet("{F2}", "Detail")


While 1 
   Sleep(1000)
   WEnd

Func Drawing()
_BlockInputEx(0)
MouseClick("left",164, 30,1, $MouseSpeed)
MouseClick("left", 181, 53, 1, $MouseSpeed)
MouseClick("left", 995, 500, 1, $MouseSpeed)
_BlockInputEX(1, "{F1}|{F2}|{UP}|{DOWN}|{PGUP}|{PGDN}")
EndFunc

Func Detail()
_BlockInputEx(0)
MouseClick("left",164, 30,1, $MouseSpeed)
MouseClick("left", 186, 96, 1, $MouseSpeed)
MouseClick("left", 182, 97, 1, $MouseSpeed)
MouseClick("left", 995, 500, 1, $MouseSpeed)
_BlockInputEx(1, "{F1}|{F2}|{LEFT}|{RIGHT}|{UP}|{DOWN}|{PGUP}|{PGDN}") 
EndFunc   

Func Quit()
_BlockInputEx(0)
HotKeySet("{F5}")
HotKeySet("{F11}")
Exit
EndFunc


