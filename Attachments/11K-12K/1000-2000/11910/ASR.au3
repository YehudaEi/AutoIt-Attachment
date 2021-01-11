; Autoit script to run Windows ASR (Automated System Recovery) backup
; Requires admin privledges for the remote share to have ntbackup write ASR there

; ==========================================================================
; Variables
; ==========================================================================
; Write a running list of actions in script to a log file (may be too long to write through EventCreate)
$file = FileOpen(@ComputerName & "_ASR.log", 2)		; Mode 2 = overwrite previous file
FileWriteLine($file, @MON & "/" & @MDAY & "/" & @YEAR & @CRLF & @HOUR & ":" & @MIN & " Starting " & @ScriptName)
; ASR Wizard will not accept UNC paths: "The backup file name could not be used 
; "\\ServerName\ASR$\AMANDA.bkf" Please ensure it is a valid path, and that you have sufficient access."
$BackupPath = "\\ServerName\ASR$"
$BackupDrive = DriveMapAdd("*", $BackupPath)	; Map an unused drive letter to the UNC path
$FullPathToBackupFile = $BackupDrive & "\" & @ComputerName
; Set default for variables for event log writing on program exit
$EventType = "INFORMATION"
$EventID = "100"
$EventDescription = chr(34) & "Creating ASR " & $BackupPath & "\" & @ComputerName & ".bkf" & chr(34)
$UserResponse = 2			; Script canceled (set as default in case user clicks "X" button to close MsgBox)
$WindowTextPrevious = ""	; text read from 'Backup Progress' dialog

; ==========================================================================
; Begin Script
; ==========================================================================
; Ensure drives are ready
CheckDriveStatus("a:\", "floppy")
CheckDriveStatus($BackupDrive, "backup path")
$UserResponse = 0	; clear this to prevent false triggering in MyWriteLogEvent()(no further MsgBox prompts in script)

; Start NTBACKUP.exe (must start up in Advanced Mode, not Wizard mode [a per-user setting])
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Starting ntbackup.exe")
Run("ntbackup.exe")

; Loop looking for startup windows without having to delay waiting for each WinWait to timeout
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Looking for ntbackup.exe startup window and dialogs")
$NtbackupReady = False
$begin = TimerInit()	; begin a timer
Do
	sleep(5000)		; prevent loop from racing while waiting for dialogs

	; If NtBackup isn't ready (which would exit this loop) within 5 minutes, time out the script
	if ((TimerDiff($begin))/1000) > 300 then Exit(MySetEventInfo("ERROR", "299", (TimerDiff($begin))/1000) & _ 
		" Timeout waiting for NTBACKUP.EXE to be ready. NTBACKUP.EXE could be hung or still running."))

	; May get a dialog at startup if new media detected. Just say OK.
	MyWinWaitSendKeys("Recognizable Media Found", "", 1, "{ENTER}", 0)

	; Check if ntbackup has started in Wizard Mode
	if WinWait("Backup or Restore Wizard", "", 1) = 1 Then
		WinActivate("Backup or Restore Wizard")		; ensure it is ready to receive commands & keys
		; Uncheck checkbox to always start up NtBackup in Wizard Mode
		ControlCommand("Backup or Restore Wizard", "Always start in &wizard mode", "Button1", "UnCheck", "")
		; Cannot click link to run NtBackup in Advanced Mode, so close wizard & restart ntbackup
		Send("{ESC}")
		FileWriteLine($file, @HOUR & ":" & @MIN & " " & "ntbackup.exe started in Wizard mode. Restarting in Advanced Mode.")
		sleep(2000)
		Run("ntbackup.exe")
	EndIf

	; Check if ntbackup (in Advanced Mode) is running & send keys Alt-A to start ASR wizard
	if MyWinWaitSendKeys("Backup Utility - [Untitled]", "", 1, "!a", 0) Then $NtbackupReady = True

While $NtbackupReady

; Wait for the ASR wizard to appear & send Alt-N to press "Next" button on first screen of ASR wizard
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Started ntbackup.exe, 1st ASR wizard screen.")
MyWinWaitSendKeys("Automated System Recovery Preparation Wizard", "", 30, "!n", 2)
Sleep(1000)

; Send the full path to the backup file (Control ID: 4147, ClassNameNN:	Edit1)
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Setting backup path in ASR wizard.")
ControlSetText("Automated System Recovery Preparation Wizard", "", "Edit1", $FullPathToBackupFile & ".bkf")
Send("!n")	; Send Alt-N to press "Next" button

; If the folder does not exist, permit it to be created
MyWinWaitSendKeys("Folder Does Not Exist", "", 3, "!y", 0)

; Dialog for ASR to network drive: "Warning. The specified path is not local to this computer. 
; It may not be accessible at recovery time. Do you wish to continue?" OK & Cancel buttons
MyWinWaitSendKeys("Warning", "", 3, "{ENTER}", 0)

