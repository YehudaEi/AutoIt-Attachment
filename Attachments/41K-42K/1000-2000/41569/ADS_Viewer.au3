
; Script written by trancexx (trancexx at yahoo dot com)
; Donations are wellcome and are accepted via PayPal address: trancexx at yahoo dot com
; Thank you for the shiny stuff :kiss:

; Three functions to enumerate alternate data streams:
; - _ADS_List_NtQuery()
; - _ADS_List_BackupRead()
; - _ADS_List_FindStream()
; First function uses undocummented NtQueryInformationFile function and third uses FindFirstStream->FindNextStream functions that aren't
; supported on older Windows systems.
; GUI has option for you to choose wanted algorithm.


; DLLs to use
Global Const $hNTDLL = DllOpen("ntdll.dll")
Global Const $hKERNEL32 = DllOpen("kernel32.dll")
Global Const $hCRYPT32 = DllOpen("crypt32.dll")
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hSHELL32 = DllOpen("shell32.dll")

; File to load
Global $sFile

; GUI
Global $hGUI = GUICreate("Alternate Data Stream Viewer ", 565, 465, -1, -1, -1, 16) ; $WS_EX_ACCEPTFILES
GUISetIcon("explorer.exe")

; To bring file-open dialog
Global $hButtonBrowse = GUICtrlCreateButton("&Open File...", 15, 28, 75, 25)
GUICtrlSetTip($hButtonBrowse, "Browse for File")

; A label to explain things
GUICtrlCreateLabel("Alternate streams are not listed in Windows Explorer, and their size is not included in the file's size. " & _
		"Use the button on the left to bring file-open dialog to choose file for which to view existing ADS-s. " & _
		"You can grab file and drop it onto the GUI to process it too.", _
		105, 20, 450, 65)

; Treeview to show streams
Global $hTreeViewADS = GUICtrlCreateTreeView(10, 100, 300, 120, 63)

; Edit control to display ADS data
Global $hLabelSizeDisplayed = GUICtrlCreateLabel("", 10, 240, 165, 15) ; little helper label
Global $hEditADS = GUICtrlCreateEdit("", 10, 260, 545, 180, 0x200844, 0x100) ; WS_VSCROLL | ES_READONLY | ES_MULTILINE, WS_EX_WINDOWEDGE
GUICtrlSetBkColor($hEditADS, 0xFFFFFF)
GUICtrlSetFont($hEditADS, 9, 500, -1, "Courier New")

; "Choose algorithm" controls
GUICtrlCreateGroup("Enumeration Algo", 320, 100, 240, 60)
Global $hRadioNT = GUICtrlCreateRadio("NtQuery", 330, 120)
Global $hRadioBCKP = GUICtrlCreateRadio("BackupRead", 395, 120)
Global $hRadioFS = GUICtrlCreateRadio("FindStream", 485, 120)
GUICtrlSetState(_ADS_ReadRadioSetting($hRadioNT, $hRadioBCKP, $hRadioFS), 1) ; $GUI_CHECKED

; Ignore this
HotKeySet("{F5}", "_ADS_A")
Global $hMyTimer, $hMyLabel

; Button for repeated enumeration
Global $hButtonReEnumerate = GUICtrlCreateButton("&ReEnumerate", 480, 170, 80, 25)
GUICtrlSetTip($hButtonReEnumerate, "Enumerate streams in the file using specified algorithm")

; Will show time passed during enumeration
GUICtrlCreateLabel("Elapsed time:", 320, 205, 100, 20)
Global $hLabelTimer = GUICtrlCreateLabel("", 390, 205, 167, 15)
GUICtrlSetFont($hLabelTimer, 10, 700, -1, "Courier New")
GUICtrlSetBkColor($hLabelTimer, 0xFFFFFF)
GUICtrlSetColor($hLabelTimer, 0x0000FF)

; Accept dropped files
GUIRegisterMsg(563, "_ADS_WM_DROPFILES") ; WM_DROPFILES

; Show the GUI
GUISetState()

; Command line can specify file to load
If @Compiled Then $sFile = StringReplace($CmdLineRaw, '"', "")

; Global variables
Global $iViewed, $sLoaded, $iMsg

