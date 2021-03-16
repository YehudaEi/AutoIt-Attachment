; ========================================================================================================
; <DiskDeviceIOStatistics.au3>
;
; Example of reading and displaying Disk and Device I/O Statistics, using a 'Spash' window
;  NOTE There is alot more data returned from _NTSysPerformanceInfo(), but
;  for our purposes, we focus only on I/O data
;
; Functions:
;	_NTSysPerformanceInfo()		; Returns I/O and a whole slew of other Performance Info
;
; Author: Ascend4nt
; ========================================================================================================

; ===================================================================================================================
; Func _NTSysPerformanceInfo()
;
; Returns Disk & Device I/O Statistics (and much more) from NtQuerySystemInformation.
;
; NOTE: ZWReadFile and ZWWriteFile are low-level File I/O that are called by higher-level File I/O
;	(such as ReadFile and WriteFile)
;
; Returns:
;  Success: Array of I/O and Performance Stats:
;	[0]  = Idle Time of all CPU's on the system (in 100-nanosecond intervals)
;	[1]  = # of Bytes Read through ZWReadFile calls
;	[2]  = # of Bytes Written through ZWWriteFile calls
;	[3]  = # of Bytes for all Other I/O Operations (such as Device I/O)
;	[4]  = # of calls made to ZWReadFile (NOT the # of bytes - see [1])
;	[5]  = # of calls made to ZWWriteFile (NOT the # of bytes - see [2])
;	[6]  = # of calls to other I/O Operations (such as Device I/O) - see [3]
;	[7]  = # of Physical Pages Available to Processes
;	[8]  = # of Commited Pages of Virtual Memory
;	[9]  = Commit Limit - # of Pages that can be committed before extending PageFile
;	[10] = Peak # of Pages of Committed Virtual Memory
;	[11] = # of Page Faults (soft and hard)
;	[12] = # of Write Faults (attempts to write to copy-on-write pages)
;	[13] = # of Soft Page Faults [TransitionFaults]
;	[14] = # of Demand Zero Faults
;	[15] = # of Pages Read from Disk to Resolve Page Faults
;	[16] = # of Read Operations to Resolve Page Faults [not # of pages]
;	[17] = # of Pages Written to System's Pagefiles
;	[18] = # of Write operations performed on System's Pagefiles
;	.. alot more info (see SYSTEM_PERFORMANCE_INFO structure) ..
;	[73] = # of System Calls
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: NTSTATUS returned error code, @extended contains error code
;
; Author: Ascend4nt
; ===================================================================================================================

Func _NTQuerySysPerfInfo()
#cs
	; SYSTEM_PERFORMANCE_INFORMATION Defined as size 312 in latest <winternl.h>,
	;  but on Win7 this is 328 (both 32-bit and 64-bit modes).
	; For now I've added a buffer at the end of 16 bytes (+ 16 more for future issues).
	; Hopefully eventually I'll be able to track down what the extra data is.
	; Its obviously not a 32-bit vs 64-bit size difference..
#ce
	Local Const $tagSYSTEM_PERFORMANCE_INFORMATION = "uint64 IdleTime;uint64 ReadTransferCount;uint64 WriteTransferCount;uint64 OtherTransferCount;" & _
		"ULONG ReadOperationCount;ULONG WriteOperationCount;ULONG OtherOperationCount;" & _
		"ULONG AvailablePages;ULONG TotalCommittedPages;ULONG TotalCommitLimit;ULONG PeakCommitment;" & _
		"ULONG PageFaults;ULONG WriteCopyFaults;ULONG TransitionFaults;ULONG Reserved1;ULONG DemandZeroFaults;ULONG PagesRead;ULONG PageReadIos;" & _
		"ULONG Reserved2[2];ULONG PagefilePagesWritten;ULONG PagefilePageWriteIos;ULONG MappedFilePagesWritten;ULONG MappedFilePageWriteIos;" & _
		"ULONG PagedPoolUsage;ULONG NonPagedPoolUsage;ULONG PagedPoolAllocs;ULONG PagedPoolFrees;ULONG NonPagedPoolAllocs;ULONG NonPagedPoolFrees;" & _
		"ULONG TotalFreeSystemPtes;ULONG SystemCodePage;ULONG TotalSystemDriverPages;ULONG TotalSystemCodePages;" & _
		"ULONG SmallNonPagedLookasideListAllocateHits;ULONG SmallPagedLookasideListAllocateHits;ULONG Reserved3;" & _
		"ULONG MmSystemCachePage;ULONG PagedPoolPage;ULONG SystemDriverPage;" & _
		"ULONG FastReadNoWait;ULONG FastReadWait;ULONG FastReadResourceMiss;ULONG FastReadNotPossible;ULONG FastMdlReadNoWait;" & _
		"ULONG FastMdlReadWait;ULONG FastMdlReadResourceMiss;ULONG FastMdlReadNotPossible;" & _
		"ULONG MapDataNoWait;ULONG MapDataWait;ULONG MapDataNoWaitMiss;ULONG MapDataWaitMiss;" & _
		"ULONG PinMappedDataCount;ULONG PinReadNoWait;ULONG PinReadWait;ULONG PinReadNoWaitMiss;ULONG PinReadWaitMiss;" & _
		"ULONG CopyReadNoWait;ULONG CopyReadWait;ULONG CopyReadNoWaitMiss;ULONG CopyReadWaitMiss;" & _
		"ULONG MdlReadNoWait;ULONG MdlReadWait;ULONG MdlReadNoWaitMiss;ULONG MdlReadWaitMiss;" & _
		"ULONG ReadAheadIos;ULONG LazyWriteIos;ULONG LazyWritePages;ULONG DataFlushes;ULONG DataPages;" & _
		"ULONG ContextSwitches;ULONG FirstLevelTbFills;ULONG SecondLevelTbFills;ULONG SystemCalls;" & "ULONG Buffer[8];"

	Local $stSysPerfInfo,$iSysInfoLen

	$stSysPerfInfo = DllStructCreate($tagSYSTEM_PERFORMANCE_INFORMATION)
	$iSysInfoLen = DllStructGetSize($stSysPerfInfo)

