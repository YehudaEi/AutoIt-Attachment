#Include <GuiListView.au3>
#Include <GuiListBox.au3>
#include <Google Maps.au3>

Global Const $EN_SETFOCUS = 0x100
Dim $msg, $gmap, $distance, $duration
Global $main_gui, $set_view_button, $set_view_input, $zoom_view_button, $zoom_view_input, $add_marker_button, $add_marker_input

; Setup Main GUI
$main_gui = GUICreate("Google Maps Example", 800, 600, -1, -1, BitOR($WS_SIZEBOX, $WS_MAXIMIZEBOX))
$gmap_ctrl = _GUICtrlGoogleMap_Create($gmap, 0, 10, 800, 430, "Palm Beach, Queensland, Australia", 12, True, 0, 2, 1, 1)
GUICtrlSetResizing($gmap_ctrl, $GUI_DOCKTOP)

$main_tab = GUICtrlCreateTab(5, 455, 785, 120)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$view_tabitem = GUICtrlCreateTabItem("View")
$set_view_button = GUICtrlCreateButton("Set View to", 10, 485, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$set_view_input = GUICtrlCreateInput("Sydney, NSW", 100, 485, 180, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$zoom_view_button = GUICtrlCreateButton("Zoom view to", 10, 505, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$zoom_view_input = GUICtrlCreateInput("6", 100, 505, 180, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
GUICtrlCreateLabel("Map Type:", 290, 485, 100, 20)
$map_type_list = GUICtrlCreateList("", 290, 505, 100, 70, BitOR($WS_BORDER, $WS_VSCROLL))
GUICtrlSetData(-1, "Roadmap|Satellite|Hybrid|Terrain")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)

$markers_tabitem = GUICtrlCreateTabItem("Markers")
$add_marker_button = GUICtrlCreateButton("Add Marker to", 10, 485, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$add_marker_input = GUICtrlCreateInput("Currumbin, Queensland, Australia", 100, 485, 180, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$view_markers_after_add_checkbox = GUICtrlCreateCheckbox("View All Markers after Add", 10, 505)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
GUICtrlSetState($view_markers_after_add_checkbox, $GUI_CHECKED)
GUICtrlCreateLabel("Marker icon to use:", 290, 485, 100, 20)
$marker_icon_list = GUICtrlCreateList("", 290, 505, 100, 70)
GUICtrlSetData(-1, "<default>|A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z")
$hide_markers_checkbox = GUICtrlCreateCheckbox("Hide All Markers", 400, 485, 100, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$delete_markers_button = GUICtrlCreateButton("Delete All Markers", 400, 505, 100, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$view_markers_button = GUICtrlCreateButton("View All Markers", 400, 525, 100, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)

$directions_tabitem = GUICtrlCreateTabItem("Directions")
$add_route_button = GUICtrlCreateButton("Add Route", 10, 485, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
$get_route_button = GUICtrlCreateButton("Route Info", 10, 505, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
GUICtrlCreateLabel("from", 100, 485, 30, 20)
$start_route_input = GUICtrlCreateInput("Palm Beach, Queensland, Australia", 130, 485, 180, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
GUICtrlCreateLabel("to", 100, 505, 20, 20)
$end_route_input = GUICtrlCreateInput("Tugun, Queensland, Australia", 130, 505, 180, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)
GUICtrlCreateLabel("via", 100, 525, 30, 20)
$travel_mode_list = GUICtrlCreateList("", 130, 525, 100, 50, BitOR($WS_BORDER, $WS_VSCROLL))
GUICtrlSetData(-1, "Driving|Walking|Bicyling", "Driving")
GUICtrlCreateLabel("Distance (m)", 320, 485, 80, 20)
$distance_input = GUICtrlCreateInput("", 390, 485, 50, 20)
GUICtrlCreateLabel("Duration (sec)", 320, 505, 80, 20)
$duration_input = GUICtrlCreateInput("", 390, 505, 50, 20)
$directions_listview = GUICtrlCreateListView("Step #|Instruction|Distance (m)|Duration (sec)", 450, 485, 250, 85)
_GUICtrlListView_SetColumnWidth($directions_listview,0,55)
_GUICtrlListView_SetColumnWidth($directions_listview,1,350)
_GUICtrlListView_SetColumnWidth($directions_listview,2,90)
_GUICtrlListView_SetColumnWidth($directions_listview,3,90)

$map_tabitem = GUICtrlCreateTabItem("Map")
$hide_map_checkbox = GUICtrlCreateCheckbox("Hide Map", 10, 485, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)

GUICtrlCreateTabItem(""); 

$close_button = GUICtrlCreateButton("Close (Esc)", 705, 550, 80, 20)
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER)

dim $main_gui_accel[1][2]=[["{ESC}", $close_button]]

; Show Main GUI
GUISetState(@SW_SHOW)
GUISetAccelerators($main_gui_accel)

GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")

; Main Loop
while 1

	if $msg = $get_route_button Then
		
		$instruction = _GUICtrlGoogleMap_GetRoute($gmap, GUICtrlRead($start_route_input), GUICtrlRead($end_route_input), $distance, $duration, _GUICtrlListBox_GetCurSel($travel_mode_list))
		GUICtrlSetData($distance_input, $distance)
		GUICtrlSetData($duration_input, $duration)
		_GUICtrlListView_BeginUpdate($directions_listview)
		_GUICtrlListView_DeleteAllItems($directions_listview)
		
		if IsArray($instruction) Then
		
			for $instr_num = 0 to (UBound($instruction) - 1)
				
				GUICtrlCreateListViewItem(($instr_num + 1) & "|" & $instruction[$instr_num][0] & "|" & $instruction[$instr_num][1] & "|" & $instruction[$instr_num][2], $directions_listview)
			Next
		EndIf
		
		_GUICtrlListView_EndUpdate($directions_listview)
	EndIf

	if $msg = $add_route_button Then
		
		_GUICtrlGoogleMap_AddRoute($gmap, GUICtrlRead($start_route_input), GUICtrlRead($end_route_input), _GUICtrlListBox_GetCurSel($travel_mode_list))
	EndIf

	if $msg = $hide_map_checkbox Then
		
		if GUICtrlRead($hide_map_checkbox) = $GUI_CHECKED Then
			
			GUICtrlSetState($gmap_ctrl, $GUI_HIDE)
		Else
			
			GUICtrlSetState($gmap_ctrl, $GUI_SHOW)
		EndIf
	EndIf

	if $msg = $map_type_list Then
		
		_GUICtrlGoogleMap_SetMapType($gmap, _GUICtrlListBox_GetCurSel($map_type_list))
	EndIf

	if $msg = $view_markers_button Then
		
		_GUICtrlGoogleMap_ViewAllMarkers($gmap)
	EndIf
	
	if $msg = $delete_markers_button Then
		
		_GUICtrlGoogleMap_DeleteAllMarkers($gmap)
	EndIf

	if $msg = $hide_markers_checkbox Then

		if GUICtrlRead($hide_markers_checkbox) = $GUI_CHECKED Then
			
			_GUICtrlGoogleMap_HideAllMarkers($gmap)
		Else
			
			_GUICtrlGoogleMap_ShowAllMarkers($gmap)
		EndIf
	EndIf

	if $msg = $set_view_button Then
		
		_GUICtrlGoogleMap_SetView($gmap, GUICtrlRead($set_view_input))
	EndIf

	if $msg = $zoom_view_button Then
		
		_GUICtrlGoogleMap_ZoomView($gmap, GUICtrlRead($zoom_view_input))
	EndIf

	if $msg = $add_marker_button Then
		
		$marker_icon_url = ""
		
		if StringCompare(GUICtrlRead($marker_icon_list), "<default>") <> 0 Then
			
			$marker_icon_url = "http://www.google.com/mapfiles/marker" & GUICtrlRead($marker_icon_list) & ".png"
		EndIf
		
		_GUICtrlGoogleMap_AddMarker($gmap, GUICtrlRead($add_marker_input), $marker_icon_url)
		
		if GUICtrlRead($view_markers_after_add_checkbox) = $GUI_CHECKED Then
			
			_GUICtrlGoogleMap_ViewAllMarkers($gmap)
		EndIf
	EndIf

	If $msg = $GUI_EVENT_CLOSE or $msg = $close_button Then
		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

GUIDelete()

Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
    Local $nNotifyCode = BitShift($wParam, 16) ; high word
    Local $nID = BitAND($wParam, 0xFFFF) ; low word
    Local $hCtrl = $lParam
    
	Switch $nID
		
		Case $set_view_input
			
			Switch $nNotifyCode

				Case $EN_SETFOCUS
					
					GUICtrlSetState($set_view_button, $GUI_DEFBUTTON)
			EndSwitch
		
		Case $zoom_view_input
			
			Switch $nNotifyCode

				Case $EN_SETFOCUS
					
					GUICtrlSetState($zoom_view_button, $GUI_DEFBUTTON)
			EndSwitch
		
		Case $add_marker_input
			
			Switch $nNotifyCode

				Case $EN_SETFOCUS
					
					GUICtrlSetState($add_marker_button, $GUI_DEFBUTTON)
			EndSwitch
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_COMMAND
