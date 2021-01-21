; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.102 BETA
; Author:         Bill Suthers
; Script Function:Basic Address Database
;
; ----------------------------------------------------------------------------

; include files
#include <GUIConstants.au3>
; #include <Array.au3> (decided to include just the procedures used explicitly at the end of my own functions section

AutoItSetOption("GUICloseOnESC", 0)
AutoItSetOption("RunErrorsFatal", 0)

If $Cmdline[0] = 1 Then ; set whether to display detailed info messages was requested on the command line
	$VerboseMode = "on" ; note that it doesn't requires any particular switch.  ANYTHING passd on the command line will cause verbose mode to activate
Else
	$VerboseMode = "off"
EndIf

$LoadAnotherDataFile = "yes"

;main Script
While $LoadAnotherDataFile = "yes" ; the whole script operates within this loop, which re-starts from scratch if the user chooses to load another Data file
	
	$LoadAnotherDataFile = "no"
	
	;Set Variables
	$ScriptVersionNumber = "1.4.3"
	$ProgramFilePath = @ScriptDir & "\"
	$DataFileSubDIR = "data\"
	$DataFilePath = $ProgramFilePath & $DataFileSubDIR
	$RuntimeBackupFileSubDIR = "Runtime Backups\"
	$RuntimeBackupDataFilePath = $ProgramFilePath & $RuntimeBackupFileSubDIR
	$UserBackupFileSubDIR = "Internal Backups\"
	$UserBackupDataFilePath = $ProgramFilePath & $UserBackupFileSubDIR
	$PrintFileSubDIR = "Printfile\"
	$PrintFilePath = $ProgramFilePath & $PrintFileSubDIR
	$PrintFileEXE = "PrFile32.exe"
	$PrintFileEXEAndPath = $PrintFilePath & $PrintFileEXE
	$PrintFileINI = "prfile.ini"
	$PrintFileINIAndPath = $PrintFilePath & $PrintFileINI
	$PrintFileListFile = "listing of all files.prt"
	$PrintFileListFileAndPath = $PrintFilePath & $PrintFileListFile
	$BlankTemplateFile = "Templete File.dat"
	$BlankTemplateFileAndPath = $ProgramFilePath & $BlankTemplateFile
	$NumberedFileName = "Numbered File.txt"
	$NumberedFileNameAndPath = $ProgramFilePath & $NumberedFileName
	$OutputFileBaseName = "Page"
	$ExportFilesSubDIR = "Export Files\"
	$ExportFilesPath = $ProgramFilePath & $ExportFilesSubDIR
	$TruncationReportFileName = "Truncation Report.txt"
	$TruncationReportFileNameandPath = $ProgramFilePath & $TruncationReportFileName
	$HelpFileName = "ard.hlp"
	$HelpFileNameandPath = $ProgramFilePath & $HelpFileName
	Global $AdvancedFeaturesGUIHandle ; declaration for use in multiple functions later
	Global $OldDataArrayHeight ; declaration for use in multiple functions later
	Global $NumberOfRecordsinSubsequentFile
	$SaveNeeded = "no" ; when an operation that needs a save performed is done, this is set to 'yes'.  Saving reverts it to 'no'
	$TruncationWarning = "on" ; after recieving 5 truncation warnings the user can switch this off.
	$LableTestingDataFileName = "zz Lable Layout Testing.csv" ; if this file is loaded, all truncation warnings are disabled
	$TruncationCount = 0
	$TextTooLong = ""
	$LableFormatForTruncationCheck = ""
	$TruncationTrackerString = "" ; this is used to keep a list of records that suffered truncation
	$AutoUpdateMemberList = "on" ; the user is prompted if they wish to turn this off if the number of records in the file is greater than 200
	$AutoUpdateQuestionAsked = "no" ; this is used to aviod repeating the same question to the user
	$DescriptorLineNumber = 7 ; this is the line number of the data files that contains the file descriptor string
	$PromptToAutoSortNumber = 200 ; if the number of records in the database exceeds this, the user will be prompted to switch off automatic refreshing of the member list window
	$SkipRowsOnFirstPage = 0 ; sets skipping of rows in printout if using up a partly filled sheet
	
	;display splash screen
	SplashImageOn("", "splash image 560x150.jpg", 560, 150, -1, -1, 3)
	
	;choose Data file to open
	;Create list of Data files for the combo box
	$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.csv")
	
	; Warn if no Data files exist
	If $FileSearchHandle = -1 Then
		SplashOff()
		MsgBox(0, "Warning", "No Data Files Currently Exist.")
		$FileList = "No Data Files Exist - Please Create One!"
		$FileListFirst = "No Data Files Exist - Please Create One!"
	Else ; form list of available Data files
		;retrieve 1st file in file list
		$FileSearchName = FileFindNextFile($FileSearchHandle)
		;get file size (used to count records later)
		$SearchFileSize = FileGetSize($DataFilePath & $FileSearchName)
		;open data file
		$FileSearchNameHandle = FileOpen($DataFilePath & $FileSearchName, 0)
		;count lines in file
		$NumberOfSearchFileLines = CountDataFileLines($FileSearchNameHandle, $SearchFileSize)
		;close file
		FileClose($FileSearchNameHandle)
		;convert to number of records (ie subtract the header lines) & ad to descriptor
		$FileList = StringTrimRight($FileSearchName, 4) & "   (" & $NumberOfSearchFileLines - 12 & " members)"
		$FileListFirst = $FileList
		;continue to populate list
		While 1
			$NextFile = FileFindNextFile($FileSearchHandle)
			If @error Then
				ExitLoop
			EndIf
			$FileSearchName = $NextFile
			;get file size (used to count records later)
			$SearchFileSize = FileGetSize($DataFilePath & $FileSearchName)
			;open data file
			$FileSearchNameHandle = FileOpen($DataFilePath & $FileSearchName, 0)
			;count lines in file
			$NumberOfSearchFileLines = CountDataFileLines($FileSearchNameHandle, $SearchFileSize)
			;close file
			FileClose($FileSearchNameHandle)
			;convert to number of records (ie subtract the header lines) & ad to descriptor
			$NextFile = StringTrimRight($FileSearchName, 4) & "   (" & $NumberOfSearchFileLines - 12 & " members)"
			$FileList = $FileList & "|" & $NextFile
		WEnd
	EndIf
	
	; Close the search handle
	FileClose($FileSearchHandle)
	
	SplashOff()
	
	; create the File Selection GUI
	$CurrentGUITitle = "Address Database"
	GUICreate($CurrentGUITitle, 300, 250, (@DesktopWidth - 300) / 2, (@DesktopHeight - 250) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$GUIImageID = GUICtrlCreatePic("GUI image 300x80.jpg", 0, 0, 300, 80)
	$SelectDataFileComboID = GUICtrlCreateCombo("", 5, 120, 290, 250)
	$SelectDataFileLabelID = GUICtrlCreateLabel("Please Select Data File To Open", 30, 95, 310, 20)
	$OpenDataFileButtonID = GUICtrlCreateButton("Open File", 30, 170, 100, 30)
	$CreateNewDataFileButtonID = GUICtrlCreateButton("New Data File", 160, 170, 100, 30)
	GUICtrlSetState($OpenDataFileButtonID, $GUI_DEFBUTTON)
	
	;load data into file list window
	GUICtrlSetData($SelectDataFileComboID, $FileList, $FileListFirst)
	
	GUISetState()
	While 1 ; process GUI events for Data file selection
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Exit
			Case $GUImsg = $OpenDataFileButtonID
				$ComboData = GUICtrlRead($SelectDataFileComboID)
				If $ComboData <> "No Data Files Exist - Please Create One!" Then
					ExitLoop
				Else
					MsgBox(0, "No Data Files", "Cannot Continue.  No Data files Exist. Please Click 'OK', then click on the Button 'Create a new File'")
				EndIf
			Case $GUImsg = $CreateNewDataFileButtonID
				CreatNewDataFile()
				GUIDelete()
				MsgBox(0, "Database Restarting", "New Data File Created!  The database will now close and reopen.  Your new Data file will then be available to select.")
				$LoadAnotherDataFile = "yes"
				ContinueLoop 2
		EndSelect
	WEnd
	
	If $VerboseMode = "on" Then
		MsgBox(0, "File Selection", "Combo Box Returned '" & $ComboData & "'")
	EndIf
	
	GUIDelete()
	
	;extract filename from value returned from combo box
	$ComboElements = StringSplit($ComboData, "(")
	$ComboData = StringTrimRight($ComboElements[1], 3)
	
	;set data file name and path
	$DataFileName = $ComboData & ".csv"
	$DataFileNameAndPath = $DataFilePath & $DataFileName
	$RuntimeBackupDataFileName = $ComboData & ".bak"
	$RuntimeBackupDataFileNameAndPath = $RuntimeBackupDataFilePath & $RuntimeBackupDataFileName
	
	;back up data file
	$BackupSuccess = FileCopy($DataFileNameAndPath, $RuntimeBackupDataFileNameAndPath, 9)
	
	;allow user to quit if backup unsuccessful
	If $BackupSuccess <> 1 Then
		SplashOff()
		$Proceed = MsgBox(20, "Unable to Back Up", "WARNING!  Unable to create database backup file '" & $RuntimeBackupDataFileNameAndPath & "'. If you proceed, your data may be at risk.  Do you wish to proceed?")
		If $Proceed <> 6 Then; user did not say yes
			Exit
		EndIf
	EndIf
	
	;get file size (used to read file)
	$DataFileSize = FileGetSize($DataFileNameAndPath)
	;open data file
	$DataFileHandle = FileOpen($DataFileNameAndPath, 0)
	;read in data file
	$EntireDataFileasOneString = FileRead($DataFileHandle, $DataFileSize)
	;split datafile into temp array of lines
	$DataFileLineArraytemp = StringSplit($EntireDataFileasOneString, @CRLF, 1)
	
	;test if a final CRLF was present in the data file.  If so, a 'blank' last string is returned into the array which must be ignored.  (A final CRLF is 'normal' for files saved by 'filewriteline')
	$LinesinTempArray = $DataFileLineArraytemp[0]
	If StringLen($DataFileLineArraytemp[$LinesinTempArray]) < 10 Then
		$NumberOfDataFileLines = $LinesinTempArray - 1
	Else
		$NumberOfDataFileLines = $LinesinTempArray
	EndIf
	
	;extract descriptors of data file
	$DescriptorRawString = $DataFileLineArraytemp[$DescriptorLineNumber] ; read the descriptor line
	$FileDescriptors = StringSplit($DescriptorRawString, ",") ; split descriptors up into $FileDescriptors array
	$DataFileLineNumberOfFirstRecord = $FileDescriptors[1] ; all lines preceeding this are taken as comment lines, and are read into the comment array
	$DataFileLineNumberOfDisplayableFileComment = $FileDescriptors[2]
	$NumberOfFields = $FileDescriptors[3]
	$SortField = $FileDescriptors[4]
	$NumberOfRecords = $NumberOfDataFileLines - ($DataFileLineNumberOfFirstRecord - 1)
	
	;display data file stats
	If $VerboseMode = "on" Then
		MsgBox(0, $DataFileNameAndPath, "Above Data File Found. " & $NumberOfDataFileLines & " total lines in file, " & $DataFileLineNumberOfFirstRecord - 1 & " comment lines, " & $NumberOfRecords & " record lines")
	EndIf
	
	;dim data arrays
	$DataArrayHeight = $NumberOfRecords + 1
	$DataArrayWidth = $NumberOfFields + 1
	Dim $DataArray [$DataArrayHeight][$DataArrayWidth] ; used to store the data.  the "+ 1" is used so array element [0] does not have to be used and the array numbers will match the field numbers and record numbers width[0] is used to store the Data filename of the record.  This is mainly used when producing a multi-Data truncation report
	Dim $HeaderArray [$DataFileLineNumberOfFirstRecord]; used to store the file header information. element [0] is not used
	
	;read header information into header array
	$LinesRead = ReadHeaderIntoArray()
	
	;display successful read
	If $VerboseMode = "on" Then
		MsgBox(0, "Header Data Read Done", $LinesRead & " Lines successfully read into the Header Array.  File Comment is '" & $HeaderArray[$DataFileLineNumberOfDisplayableFileComment] & "'.")
	EndIf
	
	;read data into data array
	$RecordsRead = ReadDataIntoArray()
	
	;close data file
	FileClose($DataFileHandle)
	
	;display successful read
	If $VerboseMode = "on" Then
		MsgBox(0, "Record Data Read Done", $RecordsRead & " Records successfully read into the Data Array")
	EndIf
	
	; display main GUI
	$MainGUITitle = "Address Database, Version " & $ScriptVersionNumber & " : " & $DataFileName
	$CurrentGUITitle = $MainGUITitle
	$MainGUIHandle = GUICreate($MainGUITitle, 700, 550, (@DesktopWidth - 700) / 2, 0, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	;controls
	$FileCommentLableID = GUICtrlCreateLabel("File Comment", 10, 14, 70, 15, $SS_right)
	$FileCommentInputID = GUICtrlCreateInput("Comment Input Field", 85, 10, 375, 20, $SS_center)
	$SearchButtonID = GUICtrlCreateButton("Search for Surname", 50, 38, 190, 25)
	GUICtrlSetState($SearchButtonID, $GUI_DEFBUTTON)
	$SearchInputID = GUICtrlCreateInput("Enter Start of Surname...", 245, 40, 215, 20)
	GUICtrlSetTip($SearchInputID, "To display all members, enter nothing")
	GUICtrlSetState($SearchInputID, $GUI_FOCUS)
	$ListofMembersListID = GUICtrlCreateList("Clickable List", 20, 70, 440, 450)
	$SortButtonID = GUICtrlCreateButton("Sort Member List", 50, 512, 150, 30)
	$MemberNumberRadioID = GUICtrlCreateRadio("By Member Number", 225, 515, 110, 25)
	$SurnameRadioID = GUICtrlCreateRadio("By Surname", 355, 515, 80, 25)
	$RadioGroup = GUICtrlCreateGroup("", 215, 505, 235, 40)
	GUICtrlSetTip($SurnameRadioID, "The option selected activates only after 'Sort Member List' is clicked")
	GUICtrlSetTip($MemberNumberRadioID, "The option selected activates only after 'Sort Member List' is clicked")
	
	;Button List at right
	$GUIImageID = GUICtrlCreatePic("GUI image 150x77.jpg", 520, 10, 150, 77)
	$MainGUIHelpButtonID = GUICtrlCreateButton("Help", 550, 100, 90, 30)
	$AddNewMemberButtonID = GUICtrlCreateButton("Add New Member", 520, 140, 150, 30)
	$EditSelectedMemberButtonID = GUICtrlCreateButton("Edit Member", 520, 180, 150, 30)
	$DeleteSelectedMemberButtonID = GUICtrlCreateButton("Delete Member", 520, 220, 150, 30)
	$SaveButtonID = GUICtrlCreateButton("Save", 520, 275, 150, 30)
	$PrintThisDataButtonID = GUICtrlCreateButton("Print This Data File", 520, 325, 150, 30)
	$PrintMultipleDataFilesButtonID = GUICtrlCreateButton("Print Multiple Data Files", 520, 365, 150, 30)
	$AdvancedFeaturesButtonID = GUICtrlCreateButton("Advanced Features", 520, 420, 150, 30)
	$ChangeDataButtonID = GUICtrlCreateButton("Change Data File", 520, 475, 150, 30)
	$QuitButtonID = GUICtrlCreateButton("Quit", 520, 515, 150, 30)
	GUICtrlSetFont($SaveButtonID, 9, 600)
	GUICtrlSetFont($AdvancedFeaturesButtonID, 9, 400, 2)
	
	; set control contents
	If $SortField = 4 Then ; set sort radio from file setting
		GUICtrlSetState($SurnameRadioID, $GUI_CHECKED)
	Else
		GUICtrlSetState($MemberNumberRadioID, $GUI_CHECKED)
	EndIf
	GUICtrlSetData($FileCommentInputID, $HeaderArray[$DataFileLineNumberOfDisplayableFileComment])
	GUICtrlSetData($ListofMembersListID, GenerateMembersList())
	GUIDelete() ; kill member list progress bar GUI
	GUISwitch($MainGUIHandle)
	
	
	GUISetState()
	While 1 ; process Main GUI events
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE ; user closed the window
				Exit
				
			Case $GUImsg = $MainGUIHelpButtonID ; help
				Run("winhlp32.exe" & ' "' & $HelpFileNameandPath & '"', $ProgramFilePath)
				$HelpLaunchFailure = WinWait("Windows Help", "Cannot", 5) ; check if opening fails (only observed under Win9x)
				If $HelpLaunchFailure = 1 Then
					Send("{Tab}")
					Send("{Enter}")
					MsgBox(0, "Help Launch Failure", "Help cannot be started automatically.  Please start it manually using the icon normally installed at Start -> Programs -> Address Database -> Help")
				EndIf
				
			Case $GUImsg = $SearchButtonID
				SearchForSurname(GUICtrlRead($SearchInputID))
				
			Case $GUImsg = $AddNewMemberButtonID ; Add New
				GUISetState(@SW_HIDE, $MainGUIHandle)
				AddNewMember()
				GUISetState(@SW_SHOW, $MainGUIHandle)
				UpdateMemberListIfOptionActive()
				
			Case $GUImsg = $EditSelectedMemberButtonID ; Edit
				$ComboData = GUICtrlRead($ListofMembersListID)
				If $ComboData < 1 Then
					MsgBox(0, "No Record Selected", "Please select a record by clicking on it with the mouse")
				Else
					GUISetState(@SW_HIDE, $MainGUIHandle)
					EditRecord(Int(StringLeft($ComboData, 5)))
					GUISetState(@SW_SHOW, $MainGUIHandle)
					UpdateMemberListIfOptionActive()
					GUICtrlSetState($SearchInputID, $GUI_FOCUS)
				EndIf
				
			Case $GUImsg = $DeleteSelectedMemberButtonID ; Delete
				$ComboData = GUICtrlRead($ListofMembersListID)
				
				If $ComboData < 1 Then
					MsgBox(0, "No Record Selected", "Please select a record by clicking on it with the mouse")
				Else
					$Question = MsgBox(36, "Confirmation", StringTrimLeft($ComboData, 8) & " Will be Deleted!  Are You Sure?")
					If $Question = 6 Then ; user said yes
						DeleteMember(Int(StringLeft($ComboData, 5)))
						UpdateMemberListIfOptionActive()
					EndIf
				EndIf
				
			Case $GUImsg = $SaveButtonID ; save
				Save()
				
			Case $GUImsg = $PrintThisDataButtonID  ; print Data
				If $SaveNeeded = "yes" Then
					$Question = MsgBox(16, "Data Not Saved", "Warning!!  Unsaved Data Exists!  Please save before Printing.")
				Else
					CreateLableOutputFiles()
				EndIf
				
			Case $GUImsg = $PrintMultipleDataFilesButtonID  ; print multiple DataFiles
				If $SaveNeeded = "yes" Then
					$Question = MsgBox(16, "Data Not Saved", "Warning!!  Unsaved Data Exists!  Please save before Printing.")
				Else
					MultipleDataPrint()
				EndIf
				
			Case $GUImsg = $AdvancedFeaturesButtonID ; advanced
				If $SaveNeeded = "yes" Then
					$Question = MsgBox(16, "Data Not Saved", "Warning!!  Unsaved Data Exists!  Please save before launching Advanced Features.")
				Else
					GUISetState(@SW_HIDE, $MainGUIHandle)
					AdvancedFeaturesGUI()
					GUISetState(@SW_SHOW, $MainGUIHandle)
				EndIf
				
			Case $GUImsg = $QuitButtonID ; quit
				If $SaveNeeded = "yes" Then
					$Question = MsgBox(20, "Data Not Saved", "Warning!!  Unsaved Data Exists!  Do you really want to exit? (Unsaved Data will be lost)")
					If $Question = 6 Then ; user said yes
						Exit
					EndIf
				Else
					Exit
				EndIf
				
			Case $GUImsg = $ChangeDataButtonID ; change Data
				If $SaveNeeded = "yes" Then
					$Question = MsgBox(20, "Data Not Saved", "Warning!!  Unsaved Data Exists!  Do you really want to change Data? (Unsaved Data will be lost)")
					If $Question = 6 Then ; user said yes
						$LoadAnotherDataFile = "yes"
						GUIDelete()
						ContinueLoop 2
					EndIf
				Else
					$LoadAnotherDataFile = "yes"
					GUIDelete()
					ContinueLoop 2
				EndIf
				
			Case $GUImsg = $SortButtonID ; sort
				Select
					Case GUICtrlRead($MemberNumberRadioID) = $GUI_CHECKED
						$SortField = 1
						$FileDescriptors[4] = 1
						If $VerboseMode = "on" Then
							MsgBox(0, "GUI State Report", "Member Number was checked. $SortField is set to " & $SortField)
						EndIf
						
					Case GUICtrlRead($SurnameRadioID) = $GUI_CHECKED
						$SortField = 4
						$FileDescriptors[4] = 4
						If $VerboseMode = "on" Then
							MsgBox(0, "GUI State Report", "Surname was checked. $SortField is set to " & $SortField)
						EndIf
						
				EndSelect
				SortDatabase($SortField, $DataArrayWidth)
				GUICtrlSetData($ListofMembersListID, GenerateMembersList())
				GUIDelete() ; kill member list progress bar GUI
				GUISwitch($MainGUIHandle)
				
		EndSelect
	WEnd
	
WEnd ; end of huge main loop that re-starts from scratch in another Data file is requested

Exit
; End Main Script ----------------------------------------------------------------------

; FUNCTIONS ----------------------------------------------------------------------------

Func CreatNewDataFile()
	;check template exists
	$FileExistsCheck = FileExists($BlankTemplateFileAndPath)
	If $FileExistsCheck = 0 Then
		MsgBox(0, "Missing File", "Template File '" & $BlankTemplateFileAndPath & "' does not exist.  Cannot Create New Data File.")
		Exit
	EndIf
	;request new name
	$NewDataName = InputBox("New Data Name", "Please Input the Name of the New Data", "New Data File")
	$CreateFilereturncode = FileCopy($BlankTemplateFileAndPath, $DataFilePath & $NewDataName & ".csv")
	If $CreateFilereturncode = 0 Then
		MsgBox(0, "Cannot Create File", "Cannot Create Data File '" & $DataFilePath & $NewDataName & ".csv" & "'.  This may mean a Data file by that name already exists.")
		Exit
	EndIf
EndFunc   ;==>CreatNewDataFile

Func CountDataFileLines($FileHandle, $FileSize) ; this is a modified version of the user function _filecountlines.  The file size must have been determined before opening the file
	Local $N = $FileSize - 1
	If @error Or $N = -1 Then Return 0
	Return StringLen(StringAddCR(FileRead($FileHandle, $N))) - $N + 1
EndFunc   ;==>CountDataFileLines

Func ReadHeaderIntoArray()
	;read header information into header array
	$LineCounter = 0
	For $LineNumber = 1 To $DataFileLineNumberOfFirstRecord - 1
		;copy the lines from temp array into the $HeaderArray for that line
		$HeaderArray[$LineNumber] = $DataFileLineArraytemp[$LineNumber]
		$LineCounter = $LineCounter + 1
	Next
	return ($LineCounter)
EndFunc   ;==>ReadHeaderIntoArray

Func ReadDataIntoArray() ; used for normal operation to read Data file
	;create read data into data array progress bar GUI
	GUICreate("Opening Data File", 350, 100, (@DesktopWidth - 350) / 2, (@DesktopHeight - 100) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	$ProgressLableID = GUICtrlCreateLabel("Reading Data File...", 40, 10, 270, 30, $SS_center)
	GUICtrlSetFont($ProgressLableID, 9, 600)
	$ProgressBarID = GUICtrlCreateProgress(40, 60, 270, 20)
	GUISetState()
	
	$RecordCounter = 0
	For $LineNumber = $DataFileLineNumberOfFirstRecord To $NumberOfDataFileLines
		GUICtrlSetData($ProgressBarID, ($RecordCounter / $NumberOfRecords) * 100)
		;increment the record counter (this is used to index the array)
		$RecordCounter = $RecordCounter + 1
		If $VerboseMode = "on" Then
			SplashTextOn("Address Database", "Reading Record " & $RecordCounter & " of " & $NumberOfRecords, 300, 100, -1, -1, 18)
		EndIf
		;split the line at the comma delimeters and read into the $linefields array
		$LineFields = StringSplit($DataFileLineArraytemp[$DataFileLineNumberOfFirstRecord + $RecordCounter - 1], ",", 0)
		;test the number of fields is correct
		If $LineFields[0] <> $NumberOfFields Then
			If $LineFields[0] >= 4 Then ; only output member description if it exists
				$ErrorText = "Data File Line " & $LineNumber & " representing Member Number " & $LineFields[1] & " (" & $LineFields[3] & " " & $LineFields[4] & ") contains " & $LineFields[0] & " fields when it should contain " & $NumberOfFields & " fields.  This record is corrupted and will be REMOVED from the database."
			Else
				$ErrorText = "Data File Line " & $LineNumber & " contains " & $LineFields[0] & " fields when it should contain " & $NumberOfFields & " fields.  This record is corrupted and will be REMOVED from the database."
			EndIf
			;display error and warning the record will be skipped.  While it will not be deleted from the file now, it WILL be when the data is written beck from the array
			MsgBox(48, "Data File Error", $ErrorText)
			$RecordCounter = $RecordCounter - 1 ; decrement the record counter
			$DataArrayHeight = $DataArrayHeight - 1 ; shorten the data array
			ReDim $DataArray[$DataArrayHeight][$DataArrayWidth]
			$NumberOfRecords = $NumberOfRecords - 1 ; adjust the number of records
			ContinueLoop ; skip this record & restart with the next line
		EndIf
		;convert the string for membernumber into a true number
		$LineFields[1] = Number($LineFields[1])
		;write the Data filename to element [0]
		$DataArray[$RecordCounter][0] = StringTrimRight($DataFileName, 4)
		;copy the $linefields array into the record line of the $DataArray for that record
		For $FieldNumber = 1 To $NumberOfFields
			$DataArray[$RecordCounter][$FieldNumber] = $LineFields[$FieldNumber]
		Next
	Next
	If $VerboseMode = "on" Then
		SplashOff()
	EndIf
	;remove progress bar GUI
	GUIDelete()
	return ($RecordCounter)
EndFunc   ;==>ReadDataIntoArray

Func AddSubsequentDataIntoArray() ; used for multiple Data file loading for multiple Data file print
	;create read data into data array progress bar GUI
	GUICreate("Opening Data File", 350, 100, (@DesktopWidth - 350) / 2, (@DesktopHeight - 100) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	$ProgressLableID = GUICtrlCreateLabel("Reading Data File...", 40, 10, 270, 30, $SS_center)
	GUICtrlSetFont($ProgressLableID, 9, 600)
	$ProgressBarID = GUICtrlCreateProgress(40, 60, 270, 20)
	GUISetState()
	;read data into data array
	$RecordCounter = 0
	For $LineNumber = $DataFileLineNumberOfFirstRecord To $NumberOfDataFileLines
		GUICtrlSetData($ProgressBarID, ($RecordCounter / $NumberOfRecordsinSubsequentFile) * 100)
		;increment the record counter (this is used to index the array)
		$RecordCounter = $RecordCounter + 1
		If $VerboseMode = "on" Then
			SplashTextOn("Address Database", "Reading Record " & $RecordCounter & " of " & $NumberOfRecordsinSubsequentFile, 300, 100, -1, -1)
		EndIf
		;split the line at the comma delimeters and read into the $linefields array
		$LineFields = StringSplit($DataFileLineArraytemp[$DataFileLineNumberOfFirstRecord + $RecordCounter - 1], ",", 0)
		;test the number of fields is correct
		If $LineFields[0] <> $NumberOfFields Then
			If $LineFields[0] >= 4 Then ; only output member description if it exists
				$ErrorText = "Data File Line " & $LineNumber & " representing Member Number " & $LineFields[1] & " (" & $LineFields[3] & " " & $LineFields[4] & ") contains " & $LineFields[0] & " fields when it should contain " & $NumberOfFields & " fields.  This record is corrupted and will be REMOVED from the database."
			Else
				$ErrorText = "Data File Line " & $LineNumber & " contains " & $LineFields[0] & " fields when it should contain " & $NumberOfFields & " fields.  This record is corrupted and will be REMOVED from the database."
			EndIf
			;display error and warning the record will be skipped.  While it will not be deleted from the file now, it WILL be when the data is written beck from the array
			MsgBox(48, "Data File Error", $ErrorText)
			$RecordCounter = $RecordCounter - 1 ; decrement the record counter
			$DataArrayHeight = $DataArrayHeight - 1 ; shorten the data array
			ReDim $DataArray[$DataArrayHeight][$DataArrayWidth]
			$NumberOfRecords = $NumberOfRecords - 1 ; adjust the number of records
			ContinueLoop ; skip this record & restart with the next line
		EndIf
		;convert the string for membernumber into a true number
		$LineFields[1] = Number($LineFields[1])
		;write the Data filename to element [0]
		$DataArray[$OldDataArrayHeight - 1 + $RecordCounter][0] = StringTrimRight($DataFileName, 4)
		;copy the $linefields array into the record line of the $DataArray for that record
		For $FieldNumber = 1 To $NumberOfFields
			$DataArray[$OldDataArrayHeight - 1 + $RecordCounter][$FieldNumber] = $LineFields[$FieldNumber]
		Next
	Next
	If $VerboseMode = "on" Then
		SplashOff()
	EndIf
	;remove progress bar GUI
	GUIDelete()
	return ($RecordCounter)
EndFunc   ;==>AddSubsequentDataIntoArray

Func GenerateMembersList()
	GUICreate("Generating Member List", 350, 100, (@DesktopWidth - 350) / 2, (@DesktopHeight - 100) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	$ProgressLableID = GUICtrlCreateLabel("Preparing List of Members...", 40, 10, 270, 30, $SS_center)
	GUICtrlSetFont($ProgressLableID, 9, 600)
	$ProgressBarID = GUICtrlCreateProgress(40, 60, 270, 20)
	GUISetState()
	$ConcatenatedString = ""
	For $RecordNumber = 1 To $NumberOfRecords
		$RecordString = StringFormat("%05u", $RecordNumber) & " : " & $DataArray[$RecordNumber][1] & " - " & $DataArray[$RecordNumber][3] & " " & StringUpper($DataArray[$RecordNumber][4]) & "  -  " & $DataArray[$RecordNumber][5] & " " & $DataArray[$RecordNumber][6]
		$ConcatenatedString = $ConcatenatedString & "|" & $RecordString
		GUICtrlSetData($ProgressBarID, ($RecordNumber / $NumberOfRecords) * 100)
	Next
	Return $ConcatenatedString
EndFunc   ;==>GenerateMembersList

Func CreateLableOutputFiles()
	
	;clear any previous .txt and .prt files in printfile dir
	FileDelete($PrintFilePath & "*.txt")
	FileDelete($PrintFilePath & "*.prt")
	
	;choose a Lable Type to open
	;Create list of specification files for the combo box
	$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.spc")
	
	; Warn if no Lable Specification Files  files exist
	If $FileSearchHandle = -1 Then
		MsgBox(0, "Warning", "No Lable Specification Files Exist.  Cannot Continue.")
		Return
	EndIf
	;retrieve 1st file in file list
	$FileList = StringTrimRight(FileFindNextFile($FileSearchHandle), 4)
	$FileListFirst = $FileList
	;continue to populate list
	While 1
		$NextFile = FileFindNextFile($FileSearchHandle)
		If @error Then
			ExitLoop
		EndIf
		$NextFile = StringTrimRight($NextFile, 4)
		$FileList = $FileList & "|" & $NextFile
	WEnd
	
	; Close the search handle
	FileClose($FileSearchHandle)
	
	; create the Lable Type Selection GUI
	GUICreate("Lable Type Selection", 300, 170, (@DesktopWidth - 300) / 2, (@DesktopHeight - 250) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$SelectLableFileComboID = GUICtrlCreateCombo("", 15, 15, 270, 250)
	$CopyNumberCheckboxID = GUICtrlCreateCheckbox("Include 'Number of Copies' Figure on Lable", 40, 50, 260, 20)
	GUICtrlCreateLabel("Skip top", 15, 83, 60, 15, $SS_right)
	$SkipRowsOnFirstPageInputID = GUICtrlCreateInput("", 80, 80, 30, 20, $ES_NUMBER)
	GUICtrlCreateLabel("lable rows on first page of lables", 115, 83, 150, 15, $SS_Left)
	$OpenLableFileButtonID = GUICtrlCreateButton("Select", 85, 120, 100, 30)
	GUICtrlSetState($CopyNumberCheckboxID, $GUI_CHECKED)
	GUICtrlSetState($SelectLableFileComboID, $GUI_FOCUS)
	GUICtrlSetState($OpenLableFileButtonID, $GUI_DEFBUTTON)
	GUICtrlSetData($SkipRowsOnFirstPageInputID, 0)
	GUICtrlSetTip($CopyNumberCheckboxID, "Includes the 'Number of Copies' from the member record on the lable bottom corner")
	GUICtrlSetTip($SkipRowsOnFirstPageInputID, "Handy when using up a partly printed lable sheet")
	
	;load data into file list window
	GUICtrlSetData($SelectLableFileComboID, $FileList, $FileListFirst)
	
	GUISetState()
	While 1
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Return
			Case $GUImsg = $OpenLableFileButtonID
				$ComboData = GUICtrlRead($SelectLableFileComboID)
				$SkipRowsOnFirstPage = Number(Int(GUICtrlRead($SkipRowsOnFirstPageInputID)))
				If GUICtrlRead($CopyNumberCheckboxID) = $GUI_CHECKED Then
					$CopyNumberInclude = "yes"
				Else
					$CopyNumberInclude = "no"
				EndIf
				ExitLoop
		EndSelect
	WEnd
	
	GUIDelete()
	
	$LableSpecificationFileAndPath = $DataFilePath & $ComboData & ".spc"
	$LableSpecificationFileHandle = FileOpen($LableSpecificationFileAndPath, 0)
	If $LableSpecificationFileHandle = -1 Then
		MsgBox(0, "Error", "Cannot open Lable Specification File '" & $LableSpecificationFileAndPath & "'.  Cannot Continue")
		Return
	EndIf
	
	;read ini file data for printfile
	$RawINISpec = FileReadLine($LableSpecificationFileHandle, 25)
	$INISpecLines = StringSplit($RawINISpec, ",")
	$NumberofINILines = $INISpecLines[2] - $INISpecLines[1] + 1
	
	Dim $INIContentArray[$NumberofINILines + 1] ; 1 is added so element [0] can be used to indicate the array size
	
	$INIContentArray[0] = $NumberofINILines
	$Arraycounter = 1
	For $LineNumber = $INISpecLines[1] To $INISpecLines[2]
		$INIContentArray[$Arraycounter] = FileReadLine($LableSpecificationFileHandle, $LineNumber)
		$Arraycounter = $Arraycounter + 1
	Next
	
	If $VerboseMode = "on" Then
		MsgBox(0, "PrintFile INI file Data Found", $INIContentArray[0] & " lines of INI file data found")
	EndIf
	
	;now write array to printfile ini file
	$INIFileHandle = FileOpen($PrintFileINIAndPath, 2) ; open & erase contents
	If $INIFileHandle = -1 Then
		MsgBox(0, "Unable to dump INI data", "Unable to open PrintFile INI file '" & $PrintFileINIAndPath & "' for writing.  Unable to continue.")
		Return
	EndIf
	
	For $LineNumber = 1 To $NumberofINILines
		FileWriteLine($INIFileHandle, $INIContentArray[$LineNumber])
	Next
	FileClose($INIFileHandle)
	
	;read print layout information
	$RawLableSpec = FileReadLine($LableSpecificationFileHandle, 12)
	$LableSpecificationArray_RowsColumnsSizes = StringSplit($RawLableSpec, ",;")
	$RawLableSpec = FileReadLine($LableSpecificationFileHandle, 13)
	$LableSpecificationArray_ColumnGaps = StringSplit($RawLableSpec, ",;")
	$RawLableSpec = FileReadLine($LableSpecificationFileHandle, 14)
	$LableSpecificationArray_RowGaps = StringSplit($RawLableSpec, ",;")
	
	;zero truncation count
	$TruncationCount = 0
	
	;check if printing test file
	If $DataFileName = $LableTestingDataFileName Then $TruncationWarning = "off"
	
	;use case to select a procedure for the column & row type specified in the specification file
	
	Select
		Case $LableSpecificationArray_RowsColumnsSizes[1] = 2 ; ie we have a 2 column paper layout
			
			; make number of records even if required
			$NumberofLableRowsInTotal = $NumberOfRecords / 2
			If Int($NumberofLableRowsInTotal) <> $NumberofLableRowsInTotal Then
				;add a row to the data array
				ReDim $DataArray [$DataArrayHeight + 1 ][$DataArrayWidth]
				;increase the record count
				$NumberOfRecords = $NumberOfRecords + 1
				;add note to dummy last record
				$DataArray [$DataArrayHeight][3] = "This is Blank Intentionally"
				;check we are now even
				$NumberofLableRowsInTotal = $NumberOfRecords / 2
				If Int($NumberofLableRowsInTotal) <> $NumberofLableRowsInTotal Then
					MsgBox(0, "Cannot make record number even", "Failed to augment data array to an even number of records.  Cannot Continue")
					Return
				EndIf
				If $VerboseMode = "on" Then
					MsgBox(0, "Record Number Adjusted", "Record number adjusted up one to make even")
				EndIf
				$ReDimDone = "yes"
			Else
				If $VerboseMode = "on" Then
					MsgBox(0, "Record Number not Adjusted", "Record number was already even.  No adjustment was required.")
				EndIf
				$ReDimDone = "no"
			EndIf
			
			
			;create first outputfile for writing
			$OutputFileCounter = 1
			$OutputFileHandle = FileOpen($PrintFilePath & $OutputFileBaseName & StringFormat("%03u", $OutputFileCounter) & ".txt", 2)
			If $OutputFileHandle = -1 Then
				MsgBox(0, "Cannot Open Output File", "Cannot open output file '" & $PrintFilePath & $OutputFileBaseName & $OutputFileCounter & ".txt'  Cannot Continue")
			EndIf
			SplashTextOn("Writing to File....", "Formatting Page 1 ...", 200, 50, -1, -1, 18)
			
			;create text to insert between columns
			$InsertionText = "" ; this is the blank spaces inserted between the data in column 1 & column 2
			For $InsertionTextCounter = 1 To Number($LableSpecificationArray_ColumnGaps[1])
				$InsertionText = $InsertionText & " "
			Next
			If $VerboseMode = "on" Then
				MsgBox(0, "InsertionTextCounter = " & $InsertionTextCounter, "Lable Spec from Array = " & $LableSpecificationArray_ColumnGaps[1] & @CRLF & "Insertion Text = '" & $InsertionText & "'" & @CRLF & "Insertion String Length = " & StringLen($InsertionText))
			EndIf
			
			
			;create blank line string (this is used to test for empty lines in lables)
			$BlankLineText = ""
			For $Counter = 1 To $LableSpecificationArray_RowsColumnsSizes[3]
				$BlankLineText = $BlankLineText & " "
			Next
			
			$PageRowCounter = 0 ; this tracks how many lable rows have been written to the output file
			
			$TruncationTrackerString = "" ; this is used to keep a list of records that suffered truncation
			
			;insert skip rows if requested
			If $SkipRowsOnFirstPage > 0 Then
				;check skip lines is valid for this layout
				If $SkipRowsOnFirstPage > $LableSpecificationArray_RowsColumnsSizes[2] - 1 Then
					MsgBox(0, "Error", "Number of rows to skip on first page is too large!.  Skipping cancelled.  Normal print mode restored.")
				Else
					For $Counter = 1 To $SkipRowsOnFirstPage
						;write spacer lines to file
						If $LableSpecificationArray_RowGaps[$PageRowCounter + 1] > 0 Then ; check if blank lines required
							For $BlankLines = 1 To $LableSpecificationArray_RowGaps[$PageRowCounter + 1] ; write blank lines
								FileWriteLine($OutputFileHandle, " ")
							Next
						EndIf
						
						;write block lines to file
						FileWriteLine($OutputFileHandle, " ")
						FileWriteLine($OutputFileHandle, " ")
						FileWriteLine($OutputFileHandle, " ")
						FileWriteLine($OutputFileHandle, " ")
						FileWriteLine($OutputFileHandle, " ")
						FileWriteLine($OutputFileHandle, " ")
						FileWriteLine($OutputFileHandle, " ")
						
						$PageRowCounter = $PageRowCounter + 1
					Next
				EndIf
				
			EndIf
			
			;---------------------------------------------------------------
			
			;set loop to read whole of data array
			For $RecordNumber = 1 To $NumberOfRecords Step 2 ; proceed 2 records at a time
				
				;create 1st Address Block
				$TruncCheck = $TruncationCount ; initialist truncation count monitor
				$TextTooLong = "" ; initialise the truncation text record
				$Block1Line1 = AdjustToLength($DataArray[$RecordNumber][2] & " " & $DataArray[$RecordNumber][3] & " " & $DataArray[$RecordNumber][4], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block1Line2 = AdjustToLength($DataArray[$RecordNumber][5], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block1Line3 = AdjustToLength($DataArray[$RecordNumber][6], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block1Line4 = AdjustToLength($DataArray[$RecordNumber][7], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block1Line5 = AdjustToLength($DataArray[$RecordNumber][8], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block1Line6 = AdjustToLength($DataArray[$RecordNumber][9] & " " & $DataArray[$RecordNumber][10], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block1Line7WithoutCopyNumber = StringUpper(AdjustToLength($DataArray[$RecordNumber][11] & "   " & $DataArray[$RecordNumber][12], $LableSpecificationArray_RowsColumnsSizes[3]))
				If $CopyNumberInclude = "yes" Then
					$Block1line7 = StringTrimRight($Block1Line7WithoutCopyNumber, StringLen($DataArray[$RecordNumber][15]) + 2) & "(" & $DataArray[$RecordNumber][15] & ")"
				Else
					$Block1line7 = $Block1Line7WithoutCopyNumber
				EndIf
				If $TruncCheck <> $TruncationCount Then ;check if truncations occured
					$TruncationTrackerString = $TruncationTrackerString & "," & $RecordNumber & "|" & $TextTooLong ; write record number to truncation file
				EndIf
				;create 2st Address Block
				$TruncCheck = $TruncationCount ; initialist truncation count monitor
				$TextTooLong = "" ; ; initialise the truncation text record
				$Block2Line1 = AdjustToLength($DataArray[$RecordNumber + 1][2] & " " & $DataArray[$RecordNumber + 1][3] & " " & $DataArray[$RecordNumber + 1][4], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block2Line2 = AdjustToLength($DataArray[$RecordNumber + 1][5], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block2Line3 = AdjustToLength($DataArray[$RecordNumber + 1][6], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block2Line4 = AdjustToLength($DataArray[$RecordNumber + 1][7], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block2Line5 = AdjustToLength($DataArray[$RecordNumber + 1][8], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block2Line6 = AdjustToLength($DataArray[$RecordNumber + 1][9] & " " & $DataArray[$RecordNumber + 1][10], $LableSpecificationArray_RowsColumnsSizes[3])
				$Block2Line7WithoutCopyNumber = StringUpper(AdjustToLength($DataArray[$RecordNumber + 1][11] & "   " & $DataArray[$RecordNumber + 1][12], $LableSpecificationArray_RowsColumnsSizes[3]))
				If $CopyNumberInclude = "yes" Then
					$Block2line7 = StringTrimRight($Block2Line7WithoutCopyNumber, StringLen($DataArray[$RecordNumber + 1][15]) + 2) & "(" & $DataArray[$RecordNumber + 1][15] & ")"
				Else
					$Block2line7 = $Block2Line7WithoutCopyNumber
				EndIf
				If $TruncCheck <> $TruncationCount Then ;check if truncations occured
					$TruncationTrackerString = $TruncationTrackerString & "," & $RecordNumber + 1 & "|" & $TextTooLong ; write record number to truncation file
				EndIf
				;shuffle lines if optional address lines are not present for block 1
				$LoopCount = 0
				While $Block1Line3 = $BlankLineText
					$Block1Line3 = $Block1Line4
					$Block1Line4 = $Block1Line5
					$Block1Line5 = $Block1Line6
					$Block1Line6 = $Block1line7
					$Block1line7 = AdjustToLength(" ", $LableSpecificationArray_RowsColumnsSizes[3])
					$LoopCount = $LoopCount + 1
					If $LoopCount = 5 Then ExitLoop ; to avoid an endless loop.  By this time the whole bottom half of the lable is blank!
				WEnd
				$LoopCount = 0
				While $Block1Line4 = $BlankLineText
					$Block1Line4 = $Block1Line5
					$Block1Line5 = $Block1Line6
					$Block1Line6 = $Block1line7
					$Block1line7 = AdjustToLength(" ", $LableSpecificationArray_RowsColumnsSizes[3])
					$LoopCount = $LoopCount + 1
					If $LoopCount = 5 Then ExitLoop ; to avoid an endless loop.  By this time the whole bottom half of the lable is blank!
				WEnd
				$LoopCount = 0
				While $Block1Line5 = $BlankLineText
					$Block1Line5 = $Block1Line6
					$Block1Line6 = $Block1line7
					$Block1line7 = AdjustToLength(" ", $LableSpecificationArray_RowsColumnsSizes[3])
					$LoopCount = $LoopCount + 1
					If $LoopCount = 5 Then ExitLoop ; to avoid an endless loop.  By this time the whole bottom half of the lable is blank!
				WEnd
				;shuffle lines if optional address lines are not present for block 2
				$LoopCount = 0
				While $Block2Line3 = $BlankLineText
					$Block2Line3 = $Block2Line4
					$Block2Line4 = $Block2Line5
					$Block2Line5 = $Block2Line6
					$Block2Line6 = $Block2line7
					$Block2line7 = AdjustToLength(" ", $LableSpecificationArray_RowsColumnsSizes[3])
					$LoopCount = $LoopCount + 1
					If $LoopCount = 5 Then ExitLoop ; to avoid an endless loop.  By this time the whole bottom half of the lable is blank!
				WEnd
				$LoopCount = 0
				While $Block2Line4 = $BlankLineText
					$Block2Line4 = $Block2Line5
					$Block2Line5 = $Block2Line6
					$Block2Line6 = $Block2line7
					$Block2line7 = AdjustToLength(" ", $LableSpecificationArray_RowsColumnsSizes[3])
					$LoopCount = $LoopCount + 1
					If $LoopCount = 5 Then ExitLoop ; to avoid an endless loop.  By this time the whole bottom half of the lable is blank!
				WEnd
				$LoopCount = 0
				While $Block2Line5 = $BlankLineText
					$Block2Line5 = $Block2Line6
					$Block2Line6 = $Block2line7
					$Block2line7 = AdjustToLength(" ", $LableSpecificationArray_RowsColumnsSizes[3])
					$LoopCount = $LoopCount + 1
					If $LoopCount = 5 Then ExitLoop ; to avoid an endless loop.  By this time the whole bottom half of the lable is blank!
				WEnd
				;combine data from blocks into complete lines
				$OutputLine1 = $Block1Line1 & $InsertionText & $Block2Line1
				$OutputLine2 = $Block1Line2 & $InsertionText & $Block2Line2
				$OutputLine3 = $Block1Line3 & $InsertionText & $Block2Line3
				$OutputLine4 = $Block1Line4 & $InsertionText & $Block2Line4
				$OutputLine5 = $Block1Line5 & $InsertionText & $Block2Line5
				$OutputLine6 = $Block1Line6 & $InsertionText & $Block2Line6
				$OutputLine7 = $Block1line7 & $InsertionText & $Block2line7
				
				;write spacer lines to file
				If $LableSpecificationArray_RowGaps[$PageRowCounter + 1] > 0 Then ; check if blank lines required
					For $BlankLines = 1 To $LableSpecificationArray_RowGaps[$PageRowCounter + 1] ; write blank lines
						FileWriteLine($OutputFileHandle, " ")
					Next
				EndIf
				
				;write block lines to file
				FileWriteLine($OutputFileHandle, $OutputLine1)
				FileWriteLine($OutputFileHandle, $OutputLine2)
				FileWriteLine($OutputFileHandle, $OutputLine3)
				FileWriteLine($OutputFileHandle, $OutputLine4)
				FileWriteLine($OutputFileHandle, $OutputLine5)
				FileWriteLine($OutputFileHandle, $OutputLine6)
				FileWriteLine($OutputFileHandle, $OutputLine7)
				
				$PageRowCounter = $PageRowCounter + 1
				
				If $PageRowCounter = $LableSpecificationArray_RowsColumnsSizes[2] Then ; all rows written to current file
					; close data file & open a new one
					FileClose($OutputFileHandle)
					
					$OutputFileCounter = $OutputFileCounter + 1; increment output file counter
					
					$OutputFileHandle = FileOpen($PrintFilePath & $OutputFileBaseName & StringFormat("%03u", $OutputFileCounter) & ".txt", 2)
					If $OutputFileHandle = -1 Then
						MsgBox(0, "Cannot Open Output File", "Cannot open output file '" & $PrintFilePath & $OutputFileBaseName & $OutputFileCounter & ".txt'  Cannot Continue")
					EndIf
					SplashTextOn("Writing to File....", "Formatting Page " & $OutputFileCounter & " ...", 200, 50, -1, -1, 18)
					$PageRowCounter = 0 ; reset page row counter
				EndIf
			Next ; loop back while there are still records
			
			; all output data files are now written
			;close last output file
			FileClose($OutputFileHandle)
			SplashOff()
			
			; remove the dummy record from the end of the array (if it was added)
			If $ReDimDone = "yes" Then
				;correct the size of the data array
				ReDim $DataArray [$DataArrayHeight][$DataArrayWidth]
				;decrement the record count
				$NumberOfRecords = $NumberOfRecords - 1
				If $VerboseMode = "on" Then
					MsgBox(0, "Reducing Array", "Removing dummy record added to array")
				EndIf
			EndIf
			
			;check if printing test file
			If $DataFileName <> $LableTestingDataFileName Then ; truncation reporting is skipped for test file
				;write truncation report if required
				If StringLen($TruncationTrackerString) > 0 Then ; test if any truncations occured.
					If $VerboseMode = "on" Then
						MsgBox(0, "Truncation Tracker String", $TruncationTrackerString)
					EndIf
					
					$TruncationRecordNumbersArray = StringSplit($TruncationTrackerString, ",")
					;open truncation file
					$TruncationFileHandle = FileOpen($TruncationReportFileNameandPath, 2)
					;write header info
					FileWriteLine($TruncationFileHandle, "Truncation Report from Address List Database " & @MDAY & "/" & @MON & "/" & @YEAR)
					FileWriteLine($TruncationFileHandle, "=========================================================")
					FileWriteLine($TruncationFileHandle, "Using Lable Specification File '" & $LableSpecificationFileAndPath & "'")
					FileWriteLine($TruncationFileHandle, " ")
					FileWriteLine($TruncationFileHandle, "Format is => Data File : FirstName SURNAME (Member number)")
					FileWriteLine($TruncationFileHandle, '          =>     "Text that was truncated"')
					FileWriteLine($TruncationFileHandle, " ")
					;write content
					For $Counter = 2 To $TruncationRecordNumbersArray[0] ; start from 2 because of the nul element in $TruncationRecordNumbersArray[1] caused by the truncation string starting with a comma
						$TruncReference = StringSplit($TruncationRecordNumbersArray[$Counter], "|")
						FileWriteLine($TruncationFileHandle, $DataArray[$TruncReference[1]][0] & " : " & $DataArray[$TruncReference[1]][3] & " " & StringUpper($DataArray[$TruncReference[1]][4]) & " (Member " & $DataArray[$TruncReference[1]][1] & ")")
						FileWriteLine($TruncationFileHandle, "    " & $TruncReference[2])
						FileWriteLine($TruncationFileHandle, " ")
					Next
					;close file
					FileClose($TruncationFileHandle)
					$Question = MsgBox(36, "Truncation Report Option", "A total of " & $TruncationCount & " truncation events occured during formatting.  A detailed report has been saved at '" & $TruncationReportFileNameandPath & "'.  Would you like to print this report?")
					If $Question = 6 Then
						;dump report to notepad
						$NotepadCommandLine = 'notepad.exe /p "' & $TruncationReportFileNameandPath & '"'
						Run($NotepadCommandLine)
						
					Else
						MsgBox(0, "Advanced option", "An option to view this report is available under the 'Advanced Features' button on the main screen if you wish to access it later")
						
					EndIf
				Else
					;open truncation file
					$TruncationFileHandle = FileOpen($TruncationReportFileNameandPath, 2)
					;write info confirming no truncations occured
					FileWriteLine($TruncationFileHandle, "Truncation Report from Address List Database " & @MDAY & "/" & @MON & "/" & @YEAR)
					FileWriteLine($TruncationFileHandle, "=========================================================")
					FileWriteLine($TruncationFileHandle, "Using Lable Specification File '" & $LableSpecificationFileAndPath & "'")
					FileWriteLine($TruncationFileHandle, " ")
					FileWriteLine($TruncationFileHandle, " ")
					FileWriteLine($TruncationFileHandle, "No records were truncated during this print run")
					;close file
					FileClose($TruncationFileHandle)
					
				EndIf
			EndIf
			
			;now call the function to print the output files
			
			PrintOutputFiles()
			
		Case Else
			MsgBox(0, "No Matching Program Section", "The lable specification describes a layout of " & $LableSpecificationArray_RowsColumnsSizes[1] & " columns.  No corresponding section was found in the print function to handle this configuration.  Cannot Continue.")
			Return
	EndSelect
	
EndFunc   ;==>CreateLableOutputFiles

Func AdjustToLength($Text, $Length) ; adjusts the length of the string to match specification
	$TextLength = StringLen($Text)
	Select
		Case $TextLength > $Length
			$TruncatedText = StringTrimRight($Text, $TextLength - $Length)
			If $TruncationWarning = "on" Then
				MsgBox(0, "Truncation Warning", "The text '" & $Text & "' was too long for the lable width, and was truncated to '" & $TruncatedText & "'")
			EndIf
			If $TextTooLong = "" Then ; keep a record of the text that was truncated for reporting
				$TextTooLong = '"' & $Text & '" ' & $TextLength - $Length & " Chars too long"
			Else
				$TextTooLong = $TextTooLong & ":" & '"' & $Text & '" ' & $TextLength - $Length & ' Chars too long'
			EndIf
			$Text = $TruncatedText
			$TruncationCount = $TruncationCount + 1
			If $TruncationWarning = "on" Then
				If $TruncationCount = 5 Or $TruncationCount = 20 Or $TruncationCount = 100 Then
					$Question = MsgBox(36, "Multiple Truncation Warnings", "You have recieved " & $TruncationCount & " truncation warnings. Do you want to continue recieving them?  (You will always be given the option to print a report of all truncations later)")
					If $Question = 7 Then
						$TruncationWarning = "off"
					EndIf
				EndIf
			EndIf
			
		Case $TextLength < $Length
			For $ExtraCharacters = 1 To $Length - $TextLength
				$Text = $Text & " "
			Next
	EndSelect
	Return $Text
EndFunc   ;==>AdjustToLength

Func CheckLengthOnDataInput($Text, $Length) ; checks the length of the string to match specification
	$TextLength = StringLen($Text)
	If $TextLength > $Length Then
		MsgBox(0, "Truncation Warning", "The text '" & $Text & "' was too long for the lable width by " & $TextLength - $Length & " characters.")
		$Count = 1
	Else
		$Count = 0
	EndIf
	Return $Count
EndFunc   ;==>CheckLengthOnDataInput

Func PrintOutputFiles()
	
	;Select Data Files to Print
	
	;Create list of print files for the combo box
	$FileSearchHandle = FileFindFirstFile($PrintFilePath & "*.txt")
	
	; Warn if no print files exist
	If $FileSearchHandle = -1 Then
		MsgBox(0, "Warning", "No Print Files Currently Exist at '" & $PrintFilePath & "'.  Cannot Continue.")
		Return
	Else
		;open list file for 'print all files' function
		$PrintFileListFileHandle = FileOpen($PrintFileListFileAndPath, 2)
		If $PrintFileListFileHandle = -1 Then
			MsgBox(0, "Cannot Create List File", "Could not create list file '" & $PrintFileListFileAndPath & "'.  The 'Print All Files' feature will be disabled.")
		EndIf
		
		;retrieve 1st file in file list
		$FileList = StringTrimRight(FileFindNextFile($FileSearchHandle), 4)
		$FileListFirst = $FileList
		FileWriteLine($PrintFileListFileHandle, $FileList & ".txt") ; write filename to list file as well
		;continue to populate list
		While 1
			$NextFile = FileFindNextFile($FileSearchHandle)
			If @error Then
				ExitLoop
			EndIf
			FileWriteLine($PrintFileListFileHandle, $NextFile) ; write filename to list file
			$NextFile = StringTrimRight($NextFile, 4)
			$FileList = $FileList & "|" & $NextFile
			
		WEnd
	EndIf
	
	; Close the search handle
	FileClose($FileSearchHandle)
	; Close list file
	FileClose($PrintFileListFileHandle)
	
	; create the File Selection GUI
	GUICreate("Printing Lables", 300, 170, (@DesktopWidth - 300) / 2, (@DesktopHeight - 250) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$SelectPrintFileComboID = GUICtrlCreateCombo("", 35, 20, 230, 250)
	$PrintHighlightedPageButtonID = GUICtrlCreateButton("Print Selected Page", 25, 70, 130, 30)
	$PrintAllPagesButtonID = GUICtrlCreateButton("Print All Pages", 170, 70, 100, 30)
	$DoneButtonID = GUICtrlCreateButton("Done", 100, 120, 100, 30)
	
	;load data into file list window
	GUICtrlSetData($SelectPrintFileComboID, $FileList, $FileListFirst)
	
	GUISetState()
	While 1
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Return
				
			Case $GUImsg = $PrintHighlightedPageButtonID
				$ComboData = GUICtrlRead($SelectPrintFileComboID)
				$FileToPrintNameAndPath = $PrintFilePath & $ComboData & ".txt"
				$PrintFileCommandLine = '"' & $PrintFileEXEAndPath & '" /i:"' & $PrintFileINIAndPath & '" /q "' & $FileToPrintNameAndPath & '"'
				If $VerboseMode = "on" Then
					MsgBox(0, "PrintFile Command", $PrintFileCommandLine & " is ready to send.")
				EndIf
				Run($PrintFileCommandLine, $PrintFilePath) ; pass the command to printfile
				
			Case $GUImsg = $PrintAllPagesButtonID
				If $PrintFileListFileHandle = -1 Then ; ie if list file could not be opened
					MsgBox(0, "Disabled", "This feature is disabled")
				Else
					$PrintFileCommandLine = '"' & $PrintFileEXEAndPath & '" /i:"' & $PrintFileINIAndPath & '" /q @"' & $PrintFileListFileAndPath & '"'
					If $VerboseMode = "on" Then
						MsgBox(0, "PrintFile Command", $PrintFileCommandLine & " is ready to send.")
					EndIf
					Run($PrintFileCommandLine, $PrintFilePath) ; pass the command to printfile
				EndIf
				
			Case $GUImsg = $DoneButtonID
				ExitLoop
		EndSelect
	WEnd
	
	GUIDelete() ; kill the print GUI
	
EndFunc   ;==>PrintOutputFiles

Func AdvancedFeaturesGUI()
	
	$AdvancedFeaturesGUIHandle = GUICreate("Advanced Features", 520, 400, (@DesktopWidth - 520) / 2, (@DesktopHeight - 400) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	;column 1
	$Column1LabelID = GUICtrlCreateLabel("General", 40, 20, 120, 20, $SS_center)
	$DeleteDataButtonID = GUICtrlCreateButton("Delete Data File", 40, 60, 120, 30)
	$ViewTruncationReportButtonID = GUICtrlCreateButton("View Truncation Report", 40, 110, 120, 30)
	$ExportDatatoDesktopButtonID = GUICtrlCreateButton("Export Data to Desktop", 30, 160, 140, 30)
	$ImportDatafromDesktopButtonID = GUICtrlCreateButton("Import Data from Desktop", 30, 210, 140, 30)
	;$Button = GuiCtrlCreateButton("Button", 40, 260, 120, 30)
	$SearchAcrossMultipleDataFilesButtonID = GUICtrlCreateButton("Search Multiple DataFiles", 30, 310, 140, 30)
	;column 2
	$Column2LabelID = GUICtrlCreateLabel("Printing", 200, 20, 120, 20, $SS_center)
	$RePrintPreviousRunButtonID = GUICtrlCreateButton("RePrint Previous Run", 200, 60, 120, 30)
	;$ButtonID = GUICtrlCreateButton("", 200, 110, 120, 30)
	$PrintFileSettingsViewButtonID = GUICtrlCreateButton("PrintFile Settings View", 200, 160, 120, 30)
	$SpecificationFileEditButtonID = GUICtrlCreateButton("Specification File Edit", 200, 210, 120, 30)
	$OpenPrintFileINIButtonID = GUICtrlCreateButton("PrintFile INI View", 200, 260, 120, 30)
	$PrintKeySheetButtonID = GUICtrlCreateButton("Print Numbered Page", 200, 310, 120, 30)
	$FinishedButtonID = GUICtrlCreateButton("Finished", 120, 360, 280, 30)
	;column 3
	$Column3LabelID = GUICtrlCreateLabel("Backup", 360, 20, 120, 20, $SS_center)
	$InternalBackupButtonID = GUICtrlCreateButton("Internal Backup", 360, 60, 120, 30)
	$ExternalBackupButtonID = GUICtrlCreateButton("External Backup", 360, 110, 120, 30)
	$RestoreLableID = GUICtrlCreateLabel("Restore", 360, 170, 120, 30, $SS_center)
	$InternalRestoreButtonID = GUICtrlCreateButton("Internal Restore", 360, 210, 120, 30)
	$ExternalRestoreButtonID = GUICtrlCreateButton("External Restore", 360, 260, 120, 30)
	;$Button = GuiCtrlCreateButton("Button", 360, 310, 120, 30)
	
	;set fonts
	GUICtrlSetFont($Column1LabelID, 9, 600)
	GUICtrlSetFont($Column2LabelID, 9, 600)
	GUICtrlSetFont($Column3LabelID, 9, 600)
	GUICtrlSetFont($FinishedButtonID, 9, 600)
	GUICtrlSetFont($RestoreLableID, 9, 600)
	
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				GUIDelete()
				ExitLoop
			Case $msg = $DeleteDataButtonID
				DeleteDataFile()
				GUISwitch($AdvancedFeaturesGUIHandle)
				
			Case $msg = $ViewTruncationReportButtonID
				$RunCommandLine = 'Notepad.exe "' & $TruncationReportFileNameandPath & '"'
				Run($RunCommandLine)
				
			Case $msg = $ExportDatatoDesktopButtonID
				DesktopExport()
				
			Case $msg = $ImportDatafromDesktopButtonID
				DesktopImport()
				GUISwitch($AdvancedFeaturesGUIHandle)
				
			Case $msg = $RePrintPreviousRunButtonID
				PrintOutputFiles()
				GUISwitch($AdvancedFeaturesGUIHandle)
				
			Case $msg = $PrintFileSettingsViewButtonID
				MsgBox(0, "Warning", "Note that the settings you see here are the most recent ones loaded to PrintView from a Lable Specification File.  Changes you make will only persist until the next time a Lable Specification File is loaded.  To get persistant change you have to take the INI file contents from '" & $PrintFileINIAndPath & "' and manually transfer them to the relevent Lable Specification File")
				$PrintFileCommandLine = '"' & $PrintFileEXEAndPath & '" /i:"' & $PrintFileINIAndPath & '"'; specify just the INI file
				Run($PrintFileCommandLine, $PrintFilePath) ; pass the command to printfile
				
			Case $msg = $SpecificationFileEditButtonID
				SpecificationFileEdit()
				GUISwitch($AdvancedFeaturesGUIHandle)
				
			Case $msg = $OpenPrintFileINIButtonID
				$NotepadCommandLine = 'Notepad.exe ' & '"' & $PrintFileINIAndPath & '"'
				Run($NotepadCommandLine)
				
			Case $msg = $PrintKeySheetButtonID
				#region
				;select spec file to use to print
				;choose a Lable Type to open
				;Create list of specification files for the combo box
				$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.spc")
				
				; Warn if no Lable Specification Files  files exist
				If $FileSearchHandle = -1 Then
					MsgBox(0, "Warning", "No Lable Specification Files Exist.  Cannot Continue.")
					Return
				EndIf
				;retrieve 1st file in file list
				$FileList = "No Specification File Read!"
				$FileListFirst = StringTrimRight(FileFindNextFile($FileSearchHandle), 4)
				$FileList = $FileList & "|" & $FileListFirst
				;continue to populate list
				While 1
					$NextFile = FileFindNextFile($FileSearchHandle)
					If @error Then
						ExitLoop
					EndIf
					$NextFile = StringTrimRight($NextFile, 4)
					$FileList = $FileList & "|" & $NextFile
				WEnd
				
				; Close the search handle
				FileClose($FileSearchHandle)
				
				; create the Lable Type Selection GUI
				GUICreate("Lable Type Selection", 300, 170, (@DesktopWidth - 300) / 2, (@DesktopHeight - 250) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
				
				$SelectLableFileComboID = GUICtrlCreateCombo("", 15, 15, 270, 250)
				;$CopyNumberCheckboxID = GUICtrlCreateCheckbox("Include 'Number of Copies' Figure on Lable", 40, 50, 260, 20)
				;GUICtrlCreateLabel("Skip top", 15, 83, 60, 15, $SS_right)
				;$SkipRowsOnFirstPageInputID = GUICtrlCreateInput("", 80, 80, 30, 20, $ES_NUMBER)
				;GUICtrlCreateLabel("lable rows on first page of lables", 115, 83, 150, 15, $SS_Left)
				$OpenLableFileButtonID = GUICtrlCreateButton("Select", 85, 120, 100, 30)
				;GUICtrlSetState($CopyNumberCheckboxID, $GUI_CHECKED)
				GUICtrlSetState($SelectLableFileComboID, $GUI_FOCUS)
				GUICtrlSetState($OpenLableFileButtonID, $GUI_DEFBUTTON)
				;GUICtrlSetData($SkipRowsOnFirstPageInputID, 0)
				;UICtrlSetTip($CopyNumberCheckboxID, "Includes the 'Number of Copies' from the member record on the lable bottom corner")
				;GUICtrlSetTip($SkipRowsOnFirstPageInputID, "Handy when using up a partly printed lable sheet")
				
				;load data into file list window
				GUICtrlSetData($SelectLableFileComboID, $FileList, $FileListFirst)
				
				GUISetState()
				While 1
					$GUImsg = GUIGetMsg()
					Select
						Case $GUImsg = $GUI_EVENT_CLOSE
							Return
						Case $GUImsg = $OpenLableFileButtonID
							$ComboData = GUICtrlRead($SelectLableFileComboID)
							ExitLoop
					EndSelect
				WEnd
				
				GUIDelete()
				GUISwitch($AdvancedFeaturesGUIHandle)
				
				If $ComboData <> "No Specification File Read!" Then ; permit skipping fo the INI file dump if requested
					
					$LableSpecificationFileAndPath = $DataFilePath & $ComboData & ".spc"
					$LableSpecificationFileHandle = FileOpen($LableSpecificationFileAndPath, 0)
					If $LableSpecificationFileHandle = -1 Then
						MsgBox(0, "Error", "Cannot open Lable Specification File '" & $LableSpecificationFileAndPath & "'.  Cannot Continue")
						Return
					EndIf
					
					;read ini file data for printfile
					$RawINISpec = FileReadLine($LableSpecificationFileHandle, 25)
					$INISpecLines = StringSplit($RawINISpec, ",")
					$NumberofINILines = $INISpecLines[2] - $INISpecLines[1] + 1
					
					Dim $INIContentArray[$NumberofINILines + 1] ; 1 is added so element [0] can be used to indicate the array size
					
					$INIContentArray[0] = $NumberofINILines
					$Arraycounter = 1
					For $LineNumber = $INISpecLines[1] To $INISpecLines[2]
						$INIContentArray[$Arraycounter] = FileReadLine($LableSpecificationFileHandle, $LineNumber)
						$Arraycounter = $Arraycounter + 1
					Next
					
					If $VerboseMode = "on" Then
						MsgBox(0, "PrintFile INI file Data Found", $INIContentArray[0] & " lines of INI file data found")
					EndIf
					
					;now write array to printfile ini file
					$INIFileHandle = FileOpen($PrintFileINIAndPath, 2) ; open & erase contents
					If $INIFileHandle = -1 Then
						MsgBox(0, "Unable to dump INI data", "Unable to open PrintFile INI file '" & $PrintFileINIAndPath & "' for writing.  Unable to continue.")
						Return
					EndIf
					
					For $LineNumber = 1 To $NumberofINILines
						FileWriteLine($INIFileHandle, $INIContentArray[$LineNumber])
					Next
					FileClose($INIFileHandle)
				EndIf
				#region
				;format PrintFile Command
				$PrintFileCommandLine = '"' & $PrintFileEXEAndPath & '" /i:"' & $PrintFileINIAndPath & '" /q "' & $NumberedFileNameAndPath & '"'
				; pass the command to printfile
				Run($PrintFileCommandLine, $PrintFilePath)
				
			Case $msg = $InternalBackupButtonID
				InternalBackup()
				
			Case $msg = $ExternalBackupButtonID
				ExternalBackup()
				GUISwitch($AdvancedFeaturesGUIHandle)
				
			Case $msg = $InternalRestoreButtonID
				InternalRestore()
				
			Case $msg = $ExternalRestoreButtonID
				ExternalRestore()
				GUISwitch($AdvancedFeaturesGUIHandle)
				
			Case $msg = $ExternalRestoreButtonID
				MsgBox(0, "In Progress", "Not Inplemented Yet")
				
			Case $msg = $SearchAcrossMultipleDataFilesButtonID
				;close the Advanced features GUI
				GUIDelete($AdvancedFeaturesGUIHandle)
				;focus on the main GUI
				GUISwitch($MainGUIHandle)
				;show the main GUI
				GUISetState()
				;call function
				MultipleDataSearch()
				;function never returns to here: script quits in function
				
			Case $msg = $FinishedButtonID
				GUIDelete()
				ExitLoop
		EndSelect
	WEnd
EndFunc   ;==>AdvancedFeaturesGUI
#cs
this is only hear to correct a code folding bug in the SciTE Editor
#ce

Func EditRecord($ArrayNumber)
	$EditRecordGUIHandle = GUICreate("Edit Record", 750, 400, (@DesktopWidth - 750) / 2, (@DesktopHeight - 400) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$MemberNumberInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][1], 110, 10, 130, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Member Number", 0, 14, 100, 20, $SS_right)
	GUICtrlSetFont(GUICtrlCreateLabel("(Auto-generated numbers are only unique within the members own Data File!)", 250, 11, 500, 20), 9, 400, 2)
	$TitleInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][2], 110, 40, 80, 20)
	GUICtrlCreateLabel("Salutation", 0, 44, 100, 20, $SS_right)
	$FirstNamesInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][3], 110, 60, 200, 20)
	GUICtrlCreateLabel("Name : Surname", 0, 64, 100, 20, $SS_right)
	$SurnameInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][4], 320, 60, 220, 20)
	
	$AddressLine1InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][5], 110, 85, 320, 20)
	GUICtrlCreateLabel("Address Line 1", 0, 89, 100, 20, $SS_right)
	GUICtrlSetTip($AddressLine1InputID, "Keep lines short to avoid truncations when printing!")
	$AddressLine2InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][6], 110, 105, 320, 20)
	GUICtrlCreateLabel("Line 2 (Optional)", 0, 109, 100, 20, $SS_right)
	GUICtrlSetTip($AddressLine2InputID, "Keep lines short to avoid truncations when printing!")
	$AddressLine3InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][7], 110, 125, 320, 20)
	GUICtrlCreateLabel("Line 3 (Optional)", 0, 129, 100, 20, $SS_right)
	GUICtrlSetTip($AddressLine3InputID, "Keep lines short to avoid truncations when printing!")
	$AddressLine4InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][8], 110, 145, 320, 20)
	GUICtrlCreateLabel("Line 4 (Optional)", 0, 149, 100, 20, $SS_right)
	GUICtrlSetTip($AddressLine4InputID, "Keep lines short to avoid truncations when printing!")
	
	$CitySuburbInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][9], 110, 170, 200, 20)
	GUICtrlCreateLabel("City/Suburb : State", 0, 174, 100, 20, $SS_right)
	$StateInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][10], 320, 170, 220, 20)
	$ZIPPostcodeInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][11], 110, 195, 110, 20)
	GUICtrlCreateLabel("PostCode : Data", 0, 199, 100, 20, $SS_right)
	$DataInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][12], 230, 195, 260, 20)
	
	$NumberOfCopiesInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][15], 220, 245, 80, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Number of Copies", 110, 249, 100, 20, $SS_right)
	$StartDateInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][16], 380, 245, 80, 20)
	GUICtrlCreateLabel("Start Date", 310, 249, 60, 20, $SS_right)
	
	$CommentInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][13], 110, 290, 410, 90, $ES_MULTILINE)
	GUICtrlCreateLabel("Comments", 0, 294, 100, 20, $SS_right)
	
	$NoteAboutSavingLableID = GUICtrlCreateLabel("A Note About Saving" & @CRLF & @CRLF & "Pressing 'OK' on this window only commits the changes to the memory of the computer.  The changes are not written to the hard disk until 'Save' is clicked on the main window.", 560, 210, 185, 160, $SS_center)
	
	$OKButtonID = GUICtrlCreateButton("OK", 600, 40, 140, 40)
	GUICtrlSetFont($OKButtonID, 9, 600)
	$CanceButtonID = GUICtrlCreateButton("Cancel", 600, 120, 140, 40)
	GUICtrlSetState($TitleInputID, $GUI_FOCUS)
	
	GUISetState()
	$CancelButtonPressed = "no"
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $OKButtonID
				;check surname is OK
				If StringLen(GUICtrlRead($SurnameInputID)) < 2 Then
					MsgBox(0, "Invalid Surname", "Surname must have at least 2 characters.")
				Else
					$SaveNeeded = "yes"
					$DataArray[$ArrayNumber][1] = Number(GUICtrlRead($MemberNumberInputID))
					$DataArray[$ArrayNumber][2] = CommaCheck(GUICtrlRead($TitleInputID))
					$DataArray[$ArrayNumber][3] = CommaCheck(GUICtrlRead($FirstNamesInputID))
					$DataArray[$ArrayNumber][4] = CommaCheck(GUICtrlRead($SurnameInputID))
					$DataArray[$ArrayNumber][5] = CommaCheck(GUICtrlRead($AddressLine1InputID))
					$DataArray[$ArrayNumber][6] = CommaCheck(GUICtrlRead($AddressLine2InputID))
					$DataArray[$ArrayNumber][7] = CommaCheck(GUICtrlRead($AddressLine3InputID))
					$DataArray[$ArrayNumber][8] = CommaCheck(GUICtrlRead($AddressLine4InputID))
					$DataArray[$ArrayNumber][9] = CommaCheck(GUICtrlRead($CitySuburbInputID))
					$DataArray[$ArrayNumber][10] = CommaCheck(GUICtrlRead($StateInputID))
					$DataArray[$ArrayNumber][11] = CommaCheck(GUICtrlRead($ZIPPostcodeInputID))
					$DataArray[$ArrayNumber][12] = CommaCheck(GUICtrlRead($DataInputID))
					$DataArray[$ArrayNumber][13] = CommaCheck(GUICtrlRead($CommentInputID))
					;14 is skipped as it is the delete flag, which cannot be set from this screen
					$DataArray[$ArrayNumber][15] = CommaCheck(GUICtrlRead($NumberOfCopiesInputID))
					$DataArray[$ArrayNumber][16] = CommaCheck(GUICtrlRead($StartDateInputID))
					;select lable format to use for truncation check
					#region
					;choose a Lable Type to open
					If $LableFormatForTruncationCheck = "" Then ; this ensures that once the lable type is chosen once in a session the choice persiste for the remainder of the session
						;Create list of specification files for the combo box
						$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.spc")
						
						; Warn if no Lable Specification Files  files exist
						If $FileSearchHandle = -1 Then
							MsgBox(0, "Warning", "No Lable Specification Files Exist.  Cannot Continue.")
							Return
						EndIf
						;retrieve 1st file in file list
						$FileList = StringTrimRight(FileFindNextFile($FileSearchHandle), 4)
						$FileListFirst = $FileList
						;continue to populate list
						While 1
							$NextFile = FileFindNextFile($FileSearchHandle)
							If @error Then
								ExitLoop
							EndIf
							$NextFile = StringTrimRight($NextFile, 4)
							$FileList = $FileList & "|" & $NextFile
						WEnd
						
						; Close the search handle
						FileClose($FileSearchHandle)
						
						; create the Lable Type Selection GUI
						GUICreate("Lable Type Selection", 300, 170, (@DesktopWidth - 300) / 2, (@DesktopHeight - 250) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
						
						$SelectLableFileComboID = GUICtrlCreateCombo("", 15, 15, 270, 250)
						GUICtrlCreateLabel("Please Select your normal lable type", 10, 50, 280, 15, $SS_center)
						GUICtrlCreateLabel("(This lable type will be used to check address line lengths)", 10, 80, 280, 15, $SS_center)
						$OpenLableFileButtonID = GUICtrlCreateButton("Select", 95, 120, 100, 30)
						GUICtrlSetState($SelectLableFileComboID, $GUI_FOCUS)
						GUICtrlSetState($OpenLableFileButtonID, $GUI_DEFBUTTON)
						
						;load data into file list window
						GUICtrlSetData($SelectLableFileComboID, $FileList, $FileListFirst)
						
						GUISetState()
						While 1
							$GUImsg = GUIGetMsg()
							Select
								Case $GUImsg = $GUI_EVENT_CLOSE
									Return
								Case $GUImsg = $OpenLableFileButtonID
									$ComboData = GUICtrlRead($SelectLableFileComboID)
									ExitLoop
							EndSelect
						WEnd
						
						$LableFormatForTruncationCheck = $ComboData
						
						GUIDelete()
						
						GUISwitch($EditRecordGUIHandle)
					EndIf
					$LableSpecificationFileAndPath = $DataFilePath & $LableFormatForTruncationCheck & ".spc"
					;read print layout information
					$RawLableSpec = FileReadLine($LableSpecificationFileAndPath, 12)
					$LableSpecificationArray_RowsColumnsSizes = StringSplit($RawLableSpec, ",;")
					#endregion
					
					;check truncation issues
					$TruncIssues = CheckLengthOnDataInput($DataArray[$ArrayNumber][2] & " " & $DataArray[$ArrayNumber][3] & " " & $DataArray[$ArrayNumber][4], $LableSpecificationArray_RowsColumnsSizes[3])
					$TruncIssues = $TruncIssues + CheckLengthOnDataInput($DataArray[$ArrayNumber][5], $LableSpecificationArray_RowsColumnsSizes[3])
					$TruncIssues = $TruncIssues + CheckLengthOnDataInput($DataArray[$ArrayNumber][6], $LableSpecificationArray_RowsColumnsSizes[3])
					$TruncIssues = $TruncIssues + CheckLengthOnDataInput($DataArray[$ArrayNumber][7], $LableSpecificationArray_RowsColumnsSizes[3])
					$TruncIssues = $TruncIssues + CheckLengthOnDataInput($DataArray[$ArrayNumber][8], $LableSpecificationArray_RowsColumnsSizes[3])
					$TruncIssues = $TruncIssues + CheckLengthOnDataInput($DataArray[$ArrayNumber][9] & " " & $DataArray[$ArrayNumber][10], $LableSpecificationArray_RowsColumnsSizes[3])
					$TruncIssues = $TruncIssues + CheckLengthOnDataInput($DataArray[$ArrayNumber][11] & "   " & $DataArray[$ArrayNumber][12], $LableSpecificationArray_RowsColumnsSizes[3])
					
					If $TruncIssues <> 0 Then
						$Proceed = MsgBox(20, "Truncation Issues", "There are " & $TruncIssues & " truncations that will occur when this record is printed on lable format '" & $LableFormatForTruncationCheck & "'.  Do you want to go back and change the member details to aviod this?")
						If $Proceed = 7 Then
							ExitLoop
						EndIf
					Else
						ExitLoop
					EndIf
				EndIf
				
			Case $msg = $CanceButtonID
				$CancelButtonPressed = "yes"
				ExitLoop
		EndSelect
	WEnd
	GUIDelete()
	Return $CancelButtonPressed ; this is not needed for editing, but it is used when this function is called from the the 'Add New Member' procedure
EndFunc   ;==>EditRecord

Func CommaCheck($String)
	$CheckedString = StringReplace($String, ",", " ")
	If @extended <> 0 Then
		MsgBox(0, "Comma's not allowed in data", "The entered data '" & $String & "' contained an illegal comma.  This has been removed.  New data is '" & $CheckedString & "'")
	EndIf
	Return $CheckedString
EndFunc   ;==>CommaCheck

Func DeleteMember($ArrayNumber)
	$DataArray[$ArrayNumber][14] = "yes"
	$DataArray[$ArrayNumber][1] = "* DELETED *"
	$DataArray[$ArrayNumber][3] = "(Will be gone when file is next re-opened)"
	$SaveNeeded = "yes"
EndFunc   ;==>DeleteMember

Func SortDatabase($SortField, $NumberOfArrayColumns)
	SplashTextOn("Sorting", "Sorting Records...", 300, 100, -1, -1)
	_ArraySort($DataArray, 0, 1, 0, $NumberOfArrayColumns, $SortField)
	$SaveNeeded = "yes"
	SplashOff()
	
EndFunc   ;==>SortDatabase

Func UpdateMemberListIfOptionActive()
	If $NumberOfRecords > $PromptToAutoSortNumber And $AutoUpdateMemberList = "on" And $AutoUpdateQuestionAsked = "no" Then
		$Question = MsgBox(36, "Update Record List?", "The number of members in this Data file is greater than " & $PromptToAutoSortNumber & ".  Updating the displayed member list after each edit may slow down the database.  Do you want to switch off automatic updating of the member list?")
		$AutoUpdateQuestionAsked = "yes"
		If $Question = "6" Then
			$AutoUpdateMemberList = "off"
		EndIf
	EndIf
	If	$AutoUpdateMemberList = "on" Then
		SortDatabase($SortField, $DataArrayWidth)
		GUICtrlSetData($ListofMembersListID, GenerateMembersList())
		GUIDelete() ; kill member list progress bar GUI
		GUISwitch($MainGUIHandle)
	EndIf
EndFunc   ;==>UpdateMemberListIfOptionActive

Func AddNewMember()
	;redim array to add space for new record
	$DataArrayHeight = $DataArrayHeight + 1
	$NumberOfRecords = $NumberOfRecords + 1
	ReDim $DataArray[$DataArrayHeight][$DataArrayWidth]
	$NewRecordArrayNumber = $DataArrayHeight - 1 ; because array starts with [0]
	;set all fields to nothing
	For $FieldNumber = 1 To $NumberOfFields
		$DataArray[$NewRecordArrayNumber][$FieldNumber] = ""
	Next
	;Set new member number
	$DataArray[$NewRecordArrayNumber][1] = FindHighestMemberNumber() + 1
	;Set salutation to a space so it highlights when gui focuses on it at open
	$DataArray[$NewRecordArrayNumber][2] = " "
	;set delete flag off
	$DataArray[$NewRecordArrayNumber][14] = "no"
	;set Data descriptor to match current Data file
	$DataArray[$NewRecordArrayNumber][12] = StringTrimRight($DataFileName, 4)
	;set # of copies to 1
	$DataArray[$NewRecordArrayNumber][15] = 1
	;set date started to today
	$DataArray[$NewRecordArrayNumber][16] = @MDAY & "/" & @MON & "/" & @YEAR
	
	;call editmember on new record
	$Cancel = EditRecord($NewRecordArrayNumber)
	
	;check if 'Cancel' was pressed.  If so, trash the newly created record from the array
	If $Cancel = "yes" Then
		$DataArrayHeight = $DataArrayHeight - 1
		$NumberOfRecords = $NumberOfRecords - 1
		ReDim $DataArray[$DataArrayHeight][$DataArrayWidth]
	EndIf
EndFunc   ;==>AddNewMember

Func FindHighestMemberNumber()
	SplashTextOn("Processing", "Generating Next Member Number...", 300, 100, -1, -1)
	$Highest = 0
	For $RecordNumber = 1 To $NumberOfRecords
		If $DataArray[$RecordNumber][1] >= $Highest Then
			$Highest = $DataArray[$RecordNumber][1]
		EndIf
	Next
	SplashOff()
	Return $Highest
EndFunc   ;==>FindHighestMemberNumber

Func Save()
	SortDatabase($SortField, $DataArrayWidth)
	
	;open & clear data file
	$DataFileHandle = FileOpen($DataFileNameAndPath, 2)
	If $DataFileHandle = -1 Then
		MsgBox(0, "Cannot Open File", "Cannot open '" & $DataFileNameAndPath & "' for saving.  Save failed.")
		Return
	EndIf
	
	;create progress bar GUI
	GUICreate("Writing Data File", 350, 100, (@DesktopWidth - 350) / 2, (@DesktopHeight - 100) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	$ProgressLableID = GUICtrlCreateLabel("Writing Data File...", 40, 10, 270, 30, $SS_center)
	GUICtrlSetFont($ProgressLableID, 9, 600)
	$ProgressBarID = GUICtrlCreateProgress(40, 60, 270, 20)
	GUISetState()
	
	; recreate descriptor line containing sort flag in case sort flag altered
	$HeaderArray[$DescriptorLineNumber] = $FileDescriptors[1] ; place 1st element
	For $Element = 2 To $FileDescriptors[0] ; add remaining elements
		$HeaderArray[$DescriptorLineNumber] = $HeaderArray[$DescriptorLineNumber] & "," & $FileDescriptors[$Element]
	Next
	
	; write comment line back from GUI to header array
	$HeaderArray[$DataFileLineNumberOfDisplayableFileComment] = GUICtrlRead($FileCommentInputID)
	
	;write header array back to file
	For $LineNumber = 1 To $DataFileLineNumberOfFirstRecord - 1
		;write the line
		FileWriteLine($DataFileHandle, $HeaderArray[$LineNumber])
	Next
	
	;write data array back to file
	
	For $RecordNumber = 1 To $NumberOfRecords
		
		$DataLine = $DataArray[$RecordNumber][1] ; extract 1st field
		
		If $DataArray[$RecordNumber][14] = "no" Then ; checks delete flag has not been set - skips if it has
			
			For $FieldNumber = 2 To $NumberOfFields ; extract remaining fields
				$DataLine = $DataLine & "," & $DataArray[$RecordNumber][$FieldNumber]
			Next
			; write the line
			FileWriteLine($DataFileHandle, $DataLine)
			;update the progress bar
			GUICtrlSetData($ProgressBarID, ($RecordNumber / $NumberOfRecords) * 100)
			
		EndIf
		
	Next
	FileClose($DataFileHandle)
	GUIDelete()
	MsgBox(0, "Completed", "Data Saved!")
	$SaveNeeded = "no"
EndFunc   ;==>Save

Func SearchForSurname($SearchString)
	SplashTextOn("Processing", "Searching...", 300, 100, -1, -1)
	$SearchStringLength = StringLen($SearchString)
	$ConcatenatedString = ""
	For $RecordNumber = 1 To $NumberOfRecords
		If StringLeft($DataArray[$RecordNumber][4], $SearchStringLength) = $SearchString Then
			$RecordString = StringFormat("%05u", $RecordNumber) & " : " & $DataArray[$RecordNumber][1] & " - " & $DataArray[$RecordNumber][3] & " " & StringUpper($DataArray[$RecordNumber][4]) & "  -  " & $DataArray[$RecordNumber][5] & " " & $DataArray[$RecordNumber][6]
			$ConcatenatedString = $ConcatenatedString & "|" & $RecordString
		EndIf
	Next
	SplashOff()
	If $ConcatenatedString = "" Then
		MsgBox(0, "No Results", "No members matched the search entered")
	Else
		GUICtrlSetData($ListofMembersListID, $ConcatenatedString)
	EndIf
EndFunc   ;==>SearchForSurname

Func SpecificationFileEdit()
	
	;Create list of specification files for the combo box
	$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.spc")
	
	; Warn if no Lable Specification Files  files exist
	If $FileSearchHandle = -1 Then
		MsgBox(0, "Warning", "No Lable Specification Files Exist.  Cannot Continue.")
		Return
	EndIf
	;retrieve 1st file in file list
	$FileList = StringTrimRight(FileFindNextFile($FileSearchHandle), 4)
	$FileListFirst = $FileList
	;continue to populate list
	While 1
		$NextFile = FileFindNextFile($FileSearchHandle)
		If @error Then
			ExitLoop
		EndIf
		$NextFile = StringTrimRight($NextFile, 4)
		$FileList = $FileList & "|" & $NextFile
	WEnd
	
	; Close the search handle
	FileClose($FileSearchHandle)
	
	; create the Lable Type Selection GUI
	GUICreate("Specification File Selection", 300, 170, (@DesktopWidth - 300) / 2, (@DesktopHeight - 250) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$SelectLableFileComboID = GUICtrlCreateCombo("", 15, 30, 270, 250)
	$OpenLableFileButtonID = GUICtrlCreateButton("Select", 100, 115, 100, 30)
	GUICtrlSetState($SelectLableFileComboID, $GUI_FOCUS)
	GUICtrlSetState($OpenLableFileButtonID, $GUI_DEFBUTTON)
	
	;load data into file list window
	GUICtrlSetData($SelectLableFileComboID, $FileList, $FileListFirst)
	
	GUISetState()
	While 1
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Return
			Case $GUImsg = $OpenLableFileButtonID
				$ComboData = GUICtrlRead($SelectLableFileComboID)
				ExitLoop
		EndSelect
	WEnd
	
	GUIDelete()
	
	$LableSpecificationFileAndPath = $DataFilePath & $ComboData & ".spc"
	
	$NotepadCommandLine = 'notepad.exe ' & '"' & $LableSpecificationFileAndPath & '"'
	Run($NotepadCommandLine)
	
EndFunc   ;==>SpecificationFileEdit

Func InternalBackup()
	;clear old backup dir
	DirRemove($UserBackupFileSubDIR, 1)
	;create backup DIR again
	$Success = DirCreate($UserBackupFileSubDIR)
	If $Success <> 1 Then
		MsgBox(0, "Error", "Cannot create internal backup directory '" & $UserBackupFileSubDIR & "'.  Cannot Continue")
		Return
	EndIf
	;copy all files from data dir.
	$Success = FileCopy($DataFilePath & "*.*", $UserBackupFileSubDIR & "*.*")
	If $Success <> 1 Then
		MsgBox(0, "Error", "Cannot create internal backup directory '" & $UserBackupFileSubDIR & "'.  Cannot Continue")
		Return
	EndIf
	MsgBox(0, "Success", "Backup successfully saved to '" & $UserBackupFileSubDIR & "'")
	;write date record file
	$DateFileHandle = FileOpen($UserBackupFileSubDIR & "Date of These Backup Files.txt", 2)
	FileWriteLine($DateFileHandle, "Address Database Internal Backup Date Record File.  This simply records the date and time on which the backup was performed.")
	FileWriteLine($DateFileHandle, @MDAY & "-" & @MON & "-" & @YEAR & " at " & @HOUR & ":" & @MIN)
	FileClose($DateFileHandle)
	
EndFunc   ;==>InternalBackup

Func InternalRestore()
	;get backup date from backup date record file
	$DateFileHandle = FileOpen($UserBackupDataFilePath & "Date of These Backup Files.txt", 0)
	If $DateFileHandle = -1 Then
		MsgBox(0, "No Backup", "No internal backups exist at '" & $UserBackupDataFilePath & "'.  Cannot Continue")
		Return
	EndIf
	$BackupDateString = FileReadLine($DateFileHandle, 2)
	FileClose($DateFileHandle)
	
	;form list of all files in backup directory
	$FileSearchHandle = FileFindFirstFile($UserBackupDataFilePath & "*.*")
	;retrieve 1st file in file list
	$FileList = (FileFindNextFile($FileSearchHandle))
	;continue to populate list
	While 1
		$NextFile = FileFindNextFile($FileSearchHandle)
		If @error Then
			ExitLoop
		EndIf
		$FileList = $FileList & @CRLF & $NextFile
	WEnd
	
	;Construct warning text
	$Text = "Do you want to restore the database data to its state at " & $BackupDateString & " ?" & @CRLF & @CRLF & "!ALL CHANGES MADE SINCE THIS TIME WILL BE LOST!" & @CRLF & @CRLF & "The following files will be restored:" & @CRLF & $FileList
	
	;Warning
	$Proceed = MsgBox(52, "Warning", $Text)
	If $Proceed = 6 Then
		;remove all files from data dir
		DirRemove($DataFilePath, 1)
		;re-create data dir
		$Success = DirCreate($DataFilePath)
		If $Success <> 1 Then
			MsgBox(0, "Error", "Cannot recreate data directory '" & $DataFilePath & "'.  This is a very serious error, and may mean no Data files remain when you re-open the database.  Manual data retrieval from '" & $UserBackupDataFilePath & "' or '" & $RuntimeBackupDataFilePath & "' will probably be required.  While this needs someone who knows what they are doing, the data should be eventually recoverable.  Please write down this error message to assist in the data recovery process.")
			Return
		EndIf
		;copy data files back from backup dir
		$Success = FileCopy($UserBackupDataFilePath & "*.*", $DataFilePath & "*.*", 1)
		If $Success <> 1 Then
			MsgBox(0, "Error", "Cannot restore data files to '" & $DataFilePath & "'.  This is a very serious error, and may mean no Data files remain when you re-open the database.  Manual data retrieval from '" & $UserBackupDataFilePath & "' or '" & $RuntimeBackupDataFilePath & "' will probably be required.  While this needs someone who knows what they are doing, the data should be eventually recoverable.  Please write down this error message to assist in the data recovery process.")
			Return
		EndIf
		;remove data record file from working dir
		FileDelete($DataFilePath & "Date of These Backup Files.txt")
		MsgBox(0, "Success", "Database restored to " & $BackupDateString)
		MsgBox(0, "Restart Required", "The Database will now exit. Please restart it again to view the restored files.")
		Exit
	EndIf
	
EndFunc   ;==>InternalRestore

Func DeleteDataFile()
	;choose Data file to Delete
	;Create list of Data files for the combo box
	$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.csv")
	
	; Quit if no Data files exist - this souldn't ever happen!
	If $FileSearchHandle = -1 Then
		MsgBox(0, "Warning", "No Data Files Currently Exist.  Cannot Continue")
		Return
	EndIf
	
	; form list of available Data files
	;retrieve 1st file in file list
	$FileList = StringTrimRight(FileFindNextFile($FileSearchHandle), 4)
	$FileListFirst = $FileList
	;continue to populate list
	While 1
		$NextFile = FileFindNextFile($FileSearchHandle)
		If @error Then
			ExitLoop
		EndIf
		$NextFile = StringTrimRight($NextFile, 4)
		$FileList = $FileList & "|" & $NextFile
	WEnd
	
	; Close the search handle
	FileClose($FileSearchHandle)
	
	; create the File Selection GUI
	GUICreate("Address Database", 300, 160, (@DesktopWidth - 300) / 2, (@DesktopHeight - 160) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$SelectDataFileComboID = GUICtrlCreateCombo("", 30, 40, 230, 250)
	$SelectDataFileLabelID = GUICtrlCreateLabel("Select Data File To Delete", 60, 15, 250, 18)
	$DeleteDataFileButtonID = GUICtrlCreateButton("Delete File", 30, 90, 100, 30)
	$CancelButtonID = GUICtrlCreateButton("Cancel", 160, 90, 100, 30)
	GUICtrlSetState($CancelButtonID, $GUI_DEFBUTTON)
	
	;load data into file list window
	GUICtrlSetData($SelectDataFileComboID, $FileList, $FileListFirst)
	
	GUISetState()
	While 1 ; process GUI events for Data file selection
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Return
				
			Case $GUImsg = $DeleteDataFileButtonID
				$ComboData = GUICtrlRead($SelectDataFileComboID)
				$Proceed = MsgBox(52, "Confirmation", $ComboData & "'s Data file will be DELETED!  Are you sure you want to do this?")
				If $Proceed = 6 Then ExitLoop
				
			Case $GUImsg = $CancelButtonID
				GUIDelete()
				MsgBox(0, "", "No changes have been made to your data")
				Return
		EndSelect
	WEnd
	
	If $VerboseMode = "on" Then
		MsgBox(0, "File Selection", "Combo Box Returned '" & $ComboData & "'")
	EndIf
	
	GUIDelete()
	
	$DeleteFileNameAndPath = $DataFilePath & $ComboData & ".csv"
	
	$Success = FileDelete($DeleteFileNameAndPath)
	If $Success = 1 Then
		MsgBox(0, "Success", "Data File " & $DeleteFileNameAndPath & " was succesfully deleted")
	Else
		MsgBox(0, "Failure", "Data File " & $DeleteFileNameAndPath & " could not be deleted.  Return code " & $Success)
	EndIf
	
EndFunc   ;==>DeleteDataFile

Func ExternalBackup()
	#cs - this was the original method of getting the save location before AutoIT brought out the fileselectfolder() function
	;input backup location
	$ExternalSaveLocation = InputBox("External Save Location", "Please enter the directory to save backup files into", StringLeft(@ScriptDir, 3) & "Address Backup", "", 450, 100)
	If $ExternalSaveLocation = "" Then Return ; quit if cancel pressed
	$Test = FileExists($ExternalSaveLocation)
	If $Test = 0 Then
		$Proceed = MsgBox(4, "Location Not Found", "The directory '" & $ExternalSaveLocation & "' does not exist.  Would you like to create it?")
		If $Proceed = 7 Then
			Return ; quit if uesr says no
		Else
			$Test = DirCreate($ExternalSaveLocation)
			If $Test = 0 Then
				Return
			Else
				MsgBox(0, "Success", "'" & $ExternalSaveLocation & "' Created Succesfully")
			EndIf
		EndIf
	EndIf
	#ce
	
	$ExternalSaveLocation = FileSelectFolder ("Please select a directory to save backup folder into","",7)
	if @error = 1 then return ; user cancelled procedure
	
	If StringRight($ExternalSaveLocation, 1) <> "\" Then $ExternalSaveLocation = $ExternalSaveLocation & "\" ; add trailling backslash if it wasn't entered
	
	;create descriptor string
	
	$ExternalBackupSubDIR = "Address Database Backup " & @MDAY & "-" & @MON & "-" & @YEAR & " at " & @HOUR & "-" & @MIN & "\"
	SplashTextOn("Address Database", "Backing Up Data... ", 300, 100, -1, -1)
	;copy all files from data dir.
	$Success = FileCopy($DataFilePath & "*.*", $ExternalSaveLocation & $ExternalBackupSubDIR & "*.*", 9)
	If $Success <> 1 Then
		MsgBox(0, "Error", "Cannot create backup at '" & $ExternalSaveLocation & $ExternalBackupSubDIR & "'.  Cannot Continue")
		Return
	EndIf
	;write date record file
	$DateFileHandle = FileOpen($ExternalSaveLocation & $ExternalBackupSubDIR & "Date of These Backup Files.txt", 2)
	FileWriteLine($DateFileHandle, "Address Database External Backup Date Record File.  This simply records the date and time on which the backup was performed.")
	FileWriteLine($DateFileHandle, @MDAY & "-" & @MON & "-" & @YEAR & " at " & @HOUR & ":" & @MIN)
	FileClose($DateFileHandle)
	SplashOff()
	MsgBox(0, "Success", "Backup successfully saved to '" & $ExternalSaveLocation & $ExternalBackupSubDIR & "'")
EndFunc   ;==>ExternalBackup

Func ExternalRestore()
	#cs - original method of locating external backups before AutoIT brought out th fileselectfolder() function
	;find external backup location
	$ExternalSaveLocationRaw = FileOpenDialog("Please Select First Data File in Backup to Restore From", StringLeft(@ScriptDir, 3) & "Address Database Backup", "Data Files (*.csv)", 1)
	If @error = 1 Then Return
	;remove filename from the end of the string
	$ExternalBackupPathArray = StringSplit($ExternalSaveLocationRaw, "\") ; split up full filename into parts
	$ExternalSaveLocation = $ExternalBackupPathArray[1] & "\" ; reinstane first part
	If $ExternalBackupPathArray[0] > 2 Then
		For $Counter = 2 To $ExternalBackupPathArray[0] - 1 ; add other parts if required
			$ExternalSaveLocation = $ExternalSaveLocation & $ExternalBackupPathArray[$Counter] & "\"
		Next
	EndIf
	#ce
	
	$ExternalSaveLocation = FileSelectFolder ("Please select the directory containing the backup files to restore from","",7)
	if @error = 1 then return ; user cancelled procedure
	
	If StringRight($ExternalSaveLocation, 1) <> "\" Then $ExternalSaveLocation = $ExternalSaveLocation & "\" ; add trailling backslash if it wasn't entered
	
	If $VerboseMode = "on" Then
		MsgBox(0, "External backup location path", $ExternalSaveLocation)
	EndIf
	
	;get backup date from backup date record file
	$DateFileHandle = FileOpen($ExternalSaveLocation & "Date of These Backup Files.txt", 0)
	If $DateFileHandle = -1 Then
		$BackupDateString = "the time this backup was made"
	Else
		$BackupDateString = FileReadLine($DateFileHandle, 2)
	EndIf
	FileClose($DateFileHandle)
	
	;form list of all files in backup directory
	$FileSearchHandle = FileFindFirstFile($ExternalSaveLocation & "*.*")
	;retrieve 1st file in file list
	$FileList = (FileFindNextFile($FileSearchHandle))
	;continue to populate list
	While 1
		$NextFile = FileFindNextFile($FileSearchHandle)
		If @error Then
			ExitLoop
		EndIf
		$FileList = $FileList & @CRLF & $NextFile
	WEnd
	
	;Construct warning text
	$Text = "Do you want to restore the database data to its state at " & $BackupDateString & " ?" & @CRLF & @CRLF & "!ALL CHANGES MADE SINCE THIS TIME WILL BE LOST!" & @CRLF & @CRLF & "The following files will be restored:" & @CRLF & $FileList
	
	;Warning **********************
	$Proceed = MsgBox(52, "Warning", $Text)
	If $Proceed = 6 Then
		;remove all files from data dir
		DirRemove($DataFilePath, 1)
		;re-create data dir
		$Success = DirCreate($DataFilePath)
		If $Success <> 1 Then
			MsgBox(0, "Error", "Cannot recreate data directory '" & $DataFilePath & "'.  This is a very serious error, and may mean no Data files remain when you re-open the database.  Manual data retrieval from '" & $UserBackupDataFilePath & "' or '" & $RuntimeBackupDataFilePath & "' will probably be required.  While this needs someone who knows what they are doing, the data should be eventually recoverable.  Please write down this error message to assist in the data recovery process.")
			Return
		EndIf
		SplashTextOn("Address Database", "Restoring Data... ", 300, 100, -1, -1)
		;copy data files back from backup dir
		$Success = FileCopy($ExternalSaveLocation & "*.*", $DataFilePath & "*.*", 1)
		If $Success <> 1 Then
			SplashOff()
			MsgBox(0, "Error", "Cannot restore data files to '" & $DataFilePath & "'.  This is a very serious error, and may mean no Data files remain when you re-open the database.  Manual data retrieval from '" & $UserBackupDataFilePath & "' or '" & $RuntimeBackupDataFilePath & "' will probably be required.  While this needs someone who knows what they are doing, the data should be eventually recoverable.  Please write down this error message to assist in the data recovery process.")
			Return
		EndIf
		;remove data record file from working dir
		FileDelete($DataFilePath & "Date of These Backup Files.txt")
		SplashOff()
		MsgBox(0, "Success", "Database restored to " & $BackupDateString)
		MsgBox(0, "Restart Required", "The Database will now exit. Please restart it again to view the restored files.")
		Exit
	EndIf
EndFunc   ;==>ExternalRestore

Func DesktopExport()
	$Success = FileCopy($DataFileNameAndPath, @DesktopDir & "\*.*", 1)
	If $Success = 1 Then
		MsgBox(0, "Success", "Data File '" & $DataFileName & "' saved to desktop.  This file can be sent as an e-mail attachment if desired.")
	Else
		MsgBox(0, "Failure", "Unable to export to '" & @DesktopDir & "'. Cannot save to desktop")
	EndIf
	
EndFunc   ;==>DesktopExport

Func DesktopImport()
	
	;$Success  = filecopy ($DataFileNameAndPath,@DesktopDir & "\*.*",1)
	;if $Success = 1 Then
	;	MsgBox(0,"Success","Data File '"&$DataFileName&"' saved to desktop.  This file can be sent as an e-mail attachment if desired.")
	;Else
	;	MsgBox(0,"Failure","Unable to export to '"&@DesktopDir&"'. Cannot save to desktop")
	;EndIf
	
	
	;Create list of Data files on the desktop
	$FileSearchHandle = FileFindFirstFile(@DesktopDir & "\*.csv")
	
	; Warn & Exit if no Data files exist
	If $FileSearchHandle = -1 Then
		MsgBox(0, "Warning", "No Data Files Currently Exist On the Desktop at '" & @DesktopDir & "'.  Cannot continue")
		Return
	Else ; form list of available Data files
		;retrieve 1st file in file list
		$FileList = StringTrimRight(FileFindNextFile($FileSearchHandle), 4)
		$FileListFirst = $FileList
		;continue to populate list
		While 1
			$NextFile = FileFindNextFile($FileSearchHandle)
			If @error Then
				ExitLoop
			EndIf
			$NextFile = StringTrimRight($NextFile, 4)
			$FileList = $FileList & "|" & $NextFile
		WEnd
	EndIf
	
	; Close the search handle
	FileClose($FileSearchHandle)
	
	; create the File Selection GUI
	GUICreate("Address Database", 300, 170, (@DesktopWidth - 300) / 2, (@DesktopHeight - 170) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	$SelectDataFileComboID = GUICtrlCreateCombo("", 30, 60, 230, 250)
	$SelectDataFileLabelID = GUICtrlCreateLabel("Please Select Data File To Import", 60, 15, 250, 18)
	$OpenDataFileButtonID = GUICtrlCreateButton("Import File", 30, 110, 100, 30)
	$CancelButtonID = GUICtrlCreateButton("Cancel", 160, 110, 100, 30)
	GUICtrlSetState($OpenDataFileButtonID, $GUI_DEFBUTTON)
	
	;load data into file list window
	GUICtrlSetData($SelectDataFileComboID, $FileList, $FileListFirst)
	
	GUISetState()
	While 1 ; process GUI events for Data file selection
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				GUIDelete()
				Return
			Case $GUImsg = $OpenDataFileButtonID
				$ComboData = GUICtrlRead($SelectDataFileComboID)
				$CheckforFile = FileExists($DataFilePath & $ComboData & ".csv")
				If $CheckforFile = 1 Then
					$Proceed = MsgBox(20, "Confirm Overwrite", "WARNING!  Data file '" & $ComboData & ".csv' already exists in the database.  Are you sure you want to overwrite the existing Data file with the one from the desktop?")
					If $Proceed = 6 Then
						$Success = FileMove(@DesktopDir & "\" & $ComboData & ".csv", $DataFilePath & $ComboData & ".csv", 1)
						If $Success = 1 Then
							MsgBox(0, "Success", "Data file for " & $ComboData & " successfully imported.")
							MsgBox(0, "Database Restart", "The Database will now close.  Please re-open it to access the newly imported file")
							Exit
						Else
							MsgBox(0, "Failure", "Unable to import file '" & @DesktopDir & $ComboData & ".csv'.")
						EndIf
					EndIf
				Else
					$Success = FileMove(@DesktopDir & "\" & $ComboData & ".csv", $DataFilePath & $ComboData & ".csv", 1)
					If $Success = 1 Then
						MsgBox(0, "Success", "Data file for " & $ComboData & " successfully imported.")
						MsgBox(0, "Database Restart", "The Database will now close.  Please re-open it to access the newly imported file")
						Exit
					Else
						MsgBox(0, "Failure", "Unable to import file '" & @DesktopDir & "\" & $ComboData & ".csv'.")
					EndIf
				EndIf
				
			Case $GUImsg = $CancelButtonID
				GUIDelete()
				Return
		EndSelect
	WEnd
	GUIDelete()
EndFunc   ;==>DesktopImport

Func MultipleDataPrint()
	;re-format main GUI
	GUICtrlDelete($FileCommentLableID) ;  = GUICtrlCreateLabel("File Comment", 10, 14, 70, 15, $SS_right)
	GUICtrlDelete($FileCommentInputID) ; = GUICtrlCreateInput("Comment Input Field", 85, 10, 375, 20, $SS_center)
	GUICtrlDelete($SearchButtonID) ; = GUICtrlCreateButton("Search for Surname", 50, 38, 190, 25)
	GUICtrlDelete($SearchInputID) ;  = GUICtrlCreateInput("Enter Start of Surname...", 245, 40, 215, 20)
	GUICtrlDelete($ListofMembersListID); = GUICtrlCreateList("Clickable List", 20, 70, 440, 450)
	GUICtrlDelete($SortButtonID) ; = GUICtrlCreateButton("Sort Member List", 50, 512, 150, 30)
	GUICtrlDelete($MemberNumberRadioID) ;  = GUICtrlCreateRadio("By Member Number", 225, 515, 110, 25)
	GUICtrlDelete($SurnameRadioID) ;  = GUICtrlCreateRadio("By Surname", 355, 515, 80, 25)
	GUICtrlDelete($RadioGroup) ;  = GUICtrlCreateGroup("", 215, 505, 235, 40)
	;Button List at right
	GUICtrlDelete($AddNewMemberButtonID) ;  = GUICtrlCreateButton("Add New Member", 520, 140, 150, 30)
	GUICtrlDelete($EditSelectedMemberButtonID) ;  = GUICtrlCreateButton("Edit Member", 520, 180, 150, 30)
	GUICtrlDelete($DeleteSelectedMemberButtonID) ;  = GUICtrlCreateButton("Delete Member", 520, 220, 150, 30)
	GUICtrlDelete($SaveButtonID) ;  = GUICtrlCreateButton("Save", 520, 280, 150, 30)
	GUICtrlDelete($PrintThisDataButtonID) ;  = GUICtrlCreateButton("Print Mailing Lables", 520, 340, 150, 30)
	GUICtrlDelete($PrintMultipleDataFilesButtonID)
	GUICtrlDelete($AdvancedFeaturesButtonID) ;  = GUICtrlCreateButton("Advanced Features", 520, 410, 150, 30)
	GUICtrlDelete($QuitButtonID) ;  = GUICtrlCreateButton("Quit", 520, 480, 150, 30)
	GUICtrlDelete($MainGUIHelpButtonID)
	GUICtrlDelete($ChangeDataButtonID)
	
	;pretty GUI method of selecting Data files
	
	;add buttons to GUI
	$SelectAllDataFilesButtonID = GUICtrlCreateButton("Select All", 40, 35, 120, 30)
	$PrintSelectedDataFilesButtonID = GUICtrlCreateButton("Print Selected DataFiles", 195, 35, 140, 30)
	$ExitButtonID = GUICtrlCreateButton("Exit", 370, 35, 120, 30)
	
	;Create list of Data files for the combo box
	$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.csv")
	;retrieve 1st file in file list
	$FileSearchName = FileFindNextFile($FileSearchHandle)
	;get file size (used to count records later)
	$SearchFileSize = FileGetSize($DataFilePath & $FileSearchName)
	;open data file
	$FileSearchNameHandle = FileOpen($DataFilePath & $FileSearchName, 0)
	;count lines in file
	$NumberOfSearchFileLines = CountDataFileLines($FileSearchNameHandle, $SearchFileSize)
	;close file
	FileClose($FileSearchNameHandle)
	;convert to number of records (ie subtract the header lines) & ad to descriptor
	$FileList = StringTrimRight($FileSearchName, 4) & "   (" & $NumberOfSearchFileLines - 12 & " members)"
	$FileListFirst = $FileList
	;continue to populate list
	While 1
		$NextFile = FileFindNextFile($FileSearchHandle)
		If @error Then
			ExitLoop
		EndIf
		$FileSearchName = $NextFile
		;get file size (used to count records later)
		$SearchFileSize = FileGetSize($DataFilePath & $FileSearchName)
		;open data file
		$FileSearchNameHandle = FileOpen($DataFilePath & $FileSearchName, 0)
		;count lines in file
		$NumberOfSearchFileLines = CountDataFileLines($FileSearchNameHandle, $SearchFileSize)
		;close file
		FileClose($FileSearchNameHandle)
		;convert to number of records (ie subtract the header lines) & ad to descriptor
		$NextFile = StringTrimRight($FileSearchName, 4) & "   (" & $NumberOfSearchFileLines - 12 & " members)"
		$FileList = $FileList & "|" & $NextFile
	WEnd
	
	; Close the search handle
	FileClose($FileSearchHandle)
	;create list of Data file descriptors from above search string
	$DataFilesListArray = StringSplit($FileList, "|")
	$NumberofDataFiles = $DataFilesListArray[0]
	;copy the descriptors to a 2D array that will also hold the checkbox ID's
	Dim $DataFileandControlIDArray[$NumberofDataFiles + 1][2]
	For $Counter = 1 To $NumberofDataFiles
		$DataFileandControlIDArray[$Counter][0] = $DataFilesListArray[$Counter]
	Next
	;sort the array to get the DataFiles in alaphabetical order
	_ArraySort($DataFileandControlIDArray, 0, 1, 0, 2, 0)
	;warn if greater than 65 DataFiles
	If $NumberofDataFiles > 65 Then
		MsgBox(0, "Error", "Number of Data files is greater than 65.  Only the first 65 will be displayed.  If you need more than 65 DataFiles, let me know and I'll re-code this section.")
		$NumberofDataFiles = 65
	EndIf
	;create boxes in GUI
	$Counter = 1 ; initialise counter
	$Row = 100 ; hight to top of 1st row
	$Column = 10 ; left margin of leftmost column
	While $Counter < $NumberofDataFiles + 1
		$DataFileandControlIDArray[$Counter][1] = GUICtrlCreateCheckbox($DataFileandControlIDArray[$Counter][0], $Column, $Row, 200, 15)
		#cs - this was the old 'paint by row' procedure
			$Column = $Column + 220
			if $Column > 450 Then
			$Column = 10
			$Row = $Row + 20
			EndIf
		#ce
		;paint the checkboxes by column
		$Row = $Row + 20
		If $Row > 520 Then
			$Row = 100
			$Column = $Column + 220
		EndIf
		$Counter = $Counter + 1
	WEnd
	
	While 1 ; process GUI events for Data file selection
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Exit
				
			Case $GUImsg = $PrintSelectedDataFilesButtonID
				$SelectedFilesString = ""
				For $Counter = 1 To $NumberofDataFiles
					If GUICtrlRead($DataFileandControlIDArray[$Counter][1]) = $GUI_CHECKED Then
						$SelectedFilesString = $SelectedFilesString & "|" & $DataFileandControlIDArray[$Counter][0]
					EndIf
				Next
				$SelectedFilesArray = StringSplit($SelectedFilesString, "|") ; 1st element will be dud due to leading comma in filesstring
				If $SelectedFilesArray[0] > 2 Then
					;The guts of the multiple file print operation!!!!!!
					$NumberofFilesSelected = $SelectedFilesArray[0] - 1
					;read in first file
					#region
					;set data file name and path
					$FileNameWithTrailingSpaces = StringSplit($SelectedFilesArray[2], "(")
					$DataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".csv"
					$DataFileNameAndPath = $DataFilePath & $DataFileName
					$RuntimeBackupDataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".bak"
					$RuntimeBackupDataFileNameAndPath = $RuntimeBackupDataFilePath & $RuntimeBackupDataFileName
					
					;back up data file
					FileCopy($DataFileNameAndPath, $RuntimeBackupDataFileNameAndPath, 9)
					
					;get file size (used to read file)
					$DataFileSize = FileGetSize($DataFileNameAndPath)
					;open data file
					$DataFileHandle = FileOpen($DataFileNameAndPath, 0)
					;read in data file
					$EntireDataFileasOneString = FileRead($DataFileHandle, $DataFileSize)
					;split datafile into temp array of lines
					$DataFileLineArraytemp = StringSplit($EntireDataFileasOneString, @CRLF, 1)
					
					;test if a final CRLF was present in the data file.  If so, a 'blank' last string is returned into the array which must be ignored.  (A final CRLF is 'normal' for files saved by 'filewriteline')
					$LinesinTempArray = $DataFileLineArraytemp[0]
					If StringLen($DataFileLineArraytemp[$LinesinTempArray]) < 10 Then
						$NumberOfDataFileLines = $LinesinTempArray - 1
					Else
						$NumberOfDataFileLines = $LinesinTempArray
					EndIf
					
					;extract descriptors of data file
					$DescriptorRawString = $DataFileLineArraytemp[$DescriptorLineNumber] ; read the descriptor line
					$FileDescriptors = StringSplit($DescriptorRawString, ",") ; split descriptors up into $FileDescriptors array
					$DataFileLineNumberOfFirstRecord = $FileDescriptors[1] ; all lines preceeding this are taken as comment lines, and are read into the comment array
					$DataFileLineNumberOfDisplayableFileComment = $FileDescriptors[2]
					$NumberOfFields = $FileDescriptors[3]
					$SortField = $FileDescriptors[4]
					$NumberOfRecords = $NumberOfDataFileLines - ($DataFileLineNumberOfFirstRecord - 1)
					
					;display data file stats
					If $VerboseMode = "on" Then
						MsgBox(0, $DataFileNameAndPath, "Above Data File Found. " & $NumberOfDataFileLines & " total lines in file, " & $DataFileLineNumberOfFirstRecord - 1 & " comment lines, " & $NumberOfRecords & " record lines")
					EndIf
					
					;dim data arrays
					$DataArrayHeight = $NumberOfRecords + 1
					$DataArrayWidth = $NumberOfFields + 1
					Dim $DataArray [$DataArrayHeight][$DataArrayWidth] ; used to store the data.  the "+ 1" is used so array element [0] does not have to be used and the array numbers will match the field numbers and record numbers width[0] is used to store the Data filename of the record.  This is mainly used when producing a multi-Data truncation report
					Dim $HeaderArray [$DataFileLineNumberOfFirstRecord]; used to store the file header information. element [0] is not used
					
					;read header information into header array
					$LinesRead = ReadHeaderIntoArray()
					
					;display successful read
					If $VerboseMode = "on" Then
						MsgBox(0, "Header Data Read Done", $LinesRead & " Lines successfully read into the Header Array.  File Comment is '" & $HeaderArray[$DataFileLineNumberOfDisplayableFileComment] & "'.")
					EndIf
					
					;read data into data array
					$RecordsRead = ReadDataIntoArray()
					
					;close data file
					FileClose($DataFileHandle)
					
					$AccumulationReportText = $RecordsRead & " members for " & StringTrimRight($DataFileName, 4) & " added"
					$AccumulationReportTotalRecords = $RecordsRead
					#endregion
					
					;redim array and read in subsequent files
					#region
					For $Filereadcounter = 3 To $NumberofFilesSelected + 1 ; the + 1 is there because the array element numbers are offset by 1 from the file numbers
						;set data file name and path
						$FileNameWithTrailingSpaces = StringSplit($SelectedFilesArray[$Filereadcounter], "(")
						$DataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".csv"
						$DataFileNameAndPath = $DataFilePath & $DataFileName
						$RuntimeBackupDataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".bak"
						$RuntimeBackupDataFileNameAndPath = $RuntimeBackupDataFilePath & $RuntimeBackupDataFileName
						
						;back up data file
						FileCopy($DataFileNameAndPath, $RuntimeBackupDataFileNameAndPath, 9)
						
						;get file size (used to read file)
						$DataFileSize = FileGetSize($DataFileNameAndPath)
						;open data file
						$DataFileHandle = FileOpen($DataFileNameAndPath, 0)
						;read in data file
						$EntireDataFileasOneString = FileRead($DataFileHandle, $DataFileSize)
						;split datafile into temp array of lines
						$DataFileLineArraytemp = StringSplit($EntireDataFileasOneString, @CRLF, 1)
						
						;test if a final CRLF was present in the data file.  If so, a 'blank' last string is returned into the array which must be ignored.  (A final CRLF is 'normal' for files saved by 'filewriteline')
						$LinesinTempArray = $DataFileLineArraytemp[0]
						If StringLen($DataFileLineArraytemp[$LinesinTempArray]) < 10 Then
							$NumberOfDataFileLines = $LinesinTempArray - 1
						Else
							$NumberOfDataFileLines = $LinesinTempArray
						EndIf
						
						;extract descriptors of data file
						$DescriptorRawString = $DataFileLineArraytemp[$DescriptorLineNumber] ; read the descriptor line
						$FileDescriptors = StringSplit($DescriptorRawString, ",") ; split descriptors up into $FileDescriptors array
						$DataFileLineNumberOfFirstRecord = $FileDescriptors[1] ; all lines preceeding this are taken as comment lines, and are read into the comment array
						$DataFileLineNumberOfDisplayableFileComment = $FileDescriptors[2]
						$NumberOfFields = $FileDescriptors[3]
						$SortField = $FileDescriptors[4]
						
						;extract descriptors of data file
						$NumberOfRecordsinSubsequentFile = $NumberOfDataFileLines - ($DataFileLineNumberOfFirstRecord - 1)
						$NumberOfRecords = $NumberOfRecords + $NumberOfRecordsinSubsequentFile
						
						;display data file stats
						If $VerboseMode = "on" Then
							MsgBox(0, $DataFileNameAndPath, "Above Data File Found. " & $NumberOfDataFileLines & " total lines in file, " & $DataFileLineNumberOfFirstRecord - 1 & " comment lines, " & $NumberOfRecordsinSubsequentFile & " record lines")
						EndIf
						
						;dim data arrays
						$OldDataArrayHeight = $DataArrayHeight
						$DataArrayHeight = $DataArrayHeight + $NumberOfRecordsinSubsequentFile
						ReDim $DataArray [$DataArrayHeight][$DataArrayWidth] ; preserve existing array & add further lines used to store the subsequent data.
						Dim $HeaderArray [$DataFileLineNumberOfFirstRecord]; used to store the file header information. element [0] is not used
						
						;read header information into header array
						$LinesRead = ReadHeaderIntoArray()
						
						;display successful read
						If $VerboseMode = "on" Then
							MsgBox(0, "Header Data Read Done", $LinesRead & " Lines successfully read into the Header Array.  File Comment is '" & $HeaderArray[$DataFileLineNumberOfDisplayableFileComment] & "'.")
						EndIf
						
						;read data into data array
						$RecordsRead = AddSubsequentDataIntoArray()
						
						;close data file
						FileClose($DataFileHandle)
						
						$AccumulationReportText = $AccumulationReportText & @CRLF & $RecordsRead & " members for " & StringTrimRight($DataFileName, 4) & " added"
						$AccumulationReportTotalRecords = $AccumulationReportTotalRecords + $RecordsRead
						
					Next
					#endregion
					
					;all data files are now read into data array!
					
					;display report
					$AccumulationReportText = $AccumulationReportText & @CRLF & @CRLF & $AccumulationReportTotalRecords & " member lables now ready to print"
					MsgBox(0, "Preparation Complete", $AccumulationReportText)
					
					;call printing functions
					
					CreateLableOutputFiles() ; this then calls the print engine
					
				Else
					MsgBox(0, "Error", "You must choose at least 2 DataFiles")
				EndIf
				
			Case $GUImsg = $SelectAllDataFilesButtonID
				If GUICtrlRead($SelectAllDataFilesButtonID) = "Select All" Then
					For $Counter = 1 To $NumberofDataFiles
						GUICtrlSetState($DataFileandControlIDArray[$Counter][1], $GUI_CHECKED)
					Next
					GUICtrlSetData($SelectAllDataFilesButtonID, "Unselect All")
				Else
					For $Counter = 1 To $NumberofDataFiles
						GUICtrlSetState($DataFileandControlIDArray[$Counter][1], $GUI_UNCHECKED)
					Next
					GUICtrlSetData($SelectAllDataFilesButtonID, "Select All")
				EndIf
				
			Case $GUImsg = $ExitButtonID
				Exit
		EndSelect
	WEnd
	
EndFunc   ;==>MultipleDataPrint

Func MultipleDataSearch()
	;re-format main GUI
	GUICtrlDelete($FileCommentLableID) ;  = GUICtrlCreateLabel("File Comment", 10, 14, 70, 15, $SS_right)
	GUICtrlDelete($FileCommentInputID) ; = GUICtrlCreateInput("Comment Input Field", 85, 10, 375, 20, $SS_center)
	GUICtrlDelete($SearchButtonID) ; = GUICtrlCreateButton("Search for Surname", 50, 38, 190, 25)
	GUICtrlDelete($SearchInputID) ;  = GUICtrlCreateInput("Enter Start of Surname...", 245, 40, 215, 20)
	GUICtrlDelete($ListofMembersListID); = GUICtrlCreateList("Clickable List", 20, 70, 440, 450)
	GUICtrlDelete($SortButtonID) ; = GUICtrlCreateButton("Sort Member List", 50, 512, 150, 30)
	GUICtrlDelete($MemberNumberRadioID) ;  = GUICtrlCreateRadio("By Member Number", 225, 515, 110, 25)
	GUICtrlDelete($SurnameRadioID) ;  = GUICtrlCreateRadio("By Surname", 355, 515, 80, 25)
	GUICtrlDelete($RadioGroup) ;  = GUICtrlCreateGroup("", 215, 505, 235, 40)
	;Button List at right
	GUICtrlDelete($AddNewMemberButtonID) ;  = GUICtrlCreateButton("Add New Member", 520, 140, 150, 30)
	GUICtrlDelete($EditSelectedMemberButtonID) ;  = GUICtrlCreateButton("Edit Member", 520, 180, 150, 30)
	GUICtrlDelete($DeleteSelectedMemberButtonID) ;  = GUICtrlCreateButton("Delete Member", 520, 220, 150, 30)
	GUICtrlDelete($SaveButtonID) ;  = GUICtrlCreateButton("Save", 520, 280, 150, 30)
	GUICtrlDelete($PrintThisDataButtonID) ;  = GUICtrlCreateButton("Print Mailing Lables", 520, 340, 150, 30)
	GUICtrlDelete($PrintMultipleDataFilesButtonID)
	GUICtrlDelete($AdvancedFeaturesButtonID) ;  = GUICtrlCreateButton("Advanced Features", 520, 410, 150, 30)
	GUICtrlDelete($QuitButtonID) ;  = GUICtrlCreateButton("Quit", 520, 480, 150, 30)
	GUICtrlDelete($MainGUIHelpButtonID)
	GUICtrlDelete($ChangeDataButtonID)
	
	;add buttons to GUI
	$SelectAllDataFilesButtonID = GUICtrlCreateButton("Select All", 40, 35, 120, 30)
	$SearchSelectedDataFilesButtonID = GUICtrlCreateButton("Search Selected DataFiles", 195, 35, 140, 30)
	$ExitButtonID = GUICtrlCreateButton("Exit", 370, 35, 120, 30)
	
	;Create list of Data files for the combo box
	$FileSearchHandle = FileFindFirstFile($DataFilePath & "*.csv")
	;retrieve 1st file in file list
	$FileSearchName = FileFindNextFile($FileSearchHandle)
	;get file size (used to count records later)
	$SearchFileSize = FileGetSize($DataFilePath & $FileSearchName)
	;open data file
	$FileSearchNameHandle = FileOpen($DataFilePath & $FileSearchName, 0)
	;count lines in file
	$NumberOfSearchFileLines = CountDataFileLines($FileSearchNameHandle, $SearchFileSize)
	;close file
	FileClose($FileSearchNameHandle)
	;convert to number of records (ie subtract the header lines) & ad to descriptor
	$FileList = StringTrimRight($FileSearchName, 4) & "   (" & $NumberOfSearchFileLines - 12 & " members)"
	$FileListFirst = $FileList
	;continue to populate list
	While 1
		$NextFile = FileFindNextFile($FileSearchHandle)
		If @error Then
			ExitLoop
		EndIf
		$FileSearchName = $NextFile
		;get file size (used to count records later)
		$SearchFileSize = FileGetSize($DataFilePath & $FileSearchName)
		;open data file
		$FileSearchNameHandle = FileOpen($DataFilePath & $FileSearchName, 0)
		;count lines in file
		$NumberOfSearchFileLines = CountDataFileLines($FileSearchNameHandle, $SearchFileSize)
		;close file
		FileClose($FileSearchNameHandle)
		;convert to number of records (ie subtract the header lines) & ad to descriptor
		$NextFile = StringTrimRight($FileSearchName, 4) & "   (" & $NumberOfSearchFileLines - 12 & " members)"
		$FileList = $FileList & "|" & $NextFile
	WEnd
	
	; Close the search handle
	FileClose($FileSearchHandle)
	;create list of Data file descriptors from above search string
	$DataFilesListArray = StringSplit($FileList, "|")
	$NumberofDataFiles = $DataFilesListArray[0]
	;copy the descriptors to a 2D array that will also hold the checkbox ID's
	Dim $DataFileandControlIDArray[$NumberofDataFiles + 1][2]
	For $Counter = 1 To $NumberofDataFiles
		$DataFileandControlIDArray[$Counter][0] = $DataFilesListArray[$Counter]
	Next
	;sort the array to get the DataFiles in alaphabetical order
	_ArraySort($DataFileandControlIDArray, 0, 1, 0, 2, 0)
	;warn if greater than 65 DataFiles
	If $NumberofDataFiles > 65 Then
		MsgBox(0, "Error", "Number of Data files is greater than 65.  Only the first 65 will be displayed.  If you need more than 65 DataFiles, let me know and I'll re-code this section.")
		$NumberofDataFiles = 65
	EndIf
	;create boxes in GUI
	$Counter = 1 ; initialise counter
	$Row = 100 ; hight to top of 1st row
	$Column = 10 ; left margin of leftmost column
	While $Counter < $NumberofDataFiles + 1
		$DataFileandControlIDArray[$Counter][1] = GUICtrlCreateCheckbox($DataFileandControlIDArray[$Counter][0], $Column, $Row, 200, 15)
		;paint the checkboxes by column
		$Row = $Row + 20
		If $Row > 520 Then
			$Row = 100
			$Column = $Column + 220
		EndIf
		$Counter = $Counter + 1
	WEnd
	
	While 1 ; process GUI events for Data file selection
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Exit
				
			Case $GUImsg = $ExitButtonID
				Exit
				
			Case $GUImsg = $SearchSelectedDataFilesButtonID
				ExitLoop
				
			Case $GUImsg = $SelectAllDataFilesButtonID
				If GUICtrlRead($SelectAllDataFilesButtonID) = "Select All" Then
					For $Counter = 1 To $NumberofDataFiles
						GUICtrlSetState($DataFileandControlIDArray[$Counter][1], $GUI_CHECKED)
					Next
					GUICtrlSetData($SelectAllDataFilesButtonID, "Unselect All")
				Else
					For $Counter = 1 To $NumberofDataFiles
						GUICtrlSetState($DataFileandControlIDArray[$Counter][1], $GUI_UNCHECKED)
					Next
					GUICtrlSetData($SelectAllDataFilesButtonID, "Select All")
				EndIf
				
		EndSelect
	WEnd
	;retrieve info on selected DataFiles
	$SelectedFilesString = ""
	For $Counter = 1 To $NumberofDataFiles
		If GUICtrlRead($DataFileandControlIDArray[$Counter][1]) = $GUI_CHECKED Then
			$SelectedFilesString = $SelectedFilesString & "|" & $DataFileandControlIDArray[$Counter][0]
		EndIf
	Next
	$SelectedFilesArray = StringSplit($SelectedFilesString, "|") ; 1st element will be dud due to leading comma in filesstring
	If $SelectedFilesArray[0] > 2 Then
		;
		$NumberofFilesSelected = $SelectedFilesArray[0] - 1
		;read in first file
		#region
		;set data file name and path
		$FileNameWithTrailingSpaces = StringSplit($SelectedFilesArray[2], "(")
		$DataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".csv"
		$DataFileNameAndPath = $DataFilePath & $DataFileName
		$RuntimeBackupDataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".bak"
		$RuntimeBackupDataFileNameAndPath = $RuntimeBackupDataFilePath & $RuntimeBackupDataFileName
		
		;back up data file
		FileCopy($DataFileNameAndPath, $RuntimeBackupDataFileNameAndPath, 9)
		
		;get file size (used to read file)
		$DataFileSize = FileGetSize($DataFileNameAndPath)
		;open data file
		$DataFileHandle = FileOpen($DataFileNameAndPath, 0)
		;read in data file
		$EntireDataFileasOneString = FileRead($DataFileHandle, $DataFileSize)
		;split datafile into temp array of lines
		$DataFileLineArraytemp = StringSplit($EntireDataFileasOneString, @CRLF, 1)
		
		;test if a final CRLF was present in the data file.  If so, a 'blank' last string is returned into the array which must be ignored.  (A final CRLF is 'normal' for files saved by 'filewriteline')
		$LinesinTempArray = $DataFileLineArraytemp[0]
		If StringLen($DataFileLineArraytemp[$LinesinTempArray]) < 10 Then
			$NumberOfDataFileLines = $LinesinTempArray - 1
		Else
			$NumberOfDataFileLines = $LinesinTempArray
		EndIf
		
		;extract descriptors of data file
		$DescriptorRawString = $DataFileLineArraytemp[$DescriptorLineNumber] ; read the descriptor line
		$FileDescriptors = StringSplit($DescriptorRawString, ",") ; split descriptors up into $FileDescriptors array
		$DataFileLineNumberOfFirstRecord = $FileDescriptors[1] ; all lines preceeding this are taken as comment lines, and are read into the comment array
		$DataFileLineNumberOfDisplayableFileComment = $FileDescriptors[2]
		$NumberOfFields = $FileDescriptors[3]
		$SortField = $FileDescriptors[4]
		$NumberOfRecords = $NumberOfDataFileLines - ($DataFileLineNumberOfFirstRecord - 1)
		
		;display data file stats
		If $VerboseMode = "on" Then
			MsgBox(0, $DataFileNameAndPath, "Above Data File Found. " & $NumberOfDataFileLines & " total lines in file, " & $DataFileLineNumberOfFirstRecord - 1 & " comment lines, " & $NumberOfRecords & " record lines")
		EndIf
		
		;dim data arrays
		$DataArrayHeight = $NumberOfRecords + 1
		$DataArrayWidth = $NumberOfFields + 1
		Dim $DataArray [$DataArrayHeight][$DataArrayWidth] ; used to store the data.  the "+ 1" is used so array element [0] does not have to be used and the array numbers will match the field numbers and record numbers width[0] is used to store the Data filename of the record.  This is mainly used when producing a multi-Data truncation report
		Dim $HeaderArray [$DataFileLineNumberOfFirstRecord]; used to store the file header information. element [0] is not used
		
		;read header information into header array
		$LinesRead = ReadHeaderIntoArray()
		
		;display successful read
		If $VerboseMode = "on" Then
			MsgBox(0, "Header Data Read Done", $LinesRead & " Lines successfully read into the Header Array.  File Comment is '" & $HeaderArray[$DataFileLineNumberOfDisplayableFileComment] & "'.")
		EndIf
		
		;read data into data array
		$RecordsRead = ReadDataIntoArray()
		
		;close data file
		FileClose($DataFileHandle)
		
		$AccumulationReportText = $RecordsRead & " members for " & StringTrimRight($DataFileName, 4) & " added"
		$AccumulationReportTotalRecords = $RecordsRead
		#endregion
		
		;redim array and read in subsequent files
		#region
		For $Filereadcounter = 3 To $NumberofFilesSelected + 1 ; the + 1 is there because the array element numbers are offset by 1 from the file numbers
			;set data file name and path
			$FileNameWithTrailingSpaces = StringSplit($SelectedFilesArray[$Filereadcounter], "(")
			$DataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".csv"
			$DataFileNameAndPath = $DataFilePath & $DataFileName
			$RuntimeBackupDataFileName = StringTrimRight($FileNameWithTrailingSpaces[1], 3) & ".bak"
			$RuntimeBackupDataFileNameAndPath = $RuntimeBackupDataFilePath & $RuntimeBackupDataFileName
			
			;back up data file
			FileCopy($DataFileNameAndPath, $RuntimeBackupDataFileNameAndPath, 9)
			
			;get file size (used to read file)
			$DataFileSize = FileGetSize($DataFileNameAndPath)
			;open data file
			$DataFileHandle = FileOpen($DataFileNameAndPath, 0)
			;read in data file
			$EntireDataFileasOneString = FileRead($DataFileHandle, $DataFileSize)
			;split datafile into temp array of lines
			$DataFileLineArraytemp = StringSplit($EntireDataFileasOneString, @CRLF, 1)
			
			;test if a final CRLF was present in the data file.  If so, a 'blank' last string is returned into the array which must be ignored.  (A final CRLF is 'normal' for files saved by 'filewriteline')
			$LinesinTempArray = $DataFileLineArraytemp[0]
			If StringLen($DataFileLineArraytemp[$LinesinTempArray]) < 10 Then
				$NumberOfDataFileLines = $LinesinTempArray - 1
			Else
				$NumberOfDataFileLines = $LinesinTempArray
			EndIf
			
			;extract descriptors of data file
			$DescriptorRawString = $DataFileLineArraytemp[$DescriptorLineNumber] ; read the descriptor line
			$FileDescriptors = StringSplit($DescriptorRawString, ",") ; split descriptors up into $FileDescriptors array
			$DataFileLineNumberOfFirstRecord = $FileDescriptors[1] ; all lines preceeding this are taken as comment lines, and are read into the comment array
			$DataFileLineNumberOfDisplayableFileComment = $FileDescriptors[2]
			$NumberOfFields = $FileDescriptors[3]
			$SortField = $FileDescriptors[4]
			
			;extract descriptors of data file
			$NumberOfRecordsinSubsequentFile = $NumberOfDataFileLines - ($DataFileLineNumberOfFirstRecord - 1)
			$NumberOfRecords = $NumberOfRecords + $NumberOfRecordsinSubsequentFile
			
			;display data file stats
			If $VerboseMode = "on" Then
				MsgBox(0, $DataFileNameAndPath, "Above Data File Found. " & $NumberOfDataFileLines & " total lines in file, " & $DataFileLineNumberOfFirstRecord - 1 & " comment lines, " & $NumberOfRecordsinSubsequentFile & " record lines")
			EndIf
			
			;dim data arrays
			$OldDataArrayHeight = $DataArrayHeight
			$DataArrayHeight = $DataArrayHeight + $NumberOfRecordsinSubsequentFile
			ReDim $DataArray [$DataArrayHeight][$DataArrayWidth] ; preserve existing array & add further lines used to store the subsequent data.
			Dim $HeaderArray [$DataFileLineNumberOfFirstRecord]; used to store the file header information. element [0] is not used
			
			;read header information into header array
			$LinesRead = ReadHeaderIntoArray()
			
			;display successful read
			If $VerboseMode = "on" Then
				MsgBox(0, "Header Data Read Done", $LinesRead & " Lines successfully read into the Header Array.  File Comment is '" & $HeaderArray[$DataFileLineNumberOfDisplayableFileComment] & "'.")
			EndIf
			
			;read data into data array
			$RecordsRead = AddSubsequentDataIntoArray()
			
			;close data file
			FileClose($DataFileHandle)
			
			$AccumulationReportText = $AccumulationReportText & @CRLF & $RecordsRead & " members for " & StringTrimRight($DataFileName, 4) & " added"
			$AccumulationReportTotalRecords = $AccumulationReportTotalRecords + $RecordsRead
			
		Next
		#endregion
		
		;all data files are now read into data array!
		
		;display report
		$AccumulationReportText = $AccumulationReportText & @CRLF & @CRLF & $AccumulationReportTotalRecords & " members compiled for searching"
		MsgBox(0, "Preparation Complete", $AccumulationReportText)
		
		;format GUI again to display records for searching
		
		
	Else
		MsgBox(0, "Error", "You must choose at least 2 DataFiles")
	EndIf
	
	;reformat GUI again
	GUISwitch($MainGUIHandle)
	;remove unwanted elements
	GUICtrlDelete($SelectAllDataFilesButtonID) ;= GUICtrlCreateButton("Select All", 40, 35, 120, 30)
	GUICtrlDelete($SearchSelectedDataFilesButtonID) ;= GUICtrlCreateButton("Search Selected DataFiles", 195, 35, 140, 30)
	GUICtrlDelete($ExitButtonID) ;= GUICtrlCreateButton("Exit", 370, 35, 120, 30)
	For $Counter = 1 To $NumberofDataFiles
		GUICtrlDelete($DataFileandControlIDArray[$Counter][1])
	Next
	;set up new controls
	GUICtrlSetFont(GUICtrlCreateLabel("Multiple Data Search Mode", 20, 14, 440, 20, $SS_center), 9, 600)
	;$FileCommentInputID = GUICtrlCreateInput("Comment Input Field", 85, 10, 375, 20, $SS_center)
	$SearchButtonID = GUICtrlCreateButton("Search for Surname", 50, 38, 190, 25)
	GUICtrlSetState($SearchButtonID, $GUI_DEFBUTTON)
	$SearchInputID = GUICtrlCreateInput("Enter Start of Surname...", 245, 40, 215, 20)
	GUICtrlSetTip($SearchInputID, "To display all members, enter nothing")
	GUICtrlSetState($SearchInputID, $GUI_FOCUS)
	$ListofMembersListID = GUICtrlCreateList("Clickable List", 20, 70, 440, 450)
	$SortButtonID = GUICtrlCreateButton("Sort Member List", 50, 512, 150, 30)
	$MemberNumberRadioID = GUICtrlCreateRadio("By Member Number", 225, 515, 110, 25)
	$SurnameRadioID = GUICtrlCreateRadio("By Surname", 355, 515, 80, 25)
	$RadioGroup = GUICtrlCreateGroup("", 215, 505, 235, 40)
	GUICtrlSetTip($SurnameRadioID, "The option selected activates only after 'Sort Member List' is clicked")
	GUICtrlSetTip($MemberNumberRadioID, "The option selected activates only after 'Sort Member List' is clicked")
	
	; set control contents
	;GUICtrlSetData($FileCommentInputID, $HeaderArray[$DataFileLineNumberOfDisplayableFileComment])
	GUICtrlSetState($SurnameRadioID, $GUI_CHECKED)
	;sort by surname before display
	SortDatabase(4, $DataArrayWidth)
	GUICtrlSetData($ListofMembersListID, GenerateMembersList())
	GUIDelete() ; kill member list progress bar GUI
	GUISwitch($MainGUIHandle)
	
	;Button List at right
	;$GUIImageID = GUICtrlCreatePic("GUI image 150x77.jpg", 520, 10, 150, 77)
	;$MainGUIHelpButtonID = GUICtrlCreateButton("Help", 550, 100, 90, 30)
	;$AddNewMemberButtonID = GUICtrlCreateButton("Add New Member", 520, 140, 150, 30)
	$ViewSelectedMemberButtonID = GUICtrlCreateButton("View Member Details", 520, 180, 150, 30)
	;$DeleteSelectedMemberButtonID = GUICtrlCreateButton("Delete Member", 520, 220, 150, 30)
	;$SaveButtonID = GUICtrlCreateButton("Save", 520, 275, 150, 30)
	;$PrintThisDataButtonID = GUICtrlCreateButton("Print This Data", 520, 325, 150, 30)
	;$PrintMultipleDataFilesButtonID = GUICtrlCreateButton("Print Multiple DataFiles", 520, 365, 150, 30)
	;$AdvancedFeaturesButtonID = GUICtrlCreateButton("Advanced Features", 520, 420, 150, 30)
	;$ChangeDataButtonID = GUICtrlCreateButton("Change Data", 520, 475, 150, 30)
	$QuitButtonID = GUICtrlCreateButton("Quit", 520, 515, 150, 30)
	;GUICtrlSetFont($SaveButtonID, 9, 600)
	;GUICtrlSetFont($AdvancedFeaturesButtonID, 9, 400, 2)
	
	GUISetState()
	While 1 ; process search GUI events
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE ; user closed the window
				Exit
				
			Case $GUImsg = $SearchButtonID
				SearchForSurname(GUICtrlRead($SearchInputID))
				
			Case $GUImsg = $ViewSelectedMemberButtonID ; View
				$ComboData = GUICtrlRead($ListofMembersListID)
				If $ComboData < 1 Then
					MsgBox(0, "No Record Selected", "Please select a record by clicking on it with the mouse")
				Else
					GUISetState(@SW_HIDE, $MainGUIHandle)
					ViewMember(Int(StringLeft($ComboData, 5)))
					GUISetState(@SW_SHOW, $MainGUIHandle)
					GUICtrlSetState($SearchInputID, $GUI_FOCUS)
				EndIf
				
			Case $GUImsg = $QuitButtonID ; quit
				MsgBox(0, "Database Closing", "The database will now close, and exit Multiple Data Search mode.  Please restart it to restore normal operation")
				Exit
				
			Case $GUImsg = $SortButtonID ; sort
				Select
					Case GUICtrlRead($MemberNumberRadioID) = $GUI_CHECKED
						$SortField = 1
						$FileDescriptors[4] = 1
						If $VerboseMode = "on" Then
							MsgBox(0, "GUI State Report", "Member Number was checked. $SortField is set to " & $SortField)
						EndIf
						
					Case GUICtrlRead($SurnameRadioID) = $GUI_CHECKED
						$SortField = 4
						$FileDescriptors[4] = 4
						If $VerboseMode = "on" Then
							MsgBox(0, "GUI State Report", "Surname was checked. $SortField is set to " & $SortField)
						EndIf
						
				EndSelect
				SortDatabase($SortField, $DataArrayWidth)
				GUICtrlSetData($ListofMembersListID, GenerateMembersList())
				GUIDelete() ; kill member list progress bar GUI
				GUISwitch($MainGUIHandle)
				
		EndSelect
	WEnd
	
	
EndFunc   ;==>MultipleDataSearch

Func ViewMember($ArrayNumber)
	$EditRecordGUIHandle = GUICreate("View Record", 750, 400, (@DesktopWidth - 750) / 2, (@DesktopHeight - 400) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	;$MemberNumberInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][1], 110, 10, 130, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Member Number : " & $DataArray[$ArrayNumber][1], 10, 14, 180, 20)
	GUICtrlSetFont( GUICtrlCreateLabel("Source Data File : " & $DataArray[$ArrayNumber][0], 200, 14, 350, 20), 9, 600)
	
	;GUICtrlSetFont(GUICtrlCreateLabel("(Auto-generated numbers are only unique within the members own Data!)", 250, 11, 500, 20), 9, 400, 2)
	;$TitleInputID = GUICtrlCreateInput(, 110, 40, 80, 20)
	GUICtrlCreateLabel("Salutation : " & $DataArray[$ArrayNumber][2], 10, 44, 500, 20)
	;$FirstNamesInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][3], 110, 60, 200, 20)
	GUICtrlCreateLabel("Name SURNAME : " & $DataArray[$ArrayNumber][3] & " " & StringUpper($DataArray[$ArrayNumber][4]), 10, 64, 500, 20)
	;$SurnameInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][4], 320, 60, 220, 20)
	
	;$AddressLine1InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][5], 110, 85, 320, 20)
	GUICtrlCreateLabel("Address Line 1 : " & $DataArray[$ArrayNumber][5], 10, 89, 500, 20)
	;GUICtrlSetTip($AddressLine1InputID, "Keep lines short to avoid truncations when printing!")
	;$AddressLine2InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][6], 110, 105, 320, 20)
	GUICtrlCreateLabel("Line 2 (Optional) : " & $DataArray[$ArrayNumber][6], 10, 109, 500, 20)
	;GUICtrlSetTip($AddressLine2InputID, "Keep lines short to avoid truncations when printing!")
	;$AddressLine3InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][7], 110, 125, 320, 20)
	GUICtrlCreateLabel("Line 3 (Optional) : " & $DataArray[$ArrayNumber][7], 10, 129, 500, 20)
	;GUICtrlSetTip($AddressLine3InputID, "Keep lines short to avoid truncations when printing!")
	;$AddressLine4InputID = GUICtrlCreateInput($DataArray[$ArrayNumber][8], 110, 145, 320, 20)
	GUICtrlCreateLabel("Line 4 (Optional) : " & $DataArray[$ArrayNumber][8], 10, 149, 500, 20)
	;GUICtrlSetTip($AddressLine4InputID, "Keep lines short to avoid truncations when printing!")
	
	;$CitySuburbInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][9], 110, 170, 200, 20)
	GUICtrlCreateLabel("City/Suburb  State : " & $DataArray[$ArrayNumber][9] & "  " & $DataArray[$ArrayNumber][10], 10, 174, 500, 20)
	;$StateInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][10], 320, 170, 220, 20)
	;$ZIPPostcodeInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][11], 110, 195, 110, 20)
	GUICtrlCreateLabel("PostCode  Data : " & $DataArray[$ArrayNumber][11] & "  " & $DataArray[$ArrayNumber][12], 10, 199, 500, 20)
	;$DataInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][12], 230, 195, 260, 20)
	
	;$NumberOfCopiesInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][15], 220, 245, 80, 20, $ES_NUMBER)
	GUICtrlCreateLabel("Number of Copies : " & $DataArray[$ArrayNumber][15], 110, 249, 300, 20)
	;$StartDateInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][16], 380, 245, 80, 20)
	GUICtrlCreateLabel("Start Date : " & $DataArray[$ArrayNumber][16], 310, 249, 150, 20)
	
	;$CommentInputID = GUICtrlCreateInput($DataArray[$ArrayNumber][13], 110, 290, 410, 90, $ES_MULTILINE)
	GUICtrlCreateLabel("Comments : " & $DataArray[$ArrayNumber][13], 10, 294, 500, 90)
	
	$NoteAboutSavingLableID = GUICtrlCreateLabel("Viewing Only" & @CRLF & @CRLF & "Member information cannot be edited in this screen.  To edit, note the 'Source Data File' shown above.  Then re-open the database on that Data file and edit the member.", 560, 210, 185, 160, $SS_center)
	
	$OKButtonID = GUICtrlCreateButton("OK", 590, 80, 140, 40)
	GUICtrlSetFont($OKButtonID, 9, 600)
	;$CanceButtonID = GUICtrlCreateButton("Cancel", 600, 120, 140, 40)
	;GUICtrlSetState($TitleInputID, $GUI_FOCUS)
	
	GUISetState()
	
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $OKButtonID
				ExitLoop
		EndSelect
	WEnd
	GUIDelete()
	Return
