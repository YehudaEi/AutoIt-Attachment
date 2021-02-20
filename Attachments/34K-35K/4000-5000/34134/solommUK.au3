#cs
    MasterMind -  Logically deduce a hidden, 4 digit, computer generated, number.
    To help with the deduction,"X 0 = " are used.
    "X" - A digit is present and placed correctly.
    "0" - A digit is present, but not correctly placed.
    "=" - A digit is not present at all.

    Note: This version has no repeated digits in the hidden number.
#ce

Const $title = "               "& "Malkey's MasterMind"
Local $answ = 6, $aVG, $aRG, $rg, $sDisp, $sPreDis, $sPostDis, $bWin = False
Local $iNumTurns = 9 ; Number of guesses -above 9 lining out gets disturbed

While $answ = 6
    $iLoop = 0
    $sPreDis = @TAB & "? ? ? ?" & @TAB & @TAB & " Results" & @CRLF
    $sDisp = ""
    $bWin = False
    $sPostDis = @TAB & '"X" - Match number and position,' & @CRLF & _
            @TAB & '"0" - Match number, not position,' & @CRLF & _
            @TAB & '"=" - Number not present' & @CRLF

    ; Generate unique 4 digit number separated with spaces
    Local $sHidNumber = Random(0, 9, 1), $iRand
    Do
        $iRand = Random(0, 9, 1)
        If StringInStr($sHidNumber, $iRand) = 0 Then $sHidNumber &= " " & $iRand
    Until StringLen($sHidNumber) = 7 ; Example result is "1 2 3 4" So, 4 digits plus 3 spaces = 7 characters.

    Local $aArray[$iNumTurns + 1][2] = [[$sHidNumber]]
    ;Local $aArray[$iNumTurns + 1][6] = [[Random(0, 9, 1) & " " & Random(0, 9, 1) & " " & Random(0, 9, 1) & " " & Random(0, 9, 1)]]
    $aVG = StringSplit($aArray[0][0], " "); splitting number into 4 separate variables

    ;ConsoleWrite($aArray[0][0] & @CRLF) ; The hidden numbers (uncomment for testing purposes)

    ; ---------------- Loop for guesses ---------------------
    While 1
        $iLoop += 1
        $rg = ""
        $sDisp = ""
        For $i = 1 To $iNumTurns
            $sDisp &= $i & ":" & @TAB & $aArray[$i][0] & @TAB & @TAB & $aArray[$i][1] & @CRLF & @CRLF
        Next

        ; Exit loop for guesses .
        If $bWin = True Or $iLoop = $iNumTurns + 1 Then ExitLoop

        ; Input guess number
        While StringLen($rg) <> 4
            $rg = InputBox($title, $sPreDis & @CRLF & $sDisp & @CRLF & @CRLF & $sPostDis & @CRLF & 'Logically deduce a 4 digit number. NO spaces.' & _
                    @CRLF & 'Then press "OK" or "Cancel" to exit', "", "", 280, 500)
            If @error = 1 Then Exit ; Exit two loops.
            If StringLen($rg) <> 4 Then MsgBox(48, $title, @TAB & "Wrong input: Input again", 2)
        WEnd
        $aRG = StringSplit($rg, "")
        $aArray[$iLoop][0] = StringTrimRight(StringRegExpReplace($rg, "(.)", "\1 "), 1) ; Add space between digits & remove trailing space.

        ; evaluation: comparing with no match, makes value for $s as set in start of section:  so   "= "
        Local $aRes[UBound($aRG)]
        For $i = 1 To UBound($aRG) - 1
            If $aVG[$i] = $aRG[$i] Then
                $aRes[1] &= "X" & " "
            ElseIf StringInStr($aArray[0][0], $aRG[$i]) Then
                $aRes[2] &= "0" & " "
            Else
                $aRes[3] &= "=" & " "
            EndIf
        Next
        $aArray[$iLoop][1] = $aRes[3] & $aRes[2] & $aRes[1]
        If $aArray[0][0] == $aArray[$iLoop][0] Then $bWin = True
    WEnd
    ; ------------> End of  Loop for guesses ---------------------

    SoundPlay(@WindowsDir & "\media\notify.wav", 0) ; just dressing up

    If $bWin = True Then
        MsgBox(0, $title, @TAB & $aArray[0][0] & @TAB & " Results" & @CRLF & $sDisp & @CRLF & @TAB & "Guessed  correctly!")
    Else
        MsgBox(0, $title, @TAB & $aArray[0][0] & @TAB & " Results" & @CRLF & $sDisp & @CRLF & @TAB & "You lose!")
    EndIf

    $antw = MsgBox(4, $title, 'To start game again press "Yes" button')
WEnd