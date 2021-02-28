TraySetState(2) 
HotKeySet("!^n", "enie") ;Crtl+Shift-Alt-n
HotKeySet("+!n}", "enieg") ;Crtl+Shift-Alt-n
HotKeySet("+!^q", "Terminado") ;Cerrar
$x = Chr(241)
$y = Chr(209)

While 1
    Sleep(100)
WEnd

Func enie()
   	Send("{" & $x & "}")
 EndFunc

Func enieg()
  	Send("{" & $y & "}")
 EndFunc
 
Func Terminado()
        ToolTip('Programa Enie Cerrado"', 0, 0)
		Sleep(1000)
	Exit 0
 EndFunc 
 