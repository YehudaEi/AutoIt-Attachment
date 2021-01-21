#include "Bin.au3"

$temp = InputBox( "", "Enter a decimal number: " )
MsgBox( 0, "Result", "The binary form of   " & $temp & "   is   " & Bin( $temp ) )