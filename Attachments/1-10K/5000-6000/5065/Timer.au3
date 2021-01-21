HotKeySet("T", "TIMERADD")
HotKeySet("{F1}", "TIMERSTAR")
$timeon = 0
$time = 0

Func TIMERADD()
    $time = $time + 1
    MsgBox(1, "Time", "1 Min added!", 1)
EndFunc

Func TIMERSTAR()
    If $timeon = 1 Then
    $timeon = 0
    MsgBox(1, "Timer off", "Timer is off!", 1)
ElseIf $timeon = 0 Then
    $timeon = 1
    MsgBox(1, "Timer on", "Timer is on!", 1)
    EndIf
EndFunc

While 1
    If $timeon = 1 Then
        $time = $time - 1
        BlockInput(0)
        Sleep(60000)
        If $time = 0 Then
            MsgBox(1, "Beep", "Timer went off!", 1)
            BlockInput(1)
            $timeon = 0
            SoundSetWaveVolume(100)
            SoundPlay("") 
            #comments-start Put the path and name of sound and extension in soundplay box! 
            #comments-end
        EndIf
    EndIf
WEnd