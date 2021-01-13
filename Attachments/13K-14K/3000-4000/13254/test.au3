#include <GUIConstants.au3>
#Include <Misc.au3>
DIM $x, $y, $_PicHnd
HotKeySet("{ESC}", "f_EscPressed")

$dll = dllopen("user32.dll")

$gui = GUICreate("",190,190,$x,$y,$WS_POPUP)
#cs
		GUICtrlCreatePic(".\rahmen.bmp",0,0,190,190)
		$a = DLLCall(".\BMP2RGN.dll","int","BMP2RGN", _
					"str",".\rahmen.bmp", _
					"int",0, _
					"int",0, _
					"int",0)
		SetWindowRgn($gui, $a[0])
#ce
$_Pic = GUICtrlCreatePic(".\cover.jpg",10,10,150,150)
$_PicHnd = GUICtrlGetHandle ($_Pic)

GUISetState()
	
While 1
	If WindowFromPoint() = $_PicHnd Then _DragRegion ($gui, 150, 150, $x, $y)
WEnd

Func f_EscPressed()
		Exit
	EndFunc


;(...)
Func SetWindowRgn($h_win, $rgn)
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc

Func _DragRegion ($g,$reg_x,$reg_y,ByRef $x,ByRef $y)
	Local $pos[2],$xm,$ym,$dx,$dy
	$pos = MouseGetPos()
	$xm=$pos[0]
	$ym=$pos[1]
	If ($xm<$x) or ($xm>($x+$reg_x)) then Return
	If ($ym<$y) or ($ym>($y+$reg_y)) then Return
	$dx=$xm-$x
	$dy=$ym-$y
	while _IsPressed(01) = 1 ; left mouse button
		$pos = MouseGetPos()
		$xm=$pos[0]
		$ym=$pos[1]
		$x = $xm - $dx
		$y = $ym - $dy
		WinMove ( $g, "", $x, $y )
	wend
	Return
EndFunc

Func WindowFromPoint()
	Local $point, $cHwnd, $hwnd, $pos, $size
	$point = MouseGetPos()
	$hwnd = DLLCall($dll, "hwnd", "WindowFromPoint", "int", $point[0], "int", $point[1])

	If $hwnd[0] <> 0 Then
		$pos = WinGetPos($hwnd[0])
		If @error Then Return 0
		$size = WinGetClientSize($hwnd[0])
		If @error Then Return 0
		$pos[0] += (($pos[2] - $size[0]) / 2)
		$pos[1] += (($pos[3] - $size[1]) - (($pos[2] - $size[0]) / 2))
		$cHwnd = DLLCall($dll,"hwnd","RealChildWindowFromPoint","hwnd",$hwnd[0], _
				"int",$point[0] - $pos[0],"int",$point[1] - $pos[1])
		If $cHwnd[0] <> 0 Then $hwnd[0] = $cHwnd[0]
	EndIf
	Return $hwnd[0]
EndFunc
