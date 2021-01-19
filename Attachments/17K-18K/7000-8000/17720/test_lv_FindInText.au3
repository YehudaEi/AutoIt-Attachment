#Include <GuiListView.au3>
AutoItSetOption('GUICloseOnEsc',0)
AutoItSetOption('TrayAutoPause',0)
AutoItSetOption('GuiOnEventMode',1)

Global Const $KEY_ARROW_DOWN = '28'
Global Const $KEY_ARROW_UP = '26'
Global $appTitle = 'ViewDirs'
Global $gui,$glList,$giInput
Dim $aGuiSize[5] = [4,-1,-1,700,300]
Global $input_new,$input_old
Global $lastFindIdx = -1
Global $user32dll = DllOpen("user32.dll")

setupGui()

While 1
	Sleep(20)
	If ControlGetFocus($appTitle) = 'Edit1' Then
		If _IsPressed($KEY_ARROW_DOWN,$user32dll) Then
			Local $selIdx = _GUICtrlListView_GetSelectedIndices($glList,True)
			If $selIdx[0] Then $lastFindIdx = $selIdx[1]
			updateList($input_new,0)
			untilKeyReleased($KEY_ARROW_DOWN)
		ElseIf _IsPressed($KEY_ARROW_UP,$user32dll) Then
			updateList($input_new,1)
			untilKeyReleased($KEY_ARROW_UP)
		EndIf
	EndIf	
WEnd

Func untilKeyReleased($sKey)
	While _IsPressed($sKey,$user32dll)
		Sleep(10)
	WEnd
EndFunc

Func chkInput($hGI)
	$input_new = GUICtrlRead($hGI)
	If $input_new <> $input_old Then
		$lastFindIdx -= 1
		updateList($input_new)
		$input_old = $input_new
	EndIf
EndFunc

Func removeListViewIndexes($hLV)
	Local $selIdx = _GUICtrlListView_GetSelectedIndices($hLV,1)
	If $selIdx[0] Then
		For $i = 1 To $selIdx[0]
			_GUICtrlListView_SetItemSelected($hLV,$selIdx[$i],0)
		Next
	EndIf
EndFunc

Func updateList($input,$bReverse = 0)
	Local $iIdx = _GUICtrlListView_FindInText($glList,$input,$lastFindIdx,1,$bReverse)
	If $iIdx > -1 Then
		removeListViewIndexes($glList)
		_GUICtrlListView_SetItemSelected($glList,$iIdx,1)
		_GUICtrlListView_EnsureVisible($glList,$iIdx)
		$lastFindIdx = $iIdx
		Return True
	EndIf
	$lastFindIdx = -1
	Return False
EndFunc

Func setupGui()
	$gui = GUICreate($appTitle,$aGuiSize[3],$aGuiSize[4],$aGuiSize[1],$aGuiSize[2],BitOR($WS_OVERLAPPEDWINDOW,$WS_CLIPSIBLINGS))
	GUISetOnEvent($GUI_EVENT_CLOSE,'chkGuiMsg')
	$glList = GUICtrlCreateListView('Column-1|Column-2|Column-3|Column-4|Column-5',0,0,$aGuiSize[3],$aGuiSize[4]-46,$LVS_SHOWSELALWAYS)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP+$GUI_DOCKBOTTOM)
	_GUICtrlListView_SetColumnWidth($glList,0,220)
	_GUICtrlListView_SetColumnWidth($glList,1,170)
	_GUICtrlListView_SetExtendedListViewStyle($glList,BitOR($LVS_EX_HEADERDRAGDROP,$LVS_EX_FULLROWSELECT))
	$giInput = GUICtrlCreateInput('',0,$aGuiSize[4]-42,$aGuiSize[3]-400,20)
	GUICtrlSetResizing(-1,$GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	GUICtrlSetTip(-1,'Instructions:'&@LF&'Type text to find files,'&@LF&'Arrow DOWN: jump to next hit,'&@LF&'Arrow UP: jump to first hit')
	For $j = 1 to 5
		For $i = 1 To 10
			GUICtrlCreateListViewItem('This is a test|123456789|987654321|abcd|efgh',$glList)
		Next
		GUICtrlCreateListViewItem('This is a test ball|1234567890|9876543210|pqrs|tuvw',$glList)	
	Next
	GUISetState()
	GUIRegisterMsg($WM_COMMAND,'WM_COMMAND')
	ControlFocus($appTitle,'',$giInput)
EndFunc

Func chkGuiMsg()
	Switch @GUI_CtrlId
		Case 0
			Return
		Case -3
			Exit
	EndSwitch
EndFunc

Func WM_COMMAND($hWnd,$Msg,$wParam,$lParam)
    Local $nNotifyCode = BitShift($wParam,16)
    Local $nID = BitAnd($wParam,0x0000FFFF)
	Switch $nID
		Case $giInput
			Switch $nNotifyCode
				Case $EN_UPDATE
					chkInput($giInput)
			EndSwitch
	EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc
