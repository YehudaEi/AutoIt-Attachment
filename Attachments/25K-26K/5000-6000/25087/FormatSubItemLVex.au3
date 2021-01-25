#Include <Array.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <StructureConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

#cs
===================================================================================================
Functions for setting colors/fonts:
	
===================================================================================================
	SubItem-Mode  
===================================================================================================
_SubItemColSet($hWndFrom, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $sFont='-14,0,0,0,400,False,False,False,1,0,0,0,0,Arial')
	Formatting (color und font) for given SubItem
	$sFont as 'Font short' or 'Font long' ==> see region declarations
	(exists always formatting for this SubItem, it will set back at first)
	
_SubItemColOff($hWndFrom, $iItem, $iSubItem)
	Set back formatting for given SubItem

_CheckToFormatted($hWndFrom, $iItem, $iSubItem)
	Checks if given SubItem always formatted
	Returns True/False

===================================================================================================	
	Row/Column-Mode  (existing settings will erased with every command)
===================================================================================================
_OneColumnSetCol($hWndFrom, $iIndex, $iBkCol=-1, $iCol=-1)
	Set colors for an single column (-1: $defColLV / $defBkColLV)
	
_OneRowSetCol($hWndFrom, $iIndex, $iBkCol=-1, $iCol=-1)
	Set colors for an single row (-1: $defColLV / $defBkColLV)

_ColumnsSetCol($hWndFrom, $iOddCol=-1, $iEvenCol=-1)
	Coloring columns rotatory (-1: odd=$defBkColLV, even=$defColLV)

_RowsSetCol($hWndFrom, $iOddCol=-1, $iEvenCol=-1)
	Coloring rows rotatory (-1: odd=$defBkColLV, even=$defColLV)

_ColRowOff($hWndFrom)
	Formatting in Row/Column set back
===================================================================================================	
#ce

#region - required declarations for coloring and font
Global $hFont, $defColLV = 0x000000, $defBkColLV = 0xFFFFFF
; Font long = -$nHeight, $nWidth[, $nEscape = 0[, $nOrientn = 0[, $fnWeight = $FW_NORMAL[, 
;          $bItalic = False[, $bUnderline = False[, $bStrikeout = False[, $nCharset = $DEFAULT_CHARSET[, 
;          $nOutputPrec = $OUT_DEFAULT_PRECIS[, $nClipPrec = $CLIP_DEFAULT_PRECIS[, $nQuality = $DEFAULT_QUALITY[, 
;          $nPitch = 0[, $szFace = 'Arial']]]]]]]]]]]])]
; for distinction: 
;          $nHeight with leading '-' by using Font long !!
; Font short = $nHeight, $fnWeight, $szFace

Global $aSubItemSet1[1][5] = [[-1]]	; [$i][$iItem, $iSubItem, $iBkCol, $iCol, $sFont]
Global $aSubItemSet2[1][5] = [[-1]]
Global $ahWndSets[2][2] = [[0,$aSubItemSet1],[0,$aSubItemSet2]] ; holds ListView-handle and accordingly array
;~ if [0][0] = -1
;~ $aSubItemSet[0][1] = 0 SubItem-Mode, -1 rows rotatory, -2 columns rotatory, -3 single row, -4 single column
;~ $aSubItemSet[0][2] = odd row/column Bk-Color or single row/column Bk-Color
;~ $aSubItemSet[0][3] = even row/column Bk-Color or single row/column Text-Color
;~ $aSubItemSet[0][4] = row or column (if [0][1]= -3 or -4)
#endregion

Global $setIndex, $setSubIndex

