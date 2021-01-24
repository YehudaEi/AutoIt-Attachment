#include <GUIConstantsEx.au3>
#Include <Array.au3>
#include <WindowsConstants.au3>
#Include <GuiToolBar.au3>
#include <Constants.au3>
#include <GuiImageList.au3>
#include <EditConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include <ButtonConstants.au3>
#Include <GuiButton.au3>
#include <GuiEdit.au3>
#Include <GuiMenu.au3>
#include <file.au3>
#NoTrayIcon 

Opt("GUICloseOnESC", 0)

Global $save = True
Global $iEditFlag = 0
Global $ITEM_ADDED1 = False
Global $ITEM_ADDED2 = False
Global $ITEM_ADDED3 = False
Global $section_added = 0
Global $key_added = 0
Global $edit_mode = 0
Global $count_k = 1
Global $Last_search = ""
Global $previous_searched_item
Global $LastAddedChild
Global $LastAddedKey
Global $LastAddedSection
Global $expanded = False
Global $power_mode = False
Global $just_edited = False
Global $item_just_added = 0
Global $fDragging = False, $hDragItem, $fWhere, $moving_txt, $item_above_drag, $item_below_drag, $moving_item_is_key = false, $his_parent, $wProcOldLocal, $form3
Global $Startx, $Starty, $Endx, $Endy, $aM_Mask, $aMask
Global $set_hotkeys = 0
Global $aUtil_MinMax[4]
Dim $ini_section[1]
Global $sToolTipData, $tooltip_x, $tooltip_y, $tooltip_timer, $display_tooltip = False, $tooltip_displayed = False, $display_infos = 1, $input5, $exit_loop = False
Dim $tool_txt_array[1][1]
Dim $aRecords
dim $tooltips[1]
Global $string_splitter = "/"

Global $Last_hovered

Global Const $VK_RETURN = 0x0D ;Enter key
Global Const $VK_DELETE = 0x2E ;Del key
Global Const $VK_ESC = 0x1B ;Esc key
Global Const $VK_F2 = 0x71 ;F2 key
Global Const $VK_APP = 0x5D ;Application key

Global Enum $Save_only=2001, $Save_as1=2002
Global Enum $add_item_menu = 3001, $edit_item_menu = 3002, $delete_item_menu = 3003, $expand_item_menu = 3004, $colapse_item_menu = 3005
Global Enum $expand_all_menu = 3006, $colapse_all_menu = 3007, $gen_write_menu = 3008, $gen_read_menu = 3009, $tool_tips_menu = 3010, $tool_tip_add_menu = 3011

Global $dll = DllOpen("user32.dll")

Global $prog_name = "Ini Editor v1.2"

Global $Form1 = GUICreate($prog_name, 240+2, 500+28, -1, -1, $WS_SIZEBOX+$WS_MINIMIZEBOX+$WS_MAXIMIZEBOX)
	GUISetIcon("Shell32.dll", -70)
	GUISetBkColor(0xE0F0FE)
Global $hToolbar = _GUICtrlToolbar_Create ($Form1, $WS_TABSTOP+0x00000800)
	_GUICtrlToolbar_SetExtendedStyle($hToolbar, $TBSTYLE_EX_DRAWDDARROWS)
	_GUICtrlToolbar_SetColorScheme($hToolbar, 16774367, 16774367)
Global $idNew=1000, $idOpen=1001, $idSave=1002, $idHelp=1003, $idPower=1004

Global $hImage = _GUIImageList_Create(16, 16, 5, 3, 3)
_GUIImageList_AddIcon($hImage, "Shell32.dll", 140) ;new    0
_GUIImageList_AddIcon($hImage, "Shell32.dll", 193);-7) ;save    1
_GUIImageList_AddIcon($hImage, "Shell32.dll", -9) ;open    2
_GUIImageList_AddIcon($hImage, "Shell32.dll", 131) ;exit    3
_GUIImageList_AddIcon($hImage, "Shell32.dll", 109) ;instant    4
_GUIImageList_AddIcon($hImage, "Shell32.dll", 137) ;normal    5
_GUICtrlToolbar_SetImageList($hToolbar, $hImage)
$new_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&New")
$save_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&Save")
$open_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&Open")
$power_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&Turbo")
$Exit_button_txt = _GUICtrlToolbar_AddString($hToolbar, "E&xit")
_GUICtrlToolbar_AddButton ($hToolbar, $idNew, 0, $new_button_txt)
_GUICtrlToolbar_AddButton ($hToolbar, $idSave, 1, $save_button_txt, $BTNS_DROPDOWN)
_GUICtrlToolbar_AddButton ($hToolbar, $idOpen, 2, $open_button_txt)
_GUICtrlToolbar_AddButtonSep ($hToolbar)
_GUICtrlToolbar_AddButton ($hToolbar, $idPower, 4, $power_button_txt)
_GUICtrlToolbar_AddButtonSep ($hToolbar)
_GUICtrlToolbar_AddButton ($hToolbar, $idHelp, 3, $Exit_button_txt)

_GUICtrlToolbar_SetButtonStyle($hToolbar, $idPower, $BTNS_CHECK)
_GUICtrlToolbar_SetButtonWidth($hToolbar, 37, 37)

Global $dir_input = GUICtrlCreateInput("No file loaded", 0, 40+10, 240, 20, $ES_READONLY+$ES_AUTOHSCROLL)
	GUICtrlSetBkColor(-1, 0x003D79)
	GUICtrlSetColor(-1, 0xEDF3FE)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKHEIGHT)
Global $add_item_button = GUICtrlCreateButton("&Add", 0, 60+10, 61, 22, $BS_FLAT+$BS_NOTIFY)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	_GUICtrlButton_SetImageList(-1, _set_button_image(146), 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
Global $edit_item_button = GUICtrlCreateButton("&Edit", 60, 60+10, 61, 22, $BS_FLAT+$BS_NOTIFY)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	_GUICtrlButton_SetImageList(-1, _set_button_image(-22), 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
Global $delete_item_button = GUICtrlCreateButton("Delete", 120, 60+10, 61, 22, $BS_FLAT+$BS_NOTIFY)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	_GUICtrlButton_SetImageList(-1, _set_button_image(31), 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
Global $find_item_button = GUICtrlCreateButton("&Find", 180, 60+10, 60, 22, $BS_FLAT+$BS_NOTIFY)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	_GUICtrlButton_SetImageList(-1, _set_button_image(22), 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKSIZE)
Global $button_gen_code = GUICtrlCreateButton("&Generate AU3 Code", 0, 458, 240, 22, $BS_FLAT+$BS_NOTIFY)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	_GUICtrlButton_SetImageList(-1, _set_button_image(165), 5)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKRIGHT)
Global $val_input = GUICtrlCreateInput("", 50, 480, 190, 20, $ES_READONLY+$ES_AUTOHSCROLL)
	GUICtrlSetBkColor(-1, 0x003D79)
	GUICtrlSetColor(-1, 0xEDF3FE)
	GUICtrlSetFont(-1, -1, 800)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKHEIGHT+$GUI_DOCKRIGHT)
	
$val_label = GUICtrlCreateLabel("Value:", 5, 483, 40, 17)
	GUICtrlSetBkColor(-1, 0xD0D0D0)
	GUICtrlSetColor(-1, 0x003D79)
	GUICtrlSetFont(-1, -1, 800)	
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
	
	GUICtrlCreateGraphic(0, 480, 50, 20)
	GUICtrlSetBkColor(-1, 0x003D79)
	GUICtrlSetState(-1, $GUI_DISABLE)

$back2 = GUICtrlCreateGraphic(0, 91, @DesktopWidth, @DesktopHeight)
	GUICtrlSetBkColor(-1, 0xD0D0D0)
	GUICtrlSetState(-1, $GUI_DISABLE)

Global $find_input = GUICtrlCreateInput("", 0, 439, 100, 19, $ES_AUTOHSCROLL)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)

Global $button_find_next = GUICtrlCreateButton("Find Next", 100, 439, 55, 20, $BS_FLAT+$BS_NOTIFY)
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
Global $match_check = GUICtrlCreateCheckbox("&Match", 160, 440, 50, 17)
	GUICtrlSetBkColor(-1, 0xD0D0D0)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
Global $button_close_find = GUICtrlCreateButton("", 223, 440, 16, 16, $BS_ICON, $WS_EX_CLIENTEDGE)
	GUICtrlSetImage(-1, "Shell32.dll", -132, 0)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT+$GUI_DOCKBOTTOM+$GUI_DOCKSIZE)
GUICtrlSetState($find_input, $GUI_HIDE)
GUICtrlSetState($match_check, $GUI_HIDE)
GUICtrlSetState($button_find_next, $GUI_HIDE)
GUICtrlSetState($button_close_find, $GUI_HIDE)

Global $treeview = _GUICtrlTreeView_Create($Form1, 0, 92, 240, 366, BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVIS_DROPHILITED, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS, $WS_TABSTOP));, $WS_EX_CLIENTEDGE)
	_GUICtrlTreeView_SetTextColor($treeview, 0x003D79)
	_GUICtrlTreeView_SetBkColor($treeview, 0xEDF3FE)

$size_client = WinGetClientSize($form1)
$size_treeview = ControlGetPos($form1, "", $treeview)
$previous_x_dif = $size_client[0]-$size_treeview[0]-$size_treeview[2]
$previous_y_dif = $size_client[1]-$size_treeview[1]-$size_treeview[3]

