Opt("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 2)
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <SendMessage.au3>

Global $hDragImageList, $h_ListView, $bDragging = False, $LV_Height, $fNoImage
Global $a_index[2] ; from and to

Global Const $DebugIt = 0

;Opt("WinTitleMatchMode", 2)

Local Const $image_width = 20
Local Const $image_height = 20
Local $h_images, $main_GUI, $iIndex, $sTitle = "Listview Drag & Drop Rearrange"

#cs
	Switch MsgBox(262144 + 4, $sTitle, '"Yes" for listview with icons' & @LF & '"No" for standard listview')
	Case 6
	$fNoImage = False
	Case 7
	$fNoImage = True
	EndSwitch
#CE

$main_GUI = GUICreate($sTitle, 350, 220)
$h_ListView = _GUICtrlListView_Create($main_GUI, "Entry Name|Category", 5, 10, 340, 200, -1, BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))
;MsgBox(0, "", "ctrlid = " & _WinAPI_GetDlgCtrlID($h_ListView))

$LV_Height = _WinAPI_GetClientHeight($h_ListView) - 75

_GUICtrlListView_SetColumnWidth($h_ListView, 0, 160)
_GUICtrlListView_SetColumnWidth($h_ListView, 1, 160)


_GUICtrlListView_SetExtendedListViewStyle($h_ListView, _
		BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_GRIDLINES, _
		$LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))

GUICtrlSetTip(-1, "HDD Information")

;Register WM_NOTIFY events
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg($WM_LBUTTONUP, "WM_LBUTTONUP")
GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE")
;GUIRegisterMsg($WM_SIZE, "WM_SIZE")

Local $y = 1
For $x = 0 To 30
	$iIndex = _GUICtrlListView_AddItem($h_ListView, "Name " & $x + 1, $y) ; handle, string, image index
	_GUICtrlListView_AddSubItem($h_ListView, $iIndex, "Category " & $x + 1, 1, $y + 1) ; handle, index, string, subitem, image index
	$y += 2
Next

GUISetState()

While 1
	Switch GUIGetMsg()
		;This case statement exits and updates code if needed
		Case $GUI_EVENT_CLOSE
			ExitLoop
			;put all the misc. stuff here
		Case Else
			;;;
	EndSwitch
WEnd

GUIDelete()

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
	_GUICtrlListView_GetItemEx($h_ListView, $struct_LVITEM)
	If @error Then Return SetError(-1, -1, -1)

	Local $item_state = DllStructGetData($struct_LVITEM, "State")
	DllStructSetData($struct_LVITEM, "Item", $i_ToItem)

	Local $i_newIndex = _GUICtrlListView_InsertItem($h_ListView, _GUICtrlListView_GetItemText($h_ListView, $i_FromItem), $i_ToItem, DllStructGetData($struct_LVITEM, "Image"))
	If @error Then Return SetError(-1, -1, -1)

	If $DebugIt Then _DebugPrint("$i_newIndex = " & $i_newIndex)
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_STATE)
	DllStructSetData($struct_LVITEM, "Item", $i_newIndex)
	DllStructSetData($struct_LVITEM, "State", $item_state)
	DllStructSetData($struct_LVITEM, "StateMask", $LVIS_STATEIMAGEMASK)
	_GUICtrlListView_SetItemState($h_ListView, $i_newIndex, $item_state, $LVIS_STATEIMAGEMASK)
	If @error Then Return SetError(-1, -1, -1)

	Return $i_newIndex
EndFunc   ;==>_LVInsertItem

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
	_GUICtrlListView_GetItemEx($h_ListView, $struct_LVITEM)

	; set to
	DllStructSetData($struct_LVITEM, "Item", $i_ToItem)

	; set text
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_TEXT)
	DllStructSetData($struct_LVITEM, "Text", $sBuffer_pointer)
	DllStructSetData($struct_LVITEM, "TextMax", 4096)
	_GUICtrlListView_SetItemEx($h_ListView, $struct_LVITEM)
	If @error Then Return SetError(@error, @error, @error)

	; set status
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_STATE)
	_GUICtrlListView_SetItemEx($h_ListView, $struct_LVITEM)

	; set state
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_STATE)
	DllStructSetData($struct_LVITEM, "State", $LVIF_STATE)
	_GUICtrlListView_SetItemEx($h_ListView, $struct_LVITEM)

	; set indent
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_INDENT)
	DllStructSetData($struct_LVITEM, "State", $LVIF_INDENT)
	_GUICtrlListView_SetItemEx($h_ListView, $struct_LVITEM)

	; set Param
	DllStructSetData($struct_LVITEM, "Mask", $LVIF_PARAM)
	DllStructSetData($struct_LVITEM, "State", $LVIF_PARAM)
	_GUICtrlListView_SetItemEx($h_ListView, $struct_LVITEM)
EndFunc   ;==>_LVCopyItem

Func ListView_Click()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("$NM_CLICK")
	;----------------------------------------------------------------------------------------------
EndFunc   ;==>ListView_Click

Func ListView_DoubleClick()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then _DebugPrint("$NM_DBLCLK")
	;----------------------------------------------------------------------------------------------
EndFunc   ;==>ListView_DoubleClick

