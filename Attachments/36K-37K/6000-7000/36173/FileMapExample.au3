#include <_FileMapping.au3>
#include <File.au3>

$sPath = _TempFile(@DesktopDir)
ConsoleWrite("Test file: " & $sPath & @CRLF & @CRLF)
; build new test file
$h = FileOpen($sPath, 2+16)
For $i = 1 To 2048
	FileWrite($h, "0x" & Hex(Random(32, 126, 1), 2))
Next
FileFlush($h)
FileClose($h)
;
; make backup copy of original file
FileCopy($sPath, $sPath & ".bak")
;
; get file mapping including physical cluster offsets
Local $arr = _FM_GetFileMapping($sPath)
If @error Then ConsoleWrite("Error: " & @error & @CRLF & "Ext: " & @extended & @CRLF)
; print map info
_FM_PrintMapInfo($arr)
; exit if no extents
If $arr[0][0] = 0 Then Exit
;
; delete the original file
FileDelete($sPath)
ConsoleWrite(@CRLF & "Deleted original file, wait..." & @CRLF)
Sleep(2000)
ConsoleWrite("Recovering..." & @CRLF)
;
; read data map from disk sectors, recovering the deleted file and set final file size
_FM_ReadMapToFile($arr, $sPath & ".recovered", True)
;
; restore original file from backup for comparison
FileMove($sPath & ".bak", $sPath)
;
ConsoleWrite(".recovered file should be identical to the original file" & @CRLF)
