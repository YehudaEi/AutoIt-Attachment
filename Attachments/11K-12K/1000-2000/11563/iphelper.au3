; NAME: IPHELPER.AU3
; DATE: 11-AUG-2006
; AUTH: SvenP
; DESC: Several IP Helper functions
;
;
; GetAdapterInfo()		Obtains IP adapter info in a two dimensional array
; SendArp()				Sends a ARP packet
; IsReachable()			Tests if an IP-adress is reachable through given interface
; AddStaticRoute()		Adds a static route to given interface
; DeleteStaticRoute()	Deletes a static route
; GetIfEntry()			Gets interface entry from given index
; inet_addr()			Convert IP to inet_addr
; GetPublicIP()			Obtains the public IP Address of an interface
; GetLocationInfo()		Obtains geo location and provider of given IP address
;
;
; This is non-tested, non-supported beta software, use at your own risk !!
; ------------------------------------------------------------------------


; ---------
; Constants
; ---------

; Adapter information

; Public Constants used for network adapter information

; Interface types
Const $MIB_IF_TYPE_WLAN	= 2		; Custom type for wireless network adapters
Const $MIB_IF_TYPE_PPP	= 23	; PPP adapter (like VPN)

; Adapter information is being stored in a 2-dimensional array
; These constants represent the index in the array
Const $Adap_Idx_GUID	= 3
Const $Adap_Idx_Descr	= 4
Const $Adap_Idx_IfIndex = 7
Const $Adap_Idx_Type	= 8
Const $Adap_Idx_DHCPEn	= 9
Const $Adap_Idx_IPAddr	= 12	
Const $Adap_Idx_Gateway	= 16
Const $Adap_Idx_DHCP	= 20
Const $Adap_Idx_WINSEn	= 23
Const $Adap_Idx_WINS1	= 25
Const $Adap_Idx_WINS2	= 29
Const $Adap_Idx_DNS1	= 34
Const $Adap_Idx_DNS2	= 35
Const $Adap_Idx_IPValid	= 36
Const $Adap_Idx_GwOK 	= 37
Const $Adap_Idx_GwMAC 	= 38
Const $Adap_Idx_DNS1OK 	= 39
Const $Adap_Idx_DNS2OK 	= 40
Const $Adap_Idx_InetOK	= 41
Const $Adap_Idx_PubIP   = 42
Const $Adap_Idx_Org		= 43
Const $Adap_Idx_City	= 44
Const $Adap_Idx_RDNS	= 45
Const $Adap_Idx_Status  = 46
Const $Adap_Idx_MAX		= 47

; This array contains our adapter information
Dim $Adapters[8][$Adap_Idx_MAX]	

; User friendly descriptions for the same indexes (english)

Dim $AdapLabel[$Adap_Idx_MAX]

$AdapLabel[$Adap_Idx_Descr]="Adapter Description"
$AdapLabel[$Adap_Idx_Type]="Adapter Type"
$AdapLabel[$Adap_Idx_DHCPen]="DHCP Enabled"
$AdapLabel[$Adap_Idx_IPAddr]="Local IP Address"
$AdapLabel[$Adap_Idx_Gateway]="Gateway"
$AdapLabel[$Adap_Idx_DHCP]="DHCP Server"
$AdapLabel[$Adap_Idx_WINSen]="WINS Enabled"
$AdapLabel[$Adap_Idx_WINS1]="First WINS server"
$AdapLabel[$Adap_Idx_WINS2]="Second WINS server"
$AdapLabel[$Adap_Idx_DNS1]="First DNS server"
$AdapLabel[$Adap_Idx_DNS2]="Second DNS server"
$AdapLabel[$Adap_Idx_IPValid]="IP Address valid"
$AdapLabel[$Adap_Idx_GWOK]="Gateway status"
$AdapLabel[$Adap_Idx_GWMAC]="MAC Addr Gateway"
$AdapLabel[$Adap_Idx_DNS1OK]="First DNS status"
$AdapLabel[$Adap_Idx_DNS2OK]="Second DNS status"
$AdapLabel[$Adap_Idx_InetOK]="Internet status"
$AdapLabel[$Adap_Idx_PubIP]="Public IP Address"
$AdapLabel[$Adap_Idx_Org]="Organisation"
$AdapLabel[$Adap_Idx_City]="City"
$AdapLabel[$Adap_Idx_RDNS]="Full host name"
$AdapLabel[$Adap_Idx_Status]="Physical status"



; -------------
; Main Function
; -------------
;
; $Result = GetAdapterInfo($Adapters)
;
; Collects network adapter information

Func GetAdapterInfo(ByRef $Adapters)

; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/iphlp/iphlp/getadaptersinfo.asp

#cs

; The IP_ADAPTER_INFO structure contains information about a particular network adapter on the local computer.

#define MAX_ADAPTER_DESCRIPTION_LENGTH  128 // arb.
#define MAX_ADAPTER_NAME_LENGTH         256 // arb.
#define MAX_ADAPTER_ADDRESS_LENGTH      8   // arb.

