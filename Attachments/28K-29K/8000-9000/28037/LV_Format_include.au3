#cs
	To hold main script small, all management stuff in this include file.

	Initialize Global vars at startup
		_LVFormatting_Startup($hLVmaxCol, $defTxtCol=0x000000, $defBkCol=0xFFFFFF)
			$hLVmaxCol	Listview handle, if several LV use handle from LV with most column
			$defTxtCol	textcolor to use as default
			$defBkCol	backcolor to use as default
			also set:
			$maxColumn = _GUICtrlListView_GetColumnCount($hLVmaxCol)
			$aIParam[1][$maxColumn+1][5]
			$oParamSearch = ObjCreate('Scripting.Dictionary')
			$hFont
			$defColLV = $defTxtCol
			$defBkColLV = $defBkCol

	Clean up resources
		_LVFormatting_Shutdown()

	Add or insert new Listview Item:
		_GUICtrlListView_AddOrIns_Item($hWnd, $sText, $iItem=-1)
			$hWnd	Listview handle
			$sText	lonely string to set only Item text (than SubItem must set with _GUICtrlListView_AddSubItem)
					or
					"Item|SubItem|SubItem.." to set all text at once
			$iItem	Item index, if -1 a new Item will add at the end
					otherwise
					the Item will insert at index position

	Delete one, selected or all Item:
		__GUICtrlListView_DeleteItem($hWnd, $iIndex)
		__GUICtrlListView_DeleteItemsSelected($hWnd)
		__GUICtrlListView_DeleteAllItems($hWnd)

	Format Listview Item
		_SetItemParam($hWnd, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
			$hWnd		Listview handle
			$iItem		Item index
			$iSubItem	SubItem index
			$iBkCol		back color (-1 = default BkCol)
			$iCol		text color (-1 = default txtCol)
			$iSize		height of font (-1 = 14)
			$iWeight	font weight    (-1 = 400)
			$sFont		typefont name  (-1 = Arial)

	Sort Listview:
		By default SimpleSort doesn't really sort Items - only Item-/SubItem text moves. Because that, IParam stands at same
		position like before. I've modified this function, so that IParam also will sorted.
		__GUICtrlListView_SimpleSort($hWnd, ByRef $vDescending, $iCol)

	Call from WM_NOTIFY
		_getMarked($hWnd, $iItem, $iSubItem) ==> check if SubItem is formatted
		_DrawItemCol(ByRef $hDC, ByRef $tCustDraw, $hWnd, $iItem, $iSubitem) ==> draw formatted SubItem
		_DrawDefault(ByRef $hDC, ByRef $tCustDraw) ==> draw unformatted SubItem
		for simple sort:
		__GUICtrlListView_SimpleSort($hWnd, ByRef $vDescending, $iCol)

#ce

#include-once
#include <Array.au3>
#include <FontConstants.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <WinAPI.au3>

Func _LVFormatting_Startup($hLVmaxCol, $defTxtCol=0x000000, $defBkCol=0xFFFFFF)
	Global $maxColumn = _GUICtrlListView_GetColumnCount($hLVmaxCol)
	; [n][0][0]=ItemStruct, [n][1..Count][0..4]=SubItemValue
	Global $aIParam[1][$maxColumn+1][5]
	Global $oParamSearch = ObjCreate('Scripting.Dictionary')
	Global $hFont
	Global $defColLV = $defTxtCol
	Global $defBkColLV = $defBkCol
EndFunc

Func _LVFormatting_Shutdown()
	If Not IsDeclared('hFont') Then
		Global $hFont
	EndIf
	_WinAPI_DeleteObject($hFont)
EndFunc

Func _GUICtrlListView_AddOrIns_Item($hWnd, $sText, $iItem=-1)
	If Not IsDeclared('maxColumn') Then
		Global $maxColumn
	EndIf
	If Not IsDeclared('aIparam') Then
		Global $aIParam[1][$maxColumn+1][5]
	EndIf
	If Not IsDeclared('oParamSearch') Then
		Global $oParamSearch = ObjCreate('Scripting.Dictionary')
	EndIf
	If Not IsDeclared('hFont') Then
		Global $hFont
	EndIf
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	$sText = StringSplit($sText, '|')
	If $iItem < -1 Then
		$iItem = 0
	EndIf
	If $iItem > _GUICtrlListView_GetItemCount($hWnd)-1 Then
		$iItem = -1
	EndIf
	Local $cntCOL = _GUICtrlListView_GetColumnCount($hWnd)
	If $aIParam[UBound($aIParam)-1][0][0] <> '' Then
		ReDim $aIParam[UBound($aIParam)+1][$maxColumn+1][5]
	EndIf
	Local $tagITEMPARAM = "int_ptr;byte[" & $cntCOL & "];"
	Local $tITEMPARAM = DllStructCreate($tagITEMPARAM)
	DllStructSetData($tITEMPARAM, 1, DllStructGetPtr($tITEMPARAM, 2)) ; byte[col]
	$aIParam[UBound($aIParam)-1][0][0] = $tITEMPARAM
	$oParamSearch.Add(DllStructGetData($tITEMPARAM, 1), UBound($aIParam)-1) ; key=IParam, val=array-index
	For $i = 1 To $cntCOL
		DllStructSetData($tITEMPARAM, 2, 0, $i)
	Next
	If $iItem = -1 Then
		$iItem = _GUICtrlListView_AddItem($hWnd, $sText[1])
		_GUICtrlListView_SetItemParam($hWnd, $iItem, DllStructGetData($tITEMPARAM, 1))
	Else
		_GUICtrlListView_InsertItem($hWnd, $sText[1], $iItem)
		_GUICtrlListView_SetItemParam($hWnd, $iItem, DllStructGetData($tITEMPARAM, 1))
	EndIf
	If $sText[0] > 1 Then
		For $i = 2 To UBound($sText) -1
			_GUICtrlListView_AddSubItem($hWnd, $iItem, $sText[$i], $i-1)
		Next
	EndIf
EndFunc  ;==>_GUICtrlListView_AddOrIns_Item

Func __GUICtrlListView_DeleteItem($hWnd, $iIndex)
	If Not IsDeclared('maxColumn') Then
		Global $maxColumn
	EndIf
	If Not IsDeclared('aIparam') Then
		Global $aIParam[1][$maxColumn+1][5]
	EndIf
	If Not IsDeclared('oParamSearch') Then
		Global $oParamSearch = ObjCreate('Scripting.Dictionary')
	EndIf
	Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
	$aIParam[$oParamSearch.Item($iParam)][0][0] = ''
	$oParamSearch.Remove($iParam)
	_GUICtrlListView_DeleteItem($hWnd, $iIndex)
EndFunc  ;==>__GUICtrlListView_DeleteItem

Func __GUICtrlListView_DeleteItemsSelected($hWnd)
	If Not IsDeclared('maxColumn') Then
		Global $maxColumn
	EndIf
	If Not IsDeclared('aIparam') Then
		Global $aIParam[1][$maxColumn+1][5]
	EndIf
	If Not IsDeclared('oParamSearch') Then
		Global $oParamSearch = ObjCreate('Scripting.Dictionary')
	EndIf
	Local $aSelected = _GUICtrlListView_GetSelectedIndices($hWnd, True)
	For $i = 1 To $aSelected[0]
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $aSelected[$i])
		$aIParam[$oParamSearch.Item($iParam)][0][0] = ''
		$oParamSearch.Remove($iParam)
		_GUICtrlListView_DeleteItem($hWnd, $aSelected[$i])
	Next
