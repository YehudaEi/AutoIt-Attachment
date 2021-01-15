; AutoIt Version: 3.2.4.1
; ===============================================================================================================================
; Description ...: Routines to manipulate Outlook Express
; Author ........: Steve Bateman (MisterBates)
; Remarks/Notes .: OE has no public API, so these routines manipulate a visible OE instance ...
;                  These routines are *incredibly* ill-behaved and will keep OE maximized and activated !!!!
;                  Contains an _ArrayAddItem() function based on _ArrayAdd(), as well as a newly created _ArrayAppend()
; The following routines are included in this UDF:
; _OE_Start()                                       - Starts and/or connectes to Outlook Express
; _OE_Finish($hOE)                                  - Closes Outlook Express
; _OE_CloseChildren($hOE)                           - Closes any open child windows, leaving only the main OE window showing
; _OE_GetPropertyValue($sProperties, $sName)        - Gets a specific property value from @LF-separated name:value properties
; _OE_FolderGetName($hOE)                           - Returns the name of the currently selected folder
; _OE_FolderGetProperties($hOE)                     - Returns @LF-separated name:value string for the current folder
; _OE_FolderGoto($hOE, $sFolder)                    - Go to a specific folder (fully-qualified or first-matching)
; _OE_FolderHasSubfolders($hOE, $sFolder="")        - Returns True if the current folder has subfolders
; _OE_FolderList($hOE, $bHierarchical=True)         - Returns an array of folder names
; _OE_FolderMoveFirst($hOE)                         - Moves to (selects) the first folder - this is normally "Outlook Express"
; _OE_FolderMoveNext($hOE, $bExpandSubfolders=True) - Moves to the next folder or subfolder
; _OE_FolderNumMessages($hOE, $sFolder="")          - Returns the number of messages in the current folder
; _OE_FolderNumUnread($hOE, $sFolder="")            - Returns the number of unread messages in the current folder
; _OE_MessageGetProperties($hOE, $bBodyText=False, $iMaxBodyText=0) - Returns @LF-separated name:value string for current message
; _OE_MessageGetSubject($hOE)                       - Returns subject of the current message
; _OE_MessageMoveFirst($hOE, $sFolder="", $bSubject=True) - Moves to (selects) the first message in the current folder
; _OE_MessageMoveNext($hOE, $bSubject=True)         - Moves to (selects) the next nmessage in the current folder
; _OE_PaneActivate($hOE, $sPane = "Folders")        - Activates the Folders or Messages pane
; _OE_PaneChecksum($hOE, $sPane = "Folders")        - Returns the Pixelchecksum for the Folders or Messages pane
; _ArrayAddItem(ByRef $avArray, $sValue, $bOneBased = False) - Adds an item to an array - also works with one-based arrays
; _ArrayAppend(ByRef $avArray, $avAppend, $bOneBased = False) - Appends an array to another, zero- or one-based
; ===============================================================================================================================
#include <array.au3>
; ===============================================================================================================================
; Global Variables
; ===============================================================================================================================
Const $iWaitOERunning = 30000 ; Milliseconds to wait to detect OE main window
Const $iWaitOEInitialize = 15000 ; Milliseconds to wait for OE to initialize on startup
Const $iWaitScreenUpdate = 500 ; Milliseconds to wait for OE to update/repaint the screen
Const $iWaitDetectChange = 1000 ; Max Milliseconds to try to detect change in folder/messages panes
Const $iWaitDetectChangeFolders = 500 ; Max Milliseconds to try to detect change in folder pane
Const $iTryDetectChange = 10 ; Number of attempts to detect a change
; ===============================================================================================================================
; Function ......: _OE_Start - starts/connects to an instance of Outlook Express
; Parameters ....: 
; Return values .: $hOE      - non-zero handle to Outlook Express (if successful)
;									 0         - if unsuccessful and sets @error as follows:
;										           1 - Unable to 'run' OE - check @extended for WinAPI error information
;                              2 - Successful 'run', but unable to find the new OE process
;                              3 - Unable to adjust the window to be visible, enabled and maximized
; Dependencies ..: _OE_Valid()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_Start()
	Local $hOE
	AutoItSetOption("WinTitleMatchMode", 4) ; advanced title match mode
	AutoItSetOption("RunErrorsFatal", 0) ; return error if run commands don't work
	$hOE = WinGetHandle("[CLASS:Outlook Express Browser Class]")
	if $hOE = 0 Then ; OE not running, run it
		Run("C:\Program Files\Outlook Express\msimn.exe", @UserProfileDir, @SW_MAXIMIZE)
		if WinWaitActive("[CLASS:Outlook Express Browser Class]", "", $iWaitOERunning / 1000) Then
			$hOE = WinGetHandle("[CLASS:Outlook Express Browser Class]")
			Sleep($iWaitOEInitialize) ; Give OE time to initialize
		Else
			SetError(2)
			Return
		EndIf
	EndIf
	AutoItSetOption("WinTitleMatchMode", 1) ; reset to default
	AutoItSetOption("RunErrorsFatal", 1) ; reset to default
  if not _OE_Valid($hOE) Then
		SetError(@error + 1, @extended)
		return 0
	EndIf
	Return $hOE
EndFunc   ;==>_OE_Start

; ===============================================================================================================================
; Function ......: _OE_Finish - terminates OE instance
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: True      - if successful
;									 False     - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Unable to terminate the OE process
; Dependencies ..: _OE_Valid()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_Finish($hOE)
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		Return False
	EndIf
	if not WinClose($hOE) Then
		SetError(3)
		Return False
	EndIf
	Return True
EndFunc   ;==>_OE_Finish

; ===============================================================================================================================
; Function ......: _OE_CloseChildren - closes all OE child windows, leaving just the main OE window
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: True      - if successful
;									 False     - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Unable to close one or more child windows
; Dependencies ..: _OE_Valid()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_CloseChildren($hOE)
	Local $iCount = 0
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		Return False
	EndIf
	$hOEProcess = WinGetProcess("[CLASS:Outlook Express Browser Class]") ; find OE process ID
	; Try to close the child windows
	$aWindows = WinList("") ; Find candidate windows
	For $iI = 1 to $aWindows[0][0]
		; Look for windows with same PID as OE, different handle and excluding standard hidden OE child window
		if $aWindows[$iI][1] <> $hOE And WinGetProcess($aWindows[$iI][1]) = $hOEProcess and _
				StringInStr(WinGetClassList($aWindows[$iI][1]), "msctls_progress32") = 0 Then
			$iCount += 1
			WinClose($aWindows[$iI][1])
		EndIf
	Next
	if $iCount > 0 Then
		Sleep(5 * 1000)
		; See if any child windows remain
		$aWindows = WinList("") ; Find candidate windows
		For $iI = 1 to $aWindows[0][0]
			; Look for windows with same PID as OE, different handle and excluding standard hidden OE child window
			if $aWindows[$iI][1] <> $hOE And WinGetProcess($aWindows[$iI][1]) = $hOEProcess and _
					StringInStr(WinGetClassList($aWindows[$iI][1]), "msctls_progress32") = 0 Then
				SetError(3, 0, False)
				ExitLoop
			EndIf
		Next
	EndIf
	Return True
EndFunc   ;==>_OE_CloseChildren

; ===============================================================================================================================
; Function ......: _OE_FindPropertiesDialog - Find the OE properties dialog and return the handle
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: $hDialog  - handle to the OE properties dialog
;									 0         - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Could not get handle to OE properties dialog
; Dependencies ..: _OE_Valid()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FindPropertiesDialog($hOE)
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return ""
	EndIf
	$hDialog = 0
	$hOEProcess = WinGetProcess("[CLASS:Outlook Express Browser Class]") ; find OE process ID
	$aWindows = WinList("[Class:#32770]") ; Find candidate windows
	For $iI = 1 to $aWindows[0][0]
		; Look for windows with same PID as OE, different handle and excluding standard hidden OE child window
		if $aWindows[$iI][1] <> $hOE And WinGetProcess($aWindows[$iI][1]) = $hOEProcess and _
				StringInStr(WinGetClassList($aWindows[$iI][1]), "msctls_progress32") = 0 Then
			$hDialog = $aWindows[$iI][1]
			ExitLoop
		EndIf
	Next
  if $hDialog = 0 Then
		SetError(5)
		Return 0
	EndIf
	Return $hDialog
EndFunc   ;==>_OE_FindPropertiesDialog

; ===============================================================================================================================
; Function ......: _OE_GetPropertyValue - Return a property value from a linefeed-separated property string
; Parameters ....: $sProperties - @LF-separated list of properties, with each property in format "name: value"
;                  $sName    - Name of the property to return
; Return values .: $sValue   - property value.
;									 ""        - if unsuccessful and sets @error as follows:
;										           1 - Could not find property name
; Dependencies ..:
; Remarks/Notes .:
; ===============================================================================================================================
Func _OE_GetPropertyValue($sProperties, $sName)
	$asProperties = StringSplit($sProperties, @LF)
	; Try to find the property
	$bFound = False
	$iItem = 1
	While not $bFound and $iItem > 0
		$iItem = _ArraySearch($asProperties, $sName & ":", $iItem, $asProperties[0], 0, True)
		if $iItem >= 0 Then
			If StringInStr($asProperties[$iItem], $sName) = 1 Then 
				$bFound = True
			Else
				$iItem += 1
			EndIf
		EndIf
	WEnd
	if $iItem < 0 Then
		SetError(1)
		Return ""
	EndIf
	$sValue = StringStripWS(StringMid($asProperties[$iItem], StringInStr($asProperties[$iItem], ":") + 1), 1) ; Remove Name
	Return $sValue
EndFunc   ;==>_OE_GetProperty

; ===============================================================================================================================
; Function ......: _OE_FolderGetName - Get the name of the current folder (from the OE Title)
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: $sFolder  - Name of the current folder
;									 ""        - if unsuccessful, and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
; Dependencies ..: 
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderGetName($hOE)
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return ""
	EndIf
	$sFolder = WinGetTitle($hOE)
	if StringInStr($sFolder, " - Outlook Express") > 0 Then
		$sFolder = StringLeft($sFolder, StringInStr($sFolder, " - Outlook Express") - 1)
	Else
		$sFolder = "Outlook Express"
	EndIf
	Return $sFolder
EndFunc   ;==>_OE_FolderGetName

