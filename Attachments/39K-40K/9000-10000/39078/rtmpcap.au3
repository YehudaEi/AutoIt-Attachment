#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=by Jan Reiss
#AutoIt3Wrapper_Res_Description=Putpat.tv downloader
#AutoIt3Wrapper_Res_Fileversion=0.1
#AutoIt3Wrapper_Res_LegalCopyright=by Jan Reiss 2012 www.jan-reiss.de
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; rtmpcap derived from httpcap file capture v1.0e Copyleft GPL3 Nicolas Ricquemaque 2009-2011
; Copyleft GPL3 Jan Reiss (www.jan-reiss.de) 2005-2012

#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>

#include <Winpcap.au3>

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

$int = SelectInterface($pcap_devices)

$pcap = _PcapStartCapture($pcap_devices[$int][0], "host " & $pcap_devices[$int][7] & " and tcp port 80", 0, 65536, 2 ^ 24, 0)
If IsInt($pcap) Then
	MsgBox(16, "Pcap error !", _PcapGetLastError())
	_PcapFree()
	Exit
EndIf

Do
	If IsPtr($pcap) Then ; If $pcap is a Ptr, then the capture is running
		$time0 = TimerInit()
		While (TimerDiff($time0) < 500) ; Retrieve packets from queue for maximum 500ms before returning to main loop, not to "hang" the window for user
			$packet = _PcapGetPacket($pcap)
			If IsInt($packet) Then ExitLoop
			HttpCapture($packet[3])
		WEnd
	EndIf
Until False

_PcapStopCapture($pcap)
_PcapFree()

Exit

Func HttpCapture($data)
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
	If $httplen = 0 Then Return False
	Local $http = BinaryToString(BinaryMid($data, $httpoffset, $httplen))
	dumprtmp($http)
EndFunc   ;==>HttpCapture

Func SelectInterface($devices) ; auto selects an ethernet pcap interface or prompt user for choice
	Local $ipv4 = 0, $int = 0, $i, $win0, $first, $interface, $ok, $which, $msg
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
		For $i = 0 To UBound($devices) - 1
			If $devices[$i][3] = "EN10MB" And StringLen($devices[$i][7]) > 6 Then
				If $first Then
					GUICtrlSetData(-1, $devices[$i][7] & " - " & _PcapCleanDeviceName($devices[$i][1]), $devices[$i][7] & " - " & _PcapCleanDeviceName($devices[$i][1]))
					$first = False
				Else
					GUICtrlSetData(-1, $devices[$i][7] & " - " & _PcapCleanDeviceName($devices[$i][1]))
				EndIf
			EndIf
		Next
		$ok = GUICtrlCreateButton(" Ok ", 430, 15, 60)
		GUISetState()
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

Func dumprtmp($http)
	Local $line = StringSplit($http, @CRLF)
	Local $counti
	For $counti = 1 To $line[0]

		If StringInStr($line[$counti], "<medium>rtmp://") Then
			If StringInStr($line[$counti], "</medium>") Then
				$med = StringStripWS($line[$counti], 8)
				$med = StringTrimRight(StringTrimLeft($med, 8), 9)
				call_rtmpdump($med)

			EndIf
		EndIf
	Next
EndFunc   ;==>dumprtmp

Func call_rtmpdump($path)
	$exec = 'rtmpdump.exe -r "rtmp://tvrlfs.fplive.net:1935/tvrl" -a "tvrl" -f "WIN 11,3,376,12" -W "http://files.putpat.tv/putpat_player/263/PutpatPlayer.swf" -p "http://www.putpat.tv/" -y "' & StringMid($path, 157, 37) & '?token=' & StringMid($path, 37, 120) & '" -o ' & StringMid($path, 175, 15) & '.flv'
	ConsoleWrite($exec & @CRLF)
	if not existsinqueue(StringMid($path, 175, 15) & '.flv') then FileWriteLine("queue.bat", $exec)
EndFunc   ;==>call_rtmpdump

Func existsinqueue($name)
	Local $file = FileOpen("queue.bat", 0)
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf

	While 1
		Local $line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		If StringInStr($line, $name) Then Return True
	WEnd
	Return False
	FileClose($file)
EndFunc   ;==>existsinqueue