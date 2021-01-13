;Mindreader by spyrorocks
#include <GUIConstants.au3>
Global $wait = 10, $Guessme
Global $color = StringSplit("0XFFFFFF,0x00FF00,0xFF0000,0x0000FF,0xF0F000,0xCCCCCC,0x99FF00,0xFF9900,0x0FF0F0,0xFF66CC,0xCC33CC,0x669900", ",")
$Form1 = GUICreate("MindReader - By Spyrorocks", 529, 411, 209, 149)
$Group1 = GUICtrlCreateGroup("Numbers/Colors", 168, 80, 353, 321)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Your Color", 8, 80, 153, 153)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$dispcolor = GUICtrlCreateLabel("", 35, 110, 100, 100)
$doit = GUICtrlCreateButton("Read My Mind!", 32, 248, 107, 41, 0)
$newcolors = GUICtrlCreateButton("Refresh Colors", 32, 290, 107, 26, 0)
$Edit1 = GUICtrlCreateEdit("", 8, 0, 513, 81, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetData(-1, StringFormat("MindReader Instructions\r\n\r\n1. Pick a 2 digit number (Such as 47)\r\n\r\n2. Add both of the digits togeather (Example: If you had 47, add 4 + 7 to get 11)\r\n\r\n3. Subtract what you got for adding the digits togeather from your origanal number.\r\n\r\nFocus on the color behind your new number, and click " & Chr(34) & "Read My Mind!" & Chr(34) & ""))
GUISetState(@SW_SHOW)

CreateTables()

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $newcolors
            deletetables()
            CreateTables()
        Case $doit
            ShowIt()
    EndSwitch
WEnd

Func CreateTables()
    b_disable()
    $xpos = 470
    $ypos = 0
    $count = 0
    $slide = 22
    $thecolor = $color[(Random(1, 11, 1))]

    For $i = 0 To 99
        Assign("num_" & $i, GUICtrlCreateLabel($i, $xpos - $slide, Execute("(368) - (" & ($i - $ypos) & " * 17)"), 26, 17, $SS_CENTER), 2)
        If StringInStr(String($i / 9), ".") Then
            GUICtrlSetBkColor(-1, $color[(Random(1, 11, 1))])
        Else
            GUICtrlSetBkColor(-1, $thecolor)
        EndIf
        Sleep($wait)
        $count += 1
        If $count = 16 Then
            $xpos -= 35
            $ypos += 16
            If $i >= 95 Then $ypos -= 12
            $count = 0
        EndIf
    Next
    $Guessme = $thecolor
    GUICtrlSetState($doit, $GUI_ENABLE)
    GUICtrlSetState($newcolors, $GUI_ENABLE)
EndFunc   ;==>CreateTables

Func deletetables()
    b_disable()
    GUICtrlDelete($dispcolor)
    For $i = 0 To 100
        GUICtrlDelete(Eval("num_" & $i))
        Sleep($wait)
    Next
EndFunc   ;==>deletetables

Func ShowIt()
    b_disable()
    deletetables()
    GUICtrlDelete($dispcolor)
    Global $dispcolor = GUICtrlCreateLabel("", 35, 110, 100, 100)

    ;Little bit of show

    For $i = 94 To 114
        GUICtrlSetBkColor(-1, $color[(Random(1, 11, 1))])
        Sleep($i * 2)
    Next
    GUICtrlSetBkColor(-1, $GUI_BKCOLOR_DEFAULT)
    For $i = 0 To 5
        Sleep(100)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_DEFAULT)
        Sleep(100)
        GUICtrlSetBkColor(-1, $Guessme)
    Next
    GUICtrlSetState($newcolors, $GUI_ENABLE)
    GUICtrlSetState($doit, $GUI_DISABLE)
EndFunc   ;==>ShowIt

Func onautoitexit()
    deletetables()
    Exit
EndFunc   ;==>onautoitexit

Func b_disable()
    GUICtrlSetState($doit, $GUI_DISABLE)
    GUICtrlSetState($newcolors, $GUI_DISABLE)
EndFunc   ;==>b_disable