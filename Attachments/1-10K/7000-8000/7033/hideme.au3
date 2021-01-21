#NoTrayIcon

#include<guiconstants.au3>
#Include <GuiListView.au3>

HotKeySet("!{ESC}","terminate")
HotKeySet("!{pgdn}","hide")
HotKeySet("!{pgup}","unhide")

dim $window[1000]
dim $state[1000]
dim $xx[1000]
$i=1

$hider = GUICreate("Unhide Window", 300, 300)
$list = GUICtrlCreateListView ("Window|Status", 10, 10, 280, 200)
$unhide = GUICtrlCreateButton ("Unhide", 10, 220, 130)
$hide = GUICtrlCreateButton ("Hide", 160, 220, 130)
$update = GUICtrlCreateButton ("Update", 80, 260, 140)
GUISetState()

WinSetState ("Unhide Window", "", @sw_hide)


while 1
		$msg = GUIGetMsg()
		Select
		case $msg = $GUI_EVENT_CLOSE
			WinSetState ("Unhide Window", "", @sw_hide)
		Case $msg = $unhide
			$a = StringSplit(guictrlread(guictrlread($list)), "|")
			WinSetState($a[1] ,"",@SW_SHOW)
		case $msg = $hide
			$a = StringSplit(guictrlread(guictrlread($list)), "|")
			WinSetState($a[1] ,"",@SW_HIDE)
		case $msg = $update
			update()
		case $msg = $list
			Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($list) ]
			_GUICtrlListViewSort1($list, $B_DESCENDING, GUICtrlGetState($list))
		EndSelect
WEnd

func update()
	_GUICtrlListViewDeleteAllItems ($list)
	$lili = WinList()
	for $j = 1 to $lili[0][0] step 1
		$state[$j] = WinGetState ($lili[$j][1])
		Select
		case BitAND($state[$j], 1) and BitAND ($state[$j], 2)
			$winstate = "shown"
		case BitAND($state[$j], 1) and Not BitAND ($state[$j], 2)
			$winstate = "hidden"
		Case not BitAND ($state[$j], 1)
			$winstate = "doesn't exist"
		EndSelect
		if $lili[$j][0] <> "" and $winstate <> "doesn't exist" Then $window[$j] = GUICtrlCreateListViewItem ($lili[$j][0] & "|" & $winstate, $list)
	Next
	Dim $B_DESCENDING = 1
	_GUICtrlListViewSort1($list, $B_DESCENDING, 1)	
EndFunc


Func hide()
    $xx[$i] = wingettitle ("")
    WinSetState($xx[$i],"",@SW_HIDE)
    $i = $i + 1
EndFunc

Func unhide()
    WinSetState("Unhide Window", "", @SW_SHOW)
	update()
EndFunc

Func terminate()
    Exit
EndFunc

Func _GUICtrlListViewSort1($h_listview, ByRef $v_descending, $i_sortcol, $s_Title = "", $s_text = "")
   Local $X, $Y, $b_desc, $columns, $items, $v_item, $temp_item
   If _GUICtrlListViewGetItemCount($h_listview) Then
      If (StringLen($s_Title) == 0) Then
         $s_Title = WinGetTitle("")
      EndIf
      If (IsArray($v_descending)) Then
         $b_desc = $v_descending[$i_sortcol]
      Else
         $b_desc = $v_descending
      EndIf
      $columns = _GUICtrlListViewGetSubItemsCount($h_listview, $s_Title, $s_text)
      $items = _GUICtrlListViewGetItemCount($h_listview)
      For $X = 1 To $columns
         $temp_item = $temp_item & " |"
      Next
      $temp_item = StringTrimRight($temp_item, 1)
      If ($columns > 1) Then
         Local $a_lv[$items][$columns]
         For $X = 0 To UBound($a_lv) - 1 Step 1
            For $Y = 0 To UBound($a_lv, 2) - 1 Step 1
               $v_item = _GUICtrlListViewGetItemText($h_listview, $X, $Y, $s_Title, $s_text)
               If (StringIsFloat($v_item) Or StringIsInt($v_item)) Then
                  $a_lv[$X][$Y] = Number($v_item)
               Else
                  $a_lv[$X][$Y] = $v_item
               EndIf
            Next
         Next
         _GUICtrlListViewDeleteAllItems($h_listview)
         _ArraySort($a_lv, $b_desc, 0, 0, $columns, $i_sortcol)
         For $X = 0 To UBound($a_lv) - 1 Step 1
            $window[$X] = GUICtrlCreateListViewItem ($v_item, $h_listview)
            For $Y = 0 To UBound($a_lv, 2) - 1 Step 1
               _GUICtrlListViewSetItemText($h_listview, $X, $Y, $a_lv[$X][$Y])
            Next
         Next
      Else
         Local $a_lv[$items]
         For $X = 0 To UBound($a_lv) - 1 Step 1
            $v_item = _GUICtrlListViewGetItemText($h_listview, $X, -1, $s_Title, $s_text)
            If (StringIsFloat($v_item) Or StringIsInt($v_item)) Then
               $a_lv[$X] = Number($v_item)
            Else
               $a_lv[$X] = $v_item
            EndIf
         Next
         _GUICtrlListViewDeleteAllItems($h_listview)
         _ArraySort($a_lv, $b_desc)
         For $X = 0 To UBound($a_lv) - 1 Step 1
            $window[$X] = GUICtrlCreateListViewItem ($v_item, $h_listview)
         Next
      EndIf
      If (IsArray($v_descending)) Then
         $v_descending[$i_sortcol] = Not $b_desc
      Else
         $v_descending = Not $b_desc
      EndIf
   EndIf
EndFunc   ;==>_GUICtrlListViewSort