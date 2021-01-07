#include <GUIConstants.au3>

Global Const $MF_BYCOMMAND = 0x00000000
Global Const $MF_BYPOSITION = 0x00000400
Global Const $IMAGE_BITMAP = 0
Global Const $LR_LOADMAP3DCOLORS = 0x00001000
Global Const $LR_LOADFROMFILE = 0x0010

GUICreate("AddImageToMenu",100,100,-1,-1,$WS_OVERLAPPEDWINDOW)

$trackmenu = GuiCtrlCreateContextMenu()

GuiCtrlCreateMenuItem("Item 1",$trackmenu)
GuiCtrlCreateMenuItem("Item 2",$trackmenu)
GuiCtrlCreateMenuItem("Item 3",$trackmenu)

AddImageToMenu($trackmenu, $MF_BYPOSITION, 1, ".\AddImageToMenu.bmp")

GUISetState()

While GUIGetMsg() <> -3
WEnd

Func AddImageToMenu($ParentMenu, $IndexType, $MenuIndex, $BitmapMenu)
	$hBmpMenu = DllCall("user32.dll", "hwnd", "LoadImage", "hwnd", 0, _
												           "str", $BitmapMenu, _
												           "int", $IMAGE_BITMAP, _
												           "int", 0, _
												           "int", 0, _
												           "int", BitOR($LR_LOADFROMFILE, $LR_LOADMAP3DCOLORS))
	$hBmpMenu = $hBmpMenu[0]
	DllCall("user32.dll", "int", "SetMenuItemBitmaps", "hwnd", GUICtrlGetHandle($ParentMenu), _
                                                       "int",  $MenuIndex, _
													   "int",  $IndexType, _
													   "hwnd", $hBmpMenu, _
													   "hwnd", $hBmpMenu)
EndFunc
