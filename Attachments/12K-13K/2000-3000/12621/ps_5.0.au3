#include <GUIConstants.au3>
#include <Math.au3>
#include <GUIConstants.au3>

Opt("CaretCoordMode", 0)
Opt("MustDeclareVars", 0) 

DirCreate ( "C:\PS" )
FileInstall("C:\Documents and Settings\HP_Administrator\Desktop\PS Beta\dot.bmp","C:\PS\dot.bmp",1)
FileInstall("C:\Documents and Settings\HP_Administrator\Desktop\PS Beta\field1.bmp","C:\PS\field1.bmp",1)


;<===Variables===>
$gui = GUICreate("test")
$first0 = ""
$first1 = ""
$x22 = ""
$y22 = ""
$x11 = ""
$y11 = ""
$x22_a1 = ""
$y22_a1 = ""
$x11_a1 = ""
$y11_a1 = ""
$x22_a2 = ""
$y22_a2 = ""
$x11_a2 = ""
$y11_a2 = ""
$x22_o1 = ""
$y22_o1 = ""
$x11_o1 = ""
$y11_o1 = ""
$x22_o2 = ""
$y22_o2 = ""
$x11_o2 = ""
$y11_o2 = ""
$x22_o3 = ""
$y22_o3 = ""
$x11_o3 = ""
$y11_o3 = ""
$team = ""
$maxControls = 50000
Global $controlIDs[$maxControls]
Global $nextControl = 0
$b_1 = ""
$control = 4160 ;<=========== ###Control###
$count_us = 0
$count_a1 = 0
$count_a2 = 0
$count_o1 = 0
$count_o2 = 0
$count_o3 = 0
$text = ""
$x_old = ""
$y_old = ""
$x_location = "0"
$y_location = "0"
$Gear_x = 750
$Gear_y = 15
$gear = "Mid"
$Start_x = 890
$Start_y = 15
$blue = 4123
$red = 4126
$auto = 0
$check_x = 740
$check_y = 640
$angle_x = 750
$angle_y = 305
$delay_x = 750
$delay_y = 415
$make_x = 750
$make_y = 240
$code = "int waypoints[0][4]=" & @CRLF & "{/*	x	y	g	p        */"
$current = $control + 1
$current1 = ""
$line = ""
$output = ""
$head = "int waypoints[0][4]=" & @CRLF & "{/*	x	y	g	p         */"
$num = 0
$num1 = 10000
Dim $x_move1[$Num1]
Dim $y_move1[$Num1]
Dim $gear_num1[$Num1]
$mode = 0
$x_move2 = ""
$y_move2 = ""
$x_coord = ""
$y_coord = ""
$no = 0
$p = 0
$num2 = 10000
$accel1 = 0
$brakes1 = 0
$oldvalue = 0
$delay = 0

