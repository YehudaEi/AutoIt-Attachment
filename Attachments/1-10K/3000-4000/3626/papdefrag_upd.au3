; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Language: English
; Platform: WindowsXP
;
; Script Function: Plain Defragment tool with multiple disk and shutdown options
; ----------------------------------------------------------------------------






#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <GuiList.au3>
#include <date.au3>
#include <Constants.au3>




opt ("TrayMenuMode", 1)
TraySetToolTip("PaPd3fr4g")
GUICreate("PaPd3fr4g", 400, 300)
Dim $drives[10], $timer, $count
$list = GUICtrlCreateListView("Drive|Name|Space Free|Space Total|Percentage Free", 10, 10, 380, 100)
drive_gen()
_GUICtrlListViewJustifyColumn ($list, 2, 1)
_GUICtrlListViewJustifyColumn ($list, 3, 1)
_GUICtrlListViewJustifyColumn ($list, 4, 1)
$listbox = GUICtrlCreateList("", 10, 120, 120, 100)
$addjob = GUICtrlCreateButton("Add Job", 140, 120, 70, 20)
$deljob = GUICtrlCreateButton("Delete", 140, 150, 70, 20)
$analyze = GUICtrlCreateButton("Analyze", 10, 220, 70, 20)
$Defrag = GUICtrlCreateButton("Defragment", 90, 220, 70, 20)
$stop = GUICtrlCreateButton("Stop", 170, 220, 70, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
$exit = GUICtrlCreateButton("Exit", 250, 220, 70, 20)
$info = GUICtrlCreateLabel("", 10, 280, 380, 20)
GUICtrlCreateLabel("Time Elapsed:", 280, 260)
$timedisp = GUICtrlCreateLabel("00:00:00", 350, 260)
$shutdown = GUICtrlCreateCheckbox("Shutdown when finished?", 10, 255)
Global $Secs, $Mins, $Hour, $Time
GUISetState()



While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $exit
			Exit
		Case $msg = $analyze
			analyze()
		Case $msg = $Defrag
			defragment()
		Case $msg = $addjob
			GUICtrlSetData($listbox, StringUpper($drives[GUICtrlRead($list) - 3]))
		Case $msg = $deljob
			_GUICtrlListDeleteItem ($listbox, _guictrllistselectedindex ($listbox))
	EndSelect
	
	
WEnd




Func drive_gen()
	Global $drives = DriveGetDrive("FIXED")
	
	For $i = 1 To $drives[0]
		$name = DriveGetLabel($drives[$i])
		If $name = "" Then $name = "<Local Disk>"
		$free = Round(DriveSpaceFree($drives[$i]) / 1024, 2) & " GB"
		$total = Round(DriveSpaceTotal($drives[$i]) / 1024, 2) & " GB"
		$per = Round(($free / $total) * 100) & " %"
		If $per < 15 Then TrayTip("Warning", "Some Drives have Free Disk percentage lower than 15% which is recommended.", 10, 2)
		Assign("Item" & $i, GUICtrlCreateListViewItem(StringUpper($drives[$i]) & "|" & $name & "|" & $free & "|" & $total & "|" & $per, $list), 2)
	Next
	_GUICtrlListViewSetItemSelState ($list, _Guictrllistviewgettopindex ($list), 1)
EndFunc   ;==>drive_gen

Func analyze()
	If GUICtrlRead($list) = 0 Then Return
	GUICtrlSetData($info, "Analyzing....")
	$out=Run(@ComSpec & " /c defrag " & $drives[GUICtrlRead($list) - 3] & " -a -v", "", @SW_HIDE,$STDERR_CHILD + $STDOUT_CHILD)
	$log = ""
	While @error <> -1
		$log &= StdoutRead($out)
	WEnd
	MsgBox(0, "Analysis Report", $log)
	GUICtrlSetData($info, "")
EndFunc   ;==>analyze

Func defragment()
	
	
	$timer = TimerInit()
	
	$count = _GUICtrlListCount ($listbox)
	For $i = 0 To $count
		AdlibEnable("timer")
		If $count = $i Then ExitLoop
		GUICtrlSetData($info, "Defragmenting drive " & _guictrllistgettext ($listbox, $i) & " .... Please Wait.....")
		GUICtrlSetState($stop, $GUI_ENABLE)
		GUICtrlSetState($analyze, $GUI_DISABLE)
		GUICtrlSetState($Defrag, $GUI_DISABLE)
		send("#r")
		winwait("Run")
		winactivate("Run") 
		winwaitactive("Run")
		Send("Defrag " & _guictrllistgettext ($listbox, $i)& "{ENTER}")
		WinWaitActive("C:\WINDOWS\system32\")
		WinSetState("C:\WINDOWS\system32\","",@SW_HIDE)
		ProcessWaitClose("defrag.exe")
		ProcessClose("cmd.exe")
	Next
	
	If GUICtrlRead($shutdown) = $GUI_CHECKED Then
		$msgbox = MsgBox(1, "", "Your computer will now shutdown...", 6)
		If $msgbox = 1 Then Shutdown(1)
		EndIf
		
	GUICtrlSetState($stop, $GUI_DISABLE)
	GUICtrlSetState($analyze, $GUI_ENABLE)
	GUICtrlSetState($Defrag, $GUI_ENABLE)
	GUICtrlSetData($info, "")
	AdlibDisable()
	GUICtrlSetData($timedisp, "00:00:00")
EndFunc   ;==>defragment









Func Timer()
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Or $msg = $exit Then
		If MsgBox(4, "", "Defragment is currently working" & @CRLF & "Are you sure you want to exit?") = 6 Then
			WinSetState("C:\WINDOWS\system32\","",@SW_SHOW)
			WinWaitActive("C:\WINDOWS\system32\")
			Send("^C")
			WinSetState("C:\WINDOWS\system32\","",@SW_HIDE)
			ProcessWaitClose("defrag.exe")
			ProcessClose("cmd.exe")
			Exit
		EndIf
	EndIf
	
	If $msg = $stop Then
		If MsgBox(4, "", "Defragment is currently working" & @CRLF & "Are you sure you want to stop?") = 6 Then
			WinSetState("C:\WINDOWS\system32\","",@SW_SHOW)
			WinWaitActive("C:\WINDOWS\system32\")
			Send("^C")
			WinSetState("C:\WINDOWS\system32\","",@SW_HIDE)
			ProcessWaitClose("defrag.exe")
			ProcessClose("cmd.exe")
			AdlibDisable()
			GUICtrlSetData($timedisp, "00:00:00")
			GUICtrlSetState($stop, $GUI_DISABLE)
			GUICtrlSetState($analyze, $GUI_ENABLE)
			GUICtrlSetState($Defrag, $GUI_ENABLE)
			GUICtrlSetData($info, "")
			$counter = 0
			Return
		EndIf
	EndIf
	
	
	_TicksToTime(Int(TimerDiff($timer)), $Hour, $Mins, $Secs)
	Local $sTime = $Time  ; save current time to be able to test and avoid flicker..
	$Time = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
	If $sTime <> $Time Then GUICtrlSetData($timedisp, $Time)
EndFunc   ;==>Timer













