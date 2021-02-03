;#include <GuiConstantsEx.au3>
#include <ClipBoard.au3>
;#include <WindowsConstants.au3>
#Include <ScreenCapture.au3>

HotKeySet("^s","ScreenCapture")
HotKeySet("^q","Quit")

While 1
    Sleep(100)
WEnd

Func Quit()
	Exit
EndFunc

Func ScreenCapture()

	Send("{PRINTSCREEN}")

;	_ClipBoard_Open(0) ; open clipboard is associated with the current task
	$hBitmap = _ClipBoard_GetData($CF_BITMAP) ; $CF_BITMAP

	MsgBox(4096,"ClipBoardGetData", $CF_BITMAP)

;	$HBitmap = _ScreenCapture_Capture("")      ; This works for 2D screen!

	_ScreenCapture_SaveImage("ScreenCap.bmp", $hBitmap)
;	_ClipBoard_Close()

	Exit
EndFunc
