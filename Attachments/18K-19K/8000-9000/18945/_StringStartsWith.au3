#include "StringStart.au3"

Global $sSingleLineComment = "//This is a C styled comment."
if (_StringStartsWith($sSingleLineComment, "//")) Then
	MsgBox(0, "Winner!", "The string starts with a '//'")
Else
	MsgBox(0, "Error", @Error)
EndIf