;<===GUI===>
GUICreate("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †",1024,768,0,0)
$reset = GUICtrlCreateButton("Reset",50,20,50,30)
$save = GUICtrlCreateButton("Save",250,20,50,30)
$exit = GUICtrlCreateButton("Exit",450,20,50,30)
;$input = GUICtrlCreateInput($text,100,450,0,0,"0x00201004") ;<==== Other box
GUICtrlCreateGroup("Coordinants",$make_x,$make_y,240,50)
GUICtrlCreateLabel("X:",$make_x + 10,$make_y + 20,10,20)
$x_pos = GUICtrlCreateInput($x_location,$make_x + 30,$make_y + 20,30,20)
GUICtrlCreateLabel("Y:",$make_x + 80,$make_y + 20,10,20)
$y_pos = GUICtrlCreateInput($y_location,$make_x + 100,$make_y + 20,30,20)
$point = GUICtrlCreateButton("Make Point",$make_x + 150,$make_y + 15,70,30)
GUICtrlCreateGroup("Line",$Gear_x,$Gear_y,115,210)
$high = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 20,20,20)
$mid = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 43,20,20)
$low = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 66,20,20)
$team1 = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 89,20,20)
$team2 = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 112,20,20)
$opp1 = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 135,20,20)
$opp2 = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 158,20,20)
$opp3 = GUICtrlCreateRadio("",$Gear_x + 20,$Gear_y + 182,20,20)
$high_label = GUICtrlCreateLabel("High",$Gear_x + 40,$Gear_y + 20,60,20)
$mid_label = GUICtrlCreateLabel("Mid",$Gear_x + 40,$Gear_y + 43,60,20)
$low_label = GUICtrlCreateLabel("Low",$Gear_x + 40,$Gear_y + 66,60,20)
$team1_label = GUICtrlCreateLabel("Ally 1",$Gear_x + 40,$Gear_y + 89,60,20)
$team2_label = GUICtrlCreateLabel("Ally 2",$Gear_x + 40,$Gear_y + 112,60,20)
$opp1_label = GUICtrlCreateLabel("Opponent 1",$Gear_x + 40,$Gear_y + 135,80,20)
$opp2_label = GUICtrlCreateLabel("Opponent 2",$Gear_x + 40,$Gear_y + 158,80,20)
$opp3_label = GUICtrlCreateLabel("Opponent 3",$Gear_x + 40,$Gear_y + 182,80,20)
GUICtrlSetState($mid, $GUI_CHECKED)
GUICtrlSetColor($high_label,0x00ff00)
GUICtrlSetColor($mid_label,0xffff00)
GUICtrlSetColor($low_label,0xff0000)
GUICtrlSetColor($team1_label,0x800080)
GUICtrlSetColor($team2_label,0xFF00FF)
GUICtrlSetColor($opp1_label,0x00FFFF)
GUICtrlSetColor($opp2_label,0x0080FF)
GUICtrlSetColor($opp3_label,0x0000A2)
GUICtrlCreateGroup("Starting Position",$Start_x,$Start_y,100,210)
$b_1 = GUICtrlCreateRadio("",$Start_x + 20,$Start_y + 20,20,20)
$b_2 = GUICtrlCreateRadio("",$Start_x + 20,$Start_y + 45,20,20)
$b_3 = GUICtrlCreateRadio("",$Start_x + 20,$Start_y + 70,20,20)
$r_1 = GUICtrlCreateRadio("",$Start_x + 20,$Start_y + 95,20,20)
$r_2 = GUICtrlCreateRadio("",$Start_x + 20,$Start_y + 120,20,20)
$r_3 = GUICtrlCreateRadio("",$Start_x + 20,$Start_y + 145,20,20)
$blue1 = GUICtrlCreateLabel("Blue 1",$Start_x + 40,$Start_y + 21,50,20)
$blue2 = GUICtrlCreateLabel("Blue 2",$Start_x + 40,$Start_y + 46,50,20)
$blue3 = GUICtrlCreateLabel("Blue 3",$Start_x + 40,$Start_y + 71,50,20)
$red1 = GUICtrlCreateLabel("Red 1",$Start_x + 40,$Start_y + 96,50,20)
$red2 = GUICtrlCreateLabel("Red 2",$Start_x + 40,$Start_y + 121,50,20)
$red3 = GUICtrlCreateLabel("Red 3",$Start_x + 40,$Start_y + 146,50,20)
$set = GUICtrlCreateButton("Set",$Start_x + 20,$start_y + 170,60,30)
GUICtrlSetColor($blue1,0x0000ff)
GUICtrlSetColor($blue2,0x0000ff)
GUICtrlSetColor($blue3,0x0000ff)
GUICtrlSetColor($red1,0xff0000)
GUICtrlSetColor($red2,0xff0000)
GUICtrlSetColor($red3,0xff0000)
GUICtrlCreateGroup("Delay",$delay_x,$delay_y,240,50)
GUICtrlCreateLabel("Delay (ms):",$delay_x + 15,$delay_y + 20,60,20)
$Delay_input = GUICtrlCreateInput("",$delay_x + 72,$delay_y + 20,50,20)
$set_delay = GUICtrlCreateButton("Set Delay",$delay_x + 140,$delay_y + 15,80,30)
GUICtrlCreateGroup("Options",$check_x,$check_y,250,110)
$accel = GUICtrlCreateCheckbox("Accelerate",$check_x + 30,$check_y + 20,80,20)
GUICtrlCreateCheckbox("Decelerate",$check_x + 150,$check_y + 20,80,20)
$brakes = GUICtrlCreateCheckbox("Brakes",$check_x + 30,$check_y + 40,80,20)
GUICtrlCreateCheckbox("Camera",$check_x + 150,$check_y + 40,80,20)
GUICtrlCreateCheckbox("End Point",$check_x + 30,$check_y + 60,80,20)
$05 = GUICtrlCreateCheckbox("Half Sec Stop",$check_x + 150,$check_y + 60,80,20)
$10 = GUICtrlCreateCheckbox("1 Sec Stop",$check_x + 30,$check_y + 80,80,20)
$15 = GUICtrlCreateCheckbox("1.5 Sec Stop",$check_x + 150,$check_y + 80,80,20)
$undo = GUICtrlCreateButton("Undo",650,20,50,30)
$code = GUICtrlCreateInput($code,50,400,650,350,"0x00301004") ;<==== Code Box
GUICtrlCreateGroup("End Angle",$angle_x,$angle_y,240,95)
$slider_label = GUICtrlCreateLabel("0 Degrees",$angle_x + 45,$angle_y + 30,150,20,$SS_CENTER )
$slider = GUICtrlCreateSlider($angle_x + 45,$angle_y + 55,150,30);                       <==== Slider
;$graphic = GUICtrlCreateGraphic(0,0,705,410)
$field = GUICtrlCreatePic("C:\PS\field1.bmp",50,70,648,315)
GUICtrlSetState(-1, $GUI_DISABLE)
;GuiCtrlSetState($field,$GUI_DISABLE)
;$graphic = GUICtrlCreateGraphic(50,70,648,315)
;$field = GUICtrlCreateGraphic(50,70,648,315)
;GUICtrlSetGraphic($field,"C:\PS\field1.bmp")
$graphic = GUICtrlCreateGraphic(0,0,705,410)




