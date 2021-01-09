#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <File.au3>
;thnx to PsaltyDS' udf..
Opt('GUIOnEventMode', 1)
$Title = "SBA Task Manager"
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate($Title, 633, 447, 193, 125)
$ListView1 = GUICtrlCreateListView("Name|Priority|Path|CPU|MEM|Date|Size", 0, 0, 494, 446)
GUICtrlSendMsg(-1, 0x101E, 0, 70)
GUICtrlSendMsg(-1, 0x101E, 1, 70)
GUICtrlSendMsg(-1, 0x101E, 2, 70)
GUICtrlSendMsg(-1, 0x101E, 3, 70)
GUICtrlSendMsg(-1, 0x101E, 4, 70)
GUICtrlSendMsg(-1, 0x101E, 5, 70)
GUICtrlSendMsg(-1, 0x101E, 6, 70)
GUICtrlSendMsg(-1, 0x101E, 7, 70)
_SetList($ListView1)
$menu = GUICtrlCreateContextMenu($ListView1)
$DelTask = GUICtrlCreateMenuItem('End Task', $menu)
$Copy = GUICtrlCreateMenuItem('Copy', $menu)
GUICtrlSetOnEvent($DelTask, '_EndTask')
GUICtrlSetOnEvent($Copy, '_CopyItem')
$Button1 = GUICtrlCreateButton("End Task", 528, 416, 75, 25, 0)
GUICtrlSetOnEvent(-1, '_EndTask')
$Button2 = GUICtrlCreateButton("Export List", 528, 389, 75, 25, 0)
GUICtrlSetOnEvent(-1, '_ExportList')
GUISetOnEvent($GUI_EVENT_CLOSE, '_exit')
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
	_UpdateList($ListView1)
	$nMsg = GUIGetMsg()
WEnd

Func _exit()
	exit
EndFunc

Func _GetListItems($sList)
	$list = GUICtrlGetHandle($sList)
	global $sReturn=''
	For $i=0 to _GUICtrlListView_GetItemCount($list)
		$tlk = _GUICtrlListView_GetItemTextArray($list, $i)
		if $sReturn='' then
			$sReturn = $tlk[1]&' - '&$tlk[2]&' - '&$tlk[3]&' - '&$tlk[4]&' - '&$tlk[5]&' - '&$tlk[6]&' - '&$tlk[7]
		Else
			$sReturn &= @CRLF&$tlk[1]&' - '&$tlk[2]&' - '&$tlk[3]&' - '&$tlk[4]&' - '&$tlk[5]&' - '&$tlk[6]&' - '&$tlk[7]
		EndIf
	Next
	return $sReturn
EndFunc

Func _ExportList()
	$AllItems = _GetListItems($ListView1)
	$file = FileSaveDialog('Save the tasks..', '', 'Text Files (*.txt)|All Files (*.*)')
	if $file = '' then Return -1
	_FileCreate($file)
	if _FileWriteToLine($file, 1, $AllItems, 1) = 1 then 
		msgbox(32, $Title, 'Succesfully created task file..'&@CRLF&'Path: '&$file)
	Else
		msgbox(16, $Title, 'Error creating task file..'&@CRLF&'Path: '&$file)
	EndIf
EndFunc

Func _EndTask()
	$1 = StringSplit(GUICtrlRead(GUICtrlRead($ListView1)), '|', 1)
	ProcessClose($1[1])
EndFunc

Func _CopyItem()
	ClipPut(GUICtrlRead(GUICtrlRead($ListView1)))
EndFunc


Func _SetList($sList)
	$process = _ProcessListProperties()
	for $i = 1 to $process[0][0]
		GUICtrlCreateListViewItem($process[$i][0]&'|'&_GetPriority($process[$i][4])&'|'&$process[$i][5]&'|'&$process[$i][6]&'|'&$process[$i][7]&'|'&$process[$i][8]&'|'&FileGetSize($process[$i][5]), $sList)
	Next
EndFunc

Func _UpdateList($sList)
	$process = _ProcessListProperties()
	for $i = 1 to $process[0][0]
		GUICtrLSetData($i+3, $process[$i][0]&'|'&_GetPriority($process[$i][4])&'|'&$process[$i][5]&'|'&$process[$i][6]&'|'&$process[$i][7]&'|'&$process[$i][8]&'|'&FileGetSize($process[$i][5]))
	Next
EndFunc

Func _GetPriority($process)
	return $process
EndFunc