; Process messages
While 1
	$iMsg = GUIGetMsg()
	Switch $iMsg
		Case -3 ; $GUI_EVENT_CLOSE
			Exit
		Case $hButtonBrowse
			$sFile = FileOpenDialog("ADS Viewer ", "", "All files(*)", 1, "", $hGUI)
		Case $hButtonReEnumerate
			$sFile = $sLoaded ; to trigger enumeration
		Case $hRadioNT, $hRadioBCKP, $hRadioFS
			_ADS_SaveRadioSetting($iMsg, $hRadioNT, $hRadioBCKP, $hRadioFS)
	EndSwitch

	If GUICtrlRead($hTreeViewADS) <> $iViewed Then ; change happened
		$iViewed = GUICtrlRead($hTreeViewADS)
		If $iViewed Then
			If StringLeft(GUICtrlRead($iViewed, 1), 1) = ":" Then ; ADS
				_ADS_DisplayStreams($sLoaded, GUICtrlRead($iViewed, 1), $hEditADS, $hLabelSizeDisplayed)
			Else ; main stream (file)
				_ADS_DisplayStreams($sLoaded, "", $hEditADS, $hLabelSizeDisplayed)
			EndIf
		EndIf
	EndIf

	; If $sFile is set to something then process it
	If $sFile Then
		GUISetCursor(15, 1)
		GUISetState(@SW_LOCK, $hGUI)
		GUICtrlSetData($hEditADS, "")
		_ADS_ShowStreams(BitAND(GUICtrlRead($hRadioNT), 1) * 1 + BitAND(GUICtrlRead($hRadioBCKP), 1) * 2 + BitAND(GUICtrlRead($hRadioFS), 1) * 4, $sFile, $hTreeViewADS, $hLabelTimer)
		_ADS_DisplayStreams($sFile, "", $hEditADS, $hLabelSizeDisplayed)
		GUISetState(@SW_UNLOCK, $hGUI)
		GUISetCursor(-1)
		GUICtrlSetData($hButtonBrowse, "&New File...")
		$sLoaded = $sFile
		$sFile = ""
	EndIf

	; Nothing smart, ignore it
	If $hMyTimer Then
		If TimerDiff($hMyTimer) > 1500 Then
			GUICtrlSetState($hMyLabel, 32) ; $GUI_HIDE
			$hMyTimer = 0
		EndIf
	EndIf
WEnd

; That's it. Nothing more.
; Some boring functions down below and three super-cool enumeration functions...


Func _ADS_A()
	If Not $hMyLabel Then
		$hMyLabel = GUICtrlCreateLabel(BinaryToString("0x7472616E63657878206D6164652074686973"), 320, 174, 150, 25)
		GUICtrlSetFont($hMyLabel, 9, 600, 1, "Courier New", 5)
		GUICtrlSetColor($hMyLabel, 0x9999ff)
		GUICtrlSetState($hMyLabel, 32)
	EndIf
	HotKeySet("{F5}")
	Send("{F5}")
	GUICtrlSetState($hMyLabel, 16)
	Local $aGUIPos = ControlGetPos($hGUI, 0, $hMyLabel)
	For $i = 1 To 40
		$aGUIPos[0] += 14 * Sin(9 * $i)
		$aGUIPos[1] += 9 * Cos(9 * $i)
		WinMove(GUICtrlGetHandle($hMyLabel), 0, $aGUIPos[0], $aGUIPos[1])
		Sleep(10)
	Next
	$hMyTimer = TimerInit()
	WinMove(GUICtrlGetHandle($hMyLabel), 0, $aGUIPos[0] - 8, $aGUIPos[1] + 5)
	HotKeySet("{F5}", "_ADS_A")
EndFunc

;======================================================
; GUI helper functions
Func _ADS_RebuildTreeView(ByRef $hTreeViewControl) ; Destroys the old treeview and builds the new one to free resources
	Local $aTreeViewPos = ControlGetPos($hGUI, 0, $hTreeViewControl)
	GUICtrlDelete($hTreeViewControl)
	$hTreeViewControl = GUICtrlCreateTreeView($aTreeViewPos[0], $aTreeViewPos[1], $aTreeViewPos[2], $aTreeViewPos[3], 63)
	GUICtrlSendMsg($hTreeViewControl, 4379, 18, 0) ; set size
