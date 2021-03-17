If Not (@OSVersion = "WIN_7") Then
    MsgBox(16, "Error", "Windows 7 or higher required!")
Else
    DllCall("dwmapi.dll", "int", 105)
EndIf