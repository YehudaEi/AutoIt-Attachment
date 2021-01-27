#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <GuiToolBar.au3>
#include <Constants.au3>
#include <GuiImageList.au3>
#include <EditConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiTreeView.au3>
#include <ButtonConstants.au3>
#include <GuiButton.au3>
#include <GuiEdit.au3>
#include <GuiMenu.au3>
#include <file.au3>
#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
Opt("GUICloseOnESC", 0)

;;Dir hierarchy constants

Global Const $instal_bin = @ScriptDir & "\bin"
Global Const $instal_data = @ScriptDir & "\data"
Global Const $instal_logs = @ScriptDir & "\logs"
Global Const $instal_config = @ScriptDir & "\config"
Global Const $instal_include = @ScriptDir & "\include"

Global Const $TVN_SELCHANGED = $TVN_SELCHANGEDA
Global Const $TVN_ENDLABELEDIT = $TVN_ENDLABELEDITA
Global Const $TVN_ITEMEXPANDING = $TVN_ITEMEXPANDINGA
Global Const $TVN_BEGINLABELEDIT = $TVN_BEGINLABELEDITA
Global Const $TVN_BEGINDRAG = $TVN_BEGINDRAGA
Global Const $WIN_UNKNOWN = -1, $WIN_95 = "WIN_95", $WIN_98 = "WIN_98", $WIN_ME = "WIN_ME", _
		$WIN_NT = "WIN_NT", $WIN_2000 = "WIN_2000", $WIN_XP = "WIN_XP", $WIN_2003 = "WIN_2003", $WIN_VISTA = "WIN_VISTA", $WIN_2008 = "WIN_2008"
Global $progress, $SGUI, $SGUI2, $iIndex, $i_opt
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
Global $fDragging = False, $hDragItem, $fWhere, $moving_txt, $item_above_drag, $item_below_drag, $moving_item_is_key = False, $his_parent, $wProcOldLocal, $form3
Global $Startx, $Starty, $Endx, $Endy, $aM_Mask, $aMask
Global $set_hotkeys = 0
Global $aUtil_MinMax[4]
Dim $ini_section[1]
Global $sToolTipData, $tooltip_x, $tooltip_y, $tooltip_timer, $display_tooltip = False, $tooltip_displayed = False, $display_infos = 1, $input5, $exit_loop = False
Dim $tool_txt_array[1][1]
Dim $aRecords
Dim $tooltips[1]
Global $string_splitter = "/"

Global $Last_hovered

Global Const $VK_RETURN = 0x0D ;Enter key
Global Const $VK_DELETE = 0x2E ;Del key
Global Const $VK_ESC = 0x1B ;Esc key
Global Const $VK_F2 = 0x71 ;F2 key
Global Const $VK_APP = 0x5D ;Application key

Global Enum $Save_only = 2001, $Save_as1 = 2002
Global Enum $add_item_menu = 3001, $edit_item_menu = 3002, $delete_item_menu = 3003, $expand_item_menu = 3004, $colapse_item_menu = 3005
Global Enum $expand_all_menu = 3006, $colapse_all_menu = 3007, $gen_write_menu = 3008, $gen_read_menu = 3009, $tool_tips_menu = 3010, $tool_tip_add_menu = 3011

Global $dll = DllOpen("user32.dll")

Global $prog_name = "Astetine - Links Workshop"

Global $Form1 = GUICreate($prog_name, 240 + 2, 500 + 28, -1, -1, $WS_SIZEBOX + $WS_MINIMIZEBOX + $WS_MAXIMIZEBOX)
GUISetIcon("Shell32.dll", -134)
GUISetBkColor(0xE0F0FE)

;;FILCKER START
Global Const $WM_ENTERSIZEMOVE = 0x0231 ; [ema]
Global Const $WM_EXITSIZEMOVE = 0x0232 ; [ema]
Global Const $WS_EX_COMPOSITED = 0x2000000 ; [ema]
GUIRegisterMsg($WM_ENTERSIZEMOVE, "WM_ENTERSIZEMOVE") ; [ema]
GUIRegisterMsg($WM_EXITSIZEMOVE, "WM_EXITSIZEMOVE") ; [ema]
Global $g_IsResizing = False

Func WM_ENTERSIZEMOVE($hWnd, $Msg, $wParam, $lParam)
	; add $WS_EX_COMPOSITED to the extended window style
	#forceref $hWnd, $Msg, $wParam, $lParam
	Local $GUIStyle
	; called when resizing begins
	If Not $g_IsResizing Then
		$GUIStyle = GUIGetStyle($Form1)
		GUISetStyle(-1, BitOR($GUIStyle[1], $WS_EX_COMPOSITED), $Form1)
		$g_IsResizing = True
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_ENTERSIZEMOVE

Func WM_EXITSIZEMOVE($hWnd, $Msg, $wParam, $lParam)
	; reset the extended window style to previous values
	#forceref $hWnd, $Msg, $wParam, $lParam
	Local $GUIStyle
	; called when resizing ends
	If $g_IsResizing Then
		$GUIStyle = GUIGetStyle($Form1)
		GUISetStyle(-1, BitAND($GUIStyle[1], BitNOT($WS_EX_COMPOSITED)), $Form1)
		$g_IsResizing = False
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_EXITSIZEMOVE
;; FLICKER END

Global $hToolbar = _GUICtrlToolbar_Create($Form1, $WS_TABSTOP + 0x00000800)
_GUICtrlToolbar_SetExtendedStyle($hToolbar, $TBSTYLE_EX_DRAWDDARROWS)
_GUICtrlToolbar_SetColorScheme($hToolbar, 16774367, 16774367)
Global $idNew = 1000, $idOpen = 1001, $idSave = 1002, $idHelp = 1003, $idPower = 1004, $idConfig = 1005

Global $hImage = _GUIImageList_Create(16, 16, 5, 3, 3)
_GUIImageList_AddIcon($hImage, "Shell32.dll", 142) ;new    0
_GUIImageList_AddIcon($hImage, "Shell32.dll", 206);-7) ;save    1
_GUIImageList_AddIcon($hImage, "Shell32.dll", 205) ;open    2
_GUIImageList_AddIcon($hImage, "Shell32.dll", 27) ;exit    3
_GUIImageList_AddIcon($hImage, "Shell32.dll", 84) ;Home    4
_GUIImageList_AddIcon($hImage, "Shell32.dll", 96) ;config    5
_GUIImageList_AddIcon($hImage, "Shell32.dll", 137) ;normal    6
_GUICtrlToolbar_SetImageList($hToolbar, $hImage)
$new_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&New")
$save_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&Save")
$open_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&Open")
;$power_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&Home")
$config_button_txt = _GUICtrlToolbar_AddString($hToolbar, "&Config")
$Exit_button_txt = _GUICtrlToolbar_AddString($hToolbar, "E&xit")
_GUICtrlToolbar_AddButton($hToolbar, $idNew, 0, $new_button_txt)
_GUICtrlToolbar_AddButton($hToolbar, $idSave, 1, $save_button_txt, $BTNS_DROPDOWN)
_GUICtrlToolbar_AddButton($hToolbar, $idOpen, 2, $open_button_txt)
_GUICtrlToolbar_AddButtonSep($hToolbar)
;_GUICtrlToolbar_AddButton($hToolbar, $idPower, 4, $power_button_txt)
_GUICtrlToolbar_AddButton($hToolbar, $idConfig, 5, $config_button_txt)
_GUICtrlToolbar_AddButtonSep($hToolbar)
_GUICtrlToolbar_AddButton($hToolbar, $idHelp, 3, $Exit_button_txt)


;_GUICtrlToolbar_SetButtonStyle($hToolbar, $idPower, $BTNS_CHECK)
_GUICtrlToolbar_SetButtonWidth($hToolbar, 37, 37)

Global $dir_input = GUICtrlCreateInput("", 0, 40 + 10, 240, 20, $ES_READONLY + $ES_AUTOHSCROLL)
GUICtrlSetBkColor(-1, 0x003D79)
GUICtrlSetColor(-1, 0xEDF3FE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
Global $add_item_button = GUICtrlCreateButton("&Append", 0, 60 + 10, 61, 22, $BS_FLAT + $BS_NOTIFY)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
_GUICtrlButton_SetImageList(-1, _set_button_image(54), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $edit_item_button = GUICtrlCreateButton("&Edit", 60, 60 + 10, 61, 22, $BS_FLAT + $BS_NOTIFY)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
_GUICtrlButton_SetImageList(-1, _set_button_image(67), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $delete_item_button = GUICtrlCreateButton("Delete", 120, 60 + 10, 61, 22, $BS_FLAT + $BS_NOTIFY)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
_GUICtrlButton_SetImageList(-1, _set_button_image(109), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
Global $find_item_button = GUICtrlCreateButton("&Find", 180, 60 + 10, 60, 22, $BS_FLAT + $BS_NOTIFY)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
_GUICtrlButton_SetImageList(-1, _set_button_image(55), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

;1
Global $colapse_item_button = GUICtrlCreateButton("Colapse", 240, 60 + 10, 60, 22, $BS_FLAT + $BS_NOTIFY)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
_GUICtrlButton_SetImageList(-1, _set_button_image(18), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
;2
Global $expand_item_button = GUICtrlCreateButton("Expand", 300, 60 + 10, 60, 22, $BS_FLAT + $BS_NOTIFY)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
_GUICtrlButton_SetImageList(-1, _set_button_image(21), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)




Global $button_gen_code = GUICtrlCreateButton("Search Configuration Files", 0, 465, 240, 22, $BS_FLAT + $BS_NOTIFY)
;Global $button_Clear_List = GUICtrlCreateButton("Clear Search", 130, 458, 120, 22, $BS_FLAT + $BS_NOTIFY)

DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
_GUICtrlButton_SetImageList(-1, _set_button_image(20), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT)
;Global $val_input = GUICtrlCreateInput("", 50, 480, 190, 20, $ES_READONLY + $ES_AUTOHSCROLL)
;GUICtrlSetBkColor(-1, 0x003D79)
;GUICtrlSetColor(-1, 0xEDF3FE)
;GUICtrlSetFont(-1, -1, 800)
;GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT)

;$val_label = GUICtrlCreateLabel("Value:", 5, 483, 40, 17)
;GUICtrlSetBkColor(-1, 0xD0D0D0)
;GUICtrlSetColor(-1, 0x003D79)
;GUICtrlSetFont(-1, -1, 800)
;GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)

GUICtrlCreateGraphic(0, 480, 50, 20)
GUICtrlSetBkColor(-1, 0x003D79)
GUICtrlSetState(-1, $GUI_DISABLE)

;$back2 = GUICtrlCreateGraphic(0, 91, @DesktopWidth, @DesktopHeight)
;GUICtrlSetBkColor(-1, 0xD0D0D0)
;GUICtrlSetState(-1, $GUI_DISABLE)

Global $find_input = GUICtrlCreateInput("", 0, 285 - 25, 100, 19, $ES_AUTOHSCROLL)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)

Global $button_find_next = GUICtrlCreateButton("Find Next", 100, 285 - 25, 55, 20, $BS_FLAT + $BS_NOTIFY)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $match_check = GUICtrlCreateCheckbox("&Match", 160, 285 - 24, 50, 17)
GUICtrlSetBkColor($match_check, 0xD0D0D0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
Global $button_close_find = GUICtrlCreateButton("", 223, 285 - 24, 24, 24, $BS_ICON, $WS_EX_CLIENTEDGE)
GUICtrlSetImage(-1, "Shell32.dll", -132, 0)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlSetState($find_input, $GUI_HIDE)
GUICtrlSetState($match_check, $GUI_HIDE)
GUICtrlSetState($button_find_next, $GUI_HIDE)
GUICtrlSetState($button_close_find, $GUI_HIDE)

;Global $treeview = _GUICtrlTreeView_Create($Form1, 0, 92, 240, 175, BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVIS_DROPHILITED, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS, $WS_TABSTOP));, $WS_EX_CLIENTEDGE)

Global $treeview = _GUICtrlTreeView_Create($Form1, 0, 92, 240, 185, BitOR($TVS_HASBUTTONS, $TVIS_DROPHILITED, $TVS_SHOWSELALWAYS, $TVS_HASLINES), $WS_EX_CLIENTEDGE);, $WS_EX_CLIENTEDGE)


_GUICtrlTreeView_SetTextColor($treeview, 0x003D79)
_GUICtrlTreeView_SetBkColor($treeview, 0xEDF3FE)


$size_client = WinGetClientSize($Form1)
$size_treeview = ControlGetPos($Form1, "", $treeview)
$previous_x_dif = $size_client[0] - $size_treeview[0] - $size_treeview[2]
$previous_y_dif = $size_client[1] - $size_treeview[1] - $size_treeview[3]

Global $hImage3 = _GUIImageList_Create(16, 16, 5, 3)
_GUIImageList_AddIcon($hImage3, "shell32.dll", 166)
_GUIImageList_AddIcon($hImage3, "shell32.dll", 199)
_GUIImageList_AddIcon($hImage3, "shell32.dll", 165)
_GUIImageList_AddIcon($hImage3, "shell32.dll", 137)
_GUICtrlTreeView_SetNormalImageList($treeview, $hImage3)

_GUICtrlTreeView_SetInsertMarkColor($treeview, 13005581)



ControlFocus($Form1, "", $treeview)


;;;;;;;;;;Gaby's start here
;GUICreate("ListView Click Item", 400, 300)

Global $hListView = GUICtrlCreateListView("", 0, 285, 240, 180)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
GUICtrlSetBkColor(-1, 0xEDF3FE)
GUICtrlSetColor(-1, 0x003D79)
GUICtrlSetFont(-1, -1, 800)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT)

