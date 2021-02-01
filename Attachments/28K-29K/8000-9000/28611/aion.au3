#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIComboBox.au3>
#include <Constants.au3>
#include <WinAPI.au3>
#include <array.au3>
#include <Winpcap.au3>
#include <blowfish.au3>
#include <string.au3>
#include <decrypt.au3>

$filter = "tcp port 7777"


#cs
length 63 byte
0x09000054FF462C263D
0x09000054FFC82995D6
#ce

Global $in = 0, $out = 0
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

$int = $pcap_devices[SelectInterface($pcap_devices)][0]

$pcap = _PcapStartCapture($int, $filter, 0)
If ($pcap = -1) Then
	MsgBox(16, "Pcap error !", _PcapGetLastError())
EndIf

While True
	If IsPtr($pcap) Then
		$time0 = TimerInit()
		While (TimerDiff($time0) < 500) ; Retrieve packets from queue for maximum 500ms before returning to main loop, not to "hang" the window for user
			$packet = _PcapGetPacket($pcap)
			If IsInt($packet) Then ExitLoop
			$aion = aion($packet[3])
			If $aion <> False Then ConsoleWrite($aion & @CRLF)
		WEnd
	EndIf
	Sleep(1)
	ToolTip("In: " & $in & " Out: " & $out,0,0)
WEnd

_PcapStopCapture($pcap)
_PcapFree()

Func aion($data)
	Local $ipheaderlen = BitAND(_PcapBinaryGetVal($data, 15, 1), 0xF) * 4
	Local $tcpoffset = $ipheaderlen + 14
	Local $tcplen = _PcapBinaryGetVal($data, 17, 2) - $ipheaderlen ; ip total len - ip header len
	Local $tcpheaderlen = BitShift(_PcapBinaryGetVal($data, $tcpoffset + 13, 1), 4) * 4
	Local $tcpsrcport = _PcapBinaryGetVal($data, $tcpoffset + 1, 2)
	Local $tcpdstport = _PcapBinaryGetVal($data, $tcpoffset + 3, 2)
	Local $tcpsequence = _PcapBinaryGetVal($data, $tcpoffset + 5, 4)
	Local $tcpflags = _PcapBinaryGetVal($data, $tcpoffset + 14, 1)
	Local $httpoffset = $tcpoffset + $tcpheaderlen + 1
	Local $httplen = $tcplen - $tcpheaderlen
	$aion_packet = BinaryMid($data, $httpoffset)
	; From here, we are watching aion payload
	decrypt($aion_packet)
	If $httplen = 0 Then Return False ; empty tcp packet
	If $tcpsrcport = 7777 Then
		$in += 1
		Return ">IN :" & padd(_PcapBinaryGetVal($aion_packet, 1, 1), 5) & padd(BinaryLen($aion_packet),5) & $aion_packet ; game server	==> client
	EndIf
	If $tcpdstport = 7777 Then
		$out += 1
		Return "-OUT:" & padd(_PcapBinaryGetVal($aion_packet, 1, 1), 5) & padd(BinaryLen($aion_packet),5) & $aion_packet ; client 		==> game server
	EndIf
EndFunc   ;==>aion

Func SelectInterface($devices) ; auto selects an ethernet pcap interface or prompt user for choice
	Local $ipv4 = 0, $int = 0, $i, $win0, $first, $interface, $ok, $which, $msg, $txt
	For $i = 0 To UBound($devices) - 1
		If $devices[$i][3] = "EN10MB" And StringLen($devices[$i][7]) > 6 Then ; for ethernet devices with valid ip address only !
			$ipv4 += 1
			$int = $i
		EndIf
	Next
	If $ipv4 = 0 Then
		MsgBox(16, "Error", "No network interface found with a valid IPv4 address !")
		_PcapFree()
		Exit
	EndIf
	If $ipv4 > 1 Then
		$win0 = GUICreate("Interface choice", 500, 50)
		$interface = GUICtrlCreateCombo("", 10, 15, 400, Default, $CBS_DROPDOWNLIST)
		$first = True
		$gateway = Default_gateway()
		For $i = 0 To UBound($devices) - 1
			If $devices[$i][3] = "EN10MB" And StringLen($devices[$i][7]) > 6 Then
				$gw = ""
				If $devices[$i][7] = $gateway Then $gw = "Default GW: "
				If $first Then
					GUICtrlSetData(-1, $gw & $devices[$i][7] & " - " & _PcapCleanDeviceName($devices[$i][1]), $gw & $devices[$i][7] & " - " & _PcapCleanDeviceName($devices[$i][1]))
					$first = False
				Else
					GUICtrlSetData(-1, $gw & $devices[$i][7] & " - " & _PcapCleanDeviceName($devices[$i][1]))
				EndIf
			EndIf
		Next
		$ok = GUICtrlCreateButton(" Ok ", 430, 15, 60)
		GUISetState()
		For $i = 0 To UBound($devices) - 1
			If $devices[$i][7] = $gateway Then
				_GUICtrlComboBox_SetCurSel($interface, $i)
			EndIf
		Next
		While True
			$msg = GUIGetMsg()
			If $msg = $ok Then
				$which = GUICtrlRead($interface)
				For $i = 0 To UBound($devices) - 1
					If StringLen($devices[$i][7]) > 6 And StringInStr($which, $devices[$i][7]) Then
						$int = $i
						ExitLoop
					EndIf
				Next
				GUIDelete($win0)
				ExitLoop
			EndIf
			If $msg = $GUI_EVENT_CLOSE Then Exit
		WEnd
	EndIf
	Return $int
EndFunc   ;==>SelectInterface

Func Default_gateway()
	Local $foo = Run(@ComSpec & " /c route print", @SystemDir, @SW_HIDE, $STDOUT_CHILD)
	Local $line, $all, $gateway
	While 1
		$line = StdoutRead($foo)
		If @error Then ExitLoop
		$all &= $line
	WEnd
	$a_all = StringSplit($all, @CRLF, 1)
	For $i = 1 To $a_all[0]
		If StringInStr($a_all[$i], "0.0.0.0", 1, 1) Then
			$gateway = $a_all[$i]
			ExitLoop
		EndIf
	Next
	$a_gateway = StringSplit($gateway, "    ", 1)
	$gateway = $a_gateway[7]
	Return $gateway
EndFunc   ;==>Default_gateway

Func padd($txt, $len)
	Return $txt & StringTrimLeft(_StringRepeat(" ", $len), StringLen($txt))
EndFunc   ;==>padd
