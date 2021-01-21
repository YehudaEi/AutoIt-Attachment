#include-once
#include <GUIConstantsEx.au3>
#Include <GuiListView.au3>
#include <Misc.au3>




; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayEdt1D
; Description ...: Lets you edit an one dimensional array in a listview
; Syntax.........: _ArrayEdt1D(ByRef $aData, $sColName = 'Data', $sTitle = 'ArrayEdt', $iWidth = 400, $iHeight = 300, $iLeft = -1, $iTop = -1, $hParent = '')
; Parameters ....: $aData		- 1D array
;				   $sColName	- Title string for the column
;				   $sTitle		- GUI window title string
;				   $iWidth		- GUI window width
;				   $iHeight		- GUI window height
;				   $iLeft		- GUI window x position
;				   $iTop		- GUI window y position
;				   $hParent		- GUI window handle to parent window
; Return values .: Success      - True		user pressed Ok-button
;								- returns $aData array (ByRef)
;                  Failure      - False		user pressed Cancel-button, or an error occured
;								- sets @error to
;									- 0 ... user pressed Cancel-button
;									- 1 ... $aData is not a valid 1D array
; Author ........: Xandl
; Modified.......: 
; Remarks .......: Wrapper for one dimensional arrays and _ArrayEdt2D.
;				   When editing an 1D array, you need not take care for the first column, the 'Index'.
;				   Just change the data column as needed, the array will be returned in the order as you see it in the listview.
; Related .......: _ArrayEdt2D
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayEdt1D(ByRef $aData, $sColName = 'Data', $sTitle = 'ArrayEdt', $iWidth = 400, $iHeight = 300, $iLeft = -1, $iTop = -1, $hParent = '')
	If Not IsArray($aData) Or UBound($aData,0) <> 1 Then
		Return SetError(1,0,0)
	EndIf
	Local $asDataTmp[UBound($aData)][2]
	For $i = 0 To UBound($aData)-1
		$asDataTmp[$i][0] = $i
		$asDataTmp[$i][1] = $aData[$i]
	Next
	Local $asColTmp[2] = ['Index',$sColName]
	Local $fRet = _ArrayEdt2D($asDataTmp,$asColTmp,$sTitle,$iWidth,$iHeight,$iLeft,$iTop,$hParent)
	If $fRet Then
		Local $asRet[UBound($asDataTmp)]
		For $i = 0 To UBound($asDataTmp)-1
			$asRet[$i] = $asDataTmp[$i][1]
		Next
		$aData = $asRet
	EndIf
	Return SetError(0,0,$fRet)
