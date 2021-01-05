#include <GuiConstants.au3>

; First four params define the graphic region; last four params specify the region (x_min, y_max) to (x_max, y_min)
Func _GraphCreatePlane($left, $top, $width, $height, $x_min, $y_max, $x_max, $y_min)
	Local $canvas = GuiCtrlCreateGraphic($left, $top, $width, $height)
	;GUICtrlSetGraphic($canvas, $GUI_GR_COLOR, 0x000000, 0xFFFFFF)
	EnvSet("CGP" & $canvas, $left & "," & $top & "," &  $width & "," & $height & _ 
							"," & $x_min & "," & $y_min & "," & $x_max & "," & $y_max)
	Return $canvas
EndFunc


; If you don't want tick marks, use -1 as the value
Func _GraphSetAxes($canvas, $want_x_axis, $want_y_axis, $x_tick_interval = 1, $y_tick_interval = 1, _
														$axis_color = 0x0, $background_color = 0xFFFFFF)
	Local $scale_params = StringSplit(EnvGet("CGP" & $canvas), ",")
	Local $left = $scale_params[1], $top = $scale_params[2], $width = $scale_params[3], $height = $scale_params[4]
	Local $x_min = $scale_params[5], $y_max = $scale_params[6], $x_max = $scale_params[7], $y_min = $scale_params[8]
	
	GuiCtrlSetGraphic($canvas, $GUI_GR_COLOR, $axis_color)
	GuiCtrlSetBkColor($canvas, $background_color)
	
	If $want_x_axis Then
		GuiCtrlSetGraphic($canvas, $GUI_GR_MOVE, 0, $height/2)
		GuiCtrlSetGraphic($canvas, $GUI_GR_LINE, $width, $height/2)
	EndIf
	
	If $want_y_axis Then
		GuiCtrlSetGraphic($canvas, $GUI_GR_MOVE, $width/2, 0)
		GuiCtrlSetGraphic($canvas, $GUI_GR_LINE, $width/2, $height)
	EndIf

	If $y_tick_interval > 0 Then
		For $y = 0 to $height step $y_tick_interval * $height / ($y_max-$y_min) 
			GuiCtrlSetGraphic($canvas, $GUI_GR_MOVE, $width/2-2, $y)
			GuiCtrlSetGraphic($canvas, $GUI_GR_LINE, $width/2+3, $y)
		Next
	EndIf
	
	If $x_tick_interval > 0 Then
		For $x = 0 to $width step $x_tick_interval * $width / ($x_max-$x_min) 
			GuiCtrlSetGraphic($canvas, $GUI_GR_MOVE, $x, $height/2-2)
			GuiCtrlSetGraphic($canvas, $GUI_GR_LINE, $x, $height/2+3)
		Next
	EndIf

EndFunc

; The paramter $function is the name of the user-defined function; style is $GUI_GR_DOT and/or $GUI_GR_LINE
Func _GraphFunction($canvas, $function, $step = 1, $style = '', $lower_x = 0, $upper_x = 0, $color = 0x0)
	Local $x, $y
	Local $scale_params = StringSplit(EnvGet("CGP" & $canvas), ",")
	
	Local $left = $scale_params[1], $top = $scale_params[2], $width = $scale_params[3], $height = $scale_params[4]
	Local $x_min = $scale_params[5], $y_max = $scale_params[6], $x_max = $scale_params[7], $y_min = $scale_params[8]
	
	If @NumParams < 5 Then $lower_x = $x_min
	If @NumParams < 6 Then $upper_x = $x_max

	If $lower_x < $x_min Then $lower_x = $x_min
	If $upper_x > $x_max Then $upper_x = $x_max
	
	Local $SCALE_X = $width / ($x_min-$x_max) 
	Local $SCALE_Y = $height / ($y_min-$y_max) 
	
	If $style = '' Then $style = $GUI_GR_LINE
	GUICtrlSetGraphic($canvas, $GUI_GR_COLOR, $color)

	Local $plotted = 0 ;if we use line style, we need to obtain the first point prior to drawing
	
	For $x = $lower_x To $upper_x Step Abs($step)
		EnvSet("CGP_x", $x)
		$y = Call($function)
		If $y >= Number($y_min) And $y <= Number($y_max) Then
			Local $scaled_x = $x * $SCALE_X + $width/2
			Local $scaled_y = $y * $SCALE_Y + $height/2
			If $plotted = 0 Then
				GUICtrlSetGraphic($canvas, $GUI_GR_MOVE, $scaled_x, $scaled_y)
				$plotted = 1
			EndIf
			If $style = $GUI_GR_DOT OR $style = $GUI_GR_DOT+$GUI_GR_LINE Then GUICtrlSetGraphic($canvas, $GUI_GR_DOT, $scaled_x, $scaled_y)
			If $style = $GUI_GR_LINE OR $style = $GUI_GR_DOT+$GUI_GR_LINE Then GUICtrlSetGraphic($canvas, $GUI_GR_LINE, $scaled_x, $scaled_y)
		EndIf
	Next
EndFunc



Func f()
	Local $x = Number(EnvGet("CGP_x"))
	Return ($x) ^ 2 ;define your function here
EndFunc

Func g()
	Local $x = Number(EnvGet("CGP_x"))
	Return sin($x)*5  ;define your function here
EndFunc

Func h()
	Local $x = Number(EnvGet("CGP_x"))
	Return $x/2  ;define your function here
EndFunc



GuiCreate("Example Graphs ", 600, 400) ;;;;;;;;;;;;;;;;;;;;;;;;;;

$planeOne = _GraphCreatePlane(30, 20, 300, 200, -10, -10, 10, 10)
_GraphSetAxes($planeOne, 1, 1, 2, 1, 0x0, 0xFFFFFF)
_GraphFunction($planeOne, "f", 0.1, $GUI_GR_DOT, -10, 10, 0x00FF00)
_GraphFunction($planeOne, "g", 0.1, $GUI_GR_LINE, -7, 7, 0xFF0000)

$planeTwo = _GraphCreatePlane(350, 150, 200, 150, -10, -10, 10, 10)
_GraphSetAxes($planeTwo, 1, 1, -1, -1, 0xFFFFFF, 0x0)
_GraphFunction($planeTwo, "h", 1, $GUI_GR_LINE, -10, 10, 0xFF0000)
_GraphFunction($planeTwo, "g", 1, $GUI_GR_DOT+$GUI_GR_LINE, -10, 10, 0x00FF00)

GuiSetState()
while guigetmsg() <> -3
WEnd

