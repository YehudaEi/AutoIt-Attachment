#Include <GUIConstantsEx.au3>
#Include <GUIListView.au3>
#Include <WinAPIEx.au3>

Opt('MustDeclareVars', 1)
Opt('WinWaitDelay', 0)

Global $hWnd, $hForm, $hPopup, $hActive = 0, $hOver = 0, $hListView, $tRect, $tPoint, $ID, $List, $Pos, $Text, $Title
Global $HotKey[4][2] = [['^{DEL}', 0], ['{F5}', 0], ['{F6}', 0], ['{F8}', 0]]
Global $Highlight = True, $Hold = False, $Stop = False

AutoItWinSetTitle('#CvrVi')

$Pos = _WinAPI_GetPosFromRect(_WinAPI_GetWorkArea())
$hForm = GUICreate('Control Viewer', 407-17, $Pos[3] - 53, 8, 8, BitOR($WS_CAPTION, $WS_POPUP, $WS_SIZEBOX, $WS_SYSMENU))
;~GUISetIcon(@systemDir & '\shell32.dll', 23)
GUICtrlCreateListView('Handle|Class|NN|ID|Text', 0, 0, 407-17, $Pos[3] - 53, BitOR($LVS_DEFAULT, $LVS_NOSORTHEADER), $WS_EX_WINDOWEDGE)
GUICtrlSetFont(-1, 8.5, 400, 0, 'Tahoma')
$hListView = GUICtrlGetHandle(-1)
For $i = 0 To 3
	$HotKey[$i][1] = GUICtrlCreateDummy()
Next
_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP))
_GUICtrlListView_SetColumnWidth($hListView, 0, 80)
_GUICtrlListView_SetColumnWidth($hListView, 1, 120)
_GUICtrlListView_SetColumnWidth($hListView, 2, 26)
_GUICtrlListView_SetColumnWidth($hListView, 3, 44)
_GUICtrlListView_SetColumnWidth($hListView, 4, 120)
If _WinAPI_GetVersion() >= '6.0' Then
	_WinAPI_SetWindowTheme($hListView, 'Explorer')
EndIf
GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')
GUISetState(@SW_SHOWNOACTIVATE)

$hPopup = GUICreate('', 100, 100, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST), WinGetHandle('#CvrVi'))
GUISetBkColor(0xABABAB)
GUICtrlCreateLabel('', 0, 0, 100, 2)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKHEIGHT))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1, 0xFF0000)
GUICtrlCreateLabel('', 0, 98, 100, 2)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKRIGHT, $GUI_DOCKBOTTOM, $GUI_DOCKHEIGHT))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1, 0xFF0000)
GUICtrlCreateLabel('', 0, 0, 2, 100)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKLEFT, $GUI_DOCKTOP, $GUI_DOCKBOTTOM, $GUI_DOCKWIDTH))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1, 0xFF0000)
GUICtrlCreateLabel('', 98, 0, 2, 100)
GUICtrlSetResizing(-1, BitOR($GUI_DOCKRIGHT, $GUI_DOCKTOP, $GUI_DOCKBOTTOM, $GUI_DOCKWIDTH))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1, 0xFF0000)
_WinAPI_SetLayeredWindowAttributes($hPopup, 0, 0, $LWA_ALPHA)
GUISetState(@SW_SHOWNOACTIVATE)

For $i = 0 To 3
	HotKeySet($HotKey[$i][0], '_HotKey')
