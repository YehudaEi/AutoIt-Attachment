#include <Misc.au3>

Func xml_encode($val)
	Return StringReplace(StringReplace(StringReplace($val, "&", "&amp;"), "<", "&lt;"), ">", "&gt;")
EndFunc

Func xml_makeNode($tag, $val)
	If StringLen($val) = 0 Then Return ""
	ConsoleWrite($tag & "=" & $val & @CRLF)
	Return "<" & StringUpper($tag) & ">" & xml_encode($val) & "</" & StringUpper($tag) & ">" & @CRLF
EndFunc

Func net_getMACIDFromIP($ip_addr)
    Local $MAC_struct = DllStructCreate("byte[6]")
    Local $MAC_size = DllStructCreate("int")
    DllStructSetData($MAC_size, 1, 6)
    Local $rc = DllCall("Ws2_32.dll", "int", "inet_addr", "str", $ip_addr)
	Local $in_addr = $rc[0]
    $rc = DllCall("iphlpapi.dll", "int", "SendARP", "int", $in_addr, "int", 0, "ptr", DllStructGetPtr($MAC_struct), "ptr", DllStructGetPtr($MAC_size))
	If $rc[0] <> 0 Then Return ""
    Local $str = ""
    For $i = 1 To 6
        If $i > 1 Then $str = $str & ":"
        $str &= Hex(DllStructGetData($MAC_struct, 1, $i), 2)
    Next
    Return $str
EndFunc

Func _IPH_Capture()
;; returns an XML string of all the adapter details
	Local $hDllFile = DllOpen("iphlpapi.dll")
	Local $xml_str = "<NETWORK_INFO>" & @CRLF
	__IPH_AdaptersCapture($hDllFile, $xml_str)
	Local $ec = @error
	If $ec <> 0 Then
		$xml_str &= "<ERROR>" & @CRLF
		$xml_str &= xml_makeNode("FUNCTION", "__IPH_AdaptersCapture")
		$xml_str &= xml_makeNode("CODE", $ec)
		$xml_str &= "</ERROR>" & @CRLF
	Else
		__IPH_MetricsCapture($hDllFile, $xml_str)
	EndIf
	$xml_str &= "</NETWORK_INFO>" & @CRLF
	DllClose($hDllFile)
	Return $xml_str
EndFunc

Func net_isValidIP($ip)
;; returns true if $ip appears to be valid
	If StringInStr($ip, ".", 1, 3) = 0 Then Return False
	If $ip = "0.0.0.0" Then Return False
	If $ip = "255.255.255.255" Then Return False
	Return True
EndFunc

Func net_convertToTimestamp($val)
;; would be nice to convert this number to a readable date and time format
	Return $val
EndFunc

