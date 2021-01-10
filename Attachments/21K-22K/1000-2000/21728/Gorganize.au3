; Gorganize.au3 - By _Kurt
#include-once
#include <GUIConstants.au3>

Global $current = 0
Global $controls[30][5]
Global $count = 0

Func Gorganize()
    Local Const $WS_POPUP = 0x80000000
    Local Const $WS_BORDER = 0x00800000
    Local Const $WS_EX_TOOLWINDOW  = 0x00000080
    Local Const $WS_POPUPWINDOW = 0x80880000
    Local $tmp, $x, $y, $oldx, $oldy, $msg, $hover, $pos, $hwnd, $pos1
    Local $script, $handle, $toolbar, $scaleX, $scaleY, $scaleNum
    Local $DRAG = True, $SCALE = False
    $hwnd = WinGetHandle("[ACTIVE]")
    $pos = WinGetPos($hwnd)
    $toolbar = GUICreate("", 145, 190, $pos[0]+$pos[2]+3, $pos[1], $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW, $hwnd)
    $Dragging = GUICtrlCreateCheckbox("Enable Dragging", 8, 72, 129, 25)
    GUICtrlSetState(-1,$GUI_CHECKED)
    $MovingCtrl = GUICtrlCreateCheckbox("Enable Scale", 8, 96, 129, 25)
    GUICtrlCreateLabel("Control Coordinates:", 8, 8, 99, 17)
    $zX = GUICtrlCreateLabel("X:   ---", 32, 24, 80, 17)
    $zY = GUICtrlCreateLabel("Y:   ---", 32, 40, 80, 17)
    $Output = GUICtrlCreateButton("Output Code ..", 8, 136, 129, 17, 0)
    $Exit = GUICtrlCreateButton("Exit", 8, 160, 129, 17, 0)
    GUISetState()
    WinSetOnTop($toolbar,"",1)
    WinActivate($hwnd)
    HotKeySet("{ESC}","done")
    While 1
        $pos1 = WinGetPos($hwnd)
		If $pos1[0]+$pos1[2] <> $pos[0]+$pos[2] Or $pos1[1] <> $pos[1] Then WinMove($toolbar, "", $pos1[0]+$pos1[2]+3, $pos1[1])
        $msg = GUIGetMsg()
        Select
            Case $msg = $GUI_EVENT_CLOSE Or $msg = $Exit
                done()
                WinActivate($hwnd)
            Case $msg = $Output
                WinActivate($hwnd)
                $script = StringSplit(FileRead(@ScriptFullPath),@CRLF,1)
                FileCopy(@ScriptFullPath, @ScriptDir & "\BackUps\BackUp.au3", 8)
                $handle = FileOpen(@ScriptFullPath,0)
                FileWrite(@ScriptDir & "\Gorganize.log.txt", @HOUR&":"&@MIN&" - Gorganized File: " & @ScriptFullPath)
                For $i = 0 To $count-1
                    For $x = 1 To UBound($script)-1
                        $tmp = $script[$x]
                        $script[$x] = StringStripWS($script[$x],8)
                        If StringInStr($script[$x], "GUICtrlCreate") AND StringLeft($script[$x],1) <> ";" AND _
                            StringInStr($script[$x], $controls[$i][1] & "," & $controls[$i][2]) Then
                            FileWrite(@ScriptDir & "\Gorganize.log.txt",@CRLF & @CRLF & "______" & @CRLF & "Ctrl_ID: " & $controls[$i][0] & " | " & "Old_X_Pos:" & $controls[$i][1] & " | " & "Old_Y_Pos:" & $controls[$i][2] & " | " & "New_X_Pos:" & $controls[$i][3] & " | " & "New_Y_Pos:" & $controls[$i][4])
                            $script[$x] = StringReplace($script[$x], $controls[$i][1] & "," & $controls[$i][2], $controls[$i][3] & "," & $controls[$i][4])
                        Else
                            $script[$x] = $tmp
                        EndIf
                    Next
                Next
                FileClose($handle)
                $handle = FileOpen(@ScriptFullPath,2)
                For $i = 1 To UBound($script)-1
                    FileWrite($handle,$script[$i] & @CRLF)
                Next
                FileClose($handle)
                MsgBox(0,"","Updated: " & @ScriptFullPath & "." & @CRLF & @CRLF & "Backup was copied to: " & @ScriptDir & "\BackUps\BackUp.au3")
            Case $msg = $Dragging
                If GUICtrlRead($Dragging) = $GUI_CHECKED Then
                    $DRAG = True
                Else
                    $DRAG = False
                EndIf
                WinActivate($hwnd)
            Case $msg = $MovingCtrl
                If GUICtrlRead($MovingCtrl) = $GUI_CHECKED Then
                    $scaleNum = InputBox("","Please enter a number for the GUI scale (Default: 10x10 scale)","10")
                    If Number($scaleNum) Then
                        $SCALE = True
                    Else
                        MsgBox(0,"","Invalid Number")
                    EndIf
                Else
                    $SCALE = False
                EndIf
                WinActivate($hwnd)
            EndSelect
            If Not WinActive($hwnd) AND Not WinActive($toolbar) Then
                GUISetState(@SW_HIDE,$toolbar)
                While NOT WinActive($hwnd)
                    Sleep(50)
                WEnd
                GUISetState(@SW_SHOW,$toolbar)
                WinActivate($hwnd)
            EndIf
        $hover = GUIGetCursorInfo($hwnd)
        If IsArray($hover) Then
            If $hover[4] <> 0 AND $DRAG = True Then
                If $hover[4] <> $current Then
                    If UnknownCTRL($hover[4]) Then
                        $controls[$count][0] = $hover[4]
                        $tmp = ControlGetPos($hwnd, "", $hover[4])
                        $controls[$count][1] = $tmp[0] ;x
                        $controls[$count][2] = $tmp[1] ;y
                        $controls[$count][3] = $tmp[0] ;x
                        $controls[$count][4] = $tmp[1] ;y
                        $count += 1
                    EndIf
                    If $current <> -1 Then GUICtrlSetState($current,$GUI_ENABLE)
                    $current = $hover[4]
                    GUICtrlSetState($current,$GUI_DISABLE)
                EndIf
                If $hover[2] = 1 Then
                    $tmp = ControlGetPos($hwnd, "", $current)
                    $oldx = $hover[0]
                    $oldy = $hover[1]
                    GUISetCursor(9,1,$hwnd)
                    $mp = MouseGetPos()
                    $cp = ControlGetPos($hwnd, "", $current)
                    $max = WinGetClientSize($hwnd)
                    While $hover[2] = 1
                        $hover = GUIGetCursorInfo($hwnd)
                        If $hover[0] <> $x Or $hover[1] <> $y Then
                            $x = $hover[0]
                            $y = $hover[1]
                            If $SCALE = True Then
                                $scaleX = $tmp[0]-($oldx-$x)
                                $scaleY = $tmp[1]-($oldy-$y)
                                If $scaleX/$scaleNum-Round($scaleX/$scaleNum) > 0 Then
                                    While IsFloat($scaleX/$scaleNum)
                                        $scaleX = Round($scaleX)-1
                                    WEnd
                                Else
                                    While IsFloat($scaleX/$scaleNum)
                                        $scaleX = Round($scaleX)+1
                                    WEnd
                                EndIf
                                If $scaleY/$scaleNum-Round($scaleY/$scaleNum) > 0 Then
                                    While IsFloat($scaleY/$scaleNum)
                                        $scaleY = Round($scaleY)-1
                                    WEnd
                                Else
                                    While IsFloat($scaleY/$scaleNum)
                                        $scaleY = Round($scaleY)+1
                                    WEnd
                                EndIf
                                GUICtrlSetPos($current, $scaleX, $scaleY)
                                GUICtrlSetData($zX,"X:   " & $scaleX)
                                GUICtrlSetData($zY,"Y:   " & $scaleY)
                            Else
                                GUICtrlSetPos($current, $tmp[0]-($oldx-$x), $tmp[1]-($oldy-$y))
                                GUICtrlSetData($zX,"X:   " & $tmp[0]-($oldx-$x))
                                GUICtrlSetData($zY,"Y:   " & $tmp[1]-($oldy-$y))
                                
                                $nm = MouseGetPos()
                                $x = $cp[0] - $mp[0] + $nm[0]
                                $y = $cp[1] - $mp[1] + $nm[1]
                                Select
                                    Case $y < 0
                                        $y = 0
                                    Case $y > $max[1]-$cp[3]
                                        $y = $max[1]-$cp[3]
                                EndSelect
                                Select
                                    Case $x < 0
                                        $x = 0
                                    Case $x > $max[0]-$cp[2]
                                        $x = $max[0]-$cp[2]
                                EndSelect
                                ControlMove($hwnd, "", $current, $x,$y)
                                Sleep(50)
                                
                            EndIf
                        EndIf
                    WEnd
                    GUISetCursor(2,1,$hwnd)
                    $controls[Find($current)][3] = $tmp[0]-($oldx-$x)
                    $controls[Find($current)][4] = $tmp[1]-($oldy-$y)
                EndIf
            Else
                If $current <> -1 Then GUICtrlSetState($current, $GUI_ENABLE)
                $current = -1
            EndIf
        EndIf
    WEnd
EndFunc

Func Find($ctrl)
    For $i = 0 To $count-1
        If $controls[$i][0] = $ctrl Then Return $i
    Next
EndFunc

Func UnknownCTRL($ctrl)
    For $i = 0 To $count
        If $controls[$i][0] = $ctrl Then Return False
    Next
    Return True
EndFunc

Func done()
    If MsgBox(4,"","Are you sure you are done organizing your GUI?") = 6 Then Exit
EndFunc