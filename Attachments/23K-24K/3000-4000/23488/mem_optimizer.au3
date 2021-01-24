#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=memory.ico
#AutoIt3Wrapper_outfile=memopt.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Another fine release by L|M|TER : a simple yet powerful memory optimizer.
#AutoIt3Wrapper_Res_Description=L|M|TER Memory Optimizer
#AutoIt3Wrapper_Res_Fileversion=0.5.0.0
#AutoIt3Wrapper_Res_LegalCopyright=© 2008 L|M|TER Inc.
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <GuiListView.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
$cver = "0.5"
Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)
TraySetToolTip("L|M|TER Memory Optimizer v." & $cver)

$gui = GUICreate("L|M|TER Memory Optimizer", 262, 173, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "_Minimize")
$list = GUICtrlCreateListView("Process|PID|Memory", 5, 25, 251, 110)
GUICtrlSetOnEvent(-1, "pevent")
GUICtrlSendMsg(-1, 0x101E, 0, 126)
GUICtrlSendMsg(-1, 0x101E, 1, 38)
GUICtrlSendMsg(-1, 0x101E, 2, 39)
$txt = GUICtrlCreateLabel("L|M|TER's Memory Optimizer v." & $cver & " © 2008", 5, 5, 204, 17)
$optpbtn = GUICtrlCreateButton("Optimize Process !", 5, 140, 100, 25, 0)
GUICtrlSetFont(-1, 6, 400, 0, "MS Sans Serif")
GUICtrlSetOnEvent(-1, "optproc")
$optbtn = GUICtrlCreateButton("Total Optimize !", 107, 140, 80, 25, 0)
GUICtrlSetOnEvent(-1, "optall")
$settingsbtn = GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -166, 190, 138, 32, 32, BitOR($SS_NOTIFY, $WS_GROUP))
GUICtrlSetOnEvent(-1, "settings")
$aboutbtn = GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -155, 223, 138, 32, 32, BitOR($SS_NOTIFY, $WS_GROUP))
GUICtrlSetOnEvent(-1, "about")
If @OSVersion = "WIN_VISTA" Then
$refreshbtn = GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -239, 240, 5, 16, 16, BitOR($SS_NOTIFY, $WS_GROUP))
ElseIf @OSVersion = "WIN_XP" Then
$refreshbtn = GUICtrlCreateIcon(@SystemDir & "\shell32.dll", -147, 240, 5, 16, 16, BitOR($SS_NOTIFY, $WS_GROUP))
EndIf
GUICtrlSetOnEvent($refreshbtn, "_Refresh")
_GUICtrlListView_RegisterSortCallBack($list)
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "_Restore")

Dim $pid[2] = [0,0]
Dim $memory[1][7]
Dim $procl[1][1]
$procl = ProcessList()
ProgressOn("L|M|TER Memory Optimizer","Loading ...")
For $i = 1 To $procl[0][0]
	$percent = Round(($i / $procl[0][0]) * 100)
	ProgressSet($percent,$percent & " %","Checking " & $procl[$i][0] & "...")
	If $procl[$i][1] = 0 Or $procl[$i][0] = "System" Then ContinueLoop
	If ProcessExists($procl[$i][1]) Then
	$memory = _ProcessListProperties($procl[$i][1])
;~ 	ConsoleWrite("$i = " & $i & "   Name : " & $procl[$i][0] & "   PID : " & $procl[$i][1] & @CRLF)
	If UBound($memory, 2) = "10" Then
	GUICtrlCreateListViewItem($procl[$i][0] & "|" & $procl[$i][1] & "|" & Round($memory[1][7] / 1048576,2) & " MB", $list)
	EndIf
	_Optimize()
	EndIf
Next
ProgressOff()
GUISetState(@SW_SHOW)

GUICtrlSendMsg(-1, 0x101E, 0, 133)
GUICtrlSendMsg(-1, 0x101E, 1, 38)
GUICtrlSendMsg(-1, 0x101E, 2, 39)
	
While 1
	Sleep(100)
WEnd

Func optproc()
	$pid1 = GUICtrlRead(GUICtrlRead($list))
	$pid = StringSplit($pid1, "|")
	If IsArray($pid) And UBound($pid) = "5" Then
	$mem1 = _ProcessListProperties($pid[2])
	_Optimize($pid[2])
	$mem = _ProcessListProperties($pid[2])
	TrayTip("Process : " & $pid[1],"Before : " & Round($mem1[1][7] / 1048576,2) & " MB" & @CRLF & _
	"After : " & Round($mem[1][7] / 1048576,2) & " MB" & @CRLF & _
	"Optimized by " & Round(($mem1[1][7] - $mem[1][7]) / 1048576,2) & " MB",1000)
	EndIf
