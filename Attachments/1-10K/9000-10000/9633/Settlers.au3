#include <GUIConstants.au3>
 Global $r2 = 0, $r3 = 0, $r4 = 0, $r5 = 0, $r6 = 0, $r7 = 0, $r8 = 0, $r9 = 0, $r10 = 0, $r11 = 0, $r12 = 0

$y_coord_Rolls_button_Row1 = 31
$y_coord_Rolls_button_Row2 = 180

$y_coord_Rolls_Theo_Row1 = $y_coord_Rolls_button_Row1 - 20
$y_coord_Rolls_Theo_Row2 = $y_coord_Rolls_button_Row2 - 20

;~ .028 - 2's & 12's
;~ .056 - 3's & 11's
;~ .083 - 4's & 10's
;~ .111 - 5's & 9's
;~ .139 - 6's & 8's
;~ .167 - 7's

; == GUI generated with Koda ==
$Form1 = GUICreate("AForm1", 618, 352, 192, 125)
$Button2 = GUICtrlCreateButton("2", 8, $y_coord_Rolls_button_Row1, 75, 25)
$Button3 = GUICtrlCreateButton("3", 96, $y_coord_Rolls_button_Row1, 75, 25)
$Button4 = GUICtrlCreateButton("4", 184, $y_coord_Rolls_button_Row1, 75, 25)
$Button5 = GUICtrlCreateButton("5", 272, $y_coord_Rolls_button_Row1, 75, 25)
$Button6 = GUICtrlCreateButton("6", 360, $y_coord_Rolls_button_Row1, 75, 25)
$Button7 = GUICtrlCreateButton("7", 448, $y_coord_Rolls_button_Row1, 75, 25)
$Button8 = GUICtrlCreateButton("8", 8, $y_coord_Rolls_button_Row2, 75, 25)
$Button9 = GUICtrlCreateButton("9", 96, $y_coord_Rolls_button_Row2, 75, 25)
$Button10 = GUICtrlCreateButton("10", 184, $y_coord_Rolls_button_Row2, 75, 25)
$Button11 = GUICtrlCreateButton("11", 272, $y_coord_Rolls_button_Row2, 75, 25)
$Button12 = GUICtrlCreateButton("12", 360, $y_coord_Rolls_button_Row2, 75, 25)

$x_coord_Rolls_Theo_Row1 = 16
$x_coord_Rolls_Theo_Row1_variance = 88

