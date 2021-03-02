
#include-once

; #INDEX# ============================================================================================================
; Title .........: ChooseFileFolder
; AutoIt Version : 3.3 +
; Language ......: English
; Description ...: Allows selection of single or multiple files/folders from within a defined path
; Remarks .......: - If the script already has a WM_NOTIFY handler then call the _CFF_WM_NOTIFY_Handler function
;                    from within it
;                  - Requires another Melba23 UDF: RecFileListToArray.au3
; Author ........: Melba23
; Modified ......;
; ====================================================================================================================

;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #INCLUDES# =========================================================================================================
#include <GuiTreeView.au3>
#include <RecFileListToArray.au3>

; #GLOBAL VARIABLES# =================================================================================================
Global $fCFF_DblClk, $sCFF_Def_Folder_Path = "", $sCFF_Def_FileMask = "*.*", $aCFF_Def_Folder_Index, $aCFF_Def_File_Index

; #CURRENT# ==========================================================================================================
; _CFF_IndexDefault: Pre-index path and file for speed
; _CFF_SetDefault:   Sets existing arrays as default folder and file indexes for speed
; _CFF_ClearDefault: Clears any default arrays to save memory
; _CFF_Choose:       Creates a dialog to chose single or multiple files or folders within a specified path
; _CFF_RegMsg:       Register WM_NOTIFY to enable double clicks on TreeView
; ====================================================================================================================

; #INTERNAL_USE_ONLY#=================================================================================================
; _CFF_Combo_Fill: Creates and fills a combo to allow drive selection
; _CFF_TV_Fill:    Fills a TreeView with the selected folder structure to allow folder selection
; _CFF_ListFiles:  Adds files to an existing folder structure to allow file selection
; _CFF_GetSel:     Retrieves selected TreeView item and if file confirms match to file mask
; ====================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _CFF_IndexDefault
; Description ...: Creates default folder and file indexes for speed
; Syntax.........: _CFF_IndexDefault($sPath, [$sFile_Mask = "*.*"])
; Parameters ....: $sPath      - Default folder tree to index and store ("" = no index
;                  $sFile_Mask - Default file mask within folder tree to index and store, "" (default) = no index)
; Requirement(s).: v3.3 +
; Return values .: Success: 1
;                  Failure: Returns 0 and sets @error as follows:
;                      1 = Path does not exist
;                      2 = Index of folder tree failed
;                      3 = Index of files in folder tree failed
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _CFF_IndexDefault($sPath, $sFile_Mask = "")

	If $sPath <> "" Then
		If StringRight($sPath, 1) <> "\" Then $sPath &= "\"
		If Not FileExists($sPath) Then Return SetError(1, 0, 0)
		$aCFF_Def_Folder_Index = _RecFileListToArray($sPath, "*", 2, 1, 1, 1, "$*;System Volume Information;RECYCLED;_Restore")
		If @error Then Return SetError(2, 0, 0)
		$sCFF_Def_Folder_Path = $sPath
	EndIf

	If $sFile_Mask <> "" Then
		$aCFF_Def_File_Index = _RecFileListToArray($sPath, $sFile_Mask, 1, 1, 1)
		If @error Then Return SetError(3, 0, 0)
		$sCFF_Def_FileMask = $sFile_Mask
	EndIf

	Return 1

EndFunc   ;==>_CFF_IndexDefault

