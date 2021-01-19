#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseAnsi=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <Date.au3>

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Serge\My Documents\A_AutoIt\My-SysInfo\dashboard-gui.kxf
$gui = GUICreate("Dashboard", 170, 400, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
GUISetFont(9, 400, 0, "tahoma")

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group5 = GUICtrlCreateGroup("CPU", 5, 5, 160, 45)
$Label8 = GUICtrlCreateLabel("CPU:", 10, 25, 70, 17)
$Graphic4 = GUICtrlCreateGraphic(80, 25, 80, 17)
GUICtrlSetColor(-1, 0x000000)
$Graphic5 = GUICtrlCreateGraphic(81, 26, 0, 15)
GUICtrlSetColor(-1, 0xFF0000)

$Group1 = GUICtrlCreateGroup("Memory", 5, 55, 160, 85)
$Label1 = GUICtrlCreateLabel("RAM:", 10, 75, 150, 17)
$Label2 = GUICtrlCreateLabel("PageFile:", 10, 95, 150, 17)
$Label3 = GUICtrlCreateLabel("Virtual:", 10, 115, 150, 17)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group6 = GUICtrlCreateGroup("Battery", 5, 150, 160, 45)
$Graphic2 = GUICtrlCreateGraphic(9, 169, 152, 17)
$Graphic3 = GUICtrlCreateGraphic(9, 169, 152, 17)
GUICtrlSetColor(-1, 0x000000)
$Label10 = GUICtrlCreateLabel("", 10, 170, 148, 15, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFFFFFF)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Internet", 5, 205, 160, 45)
$Label5 = GUICtrlCreateLabel("IP:", 10, 225, 100, 17)
$Graphic1 = GUICtrlCreateGraphic(120, 225, 40, 15)
GUICtrlSetColor(-1, 0x000000)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Date and Time", 5, 260, 160, 65)
$Label6 = GUICtrlCreateLabel("", 10, 280, 150, 17, $SS_CENTER)
$Label7 = GUICtrlCreateLabel("", 10, 300, 150, 17, $SS_CENTER)

GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Hard + Removable Drives", 5, 330, 160, 45)
$Label4 = GUICtrlCreateLabel("C:\", 10, 350, 120, 17)
$Graphic6 = GUICtrlCreateGraphic(140, 350, 20, 8)
GUICtrlSetColor(-1, 0x000000)
$Graphic7 = GUICtrlCreateGraphic(140, 360, 20, 8)
GUICtrlSetColor(-1, 0x000000)

GUISetState(@SW_SHOW)

#EndRegion ### END Koda GUI section ###

Opt("TrayMenuMode", 1)
$exititem	= TrayCreateItem("Exit")
HotKeySet('{ESC}', '_Exit')

$SYSTEM_POWER_STATUS = DLLStructCreate("byte;byte;byte;byte;int;int")
$power = 0
$timer = TimerInit()
$HD_Read_Reference = 0
$HD_Write_Reference = 0
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = "localhost"
$HD_Read = ""
$HD_Write = ""
$cpu_raw = 0

While 1

; MEMORY
$mem = MemGetStats()
$Total_Ram = Round($mem[1] / 1024, 0)
$Available_Ram = Round($mem[2] /1024, 0)
$Total_Pagefile = Round($mem[3] /1024, 0)
$Available_Pagefile = Round($mem[4] /1024, 0)
$Total_Virtual = Round($mem[5] /1024, 0)
$Available_Virtual = Round($mem[6] /1024, 0)

GUICtrlSetData($Label1, "RAM: " & $Available_Ram & " / " & $Total_Ram & " Mb")
GUICtrlSetData($Label2, "PageFile: "  & $Available_Pagefile & " / " & $Total_Pagefile & " Mb")
GUICtrlSetData($Label3, "Virtual: " & $Available_Virtual & " / " & $Total_Virtual & " Mb")

; HARD DISK
#comments-start
$Total_Hard_Disk = Round(DriveSpaceTotal("C:\") / 1024, 2)
$Free_Hard_Disk = Round(DriveSpaceFree("C:\") / 1024, 2)

GUICtrlSetData($Label4, "C:\ " & $Free_Hard_Disk & " / " & $Total_Hard_Disk & " Gb")
#comments-end

$Disks = DriveGetDrive("All")
$HD_Data = ""
For $i = 1 To $Disks[0]
	$Totaldisk = DriveSpaceTotal($Disks[$i])
	If $Totaldisk > 1024 Then    
		$Totaldisk = Round(($Totaldisk) / 1024, 2) & " Gb"
		$Freedisk = Round(DriveSpaceFree($Disks[$i]) / 1024, 2)
	Else
		$Totaldisk = Round($Totaldisk, 0) & " Mb"	
		$Freedisk = Round(DriveSpaceFree($Disks[$i]), 0)
	EndIf
	If $HD_Data = "" Then
		$HD_Data = StringUpper($Disks[$i]) & "\ " & $Freedisk & " / " & $Totaldisk 
	Else
		$HD_Data = $HD_Data & @CRLF & StringUpper($Disks[$i]) & "\ " & $Freedisk & " / " & $Totaldisk 
	EndIf
Next
$temp = $Disks[0]
$dashboard = WinGetPos("Dashboard")
;WinMove("Dashboard", "", $dashboard[0], $dashboard[1], 170, 383 + ($temp * 17))
GUICtrlSetPos($Group2,5, 330, 160, 25 + ( $temp * 17))
GUICtrlSetPos($Label4, 10, 350, 120, ($temp * 17))
GUICtrlSetData($Label4, $HD_Data)
	
; Internet
GUICtrlSetData($Label5, "IP: " & @IPAddress1)
If @IPAddress1 = "127.0.0.1" Then
	GUICtrlSetBkColor($Graphic1, 0xFF0000) ; red
Else
	GUICtrlSetBkColor($Graphic1, 0x00CC00) ; green
EndIf	

; Date and Time
GUICtrlSetData($Label6, _DateTimeFormat( _NowCalc(),1))
GUICtrlSetData($Label7, _DateTimeFormat( _NowCalc(),3))

; Battery
$status = DLLStructGetData($SYSTEM_POWER_STATUS,1)
$test = DLLCall("kernel32.dll","int","GetSystemPowerStatus", "ptr",DllStructGetPtr($SYSTEM_POWER_STATUS))
    if DLLStructGetData($SYSTEM_POWER_STATUS,3) <> $power Then
		$battery_status = "Charging"	
		$power = DLLStructGetData($SYSTEM_POWER_STATUS,3)
        ;$timeleft = Round((DLLStructGetData($SYSTEM_POWER_STATUS,3)*(TimerDiff($timer)/1000))/60,0)
        GUICtrlSetData($Label10, $power & "%")
		$timer = TimerInit()
	EndIf
    if DLLStructGetData($SYSTEM_POWER_STATUS,1) = 1 and $status = 1 Then
        ;$timeleft = Round((DLLStructGetData($SYSTEM_POWER_STATUS,3)*(TimerDiff($timer)/1000))/60,0)
        $power = DLLStructGetData($SYSTEM_POWER_STATUS,3)
		If $power <> -1 Then
			$battery_status = "Charging"	
			$timer = TimerInit()
			GUICtrlSetData($Label10, $power & "%")
			If $power > 19.9 Then
				$power = $power * 1.5
				GUICtrlSetPos($Label10, 10, 170, $power, 15)
				GUICtrlSetBkColor($Label10, 0x00CC00) ; green
				GUICtrlSetColor($Label10, 0xC0FFC0)
				GUICtrlSetColor($Graphic2, 0x00CC00)
				$status = 0
			Else
				$power = $power * 7.5
				GUICtrlSetPos($Label10, 10, 170, $power, 15)
				GUICtrlSetBkColor($Label10, 0xFFFFFF) ; black text 
				GUICtrlSetColor($Label10, 0x000000)
				GUICtrlSetColor($Graphic2, 0x000000) ; white background
				$status = 0
			EndIf
		Else
			$battery_status = "No Battery"
 			GUICtrlSetData($Label10, "No Battery")
			GUICtrlSetPos($Label10, 10, 170, 150, 15)
			GUICtrlSetBkColor($Label10, -1) 
			GUICtrlSetColor($Graphic2, -1)
		EndIf
    Elseif DLLStructGetData($SYSTEM_POWER_STATUS,1) = 0 and $status = 0 then
        ;$timeleft = Round((DLLStructGetData($SYSTEM_POWER_STATUS,3)*(TimerDiff($timer)/1000))/60,0)
        $power = DLLStructGetData($SYSTEM_POWER_STATUS,3)
        If $power <> -1 Then
			$battery_status = "Discharging"	
			$timer = TimerInit()
			GUICtrlSetData($Label10, $power & "%")
			If $power > 19.9 Then
				$power = $power * 1.5
				GUICtrlSetPos($Label10, 10, 170, $power, 15)
				GUICtrlSetBkColor($Label10, 0xFF0000) ; red 
				GUICtrlSetColor($Label10, 0xFFE0E0)
				GUICtrlSetColor($Graphic2, 0xFF0000)
				$status = 1
			Else
				$power = $power * 7.5
				GUICtrlSetPos($Label10, 10, 170, $power, 15)
				GUICtrlSetBkColor($Label10, 0x000000) ; white text 
				GUICtrlSetColor($Label10, 0xFFFFFF)
				GUICtrlSetColor($Graphic2, 0xFFFFFF) ; black background
				$status = 1
			EndIf
		Else
			$battery_status = "No Battery"
			GUICtrlSetData($Label10, "No Battery")
			GUICtrlSetPos($Label10, 11, 170, 148, 15)
			GUICtrlSetBkColor($Label10, -1) 
			GUICtrlSetColor($Graphic2, -1)
		EndIf
    EndIf


For $i = 1 To 2
    $msg = TrayGetMsg()
	Select
		Case $msg = $exititem
			Exit
		Case Else
			Sleep(500)
			; CPU Load
			$aProcessCPU = _ProcessListCPU("Total", 0)
			$cpu_raw = $aProcessCPU[0][1]
			; an alternative to getting cpu process % - but is it accurate?
			#comments-start
			$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
			$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfFormattedData_PerfOS_Processor", "WQL", _
												$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
			If IsObj($colItems) Then
				For $objItem In $colItems
					 $cpu_raw = $objItem.PercentProcessorTime
					 
				Next	
			EndIf
			#comments-end
			GUICtrlSetData($Label8, "CPU: " & $cpu_raw & "%")
			$cpu = $cpu_raw * 0.78
			If $cpu = 0 Then
				$cpu = 1
			EndIf
			GUICtrlSetPos($Graphic5, 81, 26, $cpu, 15)
			GUICtrlSetBkColor($Graphic5, 0x00CC00) ; green
			GUICtrlSetColor($Graphic5, 0x00CC00) ; green
			If $cpu_raw > 79 And $cpu_raw < 90 Then
				GUICtrlSetBkColor($Graphic5, 0xFFF000) ; yellow
				GUICtrlSetColor($Graphic5, 0xFFFF00)
			ElseIf $cpu_raw > 89 Then
				GUICtrlSetBkColor($Graphic5, 0xFF0000) ; red
				GUICtrlSetColor($Graphic5, 0xFF0000)
			EndIf
			
			
	EndSelect
	
Next


;If $battery_status = "Charging" Or $battery_status = "No Battery" Then
			; Hard Disk Activity
			$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
			$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_PerfDisk_PhysicalDisk", "WQL", _
                                          $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
			If IsObj($colItems) Then
				For $objItem In $colItems
					$HD_Read = $objItem.PercentDiskReadTime
					If $HD_Read > $HD_Read_Reference Then
						GUICtrlSetBkColor($Graphic6, 0xFF0000) ; red content	
					Else
						GUICtrlSetBkColor($Graphic6, 0x00CC00) ; green content
					EndIf
					$HD_Write = $objItem.PercentDiskWriteTime
					If $HD_Write > $HD_Write_Reference Then
						GUICtrlSetBkColor($Graphic7, 0xFF0000) ; red content	
					Else
						GUICtrlSetBkColor($Graphic7, 0x00CC00) ; green content
					EndIf
				Next	
				$HD_Read_Reference = $HD_Read
				$HD_Write_Reference = $HD_Write
			EndIf
;Else 
;	GUICtrlSetBkColor($Graphic6, 0xC0C0C0) ; grey content
;	GUICtrlSetBkColor($Graphic7, 0xC0C0C0) ; grey content
;EndIf	


WEnd

; =====================================================================================================

Func _Exit()
    If WinActive($gui) then Exit
EndFunc

; Works out CPU load
Func _ProcessListCPU($strProcess = "", $iSampleTime = 500, $sComputerName = @ComputerName)
dim $aResultSet[1][3]
   
    if $strProcess = 0 AND IsNumber($strProcess) then $strProcess = "Idle"
    if $iSampleTime = "" AND IsString($iSampleTime) then $iSampleTime = 500
    if $sComputerName = "" then $sComputerName = @ComputerName
   
    if not IsDeclared("aProcess") AND $iSampleTime = 0 then  ;first time in loop mode
        $bFirstTimeInLoopMode = 1
    else
        $bFirstTimeInLoopMode = 0
    endif
   
    if not IsDeclared("aProcess") then
       
        global $aProcess[10000][10] ;[ nul, PID, name, CPU, iP1, iT1, iP2, iT2, iPP, iTT ]
                                    ;   0    1    2     3    4    5    6    7    8    9
        global $objWMIService

        $objWMIService = ObjGet("winmgmts:\\" & $sComputerName & "\root\CIMV2")
        if @error then
            $aResultSet[0][0] = -2
            return $aResultSet
        endif
    endif


    ;First Sample
    if $iSampleTime OR $bFirstTimeInLoopMode = 1 then   ;skip if Loop Mode, but not First time
       
        $colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfRawData_PerfProc_Process")
       
        For $objItem In $colItems
           
            $iPID = $objItem.IDProcess
            If $iPID = 0 AND $objItem.Name = "_Total" Then $iPID = 9999

            $aProcess[$iPID][4] = $objItem.PercentProcessorTime
            $aProcess[$iPID][5] = $objItem.TimeStamp_Sys100NS
        next

        if  $objItem = "" then
            $aResultSet[0][0] = -1  ;collection or process not found
            return $aResultSet
        endif
       
        sleep($iSampleTime)
    endif
   
    ;Second Sample
    $colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_PerfRawData_PerfProc_Process")

    $iCountItems = 0
    $iTotalUsedByName = 0
    $iTotalUsed = 0

    For $objItem In $colItems
       
        if $objItem.Name = "_Total" AND not($strProcess = "_Total") then exitloop
       
        $iPID = $objItem.IDProcess
        If $iPID = 0 AND $objItem.Name = "_Total" Then $iPID = 9999
;~   $aProcess[$iPID][1] = $objItem.IDProcess
;~   $aProcess[$iPID][2] = $objItem.Name
        $aProcess[$iPID][6] = $objItem.PercentProcessorTime
        $aProcess[$iPID][7] = $objItem.TimeStamp_Sys100NS
        $aProcess[$iPID][8] = $aProcess[$iPID][6] - $aProcess[$iPID][4] ;$iPP = ($iP2 - $iP1)
        $aProcess[$iPID][9] = $aProcess[$iPID][7] - $aProcess[$iPID][5] ;$iTT = ($iT2 - $iT1)
        $aProcess[$iPID][3] = round( ($aProcess[$iPID][8] / $aProcess[$iPID][9]) * 100, 0)
                                                        ;$iCPU = round( ($iPP/$iTT) * 100, 0)
        $aProcess[$iPID][4] = $aProcess[$iPID][6]      ;$iP1 = $iP2
        $aProcess[$iPID][5] = $aProcess[$iPID][7]      ;$iT1 = $iT2
       
        ;SumTotalUsed
        if not($objItem.Name = "Idle") AND not($objItem.Name = "_Total") Then
            $iTotalUsed = $iTotalUsed + $aProcess[$iPID][3]
        endif

        ;Result Set
        if  (($strProcess = "") AND IsString($strProcess)) OR _            ;strNAME = "", but not 0
            (StringUpper($strProcess) = StringUpper($objItem.Name)) OR _            ;strNAME = objNAME
            (IsNumber($strProcess) AND ($strProcess = $objItem.IDProcess)) then  ;i1234 = obj1234
                       
            $iCountItems += 1
            redim $aResultSet[$iCountItems +1][3]
            $aResultSet[$iCountItems][0] = $objItem.Name
            $aResultSet[$iCountItems][1] = $iPID
            $aResultSet[$iCountItems][2] = $aProcess[$iPID][3]
            $aResultSet[0][0] = $iCountItems
           
            ;SumTotalByName
            if not($objItem.Name = "Idle") OR ($strProcess = "Idle") Then
                $iTotalUsedByName = $iTotalUsedByName + $aProcess[$iPID][3]
            endif
        endif
    next

    if  $objItem = "" then
            $aResultSet[0][0] = -1  ;collection or process not found
            return $aResultSet
    endif
       
    $aResultSet[0][1] = $iTotalUsed
    $aResultSet[0][2] = $iTotalUsedByName   

    Return $aResultSet
EndFunc ;==>_ProcessListCPU() by novaTek   ...ver 0.02
 

Exit