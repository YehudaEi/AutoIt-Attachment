
#include <GUIConstants.au3>
#include <GuiList.au3>
#include <Array.au3>
#include <Process.au3>

GUICreate("Window Hider", 941, 461)

Dim $windows, $i, $mess, $selected, $testtext, $edit, $windowtohide, $windowtohide1, $hax

$list = GUICtrlCreateList("", 1, 1, 300, 400, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY, $WS_HSCROLL, $LBS_MULTIPLESEL, $LBS_DISABLENOSCROLL))
$list2 = GUICtrlCreateList("", 340, 1, 300, 400, BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $WS_HSCROLL, $LBS_NOTIFY, $LBS_MULTIPLESEL, $LBS_DISABLENOSCROLL))
$list3 = GUICtrlCreateList("", 640, 1, 300, 400, BitOR($WS_BORDER, $WS_VSCROLL, $WS_HSCROLL, $LBS_NOTIFY, $LBS_MULTIPLESEL, $LBS_DISABLENOSCROLL))
GUICtrlSetLimit($list, 600)
GUICtrlSetLimit($list2, 600)
GUICtrlSetLimit($list3, 600)
$button = GUICtrlCreateButton("Visible", 1, 385, 80, 20)
$button2 = GUICtrlCreateButton("Invisible", 1, 406, 80, 20)
$button3 = GUICtrlCreateButton("All", 1, 427, 80, 20)
$addtolist1 = GUICtrlCreateButton(">", 301, 180, 38, 20)
$addtolist2 = GUICtrlCreateButton(">>", 301, 200, 38, 20)
$clearsel = GUICtrlCreateButton("Clear Selected", 450, 385, 80, 20)
$clearall = GUICtrlCreateButton("Clear All", 450, 406, 80, 20)
$hidesel = GUICtrlCreateButton("Hide Selected", 340, 385, 80, 20)
$showsel = GUICtrlCreateButton("Show Selected", 559, 385, 80, 20)
$hideall = GUICtrlCreateButton("Hide All", 340, 406, 80, 20)
$showall = GUICtrlCreateButton("Show All", 559, 406, 80, 20)
$hideproc = GUICtrlCreateButton("Hide by Process", 745, 385, 90, 20)
$showproc = GUICtrlCreateButton("Show by Process", 745, 406, 90, 20)

GUISetState()
While $mess <> $GUI_EVENT_CLOSE
	$mess = GUIGetMsg()
	If $mess = $button Then populate()
	If $mess = $button2 Then populateinvis()
	If $mess = $button3 Then populateall()
	If $mess = $addtolist1 Then addtolist()
	If $mess = $clearsel Then clearsel()
	If $mess = $clearall Then clearall()
	If $mess = $hidesel Then hideselected()
	If $mess = $hideall Then hideall()
	If $mess = $showsel Then showselected()
	If $mess = $showall Then showall()
	If $mess = $addtolist2 Then addall()
	If $mess = $hideproc Then _hidebyproc()
	If $mess = $showproc Then showbyproc()
WEnd


