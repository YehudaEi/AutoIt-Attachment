; Script Start

#include <GuiConstants.au3>
opt ("GuiOnEventmode",1)
GuiCreate("Staying Alive", 130, 50,-1, -1 , BitOR($DS_MODALFRAME, $WS_CAPTION ))

$Button_1 = GuiCtrlCreateButton("Quit", 20, 10, 90, 25)
GUICtrlSetOnEvent(-1, "_exit")

GuiSetState()
WinSetOnTop ( "Staying Alive", "", 1 )
HotKeySet("x", "_exit")

While 1
MouseMove(10, 15, 25) 
MouseMove(15, 10, 25)
MouseMove(10, 15, 25) 
MouseMove(15, 10, 25)
Sleep(60000)
MouseMove(10, 15, 25) 
MouseMove(15, 10, 25)
WEnd

Func _exit()
Exit 1
EndFunc