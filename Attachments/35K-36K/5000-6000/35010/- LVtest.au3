#include-once
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>

#include "GUIListViewEx.au3"

#include<GUIImageList.au3>
#include<GUIListView.au3>
#include<Misc.au3>

#region ### START Koda GUI section ### Form=C:\AutoIt NDB Kit\- 0 Exemplos\GUIListViewEx\hGUI.kxf
$hGUI = GUICreate("LVEx Test", 390, 192, 193, 120)
GUICtrlCreateLabel("UDF ListView - single selection", 2, 15, 300, 20)
$hInsert_Button = GUICtrlCreateButton("Insert", 310, 38, 75, 30)
GUICtrlSetState(-1, $GUI_DISABLE)
$hDelete_Button = GUICtrlCreateButton("Delete", 310, 78, 75, 30)
GUICtrlSetState(-1, $GUI_DISABLE)
$hUp_Button = GUICtrlCreateButton("Move Up", 310, 8, 75, 30)
GUICtrlSetState(-1, $GUI_DISABLE)
$hDown_Button = GUICtrlCreateButton("Move Down", 310, 110, 75, 30)
GUICtrlSetState(-1, $GUI_DISABLE)
$hExit_Button = GUICtrlCreateButton("Exit", 100, 160, 75, 30)
GUICtrlSetTip(-1, "Exit")
$ListView1 = GUICtrlCreateListView("Name|Phone Number", 2, 40, 300, 115, BitOR($WS_VSCROLL, $WS_BORDER), BitOR($LVS_EX_DOUBLEBUFFER, $LVS_REPORT, $WS_EX_CLIENTEDGE, $LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $WS_EX_DLGMODALFRAME))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 120)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 170)

_GUICtrlListView_SetInsertMarkColor($ListView1, 0)

_Get_LvItems()

$ListView1_Index = _GUIListViewEx_Init($ListView1, _GUICtrlListView_GetItemTextArray($ListView1), 0, 0x00FF00)

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###


Global Const $DebugIt = 0
Global $Running = False

Global $bDragging = False, $LV_Height
Global $a_index[2] ; from and to

$LV_Height = _WinAPI_GetClientHeight($ListView1) - 75

_GUIListViewEx_DragRegister()
_GUIListViewEx_SetActive($ListView1_Index)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg($WM_LBUTTONUP, "WM_LBUTTONUP")
GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $hExit_Button
			_GUIListViewEx_Close(0)
			Exit

	EndSwitch
