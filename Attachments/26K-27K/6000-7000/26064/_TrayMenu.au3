#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6


#cs
	User Calltips:
	_TrayMenu_SetIcon( [ iconfile1 [, iconID1 [, iconfile2 [, iconID2]]]] ) Loads/Sets the specified tray icon(s).
	_TrayMenu_IconSetState( [ flag ] ) Sets the state of the tray icon(s).
	_TrayMenu_ItemCreate ( text [, menuID [, menuentry [, menuradioitem]]] ) Creates all kinds of item controls for the tray menu.
	_TrayMenu_ItemSetState ( controlID, state ) Sets the state of a tray item control.
	_TrayMenu_ItemCheck ( [ controlID [, flag]] ) Checks a tray item control.
	_TrayMenu_ItemUnCheck ( [ controlID] ) Unchecks a tray item control.
	_TrayMenu_ItemGetState ( controlID ) Gets the current state of a tray item control.
	_TrayMenu_ItemGetHandle ( controlID [, icon] ) Returns the handle of the given control ID, level or specified icon.
	_TrayMenu_ItemGetPos ( controlID ) Retrieves the position and the level of a tray item control.
	_TrayMenu_ItemDelete ( controlID ) Delete a tray item control.
	_TrayMenu_ItemRead ( controlID [, advanced] ) Reads state or text of a tray item control.
	_TrayMenu_ItemSetHeight ( controlID [, height] ) Sets height of a single tray item control.
	_TrayMenu_ItemSetSelectMode ( controlID [, select] ) Sets the behaviour of the tray item when selected / hot.
	_TrayMenu_ItemSetUserIcon ( controlID [, filename [, iconname [, fileselected [, iconselected]]]] ) Sets a user (left) icon and a selected user icon to the specified tray control.
	_TrayMenu_ItemSetMenuIcon ( controlID [, filename [, iconname [, fileselected [, iconselected]]]] ) Sets a menu (right) icon and a selected menu icon to the specified tray control.
	_TrayMenu_ItemSetIconSize ( controlID [, size1 [, size2 [, size1sel [, size2sel]]]] ) Defines the user and menu icon size for the specified item.
	_TrayMenu_ItemSetText ( controlID, text [, select] ) Sets the item text and/or the selected text of a tray item control.
	_TrayMenu_ItemSetPadding ( controlID [, padleft [, padright [, padleftsel [, padrightsel]]]] ) Sets the item text padding and/or the selected text padding of a tray item control.
	_TrayMenu_ItemSetFont ( controlID, size [, weight [, attribute [, fontname]]] ) Sets the font for a tray item control.
	_TrayMenu_ItemSetSelFont ( controlID, size [, weight [, attribute [, fontname]]] ) Sets the selected font for a tray item control.
	_TrayMenu_ItemSetColor ( controlID [, textcolor [, selected]] ) Sets the text color and the selected text color of a tray control.
	_TrayMenu_ItemSetBkColor ( controlID [, backgroundcolor [, selected]] ) Sets the background color and the selected background color of a tray control.
	_TrayMenu_ItemSetStyle ( controlID [, style [, selected]] ) Sets the style and the selected style of a tray control.
	_TrayMenu_ItemSetPic ( controlID [, image [, selected]] ) Sets a background pic (and a selected pic) to the specified item.
	_TrayMenu_PopupSetPic ( [ level [, image]] ) Sets a background pic to the specified or all level popups.
	_TrayMenu_SidebarCreate ( level [, width [, text [, orientation [, style [, color [, direction [, font [, fontsize [, attribute [, fontcolor [, trans]]]]]]]]]]] ) Creates a sidebar for the specified level.
	_TrayMenu_SidebarDelete ( level ) Deletes the sidebar for the specified level.
	_TrayMenu_GetHotItem ( level ) Retrieves the currently selected / hot item in the specified level.
	_TrayMenu_GetHotItemLast ( ) Retrieves the last selected / hot item.
	_TrayMenu_ItemIsHot ( controlID ) Checks if control is currently selected / hot.
	_TrayMenu_LevelIsHot ( level ) Checks if any item in the specified level is selected / hot.
	_TrayMenu_LevelIsOpened ( level ) Checks if specified menu level is currently open.
	_TrayMenu_SetToolTip ( [text] ) (Re)Sets the tooltip text for the tray icon.
	_TrayMenu_Tip ( "title", "text", timeout [, option] ) Displays a balloon tip from the Tray Icon. (2000/XP only).
	_TrayMenu_SetDefault ( ) Sets all _TrayMenu options and settings to the defaults.
	_TrayMenu_SetClick ( flag ) Sets the clickmode of the tray icon - what mouseclicks will display the tray menu.
	_TrayMenu_SetCheckMode ( [ check auto state [, radio auto state ]] ) Changes behaviour of checked items or radio items.
	_TrayMenu_SetSelectMode ( [ mode ] ) Sets the behaviour of selected / hot items for one or all menu levels.
	_TrayMenu_SetIconSize ( [ level [, size1 [, size2 ]]] ) Sets the default icon sizes for the icons of one or all menu levels.
	_TrayMenu_SetPadding ( [ level [, padleft [, padright [, padleftsel [, padrightsel]]]]] ) Sets the item text padding and/or the selected text padding of one or all tray menu levels.
	_TrayMenu_SetFont ( [ level [, size [, weight [, attribute [, fontname]]]]] ) (Re)sets the font for one or all menu levels.
	_TrayMenu_SetSelFont ( [ level [, size [, weight [, attribute [, fontname]]]]] ) (Re)sets the selected font for one or all menu levels.
	_TrayMenu_SetColor ( [ level [, textcolor [, selected]]] ) (Re)sets the text color for one or all menu levels.
	_TrayMenu_SetBkColor ([ level [, backgroundcolor [, selected]] ) (Re)sets the background color and the selected background color of all tray controls in one or all menu levels.
	_TrayMenu_SetStyle ( [ level [, style [, selected]]] ) (Re)sets the style and the selected style of all tray controls in one or all menu levels.
	_TrayMenu_SetItemSize ( [ level [, $width [, $height [, $blank]]]] ) Changes default size of the items in one or all menu levels to be assigned to an item on creation.
	_TrayMenu_SetCheckMark ( filename [, iconname [, fileselected [, iconselected]]] ) Sets the default check mark and the selected check mark icon to be assigned to an item on creation.
	_TrayMenu_SetIndeterminateMark ( filename [, iconname [, fileselected [, iconselected]]] ) Sets the default indeterminate mark and the selected indeterminate mark icon to be assigned to an item on creation.
	_TrayMenu_SetRadioMark ( filename [, iconname [, fileselected [, iconselected [, flag]]]] ) Sets the default radio mark and the selected radio mark icon to be assigned to an item on creation.
	_TrayMenu_SetMenuMark ( filename [, iconname [, fileselected [, iconselected [, flag]]]] ) Sets the default menu mark and the selected menu mark icon to be assigned to an item on creation.
	_TrayMenu_PopupSetDelay ( [ open [, close]] ) Sets open and close delay for the (higher level) tray popup windows.
	_TrayMenu_PopupSetColor ( [ open [, color]] ) Sets background color for all or specified tray popup window(s).
	_TrayMenu_PopupSetTrans ( [ open [, trans] ) Sets transparency for all or specified tray popup window(s).
	_TrayMenu_ShadowShow ( [ level [, show]] ) Determines wether to show shadow of specified or all menu levels.
	_TrayMenu_ShadowSetColor ( [ level [, color]] ) Sets the shadow color of specified or all menu levels.
	_TrayMenu_ShadowSetTrans ( [ level [, trans]] ) Sets the shadow transparency of specified or all menu levels.
	_TrayMenu_Delete ( )
#ce

#cs
	;#=#INDEX#============================================================================================================================#
	;#	Title .........: _TrayMenu.au3
	;#	Description ...: Advanced Tray Menu Functions.
	;#	Date ..........: 14.12.08
	;#	Version .......: 0.91 - added side menu bar with rotated text and color gradient -
	;#	History .......: 0.9 - 12.12.08 - first release - 53 downloads
	;#	Author ........: jennico (jennicoattminusonlinedotde)  ©  2008 by jennico
	;#  AutoIt Version : written in v 3.2.12.1, upwards compatible ( no includes; will work forever )
	;#  Remarks .......: _TrayMenu.au3 UDF is designed to replace the standard tray functions.
	;#					 ------
	;#					 It provides the utmost freedom in individualizing the tray menu.
	;#					 The tray menu imitates nearly perfectly the standard menu. It uses the same GUI styles, shadows and delays. The main functions equal their corresponding origins.
	;#					 Sizes, fonts, colors, backgrounds (pictures), icons, behaviour, side and title bars can be individualized as well as the standard settings.
	;#					 The reaction on mouse hover events can be randomly designed.
	;#					 ------
	;#					 When _TrayMenu.au3 is used, the standard AutoIt tray functions and options MUST NOT be used at all.
	;#					 _TrayMenu.au3 has no default icon, no default menu and no default traytip. All this has to be defined.
	;#					 ------
	;#					 Unlike standard functions, there is no need to differenciate between items and menuitems. There is only _TrayMenu_ItemCreate.
	;#					 If a newly created item backreferences to a previous item, this item automatically becomes a menuitem and a new level is created.
	;#					 ------
	;#					 The control IDs of the items are used like common control IDs. The events can be caught by GUICtrlSetOnEvent or GUIGetMsg. @GUI_CTRLID instead of @TRAY_ID will be returned.
	;#					 For instance, there can be set a tooltip for every single item (GUICtrlSetToolTip).
	;#					 If needed the windows (menu) handle and the control handle can be retrieved with @GUI_WINHANDLE or @GUI_CTRLHANDLE.
	;#					 ------
	;#					 Unlike standard tray menu, events from separators and menuitem can be retrieved, too.
	;#					 Menuitems can be checked and can even be created as radioitems.
	;#					 ------
	;#					 This UDF will be converted to replace also standard context and sys menus in future.
	;#					 ------
	;#	Limitations ...: The following current limitations are due to the construction progress and will be removed during development.
	;#					 - only one tray icon per instance supported.
	;#					 - only two menu levels entirely supported.
	;#					 - text padding to be working with pixels not spaces.
	;#					 - control icons only very basic. need better GDI coding.
	;#					 - some functions not completely tested.
	;#					 - icon flash and similar functions to be done.
	;#					 - iconbar, titlebar to be done.
	;#					 - generally replace functions with GDI functions.
	;#	Main Functions : _TrayMenu_SetIcon( [ iconfile1 [, iconID1 [, iconfile2 [, iconID2]]]] )
	;#					 _TrayMenu_IconSetState( [ flag ] )
	;#					 _TrayMenu_ItemCreate ( text [, menuID [, menuentry [, menuradioitem]]] )
	;#					 _TrayMenu_ItemSetState ( controlID, state )
	;#					 _TrayMenu_ItemCheck ( [ controlID [, flag]] )
	;#					 _TrayMenu_ItemUnCheck ( [ controlID] )
	;#					 _TrayMenu_ItemGetState ( controlID )
	;#					 _TrayMenu_ItemGetHandle ( controlID [, icon] )
	;#					 _TrayMenu_ItemGetPos ( controlID )
	;#					 _TrayMenu_ItemDelete ( controlID )
	;#					 _TrayMenu_ItemRead ( controlID [, advanced] )
	;#					 _TrayMenu_ItemSetHeight ( controlID [, height] )
	;#					 _TrayMenu_ItemSetSelectMode ( controlID [, select] )
	;#					 _TrayMenu_ItemSetUserIcon ( controlID [, filename [, iconname [, fileselected [, iconselected]]]] )
	;#					 _TrayMenu_ItemSetMenuIcon ( controlID [, filename [, iconname [, fileselected [, iconselected]]]] )
	;#					 _TrayMenu_ItemSetIconSize ( controlID [, size1 [, size2 [, size1sel [, size2sel]]]] )
	;#					 _TrayMenu_ItemSetText ( controlID, text [, select] )
	;#					 _TrayMenu_ItemSetPadding ( controlID [, padleft [, padright [, padleftsel [, padrightsel]]]] )
	;#					 _TrayMenu_ItemSetFont ( controlID, size [, weight [, attribute [, fontname]]] )
	;#					 _TrayMenu_ItemSetSelFont ( controlID, size [, weight [, attribute [, fontname]]] )
	;#					 _TrayMenu_ItemSetColor ( controlID [, textcolor [, selected]] )
	;#					 _TrayMenu_ItemSetBkColor ( controlID [, backgroundcolor [, selected]] )
	;#					 _TrayMenu_ItemSetStyle ( controlID [, style [, selected]] )
	;#					 _TrayMenu_ItemSetPic ( controlID [, image [, selected]] )
	;#					 _TrayMenu_PopupSetPic ( [ level [, image]] )
	;#					 _TrayMenu_SidebarCreate ( level [, width [, text [, orientation [, style [, color [, direction [, font [, fontsize [, attribute [, fontcolor [, trans]]]]]]]]]]] )
	;#					 _TrayMenu_SidebarDelete ( level )
	;#					 _TrayMenu_GetHotItem ( level )
	;#					 _TrayMenu_GetHotItemLast ( )
	;#					 _TrayMenu_ItemIsHot ( controlID )
	;#					 _TrayMenu_LevelIsHot ( level )
	;#					 _TrayMenu_LevelIsOpened ( level )
	;#					 _TrayMenu_SetToolTip ( [text] )
	;#					 _TrayMenu_Tip ( "title", "text", timeout [, option] )
	;#	Options Section: _TrayMenu_SetDefault ( )
	;#					 _TrayMenu_SetClick ( flag )
	;#					 _TrayMenu_SetCheckMode ( [ check auto state [, radio auto state ]] )
	;#					 _TrayMenu_SetSelectMode ( [ mode ] )
	;#					 _TrayMenu_SetIconSize ( [ level [, size1 [, size2 ]]] )
	;#					 _TrayMenu_SetPadding ( [ level [, padleft [, padright [, padleftsel [, padrightsel]]]]] )
	;#					 _TrayMenu_SetFont ( [ level [, size [, weight [, attribute [, fontname]]]]] )
	;#					 _TrayMenu_SetSelFont ( [ level [, size [, weight [, attribute [, fontname]]]]] )
	;#					 _TrayMenu_SetColor ( [ level [, textcolor [, selected]]] )
	;#					 _TrayMenu_SetBkColor ( [ level [, backgroundcolor [, selected]] )
	;#					 _TrayMenu_SetStyle ( [ level [, style [, selected]]] )
	;#					 _TrayMenu_SetItemSize ( [ level [, $width [, $height [, $blank]]]] )
	;#					 _TrayMenu_SetCheckMark ( filename [, iconname [, fileselected [, iconselected]]] )
	;#					 _TrayMenu_SetIndeterminateMark ( filename [, iconname [, fileselected [, iconselected]]] )
	;#					 _TrayMenu_SetRadioMark ( filename [, iconname [, fileselected [, iconselected [, flag]]]] )
	;#					 _TrayMenu_SetMenuMark ( filename [, iconname [, fileselected [, iconselected [, flag]]]] )
	;#					 _TrayMenu_PopupSetDelay ( [ open [, close]] )
	;#					 _TrayMenu_PopupSetColor ( [ open [, color]] )
	;#					 _TrayMenu_PopupSetTrans ( [ open [, trans] )
	;#					 _TrayMenu_ShadowShow ( [ level [, show]] )
	;#					 _TrayMenu_ShadowSetColor ( [ level [, color]] )
	;#					 _TrayMenu_ShadowSetTrans ( [ level [, trans]] )
	;#					 _TrayMenu_Delete ( ) Deletes entire tray menu.
	;#	Internal ......: __TM_Main ( $hWnd, $Msg, $iIDTimer, $dwTime ) Main timer called function.
	;#					 __TM_ItemNotify ( $hRef ) Retrieves control on hover or click event.
	;#					 __TM_Select ( $t ) Selects item.
	;#					 __TM_Deselect ( $t ) Deselects item.
	;#					 __TM_Radio ( $t ) Deselects radioitem.
	;#					 __TM_IconSetImage ( $hWnd, $hctrl, $img, $nmr, $size ) Sets image to icon.
	;#					 __TM_Show_1st ( ) Opens first level popup.
	;#					 __TM_Show ( $hRef [, $timeout]) Opens higher level popups.
	;#					 __TM_Hide ( $hRef [, $timeout]) Closes single higher level popups.
	;#					 __TM_Hide_all ( ) Closes all popups.
	;#					 __TM_Redim_Win ( $n ) Redims window properties.
	;#					 __TM_Redim_Item_1 ( $n ) Redims item properties.
	;#					 __TM_Redim_Item_2 ( $m ) Redims item properties.
	;#					 __TM_Measure_Item ( $hRef, $hCnt ) Measures items according to max text length and height.
	;#					 __TM_Resize_Win ( $hRef [, $mode] ) Calculates the popup size according to all its menu entries sizes and reorders the controls.
	;#					 __TM_Create_Sidebar ( $s_ID, $iW, $nText, $iAngle, $pos, $gradcolor, $idirection, $nFontName, $nFontSize, $iStyle, $ifontcolor, $ialpha [, $mode] ) Creates sidebar.
	;#					 __TM_Resize ( $x ) Resizes level.
	;#					 __TM_Shadow ( $x ) Creates the popups' shadows.
	;#					 __TM_Pad ( $txt, $x, $y ) Left and right pads given text.
	;#					 __TM_SetFont ( $i, $size, $width, $attr, $name ) Sets font for a given level.
	;#					 __TM_SetSelFont ( $i, $size, $width, $attr, $name ) Sets selected font for a given level.
	;#					 __TM_SetOnEvent ( $x ) Determines which action opens tray menu.
	;#					 __TM_GetPos ( $x ) Retrieves item position.
	;#					 __TM_GetMenu ( $x ) Retrieves level from menu / item ID.
	;#					 __TM_DLLStructSetData ( $x, $y, $w, $h ) Sets Data to rectangle structure.
	;#====================================================================================================================================#
#ce

#Region;--------------------------Includes declarations

#NoTrayIcon
#include-once
#include <winapi.au3>

#EndRegion;--------------------------Includes declarations
#Region;--------------------------Options declarations

Opt("TrayOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

;GUIRegisterMsg(0x0010,"__TM_Interrupt");	not working

#EndRegion;--------------------------Options declarations
#Region;--------------------------Global declarations

Global Const $TM_Size = DllStructCreate("int X;int Y")
Global Const $TM_Float = DllStructCreate("float")
Global Const $TM_Token = DllStructCreate("int Data")
Global Const $TM_Input = DllStructCreate("int Version;int Callback;int NoThread;int NoCodecs")
Global Const $TM_Rect = DllStructCreate("float X;float Y;float Width;float Height")
Global Const $TM_Int = DllStructCreate("int", DllStructGetPtr($TM_Float))
Global Const $TM_def_shdw_style = 0x80000000
Global Const $TM_def_style = 0x80400000 ;	style gui
Global Const $TM_def_ex_style = 0x80 ;	exstyle gui
Global Const $TM_border = 3 ;	gui border size

_TrayMenu_Delete()

#EndRegion;--------------------------Global declarations
#Region;--------------------------Main Functions
#Region;--------_TrayMenu_SetIcon

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetIcon( [ iconfile1 [, iconID1 [, iconfile2 [, iconID2]]]] )
	;#	Description....: Loads/Sets the specified tray icon(s).
	;# 	Parameters.....: iconfile1 = [optional] The filename of the standard icon to be displayed in the tray.
	;#					 iconID1 = [optional] Icon identifier if iconfile1 contains multiple icons.
	;#					 iconfile2 = [optional] The filename of the flash icon to be displayed in the tray.
	;#					 iconID2 = [optional] Icon identifier if iconfile2 contains multiple icons.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: Passing a positive number will reference the string equivalent icon name.
	;#  				 Passing a negative number causes 1-based "index" behaviour. Some Dll can have icon extracted just with negative numbers.
	;#					 If you specify a flash icon, then the tray icon will change instead of flashing when tray state is set to "4".
	;#	Related........: _TrayMenu_SetState
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetIcon($TM_mn_Icon_1, $TM_mn_INum_1 = 0, $TM_mn_Icon_2 = "", $TM_mn_INum_2 = 0)
	Local $ret = TraySetIcon($TM_mn_Icon_1, $TM_mn_INum_1)
	TraySetToolTip(Chr(0))
	TraySetState() ;	vielleicht nicht ?
	Return $ret
EndFunc   ;==>_TrayMenu_SetIcon

#EndRegion;--------_TrayMenu_SetIcon
#Region;--------_TrayMenu_IconSetState

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_IconSetState( [ flag ] )
	;#	Description....: Sets the state of the tray icon(s).
	;# 	Parameters.....: flag [optional] = A combination of the following:
	;#						1 = Shows the tray icon (default)
	;#						2 = Destroys/Hides the tray icon
	;#						4 = Flashes the tray icon
	;#						8 = Stops tray icon flashing
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: none
	;#	Related........: _TrayMenu_SetIcon
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_IconSetState($mode = 1)
	If $mode < 9 Then Return TraySetState($mode)
EndFunc   ;==>_TrayMenu_IconSetState

#EndRegion;--------_TrayMenu_IconSetState
#Region;--------_TrayMenu_ItemCreate

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemCreate ( text [, menuID [, menuentry [, menuradioitem]]] )
	;#	Description....: Creates all kinds of item controls for the tray menu.
	;# 	Parameters.....: text = The text of the control.
	;#					 menuID [optional] = Allows you to create a submenu from the referenced item. If equal -1 it refers to first level menu (default setting).
	;#						( DIFFERENT to the "normal" TrayCreateItem ! )
	;#					 menuentry [optional] = Allows you to define the entry number to be created. The entries are numbered starting at 0. If equal -1 it will be added 'behind' the last created entry (default setting).
	;#					 menuradioitem [optional] 0 (default) = create a normal item, 1 = create a radioitem.
	;#  Return Value ..: Success: Returns the identifier (controlID) of the new tray menuitem.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: If the 'text' parameter is a blank string ( "" ) then a separator line is created. A separator cannot have icons, but can be clicked.
	;#					 Items that open a submenu can be checked, too, and can even be radioitems.
	;#					 By default, normal checked items (not radio menuitems, not separators) will be automatically unchecked if you click them!
	;#					 To turn off this behaviour use _TrayMenu_SetCheckMode.
	;#					 Radio menuitems are automatically grouped together and these groups are separated by a separator line or a normal item which is not a radio item.
	;#					 By default, a clicked radio item will be checked automatically and all other radio items in the same group will be unchecked!
	;#					 To turn off this behaviour use _TrayMenu_SetCheckMode
	;#  				 If necessary, you will have to reactivate the parent GUI by GUISwitch afterwards.
	;#					 In some cases, you will have to define the parent GUI in GUISetState() afterwards [ GUISetState(@SW_SHOW,$parent) ].
	;#	Related........: _TrayMenu_ItemSetState, TrayMenu_ItemSetText, _TrayMenu_SetCheckMode
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemCreate($txt, $ref = -1, $count = -1, $radio = 0)
	__TM_Hide_all()
	Local $t, $m, $n
	If $ref = -1 Or $ref = "" Then
		$ref = 0
	Else
		If $ref > UBound($TM_type) - 1 Then Return
		If $TM_type[$ref] Then
			$ref = $TM_type[$ref]
		Else
			;------------------- case menuitem
			$TM_gui_cnt += 1
			$n = __TM_Redim_Win($TM_gui_cnt + 1)
			$TM_shdw_GUI[$TM_gui_cnt] = GUICreate("", 0, 0, -1000, -1000, $TM_def_shdw_style, $TM_def_ex_style);, $TM_main_GUI[0])
			$TM_main_GUI[$TM_gui_cnt] = GUICreate("", 0, 0, -1000, -1000, $TM_def_style, $TM_def_ex_style, $TM_shdw_GUI[$TM_gui_cnt])
			$TM_gui_pic[$TM_gui_cnt] = GUICtrlCreatePic("", 0, 0, 0, 0)
			GUICtrlSetState(-1, 160)
			__TM_Shadow($TM_gui_cnt)
			$TM_last[$TM_gui_cnt] = -1
			$TM_gui_def_w[$TM_gui_cnt] = $TM_Itm_def_w
			$TM_gui_def_h[$TM_gui_cnt] = $TM_Itm_def_h
			$TM_gui_def_blk[$TM_gui_cnt] = $TM_Itm_blk_h
			GUICtrlSetState($TM_MenIcon[$ref], 16)
			$TM_mn_orig[$TM_gui_cnt] = $ref
			$TM_type[$ref] = $TM_gui_cnt
			$ref = $TM_gui_cnt
		EndIf
	EndIf
	$TM_Itm_cnt[$ref] += 1
	If $TM_Itm_cnt[$ref] > $TM_Itm_max_cnt Then $TM_Itm_max_cnt = $TM_Itm_cnt[$ref]
	Dim $t = $TM_gui_cnt + 1, $n = $TM_Itm_max_cnt
	ReDim $TM_Itm[$t][$n], $TM_Itm_top[$t][$n], $TM_Itm_bot[$t][$n]
	$t = $TM_Itm_cnt[$ref] - 1
	GUISwitch($TM_main_GUI[$ref])
	If $txt Then
		$TM_Itm[$ref][$t] = GUICtrlCreateLabel(__TM_Pad($txt, $TM_pad_le, $TM_pad_ri), 0, 0, -1, -1, 512);$SS_CENTERIMAGE
		GUICtrlSetFont(-1, $TM_ft_size, $TM_ft_width, $TM_ft_attr, $TM_ft)
		GUICtrlSetBkColor(-1, $TM_col_it_bk)
		GUICtrlSetColor(-1, $TM_col_it_ft);	GUICtrlSetState(-1, 2048)
		$TM_Itm_top[$ref][$t] = GUICtrlCreateDummy()
		$TM_Itm_bot[$ref][$t] = GUICtrlCreateDummy();icon?
		$n = __TM_Redim_Item_1($TM_Itm[$ref][$t] + 1)
		If $radio <> 0 Then
			;------------------- case radioitem
			$TM_usr_icn[$n] = $TM_def_radio_Icon
			$TM_usr_inm[$n] = $TM_def_radio_INum
			$TM_usr_icn_2nd[$n] = $TM_def_radio_Icon_2nd
			$TM_usr_inm_2nd[$n] = $TM_def_radio_INum_2nd
			$TM_type[$n] = -1
		Else
			$TM_usr_icn[$n] = $TM_def_check_Icon
			$TM_usr_inm[$n] = $TM_def_check_INum
			$TM_usr_icn_2nd[$n] = $TM_def_check_Icon_2nd
			$TM_usr_inm_2nd[$n] = $TM_def_check_INum_2nd
		EndIf
		$TM_men_icn[$n] = $TM_def_men_Icon
		$TM_men_inm[$n] = $TM_def_men_INum
		$TM_men_icn_2nd[$n] = $TM_def_men_Icon_2nd
		$TM_men_inm_2nd[$n] = $TM_def_men_INum_2nd
		$TM_UsrIcon[$n] = GUICtrlCreateIcon($TM_usr_icn[$n], $TM_usr_inm[$n], 0, 0)
		GUICtrlSetState(-1, 160)
		$TM_MenIcon[$n] = GUICtrlCreateIcon($TM_men_icn[$n], $TM_men_inm[$n], 0, 0)
		GUICtrlSetState(-1, 160)
		;	$TM_Itm_height[$n] = $TM_gui_def_h[$ref];$TM_Itm_h;
		$TM_Itm_height[$n] = $TM_Itm_h;
		$TM_Itm_height[$n] = __TM_Measure_Item($ref, $t)
	Else
		;------------------- case separator
		$TM_Itm_top[$ref][$t] = GUICtrlCreateLabel("", 0, 0);0x04000000); $WS_CLIPSIBLINGS))
		GUICtrlSetBkColor(-1, $TM_col_it_bk_top);GUICtrlSetResizing(-1, 546)
		GUICtrlSetState(-1, 128)
		$TM_Itm_bot[$ref][$t] = GUICtrlCreateLabel("", 0, 0)
		GUICtrlSetBkColor(-1, $TM_col_it_bk_bot)
		GUICtrlSetState(-1, 128)
		$TM_Itm[$ref][$t] = GUICtrlCreateLabel("", 0, 0)
		GUICtrlSetBkColor(-1, $TM_col_it_bk);GUICtrlSetState(-1, 2048)
		$n = __TM_Redim_Item_1($TM_Itm[$ref][$t] + 1)
		;	$TM_Itm_height[$n] = $TM_gui_def_blk[$ref];$TM_Itm_blk_h;
		$TM_Itm_height[$n] = $TM_Itm_blk_h;
		$TM_UsrIcon[$n] = GUICtrlCreateDummy()
		$TM_MenIcon[$n] = GUICtrlCreateDummy();type=-2
	EndIf
	__TM_Redim_Item_2($n + 1)
	ReDim $TM_IsIcon[$TM_MenIcon[$TM_Itm[$ref][$t]] + 1]
	If $count < 0 Or $count > $t Then
		$count = $t
	Else
		;------------------- case menuentry
		Local $temp[6] = [$n, $TM_Itm_top[$ref][$t], $TM_Itm_bot[$ref][$t], $TM_type[$n], $TM_UsrIcon[$n], $TM_MenIcon[$n]]
		For $i = $t - 1 To $count Step -1
			$TM_Itm[$ref][$i + 1] = $TM_Itm[$ref][$i]
			$TM_Itm_top[$ref][$i + 1] = $TM_Itm_top[$ref][$i]
			$TM_Itm_bot[$ref][$i + 1] = $TM_Itm_bot[$ref][$i]
			$TM_type[$TM_Itm[$ref][$i + 1]] = $TM_type[$TM_Itm[$ref][$i]]
			$TM_UsrIcon[$TM_Itm[$ref][$i + 1]] = $TM_UsrIcon[$TM_Itm[$ref][$i]]
			$TM_MenIcon[$TM_Itm[$ref][$i + 1]] = $TM_MenIcon[$TM_Itm[$ref][$i]]
			$TM_IsChecked[$TM_Itm[$ref][$i + 1]] = $TM_IsChecked[$TM_Itm[$ref][$i]]
			$TM_origin[$TM_Itm[$ref][$i + 1]] = $ref & "," & $i + 1
			$TM_IsIcon[$TM_UsrIcon[$TM_Itm[$ref][$i]]] += 1
			$TM_IsIcon[$TM_MenIcon[$TM_Itm[$ref][$i]]] += 1
		Next
		$TM_Itm[$ref][$count] = $temp[0]
		$TM_Itm_top[$ref][$count] = $temp[1]
		$TM_Itm_bot[$ref][$count] = $temp[2]
		$TM_type[$TM_Itm[$ref][$count]] = $temp[3]
		$TM_UsrIcon[$TM_Itm[$ref][$count]] = $temp[4]
		$TM_MenIcon[$TM_Itm[$ref][$count]] = $temp[5]
		$TM_IsChecked[$TM_Itm[$ref][$count]] = ""
		$temp = ""
	EndIf
	$t = $TM_Itm[$ref][$count]
	$TM_last_created = $ref & "," & $count
	$TM_origin[$t] = $TM_last_created
	$TM_IsIcon[$TM_UsrIcon[$t]] = $count + 1
	$TM_IsIcon[$TM_MenIcon[$t]] = $count + 1
	$TM_itm_ft_col_2nd[$t] = $TM_col_it_ft_2nd
	$TM_itm_bk_col_2nd[$t] = $TM_col_it_bk_2nd
	$TM_usr_icn_sz_2nd[$t] = $TM_def_usr_ISz
	$TM_men_icn_sz_2nd[$t] = $TM_def_men_ISz
	$TM_itm_pad_l_2nd[$t] = $TM_pad_le_2nd
	$TM_itm_pad_r_2nd[$t] = $TM_pad_ri_2nd
	$TM_itm_ft_width[$t] = $TM_ft_width
	$TM_usr_icn_sz[$t] = $TM_def_usr_ISz
	$TM_men_icn_sz[$t] = $TM_def_men_ISz
	$TM_itm_ft_col[$t] = $TM_col_it_ft
	$TM_itm_bk_col[$t] = $TM_col_it_bk
	$TM_itm_ft_attr[$t] = $TM_ft_attr
	$TM_itm_ft_size[$t] = $TM_ft_size
	$TM_itm_sel[$t] = $TM_Select_Mode
	$TM_itm_pad_l[$t] = $TM_pad_le
	$TM_itm_pad_r[$t] = $TM_pad_ri
	$TM_itm_txt_2nd[$t] = $txt
	$TM_itm_ft[$t] = $TM_ft
	$TM_itm_txt[$t] = $txt
	$TM_itm_pic[$t] = GUICtrlCreatePic($TM_itm_img[$t], 0, 0, 0, 0)
	GUICtrlSetState(-1, 160)
	__TM_Resize_Win($ref)
	Return $t
