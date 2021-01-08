#include <GUIConstants.au3>
#include <Misc.au3>
$dll = DllOpen("user32.dll")

Opt("ColorMode",0)

$Form1 = GUICreate("Tools", 337, 39, 300, 600, -1, $WS_EX_TOOLWINDOW)
$Button1 = GUICtrlCreateButton("Choose Color", 8, 8, 97, 25)
$Button2 = GUICtrlCreateButton("Exit", 232, 8, 97, 25)
$Button3 = GUICtrlCreateButton("Eraser Tool", 120, 8, 97, 25)
GUISetState(@SW_SHOW)

$color = 0x000000

Func quit()
	DllClose($dll)
	  Run("Explorer.exe", "", @SW_MAXIMIZE)
	Exit
EndFunc

Func eraser()
GUICreate("Eraser", 100, 0)
EndFunc

Func drawpix($dc,$x,$y,$color)
DllCall ("gdi32.dll", "long", "SetPixel", "long", $dc[0], "long", $x, "long", $y, "long", $color)
EndFunc

Func Color_Box()
	$color = 0
    $color = _ChooseColor (0)
EndFunc

Func shape_square($x,$y)
$dc= DllCall ("user32.dll", "int", "GetDC", "hwnd", "")
drawpix($dc,$x+1,$y+0,$color)
drawpix($dc,$x+1,$y+1,$color)
drawpix($dc,$x+1,$y+3,$color)
drawpix($dc,$x+1,$y+4,$color)
drawpix($dc,$x+1,$y+5,$color)
drawpix($dc,$x+1,$y+6,$color)
drawpix($dc,$x+1,$y+7,$color)
drawpix($dc,$x+1,$y+8,$color)
drawpix($dc,$x+1,$y+9,$color)
drawpix($dc,$x+2,$y+0,$color)
drawpix($dc,$x+2,$y+1,$color)
drawpix($dc,$x+2,$y+3,$color)
drawpix($dc,$x+2,$y+4,$color)
drawpix($dc,$x+2,$y+5,$color)
drawpix($dc,$x+2,$y+6,$color)
drawpix($dc,$x+2,$y+7,$color)
drawpix($dc,$x+2,$y+8,$color)
drawpix($dc,$x+2,$y+9,$color)
drawpix($dc,$x+3,$y+0,$color)
drawpix($dc,$x+3,$y+1,$color)
drawpix($dc,$x+3,$y+3,$color)
drawpix($dc,$x+3,$y+4,$color)
drawpix($dc,$x+3,$y+5,$color)
drawpix($dc,$x+3,$y+6,$color)
drawpix($dc,$x+3,$y+7,$color)
drawpix($dc,$x+3,$y+8,$color)
drawpix($dc,$x+3,$y+9,$color)
drawpix($dc,$x+4,$y+0,$color)
drawpix($dc,$x+4,$y+1,$color)
drawpix($dc,$x+4,$y+3,$color)
drawpix($dc,$x+4,$y+4,$color)
drawpix($dc,$x+4,$y+5,$color)
drawpix($dc,$x+4,$y+6,$color)
drawpix($dc,$x+4,$y+7,$color)
drawpix($dc,$x+4,$y+8,$color)
drawpix($dc,$x+4,$y+9,$color)
drawpix($dc,$x+5,$y+0,$color)
drawpix($dc,$x+5,$y+1,$color)
drawpix($dc,$x+5,$y+3,$color)
drawpix($dc,$x+5,$y+4,$color)
drawpix($dc,$x+5,$y+5,$color)
drawpix($dc,$x+5,$y+6,$color)
drawpix($dc,$x+5,$y+7,$color)
drawpix($dc,$x+5,$y+8,$color)
drawpix($dc,$x+5,$y+9,$color)
drawpix($dc,$x+6,$y+0,$color)
drawpix($dc,$x+6,$y+1,$color)
drawpix($dc,$x+6,$y+3,$color)
drawpix($dc,$x+6,$y+4,$color)
drawpix($dc,$x+6,$y+5,$color)
drawpix($dc,$x+6,$y+6,$color)
drawpix($dc,$x+6,$y+7,$color)
drawpix($dc,$x+6,$y+8,$color)
drawpix($dc,$x+6,$y+9,$color)
drawpix($dc,$x+7,$y+0,$color)
drawpix($dc,$x+7,$y+1,$color)
drawpix($dc,$x+7,$y+3,$color)
drawpix($dc,$x+7,$y+4,$color)
drawpix($dc,$x+7,$y+5,$color)
drawpix($dc,$x+7,$y+6,$color)
drawpix($dc,$x+7,$y+7,$color)
drawpix($dc,$x+7,$y+8,$color)
drawpix($dc,$x+7,$y+9,$color)
drawpix($dc,$x+8,$y+0,$color)
drawpix($dc,$x+8,$y+1,$color)
drawpix($dc,$x+8,$y+3,$color)
drawpix($dc,$x+8,$y+4,$color)
drawpix($dc,$x+8,$y+5,$color)
drawpix($dc,$x+8,$y+6,$color)
drawpix($dc,$x+8,$y+7,$color)
drawpix($dc,$x+8,$y+8,$color)
drawpix($dc,$x+8,$y+9,$color)
drawpix($dc,$x+9,$y+0,$color)
drawpix($dc,$x+9,$y+1,$color)
drawpix($dc,$x+9,$y+3,$color)
drawpix($dc,$x+9,$y+4,$color)
drawpix($dc,$x+9,$y+5,$color)
drawpix($dc,$x+9,$y+6,$color)
drawpix($dc,$x+9,$y+7,$color)
drawpix($dc,$x+9,$y+8,$color)
drawpix($dc,$x+9,$y+9,$color)
DllCall ("user32.dll", "int", "ReleaseDC", "hwnd", 0,  "int", $dc[0])
EndFunc

While 1
	$pos= MouseGetPos()
	If _IsPressed("01", $dll) Then shape_square($pos[0],$pos[1])
	ProcessClose("Explorer.exe")
	
	$msg = GUIGetMsg()
    Select
		Case $msg = $Button1
			Color_Box()
		Case $msg = $Button2
			quit()
		Case $msg = $Button3
			eraser()
	EndSelect
WEnd
