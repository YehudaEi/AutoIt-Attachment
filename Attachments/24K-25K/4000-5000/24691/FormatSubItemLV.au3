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
_SubItemColSet($iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $sFont='-14,0,0,0,400,False,False,False,1,0,0,0,0,Arial')
	Formatting (color und font) for given SubItem
	$sFont as 'Font short' or 'Font long' ==> see region declarations
	(exists always formatting for this SubItem, it will set back at first)
	
_SubItemColOff($iItem, $iSubItem)
	Set back formatting for given SubItem

_CheckToFormatted($iItem, $iSubItem)
	Checks if given SubItem always formatted
	Returns True/False

===================================================================================================	
	Row/Column-Mode  (existing settings will erased with every command)
===================================================================================================
_OneColumnSetCol($iIndex, $iBkCol=-1, $iCol=-1)
	Set colors for an single column (-1: $defColLV / $defBkColLV)
	
_OneRowSetCol($iIndex, $iBkCol=-1, $iCol=-1)
	Set colors for an single row (-1: $defColLV / $defBkColLV)

_ColumnsSetCol($iOddCol=-1, $iEvenCol=-1)
	Coloring columns rotatory (-1: odd=$defBkColLV, even=$defColLV)

_RowsSetCol($iOddCol=-1, $iEvenCol=-1)
	Coloring rows rotatory (-1: odd=$defBkColLV, even=$defColLV)

_ColRowOff()
	Formatting in Row/Column set back
===================================================================================================	
#ce

#region - required declarations for coloring and font
Global $hFont, $defColLV = 0x000000, $defBkColLV = 0xFFFFFF
; Font long = $nHeight, $nWidth[, $nEscape = 0[, $nOrientn = 0[, $fnWeight = $FW_NORMAL[, 
;          $bItalic = False[, $bUnderline = False[, $bStrikeout = False[, $nCharset = $DEFAULT_CHARSET[, 
;          $nOutputPrec = $OUT_DEFAULT_PRECIS[, $nClipPrec = $CLIP_DEFAULT_PRECIS[, $nQuality = $DEFAULT_QUALITY[, 
;          $nPitch = 0[, $szFace = 'Arial']]]]]]]]]]]])]
; for distinction: 
;          $nHeight with leading '-' by using Font long !!
; Font short = $nHeight, $fnWeight, $szFace

Global $aSubItemSet[1][5] = [[-1]]	; [$i][$iItem, $iSubItem, $iBkCol, $iCol, $sFont]
;~ if [0][0] = -1
;~ $aSubItemSet[0][1] = 0 SubItem-Mode, -1 rows rotatory, -2 columns rotatory, -3 single row, -4 single column
;~ $aSubItemSet[0][2] = odd row/column Bk-Color or single row/column Bk-Color
;~ $aSubItemSet[0][3] = even row/column Bk-Color or single row/column Text-Color
;~ $aSubItemSet[0][4] = row or column (if [0][1]= -3 or -4)
#endregion

Global $setIndex, $setSubIndex