Func IsVisible($handle)
	If BitAND( WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible


Func populate()
	GUICtrlSetData($list, "")
	$windows = WinList()
	For $i = 1 To $windows[0][0]
		If $windows[$i][0] <> "" And IsVisible($windows[$i][1]) Then
			GUICtrlSetData($list, $windows[$i][0])
		EndIf
	Next
EndFunc   ;==>populate


Func populateinvis()
	GUICtrlSetData($list, "")
	$windows = WinList()
	For $i = 1 To $windows[0][0]
		If $windows[$i][0] <> "" And IsVisible($windows[$i][1]) = 0 Then
			GUICtrlSetData($list, $windows[$i][0])
		EndIf
	Next
EndFunc   ;==>populateinvis


Func populateall()
	GUICtrlSetData($list, "")
	$windows = WinList()
	For $i = 1 To $windows[0][0]
		If $windows[$i][0] <> "" Then
			GUICtrlSetData($list, $windows[$i][0])
		EndIf
	Next
EndFunc   ;==>populateall

Func addprocesses()
	$selected = _GUICtrlListGetSelItemsText($list)
	If IsArray($selected) Then
		For $i = 1 To $selected[0]
			$procid = WinGetProcess($selected[$i])
			$procname = _ProcessGetName($procid)
			GUICtrlSetData($list3, $procname)
		Next
	EndIf
EndFunc   ;==>addprocesses

Func _hidebyproc()
	_GUICtrlListSelItemRange($list, "", _GUICtrlListCount($list) - _GUICtrlListCount($list), _GUICtrlListCount($list) - 1)
	$selected = _GUICtrlListGetSelItemsText($list3)
	If IsArray($selected) Then
		For $i = 0 To $selected[0]
			$selected2 = _GUICtrlListGetSelItemsText($list)
			If IsArray($selected2) Then
				For $i2 = 0 To $selected2[0]
					$procid = WinGetProcess($selected2[$i2])
					$procname = _ProcessGetName($procid)
					If $procname = $selected[$i] Then
						WinSetState($selected2[$i2], "", @SW_HIDE)
					EndIf
				Next
			EndIf
		Next
	EndIf
EndFunc   ;==>hidebyproc

Func showbyproc()
	_GUICtrlListSelItemRange($list, "", _GUICtrlListCount($list) - _GUICtrlListCount($list), _GUICtrlListCount($list) - 1)
	$selected = _GUICtrlListGetSelItemsText($list3)
	If IsArray($selected) Then
		For $i = 0 To $selected[0]
			$selected2 = _GUICtrlListGetSelItemsText($list)
			If IsArray($selected2) Then
				For $i2 = 0 To $selected2[0]
					$procid = WinGetProcess($selected2[$i2])
					$procname = _ProcessGetName($procid)
					If $procname = $selected[$i] Then
						WinSetState($selected2[$i2], "", @SW_SHOW)
					EndIf
				Next
			EndIf
		Next
	EndIf
EndFunc   ;==>showbyproc

Func addtolist()
	$selected = _GUICtrlListGetSelItemsText($list)
	If IsArray($selected) Then
		For $i = 1 To $selected[0]
			GUICtrlSetData($list2, $selected[$i])
		Next
	EndIf
	addprocesses()
EndFunc   ;==>addtolist

Func addall()
	_GUICtrlListSelItemRange($list, "", _GUICtrlListCount($list) - _GUICtrlListCount($list), _GUICtrlListCount($list) - 1)
	$selected = _GUICtrlListGetSelItemsText($list)
	If IsArray($selected) Then
		For $i = 1 To $selected[0]
			GUICtrlSetData($list2, $selected[$i])
		Next
	EndIf
EndFunc   ;==>addall

Func clearsel()
	$selected = _GUICtrlListGetSelItems($list2)
	If IsArray($selected) Then
		For $i = 0 To $selected[0]
			_GUICtrlListDeleteItem($list2, $selected[$i])
		Next
	EndIf
EndFunc   ;==>clearsel


Func clearall()
	GUICtrlSetData($list2, "")
	GUICtrlSetData($list3, "")
EndFunc   ;==>clearall


Func hideselected()
	$selected = _GUICtrlListGetSelItemsText($list2)
	If IsArray($selected) Then
		For $i = 1 To $selected[0]
			$windowtohide = $selected[$i]
			WinSetState($windowtohide, "", @SW_HIDE)
		Next
	EndIf
EndFunc   ;==>hideselected


Func hideall()
	_GUICtrlListSelItemRange($list2, "", _GUICtrlListCount($list2) - _GUICtrlListCount($list2), _GUICtrlListCount($list2) - 1)
	$selected = _GUICtrlListGetSelItemsText($list2)
	If IsArray($selected) Then
		For $i = 1 To $selected[0]
			$windowtohide = $selected[$i]
			WinSetState($windowtohide, "", @SW_HIDE)
		Next
	EndIf
EndFunc   ;==>hideall


Func showselected()
	$selected = _GUICtrlListGetSelItemsText($list2)
	If IsArray($selected) Then
		For $i = 1 To $selected[0]
			$windowtohide = $selected[$i]
			WinSetState($windowtohide, "", @SW_SHOW)
		Next
	EndIf
EndFunc   ;==>showselected


Func showall()
	_GUICtrlListSelItemRange($list2, "", _GUICtrlListCount($list2) - _GUICtrlListCount($list2), _GUICtrlListCount($list2) - 1)
	$selected = _GUICtrlListGetSelItemsText($list2)
	If IsArray($selected) Then
		For $i = 1 To $selected[0]
			$windowtohide = $selected[$i]
			WinSetState($windowtohide, "", @SW_SHOW)
		Next
	EndIf
EndFunc   ;==>showall
