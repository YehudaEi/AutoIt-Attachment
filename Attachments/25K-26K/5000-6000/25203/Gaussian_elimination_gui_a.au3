#include <Array.au3>
#include <GuiConstantsEx.au3>
#include "Gaussian elimination function.au3"

Func Terminate ()
	Exit
EndFunc

HotKeySet ("{ESC}", "Terminate")

$gui = GuiCreate ("Gaussian Elimination", 300, 300)
GUISetState ()

$p = 0

For $x = 1 To 10
	For $y = 1 To 9
		If $x = 10 Then
			$p = 15
		Else
			$p = 0
		EndIf
		Assign("input_"&$y&"_"&$x, GUICtrlCreateInput ("0", ($x * 25) + $p, 10 + ($y * 25), 15))
	Next
Next

$continue_button = 	GUICtrlCreateButton ("Solve", 120, 265, 50)
$help_button = GUICtrlCreateButton ("?", 170, 265, 20)

While 1
While 1
	$msg = GuiGetMsg ()
	Switch $msg
		Case $continue_button
			ExitLoop
		Case $GUI_EVENT_CLOSE
			Exit
		Case $help_button
			MsgBox (0, "Help", "This application utilizes Gaussian elimination to solve any system of linear" & @lf & _
			"equations. To enter in a system, enter the coefficients on the left side of the main screen. Then enter in the constants on the right side of the screen.", 0, $gui)
	EndSwitch
WEnd

Local $augmented_matrix[10][11]
For $x1 = 1 to 10
	For $y1 = 1 to 9
		$augmented_matrix[$y1][$x1] = GuiCtrlRead (Eval("input_"&$y1&"_"&$x1))
	Next
Next

For $c = 9 To 1 Step -1
	If IsEntireColumnZero ($c, $augmented_matrix) = 1 and IsEntireRowZero ($c, $augmented_matrix) = 1 Then
		$augmented_matrix = MoveConstantsColLeftOne ($augmented_matrix)
		;_ArrayDisplay ($augmented_matrix)
	EndIf
Next

;_ArrayDisplay ($augmented_matrix, "Fixed")
	
$answer_array = _SolveLinearSystem ($augmented_matrix)
If IsArray ($answer_array) Then
	_ArrayDisplay ($answer_array, "Solution")
Else
	Switch $answer_array
		Case -1
			MsgBox (0, "Solve linear system", "Infinitely many solutions or empty set.")
		Case -2
			MsgBox (0, "Solve linear system", "Error -2. Please try again.")
	EndSwitch
EndIf
WEnd

Func IsEntireRowZero ($row, $array)
	For $a = 1 To Ubound ($array, 2) - 1
		If $array[$row][$a] <> 0 Then Return (0)
	Next
	Return (1)
EndFunc

Func IsEntireColumnZero ($col, $array)
	For $a = 1 To Ubound ($array, 1) - 1
		If $array[$a][$col] <> 0 Then Return (0)
	Next
	Return (1)
EndFunc

Func MoveConstantsColLeftOne ($array)
	$const_col = Ubound ($array, 2) - 1
	For $a = 1 To Ubound ($array, 1) - 1
		$array[$a][$const_col-1] = $array[$a][$const_col]
	Next
	ReDim $array[$a-1][$const_col]
	Return $array
EndFunc