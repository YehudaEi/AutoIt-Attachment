;================== iCopy ==================;
; -Author: _Kurt			      			;
; -Requirements:  You need to have iTunes	;
;  installed on your computer if you are	;
;  using the "copy to itunes" option		;
; -Tested using 80GB iPod Video				;
;===========================================;

#include <GUIListView.au3>
#include <GUIConstants.au3>

Global Const $MY_MUSIC = 0xD
Global $oiTunes, $dll = DllOpen("user32.dll"), $iPodDrive
$GUI = GUICreate("iCopy - Copy files from iPod to Computer", 395, 400)
$grp1 = GUICtrlCreateGroup("1. Select iPod ", 8, 8, 321, 113)
$drives = GUICtrlCreateListView(" |Name|Serial|Capacity|Available", 24, 24, 289, 71)
_GUICtrlListView_SetColumnWidth($drives, 0, 22)
_GUICtrlListView_SetColumnWidth($drives, 1, 60)
$check1 = GUICtrlCreateButton("OK", 208, 96, 105, 17, 0)
GUICtrlSetFont(-1, 9, 1000)
$NOIPOD = GUICtrlCreateLabel("", 25, 96, 180, 17)
$grp2 = GUICtrlCreateGroup("2. Select Filter ", 8, 128, 321, 97)
$_mp3 = GUICtrlCreateCheckbox(".MP3", 24, 144, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$_m4a = GUICtrlCreateCheckbox(".M4A", 24, 168, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$_aiff = GUICtrlCreateCheckbox(".AIFF", 88, 168, 41, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$_wav = GUICtrlCreateCheckbox(".WAV", 88, 144, 49, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$_wma = GUICtrlCreateCheckbox(".WMA", 152, 144, 49, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$_m4p = GUICtrlCreateCheckbox(".M4P", 152, 168, 49, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$_other = GUICtrlCreateCheckbox("Other:", 24, 192, 46, 17)
$_otherinput = GUICtrlCreateInput("", 72, 192, 97, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$check2 = GUICtrlCreateButton("OK", 208, 200, 105, 17, 0)
GUICtrlSetFont(-1, 9, 1000)
$grp3 = GUICtrlCreateGroup("3. Select Destination ", 8, 232, 321, 125)
$radio1 = GUICtrlCreateRadio("Copy to specified directory", 20, 248, 150, 20)
$dest = GUICtrlCreateInput(@MyDocumentsDir, 44, 270, 177, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$browse = GUICtrlCreateButton("Browse..", 225, 272, 80, 17, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetFont(-1, 8, 500)
$radio2 = GUICtrlCreateRadio("Copy directly to iTunes", 20, 296, 150, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel("Must have iTunes installed on your computer", 44, 318, 261, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
$check3 = GUICtrlCreateButton("OK", 208, 335, 105, 17, 0)
GUICtrlSetFont(-1, 9, 1000)
GUICtrlCreateButton("", 340, 152, 49, 49, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateButton("", 340, 274, 49, 49, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateButton("", 340, 40, 49, 49, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
$arrow1 = GUICtrlCreateButton("", 340, 40, 49, 49, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetBkColor(-1, 0x00FF00)
$arrow2 = GUICtrlCreateLabel("<", 345, 42, 49, 49, 0)
GUICtrlSetFont(-1, 30, 100)
GUICtrlSetColor(-1, 0x00BB00)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$arrow3 = GUICtrlCreateLabel("__", 350, 36, 49, 49, 0)
GUICtrlSetFont(-1, 20, 1200)
GUICtrlSetColor(-1, 0x00BB00)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Start = GUICtrlCreateButton("Start", 80, 360, 233, 17, 0)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetFont(-1, 9)
$Progress = GUICtrlCreateProgress(8, 360, 380, 25)
GUICtrlSetState(-1, $GUI_HIDE)
$Status = GUICtrlCreateLabel("", 50, 385, 264, 17, $SS_CENTER)
HighlightGroup($grp1, $check1)
If _GetIpods($drives) = -1 Then
	GUICtrlSetData($NOIPOD, "Please plug in your iPod/MP3")
	GUICtrlSetData($check1, "Refresh List")
EndIf
GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $Start
			If MsgBox(4, "", "Hold {END} to pause the process." & @CRLF & "             Ready to start?") = 6 Then Go()
		Case $msg = $_other
			If GUICtrlRead($_other) = $GUI_CHECKED Then
				MsgBox(0, "Info", "To add other filetypes, type the desired file extensions in" & @CRLF & "the input, seperating each one by a comma. Be sure to include" & @CRLF & "a period in each filetype." & @CRLF & @CRLF & "Example:" & @CRLF & ".txt, .doc, .dat")
				GUICtrlSetState($_otherinput, $GUI_ENABLE)
			Else
				GUICtrlSetState($_otherinput, $GUI_DISABLE)
			EndIf
		Case $msg = $radio1
			GUICtrlSetState($dest, $GUI_ENABLE)
			GUICtrlSetState($browse, $GUI_ENABLE)
		Case $msg = $radio2
			GUICtrlSetState($dest, $GUI_DISABLE)
			GUICtrlSetState($browse, $GUI_DISABLE)
		Case $msg = $browse
			$newdest = FileSelectFolder("Select Destination Folder..", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
			If Not $newdest = "" Then GUICtrlSetData($dest, $newdest)
		Case $msg = $check1
			If GUICtrlRead($check1) = "Refresh List"  Then
				If _GetIpods($drives) <> -1 Then
					GUICtrlSetData($NOIPOD, "")
					GUICtrlSetData($check1, "OK")
				EndIf
				GUICtrlSetData($Status, "List Refreshed.")
				AdlibEnable("StatusDelay", 2000)
			Else
				If Not GUICtrlRead(GUICtrlRead($drives)) <> "0"  Then
					$iPodDrive = StringLeft(GUICtrlRead(GUICtrlRead($drives)), 2)
					HighlightGroup($grp2, $check2)
					GUICtrlSetPos($arrow1, 340, 152)
					GUICtrlSetPos($arrow2, 345, 154)
					GUICtrlSetPos($arrow3, 350, 148)
					GUICtrlSetState($drives, $GUI_DISABLE)
					GUICtrlCreateLabel("\", 355, 58, 49, 49, 0)
					GUICtrlSetFont(-1, 16, 5500)
					GUICtrlSetColor(-1, 0x00FF00)
					GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
					GUICtrlCreateLabel("/", 360, 39, 49, 49, 0)
					GUICtrlSetFont(-1, 34, 10)
					GUICtrlSetColor(-1, 0x00FF00)
					GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				Else
					GUICtrlSetData($Status, "Please select an iPod/MP3 from the list.")
					AdlibEnable("StatusDelay", 2000)
				EndIf
			EndIf
		Case $msg = $check2
			If GUICtrlRead($_other) <> $GUI_CHECKED And GUICtrlRead($_mp3) <> $GUI_CHECKED And _
					GUICtrlRead($_m4a) <> $GUI_CHECKED And GUICtrlRead($_m4p) <> $GUI_CHECKED And _
					GUICtrlRead($_wma) <> $GUI_CHECKED And GUICtrlRead($_wav) <> $GUI_CHECKED And _
					GUICtrlRead($_aiff) <> $GUI_CHECKED Then
				GUICtrlSetData($Status, "Please select at least one filetype.")
				AdlibEnable("StatusDelay", 2000)
			Else
				Local $bad = 0
				If GUICtrlRead($_other) = $GUI_CHECKED Then
					Local $split = StringStripWS(GUICtrlRead($_otherinput), 8)
					$split = StringSplit($split, ",", 1)
					For $i = 1 To UBound($split) - 1
						If StringLeft($split[$i], 1) <> "."  And Not StringIsAlNum(StringRight($split, StringLen($split) - 1)) Then $bad = 1
					Next
				EndIf
				If $bad = 1 Then
					GUICtrlSetData($Status, "One or more Other filetypes does not follow format.")
					AdlibEnable("StatusDelay", 3000)
				Else
					HighlightGroup($grp3, $check3)
					GUICtrlSetPos($arrow1, 340, 274)
					GUICtrlSetPos($arrow2, 345, 278)
					GUICtrlSetPos($arrow3, 350, 272)
					GUICtrlSetState($_mp3, $GUI_DISABLE)
					GUICtrlSetState($_m4a, $GUI_DISABLE)
					GUICtrlSetState($_m4p, $GUI_DISABLE)
					GUICtrlSetState($_aiff, $GUI_DISABLE)
					GUICtrlSetState($_wav, $GUI_DISABLE)
					GUICtrlSetState($_wma, $GUI_DISABLE)
					GUICtrlSetState($_other, $GUI_DISABLE)
					GUICtrlSetState($_otherinput, $GUI_DISABLE)
					GUICtrlCreateLabel("\", 355, 170, 49, 49, 0)
					GUICtrlSetFont(-1, 16, 5500)
					GUICtrlSetColor(-1, 0x00FF00)
					GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
					GUICtrlCreateLabel("/", 360, 151, 49, 49, 0)
					GUICtrlSetFont(-1, 34, 10)
					GUICtrlSetColor(-1, 0x00FF00)
					GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				EndIf
			EndIf
		Case $msg = $check3
			Local $bad = 0
			If GUICtrlRead($radio1) = $GUI_CHECKED Then
				If Not FileExists(GUICtrlRead($dest)) Then
					If MsgBox(4, "Important", "The destination folder you have chosen does not exist." & @CRLF & @CRLF & "Do you want the program to automatically create the destination directory?") = 7 Then $bad = 1
				EndIf
			EndIf
			If $bad = 1 Then
				GUICtrlSetData($Status, "Please choose another destination.")
				AdlibEnable("StatusDelay", 2500)
			Else
				HighlightGroup(100, 100)
				GUICtrlSetPos($arrow1, -300, -300)
				GUICtrlSetPos($arrow2, 317, 347)
				GUICtrlSetPos($arrow3, 322, 341)
				GUICtrlSetState($radio1, $GUI_DISABLE)
				GUICtrlSetState($radio2, $GUI_DISABLE)
				GUICtrlSetState($dest, $GUI_DISABLE)
				GUICtrlSetState($browse, $GUI_DISABLE)
				GUICtrlSetState($Start, $GUI_ENABLE)
				GUICtrlCreateLabel("\", 355, 292, 49, 49, 0)
				GUICtrlSetFont(-1, 16, 5500)
				GUICtrlSetColor(-1, 0x00FF00)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlCreateLabel("/", 360, 273, 49, 49, 0)
				GUICtrlSetFont(-1, 34, 10)
				GUICtrlSetColor(-1, 0x00FF00)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			EndIf
		Case $msg = $Start
			GUICtrlSetPos($arrow2, -300, -300)
			GUICtrlSetPos($arrow3, -300, -300)
			GUICtrlSetState($Start, $GUI_HIDE)
			GUICtrlSetState($Progress, $GUI_SHOW)
			GUICtrlSetData($Status, "Starting..")
	EndSelect
WEnd

Func HighlightGroup($ctrl, $ctrl2)
	GUICtrlSetState($check1, $GUI_DISABLE)
	GUICtrlSetState($check2, $GUI_DISABLE)
	GUICtrlSetState($check3, $GUI_DISABLE)
	GUICtrlSetBkColor($grp1, 0xECE9D8)
	GUICtrlSetBkColor($grp2, 0xECE9D8)
	GUICtrlSetBkColor($grp3, 0xECE9D8)
	GUICtrlSetBkColor($ctrl, 0xAAFFFF)
	GUICtrlSetState($ctrl2, $GUI_ENABLE)
EndFunc   ;==>HighlightGroup

Func StatusDelay()
	GUICtrlSetData($Status, "")
	AdlibDisable()
EndFunc   ;==>StatusDelay

Func Go()
	GUICtrlSetState($Start, $GUI_HIDE)
	GUICtrlSetState($Progress, $GUI_SHOW)
	If FileExists(@ScriptDir & "\iCopy.log.txt") Then FileDelete(@ScriptDir & "\iCopy.log.txt")
	If GUICtrlRead($radio2) = $GUI_CHECKED Then
		GUICtrlSetData($Status, "Creating iTunes Object..")
		$oiTunes = ObjCreate("iTunes.Application")
		If Not IsObj($oiTunes) Then
			MsgBox(0, "", "ERROR: Could not create iTunes object." & @CRLF & @CRLF & "Explanation:" & @CRLF & "iTunes, or some of it's components, are not installed on your computer." & @CRLF & "Now Exiting..")
			Exit
		EndIf
	EndIf
	If GUICtrlRead($_mp3) = $GUI_CHECKED Then FindAndCopy("mp3", IsObj($oiTunes))
	If GUICtrlRead($_wav) = $GUI_CHECKED Then FindAndCopy("wav", IsObj($oiTunes))
	If GUICtrlRead($_wma) = $GUI_CHECKED Then FindAndCopy("wma", IsObj($oiTunes))
	If GUICtrlRead($_m4a) = $GUI_CHECKED Then FindAndCopy("m4a", IsObj($oiTunes))
	If GUICtrlRead($_m4p) = $GUI_CHECKED Then FindAndCopy("m4p", IsObj($oiTunes))
	If GUICtrlRead($_aiff) = $GUI_CHECKED Then FindAndCopy("aiff", IsObj($oiTunes))
	If GUICtrlRead($_other) = $GUI_CHECKED Then
		$split = StringSplit(StringStripWS(GUICtrlRead($_otherinput), 8), ",", 1)
		For $i = 1 To UBound($split) - 1
			FindAndCopy($split[$i], IsObj($oiTunes))
		Next
	EndIf
	$oiTunes = 0
	GUICtrlSetData($Status, "Complete.")
	GUICtrlSetData($Progress, 100)
EndFunc   ;==>Go

Func Pause()
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
		If MsgBox(4, "Abort?", "Are you sure you wish to abort the process?") = 6 Then Exit
	EndIf
	If _IsPressed("23", $dll) Then
		GUICtrlSetData($Status, "PAUSED: Press {END} to resume")
		MsgBox(0, "", "PAUSED")
		While 1
			$msg = GUIGetMsg()
			If $msg = $GUI_EVENT_CLOSE Then Exit
			If _IsPressed("23", $dll) Then ExitLoop
		WEnd
		GUICtrlSetData($Status, "")
		Sleep(500)
	EndIf
EndFunc   ;==>Pause

Func FindAndCopy($filetype, $mode)
	Local $handle, $count = 0
	Local $files, $name, $new1, $new2
	$handle = FileOpen(@ScriptDir & "\iCopy.log.txt", 9)
	FileWrite($handle, "." & StringUpper($filetype) & " TRANSFER" & @CRLF & "----------------------------------" & @CRLF)
	GUICtrlSetData($Progress, 0)
	GUICtrlSetData($Status, "Searching for ." & $filetype & " files..")
	$files = _FileSearch($iPodDrive & "\*." & $filetype, 1, 0)
	If $mode = 0 Then
		If StringRight(GUICtrlRead($dest), 1) = "\"  Then GUICtrlSetData($dest, StringTrimRight($dest, 1))
		$name = StringRight(GUICtrlRead($dest), StringLen(GUICtrlRead($dest)) - StringInStr(GUICtrlRead($dest), "\", 0, -1))
		For $i = 1 To $files[0]
			Pause()
			FileWrite($handle, $files[$i] & " -> " & GUICtrlRead($dest) & "\Transfer\" & @CRLF)
			GUICtrlSetData($Status, "Copying ." & StringUpper($filetype) & "s to " & $name & " .. " & $i & "/" & $files[0])
			GUICtrlSetData($Progress, Round(($i / $files[0]) * 100))
			$new1 = _GetExtProperty($files[$i], 16) ;artist
			$new2 = _GetExtProperty($files[$i], 10) ;song
			If $new1 = "" Then $new1 = "Unknown"
			If $new2 = "" Then $new2 = "Unknown"
			$count = 0
			Local $tmp = $new2
			While FileExists(GUICtrlRead($dest) & "\Transfer\" & $new1 & " - " & $new2 & "." & $filetype)
				$new2 = $tmp & $count
				$count += 1
			WEnd
			FileCopy($files[$i], GUICtrlRead($dest) & "\Transfer\" & $new1 & " - " & $new2 & "." & $filetype, 8)
		Next
	Else
		If StringRight(GUICtrlRead($dest), 1) = "\"  Then GUICtrlSetData($dest, StringTrimRight(GUICtrlRead($dest), 1))
		$name = StringRight(GUICtrlRead($dest), StringLen(GUICtrlRead($dest)) - StringInStr(GUICtrlRead($dest), "\", 0, -1))
		For $i = 1 To $files[0]
			Pause()
			Local $target = _FileFindSpecialFolder($MY_MUSIC) & "\iTunes\iTunes Music"
			If Not FileExists($target) Then $target = @ScriptDir & "\Transfer"
			FileWrite($handle, $files[$i] & " -> iTunes" & @CRLF)
			GUICtrlSetData($Status, "Copying ." & StringUpper($filetype) & "s to iTunes .. " & $i & "/" & $files[0])
			GUICtrlSetData($Progress, Round(($i / $files[0]) * 100))
			$count = 0
			$new2 = StringTrimRight($files[$i], StringLen($filetype) + 1)
			$new2 = StringRight($new2, StringLen($new2) - StringInStr($new2, "\", 0, -1))
			Local $tmp = $new2
			While FileExists($target & "\" & $new2 & "." & $filetype)
				$new2 = $tmp & $count
				$count += 1
			WEnd
			FileCopy($files[$i], $target & "\" & $new2 & "." & $filetype, 8)
			While Not FileExists($target & "\" & $new2 & "." & $filetype)
				Sleep(1)
			WEnd
			$oiTunes.LibraryPlaylist.AddFile($target & "\" & $new2 & "." & $filetype)
		Next
	EndIf
	FileWrite($handle, "----------------------------------")
	FileClose($handle)
	DllClose($dll)
	Return $files[0]
EndFunc   ;==>FindAndCopy

;FileSearch by Larry;
Func _FileSearch($szMask, $nOption, $num)
	$szRoot = "";;;;;;;;;;;;;;
	$hFile = 0
	$szBuffer = ""
	$szReturn = ""
	$szPathList = "*"
	Dim $aNULL[1]
	If Not StringInStr($szMask, "\") Then
		$szRoot = @ScriptDir & "\"
	Else
		While StringInStr($szMask, "\")
			$szRoot = $szRoot & StringLeft($szMask, StringInStr($szMask, "\"))
			$szMask = StringTrimLeft($szMask, StringInStr($szMask, "\"))
		WEnd
	EndIf
	If $nOption = 0 Then
		_FileSearchUtil($szRoot, $szMask, $szReturn)
	Else
		While 1
			Pause()
			$hFile = FileFindFirstFile($szRoot & "*.*")
			If $hFile >= 0 Then
				$szBuffer = FileFindNextFile($hFile)
				While Not @error
					If $szBuffer <> "."  And $szBuffer <> ".."  And _
							StringInStr(FileGetAttrib($szRoot & $szBuffer), "D") Then _
							$szPathList = $szPathList & $szRoot & $szBuffer & "*"
					$szBuffer = FileFindNextFile($hFile)
				WEnd
				FileClose($hFile)
			EndIf
			_FileSearchUtil($szRoot, $szMask, $szReturn)
			If $szPathList == "*"  Then ExitLoop
			$szPathList = StringTrimLeft($szPathList, 1)
			$szRoot = StringLeft($szPathList, StringInStr($szPathList, "*") - 1) & "\"
			$szPathList = StringTrimLeft($szPathList, StringInStr($szPathList, "*") - 1)
		WEnd
	EndIf
	If $szReturn = "" Then
		$aNULL[0] = 0
		Return $aNULL
	Else
		Return StringSplit(StringTrimRight($szReturn, 1), "*")
	EndIf
EndFunc   ;==>_FileSearch

;FileSearchUtility by Larry (for FileSearch);
Func _FileSearchUtil(ByRef $ROOT, ByRef $MASK, ByRef $RETURN)
	$hFile = FileFindFirstFile($ROOT & $MASK)
	If $hFile >= 0 Then
		$szBuffer = FileFindNextFile($hFile)
		While Not @error
			If $szBuffer <> "."  And $szBuffer <> ".."  Then _
					$RETURN = $RETURN & $ROOT & $szBuffer & "*"
			$szBuffer = FileFindNextFile($hFile)
		WEnd
		FileClose($hFile)
	EndIf
EndFunc   ;==>_FileSearchUtil

Func _GetIpods($listview)
	Local $checker = 0, $file, $line, $drivename, $drivenameType, $Serial, $DriveCap, $driveFree, $DriveGet
	$DriveGet = DriveGetDrive("REMOVABLE")
	If IsArray($DriveGet) Then
		For $i = 1 To $DriveGet[0]
			$checker = $checker + 1
			If FileExists($DriveGet[$i] & "\iPod_Control\Device\SysInfo") Then
				$file = FileOpen($DriveGet[$i] & "\iPod_Control\Device\SysInfo", 0)
				$line = FileReadLine($file, 2)
				$Serial = StringTrimLeft($line, 17)
			Else
				$Serial = "Unknown"
			EndIf
			$drivename = StringUpper(StringLeft($DriveGet[$i], 1)) & StringTrimLeft($DriveGet[$i], 1)
			$drivenameType = DriveGetLabel($DriveGet[$i])
			$DriveCap = Round(DriveSpaceTotal($DriveGet[$i]) / 1024, 2)
			$driveFree = Round(DriveSpaceFree($DriveGet[$i]) / 1024, 2)
			GUICtrlCreateListViewItem($drivename & "|" & $drivenameType & "|" & $Serial & "|" & $DriveCap & "GB|" & $driveFree & "  (" & Round($driveFree / $DriveCap * 100) & "%)", $listview)
		Next
	EndIf
	If $checker = 0 Then
		Return -1
	Else
		Return $checker
	EndIf
EndFunc   ;==>_GetIpods

Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$iExist = FileExists($sPath)
	If $iExist = 0 Then
		SetError(1)
		Return 0
	Else
		$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
		$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		$oShellApp = ObjCreate("shell.application")
		$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
		$oDir = $oShellApp.NameSpace($sDir)
		$oFile = $oDir.Parsename($sFile)
		If $iProp = -1 Then
			Local $aProperty[35]
			For $i = 0 To 34
				$aProperty[$i] = $oDir.GetDetailsOf($oFile, $i)
			Next
			Return $aProperty
		Else
			$sProperty = $oDir.GetDetailsOf($oFile, $iProp)
			If $sProperty = "" Then
				Return 0
			Else
				Return $sProperty
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty

Func _FileFindSpecialFolder($Folder, $ListToArray = 0, $Filter = 0)
	Local $oShell = ObjCreate("Shell.Application")
	$nPath = $oShell.NameSpace($Folder).Self.Path
	If StringLeft($nPath, 1) = ":"  Or StringLeft($nPath, 1) = ";"  Then
		SetError(2)
	Else
		SetError(1)
	EndIf
	If $nPath = "" Then $nPath = -1
	If $ListToArray = 0 Then Return $nPath
	$nNum = $oShell.NameSpace($Folder).Items.Count
	Local $List[$nNum], $a = 0
	For $i = 0 To $nNum - 1
		Select
			Case $Filter = 0
				$List[$i] = $oShell.NameSpace($Folder).Items.Item($i).Path
				$a += 1
			Case $Filter = 1
				If $oShell.NameSpace($Folder).Items.Item($i).IsFileSystem = True Then
					If Not $oShell.NameSpace($Folder).Items.Item($i).IsFolder = True Then
						$List[$a] = $oShell.NameSpace($Folder).Items.Item($i).Path
						$a += 1
					EndIf
				EndIf
			Case $Filter = 2
				If $oShell.NameSpace($Folder).Items.Item($i).IsFolder = True Then
					$List[$a] = $oShell.NameSpace($Folder).Items.Item($i).Path
					$a += 1
				EndIf
			Case $Filter = 3
				If $oShell.NameSpace($Folder).Items.Item($i).IsLink = True Then
					$List[$a] = $oShell.NameSpace($Folder).Items.Item($i).Path
					$a += 1
				EndIf
			Case $Filter = 4
				$b = $oShell.NameSpace($Folder).Items.Item($i).Path
				If StringLeft($b, 1) = ":"  Or StringLeft($b, 1) = ";"  Then
					$List[$a] = $oShell.NameSpace($Folder).Items.Item($i).Path
					$a += 1
				EndIf
		EndSelect
	Next
	If $a = 0 Then
		$List = -1
	Else
		ReDim $List[$a]
	EndIf
	Return $List
EndFunc   ;==>_FileFindSpecialFolder