#include-once
#include <WinAPI.au3>
#Region Header
#cs
	Title:   		File System Monitoring UDF Library for AutoIt3
	Filename:  		FileSystemMonitor.au3
	Description: 	A collection of functions for monitoring the Windows File System
	Author:   		seangriffin
	Version:  		V0.4
	Last Update: 	02/05/10
	Requirements: 	AutoIt3 3.2 or higher
	Changelog:		---------02/05/10---------- v0.4
					Updated "FileSystemMonitor example.au3" to include an $event_id check and filter for unexpected events.
					Fixed "FileSystemMonitor Explorer example.au3" to exclude the "_GUICtrlListView_SetUnicodeFormat" call.
					Fixed "$LVN_ENDLABELEDIT" to be "$LVN_ENDLABELEDITA" in "FileSystemMonitor Explorer example.au3" for better compatibility.
	
					---------01/05/10---------- v0.3
					Removed the $shell_gui param from functions.  Not required, now managed internally.
					Updated "FileSystemMonitor Explorer example.au3" to select drive "C" if the currently selected drive is disconnected.
					Fixed error in "FileSystemMonitor Explorer example.au3" when an inactive drive is selected.
					Updated "FileSystemMonitor Explorer example.au3" to use $scroll_checkbox.
					Updated "FileSystemMonitor Explorer example.au3" to allow file/folder rename (F2) and deletion (Delete).
	
					---------01/05/10---------- v0.2
					Removed unused external UDF references.
					Updated remarks to indicate that the user must create _FileSysMonActionEvent.
					Removed the use of $old_Filename (a failed attempt to hide duplicate events).
					Fixed a bug where _FileSysMonSetDirMonPath() was still reporting the next change in the previous path.
	
					---------29/04/10---------- v0.1
					Initial release.
					
