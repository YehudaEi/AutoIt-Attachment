#include "_String.au3"

Global $sSentence = "This is a simple sentence that ends with the phrase: I would like a hamburger."
if (_StringEndsWith($sSentence, "I would like a hamburger.")) Then
	MsgBox(0, "Winner!", "The string ends with the phrase 'I would like a hamburger.'")
Else
	MsgBox(0, "Error", @Error)
EndIf