; Get a hard drive's Serial Number 

If $CmdLine[0] = 0 Then ErrorExit("Usage: " & @ScriptName & " DriveLetter", 1)

$DriveLetter = $CmdLine[1]

$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
If $objWMIService = 0 Then ErrorExit("Failed to connect to WMI", 2)

$diskno = GetDiskNo($DriveLetter)
if $diskno < 0 Then ErrorExit("Drive Letter not found", 3)
$serialno = GetSerial($diskno)
if $serialno = "" Then ErrorExit("Serial Number not found", 4)
MsgBox(0, @ScriptName, "Serial no for drive " & $DriveLetter & " is " & $serialno)

; ===========================================================================================
Func GetDiskNo($DriveLetter)
; ===========================================================================================
	if StringLen($driveLetter) < 2 Then
		$DriveLetter = $DriveLetter & ":"
	EndIf
	$colRows = $objWMIService.ExecQuery("SELECT * FROM Win32_LogicalDiskToPartition")
	For $row In $colRows
		$array = StringSplit($row.dependent, '"')
		if $array[0] < 2 Then ErrorExit("no dependent", 5)
		if $DriveLetter = $array[2] Then
			$i = StringInStr($row.antecedent, "Disk #")
			if $i = 0 Then  ErrorExit("antecdent - unexpected format", 6)
			$j = StringInStr($row.antecedent, ",", 0, 1, $i)
			if $j = 0 Then  ErrorExit("antecdent - unexpected format (2)", 7)
			$diskno = StringMid($row.antecedent, $i + 6, $j - $i - 6)
			return $diskno
		EndIf
	Next
	return -1
EndFunc
	

; ===========================================================================================
Func GetSerial($diskno)
; ===========================================================================================
	$colRows = $objWMIService.ExecQuery("SELECT * FROM Win32_DiskDrive WHERE Index = " & $diskno)
	For $row In $colRows
		if StringLeft($row.PNPDeviceID, 3) <> "USB" Then
			return GetSerialNonUsb($diskno)
		EndIf
		$array = StringSplit($row.PNPDeviceID, '\')
		$i = $array[0]
		if $i < 1 Then  ErrorExit("PNPDeviceID, unexpected format", 8)
		$serno = $array[$i]
		$i = StringInStr($serno, '&')
		if $i > 0 Then
			$serno = StringLeft($serno, $i - 1)
		EndIf
		MsgBox(0, @ScriptName, "Drive letter: " & $DriveLetter & @CRLF & "Disk Number: " & $diskno & @CRLF & "PNPDeviceID: " & $row.PNPDeviceID & @CRLF & "serial no: " & $serno)
		if StringLen($serno) < 3 Then
			; If the device doesn't have a serial number, windows manufactures a unique ID that the above code will parse as a 1 digit number. Admit defeat rather than mislead.
			$serno = ""
		EndIf
		return $serno
	Next
	return ""
EndFunc

; ===========================================================================================
Func GetSerialNonUsb($diskno)
; ===========================================================================================
	$colRows = $objWMIService.ExecQuery("SELECT * FROM Win32_PhysicalMedia WHERE Tag = '\\\\.\\PHYSICALDRIVE" & $diskno &"'")
	For $row In $colRows
		$serno = StringStripWS($row.SerialNumber, 3)
		return $serno
	Next
	return ""
EndFunc


; ===========================================================================================
Func ErrorExit($msg, $exitcode)
; ===========================================================================================

	MsgBox(0x40010, @ScriptName, $msg, 10)	; 10 is timeout, i.e. the msgbox closes after 10 seconds
	Exit $exitcode

EndFunc