#ce
#EndRegion Header
#Region Global Variables and Constants
Global $pDirEvents, $hDir, $pOverLapped, $tFNI, $pBuffer, $Filename, $register, $iBufferSize, $tOverLapped
Global $tBuffer, $tDirEvents, $iDirEvents, $hEvent, $fsm_shell_mon_gui = GUICreate("")
#EndRegion Global Variables and Constants
#Region Core functions
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
func _FileSysMonSetup($monitor_type = 3, $dir_monitor_path = "C:\", $shell_monitor_path = "")

	if $monitor_type = 1 or $monitor_type = 3 Then
	
		; Setup the Directory Event Handler

		$sdir = $dir_monitor_path
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
	EndIf

	; Setup the Shell Event Handler

	if $monitor_type = 2 or $monitor_type = 3 Then

		; Register a window message to associate an AutoIT function with the change notification events
		$SHNOTIFY = _WinAPI_RegisterWindowMessage("shchangenotifymsg")
		GUIRegisterMsg($SHNOTIFY, "_FileSysMonShellEventHandler")

		; Setup the structure for registering the gui to receive shell notifications

		if StringCompare($shell_monitor_path, "") <> 0 Then
		
			$ppidl = DllCall("shell32.dll", "ptr", "ILCreateFromPath", "wstr", $shell_monitor_path)
		EndIf
		
		$shnotifystruct = DllStructCreate("ptr pidl; int fRecursive")
		
		if StringCompare($shell_monitor_path, "") <> 0 Then

			DllStructSetData($shnotifystruct, "pidl", $ppidl[0])
		Else
		
			DllStructSetData($shnotifystruct, "pidl", 0)
		EndIf
		
		DllStructSetData($shnotifystruct, "fRecursive", 0)

		; Register the gui to receive shell notifications
		$register = DllCall("shell32.dll", "int", "SHChangeNotifyRegister", "hwnd", $fsm_shell_mon_gui, "int", BitOR(0x0001, 0x0002), "long", 0x7FFFFFFF, "uint", $SHNOTIFY, "int", 1, "ptr", DllStructGetPtr($shnotifystruct))
		
		if StringCompare($shell_monitor_path, "") <> 0 Then
		
			DllCall("ole32.dll", "none", "CoTaskMemFree", "ptr", $ppidl[0])
		EndIf
	EndIf
	
	Return True
EndFunc

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
func _FileSysMonSetDirMonPath($dir_monitor_path = "C:\")

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

; #FUNCTION# ;===============================================================================
;
; Name...........:	_FileSysMonSetShellMonPath()
; Description ...:	Change the path of Shell Monitoring
; Syntax.........:	_FileSysMonSetShellMonPath($dir_monitor_path = "")
; Parameters ....:	$dir_monitor_path	- Optional: The path to use for shell monitoring.
;											The path "" is used if one isn't provided.
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False.
;							
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
;					
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _FileSysMonSetShellMonPath($shell_monitor_path = "")

	; De-Register the gui from receiving shell notifications
	DllCall("shell32.dll", "int", "SHChangeNotifyDeregister", "ulong", $register[0])

	; Register a window message to associate an AutoIT function with the change notification events
	$SHNOTIFY = _WinAPI_RegisterWindowMessage("shchangenotifymsg")
	GUIRegisterMsg($SHNOTIFY, "_FileSysMonShellEventHandler")

	; Setup the structure for registering the gui to receive shell notifications

	if StringCompare($shell_monitor_path, "") <> 0 Then
	
		$ppidl = DllCall("shell32.dll", "ptr", "ILCreateFromPath", "wstr", $shell_monitor_path)
	EndIf
	
	$shnotifystruct = DllStructCreate("ptr pidl; int fRecursive")
	
	if StringCompare($shell_monitor_path, "") <> 0 Then

		DllStructSetData($shnotifystruct, "pidl", $ppidl[0])
	Else
	
		DllStructSetData($shnotifystruct, "pidl", 0)
	EndIf
	
	DllStructSetData($shnotifystruct, "fRecursive", 0)

	; Register the gui to receive shell notifications
	$register = DllCall("shell32.dll", "int", "SHChangeNotifyRegister", "hwnd", $fsm_shell_mon_gui, "int", BitOR(0x0001, 0x0002), "long", 0x7FFFFFFF, "uint", $SHNOTIFY, "int", 1, "ptr", DllStructGetPtr($shnotifystruct))
	
	if StringCompare($shell_monitor_path, "") <> 0 Then
	
		DllCall("ole32.dll", "none", "CoTaskMemFree", "ptr", $ppidl[0])
	EndIf

	Return True
EndFunc

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
;					
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _FileSysMonDirEventHandler()
	
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


; #FUNCTION# ;===============================================================================
;
; Name...........:	_FileSysMonShellEventHandler()
; Description ...:	Monitors the file system for shell events.
; Syntax.........:	_FileSysMonShellEventHandler()
; Parameters ....:	$hWnd			- The Window handle of the GUI in which the message appears.
;					$Msg			- The Windows message ID.
;					$wParam			- The first message parameter as hex value.
;					$lParam			- The second message parameter as hex value.
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
;							
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	If a directory was provided in "_FileSysMonSetup" then only events in
;					that directory will be caught.  If no directory was provided, then
;					system-wide events will be caught.
;
;					This function utilises the "SHChangeNotifyRegister" Win32 operating system functionality 
;					monitor a system or directory for changes relating to the Windows shell.
;
;					The function "_FileSysMonSetup" must be called, with a $monitor_type
;					of either 2 or 3, prior to calling this	function.
;
;					A call to this function is not required.  It is triggered automatically
;					for each new shell event.
;
;					A user-defined function to action the events is required to be created by the user
;					in the calling script, and must be defined as follows:
;
;					Func _FileSysMonActionEvent($event_type, $event_id, $event_value)
;
;					EndFunc
;					
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _FileSysMonShellEventHandler($hWnd, $Msg, $wParam, $lParam)

	Local $path, $Destination, $ret, $wHighBit

    $path = DllStructCreate("dword dwItem1; dword dwItem2", $wParam)
    $ret = DllCall("shell32.dll", "int", "SHGetPathFromIDList", "ptr", DllStructGetData($path, "dwItem1"), "str", "")
	
	; Get the drive for which free space has changed
	if $lParam = 0x00040000 Then
	
		$Destination = DllStructCreate("long")
		DllCall("kernel32.dll", "none", "RtlMoveMemory", "ptr", DllStructGetPtr($Destination), "ptr", (DllStructGetData($path, "dwItem1")+2),"int", 4)	; CopyMemory
		$wHighBit = Int(Log(DllStructGetData($Destination, 1)) / Log(2))
		$ret[2] = Chr(65 + $wHighBit)
	EndIf

	if $lParam <> 0x00000002 And $lParam <> 0x00000004 Then ; FILE_ACTION_ADDED & FILE_ACTION_REMOVED skipped due to a deadlock with Directory_Event_Handler()

		_FileSysMonActionEvent(1, $lParam, $ret[2])
	EndIf
	
	Return True
EndFunc
