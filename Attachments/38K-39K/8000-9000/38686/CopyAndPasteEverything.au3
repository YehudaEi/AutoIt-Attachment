#include <Misc.au3> ; 
Local $ThuMucChepDen = "D:\Temp"

If WinExists("[CLASS:EVERYTHING]") Then
WinActivate("[CLASS:EVERYTHING]", "")
While 1
If _IsPressed("77") Then ; Nhan nut F8
CopyToMMC()
ExitLoop
EndIf
WEnd
Else
RunWait("C:\Program Files\Everything-1.2.1.371\Everything-1.2.1.371.exe", "", @SW_MAXIMIZE)
EndIf

Func CopyToMMC()
If DirGetSize($ThuMucChepDen) = -1 Then
DirCreate($ThuMucChepDen) 
Send("^c") ;for copy
FileChangeDir($ThuMucChepDen) ;change dir 
WinActivate("[CLASS:ExploreWClass]", "") ; Active this dir
Send("^v") ;and paste
;FileCopy("C:\Temp\*.txt", $ThuMucChepDen, 9) ; I can't using FileCopy because don't know $Source.
EndIf
EndFunc