;===============================================================================
; Function Name:    _ProcessListProperties()
; Description:   Get various properties of a process, or all processes
; Call With:       _ProcessListProperties( [$Process [, $sComputer]] )
; Parameter(s):     (optional) $Process - PID or name of a process, default is "" (all)
;           (optional) $sComputer - remote computer to get list from, default is local
; Requirement(s):   AutoIt v3.2.4.9+
; Return Value(s):  On Success - Returns a 2D array of processes, as in ProcessList()
;             with additional columns added:
;             [0][0] - Number of processes listed (can be 0 if no matches found)
;             [1][0] - 1st process name
;             [1][1] - 1st process PID
;             [1][2] - 1st process Parent PID
;             [1][3] - 1st process owner
;             [1][4] - 1st process priority (0 = low, 31 = high)
;             [1][5] - 1st process executable path
;             [1][6] - 1st process CPU usage
;             [1][7] - 1st process memory usage
;             [1][8] - 1st process creation date/time = "MM/DD/YYY hh:mm:ss" (hh = 00 to 23)
;             [1][9] - 1st process command line string
;             ...
;             [n][0] thru [n][9] - last process properties
; On Failure:       Returns array with [0][0] = 0 and sets @Error to non-zero (see code below)
; Author(s):        PsaltyDS at http://www.autoitscript.com/forum
; Date/Version:   07/02/2008  --  v2.0.2
; Notes:            If an integer PID or string process name is provided and no match is found,
;             then [0][0] = 0 and @error = 0 (not treated as an error, same as ProcessList)
;           This function requires admin permissions to the target computer.
;           All properties come from the Win32_Process class in WMI.
;             To get time-base properties (CPU and Memory usage), a 100ms SWbemRefresher is used.
;===============================================================================
Func _ProcessListProperties($Process = "", $sComputer = ".")
    Local $sUserName, $sMsg, $sUserDomain, $avProcs, $dtmDate
    Local $avProcs[1][2] = [[0, ""]], $n = 1
    
; Convert PID if passed as string
    If StringIsInt($Process) Then $Process = Int($Process)
    
; Connect to WMI and get process objects
    $oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate,authenticationLevel=pktPrivacy}!\\" & $sComputer & "\root\cimv2")
    If IsObj($oWMI) Then
; Get collection processes from Win32_Process
        If $Process = "" Then
; Get all
            $colProcs = $oWMI.ExecQuery("select * from win32_process")
        ElseIf IsInt($Process) Then
; Get by PID
            $colProcs = $oWMI.ExecQuery("select * from win32_process where ProcessId = " & $Process)
        Else
; Get by Name
            $colProcs = $oWMI.ExecQuery("select * from win32_process where Name = '" & $Process & "'")
        EndIf
        
        If IsObj($colProcs) Then
; Return for no matches
            If $colProcs.count = 0 Then Return $avProcs

; Size the array
            ReDim $avProcs[$colProcs.count + 1][10]
            $avProcs[0][0] = UBound($avProcs) - 1

; For each process...
            For $oProc In $colProcs
    ; [n][0] = Process name
                $avProcs[$n][0] = $oProc.name
    ; [n][1] = Process PID
                $avProcs[$n][1] = $oProc.ProcessId
    ; [n][2] = Parent PID
                $avProcs[$n][2] = $oProc.ParentProcessId
    ; [n][3] = Owner
                ;If $oProc.GetOwner($sUserName, $sUserDomain) = 0 Then $avProcs[$n][3] = $sUserDomain & "\" & $sUserName
    ; [n][4] = Priority
                $avProcs[$n][4] = $oProc.Priority
    ; [n][5] = Executable path
                $avProcs[$n][5] = $oProc.ExecutablePath
    ; [n][8] = Creation date/time
                $dtmDate = $oProc.CreationDate
                If $dtmDate <> "" Then
        ; Back referencing RegExp pattern from weaponx
                    Local $sRegExpPatt = "\A(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(?:.*)"
                    $dtmDate = StringRegExpReplace($dtmDate, $sRegExpPatt, "$2/$3/$1 $4:$5:$6")
                EndIf
                $avProcs[$n][8] = $dtmDate
    ; [n][9] = Command line string
                $avProcs[$n][9] = $oProc.CommandLine

    ; increment index
                $n += 1
            Next
        Else
            SetError(2); Error getting process collection from WMI
        EndIf
; release the collection object
        $colProcs = 0

; Get collection of all processes from Win32_PerfFormattedData_PerfProc_Process
; Have to use an SWbemRefresher to pull the collection, or all Perf data will be zeros
        Local $oRefresher = ObjCreate("WbemScripting.SWbemRefresher")
        $colProcs = $oRefresher.AddEnum($oWMI, "Win32_PerfFormattedData_PerfProc_Process" ).objectSet
        $oRefresher.Refresh

; Time delay before calling refresher
        Local $iTime = TimerInit()
        Do
            Sleep(20)
        Until TimerDiff($iTime) >= 100
        $oRefresher.Refresh

; Get PerfProc data
        For $oProc In $colProcs
; Find it in the array
            For $n = 1 To $avProcs[0][0]
                If $avProcs[$n][1] = $oProc.IDProcess Then
        ; [n][6] = CPU usage
                    $avProcs[$n][6] = $oProc.PercentProcessorTime
        ; [n][7] = memory usage
                    $avProcs[$n][7] = $oProc.WorkingSet
                    ExitLoop
                EndIf
            Next
        Next
    Else
        SetError(1); Error connecting to WMI
    EndIf
    
; Return array
    Return $avProcs
EndFunc;==>_ProcessListProperties