Func __IPH_AdaptersCapture($hDllFile, ByRef $xml_str)
	#cs
	$IPAS is the _IP_ADDR_STRING structure:
		+0 struct _IP_ADDR_STRING* Next;	I pretty much ignore this all the time
		+1	IP_ADDRESS_STRING IpAddress;	char[4 * 4]
		+2	IP_MASK_STRING IpMask;
		+3	DWORD Context;
	this structure is used inside others a lot; you need to add 1 to the index to get the IP
	#ce
	Local Const $IPAS = "ptr;char[16];char[16];dword"
	#cs
	$IPAI is the _IP_ADAPTER_INFO structure:
		1	struct _IP_ADAPTER_INFO* Next;
		2	DWORD ComboIndex;
		3*	char AdapterName[MAX_ADAPTER_NAME_LENGTH + 4];  (260)
		4*	char Description[MAX_ADAPTER_DESCRIPTION_LENGTH + 4];  (132)
		5	UINT AddressLength;
		6*	BYTE Address[MAX_ADAPTER_ADDRESS_LENGTH];  (8)
		7*	DWORD Index;
		8*	UINT Type;							(ETHERNET=Y if Type=6)
		9*	UINT DhcpEnabled;
		10	PIP_ADDR_STRING CurrentIpAddress;
		11*	IP_ADDR_STRING IpAddressList;		(12=IP, 13=SUBNET_MASK)
		15*	IP_ADDR_STRING GatewayList;			(16=GATEWAY_IP)
		19*	IP_ADDR_STRING DhcpServer;			(20=DHCP_SERVER)
		23*	BOOL HaveWins;
		24*	IP_ADDR_STRING PrimaryWinsServer;	(25=WINS_1)
		28*	IP_ADDR_STRING SecondaryWinsServer;	(29=WINS_2)
		32*	time_t LeaseObtained;
		33*	time_t LeaseExpires;
	#ce
	Local Const $nNumIPAIFields = 33
	Local Const $IPAI = "ptr;dword;char[260];char[132];uint;byte[8];dword;uint;uint;ptr;" & $IPAS & ';' & $IPAS & ';' & $IPAS & ";int;" & $IPAS & ';' & $IPAS & ";long;long"
	Local Const $IPAI_tags = StringSplit("x;x;GUID;DESC;x;MAC;INDEX;ETHERNET;DHCP_ENABLED;x;x;IP;SUBNET_MASK;x;x;GATEWAY_IP;x;x;x;DHCP_SERVER;x;x;WINS_ENABLED;x;WINS_1;x;x;x;WINS_2;x;x;LEASE_OBTAINED;LEASE_EXPIRES", ";")
	If $IPAI_tags[0] <> $nNumIPAIFields Then
		ConsoleWriteError("$IPAI_tags needs to be fixed" & @CR)
		Return SetError(-1)
	EndIf
	Local $stIPAI = DllStructCreate($IPAI)
	;; first call to GetAdaptersInfo() is to determine the buffer size required
	Local $nBufLen = 0
	Local $rc = DllCall($hDllFile, "dword", "GetAdaptersInfo", "ptr", 0, "long*", $nBufLen)
	If @error <> 0 Or $rc[0] <> 111 Then		;; expecting ERROR_BUFFER_OVERFLOW and buffer size
		ConsoleWriteError("GetAdaptersInfo() - bad return code of " & $rc[0] & @CR)
		Return SetError(1)
	EndIf
	$nBufLen = $rc[2]
	;; build a structure large enough to hold the information passed back
	Local $stAdapterInfo = DllStructCreate($IPAI & ";ubyte[" & String($nBufLen - DllStructGetSize($stIPAI)) & "]")
	;; now we can capture all of the adapter information in one call to GetAdaptersInfo()
	$rc = DllCall($hDllFile, "dword", "GetAdaptersInfo", "ptr", DllStructGetPtr($stAdapterInfo), "long*", $nBufLen)
	If @error <> 0 Or $rc[0] <> 0 Then
		ConsoleWriteError("GetAdaptersInfo() - bad return code of " & $rc[0] & @CR)
		Return SetError(3)
	EndIf
	#cs $IFROW is the _MIB_IFROW structure
		1	WCHAR wszName[256];
		2	DWORD dwIndex;
		3	DWORD dwType;
		4*	DWORD dwMtu;
		5*	DWORD dwSpeed;
		6	DWORD dwPhysAddrLen;
		7	BYTE bPhysAddr[8];
		8*	DWORD dwAdminStatus;
		9*	DWORD dwOperStatus; 0=NON_OPERATIONAL, 1=UNREACHABLE, 2=DISCONNECTED, 3=CONNECTING, 4=CONNECTED, 5=OPERATIONAL
		10*	DWORD dwLastChange;
		11*	DWORD dwInOctets;
		12*	DWORD dwInUcastPkts;
		13*	DWORD dwInNUcastPkts;
		14*	DWORD dwInDiscards;
		15*	DWORD dwInErrors;
		16*	DWORD dwInUnknownProtos;
		17*	DWORD dwOutOctets;
		18*	DWORD dwOutUcastPkts;
		19*	DWORD dwOutNUcastPkts;
		20*	DWORD dwOutDiscards;
		21*	DWORD dwOutErrors;
		22*	DWORD dwOutQLen;
		23	DWORD dwDescrLen;
		24	BYTE bDescr[256];
	#ce
	Local Const $nNumIFROWFields = 24
	Local Const $IFROW = "short[256];dword;dword;dword;dword;dword;char[8];dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;char[256]"
	Local Const $IFROW_tags = StringSplit("x;x;x;MTU;SPEED;x;x;ADMIN_STATUS;OPERATIONAL_STATUS;LAST_CHANGE;RECEIVED_OCTETS;RECEIVED_UNICAST_PKTS;RECEIVED_OTHER_PKTS;RECEIVED_DISCARDS;RECEIVED_ERRORS;UNKNOWN_PROTOCOLS;SENT_OCTETS;SENT_UNICAST_PACKETS;SENT_OTHER_PACKETS;SENT_DISCARDS;SENT_ERRORS;SENT_QUEUE_LEN;x;x", ";")
	If $IFROW_tags[0] <> $nNumIFROWFields Then
		ConsoleWriteError("$IFROW_tags needs to be fixed" & @CR)
		Return SetError(-1)
	EndIf
	Local $stIFROW = DllStructCreate($IFROW)
	#cs
	$IPPAI is the _IP_PER_ADAPTER_INFO structure:
		1*	UINT AutoconfigEnabled;
		2*	UINT AutoconfigActive;
		3	PIP_ADDR_STRING CurrentDnsServer;
		4*	IP_ADDR_STRING DnsServerList;	(5=DNS_1, 9=DNS_2, 13=DNS_3)
	#ce
	Local Const $nNumIPPAIFields = 15
	Local Const $IPPAI = "uint;uint;ptr;" & $IPAS & ';' & $IPAS & ';' & $IPAS		;; allow for up to 3 DNS machines
	Local Const $IPPAI_tags = StringSplit("APIPA_ENABLED;APIPA_ACTIVE;x;x;DNS_1;x;x;x;DNS_2;x;x;x;DNS_3;x;x", ";")
	If $IPPAI_tags[0] <> $nNumIPPAIFields Then
		ConsoleWriteError("$IPPAI_tags needs to be fixed" & @CR)
		Return SetError(-1)
	EndIf
	Local $stIPPAI = DllStructCreate($IPPAI)
	;; here's the variables for the registry scan
	Local Const $sRegistryRoot = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\"
	Local Const $sRegistryGUID = "{4D36E972-E325-11CE-BFC1-08002BE10318}"
	Local Const $REG_keys = StringSplit("IpCheckingEnabled;MediaSubType;Name;PnpInstanceID;ShowIcon", ";")
	Local Const $REG_tags = StringSplit("IP_CHECKING_ENABLED;MEDIA_SUB_TYPE;SHORTCUT_NAME;PNP_INSTANCE_ID;ICON_ENABLED", ";")
	Local Const $REG_keys2 = StringSplit("DriverVersion;DriverDate;ProviderName;DriverDesc;MatchingDeviceId", ";")
	Local Const $REG_tags2 = StringSplit("DRIVER_VERSION;DRIVER_DATE;DRIVER_PROVIDER;DRIVER_DESCRIPTION;DEVICE_ID", ";")
	If $REG_keys[0] <> $REG_tags[0] Then
		ConsoleWriteError("$REG_keys and $REG_tags do not match" & @CR)
		Return SetError(-1)
	EndIf
	;; now we need to call GetIfEntry() and GetPerAdapterInfo() to get additional information for each adapter
	Local $bFirst = True
	While True
		If $bFirst Then	;; copy the first structure returned
			$stIPAI = DllStructCreate($IPAI, DllStructGetPtr($stAdapterInfo))
		Else			;; create structure based on the 'Next' pointer in the previous structure
			$stIPAI = DllStructCreate($IPAI, DllStructGetData($stIPAI, 1))
		EndIf
		If @error Then ExitLoop
		$bFirst = False
		Local $guid = ""
		Local $nAdapterIndex = DllStructGetData($stIPAI, 7)
		$xml_str &= "<ADAPTER>" & @CRLF
		;; now we will add XML tags for each of the important fields in the _IP_ADAPTER_INFO structure
		Local $dhcp_enabled = False
		Local $dhcp_server = ""
		Local $ip_addr = ""
		Local $gateway_ip = ""
		For $fld = 1 To $nNumIPAIFields
			Local $tag = $IPAI_tags[$fld]
			If $tag = "x" Then ContinueLoop	;; we can skip this field
			Local $val = DllStructGetData($stIPAI, $fld)
			If StringLen($val) = 0 Then ContinueLoop
			Switch $tag
			Case "GUID"
				$guid = $val
			Case "MAC"						;; "0x0013CE7A8EC20000" -> "00:13:CE:7A:8E:C2"
				If StringLen($val) = 18 Then $val = StringMid($val, 3, 2) & ":" & StringMid($val, 5, 2) & ":" & StringMid($val, 7, 2) & ":" & StringMid($val, 9, 2) & ":" & StringMid($val, 11, 2) & ":" & StringMid($val, 13, 2)
			Case "DHCP_ENABLED"				;; special handling for DHCP flag
				If $val = "1" Then
					$dhcp_enabled = True
					$val = "Y"
				Else
					$val = "N"
				EndIf
			Case "WINS_ENABLED"				;; 1->Y and 0->N
				$val = _Iif($val = "1", "Y", "N")
			Case "ETHERNET"					;; if Type is 6 then it's Ethernet
				$val = _Iif($val = "6", "Y", "N")
			Case "IP", "DHCP_SERVER", "WINS_1", "WINS_2", "SUBNET_MASK", "GATEWAY_IP"
				if Not net_isValidIP($val) Then $val = ""
				If $tag = "DHCP_SERVER" Then
					$dhcp_server = $val
				ElseIf $tag ="IP" Then
					$ip_addr = $val
				ElseIf $tag = "GATEWAY_IP" Then
					$gateway_ip = $val
					;; if you ARP to the gateway, then you can discover the type of router you are using
					$xml_str &= xml_makeNode("GATEWAY_MAC", net_getMACIDFromIP($gateway_ip))
				EndIf
			Case "LEASE_OBTAINED", "LEASE_EXPIRES"
				$val = net_convertToTimestamp($val)
			EndSwitch
			$xml_str &= xml_makeNode($tag, $val)
		Next
		;; call GetIFEntry() for a specific adapter to get adapter stats and additional info like MTU and speed
		DllStructSetData($stIFROW, 2, $nAdapterIndex)
		$rc = DllCall($hDllFile, "dword", "GetIfEntry", "ptr", DllStructGetPtr($stIFROW))
		If @error <> 0 Or $rc[0] <> 0 Then
			ConsoleWriteError("GetIfEntry() - bad return code of " & $rc[0] & @CR)
			$xml_str &= "</ADAPTER>" & @CRLF
			Return SetError(4)
		EndIf
		Local $operational = False
		For $fld = 1 To $nNumIFROWFields
			Local $tag = $IFROW_tags[$fld]
			If $tag = "x" Then ContinueLoop	;; we can skip this field
			Local $val = DllStructGetData($stIFROW, $fld)
			If $val = "0" Then ContinueLoop
			Switch $tag
			Case "SPEED"
				If Number($val) > 999999999 Then
					$xml_str &= xml_makeNode("DISPLAY_SPEED", Round($val / 1000000000, 1) & " Gbps")
				ElseIf Number($val) > 99999 Then
					$xml_str &= xml_makeNode("DISPLAY_SPEED", Round($val / 1000000, 1) & " Mbps")
				ElseIf Number($val) > 999 Then
					$xml_str &= xml_makeNode("DISPLAY_SPEED", Round($val / 1000, 1) & " Kbps")
				EndIf
			Case "LAST_CHANGE"
				$val = net_convertToTimestamp($val)
			Case "OPERATIONAL_STATUS"
				If Number($val) > 3 Then
					$operational = True
				ElseIf Number($val) = 3 Then
					$xml_str &= xml_makeNode("CONNECTING", "Y")
				EndIf
			EndSwitch
			$xml_str &= xml_makeNode($tag, $val)
		Next
		;; call GetPerAdapterInfo() for a specific adapter to get DNS and AIPIA information
		$nBufLen = DllStructGetSize($stIPPAI)
		$rc = DllCall($hDllFile, "dword", "GetPerAdapterInfo", "long", $nAdapterIndex, "ptr", DllStructGetPtr($stIPPAI), "long*", $nBufLen)
		If @error <> 0 Or $rc[0] <> 0 Then
			ConsoleWriteError("GetPerAdapterInfo() - bad return code of " & $rc[0] & @CR)
			$xml_str &= "</ADAPTER>" & @CRLF
			Return SetError(5)
		EndIf
		Local $apipa_active = False
		For $fld = 1 To $nNumIPPAIFields
			Local $tag = $IPPAI_tags[$fld]
			If $tag = "x" Then ContinueLoop	;; we can skip this field
			Local $val = DllStructGetData($stIPPAI, $fld)
			Switch $tag
			Case "APIPA_ACTIVE"			;; special handing for APIPA
				If $val = "1" Then
					$apipa_active = True
					$val = "Y"
				Else
					$val = "N"
				EndIf
			Case "APIPA_ENABLED"		;; 1->Y and 0->N
				$val = _Iif($val = "1", "Y", "N")
			Case "DNS_1", "DNS_2", "DNS_3"
				if Not net_isValidIP($val) Then $val = ""
			EndSwitch
			$xml_str &= xml_makeNode($tag, $val)
		Next

		;; we need to provide our own logic for DHCP_ACTIVE and CONNECTED flags
		;; DHCP must be on and APIPA must be inactive and we must have a valid IP address and DHCP server address
		$xml_str &= xml_makeNode("DHCP_ACTIVE", _Iif($dhcp_enabled And Not $apipa_active And StringLen($ip_addr) > 0 And StringLen($dhcp_server) > 0, "Y", "N"))
		;; OPERATIONAL_STATUS must be > 3 and we must have a valid IP address and gateway IP address
		$xml_str &= xml_makeNode("CONNECTED", _Iif($operational And StringLen($ip_addr) > 0 And StringLen($gateway_ip) > 0, "Y", "N"))

		;; we're going to pull some information from the registry for this adapter
		Local $reg_base = $sRegistryRoot & "Network\" & $sRegistryGUID & '\' & $guid & "\Connection"
		For $i = 1 To $REG_keys[0]
			Local $val = RegRead($reg_base, $REG_keys[$i])
			If StringLen($val) = 0 Then ContinueLoop
			Switch $REG_tags[$i]
			Case "IP_CHECKING_ENABLED", "ICON_ENABLED"
				$val = _Iif($val = "1", "Y", "N")
			Case "MEDIA_SUB_TYPE"
				$xml_str &= xml_makeNode("LAN", _Iif(Number($val) = 1, "Y", "N"))
				$xml_str &= xml_makeNode("WIRELESS", _Iif(Number($val) = 2, "Y", "N"))
				$xml_str &= xml_makeNode("BLUETOOTH", _Iif(Number($val) = 9, "Y", "N"))
			EndSwitch
			$xml_str &= xml_makeNode($REG_tags[$i], $val)
		Next
		$reg_base = $sRegistryRoot & "Class\" & $sRegistryGUID
		Local $count = 1			;; enumeration counter
		While True
			Local $var = RegEnumKey($reg_base, $count)
			If @error <> 0 Then ExitLoop
			$count += 1
			If RegRead($reg_base & '\' & $var, "NetCfgInstanceId") = $guid Then
				For $i = 1 To $REG_keys2[0]
					$xml_str &= xml_makeNode($REG_tags2[$i], RegRead($reg_base & '\' & $var, $REG_keys2[$i]))
				Next
				ExitLoop
			EndIf
		WEnd
		$xml_str &= "</ADAPTER>" & @CRLF
	WEnd
EndFunc

Func __IPH_MakeDWORDStructure($cnt)
	Local $str = ""
	For $i = 1 To $cnt
		If StringLen($str) > 0 Then $str &= ';'
		$str &= "dword"
	Next
	Return DllStructCreate($str)
EndFunc

Func __IPH_MetricsCapture($hDllFile, ByRef $xml_str)
	Local Const $nIPStats = 23		;; number of elements for GetIpStatistics()
	Local Const $nTCPStats = 15		;; number of elements for GetTcpStatistics()
	Local Const $nUDPStats = 5		;; number of elements for GetUdpStatistics()

	$xml_str &= "<STATISTICS>" & @CRLF
	$xml_str &= "<IP>" & @CRLF
	Local $stIPStats = __IPH_MakeDWORDStructure($nIPStats)
	Local $rc = DllCall($hDllFile, "dword", "GetIpStatistics", "ptr", DllStructGetPtr($stIPStats))
	If @error <> 0 Or $rc[0] <> 0 Then
		$xml_str &= xml_makeNode("ERRCODE", $rc[0])
	Else
		Local Const $IPStat_tags = StringSplit("RTO_ALGORITHM;FORWARDING;DEFAULT_TTL;DATAGRAMS_RECEIVED;RECEIVED_HEADER_ERRORS;RECEIVED_ADDRESS_ERRORS;FORWARDED;RECEIVED_UNKNOWN_PROTOCOLS;RECEIVED_DISCARDS;RECEIVED_DELIVERED;SENT_REQUESTS;ROUTING_DISCARDS;SENT_DISCARDS;SENT_UNROUTABLE;REASSEMBLE_TIMEOUT;REASSEMBLE_REQUIRED;REASSEMBLE_FAILED;FRAGMENTED;FRAGMENTED_FAILED;FRAGMENTED_CREATED;NUM_INTERFACES;NUM_IPS;NUM_ROUTES", ";")
		For $i = 1 To $nIPStats
			$xml_str &= xml_makeNode($IPStat_tags[$i], DllStructGetData($stIPStats, $i))
		Next
	EndIf
	$xml_str &= "</IP>" & @CRLF

	$xml_str &= "<TCP>" & @CRLF
	Local $stTCPStats = __IPH_MakeDWORDStructure($nTCPStats)
	$rc = DllCall($hDllFile, "dword", "GetTcpStatistics", "ptr", DllStructGetPtr($stTCPStats))
	If @error <> 0 Or $rc[0] <> 0 Then
		$xml_str &= xml_makeNode("ERRCODE", $rc[0])
	Else
		Local Const $TCPStat_tags = StringSplit("RTO_ALGORITHM;MIN_RTO;MAX_RTO;MAX_CONNECTIONS;ACTIVE_OPENS;PASSIVE_OPENS;FAILED_CONNECTIONS;RESET_CONNECTIONS;ACTIVE_CONNECTIONS;SEGMENTS_RECEIVED;SEGMENTS_TRANSMITTED;SEGMENTS_RETRANSMITTED;ERRORS_RECEIVED;RESETS_TRANSMITTED;TOTAL_CONNECTIONS", ";")
		For $i = 1 To $nTCPStats
			$xml_str &= xml_makeNode($TCPStat_tags[$i], DllStructGetData($stTCPStats, $i))
		Next
	EndIf
	$xml_str &= "</TCP>" & @CRLF

	$xml_str &= "<UDP>" & @CRLF
	Local $stUDPStats = __IPH_MakeDWORDStructure($nUDPStats)
	$rc = DllCall($hDllFile, "dword", "GetUdpStatistics", "ptr", DllStructGetPtr($stUDPStats))
	If @error <> 0 Or $rc[0] <> 0 Then
		$xml_str &= xml_makeNode("ERRCODE", $rc[0])
	Else
		Local Const $UDPStat_tags = StringSplit("DATAGRAMS_RECEIVED;DATAGRAMS_DISCARDED;DATAGRAM_ERRORS;DATAGRAMS_TRANSMITTED;LISTENER_ENTRIES", ";")
		For $i = 1 To $nUDPStats
			$xml_str &= xml_makeNode($UDPStat_tags[$i], DllStructGetData($stUDPStats, $i))
		Next
	EndIf
	$xml_str &= "</UDP>" & @CRLF
	$xml_str &= "</STATISTICS>" & @CRLF
EndFunc

FileDelete("IPHelper.xml")
FileWrite("IPHelper.xml", _IPH_Capture())