_GUICtrlListView_SetUnicodeFormat($hListView, False)
;GUISetState()
;GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
; Load images
$hImage4 = _GUIImageList_Create()
_GUIImageList_AddIcon($hImage4, @SystemDir & "\shell32.dll", 137)
;_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($hListView), 0xFF0000, 16, 16))
;_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($hListView), 0x00FF00, 16, 16))
;_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($hListView), 0x0000FF, 16, 16))

_GUIImageList_Add($hImage4, _GUIImageList_AddIcon($hImage4, @SystemDir & "\shell32.dll", 137))
_GUIImageList_Add($hImage4, _GUIImageList_AddIcon($hImage4, @SystemDir & "\shell32.dll", 138))
_GUIImageList_Add($hImage4, _GUIImageList_AddIcon($hImage4, @SystemDir & "\shell32.dll", 139))

_GUICtrlListView_SetImageList($hListView, $hImage4, 1)
; Add columns
_GUICtrlListView_InsertColumn($hListView, 0, "Path", 800, 0, 3)
;_GUICtrlListView_InsertColumn($hListView, 1, "Column 2", 100)
;_GUICtrlListView_InsertColumn($hListView, 1, "File Name", 200)
; Add items
;_GUICtrlListView_AddItem($hListView, "gBY", 0)
;_GUICtrlListView_AddItem($hListView, "Row 2: Col 1", 1)

;_GUICtrlListView_AddItem($hListView, "Row 3: Col 1", 1)
;;;;;;;;;;gaby's end

;GUISetState(@SW_SHOW, $Form1)
initMinMax(248, 220, @DesktopWidth, @DesktopHeight)

Global $position = WinGetPos($Form1)
Global $client = WinGetClientSize($Form1)
Global $light_border = ($position[2] - $client[0]) / 2
Global $thick_border = $position[3] - $client[1] - $light_border
Global $x_coord = $position[0] + $light_border
Global $y_coord = $position[1] + $thick_border
Global $gw = 16
Global $gh = 16
$drag_gui = GUICreate("Drag", $gw, $gh, $x_coord, $y_coord, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST), $Form1)
GUISetBkColor(0xEDF3FE, $drag_gui)
$cursor_icon = GUICtrlCreateIcon("Shell32.dll", -147, 0, 0, 16, 16)
GUISetState(@SW_SHOWNOACTIVATE, $drag_gui)
setTrans()
GUISetState(@SW_HIDE, $drag_gui)

GUIRegisterMsg($WM_ACTIVATE, "WM_ACTIVATE")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")

Global $wProcHandle = DllCallbackRegister("_WindowProc", "int", "hwnd;uint;wparam;lparam")
Global $wProcHandle2 = DllCallbackRegister("_EditWindowProc", "ptr", "hwnd;uint;wparam;lparam")
Global $wProcOld = _WinAPI_SetWindowLong($treeview, $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle))
Global $wProcOldLocal2 = _WinAPI_SetWindowLong(GUICtrlGetHandle($find_input), $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle2))

_check_for_hotkeys()
;;Gaby;s code start
Global $hStatusBar, $hStatusBar2
Global $aParts[3] = [40, 200, -1]

$hStatusBar = _GUICtrlStatusBar_Create($Form1, $aParts)

WinMove("[active]", "", Default, Default, 500, 600)

GUISetState(@SW_SHOW, $Form1)

$BPMRTLocation = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Mercury Interactive\HP Business Process Monitor\CurrentVersion", "RuntimeEnvironment")
$BPMRTLocation = StringTrimRight($BPMRTLocation, 1)

;If $BPMRTLocation = "" Then
;	MsgBox(4096, "BPM Files not found", "Can not find BPM installation" & @CRLF & "Please use the Folder icon to set home directory")
;EndIf


;fonts for custom draw example
;bold
Local $aFontBold = DllCall("gdi32.dll", "int", "CreateFont", "int", 14, "int", 0, "int", 0, "int", 0, "int", 700, _
		"dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, _
		"dword", 0, "str", "")
;italic
Local $aFontItalic = DllCall("gdi32.dll", "int", "CreateFont", "int", 14, "int", 0, "int", 0, "int", 0, "int", 400, _
		"dword", 1, "dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, "dword", 0, _
		"dword", 0, "str", "")

Global $sRet

GUISetBkColor(0xE0F0FE)
GUISetState()
;;Gaby;s code end
Global $SGUI = GUICreate("Configuration", 400, 300, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_MDICHILD), $Form1)
;Global $SGUI = GUICreate("Configuration", 340, 200, -1, -1, -1, $WS_EX_TOOLWINDOW)
GUISetBkColor(0xE0F0FE)
Global $hStatusBar2
Global $aParts2[2] = [40, -1]
;Global $hHeader = _GUICtrlHeader_Create($SGUI)
;_GUICtrlHeader_AddItem($hHeader, "Set Files To Search", -1)
;_GUICtrlHeader_AddItem($hHeader, "", -1)
$hStatusBar2 = _GUICtrlStatusBar_Create($SGUI, $aParts2)
Global $Configtree = _GUICtrlTreeView_Create($SGUI, 0, 70, 160, 100, BitOR($TVS_CHECKBOXES, $TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVIS_DROPHILITED, $TVS_LINESATROOT, $TVS_SHOWSELALWAYS, $WS_TABSTOP), $TVS_CHECKBOXES);, $WS_EX_CLIENTEDGE)
_GUICtrlTreeView_SetTextColor($Configtree, 0x003D79)
_GUICtrlTreeView_SetBkColor($Configtree, 0xE0F0FE)
Global $hImage5 = _GUIImageList_Create(16, 16, 5, 3)
_GUIImageList_AddIcon($hImage5, "shell32.dll", 166)
_GUIImageList_AddIcon($hImage5, "shell32.dll", 199)
_GUIImageList_AddIcon($hImage5, "shell32.dll", 165)
_GUIImageList_AddIcon($hImage5, "shell32.dll", 137)
_GUICtrlTreeView_SetNormalImageList($Configtree, $hImage5)
_GUICtrlTreeView_SetInsertMarkColor($Configtree, 13005581)
_GUICtrlTreeView_BeginUpdate($Configtree)

Global $hItem10[5], $hFiles[5] = ["INI", "CFG", "CONF", "DAT", "Other File Type"]

For $x = 0 To UBound($hItem10) - 1
	$hItem10[$x] = _GUICtrlTreeView_Add($Configtree, 0, StringFormat($hFiles[$x], 4), 2, 1)
Next

Global $GlobalFileType = "INI"
_GUICtrlTreeView_SetChecked($Configtree, $hItem10[0], True) ;ini

$GetButton = GUICtrlCreateButton("Apply", 8, 245, 80, 23, $BS_FLAT + $BS_NOTIFY)
$CloseButton = GUICtrlCreateButton("Close", 98, 245, 80, 23, $BS_FLAT + $BS_NOTIFY)
$Group = GUICtrlCreateGroup("Set Home Directory", 4, 2, 393, 50)
$BrowseButton = GUICtrlCreateButton("...", 360, 20, 30, 23, $BS_FLAT + $BS_NOTIFY)
$BrowseInput = GUICtrlCreateInput("", 13, 20, 330, 21)

GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetData($BrowseInput, $BPMRTLocation)
$Group1 = GUICtrlCreateGroup("Other File Extension", 4, 156, 175, 75)
GUICtrlSetColor(-1, 0x000080)
$Input1 = GUICtrlCreateInput("", 13, 180, 160, 21)
GUICtrlSetState($Input1, $GUI_DISABLE)
$Label1 = GUICtrlCreateLabel("Use wildcards (* ?)", 12, 203, 160, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)

_GUICtrlTreeView_EndUpdate($Configtree)
_GUICtrlTreeView_Expand($Configtree)
GUISetState(@SW_HIDE, $SGUI)

Global $SGUI2 = GUICreate("Set hotkey value", 400, 300, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_MDICHILD), $Form1)
GUISetState(@SW_HIDE, $SGUI2)

GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUISetState(@SW_MAXIMIZE, $Form1)
_AddFileToListView($GlobalFileType)
_no_flash_disable($add_item_button)
_no_flash_disable($delete_item_button)
_no_flash_disable($edit_item_button)
_no_flash_disable($colapse_item_button)
_no_flash_disable($find_item_button)
_no_flash_disable($expand_item_button)