WEnd

Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "--> ")
	ConsoleWrite("!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint

Func _Get_LvItems()
	SplashTextOn("", "Loading Information." & @CRLF & @CRLF & "Please wait...", 300, 100, -1, -1, 33, "", "", "")
	_GUICtrlListView_DeleteAllItems($ListView1)
	For $LV_Item = 0 To 11
		GUICtrlCreateListViewItem("Name " & $LV_Item & "|Phone nº " & $LV_Item, $ListView1)
		;GUICtrlSetState(-1, $GUI_CHECKED)
	Next
	SplashOff()
EndFunc   ;==>_Get_LvItems

Func ItemChecked_Proc($iItem, $sState)

	;	_Change_btn_state()
EndFunc   ;==>ItemChecked_Proc

Func _NotAvailable()
	;must try splash
	;$begin = TimerInit()
	MsgBox(790592, "Running", "not available at the moment." & @CRLF & @CRLF & "Please wait...", 10)
EndFunc   ;==>_NotAvailable

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView

	$hWndListView = $ListView1
	If Not IsHWnd($ListView1) Then $hWndListView = GUICtrlGetHandle($ListView1)

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $LVN_BEGINDRAG
					If Not $Running Then
						If $DebugIt Then _DebugPrint("$LVN_BEGINDRAG")

						_GUIListViewEx_WM_NOTIFY_Handler($hWnd, $iMsg, $wParam, $lParam)

						;$x = BitAND($lParam, 0xFFFF)
						;$y = BitShift($lParam, 16)
						$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $lParam)
						$a_index[0] = DllStructGetData($tNMLISTVIEW, "Item")
						$hDragImageList = _GUICtrlListView_CreateDragImage($hWndListView, $a_index[0])
						If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)

						_GUIImageList_BeginDrag($hDragImageList[0], 0, 0, 0)
						If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)

						If $DebugIt Then _DebugPrint("From = " & $a_index[0])

						_WinAPI_SetCapture($hWnd)
						$bDragging = True

					EndIf

				Case $LVN_ITEMCHANGING
					If $Running Then _
							Return 1

				Case $LVN_KEYDOWN
					If Not $Running Then
						If _IsPressed("20") Then;SpaceBar
							Local $iIndex = _GUICtrlListView_GetSelectedIndices($ListView1)
							Local $iText = _GUICtrlListView_GetItemText(GUICtrlGetHandle($ListView1), _GUICtrlListView_GetSelectedIndices($ListView1), 0)
							ItemChecked_Proc($iText, _GUICtrlListView_GetItemChecked($ListView1, $iIndex) = 0)
						EndIf

						If _IsPressed("74") Then; F5
							_Get_LvItems()
						EndIf
					Else
						_NotAvailable()
					EndIf

				Case $NM_RCLICK
					If Not $Running Then
						Switch MsgBox(4 + 32, "Refresh", "Refresh List?", 10)
							Case -1
								Beep(10, 10)
							Case 6
								_Get_LvItems()
						EndSwitch

					Else
						_NotAvailable()
					EndIf

				Case $LVN_COLUMNCLICK
					; removed Sort by LVSort()
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					_GUICtrlListView_SortItems($hWndFrom, DllStructGetData($tInfo, "SubItem"))

				Case $NM_DBLCLK
					MsgBox(528420, "Refresh", "Refresh List?")

				Case $NM_CLICK
					If Not $Running Then
						Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
						Local $iIndex = DllStructGetData($tInfo, "Index")

						If $iIndex <> -1 Then
							Local $iX = DllStructGetData($tInfo, "X")
							Local $iPart = 1
							If _GUICtrlListView_GetView($ListView1) = 1 Then $iPart = 2 ;for large icons view
							Local $aIconRect = _GUICtrlListView_GetItemRect($ListView1, $iIndex, $iPart)
							If $iX < $aIconRect[0] And $iX >= 5 Then
								;ItemChecked_Proc(_GUICtrlListView_GetItemText($ListView1, $iIndex), _
								;		_GUICtrlListView_GetItemChecked($ListView1, $iIndex) = 0)
								Return 0
							EndIf
						EndIf
					Else
						_NotAvailable()
					EndIf
			EndSwitch

	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func WM_LBUTTONUP($hWnd, $MsgID, $wParam, $lParam)
	#forceref $MsgID, $wParam
	_GUIListViewEx_WM_LBUTTONUP_Handler($hWnd, $MsgID, $wParam, $lParam)
	$bDragging = False

	Local $lpos = ControlGetPos($hWnd, "", $ListView1)
	Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
	Local $y = BitShift($lParam, 16) - $lpos[1]
	If $DebugIt Then _DebugPrint("$x = " & $x)
	If $DebugIt Then _DebugPrint("$y = " & $y)
	_GUIImageList_DragLeave($ListView1)
	_GUIImageList_EndDrag()

	_WinAPI_ReleaseCapture()

	Local $struct_LVHITTESTINFO = DllStructCreate($tagLVHITTESTINFO)

	DllStructSetData($struct_LVHITTESTINFO, "X", $x)
	DllStructSetData($struct_LVHITTESTINFO, "Y", $y)
	$a_index[1] = _SendMessage($ListView1, $LVM_HITTEST, 0, DllStructGetPtr($struct_LVHITTESTINFO), 0, "wparam", "ptr")

	;_ArrayDisplay($a_index)

	Local $flags = DllStructGetData($struct_LVHITTESTINFO, "Flags")
	If $DebugIt Then _DebugPrint("$flags: " & $flags)
;~ // Out of the ListView?
	If $a_index[1] = -1 Then Return $GUI_RUNDEFMSG
;~ // Not in an item?
	If BitAND($flags, $LVHT_ONITEMLABEL) = 0 And BitAND($flags, $LVHT_ONITEMSTATEICON) = 0 And BitAND($flags, $LVHT_ONITEMICON) = 0 Then Return $GUI_RUNDEFMSG

	;If $a_index[0] < $a_index[1] - 1 Or $a_index[0] > $a_index[1] + 1 Then
	; make sure insert is at least 2 items above or below, don't want to create a duplicate
	If $a_index[0] < $a_index[1] Or $a_index[0] > $a_index[1] Then
		If $DebugIt Then _DebugPrint("To = " & $a_index[1])
		Local $i_newIndex = _LVInsertItem($a_index[0], $a_index[1])
		If @error Then
			Return SetError(-1, -1, $GUI_RUNDEFMSG)
		EndIf

		Local $From_index = $a_index[0]
		If $a_index[0] > $a_index[1] Then
			$From_index = $a_index[0] + 1
		EndIf

		For $x = 1 To _GUICtrlListView_GetColumnCount($ListView1) - 1
			_LVCopyItem($From_index, $i_newIndex, $x)
			If @error Then
				Return SetError(-1, -1, $GUI_RUNDEFMSG)

			EndIf
		Next

		_GUICtrlListView_DeleteItem($ListView1, $From_index)

	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LBUTTONUP

