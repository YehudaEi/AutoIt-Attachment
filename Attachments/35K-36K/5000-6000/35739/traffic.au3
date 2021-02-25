#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <date.au3>
#include "Winpcap.au3"

$winpcap = _PcapSetup()
If ($winpcap = -1) Then
	MsgBox(16, "Pcap error !", "WinPcap not found !")
	Exit
EndIf

$pcap_devices = _PcapGetDeviceList()
If ($pcap_devices = -1) Then
	MsgBox(16, "Pcap error !", _PcapGetLastError())
	Exit
EndIf

For $i = 0 To UBound($pcap_devices) - 1
;~ 	ConsoleWrite($pcap_devices[$i][0] & " ==> " & $pcap_devices[$i][1] & @CRLF)
Next

$dev_ID = $pcap_devices[0][0]


$i = 0
$pcap = 0
$packet = 0
$pcapfile = 0
$prom = 1
$filter = "port 67" ; DHCP

$pcap = _PcapStartCapture($dev_ID, $filter, $prom)
If ($pcap = -1) Then
	MsgBox(16, "Pcap error !", _PcapGetLastError())
	Exit
EndIf
$linktype = _PcapGetLinkType($pcap)
If ($linktype[1] <> "EN10MB") Then
	MsgBox(16, "Pcap error !", "This example only works for Ethernet captures")
	Exit
EndIf

;~ AdlibRegister("stats", 1000 * 60)

While True
	If IsPtr($pcap) Then ; If $pcap is a Ptr, then the capture is running
		$time0 = TimerInit()
		While (TimerDiff($time0) < 500) ; Retrieve packets from queue for maximum 500ms before returning to main loop, not to "hang" the window for user
			$packet = _PcapGetPacket($pcap)
			If IsInt($packet) Then ExitLoop
			$udpdata = _UDP_Parser($packet[3])
			$dhcpdata = _DHCP_Parser($udpdata)
		WEnd
	EndIf
	Sleep(1)
WEnd
_PcapFree()
Exit

Func Stats()
	$s = _PcapGetStats($pcap)
	Local $stats_txt = ""
	For $a = 1 To UBound($s, 1) - 1
		$stats_txt &= $s[$a][1] & ":" & $s[$a][0] & @CRLF
	Next
	ConsoleWrite($stats_txt)
EndFunc   ;==>Stats

Func _UDP_Parser($data)
	If BinaryMid($data, 13, 2) <> "0x0800" Then Return ; Ethertype
	If BinaryMid($data, 24, 1) <> "0x11" Then Return ; UDP
	Local $srcip = Number(BinaryMid($data, 27, 1)) & "." & Number(BinaryMid($data, 28, 1)) & "." & Number(BinaryMid($data, 29, 1)) & "." & Number(BinaryMid($data, 30, 1))
	Local $dstip = Number(BinaryMid($data, 31, 1)) & "." & Number(BinaryMid($data, 32, 1)) & "." & Number(BinaryMid($data, 33, 1)) & "." & Number(BinaryMid($data, 34, 1))
	Local $srcport = Number(BinaryMid($data, 35, 1)) * 256 + Number(BinaryMid($data, 36, 1))
	Local $dstport = Number(BinaryMid($data, 37, 1)) * 256 + Number(BinaryMid($data, 38, 1))
	Local $udplength = Number(BinaryMid($data, 39, 1)) * 256 + Number(BinaryMid($data, 40, 1))
	Local $udpchecksum = Number(BinaryMid($data, 41, 1)) * 256 + Number(BinaryMid($data, 42, 1))
	ConsoleWrite($srcip & ":" & $srcport & " ==> " & $dstip & ":" & $dstport & " Length: " & $udplength & @CRLF)
	Local $udpdata = BinaryMid($data, 43, $udplength)
	ConsoleWrite($udpdata & @CRLF)
	Return $udpdata
EndFunc   ;==>_UDP_Parser

