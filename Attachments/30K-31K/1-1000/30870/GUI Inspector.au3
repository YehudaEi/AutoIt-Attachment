#Include <GuiMenu.au3>
#include <StaticConstants.au3>
#Include <GuiEdit.au3>
#Include <GuiListView.au3>
#include <GUIConstants.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <IE.au3>
#include "Toolkit.au3"
#cs
	Title:   		Sean's GUI Inspector
	Filename:  		GUI Inspector.au3
	Description: 	A scripting tool for querying GUIs
	Author:   		seangriffin
	Version:  		V0.1
	Last Update: 	12/06/10
	Requirements: 	AutoIt3 3.2 or higher
	Changelog:		
					---------12/06/10---------- v0.1
					Initial release.
#ce

;------------------------------------------------------------------
; Constants and Variables
;------------------------------------------------------------------

Const $def_dom_properties = "name|ObjName|type|value|id|title|class|clientLeft|clientTop|clientWidth|clientHeight|disabled|fontFamily|fontSize|hidden|innerHTML|innerText|outerHTML|outerText|tagName|text|visibility"
Dim $msg, $tab_num = -1, $num_cols, $close_button, $open_script_button
Global $output_listview, $get_all_tables_button, $get_table_button, $get_all_table_cells_button, $get_table_cells_button, $script_edit
Global $old_hottrack_item = 0, $old_hottrack_subitem = 0, $dom_prop, $hottrack_item, $hottrack_subitem
global $form_buttons_dummy, $form_buttons_menu, $click_button_menuitem

$ini_filename = @ScriptDir & "\GUI Inspector.ini"
$open_script_filename = @ScriptDir & "\GUI Inspector open script.au3"


;------------------------------------------------------------------
; Configure the GUIs
;------------------------------------------------------------------

; Main GUI
$main_gui = GUICreate("Sean's GUI Inspector", 1024, 768, -1, -1)
WinSetOnTop($main_gui, "", 1)
GUICtrlCreateGroup("Attach", 10, 10, 1000, 200)
GUICtrlCreateLabel("Page", 20, 30, 30, 20)
$page_string_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "page string", "Google - Windows Internet Explorer"), 50, 30, 500, 20)
GUICtrlCreateLabel("Mode", 560, 30, 40, 20)
$page_mode_list = GUICtrlCreateList("", 600, 30, 100, 110, BitOR($WS_BORDER, $WS_VSCROLL))
GUICtrlSetData(-1, "WindowTitle|URL|Title|Text|HTML|HWND|Embedded|DialogBox", IniRead($ini_filename, "Main", "page mode", "WindowTitle"))
GUICtrlCreateLabel("Frame", 20, 80, 40, 20)
$frame_string_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "frame string", "-1"), 50, 80, 80, 20)
$frame_string_updown = GUICtrlCreateUpdown($frame_string_input)
GUICtrlCreateLabel("SubFrame", 150, 80, 50, 20)
$subframe_string_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "subframe string", "-1"), 200, 80, 80, 20)
$subframe_string_updown = GUICtrlCreateUpdown($subframe_string_input)
;GUICtrlCreateLabel("Form", 20, 110, 80, 20)
;$form_string_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "form string", ""), 50, 110, 200, 20)
GUICtrlCreateLabel("Waits", 20, 140, 50, 20)
$waits_string_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "waits", "1"), 60, 140, 80, 20)
$waits_string_updown = GUICtrlCreateUpdown($waits_string_input)
GUICtrlCreateLabel("Timeout", 150, 140, 50, 20)
$timeout_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "timeout", "120000"), 210, 140, 50, 20)
$wait_for_done_checkbox = GUICtrlCreateCheckbox("Wait for Done", 280, 140, 90, 20)
GUICtrlSetState($wait_for_done_checkbox, IniRead($ini_filename, "Main", "wait for done", $GUI_UNCHECKED))

$main_tab = GUICtrlCreateTab(5, 220, 1000, 120)
$pages_tabitem = GUICtrlCreateTabItem("Document")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_doc_html_button = GUICtrlCreateButton("Get Doc HTML (F6)", 10, 250, 130, 20)

$pages_tabitem = GUICtrlCreateTabItem("Body")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_body_html_button = GUICtrlCreateButton("Get Body HTML (F6)", 10, 250, 130, 20)
$get_body_text_button = GUICtrlCreateButton("Get Body Text (F7)", 10, 270, 130, 20)
$get_all_tags_button = GUICtrlCreateButton("Get All Tags (F8)", 10, 290, 130, 20)

$frames_tabitem = GUICtrlCreateTabItem("Frames")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)

$tables_tabitem = GUICtrlCreateTabItem("Tables")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_tables_button = GUICtrlCreateButton("Get All Tables (F6)", 10, 250, 130, 20)
$get_table_button = GUICtrlCreateButton("Get Table (F7)", 10, 270, 130, 20)
$get_all_table_cells_button = GUICtrlCreateButton("Get All Table Cells (F8)", 10, 290, 130, 20)
$get_table_cells_button = GUICtrlCreateButton("Get Table Cells (F9)", 10, 310, 130, 20)
GUICtrlCreateLabel("Property", 150, 250, 80, 20)
$table_prop_list = GUICtrlCreateList("", 150, 270, 80, 60, BitOR($WS_BORDER, $WS_VSCROLL))
GUICtrlSetData(-1, "Index|name", IniRead($ini_filename, "Main", "table property", "Index"))
GUICtrlCreateLabel("Value", 240, 250, 80, 20)
$table_prop_val = GUICtrlCreateInput("0", 240, 270, 80, 20)
GUICtrlSetData(-1, IniRead($ini_filename, "Main", "table value", "0"))