; ===============================================================================================================================
; Function ......: _OE_FolderGetProperties - Returns a string containing a linefeed-separated list of properties "name: value"
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: $sProperties- Properties for the current folder formatted as name:value with @LF separators
;									 ""        - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Could not get handle to folder properties dialog
; Dependencies ..: 
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderGetProperties($hOE)
	Local $asProperties[1] = [0]
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return ""
	EndIf
	$hPane = _OE_PaneActivate($hOE, "Folders")
	if @error <> 0 Then
		SetError(@error, @extended)
		Return ""
	EndIf
	$sSubject = ""
	ControlSend($hOE, "", $hPane, "!{ENTER}")  ; Look at folder properties [ALT]+[ENTER]
	$hDialog = _OE_FindPropertiesDialog($hOE)
	$iI = 0
	While $iI < $iTryDetectChange and $hDialog = 0 ; Wait to be sure dialog has appeared
		Sleep($iWaitDetectChangeFolders / $iTryDetectChange)
		$hDialog = _OE_FindPropertiesDialog($hOE)
		$iI += 1
	WEnd
	if $hDialog = 0 Then
		SetError(5)
		Return ""
	EndIf
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated/dialog is ready
	; Get and format the properties from the tab
	$sProperties = WinGetText($hDialog)
	$asRawProperties = StringSplit($sProperties, @lf)
	if $asRawProperties[0] < 1 Then
		ControlSend($hDialog, "", "[CLASS:Button; TEXT:Cancel]", "{ESC}")
		SetError(6)
		Return ""
	EndIf
	_ArrayAddItem($asProperties, "Name: " & $asRawProperties[2], True) ; first property is tab name, second is folder name
	For $iN = 3 to $asRawProperties[0]
		If StringRight($asRawProperties[$iN], 1) = ":" and $iN < $asRawProperties[0] Then
			_ArrayAddItem($asProperties, $asRawProperties[$iN] & " " & $asRawProperties[$iN + 1], True)
			$iN += 1
		Else
			Switch $asRawProperties[$iN]
				Case "OK", "Cancel", "&Apply", ""
				Case Else
					_ArrayAddItem($asProperties, "<Unknown>: " & $asRawProperties[$iN], True)
			EndSwitch
		EndIf
	Next
	ControlSend($hDialog, "", "[CLASS:Button; TEXT:Cancel]", "{ESC}")
	$iI = 0
	While $iI < $iTryDetectChange and WinExists($hDialog)
		Sleep($iWaitDetectChangeFolders / $iTryDetectChange) ; wait for dialog to close, so as not to interfere with other OE UDFs
		$iI += 1
	WEnd
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated
	_ArraySort($asProperties, 0, 1, $asProperties[0])
	Return _ArrayToString($asProperties, @LF, 1, $asProperties[0])
EndFunc   ;==>_OE_FolderGetProperties

