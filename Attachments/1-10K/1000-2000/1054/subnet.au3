Func _Subnet($sIp, $sNetmask)
   
   Dim $maskslash
   Dim $slash[32]
   
   $iparray = StringSplit($sIp, ".")
   $netmaskarray = StringSplit($sNetmask, ".")
   
   $slash[1] = "128.0.0.0"
   $slash[2] = "192.0.0.0"
   $slash[3] = "224.0.0.0"
   $slash[4] = "240.0.0.0"
   $slash[5] = "248.0.0.0"
   $slash[6] = "252.0.0.0"
   $slash[7] = "254.0.0.0"
   $slash[8] = "255.0.0.0"
   $slash[9] = "255.128.0.0"
   $slash[10] = "255.192.0.0"
   $slash[11] = "255.224.0.0"
   $slash[12] = "255.240.0.0"
   $slash[13] = "255.248.0.0"
   $slash[14] = "255.252.0.0"
   $slash[15] = "255.254.0.0"
   $slash[16] = "255.255.0.0"
   $slash[17] = "255.255.128.0"
   $slash[18] = "255.255.192.0"
   $slash[19] = "255.255.224.0"
   $slash[20] = "255.255.240.0"
   $slash[21] = "255.255.248.0"
   $slash[22] = "255.255.252.0"
   $slash[23] = "255.255.254.0"
   $slash[24] = "255.255.255.0"
   $slash[25] = "255.255.255.128"
   $slash[26] = "255.255.255.192"
   $slash[27] = "255.255.255.224"
   $slash[28] = "255.255.255.240"
   $slash[29] = "255.255.255.248"
   $slash[30] = "255.255.255.252"
   $slash[31] = "255.255.255.254"
   
   For $i = 1 To 31
      If $sNetmask = $slash[$i] Then
         $maskslash = $i
      EndIf
   Next
   If Not $maskslash > 0 And $maskslash < 31 Then
      SetError(1)
      Return (0)
   EndIf
   
   For $i = 1 To 4
      If Number($iparray[$i]) < 0 Or Number($iparray[$i]) > 255 Then
         SetError(1)
         Return (-1)
      EndIf
   Next
   
   Dim $subnetaddarray[5]
   Dim $invmaskarray[5]
   Dim $broadcastaddarray[5]
   Dim $sSubnetinfo[7]
   
   For $i = 1 To $iparray[0]
      $subnetaddarray[$i] = BitAND($iparray[$i], $netmaskarray[$i])
      $invmaskarray[$i] = BitNOT($netmaskarray[$i] - 256)
      $broadcastaddarray[$i] = BitOR($subnetaddarray[$i], $invmaskarray[$i])
   Next
   
   ; The subnet address.
   $subnetadd = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." & $subnetaddarray[4]
   ; The broadcast address.
   $broadcastadd = $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4]
   ; The inverse netmask (wildcard).
   $invmask = $invmaskarray[1] & "." & $invmaskarray[2] & "." & $invmaskarray[3] & "." & $invmaskarray[4]
   ; The range of IP addresses for this subnet.
   $iprange = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." & $subnetaddarray[4] + 1 & _
         "-" & $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4] - 1
   ; The number of available hosts in this IP range.
   $hosts = ($invmaskarray[4] + 1) * ($invmaskarray[3] + 1) * ($invmaskarray[2] + 1) - 2
   
   $sSubnetinfo[1] = $subnetadd
   $sSubnetinfo[2] = $broadcastadd
   $sSubnetinfo[3] = $invmask
   $sSubnetinfo[4] = $iprange
   $sSubnetinfo[5] = $hosts
   $sSubnetinfo[6] = $maskslash
   
   Return ($sSubnetinfo)
EndFunc

Func _SameSub($sIp, $sSubadd, $sBroadadd)
   
   Dim $iparray[5]
   Dim $subaddarray[5]
   Dim $broadaddarray[5]
   
   $iparray = StringSplit($sIp, ".")
   $subaddarray = StringSplit($sSubadd, ".")
   $broadaddarray = StringSplit($sBroadadd, ".")
   
   For $i = 1 To 4
      If Number($iparray[$i]) < 0 Or Number($iparray[$i]) > 255 Then
         SetError(1)
         Return (-1)
      EndIf
      If Number($subaddarray[$i]) < 0 Or Number($subaddarray[$i]) > 255 Then
         SetError(1)
         Return (-2)
      EndIf
      If Number($broadaddarray[$i]) < 0 Or Number($broadaddarray[$i]) > 255 Then
         SetError(1)
         Return (-3)
      EndIf
   Next
   
   $ipint = ($iparray[1] * 16777216) + ($iparray[2] * 65536) + ($iparray[3] * 256) + $iparray[4]
   $subaddint = ($subaddarray[1] * 16777216) + ($subaddarray[2] * 65536) + ($subaddarray[3] * 256) + $subaddarray[4]
   $broadaddint = ($broadaddarray[1] * 16777216) + ($broadaddarray[2] * 65536) + ($broadaddarray[3] * 256) + $broadaddarray[4]
   
   If $ipint > $subaddint And $ipint < $broadaddint Then
      Return (1)
   Else
      Return (0)
   EndIf
EndFunc