Global $hImage3 = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($hImage3, "shell32.dll", 166)
	_GUIImageList_AddIcon($hImage3, "shell32.dll", 199)
	_GUIImageList_AddIcon($hImage3, "shell32.dll", 165)
	_GUIImageList_AddIcon($hImage3, "shell32.dll", 137)
	_GUICtrlTreeView_SetNormalImageList($treeview, $hImage3)

_GUICtrlTreeView_SetInsertMarkColor($treeview, 13005581)

ControlFocus($form1, "", $treeview)
GUISetState(@SW_SHOW, $Form1)
initMinMax(248,220,@DesktopWidth,@DesktopHeight)

Global $position = WinGetPos($Form1)
Global $client = WinGetClientSize($Form1)
Global $light_border = ($position[2]-$client[0])/2
Global $thick_border = $position[3]-$client[1]-$light_border
Global $x_coord = $position[0]+$light_border
Global $y_coord = $position[1]+$thick_border
Global $gw = 16
Global $gh = 16
$drag_gui = GUICreate("Drag", $gw, $gh, $x_coord, $y_coord, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST), $Form1)
GUISetBkColor(0xEDF3FE, $drag_gui)
$cursor_icon = GUICtrlCreateIcon("Shell32.dll", -147, 0, 0, 16, 16)
GUISetState(@SW_SHOWNOACTIVATE, $drag_gui)
setTrans()
GUISetState(@SW_HIDE, $drag_gui)

GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")

Global $wProcHandle = DllCallbackRegister("_WindowProc", "int", "hwnd;uint;wparam;lparam")
Global $wProcHandle2 = DllCallbackRegister("_EditWindowProc", "ptr", "hwnd;uint;wparam;lparam")
Global $wProcOld = _WinAPI_SetWindowLong($treeview, $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle))
Global $wProcOldLocal2 = _WinAPI_SetWindowLong(GUICtrlGetHandle($find_input), $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle2))

_check_for_hotkeys()

While 1
	if $fDragging = True then chase()
	if $just_edited = True Then
		$just_edited = False
		Local $curent = _GUICtrlTreeView_GetSelection($treeview)
		Local $get = _get_level()
		Switch $get
			case 1 ;Key
				GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent)))
			case 2 ;Section
				GUICtrlSetData($val_input, "")
			case 3 ;Value
				GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, $curent))
		EndSwitch
	EndIf
	if $save = False AND _GUICtrlToolbar_GetButtonText($hToolbar, $idSave) = "&Save" then
		_GUICtrlToolbar_SetButtonText($hToolbar, $idSave, "&Save*")
	ElseIf $save = True AND _GUICtrlToolbar_GetButtonText($hToolbar, $idSave) = "&Save*" Then
		_GUICtrlToolbar_SetButtonText($hToolbar, $idSave, "&Save")
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_exit()
		case $add_item_button
			_add_item()
		case $edit_item_button
			_TextEdit()
		case $delete_item_button
			_delete_item()
		case $button_gen_code
			_generate_full_code()
		case $find_item_button
			_find_item_input()
		case $button_close_find
			_close_find()
		case $button_find_next
			_find_item()
		case $GUI_EVENT_PRIMARYDOWN
			Local $hItem = _GUICtrlTreeView_GetSelection($treeview)
			If $hItem Then _GUICtrlTreeView_SelectItem($treeview, $hItem)
		case $GUI_EVENT_MOUSEMOVE
			If $fDragging = False Then
				if $display_infos then
					Local $bHwnd = DllCall("user32.dll", "hwnd", "WindowFromPoint", "uint", MouseGetPos(0), "uint", MouseGetPos(1))
					Local $hItem5 = TreeItemFromPoint($treeview)
					If $hItem5 Then
						Local $aItem_Rect = _GUICtrlTreeView_DisplayRect($treeview, $hItem5)               
						Local $aLV_Pos = WinGetPos($treeview)
						$sToolTipData = _get_tooltxt($hItem5)
						Local $x_movement
						Local $get = _get_level2($hItem5)
						Switch $get
							case 1
								$x_movement = 105
							case 2
								$x_movement = 90
							case 3
								$x_movement = 120
						EndSwitch
						$tooltip_x = $aLV_Pos[0]+$aItem_Rect[0]+$x_movement
						$tooltip_y = $aLV_Pos[1]+$aItem_Rect[1]+18
						ToolTip($sToolTipData, $tooltip_x, $tooltip_y)
					Else
						ToolTip("")
					EndIf
				endif
			Else
				Local $aHwnd = DllCall("user32.dll", "hwnd", "WindowFromPoint", "uint", MouseGetPos(0), "uint", MouseGetPos(1))
				Local $hItemHover = TreeItemFromPoint($treeview)
				If $hItemHover <> 0 Then
					$aRect = _GUICtrlTreeView_DisplayRect($treeview, $hItemHover)
					$iTreeY = _WinAPI_GetMousePosY(True, $treeview)
					Switch $iTreeY
						Case $aRect[1] To $aRect[1]+Int(($aRect[3]-$aRect[1])/4)
							if $fWhere <> -1 Then
								_GUICtrlTreeView_SetInsertMark($treeview, $hItemHover, False)
								$fWhere = -1
							EndIf
						Case 1+$aRect[1]+Int(($aRect[3]-$aRect[1])/3) To $aRect[1]+Int(($aRect[3]-$aRect[1])*2/3)
							if $fWhere <> 0 Then
								_SendMessage($treeview, $TVM_SETINSERTMARK, 0, 0)
								$fWhere = 0
							EndIf
						Case 1+$aRect[1]+Int(($aRect[3]-$aRect[1])*2/3) To $aRect[3]
							if $fWhere <> 1 Then
								_GUICtrlTreeView_SetInsertMark($treeview, $hItemHover)
								$fWhere = 1
							EndIf
					EndSwitch
				EndIf
			EndIf
        Case $GUI_EVENT_PRIMARYUP
            If $fDragging Then
                GUISetState(@SW_HIDE, $drag_gui)
				ToolTip("")
                _WinAPI_ShowCursor(True)
                _WinAPI_InvalidateRect($treeview)
                $fDragging = False
                _SendMessage($treeview, $TVM_SETINSERTMARK, 0, 0)
                If (TreeItemFromPoint($treeview) = $hDragItem) Then ContinueCase
				if $moving_item_is_key = False and _get_level2(TreeItemFromPoint($treeview)) <> 2 then ContinueCase
				if $moving_item_is_key = true and _get_level2(TreeItemFromPoint($treeview)) <> 1 then ContinueCase
				if $moving_item_is_key = true and _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $hDragItem)) = 1 Then ContinueCase
				if $fWhere <> 0 then
					$hItem = TreeItemCopy($treeview, $hDragItem, TreeItemFromPoint($treeview), $fWhere)
					If $hItem <> 0 Then
						_GUICtrlTreeView_SelectItem($treeview, $hItem)
						_delete_tooltxt($hDragItem)
						_GUICtrlTreeView_Delete($treeview, $hDragItem)
					EndIf
					$save = False
					
				EndIf
            EndIf
	EndSwitch
WEnd

func OnAutoItExit()
	_WinAPI_SetWindowLong($treeview, $GWL_WNDPROC, $wProcOld)
	_WinAPI_SetWindowLong(GUICtrlGetHandle($find_input), $GWL_WNDPROC, $wProcOldLocal2)
	DllCallbackFree($wProcHandle)
	DllCallbackFree($wProcHandle2)
	DllClose($dll)
EndFunc

