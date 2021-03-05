#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;======================================================================================================================================
; Program Name:			MyTreeViewExample
; Description:      	This script is a demo of the treeview function.
;
; External Programs:	None
; External Files:		None
; Author:				Robert Helgeson
;
; Asumptions:			None
;
; Revision History:
; Version 1.0:			Initial Release
; 06/15/2012 (RH)
;
;======================================================================================================================================#include <GUITreeView.au3>
#Region includes
#include <GUIConstants.au3>
#include <GUITreeView.au3>
#include <TreeViewConstants.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEX.au3>
#EndRegion includes

#Region Define and create Treelist
Local $hGUI = GUICreate('TreeView', 300, 700)
Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
Local $idTreeView = GUICtrlCreateTreeView(0, 0, 300, 700, $iStyle, $WS_EX_CLIENTEDGE)
Global $hTreeView = GUICtrlGetHandle($idTreeView)
_GUICtrlTreeView_BeginUpdate($hTreeView)

; Create the Treeview evtries entry
$idTreeView_Top = GUICtrlCreateTreeViewItem("Top", $idTreeView)
$hTreeView_Top = GUICtrlGetHandle($idTreeView_Top)

Local $idParent1 = GUICtrlCreateTreeViewItem('Parent1', $idTreeView_Top)
Local $hParent1 = GUICtrlGetHandle($idParent1)
$idLevel2 = GUICtrlCreateTreeViewItem('1-1', $idParent1)
For $i = 2 To 5
    GUICtrlCreateTreeViewItem('1-' & $i, $idLevel2)
Next
$idLevel5 = GUICtrlCreateTreeViewItem('1-6', $idLevel2)
    GUICtrlCreateTreeViewItem('1-6-1', $idLevel5)
$idLevel3 = GUICtrlCreateTreeViewItem('2-1', $idParent1)
For $i = 2 To 5
    GUICtrlCreateTreeViewItem('2-' & $i, $idLevel3)
Next
$idLevel4 = GUICtrlCreateTreeViewItem('3-1', $idParent1)
For $i = 2 To 5
    GUICtrlCreateTreeViewItem('3-' & $i, $idLevel4)
Next
For $i = 4 To 6
    GUICtrlCreateTreeViewItem($i, $idParent1)
Next

Local $idParent2 = GUICtrlCreateTreeViewItem('Parent2', $idTreeView_Top)
Local $hParent2 = GUICtrlGetHandle($idParent2)
For $i = 1 To 5
    GUICtrlCreateTreeViewItem('2-' & $i, $idParent2)
Next
Local $idParent3 = GUICtrlCreateTreeViewItem('Parent3', $idTreeView_Top)
Local $hParent3 = GUICtrlGetHandle($idParent3)
For $i = 1 To 5
    GUICtrlCreateTreeViewItem('3-' & $i, $idParent3)
Next
Local $idParent4 = GUICtrlCreateTreeViewItem('Parent4', $idTreeView_Top)
Local $hParent4 = GUICtrlGetHandle($idParent4)

; Expand all parents on startup
_GUICtrlTreeView_SetState($hTreeView, $hTreeView_Top, $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, $hParent1, $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, GUICtrlGetHandle($idLevel5), $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, $hParent2, $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, GUICtrlGetHandle($idLevel2), $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, GUICtrlGetHandle($idLevel3), $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, GUICtrlGetHandle($idLevel4), $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, $hParent3, $TVIS_EXPANDED)
_GUICtrlTreeView_SetState($hTreeView, $hParent4, $TVIS_EXPANDED)

_GUICtrlTreeView_EndUpdate($hTreeView)