While 1
	If $fDragging = True Then chase()
	If $just_edited = True Then
		$just_edited = False
		Local $curent = _GUICtrlTreeView_GetSelection($treeview)
		Local $get = _get_level()
		;Switch $get
		;	Case 1 ;Key
		;		GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent)))
		;	Case 2 ;Section
		;		GUICtrlSetData($val_input, "")
		;	Case 3 ;Value
		;		GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, $curent))
		;EndSwitch
	EndIf
	If $save = False And _GUICtrlToolbar_GetButtonText($hToolbar, $idSave) = "&Save" Then
		_GUICtrlToolbar_SetButtonText($hToolbar, $idSave, "&Save*")
	ElseIf $save = True And _GUICtrlToolbar_GetButtonText($hToolbar, $idSave) = "&Save*" Then
		_GUICtrlToolbar_SetButtonText($hToolbar, $idSave, "&Save")
	EndIf
	$nMsg = GUIGetMsg(1)
	Switch $nMsg[1]
		Case $Form1
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					_exit()
				Case $colapse_item_button
					GUICtrlSetState($expand_item_button, $GUI_DISABLE)
					_colapse_all()
					GUICtrlSetState($expand_item_button, $GUI_ENABLE)
				Case $expand_item_button
					GUICtrlSetState($colapse_item_button, $GUI_DISABLE)
					_expand_all()
					GUICtrlSetState($colapse_item_button, $GUI_ENABLE)
				Case $add_item_button
					_add_item()
				Case $edit_item_button
					_TextEdit()
				Case $delete_item_button
					_delete_item()
				Case $button_gen_code
					_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListView))
					;_GUICtrlTreeView_DeleteAll($treeview)
					_AddFileToListView($GlobalFileType)
					$sRet = 0
				Case $find_item_button
					_find_item_input()
				Case $button_close_find
					_close_find()
				Case $button_find_next
					_find_item()
				Case $GUI_EVENT_PRIMARYDOWN
					Local $hItem = _GUICtrlTreeView_GetSelection($treeview)
					If $hItem Then _GUICtrlTreeView_SelectItem($treeview, $hItem)
				Case $GUI_EVENT_MOUSEMOVE
					If $fDragging = False Then
						If $display_infos Then
							Local $bHwnd = DllCall("user32.dll", "hwnd", "WindowFromPoint", "uint", MouseGetPos(0), "uint", MouseGetPos(1))
							Local $hItem5 = TreeItemFromPoint($treeview)
							If $hItem5 Then
								Local $aItem_Rect = _GUICtrlTreeView_DisplayRect($treeview, $hItem5)
								Local $aLV_Pos = WinGetPos($treeview)
								$sToolTipData = _get_tooltxt($hItem5)
								Local $x_movement
								Local $get = _get_level2($hItem5)
								Switch $get
									Case 1
										$x_movement = 105
									Case 2
										$x_movement = 90
									Case 3
										$x_movement = 120
								EndSwitch
								$tooltip_x = $aLV_Pos[0] + $aItem_Rect[0] + $x_movement
								$tooltip_y = $aLV_Pos[1] + $aItem_Rect[1] + 18
								ToolTip($sToolTipData, $tooltip_x, $tooltip_y)
							Else
								ToolTip("")
							EndIf
						EndIf
					Else
						Local $aHwnd = DllCall("user32.dll", "hwnd", "WindowFromPoint", "uint", MouseGetPos(0), "uint", MouseGetPos(1))
						Local $hItemHover = TreeItemFromPoint($treeview)
						If $hItemHover <> 0 Then
							$aRect = _GUICtrlTreeView_DisplayRect($treeview, $hItemHover)
							$iTreeY = _WinAPI_GetMousePosY(True, $treeview)
							Switch $iTreeY
								Case $aRect[1] To $aRect[1] + Int(($aRect[3] - $aRect[1]) / 4)
									If $fWhere <> -1 Then
										_GUICtrlTreeView_SetInsertMark($treeview, $hItemHover, False)
										$fWhere = -1
									EndIf
								Case 1 + $aRect[1] + Int(($aRect[3] - $aRect[1]) / 3) To $aRect[1] + Int(($aRect[3] - $aRect[1]) * 2 / 3)
									If $fWhere <> 0 Then
										_SendMessage($treeview, $TVM_SETINSERTMARK, 0, 0)
										$fWhere = 0
									EndIf
								Case 1 + $aRect[1] + Int(($aRect[3] - $aRect[1]) * 2 / 3) To $aRect[3]
									If $fWhere <> 1 Then
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
						If $moving_item_is_key = False And _get_level2(TreeItemFromPoint($treeview)) <> 2 Then ContinueCase
						If $moving_item_is_key = True And _get_level2(TreeItemFromPoint($treeview)) <> 1 Then ContinueCase
						If $moving_item_is_key = True And _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $hDragItem)) = 1 Then ContinueCase
						If $fWhere <> 0 Then
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
		Case $SGUI2
			Switch $nMsg[0]

				Case $GUI_EVENT_CLOSE
					;MsgBox(0, "GUI Event", "You clicked CLOSE! Exiting...")
					GUISetState(@SW_HIDE, $SGUI2)
			EndSwitch
		Case $SGUI
			Switch $nMsg[0]
				Case $GUI_EVENT_CLOSE
					GUISetState(@SW_HIDE, $SGUI)
					GUISetState(@SW_ENABLE, $Form1)
					WinActivate($Form1)
					GUISwitch($Form1)
				Case $GUI_EVENT_PRIMARYDOWN
					Local $tMPos = _WinAPI_GetMousePos(True, $Configtree)
					Local $tHitTest = _GUICtrlTreeView_HitTestEx($Configtree, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
					Local $iFlags = DllStructGetData($tHitTest, "Flags")
					If BitAND($iFlags, $TVHT_ONITEMSTATEICON) <> 0 Then
						Local $hItem9 = TreeItemFromPoint($Configtree)
						If $hItem9 Then _GUICtrlTreeView_SelectItem($Configtree, $hItem9)
					EndIf
				Case $GetButton
					$GlobalFileType = _GetChecked()
					$GlobalFileType = StringTrimLeft($GlobalFileType, 1)
					$GlobalFileType = StringTrimRight($GlobalFileType, 1)
					_GUICtrlStatusBar_SetText($hStatusBar2, "Done", 0)
					If $GlobalFileType = "|" Then
						_GUICtrlStatusBar_SetText($hStatusBar2, "", 0)
						MsgBox(262160, "Error Setting", "Please set at least one type of configuration file.")
					EndIf
				Case $CloseButton
					$GlobalFileType = _GetChecked()
					$GlobalFileType = StringTrimLeft($GlobalFileType, 1)
					$GlobalFileType = StringTrimRight($GlobalFileType, 1)
					If $GlobalFileType = "|" Then
						_GUICtrlStatusBar_SetText($hStatusBar2, "", 0)
						MsgBox(262160, "Error Setting", "Please set at least one type of configuration file before closing.")
					Else
						GUISetState(@SW_HIDE, $SGUI)
						GUISetState(@SW_ENABLE, $Form1)
						WinActivate($Form1)
						GUISwitch($Form1)
					EndIf
				Case $BrowseButton
					Local $BPMRTLocationTmp = $BPMRTLocation
					;MsgBox(4096, " $BPMRTLocationTmp  " , $BPMRTLocationTmp)
					$BPMRTLocation = FileSelectFolder("Choose a configuration folder.", "", 1)
					;MsgBox(4096, " After  " , $BPMRTLocation)
					If $BPMRTLocation = "" Then
						$BPMRTLocation = $BPMRTLocationTmp
						GUICtrlSetData($BrowseInput, $BPMRTLocation)
					Else
						GUICtrlSetData($BrowseInput, $BPMRTLocation)
					EndIf
			EndSwitch
	EndSwitch
WEnd

Func _GetChecked()
	Local $iSelected = "|"
	For $x = 0 To UBound($hItem10) - 1
		If $x <> UBound($hItem10) - 1 Then
			If _GUICtrlTreeView_GetChecked($Configtree, $hItem10[$x]) Then $iSelected &= _GUICtrlTreeView_GetText($Configtree, $hItem10[$x]) & "|"
		Else
			Local $GetInput = StringStripWS(GUICtrlRead($Input1), 8)
			$GetInput = StringUpper($GetInput)
			If $GetInput <> "" Then
				If $GetInput <> "INI" And _
						$GetInput <> "CFG" And _
						$GetInput <> "CONF" And _
						$GetInput <> "DAT" Then
					If _GUICtrlTreeView_GetChecked($Configtree, $hItem10[$x]) Then $iSelected &= $GetInput & "|"
				EndIf
			EndIf
		EndIf
	Next
	Return $iSelected
EndFunc   ;==>_GetChecked

Func OnAutoItExit()
	_GUICtrlStatusBar_Destroy($hStatusBar2)
	_GUIImageList_Destroy($hImage5)
	_GUICtrlTreeView_Destroy($Configtree)
	;	_GUICtrlHeader_Destroy($hHeader)
	_WinAPI_SetWindowLong($treeview, $GWL_WNDPROC, $wProcOld)
	_WinAPI_SetWindowLong(GUICtrlGetHandle($find_input), $GWL_WNDPROC, $wProcOldLocal2)
	DllCallbackFree($wProcHandle)
	DllCallbackFree($wProcHandle2)
	DllClose($dll)
EndFunc   ;==>OnAutoItExit

Func _WM_NOTIFY($hWndGUI, $MsgID, $wParam, $lParam)
	#forceref $hWndGUI, $MsgID, $wParam
	Local $tNMHDR, $event, $code, $i_idNew, $dwFlags, $lResult, $idFrom, $i_idOld, $tInfo
	Local $tNMTOOLBAR, $tNMTBHOTITEM, $hwndFrom, $code
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam) ;$tNMHDR
	$hwndFrom = DllStructGetData($tNMHDR, "hWndFrom") ;$hWndFrom
	$idFrom = DllStructGetData($tNMHDR, "IDFrom") ;$iIDFrom
	$code = DllStructGetData($tNMHDR, "Code") ;$iCode

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

	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

	Switch $hwndFrom
		Case $Configtree
			Switch $code
				Case $TVN_SELCHANGED, $TVN_SELCHANGEDW

					_DebugPrint("$TVN_SELCHANGED" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code)
				Case $NM_CLICK ; The user has clicked the left mouse button within the control
					Local $tMPos = _WinAPI_GetMousePos(True, $Configtree)
					Local $tHitTest = _GUICtrlTreeView_HitTestEx($Configtree, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
					Local $iFlags = DllStructGetData($tHitTest, "Flags")
					If BitAND($iFlags, $TVHT_ONITEMSTATEICON) <> 0 Then
						Local $iItem = _GUICtrlTreeView_HitTestItem($Configtree, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
						ConsoleWrite(_GUICtrlTreeView_GetText($Configtree, $iItem) & " is checked = " & _GUICtrlTreeView_GetChecked($Configtree, $iItem) & @LF)

						If _GUICtrlTreeView_GetText($Configtree, $iItem) = "Other File Type" Then

							If Not _GUICtrlTreeView_GetChecked($Configtree, $iItem) Then
								GUICtrlSetState($Input1, $GUI_ENABLE)
							Else

								GUICtrlSetState($Input1, $GUI_DISABLE)
								GUICtrlSetData($Input1, "")
							EndIf
						EndIf
					EndIf
					_DebugPrint("$NM_CLICK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_DBLCLK ; The user has double-clicked the left mouse button within the control

					_DebugPrint("$NM_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_RCLICK ; The user has clicked the right mouse button within the control
					_DebugPrint("$NM_RCLICK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_RDBLCLK ; The user has clicked the right mouse button within the control
					_DebugPrint("$NM_RDBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code)
;~ 					Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing

			EndSwitch
		Case $treeview
			Switch $code
				Case $NM_RCLICK ; Right Mouse Click
					If $display_infos Then ToolTip("")
					If $fDragging = True Then
						_cancel_dragging()
					Else
						Local $tInfo = DllStructCreate($tagNMTREEVIEW, $lParam)
						Local $hNewItem = DllStructGetData($tInfo, "NewParam")
						_GUICtrlTreeView_SelectItem($treeview, $hNewItem)
						_right_menu($hNewItem)
					EndIf
					Return 0
				Case $TVN_SELCHANGED, $TVN_SELCHANGEDW
					If Not $item_just_added Then
						Local $curent = _GUICtrlTreeView_GetSelection($treeview)
						Local $get = _get_level()
						Switch $get
							Case 1 ;Key

								;GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent)))
								_no_flash_disable($add_item_button, False)
								If _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetSelection($treeview))) = 1 Then
									_no_flash_disable($delete_item_button)
								Else
									_no_flash_disable($delete_item_button, False)
								EndIf
								_no_flash_disable($add_item_button)
								_no_flash_disable($delete_item_button)
								_no_flash_disable($edit_item_button)

							Case 2 ;Section
								;GUICtrlSetData($val_input, "")
								_no_flash_disable($add_item_button, False)
								_no_flash_disable($delete_item_button, False)
								_no_flash_disable($edit_item_button, False)
							Case 3 ;Value
								;GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, $curent))
								_no_flash_disable($add_item_button)
								_no_flash_disable($delete_item_button)
								_no_flash_disable($edit_item_button, False)
						EndSwitch
					Else
						$item_just_added = 0
					EndIf
					_GUICtrlTreeView_SetRemoveMark($treeview)
				Case $TVN_ENDLABELEDIT, $TVN_ENDLABELEDITW

					If $display_infos Then ToolTip("")
					HotKeySet("{Enter}")
					HotKeySet("{Esc}")
					Local $curent = _GUICtrlTreeView_GetSelection($treeview)
					#cs
						If $ITEM_ADDED1 = True Then
						HotKeySet("{Enter}", "_TextSet")
						HotKeySet("{Esc}", "_EditClose")
						$ITEM_ADDED1 = False
						$ITEM_ADDED2 = True
						_GUICtrlTreeView_EditText($treeview, _GUICtrlTreeView_GetNext($treeview, $LastAddedSection))
						;_GUICtrlTreeView_EditText($treeview, _GUICtrlTreeView_GetNext($treeview, _GUICtrlTreeView_GetNext($treeview, $LastAddedSection)))
						ElseIf $ITEM_ADDED2 = True Then
						HotKeySet("{Enter}", "_TextSet")
						HotKeySet("{Esc}", "_EditClose")
						$ITEM_ADDED2 = False
						_GUICtrlTreeView_EditText($treeview, _GUICtrlTreeView_GetNext($treeview, _GUICtrlTreeView_GetNext($treeview, $LastAddedSection)))
						_GUICtrlTreeView_SelectItem($treeview, $LastAddedSection, 0)
						ElseIf $ITEM_ADDED3 = True Then
						_no_flash_disable($delete_item_button, False)
						HotKeySet("{Enter}", "_TextSet")
						HotKeySet("{Esc}", "_EditClose")
						$ITEM_ADDED3 = False
						_GUICtrlTreeView_EditText($treeview, $LastAddedChild)
						_GUICtrlTreeView_SelectItem($treeview, $LastAddedKey, 0)
						EndIf
					#ce
					If $power_mode = True Then
						If Not $edit_mode Then
							If $section_added Then
								If $count_k = 3 Then
									_GUICtrlTreeView_Expand($treeview, $curent, False)
									$section_added = 0
									$count_k = 1
								Else
									$count_k += 1
								EndIf
							ElseIf $key_added Then
								If $count_k = 2 Then
									_GUICtrlTreeView_Expand($treeview, $curent, False)
									$key_added = 0
									$count_k = 1
								Else
									$count_k += 1
								EndIf
							EndIf
						Else
							If $expanded = False Then
								_GUICtrlTreeView_Expand($treeview, $curent, False)
							EndIf
							$edit_mode = 0
						EndIf
					EndIf
					If $iEditFlag Then
						$iEditFlag = 0
						Local $tInfo = DllStructCreate($tagNMTVDISPINFO, $lParam)
						Local $sBuffer = DllStructCreate("wchar Text[" & DllStructGetData($tInfo, "TextMax") & "]")
						If Not _GUICtrlTreeView_GetUnicodeFormat($hwndFrom) Then $sBuffer = StringTrimLeft($sBuffer, 1)
						DllStructSetData($sBuffer, "Text", DllStructGetData($tInfo, "Text"))
						If StringLen(DllStructGetData($sBuffer, "Text")) Then
							$save = False
							$just_edited = True
							Return 1
						EndIf
					EndIf
				Case $NM_KILLFOCUS

					Local $get = _get_level()
					Switch $get
						Case 1 ;Key

							_GUICtrlTreeView_EndEdit($treeview)
						Case 2 ;Section

						Case 3 ;Value

					EndSwitch

					If $display_infos Then ToolTip("")
				Case $TVN_ITEMEXPANDING, $TVN_ITEMEXPANDINGW
					If $display_infos Then ToolTip("")
				Case $TVN_BEGINLABELEDIT, $TVN_BEGINLABELEDITW
					;TODO: Detect when editing item

					;_SetItemX(_GUICtrlTreeView_GetItemHandle($treeview, $hItem))
					;MsgBox(0,2,_GUICtrlTreeView_GetItemHandle($treeview, $hItem))

					If $display_infos Then ToolTip("")
					HotKeySet("{Enter}", "_TextSet")
					HotKeySet("{Esc}", "_EditClose")
				Case $TVN_BEGINDRAG, $TVN_BEGINDRAGW
					If $display_infos Then ToolTip("")
					Local $tInfo = DllStructCreate($tagNMTREEVIEW, $lParam)
					Local $hNewItem = DllStructGetData($tInfo, "NewhItem")
					_GUICtrlTreeView_SelectItem($treeview, $hNewItem)
					Local $get = _get_level2($hNewItem)
					If $get = 3 Then ContinueCase
					If $get = 2 Then
						$moving_item_is_key = False
					ElseIf $get = 1 Then
						$moving_item_is_key = True
						$his_parent = _GUICtrlTreeView_GetParentHandle($treeview, $hNewItem)
					EndIf
					$hDragItem = $hNewItem
					$item_above_drag = GetNeighbourItem($treeview, $hDragItem)
					$item_below_drag = GetNeighbourItem($treeview, $hDragItem, False)
					$fDragging = True
					$moving_txt = "Moving: " & _GUICtrlTreeView_GetText($treeview, $hNewItem)
					_WinAPI_ShowCursor(False)
					GUISetState(@SW_SHOWNOACTIVATE, $drag_gui)
					HotKeySet("{Esc}", "_cancel_dragging2")
					ToolTip($moving_txt, MouseGetPos(0) + 18, MouseGetPos(1))

			EndSwitch
		Case $hWndListView

			Switch $code

				Case $NM_CUSTOMDRAW

					If Not _GUICtrlListView_GetViewDetails($hwndFrom) Then Return $GUI_RUNDEFMSG
					Local $tCustDraw = DllStructCreate('hwnd hwndFrom;int idFrom;int code;' & _
							'dword DrawStage;hwnd hdc;long rect[4];dword ItemSpec;int ItemState;dword Itemlparam;' & _
							'dword clrText;dword clrTextBk;int SubItem;dword ItemType;dword clrFace;int IconEffect;' & _
							'int IconPhase;int PartID;int StateID;long rectText[4];int Align', _;winxp or later
							$lParam)
					Local $iDrawStage, $iItem, $iSubitem, $hDC, $iColor1, $iColor2, $iColor3
					$iDrawStage = DllStructGetData($tCustDraw, 'DrawStage')
					If $iDrawStage = $CDDS_PREPAINT Then Return $CDRF_NOTIFYITEMDRAW;request custom drawing of items
					If $iDrawStage = $CDDS_ITEMPREPAINT Then Return $CDRF_NOTIFYSUBITEMDRAW;request drawing each cell separately
					If Not BitAND($iDrawStage, $CDDS_SUBITEM) Then Return $CDRF_DODEFAULT
					$iItem = DllStructGetData($tCustDraw, 'ItemSpec')
					;$iSubitem = DllStructGetData($tCustDraw, 'SubItem')
					;$iColor1 = RGB2BGR(0xFBFFD8); light yellow
					$iColor1 = RGB2BGR(0xFFFFA8); yellow
					;$iColor1 = RGB2BGR(0xFFDDDD); light red
					$iColor2 = RGB2BGR(-1) ; white
					;$iColor3 = RGB2BGR(0xFF0000); red
					$iColor3 = RGB2BGR(0xFF6060); light red
					;$iColor3 = RGB2BGR(0x000080); navy blue
					If $iIndex = -1 Then Return $CDRF_NEWFONT
					If StringInStr($iIndex, "|" & $iItem & "|") Then
						$hDC = DllStructGetData($tCustDraw, 'hdc')
						DllCall("gdi32.dll", "hwnd", "SelectObject", "hwnd", $hDC, "hwnd", $aFontBold[0])
						DllStructSetData($tCustDraw, 'clrText', $iColor2)
						DllStructSetData($tCustDraw, 'clrTextBk', $iColor3)
					EndIf
					Return $CDRF_NEWFONT
				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)



					If _GUICtrlListView_GetItemText($hListView, DllStructGetData($tInfo, "Index")) <> "" Then
						_open_file(_GUICtrlListView_GetItemText($hListView, DllStructGetData($tInfo, "Index")))
					EndIf
					If _GUICtrlTreeView_GetCount($treeview) > 0 Then
						_no_flash_disable($add_item_button, False)
						_no_flash_disable($delete_item_button, False)
						_no_flash_disable($edit_item_button, False)
						_no_flash_disable($colapse_item_button, False)
						_no_flash_disable($find_item_button, False)
						_no_flash_disable($expand_item_button, False)
						_GUICtrlTreeView_SelectItem($treeview, 0)
					Else
						_no_flash_disable($add_item_button)
						_no_flash_disable($delete_item_button)
						_no_flash_disable($edit_item_button)
						_no_flash_disable($colapse_item_button)
						_no_flash_disable($find_item_button)
						_no_flash_disable($expand_item_button)
					EndIf
					;_no_flash_disable($colapse_item_button, False)
					;_no_flash_disable($find_item_button, False)
					;_no_flash_disable($expand_item_button, False)
					_DebugPrint("$NM_CLICK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; No return value
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)



					If _GUICtrlListView_GetItemText($hListView, DllStructGetData($tInfo, "Index")) <> "" Then
						_open_file(_GUICtrlListView_GetItemText($hListView, DllStructGetData($tInfo, "Index")))
					EndIf
					If _GUICtrlTreeView_GetCount($treeview) > 0 Then
						_no_flash_disable($add_item_button, False)
						_no_flash_disable($delete_item_button, False)
						_no_flash_disable($edit_item_button, False)
						_no_flash_disable($colapse_item_button, False)
						_no_flash_disable($find_item_button, False)
						_no_flash_disable($expand_item_button, False)
						_GUICtrlTreeView_SelectItem($treeview, 0)
					Else
						_no_flash_disable($add_item_button)
						_no_flash_disable($delete_item_button)
						_no_flash_disable($edit_item_button)
						_no_flash_disable($colapse_item_button)
						_no_flash_disable($find_item_button)
						_no_flash_disable($expand_item_button)
					EndIf
					_DebugPrint("$NM_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; No return value
				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					;_open_file(_GUICtrlListView_GetItemText($hListView, DllStructGetData($tInfo, "Index")))
					_DebugPrint("$NM_RCLICK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					;Return 1 ; not to allow the default processing
					Return 0 ; allow the default processing
				Case $NM_RDBLCLK ; Sent by a list-view control when the user double-clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					;_open_file(_GUICtrlListView_GetItemText($hListView, DllStructGetData($tInfo, "Index")))
					_DebugPrint("$NM_RDBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hwndFrom & @LF & _
							"-->IDFrom:" & @TAB & $idFrom & @LF & _
							"-->Code:" & @TAB & $code & @LF & _
							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Switch $iwParam
		Case $Save_only
			_save_file(False)
		Case $Save_as1
			_save_file()
		Case $idSave
			_save_file(False)
		Case $idHelp
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer

			$iMsgBoxAnswer = MsgBox(262433, "Exit Dialog", "Are you sure you want to exit the application?")
			Select
				Case $iMsgBoxAnswer = 1 ;OK
					_exit()
				Case $iMsgBoxAnswer = 2 ;Cancel

			EndSelect
		Case $idNew
			_new_file()
		Case $idOpen
			_open_file()

			If _GUICtrlTreeView_GetCount($treeview) > 0 Then
				_no_flash_disable($add_item_button, False)
				_no_flash_disable($delete_item_button, False)
				_no_flash_disable($edit_item_button, False)
				_no_flash_disable($colapse_item_button, False)
				_no_flash_disable($find_item_button, False)
				_no_flash_disable($expand_item_button, False)
				_GUICtrlTreeView_SelectItem($treeview, 0)
			Else
				_no_flash_disable($add_item_button)
				_no_flash_disable($delete_item_button)
				_no_flash_disable($edit_item_button)
				_no_flash_disable($colapse_item_button)
				_no_flash_disable($find_item_button)
				_no_flash_disable($expand_item_button)
			EndIf
		Case $idConfig
			GUISetState(@SW_DISABLE, $Form1)
			GUISetState(@SW_SHOW, $SGUI)
			_GUICtrlStatusBar_SetText($hStatusBar2, "", 0)



			;Case $idPower
			;$BPMRTLocation = FileSelectFolder("Choose a configuration folder.", "")
			;MsgBox(4096,"ss", $BPMRTLocation)
			;#cs
			;MsgBox(4096, "   " , $BPMRTLocation)
			;Local $BPMRTLocationTmp = $BPMRTLocation
			;MsgBox(4096, " $BPMRTLocationTmp  " , $BPMRTLocationTmp)
			;$BPMRTLocation = FileSelectFolder("Choose a configuration folder.", "", 1)
			;MsgBox(4096, " After  " , $BPMRTLocation)
			;If $BPMRTLocation = "" Then
			;	$BPMRTLocation = $BPMRTLocationTmp
			;EndIf
			;MsgBox(4096, " After  " , $BPMRTLocation)
			;#ce
			;_turn_power_mode()
		Case $add_item_menu
			_add_item()
		Case $delete_item_menu
			_delete_item()
		Case $edit_item_menu()
			_TextEdit()
		Case $expand_item_menu
			_expand_selected()
		Case $colapse_item_menu
			_colapse_selected()
		Case $expand_all_menu
			_expand_all()
		Case $colapse_all_menu
			_colapse_all()
		Case $gen_write_menu
			_Generate_in_code()
		Case $gen_read_menu
			_generate_out_code()
		Case $tool_tips_menu
			If $display_infos = 1 Then
				$display_infos = 0
			Else
				$display_infos = 1
			EndIf
		Case $tool_tip_add_menu
			_create_tool_tip_window()
			If $display_infos Then ToolTip("")
	EndSwitch
	#forceref $hWnd, $iMsg
	Local $hwndFrom, $iIDFrom, $iCode, $hWndEdit
	If Not IsHWnd($find_input) Then $hWndEdit = GUICtrlGetHandle($find_input)
	$hwndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hwndFrom
		Case $find_input, $hWndEdit
			Switch $iCode
				Case 1024
					_find_item(True)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_ACTIVATE($hWnd, $Msg, $wParam, $lParam)
	Local $wActive = BitAND($wParam, 0x0000FFFF)
	_set_hotkeys($wActive)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_ACTIVATE

Func WM_SIZE($hWnd, $Msg, $wParam, $lParam)
	$size_client = WinGetClientSize($Form1)
	$size_treeview = ControlGetPos($Form1, "", $treeview)
	Local $new_width_treeview = $size_client[0] - $previous_x_dif - $size_treeview[0]
	Local $new_height_treeview = $size_client[1] - $previous_y_dif - $size_treeview[1]
	_WinAPI_MoveWindow($treeview, $size_treeview[0], $size_treeview[1], $new_width_treeview, $new_height_treeview, True)

	GUICtrlSetResizing($progress, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)


	_GUICtrlStatusBar_Resize($hStatusBar)
	_GUICtrlStatusBar_Resize($hStatusBar2)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

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
							If _GUICtrlTreeView_GetChildren($treeview, $curent) = True Then
								Local $get = _get_level()
								Switch $get
									Case 1
										If _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent)) > 1 Then
											_delete_tooltxt($curent)
											_GUICtrlTreeView_Delete($treeview, $curent)
											_no_flash_disable($delete_item_button, False)
										Else
											_no_flash_disable($delete_item_button)
										EndIf
									Case 2
										_delete_tooltxt($curent)
										_GUICtrlTreeView_Delete($treeview, $curent)
								EndSwitch
							EndIf
							$save = False
						Case $VK_F2
							_TextEdit()
						Case $VK_ESC
							Local $curent = _GUICtrlTreeView_GetSelection($treeview)
							Local $parent4 = _GUICtrlTreeView_GetParentHandle($treeview, $curent)
							If $parent4 Then
								_GUICtrlTreeView_SelectItem($treeview, $parent4)
								_GUICtrlTreeView_Expand($treeview, $parent4, False)
							EndIf
							ToolTip("")
						Case $VK_APP
							Local $curent = _GUICtrlTreeView_GetSelection($treeview)
							_right_menu($curent)
					EndSwitch
			EndSwitch

	EndSwitch
	If $hWnd = $treeview Then Return _WinAPI_CallWindowProc($wProcOld, $hWnd, $Msg, $wParam, $lParam)
EndFunc   ;==>_WindowProc

Func _EditWindowProc($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Switch $hWnd
		Case GUICtrlGetHandle($input5)
			Switch $iMsg
				Case $WM_GETDLGCODE
					Switch $wParam
						Case $VK_RETURN
							_tooltip_ok()
							$exit_loop = True
						Case $VK_ESC
							_tooltip_cancel()
							$exit_loop = True
					EndSwitch
			EndSwitch
		Case GUICtrlGetHandle($find_input)
			Switch $iMsg
				Case $WM_GETDLGCODE
					Switch $wParam
						Case $VK_RETURN
							_find_item()
						Case $VK_ESC
							_close_find()
					EndSwitch
			EndSwitch
	EndSwitch
	If $hWnd = GUICtrlGetHandle($input5) Then Return _WinAPI_CallWindowProc($wProcOldLocal, $hWnd, $iMsg, $wParam, $lParam)
	If $hWnd = GUICtrlGetHandle($find_input) Then Return _WinAPI_CallWindowProc($wProcOldLocal2, $hWnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>_EditWindowProc

Func initMinMax($x0, $y0, $x1, $y1)
	Local Const $WM_GETMINMAXINFO = 0x24
	$aUtil_MinMax[0] = $x0
	$aUtil_MinMax[1] = $y0
	$aUtil_MinMax[2] = $x1
	$aUtil_MinMax[3] = $y1
	GUIRegisterMsg($WM_GETMINMAXINFO, 'MY_WM_GETMINMAXINFO')
EndFunc   ;==>initMinMax

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
	Local $minmaxinfo = DllStructCreate('int;int;int;int;int;int;int;int;int;int', $lParam)
	DllStructSetData($minmaxinfo, 7, $aUtil_MinMax[0]); min X
	DllStructSetData($minmaxinfo, 8, $aUtil_MinMax[1]); min Y
	DllStructSetData($minmaxinfo, 9, $aUtil_MinMax[2]); max X
	DllStructSetData($minmaxinfo, 10, $aUtil_MinMax[3]); max Y
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_GETMINMAXINFO

Func _check_for_hotkeys()
	Local $wActive = WinActive($Form1)
	_set_hotkeys($wActive)
EndFunc   ;==>_check_for_hotkeys

Func _set_hotkeys($win_active)
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
EndFunc   ;==>_set_hotkeys

Func _right_menu($hWnd)
	Local $get = _get_level2($hWnd)
	$hMenu2 = _GUICtrlMenu_CreatePopup()
	;_GUICtrlMenu_AddMenuItem($hMenu2, "Add Item" & @TAB & "(Alt+A)", $add_item_menu)
	If $get = 3 Then _GUICtrlMenu_SetItemDisabled($hMenu2, 0)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Edit Item" & @TAB & "(F2)", $edit_item_menu)
	;_GUICtrlMenu_AddMenuItem($hMenu2, "Delete Item" & @TAB & "(Del)", $delete_item_menu)
	If $get = 1 And _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $hWnd)) = 1 Then _GUICtrlMenu_SetItemDisabled($hMenu2, 2)
	If $get = 3 Then _GUICtrlMenu_SetItemDisabled($hMenu2, 2)
	;_GUICtrlMenu_AddMenuItem($hMenu2, "")
	_GUICtrlMenu_AddMenuItem($hMenu2, "Display Description(s)", $tool_tips_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Add/Edit Description", $tool_tip_add_menu)
	If $display_infos Then
		_GUICtrlMenu_SetItemChecked($hMenu2, 4)
	Else
		_GUICtrlMenu_SetItemDisabled($hMenu2, 5)
		_GUICtrlMenu_SetItemChecked($hMenu2, 4, False)
	EndIf
	_GUICtrlMenu_AddMenuItem($hMenu2, "")
	_GUICtrlMenu_AddMenuItem($hMenu2, "Expand Selected", $expand_item_menu)
	_GUICtrlMenu_AddMenuItem($hMenu2, "Colapse Selected", $colapse_item_menu)
	;_GUICtrlMenu_AddMenuItem($hMenu2, "")
	;_GUICtrlMenu_AddMenuItem($hMenu2, "Expand All", $expand_all_menu)
	;_GUICtrlMenu_AddMenuItem($hMenu2, "Colapse All", $colapse_all_menu)
	;_GUICtrlMenu_AddMenuItem($hMenu2, "")
	;_GUICtrlMenu_AddMenuItem($hMenu2, "Generate WriteIni Code", $gen_write_menu)
	;_GUICtrlMenu_AddMenuItem($hMenu2, "Generate ReadIni Code", $gen_read_menu)
	If $get = 2 Then
		_GUICtrlMenu_SetItemDisabled($hMenu2, 13)
		_GUICtrlMenu_SetItemDisabled($hMenu2, 14)
	EndIf
	Local $hItem = _GUICtrlTreeView_GetSelection($treeview)
	If Not $hItem Then
		For $i = 0 To 14
			If $i <> 4 Then _GUICtrlMenu_SetItemDisabled($hMenu2, $i)
		Next
	EndIf
	$hBrush = _WinAPI_GetSysColorBrush($COLOR_INFOBK)
	_GUICtrlMenu_SetMenuBackground($hMenu2, $hBrush)
	_GUICtrlMenu_SetItemDisabled($hMenu2, $delete_item_menu)
	_GUICtrlMenu_TrackPopupMenu($hMenu2, $Form1)
	_GUICtrlMenu_DestroyMenu($hMenu2)
EndFunc   ;==>_right_menu

Func _create_gen_code_window($icode_gen = "", $window_subname = "")
	GUISetState(@SW_DISABLE, $Form1)
	Local $form2 = GUICreate("Generated AU3 Code" & " (" & $window_subname & ")", 300 + 2, 460 + 28, -1, -1, $WS_SIZEBOX + $WS_MINIMIZEBOX + $WS_MAXIMIZEBOX, -1, $Form1)
	GUISetIcon("Shell32.dll", -134, $form2)
	GUISetBkColor(0xE0F0FE, $form2)
	Local $edit_gen_code = GUICtrlCreateEdit($icode_gen, 0, 0, 300, 420)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKLEFT)
	GUICtrlSetColor(-1, 0x003D79)
	GUICtrlSetBkColor(-1, 0xE0F0FE)
	Local $button_copy_code = GUICtrlCreateButton("&Copy to clipboard", 76, 425, 140, 30)
	_GUICtrlButton_SetImageList(-1, _set_button_image(176), 5)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT)
	Local $button_close_code = GUICtrlCreateButton("Close", 220, 425, 75, 30)
	_GUICtrlButton_SetImageList(-1, _set_button_image(27), 5)
	GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT)
	GUISetState(@SW_SHOW, $form2)
	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $button_close_code
				GUISetState(@SW_ENABLE, $Form1)
				GUIDelete($form2)
				ExitLoop
			Case $button_copy_code
				_copy_generated_code($edit_gen_code)
		EndSwitch
	WEnd