Func _WM_NOTIFY($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $tNMHDR, $event, $hwndFrom, $code, $i_idNew, $dwFlags, $lResult, $idFrom, $i_idOld, $tInfo
	Local $tNMTOOLBAR, $tNMTBHOTITEM
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hwndFrom = DllStructGetData($tNMHDR, "hWndFrom")
	$idFrom = DllStructGetData($tNMHDR, "IDFrom")
	$code = DllStructGetData($tNMHDR, "Code")
	If $code = $TBN_DROPDOWN Then
		$hMenu = _GUICtrlMenu_CreatePopup()
		_GUICtrlMenu_AddMenuItem($hMenu, "Save" & @TAB & "Ctrl+S", $Save_only)
		_GUICtrlMenu_AddMenuItem($hMenu, "Save As..." & @TAB & "Ctrl+Shift+S", $Save_as1)
		$hBrush = _WinAPI_GetSysColorBrush($COLOR_INFOBK)
		_GUICtrlMenu_SetMenuBackground($hMenu, $hBrush)
		_GUICtrlMenu_SetMenuDefaultItem($hMenu, 0)
		_GUICtrlMenu_TrackPopupMenu($hMenu, $Form1)
		_GUICtrlMenu_DestroyMenu($hMenu)
	EndIf
	Switch $hwndFrom
		case $treeview
			Switch $code
				case $NM_RCLICK ; Right Mouse Click
					if $display_infos then ToolTip("")
					if $fDragging = True Then
						_cancel_dragging()
					Else
						Local $tInfo = DllStructCreate($tagNMTREEVIEW, $lParam)
						Local $hNewItem = DllStructGetData($tInfo, "NewParam")
						_GUICtrlTreeView_SelectItem($treeview, $hNewItem)
						_right_menu($hNewItem)
					EndIf
					Return 0
				Case $TVN_SELCHANGED, $TVN_SELCHANGEDW
					if NOT $item_just_added then
						Local $curent = _GUICtrlTreeView_GetSelection($treeview)
						Local $get = _get_level()
						Switch $get
							case 1 ;Key
								GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent)))
								_no_flash_disable($add_item_button, False)
								if _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetSelection($treeview))) = 1 Then
									_no_flash_disable($delete_item_button)
								Else
									_no_flash_disable($delete_item_button, False)
								EndIf
							case 2 ;Section
								GUICtrlSetData($val_input, "")
								_no_flash_disable($add_item_button, False)
								_no_flash_disable($delete_item_button, False)
							case 3 ;Value
								GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, $curent))
								_no_flash_disable($add_item_button)
								_no_flash_disable($delete_item_button)
						EndSwitch
					Else
						$item_just_added = 0
					EndIf
					_GUICtrlTreeView_SetRemoveMark($treeview)
				Case $TVN_ENDLABELEDIT, $TVN_ENDLABELEDITW
					if $display_infos then ToolTip("")
					HotKeySet("{Enter}")
					HotKeySet("{Esc}")
					Local $curent = _GUICtrlTreeView_GetSelection($treeview)
						if $ITEM_ADDED1 = True Then
							HotKeySet("{Enter}", "_TextSet")
							HotKeySet("{Esc}", "_EditClose")
							$ITEM_ADDED1 = False
							$ITEM_ADDED2 = True
							_GUICtrlTreeView_EditText($treeview, _GUICtrlTreeView_GetNext($treeview, $LastAddedSection))
						ElseIf $ITEM_ADDED2 = True Then
							HotKeySet("{Enter}", "_TextSet")
							HotKeySet("{Esc}", "_EditClose")
							$ITEM_ADDED2 = False
							_GUICtrlTreeView_EditText($treeview, _GUICtrlTreeView_GetNext($treeview, _GUICtrlTreeView_GetNext($treeview, $LastAddedSection)))
							_GUICtrlTreeView_SelectItem($treeview, $LastAddedSection, 0)
						ElseIf $ITEM_ADDED3 = True then 
							_no_flash_disable($delete_item_button, False)
							HotKeySet("{Enter}", "_TextSet")
							HotKeySet("{Esc}", "_EditClose")
							$ITEM_ADDED3 = False
							_GUICtrlTreeView_EditText($treeview, $LastAddedChild)
							_GUICtrlTreeView_SelectItem($treeview, $LastAddedKey, 0)
						EndIf
					if $power_mode = True Then
						if NOT $edit_mode Then
							if $section_added Then
								if $count_k = 3 Then
									_GUICtrlTreeView_Expand($treeview, $curent, False)
									$section_added = 0
									$count_k = 1
								Else
									$count_k += 1
								EndIf
							ElseIf $key_added Then
								if $count_k = 2 Then
									_GUICtrlTreeView_Expand($treeview, $curent, False)
									$key_added = 0
									$count_k = 1
								Else
									$count_k += 1
								EndIf
							EndIf
						else
							if $expanded = false Then
								_GUICtrlTreeView_Expand($treeview, $curent, False)
							EndIf
							$edit_mode = 0
						EndIf
					EndIf
                    If $iEditFlag Then
                        $iEditFlag = 0
                        Local $tInfo = DllStructCreate($tagNMTVDISPINFO, $lParam)
                        Local $sBuffer = DllStructCreate("wchar Text[" & DllStructGetData($tInfo, "TextMax") & "]")
                        If Not _GUICtrlTreeView_GetUnicodeFormat($HwndFrom) Then $sBuffer = StringTrimLeft($sBuffer, 1)
                        DllStructSetData($sBuffer, "Text", DllStructGetData($tInfo, "Text"))
                        If StringLen(DllStructGetData($sBuffer, "Text")) Then
							$save = False
							$just_edited = True
							Return 1
						EndIf
					EndIf
				case $NM_KILLFOCUS
					if $display_infos then ToolTip("")
				Case $TVN_ITEMEXPANDING, $TVN_ITEMEXPANDINGW
					if $display_infos then ToolTip("")
				Case $TVN_BEGINLABELEDIT, $TVN_BEGINLABELEDITW
					if $display_infos then ToolTip("")
					HotKeySet("{Enter}", "_TextSet")
					HotKeySet("{Esc}", "_EditClose")
				Case $TVN_BEGINDRAG, $TVN_BEGINDRAGW
					if $display_infos then ToolTip("")
                    Local $tInfo = DllStructCreate($tagNMTREEVIEW, $lParam)
                    Local $hNewItem = DllStructGetData($tInfo, "NewhItem")
					_GUICtrlTreeView_SelectItem($treeview, $hNewItem)
					Local $get = _get_level2($hNewItem)
					if $get = 3 then ContinueCase
					if $get = 2 Then
						$moving_item_is_key = False
					elseif $get = 1 Then
						$moving_item_is_key = True
						$his_parent = _GUICtrlTreeView_GetParentHandle($treeview, $hNewItem)
					EndIf
					$hDragItem = $hNewItem
					$item_above_drag = GetNeighbourItem($treeview, $hDragItem)
					$item_below_drag = GetNeighbourItem($treeview, $hDragItem, false)
                    $fDragging = True
					$moving_txt = "Moving: " & _GUICtrlTreeView_GetText($treeview, $hNewItem)
                    _WinAPI_ShowCursor(False)
                    GUISetState(@SW_SHOWNOACTIVATE, $drag_gui)
					HotKeySet("{Esc}", "_cancel_dragging2")
                    tooltip($moving_txt, MouseGetPos(0)+18, MouseGetPos(1))
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Switch $iwParam
		Case $Save_only
			_save_file(False)
		Case $Save_as1
			_save_file()
		case $idSave
			_save_file(False)
		case $idHelp
			_exit()
		case $idNew
			_new_file()
		case $idOpen
			_open_file()
		case $idPower
			_turn_power_mode()
		case $add_item_menu
			_add_item()
		Case $delete_item_menu
			_delete_item()
		Case $edit_item_menu()
			_TextEdit()
		Case $expand_item_menu
			_expand_selected()
		Case $colapse_item_menu
			_colapse_selected()
		case $expand_all_menu
			_expand_all()
		case $colapse_all_menu
			_colapse_all()
		Case $gen_write_menu
			_Generate_in_code()
		Case $gen_read_menu
			_generate_out_code()
		case $tool_tips_menu
			if $display_infos = 1 Then
				$display_infos = 0
			Else
				$display_infos = 1
			EndIf
		case $tool_tip_add_menu
			_create_tool_tip_window()
			if $display_infos then ToolTip("")
	EndSwitch
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode, $hWndEdit
	If Not IsHWnd($find_input) Then $hWndEdit = GUICtrlGetHandle($find_input)
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $find_input, $hWndEdit
			Switch $iCode
				Case 1024
					_find_item(True)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc

Func WM_ACTIVATE($hWnd, $Msg, $wParam, $lParam)
    Local $wActive = BitAND($wParam, 0x0000FFFF)
	_set_hotkeys($wActive)
    Return $GUI_RUNDEFMSG
EndFunc

Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
 	$size_client = WinGetClientSize($form1)
	$size_treeview = ControlGetPos($form1, "", $treeview)
	Local $new_width_treeview = $size_client[0]-$previous_x_dif-$size_treeview[0]
	Local $new_height_treeview = $size_client[1]-$previous_y_dif-$size_treeview[1]
	_WinAPI_MoveWindow($treeview, $size_treeview[0], $size_treeview[1], $new_width_treeview, $new_height_treeview,  True)
	Return $GUI_RUNDEFMSG
EndFunc

Func _WindowProc($hWnd, $Msg, $wParam, $lParam)
    Switch $hWnd
        Case $treeview
            Switch $Msg
                Case $WM_GETDLGCODE
                    Switch $wParam
						Case $VK_RETURN
                            _TextEdit()
                            Return 0
						Case $VK_DELETE
							Local $curent = _GUICtrlTreeView_GetSelection($treeview)
							if _GUICtrlTreeView_GetChildren($treeview, $curent) = true then
								Local $get = _get_level()
								Switch $get
									case 1
										if _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent)) > 1 Then
											_delete_tooltxt($curent)
											_GUICtrlTreeView_Delete($treeview, $curent)
											_no_flash_disable($delete_item_button, False)
										Else
											_no_flash_disable($delete_item_button)
										EndIf
									case 2
										_delete_tooltxt($curent)
										_GUICtrlTreeView_Delete($treeview, $curent)
								EndSwitch
							EndIf
							$save = False
						Case $VK_F2
							_TextEdit()
						case $VK_ESC
							Local $curent = _GUICtrlTreeView_GetSelection($treeview)
							Local $parent4 = _GUICtrlTreeView_GetParentHandle($treeview, $curent)
							if $parent4 Then
								_GUICtrlTreeView_SelectItem($treeview, $parent4)
								_GUICtrlTreeView_Expand($treeview, $parent4, False)
							EndIf
							ToolTip("")
						case $VK_APP
							Local $curent = _GUICtrlTreeView_GetSelection($treeview)
							_right_menu($curent)
                    EndSwitch
			EndSwitch
	EndSwitch
	if $hWnd = $treeview then Return _WinAPI_CallWindowProc($wProcOld, $hWnd, $Msg, $wParam, $lParam)
EndFunc

Func _EditWindowProc($hWnd, $iMsg, $wParam, $lParam)
    #forceref $hWnd, $iMsg, $wParam, $lParam
	Switch $hWnd
		case GUICtrlGetHandle($input5)
			Switch $iMsg
				Case $WM_GETDLGCODE
					Switch $wParam
						Case $VK_RETURN
							_tooltip_ok()
							$exit_loop = True
						case $VK_ESC
							_tooltip_cancel()
							$exit_loop = True
					EndSwitch
			EndSwitch
		case GUICtrlGetHandle($find_input)
			Switch $iMsg
				Case $WM_GETDLGCODE
					Switch $wParam
						Case $VK_RETURN
							_find_item()
						case $VK_ESC
							_close_find()
					EndSwitch
			EndSwitch
	EndSwitch
    if $hWnd = GUICtrlGetHandle($input5) then Return _WinAPI_CallWindowProc($wProcOldLocal, $hWnd, $iMsg, $wParam, $lParam)
	if $hWnd = GUICtrlGetHandle($find_input) then Return _WinAPI_CallWindowProc($wProcOldLocal2, $hWnd, $iMsg, $wParam, $lParam)