$GUI = GUICreate("Listview Custom Draw", 600, 440)
$cListView1 = GUICtrlCreateListView("", 2, 2, 290, 250, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
$hListView1 = GUICtrlGetHandle($cListView1)
$ahWndSets[0][0] = $hListView1
_GUICtrlListView_InsertColumn($hListView1, 0, "Column 1", 90)
_GUICtrlListView_InsertColumn($hListView1, 1, "Column 2", 90)
_GUICtrlListView_InsertColumn($hListView1, 2, "Column 3", 90)
For $i = 1 To 30
    _GUICtrlListView_AddItem($hListView1, "Row" & $i & ": Col 1", $i-1)
    For $j = 1 To 2
        _GUICtrlListView_AddSubItem ($hListView1, $i-1, "Row" & $i & ": Col " & $j+1, $j)
    Next
Next
$cListView2 = GUICtrlCreateListView("", 300, 2, 290, 250, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
$hListView2 = GUICtrlGetHandle($cListView2)
$ahWndSets[1][0] = $hListView2
_GUICtrlListView_InsertColumn($hListView2, 0, "Column 1", 90)
_GUICtrlListView_InsertColumn($hListView2, 1, "Column 2", 90)
_GUICtrlListView_InsertColumn($hListView2, 2, "Column 3", 90)
For $i = 1 To 30
    _GUICtrlListView_AddItem($hListView2, "Row" & $i & ": Col 1", $i-1)
    For $j = 1 To 2
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
$btOff = GUICtrlCreateButton('Off', 340, 390, 50, 20)
GUICtrlCreateGroup('', -99, -99, 1, 1)
GUICtrlCreateLabel('Bk-Color', 32, 366, 40, 17)
GUICtrlCreateLabel('or odd', 32, 378, 40, 17)
$inBkCol = GUICtrlCreateInput('0x3DF8FF', 80, 368, 60, 20)
GUICtrlCreateLabel('Color', 160, 366, 40, 17)
GUICtrlCreateLabel('or even', 160, 378, 40, 17)
$inCol = GUICtrlCreateInput('0xFF0000', 200, 368, 60, 20)
GUICtrlCreateLabel('Font', 32, 405, 40, 17)
$inFont = GUICtrlCreateInput('14,600,Comic Sans MS', 80, 402, 180, 20)
GUICtrlCreateGroup(' Columns or rows ', 440, 315, 150, 120)
$rRows = GUICtrlCreateRadio('Rows rotatory', 445, 330, 130)
GUICtrlSetState(-1, $GUI_CHECKED)
$rCols = GUICtrlCreateRadio('Columns rotatory', 445, 350, 130)
$rOneRow = GUICtrlCreateRadio('Single Row', 445, 370, 130)
$rOneCol = GUICtrlCreateRadio('Single Column', 445, 390, 130)
$btSet2 = GUICtrlCreateButton('Set', 450, 412, 50, 18)
$btOff2 = GUICtrlCreateButton('Off', 530, 412, 50, 18)
GUICtrlCreateGroup('', -99, -99, 1, 1)


GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState()

While True
	$msg = GUIGetMsg()
	Switch $msg
		Case -3
			ExitLoop
		Case $btSet
			$setIndex = GUICtrlRead($inItem)
			$setSubIndex = GUICtrlRead($inSubItem)
			If ($setIndex <> '' And $setSubIndex <> '') Then _
				_SubItemColSet(_GetLV(), $setIndex, $setSubIndex, GUICtrlRead($inBkCol), GUICtrlRead($inCol), GUICtrlRead($inFont))
		Case $btOff
			$setIndex = GUICtrlRead($inItem)
			$setSubIndex = GUICtrlRead($inSubItem)
			If ($setIndex <> '' And $setSubIndex <> '') Then _
				_SubItemColOff(_GetLV(), $setIndex, $setSubIndex)
		Case $btSet2
			If BitAND(GUICtrlRead($rRows), $GUI_CHECKED) Then
				_RowsSetCol(_GetLV(), GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			ElseIf BitAND(GUICtrlRead($rCols), $GUI_CHECKED) Then
				_ColumnsSetCol(_GetLV(), GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			ElseIf BitAND(GUICtrlRead($rOneRow), $GUI_CHECKED) Then
				_OneRowSetCol(_GetLV(), GUICtrlRead($inItem), GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			Else
				_OneColumnSetCol(_GetLV(), GUICtrlRead($inSubItem), GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			EndIf
		Case $btOff2
			_ColRowOff(_GetLV())
	EndSwitch
WEnd
_WinAPI_DeleteObject($hFont)
Exit


Func _GetLV()
	If BitAND(GUICtrlRead($rLV1), $GUI_CHECKED) Then
		Return $hListView1
	Else
		Return $hListView2
	EndIf
EndFunc

#region - functions for setting color and font
Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hListView1, $hListView2
            Switch $iCode
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
							_SetItemCol($hDC, $tCustDraw, $hWndFrom, $iItem, $iSubitem)
                            Return $CDRF_NEWFONT
                    EndSwitch
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _SetItemCol(ByRef $hDC, ByRef $tCustDraw, $hWndFrom, $iItem, $iSubitem)
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	If $aSubItemSet[0][0] = -1 Then 
		If $aSubItemSet[0][1] < 0 Then
			Switch $aSubItemSet[0][1]
				Case -1 ; rows rotatory
					If Mod($iItem, 2) Then ; odd
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][2]))
					Else                   ; even
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][3]))
					EndIf
				Case -2 ; columns rotatory
					If Mod($iSubItem, 2) Then ; odd
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][2]))
					Else                      ; even
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][3]))
					EndIf
				Case -3 ; single row
					If $iItem = $aSubItemSet[0][4] Then
						DllStructSetData($tCustDraw, 'clrText', RGB2BGR($aSubItemSet[0][3]))
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][2]))
					Else
						DllStructSetData($tCustDraw, 'clrText', RGB2BGR($defColLV))
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($defBkColLV))
					EndIf
				Case -4 ; single column
					If $iSubItem = $aSubItemSet[0][4] Then
						DllStructSetData($tCustDraw, 'clrText', RGB2BGR($aSubItemSet[0][3]))
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][2]))
					Else
						DllStructSetData($tCustDraw, 'clrText', RGB2BGR($defColLV))
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($defBkColLV))
					EndIf
				Case Else
					Return
			EndSwitch
			$hDC = DllStructGetData($tCustDraw, 'hdc')
			$hFont = _WinAPI_CreateFont(14,0,0,0,$FW_NORMAL,False,False,False,$DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS, _
					 $CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial')
			_WinAPI_SelectObject($hDC, $hFont)
		EndIf
	Else
		Local $indx, $aIndex = _ArrayFindAll($aSubItemSet, $iItem)
		If @error Then Return
		For $i = 0 To UBound($aIndex) -1
			If $aSubItemSet[$aIndex[$i]][1] = $iSubitem Then
				$indx = $aIndex[$i]
				ExitLoop
			EndIf
		Next
		Local $aDefFont[14] = [14,0,0,0,$FW_NORMAL,False,False,False, _
							  $DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS,$CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial']		
		Local $splitFont = StringSplit($aSubItemSet[$indx][4], ',')
		If StringLeft($splitFont[1], 1) <> '-' Then  ; short FontString? leading '-' is long string 
			$aDefFont[0]  = $splitFont[1]
			$aDefFont[4]  = $splitFont[2]
			$aDefFont[13] = $splitFont[3]
		Else
			For $i = 1 To UBound($splitFont) -1
				If $i = 1 Then
					$aDefFont[0] = StringTrimLeft($splitFont[1], 1)
				Else
					$aDefFont[$i-1] = $splitFont[$i]
				EndIf
			Next
		EndIf
		If ($aSubItemSet[$indx][0] = $iItem) And ($aSubItemSet[$indx][1] = $iSubitem) Then
			$hDC = DllStructGetData($tCustDraw, 'hdc')
			DllStructSetData($tCustDraw, 'clrText', RGB2BGR($aSubItemSet[$indx][3]))
			DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[$indx][2]))
			$hFont = _WinAPI_CreateFont($aDefFont[0],$aDefFont[1],$aDefFont[2],$aDefFont[3],$aDefFont[4],$aDefFont[5],$aDefFont[6], _
					 $aDefFont[7],$aDefFont[8],$aDefFont[9],$aDefFont[10],$aDefFont[11],$aDefFont[12],$aDefFont[13])
			_WinAPI_SelectObject($hDC, $hFont)
		Else
			$hDC = DllStructGetData($tCustDraw, 'hdc')
			DllStructSetData($tCustDraw, 'clrText', RGB2BGR($defColLV))
			DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($defBkColLV))
			$hFont = _WinAPI_CreateFont(14,0,0,0,$FW_NORMAL,False,False,False,$DEFAULT_CHARSET,$OUT_DEFAULT_PRECIS, _
					 $CLIP_DEFAULT_PRECIS,$DEFAULT_QUALITY,0,'Arial')
			_WinAPI_SelectObject($hDC, $hFont)
		EndIf
	EndIf
