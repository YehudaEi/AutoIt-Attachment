; _WinMoveAnimated and _WinTransformAnimated DEMOs
; by antiufo


#include <GUIConstants.au3>
#include "WinMoveAnimated.au3"


Send('{MEDIA_STOP}')
SoundPlay(@WindowsDir&'\Help\Tours\WindowsMediaPlayer\Audio\Wav\wmpaud7.wav')
WinMinimizeAll()

$s = GUICreate('First Window', 300, 200, 400, 100, -1, $WS_EX_TOPMOST)
GUICtrlCreateDate('Test', 50, 50)
WinSetTrans($s, '', 250)

$d = GUICreate('Second Window', 200, 300, 500, 300)
GUICtrlCreateProgress(1, 1, 200, 30)
GUICtrlSetData(-1, 75)
WinSetTrans($d, '', 100)

GUISetState(@SW_SHOW, $s)

Sleep(500)
_WinTransformAnimated($s, $d)
Sleep(500)
_WinMoveAnimated($d, 500, 200, 250)
Sleep(500)
_WinMoveAnimated($d, 255, 100, 150, '', '', 1000)
Sleep(500)
_WinMoveAnimated($d, '', '', '', -50, -50, 100)
Sleep(500)
_WinMoveAnimated($d, 500, 300, 255, @DesktopWidth/2-250, @DesktopHeight/2-150, 500)
_WinMoveAnimated($d, 450, 120, '', -5, 150, 1500)
Sleep(1000)
_WinMoveAnimated($d, 300, 350, 255)
Sleep(1000)
_WinMoveAnimated($d, 1, 1, 0, '', '', 4000)
Sleep(2000)









