msgbox(2+512+32,"", "What to do?")

;RETURN VALUES:
;CANCEL 2
;ABORT 3
;TRY AGAIN 10
;RETRY 4
;IGNORE 5

If $answer = 2 Then
    MsgBox(0, "-", "OK.  Bye!")
    Exit
EndIf
If $answer = 5 Then
    MsgBox(0, "Yay!", "You did it :P")
    Exit
EndIf
If $answer = 4 Then
    $bLoop = 1
    Exit
EndIf