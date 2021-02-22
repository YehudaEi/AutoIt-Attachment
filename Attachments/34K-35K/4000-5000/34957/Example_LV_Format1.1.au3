#Region - TimeStamp
; 2011-08-08 15:26:08   v 1.1
#EndRegion - TimeStamp

#cs
	Initialize Global vars at startup
		_GUICtrlListView_Formatting_Startup($hGUI, $hListView)
			$hGUI        Handle of your GUI
			$hListView	Listview handle, for several LV commit handle's as array

	[ Clean up ressources ==> Changed! ==> now automatically called on AutoIt exit ]
		_GUICtrlListView_Formatting_Shutdown()

	Add or insert new Listview Item:
		_GUICtrlListView_AddOrIns_Item($hWnd, $sText, $iItem=-1)
			$hWnd	Listview handle
			$sText	lonely string to set only Item text (than SubItem must set with _GUICtrlListView_AddSubItem)
					or
					"Item|SubItem|SubItem.." to set all text at once
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

#ce


; == Variable: $FORMATLV_aITEM_INDEX
; == created as Global array variable inside include, filled with values in WM_NOTIFY() by right click [state formatting:TrueFalse, $hWndFrom, "Index", "SubItem", $iBkCol, $iCol, $iSize, $iWeight, $sFont]
; == how to use see Func _RightClick()

#include <GuiListView.au3>
#include <EditConstants.au3>
#include 'LV_Format_include.au3'


Local $col = ''
For $i = 1 To 6
	$col &= $i & '|'
Next

; Main GUI
$GUI = GUICreate('')
$lv = GUICtrlCreateListView(StringTrimRight($col,1), 10, 10, 300, 150)
$hLV = GUICtrlGetHandle($lv)
For $i = 0 To 5
	_GUICtrlListView_SetColumnWidth($hLV, $i, 49)
Next
$col = StringTrimRight($col, 2)
$lv2 = GUICtrlCreateListView(StringTrimRight($col,1), 10, 180, 300, 150)
$hLV2 = GUICtrlGetHandle($lv2)
For $i = 0 To 4
	_GUICtrlListView_SetColumnWidth($hLV2, $i, 59)
Next

; initialize Global vars
; for more than one Listview commit Listview handle as array
Local $aHWnd[2] = [$hLV,$hLV2]
_GUICtrlListView_Formatting_Startup($GUI, $aHWnd)
;~ _GUICtrlListView_Formatting_Startup($GUI, $hLV)

; add new Items
_GUICtrlListView_AddOrIns_Item($hLV, 'Test0|Test1|Test2|Test3|Test4|Test5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blub0|Blub1|Blub2|Blub3|Blub4|Blub5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Club0|Club1|Club2|Club3|Club4|Club5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Blab0|Blab1|Blab2|Blab3|Blab4|Blab5')
_GUICtrlListView_AddOrIns_Item($hLV, 'Bumm0|Bumm1|Bumm2|Bumm3|Bumm4|Bumm5')
; set format
_GUICtrlListView_FormattingCell($hLV, 0, 2, 0xff0000, -1, -1, 600, 'Times New Roman')
_GUICtrlListView_FormattingCell($hLV, 1, 3, 0xff0000, -1, -1, 400, 'Times New Roman')
_GUICtrlListView_FormattingCell($hLV, 1, 4, 0xffff00, -1, -1, 600, 'Comic Sans MS')

; add new Items from array
Local $aInsert[5] = [ _
					'Test0|Test1|Test2|Test3|Test4', _
					'Blub0|Blub1|Blub2|Blub3|Blub4', _
					'Club0|Club1|Club2|Club3|Club4', _
					'Blab0|Blab1|Blab2|Blab3|Blab4', _
					'Bumm0|Bumm1|Bumm2|Bumm3|Bumm4']
_GUICtrlListView_AddOrIns_Item($hLV2, $aInsert)
;~ ; set format
_GUICtrlListView_FormattingCell($hLV2, 0, 2, 0xff0000, -1, -1, 600, 'Times New Roman')
_GUICtrlListView_FormattingCell($hLV2, 1, 4, 0xffff00, -1, -1, 600, 'Comic Sans MS')
_GUICtrlListView_FormattingCell($hLV2, 1, 3, 0xff0000, -1, -1, 400, 'Times New Roman')

GUISetState(@SW_SHOW, $GUI)


