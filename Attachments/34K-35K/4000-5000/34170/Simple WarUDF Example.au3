#include<WarUDF.au3>

$ReturnKey = WarUdf(@ScriptDir,"test.ini","test section","test")

If $ReturnKey = 0 Then
	MsgBox(0,"Welcome", "Welcome to this script!" & @CRLF & "You seem to be new here!")
Else
	MsgBox(0,"Welcome back", "Welcome back!" & @CRLF & "You have been here before!" & @CRLF & "To reset the script delete test.ini file." & @CRLF & "Its in the same place as this script!")
EndIf

