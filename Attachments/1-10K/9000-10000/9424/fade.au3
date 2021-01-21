#include <GUIConstants.au3>

; Function to set form's transparency!
Func SetOpacity($hwnd, $opacity)
    Dim $a
    $a = DllCall("user32.dll", "long", "GetWindowLongA", "hwnd", $hwnd, "long", -20)
    DllCall("user32.dll", "long", "SetWindowLongA", "hwnd", $hwnd, "long", -20, "long", BitOR($a, 524288))
    DllCall("user32.dll", "long", "SetLayeredWindowAttributes", "hwnd", $hwnd, "long", 0, "long", $opacity, "long", 2)
EndFunc

; Create a form and labels
$G = GUICreate("Transparent From Example", 400, 60) 
GUICtrlCreateLabel("Hello, this is a transparent from using DllCall!", 10, 10)
GUICtrlCreateLabel("Note that this program only works in Windows 2000/XP/Vista!", 10, 30)

; Make it transparent at first
SetOpacity($G, 0)
GUISetState(@SW_SHOW)

; Fade in
$Closing = 0
For $i = 1 To 200 Step 5
    SetOpacity($G, $i)
    Sleep(5)
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then
        $Closing = 1
        ExitLoop
    EndIf
Next

If NOT $Closing Then
    While 1
        $msg = GUIGetMsg()
        If $msg = $GUI_EVENT_CLOSE Then
            ExitLoop
        EndIf
    WEnd 
EndIf

; Fade Out
$ii = $i
For $i = $ii To 0 Step -5
    SetOpacity($G, $i);
    Sleep(5);
Next