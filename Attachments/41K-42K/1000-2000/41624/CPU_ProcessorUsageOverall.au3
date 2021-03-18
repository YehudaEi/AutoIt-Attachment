; ========================================================================================================
; <CPU_ProcessorUsageOverall.au3>
;
; Example of reading combined overall CPU usage and deducing Idle CPU usage as well
;  Readings are shown in a 'Splash' window
;
; Functions:
;	_CPUGetTotalProcessorTimes()      ; Gets Overall (combined CPUs) Processor Times
;	_CPUOverallUsageTracker_Create()  ; Creates a CPU usage tracker for Overall CPU usage
;	_CPUOverallUsageTracker_GetUsage(); Updates CPU usage tracker and returns CPU usage [Overall Usage]
;
; External Functions:
;	_CPUGetIndividualProcessorTimes() ; Returns an array of CPU usage info for individual processors
;	_CPUsUsageTracker_Create()        ; Creates a CPU usage tracker for all CPUs
;	_CPUsUsageTracker_GetUsage()      ; Updates CPU usage tracker and returns a CPU usage array
;
; See also:
;	<CPU_ProcessorUsage.au3>	; Individual CPU processor usage example
;	Performance Counters UDF
;
;
; Author: Ascend4nt
; ========================================================================================================

; --- UDF's ---

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
	Local $aRet, $aTimes
	$aRet = DllCall("kernel32.dll", "bool", "GetSystemTimes", "uint64*", 0, "uint64*", 0, "uint64*", 0)

	If @error Then Return SetError(2, @error, "")
	If Not $aRet[0] Then Return SetError(3, 0, "")

	Dim $aTimes[3] = [ $aRet[1], $aRet[2], $aRet[3] ]

	Return $aTimes
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


;   --------------------    HOTKEY FUNCTION & VARIABLE --------------------

Global $bHotKeyPressed=False

Func _EscPressed()
    $bHotKeyPressed=True
EndFunc


;   --------------------    MAIN PROGRAM CODE   --------------------

HotKeySet("{Esc}", "_EscPressed")

Local $hSplash, $sSplashText

; Overall CPU Usage Tracker		; (GetSystemTimes)
Local $aCPUOverallTracker, $fPercent


; Overall CPU Usage tracker
$aCPUOverallTracker = _CPUOverallUsageTracker_Create()
If @error Then Exit ConsoleWrite("Error calling _CPUOverallUsageTracker_Create():" & @error & ", @extended = " & @extended & @CRLF)

Sleep(250)

$hSplash=SplashTextOn("CPU [Overall] Usage Information", "", _
	240, 100, Default, Default, 16, Default, 12)

; Start loop
Do
	$fPercent = _CPUOverallUsageTracker_GetUsage($aCPUOverallTracker)
	$sSplashText=""

	$sSplashText &= "[Overall CPU Usage] :" & $fPercent & " %" & @CRLF
	$sSplashText &= "[Idle] : " & (100 - $fPercent) & " %" & @CRLF

	$sSplashText &= @CRLF & "[Esc] exits"

	ControlSetText($hSplash, "", "[CLASS:Static; INSTANCE:1]", $sSplashText)
	Sleep(500)
Until $bHotKeyPressed