EndFunc   ;==>ArrayEdt1D

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayEdt2D
; Description ...: Lets you edit a two dimensional array in a listview
; Syntax.........: _ArrayEdt2D(ByRef $aData, ByRef $aColName, $sTitle = 'ArrayEdt', $iWidth = 400, $iHeight = 300, $iLeft = -1, $iTop = -1, $hParent = '')
; Parameters ....: $aData		- 2D array
;				   $aColName	- Array of strings, representing column names
;				   $sTitle		- GUI window title string
;				   $iWidth		- GUI window width
;				   $iHeight		- GUI window height
;				   $iLeft		- GUI window x position
;				   $iTop		- GUI window y position
;				   $hParent		- GUI window handle to parent window
; Return values .: Success      - True:		user pressed Ok-button
;								- returns $aData array (ByRef)
;								- returns $aColName array (ByRef)
;                  Failure      - False:	user pressed Cancel-button, or an error occured
;								- sets @error to
;									- 0 ... user pressed Cancel-button
;									- 1 ... $aData is not a valid 2D array
;									- 2 ... number of strings in $aColName does not match UBound($aData,2)
; Author ........: Xandl
; Modified.......: 
; Remarks .......: If you change column order in the listview, changes are reflected in $aColName (ByRef).
; Related .......: _ArrayEdt1D
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayEdt2D(ByRef $aData, ByRef $aColName, $sTitle = 'ArrayEdt', $iWidth = 400, $iHeight = 300, $iLeft = -1, $iTop = -1, $hParent = '')
	If Not IsArray($aData) Or UBound($aData,0) <> 2 Then
		Return SetError(1,0,0)
	ElseIf Not IsArray($aColName) Or UBound($aData,2) <> UBound($aColName) Then
		Return SetError(2,0,0)
	EndIf
	If Not $aColName[0] Then
		ReDim $aColName[UBound($aData,2)]
		For $i = 0 To UBound($aColName)-1
			$aColName[$i] = 'Column ' & $i
		Next
	EndIf
	Local Const $KEYBD_F3 = '72'
	Local $oldGuiOnEventMode = AutoItSetOption('GuiOnEventMode',0)
	Local $oldGuiCloseOnESC = AutoItSetOption('GuiCloseOnESC',0)
	Local $hUser32 = DllOpen('user32.dll')
	Local $hWin = GUICreate($sTitle,$iWidth,$iHeight,$iLeft,$iTop,BitOR($WS_OVERLAPPEDWINDOW,$WS_CLIPSIBLINGS,$WS_SYSMENU),-1,$hParent)
	Local $hList = GUICtrlCreateListView('',0,0,$iWidth,$iHeight-40,BitXOR($GUI_SS_DEFAULT_LISTVIEW,$LVS_SINGLESEL))
	_GUICtrlListView_SetTextBkColor($hList,0xECFFFF)
	GUICtrlSetResizing($hList,$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
	_GUICtrlListView_SetExtendedListViewStyle($hList,BitOR($LVS_EX_HEADERDRAGDROP,$LVS_EX_FULLROWSELECT,$LVS_EX_DOUBLEBUFFER,$LVS_EX_BORDERSELECT,$LVS_EX_GRIDLINES))
	Local $hbOk = GUICtrlCreateButton('&Ok',20,$iHeight-30,60)
	GUICtrlSetResizing($hbOk,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	Local $hbCancel = GUICtrlCreateButton('&Cancel',90,$iHeight-30,60,-1,$BS_DEFPUSHBUTTON)
	GUICtrlSetResizing($hbCancel,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	Local $hbMoveUp = GUICtrlCreateButton('Move &Up',200,$iHeight-30,80)
	GUICtrlSetResizing($hbMoveUp,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	Local $hbMoveDwn = GUICtrlCreateButton('Move &Down',290,$iHeight-30,80)
	GUICtrlSetResizing($hbMoveDwn,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	_GUICtrlListView_BeginUpdate($hList)
	For $i = 0 To UBound($aColName)-1
		_GUICtrlListView_AddColumn($hList,$aColName[$i])
	Next
	GUISetState(@SW_SHOW,$hWin)
	Local $hPbar = _ArrayEdt_Progress(1)
	For $i = 0 To UBound($aData)-1
		If Mod($i,Int(UBound($aData)/24)) = 0 Then _ArrayEdt_Progress(0,$hPbar,100/UBound($aData)*$i)
		_GUICtrlListView_AddItem($hList,$aData[$i][0])
		For $k = 1 To UBound($aData,2)-1
			_GUICtrlListView_SetItemText($hList,$i,$aData[$i][$k],$k)
		Next
	Next
	For $i = 0 To UBound($aColName)-1
		_GUICtrlListView_SetColumnWidth($hList,$i,$LVSCW_AUTOSIZE_USEHEADER)
	Next
	_ArrayEdt_Progress(0,$hPbar,100)
	_GUICtrlListView_EndUpdate($hList)
	_ArrayEdt_Progress(-1,$hPbar)
	Local $afSortOrderhList[_GUICtrlListView_GetColumnCount($hList)]
	Local $hMenu = GUICtrlCreateContextMenu($hList)
	Local $hmAdd = GUICtrlCreateMenuItem('&Add Row',$hMenu)
	Local $hmChange = GUICtrlCreateMenuItem('&Change Row',$hMenu)
	Local $hmCopy = GUICtrlCreateMenuItem('Cop&y Row',$hMenu)
	Local $hmDelete = GUICtrlCreateMenuItem('&Delete Row',$hMenu)
	Local $hmInsert = GUICtrlCreateMenuItem('&Insert Row',$hMenu)
	GUICtrlCreateMenuItem('',$hMenu)
	Local $hmSearch = GUICtrlCreateMenuItem('&Find Item',$hMenu)
	Local $hmSearchAgain = GUICtrlCreateMenuItem('Find Item A&gain (F3)',$hMenu)
	GUICtrlCreateMenuItem('',$hMenu)
	Local $hmMoveStart = GUICtrlCreateMenuItem('Move Row to &Begin',$hMenu)
	Local $hmMoveUp = GUICtrlCreateMenuItem('Move Row 1 &Up',$hMenu)
	Local $hmMoveDwn = GUICtrlCreateMenuItem('Move Row 1 D&own',$hMenu)
	Local $hmMoveEnd = GUICtrlCreateMenuItem('Move Row to &End',$hMenu)
	GUICtrlCreateMenuItem('',$hMenu)
	Local $hmSelAll = GUICtrlCreateMenuItem('&Select All',$hMenu)
	Local $hmSelNone = GUICtrlCreateMenuItem('Select &None',$hMenu)
	Local $hmClip = GUICtrlCreateMenu('Cli&pboard',$hMenu)
	Local $hmCopy2Clip = GUICtrlCreateMenuItem('Copy to Clipboard &with header',$hmClip)
	Local $hmCopy2ClipNoHeader = GUICtrlCreateMenuItem('Copy to Clipboard with&out header',$hmClip)
	Local $hmClip2List = GUICtrlCreateMenuItem('Copy f&rom Clipboard',$hmClip)
	Local $fRet = False
	Local $avSearch[2] = ['',-1]
	_ArrayEdt_SetSelItem($hList,0)
	_ArrayEdt_SetWinTitle($sTitle,$hList)
	While 1
		If WinActive($sTitle) Then
			If _IsPressed($KEYBD_F3,$hUser32) Then
				_ArrayEdt_SearchItem($hList,$avSearch,True)
				_ArrayEdt_KeybdWaitRelease($KEYBD_F3,$hUser32)
			Else
				Switch GUIGetMsg()
					Case 0
						ContinueLoop
					Case $hmAdd
						_ArrayEdt_AddRow($hWin,$hList,False)
						_ArrayEdt_SetWinTitle($sTitle,$hList)
					Case $hmCopy
						_ArrayEdt_CopyRow($hList)
						_ArrayEdt_SetWinTitle($sTitle,$hList)
					Case $hmChange
						_ArrayEdt_ChangeRow($hWin,$hList)
					Case $hmDelete
						_ArrayEdt_DeleteRow($hList)
						_ArrayEdt_SetWinTitle($sTitle,$hList)
					Case $hmInsert
						_ArrayEdt_AddRow($hWin,$hList,True)
						_ArrayEdt_SetWinTitle($sTitle,$hList)
					Case $hmSearch
						_ArrayEdt_SearchItem($hList,$avSearch,False)
					Case $hmSearchAgain
						_ArrayEdt_SearchItem($hList,$avSearch,True)
					Case $hmMoveStart
						_ArrayEdt_MoveRowUp($hList,True)
					Case $hmMoveUp, $hbMoveUp
						_ArrayEdt_MoveRowUp($hList)
					Case $hmMoveDwn, $hbMoveDwn
						_ArrayEdt_MoveRowDown($hList)
					Case $hmMoveEnd
						_ArrayEdt_MoveRowDown($hList,True)
					Case $hmSelAll
						_ArrayEdt_SelectAll($hList)
					Case $hmSelNone
						_ArrayEdt_UnSelectAll($hList)
					Case $hmCopy2Clip
						_ArrayEdt_ReadRows2Clipboard($hList)
					Case $hmCopy2ClipNoHeader
						_ArrayEdt_ReadRows2Clipboard($hList,False)
					Case $hmClip2List
						_ArrayEdt_ReadClipboard2Rows($hList)
						_ArrayEdt_SetWinTitle($sTitle,$hList)
					Case $hList
						ToolTip('Sorting column ' & GUICtrlGetState($hList))
						_GUICtrlListView_SimpleSort($hList,$afSortOrderhList,GUICtrlGetState($hList))
						ToolTip('')
					Case $GUI_EVENT_PRIMARYUP, $GUI_EVENT_SECONDARYUP
						_ArrayEdt_SetWinTitle($sTitle,$hList)
						_GUICtrlListView_SetItemFocused($hList,_GUICtrlListView_GetNextItem($hList,-1,0,4),False)
					Case $hbOk
						$aData = _ArrayEdt_ReadRows($hList)
						$aColName = _ArrayEdt_GetColumnArray($hList)
						$fRet = True
						ExitLoop
					Case $GUI_EVENT_CLOSE, $hbCancel
						ExitLoop
				EndSwitch
			EndIf
		EndIf
		Sleep(20)
	WEnd
	GUISetState(@SW_HIDE,$hWin)
	GUIDelete($hWin)
	DllClose($hUser32)
	AutoItSetOption('GuiOnEventMode',$oldGuiOnEventMode)
	AutoItSetOption('GuiCloseOnESC',$oldGuiCloseOnESC)
	Return SetError(0,0,$fRet)
EndFunc   ;==>ArrayEdt2D

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_KeybdWaitRelease
; Description ...: Wait for keyboard release key; return for repeat after 100ms if not already released
; Syntax.........: _ArrayEdt_KeybdWaitRelease($sKey,$user32)
; Parameters ....: $sKey		- Key to wait for release
;				   $user32		- Handle to user32.dll
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_KeybdWaitRelease($sKey,$hUser32)
	Local $iTime = TimerInit()
	While _IsPressed($sKey,$hUser32)
		Sleep(20)
		If TimerDiff($iTime) > 100 Then Return
	WEnd
EndFunc   ;==>_ArrayEdt_KeybdWaitRelease

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_Info
; Description ...: Display MsgBox: Ok button, Info icon, Top-most placing
; Syntax.........: _ArrayEdt_Info($sTitle,$sText)
; Parameters ....: $sTitle		- String for msgbox title
;				   $sText		- String for msgbox text
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_Info($sTitle,$sText)
	Local Const $MSGBOX_ICONINFO = 64
	Local Const $MSGBOX_TASKMODAL = 8192
	MsgBox(BitOR($MSGBOX_ICONINFO,$MSGBOX_TASKMODAL),' ' & $sTitle,$sText)
EndFunc   ;==>_ArrayEdt_Info

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_SetWinTitle
; Description ...: Set gui window title with array extends, i.e. '[12][4]'
; Syntax.........: _ArrayEdt_SetWinTitle($sTitle,$hList)
; Parameters ....: $sTitle		- GUI window title string
;				   $hList		- Handle to listview control
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_SetWinTitle($sTitle,$hList)
	Local $iCols = _GUICtrlListView_GetColumnCount($hList)
	Local $iItems = _GUICtrlListView_GetItemCount($hList)
	Local $iSelected = _GUICtrlListView_GetNextItem($hList)
	WinSetTitle($sTitle,'',$sTitle & ' - [' & $iItems & '][' & $iCols & '] - (' & $iSelected & ')')
EndFunc   ;==>_ArrayEdt_SetWinTitle

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_SetSelItem
; Description ...: Select item in listview, set focus, scroll into view
; Syntax.........: _ArrayEdt_SetSelItem($hList,$iIdx)
; Parameters ....: $hList       - Handle to listview control
;				   $iIdx		- 0 based index of item
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_SetSelItem($hList,$iIdx)
	_GUICtrlListView_SetItemSelected($hList,$iIdx,True)
	_GUICtrlListView_SetItemFocused($hList,$iIdx)
	_GUICtrlListView_EnsureVisible($hList,$iIdx)
EndFunc   ;==>_ArrayEdt_SetSelItem

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_SelectAll
; Description ...: Select all items in listview
; Syntax.........: _ArrayEdt_SelectAll($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_SelectAll($hList)
	_GUICtrlListView_BeginUpdate($hList)
	For $i = 0 To _GUICtrlListView_GetItemCount($hList)-1
		_GUICtrlListView_SetItemSelected($hList,$i,True)
	Next
	_ArrayEdt_SetSelItem($hList,0)
	_GUICtrlListView_EndUpdate($hList)
EndFunc   ;==>_ArrayEdt_SelectAll

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_UnSelectAll
; Description ...: Unselect all items in listview
; Syntax.........: _ArrayEdt_UnSelectAll($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_UnSelectAll($hList)
	Local $aiIdx = _GUICtrlListView_GetSelectedIndices($hList,True)
	If $aiIdx[0] Then
		_GUICtrlListView_BeginUpdate($hList)
		For $i = 1 To $aiIdx[0]
			_GUICtrlListView_SetItemSelected($hList,$aiIdx[$i],False)
		Next
		_GUICtrlListView_EndUpdate($hList)
	EndIf
EndFunc   ;==>_ArrayEdt_UnSelectAll

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_SearchItem
; Description ...: Search item in listview
; Syntax.........: _ArrayEdt_SearchItem($hList,ByRef $avSearch,$fAgain = False)
; Parameters ....: $hList       - Handle to listview control
;				   $avSearch	- search info:	$avSearch[0] = last search string
;												$avSearch[1] = last find index
;				   $fAgain		- true:		repeat last search
;								- false:	show inputbox for new search string
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_SearchItem($hList,ByRef $avSearch,$fAgain = False)
	Local $sFind
	If $fAgain Then
		$sFind = $avSearch[0]
	Else
		$sFind = InputBox('Find item in array:','Enter search phrase below:',$avSearch[0],'',300,130)
		If $sFind <> $avSearch[0] Then $avSearch[1] = -1
	EndIf
	If $sFind Then
		Local $iIdx = _GUICtrlListView_FindInText($hList,$sFind,$avSearch[1])
		If $iIdx > -1 Then
			_ArrayEdt_UnSelectAll($hList)
			_ArrayEdt_SetSelItem($hList,$iIdx)
		EndIf
		$avSearch[0] = $sFind
		$avSearch[1] = $iIdx
	EndIf
EndFunc   ;==>_ArrayEdt_SearchItem

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_MoveRowUp($hList,$fStart = False)
; Description ...: Moves selected items in listview to new position
; Syntax.........: _ArrayEdt_MoveRowUp($hList,$fStart = False)
; Parameters ....: $hList       - Handle to listview control
;				   $fStart		- If true, item will be moved to start of list
;								- If false, item will be moved one line up
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_MoveRowUp($hList,$fStart = False)
	Local $iPos
	Local $iSelected = _GUICtrlListView_GetNextItem($hList)
	If $iSelected < 0 Then Return _ArrayEdt_Info('Move Item','Please select an item first.')
	If $fStart Then
		$iPos = 0
	Else
		$iPos = $iSelected - 1
		If $iPos < 0 Then Return ControlFocus('','',$hList)
	EndIf
	Return _ArrayEdt_MoveItem($hList,$iPos)
EndFunc   ;==>_ArrayEdt_MoveRowUp

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_MoveRowDown
; Description ...: Moves selected items in listview to new position
; Syntax.........: _ArrayEdt_MoveRowDown($hList,$fEnd = False)
; Parameters ....: $hList       - Handle to listview control
;				   $fEnd		- If true, item will be moved to end of list
;								- If false, item will be moved one line down
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_MoveRowDown($hList,$fEnd = False)
	Local $iPos
	Local $aiIdx = _GUICtrlListView_GetSelectedIndices($hList,True)
	If $aiIdx[0] < 1 Then Return _ArrayEdt_Info('Move Item','Please select an item first.')
	If $fEnd Then
		$iPos = _GUICtrlListView_GetItemCount($hList)
	Else
		$iPos = $aiIdx[$aiIdx[0]] + 2
		If $iPos > _GUICtrlListView_GetItemCount($hList) Then Return ControlFocus('','',$hList)
	EndIf
	Return _ArrayEdt_MoveItem($hList,$iPos)
EndFunc   ;==>_ArrayEdt_MoveRowDown

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_MoveItem
; Description ...: Moves selected items in listview to new position
; Syntax.........: _ArrayEdt_MoveItem($hList,$iTargetPos)
; Parameters ....: $hList       - Handle to listview control
;				   $iTargetPos	- Index to move selected items to
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_MoveItem($hList,$iTargetPos)
	Local $aiIdx = _GUICtrlListView_GetSelectedIndices($hList,True)
	Local $iDirection, $asTmp, $iFrom
	If $iTargetPos < _GUICtrlListView_GetNextItem($hList) Then
		$iDirection = -1
	Else
		$iDirection = 1
	EndIf
	If $aiIdx[0] Then
		_GUICtrlListView_BeginUpdate($hList)
		For $i = 1 To $aiIdx[0]
			If $iDirection = -1 Then
				$iFrom = $aiIdx[$i]
			Else
				$iFrom = $aiIdx[$i] - $i+1
			EndIf
			$asTmp = _GUICtrlListView_GetItemTextArray($hList,$iFrom)
			_GUICtrlListView_InsertItem($hList,$asTmp[1],$iTargetPos)
			For $k = 2 To $asTmp[0]
				_GUICtrlListView_SetItemText($hList,$iTargetPos,$asTmp[$k],$k-1)
			Next
			_GUICtrlListView_SetItemSelected($hList,$iTargetPos,True)
			If $iDirection = -1 Then
				_GUICtrlListView_DeleteItem(GUICtrlGetHandle($hList),$iFrom+1)
				$iTargetPos += 1
			Else
				_GUICtrlListView_DeleteItem(GUICtrlGetHandle($hList),$iFrom)
			EndIf
		Next
		_ArrayEdt_SetSelItem($hList,$iTargetPos-$aiIdx[0])
		_GUICtrlListView_EndUpdate($hList)
		ControlFocus('','',$hList)
	Else
		_ArrayEdt_Info('Move Item','Please select an item first.')
	EndIf
EndFunc   ;==>_ArrayEdt_MoveItem

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_DeleteRow
; Description ...: Delete all selected items in listview
; Syntax.........: _ArrayEdt_DeleteRow($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_DeleteRow($hList)
	Local $iSelected = _GUICtrlListView_GetNextItem($hList)
	If $iSelected < 0 Then Return _ArrayEdt_Info('Delete Item','Please select an item first.')
	_GUICtrlListView_DeleteItemsSelected(GUICtrlGetHandle($hList))
	_ArrayEdt_SetSelItem($hList,$iSelected)
EndFunc   ;==>_ArrayEdt_DeleteRow

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_CopyRow
; Description ...: Copy all selected items to next position in listview
; Syntax.........: _ArrayEdt_CopyRow($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_CopyRow($hList)
	Local $aiIdx = _GUICtrlListView_GetSelectedIndices($hList,True)
	If $aiIdx[0] < 1 Then
		_ArrayEdt_Info('Copy Item','Please select an item first.')
		Return False
	EndIf
	Local $asTmp, $iFrom = 0
	_GUICtrlListView_BeginUpdate($hList)
	For $i = 1 To $aiIdx[0]
		$asTmp = _GUICtrlListView_GetItemTextArray($hList,$aiIdx[$i]+$iFrom)
		_GUICtrlListView_InsertItem($hList,$asTmp[1],$aiIdx[$i]+$iFrom+1)
		For $k = 2 To $asTmp[0]
			_GUICtrlListView_SetItemText($hList,$aiIdx[$i]+$iFrom+1,$asTmp[$k],$k-1)
		Next
		_GUICtrlListView_SetItemSelected($hList,$aiIdx[$i]+$iFrom+1,True)
		$iFrom += 1
	Next
	_ArrayEdt_SetSelItem($hList,$aiIdx[1])
	_GUICtrlListView_EndUpdate($hList)
	Return True
EndFunc   ;==>_ArrayEdt_CopyRow

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_AddRow
; Description ...: Displays dialog to add or insert a row item
; Syntax.........: _ArrayEdt_AddRow($hParent,$hList,$fInsert = False)
; Parameters ....: $hParent		- Handle to parent window
;				   $hList       - Handle to listview control
;				   $fInsert		- true:		insert new row below selected item position
;								- false:	insert new row at end of list
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_AddRow($hParent,$hList,$fInsert = False)
	Local $iItems = _GUICtrlListView_GetItemCount($hList)
	Local $iCols = _GUICtrlListView_GetColumnCount($hList)
	Local $iSelected = _GUICtrlListView_GetNextItem($hList)
	Local $iPos, $sTitle
	If $fInsert Then
		If $iSelected < 0 Then Return _ArrayEdt_Info('Insert Item','Please select an item first.')
		$iPos = $iSelected
		$sTitle = 'Insert Item at Row ' & $iPos
	Else
		$iPos = $iItems
		$sTitle = 'Add Item to Row ' & $iPos
	EndIf
	AutoItSetOption('GuiCloseOnESC',1)
	Local $aiColOrder = _GUICtrlListView_GetColumnOrderArray($hList)
	Local $hAdd = GUICreate($sTitle,440,80+$iCols*20,-1,-1,BitOR($WS_OVERLAPPEDWINDOW,$WS_CLIPSIBLINGS,$WS_SYSMENU),-1,$hParent)
	Local $ahData[$iCols], $asTmp
	GUICtrlCreateGroup('Enter item values',10,5,420,25+($iCols)*20)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT)
	For $i = 0 To $iCols-1
		$asTmp = _GUICtrlListView_GetColumn($hList,$aiColOrder[$i+1])
		GUICtrlCreateLabel($asTmp[5],20,23+$i*20,120,-1,$SS_RIGHT)
		GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
		$ahData[$i] = GUICtrlCreateInput('',150,20+$i*20,270)
		GUICtrlSetResizing($ahData[$i],$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT+$GUI_DOCKTOP)
	Next
	Local $hbOk = GUICtrlCreateButton('&Ok',20,50+$iCols*20,60)
	GUICtrlSetResizing($hbOk,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	Local $hbCancel = GUICtrlCreateButton('&Cancel',90,50+$iCols*20,60,-1,$BS_DEFPUSHBUTTON)
	GUICtrlSetResizing($hbCancel,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	GUISetState(@SW_SHOW,$hAdd)
	While 1
		Switch GUIGetMsg()
			Case 0
				ContinueLoop
			Case $hbOk
				_GUICtrlListView_InsertItem($hList,GUICtrlRead($ahData[0]),$iPos)
				For $i = 1 To $iCols-1
					_GUICtrlListView_SetItemText($hList,$iPos,GUICtrlRead($ahData[$i]),$aiColOrder[$i+1])
				Next
				_ArrayEdt_UnSelectAll($hList)
				_ArrayEdt_SetSelItem($hList,$iPos)
				ExitLoop
			Case $GUI_EVENT_CLOSE, $hbCancel
				ExitLoop
		EndSwitch
		Sleep(20)
	WEnd
	GUISetState(@SW_HIDE,$hAdd)
	GUIDelete($hAdd)
	AutoItSetOption('GuiCloseOnESC',0)
EndFunc   ;==>_ArrayEdt_AddRow

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_ChangeRow
; Description ...: Displays dialog to change selected row item in listview
; Syntax.........: _ArrayEdt_ChangeRow($hParent,$hList)
; Parameters ....: $hParent		- Handle to parent window
;				   $hList       - Handle to listview control
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_ChangeRow($hParent,$hList)
	Local $iSelected = _GUICtrlListView_GetNextItem($hList)
	If $iSelected < 0 Then Return _ArrayEdt_Info('Change Item','Please select an item first.')
	AutoItSetOption('GuiCloseOnESC',1)
	Local $iCols = _GUICtrlListView_GetColumnCount($hList)
	Local $aiColOrder = _GUICtrlListView_GetColumnOrderArray($hList)
	Local $hChg = GUICreate('Change Item in Row ' & $iSelected,440,80+$iCols*20,-1,-1,BitOR($WS_OVERLAPPEDWINDOW,$WS_CLIPSIBLINGS,$WS_SYSMENU),-1,$hParent)
	Local $ahData[$iCols], $asTmp
	GUICtrlCreateGroup('Change item values',10,5,420,25+($iCols)*20)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT)
	For $i = 0 To $iCols-1
		$asTmp = _GUICtrlListView_GetColumn($hList,$aiColOrder[$i+1])
		GUICtrlCreateLabel($asTmp[5],20,23+$i*20,120,-1,$SS_RIGHT)
		GUICtrlSetResizing(-1,$GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
		$asTmp = _GUICtrlListView_GetItem($hList,$iSelected,$aiColOrder[$i+1])
		$ahData[$i] = GUICtrlCreateInput($asTmp[3],150,20+$i*20,270)
		GUICtrlSetResizing($ahData[$i],$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT+$GUI_DOCKTOP)
	Next
	Local $hbOk = GUICtrlCreateButton('&Ok',20,50+$iCols*20,60)
	GUICtrlSetResizing($hbOk,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	Local $hbCancel = GUICtrlCreateButton('&Cancel',90,50+$iCols*20,60,-1,$BS_DEFPUSHBUTTON)
	GUICtrlSetResizing($hbCancel,$GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKWIDTH)
	GUISetState(@SW_SHOW,$hChg)
	While 1
		Switch GUIGetMsg()
			Case 0
				ContinueLoop
			Case $hbOk
				_GUICtrlListView_SetItem($hList,GUICtrlRead($ahData[0]),$iSelected)
				For $i = 1 To $iCols-1
					_GUICtrlListView_SetItem($hList,GUICtrlRead($ahData[$i]),$iSelected,$aiColOrder[$i+1])
				Next
				ExitLoop
			Case $GUI_EVENT_CLOSE, $hbCancel
				ExitLoop
		EndSwitch
		Sleep(20)
	WEnd
	GUISetState(@SW_HIDE,$hChg)
	GUIDelete($hChg)
	AutoItSetOption('GuiCloseOnESC',0)
EndFunc   ;==>_ArrayEdt_ChangeRow

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_ReadRows_NoColumnOrder
; Description ...: Returns array from listview
; Syntax.........: _ArrayEdt_ReadRows_NoColumnOrder($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: 2D array
; Remarks .......: For Internal Use Only
;				   Does not follow changed column order.
; ===============================================================================================================================
Func _ArrayEdt_ReadRows_NoColumnOrder($hList)
	Local $iItems = _GUICtrlListView_GetItemCount($hList)
	Local $iCols = _GUICtrlListView_GetColumnCount($hList)
	Local $asDataTmp[$iItems][$iCols], $asTmp
	For $i = 0 To $iItems-1
		$asTmp = _GUICtrlListView_GetItemTextArray($hList,$i)
		For $k = 1 To $asTmp[0]
			$asDataTmp[$i][$k-1] = $asTmp[$k]
		Next
	Next
	Return $asDataTmp
EndFunc   ;==>_ArrayEdt_ReadRows_NoColumnOrder

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_ReadRows
; Description ...: Returns 2D array from listview
; Syntax.........: _ArrayEdt_ReadRows($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: 2D array
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_ReadRows($hList)
	Local $iItems = _GUICtrlListView_GetItemCount($hList)
	Local $iCols = _GUICtrlListView_GetColumnCount($hList)
	Local $aiColOrder = _GUICtrlListView_GetColumnOrderArray($hList)
	Local $asDataTmp[$iItems][$iCols], $asTmp
	Local $hPbar = _ArrayEdt_Progress(1)
	For $i = 0 To $iItems-1
		If Mod($i,Int($iItems/24)) = 0 Then _ArrayEdt_Progress(0,$hPbar,100/$iItems*$i)
		$asTmp = _GUICtrlListView_GetItemTextArray($hList,$i)
		For $k = 1 To $aiColOrder[0]
			$asDataTmp[$i][$k-1] = $asTmp[$aiColOrder[$k]+1]
		Next
	Next
	_ArrayEdt_Progress(0,$hPbar,100)
	_ArrayEdt_Progress(-1,$hPbar)
	Return $asDataTmp
EndFunc   ;==>_ArrayEdt_ReadRows

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_Progress
; Description ...: Progress bar handling: create, set, destroy progressbar
; Syntax.........: _ArrayEdt_Progress($iMode,$hPbar = 0,$iValue = 0)
; Parameters ....: $iMode	- Mode (destroy,set,create)
;				   $hPbar	- Handle to gui bar
;				   $iValue	- Value in percent
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_Progress($iMode,$hPbar = 0,$iValue = 0)
	Switch $iMode
		Case 0
			GUICtrlSetData($hPbar,$iValue)
		Case -1
			Sleep(100)
			GUICtrlDelete($hPbar)
		Case 1
			Local $aiWinPos = WinGetPos('')
			Local $hBar = GUICtrlCreateProgress(40,$aiWinPos[3]/2-40,$aiWinPos[2]-80,20,$PBS_SMOOTH)
			GUICtrlSetResizing($hBar,$GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKHEIGHT)
			GUICtrlSetColor($hBar,0xFFFFEC)
			Return $hBar
	EndSwitch
EndFunc   ;==>_ArrayEdt_Progress

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_GetColumnArray
; Description ...: Returns an array of column names, in current column order
; Syntax.........: _ArrayEdt_GetColumnArray($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: Array of column names, in current column order
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_GetColumnArray($hList)
	Local $aiColOrder = _GUICtrlListView_GetColumnOrderArray($hList)
	Local $asTmp[$aiColOrder[0]], $asTmpName
	For $i = 1 To $aiColOrder[0]
		$asTmpName = _GUICtrlListView_GetColumn($hList,$aiColOrder[$i])
		$asTmp[$i-1] = $asTmpName[5]
	Next
	Return $asTmp
EndFunc   ;==>_ArrayEdt_GetColumnArray

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_ReadRows2Clipboard
; Description ...: Put selected rows fom listview to clipboard, including column names
; Syntax.........: _ArrayEdt_ReadRows2Clipboard($hList,$fCopyHeader = True)
; Parameters ....: $hList       - Handle to listview control
;				   $fCopyHeader	- if true, include column names
;								- if false, do not include column names
; Return values .: None
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func _ArrayEdt_ReadRows2Clipboard($hList,$fCopyHeader = True)
	Local $aiIdx = _GUICtrlListView_GetSelectedIndices($hList,True)
	If $aiIdx[0] < 1 Then Return _ArrayEdt_Info('Copy Rows to Clipboard','Please select an item first.')
	Local $aiColOrder = _GUICtrlListView_GetColumnOrderArray($hList)
	Local $asTmp, $sClip
	If $fCopyHeader Then
		$asTmp = _ArrayEdt_GetColumnArray($hList)
		$sClip = $asTmp[0]
		For $i = 1 To UBound($asTmp)-1
			$sClip &= '|' & $asTmp[$i]
		Next
		$sClip &= @LF
	EndIf
	Local $hPbar = _ArrayEdt_Progress(1)
	For $i = 1 To $aiIdx[0]
		If Mod($i,Int($aiIdx[0]/24)) = 0 Then _ArrayEdt_Progress(0,$hPbar,100/$aiIdx[0]*$i)
		$asTmp = _GUICtrlListView_GetItemTextArray($hList,$aiIdx[$i])
		$sClip &= $asTmp[$aiColOrder[1]+1]
		For $k = 2 To $aiColOrder[0]
			$sClip &= '|' & $asTmp[$aiColOrder[$k]+1]
		Next
		$sClip &= @LF
	Next
	ClipPut($sClip)
	_ArrayEdt_Progress(0,$hPbar,100)
	_ArrayEdt_Progress(-1,$hPbar)
	_ArrayEdt_Info('Copy to Clipboard',$aiIdx[0] & ' rows sent to clipboard.')
EndFunc   ;==>_ArrayEdt_ReadRows2Clipboard

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _ArrayEdt_ReadClipboard2Rows
; Description ...: Add rows from clipboard to listview, data separator is '|', line separator is @LF
; Syntax.........: _ArrayEdt_ReadClipboard2Rows($hList)
; Parameters ....: $hList       - Handle to listview control
; Return values .: None
; Remarks .......: For Internal Use Only
;				   Accepts one row per line, format is 'value1|value2|value3'
; ===============================================================================================================================
Func _ArrayEdt_ReadClipboard2Rows($hList)
	Local $iItems = _GUICtrlListView_GetItemCount($hList)
	Local $iCols = _GUICtrlListView_GetColumnCount($hList)
	Local $sClip = ClipGet()
	If $sClip Then
		Local $hPbar = _ArrayEdt_Progress(1)
		_GUICtrlListView_BeginUpdate($hList)
		Local $asLine, $asTmpRow
		$asLine = StringSplit($sClip,@LF)
		For $i = 1 To $asLine[0]
			If Mod($i,Int($asLine[0]/24)) = 0 Then _ArrayEdt_Progress(0,$hPbar,100/$asLine[0]*$i)
			$asLine[$i] = StringReplace($asLine[$i],@CR,'')
			$asLine[$i] = StringReplace($asLine[$i],@TAB,'')
			$asTmpRow = StringSplit($asLine[$i],'|')
			If $asTmpRow[0] = $iCols Then
				_GUICtrlListView_InsertItem($hList,$asTmpRow[1],_GUICtrlListView_GetItemCount($hList))
				For $k = 2 To $asTmpRow[0]
					_GUICtrlListView_SetItemText($hList,_GUICtrlListView_GetItemCount($hList)-1,$asTmpRow[$k],$k-1)
				Next
			Else
				ConsoleWrite("Cannot read: '" &$asLine[$i]&"'"&@LF)
			EndIf
		Next
		_ArrayEdt_SetSelItem($hList,$iItems)
		_ArrayEdt_Progress(0,$hPbar,100)
		_GUICtrlListView_EndUpdate($hList)
		_ArrayEdt_Progress(-1,$hPbar)
		_ArrayEdt_Info('Read from Clipboard',$asLine[0] & ' lines read from clipboard,'& @TAB & @LF & _
											_GUICtrlListView_GetItemCount($hList)-$iItems & ' rows added to list.')
	Else
		_ArrayEdt_Info('Read from Clipboard','Error: could not read text from clipboard.' & @LF & @LF & _
											 "Please use the same format as produced by the 'Copy to Clipboard' function." & @TAB & @LF & _
											 "i.e.: 'value1|value2|value3'")
	EndIf
EndFunc   ;==>_ArrayEdt_ReadClipboard2Rows
