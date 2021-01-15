#include <GUIConstants.au3>
#include <Array.au3>
AutoItSetOption("GUIOnEventMode",1)
ProcessSetPriority ( "Planetiod 3.00.exe", 4)
HotKeySet("{esc}","die")


Func die()
	Exit
EndFunc
Const $pi = 3.14159265358979,$degToRad = $pi / 180,$bound = 100
Global $pan[3], $pan_const = 1,$Window[2],$draw_field,$render
$Window[0] = 1000
$Window[1] = 1000
$pan[0] = 1
$pan[1] = 1
$pan[2] = $bound

initialize()
redraw()
	HotKeySet("{numpadsub}","zoom_out")
	HotKeySet("{numpadadd}","zoom_in")
	HotKeySet("{numpad4}","left")
	HotKeySet("{numpad8}","up")
	HotKeySet("{numpad6}","right")
	HotKeySet("{numpad2}","down")
While 1
	Sleep(500)
	redraw()
WEnd


Func redraw()
	Local $a,$b,$x,$y,$z,$xx,$yy,$zz,$movers[3],$draw2
	$render = False
	$draw2 = $Draw_Field
	$draw_field = guictrlcreategraphic(0,0,$Window[0],$Window[1])
	
	GUICtrlSetGraphic($Draw_Field,$GUI_GR_COLOR,0xffffff)

	$movers = Calc(-50,0,0)	
	guictrlsetgraphic($draw_field,$GUI_GR_MOVE,$movers[0],$movers[1])
	for $a = -50 to 50 Step 5
		$movers = Calc($a,0,0)	
		guictrlsetgraphic($draw_field,$GUI_GR_LINE,$movers[0],$movers[1])
	Next
	$movers = Calc(0,-50,0)	
	guictrlsetgraphic($draw_field,$GUI_GR_MOVE,$movers[0],$movers[1])
	for $a = -50 to 50 Step 5
		$movers = Calc(0,$a,0)	
		guictrlsetgraphic($draw_field,$GUI_GR_LINE,$movers[0],$movers[1])
	Next
	$movers = Calc(0,0,-50)	
	guictrlsetgraphic($draw_field,$GUI_GR_MOVE,$movers[0],$movers[1])
	
	for $a = -50 to 50 Step 5
		$movers = Calc(0,0,Min($a,$pan[2] -.1))
		guictrlsetgraphic($draw_field,$GUI_GR_LINE,$movers[0],$movers[1])
	Next
	
	for $x = -10 to 10 Step 5
		for $y = -10 to 10 Step 5
			for $z = -10 to 10 Step 5
				$movers = Calc($x,$y,$z)
				GUICtrlSetGraphic($draw_field,$GUI_GR_DOT,$movers[0],$movers[1])
			Next
		Next
	Next
	
	
	
	
	
	
	GUICtrlSetBkColor($draw_field,0x000000)
	GUICtrlDelete($draw2)
	Refresh()
	GUICtrlSetState($Draw_Field,0x000F)

	AdlibDisable()
	$render = true
EndFunc

func Calc($x,$y,$z)
	Local $xx,$yy,$zz,$d
	local $return[3]
	$x = $x - $pan[0]
	$y = $y - $pan[1]
	$z = $z - $pan[2]

	$xx = .5 *$Window[0]*$x/($z)
	$yy = .5 *$Window[1]*$y/($z)
	if $z < $pan[2] then 
		$return[0] = $xx + .5 * $Window[0]
		$return[1] = $yy + .5 * $Window[1]
		$return[2] = $d
	Else
		$return[2] = -100000
	EndIf
	Return $return
EndFunc

Func initialize()
	Local $x, $y,$z
	GUICreate("3D Render",$Window[0],$Window[1])
	GUISetState()
	GUISetBkColor(0x000000)
	$draw_field = guictrlcreategraphic(0,0,$Window[0],$Window[1])
EndFunc

Func Refresh()
	GUICtrlSetState($Draw_Field,0x000F)
EndFunc

func zoom_in()
	if $render then $pan[2] = $pan[2] -$pan_const
EndFunc
func zoom_out()
	if $render then $pan[2] = $pan[2] +$pan_const
EndFunc
Func left()
	if $render then $pan[0]= $pan[0] -$pan_const
EndFunc
Func right()
	if $render then $pan[0]= $pan[0] +$pan_const
EndFunc
Func up()
	if $render then $pan[1]= $pan[1] -$pan_const
EndFunc
Func down()
	if $render then $pan[1]= $pan[1] +$pan_const
EndFunc
Func Max($a,$b)
	if $a > $b then Return $a
	Return $b
EndFunc
Func Min($a,$b)
	if $a < $b then Return $a
	Return $b
EndFunc

func empty()
EndFunc


Func randcolor()
	local $number = "0x", $a
	For $a = 1 to 3
		$number = $number & String(Hex(Random(40,255,1),2))
	Next
	Return $number
EndFunc