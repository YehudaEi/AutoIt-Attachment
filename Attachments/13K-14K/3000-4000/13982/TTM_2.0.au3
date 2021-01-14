#include <GUIConstants.au3>
#include <GUIListView.au3>
#include "CPU.au3"

Dim $ShowHidden = 0

Opt("WinTitleMatchMode", 3)
Opt("TrayMenuMode", 1)

$GUI = GUICreate("Total Task Manager 2.0", 450, 400)
WinSetOnTop("Total Task Manager 2.0", "", 1) ; Give TTM 'On Top' attribute
GUISetIcon("ttm.ico")
TraySetIcon("ttm.ico")
TraySetToolTip("Total Task Manager 2.0")

$FileMenu = GUICtrlCreateMenu("File")
	$MenuOverride = GUICtrlCreateMenuitem("Override Task Manager", $FileMenu)
	GUICtrlCreateMenuitem("", $FileMenu)
	$MenuExit = GUICtrlCreateMenuitem("Exit", $FileMenu)
$tab = GUICtrlCreateTab(5, 0, 440, 355)
$WindowTab = GUICtrlCreateTabItem("Windows")
	$WindowListView = GUICtrlCreateListView("Window name                     |Handle    |X    |Y    |Width|Height", 15, 40, 420, 280, BitOr($LVS_ICON, $LVS_SINGLESEL))
	Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($WindowListView) ]
	_GUICtrlListViewSort($WindowListView, $B_DESCENDING, GUICtrlGetState($WindowListView))
	$WindowContext = GUICtrlCreateContextMenu($WindowListView)
		$WindowClose = GUICtrlCreateMenuitem("Close", $WindowContext)
		$WindowFlash = GUICtrlCreateMenuitem("Flash", $WindowContext)
		$WindowSetState = GUICtrlCreateMenu("Set window state", $WindowContext)
			$LockWindow = GUICtrlCreateMenuitem("Lock", $WindowSetState)
			$UnlockWindow = GUICtrlCreateMenuitem("Unlock", $WindowSetState)
			GUICtrlCreateMenuitem("", $WindowSetState)
			$ShowWindow = GUICtrlCreateMenuitem("Show", $WindowSetState)
			$HideWindow = GUICtrlCreateMenuitem("Hide", $WindowSetState)
			GUICtrlCreateMenuitem("", $WindowSetState)
			$MinimizeWindow = GUICtrlCreateMenuitem("Minimize", $WindowSetState)
			$MaximizeWindow = GUICtrlCreateMenuitem("Maximize", $WindowSetState)
			$RestoreWindow = GUICtrlCreateMenuitem("Restore", $WindowSetState)
		$WindowCopy = GUICtrlCreateMenu("Copy", $WindowContext)
			$WindowCopyName = GUICtrlCreateMenuitem("Window Name", $WindowCopy)
			$WindowCopyHandle = GUICtrlCreateMenuitem("Window Handle", $WindowCopy)
			$WindowCopySize = GUICtrlCreateMenu("Window Size", $WindowCopy)
				$WindowCopyWidth = GUICtrlCreateMenuitem("Width", $WindowCopySize)
				$WindowCopyHeight = GUICtrlCreateMenuitem("Height", $WindowCopySize)
			$WindowCopyPos = GUICtrlCreateMenu("Window Position", $WindowCopy)
				$WindowCopyXPos = GUICtrlCreateMenuitem("X", $WindowCopyPos)
				$WindowCopyYPos = GUICtrlCreateMenuitem("Y", $WindowCopyPos)
			$WindowCopyLocation = GUICtrlCreateMenuitem("Location", $WindowCopy)
		GUICtrlCreateMenuitem("", $WindowContext)
		$WindowMutate = GUICtrlCreateMenuitem("Mutate", $WindowContext)
		$WindowLocate = GUICtrlCreateMenuitem("Locate", $WindowContext)
		$ShowHiddenWindowsCheckbox = GUICtrlCreateCheckbox("Show hidden windows", 15, 325, 130, 23)
		$CloseWindowButton = GUICtrlCreateButton("Close window", 160, 325, 80, 23)
		$SwitchToButton = GUICtrlCreateButton("Switch to", 245, 325, 80, 23)
		$NewWindowButton = GUICtrlCreateButton("New task (Run)", 330, 325, 85, 23)
		_WinList()
