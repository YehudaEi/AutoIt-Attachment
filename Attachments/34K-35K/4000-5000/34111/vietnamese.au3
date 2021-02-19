#Include <File.au3>
#Include <WinAPI.au3>

$msiName = "TortoiseSVN-1.6.15.21042-win32-svn-1.6.16.msi"
$logName = @ScriptDir & "\downloads.log"


ShellExecuteWait(@scriptdir & "\" & $msiName)
Sleep(500)
;ControlSend("TortoiseSVN 1.6.12.20536 (32 bit) Setup", "", "[CLASS:Button; INSTANCE:2]", "This is some text")
;ControlClick("TortoiseSVN 1.6.15.21042 (32 bit) Setup", "", "[[CLASS:Button; INSTANCE:2")

WinWaitActive("TortoiseSVN 1.6.15.21042 (32 bit) Setup")
;ControlClick("TortoiseSVN 1.6.15.21042 (32 bit) Setup","&Next >",662)
Send("+n")

WinWaitActive("TortoiseSVN 1.6.15.21042 (32 bit) License Agreement","I &accept the terms in the License Agreement")
ControlClick("TortoiseSVN 1.6.15.21042 (32 bit) License Agreement","I &accept the terms in the License Agreement",662)
Send("+n")

WinWaitActive("TortoiseSVN 1.6.15.21042 (32 bit) Setup","Ready to Install")
ControlClick("TortoiseSVN 1.6.15.21042 (32 bit) Setup","&Install",802)
WinWaitActive("TortoiseSVN 1.6.15.21042 (32 bit) Setup","dlgbmp")
Send("{ENTER}")