EndFunc  ;==>__GUICtrlListView_DeleteItemsSelected

Func __GUICtrlListView_DeleteAllItems($hWnd)
	If Not IsDeclared('maxColumn') Then
		Global $maxColumn
	EndIf
	If Not IsDeclared('aIparam') Then
		Global $aIParam[1][$maxColumn+1][5]
	EndIf
	If Not IsDeclared('oParamSearch') Then
		Global $oParamSearch = ObjCreate('Scripting.Dictionary')
	EndIf
	Local $item = _GUICtrlListView_GetItemCount($hWnd)
	For $i = 0 To $item -1
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $i)
		$aIParam[$oParamSearch.Item($iParam)][0][0] = ''
		$oParamSearch.Remove($iParam)
	Next
 	_GUICtrlListView_DeleteAllItems($hWnd)
EndFunc  ;==>__GUICtrlListView_DeleteAllItems

Func _SetItemParam($hWnd, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
	If Not IsDeclared('maxColumn') Then
		Global $maxColumn
	EndIf
	If Not IsDeclared('aIparam') Then
		Global $aIParam[1][$maxColumn+1][5]
	EndIf
	If Not IsDeclared('oParamSearch') Then
		Global $oParamSearch = ObjCreate('Scripting.Dictionary')
	EndIf
	If Not IsDeclared('defColLV') Then
		Global $defColLV
	EndIf
	If Not IsDeclared('defBkColLV') Then
		Global $defBkColLV
	EndIf
	Local $sumParam = 0
	Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iItem)
	Local $index = $oParamSearch.Item($iParam)
	If $iBkCol = -1 Then
		$iBkCol = $defBkColLV
		$sumParam += 1
	EndIf
	If $iCol = -1 Then
		$iCol = $defColLV
		$sumParam += 1
	EndIf
	If $iSize = -1 Then
		$iSize = 14
		$sumParam += 1
	EndIf
	If $iWeight = -1 Then
		$iWeight = 400
		$sumParam += 1
	EndIf
	If $sFont = -1 Then
		$sFont = 'Arial'
		$sumParam += 1
	EndIf
	$aIParam[$index][$iSubItem+1][0] = $iBkCol
	$aIParam[$index][$iSubItem+1][1] = $iCol
	$aIParam[$index][$iSubItem+1][2] = $iSize
	$aIParam[$index][$iSubItem+1][3] = $iWeight
	$aIParam[$index][$iSubItem+1][4] = $sFont
	; if SubItem not registered in IParam OR all values by -1 (delete Sub from IParam) ==> switch Sub value in IParam
	Local $mark = DllStructGetData($aIParam[$index][0][0], 2, $iSubItem+1)
	If Not $mark Or $sumParam = 5 Then
		DllStructSetData($aIParam[$index][0][0], 2, BitXOR($mark, 1), $iSubItem+1)
	EndIf
	If DllStructGetData($aIParam[$index][0][0], 2, $iSubItem+1) <> $mark Then
		_GUICtrlListView_RedrawItems($hWnd, $iItem, $iItem)
	EndIf
