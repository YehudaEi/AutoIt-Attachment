Opt("MustDeclareVars", 1)
#include <GuiConstants.au3>
#include <GuiListView.au3>
#include <GuiStatusbar.au3>

#region Globals *************************************************************************
Global $ListView, $hDragImageList, $h_ListView, $bDragging = False, $StatusBar1, $LV_Height
Global $a_index[2] ; from and to

; Message Handlers
Global Const $WM_NOTIFY = 0x004E
Global Const $WM_LBUTTONUP = 0x202
Global Const $WM_MOUSEMOVE = 0x200
;~ Global Const $WM_SIZE = 0x05

Global Const $DebugIt = 1

Global Const $LVHT_ONITEMLABEL = 0x4
Global Const $LVHT_ONITEMSTATEICON = 0x8

;ListView Events
Global Const $LVN_FIRST = -100
Global Const $LVN_BEGINDRAG = ($LVN_FIRST - 9)
Global Const $NM_FIRST = 0
Global Const $NM_LAST = (-99)
Global Const $NM_OUTOFMEMORY = ($NM_FIRST - 1)
Global Const $NM_CLICK = ($NM_FIRST - 2)
Global Const $NM_DBLCLK = ($NM_FIRST - 3)

; ListView Messages
Global Const $LVM_HITTEST = ($LVM_FIRST + 18)
Global Const $LVM_CREATEDRAGIMAGE = ($LVM_FIRST + 33)
Global Const $LVM_SETITEM = ($LVM_FIRST + 6)

; Mask Constants
Global Const $LVIF_IMAGE = 0x0002
Global Const $LVIF_PARAM = 0x0004
Global Const $LVIF_INDENT = 0x0010
Global Const $LVIF_NORECOMPUTE = 0x0800

;~ Global Enum $LVI_MASK = 1, $LVI_IITEM, $LVI_ISUBITEM, $LVI_STATE, $LVI_STATEMASK, $LVI_PSZTEXT, _
;~ 		$LVI_CCHTEXTMAX, $LVI_IIMAGE, $LVI_LPARAM, $LVI_IINDENT

; Image List Constants
Global Const $IMAGE_BITMAP = 0
Global Const $IMAGE_ICON = 1
Global Const $IMAGE_CURSOR = 2

Global Const $LR_LOADFROMFILE = 0x0010
Global Const $LR_LOADMAP3DCOLORS = 0x1000
Global Const $LR_DEFAULTSIZE = 0x0040
Global Const $LR_LOADTRANSPARENT = 0x20

;~ Global Const $LVM_GETIMAGELIST = ($LVM_FIRST + 2)
Global Const $LVM_SETIMAGELIST = ($LVM_FIRST + 3)
#endregion End Global variables

Opt("WinTitleMatchMode", 2)

_TestDragItem()

_TestDragItemWithImages()

Func _TestDragItem()
	Local $main_GUI = GUICreate("GuiRegisterMsg Test", 500, 500, -1, -1, BitOR($WS_THICKFRAME, $WS_SIZEBOX))

	$ListView = GUICtrlCreateListView("Entry Name|Category|More", 5, 75, 300, 280, BitOR($LVS_SINGLESEL,$LVS_SHOWSELALWAYS))
	$LV_Height = 280 - 75
	$h_ListView = ControlGetHandle($main_GUI, "", $ListView)
	_GUICtrlListViewSetColumnWidth($ListView, 0, 100)
	_GUICtrlListViewSetColumnWidth($ListView, 1, 100)
	_GUICtrlListViewSetColumnWidth($ListView, 2, $LVSCW_AUTOSIZE)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
;~ 	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
	
	For $x = 0 To 20
		GUICtrlCreateListViewItem("Name " & $x + 1 & "|Category " & $x + 1 & "|More " & $x + 1, $ListView)
