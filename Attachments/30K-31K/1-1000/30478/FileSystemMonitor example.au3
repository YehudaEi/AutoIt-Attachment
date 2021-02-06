#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListviewConstants.au3>
#Include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <FileSystemMonitor.au3>

dim $msg

; GUI Setup

$main_gui = GUICreate("Shell Notification Monitor (Press ESC to close)", 800, 320, -1, -1, -1, $WS_EX_TOPMOST)
$path_input = GUICtrlCreateInput("C:\", 10, 10, 320)
$use_path_button = GUICtrlCreateButton("Use Path", 350, 10)
$listview = GUICtrlCreateListView("", 10, 40, 780, 250, $LVS_REPORT)
_GUICtrlListView_SetUnicodeFormat($listview, False)
_GUICtrlListView_InsertColumn($listview, 0, "Type", 200)
_GUICtrlListView_InsertColumn($listview, 1, "Name (Hex)", 200)
_GUICtrlListView_InsertColumn($listview, 2, "Value", 200)
_GUICtrlListView_InsertColumn($listview, 3, "Time", 100)
GUISetState(@SW_SHOW)

; Setup File System Monitoring
_FileSysMonSetup(3, "C:\", "")

; Main Loop

While 1

	; Handle Directory related events
	_FileSysMonDirEventHandler()

	If $msg = $use_path_button then 

		_FileSysMonSetDirMonPath(GUICtrlRead($path_input))
		_FileSysMonSetShellMonPath(GUICtrlRead($path_input))
	EndIf

	If $msg = $GUI_EVENT_CLOSE then 
		
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

Func _FileSysMonActionEvent($event_type, $event_id, $event_value)

	Local $event_type_name
	Local $fs_event = ObjCreate("Scripting.Dictionary")

	Switch $event_type
		
		Case 0

			$fs_event.item(Hex(0x00000001)) = "file added to the directory|FILE_ACTION_ADDED"
			$fs_event.item(Hex(0x00000002)) = "file removed from the directory|FILE_ACTION_REMOVED"
			$fs_event.item(Hex(0x00000003)) = "file was modified|FILE_ACTION_MODIFIED"
			$fs_event.item(Hex(0x00000004)) = "file was renamed old name|FILE_ACTION_RENAMED_OLD_NAME"
			$fs_event.item(Hex(0x00000005)) = "file was renamed new name|FILE_ACTION_RENAMED_NEW_NAME"

		Case 1

			$fs_event.item(Hex(0x00000001)) = "Non-folder item name changed|SHCNE_RENAMEITEM"
			$fs_event.item(Hex(0x00000002)) = "Non-folder item created|SHCNE_CREATE"
			$fs_event.item(Hex(0x00000004)) = "Non-folder item deleted|SHCNE_DELETE"
			$fs_event.item(Hex(0x00000008)) = "Folder created|SHCNE_MKDIR"
			$fs_event.item(Hex(0x00000010)) = "Folder removed|SHCNE_RMDIR"
			$fs_event.item(Hex(0x00000020)) = "Storage media inserted into a drive|SHCNE_MEDIAINSERTED"
			$fs_event.item(Hex(0x00000040)) = "Storage media removed from a drive|SHCNE_MEDIAREMOVED"
			$fs_event.item(Hex(0x00000080)) = "Drive removed|SHCNE_DRIVEREMOVED"
			$fs_event.item(Hex(0x00000100)) = "Drive added|SHCNE_DRIVEADD"
			$fs_event.item(Hex(0x00000200)) = "Local computer folder shared via the network|SHCNE_NETSHARE"
			$fs_event.item(Hex(0x00000400)) = "Local computer folder not shared via the network|SHCNE_NETUNSHARE"
			$fs_event.item(Hex(0x00000800)) = "Item or folder attributes have changed|SHCNE_ATTRIBUTES"
			$fs_event.item(Hex(0x00001000)) = "Folder content has changed|SHCNE_UPDATEDIR"
			$fs_event.item(Hex(0x00002000)) = "Folder or non-folder has changed|SHCNE_UPDATEITEM"
			$fs_event.item(Hex(0x00004000)) = "Computer disconnected from server|SHCNE_SERVERDISCONNECT"
			$fs_event.item(Hex(0x00008000)) = "System image list image has changed|SHCNE_UPDATEIMAGE"
			$fs_event.item(Hex(0x00010000)) = "Not used|SHCNE_DRIVEADDGUI"
			$fs_event.item(Hex(0x00020000)) = "Folder name has changed|SHCNE_RENAMEFOLDER"
			$fs_event.item(Hex(0x00040000)) = "Drive free space has changed|SHCNE_FREESPACE"
			$fs_event.item(Hex(0x0002381F)) = "SHCNE_DISKEVENTS"
			$fs_event.item(Hex(0x0C0581E0)) = "SHCNE_GLOBALEVENTS"
			$fs_event.item(Hex(0x7FFFFFFF)) = "SHCNE_ALLEVENTS"
			$fs_event.item(Hex(0x80000000)) = "SHCNE_INTERRUPT"
	EndSwitch
	
	if StringLen($fs_event.item(Hex($event_id))) > 0 Then
	
		$event_type_name = StringSplit($fs_event.item(Hex($event_id)), "|")
		$event_type_name[2] = $event_type_name[2] & "(" & $event_id & ")"
		
		_GUICtrlListView_InsertItem($listview, $event_type_name[1], 0)
		_GUICtrlListView_SetItemText($listview, 0, $event_type_name[2], 1)
		_GUICtrlListView_SetItemText($listview, 0, $event_value, 2)
		_GUICtrlListView_SetItemText($listview, 0, @HOUR & ":" & @MIN & ":" & @SEC, 3)
	EndIf
EndFunc
