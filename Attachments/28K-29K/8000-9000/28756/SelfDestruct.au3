
; RUN-AFTER script
;.......script written by trancexx (trancexx at yahoo dot com)


If @AutoItX64 Then ; Check for te right interpretor
	ConsoleWriteError("! 32-bit only" & @CRLF)
	MsgBox(262192, "32-bit", "32-bit interpretor required!")
	Exit
EndIf

HotKeySet("{Esc}", "_Quit") ; ESC to quit if something goes wrong


; This is the part of the script that always goes at the top:
_CheckForSelfDestruction()


; Some code
If @Compiled Then
	MsgBox(64 + 262144, "Self destruction", "Executable will self destruct when you click OK")
Else
	MsgBox(64 + 262144, "Self destruction", "Script will self destruct when you click OK")
EndIf


; And then self destruct:
_SelfDestruct()
If @error Then
	MsgBox(64 + 262144, "Self destruction", "Error occurred.            " & @CRLF & "Error number is " & @error)
EndIf
; That's it. It was easy, right?



; FUNCTIONS:


Func _CheckForSelfDestruction()

	If UBound($CmdLine) > 1 Then ; checking for the specific command line parameters
		Local $iInstance = _NumInst($CmdLine[1]) ; is 'mother' still alive? Should be because I want to be able to check for errors from there!
		If $iInstance > 1 Then
			Opt("TrayIconHide", 1) ; not to show tray icon
			If FileDelete(@ScriptFullPath) Then Exit ; if not compiled this will work just fine
			_ProcessWaitClose($CmdLine[2]) ; wait for original module to exit
			If @error Then
				ProcessWaitClose($CmdLine[2]) ; built-in function is too demanding on CPU, will not use it's unless absolutely needed, like now.
			EndIf
			FileDelete(@ScriptFullPath) ; delete executable
			Exit
		EndIf
	EndIf

EndFunc   ;==>_CheckForSelfDestruction


Func _SelfDestruct()

	; Generate random string to uniquely identify the semaphore
	Local $sGUID_Instance = _GenerateGUID()
	If @error Then ; check for errors
		$sGUID_Instance = "Semaphore_" & Random(2 ^ 20, 2 ^ 30, 1) ; back-up scenario
	EndIf

	; Create Semaphore
	_NumInst($sGUID_Instance)
	If @error Then ; check for errors
		Return SetError(2, 0, 0) ; _NumInst function failed
	EndIf

	; Build a new AutoIt Interpreter out of e.g. cmd.exe
	Local $iNewPID = _RunAutoItFromMemory(@SystemDir & "\cmd.exe", ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '" ' & $sGUID_Instance & " " & @AutoItPID)
	If @error Then ; check for errors
		Return SetError(3, 0, 0) ; _RunAutoItFromMemory function failed
	EndIf

	; If all went well wait for the new interpreter to start interpreting and then return
	_WaitForAutoItInterpretor($sGUID_Instance)
	If @error Then ; check for errors
		Return SetError(4, 0, 0) ; _WaitForAutoItInterpretor function failed
	EndIf

	Return 1 ; All OK!

EndFunc   ;==>_SelfDestruct