;~ 	_GUICtrlListViewSetCheckState($listview, $x-1)
	Next
	$StatusBar1 = _GUICtrlStatusBarCreate($main_GUI, -1, "")
	_GUICtrlStatusBarSetSimple($StatusBar1)

	GUISetState()

	;Register WM_NOTIFY  events
	GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")
	GUIRegisterMsg($WM_LBUTTONUP, "WM_LButtonUp_Events")
	GUIRegisterMsg($WM_MOUSEMOVE, "WM_MouseMove_Events")
	GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")

	While 1

		Switch GUIGetMsg()

			;-----------------------------------------------------------------------------------------
			;This case statement exits and updates code if needed
			Case $GUI_EVENT_CLOSE
				ExitLoop

				;-----------------------------------------------------------------------------------------
				;put all the misc. stuff here
			Case Else
				;;;
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>_TestDragItem

Func _TestDragItemWithImages()
	Local $AutoItIconsDir = StringReplace(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\AutoIt v3\AutoIt", "InstallDir"), "\\", "\") & "\icons"
	Local Const $image_width = 20
	Local Const $image_height = 20
	Local $h_images, $image_indexes[20]
	Local $main_GUI
	$main_GUI = GUICreate("GuiRegisterMsg Test", 225, 400, -1, -1, BitOR($WS_THICKFRAME, $WS_SIZEBOX))

	$ListView = GUICtrlCreateListView("Entry Name|Category", 5, 75, 195, 280, $LVS_SINGLESEL)
	$LV_Height = 280 - 75
	$h_ListView = ControlGetHandle($main_GUI, "", $ListView)
	_GUICtrlListViewSetColumnWidth($ListView, 0, 100)
	_GUICtrlListViewSetColumnWidth($ListView, 1, 100)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_CHECKBOXES, $LVS_EX_CHECKBOXES)
	;------------------------------------------------------
	; Using subitem images
	;------------------------------------------------------
	GUICtrlSendMsg($ListView, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_SUBITEMIMAGES, $LVS_EX_SUBITEMIMAGES)

	$h_images = _GUICtrlListViewCreateImageList($image_width, $image_height, 0x0021, 0, 4, $LVSIL_SMALL)
	For $x = 0 To 19
		$image_indexes[$x] = _GUICtrlListViewImageListAdd($h_images, @SystemDir & "\shell32.dll", $x)
	Next
;~ $image_indexes[0] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\au3.ico')
;~ $image_indexes[1] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype1.ico')
;~ $image_indexes[2] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype2.ico')
;~ $image_indexes[3] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype3.ico')
;~ $image_indexes[4] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype-blank.ico')
;~ $image_indexes[5] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\au3.ico')
;~ $image_indexes[6] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype2.ico')
;~ $image_indexes[7] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype3.ico')
;~ $image_indexes[8] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype-blank.ico')
;~ $image_indexes[9] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\au3.ico')
;~ $image_indexes[10] = _GUICtrlListViewImageListAdd($h_images, $AutoItIconsDir & '\filetype1.ico')

	_GuiCtrlListViewSetImageList($h_ListView, $h_images, $LVSIL_SMALL)
	;------------------------------------------------------
	Local $y = 0
	For $x = 0 To 9
		GUICtrlCreateListViewItem("Name " & $x + 1 & "|Category " & $x + 1, $ListView)
;~ 	GUICtrlSetImage(-1, "shell32.dll", $x)
		;------------------------------------------------------
		;------------------------------------------------------
		;------------------------------------------------------
		_GUICtrlListViewSetItemImage($h_ListView, $x, 0, $y) ; listview handle, index, subitem, image index
		_GUICtrlListViewSetItemImage($h_ListView, $x, 1, $y + 1) ; listview handle, index, subitem, image index
		$y += 2
		;------------------------------------------------------
		;------------------------------------------------------
		;------------------------------------------------------
