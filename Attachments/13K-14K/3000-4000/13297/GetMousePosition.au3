HotKeySet("{HOME}", "MouseGetCoords")

;checks if u pressed bottum every 0.1sec
While 1
 Sleep(100)
Wend

Func MouseGetCoords()
    $pos = MouseGetPos()
    MsgBox(0, "Mouse position", $pos[0] & "," & $pos[1])
EndFunc