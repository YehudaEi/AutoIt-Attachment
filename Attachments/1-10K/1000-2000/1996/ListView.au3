;**********
;ListView UDFs
;**********
Func _GUICtrlGetListViewColsCount(ByRef $lv,$title="",$text="")
    If(StringLen($title)==0) Then
        $title = WinGetTitle("")
    EndIf
    Return ControlListView($title ,$text, $lv, "GetSubItemCount")
EndFunc

Func _GUICtrlGetListViewItemsCount(ByRef $lv,$title="",$text="")
    If(StringLen($title)==0) Then
        $title = WinGetTitle("")
    EndIf
    Return ControlListView($title ,$text, $lv, "GetItemCount")
EndFunc

Func _GUICtrlLVClear($listview)
; Removes all items from a list-view control.
    Local $LVM_DELETEALLITEMS = 0x1009
; Returns TRUE if successful, or FALSE otherwise.
    Return GuiCtrlSendMsg($listview, $LVM_DELETEALLITEMS,0,0)
EndFunc

Func _GUICtrlLVGetItemsText($lv)
; returns an array of the subitems from an item
    Return StringSplit(GUICtrlRead(GUICtrlRead($lv)),"|")
EndFunc

;===============================================================================
; Function:      _GUICtrlLVGetItemText
; Author:        Gary Frost
;
; Description:       Get the text if the item (all or 1 subitem)
; Parameters:        $lv - The ListView Control to get the text from
;                         $WindowTitle - The Title to the window the control resides on
;                         [$WindowText] - The Text from the window the control resides on
;                        [$Item] - The Item to get data from
;                         [$SubItem] - The SubItem to get the text from
; Requirements:  None
; Return Values: Text from item/subitem(s) or error
;
; Note:          None
;===============================================================================
Func _GUICtrlLVGetItemText($lv, $WindowTitle, $WindowText="",$Item=-1,$SubItem=-1)
    Local $X,$count,$str
    $count = ControlListView ( $WindowTitle, $WindowText, $lv, "GetSubItemCount")
    if(ControlListView ( $WindowTitle, $WindowText, $lv, "GetSelectedCount")) Then
        If($SubItem == -1) Then; return all the subitems in the item selected
        
            For $X=0 To $count - 1 Step 1
                If($str) Then
                        If($Item == -1) Then
                            $str = $str & "|" & ControlListView ( $WindowTitle, $WindowText, $lv, "GetText", ControlListView ( $WindowTitle, $WindowText, $lv, "GetSelected"), $X )
                        Else
                            $str = $str & "|" & ControlListView ( $WindowTitle, $WindowText, $lv, "GetText", $Item, $X )
                        EndIf
                Else
                        If($Item == -1) Then
                            $str = ControlListView ( $WindowTitle, $WindowText, $lv, "GetText", ControlListView ( $WindowTitle, $WindowText, $lv, "GetSelected"), $X )
                        Else
                            $str = ControlListView ( $WindowTitle, $WindowText, $lv, "GetText", $Item, $X )
                        EndIf
                EndIf
            Next
            Return $str
        ElseIf($SubItem < $count) Then; return the subitem in the item selected
                If($Item == -1) Then
                    Return ControlListView ( $WindowTitle, $WindowText, $lv, "GetText", ControlListView ( $WindowTitle, $WindowText, $lv, "GetSelected"), $SubItem )
                Else
                    Return ControlListView ( $WindowTitle, $WindowText, $lv, "GetText", $Item, $SubItem )
                EndIf
        Else
        ; set an error, subitem is out of range
            SetError( -1 )
            Return @error
        EndIf
    Else
    ; set an error, no item selected
        SetError( -2 )
        Return @error
    EndIf
EndFunc


;===============================================================================
;
; Description:            _GUICtrlLVDeleteItems
; Parameter(s):        $lv - listview control id
;                            $WindowTitle - Text or gui id
;                            [$WindowText]- Text on Window
; Requirement:            None
; Return Value(s):    None
; User CallTip:        None
; Author(s):            Gary Frost <gary.frost@arnold.af.mil
; Note(s):                Idea from Holger
;                            Deletes items selected
;===============================================================================
Func _GUICtrlLVDeleteItems($lv,$WindowTitle,$WindowText="")
    Dim $i,$ItemCount
    Dim $LVM_DELETEITEM = 0x1008
    $ItemCount = ControlListView($WindowTitle,$WindowText,$lv,"GetItemCount")
    For $i = 0 To $ItemCount - 1
        If ControlListView($WindowTitle,$WindowText,$lv,"IsSelected",$i) Then 
            GuiCtrlSendMsg($lv, $LVM_DELETEITEM,$i,0)
            $i = $i - 1
        EndIf
    Next
EndFunc    

