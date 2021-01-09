#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=backup.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; Hide the tray icon, makes the script more ubiquitous and set working directory
FileChangeDir(@ScriptDir)
Opt("TrayIconHide", 1)

; Include AutoIt Files needed for GUI, deleting old files, and file splitting
#include-once
#include <Date.au3>
#include <file.au3>
#include <GUIConstants.au3>
#include <Array.au3>

Global $sIniFile
Global $var
Global $version = "v0.3"
If $cmdline[0] > 0 Then $var = $cmdline[1]

; Switches. Thanks to PsaltyDS
Select
	Case $var = ''
		MsgBox(0, "Oops!", "BackUp! requires a switch to function. Available switches are: /create, /edit, /ini, and /run " & Chr(34) & "profilename.ini" & Chr(34) & ". View the readme for more information.")
		Exit
	Case $var = "/about"
		MsgBox(0, "BackUp!" & $version, "Written by Peter Berke in AutoIt. See Readme.txt for detailed information.")
		Exit
	Case $var = "/edit"
		Local $inierror = "An unexpected error occured. Please contact your administrator."
		Local $readini = FileOpenDialog("Please select the profile to edit", @ScriptDir, "Profiles (*.ini)", 3)
		If @error Then ;Cancel
			MsgBox(0, "Oops!", "No file was chosen. BackUp! will now exit.")
			Exit
		EndIf
		FileSetAttrib($readini, "-R")
		Local $readinidir = IniRead($readini, "Backup", "sourcedir", $inierror)
		Local $readininame = IniRead($readini, "Backup", "sourcename", $inierror)
		Local $readininum = IniRead($readini, "Backup", "maxcount", $inierror)
		Local $writeinichanged = FileOpenDialog("Please locate the file", $readinidir, "All files (*.*)", 3, $readininame)
		If @error Then ;Cancel
			MsgBox(0, "Oops!", "No file was chosen. BackUp! will now exit.")
			Exit
		EndIf
		Local $szDriveFileEdit, $szDirFileEdit, $szFNameFileEdit, $szExtFileEdit
		Local $fileinipathedit = _PathSplit($writeinichanged, $szDriveFileEdit, $szDirFileEdit, $szFNameFileEdit, $szExtFileEdit)
		Local $fileiniedit = $fileinipathedit[1] & $fileinipathedit[2]
		Local $newinipathedit = @ScriptDir & "\" & $fileinipathedit[3] & $fileinipathedit[4] & ".ini"
		Local $filefolderlenedit = StringLen($fileiniedit)
		Local $filefolderedit = StringLeft($fileiniedit, $filefolderlenedit - 1)
		Local $filefoldernameedit = $fileinipathedit[3] & $fileinipathedit[4]
		Call("InputGUI")
		IniWrite($newinipathedit, "Backup", "sourcedir", $filefolderedit)
		IniWrite($newinipathedit, "Backup", "sourcename", $filefoldernameedit)
		IniWrite($newinipathedit, "Backup", "maxcount", $sInput)
		FileDelete($readini)
		FileSetAttrib($newinipathedit, "+R")
		MsgBox(0, "Success", $fileinipathedit[3] & $fileinipathedit[4] & ".ini was successfully edited.")
		Exit
	Case $var = "/create"
		Local $readininum
		Local $sourceinifile = FileOpenDialog("Please select the file to be backed up", "C:\", "All files (*.*)", 3)
		If @error Then ;Cancel
			MsgBox(0, "Oops!", "No file was chosen. BackUp! will now exit.")
			Exit
		EndIf
		Call("InputGUI")
		; Code below will split the file selected above into the directory and the filename
		Local $szDriveFile, $szDirFile, $szFNameFile, $szExtFile
		Local $fileinipath = _PathSplit($sourceinifile, $szDriveFile, $szDirFile, $szFNameFile, $szExtFile)
		Local $fileini = $fileinipath[1] & $fileinipath[2]
		Local $filefolderlen = StringLen($fileini)
		Local $filefolder = StringLeft($fileini, $filefolderlen - 1)
		Local $filefoldername = $fileinipath[3] & $fileinipath[4]
		Local $newinipath = @ScriptDir & "\" & $fileinipath[3] & $fileinipath[4] & ".ini"
		; Pass the values from above into the INI
		IniWrite($newinipath, "Backup", "sourcedir", $filefolder)
		IniWrite($newinipath, "Backup", "sourcename", $filefoldername)
		IniWrite($newinipath, "Backup", "maxcount", $sInput)
		FileSetAttrib($newinipath, "+R")
		MsgBox(0, "Success", "This file can now be backed up by executing: backup.exe /run " & Chr(34) & $fileinipath[3] & $fileinipath[4] & ".ini" & Chr(34))
		Exit
	Case $var = "/ini"
		Local $IniRunIt = FileOpenDialog("Please select the profile to use", @ScriptDir, "INI files (*.ini)", 3)
		If @error Then ;Cancel
			MsgBox(0, "Oops!", "No file was chosen. BackUp! will now exit.")
			Exit
		EndIf
		Local $szDriveIniRunIt, $szDirIniRunIt, $szFNameIniRunIt, $szExtIniRunIt
		Local $IniRunItSplit = _PathSplit($IniRunIt, $szDriveIniRunIt, $szDirIniRunIt, $szFNameIniRunIt, $szExtIniRunIt)
		Local $IniToRun = $IniRunItSplit[3] & $IniRunItSplit[4]
		$sIniFile = $IniToRun
	Case $var = "/run"
		For $n = 1 To $cmdline[0] - 1
			If $cmdline[$n] = "/run" Then
				$sIniFile = $cmdline[$n + 1]
				ExitLoop
			EndIf
		Next
	Case Else
		MsgBox(0, "Oops!", "You have not entered a valid switch. BackUp! will now exit.")
		Exit
EndSelect

; Declaring variables
Global $sourcedir = IniRead(@ScriptDir & "\" & $sIniFile, "Backup", "sourcedir", "An unexpected error occured. Please contact your administrator.") ; Path to the folder where the original file resides
Global $sourcename = IniRead(@ScriptDir & "\" & $sIniFile, "Backup", "sourcename", "An unexpected error occured. Please contact your administrator.") ; Filename of the original file
Global $sourcefile = $sourcedir & "\" & $sourcename ; Path to the file that needs to be backed up
Global $targetdir = $sourcedir & "\FileBackups\" & $sourcename ; Path of the folder where the backup will reside
Global $targetname = @MON & "-" & @MDAY & "-" & @YEAR & "-" & @HOUR & "-" & @MIN & "-" & @SEC & "." & $sourcename ; Filename of the backup.
Global $targetfile = $targetdir & "\" & $targetname ; Concatenate the two above. They are separated to allow users the option of creating a backup directory if it doesn't exist.
Global $error = "Backup Error" ; Error title
Global $success = $sourcename & " backup was successful." ; Success message in creating a new backup when there's no original
Global $direrror = "The backup folder could not be created. Please contact your administrator" ; Error message if targetdir can't be created
Global $dirsuccess = "The backup folder was created. Let's backup " & $sourcename ; Success message if targetdir was created
Global $nodir = $sourcename & " was not backed up. Please contact your administrator" ; Success message for backup following auto-creation of targetdir

; Check if backup directory exists. If it doesn't, give user option to create it.
If Not FileExists($targetdir) Then
	GUICreate($error, 217, 75, -1, -1, $WS_CAPTION)

	Opt("GUICoordMode", 2)

	GUICtrlCreateLabel("The backup folder for " & $sourcename & " doesn't exist. Would you like to create it?", 10, 10, 200, 25)

	Local $Button_1 = GUICtrlCreateButton("Yes", -1, 10, 100, 25)
	Local $Button_2 = GUICtrlCreateButton("No", 0, -1)

	GUISetState() ; Create the GUI dialog box

	; Run the GUI until the dialog is closed
	While 1
		Local $msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $Button_1
				GUISetState(@SW_HIDE)
				Local $createdircheck = DirCreate($targetdir)
				If $createdircheck = 1 Then ; Making sure the directory can be created
					DirCreate($targetdir)
				Else
					MsgBox(0, $sourcename, $direrror)
				EndIf
				MsgBox(0, $sourcename, $dirsuccess)
				If FileExists($sourcefile) Then
					FileCopy($sourcefile, $targetfile, 1) ; Creating backup
				Else
					MsgBox(0, $error, "The original " & $sourcename & " file was not found. No backup can be created.") ; If it doesn't, let the user know and exit script
					Exit
				EndIf
				MsgBox(0, $sourcename, $success)
				ExitLoop
			Case $msg = $Button_2
				GUISetState(@SW_HIDE)
				MsgBox(0, $sourcename, $nodir)
				Exit
		EndSelect
	WEnd
EndIf

; Check to see if targetdir is empty. If it is, prompt user to create first backup
Dim $targetdirsize = DirGetSize($targetdir, 1)
Dim $targetdircount = $targetdirsize[1]
If $targetdircount = 0 Then
	GUICreate($error, 217, 93, -1, -1, $WS_CAPTION)

	Opt("GUICoordMode", 2)

	GUICtrlCreateLabel("No " & $sourcename & " backup was found. Click OK to create a new backup, or click Cancel to end the backup process.", 10, 10, 200, 40)

	Local $Button_1 = GUICtrlCreateButton("OK", -1, 10, 100, 25)
	Local $Button_2 = GUICtrlCreateButton("Cancel", 0, -1)

	GUISetState() ; Create the GUI dialog box

	; Run the GUI until the dialog is closed
	While 1
		Local $msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $Button_1
				GUISetState(@SW_HIDE)
				FileCopy($sourcefile, $targetfile)
				MsgBox(0, $sourcename, $success)
				Exit
			Case $msg = $Button_2
				Exit
		EndSelect
	WEnd
EndIf

; Declaring variables needed for date functions to work
Global Const $maxcount = IniRead(@ScriptDir & "\" & $sIniFile, "Backup", "maxcount", "An unexpected error occured. Please contact your administrator.")
Global $sFilter = "*.*"
Global $sWorkFolder = $targetdir & "\"
Global $FileList = _FileDelOldHistory($sWorkFolder, $maxcount, $sFilter, False)

; Delete oldest files bassed on parameter. Thanks to RAMzor
Func _FileDelOldHistory($sPath, $iHistoryOfFiles = 2, $sFilter = "*", $bDelReadonly = True)

	Local $hSearch, $sFile, $sOldestFilePath, $Count = 0, $iMaxIndex, $sCurntFile
	Local $asFileList[1], $iFileAgeList[1], $asFileError[1]
	If Not FileExists($sPath) Then Return SetError(1, 1, "")
	If (StringInStr($sFilter, "\")) Or (StringInStr($sFilter, "/")) Or (StringInStr($sFilter, ":")) Or (StringInStr($sFilter, ">")) Or (StringInStr($sFilter, "<")) Or (StringInStr($sFilter, "|")) Or (StringStripWS($sFilter, 8) = "") Then Return SetError(2, 2, "")
	If StringRight($sWorkFolder, 1) <> "\" Then $sWorkFolder = $sWorkFolder & "\"

	ReDim $asFileList[1]
	ReDim $iFileAgeList[1]
	$asFileList[0] = 0
	$iFileAgeList[0] = 0

	$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			SetError(0)
			ExitLoop
		EndIf
		If StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> 0 Then ContinueLoop

		ReDim $asFileList[UBound($asFileList) + 1]
		$asFileList[0] = $asFileList[0] + 1 ; Write Nunber of elements
		$asFileList[UBound($asFileList) - 1] = $sFile

		ReDim $iFileAgeList[$asFileList[0] + 1]
		$iFileAgeList[0] = $asFileList[0] ; Write Nunber of elements
		$iFileAgeList[$asFileList[0]] = _FileAge("s", $sPath & $sFile)
	WEnd
	FileClose($hSearch)

	While $iFileAgeList[0] > $iHistoryOfFiles ;+ 1

		$iMaxIndex = _ArrayMaxIndex($iFileAgeList, 1, 1)
		$iFileAgeList[$iMaxIndex] = -1 ; Reset age ( age < 0 )
		$iFileAgeList[0] -= 1 ; Write valid nunber of elements ( age >= 0 )
		$sOldestFilePath = $sPath & $asFileList[$iMaxIndex]
		ConsoleWrite("Delete " & $asFileList[$iMaxIndex] & @LF)
		If $bDelReadonly Then
			; Set file attributes ( Remove READONLY, Set ARCHIVE )
			If Not FileSetAttrib($sOldestFilePath, "-R+A") Then
				MsgBox(4096, "Robot Error", "Problem setting attributes to " & @LF & $sOldestFilePath, 2)
			EndIf
		EndIf
		; Delete File
		If Not FileDelete($sOldestFilePath) Then
;~     MsgBox(16, "Robot", "Can't Delete " & $sOldestFilePath )
			$Count += 1
			ReDim $asFileError[$Count + 1]
			$asFileError[$Count] = $sOldestFilePath
		EndIf
	WEnd
	$asFileError[0] = $Count
	Return $asFileError
EndFunc   ;==>_FileDelOldHistory

; Get age of files in targetdir
Func _FileAge($sType, $sFileName, $Flag = 0)

	Local $fTimeArray[6]
	Local $fYear, $fMonth, $fDay, $fHour, $fMin, $fSec
	Local $iYearDiff, $iMonthDiff, $iTimeDiff
	Local $iFileTimeInSecs, $iNowTimeInSecs
	Local $aDaysDiff

	$fTimeArray = FileGetTime($sFileName)
	If @error Then
		SetError(1)
		Return ""
	EndIf
	$fYear = $fTimeArray[0] ; year (four digits)
	$fMonth = $fTimeArray[1]; month (range 01 - 12)
	$fDay = $fTimeArray[2] ; day (range 01 - 31)
	$fHour = $fTimeArray[3] ; hour (range 00 - 23)
	$fMin = $fTimeArray[4] ; min (range 00 - 59)
	$fSec = $fTimeArray[5] ; sec (range 00 - 59)

	; Get the differens in days between the 2 dates
	$aDaysDiff = _DateToDayValue(@YEAR, @MON, @MDAY) - _DateToDayValue($fYear, $fMonth, $fDay)

	; Get the differens in Seconds between the 2 times
	$iFileTimeInSecs = $fHour * 3600 + $fMin * 60 + $fSec
	$iNowTimeInSecs = @HOUR * 3600 + @MIN * 60 + @SEC
	$iTimeDiff = $iNowTimeInSecs - $iFileTimeInSecs
	If $iTimeDiff < 0 Then
		$aDaysDiff = $aDaysDiff - 1
		$iTimeDiff = $iTimeDiff + 24 * 60 * 60
	EndIf

	Select
		Case $sType = "d"
			Return ($aDaysDiff)
		Case $sType = "m"
			$iYearDiff = @YEAR - $fYear
			$iMonthDiff = @MON - $fMonth + $iYearDiff * 12
			If @MDAY < $fDay Then $iMonthDiff = $iMonthDiff - 1
			$iFileTimeInSecs = $fHour * 3600 + $fMin * 60 + $fSec
			$iNowTimeInSecs = @HOUR * 3600 + @MIN * 60 + @SEC
			$iTimeDiff = $iNowTimeInSecs - $iFileTimeInSecs
			If @MDAY = $fDay And $iTimeDiff < 0 Then $iMonthDiff = $iMonthDiff - 1
			Return ($iMonthDiff)
		Case $sType = "y"
			$iYearDiff = @YEAR - $fYear
			If @MON < $fMonth Then $iYearDiff = $iYearDiff - 1
			If @MON = $fMonth And @MDAY < $fDay Then $iYearDiff = $iYearDiff - 1
			$iFileTimeInSecs = $fHour * 3600 + $fMin * 60 + $fSec
			$iNowTimeInSecs = @HOUR * 3600 + @MIN * 60 + @SEC
			$iTimeDiff = $iNowTimeInSecs - $iFileTimeInSecs
			If @MON = $fMonth And @MDAY = $fDay And $iTimeDiff < 0 Then $iYearDiff = $iYearDiff - 1
			Return ($iYearDiff)
		Case $sType = "w"
			Return (Int($aDaysDiff / 7))
		Case $sType = "h"
			Return ($aDaysDiff * 24 + Int($iTimeDiff / 3600))
		Case $sType = "n"
			Return ($aDaysDiff * 24 * 60 + Int($iTimeDiff / 60))
		Case $sType = "s"
			Return ($aDaysDiff * 24 * 60 * 60 + $iTimeDiff)
		Case Else ; invalid parameter $sType
			SetError(2)
			Return ""
	EndSelect
EndFunc   ;==>_FileAge

; Input Box with validation. Thanks to zorphnog.
Func InputGUI()
	$myGUI = GUICreate("How many backups?", 180, 100, -1, -1, BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU))
	GUICtrlCreateLabel("Enter a number from 1 to 99", 10, 10)
	$inInputBox = GUICtrlCreateInput("", 10, 30, 160, Default, $ES_NUMBER)
	GUICtrlSetData($inInputBox, $readininum)
	$btOk = GUICtrlCreateButton("Ok", 10, 65, 75)
	GUICtrlSetState($btOk, $GUI_DISABLE)
	$bOkEnabled = False
	$btCancel = GUICtrlCreateButton("Cancel", 95, 65, 75)
	GUISetState()

	While 1
		$nMsg = GUIGetMsg()
		Global $sInput = GUICtrlRead($inInputBox)
		Select
			Case $nMsg = $GUI_EVENT_CLOSE Or $nMsg = $btCancel
				Exit
			Case $nMsg = $btOk
				GUISetState(@SW_HIDE)
				ExitLoop
			Case StringLen($sInput) > 2
				GUICtrlSetData($inInputBox, StringLeft($sInput, 2))
			Case StringLen($sInput) = 2 And Not $bOkEnabled
				GUICtrlSetState($btOk, $GUI_ENABLE)
				$bOkEnabled = True
			Case StringLen($sInput) = 1 And Not $bOkEnabled
				GUICtrlSetState($btOk, $GUI_ENABLE)
				$bOkEnabled = True
			Case StringLen($sInput) = 0 And $bOkEnabled
				GUICtrlSetState($btOk, $GUI_DISABLE)
				$bOkEnabled = False
		EndSelect
	WEnd
EndFunc   ;==>InputGUI

; Display errors from date functions, if any
If @error Then
	MsgBox(0, "Error", "Error " & @error)
	Exit
EndIf

If $FileList[0] > 0 Then
	_ArrayDisplay($FileList, "Can't delete " & $FileList[0] & " file(s)")
EndIf

; Make sure the file that needs to be backed up exists
If FileExists($sourcefile) Then
	FileCopy($sourcefile, $targetfile, 1) ; Creating backup
Else
	MsgBox(0, $error, "The original " & $sourcename & " file was not found. No backup can be created.") ; If it doesn't, let the user know and exit script
	Exit
EndIf

