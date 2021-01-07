;===============================================================================
;
; Description:		_TreeViewGetItemState
; Parameter(s):		$h_treeview - control handle -> ControlGetHandle()
;					$h_item - item handle -> TVM_GETNEXTITEM
; Requirement:		None
; Return Value(s):	Returns state of item
;					Returns 0 and sets @error if it fails
; User CallTip:		_TreeViewGetItemState($h_treeview, $h_item) Retrieve the item state by sending a right item handle (required: <GuiTreeView.au3>)
; Author(s):		Zedna
; Note(s):			checked state: BitAND($state, $TVIS_STATEIMAGEMASK) = 0x2000 
;					unchecked=0x1000 checked=0x2000
;
;===============================================================================
Func _TreeViewGetItemState($h_treeview, $h_item)
	Dim $state = 0, $TVITEM_struct, $ret
	$TVITEM_struct = DllStructCreate("uint;int;uint;uint;ptr;int;int;int;int;int")
	If @error Then
		SetError(1)
		Return $state
	EndIf
	
	DllStructSetData($TVITEM_struct, 1, $TVIF_STATE)
	DllStructSetData($TVITEM_struct, 2, $h_item)
	
	$ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_treeview, "int", $TVM_GETITEM, "int", 0, "ptr", DllStructGetPtr($TVITEM_struct))
	If $ret[0] Then
		$state = DllStructGetData($TVITEM_struct, 3)
	Else
		SetError(2)
	EndIf
	DllStructDelete($TVITEM_struct)
	
	Return $state
EndFunc   ;==>_TreeViewGetItemState