EndFunc

Func initMinMax($x0,$y0,$x1,$y1)
    Local Const $WM_GETMINMAXINFO = 0x24
    $aUtil_MinMax[0]=$x0
    $aUtil_MinMax[1]=$y0
    $aUtil_MinMax[2]=$x1
    $aUtil_MinMax[3]=$y1
    GUIRegisterMsg($WM_GETMINMAXINFO,'MY_WM_GETMINMAXINFO')
EndFunc

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
    Local $minmaxinfo = DllStructCreate('int;int;int;int;int;int;int;int;int;int',$lParam)
    DllStructSetData($minmaxinfo,7,$aUtil_MinMax[0]); min X
    DllStructSetData($minmaxinfo,8,$aUtil_MinMax[1]); min Y
    DllStructSetData($minmaxinfo,9,$aUtil_MinMax[2]); max X
    DllStructSetData($minmaxinfo,10,$aUtil_MinMax[3]); max Y
    Return $GUI_RUNDEFMSG
EndFunc

func _check_for_hotkeys()
	Local $wActive = WinActive($form1)
	_set_hotkeys($wActive)
EndFunc

func _set_hotkeys($win_active)
	If $win_active Then
		HotKeySet("^s", "_save_dummy")
		HotKeySet("^+s", "_save_dummy2")
		HotKeySet("^o", "_open_file")
		HotKeySet("^n", "_new_file")
		HotKeySet("^f", "_find_item_input")
		HotKeySet("^{ENTER}", "_expand_selected")
		HotKeySet("^+{ENTER}", "_expand_all")
		HotKeySet("^{BS}", "_colapse_selected")
		HotKeySet("^+{BS}", "_colapse_all")
    Else
		HotKeySet("^s")
		HotKeySet("^+s")
		HotKeySet("^o")
		HotKeySet("^n")
		HotKeySet("^f")
		HotKeySet("^{ENTER}")
		HotKeySet("^+{ENTER}")
		HotKeySet("^{BS}")
		HotKeySet("^+{BS}")
    EndIf
EndFunc

func _right_menu($hWnd)
	Local $get = _get_level2($hWnd)
	$hMenu2 = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_AddMenuItem($hMenu2, "Add Item" & @TAB & "(Alt+A)", $add_item_menu)
	if $get =3 then _GUICtrlMenu_SetItemDisabled($hMenu2, 0)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Edit Item" & @TAB & "(F2)", $edit_item_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Delete Item" & @TAB & "(Del)", $delete_item_menu)
	if $get = 1 and _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $hWnd)) = 1 Then _GUICtrlMenu_SetItemDisabled($hMenu2, 2)
	if $get = 3 then _GUICtrlMenu_SetItemDisabled($hMenu2, 2)
	_GUICtrlMenu_AddMenuItem($hMenu2, "")
	_GUICtrlMenu_AddMenuItem($hMenu2, "Display Description(s)", $tool_tips_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Add/Edit Description", $tool_tip_add_menu)
	if $display_infos then
		_GUICtrlMenu_SetItemChecked($hMenu2, 4)
	Else
		_GUICtrlMenu_SetItemDisabled($hMenu2, 5)
		_GUICtrlMenu_SetItemChecked($hMenu2, 4, False)
	EndIf
	_GUICtrlMenu_AddMenuItem($hMenu2, "")
	_GUICtrlMenu_AddMenuItem($hMenu2, "Expand Selected", $expand_item_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Colapse Selected", $colapse_item_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "")
	_GUICtrlMenu_AddMenuItem($hMenu2, "Expand All", $expand_all_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Colapse All", $colapse_all_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "")
	_GUICtrlMenu_AddMenuItem($hMenu2, "Generate WriteIni Code", $gen_write_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Generate ReadIni Code", $gen_read_menu)
	if $get = 2 Then
		_GUICtrlMenu_SetItemDisabled($hMenu2, 13)
		_GUICtrlMenu_SetItemDisabled($hMenu2, 14)
	EndIf
	Local $hItem = _GUICtrlTreeView_GetSelection($treeview)
	If NOT $hItem Then
		for $i = 0 to 14
			if $i <> 4 then _GUICtrlMenu_SetItemDisabled($hMenu2, $i)
		Next
	EndIf
	$hBrush = _WinAPI_GetSysColorBrush($COLOR_INFOBK)
	_GUICtrlMenu_SetMenuBackground($hMenu2, $hBrush)
	_GUICtrlMenu_SetItemDisabled($hMenu2, $delete_item_menu)
	_GUICtrlMenu_TrackPopupMenu($hMenu2, $Form1)
	_GUICtrlMenu_DestroyMenu($hMenu2)
EndFunc

func _create_gen_code_window($icode_gen = "", $window_subname = "")
	GUISetState(@SW_DISABLE, $Form1)
	Local $form2 = GUICreate("Generated AU3 Code" & " (" & $window_subname & ")", 300+2, 460+28, -1, -1, $WS_SIZEBOX+$WS_MINIMIZEBOX+$WS_MAXIMIZEBOX, -1, $Form1)
		GUISetIcon("Shell32.dll", -70, $form2)
		GUISetBkColor(0xE0F0FE, $form2)
	Local $edit_gen_code = GUICtrlCreateEdit($icode_gen, 0, 0, 300, 420)
		GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM+$GUI_DOCKTOP+$GUI_DOCKRIGHT+$GUI_DOCKLEFT)
		GUICtrlSetColor(-1, 0x003D79)
		GUICtrlSetBkColor(-1, 0xE0F0FE)
	Local $button_copy_code = GUICtrlCreateButton("&Copy to clipboard", 76, 425, 140, 30)
		_GUICtrlButton_SetImageList(-1, _set_button_image(176), 5)
		GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT+$GUI_DOCKRIGHT)
	Local $button_close_code = GUICtrlCreateButton("Close", 220, 425, 75, 30)
		_GUICtrlButton_SetImageList(-1, _set_button_image(131), 5)
		GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT+$GUI_DOCKRIGHT)
	GUISetState(@SW_SHOW, $form2)
	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $button_close_code
				GUISetState(@SW_ENABLE, $Form1)
				GUIDelete($form2)
				ExitLoop
			case $button_copy_code
				_copy_generated_code($edit_gen_code)
		EndSwitch
	WEnd
EndFunc

Func _create_tool_tip_window()
	$exit_loop = False
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	GUISetState(@SW_DISABLE, $form1)
	$form3 = GUICreate("enter new description", 160, 100, $tooltip_x, $tooltip_y, $WS_POPUP, -1, $form1)
		GUISetBkColor(0xFFFFE1, $form3)
	$input5 = GUICtrlCreateEdit(StringReplace(StringReplace(_get_tooltxt($curent), @CRLF, " "), "  ", " "), 0, 0, 160, 80, $WS_VSCROLL+$ES_AUTOVSCROLL+$WS_TABSTOP+$ES_MULTILINE, $WS_EX_CLIENTEDGE)
		GUICtrlSetBkColor(-1, 0xFFFFE1)
	Local $button_ok = GUICtrlCreateButton("OK", 0, 80, 80, 20)
		GUICtrlSetBkColor(-1, 0xFFFFE1)
	Local $button_cancel = GUICtrlCreateButton("Cancel", 80, 80, 80, 20)
		GUICtrlSetBkColor(-1, 0xFFFFE1)
	$wProcOldLocal = _WinAPI_SetWindowLong(GUICtrlGetHandle($input5), $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle2))
	GUISetState(@SW_SHOW, $form3)
	While 1
		if $exit_loop = true then ExitLoop
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			case $button_ok
				_tooltip_ok()
				ExitLoop
			case $button_cancel
				_tooltip_cancel()
				ExitLoop
		EndSwitch
	WEnd
EndFunc

func _tooltip_ok()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	_add_tooltxt($curent, GUICtrlRead($input5))
	GUISetState(@SW_ENABLE, $form1)
	_WinAPI_SetWindowLong(GUICtrlGetHandle($input5), $GWL_WNDPROC, $wProcOldLocal)
	GUIDelete($form3)
	$save = False
EndFunc

func _tooltip_cancel()
	GUISetState(@SW_ENABLE, $form1)
	_WinAPI_SetWindowLong(GUICtrlGetHandle($input5), $GWL_WNDPROC, $wProcOldLocal)
	GUIDelete($form3)
EndFunc

func _exit()
	if $save = False Then
		Switch MsgBox(3+32+512+262144, "Exit", "Save changes before you exit?")
			case 6 ;yes
				_save_file(False)
				Exit
			case 7 ;no
				Exit
		EndSwitch
	Else
		Exit
	EndIf
EndFunc

func _set_button_image($icon_index)
	Local $hImage_Temp = _GUIImageList_Create(16, 16, 5, 3)
		_GUIImageList_AddIcon($hImage_Temp, "Shell32.dll", $icon_index)
	return $hImage_Temp
EndFunc

