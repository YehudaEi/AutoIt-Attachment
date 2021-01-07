; PopG_GuiCtrl.au3 - Created by Andy Swarbrick (c) 2005-6
#region		Doc:
#region		Doc: Function List
; _GUICtrlCheckBoxSet					Sets or clears a Checkbox
; _GUICtrlComboSetItemTextFromArray		Sets the items in a combo from elements in an array.
; _GUICtrlCreateListViewFromArray		Sets the items in a list view from elements in an array.
; _GUICtrlCreateListViewFromArray2		Sets the items in a list view from elements in a two-dimensional array. filtering on the first dimension, and populating from the second.
; _GUICtrlCreateMenuitemEvent			Adds a Menu item for event driven handling
; _GUICtrlCreateWithTipAndEvent			Creates GUICtrls, setting tips and events
; _GUICtrlHasFocus						Returns the Gui Control that has focus from the list of handles.
; _GUICtrlListViewRenameItem			Renames the leftmost subitem for two rows in a listview
; _GUICtrlListViewSwapRow				Swaps the entire row for two subitems in a listview, leaving the "key" subitem as is.
#endregion	Doc: Function List
#endregion	Doc:
#region 	Init:
#region 	Init: Includes
	#include-once
	#include <array.au3>
	#include <GUIConstants.au3>
	#include <GuiList.au3>
	#Include <GuiListView.au3>
	#include <GuiCombo.au3>
#endregion	Init: Includes
#endregion	Init:
#region		Run:
#region		Run: Functions
; _GUICtrlCheckBoxSet					Sets or clears a Checkbox
Func _GUICtrlCheckBoxSet($handle, $val)
	If $val Then ; anything other than 0
		GUICtrlSetState($handle,$GUI_CHECKED)
	Else
		GUICtrlSetState($handle,$GUI_UNCHECKED)
	EndIf
EndFunc ;_GUICtrlCheckBoxSet
; _GUICtrlCreateWithTipAndEvent			Creates GUICtrls, setting tips and events
Func _GUICtrlCreateWithTipAndEvent($Type, $Text, $X, $Y, $W, $H, $Tip, $Event='', $Style=-1)
	Local $Handle
	Select 
	Case $Style<>-1
		Select
		Case $Type='Button'
			$Handle=GUICtrlCreateButton($Text, $X, $Y, $W, $H, $Style)
		Case $Type='Combo'
			$Handle=GUICtrlCreateCombo($Text, $X, $Y, $W, $H, $Style)
		Case $Type='Input'
			$Handle=GUICtrlCreateInput($Text, $X, $Y, $W, $H, $Style)
		Case $Type='Label'
			$Handle=GUICtrlCreateLabel($Text, $X, $Y, $W, $H, $Style)
		EndSelect
	Case Else
		Select
		Case $Type='Button'
			$Handle=GUICtrlCreateButton($Text, $X, $Y, $W, $H)
		Case $Type='Combo'
			$Handle=GUICtrlCreateCombo($Text, $X, $Y, $W, $H)
		Case $Type='Input'
			$Handle=GUICtrlCreateInput($Text, $X, $Y, $W, $H)
		Case $Type='Label'
			$Handle=GUICtrlCreateLabel($Text, $X, $Y, $W, $H)
		EndSelect
	EndSelect
	GUICtrlSetTip($Handle, $Tip)
	If $Event<>'' Then 
		If Opt('GUIOnEventMode') Then GUICtrlSetOnEvent ($Handle, $Event)
	EndIf
	Return $Handle
EndFunc ;_GUICtrlCreateWithTipAndEvent
; _GUICtrlListViewSwapRow				Swaps the entire row for two subitems in a listview, leaving the "key" subitem as is.
; Returns 1 if error getting $LvIdx1
; Returns 2 if error getting $LvIdx2
; Returns 3 if error setting $LvIdx1
; Returns 4 if error setting $LvIdx2
Func _GUICtrlListViewSwapRow($Lv,$LvIdx1,$LvIdx2)
	Local $SubItemIdx,$LvArr1,$LvArr2,$LvItemText1,$LvItemText2
	$LvArr1=_GUICtrlListViewGetItemTextArray($Lv,$LvIdx1)
	If $LvArr1=$LV_ERR 															Then Return 1
	$LvArr2=_GUICtrlListViewGetItemTextArray($Lv,$LvIdx2)
	If $LvArr2=$LV_ERR 															Then Return 2
	Local $SubItems=$LvArr1[0]
	If $LvArr2[0]>$SubItems Then $SubItems=$LvArr2[0]
	For $SubItemIdx=2 To $SubItems
		If $SubItemIdx<=$LvArr1[0] Then
			$LvItemText1=$LvArr1[$SubItemIdx]
		Else
			$LvItemText1=''
		EndIf
		If $SubItemIdx<=$LvArr2[0] Then
			$LvItemText2=$LvArr2[$SubItemIdx]
		Else
			$LvItemText2=''
		EndIf
		_GUICtrlListViewSetItemText($Lv,$LvIdx1,$SubItemIdx-1,$LvItemText2)
		_GUICtrlListViewSetItemText($Lv,$LvIdx2,$SubItemIdx-1,$LvItemText1)
	Next