EndFunc   ;==>_TrayMenu_ItemCreate

#EndRegion;--------_TrayMenu_ItemCreate
#Region;--------_TrayMenu_ItemSetState

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetState ( controlID, state )
	;#	Description....: Sets the state of a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 state = See the State table below.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: No Change = 0
	;#					 $GUI_CHECKED = 1 Menuitem will be checked (not separator)
	;#					 $GUI_INDETERMINATE = 2 Menuitem will be set to indeterminate (not separator)(for radioitems same as checked)
	;#					 $GUI_UNCHECKED = 4 Menuitem will be unchecked (not separator)
	;#					 $GUI_SHOW = 16 Menuitem will be shown
	;#					 $GUI_HIDE = 32 Menuitem will be hidden
	;#					 $GUI_ENABLE = 64 Menuitem will be enabled
	;#					 $GUI_DISABLE = 128 Menuitem will be greyed out
	;#					 $GUI_FOCUS = 256 Menuitem will be selected
	;#					 $GUI_DEFBUTTON = 512 Menuitem will be set as default menuitem
	;#					 $GUI_NOFOCUS = 8192
	;#					 State values can be summed up as for example $GUI_CHECKED + $GUI_DEFBUTTON sets the menuitem in an checked and default state.
	;#					 To reset/delete the $GUI_DEFBUTTON-state for a menuitem just use this function on the item with another state, for instance with $GUI_ENABLE.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemGetState
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetState($s_ID, $state)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If $state >= 8192 Then
		;to be done
		$state -= 8192
	EndIf
	If $state >= 512 Then ;	funktion checken
		;	$TRAY_DEFAULT 512 Menuitem will be set as default menuitem
		;	$TM_itm_pad_l = Round($TM_itm_pad_l)
		GUICtrlSetData($s_ID, __TM_Pad($TM_itm_txt[$s_ID], $TM_itm_pad_l[$s_ID], $TM_itm_pad_r[$s_ID]))
		_TrayMenu_ItemSetFont($s_ID, "", 1000)
		__TM_Resize($x)
		$state -= 512 ;	indiv font
	EndIf
	If $state >= 256 Then
		;to be done
		$state -= 256
	EndIf
	If $state >= 128 Then
		GUICtrlSetState($s_ID, 128)
		$state -= 128
	EndIf
	If $state >= 64 Then
		GUICtrlSetState($s_ID, 64)
		$state -= 64
	EndIf
	If $state >= 32 Then
		GUICtrlSetState($TM_Itm_bot[$x[1]][$x[2]], 32)
		GUICtrlSetState($TM_Itm_top[$x[1]][$x[2]], 32)
		GUICtrlSetState($TM_MenIcon[$s_ID], 32)
		GUICtrlSetState($TM_UsrIcon[$s_ID], 32)
		GUICtrlSetState($s_ID, 32)
		$state -= 32
	EndIf
	If $state >= 16 Then
		GUICtrlSetState($TM_Itm_bot[$x[1]][$x[2]], 16)
		GUICtrlSetState($TM_Itm_top[$x[1]][$x[2]], 16)
		GUICtrlSetState($TM_MenIcon[$s_ID], 16)
		GUICtrlSetState($TM_UsrIcon[$s_ID], 16)
		GUICtrlSetState($s_ID, 16)
		$state -= 16
	EndIf
	If $state >= 4 Then
		$TM_IsChecked[$s_ID] = 0
		GUICtrlSetState($TM_UsrIcon[$s_ID], 32)
		$state -= 4
	EndIf
	If $state > 0 Then _TrayMenu_ItemCheck($s_ID, $state - 1)
	Return 1
EndFunc   ;==>_TrayMenu_ItemSetState

#EndRegion;--------_TrayMenu_ItemSetState
#Region;--------_TrayMenu_ItemCheck

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemCheck ( [ controlID [, flag]] )
	;#	Description....: Checks a tray item control.
	;# 	Parameters.....: controlID [optional] = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 flag [optional] = if not radioitem, flag <> 0 will check the item indeterminate (grey check mark).
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: Tray menus can be checked, too.
	;#					 _TrayMenu_ItemCheck() or _TrayMenu_ItemCheck(-1) specifies the last created item.
	;#	Related........: _TrayMenu_ItemGetState
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemCheck($s_ID = -1, $flag = 0)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If GUICtrlRead($s_ID) = "" Then Return
	If $TM_type[$s_ID] > -1 Then
		If $flag Then
			$TM_usr_icn[$s_ID] = $TM_def_indt_Icon
			$TM_usr_inm[$s_ID] = $TM_def_indt_INum
			$TM_usr_icn_2nd[$s_ID] = $TM_def_indt_Icon_2nd
			$TM_usr_inm_2nd[$s_ID] = $TM_def_indt_INum_2nd
		Else
			$TM_usr_icn[$s_ID] = $TM_def_check_Icon
			$TM_usr_inm[$s_ID] = $TM_def_check_INum
			$TM_usr_icn_2nd[$s_ID] = $TM_def_check_Icon_2nd
			$TM_usr_inm_2nd[$s_ID] = $TM_def_check_INum_2nd
		EndIf
		__TM_IconSetImage($TM_main_GUI[$x[1]], $TM_UsrIcon[$s_ID], $TM_usr_icn[$s_ID], $TM_usr_inm[$s_ID], $TM_usr_icn_sz[$s_ID])
	EndIf
	GUICtrlSetState($TM_UsrIcon[$s_ID], 16)
	$TM_IsChecked[$s_ID] = 1 + ($flag = 1)
	Return 1
EndFunc   ;==>_TrayMenu_ItemCheck

#EndRegion;--------_TrayMenu_ItemCheck
#Region;--------_TrayMenu_ItemUnCheck

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemUnCheck ( [ controlID] )
	;#	Description....: Unchecks a tray item control.
	;# 	Parameters.....: controlID [optional] = The control identifier (controlID) as returned by a TrayCreateItem  function.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: _TrayMenu_ItemUnCheck() or _TrayMenu_ItemUnCheck(-1) specifies the last created item.
	;#	Related........: _TrayMenu_ItemGetState
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemUnCheck($s_ID = -1)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	GUICtrlSetState($TM_UsrIcon[$s_ID], 32)
	$TM_IsChecked[$s_ID] = 0
	Return 1
EndFunc   ;==>_TrayMenu_ItemUnCheck

#EndRegion;--------_TrayMenu_ItemUnCheck
#Region;--------_TrayMenu_ItemGetState

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemGetState ( controlID )
	;#	Description....: Gets the current state of a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#  Return Value ..: Success: Returns the state. See _TrayMenu_ItemSetState for values.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: This function returns ONLY the state of a control checked/unchecked/indeterminate/enabled/disabled/hidden/shown.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemSetState, _TrayMenu_ItemRead
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemGetState($s_ID)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	Return GUICtrlGetState($s_ID) + $TM_IsChecked[$s_ID] + 3 * ($TM_IsChecked[$s_ID] = 0)
EndFunc   ;==>_TrayMenu_ItemGetState

#EndRegion;--------_TrayMenu_ItemGetState
#Region;--------_TrayMenu_ItemGetHandle

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemGetHandle ( controlID [, icon] )
	;#	Description....: Returns the handle of the given control ID, level or specified icon.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 icon = [optional] 0 specifies menu (left) icon, 1 specifies menu (right) icon, -1 will return the GUI handle of the level of the specified item.
	;#  Return Value ..: Success: Returns the handle of the given control ID, level or icon.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 10.12.08
	;#  Remarks .......: The menu levels are numbered on creation from 0 (first level) upwards. Use this number to obtain the level (GUI) handle.
	;#					 The level number can be retrieved by _TrayMenu_ItemGetPos.
	;#					 Alternatively, you can achieve the level handle by passing the controlID of an item situated in the level, and set icon to -1.
	;#	Related........: _TrayMenu_ItemGetPos
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemGetHandle($s_ID, $icon = -2)
	If $s_ID <= $TM_gui_cnt And $s_ID > -1 Then Return WinGetHandle($TM_main_GUI[$s_ID])
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	If $icon = -1 Then Return WinGetHandle($TM_main_GUI[$x[1]])
	If $icon = 0 Then Return GUICtrlGetHandle($TM_UsrIcon[$TM_Itm[$x[1]][$x[2]]])
	If $icon = 0 Then Return GUICtrlGetHandle($TM_MenIcon[$TM_Itm[$x[1]][$x[2]]])
	Return GUICtrlGetHandle($TM_Itm[$x[1]][$x[2]])
EndFunc   ;==>_TrayMenu_ItemGetHandle

#EndRegion;--------_TrayMenu_ItemGetHandle
#Region;--------_TrayMenu_ItemGetPos

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemGetPos ( controlID )
	;#	Description....: Retrieves the position and the level of a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#  Return Value ..: Success: Returns the position (0 based) of the control within the level. @extended returns the level number (0 is main level).
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 10.12.08
	;#  Remarks .......: none.
	;#	Related........: _TrayMenu_ItemGetHandle
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemGetPos($s_ID)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	Return GUICtrlGetState($s_ID) + $TM_IsChecked[$s_ID] + 3 * ($TM_IsChecked[$s_ID] = 0)
EndFunc   ;==>_TrayMenu_ItemGetPos

#EndRegion;--------_TrayMenu_ItemGetPos
#Region;--------_TrayMenu_ItemDelete

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemDelete ( controlID )
	;#	Description....: Delete a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemCreate
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemDelete($s_ID)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	Local $pos = ControlGetPos($TM_main_GUI[$x[1]], "", $s_ID)
	If @error Then Return
	__TM_Hide_all()
	If $TM_Itm_bot[$x[1]][$x[2]] Then GUICtrlDelete($TM_Itm_bot[$x[1]][$x[2]])
	If $TM_Itm_top[$x[1]][$x[2]] Then GUICtrlDelete($TM_Itm_top[$x[1]][$x[2]])
	If $TM_MenIcon[$s_ID] Then GUICtrlDelete($TM_MenIcon[$s_ID])
	If $TM_UsrIcon[$s_ID] Then GUICtrlDelete($TM_UsrIcon[$s_ID])
	GUICtrlDelete($TM_itm_pic[$s_ID])
	$TM_Itm_w[$x[1]] = $TM_Itm_def_w
	GUICtrlDelete($s_ID)
	For $i = 0 To $TM_Itm_cnt[$x[1]] - 2
		If $i >= $x[2] Then
			$TM_Itm[$x[1]][$i] = $TM_Itm[$x[1]][$i + 1]
			$TM_IsChecked[$TM_Itm[$x[1]][$i]] = $TM_IsChecked[$TM_Itm[$x[1]][$i + 1]]
			$TM_MenIcon[$TM_Itm[$x[1]][$i]] = $TM_MenIcon[$TM_Itm[$x[1]][$i + 1]];?
			$TM_UsrIcon[$TM_Itm[$x[1]][$i]] = $TM_UsrIcon[$TM_Itm[$x[1]][$i + 1]];?
			$TM_type[$TM_Itm[$x[1]][$i]] = $TM_type[$TM_Itm[$x[1]][$i + 1]]
			$TM_Itm_top[$x[1]][$i] = $TM_Itm_top[$x[1]][$i + 1]
			$TM_Itm_bot[$x[1]][$i] = $TM_Itm_bot[$x[1]][$i + 1]
			$TM_origin[$TM_Itm[$x[1]][$i]] = $x[1] & "," & $i
			$TM_IsIcon[$TM_UsrIcon[$TM_Itm[$x[1]][$i]]] -= 1
			$TM_IsIcon[$TM_MenIcon[$TM_Itm[$x[1]][$i]]] -= 1
		EndIf
		__TM_Measure_Item($x[1], $i)
	Next
	;	$TM_gui_h[$x[1]] -= $pos[3]
	$TM_Itm_cnt[$x[1]] -= 1
	__TM_Resize_Win($x[1])
	Return 1
EndFunc   ;==>_TrayMenu_ItemDelete

#EndRegion;--------_TrayMenu_ItemDelete
#Region;--------_TrayMenu_ItemRead

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemRead ( controlID [, advanced] )
	;#	Description....: Reads state or text of a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 advanced [optional] = Return extended information of a control.
	;#							0 = (Default) Returns the state of the control (see Remarks).
	;#							1 = Returns the text of a control. If defined, @extended macro contains the selected text of the control.
	;#  Return Value ..: Success: Returns state or text.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: On default, ONLY the state values ($GUI_CHECKED = 1), ($GUI_INDETERMINATE = 2) or ($GUI_UNCHECKED = 4) are returned.
	;#					 Use controlID = -1 to specify the last item created.
	;#
	;#	Related........: _TrayMenu_ItemCreate
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemRead($s_ID, $mode)
	If $mode Then Return SetExtended($TM_itm_txt_2nd[$s_ID], $TM_itm_txt[$s_ID]);StringStripWS(GUICtrlRead($s_ID), 1)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	Return $TM_IsChecked[$s_ID] + 3 * ($TM_IsChecked[$s_ID] = 0)
EndFunc   ;==>_TrayMenu_ItemRead

#EndRegion;--------_TrayMenu_ItemRead
#Region;--------_TrayMenu_ItemSetHeight

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetHeight ( controlID [, height] )
	;#	Description....: Sets height of a single tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 height [optional] = The new control height. Default is 16.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 8.12.08
	;#  Remarks .......: On default, height is fixed to 16 px, separators to 10 px. This corresponds to the default Windows menu size.
	;#					 If item is not a separator and height is set to 0, item height will automatically be adapted to fit text / font height.
	;#					 In order to set all items to the same height, refer to _TrayMenu_SetItemSize.
	;#	Related........: _TrayMenu_SetItemSize
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetHeight($s_ID, $height = 16)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$TM_gui_h[$x[1]] -= $TM_Itm_height[$TM_Itm[$x[1]][$x[2]]] + $height
	$TM_Itm_height[$TM_Itm[$x[1]][$x[2]]] = $height
	__TM_Resize_Win($x)
	Return 1
