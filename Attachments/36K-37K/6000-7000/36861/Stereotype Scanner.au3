#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include-once

Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $hWINTRST = DllOpen("Wintrust.dll")

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetProbability
; Description ...: Checks for the stereotypical file asociation based on imported functions and section names.
; Syntax ........: _GetProbability($File)
; Parameters ....: $File                - A string containing the file location.
; Return values .: String containing the file description based on a stereotypical  API import analysis and sets the @Extended
;						macro to the amount of hits made searching for the stereotype.
;						If errors occure, the error level is set to either 1 or 2.
;					@Error
;						1 - File not Found
;						2 - both calls to _PEInfo() failed.
; Author ........: THAT1ANONYMOUSDUDE
; Modified ......:
; Remarks .......: The
; Related .......: None
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _GetProbability($File)
	If Not FileExists($File) Then Return SetError(1, 0, 0)

	Local $API_IMP = True
	Local $SEC_NME = True
	Local $Packer = False
	Local $Strikes = 0
	Local $Probability = 0

	; A lot of legit applications can/will get
	; flagged in the checks below, and some apps
	; even have a shi** ton of imports, so we will
	; attempt to skip some apps that are digitally
	; signed to avoid wasting time since we're not a real av anyway
	Wintrust($File)
	If Not @error Then
		; check if the PE is signed
		; only third part PEs work here
		; Microsoft PEs don't work
		$API_IMP = False
		$SEC_NME = False
		$Packer = "SIGNED APPLICATION"
		$Probability += 10
		; If it has a valid signature, than maybe its a trustable PE
	Else
		; If the ass hole who made it didn't sign it, then
		; its probably modified or the maker didn't bother to
		; fork out the cash for a cert, commence our
		; noob level investigation using code developed
		; by the hyper inteligent alien hybrid aka trancexx :D
		Local $HeaderSections = _PEInfo($File, 1)
		If @error Then $SEC_NME = False

		Local $Imports = _PEInfo($File)
		If @error Then $API_IMP = False

		If Not $API_IMP And Not $SEC_NME Then Return SetError(2, 0, 0)
	EndIf

	If $SEC_NME Then
		For $X = 1 To UBound($HeaderSections) - 1
			;MsgBox(0, "Section Names", $HeaderSections[$X])
			Select
				Case StringInStr($HeaderSections[$X], "upx", 2)
					$Packer = "UPX"
					$Probability = +1

				Case StringInStr($HeaderSections[$X], "XCompw", 2)
					$Packer = "XCompw"
					$Probability = +1

				Case StringInStr($HeaderSections[$X], "XPackw", 2)
					$Packer = "XPackw"
					$Probability = +1

				Case StringInStr($HeaderSections[$X], "BJFnt", 2)
					$Packer = "BJFnt"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "PELOCKnt", 2)
					$Packer = "PELOCKnt"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "PCGW32", 2)
					$Packer = "PCGW32"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "wwpack", 2)
					$Packer = "wwpack"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "RLPack", 2)
					$Packer = "RLPack"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "exe32pack", 2)
					$Packer = "exe32pack"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "ASPack", 2)
					$Packer = "ASPack"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "PECompact", 2)
					$Packer = "PECompact"
					$Probability += 1

				Case StringInStr($HeaderSections[$X], "MPress", 2)
					$Packer = "MPress"
					$Probability += 1
			EndSelect
		Next
	EndIf

	If $API_IMP Then

		Local $Ubound

		For $X = 0 To UBound($Imports) - 1
			; telock has an option to add a bunch of fake compressor signatures
			; but the bastard who created it didn't count on being able to detect it based on its imports
			; which are ALWAYS GetModuleHandleA from kernel32 and MessageBoxA from user32
			; which appaers to be unique compared to all the others I've fiddled with
			If StringInStr($Imports[$X][0][0], "kernel32.dll", 2) Or StringInStr($Imports[$X][0][0], "user32.dll", 2) Then
				; Only fall through if we're in the kernel32 and user32 imports are of the array
				If $Imports[$X][1][0] < 2 Then
					; telock seems to be very good at always hiding all imports
					; In this area, we will only fall through if there is only one imported function from
					; either kernel32 or user32, if it has more then this is not telock
					If StringInStr($Imports[$X][1][1], "GetModuleHandleA", 2) Or StringInStr($Imports[$X][1][1], "MessageBoxA", 2) Then
						; In telock. the imports are always the first in the array so we don't need to go through everything in it at this point
						$Strikes += 1
						$Probability += 1
						If $Strikes > 1 And Not $Packer Then
							$Packer = "telock"
						EndIf
					EndIf
				EndIf
			EndIf
		Next

		If Not $Probability Then
			; If nothing has been detected, then lets see if it's packed with WInIpackE
			; based on it's stubs imports.
			$Ubound = UBound($Imports)
			; If it has more imported functions from more than
			; 4 moduals, this is most likely not WInUpackE packed.
			For $X = 1 To $Ubound - 1
				If StringInStr($Imports[$X][0][0], "kernel32.dll", 2) Then
					; Again, we're only interested in the imported functions from kernel32
					If $Imports[$X][1][0] < 3 Then
						; Fall through only if there are less than 3 imports from kernel32
						; and check if they match the ones from a version of WInUpackE
						For $Z = 1 To UBound($Imports, 3) - 1
							If StringInStr($Imports[$X][1][$Z], "LoadLibraryA", 2) Or StringInStr($Imports[$X][1][$Z], "GetProcAddress", 2) Then
								; the two main imports of this bastard seem to be here
								; not even procexplorer detects this type of packed PE
								; but again take note that unpacked files may/will get
								; caught in this function and the ones below...
								$Strikes += 1
								$Probability += 3
								If $Strikes < 2 And Not $Packer Then
									$Packer = "WInUpackE"
								EndIf
							EndIf
						Next
					EndIf

				EndIf
			Next

		EndIf

		If Not $Packer Then
			$Strikes = 0
			; This is where I get really desperate and attempt to see if I
			; can get enough hits to determin if it's packed, read on...
			$Ubound = UBound($Imports)
			If $Ubound < 15 And (FileGetSize($File) / 1024) > 4.50 Then
				; Looking good, if we get here that means not to many moduals are  used and
				; the file is larger than 4.50 Kb, possibly meaning we are dealing with a stub
				; that is unpacking the original PE file and hiding its imports.
				For $X = 1 To $Ubound - 1
					If StringInStr($Imports[$X][0][0], "kernel32.dll", 2) Then
						;Again, only interested in imports from kernel32
						If $Imports[$X][1][0] > 1 And $Imports[$X][1][0] < 7 Then
							; Falling through this area means the file may possibly be packed
							; and originally imported functions may be masked by the packer
							; which is using only some basic API necessary to run the packed PE
							For $Z = 1 To UBound($Imports, 3) - 1
								If StringInStr($Imports[$X][1][$Z], "GetModuleHandleA", 2) Or _
										StringInStr($Imports[$X][1][$Z], "GetProcAddress", 2) Or _
										StringInStr($Imports[$X][1][$Z], "VirtualProtect", 2) Or _
										StringInStr($Imports[$X][1][$Z], "VirtualAlloc", 2) Or _
										StringInStr($Imports[$X][1][$Z], "VirtualFree", 2) Or _
										StringInStr($Imports[$X][1][$Z], "LoadLibraryA", 2) Then

									$Strikes += 1
									$Probability += 3
									If $Strikes > 2 And Not $Packer Then
										; Getting here after having very few kernel32 imports must mean this
										; file is packed, why else would such few imports be these functions
										; if not a packer stub???
										$Packer = "PACKED"
									ElseIf $Strikes > 2 And $Packer Then
										$Probability -= 2
									EndIf
								EndIf
							Next
						EndIf
					EndIf
				Next
			EndIf
		EndIf

		If Not $Packer Then
			; Then lets search for a UPX packed PE if someone removed it's header signature
			$Strikes = 0
			$Probability = 0
			$Ubound = UBound($Imports)
			If $Ubound < 20 Then
				; UPX doesn't seem to hide all the imported functions like most other packers
				For $X = 1 To $Ubound - 1
					If StringInStr($Imports[$X][0][0], "kernel32.dll", 2) Then
						;Again, only interested in imports from kernel32, because UPX does seem to hide at least
						; the imports from kernel32 ant not others for some reason
						If (UBound($Imports, 3) - 1) > 5 And (UBound($Imports, 3) - 1) < 10 Then
							; Falling through this area means the file may possibly be packed
							; and originally imported functions may be masked by the packer
							; which is using only some basic API necessary to run the packed PE
							For $Z = 1 To UBound($Imports, 3) - 1
								If StringInStr($Imports[$X][1][$Z], "GetModuleHandleA", 2) Or _
										StringInStr($Imports[$X][1][$Z], "GetProcAddress", 2) Or _
										StringInStr($Imports[$X][1][$Z], "VirtualProtect", 2) Or _
										StringInStr($Imports[$X][1][$Z], "VirtualAlloc", 2) Or _
										StringInStr($Imports[$X][1][$Z], "VirtualFree", 2) Or _
										StringInStr($Imports[$X][1][$Z], "LoadLibraryA", 2) Then

									$Strikes += 1
									$Probability += 3
									If $Strikes > 2 And Not $Packer Then
										; Getting here after having very few kernel32 imports must mean this
										; file is packed, why else would such few imports be these functions
										; if not a packer stub???
										$Packer = "UPX"
									ElseIf $Strikes > 2 And $Packer Then
										$Probability -= 2
									EndIf
								EndIf
							Next
						EndIf
					EndIf
				Next
			EndIf
		EndIf

		If Not $Packer And Not $Probability Then
			; Nothing detected, lets see if this is some kind of dev tool, script interpreter, hacktool or debugger etc
			$Ubound = UBound($Imports)
			For $X = 1 To $Ubound - 1
				If StringInStr($Imports[$X][0][0], "kernel32.dll", 2) Then
					For $Z = 1 To UBound($Imports, 3) - 1
						If StringInStr($Imports[$X][1][$Z], "OpenProcess", 2) Or _
								StringInStr($Imports[$X][1][$Z], "ReadProcessMemory", 2) Or _
								StringInStr($Imports[$X][1][$Z], "EnterCriticalSection", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetCurrentThreadId", 2) Or _
								StringInStr($Imports[$X][1][$Z], "ReadProcessMemory", 2) Or _
								StringInStr($Imports[$X][1][$Z], "SetThreadContext", 2) Or _
								StringInStr($Imports[$X][1][$Z], "VirtualAllocEx", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetProcAddress", 2) Or _
								StringInStr($Imports[$X][1][$Z], "WriteProcessMemory", 2) Then
							$Strikes += 1
							$Probability += 1
							If $Strikes > 4 Then
								$Packer = "HACK TOOL"
							EndIf
						EndIf
					Next
				EndIf
			Next
		EndIf

		If Not $Packer And (FileGetSize($File) / 1024) < 50 Then
			$Probability = 0
			$Ubound = UBound($Imports)
			For $X = 0 To $Ubound - 1
				If StringInStr($Imports[$X][0][0], "kernel32.dll", 2) Or StringInStr($Imports[$X][0][0], "user32.dll", 2) Then

					For $Z = 1 To UBound($Imports, 3) - 1
						If StringInStr($Imports[$X][1][$Z], "SetWindowsHook", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetWindowThreadProcessId", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetWindowTextA", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetKeyboardState", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetKeyState", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetModuleFileNameA", 2) Or _
								StringInStr($Imports[$X][1][$Z], "GetUserName", 2) Or _
								StringInStr($Imports[$X][1][$Z], "CreateToolhelp32Snapshot", 2) Then
							$Strikes += 1
							$Probability += 1
							If $Strikes > 5 Then
								; we have ourselves a keylogger :D
								; or possibly a game of some kind
								$Packer = "KEYLOGGER"
							EndIf
						EndIf
					Next
				EndIf
			Next
		EndIf
	EndIf

	If Not $Packer And $Probability < 2 Then
		$Strikes = 0
		; Nothing detected again, lets see if this is some kind of possibly malicious application
		; or is just capable of being malicious..
		$Ubound = UBound($Imports)
		For $X = 0 To $Ubound - 1
			If StringInStr($Imports[$X][0][0], "kernel32.dll", 2) Or StringInStr($Imports[$X][0][0], "advapi32.dll", 2) Then
				; this time we will even check imports from advapi.dll along with kernel32 imports
				For $Z = 1 To UBound($Imports, 3) - 1
					If StringInStr($Imports[$X][1][$Z], "DeleteCriticalSection", 2) Or _
							StringInStr($Imports[$X][1][$Z], "EnterCriticalSection", 2) Or _
							StringInStr($Imports[$X][1][$Z], "GetCurrentThreadId", 2) Or _
							StringInStr($Imports[$X][1][$Z], "TerminateProcess", 2) Or _
							StringInStr($Imports[$X][1][$Z], "CreateToolhelp32Snapshot", 2) Or _
							StringInStr($Imports[$X][1][$Z], "SetFileTime", 2) Or _
							StringInStr($Imports[$X][1][$Z], "GetFileAttributes", 2) Or _
							StringInStr($Imports[$X][1][$Z], "TerminateThread", 2) Or _; Below are advapi functions
							StringInStr($Imports[$X][1][$Z], "DeviceIoControl", 2) Or _
							StringInStr($Imports[$X][1][$Z], "OpenProcessToken", 2) Or _
							StringInStr($Imports[$X][1][$Z], "LookupPrivilegeValue", 2) Or _
							StringInStr($Imports[$X][1][$Z], "OpenThreadToken", 2) Or _
							StringInStr($Imports[$X][1][$Z], "OpenSCManager", 2) Or _
							StringInStr($Imports[$X][1][$Z], "SetSecurityDescriptorDacl", 2) Or _
							StringInStr($Imports[$X][1][$Z], "GetTokenInformation", 2) Or _
							StringInStr($Imports[$X][1][$Z], "GetSecurityDescriptorDacl", 2) Or _
							StringInStr($Imports[$X][1][$Z], "GetAclInformation", 2) Then
						;MsgBox(0, "$Imports[$X][1][$Z]", $Imports[$X][1][$Z])
						$Strikes += 1
						$Probability += 1
						If $Strikes > 4 Then
							; If the ass hole who made it didn't sign it, then
							; its probably modified or the maker didn't bother to
							; fork out the cash for a cert
							$Packer = "POSSIBLY MALICIOUS"
						EndIf
					EndIf
				Next
			EndIf
		Next
	EndIf

	Return SetError(-1, $Probability, $Packer)
EndFunc   ;==>_GetProbability


; #FUNCTION# ====================================================================================================================
; Name ..........: _PEInfo
; Description ...:
; Syntax ........: _PEInfo($sModule[, $TypeInfo = 0])
; Parameters ....: $sModule             - A string value containing path to a PE file.
;                  $TypeInfo            - [optional] Returns array containing specified information.
;												Parameter 1 returns 3 dimensional array of imported functions found.
;													$Imports[0][0][0] - number of modulas detected
;													$Imports[n][0][0] - n modual name
;													$Imports[n][n][0] - n modual imports
;													$Imports[n][n][n] - n modual imported function name
;												Parameter 2 returns one dimensional array containing header section names.
;														Use ubound() to get item count.
; Return values .: An array depending on information requested via possible parameters. If failure occured, @error is
;						set to a positive value, check @error before using the array to avoid autoit error.
; Author ........: Trancexx
; Modified ......: THAT1ANONYMOUSDUDE
; Remarks .......: This is Trancexxs work originally taken from IATManipulate.au3, I just took out what I needed for this script.
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/85618-reshacker-project/page__view__findpost__p__724332
; Example .......: Depends on you.
; ===============================================================================================================================

Func _PEInfo($sModule, $TypeInfo = 0)

	DllCall($hKERNEL32, "dword", "SetErrorMode", "dword", 1) ; SEM_FAILCRITICALERRORS ; will handle errors

	Local $iLoaded
	Local $a_hCall = DllCall($hKERNEL32, "hwnd", "GetModuleHandleW", "wstr", $sModule)

	If @error Then
		Return SetError(1, 0, "")
	EndIf

	Local $pPointer = $a_hCall[0]

	If Not $a_hCall[0] Then
		$a_hCall = DllCall($hKERNEL32, "hwnd", "LoadLibraryExW", "wstr", $sModule, "hwnd", 0, "int", 1) ; DONT_RESOLVE_DLL_REFERENCES
		If @error Or Not $a_hCall[0] Then
			$a_hCall = DllCall($hKERNEL32, "hwnd", "LoadLibraryExW", "wstr", $sModule, "hwnd", 0, "int", 34) ; LOAD_LIBRARY_AS_IMAGE_RESOURCE|LOAD_LIBRARY_AS_DATAFILE

			If @error Or Not $a_hCall[0] Then
				Return SetError(2, 0, "")
			EndIf
			$iLoaded = 1
			$pPointer = $a_hCall[0] - 1
		Else
			$iLoaded = 1
			$pPointer = $a_hCall[0]
		EndIf

	EndIf

	Local $hModule = $a_hCall[0]

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

	Local $sMagic = DllStructGetData($tIMAGE_DOS_HEADER, "Magic")

	If Not ($sMagic == "MZ") Then
		If $iLoaded Then
			Local $a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
			If @error Or Not $a_iCall[0] Then
				Return SetError(5, 0, "")
			EndIf
		EndIf
		Return SetError(3, 0, "")
	EndIf

	Local $iAddressOfNewExeHeader = DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader")

	$pPointer += $iAddressOfNewExeHeader ; start of PE file header

	Local $tIMAGE_NT_SIGNATURE = DllStructCreate("dword Signature", $pPointer) ; IMAGE_NT_SIGNATURE = 17744

	If DllStructGetData($tIMAGE_NT_SIGNATURE, "Signature") <> 17744 Then
		If $iLoaded Then
			$a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
			If @error Or Not $a_iCall[0] Then
				Return SetError(5, 0, "")
			EndIf
		EndIf
		Return SetError(4, 0, "")
	EndIf

	$pPointer += 4 ; size of $tIMAGE_NT_SIGNATURE structure
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

	Local $iMagic = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "Magic")

	If $iMagic <> 267 Then
		If $iLoaded Then
			$a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
			If @error Or Not $a_iCall[0] Then
				Return SetError(5, 0, "")
			EndIf
		EndIf
		Return SetError(0, 1, 1) ; not 32-bit application. Structures are for 32-bit
	EndIf

	$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER structure

	Switch $TypeInfo
		Case 0
			Local $i, $j, $k, $MaxLen = 0, $MaxLenOld = 0
			Local $IMFA[1][1][1]

			$pPointer += 8

			; Import Directory
			Local $tIMAGE_DIRECTORY_ENTRY_IMPORT = DllStructCreate("dword VirtualAddress;" & _
					"dword Size", _
					$pPointer)

			; Virtual address of IAT
			Local $iImportDirectoryVirtAddress = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "VirtualAddress")

			If $iImportDirectoryVirtAddress And DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "Size") Then ; if valid

				Local $tIMAGE_IMPORT_MODULE_DIRECTORY

				Local $iOffset, $iOffset2, $tModuleName, $iBufferOffset, $sModuleName, $iInitialOffset, $tBufferOffset, $tBuffer, $sFunctionName

				;Local $iModuleNameOffset
				;Local $iModuleNameLength ; for modules
				;Local $iFunctionNameOffset, $iFunctionNameLength ; for functions

				While 1

					$i += 1

					$tIMAGE_IMPORT_MODULE_DIRECTORY = DllStructCreate("dword RVAOriginalFirstThunk;" & _ ; actually union
							"dword TimeDateStamp;" & _
							"dword ForwarderChain;" & _
							"dword RVAModuleName;" & _
							"dword RVAFirstThunk", _
							DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "VirtualAddress") + $iOffset)

					If Not DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk") Then ; the end
						ExitLoop
					EndIf

					If DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk") Then
						$iInitialOffset = DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk")
					Else
						$iInitialOffset = DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk")
					EndIf

					$tModuleName = DllStructCreate("char[64]", DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName"))
					$sModuleName = DllStructGetData($tModuleName, 1)

					; Two important info I collect now
					; Get offset of the name of the module which holds the functions.
					;$iModuleNameOffset = DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName")
					; Get length of the module name
					;$iModuleNameLength = StringLen($sModuleName)

					ReDim $IMFA[$i + 1][2][UBound($IMFA, 3) + 1]
					$IMFA[$i][0][0] = $sModuleName

					$iOffset2 = 0
					$j = 0

					While 1

						$j += 1
						$tBufferOffset = DllStructCreate("dword", $iInitialOffset + $iOffset2)

						$iBufferOffset = DllStructGetData($tBufferOffset, 1)
						If Not $iBufferOffset Then ; zero value is the end
							ExitLoop
						EndIf

						If BitShift($iBufferOffset, 24) Then ; MSB is set for imports by ordinal, otherwise not
							;MsgBox(0,"Ordinal ", BitAND($iBufferOffset, 0xFFFFFF)) ; the rest is ordinal value
							; But we skip this because we're no looking for this shit
							$iOffset2 += 4 ; size of $tBufferOffset
							ContinueLoop

						EndIf
						;$j += 1
						$tBuffer = DllStructCreate("ushort Ordinal; char Name[64]", DllStructGetPtr($tIMAGE_DOS_HEADER) + $iBufferOffset)

						; Get name of that funcrion
						$sFunctionName = DllStructGetData($tBuffer, "Name")

						; Two more important info
						; Get offset of the function. 2 is size of "ushort Ordinal" from above
						;$iFunctionNameOffset = $iBufferOffset + 2 - DllStructGetPtr($tIMAGE_DOS_HEADER) ;<- this!
						; Get length of the function name
						;$iFunctionNameLength = StringLen($sFunctionName) ;<- and this!

						$MaxLenOld = $j

						If $MaxLenOld > $MaxLen Then
							$MaxLen = $MaxLenOld + 1
						EndIf

						ReDim $IMFA[UBound($IMFA) + 1][2][$MaxLen + 1]
						$IMFA[$i][1][$j] = $sFunctionName
						ConsoleWrite($IMFA[$i][0][0] & " > " & $sFunctionName & @CR)

						; Move pointer
						$iOffset2 += 4 ; size of $tBufferOffset

					WEnd

					$IMFA[$i][1][0] = $j - 1
					$k += $j - 1


					$iOffset += 20 ; size of $tIMAGE_IMPORT_MODULE_DIRECTORY

				WEnd

				ReDim $IMFA[UBound($IMFA, 1)][2][$MaxLen + 1]
				$IMFA[0][0][0] = $k

			EndIf
		Case 1

			Local $tIMAGE_FILE_HEADER = DllStructCreate("ushort Machine;" & _
					"ushort NumberOfSections;" & _
					"dword TimeDateStamp;" & _
					"dword PointerToSymbolTable;" & _
					"dword NumberOfSymbols;" & _
					"ushort SizeOfOptionalHeader;" & _
					"ushort Characteristics", _
					$pPointer - (20 + 96));Trunctiate size of $tIMAGE_OPTIONAL_HEADER and $tIMAGE_NT_SIGNATURE from pointer since we're not using them in this case


			Local $iAddressOfEntryPoint = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint")
			Local $Sections[1]

			Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")

			ReDim $Sections[$iNumberOfSections + 1]
			$Sections[0] = $iNumberOfSections

			$pPointer += 8

;~ 			 Resources Directory
;~ 			Local $tIMAGE_DIRECTORY_ENTRY_RES = DllStructCreate("dword VirtualAddress;" & _
;~ 					"dword Size", _
;~ 					$pPointer)

;~ 			 Virtual address of resources table
;~ 			Local $iResDirectoryVirtAddress = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_RES, "VirtualAddress")

			$pPointer += 120 ; skip 15 data directories

			Local $tIMAGE_SECTION_HEADER
			Local $iVirtualAddress
			Local $iVirtualSize
			Local $sItemText

			For $i = 0 To $iNumberOfSections - 1

				$tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];" & _
						"dword VirtualSize;" & _ ; union actually
						"dword VirtualAddress;" & _
						"dword SizeOfRawData;" & _
						"dword PointerToRawData;" & _
						"dword PointerToRelocations;" & _
						"dword PointerToLinenumbers;" & _
						"ushort NumberOfRelocations;" & _
						"ushort NumberOfLinenumbers;" & _
						"dword Characteristics", _
						$pPointer)

				; Get virtual address
				$iVirtualAddress = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualAddress")
				; Get virtual size
				$iVirtualSize = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualSize")

				; Find where Enty Point is (Digisoul)
				If ($iVirtualAddress <= $iAddressOfEntryPoint) And $iAddressOfEntryPoint < ($iVirtualAddress + $iVirtualSize) Then
					$sItemText = DllStructGetData($tIMAGE_SECTION_HEADER, "Name"); & "    (entry point)"
				Else
					$sItemText = DllStructGetData($tIMAGE_SECTION_HEADER, "Name")
				EndIf

