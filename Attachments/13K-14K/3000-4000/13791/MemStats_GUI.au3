;------------------------------------------------------------
; MemStats by AutoItKing
; Shows RAM and Page File usage
; Also has an option to reduce the memory load
; AutoIt3
; 2007
; Duh
;------------------------------------------------------------

#include <GUIConstants.au3>

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
TraySetOnEvent(-7, "ShowGui")

$mostused=IniRead("MemStats.ini","RAM","most","0")
$leastused=IniRead("MemStats.ini","RAM","least","100")
$mostusedpf=IniRead("MemStats.ini","PF","most","0")
$leastusedpf=IniRead("MemStats.ini","PF","least","100")

$mem=MemGetStats()

$Form1 = GUICreate("MemStats By AutoItKing", 588, 330)

$Group1 = GUICtrlCreateGroup("Specs", 8, 8, 249, 200)
$Label3 = GUICtrlCreateLabel("Total RAM: " & Round($mem[1]/1024,1) & " MB", 24, 40, 226, 17)
$Label3 = GUICtrlCreateLabel("Total PF: " & Round($mem[3]/1024,1) & " MB", 24, 168, 226, 17)
$Label6 = GUICtrlCreateLabel("Total C: Space: " & Round(DriveSpaceTotal("c:")/1024,1) & "GB", 24, 72, 224, 17)
$Label7 = GUICtrlCreateLabel("Available C: Space: " & Round(DriveSpaceFree("c:")/1024,1) & "GB", 24, 104, 227, 17)
$Label8 = GUICtrlCreateLabel("File System: " & DriveGetFileSystem("c:"), 24, 136, 224, 17)

$Group2 = GUICtrlCreateGroup("RAM Usage", 264, 8, 315, 155)
$Progress1 = GUICtrlCreateProgress(272, 30, 300, 20)
$percent = GUICtrlCreateLabel($mem[0] & "% Percent Used", 312, 88, 100, 17)
$Label4 = GUICtrlCreateLabel(Round(($mem[1]-$mem[2])/1024,1) & "MB in use", 312, 56, 100, 17)
$Label5 = GUICtrlCreateLabel(Round($mem[2]/1024,1) & "MB available", 312, 72, 100, 17)
$most = GUICtrlCreateLabel("Most used: " & $mostused & "%", 312, 122, 100, 17)
$least = GUICtrlCreateLabel("Least used: " & $leastused & "%", 312, 139, 100, 17)

$Group3 = GUICtrlCreateGroup("Page File Usage", 264, 168, 315, 155)
$Progress2 = GUICtrlCreateProgress(272, 190, 300, 20)
$pfpercent = GUICtrlCreateLabel(Round((($mem[3]-$mem[4])/$mem[3])*100,0) & "% Percent Used", 312, 88+160, 100, 17)
$pfuse = GUICtrlCreateLabel(Round(($mem[3]-$mem[4])/1024,1) & "MB in use", 312, 56+160, 100, 17)
$pfavail = GUICtrlCreateLabel(Round($mem[4]/1024,1) & "MB available", 312, 72+160, 100, 17)
$mostpf = GUICtrlCreateLabel("Most used: " & $mostusedpf & "%", 312, 122+160, 100, 17)
$leastpf = GUICtrlCreateLabel("Least used: " & $leastusedpf & "%", 312, 139+160, 100, 17)

$reducemem = GUICtrlCreateButton("Reduce Memory Usage",5,220,150,50)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	$mem=MemGetStats()
	GUICtrlSetData($percent,$mem[0] & "% Percent Used")
	GUICtrlSetData($Label4,Round(($mem[1]-$mem[2])/1024,1) & "MB in use")
	GUICtrlSetData($Label5,Round($mem[2]/1024,1) & "MB available")
	GUICtrlSetData($Progress1,$mem[0])
	
	GUICtrlSetData($pfpercent,Round((($mem[3]-$mem[4])/$mem[3])*100,0) & "% Percent Used")
	GUICtrlSetData($pfuse,Round(($mem[3]-$mem[4])/1024,1) & "MB in use")
	GUICtrlSetData($pfavail,Round($mem[4]/1024,1) & "MB available")
	GUICtrlSetData($Progress2,Round((($mem[3]-$mem[4])/$mem[3])*100,0))
	
	If $mem[0] > $mostused Then
		$mostused=$mem[0]
		GUICtrlSetData($most, "Most used: " & $mostused & "%")
		IniWrite("MemStats.ini","RAM","most",$mostused)
	EndIf
	If $mem[0] < $leastused Then
		$leastused=$mem[0]
		GUICtrlSetData($least, "Least used: " & $leastused & "%")
		IniWrite("MemStats.ini","RAM","least",$leastused)
	EndIf
	
	If Round((($mem[3]-$mem[4])/$mem[3])*100,0) > $mostusedpf Then
		$mostusedpf=Round((($mem[3]-$mem[4])/$mem[3])*100,0)
		GUICtrlSetData($mostpf, "Most used: " & $mostusedpf & "%")
		IniWrite("MemStats.ini","PF","most",$mostusedpf)
	EndIf
	If Round((($mem[3]-$mem[4])/$mem[3])*100,0) < $leastusedpf Then
		$leastusedpf=Round((($mem[3]-$mem[4])/$mem[3])*100,0)
		GUICtrlSetData($leastpf, "Least used: " & $leastusedpf & "%")
		IniWrite("MemStats.ini","PF","least",$leastusedpf)
	EndIf
	Sleep(50)
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			
		Case $GUI_EVENT_MINIMIZE
			GUISetState(@SW_HIDE)
			
		Case $reducemem
			$processes=ProcessList()
			GUISetState(@SW_DISABLE)
			$current1=GUICtrlCreateLabel("Optimizing RAM: ",5,280,200,20)
			If @error Then
				MsgBox(0,"Error", "Could not enumerate processes.")
				GUIDelete($current1)
				GuiSetState(@SW_ENABLE)
			Else
				$i=0
				$i2=0
				$percent=0
				$num=1
				While $num<=$processes[0][0]
					$current=$processes[$num][1]
					GUICtrlSetData($current1,"Optimizing RAM: " & $processes[$num][0])
					_ReduceMemory($current)
					$num += 1
					Sleep(100)
				WEnd
				GUICtrlDelete($current1)
				GuiSetState(@SW_ENABLE)
			EndIf
	EndSwitch
	TraySetToolTip("Ram Usage: " & Round(($mem[1]-$mem[2])/1024,1) & " MB in use" & _
			@LF & "Page File Usage: " & Round(($mem[3]-$mem[4])/1024,1) & " MB in use")
WEnd

Func _ReduceMemory($i_PID = -1)
	$memory_counter = 1
	If $i_PID <> - 1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc

Func ShowGui()
	GUISetState(@SW_SHOW)
EndFunc