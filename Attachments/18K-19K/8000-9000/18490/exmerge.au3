; make sure to edit the paths correctly, based on %USERNAME% variable
; this script should start exmerge.exe with the correct exmerge.ini configuration, backup/archive the mailbox to a local PST, then rename the PST and corresponding log file to the date it was executed
; if script encounters a basic error it will alert user
; before you run this double-check the exmerge.ini that you are using, especially in regards backup/archive settings

; exmerge.exe - make sure this works in current location
$exmergeEXE="d:\program files\exchsrvr\bin\exmerge.exe"
; exmerge.ini - contains specific options like archiving and location of exported data
$exmergeINI="f:\scripts\exmerge\%USERNAME%\exmerge.ini"
; exmerge.log - log file created during the data export
$exmergeLOG="f:\logs\exmerge\%USERNAME%\exmerge.log"
; archive.pst - exported data, named after the mailbox username
$exmergePST="f:\data\exmerge\%USERNAME%\%USERNAME%.PST"
; standard data notation
$date=@YEAR&"."&@MON&"."&@MDAY

; set security credentials
RunAsSet("username","DOMAIN","password")
; run exmerge process, linking to custom exmerge.ini
RunWait($exmergeEXE&" -f "&$exmergeINI&" -b -d")
; clears security credentials
RunAsSet()

; renames exported data, alerts if not found
If FileExists($exmergePST) Then
	FileMove($exmergePST,"f:\data\exmerge\%USERNAME%\"&$date&".PST")
Else
	MsgBox(4096,"Error - PST","Does Not Exist")
EndIf

; renames exported data log, alerts if not found
If FileExists($exmergeLOG) Then
	FileMove($exmergeLOG,"f:\logs\exmerge\%USERNAME%\"&$date&".LOG")
Else
	MsgBox(4096,"Error - LOG","Does Not Exist")
EndIf

