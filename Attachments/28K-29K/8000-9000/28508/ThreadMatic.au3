; THREADMATIC
;.......script written by trancexx (trancexx at yahoo dot com)

Opt("GUICloseOnESC", 1)

; Check for the right interpreter
If @AutoItX64 Then
	ConsoleWriteError("! 32-bit only" & @CRLF)
	MsgBox(262192, "32-bit", "This is 32-bit script.")
	Exit
EndIf

; This is to clean the garbage 
_EmptyWorkingSet()

; GUI stuff
Global $hGui = GUICreate("Testing", 400, 400, Random(0, @DesktopWidth - 410, 1), Random(0, @DesktopHeight - 500, 1))

; Some labels
Global $hLabel1 = GUICtrlCreateLabel("Moving label", 0, 70, 140, 30)
GUICtrlSetFont($hLabel1, 16, 800)
GUICtrlSetColor($hLabel1, 0x0000CC)
Global $hLabel2 = GUICtrlCreateLabel("Moving label", 380, 300, 140, 30)
GUICtrlSetFont($hLabel2, 16, 800)
GUICtrlSetColor($hLabel2, 0x0000CC)

; Buttons
Global $hButtonKill = GUICtrlCreateButton("Kill this thread", 270, 190, 100, 30)
Global $hButtonMake = GUICtrlCreateButton("Make a new thread", 20, 150, 200, 30)
Global $hButtonMakeAndRun = GUICtrlCreateButton("Start over in new thread", 20, 220, 200, 30)

; For moving labels
Global $iX, $iMove

; Show it
GUISetState()
WinActivate($hGui)


; Loop till the end
While 1

	Switch GUIGetMsg()
		Case - 3
			Exit
		Case $hButtonMake
			_MakeNewThread()
			GUICtrlSetState($hButtonMake, 128)
			GUICtrlSetState($hButtonMakeAndRun, 128)
		Case $hButtonMakeAndRun
			_StartOverInNewThread()
		Case $hButtonKill
			MsgBox(262144, "Exit thread", "You are about to kill this thread." & @CRLF & _
					"If this is the first one (original) then the internal AutoIt's handler will 'try' to figure what happened and will wait fof 5-6-10 sec (counter already started counting) before it decides to exit." & @CRLF & _
					"Otherwise you will exit immediately if timer was out before. That is unless you made a new thread before you clicked 'Kill this thread' button. " & _
					"In that case execution will start again in that new thread.", 0, $hGui)
			DllCall("kernel32.dll", "int", "ExitThread", "dword", 0)
	EndSwitch

	If Mod(@MSEC, 5) Then ; clumsy, but who cares
		If Not $iMove Then
			$iMove = 1
		EndIf
	Else
		If $iMove Then
			GUICtrlSetPos($hLabel1, $iX, 70)
			GUICtrlSetPos($hLabel2, 380 - 2 * $iX, 300)
			$iX += 1
			If $iX = 250 Then $iX = 0
			$iMove = 0
		EndIf
	EndIf

WEnd





; FUNCTIONS


