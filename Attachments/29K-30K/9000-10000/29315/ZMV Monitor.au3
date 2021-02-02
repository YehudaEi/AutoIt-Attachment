#cs ----------------------------------------------------------------------------
 Version  : 1.0.0.1             (1.1.A.0)
 Author   : Zorphnog (M. Mims), Matthew Mansfield, Richard Vinck
 Function : Monitors the user defined directories for file activity.
#ce ----------------------------------------------------------------------------
#include <Constants.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include <GUIConstants.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
Global Const _
        $FILE_FLAG_BACKUP_SEMANTICS = 0x02000000, _
        $FILE_FLAG_OVERLAPPED       = 0x40000000
Global Const _
        $FILE_NOTIFY_CHANGE_ALL         = 0x17F, _
        $FILE_NOTIFY_CHANGE_FILE_NAME   = 0x001, _
        $FILE_NOTIFY_CHANGE_DIR_NAME    = 0x002, _
        $FILE_NOTIFY_CHANGE_ATTRIBUTES  = 0x004, _
        $FILE_NOTIFY_CHANGE_SIZE        = 0x008, _
        $FILE_NOTIFY_CHANGE_LAST_WRITE  = 0x010, _
        $FILE_NOTIFY_CHANGE_LAST_ACCESS = 0x020, _
        $FILE_NOTIFY_CHANGE_CREATION    = 0x040, _
        $FILE_NOTIFY_CHANGE_SECURITY    = 0x100
Global Const _
        $FILE_ACTION_ADDED            = 0x1, _
        $FILE_ACTION_REMOVED          = 0x2, _
        $FILE_ACTION_MODIFIED         = 0x3, _
        $FILE_ACTION_RENAMED_OLD_NAME = 0x4, _
        $FILE_ACTION_RENAMED_NEW_NAME = 0x5
Global Const _
        $MWMO_ALERTABLE      = 0x0002, _
        $MWMO_INPUTAVAILABLE = 0x0004, _
        $MWMO_WAITALL        = 0x0001