;~ 	ConsoleWrite("SYSTEM_PERFORMANCE_INFORMATION structure size:" & $iSysInfoLen & @CRLF)

	; SystemPerformanceInformation = class 2
	Local $aRet=DllCall("ntdll.dll","long","NtQuerySystemInformation","int",2,"ptr",DllStructGetPtr($stSysPerfInfo),"ulong",$iSysInfoLen,"ulong*",0)
	If @error Then Return SetError(2, @error, "")

	; NTSTATUS of something OTHER than success?
	If $aRet[0] Then
;~ 		If $aRet[0] = 0xC0000004 Then ConsoleWrite("STATUS_INFO_LENGTH_MISMATCH, size required: " &$aRet[4] & @CRLF)
		Return SetError(3, $aRet[0], "")
	EndIf

;~ 	If $aRet[4]<>$iSysInfoLen Then ConsoleWriteError("Size mismatch: $stInfo struct length="&$iSysInfoLen&", ReturnLength="&$aRet[4]&@LF)

;~ 	_DLLStructDisplay($stSysPerfInfo, $tagSYSTEM_PERFORMANCE_INFORMATION)

	Dim $aRet[74]
	For $i = 1 To 74
		$aRet[$i - 1] = DllStructGetData($stSysPerfInfo, $i)
	Next
	Return $aRet
EndFunc


; ====================================================================================================
; Func _AddCommas($sString)
;
; Simple PCRE to add commas - borrowed from StackOverflow
; "regex - Insert commas into number string" - answer by toolkit:
; @ http://stackoverflow.com/a/721415
;
; Author: Ascend4nt
; ====================================================================================================

Func _AddCommas($sString)
	Return StringRegExpReplace($sString, "(\d)(?=(\d{3})+$)", "$1,")
EndFunc


;   --------------------    HOTKEY FUNCTION & VARIABLE --------------------

Global $bHotKeyPressed = False

Func _EscPressed()
    $bHotKeyPressed=True
EndFunc

;   --------------------    MAIN PROGRAM CODE   --------------------

HotKeySet("{Esc}", "_EscPressed")

Local $hSplash, $sSplashText
Local $aIOStats


$aIOStats = _NTQuerySysPerfInfo()
If @error Then
	Exit ConsoleWrite("@error = " &@error & ", @extended = " &Hex(@extended) & @CRLF)
EndIf

ConsoleWrite(" I/O Stats: Read = " & _AddCommas($aIOStats[1]) & "; Write = " & _AddCommas($aIOStats[2]) & "; Other = " & _AddCommas($aIOStats[3]) & @CRLF)

$hSplash=SplashTextOn("Hard Drive Usage Information", "", 740, 24 + (4 * 15), Default, Default, 16+4, "Lucida Console", 11)

; Start loop
Do
	$aIOStats = _NTQuerySysPerfInfo()
	$sSplashText  = StringFormat("%50s", "== I/O Stats ==") & @CRLF
	$sSplashText &= StringFormat("Read = %20s | Write = %20s | Other = %20s", _AddCommas($aIOStats[1]), _AddCommas($aIOStats[2]), _AddCommas($aIOStats[3])) & @CRLF

	$sSplashText &= @CRLF & StringFormat("%48s", "[ESC] Exits") & @CRLF

	ControlSetText($hSplash, "", "[CLASS:Static; INSTANCE:1]", $sSplashText)

	Sleep(500)
Until $bHotKeyPressed
