; ----------------------------------------------------------------------------
;
; Notepad Text Replacer
; Author:         TK_Incorperate <TK_Incorperate@yahoo.com>
;
; Script Function:
;    Replaces the character(s) in witch you chose, with other character(s) that you chose in notepad
;
; ----------------------------------------------------------------------------


WinActivate("###### - Notepad", "");Replace the ###### with your file name



HotKeySet("q", "Terminate");Completely stops replacing by pressing Q
HotKeySet("w", "Pause");Pauses the replacing untill you press W again
dim $Paused = 0



While 1
    TrayTip("Currently", "Replacing", 10)
        Send("{ALT}{RIGHT}{DOWN}f")
        Send("####");Replace the #### with the text you wish to find
        Send("{ENTER}{ESC}")
        Send("####");Replace the #### with the text you wish to replace the first text with
            Sleep(3000);I perfer keeping this at 3 seconds, but you can change to your likings
WEnd



Func Terminate()
    Exit 0
EndFunc



Func Pause()
    $Paused = NOT $Paused
    HotKeySet("w", "UnPause")
    TrayTip("Currently", "Paused", 10)
    While $Paused
    TrayTip("Currently", "Paused", 10)
    sleep(100)
    WEnd
EndFunc



Func UnPause()
    $Paused = NOT $Paused
    HotKeySet("w", "Pause")
EndFunc