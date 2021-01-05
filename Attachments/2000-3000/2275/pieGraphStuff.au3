#include "GUIConstants.au3"
GUICreate("Example Pie Graph")

_CreatePieGraph(30, 30, 170, "30,20,20,20,10,5", 0x0, "darkred,darkgreen,darkblue,darkGray,purple,teal")

GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
WEnd


Func _CreatePieGraph($left, $top, $radius, $percentages, $borderColor = 0x0, $colors = "")
	Local $canvas = GuiCtrlCreateGraphic($left, $top, $radius*2, $radius*2)
	Local $initAngle = 90 ;start at twelve o'clock position; we want to move clockwise, so angles will be negative
	Local $i
	Local $slice = StringSplit($percentages, ",")
	Local $color = StringSplit($colors, ",")
	
	GUICtrlSetGraphic(-1,$GUI_GR_COLOR, $borderColor)
	For $i = 1 to $slice[0]
		If UBound($color) >= $slice[0] Then GUICtrlSetGraphic(-1,$GUI_GR_COLOR, $borderColor, _colorToNumber($color[$i]))
		GUICtrlSetGraphic($canvas, $GUI_GR_PIE, 0+$radius, 0+$radius, $radius, $initAngle, -Number($slice[$i]) * 3.6)
		$initAngle = $initAngle - Number($slice[$i]) * 3.6
	Next
	
	GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)
EndFunc

Func _colorToNumber($color) ;helper function
	Select
		Case $color = "black"
			Return 0x0
			
		Case $color = "darkBlue"
			Return 0x000084
			
		Case $color = "darkGreen"
			Return 0x008400
			
		Case $color = "darkCyan" or $color = "teal"
			Return 0x008484
			
		Case $color = "darkRed" or $color = "maroon"
			Return 0x840000
			
		Case $color = "darkMagenta" or $color = "purple"
			Return 0x840084
			
		Case $color = "darkYellow"
			Return 0x848400
		
		Case $color = "darkGray"
			Return 0x848484
			
		Case $color = "lightGray"
			Return 0xBFBFBF
		
		Case $color = "blue"
			Return 0x0000FF
			
		Case $color = "green"
			Return 0x00FF00
			
		Case $color = "cyan"
			Return 0x00FFFF
			
		Case $color = "red"
			Return 0xFF0000
			
		Case $color = "magenta"
			Return 0xFF00FF
			
		Case $color = "yellow"
			Return 0xFFFF00
			
		Case $color = "white"
			Return 0xFFFFFF
			
		Case Else
			Return Dec($color)
	EndSelect
EndFunc