EndFunc   ;==>_TrayMenu_ItemSetHeight

#EndRegion;--------_TrayMenu_ItemSetHeight
#Region;--------_TrayMenu_ItemSetSelectMode

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetSelectMode ( controlID [, select] )
	;#	Description....: Sets the behaviour of the tray item when selected / hot.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 select [optional] = (sum of) below values (Default is 3).
	;#							0 = No reaction.
	;#							1 = selected / hot item will change text color.
	;#					 		2 = selected / hot item will change background color.
	;#							4 = selected / hot item will change user (left) icon and its size.
	;#						   	8 = selected / hot item will change menu (right) icon and its size.
	;#						   16 = selected / hot item will change font.
	;#						   32 = selected / hot item will change background pic.
	;#						   64 = selected / hot item will change text AND PADDING.
	;#						  128 = selected / hot item will change style.
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 2.12.08
	;#  Remarks .......: If not defined, every item changes color and background color (mode 3).
	;#					 The tray menu will not be resized on mouse hovering. If necessary, you will have to use fixed sizes.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_SetSelectMode, _TrayMenu_ItemSetBkColor, _TrayMenu_ItemSetColor, _TrayMenu_ItemSetFont, _TrayMenu_ItemSetText, _TrayMenu_ItemSetStyle, _TrayMenu_ItemSetIconSize, _TrayMenu_ItemSetPadding
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetSelectMode($s_ID, $mode = 3)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$TM_itm_sel[$TM_Itm[$x[1]][$x[2]]] = $mode
	Return 1
EndFunc   ;==>_TrayMenu_ItemSetSelectMode