func _new_file()
	if _GUICtrlTreeView_GetCount($treeview) <> 0 Then
		if $save = False Then
			Switch MsgBox(3+32+512+262144, "New File", "Save changes before you start new file?")
				case 6 ;yes
					_save_file(False)
					_GUICtrlTreeView_BeginUpdate($treeview)
					_GUICtrlTreeView_DeleteAll($treeview)
					_GUICtrlTreeView_EndUpdate($treeview)
					GUICtrlSetData($dir_input, "New file, Not saved yet")
					$save = True
					_clear_tooltip_txt()
				case 7 ;no
					_GUICtrlTreeView_BeginUpdate($treeview)
					_GUICtrlTreeView_DeleteAll($treeview)
					_GUICtrlTreeView_EndUpdate($treeview)
					GUICtrlSetData($dir_input, "New file, Not saved yet")
					$save = True
					_clear_tooltip_txt()
			EndSwitch
		Else
			_GUICtrlTreeView_BeginUpdate($treeview)
			_GUICtrlTreeView_DeleteAll($treeview)
			_GUICtrlTreeView_EndUpdate($treeview)
			GUICtrlSetData($dir_input, "New file, Not saved yet")
			$save = True
			_clear_tooltip_txt()
		EndIf
	Else
		GUICtrlSetData($dir_input, "New file, Not saved yet")
		$save = True
		_clear_tooltip_txt()
	EndIf
EndFunc

Func _FileSaveDialog ($sTitle, $sInitDir, $sFilter = 'All (*.*)', $iOpt = 0, $sDefaultFile = "", $sDefaultExt = "", $mainGUI = 0)
    Local $iFileLen = 65536 ; Max chars in returned string
    ; API flags prepare
    Local $iFlag = BitOR (BitShift (BitAND ($iOpt, 2),-10), BitShift (BitAND ($iOpt,16), 3 ))
    ; Filter string to array convertion
    Local $asFLines = StringSplit ( $sFilter, '|'), $asFilter [$asFLines [0] *2+1]
    Local $i, $iStart, $iFinal, $suFilter = ''
    $asFilter [0] = $asFLines [0] *2
    For $i=1 To $asFLines [0]
        $iStart = StringInStr ($asFLines [$i], '(', 0, 1)
        $iFinal = StringInStr ($asFLines [$i], ')', 0,-1)
        $asFilter [$i*2-1] = StringStripWS (StringLeft ($asFLines [$i], $iStart-1), 3)
        $asFilter [$i*2] = StringStripWS (StringTrimRight (StringTrimLeft ($asFLines [$i], $iStart), StringLen ($asFLines [$i]) -$iFinal+1), 3)
        $suFilter = $suFilter & 'char[' & StringLen ($asFilter [$i*2-1])+1 & '];char[' & StringLen ($asFilter [$i*2])+1 & '];'
    Next
    ; Create API structures
    Local $uOFN = DllStructCreate ('dword;int;int;ptr;ptr;dword;dword;ptr;dword' & _
        ';ptr;int;ptr;ptr;dword;short;short;ptr;ptr;ptr;ptr;ptr;dword;dword' )
    Local $usTitle  = DllStructCreate ('char[' & StringLen ($sTitle) +1 & ']')
    Local $usInitDir= DllStructCreate ('char[' & StringLen ($sInitDir) +1 & ']')
    Local $usFilter = DllStructCreate ($suFilter & 'char')
    Local $usFile   = DllStructCreate ('char[' & $iFileLen & ']')
    Local $usExtn   = DllStructCreate ('char[' & StringLen ($sDefaultExt) +1 & ']')
    For $i=1 To $asFilter [0]
        DllStructSetData ($usFilter, $i, $asFilter [$i])
    Next
    ; Set Data of API structures
    DllStructSetData ($usTitle, 1, $sTitle)
    DllStructSetData ($usInitDir, 1, $sInitDir)
    DllStructSetData ($usFile, 1, $sDefaultFile)
    DllStructSetData ($usExtn, 1, $sDefaultExt)
    DllStructSetData ($uOFN,  1, DllStructGetSize($uOFN))
    DllStructSetData ($uOFN,  2, $mainGUI)
    DllStructSetData ($uOFN,  4, DllStructGetPtr ($usFilter))
    DllStructSetData ($uOFN,  7, 1)
    DllStructSetData ($uOFN,  8, DllStructGetPtr ($usFile))
    DllStructSetData ($uOFN,  9, $iFileLen)
    DllStructSetData ($uOFN, 12, DllStructGetPtr ($usInitDir))
    DllStructSetData ($uOFN, 13, DllStructGetPtr ($usTitle))
    DllStructSetData ($uOFN, 14, $iFlag)
    DllStructSetData ($uOFN, 17, DllStructGetPtr ($usExtn))
    DllStructSetData ($uOFN, 23, BitShift (BitAND ($iOpt, 32), 5))
    ; Call API function
    $ret = DllCall ('comdlg32.dll', 'int', 'GetSaveFileName', _
            'ptr', DllStructGetPtr ($uOFN) )
    If $ret [0] Then
        Return DllStructGetData ($usFile, 1)
    Else
        SetError (1)
        Return ""
    EndIf
EndFunc

Func _save_to_file($save_file_dir)
	if FileExists($save_file_dir) then FileDelete($save_file_dir)
	FileWrite($save_file_dir, "")
	Local $Sections = _get_Section_count()
	if $Sections <> -1 then
		Local $Keys
		for $i = 1 to $Sections[0]
			$Keys = _get_key($Sections[$i])
			if $Keys <> -1 Then
				for $j = 1 to $Keys[0][0]
					IniWrite($save_file_dir, _GUICtrlTreeView_GetText($treeview, $Sections[$i]), _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]), _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]))
					if _get_tooltxt($Keys[$j][0]) <> "" then _FileWriteToLine($save_file_dir, _FileCountLines($save_file_dir), ";//*//" & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) _
											& "/" & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & "//*//" & StringReplace(StringReplace(_get_tooltxt($Keys[$j][0]), @CRLF, " "), "  ", " "))
					if _get_tooltxt($Keys[$j][1]) <> "" then _FileWriteToLine($save_file_dir, _FileCountLines($save_file_dir), ";//*//" & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) _
											& "/" & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & "/" & _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]) & "//*//" & StringReplace(StringReplace(_get_tooltxt($Keys[$j][1]), @CRLF, " "), "  ", " "))
				Next
			EndIf
			if _get_tooltxt($Sections[$i]) <> "" then _FileWriteToLine($save_file_dir, _FileCountLines($save_file_dir), ";//*//" & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) _
											& "//*//" & StringReplace(StringReplace(_get_tooltxt($Sections[$i]), @CRLF, " "), "  ", " "))
		Next
	EndIf
	GUICtrlSetData($dir_input, $save_file_dir)
EndFunc

func _get_save_file($newname = "New File")
	Local $save_file_dir = ""
	$rectype = False
	$save_file_dir = _FileSaveDialog("Save INI file", "", "Ini File [*.ini](*.ini)|Txt File [*.txt](*.txt)|Data File [*.dat](*.dat)|Config File [*.cfg](*.cfg)|Other [*.*](*.*)", 2+16, $newname, "", $Form1)
	Return $save_file_dir
EndFunc