;~ 	_GUICtrlListViewSetCheckState($listview, $x-1)
	Next
	$StatusBar1 = _GUICtrlStatusBarCreate($main_GUI, -1, "")
	_GUICtrlStatusBarSetSimple($StatusBar1)

	GUISetState()

	;Register WM_NOTIFY  events
	GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")
	GUIRegisterMsg($WM_LBUTTONUP, "WM_LButtonUp_Events")
	GUIRegisterMsg($WM_MOUSEMOVE, "WM_MouseMove_Events")
	GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")

	While 1

		Switch GUIGetMsg()

			;-----------------------------------------------------------------------------------------
			;This case statement exits and updates code if needed
			Case $GUI_EVENT_CLOSE
				ExitLoop
				;-----------------------------------------------------------------------------------------
				;put all the misc. stuff here
			Case Else
				;;;
		EndSwitch
	WEnd
	;------------------------------------------------------
	;------------------------------------------------------
	;------------------------------------------------------
	_GUICtrlListViewDestroyImageList($h_images)
	;------------------------------------------------------
	;------------------------------------------------------
	;------------------------------------------------------
	GUIDelete()
EndFunc   ;==>_TestDragItemWithImages
#region Item Function(s) **********************************************************************************************
Func _GUICtrlListViewSetItemImage($h_ListView, $i_index = 0, $i_subindex = 0, $i_IconIdex = 0)
	If Not IsHWnd($h_ListView) Then Return SetError(-1, -1, 0)
	
	Local $LVITEM_pointer, $iResult, $struct_LVITEM
	$struct_LVITEM = DllStructCreate("int;int;int;int;int;ptr;int;int;int;int")
	If @error Then
		Return SetError(-1, -1, 0)
	EndIf
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_IMAGE)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_index)
	DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $i_subindex)
	DllStructSetData($struct_LVITEM, $LVI_IIMAGE, $i_IconIdex)
	$LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
	If @error Then Return SetError(-1, -1, 0)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	If @error Then Return SetError(-1, -1, 0)
	;****************************************************************************************
EndFunc   ;==>_GUICtrlListViewSetItemImage

Func _LVInsertItem($i_FromItem, $i_ToItem)
	Local $struct_LVITEM = DllStructCreate("int;int;int;int;int;ptr;int;int;int;int")
	If @error Then Return SetError(-1, -1, -1)
	Local $struct_String = DllStructCreate("char[4096]")
	If @error Then Return SetError(-1, -1, -1)
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
	DllStructSetData($struct_LVITEM, $LVI_MASK, BitOR($LVIF_STATE, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_TEXT))
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, $LVIS_STATEIMAGEMASK)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_FromItem)
	DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, 0)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, 4096)
	DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $sBuffer_pointer)
	_SendMessage($h_ListView, $LVM_GETITEMA, 0, $LVITEM_pointer)
	If @error Then Return SetError(-1, -1, -1)
	Local $item_state = DllStructGetData($struct_LVITEM, $LVI_STATE)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_ToItem)
	Local $i_newIndex = _SendMessage($h_ListView, $LVM_INSERTITEMA, 0, DllStructGetPtr($struct_LVITEM))
	If @error Then Return SetError(-1, -1, -1)
	If $DebugIt Then _DebugPrint("$i_newIndex = " & $i_newIndex)
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_newIndex)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $item_state)
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, $LVIS_STATEIMAGEMASK)
	Local $iResult = _SendMessage($h_ListView, $LVM_SETITEMSTATE, $i_newIndex, DllStructGetPtr($struct_LVITEM))
	If @error Then Return SetError(-1, -1, -1)
	Return $i_newIndex
EndFunc   ;==>_LVInsertItem

