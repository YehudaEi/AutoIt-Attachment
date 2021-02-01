#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         IDK(sandeep_laik@mindtree.com)

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

HotKeySet("{F9}", "Fastrack")
HotKeySet("{ESC}", "Terminate")
HotKeySet("+!d", "ShowMessage")  ;Shift-Alt-d

;;;; Body of program would go here ;;;;
TrayTip("Info","F9 to close any Notepad window,ESC to terminate.",30,1)

While 1
    Sleep(100)
WEnd
;;;;;;;;

Func Fastrack()
	TrayTip("Working","Looking for any Notepad",30,0)
	WinActivate("[Class:Notepad]","") ;<-----------enter the name of your program if u know it :)
	$title=WinGetTitle("[ACTIVE]")
	WinGetHandle($title,"")
	WinSetState($title,"",@SW_MAXIMIZE)
	MouseClick("left",1250,40) ;<-----------------give the co-ord of u'r program's close button when it's maximized
	;send("!{F4}") <-------- You can use this too
EndFunc

Func Terminate()
	TrayTip("Terminating","IDK[sandeep_laik@mindtree.com]",30,0)
	sleep(3000)
    Exit 0
EndFunc

Func ShowMessage()
    TrayTip("Info","F9 to close any Notepad window,ESC to terminate.",30,1)
EndFunc

