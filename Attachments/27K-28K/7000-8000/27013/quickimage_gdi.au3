#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

_GDIPlus_Startup()
Global $BackG = _GDIPlus_ImageLoadFromFile("simple.jpg")

$MainGui = GUICreate("Example",640,480,-1,-1)
GUISetState()
Global $Graphic = _GDIPlus_GraphicsCreateFromHWND($MainGui)
_GDIPlus_GraphicsDrawImageRect($Graphic, $BackG,0,0,640,480)

$tstlabel=GuiCtrlCreateLabel("restore", 280, 200, 75, 20)
GUICtrlSetBkColor($tstlabel, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetCursor(-1, 0)
$_tst = GUICtrlCreateButton("Check", 280, 240, 76)

While 1
    $MSG = GUIGetMsg()
    Switch $MSG
        Case -3
            Quit()
    EndSwitch
WEnd

Func Quit()
    _GDIPlus_ImageDispose($BackG)
    _GDIPlus_GraphicsDispose($Graphic)
    _GDIPlus_Shutdown()
    Exit
EndFunc