; GUI formatting
GUICtrlCreateLabel('With right click on single SubItem' & @LF & 'will formatting GUI load', 10, 350, 300, 40)
$GUI_Format = GUICreate('set formatting', 200, 180)
GUICtrlCreateLabel('  Control        | Index row | column', 10, 10, 180, 17)
$ctrl = GUICtrlCreateInput('', 10, 30, 85, 20, $ES_READONLY)
$zeile = GUICtrlCreateInput('', 100, 30, 30, 20, BitOR($ES_READONLY,$ES_RIGHT))
$spalte = GUICtrlCreateInput('', 135, 30, 30, 20, BitOR($ES_READONLY,$ES_RIGHT))
GUICtrlCreateLabel('  BkColor     |   TextColor   |      Size', 10, 70, 180, 17)
$inBkCol = GUICtrlCreateInput('-1', 10, 90, 55, 20, $ES_RIGHT)
$inTxtCol = GUICtrlCreateInput('-1', 75, 90, 55, 20, $ES_RIGHT)
$inSize = GUICtrlCreateInput('-1', 140, 90, 50, 20, $ES_RIGHT)
GUICtrlCreateLabel('  Weight      |         Font', 10, 130, 150, 17)
$inWeight = GUICtrlCreateInput('-1', 10, 150, 50, 20, $ES_RIGHT)
$inFont = GUICtrlCreateInput('-1', 75, 150, 115, 20, $ES_RIGHT)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

;~ $timer = TimerInit()
While 1
;~ 	If TimerDiff($timer) >= 3000 Then
;~ 		ControlMove($GUI, '', $lv, 10, 10, 300+40, 150)
;~ 		_GUICtrlListView_AddOrIns_Column($hLV, -1, 'NEU', 40)
;~ 	EndIf
	$msg = GUIGetMsg(1)
	Switch $msg[1]
		Case $GUI
			If $msg[0] = -3 Then ExitLoop
		Case $GUI_Format
			If $msg[0] = -3 Then
				GUISetState(@SW_HIDE, $GUI_Format)
				_setFormat()
			EndIf
	EndSwitch
WEnd

Func _RightClick()
	If Not IsArray($FORMATLV_aITEM_INDEX) Then Return
	If Not $FORMATLV_aITEM_INDEX[0] Then Return
	$FORMATLV_aITEM_INDEX[0] = False
	GUICtrlSetData($ctrl, $FORMATLV_aITEM_INDEX[1])
	GUICtrlSetData($zeile, $FORMATLV_aITEM_INDEX[2])
	GUICtrlSetData($spalte, $FORMATLV_aITEM_INDEX[3])
	Local $bk = $FORMATLV_aITEM_INDEX[4]
	If $bk = -1 Then
		GUICtrlSetData($inBkCol, $bk)
	Else
		GUICtrlSetData($inBkCol, '0x' & Hex($bk,6))
	EndIf
	Local $tx = $FORMATLV_aITEM_INDEX[5]
	If $tx = -1 Then
		GUICtrlSetData($inTxtCol, $tx)
	Else
		GUICtrlSetData($inTxtCol, '0x' & Hex($tx,6))
	EndIf
	GUICtrlSetData($inSize, $FORMATLV_aITEM_INDEX[6])
	GUICtrlSetData($inWeight, $FORMATLV_aITEM_INDEX[7])
	GUICtrlSetData($inFont, $FORMATLV_aITEM_INDEX[8])
	GUISetState(@SW_SHOW, $GUI_Format)
EndFunc  ;==>_RightClick

Func _setFormat()
	Local $bk = GUICtrlRead($inBkCol)
	Local $tx = GUICtrlRead($inTxtCol)
	Local $sz = GUICtrlRead($inSize)
	Local $wt = GUICtrlRead($inWeight)
	Local $ft = GUICtrlRead($inFont)
	If $bk = '' Or $tx = '' Or $sz = '' Or $wt = '' Or $ft = '' Then Return
	_GUICtrlListView_FormattingCell($FORMATLV_aITEM_INDEX[1], $FORMATLV_aITEM_INDEX[2], $FORMATLV_aITEM_INDEX[3], $bk, $tx, $sz, $wt, $ft)
EndFunc  ;==>_setFormat

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    Local $hWndFrom, $iCode, $tNMHDR
    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")
    If ($hWndFrom = $hLV Or $hWndFrom = $hLV2) And $iCode = $NM_RCLICK Then _RightClick()
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
