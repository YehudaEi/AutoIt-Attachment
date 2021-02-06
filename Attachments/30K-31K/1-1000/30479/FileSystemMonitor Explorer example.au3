#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <ListviewConstants.au3>
#Include <GuiListView.au3>
#Include <GuiListBox.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#include <FileSystemMonitor.au3>

dim $msg
Global $old_item, $directory_listview, $drive_list, $path_input, $deleteitem, $renameitem, $old_name

; Get the list of drives
$drive = DriveGetDrive("all")
_ArrayDelete($drive, 0)
$drives = StringUpper(StringReplace(_ArrayToString($drive), ":", ""))

; Create GUI
$main_gui = GUICreate("FileSystemMonitor Explorer Example (Press ESC to close)", 400, 320, -1, -1, -1, $WS_EX_TOPMOST)
GUICtrlCreateLabel("Directory:", 10, 10, 50)
$path_input = GUICtrlCreateInput("C:\", 70, 10, 320, 20, $ES_READONLY)
GUICtrlCreateLabel("Drives", 10, 40, 50)
$drive_list = GUICtrlCreateList("", 10, 60, 40, 230)
GUICtrlSetData($drive_list, $drives)
GUICtrlCreateLabel("Directory Listing", 190, 40, 80)
$directory_listview = _GUICtrlListView_Create($main_gui, "", 70, 60, 320, 230, BitOR($LVS_EDITLABELS, $LVS_REPORT))
_GUICtrlListView_InsertColumn($directory_listview, 0, "Name", 300)
$scroll_checkbox = GUICtrlCreateCheckbox("Automatically scroll to new and changed items", 70, 295, 300)
GUICtrlSetState($scroll_checkbox, $GUI_CHECKED)
$deleteitem = GUICtrlCreateDummy()
$renameitem = GUICtrlCreateDummy()
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
dim $main_gui_accel[2][2]=[["{DELETE}", $deleteitem], ["{F2}", $renameitem]]

; Setup File System Monitoring
_FileSysMonSetup(3, "C:\", "")
UpdatePathListingMonitor("C:\")

; Show GUI
GUISetState(@SW_SHOW)
GUISetAccelerators($main_gui_accel)
_GUICtrlListView_ClickItem($directory_listview, 0)

; Main Loop
While 1

	; Handle Directory related events
	_FileSysMonDirEventHandler()

	If $msg = $drive_list then 
		
		UpdatePathListingMonitor(GUICtrlRead($drive_list) & ":\")
	EndIf

	If $msg = $renameitem then
		
		$old_name = GUICtrlRead($path_input) & StringReplace(_GUICtrlListView_GetItemTextString($directory_listview), "<DIR> ", "")
		_GUICtrlListView_EditLabel($directory_listview, int(_GUICtrlListView_GetSelectedIndices($directory_listview)))
	EndIf

	if $msg = $deleteitem Then

		$old_name = GUICtrlRead($path_input) & StringReplace(_GUICtrlListView_GetItemTextString($directory_listview), "<DIR> ", "")
		$ans = MsgBox(262148, "FileSystemMonitor Explorer - Recycle", "Do you want to recycle:" & @crlf & @crlf & $old_name)
		
		if $ans = 6 Then
		
			_GUICtrlListView_DeleteItem($directory_listview, int(_GUICtrlListView_GetSelectedIndices($directory_listview)))
			FileRecycle($old_name)
		EndIf
	EndIf

	If $msg = $GUI_EVENT_CLOSE then 
		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

Func _FileSysMonActionEvent($event_type, $event_id, $event_value)

	ConsoleWrite($event_type & "|" & $event_id & "|" & $event_value & @CRLF)
	
	Switch $event_type
	
		case 0
	
			Switch $event_id

				Case 0x00000001	; file / folder added
				
					ConsoleWrite("adding file / folder " & $event_value & @CRLF)
					
					; If the item is a folder
					if StringInStr(FileGetAttrib(GUICtrlRead($path_input) & $event_value), "D") > 0 Then $event_value = "<DIR> " & $event_value
					
					$new_index = ListViewGetSortedIndex($directory_listview, $event_value)
					_GUICtrlListView_InsertItem($directory_listview, $event_value, $new_index)
					
					if GUICtrlRead($scroll_checkbox) = $GUI_CHECKED Then
					
						_GUICtrlListView_EnsureVisible($directory_listview, $new_index)
						_GUICtrlListView_SetItemFocused($directory_listview, $new_index)
					EndIf

				Case 0x00000002	; file removed
				
					ConsoleWrite("removing file " & $event_value & @CRLF)
					_GUICtrlListView_DeleteItem($directory_listview, _GUICtrlListView_FindText($directory_listview, $event_value, -1, False))

				Case 0x00000004	; file / folder renamed - old name
					
					$old_item = $event_value

				Case 0x00000005	; file / folder renamed - new name

					ConsoleWrite("renaming file " & $old_item & " to " & $event_value & @CRLF)

					; If the item is a folder
					if StringInStr(FileGetAttrib(GUICtrlRead($path_input) & $event_value), "D") > 0 Then 

						$old_item = "<DIR> " & $old_item
						$event_value = "<DIR> " & $event_value
					EndIf

					_GUICtrlListView_DeleteItem($directory_listview, _GUICtrlListView_FindText($directory_listview, $old_item, -1, False))
					
					if _GUICtrlListView_FindText($directory_listview, $event_value) = -1 Then
					
						$new_index = ListViewGetSortedIndex($directory_listview, $event_value)
						_GUICtrlListView_InsertItem($directory_listview, $event_value, $new_index)
					
						if GUICtrlRead($scroll_checkbox) = $GUI_CHECKED Then
							
							_GUICtrlListView_EnsureVisible($directory_listview, $new_index)
							_GUICtrlListView_SetItemFocused($directory_listview, $new_index)
						EndIf
					EndIf
			EndSwitch
			
		case 1

			Switch $event_id

				Case 0x00000010	; folder removed

					ConsoleWrite("removing folder " & $event_value & @CRLF)
					$event_value = "<DIR> " & StringMid($event_value, StringInStr($event_value, "\", 0, -1) + 1)
					_GUICtrlListView_DeleteItem($directory_listview, _GUICtrlListView_FindText($directory_listview, $event_value, -1, False))

				Case 0x00000100	; drive added
				
					ConsoleWrite("adding drive " & $event_value & @CRLF)
					GUICtrlSetData($drive_list, StringReplace(StringReplace($event_value, ":", ""), "\", ""))
				
				case 0x00000080	; drive removed
				
					ConsoleWrite("removing drive " & $event_value & @CRLF)
					$event_value = StringReplace(StringReplace($event_value, ":", ""), "\", "")
					
					if StringCompare($event_value, GUICtrlRead($drive_list)) = 0 Then
						
						_GUICtrlListBox_SelectString($drive_list, "C")
						UpdatePathListingMonitor("C:\")
					EndIf
					
					_GUICtrlListBox_DeleteString($drive_list, _GUICtrlListBox_FindString($drive_list, $event_value, True))
			EndSwitch
	EndSwitch
EndFunc

Func ListViewGetSortedIndex($hWnd, $vValue)

	Local $iStart = 0, $iEnd = 0, $iUBound = _GUICtrlListView_GetItemCount($hWnd) - 1

	$iEnd = $iUBound
	Local $iMid = Int(($iEnd + $iStart) / 2)

	; Search
	While $iStart <= $iMid And $vValue <> _GUICtrlListView_GetItemText($hWnd, $iMid)
		
		If $vValue < _GUICtrlListView_GetItemText($hWnd, $iMid) Then
			$iEnd = $iMid - 1
		Else
			$iStart = $iMid + 1
		EndIf
		$iMid = Int(($iEnd + $iStart) / 2)
	WEnd

	Return ($iMid + 1)
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    
	#forceref $hWnd, $iMsg, $iwParam
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
    $hWndListView = $directory_listview
    If Not IsHWnd($directory_listview) Then $hWndListView = GUICtrlGetHandle($directory_listview)
    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    
	Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
                Case $NM_DBLCLK
                    
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
					
					ConsoleWrite(DllStructGetData($tInfo, "Index"))
					
					$item_text = _GUICtrlListView_GetItemText($directory_listview, DllStructGetData($tInfo, "Index"))
					
					if StringInStr($item_text, "<DIR> ") > 0 Then
					
						if StringCompare($item_text, "<DIR> ..") = 0 Then
							
							$new_path = StringLeft(GUICtrlRead($path_input), StringInStr(GUICtrlRead($path_input), "\", 0, -2))
						Else
					
							$new_path = GUICtrlRead($path_input) & StringReplace($item_text, "<DIR> ", "") & "\"
						EndIf
						
						UpdatePathListingMonitor($new_path)
					EndIf
				
				Case $LVN_ENDLABELEDITA, $LVN_ENDLABELEDITW ; The end of label editing for an item

					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
					Local $tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
					
					if DllStructGetData($tInfo, "Text") <> 0 Then
					
						$new_name = GUICtrlRead($path_input) & StringReplace(DllStructGetData($tBuffer, "Text"), "<DIR> ", "")
						
						if StringInStr(FileGetAttrib($old_name), "D") > 0 Then
							
							DirMove($old_name, $new_name)
						Else
						
							FileMove($old_name, $new_name)
						EndIf
						
						_GUICtrlListView_SetItemText($directory_listview, int(_GUICtrlListView_GetSelectedIndices($directory_listview)), DllStructGetData($tBuffer, "Text"))
					EndIf
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc

Func UpdatePathListingMonitor($path)
	
	GUICtrlSetData($path_input, $path)
	
	_GUICtrlListView_BeginUpdate($directory_listview)

	_GUICtrlListView_DeleteAllItems($directory_listview)

	; folders
	if StringInStr($path, "\", 0, 2) > 0 Then _GUICtrlListView_AddItem($directory_listview, "<DIR> ..")
	$foldername = _FileListToArray($path, "*", 2)
	
	if @error <> 4 and IsArray($foldername) and $foldername[0] > 0 Then
	
		_ArrayDelete($foldername, 0)
		for $each in $foldername

			_GUICtrlListView_AddItem($directory_listview, "<DIR> " & $each)
		Next
	EndIf

	; files
	$filename = _FileListToArray($path, "*", 1)
	
	if @error <> 4 and IsArray($filename) and $filename[0] > 0 Then
		
		_ArrayDelete($filename, 0)
		for $each in $filename

			_GUICtrlListView_AddItem($directory_listview, $each)
		Next
	EndIf

	_GUICtrlListView_EndUpdate($directory_listview)
	_GUICtrlListView_ClickItem($directory_listview, 0)
	
	_FileSysMonSetDirMonPath($path)
	_FileSysMonSetShellMonPath($path)
	
EndFunc