EndFunc  ;==>_SetItemParam

Func _DrawItemCol(ByRef $hDC, ByRef $tCustDraw, $hWnd, $iItem, $iSubitem) ; draw formatted item
	If Not IsDeclared('maxColumn') Then
		Global $maxColumn
	EndIf
	If Not IsDeclared('aIparam') Then
		Global $aIParam[1][$maxColumn+1][5]
	EndIf
	If Not IsDeclared('hFont') Then
		Global $hFont
	EndIf
	Local $aDefFont[14] = [14,0,0,0,$FW_NORMAL,False,False,False, _
		  $DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS,$CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial']
	$aDefFont[0]  = $aIParam[$iItem][$iSubItem+1][2]
	$aDefFont[4]  = $aIParam[$iItem][$iSubItem+1][3]
	$aDefFont[13] = $aIParam[$iItem][$iSubItem+1][4]
	$hDC = DllStructGetData($tCustDraw, 'hdc')
	DllStructSetData($tCustDraw, 'clrText', RGB2BGR($aIParam[$iItem][$iSubItem+1][1]))
	DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aIParam[$iItem][$iSubItem+1][0]))
	$hFont = _WinAPI_CreateFont($aDefFont[0],$aDefFont[1],$aDefFont[2],$aDefFont[3],$aDefFont[4],$aDefFont[5],$aDefFont[6], _
			 $aDefFont[7],$aDefFont[8],$aDefFont[9],$aDefFont[10],$aDefFont[11],$aDefFont[12],$aDefFont[13])
	_WinAPI_SelectObject($hDC, $hFont)
EndFunc  ;==>_DrawItemCol

Func _DrawDefault(ByRef $hDC, ByRef $tCustDraw) ; draw unformatted item
	If Not IsDeclared('hFont') Then
		Global $hFont
	EndIf
	If Not IsDeclared('defColLV') Then
		Global $defColLV
	EndIf
	If Not IsDeclared('defBkColLV') Then
		Global $defBkColLV
	EndIf
	$hDC = DllStructGetData($tCustDraw, 'hdc')
	DllStructSetData($tCustDraw, 'clrText', RGB2BGR($defColLV))
	DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($defBkColLV))
	$hFont = _WinAPI_CreateFont(14,0,0,0,$FW_NORMAL,False,False,False,$DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS, _
			$CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial')
	_WinAPI_SelectObject($hDC, $hFont)
EndFunc  ;==>_DrawDefault

Func _getMarked($hWnd, $iItem, $iSubItem)
	If Not IsDeclared('oParamSearch') Then
		Global $oParamSearch = ObjCreate('Scripting.Dictionary')
	EndIf
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	Local $cntCOL = _GUICtrlListView_GetColumnCount($hWnd)
	Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iItem)
	Local $struct = DllStructCreate("byte[" & $cntCOL & "]", $iParam)
	If DllStructGetData($struct, 1, $iSubItem+1) Then
		Return $oParamSearch.Item($iParam)
	Else
		Return -1
	EndIf
EndFunc  ;==>_getMarked

Func RGB2BGR($iColor)
	Local $sH = Hex($iColor,6)
    Return '0x' & StringRight($sH, 2) & StringMid($sH,3,2) & StringLeft($sH, 2)
