Local $iRange = 255, $iDelay = 0
Local $hWind = WinGetHandle("[CLASS:Progman]")


    For $i = 0 To $iRange
        WinSetTrans($hWind, "", $i)
        Sleep($iDelay)
    Next

    Sleep(3000)

    For $i = $iRange To 0 Step -1
        WinSetTrans($hWind, "", $i)
        Sleep($iDelay)
    Next
