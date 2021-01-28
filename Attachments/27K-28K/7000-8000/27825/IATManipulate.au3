Opt("MustDeclareVars", 1)

; Used dlls
Global Const $hNTDLL = DllOpen("ntdll.dll")
Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hGDI32 = DllOpen("gdi32.dll")
Global Const $hADVAPI32 = DllOpen("advapi32.dll")
Global Const $hOLE32 = DllOpen("ole32.dll")
Global Const $hCRYPT32 = DllOpen("crypt32.dll")
Global Const $hRPCRT4 = DllOpen("rpcrt4.dll")
Global Const $hSHLWAPI = DllOpen("shlwapi.dll")

; Will make 'my dir'
Global $sTemporaryFolder = @TempDir & "\TemporaryDirectoryForTheIATScript"
If DirCreate($sTemporaryFolder) Then
	$sTemporaryFolder = FileGetShortName($sTemporaryFolder)
	If @error Then
		$sTemporaryFolder = @TempDir
	EndIf
Else
	$sTemporaryFolder = @TempDir
EndIf

; Custom fonts
Global $hFontTreeView = _CreateFont(9, 400, 256)
Global $hFontLabel = _CreateFont(10, 400, 256)
Global $hFontEdit = _CreateFont(14, 400, 256)
Global $hFontButton = _CreateFont(11, 800, 258, "Arial")

