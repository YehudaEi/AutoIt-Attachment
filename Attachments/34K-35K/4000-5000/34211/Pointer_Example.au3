#include "Pointer.au3"
#cs
this is my UDF example
iam using the Cheat Engine tut program
step 8 (Multilevel Pointer)
#ce

$hMemory = _MemoryOpen(ProcessExists("Tutorial-i386.exe"))
GLobal $offset[5] = [0,"C","14","0","18"] ; you must put 0 at the beginning ( the offsets must be in decimal formate )
$read = _PointerRead($hMemory,"0017C3A0",$offset)
MsgBox(0,'Test',"Address : " & $read[0] & @CRLF & "Value : " & $read[1])
$write = _PointerWrite($hMemory,"0017C3A0",$offset,"5000")
$read = _PointerRead($hMemory,"0017C3A0",$offset)
MsgBox(0,'Test',"New Address : " & $read[0] & @CRLF & "New Value : " & $read[1])