$hyperlinks_tabitem = GUICtrlCreateTabItem("Hyperlinks")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_hyperlinks_button = GUICtrlCreateButton("Get All Hyperlinks (F6)", 10, 250, 130, 20)
$get_hyperlink_button = GUICtrlCreateButton("Get Hyperlink (F7)", 10, 270, 130, 20)
GUICtrlCreateLabel("Property", 150, 250, 80, 20)
$hyperlink_prop_list = GUICtrlCreateList("", 150, 270, 80, 60, BitOR($WS_BORDER, $WS_VSCROLL))
GUICtrlSetData(-1, "Index|outerText|href", IniRead($ini_filename, "Main", "hyperlink property", "Index"))
GUICtrlCreateLabel("Value", 240, 250, 80, 20)
$hyperlink_prop_val = GUICtrlCreateInput("0", 240, 270, 80, 20)
GUICtrlSetData(-1, IniRead($ini_filename, "Main", "hyperlink value", "0"))

$images_tabitem = GUICtrlCreateTabItem("Images")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)

$forms_tabitem = GUICtrlCreateTabItem("Forms")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_forms_button = GUICtrlCreateButton("Get All Forms (F6)", 10, 250, 130, 20)
$get_form_button = GUICtrlCreateButton("Get Form (F7)", 10, 270, 130, 20)
$get_all_form_elements_button = GUICtrlCreateButton("Get All Elements (F8)", 10, 290, 130, 20)
$get_form_elements_button = GUICtrlCreateButton("Get Form Elements (F9)", 10, 310, 130, 20)
GUICtrlCreateLabel("Property", 150, 250, 80, 20)
$form_prop_list = GUICtrlCreateList("", 150, 270, 80, 60, BitOR($WS_BORDER, $WS_VSCROLL))
GUICtrlSetData(-1, "Index|name", IniRead($ini_filename, "Main", "form property", "Index"))
GUICtrlCreateLabel("Value", 240, 250, 80, 20)
$form_prop_val = GUICtrlCreateInput("0", 240, 270, 80, 20)
GUICtrlSetData(-1, IniRead($ini_filename, "Main", "form value", "0"))

$forms_tabitem = GUICtrlCreateTabItem("Buttons")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_form_buttons_button = GUICtrlCreateButton("Get All Buttons", 350, 250, 130, 20)
$get_form_buttons_button = GUICtrlCreateButton("Get Form Buttons", 350, 270, 130, 20)

$forms_tabitem = GUICtrlCreateTabItem("Checkboxes")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_form_checkboxes_button = GUICtrlCreateButton("Get All Checkboxes", 350, 290, 130, 20)
$get_form_checkboxes_button = GUICtrlCreateButton("Get Form Checkboxes", 350, 310, 130, 20)

$forms_tabitem = GUICtrlCreateTabItem("Radio Buttons")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_form_radio_buttons_button = GUICtrlCreateButton("Get All Radio Buttons", 500, 250, 130, 20)
$get_form_radio_buttons_button = GUICtrlCreateButton("Get Form Radio Buttons", 500, 270, 130, 20)

$forms_tabitem = GUICtrlCreateTabItem("Textboxes")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_form_textboxes_button = GUICtrlCreateButton("Get All Textboxes", 500, 290, 130, 20)
$get_form_textboxes_button = GUICtrlCreateButton("Get Form Textboxes", 500, 310, 130, 20)

$forms_tabitem = GUICtrlCreateTabItem("Images")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_form_images_button = GUICtrlCreateButton("Get All Images", 650, 250, 130, 20)
$get_form_images_button = GUICtrlCreateButton("Get Form Images", 650, 270, 130, 20)

$forms_tabitem = GUICtrlCreateTabItem("Listboxes")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)
$get_all_form_listboxes_button = GUICtrlCreateButton("Get All Listboxes", 650, 290, 130, 20)
$get_form_listboxes_button = GUICtrlCreateButton("Get Form Listboxes", 650, 310, 130, 20)

$images_tabitem = GUICtrlCreateTabItem("Java")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)

$images_tabitem = GUICtrlCreateTabItem("SAP")
$tab_num = $tab_num + 1
if IniRead($ini_filename, "Main", "tab", "") = $tab_num Then GUICtrlSetState(-1, $GUI_SHOW)

GUICtrlCreateTabItem(""); 

;GUICtrlCreateGroup("Output", 10, 350, 1000, 200)
$output_label = GUICtrlCreateLabel("Output", 10, 350, 300, 20)
$output_edit = GUICtrlCreateEdit("", 10, 370, 1000, 170)
GUICtrlSetState($output_edit, $GUI_HIDE)
GUICtrlCreateLabel("Script", 10, 550, 80, 20)
$script_edit = GUICtrlCreateEdit("", 10, 570, 1000, 100)
$open_script_button = GUICtrlCreateButton("Open this Script (F12)", 10, 670, 160, 20)
GUICtrlSetState($open_script_button, $GUI_HIDE)

$prefs_button = GUICtrlCreateButton("Preferences", 10, 745, 160, 20)
$about_button = GUICtrlCreateButton("About", 200, 745, 160, 20)
$close_button = GUICtrlCreateButton("Close (Esc)", 900, 745, 80, 20)

; Tables Context Menu
$tables_dummy = GUICtrlCreateDummy()
$tables_menu = GUICtrlCreateContextMenu($tables_dummy)
$click_table_menuitem = GUICtrlCreateMenuItem("Click Table", $tables_menu)
$open_script_table_menuitem = GUICtrlCreateMenuItem("Open this Script (F12)", $tables_menu)

; Form Buttons Context Menu
$form_buttons_dummy = GUICtrlCreateDummy()
$form_buttons_menu = GUICtrlCreateContextMenu($form_buttons_dummy)
$click_button_menuitem = GUICtrlCreateMenuItem("Click Button", $form_buttons_menu)
$open_script_button_menuitem = GUICtrlCreateMenuItem("Open this Script (F12)", $form_buttons_menu)

