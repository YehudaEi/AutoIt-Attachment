Func _CreateLevelMeter($iX=5, $iY=5, $bContinous=False, $iUnits=20, $iUnitHeight=5, $iUnitWidth=30, $lStartColour=0xFFFF00, $lEndColour=0xFF0000)
    Local $iUH, $arIndicator[$iUnits], $arColours[$iUnits]
    Local $arRet[$iUnits][3]
    If $bContinous = False Then
        $iUH = $iUnitHeight+1
    Else
        $iUnitHeight+=1
        $iUH = $iUnitHeight
    EndIf
    ;label to show some values (optional)
    $hLblValue = GUICtrlCreateLabel("", $iX, $iY+$iUH*$iUnits+$iUH+5, $iUnitWidth, 18,$SS_CENTER)
    GUICtrlSetColor(-1,0xEFEFEF)
    $Ri = Mod($lStartColour,256)
    $Gi = BitAND($lStartColour/256,255)
    $Bi = BitAND($lStartColour/65536,255)
    $Rf = Mod($lEndColour,256)
    $Gf = BitAND($lEndColour/256,255)
    $Bf = BitAND($lEndColour/65536,255)
    $Rs = Abs($Ri - $Rf)/$iUnits
    $Gs = Abs($Gi - $Gf)/$iUnits
    $Bs = Abs($Bi - $Bf)/$iUnits
    If $Rf < $Ri Then $Rs = -$Rs
    If $Gf < $Gi Then $Gs = -$Gs
    If $Bf < $Bi Then $Bs = -$Bs

    For $i=0 To $iUnits-1
        $Rf = $Ri + $Rs * $i
        $Gf = $Gi + $Gs * $i
        $Bf = $Bi + $Bs * $i
        $arColours[$i]="0x"&Hex($Bf,2) & Hex($Gf,2) & Hex($Rf,2)
    Next
    For $i=0 To $iUnits-1
        $arIndicator[$i] = GUICtrlCreateLabel("", $iX, ($iY+$iUH*$iUnits)-$iUH*$i, $iUnitWidth, $iUnitHeight)
        $arRet[$i][0]=$arIndicator[$i]
        $arRet[$i][1]=$arColours[$i]
        $arRet[$i][2]=$iUnits
    Next
    Return $arRet
EndFunc

Func _ShowLevelMeter($Signal,ByRef $avArray)
    Local $iUnitsColoured
    Local $m = Mod($Signal, $avArray[0][2])
    Switch $m
        Case 0
            $iUnitsColoured=($Signal-$m)*$avArray[0][2]/100
        Case Else
            $iUnitsColoured=($Signal-$m)*$avArray[0][2]/100 + 1
    EndSwitch
    For $i=0 To $iUnitsColoured-1
        GUICtrlSetBkColor($avArray[$i][0], $avArray[$i][1])
    Next
    For $j=UBound($avArray)-1 To $iUnitsColoured Step -1
        GUICtrlSetBkColor($avArray[$j][0], $GUI_BKCOLOR_TRANSPARENT)
    Next
EndFunc