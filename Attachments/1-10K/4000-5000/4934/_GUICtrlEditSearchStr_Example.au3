#include <GUIConstants.au3>
#include <GUIEdit.au3>
GUICreate("_GUICtrlEditSearchString", 300, 300)
$MyEdit = GUICtrlCreateEdit("Autoit is best program!", 10, 10, 290, 260)
$MyBut = GUICtrlCreateButton("Search", 100, 270, 50, 20)
GUISetState()
Do
    $msg = GUIGetMsg()
Select
Case $msg = $MyBut
    $search = _GUICtrlEditSearchStr($MyEdit, "best")
EndSelect
Until $msg = $GUI_EVENT_CLOSE

Func _GUICtrlEditSearchStr($edit, $string)
$count = 0
Global $Save_String = $string
Global $Save_Edit = $edit
Do
    $trim_right = StringTrimRight($string, 1)
    $count = $count + 1
    $string = $trim_right
Until $trim_right = ""
$new_count = 0
Global $edit1 = GUICtrlRead($edit)
Do
    $r_count = 0
    $right = StringLeft($edit1, $count)
    If $right = $Save_String Then
        $new_count = $new_count
        Global $new_count2 = $new_count + $count
        GUICtrlSetState($edit,$GUI_FOCUS)
        _GUICtrlEditSetSel($edit, $new_count, $new_count2)
    $r_count = 1
    Else
        $edit1 = StringTrimLeft($edit1, 1)
        $new_count = $new_count + 1
    EndIf
Until $r_count = 1
EndFunc