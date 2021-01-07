; ----------------------------------------------------------------------------
; AutoIt Version: 3.1.0
; Author:         Bill Suthers
; Script Function:	Demonstrate crash on GUICtrlDelete($CheckboxFileTransfersOnly) command
; Script Version: See variables section
; ----------------------------------------------------------------------------
#include <GUIConstants.au3>

; create the GUI
GUICreate("Mytitle", 700, 100, (@DesktopWidth - 700) / 2, 0, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

; create feedback Lable
$FeedBackLableID = GUICtrlCreateLabel("Script Started....", 20, 20, 320, 60)
GUICtrlSetFont($FeedBackLableID, 9, 600)

$Backup = GetBackupType() ; call function

MsgBox (0,"Worked","If you see this, the script didn't crash as I describe!")

Exit
; ----------------------------------------------------------------------------

Func GetBackupType()
	GUICtrlSetData($FeedBackLableID, "Please select the type of backup to perform....")
	;Display Options Radio Buttons & Continue Buttons
	$GroupofRadioButtons = GUICtrlCreateGroup("", 360, 3, 160, 80)
	$RadioDailyBackupID = GUICtrlCreateRadio("Daily Backup (to USB)", 370, 20, 145, 20)
	GUICtrlSetTip($RadioDailyBackupID, "Normally used Monday to Thursday")
	$RadioWeeklyBackupID = GUICtrlCreateRadio("Weekly Backup (to CD)", 370, 50, 145, 20)
	GUICtrlSetTip($RadioWeeklyBackupID, "Normally used Friday")
	GUICtrlSetState($RadioDailyBackupID, $GUI_CHECKED)
	$CheckboxFileTransfersOnly = GUICtrlCreateCheckbox("File Transfers Only", 110, 81, 120, 20)
	GUICtrlSetFont($CheckboxFileTransfersOnly, 9, 400, 2)
	GUICtrlSetTip($CheckboxFileTransfersOnly, "NOT USED NORMALLY!  Performs NO fresh backup of the database!  Only copies the most recent backup files to external media.")
	$ButtonExecuteID = GUICtrlCreateButton("Execute", 570, 20, 110, 30)
	$ButtonQuitID = GUICtrlCreateButton("Quit", 570, 60, 110, 30)
	
	MsgBox (0,"Demo of Problem","Please click the 'Execute' button to continue")
	
	GUISetState()
	While 1; loop while waiting for user to give information
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				Exit
			Case $msg = $ButtonQuitID
				Exit
			Case $msg = $ButtonExecuteID
				;read daily/weekly radio buttons
				If GUICtrlRead($RadioDailyBackupID) = $GUI_CHECKED Then
					$BackupType = "Daily"
				Else
					$BackupType = "Weekly"
				EndIf
				;read file transfers only checkbox
				If GUICtrlRead($CheckboxFileTransfersOnly) = $GUI_CHECKED Then
					$PerformFileTransfersOnly = "yes"
					$ConfirmFilesOnly = MsgBox(36, "Files Only Warning", "You have selected the 'File Transfer Only' option.  This DOES NOT perform a fresh backup of the database.  Only the most recent previous backup files are transfered to external media.  Are you sure you want to continue?")
				EndIf
				ExitLoop
		EndSelect
	WEnd
	
	
	;Remove the Selection Controls....
	GUICtrlDelete($RadioDailyBackupID)
	GUICtrlDelete($RadioWeeklyBackupID)
	GUICtrlDelete($ButtonExecuteID)
	GUICtrlDelete($ButtonQuitID)
	GUICtrlDelete($CheckboxFileTransfersOnly) ; script crashes on this command!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	GUICtrlDelete($GroupofRadioButtons)

	GUICtrlSetData($FeedBackLableID, $BackupType & " Backup Selected....")
	return ($BackupType)
EndFunc   ;==>GetBackupType