func _save_file($saveAS = True)
	Local $save_file_dir = ""
	Local $read = GUICtrlRead($dir_input)
	Local $new_file_name = ""
	if $saveAS = true then
		if $read = "New file, Not saved yet" OR $read = "No file loaded" OR $read = "Could not load selected file" then
			$new_file_name = "New File"
		Else
			$new_file_name = StringTrimRight(StringTrimLeft($read, StringInStr($read, "\", 0, -1)), (StringLen($read)-StringInStr($read, ".", 0, -1)+1))
		EndIf
		$save_file_dir = _get_save_file($new_file_name)
		if $save_file_dir <> "" then
			_save_to_file($save_file_dir)
			$save = True
		EndIf
	Else
		if $read = "New file, Not saved yet" OR $read = "No file loaded" OR $read = "Could not load selected file" then
			$save_file_dir = _get_save_file()
			if $save_file_dir <> "" then
				_save_to_file($save_file_dir)
				$save = True
			EndIf
		Else
			_save_to_file($read)
			$save = True
		EndIf
	EndIf
EndFunc

func _get_Section_count()
	Local $count = _GUICtrlTreeView_GetSiblingCount($treeview, 0)
	if $count <> -1 then
		Local $display2
		Local $display[$count+1]
		$display[0] = $count
		Local $is_parent = False
		for $i = 1 to $count
			if $i = 1 Then
				$display2 = _GUICtrlTreeView_GetFirstItem($treeview)
			Else
				$display2 = _GUICtrlTreeView_GetNext($treeview, $display2)
				For $j = 1 to _GUICtrlTreeView_GetSiblingCount($treeview, $display2)*2
					$display2 = _GUICtrlTreeView_GetNext($treeview, $display2)
				Next
			EndIf
			$display[$i] = _GUICtrlTreeView_GetItemHandle($treeview, $display2)
		Next
		Return $display
	Else
		Return -1
	EndIf
EndFunc

func _clear_tooltip_txt()
	Local $count2 = UBound($tool_txt_array)-1
	Local $index
	Local $found = false
	for $j = 1 to $count2
		_ArrayDelete($tool_txt_array, $j)
	Next
EndFunc

func _open_file()
	$not_open = 0
	if $save = False Then
		Switch MsgBox(3+32+512+262144, "Open File", "Save changes before you open file?")
			case 6 ;yes
				_save_file(False)
			case 2 ;cancel
				$not_open = 1
		EndSwitch
	EndIf
	if $not_open = 0 then
		Local $file = FileOpenDialog("Open INI file", "", "Ini Files (*.ini)|All Files (*.*)", 1 + 2)
		if NOT @error Then
			_GUICtrlTreeView_BeginUpdate($treeview)
			_GUICtrlTreeView_DeleteAll($treeview)
			_clear_tooltip_txt()
			GUICtrlSetData($dir_input, $file)
			Local $ini_section_count = IniReadSectionNames($file)
			if NOT @error then
				ReDim $ini_section[$ini_section_count[0]+1]
				for $i = 1 to $ini_section_count[0]
					$ini_section[$i] = _GUICtrlTreeView_Add($treeview, 0,$ini_section_count[$i], 0, 3)
					_GUICtrlTreeView_SetBold($treeview, $ini_section[$i])
					Local $ini_key_count = IniReadSection($file, $ini_section_count[$i])
					if @error then
						GUICtrlSetData($dir_input, "Could not load selected file")
						ExitLoop
					EndIf
					Local $curent_key[$ini_key_count[0][0]+1]
					Local $curent_value[$ini_key_count[0][0]+1]
					for $j = 1 to $ini_key_count[0][0]
						$curent_key[$j] = _GUICtrlTreeView_AddChild($treeview, $ini_section[$i], $ini_key_count[$j][0], 1, 3)
						$curent_value[$j] = _GUICtrlTreeView_AddChild($treeview, $curent_key[$j], $ini_key_count[$j][1], 2, 3)
					Next
				Next
				$save = True
			Else
				GUICtrlSetData($dir_input, "Could not load selected file")
			EndIf
			_GUICtrlTreeView_EndUpdate($treeview)
			If Not _FileReadToArray($file, $aRecords) Then
			Else
				Local $is_section = 0
				Local $searching_item
				For $x = 1 to $aRecords[0]
					Local $current_string = $aRecords[$x]
					if StringLeft($current_string, 6) = ";//*//" Then
						ReDim $tooltips[$x+1]
						Local $first_split = StringTrimLeft(StringTrimRight($current_string, StringLen($current_string)-StringInStr($current_string, "//*//", 0, -1)+1), 6)
						Local $second_split = StringSplit($first_split, "/")
						Switch $second_split[0]
							Case 1
								Do
									$searching_item = _GUICtrlTreeView_FindItem($treeview, $second_split[1])
								Until _get_level2($searching_item) = 2
								_add_tooltxt($searching_item, StringRight($current_string, StringLen($current_string)-StringInStr($current_string, "//*//", 0, -1)-4))
							case 2
								Do
									$searching_item = _GUICtrlTreeView_FindItem($treeview, $second_split[2])
								Until _get_level2($searching_item) = 1
								_add_tooltxt($searching_item, StringRight($current_string, StringLen($current_string)-StringInStr($current_string, "//*//", 0, -1)-4))
							Case 3
								Do
									$searching_item = _GUICtrlTreeView_FindItem($treeview, $second_split[3])
								Until _get_level2($searching_item) = 3
								_add_tooltxt($searching_item, StringRight($current_string, StringLen($current_string)-StringInStr($current_string, "//*//", 0, -1)-4))
						EndSwitch
					EndIf
				Next
			EndIf
		endif
	EndIf
EndFunc

func _add_tooltxt($hwnd, $txt)
	Local $count2 = UBound($tool_txt_array)-1
	Local $index
	Local $found = false
	for $j = 1 to $count2
		if $tool_txt_array[$j][0] = $hwnd Then
			$index = $j
			$found = true
			ExitLoop
		EndIf
	Next
	if $found = False then
		Local $count = UBound($tool_txt_array, 1)

		ReDim $tool_txt_array[$count+1][2]
		$tool_txt_array[$count][0] = $hwnd
		$tool_txt_array[$count][1] = _limit_txt($txt, 32)
	Else
		$tool_txt_array[$index][1] = _limit_txt($txt, 32)
	EndIf
EndFunc

func _limit_txt($text, $longest)
	$text = StringReplace($text, " " & @CRLF, " ")
	$text = StringReplace($text, "  ", " ")
	Local $split1 = StringSplit($text, " ")
	Local $longest2 = $longest
	Local $previous_txt = ""
	Local $split2
	for $i = 1 to $split1[0]
		if StringLen($split1[$i]) > $longest then $longest = StringLen($split1[$i])
	Next
	for $i = 1 to $split1[0]
		if StringLen($split1[$i] & $previous_txt) < $longest Then
			$previous_txt &= $split1[$i] & " "
		Else
			$previous_txt &= @CRLF
			$longest = $longest2+StringLen($previous_txt)
			$previous_txt &= $split1[$i] & " "
		EndIf
	Next
	Return StringTrimRight($previous_txt, 1)
EndFunc

func _delete_tooltxt($hWnd)
	Local $count2 = UBound($tool_txt_array)-1
	Local $index
	Local $found = false
	for $j = 1 to $count2
		if $tool_txt_array[$j][0] = $hwnd Then
			$index = $j
			$found = true
			ExitLoop
		EndIf
	Next
	if $found = true then
		_ArrayDelete($tool_txt_array, $index)
		Local $get_child_count = _GUICtrlTreeView_GetChildCount($treeview, $hwnd)
		if $get_child_count <> -1 then
			Local $previous_item = _GUICtrlTreeView_GetFirstChild($treeview, $hWnd)
			for $j = 1 to $get_child_count
				if $j = 1 then
					_delete_tooltxt($previous_item)
				Else
					$previous_item = _GUICtrlTreeView_GetNextChild($treeview, $previous_item)
					_delete_tooltxt($previous_item)
				EndIf
			Next
		EndIf
	EndIf
	ToolTip("")
EndFunc

func _get_tooltxt($hwnd)
	Local $count2 = UBound($tool_txt_array)-1
	Local $index
	Local $found = false
	for $j = 1 to $count2
		if $tool_txt_array[$j][0] = $hwnd Then
			$index = $j
			$found = true
			ExitLoop
		EndIf
	Next
	if $found = true then
		Return $tool_txt_array[$index][1]
	Else
		Return ""
	EndIf
EndFunc

func _add_new_main_item()
	ReDim $ini_section[UBound($ini_section)+1]
	Local $additem2
	Local $additem3
	Local $curent_selection = _GUICtrlTreeView_GetSelection($treeview)
	$ini_section[UBound($ini_section)-1] = _GUICtrlTreeView_Add($treeview, 0, "", 0, 3)
	$item_just_added = 1
	$section_added = 1
	_GUICtrlTreeView_SelectItem($treeview, $ini_section[UBound($ini_section)-1]) ;select
	_GUICtrlTreeView_SetBold($treeview, $ini_section[UBound($ini_section)-1])
	$additem2 = _GUICtrlTreeView_AddChild($treeview, $ini_section[UBound($ini_section)-1], "", 1, 3)
	$additem3 = _GUICtrlTreeView_AddChild($treeview, $additem2, "", 2, 3)
	_GUICtrlTreeView_Expand($treeview, $ini_section[UBound($ini_section)-1])
	_GUICtrlTreeView_EditText($treeview, $ini_section[UBound($ini_section)-1])
	$LastAddedSection = _GUICtrlTreeView_GetItemHandle($treeview, $ini_section[UBound($ini_section)-1])
	$ITEM_ADDED1 = True
EndFunc

func _add_item()
	Local $additem1
	Local $additem2
	Local $curent_selection = _GUICtrlTreeView_GetCount($treeview)
	if $curent_selection = 0 Then
		if GUICtrlRead($dir_input) = "No file loaded" then GUICtrlSetData($dir_input, "New file, Not saved yet")
		_add_new_main_item()
		$save = False
		$first_item_added = true
	Else
		Local $curent_selection = _GUICtrlTreeView_GetSelection($treeview)
		Local $get = _get_level()
		Switch $get
			case 1
				$additem1 = _GUICtrlTreeView_AddChild($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent_selection), "", 1, 3)
				$item_just_added = 1
				$key_added = 1
				_GUICtrlTreeView_SelectItem($treeview, $additem1) ;select
				$additem2 = _GUICtrlTreeView_AddChild($treeview, $additem1, "", 2, 3)
				_GUICtrlTreeView_Expand($treeview, $additem1)
				_GUICtrlTreeView_EditText($treeview, $additem1)
				$LastAddedChild = _GUICtrlTreeView_GetItemHandle($treeview, _GUICtrlTreeView_GetNext($treeview, $additem1))
				$LastAddedKey = _GUICtrlTreeView_GetItemHandle($treeview, $additem1)
				$ITEM_ADDED3 = True
				$save = False
			case 2
				_add_new_main_item()
				$save = False
		EndSwitch
	EndIf
EndFunc

func _delete_item()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	if $curent then
		Local $get = _get_level()
		Switch $get
			case 1 ;Key
				_no_flash_disable($add_item_button, False)
				if _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetSelection($treeview))) = 1 Then
					_no_flash_disable($delete_item_button)
				Else
					_no_flash_disable($delete_item_button, False)
					_delete_tooltxt($curent)
					_GUICtrlTreeView_Delete($treeview, $curent)
					$save = False
				EndIf
			case 2 ;Section
				_delete_tooltxt($curent)
				_GUICtrlTreeView_Delete($treeview, $curent)
				$save = False
				_no_flash_disable($add_item_button, False)
				_no_flash_disable($delete_item_button, False)
			case 3 ;Value
				GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, $curent))
				_no_flash_disable($add_item_button)
				_no_flash_disable($delete_item_button)
		EndSwitch
	EndIf
EndFunc

func _copy_generated_code($Control)
	ClipPut(GUICtrlRead($Control))
EndFunc