EndFunc  ;==>_SetItemCol

Func RGB2BGR($iColor)
	Local $sH = Hex($iColor,6)
    Return '0x' & StringRight($sH, 2) & StringMid($sH,3,2) & StringLeft($sH, 2)
EndFunc  ;==>RGB2BGR

Func _CheckToFormatted($hWndFrom, $iItem, $iSubItem)
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	Local $aItemFound = _ArrayFindAll($aSubItemSet, $iItem)
	If @error Then Return False
	For $i = 0 To UBound($aItemFound) -1
		If $aSubItemSet[$aItemFound[$i]][1] = $iSubItem Then Return True 
	Next
	Return False
EndFunc  ;==>_CheckToFormatted

Func _SubItemColSet($hWndFrom, $iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $sFont='-14,0,0,0,400,False,False,False,1,0,0,0,0,Arial')
	If _CheckToFormatted($hWndFrom, $iItem, $iSubItem) Then _SubItemColOff($hWndFrom, $iItem, $iSubItem)
	Local $Bk, $Col
	If $iBkCol = -1 Then $iBkCol = $defBkColLV
	If $iCol = -1 Then $iCol = $defColLV
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	If $aSubItemSet[0][0] <> -1 Then ReDim $aSubItemSet[UBound($aSubItemSet)+1][5]
	$aSubItemSet[UBound($aSubItemSet)-1][0] = $iItem
	$aSubItemSet[UBound($aSubItemSet)-1][1] = $iSubItem
	$aSubItemSet[UBound($aSubItemSet)-1][2] = $iBkCol
	$aSubItemSet[UBound($aSubItemSet)-1][3] = $iCol
	$aSubItemSet[UBound($aSubItemSet)-1][4] = $sFont
	$ahWndSets[$i][1] = $aSubItemSet
	_WinAPI_InvalidateRect($hWndFrom)
