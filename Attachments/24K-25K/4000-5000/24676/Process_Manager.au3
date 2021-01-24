#AutoIt3Wrapper_aut2exe=C:\Program Files\AutoIt3\aut2exe\Aut2Exe.exe
#AutoIt3Wrapper_icon=S:\Scripting Projects\Process Manager\Icons\process.ico
#AutoIt3Wrapper_outfile=S:\Scripting Projects\Process Manager\Process Manager.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Description=AutoIt v3 Compiled Script
;
;Process Manager
;v.1.0
;written by Jared Epstein
#include <Constants.au3>
#include <GUIConstants.au3>
#include <GUIListView.au3>
#Include <GuiTab.au3>
#include <Process.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <CompInfo.au3>
#notrayicon

Dim $vDescending, $users

$name = "Process Manager"
$version = "1.0"
$author = "Jared Epstein"

Opt("TrayMenuMode", 1)

$restore = TrayCreateItem("Restore")
TrayItemSetState(-1, $TRAY_DEFAULT)
$newtray = TrayCreateItem("New Task")
$exittray = TrayCreateItem("Exit")

$main = GUICreate($name, 500, 610)
$contextmenu = GUICtrlCreateContextMenu()
$fileopt = GUICtrlCreateMenu("&File")
$ontopitem = GUICtrlCreateMenuItem("Always On Top", $fileopt)
$top = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\PM", "AlwaysOnTop")
If $top = 0 Then
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	WinSetOnTop($name, "", 0)
ElseIf $top = 1 Then
	GUICtrlSetState(-1, $GUI_CHECKED)
	WinSetOnTop($name, "", 1)
EndIf
$exititem = GUICtrlCreateMenuItem("Exit", $fileopt)
$helpopt = GUICtrlCreateMenu("About")
$helpitem = GUICtrlCreateMenuItem("Help", $helpopt)
$aboutitem = GUICtrlCreateMenuItem("About", $helpopt)

$tab = GUICtrlCreateTab(5, 5, 490, 495)

