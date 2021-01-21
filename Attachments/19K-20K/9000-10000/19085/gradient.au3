#include <GUIConstants.au3>

$gui = GUICreate("My GUI"); will create a dialog box that when displayed is centered
$picbk = guictrlcreateLabel("",20,50,205,15)
GUICtrlSetBkColor(-1,0x0000ff)
$pic = guictrlcreatepic("gradientbar2.bmp",20,50,5,15)
GUISetState (@SW_SHOW)
 
for $n = 1 to 200
    ControlMove($gui,"",$pic,20,50,5 + $n,15)
    sleep(20)
Next

MsgBox(0, "done", "loading c0mp1337")
Exit

while guigetmsg() <> -3
    
    WEnd