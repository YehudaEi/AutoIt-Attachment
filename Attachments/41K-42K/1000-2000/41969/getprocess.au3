;the thread stuff was not included because I don/t think this language is thread-safe.
#include <WinAPI.au3>
global const 								_
    $ProcessBasicInformation=0,             _
    $ProcessQuotaLimits=1,                  _
    $ProcessIoCounters=2,                   _
    $ProcessVmCounters=3,                   _
    $ProcessTimes=4,                        _
    $ProcessBasePriority=5,                 _
    $ProcessRaisePriority=6,                _
    $ProcessDebugPort=7,                    _
    $ProcessExceptionPort=8,                _
    $ProcessAccessToken=9,                  _
    $ProcessLdtInformation=10,              _
    $ProcessLdtSize=11,                     _
    $ProcessDefaultHardErrorMode=12,        _
    $ProcessIoPortHandlers=13,              _
    $ProcessPooledUsageAndLimits=14,        _
    $ProcessWorkingSetWatch=15,             _
    $ProcessUserModeIOPL=16,                _
    $ProcessEnableAlignmentFaultFixup=17,   _
    $ProcessPriorityClass=18,               _
    $ProcessWx86Information=19,             _
    $ProcessHandleCount=20,                 _
    $ProcessAffinityMask=21,                _
    $ProcessPriorityBoost=22,               _
    $ProcessDeviceMap=23,                   _
    $ProcessSessionInformation=24,          _
    $ProcessForegroundInformation=25,       _
    $ProcessWow64Information=26,            _
    $ProcessImageFileName=27,               _
    $ProcessLUIDDeviceMapsEnabled=28,       _
    $ProcessBreakOnTermination=29,          _
    $ProcessDebugObjectHandle=30,           _
    $ProcessDebugFlags=31,                  _
    $ProcessHandleTracing=32,               _
    $ProcessIoPriority=33,                  _
    $ProcessExecuteFlags=34,                _
    $ProcessTlsInformation=35,              _
    $ProcessCookie=36,                      _
    $ProcessImageInformation=37,            _
    $ProcessCycleTime=38,                   _
    $ProcessPagePriority=39,                _
    $ProcessInstrumentationCallback=40,     _
    $ProcessThreadStackAllocation=41,       _
    $ProcessWorkingSetWatchEx=42,           _
    $ProcessImageFileNameWin32=43,          _
    $ProcessImageFileMapping=44,            _
    $ProcessAffinityUpdateMode=45,          _
    $ProcessMemoryAllocationMode=46,        _
    $ProcessGroupInformation=47,            _
    $ProcessTokenVirtualizationEnabled=48,  _
    $ProcessConsoleHostProcess=49,          _
    $ProcessWindowInformation=50,           _
    $MaxProcessInfoClass=51

	
	
func ZwQueryInformationProcess($hProcessHandle,$picProcessInformationClass,$pvProcessInformation,$ulProcessInformationLength,$pulReturnLength) ;returns NTSTATUS
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms687420%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "long", "ZwQueryInformationProcess", "HANDLE", $hProcessHandle, "int", $picProcessInformationClass, "ptr", $pvProcessInformation, "ULONG", $ulProcessInformationLength, "ptr", $pulReturnLength)
endfunc
func GetCurrentProcess() ;returns HANDLE
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683179%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "HANDLE", "GetCurrentProcess")
endfunc
func GetCurrentProcessHandle() ;returns HANDLE
	return GetCurrentProcess()
endfunc
func GetCurrentProcessId() ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683180%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetCurrentProcessId")
endfunc
func GetActiveProcessorCount($wGroupNumber) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/dd405485%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetActiveProcessorCount", "WORD", $wGroupNumber)
endfunc
func GetActiveProcessorGroupCount() ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/dd405486%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetActiveProcessorGroupCount")
endfunc
func GetCommandLine() ;returns LPTSTR
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683156%28v=vs.85%29.aspx
	if (1==@AutoItX64) then
		return dllcall("kernel32.dll", "wstr", "GetCommandLine")
	else
		return dllcall("kernel32.dll", "str", "GetCommandLine")
	endif
endfunc
func GetCurrentProcessorNumber() ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683181%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetCurrentProcessorNumber")
endfunc
func GetCurrentProcessorNumberEx($pProcessorNumber) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683181%28v=vs.85%29.aspx
	dllcall("kernel32.dll", "none", "GetCurrentProcessorNumberEx", "ptr", $pProcessorNumber)
endfunc
func GetEnvironmentStrings() ;returns LPTCH
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683187%28v=vs.85%29.aspx
	if (1==@AutoItX64) then
		return dllcall("kernel32.dll", "wstr", "GetEnvironmentStrings")
	else
		return dllcall("kernel32.dll", "str", "GetEnvironmentStrings")
	endif
