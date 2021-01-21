; ----------------------------------------------------------------------------
;
; VBScript to AutoIt Converter v0.4
;
; ----------------------------------------------------------------------------

#include <Date.au3>

AutoItSetOption("MustDeclareVars", 1)

Const $sLongDayName = _DateDayOfWeek( @WDAY )
Const $strRxWorksProcess = "RXWORKS.EXE"
Const $strRxOptionsProcess = "VVSETUP.EXE"
Const $strRxReportwindowProcess = "RXREPORTVIEWER.EXE"
Const $strRxImagingProcess = "VVIMAGING.EXE"
Const $strDBName = "MAIN.MDB"
Const $strServerName = "Fileserver"
Const $strMainDatabasePath = "F:\RxWorks\Database\MAIN.MDB"
Const $strBackupPath = "R:\"
Const $strRemotePath = "\\Front\Backup\"


Dim $objRxBackup
Dim $objShell
Dim $objNetwork
Dim $objFSO
Dim $oShell
Dim $objOutputFile
Dim $objTextFile
Dim $strText
Dim $file
Dim $chars


;	Initialise
 $objShell = ObjCreate("Wscript.Shell")

; Create the RxBackup object
 $objRxBackup = ObjCreate("RxComlib.RxBackup")

; Send Network Message
RunWait(@ComSpec & " /c " & "msg * /TIME:10 Please Exit RxWorks")
Sleep(10000)

; Send Network Message
RunWait(@ComSpec & " /c " & "msg * /TIME:10 RxWorks Maintenace Starting Please Exit Now!!")
Sleep(10000)

; Event Log entry
$objShell.LogEvent (0,"ITWorks script Started")

; RxBackup Logs
FileMove("F:\RxWorks\Logs\Backup.txt", "F:\RxWorks\Logs\Backup.log", 1)


; Terminate all RxWorks processes
$objRxBackup.TerminateProcess ("Fileserver",$strRxWorksProcess)
$objRxBackup.TerminateProcess ("Fileserver",$strRxOptionsProcess)
$objRxBackup.TerminateProcess ("Fileserver",$strRxReportwindowProcess)
$objRxBackup.TerminateProcess ("Fileserver",$strRxImagingProcess)

; Delete RxMain.ldb if still in directory
FileDelete("F:\RxWorks\Database\Main.ldb")


; Copy the main database to the backup location proir to Rx Maintenace
$objShell.LogEvent (0,"Copying MainData Base to Tmp Drive")
FileCopy("F:\RxWorks\Database\main.mdb", "C:\ITCustom\Tmp\Main.mdb", 1)

; Run the Maintenance function
$objShell.LogEvent (0,"RxWorks Main Database Maintenance Started")
$objRxBackup.RunMaintenance($strMainDatabasePath)
$objShell.LogEvent (0,"RxWorks Main Database Maintenance Completed")

; Copy the main database to the backup location proir to Rx Maintenace
$objShell.LogEvent (0,"Copying MainData Base to Backup Drive")
FileCopy("F:\RxWorks\Database\main.mdb", "R:\" & $sLongDayName & "-Main.mdb", 1)
$objShell.LogEvent (0,"Copying MainData Base to Backup Drive Done")

; Backup logs
FileCopy("F:\RxWorks\Logs\Backup.txt", "C:\ITCustom\Logs\RxBackup.txt", 1)
FileOpen("F:\RxWorks\Logs\Backup.log", 1)
$chars = FileRead("F:\RxWorks\Logs\Backup.log")
$file = FileOpen("F:\RxWorks\Logs\Backup.txt", 1)
FileWriteLine($file, "I.T.Works" & $chars)
FileClose($file)
FileClose("F:\RxWorks\Logs\Backup.log")


; Prepair Data Base for remote Backup
FileMove("R:\*.zip", "R:\zips\" & $sLongDayName & "-Main.zip", 1)
FileDelete("R:\Remote\*.7z.*")
RunWait ("7z.exe a -mx=1 R:\Remote\ -v11m F:\RxWorks\Database\Main.mdb")

; Send Network Message to restart RxWorks
RunWait(@ComSpec & " /c " & "msg * /TIME:15 You Can now start RxWorks")
Sleep(15000)

; Send Email with Log File
RunWait ("c:\ITCustom\Sys\Email.exe")