GUISetState()



$win = WinGetPos("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †","")
$size1 = WinGetClientSize("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †")
$offset_x = $win[2] - $size1[0] - 3
$offset_y = $win[3] - $size1[1] - 3



;<===Check GUI===>
While 1
    $dll = DllOpen("user32.dll")
        If _IsPressed("01", $dll) Then everything()
    DllClose($dll)
    Sleep(5)
    $msg = GUIGetMsg()
    If $msg = $reset Then reset()
    If $msg = $save then save()
    If $msg = $exit then exit1()
    If $msg = $undo Then MsgBox(0,"Fix this...","Kyler will fix the EVIL undo button... eventually... if he feels like it... which will be well... never.");undo()
    If $msg = $GUI_EVENT_CLOSE Then exit1()
    If $msg = $point Then point()
    If $msg = $high Then $gear = "High"
    If $msg = $mid Then $gear = "Mid"
    If $msg = $low Then $gear = "Low"
    If $msg = $team1 Then $gear = 1
    If $msg = $team2 Then $gear = 2
    If $msg = $opp1 Then $gear = 3
    If $msg = $opp2 Then $gear = 4
    If $msg = $opp3 Then $gear = 5
    If $msg = $set Then start()
    If $msg = $b_1 Then $auto = 1
    If $msg = $b_2 Then $auto = 2
    If $msg = $b_3 Then $auto = 3
    If $msg = $r_1 Then $auto = 4
    If $msg = $r_2 Then $auto = 5
    If $msg = $r_3 Then $auto = 6
    If $msg = $05 Then $p = 5
    If $msg = $10 Then $p = 10
    If $msg = $15 Then $p = 15
    If $msg = $accel Then 
        $accel1 = 1
    ;Else
    ;    $accel1 = 0
    EndIf
    If $msg = $brakes Then 
        $brakes1 = 1
    ;Else
    ;    $brakes1 = 0
    EndIf
    If $msg = $set_delay Then
        $delay = GUICtrlRead($delay_input)
    EndIf
    GetPos()
    
    If $oldvalue <> GUICtrlRead($slider) Then
        $oldvalue = GUICtrlRead($slider)
        GUICtrlSetData($slider_label,$oldvalue * 3.6 & " degrees.",0)
         $ahead = "int gui_variables[4]=" & @CRLF & "{//        #    end_angle  accel  brake" & @CRLF & "{    " & $num & ",        " & $oldvalue * 3.6 & ",        " & $accel1 & ",        " & $brakes1 & "}" & @CRLF & "};" & @CRLF & @CRLF
    If $no = 0 Then $head = "int waypoints[" & $num + 1 & "][4]=" & @CRLF & "{/*	x	y	g	p        */"
    If $no = 0 Then $output = $output
    $output1 = $ahead & @CRLF & $head &  $output & @CRLF & "};"
    GUICtrlSetData($code,$output1)
    EndIf
WEnd


;<===Functions===>
Func undo()
    $delete = 1
    Do
        GUICtrlDelete($delete + $current1 - $line)
        $delete = $delete + 1
    Until $delete = $line + 5
EndFunc


