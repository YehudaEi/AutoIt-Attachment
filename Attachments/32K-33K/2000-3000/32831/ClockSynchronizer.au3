#include <Date.au3>
#NoTrayIcon
;Variables
Dim $NTP_Server[4] = ['time.nist.gov','pool.ntp.org','ntp.amnic.net','ntp.stairweb.de'], $NTP_IP[4], $NTPIP[4]
;main program
$NTP_IP = call('check_internet_connectivity')
		If 	$NTP_IP[0] <> '' Then
			$adata = call('NTP_Connect', $NTP_Server[0])
		ElseIf $NTP_IP[1] <> '' Then
			$adata = call('NTP_Connect', $NTP_Server[1])
		ElseIf $NTP_IP[2] <> '' Then
			$adata = call('NTP_Connect', $NTP_Server[2])
		ElseIf $NTP_IP[3] <> '' Then
			$adata = call('NTP_Connect', $NTP_Server[3])
			Else
		Exit
		EndIf
call('Set_Time', $adata)
Exit
;Function to check wich/if servers if you are available to avoid UDP blockage.
Func check_internet_connectivity()
	TCPStartup()
		For $i = 0 to 3
			$NTPIP[$i] = TCPNameToIP ( $NTP_Server[$i])
			Sleep(250)
		Next
	TCPShutdown ()
	Return $NTPIP
EndFunc
;Function to read time from ntp server.
Func NTP_Connect($NTP_Server)
	UDPStartup()
	Dim $socket = UDPOpen(TCPNameToIP($NTP_Server), 123)
	$status = UDPSend($socket, MakePacket("1b0e01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"))
	$data = ""
	While $data = ""
		$data = UDPRecv($socket, 100)
		Sleep(100)
	WEnd
	UDPCloseSocket($socket)
	UDPShutdown()
	Return $data
EndFunc
;Function to decript the time and apply to system
Func Set_Time($bdata)
	$unsignedHexValue = StringMid($bdata, 83, 8); Extract time from packet. Disregards the fractional second.
	$value = UnsignedHexToDec($unsignedHexValue)
	$TZinfo = _Date_Time_GetTimeZoneInformation()
	$UTC = _DateAdd("s", $value, "1900/01/01 00:00:00")
	If 	$TZinfo[0] <> 2 Then ; 0 = Daylight Savings not used in current time zone / 1 = Standard Time
		$TZoffset = ($TZinfo[1]) * - 1
		Else ; 2 = Daylight Savings Time
		$TZoffset = ($TZinfo[1] + $TZinfo[7]) * - 1
	EndIf
			;~ Extracts the data & time into vars
			;~ Date format & offsets
			;~ 2009/12/31 19:26:05
			;~ 1234567890123456789  [1 is start of string]
	$m = StringMid($UTC, 6, 2)
	$d = StringMid($UTC, 9, 2)
	$y = StringMid($UTC, 1, 4)
	$h = StringMid($UTC, 12, 2)
	$mi = StringMid($UTC, 15, 2)
	$s = StringMid($UTC, 18, 2)
;~ Sets the new current time to the computer
	$tCurr = _Date_Time_EncodeSystemTime($m, $d, $y, $h, $mi, $s)
	_Date_Time_SetSystemTime(DllStructGetPtr($tCurr))
EndFunc
;Function to send packet to ntp server
Func MakePacket($d)
    Local $p = ""
    While $d
        $p &= Chr(Dec(StringLeft($d, 2)))
        $d = StringTrimLeft($d, 2)
    WEnd
    Return $p
EndFunc
;Function to decript UnsignedHexToDec
Func UnsignedHexToDec($n)
    $ones = StringRight($n, 1)
    $n = StringTrimRight($n, 1)
    Return Dec($n) * 16 + Dec($ones)
EndFunc