EndFunc
; _GUICtrlListViewRenameItem			Renames the leftmost subitem for two rows in a listview
; Returns 1 if error getting $LvIdx1
; Returns 2 if error getting $LvIdx2
; Returns 3 if error setting $LvIdx1
; Returns 4 if error setting $LvIdx2
Func _GUICtrlListViewRenameItem($Lv,$LvIdx1,$LvIdx2)
	Local $LvText1=_GUICtrlListViewGetItemText($Lv,$LvIdx1,0)
	If $LvText1=$LV_ERR 											Then Return 1
	Local $LvText2=_GUICtrlListViewGetItemText($Lv,$LvIdx2,0)
	If $LvText2=$LV_ERR 											Then Return 2
	If _GUICtrlListViewSetItemText($Lv,$LvIdx1,0,$LvText2)=$LV_ERR 	Then Return 3
	If _GUICtrlListViewSetItemText($Lv,$LvIdx2,0,$LvText1)=$LV_ERR 	Then Return 4
EndFunc
; _GUICtrlCreateMenuitemEvent			Adds a Menu item for event driven handling
Func _GUICtrlCreateMenuitemEvent($label,$menuid,$event='')
	Local $hdl=GUICtrlCreateMenuitem ($label,$menuid)
	If $event<>'' Then 
		If Opt('GUIOnEventMode') Then 
			GUICtrlSetOnEvent($hdl, $event)
		EndIf
	EndIf
	Return $hdl
EndFunc ;_GUICtrlCreateMenuitemEvent
; _GUICtrlCreateListViewFromArray		Sets the items in a list view from elements in an array.
Func _GUICtrlCreateListViewFromArray($Lv,ByRef $arr,$dflt='')
	If Not IsArray($arr) Then
		SetError(1)
		Return '_GUICtrlCreateListViewFromArray'&'Not array'
	EndIf
	Local $i,$dflt1
	Local $str=$arr[1]
	If Not IsString($dflt) Then	Local $dflti=$dflt
	_GUICtrlListViewDeleteAllItems($Lv)
	For $i=1 To $arr[0]
		If GUICtrlCreateListViewItem($Lv,$arr[$i]) = 0 Then 
			SetError(2)
			Return '_GUICtrlCreateListViewFromArray'&GUICtrlCreateListViewItem($Lv,$arr[$i])
		EndIf
		If IsString($dflt) Then
			If StringInStr($arr[$i],$dflt,1)=1 Then $dflt1=$i
		EndIf
	Next
	_GUICtrlListViewSetItemSelState($Lv,$dflti,1)
	Return
EndFunc ;_GUICtrlCreateListViewFromArray
; _GUICtrlCreateListViewFromArray2		Sets the items in a list view from elements in a two-dimensional array. filtering on the first dimension, and populating from the second.
Func _GUICtrlCreateListViewFromArray2($Lv,ByRef $arr,$dflt='',$filter='')
	Const $ErrBas=10
	If Not IsArray($arr) Then
		SetError($ErrBas+1)
		Return '_GUICtrlCreateListViewFromArray2'&' If Not IsArray($arr) Then'
	EndIf
	Local $i,$dflti,$j,$dflt1
	Local $str=$arr[1]
	If Not IsString($dflt) Then	$dflti=$dflt
	_GUICtrlListViewDeleteAllItems($Lv)
	If @error Then
		SetError($ErrBas+2)
		Return '_GUICtrlCreateListViewFromArray2'&' _GUICtrlListViewDeleteAllItems($Lv)'
	EndIf
	For $i=1 To $arr[0][0]
		If $filter<>'' Then
			If $arr[$i][0]<>$filter Then ContinueLoop
		EndIf
		If GUICtrlCreateListViewItem($Lv,$arr[$i][1]) = 0 Then 
			SetError($ErrBas+3)
			Return '_GUICtrlCreateListViewFromArray2'&' If GUICtrlCreateListViewItem($Lv,$arr[$i][1]) = 0 Then '
		EndIf
		If IsString($dflt) Then
			If StringInStr($arr[$i][$j],$dflt,1)=1 Then $dflt1=$i
		EndIf
	Next
	_GUICtrlListViewSetItemSelState($Lv,$dflti,1)
	Return
EndFunc ;_GUICtrlCreateListViewFromArray2
; _GUICtrlComboSetItemTextFromArray		Sets the items in a list view from elements in an array.
Func _GUICtrlComboSetItemTextFromArray($combo,ByRef $arr,$dflt)
	If Not IsArray($arr) Then
		SetError(1)
		Return '_GUICtrlComboSetItemTextFromArray'&'not array'
	EndIf
	Local $i
	Local $Dlm=Opt('GUIDataSeparatorChar')
	Local $str=$arr[1]
	For $i=2 To $arr[0]
		$str=$str&$Dlm&$arr[$i]
	Next
	If GUICtrlSetData($combo,$str,$dflt) Then Return
	SetError(2)
	Return '_GUICtrlComboSetItemTextFromArray'
EndFunc ;_GUICtrlComboSetItemTextFromArray
; _GUICtrlHasFocus						Returns the Gui Control that has focus from the list of handles.
; Between 2 and 10 handles can be supplied.
Func _GUICtrlHasFocus($c1,$c2,$c3=0,$c4=0,$c5=0,$c6=0,$c7=0,$c8=0,$c9=0,$c10=0)
	Local $hdl,$res,$cS
	$cS=0
	For $cI=1 To 10
		If $cI=0 Then ExitLoop
		$cS=Eval('C'&$cI)
		If BitAND(GUICtrlGetState($cS),$GUI_FOCUS) Then
			$res=$cS
			ExitLoop
		EndIf
	Next
	If $cS=0 Then
		SetError(1)
		Return '_GUICtrlHasFocus'&'c5'
	Else
		Return $hdl
	EndIf
EndFunc ; _GUICtrlHasFocus
#endregion	Run: Functions
#endregion	Run:
