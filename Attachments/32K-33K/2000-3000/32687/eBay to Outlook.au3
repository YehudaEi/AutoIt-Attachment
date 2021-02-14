#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Date.au3>
#Include <Array.au3>
#Include <GuiListView.au3>

#Region Header
Dim $time,$title,$address
$signin = "Sign In: https://signin.ebay.com/ws/eBayISAPI.dll?SignIn"
FileDelete("C:\windows\eBay.txt")
FileDelete("C:\windows\eBay.vbs")
Func _eBay_GetSingleItem($appid, $ItemID, $IncludeSelector = "")
	
	Local $nv_response = ObjCreate("Scripting.Dictionary")
	
	If StringLen($IncludeSelector) > 0 Then $IncludeSelector = "&IncludeSelector=" & $IncludeSelector
	
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET","                                                                                   " & $appid & "&siteid=0&version=515" & $IncludeSelector & "&ItemID=" & $ItemID)
	$oHTTP.Send()
	$HTMLSource = $oHTTP.Responsetext 
	
	; Split the name-value pairs into seperate array items
	$arr = StringSplit($HTMLSource, "&")
;	_ArrayDisplay($arr)

	; Join incorrectly split text (ie. "&amp")
	$i = 0
	While $i < UBound($arr)
		
		$start = $i - 1
		
		While StringLen($arr[$i]) >= 4 and StringCompare(StringLeft($arr[$i], 4), "amp;") = 0
			
			$arr[$start] = $arr[$start] & "&" & $arr[$i]
			_ArrayDelete($arr, $i)
		WEnd
		
		$i = $i + 1
	WEnd
	
	_ArrayDelete($arr, 0)
	
	; for each name-value pair
	For $each in $arr
		
		$seperator_pos = StringInStr($each, "=")
		$name = StringLeft($each, $seperator_pos-1)
		$value = StringMid($each, $seperator_pos+1)
		ConsoleWrite("name:" & $name & "|val:" & $value & @CRLF)
		$filename = "C:\windows\eBay.txt"
		FileWrite($filename, $each & @CRLF)
		
		if StringCompare($name, "Item.EndTime") = 0 Then
			$time = StringReplace($value, "-", "/")
			$time = StringReplace($time, "T", " ")
			$time = StringTrimRight($time, 5)
			;MsgBox(0, "Greenwich eBay Ending Time", $time)
			$Inter1 = -5 ;Timezone EST is -5
			$Inter2 = -1 ;Remove one minute just for good luck
			$time =  _DateAdd( 'h',$Inter1, $time)
			$time =  _DateAdd( 'n',$Inter2, $time)
			;MsgBox(0,"EST -5",$time)
		Else
			$nv_response.item($name) = $value
		EndIf
		
		if StringCompare($name, "Item.ViewItemURLForNaturalSearch") = 0 Then
			$address = $value
		Else
			$nv_response.item($name) = $value
		EndIf
		
		if StringCompare($name, "Item.Title") = 0 Then
			$title = $value
		Else
			$nv_response.item($name) = $value
		EndIf
	Next
	Return $nv_response
EndFunc


; ---------------------------------------Part Two----------------------------------------------


Const $main_gui_width = 640, $main_gui_height = 480, $std_button_width = 70, $std_button_height = 20, $std_button_gap = 10, $std_input_width = 200
dim $msg

$main_gui = GUICreate("eBay Get Item", $main_gui_width, $main_gui_height)
;GUICtrlCreateLabel("App ID:", 10, 10, 40, 20)
;$appid_input = GUICtrlCreateInput("xxxxxxxx-6e3a-4409-8089-1d7edfe4d8e3", 90, 10, 400, 20)
$itemid = GUICtrlCreateLabel("Item ID:", 10, 30, 40, 20)
$itemid_input = GUICtrlCreateInput("", 90, 30, 400, 20)
;GUICtrlCreateLabel("IncludeSelector:", 10, 50, 80, 20)
;$include_selector_input = GUICtrlCreateInput("Details,Description,TextDescription,ShippingCosts,ItemSpecifics,Variations", 90, 50, 400, 20)
$get_item_button = GUICtrlCreateButton("Add to Outlook Calendar", 10, 80, 130, 20)
;$get_item_status_button = GUICtrlCreateButton("Get Item Status", 100, 80, 80, 20)
$get_item_status_button = ""
$response_listview = GUICtrlCreateListView("Name|Value", 10, 100, 600, 370);,$LVS_SORTDESCENDING)
_GUICtrlListView_SetColumnWidth($response_listview,0,200)
_GUICtrlListView_SetColumnWidth($response_listview,1,380)

; Display the GUI
GUISetState()

$appid_input = "xxxxxxxx-6e3a-4409-8089-1d7edfe4d8e3"
$include_selector_input = "Details,Description,TextDescription,ShippingCosts,ItemSpecifics,Variations"

; Main loop
While 1

	if $msg = $get_item_button Then
		GUICtrlSetState($itemid_input, $GUI_HIDE)
		GUICtrlSetState($get_item_button, $GUI_HIDE)
		GUICtrlSetState($itemid, $GUI_HIDE)
		 
		;$item_dict = _eBay_GetSingleItem(GUICtrlRead($appid_input), GUICtrlRead($itemid_input), GUICtrlRead($include_selector_input))
		$item_dict = _eBay_GetSingleItem($appid_input, GUICtrlRead($itemid_input), $include_selector_input)
		_GUICtrlListView_DeleteAllItems($response_listview)

		$item_key = $item_dict.Keys
		
		For $i = 0 To ($item_dict.Count - 1)
			GUICtrlCreateListViewItem($item_key[$i] & "|" & $item_dict.item($item_key[$i]), $response_listview)
		Next
		$filename1 = "C:\windows\eBay.vbs"
		FileWrite($filename1, "On error resume next" & @CRLF)
		FileWrite($filename1, "Const ForAppending = 8" & @CRLF)
		FileWrite($filename1, "Set objFSO = CreateObject" & "(""" & "Scripting.FileSystemObject" & """)" & @CRLF)
		FileWrite($filename1, "Set objNetwork = CreateObject" & "(""" & "WScript.Network" & """)" & @CRLF)
		FileWrite($filename1, "Set objOutlook = CreateObject" & "(""" & "Outlook.Application" & """)" & @CRLF)
		FileWrite($filename1, "Set itmAppt = objOutlook.CreateItem(1" & ")" & @CRLF)
		FileWrite($filename1, "itmAppt.Start = """ & $time & """" & @CRLF)
		FileWrite($filename1, "itmAppt.Duration = 60" & @CRLF)
		FileWrite($filename1, "itmAppt.Subject = " & """eBay Item Ending - " & $title & """" & @CRLF)
		FileWrite($filename1, "itmAppt.ReminderSet = True" & @CRLF)
		FileWrite($filename1, "itmAppt.ReminderMinutesBeforeStart = 30" & @CRLF)
		FileWrite($filename1, "itmAppt.Body = """ & $signin & """ & vbcr & vbcr & ""Item: " & $address & """" & @CRLF)
		FileWrite($filename1, "itmAppt.Save" & @CRLF)
		runwait("wscript.exe C:\windows\eBay.vbs")
		MsgBox(0, "Added", "Your item has been entered into Outlook Calendar")
	EndIf

	if $msg = $GUI_EVENT_CLOSE Then		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
	
WEnd

GUIDelete()
