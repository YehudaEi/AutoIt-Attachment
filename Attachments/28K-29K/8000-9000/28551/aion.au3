#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#Include <WinAPI.au3>
#include <array.au3>
#include <Winpcap.au3>
#include <blowfish.au3>

$filter = "tcp port 7777 or tcp port 2106"


$winpcap=_PcapSetup()
If ($winpcap=-1) Then
	MsgBox(16,"Pcap error !","WinPcap not found !")
	exit
EndIf

$pcap_devices=_PcapGetDeviceList()
If ($pcap_devices=-1) Then
	MsgBox(16,"Pcap error !",_PcapGetLastError())
	exit
EndIf

$int=$pcap_devices[SelectInterface($pcap_devices)][0]

$pcap=_PcapStartCapture($int,$filter,0)
If ($pcap=-1) Then
	MsgBox(16,"Pcap error !",_PcapGetLastError())
EndIf

While True
If IsPtr($pcap) Then
	$time0=TimerInit()
	While (TimerDiff($time0)<500) ; Retrieve packets from queue for maximum 500ms before returning to main loop, not to "hang" the window for user
		$packet=_PcapGetPacket($pcap)
		If IsInt($packet) Then ExitLoop
		$aion = aion($packet[3])
		if $aion <> False Then ConsoleWrite($aion & @CRLF)
	Wend
EndIf
Sleep(1)
WEnd

_PcapStopCapture($pcap)
_PcapFree()

Func aion($data)
	Local $ipheaderlen=BitAnd(_PcapBinaryGetVal($data,15,1),0xF)*4
	Local $tcpoffset=$ipheaderlen+14
	Local $tcplen=_PcapBinaryGetVal($data,17,2)-$ipheaderlen  ; ip total len - ip header len
	Local $tcpheaderlen=BitShift(_PcapBinaryGetVal($data, $tcpoffset+13,1),4)*4
	Local $tcpsrcport=_PcapBinaryGetVal($data,$tcpoffset+1,2)
	Local $tcpdstport=_PcapBinaryGetVal($data,$tcpoffset+3,2)
	Local $tcpsequence=_PcapBinaryGetVal($data,$tcpoffset+5,4)
	Local $tcpflags=_PcapBinaryGetVal($data, $tcpoffset+14,1)
	Local $httpoffset=$tcpoffset+$tcpheaderlen+1
	Local $httplen=$tcplen-$tcpheaderlen
	$aion_packet = BinaryMid($data,$httpoffset)
	; From here, we are watching aion payload
	If $httplen=0 Then return false ; empty tcp packet
	if $tcpsrcport = 2106 Then Return "+" & $aion_packet ; login server ==> client
	if $tcpdstport = 2106 Then Return "!" & $aion_packet ; client 		==> login server
	if $tcpsrcport = 7777 Then Return ">" & $aion_packet ; game server	==> client
	if $tcpdstport = 7777 Then Return "-" & $aion_packet ; client 		==> game server
EndFunc

Func SelectInterface($devices) ; auto selects an ethernet pcap interface or prompt user for choice
	Local $ipv4=0,$int=0,$i,$win0,$first,$interface,$ok,$which,$msg
	For $i=0 To Ubound($devices)-1
		If $devices[$i][3]="EN10MB" AND StringLen($devices[$i][7])>6 Then ; for ethernet devices with valid ip address only !
			$ipv4+=1
			$int=$i
		EndIf
	Next
	If $ipv4=0 Then
		MsgBox(16,"Error","No network interface found with a valid IPv4 address !")
		_PcapFree()
		Exit
	EndIf
	If $ipv4>1 Then
		$win0=GUICreate("Interface choice", 500, 50)
		$interface=GUICtrlCreateCombo("", 10, 15, 400,default,$CBS_DROPDOWNLIST)
		$first=true
		For $i = 0 to Ubound($devices)-1
			If $devices[$i][3]="EN10MB" AND StringLen($devices[$i][7])>6 Then
				If $first Then
					GUICtrlSetData(-1, $devices[$i][7]&" - "&_PcapCleanDeviceName($devices[$i][1]),$devices[$i][7]&" - "&_PcapCleanDeviceName($devices[$i][1]))
					$first=false
				Else
					GUICtrlSetData(-1, $devices[$i][7]&" - "&_PcapCleanDeviceName($devices[$i][1]))
				EndIf
			EndIf
		Next
		$ok=GUICtrlCreateButton ( " Ok ", 430, 15,60)
		GUISetState()
		While true
			$msg = GUIGetMsg()
			If $msg=$ok Then
				$which=GUICtrlRead($interface)
				For $i=0 To Ubound($devices)-1
					If StringLen($devices[$i][7])>6 AND StringInStr($which,$devices[$i][7]) Then
						$int=$i
						ExitLoop
					EndIf
				Next
				GUIDelete($win0)
				ExitLoop
			EndIf
			If $msg=$GUI_EVENT_CLOSE Then Exit
		Wend
	EndIF
	return $int
EndFunc

#cs
enum SERVER_OPCODE_TYPE
{
   SM_INIT            = 0x00,
   SM_LOGIN_FAIL      = 0x01,
   SM_ACCOUNT_BLOCKED   = 0x02
   SM_LOGIN_OK         = 0x03,
   SM_SERVER_LIST      = 0x04,
   SM_SERVER_LIST_FAIL = 0x05,
   SM_PLAY_FAIL      = 0x06,
   SM_PLAY_OK         = 0x07,
   SM_ACCOUNT_KICKED   = 0x08,
   SM_ACCOUNT_BLOCKED_WITH_MSG = 0x09,
   SM_AUTH_GG         = 0x0B,
   SM_UPDATE_SESSION   = 0x0C,
};

enum CLIENT_OPCODE_TYPE
{
   CM_LOGIN      = 0x00,
   CM_PLAY         = 0x02,
   CM_LOGOUT      = 0x03,
   CM_SERVER_LIST   = 0x05,
   CM_AUTH_GG      = 0x07,
   CM_UPDATE_SESSION = 0x08,
};
#ce
