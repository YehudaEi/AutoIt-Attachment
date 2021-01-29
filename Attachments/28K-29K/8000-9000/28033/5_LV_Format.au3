#cs
	To have no trouble with management of information about formatting, it's required to respect following:
	I've made or modified some functions, so that all information are accordingly with an Item all times will
	be connected with them. Wether if a new one created, an other deleted, position changed or listview are sorted.

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


	NEW:
		- No limitation by column count!
		- All information stored in one array, also if severally Listview exists.
		  That's why an variable is set as $maxColumn to hold maximum number of columns from all Listview.
		- Get index from array is now faster. An dictionary object stores IParam,array-index.
#ce
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <StructureConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <WinAPI.au3>

Local $col = ''
For $i = 1 To 6
	$col &= $i & '|'
Next

$GUI = GUICreate('')
$lv = GUICtrlCreateListView(StringTrimRight($col,1), 10, 10, 300, 150)
$hLV = GUICtrlGetHandle($lv)
For $i = 0 To 5
	_GUICtrlListView_SetColumnWidth($hLV, $i, 49)
Next

Global $B_DESCENDING[_GUICtrlListView_GetColumnCount($hLV)]


; if more than one LV get count column from LV with most columns
Global $maxColumn = _GUICtrlListView_GetColumnCount($hLV)
; Array to store infos about format, only one array - also if several LV
; [n][0][0]=ItemStruct, [n][1..Count][0..4]=SubItemValue
Global $aIParam[1][$maxColumn+1][5]
Global $oParamSearch = ObjCreate('Scripting.Dictionary') ; store for faster search (iParam, arrayIndex)
Global $hFont, $defColLV = 0x000000, $defBkColLV = 0xFFFFFF

; add new Items
_GUICtrlListView_AddOrIns_Item($hLV, 'Test0|Test1|Test2|Test3|Test4|Test5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blub0|Blub1|Blub2|Blub3|Blub4|Blub5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Club0|Club1|Club2|Club3|Club4|Club5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blab0|Blab1|Blab2|Blab3|Blab4|Blab5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Bumm0|Bumm1|Bumm2|Bumm3|Bumm4|Bumm5')

; set format
_SetItemParam($hLV, 0, 2, 0xff0000, -1, -1, 600, 'Times New Roman')
_SetItemParam($hLV, 1, 4, 0xffff00, -1, -1, 600, 'Comic Sans MS')
_SetItemParam($hLV, 1, 3, 0xff0000, -1, -1, 600, 'Times New Roman')


GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState(@SW_SHOW, $GUI)

Sleep(1000)
_SetItemParam($hLV, 1, 4) ; set format to default for Item at index 1, column-index 4

Sleep(1000)
__GUICtrlListView_DeleteItem($hLV, 1) ; delete Item at index 1

Sleep(1000)
__GUICtrlListView_DeleteAllItems($hLV)

Sleep(1000)
_GUICtrlListView_BeginUpdate($hLV)
_GUICtrlListView_AddOrIns_Item($hLV, 'Test0|Test1|Test2|Test3|Test4|Test5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blub0|Blub1|Blub2|Blub3|Blub4|Blub5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Club0|Club1|Club2|Club3|Club4|Club5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blab0|Blab1|Blab2|Blab3|Blab4|Blab5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Bumm0|Bumm1|Bumm2|Bumm3|Bumm4|Bumm5')
_GUICtrlListView_EndUpdate($hLV)
_SetItemParam($hLV, 0, 1, 0xff0000, -1, -1, 600, 'Times New Roman')
_SetItemParam($hLV, 1, 2, 0xffff00, -1, -1, 600, 'Comic Sans MS')
_SetItemParam($hLV, 2, 3, 0xff0000, -1, -1, 600, 'Times New Roman')

WinSetTitle($GUI, '', 'Now click column header to sort')

Do
Until GUIGetMsg() = -3
_WinAPI_DeleteObject($hFont)


#region - Listview handling (add/insert, delete)
Func _GUICtrlListView_AddOrIns_Item($hWnd, $sText, $iItem=-1)
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
	Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex)
	$aIParam[$oParamSearch.Item($iParam)][0][0] = ''
	$oParamSearch.Remove($iParam)
	_GUICtrlListView_DeleteItem($hWnd, $iIndex)
EndFunc  ;==>__GUICtrlListView_DeleteItem

Func __GUICtrlListView_DeleteItemsSelected($hWnd)
	Local $aSelected = _GUICtrlListView_GetSelectedIndices($hWnd, True)
	For $i = 1 To $aSelected[0]
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $aSelected[$i])
		$aIParam[$oParamSearch.Item($iParam)][0][0] = ''
		$oParamSearch.Remove($iParam)
		_GUICtrlListView_DeleteItem($hWnd, $aSelected[$i])
	Next
EndFunc  ;==>__GUICtrlListView_DeleteItemsSelected

Func __GUICtrlListView_DeleteAllItems($hWnd)
	Local $item = _GUICtrlListView_GetItemCount($hWnd)
	For $i = 0 To $item -1
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $i)
		$aIParam[$oParamSearch.Item($iParam)][0][0] = ''
		$oParamSearch.Remove($iParam)
	Next
 	_GUICtrlListView_DeleteAllItems($hWnd)
EndFunc  ;==>__GUICtrlListView_DeleteAllItems

#endregion

Func _SetItemParam($hWnd, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
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
	$hDC = DllStructGetData($tCustDraw, 'hdc')
	DllStructSetData($tCustDraw, 'clrText', RGB2BGR($defColLV))
	DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($defBkColLV))
	$hFont = _WinAPI_CreateFont(14,0,0,0,$FW_NORMAL,False,False,False,$DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS, _
			$CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial')
	_WinAPI_SelectObject($hDC, $hFont)
EndFunc  ;==>_DrawDefault

Func _getMarked($hWnd, $iItem, $iSubItem)
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

Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hLV
            Switch $iCode
				Case $LVN_COLUMNCLICK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					__GUICtrlListView_SimpleSort($hWndFrom, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
                Case $NM_CUSTOMDRAW
                    If Not _GUICtrlListView_GetViewDetails($hWndFrom) Then Return $GUI_RUNDEFMSG
					Local $tCustDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
					Local $iDrawStage, $iItem, $iSubitem, $hDC, $tRect
                    $iDrawStage = DllStructGetData($tCustDraw, 'dwDrawStage')
                    Switch $iDrawStage
                        Case $CDDS_ITEMPREPAINT
                            Return $CDRF_NOTIFYSUBITEMDRAW
                        Case BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
                            $iItem = DllStructGetData($tCustDraw, 'dwItemSpec')
                            $iSubitem = DllStructGetData($tCustDraw, 'iSubItem')
							Local $index = _getMarked($hWndFrom, $iItem, $iSubitem)
							If $index = -1 Then
								_DrawDefault($hDC, $tCustDraw)
							Else
								_DrawItemCol($hDC, $tCustDraw, $hWndFrom, $index, $iSubitem)
							EndIf
                            Return $CDRF_NEWFONT
                    EndSwitch
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

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
