#include <Date.au3>
$sJulDate = _DateAdd( 'd',0, _NowCalcDate())
$tdate = StringReplace($sJulDate, "/", "-")
$newfiled = "bm-" & $tdate
$bmdir = "C:\#bmfiles\"
$finnewfile = $bmdir & $newfiled & ".wpd"
$allbm = $bmdir & "*.*"
$sourcedir = "Z:\Test Docs\EB\"
$sentdir = "Z:\Test Docs\EB\Sent\"
$sourcedirwpd = $sourcedir & "*.wpd"
dim const $pw = "324fgg86j5"


If FileExists("Z:\Test Docs\EB\*.wpd") Then
    FileCopy("Z:\Test Docs\EB\*.wpd", $finnewfile)
Else
    Exit
EndIf

Run("c:\abisoft\coder\coder.exe", "",@SW_MAXIMIZE )
sleep(7000)
;   this is for windows key run.... Send("#r")
Send("!f")
Send("{DOWN}")
Send("{LEFT}")
Send("{DOWN}")
Send("{DOWN}")
Send("{DOWN}")
Send("{DOWN}")
Send("{ENTER}")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{PGUP}")
Send("{DOWN}")
Send("{ENTER}")
Send("{DOWN}")
Send("{DOWN}")
Send("{TAB}")
Send("{RIGHT")
Send("{RIGHT")
Send("{DOWN}")
Send("!t")
Send("e")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("{Space}")
Send("+{TAB 2}") 
sleep(1000)
Send($pw,1)
sleep(1000)
Send("{TAB}")
sleep(1000)
Send($pw,1)
sleep(1000)
Send("{TAB}")
Send("{TAB}")
Send("{ENTER}")
sleep(80000)
Send("{ENTER}")
Send("!f")
Send("e")


ProcessWaitClose("coder.exe")

$abi = $bmdir & $newfiled & ".abi"
$exe = $bmdir & $newfiled & ".exe"
FileMove($exe, $abi, 1)
;This is the mailer portion that mails the encrypted files
runwait('Wscript.exe c:\#scripts\sendencmailtobm.vbs', "c:\#scripts", @SW_HIDE)
FileMove($allbm, $sentdir, 1)
FileMove($sourcedirwpd, $sentdir, 1)