#Region - TimeStamp
; 2011-08-08 14:48:18   v 1.3
#EndRegion - TimeStamp

#cs
	Initialize Global vars at startup
		_GUICtrlListView_Formatting_Startup($hGUI, $hListView)
			$hGUI       Handle of your GUI
			$hListView	Listview handle, for several LV commit handle's as array

	[ Clean up ressources ==> Changed! ==> now automatically called on AutoIt exit ]
		_GUICtrlListView_Formatting_Shutdown()

	Add or insert new Listview Item:
		_GUICtrlListView_AddOrIns_Item($hWnd, $sText, $iItem=-1)
			$hWnd	Listview handle
			$vText	String with:
					lonely string to set only Item text (than SubItem must set with _GUICtrlListView_AddSubItem)
					or
					"Item|SubItem|SubItem.." to set all text at once
					or..
					an Array with this strings to set more than one Item at once
			$iItem	Item index, if -1 a new Item will add at the end (default)
					otherwise
					the Item will insert at index position

	Delete one, selected or all Item:
		_GUICtrlListView_FormattedDeleteItem($hWnd, $iIndex)
		_GUICtrlListView_FormattedDeleteItemsSelected($hWnd)
		_GUICtrlListView_FormattedDeleteAllItems($hWnd)

	Set defaults
		_GUICtrlListView_DefaultsSet($iBkCol=0xFFFFFF, $iCol=0x000000, $iSize=14, $iWeight=400, $sFont='Arial')
			$iBkCol    back color   default white
			$iCol      text color   default black
			$iSize     font size    default 14
			$iWeight   font weight  default 400
			$sFont     font name    default Arial

	Get defaults
		_GUICtrlListView_DefaultsGet()
		Return: [$iBkCol, $iCol, $iSize, $iWeight, $sFont]

	Format Listview Item
		_GUICtrlListView_FormattingCell($hWnd, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
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

	Call from WM_NOTIFY_LV_FORMAT
		__getMarked($hWnd, $iItem, $iSubItem) ==> check if SubItem is formatted
		__DrawItemCol(ByRef $hDC, ByRef $tCustDraw, $hWnd, $iItem, $iSubitem) ==> draw formatted SubItem
		__DrawDefault(ByRef $hDC, ByRef $tCustDraw) ==> draw unformatted SubItem
		for simple sort:
		__GUICtrlListView_SimpleSort($hWnd, ByRef $vDescending, $iCol)

#ce

#include-once
#include <Array.au3>
#include <FontConstants.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <StructureConstants.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>

OnAutoItExitRegister("_GUICtrlListView_Formatting_Shutdown")

Global Const $SHIFT_PARAMVALUE = 9000 ; == if you have higher Ctrl-ID in your script - increase this value
Global $FORMATLV_hPROC, $FORMATLV_hHOOK, $FORMATLV_hGUI
Global $FORMATLV_aITEM_INDEX
; == $FORMATLV_aITEM_INDEX
; == use in your script this Global array variable with information about right clicked Item [state clicked:TrueFalse, $hWndFrom, "Index", "SubItem", $iBkCol, $iCol, $iSize, $iWeight, $sFont]
; == use GuiRegisterMessage($WM_NOTIFY, 'Function') to react
; == how to use, see Func _RightClick() inside "Example_LV_Format.au3"

Global $FORMATLV_DEF_BKCOL        = 0xFFFFFF
Global $FORMATLV_DEF_COL          = 0x000000
Global $FORMATLV_DEF_SIZE         = 14
Global $FORMATLV_DEF_WEIGHT       = 400
Global $FORMATLV_DEF_FONT         = 'Arial'
Global $FORMATLV_LAST_FONT_SIZE   = $FORMATLV_DEF_SIZE
Global $FORMATLV_LAST_FONT_WEIGHT = $FORMATLV_DEF_WEIGHT
Global $FORMATLV_LAST_FONT_TYPE   = $FORMATLV_DEF_FONT
Global $FORMATLV_LAST_COL         = $FORMATLV_DEF_COL
Global $FORMATLV_LAST_BKCOL       = $FORMATLV_DEF_BKCOL
Global $FORMATLV_LAST_DEF         = False
Global $FORMATLV_aHWND, $FORMATLV_CURR_WINDOW, $FORMATLV_MAX_COLUMN, $FORMATLV_aIPARAM[1][1][5]
Global $FORMATLV_oPARAM_SEARCH, $FORMATLV_hFONT, $FORMATLV_B_DESCENDING

Func _GUICtrlListView_Formatting_Startup($hGUI, $hListView)
	$FORMATLV_hGUI = $hGUI
	; initialize Callback Function to analyze $WM_NOTIFY
	$FORMATLV_hPROC = DllCallbackRegister('_WinProc', 'ptr', 'hwnd;uint;wparam;lparam')
	$FORMATLV_hHOOK = _WinAPI_SetWindowLong($FORMATLV_hGUI, $GWL_WNDPROC, DllCallbackGetPtr($FORMATLV_hPROC))
	Local $count
	If IsArray($hListView) Then
		$FORMATLV_MAX_COLUMN = _GUICtrlListView_GetColumnCount($hListView[0])
		For $i = 0 To UBound($hListView) -1
			If Not IsHWnd($hListView[$i]) Then
				$hListView[$i] = GUICtrlGetHandle($hListView[$i])
			EndIf
			$count = _GUICtrlListView_GetColumnCount($hListView[$i])
			If $count > $FORMATLV_MAX_COLUMN Then
				$FORMATLV_MAX_COLUMN = $count
			EndIf
		Next
		$FORMATLV_aHWND = $hListView
	Else
		If Not IsHWnd($hListView) Then
			$hListView = GUICtrlGetHandle($hListView)
		EndIf
		$FORMATLV_MAX_COLUMN = _GUICtrlListView_GetColumnCount($hListView)
		Local $aTmp[1] = [$hListView]
		$FORMATLV_aHWND = $aTmp
	EndIf
	ReDim $FORMATLV_aIPARAM[1][$FORMATLV_MAX_COLUMN+1][5] ; [n][0][0]=ItemStruct, [n][1..Count][0..4]=SubItemValue
	$FORMATLV_oPARAM_SEARCH = ObjCreate('Scripting.Dictionary')
	$FORMATLV_CURR_WINDOW = $FORMATLV_hGUI
	If Not IsHWnd($FORMATLV_CURR_WINDOW) Then $FORMATLV_CURR_WINDOW = WinGetHandle($FORMATLV_CURR_WINDOW)
EndFunc  ;==>_GUICtrlListView_Formatting_Startup

Func _GUICtrlListView_Formatting_Shutdown()
	$FORMATLV_aIPARAM = 0
	$FORMATLV_oPARAM_SEARCH = 0
	_WinAPI_SetWindowLong($FORMATLV_hGUI, $GWL_WNDPROC, $FORMATLV_hHOOK) ; to reconstruct original WinProcedure
EndFunc  ;==>_GUICtrlListView_Formatting_Shutdown

Func _GUICtrlListView_DefaultsSet($iBkCol=0xFFFFFF, $iCol=0x000000, $iSize=14, $iWeight=400, $sFont='Arial')
    $FORMATLV_DEF_BKCOL  = $iBkCol
    $FORMATLV_DEF_COL    = $iCol
    $FORMATLV_DEF_SIZE   = $iSize
    $FORMATLV_DEF_WEIGHT = $iWeight
    $FORMATLV_DEF_FONT   = $sFont
	_WinAPI_RedrawWindow($FORMATLV_CURR_WINDOW)
EndFunc  ;==>_GUICtrlListView_DefaultsSet

Func _GUICtrlListView_DefaultsGet()
	Local $aRet[5] = [ _
					$FORMATLV_DEF_BKCOL, _
					$FORMATLV_DEF_COL, _
					$FORMATLV_DEF_SIZE, _
					$FORMATLV_DEF_WEIGHT, _
					$FORMATLV_DEF_FONT]
	Return $aRet
EndFunc  ;==>_GUICtrlListView_DefaultsGet

Func _GUICtrlListView_AddOrIns_Item($hWnd, $vText, $iItem=-1)
	Local $tagITEMPARAM = "int_ptr;byte[" & $FORMATLV_MAX_COLUMN & "];", $tITEMPARAM, $aItem = $vText, $aItemTxt, $1stItemFilled = 0
	Local $lastIndex, $bAdd = False, $ub_aItem, $ub_aIPARAM, $DataSep = Opt('GUIDataSeparatorChar')
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	Local $itemCount = _GUICtrlListView_GetItemCount($hWnd)
; == if not is array $vText ==> create array
	If Not IsArray($aItem) Then
		Local $aTmp[1] = [$aItem]
		$aItem = $aTmp
	EndIf
	$ub_aItem = UBound($aItem)
; == check insert position ($iItem)
	Select
		Case ( $iItem < 0 ) Or ( $iItem >= $itemCount ); append at the end
			$iItem = -1
			$bAdd = True
		Case $iItem < $itemCount
			$bAdd = False
	EndSelect
; == one item or array of item - append/insert
	; == increase array if necessary
	$ub_aIPARAM = UBound($FORMATLV_aIPARAM)
	$lastIndex = $ub_aIPARAM -1
	$1stItemFilled = IsDllStruct($FORMATLV_aIPARAM[0][0][0])
	If $1stItemFilled = 1 Then  ; == 1st entry not empty
		ReDim $FORMATLV_aIPARAM[$ub_aIPARAM +$ub_aItem][$FORMATLV_MAX_COLUMN+1][5]
		$lastIndex += 1
	Else                        ; == 1st entry is empty
		If $ub_aItem > 1 Then
			ReDim $FORMATLV_aIPARAM[$ub_aIPARAM +$ub_aItem -1][$FORMATLV_MAX_COLUMN+1][5]
		EndIf
	EndIf
	For $i = 0 To $ub_aItem -1
		$1stItemFilled = IsDllStruct($FORMATLV_aIPARAM[0][0][0])
		; == create structure, fill with zeros, store to array
		; == storage index from array stored about integer pointer in an dictionary object: key=IntegerPointer, val=ArrayIndex
		$tITEMPARAM = DllStructCreate($tagITEMPARAM)
		DllStructSetData($tITEMPARAM, 1, DllStructGetPtr($tITEMPARAM, 2))
		For $j = 1 To $FORMATLV_MAX_COLUMN
			DllStructSetData($tITEMPARAM, 2, 0, $j)
		Next
		If $1stItemFilled = 0 Then
			$FORMATLV_aIPARAM[0][0][0] = $tITEMPARAM
			$FORMATLV_oPARAM_SEARCH.Add(DllStructGetData($tITEMPARAM, 1), 0)
		Else
			$FORMATLV_aIPARAM[$lastIndex +$i][0][0] = $tITEMPARAM
			$FORMATLV_oPARAM_SEARCH.Add(DllStructGetData($tITEMPARAM, 1), $lastIndex +$i)
		EndIf
		; == create listview -Item, -SubItem, store IntegerPointer as ItemParam
		$aItemTxt = StringSplit($aItem[$i], $DataSep, 1)
		If $bAdd Then
			$iItem = _GUICtrlListView_AddItem($hWnd, $aItemTxt[1])
		Else
			_GUICtrlListView_InsertItem($hWnd, $aItemTxt[1], $iItem)
		EndIf
		_GUICtrlListView_SetItemParam($hWnd, $iItem, DllStructGetData($tITEMPARAM, 1) +$SHIFT_PARAMVALUE)
		If $aItemTxt[0] > 1 Then
			For $j = 2 To UBound($aItemTxt) -1
				_GUICtrlListView_AddSubItem($hWnd, $iItem, $aItemTxt[$j], $j-1)
			Next
		EndIf
	Next
EndFunc  ;==>_GUICtrlListView_AddOrIns_Item

Func _GUICtrlListView_FormattedDeleteItem($hWnd, $iIndex)
	Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iIndex) -$SHIFT_PARAMVALUE
	$FORMATLV_aIPARAM[$FORMATLV_oPARAM_SEARCH.Item($iParam)][0][0] = ''
	$FORMATLV_oPARAM_SEARCH.Remove($iParam)
	_GUICtrlListView_DeleteItem($hWnd, $iIndex)