EndFunc   ;==>ViewMember

; Sections From Include Files
#region
;------------------------------------------------------------------

;from Array.au3
Func _ArrayDisplay(ByRef $avArray, $sTitle)
	Local $iCounter = 0, $sMsg = ""
	
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	
	For $iCounter = 0 To UBound($avArray) - 1
		$sMsg = $sMsg & "[" & $iCounter & "]    = " & StringStripCR($avArray[$iCounter]) & @CR
	Next
	
	MsgBox(4096, $sTitle, $sMsg)
	SetError(0)
	Return 1
EndFunc   ;==>_ArrayDisplay

Func _ArrayReverse(ByRef $avArray, $i_Base = 0, $i_UBound = 0)
	If Not IsArray($avArray) Then
		SetError(1)
		Return 0
	EndIf
	Local $tmp, $last = UBound($avArray) - 1
	If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
	For $i = $i_Base To $i_Base + Int(($i_UBound - $i_Base - 1) / 2)
		$tmp = $avArray[$i]
		$avArray[$i] = $avArray[$i_UBound]
		$avArray[$i_UBound] = $tmp
		$i_UBound = $i_UBound - 1
	Next
	Return 1
EndFunc   ;==>_ArrayReverse

Func _ArraySort(ByRef $a_Array, $i_Decending = 0, $i_Base = 0, $i_UBound = 0, $i_Dim = 1, $i_SortIndex = 0)
	; Set to ubound when not specified
	If Not IsArray($a_Array) Then
		SetError(1)
		Return 0
	EndIf
	Local $last = UBound($a_Array) - 1
	If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
	
	If $i_Dim = 1 Then
		__ArrayQSort1($a_Array, $i_Base, $i_UBound)
		If $i_Decending Then _ArrayReverse($a_Array, $i_Base, $i_UBound)
	Else
		__ArrayQSort2($a_Array, $i_Base, $i_UBound, $i_Dim, $i_SortIndex, $i_Decending)
	EndIf
	Return 1
