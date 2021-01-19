#include <GUIConstants.au3>
#include <GUIListView.au3>
#include <Process.au3>
#include <A3LListView.au3>
#NoTrayIcon

$name = "Process Manager"

$parent = GUICreate($name,500,610,-1,-1,-1, $WS_EX_ACCEPTFILES)
Opt("RunErrorsFatal", 0)
$contextmenu = GUICtrlCreateContextMenu ()
$fileopt = GUICtrlCreateMenu ("&File")
$ontopitem = GUICtrlCreateMenuitem ("Always On Top",$fileopt)
$top = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\PM", "AlwaysOnTop")
if $top = 0 then
GUICtrlSetState(-1,$GUI_UNCHECKED)
WinSetOnTop($name, "", 0)
elseif $top = 1 then
GUICtrlSetState(-1,$GUI_CHECKED)
WinSetOnTop($name, "", 1)
endif
$exititem = GUICtrlCreateMenuitem("Exit",$fileopt)
$helpopt = GUICtrlCreateMenu("About")
$aboutitem = GUICtrlCreateMenuitem("About",$helpopt)

$tab=GUICtrlCreateTab(5,5,490,575)

$tab0=GUICtrlCreateTabitem("Processes")
GUICtrlSetState(-1,$GUI_SHOW)
GUICtrlCreateLabel ("Processes", 30,80,50,20)
$listview = GUICtrlCreateListView("Process            |PID     |Priority|Process Owner      |Parent PID",20,30,465,460,$LVS_REPORT)
$processes = _ProcessListProperties()
For $i = 1 To $processes[0][0]
$priority = _ProcessGetPriority($processes[$i][1])
GUICtrlCreateListViewItem($processes[$i][0] & "|" & $processes[$i][1] & "|" & $priority & "|" & $processes[$i][3] & "|" & $processes[$i][2],$listview)
Next
$new = GUICtrlCreateButton("New Task",40,510,75,25)
$kill = GUICtrlCreateButton("Kill Process",120,510,75,25)
$refresh = GUICtrlCreateButton("Refresh",40,540,75,25)
$close = GUICtrlCreateButton("Close",120,540,75,25)
$getpath = GUICtrlCreateButton("Get Path",200,510,75,25)
$google = GUICtrlCreateButton("Google",200,540,75,25)

$tab1=GUICtrlCreateTabitem("Applications")
GUICtrlCreateLabel("Applications", 30,80,50,20)
$listview1 = GUICtrlCreateListView("Window Title                        |Window Handle|Associated Process|PID     ",20,30,465,460,$LVS_REPORT)
$windows = WinList()
For $i = 1 To $windows[0][0]
$winpid = WinGetProcess($windows[$i][0],"")
$winprocess = _WinGetProcessName($windows[$i][0],'')
if $windows[$i][0] <> "" AND IsVisible($windows[$i][1]) then
GUICtrlCreateListViewItem($windows[$i][0] & "|" & $windows[$i][1] & "|" & $winprocess & "|" & $winpid,$listview1)
endif
Next
$new1 = GUICtrlCreateButton ("New Task", 40, 510, 75,25)
$kill1 = GUICtrlCreateButton ("Kill Process", 120, 510, 75,25)
$refresh1 = GUICtrlCreateButton ("Refresh", 40, 540, 75,25)
$close1 = GUICtrlCreateButton ("Close", 120, 540, 75,25)

GUICtrlCreateTabitem ("")

GUISetState()
Do
$msg = GUIGetMsg()

Select
Case $msg = $new or $msg = $new1
$open = FileOpenDialog("New Task", @homedrive, "All (*.*)", 1,"")
ShellExecute($open)
RefreshProcess()
RefreshWindow()
Case $msg = $kill
$split = StringSplit(GUICtrlRead(GUICtrlRead($listview)),"|")
ProcessClose($split[2])
GuiCtrlDelete(GUICtrlRead($listview))
RefreshWindow()
Case $msg = $kill1
$split = StringSplit(GUICtrlRead(GUICtrlRead($listview1)),"|")
ProcessClose($split[3])
GuiCtrlDelete(GUICtrlRead($listview1))
RefreshProcess()
Case $msg = $refresh
RefreshProcess()
Case $msg = $refresh1
RefreshWindow()
Case $msg = $getpath
$selected = _GUICtrlListViewGetSelectedIndices($listview,0)
$listviewhandle = GuiCtrlGetHandle($listview)
$pid = _ListView_GetItemText($listviewhandle,$selected,0)
$pidpath = _ProcessListProperties($pid)
MsgBox(0,"Process Path",$pidpath[1][5])
Case $msg = $google
$item = _GUICtrlListViewGetItemText($listview, _GUICtrlListViewGetSelectedIndices($listview), 0)
_OpenWeb("                                  " & $item)
EndSelect

