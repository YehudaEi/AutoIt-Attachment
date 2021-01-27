#include <Misc.au3>

$dll = DllOpen("user32.dll")
Opt("TrayIconHide", 1)
ToolTip("Press ESC to Exit!", 1, 1)

While 1
    Sleep ( 50 )
    If _IsPressed("01", $dll) Then
        MsgBox(0,"_IsPressed", "01", 1)
    EndIf
	If _IsPressed("02", $dll) Then
        MsgBox(0,"_IsPressed", "04", 1)
    EndIf
	If _IsPressed("04", $dll) Then
        MsgBox(0,"_IsPressed", "04", 1)
    EndIf
	If _IsPressed("05", $dll) Then
        MsgBox(0,"_IsPressed", "05", 1)
    EndIf
	If _IsPressed("06", $dll) Then
        MsgBox(0,"_IsPressed", "06", 1)
    EndIf
	If _IsPressed("08", $dll) Then
        MsgBox(0,"_IsPressed", "08", 1)
    EndIf
	If _IsPressed("09", $dll) Then
        MsgBox(0,"_IsPressed", "09", 1)
    EndIf
	If _IsPressed("0C", $dll) Then
        MsgBox(0,"_IsPressed", "0C", 1)
    EndIf
	If _IsPressed("0D", $dll) Then
        MsgBox(0,"_IsPressed", "0D", 1)
    EndIf
	If _IsPressed("10", $dll) Then
        MsgBox(0,"_IsPressed", "10", 1)
    EndIf
	If _IsPressed("11", $dll) Then
        MsgBox(0,"_IsPressed", "11", 1)
    EndIf
	If _IsPressed("12", $dll) Then
        MsgBox(0,"_IsPressed", "12", 1)
    EndIf
	If _IsPressed("13", $dll) Then
        MsgBox(0,"_IsPressed", "13", 1)
    EndIf
	If _IsPressed("14", $dll) Then
        MsgBox(0,"_IsPressed", "14", 1)
    EndIf
	If _IsPressed("1B", $dll) Then
        MsgBox(0,"_IsPressed", "1B", 1)
		DllClose($dll)
		Exit
    EndIf
	If _IsPressed("20", $dll) Then
        MsgBox(0,"_IsPressed", "20", 1)
    EndIf
	If _IsPressed("21", $dll) Then
        MsgBox(0,"_IsPressed", "21", 1)
    EndIf
	If _IsPressed("22", $dll) Then
        MsgBox(0,"_IsPressed", "22", 1)
    EndIf
	If _IsPressed("23", $dll) Then
        MsgBox(0,"_IsPressed", "23", 1)
    EndIf
	If _IsPressed("24", $dll) Then
        MsgBox(0,"_IsPressed", "24", 1)
    EndIf
	If _IsPressed("25", $dll) Then
        MsgBox(0,"_IsPressed", "25", 1)
    EndIf
	If _IsPressed("26", $dll) Then
        MsgBox(0,"_IsPressed", "26", 1)
    EndIf
	If _IsPressed("27", $dll) Then
        MsgBox(0,"_IsPressed", "27", 1)
    EndIf
	If _IsPressed("28", $dll) Then
        MsgBox(0,"_IsPressed", "28", 1)
    EndIf
	If _IsPressed("29", $dll) Then
        MsgBox(0,"_IsPressed", "29", 1)
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
	If _IsPressed("30", $dll) Then
        MsgBox(0,"_IsPressed", "30", 1)
    EndIf
	If _IsPressed("31", $dll) Then
        MsgBox(0,"_IsPressed", "31", 1)
    EndIf
	If _IsPressed("32", $dll) Then
        MsgBox(0,"_IsPressed", "32", 1)
    EndIf
	If _IsPressed("33", $dll) Then
        MsgBox(0,"_IsPressed", "33", 1)
    EndIf
	If _IsPressed("34", $dll) Then
        MsgBox(0,"_IsPressed", "34", 1)
    EndIf
	If _IsPressed("35", $dll) Then
        MsgBox(0,"_IsPressed", "35", 1)
    EndIf
	If _IsPressed("36", $dll) Then
        MsgBox(0,"_IsPressed", "36", 1)
    EndIf
	If _IsPressed("37", $dll) Then
        MsgBox(0,"_IsPressed", "37", 1)
    EndIf
	If _IsPressed("38", $dll) Then
        MsgBox(0,"_IsPressed", "38", 1)
    EndIf
	If _IsPressed("39", $dll) Then
        MsgBox(0,"_IsPressed", "39", 1)
    EndIf
	If _IsPressed("41", $dll) Then
        MsgBox(0,"_IsPressed", "41", 1)
    EndIf
	If _IsPressed("42", $dll) Then
        MsgBox(0,"_IsPressed", "42", 1)
    EndIf
	If _IsPressed("43", $dll) Then
        MsgBox(0,"_IsPressed", "43", 1)
    EndIf
	If _IsPressed("44", $dll) Then
        MsgBox(0,"_IsPressed", "44", 1)
    EndIf
	If _IsPressed("45", $dll) Then
        MsgBox(0,"_IsPressed", "45", 1)
    EndIf
	If _IsPressed("46", $dll) Then
        MsgBox(0,"_IsPressed", "46", 1)
    EndIf
	If _IsPressed("47", $dll) Then
        MsgBox(0,"_IsPressed", "47", 1)
    EndIf
	If _IsPressed("48", $dll) Then
        MsgBox(0,"_IsPressed", "48", 1)
    EndIf
	If _IsPressed("49", $dll) Then
        MsgBox(0,"_IsPressed", "49", 1)
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
	If _IsPressed("50", $dll) Then
        MsgBox(0,"_IsPressed", "50", 1)
    EndIf
	If _IsPressed("51", $dll) Then
        MsgBox(0,"_IsPressed", "51", 1)
    EndIf
	If _IsPressed("52", $dll) Then
        MsgBox(0,"_IsPressed", "52", 1)
    EndIf
	If _IsPressed("53", $dll) Then
        MsgBox(0,"_IsPressed", "53", 1)
    EndIf
	If _IsPressed("54", $dll) Then
        MsgBox(0,"_IsPressed", "54", 1)
    EndIf
	If _IsPressed("55", $dll) Then
        MsgBox(0,"_IsPressed", "55", 1)
    EndIf
	If _IsPressed("56", $dll) Then
        MsgBox(0,"_IsPressed", "56", 1)
    EndIf
	If _IsPressed("57", $dll) Then
        MsgBox(0,"_IsPressed", "57", 1)
    EndIf
	If _IsPressed("58", $dll) Then
        MsgBox(0,"_IsPressed", "58", 1)
    EndIf
	If _IsPressed("59", $dll) Then
        MsgBox(0,"_IsPressed", "59", 1)
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
	If _IsPressed("60", $dll) Then
        MsgBox(0,"_IsPressed", "60", 1)
    EndIf
	If _IsPressed("61", $dll) Then
        MsgBox(0,"_IsPressed", "61", 1)
    EndIf
	If _IsPressed("62", $dll) Then
        MsgBox(0,"_IsPressed", "62", 1)
    EndIf
	If _IsPressed("63", $dll) Then
        MsgBox(0,"_IsPressed", "63", 1)
    EndIf
	If _IsPressed("64", $dll) Then
        MsgBox(0,"_IsPressed", "64", 1)
    EndIf
	If _IsPressed("65", $dll) Then
        MsgBox(0,"_IsPressed", "65", 1)
    EndIf
	If _IsPressed("66", $dll) Then
        MsgBox(0,"_IsPressed", "66", 1)
    EndIf
	If _IsPressed("67", $dll) Then
        MsgBox(0,"_IsPressed", "67", 1)
    EndIf
	If _IsPressed("68", $dll) Then
        MsgBox(0,"_IsPressed", "68", 1)
    EndIf
	If _IsPressed("69", $dll) Then
        MsgBox(0,"_IsPressed", "69", 1)
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
	If _IsPressed("70", $dll) Then
        MsgBox(0,"_IsPressed", "70", 1)
    EndIf
	If _IsPressed("71", $dll) Then
        MsgBox(0,"_IsPressed", "71", 1)
    EndIf
	If _IsPressed("72", $dll) Then
        MsgBox(0,"_IsPressed", "72", 1)
    EndIf
	If _IsPressed("73", $dll) Then
        MsgBox(0,"_IsPressed", "73", 1)
    EndIf
	If _IsPressed("74", $dll) Then
        MsgBox(0,"_IsPressed", "74", 1)
    EndIf
	If _IsPressed("75", $dll) Then
        MsgBox(0,"_IsPressed", "75", 1)
    EndIf
	If _IsPressed("76", $dll) Then
        MsgBox(0,"_IsPressed", "76", 1)
    EndIf
	If _IsPressed("77", $dll) Then
        MsgBox(0,"_IsPressed", "77", 1)
    EndIf
	If _IsPressed("78", $dll) Then
        MsgBox(0,"_IsPressed", "78", 1)
    EndIf
	If _IsPressed("79", $dll) Then
        MsgBox(0,"_IsPressed", "79", 1)
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
	If _IsPressed("80H", $dll) Then
        MsgBox(0,"_IsPressed", "80H", 1)
    EndIf
	If _IsPressed("81H", $dll) Then
        MsgBox(0,"_IsPressed", "81H", 1)
    EndIf
	If _IsPressed("82H", $dll) Then
        MsgBox(0,"_IsPressed", "82H", 1)
    EndIf
	If _IsPressed("83H", $dll) Then
        MsgBox(0,"_IsPressed", "83H", 1)
    EndIf
	If _IsPressed("84H", $dll) Then
        MsgBox(0,"_IsPressed", "84H", 1)
    EndIf
	If _IsPressed("85H", $dll) Then
        MsgBox(0,"_IsPressed", "85H", 1)
    EndIf
	If _IsPressed("86H", $dll) Then
        MsgBox(0,"_IsPressed", "86H", 1)
    EndIf
	If _IsPressed("87H", $dll) Then
        MsgBox(0,"_IsPressed", "87H", 1)
    EndIf
	If _IsPressed("90", $dll) Then
        MsgBox(0,"_IsPressed", "90", 1)
    EndIf
	If _IsPressed("91", $dll) Then
        MsgBox(0,"_IsPressed", "91", 1)
    EndIf
	If _IsPressed("A0", $dll) Then
        MsgBox(0,"_IsPressed", "A0", 1)
    EndIf
	If _IsPressed("A1", $dll) Then
        MsgBox(0,"_IsPressed", "A1", 1)
    EndIf
	If _IsPressed("A2", $dll) Then
        MsgBox(0,"_IsPressed", "A2", 1)
    EndIf
	If _IsPressed("A3", $dll) Then
        MsgBox(0,"_IsPressed", "A3", 1)
    EndIf
	If _IsPressed("A4", $dll) Then
        MsgBox(0,"_IsPressed", "A4", 1)
    EndIf
	If _IsPressed("A5", $dll) Then
        MsgBox(0,"_IsPressed", "A5", 1)
    EndIf
	If _IsPressed("BA", $dll) Then
        MsgBox(0,"_IsPressed", "BA", 1)
    EndIf
	If _IsPressed("BB", $dll) Then
        MsgBox(0,"_IsPressed", "BB", 1)
    EndIf
	If _IsPressed("BC", $dll) Then
        MsgBox(0,"_IsPressed", "BC" 1)
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