$ProcessTab = GUICtrlCreateTabItem("Processes")
	$ProcessListView = GUICtrlCreateListView("Process name       |PID", 15, 40, 420, 280)
	_ProcessList()
$PerfTab = GUICtrlCreateTabItem("Performance")
	GUICtrlCreateGroup("CPU Usage", 15, 40, 75, 120)
		$CPUProgress = GUICtrlCreateProgress(30, 60, 45, 70, BitOR($PBS_SMOOTH, $PBS_VERTICAL))
			GUICtrlSetBkColor(-1, 0x000000)
			GUICtrlSetColor(-1, 0x00FF00)
			GUICtrlSetData(-1, 50)
		$CPULabel1 = GUICtrlCreateLabel("50%", 42, 138, 40, 20)
	GUICtrlCreateGroup("RAM Usage", 15, 170, 75, 120)
		$RAMProgress = GUICtrlCreateProgress(30, 190, 45, 70, BitOR($PBS_SMOOTH, $PBS_VERTICAL))
			GUICtrlSetBkColor(-1, 0x000000)
			GUICtrlSetColor(-1, 0x00FF00)
			GUICtrlSetData(-1, 50)
		$RAMLabel = GUICtrlCreateLabel("50%", 42, 268, 40, 20)
	GUICtrlCreateGroup("CPU Usage History", 100, 40, 160, 120)
	GUICtrlCreateGroup("PF Usage History", 270, 40, 160, 120)
	$CleanRAM = GUICtrlCreateButton("Clean RAM", 15, 296, 75, 22)
	$DefragRAM = GUICtrlCreateButton("Defrag RAM", 15, 325, 75, 22)
$OptionsTab = GUICtrlCreateTabItem("Options")
GUICtrlCreateTabItem("")

$ProcessLabel = GUICtrlCreateLabel("   processes", 5, 360, 120, 18, $SS_SUNKEN)
$CPULabel2 = GUICtrlCreateLabel(" CPU usage:    %", 128, 360, 125, 18, $SS_SUNKEN)
$TTMLabel = GUICtrlCreateLabel("Total Task Manager 2.0", 256, 360, 189, 18, BitOr($SS_SUNKEN, $SS_CENTER))
adlib()
AdlibEnable("adlib", 2000)

GUISetState()

While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE or $msg = $MenuExit Then _exit()
	; Window context menu
	If $msg = $WindowClose Then _WindowClose()
	If $msg = $WindowFlash Then _WindowFlash()
	If $msg = $LockWindow Then _WindowSetState(@SW_LOCK)
	If $msg = $UnlockWindow Then _WindowSetState(@SW_UNLOCK)
	If $msg = $ShowWindow Then _WindowSetState(@SW_SHOW)
	If $msg = $HideWindow Then _WindowSetState(@SW_HIDE)
	If $msg = $MinimizeWindow Then _WindowSetState(@SW_MINIMIZE)
	If $msg = $MaximizeWindow Then _WindowSetState(@SW_MAXIMIZE)
	If $msg = $RestoreWindow Then _WindowSetState(@SW_RESTORE)
	If $msg = $WindowCopyName Then _WindowCopy(1)
	If $msg = $WindowCopyHandle Then _WindowCopy(2)
	If $msg = $WindowCopyWidth Then _WindowCopy(5)
	If $msg = $WindowCopyHeight Then _WindowCopy(6)
	If $msg = $WindowCopyXPos Then _WindowCopy(3)
	If $msg = $WindowCopyYPos Then _WindowCopy(4)
	If $msg = $WindowCopyLocation Then
		$title = _GUICtrlListViewGetItemTextArray($WindowListView, _GUICtrlListViewGetCurSel($WindowListView))
		ClipPut(getExePathByPid(WinGetProcess($title[1])))
	EndIf
	If $msg = $WindowLocate Then _WindowLocate()
	If GUICtrlRead($ShowHiddenWindowsCheckbox) = 1 Then
		$ShowHidden = 1
	Else
		$ShowHidden = 0
	EndIf
WEnd