#EndRegion;--------_TrayMenu_ItemSetSelectMode
#Region;--------_TrayMenu_ItemSetUserIcon

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetUserIcon ( controlID [, filename [, iconname [, fileselected [, iconselected]]]] )
	;#	Description....: Sets a user (left) icon and a selected user icon to the specified tray control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;# 					 filename = The filename containing the picture to be displayed.
	;#					 iconname [optional] = Icon name if filename contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 fileselected [optional] = The filename containing the picture when mouse hovers over control.
	;#					 iconselected [optional] = Icon name if fileselected contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 7.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged.
	;#					 A blank string ("") for fileselected will set the same icon for both states.
	;#					 If a selected icon is defined, don't forget to "turn on" select mode 4.
	;#					 Please observe: the transparent color of icons will be painted in the GUI BkColor. Refer to _TrayMenu_PopupSetColor
	;#					 Use _TrayMenu_ItemSetUserIcon( controlID ) to clear icon (will save system resources).
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemSetMenuIcon, _TrayMenu_ItemSetSelectMode, _TrayMenu_SetSelectMode, _TrayMenu_PopupSetColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetUserIcon($s_ID, $name1 = "", $icon1 = "", $name2 = "", $icon2 = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If GUICtrlRead($s_ID) = "" Then Return
	__TM_Hide_all()
	If $name1 & $icon1 & $name2 & $icon2 = "" Then Return GUICtrlSetState($TM_UsrIcon[$s_ID], 32)
	If $name1 <> -1 Then $TM_usr_icn[$s_ID] = $name1
	If $icon1 <> -1 Then $TM_usr_inm[$s_ID] = $icon1
	If $name2 Then
		If $name2 <> -1 Then $TM_usr_icn_2nd[$s_ID] = $name2
		If $name2 <> -1 Then $TM_usr_inm_2nd[$s_ID] = $icon2
	Else
		$TM_usr_icn_2nd[$s_ID] = $name1
		$TM_usr_inm_2nd[$s_ID] = $icon1
	EndIf
	GUICtrlSetImage($TM_UsrIcon[$s_ID], $TM_usr_icn[$s_ID], $TM_usr_inm[$s_ID])
	GUICtrlSetState($TM_UsrIcon[$s_ID], 16)
	Return 1
EndFunc   ;==>_TrayMenu_ItemSetUserIcon

#EndRegion;--------_TrayMenu_ItemSetUserIcon
#Region;--------_TrayMenu_ItemSetMenuIcon

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetMenuIcon ( controlID [, filename [, iconname [, fileselected [, iconselected]]]] )
	;#	Description....: Sets a menu (right) icon and a selected menu icon to the specified tray control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 filename = The filename containing the picture to be displayed.
	;#					 iconname [optional] = Icon name if filename contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 fileselected [optional] = The filename containing the picture when mouse hovers over control.
	;#					 iconselected [optional] = Icon name if fileselected contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 7.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged.
	;#					 A blank string ("") for fileselected will set the same icon for both states.
	;#					 If a selected icon is defined, don't forget to "turn on" select mode 8.
	;#					 Please observe: the transparent color of icons will be painted in the GUI BkColor. Refer to _TrayMenu_PopupSetColor
	;#					 Use _TrayMenu_ItemSetMenuIcon( controlID ) to clear icon (will save system resources).
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemSetUserIcon, _TrayMenu_ItemSetSelectMode, _TrayMenu_SetSelectMode, _TrayMenu_PopupSetColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetMenuIcon($s_ID, $name1, $icon1 = "", $name2 = "", $icon2 = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If GUICtrlRead($s_ID) = "" Then Return
	__TM_Hide_all()
	If $name1 & $icon1 & $name2 & $icon2 = "" Then Return GUICtrlSetState($TM_MenIcon[$s_ID], 32)
	If $name1 <> -1 Then $TM_men_icn[$s_ID] = $name1
	If $icon1 <> -1 Then $TM_men_inm[$s_ID] = $icon1
	If $name2 Then
		If $name2 <> -1 Then $TM_men_icn_2nd[$s_ID] = $name2
		If $name2 <> -1 Then $TM_men_inm_2nd[$s_ID] = $icon2
	Else
		$TM_men_icn_2nd[$s_ID] = $name1
		$TM_men_inm_2nd[$s_ID] = $icon1
	EndIf
	GUICtrlSetImage($TM_MenIcon[$s_ID], $TM_men_icn[$s_ID], $TM_men_inm[$s_ID])
	GUICtrlSetState($TM_MenIcon[$s_ID], 16)
	Return 1
EndFunc   ;==>_TrayMenu_ItemSetMenuIcon

#EndRegion;--------_TrayMenu_ItemSetMenuIcon
#Region;--------_TrayMenu_ItemSetIconSize

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetIconSize ( controlID [, size1 [, size2 [, size1sel [, size2sel]]]] )
	;#	Description....: Defines the user and menu icon size for the specified item.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 size1 [optional] = The size of the user (left) icon in pixel. Default is 12.
	;#					 size2 [optional] = The size of the menu (right) icon in pixel. Default is 12.
	;#					 size1sel [optional] = The size of the user (left) icon when hot / selected in pixel. Default is 12.
	;#					 size2sel [optional] = The size of the menu (right) icon when hot / selected in pixel. Default is 12.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 8.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged, "" (blank string) sets to the default.
	;#					 If not redefined by _TrayMenu_SetIconSize, all icons will be created in 12 x 12 px. This corresponds to the menu mark size in the "normal" tray menu.
	;#					 If selected icon sizing is supposed to be used, add select mode 4 / 8 (icons). The sizing is connected to the icons.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_SetIconSize, _TrayMenu_ItemSetUserIcon, _TrayMenu_ItemSetMenuIcon
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetIconSize($s_ID, $size1 = 12, $size2 = 12, $size1sel = 12, $size2sel = 12)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If GUICtrlRead($s_ID) = "" Then Return
	__TM_Hide_all()
	If $size1 <> -1 Then $TM_usr_icn_sz[$s_ID] = $size1
	If $size2 <> -1 Then $TM_men_icn_sz[$s_ID] = $size2
	If $size1 <> -1 Then $TM_usr_icn_sz_2nd[$s_ID] = $size1sel
	If $size2 <> -1 Then $TM_men_icn_sz_2nd[$s_ID] = $size2sel
	Local $p = ControlGetPos($TM_main_GUI[$x[1]], "", $s_ID)
	ControlMove($TM_main_GUI[$x[1]], "", $TM_UsrIcon[$s_ID], $p[0] + 2, $p[1] + ($p[3] - $TM_usr_icn_sz[$s_ID]) / 2, $TM_usr_icn_sz[$s_ID], $TM_usr_icn_sz[$s_ID])
	ControlMove($TM_main_GUI[$x[1]], "", $TM_MenIcon[$s_ID], $p[2] - $TM_men_icn_sz[$s_ID] - 2, $p[1] + ($p[3] - $TM_men_icn_sz[$s_ID]) / 2, $TM_men_icn_sz[$s_ID], $TM_men_icn_sz[$s_ID])
	Return 1
EndFunc   ;==>_TrayMenu_ItemSetIconSize

#EndRegion;--------_TrayMenu_ItemSetIconSize
#Region;--------_TrayMenu_ItemSetText

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetText ( controlID, text [, select] )
	;#	Description....: Sets the item text and/or the selected text of a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a _TrayMenue_CreateItem function.
	;#					 text = The new text of the tray item control.
	;#					 select [optional] = The text to be shown when item selected / hot.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 3.12.08
	;#  Remarks .......: Use "" (blank string) for text if only selected text shall be set without changing text.
	;#					 The popup will not be resized to diplay the selected text. If necessary, it is recommended to use a fixed size (_TrayMenu_SetItemSize).
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemCreate, _TrayMenu_ItemGetText
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetText($s_ID, $txt, $selected = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If $txt = "" Then Return
	__TM_Hide_all()
	$TM_itm_txt[$s_ID] = $txt
	If $selected Then $TM_itm_txt_2nd[$s_ID] = $selected
	$ret = GUICtrlSetData($s_ID, __TM_Pad($txt, $TM_itm_pad_l[$s_ID], $TM_itm_pad_r[$s_ID]))
	__TM_Resize($x)
	Return $ret
EndFunc   ;==>_TrayMenu_ItemSetText

#EndRegion;--------_TrayMenu_ItemSetText
#Region;--------_TrayMenu_ItemSetPadding

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetPadding ( controlID [, padleft [, padright [, padleftsel [, padrightsel]]]] )
	;#	Description....: Sets the item text padding and/or the selected text padding of a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a _TrayMenue_CreateItem function.
	;#					 padleft [optional] = The number of spaces to be added to the left of the text. Default is 5 (appr. 15 pixel).
	;#					 padright [optional] = The number of spaces to be added to the right of the text. Default is 7 (appr. 21 pixel).
	;#					 padleftsel [optional] = The number of spaces to be added to the left of the text when item is selected / hot. Default is 5 (appr. 15 pixel).
	;#					 padrightsel [optional] = The number of spaces to be added to the right of the text when item is selected / hot. Default is 7 (appr. 21 pixel).
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 10.12.08
	;#  Remarks .......: The padding is used to reserve space for check/menu marks and icons to the left and the right of the text.
	;#					 As spaces are used, the width depends of the used font. One spaces corresponds to 3 pixels in default font.
	;#					 A selected padding can be used to buffer different item or font sizes.
	;#					 If selected padding is supposed to be used, add select mode 64 (text). The padding is connected to the text.
	;#					 Does not apply to separators.
	;# 					 Use -1 to leave a parameter unchanged, "" (blank string) to set to the default.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemSetText, _TrayMenu_SetPadding
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetPadding($s_ID, $padl = 5, $padr = 7, $padls = 5, $padrs = 7)
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If $TM_itm_txt[$s_ID] = "" Then Return
	__TM_Hide_all()
	;-1 fehlt noch "" geht auch nicht
	$TM_itm_pad_l[$s_ID] = $padl
	$TM_itm_pad_r[$s_ID] = $padr
	$TM_itm_pad_l_2nd[$s_ID] = $padls
	$TM_itm_pad_r_2nd[$s_ID] = $padrs
	$ret = GUICtrlSetData($s_ID, __TM_Pad($TM_itm_txt[$s_ID], $TM_itm_pad_l[$s_ID], $TM_itm_pad_r[$s_ID]))
	__TM_Resize($x)
	Return $ret
EndFunc   ;==>_TrayMenu_ItemSetPadding

#EndRegion;--------_TrayMenu_ItemSetPadding
#Region;--------_TrayMenu_ItemSetFont

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetFont ( controlID, size [, weight [, attribute [, fontname]]] )
	;#	Description....: Sets the font for a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 size = Fontsize (default is specified in _TrayMenu_SetFont).
	;#					 weight [optional] = Font weight (default is specified in _TrayMenu_SetFont).
	;#					 attribute [optional] = Add together the values of all the styles required (2+4 = italic and underlined). Default is specified in _TrayMenu_SetFont.
	;#											2 = italic
	;#											4 = underlined
	;#											8 = strike
	;#					 fontname [optional] = The name of the font to use (default is specified in _TrayMenu_SetFont).
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: By default, controls use the font set by _TrayMenu_SetFont.
	;#					 GUICtrlSetFont could be used as well, but tray menu will not be resized then.
	;#					 Please observe: By default, the height of the items is fixed to 16 px = windows default, while the width is released (automatic).
	;#					 On changing font height, you might want to release the item height before. Do this by using _TrayMenu_SetItemSize(0,0).
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_SetFont, _TrayMenu_SetItemSize
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetFont($s_ID, $size = "", $width = "", $attr = "", $name = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	__TM_Hide_all()
	If $size = "" Then $size = $TM_ft_size
	If $width = "" Then $width = $TM_ft_width
	If $attr = "" Then $attr = $TM_ft_attr
	If $name = "" Then $name = $TM_ft
	$TM_itm_ft_width[$s_ID] = $width
	$TM_itm_ft_attr[$s_ID] = $attr
	$TM_itm_ft_size[$s_ID] = $size
	$TM_itm_ft[$s_ID] = $name
	Local $ret = GUICtrlSetFont($s_ID, $size, $width, $attr, $name)
	__TM_Resize($x)
	Return $ret
EndFunc   ;==>_TrayMenu_ItemSetFont

#EndRegion;--------_TrayMenu_ItemSetFont
#Region;--------_TrayMenu_ItemSetSelFont

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetSelFont ( controlID, size [, weight [, attribute [, fontname]]] )
	;#	Description....: Sets the selected font for a tray item control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 size = Fontsize (default is specified in _TrayMenu_SetFont).
	;#					 weight [optional] = Font weight (default is specified in _TrayMenu_SetFont).
	;#					 attribute [optional] = Add together the values of all the styles required (2+4 = italic and underlined). Default is specified in _TrayMenu_SetFont.
	;#											2 = italic
	;#											4 = underlined
	;#											8 = strike
	;#					 fontname [optional] = The name of the font to use (default is specified in _TrayMenu_SetFont).
	;#  Return Value ..: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 3.12.08
	;#  Remarks .......: By default, controls use the font set by _TrayMenu_SetFont.
	;#					 GUICtrlSetFont could be used as well, but tray menu will not be resized then.
	;#					 Please observe: By default, the height of the items is fixed to 16 px = windows default, while the width is released (automatic).
	;#					 On changing font height, you might want to release the item height before. Do this by using _TrayMenu_SetItemSize(0,0).
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_SetFont, _TrayMenu_SetItemSize
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetSelFont($s_ID, $size = "", $width = "", $attr = "", $name = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If $size = "" Then $size = $TM_ft_size
	If $width = "" Then $width = $TM_ft_width
	If $attr = "" Then $attr = $TM_ft_attr
	If $name = "" Then $name = $TM_ft
	$TM_itm_ft_width_2nd[$s_ID] = $width
	$TM_itm_ft_attr_2nd[$s_ID] = $attr
	$TM_itm_ft_size_2nd[$s_ID] = $size
	$TM_itm_ft_2nd[$s_ID] = $name
	Return 1
EndFunc   ;==>_TrayMenu_ItemSetSelFont

#EndRegion;--------_TrayMenu_ItemSetSelFont
#Region;--------_TrayMenu_ItemSetColor

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetColor ( controlID [, textcolor [, selected]] )
	;#	Description....: Sets the text color and the selected text color of a tray control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 textcolor [optional] = The RGB color to use. Default is the previously set. In the default color scheme it is 0 (black).
	;#					 selected [optional] = The RGB color to use when mouse hovers over control. Default is the previously set. In the default color scheme it is 0xFFFFFF (white).
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 30.11.08
	;#  Remarks .......: Use -1 to leave textcolor unchanged, use "" (blank string) to reset to default color scheme.
	;#					 Separator lines can be colored analogically. Textcolor is the color of the upper line, selected the color of the lower line.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemSetBkColor, _TrayMenu_SetColor, _TrayMenu_SetBkColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetColor($s_ID, $color1 = "", $color2 = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If GUICtrlRead($s_ID) Then
		If $color1 = "" Then
			$TM_itm_ft_col[$s_ID] = $TM_col_it_ft
		ElseIf $color1 > -1 Then
			$TM_itm_ft_col[$s_ID] = $color1
		EndIf
		If $color2 = "" Then
			$TM_itm_ft_col_2nd[$s_ID] = $TM_col_it_ft_2nd
		ElseIf $color2 > -1 Then
			$TM_itm_ft_col_2nd[$s_ID] = $color2
		EndIf
		Return GUICtrlSetColor($s_ID, $TM_itm_ft_col[$s_ID])
	EndIf
	If $color1 = "" Then $color1 = $TM_col_it_bk_top
	If $color2 = "" Then $color2 = $TM_col_it_bk_bot
	If $color1 > -1 Then GUICtrlSetBkColor($TM_Itm_top[$x[1]][$x[2]], $color1)
	If $color2 > -1 Then GUICtrlSetBkColor($TM_Itm_bot[$x[1]][$x[2]], $color2)
EndFunc   ;==>_TrayMenu_ItemSetColor

#EndRegion;--------_TrayMenu_ItemSetColor
#Region;--------_TrayMenu_ItemSetBkColor

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetBkColor ( controlID [, backgroundcolor [, selected]] )
	;#	Description....: Sets the background color and the selected background color of a tray control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 backgroundcolor [optional] = The RGB color to use. Default is the previously used. In the default color scheme it is -2 ($GUI_BKCOLOR_TRANSPARENT).
	;#					 selected [optional] = The RGB color to use when mouse hovers over control. Default is the previously used. In the default color scheme it is 0x0A246A (blue).
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 30.11.08
	;#  Remarks .......: Use -1 to leave backgroundcolor unchanged, use "" (blank string) to reset to default color scheme.
	;#					 Can be used for separator backgrounds as well, separators have no selected color.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_ItemSetBkColor, _TrayMenu_SetColor, _TrayMenu_SetBkColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetBkColor($s_ID, $color1 = "", $color2 = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If $color1 = "" Then
		$TM_itm_bk_col[$s_ID] = $TM_col_it_bk
	ElseIf $color1 > -1 Then
		$TM_itm_bk_col[$s_ID] = $color1
	EndIf
	If $color2 = "" Then
		$TM_itm_bk_col_2nd[$s_ID] = $TM_col_it_bk_2nd
	ElseIf $color2 > -1 Then
		$TM_itm_bk_col_2nd[$s_ID] = $color2
	EndIf
	Return GUICtrlSetColor($s_ID, $TM_itm_bk_col[$s_ID])
EndFunc   ;==>_TrayMenu_ItemSetBkColor

#EndRegion;--------_TrayMenu_ItemSetBkColor
#Region;--------_TrayMenu_ItemSetStyle

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetStyle ( controlID [, style [, selected]] )
	;#	Description....: Sets the style and the selected style of a tray control.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 style [optional] = The style to use. See state table below.
	;#					 selected [optional] = The style to use when mouse hovers over control. See state table below.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: 3 styles are allowed:
	;#						$SS_LEFT = 0 (Default)  Left aligns text.
	;#						$SS_CENTER = 1  Centers text horizontally.
	;#						$SS_RIGHT = 2  Right aligns text.
	;#  				 Use -1 to leave style unchanged, use "" (blank string) to reset to default style.
	;#					 $SS_NOTIFY and $SS_CENTERIMAGE will always be forced.
	;#					 On $SS_CENTER, keep in mind, that the text padding might prevent real symmetry (use _TrayMenu_ItemSetPadding).
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_SetStyle, _TrayMenu_ItemSetPadding, _TrayMenu_ItemSetText
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetStyle($s_ID, $style = 0, $selected = "")
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	If GUICtrlRead($s_ID) = "" Then Return
	If $style < 0 Or $style > 2 Then $style = 0
	If $selected < 0 Or $selected > 2 Then $selected = 0
	$TM_itm_style[$s_ID] = $style
	$TM_itm_style_2nd[$s_ID] = $selected
	Return GUICtrlSetStyle($s_ID, BitOR(768, $style))
EndFunc   ;==>_TrayMenu_ItemSetStyle

#EndRegion;--------_TrayMenu_ItemSetStyle
#Region;--------_TrayMenu_ItemSetPic

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemSetPic ( controlID [, image [, selected]] )
	;#	Description....: Sets a background pic (and a selected pic) to the specified item.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#					 image [optional] = The filename containing the picture to be display on the control.
	;#					 selected [optional] = The filename containing the picture to be display when mouse hovers over the control.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 4.12.08
	;#  Remarks .......: Use _TrayMenu_ItemSetPic() to remove all images from the items.
	;#					 Image will be stretched to fit the control.
	;#					 Use controlID = -1 to specify the last item created.
	;#	Related........: _TrayMenu_PopupSetPic
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemSetPic($s_ID = -2, $pic1 = "", $pic2 = "")
	__TM_Hide_all()
	Local $x = __TM_GetPos($s_ID)
	If $x[0] <> 2 Then Return
	$s_ID = $TM_Itm[$x[1]][$x[2]]
	$TM_itm_img[$s_ID] = $pic1
	$TM_itm_img_2nd[$s_ID] = $pic2
	;	Local $pos=ControlGetPos($TM_main_GUI[$x[1]],"",$s_ID);kontrollieren
	;	ControlMove($TM_main_GUI[$x[1]],"", $TM_itm_pic[$s_ID], 0, $pos[1], $pos[2],$pos[3])
	;	GUICtrlSetState($TM_itm_pic[$s_ID],144)
	Return GUICtrlSetImage($TM_itm_pic[$s_ID], $pic1)
	;C:\Programme\AutoIt3\Examples\GUI\logo4.gif
EndFunc   ;==>_TrayMenu_ItemSetPic

#EndRegion;--------_TrayMenu_ItemSetPic
#Region;--------_TrayMenu_PopupSetPic

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_PopupSetPic ( [ level [, image]] )
	;#	Description....: Sets a background pic to the specified or all level popups.
	;# 	Parameters.....: level = Specifies the menu level.
	;#							use -1 for all menu levels.
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 image [optional] = The filename containing the picture to be display on the control.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 4.12.08
	;#  Remarks .......: Use _TrayMenu_PopupSetPic() to remove all popup images.
	;#					 Image will be stretched to fit the window.
	;#	Related........: _TrayMenu_ItemSetPic
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_PopupSetPic($s_ID = -1, $Pic = "")
	;C:\Programme\AutoIt3\Examples\GUI\logo4.gif
	__TM_Hide_all()
	If $s_ID < 0 Then
		For $i = 0 To $TM_gui_cnt
			GUICtrlSetImage($TM_gui_pic[$i], $Pic)
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID > -1 Then Return GUICtrlSetImage($TM_gui_pic[$s_ID], $Pic)
EndFunc   ;==>_TrayMenu_PopupSetPic

#EndRegion;--------_TrayMenu_PopupSetPic
#Region;--------_TrayMenu_SidebarCreate

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SidebarCreate ( level [, width [, text [, orientation [, style [, color [, direction [, font [, fontsize [, attribute [, fontcolor [, trans]]]]]]]]]]] )
	;#	Description....: Creates a sidebar for the specified level.
	;# 	Parameters.....: level = Specifies the menu level. Use 0 for first menu level only. Use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 width [optional] = The width of the sidebar in px (default is 22).
	;#					 text [optional] = The text to be displayed on the sidebar. Default is blank.
	;#					 orientation [optional] = The orientation of the text. 0 = from top to bottom (default)  1 = from bottom to top.
	;#					 style [optional] = Vertical position of the text. -1 = centered,  -2 = attached to bottom of sidebar,  -3 = attached to top of sidebar,  -4 = optimal (default),  or distance to bottom in pixel.
	;#					 color [optional] = The RGB background color of the sidebar. If you pass more than one color (no limit, delimited by a pipe ("|")), a gradient will be displayed. Default is white (0xFFFFFF).
	;#					 direction [optional] = The direction of the gradient. 0 = GradientHorizontal  1 = GradientVertical (default)  2 = GradientForwardDiagonal  3 = GradientBackwardDiagonal
	;#					 font [optional] = The font to be used with the text. Default is "Arial".
	;#					 fontsize [optional] = The font size to be used with the text. Default is 12.
	;#					 attribute [optional] = Sum up values: 0 = Normal  1 = Bold (default)  2 = Italic  4 = Underline  8 - Strikethrough.
	;#					 fontcolor [optional] = The RGB font color. Default is black (0).
	;#					 trans [optional] = The font transparency, a value between 0 (invisible) and 255 (solid). Default is 255.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 13.12.08
	;#  Remarks .......: The text is always horizontally centered.
	;#					 Use "" (blank string) to skip a parameter.
	;#					 _TrayMenu_SidebarCreate "steals" the current window, you may need GUISwitch in your parent script.
	;#					 To save startup time, it is recommended to create the sidebar at last.
	;#					 To update a sidebar, re-create it.
	;#	Related........: _TrayMenu_SidebarDelete.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SidebarCreate($s_ID, $iW = 22, $nText = "", $iAngle = 0, $pos = -4, $gradcolor = 0xFFFFFF, $idirection = 1, $nFontName = "Arial", $nFontSize = 12, $iStyle = 1, $ifontcolor = 0, $ialpha = 255)
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID > -1 Then Return __TM_Create_Sidebar($s_ID, $iW, $nText, $iAngle, $pos, $gradcolor, $idirection, $nFontName, $nFontSize, $iStyle, $ifontcolor, $ialpha)
EndFunc   ;==>_TrayMenu_SidebarCreate

#EndRegion;--------_TrayMenu_SidebarCreate
#Region;--------_TrayMenu_SidebarDelete

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SidebarDelete ( level )
	;#	Description....: Deletes the sidebar for the specified level.
	;# 	Parameters.....: level = Specifies the menu level. Use 0 for first menu level only. Use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 14.12.08
	;#  Remarks .......: none.
	;#	Related........: _TrayMenu_SidebarCreate.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SidebarDelete($s_ID)
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID = -1 Then Return
	$TM_SideBar_size[$s_ID] = ""
	__TM_Resize_Win($s_ID)
	If $TM_SideBar[$s_ID] Then Return GUICtrlDelete($TM_SideBar[$s_ID])
EndFunc   ;==>_TrayMenu_SidebarDelete

#EndRegion;--------_TrayMenu_SidebarDelete

;	userbarcreate
;	menubarcreate

#Region;--------_TrayMenu_GetHotItem

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_GetHotItem ( level )
	;#	Description....: Retrieves the currently selected / hot item in the specified level.
	;# 	Parameters.....: level = specifies the menu level. Use 0 for first menu level, 1 for the second created submenu, a.s.o.
	;#  Return Value ..: Success: Returns the controlID of the hot item.
	;#					 Failure: Returns 0 if no item in the specified level is currently selected (or level is not opened).
	;#							  Returns -1 if level is not valid.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: A level has to be specified, because there can be more than one hot item (one per opened level possible).
	;#					 @extended containes the menu level entry number (from top = 0 to bottom).
	;#	Related........: _TrayMenu_GetHotItemLast
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_GetHotItem($s_ID)
	If $s_ID > $TM_gui_cnt Then Return -1
	If $TM_last[$s_ID] = -1 Then Return
	Local $x = __TM_GetPos($s_ID)
	If $x[0] = 2 Then Return SetExtended($x[2], $TM_last[$s_ID])
EndFunc   ;==>_TrayMenu_GetHotItem

#EndRegion;--------_TrayMenu_GetHotItem
#Region;--------_TrayMenu_GetHotItemLast

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_GetHotItemLast ( )
	;#	Description....: Retrieves the last selected / hot item.
	;# 	Parameters.....: none.
	;#  Return Value ..: Success: Returns the controlID of the hot item.
	;#					 Failure: Returns 0 if no item is currently selected.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: The last selected / hot item is usually ( not always ) the item the mouse is currently hovering over.
	;#  				 @extended contains the level of the last selected / hot item (0 = first level).
	;#	Related........: _TrayMenu_GetHotItem
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_GetHotItemLast()
	For $i = $TM_gui_cnt To 0 Step -1
		If $TM_last[$i] > 0 Then Return SetExtended($i, $TM_last[$i])
	Next
EndFunc   ;==>_TrayMenu_GetHotItemLast

#EndRegion;--------_TrayMenu_GetHotItemLast
#Region;--------_TrayMenu_ItemIsHot

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ItemIsHot ( controlID )
	;#	Description....: Checks if control is currently selected / hot.
	;# 	Parameters.....: controlID = The control identifier (controlID) as returned by a TrayCreateItem function.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: none.
	;#	Related........: _TrayMenu_LevelIsHot
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ItemIsHot($s_ID)
	For $i = 0 To $TM_gui_cnt
		If $TM_last[$i] = $s_ID Then Return 1
	Next
EndFunc   ;==>_TrayMenu_ItemIsHot

#EndRegion;--------_TrayMenu_ItemIsHot
#Region;--------_TrayMenu_LevelIsHot

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_LevelIsHot ( level )
	;#	Description....: Checks if any item in the specified level is selected / hot.
	;# 	Parameters.....: level = specifies the menu level. Use 0 for first menu level, 1 for the second created submenu, a.s.o.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: none.
	;#	Related........: _TrayMenu_LevelIsOpened, _TrayMenu_ItemIsHot
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_LevelIsHot($s_ID)
	If $TM_last[$s_ID] > 0 Then Return 1
EndFunc   ;==>_TrayMenu_LevelIsHot

#EndRegion;--------_TrayMenu_LevelIsHot
#Region;--------_TrayMenu_LevelIsOpened

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_LevelIsOpened ( level )
	;#	Description....: Checks if specified menu level is currently open.
	;# 	Parameters.....: level = specifies the menu level. Use 0 for first menu level, 1 for the second created submenu, a.s.o.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#					 Special error: Returns -1 if level is not valid.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: none.
	;#	Related........: _TrayMenu_LevelIsHot, _TrayMenu_ItemIsHot
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_LevelIsOpened($s_ID)
	If $s_ID > $TM_gui_cnt Or $s_ID < 0 Then Return -1
	Local $x = WinGetPos($TM_main_GUI[$s_ID])
	If $x[0] > -1000 Then Return 1
EndFunc   ;==>_TrayMenu_LevelIsOpened

#EndRegion;--------_TrayMenu_LevelIsOpened
#Region;--------_TrayMenu_SetToolTip

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetToolTip ( [text] )
	;#	Description....: (Re)Sets the tooltip text for the tray icon.
	;# 	Parameters.....: title = [optional] The new text to be displayed as tooltip. The length is limited - see Remarks.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 10.12.08
	;#  Remarks .......: Same as TraySetToolTip See "TraySetToolTip" for remarks..
	;#	Related........: _TrayMenu_Tip
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetToolTip($txt = "")
	Return TraySetToolTip($txt)
EndFunc   ;==>_TrayMenu_SetToolTip

#EndRegion;--------_TrayMenu_SetToolTip
#Region;--------_TrayMenu_Tip

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_Tip ( "title", "text", timeout [, option] )
	;#	Description....: Displays a balloon tip from the Tray Icon. (2000/XP only).
	;# 	Parameters.....: title = Text appears in bold at the top of the balloon tip. (63 characters maximum)
	;#					 text = Message the balloon tip will display. (255 characters maximum)
	;#					 timeout = A rough estimate of the time (in seconds) the balloon tip should be displayed. (Windows has a min and max of about 10-30 seconds but does not always honor a time in that range.)
	;#					 option = [optional] See Remarks. 0=No icon (default), 1=Info icon, 2=Warning icon, 3=Error icon
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 10.12.08
	;#  Remarks .......: Same as TrayTip. See "TrayTip" for remarks.
	;#	Related........: _TrayMenu_SetToolTip
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_Tip($title, $txt, $timeout, $icon = 0)
	If $icon < 0 Or $icon > 3 Then $icon = 0
	TrayTip($title, $txt, $timeout, $icon)
	Return 1
EndFunc   ;==>_TrayMenu_Tip

#EndRegion;--------_TrayMenu_Tip
#EndRegion;--------------------------Main Functions
#Region;--------------------------Options Section
#Region;--------_TrayMenu_SetDefault

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetDefault ( )
	;#	Description....: Sets all _TrayMenu options and settings to the defaults.
	;# 	Parameters.....: none
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: The subsequent functions are used to change these default settings.
	;#					 However, all variables can be reassigned directly, if desired.
	;#	Related........: all _TrayMenu_Set... functions
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetDefault() ;default main icon ?
	Global $TM_def_radio_Icon = "mmcndmgr.dll" ;	def radio (dot) icon
	Global $TM_def_check_Icon = "rasdlg.dll" ;	def check mark icon
	Global $TM_def_men_Icon = "mmcndmgr.dll" ;	def menu (arrow right) icon
	Global $TM_def_indt_Icon = "rasdlg.dll" ;	def indeterminate check mark icon
	Global $TM_col_it_bk_2nd = 0x0A246A ;	selected bk color
	Global $TM_col_it_ft_2nd = 0xFFFFFF ;	selected ft color
	Global $TM_col_it_bk_top = 0x808080 ;	separator top color
	Global $TM_col_it_bk_bot = 0xFFFFFF ;	separator bottom color
	Global $TM_col_gui_bk = 0xD4D0C8 ;	default gui bk color
	Global $TM_def_radio_INum = -62 ;	def radio (dot) icon number
	Global $TM_ft = "MS Sans Serif" ;	default font name
	Global $TM_Check_Auto_Mode = 1 ;	auto-uncheck-item
	Global $TM_Radio_Auto_Mode = 1 ;	auto_radio_group
	Global $TM_def_check_INum = 0 ;	def check mark icon number
	;	Global $TM_def_radio_ISz = 12	;	def radio (dot) icon size
	;	Global $TM_def_check_ISz = 12	;	def check mark icon size
	Global $TM_def_indt_INum = 61 ;	def indeterminate check mark icon number
	Global $TM_def_men_INum = -33 ;	def menu (arrow right) icon number
	Global $TM_Itm_def_style = 0 ;	default item style
	Global $TM_Close_Delay = 300 ;	delay for popup closing ms
	Global $TM_def_men_ISz = 12 ;	def menu (arrow right) icon size
	Global $TM_def_usr_ISz = 12 ;	def user icon (left) size
	Global $TM_Open_Delay = 300 ;	delay for popup opening ms
	Global $TM_Select_Mode = 3 ;	default select mode (on hovering)
	Global $TM_Resize_Mode = 1 ;	autom. resizing
	Global $TM_shdw_trans = 80 ;	shadow transparency
	Global $TM_Frequency = 50 ;	callback frequency
	Global $TM_Itm_def_h = 16 ;	default item height (0=auto)
	Global $TM_Itm_blk_h = 10 ;	default separator height
	Global $TM_col_it_bk = -2 ;	default item bk color
	Global $TM_ft_width = 400 ;	default font width
	Global $TM_Itm_def_w = 0 ;	default item width (0=auto)
	Global $TM_col_it_ft = 0 ;	default font color
	Global $TM_Shdw_Mode = 1 ;	shadow on/off
	Global $TM_ft_size = 8.5 ;	defaut font size
	Global $TM_shdw_col = 0 ;	shadow color
	Global $TM_ft_attr = 0 ;	default font attr
	Global $TM_pad_le_2nd = 5 ;	item left sel padding; (pixel 3-step)
	Global $TM_pad_ri_2nd = 7 ;	item right sel padding; (pixel)
	Global $TM_pad_le = 5 ;	item left padding; (pixel 3-step)
	Global $TM_pad_ri = 7 ;	item right padding; (pixel)
	If IsDeclared("TM_Itm") Then
		For $i = 0 To $TM_gui_cnt
			$TM_gui_w[$i] = 0
			$TM_gui_h[$i] = 0
			$TM_Itm_w[$i] = $TM_Itm_def_w
			$TM_Itm_h[$i] = $TM_Itm_def_h
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				Local $t = $TM_Itm[$i][$j]
				GUICtrlSetBkColor($t, $TM_col_it_bk)
				If GUICtrlRead($t) Then
					$TM_itm_ft_col[$t] = $TM_col_it_ft
					$TM_itm_ft_col_2nd[$t] = $TM_col_it_ft_2nd
					$TM_itm_bk_col[$t] = $TM_col_it_bk
					$TM_itm_bk_col_2nd[$t] = $TM_col_it_bk_2nd
					$TM_itm_sel[$t] = $TM_Select_Mode
					$TM_itm_ft_width[$t] = $TM_ft_width
					$TM_itm_ft_attr[$t] = $TM_ft_attr
					$TM_itm_ft_size[$t] = $TM_ft_size
					$TM_itm_ft[$t] = $TM_ft
					;		$TM_usr_icn[$t]
					;		$TM_usr_inm[$t]
					;		$TM_usr_icn_2nd[$t]
					;		$TM_usr_inm_2nd[$t]
					;		$TM_men_icn[$t]
					;		$TM_men_inm[$t]
					;		$TM_men_icn_2nd[$t]
					;		$TM_men_inm_2nd[$t]
					;style
					;pad
					;setclick
					;icon hide
					;iconsize
					;item höhe und default !
					;sidebar deleten ? und size =0
					GUICtrlSetColor($t, $TM_col_it_ft)
					GUICtrlSetFont($t, $TM_ft_size, $TM_ft_width, $TM_ft_attr, $TM_ft)
					;		$TM_gui_h[$i] += $TM_Itm_def_h
					GUICtrlSetData($t, __TM_Pad($TM_itm_txt[$t], $TM_pad_le, $TM_pad_ri))
					;set def item
				Else
					GUICtrlSetBkColor($TM_Itm_top[$i][$j], $TM_col_it_bk_top)
					GUICtrlSetBkColor($TM_Itm_bot[$i][$j], $TM_col_it_bk_bot)
					;		$TM_gui_h[$i] += $TM_Itm_blk_h
				EndIf
				GUICtrlSetImage($TM_itm_pic[$t], "")
				__TM_Measure_Item($i, $j)
			Next
			GUISetBkColor($TM_shdw_col, $TM_shdw_GUI[$i])
			GUISetBkColor($TM_col_gui_bk, $TM_main_GUI[$i])
			WinSetTrans($TM_shdw_GUI[$i], "", $TM_shdw_trans)
			WinSetTrans($TM_main_GUI[$i], "", 255)
			GUICtrlSetImage($TM_gui_pic[$i], "")
			__TM_Resize_Win($i)
		Next
	EndIf
	Return 1
EndFunc   ;==>_TrayMenu_SetDefault

#EndRegion;--------_TrayMenu_SetDefault
#Region;--------_TrayMenu_SetClick

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetClick ( flag )
	;#	Description....: Sets the clickmode of the tray icon - what mouseclicks will display the tray menu.
	;# 	Parameters.....: flag = 0 = Tray menu will never be shown through a mouseclick
	;#					 		1 = Pressing primary mouse button
	;#					 		2 = Releasing primary mouse button
	;#					 		4 = Pressing double primary mouse button
	;#					 		8 = Pressing secondary mouse button
	;#					 		16 = Releasing secondary mouse button
	;#					 		32 = Pressing double secondary mouse button
	;#					 		64 = Releasing or pressing any mouse button
	;#					 		128 = Mouse hovers over icon
	;#					 		256 = Mouse leaves icon hovering
	;#  Return Value ..: Success: Returns 1.
	;#					 		  Returns 0 if flag was 0.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: These flags are NOT tray event values!
	;#	Related........: None.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetClick($x)
	If $x = 0 Then
		For $i = -14 To -7
			TraySetOnEvent($i, "")
		Next
	Else
		If $x >= 256 Then $x -= __TM_SetOnEvent(256, -12) ;	$TRAY_EVENT_MOUSEOUT = -12
		If $x >= 128 Then $x -= __TM_SetOnEvent(128, -11) ;	$TRAY_EVENT_MOUSEOVER -11 The mouse moves over the tray icon.
		If $x >= 64 Then
			For $i = -14 To -7
				If $i <> -12 And $i <> -11 Then TraySetOnEvent($i, "__TM_Show_1st")
			Next
			Return 1
		EndIf
		If $x >= 32 Then $x -= __TM_SetOnEvent(32, -14) ;	$TRAY_EVENT_SECONDARYDOUBLE -14 The secondary mouse button was double pressed on the tray icon.
		If $x >= 16 Then $x -= __TM_SetOnEvent(16, -10) ;	$TRAY_EVENT_SECONDARYUP -10 The secondary mouse button was released on the tray icon.
		If $x >= 8 Then $x -= __TM_SetOnEvent(8, -9) ;	$TRAY_EVENT_SECONDARYDOWN -9 The secondary mouse button was pressed on the tray icon.
		If $x >= 4 Then $x -= __TM_SetOnEvent(4, -13) ;	$TRAY_EVENT_PRIMARYDOUBLE -13 The primary mouse button was double pressed on the tray icon.
		If $x >= 2 Then $x -= __TM_SetOnEvent(2, -8) ;	$TRAY_EVENT_PRIMARYUP -8 The primary mouse button was released on the tray icon.
		If $x >= 1 Then $x -= __TM_SetOnEvent(1, -7) ;	$TRAY_EVENT_PRIMARYDOWN -7 The primary mouse button was pressed on the tray icon.
		Return 1
	EndIf
EndFunc   ;==>_TrayMenu_SetClick

#cs
	$TRAY_EVENT_SHOWICON -3 The tray icon will be shown.
	$TRAY_EVENT_HIDEICON -4 The tray icon will be hidden.
	$TRAY_EVENT_FLASHICON -5 The user turned the tray icon flashing on.
	$TRAY_EVENT_NOFLASHICON -6 The user turned the tray icon flashing off.
#ce

#EndRegion;--------_TrayMenu_SetClick
#Region;--------_TrayMenu_SetCheckMode

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetCheckMode ( [ check auto state [, radio auto state ]] )
	;#	Description....: Changes behaviour of checked items or radio items.
	;# 	Parameters.....: check auto state [optional]
	;#							1 = (Default) checked item will automatically uncheck if you click it.
	;#							0 = checked item will not automatically uncheck if you click it.
	;#					 radio auto state [optional]
	;#							1 = (Default) A clicked radio menuitem will be checked automatically and all other radio items in the same group will be unchecked.
	;#							0 = No reaction when clicking radio items.
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: Without parameters, both states are set to 1.
	;#					 Options can also be changed directly. The variables are: $TM_Check_Auto_Mode, $TM_Radio_Auto_Mode
	;#	Related........: _TrayMenu_ItemCreate, _TrayMenu_SetDefault
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetCheckMode($mode1 = 1, $mode2 = 1)
	$TM_Check_Auto_Mode = ($mode1 > 0)
	$TM_Radio_Auto_Mode = ($mode2 > 0)
	Return 1
EndFunc   ;==>_TrayMenu_SetCheckMode

#EndRegion;--------_TrayMenu_SetCheckMode
#Region;--------_TrayMenu_SetSelectMode

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetSelectMode ( [ level [, mode ]] )
	;#	Description....: Sets the behaviour of selected / hot items for one or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default select mode !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;# 					 mode [optional] Default is 3 (1+2).
	;#							0 = No reaction.
	;#							1 = selected / hot item will change text color.
	;#					 		2 = selected / hot item will change background color.
	;#							4 = selected / hot item will change user (left) icon and its size.
	;#						   	8 = selected / hot item will change menu (right) icon and its size.
	;#						   16 = selected / hot item will change font.
	;#						   32 = selected / hot item will change background pic.
	;#						   64 = selected / hot item will change text AND PADDING.
	;#						  128 = selected / hot item will change style.
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 28.11.08
	;#  Remarks .......: Values can be summed up.
	;# 					 Use _TrayMenu_SetSelectMode() to (re)set the default ( = 3 (changes color and background color)).
	;#					 Option can also be changed directly, but already created items will not be changed then. The variable is: $TM_Select_Mode.
	;#	Related........: _TrayMenu_ItemSetSelectMode, _TrayMenu_SetColor, _TrayMenu_SetBkColor, _TrayMenu_SetFont, _TrayMenu_SetText, _TrayMenu_SetStyle, _TrayMenu_SetIconSize, _TrayMenu_SetPadding
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetSelectMode($s_ID = -2, $mode = 3)
	If $s_ID < 0 Then
		If $s_ID = -1 Then $TM_Select_Mode = $mode
		For $i = 0 To $TM_gui_cnt
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				$TM_itm_sel[$TM_Itm[$i][$j]] = $mode
			Next
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	For $j = 0 To $TM_Itm_cnt[$s_ID] - 1
		$TM_itm_sel[$TM_Itm[$s_ID][$j]] = $mode
	Next
	Return 1
EndFunc   ;==>_TrayMenu_SetSelectMode

#EndRegion;--------_TrayMenu_SetSelectMode
#Region;--------_TrayMenu_SetIconSize

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetIconSize ( [ level [, size1 [, size2 ]]] )
	;#	Description....: Sets the default icon sizes for the icons of one or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default size !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 size1 [optional] = The size of the user (left) icon in pixel. Default is 12.
	;#					 size2 [optional] = The size of the menu (right) icon in pixel. Default is 12.
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 11.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged.
	;#					 Changing sizes will affect all marks as well as selected icons.
	;#					 Defaults can also be changed directly. The variables are: $TM_def_usr_ISz, $TM_def_men_ISz.
	;#	Related........: _TrayMenu_ItemSetIconSize
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetIconSize($s_ID, $size1 = 12, $size2 = 12)
	__TM_Hide_all()
	Local $t, $o, $p, $g, $u
	If $s_ID = -1 Then
		If $size1 <> -1 Then $TM_def_usr_ISz = $size1
		If $size2 <> -1 Then $TM_def_men_ISz = $size2
		For $i = 0 To $TM_gui_cnt
			$g = $TM_main_GUI[$i]
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				Dim $t = $TM_Itm[$i][$j], $o = $TM_UsrIcon[$t], $p = ControlGetPos($g, "", $o)
				If @error = 0 And BitAND(GUICtrlGetState($o), 16) Then
					$u = $TM_def_usr_ISz
					ControlMove($g, "", $o, $p[0] + 2, $p[1] + ($p[2] - $u) / 2, $u, $u)
				EndIf
				Dim $o = $TM_MenIcon[$t], $p = ControlGetPos($g, "", $o)
				If @error = 0 And BitAND(GUICtrlGetState($o), 16) Then
					Dim $u = $TM_def_usr_ISz, $q = $p[2] - $u
					ControlMove($g, "", $o, $p[0] + $q, $p[1] + $q / 2, $u, $u)
				EndIf
				$TM_usr_icn_sz[$t] = $TM_def_usr_ISz
				$TM_men_icn_sz[$t] = $TM_def_men_ISz
				$TM_usr_icn_sz_2nd[$t] = $TM_def_usr_ISz
				$TM_men_icn_sz_2nd[$t] = $TM_def_men_ISz
			Next
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	For $j = 0 To $TM_Itm_cnt[$s_ID] - 1
		Dim $g = $TM_main_GUI[$s_ID], $t = $TM_Itm[$s_ID][$j], $o = $TM_UsrIcon[$t], $p = ControlGetPos($g, "", $o)
		If $size1 <> -1 Then
			If @error = 0 And BitAND(GUICtrlGetState($o), 16) Then ControlMove($g, "", $o, $p[0] + 2, $p[1] + ($p[2] - $size1) / 2, $size1, $size1)
			$TM_usr_icn_sz[$t] = $size1
			$TM_usr_icn_sz_2nd[$t] = $size1
		EndIf
		Dim $o = $TM_MenIcon[$t], $p = ControlGetPos($g, "", $o)
		If $size2 <> -1 Then
			If @error = 0 And BitAND(GUICtrlGetState($o), 16) Then
				$q = $p[2] - $size2
				ControlMove($g, "", $o, $p[0] + $q, $p[1] + $q / 2, $size2, $size2)
			EndIf
			$TM_men_icn_sz[$t] = $size2
			$TM_men_icn_sz_2nd[$t] = $size2
		EndIf
	Next
	Return 1
EndFunc   ;==>_TrayMenu_SetIconSize

#EndRegion;--------_TrayMenu_SetIconSize
#Region;--------_TrayMenu_SetPadding

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetPadding ( [ level [, padleft [, padright [, padleftsel [, padrightsel]]]]] )
	;#	Description....: Sets the item text padding and/or the selected text padding of one or all tray menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default padding !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 padleft [optional] = The number of spaces to be added to the left of the text. Default is 5 (appr. 15 pixel).
	;#					 padright [optional] = The number of spaces to be added to the right of the text. Default is 7 (appr. 21 pixel).
	;#					 padleftsel [optional] = The number of spaces to be added to the left of the text when item is selected / hot. Default is 5 (appr. 15 pixel).
	;#					 padrightsel [optional] = The number of spaces to be added to the right of the text when item is selected / hot. Default is 7 (appr. 21 pixel).
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 11.12.08
	;#  Remarks .......: The padding is used to reserve space for check/menu marks and icons to the left and the right of the text.
	;#					 As spaces are used, the width depends of the used font. One spaces corresponds to 3 pixels in default font.
	;#					 A selected padding can be used to buffer different item or font sizes.
	;#					 If selected padding is supposed to be used, add select mode 64 (text). The padding is connected to the text.
	;#					 Does not apply to separators.
	;# 					 Use -1 to leave a parameter unchanged, "" (blank string) to set to the default.
	;#					 Defaults can also be changed directly. The variables are: $TM_pad_le, $TM_pad_ri, $TM_pad_le_2nd, $TM_pad_ri_2nd.
	;#	Related........: _TrayMenu_ItemSetPadding
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetPadding($s_ID, $padl = 5, $padr = 7, $padls = 5, $padrs = 7)
	__TM_Hide_all()
	Local $t
	If $s_ID = -1 Then
		If $padl <> -1 Then $TM_pad_le = $padl
		If $padr <> -1 Then $TM_pad_ri = $padr
		If $padls <> -1 Then $TM_pad_le_2nd = $padls
		If $padrs <> -1 Then $TM_pad_ri_2nd = $padrs
		For $i = 0 To $TM_gui_cnt
			$TM_Itm_w[$i] = $TM_Itm_def_w
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				$t = $TM_Itm[$i][$j]
				If $TM_itm_txt[$t] Then
					GUICtrlSetData($t, __TM_Pad($TM_itm_txt[$t], $TM_pad_le, $TM_pad_ri))
					$TM_itm_pad_l[$t] = $TM_pad_le
					$TM_itm_pad_r[$t] = $TM_pad_ri
					$TM_itm_pad_l_2nd[$t] = $TM_pad_le_2nd
					$TM_itm_pad_r_2nd[$t] = $TM_pad_ri_2nd
				EndIf
				__TM_Measure_Item($i, $j)
			Next
			__TM_Resize_Win($i)
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	$TM_Itm_w[$s_ID] = $TM_Itm_def_w
	For $j = 0 To $TM_Itm_cnt[$s_ID] - 1
		$t = $TM_Itm[$s_ID][$j]
		If $TM_itm_txt[$t] Then
			If $padl <> -1 Then $TM_itm_pad_l[$t] = $padl
			If $padr <> -1 Then $TM_itm_pad_r[$t] = $padr
			If $padls <> -1 Then $TM_itm_pad_l_2nd[$t] = $padls
			If $padrs <> -1 Then $TM_itm_pad_r_2nd[$t] = $padrs
			GUICtrlSetData($t, __TM_Pad($TM_itm_txt[$t], $TM_itm_pad_l[$t], $TM_itm_pad_r[$t]))
		EndIf
		__TM_Measure_Item($s_ID, $j)
	Next
	__TM_Resize_Win($s_ID)
	Return 1
EndFunc   ;==>_TrayMenu_SetPadding

#EndRegion;--------_TrayMenu_SetPadding
#Region;--------_TrayMenu_SetFont

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetFont ( [ level [, size [, weight [, attribute [, fontname]]]]] )
	;#	Description....: (Re)sets the font for one or all menu levels.
	;# 	Parameters.....: level = Specifies the menu level.
	;#							use -1 for all menu levels.
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 size = Fontsize (default is 8.5).
	;#					 weight [optional] = Font weight (default is 400).
	;#					 attribute [optional] = Add together the values of all the styles required (2+4 = italic and underlined). Default is 0.
	;#											2 = italic
	;#											4 = underlined
	;#											8 = strike
	;#					 fontname [optional] = The name of the font to use (default is "MS Sans Serif").
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: To reset to the default font stored in _TrayMenu_SetDefault, use _TrayMenu_SetFont().
	;#					 Please observe: By default, the height of the items is fixed to 16 px = windows default, while the width is released (automatic).
	;#					 On changing font height, you might want to release the item height before. Do this by using _TrayMenu_SetItemSize(0,0).
	;#					 Defaults can also be changed directly. The variables are: $TM_ft_size, $TM_ft_width, $TM_ft_attr, $TM_ft
	;#	Related........: _TrayMenu_ItemSetFont, _TrayMenu_SetItemSize
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetFont($s_ID = -2, $size = 8.5, $width = 400, $attr = 0, $name = "MS Sans Serif")
	__TM_Hide_all()
	Local $t
	If $s_ID < 0 Then
		If $s_ID = -1 Then
			If $size <> -1 Then $TM_ft_size = $size
			If $width <> -1 Then $TM_ft_width = $width
			If $attr <> -1 Then $TM_ft_attr = $attr
			If $name <> -1 Then $TM_ft = $name
		EndIf
		If $size = -1 Then $size = $TM_ft_size
		If $width = -1 Then $width = $TM_ft_width
		If $attr = -1 Then $attr = $TM_ft_attr
		If $name = -1 Then $name = $TM_ft
		For $i = 0 To $TM_gui_cnt
			__TM_SetFont($i, $size, $width, $attr, $name)
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	If $size = -1 Then $size = $TM_ft_size
	If $width = -1 Then $width = $TM_ft_width
	If $attr = -1 Then $attr = $TM_ft_attr
	If $name = -1 Then $name = $TM_ft
	__TM_SetFont($s_ID, $size, $width, $attr, $name)
	Return 1
EndFunc   ;==>_TrayMenu_SetFont

#EndRegion;--------_TrayMenu_SetFont
#Region;--------_TrayMenu_SetSelFont

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetSelFont ( [ level [, size [, weight [, attribute [, fontname]]]]] )
	;#	Description....: (Re)sets the selected font for one or all menu levels.
	;# 	Parameters.....: level = Specifies the menu level.
	;#							use -1 for all menu levels.
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 size = Fontsize (default is 8.5).
	;#					 weight [optional] = Font weight (default is 400).
	;#					 attribute [optional] = Add together the values of all the styles required (2+4 = italic and underlined). Default is 0.
	;#											2 = italic
	;#											4 = underlined
	;#											8 = strike
	;#					 fontname [optional] = The name of the font to use (default is "MS Sans Serif").
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: To reset to the default font stored in _TrayMenu_SetDefault, use _TrayMenu_SetSelFont().
	;#					 Please observe: The popup size will not be adapted to selected font. It might be necessary to use a fixed size.
	;#	Related........: _TrayMenu_ItemSetSelFont, _TrayMenu_SetItemSize
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetSelFont($s_ID = -1, $size = 8.5, $width = 400, $attr = 0, $name = "MS Sans Serif")
	__TM_Hide_all()
	Local $t
	If $size = -1 Then $size = $TM_ft_size
	If $width = -1 Then $width = $TM_ft_width
	If $attr = -1 Then $attr = $TM_ft_attr
	If $name = -1 Then $name = $TM_ft
	If $s_ID < 0 Then
		For $i = 0 To $TM_gui_cnt
			__TM_SetSelFont($i, $size, $width, $attr, $name)
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	__TM_SetSelFont($s_ID, $size, $width, $attr, $name)
	Return 1
EndFunc   ;==>_TrayMenu_SetSelFont

#EndRegion;--------_TrayMenu_SetSelFont
#Region;--------_TrayMenu_SetColor

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetColor ( [ level [, textcolor [, selected]]] )
	;#	Description....: (Re)sets the text color for one or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default text color !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 textcolor [optional] = The RGB color to use. Default is the previously set. In the default color scheme it is 0 (black).
	;#					 selected [optional] = The RGB color to use when mouse hovers over control. Default is the previously set. In the default color scheme it is 0xFFFFFF (white).
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 2.12.08
	;#  Remarks .......: Use -1 to leave textcolor unchanged.
	;# 					 To reset to the default text color stored in _TrayMenu_SetDefault, use _TrayMenu_SetColor().
	;#					 Separator lines will not be affected. Use _TrayMenu_ItemSetColor to set them individually.
	;#					 Defaults can also be changed directly. The variables are: $TM_col_it_ft, $TM_col_it_ft_2nd.
	;#	Related........: _TrayMenu_ItemSetColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetColor($s_ID = -2, $color1 = 0, $color2 = 0xFFFFFF)
	If $s_ID < 0 Then
		If $s_ID = -1 Then
			$TM_col_it_ft = $color1
			$TM_col_it_ft_2nd = $color2
		EndIf
		For $i = 0 To $TM_gui_cnt
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				GUICtrlSetColor($TM_Itm[$i][$j], $TM_col_it_ft)
				$TM_itm_ft_col[$TM_Itm[$i][$j]] = $TM_col_it_ft
				$TM_itm_ft_col_2nd[$TM_Itm[$i][$j]] = $TM_col_it_ft_2nd
			Next
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	For $j = 0 To $TM_Itm_cnt[$s_ID] - 1
		GUICtrlSetColor($TM_Itm[$s_ID][$j], $color1)
		$TM_itm_ft_col[$TM_Itm[$s_ID][$j]] = $color1
		$TM_itm_ft_col_2nd[$TM_Itm[$s_ID][$j]] = $color2
	Next
	Return 1
EndFunc   ;==>_TrayMenu_SetColor

#EndRegion;--------_TrayMenu_SetColor
#Region;--------_TrayMenu_SetBkColor

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetBkColor ( [ level [, backgroundcolor [, selected]] )
	;#	Description....: (Re)sets the background color and the selected background color of all tray controls in one or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default background color !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 backgroundcolor [optional] = The RGB color to use. Default is the previously set. In the default color scheme it is -2 ($GUI_BKCOLOR_TRANSPARENT).
	;#					 selected [optional] = The RGB color to use when mouse hovers over control. Default is the previously set. In the default color scheme it is 0x0A246A (blue).
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 2.12.08
	;#  Remarks .......: Use -1 to leave background color unchanged.
	;# 					 To reset to the default background color stored in _TrayMenu_SetDefault, use _TrayMenu_SetBkColor().
	;#					 Separator lines will be affected as well. The selected color is not used on them.
	;#					 Defaults can also be changed directly. The variables are: $TM_col_it_bk, $TM_col_it_bk_2nd.
	;#	Related........: _TrayMenu_ItemSetBkColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetBkColor($s_ID = -2, $color1 = -2, $color2 = 0x0A246A)
	If $s_ID < 0 Then
		If $s_ID = -1 Then
			$TM_col_it_bk = $color1
			$TM_col_it_bk_2nd = $color2
		EndIf
		For $i = 0 To $TM_gui_cnt
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				GUICtrlSetBkColor($TM_Itm[$i][$j], $TM_col_it_bk)
				$TM_itm_bk_col[$TM_Itm[$i][$j]] = $TM_col_it_bk
				$TM_itm_bk_col_2nd[$TM_Itm[$i][$j]] = $TM_col_it_bk_2nd
			Next
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	For $j = 0 To $TM_Itm_cnt[$s_ID] - 1
		GUICtrlSetBkColor($TM_Itm[$s_ID][$j], $color1)
		$TM_itm_bk_col[$TM_Itm[$s_ID][$j]] = $color1
		$TM_itm_bk_col_2nd[$TM_Itm[$s_ID][$j]] = $color2
	Next
	Return 1
EndFunc   ;==>_TrayMenu_SetBkColor

#EndRegion;--------_TrayMenu_SetBkColor
#Region;--------_TrayMenu_SetStyle

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetStyle ( [ level [, style [, selected]]] )
	;#	Description....: (Re)sets the style and the selected style of all tray controls in one or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels.
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 style [optional] = The style to use. See state table below.
	;#					 selected [optional] = The style to use when mouse hovers over control. See state table below.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: 3 styles are allowed:
	;#						$SS_LEFT = 0 (Default)  Left aligns text.
	;#						$SS_CENTER = 1  Centers text horizontally.
	;#						$SS_RIGHT = 2  Right aligns text.
	;#  				 Use -1 to leave style unchanged, use "" (blank string) to reset to default style.
	;#					 $SS_NOTIFY and $SS_CENTERIMAGE will always be forced.
	;#					 Default can also be changed directly. The variable is: $TM_Itm_def_style
	;#	Related........: _TrayMenu_ItemSetStyle
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetStyle($s_ID = -1, $style = 0, $selected = "")
	__TM_Hide_all()
	Local $t
	If $style < 0 Or $style > 2 Then $style = 0
	If $selected < 0 Or $selected > 2 Then $selected = 0
	If $style = -1 Then $style = $TM_Itm_def_style
	If $selected = -1 Then $selected = $TM_Itm_def_style
	If $s_ID = -1 Then
		If $style <> -1 Then $TM_Itm_def_style = $style
		For $i = 0 To $TM_gui_cnt
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				$t = $TM_Itm[$i][$j]
				If $TM_itm_txt[$t] Then
					GUICtrlSetStyle($t, BitOR(768, $style))
					$TM_itm_style_2nd[$t] = $selected
					$TM_itm_style[$t] = $style
				EndIf
			Next
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	For $j = 0 To $TM_Itm_cnt[$s_ID] - 1
		$t = $TM_Itm[$s_ID][$j]
		If $TM_itm_txt[$t] Then
			GUICtrlSetStyle($t, BitOR(768, $style))
			$TM_itm_style_2nd[$t] = $selected
			$TM_itm_style[$t] = $style
		EndIf
	Next
	Return 1
EndFunc   ;==>_TrayMenu_SetStyle

#EndRegion;--------_TrayMenu_SetStyle
#Region;--------_TrayMenu_SetItemSize;	not fully working

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetItemSize ( [ level [, $width [, $height [, $blank]]]] )
	;#	Description....: Changes default size of the items in one or all menu levels to be assigned to an item on creation.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default sizes !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;# 					 $width [optional] = Default item width in px (Default is 0 (automatic sizing according to font and text length)).
	;#					 $height [optional] = Default item height in px (Default is 16).
	;#					 $blank [optional] = Default separator height in px (Default is 10).
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: For $width or $height, value = 0 means automatic sizing according to font and text length. No automatic height sizing for separators !
	;#					 By default, all items will be resized to the same size according to the widest / highest item.
	;#					 To resize a single item only, use _TrayMenu_ItemSetHeight.
	;#					 Use -1 to leave a param unchanged.
	;#					 Use "" (blank string) to set a parameter to default.
	;#					 Options can also be changed directly. The variables are: $TM_Itm_def_w, $TM_Itm_def_h, $TM_Itm_blk_h
	;#	Related........: _TrayMenu_ItemSetHeight, _TrayMenu_ItemSetFont, _TrayMenu_SetFont
	;#	Example........: yes
	;#===========================================================#
#ce
;			currently only level = -1 working !!!
Func _TrayMenu_SetItemSize($s_ID = -1, $width = 0, $height = 16, $blank = 10)
	If $width < 0 Then $width = 0
	If $height < 0 Then $height = 16
	If $blank < 0 Then $blank = 10
	If $s_ID = -1 Then
		$TM_Itm_def_w = $width
		$TM_Itm_def_h = $height
		$TM_Itm_blk_h = $blank
		For $i = 0 To $TM_gui_cnt
			$TM_gui_def_w[$i] = $width
			$TM_gui_def_h[$i] = $height
			$TM_gui_def_blk[$i] = $blank
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				__TM_Measure_Item($i, $j)
			Next
			__TM_Resize_Win($i)
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	$TM_gui_def_w[$s_ID] = $width
	$TM_gui_def_h[$s_ID] = $height
	$TM_gui_def_blk[$s_ID] = $blank
	For $j = 0 To $TM_Itm_cnt[$s_ID] - 1
		__TM_Measure_Item($s_ID, $j)
	Next
	__TM_Resize_Win($s_ID)
	Return 1
EndFunc   ;==>_TrayMenu_SetItemSize

#EndRegion;--------_TrayMenu_SetItemSize
#Region;--------_TrayMenu_SetCheckMark

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetCheckMark ( filename [, iconname [, fileselected [, iconselected]]] )
	;#	Description....: Sets the default check mark and the selected check mark icon to be assigned to an item on creation.
	;# 	Parameters.....: filename = The filename containing the picture to be displayed.
	;#					 iconname [optional] = Icon name if filename contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 fileselected [optional] = The filename containing the picture when mouse hovers over control.
	;#					 iconselected [optional] = Icon name if fileselected contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 6.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged. A blank string ("") will destroy an icon.
	;#					 Function is recommended to be used before items are created.
	;#					 Previously created AND checked items will not be affected ! Use _TrayMenu_ItemSetUserIcon instead or re-check item by _TrayMenu_ItemCheck(controlID).
	;#					 _TrayMenu_ItemSetUserIcon will override this setting.
	;#					 Defaults can also be changed directly. The variables are: $TM_def_check_Icon, $TM_def_check_INum, $TM_def_check_Icon_2nd, $TM_def_check_INum_2nd.
	;#	Related........: _TrayMenu_ItemSetUserIcon.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetCheckMark($name1, $icon1 = -1, $name2 = "", $icon2 = -1)
	If $name1 <> -1 Then
		$TM_def_check_Icon = $name1
		$TM_def_check_INum = $icon1
	EndIf
	If $name2 <> -1 Then
		$TM_def_check_Icon_2nd = $name2
		$TM_def_check_INum_2nd = $icon2
	EndIf
	Return 1
EndFunc   ;==>_TrayMenu_SetCheckMark

#EndRegion;--------_TrayMenu_SetCheckMark
#Region;--------_TrayMenu_SetIndeterminateMark

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetIndeterminateMark ( filename [, iconname [, fileselected [, iconselected]]] )
	;#	Description....: Sets the default indeterminate mark and the selected indeterminate mark icon to be assigned to an item on creation.
	;# 	Parameters.....: filename = The filename containing the picture to be displayed.
	;#					 iconname [optional] = Icon name if filename contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 fileselected [optional] = The filename containing the picture when mouse hovers over control.
	;#					 iconselected [optional] = Icon name if fileselected contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 6.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged. A blank string ("") will destroy an icon.
	;#					 Function is recommended to be used before items are created.
	;#					 Previously created AND checked items will not be affected ! Use _TrayMenu_ItemSetUserIcon instead or re-check item by _TrayMenu_ItemCheck(controlID,1).
	;#					 _TrayMenu_ItemSetUserIcon will override this setting.
	;#					 Defaults can also be changed directly. The variables are: $TM_def_indt_Icon, $TM_def_indt_INum, $TM_def_indt_Icon_2nd, $TM_def_indt_INum_2nd.
	;#	Related........: _TrayMenu_ItemSetUserIcon.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetIndeterminateMark($name1, $icon1 = -1, $name2 = "", $icon2 = -1)
	If $name1 <> -1 Then
		$TM_def_indt_Icon = $name1
		$TM_def_indt_INum = $icon1
	EndIf
	If $name2 <> -1 Then
		$TM_def_indt_Icon_2nd = $name2
		$TM_def_indt_INum_2nd = $icon2
	EndIf
	Return 1
EndFunc   ;==>_TrayMenu_SetIndeterminateMark

#EndRegion;--------_TrayMenu_SetIndeterminateMark
#Region;--------_TrayMenu_SetRadioMark

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetRadioMark ( filename [, iconname [, fileselected [, iconselected [, flag]]]] )
	;#	Description....: Sets the default radio mark and the selected radio mark icon to be assigned to an item on creation.
	;# 	Parameters.....: filename = The filename containing the picture to be displayed.
	;#					 iconname [optional] = Icon name if filename contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 fileselected [optional] = The filename containing the picture when mouse hovers over control.
	;#					 iconselected [optional] = Icon name if fileselected contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 flag [optional] = 1 (default) will also change previously created, 0 will not.
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 6.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged. A blank string ("") will destroy an icon.
	;#					 _TrayMenu_ItemSetUserIcon will override this setting.
	;#					 Defaults can also be changed directly. The variables are: $TM_def_radio_Icon, $TM_def_radio_INum, $TM_def_radio_Icon_2nd, $TM_def_radio_INum_2nd.
	;#	Related........: _TrayMenu_ItemSetUserIcon.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetRadioMark($name1, $icon1 = -1, $name2 = "", $icon2 = -1, $flag = 1)
	If $name1 <> -1 Then
		$TM_def_radio_Icon = $name1
		$TM_def_radio_INum = $icon1
	EndIf
	If $name2 <> -1 Then
		$TM_def_radio_Icon_2nd = $name2
		$TM_def_radio_INum_2nd = $icon2
	EndIf
	If $flag = 1 Then
		Local $t
		For $i = 0 To $TM_gui_cnt
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				$t = $TM_Itm[$i][$j]
				If $TM_type[$t] = -1 Then
					$TM_usr_icn[$t] = $TM_def_radio_Icon
					$TM_usr_inm[$t] = $TM_def_radio_INum
					$TM_usr_icn_2nd[$t] = $TM_def_radio_Icon_2nd
					$TM_usr_inm_2nd[$t] = $TM_def_radio_INum_2nd
					__TM_IconSetImage($i, $j, $TM_usr_icn[$t], $TM_usr_inm[$t], $TM_usr_icn_sz[$t])
				EndIf
			Next
		Next
	EndIf
	Return 1
EndFunc   ;==>_TrayMenu_SetRadioMark

#EndRegion;--------_TrayMenu_SetRadioMark
#Region;--------_TrayMenu_SetMenuMark

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetMenuMark ( filename [, iconname [,fileselected [, iconselected [, flag]]]] )
	;#	Description....: Sets the default menu mark and the selected menu mark icon to be assigned to an item on creation.
	;# 	Parameters.....: filename = The filename containing the picture to be displayed.
	;#					 iconname [optional] = Icon name if filename contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 fileselected [optional] = The filename containing the picture when mouse hovers over control.
	;#					 iconselected [optional] = Icon name if fileselected contains multiple icons. Can be an ordinal name if negative number. Otherwise -1.
	;#					 flag [optional] = 1 (default) will also change previously created, 0 will not.
	;#  Return Value ..: Success: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 6.12.08
	;#  Remarks .......: Use -1 to leave a parameter unchanged. A blank string ("") will destroy an icon.
	;#					 Previously created items will not be affected, unless you set the select mode to 16.
	;#					 _TrayMenu_ItemSetMenuIcon will override this setting.
	;#					 Defaults can also be changed directly. The variables are: $TM_def_radio_Icon, $TM_def_radio_INum, $TM_def_radio_Icon_2nd, $TM_def_radio_INum_2nd.
	;#	Related........: _TrayMenu_ItemSetMenuIcon.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetMenuMark($name1, $icon1 = -1, $name2 = "", $icon2 = -1, $flag = 1)
	If $name1 <> -1 Then
		$TM_def_men_Icon = $name1
		$TM_def_men_INum = $icon1
	EndIf
	If $name2 <> -1 Then
		$TM_def_men_Icon_2nd = $name2
		$TM_def_men_INum_2nd = $icon2
	EndIf
	If $flag = 1 Then
		Local $t
		For $i = 0 To $TM_gui_cnt
			For $j = 0 To $TM_Itm_cnt[$i] - 1
				$t = $TM_Itm[$i][$j]
				If $TM_type[$t] > 0 Then
					$TM_men_icn[$t] = $TM_def_men_Icon
					$TM_men_inm[$t] = $TM_def_men_INum
					$TM_men_icn_2nd[$t] = $TM_def_men_Icon_2nd
					$TM_men_inm_2nd[$t] = $TM_def_men_INum_2nd
					__TM_IconSetImage($i, $j, $TM_def_men_Icon, $TM_def_men_INum, $TM_men_icn_sz[$t])
				EndIf
			Next
		Next
	EndIf
	Return 1
EndFunc   ;==>_TrayMenu_SetMenuMark

#EndRegion;--------_TrayMenu_SetMenuMark
#Region;--------_TrayMenu_PopupSetDelay

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_PopupSetDelay ( [ open [, close]] )
	;#	Description....: Sets open and close delay for the (higher level) tray popup windows.
	;# 	Parameters.....: open [optional] = Delay for popup to open in ms.
	;#					 close [optional] = Delay for popup to close in ms.
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 1.12.08
	;#  Remarks .......: Use _TrayMenu_SetPopupDelay() to (re)set the default ( = 300 ms each ).
	;#					 Options can also be changed directly. The variables are: $TM_Open_Delay, $TM_Close_Delay.
	;#	Related........: _TrayMenu_SetDefault
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_PopupSetDelay($mode1 = 300, $mode2 = 300)
	$TM_Open_Delay = $mode1
	$TM_Close_Delay = $mode2
	Return 1
EndFunc   ;==>_TrayMenu_PopupSetDelay

#EndRegion;--------_TrayMenu_PopupSetDelay
#Region;--------_TrayMenu_PopupSetColor

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_PopupSetColor ( [ level [, color]] )
	;#	Description....: Sets background color for all or specified tray popup window(s).
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default background color !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 color [optional] = The RGB color to use.
	;#  Return Value ..: Success: Returns 1.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 3.12.08
	;#  Remarks .......: To reset all levels to the default background color stored in _TrayMenu_SetDefault, use _TrayMenu_PopupSetColor().
	;#					 Option can also be changed directly. The variable is: $TM_col_gui_bk.
	;#	Related........: _TrayMenu_PopupSetTrans
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_PopupSetColor($s_ID = -2, $color = 0xD4D0C8)
	If $s_ID < 0 Then
		If $s_ID = -1 Then $TM_col_gui_bk = $color
		For $i = 0 To $TM_gui_cnt
			GUISetBkColor($TM_col_gui_bk, $TM_main_GUI[$i])
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID > -1 Then Return GUISetBkColor($color, $TM_main_GUI[$s_ID])
EndFunc   ;==>_TrayMenu_PopupSetColor

#EndRegion;--------_TrayMenu_PopupSetColor
#Region;--------_TrayMenu_PopupSetTrans

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_PopupSetTrans ( [ level [, trans] )
	;#	Description....: Sets transparency for all or specified tray popup window(s).
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default background color !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 trans [optional] = A number in the range 0 - 255. The lower the number, the more transparent the window will become. 255 = Solid, 0 = Invisible.
	;#  Return Value ..: Success: Returns non-zero.
	;# 					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 3.12.08
	;#  Remarks .......: To reset all levels to the default transparency (255), use _TrayMenu_PopupSetTrans().
	;#	Related........: _TrayMenu_PopupSetColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_PopupSetTrans($s_ID = -1, $trans = 255)
	If $s_ID < 0 Then
		For $i = 0 To $TM_gui_cnt
			WinSetTrans($TM_main_GUI[$i], "", $trans)
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID > -1 Then Return WinSetTrans($TM_main_GUI[$s_ID], "", $trans)
EndFunc   ;==>_TrayMenu_PopupSetTrans

#EndRegion;--------_TrayMenu_PopupSetTrans
#Region;--------_TrayMenu_ShadowShow

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ShadowShow ( [ level [, show]] )
	;#	Description....: Determines wether to show shadow of specified or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default mode !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 show [optional] = 1 = show, 0 = hide
	;#  Return Value ..: Success: Returns 1.
	;# 					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 4.12.08
	;#  Remarks .......: Use _TrayMenu_ShadowShow() to show all shadows.
	;#					 Option can also be changed directly. The variable is: $TM_Shdw_Mode
	;#	Related........: _TrayMenu_ShadowSetColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ShadowShow($s_ID = -2, $mode = 1)
	__TM_Hide_all()
	If $s_ID = -1 Then
		If $s_ID = -1 Then $TM_Shdw_Mode = $mode
		For $i = 0 To $TM_gui_cnt
			If $TM_Shdw_Mode > 0 Then GUISetState(@SW_SHOW, $TM_shdw_GUI[$i])
			If $TM_Shdw_Mode < 1 Then GUISetState(@SW_HIDE, $TM_shdw_GUI[$i])
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID < 0 Then Return
	If $mode > 0 Then Return GUISetState(@SW_SHOW, $TM_shdw_GUI[$s_ID])
	If $mode < 1 Then Return GUISetState(@SW_HIDE, $TM_shdw_GUI[$s_ID])
EndFunc   ;==>_TrayMenu_ShadowShow

#EndRegion;--------_TrayMenu_ShadowShow
#Region;--------_TrayMenu_ShadowSetColor

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ShadowSetColor ( [ level [, color]] )
	;#	Description....: Sets the shadow color of specified or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default shadow color !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 color [optional] = The RGB color to use. Default is 0 (black)
	;#  Return Value ..: Success: Returns 1.
	;# 					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 4.12.08
	;#  Remarks .......: Use _TrayMenu_ShadowSetColor() to (re)set the default color stored in _TM_SetDefault.
	;#					 Option can also be changed directly. The variable is: $TM_shdw_col
	;#	Related........: _TrayMenu_ShadowSetTrans
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ShadowSetColor($s_ID = -2, $color = 0)
	__TM_Hide_all()
	If $s_ID = -1 Then
		If $s_ID = -1 Then $TM_shdw_col = $color
		For $i = 0 To $TM_gui_cnt
			GUISetBkColor($TM_shdw_col, $TM_shdw_GUI[$i])
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID > -1 Then Return GUISetBkColor($color, $TM_shdw_GUI[$s_ID])
EndFunc   ;==>_TrayMenu_ShadowSetColor

#EndRegion;--------_TrayMenu_ShadowSetColor
#Region;--------_TrayMenu_ShadowSetTrans

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_ShadowSetTrans ( [ level [, trans]] )
	;#	Description....: Sets the shadow transparency of specified or all menu levels.
	;# 	Parameters.....: level [optional] = Specifies the menu level.
	;#							use -1 for all menu levels (this will change the default transparency !).
	;#							use 0 for first menu level only.
	;#							use the controlID of the menu control that opens the level to be changed or controlID of any item (not menuitem) of the level to be changed.
	;#					 trans [optional] = A number in the range 0 - 255. The lower the number, the more transparent the window will become. 255 = Solid, 0 = Invisible. Default is 80.
	;#  Return Value ..: Success: Returns non-zero.
	;#					 Failure: Returns 0.
	;#	Author ........: jennico
	;#	Date ..........: 4.12.08
	;#  Remarks .......: Use _TrayMenu_SetPopupDelay() to (re)set the default transparency.
	;#					 Option can also be changed directly. The variable is: $TM_shdw_trans.
	;#	Related........: _TrayMenu_ShadowSetColor
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_ShadowSetTrans($s_ID = -2, $trans = 80)
	__TM_Hide_all()
	If $s_ID = -1 Then
		If $s_ID = -1 Then $TM_shdw_trans = $trans
		For $i = 0 To $TM_gui_cnt
			WinSetTrans($TM_shdw_GUI[$i], "", $TM_shdw_trans)
		Next
		Return 1
	EndIf
	If $s_ID > 0 Then $s_ID = __TM_GetMenu($s_ID)
	If $s_ID > -1 Then Return WinSetTrans($TM_shdw_GUI[$s_ID], "", $trans)
EndFunc   ;==>_TrayMenu_ShadowSetTrans

#EndRegion;--------_TrayMenu_ShadowSetTrans
#Region;--------_TrayMenu_Delete

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_Delete ( )
	;#	Description....: Deletes entire tray menu.
	;# 	Parameters.....: none.
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 3.12.08
	;#  Remarks .......: To delete only a specific level, use _TrayMenu_IemDelete with the menuitem that opens the level.
	;#	Related........: _TrayMenu_IemDelete
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_Delete()
	If IsDeclared("TM_Itm") Then
		For $i = 0 To $TM_gui_cnt
			GUIDelete($TM_main_GUI[$i])
			GUIDelete($TM_shdw_GUI[$i])
		Next
	EndIf
	_TrayMenu_SetDefault()
	Global $TM_Itm[1][1]
	Global $TM_Itm_top[1][1]
	Global $TM_Itm_bot[1][1]
	Global $TM_shdw_GUI[1] = [GUICreate("", 0, 0, -1000, -1000, $TM_def_shdw_style, $TM_def_ex_style)]
	Global $TM_main_GUI[1] = [GUICreate("", 0, 0, -1000, -1000, $TM_def_style, $TM_def_ex_style, $TM_shdw_GUI[0])]
	Global $TM_gui_pic[1] = [GUICtrlCreatePic("", 0, 0, 0, 0)]
	Global $TM_itm_ft_width_2nd[1]
	Global $TM_itm_ft_attr_2nd[1]
	Global $TM_itm_ft_size_2nd[1]
	Global $TM_itm_ft_col_2nd[1]
	Global $TM_itm_bk_col_2nd[1]
	Global $TM_usr_icn_sz_2nd[1]
	Global $TM_men_icn_sz_2nd[1]
	Global $TM_itm_style_2nd[1]
	Global $TM_itm_pad_l_2nd[1]
	Global $TM_itm_pad_r_2nd[1]
	Global $TM_itm_ft_width[1]
	Global $TM_SideBar_size[1]
	Global $TM_last[1] = [-1]
	Global $TM_itm_img_2nd[1]
	Global $TM_itm_txt_2nd[1]
	Global $TM_usr_icn_2nd[1]
	Global $TM_usr_inm_2nd[1]
	Global $TM_men_icn_2nd[1]
	Global $TM_men_inm_2nd[1]
	Global $TM_itm_ft_size[1]
	Global $TM_itm_ft_attr[1]
	Global $TM_gui_def_blk[1]
	Global $TM_itm_ft_col[1]
	Global $TM_itm_bk_col[1]
	Global $TM_itm_ft_2nd[1]
	Global $TM_usr_icn_sz[1]
	Global $TM_men_icn_sz[1]
	Global $TM_Itm_height[1]
	Global $TM_itm_style[1]
	Global $TM_IsChecked[1]
	Global $TM_itm_pad_l[1]
	Global $TM_itm_pad_r[1]
	Global $TM_gui_def_w[1]
	Global $TM_gui_def_h[1]
	Global $TM_MenIcon[1]
	Global $TM_UsrIcon[1]
	Global $TM_itm_pic[1]
	Global $TM_itm_sel[1]
	Global $TM_Itm_cnt[1]
	Global $TM_itm_txt[1]
	Global $TM_mn_orig[1]
	Global $TM_itm_img[1]
	Global $TM_usr_icn[1]
	Global $TM_usr_inm[1]
	Global $TM_men_icn[1]
	Global $TM_men_inm[1]
	Global $TM_SideBar[1]
	Global $TM_IsIcon[1]
	Global $TM_origin[1]
	Global $TM_itm_ft[1]
	Global $TM_Itm_w[1]
	Global $TM_Itm_h[1]
	Global $TM_gui_w[1]
	Global $TM_gui_h[1]
	Global $TM_type[1]
	Global $TM_sb1[1]
	Global $TM_sb2[1]
	Global $TM_sb3[1]
	Global $TM_sb4[1]
	Global $TM_sb5[1]
	Global $TM_sb6[1]
	Global $TM_sb7[1]
	Global $TM_sb8[1]
	Global $TM_sb9[1]
	Global $TM_sb0[1]
	Global $TM_def_check_Icon_2nd = ""
	Global $TM_def_check_INum_2nd = ""
	Global $TM_def_radio_Icon_2nd = ""
	Global $TM_def_radio_INum_2nd = ""
	Global $TM_def_indt_Icon_2nd = ""
	Global $TM_def_indt_INum_2nd = ""
	Global $TM_def_men_Icon_2nd = ""
	Global $TM_def_men_INum_2nd = ""
	Global $TM_last_created = ""
	Global $TM_kill_timeout = ""
	Global $TM_open_timeout = ""
	Global $TM_Itm_max_cnt = ""
	Global $TM_last_open = ""
	Global $TM_show_2nd = ""
	Global $TM_win2kill = ""
	Global $TM_win2open = ""
	Global $TM_gui_cnt = ""
	Global $TM_show = ""
	Global $TM_kill = ""
	Global $TM_open = ""
	GUICtrlSetState(-1, 160)
	__TM_Shadow(0)
	Return 1
EndFunc   ;==>_TrayMenu_Delete

#EndRegion;--------_TrayMenu_Delete
#EndRegion;--------------------------Options Section
#Region;--------------------------Internal Functions
#Region;--------__TM_Main

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Main ( $hWnd, $Msg, $iIDTimer, $dwTime )
	;#	Description....: Main timer called function.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Main();$hWnd, $msg, $iIDTimer, $dwTime);wenn second, dann bleibt offen
	;	WinSetTitle($gui, "", $TM_last[0])
	If $TM_open And TimerDiff($TM_open) > $TM_open_timeout Then
		Local $info = GUIGetCursorInfo($TM_main_GUI[0]), $n = $info[4]
		If $n < UBound($TM_IsIcon) - 1 Then
			If $TM_IsIcon[$n] Then $n = $TM_Itm[0][$TM_IsIcon[$n] - 1]
			If @error = 0 And $TM_last_open = $n Then
				If $TM_show_2nd > 0 Then __TM_Hide($TM_show_2nd);nicht
				__TM_Show($TM_win2open)
			EndIf
		EndIf
		Dim $TM_kill_timeout = 0, $TM_open = ""
	EndIf
	If $TM_kill And TimerDiff($TM_kill) > $TM_kill_timeout Then __TM_Hide($TM_win2kill);nur wenn nicht hot
	If $TM_show_2nd And __TM_ItemNotify($TM_show_2nd) Then; kill nur wenn auf anderem item in 0
		$TM_kill = ""
		Local $t = $TM_last[0]
		If $t = -1 Or $TM_type[$t] <> $TM_show_2nd Then
			If $t > -1 Then __TM_Deselect($t, 0)
			$TM_last[0] = __TM_Select($TM_mn_orig[$TM_show_2nd], $TM_show_2nd)
		EndIf
		Return
	EndIf
	If $TM_show = 1 Then __TM_ItemNotify(0)
EndFunc   ;==>__TM_Main

#EndRegion;--------__TM_Main
#Region;--------__TM_ItemNotify

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_ItemNotify ( $hRef )
	;#	Description....: Retrieves control on hover or click event.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_ItemNotify($hRef);wenn second, dann bleibt offen
	Local $info = GUIGetCursorInfo($TM_main_GUI[$hRef])
	If @error Then Return
	;------------------- case hover
	Local $t = $TM_last[$hRef], $n = $info[4]
	If $n > UBound($TM_IsIcon) - 2 Then Return $n
	If $TM_IsIcon[$n] Then $n = $TM_Itm[$hRef][$TM_IsIcon[$n] - 1]
	If $t <> $n Then ;	WinSetTitle($gui, "", $TM_origin[$n] & "-" & @SEC)
		If $t > -1 Then
			__TM_Deselect($t, $hRef);zusammen
			If $hRef = 0 And $TM_type[$n] <> $TM_show_2nd And $TM_show_2nd > 0 Then __TM_Hide($TM_show_2nd, $TM_Close_Delay)
		EndIf
		$TM_last[$hRef] = -1
		If GUICtrlRead($n) Then
			$TM_last[$hRef] = __TM_Select($n, $hRef)
			;------------------- case menuitem
			If $TM_type[$n] > 0 Then __TM_Show($n, $TM_Open_Delay);And $TM_Itm_cnt[$TM_type[$n]]
		EndIf
	EndIf
	;------------------- case click
	$g = DllCall("user32.dll", "int", "GetAsyncKeyState", "int", "0x0D")
	If $TM_show = 1 And $info[2] = 1 Or $info[3] = 1 Or (@error = 0 And $g[0]) Then
		__TM_Hide_all()
		If $TM_type[$n] = -1 And $TM_Radio_Auto_Mode Then
			;------------------- case radio
			Local $x = StringSplit($TM_origin[$n], ",")
			GUICtrlSetState($TM_UsrIcon[$n], 16)
			$TM_IsChecked[$n] = 1
			For $i = $x[2] - 1 To 0 Step -1
				If __TM_Radio($TM_Itm[$x[1]][$i]) Then ExitLoop
			Next
			For $i = $x[2] + 1 To $TM_Itm_cnt[$x[1]] - 1
				If __TM_Radio($TM_Itm[$x[1]][$i]) Then ExitLoop
			Next
		ElseIf $TM_Check_Auto_Mode Then
			;------------------- case check
			GUICtrlSetState($TM_UsrIcon[$n], 32)
			$TM_IsChecked[$n] = 0
		EndIf
	EndIf
	Return $n
EndFunc   ;==>__TM_ItemNotify

#EndRegion;--------__TM_ItemNotify
#Region;--------__TM_Select

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Select ( $t )
	;#	Description....: Selects item.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Select($t, $n);nur wenn icon sichtbar, einschränken
	If BitAND($TM_itm_sel[$t], 1) Then GUICtrlSetColor($t, $TM_itm_ft_col_2nd[$t])
	If BitAND($TM_itm_sel[$t], 2) Then GUICtrlSetBkColor($t, $TM_itm_bk_col_2nd[$t])
	If BitAND($TM_itm_sel[$t], 4) And BitAND(GUICtrlGetState($TM_UsrIcon[$t]), 16) Then __TM_IconSetImage($TM_main_GUI[$n], $TM_UsrIcon[$t], $TM_usr_icn_2nd[$t], $TM_usr_inm_2nd[$t], $TM_usr_icn_sz_2nd[$t])
	If BitAND($TM_itm_sel[$t], 8) And BitAND(GUICtrlGetState($TM_MenIcon[$t]), 16) Then __TM_IconSetImage($TM_main_GUI[$n], $TM_MenIcon[$t], $TM_men_icn_2nd[$t], $TM_men_inm_2nd[$t], $TM_men_icn_sz_2nd[$t])
	If BitAND($TM_itm_sel[$t], 16) Then GUICtrlSetFont($t, $TM_itm_ft_size_2nd[$t], $TM_itm_ft_width_2nd[$t], $TM_itm_ft_attr_2nd[$t], $TM_itm_ft_2nd[$t])
	If BitAND($TM_itm_sel[$t], 32) And BitAND(GUICtrlGetState($TM_itm_pic[$t]), 16) Then GUICtrlSetImage($TM_itm_pic[$t], $TM_itm_img_2nd[$t])
	If BitAND($TM_itm_sel[$t], 64) Then GUICtrlSetData($t, __TM_Pad($TM_itm_txt_2nd[$t], $TM_itm_pad_l_2nd[$t], $TM_itm_pad_r_2nd[$t]))
	If BitAND($TM_itm_sel[$t], 128) Then GUICtrlSetStyle($t, BitOR(768, $TM_itm_style_2nd[$t]))
	Return $t
EndFunc   ;==>__TM_Select

#EndRegion;--------__TM_Select
#Region;--------__TM_Deselect

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Deselect ( $t )
	;#	Description....: Deselects item.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Deselect($t, $n)
	If BitAND($TM_itm_sel[$t], 1) Then GUICtrlSetColor($t, $TM_itm_ft_col[$t])
	If BitAND($TM_itm_sel[$t], 2) Then GUICtrlSetBkColor($t, $TM_itm_bk_col[$t])
	If BitAND($TM_itm_sel[$t], 4) And BitAND(GUICtrlGetState($TM_UsrIcon[$t]), 16) Then __TM_IconSetImage($TM_main_GUI[$n], $TM_UsrIcon[$t], $TM_usr_icn[$t], $TM_usr_inm[$t], $TM_usr_icn_sz[$t])
	If BitAND($TM_itm_sel[$t], 8) And BitAND(GUICtrlGetState($TM_MenIcon[$t]), 16) Then __TM_IconSetImage($TM_main_GUI[$n], $TM_MenIcon[$t], $TM_men_icn[$t], $TM_men_inm[$t], $TM_men_icn_sz[$t])
	If BitAND($TM_itm_sel[$t], 16) Then GUICtrlSetFont($t, $TM_itm_ft_size[$t], $TM_itm_ft_width[$t], $TM_itm_ft_attr[$t], $TM_itm_ft[$t])
	If BitAND($TM_itm_sel[$t], 32) And BitAND(GUICtrlGetState($TM_itm_pic[$t]), 16) Then GUICtrlSetImage($TM_itm_pic, $TM_itm_img[$t])
	If BitAND($TM_itm_sel[$t], 64) Then GUICtrlSetData($t, __TM_Pad($TM_itm_txt[$t], $TM_itm_pad_l[$t], $TM_itm_pad_r[$t]))
	If BitAND($TM_itm_sel[$t], 128) Then GUICtrlSetStyle($t, BitOR(768, $TM_itm_style[$t]))
EndFunc   ;==>__TM_Deselect

#EndRegion;--------__TM_Deselect
#Region;--------__TM_Radio

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Radio ( $t )
	;#	Description....: Deselects radioitem.
	;#	Author ........: jennico
	;#	Date ..........: 6.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Radio($t)
	If $TM_type[$t] > -1 Then Return 1
	GUICtrlSetState($TM_UsrIcon[$t], 32)
	$TM_IsChecked[$t] = 0
EndFunc   ;==>__TM_Radio

#EndRegion;--------__TM_Radio
#Region;--------__TM_IconSetImage

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_IconSetImage ( $hWnd, $hctrl, $img, $nmr, $size )
	;#	Description....: Sets image to icon.
	;#	Author ........: jennico
	;#	Date ..........: 7.12.08
	;#  Remarks .......: internal use only.
	;#	??? maybe an AutoIt bug: on changing an icon image, the icon looses its position and size.
	;#===========================================================#
#ce

Func __TM_IconSetImage($hWnd, $hctrl, $img, $nmr, $size)
	Local $p = ControlGetPos($hWnd, "", $hctrl)
	If @error Then Return
	Local $q = $p[2] - $size
	GUICtrlSetState($hctrl, 32)
	GUICtrlSetImage($hctrl, $img, $nmr)
	If $p[0] = 2 Then
		ControlMove($hWnd, "", $hctrl, $p[0] + 2, $p[1] + $q / 2, $size, $size)
	Else
		ControlMove($hWnd, "", $hctrl, $p[0] + $q, $p[1] + $q / 2, $size, $size)
	EndIf
	GUICtrlSetState($hctrl, 16)
EndFunc   ;==>__TM_IconSetImage

#EndRegion;--------__TM_IconSetImage
#Region;--------__TM_Show_1st

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Show_1st ( )
	;#	Description....: Opens first level popup.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Show_1st();128 setonhover muss wieder unterbrochen werden -12 !
	Local $pos = MouseGetPos(), $x = $pos[0]
	WinActivate($TM_main_GUI[0])
	If $pos[0] + $TM_gui_w[0] + 2 * $TM_border + 2 > @DesktopWidth Then $x = $pos[0] - $TM_gui_w[0] - 2 * $TM_border
	WinMove($TM_main_GUI[0], "", $x, $pos[1] - $TM_gui_h[0] - $TM_border - 4, $TM_gui_w[0] + 2 * $TM_border, $TM_gui_h[0] + 2 * $TM_border)
	ControlMove($TM_main_GUI[0], "", $TM_gui_pic[0], $TM_SideBar_size[0], 0, $TM_gui_w[0] - $TM_SideBar_size[0], $TM_gui_h[0])
	GUICtrlSetState($TM_gui_pic[0], 16)
	If $TM_Shdw_Mode Then WinMove($TM_shdw_GUI[0], "", $x + 2 * $TM_border + 2, $pos[1] - $TM_gui_h[0] + $TM_border - 2, $TM_gui_w[0], $TM_gui_h[0])
	WinSetOnTop($TM_shdw_GUI[0], "", 1)
	$TM_show = 1
	While $TM_show
		Sleep(1)
		__TM_Main()
	WEnd
EndFunc   ;==>__TM_Show_1st

#EndRegion;--------__TM_Show_1st
#Region;--------__TM_Show

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Show ( $hRef [, $timeout])
	;#	Description....: Opens higher level popups.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Show($hRef, $timeout = "");$TM_Level	;erstmal nur eine ebene ! mit zweitem param noch eine ebene
	If $timeout Then
		Dim $TM_win2open = $hRef, $TM_open_timeout = $timeout, $TM_last_open = $hRef, $TM_open = TimerInit()
		Return
	EndIf
	Local $n = $TM_type[$hRef], $pos = ControlGetPos($TM_main_GUI[0], "", $hRef), $pos2 = WinGetPos($TM_main_GUI[0]), $x = $pos2[0] + $pos2[2] - 2 * $TM_border, $y = $pos[1] + $pos2[1], $t = $pos[1] + $pos[3] + $pos2[1] - $TM_gui_h[$n]
	If $x + $TM_gui_w[$n] + $TM_border + 2 > @DesktopWidth Then $x = $pos2[0] - $TM_gui_w[$n] - $TM_border
	If $y + $TM_gui_h[$n] + $TM_border > $pos2[1] + $pos2[3] And $t > 0 Then $y = $t;aber auch nur wenn nicht ganz oben
	WinMove($TM_main_GUI[$n], "", $x, $y, $TM_gui_w[$n] + 2 * $TM_border, $TM_gui_h[$n] + 2 * $TM_border)
	ControlMove($TM_main_GUI[$n], "", $TM_gui_pic[$n], $TM_SideBar_size[$n], 0, $TM_gui_w[$n] - $TM_SideBar_size[0], $TM_gui_h[$n])
	GUICtrlSetState($TM_gui_pic[$n], 16)
	If $TM_Shdw_Mode Then WinMove($TM_shdw_GUI[$n], "", $x + 2 * $TM_border + 2, $y + 2 * $TM_border + 2, $TM_gui_w[$n], $TM_gui_h[$n])
	WinSetOnTop($TM_shdw_GUI[$n], "", 1)
	$TM_show_2nd = $n
EndFunc   ;==>__TM_Show

#EndRegion;--------__TM_Show
#Region;--------__TM_Hide

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Hide ( $hRef [, $timeout])
	;#	Description....: Closes single higher level popups.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Hide($hRef, $timeout = "")
	If $timeout Then;wenn second, dann bleibt offen
		;If $hRef <> $TM_show_2nd And $TM_last[$hRef]=-1 Then;get
		Dim $TM_win2kill = $hRef, $TM_kill_timeout = $timeout, $TM_kill = TimerInit()
		Return
	EndIf
	Dim $TM_kill = "", $TM_show_2nd = 0
	WinMove($TM_main_GUI[$hRef], "", -1000, -1000)
	WinMove($TM_shdw_GUI[$hRef], "", -1000, -1000)
	If $TM_last[$hRef] = -1 Then Return
	GUICtrlSetBkColor($TM_last[$hRef], $TM_col_it_bk)
	GUICtrlSetColor($TM_last[$hRef], $TM_col_it_ft)
	$TM_last[$hRef] = -1
EndFunc   ;==>__TM_Hide

#EndRegion;--------__TM_Hide
#Region;--------__TM_Hide_all

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Hide_all ( )
	;#	Description....: Closes all popups.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Hide_all()
	For $i = 0 To $TM_gui_cnt
		__TM_Hide($i)
	Next
	$TM_show = 0
EndFunc   ;==>__TM_Hide_all

#EndRegion;--------__TM_Hide_all
#Region;--------__TM_Redim_Win

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Redim_Win ( $n )
	;#	Description....: Redims window properties.
	;#	Author ........: jennico
	;#	Date ..........: 8.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Redim_Win($n)
	ReDim $TM_main_GUI[$n], $TM_shdw_GUI[$n], $TM_Itm_w[$n], $TM_Itm_h[$n], $TM_gui_w[$n], $TM_gui_h[$n], $TM_Itm_cnt[$n], $TM_last[$n], $TM_mn_orig[$n], $TM_gui_pic[$n], $TM_gui_def_w[$n], $TM_gui_def_h[$n], $TM_gui_def_blk[$n], $TM_SideBar[$n], $TM_SideBar_size[$n], $TM_sb1[$n], $TM_sb2[$n], $TM_sb3[$n], $TM_sb4[$n], $TM_sb5[$n], $TM_sb6[$n], $TM_sb7[$n], $TM_sb8[$n], $TM_sb9[$n], $TM_sb0[$n]
	Return $n
EndFunc   ;==>__TM_Redim_Win

#EndRegion;--------__TM_Redim_Win
#Region;--------__TM_Redim_Item_1

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Redim_Item_1 ( $n )
	;#	Description....: Redims item properties.
	;#	Author ........: jennico
	;#	Date ..........: 8.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Redim_Item_1($n)
	ReDim $TM_type[$n], $TM_UsrIcon[$n], $TM_MenIcon[$n], $TM_usr_icn[$n], $TM_usr_inm[$n], $TM_usr_icn_2nd[$n], $TM_usr_inm_2nd[$n], $TM_men_icn[$n], $TM_men_inm[$n], $TM_men_icn_2nd[$n], $TM_men_inm_2nd[$n], $TM_Itm_height[$n], $TM_itm_style[$n], $TM_itm_style_2nd[$n], $TM_itm_pad_l[$n], $TM_itm_pad_r[$n], $TM_itm_pad_l_2nd[$n], $TM_itm_pad_r_2nd[$n]
	Return $n - 1
EndFunc   ;==>__TM_Redim_Item_1

#EndRegion;--------__TM_Redim_Item_1
#Region;--------__TM_Redim_Item_2

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Redim_Item_2 ( $n )
	;#	Description....: Redims item properties.
	;#	Author ........: jennico
	;#	Date ..........: 8.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Redim_Item_2($m)
	ReDim $TM_origin[$m], $TM_itm_ft_col_2nd[$m], $TM_itm_bk_col_2nd[$m], $TM_itm_ft_col[$m], $TM_itm_bk_col[$m], $TM_itm_sel[$m], $TM_itm_txt[$m], $TM_itm_txt_2nd[$m], $TM_itm_ft[$m], $TM_itm_ft_attr[$m], $TM_itm_ft_size[$m], $TM_itm_ft_width[$m], $TM_itm_ft_2nd[$m], $TM_itm_ft_attr_2nd[$m], $TM_itm_ft_size_2nd[$m], $TM_itm_ft_width_2nd[$m], $TM_itm_pic[$m], $TM_itm_img[$m], $TM_itm_img_2nd[$m], $TM_IsChecked[$m], $TM_usr_icn_sz[$m], $TM_men_icn_sz[$m], $TM_usr_icn_sz_2nd[$m], $TM_men_icn_sz_2nd[$m]
EndFunc   ;==>__TM_Redim_Item_2

#EndRegion;--------__TM_Redim_Item_2
#Region;--------__TM_Measure_Item

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Measure_Item ( $hRef, $hCnt )
	;#	Description....: Measures items according to max text length and height.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#					 uses _WinAPI_GetTextExtentPoint32.
	;#===========================================================#
#ce

Func __TM_Measure_Item($hRef, $hCnt);noch individuell
	Local $i = $TM_Itm[$hRef][$hCnt];nicht ganz korrekt so !
	If $TM_Itm_def_w > 0 And $TM_Itm_height[$i] > 0 Then Return $TM_Itm_height[$i]
	Local $hWnd = GUICtrlGetHandle($i), $sText = GUICtrlRead($i), $hDC = DllCall("User32.dll", "hwnd", "GetDC", "hwnd", $hWnd), $hMsg = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hWnd, "int", 49, "wparam", 0, "lparam", 0)
	DllCall("GDI32.dll", "hwnd", "SelectObject", "hwnd", $hDC[0], "hwnd", $hMsg[0])
	DllCall("GDI32.dll", "int", "GetTextExtentPoint32", "hwnd", $hDC[0], "str", $sText, "int", StringLen($sText), "ptr", DllStructGetPtr($TM_Size))
	Local $x = DllStructGetData($TM_Size, "X"), $y = DllStructGetData($TM_Size, "Y") + 1
	DllCall("User32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "hwnd", $hDC[0])
	If $TM_Itm_def_w > 0 Then $x = $TM_Itm_def_w
	If $x > $TM_Itm_w[$hRef] Then $TM_Itm_w[$hRef] = $x
	If $TM_Itm_height[$i] > 0 Then Return $TM_Itm_height[$i]
	If $TM_Itm_def_h > 0 Then $y = $TM_Itm_def_h
	If $y > $TM_Itm_h[$hRef] Then $TM_Itm_h[$hRef] = $y
	Return $y
EndFunc   ;==>__TM_Measure_Item

#EndRegion;--------__TM_Measure_Item
#Region;--------__TM_Resize_Win

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Resize_Win ( $hRef [, $mode] )
	;#	Description....: Calculates the popup size according to all its menu entries sizes and reorders the controls.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Resize_Win($hRef, $mode = 0)
	$TM_gui_h[$hRef] = 0
	Local $g = $TM_main_GUI[$hRef], $w = $TM_Itm_w[$hRef], $s = $TM_SideBar_size[$hRef], $h, $t, $u, $m
	For $i = 0 To $TM_Itm_cnt[$hRef] - 1
		Dim $t = $TM_Itm[$hRef][$i], $h = $TM_Itm_height[$t], $u = $TM_usr_icn_sz[$t], $m = $TM_men_icn_sz[$t]
		If GUICtrlRead($t) = "" Then
			;------------------- case separator
			ControlMove($g, "", $TM_Itm_top[$hRef][$i], $s + 1, $TM_gui_h[$hRef] + $h / 2 - 1, $w - 2, 1)
			ControlMove($g, "", $TM_Itm_bot[$hRef][$i], $s + 1, $TM_gui_h[$hRef] + $h / 2, $w - 2, 1)
		EndIf
		ControlMove($g, "", $t, $s, $TM_gui_h[$hRef], $w, $h)
		ControlMove($g, "", $TM_itm_pic[$t], $s, $TM_gui_h[$hRef], $w, $h)
		ControlMove($g, "", $TM_UsrIcon[$t], $s + 2, $TM_gui_h[$hRef] + ($h - $u) / 2, $u, $u)
		ControlMove($g, "", $TM_MenIcon[$t], $s + $w - $m - 2, $TM_gui_h[$hRef] + ($h - $m) / 2, $m, $m)
		$TM_gui_h[$hRef] += $h
	Next
	$TM_gui_w[$hRef] = $s + $w
	If $TM_SideBar[$hRef] And $mode = 0 Then __TM_Create_Sidebar($hRef, $s, $TM_sb1[$hRef], $TM_sb2[$hRef], $TM_sb3[$hRef], $TM_sb4[$hRef], $TM_sb5[$hRef], $TM_sb6[$hRef], $TM_sb7[$hRef], $TM_sb8[$hRef], $TM_sb9[$hRef], $TM_sb0[$hRef], 1)
EndFunc   ;==>__TM_Resize_Win

#EndRegion;--------__TM_Resize_Win
#Region;--------__TM_Create_Sidebar

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Create_Sidebar ( $s_ID, $iW, $nText, $iAngle, $pos, $gradcolor, $idirection, $nFontName, $nFontSize, $iStyle, $ifontcolor, $ialpha [, $mode] )
	;#	Description....: Creates sidebar.
	;#	Author ........: jennico
	;#	Date ..........: 14.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Create_Sidebar($s_ID, $iW, $nText, $iAngle, $pos, $gradcolor, $idirection, $nFontName, $nFontSize, $iStyle, $ifontcolor, $ialpha, $mode = 0)
	Local $ghGDIPDll = DllOpen("GDIPlus.dll")
	If $ghGDIPDll = -1 Then Return
	DllStructSetData($TM_Input, "Version", 1)
	DllCall($ghGDIPDll, "int", "GdiplusStartup", "ptr", DllStructGetPtr($TM_Token), "ptr", DllStructGetPtr($TM_Input), "ptr", 0)
	If @error Then Return
	$TM_SideBar_size[$s_ID] = $iW
	$TM_sb1[$s_ID] = $nText
	$TM_sb2[$s_ID] = $iAngle
	$TM_sb3[$s_ID] = $pos
	$TM_sb4[$s_ID] = $gradcolor
	$TM_sb5[$s_ID] = $idirection
	$TM_sb6[$s_ID] = $nFontName
	$TM_sb7[$s_ID] = $nFontSize
	$TM_sb8[$s_ID] = $iStyle
	$TM_sb9[$s_ID] = $ifontcolor
	$TM_sb0[$s_ID] = $ialpha
	If $TM_SideBar[$s_ID] Then GUICtrlDelete($TM_SideBar[$s_ID])
	If $mode = 0 Then __TM_Resize_Win($s_ID, 1)
	GUISwitch($TM_main_GUI[$s_ID])
	$TM_SideBar[$s_ID] = GUICtrlCreatePic("", 0, 0, $iW, $TM_gui_h[$s_ID])
	GUICtrlSetState(-1, 128);?
	;
	Local $aBlend = StringSplit($gradcolor, "|"), $count = $aBlend[0]
	Local $tPositions = DllStructCreate("float[" & $count & "]"), $tBlend = DllStructCreate("int[" & $count & "]")
	Local $pPositions = DllStructGetPtr($tPositions), $pBlend = DllStructGetPtr($tBlend)
	Local $hBitmap = DllCall("GDI32.dll", "hwnd", "CreateBitmap", "int", $iW, "int", $TM_gui_h[$s_ID], "int", 1, "int", 32, "ptr", 0)
	Local $hImage = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "hwnd", $hBitmap[0], "hwnd", 0, "int*", 0)
	Local $hGraphic = DllCall($ghGDIPDll, "int", "GdipGetImageGraphicsContext", "hwnd", $hImage[3], "int*", 0)
	For $i = 0 To $count - 1
		DllStructSetData($tPositions, 1, $i / ($count - 1), $i + 1)
		DllStructSetData($tBlend, 1, BitOR(0xFF000000, $aBlend[$i + 1]), $i + 1);auch alpha
	Next
	__TM_DLLStructSetData(0, 0, $iW, $TM_gui_h[$s_ID])
	Local $hBLin = DllCall($ghGDIPDll, "int", "GdipCreateLineBrushFromRect", "ptr", DllStructGetPtr($TM_Rect), "int", $count, "int", BitOR(0xFF000000, $aBlend[$count]), "int", $idirection, "int", 0, "int*", 0)
	DllCall($ghGDIPDll, "int", "GdipSetLineBlend", "hwnd", $hBLin[6], "ptr", $tPositions, "ptr", $pPositions, "int", $count)
	DllCall($ghGDIPDll, "int", "GdipSetLinePresetBlend", "hwnd", $hBLin[6], "int", $pBlend, "ptr", $pPositions, "int", $count)
	DllCall($ghGDIPDll, "int", "GdipFillRectangleI", "hwnd", $hGraphic[2], "hwnd", $hBLin[6], "int", 0, "int", 0, "int", $iW, "int", $TM_gui_h[$s_ID])
	;
	Local $hFormat = DllCall($ghGDIPDll, "int", "GdipCreateStringFormat", "int", 0, "short", 0, "int*", 0)
	Local $hFamily = DllCall($ghGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $nFontName, "ptr", 0, "int*", 0)
	DllStructSetData($TM_Float, 1, $nFontSize)
	Local $hFont = DllCall($ghGDIPDll, "int", "GdipCreateFont", "hwnd", $hFamily[3], "int", DllStructGetData($TM_Int, 1), "int", $iStyle, "int", 3, "int*", 0)
	; #FUNCTION# ====================================================================================================================
	; Syntax.........: _GDIPlus_FontCreate($hFamily, $nSize[, $iStyle = 0[, $iUnit = 3]])
	;                  $iUnit       - Unit of measurement for the font size:
	;                  |0 - World coordinates, a nonphysical unit
	;                  |1 - Display units
	;                  |2 - A unit is 1 pixel
	;                  |3 - A unit is 1 point or 1/72 inch	; 	default
	;                  |4 - A unit is 1 inch
	;                  |5 - A unit is 1/300 inch
	;                  |6 - A unit is 1 millimeter
	; ===============================================================================================================================
	__TM_DLLStructSetData($iW / 2, $TM_gui_h[$s_ID] / 2, 0, 0)
	DllCall($ghGDIPDll, "int", "GdipMeasureString", "hwnd", $hGraphic[2], "wstr", $nText, "int", -1, "hwnd", $hFont[5], "ptr", DllStructGetPtr($TM_Rect), "hwnd", $hFormat[3], "ptr", DllStructGetPtr($TM_Rect), "int*", 0, "int*", 0)
	Local $iWidth = Ceiling(DllStructGetData($TM_Rect, "Width")), $iHeight = Ceiling(DllStructGetData($TM_Rect, "Height")), $iXt, $iYt
	If $iAngle = 1 Then
		$iAngle = 1119092736
		Dim $iYt = ($iW - $iHeight) / 2 - $iW
		If $pos = -1 Then $iXt = ($TM_gui_h[$s_ID] - $iWidth) / 2
		If $pos = -2 Then $iXt = $TM_gui_h[$s_ID] - $iWidth
		If $pos = -3 Then $iXt = 0
		If $pos = -4 Then $iXt = $TM_gui_h[$s_ID] - $iWidth - ($iW - $iHeight) / 2
		If $pos > -1 Then $iXt = $TM_gui_h[$s_ID] - $iWidth - $pos
	Else
		$iAngle = 1132920832
		Dim	$iYt = ($iW - $iHeight) / 2
		If $pos = -1 Then $iXt = ($TM_gui_h[$s_ID] - $iWidth) / 2 - $TM_gui_h[$s_ID]
		If $pos = -2 Then $iXt = 0 - $TM_gui_h[$s_ID]
		If $pos = -3 Then $iXt = 0 - $iWidth
		If $pos = -4 Then $iXt = $iYt - $TM_gui_h[$s_ID]
		If $pos > -1 Then $iXt = $pos - $TM_gui_h[$s_ID]
	EndIf
	Local $hMatrix = DllCall($ghGDIPDll, "int", "GdipCreateMatrix", "int*", 0)
	DllCall($ghGDIPDll, "int", "GdipRotateMatrix", "hwnd", $hMatrix[1], "int", $iAngle, "int", 1)
	DllCall($ghGDIPDll, "int", "GdipSetWorldTransform", "hwnd", $hGraphic[2], "hwnd", $hMatrix[1])
	Local $hBrush = DllCall($ghGDIPDll, "int", "GdipCreateSolidFill", "int", BitOR(BitShift($ialpha, -24), $ifontcolor), "int*", 0)
	__TM_DLLStructSetData($iXt, $iYt, $iWidth, $iWidth)
	DllCall($ghGDIPDll, "int", "GdipDrawString", "hwnd", $hGraphic[2], "wstr", $nText, "int", -1, "hwnd", $hFont[5], "ptr", DllStructGetPtr($TM_Rect), "hwnd", $hFormat[3], "hwnd", $hBrush[2])
	;
	Local $hbmp = DllCall($ghGDIPDll, "int", "GdipCreateHBITMAPFromBitmap", "hwnd", $hImage[3], "int*", 0, "int", 0xFF000000)
	Local $aBmp = DllCall("user32.dll", "hwnd", "SendMessage", "hwnd", GUICtrlGetHandle($TM_SideBar[$s_ID]), "int", 0x0172, "int", 0, "int", $hbmp[2])
	DllCall("User32.dll", "int", "RedrawWindow", "hwnd", $s_ID, "ptr", 0, "int", 0, "int", 0x501)
	If $aBmp[0] <> 0 Then DllCall("GDI32.dll", "int", "DeleteObject", "int", $aBmp[0])
	DllCall($ghGDIPDll, "int", "GdipDeleteStringFormat", "hwnd", $hFormat[3])
	DllCall($ghGDIPDll, "int", "GdipDeleteFontFamily", "hwnd", $hFamily)
	DllCall($ghGDIPDll, "int", "GdipDeleteGraphics", "hwnd", $hGraphic[2])
	DllCall($ghGDIPDll, "int", "GdipDeleteMatrix", "hwnd", $hMatrix[1])
	DllCall($ghGDIPDll, "int", "GdipDeleteBrush", "hwnd", $hBrush[2])
	DllCall($ghGDIPDll, "int", "GdipDeleteBrush", "hwnd", $hBLin[6])
	DllCall($ghGDIPDll, "int", "GdipDeleteFont", "hwnd", $hFont[5])
	DllCall("GDI32.dll", "int", "DeleteObject", "int", $hbmp[2])
	DllCall("GDI32.dll", "int", "DeleteObject", "int", $hBitmap[0])
	DllCall($ghGDIPDll, "int", "GdipDisposeImage", "hwnd", $hImage[3])
	DllCall($ghGDIPDll, "none", "GdiplusShutdown", "ptr", DllStructGetData($TM_Token, "Data"))
	DllClose($ghGDIPDll)
	Return 1;$TM_SideBar[$s_ID]
EndFunc   ;==>__TM_Create_Sidebar

#EndRegion;--------__TM_Create_Sidebar
#Region;--------__TM_Resize

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Resize ( $x )
	;#	Description....: Resizes level.
	;#	Author ........: jennico
	;#	Date ..........: 10.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Resize($x)
	$TM_gui_w[$x[1]] = $TM_Itm_def_w;in die funktion, indiv.
	For $i = 0 To $TM_Itm_cnt[$x[1]]
		__TM_Measure_Item($x[1], $x[2])
	Next
	__TM_Resize_Win($x[1])
EndFunc   ;==>__TM_Resize

#EndRegion;--------__TM_Resize
#Region;--------__TM_Shadow

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Shadow ( $x )
	;#	Description....: Creates the popups' shadows.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_Shadow($x)
	GUISetState(@SW_SHOW, $TM_main_GUI[$x])
	If $TM_Shdw_Mode = 0 Then Return
	GUISetBkColor($TM_shdw_col, $TM_shdw_GUI[$x])
	WinSetTrans($TM_shdw_GUI[$x], "", $TM_shdw_trans)
	GUISetState(@SW_SHOW, $TM_shdw_GUI[$x])
EndFunc   ;==>__TM_Shadow

#EndRegion;--------__TM_Shadow
#Region;--------__TM_Pad

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Pad ( $txt, $x, $y )
	;#	Description....: Left and right pads given text.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#					 one space is appr. 3 px.
	;#===========================================================#
#ce

Func __TM_Pad($txt, $x, $y)
	$txt = StringFormat("%-" & $y + StringLen($txt) & "s", $txt)
	Return StringFormat("%" & $x + StringLen($txt) & "s", $txt)
EndFunc   ;==>__TM_Pad

#EndRegion;--------__TM_Pad
#Region;--------__TM_SetFont

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_SetFont ( $i, $size, $width, $attr, $name )
	;#	Description....: Sets font for a given level.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_SetFont($i, $size, $width, $attr, $name)
	$TM_gui_w[$i] = $TM_Itm_def_w
	For $j = 0 To $TM_Itm_cnt[$i] - 1
		$t = $TM_Itm[$i][$j]
		$TM_itm_ft_size[$t] = $size
		$TM_itm_ft_width[$t] = $width
		$TM_itm_ft_attr[$t] = $attr
		$TM_itm_ft[$t] = $name
		GUICtrlSetFont($t, $size, $width, $attr, $name)
		__TM_Measure_Item($i, $j)
	Next
	__TM_Resize_Win($i)
EndFunc   ;==>__TM_SetFont

#EndRegion;--------__TM_SetFont
#Region;--------__TM_SetSelFont

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_SetSelFont ( $i, $size, $width, $attr, $name )
	;#	Description....: Sets selected font for a given level.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_SetSelFont($i, $size, $width, $attr, $name)
	For $j = 0 To $TM_Itm_cnt[$i] - 1
		$t = $TM_Itm[$i][$j]
		$TM_itm_ft_size_2nd[$t] = $size
		$TM_itm_ft_width_2nd[$t] = $width
		$TM_itm_ft_attr_2nd[$t] = $attr
		$TM_itm_ft_2nd[$t] = $name
	Next
EndFunc   ;==>__TM_SetSelFont

#EndRegion;--------__TM_SetSelFont
#Region;--------__TM_SetOnEvent

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_SetOnEvent ( $x )
	;#	Description....: Determines which action opens tray menu.
	;#	Author ........: jennico
	;#	Date ..........: 27.11.08
	;#  Remarks .......: internal use only.
	;#					 uses TraySetOnEvent
	;#===========================================================#
#ce

Func __TM_SetOnEvent($x, $y)
	TraySetOnEvent($y, "__TM_Show_1st")
	Return $x
EndFunc   ;==>__TM_SetOnEvent

#EndRegion;--------__TM_SetOnEvent
#Region;--------__TM_GetPos

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_GetPos ( $x )
	;#	Description....: Retrieves item position.
	;#	Author ........: jennico
	;#	Date ..........: 5.12.08
	;#  Remarks .......: internal use only.
	;#					 returns popup number and entry number.
	;#===========================================================#
#ce

Func __TM_GetPos($x)
	If $x = -1 Then Return StringSplit($TM_last_created, ",")
	Return StringSplit($TM_origin[$x], ",")
	Return StringSplit("", "")
EndFunc   ;==>__TM_GetPos

#EndRegion;--------__TM_GetPos
#Region;--------__TM_GetMenu

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_GetMenu ( $x )
	;#	Description....: Retrieves level from menu / item ID.
	;#	Author ........: jennico
	;#	Date ..........: 4.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_GetMenu($x)
	If $TM_type[$x] > 0 Then
		Return $TM_type[$x]
	Else
		$x = StringSplit($TM_origin[$x], ",")
		If $x[0] = 2 Then Return $x[1]
	EndIf
	Return -1
EndFunc   ;==>__TM_GetMenu

#EndRegion;--------__TM_GetMenu
#Region;--------__TM_DLLStructSetData

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_DLLStructSetData ( $x, $y, $w, $h )
	;#	Description....: Sets Data to rectangle structure.
	;#	Author ........: jennico
	;#	Date ..........: 14.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce

Func __TM_DLLStructSetData($x, $y, $w, $h)
	DllStructSetData($TM_Rect, "X", $x)
	DllStructSetData($TM_Rect, "Y", $y)
	DllStructSetData($TM_Rect, "Width", $w)
	DllStructSetData($TM_Rect, "Height", $h)
EndFunc   ;==>__TM_DLLStructSetData

#EndRegion;--------__TM_DLLStructSetData
#EndRegion;--------------------------Internal Functions
#Region;--------------------------Appendix / Notes / ToDo
#Region;--------__TM_Interrupt

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Interrupt ( $hWndGUI, $MsgID )
	;#	Description....: Interrupts when parent window is closing.
	;#	Author ........: jennico
	;#	Date ..........: 12.12.08
	;#  Remarks .......: internal use only.
	;# 					 not working yet.
	;#===========================================================#
#ce

Func __TM_Interrupt($hWndGUI, $MsgID)
	;	MsgBox(0,$hWndGUI,$MsgID)
	__TM_Hide_all()
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>__TM_Interrupt

#EndRegion;--------__TM_Interrupt
#Region;--------_TrayMenu_SetCBFrequency;nicht mehr

#cs
	;#=#Function#================================================#
	;#	Name ..........: _TrayMenu_SetCBFrequency ( [ freq ] )
	;#	Description....: Sets the callback frequency for __TM_main.
	;# 	Parameters.....: freq [optional] = Callback frequency in ms (Default is 50).
	;#  Return Value ..: Returns 1.
	;#	Author ........: jennico
	;#	Date ..........: 3.12.08
	;#  Remarks .......: Use _TrayMenu_SetCBFrequency() to reset the default.
	;#	Related........: none.
	;#	Example........: yes
	;#===========================================================#
#ce

Func _TrayMenu_SetCBFrequency($x = 50)
	$TM_timer = DllCall("user32.dll", "int", "SetTimer", "hwnd", $TM_main_GUI[0], "int", $TM_timer, "int", $x, "ptr", DllCallbackGetPtr(DllCallbackRegister("__TM_Main", "none", "hwnd;int;int;dword")))
	;	$TM_timer = __TM_SetTimer()
	Return 1
EndFunc   ;==>_TrayMenu_SetCBFrequency

#EndRegion;--------_TrayMenu_SetCBFrequency

;Global $TM_timer = DllCall("user32.dll", "int", "SetTimer", "hwnd", $TM_main_GUI[0], "int", 1001, "int", $TM_Frequency, "ptr", DllCallbackGetPtr (DllCallbackRegister ("__TM_Main", "none", "hwnd;int;int;dword")))

Func _TrayMenu_SetFlashIntervall($x)
	;settimer
EndFunc   ;==>_TrayMenu_SetFlashIntervall


;**********************************************************************
; Get the icon ID like in newer Autoit versions
;**********************************************************************
Func _GetIconID($nID, $sFile)
	If StringRight($sFile, 4) = ".exe" Then
		If $nID < 0 Then
			$nID = -($nID + 1)
		ElseIf $nID > 0 Then
			$nID = -$nID
		EndIf
	ElseIf StringRight($sFile, 4) = ".icl" And $nID < 0 Then
		$nID = -($nID + 1)
	Else
		If $nID > 0 Then
			$nID = -$nID
		ElseIf $nID < 0 Then
			$nID = -($nID + 1)
		EndIf
	EndIf
	
	Return $nID
EndFunc   ;==>_GetIconID

#Region;--------__TM_Resize_Icon;nicht mehr benötigt

#cs
	;#=#Function#================================================#
	;#	Name ..........: __TM_Resize_Icon ( $x, $y )
	;#	Description....: Resizes user icons.
	;#	Author ........: jennico
	;#	Date ..........: 6.12.08
	;#  Remarks .......: internal use only.
	;#===========================================================#
#ce
Func __TM_Resize_Icon($x, $y)
	Local $pos = ControlGetPos($TM_main_GUI[$x], "", $TM_Itm[$x][$y])
	ControlMove($TM_main_GUI[$x], "", $TM_UsrIcon[$TM_Itm[$x][$y]], 2, $pos[1] + ($pos[3] - $TM_def_usr_ISz) / 2, $TM_def_usr_ISz, $TM_def_usr_ISz)
EndFunc   ;==>__TM_Resize_Icon

#EndRegion;--------__TM_Resize_Icon
#Region;--------__TM_Create_Item
;	_WinAPI_DrawIcon
;	_WinAPI_DrawIconEx
;	http://msdn.microsoft.com/en-us/library/bb773289(VS.85).aspx
;	http://msdn.microsoft.com/en-us/library/ms534865(VS.85).aspx
;	display device contexts
#EndRegion;--------__TM_Create_Item

Global Const $STD_CUT = 0
Global Const $STD_COPY = 1
Global Const $STD_PASTE = 2
Global Const $STD_UNDO = 3
Global Const $STD_REDOW = 4
Global Const $STD_DELETE = 5
Global Const $STD_FILENEW = 6
Global Const $STD_FILEOPEN = 7
Global Const $STD_FILESAVE = 8
Global Const $STD_PRINTPRE = 9
Global Const $STD_PROPERTIES = 10
Global Const $STD_HELP = 11
Global Const $STD_FIND = 12
Global Const $STD_REPLACE = 13
Global Const $STD_PRINT = 14

Func DrawFrameControl($hDC, $ptrRect, $nType, $nState)
	Local $bResult = DllCall($hUser32Dll, "int", "DrawFrameControl", _
			"hwnd", $hDC, _
			"ptr", $ptrRect, _
			"int", $nType, _
			"int", $nState)
	Return $bResult[0]
EndFunc   ;==>DrawFrameControl


#cs
	$gui = GUICreate("")
	$pic = GUICtrlCreatePic("",0,0,200,200)
	
	GUISetState()
	
	SetBitmapResourceToPicCtrl($gui,$pic,"c:\myfile.exe",47)
	
	While 1
	If GUIGetMsg() = -3 Then Exit
	WEnd
	
	Func SetBitmapResourceToPicCtrl($hwnd,$ctrl,$file,$resource)
	Local Const $STM_SETIMAGE = 0x0172
	Local Const $IMAGE_BITMAP = 0
	Local Const $LR_CREATEDIBSECTION = 0x2000
	Local $A = ControlGetHandle($hwnd,"",$ctrl)
	Local $DLLinst = DLLCall("kernel32.dll","hwnd","LoadLibrary","str",$file)
	$DLLinst = $DLLinst[0]
	Local $hBitmap = DLLCall("user32.dll","hwnd","LoadImage","hwnd",$DLLinst,"short",$resource, _
	"int",$IMAGE_BITMAP,"int",0,"int",0,"int",0)
	$hBitmap = $hBitmap[0]
	_SendMessage($A,$STM_SETIMAGE,$IMAGE_BITMAP,$hBitmap);
	DLLCall("gdi32.dll","int","DeleteObject","hwnd",$hBitmap)
	DLLCall("kernel32.dll","int","FreeLibrary","hwnd",$DLLinst)
	EndFunc
	
	Func _SendMessage($hWnd, $msg, $wParam = 0, $lParam = 0, $r = 0, $t1 = "int", $t2 = "int")
	Local $ret = DllCall("user32.dll", "long", "SendMessage", "hwnd", $hWnd, "int", $msg, $t1, $wParam, $t2, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $r >= 0 And $r <= 4 Then Return $ret[$r]
	Return $ret
	EndFunc ; _SendMessage()
#ce

#cs
	#include <GUIConstants.au3>
	#include <WinAPI.au3>
	
	$IMAGE_BITMAP=0
	$LR_DEFAULTCOLOR = 0
	
	$Form1 = GUICreate("", 400, 400)
	$pic = GUICtrlCreatePic("", 0, 20, 400, 380)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$b1 = GUICtrlCreateButton("Change Pic", 150, 0, 100, 20)
	GUISetState(@SW_SHOW)
	Global $i = 0, $aBitmaps[46] = [130,131,133,134,135,136,137,138,140,141,142,143, 14351,14353,14354,14355,14356, 145,146,147,148,149,204,205,206,207,214,215,216,217,225,226,227,228,230,231,240,241,242,245,246,247, 309,310,369,390]
	While 1
	Switch GuiGetMsg()
	Case $GUI_EVENT_CLOSE
	ExitLoop
	Case $b1
	GUICtrlSetImageFromDLL($pic, 'shell32.dll', $aBitmaps[$i])
	$i += 1
	If $i = UBound($aBitmaps)-1 Then $i = 0
	EndSwitch
	WEnd
#ce

Func GUICtrlSetImageFromDLL($controlID, $filename, $imageIndex)
	Local Const $STM_SETIMAGE = 0x0172

	$hLib = _WinAPI_LoadLibrary($filename)
	$hbmp = _WinAPI_LoadImage($hLib, $imageIndex, $IMAGE_BITMAP, 0, 0, $LR_DEFAULTCOLOR)
	GUICtrlSendMsg($controlID, $STM_SETIMAGE, $IMAGE_BITMAP, $hbmp)
	_WinAPI_FreeLibrary($hLib)
	_WinAPI_DeleteObject($hbmp)
EndFunc   ;==>GUICtrlSetImageFromDLL

#cs
	0 = Tray menu will never be shown through a mouseclick
	1 = Pressing primary mouse button
	2 = Releasing primary mouse button
	4 = Pressing double primary mouse button
	8 = Pressing secondary mouse button
	16 = Releasing secondary mouse button
	32 = Pressing double secondary mouse button
	64 = Releasing or pressing any mouse button
	128 = Mouse hovers over icon
	256 = MouseOut 	!!!
	
	$TRAY_EVENT_SHOWICON -3 The tray icon will be shown.
	$TRAY_EVENT_HIDEICON -4 The tray icon will be hidden.
	$TRAY_EVENT_FLASHICON -5 The user turned the tray icon flashing on.
	$TRAY_EVENT_NOFLASHICON -6 The user turned the tray icon flashing off.
	$TRAY_EVENT_PRIMARYDOWN -7 The primary mouse button was pressed on the tray icon.
	$TRAY_EVENT_PRIMARYUP -8 The primary mouse button was released on the tray icon.
	$TRAY_EVENT_SECONDARYDOWN -9 The secondary mouse button was pressed on the tray icon.
	$TRAY_EVENT_SECONDARYUP -10 The secondary mouse button was released on the tray icon.
	$TRAY_EVENT_MOUSEOVER -11 The mouse moves over the tray icon.
	$TRAY_EVENT_MOUSEOUT = -12	!!!!
	$TRAY_EVENT_PRIMARYDOUBLE -13 The primary mouse button was double pressed on the tray icon.
	$TRAY_EVENT_SECONDARYDOUBLE -14 The secondary mouse button was double pressed on the tray icon.
#ce

;Global $TM_timer = DllCall("user32.dll", "uint", "SetTimer", "hwnd", $TM_main_GUI[0], "uint", 1001, "uint", $TM_Frequency, "ptr", "__TM_Main")

Func SetTimer($hWnd, $nID, $nTimeOut, $pFunc)
	Local $nResult = DllCall($hUser32Dll, "uint", "SetTimer", _
			"hwnd", $hWnd, _
			"uint", $nID, _
			"uint", $nTimeOut, _
			"ptr", $pFunc)
	Return $nResult[0]
EndFunc   ;==>SetTimer


Func KillTimer($hWnd, $nID)
	Local $nResult = DllCall($hUser32Dll, "int", "KillTimer", _
			"hwnd", $hWnd, _
			"uint", $nID)
	Return $nResult[0]
EndFunc   ;==>KillTimer

Func __TM_SetTimer()
	;	Local $hCallBack, $pTimerFunc, $iResult
	;	If Not $TM_timer Then
	;		$TM_timer = 1001
	;		$hCallBack = DllCallbackRegister ("__TM_Main", "none", "hwnd;int;int;dword")
	;	EndIf
	;	$pTimerFunc = DllCallbackGetPtr ($hCallBack)
	;	$iResult = DllCall("user32.dll", "int", "SetTimer", "hwnd", $TM_main_GUI[0], "int", $TM_timer, "int", $TM_Frequency, "ptr", $pTimerFunc)
	;	Return $iResult[0]
EndFunc   ;==>__TM_SetTimer

#cs
	If $nIconIndex > -1 Then
	If Not $bChecked Then
	If $bGrayed Then
	; An easy way to draw something that looks deactivated
	ImageList_DrawEx($hMenuImageList, $nIconIndex, $hDC, $nSpace + $nSideWidth, DllStructGetData($stItemRect, 2) + 2, 0, 0, 0xFFFFFFFF, 0xFFFFFFFF, BitOr(0x0004, 0x0001))
	Else
	; Draw the icon "normal"
	ImageList_Draw($hMenuImageList, $nIconIndex, $hDC, $nSpace + $nSideWidth, DllStructGetData($stItemRect, 2) + 2, 0x0001)
	EndIf
	EndIf
	EndIf
#ce

Global $hComctl32Dll = DllOpen("comctl32.dll")
Global $hGdi32Dll = DllOpen("gdi32.dll")
Global $hKernel32Dll = DllOpen("kernel32.dll")
Global $hShell32Dll = DllOpen("shell32.dll")
Global $hUser32Dll = DllOpen("user32.dll")
Global $hMsimg32Dll = DllOpen("msimg32.dll")



Func ImageList_Draw($hIml, $nIndex, $hDC, $nX, $nY, $nStyle)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_Draw", _
			"hwnd", $hIml, _
			"int", $nIndex, _
			"hwnd", $hDC, _
			"int", $nX, _
			"int", $nY, _
			"int", $nStyle)
	Return $bResult[0]
EndFunc   ;==>ImageList_Draw

Func ImageList_DrawEx($hIml, $nIndex, $hDC, $nX, $nY, $nDx, $nDy, $nBkClr, $nFgClr, $nStyle)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_DrawEx", _
			"hwnd", $hIml, _
			"int", $nIndex, _
			"hwnd", $hDC, _
			"int", $nX, _
			"int", $nY, _
			"int", $nDx, _
			"int", $nDy, _
			"int", $nBkClr, _
			"int", $nFgClr, _
			"int", $nStyle)
	Return $bResult[0]
EndFunc   ;==>ImageList_DrawEx

;********************************************************************
; Fill background rect with gradient colors
;********************************************************************
Func _FillGradientRect($hDC, $stRect, $nClr1, $nClr2, $bVert = False)
	Local $stVert = DllStructCreate("long;long;ushort;ushort;ushort;ushort;" & _
			"long;long;ushort;ushort;ushort;ushort")
	
	DllStructSetData($stVert, 1, DllStructGetData($stRect, 1))
	DllStructSetData($stVert, 2, DllStructGetData($stRect, 2))
	DllStructSetData($stVert, 3, BitShift(_ColorGetClr($nClr1, 3), -8))
	DllStructSetData($stVert, 4, BitShift(_ColorGetClr($nClr1, 2), -8))
	DllStructSetData($stVert, 5, BitShift(_ColorGetClr($nClr1, 1), -8))
	DllStructSetData($stVert, 6, 0)
	
	DllStructSetData($stVert, 7, DllStructGetData($stRect, 3))
	DllStructSetData($stVert, 8, DllStructGetData($stRect, 4))
	DllStructSetData($stVert, 9, BitShift(_ColorGetClr($nClr2, 3), -8))
	DllStructSetData($stVert, 10, BitShift(_ColorGetClr($nClr2, 2), -8))
	DllStructSetData($stVert, 11, BitShift(_ColorGetClr($nClr2, 1), -8))
	DllStructSetData($stVert, 12, 0)
	
	Local $stGradRect = DllStructCreate("ulong;ulong")
	DllStructSetData($stGradRect, 1, 0)
	DllStructSetData($stGradRect, 2, 1)
	
	If $bVert Then
		GradientFill($hDC, DllStructGetPtr($stVert), 2, DllStructGetPtr($stGradRect), 1, 1)
	Else
		GradientFill($hDC, DllStructGetPtr($stVert), 2, DllStructGetPtr($stGradRect), 1, 0)
	EndIf
EndFunc   ;==>_FillGradientRect

Func GradientFill($hDC, $pVert, $nNumVert, $pRect, $nNumRect, $nFillMode)
	Local $nResult = DllCall($hMsimg32Dll, "int", "GradientFill", _
			"hwnd", $hDC, _
			"ptr", $pVert, _
			"ulong", $nNumVert, _
			"ptr", $pRect, _
			"ulong", $nNumRect, _
			"ulong", $nFillMode)
	Return $nResult[0]
EndFunc   ;==>GradientFill

;	Local $stSideRect = DllStructCreate("int;int;int;int")
;	_SetItemRect($stSideRect, 0, 0, $nSideWidth, $arIR[3])

Func _ColorGetClr($nColor, $nMode)
	Local $nClr = $nColor
	
	If $bUseRGBColors Then $nClr = _GetBGRColor($nColor)
	
	Switch $nMode
		Case 1
			$nClr = BitShift($nClr, 16)
		Case 2
			$nClr = BitShift(BitAND($nClr, 0xFF00), 8)
		Case 3
			$nClr = BitAND($nClr, 0xFF)
	EndSwitch
	
	Return $nClr
EndFunc   ;==>_ColorGetClr

;**********************************************************************
; Return an BGR color to a given RGB color
;**********************************************************************
Func _GetBGRColor($nColor)
	If $bUseRGBColors And $nColor <> -2 Then
		Return BitOR(BitShift(BitAND($nColor, 0xFF), -16), BitAND($nColor, 0xFF00), BitShift($nColor, 16))
	Else
		Return $nColor
	EndIf
EndFunc   ;==>_GetBGRColor

#EndRegion;--------------------------Appendix / Notes