;===============================================================================
;
; Function Name:    _LimitTimeGui ([title], [caption], [white squares], [blue squares])
; Description:      Displays a GUI For easily controlling access
; Parameter(s):     $title   - Title For GUI (Default: Limit Time GUI)
;                   $caption - Text to display at top of GUI
;                   $white   - Text to display as key For white squares (Default: Accessable)
;                   $blue    - Text to display as key For blue squares (Default: Inaccessable)
; Requirement(s):   GUIConstants.au3
; Return Value(s):  On Success - Returns 2-dimensional array [day(1-7)][hour(1-24)] (no [0]'s in array)
;                   On Failure - Exit sets 0 and @error = 1
; Author(s):        Dale Edwards (A.K.A. Gmail)
; Special thanks to:Valuater
;
;==============================================================================
Func _limittimegui($title = "Limit Time GUI", $caption = "", $white = "Accessable", $blue = "Inaccessable")
    Local $return[8][25], $Graphic[169], $GRead[169], $count
    
    $gui = GUICreate("" & $title & "", 476, 262, 193, 115, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
    GUICtrlCreateLabel("Hours", 70, 37, 391, 20, $SS_CENTER)
    GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
    
    Local $top = 66
    Local $left[25] = [25, 74, 90, 106, 122, 138, 154, 170, 186, 202, 218, 234, 250, 267, 283, 299, 315, 331, 347, 363, 379, 395, 411, 427, 443]
    For $i = 1 To 7
        $top += 17
        For $x = 1 To 24
            $count += 1
            $Graphic[$count] = GUICtrlCreateGraphic($left[$x], $top, 17, 17)
            GUICtrlSetBkColor(-1, 0xFFFFFF)
            $GRead[$count] = 0
        Next
    Next
    
    GUICtrlSetBkColor(-1, 0xFFFFFF)
    GUICtrlCreateLabel("0", 69, 64, 10, 17)
    GUICtrlCreateLabel("2", 103, 64, 10, 17)
    GUICtrlCreateLabel("4", 134, 64, 10, 17)
    GUICtrlCreateLabel("6", 166, 64, 10, 17)
    GUICtrlCreateLabel("8", 197, 64, 10, 17)
    GUICtrlCreateLabel("10", 226, 64, 16, 17)
    GUICtrlCreateLabel("12", 259, 64, 16, 17)
    GUICtrlCreateLabel("14", 292, 64, 16, 17)
    GUICtrlCreateLabel("16", 323, 64, 16, 17)
    GUICtrlCreateLabel("18", 355, 64, 16, 17)
    GUICtrlCreateLabel("20", 387, 64, 16, 17)
    GUICtrlCreateLabel("22", 419, 64, 16, 17)
    GUICtrlCreateLabel("24", 451, 64, 16, 17)
    $mon = GUICtrlCreateButton("Monday", 11, 83, 61, 17)
    $tue = GUICtrlCreateButton("Tuesday", 11, 100, 61, 17)
    $wed = GUICtrlCreateButton("Wednesday", 11, 117, 61, 17)
    $thu = GUICtrlCreateButton("Thursday", 11, 134, 61, 17)
    $fri = GUICtrlCreateButton("Friday", 11, 151, 61, 17)
    $sat = GUICtrlCreateButton("Saturday", 11, 168, 61, 17)
    $sun = GUICtrlCreateButton("Sunday", 11, 185, 61, 17)
    $label = GUICtrlCreateLabel("" & $caption & "", 7, 8, 459, 17)
    $select = GUICtrlCreateButton("&Select All", 5, 224, 75, 25, 0)
    $deselect = GUICtrlCreateButton("&Deselect All", 85, 224, 75, 25, 0)
    GUICtrlCreateGraphic(175, 210, 16, 17)
    GUICtrlSetBkColor(-1, 0xFFFFFF)
    GUICtrlCreateLabel($white, 195, 212)
    GUICtrlCreateGraphic(175, 230, 16, 17)
    GUICtrlSetBkColor(-1, 0x1111ff)
    GUICtrlCreateLabel($blue, 195, 232)
    $ok = GUICtrlCreateButton("&OK", 392, 224, 75, 25, 0)
    GUISetState(@SW_SHOW)
    
    While 1
        $nMsg = GUIGetMsg()
        For $x = 1 To 168
            If $nMsg = $Graphic[$x] Then
                If $GRead[$x] = 0 Then
                    GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                    $GRead[$x] = 1
                Else
                    GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                    $GRead[$x] = 0
                EndIf
            EndIf
        Next
        Switch $nMsg
            Case $GUI_EVENT_CLOSE
                GUIDelete($gui)
                SetError(1)
                Return 0
                ExitLoop
                
            Case $deselect
                For $x = 1 To 168
                    GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                    $GRead[$x] = 0
                Next
                
            Case $select
                For $x = 1 To 168
                    GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                    $GRead[$x] = 1
                Next
                
            Case $mon
                For $x = 1 To 24
                    If $GRead[$x] = 0 Then
                        GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                        $GRead[$x] = 1
                    Else
                        GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                        $GRead[$x] = 0
                    EndIf
                Next
                
            Case $tue
                For $x = 25 To 48
                    If $GRead[$x] = 0 Then
                        GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                        $GRead[$x] = 1
                    Else
                        GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                        $GRead[$x] = 0
                    EndIf
                Next
                
            Case $wed
                For $x = 49 To 72
                    If $GRead[$x] = 0 Then
                        GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                        $GRead[$x] = 1
                    Else
                        GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                        $GRead[$x] = 0
                    EndIf
                Next
                
            Case $thu
                For $x = 73 To 96
                    If $GRead[$x] = 0 Then
                        GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                        $GRead[$x] = 1
                    Else
                        GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                        $GRead[$x] = 0
                    EndIf
                Next
                
            Case $fri
                For $x = 97 To 120
                    If $GRead[$x] = 0 Then
                        GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                        $GRead[$x] = 1
                    Else
                        GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                        $GRead[$x] = 0
                    EndIf
                Next
                
            Case $sat
                For $x = 121 To 144
                    If $GRead[$x] = 0 Then
                        GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                        $GRead[$x] = 1
                    Else
                        GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                        $GRead[$x] = 0
                    EndIf
                Next
                
            Case $sun
                For $x = 145 To 168
                    If $GRead[$x] = 0 Then
                        GUICtrlSetBkColor($Graphic[$x], 0x1111ff)
                        $GRead[$x] = 1
                    Else
                        GUICtrlSetBkColor($Graphic[$x], 0xffffff)
                        $GRead[$x] = 0
                    EndIf
                Next
                
            Case $ok
                $count = 0
                For $i = 1 To 7
                    For $x = 1 To 24
                        $count += 1
                        If $GRead[$count] = 1 Then
                            $return[$i][$x] = 1
                        Else
                            $return[$i][$x] = 0
                        EndIf
                    Next
                Next
                
                Return $return
        EndSwitch
    WEnd
EndFunc   ;==>_limittimegui