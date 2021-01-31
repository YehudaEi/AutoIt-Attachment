Func MSDecode($msd_prodid, $msd_sep="")

$msd_decoded =""
$msd_code="BCDFGHJKMPQRTVWXY2346789"
Dim $msd_encoded[16]
$msd_cnt=0
For $msd_t = 107 To 135 Step + 2
    $msd_encoded[$msd_cnt]=Dec(StringMid($msd_prodid, $msd_t, 2))
    $msd_cnt += 1
Next
$msd_cnt=1
For $msd_t = 29 To 1 Step - 1
If $msd_cnt <> 6 Then
    $msd_mod = 0
    For $msd_r = 14 To 0 Step -1
        $msd_bit = BitOR(BitShift($msd_mod, -8), $msd_encoded[$msd_r])
        $msd_encoded[$msd_r] = Int($msd_bit / 24)
        $msd_mod = Mod($msd_bit, 24)
    Next
    $msd_decoded = StringMid($msd_code, $msd_mod + 1, 1) & $msd_decoded
    $msd_cnt += 1
Else
    $msd_cnt=1
    If $msd_sep<>"" Then $msd_decoded = $msd_sep & $msd_decoded
EndIf
Next
Return $msd_decoded

EndFunc