; Form Checkbox Context Menu
$form_checkboxes_dummy = GUICtrlCreateDummy()
$form_checkboxes_menu = GUICtrlCreateContextMenu($form_checkboxes_dummy)
$check_checkbox_menuitem = GUICtrlCreateMenuItem("Check Checkbox", $form_checkboxes_menu)
$uncheck_checkbox_menuitem = GUICtrlCreateMenuItem("Uncheck Checkbox", $form_checkboxes_menu)
$open_script_checkbox_menuitem = GUICtrlCreateMenuItem("Open this Script (F12)", $form_checkboxes_menu)

dim $main_gui_accel[2][2]=[["{ESC}", $close_button], ["{F12}", $open_script_button]]

; Preferences GUI
$preferences_gui = GUICreate("Sean's GUI Inspector - Preferences", 640, 300)
GUICtrlCreateLabel("DOM Properties", 10, 10, 80, 20)
$dom_prop_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "domprop", $def_dom_properties), 100, 10, 450, 20)
$prefsclosebutton = GUICtrlCreateButton("&Close", 160, 140, 70, 20)

; About GUI
$about_gui = GUICreate("Sean's GUI Inspector - About", 380, 170, -1, -1, -1, -1, $main_gui)
GUICtrlCreateLabel(	"Version 0.1 (12th June 2010)" & @CRLF & _
					"Freeware", 10, 60, 370, 30, $SS_CENTER)
GUICtrlCreateLabel(	"Author: Sean Griffin" & @CRLF & _
					"WWW: http://www.autoitscript.com/forum/index.php?showtopic=110244" & @CRLF & _
					"Email: seangriffin@aanet.com.au", 10, 90, 370, 50)
$aboutclosebutton = GUICtrlCreateButton("&Close", 160, 140, 70, 20)

;------------------------------------------------------------------
; Main Loop
;------------------------------------------------------------------

$curr_gui = $main_gui
GUISwitch($curr_gui)
GUISetState(@SW_SHOW)
;GUISetAccelerators($main_gui_accel)
set_tab_accel(IniRead($ini_filename, "Main", "tab", ""))

;GUIRegisterMsg($WM_NOTIFY,"WM_Notify_Events")
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