EndFunc  ;==>_SubItemColSet

Func _SubItemColOff($hWndFrom, $iItem, $iSubItem)
	Local $aSubItemSet
	For $k = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$k][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$k][1]
			ExitLoop
		EndIf
	Next
	Local $indx=-1
	Local $aIndex = _ArrayFindAll($aSubItemSet, $iItem)
	If @error Then Return
	For $i = 0 To UBound($aIndex) -1
		If $aSubItemSet[$aIndex[$i]][1] = $iSubitem Then
			$indx = $aIndex[$i]
			ExitLoop
		EndIf
	Next
	If $indx = -1 Then Return
	If UBound($aSubItemSet) > 1 Then
		_ArrayDelete($aSubItemSet, $indx)
	Else
		$aSubItemSet[0][0] = -1
		$aSubItemSet[0][1] = 0
		$aSubItemSet[0][2] = 0
		$aSubItemSet[0][3] = 0
		$aSubItemSet[0][4] = 0
	EndIf
	$ahWndSets[$k][1] = $aSubItemSet
	_WinAPI_InvalidateRect($hWndFrom)
EndFunc  ;==>_SubItemColOff

Func _OneColumnSetCol($hWndFrom, $iIndex, $iBkCol=-1, $iCol=-1)
	If $iBkCol = -1 Then $iBkCol = $defBkColLV
	If $iCol = -1 Then $iCol = $defColLV
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -4
	$aSubItemSet[0][2] = $iBkCol
	$aSubItemSet[0][3] = $iCol
	$aSubItemSet[0][4] = $iIndex
	$ahWndSets[$i][1] = $aSubItemSet
	_WinAPI_InvalidateRect($hWndFrom)
EndFunc  ;==>_OneColumnSetCol

Func _OneRowSetCol($hWndFrom, $iIndex, $iBkCol=-1, $iCol=-1)
	If $iBkCol = -1 Then $iBkCol = $defBkColLV
	If $iCol = -1 Then $iCol = $defColLV
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -3
	$aSubItemSet[0][2] = $iBkCol
	$aSubItemSet[0][3] = $iCol
	$aSubItemSet[0][4] = $iIndex
	$ahWndSets[$i][1] = $aSubItemSet
	_WinAPI_InvalidateRect($hWndFrom)
EndFunc  ;==>_OneRowSetCol

Func _ColumnsSetCol($hWndFrom, $iOddCol=-1, $iEvenCol=-1)
	If $iOddCol = -1 Then $iOddCol = $defBkColLV
	If $iEvenCol = -1 Then $iEvenCol = $defColLV
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -2
	$aSubItemSet[0][2] = $iOddCol
	$aSubItemSet[0][3] = $iEvenCol
	$ahWndSets[$i][1] = $aSubItemSet
	_WinAPI_InvalidateRect($hWndFrom)
EndFunc  ;==>_ColumnsSetCol

Func _RowsSetCol($hWndFrom, $iOddCol=-1, $iEvenCol=-1)
	If $iOddCol = -1 Then $iOddCol = $defBkColLV
	If $iEvenCol = -1 Then $iEvenCol = $defColLV
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -1
	$aSubItemSet[0][2] = $iOddCol
	$aSubItemSet[0][3] = $iEvenCol
	$ahWndSets[$i][1] = $aSubItemSet
	_WinAPI_InvalidateRect($hWndFrom)
EndFunc  ;==>_RowsSetCol

Func _ColRowOff($hWndFrom)
	Local $aSubItemSet
	For $i = 0 To UBound($ahWndSets) -1
		If $ahWndSets[$i][0] = $hWndFrom Then
			$aSubItemSet = $ahWndSets[$i][1]
			ExitLoop
		EndIf
	Next
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = 0
	$aSubItemSet[0][2] = 0
	$aSubItemSet[0][3] = 0
	$aSubItemSet[0][4] = 0
	$ahWndSets[$i][1] = $aSubItemSet
	_WinAPI_InvalidateRect($hWndFrom)
EndFunc  ;==>_ColRowOff
#endregion
