; http://www.autoitscript.com/forum/index.php?showtopic=89654&view=findpost&p=644312
#cs ===============================================================================================
	Functions

	_SetItemParam($hWnd, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
		set params for an defined SubItem
		set off by calling with defaults

	_SetRowParam($hWnd, $iItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
		set params for one Row  by calling _SetItemParam in an loop for accordingly SubItem
		set off by calling with defaults

	_SetColumnParam($hWnd, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
		set params for one Column by calling _SetItemParam in an loop for accordingly SubItem
		set off by calling with defaults

	New settings are overwriting older ones.
	It's required to create listview with:  GUICtrlCreateListView().
	The state, if SubItem are formatted, are stored in IParam of every Item.
	IParam value are shifted to avoid complications with other (lower) Control-IDs.
	In moment i use only positive Values in IParam. So the count of columns are limitd by 31.
	If you want to use more columns, feel free to modulate the IParam management. :D

#ce ===============================================================================================

#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <StructureConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)

#region - GUI
$GUI = GUICreate("Listview Custom Draw         [ You can choose element by leftclick ]", 600, 440)
GUISetOnEvent($GUI_EVENT_CLOSE, '_exit')
$cListView1 = GUICtrlCreateListView("", 2, 2, 290, 250, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
$hListView1 = GUICtrlGetHandle($cListView1)
_GUICtrlListView_InsertColumn($hListView1, 0, "Column 1", 90)
_GUICtrlListView_InsertColumn($hListView1, 1, "Column 2", 90)
_GUICtrlListView_InsertColumn($hListView1, 2, "Column 3", 90)
$cListView2 = GUICtrlCreateListView("", 300, 2, 290, 250, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
$hListView2 = GUICtrlGetHandle($cListView2)
_GUICtrlListView_InsertColumn($hListView2, 0, "Column 1", 90)
_GUICtrlListView_InsertColumn($hListView2, 1, "Column 2", 90)
_GUICtrlListView_InsertColumn($hListView2, 2, "Column 3", 90)
For $i = 1 To 30 ; fill both LV
    _GUICtrlListView_AddItem($hListView1, "Row" & $i & ": Col 1", $i-1)
	_GUICtrlListView_AddItem($hListView2, "Row" & $i & ": Col 1", $i-1)
    For $j = 1 To 2
        _GUICtrlListView_AddSubItem ($hListView1, $i-1, "Row" & $i & ": Col " & $j+1, $j)
		_GUICtrlListView_AddSubItem ($hListView2, $i-1, "Row" & $i & ": Col " & $j+1, $j)
    Next
Next
GUICtrlCreateGroup(' Settings for ', 2, 255, 590, 40)
$rLV1 = GUICtrlCreateRadio('ListView 1', 130, 270, 150, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$rLV2 = GUICtrlCreateRadio('ListView 2', 430, 270, 150, 17)
GUICtrlCreateGroup('', -99, -99, 1, 1)
GUICtrlCreateGroup(' Settings ', 2, 315, 290, 120)
GUICtrlCreateLabel('Item', 32, 332, 50, 17)
GUICtrlCreateLabel('or Row', 32, 344, 50, 17)
$inItem = GUICtrlCreateInput('10', 80, 334, 25, 20)
GUICtrlCreateLabel('SubItem', 116, 332, 45, 17)
GUICtrlCreateLabel('or Column', 116, 344, 50, 17)
$inSubItem = GUICtrlCreateInput('1', 175, 334, 25, 20)
GUICtrlCreateLabel('( 0-Index )', 215, 337, 50, 17)
GUICtrlCreateGroup('', -99, -99, 1, 1)
GUICtrlCreateGroup(' Single Item ', 320, 315, 90, 120)
$btSet = GUICtrlCreateButton('Set', 340, 350, 50, 20)
GUICtrlSetOnEvent(-1, '_btSet')
$btOff = GUICtrlCreateButton('Off', 340, 390, 50, 20)
GUICtrlSetOnEvent(-1, '_btOff')
GUICtrlCreateGroup('', -99, -99, 1, 1)
GUICtrlCreateLabel('Bk-Color', 32, 370, 40, 17)
$inBkCol = GUICtrlCreateInput('0x3DF8FF', 80, 368, 60, 20)
GUICtrlCreateLabel('Color', 160, 370, 40, 17)
$inCol = GUICtrlCreateInput('0xFF0000', 200, 368, 60, 20)
GUICtrlCreateLabel('Font', 32, 405, 40, 17)
$inFont = GUICtrlCreateInput('14,600,Comic Sans MS', 80, 402, 180, 20)
GUICtrlCreateGroup(' Columns or rows ', 440, 315, 150, 120)
$rOneRow = GUICtrlCreateRadio('Single Row', 450, 340, 130)
GUICtrlSetState(-1, $GUI_CHECKED)
$rOneCol = GUICtrlCreateRadio('Single Column', 450, 370, 130)
$btSet2 = GUICtrlCreateButton('Set', 450, 407, 50, 18)
GUICtrlSetOnEvent(-1, '_btSetRorC')
$btOff2 = GUICtrlCreateButton('Off', 530, 407, 50, 18)
GUICtrlSetOnEvent(-1, '_btOffRorC')
GUICtrlCreateGroup('', -99, -99, 1, 1)
#endregion - GUI

#region - Global settings (needed, whenever you want to use formatting)
; create an array for every LV with same count of elements like in LV
; IMPORTANT:
; By deleting an LV-Item it's required to delete also the according item from array!
; Also by insert an item in LV or sort LV you must modulate the array!
; [Item][SubItem][0] = iBkCol
; [Item][SubItem][1] = iCol
; [Item][SubItem][2] = iSize
; [Item][SubItem][3] = iWeight
; [Item][SubItem][4] = sFont
Global $aLV1[_GUICtrlListView_GetItemCount($hListView1)][_GUICtrlListView_GetColumnCount($hListView1)][5]
Global $aLV2[_GUICtrlListView_GetItemCount($hListView2)][_GUICtrlListView_GetColumnCount($hListView2)][5]
; create array to hold ListView-handle and accordingly array
Global $ahWndSets[2][2] = [[$hListView1,$aLV1],[$hListView2,$aLV2]]
Global $lvParam, $hFont, $defColLV = 0x000000, $defBkColLV = 0xFFFFFF
Global Const $INDEXSHIFT = 9999 ; need to avoid complications with other (lower) Control-ID
#endregion - Global settings

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState(@SW_SHOW, $GUI)

While True
	Sleep(100)
WEnd

Func _exit()
	_WinAPI_DeleteObject($hFont)
	Exit
EndFunc  ;==>_exit

Func _GetLV() ; return currently choosed listview
	If BitAND(GUICtrlRead($rLV1), $GUI_CHECKED) Then
		Return $hListView1
	Else
		Return $hListView2
	EndIf
EndFunc  ;==>_GetLV

Func _SetInput($aRet) ; in example: set radio state, item, subitem if clicked in listview
	If $aRet[0] = $hListView1 Then
		GUICtrlSetState($rLV1, $GUI_CHECKED)
	Else
		GUICtrlSetState($rLV2, $GUI_CHECKED)
	EndIf
	GUICtrlSetData($inItem, $aRet[1])
	GUICtrlSetData($inSubItem, $aRet[2])
EndFunc

Func _btSet() ; in example: set format for an single SubItem
	$setIndex = GUICtrlRead($inItem)
	$setSubIndex = GUICtrlRead($inSubItem)
	If ($setIndex <> '' And $setSubIndex <> '') Then
		Local $aFont = StringSplit(GUICtrlRead($inFont), ',')
		_SetItemParam(_GetLV(), $setIndex, $setSubIndex, GUICtrlRead($inBkCol), GUICtrlRead($inCol), $aFont[1], $aFont[2], $aFont[3])
	EndIf
EndFunc  ;==>_btSet

Func _btOff() ; in example: set format for an single SubItem off
	$setIndex = GUICtrlRead($inItem)
	$setSubIndex = GUICtrlRead($inSubItem)
	If ($setIndex <> '' And $setSubIndex <> '') And BitAND(__GUICtrlListView_GetItemParam(_GetLV(), $setIndex), 2^$setSubIndex) Then _
		_SetItemParam(_GetLV(), $setIndex, $setSubIndex, -1, -1, -1, -1, -1)
EndFunc  ;==>_btOff

Func _btSetRorC() ; in example: set format for one Row or Column
	If BitAND(GUICtrlRead($rOneRow), $GUI_CHECKED) Then
		$setIndex = GUICtrlRead($inItem)
		If $setIndex = '' Then Return
		_GUICtrlListView_BeginUpdate(_GetLV())
		Local $aFont = StringSplit(GUICtrlRead($inFont), ',')
		_SetRowParam(_GetLV(), $setIndex, GUICtrlRead($inBkCol), GUICtrlRead($inCol), $aFont[1], $aFont[2], $aFont[3])
		_GUICtrlListView_EndUpdate(_GetLV())
	Else
		$setSubIndex = GUICtrlRead($inSubItem)
		If $setSubIndex = '' Then Return
		_GUICtrlListView_BeginUpdate(_GetLV())
		Local $aFont = StringSplit(GUICtrlRead($inFont), ',')
		_SetColumnParam(_GetLV(), $setSubIndex, GUICtrlRead($inBkCol), GUICtrlRead($inCol), $aFont[1], $aFont[2], $aFont[3])
		_GUICtrlListView_EndUpdate(_GetLV())
	EndIf
EndFunc  ;==>_btSetRorC

Func _btOffRorC() ; in example: set format for one Row or Column off
	If BitAND(GUICtrlRead($rOneRow), $GUI_CHECKED) Then
		$setIndex = GUICtrlRead($inItem)
		If $setIndex = '' Then Return
		_GUICtrlListView_BeginUpdate(_GetLV())
		_SetRowParam(_GetLV(), $setIndex, -1, -1, -1, -1, -1)
		_GUICtrlListView_EndUpdate(_GetLV())
	Else
		$setSubIndex = GUICtrlRead($inSubItem)
		If $setSubIndex = '' Then Return
		_GUICtrlListView_BeginUpdate(_GetLV())
		_SetColumnParam(_GetLV(), $setSubIndex, -1, -1, -1, -1, -1)
		_GUICtrlListView_EndUpdate(_GetLV())
	EndIf
EndFunc  ;==>_btOffRorC

Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hListView1, $hListView2
            Switch $iCode
				Case $NM_CLICK ; only to set index to input in example
                    Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					Local $aRet[3] = [$hWndFrom, DllStructGetData($tInfo, "Index"), DllStructGetData($tInfo, "SubItem")]
                    Return _SetInput($aRet)
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
							If BitAND(__GUICtrlListView_GetItemParam($hWndFrom, $iItem), 2^$iSubitem) Then
								_DrawItemCol($hDC, $tCustDraw, $hWndFrom, $iItem, $iSubitem)
							Else
								_DrawDefault($hDC, $tCustDraw)
							EndIf
                            Return $CDRF_NEWFONT
                    EndSwitch
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

; use _SetItemParam() with defaults to set off
; to mark an SubItem as set, 2^SubItem-index are stored in ItemParam as sum for all SubItem,
; so the max. count of columns are 31 !!
Func _SetItemParam($hWnd, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
	Local $accArray, $sumParam = 0
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWnd Then
			$accArray = $ahWndSets[$i][1] ; temp array
			ExitLoop
		EndIf
	Next
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
	$accArray[$iItem][$iSubItem][0] = $iBkCol
	$accArray[$iItem][$iSubItem][1] = $iCol
	$accArray[$iItem][$iSubItem][2] = $iSize
	$accArray[$iItem][$iSubItem][3] = $iWeight
	$accArray[$iItem][$iSubItem][4] = $sFont
	$ahWndSets[$i][1] = $accArray ; write back to original array
	; if SubItem not registered in IParam OR all values by -1 (delete Sub from IParam) ==> switch Sub value in IParam
	If ( Not BitAND(__GUICtrlListView_GetItemParam($hWnd, $iItem), 2^$iSubItem) ) Or ( $sumParam = 5 ) Then _
		__GUICtrlListView_SetItemParam($hWnd, $iItem, BitXOR(__GUICtrlListView_GetItemParam($hWnd, $iItem), 2^$iSubItem))
	If BitAND(__GUICtrlListView_GetItemParam($hWnd, $iItem), 2^$iSubItem) Then _WinAPI_InvalidateRect($hWnd) ; only if values changed
EndFunc  ;==>_SetItemParam

Func _SetRowParam($hWnd, $iItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
	For $i = 0 To _GUICtrlListView_GetColumnCount($hWnd)-1
		_SetItemParam($hWnd, $iItem, $i, $iBkCol, $iCol, $iSize, $iWeight, $sFont)
	Next
EndFunc  ;==>_SetRowParam

Func _SetColumnParam($hWnd, $iSubItem, $iBkCol=-1, $iCol=-1, $iSize=-1, $iWeight=-1, $sFont=-1)
	For $i = 0 To _GUICtrlListView_GetItemCount($hWnd)-1
		_SetItemParam($hWnd, $i, $iSubItem, $iBkCol, $iCol, $iSize, $iWeight, $sFont)
	Next
EndFunc  ;==>_SetColumnParam

Func _DrawItemCol(ByRef $hDC, ByRef $tCustDraw, $hWnd, $iItem, $iSubitem)
	Local $accArray
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWnd Then
			$accArray = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	Local $aDefFont[14] = [14,0,0,0,$FW_NORMAL,False,False,False, _
		  $DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS,$CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial']
	$aDefFont[0]  = $accArray[$iItem][$iSubItem][2]
	$aDefFont[4]  = $accArray[$iItem][$iSubItem][3]
	$aDefFont[13] = $accArray[$iItem][$iSubItem][4]
	$hDC = DllStructGetData($tCustDraw, 'hdc')
	DllStructSetData($tCustDraw, 'clrText', RGB2BGR($accArray[$iItem][$iSubItem][1]))
	DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($accArray[$iItem][$iSubItem][0]))
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

Func __GUICtrlListView_GetItemParam($hWnd, $iItem) ; modified for use indexshift
	Local $param = _GUICtrlListView_GetItemParam($hWnd, $iItem)
	If $param > 0 Then $param -= $INDEXSHIFT
	Return $param
EndFunc

Func __GUICtrlListView_SetItemParam($hWnd, $iItem, $iParam) ; modified for use indexshift
	_GUICtrlListView_SetItemParam($hWnd, $iItem, $INDEXSHIFT + $iParam)
EndFunc

Func RGB2BGR($iColor)
	Local $sH = Hex($iColor,6)
    Return '0x' & StringRight($sH, 2) & StringMid($sH,3,2) & StringLeft($sH, 2)
EndFunc  ;==>RGB2BGR