Func _LVCopyItem($i_FromItem, $i_ToItem, $i_SubItem = 0)
	Local $struct_LVITEM = DllStructCreate("int;int;int;int;int;ptr;int;int;int;int")
	Local $struct_String = DllStructCreate("char[4096]")
	Local $sBuffer_pointer = DllStructGetPtr($struct_String)
	Local $LVITEM_pointer = DllStructGetPtr($struct_LVITEM)
	; get from item info
	DllStructSetData($struct_LVITEM, $LVI_MASK, BitOR($LVIF_STATE, $LVIF_IMAGE, $LVIF_INDENT, $LVIF_PARAM, $LVIF_TEXT))
	DllStructSetData($struct_LVITEM, $LVI_STATEMASK, $LVIS_STATEIMAGEMASK)
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_FromItem)
	DllStructSetData($struct_LVITEM, $LVI_ISUBITEM, $i_SubItem)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, 4096)
	DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $sBuffer_pointer)
	_SendMessage($h_ListView, $LVM_GETITEMA, 0, $LVITEM_pointer)

	; set to
	DllStructSetData($struct_LVITEM, $LVI_IITEM, $i_ToItem)
	; set text
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_TEXT)
	DllStructSetData($struct_LVITEM, $LVI_PSZTEXT, $sBuffer_pointer)
	DllStructSetData($struct_LVITEM, $LVI_CCHTEXTMAX, 4096)
	Local $iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	If @error Then Return SetError(@error, @error, @error)
	; set status
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set image
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_IMAGE)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_IMAGE)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set state
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_STATE)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_STATE)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set indent
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_INDENT)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_INDENT)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
	; set Param
	DllStructSetData($struct_LVITEM, $LVI_MASK, $LVIF_PARAM)
	DllStructSetData($struct_LVITEM, $LVI_STATE, $LVIF_PARAM)
	$iResult = _SendMessage($h_ListView, $LVM_SETITEM, 0, $LVITEM_pointer)
EndFunc   ;==>_LVCopyItem
#endregion Item Function(s) *******************************************************************************************

#region Image Lists ***********************************************************************************************
Func _GUICtrlListViewCreateImageList($iCX = 16, $iCY = 16, $iFlags = 0x0021, $iInitial = 4, $iGrow = 4, $iType = 0)
	Local $h_images, $aResult
	If @error Then Return SetError(-1, -1, 0)
	$h_images = DllCall("ComCtl32.dll", "hwnd", "ImageList_Create", "int", $iCX, "int", $iCY, _
			"int", $iFlags, "int", $iInitial, "int", $iGrow)
	If @error Then Return SetError(-1, -1, 0)
	$h_images = $h_images[0]
	Return $h_images
EndFunc   ;==>_GUICtrlListViewCreateImageList

Func _GUICtrlListViewDestroyImageList($h_images)
	Local $result = DllCall("ComCtl32.dll", "int", "ImageList_Destroy", "hwnd", $h_images)
	If @error Then Return SetError(-1, -1, 0)
	Return $result[0]
EndFunc   ;==>_GUICtrlListViewDestroyImageList

Func _GuiCtrlListViewSetImageList($h_LV, $h_images, $iType = 0)
	Local $iResult = _SendMessage($h_LV, $LVM_SETIMAGELIST, $iType, $h_images)
	If @error Then
		Return SetError(-1, -1, 0)
	EndIf
	Return $iResult
EndFunc   ;==>_GuiCtrlListViewSetImageList

Func _GUICtrlListViewImageListAdd($hImageList, $szFile, $nIconID = -1, $i_Width = -1, $i_Height = -1, $Mask = 0)
	Local $result
	Local $ext = StringLower(StringRight($szFile, 3))
	If $ext = "ico" Or $ext = "cur" Or $ext = "exe" Or $ext = "dll" Then
		If $nIconID = -1 Then $nIconID = 0
		Local $hIcon = DllStructCreate("int")
		$result = DllCall("shell32.dll", "int", "ExtractIconEx", "str", $szFile, "int", $nIconID, "hwnd", 0, "ptr", DllStructGetPtr($hIcon), "int", 1)
		If @error Then Return SetError(-1, -1, 0)
		$result = $result[0]
		If $result > 0 Then
			Local $icon_handle = DllStructGetData($hIcon, 1)
			$result = DllCall("ComCtl32.dll", "int", "ImageList_ReplaceIcon", "hwnd", $hImageList, "int", -1, _
					"hwnd", $icon_handle)
			If @error Then Return SetError(-1, -1, 0)
			DllCall("user32.dll", "int", "DestroyIcon", "hwnd", $icon_handle)
			If @error Then Return SetError(-1, -1, 0)
			Return $result[0]
		EndIf
	ElseIf $ext = "bmp" Then
		Local $fuLoad = $LR_LOADFROMFILE
		If $i_Width = -1 Then $i_Width = 20
		If $i_Height = -1 Then $i_Height = 20
		Local $h_Bitmap = DllCall('user32.dll', 'hwnd', 'LoadImage', 'hwnd', 0, 'str', $szFile, _
				'int', 0, 'int', $i_Width, 'int', $i_Height, 'int', $fuLoad)
		If @error Then Return SetError(-1, -1, 0)
		$result = DllCall("ComCtl32.dll", "int", "ImageList_Add", "hwnd", $hImageList, "hwnd", $h_Bitmap[0], "hwnd", $Mask)
		If @error Then Return SetError(-1, -1, 0)
		DllCall('gdi32.dll', 'int', 'DeleteObject', 'hwnd', $h_Bitmap[0])
		Return $result[0]
	EndIf