;~ Theoretical Row 1
GUICtrlCreateLabel(".028", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".056",$x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".083", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".111", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".139", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".167", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = 16

;~ Theoretical Row 2
GUICtrlCreateLabel(".139", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".111", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".083", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".056", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Theo_Row1 = $x_coord_Rolls_Theo_Row1 + $x_coord_Rolls_Theo_Row1_variance
GUICtrlCreateLabel(".028", $x_coord_Rolls_Theo_Row1, $y_coord_Rolls_Theo_Row2, 43, 17, $SS_CENTER)






;;;;;;;;;;;;;;;;;;;;;;;;;;;Only a Place Marker;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$x_coord_Rolls_Actual_Row1 = 16
$x_coord_Rolls_Actual_Row1_variance = 88
$y_coord_Rolls_Actual_Row1 = $y_coord_Rolls_button_Row1 + 60
$y_coord_Rolls_Actual_Row2 = $y_coord_Rolls_button_Row2 + 60

;~ Current/Actual Row 1
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual",$x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = 16

;~ Current/Actual Row 2
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Actual_Row1 = $x_coord_Rolls_Actual_Row1 + $x_coord_Rolls_Actual_Row1_variance
GUICtrlCreateLabel("Actual", $x_coord_Rolls_Actual_Row1, $y_coord_Rolls_Actual_Row2, 43, 17, $SS_CENTER)


;;;;;;;;;;;;;;;;;;;;;;;;;;;Only a Place Marker;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;Deviant
$x_coord_Rolls_Deviant_Row1 = 16
$x_coord_Rolls_Deviant_Row1_variance = 88
$y_coord_Rolls_Deviant_Row1 = $y_coord_Rolls_button_Row1 + 80
$y_coord_Rolls_Deviant_Row2 = $y_coord_Rolls_button_Row2 + 80

;~ Deviant Row 1
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant",$x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row1, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = 16

;~ Deviant Row 2
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row2, 43, 17, $SS_CENTER)
	$x_coord_Rolls_Deviant_Row1 = $x_coord_Rolls_Deviant_Row1 + $x_coord_Rolls_Deviant_Row1_variance
GUICtrlCreateLabel("Deviant", $x_coord_Rolls_Deviant_Row1, $y_coord_Rolls_Deviant_Row2, 43, 17, $SS_CENTER)

GUISetState(@SW_SHOW)


$y_coord_Rolls_label_Row1 = $y_coord_Rolls_button_Row1 + 35
$y_coord_Rolls_label_Row2 = $y_coord_Rolls_button_Row2 + 35


$x_coord_Count_initial = 24
$x_coord_Count_variance = 88


While 1
 $msg = GuiGetMsg()
 Select
 Case $msg = $GUI_EVENT_CLOSE
  ExitLoop
 Case $msg = $Button2
  $r2 = $r2 + 1
  GUICtrlCreateLabel($r2, 24, $y_coord_Rolls_label_Row1, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r2)
 Case $msg = $Button3
  $r3 = $r3 + 1
  GUICtrlCreateLabel($r3, 112, $y_coord_Rolls_label_Row1, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r3)
 Case $msg = $Button4
  $r4 = $r4 + 1
  GUICtrlCreateLabel($r4, 200, $y_coord_Rolls_label_Row1, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r4)
 Case $msg = $Button5
  $r5 = $r5 + 1
  GUICtrlCreateLabel($r5, 288, $y_coord_Rolls_label_Row1, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r5)
 Case $msg = $Button6
  $r6 = $r6 + 1
  GUICtrlCreateLabel($r6, 376, $y_coord_Rolls_label_Row1, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r6)
 Case $msg = $Button7
  $r7 = $r7 + 1
  GUICtrlCreateLabel($r7, 464, $y_coord_Rolls_label_Row1, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r7)
 Case $msg = $Button8
  $r8 = $r8 + 1
  GUICtrlCreateLabel($r8, 24, $y_coord_Rolls_label_Row2, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r8)
 Case $msg = $Button9
  $r9 = $r9 + 1
  GUICtrlCreateLabel($r9, 112, $y_coord_Rolls_label_Row2, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r9)
 Case $msg = $Button10
  $r10 = $r10 + 1
  GUICtrlCreateLabel($r10, 200, $y_coord_Rolls_label_Row2, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r10)
 Case $msg = $Button11
  $r11 = $r11 + 1
  GUICtrlCreateLabel($r11, 288, $y_coord_Rolls_label_Row2, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r11)
 Case $msg = $Button12
  $r12 = $r12 + 1
  GUICtrlCreateLabel($r12, 368, $y_coord_Rolls_label_Row2, 43, 17, $SS_CENTER)
  Calculate_Percentages ($r12)
 EndSelect
WEnd
Exit

 

Func Calculate_Percentages ($r)
$total_rolls = $r2 + $r3 + $r4 + $r5 + $r6 + $r7 + $r8 + $r9 + $r10 + $r11 + $r12
$percent = $r/$total_rolls

ToolTip ($percent)
GUICtrlCreateLabel ($total_rolls, 448, 296, 75, 25)

GUICtrlCreateLabel ($total_rolls, 448, 296, 75, 25)
;~ ToolTip ($total_rolls)
;~ GUICtrlCreateLabel ($button, 448, 156, 75, 25)
;Actual


EndFunc