$GUI = GUICreate("Listview Custom Draw", 400, 440)
$cListView = GUICtrlCreateListView("", 2, 2, 394, 268, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
$hListView = GUICtrlGetHandle($cListView)
_GUICtrlListView_InsertColumn($hListView, 0, "Column 1", 100)
_GUICtrlListView_InsertColumn($hListView, 1, "Column 2", 100)
_GUICtrlListView_InsertColumn($hListView, 2, "Column 3", 100)
For $i = 1 To 30
    _GUICtrlListView_AddItem($hListView, "Row" & $i & ": Col 1", $i-1)
    For $j = 1 To 2
        _GUICtrlListView_AddSubItem ($hListView, $i-1, "Row" & $i & ": Col " & $j+1, $j)
    Next
Next
GUICtrlCreateLabel('Item', 2, 278, 50, 17)
GUICtrlCreateLabel('or Row', 2, 290, 50, 17)
$inItem = GUICtrlCreateInput('10', 50, 280, 25, 20)
GUICtrlCreateLabel('SubItem', 86, 278, 45, 17)
GUICtrlCreateLabel('or Column', 86, 290, 50, 17)
$inSubItem = GUICtrlCreateInput('1', 145, 280, 25, 20)
GUICtrlCreateLabel('( 0-Index )', 185, 283, 50, 17)
$btSet = GUICtrlCreateButton('Set', 260, 280, 50, 20)
$btOff = GUICtrlCreateButton('Off', 340, 280, 50, 20)
GUICtrlCreateLabel('Bk-Color', 2, 308, 40, 17)
GUICtrlCreateLabel('or odd', 2, 320, 40, 17)
$inBkCol = GUICtrlCreateInput('0x3DF8FF', 50, 310, 60, 20)
GUICtrlCreateLabel('Color', 130, 308, 40, 17)
GUICtrlCreateLabel('or even', 130, 320, 40, 17)
$inCol = GUICtrlCreateInput('0xFF0000', 170, 310, 60, 20)
GUICtrlCreateLabel('Font', 2, 343, 40, 17)
$inFont = GUICtrlCreateInput('14,700,Courier New', 50, 340, 180, 20)
GUICtrlCreateGroup(' Columns or rows', 240, 315, 150, 120)
$rRows = GUICtrlCreateRadio('Rows rotatory', 245, 330, 130)
GUICtrlSetState(-1, $GUI_CHECKED)
$rCols = GUICtrlCreateRadio('Columns rotatory', 245, 350, 130)
$rOneRow = GUICtrlCreateRadio('Single Row', 245, 370, 130)
$rOneCol = GUICtrlCreateRadio('Single Column', 245, 390, 130)
$btSet2 = GUICtrlCreateButton('Set', 250, 412, 50, 18)
$btOff2 = GUICtrlCreateButton('Off', 330, 412, 50, 18)
GUICtrlCreateGroup('', -99, -99, 1, 1)
$lbActiv = GUICtrlCreateLabel('Row/Column-Mode active', 40, 415, 200)
GUICtrlSetFont(-1, 10, 400, -1, 'Comic Sans MS')
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetState(-1, $GUI_HIDE)

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
				_SubItemColSet($setIndex, $setSubIndex, GUICtrlRead($inBkCol), GUICtrlRead($inCol), GUICtrlRead($inFont))
		Case $btOff
			$setIndex = GUICtrlRead($inItem)
			$setSubIndex = GUICtrlRead($inSubItem)
			If ($setIndex <> '' And $setSubIndex <> '') Then _
				_SubItemColOff($setIndex, $setSubIndex)
		Case $btSet2
			If BitAND(GUICtrlRead($rRows), $GUI_CHECKED) Then
				_RowsSetCol(GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			ElseIf BitAND(GUICtrlRead($rCols), $GUI_CHECKED) Then
				_ColumnsSetCol(GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			ElseIf BitAND(GUICtrlRead($rOneRow), $GUI_CHECKED) Then
				_OneRowSetCol(GUICtrlRead($inItem), GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			Else
				_OneColumnSetCol(GUICtrlRead($inSubItem), GUICtrlRead($inBkCol), GUICtrlRead($inCol))
			EndIf
		Case $btOff2
			_ColRowOff()
	EndSwitch
WEnd
_WinAPI_DeleteObject($hFont)
Exit

#region - functions for setting color and font
Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    Switch $hWndFrom
        Case $hListView
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
							_SetItemCol($hDC, $tCustDraw, $iItem, $iSubitem)
                            Return $CDRF_NEWFONT
                    EndSwitch
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _SetItemCol(ByRef $hDC, ByRef $tCustDraw, $iItem, $iSubitem)
	If $aSubItemSet[0][0] = -1 Then 
		If $aSubItemSet[0][1] < 0 Then
			Switch $aSubItemSet[0][1]
				Case -1 ; Zeilen abwechselnd färben
					If Mod($iItem, 2) Then ; ungerade
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][2]))
					Else
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][3]))
					EndIf
				Case -2 ; Spalten abwechselnd färben
					If Mod($iSubItem, 2) Then ; ungerade
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][2]))
					Else
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][3]))
					EndIf
				Case -3 ; einzelne Zeile färben
					If $iItem = $aSubItemSet[0][4] Then
						DllStructSetData($tCustDraw, 'clrText', RGB2BGR($aSubItemSet[0][3]))
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($aSubItemSet[0][2]))
					Else
						DllStructSetData($tCustDraw, 'clrText', RGB2BGR($defColLV))
						DllStructSetData($tCustDraw, 'clrTextBk', RGB2BGR($defBkColLV))
					EndIf
				Case -4 ; einzelne Spalte färben
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
		If StringLeft($splitFont[1], 1) <> '-' Then  ; alternativer FontString?
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