EndFunc   ;==>_GUICtrlListViewImageListAdd

Func _GUICtrlListViewImageListRemove($hImageList, $iIndex = -1) ; -1 removes all images
	Local $result = DllCall("ComCtl32.dll", "int", "ImageList_Remove", "hwnd", $hImageList, "int", $iIndex)
	If @error Then Return SetError(-1, -1, 0)
	Return $result[0]
EndFunc   ;==>_GUICtrlListViewImageListRemove

Func _GUICtrlListViewReleaseBitMap(ByRef $hLVBitmap)
	DllCall('gdi32.dll', 'int', 'DeleteObject', 'hwnd', $hLVBitmap)
	If @error Then Return SetError(-1, -1, 0)
EndFunc   ;==>_GUICtrlListViewReleaseBitMap
#endregion Images Lists ***********************************************************************************************

#region Event Function(s) **********************************************************************************************
Func MY_WM_SIZE()
	_GUICtrlStatusBarResize($StatusBar1)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_SIZE

Func ListView_Click()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then
		_DebugPrint("$NM_CLICK")
		_GUICtrlStatusBarSetText($StatusBar1, "$NM_CLICK", $SB_SIMPLEID)
	EndIf
	;----------------------------------------------------------------------------------------------
EndFunc   ;==>ListView_Click

Func ListView_DoubleClick()
	;----------------------------------------------------------------------------------------------
	If $DebugIt Then
		_DebugPrint("$NM_DBLCLK")
		_GUICtrlStatusBarSetText($StatusBar1, "$NM_DBLCLK", $SB_SIMPLEID)
	EndIf
	;----------------------------------------------------------------------------------------------
	MsgBox(0, "Double Clicked", _GUICtrlListViewGetItemText($ListView, _GUICtrlListViewGetSelectedIndices($ListView)))
EndFunc   ;==>ListView_DoubleClick

Func WM_MouseMove_Events($hWndGUI, $MsgID, $wParam, $lParam)
	If $bDragging = False Then Return $GUI_RUNDEFMSG
	Local $lpos = ControlGetPos($hWndGUI, "", $ListView)
	Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
	Local $y = BitShift($lParam, 16) - $lpos[1]
;~ 	ToolTip("Test Mouse Move: " & $y & @CRLF & $LV_Height)
	If $y > $LV_Height Then 
		_GUICtrlListViewScroll($ListView, 0, $y)
	ElseIf $y < 20 Then
		_GUICtrlListViewScroll($ListView, 0, $y * -1)
	EndIf
	DllCall("ComCtl32.dll", "int", "ImageList_DragMove", "int", $x, "int", $y)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MouseMove_Events

Func WM_LButtonUp_Events($hWndGUI, $MsgID, $wParam, $lParam)
	$bDragging = False
	Local $lpos = ControlGetPos($hWndGUI, "", $ListView)
	Local $x = BitAND($lParam, 0xFFFF) - $lpos[0]
	Local $y = BitShift($lParam, 16) - $lpos[1]

	DllCall("ComCtl32.dll", "int", "ImageList_DragLeave", "hwnd", $h_ListView)
	DllCall("ComCtl32.dll", "int", "ImageList_EndDrag")
	DllCall("ComCtl32.dll", "int", "ImageList_Destroy", "hwnd", $hDragImageList)
	DllCall("user32.dll", "int", "ReleaseCapture")
	
	Local $struct_LVHITTESTINFO = DllStructCreate("int;int;uint;int;int;int")
	
	DllStructSetData($struct_LVHITTESTINFO, 1, $x)
	DllStructSetData($struct_LVHITTESTINFO, 2, $y)
	$a_index[1] = GUICtrlSendMsg($ListView, $LVM_HITTEST, 0, DllStructGetPtr($struct_LVHITTESTINFO))
	Local $flags = DllStructGetData($struct_LVHITTESTINFO, 2)
