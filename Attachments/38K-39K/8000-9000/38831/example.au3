#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
;ADD;
#include <GuiListView.au3>
#include <Array.au3>
;----
Opt("GUIDataSeparatorChar", "/")
$GUI = GUICreate("Form1", 673, 433, -1, -1)
$hListView = GUICtrlCreateListView("Name File / Value", 8, 64, 657, 361)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 380)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 270)
$Button1 = GUICtrlCreateButton("Load", 8, 16, 105, 33)
$Input1 = GUICtrlCreateInput("Input1", 136, 24, 145, 21)
$Button2 = GUICtrlCreateButton("Search", 304, 16, 105, 33)
GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
	Case $GUI_EVENT_CLOSE
	Exit
	Case $Button1
		$Log = "Test1/Test" & @LF & "Test2/Sun" & @LF & "Sun1/Sun/" & @LF & "Earth1/Earth1"
		$aArray = StringSplit($Log, @LF)
		For $i = 1 To $aArray[0]
			GUICtrlCreateListViewItem($aArray[$i], $hListView)
		Next
	;ADD
	Case $Button2
		$search = _GuiCtrlListView_ItemSearch($hListView,GUICtrlRead($Input1))
		_ArrayDisplay($search)
	;--
	EndSwitch
WEnd



; #FUNCTION# ====================================================================================================================
; Name ..........: _GuiCtrlListView_ItemSearch
; Description ...: Search a text in a listview
; Syntax ........: _GuiCtrlListView_ItemSearch($ctrlId, $sSearch[, $sCaseSense = False])
; Parameters ....: $ctrlId              - Control ID from listview.
;                  $sSearch             - String to search.
;                  $sCaseSense          - [optional] If function use case sensitive or not.
; Return values .: Succes:
;					> $Array[0][0] = Number of match string.
;					> $Array[1][0] = Line of result 1 (zero based)
;						> $Array[1][1] = SubItem of result 1 (zero based)
;					>.....................................................
;					> $Array[n][0] = Line of result 1 (zero based)
;						> $Array[n][1] = SubItem of result 1 (zero based)
;				   Fail :
;					> No string find return $Array[0][0] > 0
;					> @error
;						-> 1 : $sSearch is empty ("")
;						-> 2 : List had no lines (or control id is not a list)
;						-> 3 : List had no column (or control id is not a list)
; Author ........: PlayHD (Ababei Andrei)
; Modified ......: -
; Remarks .......: -
; Related .......: _GUICtrlListView_GetItemText
; Link ..........: -
; Example .......: No
; ===============================================================================================================================
Func _GuiCtrlListView_ItemSearch($ctrlId,$sSearch, $sCaseSense = False)
	If $sSearch = "" Then Return SetError(1,0,-2)
	Local $iCount = _GUICtrlListView_GetItemCount($ctrlId)
	If $iCount <= 0 Then Return SetError(2,0,-2)
	Local $iCol = _GUICtrlListView_GetColumnCount($ctrlId)
	If $iCol <= 0 Then Return SetError(3,0,-2)
	Local $i, $j, $lCaseSense = 0,$k = 1, $rArray[1][1]
	$rArray[0][0] = 0
	If $sCaseSense = True Then $lCaseSense = 1
	For $i = 0 To $iCount
		For $j = 0 To $iCol
			If StringCompare (_GUICtrlListView_GetItemText($ctrlId,$i,$j),$sSearch,$lCaseSense) = 0 Then
				ReDim $rArray[$k+1][2]
				$rArray[0][0] += 1
				$rArray[$k][0] = $i
				$rArray[$k][1] = $j
				$k += 1
			EndIf
		Next
	Next
	Return $rArray
EndFunc ;==> _GuiCtrlListView_ItemSearch