Func start()
    $win = WinGetPos("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †","")
    If $auto = 1 Then ;<=== Blue 1
        everything_auto($offset_x + $win[0] + 50 + 264,$offset_y + $win[1] + 70 + 30)
        If $gear = "low" Then $team = "blue"
        If $gear = "mid" Then $team = "blue"
        If $gear = "high" Then $team = "blue"
    EndIf
    If $auto = 2 Then ;<=== Blue 2
        everything_auto($offset_x + $win[0] + 50 + 324,$offset_y + $win[1] + 70 + 30)
        If $gear = "low" Then $team = "blue"
        If $gear = "mid" Then $team = "blue"
        If $gear = "high" Then $team = "blue"
    EndIf
    If $auto = 3 Then ;<=== Blue 3
        everything_auto($offset_x + $win[0] + 50 + 384,$offset_y + $win[1] + 70 + 30)
        If $gear = "low" Then $team = "blue"
        If $gear = "mid" Then $team = "blue"
        If $gear = "high" Then $team = "blue"
    EndIf
    If $auto = 6 Then ;<=== Red 3
        everything_auto($offset_x + $win[0] + 50 + 264,$offset_y + $win[1] + 70 + 285)
        If $gear = "low" Then $team = "red"
        If $gear = "mid" Then $team = "red"
        If $gear = "high" Then $team = "red"
    EndIf
    If $auto = 5 Then ;<=== Red 2
        everything_auto($offset_x + $win[0] + 50 + 324,$offset_y + $win[1] + 70 + 285)
        If $gear = "low" Then $team = "red"
        If $gear = "mid" Then $team = "red"
        If $gear = "high" Then $team = "red"
    EndIf
    If $auto = 4 Then ;<=== Red 1
        everything_auto($offset_x + $win[0] + 50 + 384,$offset_y + $win[1] + 70 + 285)
        If $gear = "low" Then $team = "red"
        If $gear = "mid" Then $team = "red"
        If $gear = "high" Then $team = "red"
    EndIf
EndFunc

Func GetPos()
    $a = GUIGetCursorInfo()
    If $a[4] > $control - 1 And WinActive("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †") Then
        If $mode = 0 Then
            $x_coord = $a[0] -50
            $y_coord = $a[1] - 70
        ElseIf $mode = 1 Then 
            $x_coord = $a[1] -70
            $y_coord = $a[0] - 50
        ElseIf $mode = 2 Then
            $x_coord = Abs($a[1] - 315 - 70)
            $y_coord = Abs($a[0] - 648 - 50)
        EndIf
        GUIctrlSetData($x_pos,$x_coord) 
        GUIctrlSetData($y_pos,$y_coord)
    EndIf
EndFunc

Func point()
    BlockInput(1)
    $win = WinGetPos("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †","")
    $window=GUIGetCursorInfo()
    HotKeySet( "z", "everything")
    $x1 = GUICtrlRead($x_pos)
    $y1 = GUICtrlRead($y_pos)
    $pos = MouseGetPos()
    If $mode = 0 Then
        $x2 =  $x1 + 50 + $offset_x + $win[0]
        $y2 = $y1 + 70 + $offset_y + $win[1]
    EndIf
    If $mode = 1 Then
        $x2 = $y1 + 50 + $offset_x + $win[1]
        $y2 = $x1 + 70 + $offset_y + $win[0]
    EndIf
    If $mode = 2 Then
        $x2 = Abs($y1 - 315) + 70 + $offset_y + $win[1]
        $y2 = Abs($x1 - 648) + 50 + $offset_x + $win[0]
    EndIf
    MouseMove($x2,$y2,0)
    Send("z")
    MouseMove($pos[0],$pos[1],0)
    HotKeySet( "z")
    BlockInput(0)
EndFunc


    
Func everything()
    $current = $current + 1
    $current1 = $current
    sleep(50)
    $window=GUIGetCursorInfo()
    If $window[4] > $control - 1 And WinActive("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †") Then
        waypoint()
        linedraw()
        code()
        unpause()
        sleep(100)
    EndIf
EndFunc

Func everything_auto($x_auto,$y_auto)
    $current = $current + 1
    $current1 = $current
    waypoint($x_auto,$y_auto)
    linedraw($x_auto,$y_auto)
    code()
    unpause()
    sleep(100)
EndFunc

Func unpause()
    GUICtrlSetState($05, $GUI_UNCHECKED)
    GUICtrlSetState($10, $GUI_UNCHECKED)
    GUICtrlSetState($15, $GUI_UNCHECKED)
    $p = 0
EndFunc
    