Func _RunAutoItFromMemory($sImageName, $sCommandLine)

	#region 1. PREPROCESSING
	Local $hModule = FileOpen(@AutoItExe, 16)
	Local $bBinary = FileRead($hModule)
	FileClose($hModule)
	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)

	Local $pPointer = DllStructGetPtr($tInput)

	#region 2. CREATING NEW PROCESS
	; STARTUPINFO structure (actually all that really matters is allocaed space)
	Local $tSTARTUPINFO = DllStructCreate("dword  cbSize;" & _
			"ptr Reserved;" & _
			"ptr Desktop;" & _
			"ptr Title;" & _
			"dword X;" & _
			"dword Y;" & _
			"dword XSize;" & _
			"dword YSize;" & _
			"dword XCountChars;" & _
			"dword YCountChars;" & _
			"dword FillAttribute;" & _
			"dword Flags;" & _
			"ushort ShowWindow;" & _
			"ushort Reserved2;" & _
			"ptr Reserved2;" & _
			"ptr hStdInput;" & _
			"ptr hStdOutput;" & _
			"ptr hStdError")

	; This is much important. This structure will hold some very important data.
	Local $tPROCESS_INFORMATION = DllStructCreate("ptr Process;" & _
			"ptr Thread;" & _
			"dword ProcessId;" & _
			"dword ThreadId")

	; Create new process
	$aCall = DllCall("kernel32.dll", "int", "CreateProcessW", _
			"wstr", $sImageName, _
			"wstr", $sCommandLine, _
			"ptr", 0, _
			"ptr", 0, _
			"int", 0, _
			"dword", 4, _ ; CREATE_SUSPENDED ; <- this is essential
			"ptr", 0, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($tSTARTUPINFO), _
			"ptr", DllStructGetPtr($tPROCESS_INFORMATION))

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0) ; CreateProcess function or call to it failed
	EndIf

	; New process and thread handles:
	Local $hProcess = DllStructGetData($tPROCESS_INFORMATION, "Process")
	Local $hThread = DllStructGetData($tPROCESS_INFORMATION, "Thread")

	#region 3. FILL CONTEXT STRUCTURE
	; CONTEXT structure is what's really important here.
	Local $tCONTEXT = DllStructCreate("dword ContextFlags;" & _
			"dword Dr0;" & _
			"dword Dr1;" & _
			"dword Dr2;" & _
			"dword Dr3;" & _
			"dword Dr6;" & _
			"dword Dr7;" & _
			"dword ControlWord;" & _
			"dword StatusWord;" & _
			"dword TagWord;" & _
			"dword ErrorOffset;" & _
			"dword ErrorSelector;" & _
			"dword DataOffset;" & _
			"dword DataSelector;" & _
			"byte RegisterArea[80];" & _
			"dword Cr0NpxState;" & _
			"dword SegGs;" & _
			"dword SegFs;" & _
			"dword SegEs;" & _
			"dword SegDs;" & _
			"dword Edi;" & _
			"dword Esi;" & _
			"dword Ebx;" & _ ; pointer to PEB structure
			"dword Edx;" & _
			"dword Ecx;" & _
			"dword Eax;" & _ ; address of entry point
			"dword Ebp;" & _
			"dword Eip;" & _
			"dword SegCs;" & _
			"dword EFlags;" & _
			"dword Esp;" & _
			"dword SegSS")

	DllStructSetData($tCONTEXT, "ContextFlags", 0x10002) ; CONTEXT_INTEGER

	; Fill tCONTEXT structure:
	$aCall = DllCall("kernel32.dll", "int", "GetThreadContext", _
			"ptr", $hThread, _
			"ptr", DllStructGetPtr($tCONTEXT))

	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(2, 0, 0) ; GetThreadContext function or call to it failed
	EndIf

	#region 4. READ PE-FORMAT
	; Start processing passed binary data. 'Reading' PE format follows.
	Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];" & _
			"ushort BytesOnLastPage;" & _
			"ushort Pages;" & _
			"ushort Relocations;" & _
			"ushort SizeofHeader;" & _
			"ushort MinimumExtra;" & _
			"ushort MaximumExtra;" & _
			"ushort SS;" & _
			"ushort SP;" & _
			"ushort Checksum;" & _
			"ushort IP;" & _
			"ushort CS;" & _
			"ushort Relocation;" & _
			"ushort Overlay;" & _
			"char Reserved[8];" & _
			"ushort OEMIdentifier;" & _
			"ushort OEMInformation;" & _
			"char Reserved2[20];" & _
			"dword AddressOfNewExeHeader", _
			$pPointer)

	; Move pointer
	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader") ; move to PE file header

	Local $sMagic = DllStructGetData($tIMAGE_DOS_HEADER, "Magic")

	; Check if it's valid format
	If Not ($sMagic == "MZ") Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(3, 0, 0) ; MS-DOS header missing. Btw 'MZ' are the initials of Mark Zbikowski in case you didn't know.
	EndIf

	Local $tIMAGE_NT_SIGNATURE = DllStructCreate("dword Signature", $pPointer)

	; Move pointer
	$pPointer += 4 ; size of $tIMAGE_NT_SIGNATURE structure

	; Check signature
	If DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature") <> 17744 Then ; IMAGE_NT_SIGNATURE
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(4, 0, 0) ; wrong signature. For PE image should be "PE\0\0" or 17744 dword.
	EndIf

	Local $tIMAGE_FILE_HEADER = DllStructCreate("ushort Machine;" & _
			"ushort NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"ushort SizeOfOptionalHeader;" & _
			"ushort Characteristics", _
			$pPointer)

	; Get number of sections
	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")

	; Move pointer
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure

	Local $tIMAGE_OPTIONAL_HEADER = DllStructCreate("ushort Magic;" & _
			"ubyte MajorLinkerVersion;" & _
			"ubyte MinorLinkerVersion;" & _
			"dword SizeOfCode;" & _
			"dword SizeOfInitializedData;" & _
			"dword SizeOfUninitializedData;" & _
			"dword AddressOfEntryPoint;" & _
			"dword BaseOfCode;" & _
			"dword BaseOfData;" & _
			"dword ImageBase;" & _
			"dword SectionAlignment;" & _
			"dword FileAlignment;" & _
			"ushort MajorOperatingSystemVersion;" & _
			"ushort MinorOperatingSystemVersion;" & _
			"ushort MajorImageVersion;" & _
			"ushort MinorImageVersion;" & _
			"ushort MajorSubsystemVersion;" & _
			"ushort MinorSubsystemVersion;" & _
			"dword Win32VersionValue;" & _
			"dword SizeOfImage;" & _
			"dword SizeOfHeaders;" & _
			"dword CheckSum;" & _
			"ushort Subsystem;" & _
			"ushort DllCharacteristics;" & _
			"dword SizeOfStackReserve;" & _
			"dword SizeOfStackCommit;" & _
			"dword SizeOfHeapReserve;" & _
			"dword SizeOfHeapCommit;" & _
			"dword LoaderFlags;" & _
			"dword NumberOfRvaAndSizes", _
			$pPointer)

	; Move pointer
	$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER

	Local $iMagic = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "Magic")

	; Check if it's 32-bit application
	If $iMagic <> 267 Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(5, 0, 0) ; not 32-bit application. Structures (and sizes) are for 32-bit apps.
	EndIf

	; Extract entry point address
	Local $iEntryPointNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint") ; if loaded binary image would start executing at this address

	; Move pointer
	$pPointer += 128 ; size of the structures before IMAGE_SECTION_HEADER (16 of them - find PE specification if you are interested).

	Local $pOptionalHeaderImageBaseNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "ImageBase") ; address of the first byte of the image when it's loaded in memory
	Local $iOptionalHeaderSizeOfImageNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfImage") ; the size of the image including all headers

	#region 5. GET AND THEN CHANGE BASE ADDRESS
	; Read base address
	Local $tPEB = DllStructCreate("byte InheritedAddressSpace;" & _
			"byte ReadImageFileExecOptions;" & _
			"byte BeingDebugged;" & _
			"byte Spare;" & _
			"ptr Mutant;" & _
			"ptr ImageBaseAddress;" & _
			"ptr LoaderData;" & _
			"ptr ProcessParameters;" & _
			"ptr SubSystemData;" & _
			"ptr ProcessHeap;" & _
			"ptr FastPebLock;" & _
			"ptr FastPebLockRoutine;" & _
			"ptr FastPebUnlockRoutine;" & _
			"dword EnvironmentUpdateCount;" & _
			"ptr KernelCallbackTable;" & _
			"ptr EventLogSection;" & _
			"ptr EventLog;" & _
			"ptr FreeList;" & _
			"dword TlsExpansionCounter;" & _
			"ptr TlsBitmap;" & _
			"dword TlsBitmapBits[2];" & _
			"ptr ReadOnlySharedMemoryBase;" & _
			"ptr ReadOnlySharedMemoryHeap;" & _
			"ptr ReadOnlyStaticServerData;" & _
			"ptr AnsiCodePageData;" & _
			"ptr OemCodePageData;" & _
			"ptr UnicodeCaseTableData;" & _
			"dword NumberOfProcessors;" & _
			"dword NtGlobalFlag;" & _
			"ubyte Spare2[4];" & _
			"int64 CriticalSectionTimeout;" & _
			"dword HeapSegmentReserve;" & _
			"dword HeapSegmentCommit;" & _
			"dword HeapDeCommitTotalFreeThreshold;" & _
			"dword HeapDeCommitFreeBlockThreshold;" & _
			"dword NumberOfHeaps;" & _
			"dword MaximumNumberOfHeaps;" & _
			"ptr ProcessHeaps;" & _
			"ptr GdiSharedHandleTable;" & _
			"ptr ProcessStarterHelper;" & _
			"ptr GdiDCAttributeList;" & _
			"ptr LoaderLock;" & _
			"dword OSMajorVersion;" & _
			"dword OSMinorVersion;" & _
			"dword OSBuildNumber;" & _
			"dword OSPlatformId;" & _
			"dword ImageSubSystem;" & _
			"dword ImageSubSystemMajorVersion;" & _
			"dword ImageSubSystemMinorVersion;" & _
			"dword GdiHandleBuffer[34];" & _
			"dword PostProcessInitRoutine;" & _
			"dword TlsExpansionBitmap;" & _
			"ubyte TlsExpansionBitmapBits[128];" & _
			"dword SessionId")

	$aCall = DllCall("kernel32.dll", "int", "ReadProcessMemory", _
			"ptr", $hProcess, _
			"ptr", DllStructGetData($tCONTEXT, "Ebx"), _
			"ptr", DllStructGetPtr($tPEB), _
			"dword", DllStructGetSize($tPEB), _
			"dword*", 0)

	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(6, 0, 0) ; ReadProcessMemory function or call to it failed while filling PEB structure
	EndIf

	Local $hBaseAddress = DllStructGetData($tPEB, "ImageBaseAddress")

	; Shorter version of the step above is within comments below:
	#cs
		$aCall = DllCall("kernel32.dll", "int", "ReadProcessMemory", _
		"ptr", $hProcess, _
		"ptr", DllStructGetData($tCONTEXT, "Ebx") + 8, _
		"ptr*", 0, _
		"dword", 4, _
		"dword*", 0)
		
		If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(7, 0, 0) ; ReadProcessMemory function or call to it failed while reading base address of the process
		EndIf
		
		Local $hBaseAddress = $aCall[3]
	#ce

	; Write new base address
	$aCall = DllCall("kernel32.dll", "int", "WriteProcessMemory", _
			"ptr", $hProcess, _
			"ptr", DllStructGetData($tCONTEXT, "Ebx") + 8, _
			"ptr*", $pOptionalHeaderImageBaseNEW, _
			"dword", 4, _
			"dword*", 0)

	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(7, 0, 0) ; WriteProcessMemory function or call to it failed while writting new base address
	EndIf

	#region 6. CLEAR EVERYTHING THAT THIS NEW PROCESS HAVE MAPPED
	; Clear old data.
	$aCall = DllCall("ntdll.dll", "int", "NtUnmapViewOfSection", _
			"ptr", $hProcess, _
			"ptr", $hBaseAddress)

	If @error Or $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(8, 0, 0) ; NtUnmapViewOfSection function or call to it failed
	EndIf

	#region 7. ALLOCATE 'NEW' MEMORY SPACE
	; Allocate proper size of memory at the proper place.
	$aCall = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", _
			"ptr", $hProcess, _
			"ptr", $pOptionalHeaderImageBaseNEW, _
			"dword", $iOptionalHeaderSizeOfImageNEW, _
			"dword", 12288, _ ; MEM_COMMIT|MEM_RESERVE
			"dword", 64) ; PAGE_EXECUTE_READWRITE

	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(9, 0, 0) ; VirtualAllocEx function or call to it failed
	EndIf

	Local $pRemoteCode = $aCall[0] ; from now on this is zero-point

	#region 8. GET AND WRITE NEW PE-HEADERS
	Local $pHEADERS_NEW = DllStructGetPtr($tIMAGE_DOS_HEADER) ; starting address of binary image headers
	Local $iOptionalHeaderSizeOfHeadersNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfHeaders") ; the size of the MS-DOS stub, the PE header, and the section headers

	; Write NEW headers
	$aCall = DllCall("kernel32.dll", "int", "WriteProcessMemory", _
			"ptr", $hProcess, _
			"ptr", $pRemoteCode, _
			"ptr", $pHEADERS_NEW, _
			"dword", $iOptionalHeaderSizeOfHeadersNEW, _
			"dword*", 0)

	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(10, 0, 0) ; WriteProcessMemory function or call to it while writting new PE headers failed
	EndIf

	#region 9. WRITE SECTIONS
	; Dealing with sections. Will write them too as they hold all needed data that PE loader reads
	Local $tIMAGE_SECTION_HEADER
	Local $iSizeOfRawData, $pPointerToRawData
	Local $iVirtualAddress

	For $i = 1 To $iNumberOfSections

		$tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];" & _
				"dword UnionOfVirtualSizeAndPhysicalAddress;" & _
				"dword VirtualAddress;" & _
				"dword SizeOfRawData;" & _
				"dword PointerToRawData;" & _
				"dword PointerToRelocations;" & _
				"dword PointerToLinenumbers;" & _
				"ushort NumberOfRelocations;" & _
				"ushort NumberOfLinenumbers;" & _
				"dword Characteristics", _
				$pPointer)

		$iSizeOfRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")
		$pPointerToRawData = DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
		$iVirtualAddress = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualAddress")

		; If there is data to write, write it where is should be written
		If $iSizeOfRawData Then

			$aCall = DllCall("kernel32.dll", "int", "WriteProcessMemory", _
					"ptr", $hProcess, _
					"ptr", $pRemoteCode + $iVirtualAddress, _
					"ptr", $pPointerToRawData, _
					"dword", $iSizeOfRawData, _
					"dword*", 0)

			If @error Or Not $aCall[0] Then
				DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
				Return SetError(11, $i, 0) ; WriteProcessMemory function or call to it while writting new sections failed
			EndIf

		EndIf

		; Move pointer
		$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure

	Next

	#region 10. NEW ENTRY POINT
	; Entry point manipulation
	DllStructSetData($tCONTEXT, "Eax", $pRemoteCode + $iEntryPointNEW) ; $iEntryPointNEW was relative address

	#region 11. SET NEW CONTEXT
	; New context:
	$aCall = DllCall("kernel32.dll", "int", "SetThreadContext", _
			"ptr", $hThread, _
			"ptr", DllStructGetPtr($tCONTEXT))

	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(12, 0, 0) ; SetThreadContext function or call to it failed
	EndIf

	#region 12. RESUME THREAD
	; And that's it!. Continue execution
	$aCall = DllCall("kernel32.dll", "int", "ResumeThread", "ptr", $hThread)

	If @error Or $aCall[0] = -1 Then
		DllCall("kernel32.dll", "int", "TerminateProcess", "ptr", $hProcess, "dword", 0)
		Return SetError(13, 0, 0) ; ResumeThread function or call to it failed
	EndIf

	#region 13. RETURN SUCCESS
	; All went well. Return new PID:
	Return DllStructGetData($tPROCESS_INFORMATION, "ProcessId")