typedef struct {
 char String[4 * 4];
} IP_ADDRESS_STRING, IP_MASK_STRING;

typedef struct _IP_ADDR_STRING {
    struct _IP_ADDR_STRING* Next;
    IP_ADDRESS_STRING IpAddress;
    IP_MASK_STRING IpMask;
    DWORD Context;
} IP_ADDR_STRING

typedef struct _IP_ADAPTER_INFO {
  struct _IP_ADAPTER_INFO* Next;
  DWORD ComboIndex;
  char AdapterName[MAX_ADAPTER_NAME_LENGTH + 4];
  char Description[MAX_ADAPTER_DESCRIPTION_LENGTH + 4];
  UINT AddressLength;
  BYTE Address[MAX_ADAPTER_ADDRESS_LENGTH];
  DWORD Index;
  UINT Type;
  UINT DhcpEnabled;
  PIP_ADDR_STRING CurrentIpAddress;
  IP_ADDR_STRING IpAddressList;
  IP_ADDR_STRING GatewayList;
  IP_ADDR_STRING DhcpServer;
  BOOL HaveWins;
  IP_ADDR_STRING PrimaryWinsServer;
  IP_ADDR_STRING SecondaryWinsServer;
  time_t LeaseObtained;
  time_t LeaseExpires;
} IP_ADAPTER_INFO, 
*PIP_ADAPTER_INFO;
#ce

	Const $ERROR_BUFFER_OVERFLOW = 111


	; Struct IP_ADAPTER_INFO (single)
	$Str_IPAdptInfo        		= "ptr;dword;char[260];char[132];uint;byte[8];dword;uint;uint;ptr;"
	$Str_IPAdptInfo = $Str_IPAdptInfo &         "ptr;char[16];char[16];dword;"	; IPAddressList
	$Str_IPAdptInfo = $Str_IPAdptInfo &         "ptr;char[16];char[16];dword;" ; GateWayList
	$Str_IPAdptInfo = $Str_IPAdptInfo &         "ptr;char[16];char[16];dword;" ; DhcpServer
	$Str_IPAdptInfo = $Str_IPAdptInfo &         "int;"							; HaveWins
	$Str_IPAdptInfo = $Str_IPAdptInfo &         "ptr;char[16];char[16];dword;" ; PrimaryWinsServer
	$Str_IPAdptInfo = $Str_IPAdptInfo &         "ptr;char[16];char[16];dword;" ; SecondaryWinsServer
	$Str_IPAdptInfo = $Str_IPAdptInfo &         "int;int"	

	$ulOutBufLen = 640		; sizeof struct IP_ADAPTER_INFO

#cs
; NOTE: Windows 9x does not use per-interface DNS information. They are global to all interfaces.

; The FIXED_INFO structure contains information that is the same across all the interfaces in a computer.

#define MAX_HOSTNAME_LEN                128 // arb.
#define MAX_DOMAIN_NAME_LEN             128 // arb.
#define MAX_SCOPE_ID_LEN                256 // arb.

typedef struct {
  char HostName[MAX_HOSTNAME_LEN + 4];
  char DomainName[MAX_DOMAIN_NAME_LEN + 4];
  PIP_ADDR_STRING CurrentDnsServer;
  IP_ADDR_STRING DnsServerList;
  UINT NodeType;
  char ScopeId[MAX_SCOPE_ID_LEN + 4];
  UINT EnableRouting;
  UINT EnableProxy;
  UINT EnableDns;
} FIXED_INFO, 
*PFIXED_INFO;

; The GetNetworkParams function retrieves network parameters for the local computer.
DWORD GetNetworkParams(  PFIXED_INFO pFixedInfo,   PULONG pOutBufLen );