Func reset()
    unpause()
    $auto = 0
    $delete = 1
    $mode = 0
    Do
        GUICtrlDelete($delete + $control)
        $delete = $delete + 1
    Until $delete = 5000
    $count = 0
    $text = ""
    GUICtrlSetData(4105,$text)
    GUICtrlSetState($b_1, $GUI_UNCHECKED)
    GUICtrlSetState($b_2, $GUI_UNCHECKED)
    GUICtrlSetState($b_3, $GUI_UNCHECKED)
    GUICtrlSetState($r_1, $GUI_UNCHECKED)
    GUICtrlSetState($r_2, $GUI_UNCHECKED)
    GUICtrlSetState($r_3, $GUI_UNCHECKED)
    $num = 0
    $head = "int waypoints[" & $num  & "][4]=" & @CRLF & "{/*	x	y	g	p        */"
    $output = "" 
    $output1 = $head &  $output & @CRLF & "};"
    GUICtrlSetData($code,$output1)
EndFunc

Func save()
    ClipPut($text)
EndFunc

Func exit1()
    Exit
EndFunc

Func linedraw($x_draw = "",$y_draw = "")
    $win = WinGetPos("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †")
    If $gear = 1 Then
        If $count_a1 = 0 Then 
            $first = MouseGetPos()
            If $x_draw = "" Then
                $x11_a1 = $first[0]  - $offset_x - $win[0]
                $y11_a1 = $first[1]  - $offset_y - $win[1]
            Else
                $x11_a1 = $x_draw  - $offset_x - $win[0]
                $y11_a1 = $y_draw  - $offset_y - $win[1]
            EndIf
        EndIf
        If $count_a1 = 1 Then 
            $second = MouseGetPos()
            If $x_draw = "" Then
                $x22_a1 = $second[0]  - $offset_x - $win[0]
                $y22_a1 = $second[1] - $offset_y - $win[1]
            Else
                $x22_a1 = $x_draw - $offset_x - $win[0]
                $y22_a1 = $y_draw - $offset_y - $win[1]
            EndIf
            line($x11_a1,$y11_a1,$x22_a1,$y22_a1)
            $x11_a1 = $x22_a1
            $y11_a1 = $y22_a1
        EndIf
        If $count_a1 = 2 Then 
            $second = MouseGetPos()
            $x11_a1 = $x22_a1
            $y11_a1 = $y22_a1
            If $x_draw = "" Then
                $x22_a1 = $second[0]  - $offset_x - $win[0]
                $y22_a1 = $second[1] - $offset_y - $win[1]
            Else
                $x22_a1 = $x_draw - $offset_x - $win[0]
                $y22_a1 = $y_draw - $offset_y - $win[1]
            EndIf
            $count_a1 = 1
            line($x11_a1,$y11_a1,$x22_a1,$y22_a1)
        EndIf
        $count_a1 = $count_a1 + 1
    ElseIf $gear = 2 Then
        If $count_a2 = 0 Then 
            $first = MouseGetPos()
            If $x_draw = "" Then
                $x11_a2 = $first[0]  - $offset_x - $win[0]
                $y11_a2 = $first[1]  - $offset_y - $win[1]
            Else
                $x11_a2 = $x_draw  - $offset_x - $win[0]
                $y11_a2 = $y_draw  - $offset_y - $win[1]
            EndIf
        EndIf
        If $count_a2 = 1 Then 
            $second = MouseGetPos()
            If $x_draw = "" Then
                $x22_a2 = $second[0]  - $offset_x - $win[0]
                $y22_a2 = $second[1] - $offset_y - $win[1]
             Else
                $x22_a2 = $x_draw - $offset_x - $win[0]
                $y22_a2 = $y_draw - $offset_y - $win[1]
            EndIf
            line($x11_a2,$y11_a2,$x22_a2,$y22_a2)
            $x11_a2 = $x22_a2
            $y11_a2 = $y22_a2
        EndIf
        If $count_a2 = 2 Then 
            $second = MouseGetPos()
            $x11_a2 = $x22_a2
            $y11_a2 = $y22_a2
            If $x_draw = "" Then
                $x22_a2 = $second[0]  - $offset_x - $win[0]
                $y22_a2 = $second[1] - $offset_y - $win[1]
            Else
                $x22_a2 = $x_draw - $offset_x - $win[0]
                $y22_a2 = $y_draw - $offset_y - $win[1]
            EndIf
            $count_a2 = 1
            line($x11_a2,$y11_a2,$x22_a2,$y22_a2)
        EndIf
        $count_a2 = $count_a2 + 1
    ElseIf $gear = 3 Then
        If $count_o1 = 0 Then 
            $first = MouseGetPos()
            If $x_draw = "" Then
                $x11_o1 = $first[0]  - $offset_x - $win[0]
                $y11_o1 = $first[1]  - $offset_y - $win[1]
            Else
                $x11_o1 = $x_draw  - $offset_x - $win[0]
                $y11_o1 = $y_draw  - $offset_y - $win[1]
            EndIf
        EndIf
        If $count_o1 = 1 Then 
            $second = MouseGetPos()
            If $x_draw = "" Then
                $x22_o1 = $second[0]  - $offset_x - $win[0]
                $y22_o1 = $second[1] - $offset_y - $win[1]
             Else
                $x22_o1 = $x_draw - $offset_x - $win[0]
                $y22_o1 = $y_draw - $offset_y - $win[1]
            EndIf
            line($x11_o1,$y11_o1,$x22_o1,$y22_o1)
            $x11_o1 = $x22_o1
            $y11_o1 = $y22_o1
        EndIf
        If $count_o1 = 2 Then 
            $second = MouseGetPos()
            $x11_o1 = $x22_o1
            $y11_o1 = $y22_o1
            If $x_draw = "" Then
                $x22_o1 = $second[0]  - $offset_x - $win[0]
                $y22_o1 = $second[1] - $offset_y - $win[1]
            Else
                $x22_o1 = $x_draw - $offset_x - $win[0]
                $y22_o1 = $y_draw - $offset_y - $win[1]
            EndIf
            $count_o1 = 1
            line($x11_o1,$y11_o1,$x22_o1,$y22_o1)
        EndIf
        $count_o1 = $count_o1 + 1
    ElseIf $gear = 4 Then
        If $count_o2 = 0 Then 
            $first = MouseGetPos()
            If $x_draw = "" Then
                $x11_o2 = $first[0]  - $offset_x - $win[0]
                $y11_o2 = $first[1]  - $offset_y - $win[1]
            Else
                $x11_o2 = $x_draw  - $offset_x - $win[0]
                $y11_o2 = $y_draw  - $offset_y - $win[1]
            EndIf
        EndIf
        If $count_o2 = 1 Then 
            $second = MouseGetPos()
            If $x_draw = "" Then
                $x22_o2 = $second[0]  - $offset_x - $win[0]
                $y22_o2 = $second[1] - $offset_y - $win[1]
             Else
                $x22_o2 = $x_draw - $offset_x - $win[0]
                $y22_o2 = $y_draw - $offset_y - $win[1]
            EndIf
            line($x11_o2,$y11_o2,$x22_o2,$y22_o2)
            $x11_o2 = $x22_o2
            $y11_o2 = $y22_o2
        EndIf
        If $count_o2 = 2 Then 
            $second = MouseGetPos()
            $x11_o2 = $x22_o2
            $y11_o2 = $y22_o2
            If $x_draw = "" Then
                $x22_o2 = $second[0]  - $offset_x - $win[0]
                $y22_o2 = $second[1] - $offset_y - $win[1]
            Else
                $x22_o2 = $x_draw - $offset_x - $win[0]
                $y22_o2 = $y_draw - $offset_y - $win[1]
            EndIf
            $count_o2 = 1
            line($x11_o2,$y11_o2,$x22_o2,$y22_o2)
        EndIf
        $count_o2 = $count_o2 + 1
    ElseIf $gear = 5 Then
        If $count_o3 = 0 Then 
            $first = MouseGetPos()
            If $x_draw = "" Then
                $x11_o3 = $first[0]  - $offset_x - $win[0]
                $y11_o3 = $first[1]  - $offset_y - $win[1]
            Else
                $x11_o3 = $x_draw  - $offset_x - $win[0]
                $y11_o3 = $y_draw  - $offset_y - $win[1]
            EndIf
        EndIf
        If $count_o3 = 1 Then 
            $second = MouseGetPos()
            If $x_draw = "" Then
                $x22_o3 = $second[0]  - $offset_x - $win[0]
                $y22_o3 = $second[1] - $offset_y - $win[1]
             Else
                $x22_o3 = $x_draw - $offset_x - $win[0]
                $y22_o3 = $y_draw - $offset_y - $win[1]
            EndIf
            line($x11_o3,$y11_o3,$x22_o3,$y22_o3)
            $x11_o3 = $x22_o3
            $y11_o3 = $y22_o3
        EndIf
        If $count_o3 = 2 Then 
            $second = MouseGetPos()
            $x11_o3 = $x22_o3
            $y11_o3 = $y22_o3
            If $x_draw = "" Then
                $x22_o3 = $second[0]  - $offset_x - $win[0]
                $y22_o3 = $second[1] - $offset_y - $win[1]
            Else
                $x22_o3 = $x_draw - $offset_x - $win[0]
                $y22_o3 = $y_draw - $offset_y - $win[1]
            EndIf
            $count_o3 = 1
            line($x11_o3,$y11_o3,$x22_o3,$y22_o3)
        EndIf
        $count_o3 = $count_o3 + 1
    Else
        If $count_us = 0 Then 
            $first = MouseGetPos()
            If $x_draw = "" Then
                $x11 = $first[0]  - $offset_x - $win[0]
                $y11 = $first[1]  - $offset_y - $win[1]
            Else
                $x11 = $x_draw  - $offset_x - $win[0]
                $y11 = $y_draw  - $offset_y - $win[1]
            EndIf
        EndIf
        If $count_us = 1 Then 
            $second = MouseGetPos()
            If $x_draw = "" Then
                $x22 = $second[0]  - $offset_x - $win[0]
                $y22 = $second[1] - $offset_y - $win[1]
             Else
                $x22 = $x_draw - $offset_x - $win[0]
                $y22 = $y_draw - $offset_y - $win[1]
            EndIf
            line($x11,$y11,$x22,$y22)
            $x11 = $x22
            $y11 = $y22
        EndIf
        If $count_us = 2 Then 
            $second = MouseGetPos()
            $x11 = $x22
            $y11 = $y22
            If $x_draw = "" Then
                $x22 = $second[0]  - $offset_x - $win[0]
                $y22 = $second[1] - $offset_y - $win[1]
            Else
                $x22 = $x_draw - $offset_x - $win[0]
                $y22 = $y_draw - $offset_y - $win[1]
            EndIf
            $count_us = 1
            line($x11,$y11,$x22,$y22)
        EndIf
        $count_us = $count_us + 1
    EndIf