func _get_key($Section)
	Local $return[1][1]
	Local $first_child = _GUICtrlTreeView_GetNext($treeview, $Section)
	Local $count = _GUICtrlTreeView_GetSiblingCount($treeview, $first_child)
	if $count <> -1 Then
		ReDim $return[$count+1][2]
		for $i = 1 to $count
			if $i = 1 Then
				$return[$i][0] = $first_child
				$return[$i][1] = _GUICtrlTreeView_GetNext($treeview, $first_child)
			Else
				$return[$i][0] = _GUICtrlTreeView_GetNext($treeview, $return[$i-1][1])
				$return[$i][1] = _GUICtrlTreeView_GetNext($treeview, $return[$i][0])
			EndIf
		Next
		$return[0][0] = $count
		Return $return
	Else
		Return -1
	EndIf
EndFunc

func _generate_full_code()
	Local $Sections
	Local $Keys
	Local $values
	Local $file_name = GUICtrlRead($dir_input)
	Local $final_ini = ""
	Local $new_file_name = ""
	Local $read = GUICtrlRead($dir_input)
	if $read = "New file, Not saved yet" OR $read = "No file loaded" OR $read = "Could not load selected file" then
			$new_file_name = "New File.ini"
		Else
			$new_file_name = StringTrimLeft($read, StringInStr($read, "\", 0, -1))
		EndIf
	Local $pre_ini_txt = "_iGenerated_Ini_File_Save(@ScriptDir & ""\" & $new_file_name & """) ;Rename " & $new_file_name & " to whatever you want your file to be named" _
					& @CRLF  & @CRLF _
					& "Func _iGenerated_Ini_File_Save($Save_File)" & @CRLF _
					& @TAB & "If NOT FileExists($Save_File) then FileWrite($Save_File, """")" & @CRLF
	Local $after_ini_txt = "EndFunc"
	Local $gen_code = ""
	$Sections = _get_Section_count()
	if $Sections <> -1 then
		for $i = 1 to $Sections[0]
			$Keys = _get_key($Sections[$i])
			if $Keys <> -1 then
				for $j = 1 to $Keys[0][0]
					if $final_ini = "" Then
						$final_ini = @TAB & "IniWrite($Save_File, """ & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]) & """)" & @CRLF
					Else
						$final_ini &= @TAB & "IniWrite($Save_File, """ & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]) & """)" & @CRLF
					EndIf
				Next
			EndIf
		Next
		$gen_code = $pre_ini_txt & $final_ini & $after_ini_txt
		_create_gen_code_window($gen_code, "Full Write")
	EndIf
EndFunc

func _find_item_input()
	if GUICtrlGetState($button_find_next) = 96 Then
		GUICtrlSetState($button_find_next, $GUI_SHOW)
		GUICtrlSetState($match_check, $GUI_SHOW)
		GUICtrlSetState($button_close_find, $GUI_SHOW)
		Local $control_pos = ControlGetPos($Form1, "", $treeview)
		ControlMove($Form1, "", $treeview, $control_pos[0], $control_pos[1], $control_pos[2], $control_pos[3]-19)
		GUICtrlSetState($find_input, $GUI_SHOW)
		$size_client = WinGetClientSize($form1)
		$size_treeview = ControlGetPos($form1, "", $treeview)
		$previous_x_dif = $size_client[0]-$size_treeview[0]-$size_treeview[2]
		$previous_y_dif = $size_client[1]-$size_treeview[1]-$size_treeview[3]
	EndIf
	ControlFocus($form1, "", $find_input)
EndFunc

func _generate_out_code()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	Local $Key
	Local $value
	Local $parent
	Local $send_txt = ""
	Local $get
	if _GUICtrlTreeView_GetCount($treeview) <> 0 then
		$get = _get_level()
		Switch $get
			case 1 ;Key
				$Key = _GUICtrlTreeView_GetText($treeview, $curent)
				$value = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent))
			case 3 ;Value
				$value = _GUICtrlTreeView_GetText($treeview, $curent)
				$Key = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent))
		EndSwitch
		if $get <> 2 Then
			$parent = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent)))
			Local $new_file_name = ""
			Local $read = GUICtrlRead($dir_input)
			if $read = "New file, Not saved yet" OR $read = "No file loaded" OR $read = "Could not load selected file" then
					$new_file_name = "New File.ini"
				Else
					$new_file_name = StringTrimLeft($read, StringInStr($read, "\", 0, -1))
				EndIf
			$send_txt = "IniRead(@ScriptDir & ""\" & $new_file_name & """, """ & $parent & """, """ & $Key & """, """ & $value & """) ;Change " & $new_file_name & " into your ini-read file"
			_create_gen_code_window($send_txt, "Read")
		EndIf
	EndIf
EndFunc

func _Generate_in_code()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	Local $Key
	Local $value
	Local $parent
	Local $send_txt = ""
	Local $get
	if _GUICtrlTreeView_GetCount($treeview) <> 0 then
		$get = _get_level()
		Switch $get
			case 1 ;Key
				$Key = _GUICtrlTreeView_GetText($treeview, $curent)
				$value = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent))
			case 3 ;Value
				$value = _GUICtrlTreeView_GetText($treeview, $curent)
				$Key = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent))
		EndSwitch
		if $get <> 2 Then
			$parent = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent)))
			
			
			Local $new_file_name = ""
			Local $read = GUICtrlRead($dir_input)
			if $read = "New file, Not saved yet" OR $read = "No file loaded" OR $read = "Could not load selected file" then
					$new_file_name = "New File.ini"
				Else
					$new_file_name = StringTrimLeft($read, StringInStr($read, "\", 0, -1))
				EndIf
			$send_txt = "IniWrite(@ScriptDir & ""\" & $new_file_name & """, """ & $parent & """, """ & $Key & """, """ & $value & """) ;Rename " & $new_file_name & " to your ini file"
			_create_gen_code_window($send_txt, "Write")
		EndIf
	EndIf
EndFunc

func _save_dummy()
	_save_file(false)
EndFunc

func _save_dummy2()
	_save_file(True)
EndFunc

func _expand_selected()
	_GUICtrlTreeView_Expand($treeview, _GUICtrlTreeView_GetSelection($treeview))
EndFunc

func _expand_all()
	Local $Sections = _get_Section_count()
	if $Sections <> -1 then
		for $i = 1 to $Sections[0]
			_GUICtrlTreeView_Expand($treeview, $Sections[$i])
		Next
	EndIf
EndFunc

func _colapse_selected()
	_GUICtrlTreeView_Expand($treeview, _GUICtrlTreeView_GetSelection($treeview), False)
EndFunc

func _colapse_all()
	Local $Sections = _get_Section_count()
	if $Sections <> -1 then
		for $i = 1 to $Sections[0]
			_GUICtrlTreeView_Expand($treeview, $Sections[$i], False)
		Next
	EndIf
	_GUICtrlTreeView_SelectItem($treeview, 0)
EndFunc

func _close_find()
	if GUICtrlGetState($find_input) <> 96 then
		GUICtrlSetState($find_input, $GUI_HIDE)
		GUICtrlSetState($match_check, $GUI_HIDE)
		GUICtrlSetState($button_find_next, $GUI_HIDE)
		GUICtrlSetState($button_close_find, $GUI_HIDE)
		_GUICtrlTreeView_SetRemoveMark($treeview)
		Local $control_pos = ControlGetPos($Form1, "", $treeview)
		ControlMove($Form1, "", $treeview, $control_pos[0], $control_pos[1], $control_pos[2], $control_pos[3]+19)
		ControlFocus($form1, "", $treeview)
		$size_client = WinGetClientSize($form1)
		$size_treeview = ControlGetPos($form1, "", $treeview)
		$previous_x_dif = $size_client[0]-$size_treeview[0]-$size_treeview[2]
		$previous_y_dif = $size_client[1]-$size_treeview[1]-$size_treeview[3]
	EndIf
EndFunc

func GetNeighbourItem($hWnd, $hItemTarget, $above = True)
	if $above = True Then
		Local $hPrev = _GUICtrlTreeView_GetPrevSibling($hWnd, $hItemTarget)
		Return $hPrev
	Else
		Local $hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hItemTarget)
		Return $hNext
	EndIf
EndFunc

Func TreeItemCopy($hWnd, $hItemSource, $hItemTarget, $fDirection)
    $hTest = $hItemTarget
    Do
        $hTest = _GUICtrlTreeView_GetParentHandle($hWnd, $hTest)
        If $hTest = $hItemSource Then Return 0
    Until $hTest = 0
    $sText = _GUICtrlTreeView_GetText($hWnd, $hItemSource)
    $hParent = _GUICtrlTreeView_GetParentHandle($hWnd, $hItemTarget)
    Switch $fDirection
        Case -1
            $hPrev = _GUICtrlTreeView_GetPrevSibling($hWnd, $hItemTarget)
            If $hPrev = 0 Then
                $hNew = _GUICtrlTreeView_AddFirst($hWnd, $hItemTarget, $sText)
				_add_tooltxt($hNew, _get_tooltxt($hItemSource))
            Else
                $hNew = _GUICtrlTreeView_InsertItem($hWnd, $sText, $hParent, $hPrev)
				_add_tooltxt($hNew, _get_tooltxt($hItemSource))
            EndIf
        Case 0
            $hNew = _GUICtrlTreeView_InsertItem($hWnd, $sText, $hItemTarget)
			_add_tooltxt($hNew, _get_tooltxt($hItemSource))
        Case 1
            $hNew = _GUICtrlTreeView_InsertItem($hWnd, $sText, $hParent, $hItemTarget)
			_add_tooltxt($hNew, _get_tooltxt($hItemSource))
        Case Else
            Return 0
    EndSwitch
    _GUICtrlTreeView_SetState($hWnd, $hNew, _GUICtrlTreeView_GetState($hWnd, $hItemSource))
    If _GUICtrlTreeView_GetStateImageList($hWnd) <> 0 Then
        _GUICtrlTreeView_SetStateImageIndex($hWnd, $hNew, _GUICtrlTreeView_GetStateImageIndex($hWnd, $hItemSource))
    EndIf
    If _GUICtrlTreeView_GetNormalImageList($hWnd) <> 0 Then
        _GUICtrlTreeView_SetImageIndex($hWnd, $hNew, _GUICtrlTreeView_GetImageIndex($hWnd, $hItemSource))
        _GUICtrlTreeView_SetSelectedImageIndex($hWnd, $hNew, _GUICtrlTreeView_GetSelectedImageIndex($hWnd, $hItemSource))
    EndIf
    $iChildCount = _GUICtrlTreeView_GetChildCount($hWnd, $hItemSource)
    If $iChildCount > 0 Then
        For $i = 0 To $iChildCount-1
            $hRecSource = _GUICtrlTreeView_GetItemByIndex($hWnd, $hItemSource, $i)
            TreeItemCopy($hWnd, $hRecSource, $hNew, 0)
        Next
    EndIf
    Return $hNew
