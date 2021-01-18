#include <GUIConstants.au3>
#include "GUIEnhance.au3"

Opt("GUIOnEventMode", 1)
$GUI = GUICreate("", 350, 150)
$btnTL = GUICtrlCreateButton("Test Button", -80, -25, 80, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$btnTR = GUICtrlCreateButton("Test Button", 600, -25, 80, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$btnBL = GUICtrlCreateButton("Test Button", -80, 500, 80, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$btnBR = GUICtrlCreateButton("Test Button", 600, 500, 80, 25)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$label1 = GUICtrlCreateLabel("This is a label for demonstration purposes.", 10, 30)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$label2 = GUICtrlCreateLabel("This is a label for demonstration purposes.", 10, 30)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$label3 = GUICtrlCreateLabel("This is a label for demonstration purposes.", 10, 60)
GUICtrlSetResizing(-1, $GUI_DOCKALL)
$label4 = GUICtrlCreateLabel("This is a label for demonstration purposes.", 10, 90, -1, 16)
GUICtrlSetResizing(-1, $GUI_DOCKALL)

_GUIEnhanceAnimateWin ($GUI, 1000, $GUI_EN_ANI_FADEIN)
GUISetState()
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
Local $aiTemp[2] = [0, 0]
ClientToScreen($GUI, $aiTemp[0], $aiTemp[1])
Global $bgcolor = PixelGetColor($aiTemp[0], $aiTemp[1])
ConsoleWrite($bgcolor & @CRLF)
GUICtrlSetColor($label1, $bgcolor)
_GUIEnhanceAnimateTitle ($GUI, "GUI Enhance UDF Test :: RazerM", $GUI_EN_TITLE_DROP)
Sleep(1000)
_GUIEnhanceAnimateTitle ($GUI, "GUI Enhance UDF Test :: RazerM", $GUI_EN_TITLE_SLIDE)
Sleep(1000)
_GUIEnhanceCtrlDrift ($GUI, $label4, 10, 120)
_GUIEnhanceCtrlDrift ($GUI, $label3, 10, 90)
_GUIEnhanceCtrlDrift ($GUI, $label2, 10, 60)
_GUIEnhanceCtrlFade ($label1, 3000, True, False, $bgcolor, 0x000000)
Local $aLabels[2] = [$label2, $label3]
_GUIEnhanceCtrlFade ($aLabels, 1500, True, False, 0x000000, $bgcolor)
_GUIEnhanceCtrlDrift ($GUI, $label4, 10, 60)
_GUIEnhanceCtrlFade ($label4, 1000, False, True, $bgcolor, 0x000000)
_GUIEnhanceCtrlFade ($label4, 1000, True, False, 0x000000, 0xFF0000)
_GUIEnhanceCtrlFade ($label4, 1000, False, True, 0x000000, $bgcolor)

_GUIEnhanceScaleWin ($GUI, 250, 350, True, 10, 25) ;add 250 to width, add 350 to height, centre win: true

_GUiEnhanceCtrlDrift ($GUI, $btnTL, 305, 255, 2)
_GUiEnhanceCtrlDrift ($GUI, $btnTR, 215, 255, 4)
_GUiEnhanceCtrlDrift ($GUI, $btnBL, 305, 220, 6)
_GUiEnhanceCtrlDrift ($GUI, $btnBR, 215, 220, 8)

While 1
	Sleep(5000)
WEnd

Func ClientToScreen($hwnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hwnd, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local
	$stPoint = 0
EndFunc   ;==>ClientToScreen

Func _exit()
	_GUIEnhanceAnimateWin ($GUI, 700, $GUI_EN_ANI_FADEOUT)
	Exit
EndFunc   ;==>_exit