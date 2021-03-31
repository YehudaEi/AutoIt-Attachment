#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ Author:				Ian Maxwell (llewxam @ AutoIt forums)
;~ Date:				September 4 2014
;~ AutoIt version:		3.3.12.0
;~ Credits and thanks:
;~ Ascend4nt for _FileFindEx, parts of which I have placed directly in this script rather than requiring users to download a separate UDF.
;~		 The complete _FileFindEx can be found at http://www.autoitscript.com/forum/topic/90545-filefindex-get-more-from-filefolder-searches
;~ DXRW4E for his version of _FileListToArrayEx which I stripped heavily for top speed , not flexability.
;~ 		 The complete version can be found at http://www.autoitscript.com/forum/topic/131277-filelisttoarrayex

#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

FileInstall("delbat.bat", @TempDir & "\delbat.bat", 1)
FileInstall("delpath.bat", @TempDir & "\delpath.bat", 1)
FileInstall("robocopy.exe", @SystemDir & "\robocopy.exe", 1)

Local $rKey = "HKCU\Control Panel\International"
$sDecimal = RegRead($rKey, "sDecimal")
$sThousands = RegRead($rKey, "sThousand")

Local $BytesSuffix[6] = [" B", " KB", " MB", " GB", " TB", " PB"], $ClickingAllowed = True, $DisplayDelay = 500, $_FFX_iFileFindHandleCount = 0, $_COMMON_KERNEL32DLL = DllOpen("kernel32.dll")
Local $_FFX_stFileFindInfo, $ChooseDrive, $Drive, $DirCount, $DirSize, $DriveType, $fDblClk, $Gui, $RootListBreak, $ScanningPath, $ShowPath, $Status, $Timer, $TotalFileCount, $TotalFileSize, $Up

_ScanForDrives()