$tab0 = GUICtrlCreateTabItem("Processes")
GUICtrlSetState(-1, $GUI_SHOW)
$listview = GUICtrlCreateListView("Process|PID|Priority|Process Owner       |Parent", 20, 30, 465, 460, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
$processes = _ProcessListProperties()
For $i = 1 To $processes[0][0]
	$priority = _ProcessGetPriority($processes[$i][1])
	GUICtrlCreateListViewItem($processes[$i][0] & "|" & $processes[$i][1] & "|" & $priority & "|" & $processes[$i][3] & "|" & $processes[$i][2], $listview)
	GUICtrlSetImage(-1, "shell32.dll", 3)
	GUICtrlSetImage(-1, $processes[$i][5], 1)
Next
_GUICtrlListView_SetColumnWidth ($listview, 0, $LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($listview, 1, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetColumnWidth ($listview, 2, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetColumnWidth ($listview, 4, $LVSCW_AUTOSIZE_USEHEADER)
$tab1 = GUICtrlCreateTabItem("Applications")
$listview1 = GUICtrlCreateListView("Window Title                        |Window Handle|Associated Process|PID", 20, 30, 465, 460, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
$windows = WinList()
For $i = 1 To $windows[0][0]
	$winpid = WinGetProcess($windows[$i][0], "")
	$winprocess = _WinGetProcessName($windows[$i][0], '')
	If $windows[$i][0] <> "" And IsVisible($windows[$i][1]) Then
		$winpath = _ProcessGetPath($winpid)
		GUICtrlCreateListViewItem($windows[$i][0] & "|" & $windows[$i][1] & "|" & $winprocess & "|" & $winpid, $listview1)
		GUICtrlSetImage(-1, "shell32.dll", 3)
		GUICtrlSetImage(-1, $winpath, 1)
	EndIf
Next
_GUICtrlListView_SetColumnWidth ($listview1, 1, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetColumnWidth ($listview1, 2, $LVSCW_AUTOSIZE_USEHEADER)
_GUICtrlListView_SetColumnWidth ($listview1, 3, $LVSCW_AUTOSIZE_USEHEADER)
$tab2 = GUICtrlCreateTabItem("Users")
$listview2 = GUICtrlCreateListView("Name|Domain/Computer|Description", 20, 30, 465, 460, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
_ComputerGetUsers ($users)
For $i = 1 To $users[0][0]
	GUICtrlCreateListViewItem($users[$i][0] & "|" & $users[$i][1] & "|" & $users[$i][4], $listview2)
	GUICtrlSetImage(-1, "shell32.dll", 220)
Next
_GUICtrlListView_SetColumnWidth ($listview2, 0, $LVSCW_AUTOSIZE)
_GUICtrlListView_SetColumnWidth ($listview2, 2, $LVSCW_AUTOSIZE)
GUICtrlCreateTabItem("")

$new = GUICtrlCreateButton("New Task", 40, 520, 75, 25)
$kill = GUICtrlCreateButton("Kill Process", 120, 520, 75, 25)
$refresh = GUICtrlCreateButton("Refresh", 40, 550, 75, 25)
$google = GUICtrlCreateButton("Google",120, 550, 75, 25)
$getpath = GUICtrlCreateButton("Get Path", 200, 520, 75, 25)
$findexe = GUICtrlCreateButton("Find File Exe", 200, 550, 75, 25)
$viewstart = GUICtrlCreateButton("View Startup Items", 280, 520, 100, 25)
$viewinstalled = GUICtrlCreateButton("View Installed Apps", 280, 550, 100, 25)
$close = GUICtrlCreateButton("Close", 385,535,75,25)

GUISetState()
Do
	$msg = GUIGetMsg()
	$msga = TrayGetMsg()

	Select
		Case $msg = $new Or $msga = $newtray
			$open = FileOpenDialog("New Task", @HomeDrive, "All (*.*)", 1, "")
			If @error = 1 Then
			Else
				ShellExecute($open)
				RefreshProcess()
				RefreshWindow()
			EndIf
		Case $msg = $kill
			$tabhandle = GUICtrlGetHandle($tab)
			$tabid = _GUICtrlTab_GetCurFocus ($tabhandle)
			If $tabid = 0 Then
				_KillProcess($listview, 2)
				RefreshWindow()
			ElseIf $tabid = 1 Then
				_KillProcess($listview1, 3)
				RefreshProcess()
			EndIf
		Case $msg = $refresh
			$tabhandle = GUICtrlGetHandle($tab)
			$tabid = _GUICtrlTab_GetCurFocus ($tabhandle)
			If $tabid = 0 Then
				RefreshProcess()
			ElseIf $tabid = 1 Then
				RefreshWindow()
			ElseIf $tabid = 2 Then
				RefreshUsers()
			EndIf
		Case $msg = $getpath
			$tabhandle = GUICtrlGetHandle($tab)
			$tabid = _GUICtrlTab_GetCurFocus ($tabhandle)
			If $tabid = 0 Then
				_GetPath($listview, 0)
			ElseIf $tabid = 1 Then
				_GetPath($listview1, 3)
			EndIf
		Case $msg = $findexe
			_FindFileExe()
		Case $msg = $viewinstalled
			_ViewInstalled($main)
		Case $msg = $viewstart
			_ViewStart($main)
		Case $msg = $google
			$tabhandle = GUICtrlGetHandle($tab)
			$tabid = _GUICtrlTab_GetCurFocus ($tabhandle)
			If $tabid = 0 Then
				$item = _GUICtrlListView_GetItemText(GuiCtrlGetHandle($listview), _GUICtrlListView_GetSelectedIndices($listview), 0)
				_OpenWeb("http://www.google.com/search?q=" & $item)
			ElseIf $tabid = 1 Then
				$item = _GUICtrlListView_GetItemText(GuiCtrlGetHandle($listview1), _GUICtrlListView_GetSelectedIndices($listview1), 2)
				_OpenWeb("http://www.google.com/search?q=" & $item)
			EndIf
	EndSelect

	If $msg = $ontopitem Then
		If BitAND(GUICtrlRead($ontopitem), $GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($ontopitem, $GUI_UNCHECKED)
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\PM", "AlwaysOnTop", "REG_SZ", "0")
			WinSetOnTop("", "", 0)
		Else
			GUICtrlSetState($ontopitem, $GUI_CHECKED)
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\PM", "AlwaysOnTop", "REG_SZ", "1")
			WinSetOnTop("", "", 1)
		EndIf
	EndIf

	If $msg = $aboutitem Then
		_AboutInfo ($name, $version, $author, $main, "Icons\process.ico")
	EndIf

	If $msg = $close Or $msg = $exititem Or $msga = $exittray Then
		ExitLoop
	EndIf
	
	If $msga = $restore Then
		_RestoreFromTray($main)
	EndIf

	If $msg = $GUI_EVENT_MINIMIZE Then
		_MinimizeToTray($main)
	EndIf
	
	If $msg = $helpitem Then
		ShellExecute("pmhelp.chm", "", @ScriptDir)
	EndIf

Until $msg = $GUI_EVENT_CLOSE
GUIDelete()

Func _OpenWeb($URL) ;borrowed
    $oWeb = ObjCreate ("Shell.Application")
    $oWeb.Open ($URL)
EndFunc   ;==>_OpenWeb

Func _KillProcess($listviewid, $stringpart)
	$split = StringSplit(GUICtrlRead(GUICtrlRead($listviewid)), "|")
	ProcessClose($split[$stringpart])
	GUICtrlDelete(GUICtrlRead($listview1))
EndFunc   ;==>_KillProcess

Func _GetPath($listviewid, $pidindex)
	$selected = _GUICtrlListView_GetSelectedIndices ($listviewid, 0)
	$listviewhandle = GUICtrlGetHandle($listviewid)
	$pid = _GuiCtrlListView_GetItemText ($listviewhandle, $selected, $pidindex)
	;$pidpath = _ProcessListProperties($pid)
	$pidpath = _ProcessGetPath($pid)
	;MsgBox(0, "Process Path", $pidpath[1][5])
	MsgBox(0, "Process Path", $pidpath)
EndFunc   ;==>_GetPath

Func _FindFileExe()
	Dim $szDrive, $szDir, $szFName, $szExt
	$file = FileOpenDialog("Find Associated EXE", @HomeDrive, "All (*.*)", 3)
	If @error = 1 Then
	Else
		$filepath = _WinAPI_FindExecutable ($file)
		$fileexe = _PathSplit($filepath, $szDrive, $szDir, $szFName, $szExt)
		$pid = _ProcessGetPid($fileexe[3] & $fileexe[4])
		$owner = _ProcessGetOwner($pid[1], @ComputerName)
		$parentpid = _ProcessGetParent($pid[1])
		MsgBox(64, "Associated Process", "Process: " & $fileexe[3] & $fileexe[4] & @CRLF & "PID: " & $pid[1] & @CRLF & "Owner: " & $owner & @CRLF & "Parent: " & $parentpid)
	EndIf
EndFunc   ;==>_FindFileExe

Func _ViewInstalled($parent)
	Dim $key[500]
	$child = GUICreate("Installed Items", 800, 490, -1, -1, -1, -1, $parent)
	$listview3 = GUICtrlCreateListView("Software|Version|Subkey Name", 10, 10, 780, 470, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
	$p = 1
	While 1
		$key[$p] = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\windows\currentversion\uninstall", $p)
		If @error = 2 Then
			ContinueLoop
		ElseIf @error = -1 Then
			ExitLoop
		ElseIf @error = 1 Then
			ExitLoop
		EndIf
		$p += 1
	WEnd
	For $q = 1 To $p
		$software = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\windows\currentversion\uninstall\" & $key[$q], "DisplayName")
		If $software = "" Then
		ElseIf $software <> "" Then
			$instversion = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\windows\currentversion\uninstall\" & $key[$q], "DisplayVersion")
			GUICtrlCreateListViewItem($software & "|" & $instversion & "|" & $key[$q], $listview3)
		EndIf
	Next
	_GUICtrlListView_SimpleSort ($listview3, $software, 0)
	_GUICtrlListView_SetColumnWidth ($listview3, 0, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth ($listview3, 1, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth ($listview3, 2, $LVSCW_AUTOSIZE)
	GUISetState()
	Do
		$msg1 = GUIGetMsg()

	Until $msg1 = $GUI_EVENT_CLOSE
	GUIDelete($child)
EndFunc   ;==>_ViewInstalled

Func _ViewStart($parent)
	Dim $stkey1[500], $stkey2[500]
	$child = GUICreate("Startup Items", 740, 490, -1, -1, -1, -1, $parent)
	$listview4 = GUICtrlCreateListView("Current_User\Software\Microsoft\Windows\CurrentVersion\Run|Executable Path", 10, 10, 720, 150, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
	$cu = 1
	While 1
		$stkey1[$cu] = RegEnumVal("HKEY_CURRENT_USER\SOFTWARE\Microsoft\windows\currentversion\run", $cu)
		If @error = 2 Then
			ContinueLoop
		ElseIf @error = -1 Then
			ExitLoop
		ElseIf @error = 1 Then
			ExitLoop
		EndIf
		$oldstkey1path = RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\windows\currentversion\run", $stkey1[$cu])
		$stkey1path = StringReplace($oldstkey1path, '"', "", 0)
		GUICtrlCreateListViewItem($stkey1[$cu] & "|" & $stkey1path, $listview4)
		GUICtrlSetImage(-1, "shell32.dll", 3)
		GUICtrlSetImage(-1, $stkey1path, 0)
		$cu += 1
	WEnd
	$listview5 = GUICtrlCreateListView("Local_Machine\Software\Microsoft\Windows\CurrentVersion\Run|Executable Path", 10, 170, 720, 150, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
	$lm = 1
	While 1
		$stkey2[$lm] = RegEnumVal("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\windows\currentversion\run", $lm)
		If @error = 2 Then
			ContinueLoop
		ElseIf @error = -1 Then
			ExitLoop
		ElseIf @error = 1 Then
			ExitLoop
		EndIf
		$oldstkey2path = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\windows\currentversion\run", $stkey2[$lm])
		$stkey2path = StringReplace($oldstkey2path, '"', "", 0)
		GUICtrlCreateListViewItem($stkey2[$lm] & "|" & $stkey2path, $listview5)
		GUICtrlSetImage(-1, "shell32.dll", 3)
		GUICtrlSetImage(-1, $stkey2path, 0)
		$lm += 1
	WEnd
	$listview6 = GUICtrlCreateListView("Executable Path|Description", 10, 330, 720, 150, BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_HEADERDRAGDROP))
	$lnksearch = FileFindFirstFile("C:\Documents and Settings\Jared Epstein\Start Menu\Programs\Startup\*.*")
	If $lnksearch = -1 Then
	EndIf
	While 1
		$lnk = FileFindNextFile($lnksearch)
		If @error Then ExitLoop
		If StringRight($lnk, 4) = ".lnk" Then
			$lnkinfo = FileGetShortcut("C:\Documents and Settings\Jared Epstein\Start Menu\Programs\Startup\" & $lnk)
			If @error Then
				GUICtrlCreateListViewItem("C:\Documents and Settings\Jared Epstein\Start Menu\Programs\Startup\" & $lnk & "|", $listview6)
				GUICtrlSetImage(-1, "C:\Documents and Settings\Jared Epstein\Start Menu\Programs\Startup\" & $lnk, 1)
			Else
				GUICtrlCreateListViewItem($lnkinfo[0] & "|" & $lnkinfo[3], $listview6)
				GUICtrlSetImage(-1, "shell32.dll", 3)
				GUICtrlSetImage(-1, $lnkinfo[0], 0)
			EndIf
		Else
			GUICtrlCreateListViewItem("C:\Documents and Settings\Jared Epstein\Start Menu\Programs\Startup\" & $lnk & "|", $listview6)
			GUICtrlSetImage(-1, "C:\Documents and Settings\Jared Epstein\Start Menu\Programs\Startup\" & $lnk, 1)
		EndIf
	WEnd
	FileClose($lnksearch)
	_GUICtrlListView_SetColumnWidth ($listview4, 0, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth ($listview4, 1, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth ($listview5, 0, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth ($listview5, 1, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth ($listview6, 0, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth ($listview6, 1, $LVSCW_AUTOSIZE)
	GUISetState()
	Do
		$msg1 = GUIGetMsg()

	Until $msg1 = $GUI_EVENT_CLOSE
	GUIDelete($child)
EndFunc   ;==>_ViewStart

Func RefreshProcess()
	_GUICtrlListView_DeleteAllItems ($listview)
	$processes = _ProcessListProperties()
	For $i = 1 To $processes[0][0]
		$priority = _ProcessGetPriority($processes[$i][1])
		GUICtrlCreateListViewItem($processes[$i][0] & "|" & $processes[$i][1] & "|" & $priority & "|" & $processes[$i][3] & "|" & $processes[$i][2], $listview)
		GUICtrlSetImage(-1, "shell32.dll", 3)
		GUICtrlSetImage(-1, $processes[$i][5], 1)
	Next
	_GUICtrlListView_SetColumnWidth ($listview, 0, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth ($listview, 1, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth ($listview, 2, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth ($listview, 4, $LVSCW_AUTOSIZE_USEHEADER)
EndFunc   ;==>RefreshProcess

Func RefreshWindow()
	_GUICtrlListView_DeleteAllItems ($listview1)
	$windows = WinList()
	For $i = 1 To $windows[0][0]
		$winpid = WinGetProcess($windows[$i][0], "")
		$winprocess = _WinGetProcessName($windows[$i][0], '')
		If $windows[$i][0] <> "" And IsVisible($windows[$i][1]) Then
			$winpath = _ProcessGetPath($winpid)
			GUICtrlCreateListViewItem($windows[$i][0] & "|" & $windows[$i][1] & "|" & $winprocess & "|" & $winpid, $listview1)
			GUICtrlSetImage(-1, "shell32.dll", 3)
			GUICtrlSetImage(-1, $winpath, 1)
		EndIf
	Next
	_GUICtrlListView_SetColumnWidth ($listview1, 1, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth ($listview1, 2, $LVSCW_AUTOSIZE_USEHEADER)
	_GUICtrlListView_SetColumnWidth ($listview1, 3, $LVSCW_AUTOSIZE_USEHEADER)
EndFunc   ;==>RefreshWindow

Func RefreshUsers()
	_GUICtrlListView_DeleteAllItems ($listview2)
	_ComputerGetUsers ($users)
	For $i = 1 To $users[0][0]
		GUICtrlCreateListViewItem($users[$i][0] & "|" & $users[$i][1] & "|" & $users[$i][4], $listview2)
	Next
	_GUICtrlListView_SetColumnWidth ($listview2, 0, $LVSCW_AUTOSIZE)
	_GUICtrlListView_SetColumnWidth ($listview2, 2, $LVSCW_AUTOSIZE)
EndFunc   ;==>RefreshUsers

Func IsVisible($handle) ;borrowed
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible

Func _RestoreFromTray($parent)
	GUISetState(@SW_SHOW, $parent)
	GUISetState(@SW_RESTORE, $parent)
	Opt("TrayIconHide", 1)
EndFunc   ;==>_RestoreFromTray

Func _MinimizeToTray($parent)
	GUISetState(@SW_HIDE, $parent)
	Opt("TrayIconHide", 0)
EndFunc   ;==>_MinimizeToTray

Func _ProcessListProperties($Process = "", $sComputer = ".") ;borrowed
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
			$colProcs = $oWMI.ExecQuery ("select * from win32_process")
		ElseIf IsInt($Process) Then
			; Get by PID
			$colProcs = $oWMI.ExecQuery ("select * from win32_process where ProcessId = " & $Process)
		Else
			; Get by Name
			$colProcs = $oWMI.ExecQuery ("select * from win32_process where Name = '" & $Process & "'")
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
				If $oProc.GetOwner ($sUserName, $sUserDomain) = 0 Then $avProcs[$n][3] = $sUserDomain & "\" & $sUserName
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
		$colProcs = $oRefresher.AddEnum ($oWMI, "Win32_PerfFormattedData_PerfProc_Process" ).objectSet
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
EndFunc   ;==>_ProcessListProperties

Func _WinGetProcessName($s_Title, $s_Text = '') ;borrowed
	Local $i_PID, $a_ProcList
	$i_PID = WinGetProcess($s_Title, $s_Text)
	If $i_PID <> -1 Then
		$a_ProcList = ProcessList()
		For $i_For = 1 To $a_ProcList[0][0]
			If $a_ProcList[$i_For][1] = $i_PID Then
				SetExtended($i_PID)
				Return $a_ProcList[$i_For][0]
			EndIf
		Next
	EndIf
	SetError(1)
	Return False
EndFunc   ;==>_WinGetProcessName

Func _ProcessGetPath($pid) ;borrowed
	If IsString($pid) Then $pid = ProcessExists($pid)
	$Path = DllStructCreate("char[1000]")
	$dll = DllOpen("Kernel32.dll")
	$handle = DllCall($dll, "int", "OpenProcess", "dword", 0x0400 + 0x0010, "int", 0, "dword", $pid)
	$ret = DllCall("Psapi.dll", "long", "GetModuleFileNameEx", "long", $handle[0], "int", 0, "ptr", DllStructGetPtr($Path), "long", DllStructGetSize($Path))
	$ret = DllCall($dll, "int", "CloseHandle", "hwnd", $handle[0])
	DllClose($dll)
	Return DllStructGetData($Path, 1)
EndFunc   ;==>_ProcessGetPath

Func _ProcessGetPid($sName) ;borrowed
	If Not ProcessExists($sName) Then
		SetError(1)
		Return ""
	EndIf
	Local $aPList = ProcessList($sName)
	If @error Then Return ""
	Local $aMatches[UBound($aPList) ]
	$aMatches[0] = $aPList[0][0]
	For $i = 1 To $aPList[0][0]
		$aMatches[$i] = $aPList[$i][1]
	Next
	Return $aMatches
EndFunc   ;==>_ProcessGetPid

Func _ProcessGetOwner($vProcess, $strComputer) ;borrowed

	Local $i_PID = ProcessExists($vProcess)
	If Not $i_PID Then
		SetError(1)
		Return -1
	EndIf

	Local $wbemFlagReturnImmediately = 0x10
	Local $wbemFlagForwardOnly = 0x20
	Local $colItems = ""
	Local $strUser = ""

	$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_Process WHERE ProcessID = " & $i_PID, "WQL", _
			$wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			$rc = $objItem.GetOwner ($strUser)

			Switch $rc
				Case 0
					SetError(0)
					Return $strUser
				Case 2
					SetError(2)
					Return "ACCESS DENIED"
				Case 3
					SetError(3)
					Return "INSUFFICIENT PRIVILEGE"
				Case 8
					SetError(8)
					Return "UNKNOWN FAILURE"
				Case 9
					SetError(9)
					Return "PATH NOT FOUND"
				Case 21
					SetError(21)
					Return "INVALID PARAMETER"
				Case Else
					SetError(1)
					Return -1
			EndSwitch
		Next
	EndIf
EndFunc   ;==>_ProcessGetOwner

Func _ProcessGetParent($i_PID) ;borrowed
	Local Const $TH32CS_SNAPPROCESS = 0x00000002

	Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
	If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_PID)

	Local $tagPROCESSENTRY32 = _
			DllStructCreate _
			( _
			"dword dwsize;" & _
			"dword cntUsage;" & _
			"dword th32ProcessID;" & _
			"uint th32DefaultHeapID;" & _
			"dword th32ModuleID;" & _
			"dword cntThreads;" & _
			"dword th32ParentProcessID;" & _
			"long pcPriClassBase;" & _
			"dword dwFlags;" & _
			"char szExeFile[260]" _
			)
	DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))

	Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)

	Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
	If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_PID)

	Local $a_pnext, $i_return = 0
	If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_PID Then
		$i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
		DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
		If $i_return Then Return $i_return
		Return $i_PID
	EndIf

	While 1
		$a_pnext = DllCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
		If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop
		If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_PID Then
			$i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
			If $i_return Then ExitLoop
			$i_return = $i_PID
			ExitLoop
		EndIf
	WEnd

	If $i_return = "" Then $i_return = $i_PID

	DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
	Return $i_return
EndFunc   ;==>_ProcessGetParent

Func _AboutInfo($s_Program,$s_Version,$s_Author,$h_Parent,$s_Icon = "")
	Local $h_Child,$s_Font,$h_Aboutok,$s_Msg1
	$h_Child = GUICreate("About", 220, 220, -1, -1, -1, -1, $h_Parent)
	$s_Font = "Ariel"
	GUICtrlCreateLabel($s_Program & " " & $s_Version, 50, 30, 150, 30)
	GUICtrlSetFont(-1, 10, 400, $s_Font)
	GUICtrlCreateIcon($s_Icon, -1, 85, 60, 48, 48)
	GUICtrlCreateLabel("Written by " & $s_Author, 55, 120, 150, 30)
	GUICtrlSetFont(-1, 10, 400, $s_Font)
	GUICtrlCreateLabel("Copyright " & @YEAR, 55, 140, 150, 30)
	GUICtrlSetFont(-1, 10, 400, $s_Font)
	$h_Aboutok = GUICtrlCreateButton("OK", 75, 175, 75, 25)
	GUISetState()
	Do
		$s_Msg1 = GUIGetMsg()
		If $s_Msg1 = $h_Aboutok Then
			ExitLoop
		EndIf
	Until $s_Msg1 = $GUI_EVENT_CLOSE
	GUIDelete($h_Child)
EndFunc   ;==>_AboutInfo