; Working Mode (says what's loaded)
Global $iFullEditMode = 0

; MD5 to verify changes
Global $sMD5Original

; File name and alias
Global $sFile, $aShortcut, $sFileAlias

; This for the procedure
Global $iTargetVirtAddress, $iRawOffset
Global $sCurrentName, $sNewName
; True string offset
Global $iPos

; For reading treeview
Global $iViewed
Global $iIsModulName, $iNoInfo

; Will distroy treeview with every new load. This holds dimensions of treeview
Global $aTreeViewPos

; For reading
Global $hFile, $bFileString, $sFileString

; GUI related
Global $aClientSize, $sTitle

; Array of 'additional info'
Global $aArrayOfAdditionaInfo[30000] ; Oversizing? Sure hope so. This way for simplicity.
; his too, but special for every string
Global $aAdditionalInfo

; Delimeters for $aArrayOfAdditionaInfo
Global Const $sModulesDelimeter = ":?:"
Global Const $sFunctionsDelimeter = ";?;"

; Create GUI
Global $hGui = GUICreate("", 670, 400, -1, -1, 13565952, 16)

; Menu
Global $hFileMenu = GUICtrlCreateMenu("File")
Global $hFileOpenItem = GUICtrlCreateMenuItem("&Open", $hFileMenu)
GUICtrlSetState($hFileOpenItem, 512)
Global $hSaveItem = GUICtrlCreateMenuItem("&Save As...", $hFileMenu)
GUICtrlSetState($hSaveItem, 128)
GUICtrlCreateMenuItem("", $hFileMenu)
Global $hExitItem = GUICtrlCreateMenuItem("&Exit", $hFileMenu)

; TreeView
Global $hTreeView = GUICtrlCreateTreeView(2, 0, 315, 345)
GUICtrlSetState($hTreeView, 8) ; $GUI_DROPACCEPTED
GUICtrlSendMsg($hTreeView, 48, $hFontTreeView, 1) ; WM_SETFONT
GUICtrlSendMsg($hTreeView, 4379, 22, 0) ; set size
GUICtrlSetResizing($hTreeView, 354)

; For editing
Global $hLabelCurrent = GUICtrlCreateLabel("Current name", 350, 15, 300)
GUICtrlSendMsg($hLabelCurrent, 48, $hFontLabel, 1) ; WM_SETFONT

Global $hEditCurrent = GUICtrlCreateInput("", 350, 35, 300, 30, 2176) ; ES_READONLY|ES_AUTOHSCROLL
GUICtrlSendMsg($hEditCurrent, 48, $hFontEdit, 1) ; WM_SETFONT
GUICtrlSetBkColor($hEditCurrent, 0xFFFFFF)
GUICtrlSetColor($hEditCurrent, 0x0000C0)

Global $hLabelNew = GUICtrlCreateLabel("New name", 350, 100, 300)
GUICtrlSendMsg($hLabelNew, 48, $hFontLabel, 1) ; WM_SETFONT
Global $hEditNew = GUICtrlCreateInput("", 350, 120, 300, 30, 128) ; ES_AUTOHSCROLL
GUICtrlSendMsg($hEditNew, 48, $hFontEdit, 1) ; WM_SETFONT
GUICtrlSetColor($hEditNew, 0x0000C0)

Global $hButtonIAT = GUICtrlCreateButton("Change!", 450, 200, 100, 32)
GUICtrlSendMsg($hButtonIAT, 48, $hFontButton, 1) ; WM_SETFONT
GUICtrlSetTip($hButtonIAT, "GO!")

; Nothing particular
GUICtrlCreateLabel("", 0, 348, 670, 2, 4096)
GUICtrlSetResizing(-1, 576)

; For treeview
Global $hGeneralInfoTree, $hExportedFuncTree, $hImportsTree, $hSectionsTree

; Handle resizing additionally
GUIRegisterMsg(5, "_AdjustGUITitle") ; WM_SIZE

; Show it
GUISetState(@SW_SHOW, $hGui)

Global $iMsg

While 1

	$iMsg = GUIGetMsg()

	Switch $iMsg

		Case - 3, $hExitItem
			If _CheckSave() Then
				Exit
			EndIf

		Case - 13
			$aShortcut = FileGetShortcut(@GUI_DragFile)
			If @error Then
				$sFile = @GUI_DragFile
			Else
				$sFile = $aShortcut[0]
			EndIf

			If FileExists($sFile) Then

				$iFullEditMode = 0
				GUICtrlSetState($hSaveItem, 64)

				$aTreeViewPos = ControlGetPos($hGui, 0, $hTreeView)
				GUICtrlDelete($hTreeView)
				$hTreeView = GUICtrlCreateTreeView($aTreeViewPos[0], $aTreeViewPos[1], $aTreeViewPos[2], $aTreeViewPos[3], 63)
				GUICtrlSetState($hTreeView, 8) ; $GUI_DROPACCEPTED
				GUICtrlSendMsg($hTreeView, 48, $hFontTreeView, 1) ; WM_SETFONT
				GUICtrlSendMsg($hTreeView, 4379, 22, 0) ; set size
				GUICtrlSetResizing($hTreeView, 354)

				If $sFileAlias Then
					FileDelete($sFileAlias)
				EndIf

				$sFileAlias = $sTemporaryFolder & "\" & _GenerateGUID() & ".dll"
				FileCopy($sFile, $sFileAlias, 9)
				FileSetAttrib($sFileAlias, "-RS")

				GUICtrlSendMsg($hTreeView, 11, 0, 0) ; disable treeview changes
				_Main($hTreeView, $sFileAlias, $iTargetVirtAddress, $iRawOffset)
				GUICtrlSendMsg($hTreeView, 11, 1, 0) ; enable treeview changes
				GUICtrlSetState($hGeneralInfoTree, 512 + 1024) ; $GUI_DEFBUTTON|$GUI_EXPAND

				$aClientSize = WinGetClientSize($hGui)
				$sTitle = _CompactString($sFile, $aClientSize[0] - 100)
				WinSetTitle($hGui, 0, $sTitle)

				$hFile = FileOpen($sFileAlias, 16)
				$bFileString = FileRead($hFile)
				FileClose($hFile)
				$sFileString = BinaryToString($bFileString)

			EndIf


		Case $hFileOpenItem
			$sFile = FileOpenDialog("Choose file", "", "(*.exe; *.dll; *.scr; *.ocx; *.cpl; *.icl)| All files(*.*)", 1, "", $hGui)
			If Not @error Then

				$iFullEditMode = 0
				GUICtrlSetState($hSaveItem, 64)

				$aTreeViewPos = ControlGetPos($hGui, 0, $hTreeView)
				GUICtrlDelete($hTreeView)
				$hTreeView = GUICtrlCreateTreeView($aTreeViewPos[0], $aTreeViewPos[1], $aTreeViewPos[2], $aTreeViewPos[3], 63)
				GUICtrlSetState($hTreeView, 8) ; $GUI_DROPACCEPTED
				GUICtrlSendMsg($hTreeView, 48, $hFontTreeView, 1) ; WM_SETFONT
				GUICtrlSendMsg($hTreeView, 4379, 22, 0) ; set size
				GUICtrlSetResizing($hTreeView, 354)

				If $sFileAlias Then
					FileDelete($sFileAlias)
				EndIf

				$sFileAlias = $sTemporaryFolder & "\" & _GenerateGUID() & ".dll"
				FileCopy($sFile, $sFileAlias, 9)
				FileSetAttrib($sFileAlias, "-RS")

				GUICtrlSendMsg($hTreeView, 11, 0, 0) ; disable treeview changes
				_Main($hTreeView, $sFileAlias, $iTargetVirtAddress, $iRawOffset)
				GUICtrlSendMsg($hTreeView, 11, 1, 0) ; enable treeview changes
				GUICtrlSetState($hGeneralInfoTree, 512 + 1024) ; $GUI_DEFBUTTON|$GUI_EXPAND

				$aClientSize = WinGetClientSize($hGui)
				$sTitle = _CompactString($sFile, $aClientSize[0] - 100)
				WinSetTitle($hGui, 0, $sTitle)

				$hFile = FileOpen($sFileAlias, 16)
				$bFileString = FileRead($hFile)
				FileClose($hFile)
				$sFileString = BinaryToString($bFileString)

			EndIf

		Case $hButtonIAT
			$sCurrentName = GUICtrlRead($hEditCurrent)
			$sNewName = GUICtrlRead($hEditNew)
			If StringLen($sNewName) > StringLen($sCurrentName) Then
				MsgBox(262144 + 48, "Error", "New name must not be larger than the old one." & @CRLF & "Make it shorter.", 0, $hGui)
			ElseIf Not $sCurrentName Then
				MsgBox(262144 + 48, "Error", "Yeah right." & @CRLF & "...and I didn't thought of that.", 0, $hGui)
			ElseIf Not $sNewName Then
				MsgBox(262144 + 48, "Error", "New name field is empty!", 0, $hGui)
			Else
				$sFileString = StringReplace($sFileString, $iPos, $sNewName & Chr(0)) ; null-terminated
				$hFile = FileOpen($sFileAlias, 18)
				$bFileString = FileWrite($hFile, StringToBinary($sFileString))
				FileClose($hFile)

				$aTreeViewPos = ControlGetPos($hGui, 0, $hTreeView)
				GUICtrlDelete($hTreeView)
				$hTreeView = GUICtrlCreateTreeView($aTreeViewPos[0], $aTreeViewPos[1], $aTreeViewPos[2], $aTreeViewPos[3], 63)
				GUICtrlSetState($hTreeView, 8) ; $GUI_DROPACCEPTED
				GUICtrlSendMsg($hTreeView, 48, $hFontTreeView, 1) ; WM_SETFONT
				GUICtrlSendMsg($hTreeView, 4379, 22, 0) ; set size
				GUICtrlSetResizing($hTreeView, 354)

				GUICtrlSendMsg($hTreeView, 11, 0, 0) ; disable treeview changes
				_Main($hTreeView, $sFileAlias, $iTargetVirtAddress, $iRawOffset)
				GUICtrlSendMsg($hTreeView, 11, 1, 0) ; enable treeview changes
				GUICtrlSetState($hGeneralInfoTree, 512 + 1024) ; $GUI_DEFBUTTON|$GUI_EXPAND
			EndIf

		Case $hSaveItem
			;Code missing

	EndSwitch


	If GUICtrlRead($hTreeView) <> $iViewed Then

		$iNoInfo = 0
		$iIsModulName = 0
		$iViewed = GUICtrlRead($hTreeView)

		$aAdditionalInfo = StringSplit($aArrayOfAdditionaInfo[$iViewed], $sFunctionsDelimeter, 1)
		If @error Then
			$iIsModulName = 1
			$aAdditionalInfo = StringSplit($aArrayOfAdditionaInfo[$iViewed], $sModulesDelimeter, 1)
			If @error Then
				$iNoInfo = 1
				$iIsModulName = 0
			EndIf
		EndIf

		If $iNoInfo Then
			GUICtrlSetData($hLabelCurrent, "Current name:")
			GUICtrlSetData($hLabelNew, "New name:")
			GUICtrlSetData($hEditCurrent, "")
			GUICtrlSetData($hEditNew, "")
		Else
			; Position of module/function string-name
			$iPos = $iRawOffset + ($aAdditionalInfo[1] - $iTargetVirtAddress) + 1

			If $iIsModulName Then
				GUICtrlSetData($hLabelCurrent, "Current module name:")
				GUICtrlSetData($hLabelNew, "New module name:")
				GUICtrlSetData($hEditCurrent, $aAdditionalInfo[3])
			Else
				GUICtrlSetData($hLabelCurrent, "Current function name:")
				GUICtrlSetData($hLabelNew, "New function name:")
				GUICtrlSetData($hEditCurrent, $aAdditionalInfo[3])
			EndIf
		EndIf

	EndIf

WEnd

;The End!


;FUNCTIONS...

Func _Main($hTreeViewControl, $sModule, ByRef $iTargetVirtAddress, ByRef $iRawOffset)

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
			Local $a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
			If @error Or Not $a_iCall[0] Then
				Return SetError(5, 0, "")
			EndIf
		EndIf
		Return SetError(4, 0, "")
	EndIf

	$pPointer += 4 ; size of $tIMAGE_NT_SIGNATURE structure

	Local $tIMAGE_FILE_HEADER = DllStructCreate("ushort Machine;" & _
			"ushort NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"ushort SizeOfOptionalHeader;" & _
			"ushort Characteristics", _
			$pPointer)

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

	$hGeneralInfoTree = GUICtrlCreateTreeViewItem("General information", $hTreeViewControl)
	GUICtrlSetColor($hGeneralInfoTree, 0x0000C0)

	Local $iMachine = DllStructGetData($tIMAGE_FILE_HEADER, "Machine")
	Local $sMachine
	Switch $iMachine
		Case 332
			$sMachine = "x86"
		Case 512
			$sMachine = "Intel IPF"
		Case 34404
			$sMachine = "x64"
	EndSwitch

	Local $iMagic = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "Magic")
	Local $sMagic
	Switch $iMagic
		Case 267
			$sMagic = "32-bit application"
		Case 523
			$sMagic = "64-bit application"
		Case 263
			$sMagic = "ROM image"
	EndSwitch


	Local $iFileSize = FileGetSize($sModule)
	Local $sFileSize

	Local $aCall = DllCall($hSHLWAPI, "int", "StrFormatByteSizeW", _
			"uint64", $iFileSize, _
			"wstr", "", _
			"dword", 16)

	If @error Then
		$sFileSize = $iFileSize
	Else
		$sFileSize = $iFileSize & " bytes (" & $aCall[2] & ")"
	EndIf

	GUICtrlCreateTreeViewItem("File name: " & StringRegExpReplace($sFile, ".*\\", ""), $hGeneralInfoTree)
	GUICtrlCreateTreeViewItem("File size: " & $sFileSize, $hGeneralInfoTree)
	Local $aHashes = _GetHashes($sModule)
	GUICtrlCreateTreeViewItem("MD5: " & $aHashes[0], $hGeneralInfoTree)
	GUICtrlCreateTreeViewItem("SHA1: " & $aHashes[1], $hGeneralInfoTree)
	GUICtrlCreateTreeViewItem("TimeDateStamp: " & _EpochDecrypt(DllStructGetData($tIMAGE_FILE_HEADER, "TimeDateStamp")) & " UTC", $hGeneralInfoTree)
	GUICtrlCreateTreeViewItem("Made for: " & $sMachine & " machine", $hGeneralInfoTree)
	GUICtrlCreateTreeViewItem("Type: " & $sMagic, $hGeneralInfoTree)
	Local $iAddressOfEntryPoint = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint")
	GUICtrlCreateTreeViewItem("AddressOfEntryPoint: " & Ptr($iAddressOfEntryPoint), $hGeneralInfoTree)
	GUICtrlCreateTreeViewItem("ImageBase: " & Ptr(DllStructGetData($tIMAGE_OPTIONAL_HEADER, "ImageBase")), $hGeneralInfoTree)
	GUICtrlCreateTreeViewItem("CheckSum: " & DllStructGetData($tIMAGE_OPTIONAL_HEADER, "CheckSum"), $hGeneralInfoTree)

	If $iMagic <> 267 Then
		If $iLoaded Then
			Local $a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
			If @error Or Not $a_iCall[0] Then
				Return SetError(5, 0, "")
			EndIf
		EndIf
		Return SetError(0, 1, 1) ; not 32-bit application. Structures are for 32-bit
	EndIf

	$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER structure

	$hExportedFuncTree = GUICtrlCreateTreeViewItem("Exported functions - none", $hTreeViewControl)
	GUICtrlSetColor($hExportedFuncTree, 0x0000C0)
	GUICtrlSetState($hExportedFuncTree, 512) ; $GUI_DEFBUTTON

	$hImportsTree = GUICtrlCreateTreeViewItem("Imported functions - none", $hTreeViewControl)
	GUICtrlSetColor($hImportsTree, 0x0000C0)
	GUICtrlSetState($hImportsTree, 512) ; $GUI_DEFBUTTON

	$hSectionsTree = GUICtrlCreateTreeViewItem("Sections", $hTreeViewControl)
	GUICtrlSetColor($hSectionsTree, 0x0000C0)
	GUICtrlSetState($hSectionsTree, 512) ; $GUI_DEFBUTTON

	Local $hTreeViewExp[1]
	Local $hTreeViewImpModules[1]
	Local $hTreeViewSections[1]

	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	ReDim $hTreeViewSections[$iNumberOfSections + 1]
	GUICtrlSetData($hSectionsTree, "Sections (" & $iNumberOfSections & ")")

	; Export Directory
	Local $tIMAGE_DIRECTORY_ENTRY_EXPORT = DllStructCreate("dword VirtualAddress;" & _
			"dword Size", _
			$pPointer)

	; Virtual address of export table
	Local $iExportDirectoryVirtAddress = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_EXPORT, "VirtualAddress")

	If $iExportDirectoryVirtAddress And DllStructGetData($tIMAGE_DIRECTORY_ENTRY_EXPORT, "Size") Then ; if valid

		Local $tIMAGE_EXPORT_DIRECTORY = DllStructCreate("dword Characteristics;" & _
				"dword TimeDateStamp;" & _
				"ushort MajorVersion;" & _
				"ushort MinorVersion;" & _
				"dword Name;" & _
				"dword Base;" & _
				"dword NumberOfFunctions;" & _
				"dword NumberOfNames;" & _
				"dword AddressOfFunctions;" & _
				"dword AddressOfNames;" & _
				"dword AddressOfNameOrdinals", _
				DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_DIRECTORY_ENTRY_EXPORT, "VirtualAddress"))

		Local $iBase = DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "Base")
		Local $iNumberOfExporedFunctions = DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "NumberOfFunctions")

		If $iNumberOfExporedFunctions Then
			ReDim $hTreeViewExp[$iNumberOfExporedFunctions]
			GUICtrlSetData($hExportedFuncTree, "Exported Functions (" & $iNumberOfExporedFunctions & ")")
		EndIf

		Local $tBufferAddress = DllStructCreate("dword[" & DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "NumberOfFunctions") & "]", DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "AddressOfFunctions"))
		Local $tBufferNames = DllStructCreate("dword[" & DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "NumberOfNames") & "]", DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "AddressOfNames"))
		Local $tBufferNamesOrdinals = DllStructCreate("ushort[" & DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "NumberOfFunctions") & "]", DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "AddressOfNameOrdinals"))

		Local $iNumNames = DllStructGetData($tIMAGE_EXPORT_DIRECTORY, "NumberOfNames") ; number of functions exported by name
		Local $iFuncOrdinal
		Local $tFuncName, $sFuncName
		Local $iFuncAddress

		For $i = 1 To $iNumberOfExporedFunctions
			$hTreeViewExp[$i - 1] = GUICtrlCreateTreeViewItem("Ordinal " & $iBase + $i - 1, $hExportedFuncTree)
		Next

		For $i = 1 To $iNumNames
			$tFuncName = DllStructCreate("char[64]", DllStructGetPtr($tIMAGE_DOS_HEADER) + DllStructGetData($tBufferNames, 1, $i))
			$sFuncName = DllStructGetData($tFuncName, 1) ; name of the function
			$iFuncOrdinal = $iBase + DllStructGetData($tBufferNamesOrdinals, 1, $i)
			$iFuncAddress = DllStructGetData($tBufferAddress, 1, $i)

			GUICtrlSetData($hTreeViewExp[$iFuncOrdinal - $iBase], $iFuncOrdinal & "  " & $sFuncName & "    " & Ptr($iFuncAddress))
		Next

	EndIf

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

		Local $iModuleNameOffset, $iModuleNameLength ; for modules
		Local $iFunctionNameOffset, $iFunctionNameLength ; for functions

		Local $i, $j, $k

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
			$iModuleNameOffset = DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName")
			; Get length of the module name
			$iModuleNameLength = StringLen($sModuleName)

			ReDim $hTreeViewImpModules[$i + 1]
			$hTreeViewImpModules[$i] = GUICtrlCreateTreeViewItem($sModuleName, $hImportsTree)

			; Fill array of additional info that I'm 'exporting'. This looks kind of obfuscated but it's really very simple when you figure what I'm doing.
			$aArrayOfAdditionaInfo[$hTreeViewImpModules[$i]] = $iModuleNameOffset & $sModulesDelimeter & $iModuleNameLength & $sModulesDelimeter & $sModuleName

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

					GUICtrlCreateTreeViewItem("Ordinal " & BitAND($iBufferOffset, 0xFFFFFF), $hTreeViewImpModules[$i]) ; the rest is ordinal value
					$iOffset2 += 4 ; size of $tBufferOffset
					ContinueLoop

				EndIf

				$tBuffer = DllStructCreate("ushort Ordinal; char Name[64]", DllStructGetPtr($tIMAGE_DOS_HEADER) + $iBufferOffset)

				; Get name of that funcrion
				$sFunctionName = DllStructGetData($tBuffer, "Name")

				; Two more important info
				; Get offset of the function. 2 is size of "ushort Ordinal" from above
				$iFunctionNameOffset = $iBufferOffset + 2 - DllStructGetPtr($tIMAGE_DOS_HEADER) ;<- this!
				; Get length of the function name
				$iFunctionNameLength = StringLen($sFunctionName) ;<- and this!

				; Fill array of additional info that I'm 'exporting'
				$aArrayOfAdditionaInfo[GUICtrlCreateTreeViewItem($sFunctionName, $hTreeViewImpModules[$i])] = $iFunctionNameOffset & $sFunctionsDelimeter & $iFunctionNameLength & $sFunctionsDelimeter & $sFunctionName

				; Move pointer
				$iOffset2 += 4 ; size of $tBufferOffset

			WEnd

			GUICtrlSetData($hTreeViewImpModules[$i], $sModuleName & " (" & $j - 1 & ")")
			$k += $j - 1

			$iOffset += 20 ; size of $tIMAGE_IMPORT_MODULE_DIRECTORY

		WEnd

		GUICtrlSetData($hImportsTree, "Imported functions (" & $k & ")")

	EndIf

	$pPointer += 8

	; Resources Directory
	Local $tIMAGE_DIRECTORY_ENTRY_RES = DllStructCreate("dword VirtualAddress;" & _
			"dword Size", _
			$pPointer)

	; Virtual address of resources table
	Local $iResDirectoryVirtAddress = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_RES, "VirtualAddress")

	$pPointer += 8

	$pPointer += 64 ; 8 more data directories that I'm not interested in here

	$pPointer += 40 ; five more unused data directories

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
			$sItemText = DllStructGetData($tIMAGE_SECTION_HEADER, "Name") & "    (entry point)"
			;$hTreeViewSections[$i] = GUICtrlCreateTreeViewItem($sItemText, $hSectionsTree)
		Else
			$sItemText = DllStructGetData($tIMAGE_SECTION_HEADER, "Name")
		EndIf

		; Locate Import Address Table
		If ($iVirtualAddress <= $iImportDirectoryVirtAddress) And $iImportDirectoryVirtAddress < ($iVirtualAddress + $iVirtualSize) Then
			$iTargetVirtAddress = $iVirtualAddress
			$iRawOffset = DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
			$sItemText &= "    (IAT)"
		EndIf

		; See where exported functions are
		If ($iVirtualAddress <= $iExportDirectoryVirtAddress) And $iExportDirectoryVirtAddress < ($iVirtualAddress + $iVirtualSize) Then
			$sItemText &= "    (exports)"
		EndIf

		; Find resources
		If ($iVirtualAddress <= $iResDirectoryVirtAddress) And $iResDirectoryVirtAddress < ($iVirtualAddress + $iVirtualSize) Then
			$sItemText &= "    (resources)"
		EndIf

		$hTreeViewSections[$i] = GUICtrlCreateTreeViewItem($sItemText, $hSectionsTree)

		GUICtrlCreateTreeViewItem("SizeOfRawData: " & DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData") & " bytes", $hTreeViewSections[$i])
		GUICtrlCreateTreeViewItem("PointerToRawData: " & Ptr(DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")), $hTreeViewSections[$i])
		GUICtrlCreateTreeViewItem("VirtualAddress: " & Ptr($iVirtualAddress), $hTreeViewSections[$i])
		GUICtrlCreateTreeViewItem("NumberOfRelocations: " & DllStructGetData($tIMAGE_SECTION_HEADER, "NumberOfRelocations"), $hTreeViewSections[$i])

		; Move pointer
		$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure

	Next

	; Free module
	If $iLoaded Then
		Local $a_iCall = DllCall($hKERNEL32, "int", "FreeLibrary", "hwnd", $hModule)
		If @error Or Not $a_iCall[0] Then
			Return SetError(6, 0, "")
		EndIf
	EndIf

	; Return
	Return 1


EndFunc   ;==>_Main








Func _GetHashes($sFile) ; Siao's originally

	Local $aHashArray[2] = [" ~unable to resolve~", " ~unable to resolve~"] ; predefining output

	Local $a_hCall = DllCall($hKERNEL32, "hwnd", "CreateFileW", _
			"wstr", $sFile, _
			"dword", 0x80000000, _ ; GENERIC_READ
			"dword", 1, _ ; FILE_SHARE_READ
			"ptr", 0, _
			"dword", 3, _ ; OPEN_EXISTING
			"dword", 0, _ ; SECURITY_ANONYMOUS
			"ptr", 0)

	If @error Or $a_hCall[0] = -1 Then
		Return SetError(1, 0, $aHashArray)
	EndIf

	Local $hFile = $a_hCall[0]

	$a_hCall = DllCall($hKERNEL32, "ptr", "CreateFileMappingW", _
			"hwnd", $hFile, _
			"dword", 0, _ ; default security descriptor
			"dword", 2, _ ; PAGE_READONLY
			"dword", 0, _
			"dword", 0, _
			"ptr", 0)

	If @error Or Not $a_hCall[0] Then
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(2, 0, $aHashArray)
	EndIf

	DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFile)

	Local $hFileMappingObject = $a_hCall[0]

	$a_hCall = DllCall($hKERNEL32, "ptr", "MapViewOfFile", _
			"hwnd", $hFileMappingObject, _
			"dword", 4, _ ; FILE_MAP_READ
			"dword", 0, _
			"dword", 0, _
			"dword", 0)

	If @error Or Not $a_hCall[0] Then
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(3, 0, $aHashArray)
	EndIf

	Local $pFile = $a_hCall[0]
	Local $iBufferSize = FileGetSize($sFile)

	Local $a_iCall = DllCall($hADVAPI32, "int", "CryptAcquireContext", _
			"ptr*", 0, _
			"ptr", 0, _
			"ptr", 0, _
			"dword", 1, _ ; PROV_RSA_FULL
			"dword", 0xF0000000) ; CRYPT_VERIFYCONTEXT

	If @error Or Not $a_iCall[0] Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(5, 0, $aHashArray)
	EndIf

	Local $hContext = $a_iCall[1]

	$a_iCall = DllCall($hADVAPI32, "int", "CryptCreateHash", _
			"ptr", $hContext, _
			"dword", 0x00008003, _ ; CALG_MD5
			"ptr", 0, _ ; nonkeyed
			"dword", 0, _
			"ptr*", 0)

	If @error Or Not $a_iCall[0] Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall($hADVAPI32, "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(6, 0, $aHashArray)
	EndIf

	Local $hHashMD5 = $a_iCall[5]

	$a_iCall = DllCall($hADVAPI32, "int", "CryptHashData", _
			"ptr", $hHashMD5, _
			"ptr", $pFile, _
			"dword", $iBufferSize, _
			"dword", 0)

	If @error Or Not $a_iCall[0] Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall($hADVAPI32, "int", "CryptDestroyHash", "ptr", $hHashMD5)
		DllCall($hADVAPI32, "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(7, 0, $aHashArray)
	EndIf

	Local $tOutMD5 = DllStructCreate("byte[16]")

	$a_iCall = DllCall($hADVAPI32, "int", "CryptGetHashParam", _
			"ptr", $hHashMD5, _
			"dword", 2, _ ; HP_HASHVAL
			"ptr", DllStructGetPtr($tOutMD5), _
			"dword*", 16, _
			"dword", 0)

	If @error Or Not $a_iCall[0] Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall($hADVAPI32, "int", "CryptDestroyHash", "ptr", $hHashMD5)
		DllCall($hADVAPI32, "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(8, 0, $aHashArray)
	EndIf

	DllCall($hADVAPI32, "int", "CryptDestroyHash", "ptr", $hHashMD5)

	$aHashArray[0] = Hex(DllStructGetData($tOutMD5, 1))

	If Not $iFullEditMode Then
		$iFullEditMode = 1
		$sMD5Original = $aHashArray[0] ; this is global
	EndIf

	$a_iCall = DllCall($hADVAPI32, "int", "CryptCreateHash", _
			"ptr", $hContext, _
			"dword", 0x00008004, _ ; CALG_SHA1
			"ptr", 0, _ ; nonkeyed
			"dword", 0, _
			"ptr*", 0)

	If @error Or Not $a_iCall[0] Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall($hADVAPI32, "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(9, 0, $aHashArray)
	EndIf

	Local $hHashSHA1 = $a_iCall[5]

	$a_iCall = DllCall($hADVAPI32, "int", "CryptHashData", _
			"ptr", $hHashSHA1, _
			"ptr", $pFile, _
			"dword", $iBufferSize, _
			"dword", 0)

	If @error Or Not $a_iCall[0] Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall($hADVAPI32, "int", "CryptDestroyHash", "ptr", $hHashSHA1)
		DllCall($hADVAPI32, "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(10, 0, $aHashArray)
	EndIf

	Local $tOutSHA1 = DllStructCreate("byte[20]")

	$a_iCall = DllCall($hADVAPI32, "int", "CryptGetHashParam", _
			"ptr", $hHashSHA1, _
			"dword", 2, _ ; HP_HASHVAL
			"ptr", DllStructGetPtr($tOutSHA1), _
			"dword*", 20, _
			"dword", 0)

	If @error Or Not $a_iCall[0] Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		DllCall($hADVAPI32, "int", "CryptDestroyHash", "ptr", $hHashSHA1)
		DllCall($hADVAPI32, "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)
		Return SetError(11, 0, $aHashArray)
	EndIf

	DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)

	DllCall($hADVAPI32, "int", "CryptDestroyHash", "ptr", $hHashSHA1)

	$aHashArray[1] = Hex(DllStructGetData($tOutSHA1, 1))

	DllCall($hADVAPI32, "int", "CryptReleaseContext", "ptr", $hContext, "dword", 0)

	Return SetError(0, 0, $aHashArray)

EndFunc   ;==>_GetHashes



Func _EpochDecrypt($iEpochTime)

	Local $iDayToAdd = Int($iEpochTime / 86400)
	Local $iTimeVal = Mod($iEpochTime, 86400)

	If $iTimeVal < 0 Then
		$iDayToAdd -= 1
		$iTimeVal += 86400
	EndIf

	Local $i_wFactor = Int((573371.75 + $iDayToAdd) / 36524.25)
	Local $i_xFactor = Int($i_wFactor / 4)
	Local $i_bFactor = 2442113 + $iDayToAdd + $i_wFactor - $i_xFactor

	Local $i_cFactor = Int(($i_bFactor - 122.1) / 365.25)
	Local $i_dFactor = Int(365.25 * $i_cFactor)
	Local $i_eFactor = Int(($i_bFactor - $i_dFactor) / 30.6001)

	Local $aDatePart[3]
	$aDatePart[2] = $i_bFactor - $i_dFactor - Int(30.6001 * $i_eFactor)
	$aDatePart[1] = $i_eFactor - 1 - 12 * ($i_eFactor - 2 > 11)
	$aDatePart[0] = $i_cFactor - 4716 + ($aDatePart[1] < 3)

	Local $aTimePart[3]
	$aTimePart[0] = Int($iTimeVal / 3600)
	$iTimeVal = Mod($iTimeVal, 3600)
	$aTimePart[1] = Int($iTimeVal / 60)
	$aTimePart[2] = Mod($iTimeVal, 60)

	Return SetError(0, 0, StringFormat("%.2d/%.2d/%.2d %.2d:%.2d:%.2d", $aDatePart[0], $aDatePart[1], $aDatePart[2], $aTimePart[0], $aTimePart[1], $aTimePart[2]))

EndFunc   ;==>_EpochDecrypt




Func _CreateFont($iSize = 8.5, $iWeight = 400, $iAttribute = 0, $sFontName = "", $hWnd = 0)

	Local $iItalic = BitAND($iAttribute, 2)
	Local $iUnderline = BitAND($iAttribute, 4)
	Local $iStrikeout = BitAND($iAttribute, 8)

	Local $iQuality
	If BitAND($iAttribute, 16) Then
		$iQuality = 1 ; DRAFT_QUALITY
	ElseIf BitAND($iAttribute, 32) Then
		$iQuality = 2 ; PROOF_QUALITY
	ElseIf BitAND($iAttribute, 64) Then
		$iQuality = 3 ; NONANTIALIASED_QUALITY
	ElseIf BitAND($iAttribute, 128) Then
		$iQuality = 4 ; ANTIALIASED_QUALITY
	ElseIf BitAND($iAttribute, 256) Then
		$iQuality = 5 ; CLEARTYPE_QUALITY
	ElseIf BitAND($iAttribute, 512) Then
		$iQuality = 6 ; CLEARTYPE_COMPAT_QUALITY
	EndIf

	Local $aCall = DllCall($hUSER32, "hwnd", "GetDC", "hwnd", $hWnd)

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $hDC = $aCall[0]

	$aCall = DllCall($hGDI32, "int", "GetDeviceCaps", _
			"hwnd", $hDC, _
			"int", 90) ; LOGPIXELSY

	If @error Or Not $aCall[0] Then
		Return SetError(2, 0, 0)
	EndIf

	Local $iDCaps = $aCall[0]

	DllCall($hUSER32, "int", "ReleaseDC", "hwnd", $hWnd, "hwnd", $hDC)

	$aCall = DllCall($hGDI32, "hwnd", "CreateFontW", _
			"int", -$iSize * $iDCaps / 72, _
			"int", 0, _
			"int", 0, _
			"int", 0, _
			"int", $iWeight, _
			"dword", $iItalic, _
			"dword", $iUnderline, _
			"dword", $iStrikeout, _
			"dword", 0, _
			"dword", 0, _
			"dword", 0, _
			"dword", $iQuality, _
			"dword", 0, _
			"wstr", $sFontName)

	If @error Or Not $aCall[0] Then
		Return SetError(3, 0, 0)
	EndIf

	Local $hFont = $aCall[0]

	Return SetError(0, 0, $hFont)

EndFunc   ;==>_CreateFont


Func _HexEncode($bInput)

	Local $iSizeIn = BinaryLen($bInput)

	Local $tInput = DllStructCreate("byte[" & $iSizeIn & "]")

	DllStructSetData($tInput, 1, $bInput)

	Local $a_iCall = DllCall($hCRYPT32, "int", "CryptBinaryToStringA", _
			"ptr", DllStructGetPtr($tInput), _
			"dword", $iSizeIn, _
			"dword", 11, _
			"ptr", 0, _
			"dword*", 0)

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, "")
	EndIf

	Local $iSizeOut = $a_iCall[5]
	If $iSizeOut > 3E7 Then
		Return SetError(0, 1, "Too Big! " & @CRLF & "This action would require to alocate over " & Floor($iSizeOut / 1.05E6) & " MB of memory at time. " & @CRLF & "Aborted!!!")
	EndIf

	Local $tOut = DllStructCreate("char[" & $iSizeOut & "]")

	$a_iCall = DllCall($hCRYPT32, "int", "CryptBinaryToStringA", _
			"ptr", DllStructGetPtr($tInput), _
			"dword", $iSizeIn, _
			"dword", 11, _
			"ptr", DllStructGetPtr($tOut), _
			"dword*", $iSizeOut)

	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, "")
	EndIf

	Return SetError(0, 0, DllStructGetData($tOut, 1))

EndFunc   ;==>_HexEncode




Func _CompactString($sString, $iWidth)

	Local $a_iCall = DllCall($hSHLWAPI, "dword", "PathCompactPathW", _
			"hwnd", 0, _
			"wstr", $sString, _
			"dword", $iWidth)

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, $sString)
	EndIf

	Return SetError(0, 0, $a_iCall[2])

EndFunc   ;==>_CompactString



Func _AdjustGUITitle($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam
	If $sFile Then
		Local $aClientSize[2] = [BitAND($lParam, 65535), BitShift($lParam, 16)]
		$sTitle = _CompactString($sFile, $aClientSize[0] - 100)
		WinSetTitle($hGui, 0, $sTitle)
	EndIf

EndFunc   ;==>_AdjustGUITitle


Func _GenerateGUID()

	Local $GUIDSTRUCT = DllStructCreate("int;short;short;byte[8]")

	Local $a_iCall = DllCall($hRPCRT4, "int", "UuidCreate", "ptr", DllStructGetPtr($GUIDSTRUCT))

	If @error Or $a_iCall[0] Then
		Return SetError(1, 0, "")
	EndIf

	$a_iCall = DllCall($hOLE32, "int", "StringFromGUID2", _
			"ptr", DllStructGetPtr($GUIDSTRUCT), _
			"wstr", "", _
			"int", 40)

	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, "")
	EndIf

	Return SetError(0, 0, $a_iCall[2])

EndFunc   ;==>_GenerateGUID


Func _MessageBoxCheck($iFlag, $sTitle, $sText, $sIdentifier, $iDefault, $hWnd, $iTimeout = 0)

	Local $a_iCall = DllCall($hSHLWAPI, "int", 191, _ ; "SHMessageBoxCheckW" exported by ordinal prior Vista
			"hwnd", $hWnd, _
			"wstr", $sText, _
			"wstr", $sTitle, _
			"dword", $iFlag, _
			"int", $iDefault, _
			"wstr", $sIdentifier)

	If @error Or $a_iCall[0] = -1 Then
		Return SetError(1, 0, MsgBox($iFlag, $sTitle, $sText, $iTimeout, $hWnd))
	EndIf

	Return SetError(0, 0, $a_iCall[0])

EndFunc   ;==>_MessageBoxCheck


Func _MD5($sFile) ; will get MD5 using different functions then _GetHashes(). No particular reason why.

	Local $a_hCall = DllCall($hKERNEL32, "hwnd", "CreateFileW", _
			"wstr", $sFile, _
			"dword", 0x80000000, _ ; GENERIC_READ
			"dword", 1, _ ; FILE_SHARE_READ
			"ptr", 0, _
			"dword", 3, _ ; OPEN_EXISTING
			"dword", 0, _ ; SECURITY_ANONYMOUS
			"ptr", 0)

	If @error Or $a_hCall[0] = -1 Then
		Return SetError(1, 0, "")
	EndIf

	Local $hFile = $a_hCall[0]

	$a_hCall = DllCall($hKERNEL32, "ptr", "CreateFileMappingW", _
			"hwnd", $hFile, _
			"dword", 0, _ ; default security descriptor
			"dword", 2, _ ; PAGE_READONLY
			"dword", 0, _
			"dword", 0, _
			"ptr", 0)

	If @error Or Not $a_hCall[0] Then
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(2, 0, "")
	EndIf

	DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFile)

	Local $hFileMappingObject = $a_hCall[0]

	$a_hCall = DllCall($hKERNEL32, "ptr", "MapViewOfFile", _
			"hwnd", $hFileMappingObject, _
			"dword", 4, _ ; FILE_MAP_READ
			"dword", 0, _
			"dword", 0, _
			"dword", 0)

	If @error Or Not $a_hCall[0] Then
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(3, 0, "")
	EndIf

	Local $pFile = $a_hCall[0]
	Local $iBufferSize = FileGetSize($sFile)

	Local $tMD5_CTX = DllStructCreate("dword i[2];" & _
			"dword buf[4];" & _
			"ubyte in[64];" & _
			"ubyte digest[16]")

	DllCall($hADVAPI32, "none", "MD5Init", "ptr", DllStructGetPtr($tMD5_CTX))

	If @error Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(4, 0, "")
	EndIf

	DllCall($hADVAPI32, "none", "MD5Update", _
			"ptr", DllStructGetPtr($tMD5_CTX), _
			"ptr", $pFile, _
			"dword", $iBufferSize)

	If @error Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(5, 0, "")
	EndIf

	DllCall($hADVAPI32, "none", "MD5Final", "ptr", DllStructGetPtr($tMD5_CTX))

	If @error Then
		DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(6, 0, "")
	EndIf

	DllCall($hKERNEL32, "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall($hKERNEL32, "int", "CloseHandle", "hwnd", $hFileMappingObject)

	Local $sMD5 = Hex(DllStructGetData($tMD5_CTX, "digest"))

	Return SetError(0, 0, $sMD5)

EndFunc   ;==>_MD5


Func _CheckSave($iMode = 0)

	If FileExists($sFileAlias) Then

		If $iMode Then

			Local $sName = StringRegExpReplace($sFile, ".*\\", "")
			Local $sDir = StringReplace($sFile, $sName, "")
			Local $sExtension = StringRegExpReplace($sFile, ".*\.", "")

			Local $sSaveFile = FileSaveDialog("Save changes", $sDir, "(*." & StringLower($sExtension) & ")|All files (*.*)", 18, $sName, $hGui)

			If FileCopy($sFileAlias, $sSaveFile, 9) Then
				Return 1
			Else
				MsgBox(48, "Saving failed", "Aborted!            ", 0, $hGui) ; you canceled or maybe access is denied
				Return 0
			EndIf

		Else

			If _MD5($sFileAlias) = $sMD5Original Then
				Return 1
			EndIf

			If MsgBox(262144 + 32 + 4, "Unsaved Changes", "Commited changes not saved." & @CRLF & "Would you like to save it?", 0, $hGui) = 6 Then

				Local $sName = StringRegExpReplace($sFile, ".*\\", "")
				Local $sDir = StringReplace($sFile, $sName, "")
				Local $sExtension = StringRegExpReplace($sFile, ".*\.", "")

				Local $sSaveFile = FileSaveDialog("Save changes", $sDir, "(*." & StringLower($sExtension) & ")|All files (*.*)", 18, $sName, $hGui)

				If FileCopy($sFileAlias, $sSaveFile, 9) Then
					Return 1
				Else
					MsgBox(48, "Saving failed", "Aborted!            ", 0, $hGui) ; you canceled or maybe access is denied
					Return 0
				EndIf

			EndIf
		EndIf
	EndIf

	Return 1

EndFunc   ;==>_CheckSave


Func OnAutoItExit()

	; Clean
	DirRemove($sTemporaryFolder, 1)
	DirRemove($sTemporaryFolder)

EndFunc   ;==>OnAutoItExit