EndFunc   ;==>_create_gen_code_window

Func _create_tool_tip_window()
	$exit_loop = False
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	GUISetState(@SW_DISABLE, $Form1)
	$form3 = GUICreate("enter new description", 160, 100, $tooltip_x, $tooltip_y, $WS_POPUP, -1, $Form1)
	GUISetBkColor(0xFFFFE1, $form3)
	$input5 = GUICtrlCreateEdit(StringReplace(StringReplace(_get_tooltxt($curent), @CRLF, " "), "  ", " "), 0, 0, 160, 80, $WS_VSCROLL + $ES_AUTOVSCROLL + $WS_TABSTOP + $ES_MULTILINE, $WS_EX_CLIENTEDGE)
	GUICtrlSetBkColor(-1, 0xFFFFE1)
	Local $button_ok = GUICtrlCreateButton("OK", 0, 80, 80, 20)
	GUICtrlSetBkColor(-1, 0xFFFFE1)
	Local $button_cancel = GUICtrlCreateButton("Cancel", 80, 80, 80, 20)
	GUICtrlSetBkColor(-1, 0xFFFFE1)
	$wProcOldLocal = _WinAPI_SetWindowLong(GUICtrlGetHandle($input5), $GWL_WNDPROC, DllCallbackGetPtr($wProcHandle2))
	GUISetState(@SW_SHOW, $form3)
	While 1
		If $exit_loop = True Then ExitLoop
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $button_ok
				_tooltip_ok()
				ExitLoop
			Case $button_cancel
				_tooltip_cancel()
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_create_tool_tip_window