EndFunc  ;==>RGB2BGR

Func __GUICtrlListView_SimpleSort($hWnd, ByRef $vDescending, $iCol) ; modified to sort also IParam
	If $Debug_LV Then _GUICtrlListView_ValidateClassName($hWnd)
	Local $x, $Y, $Z, $b_desc, $columns, $items, $v_item, $temp_item, $iFocused = -1
	Local $SeparatorChar = Opt('GUIDataSeparatorChar')
	If _GUICtrlListView_GetItemCount($hWnd) Then
		If (IsArray($vDescending)) Then
			$b_desc = $vDescending[$iCol]
		Else
			$b_desc = $vDescending
		EndIf
		$columns = _GUICtrlListView_GetColumnCount($hWnd)
		$items = _GUICtrlListView_GetItemCount($hWnd)
		For $x = 1 To $columns
			$temp_item = $temp_item & " " & $SeparatorChar
		Next
		$temp_item = StringTrimRight($temp_item, 1)
;~ 		Local $a_lv[$items][$columns + 1], $i_selected
		Local $a_lv[$items][$columns + 2], $i_selected ; add column for IParam  ### MODIFIED ###

		$i_selected = StringSplit(_GUICtrlListView_GetSelectedIndices($hWnd), $SeparatorChar)
		For $x = 0 To UBound($a_lv) - 1 Step 1
			If $iFocused = -1 Then
				If _GUICtrlListView_GetItemFocused($hWnd, $x) Then $iFocused = $x
			EndIf
			_GUICtrlListView_SetItemSelected($hWnd, $x, False)
;~ 			_GUICtrlListView_SetItemState($hWnd, $x, 0, BitOR($LVIS_SELECTED, $LVIS_FOCUSED))
;~ 			For $Y = 0 To UBound($a_lv, 2) - 2 Step 1
			For $Y = 0 To UBound($a_lv, 2) - 3 Step 1  ;  ### MODIFIED ###
				$v_item = StringStripWS(_GUICtrlListView_GetItemText($hWnd, $x, $Y), 2)
				If (StringIsFloat($v_item) Or StringIsInt($v_item)) Then
					$a_lv[$x][$Y] = Number($v_item)
				Else
					$a_lv[$x][$Y] = $v_item
				EndIf
			Next
			$a_lv[$x][$Y] = $x
			$a_lv[$x][$Y+1] = _GUICtrlListView_GetItemParam($hWnd, $x)  ;  ### NEW ###
		Next
		_ArraySort($a_lv, $b_desc, 0, 0, $iCol)
		For $x = 0 To UBound($a_lv) - 1 Step 1
;~ 			For $Y = 0 To UBound($a_lv, 2) - 2 Step 1
			For $Y = 0 To UBound($a_lv, 2) - 3 Step 1  ;  ### MODIFIED ###
;~ 				_GUICtrlListViewSetItemText($hWnd, $x, $Y, $a_lv[$x][$Y])
				_GUICtrlListView_SetItemText($hWnd, $x, $a_lv[$x][$Y], $Y)
			Next
			_GUICtrlListView_SetItemParam($hWnd, $x, $a_lv[$x][$Y+1])  ;  ### NEW ###
			For $Z = 1 To $i_selected[0]
;~ 				If $a_lv[$x][UBound($a_lv, 2) - 1] = $i_selected[$Z] Then
				If $a_lv[$x][UBound($a_lv, 2) - 2] = $i_selected[$Z] Then  ;  ### MODIFIED ###
;~ 					If $a_lv[$x][UBound($a_lv, 2) - 1] = $iFocused Then
					If $a_lv[$x][UBound($a_lv, 2) - 2] = $iFocused Then  ;  ### MODIFIED ###
						_GUICtrlListView_SetItemSelected($hWnd, $x, True, True)
					Else
						_GUICtrlListView_SetItemSelected($hWnd, $x, True)
					EndIf
;~ 					_GUICtrlListView_SetItemState($hWnd, $x, $LVIS_SELECTED, BitOR($LVIS_SELECTED, $LVIS_FOCUSED))
;~ 					If $a_lv[$x][UBound($a_lv, 2) - 1] = $iFocused Then _GUICtrlListView_SetItemState($hWnd, $x, $LVIS_FOCUSED, $LVIS_FOCUSED)
					ExitLoop
				EndIf
			Next
		Next
		If (IsArray($vDescending)) Then
			$vDescending[$iCol] = Not $b_desc
		Else
			$vDescending = Not $b_desc
		EndIf
	EndIf
EndFunc   ;==>__GUICtrlListView_SimpleSort