; #FUNCTION# =========================================================================================================
; Name...........: _CFF_SetDefault
; Description ...: Sets existing arrays as default folder and file indexes for speed
; Syntax.........: _CFF_SetDefault($sPath, $sFile_Mask, $aFolderArray, $aFileArray)
; Parameters ....: $sPath        - Default folder
;                  $sFile_Mask   - Default file mask within folder tree
;                  $aFolderArray - Existing sorted array of folder tree
;                  $aFileArray   - Existing sorted array of files within the folder tree
; Requirement(s).: v3.3 +
; Return values .: Success: 1
;                  Failure: Returns 0 and sets @error as follows:
;                      1 = Path does not exist
;                      2 = File mask not set
;                      3 = No folder array passed
;                      3 = No file array passed
; Author ........: Melba23
; Modified ......:
; Remarks .......: Arrays MUST have been been created using _RecFileListToArray with the parameters as shown in the
;                  _CFF_IndexDefault function
; Example........: Yes
;=====================================================================================================================
Func _CFF_SetDefault($sPath, $sFile_Mask, $aFolderArray = "", $aFileArray = "")

	If $sPath <> "" And Not FileExists($sPath) Then Return SetError(1, 0, 0)
	If $aFolderArray <> "" And Not IsArray($aFolderArray) Then Return SetError(3, 0, 0)
	If $aFileArray <> "" And Not IsArray($aFileArray) Then Return SetError(4, 0, 0)
	If $sFile_Mask = "" And $aFileArray <> "" Then Return SetError(2, 0, 0)

	If $sPath <> "" Then $sCFF_Def_Folder_Path = $sPath
	If $sFile_Mask <> "" Then $sCFF_Def_FileMask = $sFile_Mask
	If $aFolderArray <> "" Then
		$aCFF_Def_Folder_Index = $aFolderArray
	EndIf
	If $aFileArray <> "" Then
		$aCFF_Def_File_Index = $aFileArray
	EndIf

	Return 1

EndFunc   ;==>_CFF_SetDefault

; #FUNCTION# =========================================================================================================
; Name...........: _CFF_ClearDefault
; Description ...: Clears default arrays to save memory
; Syntax.........: _CFF_ClearDefault([$fFolder = True, [$fFile = True]])
; Parameters.....: $fFolder - True (default) clear default folder array, False leave array intact
;                  $fFile   - True (default) clear default file array, False leave array intact
; Requirement(s).: v3.3 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _CFF_ClearDefault($fFolder = True, $fFile = True)

	If $fFolder Then
		$aCFF_Def_Folder_Index = 0
		$sCFF_Def_Folder_Path = ""
	EndIf
	If $fFile Then
		$aCFF_Def_File_Index = 0
		$sCFF_Def_FileMask = ""
	EndIf

EndFunc   ;==>_CFF_ClearDefault

; #FUNCTION# =========================================================================================================
; Name...........: _CFF_RegMsg
; Description ...: Registers WM_NOTIFY to enable double clicks on TreeView
; Syntax.........: _CFF_RegMsg()
; Parameteres....: None
; Requirement(s).: v3.3 +
; Return values .: Success: 1
;                  Failure: 0
; Author ........: Melba23
; Modified ......:
; Remarks .......: If the script already has a WM_NOTIFY handler then call the _CFF_WM_NOTIFY_Handler function
;                  from within it
; Example........: Yes
;=====================================================================================================================
Func _CFF_RegMsg()

	Return GUIRegisterMsg(0x004E, "_CFF_WM_NOTIFY_Handler") ; $WM_NOTIFY

EndFunc   ;==>_CFF_RegMsg

