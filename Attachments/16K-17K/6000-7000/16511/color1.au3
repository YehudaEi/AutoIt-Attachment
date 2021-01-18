#include <Color.au3>
#include <GUIConstants.au3>
#NoTrayIcon
AutoItSetOption("GUIOnEventMode",1)


;$mainwindow = GUICreate("Color1", 200, 100)
$mainwindow = GUICreate("Color1", 1,1,-200,-100,0x00C00000,$WS_EX_TOOLWINDOW)

GUISetOnEvent($GUI_EVENT_CLOSE, "DoQuit")
$DataHerebutton = GUICtrlCreateButton("Data", 50, 5, 60, 20)
$Box = GUICtrlCreateEdit ( "", 50, 50, 120, 40 )
GUICtrlSetOnEvent($DataHerebutton, "DataHere")
GUISetState(@SW_SHOW)

While 1
  Sleep(100)  
WEnd

Func DataHere ()
$nColor=GUICtrlRead($Box)
$r=_ColorGetRed($nColor)
$g=_ColorGetGreen($nColor)
$b=_ColorGetBlue($nColor)
$st="R: "&string($r)&" G: "&string($g)& " B: "&string($b)
ControlSetText("Test1","","Edit1",$st);
EndFunc	
	
Func DoQuit ()
	 Exit
EndFunc


