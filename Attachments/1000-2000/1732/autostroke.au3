; Press Esc to terminate script
; Pause/Break to "pause"

Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
;HotKeySet("{ESC}", "Terminate")
HotKeySet("{F8}", "Terminate")

MsgBox(65,"Auto Stroke 1.0b","Use at your own risk. F8 to close program.. PAUSE to pause it (toggle).")


WinWaitActive ("windownamehere") ; removed just for example


;Neverending loop.. use hotkeyset's to stop/pause
While 1
    send("7")
    Sleep(4000)
WEnd
;;;;;;;;

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',10,10)
    WEnd
    ToolTip("")
EndFunc

Func Terminate()
    Exit 0
EndFunc