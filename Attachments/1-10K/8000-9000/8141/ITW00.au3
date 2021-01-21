; ----------------------------------------------------------------------------
;
; VBScript to AutoIt Converter v0.4
;
; ----------------------------------------------------------------------------

AutoItSetOption("MustDeclareVars", 1)

Const $strRxWorksProcess = "RXWORKS.EXE"
Const $strRxOptionsProcess = "VVSETUP.EXE"
Const $strRxReportwindowProcess = "RXREPORTVIEWER.EXE"
Const $strRxImagingProcess = "VVIMAGING.EXE"
Const $strServerName = "Fileserver"


Dim $objRxBackup
Dim $objShell
Dim $objFSO
Dim $oShell
Dim $objNetwork
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
RunWait(@ComSpec & " /c " &"msg * /TIME:30 Please Exit System, Maintenace Starting")
Sleep(30000)

; Send Network Message
RunWait(@ComSpec & " /c " &"msg * /TIME:30 Please Exit Now, Server Will Reboot For Maintenace!!")
Sleep(30000)

; Terminate all RxWorks processes
$objRxBackup.TerminateProcess ("Fileserver",$strRxWorksProcess)
$objRxBackup.TerminateProcess ("Fileserver",$strRxOptionsProcess)
$objRxBackup.TerminateProcess ("Fileserver",$strRxReportwindowProcess)
$objRxBackup.TerminateProcess ("Fileserver",$strRxImagingProcess)

; Send Network Message
RunWait(@ComSpec & " /c " &"msg * /TIME:30 Server To Reboot in 30 seconds!!!")
Sleep(40000)


; SYSTEM SHUTDOWN
Run ("C:\ITCustom\Appz\poweroff reboot -force ")

        $objShell.LogEvent (0,"Reboot Of System For Maintenace.")