if $msg = $ontopitem then
if BitAnd(GUICtrlRead($ontopitem),$GUI_CHECKED) = $GUI_CHECKED Then
GUICtrlSetState($ontopitem,$GUI_UNCHECKED)
RegWrite("HKEY_CURRENT_USER\SOFTWARE\PM","AlwaysOnTop","REG_SZ", "0")
WinSetOnTop("", "", 0)
else
GUICtrlSetState($ontopitem,$GUI_CHECKED)
RegWrite("HKEY_CURRENT_USER\SOFTWARE\PM","AlwaysOnTop","REG_SZ", "1")
WinSetOnTop("", "", 1)
endif
endif

if $msg = $aboutitem then
$child1 = GUICreate("About",220, 220,-1,-1,-1,$WS_EX_ACCEPTFILES,$parent)
$font = "Ariel"
Opt("RunErrorsFatal", 0)
GUICtrlCreateLabel ($name, 50, 30, 150,30)
GUICtrlSetFont (-1,10, 400, $font)
GUICtrlCreateIcon("icons\process.ico",-1,85,60,48,48)
GUICtrlCreateLabel ("Written by MaQleod",  55, 120, 150,30)
GUICtrlSetFont (-1,10, 400, $font)
$aboutok = GUICtrlCreateButton ("OK", 75, 170, 75,25)
GUISetState()
Do
$msg1 = GUIGetMsg()
if $msg1 = $aboutok then
ExitLoop
endif
Until $msg1 = $GUI_EVENT_CLOSE
GUIDelete($child1)
endif

if $msg = $close or $msg = $exititem or $msg = $close1 then
ExitLoop
endif

Until $msg = $GUI_EVENT_CLOSE
GUIDelete()

Func RefreshProcess()
_GUICtrlListViewDeleteAllItems($listview)
$processes = _ProcessListProperties()
For $i = 1 To $processes[0][0]
$priority = _ProcessGetPriority($processes[$i][1])
GUICtrlCreateListViewItem($processes[$i][0] & "|" & $processes[$i][1] & "|" & $priority & "|" & $processes[$i][3] & "|" & $processes[$i][2],$listview)
Next
EndFunc

Func RefreshWindow()
_GUICtrlListViewDeleteAllItems($listview1)
$windows = WinList()
For $i = 1 To $windows[0][0]
$winpid = WinGetProcess($windows[$i][0],"")
$winprocess = _WinGetProcessName($windows[$i][0],'')
if $windows[$i][0] <> "" AND IsVisible($windows[$i][1]) then
GUICtrlCreateListViewItem($windows[$i][0] & "|" & $windows[$i][1] & "|" & $winprocess & "|" & $winpid,$listview1)
endif
Next
EndFunc

Func IsVisible($handle) ;borrowed function
If BitAnd( WinGetState($handle), 2 ) Then
Return 1
Else
Return 0
EndIf
EndFunc

Func _ProcessListProperties($Process = "", $sComputer = ".") ;borrowed function
Local $sUserName, $sMsg, $sUserDomain, $avProcs
If $Process = "" Then
$avProcs = ProcessList()
Else
$avProcs = ProcessList($Process)
EndIf
If $avProcs[0][0] = 0 Then Return $avProcs
ReDim $avProcs[$avProcs[0][0] + 1][7]
$oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $sComputer & "\root\cimv2")
If IsObj($oWMI) Then
$colProcs = $oWMI.ExecQuery ("select * from win32_process")
If IsObj($colProcs) Then
For $oProc In $colProcs
For $n = 1 To $avProcs[0][0]
If $avProcs[$n][1] = $oProc.ProcessId Then
$avProcs[$n][2] = $oProc.ParentProcessId
If $oProc.GetOwner ($sUserName, $sUserDomain) = 0 Then $avProcs[$n][3] = $sUserDomain & "\" & $sUserName
$avProcs[$n][4] = $oProc.Priority
$avProcs[$n][5] = $oProc.ExecutablePath
ExitLoop
EndIf
Next
Next
Else
SetError(2)
EndIf
$oRefresher = ObjCreate("WbemScripting.SWbemRefresher")
$colProcs = $oRefresher.AddEnum ($oWMI, "Win32_PerfFormattedData_PerfProc_Process").objectSet
$oRefresher.Refresh
Sleep(1000)
$oRefresher.Refresh
For $oProc In $colProcs
For $n = 1 To $avProcs[0][0]
If $avProcs[$n][1] = $oProc.IDProcess Then
$avProcs[$n][6] = $oProc.PercentProcessorTime
ExitLoop
EndIf
Next
Next
Else
SetError(1)
EndIf
Return $avProcs
EndFunc

Func _WinGetProcessName($s_Title, $s_Text = '') ;borrowed function
Local $i_PID, $a_ProcList
$i_PID = WinGetProcess($s_Title, $s_Text)
If $i_PID <> -1 Then
$a_ProcList = ProcessList()
For $i_For = 1 to $a_ProcList[0][0]
If $a_ProcList[$i_For][1] = $i_PID Then
SetExtended($i_PID)
Return $a_ProcList[$i_For][0]
EndIf
Next
EndIf
SetError(1)
Return False
EndFunc

Func _OpenWeb($URL)
	$oWeb = ObjCreate ("Shell.Application")
	$oWeb.Open ($URL)
EndFunc   ;==>_OpenWeb