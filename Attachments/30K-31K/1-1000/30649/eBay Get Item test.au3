#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <Array.au3>
#Include <GuiListView.au3>
#include <eBay.au3>

Const $main_gui_width = 640, $main_gui_height = 480, $std_button_width = 70, $std_button_height = 20, $std_button_gap = 10, $std_input_width = 200
dim $msg

$main_gui = GUICreate("eBay Get Item test", $main_gui_width, $main_gui_height)
GUICtrlCreateLabel("App ID:", 10, 10, 40, 20)
$appid_input = GUICtrlCreateInput("<put your Application ID here>", 90, 10, 400, 20)
GUICtrlCreateLabel("Item ID:", 10, 30, 40, 20)
$itemid_input = GUICtrlCreateInput("<put the Item ID here>", 90, 30, 400, 20)
GUICtrlCreateLabel("IncludeSelector:", 10, 50, 80, 20)
$include_selector_input = GUICtrlCreateInput("Details,Description,TextDescription,ShippingCosts,ItemSpecifics,Variations", 90, 50, 400, 20)
$get_item_button = GUICtrlCreateButton("Get Item", 10, 80, 80, 20)
$get_item_status_button = GUICtrlCreateButton("Get Item Status", 100, 80, 80, 20)
$response_listview = GUICtrlCreateListView("Name|Value", 10, 100, 600, 370);,$LVS_SORTDESCENDING)
_GUICtrlListView_SetColumnWidth($response_listview,0,200)
_GUICtrlListView_SetColumnWidth($response_listview,1,380)

; Display the GUI
GUISetState()

; Main loop
While 1

	if $msg = $get_item_button Then
		
		$item_dict = _eBay_GetSingleItem(GUICtrlRead($appid_input), GUICtrlRead($itemid_input), GUICtrlRead($include_selector_input))

		_GUICtrlListView_DeleteAllItems($response_listview)

		$item_key = $item_dict.Keys
		
		For $i = 0 To ($item_dict.Count - 1)
			
			GUICtrlCreateListViewItem($item_key[$i] & "|" & $item_dict.item($item_key[$i]), $response_listview)
		Next
	EndIf

	if $msg = $get_item_status_button Then
		
		$item_dict = _eBay_GetItemStatus(GUICtrlRead($appid_input), GUICtrlRead($itemid_input))

		_GUICtrlListView_DeleteAllItems($response_listview)

		$item_key = $item_dict.Keys
		
		For $i = 0 To ($item_dict.Count - 1)
			
			GUICtrlCreateListViewItem($item_key[$i] & "|" & $item_dict.item($item_key[$i]), $response_listview)
		Next
		
	EndIf

	if $msg = $GUI_EVENT_CLOSE Then
		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

GUIDelete()