EndFunc


Func line($x1,$y1,$x2,$y2)
    If $gear = "Low" Then $color = "0xff0000"
    If $gear = "Mid" Then $color = "0xffff00"
    If $gear = "High" Then $color = "0x00ff00"
    If $gear = 1 Then $color = "0x800080"
    If $gear = 2 Then $color = "0xFF00FF"
    If $gear = 3 Then $color = "0x00FFFF"
    If $gear = 4 Then $color = "0x0080FF"
    If $gear = 5 Then $color = "0x0000A2"
    ;GuiCtrlSetState($field,$GUI_DISABLE)
    GUICtrlSetGraphic($graphic, $GUI_GR_NOBKCOLOR)
    GUICtrlSetGraphic($graphic, $GUI_GR_PENSIZE,2)
    GUICtrlSetGraphic($graphic, $GUI_GR_MOVE, $x1,$y1)
    GUICtrlSetGraphic($graphic, $GUI_GR_COLOR, $color)
    GUICtrlSetGraphic($graphic, $GUI_GR_LINE, $x2,$y2)
    GUICtrlSetGraphic($graphic, $GUI_GR_REFRESH)
EndFunc


Func waypoint($x_way = "",$y_way = "")
    If $team = "blue" And $gear = 1 Then
        $way_color = "0x0000ff"
    ElseIf $team = "red" And $gear = 1 Then
        $way_color = "0xff0000"
    ElseIf $team = "blue" And $gear = 2 Then
        $way_color = "0x0000ff"
    ElseIf $team = "red" And $gear = 2 Then
        $way_color = "0xff0000"
    ElseIf $team = "red" And $gear = 3 Then 
        $way_color = "0x0000ff"
    ElseIf $team = "blue" And $gear = 3 Then
        $way_color = "0xff0000"
    ElseIf $team = "red" And $gear = 4 Then 
        $way_color = "0x0000ff"
    ElseIf $team = "blue" And $gear = 4 Then
        $way_color = "0xff0000"
    ElseIf $team = "red" And $gear = 5 Then 
        $way_color = "0x0000ff"
    ElseIf $team = "blue" And $gear = 5 Then
        $way_color = "0xff0000"
    ElseIf $gear = "low" Then 
        $way_color = "0x00ff00"
    ElseIf $gear = "mid" Then 
        $way_color = "0x00ff00"
    ElseIf $gear = "high" Then 
        $way_color = "0x00ff00"
    Else
        $way_color = "0x000000"
    EndIf
    
    $window = GUIGetCursorInfo()
    If $x_way = "" Then
        $x = $window[0] - 4
    Else
        $x = $x_way - 8
    EndIf
    If $y_way = "" Then
        $y = $window[1] - 4
    Else
        $y = $y_way - 24 ; <======================================================================== #change this!!!# ========================================================================>
    EndIf
    $num2 = GUICtrlCreateLabel("",$x,$y,9,9)
    GUICtrlSetBkColor($num2, $way_color)
    ;GUICtrlCreatePic("C:\PS\dot.bmp",$x,$y,9,9)
    $num2 = $num2 + 1