;~ 	// Out of the ListView?
	If $a_index[1] == -1 Then Return $GUI_RUNDEFMSG
;~ 	// Not in an item?
	If BitAND($flags, $LVHT_ONITEMLABEL) == 0 And BitAND($flags, $LVHT_ONITEMSTATEICON) == 0 Then Return $GUI_RUNDEFMSG
	If $a_index[0] <> $a_index[1] Then
		If $DebugIt Then _DebugPrint("To = " & $a_index[1])
		If  ($a_index[0] <> $a_index[0] + 1) Then
			Local $i_newIndex = _LVInsertItem($a_index[0], $a_index[1])
			If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
			Local $From_index = $a_index[0]
			If $a_index[0] > $a_index[1] Then $From_index = $a_index[0] + 1
			For $x = 1 To _GUICtrlListViewGetSubItemsCount($ListView) - 1
				_LVCopyItem($From_index, $i_newIndex, $x)
				If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
			Next
			_GUICtrlListViewDeleteItem($ListView, $From_index)
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_LButtonUp_Events
;
; WM_NOTIFY event handler
Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $tagNMHDR, $event, $hwndFrom, $code
	$tagNMHDR = DllStructCreate("int;int;int", $lParam) ;NMHDR (hwndFrom, idFrom, code)
	If @error Then Return
	$code = DllStructGetData($tagNMHDR, 3)
	Switch $wParam
		Case $ListView
			Switch $code
				Case $NM_CLICK
					ListView_Click()
				Case $NM_DBLCLK
					ListView_DoubleClick()
				Case $LVN_BEGINDRAG
					Local $x = BitAND($lParam, 0xFFFF)
					Local $y = BitShift($lParam, 16)
					Local $struct_Point = DllStructCreate("int;int")
					DllStructSetData($struct_Point, 1, 8)
					DllStructSetData($struct_Point, 2, 8)
					Local $struct_tagNMLISTVIEW = DllStructCreate("int;uint;uint;int;int;uint;uint;uint;int;int;int", $lParam)
					$a_index[0] = DllStructGetData($struct_tagNMLISTVIEW, 4)
					$hDragImageList = _SendMessage($h_ListView, $LVM_CREATEDRAGIMAGE, $a_index[0], DllStructGetPtr($struct_Point))
					Local $struct_ImageInfo = DllStructCreate("int;int;int;int;int;int;int;int")
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
					Local $struct_ImageInfo_pointer = DllStructGetPtr($struct_ImageInfo)
					Local $aResult = DllCall("ComCtl32.dll", "int", "ImageList_GetImageInfo", "hwnd", $hDragImageList, "int", 0, _
							"ptr", $struct_ImageInfo_pointer)
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
					DllCall("ComCtl32.dll", "int", "ImageList_BeginDrag", "hwnd", $hDragImageList, "int", 0, "int", 0, "int", 0)
					If @error Then Return SetError(-1, -1, $GUI_RUNDEFMSG)
					If $DebugIt Then _DebugPrint("From = " & $a_index[0])
					Local $hDesktopWindow = DllCall("user32.dll", "int", "GetDesktopWindow")
					$hDesktopWindow = $hDesktopWindow[0]
					DllCall("ComCtl32.dll", "int", "ImageList_DragEnter", "hwnd", $hDesktopWindow, "int", $x, "int", $y)
					DllCall("user32.dll", "int", "SetCapture", "hwnd", $hWndGUI)
					$bDragging = True
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_Notify_Events
#endregion Event Function(s) ***********************************************************************************************

Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "-->")
	ConsoleWrite("!===========================================================" & @LF & _
			"+===========================================================" & @LF & _
			"-->" & $s_text & @LF & _
			"+===========================================================" & @LF)
EndFunc   ;==>_DebugPrint