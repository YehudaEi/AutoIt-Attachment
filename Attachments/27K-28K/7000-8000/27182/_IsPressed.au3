#include <Misc.au3>

$dll = DllOpen("user32.dll")
Opt("TrayIconHide", 1)
ToolTip("Press ESC to Exit!", 1, 1)

While 1
    Sleep ( 50 )
	For $i = 1 To 9
		If _IsPressed("0"&$i, $dll) Then
			MsgBox(0,"_IsPressed", "0"&$i, 1)
		EndIf
	Next
	For $i = 10 To 14
		If _IsPressed($i, $dll) Then
			MsgBox(0,"_IsPressed", $i, 1)
		EndIf
	Next
	For $i = 20 To 79
		If _IsPressed($i, $dll) Then
			MsgBox(0,"_IsPressed", $i, 1)
		EndIf
	Next
	For $i = 90 To 91
		If _IsPressed($i, $dll) Then
			MsgBox(0,"_IsPressed", $i, 1)
		EndIf
	Next
	For $i = 80 To 87
		If _IsPressed($i&"H", $dll) Then
			MsgBox(0,"_IsPressed", $i&"H", 1)
		EndIf
	Next
	For $i = 0 To 5
		If _IsPressed("A"&$i, $dll) Then
			MsgBox(0,"_IsPressed", "A"&$i, 1)
		EndIf
	Next
	If _IsPressed("0C", $dll) Then
        MsgBox(0,"_IsPressed", "0C", 1)
    EndIf
	If _IsPressed("0D", $dll) Then
        MsgBox(0,"_IsPressed", "0D", 1)
    EndIf
	If _IsPressed("1B", $dll) Then
        MsgBox(0,"_IsPressed", "1B", 1)
		DllClose($dll)
		Exit
    EndIf
	If _IsPressed("2A", $dll) Then
        MsgBox(0,"_IsPressed", "2A", 1)
    EndIf
	If _IsPressed("2B", $dll) Then
        MsgBox(0,"_IsPressed", "2B", 1)
    EndIf
	If _IsPressed("2C", $dll) Then
        MsgBox(0,"_IsPressed", "2C", 1)
    EndIf
	If _IsPressed("2D", $dll) Then
        MsgBox(0,"_IsPressed", "2D", 1)
    EndIf
	If _IsPressed("2E", $dll) Then
        MsgBox(0,"_IsPressed", "2E", 1)
    EndIf
	If _IsPressed("4A", $dll) Then
        MsgBox(0,"_IsPressed", "4A", 1)
    EndIf
	If _IsPressed("4B", $dll) Then
        MsgBox(0,"_IsPressed", "4B", 1)
    EndIf
	If _IsPressed("4C", $dll) Then
        MsgBox(0,"_IsPressed", "4C", 1)
    EndIf
	If _IsPressed("4D", $dll) Then
        MsgBox(0,"_IsPressed", "4D", 1)
    EndIf
	If _IsPressed("4E", $dll) Then
        MsgBox(0,"_IsPressed", "4E", 1)
    EndIf
	If _IsPressed("4F", $dll) Then
        MsgBox(0,"_IsPressed", "4F", 1)
    EndIf
	If _IsPressed("5A", $dll) Then
        MsgBox(0,"_IsPressed", "5A", 1)
    EndIf
	If _IsPressed("5B", $dll) Then
        MsgBox(0,"_IsPressed", "5B", 1)
    EndIf
	If _IsPressed("5C", $dll) Then
        MsgBox(0,"_IsPressed", "5C", 1)
    EndIf
	If _IsPressed("6A", $dll) Then
        MsgBox(0,"_IsPressed", "6A", 1)
    EndIf
	If _IsPressed("6B", $dll) Then
        MsgBox(0,"_IsPressed", "6B", 1)
    EndIf
	If _IsPressed("6C", $dll) Then
        MsgBox(0,"_IsPressed", "6C", 1)
    EndIf
	If _IsPressed("6D", $dll) Then
        MsgBox(0,"_IsPressed", "6D", 1)
    EndIf
	If _IsPressed("6E", $dll) Then
        MsgBox(0,"_IsPressed", "6E", 1)
    EndIf
	If _IsPressed("6F", $dll) Then
        MsgBox(0,"_IsPressed", "6F", 1)
    EndIf
	If _IsPressed("7A", $dll) Then
        MsgBox(0,"_IsPressed", "7A", 1)
    EndIf
	If _IsPressed("7B", $dll) Then
        MsgBox(0,"_IsPressed", "7B", 1)
    EndIf
	If _IsPressed("7C", $dll) Then
        MsgBox(0,"_IsPressed", "7C", 1)
    EndIf
	If _IsPressed("7D", $dll) Then
        MsgBox(0,"_IsPressed", "7D", 1)
    EndIf
	If _IsPressed("7E", $dll) Then
        MsgBox(0,"_IsPressed", "7E", 1)
    EndIf
	If _IsPressed("7F", $dll) Then
        MsgBox(0,"_IsPressed", "7F", 1)
    EndIf
	If _IsPressed("BA", $dll) Then
        MsgBox(0,"_IsPressed", "BA", 1)
    EndIf
	If _IsPressed("BB", $dll) Then
        MsgBox(0,"_IsPressed", "BB", 1)
    EndIf
	If _IsPressed("BC", $dll) Then
        MsgBox(0,"_IsPressed", "BC", 1)
    EndIf
	If _IsPressed("BD", $dll) Then
        MsgBox(0,"_IsPressed", "BD", 1)
    EndIf
	If _IsPressed("BE", $dll) Then
        MsgBox(0,"_IsPressed", "BE", 1)
    EndIf
	If _IsPressed("BF", $dll) Then
        MsgBox(0,"_IsPressed", "BF", 1)
    EndIf
	If _IsPressed("C0", $dll) Then
        MsgBox(0,"_IsPressed", "C0", 1)
    EndIf
	If _IsPressed("DB", $dll) Then
        MsgBox(0,"_IsPressed", "DB", 1)
    EndIf
	If _IsPressed("DC", $dll) Then
        MsgBox(0,"_IsPressed", "DC", 1)
    EndIf
	If _IsPressed("DD", $dll) Then
        MsgBox(0,"_IsPressed", "DD", 1)
    EndIf	
WEnd