#include <GUIConstants.au3>
; == GUI generated with Koda ==



Global $title = "ReflectIT!"
Global $level = 1
Global $levelTime = 5000
Global $state = 0
Global $time
Global $tent = 0

Dim $lev[21]
$lev[0] = 20;***level number
$lev[1] = 2000
$lev[2] = 1600
$lev[3] = 1200
$lev[4] = 1000
$lev[5] = 800
$lev[6] = 700
$lev[7] = 600
$lev[8] = 500
$lev[9] = 450
$lev[10] = 400
$lev[11] = 380
$lev[12] = 350
$lev[13] = 330
$lev[14] = 310
$lev[15] = 300
$lev[16] = 290
$lev[17] = 280
$lev[18] = 270
$lev[19] = 260
$lev[20] = 250


$Form1 = GUICreate($title, 519, 270, 285, 353)
$level_ = GUICtrlCreateGroup("AGroup1", 16, 72, 137, 89)
$levelTime_ = GUICtrlCreateLabel("5 sec", 72, 120, 30, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$hit = GUICtrlCreateButton("HIT!", 192, 72, 217, 161)
GUICtrlSetState($hit, $GUI_DISABLE)
GUICtrlCreateLabel("Time for pass", 40, 96, 93, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
GUICtrlSetColor(-1, 0x000080)
$start = GUICtrlCreateButton("Start", 32, 176, 105, 33)

$Icon1 = GUICtrlCreateGraphic(280, 16, 32, 32)

GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0x00ee00, 0x00ff00)
GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)

GUICtrlSetData($level_, "Level " & $level)
GUICtrlSetData($levelTime_, Round($lev[$level] / 1000, 2) & " sec")

GUISetState(@SW_SHOW)
$xi = 0
While 1
    $msg = GUIGetMsg()
    $ret = _reflex($state)
    
    If $xi = 1 Then
        $timeDiff = TimerDiff($time)
        MsgBox(0, "", Round($timeDiff / 1000, 2) & " seconds" & @CRLF & $timeDiff)
    EndIf
    
    If $ret = 1 Then
        GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0xee0000, 0xff0000)
        GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)
        GUICtrlSetGraphic($Icon1, $GUI_GR_REFRESH)
    ;$xi=1
    EndIf
    
    
    Select
        Case $msg = $hit
            If $state = 2 Then
                $timeDiff = TimerDiff($time)
            ;MsgBox(0,"",Round($timeDiff / 1000,2) & " seconds" & @CRLF & $timeDiff)
                GUICtrlSetState($hit, $GUI_DISABLE)
                GUICtrlSetState($start, $GUI_ENABLE)
                GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0x00ee00, 0x00ff00)
                GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)
                GUICtrlSetGraphic($Icon1, $GUI_GR_REFRESH)
                $state = 0
                If $timeDiff <= $lev[$level] Then
                    MsgBox(32, $title, "Success!! (" & Round($timeDiff / 1000, 2) & " second/s)" & @CRLF & "Level passed!")
                    _levelUp()
                    GUICtrlSetData($level_, "Level " & $level)
                    GUICtrlSetData($levelTime_, Round($lev[$level] / 1000, 2) & " sec")
                    
                Else
                    MsgBox(16, $title, "Fail (" & Round($timeDiff / 1000, 2) & " second/s)" & @CRLF & "Level fail")
                    $level = 1
                    GUICtrlSetData($level_, "Level " & $level)
                    GUICtrlSetData($levelTime_, Round($lev[$level] / 1000, 2) & " sec")
                EndIf
            Else
                MsgBox(16, $title, "Fail! Wait red icon")
                $state = 0
                $level = 1
                GUICtrlSetState($hit, $GUI_DISABLE)
                GUICtrlSetState($start, $GUI_ENABLE)
                GUICtrlSetData($level_, "Level " & $level)
                GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0x00ee00, 0x00ff00)
                GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)
                GUICtrlSetGraphic($Icon1, $GUI_GR_REFRESH)
            EndIf
        Case $msg = $start
            GUICtrlSetState($start, $GUI_DISABLE)
            GUICtrlSetData($start, "3")
            Sleep(1000)
            GUICtrlSetData($start, "2")
            Sleep(1000)
            GUICtrlSetData($start, "1")
            Sleep(1000)
            GUICtrlSetData($start, "Start")
            GUICtrlSetState($hit, $GUI_ENABLE)
            GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0xeeee00, 0xffff00)
            GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)
            GUICtrlSetGraphic($Icon1, $GUI_GR_REFRESH)
            $state = 1
            $tent = 0
        ;Sleep(1000)
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case Else
        ;;;;;;;
    EndSelect
WEnd
Exit

Func _levelUp()
    
    $level = $level + 1
    $levelTime = $lev[$level]
    
    If $level > $lev[0] Then
        MsgBox(0, $title, "Congratulation! Your reflex is optimal!")
        $level = 1
        $levelTime = $lev[$level]
    EndIf
    
EndFunc  ;==>_levelUp


Func _reflex($s)
    If $s = 1 Then
        $rand = Random(1, 1000+ ($level * 200), 1)
        
    ;MsgBox(0,"",$rand)
        If $rand = 1 Or $tent >= ($level * 500) Then
        ;Return 1
            $state = 2
            $time = TimerInit()
            Return 1
        Else
            $tent = $tent + 1
        ;ToolTip($tent)
            Return 0
        EndIf
    EndIf
EndFunc  ;==>_reflex