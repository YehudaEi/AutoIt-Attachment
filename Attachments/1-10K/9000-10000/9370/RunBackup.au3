;Programmer: Dan Bratt
;Date: 23-June-2006
;Purpose: Script to control UPS daily backup

#include <GUIConstants.au3>
$BackupCmd = 'C:\\WINDOWS\\system32\\ntbackup.exe backup "@c:\UPSBackup\UPSDailyBackup.bks" /v:no /r:yes /rs:no /hc:off /m normal /j "UPS Backup" /l:s /f "c:\UPSBackup\UPSDailyBackup.bkf"'

;Opt("GUIOnEventMode",1)

GUICreate("Run Backup", 210, 80)

$Label = GUICtrlCreateLabel("Running UPS Backup...", 10, 10)
GUISetState()  ; display the GUI
RunBck()
GUIDelete()    
Exit
;--------------- Functions ---------------
Func RunBck()
	FileDelete("c:\UPSBackup\UPSDailyBackup.bkf")
	RunWait(@ComSpec & " /c " & $BackupCmd, "", @SW_HIDE)
	FileCopy("c:\UPSBackup\UPSDailyBackup.bkf", "\\sqlsrv\Server Backups$\UPSDailyBackup.bkf",1)
EndFunc