EndFunc   ;==>_ArraySort

; Private
Func __ArrayQSort1(ByRef $array, ByRef $left, ByRef $right)
	If $right - $left < 10 Then
		; InsertSort - fastest on small segments (= 25% total speedup)
		Local $i, $j, $t
		For $i = $left + 1 To $right
			$t = $array[$i]
			$j = $i
			While $j > $left _
					And ((IsNumber($array[$j - 1]) = IsNumber($t) And $array[$j - 1] > $t) _
					Or (IsNumber($array[$j - 1]) <> IsNumber($t) And String($array[$j - 1]) > String($t)))
				$array[$j] = $array[$j - 1]
				$j = $j - 1
			WEnd
			$array[$j] = $t
		Next
		Return
	EndIf
	
	; QuickSort - fastest on large segments
	Local $pivot = $array[Int(($left + $right) / 2) ], $t
	Local $L = $left
	Local $R = $right
	Do
		While ((IsNumber($array[$L]) = IsNumber($pivot) And $array[$L] < $pivot) _
				Or (IsNumber($array[$L]) <> IsNumber($pivot) And String($array[$L]) < String($pivot)))
			;While $array[$L] < $pivot
			$L = $L + 1
		WEnd
		While ((IsNumber($array[$R]) = IsNumber($pivot) And $array[$R] > $pivot) _
				Or (IsNumber($array[$R]) <> IsNumber($pivot) And String($array[$R]) > String($pivot)))
			;	While $array[$R] > $pivot
			$R = $R - 1
		WEnd
		; Swap
		If $L <= $R Then
			$t = $array[$L]
			$array[$L] = $array[$R]
			$array[$R] = $t
			$L = $L + 1
			$R = $R - 1
		EndIf
	Until $L > $R
	
	__ArrayQSort1($array, $left, $R)
	__ArrayQSort1($array, $L, $right)
