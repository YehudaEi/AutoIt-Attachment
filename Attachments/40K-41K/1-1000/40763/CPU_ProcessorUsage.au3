; ========================================================================================================
; <CPU_ProcessorUsage.au3>
;
; Example of an alternative means to read individual CPU Usages for multiple CPUs,
; along with the combined overall CPU usage. (Alternative to Performance Counters)
;  Readings are shown in a 'Splash' window
;
; Functions:
;	_CPUGetTotalProcessorTimes()      ; Gets Overall (combined CPUs) Processor Times
;	_CPUGetIndividualProcessorTimes() ; Returns an array of CPU usage info for individual processors
;	_CPUsUsageTracker_Create()        ; Creates a CPU usage tracker for all CPUs
;	_CPUsUsageTracker_GetUsage()      ; Updates CPU usage tracker and returns a CPU usage array
;	_CPUOverallUsageTracker_Create()  ; Creates a CPU usage tracker for Overall CPU usage
;	_CPUOverallUsageTracker_GetUsage(); Updates CPU usage tracker and returns CPU usage [Overall Usage]
;
; See also:
;	Performance Counters UDF
;
;
; Author: Ascend4nt
; ========================================================================================================

;   --------------------    HOTKEY FUNCTION & VARIABLE --------------------

Global $bHotKeyPressed=False

Func _EscPressed()
    $bHotKeyPressed=True
EndFunc


