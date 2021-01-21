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

; Set its transparency
SetOpacity($G, 200)
GUISetState(@SW_SHOW)

; Wait Until Close
While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then
        ExitLoop
    EndIf
WEnd 