Func adlib()
	; Update stats
	$ProcessList = ProcessList()
	GUICtrlSetData($ProcessLabel, " " & $ProcessList[0][0] & " processes")
	$CPUUsage = _ProcessListCPU("", 0)
	GUICtrlSetData($CPULabel2, "CPU usage: " & $CPUUsage[0][1] - 2 & "%")
	GUICtrlSetData($CPULabel1, $CPUUsage[0][1] - 2 & "%")
	GUICtrlSetData($CPUProgress, $CPUUsage[0][1] - 2)
	$MemStats = MemGetStats()
	GUICtrlSetData($RAMProgress, $MemStats[0])
	GUICtrlSetData($RAMLabel, $MemStats[0] & "%")
	GUIGetMsg() ; Reduce CPU load
EndFunc

Func _WindowLocate()
	$title = _GUICtrlListViewGetItemTextArray($WindowListView, _GUICtrlListViewGetCurSel($WindowListView))
	MsgBox(262144, "'" & $title[1] & "' is:", getExePathByPid(WinGetProcess($title[1])))
EndFunc

Func getExePathByPid($pid)
    $objWMIService = ObjGet("winmgmts:\\.\root\CIMV2")
    $colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_Process WHERE ProcessId = " & $pid, "WQL", 0x10 + 0x20)
    If IsObj($colItems) Then
        For $objItem In $colItems
            Return $objItem.ExecutablePath
        Next
    EndIf
EndFunc

Func _WindowCopy($item)
	$title = _GUICtrlListViewGetItemTextArray($WindowListView, _GUICtrlListViewGetCurSel($WindowListView))
	$ClipInfo = $title[$item]
	ClipPut($ClipInfo)
EndFunc

Func _WindowSetState($state)
	$title = _GUICtrlListViewGetItemTextArray($WindowListView, _GUICtrlListViewGetCurSel($WindowListView))
	WinSetState($title[1], "", $state)
EndFunc

Func _WindowFlash()
	$title = _GUICtrlListViewGetItemTextArray($WindowListView, _GUICtrlListViewGetCurSel($WindowListView))
	WinFlash($title[1])
EndFunc

Func _WindowClose()
	$title = _GUICtrlListViewGetItemTextArray($WindowListView, _GUICtrlListViewGetCurSel($WindowListView))
	WinClose($title[1])
	_GUICtrlListViewDeleteItemsSelected($WindowListView)
EndFunc

Func _WinList()
	$WindowList = WinList()
	Dim $WindowListViewItem[$WindowList[0][0]+1]
	For $i = 1 to $WindowList[0][0]
		$new = 1
		If $ShowHidden = 0 Then
			$IsVisible = "No"
		Else
			$IsVisible = "Yes"
		EndIf
		If $WindowList[$i][0] <> "" and $WindowList[$i][0] <> "Program Manager" Then
			If IsVisible($WindowList[$i][0]) Then $IsVisible = "Yes"
			If $WindowList[$i][0] = "Total Task Manager 2.0" Then $IsVisible = "Yes"
			If $IsVisible = "Yes" Then
				For $j = 0 to _GUICtrlListViewGetSubItemsCount($WindowListView)
					$text = StringSplit(_GUICtrlListViewGetItemText($WindowListView, $j), "|")
					If IsArray($text) and $text[0] > 3 Then
						If $WindowList[$i][1] = $text[2] Then $new = 0
					EndIf
				Next
				If $new = 1 Then
					$WinPos = WinGetPos($WindowList[$i][0])
					$WindowListViewItem[$i] = GUICtrlCreateListViewItem($WindowList[$i][0] & "|" & $WindowList[$i][1] & "|" & $WinPos[0] & "|" & $WinPos[1] & "|" & $WinPos[2] & "|" & $WinPos[3], $WindowListView)
					GUICtrlSetImage($WindowListViewItem[$i], getExePathByPid(WinGetProcess($WindowList[$i][0])))
				EndIf
			EndIf
		EndIf
	Next
EndFunc

Func _ProcessList()
	$ProcessList = ProcessList()
	For $i = 1 to $ProcessList[0][0]
		GUICtrlCreateListViewItem($ProcessList[$i][0] & "|" & $ProcessList[$i][1], $ProcessListView)
	Next
EndFunc

Func IsVisible($handle)  ; Taken from help file
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc

Func _exit()
	Opt("TrayIconHide", 1)
	Exit
EndFunc