Func _Main($StartPoint)
	$Gui = GUICreate("MyDirStat v2", 710, 550)
	GUISetBkColor(0xb2ccff, $Gui)
	GUISetFont(10)
	GUICtrlCreateLabel("Current Path:", 10, 10, 100, 20)
	$ShowPath = GUICtrlCreateLabel("", 110, 10, 610, 40)
	Global $DisplayInfo = _GUICtrlListView_Create($Gui, "File/Folder|Size|File Count", 10, 60, 577, 448)
	_GUICtrlListView_SetExtendedListViewStyle($DisplayInfo, $LVS_EX_FULLROWSELECT)
	_GUICtrlListView_SetColumnWidth($DisplayInfo, 0, 360)
	_GUICtrlListView_SetColumnWidth($DisplayInfo, 1, 100)
	_GUICtrlListView_SetColumnWidth($DisplayInfo, 2, 100)
	Local $aParts[9] = [50, 55, 115, 120, 240, 245, 610, 615, -1]
	$Status = _GUICtrlStatusBar_Create($Gui)
	_GUICtrlStatusBar_SetParts($Status, $aParts)
	$Up = GUICtrlCreateButton("Up One Folder", 600, 60, 100, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$OpenFolder = GUICtrlCreateButton("Open Folder", 600, 90, 100, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Google = GUICtrlCreateButton("Google Item", 600, 140, 100, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$DeleteFile = GUICtrlCreateButton("Delete File", 600, 170, 100, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$DeleteDir = GUICtrlCreateButton("Delete Folder", 600, 200, 100, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$EmptyDir = GUICtrlCreateButton("Empty Folder", 600, 230, 100, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$EnterDummy = GUICtrlCreateDummy()
	Local $AccelKeys[1][2] = [["{ENTER}", $EnterDummy]]
	GUISetAccelerators($AccelKeys)
	GUISetState(@SW_SHOW, $Gui)

	Global $FolderCount = 0
	$Timer = TimerInit()
	_BuildRootMap($StartPoint)

	Local $Index = 0, $OldIndex = -1
	_GUICtrlListView_SetItemSelected($DisplayInfo, $Index)
	Global $SortMethod = True
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	Do
		$Index = _GUICtrlListView_GetSelectedIndices($DisplayInfo)
		If $OldIndex <> $Index Then
			$CurrentItem = GUICtrlRead($ShowPath) & _GUICtrlListView_GetItemText($DisplayInfo, $Index, 0)
			If StringRight($CurrentItem, 7) == "<Files>" Then
				GUICtrlSetState($DeleteDir, $GUI_DISABLE)
				GUICtrlSetState($Google, $GUI_DISABLE)
				GUICtrlSetState($OpenFolder, $GUI_DISABLE)
				GUICtrlSetState($EmptyDir, $GUI_DISABLE)
				GUICtrlSetState($DeleteFile, $GUI_DISABLE)
			Else
				$Attrib = FileGetAttrib($CurrentItem)
				If StringInStr($Attrib, "D") Then
					GUICtrlSetState($Google, $GUI_ENABLE)
					GUICtrlSetState($DeleteDir, $GUI_ENABLE)
					GUICtrlSetState($OpenFolder, $GUI_ENABLE)
					GUICtrlSetState($EmptyDir, $GUI_ENABLE)
					GUICtrlSetState($DeleteFile, $GUI_DISABLE)
				Else
					GUICtrlSetState($DeleteDir, $GUI_DISABLE)
					GUICtrlSetState($Google, $GUI_ENABLE)
					GUICtrlSetState($OpenFolder, $GUI_DISABLE)
					GUICtrlSetState($EmptyDir, $GUI_DISABLE)
					GUICtrlSetState($DeleteFile, $GUI_ENABLE)
				EndIf
			EndIf
		EndIf
		$OldIndex = $Index

		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then Exit
		If $MSG == $Google Then
			$GoogleItem = StringReplace($CurrentItem, "<Files>\", "")
			ShellExecute(Chr(34) & "http://www.google.com/search?hl=en&noj=1&site=webhp&source=hp&q=" & Chr(34) & $GoogleItem & Chr(34) & Chr(34))
		EndIf
		If $MSG == $OpenFolder Then
			$FolderToOpen = StringReplace($CurrentItem, "<Files>\", "")
			ShellExecute($FolderToOpen)
		EndIf
		If $MSG == $DeleteFile Then
			$DelPath = StringReplace($CurrentItem, "<Files>\", "")
			$YesOrNo = MsgBox(4, "Delete File", "Really delete the following file?" & @CR & @CR & $DelPath)
			If $YesOrNo == 6 Then
				$Timer = TimerInit()
				AdlibRegister("_Display", $DisplayDelay)
				FileDelete($DelPath)
				AdlibUnRegister()
				If FileExists($DelPath) Then MsgBox(0, "ERROR", "The specified file could not be deleted.  Please make sure the file is not open or protected.  You may also need to run this tool with administrative privleges to delete the file.")
				_GUICtrlStatusBar_SetText($Status, "Done", 6)
				_GUICtrlListView_DeleteItemsSelected($DisplayInfo)
				_GUICtrlStatusBar_SetText($Status, _ByteSuffix(DriveSpaceFree($Drive) * 1024 * 1024) & " Free", 8)
			EndIf
		EndIf
		If $MSG == $DeleteDir Then
			$YesOrNo = MsgBox(4, "Delete Folder", "Really delete the following folder?" & @CR & @CR & $CurrentItem)
			If $YesOrNo == 6 Then
				_GUICtrlStatusBar_SetText($Status, "Deleting", 6)
				$Timer = TimerInit()
				AdlibRegister("_Display", $DisplayDelay)
				ShellExecuteWait(@TempDir & "\delbat.bat", Chr(34) & $CurrentItem & Chr(34), "", "open", @SW_HIDE)
				AdlibUnRegister()
				_GUICtrlStatusBar_SetText($Status, _NiceTime(TimerDiff($Timer) / 1000), 0)
				_GUICtrlStatusBar_SetText($Status, "Done", 6)
				$CheckEmpty = DirGetSize($CurrentItem, 1)
				If @error <> 1 Then
					_GUICtrlListView_SetItemText($DisplayInfo, $Index, _ByteSuffix($CheckEmpty[0]), 1)
					_GUICtrlListView_SetItemText($DisplayInfo, $Index, _StringAddThousandsSep($CheckEmpty[1]), 2)
					MsgBox(0, "ERROR", "The specified folder could not be deleted.  Please make sure there are no files open or protected in the folder.  You may also need to run this tool with administrative privleges to delete the folder.")
				Else
					_GUICtrlListView_DeleteItemsSelected($DisplayInfo)
				EndIf
				_GUICtrlStatusBar_SetText($Status, _ByteSuffix(DriveSpaceFree($Drive) * 1024 * 1024) & " Free", 8)
			EndIf
		EndIf
		If $MSG == $EmptyDir Then
			$YesOrNo = MsgBox(4, "Empty Folder", "Really empty the following folder?" & @CR & @CR & $CurrentItem)
			If $YesOrNo == 6 Then
				_GUICtrlStatusBar_SetText($Status, "Emptying", 6)
				$Timer = TimerInit()
				AdlibRegister("_Display", $DisplayDelay)
				ShellExecuteWait(@TempDir & "\delpath.bat", Chr(34) & $CurrentItem & Chr(34), "", "open", @SW_HIDE)
				AdlibUnRegister()
				_GUICtrlStatusBar_SetText($Status, "Done", 6)
				$CheckEmpty = DirGetSize($CurrentItem, 1)
				If $CheckEmpty[1] > 0 Then
					MsgBox(0, "ERROR", "The specified folder could not be emptied.  Please make sure there are no files open or protected in the folder.  You may also need to run this tool with administrative privleges to empty the folder.")
				EndIf
				_GUICtrlListView_SetItemText($DisplayInfo, $Index, _ByteSuffix($CheckEmpty[0]), 1)
				_GUICtrlListView_SetItemText($DisplayInfo, $Index, _StringAddThousandsSep($CheckEmpty[1]), 2)
				_GUICtrlStatusBar_SetText($Status, _ByteSuffix(DriveSpaceFree($Drive) * 1024 * 1024) & " Free", 8)
			EndIf
		EndIf
		If $MSG == $Up Then
			$CurrentPath = GUICtrlRead($ShowPath)
			$Where = StringInStr($CurrentPath, "\", 0, -2) - 1
			$UpOne = StringLeft($CurrentPath, $Where)
			$ClickingAllowed = False
			$Timer = TimerInit()
			_BuildRootMap($UpOne)
			$ClickingAllowed = True
		EndIf
		If $fDblClk == True Or $MSG == $EnterDummy Then
			$fDblClk = False
			$Index = _GUICtrlListView_GetSelectedIndices($DisplayInfo)
			If $Index > -1 And $Index <> "" Then
				$Path = GUICtrlRead($ShowPath) & _GUICtrlListView_GetItemText($DisplayInfo, $Index, 0)
				If StringRight($Path, 7) == "<Files>" Then
					$ClickingAllowed = False
					$Timer = TimerInit()
					_ShowFiles($Path)
					$ClickingAllowed = True
					GUICtrlSetState($Up, $GUI_ENABLE)
				Else
					$Attrib = FileGetAttrib(StringReplace($Path, "<Files>\", ""))
					If StringInStr($Attrib, "D") Then
						$ClickingAllowed = False
						$Timer = TimerInit()
						_BuildRootMap($Path)
						$ClickingAllowed = True
					Else
						ShellExecute(StringReplace(Chr(34) & $Path & Chr(34), "<Files>\", ""))
					EndIf
				EndIf
			EndIf
		EndIf
	Until 1 = 2
EndFunc   ;==>_Main


Func _ScanForDrives()
	$AllDrives = DriveGetDrive("ALL")
	$DetermineHeight = $AllDrives[0] * 50 + 155
	GUIDelete($ChooseDrive)
	$ChooseDrive = GUICreate("Choose Drive", 400, $DetermineHeight)
	GUISetBkColor(0xb2ccff, $ChooseDrive)
	Local $Radio[$AllDrives[0]]
	$DriveGroup = GUICtrlCreateGroup("", 10, 10, 380, $DetermineHeight - 100)
	$Height = 30
	For $a = 1 To $AllDrives[0]
		$DriveTotal = DriveSpaceTotal($AllDrives[$a])
		If $DriveTotal > 0 Then
			GUICtrlCreateLabel("Total Space:", 105, $Height + 6, 70, 20)
			GUICtrlCreateLabel("Free Space:", 315, $Height + 6, 70, 20)
			$Height += 20
			$Radio[$a - 1] = GUICtrlCreateRadio("Drive " & StringUpper($AllDrives[$a]), 30, $Height - 10, 70, 25)
			$DriveFree = DriveSpaceFree($AllDrives[$a])
			GUICtrlCreateLabel(_ByteSuffix($DriveTotal * 1024 * 1024), 105, $Height + 6, 70, 20)
			GUICtrlCreateProgress(180, $Height - 8, 120, 20)
			GUICtrlSetData(-1, 100 - ($DriveFree / $DriveTotal * 100))
			GUICtrlCreateLabel(_ByteSuffix($DriveFree * 1024 * 1024), 315, $Height + 6, 70, 20)
			$Height += 30
		EndIf
	Next
	$Specify = GUICtrlCreateRadio("Specify Path", 30, $Height + 40, 85, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$PathSpecified = GUICtrlCreateInput("", 120, $Height + 44, 205, 18)
	GUICtrlSetBkColor(-1, 0xffffff)
	$BrowsePath = GUICtrlCreateButton("...", 340, $Height + 43, 40, 19)
	GUICtrlSetFont(-1, 9, 800)
	$Rescan = GUICtrlCreateButton("Rescan", 310, $Height + 105, 80, 25)
	$Go = GUICtrlCreateButton("GO", 160, $Height + 115, 80, 40)
	Local $AccelKeys[1][2] = [["{ENTER}", $Go]]
	GUISetAccelerators($AccelKeys)
	GUISetState(@SW_SHOW, $ChooseDrive)
	Do
		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then Exit
		If $MSG == $Rescan Then
			_ScanForDrives()
		EndIf
		If $MSG == $BrowsePath Then
			$WhereSpecify = FileSelectFolder("Choose the path to start enumeration from.", "")
			GUICtrlSetData($PathSpecified, $WhereSpecify)
		EndIf
		If $MSG == $Go Then
			For $a = 1 To $AllDrives[0]
				If BitAND(GUICtrlRead($Radio[$a - 1]), $GUI_CHECKED) Then
					Global $Drive = StringUpper($AllDrives[$a])
					$DriveType = DriveGetType($Drive)
					GUIDelete($ChooseDrive)
					_Main($Drive)
				ElseIf BitAND(GUICtrlRead($Specify), $GUI_CHECKED) Then
					$WhatWasSpecified = GUICtrlRead($PathSpecified)
					If $WhatWasSpecified == "" Then
						MsgBox(16, "ERROR", "You must specify a path or choose one of the listed drives.")
						ExitLoop
					Else
						$Attrib = FileGetAttrib($WhatWasSpecified)
						If Not StringInStr($Attrib, "D") Then
							MsgBox(16, "ERROR", "You must specify a directory.  Make sure the path you specified exists.")
							ExitLoop
						Else
							Global $Drive = StringUpper(StringLeft($WhatWasSpecified, 2))
							GUIDelete($ChooseDrive)
							$DriveType = DriveGetType($Drive)
							_Main($WhatWasSpecified)
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	Until 1 = 2
EndFunc   ;==>_ScanForDrives


Func _BuildRootMap($sDir)
	Local $DirList = "", $RootList = ""
	If StringRight($sDir, 1) <> "\" Then $sDir &= "\"
	$PathLength = StringLen($sDir)
	GUICtrlSetData($ShowPath, $sDir)
	_GUICtrlStatusBar_SetText($Status, _ByteSuffix(DriveSpaceFree($Drive) * 1024 * 1024) & " Free", 8)
	_GUICtrlListView_DeleteAllItems($DisplayInfo)
	GUICtrlSetState($Up, $GUI_DISABLE)
	_GUICtrlStatusBar_SetText($Status, "Enumerating root folders", 6)
	_GUICtrlListView_BeginUpdate($DisplayInfo)

	$f_search = FileFindFirstFile($sDir & "*.*")
	Do
		$f_file = FileFindNextFile($f_search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($sDir & $f_file), "D") Then
			$DirList &= $sDir & $f_file & "|"
		Else
			$RootList &= $sDir & $f_file & "|"
		EndIf
	Until True = False
	$RootListBreak = StringSplit(StringTrimRight($RootList, 1), "|", 2)
	$DirListBreak = StringSplit(StringTrimRight($DirList, 1), "|", 2)
	_ArraySort($DirListBreak, 0)

	$TotalFileSize = 0
	$TotalFileCount = 0
	If $RootListBreak[0] <> "" Then
		$TotalFileCount = UBound($RootListBreak)
		For $a = 0 To UBound($RootListBreak) - 1
			$TotalFileSize += FileGetSize($RootListBreak[$a])
		Next
	EndIf

	_GUICtrlListView_AddItem($DisplayInfo, "<Files>")
	_GUICtrlListView_SetItemText($DisplayInfo, 0, _ByteSuffix($TotalFileSize), 1)
	_GUICtrlListView_SetItemText($DisplayInfo, 0, _StringAddThousandsSep($TotalFileCount), 2)
	For $a = 0 To UBound($DirListBreak) - 1
		_GUICtrlListView_AddItem($DisplayInfo, StringTrimLeft($DirListBreak[$a], $PathLength))
	Next
	_GUICtrlListView_EndUpdate($DisplayInfo)

	AdlibRegister("_Display", $DisplayDelay)
	If $DirListBreak[0] <> "" Then
		For $a = 0 To UBound($DirListBreak) - 1
			$DirCount = 0
			$DirSize = 0
			$FolderCount = $a + 1
			If $DriveType == "Fixed" Then
				_LocalDriveScan($DirListBreak[$a])
			ElseIf $DriveType == "Network" Then
				_NetworkDriveScan($DirListBreak[$a])
			EndIf
			_GUICtrlListView_SetItemText($DisplayInfo, $FolderCount, _ByteSuffix($DirSize), 1)
			_GUICtrlListView_SetItemText($DisplayInfo, $FolderCount, _StringAddThousandsSep($DirCount), 2)
		Next
	EndIf
	AdlibUnRegister()
	_Display()
	_GUICtrlStatusBar_SetText($Status, _StringAddThousandsSep($TotalFileCount) & " Files", 4)
	_GUICtrlStatusBar_SetText($Status, "Done", 6)

	$Where = StringInStr($sDir, "\", 0, -2) - 1
	If $Where > 0 Then
		GUICtrlSetState($Up, $GUI_ENABLE)
	EndIf

	$Index = -1
	$OldIndex = -2
	_GUICtrlListView_ClickItem($DisplayInfo, 0, "left", False, 2)
	ControlFocus("MyDirStat v2", "", $DisplayInfo)
EndFunc   ;==>_BuildRootMap


Func _NetworkDriveScan($fa_dir)
	$ScanningPath = $fa_dir
	If StringRight($fa_dir, 1) <> "\" Then $fa_dir &= "\"
	$aFileFindArray = _FileFindExFirstFile($fa_dir & "*.*")
	If $aFileFindArray <> -1 Then
		Do
			If BitAND($aFileFindArray[2], 16) Then
				If $aFileFindArray[0] = '.' Or $aFileFindArray[0] = '..' Then ContinueLoop
				_NetworkDriveScan($fa_dir & $aFileFindArray[0])
			Else
				$DirCount += 1
				$TotalFileCount += 1
			EndIf
			$DirSize += $aFileFindArray[3]
			$TotalFileSize += $aFileFindArray[3]
		Until Not _FileFindExNextFile($aFileFindArray)
		_FileFindExClose($aFileFindArray)
	EndIf
EndFunc   ;==>_NetworkDriveScan


Func _LocalDriveScan($Path)
	If StringRight($Path, 1) <> "\" Then $Path &= "\"
	$PathLength = StringLen($Path)
	Local $Search = FileFindFirstFile($Path & "*.*")
	_FileListToArrayExStripped($Path)
	_GUICtrlListView_SetItemText($DisplayInfo, $FolderCount, _ByteSuffix($DirSize), 1)
	_GUICtrlListView_SetItemText($DisplayInfo, $FolderCount, _StringAddThousandsSep($DirCount), 2)
EndFunc   ;==>_LocalDriveScan


Func _ShowFiles($Path)
	$TotalFileSize = 0
	$TotalFileCount = 0
	$PathLength = StringLen($Path) - 7;9
	GUICtrlSetData($ShowPath, $Path & "\")
	_GUICtrlListView_DeleteAllItems($DisplayInfo)
	_GUICtrlStatusBar_SetText($Status, "Listing", 6)
	_GUICtrlStatusBar_SetText($Status, _ByteSuffix(DriveSpaceFree($Drive) * 1024 * 1024) & " Free", 8)
	For $a = 0 To UBound($RootListBreak) - 1
		$FileSize = FileGetSize($RootListBreak[$a])
		_GUICtrlListView_AddItem($DisplayInfo, StringTrimLeft($RootListBreak[$a], $PathLength))
		_GUICtrlListView_SetItemText($DisplayInfo, $a, _ByteSuffix($FileSize), 1)
		$TotalFileCount += 1
		$TotalFileSize += $FileSize
	Next
	_Display()
	_GUICtrlStatusBar_SetText($Status, "Done", 6)
	_GUICtrlListView_SetItemSelected($DisplayInfo, 0)
	ControlFocus("MyDirStat", "", $DisplayInfo)
	$Index = 0
	$OldIndex = -1
EndFunc   ;==>_ShowFiles


Func _Display()
	_GUICtrlStatusBar_SetText($Status, _NiceTime(TimerDiff($Timer) / 1000), 0)
	_GUICtrlStatusBar_SetText($Status, _ByteSuffix($TotalFileSize), 2)
	_GUICtrlStatusBar_SetText($Status, _StringAddThousandsSep($TotalFileCount) & " Files (" & Int($TotalFileCount / TimerDiff($Timer) * 1000) & "/s)", 4)
	_GUICtrlStatusBar_SetText($Status, $ScanningPath, 6)
	_GUICtrlListView_SetItemText($DisplayInfo, $FolderCount, _ByteSuffix($DirSize), 1)
	_GUICtrlListView_SetItemText($DisplayInfo, $FolderCount, _StringAddThousandsSep($DirCount), 2)
EndFunc   ;==>_Display


Func _NiceTime($ElapsedSeconds)
	Local $ElapsedMinutes, $ElapsedHours
	Do
		If $ElapsedSeconds >= 60 Then
			$ElapsedSeconds -= 60
			$ElapsedMinutes += 1
		EndIf
	Until $ElapsedSeconds < 60
	Do
		If $ElapsedMinutes >= 60 Then
			$ElapsedMinutes -= 60
			$ElapsedHours += 1
		EndIf
	Until $ElapsedMinutes < 60
	Return StringFormat('%.2i', $ElapsedHours) & ":" & StringFormat('%.2i', $ElapsedMinutes) & ":" & StringFormat('%.2i', $ElapsedSeconds)
EndFunc   ;==>_NiceTime


Func _ByteSuffix($Bytes)
	Local $x, $BytesSuffix[6] = [" B", " KB", " MB", " GB", " TB", " PB"]
	While $Bytes > 1023
		$x += 1
		$Bytes /= 1024
	WEnd
	Return StringFormat('%.2f', $Bytes) & $BytesSuffix[$x]
EndFunc   ;==>_ByteSuffix


Func _StringAddThousandsSep($sText)
;~ 	If Not StringIsInt($sText) And Not StringIsFloat($sText) Then Return 0  ;not needed for this script, value will always be known, so skipping for time savings.  Ordinarily turn on!
	Local $aSplit = StringSplit($sText, "-" & $sDecimal)
	Local $iInt = 1, $iMod
	If Not $aSplit[1] Then
		$aSplit[1] = "-"
		$iInt = 2
	EndIf
	If $aSplit[0] > $iInt Then
		$aSplit[$aSplit[0]] = "." & $aSplit[$aSplit[0]]
	EndIf
	$iMod = Mod(StringLen($aSplit[$iInt]), 3)
	If Not $iMod Then $iMod = 3
	$aSplit[$iInt] = StringRegExpReplace($aSplit[$iInt], '(?<=\d{' & $iMod & '})(\d{3})', $sThousands & '\1')
	For $i = 2 To $aSplit[0]
		$aSplit[1] &= $aSplit[$i]
	Next
	Return $aSplit[1]
EndFunc   ;==>_StringAddThousandsSep


Func _ByteSuffixReverse($Bytes)
	Local $x, $BytesSuffix[6] = [" B", " KB", " MB", " GB", " TB", " PB"]
	For $x = 5 To 0 Step -1
		If StringRight($Bytes, 3) == $BytesSuffix[$x] Then
			$TrimmedBytes = StringTrimRight($Bytes, 3)
			$TrimmedBytes *= 1024
			$Bytes = $TrimmedBytes & $BytesSuffix[$x - 1]
		EndIf
	Next
	Return StringTrimRight($Bytes, 2)
EndFunc   ;==>_ByteSuffixReverse


Func _FileListToArrayExStripped($sPath)
	Local $sRet = "", $sReturnFormat = ""
	$sPath = StringRegExpReplace($sPath, "[\\/]+\z", "") & "\"
	Local $sOrigPathLen = StringLen($sPath), $aQueue[64] = [1, $sPath], $iQMax = 63
	While $aQueue[0]
		$WorkFolder = $aQueue[$aQueue[0]]
		$aQueue[0] -= 1
		$Search = FileFindFirstFile($WorkFolder & "*") ; get full list of current folder
		If @error Then ContinueLoop
		$sReturnFormat = $WorkFolder
		While 1 ; process current folder
			$file = FileFindNextFile($Search)
			If @error Then ExitLoop
			If @extended Then ; Folder
				If $aQueue[0] = $iQMax Then
					$iQMax += 128
					ReDim $aQueue[$iQMax + 1]
				EndIf
				$aQueue[0] += 1
				$aQueue[$aQueue[0]] = $WorkFolder & $file & "\"
				ContinueLoop
			EndIf
			$ScanningPath = $sReturnFormat
			$Size = FileGetSize($sReturnFormat & $file)
			$DirCount += 1
			$DirSize += $Size
			$TotalFileCount += 1
			$TotalFileSize += $Size
		WEnd
		FileClose($Search)
	WEnd
EndFunc   ;==>_FileListToArrayExStripped


Func _FileFindExFirstFile($sSearchString)
	If Not IsString($sSearchString) Then Return SetError(1, 0, -1)
	Local $aRet, $iSearchLen = StringLen($sSearchString)
	If $iSearchLen > 259 Then
		If $iSearchLen > (32766 - 4) Then Return SetError(4, 0, -1)
		$sSearchString = '\\?\' & $sSearchString
	EndIf
	If Not $_FFX_iFileFindHandleCount Then
		$_FFX_stFileFindInfo = DllStructCreate("align 4;dword;uint64;uint64;uint64;dword;dword;dword;dword;wchar[260];wchar[14]")
	EndIf
	$aRet = DllCall($_COMMON_KERNEL32DLL, "handle", "FindFirstFileW", "wstr", $sSearchString, "ptr", DllStructGetPtr($_FFX_stFileFindInfo))
	If @error Then Return SetError(2, @error, -1)
	If $aRet[0] = -1 Then Return SetError(3, 0, -1)
	$_FFX_iFileFindHandleCount += 1
	Local $aReturnArray[9]
	$aReturnArray[8] = $aRet[0]
	$aReturnArray[0] = DllStructGetData($_FFX_stFileFindInfo, 9)
	$aReturnArray[1] = DllStructGetData($_FFX_stFileFindInfo, 10)
	$aReturnArray[2] = DllStructGetData($_FFX_stFileFindInfo, 1)
	$aReturnArray[3] = (DllStructGetData($_FFX_stFileFindInfo, 5) * 4294967296) + DllStructGetData($_FFX_stFileFindInfo, 6)
	$aReturnArray[4] = DllStructGetData($_FFX_stFileFindInfo, 2)
	$aReturnArray[5] = DllStructGetData($_FFX_stFileFindInfo, 3)
	$aReturnArray[6] = DllStructGetData($_FFX_stFileFindInfo, 4)
	$aReturnArray[7] = 0
	If BitAND($aReturnArray[2], 0x400) Then $aReturnArray[7] = DllStructGetData($_FFX_stFileFindInfo, 7)
	Return $aReturnArray
EndFunc   ;==>_FileFindExFirstFile


Func _FileFindExNextFile(ByRef $aFileFindArray)
	If Not IsArray($aFileFindArray) Or Not $_FFX_iFileFindHandleCount Then Return SetError(1, 0, False)
	Local $aRet = DllCall($_COMMON_KERNEL32DLL, "bool", "FindNextFileW", "handle", $aFileFindArray[8], "ptr", DllStructGetPtr($_FFX_stFileFindInfo))
	If @error Then Return SetError(2, @error, False)
	If Not $aRet[0] Then Return False
	$aFileFindArray[0] = DllStructGetData($_FFX_stFileFindInfo, 9)
	$aFileFindArray[1] = DllStructGetData($_FFX_stFileFindInfo, 10)
	$aFileFindArray[2] = DllStructGetData($_FFX_stFileFindInfo, 1)
	$aFileFindArray[3] = (DllStructGetData($_FFX_stFileFindInfo, 5) * 4294967296) + DllStructGetData($_FFX_stFileFindInfo, 6)
	$aFileFindArray[4] = DllStructGetData($_FFX_stFileFindInfo, 2)
	$aFileFindArray[5] = DllStructGetData($_FFX_stFileFindInfo, 3)
	$aFileFindArray[6] = DllStructGetData($_FFX_stFileFindInfo, 4)
	$aFileFindArray[7] = 0
	If BitAND($aFileFindArray[2], 0x400) Then $aFileFindArray[7] = DllStructGetData($_FFX_stFileFindInfo, 7)
	Return True
EndFunc   ;==>_FileFindExNextFile


Func _FileFindExClose(ByRef $aFileFindArray)
	If Not IsArray($aFileFindArray) Or Not $_FFX_iFileFindHandleCount Then Return SetError(1, 0, False)
	Local $aRet = DllCall($_COMMON_KERNEL32DLL, "bool", "FindClose", "handle", $aFileFindArray[8])
	If @error Then SetError(2, @error, False)
	If Not $aRet[0] Then Return SetError(3, 0, False)
	$aFileFindArray = -1
	$_FFX_iFileFindHandleCount -= 1
	If Not $_FFX_iFileFindHandleCount Then $_FFX_stFileFindInfo = 0
	Return True
EndFunc   ;==>_FileFindExClose


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	If $ClickingAllowed == True Then
		#forceref $hWnd, $iMsg, $iwParam
		Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR

		$hWndListView = $DisplayInfo
		If Not IsHWnd($DisplayInfo) Then $hWndListView = GUICtrlGetHandle($DisplayInfo)

		$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
		$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
		$iCode = DllStructGetData($tNMHDR, "Code")

		$ItemCount = _GUICtrlListView_GetItemCount($DisplayInfo)
		$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
		$tIndex = DllStructGetData($tInfo, "SubItem")

		Switch $hWndFrom
			Case $hWndListView
				Switch $iCode
					Case $NM_DBLCLK
						$fDblClk = True
					Case $LVN_COLUMNCLICK
						#forceref $hWnd, $iMsg, $iwParam
						Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR

						$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
						$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
						$iCode = DllStructGetData($tNMHDR, "Code")

						$hWndListView = $DisplayInfo
						If Not IsHWnd($DisplayInfo) Then $hWndListView = GUICtrlGetHandle($DisplayInfo)

						$ItemCount = _GUICtrlListView_GetItemCount($DisplayInfo) - 1
						If $ItemCount > 0 Then
							$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
							$tIndex = DllStructGetData($tInfo, "SubItem")
							_GUICtrlStatusBar_SetText($Status, "Sorting", 6)
							GUISetCursor(15, 1, $Gui)
							_GUICtrlListView_BeginUpdate($DisplayInfo)

							If $tIndex == 0 Then
								$SortMethod = False
								_GUICtrlListView_SimpleSort($DisplayInfo, $SortMethod, $tIndex)
							EndIf
							If $tIndex == 1 Then
								$SortMethod = True
								For $a = 0 To $ItemCount
									$GetText = _GUICtrlListView_GetItemText($DisplayInfo, $a, $tIndex)
									$Strip = _ByteSuffixReverse($GetText)
									_GUICtrlListView_SetItemText($DisplayInfo, $a, $Strip, $tIndex)
								Next
								_GUICtrlListView_SimpleSort($DisplayInfo, $SortMethod, $tIndex)
								For $a = 0 To $ItemCount
									$GetText = _GUICtrlListView_GetItemText($DisplayInfo, $a, $tIndex)
									_GUICtrlListView_SetItemText($DisplayInfo, $a, _ByteSuffix($GetText), $tIndex)
								Next
							EndIf
							If $tIndex == 2 Then
								$Found = False
								$SortMethod = True
								For $a = 0 To $ItemCount
									$GetText = _GUICtrlListView_GetItemText($DisplayInfo, $a, $tIndex)
									$Strip = StringReplace($GetText, ",", "")
									If $Strip <> "" Then $Found = True
									_GUICtrlListView_SetItemText($DisplayInfo, $a, $Strip, $tIndex)
								Next
								If $Found == True Then
									_GUICtrlListView_SimpleSort($DisplayInfo, $SortMethod, $tIndex)
									For $a = 0 To $ItemCount
										$GetText = _GUICtrlListView_GetItemText($DisplayInfo, $a, $tIndex)
										_GUICtrlListView_SetItemText($DisplayInfo, $a, _StringAddThousandsSep($GetText), $tIndex)
									Next
								EndIf
							EndIf
							GUISetCursor(2, 1, $Gui)
						EndIf
						_GUICtrlListView_EndUpdate($DisplayInfo)
						_GUICtrlStatusBar_SetText($Status, "Done", 6)
				EndSwitch
		EndSwitch
		Return $GUI_RUNDEFMSG
	EndIf
EndFunc   ;==>WM_NOTIFY
