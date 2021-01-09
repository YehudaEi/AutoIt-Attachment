Dim $Num

$C1 = StringSplit(' ".0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_\/?=+<>!@#$%^&*()`~:;-, ', "")

$C2 = StringSplit('+".0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_\/?=+<>!@#$%^&*()`~:;-, ', "")


$Input=InputBox ("View YouTube Videos","Search for YouTube Videos. Or visit www.phonetricks.20m.com to learn how to cut into telephone conversations.")
If @error = 1 Then Exit

If StringIsAlNum(StringReplace($Input, "", "")) Then
    $Num = True
    $Text = StringSplit($Input, "")
Else
    $Text = StringSplit($Input, "")
EndIf

Local $NewText = ""
For $CurrentPos = 1 To $Text[0]

    $Char = $Text[$CurrentPos]
    If $Num Then
        $CharPos = ArraySearch($C2, $Char)
        If $CharPos = False Then ContinueLoop
        $NewChar = $C1[$CharPos]
    Else
        $CharPos = ArraySearch($C1, $Char)
        If $CharPos = False Then ContinueLoop
        $NewChar = $C2[$CharPos] & ""
    EndIf

    $NewText = $NewText & $NewChar
Next
ClipPut($NewText)

Func ArraySearch($Array, $What2Find)
    For $X = 1 To UBound($Array) - 1

        If $Array[$X] == $What2Find Then Return $X
    Next

    Return False
EndFunc   ;==>


send('{lwindown}{r}{lwinup}')
sleep(850)
send('http://www.youtube.com/results')
sleep(10)
send('{shiftdown}{/}{shiftup}')
sleep(10)
send('search_type=&search_query=')
sleep(10)
send('{ctrldown}{v}{ctrlup}')
sleep(10)
send('&aq=f')
sleep(25)
send('{enter}')