while 1

	if $msg = $pages_tabitem Then
		
		MsgBox(0,"w","w")
	EndIf

	if $msg = $open_script_button Then

		FileRecycle($open_script_filename)
		FileWrite($open_script_filename, GUICtrlRead($script_edit))
		ShellExecute("C:\Program Files\AutoIt3\SciTE\SciTE.exe", """" & $open_script_filename & """")
		$msg = $GUI_EVENT_CLOSE
	EndIf

	if $msg = $prefs_button Then

		$curr_gui = $preferences_gui
		GUISwitch($curr_gui)
		GUISetState(@SW_SHOW)
		WinSetOnTop($preferences_gui, "", 1)
	EndIf

	if $msg = $about_button Then

		$curr_gui = $about_gui
		GUISwitch($curr_gui)
		GUISetState(@SW_SHOW)
		WinSetOnTop($about_gui, "", 1)
	EndIf

	if $msg = $get_doc_html_button Then

		_IEErrorHandlerRegister()
		GUICtrlSetData($output_edit, "")
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		$html = _IEDocReadHTML($page)
		GUICtrlSetState($output_listview, $GUI_HIDE)
		GUICtrlSetState($output_edit, $GUI_FOCUS)
		GUICtrlSetData($output_edit, $html)
		GUICtrlSetState($output_edit, $GUI_SHOW)
		
		$script = _
			"#include ""Toolkit.au3""" & @CRLF & _
			"IEAttachAndWait(""" & GUICtrlRead($page_string_input) & """, """ & GUICtrlRead($page_mode_list) & """, " & GUICtrlRead($frame_string_input) & ", " & GUICtrlRead($subframe_string_input) & ", -1, " & GUICtrlRead($waits_string_input) & ", " & GUICtrlRead($timeout_input) & ", False)" & @CRLF & _
			"$html = _IEDocReadHTML($page)" & @CRLF & _
			"ConsoleWrite($html)" & @CRLF & _
			"IEPageMinimise()" & @CRLF
		GUICtrlSetData($script_edit, $script)
		
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_body_html_button Then

		_IEErrorHandlerRegister()
		GUICtrlSetData($output_edit, "")
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		$html = _IEBodyReadHTML($page)
		GUICtrlSetState($output_listview, $GUI_HIDE)
		GUICtrlSetState($output_edit, $GUI_FOCUS)
		GUICtrlSetData($output_edit, $html)
		GUICtrlSetState($output_edit, $GUI_SHOW)
		
		$script = _
			"#include ""Toolkit.au3""" & @CRLF & _
			"IEAttachAndWait(""" & GUICtrlRead($page_string_input) & """, """ & GUICtrlRead($page_mode_list) & """, " & GUICtrlRead($frame_string_input) & ", " & GUICtrlRead($subframe_string_input) & ", -1, " & GUICtrlRead($waits_string_input) & ", " & GUICtrlRead($timeout_input) & ", False)" & @CRLF & _
			"$html = _IEBodyReadHTML($page)" & @CRLF & _
			"ConsoleWrite($html)" & @CRLF & _
			"IEPageMinimise()" & @CRLF
		GUICtrlSetData($script_edit, $script)
		
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_body_text_button Then

		_IEErrorHandlerRegister()
		GUICtrlSetData($output_edit, "")
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		$html = _IEBodyReadText($page)
		GUICtrlSetState($output_listview, $GUI_HIDE)
		GUICtrlSetState($output_edit, $GUI_FOCUS)
		GUICtrlSetData($output_edit, $html)
		GUICtrlSetState($output_edit, $GUI_SHOW)
		
		$script = _
			"#include ""Toolkit.au3""" & @CRLF & _
			"IEAttachAndWait(""" & GUICtrlRead($page_string_input) & """, """ & GUICtrlRead($page_mode_list) & """, " & GUICtrlRead($frame_string_input) & ", " & GUICtrlRead($subframe_string_input) & ", -1, " & GUICtrlRead($waits_string_input) & ", " & GUICtrlRead($timeout_input) & ", False)" & @CRLF & _
			"$html = _IEBodyReadText($page)" & @CRLF & _
			"ConsoleWrite($html)" & @CRLF & _
			"IEPageMinimise()" & @CRLF
		GUICtrlSetData($script_edit, $script)
		
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_hyperlinks_button Then
		
		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		$hyperlinks = _IELinkGetCollection ($page)
		$num_hyperlinks = @extended
		
		GUICtrlSetState($output_edit, $GUI_HIDE)
		_GUICtrlListView_Destroy($output_listview)
		
		$output_listview = GUICtrlCreateListView("outerText|href", 10, 370, 1000, 170)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		For $hyperlink In $hyperlinks
			
			GUICtrlCreateListViewItem($hyperlink.outerText & "|" & $hyperlink.href, $output_listview)
		Next		

		_GUICtrlListView_SetColumnWidth($output_listview,0,200)
		_GUICtrlListView_SetColumnWidth($output_listview,1,300)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_table_cells_button Then
		
		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		$arr = IETableGetArray(GUICtrlRead($table_prop_val))
		;_ArrayDisplay($arr)
		
		GUICtrlSetState($output_edit, $GUI_HIDE)
		_GUICtrlListView_Destroy($output_listview)
		$output_listview = GUICtrlCreateListView("", 10, 370, 1000, 170)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		for $i = 0 to (UBound($arr, 2) - 1)
			
			_GUICtrlListView_AddColumn($output_listview, "Col " & $i)
		Next
		
		for $x = 0 to (UBound($arr, 1) - 1)

			$tmp = ""
			
			for $y = 0 to (UBound($arr, 2) - 1)
				
				if $y > 0 then $tmp = $tmp & "|"
				
				$tmp = $tmp & $arr[$x][$y]
			Next

			ConsoleWrite($tmp & @crlf)
			GUICtrlCreateListViewItem($tmp, $output_listview)
		Next

		for $i = 0 to (UBound($arr, 2) - 1)
			
			_GUICtrlListView_SetColumnWidth($output_listview,$i,100)
		Next

		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_form_elements_button Then
		
		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		
		$form = _IEFormGetCollection($page, GUICtrlRead($form_prop_val))
		$elements = _IEFormElementGetCollection($form)
		
		GUICtrlSetState($output_edit, $GUI_HIDE)
		_GUICtrlListView_Destroy($output_listview)
		
		$output_listview = GUICtrlCreateListView(GUICtrlRead($dom_prop_input), 10, 370, 1000, 170)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		For $element In $elements
			
			$dom_prop = StringSplit(GUICtrlRead($dom_prop_input), "|")
			_ArrayDelete($dom_prop, 0)
			
			$output_row = ""
			
			for $each in $dom_prop
			
				if StringLen($output_row) > 0 Then $output_row = $output_row & "|"
			
				Switch $each
					
					Case "ObjName"

						$output_row = $output_row & String(ObjName($element))
						
					case Else
						
						$output_row = $output_row & Execute("$element." & $each)
				EndSwitch
			Next
			
			GUICtrlCreateListViewItem($output_row, $output_listview)
		Next		

		_GUICtrlListView_SetColumnWidth($output_listview,0,250)
		_GUICtrlListView_SetColumnWidth($output_listview,1,150)
		_GUICtrlListView_SetColumnWidth($output_listview,2,100)
		_GUICtrlListView_SetColumnWidth($output_listview,3,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_form_elements_button Then

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		GUICtrlSetState($output_edit, $GUI_HIDE)
		
		_GUICtrlListView_Destroy($output_listview)
		$output_listview = GUICtrlCreateListView("Index" & "|" & GUICtrlRead($dom_prop_input), 10, 370, 1000, 170)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$forms = _IEFormGetCollection($page)
		
		$form_num = 0
		for $form in $forms
			
			$elements = _IEFormElementGetCollection($form)
			
			_GUICtrlListView_BeginUpdate($output_listview)
			
			For $element In $elements
				
				$dom_prop = StringSplit(GUICtrlRead($dom_prop_input), "|")
				_ArrayDelete($dom_prop, 0)
				
				$output_row = $form_num
				
				for $each in $dom_prop
				
					$output_row = $output_row & "|"
				
					Switch $each
						
						Case "ObjName"

							$output_row = $output_row & String(ObjName($element))
							
						case Else
							
							$output_row = $output_row & Execute("$element." & $each)
					EndSwitch
				Next
				
				GUICtrlCreateListViewItem($output_row, $output_listview)
			Next		
			
			$form_num = $form_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,45)
		_GUICtrlListView_SetColumnWidth($output_listview,1,250)
		_GUICtrlListView_SetColumnWidth($output_listview,2,150)
		_GUICtrlListView_SetColumnWidth($output_listview,3,100)
		_GUICtrlListView_SetColumnWidth($output_listview,4,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_form_buttons_button Then

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		GUICtrlSetState($output_edit, $GUI_HIDE)
		
		_GUICtrlListView_Destroy($output_listview)
		GUICtrlSetData($output_label, "Output - All Form Buttons")
		$new_dom_props = StringReplace(StringReplace(GUICtrlRead($dom_prop_input), "ObjName|", ""), "type|", "")
		$output_listview = GUICtrlCreateListView("Index" & "|" & $new_dom_props, 10, 370, 1000, 170, BitOR($LVS_EDITLABELS, $LVS_REPORT))
		_GUICtrlListView_SetUnicodeFormat($output_listview, False)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$forms = _IEFormGetCollection($page)
		
		$form_num = 0
		for $form in $forms
			
			$elements = _IEFormElementGetCollection($form)
			
			_GUICtrlListView_BeginUpdate($output_listview)
			
			For $element In $elements
			
				if $element.type = "button" or $element.type = "submit" Then
	
					$dom_prop = StringSplit($new_dom_props, "|")
					_ArrayDelete($dom_prop, 0)
					
					$output_row = $form_num
					
					for $each in $dom_prop
					
						$output_row = $output_row & "|"
					
						Switch $each
							
							Case "ObjName"

								$output_row = $output_row & String(ObjName($element))
								
							case Else
								
								$output_row = $output_row & Execute("$element." & $each)
						EndSwitch
					Next
					
					GUICtrlCreateListViewItem($output_row, $output_listview)
				EndIf
			Next		
			
			$form_num = $form_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,45)
		_GUICtrlListView_SetColumnWidth($output_listview,1,250)
		_GUICtrlListView_SetColumnWidth($output_listview,2,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_form_checkboxes_button Then

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		GUICtrlSetState($output_edit, $GUI_HIDE)
		
		_GUICtrlListView_Destroy($output_listview)
		GUICtrlSetData($output_label, "Output - All Form Checkboxes")
		$new_dom_props = StringReplace(StringReplace(GUICtrlRead($dom_prop_input), "ObjName|", ""), "type|", "")
		$output_listview = GUICtrlCreateListView("Index" & "|" & $new_dom_props, 10, 370, 1000, 170)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$forms = _IEFormGetCollection($page)
		
		$form_num = 0
		for $form in $forms
			
			$elements = _IEFormElementGetCollection($form)
			
			_GUICtrlListView_BeginUpdate($output_listview)
			
			For $element In $elements
			
				if $element.type = "checkbox" Then
	
					$dom_prop = StringSplit($new_dom_props, "|")
					_ArrayDelete($dom_prop, 0)
					
					$output_row = $form_num
					
					for $each in $dom_prop
					
						$output_row = $output_row & "|"
					
						Switch $each
							
							Case "ObjName"

								$output_row = $output_row & String(ObjName($element))
								
							case Else
								
								$output_row = $output_row & Execute("$element." & $each)
						EndSwitch
					Next
					
					GUICtrlCreateListViewItem($output_row, $output_listview)
				EndIf
			Next		
			
			$form_num = $form_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,45)
		_GUICtrlListView_SetColumnWidth($output_listview,1,250)
		_GUICtrlListView_SetColumnWidth($output_listview,2,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_form_radio_buttons_button Then

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		GUICtrlSetState($output_edit, $GUI_HIDE)
		
		_GUICtrlListView_Destroy($output_listview)
		GUICtrlSetData($output_label, "Output - All Form Radio Buttons")
		$new_dom_props = StringReplace(StringReplace(GUICtrlRead($dom_prop_input), "ObjName|", ""), "type|", "")
		$output_listview = GUICtrlCreateListView("Index" & "|" & $new_dom_props, 10, 370, 1000, 170)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$forms = _IEFormGetCollection($page)
		
		$form_num = 0
		for $form in $forms
			
			$elements = _IEFormElementGetCollection($form)
			
			_GUICtrlListView_BeginUpdate($output_listview)
			
			For $element In $elements
			
				if $element.type = "radio" Then
	
					$dom_prop = StringSplit($new_dom_props, "|")
					_ArrayDelete($dom_prop, 0)
					
					$output_row = $form_num
					
					for $each in $dom_prop
					
						$output_row = $output_row & "|"
					
						Switch $each
							
							Case "ObjName"

								$output_row = $output_row & String(ObjName($element))
								
							case Else
								
								$output_row = $output_row & Execute("$element." & $each)
						EndSwitch
					Next
					
					GUICtrlCreateListViewItem($output_row, $output_listview)
				EndIf
			Next		
			
			$form_num = $form_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,45)
		_GUICtrlListView_SetColumnWidth($output_listview,1,250)
		_GUICtrlListView_SetColumnWidth($output_listview,2,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_form_textboxes_button Then

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		GUICtrlSetState($output_edit, $GUI_HIDE)
		
		_GUICtrlListView_Destroy($output_listview)
		GUICtrlSetData($output_label, "Output - All Form Textboxes")
		$new_dom_props = StringReplace(StringReplace(GUICtrlRead($dom_prop_input), "ObjName|", ""), "type|", "")
		$output_listview = GUICtrlCreateListView("Index" & "|" & $new_dom_props, 10, 370, 1000, 170)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$forms = _IEFormGetCollection($page)
		
		$form_num = 0
		for $form in $forms
			
			$elements = _IEFormElementGetCollection($form)
			
			_GUICtrlListView_BeginUpdate($output_listview)
			
			For $element In $elements
			
				if $element.type = "text" Then
	
					$dom_prop = StringSplit($new_dom_props, "|")
					_ArrayDelete($dom_prop, 0)
					
					$output_row = $form_num
					
					for $each in $dom_prop
					
						$output_row = $output_row & "|"
					
						Switch $each
							
							Case "ObjName"

								$output_row = $output_row & String(ObjName($element))
								
							case Else
								
								$output_row = $output_row & Execute("$element." & $each)
						EndSwitch
					Next
					
					GUICtrlCreateListViewItem($output_row, $output_listview)
				EndIf
			Next		
			
			$form_num = $form_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,45)
		_GUICtrlListView_SetColumnWidth($output_listview,1,250)
		_GUICtrlListView_SetColumnWidth($output_listview,2,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_form_images_button Then

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		GUICtrlSetState($output_edit, $GUI_HIDE)
		
		_GUICtrlListView_Destroy($output_listview)
		GUICtrlSetData($output_label, "Output - All Form Images")
		$new_dom_props = StringReplace(StringReplace(GUICtrlRead($dom_prop_input), "ObjName|", ""), "type|", "")
		$output_listview = GUICtrlCreateListView("Index" & "|" & $new_dom_props, 10, 370, 1000, 170)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$forms = _IEFormGetCollection($page)
		
		$form_num = 0
		for $form in $forms
			
			$elements = _IEFormElementGetCollection($form)
			
			_GUICtrlListView_BeginUpdate($output_listview)
			
			For $element In $elements
			
				if $element.type = "image" Then
	
					$dom_prop = StringSplit($new_dom_props, "|")
					_ArrayDelete($dom_prop, 0)
					
					$output_row = $form_num
					
					for $each in $dom_prop
					
						$output_row = $output_row & "|"
					
						Switch $each
							
							Case "ObjName"

								$output_row = $output_row & String(ObjName($element))
								
							case Else
								
								$output_row = $output_row & Execute("$element." & $each)
						EndSwitch
					Next
					
					GUICtrlCreateListViewItem($output_row, $output_listview)
				EndIf
			Next		
			
			$form_num = $form_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,45)
		_GUICtrlListView_SetColumnWidth($output_listview,1,250)
		_GUICtrlListView_SetColumnWidth($output_listview,2,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_form_listboxes_button Then

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		GUICtrlSetState($output_edit, $GUI_HIDE)
		
		_GUICtrlListView_Destroy($output_listview)
		GUICtrlSetData($output_label, "Output - All Form Listboxes")
		$new_dom_props = StringReplace(StringReplace(GUICtrlRead($dom_prop_input), "ObjName|", ""), "type|", "")
		$output_listview = GUICtrlCreateListView("Index" & "|" & $new_dom_props, 10, 370, 1000, 170)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$forms = _IEFormGetCollection($page)
		
		$form_num = 0
		for $form in $forms
			
			$elements = _IEFormElementGetCollection($form)
			
			_GUICtrlListView_BeginUpdate($output_listview)
			
			For $element In $elements
			
				if $element.type = "select-one" Then
	
					$dom_prop = StringSplit($new_dom_props, "|")
					_ArrayDelete($dom_prop, 0)
					
					$output_row = $form_num
					
					for $each in $dom_prop
					
						$output_row = $output_row & "|"
					
						Switch $each
							
							Case "ObjName"

								$output_row = $output_row & String(ObjName($element))
								
							case Else
								
								$output_row = $output_row & Execute("$element." & $each)
						EndSwitch
					Next
					
					GUICtrlCreateListViewItem($output_row, $output_listview)
				EndIf
			Next		
			
			$form_num = $form_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,45)
		_GUICtrlListView_SetColumnWidth($output_listview,1,250)
		_GUICtrlListView_SetColumnWidth($output_listview,2,250)
		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_table_button Then

		$dom_props = "name|className|caption|rows|cols|border|cellPadding|cellSpacing"

		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		
		GUICtrlSetState($output_edit, $GUI_HIDE)
		_GUICtrlListView_Destroy($output_listview)
		GUICtrlSetData($output_label, "Output - Table " & GUICtrlRead($table_prop_list) & " = " & GUICtrlRead($table_prop_val))
		$output_listview = GUICtrlCreateListView($dom_props, 10, 370, 1000, 170)
		GUICtrlSendMsg($output_listview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_TRACKSELECT, $LVS_EX_TRACKSELECT)
		_GUICtrlListView_BeginUpdate($output_listview)

		$dom_prop = StringSplit($dom_props, "|")
		_ArrayDelete($dom_prop, 0)

		$table = _IETableGetCollection($page, GUICtrlRead($table_prop_val))
		
		; Number of cols
		$rows = $table.rows
		
		$num_cols = 0
		
		For $row In $rows
			
			if $num_cols < $row.cells.length then $num_cols = $row.cells.length
		Next
		
		GUICtrlCreateListViewItem($table.name & "|" & $table.className & "|" & $table.caption & "|" & $table.rows.length & "|" & $num_cols & "|" & $table.border & "|" & $table.cellPadding & "|" & $table.cellSpacing, $output_listview)

		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_tables_button Then
		
		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		
		GUICtrlSetState($output_edit, $GUI_HIDE)
		_GUICtrlListView_Destroy($output_listview)
		$output_listview = GUICtrlCreateListView("Index|name|className|caption|rows|cols|border|cellPadding|cellSpacing", 10, 370, 1000, 170)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		$tables = _IETableGetCollection($page)
		
		$table_num = 0
		for $table in $tables
			
			; Number of cols
			$rows = $table.rows
			
			$num_cols = 0
			
			For $row In $rows
				
				if $num_cols < $row.cells.length then $num_cols = $row.cells.length
			Next
			
			GUICtrlCreateListViewItem($table_num & "|" & $table.name & "|" & $table.className & "|" & $table.caption & "|" & $table.rows.length & "|" & $num_cols & "|" & $table.border & "|" & $table.cellPadding & "|" & $table.cellSpacing, $output_listview)
			
			$table_num = $table_num + 1
		Next

		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	if $msg = $get_all_table_cells_button Then
		
		_IEErrorHandlerRegister()
		IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
		;_ArrayDisplay($arr)
		
		GUICtrlSetState($output_edit, $GUI_HIDE)
		_GUICtrlListView_Destroy($output_listview)
		$output_listview = GUICtrlCreateListView("", 10, 370, 1000, 170)
		_GUICtrlListView_BeginUpdate($output_listview)
		
		_GUICtrlListView_AddColumn($output_listview, "Index")

		$tables = _IETableGetCollection($page)
		
		
		$table_num = 0
		$prev_num_columns = 0
		for $table in $tables
			
			$arr = IETableGetArray($table_num)
			
			; Create columns for the table
			$num_columns = UBound($arr, 2)
			ConsoleWrite("num cols=" & $num_columns & " prev cols=" & $prev_num_columns & @CRLF)
			
			if $num_columns > $prev_num_columns Then
			
				for $i = $prev_num_columns to ($num_columns - 1)
					
					_GUICtrlListView_AddColumn($output_listview, "Col " & $i)
				Next
			EndIf
			
			$prev_num_columns = $num_columns
			
			; Add the listview items for the table
			for $x = 0 to (UBound($arr, 1) - 1)

				$tmp = $table_num
				
				for $y = 0 to (UBound($arr, 2) - 1)
					
					$tmp = $tmp & "|" & $arr[$x][$y]
				Next

				ConsoleWrite($tmp & @crlf)
				GUICtrlCreateListViewItem($tmp, $output_listview)
			Next
			
			$table_num = $table_num + 1
		Next

		_GUICtrlListView_SetColumnWidth($output_listview,0,55)
		for $i = 1 to (_GUICtrlListView_GetColumnCount($output_listview) - 1)
			
			_GUICtrlListView_SetColumnWidth($output_listview,$i,150)
		Next

		GUICtrlSetState($output_listview, $GUI_FOCUS)
		_GUICtrlListView_EndUpdate($output_listview)
		GUISetState(@SW_RESTORE)
		_IEErrorHandlerDeregister()
	EndIf

	If $msg = $GUI_EVENT_CLOSE or $msg = $close_button or $msg = $prefsclosebutton or $msg = $aboutclosebutton Then
		
		; If the Main GUI was closed, then exit the script
		if $curr_gui = $main_gui Then 

			IniWrite($ini_filename, "Main", "page string", GUICtrlRead($page_string_input))
			IniWrite($ini_filename, "Main", "page mode", GUICtrlRead($page_mode_list))
			IniWrite($ini_filename, "Main", "frame string", GUICtrlRead($frame_string_input))
			IniWrite($ini_filename, "Main", "subframe string", GUICtrlRead($subframe_string_input))
			IniWrite($ini_filename, "Main", "waits", GUICtrlRead($waits_string_input))
			IniWrite($ini_filename, "Main", "timeout", GUICtrlRead($timeout_input))
			IniWrite($ini_filename, "Main", "wait for done", GUICtrlRead($wait_for_done_checkbox))
			IniWrite($ini_filename, "Main", "tab", GUICtrlRead($main_tab))
			ExitLoop
		Else
			
			; Other GUIs are disabled, and the Main GUI enabled.
			GUISetState(@SW_HIDE)
			$curr_gui = $main_gui
			GUISwitch($curr_gui)
			GUISetState(@SW_ENABLE)
			GUISetState(@SW_RESTORE)
			GUISetAccelerators($main_gui_accel)
		EndIf
	EndIf

	$msg = GUIGetMsg()
WEnd

GUIDelete()

Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)

    Switch $wParam
		
		Case $main_tab

			set_tab_accel(GUICtrlRead($main_tab))
	EndSwitch
EndFunc

Func set_tab_accel($tab_num)
	
	Switch $tab_num
		
		case 0
	
			dim $tabitem_accel[5][2]=[["{ESC}", $close_button], ["{F12}", $open_script_button], ["{F6}", $get_doc_html_button], ["{F7}", $get_body_html_button], ["{F8}", $get_body_text_button]]
			GUISetAccelerators($tabitem_accel)
		
		case 2
	
			dim $tabitem_accel[6][2]=[["{ESC}", $close_button], ["{F12}", $open_script_button], ["{F6}", $get_all_forms_button], ["{F7}", $get_form_button], ["{F8}", $get_all_form_elements_button], ["{F9}", $get_form_elements_button]]
			GUISetAccelerators($tabitem_accel)

		case 3
	
			dim $tabitem_accel[6][2]=[["{ESC}", $close_button], ["{F12}", $open_script_button], ["{F6}", $get_all_tables_button], ["{F7}", $get_table_button], ["{F8}", $get_all_table_cells_button], ["{F9}", $get_table_cells_button]]
			GUISetAccelerators($tabitem_accel)

		case 4
	
			dim $tabitem_accel[4][2]=[["{ESC}", $close_button], ["{F12}", $open_script_button], ["{F6}", $get_all_hyperlinks_button], ["{F7}", $get_hyperlink_button]]
			GUISetAccelerators($tabitem_accel)
	EndSwitch
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg, $iwParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
;~  Local $tBuffer
    $hWndListView = $output_listview
    If Not IsHWnd($output_listview) Then $hWndListView = GUICtrlGetHandle($output_listview)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    
	Switch $hWndFrom
        
		Case $hWndListView
            
			Switch $iCode
				
				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					
					if StringCompare(GUICtrlRead($output_label), "Output - All Form Buttons") = 0 Then
					
						; show the menu
						Local $iSelected = _GUICtrlMenu_TrackPopupMenu(GUICtrlGetHandle($form_buttons_menu), $hWnd, -1, -1, 1, 1, 2)
						
						Switch $iSelected
							
							Case $click_button_menuitem
							
								_IEErrorHandlerRegister()
								IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), Number(_GUICtrlListView_GetItemText($output_listview, $hottrack_item, 0)), GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
								$button = IEGetButton($dom_prop[$hottrack_subitem-1], _GUICtrlListView_GetItemText($output_listview, $hottrack_item, $hottrack_subitem))
								_IEAction($button, "click")
								_IEErrorHandlerDeRegister()
								GUISetState(@SW_RESTORE)
							
							Case $open_script_button_menuitem
							
								$msg = $open_script_button
						EndSwitch
					EndIf
						
					if StringCompare(GUICtrlRead($output_label), "Output - All Form Checkboxes") = 0 Then
					
						; show the menu
						Local $iSelected = _GUICtrlMenu_TrackPopupMenu(GUICtrlGetHandle($form_checkboxes_menu), $hWnd, -1, -1, 1, 1, 2)
						
						Switch $iSelected
							
							Case $check_checkbox_menuitem
							
								_IEErrorHandlerRegister()
								IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), Number(_GUICtrlListView_GetItemText($output_listview, $hottrack_item, 0)), GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
								$checkbox = IEGetCheckbox($dom_prop[$hottrack_subitem-1], _GUICtrlListView_GetItemText($output_listview, $hottrack_item, $hottrack_subitem))
								$checkbox.checked = True
								_IEErrorHandlerDeRegister()
								GUISetState(@SW_RESTORE)
							
							Case $uncheck_checkbox_menuitem
							
								_IEErrorHandlerRegister()
								IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), Number(_GUICtrlListView_GetItemText($output_listview, $hottrack_item, 0)), GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
								$checkbox = IEGetCheckbox($dom_prop[$hottrack_subitem-1], _GUICtrlListView_GetItemText($output_listview, $hottrack_item, $hottrack_subitem))
								$checkbox.checked = False
								_IEErrorHandlerDeRegister()
								GUISetState(@SW_RESTORE)
							
							Case $open_script_checkbox_menuitem
							
								$msg = $open_script_button
						EndSwitch
					EndIf

					if StringInStr(GUICtrlRead($output_label), "Output - Table Index") > 0 Then
					
						; show the menu
						Local $iSelected = _GUICtrlMenu_TrackPopupMenu(GUICtrlGetHandle($tables_menu), $hWnd, -1, -1, 1, 1, 2)
						
						Switch $iSelected
							
							Case $click_table_menuitem
							
								_IEErrorHandlerRegister()
								IEAttachAndWait(GUICtrlRead($page_string_input), GUICtrlRead($page_mode_list), GUICtrlRead($frame_string_input), GUICtrlRead($subframe_string_input), -1, GUICtrlRead($waits_string_input), GUICtrlRead($timeout_input), False)
								$table = _IETableGetCollection($page, GUICtrlRead($table_prop_val))
								_IEAction($table, "click")
								_IEErrorHandlerDeRegister()
								GUISetState(@SW_RESTORE)
							
							Case $open_script_table_menuitem
							
								$msg = $open_script_button
						EndSwitch
					EndIf

				Case $LVN_HOTTRACK ; Sent by a list-view control when the user moves the mouse over an item
                  
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
					$hottrack_item = DllStructGetData($tInfo, "Item")
					$hottrack_subitem = DllStructGetData($tInfo, "SubItem")
					
					if 	$hottrack_item > -1 And $hottrack_subitem > -1 And _
						($old_hottrack_item <> $hottrack_item or _
						$old_hottrack_subitem <> $hottrack_subitem) Then
					
						if StringCompare(GUICtrlRead($output_label), "Output - All Form Buttons") = 0 Then
						
							$script = _
								"#include ""Toolkit.au3""" & @CRLF & _
								"_IEErrorHandlerRegister()" & @CRLF & _
								"IEAttachAndWait(""" & GUICtrlRead($page_string_input) & """, """ & GUICtrlRead($page_mode_list) & """, " & GUICtrlRead($frame_string_input) & ", " & GUICtrlRead($subframe_string_input) & ", " & _GUICtrlListView_GetItemText($output_listview, $hottrack_item, 0) & ", " & GUICtrlRead($waits_string_input) & ", " & GUICtrlRead($timeout_input) & ", False)" & @CRLF & _
								"$button = IEGetButton(""" & $dom_prop[$hottrack_subitem-1] & """, """ & _GUICtrlListView_GetItemText($output_listview, $hottrack_item, $hottrack_subitem) & """)" & @CRLF & _
								"ConsoleWrite($button." & $dom_prop[$hottrack_subitem-1] & " & @CRLF)" & @CRLF & _
								"_IEAction($button, ""click"")" & @CRLF & _
								"_IEErrorHandlerDeRegister()" & @CRLF
							GUICtrlSetData($script_edit, $script)
						EndIf

						if StringCompare(GUICtrlRead($output_label), "Output - All Form Checkboxes") = 0 Then

							$script = _
								"#include ""Toolkit.au3""" & @CRLF & _
								"IEAttachAndWait(""" & GUICtrlRead($page_string_input) & """, """ & GUICtrlRead($page_mode_list) & """, " & GUICtrlRead($frame_string_input) & ", " & GUICtrlRead($subframe_string_input) & ", " & _GUICtrlListView_GetItemText($output_listview, $hottrack_item, 0) & ", " & GUICtrlRead($waits_string_input) & ", " & GUICtrlRead($timeout_input) & ", False)" & @CRLF & _
								"$checkbox = IEGetCheckbox(""" & $dom_prop[$hottrack_subitem-1] & """, """ & _GUICtrlListView_GetItemText($output_listview, $hottrack_item, $hottrack_subitem) & """)" & @CRLF & _
								"ConsoleWrite($checkbox." & $dom_prop[$hottrack_subitem-1] & " & @CRLF)" & @CRLF & _
								"$checkbox.checked = True" & @CRLF
							GUICtrlSetData($script_edit, $script)
						EndIf

						if StringInStr(GUICtrlRead($output_label), "Output - Table Index") > 0 Then

							$script = _
								"#include ""Toolkit.au3""" & @CRLF & _
								"IEAttachAndWait(""" & GUICtrlRead($page_string_input) & """, """ & GUICtrlRead($page_mode_list) & """, " & GUICtrlRead($frame_string_input) & ", " & GUICtrlRead($subframe_string_input) & ", -1, " & GUICtrlRead($waits_string_input) & ", " & GUICtrlRead($timeout_input) & ", False)" & @CRLF & _
								"$table = _IETableGetCollection($page, " & GUICtrlRead($table_prop_val) & ")" & @CRLF & _
								"ConsoleWrite($table." & $dom_prop[$hottrack_subitem] & " & @CRLF)" & @CRLF & _
								"_IEAction($table, ""click"")" & @CRLF
							GUICtrlSetData($script_edit, $script)
						EndIf

						$old_hottrack_item = DllStructGetData($tInfo, "Item")
						$old_hottrack_subitem = DllStructGetData($tInfo, "SubItem")
					EndIf
					
					Return 0
            EndSwitch
    EndSwitch
    
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
