#region ;Code generated by ShapedGUI Creator by Ed_Maximized
#include <GUIConstants.au3>

$GUI = GUICreate("test",333,333,-1,@DesktopHeight,$ws_popup)
GUISetBkColor(0xFFFFFF)
GUICtrlCreatePic(@ScriptDir&"\moon.gif", 0, 0,333,333)
GUICtrlSetState(-1, $GUI_DISABLE)

$a = CreatePolyRgn("8,173,9,151,15,124,26,94,43,68,62,49,85,31,108,20,134,12,161,8,181,9,205,12,231,21,256,35,279,55,291,69,308,98,320,137,322,180,317,213,304,249,284,275,252,301,227,315,203,323,172,326,141,323,113,315,85,303,65,288,46,269,30,247,15,213,10,191")
SetWindowRgn($GUI,$a)

GUISetState()
WinSetOnTop("test","",1)
While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then Exit
	$wpos=WinGetPos("test","")
	$wpos[1] -=1
	WinMove("test","",$wpos[0],$wpos[1])
	sleep(100)
	if $wpos[1]<=-333 then Exit
WEnd

Func SetWindowRgn($h_win, $rgn)
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc

Func CreatePolyRgn($pt)
    Local $ALTERNATE = 1
    Local $buffer = ""
    $pt = StringSplit($pt,",")
    For $i = 1 to $pt[0]
        $buffer = $buffer & "int;"
    Next
    $buffer = StringTrimRight($buffer,1)
    $lppt = DllStructCreate($buffer)
    For $i = 1 to $pt[0]
        DllStructSetData($lppt,$i,$pt[$i])
    Next
    $ret = DllCall("gdi32.dll","long","CreatePolygonRgn", _
            "ptr",DllStructGetPtr($lppt),"int",Int($pt[0] / 2), _
            "int",$ALTERNATE)
    $lppt = 0
    Return $ret[0]
EndFunc
#endregion
