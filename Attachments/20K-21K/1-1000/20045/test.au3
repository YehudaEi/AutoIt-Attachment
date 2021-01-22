#include "IE.au3"



_IECreate("https://www.google.com",0,1,1,1)


if @error <> 0 Then
	
	MsgBox(0, "Error Message", "@error")
	
	
	EndIf