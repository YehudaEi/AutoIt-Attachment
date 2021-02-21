#include <ClipBoard.au3>
#include <ScreenCapture.au3>
WinActivate("BAR")
Sleep(1000)
If WinActive("BAR.OCHY") Then
    MsgBox(0,"Window 1","Inside BAR.OCHY window",1)
	WinActivate("BAR.OCHY")
    _ClipBoard_Open(0)
    Sleep(500)
    _ClipBoard_Empty()
	Sleep(500)
    ; Capture full screen
	;_ScreenCapture_Capture("C:\Dennis.jpg",0,0,796,596)
	MouseClickDrag("left",80,480,270,500)
	Send("!C")
	Sleep(500)
	Run("Notepad.exe")
	Sleep(500)
	WinActivate("Untitled - Notepad")
	Sleep(500)
	Send("1234")
	Sleep(500)
	;Send("({CTRLDOWN}v{CTRLUP}")
	Sleep(1000)
	Send("^V")
	Send("56789")
	MsgBox(0,"Window","Task Completed",2)
Else
	MsgBox(0,"Window","Not in right window",1)
EndIf
Exit