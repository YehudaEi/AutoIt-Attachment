HotKeySet("{ESC}", "Stop") ;script end with key ESC
HotKeySet("{TAB}", "getpos") ;script show mouse location with key TAB
MsgBox(0,"Start", "Press Tab to see location of mouse, Esc to finish program")
while 1
WEnd
Exit

Func Stop() 
MsgBox(0,"Finish", "Program End")
Exit
EndFunc 

Func getpos()
    $x = MouseGetPos(0)
    $y = MouseGetPos(1)
	MsgBox ( 0, "Information", "MousePos: "& $x &", " & $y , 0 )
endfunc