Global Const $FILE_LIST_DIRECTORY = 0x0001
Global Const $QS_ALLINPUT = 0x04FF
Global Const $INFINITE = 0xFFFF
Global Const $tagFNIIncomplete = "dword NextEntryOffset;dword Action;dword FileNameLength"
Global $bMonitorDone, $bSelected, $bMonitor
Global $title = "Incoming DOC Monitor", $item[1], $items = 0, $popup = 0, $start = 0
AutoItSetOption("GUIOnEventMode", 1)
GUISetIcon(@SystemDir & "\shell32.dll", -167)
TraySetIcon(@SystemDir & "\shell32.dll", -167)
$gFileMon = GUICreate($title & " ©  2010 by ZMV ", 525, 365, 250, 220)
GUISetOnEvent($GUI_EVENT_CLOSE, "_OnEvent_Close")
GUICtrlCreateGroup("**************** INCOMING DOCUMENT MESSAGE HISTORY *************", 90, 0, 350, 40)
GUICtrlSetState(-1, $GUI_DISABLE)
$lbDirectories = GUICtrlCreateList("C:\print\INCOMING\", 800, 0, 0, 0)   ;<---this way it starts out automatically monitoring the one I want
$btMonitor = GUICtrlCreateButton("Start Monitor", 230, 15, 75, 25, 0) ;<---this begins right away.
GUICtrlSetOnEvent(-1, "_OnEvent_Monitor")
GUICtrlSetState(-1, $GUI_DISABLE)
$btClear = GUICtrlCreateButton("Clear", 230, 15, 75, 25, 0) ;<--incase I want to clear it and come back to check out the numbers of the doc's I missed.
GUICtrlSetOnEvent(-1, "_OnEvent_Clear")
$lvNotifications = GUICtrlCreateListView("Action|Time|File", 12, 65, 500, 280)
GUICtrlSendMsg(-1, 0x101E, 0, Int(.1*610))
GUICtrlSendMsg(-1, 0x101E, 1, Int(.3*400))
GUICtrlSendMsg(-1, 0x101E, 2, Int(.3*650))
GUISetState(@SW_SHOW)
_Main()
Func _DisplayFileMessages($hBuffer, $sDir)
    Local $hFileNameInfo, $pBuffer, $hTime
    Local $nFileNameInfoOffset = 12, $nOffset = 0, $nNext = 1
    $pBuffer = DllStructGetPtr($hBuffer)
    While $nNext <> 0
        $hFileNameInfo = DllStructCreate($tagFNIIncomplete, $pBuffer + $nOffset)
        $hFileName = DllStructCreate("wchar FileName[" & DllStructGetData($hFileNameInfo, "FileNameLength")/2 & "]", $pBuffer + $nOffset + $nFileNameInfoOffset)
        $hTime = _Date_Time_GetSystemTime()
        Switch DllStructGetData($hFileNameInfo, "Action")
		Case $FILE_ACTION_ADDED
			run("rename.exe", "", @SW_HIDE)	
                _GUICtrlListView_InsertItem($lvNotifications, "Created", 0)
;FileCopy("C:\print\INCOMING\DOC.txt", "C:\print\CACHE\"& @MON & @MDAY & @YEAR & @HOUR & @MIN & @MSEC & ".txt", 0) ;<----a backup location incase I accidently delete a document
;FileMove("C:\print\INCOMING\DOC.txt", "C:\print\INCOMING\" & @MON & @MDAY & @YEAR & @HOUR & @MIN & @MSEC & ".txt", 0)
			Case $FILE_ACTION_REMOVED
run("rename.exe", "", @SW_HIDE)	 ; <- I have to run this thing everywhere!
    ;            _GUICtrlListView_InsertItem($lvNotifications, "Deleted", 0) ;<-don't really need to see this
			Case $FILE_ACTION_MODIFIED
;            _GUICtrlListView_InsertItem($lvNotifications, "Modified", 0) ;<-don't really need to see this
            Case $FILE_ACTION_RENAMED_OLD_NAME
;            _GUICtrlListView_InsertItem($lvNotifications, "Rename-", 0) ;<-don't really need to see this
			Case $FILE_ACTION_RENAMED_NEW_NAME
			_GUICtrlListView_InsertItem($lvNotifications, "Rename+", 0)
						run("popup.exe", "", @SW_SHOW)	
			SoundPlay(@WindowsDir & "\Media\notify.wav")
				beep(950, 300)	; <---- Incase my volume is muted it will still make noise from the tower of the PC
				SoundPlay(@WindowsDir & "\Media\chimes.wav")
            Case Else
                _GUICtrlListView_InsertItem($lvNotifications, "Unknown", 0)
run("rename.exe", "", @SW_HIDE)	
        EndSwitch
        _GUICtrlListView_AddSubItem($lvNotifications, 0, _Date_Time_SystemTimeToDateTimeStr($hTime), 1)
        _GUICtrlListView_AddSubItem($lvNotifications, 0, $sDir & DllStructGetData($hFileName, "FileName"), 2)
        $nNext = DllStructGetData($hFileNameInfo, "NextEntryOffset")
        $nOffset += $nNext
    WEnd
EndFunc

Func _GetBufferHandle ()
    Return DllStructCreate("ubyte[2048]")
EndFunc

Func _GetDirectoryChanges($aDirHandles, $hBuffer, $aOverlapped, $hEvents, $aDirs, $bAsync = Default, $nTimeout = Default)
    Local $aMsg, $i, $nBytes = 0
    If $nTimeout = -1 Or IsKeyword($nTimeout) Then $nTimeout = 250
    If Not $bAsync Then $nTimeout = $INFINITE
    $aMsg = DllCall("User32.dll", "dword", "MsgWaitForMultipleObjectsEx", _
        "dword", UBound($aOverlapped), _
        "ptr", DllStructGetPtr($hEvents), _
        "dword", $nTimeout, _
        "dword", 0, _
        "dword", 0x6)
    $i = $aMsg[0]
    Switch $i
        Case 0 To UBound($aDirHandles)-1
            If Not _WinAPI_GetOverlappedResult($aDirHandles[$i], DllStructGetPtr($aOverlapped[$i]), $nBytes, True) Then
                ConsoleWrite("!>  GetOverlappedResult Error(" & @error & "): " & _WinAPI_GetLastErrorMessage() & @LF)
                Return 0
            EndIf
            DllCall("Kernel32.dll", "Uint", "ResetEvent", "uint", DllStructGetData($aOverlapped[$i], "hEvent"))
            _DisplayFileMessages($hBuffer, $aDirs[$i])
            _SetReadDirectory($aDirHandles[$i], $hBuffer, $aOverlapped[$i],False,True)
            Return $nBytes
    EndSwitch
    Return 0
EndFunc

Func _GetDirHandle($sDir)
    Local $aResult
    $aResult = DllCall("Kernel32.dll", "hwnd", "CreateFile", _
        "str", $sDir, _
        "int", $FILE_LIST_DIRECTORY, _
        "int", BitOR($FILE_SHARE_DELETE,$FILE_SHARE_READ,$FILE_SHARE_WRITE), _
        "ptr", 0, _
        "int", $OPEN_EXISTING, _
        "int", BitOR($FILE_FLAG_BACKUP_SEMANTICS,$FILE_FLAG_OVERLAPPED), _
        "int", 0)
    If $aResult[0] = 0 Then
        ConsoleWrite("!>  CreateFile Error (" & @error & "): " & _WinAPI_GetLastErrorMessage() & @LF)
        Exit
    EndIf
    Return $aResult[0]
EndFunc

Func _GetEventHandles ($aOverlapped)
    Local $i, $hEvents
    $hEvents = DllStructCreate("hwnd hEvent[" & UBound($aOverlapped) & "]")
    For $i=1 To UBound($aOverlapped)
        DllStructSetData($hEvents, "hEvent", DllStructGetData($aOverlapped[$i-1], "hEvent"), $i)
    Next
    Return $hEvents
EndFunc

Func _GetOverlappedHandle ()
    Local $hOverlapped = DllStructCreate($tagOVERLAPPED)
    For $i=1 To 5
        DllStructSetData($hOverlapped, $i, 0)
    Next
    Return $hOverlapped
EndFunc

Func _Main ()
    $bSelected = True
    $bMonitorDone = False
    $bMonitor = True

    While 1		
run("rename.exe", "", @SW_HIDE)	
        If Not $bMonitorDone Then _MonitorDirs()
        If $bMonitor And _GUICtrlListBox_GetCount($lbDirectories) = 0 Then
			run("rename.exe", "", @SW_HIDE)	
            $bMonitor = Not $bMonitor
            GUICtrlSetState($btMonitor, $GUI_ENABLE)

		ElseIf Not $bMonitor And _GUICtrlListBox_GetCount($lbDirectories) > 0 Then
            $bMonitor = Not $bMonitor
			run("rename.exe", "", @SW_HIDE)	
            GUICtrlSetState($btMonitor, $GUI_ENABLE)
        EndIf
            $bSelected = Not $bSelected
			run("rename.exe", "", @SW_HIDE)	
  WEnd    
 EndFunc

Func _MonitorDirs ()
    Local $i, $nMax, $hBuffer, $hEvents
    $nMax = _GUICtrlListBox_GetCount($lbDirectories)
    Local $aDirHandles[$nMax], $aOverlapped[$nMax], $aDirs[$nMax]
    $hBuffer = _GetBufferHandle()
    For $i = 0 To $nMax-1
        $aDirs[$i] = _GUICtrlListBox_GetText($lbDirectories, $i)
        $aDirHandles[$i] = _GetDirHandle($aDirs[$i])
        $aOverlapped[$i] = _GetOverlappedHandle()
        _SetReadDirectory($aDirHandles[$i], $hBuffer, $aOverlapped[$i], True, True)
    Next
    $hEvents = _GetEventHandles($aOverlapped)
    While Not $bMonitorDone
        _GetDirectoryChanges($aDirHandles, $hBuffer, $aOverlapped, $hEvents, $aDirs)
    WEnd
EndFunc
Func _OnEvent_Clear ()
    _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($lvNotifications))
EndFunc
Func _OnEvent_Close ()
    Exit
EndFunc
Func _OnEvent_Monitor ()
    If $bMonitorDone Then
        $bMonitorDone = False
        GUICtrlSetData($btMonitor, "Stop Monitor")
        GUICtrlSetState($lbDirectories, $GUI_DISABLE)
        $bSelected = False
    Else
        $bMonitorDone = True
        GUICtrlSetState($lbDirectories, $GUI_ENABLE)
        GUICtrlSetData($btMonitor, "Start Monitor")
    EndIf
EndFunc
Func _SetReadDirectory($hDir, $hBuffer, $hOverlapped, $bInitial = False, $bSubtree = False)
    Local $hEvent, $pBuffer, $nBufferLength, $pOverlapped
    $pBuffer = DllStructGetPtr($hBuffer)
    $nBufferLength = DllStructGetSize($hBuffer)
    $pOverlapped = DllStructGetPtr($hOverlapped)
    If $bInitial Then
        $hEvent = DllCall("Kernel32.dll", "hwnd", "CreateEvent", _
            "uint", 0, _
            "int", True, _
            "int", False, _
            "uint", 0)
        If $hEvent[0] = 0 Then
            ConsoleWrite("!>  CreateEvent Failed (" & _WinAPI_GetLastError() & "): " & _WinAPI_GetLastErrorMessage() & @LF)
            Exit
        EndIf
        DllStructSetData($hOverlapped, "hEvent", $hEvent[0])
    EndIf
    $aResult = DllCall("Kernel32.dll", "int", "ReadDirectoryChangesW", _
        "hwnd", $hDir, _
        "ptr", $pBuffer, _
        "dword", $nBufferLength, _
        "int", $bSubtree, _
        "dword", BitOR($FILE_NOTIFY_CHANGE_FILE_NAME, _
            $FILE_NOTIFY_CHANGE_SIZE,$FILE_NOTIFY_CHANGE_DIR_NAME), _
        "uint", 0, _
        "uint", $pOverlapped, _
        "uint", 0)
    If $aResult[0] = 0 Then
        ConsoleWrite("!>  ReadDirectoryChangesW Error(" & @error & "): " & _WinAPI_GetLastErrorMessage() & @LF)
        Exit
    EndIf
    Return $aResult[0]
EndFunc
Func _Exit()
	SoundPlay(@WindowsDir & "\Media\notify.wav")
    If MsgBox(270372, $title, "Do you want to quit ?        ", 0, $GUI) = 6 Then Exit
EndFunc   ;==>_Exit