GUISetState()
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
#EndRegion Define and create Treelist
#Region Program Control
While 1
	$msg = GUIGetMsg()
    Select
		Case $msg = $GUI_EVENT_CLOSE
            _GUICtrlTreeView_Destroy($hTreeView)
            GUIDelete()
            Exit
        Case $msg = $GUI_EVENT_PRIMARYDOWN
            Local $tMPos = _WinAPI_GetMousePos(True, $hTreeView)
            Local $tHitTest = _GUICtrlTreeView_HitTestEx($hTreeView, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
            Local $iFlags = DllStructGetData($tHitTest, "Flags")
            Select
                Case BitAND($iFlags, $TVHT_ONITEMSTATEICON)
                    Local $hItem = _GUICtrlTreeView_HitTestItem($hTreeView, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
                    Local $fChecked = False
                    If _GUICtrlTreeView_GetChecked($hTreeView, $hItem) Then $fChecked = True
                    _TvCheckbox($hItem, $fChecked)
			EndSelect
	EndSelect
;~     If $iTreeView_Flag Then
;~         $iTreeView_Flag = False
;~         ConsoleWrite(_GUICtrlTreeView_GetText($hTreeView, _GUICtrlTreeView_GetSelection($hTreeView)) & @CRLF)
;~     EndIf

WEnd
#EndRegion Program Control

#Region Functions
Func _TvCheckbox($hTvItem, $fTvCheck)
;-------------- Going up the tree -----------------------------------
	_TvCheckboxParent($hTvItem, $fTvCheck)

;-------------- Going down the tree -----------------------------------
	_TvCheckboxChild($hTvItem, $fTvCheck)
EndFunc

Func _TvCheckboxChild($hTvItem, $fTvCheck)
    Local $hFirst, $hNext
    $hFirst = _GUICtrlTreeView_GetFirstChild($hTreeView, $hTvItem)
    If $hFirst Then
        $hNext = $hFirst
        While $hNext
            _GUICtrlTreeView_SetChecked($hTreeView, $hNext, $fTvCheck)
            If _GUICtrlTreeView_GetFirstChild($hTreeView, $hNext) Then
				_TvCheckboxChild($hNext, $fTvCheck)
			EndIf
            $hNext = _GUICtrlTreeView_GetNextSibling($hTreeView, $hNext)
        WEnd
    EndIf
EndFunc   ;==>_TvCheckboxChild

Func _TvCheckboxParent($hTvItem, $fTvCheck)
    Local $hFirst, $hNext, $bCheckedFlag

	If $fTvCheck Then
		$hTvParent = _GUICtrlTreeView_GetParentHandle($hTreeView, $hTvItem)
		If $hTvParent = 0 Then
			_GUICtrlTreeView_SetChecked($hTreeView, $hTvItem, $fTvCheck)
		Else
			$hFirst = _GUICtrlTreeView_GetParentHandle($hTreeView, $hTvItem)
			If $hFirst Then
				$hNext = $hFirst
					_GUICtrlTreeView_SetChecked($hTreeView, $hNext, $fTvCheck)
					If _GUICtrlTreeView_GetParentHandle($hTreeView, $hNext) Then
						_TvCheckboxParent($hNext, $fTvCheck)
					EndIf
			EndIf
		EndIf
	Else
		$hTvParent = _GUICtrlTreeView_GetParentHandle($hTreeView, $hTvItem)
		If $hTvParent = 0 Then ; reached the top of the list
			_GUICtrlTreeView_SetChecked($hTreeView, $hTvItem, $fTvCheck)
		Else
			$hNext = $hTvParent
			; check to see if any siblings are checked
			$hSibling = _GUICtrlTreeView_GetFirstChild($hTreeView, $hNext)
			$bCheckedFlag = True
			While $hSibling > 0
				If _GUICtrlTreeView_GetChecked($hTreeView, $hSibling) Then
					$bCheckedFlag = False
					ExitLoop
				EndIf
				$hSibling = _GUICtrlTreeView_GetNextSibling($hTreeView, $hSibling)
			WEnd
			If $bCheckedFlag Then
				_GUICtrlTreeView_SetChecked($hTreeView, $hNext, $fTvCheck)
			EndIf
			If _GUICtrlTreeView_GetParentHandle($hTreeView, $hNext) Then
				_TvCheckboxParent($hNext, $fTvCheck)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_TvCheckboxParent

Func WM_NOTIFY($hWnd, $Msg, $wParam, $lParam)
    Local $tNMHDR, $IdFrom, $iCode

    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $IdFrom = DllStructGetData($tNMHDR, "IdFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
        Switch $hWndFrom
        Case $hTreeView
            Switch $iCode
                Case $NM_CLICK
                     $iTreeView_Flag = True
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc
#EndRegion Functions