Func _DHCP_Parser($udpdata)
	$op = Number(BinaryMid($udpdata, 1, 1))
	Switch $op
		Case 1
			ConsoleWrite("Boot Request ")
		Case 2
			ConsoleWrite("Boot Reply ")
	EndSwitch
	$htype = Number(BinaryMid($udpdata, 2, 1))
	Switch $htype
		Case 1
			ConsoleWrite("via Ethernet ")
		Case 6
			ConsoleWrite("via IEEE 802 ")
		Case 7
			ConsoleWrite("via ARCNET ")
	EndSwitch
	$hlen = Number(BinaryMid($udpdata, 3, 1))
	Switch $hlen
		Case 6
			ConsoleWrite("and a Hardware address Length of a MAC address ")
		Case 2
			ConsoleWrite("and an Unknown Hardware address Length ")
	EndSwitch
	$hops = Number(BinaryMid($udpdata, 4, 1))
	Switch $hops
		Case 0
			ConsoleWrite("send directly ")
		Case Else
			ConsoleWrite("relayed over " & $hops & " DHCP-Relay-Agents ")
	EndSwitch
	$xid = BinaryMid($udpdata, 5, 4)
	ConsoleWrite("and a transaction ID of " & $xid & " ")
	$secs = Number(BinaryMid($udpdata, 9, 1)) * 256 + Number(BinaryMid($udpdata, 10, 1))
	ConsoleWrite("waiting since " & $secs & " seconds ")
	$flags = Number(BinaryMid($udpdata, 11, 1)) ; easy implemetation
	Switch $flags
		Case 0
			ConsoleWrite("with an old IP ")
		Case 1
			ConsoleWrite("without an old IP ")
	EndSwitch
	$ciaddr = Number(BinaryMid($udpdata, 13, 1)) & "." & Number(BinaryMid($udpdata, 14, 1)) & "." & Number(BinaryMid($udpdata, 15, 1)) & "." & Number(BinaryMid($udpdata, 16, 1))
	$yiaddr = Number(BinaryMid($udpdata, 17, 1)) & "." & Number(BinaryMid($udpdata, 18, 1)) & "." & Number(BinaryMid($udpdata, 19, 1)) & "." & Number(BinaryMid($udpdata, 20, 1))
	$siaddr = Number(BinaryMid($udpdata, 21, 1)) & "." & Number(BinaryMid($udpdata, 22, 1)) & "." & Number(BinaryMid($udpdata, 23, 1)) & "." & Number(BinaryMid($udpdata, 24, 1))
	$giaddr = Number(BinaryMid($udpdata, 25, 1)) & "." & Number(BinaryMid($udpdata, 26, 1)) & "." & Number(BinaryMid($udpdata, 27, 1)) & "." & Number(BinaryMid($udpdata, 28, 1))
	ConsoleWrite("ClientIP: " & $ciaddr & " Your IP: " & $yiaddr & " Server IP: " & $siaddr & " Relay-Agent-IP-Adress " & $giaddr & " ")
	$chaddr = BinaryMid($udpdata, 29, 16)
	$chaddr_mac = StringTrimLeft(BinaryMid($udpdata, 29, 6), 2)
	$chaddr_pad = StringTrimLeft(BinaryMid($udpdata, 35, 10), 2)
	ConsoleWrite("and a client identifier of " & $chaddr & " which results in a client MAC-Address of " & $chaddr_mac & " and padding, ")
	$sname = StringReplace(BinaryToString(BinaryMid($udpdata, 45, 64)), Chr(0), "")
	Switch $sname
		Case ""
			ConsoleWrite("requesting no special server ")
		Case Else
			ConsoleWrite("requesting Server-Name " & $sname & " ")
	EndSwitch
	$file = StringReplace(BinaryToString(BinaryMid($udpdata, 109, 128)), Chr(0), "")
	Switch $file
		Case ""
			ConsoleWrite("with no boot-file specified ")
		Case Else
			ConsoleWrite("getting following Bootfile '" & $file & "' ")
	EndSwitch
	$options = StringReplace(BinaryToString(BinaryMid($udpdata, 237)), Chr(0), "")
	ConsoleWrite("and the following options: " & $options)
	ConsoleWrite(@CRLF)
	If BitAND(BinaryMid($udpdata, 237, 4), 0x63825363) Then ; is a DHCP Package
		ConsoleWrite("DHCP options:" & @CRLF)
		_DHCP_Options_Parser(BinaryMid($udpdata, 241))
	EndIf
EndFunc   ;==>_DHCP_Parser

