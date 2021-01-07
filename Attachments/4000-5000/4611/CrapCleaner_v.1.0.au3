#include <GUIConstants.au3>

SplashTextOn("CrapCleaner", "Initializing data..." & @CRLF & "This can take a few seconds", 225, 50)
Global $FOLDERS_TO_SEARCH_IN[2]		=	[1, "C:"]
Global $ZERO_BYTE_FILES[1]			=	[0]
Global $ZERO_BYTE_FOLDERS[1]		=	[0]
Global $SHORTCUTS_WITHOUT_TARGET[1]	=	[0]
Global $DRIVE_SIZE					=	DirGetSize("C:", 1)
Global $FILES_SCANNED				=	0
Global $LAST_PROGRESS_DATA			=	0
Global $NEW_PROGRESS_DATA			=	0
SplashOff()

Global $BaseGUI = GUICreate("CrapCleaner v.1.0", 400, 350)
Global $InfoButton = GUICtrlCreateButton("Info", 365, 0, 35, 35, $BS_ICON)
GUICtrlSetImage($InfoButton, "shell32.dll", 154)
GUICtrlSetTip($InfoButton, "Info")
GUICtrlCreateGroup("Found files", 10, 50, 380, 80)
GUICtrlCreateLabel("Files with a size of 0 Bytes:", 20, 70)
GUICtrlCreateLabel("Folders with a size of 0 Bytes:", 20, 90)
GUICtrlCreateLabel("Shortcuts without an existing target file:", 20, 110)
GUICtrlCreateLabel("Scanning:", 10, 150)
Global $ScanningLabel = GUICtrlCreateLabel("", 10, 165, 330, 45)
Global $ProgressBar = GUICtrlCreateProgress(10, 210, 380, 25)
GUICtrlCreateLabel("Files scanned:", 10, 240)
Global $ScannedLabel = GUICtrlCreateLabel("", 85, 240, 305, 20)
Global $StartButton = GUICtrlCreateButton("Start", 10, 300, 40, 40, $BS_ICON)
GUICtrlSetImage($StartButton, "shell32.dll", 137)
GUICtrlSetTip($StartButton, "Start")
Global $DeleteButton = GUICtrlCreateButton("Delete", 350, 300, 40, 40, $BS_ICON)
GUICtrlSetImage($DeleteButton, "shell32.dll", 131)
GUICtrlSetTip($DeleteButton, "Delete files")
GUICtrlSetState($DeleteButton, $GUI_DISABLE)

GUISetState(@SW_SHOW, $BaseGUI)

While 1
	Switch GUIGetMsg()
	Case $GUI_EVENT_CLOSE
		Exit
	Case $InfoButton
		MsgBox(0, "CrapCleaner Info", "This tool scans your computer for the following things:" & @CRLF & "- files and folders with a size of 0 Bytes" & @CRLF & "- shortcuts without an existing target file")
	Case $StartButton
		ScanFolders()
	Case $DeleteButton
		DeleteFiles()
	EndSwitch
WEnd

#region Basic Functions
Func ScanFolders()
	GUICtrlSetState($StartButton, $GUI_DISABLE)
	Local $i = 1
	Local $hSearch
	Local $ERROR
	Local $sCurrentFile
	Local $aFileTime
	Local $aShortcutTarget
	Do
		$hSearch = FileFindFirstFile($FOLDERS_TO_SEARCH_IN[$i] & "\*.*")
		$ERROR = 0
		Do
			$sCurrentFile = FileFindNextFile($hSearch)
			If @error Then 
				$ERROR = 1
			Else
				GUICtrlSetData($ScanningLabel, $FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile)
				If StringInStr(FileGetAttrib($FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile), "D") Then
					$FOLDERS_TO_SEARCH_IN[0] += 1
					ReDim $FOLDERS_TO_SEARCH_IN[$FOLDERS_TO_SEARCH_IN[0] + 1]
					$FOLDERS_TO_SEARCH_IN[$FOLDERS_TO_SEARCH_IN[0]] = $FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile
					If DirGetSize($FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile) = 0 Then
						$ZERO_BYTE_FOLDERS[0] += 1
						ReDim $ZERO_BYTE_FOLDERS[$ZERO_BYTE_FOLDERS[0] + 1]
						$ZERO_BYTE_FOLDERS[$ZERO_BYTE_FOLDERS[0]] = $FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile
					EndIf
				Else
					If FileGetSize($FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile) = 0 Then
						$ZERO_BYTE_FILES[0]	+= 1
						ReDim $ZERO_BYTE_FILES[$ZERO_BYTE_FILES[0] + 1]
						$ZERO_BYTE_FILES[$ZERO_BYTE_FILES[0]] = $FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile
					ElseIf StringRight($sCurrentFile, 4) = ".lnk" Then
						$aShortCutTarget = FileGetShortcut($FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile)
						If Not FileExists($aShortCutTarget[0]) Then
							$SHORTCUTS_WITHOUT_TARGET[0] += 1
							ReDim $SHORTCUTS_WITHOUT_TARGET[$SHORTCUTS_WITHOUT_TARGET[0] + 1]
							$SHORTCUTS_WITHOUT_TARGET[$SHORTCUTS_WITHOUT_TARGET[0]] = $FOLDERS_TO_SEARCH_IN[$i] & "\" & $sCurrentFile
						EndIf
					EndIf
					$FILES_SCANNED += 1
				EndIf
				$NEW_PROGRESS_DATA = Ceiling(($FILES_SCANNED / $DRIVE_SIZE[1]) * 100)
				If $NEW_PROGRESS_DATA > $LAST_PROGRESS_DATA Then
					GUICtrlSetData($ProgressBar, $NEW_PROGRESS_DATA)
					$LAST_PROGRESS_DATA = $NEW_PROGRESS_DATA
				EndIf
				GUICtrlSetData($ScannedLabel, $FILES_SCANNED)
			EndIf
			If GUIGetMsg() = $GUI_EVENT_CLOSE Then Exit
		Until $ERROR
		FileClose($hSearch)
		$i += 1
	Until $i > $FOLDERS_TO_SEARCH_IN[0]
	GUICtrlDelete($ScanningLabel)
	SetData()
	GUICtrlSetState($DeleteButton, $GUI_ENABLE)
	MsgBox(0, "CrapCleaner", "Finished scanning!")

EndFunc

Func SetData()
	GUICtrlCreateLabel($ZERO_BYTE_FILES[0], 220, 70)
	GUICtrlCreateLabel($ZERO_BYTE_FOLDERS[0], 220, 90)
	GUICtrlCreateLabel($SHORTCUTS_WITHOUT_TARGET[0], 220, 110)
EndFunc

Func DeleteFiles()
	GUICtrlSetState($DeleteButton, $GUI_DISABLE)
	SplashTextOn("CrapCleaner", "Deleting files...", 150, 30)
	Local $i
	For $i = 1 To $ZERO_BYTE_FILES[0]
		FileDelete($ZERO_BYTE_FILES[$i])
	Next
	Local $j
	For $j = 1 To $ZERO_BYTE_FOLDERS[0]
		DirRemove($ZERO_BYTE_FOLDERS[$j])
	Next
	Local $k
	For $k = 1 To $SHORTCUTS_WITHOUT_TARGET[0]
		FileDelete($SHORTCUTS_WITHOUT_TARGET[$k])
	Next
	SplashOff()
	MsgBox(0, "CrapCleaner", "Files deleted!")
EndFunc
#endregion