EndFunc   ;==>_RunAutoItFromMemory


Func _WaitForAutoItInterpretor($sSemaphoreName)

	Local $aCall = DllCall("kernel32.dll", "hwnd", "CreateSemaphoreW", _
			"ptr", 0, _
			"int", 1, _
			"int", 999, _
			"wstr", $sSemaphoreName)

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hSemaphore = $aCall[0]

	Local $iInstanceCurrent

	While 1

		$aCall = DllCall("kernel32.dll", "int", "ReleaseSemaphore", _
				"ptr", $hSemaphore, _
				"int", 1, _
				"int*", 0)

		If @error Or Not $aCall[0] Then
			Return SetError(2, 0, 0)
		EndIf

		$iInstanceCurrent = $aCall[3]

		If $iInstanceCurrent > 2 Then ExitLoop

		$aCall = DllCall("kernel32.dll", "dword", "WaitForSingleObject", _
				"hwnd", $hSemaphore, _
				"dword", 0)

		If @error Or $aCall[0] = -1 Then
			Return SetError(3, 0, 0)
		EndIf

		Sleep(100)

	WEnd

	Return 1

EndFunc   ;==>_WaitForAutoItInterpretor


Func _NumInst($sName)

	Local $aCall = DllCall("kernel32.dll", "ptr", "CreateSemaphoreW", _
			"ptr", 0, _
			"int", 1, _
			"int", 999, _
			"wstr", $sName)

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hSemaphore = $aCall[0]

	$aCall = DllCall("kernel32.dll", "int", "ReleaseSemaphore", _
			"ptr", $hSemaphore, _
			"int", 1, _
			"int*", 0)

	If @error Or Not $aCall[0] Then
		Return SetError(2, 0, 0)
	EndIf

	Local $iInstanceCurrent = $aCall[3]

	Return $iInstanceCurrent