EndFunc   ;==>__ArrayQSort1

; Private
Func __ArrayQSort2(ByRef $array, ByRef $left, ByRef $right, ByRef $dim2, ByRef $sortIdx, ByRef $decend)
	If $left >= $right Then Return
	Local $t, $d2 = $dim2 - 1
	Local $pivot = $array[Int(($left + $right) / 2) ][$sortIdx]
	Local $L = $left
	Local $R = $right
	Do
		If $decend Then
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] > $pivot) _
					Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) > String($pivot)))
				;While $array[$L][$sortIdx] > $pivot
				$L = $L + 1
			WEnd
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] < $pivot) _
					Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) < String($pivot)))
				;While $array[$R][$sortIdx] < $pivot
				$R = $R - 1
			WEnd
		Else
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] < $pivot) _
					Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) < String($pivot)))
				;While $array[$L][$sortIdx] < $pivot
				$L = $L + 1
			WEnd
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] > $pivot) _
					Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) > String($pivot)))
				;While $array[$R][$sortIdx] > $pivot
				$R = $R - 1
			WEnd
		EndIf
		If $L <= $R Then
			For $x = 0 To $d2
				$t = $array[$L][$x]
				$array[$L][$x] = $array[$R][$x]
				$array[$R][$x] = $t
			Next
			$L = $L + 1
			$R = $R - 1
		EndIf
	Until $L > $R
	
	__ArrayQSort2($array, $left, $R, $dim2, $sortIdx, $decend)
	__ArrayQSort2($array, $L, $right, $dim2, $sortIdx, $decend)
EndFunc   ;==>__ArrayQSort2

#endregion
