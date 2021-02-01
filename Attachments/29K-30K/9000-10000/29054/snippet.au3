#include <Screencapture.au3>
$filename = InputBox("Notepad's screen capture", "Type in the filename for the picture on your desktop. No extensons it will be .jpg")

ToolTip("Move to top left and hold")
Sleep(3000)
$x1 = MouseGetPos(0)
$y1 = MouseGetPos(1)
ToolTip("Move to bottom right and hold.")
Sleep(3000)
$x2 = MouseGetPos(0)
$y2 = MouseGetPos(1)
_ScreenCapture_Capture($filename & ".jpg", $x1, $y1, $x2, $y2)

ToolTip("DONE")
Sleep(2000)