EndFunc  ;==>_GUICtrlListView_FormattedDeleteItem

Func _GUICtrlListView_FormattedDeleteItemsSelected($hWnd)
	Local $aSelected = _GUICtrlListView_GetSelectedIndices($hWnd, True)
	For $i = 1 To $aSelected[0]
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $aSelected[$i]) -$SHIFT_PARAMVALUE
		$FORMATLV_aIPARAM[$FORMATLV_oPARAM_SEARCH.Item($iParam)][0][0] = ''
		$FORMATLV_oPARAM_SEARCH.Remove($iParam)
		_GUICtrlListView_DeleteItem($hWnd, $aSelected[$i])
	Next
EndFunc  ;==>_GUICtrlListView_FormattedDeleteItemsSelected

Func _GUICtrlListView_FormattedDeleteAllItems($hWnd)
	Local $item = _GUICtrlListView_GetItemCount($hWnd)
	For $i = 0 To $item -1
		Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $i) -$SHIFT_PARAMVALUE
		$FORMATLV_aIPARAM[$FORMATLV_oPARAM_SEARCH.Item($iParam)][0][0] = ''
		$FORMATLV_oPARAM_SEARCH.Remove($iParam)
	Next
 	_GUICtrlListView_DeleteAllItems($hWnd)
EndFunc  ;==>_GUICtrlListView_FormattedDeleteAllItems