Func _tooltip_ok()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	_add_tooltxt($curent, GUICtrlRead($input5))
	GUISetState(@SW_ENABLE, $Form1)
	_WinAPI_SetWindowLong(GUICtrlGetHandle($input5), $GWL_WNDPROC, $wProcOldLocal)
	GUIDelete($form3)
	$save = False
EndFunc   ;==>_tooltip_ok

Func _tooltip_cancel()
	GUISetState(@SW_ENABLE, $Form1)
	_WinAPI_SetWindowLong(GUICtrlGetHandle($input5), $GWL_WNDPROC, $wProcOldLocal)
	GUIDelete($form3)
EndFunc   ;==>_tooltip_cancel

Func _exit()
	If $save = False Then
		Switch MsgBox(3 + 32 + 512 + 262144, "Exit", "Save changes before you exit?")
			Case 6 ;yes
				_save_file(False)
				Exit
			Case 7 ;no
				Exit
		EndSwitch
	Else
		Exit
	EndIf
EndFunc   ;==>_exit

Func _set_button_image($icon_index)
	Local $hImage_Temp = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($hImage_Temp, "Shell32.dll", $icon_index)
	Return $hImage_Temp
EndFunc   ;==>_set_button_image

Func _new_file()
	If _GUICtrlTreeView_GetCount($treeview) <> 0 Then
		If $save = False Then
			Switch MsgBox(3 + 32 + 512 + 262144, "New File", "Save changes before you start new file?")
				Case 6 ;yes
					_save_file(False)
					_GUICtrlTreeView_BeginUpdate($treeview)
					_GUICtrlTreeView_DeleteAll($treeview)
					_GUICtrlTreeView_EndUpdate($treeview)
					GUICtrlSetData($dir_input, "New file, Not saved yet")
					$save = True
					_clear_tooltip_txt()

					_no_flash_disable($colapse_item_button)
					_no_flash_disable($find_item_button)
					_no_flash_disable($expand_item_button)
					_no_flash_disable($add_item_button, False)
					_no_flash_disable($edit_item_button)
					_no_flash_disable($delete_item_button)
				Case 7 ;no
					_GUICtrlTreeView_BeginUpdate($treeview)
					_GUICtrlTreeView_DeleteAll($treeview)
					_GUICtrlTreeView_EndUpdate($treeview)
					GUICtrlSetData($dir_input, "New file, Not saved yet")
					$save = True
					_clear_tooltip_txt()
					_no_flash_disable($colapse_item_button)
					_no_flash_disable($find_item_button)
					_no_flash_disable($expand_item_button)
					_no_flash_disable($add_item_button, False)
					_no_flash_disable($edit_item_button)
					_no_flash_disable($delete_item_button)
			EndSwitch
		Else
			_GUICtrlTreeView_BeginUpdate($treeview)
			_GUICtrlTreeView_DeleteAll($treeview)
			_GUICtrlTreeView_EndUpdate($treeview)
			GUICtrlSetData($dir_input, "New file, Not saved yet")
			$save = True
			$save = False
			_clear_tooltip_txt()
			_no_flash_disable($colapse_item_button)
			_no_flash_disable($find_item_button)
			_no_flash_disable($expand_item_button)
			_no_flash_disable($add_item_button, False)
			_no_flash_disable($edit_item_button)
			_no_flash_disable($delete_item_button)
		EndIf
	Else

		GUICtrlSetData($dir_input, "New file, Not saved yet")
		;$save = True
		$save = False
		_clear_tooltip_txt()
		_no_flash_disable($colapse_item_button)
		_no_flash_disable($find_item_button)
		_no_flash_disable($expand_item_button)
		_no_flash_disable($add_item_button, False)
		_no_flash_disable($edit_item_button)
		_no_flash_disable($delete_item_button)
	EndIf
EndFunc   ;==>_new_file

Func _FileSaveDialog($sTitle, $sInitDir, $sFilter = 'All (*.*)', $iOpt = 0, $sDefaultFile = "", $sDefaultExt = "", $mainGUI = 0)
	Local $iFileLen = 65536 ; Max chars in returned string
	; API flags prepare
	Local $iFlag = BitOR(BitShift(BitAND($iOpt, 2), -10), BitShift(BitAND($iOpt, 16), 3))
	; Filter string to array convertion
	Local $asFLines = StringSplit($sFilter, '|'), $asFilter[$asFLines[0] * 2 + 1]
	Local $i, $iStart, $iFinal, $suFilter = ''
	$asFilter[0] = $asFLines[0] * 2
	For $i = 1 To $asFLines[0]
		$iStart = StringInStr($asFLines[$i], '(', 0, 1)
		$iFinal = StringInStr($asFLines[$i], ')', 0, -1)
		$asFilter[$i * 2 - 1] = StringStripWS(StringLeft($asFLines[$i], $iStart - 1), 3)
		$asFilter[$i * 2] = StringStripWS(StringTrimRight(StringTrimLeft($asFLines[$i], $iStart), StringLen($asFLines[$i]) - $iFinal + 1), 3)
		$suFilter = $suFilter & 'char[' & StringLen($asFilter[$i * 2 - 1]) + 1 & '];char[' & StringLen($asFilter[$i * 2]) + 1 & '];'
	Next
	; Create API structures
	Local $uOFN = DllStructCreate('dword;int;int;ptr;ptr;dword;dword;ptr;dword' & _
			';ptr;int;ptr;ptr;dword;short;short;ptr;ptr;ptr;ptr;ptr;dword;dword')
	Local $usTitle = DllStructCreate('char[' & StringLen($sTitle) + 1 & ']')
	Local $usInitDir = DllStructCreate('char[' & StringLen($sInitDir) + 1 & ']')
	Local $usFilter = DllStructCreate($suFilter & 'char')
	Local $usFile = DllStructCreate('char[' & $iFileLen & ']')
	Local $usExtn = DllStructCreate('char[' & StringLen($sDefaultExt) + 1 & ']')
	For $i = 1 To $asFilter[0]
		DllStructSetData($usFilter, $i, $asFilter[$i])
	Next
	; Set Data of API structures
	DllStructSetData($usTitle, 1, $sTitle)
	DllStructSetData($usInitDir, 1, $sInitDir)
	DllStructSetData($usFile, 1, $sDefaultFile)
	DllStructSetData($usExtn, 1, $sDefaultExt)
	DllStructSetData($uOFN, 1, DllStructGetSize($uOFN))
	DllStructSetData($uOFN, 2, $mainGUI)
	DllStructSetData($uOFN, 4, DllStructGetPtr($usFilter))
	DllStructSetData($uOFN, 7, 1)
	DllStructSetData($uOFN, 8, DllStructGetPtr($usFile))
	DllStructSetData($uOFN, 9, $iFileLen)
	DllStructSetData($uOFN, 12, DllStructGetPtr($usInitDir))
	DllStructSetData($uOFN, 13, DllStructGetPtr($usTitle))
	DllStructSetData($uOFN, 14, $iFlag)
	DllStructSetData($uOFN, 17, DllStructGetPtr($usExtn))
	DllStructSetData($uOFN, 23, BitShift(BitAND($iOpt, 32), 5))
	; Call API function
	$ret = DllCall('comdlg32.dll', 'int', 'GetSaveFileName', _
			'ptr', DllStructGetPtr($uOFN))
	If $ret[0] Then
		Return DllStructGetData($usFile, 1)
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc   ;==>_FileSaveDialog

Func _save_to_file($save_file_dir)
	If FileExists($save_file_dir) Then FileDelete($save_file_dir)
	FileWrite($save_file_dir, "")
	Local $Sections = _get_Section_count()
	If $Sections <> -1 Then
		Local $Keys
		For $i = 1 To $Sections[0]
			$Keys = _get_key($Sections[$i])
			If $Keys <> -1 Then
				For $j = 1 To $Keys[0][0]
					IniWrite($save_file_dir, _GUICtrlTreeView_GetText($treeview, $Sections[$i]), _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]), _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]))
					If _get_tooltxt($Keys[$j][0]) <> "" Then _FileWriteToLine($save_file_dir, _FileCountLines($save_file_dir), ";//*//" & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) _
							 & "/" & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & "//*//" & StringReplace(StringReplace(_get_tooltxt($Keys[$j][0]), @CRLF, " "), "  ", " "))
					If _get_tooltxt($Keys[$j][1]) <> "" Then _FileWriteToLine($save_file_dir, _FileCountLines($save_file_dir), ";//*//" & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) _
							 & "/" & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & "/" & _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]) & "//*//" & StringReplace(StringReplace(_get_tooltxt($Keys[$j][1]), @CRLF, " "), "  ", " "))
				Next
			EndIf
			If _get_tooltxt($Sections[$i]) <> "" Then _FileWriteToLine($save_file_dir, _FileCountLines($save_file_dir), ";//*//" & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) _
					 & "//*//" & StringReplace(StringReplace(_get_tooltxt($Sections[$i]), @CRLF, " "), "  ", " "))
		Next
	EndIf
	GUICtrlSetData($dir_input, $save_file_dir)