; #FUNCTION# =========================================================================================================
; Name...........: _CFF_Choose
; Description ...: Sets default path and file mask for speed and registers WM_NOTIFY for TV doubleclicks
; Syntax.........: _CFF_Choose ($sTitle, $iW, $iH, $iX, $iY, [$sRoot = "", [$sFile_Mask = "", [$iDisplay = 0, [$fSingle_Sel = True, [$hParent = 0]]]]])
; Parameters ....: $sTitle      - Title of dialog
;                  $iW, $iH, $iX, $iY - Left, Top, Width, Height parameters for dialog
;                  $sRoot       - Path tree to display (default = "" - list all drives for selection)
;                                 Set to Default keyword = Use preset default path and array
;                  $sFile_Mask  - File name & ext to match (default = *.* - all files)
;                                 Set to Default keyword = Display files matching preset default mask using preset array
;                  $iDisplay    - 0 - Display folder tree and matching files within all folders
;                                 1 - Display all matching files within the specified folder - subfolders are not displayed
;                                 2 - Display folder tree only - no files
;                  $fSingle_Sel - True (default) = Only 1 selection
;                                 False = Multiple selections collected in list on dialog - press "Return" when all selected
;                  $hParent     - Handle of GUI calling the dialog, (default = 0 - no parent GUI)
; Requirement(s).: v3.3 +
; Return values .: Success: String containing selected items - multiple items delimited by "|"
;                  Failure: Returns "" and sets @error as follows:
;                      1 = Path does not exist
;                      2 = Invalid $iDisplay parameter
;                      3 = Invalid $hParent parameter
;                      4 = Dialog creation failure
;                      5 = Cancel button or GUI [X] pressed
; Author ........: Melba23
; Modified ......:
; Remarks .......: If files are displayed, only files can be selected
; Example........: Yes
;=====================================================================================================================
Func _CFF_Choose($sTitle, $iW, $iH, $iX, $iY, $sRoot = "", $sFile_Mask = "*.*", $iDisplay = 0, $fSingle_Sel = True, $hParent = "")

	; Check path
	If $sRoot = Default Then $sRoot = $sCFF_Def_Folder_Path
	If $sRoot <> "" Then
		If Not FileExists($sRoot) Then Return SetError(1, 0, "")
		If StringRight($sRoot, 1) <> "\" Then $sRoot &= "\"
	EndIf
	; Check FileMask
	If $sFile_Mask = Default Then $sFile_Mask = $sCFF_Def_FileMask
	If $sFile_Mask = "" Then $sFile_Mask = "*.*"

	; Check Display
	Switch $iDisplay
		Case 0, 1, 2
		Case Else
			Return SetError(2, 0, "")
	EndSwitch
	; Check parent
	Switch $hParent
		Case ""
		Case Else
			If Not IsHWnd($hParent) Then Return SetError(3, 0, "")
	EndSwitch

	Local $hTreeView = 9999, $hTreeView_Handle = 9999, $hTV_GUI, $hList = 9999, $hDrive_Combo = 9999, $sCurrDrive = ""
	Local $hTreeView_Label, $hTreeView_Progress, $sBase_Path, $sSelectedPath, $iFrame, $aTV_Pos, $hFF_GUI, $hWarning_Label

	; Check for width and height minima and set button size
	Local $iButton_Width
	If $fSingle_Sel Then
		If $iW < 130 Then $iW = 130
		$iButton_Width = Int(($iW - 30) / 2)
	Else
		If $iW < 190 Then $iW = 190
		$iButton_Width = Int(($iW - 40) / 3)
	EndIf
	If $iButton_Width > 80 Then $iButton_Width = 80
	If $iH < 300 Then $iH = 300

	; Create dialog
	Local $hCFF_Win = GUICreate($sTitle, $iW, $iH, $iX, $iY, 0x80C80000, -1, $hParent) ; BitOR($WS_POPUPWINDOW, $WS_CAPTION)
	If @error Then Return SetError(4, 0, "")
	GUISetBkColor(0xCECECE)

	; Create buttons
	Local $hCan_Button, $hSel_Button = 9999, $hAdd_Button = 9999, $hRet_Button = 9999
	If $fSingle_Sel Then
		$hSel_Button = GUICtrlCreateButton("Select", $iW - ($iButton_Width + 10), $iH - 40, $iButton_Width, 30)
	Else
		$hAdd_Button = GUICtrlCreateButton("Add", 10, $iH - 40, $iButton_Width, 30)
		$hRet_Button = GUICtrlCreateButton("Return", $iW - ($iButton_Width + 10), $iH - 40, $iButton_Width, 30)
	EndIf
	$hCan_Button = GUICtrlCreateButton("Cancel", $iW - ($iButton_Width + 10) * 2, $iH - 40, $iButton_Width, 30)

	; Create controls
	Select
		Case $sRoot And $fSingle_Sel ; TV only
			$hTV_GUI = $hCFF_Win
			; Create TV and hide
			$hTreeView = GUICtrlCreateTreeView(10, 10, $iW - 20, $iH - 60)
			$hTreeView_Handle = GUICtrlGetHandle($hTreeView)
			GUICtrlSetState(-1, 32) ; $GUI_HIDE
			; Create Indexing label and progress
			$hTreeView_Label = GUICtrlCreateLabel("Indexing..." & @CRLF & "Please be patient", ($iW - 150) / 2, 20, 100, 30)
			$hTreeView_Progress = GUICtrlCreateProgress(($iW - 150) / 2, 60, 150, 10, 0x00000008); $PBS_MARQUEE
			GUICtrlSendMsg(-1, 0x40A, True, 50) ; $PBM_SETMARQUEE
		Case Not $sRoot And $fSingle_Sel ; Combo and TV
			$hTV_GUI = $hCFF_Win
			; Create and fill Combo
			$hDrive_Combo = _CFF_Combo_Fill($iW)
			; Create TV and hide
			$hTreeView = GUICtrlCreateTreeView(10, 40, $iW - 20, $iH - 90)
			$hTreeView_Handle = GUICtrlGetHandle($hTreeView)
			GUICtrlSetState(-1, 32) ; $GUI_HIDE
			; Display warning
			$hWarning_Label = GUICtrlCreateLabel("Warning:" & @CRLF & "Indexing large drives" & @CRLF & "can take some time", ($iW - 150) / 2, 50, 100, 60)
		Case $sRoot And Not $fSingle_Sel ; TV and List
			$hTV_GUI = $hCFF_Win
			; Create TV and hide
			$hTreeView = GUICtrlCreateTreeView(10, 10, $iW - 20, $iH - 160)
			$hTreeView_Handle = GUICtrlGetHandle($hTreeView)
			GUICtrlSetState(-1, 32) ; $GUI_HIDE
			; Create Indexing label and progress
			$hTreeView_Label = GUICtrlCreateLabel("Indexing..." & @CRLF & "Please be patient", ($iW - 150) / 2, 20, 100, 30)
			$hTreeView_Progress = GUICtrlCreateProgress(($iW - 150) / 2, 60, 150, 10, 0x00000008); $PBS_MARQUEE
			GUICtrlSendMsg(-1, 0x40A, True, 50) ; $PBM_SETMARQUEE
			; Create List
			$hList = GUICtrlCreateList("", 10, $iH - 150, $iW - 20, 100, 0x00A04100) ;BitOR($WS_BORDER, $WS_VSCROLL, $LBS_NOSEL, $LBS_NOINTEGRALHEIGHT))
		Case Not $sRoot And Not $fSingle_Sel ; Combo, TV and List
			; Create and fill Combo
			$hDrive_Combo = _CFF_Combo_Fill($iW)
			$hTV_GUI = $hCFF_Win
			; Create TV and hide
			$hTreeView = GUICtrlCreateTreeView(10, 40, $iW - 20, $iH - 190)
			$hTreeView_Handle = GUICtrlGetHandle($hTreeView)
			GUICtrlSetState(-1, 32) ; $GUI_HIDE
			; Create List
			$hList = GUICtrlCreateList("", 10, $iH - 150, $iW - 20, 100, 0x00A04100) ;BitOR($WS_BORDER, $WS_VSCROLL, $LBS_NOSEL, $LBS_NOINTEGRALHEIGHT))
		EndSelect

	GUISetState()

	If $sRoot Then
		; If root folder available then fill TV
		_CFF_TV_Fill($hCFF_Win, $hTV_GUI, $hTreeView, $sRoot, $sFile_Mask, $iDisplay)
		; Show TV
		GUICtrlSetState($hTreeView, 16) ; $GUI_SHOW
		; Delete label and progress
		GUICtrlDelete($hTreeView_Label)
		GUICtrlDelete($hTreeView_Progress)
	EndIf

	; Create return string for multi-selection
	Local $sAddFile_List = ""

	; Change to MessageLoop mode
	Local $nOldOpt = Opt('GUIOnEventMode', 0)

	While 1

		Local $aMsg = GUIGetMsg(1)

		If $aMsg[1] = $hCFF_Win Then

			Switch $aMsg[0]
				Case $hSel_Button, $hAdd_Button
					; Set the path base
					$sBase_Path = $sRoot
					If $sRoot = "" Then $sBase_Path = GUICtrlRead($hDrive_Combo) & "\"
					; Get the selected path
					$sSelectedPath = _CFF_GetSel($hTreeView_Handle, $iDisplay, $sFile_Mask, _GUICtrlTreeView_GetSelection($hTreeView))
					If $sSelectedPath Then
						If $fSingle_Sel Then
							GUIDelete($hCFF_Win)
							; Restore previous mode
							Opt('GUIOnEventMode', $nOldOpt)
							; Return valid path
							Return $sBase_Path & $sSelectedPath
						Else
							GUICtrlSetState($hTreeView, 256) ; $GUI_FOCUS
							; Add to return string
							$sAddFile_List &= $sBase_Path & $sSelectedPath & "|"
							; Add to onscreen list
							GUICtrlSendMsg($hList, 0x0180, 0, $sSelectedPath) ; $LB_ADDSTRING
							; Scroll to bottom of list
							GUICtrlSendMsg($hList, 0x197, GUICtrlSendMsg($hList, 0x18B, 0, 0) - 1, 0) ; $LB_SETTOPINDEX, $LB_GETCOUNT
						EndIf
					EndIf
				Case $hRet_Button
					GUIDelete($hCFF_Win)
					; Restore previous mode
					Opt('GUIOnEventMode', $nOldOpt)
					; Remove final | from return string and return
					Return StringTrimRight($sAddFile_List, 1)
				Case $hCan_Button, -3 ; $GUI_EVENT_CLOSE
					GUIDelete($hCFF_Win)
					; Restore previous mode
					Opt('GUIOnEventMode', $nOldOpt)
					Return SetError(5, 0, "")
			EndSwitch
		EndIf

		; Check if mouse has doubleclicked in TreeView
		If $fCFF_DblClk = $hTreeView_Handle Then
			; Reset flag
			$fCFF_DblClk = 0
			; Set the path base
			$sBase_Path = $sRoot
			If $sRoot = "" Then $sBase_Path = GUICtrlRead($hDrive_Combo) & "\"
			; Get the selected path
			$sSelectedPath = _CFF_GetSel($hTreeView_Handle, $iDisplay, $sFile_Mask)
			If $sSelectedPath Then
				If $fSingle_Sel Then
					GUIDelete($hCFF_Win)
					; Restore previous mode
					Opt('GUIOnEventMode', $nOldOpt)
					; Return valid path
					Return $sBase_Path & $sSelectedPath
				Else
					GUICtrlSetState($hTreeView, 256) ; $GUI_FOCUS
					; Add to return string
					$sAddFile_List &= $sBase_Path & $sSelectedPath & "|"
					; Add to onscreen list
					GUICtrlSendMsg($hList, 0x0180, 0, $sSelectedPath) ; $LB_ADDSTRING
					; Scroll to bottom of list
					GUICtrlSendMsg($hList, 0x197, GUICtrlSendMsg($hList, 0x18B, 0, 0) - 1, 0) ; $LB_SETTOPINDEX, $LB_GETCOUNT
				EndIf
			EndIf
		EndIf

		; Check if a new drive has been selected
		If $sRoot = "" Then
			If GUICtrlRead($hDrive_Combo) <> $sCurrDrive Then
				; Check combo closed
				If GUICtrlSendMsg($hDrive_Combo, 0x157, 0, 0) = False Then ; $CB_GETDROPPEDSTATE
					; Hide warning
					GUICtrlSetState($hWarning_Label, 32) ; $GUI_HIDE
					; Get drive chosen
					$sCurrDrive = GUICtrlRead($hDrive_Combo)
					; Get current TV size
					$aTV_Pos = ControlGetPos($hTV_GUI, "", $hTreeView)
					; Delete a current combo
					GUICtrlDelete($hTreeView)
					; Switch to correct GUI
					GUISwitch($hTV_GUI)
					; Create TV and hide
					$hTreeView = GUICtrlCreateTreeView($aTV_Pos[0], $aTV_Pos[1], $aTV_Pos[2], $aTV_Pos[3])
					$hTreeView_Handle = GUICtrlGetHandle($hTreeView)
					GUICtrlSetState(-1, 32) ; $GUI_HIDE
					GUICtrlSetResizing(-1, 1) ; $GUI_DOCKAUTO
					; Create Indexing label and progress
					$hTreeView_Label = GUICtrlCreateLabel("Indexing" & @CRLF & "Please be patient", ($iW - 170) / 2, 60, 100, 30)
					$hTreeView_Progress = GUICtrlCreateProgress(($iW - 170) / 2, 90, 150, 10, 0x00000008) ; $PBS_MARQUEE
					GUICtrlSendMsg($hTreeView_Progress, 0x40A, True, 50) ; $PBM_SETMARQUEE
					; Fill TV
					_CFF_TV_Fill($hCFF_Win, $hTV_GUI, $hTreeView, $sCurrDrive & "\", $sFile_Mask, $iDisplay)
					; Show TV
					GUICtrlSetState($hTreeView, 16) ; $GUI_SHOW
					; Delete label and progress
					GUICtrlDelete($hTreeView_Label)
					GUICtrlDelete($hTreeView_Progress)
					; Switch back to main dialog
					GUISwitch($hCFF_Win)
				EndIf
			EndIf
		EndIf

	WEnd

EndFunc   ;==>_CFF_Choose

; #FUNCTION# =========================================================================================================
; Name...........: _CFF_WM_NOTIFY_Handler
; Description ...: Windows message handler for WM_NOTIFY
; Syntax.........: _CFF_WM_NOTIFY_Handler($hWnd, $iMsg, $wParam, $lParam)
; Requirement(s).: v3.3 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_NOTIFY handler already registered, then call this function from within that handler
; Example........: Yes
;=====================================================================================================================
Func _CFF_WM_NOTIFY_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam

	Local $tStruct = DllStructCreate("hwnd hWndFrom;int IDFrom;int Code;int Spec", $lParam)
	If @error Then Return
	Switch DllStructGetData($tStruct, "Code")
		Case 0xFFFFFFFD ; $NM_DBLCLK
			$fCFF_DblClk = DllStructGetData($tStruct, "hWndFrom")
	EndSwitch

EndFunc   ;==>_CFF_WM_NOTIFY_Handler

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _CFF_Combo_Fill
; Description ...: Creates and fills a combo to allow drive selection.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func _CFF_Combo_Fill($iW)

	GUICtrlCreateLabel("Select Drive:", (($iW - 150) / 2) - 65, 15, 65, 20)
	Local $hCombo = GUICtrlCreateCombo("", ($iW - 150) / 2, 10, 50, 20)
	Local $aDrives = DriveGetDrive("ALL")
	For $i = 1 To $aDrives[0]
		; Only display ready drives
		If DriveStatus($aDrives[$i] & '\') <> "NOTREADY" Then GUICtrlSetData($hCombo, StringUpper($aDrives[$i]))
	Next
	Return $hCombo

EndFunc   ;==>_CFF_Combo_Fill

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _CFF_TV_Fill
; Description ...: Fills a TreeView with the selected folder structure to allow folder selection.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func _CFF_TV_Fill($hCFF_Win, $hTV_GUI, $hTreeView, $sRoot, $sFile_Mask, $iDisplay)

	Local $aLevel[100], $iLevel, $aFolderArray, $sFullFolderpath, $sFolderName, $sFileName, $sText, $iFile_Index

	; Switch to correct GUI
	GUISwitch($hTV_GUI)
	; Set TV ControlID
	$aLevel[0] = $hTreeView
	; List folders if required
	If $iDisplay <> 1 Then

		; If default folder then use existing arrays
		If $sRoot = $sCFF_Def_Folder_Path Then
			; Copy default array
			$aFolderArray = $aCFF_Def_Folder_Index
			; If default file array set then prepare index if needed
			If IsArray($aCFF_Def_File_Index) And  $iDisplay < 2 Then
				; Set file index to first file in a subfolder
				$iFile_Index = 1
				While 1
					If StringInStr($aCFF_Def_File_Index[$iFile_Index], "\") Then ExitLoop
					$iFile_Index += 1
				WEnd
			EndIf

			If IsArray($aFolderArray) Then
				; Add each folder
				For $i = 1 To $aFolderArray[0]
					$sFullFolderpath = $aFolderArray[$i]
					; Count \
					StringRegExpReplace($sFullFolderpath, "\\", "")
					$iLevel = @extended
					; Extract folder name from path
					$sFolderName = StringRegExpReplace($sFullFolderpath, "(.*\\|^)(.*)\\", "$2")
					; Add to TV and store item ControlID
					$aLevel[$iLevel] = GUICtrlCreateTreeViewItem($sFolderName, $aLevel[$iLevel - 1])
					; List files within folder if required
					If $iDisplay < 2 Then
						; Use default array if available
						If IsArray($aCFF_Def_File_Index) Then
							; Move through track listing
							For $j = $iFile_Index To $aCFF_Def_File_Index[0]
								; Check if possible match
								If StringInStr($aCFF_Def_File_Index[$j], $sFullFolderpath) Then
									$sFileName = StringReplace($aCFF_Def_File_Index[$j], $sFullFolderpath, "", 1)
									; Check all \ removed to confirm file
									If Not StringInStr($sFileName, "\") Then
										; Add to TV
										GUICtrlCreateTreeViewItem($sFileName, $aLevel[$iLevel])
										; Advance track index
										$iFile_Index = $j + 1
									EndIf
								Else
									; Move to next folder
									ExitLoop
								EndIf
							Next
						Else
							; No default array so list files within folder
							_CFF_ListFiles($sRoot & $aFolderArray[$i], $sFile_Mask, $aLevel[$iLevel])
						EndIf
					EndIf
				Next
			EndIf

		Else

			; If not default folder then list folders
			$aFolderArray = _RecFileListToArray($sRoot, "*", 2, 1, 1, 1, "$*;System Volume Information;RECYCLED;_Restore")
			If IsArray($aFolderArray) Then
				; Add each folder
				For $i = 1 To $aFolderArray[0]
					$sText = $aFolderArray[$i]
					; Count \
					StringRegExpReplace($sText, "\\", "")
					$iLevel = @extended
					; Extract folder name from path
					$sText = StringRegExpReplace($sText, "(.*\\|^)(.*)\\", "$2")
					; Add to TV and store item ControlID
					$aLevel[$iLevel] = GUICtrlCreateTreeViewItem($sText, $aLevel[$iLevel - 1])
					; List files within folder if required
					If $iDisplay < 2 Then _CFF_ListFiles($sRoot & $aFolderArray[$i], $sFile_Mask, $aLevel[$iLevel])
				Next
			EndIf
		EndIf
	EndIf
	; Look for files in Root folder if required
	If $iDisplay < 2 Then _CFF_ListFiles($sRoot, $sFile_Mask, $hTreeView)

	; Switch back to main dialog
	GUISwitch($hCFF_Win)

EndFunc   ;==>_CFF_TV_Fill

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _CFF_ListFiles
; Description ...: Adds files to an existing folder structure to allow file selection.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func _CFF_ListFiles($sFolderPath, $sFile_Mask, $hTreeView_Parent)

	Local $aFileArray = _RecFileListToArray($sFolderPath, $sFile_Mask, 1, 0, 1, 0)
	If IsArray($aFileArray) Then
		For $j = 1 To $aFileArray[0]
			GUICtrlCreateTreeViewItem($aFileArray[$j], $hTreeView_Parent)
		Next
	EndIf

EndFunc   ;==>_CFF_ListFiles

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _CFF_GetSel
; Description ...: Retrieves selected TreeView item and if file confirms match to file mask.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func _CFF_GetSel($hTreeView_Handle, $iDisplay, $sFile_Mask, $hTreeView_Item = 0)

	Local $sSelectedPath = StringReplace(_GUICtrlTreeView_GetTree($hTreeView_Handle, $hTreeView_Item), "|", "\")

	If $iDisplay = 2 Then Return $sSelectedPath

	; If files required then convert file mask to SRE format
	If $sFile_Mask Then
		; Strip WS and insert | for ;
		$sFile_Mask = StringReplace(StringStripWS(StringRegExpReplace($sFile_Mask, "\s*;\s*", ";"), 3), ";", "|")
		; Convert to SRE pattern
		$sFile_Mask = StringReplace(StringReplace(StringRegExpReplace($sFile_Mask, "(\^|\$|\.)", "\\$1"), "?", "."), "*", ".*?")
		; Add prefix and suffix
		$sFile_Mask = "(?i)^(" & $sFile_Mask & ")\z"
		; Check return is a file
		If StringRegExp($sSelectedPath, $sFile_Mask) Then
			Return $sSelectedPath
		Else
			Return ""
		EndIf
	Else
		Return $sSelectedPath
	EndIf

EndFunc   ;==>_CFF_GetSel