Func _GUICtrlListView_FormattingCell($hWnd, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
	Local $sumParam = 0
	Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iItem) -$SHIFT_PARAMVALUE
	Local $index = $FORMATLV_oPARAM_SEARCH.Item($iParam)
	If $iBkCol = -1 Then
		$iBkCol = $FORMATLV_DEF_BKCOL
		$sumParam += 1
	EndIf
	If $iCol = -1 Then
		$iCol = $FORMATLV_DEF_COL
		$sumParam += 1
	EndIf
	If $iSize = -1 Then
		$iSize = $FORMATLV_DEF_SIZE
		$sumParam += 1
	EndIf
	If $iWeight = -1 Then
		$iWeight = $FORMATLV_DEF_WEIGHT
		$sumParam += 1
	EndIf
	If $sFont = -1 Then
		$sFont = $FORMATLV_DEF_FONT
		$sumParam += 1
	EndIf
	$FORMATLV_aIPARAM[$index][$iSubItem+1][0] = $iBkCol
	$FORMATLV_aIPARAM[$index][$iSubItem+1][1] = $iCol
	$FORMATLV_aIPARAM[$index][$iSubItem+1][2] = $iSize
	$FORMATLV_aIPARAM[$index][$iSubItem+1][3] = $iWeight
	$FORMATLV_aIPARAM[$index][$iSubItem+1][4] = $sFont
	; if SubItem not registered in IParam OR all values by -1 (delete Sub from IParam) ==> switch Sub value in IParam
	Local $mark = DllStructGetData($FORMATLV_aIPARAM[$index][0][0], 2, $iSubItem+1)
	If Not $mark Or $sumParam = 5 Then
		DllStructSetData($FORMATLV_aIPARAM[$index][0][0], 2, BitXOR($mark, 1), $iSubItem+1)
	EndIf
	If DllStructGetData($FORMATLV_aIPARAM[$index][0][0], 2, $iSubItem+1) <> $mark Or $sumParam <> 5 Then
		_GUICtrlListView_RedrawItems($hWnd, $iItem, $iItem)
	EndIf