EndFunc   ;==>optproc

Func optall()
	$procl = ProcessList()
	ProgressOn("L|M|TER Memory Optimizer","Optimizing ...")
	For $i = 1 To $procl[0][0]
		$percent = Round(($i / $procl[0][0]) * 100)
		ProgressSet($percent,$percent & " %","Optimizing " & $procl[$i][0] & "...")
		If $procl[$i][1] = 0 Then ContinueLoop
		_Optimize($procl[$i][1])
	Next
	ProgressOff()
EndFunc   ;==>optall

Func settings()
	$time = InputBox("L|M|TER Memory Optimizer", "Enter the value in MS at which optimizing is done." & @CRLF & "[Default = 60000 (1 minute) - 0 = Disabled]", "60000", Default, 275, 140)
	If $time > 0 Then
		AdlibEnable("optall", $time)
	Else
		AdlibDisable()
	EndIf
EndFunc   ;==>settings

Func about()
	MsgBox(32, "L|M|TER Memory Optimizer", "To optimize a process, select it from the list" & @CRLF & _
			"and then click 'Optimize Process !'." & @CRLF & _
			@CRLF & _
			"To optimize all the processes, click 'Optimize All !'." & @CRLF & _
			@CRLF & _
			"To use the timer function, press the settings icon" & @CRLF & _
			"and insert the time in ms (miliseconds, 1 sec = 1000 ms)." & @CRLF & _
			"Insert 0 to disable the timer function." & @CRLF & _
			@CRLF & _
			"To refresh the list, click the refresh icon from the" & @CRLF & _
			"upper right corner of the GUI." & @CRLF & _
			"_______________________________________________________" & _
			@CRLF & _
			"                 L|M|TER Memory Optimizer v." & $cver & @CRLF & _
			"                                © 2008 L|M|TER")
EndFunc   ;==>about

Func _Optimize($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf

	Return $ai_Return[0]
EndFunc   ;==>_Optimize

Func pevent()
	_GUICtrlListView_SortItems($list, GUICtrlGetState($list))
EndFunc   ;==>pevent

Func _ProcessListProperties($Process = "", $sComputer = ".")
    Local $sUserName, $sMsg, $sUserDomain, $avProcs, $dtmDate
    Local $avProcs[1][2] = [[0, ""]], $n = 1
    
; Convert PID if passed as string
    If StringIsInt($Process) Then $Process = Int($Process)
    
; Connect to WMI and get process objects
    $oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate,authenticationLevel=pktPrivacy, (Debug)}!\\" & $sComputer & "\root\cimv2")
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
                If $oProc.GetOwner($sUserName, $sUserDomain) = 0 Then $avProcs[$n][3] = $sUserDomain & "\" & $sUserName
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

Func _Minimize()
GUISetState(@SW_HIDE)
EndFunc

Func _Restore()
GUISetState(@SW_SHOW)
EndFunc

Func _Exit()
	AdlibDisable()
	Exit
EndFunc   ;==>_Exit

Func _Refresh()
   $procl = ProcessList()
   ProgressOn("L|M|TER Memory Optimizer","Loading ...")

  GUICtrlDelete($list)
  $list = GUICtrlCreateListView("Process|PID|Memory", 5, 25, 251, 110)
GUICtrlSetOnEvent(-1, "pevent")
GUICtrlSendMsg(-1, 0x101E, 0, 126)
GUICtrlSendMsg(-1, 0x101E, 1, 38)
GUICtrlSendMsg(-1, 0x101E, 2, 39)

   For $i = 1 To $procl[0][0]
       $percent = Round(($i / $procl[0][0]) * 100)
       ProgressSet($percent,$percent & " %","Checking " & $procl[$i][0] & "...")
       If $procl[$i][1] = 0 Or $procl[$i][0] = "System" Then ContinueLoop
       If ProcessExists($procl[$i][1]) Then
       $memory = _ProcessListProperties($procl[$i][1])
       If UBound($memory, 2) = "10" Then
       GUICtrlCreateListViewItem($procl[$i][0] & "|" & $procl[$i][1] & "|" & Round($memory[1][7] / 1048576,2) & " MB", $list)
       EndIf
       _Optimize()
       EndIf
Next
ProgressOff()
EndFunc