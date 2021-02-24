#include <mmb_cpux86.au3>
#include <mmb.au3>
#include <MultiFileCopy.au3>

#RequireAdmin

$osarch = "WIN_XP_X86"

; Create the temp file needed to get Machine Info
_GetCPUzInfo()

; Set the drive letter to the argument
$windrive = $CmdLine[1]

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