EndFunc   ;==>_save_to_file

Func _get_save_file($newname = "New File")
	Local $save_file_dir = ""
	$rectype = False
	$save_file_dir = _FileSaveDialog("Save file", "", "Ini File [*.ini](*.ini)|Txt File [*.txt](*.txt)|Data File [*.dat](*.dat)|Config File [*.cfg](*.cfg)|Other [*.*](*.*)", 2 + 16, $newname, "", $Form1)
	Return $save_file_dir
EndFunc   ;==>_get_save_file

Func _save_file($saveAS = True)
	Local $save_file_dir = ""
	Local $read = GUICtrlRead($dir_input)
	Local $new_file_name = ""
	If $saveAS = True Then
		If $read = "New file, Not saved yet" Or $read = "No file loaded" Or $read = "Could not load selected file" Then
			$new_file_name = "New File"
		Else
			$new_file_name = StringTrimRight(StringTrimLeft($read, StringInStr($read, "\", 0, -1)), (StringLen($read) - StringInStr($read, ".", 0, -1) + 1))
		EndIf
		$save_file_dir = _get_save_file($new_file_name)
		If $save_file_dir <> "" Then
			_save_to_file($save_file_dir)
			$save = True
		EndIf
	Else
		If $read = "New file, Not saved yet" Or $read = "No file loaded" Or $read = "Could not load selected file" Then

			$save_file_dir = _get_save_file()
			If $save_file_dir <> "" Then
				_save_to_file($save_file_dir)
				$save = True
			EndIf

		Else
			_save_to_file($read)
			$save = True
		EndIf
	EndIf
EndFunc   ;==>_save_file

Func _get_Section_count()
	Local $count = _GUICtrlTreeView_GetSiblingCount($treeview, 0)
	If $count <> -1 Then
		Local $display2
		Local $display[$count + 1]
		$display[0] = $count
		Local $is_parent = False
		For $i = 1 To $count
			If $i = 1 Then
				$display2 = _GUICtrlTreeView_GetFirstItem($treeview)
			Else
				$display2 = _GUICtrlTreeView_GetNext($treeview, $display2)
				For $j = 1 To _GUICtrlTreeView_GetSiblingCount($treeview, $display2) * 2
					$display2 = _GUICtrlTreeView_GetNext($treeview, $display2)
				Next
			EndIf
			$display[$i] = _GUICtrlTreeView_GetItemHandle($treeview, $display2)
		Next
		Return $display
	Else
		Return -1
	EndIf
EndFunc   ;==>_get_Section_count

Func _clear_tooltip_txt()
	Local $count2 = UBound($tool_txt_array) - 1
	Local $index
	Local $found = False
	For $j = 1 To $count2
		_ArrayDelete($tool_txt_array, $j)
	Next
EndFunc   ;==>_clear_tooltip_txt

Func _open_file($FName = "")

	$not_open = 0

	If $save = False Then
		Switch MsgBox(3 + 32 + 512 + 262144, "Open File", "Save changes before you open file?")
			Case 6 ;yes
				_save_file(False)
			Case 2 ;cancel
				$not_open = 1
		EndSwitch
	EndIf

	If $not_open = 0 Then
		If IsDeclared("FName") Then
			If $FName = "" Then
				Local $file = FileOpenDialog("Open Configuration File", "", "Configuration Files (*.ini;*.cfg;*.config;*.dat)| Text Files (*.txt)|All Files (*.*)", 1 + 2)
			Else
				$file = $FName
			EndIf
		Else
			Local $file = FileOpenDialog("Open Configuration File", "", "Configuration Files (*.ini;*.cfg;*.config;*.dat)| Text Files (*.txt)|All Files (*.*)", 1 + 2)
		EndIf

		If Not @error Then
			_GUICtrlTreeView_BeginUpdate($treeview)
			_GUICtrlTreeView_DeleteAll($treeview)
			_clear_tooltip_txt()
			GUICtrlSetData($dir_input, $file)
			Local $ini_section_count = IniReadSectionNames($file)
			;_ArrayDisplay($ini_section_count)
			If Not @error Then
				ReDim $ini_section[$ini_section_count[0] + 1]
				For $i = 1 To $ini_section_count[0]
					$ini_section[$i] = _GUICtrlTreeView_Add($treeview, 0, $ini_section_count[$i], 0, 3)
					_GUICtrlTreeView_SetBold($treeview, $ini_section[$i])
					Local $ini_key_count = IniReadSection($file, $ini_section_count[$i])
					If @error Then
						GUICtrlSetData($dir_input, "Could not load selected file")
						ExitLoop
					EndIf
					Local $curent_key[$ini_key_count[0][0] + 1]
					Local $curent_value[$ini_key_count[0][0] + 1]
					For $j = 1 To $ini_key_count[0][0] ;TODO
						$curent_key[$j] = _GUICtrlTreeView_AddChild($treeview, $ini_section[$i], $ini_key_count[$j][0], 1, 3)
						$curent_value[$j] = _GUICtrlTreeView_AddChild($treeview, $curent_key[$j], $ini_key_count[$j][1], 2, 3)
						_GUICtrlTreeView_SetState($treeview, $ini_section[$i], $TVIS_EXPANDED) ;expand keys
					Next
				Next
				$save = True
			Else
				GUICtrlSetData($dir_input, "Could not load selected file")
			EndIf
			_GUICtrlTreeView_EndUpdate($treeview)
			If _GUICtrlTreeView_GetCount($treeview) > 0 Then
				_no_flash_disable($add_item_button, False)
				_no_flash_disable($delete_item_button, False)
				_no_flash_disable($edit_item_button, False)
				_no_flash_disable($colapse_item_button, False)
				_no_flash_disable($find_item_button, False)
				_no_flash_disable($expand_item_button, False)
				_GUICtrlTreeView_SelectItem($treeview, 0)
			Else
				_no_flash_disable($add_item_button)
				_no_flash_disable($delete_item_button)
				_no_flash_disable($edit_item_button)
				_no_flash_disable($colapse_item_button)
				_no_flash_disable($find_item_button)
				_no_flash_disable($expand_item_button)
			EndIf
			If Not _FileReadToArray($file, $aRecords) Then

			Else
				Local $is_section = 0
				Local $searching_item
				;_ArrayDisplay($aRecords)
				For $x = 1 To $aRecords[0]
					Local $current_string = $aRecords[$x]
					If StringLeft($current_string, 6) = ";//*//" Then
						ReDim $tooltips[$x + 1]
						Local $first_split = StringTrimLeft(StringTrimRight($current_string, StringLen($current_string) - StringInStr($current_string, "//*//", 0, -1) + 1), 6)
						Local $second_split = StringSplit($first_split, "/")
						Switch $second_split[0]
							Case 1
								Do
									$searching_item = _GUICtrlTreeView_FindItem($treeview, $second_split[1])
								Until _get_level2($searching_item) = 2
								_add_tooltxt($searching_item, StringRight($current_string, StringLen($current_string) - StringInStr($current_string, "//*//", 0, -1) - 4))
							Case 2
								Do
									$searching_item = _GUICtrlTreeView_FindItem($treeview, $second_split[2])
								Until _get_level2($searching_item) = 1
								_add_tooltxt($searching_item, StringRight($current_string, StringLen($current_string) - StringInStr($current_string, "//*//", 0, -1) - 4))
							Case 3
								Do
									$searching_item = _GUICtrlTreeView_FindItem($treeview, $second_split[3])
								Until _get_level2($searching_item) = 3
								_add_tooltxt($searching_item, StringRight($current_string, StringLen($current_string) - StringInStr($current_string, "//*//", 0, -1) - 4))
						EndSwitch
					EndIf
				Next

			EndIf
		EndIf
	EndIf

EndFunc   ;==>_open_file

Func _add_tooltxt($hWnd, $txt)
	Local $count2 = UBound($tool_txt_array) - 1
	Local $index
	Local $found = False
	For $j = 1 To $count2
		If $tool_txt_array[$j][0] = $hWnd Then
			$index = $j
			$found = True
			ExitLoop
		EndIf
	Next
	If $found = False Then
		Local $count = UBound($tool_txt_array, 1)

		ReDim $tool_txt_array[$count + 1][2]
		$tool_txt_array[$count][0] = $hWnd
		$tool_txt_array[$count][1] = _limit_txt($txt, 32)
	Else
		$tool_txt_array[$index][1] = _limit_txt($txt, 32)
	EndIf
EndFunc   ;==>_add_tooltxt

Func _limit_txt($text, $longest)
	$text = StringReplace($text, " " & @CRLF, " ")
	$text = StringReplace($text, "  ", " ")
	Local $split1 = StringSplit($text, " ")
	Local $longest2 = $longest
	Local $previous_txt = ""
	Local $split2
	For $i = 1 To $split1[0]
		If StringLen($split1[$i]) > $longest Then $longest = StringLen($split1[$i])
	Next
	For $i = 1 To $split1[0]
		If StringLen($split1[$i] & $previous_txt) < $longest Then
			$previous_txt &= $split1[$i] & " "
		Else
			$previous_txt &= @CRLF
			$longest = $longest2 + StringLen($previous_txt)
			$previous_txt &= $split1[$i] & " "
		EndIf
	Next
	Return StringTrimRight($previous_txt, 1)
EndFunc   ;==>_limit_txt

Func _delete_tooltxt($hWnd)
	Local $count2 = UBound($tool_txt_array) - 1
	Local $index
	Local $found = False
	For $j = 1 To $count2
		If $tool_txt_array[$j][0] = $hWnd Then
			$index = $j
			$found = True
			ExitLoop
		EndIf
	Next
	If $found = True Then
		_ArrayDelete($tool_txt_array, $index)
		Local $get_child_count = _GUICtrlTreeView_GetChildCount($treeview, $hWnd)
		If $get_child_count <> -1 Then
			Local $previous_item = _GUICtrlTreeView_GetFirstChild($treeview, $hWnd)
			For $j = 1 To $get_child_count
				If $j = 1 Then
					_delete_tooltxt($previous_item)
				Else
					$previous_item = _GUICtrlTreeView_GetNextChild($treeview, $previous_item)
					_delete_tooltxt($previous_item)
				EndIf
			Next
		EndIf
	EndIf
	ToolTip("")
EndFunc   ;==>_delete_tooltxt

Func _get_tooltxt($hWnd)
	Local $count2 = UBound($tool_txt_array) - 1
	Local $index
	Local $found = False
	For $j = 1 To $count2
		If $tool_txt_array[$j][0] = $hWnd Then
			$index = $j
			$found = True
			ExitLoop
		EndIf
	Next
	If $found = True Then
		Return $tool_txt_array[$index][1]
	Else
		Return ""
	EndIf
EndFunc   ;==>_get_tooltxt

Func _add_new_main_item()
	ReDim $ini_section[UBound($ini_section) + 1]
	Local $additem2, $additem3, $additem4, $additem5, $additem6, $additem7, $additem8, $additem9
	Local $curent_selection = _GUICtrlTreeView_GetSelection($treeview)

	$ini_section[UBound($ini_section) - 1] = _GUICtrlTreeView_Add($treeview, 0, "Name", 0, 3)
	$item_just_added = 1
	$section_added = 1
	_GUICtrlTreeView_SelectItem($treeview, $ini_section[UBound($ini_section) - 1]) ;select
	_GUICtrlTreeView_SetBold($treeview, $ini_section[UBound($ini_section) - 1])
	$additem2 = _GUICtrlTreeView_AddChild($treeview, $ini_section[UBound($ini_section) - 1], "URL", 1, 3)
	$additem3 = _GUICtrlTreeView_AddChild($treeview, $additem2, "http://", 2, 3)

	$additem4 = _GUICtrlTreeView_AddChild($treeview, $ini_section[UBound($ini_section) - 1], "Active", 1, 3)
	$additem5 = _GUICtrlTreeView_AddChild($treeview, $additem4, "False", 2, 3)

	$additem6 = _GUICtrlTreeView_AddChild($treeview, $ini_section[UBound($ini_section) - 1], "HotKey1", 1, 3)
	$additem7 = _GUICtrlTreeView_AddChild($treeview, $additem6, "Key Value", 2, 3)

	$additem8 = _GUICtrlTreeView_AddChild($treeview, $ini_section[UBound($ini_section) - 1], "HotKey2", 1, 3)
	$additem9 = _GUICtrlTreeView_AddChild($treeview, $additem8, "Key Value", 2, 3)

	_GUICtrlTreeView_Expand($treeview, $ini_section[UBound($ini_section) - 1])
	;_GUICtrlTreeView_EditText($treeview, $ini_section[UBound($ini_section) - 1])
	$LastAddedSection = _GUICtrlTreeView_GetItemHandle($treeview, $ini_section[UBound($ini_section) - 1])
	$ITEM_ADDED1 = True
EndFunc   ;==>_add_new_main_item

Func _add_item()
	Local $additem1
	Local $additem2
	Local $curent_selection = _GUICtrlTreeView_GetCount($treeview)
	;consolewrite("$curent_selection=" & $curent_selection &@LF)
	If $curent_selection = 0 Then
		If GUICtrlRead($dir_input) = "No file loaded" Then GUICtrlSetData($dir_input, "New file, Not saved yet");bug, adding before loading does not write to label.
		_add_new_main_item()
		$save = False
		$first_item_added = True
		_no_flash_disable($edit_item_button, False)
		_no_flash_disable($delete_item_button, False)
		_no_flash_disable($find_item_button, False)
		_no_flash_disable($colapse_item_button, False)
		_no_flash_disable($expand_item_button, False)
	Else
		Local $curent_selection = _GUICtrlTreeView_GetSelection($treeview)
		Local $get = _get_level()
		Switch $get
			Case 1
				#cs
					$additem1 = _GUICtrlTreeView_AddChild($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent_selection), "HotKey", 1, 3)
					$item_just_added = 1
					$key_added = 1
					_GUICtrlTreeView_SelectItem($treeview, $additem1) ;select
					$additem2 = _GUICtrlTreeView_AddChild($treeview, $additem1, "Key Value", 2, 3)
					_GUICtrlTreeView_Expand($treeview, $additem1)
					;_GUICtrlTreeView_EditText($treeview, $additem1)
					$LastAddedChild = _GUICtrlTreeView_GetItemHandle($treeview, _GUICtrlTreeView_GetNext($treeview, $additem1))
					$LastAddedKey = _GUICtrlTreeView_GetItemHandle($treeview, $additem1)
					$ITEM_ADDED3 = True
					$save = False
				#ce
			Case 2
				_add_new_main_item()
				$save = False
		EndSwitch
	EndIf
EndFunc   ;==>_add_item

Func _delete_item()

	Local $ItemCounted = _GUICtrlTreeView_GetCount($treeview)
	;MsgBox(0,0,"$ItemCounted" & $ItemCounted)
	If $ItemCounted = 9 Then
		_no_flash_disable($edit_item_button)
		_no_flash_disable($delete_item_button)
		_no_flash_disable($find_item_button)
		_no_flash_disable($colapse_item_button)
		_no_flash_disable($expand_item_button)
	EndIf

	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	If $curent Then
		Local $get = _get_level()
		Switch $get
			Case 1 ;Key
				_no_flash_disable($add_item_button, False)
				If _GUICtrlTreeView_GetChildCount($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetSelection($treeview))) = 1 Then
					_no_flash_disable($delete_item_button)
				Else
					_no_flash_disable($delete_item_button, False)
					_delete_tooltxt($curent)
					_GUICtrlTreeView_Delete($treeview, $curent)
					$save = False
				EndIf
			Case 2 ;Section
				_delete_tooltxt($curent)
				_GUICtrlTreeView_Delete($treeview, $curent)
				$save = False
				_no_flash_disable($add_item_button, False)
				;_no_flash_disable($delete_item_button, False)
			Case 3 ;Value
				;GUICtrlSetData($val_input, _GUICtrlTreeView_GetText($treeview, $curent))
				_no_flash_disable($add_item_button)
				_no_flash_disable($delete_item_button)
		EndSwitch
	EndIf

EndFunc   ;==>_delete_item

Func _copy_generated_code($Control)
	ClipPut(GUICtrlRead($Control))
EndFunc   ;==>_copy_generated_code

Func _get_key($Section)
	Local $return[1][1]
	Local $first_child = _GUICtrlTreeView_GetNext($treeview, $Section)
	Local $count = _GUICtrlTreeView_GetSiblingCount($treeview, $first_child)
	If $count <> -1 Then
		ReDim $return[$count + 1][2]
		For $i = 1 To $count
			If $i = 1 Then
				$return[$i][0] = $first_child
				$return[$i][1] = _GUICtrlTreeView_GetNext($treeview, $first_child)
			Else
				$return[$i][0] = _GUICtrlTreeView_GetNext($treeview, $return[$i - 1][1])
				$return[$i][1] = _GUICtrlTreeView_GetNext($treeview, $return[$i][0])
			EndIf
		Next
		$return[0][0] = $count
		Return $return
	Else
		Return -1
	EndIf
EndFunc   ;==>_get_key

Func _generate_full_code()
	Local $Sections
	Local $Keys
	Local $values
	Local $file_name = GUICtrlRead($dir_input)
	Local $final_ini = ""
	Local $new_file_name = ""
	Local $read = GUICtrlRead($dir_input)
	If $read = "New file, Not saved yet" Or $read = "No file loaded" Or $read = "Could not load selected file" Then
		$new_file_name = "New File.ini"
	Else
		$new_file_name = StringTrimLeft($read, StringInStr($read, "\", 0, -1))
	EndIf
	Local $pre_ini_txt = "_iGenerated_Ini_File_Save(@ScriptDir & ""\" & $new_file_name & """) ;Rename " & $new_file_name & " to whatever you want your file to be named" _
			 & @CRLF & @CRLF _
			 & "Func _iGenerated_Ini_File_Save($Save_File)" & @CRLF _
			 & @TAB & "If NOT FileExists($Save_File) then FileWrite($Save_File, """")" & @CRLF
	Local $after_ini_txt = "EndFunc"
	Local $gen_code = ""
	$Sections = _get_Section_count()
	If $Sections <> -1 Then
		For $i = 1 To $Sections[0]
			$Keys = _get_key($Sections[$i])
			If $Keys <> -1 Then
				For $j = 1 To $Keys[0][0]
					If $final_ini = "" Then
						$final_ini = @TAB & "IniWrite($Save_File, """ & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]) & """)" & @CRLF
					Else
						$final_ini &= @TAB & "IniWrite($Save_File, """ & _GUICtrlTreeView_GetText($treeview, $Sections[$i]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][0]) & """, """ & _GUICtrlTreeView_GetText($treeview, $Keys[$j][1]) & """)" & @CRLF
					EndIf
				Next
			EndIf
		Next
		$gen_code = $pre_ini_txt & $final_ini & $after_ini_txt
		;_create_gen_code_window($gen_code, "Full Write")
	EndIf
EndFunc   ;==>_generate_full_code

Func _find_item_input()
	If GUICtrlGetState($button_find_next) = 96 Then
		GUICtrlSetState($button_find_next, $GUI_SHOW)
		GUICtrlSetState($match_check, $GUI_SHOW)
		GUICtrlSetState($button_close_find, $GUI_SHOW)
		Local $control_pos = ControlGetPos($Form1, "", $treeview)
		ControlMove($Form1, "", $treeview, $control_pos[0], $control_pos[1], $control_pos[2], $control_pos[3] - 19)
		GUICtrlSetState($find_input, $GUI_SHOW)
		$size_client = WinGetClientSize($Form1)
		$size_treeview = ControlGetPos($Form1, "", $treeview)
		$previous_x_dif = $size_client[0] - $size_treeview[0] - $size_treeview[2]
		$previous_y_dif = $size_client[1] - $size_treeview[1] - $size_treeview[3]
	EndIf
	ControlFocus($Form1, "", $find_input)
EndFunc   ;==>_find_item_input

Func _generate_out_code()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	Local $Key
	Local $value
	Local $parent
	Local $send_txt = ""
	Local $get
	If _GUICtrlTreeView_GetCount($treeview) <> 0 Then
		$get = _get_level()
		Switch $get
			Case 1 ;Key
				$Key = _GUICtrlTreeView_GetText($treeview, $curent)
				$value = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent))
			Case 3 ;Value
				$value = _GUICtrlTreeView_GetText($treeview, $curent)
				$Key = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent))
		EndSwitch
		If $get <> 2 Then
			$parent = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent)))
			Local $new_file_name = ""
			Local $read = GUICtrlRead($dir_input)
			If $read = "New file, Not saved yet" Or $read = "No file loaded" Or $read = "Could not load selected file" Then
				$new_file_name = "New File.ini"
			Else
				$new_file_name = StringTrimLeft($read, StringInStr($read, "\", 0, -1))
			EndIf
			$send_txt = "IniRead(@ScriptDir & ""\" & $new_file_name & """, """ & $parent & """, """ & $Key & """, """ & $value & """) ;Change " & $new_file_name & " into your ini-read file"
			;_create_gen_code_window($send_txt, "Read")
		EndIf
	EndIf