; ==============================================================================================
; Func _CPUGetTotalProcessorTimes()
;
; Gets the total (combined CPUs) system processor times (as FILETIME)
; Note that Kernel Mode time includes Idle Mode time, so a proper calculation of usage time is
;   Kernel + User - Idle
; And percentage (based on two readings):
;  (Kernel_b - Kernel_a) + (User_b - User_a) - (Idle_b - Idle_a) * 100
;	/ (Kernel_b - Kernal_a) + (User_b - User_a)
;
; O/S Requirements: min. Windows XP SP1+
;
; Returns:
;  Success: Array of info for total (combined CPU's) processor times:
;   [0] = Idle Mode Time
;   [1] = Kernel Mode Time -> NOTE This INCLUDES Idle Time
;   [2] = User Mode Time
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned False - call GetLastError for more info
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUGetTotalProcessorTimes()
	Local $aRet, $stSystemTimes

	$stSystemTimes = DllStructCreate("int64 IdleTime;int64 KernelTime;int64 UserTime;")

	$aRet = DllCall("kernel32.dll", "bool", "GetSystemTimes", "ptr", DllStructGetPtr($stSystemTimes, 1), _
		"ptr", DllStructGetPtr($stSystemTimes, 2), "ptr", DllStructGetPtr($stSystemTimes, 3) )

	If @error Then Return SetError(2, @error, "")
	If Not $aRet[0] Then Return SetError(3, 0, "")

	Dim $aRet[3] = [ _
		DllStructGetData($stSystemTimes, 1), _
		DllStructGetData($stSystemTimes, 2), _
		DllStructGetData($stSystemTimes, 3) ]

	Return $aRet
EndFunc


; ==============================================================================================
; Func _CPUGetIndividualProcessorTimes()
;
; Gets an array of system processor times (as FILETIME)
; Note that Kernel Mode time includes Idle Mode time, so a proper calculation of usage time is
;   Kernel + User - Idle
; And percentage (based on two readings):
;  (Kernel_b - Kernel_a) + (User_b - User_a) - (Idle_b - Idle_a) * 100
;	/ (Kernel_b - Kernal_a) + (User_b - User_a)
;
; Returns:
;  Success: 2 Dimensional Array of info [@extended = #of CPU's]:
;   [0][0] = # of CPUs (and array elements)
;   [1..n][0] = Idle Mode Time for CPU # n
;   [1..n][1] = Kernel Mode Time for CPU # n -> NOTE This INCLUDES Idle Time
;   [1..n][2] = User Mode Time for CPU # n
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: NTSTATUS returned error code, @extended contains error code
;    @error = 4: Invalid length returned, @extended is length
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUGetIndividualProcessorTimes()
	; DPC = Deferred Procedure Calls
	Local $tagSYSTEM_PROCESSOR_TIMES = "int64 IdleTime;int64 KernelTime;int64 UserTime;int64 DpcTime;int64 InterruptTime;ulong InterruptCount;"

	Local $aRet, $stProcessorTimes, $stBuffer
	Local $i, $nTotalCPUStructs, $pStructPtr

	; 256 [maximum CPU's] * 48 (structure size) = 12288
	$stBuffer = DllStructCreate("byte Buffer[12288];")

	; SystemProcessorTimes = 8
	Local $aRet=DllCall("ntdll.dll", "long", "NtQuerySystemInformation", "int", 8, "ptr", DllStructGetPtr($stBuffer), "ulong", 12288, "ulong*", 0)
	If @error Then Return SetError(2, @error, "")

	; NTSTATUS of something OTHER than success?
	If $aRet[0] Then Return SetError(3, $aRet[0], "")
	; Length invalid?
	If $aRet[4] = 0 Or $aRet[0] > 12288 Or Mod($aRet[4], 48) <> 0 Then Return SetError(4, $aRet[4], "")

	$nTotalCPUStructs = $aRet[4] / 48
;~ 	ConsoleWrite("Returned buffer length = " & $aRet[4] & ", len/48 (struct size) = "& $nTotalCPUStructs & @CRLF)

	; We are interested in Idle, Kernel, and User Times (3)
	Dim $aRet[$nTotalCPUStructs + 1][3]

	$aRet[0][0] = $nTotalCPUStructs

	; Traversal Pointer for individual CPU structs
	$pStructPtr = DllStructGetPtr($stBuffer)

	For $i = 1 To $nTotalCPUStructs
		$stProcessorTimes = DllStructCreate($tagSYSTEM_PROCESSOR_TIMES, $pStructPtr)

		$aRet[$i][0] = DllStructGetData($stProcessorTimes, "IdleTime")
		$aRet[$i][1] = DllStructGetData($stProcessorTimes, "KernelTime")
		$aRet[$i][2] = DllStructGetData($stProcessorTimes, "UserTime")

		; Next CPU structure
		$pStructPtr += 48
	Next

	Return SetExtended($nTotalCPUStructs, $aRet)
EndFunc

; ==============================================================================================
; Func _CPUsUsageTracker_Create()
;
; Creates a CPU usage tracker array for all processors.  This array should be passed
; to _CPUsUsageTracker_GetUsage() to get current usage information back.
;
; Returns:
;  Success: An array used to track CPU usage [@extended = # of CPU's]
;   Array 'internal' format:
;	  $arr[0][0] = # of CPU's
;	  $arr[1..n][0] = Total CPU Time (Kernel + User Mode)
;	  $arr[1..n][1] = Total Active CPU Time (Kernel + User - Idle)
;
;  Failure: "" with @error set [reflects _CPUGetIndividualProcessorTimes codes]:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: NTSTATUS returned error code, @extended contains error code
;    @error = 4: Invalid length returned, @extended is length
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUsUsageTracker_Create()
	Local $nTotalCPUs, $aCPUTimes, $aCPUsUsage

	$aCPUTimes = _CPUGetIndividualProcessorTimes()
	If @error Then Return SetError(@error, @extended, "")

	$nTotalCPUs = @extended
	Dim $aCPUsUsage[$nTotalCPUs + 1][2]

	$aCPUsUsage[0][0] = $nTotalCPUs

	For $i = 1 To $nTotalCPUs
		; Total
		$aCPUsUsage[$i][0] = $aCPUTimes[$i][1] + $aCPUTimes[$i][2]
		; TotalActive (Kernel Time includes Idle time, so we need to subtract that)
		$aCPUsUsage[$i][1] = $aCPUTimes[$i][1] + $aCPUTimes[$i][2] - $aCPUTimes[$i][0]
	Next

	Return SetExtended($nTotalCPUs, $aCPUsUsage)
EndFunc


; ==============================================================================================
; Func _CPUOverallUsageTracker_Create()
;
; Creates a CPU usage tracker array for Overall combined processors usage.
; This array should be passed to _CPUOverallUsageTracker_GetUsage() to get
; current usage information.
;
; Returns:
;  Success: An array used to track Overall CPU usage
;   Array 'internal' format:
;	  $arr[0] = Total Overall CPU Time (Kernel + User Mode)
;	  $arr[1] = Total Active Overall CPU Time (Kernel + User - Idle)
;
;  Failure: "" with @error set [reflects _CPUGetTotalProcessorTimes codes]:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned False - call GetLastError for more info
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUOverallUsageTracker_Create()
	Local $aCPUTimes, $aCPUsUsage[2]

	$aCPUTimes = _CPUGetTotalProcessorTimes()
	If @error Then Return SetError(@error, @extended, "")

	; Total
	$aCPUsUsage[0] = $aCPUTimes[1] + $aCPUTimes[2]
	; TotalActive (Kernel Time includes Idle time, so we need to subtract that)
	$aCPUsUsage[1] = $aCPUTimes[1] + $aCPUTimes[2] - $aCPUTimes[0]

	Return $aCPUsUsage
EndFunc


; ==============================================================================================
; Func _CPUsUsageTracker_GetUsage(ByRef $aCPUsUsage)
;
; Updates a CPUsUsage array and returns an array of CPU Usage information for all processors.
;
; Returns:
;  Success: Array of CPU Usage -> 1 for each processor + 1 for Overall [@extended = # of processors]
;	[0..n]  = CPU Usage (Percentage)
;   [#CPUs] = CPUs Overall Usage (Percentage)
;  Failure: "" with @error set to 1 for invalid parameters, or:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: NTSTATUS returned error code, @extended contains error code
;    @error = 4: Invalid length returned, @extended is length
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUsUsageTracker_GetUsage(ByRef $aCPUsUsage)
	If Not IsArray($aCPUsUsage) Or UBound($aCPUsUsage, 2) < 2 Then Return SetError(1, 0, "")

	Local $nTotalCPUs, $aUsage, $aCPUsCurInfo
	Local $nTotalActive, $nTotal
	Local $nOverallActive, $nOverallTotal

	$aCPUsCurInfo = _CPUsUsageTracker_Create()
	If @error Then Return SetError(@error, @extended, "")

	$nTotalCPUs = $aCPUsCurInfo[0][0]
	Dim $aUsage[$nTotalCPUs + 1]

	$nOverallActive = 0
	$nOverallTotal = 0

	For $i = 1 To $nTotalCPUs
		$nTotal = $aCPUsCurInfo[$i][0] - $aCPUsUsage[$i][0]
		$nTotalActive = $aCPUsCurInfo[$i][1] - $aCPUsUsage[$i][1]
		$aUsage[$i - 1] = Round($nTotalActive * 100 / $nTotal, 1)

		$nOverallActive += $nTotalActive
		$nOverallTotal += $nTotal
	Next
	$aUsage[$nTotalCPUs] = Round( ($nOverallActive / $nTotalCPUs) * 100 / ($nOverallTotal / $nTotalCPUs), 1)

	; Replace current usage tracker info
	$aCPUsUsage = $aCPUsCurInfo

	Return SetExtended($nTotalCPUs, $aUsage)
EndFunc

; ==============================================================================================
; Func _CPUOverallUsageTracker_GetUsage(ByRef $aCPUsUsage)
;
; Updates a CPUsUsage array and returns CPU Usage information [Overall processor usage]
;
; Returns:
;  Success: CPU Usage (Percentage)
;  Failure: 0 with @error set to 1 for invalid parameters, or:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned False - call GetLastError for more info
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUOverallUsageTracker_GetUsage(ByRef $aCPUsUsage)
	If Not IsArray($aCPUsUsage) Or UBound($aCPUsUsage) < 2 Then Return SetError(1, 0, "")

	Local $aCPUsCurInfo, $fUsage, $nTotalActive, $nTotal

	$aCPUsCurInfo = _CPUOverallUsageTracker_Create()
	If @error Then Return SetError(@error, @extended, 0)

	$nTotal = $aCPUsCurInfo[0] - $aCPUsUsage[0]
	$nTotalActive = $aCPUsCurInfo[1] - $aCPUsUsage[1]

	; Replace current usage tracker info
	$aCPUsUsage = $aCPUsCurInfo

	Return Round($nTotalActive * 100 / $nTotal, 1)
EndFunc


;   --------------------    MAIN PROGRAM CODE   --------------------

HotKeySet("{Esc}", "_EscPressed")

Local $hSplash, $sSplashText
; CPU Usage for all CPU's
Local $iTotalCPUs, $aCPUsUsageTracker, $aPercents

; Overall CPU Usage Tracker		; (GetSystemTimes)
;~ Local $aCPUOverallTracker


; CPUs Usage Tracker
$aCPUsUsageTracker = _CPUsUsageTracker_Create()
If @error Then Exit ConsoleWrite("Error calling _CPUsUsageTracker_Create():" & @error & ", @extended = " & @extended & @CRLF)

; Overall CPU Usage tracker
;~ $aCPUOverallTracker = _CPUOverallUsageTracker_Create()
;~ If @error Then Exit ConsoleWrite("Error calling _CPUOverallUsageTracker_Create():" & @error & ", @extended = " & @extended & @CRLF)

$iTotalCPUs = $aCPUsUsageTracker[0][0]

ConsoleWrite("Total # CPU's: " & $iTotalCPUs & @CRLF)

Sleep(250)

$hSplash=SplashTextOn("CPU Usage Information [" & $iTotalCPUs & " total CPU's]", "", _
	240, 20 + ($iTotalCPUs + 1) * 35, Default, Default, 16, Default, 12)

; Start loop
Do
	$aPercents = _CPUsUsageTracker_GetUsage($aCPUsUsageTracker)

	$sSplashText=""
	For $i=0 To $iTotalCPUs - 1
		$sSplashText &= "CPU #"& $i+1 & ": " & $aPercents[$i] & " %" & @CRLF
	Next
	$sSplashText &= @CRLF &"[Overall CPU Usage] :" & $aPercents[$iTotalCPUs] & " %" & @CRLF

	; Alternative, if all we wanted was Overall CPU Usage:
;~ 	$sSplashText &= @CRLF &"[Overall CPU Usage] :" & _CPUOverallUsageTracker_GetUsage($aCPUOverallTracker) & " %" & @CRLF

	$sSplashText &= @CRLF & "[Esc] exits"

	ControlSetText($hSplash, "", "[CLASS:Static; INSTANCE:1]", $sSplashText)
	Sleep(500)
Until $bHotKeyPressed
