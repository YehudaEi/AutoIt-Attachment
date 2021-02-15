#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Archive_Current_Folder.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <File.au3>
#Include <Date.au3>
#Include <Array.au3>
#include <Process.au3>
#Include <Excel.au3>


Opt("WinTitleMatchMode", 2)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase

$AppName = "Archive Current Folder"

Dim $lOrganizedFiles = 0
Dim $lCounter = 0

$lSourceFolder = @ScriptDir & "\"
$split = StringSplit($lSourceFolder,"\")
$lArchiveFolderName = $split[$split[0]-1] & "_Archive"

$lDestionation = $lSourceFolder & $lArchiveFolderName & "\" & @YEAR & "_" & @MON  & "\"
$lLogFile = $lSourceFolder & "Folder_Archive.xls"
$lFile = _GetDirectoryStructure($lSourceFolder, ".", ".", 1, True)

IF $lFile[0] = 0 Then Exit

$FirstTime = Not FileExists($lLogFile)

FileSetAttrib($lLogFile,"-R")

$FO = FileOpen($lLogFile,1)

IF $FirstTime Then
	FileWriteLine($FO,"Archived On" & @TAB & "File ID" & @TAB & "FileName" & @TAB & "Extention" & @TAB & "Date Created" & @TAB & "Date Modified" & @TAB & "Size" & @TAB & "Source File" &  @TAB & "Open File" &  @TAB & "In Folder")
EndIf

$count = 0
For $i = 1 To $lFile[0]

	Dim $lDrive, $lDir, $lFName, $lExt
	_PathSplit($lFile[$i], $lDrive, $lDir, $lFName, $lExt)

	IF NOT SkipFile($lFName, $lExt) AND StringInStr($lFile[$i],"\" & $lArchiveFolderName & "\") = 0 Then

		$lDestinationFile = StringReplace($lFile[$i],$lSourceFolder,$lDestionation)

		$lBlnContinue = True
		IF FileExists($lDestinationFile) Then
			$lTxtNewSize      = _GetExtProperty($lFile[$i],1)
			$lTxtOldSize      = _GetExtProperty($lDestinationFile,1)
			$lDatNewModified  = _GetExtProperty($lFile[$i],4)
			$lDatOldModified  = _GetExtProperty($lDestinationFile,4)

			$iMsgBoxAnswer = MsgBox(35,"Confirm File Replace","This folder already contains a file named '" & $lFName & $lExt & "'." & @CRLF & @CRLF & "Would you like to replace the existing file:" & @CRLF & $lTxtOldSize & @CRLF & "Modified: " & $lDatOldModified & @CRLF & @CRLF & "with this one?" & @CRLF & $lTxtNewSize & @CRLF & "Modified: " & $lDatNewModified & @CRLF)
			Switch $iMsgBoxAnswer
				Case 6 ;Yes
					$lBlnContinue = True
				Case 7 ;No
					$lBlnContinue = False
				Case 2 ;Cancel
					$lBlnContinue = False
					Exit
			EndSwitch
		EndIf

		IF $lBlnContinue Then
			FileMove($lFile[$i], $lDestinationFile, 9)

			$lTxtSize      = _GetExtProperty($lFile[$i],1)
			$lDatCreated   = _GetExtProperty($lFile[$i],3)
			$lDatModified  = _GetExtProperty($lFile[$i],4)
			$count += 1
			FileWriteLine($FO,_Now() & @TAB & $count & @TAB & $lFName & @TAB & $lExt & @TAB & $lDatCreated & @TAB & $lDatModified &  @TAB & $lTxtSize & @TAB & $lFile[$i] &  @TAB  & '=HYPERLINK("' & $lDestinationFile & '";"' & $lFName & $lExt & '")' & @TAB & "'" & @YEAR & "_" & @MON)
		EndIf
	EndIf

Next

FileClose($FO)

IF $FirstTime Then	FileSetAttrib($lLogFile,"+R")

IF MsgBox(262212,$AppName,"Archive process completed for folder " & $lSourceFolder & @CRLF & "- Items added: " & $count & @CRLF & @CRLF & "Do you want to view the log file?") = 6 Then
	_ExcelBookOpen($lLogFile)
EndIf


$lFolder = _GetDirectoryStructure($lSourceFolder, ".", ".", 2, True)
IF $lFolder[0] = 0 Then Exit
For $i = 1 To $lFolder[0]
	IF StringInStr($lFolder[$i],"\" & $lArchiveFolderName) = 0 Then
		DirRemove($lFolder[$i],1)
	EndIf
Next


Exit

Func SkipFile($iFName, $iExt)
	IF (@ScriptName = $iFName & $iExt) Then Return True
	IF ($lLogFile = $lSourceFolder & $iFName & $iExt) Then Return True
	Return False
EndFunc

#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.2.10.0
	Author: WeaponX
	Updated: 2/21/08
	Script Function: Recursive file search

	2/21/08 - Added pattern for folder matching, flag for return type
	1/24/08 - Recursion is now optional

	Parameters:

	RFSstartdir: Path to starting folder

	RFSFilepattern: RegEx pattern to match
	"\.(mp3)" - Find all mp3 files - case sensitive (by default)
	"(?i)\.(mp3)" - Find all mp3 files - case insensitive
	"(?-i)\.(mp3|txt)" - Find all mp3 and txt files - case sensitive

	RFSFolderpattern:
	"(Music|Movies)" - Only match folders named Music or Movies - case sensitive (by default)
	"(?i)(Music|Movies)" - Only match folders named Music or Movies - case insensitive
	"(?!(Music|Movies)\B)\b.+" - Match folders NOT named Music or Movies - case sensitive (by default)

	RFSFlag: Specifies what is returned in the array
	0 - Files and folders
	1 - Files only
	2 - Folders only

	RFSrecurse: TRUE = Recursive, FALSE = Non-recursive

	RFSdepth: Internal use only

#ce ----------------------------------------------------------------------------
Func _GetDirectoryStructure($RFSstartDir, $RFSFilepattern = ".", $RFSFolderpattern = ".", $RFSFlag = 0, $RFSrecurse = True, $RFSdepth = 0)
	If StringRight($RFSstartDir, 1) <> "\" Then $RFSstartDir &= "\"

	If $RFSdepth = 0 Then
		$RFSfilecount = DirGetSize($RFSstartDir, 1)
		Global $RFSarray[$RFSfilecount[1] + $RFSfilecount[2] + 1]
	EndIf
	$RFSsearch = FileFindFirstFile($RFSstartDir & "*.*")

	If @error Then Return

	While 1
		$RFSnext = FileFindNextFile($RFSsearch)

		If @error Then ExitLoop

		If StringInStr(FileGetAttrib($RFSstartDir & $RFSnext), "D") Then
			If $RFSrecurse And StringRegExp($RFSnext, $RFSFolderpattern, 0) Then
				_GetDirectoryStructure($RFSstartDir & $RFSnext, $RFSFilepattern, $RFSFolderpattern, $RFSFlag, $RFSrecurse, $RFSdepth + 1)
				If $RFSFlag <> 1 Then
					$RFSarray[$RFSarray[0] + 1] = $RFSstartDir & $RFSnext
					$RFSarray[0] += 1
				EndIf
			EndIf
		ElseIf StringRegExp($RFSnext, $RFSFilepattern, 0) And $RFSFlag <> 2 Then
			$RFSarray[$RFSarray[0] + 1] = $RFSstartDir & $RFSnext
			$RFSarray[0] += 1
		EndIf
	WEnd
	FileClose($RFSsearch)
	If $RFSdepth = 0 Then
		ReDim $RFSarray[$RFSarray[0] + 1]
		_ArraySort($RFSarray)
		Return $RFSarray
	EndIf
EndFunc   ;==>_GetDirectoryStructure

;===============================================================================
; Function Name:    GetExtProperty($sPath,$iProp)
; Description:      Returns an extended property of a given file.
; Parameter(s):     $sPath - The path to the file you are attempting to retrieve an extended property from.
;                   $iProp - The numerical value for the property you want returned. If $iProp is is set
;                             to -1 then all properties will be returned in a 1 dimensional array in their corresponding order.
;                           The properties are as follows:
;                           Name = 0
;                           Size = 1
;                           Type = 2
;                           DateModified = 3
;                           DateCreated = 4
;                           DateAccessed = 5
;                           Attributes = 6
;                           Status = 7
;                           Owner = 8
;                           Author = 9
;                           Title = 10
;                           Subject = 11
;                           Category = 12
;                           Pages = 13
;                           Comments = 14
;                           Copyright = 15
;                           Artist = 16
;                           AlbumTitle = 17
;                           Year = 18
;                           TrackNumber = 19
;                           Genre = 20
;                           Duration = 21
;                           BitRate = 22
;                           Protected = 23
;                           CameraModel = 24
;                           DatePictureTaken = 25
;                           Dimensions = 26
;                           Width = 27
;                           Height = 28
;                           Company = 30
;                           Description = 31
;                           FileVersion = 32
;                           ProductName = 33
;                           ProductVersion = 34
; Requirement(s):   File specified in $spath must exist.
; Return Value(s):  On Success - The extended file property, or if $iProp = -1 then an array with all properties
;                   On Failure - 0, @Error - 1 (If file does not exist)
; Author(s):        Simucal (Simucal@gmail.com)
; Note(s):
;
;===============================================================================
Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$iExist = FileExists($sPath)
	If $iExist = 0 Then
		SetError(1)
		Return 0
	Else
		If StringInStr($sPath, "\") <> 0 Then
			$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
			$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
		Else
			$sFile = $sPath
			$sDir = @ScriptDir
		EndIf
		$oShellApp = ObjCreate("shell.application")
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
