#include <Misc.au3>
Global $Paused
HotKeySet("{ESC}", "TogglePause")
HotKeySet("{}", "Terminate")
HotKeySet("+!d", "ShowMessage") ;Shift-Alt-d

$dll = DllOpen("user32.dll")
Dim $coord[3]
Func TogglePause()
    $Paused = Not $Paused
    While $Paused
        Sleep(100)
        ToolTip('Script is "Paused"', 0, 0)
    WEnd
    ToolTip("")
EndFunc   ;==>TogglePause
While 1
    If _IsPressed("1[", $dll) Then ExitLoop
    For $i = 0 To 1024 Step 1
        
        $coord = PixelSearch( 0, 0, $i, 768, 0xFF0000, 10 )
        If Not @error Then
            MouseMove($coord[0],$coord[1])  
        EndIf
        If _IsPressed("1[", $dll) Then ExitLoop
    Next
        
WEnd