#ce

	ProgressOn("Collecting information","","One moment please...collecting network information")
	
	; Loop for getting Adapters info
	Do
	
		$IP_ADAPTER_INFO       = DllStructCreate($Str_IPAdptInfo)
		if @error then Exitloop			; function failed
	
		; Make an (initial) call to GetAdaptersInfo to get the necessary size into the ulOutBufLen variable
	
		; DWORD GetAdaptersInfo(  PIP_ADAPTER_INFO pAdapterInfo,  PULONG pOutBufLen )

		$Res = DLLCall("iphlpapi.dll","long","GetAdaptersInfo","ptr",DllStructGetPtr($IP_ADAPTER_INFO),"long_ptr",$ulOutBufLen)
	
		if (not @error) and ($Res[0] = $ERROR_BUFFER_OVERFLOW) Then	; Buffer too small ?
			
			; Multiplicate the existing structure, until the requested size has been reached.
			; $Res[2] Contains the required buffer size
			
			; ConsoleWrite("$ErrMsg=Buffer overflow (" & $Res[0] & ") needs: " & $Res[2] & " bytes., strlen=" & StringLen($Str_IPAdptInfo) & @CRLF)
			
			for $counter = 640 to $Res[2] step 640
				$Str_IPAdptInfo = $Str_IPAdptInfo & ";" & $Str_IPAdptInfo 
				;ConsoleWrite("added str, len=" & StringLen($Str_IPAdptInfo) & @CRLF)
			Next
			
			$ulOutBufLen = $Res[2]
			
			$IP_ADAPTER_INFO = ""
		EndIf
		
	Until $Res[0]<>$ERROR_BUFFER_OVERFLOW
	
	if @error or $Res[0]<> 0 then ; Other error
		return $Res[0]				; Function failed
		;$ErrMsg="Unknown error (" & $Res[0] & ")"
	EndIf
	
	; Get DNS information.  We have to split this section in a Win_32 and a Win_NT version.
	; Win_32 uses global DNS information while Win_NT uses per-adapter DNS information.
	
	$DNSServer1=""
	$DNSServer2=""
		
	if @OSType="WIN32_WINDOWS" Then	; Win32 only

		; Create Struct FIXED_INFO
		$Str_FixInfo = 					"char[132];"					; HostName
		$Str_FixInfo = $Str_FixInfo & "char[132];"  					; Domain name
		$Str_FixInfo = $Str_FixInfo & "ptr;"							; CurrentdnsServer
		$Str_FixInfo = $Str_FixInfo & "ptr;char[16];char[16];dword;" 	; Dnsserverlist
		$Str_FixInfo = $Str_FixInfo & "uint;char[260];uint;uint;uint"	; Nodetype, ScopeID, ..

		$SizeOf_FixInfo= 132+132+4+4+16+16+4+4+260+4+4+4  ; 584
	
		$uBufSize= $SizeOf_FixInfo
		do
			$FIXED_INFO=DllStructCreate($Str_FixInfo)
			if @error then return @error			; function failed
	
			$Res = DLLCall("iphlpapi.dll","long","GetNetworkParams","ptr",DllStructGetPtr($FIXED_INFO),"long_ptr",$uBufSize)
	
			if (not @error) and ($Res[0] = $ERROR_BUFFER_OVERFLOW) Then	$uBufSize=EnlargeStructure($Str_FixInfo,$SizeOf_FixInfo,$Res[2]) ; Buffer too small ? Enlarge it
			
		Until $Res[0]<>$ERROR_BUFFER_OVERFLOW 

		if $Res[0]<> 0 then return $Res[0]				; Function failed
		$DNSServer1=DllStructGetData($FIXED_INFO,5)
		if $Res[2] > $SizeOf_FixInfo then $DNSServer2=DllStructGetData($FIXED_INFO,5+1*$SizeOf_FixInfo)
			
		Consolewrite("Win9x dns servers:" & $DNSServer1 & @crLf & $DNSServer2)
	EndIf
	
	
	; Now collect all results into an array.
	; We limit ourselves to a maximum of 8 adapters.	
	
	;Dim $Result[8][$Adap_Idx_MAX]	
	
	$AdapCount=0
	
	do	; For each adapter...
		
		; Store general adapter information
		for $Index = 1 to 33
			$Adapters[$AdapCount][$Index]=DllStructGetData($IP_ADAPTER_INFO,$Index+$AdapCount*33)
		next
		
		if $DNSServer1<>"" Then	; Win32 only
			$Adapters[$AdapCount][$Adap_Idx_DNS1]=$DNSServer1
			$Adapters[$AdapCount][$Adap_Idx_DNS2]=$DNSServer2
		Else
			; Win_NT: Read DNS server from registry
			; HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{GUID}
			; Value: DhcpNameServer or NameServer
			
			$DNSServers=RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & DllStructGetData($IP_ADAPTER_INFO,3+$AdapCount*33),"DhcpNameServer")
	
			if @error or $DNSServers="" Then $DNSServers=RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & DllStructGetData($IP_ADAPTER_INFO,3+$AdapCount*33),"NameServer")
			
			if $DNSServers<>"" then 
				; Cisco delimits DNS servers using a comma instead of a space...
				if StringInStr($DNSServers,",") > 0 then
					$DNSArray=StringSplit($DNSServers,",")
				Else
					$DNSArray=StringSplit($DNSServers," ")
				EndIf
				if IsArray($DNSArray) then 
					$Adapters[$AdapCount][$Adap_Idx_DNS1]=$DNSArray[1]
					if $DNSArray[0]>1 then $Adapters[$AdapCount][$Adap_Idx_DNS2]=$DNSArray[2]
				EndIf
			EndIf
			
		EndIf

		Consolewrite("Adapter "& $AdapCount+1 & "/" & $ulOutBufLen/640 & ":" & $Adapters[$AdapCount][$Adap_Idx_Descr])
		
		; Check if the adapter is wireless (Windows 2000/xp/2003 only)
		
		$MediaSubType=RegRead("HKLM\System\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\" & $Adapters[$AdapCount][$Adap_Idx_GUID] & "\Connection" ,"MediaSubType")
		if not @error and $MediaSubType=2 then 
			$Adapters[$AdapCount][$Adap_Idx_Type]=$MIB_IF_TYPE_WLAN
		EndIf
		
		; Store physical status of the adapter
		$Adapters[$AdapCount][$Adap_Idx_Status]=GetIfEntry($Adapters[$AdapCount][$Adap_Idx_IfIndex])
		
		; Assume first that IP-address is valid..
		$Adapters[$AdapCount][$Adap_Idx_IPValid]=1
		
		; Check if IP address is valid
		$IPAddress = $Adapters[$AdapCount][$Adap_Idx_IPAddr]
		
		if $IPAddress = "0.0.0.0" or $IPAddress = "127.0.0.1" or StringLeft($IPAddress,7) = "169.254" Then 
			$Adapters[$AdapCount][$Adap_Idx_IPValid]=0
		else
			; Fix some entries when using (Cisco) VPN adapters
			if StringLeft($Adapters[$AdapCount][$Adap_Idx_Descr],17) = "Cisco Systems VPN" Then
				if $Adapters[$AdapCount][$Adap_Idx_Gateway]="" then $Adapters[$AdapCount][$Adap_Idx_Gateway] = $IPAddress		; Cisco VPN does not define a gateway
				$Adapters[$AdapCount][$Adap_Idx_Type]=$MIB_IF_TYPE_PPP				; Cisco VPN is actually a PPP-type virtual interface
			endif

			; Mark if gateway for this interface is valid and reachable.
			; We assume the 'ping' will be routed through this adapter, because we ping to the adapter's gateway
			$Adapters[$AdapCount][$Adap_Idx_GwOK] = IsReachable($Adapters[$AdapCount][$Adap_Idx_Gateway])
		
			; Gateway not pingable ?? Could be firewalled, try an ARP request  (Win2K or higher only!)
			if $Adapters[$AdapCount][$Adap_Idx_GwOK] = 0 Then
				$Adapters[$AdapCount][$Adap_Idx_GwMAC] = SendArp($Adapters[$AdapCount][$Adap_Idx_Gateway],$IPAddress,$Adapters[$AdapCount][$Adap_Idx_IfIndex])
				if $Adapters[$AdapCount][$Adap_Idx_GwMAC] <> "" then $Adapters[$AdapCount][$Adap_Idx_GwOK]= 2
			EndIf
			
			if $Adapters[$AdapCount][$Adap_Idx_GwOK] <> 0 then ; Only continue is gateway is reachable
	
				; Check DNS reachability
				
				$Adapters[$AdapCount][$Adap_Idx_DNS1OK] = IsReachable($Adapters[$AdapCount][$Adap_Idx_DNS1])
				if $Adapters[$AdapCount][$Adap_Idx_DNS1OK]= 0 then	; Try UDP port 53 directly.
					$Adapters[$AdapCount][$Adap_Idx_DNS1OK]=IsReachable($Adapters[$AdapCount][$Adap_Idx_DNS1],"",0,"UDP",53)
				EndIf

				; Check DNS2 only if IP-address of second DNS exists
				$DNS2Address=$Adapters[$AdapCount][$Adap_Idx_DNS2OK] 
				if $DNS2Address <> "0.0.0.0" and $DNS2Address <> "127.0.0.1" and StringLeft($DNS2Address,7) <> "169.254" Then 
					$Adapters[$AdapCount][$Adap_Idx_DNS2OK] = IsReachable($Adapters[$AdapCount][$Adap_Idx_DNS2])
					if $Adapters[$AdapCount][$Adap_Idx_DNS2OK]= 0 then	; Try UDP port 53 directly.
						$Adapters[$AdapCount][$Adap_Idx_DNS2OK]=IsReachable($Adapters[$AdapCount][$Adap_Idx_DNS2],"",0,"UDP",53)
					EndIf
				EndIf

				; We proceed, even when DNS servers are not reachable...
				
				; Check remote host reachability, by routing through the interface
				; We check internet access for ALL adapters 
				
				; A.Root-servers.net
				$Adapters[$AdapCount][$Adap_Idx_InetOK]=IsReachable("198.41.0.4",$Adapters[$AdapCount][$Adap_Idx_Gateway],$Adapters[$AdapCount][$Adap_Idx_IfIndex])
				if $Adapters[$AdapCount][$Adap_Idx_InetOK]= 0 then	; Try UDP port 53 directly.
					$Adapters[$AdapCount][$Adap_Idx_InetOK]=IsReachable("198.41.0.4","",0,"UDP",53)
				EndIf
				
				if $Adapters[$AdapCount][$Adap_Idx_DNS1OK]<>0 Then
					; Only perform this test if we have DNS functionality
					
					; Check our public IP address
					$PrimaryIPTestAddress="                    "	 ; MUST be numeric !!
					$PrimaryIPRoutedHost="206.176.224.3"
					;$SecondaryIPTestAddress="http://backupsite-to-test-my-ip/whatismyip.asp"
					;$SecondaryIPRoutedHost="Ip Adress of backup site"
					
					$Adapters[$AdapCount][$Adap_Idx_PubIP]=GetPublicIP($PrimaryIPTestAddress,$PrimaryIPRoutedHost,$Adapters[$AdapCount][$Adap_Idx_Gateway],$Adapters[$AdapCount][$Adap_Idx_IfIndex])
					;if $Adapters[$AdapCount][$Adap_Idx_PubIP]=-1 then $Adapters[$AdapCount][$Adap_Idx_PubIP]=GetPublicIP($SecondaryIPTestAddress,$SecondaryIPRoutedHost,$Adapters[$AdapCount][$Adap_Idx_Gateway],$Adapters[$AdapCount][$Adap_Idx_IfIndex])

					; Perform this test only if we got a valid public IP address
					if $Adapters[$AdapCount][$Adap_Idx_PubIP]<> -1 Then
						GetLocationInfo($Adapters[$AdapCount][$Adap_Idx_PubIP],$Adapters[$AdapCount][$Adap_Idx_Org],$Adapters[$AdapCount][$Adap_Idx_City],$Adapters[$AdapCount][$Adap_Idx_RDNS])
					EndIf
					
				EndIf
				
			EndIf
			
		EndIf
		
		$AdapCount=$AdapCount + 1
		
		ProgressSet($AdapCount/($ulOutBufLen/640)*100)
		
	until ($AdapCount = 8) or  (DllStructGetData($IP_ADAPTER_INFO,1+33*($AdapCount-1)) = 0)
	
	$Adapters[0][0]=$AdapCount		; Number of Adapters
	
	ProgressOff()

	return 0		; Collect successful
	
EndFunc

; ----------------
; Helper functions
; ----------------

Func EnlargeStructure(byRef $Str_Struct,$Sizeof_Struct,$Requested_Size)
	; Used to enlarge DLLStruct stucture when needed
	; Size in bytes!
	
	; consolewrite("Enlargestructure: $str=" & $str_struct & " size=" & $Sizeof_Struct & " requested=" & $Requested_Size & @CR)
	
	$Str_Single=$Str_Struct
	for $counter = $Sizeof_Struct to $Requested_Size step $Sizeof_Struct
		$Str_Struct = $Str_Struct & ";" & $Str_Single
		;ConsoleWrite("added str, len=" & StringLen($Str_Struct) & @CR)
	Next
	Return $Requested_Size
EndFunc


Func SendArp($TargetIP,$SourceIP="",$Interface="")
	
	
	; Windows 2000/XP/2003 only.
	
	; http://msdn.microsoft.com/library/en-us/iphlp/iphlp/flushipnettable.asp
	; DWORD FlushIpNetTable(  DWORD dwIfIndex );

	; http://msdn.microsoft.com/library/en-us/iphlp/iphlp/sendarp.asp
	; DWORD SendARP( IPAddr DestIP, IPAddr SrcIP, PULONG pMacAddr, PULONG PhyAddrLen);


	; If interface number is given, then flush arp table of this interface first
	if $Interface<>"" then $Res = DLLCall("iphlpapi.dll","long","FlushIpNetTable","long", $Interface)
	
	
	; A MACAddress is 6 bytes long, which won't fit in a long
	$Str_MACAddress="ubyte;ubyte;ubyte;ubyte;ubyte;ubyte"
	$MACADDRESS = DllStructCreate($Str_MACAddress)
	$SizeofMac=6		; 6 bytes
	
	$Res = DLLCall("iphlpapi.dll","long","SendARP","int", inet_addr($TargetIP),"int", inet_addr($SourceIP),"ptr",DLLStructGetPtr($MACAddress),"long_ptr",$SizeofMAc)
	if not @error and $Res[0]=0 then
		$ResultAddress=StringFormat("%02X:%02X:%02X:%02X:%02X:%02X",DLLStructGetData($MACADDRESS,1),DLLStructGetData($MACADDRESS,2), _
				DLLStructGetData($MACADDRESS,3),DLLStructGetData($MACADDRESS,4),DLLStructGetData($MACADDRESS,5),DLLStructGetData($MACADDRESS,6))
	Else
		$ResultAddress=""
	endif
	
	ConsoleWrite("SendArp: IP-adres: " & $TargetIP & "$Res[0]: " & $Res[0] & " SizeofMac:" & $Res[4] &  " MAC-Adres: " & $ResultAddress)
	
	return $ResultAddress
EndFunc



Func IsReachable($IPAddress,$Gateway="",$Interface=0,$Proto="",$TCPPortNum=0)
; Return values:
; -1	reachable, but firewalled
; 0		unreachable
; 1		reachable and pingable

	$Reachable=0
	$RouteResult=0
	$MIB_IPFORWARDROW=0
	
	if not ($Gateway = "" or $Gateway = Default) then $RouteResult=AddStaticRoute($MIB_IPFORWARDROW, $IPAddress,$Gateway,$Interface)
	
	if $IPAddress<>"" and $IPAddress<>"0.0.0.0" Then 
		if $Proto="" or $TCPPortNum=0 then
			Ping ( $IPAddress, 3000 )	
			if not @error then $Reachable=1		; reachable, pingable
		Else
			if $Proto="TCP" then
				TCPStartUp()		; Start The TCP Services
				$socket = TCPConnect( $IPAddress, $TCPPortNum )  ; Connect to a Listening "SOCKET"
				If $socket <> -1 Then 
					TCPCloseSocket($socket)
					$Reachable = -1			; reachable, but firewalled
				endif
				TCPShutdown()
			elseif $Proto="UDP" Then
				UDPStartup()
				$socket = UDPOpen(  $IPAddress, $TCPPortNum )
				If $socket <> -1 Then							; UDP is connectionless, so we must send some data to check.
					if UDPSend($socket, @CRLF) <> 0 then $Reachable = -1			; reachable, but firewalled
					
					UDPCloseSocket($socket)
					
				EndIf
				UDPShutdown()
			EndIf
			
		Endif
	EndIf

	if $RouteResult<>0 then DeleteStaticRoute($MIB_IPFORWARDROW)	; Remove static route through interface

	ConsoleWrite("IsReachable(" & $IPAddress & ", " & $Gateway & ", " & $Interface & "," & $TCPPortNum & ")=" & $Reachable)
	Return $Reachable

EndFunc



Func AddStaticRoute(ByRef $MIB_IPFORWARDROW, $IPAddress,$Gateway,$Interface=0)
#cs
http://msdn.microsoft.com/library/en-us/iphlp/iphlp/createipforwardentry.asp

typedef struct _MIB_IPFORWARDROW {
  DWORD dwForwardDest;
  DWORD dwForwardMask;
  DWORD dwForwardPolicy;
  DWORD dwForwardNextHop;
  DWORD dwForwardIfIndex;
  DWORD dwForwardType;
  DWORD dwForwardProto;
  DWORD dwForwardAge;
  DWORD dwForwardNextHopAS;
  DWORD dwForwardMetric1;
  DWORD dwForwardMetric2;
  DWORD dwForwardMetric3;
  DWORD dwForwardMetric4;
  DWORD dwForwardMetric5;
} MIB_IPFORWARDROW, 
*PMIB_IPFORWARDROW;

DWORD CreateIpForwardEntry(
  PMIB_IPFORWARDROW pRoute
);

inet string->dword: in_addr inet_addr(const char *szAddr);
(struct in_addr == ulong)

#ce
	const $PROTO_IP_NETMGMT=3

	$pdwBestIfIndex = 0
	
	ConsoleWrite("AddStaticRoute(ipaddr=" & $Ipaddress & ", gw=" & $Gateway & ", if=" & $Interface & ")" )
	
	; Create struct MIB_IPFORWARDROW
	$Str_IPForward="dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword"
	$MIB_IPFORWARDROW  = DllStructCreate($Str_IPForward)

	; We need to get the interface number for creating the static route (the 'route add' command does it automatically for us)
	
	if $Interface=0 then		; No interface was given, we must find the appropriate interface ourselves using the gateway address
		$Res = DLLCall("iphlpapi.dll","long","GetBestInterface","int", inet_addr($Gateway),"long_ptr",$pdwBestIfIndex)
		if not @error and $Res[0]=0 then $pdwBestIfIndex=$Res[2]
	Else
		$pdwBestIfIndex=$Interface	; Interface number was given directly.
	endif

	if $pdwBestIfIndex <> 0 then
		; Fill in the gaps
		DllStructSetData ( $MIB_IPFORWARDROW, 1, inet_addr($IPAddress) )		; Destination
		DllStructSetData ( $MIB_IPFORWARDROW, 2, inet_addr("255.255.255.255") )	; Netmask: It's a host, not a network
		DllStructSetData ( $MIB_IPFORWARDROW, 3, 0 )							; Policy: not used
		DllStructSetData ( $MIB_IPFORWARDROW, 4, inet_addr($Gateway))			; Nexthop (must be zero on PPP adapters !!)
		DllStructSetData ( $MIB_IPFORWARDROW, 5, $pdwBestIfIndex)				; Ifindex (mandatory!)
		DllStructSetData ( $MIB_IPFORWARDROW, 6, 4)								; Type:	The next hop is not the final destination
		DllStructSetData ( $MIB_IPFORWARDROW, 7, $PROTO_IP_NETMGMT)				; This is a static route.
		DllStructSetData ( $MIB_IPFORWARDROW, 8, 0)								; Age
		DllStructSetData ( $MIB_IPFORWARDROW, 9, 0)								; next hop autonomous system number
		DllStructSetData ( $MIB_IPFORWARDROW, 10, 1)							; Metric 1:  one hop.
		
		if not @error then 			; succeeded?
	
			; Create static route through interface

			$Res = DLLCall("iphlpapi.dll","long","CreateIpForwardEntry","ptr",DllStructGetPtr($MIB_IPFORWARDROW))
			if not @error and $Res[0]=0 then 
				;msgbox(0,"","static routing succeeded: ipaddr=" & $Ipaddress & " gw=" & $Gateway & " if=" & $pdwBestIfIndex )
				return 1
			endif
		
			; Second attempt using an empty gateway address (some PPP adapters require this)
			DllStructSetData ( $MIB_IPFORWARDROW, 4, 0)
			$Res = DLLCall("iphlpapi.dll","long","CreateIpForwardEntry","ptr",DllStructGetPtr($MIB_IPFORWARDROW))
			if not @error and $Res[0]=0 then 
				;msgbox(0,"","2nd attempt static routing succeeded: ipaddr=" & $Ipaddress & " gw=" & $Gateway & " if=" & $pdwBestIfIndex )
				return 1
			EndIf
			
			; Last attempt, using the ROUTE.EXE command
			$Result=RunWait("route.exe add " & $IPAddress & " MASK 255.255.255.255 " & $Gateway & " METRIC 1",@WindowsDir, @SW_HIDE)
			if not @error then 
				;msgbox(0,"","3rd attempt static routing succeeded: ipaddr=" & $Ipaddress & " gw=" & $Gateway & " if=" & $pdwBestIfIndex )
				$MIB_IPFORWARDROW=$IPAddress	; required when deleting route to flag that we used the route.exe command.
				return 1
			EndIf
			
		endif
	EndIf
	ConsoleWrite("AddStaticRoute:All attempts static routing FAILED: $res[0]=" & $Res[0] & " ipaddr=" & $Ipaddress & " gw=" & $Gateway & " if=" & $pdwBestIfIndex )
	seterror(1)
	return 0
EndFunc

#cs
DWORD GetIfEntry(
  PMIB_IFROW pIfRow
);

typedef struct _MIB_IFROW {
WCHAR wszName[MAX_INTERFACE_NAME_LEN];  
DWORD dwIndex;  
DWORD dwType;  
DWORD dwMtu;  
DWORD dwSpeed;  
DWORD dwPhysAddrLen;  
BYTE bPhysAddr[MAXLEN_PHYSADDR];  
DWORD dwAdminStatus;  
DWORD dwOperStatus;  
DWORD dwLastChange;  
DWORD dwInOctets;  
DWORD dwInUcastPkts;  
DWORD dwInNUcastPkts;  
DWORD dwInDiscards;  
DWORD dwInErrors;  
DWORD dwInUnknownProtos;  
DWORD dwOutOctets;  
DWORD dwOutUcastPkts;  
DWORD dwOutNUcastPkts;  
DWORD dwOutDiscards;  
DWORD dwOutErrors;  
DWORD dwOutQLen;  
DWORD dwDescrLen;  
BYTE bDescr[MAXLEN_IFDESCR];
} MIB_IFROW,  *PMIB_IFROW;

#define MIB_IF_ADMIN_STATUS_UP          1
#define MIB_IF_ADMIN_STATUS_DOWN        2
#define MIB_IF_ADMIN_STATUS_TESTING     3

#define MIB_IF_OPER_STATUS_NON_OPERATIONAL      0
#define MIB_IF_OPER_STATUS_UNREACHABLE          1
#define MIB_IF_OPER_STATUS_DISCONNECTED         2
#define MIB_IF_OPER_STATUS_CONNECTING           3
#define MIB_IF_OPER_STATUS_CONNECTED            4
#define MIB_IF_OPER_STATUS_OPERATIONAL          5

#ce

Func GetIfEntry($ifIndex)

	Const $MAX_INTERFACE_NAME_LEN = 256
	Const $MAXLEN_PHYSADDR=8
	Const $MAXLEN_IFDESCR=256
	
	; Create struct MIB_IPFORWARDROW
	$Str_IfRow="short[256];dword;dword;dword;dword;dword;char[8];dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;dword;char[256]"
	$Struct_MIB_IFROW  = DllStructCreate($Str_IfRow)
	if @error then Return
	
	DllStructSetData($Struct_MIB_IFROW,2,$ifIndex)	; dwIndex

	
	$Res = DLLCall("iphlpapi.dll","long","GetIfEntry","ptr",DllStructGetPtr($Struct_MIB_IFROW))
	if @error or $Res[0]<>0 then 
		consolewrite("GetIfEntry: dllcall error: " & @error & " $res[0]=" & $Res[0] & @CR)
		Return
	EndIf

	ConsoleWrite("GetIfEntry: dwIndex=" & $ifIndex & @CRLF & _
					"dwSpeed=" & DLLStructGetData($Struct_MIB_IFROW,5) & @CRLF & _
					"dwAdminStatus=" & 	DLLStructGetData($Struct_MIB_IFROW,8) & @CRLF & _
					"dwOperStatus=" & 	DLLStructGetData($Struct_MIB_IFROW,9) & @CRLF & _
					"bDescr=" & 	DLLStructGetData($Struct_MIB_IFROW,24) & @CRLF )
					
	return DLLStructGetData($Struct_MIB_IFROW,9)	; dwOperStatus (dwAdminstatus has no use, since a disabled adapter would not appear in the list)
		
Endfunc


Func DeleteStaticRoute($Struct_IPFORWARDROW)

	$Result=1
	; Remove static route through interface
	if IsString($Struct_IPFORWARDROW)  Then		; Did we use the route.exe command?
		$Res=RunWait("route.exe delete " & $Struct_IPFORWARDROW, @WindowsDir, @SW_HIDE)
		if @error then $Result=0
	else
		$Res = DLLCall("iphlpapi.dll","long","DeleteIpForwardEntry","ptr",DllStructGetPtr($Struct_IPFORWARDROW))
		if @error or $Res[0]<>0 then $Result=0
	EndIf
	
	ConsoleWrite("DeleteStaticRoute: $Result=" & $Result)
	return $Result
EndFunc


Func inet_addr($IPAddress)
	if IsString($IPAddress) Then	; Simple check, we won't perform a full valid IP string check...
		$Res = DLLCall("wsock32.dll","long","inet_addr","str",$IPAddress)		; 32 bit
		if not @error then return $Res[0]
	EndIf
	
	SetError(1)	
	Return 0
EndFunc


Func GetPublicIP($IPTestAddress,$IPRoutedHost="",$Gateway="",$Interface=0)
	
	$PubIP="-1"
	$MIB_IPFORWARDROW=0
	
	if $IPRoutedHost="" then return _GetIP()
	
	$RouteResult=AddStaticRoute($MIB_IPFORWARDROW, $IPRoutedHost,$Gateway,$Interface)
	
	if $RouteResult Then
		$PubIP=_GetIP($IPTestAddress)
		DeleteStaticRoute($MIB_IPFORWARDROW)
	Else
		ConsoleWrite("GetPublicIP: AddStaticRoute failed !!")
	EndIf
	
	Return $PubIP
EndFunc

;===============================================================================
;
; Function Name:    _GetIP()
; Description:      Get public IP address of a network/computer.
; Parameter(s):     None
; Requirement(s):   Internet access.
; Return Value(s):  On Success - Returns the public IP Address
;                   On Failure - -1  and sets @ERROR = 1
; Original from:    Larry/Ezzetabi & Jarvis Stubblefield
;
;===============================================================================
Func _GetIP($URL="")

	$ip_ok=False
	$ip = -1
	if $URL="" then $URL="                    "	; http://www.whatsmyip.org/
		
	$oGetIPIE=ObjCreate("InternetExplorer.Application.1")
	$oGetIPIE.Visible=0
	if @error then return -1
	$oGetIPIE.Navigate($URL)
	if @error then return -1
		
	$Timeout=20  ; 20 seconds timeout
	$BeginTime=TimerInit()
	while ($oGetIPIE.ReadyState<=2) and TimerDiff($BeginTime)<($Timeout*1000)
		sleep(100)
	WEnd
	$ip=$oGetIPIE.Document.body.innerText
	$oGetIPIE.Quit			; Do not Quit IE, in case another instance has been opened somewhere
	$oGetIPIE=0

#cs	
	If InetGet($URL, @TempDir & "\~ip.tmp", 1) Then
		$ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
#ce		
		$ip = StringStripWS ($ip,8 )
		$t_ip = StringSplit($ip, '.')
		If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then $ip_ok=true

	Consolewrite("_GetIP: $ip=" & $ip & " $ip_ok=" & $ip_ok)
	if not $ip_ok then 
		$ip=-1
		SetError(1)
	EndIf
	
	Return $ip
EndFunc   ;==>_GetIP


Func GetLocationInfo($PublicIP, byRef $Organisation,byRef $City,byRef $ReverseDNS)
	
	$URL = "http://www.dnsstuff.com/tools/ipall.ch?domain=" & $PublicIP
	
	$Organisation=""
	$City=""
	$ReverseDNS=""
	
	If InetGet($URL, @TempDir & "\~ip.tmp", 1) Then
		
		$FileHandle=FileOpen( @TempDir & "\~ip.tmp",0)
		if not @error Then
			do
				$Line=FileReadLine($fileHandle)
				if not @error Then
					; Check for ASN Name
					if $Organisation="" then $Organisation=FindLine($Line,"ASN Name")
					
					; Check for City
					if $City="" then $City=FindLine($Line,"City (per outside source)")
					
					; Check for Reverse DNS
					if $ReverseDNS="" then $ReverseDNS=FindLine($Line,"Reverse DNS")
				EndIf
			until @error		
			FileClose($FileHandle)
		EndIf
		FileDelete(@TempDir & "\~ip.tmp")
	Else
		ConsoleWrite("GetLocationInfo: Error retrieving information.")
	EndIf
EndFunc

Func FindLine($Line,$StringtoFind)
	$Result=""
	; Returns the end part of a line starting with the contents of $StringToFind and a colon (:)
	If StringInStr($Line, $StringtoFind & ":") Then
		$Result= StringStripWS(StringRight($Line,StringLen($Line)-StringInStr($Line,":")),1+2)
		ConsoleWrite("FindLine(" & $StringToFind & "): " & $Result)
		; Filter out invalid results
		if StringLeft($Result,15) = "To be filled by" then $Result=""
		if StringLeft($Result, 5) = "00000" then $Result=""		
	EndIf
	Return $Result
EndFunc