EndFunc

Func _ADS_ShowStreams($iAlgo, $sFile, ByRef $hTreeView, $hLabel = 0) ; Enumerates ADS-s using wanted algorithm
	; Clear the old treeview
	_ADS_RebuildTreeView($hTreeView)
	; Enumerate streams
	Local $aArray, $hTimer = TimerInit()
	; What's wanted
	Switch $iAlgo
		Case 1
			$aArray = _ADS_List_NtQuery($sFile)
		Case 2
			$aArray = _ADS_List_BackupRead($sFile)
		Case 4
			$aArray = _ADS_List_FindStream($sFile)
	EndSwitch
	; See how much ime it took
	Local $iDiff = TimerDiff($hTimer)
	; If label control is passed then set data to it
	If $hLabel Then GUICtrlSetData($hLabel, " " & Round($iDiff, 3) & " ms")
	; Build treeview items based on the results of the enumeration
	Local $iMainItem = GUICtrlCreateTreeViewItem(StringRegExpReplace($sFile, ".*\\", ""), $hTreeView)
	Local $bIsFile = StringInStr(FileGetAttrib($sFile), "D") = 0
	If $bIsFile Then
		GUICtrlSetImage($hTreeView, @SystemDir & "\shell32.dll", 152)
	Else
		GUICtrlSetImage($hTreeView, @SystemDir & "\shell32.dll", 5)
	EndIf
	If IsArray($aArray) Then
		if $bIsFile Then GUICtrlSetImage($hTreeView, @SystemDir & "\shell32.dll", 133)
		For $sElem In $aArray
			GUICtrlSetImage(GUICtrlCreateTreeViewItem($sElem, $iMainItem), @SystemDir & "\shell32.dll", 152)
		Next
	EndIf
	; Shaw what's viewed
	GUICtrlSetState($iMainItem, 256 + 512 + 1024) ; $GUI_FOCUS | $GUI_DEFBUTTON | $GUI_EXPAND
EndFunc

Func _ADS_DisplayStreams($sFile, $sStream, $hEdit, $hLabel = 0) ; Prints stream data as formatted hex string
	Local $iBinarySize
	GUICtrlSetData($hEdit, _ADS_HexEncode($sFile, $iBinarySize, $sStream))
	If $hLabel Then GUICtrlSetData($hLabel, "- Showing " & $iBinarySize & " bytes:")
EndFunc
;======================================================


;======================================================
; Proccessing files dropped onto the GUI
Func _ADS_WM_DROPFILES($hWnd, $iMsg, $wParam, $lParam)
	#forceref $iMsg, $lParam
	If $hWnd = $hGUI Then
		$sFile = _ADS_DragQueryFile($wParam)
		If @error Then
			_ADS_MessageBeep(48)
			Return 1
		EndIf
		_ADS_DragFinish($wParam)
		Return 1
	EndIf
	_ADS_MessageBeep(48)
	Return 1
EndFunc
;======================================================


;======================================================
; Functions to handle dropped files
Func _ADS_DragQueryFile($hDrop, $iIndex = 0)
	Local $aCall = DllCall($hSHELL32, "dword", "DragQueryFileW", _
			"handle", $hDrop, _
			"dword", $iIndex, _
			"wstr", "", _
			"dword", 32767)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	Return $aCall[3]
EndFunc

Func _ADS_DragFinish($hDrop)
	DllCall($hSHELL32, "none", "DragFinish", "handle", $hDrop)
EndFunc

Func _ADS_MessageBeep($iType)
	DllCall($hUSER32, "int", "MessageBeep", "dword", $iType)
EndFunc
;======================================================


;======================================================
; A bit playing with ADS to save settings
Func _ADS_ReadRadioSetting($hNT, $hBCKP, $hFS) ; Reads ADS
	Local $iRead = Int(_ADS_ReadBinary(@ScriptFullPath, ":RADIO_SETTING"))
	Local $iOut = $hNT ; default output
	Switch $iRead
		Case 1
			$iOut = $hBCKP
		Case 2
			$iOut = $hFS
	EndSwitch
	Return $iOut
