#include <GuiConstants.au3>

RAMRun()

Func RAMRun()
    RAMInit()
    TrayCreateItem("Exit")
    TrayItemSetOnEvent(-1, "RAMExit")    
    TraySetState()
    While 1
     Sleep(50)
    WEnd
EndFunc

Func RAMInit()
    Opt("RunErrorsFatal", 0)
    Opt("GUIOnEventMode", 1)
    Opt("TrayOnEventMode",1)
    Opt("TrayMenuMode",   1)  ; Default tray menu items (Script Paused/Exit) will not be shown.
    Opt("GUIResizeMode",  $GUI_DOCKSIZE+$GUI_DOCKLEFT)
    TrayCreateItem("Memory audit")
    TrayItemSetOnEvent(-1, "RAMmonitor")
EndFunc

Func RAMmonitor()
    Opt("GUIOnEventMode", 0)
    $gui = GuiCreate("Memory monitor", 544, 130,-1, -1 , $WS_OVERLAPPEDWINDOW + $WS_CLIPSIBLINGS)
    
    $Progress_1 = CreateProgress(10, 10, 520, 20)
    $Progress_2 = CreateProgress(10, 40, 520, 20)
    $Progress_3 = CreateProgress(10, 70, 520, 20)
    $Button     = GUICtrlCreateButton("Optimize", 470, 100, 60, 25)
    GuiSetState()
    $nb=500
    While 1
		$nb=$nb+10
        If $nb > 500 Then
            $memory = MemGetStats ( )
            UpdateProgress($Progress_1, Round(100*($memory[1]-$memory[2])/$memory[1], 1), "Physical RAM: ")
            UpdateProgress($Progress_2, Round(100*($memory[3]-$memory[4])/$memory[3], 1), "Pagefile size: ")
            UpdateProgress($Progress_3, Round(100*($memory[5]-$memory[6])/$memory[5], 1), "Virtual RAM size: ")
            $nb=0
        EndIf
        Sleep(10)
        $msg = GuiGetMsg()
        If $msg = $GUI_EVENT_CLOSE Then ExitLoop
        If $msg = $Button Then MemoryOptimize()
		If $msg = $GUI_EVENT_MAXIMIZE Then
			WinSetState("Memory monitor","Physical RAM",@SW_RESTORE)
			WinSetTitle("Memory monitor","Physical RAM","Window auto-restore on maximize by PingPong 1.0")
			GuiSetState(@SW_DISABLE)
			Sleep(5000)
			GuiSetState(@SW_ENABLE)
			WinSetTitle("Window auto-restore on maximize by PingPong 1.0","Physical RAM","Memory monitor")
		EndIf
    WEnd
    GUIDelete($gui)
    Opt("GUIOnEventMode", 1)
EndFunc

Func RAMExit()
    Exit
EndFunc

;---------------------------------------------------------------
;- Enhanced Progress widget
;---------------------------------------------------------------
Func CreateProgress($x, $y, $w, $h, $Label="")
    Dim $Progress[2]
    $Progress[0] = GuiCtrlCreateProgress($x, $y, $w, $h)
    $Progress[1] = GuiCtrlCreateLabel($Label, $x, $y+3, $w, $h, $SS_CENTER )
    GUICtrlSetBkColor($Progress[1], $GUI_BKCOLOR_TRANSPARENT)
    Return $Progress
EndFunc

Func UpdateProgress($ProgressID, $Percent, $Label="")
    GUICtrlSetData($ProgressID[0], $Percent)
    GUICtrlSetData($ProgressID[1], $Label & $Percent & "%")    
EndFunc

;---------------------------------------------------------------
;- Reduce memory
;---------------------------------------------------------------
Func MemoryOptimize()
    $memory1 = MemGetStats ( )
    Do
        ReduceMemory()
        $list = ProcessList()
        For $i=1 To $list[0][0]
            If StringInStr($list[$i][0], "csrss") > 0 Or StringInStr($list[$i][0], "smss") > 0 Or StringInStr($list[$i][0], "winlogon") > 0 Or StringInStr($list[$i][0], "lsass") > 0 Then ContinueLoop
            ReduceMemory($list[$i][1])
        Next
        $memory2 = $memory1
        $memory1 = MemGetStats ( )
    Until $memory1[2] >= $memory2[2]
EndFunc
    
Func ReduceMemory($i_PID = -1)
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    
    Return $ai_Return[0]
EndFunc