EndFunc  ;==>_GUICtrlListView_FormattingCell

Func __DrawItemCol(ByRef $hDC, ByRef $tCustDraw, $hWnd, $iItem, $iSubitem) ; draw formatted item
	Local $aDefFont[14] = [14,0,0,0,$FW_NORMAL,False,False,False, _
		  $DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS,$CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial']
	Local $iSZ = $FORMATLV_aIPARAM[$iItem][$iSubItem+1][2]
	Local $iWT = $FORMATLV_aIPARAM[$iItem][$iSubItem+1][3]
	Local $sTP = $FORMATLV_aIPARAM[$iItem][$iSubItem+1][4]
	Local $iTX = $FORMATLV_aIPARAM[$iItem][$iSubItem+1][1]
	Local $iBK = $FORMATLV_aIPARAM[$iItem][$iSubItem+1][0]
	Local $bFontChanged = False
	If ( $iSZ <> $FORMATLV_LAST_FONT_SIZE ) Or ( $iWT <> $FORMATLV_LAST_FONT_WEIGHT ) Or ( $sTP <> $FORMATLV_LAST_FONT_TYPE ) Then
		$aDefFont[0]  = $iSZ
		$aDefFont[4]  = $iWT
		$aDefFont[13] = $sTP
		$FORMATLV_LAST_FONT_SIZE   = $iSZ
		$FORMATLV_LAST_FONT_WEIGHT = $iWT
		$FORMATLV_LAST_FONT_TYPE   = $sTP
		$bFontChanged = True
	EndIf
	If ( $iTX <> $FORMATLV_LAST_COL ) Then
		DllStructSetData($tCustDraw, 'clrText', RGB2BGR($iTX))
		$FORMATLV_LAST_COL = $iTX
	EndIf
	If ( $iBK <> $FORMATLV_LAST_BKCOL ) Then
		DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($iBK))
		$FORMATLV_LAST_BKCOL = $iBK
	EndIf
	If $bFontChanged Then
		$FORMATLV_hFONT = _WinAPI_CreateFont($iSZ,$aDefFont[1],$aDefFont[2],$aDefFont[3],$iWT,$aDefFont[5],$aDefFont[6], _
						  $aDefFont[7],$aDefFont[8],$aDefFont[9],$aDefFont[10],$aDefFont[11],$aDefFont[12],$sTP)
		_WinAPI_SelectObject($hDC, $FORMATLV_hFONT)
		_WinAPI_DeleteObject($FORMATLV_hFONT)
	EndIf
	$FORMATLV_LAST_DEF = False