; ===============================================================================================================================
; Function ......: _OE_FolderGoto - Go to a named folder
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sFolder  - Folder to go to
;                              - If fully qualified (with "\" in the folder name), will go to the actual folder
;                              - If not fully qualified (no "\" in the folder name), will go to the first matching folder
; Return values .: $sFolder  - Folder name if successful (fully-qualified or simple)
;									 ""        - if unsuccessful, and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Unable to goto folder - could not find a match
; Dependencies ..: _OE_FolderMoveFirst(), _OE_FolderMoveNext()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
;                  Fully-qualified name can contain an optional trailing "\" - can fully-qualify a first-level folder
; ===============================================================================================================================
Func _OE_FolderGoto($hOE, $sFolder)
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return ""
	EndIf
	if StringInStr($sFolder, "\") > 0 Then
		$asFolderNames = StringSplit($sFolder, "\")
		if $asFolderNames[$asFolderNames[0]] = "" Then $asFolderNames[0] -= 1 ; allow for trailing "\"
		$sNextFolder = _OE_FolderMoveFirst($hOE)
		if @error <> 0 Then
			SetError(@error, @extended)
			Return ""
		EndIf
	  for $iFolderPart = 1 to $asFolderNames[0]
			While $sNextFolder <> "" And $sNextFolder <> $asFolderNames[$iFolderPart]
				$sNextFolder = _OE_FolderMoveNext($hOE, False)
			WEnd
			if $sNextFolder = "" Then
				SetError(5)
				Return ""
			ElseIf $sNextFolder = $asFolderNames[$iFolderPart] and $iFolderPart < $asFolderNames[0] Then
				$sNextFolder = _OE_FolderMoveNext($hOE, True)
			EndIf
		Next
		Return $sFolder
	Else
		$sNextFolder = _OE_FolderMoveFirst($hOE)
		if @error <> 0 Then
			SetError(@error)
			Return ""
		EndIf
		While $sNextFolder <> "" And $sNextFolder <> $sFolder
			$sNextFolder = _OE_FolderMoveNext($hOE, True)
		WEnd
		if $sNextFolder = "" Then
			SetError(5)
			Return ""
		Else
			Return $sFolder
		EndIf
	EndIf
EndFunc   ;==>_OE_FolderGoto

; ===============================================================================================================================
; Function ......: _OE_FolderHasSubfolders - Check to see if a folder has subfolders
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sFolder  - Folder for which to get the count - if blank, get it for current folder
; Return values .: $bHasSubs - True if the folder has subfolders, false if not or if error. If error, @Error set to:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Unable to goto folder - could not find a match
; Dependencies ..: _OE_PaneActivate(), _OE_PaneChecksum()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderHasSubfolders($hOE, $sFolder="")
	$hPane = _OE_PaneActivate($hOE, "Folders")
	if @error <> 0 Then
		SetError(@error, @extended)
		Return False
	EndIf
	if $sFolder <> "" Then
		$sFolder = _OE_FolderGoto($hOE, $sFolder)
		if $sFolder	= "" Then
			SetError(@error, @extended)
			return False
		EndIf
	EndIf
	sleep($iWaitScreenUpdate) ; wait for OE to finish refreshing
	$iChecksum = _OE_PaneChecksum($hOE, $hPane)
	ControlSend($hOE, "", $hPane, "{NUMPADADD}") ; Expand subfolders (if any)
	; Did the folder pane change? Wait for OE to reflect the change
	$iI = 0
	while ($iI < $iTryDetectChange) and (_OE_PaneChecksum($hOE, $hPane) = $iChecksum)
		sleep($iWaitDetectChangeFolders / $iTryDetectChange)
		$iI += 1
	WEnd
	if _OE_PaneChecksum($hOE, $hPane) = $iChecksum Then ; no change yet
		ControlSend($hOE, "", $hPane, "{NUMPADSUB}") ; Collapse subfolders (if any)
		; Did the folder pane change? Wait for OE to reflect the change
		$iI = 0
		while ($iI < $iTryDetectChange) and (_OE_PaneChecksum($hOE, $hPane) = $iChecksum)
			sleep($iWaitDetectChangeFolders / $iTryDetectChange)
			$iI += 1
		WEnd
	EndIf
	Return (_OE_PaneChecksum($hOE, $hPane) <> $iChecksum)
EndFunc   ;==>_OE_FolderHasSubfolders

; ===============================================================================================================================
; Function ......: _OE_FolderList - Return a list of fully qualified folder names in OE
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $bHierarchical - If True, returns list of fully-qualified folders, else returns folder names as they appear
; Return values .: $asFolders- array of folder names, with count in $asFolders[0]
;									 ""        - if unsuccessful, and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
; Dependencies ..: _OE_FolderMoveFirst(), _OE_FolderMoveNext(), _OE_FolderSubfolderList()
;                  _ArrayAddItem(), _ArrayAppend()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderList($hOE, $bHierarchical=True)
	Local $asMyFolders[1] = [0], $asSubFolders[1] = [0], $asFolders[1] = [0]
  if not _OE_Valid($hOE) Then
		SetError(@error)
		return ""
	EndIf
	if $bHierarchical Then
		; Process first-level folder(s)
		$sFolder = _OE_FolderMoveFirst($hOE)
		if @error <> 0 Then
			SetError(@error)
			Return ""
		EndIf
		_OE_FolderHasSubfolders($hOE) ; Prevents getting two top-level folders in folder list
		While $sFolder <> ""
			_ArrayAddItem($asMyFolders, $sFolder, True)
			$sFolder = _OE_FolderMoveNext($hOE, False)
		WEnd
		; Process each first-level folder to get subfolders (and so on down)
		For $iFolderNum = 1 to $asMyFolders[0]
			; Add the current first-level folder to the result set
			_ArrayAddItem($asFolders, $asMyFolders[$iFolderNum], True)
			; get subfolders (and sub-subfolders etc.)
			$asSubFolders = _OE_FolderSubfolderList($hOE, $asMyFolders[$iFolderNum], $asMyFolders[0] - $iFolderNum)
			; And join up the arrays
			if $asSubFolders[0] > 0 then _ArrayAppend($asFolders, $asSubFolders, True)
		Next
	Else
		$sFolder = _OE_FolderMoveFirst($hOE)
		While $sFolder <> ""
			_ArrayAddItem($asFolders, $sFolder, True)
			$sFolder = _OE_FolderMoveNext($hOE, True)
		WEnd
	EndIf
	Return $asFolders
EndFunc   ;==>_OE_FolderList

; ===============================================================================================================================
; Function ......: _OE_FolderMoveFirst - Activate the folders pane and move to the first folder
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: $sFolder  - first folder name (if successful)
;									 ""        - if unsuccessful, and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
; Dependencies ..: _OE_PaneActivate(), _OE_FolderGetName
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderMoveFirst($hOE)
	$hPane = _OE_PaneActivate($hOE, "Folders")
	if @error <> 0 Then
		SetError(@error, @extended)
		Return ""
	EndIf
	ControlClick($hOE, "", $hPane, "left", 1, 1, 1)
	ControlSend($hOE, "", $hPane, "{NUMPADADD}") ; Expand subfolders (if any)
	sleep($iWaitScreenUpdate)
	Return _OE_FolderGetName($hOE)
EndFunc   ;==>_OE_FolderMoveFirst

; ===============================================================================================================================
; Function ......: _OE_FolderMoveNext - Activate the folders pane and move to the next folder
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $bExpandSubfolders - if True, subfolders will be expanded, else they will be collapsed (and ignored)
; Return values .: $sFolder  - next folder name (if successful)
;									 ""        - if there is no next folder or if unsuccessful. If unsuccessful, sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
; Dependencies ..: _OE_PaneActivate(), _OE_PaneChecksum(), _OE_FolderGetName()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderMoveNext($hOE, $bExpandSubfolders=True)
	$hPane = _OE_PaneActivate($hOE, "Folders")
	if @error <> 0 Then
		SetError(@error, @extended)
		Return ""
	EndIf
	$iChecksum = _OE_PaneChecksum($hOE, $hPane)
	if $bExpandSubfolders Then
		ControlSend($hOE, "", $hPane, "{NUMPADADD}") ; Expand subfolders (if any)
	Else
		ControlSend($hOE, "", $hPane, "{NUMPADSUB}") ; Collapse subfolders (if any)
	EndIf
	$iI = 0
	while ($iI < $iTryDetectChange) and (_OE_PaneChecksum($hOE, $hPane) = $iChecksum)
		sleep($iWaitDetectChangeFolders / $iTryDetectChange)
		$iI += 1
	WEnd
	$iChecksum = _OE_PaneChecksum($hOE, $hPane)
	$sFolder = _OE_FolderGetName($hOE)
	ControlSend($hOE, "", $hPane, "{DOWN}") ; Move to next folder
	Sleep($iWaitScreenUpdate) ; Give OE time to refresh/repaint
	; Did the folder pane change? Wait for OE to reflect the change
	$iI = 0
	while ($iI < $iTryDetectChange) and (_OE_PaneChecksum($hOE, $hPane) = $iChecksum)
		sleep($iWaitDetectChangeFolders / $iTryDetectChange)
		$iI += 1
	WEnd
	; If the folder pane changed, wait for change to be reflected in titlebar
	if _OE_PaneChecksum($hOE, $hPane) <> $iChecksum Then
		$iI = 0
		while ($iI < $iTryDetectChange) and (_OE_FolderGetName($hOE) = $sFolder)
			sleep($iWaitDetectChangeFolders / $iTryDetectChange)
			$iI += 1
		WEnd
		Return _OE_FolderGetName($hOE)
	Else
		Return ""
	EndIf
EndFunc   ;==>_OE_FolderMoveNext

; ===============================================================================================================================
; Function ......: _OE_FolderNumMessages - Get the number of message in a folder (from the status bar)
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sFolder  - Folder for which to get the count - if blank, get it for current folder
; Return values .: $iCount   - Number of messages in the current folder (if successful)
;                  -1        - If unsuccessful, and sets @Error:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Unable to goto folder - could not find a match
;                              6 - Status bar did not contain number of messages
; Dependencies ..: _OE_FolderGoto()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderNumMessages($hOE, $sFolder="")
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return -1
	EndIf
	if $sFolder <> "" Then
		$sFolder = _OE_FolderGoto($hOE, $sFolder)
		if $sFolder	= "" Then
			SetError(@error, @extended)
			return -1
		EndIf
	EndIf
	sleep($iWaitScreenUpdate) ; wait for OE to finish refreshing
	$sStatus = StatusbarGetText($hOE)
	$sCount = StringRegExp($sStatus, "(\d+?) message", 1)
	if @error = 0 and StringIsInt($sCount[0]) then
		Return Int($sCount[0])
	Else
		SetError(6)
		Return -1
	EndIf
EndFunc   ;==>_OE_FolderNumMessages

; ===============================================================================================================================
; Function ......: _OE_FolderNumUnread - Get the number of unread messages in a folder (from the status bar)
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sFolder  - Folder for which to get the count - if blank, get it for current folder
; Return values .: $iCount   - Number of messages in the current folder (if successful)
;                  -1        - If unsuccessful, and sets @Error:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Unable to goto folder - could not find a match
;                              6 - Status bar did not contain number of messages
; Dependencies ..: _OE_FolderGoto()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderNumUnread($hOE, $sFolder="")
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return -1
	EndIf
	if $sFolder <> "" Then
		$sFolder = _OE_FolderGoto($hOE, $sFolder)
		if $sFolder	= "" Then
			SetError(@error, @extended)
			return -1
		EndIf
	EndIf
	sleep($iWaitScreenUpdate) ; wait for OE to finish refreshing
	$sStatus = StatusbarGetText($hOE)
	$sCount = StringRegExp($sStatus, "(\d+?) unread", 1)
	if @error = 0 and StringIsInt($sCount[0]) then
		Return Int($sCount[0])
	Else
		SetError(6)
		Return -1
	EndIf
EndFunc   ;==>_OE_FolderNumUnread

; ===============================================================================================================================
; Function ......: _OE_FolderSubfolderList - Return a list of fully qualified subfolder names in OE
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sFolder  - Folder for which to return the subfolders
;	                 $iFoldersAfter - Number of folders after this one to the end of the folder list (used to remove duplication)
; Return values .: $asFolders- array of fully-qualified subfolder names, with count in $asFolders[0]
;									 ""        - if unsuccessful, and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Unable to goto folder - could not find a match
; Dependencies ..: _OE_FolderMoveFirst(), _OE_FolderMoveNext(), _OE_FolderSubfolderList()
;                  _ArrayAddItem(), _ArrayAppend()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_FolderSubfolderList($hOE, $sFolder, $iFoldersAfter=0)
	Local $asMyFolders[1] = [0], $asSubFolders[1] = [0], $asFolders[1] = [0]
  if not _OE_Valid($hOE) Then
		SetError(@error)
		return ""
	EndIf
	; Ensure we start at the right folder
	$sStartFolder = _OE_FolderGoto($hOE, $sFolder)
  if $sStartFolder	= "" Then
		SetError(1)
		return ""
	EndIf
	if _OE_FolderHasSubfolders($hOE) Then
		; Get the next level of subfolders (and any folders after these that are higher in the hierarchy)
		$sNextFolder = _OE_FolderMoveNext($hOE, True)
		while	$sNextFolder <> ""
			_ArrayAddItem($asMyFolders, $sFolder & "\" & $sNextFolder, True)
			$sNextFolder = _OE_FolderMoveNext($hOE, False) ; stay at same or higher hierarchy level
		WEnd
		; If there were any folders after the higher-level folder, remove them from MyFolders
		if $asMyFolders[0] > 0 and $iFoldersAfter > 0 Then $asMyFolders[0] -= $iFoldersAfter
		; Reprocess the immediate subfolders to get sub-subfolders (etc.)
		For $iFolderNum = 1 to $asMyFolders[0]
			; Add the current subfolder to the result set
			_ArrayAddItem($asFolders, $asMyFolders[$iFolderNum], True)
			; get subfolders (and sub-subfolders etc.)
			$asSubFolders = _OE_FolderSubfolderList($hOE, $asMyFolders[$iFolderNum], $iFoldersAfter + $asMyFolders[0] - $iFolderNum)
			; And join up the arrays
			if $asSubFolders[0] > 0 then _ArrayAppend($asFolders, $asSubFolders, True)
		Next
	EndIf
	Return $asFolders
EndFunc   ;==>_OE_FolderSubfolderList

; ===============================================================================================================================
; Function ......: _OE_MessageGetProperties - Returns a string containing a linefeed-separated list of properties "name: value"
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $bBodyText - If true, returns body text as the last property [default: False]
;                  $iMaxBodyText - if > zero, limits body text to the first 'n' characters, else returns full body text
; Return values .: $sProperties - Properties for the current message formatted as name:value with @LF separators
;									 ""        - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Could not get handle to message properties dialog
;                             -1 - Could not get handle to message source dialog (NOTE: this is a warning)
; Dependencies ..: 
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
;                  Email address lists and other multi-line properties are collapsed into single values with " " separators
;                  Multiple properties with the same name, are collapsed into single values with @CR separators
;                  If requested, body text will be the last element in the property list, with a property name of
;                  "Message Body: " and the body text rows separated by carriage return characters (@CR)
; ===============================================================================================================================
Func _OE_MessageGetProperties($hOE, $bBodyText=False, $iMaxBodyText=0)
	Local $asProperties[1] = [0]
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return ""
	EndIf
	$hPane = _OE_PaneActivate($hOE, "Messages")
	if @error <> 0 Then
		SetError(@error, @extended)
		Return ""
	EndIf
	$sSubject = ""
	ControlSend($hOE, "", $hPane, "!{ENTER}")  ; Look at message properties [ALT]+[ENTER]
	$hDialog = _OE_FindPropertiesDialog($hOE)
	$iI = 0
	While $iI < $iTryDetectChange and $hDialog = 0 ; Wait to be sure dialog has appeared
		Sleep($iWaitDetectChange / $iTryDetectChange)
		$hDialog = _OE_FindPropertiesDialog($hOE)
		$iI += 1
	WEnd
	if $hDialog = 0 Then
		SetError(5)
		Return ""
	EndIf
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated
	; Get and format the properties from the first tab
	$sProperties = WinGetText($hDialog)
	$asRawProperties = StringSplit($sProperties, @lf)
	For $iN = 3 to $asRawProperties[0] ; first two properties are from/subject - repeated in second tab
		If StringRight($asRawProperties[$iN], 1) = ":" and $iN < $asRawProperties[0] Then
			Switch $asRawProperties[$iN]
				Case "Sent:"
					$asRawProperties[$iN] = "Sent Date:"
				Case "Received:"
					$asRawProperties[$iN] = "Received Date:"
			EndSwitch
			_ArrayAddItem($asProperties, $asRawProperties[$iN] & " " & $asRawProperties[$iN + 1], True)
			$iN += 1
		Else
			Switch $asRawProperties[$iN]
				Case "OK", "Cancel", ""
				Case Else
					_ArrayAddItem($asProperties, "<Unknown>: " & $asRawProperties[$iN], True)
			EndSwitch
		EndIf
	Next
	; Get and format the properties from the second tab
	ControlSend($hDialog, "", "[CLASS:SysTabControl32]", "^{TAB}")
	Sleep($iWaitScreenUpdate)
	$sProperties = ControlGetText($hDialog, "", "[ClASS:Edit]")
	$asRawProperties = StringSplit($sProperties, @LF)
	Local $asParts[2] = ["", ""]
	For $iN = 1 to $asRawProperties[0]
		if StringRegExp($asRawProperties[$iN], '^(\S)*[:]\s(\S)*') Then
			; Found a parameter - name: value
			$asParts = StringRegExp($asRawProperties[$iN], '^([^:]*)[:](.*)$', 1)
			for $iI = 0 to ubound($asParts) - 2
			Next
			; try to find property name in existing properties
			$bFound = False
			$iItem = 1
			While not $bFound and $iItem > 0
				$iItem = _ArraySearch($asProperties, $asParts[0] & ":", $iItem, $asProperties[0], 0, True)
				if $iItem >= 0 Then
					If StringInStr($asProperties[$iItem], $asParts[0]) = 1 Then 
						$bFound = True
					Else
						$iItem += 1
					EndIf
				EndIf
			WEnd
      if $iItem < 0 Then
				; Parameter name not seen before, add to parameter array
				_ArrayAddItem($asProperties, StringStripWS($asRawProperties[$iN], 1 + 2), True)
			Else
				; Parameter name seen before, append to existing parameter with @CR separator
				$asProperties[$iItem] &= (@CR & StringStripWS($asRawProperties[$iN], 1 + 2))
			EndIf
		ElseIf StringStripWS($asRawProperties[$iN], 1 + 2) <> "" Then
			; Found continuation of previous parameter, append with " " separator
			$asProperties[$asProperties[0]] &= (" " & StringStripWS($asRawProperties[$iN], 1 + 2))
		EndIf
	Next
	; Get message body from the Message Source dialog
	$sBodyText = ""
	if $bBodyText Then
		ControlClick($hDialog, "", "[CLASS:Button; TEXT:&Message Source...]")
		$hMessageSource = WinGetHandle("Message Source")
		$iI = 0
		While $iI < $iTryDetectChange and $hMessageSource = 0 ; Wait to be sure dialog has appeared
			Sleep($iWaitDetectChange / $iTryDetectChange)
			$hMessageSource = WinGetHandle("Message Source")
			$iI += 1
		WEnd
		if $hMessageSource = 0 Then
			SetError(-1)
		Else
			Sleep($iWaitScreenUpdate) ; make sure the screen is updated
			$sBodyText = ControlGetText($hMessageSource, "", "[CLASS:RICHEDIT]")
			if $sBodyText <> "" Then
				$sBodyText = StringReplace($sBodyText, $sProperties, "") ; Replace the internet header info
				; Ensure that body text is @CR separated, to not interfere with @LF separated property list
				$sBodyText = StringReplace(StringReplace($sBodyText, @LF, @CR), @CR & @CR, @CR) ; LF -> CR, then CRCR -> CR
				$sBodyText = StringStripWS($sBodyText, 1 + 2) ; Strip leading/trailing whitespace
				if $iMaxBodyText > 0 Then $sBodyText = stringleft($sBodyText, $iMaxBodyText)
			EndIf
			WinClose($hMessageSource)
			$iI = 0
			While $iI < $iTryDetectChange and WinExists($hMessageSource)
				Sleep($iWaitDetectChange / $iTryDetectChange) ; wait for dialog to close, so as not to interfere with other OE UDFs
				$iI += 1
			WEnd
		EndIf
	EndIf
	; Close the propeties dialog
	ControlSend($hDialog, "", "[CLASS:Button; TEXT:Cancel]", "{ESC}")
	$iI = 0
	While $iI < $iTryDetectChange and WinExists($hDialog)
		Sleep($iWaitDetectChange / $iTryDetectChange) ; wait for dialog to close, so as not to interfere with other OE UDFs
		$iI += 1
	WEnd
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated
	_ArraySort($asProperties, 0, 1, $asProperties[0])
	if $sBodyText <> "" Then _ArrayAddItem($asProperties, "Message Body: " & @CR & $sBodyText, True)
	Return _ArrayToString($asProperties, @LF, 1, $asProperties[0])
EndFunc   ;==>_OE_MessageGetProperties

; ===============================================================================================================================
; Function ......: _OE_MessageGetSubject - Get the subject of the current message
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: $sSubject - Subject of the current message, or '<blank>' if the subject is blank
;									 ""        - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Could not get handle to message properties dialog
; Dependencies ..: 
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_MessageGetSubject($hOE)
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		return ""
	EndIf
	$hPane = _OE_PaneActivate($hOE, "Messages")
	if @error <> 0 Then
		SetError(@error, @extended)
		Return ""
	EndIf
	$sSubject = ""
	ControlSend($hOE, "", $hPane, "!{ENTER}")  ; Look at message properties [ALT]+[ENTER]
	$hDialog = _OE_FindPropertiesDialog($hOE)
	$iI = 0
	While $iI < $iTryDetectChange and $hDialog = 0 ; Wait to be sure dialog has appeared
		Sleep($iWaitDetectChange / $iTryDetectChange)
		$hDialog = _OE_FindPropertiesDialog($hOE)
		$iI += 1
	WEnd
	if $hDialog = 0 Then
		SetError(5)
		Return ""
	EndIf
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated
	$sSubject = WinGetTitle($hDialog)
	if $sSubject = "" Then $sSubject = "<blank>"
	ControlSend($hDialog, "", "[CLASS:Button; TEXT:Cancel]", "{ESC}")
	$iI = 0
	While $iI < $iTryDetectChange and WinExists($hDialog)
		Sleep($iWaitDetectChange / $iTryDetectChange) ; wait for dialog to close, so as not to interfere with other OE UDFs
		$iI += 1
	WEnd
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated
	Return $sSubject
EndFunc   ;==>_OE_MessageGetSubject

; ===============================================================================================================================
; Function ......: _OE_MessageMoveFirst - Activate the messages pane; move to the first message in the current/specified folder
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sFolder  - Move to the first message in the specified folder; if "", use the current folder
;                  $bSubject - Determines what's returned on success/failure - subject/"" or True/False
; Return values .: $sSubject/True - subject of first message, if successful ("<blank>" if the subject is blank)
;									 ""/False  - if unsuccessful, and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
;                              5 - Unable to goto folder - could not find a match
; Dependencies ..: _OE_PaneActivate(), _OE_MessageGetSubject
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_MessageMoveFirst($hOE, $sFolder="", $bSubject=True)
	if $sFolder <> "" Then
		$sFolder = _OE_FolderGoto($hOE, $sFolder)
		if $sFolder	= "" Then
			SetError(@error, @extended)
			if $bSubject Then Return ""
			if not $bSubject Then Return False
		EndIf
	EndIf
	$hPane = _OE_PaneActivate($hOE, "Messages")
	if @error <> 0 Then
		SetError(@error, @extended)
		if $bSubject Then Return ""
		if not $bSubject Then Return False
	EndIf
	ControlSend($hOE, "", $hPane, "{HOME}{UP}") ; Go to first message and make sure item is properly highlighted
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated
	if $bSubject Then Return _OE_MessageGetSubject($hOE)
	if not $bSubject Then Return True
EndFunc   ;==>_OE_MessageMoveFirst

; ===============================================================================================================================
; Function ......: _OE_MessageMoveNext - Activate the messages pane and move to the next message in the current folder
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $bSubject - Determines what's returned on success/failure - subject/"" or True/False
; Return values .: $sSubject/True - subject of next message, if successful ("<blank>" if the subject is blank)
;									 ""/False  - if there is no next folder or if unsuccessful. If unsuccessful, sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
; Dependencies ..: _OE_PaneActivate(), _OE_PaneChecksum(), _OE_MessageGetSubject()
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_MessageMoveNext($hOE, $bSubject=True)
	$hPane = _OE_PaneActivate($hOE, "Messages")
	if @error <> 0 Then
		SetError(@error, @extended)
		if $bSubject Then Return ""
		if not $bSubject Then Return False
	EndIf
	$iChecksum = _OE_PaneChecksum($hOE, $hPane)
	ControlSend($hOE, "", $hPane, "{DOWN}") ; Move to next message and ensure it's properly highlighted
	Sleep($iWaitScreenUpdate) ; make sure the screen is updated
	; Did the message pane change? Wait for OE to reflect the change
	$iI = 0
	while ($iI < $iTryDetectChange) and (_OE_PaneChecksum($hOE, $hPane) = $iChecksum)
		sleep($iWaitDetectChange / $iTryDetectChange)
		$iI += 1
	WEnd
	if _OE_PaneChecksum($hOE, $hPane) = $iChecksum Then
		if $bSubject Then Return ""
		if not $bSubject Then Return False
	Else
		if $bSubject Then Return _OE_MessageGetSubject($hOE)
		if not $bSubject Then Return True
	EndIf
EndFunc   ;==>_OE_MessageMoveNext

; ===============================================================================================================================
; Function ......: _OE_PaneActivate - Activate a specific outlook pane
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sPane    - "Folders" to show/activate the folders pane, "Messages" to show/activate the message list
; Return values .: $hPane    - Handle to the activated pane (actually a ControlID string)
;									 0         - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlFocus returned unsuccessful
; Dependencies ..: _OE_Valid(), _OE_PaneControlID
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_PaneActivate($hOE, $sPane = "Folders")
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		Return 0
	EndIf
	$hPane = _OE_PaneControlID($sPane)
	if @error <> 0 Then
		SetError(3)
		Return 0
	EndIf
	if ControlFocus($hOE, "", $hPane) = 0 Then
		SetError(4)
		Return 0
	EndIf
	Return $hPane
EndFunc   ;==>_OE_PaneActivate

; ===============================================================================================================================
; Function ......: _OE_PaneChecksum - Calls PixelChecksum on an OE pane (can be used to see if the pane has changed)
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
;                  $sPane    - "Folders" to show/activate the folders pane, "Messages" to show/activate the message list
; Return values .: $iCheckSum- PixelChecksum for the pane (if successful)
;                  0         - if unsuccessful and sets @error as follows:
;										           1 - Invalid OE handle
;                              2 - Window inaccessible (could not be made visible, enabled and maximized)
;                              3 - Invalid pane - not one of folders/messages and not a pane handle
;                              4 - ControlGetPos and/or PixelChecksum returned unsuccessful
; Dependencies ..: _OE_Valid(), _OE_PaneControlID
; Remarks/Notes .: 
; ===============================================================================================================================
Func _OE_PaneChecksum($hOE, $sPane = "Folders")
	Local $aiPos[3]
  if not _OE_Valid($hOE) Then
		SetError(@error, @extended)
		Return 0
	EndIf
	$hPane = _OE_PaneControlID($sPane)
	if @error <> 0 Then
		SetError(3)
		Return
	EndIf
	$aiPos = ControlGetPos($hOE, "", $hPane)
  if @error <> 0 Then
		SetError(4)
		Return
	EndIf
	AutoItSetOption("PixelCoordMode", 2)
	$iChecksum = PixelChecksum($aiPos[0], $aiPos[1], $aiPos[0] + $aiPos[2], $aiPos[1] + $aiPos[3])
  if @error <> 0 Then
		SetError(4)
		Return
	EndIf
	AutoItSetOption("PixelCoordMode", 1)
	Return $iCheckSum
EndFunc   ;==>_OE_PaneChecksum

; ===============================================================================================================================
; Function ......: _OE_PaneControlID - Returns a ControlID string corresponding to a folders or messagelist pane
; Parameters ....: $sPane      - "Folders" to get the ID of the folders pane, "Messages" to get the ID of the message list
; Return values .: $sControlID - ControlID string for the pane (if successful)
;									 ""          - if unsuccessful and sets @error as follows:
;							  			           1 - Invalid pane name
; Dependencies ..:
; Remarks/Notes .: 
; ===============================================================================================================================
Func _OE_PaneControlID($sPane = "Folders")
	Switch StringLower($sPane)
		Case "folders"
			Return "[Class:SysTreeView32; Text:Folder List]"
		Case "messages"
			Return "[Class:ATL:SysListView32; Text:Outlook Express Message List]"
		Case Else
			if StringInStr($sPane, "[Class:") > 0 then
				Return $sPane
			Else
				SetError(1)
			  Return ""
			EndIf
	EndSwitch
EndFunc   ;==>_OE_PaneControlID

; ===============================================================================================================================
; Function ......: _OE_Valid - Checks OE handle and unhides/maximises window ready for work
; Parameters ....: $hOE      - handle to OE - returned by _OE_Start
; Return values .: 1         - If window handle exists, is visible, enabled and maximized
;                  0    		 - If unsuccessful, and sets @error
;                              1 - window doesn't exist
;                              2 - window cannot be made visible, enabled and maximized
; Dependencies ..:
; Remarks/Notes .: Manipulates the OE user interface - OE *should not* be used while this UDF is running
; ===============================================================================================================================
Func _OE_Valid($hOE)
  if not WinExists($hOE) Then
		SetError(1)
		Return
	EndIf
	if bitand(WinGetState($hOE), 2 + 4 + 32) <> (2 + 4 + 32) Then ; If not visible/maximized, make it visible and maximized
		WinSetState($hOE, "", @SW_SHOW)
		WinSetState($hOE, "", @SW_ENABLE)
		WinSetState($hOE, "", @SW_MAXIMIZE)
	EndIf
	if bitand(WinGetState($hOE), 2 + 4 + 32) <> (2 + 4 + 32) Then ; If not visible/maximized, make it visible and maximized
		SetError(2)
		Return
	EndIf
	Return 1
EndFunc   ;==>_OE_Valid

;===============================================================================
;
; Function Name:  _ArrayAddItem() - based on _ArrayAdd()
; Description:    Adds a specified value at the end of an array, returning the
;                 adjusted array.
; Author(s):      Jos van der Zande <jdeb at autoitscript dot com>
;                 MODIFIED BY Steve Bateman (MisterBates)
;
;===============================================================================
Func _ArrayAddItem(ByRef $avArray, $sValue, $bOneBased = False)
	If IsArray($avArray) Then
		if not $bOneBased Then
			ReDim $avArray[UBound($avArray) + 1]
			$avArray[UBound($avArray) - 1] = $sValue
			SetError(0)
			Return 1
		Else
			$avArray[0] += 1
			ReDim $avArray[$avArray[0] + 1]
			$avArray[$avArray[0]] = $sValue
			SetError(0)
			Return 1
		EndIf
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_ArrayAddItem

;===============================================================================
;
; Function Name:    _ArrayAppend()
; Description:      Append a one-dimensional array to the end of another one-dimensional array.
; Parameter(s):     $avArray - The array to be appended to (passed ByRef)
;                   $avAppend - The array to append
;                   $bOneBased - if True, then element [0] contains number of array elements, else not.
; Requirement(s):   None.
; Return Value(s):  1 if successful. If not, returns 0 and sets @Error:
;                   1 - $avArray and $avAppend must both be arrays
; Author(s):        Steve Bateman (MisterBates)
; Note(s):          None.
;
;===============================================================================
Func _ArrayAppend(ByRef $avArray, $avAppend, $bOneBased = False)
	Local $iI
	if not (IsArray($avArray) and IsArray($avAppend)) Then
		SetError(1)
		Return 0
	EndIf
	if $bOneBased Then
		ReDim $avArray[$avArray[0] + $avAppend[0] + 1]
		For $iI = 1 to $avAppend[0]
			_ArrayAddItem($avArray, $avAppend[$iI], $bOneBased)
		Next
	Else
		ReDim $avArray[ubound($avArray) + ubound($avAppend)]
		For $iI = 0 to ubound($avAppend) - 1
			_ArrayAddItem($avArray, $avAppend[$iI])
		Next
	EndIf
	Return 1
EndFunc   ;==>_ArrayAppend