Next

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $HotKey[0][1]
			If (Not $Stop) And (Not $Hold) And ($hActive) And ($hOver) Then
				ControlHide($hActive, '', $hOver)
			EndIf
		Case $HotKey[1][1]
			If (Not $Stop) And (Not $Hold) Then
				$hActive = 1
			EndIf
		Case $HotKey[2][1]
			$Stop = Not $Stop
			If (Not $Stop) And (Not $Hold) Then
				$hOver = 1
			EndIf
		Case $HotKey[3][1]
			$Highlight = Not $Highlight
			If ($Highlight) And (($Stop) Or ($Hold)) Then
				$ID = _GUICtrlListView_GetSelectedIndices($hListView)
				If $ID Then
					For $i = 0 To 1
						_GUICtrlListView_SetItemSelected($hListView, $ID, $i, $i)
					Next
				EndIf
			Else
				$hOver = 1
			EndIf
	EndSwitch
	$hWnd = WinGetHandle('[ACTIVE]')
	If $hWnd = $hPopup Then
		$hWnd = WinActivate($hForm)
	EndIf
	If $hWnd = $hForm Then
		If ($hActive) And (Not WinExists($hActive)) Then
			_GUICtrlListView_BeginUpdate($hListView)
			_GUICtrlListView_DeleteAllItems($hListView)
			_GUICtrlListView_EndUpdate($hListView)
			WinSetTitle($hForm, '', 'Control Viewer')
			$hActive = 0
			$hOver = 1
		EndIf
		$Hold = 1
	Else
		If $Hold Then
			_GUICtrlListView_SetItemFocused($hListView, _GUICtrlListView_GetSelectedIndices($hListView), 0)
			$hOver = 1
		EndIf
		$Hold = 0
	EndIf
	If ($Stop) Or ($Hold) Then
		If $hOver Then
			_WinAPI_SetLayeredWindowAttributes($hPopup, 0, 0, $LWA_ALPHA)
			$hOver = 0
		EndIf
		ContinueLoop
	EndIf
	If $hWnd <> $hActive Then
		$Text = ''
		If $hWnd Then
			$Text = WinGetTitle($hWnd)
			If $Text Then
				$Text = 'TITLE: ' & $Text
			Else
				$Text = ''
			EndIf
			$Text = StringRegExpReplace($Text & ' ; CLASS: ' & _WinAPI_GetClassName($hWnd), '( ; CLASS: )\Z|\A( ; )', '')
		EndIf
		If $Text Then
			WinSetTitle($hForm, '', '[' & $Text & ']')
		Else
			WinSetTitle($hForm, '', 'Control Viewer')
		EndIf
		$List = _WinAPI_EnumChildWindows($hWnd, 0)
		_GUICtrlListView_BeginUpdate($hListView)
		_GUICtrlListView_DeleteAllItems($hListView)
		For $i = 1 To UBound($List) - 1
			_GUICtrlListView_AddItem($hListView, $List[$i][0])
			_GUICtrlListView_AddSubItem($hListView, $i - 1, $List[$i][1], 1)
			_GUICtrlListView_AddSubItem($hListView, $i - 1, StringLeft(ControlGetText($hWnd, '', $List[$i][0]), 80), 4)
			$ID = _WinAPI_GetDlgCtrlID($List[$i][0])
			If $ID > 0 Then
				_GUICtrlListView_AddSubItem($hListView, $i - 1, $ID, 3)
			EndIf
		Next
		For $i = 1 To UBound($List) - 1
			If ($List[$i][1]) And (IsString($List[$i][1])) Then
				$ID = 1
				$Text = $List[$i][1]
				For $j = $i To UBound($List) - 1
					If $List[$j][1] = $Text Then
						$List[$j][1] = $ID
						$ID += 1
					EndIf
				Next
			EndIf
		Next
		For $i = 1 To UBound($List) - 1
			_GUICtrlListView_AddSubItem($hListView, $i - 1, $List[$i][1], 2)
		Next
		_GUICtrlListView_EndUpdate($hListView)
		_WinAPI_SetLayeredWindowAttributes($hPopup, 0, 0, $LWA_ALPHA)
		$hActive = $hWnd
		$hOver = 0
	EndIf
	If Not $hActive Then
		ContinueLoop
	EndIf
	$hWnd = 0
	$List = _WinAPI_EnumChildWindows($hActive, 0)
	If IsArray($List) Then
		If $List[0][0] = _GUICtrlListView_GetItemCount($hListView) Then
			For $i = $List[0][0] To 1 Step -1
				If Not _WinAPI_IsWindowVisible($List[$i][0]) Then
					ContinueLoop
				EndIf
				$tRect = _WinAPI_GetWindowRect($List[$i][0])
				$tPoint = _WinAPI_GetMousePos()
				If _WinAPI_PtInRect($tRect, $tPoint) Then
					$hWnd = $List[$i][0]
					ExitLoop
				EndIf
			Next
		Else
			$hActive = 1
		EndIf
	EndIf
	If $hWnd = $hOver Then
		ContinueLoop
	EndIf
	_GUICtrlListView_SetItemSelected($hListView, _GUICtrlListView_GetSelectedIndices($hListView), 0, 0)
	_WinAPI_SetLayeredWindowAttributes($hPopup, 0, 0, $LWA_ALPHA)
	If $hWnd Then
		$ID = _GUICtrlListView_FindText($hListView, $hWnd)
		If $ID <> -1 Then
			If $Highlight Then
				$Pos = _WinAPI_GetPosFromRect($tRect)
				If IsArray($Pos) Then
					WinMove($hPopup, '', $Pos[0], $Pos[1], $Pos[2], $Pos[3])
					WinSetOnTop($hPopup, '', 1)
					_WinAPI_SetLayeredWindowAttributes($hPopup, 0xABABAB, 96, BitOR($LWA_COLORKEY, $LWA_ALPHA))
				EndIf
			EndIf
			_GUICtrlListView_SetItem($hListView, StringLeft(ControlGetText($hActive, '', $hWnd), 80), $ID, 4)
			_GUICtrlListView_SetItemSelected($hListView, $ID, 1, 1)
			_GUICtrlListView_EnsureVisible($hListView, $ID, 1)
		Else
			$hActive = 1
		EndIf
	EndIf
	$hOver = $hWnd
WEnd

Func _HotKey()
	For $i = 0 To 3
		If $HotKey[$i][0] = @HotKeyPressed Then
			GUICtrlSendToDummy($HotKey[$i][1])
			Return
		EndIf
	Next
EndFunc   ;==>_HotKey

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)

	Local $tNMITEMACTIVATE = DllStructCreate($tagNMITEMACTIVATE, $lParam)
	Local $hFrom = DllStructGetData($tNMITEMACTIVATE, 'hWndFrom')
	Local $Index = DllStructGetData($tNMITEMACTIVATE, 'Index')
	Local $ID = DllStructGetData($tNMITEMACTIVATE, 'Code')

	Local $tNMLVCUSTOMDRAW = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
	Local $Stage = DllStructGetData($tNMLVCUSTOMDRAW, 'dwDrawStage')
	Local $Item = DllStructGetData($tNMLVCUSTOMDRAW, 'dwItemSpec')

	Local $Pos, $hSelect

	Switch $hFrom
		Case $hListView
			Switch $ID
				Case $LVN_BEGINDRAG
					Return 0
				Case $LVN_ITEMCHANGED
					If ($Highlight) And (WinActive($hForm)) And (WinExists($hActive)) Then
						_WinAPI_SetLayeredWindowAttributes($hPopup, 0, 0, $LWA_ALPHA)
						If BitAND(DllStructGetData($tNMITEMACTIVATE, 'NewState'), $LVIS_SELECTED) Then
							$hSelect = Ptr(_GUICtrlListView_GetItemText($hListView, $Index))
							If _WinAPI_IsWindowVisible($hSelect) Then
								$Pos = _WinAPI_GetPosFromRect(_WinAPI_GetWindowRect($hSelect))
								If IsArray($Pos) Then
									WinMove($hPopup, '', $Pos[0], $Pos[1], $Pos[2], $Pos[3])
									WinSetOnTop($hPopup, '', 1)
									_WinAPI_SetLayeredWindowAttributes($hPopup, 0xABABAB, 96, BitOR($LWA_COLORKEY, $LWA_ALPHA))
								EndIf
							EndIf
						EndIf
					EndIf
				Case $NM_CUSTOMDRAW
					Switch $Stage
						Case $CDDS_ITEMPREPAINT
							Return $CDRF_NOTIFYSUBITEMDRAW
						Case BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
							Select
								Case Not _WinAPI_IsWindowVisible(_GUICtrlListView_GetItemText($hListView, $Item))
									DllStructSetData($tNMLVCUSTOMDRAW, 'clrText', 0x0000E0)
								Case Not _WinAPI_IsWindowEnabled(_GUICtrlListView_GetItemText($hListView, $Item))
									DllStructSetData($tNMLVCUSTOMDRAW, 'clrText', 0x9C9C9C)
								Case Else

							EndSelect
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
