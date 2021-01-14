

$sProcess = ""        ;All
;~ $sProcess = "Idle"      ;Other test process names
;~ $sProcess = "_Total"  ;funny one
;~ $sProcess = "ntvdm"    ;DOS process
;~ $sProcess = "AutoIt3"    ;do not assign .exe to process name
;~ $sProcess = 1234   ;PID for process
;~ $sProcess = 0            ;Idle


While 1
    $iTimer1 = timerinit()
    
    $aProcessCPU = _ProcessListCPU($sProcess, 0)
    $iTimer2 = int(TimerDiff($iTimer1))
    
    $sTip = "PID" & @TAB & "CPU" & @TAB & "Name" & @LF & @LF
    
    for $i = 1 to $aProcessCPU[0][0]

        $sTip = $sTip & _
                        $aProcessCPU[$i][1] & @TAB & _
                        $aProcessCPU[$i][2] & @TAB & _
                        $aProcessCPU[$i][0] & @LF
    next
        
    $sTip = $sTip & @LF&  _
                        "[0][1]" & @TAB & _
                        $aProcessCPU[0][1] & @TAB & _
                        "_TotalUsed" & @LF
    $sTip = $sTip & _
                        "[0][2]" & @TAB & _
                        $aProcessCPU[0][2] & @TAB & _
                        "_TotalUsedByName" & @LF
    $sTip = $sTip & _
                        "[0][0]" & @TAB & _
                        $aProcessCPU[0][0] & @TAB & _
                        "_ProcessItems" & @LF
    $sTip = $sTip & _
                        "      " & @TAB & _
                        $iTimer2 & @TAB & _
                        "..function time in ms" & @LF

    ;tooltip($sTip)
	ExitLoop
    sleep(500)    ;set your own sleep time for LOOP mode
WEnd


Func _ProcessListCPU($strProcess = "", $iSampleTime = 500, $sComputerName = @ComputerName)
    
;~    All Parameters are optional:
;~      - All process items will be returned if first parameter is not set
;~      - 500 ms is default sample time
;~      - This computer will be measured by default
;~    Process could be string ("Name") or PID number (1234)
;~    For NORMAL MODE(one time measuring): set Sample value to more than 0 ms
;~          ( average CPU usage will be measured during sleep time within function)
;~    For LOOP MODE (continuous measuring): set Sample value to 0 ms
;~          ( average CPU usage will be measured between two function calls )
;~
;~    Success: Returns 2-D array    $array[0][0] = Number of processes (also upper bound of array)
;~          $array[0][1] = Total CPU usage by All Processes
;~          $array[0][2] = Total CPU usage by All Processes under given process "Name"
;~
;~          $array[1][0] = 1st Process name
;~          $array[1][1] = 1st Process ID (PID)
;~          $array[1][2] = 1st Process CPU Usage
;~
;~          $array[2][0] = 2nd Process name
;~          $array[2][1] = 2nd Process ID (PID)
;~          $array[2][2] = 2nd Process CPU Usage
;~          ...
;~          $array[n][0] = nth Process name
;~          $array[n][1] = nth Process ID (PID)
;~          $array[n][2] = nth Process CPU Usage
;~
;~    Failure: Returns 2-D array  $array[0][0] = ""  ( wrong process name or PID )
;~                  $array[0][0] = -1  ( process collection not found)
;~                  $array[0][0] = -2  ( WMI service not found or Computer not found)

    
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
 