Func _StartOverInNewThread()

	; Get entry point address of 'me'
	Local $pEntryPoint = _GetAddressOfEntryPoint()
    If @error Then
	    Return SetError(1, 0, 0) ; Couldn't get address of entry point
    EndIf

	; Get 'this' thread
	Local $aCall = DllCall("kernel32.dll", "ptr", "GetCurrentThread")
	If @error Or Not $aCall[0] Then
		Return SetError(2, 0, 0) ; GetCurrentThread function or call to it failed
	EndIf

	Local $hCurrentThread = $aCall[0] ; pseudohandle is returned

	; Get TID from wich to determine the real thread handle. (There are other ways of doing this)
	$aCall = DllCall("kernel32.dll", "dword", "GetThreadId", "ptr", $hCurrentThread)

	Local $hThreadID = $aCall[0]

	$aCall = DllCall("kernel32.dll", "ptr", "OpenThread", _
			"dword", 0x001F03FF, _  ; THREAD_ALL_ACCESS
			"int", 1, _
			"dword", $hThreadID)

	If @error Or Not $aCall[0] Then
		Return SetError(3, 0, 0) ; OpenThread function or call to it failed
	EndIf

	Local $hThread = $aCall[0] ; real handle

	; Make a correction
	$hCurrentThread = $hThread

	; What follows was described many times before. Will generate 'assembly on the fly'. Dynamic set of processor instructions.
	; Get handle of kernel32.dll. This dll holds needed functions.
	$aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "kernel32.dll")

	If @error Or Not $aCall[0] Then
		Return SetError(4, 0, 0) ; GetModuleHandleW function or call to it failed
	EndIf

	Local $hHandle = $aCall[0] ; wanted handle

	; Get address of WaitForSingleObject function
	$aCall = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
			"ptr", $hHandle, _
			"str", "WaitForSingleObject")

	If @error Or Not $aCall[0] Then
		Return SetError(5, 0, 0) ; GetProcAddress function or call to it failed
	EndIf

	Local $pWaitForSingleObject = $aCall[0] ; that's the one

	; Allocate enough memory with PAGE_EXECUTE_READWRITE
	$aCall = DllCall("kernel32.dll", "ptr", "VirtualAlloc", _
			"ptr", 0, _
			"dword", 25, _
			"dword", 4096, _ ; MEM_COMMIT
			"dword", 64) ; PAGE_EXECUTE_READWRITE

	If @error Or Not $aCall[0] Then
		Return SetError(6, 0, 0) ; VirtualAlloc function or call to it failed
	EndIf

	Local $pExecutableCode = $aCall[0] ; pointer to allocated memory

	; Allocate memory in  'our way' in reserved space:
	Local $tCodeBuffer = DllStructCreate("byte[25]", $pExecutableCode)

	; Write code:
	DllStructSetData($tCodeBuffer, 1, _
			"0x" & _
			"68" & SwapEndian(2147483647) & _                          ; push INFINITE
			"68" & SwapEndian($hCurrentThread) & _                     ; push current thread handle
			"B8" & SwapEndian($pWaitForSingleObject) & _               ; mov eax, [$pWaitForSingleObject]
			"FFD0" & _                                                 ; call eax
			"B8" & SwapEndian($pEntryPoint) & _                        ; mov eax, [$pEntryPoint]
			"FFD0" & _                                                 ; call eax
			"C3" _                                                     ; ret
			)

	; Create thread to execute code in:
	$aCall = DllCall("kernel32.dll", "ptr", "CreateThread", _
			"ptr", 0, _
			"dword", 0, _
			"ptr", $pExecutableCode, _
			"ptr", 0, _
			"dword", 0, _
			"dword*", 0)

	If @error Or Not $aCall[0] Then
		Return SetError(7, 0, 0) ; CreateThread function or call to it failed
	EndIf

	; Since all went well exit this thread that we are in currently:
	DllCall("kernel32.dll", "int", "ExitThread", "dword", 0)
	
	; Should never be here!
	If @error Or Not $aCall[0] Then
		Return SetError(8, 0, 0) ; ExitThread function or call to it failed
	EndIf

EndFunc   ;==>_StartOverInNewThread


