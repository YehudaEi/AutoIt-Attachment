#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "winpcap.au3"

Global $pcap
Global $iScan = 0
Global $iAlive = 0
;declare array that will be filled with what ip's we will be scanning
Dim $aIPSendArray[2] = [1, 0]
Dim $aAliveHosts[1] = [0]

; initialise the Library
$winpcap = _PcapSetup()
If ($winpcap = -1) Then
	ConsoleWrite("WinPcap not found!")
	Exit
EndIf

; Get the interfaces list for which a capture is possible
$pcap_devices = _PcapGetDeviceList()
If ($pcap_devices = -1) Then
	ConsoleWrite(_PcapGetLastError())
	Exit
EndIf

;
$tmp = 0
For $i = 0 To UBound($pcap_devices) - 1
	; look for Ethernet adapter with valid IP and MAC address that is not WMvare virtual.
	If IsIPAddress($pcap_devices[$i][7]) and $pcap_devices[$i][7]<>"0.0.0.0" and $pcap_devices[$i][3] == "EN10MB" And StringInStr($pcap_devices[$i][6], '00:50:56:') == 0 Then
		$tmp += 1
		$iInput = $i + 1
		$sAdapterName = StringMid($pcap_devices[$i][1], StringInStr($pcap_devices[$i][1], "'", 0, 1) + 1)
		$sAdapterName = StringMid($sAdapterName, 1, StringInStr($sAdapterName, "'", 0, 1) - 1)
		ConsoleWrite($i + 1 & ". " & $sAdapterName & " (MAC Address: " & $pcap_devices[$i][6] &" IP:"&$pcap_devices[$i][7]& ")" & @CRLF)
	EndIf
Next
If $tmp == 0 Then
	ConsoleWrite("No Net adapter found." & @CRLF)
	Exit
EndIf

; use console input to set the adapter index
If $tmp > 1 Then
	ConsoleWrite("Choose Adapter: ")
	$iInput = Number(cmdRead())
	;$iInput = 4 ;debug
EndIf

; validate console input
If $iInput > $i Or $iInput < 1 Then
	ConsoleWrite("No such adapter." & @CRLF)
	Exit
EndIf

; Zero based index
$iInput -= 1

ConsoleWrite(@CRLF)

; start capture only UDP packets
$pcap = _PcapStartCapture($pcap_devices[$iInput][0], "udp", 1)
If ($pcap = -1) Then
	ConsoleWrite(_PcapGetLastError())
	Exit
EndIf

scan()

_PcapStopCapture($pcap)
_PcapFree()

Func scan()

	$t = TimerInit()
	$tmout = 100
	$ops = 0

	; capture only for 60 sec.
	While TimerDiff($t) < 60000

		; call func getPacket for every packet in the buffer
		; when there is not packets left in the buffer
		; returns # of packets processed (times func was called)
		$ops = _PcapDispatchToFunc($pcap, "getPacket")

		; fancy: adjust Sleep time to amount fo the packets comming in the buffer
		If $ops > 1 Then
			$tmout -= $ops*10
			if $tmout < 1 then $tmout = 1
		ElseIf $ops == 0 And $tmout < 1000 Then
			$tmout += 10
		EndIf

		;c($ops&@tab&$tmout)

		Sleep($tmout)
	WEnd
EndFunc   ;==>scan


;function that runs everytime we get a packet
Func getPacket($packet)

		; source port in HEX
		$srcPort = StringMid($packet[3], 71, 4)

		; if source port is DHCP server Dec 67 = Hex 43
		If ($srcPort == "0043") Then
			c("DHCP Server responds (MAC "&StringMid($packet[3], 15, 12)&"; IP HEX "&StringMid($packet[3], 55, 8)&") Offering IP HEX "&StringMid($packet[3], 119, 8))
			;c("Packet: "&$packet[3])
			c()
		EndIf

		; if target port is DHCP client Dec 68 = Hex 44
		If ($srcPort == "0044") Then
			if StringMid($packet[3], 87, 2) == "01" Then
				c("Asking for IP and PXE BOOT FILE (MAC "&StringMid($packet[3], 15, 12)&")")
			Else
				c("Asking for IP (MAC "&StringMid($packet[3], 15, 12)&")")
			EndIf
			;c("Packet: "&$packet[3])
			c()
		EndIf

EndFunc   ;==>getPacket

Func IsIPAddress($text)
	Return StringRegExp($text, "(((25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([1-9]?[0-9]))\.){3}((25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([1-9]?[0-9]))")
EndFunc   ;==>IsIPAddress

Func cmdRead()
	Local $input = ""
	$file = FileOpen("con", 4)
	While 1
		$chr = FileRead($file, 1)
		If $chr = @LF Then ExitLoop
		$input &= BinaryToString($chr)
		Sleep(50)
	WEnd
	FileClose($file)
	$input = StringReplace($input, @CR, "")
	Return $input
EndFunc   ;==>cmdRead

Func c($txt="")
	ConsoleWrite($txt & @CRLF)
EndFunc   ;==>c
