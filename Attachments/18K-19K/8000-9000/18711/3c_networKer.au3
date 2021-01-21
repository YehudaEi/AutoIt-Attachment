#include-once
#cs ----------------------------------------------------------------------------
 AutoIt Version		: 3.2.8.1
 Author				: oneLess
 Script Function	: retrieve all data about my NICs/connections and so on
#ce ----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Global $_NICs_data       = 16
	Global $_net_nics [30][$_NICs_data]					; [30] will be properly redim 
	Global $_total_nics = 0 , $_total_RAS  = 0
	Global $_PPPoE_mac , $_PPPoE_index , $_PPPoE_mask , $_PPPoE_IP , $_PPPoE_IPaddress , $_PPPoE_dhcp
	Global $PPPoE = 0
	Global $_ipcfgall        = readIpConfig() 			; i dont like the Ipconfig/all way but i have not [yet] other way to retrieve the active PPPoE connection name

	;Global $_IP_global = _GetIP ( )
	Global $_IP_local_1 = @IPAddress1 , $_IP_local_2 = @IPAddress2 , $_IP_local_3 = @IPAddress3 , $_IP_local_4 = @IPAddress4 
	
	Global $_net_isok =  0 ; [-1=Yes , 0=No] 			; is not ok for [re]moved nics or other software components reported by WMI , for active PPPoE [created later as entry in my array]
	Global $_net_guid =  1 ; [string] 					; NIC's registry GUID
	Global $_net_conn =  2 ; [string] 					; connection name
	Global $_net_name =  3 ; [string] 					; product name
	Global $_net_dhcp =  4 ; [-1=enabled , 0=disabled] 	; dhcp status
	Global $_net_ip__ =  5 ; [string] 					; IP
	Global $_net_stat =  6 ; [0..12] 					; WMI status [2=Connected, 7=Media disconnected] ; -> this two work
			; 0=Disconnected, 1=Connecting, 2=Connected, 3=Disconnecting, 4=Hardware not present, 5=Hardware disabled, 6=Hardware malfunction
			; 7=Media disconnected, 8=Authenticating, 9=Authentication succeeded, 10=Authentication failed, 11=Invalid address, 12=Credentials required
	Global $_net_mask =  7 ; [string] 					; subnet mask
	Global $_net_gate =  8 ; [string] 					; gateway
	Global $_net_dns_ =  9 ; [string] 					; DNS
	Global $_net_mac_ = 10 ; [string] 					; MAC address
	Global $_net_indx = 11 ; [1..how many they are]		; WMI index
	Global $_net_ipAd = 12 ; [1,2,3 or 4] 				; if IP is @IPAddress1,2,3 or 4
	Global $_net_pppo = 13 ; [-1=Yes , 0=No] 			; is PPPoE connection
	Global $_net_RASa = 14 ; [-1=Yes , 0=No] 			; RAS is active
	Global $_net_RASd = 15 ; [-1=Yes , 0=No] 			; RAS is default
 	;----------------------------------------------------------------------------
	
	_get_all_connections ( )

	;----------------------------------------------------------------------------
	
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _get_all_connections ( )
		;-----------------------------
		Local $_buffer , $_local_guid [11] , $_local_name [11]
		Local $_k = 0
		;-----------------------------
		Global $strComputer               = "localhost"
		Global $wbemFlagReturnImmediately = 0x10
		Global $wbemFlagForwardOnly       = 0x20
		Global $colItems_1  = "" , $colItems_2  = ""
		;-----------------------------
		$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
		$colItems_1 = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration where IPEnabled=TRUE", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		$_i = 0
		If IsObj($colItems_1) then
			For $objItem_1 In $colItems_1
				$_i = $_i + 1
				$_net_nics [$_i][$_net_isok] = 0 							; n,0
				$_net_nics [$_i][$_net_guid] = $objItem_1.SettingID		; n,1
				$_net_nics [$_i][$_net_conn] = -99 						; n,2
				$_net_nics [$_i][$_net_name] = -99 						; n,3
				$_net_nics [$_i][$_net_dhcp] = $objItem_1.DHCPEnabled		; n,4
				$_net_nics [$_i][$_net_ip__] = $objItem_1.IPAddress(0)		; n,5
				$_net_nics [$_i][$_net_stat] = -99 						; n,6
				$_net_nics [$_i][$_net_mask] = $objItem_1.IPSubnet(0)	; n,7
				If $_net_nics [$_i][$_net_mask] = "" Then $_net_nics [$_i][$_net_mask] = "N/A"
				$_net_nics [$_i][$_net_gate] = "N/A" 					; n,8
				$_net_nics [$_i][$_net_dns_] = "N/A"					; n,9
				$_net_nics [$_i][$_net_mac_] = $objItem_1.MACAddress 		; n,10
				$_net_nics [$_i][$_net_indx] = $objItem_1.Index			; n,11
				$_net_nics [$_i][$_net_pppo] = -99 						; n,12
				$_net_nics [$_i][$_net_ipAd] = "N/A"
				$_net_nics [$_i][$_net_RASa] = "N/A"
				$_net_nics [$_i][$_net_RASd] = "N/A"
				Select
					Case $_net_nics [$_i][$_net_ip__] = $_IP_local_1
						If $_net_nics [$_i][$_net_ip__] <> "0.0.0.0" Then $_net_nics [$_i][$_net_ipAd] = 1   				; n,13
					Case $_net_nics [$_i][$_net_ip__] = $_IP_local_2
						If $_net_nics [$_i][$_net_ip__] <> "0.0.0.0" Then $_net_nics [$_i][$_net_ipAd] = 2   				; n,13
					Case $_net_nics [$_i][$_net_ip__] = $_IP_local_3
						If $_net_nics [$_i][$_net_ip__] <> "0.0.0.0" Then $_net_nics [$_i][$_net_ipAd] = 3   				; n,13
					Case $_net_nics [$_i][$_net_ip__] = $_IP_local_4
						If $_net_nics [$_i][$_net_ip__] <> "0.0.0.0" Then $_net_nics [$_i][$_net_ipAd] = 4   				; n,13
				EndSelect
			Next
		Endif
		$_total_nics = $_i

		$colItems_2 = $objWMIService.ExecQuery ( "SELECT * FROM Win32_NetworkAdapter" , "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		If IsObj($colItems_2) then
			For $objItem_2 In $colItems_2
				For $_i = 0 To $_total_nics
					If $objItem_2.Index = $_net_nics [$_i][$_net_indx] Then
						If $objItem_2.MACAddress = $_net_nics [$_i][$_net_mac_] Then
							$_net_nics [$_i][$_net_conn] = $objItem_2.NetConnectionID
							$_net_nics [$_i][$_net_name] = $objItem_2.Name
							$_net_nics [$_i][$_net_isok] = -1
						Else
							$_net_nics [$_i][$_net_conn] = "unknown"
							$_net_nics [$_i][$_net_name] = "unknown"
						EndIf
						$_net_nics [$_i][$_net_stat] = $objItem_2.NetConnectionStatus
					EndIf
				Next
			Next
		Endif

		For $i = 1 To $_total_nics
			If $_net_nics [$i][$_net_dhcp] <> -RegRead ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & $_net_nics [$i][$_net_guid] , "EnableDHCP" ) Then
				$_net_nics [$i][$_net_dhcp] = "error"
			EndIf
		;	If $_net_nics [$i][$_net_dhcp] = -1 Then
		;		$read_key = "DhcpIPAddress"
		;	Else
		;		$read_key = "IPAddress"
		;		$_net_nics [$i][$_net_ip__] = RegRead ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & $_net_nics [$i][$_net_guid] , $read_key )
		;	EndIf
		;	If $_net_nics [$i][$_net_dhcp] = -1 Then
		;		$read_key = "DhcpSubnetMask"
		;	Else
		;		$read_key = "SubnetMask"
		;		$_net_nics [$i][$_net_mask] = RegRead ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & $_net_nics [$i][$_net_guid] , $read_key )
		;	EndIf
			If $_net_nics [$i][$_net_mask] <> "255.255.255.255" Then  	; is not PPPoE
				$_net_nics [$i][$_net_pppo] = 0
			Else														; is PPPoE [and is active]
				$_net_nics [$i][$_net_pppo] = -1
				$_net_nics [$i][$_net_isok] =  0 ; -1
				$_net_nics [$i][$_net_name] = _get_RAS_connecton_name ( )
				$_PPPoE_mac       = $_net_nics [$i][$_net_mac_]
				$_PPPoE_index     = $_net_nics [$i][$_net_indx]
				$_PPPoE_mask      = $_net_nics [$i][$_net_mask]
				$_PPPoE_IP        = $_net_nics [$i][$_net_ip__]
				$_PPPoE_IPaddress = $_net_nics [$i][$_net_ipAd]
				$_PPPoE_dhcp      = $_net_nics [$i][$_net_dhcp]
			EndIf
			If $_net_nics [$i][$_net_dhcp] = -1 Then
				$read_key = "DhcpDefaultGateway"
			Else
				$read_key = "DefaultGateway"
			EndIf
			$_net_nics [$i][$_net_gate] = RegRead ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & $_net_nics [$i][$_net_guid] , $read_key )
			If @error = -1 Then $_net_nics [$i][$_net_gate] = "N/A"
			
			If $_net_nics [$i][$_net_dhcp] = -1 Then
				$read_key = "DhcpServer"
			Else
				$read_key = "NameServer"
			EndIf
			$_net_nics [$i][$_net_dns_] = RegRead ( "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & $_net_nics [$i][$_net_guid] , $read_key )
			If @error = -1 Then $_net_nics [$i][$_net_dns_] = "N/A"
		Next

		_get_all_RAS_connections ( )
		_arrange_the_array ( )
		;ReDim $_net_nics [$_total_nics+$_total_RAS][$_NICs_data]
		;_ArrayDisplay ( $_net_nics , "my NICs" )
		$_fake_nics = 0
		For $_ii = 0 to -1+($_total_nics+$_total_RAS+1)
			If $_net_nics [$_ii][$_net_isok] Then
			Else
				$_fake_nics = $_fake_nics + 1
			EndIf
		Next
		;$_total_nics = $_total_nics - $_fake_nics
		$_diff_nics = 0
		Local $_t [-$_fake_nics+$_total_nics+$_total_RAS+1][$_NICs_data]
		For $_ii = 0 to -1+($_total_nics+$_total_RAS+1)
			If $_net_nics [$_ii][$_net_isok] Then
				For $_jj = 0 to -1+($_NICs_data)
					$_t [$_ii-$_diff_nics][$_jj] =  $_net_nics [$_ii][$_jj]
				Next
			Else
				$_diff_nics = $_diff_nics + 1
			EndIf
		Next
		$_total_nics = $_total_nics - $_fake_nics
	;	_ArrayDisplay ( $_t , "my NICs____" )
		ReDim $_net_nics [$_total_nics+$_total_RAS+1][$_NICs_data]
		For $_ii = 0 to -1+($_total_nics+$_total_RAS+1)
			For $_jj = 0 to -1+($_NICs_data)
				$_net_nics [$_ii][$_jj] = $_t [$_ii][$_jj]
				If $_jj = $_net_RASa Then 
					If ($_net_nics [$_ii][$_jj] = -1) Then $PPPoE = $_ii
				EndIf
			Next
		Next
		;-----------------------------
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _get_RAS_connecton_name ( )
		Return "_get_RAS_connecton_name ( )"
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _move_IP ( $_IP_to_move ) ; can be 1,2,3,4 = place = @IPAddress_[$_IP_to_move]
		If Eval ( "_IP_local_" & $_IP_to_move ) = "0.0.0.0" Then Return
		Local $_IP_from_move = -1
		Local $_buffer
		If Eval ( "_IP_local_" & $_IP_to_move ) = $_net_nics [$_IP_to_move][$_net_ip__] Then 
			Return
		Else
			For $_jj = 1 To $_total_nics
				If $_net_nics [$_jj][$_net_ip__] = Eval ( "_IP_local_" & $_IP_to_move ) Then
					$_IP_from_move = $_jj
					ExitLoop
				EndIf
			Next
			For $_jj = 0 To 13
				$_buffer = $_net_nics [$_IP_to_move][$_jj]
				$_net_nics [$_IP_to_move][$_jj] = $_net_nics [$_IP_from_move][$_jj]
				$_net_nics [$_IP_from_move][$_jj] = $_buffer
			Next
		EndIf
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _arrange_the_array ( )
		_move_IP ( 1 )
		_move_IP ( 2 )
		_move_IP ( 3 )
		_move_IP ( 4 )
		$_net_nics [0][$_net_isok] = "[is ok]"
		$_net_nics [0][$_net_guid] = "[guid]"
		$_net_nics [0][$_net_conn] = "[connection name]"
		$_net_nics [0][$_net_name] = "[product name]"
		$_net_nics [0][$_net_dhcp] = "[dhcp]"
		$_net_nics [0][$_net_ip__] = "[ip]"
		$_net_nics [0][$_net_stat] = "[WMI_status]"
		$_net_nics [0][$_net_mask] = "[mask]"
		$_net_nics [0][$_net_gate] = "[gateway]"
		$_net_nics [0][$_net_dns_] = "[dns]"
		$_net_nics [0][$_net_mac_] = "[mac address]"
		$_net_nics [0][$_net_indx] = "[WMI_index]"
		$_net_nics [0][$_net_pppo] = "[PPPoE]"
		$_net_nics [0][$_net_ipAd] = "[@IPAddress x]"
		$_net_nics [0][$_net_RASa] = "[PPPoE active]"
		$_net_nics [0][$_net_RASd] = "[PPPoE default]"
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _get_all_RAS_connections ( )
		Local $_buffer , $_j = 0
		Local $_temp
		Local $_file_rasphone = @AppDataCommonDir & "\Microsoft\Network\Connections\Pbk\rasphone.pbk"
		Local $_rasphone_lines = _FileCountLines ( $_file_rasphone ) ;- 1
		;-----------------------------
		For $i = 1 to $_rasphone_lines
			$_buffer    = FileReadLine ( $_file_rasphone , $i )
			If StringInStr ( $_buffer , "]" ) Then
				$_total_RAS = $_total_RAS + 1
				$_j = $_j + 1
				$_buffer = StringSplit ( $_buffer , "]")
				$_buffer = $_buffer [1]
				$_buffer = StringSplit ( $_buffer , "[")
				$_buffer = $_buffer [2]
				$_net_nics [$_total_nics+$_j][$_net_conn] = $_buffer
				$_net_nics [$_total_nics+$_j][$_net_isok] = -1
				$_net_nics [$_total_nics+$_j][$_net_pppo] = -1
				$_net_nics [$_total_nics+$_j][$_net_name] = IniRead ( @AppDataCommonDir & "\Microsoft\Network\Connections\Pbk\rasphone.pbk" , $_buffer , "DEVICE", "" )
				If $_buffer = RegRead ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\RAS AutoDial\Default" , "DefaultInternet" ) Then
					$_net_nics [$_total_nics+$_j][$_net_RASd] = -1
				Else
					$_net_nics [$_total_nics+$_j][$_net_RASd] = 0
				EndIf
				$_net_nics [$_total_nics+$_j][$_net_stat] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_RASa] = 0
				$_net_nics [$_total_nics+$_j][$_net_mac_] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_indx] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_mask] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_ip__] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_gate] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_ipAd] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_dhcp] = 0
				$_net_nics [$_total_nics+$_j][$_net_guid] = "N/A"
				$_net_nics [$_total_nics+$_j][$_net_dns_] = "N/A"
				$_temp = StringSplit ( $_ipcfgall , "PPP adapter " , 1 )
				If $_temp[0] > 1 Then
					$_temp = StringSplit ( $_temp[2] , ":" , 1 )
					If stringinstr($_temp[1] , $_buffer ) Then
						$_net_nics [$_total_nics+$_j][$_net_RASa] = -1
						$_net_nics [$_total_nics+$_j][$_net_mac_] = $_PPPoE_mac
						$_net_nics [$_total_nics+$_j][$_net_indx] = $_PPPoE_index
						$_net_nics [$_total_nics+$_j][$_net_mask] = $_PPPoE_mask
						$_net_nics [$_total_nics+$_j][$_net_ip__] = $_PPPoE_IP
						$_net_nics [$_total_nics+$_j][$_net_ipAd] = $_PPPoE_IPaddress
						$_net_nics [$_total_nics+$_j][$_net_gate] = $_PPPoE_IP
						$_net_nics [$_total_nics+$_j][$_net_dhcp] = $_PPPoE_dhcp
						For $_ii = 1 To 15
							$_buff_1 = RegEnumKey ( "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\" , $_ii )
							If RegRead ( "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\" & $_buff_1 , "DhcpIPAddress" ) = $_PPPoE_IP Then
								$_net_nics [$_total_nics+$_j][$_net_dhcp] = -1
								$_net_nics [$_total_nics+$_j][$_net_guid] = $_buff_1
								$_net_nics [$_total_nics+$_j][$_net_dns_] = RegRead ( "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters\Interfaces\" & $_buff_1 , "NameServer" )
							EndIf
						Next
					EndIf
				EndIf
			EndIf
		Next
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func readIpConfig()
		Local $foo
		$foo    = Run ( "ipconfig /all" , @SystemDir , @SW_HIDE , $STDOUT_CHILD )
		$output = ""
		While 1
			$output &= StdoutRead ( $foo )
			If @error Then ExitLoop
		Wend
		ConsoleWrite ( $_ipcfgall )
		Return $output
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
;$SecLogonState = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\seclogon", "Start")
;If $SecLogonState = "4" Then ; 4 means disabled, 3 means manual, 2 means automatic, 1 means system (?), 0 means boot (?)
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
;	set svc = getObject("winmgmts:Root\cimv2") 
;	set objEnum = svc.execQuery("Select * from win32_service where name = 
;	'remoteAccess'") 
;	for each obj in objEnum 
;	wscript.echo obj.GetObjectText_() 
;	next 
	;----------------------------------------------------------------------------
;	strComputer = "."
;	Set objWMIService = GetObject("winmgmts:" _
;		&; "{impersonationLevel=impersonate}!\\" &; strComputer &; "\root\cimv2")
;	set objRefresher = CreateObject("WbemScripting.SWbemRefresher")
;	Set colItems = objRefresher.AddEnum(objWMIService," & _
;		"Win32_PerfFormattedData_PerfProc_RemoteAccess_RASPort").objectSet
;	objRefresher.Refresh
	;----------------------------------------------------------------------------
;	Win32_PerfRawData_RemoteAccess_RASPort
;	Win32_PerfRawData_RemoteAccess_RASTotal
;	Win32_PerfFormattedData_RemoteAccess_RASPort
;	Win32_PerfFormattedData_RemoteAccess_RASTotal
;----------------------------------------------------------------------------
;	RSOP_IEConnectionDialUpSettings.rasEntryData
;	RSOP_IEConnectionDialUpSettings.rasEntryDataSize
;----------------------------------------------------------------------------
;$objEvents = GetObject("winmgmts:\\.\root\cimv2").ExecNotificationQuery	("SELECT TargetInstance.Name FROM __InstanceOperationEvent WITHIN "	+"4 WHERE TargetInstance ISA 'Win32_NetworkAdapterConfiguration'")
;----------------------------------------------------------------------------
;----------------------------------------------------------------------------
;	Set Events = GetObject("winmgmts:\\.\root\cimv2").ExecNotificationQuery
;	("SELECT TargetInstance.Name FROM __InstanceOperationEvent WITHIN 4
;	WHERE TargetInstance ISA 'Win32_NetworkAdapterConfiguration'")
;----------------------------------------------------------------------------
;	strComputer = "."
;	strAddress = Wscript.Arguments.Item(0)
;	arrIPAddress = Array(strAddress)
;	arrSubnetMask = Array("255.255.255.0")
;	Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
;	Set colNetAdapters = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled=TRUE")
;	For Each objNetAdapter in colNetAdapters
;		 errEnableStatic = objNetAdapter.EnableStatic(arrIPAddress, arrSubnetMask)
;	Next
;----------------------------------------------------------------------------
;	Win32_Proxy
;----------------------------------------------------------------------------
;	Win32_UserAccount
;----------------------------------------------------------------------------
;	Select * from Win32_PnPEntity Where Manufacturer = 'Microsoft' and Name Like 'wan miniport%'
;----------------------------------------------------------------------------
;	select AdapterType, DeviceID, ProductName, ServiceName, NetConnectionID,
;	MACAddress from Win32_NetworkAdapter
;	-------------------------------------------------------
;	Select * from Win32_PnPEntity Where Manufacturer = 'Microsoft' or Manufacturer = 'Intel'
;	-------------------------------------------------------
;	You'll need to enumerate the available connections by their deviceID/index. This will allow you to parse each and determine which is the "RAS Async Adapter" and then you can "get" it's IPAddress property. 
;	The key is that you must find the correct adapter. When you query Win32_NetworkAdapter, you actually have a collection. Typically you have 0-5 being
;	0 - Nic
;	1 - Ras async adapter
;	2 - wan miniport (l2tp)
;	3 - wan miniport (pptp)
;	4 - Direct parallel
;	5 - WAN Miniport (IP)
;	or something of the sort. If you can retrieve Win32_NetworkAdapter.DeviceID="5" then you Obj.Get("IPAdress"). This is assuming you have the same list as above. If you're not sure, grab a copy of the MS WMI Object Browser from:
;	msdn.microsoft.com/downloads/default.asp?URL=/code/sample.asp?url=/msdn-files/027/001/566/msdncompositedoc.xml
;	to pick through your own. Good luck!
;	-------------------------------------------------------
;	                                                      [enable PPPoE as service in XP]
;	-------------------------------------------------------
;	HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RasPppoe -> start
;	-------------------------------------------------------
;MsgBox (GetObject("WinMgmts:Win32_LogicalDisk='C:'").VolumeSerialNumber)
;	-------------------------------------------------------
