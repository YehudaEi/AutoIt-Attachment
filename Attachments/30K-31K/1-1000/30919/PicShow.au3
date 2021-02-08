#include <WindowsConstants.au3>
#include <GDIPlus.au3>
Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)
Global $hWnd, $hGraphic, $file, $hImage
Global $iX, $iY

$file = "C:\Documents and Settings\Rendszergazda\Asztal\asd.bmp"

If Not FileExists($file) Then Exit MsgBox(16, "Error", $file & " not found!", 10)

_GDIPlus_Startup()

$hImage = _GDIPlus_ImageLoadFromFile($file)

$iX = _GDIPlus_ImageGetWidth($hImage)
$iY = _GDIPlus_ImageGetHeight($hImage)

$hWnd = GUICreate("Simple Splash Screen by UEZ", $iX, $iY, -1, -1, $WS_BORDER + $WS_SYSMENU + $WS_POPUP, $WS_EX_TOPMOST)
WinSetTrans($hWnd, "", 0)
GUISetState()
