#include <GuiListView.au3>

; #FUNCTION# ===================================================================
; Name : 			_GuiCtrlListView_SwitchItemSelectedUp
; Description:      Switch the selected item up
; Parameter(s):     $lv = List View
; Requirement(s):	GuiListView.au3
; Author(s):        FireFox
;===============================================================================
Func _GuiCtrlListView_SwitchItemSelectedUp($lv)
	For $i = 1 To _GUICtrlListView_GetItemCount($lv)
		If _GUICtrlListView_GetItemSelected($lv, $i) Then
			$s_obj1 = StringSplit(_GUICtrlListView_GetItemTextString($lv, $i), '|')
			$s_obj2 = StringSplit(_GUICtrlListView_GetItemTextString($lv, $i - 1), '|')
			_GUICtrlListView_SetItem($lv, $s_obj1[1], $i - 1)
			_GUICtrlListView_SetItem($lv, $s_obj2[1], $i)
			For $c = 1 To _GUICtrlListView_GetColumnCount($lv) - 1
				_GUICtrlListView_SetItem($lv, $s_obj1[$c + 1], $i - 1, $c)
				_GUICtrlListView_SetItem($lv, $s_obj2[$c + 1], $i, $c)
			Next
		EndIf
	Next
EndFunc   ;==>_GuiCtrlListView_SwitchItemSelectedUp

; #FUNCTION# ===================================================================
; Name : 			_GuiCtrlListView_SwitchItemSelectedDown
; Description:      Switch the selected item down
; Parameter(s):     $lv = List View
; Requirement(s):	GuiListView.au3
; Author(s):        FireFox
;===============================================================================
Func _GuiCtrlListView_SwitchItemSelectedDown($lv)
	For $i = 0 To _GUICtrlListView_GetItemCount($lv) - 1
		If _GUICtrlListView_GetItemSelected($lv, $i) Then
			$s_obj1 = StringSplit(_GUICtrlListView_GetItemTextString($lv, $i), '|')
			$s_obj2 = StringSplit(_GUICtrlListView_GetItemTextString($lv, $i + 1), '|')
			_GUICtrlListView_SetItem($lv, $s_obj1[1], $i + 1)
			_GUICtrlListView_SetItem($lv, $s_obj2[1], $i)
			For $c = 1 To _GUICtrlListView_GetColumnCount($lv) - 1
				_GUICtrlListView_SetItem($lv, $s_obj1[$c + 1], $i + 1, $c)
				_GUICtrlListView_SetItem($lv, $s_obj2[$c + 1], $i, $c)
			Next
		EndIf
	Next
EndFunc   ;==>_GuiCtrlListView_SwitchItemSelectedDown

; #FUNCTION# ===================================================================
; Name : 			_GUICtrlListView_ReplaceItemSelected
; Description:      Change the selected item text
; Parameter(s):     $lv = List View
;					$s_text = Text
; Requirement(s):	GuiListView.au3
; Author(s):        FireFox
;===============================================================================
Func _GUICtrlListView_ReplaceItemSelected($lv, $s_text)
	For $i = 0 To _GUICtrlListView_GetItemCount($lv)
		If _GUICtrlListView_GetItemSelected($lv, $i) Then
			_GUICtrlListView_SetItem($lv, $s_text, $i)
		EndIf
	Next
EndFunc   ;==>_GUICtrlListView_ReplaceItemSelected