; Keep one previous ASR backup. Don't over-write old version until we're sure ntbackup will run (no errors)
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Rename ASR bkf file to bak (replacing)")
If FileExists($FullPathToBackupFile & ".bkf") then FileMove($FullPathToBackupFile & ".bkf", $FullPathToBackupFile & ".bak", 1)

; Send Enter to press wizard's "Finish" button (backup begins)
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Finish ASR wizard.")
MyWinWaitSendKeys("Automated System Recovery Preparation Wizard", "", 30, "{ENTER}", 3)

; If the backup file already exists (should already be renamed ".bak" by script), allow overwrite
MyWinWaitSendKeys("Replace Data", "", 60, "!y", 0)

; Monitor changes in 'Backup Progress' dialog to check for backup completion and ensure app is not hung
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Backup starting. Waiting for prompt for floppy.")
MyProgressMonitor()

; Wait for and handle the prompt for completion
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Waiting for prompt to remove diskette.")
MyWinWaitSendKeys("Backup Utility", "Remove the diskette", 300, "{ENTER}", 5)
; ControlID: 65535		ClassNameNN: Static2
; Text: Remove the diskette, and label it as shown:
; 		Windows Automated System Recovery Disk for Backup.bkf created 8/24/2006 at 2:14 PM
;		Keep it in a safe place in case your system needs to be restored using Windows Automated System Recovery.
Sleep(2000)

; Wait for and handle the dialog reporting the backup is complete
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Waiting to close the 'Backup Progress' dialog.")
MyWinWaitSendKeys("Backup Progress", "", 3, "{ENTER}", -1)

; Close the backup program
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Waiting to close ntbackup.exe.")
MyWinWaitSendKeys("Backup Utility - [Untitled]", "", 60, "!jx", -2)

; Copy the ASR files from the floppy drive to keep this version and the previous version
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Preparing to copy floppy files to remote drive.")
MyCopyFloppyFiles()