;===============================================================================
;
; Description:            _GUICtrlLVHideColumn
; Parameter(s):        $lv - listview control id
;                            $i_col - column to hide (set width to zero)
; Requirement:            None
; Return Value(s):    None
; User CallTip:        None
; Author(s):            Gary Frost <gary.frost@arnold.af.mil
; Note(s):                Idea from Holger
;
;===============================================================================
Func _GUICtrlLVHideColumn($lv,$i_col)
;set column width to 0
    Dim $LVM_SETCOLUMNWIDTH = 0x101E
    GUICtrlSendMsg($lv,$LVM_SETCOLUMNWIDTH,$i_col,0)
EndFunc

;===============================================================================
;
; Description:            _GUICtrlLVDeleteColumn
; Parameter(s):        $lv - listview control id
;                            $i_col - column to delete
; Requirement:            None
; Return Value(s):    None
; User CallTip:        None
; Author(s):            Gary Frost <gary.frost@arnold.af.mil
; Note(s):                Idea from Holger
;
;===============================================================================
Func _GUICtrlLVDeleteColumn($lv,$i_col)
    Dim $LVM_DELETECOLUMN = 0x101C
; Returns TRUE if successful, or FALSE otherwise
    Return GUICtrlSendMsg($lv,$LVM_DELETECOLUMN ,$i_col,0)
EndFunc

Func _GUICtrlListViewIndexSelected($lv,$WindowTitle,$WindowText="")
    Return ControlListView($WindowTitle,$WindowText,$lv,"FindItem", ControlListView ( $WindowTitle, $WindowText, $lv, "GetText", ControlListView ( $WindowTitle, $WindowText, $lv, "GetSelected"), 0 ))
EndFunc

Func _GUICtrlLVDeleteItem($lv,$i_index)
; Removes an item from a list-view control.
   Dim $LVM_DELETEITEM = 0x1008
; Returns TRUE if successful, or FALSE otherwise. 
    Return GuiCtrlSendMsg($lv, $LVM_DELETEITEM,$i_index,0)
EndFunc

Func _GUICtrlLVItemsCount($lv)
; alternative to my previous _GUICtrlGetListViewItemsCount
    Dim $LVM_GETITEMCOUNT = 0x1004
; Returns the number of items.
    Return GuiCtrlSendMsg($lv, $LVM_GETITEMCOUNT, 0, 0)
EndFunc

Func _GUICtrlLVGetNextItem($lv,$i_index)
; Searches for a list-view item that has the specified properties and
; bears the specified relationship to a specified item.
    Dim $LVM_GETNEXTITEM = 0x100c
    Dim $LVNI_ABOVE = 0x100
    Dim $LVNI_BELOW = 0x200
    Dim $LVNI_TOLEFT = 0x400
    Dim $LVNI_TORIGHT = 0x800
    Dim $LVNI_ALL = 0x0

; The state of the item to find can be specified with one or a combination of the following values:
    Dim $LVNI_CUT = 0x4; The item has the LVIS_CUT state flag set.
    Dim $LVNI_DROPHILITED = 0x8; The item has the LVIS_DROPHILITED state flag set
    Dim $LVNI_FOCUSED = 0x1; The item has the LVIS_FOCUSED state flag set.
    Dim $LVNI_SELECTED = 0x2; The item has the LVIS_SELECTED state flag set.
; If an item does not have all of the specified state flags set, the search continues with the next item.
    
; Returns the index of the next item if successful, or -1 otherwise. 
    Return GuiCtrlSendMsg($lv, $LVM_GETNEXTITEM, $i_index, $LVNI_ALL)
EndFunc

Func _RGB2BGR($v_RGBcolor)
    Dim $tc = Hex(String($v_RGBcolor),6)
    Return '0x' & stringmid($tc,5,2) & Stringmid($tc,3,2) & StringMid($tc,1,2)
EndFunc

Func _GUICtrlLVSetBkColor($lv,$v_RGBcolor)
; Sets the background color of a list-view control.
    Dim $LVM_SETBKCOLOR =0x1001
; Returns TRUE if successful, or FALSE otherwise
    Return GuiCtrlSendMsg($lv, $LVM_SETBKCOLOR, 0, int(_RGB2BGR($v_RGBcolor)))
EndFunc

Func _GUICtrlLVSetTextBkColor($lv,$v_RGBcolor)
; Sets the background color of text in a list-view control
    Dim $LVM_FIRST = 0x1000
    Dim $LVM_SETTEXTBKCOLOR =  ($LVM_FIRST + 38)
; Returns TRUE if successful, or FALSE otherwise
    Return GuiCtrlSendMsg($lv, $LVM_SETTEXTBKCOLOR, 0, int(_RGB2BGR($v_RGBcolor)))
EndFunc

Func _GUICtrlLVSetTextColor($lv,$v_RGBcolor)
; Sets the text color of a list-view control
    Dim $LVM_FIRST = 0x1000
    Dim $LVM_SETTEXTCOLOR = ($LVM_FIRST + 36)
; Returns TRUE if successful, or FALSE otherwise
    Return GuiCtrlSendMsg($lv, $LVM_SETTEXTCOLOR, 0, int(_RGB2BGR($v_RGBcolor)))
EndFunc
