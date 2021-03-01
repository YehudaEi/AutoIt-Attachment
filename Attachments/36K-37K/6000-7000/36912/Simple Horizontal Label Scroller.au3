;coded by UEZ 2012 build 2012-03-09
#include <WindowsConstants.au3>
#include "Scroller.au3"

$iW = 640
$iH = Int($iW * 9 / 16)
$hGUI = GUICreate("Simple Horizontal Scroller", $iW, $iH, -1, -1, Default, $WS_EX_COMPOSITED)
GUISetState()

$sText = "This is a simple horizontal scroller made with AutoIt using a label! Using this technique is not the best way because label is flickering :-("

$aHScroller1= Scroller_Init($hGUI, 64, $sText, "Arial", 96, 0, 0x006000, False, False, 0xABCDEF)
If @error Then Exit MsgBox(16, "ERROR", "Unable to initiate scroller", 10)

$aHScroller2= Scroller_Init($hGUI, $iH - 64, $sText, "Comic Sans MS", 24, 0, 0, True, True)
If @error Then Exit MsgBox(16, "ERROR", "Unable to initiate scroller", 10)

HotKeySet("{F1}", "Init_Scroller_Off")
HotKeySet("{F2}", "Init_Scroller_On")
HotKeySet("{F3}", "Init_Scroller_Reset")

AdlibRegister("Scroll_It", 30)

Do
Until GUIGetMsg() = -3

_Exit()

Func Scroll_It()
	Scroller_Move($aHScroller1, 1.25)
	Scroller_Move($aHScroller2, 1)
EndFunc

Func Init_Scroller_Off()
	Scroller_Off($aHScroller1[0])
EndFunc

Func Init_Scroller_On()
	Scroller_On($aHScroller1[0])
EndFunc

Func Init_Scroller_Reset()
	Scroller_Reset($aHScroller1)
EndFunc

Func _Exit()
	AdlibUnRegister("Scroll_It")
	GUIDelete($hGUI)
	Exit
EndFunc