Func _Subnet($sIp, $sNetmask)
	
	Dim $netmaskbinary
	Dim $subnetaddarray[5]
	Dim $invmaskarray[5]
	Dim $broadcastaddarray[5]
	Dim $sSubnetinfo[7]
	Dim $subnetadd
	Dim $invmask
	Dim $broadcastadd
	
	; Reads IP and Netmask to an array
	$iparray = StringSplit($sIp, ".")
	$netmaskarray = StringSplit($sNetmask, ".")
	
	; Validates IP address
	For $i = 1 To 4
		If Number($iparray[$i]) < 0 Or Number($iparray[$i]) > 255 Then
			SetError(1)
			Return (-1)
		EndIf
	Next
	
	; Converts netmask into a decimal 
	$netmaskdec = ($netmaskarray[1] * 16777216) + ($netmaskarray[2] * 65536) + ($netmaskarray[3] * 256) + $netmaskarray[4]
	
	; Converts decimal netmask into binary (ex. 11111111111111111100000000000000)
	While $netmaskdec <> 0
		$binmod = Mod($netmaskdec, 2)
		$netmaskbinary = $binmod & $netmaskbinary
		$netmaskdec = Int($netmaskdec / 2)
	WEnd
	
	; Determines the "slash" value of the netmask
	$maskslash = StringInStr($netmaskbinary, "0", 1) - 1
	
	; Validates the "slash" value and netmask value
	If StringInStr(StringRight($netmaskbinary, 32 - $maskslash), "1") Then
		If $netmaskarray[4] = "255" Then
			$maskslash = 32
		Else
			SetError(1)
			Return (-1)
		EndIf
	EndIf

	; Creates arrays conatining subnet address, wilcard, and broadcast addresses
	For $i = 1 To $iparray[0]
		$subnetaddarray[$i] = BitAND($iparray[$i], $netmaskarray[$i])
		$invmaskarray[$i] = BitNOT($netmaskarray[$i] - 256)
		$broadcastaddarray[$i] = BitOR($subnetaddarray[$i], $invmaskarray[$i])
	Next
	
	; Creates strings conatining subnet address, wilcard, and broadcast addresses
	$subnetadd = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." &$subnetaddarray[4]
	$invmask = $invmaskarray[1] & "." & $invmaskarray[2] & "." & $invmaskarray[3] & "." & $invmaskarray[4]
	$broadcastadd = $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4]
	
	If $maskslash = 32 Then
		$iprange = $iparray[1] & "." & $iparray[2] & "." & $iparray[3] & "." & $iparray[4]
		$hosts = 1
	Else
		; Determines the IP range for this subnet
		$iprange = $subnetaddarray[1] & "." & $subnetaddarray[2] & "." & $subnetaddarray[3] & "." & $subnetaddarray[4] + 1 & _
				"-" & $broadcastaddarray[1] & "." & $broadcastaddarray[2] & "." & $broadcastaddarray[3] & "." & $broadcastaddarray[4] - 1
		; Calculates number of available hosts on this subnet
		$hosts = ($invmaskarray[4] + 1) * ($invmaskarray[3] + 1) * ($invmaskarray[2] + 1) * ($invmaskarray[1] + 1) - 2
	EndIf
		
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