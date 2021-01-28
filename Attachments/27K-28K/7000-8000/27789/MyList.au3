#include <GUIConstants.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <array.au3>
Global $ListHwnd, $ListRect
Global $fn = "D:\Documents and Settings\DarkFenix\Desktop\Projects\FarCry 1.bmp"
Global $gui = GUICreate("",500,500,-1,-1)
GUIRegisterMsg($WM_CTLCOLORSTATIC,"PaintFunc")
ListCreate()
Global $WM_NEEDSDRAW = 0
Global $DrawCount = 0
GUISetState()
;~ GDIDraw()
While 1
	If $WM_NEEDSDRAW Then
		If $WM_NEEDSDRAW == $ListHwnd Then
			ListRedraw()
;~ 			MsgBox(-1,"","Drawing the list")
		EndIf
		$WM_NEEDSDRAW = 0
	EndIf

	$tmsg = GUIGetMsg()
	If $tmsg == -3 Then ExitLoop
WEnd

;~ MsgBox(-1,"",$DrawCount)
Func ListCreate()
	$ListID = GUICtrlCreateLabel("List 1",10,10,480,75)
	GUICtrlSetBkColor(-1,0x000000)
	$ListHwnd = GUICtrlGetHandle(-1)
	$ListRect = GetWindowRect($ListHwnd)

EndFunc

Func ListRedraw()
	ListDraw()
EndFunc

Func ListDraw()
	Local $rect = $ListRect
	$x = 1
	$y = 11
	$w = $rect[2]-2
	$h = $rect[3]-12
	$r = Min($h,$w)*0.15
	_GDIPlus_Startup()
	$graph = _GDIPlus_GraphicsCreateFromHWND($ListHwnd)
	$image = _GDIPlus_ImageLoadFromFile($fn)
	$pen = _GDIPlus_PenCreate(0xffff0000,2)
;~ 	$temp = _GDIPlus_GraphicsDrawImage($graph,$image,0,0)
;~ 	_GDIPlus_DrawArcs($graph,$x,$y,$w,$h,$r,$pen)
;~ 	_GDIPlus_DrawLines($graph,$x,$y,$w,$h,$r,$pen)
	$temp = _GDIPlus_GraphicsDrawHex($graph,$x,$y,$w,$h,$w-$r*2,$h-$r*2,50,$pen)
	_GDIPlus_BitmapDispose($image)
	_GDIPlus_GraphicsDispose($graph)
	_GDIPlus_Shutdown()
EndFunc


Func PaintFunc($lhwnd,$msg,$lparam,$wparam)
	If $lhwnd <> $gui Then Return $GUI_RUNDEFMSG
	$WM_NEEDSDRAW = $wparam
	Return $GUI_RUNDEFMSG
EndFunc

Func _GDIPlus_DrawArcs($hwnd,$x,$y,$w,$h,$r,$pen)
	Local $temp
	Local $r2 = $r*2
	$temp = _GDIPlus_GraphicsDrawArc($hwnd,$x,$y,$r2,$r2,180,90,$pen)
	If Not $temp Then Return 0
	$temp = _GDIPlus_GraphicsDrawArc($hwnd,$x+$w-$r2,$y,$r2,$r2,270,90,$pen)
	If Not $temp Then Return 0
	$temp = _GDIPlus_GraphicsDrawArc($hwnd,$x,$y+$h-$r2,$r2,$r2,90,90,$pen)
	If Not $temp Then Return 0
	$temp = _GDIPlus_GraphicsDrawArc($hwnd,$x+$w-$r2,$y+$h-$r2-1,$r2,$r2,0,90,$pen)
	Return $temp
EndFunc

Func _GDIPlus_DrawLines($hwnd,$x,$y,$w,$h,$r,$pen)
	Local $temp
	$temp = _GDIPlus_GraphicsDrawLine($hwnd,$x+$r,$y,$x+$w-$r,$y,$pen)
	If Not $temp Then Return 0
	$temp = _GDIPlus_GraphicsDrawLine($hwnd,$x+$r,$y+$h,$x+$w-$r,$y+$h,$pen)
	If Not $temp Then Return 0
	$temp = _GDIPlus_GraphicsDrawLine($hwnd,$x,$y+$r,$x,$y+$h-$r,$pen)
	If Not $temp Then Return 0
	$temp = _GDIPlus_GraphicsDrawLine($hwnd,$x+$w,$y+$r,$x+$w,$y+$h-$r,$pen)
	Return $temp
EndFunc

Func _GDIPlus_GraphicsDrawHex($hwnd,$x,$y,$w,$h,$a,$b,$c,$pen)
	$r = ($w-$a)/2
	Local $points[11][2]
	Local $timer
	$points[0][0] = $x+$r
	$points[0][1] = $y

	$points[1][0] = $x+$r+($a/2)-$c
	$points[1][1] = $y

	$points[2][0] = $x+$r+($a/2)+$c
	$points[2][1] = $y

	$points[3][0] = $x+$r+$a
	$points[3][1] = $y

	$points[4][0] = $x+$w
	$points[4][1] = $y+$r

	$points[5][0] = $x+$w
	$points[5][1] = $y+$r+$b

	$points[6][0] = $x+$r+$a
	$points[6][1] = $y+$h

	$points[7][0] = $x+$r
	$points[7][1] = $y+$h

	$points[8][0] = $x
	$points[8][1] = $y+$b+$r

	$points[9][0] = $x
	$points[9][1] = $y+$r

	$points[10][0] = $x+$r
	$points[10][1] = $y

	For $i = 1 To 10
		$timer = TimerInit()
		If $i == 2 Then ContinueLoop
		While Not _GDIPlus_GraphicsDrawLine($hwnd,$points[$i-1][0],$points[$i-1][1],$points[$i][0],$points[$i][1],$pen)
			If TimerDiff($timer) > 5000 Then
				MsgBox(-1,"","GDI Error")
				Return 0
			EndIf
		WEnd
	Next
	Return 1
EndFunc

Func GetWindowRect($hwnd)
	Local $struct = _WinAPI_GetWindowRect($hwnd)
	Local $ret[4]
	$ret[0] = DllStructGetData($struct,"Left")
	$ret[1] = DllStructGetData($struct,"Top")
	$ret[2] = DllStructGetData($struct,"Right") - $ret[0]
	$ret[3] = DllStructGetData($struct,"Bottom") - $ret[1]
	Return $ret
EndFunc

Func Min($a,$b)
	If $a < $b Then Return $a
	Return $b
EndFunc