Func _DHCP_Options_Parser($options)
	$i = 1
	Do
		$options_type = Number(BinaryMid($options, $i, 1))
		$length = Number(BinaryMid($options, $i + 1, 1))
		If $options_type = 0 Or $options_type = 255 Then $length = 1
		ConsoleWrite("Count: " & $i & " Option Type: " & $options_type & " Packet Length: " & $length & @CRLF)
		Switch $options_type
			Case 0 ; padding

			Case 1 ; Subnetmask
				$subnetmask = Number(BinaryMid($options, $i + 2, 1)) & "." & Number(BinaryMid($options, $i + 3, 1)) & "." & Number(BinaryMid($options, $i + 4, 1)) & "." & Number(BinaryMid($options, $i + 5, 1))
				ConsoleWrite("Subnetmask: " & $subnetmask & @CRLF)
			Case 2 ; time offset
				$time_offset = Number(BinaryMid($options, $i + 2, 4))
				ConsoleWrite("Time Offset: " & $time_offset & @CRLF)
			Case 3 ; Router Option														; not working properly

			Case 6 ; DNS-Servers
				$dns_servers_count = $length/4
				for $j = 0 to $dns_servers_count-1
					$dns_servers = Number(BinaryMid($options, $i + 2 + ($j*4), 1)) & "." & Number(BinaryMid($options, $i + 3+ ($j*4), 1)) & "." & Number(BinaryMid($options, $i + 4+ ($j*4), 1)) & "." & Number(BinaryMid($options, $i + 5+ ($j*4), 1))
					ConsoleWrite("dns server: " & $dns_servers & @CRLF)
				Next
			Case 12; Client Hostname
				$Host_Name = StringReplace(BinaryToString(BinaryMid($options, $i + 2, $length)), Chr(0), "")
				ConsoleWrite("Host Name: " & $Host_Name & @CRLF)
			Case 43 ; Vendor-specific information
				$vendor_specific_info = StringReplace(BinaryToString(BinaryMid($options, $i + 2, $length)), Chr(0), "")
				ConsoleWrite("Vendor-specific information: " & $vendor_specific_info & @CRLF)
			Case 51 ; Address lease time														; not working properly
				$lease_time = Number(BinaryMid($options, $i + 2, 4))
				$sNewDate = _DateAdd('s', $lease_time, _NowCalcDate())
				ConsoleWrite("Lease Time: " & $sNewDate & @CRLF)
			Case 53 ; DHCP Message type
				Switch Number(BinaryMid($options, $i + 2, 1))
					Case 1
						ConsoleWrite("DHCPDISCOVER" & @CRLF)
					Case 2
						ConsoleWrite("DHCPOFFER" & @CRLF)
					Case 3
						ConsoleWrite("DHCPREQUEST" & @CRLF)
					Case 4
						ConsoleWrite("DHCPDECLINE" & @CRLF)
					Case 5
						ConsoleWrite("DHCPACK" & @CRLF)
					Case 6
						ConsoleWrite("DHCPNAK" & @CRLF)
					Case 7
						ConsoleWrite("DHCPRELEASE" & @CRLF)
					Case 8
						ConsoleWrite("DHCPINFORM" & @CRLF)
					Case Else; Armageddon!!!
				EndSwitch
			Case 54 ; Server Identifier
				$server_identifier = Number(BinaryMid($options, $i + 2, 1)) & "." & Number(BinaryMid($options, $i + 3, 1)) & "." & Number(BinaryMid($options, $i + 4, 1)) & "." & Number(BinaryMid($options, $i + 5, 1))
				ConsoleWrite("Server Identifier: " & $server_identifier & @CRLF)
			Case 55 ; Parameter Request List
				$parameter_request_list = BinaryMid($options, $i + 2, $length)
				ConsoleWrite("Parameter Request List: " & $parameter_request_list & @CRLF)
			Case 60 ; Class-Identifier
				$class_identifier = StringReplace(BinaryToString(BinaryMid($options, $i + 2, $length)), Chr(0), "")
				ConsoleWrite("Class-Identifier: " & $class_identifier & @CRLF)
			Case 61 ; Identifier
				$identifier = BinaryMid($options, $i + 2, $length)
				ConsoleWrite("Identifier: " & $identifier & @CRLF)
			Case 81 ; FQDN
				$FQDN = StringReplace(BinaryToString(BinaryMid($options, $i + 2, $length)), Chr(0), "")
				ConsoleWrite("FQDN: " & $FQDN & @CRLF)
			Case 255 ; end
				$i = BinaryLen($options)
			Case Else; Armageddon!!!

		EndSwitch
		$i += (2 + $length)
	Until $i >= BinaryLen($options) ; unclean but prevents the loop from continuing infinite if a counting error occures.
	Return False ; until everything is in a 2d array.....
EndFunc   ;==>_DHCP_Options_Parser
