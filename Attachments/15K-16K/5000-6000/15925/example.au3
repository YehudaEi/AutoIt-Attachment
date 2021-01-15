
#include "_fastSearch.au3"
$array =  _fastSearch(0,0,100,100, 0xFFFFFF);0xFFFFFF = white
MsgBox (0, "", "X = " & $array[0]& "     Y = " & $array[1]);x and Y coords of first white found
$array =  _fastSearch(0,0,100,100, 0x0f2f61);0x0f2f61 = some random color
MsgBox (0, "", "X = " & $array[0]& "     Y = " & $array[1]);x and Y coords of it found or -1, -1 if not
$array =  _fastSearch(0,0,100,100, 0xFFFFFF, 1, 1, 200);0xFFFFFF = white but in a large radius circle
MsgBox (0, "", "X = " & $array[0]& "     Y = " & $array[1]);x and Y coords of first white found