EndFunc  ;==>__DrawItemCol

Func __DrawDefault(ByRef $hDC, ByRef $tCustDraw) ; draw unformatted item
	If $FORMATLV_LAST_DEF Then Return
	$hDC = DllStructGetData($tCustDraw, 'hdc')
	DllStructSetData($tCustDraw, 'clrText', RGB2BGR($FORMATLV_DEF_COL))
	DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($FORMATLV_DEF_BKCOL))
	$FORMATLV_hFONT = _WinAPI_CreateFont(14,0,0,0,$FW_NORMAL,False,False,False,$DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS, _
			$CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial')
	_WinAPI_SelectObject($hDC, $FORMATLV_hFONT)
	_WinAPI_DeleteObject($FORMATLV_hFONT)
	$FORMATLV_LAST_DEF = True
	$FORMATLV_LAST_FONT_SIZE   = $FORMATLV_DEF_SIZE
	$FORMATLV_LAST_FONT_WEIGHT = $FORMATLV_DEF_WEIGHT
	$FORMATLV_LAST_FONT_TYPE   = $FORMATLV_DEF_FONT
	$FORMATLV_LAST_COL         = $FORMATLV_DEF_COL
	$FORMATLV_LAST_BKCOL       = $FORMATLV_DEF_BKCOL
EndFunc  ;==>__DrawDefault

Func __getMarked($hWnd, $iItem, $iSubItem) ; get index from array if item is formatted
	Local $cntCOL = _GUICtrlListView_GetColumnCount($hWnd)
	Local $iParam = _GUICtrlListView_GetItemParam($hWnd, $iItem) -$SHIFT_PARAMVALUE
	Local $struct = DllStructCreate("byte[" & $cntCOL & "]", $iParam)
	If DllStructGetData($struct, 1, $iSubItem+1) Then
		Return $FORMATLV_oPARAM_SEARCH.Item($iParam)
	Else
		Return -1
	EndIf
EndFunc  ;==>__getMarked

Func RGB2BGR($iColor)
	Local $sH = Hex($iColor,6)
    Return '0x' & StringRight($sH, 2) & StringMid($sH,3,2) & StringLeft($sH, 2)
EndFunc  ;==>RGB2BGR

Func _WinProc($hWnd, $Msg, $wParam, $lParam)
    If $Msg <> $WM_NOTIFY Then Return _WinAPI_CallWindowProc($FORMATLV_hHOOK, $hWnd, $Msg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")

	For $i = 0 To UBound($FORMATLV_aHWND) -1
		If $hWndFrom = $FORMATLV_aHWND[$i] Then
            Switch $iCode
				Case $LVN_COLUMNCLICK
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					__GUICtrlListView_SimpleSort($hWndFrom, $FORMATLV_B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
                Case $NM_CUSTOMDRAW
                    If Not _GUICtrlListView_GetViewDetails($hWndFrom) Then Return $GUI_RUNDEFMSG
					Local $tCustDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
					Local $iDrawStage, $iItem, $iSubitem, $hDC = DllStructGetData($tCustDraw, 'hdc'), $tRect
                    $iDrawStage = DllStructGetData($tCustDraw, 'dwDrawStage')
                    Switch $iDrawStage
                        Case $CDDS_ITEMPREPAINT
                            Return $CDRF_NOTIFYSUBITEMDRAW
                        Case BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
                            $iItem = DllStructGetData($tCustDraw, 'dwItemSpec')
                            $iSubitem = DllStructGetData($tCustDraw, 'iSubItem')
							Local $index = __getMarked($hWndFrom, $iItem, $iSubitem)
							If $index = -1 Then
								__DrawDefault($hDC, $tCustDraw)
							Else
								__DrawItemCol($hDC, $tCustDraw, $hWndFrom, $index, $iSubitem)
							EndIf
                            Return $CDRF_NEWFONT
						EndSwitch
				Case $NM_RCLICK  ;== fill Global array $FORMATLV_aITEM_INDEX
					Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					Local $aInfo[9] = [True,$hWndFrom, DllStructGetData($tInfo, "Index"), DllStructGetData($tInfo, "SubItem")]
					If $aInfo[2] < 0 Then
						$aInfo[0] = False
						Return $GUI_RUNDEFMSG
					EndIf
					Local $isFormatted = __getMarked($hWndFrom, $aInfo[2], $aInfo[3]) ; always formatted?
					If $isFormatted = -1 Then
						For $i = 4 To 8
							$aInfo[$i] = -1
						Next
					Else ; read formatting values
						$aInfo[4] = $FORMATLV_aIPARAM[$aInfo[2]][$aInfo[3]+1][0]
						$aInfo[5] = $FORMATLV_aIPARAM[$aInfo[2]][$aInfo[3]+1][1]
						$aInfo[6] = $FORMATLV_aIPARAM[$aInfo[2]][$aInfo[3]+1][2]
						$aInfo[7] = $FORMATLV_aIPARAM[$aInfo[2]][$aInfo[3]+1][3]
						$aInfo[8] = $FORMATLV_aIPARAM[$aInfo[2]][$aInfo[3]+1][4]
					EndIf
					$FORMATLV_aITEM_INDEX = $aInfo
					; if desired - use this array now in main script
			EndSwitch
		EndIf
    Next
	; call default WinProcedure, which can be analyzed in main script with GuiRegisterMsg
    Return _WinAPI_CallWindowProc($FORMATLV_hHOOK, $hWnd, $Msg, $wParam, $lParam)
EndFunc   ;==>_WinProc

Func __GUICtrlListView_SimpleSort($hWnd, ByRef $vDescending, $iCol) ; modified to sort also IParam
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
		Local $a_lv[$items][$columns + 2], $i_selected ; add column for IParam  ### MODIFIED ###

		$i_selected = StringSplit(_GUICtrlListView_GetSelectedIndices($hWnd), $SeparatorChar)
		For $x = 0 To UBound($a_lv) - 1 Step 1
			If $iFocused = -1 Then
				If _GUICtrlListView_GetItemFocused($hWnd, $x) Then $iFocused = $x
			EndIf
			_GUICtrlListView_SetItemSelected($hWnd, $x, False)
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
			For $Y = 0 To UBound($a_lv, 2) - 3 Step 1  ;  ### MODIFIED ###
				_GUICtrlListView_SetItemText($hWnd, $x, $a_lv[$x][$Y], $Y)
			Next
			_GUICtrlListView_SetItemParam($hWnd, $x, $a_lv[$x][$Y+1])  ;  ### NEW ###
			For $Z = 1 To $i_selected[0]
				If $a_lv[$x][UBound($a_lv, 2) - 2] = $i_selected[$Z] Then  ;  ### MODIFIED ###
					If $a_lv[$x][UBound($a_lv, 2) - 2] = $iFocused Then  ;  ### MODIFIED ###
						_GUICtrlListView_SetItemSelected($hWnd, $x, True, True)
					Else
						_GUICtrlListView_SetItemSelected($hWnd, $x, True)
					EndIf
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

