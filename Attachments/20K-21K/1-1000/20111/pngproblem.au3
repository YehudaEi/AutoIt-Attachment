#include <GUIConstants.au3>
#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#Include <WinAPI.au3>

$redraw = False
$gui = GUICreate("",200,200)
GUISetBkColor(0xFFFFFF)
GUISetState()
GUICtrlCreateLabel("Hover another window over this and move it away ...the boat disappear"&@CRLF&@CRLF&@CRLF&"To correct this, we can redraw the picture non stop.. Press Enable to do it and check what's happening to the shadow", 90,2,105,180)
$btn = GUICtrlCreateButton("Enable", 120, 180, 60, 20)
_GDIPlus_StartUp()
$hImage   = _GDIPlus_ImageLoadFromFile("sailboat.png")
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($gui)
_GDIPlus_GraphicsDrawImageRectRect($hGraphic, $hImage, 0, 0, 84, 128, 5, 20, 84, 128)

While 1
	$msg = GUIGetMsg()
	Switch $msg
	Case $btn 
		$redraw = True
	Case $GUI_EVENT_CLOSE
		mainwindowClose()
	EndSwitch
	If $redraw Then
		$hImage   = _GDIPlus_ImageLoadFromFile("sailboat.png")
		$hGraphic = _GDIPlus_GraphicsCreateFromHWND($gui)
		_GDIPlus_GraphicsDrawImageRectRect($hGraphic, $hImage, 0, 0, 84, 128, 5, 20, 84, 128)
	EndIf
	Sleep(100)
WEnd

Func mainwindowClose ()
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_ShutDown()
	Exit
EndFunc