Func _MakeNewThread() ; this function is the same as _StartOverInNewThread(), only on sucess returns new thread handle without closing current.

	Local $pEntryPoint = _GetAddressOfEntryPoint()
    If @error Then
	    Return SetError(1, 0, 0) ; Couldn't get address of entry point
    EndIf
	
	Local $aCall = DllCall("kernel32.dll", "ptr", "GetCurrentThread")
	If @error Or Not $aCall[0] Then
		Return SetError(2, 0, 0) ; GetCurrentThread function or call to it failed
	EndIf

	Local $hCurrentThread = $aCall[0] ; pseudohandle

	$aCall = DllCall("kernel32.dll", "dword", "GetThreadId", "ptr", $hCurrentThread)

	Local $hThreadID = $aCall[0]

	$aCall = DllCall("kernel32.dll", "ptr", "OpenThread", _
			"dword", 0x001F03FF, _  ; THREAD_ALL_ACCESS
			"int", 1, _
			"dword", $hThreadID)

	If @error Or Not $aCall[0] Then
		Return SetError(3, 0, 0) ; OpenThread function or call to it failed
	EndIf

	Local $hThread = $aCall[0] ; real handle

	$hCurrentThread = $hThread

	$aCall = DllCall("kernel32.dll", "ptr", "GetModuleHandleW", "wstr", "kernel32.dll")

	If @error Or Not $aCall[0] Then
		Return SetError(4, 0, 0) ; GetModuleHandleW function or call to it failed
	EndIf

	Local $hHandle = $aCall[0]

	$aCall = DllCall("kernel32.dll", "ptr", "GetProcAddress", _
			"ptr", $hHandle, _
			"str", "WaitForSingleObject")

	If @error Or Not $aCall[0] Then
		Return SetError(5, 0, 0) ; GetProcAddress function or call to it failed
	EndIf

	Local $pWaitForSingleObject = $aCall[0]

	$aCall = DllCall("kernel32.dll", "ptr", "VirtualAlloc", _
			"ptr", 0, _
			"dword", 25, _
			"dword", 4096, _ ; MEM_COMMIT
			"dword", 64) ; PAGE_EXECUTE_READWRITE

	If @error Or Not $aCall[0] Then
		Return SetError(6, 0, 0) ; VirtualAlloc function or call to it failed
	EndIf

	Local $pExecutableCode = $aCall[0]

	Local $tCodeBuffer = DllStructCreate("byte[25]", $pExecutableCode)

	DllStructSetData($tCodeBuffer, 1, _
			"0x" & _
			"68" & SwapEndian(2147483647) & _                          ; push INFINITE
			"68" & SwapEndian($hCurrentThread) & _                     ; push current thread handle
			"B8" & SwapEndian($pWaitForSingleObject) & _               ; mov eax, [$pWaitForSingleObject]
			"FFD0" & _                                                 ; call eax
			"B8" & SwapEndian($pEntryPoint) & _                             ; mov eax, [$pEntryPoint]
			"FFD0" & _                                                 ; call eax
			"C3" _                                                     ; ret
			)

	$aCall = DllCall("kernel32.dll", "ptr", "CreateThread", _
			"ptr", 0, _
			"dword", 0, _
			"ptr", $pExecutableCode, _
			"ptr", 0, _
			"dword", 0, _
			"dword*", 0)

	If @error Or Not $aCall[0] Then
		Return SetError(7, 0, 0) ; CreateThread function or call to it failed
	EndIf

	Local $hThreadNew = $aCall[0]

	Return $hThreadNew

EndFunc   ;==>_MakeNewThread


Func _GetAddressOfEntryPoint()

	Local $aCall = DllCall("Kernel32.dll", "ptr", "GetModuleHandleW", "ptr", 0)
    If @error Then
	    Return SetError(1, 0, 0) ; GetModuleHandleW function or call to it failed
    EndIf 
	
	Local $pPointer = $aCall[0] ; pointer we get

	; Construct IMAGE_DOS_HEADER structure
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

	; Move pointer by extracted AddressOfNewExeHeader
	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader") ; move to PE file header

	; Move pointer more (find some other scripts I wrote on the subject)
	$pPointer += 4 ; size of $tIMAGE_NT_SIGNATURE structure

	; Move pointer (same remark)
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure

	; In place of IMAGE_OPTIONAL_HEADER
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

	; Extract entry point address
	Local $iEntryPoint = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint") ; if loaded binary image would start executing at this address

	; Return findings
	Return DllStructGetPtr($tIMAGE_DOS_HEADER) + $iEntryPoint

EndFunc   ;==>_GetAddressOfEntryPoint


Func SwapEndian($iValue)
	Return Hex(BinaryMid($iValue, 1, 4))
EndFunc   ;==>SwapEndian


Func _EmptyWorkingSet()

	Local $aCall = DllCall("kernel32.dll", "ptr", "GetCurrentProcess")

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hProcess = $aCall[0]

	DllCall("psapi.dll", "int", "EmptyWorkingSet", "hwnd", $hProcess)

	If @error Then
		DllCall("kernel32.dll", "int", "K32EmptyWorkingSet", "hwnd", $hProcess)
	EndIf

EndFunc   ;==>_EmptyWorkingSet



Func OnAutoItExit()

	;This is very very (very!) important
	DllCall("kernel32.dll", "none", "ExitProcess", "dword", 0)

EndFunc   ;==>OnAutoItExit