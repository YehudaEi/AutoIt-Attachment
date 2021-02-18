#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

$x=290
$y=300
$x1=290
$y1=313
$Lx=310
$Ly=285
$Lx1=300
$Ly1=320
$left=50
$top=100
$iXGoal = 300
$iYGoal = 300
$iX = 1
$iY = 1
$iX2 = 390
$iY2 = 0
$iX3 = 0
$iY3 = 250
$iX4 = 250
$iY4 = 320
$iDelta = 1
$iDeltax = -1
$iDeltay = 1
$iDeltax2 = 1
$iDeltax3 = 1
$iDeltay3 = -1
HotKeySet("{esc}", "terminate")

$hGui = GUICreate("lol123",400,400,10,10)
$lable = GUICtrlCreateLabel("use the arrow keys to move the arrow into the goal",50,50)
$hLabel = GUICtrlCreateLabel("0", $iX, $iY, 10, 15)
$hLabel2 = GUICtrlCreateLabel("0", $iX2, $iY2, 10, 15)
$hLabel3 = GUICtrlCreateLabel("0", $iX3, $iY3, 10, 15)
$hLabel4 = GUICtrlCreateLabel("0", $iX4, $iY4, 10, 15)
$lable4 = GUICtrlCreateLabel("000000000000000000", $Lx, $Ly)
$lable5 = GUICtrlCreateLabel("0", $x, $y)
$lable6 = GUICtrlCreateLabel("0", $x1, $y1)
$lable7 = GUICtrlCreateLabel("000000000000000000", $Lx1, $Ly1)
$lable2 = GUICtrlCreateLabel("~~>",$left,$top,25,18)
GUICtrlSetBkColor(-1,0xff0000);just to see
$lable3 = GUICtrlCreateLabel("GAOL",$iXGoal,$iYGoal,30,18)
GUICtrlSetBkColor(-1,0xff0000);just to see
GUISetState()
AdlibRegister("_Win",1)

While 1
    Sleep(10)
    $nMsg = GUIGetMsg()
    If $nMsg = $GUI_EVENT_CLOSE Then Exit

	If _IsPressed(25) Then _LEFT()
    If _IsPressed(26) Then _UP()
    If _IsPressed(27) Then _RIGHT()
    If _IsPressed(28) Then _DOWN()

    ; Change the coordinates
    $iX += $iDelta
    $iY += $iDelta
	$iX2+= $iDeltax
    $iY2+= $iDeltay
	$iX3+= $iDeltax2
	$iX4+= $iDeltax3
	$iY4+= $iDeltay3
    ; Toggle the delta at the ends of the run
    If $iX = 300 Then
        $iDelta = -1
		Sleep(100)
    ElseIf $iX = 0 Then
        Sleep(100)
		$iDelta = 1
    EndIf

	If $iX2 = 390 And $iY2 = 0 Then
		$iDeltax = -1
		$iDeltay = 1
	ElseIf $iX2 = 0 And $iY2 =390  Then
		$iDeltax = 1
		$iDeltay = -1
	EndIf

	If $iX4 = 325 And $iY4 = 245 Then
		$iDeltax3 = -1
		$iDeltay3 = 1
	ElseIf $iX4 = 250 And $iY4 = 320 Then
		$iDeltax3 = 1
		$iDeltay3 = -1
	EndIf

	If $iX3 = 0 Then
		$iDeltax2 = 1
	ElseIf $iX3 = 390 Then
		$iDeltax2 = -1
	EndIf

	If $Lx-25<=$left And $left<=$Lx+100 And $Ly-18<=$top And $top<=$Ly+18 Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

	If $Lx1-25<=$left And $left<=$Lx1+100 And $Ly1-18<=$top And $top<=$Ly1+18 Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

	If $x-25<=$left And $left<=$x+15 And $y-10<=$top And $top<=$y+10 Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

	If $x1-25<=$left And $left<=$x1+15 And $y1-10<=$top And $top<=$y1+10 Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

	If $iX-15<=$left And $left<=$iX+15 And $iY-18<=$top And $top<=$iY+18 Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

	If $iX2-15<=$left And $left<=$iX2+15 And $iY2-18<=$top And $top<=$iY2+18 Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

	If $iX3-15<=$left And $left<=$iX3+15 And $iY3-18<=$top And $top<=$iY3-18  Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

	If $iX4-25<=$left And $left<=$iX4+15 And $iY4-18<=$top And $top<=$iY4+18  Then
		MsgBox(0, "awh","you lose")
		Exit
	EndIf

; Move the label
    ControlMove($hGUI, "", $hLabel4, $iX4, $iY4)
	ControlMove($hGUI, "", $hLabel3, $iX3, $iY3)
	ControlMove($hGUI, "", $hLabel2, $iX2, $iY2)
    ControlMove($hGUI, "", $hLabel, $iX, $iY)

WEnd

Func terminate()
    Exit
EndFunc

Func _Win()
    If $iXGoal-25<=$left And $left<=$iXGoal+30 And $iYGoal-18<=$top And $top<=$iYGoal+18 Then
        MsgBox(64,"Congratulation!","We have a winner!")
        Exit
    EndIf
EndFunc

Func _LEFT()
    $left=$left-3
    ControlMove($hGui,"",$lable2, $left,$top)
EndFunc

Func _RIGHT()
    $left=$left+3
    ControlMove($hGui,"",$lable2, $left,$top)
EndFunc

Func _UP()
    $top=$top-3
    ControlMove($hGui,"",$lable2, $left,$top)
EndFunc

Func _DOWN()
    $top=$top+3
    ControlMove($hGui,"",$lable2, $left,$top)
EndFunc