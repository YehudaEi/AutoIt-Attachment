;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;// E X A M P L E   S C R I P T
;// Checkbox & ListView Item Output
;//
;// By: chaos945@msn.com
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <array.au3>
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1)
;//////////////////////////////////////////////////////
;// DEFINE - variables
;//////////////////////////////////////////////////////
DIM $output[1], $selectiontxt[1], $finalout
DIM $animal[4], $vegetable[4], $mineral[4]
DIM Const $animals = "cat, dog, mouse, parrot"
$animal = StringSplit($animals, ", ", 1)
DIM Const $vegetables = "potato, carrot, spinach, tomato"
$vegetable = StringSplit($vegetables, ", ", 1)
DIM Const $minerals = "potassium, copper, zinc, calcium"
$mineral = StringSplit($minerals, ", ", 1)

;//////////////////////////////////////////////////////
;// CREATE - GUI
;//////////////////////////////////////////////////////
GuiCreate("E X A M P L E", 300, 200, -1, -1)
$g_listview = GuiCtrlCreateListView("Animal            |Vegetable         |Mineral            ", 20, 1, 278, 167, $LVS_NOSORTHEADER + $LVS_REPORT)
GuiCtrlCreateButton("Show Selection", 198, 170, 100, 28)
GuiCtrlSetOnEvent(-1, "_ShowSelection")
GuiCtrlCreateButton("Show ListView Array", 80, 170, 110, 28)
GuiCtrlSetOnEvent(-1, "_ShowListView")
GuiSetOnEvent(-3, "_Exit")

For $a = 0 to 3 step 1
	_ArrayAdd($output, $a)
	_ArrayAdd($output, GuiCtrlCreateCheckbox("", 5, 25+(14*$a), 10, 12))
	GuiCtrlCreateListViewItem($animal[$a+1] & "|" & $vegetable[$a+1] & "|" & $mineral[$a+1], $g_listview)
	_ArrayAdd($output, GUICtrlRead(-1))
Next

GuiSetState()

;//////////////////////////////////////////////////////
;// LOOP
;//////////////////////////////////////////////////////
While 1
	;;;
WEnd

;//////////////////////////////////////////////////////
;// ACTION - 'Show Selection' button, generates output
;//////////////////////////////////////////////////////
;NOTE: this section could use more simplification

Func _ShowSelection()
	GLOBAL $selectiontxt = "", $selectiontxt[1], $finalout = "";// flushes variables: removing this line will 
															   ;cause the output to be remembered everytime 
															   ;the 'Show Selection' button is pressed and 
															   ;is added into one giant array.
	
	For $b = 2 to 12 step 3
		If GUICtrlRead($output[$b]) = $GUI_CHECKED Then
			_ArrayAdd($selectiontxt, "Line: " & $output[$b-1]+1 & @CRLF & _
									 "Containing: " & $output[$b+1])
		EndIf
	Next
	
	$selectiontxt[0] = Ubound($selectiontxt) - 1
	If $selectiontxt[0] = 0 Then
		MsgBox(0, "Error:", "Nothing Selected")
		Return
	Else
		For $c = 1 to $selectiontxt[0] step 1
			$finalout = $finalout & $selectiontxt[$c]& @CRLF & @CRLF
		Next
	EndIf
	
	MsgBox(0, "Selection:", $finalout)
EndFunc


Func _ShowListView()
	_ArrayDisplay($output, "ListView Array:")
EndFunc

;//////////////////////////////////////////////////////
;// ACTION - Exit Pressed
;//////////////////////////////////////////////////////
Func _Exit()
	Exit
EndFunc