EndFunc   ;==>_generate_out_code

Func _Generate_in_code()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	Local $Key
	Local $value
	Local $parent
	Local $send_txt = ""
	Local $get
	If _GUICtrlTreeView_GetCount($treeview) <> 0 Then
		$get = _get_level()
		Switch $get
			Case 1 ;Key
				$Key = _GUICtrlTreeView_GetText($treeview, $curent)
				$value = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetFirstChild($treeview, $curent))
			Case 3 ;Value
				$value = _GUICtrlTreeView_GetText($treeview, $curent)
				$Key = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent))
		EndSwitch
		If $get <> 2 Then
			$parent = _GUICtrlTreeView_GetText($treeview, _GUICtrlTreeView_GetParentHandle($treeview, _GUICtrlTreeView_GetParentHandle($treeview, $curent)))


			Local $new_file_name = ""
			Local $read = GUICtrlRead($dir_input)
			If $read = "New file, Not saved yet" Or $read = "No file loaded" Or $read = "Could not load selected file" Then
				$new_file_name = "New File.ini"
			Else
				$new_file_name = StringTrimLeft($read, StringInStr($read, "\", 0, -1))
			EndIf
			$send_txt = "IniWrite(@ScriptDir & ""\" & $new_file_name & """, """ & $parent & """, """ & $Key & """, """ & $value & """) ;Rename " & $new_file_name & " to your ini file"
			;_create_gen_code_window($send_txt, "Write")
		EndIf
	EndIf
EndFunc   ;==>_Generate_in_code

Func _save_dummy()
	_save_file(False)
EndFunc   ;==>_save_dummy

Func _save_dummy2()
	_save_file(True)
EndFunc   ;==>_save_dummy2

Func _expand_selected()
	_GUICtrlTreeView_Expand($treeview, _GUICtrlTreeView_GetSelection($treeview))

EndFunc   ;==>_expand_selected

Func _expand_all()
	Local $Sections = _get_Section_count()
	If $Sections <> -1 Then
		For $i = 1 To $Sections[0]
			_GUICtrlTreeView_Expand($treeview, $Sections[$i])
		Next
	EndIf
EndFunc   ;==>_expand_all

Func _colapse_selected()
	_GUICtrlTreeView_Expand($treeview, _GUICtrlTreeView_GetSelection($treeview), False)
EndFunc   ;==>_colapse_selected

Func _colapse_all()
	_no_flash_disable($edit_item_button, False)
	_no_flash_disable($delete_item_button, False)
	_no_flash_disable($find_item_button, False)
	_no_flash_disable($colapse_item_button, False)
	_no_flash_disable($expand_item_button, False)
	_no_flash_disable($add_item_button, False)
	Local $Sections = _get_Section_count()
	If $Sections <> -1 Then
		For $i = 1 To $Sections[0]
			_GUICtrlTreeView_Expand($treeview, $Sections[$i], False)
		Next
	EndIf
	;_GUICtrlTreeView_SelectItem($treeview, 0)
EndFunc   ;==>_colapse_all

Func _close_find()
	If GUICtrlGetState($find_input) <> 96 Then
		GUICtrlSetState($find_input, $GUI_HIDE)
		GUICtrlSetState($match_check, $GUI_HIDE)
		GUICtrlSetState($button_find_next, $GUI_HIDE)
		GUICtrlSetState($button_close_find, $GUI_HIDE)
		_GUICtrlTreeView_SetRemoveMark($treeview)
		Local $control_pos = ControlGetPos($Form1, "", $treeview)
		ControlMove($Form1, "", $treeview, $control_pos[0], $control_pos[1], $control_pos[2], $control_pos[3] + 19)
		ControlFocus($Form1, "", $treeview)
		$size_client = WinGetClientSize($Form1)
		$size_treeview = ControlGetPos($Form1, "", $treeview)
		$previous_x_dif = $size_client[0] - $size_treeview[0] - $size_treeview[2]
		$previous_y_dif = $size_client[1] - $size_treeview[1] - $size_treeview[3]
	EndIf
EndFunc   ;==>_close_find

Func GetNeighbourItem($hWnd, $hItemTarget, $above = True)
	If $above = True Then
		Local $hPrev = _GUICtrlTreeView_GetPrevSibling($hWnd, $hItemTarget)
		Return $hPrev
	Else
		Local $hNext = _GUICtrlTreeView_GetNextSibling($hWnd, $hItemTarget)
		Return $hNext
	EndIf
EndFunc   ;==>GetNeighbourItem

Func TreeItemCopy($hWnd, $hItemSource, $hItemTarget, $fDirection)
	$hTest = $hItemTarget
	Do
		$hTest = _GUICtrlTreeView_GetParentHandle($hWnd, $hTest)
		If $hTest = $hItemSource Then Return 0
	Until $hTest = 0
	$sText = _GUICtrlTreeView_GetText($hWnd, $hItemSource)
	$hParent = _GUICtrlTreeView_GetParentHandle($hWnd, $hItemTarget)
	Switch $fDirection
		Case - 1
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
		For $i = 0 To $iChildCount - 1
			$hRecSource = _GUICtrlTreeView_GetItemByIndex($hWnd, $hItemSource, $i)
			TreeItemCopy($hWnd, $hRecSource, $hNew, 0)
		Next
	EndIf
	Return $hNew
EndFunc   ;==>TreeItemCopy

Func TreeItemFromPoint($hWnd)
	Local $tMPos = _WinAPI_GetMousePos(True, $hWnd)
	Return _GUICtrlTreeView_HitTestItem($hWnd, DllStructGetData($tMPos, 1), DllStructGetData($tMPos, 2))
EndFunc   ;==>TreeItemFromPoint

Func _find_item($typo = False)
	Local $match
	Local $select_one
	If GUICtrlRead($match_check) = $GUI_CHECKED Then
		$match = False
	Else
		$match = True
	EndIf
	Local $find_data = GUICtrlRead($find_input)
	Local $curent_selection = _GUICtrlTreeView_GetSelection($treeview)
	If _GUICtrlTreeView_FindItem($treeview, $find_data, $match) <> 0 Then
		GUICtrlSetBkColor($find_input, 0xD5FFDF)
	Else
		If $find_data <> "" Then
			GUICtrlSetBkColor($find_input, 0xFFE1E1)
		Else
			GUICtrlSetBkColor($find_input, 0xFFFFFF)
		EndIf
		_GUICtrlTreeView_SetRemoveMark($treeview);, 0)
		Return 0
	EndIf
	If $typo = True Then
		If Not StringInStr(_GUICtrlTreeView_GetText($treeview, $curent_selection), $find_data) Then
			$select_one = _GUICtrlTreeView_FindItem($treeview, $find_data, $match, _GUICtrlTreeView_GetNext($treeview, $curent_selection))
			If _GUICtrlTreeView_GetText($treeview) = _GUICtrlTreeView_GetText($treeview, $select_one) And $find_data <> _GUICtrlTreeView_GetText($treeview) Then
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
		If _GUICtrlTreeView_GetText($treeview) = _GUICtrlTreeView_GetText($treeview, $select_one) And $find_data <> _GUICtrlTreeView_GetText($treeview) Then
			_GUICtrlTreeView_SelectItem($treeview, _GUICtrlTreeView_FindItem($treeview, $find_data, $match));$select_one)
			_GUICtrlTreeView_SetInsertMark($treeview, _GUICtrlTreeView_FindItem($treeview, $find_data, $match))
		Else
			_GUICtrlTreeView_SelectItem($treeview, $select_one)
			_GUICtrlTreeView_SetInsertMark($treeview, $select_one)
		EndIf
	EndIf