EndFunc

Func _ADS_SaveRadioSetting($iSetting, $hNT, $hBCKP, $hFS) ; Writes to ADS
	Local $iToWrite = 0 ; default setting
	Switch $iSetting
		Case $hBCKP
			$iToWrite = 1
		Case $hFS
			$iToWrite = 2
	EndSwitch
	DllCall($hKERNEL32, "bool", "DeleteFileW", "wstr", @ScriptFullPath & ":RADIO_SETTING")
	Local $hFile = FileOpen(@ScriptFullPath & ":RADIO_SETTING", 18)
	If $hFile = -1 Then Return SetError(1, 0, 0)
	FileWrite($hFile, $iToWrite)
	FileClose($hFile)
	Return 1
EndFunc
;======================================================


;======================================================
; Binary reading and formatting
Func _ADS_ReadBinary($sFile, $sStream = "", $iSize = 1024) ; Reads ADS as binary data
	; Open stream for reading in binary mode
	Local $hFile = FileOpen($sFile & $sStream, 16)
	If $hFile = -1 Then Return ""
	; Read file in specified size
	Local $bOut = FileRead($hFile, $iSize)
	FileClose($hFile)
	; That's all
	Return $bOut
EndFunc

Func _ADS_HexEncode($sFile, ByRef $iSizeProccessed, $sStream = "", $iSize = 1024)
	$iSizeProccessed = 0 ; preset
	; Read ADS data as binary
	Local $bInput = _ADS_ReadBinary($sFile, $sStream, $iSize)
	; Determine the size of binary data
	Local $iSizeIn = BinaryLen($bInput)
	; Create structure to hold the data
	Local $tInput = DllStructCreate("byte[" & $iSizeIn & "]")
	; Fill it
	DllStructSetData($tInput, 1, $bInput)
	; First call is to determine the size of the output buffer
	Local $aCall = DllCall($hCRYPT32, "int", "CryptBinaryToStringA", _
			"struct*", $tInput, _
			"dword", $iSizeIn, _
			"dword", 11, _ ; CRYPT_STRING_HEXASCIIADDR
			"ptr", 0, _
			"dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, "")
	; Collect the size
	Local $iSizeOut = $aCall[5]
	; Make output buffer
	Local $tOut = DllStructCreate("char[" & $iSizeOut & "]")
	; 'Real' call
	$aCall = DllCall($hCRYPT32, "int", "CryptBinaryToStringA", _
			"struct*", $tInput, _
			"dword", $iSizeIn, _
			"dword", 11, _ ; CRYPT_STRING_HEXASCIIADDR
			"ptr", DllStructGetPtr($tOut), _
			"dword*", $iSizeOut)
	If @error Or Not $aCall[0] Then Return SetError(2, 0, "")
	$iSizeProccessed = $iSizeIn
	; Return formatted string
	Return "===========================================================================" & @CRLF & _
			"Offset  0  1  2  3  4  5  6  7   8  9  a  b  c  d  e  f         ASCII" & @CRLF & _
			"===========================================================================" & _
			@CRLF & DllStructGetData($tOut, 1) & _
			"==========================================================================="
EndFunc
;======================================================


;======================================================
; Three super-cool ADS enumeration functions
Func _ADS_List_NtQuery($sFile)
	Local $hFile = _ADS_CreateFile($sFile, 0, 0x00000001, 3, 0x02000000) ; GENERIC_READ, FILE_SHARE_READ, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS
	If @error Then Return SetError(1, 0, 0)
	Local $tagFILE_STREAM_INFORMATION = "ulong NextEntryOffset;" & _
			"ulong StreamNameLength;" & _
			"dword StreamSize[2];" & _
			"dword StreamAllocationSize[2];"
	Local $tByte, $iAllocSize = 512 ; initial size of the buffer
	Local $IO_STATUS_BLOCK = DllStructCreate("long Status;ulong_ptr Information;")
	While 1
		$tByte = DllStructCreate("byte[" & $iAllocSize & "]")
		Local $aCall = DllCall($hNTDLL, "long", "NtQueryInformationFile", _
				"handle", $hFile, _
				"struct*", $IO_STATUS_BLOCK, _
				"struct*", $tByte, _
				"ulong", DllStructGetSize($tByte), _
				"ulong", 22) ; FileStreamInformation
		If @error Or $aCall[0] = 0xC000000D Then ExitLoop ; STATUS_INVALID_PARAMETER is returned for unsupported file systems
		; Check if reading information was successful and if not try again with bigger buffer
		If DllStructGetData($IO_STATUS_BLOCK, "Information") <> 0 And DllStructGetData($IO_STATUS_BLOCK, "Status") = 0 Then ExitLoop
		If $iAllocSize > 262144 Then ExitLoop ; this size would just be super-mad, avoid processing
		$iAllocSize *= 2 ; double the size of the buffer
	WEnd
	Local $i = 1, $aOut[1]
	Local $tFILE_STREAM_INFORMATION, $iStringSize
	Local $pPointer = DllStructGetPtr($tByte)
	While 1
		$tFILE_STREAM_INFORMATION = DllStructCreate($tagFILE_STREAM_INFORMATION, $pPointer)
		$iStringSize = DllStructGetData($tFILE_STREAM_INFORMATION, "StreamNameLength")
		If $iStringSize > 14 Then ; No-name stream will have 14 bytes name ::$DATA
			ReDim $aOut[$i]
			$aOut[$i - 1] = StringRegExpReplace(DllStructGetData(DllStructCreate("wchar[" & $iStringSize / 2 & "]", $pPointer + DllStructGetSize($tFILE_STREAM_INFORMATION)), 1), "(.*):.*", "$1")
			$i += 1
		EndIf
		If DllStructGetData($tFILE_STREAM_INFORMATION, "NextEntryOffset") = 0 Then ExitLoop
		$pPointer += DllStructGetData($tFILE_STREAM_INFORMATION, "NextEntryOffset")
	WEnd
	; Close the file
	_ADS_CloseHandle($hFile)
	; Return either array or 0
	If UBound($aOut) = 1 And Not $aOut[0] Then Return 0
	Return $aOut
EndFunc

Func _ADS_List_BackupRead($sFile)
	Local $hFile = _ADS_CreateFile($sFile, 0x80000000, 0x00000001, 3, 0x02000000) ; GENERIC_READ, FILE_SHARE_READ, OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS
	If @error Then Return SetError(1, 0, 0)
	Local $tWIN32_STREAM_ID_HEAD = DllStructCreate("dword dwStreamId;" & _
			"dword dwStreamAttributes;" & _
			"dword Size[2];" & _
			"dword dwStreamNameSize;")
	Local $pContext = 0, $i = 1, $tWIN32_STREAM_ID_NAME, $aOut[1]
	While 1
		; Read to stream header
		If Not _ADS_BackupRead($hFile, $tWIN32_STREAM_ID_HEAD, DllStructGetSize($tWIN32_STREAM_ID_HEAD), $pContext) Then ExitLoop
		If DllStructGetData($tWIN32_STREAM_ID_HEAD, "dwStreamNameSize") Then
			; Allocate string
			$tWIN32_STREAM_ID_NAME = DllStructCreate("wchar cStreamName[" & DllStructGetData($tWIN32_STREAM_ID_HEAD, "dwStreamNameSize") / 2 & "];")
			; Read to it
			_ADS_BackupRead($hFile, $tWIN32_STREAM_ID_NAME, DllStructGetSize($tWIN32_STREAM_ID_NAME), $pContext)
			; Redim array and set new element
			ReDim $aOut[$i]
			$aOut[$i - 1] = StringRegExpReplace(DllStructGetData($tWIN32_STREAM_ID_NAME, "cStreamName"), "(.*):.*", "$1")
			$i += 1
		EndIf
		; Skip the stream body
		_ADS_BackupSeek($hFile, DllStructGetData($tWIN32_STREAM_ID_HEAD, "Size", 1), $pContext)
	WEnd
	; Free Context
	_ADS_BackupRead(0, 0, 0, $pContext)
	; Close the file
	_ADS_CloseHandle($hFile)
	; Return either array or 0
	If UBound($aOut) = 1 And Not $aOut[0] Then Return 0
	Return $aOut
EndFunc

Func _ADS_List_FindStream($sFile)
	Local $tWIN32_FIND_STREAM_DATA = DllStructCreate("int64 StreamSize; wchar cStreamName[292]")
	Local $hHandle = _ADS_FindFirstStreamW($sFile, $tWIN32_FIND_STREAM_DATA)
	If Not $hHandle Or $hHandle = -1 Then Return 0
	; $tWIN32_FIND_STREAM_DATA is now filled with the first stream data and that is the main stream - the file itself.
	; I'm not interested in that for files, but for folders there could be data there.
	Local $i = 1, $aOut[1]
	Local $sFirstStream = StringRegExpReplace(DllStructGetData($tWIN32_FIND_STREAM_DATA, "cStreamName"), "(.*):.*", "$1")
	If $sFirstStream <> ":" Then ; does the name exist?
		$aOut[0] = $sFirstStream
		$i = 2
	EndIf
	; I also need to loop through all other streams and collect fom there.
	While _ADS_FindNextStreamW($hHandle, $tWIN32_FIND_STREAM_DATA)
		ReDim $aOut[$i]
		$aOut[$i - 1] = StringRegExpReplace(DllStructGetData($tWIN32_FIND_STREAM_DATA, "cStreamName"), "(.*):.*", "$1")
		$i += 1
	WEnd
	; "Find" handle needs closing when done.
	_ADS_FindClose($hHandle)
	; Return either array or 0
	If UBound($aOut) = 1 And Not $aOut[0] Then Return 0
	Return $aOut
EndFunc
;======================================================


;======================================================
; Helper functions directly related to ADS enumeration
Func _ADS_CreateFile($sFile, $iAccess, $iShareMode, $iDisposition, $iFlag = 0)
	Local $aCall = DllCall($hKERNEL32, "handle", "CreateFileW", _
			"wstr", $sFile, _
			"dword", $iAccess, _
			"dword", $iShareMode, _
			"ptr", 0, _
			"dword", $iDisposition, _
			"dword", $iFlag, _
			"ptr", 0)
	If @error Or $aCall[0] = -1 Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc

Func _ADS_CloseHandle($hHandle)
	Local $aCall = DllCall($hKERNEL32, "bool", "CloseHandle", "handle", $hHandle)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc

Func _ADS_BackupRead($hFile, $tBuffer, $iSizeBuffer, ByRef $pContext, $bAbort = 0, $bProcessSecurity = 0)
	Local $aCall = DllCall($hKERNEL32, "bool", "BackupRead", _
			"handle", $hFile, _
			"struct*", $tBuffer, _
			"dword", $iSizeBuffer, _
			"dword*", 0, _
			"bool", $bAbort, _
			"bool", $bProcessSecurity, _
			"ptr*", $pContext)
	If @error Then Return SetError(1, 0, 0)
	$pContext = $aCall[7]
	If Not $aCall[4] Or ($aCall[4] <> $iSizeBuffer) Then Return 0
	Return $aCall[0]
EndFunc

Func _ADS_BackupSeek($hFile, $iSize, $pContext)
	Local $aCall = DllCall($hKERNEL32, "bool", "BackupSeek", _
			"handle", $hFile, _
			"dword", $iSize, _
			"dword", 0, _
			"dword*", 0, _
			"dword*", 0, _
			"ptr*", $pContext)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc

Func _ADS_FindNextStreamW($hHandle, $pBuffer)
	Local $aCall = DllCall($hKERNEL32, "bool", "FindNextStreamW", "handle", $hHandle, "struct*", $pBuffer)
	If @error Then Return 0
	Return $aCall[0]
EndFunc

Func _ADS_FindClose($hHandle)
	Local $aCall = DllCall($hKERNEL32, "bool", "FindClose", "handle", $hHandle)
	If @error Then Return 0
	Return $aCall[0]
EndFunc

Func _ADS_FindFirstStreamW($sFile, $pBuffer)
	Local $aCall = DllCall($hKERNEL32, "handle", "FindFirstStreamW", "wstr", $sFile, "int", 0, "struct*", $pBuffer, "dword", 0)
	If @error Then Return -1
	Return $aCall[0]
EndFunc
;======================================================