endfunc
func GetEnvironmentVariable($lpName, $lpBuffer, $dwnSize) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683188%28v=vs.85%29.aspx
	if (1==@AutoItX64) then
		return dllcall("kernel32.dll", "wstr", "GetEnvironmentVariable", "wstr", $lpName, "wstr", $lpBuffer, "DWORD", $dwnSize)
	else
		return dllcall("kernel32.dll", "str", "GetEnvironmentVariable", "wstr", $lpName, "wstr", $lpBuffer, "DWORD", $dwnSize)
	endif
endfunc
func GetExitCodeProcess($hProcess, $lpdwExitCode) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683189%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "BOOL", "GetExitCodeProcess", "HANDLE", $hProcess, "ptr", $lpdwExitCode)
endfunc

;LOGICAL_PROCESSOR_RELATIONSHIP
global const _ 
	$RelationProcessorCore=0, _
	$RelationNumaNode=1, _
	$RelationCache=2, _
	$RelationProcessorPackage=3, _
	$RelationGroup=4, _
	$RelationAll=0xffff

;PROCESSOR_CACHE_TYPE	
global const _ 
	$CacheUnified=0,_
	$CacheInstruction=1,_
	$CacheData=2,_
	$CacheTrace=3


global $SYSTEM_LOGICAL_PROCESSOR_INFORMATION_Flags=dllstructcreate("ULONG_PTR ProcessorMask;int Relationship;BYTE Flags") ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686694%28v=vs.85%29.aspx
global $SYSTEM_LOGICAL_PROCESSOR_INFORMATION_NodeNumber=dllstructcreate("ULONG_PTR ProcessorMask;int Relationship;DWORD NodeNumber") ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686694%28v=vs.85%29.aspx
global $SYSTEM_LOGICAL_PROCESSOR_INFORMATION_Cache=dllstructcreate("ULONG_PTR ProcessorMask;int Relationship;BYTE Level;BYTE Associativity;WORD LineSize;DWORD Size;int Type") ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686694%28v=vs.85%29.aspx
global $SYSTEM_LOGICAL_PROCESSOR_INFORMATION_Reserved=dllstructcreate("ULONG_PTR ProcessorMask;int Relationship;ULONGLONG Reserved[2]") ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686694%28v=vs.85%29.aspx
global $CACHE_DESCRIPTOR=dllstructcreate("BYTE Level;BYTE Associativity;WORD LineSize;DWORD Size;int Type") ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686694%28v=vs.85%29.aspx
func GetLogicalProcessorInformation($pBuffer, $pdwReturnLength) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683194%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "BOOL", "GetLogicalProcessorInformation", "ptr", $pBuffer, "ptr", $pdwReturnLength)
endfunc
func GetLogicalProcessorInformationEx($RelationshipType, $pBuffer) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/dd405488%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "BOOL", "GetLogicalProcessorInformationEx", "int", $RelationshipType, "ptr", $pBuffer)
endfunc
func GetMaximumProcessorCount($GroupNumber) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/dd405489%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetMaximumProcessorCount", "WORD", $GroupNumber)
endfunc
func GetMaximumProcessorGroupCount() ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/dd405490%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "WORD", "GetMaximumProcessorGroupCount")
endfunc
func GetProcessTimes($hProcess, $lpftCreationTime, $lpftExitTime, $lpftKernelTime, $lpftUserTime) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683223%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "WORD", "GetProcessTimes", "HANDLE", $hProcess, "ptr", $lpftCreationTime, "ptr", $lpftExitTime, "ptr", $lpftKernelTime, "ptr", $lpftUserTime)
endfunc
func GetProcessId($hProcess) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683215%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetProcessId", "HANDLE", $hProcess)
endfunc
global $MEMORY_PRIORITY_INFORMATION=dllstructcreate("ULONG MemoryPriority");http://msdn.microsoft.com/en-us/library/windows/desktop/hh448387%28v=vs.85%29.aspx

;http://msdn.microsoft.com/en-us/library/windows/desktop/hh448387%28v=vs.85%29.aspx
global const _ 
	$MEMORY_PRIORITY_VERY_LOW=1,_
	$MEMORY_PRIORITY_LOW=2,_
	$MEMORY_PRIORITY_MEDIUM=3,_
	$MEMORY_PRIORITY_BELOW_NORMAL=4,_
	$MEMORY_PRIORITY_NORMAL=5
func GetProcessInformation($hProcess, $ProcessInformationClass, $pProcessInformation, $dwProcessInformationSize) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/hh448381%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetProcessInformation", "HANDLE", $hProcess, "int", $ProcessInformationClass, "ptr", $pProcessInformation, "DWORD", $dwProcessInformationSize)
endfunc

