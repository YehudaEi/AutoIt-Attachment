#include <StringRotate.au3>
$String="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
MsgBox(0,"String before rotation.",$String)
$RotatedString = _StringRotate("ABCDEFGHIJKLMNOPQRSTUVWXYZ",1,1) ; Rotate the string one place right
MsgBox(0,"String after rotation.",$RotatedString)
