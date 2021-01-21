#include-once
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1++
; Language:       English
; Description:    Functions that assist with ListView.
;
; ------------------------------------------------------------------------------
; error
Global Const $LV_ERR = -1

; extended styles
;~ Global Const $LVS_EX_CHECKBOXES = 0x4
;~ Global Const $LVS_EX_GRIDLINES = 0x1
;~ Global Const $LVS_EX_HEADERDRAGDROP = 0x10
Global Const $LVS_EX_HIDELABELS = 0x20000
Global Const $LVS_EX_INFOTIP = 0x400
Global Const $LVS_EX_LABELTIP = 0x4000
Global Const $LVS_EX_ONECLICKACTIVATE = 0x40
Global Const $LVS_EX_REGIONAL = 0x200
Global Const $LVS_EX_SINGLEROW = 0x40000
Global Const $LVS_EX_TWOCLICKACTIVATE = 0x80
;~ Global Const $LVS_EX_TRACKSELECT = 0x8
Global Const $LVS_EX_UNDERLINEHOT = 0x800
Global Const $LVS_EX_UNDERLINECOLD = 0x1000

; Messages to send to listview
Global Const $CCM_FIRST = 0x2000
Global Const $CCM_GETUNICODEFORMAT = ($CCM_FIRST + 6)
Global Const $CCM_SETUNICODEFORMAT = ($CCM_FIRST + 5)
Global Const $CLR_NONE = 0xFFFFFFFF
Global Const $LVM_FIRST = 0x1000

Global Const $LV_VIEW_DETAILS = 0x1
Global Const $LV_VIEW_ICON = 0x0
Global Const $LV_VIEW_LIST = 0x3
Global Const $LV_VIEW_SMALLICON = 0x2
Global Const $LV_VIEW_TILE = 0x4

Global Const $LVCF_FMT = 0x1
Global Const $LVCF_WIDTH = 0x2
Global Const $LVCF_TEXT = 0x4
Global Const $LVCFMT_CENTER = 0x2
Global Const $LVCFMT_LEFT = 0x0
Global Const $LVCFMT_RIGHT = 0x1

Global Const $LVA_ALIGNLEFT = 0x1
Global Const $LVA_ALIGNTOP = 0x2
Global Const $LVA_DEFAULT = 0x0
Global Const $LVA_SNAPTOGRID = 0x5

Global Const $LVIF_STATE = 0x8
Global Const $LVIF_TEXT = 0x1

Global Const $LVIS_CUT = 0x4
Global Const $LVIS_DROPHILITED = 0x8
Global Const $LVIS_FOCUSED = 0x1
Global Const $LVIS_OVERLAYMASK = 0xF00
Global Const $LVIS_SELECTED = 0x2
Global Const $LVIS_STATEIMAGEMASK = 0xF000

Global Const $LVM_ARRANGE = ($LVM_FIRST + 22)
Global Const $LVM_CANCELEDITLABEL = ($LVM_FIRST + 179)
Global Const $LVM_DELETECOLUMN = 0x101C
Global Const $LVM_DELETEITEM = 0x1008
Global Const $LVM_DELETEALLITEMS = 0x1009
Global Const $LVM_EDITLABELA = ($LVM_FIRST + 23)
Global Const $LVM_EDITLABEL = $LVM_EDITLABELA
Global Const $LVM_ENABLEGROUPVIEW = ($LVM_FIRST + 157)
Global Const $LVM_ENSUREVISIBLE = ($LVM_FIRST + 19)
Global Const $LVM_GETBKCOLOR = ($LVM_FIRST + 0)
Global Const $LVM_GETCALLBACKMASK = ($LVM_FIRST + 10)
Global Const $LVM_GETCOLUMNORDERARRAY = ($LVM_FIRST + 59)
Global Const $LVM_GETCOLUMNWIDTH = ($LVM_FIRST + 29)
Global Const $LVM_GETCOUNTPERPAGE = ($LVM_FIRST + 40)
Global Const $LVM_GETEDITCONTROL = ($LVM_FIRST + 24)
Global Const $LVM_GETEXTENDEDLISTVIEWSTYLE = ($LVM_FIRST + 55)
Global Const $LVM_GETHEADER = ($LVM_FIRST + 31)
Global Const $LVM_GETHOTCURSOR = ($LVM_FIRST + 63)
Global Const $LVM_GETHOTITEM = ($LVM_FIRST + 61)
Global Const $LVM_GETHOVERTIME = ($LVM_FIRST + 72)
Global Const $LVM_GETIMAGELIST = ($LVM_FIRST + 2)
Global Const $LVM_GETITEMA = ($LVM_FIRST + 5)
Global Const $LVM_GETITEMCOUNT = 0x1004
Global Const $LVM_GETITEMSTATE = ($LVM_FIRST + 44)
Global Const $LVM_GETNEXTITEM = 0x100c
Global Const $LVM_GETSELECTEDCOLUMN = ($LVM_FIRST + 174)
Global Const $LVM_GETSELECTEDCOUNT = ($LVM_FIRST + 50)
Global Const $LVM_GETTOPINDEX = ($LVM_FIRST + 39)
Global Const $LVM_GETUNICODEFORMAT = $CCM_GETUNICODEFORMAT
Global Const $LVM_GETVIEW = ($LVM_FIRST + 143)
Global Const $LVM_GETVIEWRECT = ($LVM_FIRST + 34)
Global Const $LVM_INSERTCOLUMNA = ($LVM_FIRST + 27)
Global Const $LVM_INSERTITEMA = ($LVM_FIRST + 7)
Global Const $LVM_REDRAWITEMS = ($LVM_FIRST + 21)
Global Const $LVM_SETUNICODEFORMAT = $CCM_SETUNICODEFORMAT
Global Const $LVM_SCROLL = ($LVM_FIRST + 20)
Global Const $LVM_SETBKCOLOR = 0x1001
Global Const $LVM_SETCALLBACKMASK = ($LVM_FIRST + 11)
Global Const $LVM_SETCOLUMNA = ($LVM_FIRST + 26)
Global Const $LVM_SETCOLUMNORDERARRAY = ($LVM_FIRST + 58)
Global Const $LVM_SETCOLUMNWIDTH = 0x101E
Global Const $LVM_SETEXTENDEDLISTVIEWSTYLE = 0x1036
Global Const $LVM_SETHOTITEM = ($LVM_FIRST + 60)
Global Const $LVM_SETHOVERTIME = ($LVM_FIRST + 71)
Global Const $LVM_SETICONSPACING = ($LVM_FIRST + 53)
Global Const $LVM_SETITEMCOUNT = ($LVM_FIRST + 47)
Global Const $LVM_SETITEMPOSITION = ($LVM_FIRST + 15)
Global Const $LVM_SETITEMSTATE = ($LVM_FIRST + 43)
Global Const $LVM_SETITEMTEXTA = ($LVM_FIRST + 46)
Global Const $LVM_SETSELECTEDCOLUMN = ($LVM_FIRST + 140)
Global Const $LVM_SETTEXTCOLOR = ($LVM_FIRST + 36)
Global Const $LVM_SETTEXTBKCOLOR = ($LVM_FIRST + 38)
Global Const $LVM_SETVIEW = ($LVM_FIRST + 142)
Global Const $LVM_UPDATE = ($LVM_FIRST + 42)

