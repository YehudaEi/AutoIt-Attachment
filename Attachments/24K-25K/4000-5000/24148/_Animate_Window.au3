#include <_Animate_Window_UDF.au3>
#include <GUIConstantsEx.au3>

; All examples below are set to take 0.5 of a second.

$gui = GUICreate("Hello World", -1, -1, -1, -1)
$button = GUICtrlCreateButton("Click Me!", 50, 50, -1, -1)

_Animate_Window($gui, 500, $Blend_in) ;Fades in $gui
GUISetState(@SW_SHOW, $gui)
While 1
	$GuiMSG = GUIGetMsg()
	Select
	Case $GuiMSG = $GUI_EVENT_CLOSE 
		Exit
	Case $GuiMSG = $button
		_Animate_Window($gui, 500, $roll_ddr, 1) ;Rolls $gui diagonally down right and hides
		GUISetState(@SW_HIDE, $gui)
		ExitLoop
	
	EndSelect
WEnd


_Animate_Window($gui, 500, $slide_up) ;Slides $gui up vertically
GUISetState(@SW_SHOW, $gui)
While 1 
	$GuiMSG = GUIGetMsg()
	Select
	Case $GuiMSG = $GUI_EVENT_CLOSE 
		Exit
	Case $GuiMSG = $button
		_Animate_Window($gui, 500, $implode) ;Collapses $gui inwards, Doesn't need the hide paramater because it is written in to $implode.
		GUISetState(@SW_HIDE, $gui)
		ExitLoop
	EndSelect
WEnd


_Animate_Window($gui, 500, $roll_left) ;Rolls in leftward
GUISetState(@SW_SHOW, $gui)
While 1 
	$GuiMSG = GUIGetMsg()
	Select
	Case $GuiMSG = $GUI_EVENT_CLOSE 
		Exit
	Case $GuiMSG = $button
		_Animate_Window($gui, 500, $blend_out) ;Fades out, Doesn't need the hide paramater because it is written in to $blend_out.
		GUISetState(@SW_HIDE, $gui)
		Exit
	EndSelect
WEnd