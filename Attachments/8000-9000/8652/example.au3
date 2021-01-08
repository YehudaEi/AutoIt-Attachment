#include <guiconstants.au3>
#include <pbar.au3>
#cs
    Example to :
    _CreateProcessBar()
    _UpdateProcessBar()
    _DeleteProcessBar()
    (C) By Busti
    thx to :
    Jaenster , for the math func;)
#ce
Local $Bar
If Not IsDeclared('Dark_Green') Then Dim $Dark_Green = 0x006400
If Not IsDeclared('Red') Then Dim $Red = 0xff0000
If Not IsDeclared('Yellow') Then Dim $Yellow = 0xffff00
Dim $lastprocess=1,$up=0
GUICreate("_CreateProcess()", 392, 111, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
;$Progress_1 = GuiCtrlCreateProgress(30, 30, 320, 20)
$Button_2 = GUICtrlCreateButton("start", 30, 60, 80, 30)
GUISetState()
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            _DeleteProcessBar($Bar)
            ExitLoop
        Case $msg = $Button_2
            If Not IsArray($Bar) Then
                _DeleteProcessBar($Bar)
                $Bar = _CreateProcessBar(0,30,30,320,20,0x123456,2)
            EndIf
            For $i = 0 To 100 Step 1
                Sleep(100)
                $up = _UpdateProcessBar($Bar,$i)
                If $i = 100 Then ExitLoop
            Next
    EndSelect
WEnd

Func redrawgui($guiitemarray)
	If Not IsArray($guiitemarray) Then
		
	Else
		
	EndIf
	
EndFunc