; Log successful completion
FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Successful completion.")
MySetEventInfo("INFORMATION", "100", "Created ASR " & $BackupPath & "\" & @ComputerName & ".bkf")
Exit(0)		; must exit the script or you fall thru and the functions below will run
; =================================================================================
; =================================================================================


; *********************************************************************************
; Default function called by AutoIt on exit
Func OnAutoItExit()
	MyWriteLogEvent()			; write log event on exit
	FileClose($file)			; close the log file (and flushes all writes to the file)
 	DriveMapDel($BackupDrive)	; unmap the drive letter used by the script
	Shutdown(0)					; 0 = logoff Windows
EndFunc

; *********************************************************************************
; Ensure the window is active before sending keys
Func MyWinWaitSendKeys($TitleOfWindowToActivate, $SubStringInWindow, $TimeoutSeconds, $KeysToSend, $ExitScriptID)
	; WinWait returns 1 if window found. SubStringInWindow is optional (can be "")
	if WinWait($TitleOfWindowToActivate, $SubStringInWindow, $TimeoutSeconds) = 1 Then
		WinActivate($TitleOfWindowToActivate, $SubStringInWindow)
		Send($KeysToSend)
		Return True
	Else		; timeout (WinWait returned 0) - window not found
		;$ExitScriptID determines action on timeout (window not found):
		;	positive = exit script, loggin error
		;	0 = expected not to find windows (i.e. rairly seen error dialog), so continue script without logging
		;	negative = continue script, but log error
		If $ExitScriptID > 0 then Exit(MySetEventInfo("ERROR", $ExitScriptID, "Timeout waiting for window '" & $TitleOfWindowToActivate & _ 
				"' at MyWinWaitSendKeys() call with ID " & $ExitScriptID & ". NTBACKUP.EXE could be hung or still running."))
		If $ExitScriptID < 0 then FileWriteLine($file, @HOUR & ":" & @MIN & " Timeout waiting for window '" & $TitleOfWindowToActivate & _
			"' in MyWinWaitSendKeys() call with ID " & $ExitScriptID)
		Return False
	EndIf
EndFunc

; *********************************************************************************
; Ensure a drive is ready for writing
Func CheckDriveStatus($DriveToCheck, $DriveDescription)
	FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Checking status of " & $DriveDescription & " " & $DriveToCheck)
	While DriveStatus($DriveToCheck) <> "READY"
		FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Status of " & $DriveDescription  & " " & $DriveToCheck & " was not 'READY'. Prompting user.")
		; Retry/Cancel dialog times out in 300 seconds (5 minutes)
		$UserResponse = 2		; set as default in case user clicks "X" button to close MsgBox
		$UserResponse = MsgBox(262165, @ScriptName & " Error", "Drive " & $DriveToCheck & " is not ready.", 300)
		if $UserResponse = -1 then			; Msgbox timed out
				Exit(MySetEventInfo("ERROR", "110", "MsgBox timeout: Drive " & $DriveToCheck & "is not ready for " & $FullPathToBackupFile & ".bkf"))
		ElseIf $UserResponse = 2 then			; Cancel button pressed
			Exit(MySetEventInfo("WARNING", "111", "User canceled ASR script for " & $BackupPath & "\" & @ComputerName & ".bkf"))
		ElseIf $UserResponse <> 4 then		; 4 = Retry button (continue loop). If not 4, unknown return so abort.
			Exit(MySetEventInfo("ERROR", "198", "Unknown error aborted the ASR script " & @ScriptName))
		EndIf
	WEnd
EndFunc

; *********************************************************************************
; Write events to an event log, including the StatusString that logged script execution steps
Func MyWriteLogEvent()
	; if user closed MsgBox by clicking "X" button, there is no response and script exits
	if $UserResponse = 2 Then MySetEventInfo("WARNING", "300", "User canceled ASR script for " & _ 
		$BackupPath & "\" & @ComputerName & ".bkf by clicking 'X' button in MsgBox.")
	; Note: EventCreate event IDs must be in the range 1 to 1000
	$CmdStr = "EVENTCREATE.EXE" & _ 
	" /T " & $EventType & _ 
	" /ID " & $EventID & _ 
	" /L APPLICATION /SO " & @ScriptName & _
	" /D " & chr(34) & $EventDescription & @CRLF & @CRLF & "Additional details are in " & @CRLF & @CRLF & _ 
		@ScriptDir & "\" & @ComputerName & "_ASR.log" & chr(34)
    RunWait($CmdStr)
EndFunc

; *********************************************************************************
; On error, change the event type, ID, & description from the default
Func MySetEventInfo($NewEventType, $NewEventID, $NewEventDescription)
	$EventType = $NewEventType
	$EventID = $NewEventID
	$EventDescription = $NewEventDescription
	FileWriteLine($file, @HOUR & ":" & @MIN & " " & "MySetEventInfo() call with Event Type " & _ 
		$EventType & ", Event ID " & $EventID & ", and Event Description: " & $EventDescription)
	return $NewEventID		; for Exit return codes
EndFunc

; *********************************************************************************
Func MyProgressMonitor()
	; Monitor the progress of ntbackup to ensure it is running (not hung)
	$BackupComplete = False
	$NoProgressCntr = 0	; count number of time no progress was seen
	Do
		$WindowTextCurrent = WinGetText("Backup Progress")
		if $WindowTextCurrent = $WindowTextPrevious Then	; if the same, no progress. Check for complete or hung app.
			; If the floppy prompt dialog appears, sucessfull completion of ASR
			if MyWinWaitSendKeys("Backup Utility", "Insert a blank", 5, "{ENTER}", -3) Then
				; ControlID: 65535		ClassNameNN: Static2
				; Text: Insert a blank, 1.44 MB, formatted diskette in drive A:.  Recovery information will be written to this diskette.
				$BackupComplete = True
			Else
				$NoProgressCntr = $NoProgressCntr + 1
				if $NoProgressCntr > 10 then Exit(MySetEventInfo("ERROR", "200", "Timeout waiting for window 'Backup Progress' " & _ 
						"in MyProgressMonitor() call. NTBACKUP.EXE could be hung or still running."))
			Endif
		Else
			$WindowTextPrevious = $WindowTextCurrent
			$NoProgressCntr = 0
		EndIf
		sleep(60000)		; check again in 1 minute
	Until $BackupComplete	; if backup not complete, loop to check again or will exit via timeout

EndFunc

; *********************************************************************************
; Copy ASR files from floppy, keeping this version and the previous version
Func MyCopyFloppyFiles()
	FileWriteLine($file, @HOUR & ":" & @MIN & " " & "Running MyCopyFloppyFiles().")
	; Keep one previous ASR backup
	MyCopyFileSavingPreviousVersion("a:\", $BackupDrive & "\", "setup.log")
	MyCopyFileSavingPreviousVersion("a:\", $BackupDrive & "\", "asr.sif")
	MyCopyFileSavingPreviousVersion("a:\", $BackupDrive & "\", "asrpnp.sif")
EndFunc

; *********************************************************************************
; Rename (move with replace) a file from ".xxx" to ".xxx.bak" and copy a new ".xxx" version
Func MyCopyFileSavingPreviousVersion($SourcePath, $DestPath, $FileNameAndExtension)
	; $SourcePath and $DestPath must have trailing "\"
	$SourceFullPath = $SourcePath & $FileNameAndExtension
	$DestFullPath = $DestPath & @ComputerName & "_" & $FileNameAndExtension
	FileWriteLine($file, @TAB & "Copy " & $SourceFullPath & " to " & $DestFullPath)
	If FileExists($SourceFullPath) then 
		If FileExists($DestFullPath) then FileMove($DestFullPath, $DestFullPath & ".bak", 1)
		$RetVal = FileCopy($SourceFullPath, $DestFullPath)
		if $RetVal = 0 Then FileWriteLine($file, ">>> Failure copying " & $SourceFullPath & " to " & $DestFullPath)
	Else
		FileWriteLine($file, ">>> Error in MyCopyFileSavingPreviousVersion(). Source file " & $SourceFullPath & " not found.")
	EndIf
EndFunc
