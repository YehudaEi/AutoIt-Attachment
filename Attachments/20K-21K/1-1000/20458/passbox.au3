; Loop around until the user gives a valid "autoit" answer
$bLoop = 1
While $bLoop = 1
    $Pass = InputBox("Enter Password", "Typ the password here.", "", "*")
    If @error = 1 Then
        MsgBox(4096, "Error", "Action Invalid")
    Else
        ; They clicked OK, but did they type the right thing?
        If $Pass <> "milky18" Then
            MsgBox(4096, "Error", "You typed in the wrong thing - try again!")
        Else
            $bLoop = 0    ; Exit the loop - ExitLoop would have been an alternative too :)
        EndIf
    EndIf
WEnd

; Print the success message
MsgBox(4096,"Access Granted", "-----------------=Welcome Miyu=-----------------")

; Finished!