Func WM_MOUSEMOVE($hWnd, $MsgID, $wParam, $lParam)
	#forceref $MsgID, $wParam

	_GUIListViewEx_WM_MOUSEMOVE_Handler($hWnd, $MsgID, $wParam, $lParam)

	;#cs
		If $bDragging = False Then Return $GUI_RUNDEFMSG

		;ToDo
		;Checks handle

		;_GUICtrlListView_SetInsertMarkColor($ListView1, 0xFF0000)

		Local $lpos = ControlGetPos($hWnd, "", $ListView1)
		Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
		Local $y = BitShift($lParam, 16) - $lpos[1]
		If $y > $LV_Height - 17 Then; down
		;_GUICtrlListView_SetInsertMark($hWnd, _WinAPI_GetDlgCtrlID($ListView1), True);after
		If $DebugIt Then _DebugPrint(@CRLF & "Down: " & $y & @TAB & "$LV_Height: " & $LV_Height)

		_GUICtrlListView_Scroll($ListView1, 0, $y)

		ElseIf $y < 20 Then ; Up
		;_GUICtrlListView_SetInsertMark($hWnd, _WinAPI_GetDlgCtrlID($ListView1), False);before
		If $DebugIt Then _DebugPrint(@CRLF & "Up: " & $y * - 1 & @TAB & "$LV_Height: " & $LV_Height)
		_GUICtrlListView_Scroll($ListView1, 0, $y * - 1);subir
		EndIf

		;_GUIImageList_DragMove($x, $y)

		Return $GUI_RUNDEFMSG

		;_GUIListViewEx_WM_MOUSEMOVE_Handler($hWnd, $MsgID, $wParam, $lParam)
	;#ce
EndFunc   ;==>WM_MOUSEMOVE

Func _LVCopyItem($i_FromItem, $i_ToItem, $i_SubItem = 0)
	Local $struct_LVITEM = DllStructCreate($tagLVITEM)
	Local $struct_String = DllStructCreate("char Buffer[4096]")
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)

	; get from item info
	DllStructSetData($struct_LVITEM, "Mask", BitOR($LVIF_STATE, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_TEXT))
	DllStructSetData($struct_LVITEM, "StateMask", $LVIS_STATEIMAGEMASK)
	DllStructSetData($struct_LVITEM, "Item", $i_FromItem)
	DllStructSetData($struct_LVITEM, "SubItem", $i_SubItem)
	DllStructSetData($struct_LVITEM, "TextMax", 4096)
	DllStructSetData($struct_LVITEM, "Text", $sBuffer_pointer)
	_GUICtrlListView_GetItemEx($ListView1, $struct_LVITEM)

	; set to
	DllStructSetData($struct_LVITEM, "Item", $i_ToItem)

	; set text
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_TEXT)
	DllStructSetData($struct_LVITEM, "Text", $sBuffer_pointer)
	DllStructSetData($struct_LVITEM, "TextMax", 4096)
	_GUICtrlListView_SetItemEx($ListView1, $struct_LVITEM)
	If @error Then Return SetError(@error, @error, @error)

	; set status
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_STATE)
	_GUICtrlListView_SetItemEx($ListView1, $struct_LVITEM)

	; set state
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_STATE)
	DllStructSetData($struct_LVITEM, "State", $LVIF_STATE)
	_GUICtrlListView_SetItemEx($ListView1, $struct_LVITEM)

	; set indent
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_INDENT)
	DllStructSetData($struct_LVITEM, "State", $LVIF_INDENT)
	_GUICtrlListView_SetItemEx($ListView1, $struct_LVITEM)

	; set Param
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_PARAM)
	DllStructSetData($struct_LVITEM, "State", $LVIF_PARAM)
	_GUICtrlListView_SetItemEx($ListView1, $struct_LVITEM)
EndFunc   ;==>_LVCopyItem

Func _LVInsertItem($i_FromItem, $i_ToItem)
	Local $struct_LVITEM = DllStructCreate($tagLVITEM)
	If @error Then Return SetError(-1, -1, -1)

	Local $struct_String = DllStructCreate("char Buffer[4096]")
	If @error Then Return SetError(-1, -1, -1)

	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	DllStructSetData($struct_LVITEM, "Mask", BitOR($LVIF_STATE, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_TEXT))
	DllStructSetData($struct_LVITEM, "StateMask", $LVIS_STATEIMAGEMASK)
	DllStructSetData($struct_LVITEM, "Item", $i_FromItem)
	DllStructSetData($struct_LVITEM, "SubItem", 0)
	DllStructSetData($struct_LVITEM, "TextMax", 4096)
	DllStructSetData($struct_LVITEM, "Text", $sBuffer_pointer)
	_GUICtrlListView_GetItemEx($ListView1, $struct_LVITEM)
	If @error Then Return SetError(-1, -1, -1)

	Local $item_state = DllStructGetData($struct_LVITEM, "State")
	DllStructSetData($struct_LVITEM, "Item", $i_ToItem)

	Local $i_newIndex = _GUICtrlListView_InsertItem($ListView1, _GUICtrlListView_GetItemText($ListView1, $i_FromItem), $i_ToItem, DllStructGetData($struct_LVITEM, "Image"))
	If @error Then Return SetError(-1, -1, -1)

	If $DebugIt Then _DebugPrint("$i_newIndex = " & $i_newIndex)
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_STATE)
	DllStructSetData($struct_LVITEM, "Item", $i_newIndex)
	DllStructSetData($struct_LVITEM, "State", $item_state)
	DllStructSetData($struct_LVITEM, "StateMask", $LVIS_STATEIMAGEMASK)
	_GUICtrlListView_SetItemState($ListView1, $i_newIndex, $item_state, $LVIS_STATEIMAGEMASK)
	If @error Then Return SetError(-1, -1, -1)

	Return $i_newIndex
EndFunc   ;==>_LVInsertItem
