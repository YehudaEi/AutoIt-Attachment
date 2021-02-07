#include <GuiListView.au3>
;
Global $pDirEvents, $hDir, $pOverLapped, $tFNI, $pBuffer, $Filename, $register, $iBufferSize, $tOverLapped, $ItemType
Global $tBuffer, $tDirEvents, $iDirEvents, $hEvent, $fsm_shell_mon_gui = GUICreate("")
;
Global $ff = (@ScriptDir & '\Test.txt')
Global $fo = FileOpen($ff, 1)
;
Dim $msg
;
; GUI Setup
;
$main_gui = GUICreate("Shell Notification Monitor (Press ESC to close)", 510, 400, -1, -1, -1);, $WS_EX_TOPMOST)
$path_input = GUICtrlCreateInput(@TempDir, 140, 10, 355)
$use_path_button = GUICtrlCreateButton("Open Path to Monitor", 10, 8, 120)
$listview = GUICtrlCreateListView("", 10, 40, 490, 350);, $LVS_REPORT)
_GUICtrlListView_InsertColumn($listview, 0, "Event", 150)
_GUICtrlListView_InsertColumn($listview, 1, "File or Folder", 250)
_GUICtrlListView_InsertColumn($listview, 2, "Time", 70)
GUISetState(@SW_SHOW)
;
_FileSysMonSetup(1, @TempDir, ""); Setup File System Monitoring
;
; Main Loop
While 1
	_FileSysMonDirEventHandler(); Handle Directory related events
	If $msg = $use_path_button Then
		$fsf = FileSelectFolder("Choose Path to Set", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
		If $fsf Then
			GUICtrlSetData($path_input, $fsf)
			_FileSysMonSetDirMonPath($fsf)
		EndIf
	EndIf
	If $msg = -3 Then
		FileClose($fo)
		ExitLoop
	EndIf
	$msg = GUIGetMsg()
WEnd
;
Func _FileSysMonActionEvent($event_type, $event_id, $event_value)
	Local $event_type_name, $ItemType
	Local $fs_event = ObjCreate("Scripting.Dictionary")
	$attrib1 = FileGetAttrib(@TempDir & '\' & $event_value)
	$attrib2 = StringInStr($attrib1, 'D', 0, 1)
	;
	Switch $attrib2
		Case 1
			$ItemType = 'Folder'
		Case Else
			$ItemType = 'File'
	EndSwitch
	;
	Switch $event_id
		Case 1
			FileWriteLine($fo, $ItemType & '_ADDED: ' & $event_value & @CRLF)
		Case 2
			FileWriteLine($fo, 'ITEM_REMOVED: ' & $event_value & @CRLF)
		Case 3
			;FileWriteLine($fo, 'ITEM_PROPERTIES: ' & $event_value & @CRLF)
		Case 4
			FileWriteLine($fo, 'ITEM_RENAME_OLD: ' & $event_value & @CRLF)
		Case 5
			FileWriteLine($fo, $ItemType & '_RENAME_NEW: ' & $event_value & @CRLF)
	EndSwitch
	;
	$fs_event.item(Hex(0x00000001)) = $ItemType & " Added|FILE_ADDED"
	$fs_event.item(Hex(0x00000002)) = "Item Removed|FILE_REMOVED"
	;$fs_event.item(Hex(0x00000003)) = "Item Properties|FILE_PROPERTIES"
	$fs_event.item(Hex(0x00000004)) = "Item Rename Old|FILE_RENAME_OLD_NAME"
	$fs_event.item(Hex(0x00000005)) = $ItemType & " Rename New|FILE_RENAME_NEW_NAME"
	;
	If StringLen($fs_event.item(Hex($event_id))) > 0 Then
		$event_type_name = StringSplit($fs_event.item(Hex($event_id)), "|")
		_GUICtrlListView_InsertItem($listview, $event_type_name[1], 0)
		_GUICtrlListView_SetItemText($listview, 0, $event_value, 1)
		_GUICtrlListView_SetItemText($listview, 0, @HOUR & ":" & @MIN & ":" & @SEC, 2)
	EndIf
EndFunc
;
; ### UDF's ###
;
; #FUNCTION# ;===============================================================================
;
; Name...........:	_FileSysMonSetup()
; Description ...:	Setup File System Montioring.
; Syntax.........:	_FileSysMonSetup($monitor_type = 3, $dir_monitor_path = "C:\", $shell_monitor_path = "")
; Parameters ....:	$monitor_type		- Optional: The type of monitoring to use.
;											1 = directory monitoring only
;											2 = shell monitoring only
;											3 = both directory and shell monitoring
;					$dir_monitor_path	- Optional: The path to use for directory monitoring.
;											The path "C:\" is used if one isn't provided.
;					$shell_monitor_path	- Optional: The path to use for shell monitoring.
;											The blank path is used if one isn't provided. This
;											denotes that system-wide shell events will be monitored.
; Return values .: 	On Success			- Returns True.
;                 	On Failure			- Returns False.
;
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:	A call to this function should be inserted in a script prior to calling other
;					functions in this UDF.  Ideally the function should be placed before
;					the main message loop in a GUI-based script.
;
; Related .......:
; Link ..........:
; Example .......:	Yes
;
; ;==========================================================================================
Func _FileSysMonSetup($monitor_type = 1, $dir_monitor_path = "", $shell_monitor_path = "")
	$sdir = $dir_monitor_path; Setup the Directory Event Handler
	$tBuffer = DllStructCreate("byte[4096]")
	$pBuffer = DllStructGetPtr($tBuffer)
	$iBufferSize = DllStructGetSize($tBuffer)
	$tFNI = 0
	$hDir = DllCall("kernel32.dll", "hwnd", "CreateFile", "Str", $sdir, "Int", 0x1, "Int", BitOR(0x1, 0x4, 0x2), "ptr", 0, "int", 0x3, "int", BitOR(0x2000000, 0x40000000), "int", 0)
	$hDir = $hDir[0]
	$tReadLen = DllStructCreate("dword ReadLen")
	$tOverLapped = DllStructCreate("Uint OL1;Uint OL2; Uint OL3; Uint OL4; hwnd OL5")
	For $i = 1 To 5
		DllStructSetData($tOverLapped, $i, 0)
	Next
	$pOverLapped = DllStructGetPtr($tOverLapped)
	$iOverLappedSize = DllStructGetSize($tOverLapped)
	$tDirEvents = DllStructCreate("hwnd DirEvents")
	$pDirEvents = DllStructGetPtr($tDirEvents)
	$iDirEvents = DllStructGetSize($tDirEvents)
	$hEvent = DllCall("kernel32.dll", "hwnd", "CreateEvent", "UInt", 0, "Int", True, "Int", False, "UInt", 0)
	DllStructSetData($tOverLapped, 5, $hEvent[0])
	DllStructSetData($tDirEvents, 1, $hEvent[0])
	$ret = DllCall("kernel32.dll", "Int", "ReadDirectoryChangesW", "hwnd", $hDir, "ptr", $pBuffer, "dword", $iBufferSize, "int", False, "dword", BitOR(0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x100), "Uint", 0, "Uint", $pOverLapped, "Uint", 0)
	$Filename = ""
	Return True
EndFunc
;
; #FUNCTION# ;===============================================================================
;
; Name...........:	_FileSysMonSetDirMonPath()
; Description ...:	Change the path of Directory Monitoring
; Syntax.........:	_FileSysMonSetDirMonPath($dir_monitor_path = "C:\")
; Parameters ....:	$dir_monitor_path	- Optional: The path to use for directory monitoring.
;											The path "C:\" is used if one isn't provided.
; Return values .: 	On Success			- Returns True.
;                 	On Failure			- Returns False.
;
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:	For an unknown reason, after this function is called the
;
; Related .......:
; Link ..........:
; Example .......:	Yes
;
; ;==========================================================================================
Func _FileSysMonSetDirMonPath($dir_monitor_path = "")
	$sdir = $dir_monitor_path
	$hDir = DllCall("kernel32.dll", "hwnd", "CreateFile", "Str", $sdir, "Int", 0x1, "Int", BitOR(0x1, 0x4, 0x2), "ptr", 0, "int", 0x3, "int", BitOR(0x2000000, 0x40000000), "int", 0)
	$hDir = $hDir[0]
	For $i = 1 To 5
		DllStructSetData($tOverLapped, $i, 0)
	Next
	$hEvent = DllCall("kernel32.dll", "hwnd", "CreateEvent", "UInt", 0, "Int", True, "Int", False, "UInt", 0)
	DllStructSetData($tOverLapped, 5, $hEvent[0])
	DllStructSetData($tDirEvents, 1, $hEvent[0])
	$ret = DllCall("kernel32.dll", "Int", "ReadDirectoryChangesW", "hwnd", $hDir, "ptr", $pBuffer, "dword", $iBufferSize, "int", False, "dword", BitOR(0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x100), "Uint", 0, "Uint", $pOverLapped, "Uint", 0)
	Return True
EndFunc
;
; #FUNCTION# ;===============================================================================
;
; Name...........:	_FileSysMonDirEventHandler()
; Description ...:	Monitors the file system for changes to a given directory.  If a change event occurs,
;						the user-defined "_FileSysMonActionEvent" function is called.
; Syntax.........:	_FileSysMonDirEventHandler()
; Parameters ....:	none
; Return values .: 	On Success			- Returns True.
;                 	On Failure			- Returns False.
;
; Author ........:	seangriffin
; Modified.......:
; Remarks .......:	This function utilises the "ReadDirectoryChangesW" Win32 operating system function to
;					monitor the a directory for changes.
;
;					The ReadDirectoryChangesW function appears to queue events, such that whenever
;					it is called, all unprocessed events are retrieved one at a time.
;
;					The function "_FileSysMonSetup" must be called, with a $monitor_type
;					of either 1 or 3, prior to calling this	function.
;
;					A call to this function should be inserted within the main message loop of a GUI-based script.
;
;					A user-defined function to action the events is required to be created by the user
;					in the calling script, and must be defined as follows:
;
;					Func _FileSysMonActionEvent($event_type, $event_id, $event_value)
;
;					EndFunc
; Related .......:
; Link ..........:
; Example .......:	Yes
;
; ;==========================================================================================
Func _FileSysMonDirEventHandler()
	Local $r, $iOffset, $nReadLen, $tStr, $iNext, $ff, $ret
	$r = DllCall("User32.dll", "dword", "MsgWaitForMultipleObjectsEx", "dword", 1, "ptr", $pDirEvents, "dword", 100, "dword", 0x4FF, "dword", 0x6)
	If $r[0] = 0 Then
		$iOffset = 0
		$nReadLen = 0
		DllCall("kernel32.dll", "Uint", "GetOverlappedResult", "hWnd", $hDir, "Uint", $pOverLapped, "UInt*", $nReadLen, "Int", True)
		While 1
			$tFNI = DllStructCreate("dword Next;dword Action;dword FilenameLen", $pBuffer + $iOffset)
			$tStr = DllStructCreate("wchar[" & DllStructGetData($tFNI, "FilenameLen") / 2 & "]", $pBuffer + $iOffset + 12)
			$Filename = DllStructGetData($tStr, 1)
			_FileSysMonActionEvent(0, DllStructGetData($tFNI, "Action"), $Filename)
			$iNext = DllStructGetData($tFNI, "Next")
			If $iNext = 0 Then ExitLoop
			$iOffset += $iNext
		WEnd
		$ff = DllStructGetData($tOverLapped, 5)
		DllCall("kernel32.dll", "Uint", "ResetEvent", "UInt", $ff)
		$ret = DllCall("kernel32.dll", "Int", "ReadDirectoryChangesW", "hwnd", $hDir, "ptr", $pBuffer, "dword", $iBufferSize, "int", False, "dword", BitOR(0x1, 0x2, 0x4, 0x8, 0x10, 0x20, 0x40, 0x100), "Uint", 0, "Uint", $pOverLapped, "Uint", 0)
	EndIf
	Return True
EndFunc
;