EndFunc   ;==>_NumInst


Func _ProcessWaitClose($iPID)

	Local $aCall = DllCall("kernel32.dll", "ptr", "OpenProcess", _
			"dword", 0x001F0FFF, _ ; PROCESS_ALL_ACCESS
			"int", 0, _
			"dword", $iPID)

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hProcess = $aCall[0]

	$aCall = DllCall("kernel32.dll", "dword", "WaitForSingleObject", _
			"ptr", $hProcess, _
			"dword", -1)

	If @error Or $aCall[0] = -1 Then
		Return SetError(2, 0, 0)
	EndIf

	Return $aCall[0]

EndFunc   ;==>_ProcessWaitClose


Func _GenerateGUID()

	Local $GUIDSTRUCT = DllStructCreate("int;short;short;byte[8]")

	Local $aCall = DllCall("rpcrt4.dll", "int", "UuidCreate", "ptr", DllStructGetPtr($GUIDSTRUCT))

	If @error Or $aCall[0] Then
		Return SetError(1, 0, "")
	EndIf

	$aCall = DllCall("ole32.dll", "int", "StringFromGUID2", _
			"ptr", DllStructGetPtr($GUIDSTRUCT), _
			"wstr", "", _
			"int", 40)

	If @error Or Not $aCall[0] Then
		Return SetError(2, 0, "")
	EndIf

	Return SetError(0, 0, $aCall[2])

EndFunc   ;==>_GenerateGUID


Func _Quit()

	Exit

EndFunc   ;==>_Quit