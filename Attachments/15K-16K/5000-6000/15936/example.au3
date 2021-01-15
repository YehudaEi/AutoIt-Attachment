;#include <pixel.au3>
#include "_fastSearch.au3"
$T1 = TimerInit()
$array =  _fastSearch(0,0,@DesktopWidth,@DesktopHeight, 0xab0f1d);some random color
$Time = TimerDiff ($T1)
MsgBox (0, $Time, "X = " & $array[0]& "     Y = " & $array[1]);the title is the time in miliseconds
$T2 = TimerInit()
$array =  PixelSearch(0,0,@DesktopWidth,@DesktopHeight, 0xab0f1d) ;same random color
$Time = TimerDiff ($T2)
MsgBox (0, $Time, "@error =" & $array);the title is the time in miliseconds