EndFunc


Func code()
    If $gear <> 1 And $gear <> 2 And $gear <> 3 And $gear <> 4 And $gear <> 5 Then
    If $delay <> 0 then $p = $delay
    $window=GUIGetCursorInfo()
    $win = WinGetPos("† •  WÌÑÑÒVÅTÍÓÑ — P§ — ß€†Â  • †")
    $pos = MouseGetPos()
    $x_move = $window[0]
    $y_move = $window[1]
    $distance = ""
    If $gear = "Low" Then $gear_num = 1
    If $gear = "Mid" Then $gear_num = 2
    If $gear = "High" Then $gear_num = 3
    
    If $auto = 4 Or $auto = 5 Or $auto = 6 And $num = 0 Then 
        $mode = 1
    EndIf
    If $auto = 1 Or $auto = 2 Or $auto = 3 And $num = 0 Then
        $mode = 2
    EndIf
    If $auto = 0 Then
        $mode = 0
    EndIf
    
    If $mode = 0 Then
        $x_move1[$num] = $window[0] - 50
        $y_move1[$num] = $window[1] - 70
        $gear_num1[$num] = $gear_num
    EndIf
    
    If $mode = 1 Then
        $x_move1[$num] = $window[1] - 70
        $y_move1[$num] = $window[0] - 50
        $gear_num1[$num] = $gear_num
    EndIf
    
    If $mode = 2 Then
        $x_move1[$num] = Abs($window[1] - 315 - 70)
        $y_move1[$num] = Abs($window[0] - 648 - 50)
        $gear_num1[$num] = $gear_num
    EndIf
    
    If $x_move1[$num] = "" Then $x_move1[$num] = 0
    If $y_move1[$num] = "" Then $y_move1[$num] = 0
    
 
    $x_old = $x_move
    $y_old = $y_move
    $ahead = "int gui_variables[4]=" & @CRLF & "{//        #    end_angle  accel  brake" & @CRLF & "{    " & $num & ",        " & $oldvalue * 3.6 & ",        " & $accel1 & ",        " & $brakes1 & "}" & @CRLF & "};" & @CRLF & @CRLF
    If $no = 0 Then $head = "int waypoints[" & $num + 1 & "][4]=" & @CRLF & "{/*	x	y	g	p        */"
    If $no = 0 Then $output = $output & @CRLF & "/*" & $num & "*/  { " & $x_move1[$num] & ",           " & $y_move1[$num] & ",            " & $gear_num1[$num] & ",              " & $p & ",    	}," 
    $output1 = $ahead & @CRLF & $head &  $output & @CRLF & "};"
    GUICtrlSetData(4105,$text)
    GUICtrlSetData($code,$output1)
    If $no = 0 Then $num = $num + 1
    $no = 0
    $delay = 0
    EndIf