;~ 				Find resources
;~ 				If ($iVirtualAddress <= $iResDirectoryVirtAddress) And $iResDirectoryVirtAddress < ($iVirtualAddress + $iVirtualSize) Then
;~ 					$sItemText &= "    (resources)"
;~ 				EndIf
;~
;~ 				DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData");  bytes
;~ 				Ptr(DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData"))
;~ 				Ptr($iVirtualAddress)
;~ 				DllStructGetData($tIMAGE_SECTION_HEADER, "NumberOfRelocations")

				; Move pointer
				$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
				$Sections[$i + 1] = $sItemText

			Next
			$IMFA = $Sections
	EndSwitch

	; Free module
	If $iLoaded Then
		$a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
		If @error Or Not $a_iCall[0] Then
			Return SetError(6, 0, "")
		EndIf
	EndIf


	Return SetError(0, 0, $IMFA)

EndFunc   ;==>_PEInfo

; #FUNCTION# ====================================================================================================================
; Name ..........: Wintrust
; Description ...: Validates a PE files digital signature
; Syntax ........: Wintrust($SourceFile)
; Parameters ....: $SourceFile          - String file path.
; Return values .: Customized for this script, if it has a valid and trusted signature, returns true, else error is
;						set to a positive value.
; Author ........: Prog@ndy
; Modified ......: THAT1ANONYMOUSDUDE
; Remarks .......: You can find the original unmodified version of this script at the below link
; Related .......:
; Link ..........: http://www.autoit.de/index.php?page=Thread&postID=68477#post68477
; Example .......: No
; ===============================================================================================================================

Func Wintrust($SourceFile)
	#CS
		Please take note that this only works for
		3rd party signed software! You cannot verify
		native Microsoft application using this code
		for reasons unknown to me.

		I do not know who created this as I found it
		by googleing (Site:autoitscript.com wintrust.dll)
		This code came up in an attachment and I could not
		locate the post where this code was attached...

		Code is slightly modified to suit this script!

		Edit: I believe this may be made by Pr@gandy
		after more research
	#CE

	Local Const $WTD_UI_NONE = 2
	Local Const $WTD_REVOKE_NONE = 0
	Local Const $WTD_CHOICE_FILE = 1
	Local Const $WTD_SAFER_FLAG = 0x00000100
	Local Const $TRUST_E_PROVIDER_UNKNOWN = 0x800B0001
	Local Const $TRUST_E_SUBJECT_FORM_UNKNOWN = 0x800B0003
	Local Const $TRUST_E_SUBJECT_NOT_TRUSTED = 0x800B0004
	Local Const $TRUST_E_NOSIGNATURE = 0x800B0100
	Local Const $TRUST_E_EXPLICIT_DISTRUST = 0x800B0111
	Local Const $CRYPT_E_SECURITY_SETTINGS = 0x80092026

	Local Const $tagWINTRUST_FILE_INFO = "DWORD cbStruct;" & _
			"ptr pcwszFilePath;" & _
			"HWND hFile;" & _
			"ptr  pgKnownSubject;"

	Local Const $tagWINTRUST_DATA = "DWORD cbStruct;" & _
			"ptr   pPolicyCallbackData;" & _
			"ptr   pSIPClientData;" & _
			"DWORD dwUIChoice;" & _
			"DWORD fdwRevocationChecks;" & _
			"DWORD dwUnionChoice;" & _
			"ptr   pInfoStruct;" & _
			"DWORD dwStateAction;" & _
			"HWND  hWVTStateData;" & _
			"ptr   pwszURLReference;" & _
			"DWORD dwProvFlags;" & _
			"DWORD dwUIContext;"

	Local Const $WINTRUST_ACTION_GENERIC_VERIFY_V2 = _GUIDStruct("{00AAC56B-CD44-11d0-8CC2-00C04FC295EE}")

	Local $pGUID = DllStructGetPtr($WINTRUST_ACTION_GENERIC_VERIFY_V2)
	Local $WINTRUST_FILE_INFO = DllStructCreate($tagWINTRUST_FILE_INFO)
	DllStructSetData($WINTRUST_FILE_INFO, 1, DllStructGetSize($WINTRUST_FILE_INFO))
	Local $wszSourceFile = DllStructCreate("wchar[" & StringLen($SourceFile) + 1 & "]")
	DllStructSetData($wszSourceFile, 1, $SourceFile)
	DllStructSetData($WINTRUST_FILE_INFO, "pcwszFilePath", DllStructGetPtr($wszSourceFile))
	Local $WINTRUST_DATA = DllStructCreate($tagWINTRUST_DATA)
	Local $pWINTRUST_DATA = DllStructGetPtr($WINTRUST_DATA)
	DllStructSetData($WINTRUST_DATA, 1, DllStructGetSize($WINTRUST_DATA))
	DllStructSetData($WINTRUST_DATA, "pPolicyCallbackData", 0)
	DllStructSetData($WINTRUST_DATA, "pSIPClientData", 0)
	DllStructSetData($WINTRUST_DATA, "dwUIChoice", $WTD_UI_NONE)
	DllStructSetData($WINTRUST_DATA, "fdwRevocationChecks", $WTD_REVOKE_NONE)
	DllStructSetData($WINTRUST_DATA, "dwUnionChoice", $WTD_CHOICE_FILE)
	DllStructSetData($WINTRUST_DATA, "dwStateAction", 0)
	DllStructSetData($WINTRUST_DATA, "hWVTStateData", 0)
	DllStructSetData($WINTRUST_DATA, "pwszURLReference", 0)
	DllStructSetData($WINTRUST_DATA, "dwProvFlags", $WTD_SAFER_FLAG)
	DllStructSetData($WINTRUST_DATA, "dwUIContext", 0)
	DllStructSetData($WINTRUST_DATA, "pInfoStruct", DllStructGetPtr($WINTRUST_FILE_INFO))

	Local $LStatus = DllCall($hWINTRST, "long", "WinVerifyTrust", _
			"hWnd", 0, _
			"ptr", $pGUID, _
			"ptr", $pWINTRUST_DATA _
			)
	If Not @error Then
		$LStatus = $LStatus[0]
	Else
		$LStatus = -1
	EndIf

	Switch $LStatus
		Case 0 ; ERROR_SUCCESS
			Return SetError(0, 0, "Verified")
		Case $TRUST_E_NOSIGNATURE
			; Get the reason for no signature.
			Local $dwLastError = DllCall($hKERNEL32, "dword", "GetLastError")
			$dwLastError = $dwLastError[0]
			If ($TRUST_E_NOSIGNATURE == $dwLastError Or $TRUST_E_SUBJECT_FORM_UNKNOWN == $dwLastError Or $TRUST_E_PROVIDER_UNKNOWN == $dwLastError) Then
				; The file was not signed.
				Return SetError(1, 0, "Not Signed")
			Else
				; The signature was not valid or there was an error
				; opening the file.
				Return SetError(1, 0, "Unable to verify")
			EndIf
		Case $TRUST_E_EXPLICIT_DISTRUST
			; The hash that represents the subject or the publisher
			; is not allowed by the admin or user.
			Return SetError(1, 0, "Not Trusted")

		Case $TRUST_E_SUBJECT_NOT_TRUSTED
			; The user clicked "No" when asked to install and run.
			Return SetError(1, 0, "Not Trusted")

		Case $CRYPT_E_SECURITY_SETTINGS
			#CS
				The hash that represents the subject or the publisher
				was not explicitly trusted by the admin and the
				admin policy has disabled user trust. No signature,
				publisher or time stamp errors.
			#CE
			Return SetError(1, 0, "Not Trusted")
		Case -1
			Return SetError(1, 0, "Unable to verify")

		Case Else
			; The UI was disabled in dwUIChoice or the admin policy
			; has disabled user trust. lStatus contains the
			; publisher or time stamp chain error.
			Return SetError(1, 0, "Unable to verify")
	EndSwitch
	Return SetError(1, 0, "Unable to verify")
EndFunc   ;==>Wintrust

Func _GUIDStruct($IID)
	$IID = StringRegExpReplace($IID, "([}{])", "")
	$IID = StringSplit($IID, "-")
	Local $_GUID = "DWORD Data1;  ushort Data2;  ushort Data3;  BYTE Data4[8];"
	Local $GUID = DllStructCreate($_GUID)
	If $IID[0] = 5 Then $IID[4] &= $IID[5]
	If $IID[0] > 5 Or $IID[0] < 4 Then Return SetError(1, 0, 0)
	DllStructSetData($GUID, 1, Dec($IID[1]))
	DllStructSetData($GUID, 2, Dec($IID[2]))
	DllStructSetData($GUID, 3, Dec($IID[3]))
	DllStructSetData($GUID, 4, Binary("0x" & $IID[4]))
	Return $GUID
EndFunc   ;==>_GUIDStruct
