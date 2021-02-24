#include <mmb_cpux86.au3>
#include <mmb.au3>
#include <MultiFileCopy.au3>

#RequireAdmin

; Create the temp file needed to get Machine Info
_GetCPUzInfo()

$windrive = $CmdLine[1]
$destarch = $CmdLine[2]

if $destarch = "x86" Then $osarch = "WIN_7_X86"
if $destarch = "x64" Then $osarch = "WIN_7_X64"

; Create the output
$driversdir = @ScriptDir &"\"& _GetLaptop() &"\"& _GetManufacturer() &"\"& _GetModel() &"\"& $osarch
;MsgBox(0,"Drivers","Drivers will be pulled from " & @CRLF & @CRLF & $driversdir & @CRLF & @CRLF & "if they exist...",5)
;DirCopy($driversdir,$windrive & "\Drivers",1)
if FileExists($driversdir) Then _MultiFileCopy($driversdir, $windrive & "\Drivers")

;Clean up 
RunWait(@ComSpec & " /c del /s/q restore.ini",$windrive & "\Drivers",@SW_HIDE)
RunWait(@ComSpec & " /c del /s/q BackupLog.txt",$windrive & "\Drivers",@SW_HIDE)

FileDelete(@TempDir & "\cpuz.exe")
FileDelete(@TempDir & "\mysystem.txt")