global $IO_COUNTERS=dllstructcreate(ULONGLONG ReadOperationCount;ULONGLONG WriteOperationCount;ULONGLONG OtherOperationCount;ULONGLONG ReadTransferCount;ULONGLONG WriteTransferCount;ULONGLONG OtherTransferCount"); http://msdn.microsoft.com/en-us/library/windows/desktop/ms684125%28v=vs.85%29.aspx
	
func GetProcessIoCounters($hProcess, $lpIoCounters) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683218%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetProcessIoCounters", "HANDLE", $hProcess, "ptr", $lpIoCounters)
endfunc
func GetProcessVersion($dwProcessId) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683224%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetProcessVersion", "DWORD", $dwProcessId)
endfunc
func GetProcessWorkingSetSize($hProcess, $lpMinimumWorkingSetSize, $lpMaximumWorkingSetSize) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683226%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "BOOL", "GetProcessWorkingSetSize", "HANDLE", $hProcess, "ptr", $lpMinimumWorkingSetSize, "ptr", $lpMaximumWorkingSetSize)
endfunc
func GetProcessWorkingSetSizeEx($hProcess, $lpMinimumWorkingSetSize, $lpMaximumWorkingSetSize, $pdwFlags) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683227%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "BOOL", "GetProcessWorkingSetSizeEx", "HANDLE", $hProcess, "ptr", $lpMinimumWorkingSetSize, "ptr", $lpMaximumWorkingSetSize, "DWORD_PTR", $pdwFlags)
endfunc

global $SYSTEM_PROCESSOR_CYCLE_TIME_INFORMATION=dllstructcreate("UINT64 CycleTime");http://msdn.microsoft.com/en-us/library/windows/desktop/dd405497%28v=vs.85%29.aspx
func GetProcessorSystemCycleTime($usGroup, $pspctiBuffer, $pdwReturnedLength) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/dd405497%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "BOOL", "GetProcessorSystemCycleTime", "USHORT", $usGroup, "ptr", $pspctiBuffer, "ptr", $pdwReturnedLength)
endfunc

global $STARTUPINFO=dllstructcreate("DWORD cb;ptr lpReserved;ptr lpDesktop;ptr lpTitle;DWORD dwX;DWORD dwY;DWORD dwXSize;DWORD dwYSize;DWORD dwXCountChars;DWORD dwYCountChars;DWORD dwFillAttribute;DWORD dwFlags;WORD wShowWindow;WORD cbReserved2;ptr lpReserved2;HANDLE hStdInput;HANDLE hStdOutput;HANDLE hStdError");http://msdn.microsoft.com/en-us/library/windows/desktop/ms686331%28v=vs.85%29.aspx
func GetStartupInfo($lpStartupInfo) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683230%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "none", "GetStartupInfo", "ptr", $lpStartupInfo)
endfunc
func GetThreadId($hThread) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683233%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "GetThreadId", "HANDLE", $hThread)
endfunc
func GetThreadIdealProcessorEx($hThread, $lpIdealProcessor) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/dd405499%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "BOOL", "GetThreadIdealProcessorEx", "HANDLE", $hThread, "ptr", $lpIdealProcessor)
endfunc

;global const $ThreadMemoryPriority=
;func GetThreadInformation($hThread, $lpIdealProcessor, $ThreadInformationClass, $pThreadInformation, $dwThreadInformationSize) ;returns BOOL
;	;http://msdn.microsoft.com/en-us/library/windows/desktop/hh448382%28v=vs.85%29.aspx
;	return dllcall("kernel32.dll", "BOOL", "GetThreadInformation", "HANDLE", $hThread, "ptr", $lpIdealProcessor, "int", $ThreadInformationClass, "ptr", $pThreadInformation, "DWORD", $dwThreadInformationSize)
;endfunc

;func OpenProcess($dwDesiredAccess, $bInheritHandle, $dwProcessId) ;returns BOOL
;	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms684320%28v=vs.85%29.aspx
;	return dllcall("kernel32.dll", "BOOL", "OpenProcess", "DWORD", $dwDesiredAccess, "BOOL", $bInheritHandle, "DWORD", $dwProcessId)
;endfunc

;func Sleep($hThread, $lpIdealProcessor) ;returns BOOL
;	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686298%28v=vs.85%29.aspx
;   ; there is already a Sleep function in autoit
;	return dllcall("kernel32.dll", "BOOL", "Sleep", "HANDLE", $hThread, "ptr", $lpIdealProcessor)
;endfunc
func SleepEx($dwMilliseconds, $bAlertable) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686307%28v=vs.85%29.aspx
	return dllcall("kernel32.dll", "DWORD", "SleepEx", "DWORD", $dwMilliseconds, "BOOL", $bAlertable)
endfunc






























