EndFunc

Func GUICtrlCreateLine($x1, $y1, $x2, $y2, $size = 1, $color = "0x00ff00")
    $line = 1
    If $gear = "Low" Then $color = "0xff0000"
    If $gear = "Mid" Then $color = "0xffff00"
    If $gear = "High" Then $color = "0x00ff00"
    $deltaX = $x2 - $x1
    $deltaY = $y2 - $y1
    $length = _Ceil (Sqrt($deltaX * $deltaX + $deltaY * $deltaY))
    $incDeltaX = $deltaX / $length
    $incDeltaY = $deltaY / $length
    For $i = 0 To $length
        GUICtrlDelete($controlIDs[$nextControl])
        $controlIDs[$nextControl] = GUICtrlCreateLabel("", $x1 + $incDeltaX * $i, $y1 + $incDeltaY * $i, $size, $size)
        GUICtrlSetBkColor($controlIDs[$nextControl], $color)
        $nextControl = Mod($nextControl + 1, $maxControls)
        $current = $current + 1
        $line = $line + 1
    Next
    Return 1
EndFunc

Func _IsPressed($s_hexKey, $v_dll = 'user32.dll')
	Local $a_R = DllCall($v_dll, "int", "GetAsyncKeyState", "int", '0x' & $s_hexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Return 0
EndFunc