Func _CheckToFormatted($iItem, $iSubItem)
	Local $aItemFound = _ArrayFindAll($aSubItemSet, $iItem)
	If @error Then Return False
	For $i = 0 To UBound($aItemFound) -1
		If $aSubItemSet[$aItemFound[$i]][1] = $iSubItem Then Return True 
	Next
	Return False
EndFunc  ;==>_CheckToFormatted

Func _SubItemColSet($iItem, $iSubItem, $iBkCol=-1, $iCol=-1, $sFont='-14,0,0,0,400,False,False,False,1,0,0,0,0,Arial')
	If _CheckToFormatted($iItem, $iSubItem) Then _SubItemColOff($iItem, $iSubItem)
	Local $Bk, $Col
	If $iBkCol = -1 Then $iBkCol = $defBkColLV
	If $iCol = -1 Then $iCol = $defColLV
	If $aSubItemSet[0][0] <> -1 Then ReDim $aSubItemSet[UBound($aSubItemSet)+1][5]
	$aSubItemSet[UBound($aSubItemSet)-1][0] = $iItem
	$aSubItemSet[UBound($aSubItemSet)-1][1] = $iSubItem
	$aSubItemSet[UBound($aSubItemSet)-1][2] = $iBkCol
	$aSubItemSet[UBound($aSubItemSet)-1][3] = $iCol
	$aSubItemSet[UBound($aSubItemSet)-1][4] = $sFont
	_WinAPI_InvalidateRect($hListView)
EndFunc  ;==>_SubItemColSet

Func _SubItemColOff($iItem, $iSubItem)
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
	_WinAPI_InvalidateRect($hListView)
EndFunc  ;==>_SubItemColOff

Func _OneColumnSetCol($iIndex, $iBkCol=-1, $iCol=-1)
	If $iBkCol = -1 Then $iBkCol = $defBkColLV
	If $iCol = -1 Then $iCol = $defColLV
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -4
	$aSubItemSet[0][2] = $iBkCol
	$aSubItemSet[0][3] = $iCol
	$aSubItemSet[0][4] = $iIndex
	_WinAPI_InvalidateRect($hListView)
	GUICtrlSetState($lbActiv, $GUI_SHOW)
EndFunc  ;==>_OneColumnSetCol

Func _OneRowSetCol($iIndex, $iBkCol=-1, $iCol=-1)
	If $iBkCol = -1 Then $iBkCol = $defBkColLV
	If $iCol = -1 Then $iCol = $defColLV
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -3
	$aSubItemSet[0][2] = $iBkCol
	$aSubItemSet[0][3] = $iCol
	$aSubItemSet[0][4] = $iIndex
	_WinAPI_InvalidateRect($hListView)
	GUICtrlSetState($lbActiv, $GUI_SHOW)
EndFunc  ;==>_OneRowSetCol

Func _ColumnsSetCol($iOddCol=-1, $iEvenCol=-1)
	If $iOddCol = -1 Then $iOddCol = $defBkColLV
	If $iEvenCol = -1 Then $iEvenCol = $defColLV
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -2
	$aSubItemSet[0][2] = $iOddCol
	$aSubItemSet[0][3] = $iEvenCol
	_WinAPI_InvalidateRect($hListView)
	GUICtrlSetState($lbActiv, $GUI_SHOW)
EndFunc  ;==>_ColumnsSetCol

Func _RowsSetCol($iOddCol=-1, $iEvenCol=-1)
	If $iOddCol = -1 Then $iOddCol = $defBkColLV
	If $iEvenCol = -1 Then $iEvenCol = $defColLV
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = -1
	$aSubItemSet[0][2] = $iOddCol
	$aSubItemSet[0][3] = $iEvenCol
	_WinAPI_InvalidateRect($hListView)
	GUICtrlSetState($lbActiv, $GUI_SHOW)
EndFunc  ;==>_RowsSetCol

Func _ColRowOff()
	$aSubItemSet[0][0] = -1
	$aSubItemSet[0][1] = 0
	$aSubItemSet[0][2] = 0
	$aSubItemSet[0][3] = 0
	$aSubItemSet[0][4] = 0
	_WinAPI_InvalidateRect($hListView)
	GUICtrlSetState($lbActiv, $GUI_HIDE)
EndFunc  ;==>_ColRowOff
#endregion
