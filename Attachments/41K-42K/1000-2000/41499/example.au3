If ($CmdLine[0] = 0) Or StringLeft($aCmdLine[1], 16) <> "myapp://startapp" Then
    Exit 1
EndIf

;app start here