Global Const $LVNI_ABOVE = 0x100
Global Const $LVNI_BELOW = 0x200
Global Const $LVNI_TOLEFT = 0x400
Global Const $LVNI_TORIGHT = 0x800
Global Const $LVNI_ALL = 0x0
Global Const $LVNI_CUT = 0x4
Global Const $LVNI_DROPHILITED = 0x8
Global Const $LVNI_FOCUSED = 0x1
Global Const $LVNI_SELECTED = 0x2

Global Const $LVSCW_AUTOSIZE = -1
Global Const $LVSCW_AUTOSIZE_USEHEADER = -2

Global Const $LVSICF_NOINVALIDATEALL = 0x1
Global Const $LVSICF_NOSCROLL = 0x2

Global Const $LVSIL_NORMAL = 0
Global Const $LVSIL_SMALL = 1
Global Const $LVSIL_STATE = 2

; function list
;===============================================================================
; _GUICtrlListViewCopyItems
; _GUICtrlListViewDeleteAllItems
; _GUICtrlListViewDeleteColumn
; _GUICtrlListViewDeleteItem
; _GUICtrlListViewDeleteItemsSelected
; _GUICtrlListViewEnsureVisible
; _GUICtrlListViewGetBackColor
; _GUICtrlListViewGetCallBackMask
; _GUICtrlListViewGetCheckedState
; _GUICtrlListViewGetColumnOrder
; _GUICtrlListViewGetColumnWidth
; _GUICtrlListViewGetCounterPage
; _GUICtrlListViewGetCurSel
; _GUICtrlListViewGetExtendedListViewStyle
; _GUICtrlListViewGetHeader
; _GUICtrlListViewGetHotCursor
; _GUICtrlListViewGetHotItem
; _GUICtrlListViewGetHoverTime
; _GUICtrlListViewGetItemCount
; _GUICtrlListViewGetItemText
; _GUICtrlListViewGetItemTextArray
; _GUICtrlListViewGetNextItem
; _GUICtrlListViewGetSelectedCount
; _GUICtrlListViewGetSelectedIndices
; _GUICtrlListViewGetSubItemsCount
; _GUICtrlListViewGetTopIndex
; _GUICtrlListViewGetUnicodeFormat
; _GUICtrlListViewHideColumn
; _GUICtrlListViewInsertColumn
; _GUICtrlListViewInsertItem
; _GUICtrlListViewJustifyColumn
; _GUICtrlListViewScroll
; _GUICtrlListViewSetCheckState
; _GUICtrlListViewSetColumnOrder
; _GUICtrlListViewSetColumnWidth
; _GUICtrlListViewSetHotItem
; _GUICtrlListViewSetHoverTime
; _GUICtrlListViewSetItemCount
; _GUICtrlListViewSetItemSelState
; _GUICtrlListViewSetItemText
; _GUICtrlListViewSort
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlListViewCopyItems
; Parameter(s):		$h_Source_listview - controlID
;							$h_Destination_listview - control ID
;							$i_DelFlag - Delete after copying (Default: 0)
;							$s_WindowTitle - Title of window
;							$s_WindowText - Text on window
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlListViewCopyItems($h_Source_listview, $h_Destination_listview[, $i_DelFlag = 0[, $s_WindowTitle = ""[, $s_WindowText = ""]]]) Copy Items between 2 list-view controls (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewCopyItems($h_Source_listview, $h_Destination_listview, $i_DelFlag = 0, $s_WindowTitle = "", $s_WindowText = "")
	Local $a_indices, $i, $s_item, $control_ID, $items
	$items = _GUICtrlListViewGetItemCount($h_Source_listview)
	
	If BitAND(_GUICtrlListViewGetExtendedListViewStyle($h_Source_listview), $LVS_EX_CHECKBOXES) == $LVS_EX_CHECKBOXES Then
		For $i = 0 To $items - 1
			If (_GUICtrlListViewGetCheckedState($h_Source_listview, $i)) Then
				If IsArray($a_indices) Then
					ReDim $a_indices[UBound($a_indices) + 1]
				Else
					Dim $a_indices[2]
				EndIf
				$a_indices[0] = $a_indices[0] + 1
				$a_indices[UBound($a_indices) - 1] = $i
			EndIf
		Next
		
		If (IsArray($a_indices)) Then
			If (StringLen($s_WindowTitle) == 0) Then
				$s_WindowTitle = WinGetTitle("")
			EndIf
			For $i = 1 To $a_indices[0]
				$s_item = _GUICtrlListViewGetItemText($h_Source_listview, $a_indices[$i], -1, $s_WindowTitle, $s_WindowText)
				_GUICtrlListViewSetCheckState($h_Source_listview, $a_indices[$i], 0)
				GUICtrlCreateListViewItem($s_item, $h_Destination_listview)
			Next
			If $i_DelFlag Then
				For $i = $a_indices[0] To 1 Step - 1
					_GUICtrlListViewSetItemSelState($h_Source_listview, $a_indices[$i])
					$control_ID = GUICtrlRead($h_Source_listview)
					GUICtrlDelete($control_ID)
				Next
			EndIf
		EndIf
	EndIf
	If (_GUICtrlListViewGetSelectedCount($h_Source_listview)) Then
		If (StringLen($s_WindowTitle) == 0) Then
			$s_WindowTitle = WinGetTitle("")
		EndIf
		$a_indices = _GUICtrlListViewGetSelectedIndices($h_Source_listview, 1, $s_WindowTitle, $s_WindowText)
		For $i = 1 To $a_indices[0]
			$s_item = _GUICtrlListViewGetItemText($h_Source_listview, $a_indices[$i], -1, $s_WindowTitle, $s_WindowText)
			GUICtrlCreateListViewItem($s_item, $h_Destination_listview)
		Next
		ControlListView($s_WindowTitle, $s_WindowText, $h_Source_listview, "SelectClear")
		If $i_DelFlag Then
			For $i = $a_indices[0] To 1 Step - 1
				_GUICtrlListViewSetItemSelState($h_Source_listview, $a_indices[$i])
				$control_ID = GUICtrlRead($h_Source_listview)
				GUICtrlDelete($control_ID)
			Next
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListViewCopyItems

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteAllItems
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewDeleteAllItems($h_listview) Removes all items from a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewDeleteAllItems($h_listview)
	Dim $i_index, $control_ID
	For $i_index = _GUICtrlListViewGetItemCount($h_listview) - 1 To 0 Step - 1
		$control_ID = GUICtrlRead($h_listview)
		If $control_ID Then
			GUICtrlDelete($control_ID)
		EndIf
	Next
	If _GUICtrlListViewGetItemCount($h_listview) == 0 Then
		Return 1
	Else
		Return GUICtrlSendMsg($h_listview, $LVM_DELETEALLITEMS, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListViewDeleteAllItems

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteColumn
; Parameter(s):		$h_listview - controlID
;							$i_col - Index of the column to delete
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewDeleteColumn($h_listview, $i_col) Removes a column from a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				Column zero of the list-view control cannot be deleted.
;							If you must delete column zero, insert a zero length dummy
;							column zero and delete column one and above
;
;===============================================================================
Func _GUICtrlListViewDeleteColumn($h_listview, $i_col)
	Return GUICtrlSendMsg($h_listview, $LVM_DELETECOLUMN, $i_col, 0)
EndFunc   ;==>_GUICtrlListViewDeleteColumn

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteItem
; Parameter(s):		$h_listview - controlID
;							$i_index - Index of the list-view item to delete
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewDeleteItem($h_listview, $i_index) Removes an item from a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewDeleteItem($h_listview, $i_index)
	Dim $control_ID, $ID_Check
	_GUICtrlListViewSetItemSelState($h_listview, $i_index)
	$control_ID = GUICtrlRead($h_listview)
	If $control_ID Then
		GUICtrlDelete($control_ID)
		_GUICtrlListViewSetItemSelState($h_listview, $i_index)
		$ID_Check = GUICtrlRead($h_listview)
		_GUICtrlListViewSetItemSelState($h_listview, $i_index, 0)
		If $control_ID <> $ID_Check Then
			Return 1
		Else
			Return GUICtrlSendMsg($h_listview, $LVM_DELETEITEM, $i_index, 0)
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListViewDeleteItem

;===============================================================================
;
; Description:			_GUICtrlListViewDeleteItemsSelected
; Parameter(s):		$h_listview - controlID
;							$s_WindowTitle - Title of window
;							$s_WindowText - Text on window
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlListViewDeleteItemsSelected($h_listview[, $s_WindowTitle="" [, $s_WindowText=""]]) Deletes item(s) selected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				Idea from Holger
;
;===============================================================================
Func _GUICtrlListViewDeleteItemsSelected($h_listview, $s_WindowTitle = "", $s_WindowText = "")
	Local $i, $ItemCount
	If (StringLen($s_WindowTitle) == 0) Then
		$s_WindowTitle = WinGetTitle("")
	EndIf
	
	$ItemCount = _GUICtrlListViewGetItemCount($h_listview)
	If (_GUICtrlListViewGetSelectedCount($h_listview) == $ItemCount) Then
		_GUICtrlListViewDeleteAllItems($h_listview)
	Else
		Local $items = _GUICtrlListViewGetSelectedIndices($h_listview, 1, $s_WindowTitle, $s_WindowText)
		ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "SelectClear")
		For $i = $items[0] To 1 Step - 1
			ConsoleWrite($items[$i] & @LF)
			_GUICtrlListViewDeleteItem($h_listview, $items[$i])
		Next
	EndIf
EndFunc   ;==>_GUICtrlListViewDeleteItemsSelected

;===============================================================================
;
; Description:			_GUICtrlListViewEnsureVisible
; Parameter(s):		$h_listview - controlID
;							$i_index - Index of the list-view item
;							$i_bool - Value specifying whether the item must be entirely visible
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewEnsureVisible($h_listview, $i_index, $i_bool) Ensures that a list-view item is either entirely or partially visible (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				If $i_bool parameter is TRUE, no scrolling occurs if the item is at least partially visible
;
;===============================================================================
Func _GUICtrlListViewEnsureVisible($h_listview, $i_index, $i_bool)
	Return GUICtrlSendMsg($h_listview, $LVM_ENSUREVISIBLE, $i_index, $i_bool)
EndFunc   ;==>_GUICtrlListViewEnsureVisible

;===============================================================================
;
; Description:			_GUICtrlListViewGetBackColor
; Parameter(s):		$h_listview - controlID
; Requirement:			_ReverseColorOrder
; Return Value(s):	Returns the Hex RGB background color of the list-view control
; User CallTip:		_GUICtrlListViewGetBackColor($h_listview) Retrieves the background color of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetBackColor($h_listview)
	Local $v_color = GUICtrlSendMsg($h_listview, $LVM_GETBKCOLOR, 0, 0)
	Return _ReverseColorOrder($v_color)
EndFunc   ;==>_GUICtrlListViewGetBackColor

;===============================================================================
;
; Description:			_GUICtrlListViewGetCallBackMask
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the callback mask
; User CallTip:		_GUICtrlListViewGetCallBackMask($h_listview) Retrieves the callback mask for a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCallBackMask($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETCALLBACKMASK, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetCallBackMask

;===============================================================================
;
; Description:			_GUICtrlListViewGetCheckedState
; Parameter(s):		$h_listview - controlID
;							$i_index - zero-based index to retrieve item check state from
; Requirement:			$LVS_EX_CHECKBOXES used in extended style when creating listview
; Return Value(s):	Returns 1 if checked
;							Returns 0 if not checked
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewGetCheckedState($h_listview, $i_index) Returns the check state for a list-view control item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCheckedState($h_listview, $i_index)
	Local $isChecked = 0, $ret
	$ret = GUICtrlSendMsg($h_listview, $LVM_GETITEMSTATE, $i_index, $LVIS_STATEIMAGEMASK)
	If (Not $ret) Then
		$ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listview, "int", $LVM_GETITEMSTATE, "int", $i_index, "int", $LVIS_STATEIMAGEMASK)
		If ($ret[0] == -1) Then
			Return $LV_ERR
		Else
			If (BitAND($ret[0], 0x3000) == 0x3000) Then
				$isChecked = 0
			Else
				$isChecked = 1
			EndIf
		EndIf
	Else
		If (BitAND($ret, 0x2000) == 0x2000) Then
			$isChecked = 1
		EndIf
	EndIf
	Return $isChecked
EndFunc   ;==>_GUICtrlListViewGetCheckedState

;===============================================================================
;
; Description:			_GUICtrlListViewGetColumnOrder
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	"|" delimited string
;							If an error occurs, the return value is $LV_ERR.
; User CallTip:		_GUICtrlListViewGetColumnOrder($h_listview) Retrieves the current left-to-right order of columns in a list-view control. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListViewGetColumnOrder($h_listview)
	Local $i_cols = _GUICtrlListViewGetSubItemsCount($h_listview)
	Local $i, $ret
	Local $struct = ""
	For $i = 1 To $i_cols
		$struct &= "int;"
	Next
	$struct = StringTrimRight($struct, 1)
	Local $p = DllStructCreate($struct)
	If @error Then
;~ 		 MsgBox(0,"","Error in DllStructCreate " & @error);
		Return $LV_ERR
	EndIf
	$ret = GUICtrlSendMsg($h_listview, $LVM_GETCOLUMNORDERARRAY, $i_cols, DllStructGetPtr($p))
	If (Not $ret) Then
		DllStructDelete($p)
		Return $LV_ERR
	EndIf
	Local $s_cols
	For $i = 1 To $i_cols
		$s_cols &= DllStructGetData($p, $i) & "|"
	Next
	DllStructDelete($p)
	$s_cols = StringTrimRight($s_cols, 1)
	Return $s_cols
EndFunc   ;==>_GUICtrlListViewGetColumnOrder

;===============================================================================
;
; Description:			_GUICtrlListViewGetColumnWidth
; Parameter(s):		$h_listview - controlID
;							$i_col - Index of the column. This parameter is ignored in list view
; Requirement:			None
; Return Value(s):	Returns the column width if successful, or zero otherwise
; User CallTip:		_GUICtrlListViewGetColumnWidth($h_listview, $i_col) Retrieves the width of a column in report or list view (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				If this message is sent to a list-view control with the LVS_REPORT style
;							and the specified column doesn't exist, the return value is undefined
;
;===============================================================================
Func _GUICtrlListViewGetColumnWidth($h_listview, $i_col)
	Return GUICtrlSendMsg($h_listview, $LVM_GETCOLUMNWIDTH, $i_col, 0)
EndFunc   ;==>_GUICtrlListViewGetColumnWidth

;===============================================================================
;
; Description:			_GUICtrlListViewGetCounterPage
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the number of fully visible items if successful.
;							If the current view is icon or small icon view, the return value
;							is the total number of items in the list-view control.
; User CallTip:		_GUICtrlListViewGetCounterPage($h_listview) Calculates the number of items that can fit vertically in the visible area of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCounterPage($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETCOUNTPERPAGE, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetCounterPage

;===============================================================================
;
; Description:			_GUICtrlListViewGetCurSel
; Parameter(s):		$h_listview - controlID
;							$s_WindowTitle - Windows Title
;							$s_WindowText - Text from window
; Requirement:			None
; Return Value(s):	Index of current selection (zero-based index)
;							returns $LV_ERR if error
; User CallTip:		_GUICtrlListViewGetCurSel($h_listview[, $h_WindowTitle=""[, $s_WindowText=""]]) Retrieve the index of current selection (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetCurSel($h_listview, $s_WindowTitle = "", $s_WindowText = "")
	If (StringLen($s_WindowTitle) == 0) Then
		$s_WindowTitle = WinGetTitle("")
	EndIf
	If (StringLen(ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected")) > 0) Then
		Return Int(ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected", 0))
	Else
		Return $LV_ERR
	EndIf
EndFunc   ;==>_GUICtrlListViewGetCurSel

;===============================================================================
;
; Description:			_GUICtrlListViewGetExtendedListViewStyle
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns a DWORD that represents the styles currently in use for a given list-view control.
;							This value can be a combination of Extended List-View Styles
; User CallTip:		_GUICtrlListViewGetExtendedListViewStyle($h_listview) Retrieves the extended styles that are currently in use for a given list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetExtendedListViewStyle($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetExtendedListViewStyle

;===============================================================================
;
; Description:			_GUICtrlListViewGetHeader
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the handle to the header control.
; User CallTip:		_GUICtrlListViewGetHeader($h_listview) Retrieves the handle to the header control used by the list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetHeader($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETHEADER, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetHeader

;===============================================================================
;
; Description:			_GUICtrlListViewGetHotCursor
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns an HCURSOR value that is the handle to the cursor that
;							the list-view control uses when hot tracking is enabled.
; User CallTip:		_GUICtrlListViewGetHotCursor($h_listview) Retrieves the HCURSOR value used when the pointer is over an item while hot tracking is enabled (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				A list-view control uses hot tracking and hover selection when
;							the LVS_EX_TRACKSELECT style is set.
;
;===============================================================================
Func _GUICtrlListViewGetHotCursor($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETHOTCURSOR, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetHotCursor

;===============================================================================
;
; Description:			_GUICtrlListViewGetHotItem
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the index of the item that is hot.
; User CallTip:		_GUICtrlListViewGetHotItem($h_listview) Retrieves the index of the hot item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetHotItem($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETHOTITEM, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetHotItem

;===============================================================================
;
; Description:			_GUICtrlListViewGetHoverTime
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the amount of time, in milliseconds,
;							that the mouse cursor must hover over an item
;							before it is selected.
;							If the return value is -1, then the hover
;							time is the default hover time.
; User CallTip:		_GUICtrlListViewGetHoverTime($h_listview) Retrieves the amount of time that the mouse cursor must hover over an item before it is selected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				The hover time only affects list-view controls that have the
;							LVS_EX_TRACKSELECT, LVS_EX_ONECLICKACTIVATE, or
;							LVS_EX_TWOCLICKACTIVATE extended list-view style.
;
;===============================================================================
Func _GUICtrlListViewGetHoverTime($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETHOVERTIME, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetHoverTime

;===============================================================================
;
; Description:			_GUICtrlListViewGetItemCount
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the number of items.
; User CallTip:		_GUICtrlListViewGetItemCount($h_listview) Retrieves the number of items in a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetItemCount($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETITEMCOUNT, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetItemCount

;===============================================================================
;
; Description:			_GUICtrlListViewGetItemText
; Parameter(s):		$h_listview - controlID
;							$i_Item - index of item to retrieve from (zero-based index)
;							$i_SubItem - column of item to retrieve from (zero-based index)
;							$s_WindowTitle - Window title
;							$s_WindowText - string to match on windows, helps locate proper window handle
; Requirement:			None
; Return Value(s):	If $i_SubItem = -1 then row is returned pipe delimited
;							else text from $i_SubItem position is returned
;							If $i_Item = -1 current selection is used
;							If error $LV_ERR is returned
; User CallTip:		_GUICtrlListViewGetItemText($h_listview[, $i_Item=-1[, $i_SubItem=-1[, $h_WindowTitle=""[, $h_WindowText=""]]]]) Retrieves some or all of a list-view item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetItemText($h_listview, $i_Item = -1, $i_SubItem = -1, $s_WindowTitle = "", $s_WindowText = "")
	Local $X, $count, $str
	If (StringLen($s_WindowTitle) == 0) Then
		$s_WindowTitle = WinGetTitle("")
	EndIf
	
	$count = _GUICtrlListViewGetSubItemsCount($h_listview, $s_WindowTitle, $s_WindowText)
	
	If ($i_Item <> - 1) Then
		If ($i_SubItem == -1) Then; return all the subitems in the item selected
			For $X = 0 To $count - 1 Step 1
				If ($str) Then
					$str = $str & "|" & ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $X)
				Else
					$str = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $X)
				EndIf
			Next
			Return $str
		ElseIf ($i_SubItem < $count) Then; return the subitem in the item selected
			Return ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $i_SubItem)
		Else
			; subitem is out of range
			Return $LV_ERR
		EndIf
	ElseIf (_GUICtrlListViewGetSelectedCount($h_listview) > 0) Then
		If ($i_SubItem == -1) Then; return all the subitems in the item selected
			For $X = 0 To $count - 1 Step 1
				If ($str) Then
					If ($i_Item == -1) Then
						$str = $str & "|" & ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected"), $X)
					Else
						$str = $str & "|" & ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $X)
					EndIf
				Else
					If ($i_Item == -1) Then
						$str = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected"), $X)
					Else
						$str = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $X)
					EndIf
				EndIf
			Next
			Return $str
		ElseIf ($i_SubItem < $count) Then; return the subitem in the item selected
			If ($i_Item == -1) Then
				Return ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected"), $i_SubItem)
			Else
				Return ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $i_SubItem)
			EndIf
		Else
			; subitem is out of range
			Return $LV_ERR
		EndIf
	Else
		; item out of range or nothing selected
		Return $LV_ERR
	EndIf
EndFunc   ;==>_GUICtrlListViewGetItemText

;===============================================================================
;
; Description:			_GUICtrlListViewGetItemTextArray
; Parameter(s):		$h_listview - controlID
;							$i_Item - index of item to retrieve from (zero-based index)
;							$s_WindowTitle - Window title
;							$s_WindowText - string to match on windows, helps locate proper window handle
; Requirement:			None
; Return Value(s):	Returns an array of the subitems
;							If $i_Item = -1 current selection is used
;							If error $LV_ERR is returned
; User CallTip:		_GUICtrlListViewGetItemTextA($h_listview[, $i_Item=-1[, $s_WindowTitle=""[, $s_WindowText=""]]]) Retrieves all of a list-view item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetItemTextArray($h_listview, $i_Item = -1, $s_WindowTitle = "", $s_WindowText = "")
	Local $X, $count, $str
	If (StringLen($s_WindowTitle) == 0) Then
		$s_WindowTitle = WinGetTitle("")
	EndIf
	
	$count = _GUICtrlListViewGetSubItemsCount($h_listview, $s_WindowTitle, $s_WindowText)
	
	If ($i_Item <> - 1) Then
		For $X = 0 To $count - 1 Step 1
			If ($str) Then
				$str = $str & "|" & ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $X)
			Else
				$str = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", $i_Item, $X)
			EndIf
		Next
		Return StringSplit($str, "|")
	ElseIf (_GUICtrlListViewGetSelectedCount($h_listview) > 0) Then
		For $X = 0 To $count - 1 Step 1
			If ($str) Then
				If ($i_Item == -1) Then
					$str = $str & "|" & ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected"), $X)
				Else
					$str = $str & "|" & ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected"), $X)
				EndIf
			Else
				If ($i_Item == -1) Then
					$str = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected"), $X)
				Else
					$str = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetText", ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected"), $X)
				EndIf
			EndIf
		Next
		Return StringSplit($str, "|")
	Else
		; item out of range or nothing selected
		Return $LV_ERR
	EndIf
EndFunc   ;==>_GUICtrlListViewGetItemTextArray

;===============================================================================
;
; Description:			_GUICtrlListViewGetNextItem
; Parameter(s):		$h_GUI - GUI Window handle
;							$h_listview - controlID
;							$i_index - Index of the item to begin the search with
;							$i_direction - Specifies the relationship to the item specified in $i_index
; Requirement:			None
; Return Value(s):	Returns the index of the next item if successful, or $LV_ERR otherwise.
; User CallTip:		_GUICtrlListViewGetNextItem($h_GUI, $h_listview[, $i_index=-1[, $i_direction=0x0]]) Returns the index of the next item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				If $i_index = -1 then find the first item that matches the specified $i_direction.
;							The specified item itself is excluded from the search.
;
;							$i_direction
;								Searches by index.
;									$LVNI_ALL
;										Searches for a subsequent item by index, the default value.
;								Searches by physical relationship to the index of the item where the search is to begin.
;									$LVNI_ABOVE
;										Searches for an item that is above the specified item.
;									$LVNI_BELOW
;										Searches for an item that is below the specified item.
;									$LVNI_TOLEFT
;										Searches for an item to the left of the specified item.
;									$LVNI_TORIGHT
;										Searches for an item to the right of the specified item.
;
;===============================================================================
Func _GUICtrlListViewGetNextItem($h_GUI, $h_listview, $i_index = -1, $i_direction = 0x0)
	Local $ret
	Local $h_lv = ControlGetHandle($h_GUI, "", $h_listview)
	If ($i_direction == $LVNI_ALL Or $i_direction == $LVNI_ABOVE Or _
			$i_direction == $LVNI_BELOW Or $i_direction == $LVNI_TOLEFT Or _
			$i_direction == $LVNI_TORIGHT) Then
		$ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_lv, "int", $LVM_GETNEXTITEM, "int", $i_index, "int", $i_direction)
		Return $ret[0]
	Else
		Return $LV_ERR
	EndIf
EndFunc   ;==>_GUICtrlListViewGetNextItem
;~ Func _GUICtrlListViewGetNextItem($h_listview, $i_index = -1, $i_direction = 0x0)
;~ 	Local $ret
;~ 	If ($i_direction == $LVNI_ALL Or $i_direction == $LVNI_ABOVE Or _
;~ 			$i_direction == $LVNI_BELOW Or $i_direction == $LVNI_TOLEFT Or _
;~ 			$i_direction == $LVNI_TORIGHT) Then
;~ 		return = GUICtrlSendMsg($h_listview, $LVM_GETNEXTITEM, $i_index, $i_direction)
;~ 	Else
;~ 		Return $LV_ERR
;~ 	EndIf
;~ EndFunc   ;==>_GUICtrlListViewGetNextItem

;===============================================================================
;
; Description:			_GUICtrlListViewGetSelectedCount
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the number of selected items
; User CallTip:		_GUICtrlListViewGetSelectedCount($h_listview) Determines the number of selected items in a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetSelectedCount($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETSELECTEDCOUNT, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetSelectedCount

;===============================================================================
;
; Description:			_GUICtrlListViewGetSelectedIndices
; Parameter(s):		$h_listview - controlID
;							$i_ReturnType - Optional: return a string or array
;							$s_WindowTitle - Optional: Window Title
;							$s_WindowText - Optional: Window Text
; Requirement:			None
; Return Value(s):	If $i_ReturnType = 0 then Return pipe delimited string of indices of selected item(s)
;							If $i_ReturnType = 1 then Return array of indices of selected item(s)
;							If no items selected return $LV_ERR
; User CallTip:		_GUICtrlListViewGetSelectedIndices($h_listview[, $i_ReturnType=0[, $s_WindowTitle = ""[, $s_WindowText = ""]]])) Retrieve indices of selected item(s) in a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetSelectedIndices($h_listview, $i_ReturnType = 0, $s_WindowTitle = "", $s_WindowText = "")
	If (StringLen($s_WindowTitle) == 0) Then
		$s_WindowTitle = WinGetTitle("")
	EndIf
	
	If (Not $i_ReturnType) Then
		Local $s_indices = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected", 1)
		If (StringLen($s_indices) > 0) Then
			Return $s_indices
		Else
			Return $LV_ERR
		EndIf
	Else
		Local $a_indices = ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSelected", 1)
		If (StringLen($a_indices) > 0) Then
			$a_indices = StringSplit($a_indices, "|")
			If (IsArray($a_indices)) Then
				Local $i
				For $i = 1 To $a_indices[0]
					$a_indices[$i] = Int($a_indices[$i])
				Next
				Return $a_indices
			Else
				Return $LV_ERR
			EndIf
		Else
			Return $LV_ERR
		EndIf
	EndIf
EndFunc   ;==>_GUICtrlListViewGetSelectedIndices

;===============================================================================
;
; Description:			_GUICtrlListViewGetSubItemsCount
; Parameter(s):		$h_listview - controlID
;							$s_WindowTitle - Optional: Window Title
;							$s_WindowText - Optional: Window Text
; Requirement:			None
; Return Value(s):	Number of columns
; User CallTip:		_GUICtrlListViewGetSubItemsCount(ByRef $h_listview[, $s_WindowTitle=""[, $s_WindowText=""]]) Retrieve the number of columns (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetSubItemsCount(ByRef $h_listview, $s_WindowTitle = "", $s_WindowText = "")
	If (StringLen($s_WindowTitle) == 0) Then
		$s_WindowTitle = WinGetTitle("")
	EndIf
	Return Int(ControlListView($s_WindowTitle, $s_WindowText, $h_listview, "GetSubItemCount"))
EndFunc   ;==>_GUICtrlListViewGetSubItemsCount

;===============================================================================
;
; Description:			_GUICtrlListViewGetTopIndex
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns the index of the item if successful
;							zero if the list-view control is in icon or small icon view.
; User CallTip:		_GUICtrlListViewGetTopIndex($h_listview) Retrieves the index of the topmost visible item when in list or report view (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewGetTopIndex($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETTOPINDEX, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetTopIndex
;===============================================================================
;
; Description:			_GUICtrlListViewGetUnicodeFormat
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	If this value is nonzero, the control is using Unicode characters.
;							If this value is zero, the control is using ANSI characters.
; User CallTip:		_GUICtrlListViewGetUnicodeFormat($h_listview) Retrieves the UNICODE character format flag for the control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				The Unicode format flag is used by Microsoft Windows NT systems
;							with version 4.71 of Comctl32.dll or later. This message is, thus,
;							supported by Windows 2000 and later, and by Windows NT 4 with Microsoft
;							Internet Explorer 4.0 or later. It is only useful on Windows 95 or Windows 98
;							systems with version 5.80 or later of Comctl32.dll.
;
;							This means that they must have Internet Explorer 5 or later installed.
;							Windows 95 and Windows 98 systems with earlier versions of Internet Explorer
;							ignore the Unicode format flag, and its value has no bearing on whether a control
;							supports Unicode. With these systems, you will instead need to test something that
;							requires Unicode support.
;
;===============================================================================
Func _GUICtrlListViewGetUnicodeFormat($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETUNICODEFORMAT, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetUnicodeFormat

;===============================================================================
;
; Description:			_GUICtrlListViewGetView
; Parameter(s):		$h_listview - controlID
; Requirement:			None
; Return Value(s):	Returns a DWORD that specifies the current view
; User CallTip:		_GUICtrlListViewGetView($h_listview) Retrieves the current view of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				Following are the values for views.
;								$LV_VIEW_DETAILS
;								$LV_VIEW_ICON
;								$LV_VIEW_LIST
;								$LV_VIEW_SMALLICON
;								$LV_VIEW_TILE
;
;===============================================================================
Func _GUICtrlListViewGetView($h_listview)
	Return GUICtrlSendMsg($h_listview, $LVM_GETVIEW, 0, 0)
EndFunc   ;==>_GUICtrlListViewGetView

;===============================================================================
;
; Description:				_GUICtrlListViewHideColumn
; Parameter(s):			$h_listview - controlID
;								$i_col - column to hide (set width to zero)
; Requirement:				None
; Return Value(s):		Returns TRUE if successful, or FALSE otherwise
; User CallTip:			_GUICtrlListViewHideColumn($h_listview,$i_col) Hides the column "sets column width to zero" (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs@charter.net)
; Note(s):              Idea from Holger
;
;===============================================================================
Func _GUICtrlListViewHideColumn($h_listview, $i_col)
	GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNWIDTH, $i_col, 0)
EndFunc   ;==>_GUICtrlListViewHideColumn

;===============================================================================
;
; Description:				_GUICtrlListViewInsertColumn
; Parameter(s):			$h_listview - controlID
;								$i_col - Zero based index of column position to insert
;								$s_text - Header Text for column
;								$i_justification - Optional: type of justification for column
;								$i_width - Optional: width of the new column
; Requirement:				None
; Return Value(s):		Returns TRUE if successful, or FALSE otherwise
;								if error then $LV_ERR is returned
; User CallTip:			_GUICtrlListViewInsertColumn($h_listview, $i_col, $s_text[, $i_justification=0[, $i_width=25]]) Inserts a column into a list-view control (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs@charter.net)
; Note(s):              $i_justification
;									0 = Left (default)
;									1 = Right
;									2 = Center
;
;===============================================================================
Func _GUICtrlListViewInsertColumn($h_listview, $i_col, $s_text, $i_justification = 0, $i_width = 25)
	Local $struct = "uint;int;int;ptr;int;int;int;int", $p, $sp
	$p = DllStructCreate($struct)
	If @error Then
		Return $LV_ERR
	EndIf
	$sp = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then
		DllStructDelete($p)
		Return $LV_ERR
	EndIf
	DllStructSetData($sp, 1, $s_text)
	DllStructSetData($p, 1, BitOR($LVCF_WIDTH, $LVCF_FMT, $LVCF_TEXT))
	If ($i_justification == 1) Then
		DllStructSetData($p, 2, $LVCFMT_RIGHT)
	ElseIf ($i_justification == 2) Then
		DllStructSetData($p, 2, $LVCFMT_CENTER)
	Else
		DllStructSetData($p, 2, $LVCFMT_LEFT)
	EndIf
	DllStructSetData($p, 3, $i_width)
	DllStructSetData($p, 4, DllStructGetPtr($sp))
	
	Local $ret = GUICtrlSendMsg($h_listview, $LVM_INSERTCOLUMNA, $i_col, DllStructGetPtr($p))
	DllStructDelete($p)
	DllStructDelete($sp)
	Return $ret
EndFunc   ;==>_GUICtrlListViewInsertColumn

;===============================================================================
;
; Description:				_GUICtrlListViewInsertItem
; Parameter(s):			$h_listview - controlID
;								$i_index - Zero based index of position to insert
;								$s_text - text for the new item
; Requirement:				None
; Return Value(s):		Returns the index of the new item if successful, or $LV_ERR otherwise
; User CallTip:			_GUICtrlListViewInsertItem($h_listview, $i_index, $s_text) Inserts a new item in a list-view control. (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs@charter.net)
; Note(s):              $s_text is "|" delimited text
;
;===============================================================================
Func _GUICtrlListViewInsertItem($h_listview, $i_index, $s_text)
	Local $struct = "int;int;int;int;int;ptr;int;int;int;int;int;ptr", $p, $sp
	$p = DllStructCreate($struct)
	If @error Then
		Return $LV_ERR
	EndIf
	$sp = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then
		DllStructDelete($p)
		Return $LV_ERR
	EndIf
	Local $a_text = StringSplit($s_text, "|")
	DllStructSetData($sp, 1, $a_text[1])
	DllStructSetData($p, 1, $LVIF_TEXT)
	DllStructSetData($p, 2, $i_index)
	DllStructSetData($p, 6, DllStructGetPtr($sp))
	Local $ret = GUICtrlSendMsg($h_listview, $LVM_INSERTITEMA, 0, DllStructGetPtr($p))
	DllStructDelete($p)
	DllStructDelete($sp)
	Local $i
	For $i = 2 To $a_text[0]
		_GUICtrlListViewSetItemText($h_listview, $i_index, $i - 1, $a_text[$i])
	Next
	Return $ret
EndFunc   ;==>_GUICtrlListViewInsertItem

;===============================================================================
;
; Description:				_GUICtrlListViewJustifyColumn
; Parameter(s):			$h_listview - controlID
;								$i_col - Zero based index of column Justify
;								$i_justification - Optional: type of justification for column
; Requirement:				None
; Return Value(s):		Returns TRUE if successful, or FALSE otherwise
;								if error then $LV_ERR is returned
; User CallTip:			_GUICtrlListViewJustifyColumn($h_listview, $i_col[, $i_justification=0]) Set Justification of a column for a list-view control (required: <GuiListView.au3>)
; Author(s):				Gary Frost (custompcs@charter.net)
; Note(s):              $i_justification
;									0 = Left (default)
;									1 = Right
;									2 = Center
;
;===============================================================================
Func _GUICtrlListViewJustifyColumn($h_listview, $i_col, $i_justification = 0)
	Local $struct = "uint;int;int;ptr;int;int;int;int", $p
	$p = DllStructCreate($struct)
	If @error Then
		Return $LV_ERR
	EndIf
	DllStructSetData($p, 1, $LVCF_FMT)
	If ($i_justification == 1) Then
		DllStructSetData($p, 2, $LVCFMT_RIGHT)
	ElseIf ($i_justification == 2) Then
		DllStructSetData($p, 2, $LVCFMT_CENTER)
	Else
		DllStructSetData($p, 2, $LVCFMT_LEFT)
	EndIf
	Local $ret = GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNA, $i_col, DllStructGetPtr($p))
	DllStructDelete($p)
	Return $ret
EndFunc   ;==>_GUICtrlListViewJustifyColumn

;===============================================================================
;
; Description:			_GUICtrlListViewScroll
; Parameter(s):		$h_listview - controlID
;							$i_dx - Value of type int that specifies the amount of horizontal scrolling in pixels.
;									  If the list-view control is in list-view, this value specifies the number of columns to scroll
;							$i_dy - Value of type int that specifies the amount of vertical scrolling in pixels
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewScroll($h_listview, $i_dx, $i_dy) Scrolls the content of a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				When the list-view control is in report view, the control can
;							only be scrolled vertically in whole line increments.
;
;							Therefore, the $i_dy parameter will be rounded to the nearest number
;							of pixels that form a whole line increment.
;
;							For example, if the height of a line is 16 pixels and 8 is passed for $i_dy,
;							the list will be scrolled by 16 pixels (1 line). If 7 is passed for $i_dy,
;							the list will be scrolled 0 pixels (0 lines).
;
;===============================================================================
Func _GUICtrlListViewScroll($h_listview, $i_dx, $i_dy)
	Return GUICtrlSendMsg($h_listview, $LVM_SCROLL, $i_dx, $i_dy)
EndFunc   ;==>_GUICtrlListViewScroll

;===============================================================================
;
; Description:			_GUICtrlListViewSetCheckState
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero-based index of the item
;							$i_check - Optional: value to set checked state to (1 = checked, 0 = not checked)
; Requirement:			None.
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewSetCheckState($h_listview, $i_index[, $i_check = 1]) Sets the checked state of a list-view control item (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				$i_index = -1 sets all items
;							$i_check = 1 (default)
;
;===============================================================================
Func _GUICtrlListViewSetCheckState($h_listview, $i_index, $i_check = 1)
	Local $struct = "int;int;int;int;int;ptr;int;int;int;int;int;ptr", $ret
	Local $p = DllStructCreate($struct)
	If @error Then
		Return $LV_ERR
	EndIf
	DllStructSetData($p, 1, $LVIF_STATE)
	DllStructSetData($p, 2, $i_index)
	If ($i_check) Then
		DllStructSetData($p, 4, 0x2000)
	Else
		DllStructSetData($p, 4, 0x1000)
	EndIf
	DllStructSetData($p, 5, $LVIS_STATEIMAGEMASK)
	$ret = GUICtrlSendMsg($h_listview, $LVM_SETITEMSTATE, $i_index, DllStructGetPtr($p))
	DllStructDelete($p)
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetCheckState

;===============================================================================
;
; Description:			_GUICtrlListViewSetColumnOrder
; Parameter(s):		$h_listview - controlID
;							$s_order - "|" delimited column order .i.e "2|0|3|1"
; Requirement:			None
; Return Value(s):	Returns nonzero if successful, or zero otherwise.
;							If an error occurs, the return value is $LV_ERR.
; User CallTip:		_GUICtrlListViewSetColumnOrder($h_listview, $s_order) Sets the left-to-right order of columns in a list-view control. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):           Columns are zero-based
;
;===============================================================================
Func _GUICtrlListViewSetColumnOrder($h_listview, $s_order)
	Local $i, $ret
	Local $struct = ""
	Local $a_order = StringSplit($s_order, "|")
	For $i = 1 To $a_order[0]
		$struct &= "int;"
	Next
	$struct = StringTrimRight($struct, 1)
	Local $p = DllStructCreate($struct)
	For $i = 1 To $a_order[0]
		DllStructSetData($p, $i, $a_order[$i])
	Next
	If @error Then
		Return $LV_ERR
	EndIf
	$ret = GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNORDERARRAY, $a_order[0], DllStructGetPtr($p))
	If (Not $ret) Then
		DllStructDelete($p)
		Return $LV_ERR
	EndIf
	DllStructDelete($p)
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetColumnOrder

;===============================================================================
;
; Description:			_GUICtrlListViewSetColumnWidth
; Parameter(s):		$h_listview - controlID
;							$i_col - Zero-based index of a valid column. For list-view mode, this parameter must be set to zero
;							$i_width - New width of the column, in pixels.
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewSetColumnWidth($h_listview, $i_col, $i_width) Changes the width of a column (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				For list-view mode, this parameter must be set to zero
;
;							$i_width
;								New width of the column, in pixels. For report-view mode, the following special values are supported:
;									$LVSCW_AUTOSIZE
;										Automatically sizes the column.
;									$LVSCW_AUTOSIZE_USEHEADER
;										Automatically sizes the column to fit the header text.
;										If you use this value with the last column, its width
;										is set to fill the remaining width of the list-view control
;
;===============================================================================
Func _GUICtrlListViewSetColumnWidth($h_listview, $i_col, $i_width)
	Return GUICtrlSendMsg($h_listview, $LVM_SETCOLUMNWIDTH, $i_col, $i_width)
EndFunc   ;==>_GUICtrlListViewSetColumnWidth

;===============================================================================
;
; Description:			_GUICtrlListViewSetHotItem
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero-based index of the item to be set as the hot item
; Requirement:			None
; Return Value(s):	Returns the index of the item that was previously hot
;							$LV_ERR is returned if no item previously hot
; User CallTip:		_GUICtrlListViewSetHotItem($h_listview, $i_index) Sets the hot item for a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewSetHotItem($h_listview, $i_index)
	Return GUICtrlSendMsg($h_listview, $LVM_SETHOTITEM, $i_index, 0)
EndFunc   ;==>_GUICtrlListViewSetHotItem

;===============================================================================
;
; Description:			_GUICtrlListViewSetHoverTime
; Parameter(s):		$h_listview - controlID
;							$i_time - The new amount of time, in milliseconds
; Requirement:			None
; Return Value(s):	Returns the previous hover time
; User CallTip:		_GUICtrlListViewSetHoverTime($h_listview, $i_time) Sets the amount of time which the mouse cursor must hover over an item before it is selected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				$i_time
;								If this value is -1, then the hover time is set to the default hover time
;
;							The hover time only affects list-view controls that have the
;							LVS_EX_TRACKSELECT, LVS_EX_ONECLICKACTIVATE, or
;							LVS_EX_TWOCLICKACTIVATE extended list-view style
;
;===============================================================================
Func _GUICtrlListViewSetHoverTime($h_listview, $i_time)
	Return GUICtrlSendMsg($h_listview, $LVM_SETHOVERTIME, 0, $i_time)
EndFunc   ;==>_GUICtrlListViewSetHoverTime

;===============================================================================
;
; Description:			_GUICtrlListViewSetItemCount
; Parameter(s):		$h_listview - controlID
;							$i_items - Number of items that the list-view control will ultimately contain.
; Requirement:			None
; Return Value(s):	Returns nonzero if successful, or zero otherwise.
; User CallTip:		_GuiCtrlListViewSetItemCount($h_listview, $i_items) Causes the list-view control to allocate memory for the specified number of items. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				Causes the control to allocate its internal data structures for the specified number of items.
;							This prevents the control from having to allocate the data structures every time an item is added.
;
;===============================================================================
Func _GUICtrlListViewSetItemCount($h_listview, $i_items)
	Return GUICtrlSendMsg($h_listview, $LVM_SETITEMCOUNT, $i_items, BitOR($LVSICF_NOINVALIDATEALL, $LVSICF_NOSCROLL))
EndFunc   ;==>_GUICtrlListViewSetItemCount

;===============================================================================
;
; Description:			_GUICtrlListViewSetItemSelState
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero based index of the item
;							$i_selected - Optional: set the state of the item (1 = selected, 0 = not selected)
; Requirement:			None
; Return Value(s):	1 if successful, 0 otherwise
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewSetItemSelState($h_listview, $i_index[, $i_selected = 1]) Sets the Item Selected/UnSelected (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				$i_index = -1 sets all items for MultiSelect ListView
;
;===============================================================================
Func _GUICtrlListViewSetItemSelState($h_listview, $i_index, $i_selected = 1)
	Local $struct = "int;int;int;int;int;ptr;int;int;int;int;int;ptr", $ret
	Local $p = DllStructCreate($struct)
	If @error Then
		Return $LV_ERR
	EndIf
	If ($i_selected == 1) Then
		$i_selected = $LVNI_SELECTED
	Else
		$i_selected = 0
	EndIf
	DllStructSetData($p, 1, $LVIF_STATE)
	DllStructSetData($p, 2, $i_index)
	DllStructSetData($p, 4, $i_selected)
	DllStructSetData($p, 5, $LVIS_SELECTED)
	$ret = GUICtrlSendMsg($h_listview, $LVM_SETITEMSTATE, $i_index, DllStructGetPtr($p))
	DllStructDelete($p)
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetItemSelState

;===============================================================================
;
; Description:			_GUICtrlListViewSetItemText
; Parameter(s):		$h_listview - controlID
;							$i_index - Zero based index of the item
;							$i_subitem - Index of the subitem, or it can be zero to set the item label.
;							$s_text - String containing the new text
; Requirement:			None
; Return Value(s):	1 if successful, 0 if not
;							If error then $LV_ERR is returned
; User CallTip:		_GUICtrlListViewSetItemText($h_listview, $i_index, $i_subitem, $s_text) Changes the text of a list-view item or subitem. (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListViewSetItemText($h_listview, $i_index, $i_SubItem, $s_text)
	Local $struct = "int;int;int;int;int;ptr;int;int;int;int;int;ptr", $ret
	Local $p = DllStructCreate($struct)
	If @error Then
		Return $LV_ERR
	EndIf
	Local $sp = DllStructCreate("char[" & StringLen($s_text) + 1 & "]")
	If @error Then
		DllStructDelete($p)
		Return $LV_ERR
	EndIf
	DllStructSetData($sp, 1, $s_text)
	DllStructSetData($p, 1, $LVIF_TEXT)
	DllStructSetData($p, 2, $i_index)
	DllStructSetData($p, 3, $i_SubItem)
	DllStructSetData($p, 6, DllStructGetPtr($sp))
	$ret = GUICtrlSendMsg($h_listview, $LVM_SETITEMTEXTA, $i_index, DllStructGetPtr($p))
	DllStructDelete($p)
	DllStructDelete($sp)
	Return $ret
EndFunc   ;==>_GUICtrlListViewSetItemText

;===============================================================================
;
; Description:			_GUICtrlListViewSetSelectedColumn
; Parameter(s):		$h_listview - controlID
;							$i_col - Value of type int that specifies the column index
; Requirement:			None
; Return Value(s):	Returns TRUE if successful, or FALSE otherwise
; User CallTip:		_GUICtrlListViewSetSelectedColumn($h_listview, $i_col) Sets the index of the selected column (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				The column indices are stored in an int array
;
;===============================================================================
Func _GUICtrlListViewSetSelectedColumn($h_listview, $i_col)
	Return GUICtrlSendMsg($h_listview, $LVM_SETSELECTEDCOLUMN, $i_col, 0)
EndFunc   ;==>_GUICtrlListViewSetSelectedColumn

#include <Array.au3>
;===============================================================================
;
; Description:			_GUICtrlListViewSort
; Parameter(s):		$h_listview - controlID
;                   	$v_descending	- boolean value, can be a single value or array
;                   	$i_sortcol		- column to sort on
;                   	$s_Title			- Optional: Window title
;                   	$s_Text			- Optional: Window text
; Requirement:			Array.au3
; Return Value(s):	None
; User CallTip:		_GUICtrlListViewSort(ByRef $h_listview, ByRef $v_descending, $i_sortcol[, $s_Title = ""[, $s_Text = ""]]) Sorts a list-view control (required: <GuiListView.au3>)
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				:
;
;===============================================================================
Func _GUICtrlListViewSort(ByRef $h_listview, ByRef $v_descending, $i_sortcol, $s_Title = "", $s_text = "", $event = "")
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
                Local $items = GUICtrlCreateListViewItem($temp_item, $h_listview)
				If IsDeclared ( "event" ) Then
					GuiCtrlSetOnEvent($items, $event)
				EndIf
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
                GUICtrlCreateListViewItem(" ", $h_listview)
				Local $items = GUICtrlCreateListViewItem(" ", $h_listview)
				If IsDeclared ( "event" ) Then
					GuiCtrlSetOnEvent($items, $event)
				EndIf
				_GUICtrlListViewSetItemText($h_listview, $X, 0, $a_lv[$X])
            Next
        EndIf
        If (IsArray($v_descending)) Then
            $v_descending[$i_sortcol] = Not $b_desc
        Else
            $v_descending = Not $b_desc
        EndIf
    EndIf
EndFunc  ;==>_GUICtrlListViewSort



;===============================================================================
; the following functions are for internal use or possibly new functions as
; of yet not released
;===============================================================================

;===============================================================================
;
; Description:			_ReverseColorOrder
; Parameter(s):		$v_color - Hex Color
; Requirement:			None
; Return Value(s):	Return Hex RGB or BGR Color
; User CallTip:		_ReverseColorOder($v_color) Convert Hex RGB or BGR Color to Hex RGB or BGR Color
; Author(s):			Gary Frost (custompcs@charter.net)
; Note(s):				Used for getting List view colors
;
;===============================================================================
Func _ReverseColorOrder($v_color)
	Dim $tc = Hex(String($v_color), 6)
	Return '0x' & StringMid($tc, 5, 2) & StringMid($tc, 3, 2) & StringMid($tc, 1, 2)
EndFunc   ;==>_ReverseColorOrder

;===============================================================================
;===============================================================================
Func _GUICtrlListViewArrange($h_listview, $arrange)
	Return GUICtrlSendMsg($h_listview, $LVM_ARRANGE, $arrange, 0)
EndFunc   ;==>_GUICtrlListViewArrange

;===============================================================================
;===============================================================================
Func _GUICtrlListViewSetIconSpacing($h_listview, $i_cx, $i_cy)
	Return GUICtrlSendMsg($h_listview, $LVM_SETICONSPACING, 0, $i_cx * 65536 + $i_cy)
EndFunc   ;==>_GUICtrlListViewSetIconSpacing

;===============================================================================
;===============================================================================
Func _GUICtrlListViewSetItemPosition($h_listview, $i_index, $i_x, $i_y)
	Return GUICtrlSendMsg($h_listview, $LVM_SETITEMPOSITION, $i_index, $i_x * 65536 + $i_y)
EndFunc   ;==>_GUICtrlListViewSetItemPosition