Func WM_MOUSEMOVE($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $MsgID, $wParam

	If $bDragging = False Then Return $GUI_RUNDEFMSG

	;ToDo
	;Checks handle

	_GUICtrlListView_SetInsertMarkColor($h_ListView, 0xFF0000)

	Local $lpos = ControlGetPos($hWndGUI, "", $h_ListView)
	Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
	Local $y = BitShift($lParam, 16) - $lpos[1]
	If $y > $LV_Height - 20 Then; down
		_GUICtrlListView_SetInsertMark($hWndGUI, _WinAPI_GetDlgCtrlID($h_ListView), True);after
		If $DebugIt Then _DebugPrint(@CRLF & "Down: " & $y & @TAB & "$LV_Height: " & $LV_Height)

		_GUICtrlListView_Scroll($h_ListView, 0, $y)

	ElseIf $y < 20 Then ; Up
		_GUICtrlListView_SetInsertMark($hWndGUI, _WinAPI_GetDlgCtrlID($h_ListView), False);before
		If $DebugIt Then _DebugPrint(@CRLF & "Up: " & $y * - 1 & @TAB & "$LV_Height: " & $LV_Height)
		_GUICtrlListView_Scroll($h_ListView, 0, $y * - 1);subir
	EndIf

	;_GUIImageList_DragMove($x, $y)

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOUSEMOVE

Func WM_LBUTTONUP($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $MsgID, $wParam
	$bDragging = False

	Local $lpos = ControlGetPos($hWndGUI, "", $h_ListView)
	Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
	Local $y = BitShift($lParam, 16) - $lpos[1]
	If $DebugIt Then _DebugPrint("$x = " & $x)
	If $DebugIt Then _DebugPrint("$y = " & $y)
	_GUIImageList_DragLeave($h_ListView)
	_GUIImageList_EndDrag()
	_WinAPI_ReleaseCapture()

	Local $struct_LVHITTESTINFO = DllStructCreate($tagLVHITTESTINFO)

	DllStructSetData($struct_LVHITTESTINFO, "X", $x)
	DllStructSetData($struct_LVHITTESTINFO, "Y", $y)
	$a_index[1] = _SendMessage($h_ListView, $LVM_HITTEST, 0, DllStructGetPtr($struct_LVHITTESTINFO), 0, "wparam", "ptr")
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

		For $x = 1 To _GUICtrlListView_GetColumnCount($h_ListView) - 1
			_LVCopyItem($From_index, $i_newIndex, $x)
			If @error Then
				Return SetError(-1, -1, $GUI_RUNDEFMSG)

			EndIf
		Next

		_GUICtrlListView_DeleteItem($h_ListView, $From_index)

	EndIf

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LBUTTONUP

; WM_NOTIFY event handler
Func WM_NOTIFY($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $tNMHDR, $code, $x, $y, $tNMLISTVIEW, $hwndFrom, $tDraw, $dwDrawStage, $dwItemSpec
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam) ;NMHDR (hwndFrom, idFrom, code)
	If @error Then Return
	$code = DllStructGetData($tNMHDR, "Code")
	$hwndFrom = DllStructGetData($tNMHDR, "hWndFrom")
	Switch $hwndFrom
		Case $h_ListView
			Switch $code
				Case $LVN_BEGINDRAG
					If $DebugIt Then _DebugPrint("$LVN_BEGINDRAG")
					$x = BitAND($lParam, 0xFFFF)
					$y = BitShift($lParam, 16)
					$tNMLISTVIEW = DllStructCreate($tagNMLISTVIEW, $lParam)
					$a_index[0] = DllStructGetData($tNMLISTVIEW, "Item")
					$hDragImageList = _GUICtrlListView_CreateDragImage($h_ListView, $a_index[0])
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)

					_GUIImageList_BeginDrag($hDragImageList[0], 0, 0, 0)
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)

					If $DebugIt Then _DebugPrint("From = " & $a_index[0])

					#cs
						; commenting out this does not shows dragged image
						_GUIImageList_DragEnter($h_ListView, $x, $y)

					#ce

					_WinAPI_SetCapture($hWndGUI)
					$bDragging = True
				Case $NM_CUSTOMDRAW
					If $DebugIt Then _DebugPrint("$NM_CUSTOMDRAW")
					$tDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
					$dwDrawStage = DllStructGetData($tDraw, "dwDrawStage")
					$dwItemSpec = DllStructGetData($tDraw, "dwItemSpec")
					Switch $dwDrawStage
						Case $CDDS_PREPAINT
							If $DebugIt Then _DebugPrint("$CDDS_PREPAINT")
							Return $CDRF_NOTIFYITEMDRAW
						Case $CDDS_ITEMPREPAINT
							If $DebugIt Then _DebugPrint("$CDDS_ITEMPREPAINT")
							#cs
								If BitAND($dwItemSpec, 1) = 1 Then
								DllStructSetData($tDraw, "clrTextBk", $CLR_AQUA)
								Else
								DllStructSetData($tDraw, "clrTextBk", $CLR_WHITE)
								EndIf
							#ce
							Return $CDRF_NEWFONT
					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "-->")
	ConsoleWrite("!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint
