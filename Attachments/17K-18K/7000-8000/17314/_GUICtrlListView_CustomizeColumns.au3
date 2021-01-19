#Include <GUIListView.au3>

Local $hGUI = GUICreate("Column Customize Test", 350, 200)
Local $hListView = GUICtrlCreateListView("A              |B         |C         |D         |E         ", 5, 5, 340, 165)
Local $hCustomize = GUICtrlCreateButton("Customize", 5, 175, 340, 20)

GUICtrlCreateListViewItem("Item 1A|Item 1B|Item 1C|Item 1D|Item 1E", $hListView)
GUICtrlSetImage(-1, "shell32.dll", 16)

GUICtrlCreateListViewItem("Item 2A|Item 2B|Item 2C|Item 2D|Item 2E", $hListView)
GUICtrlSetImage(-1, "shell32.dll", 40)

GUICtrlCreateListViewItem("Item 3A|Item 3B|Item 3C|Item 3D|Item 3E", $hListView)
GUICtrlSetImage(-1, "shell32.dll", 160)


GUISetState()

Local $msg
Do
	$msg = GUIGetMsg()
	If $msg = $hCustomize Then _GUICtrlListView_CustomizeColumns($hListView, 5, $hGUI)
Until $msg = $GUI_EVENT_CLOSE


; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlListView_CustomizeColumns
; Description ...: Displays a dialog for customizing (managing) a listview's columns
; Syntax.........: _GUICtrlListView_CustomizeColumns($hWnd[, $iHideThreshold = 5[, $hWndOwner = 0]])
; Parameters ....: $hWnd           - Handle to the control
;                  $iHideThreshold - Minimum pixel width of a column to be considered visible
;                  $hWndOwner      - Handle to the window that owns the dialog
; Return values .: Success      - Array with the following format:
;                  |[0] - String containing original column order, Opt('GUIDataSeparatorChar') delimited
;                  |[1] - String containing original column widths, Opt('GUIDataSeparatorChar') delimited
; Author ........: Ultima
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlListView_SetColumnOrder, _GUICtrlListView_SetColumnWidth
; ===============================================================================================================================
Func _GUICtrlListView_CustomizeColumns($hWnd, $iHideThreshold = 5, $hWndOwner = 0)
	GUISetState(@SW_DISABLE, $hWndOwner)

	Local $vMsg, $vTmp1, $vTmp2, $vTmp3, $bValid, $iNext, $iOnEventMode = Opt("GUIOnEventMode", 0)

	; Positioning
	Local $aiPos[4] = [Default, Default, 225, 225], $aiOwnerPos = WinGetPos($hWndOwner)
	If Not @error Then
		$aiPos[0] = $aiOwnerPos[0] + Int(($aiOwnerPos[2] - $aiPos[2])/2)
		$aiPos[1] = $aiOwnerPos[1] + Int(($aiOwnerPos[3] - $aiPos[3])/2)
	EndIf

	; Create controls
	Local $hCustomize = GUICreate("Customize...", $aiPos[2], $aiPos[3], $aiPos[0], $aiPos[1], $WS_POPUP + $WS_CAPTION + $WS_SYSMENU, -1, $hWndOwner)
	Local $hCustomize_ListView = GUICtrlCreateListView("Column", 5, 5, $aiPos[2]-90, $aiPos[3]-10, $LVS_NOCOLUMNHEADER + $LVS_SINGLESEL + $LVS_SHOWSELALWAYS, $LVS_EX_CHECKBOXES + $WS_EX_CLIENTEDGE)
	Local $hCustomize_MoveUp = GUICtrlCreateButton("Move &Up", $aiPos[2]-80, 5, 75, 20)
	Local $hCustomize_MoveDown = GUICtrlCreateButton("Move &Down", $aiPos[2]-80, 30, 75, 20)
	Local $hCustomize_Toggle = GUICtrlCreateButton("&Toggle", $aiPos[2]-80, 55, 75, 20)
	Local $hCustomize_OK = GUICtrlCreateButton("OK", $aiPos[2]-80, $aiPos[3]-50, 75, 20, $ES_NUMBER)
	Local $hCustomize_Cancel = GUICtrlCreateButton("Cancel", $aiPos[2]-80, $aiPos[3]-25, 75, 20, $ES_NUMBER)

	; Styles
	GUICtrlSetState($hCustomize_OK, $GUI_DEFBUTTON)

	; Create arrays...
	Local $aiColumnOrder = _GUICtrlListView_GetColumnOrderArray($hWnd)
	Local $aiColumnWidth = _ArrayCreate($aiColumnOrder[0])
	Local $asColumnText = _ArrayCreate($aiColumnOrder[0])
	Local $asReturn[2]

	; Fill arrays
	For $i = 1 To $aiColumnOrder[0]
		$aiColumnOrder[$i] = Int($aiColumnOrder[$i])

		_ArrayAdd($aiColumnWidth, _GUICtrlListView_GetColumnWidth($hWnd, $i-1))
		If $aiColumnWidth[$i] < $iHideThreshold Then $aiColumnWidth[$i] = 0

		$vTmp1 = _GUICtrlListView_GetColumn($hWnd, $i-1)
		_ArrayAdd($asColumnText, $vTmp1[5])
	Next
	$asReturn[0] = _ArrayToString($aiColumnOrder, Opt('GUIDataSeparatorChar'), 1)
	$asReturn[1] = _ArrayToString($aiColumnWidth, Opt('GUIDataSeparatorChar'), 1)

	; Fill selection listview
	For $i = 1 To $aiColumnOrder[0]
		_GUICtrlListView_InsertItem($hCustomize_ListView, $asColumnText[$aiColumnOrder[$i]+1])
		If $aiColumnWidth[$aiColumnOrder[$i]+1] Then _GUICtrlListView_SetItemChecked($hCustomize_ListView, $i-1)
	Next
	_GUICtrlListView_SetColumnWidth($hCustomize_ListView, 0, $LVSCW_AUTOSIZE_USEHEADER)

	; Show and loop
	GUISetState(@SW_SHOW, $hCustomize)

	While 1
		$vMsg = GUIGetMsg()
		Switch $vMsg

			Case $GUI_EVENT_CLOSE, $hCustomize_Cancel
				ExitLoop

			Case $hCustomize_OK
				_GUICtrlListView_SetColumnOrder($hWnd, _ArrayToString($aiColumnOrder, "|", 1, $aiColumnOrder[0]))
				For $i = 1 To $aiColumnOrder[0]
					$vTmp1 = $aiColumnOrder[$i]
					$vTmp2 = 0
					If _GUICtrlListView_GetItemChecked($hCustomize_ListView, $i-1) Then
						$vTmp2 = $aiColumnWidth[$vTmp1+1]
						If $vTmp2 < $iHideThreshold Then $vTmp2 = $LVSCW_AUTOSIZE_USEHEADER
					EndIf
					_GUICtrlListView_SetColumnWidth($hWnd, $vTmp1, $vTmp2)
				Next
				ExitLoop

			Case $hCustomize_MoveUp, $hCustomize_MoveDown
				$vTmp1 = String(_GUICtrlListView_GetSelectedIndices($hCustomize_ListView))
				If $vTmp1 <> "" Then
					$vTmp1 = Int($vTmp1)

					If $vMsg = $hCustomize_MoveUp Then
						$bValid = ($vTmp1 > 0)
						$iNext = -1
					Else
						$bValid = ($vTmp1 < $aiColumnOrder[0]-1)
						$iNext = 1
					EndIf

					If $bValid Then
						$vTmp2 = _GUICtrlListView_GetItemChecked($hCustomize_ListView, $vTmp1)
						$vTmp3 = _GUICtrlListView_GetItemText($hCustomize_ListView, $vTmp1)

						_ArraySwap($aiColumnOrder[$vTmp1+1 + Int(($iNext-1)/2)], $aiColumnOrder[$vTmp1+2 + Int(($iNext-1)/2)])
						_GUICtrlListView_SetItemChecked($hCustomize_ListView, $vTmp1, _GUICtrlListView_GetItemChecked($hCustomize_ListView, $vTmp1 + $iNext))
						_GUICtrlListView_SetItemText($hCustomize_ListView, $vTmp1, _GUICtrlListView_GetItemText($hCustomize_ListView, $vTmp1 + $iNext))
						_GUICtrlListView_SetItemChecked($hCustomize_ListView, $vTmp1 + $iNext, $vTmp2)
						_GUICtrlListView_SetItemText($hCustomize_ListView, $vTmp1 + $iNext, $vTmp3)
						_GUICtrlListView_SetItemSelected($hCustomize_ListView, $vTmp1 + $iNext)
						_GUICtrlListView_EnsureVisible($hCustomize_ListView, $vTmp1 + $iNext, True)
					EndIf
				EndIf

			Case $hCustomize_Toggle
				$vTmp1 = _GUICtrlListView_GetSelectedIndices($hCustomize_ListView)
				If $vTmp1 <> "" Then _GUICtrlListView_SetItemChecked($hCustomize_ListView, Int($vTmp1), Not _GUICtrlListView_GetItemChecked($hCustomize_ListView, Int($vTmp1)))

		EndSwitch
	WEnd

	GUIDelete($hCustomize)

	Opt("GUIOnEventMode", $iOnEventMode)

	GUISetState(@SW_ENABLE, $hWndOwner)

	Return $asReturn
EndFunc   ;==> _GUICtrlListView_CustomizeColumns