EndFunc

Func TreeItemFromPoint($hWnd)
    Local $tMPos = _WinAPI_GetMousePos(True, $hWnd)
    Return _GUICtrlTreeView_HitTestItem($hWnd, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
EndFunc

func _find_item($typo = false)
	Local $match
	Local $select_one
	if GUICtrlRead($match_check) = $GUI_CHECKED Then
		$match = False
	Else
		$match = True
	EndIf
	Local $find_data = GUICtrlRead($find_input)
	Local $curent_selection = _GUICtrlTreeView_GetSelection($treeview)
	if _GUICtrlTreeView_FindItem($treeview, $find_data, $match) <> 0 Then
		GUICtrlSetBkColor($find_input, 0xD5FFDF)
	Else
		if $find_data <> "" Then
			GUICtrlSetBkColor($find_input, 0xFFE1E1)
		Else
			GUICtrlSetBkColor($find_input, 0xFFFFFF)
		EndIf
		_GUICtrlTreeView_SetRemoveMark($treeview);, 0)
		Return 0
	EndIf
	if $typo = True Then
		if NOT StringInStr(_GUICtrlTreeView_GetText($treeview, $curent_selection), $find_data) Then
			$select_one = _GUICtrlTreeView_FindItem($treeview, $find_data, $match, _GUICtrlTreeView_GetNext($treeview, $curent_selection))
			if _GUICtrlTreeView_GetText($treeview) = _GUICtrlTreeView_GetText($treeview, $select_one) AND $find_data <> _GUICtrlTreeView_GetText($treeview) Then
				_GUICtrlTreeView_SelectItem($treeview, _GUICtrlTreeView_FindItem($treeview, $find_data, $match))
				_GUICtrlTreeView_SetInsertMark($treeview, _GUICtrlTreeView_FindItem($treeview, $find_data, $match))
			Else
				_GUICtrlTreeView_SelectItem($treeview, $select_one)
				_GUICtrlTreeView_SetInsertMark($treeview, $select_one)
			EndIf
		Else
			_GUICtrlTreeView_SetInsertMark($treeview, $curent_selection)
		EndIf
	Else
		$select_one = _GUICtrlTreeView_FindItem($treeview, $find_data, $match, _GUICtrlTreeView_GetNext($treeview, $curent_selection))
		if _GUICtrlTreeView_GetText($treeview) = _GUICtrlTreeView_GetText($treeview, $select_one) AND $find_data <> _GUICtrlTreeView_GetText($treeview) Then
			_GUICtrlTreeView_SelectItem($treeview, _GUICtrlTreeView_FindItem($treeview, $find_data, $match));$select_one)
			_GUICtrlTreeView_SetInsertMark($treeview, _GUICtrlTreeView_FindItem($treeview, $find_data, $match))
		Else
			_GUICtrlTreeView_SelectItem($treeview, $select_one)
			_GUICtrlTreeView_SetInsertMark($treeview, $select_one)
		EndIf
	EndIf
EndFunc

Func _GUICtrlTreeView_SetRemoveMark($hWnd)
	_SendMessage($hWnd, $TVM_SETINSERTMARK, 0, 0)
EndFunc

func _turn_power_mode()
	if $power_mode = False Then
		$power_mode = True
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $idPower, 5)
	Else
		$power_mode = False
		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $idPower, 4)
	EndIf
EndFunc

func _cancel_dragging()
	HotKeySet("{Esc}")
    $fDragging = False
    GUISetState(@SW_HIDE, $drag_gui)
    _WinAPI_ShowCursor(True)
    ToolTip("")
    _WinAPI_InvalidateRect($treeview)
    _SendMessage($treeview, $TVM_SETINSERTMARK, 0, 0)
EndFunc

func _get_level()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	Local $n = 1
	Local $varX = $curent
	for $j = 1 to 3
		$varX = _GUICtrlTreeView_GetFirstChild($treeview, $varX)
		if _GUICtrlTreeView_GetChildren($treeview, $varX) = False then ExitLoop
		$n += 1
	Next
	Return $n
EndFunc

func _get_level2($curent)
	Local $n = 1
	Local $varX = $curent
	for $j = 1 to 3
		$varX = _GUICtrlTreeView_GetFirstChild($treeview, $varX)
		if _GUICtrlTreeView_GetChildren($treeview, $varX) = False then ExitLoop
		$n += 1
	Next
	Return $n
EndFunc

func _no_flash_disable($button_handle, $disable=True)
	if $disable Then
		if GUICtrlGetState($button_handle) <> 144 Then GUICtrlSetState($button_handle, $GUI_DISABLE)
	Else
		if GUICtrlGetState($button_handle) <> 80 Then GUICtrlSetState($button_handle, $GUI_ENABLE)
	EndIf
EndFunc

Func _TextEdit()
	HotKeySet("{Enter}", "_TextSet")
	HotKeySet("{Esc}", "_EditClose")
    Local $hItem = _GUICtrlTreeView_GetSelection($treeview)
    If $hItem Then
		if $power_mode = false Then
			_GUICtrlTreeView_EditText($treeview, $hItem)
		Else
			$edit_mode = 1
			if _GUICtrlTreeView_GetExpanded($treeview, $hItem) = True then
				$expanded = True
			Else
				if _get_level2($hItem) <> 2 then _GUICtrlTreeView_Expand($treeview, $hItem)
				$expanded = False
			EndIf
			Local $get = _get_level()
			Switch $get
				case 1 ;key
					_GUICtrlTreeView_EditText($treeview, _GUICtrlTreeView_GetNext($treeview, $hItem))
				case 2 ;section
					_GUICtrlTreeView_EditText($treeview, $hItem)
				case 3 ;value
					_GUICtrlTreeView_EditText($treeview, $hItem)
			EndSwitch
		EndIf
	Else
		HotKeySet("{Enter}")
		HotKeySet("{Esc}")
	EndIf
EndFunc

Func _TextSet()
    $iEditFlag = 1
    _GUICtrlTreeView_EndEdit($treeview)
	$save = False
EndFunc

Func _EditClose()
    $iEditFlag = 0
	$ITEM_ADDED1 = False
	$ITEM_ADDED2 = False
	$ITEM_ADDED3 = False
	_GUICtrlTreeView_EndEdit($treeview)
	if $power_mode = True then
		$section_added = 0
		$key_added = 0
		$count_k = 1
		_GUICtrlTreeView_Expand($treeview, _GUICtrlTreeView_GetSelection($treeview), False)
	EndIf
EndFunc

Func setTrans()
    Local $hGDI = DllOpen("gdi32.dll"), $color
    Local $hDC = _WinAPI_GetDC($drag_gui)
    $aM_Mask = DllCall($hGDI, "long", "CreateRectRgn", "long", 0, "long", 0, "long", $gw + 1, "long", $gh + 1)
	$TestCol = DllCall($hGDI, "int", "GetPixel", "hwnd", $hDC, "int", 0, "int", 0)
	$Startx = -1
    $Starty = -1
    $Endx = 0
    $Endy = 0
    For $i = 0 To $gw
        For $j = 0 To $gh
            $color = DllCall($hGDI, "int", "GetPixel", "hwnd", $hDC, "int", $i, "int", $j)
            If $color[0] = $TestCol[0] And $j < $gh Then
                If $Startx = -1 Then
                    $Startx = $i
                    $Starty = $j
                    $Endx = $i
                    $Endy = $j
                Else
                    $Endx = $i
                    $Endy = $j
                EndIf
            Else
                If $Startx <> -1 Then addRegion()
                $Startx = -1
                $Starty = -1
            EndIf
        Next
    Next
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $drag_gui, "long", $aM_Mask[0], "int", 1)
    _WinAPI_ReleaseDC($drag_gui, $hDC)
    DllClose($hGDI)
EndFunc

Func addRegion()
    $aMask = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", $Startx, "long", $Starty, "long", $Endx + 1, "long", $Endy + 1)
    DllCall("gdi32.dll", "long", "CombineRgn", "long", $aM_Mask[0], "long", $aMask[0], "long", $aM_Mask[0], "int", 3)
EndFunc

Func chase()
    $mp = MouseGetPos()
    WinMove($drag_gui, "", $mp[0] + 1, $mp[1] + 0)
    tooltip($moving_txt, $mp[0]+18, $mp[1])
EndFunc

Func _cancel_dragging2()
	if $fDragging = True then _cancel_dragging()
EndFunc