EndFunc   ;==>_find_item

Func _GUICtrlTreeView_SetRemoveMark($hWnd)
	_SendMessage($hWnd, $TVM_SETINSERTMARK, 0, 0)
EndFunc   ;==>_GUICtrlTreeView_SetRemoveMark

;Func _turn_power_mode()
;	If $power_mode = False Then
;		$power_mode = True
;		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $idPower, 5)
;	Else
;		$power_mode = False
;		_GUICtrlToolbar_SetButtonBitMap($hToolbar, $idPower, 4)
;	EndIf
;EndFunc   ;==>_turn_power_mode

Func _cancel_dragging()
	HotKeySet("{Esc}")
	$fDragging = False
	GUISetState(@SW_HIDE, $drag_gui)
	_WinAPI_ShowCursor(True)
	ToolTip("")
	_WinAPI_InvalidateRect($treeview)
	_SendMessage($treeview, $TVM_SETINSERTMARK, 0, 0)
EndFunc   ;==>_cancel_dragging

Func _get_level()
	Local $curent = _GUICtrlTreeView_GetSelection($treeview)
	Local $n = 1
	Local $varX = $curent
	For $j = 1 To 3
		$varX = _GUICtrlTreeView_GetFirstChild($treeview, $varX)
		If _GUICtrlTreeView_GetChildren($treeview, $varX) = False Then ExitLoop
		$n += 1
	Next
	Return $n
EndFunc   ;==>_get_level

Func _get_level2($curent)
	Local $n = 1
	Local $varX = $curent
	For $j = 1 To 3
		$varX = _GUICtrlTreeView_GetFirstChild($treeview, $varX)
		If _GUICtrlTreeView_GetChildren($treeview, $varX) = False Then ExitLoop
		$n += 1
	Next
	Return $n
EndFunc   ;==>_get_level2

Func _no_flash_disable($button_handle, $disable = True)
	If $disable Then
		If GUICtrlGetState($button_handle) <> 144 Then GUICtrlSetState($button_handle, $GUI_DISABLE)
	Else
		If GUICtrlGetState($button_handle) <> 80 Then GUICtrlSetState($button_handle, $GUI_ENABLE)
	EndIf
EndFunc   ;==>_no_flash_disable

Func _TextEdit()
	HotKeySet("{Enter}", "_TextSet")
	HotKeySet("{Esc}", "_EditClose")
	Local $hItem = _GUICtrlTreeView_GetSelection($treeview)
	If $hItem Then
		If $power_mode = False Then
			_GUICtrlTreeView_EditText($treeview, $hItem)
		Else
			$edit_mode = 1
			If _GUICtrlTreeView_GetExpanded($treeview, $hItem) = True Then
				$expanded = True
			Else
				If _get_level2($hItem) <> 2 Then _GUICtrlTreeView_Expand($treeview, $hItem)
				$expanded = False
			EndIf
			Local $get = _get_level()

			Switch $get
				Case 1 ;key
					_GUICtrlTreeView_EditText($treeview, _GUICtrlTreeView_GetNext($treeview, $hItem))
				Case 2 ;section
					_GUICtrlTreeView_EditText($treeview, $hItem)
				Case 3 ;value
					_GUICtrlTreeView_EditText($treeview, $hItem)

			EndSwitch
		EndIf
	Else
		HotKeySet("{Enter}")
		HotKeySet("{Esc}")
	EndIf
EndFunc   ;==>_TextEdit

Func _TextSet()
	$iEditFlag = 1
	_GUICtrlTreeView_EndEdit($treeview)
	$save = False
EndFunc   ;==>_TextSet

Func _EditClose()
	$iEditFlag = 0
	$ITEM_ADDED1 = False
	$ITEM_ADDED2 = False
	$ITEM_ADDED3 = False
	_GUICtrlTreeView_EndEdit($treeview)
	If $power_mode = True Then
		$section_added = 0
		$key_added = 0
		$count_k = 1
		_GUICtrlTreeView_Expand($treeview, _GUICtrlTreeView_GetSelection($treeview), False)
	EndIf
EndFunc   ;==>_EditClose

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
EndFunc   ;==>setTrans

Func addRegion()
	$aMask = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", $Startx, "long", $Starty, "long", $Endx + 1, "long", $Endy + 1)
	DllCall("gdi32.dll", "long", "CombineRgn", "long", $aM_Mask[0], "long", $aMask[0], "long", $aM_Mask[0], "int", 3)
EndFunc   ;==>addRegion

Func chase()
	$mp = MouseGetPos()
	WinMove($drag_gui, "", $mp[0] + 1, $mp[1] + 0)
	ToolTip($moving_txt, $mp[0] + 18, $mp[1])
EndFunc   ;==>chase

Func _cancel_dragging2()
	If $fDragging = True Then _cancel_dragging()
EndFunc   ;==>_cancel_dragging2

Func _OsLevel()
	Switch @OSVersion
		Case "WIN_95"
			Return $WIN_95
		Case "WIN_98"
			Return $WIN_98
		Case "WIN_ME"
			Return $WIN_ME
		Case "WIN_NT"
			Return $WIN_NT
		Case "WIN_2000"
			Return $WIN_2000
		Case "WIN_XP"
			Return $WIN_XP
		Case "WIN_2003"
			Return $WIN_2003
		Case "WIN_VISTA"
			Return $WIN_VISTA
		Case "WIN_2008"
			Return $WIN_2008
		Case Else
			Return SetError(1, 0, $WIN_UNKNOWN)
	EndSwitch
EndFunc   ;==>_OsLevel

#cs
	High Speed
	$sPath filepath
	$sSub include sub-folders? 0=N 1=Y annother = N
	$sFilter  Optional the filter to use, default is *.*
	$flag 0=output all files & folders,1=folders only ,2=files only ,default = 0 annother = 0
	$sOUT tempfile
#ce
Func _FindPathName($sPath, $sFilter = "*", $sSub = 1, $sFalg = 0, $sOUT = "")
	If $sOUT = "" Then $sOUT = @ScriptDir & "\filelist.txt"
	If StringRight($sPath, 1) <> "\" Then $sPath = $sPath & "\"
	If $sSub = 1 Then
		$sSub = " /s"
	Else
		$sSub = ""
	EndIf
	If $sFilter = "" Then $sFilter = "*"

	If $sFalg = 1 Then
		$sFalg = "/a:d"
	ElseIf $sFalg = 2 Then
		$sFalg = "/a:-d"
	Else
		$sFalg = "/a"
	EndIf

	If @OSTYPE = "WIN32_WINDOWS" Then
		$progress = GUICtrlCreateProgress(0, 0, 200, -1, $PBS_SMOOTH)
		GUICtrlSetBkColor(-1, 0x003D79)
		GUICtrlSetColor(-1, 0xEDF3FE)
		$hProgress = GUICtrlGetHandle($progress)
		_GUICtrlStatusBar_EmbedControl($hStatusBar, 1, $hProgress)
		GUICtrlSetBkColor(-1, 0x003D79)
		GUICtrlSetColor(-1, 0xEDF3FE)
	Else
		$progress = GUICtrlCreateProgress(0, 0, 395, -1, $PBS_MARQUEE) ; marquee works on Win XP and above
		;GUICtrlSetBkColor(-1, 0x003D79)
		;GUICtrlSetColor(-1, 0xEDF3FE)
		$hProgress = GUICtrlGetHandle($progress)
		_GUICtrlStatusBar_EmbedControl($hStatusBar, 1, $hProgress)
		;GUICtrlSetBkColor(-1, 0x003D79)
		; _GUICtrlStatusBar_SetBkColor ($hStatusBar, 0x003D79)
		;GUICtrlSetColor(-1, 0xEDF3FE)
		_SendMessage($hProgress, $PBM_SETMARQUEE, True, 200)
	EndIf
	;$progress = GUICtrlCreateProgress(0, 0, 395, -1, $PBS_MARQUEE) ; marquee works on Win XP and above
	; $hProgress = GUICtrlGetHandle($progress)
	; _GUICtrlStatusBar_EmbedControl ($hStatusBar, 1, $hProgress)
	; _SendMessage($hProgress, $PBM_SETMARQUEE, True, 200)
	GUISetCursor(15, 1, $Form1)
	GUICtrlSetState($button_gen_code, $GUI_DISABLE)
	RunWait(@ComSpec & ' /c ' & 'dir "' & $sPath & $sFilter & '" ' & $sFalg & ' /b' & $sSub & ' > "' & $sOUT & '"', '', @SW_HIDE)
	GUICtrlSetState($button_gen_code, $GUI_ENABLE)
	GUISetCursor(2, 1, $Form1)
	GUICtrlDelete($progress)
	Dim $sfilelist
	_FileReadToArray($sOUT, $sfilelist)
	If Not IsArray($sfilelist) Then
		Dim $sfilelist[1]
		$sfilelist[0] = 0
	Else
		If $sfilelist[$sfilelist[0]] = "" Then
			_ArrayDelete($sfilelist, $sfilelist[0])
			$sfilelist[0] = $sfilelist[0] - 1
		EndIf
	EndIf
	FileDelete($sOUT)
	Return $sfilelist
EndFunc   ;==>_FindPathName

Func _AddFileToListView($sFileExt)
	Local $cfg
	$cfg = _Concatenate($sFileExt)
	_GUICtrlListView_BeginUpdate($hListView)
	$iIndex = "|"
	For $i = 1 To UBound($cfg) - 1
		;DISPLAY ON LISTBOX ONLY IF VALID INI FORMAT if not valid then color it
		IniReadSectionNames($cfg[$i])
		If Not @error Then
			_GUICtrlListView_AddItem($hListView, $cfg[$i], 0)
			_GUICtrlListView_AddSubItem($hListView, $i - 1, StringRegExpReplace($cfg[$i], "^.*\\", ""), 1)
			;Else
			;	$iIndex = $iIndex & $i - 1 & "|"
			;	_GUICtrlListView_AddItem($hListView, $cfg[$i], 0)
			;	_GUICtrlListView_AddSubItem($hListView, $i - 1, StringRegExpReplace($cfg[$i], "^.*\\", ""), 1)
			;	_GUICtrlListView_SetOutlineColor($hListView, 0x0000FF)
		EndIf
	Next
	_WinAPI_RedrawWindow($hListView)
	_GUICtrlListView_EndUpdate($hListView)
EndFunc   ;==>_AddFileToListView

Func _Concatenate($sFileExt)
	Local $aTypes, $aFilesTemp, $aFilesConst
	$aTypes = StringSplit($sFileExt, "|")
	$aFilesConst = StringSplit("", "")
	For $i = 1 To $aTypes[0]
		Local $attrib = FileGetAttrib($BPMRTLocation)
		If @error Then
			Return
		Else
			If StringInStr($attrib, "D") Then
				If $aTypes[$i] <> "" Then
					If $aTypes[$i] = "INI" Or _
							$aTypes[$i] = "CFG" Or _
							$aTypes[$i] = "CONF" Or _
							$aTypes[$i] = "DAT" Then
						$aFilesTemp = _FindPathName($BPMRTLocation, "*." & $aTypes[$i])
					Else
						$aFilesTemp = _FindPathName($BPMRTLocation, $aTypes[$i])
					EndIf
				EndIf
				_ArrayDelete($aFilesTemp, 0)
				_ArrayConcatenate($aFilesConst, $aFilesTemp)
			EndIf
		EndIf
	Next
	Return $aFilesConst
EndFunc   ;==>_Concatenate

Func RGB2BGR($iColor)
	Return BitAND(BitShift(String(Binary($iColor)), 8), 0xFFFFFF)
EndFunc   ;==>RGB2BGR
#cs
	Func _SetItemX($ItemHandle)
	;ConsoleWrite("A=" & $ItemHandle & ", Level=" & _get_level() & ", _GUICtrlTreeView_GetSelection($treeview)=" & _GUICtrlTreeView_GetSelection($treeview) & @LF)
	Local $get = _get_level()
	Switch $get
	Case 1 ;Key
	;_GUICtrlTreeView_EndEdit($treeview)
	Case 2 ;Section
	Case 3 ;Value
	;GUISetState(@SW_SHOW, $SGUI2)
	EndSwitch
	EndFunc   ;==>_SetItemX
#ce