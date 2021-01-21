; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1 Beta
; Author:         Christoph Krogmann <Ch.Krogmann@gmx.de>
;
; Script Function: Example for _PixelGetColorMouse function.
;	
;
; ----------------------------------------------------------------------------
#include <GuiConstants.au3>
#include <PGCMouse.au3>
If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000

GuiCreate("Example", 418, 119,(@DesktopWidth-418)/2, (@DesktopHeight-119)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$Label_1 = GuiCtrlCreateLabel("Colour under mouse: ", 20, 40, 100, 20)
$Input_2 = GuiCtrlCreateInput("", 140, 40, 100, 20)
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
$color = _PixelGetColorMouse()
GUICtrlSetData($Input_2, $color)
Sleep(20)
WEnd
Exit
