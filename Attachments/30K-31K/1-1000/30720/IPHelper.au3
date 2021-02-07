#Region Header

#cs

    Title:          Internet Protocol Helper (IP Helper) UDF Library for AutoIt3
    Filename:       IPHelper.au3
    Description:    Management of network configuration settings
    Author:         Yashied
    Version:        0.1
    Requirements:   AutoIt v3.3.4.x, Developed/Tested on Windows Vista/7
    Uses:           WinAPI.au3
    Note:           Most functions from this library requires Windows Vista or later

	Available functions:

    _IPHelper_Close
    _IPHelper_ConvertInterfaceAliasToLuid
    _IPHelper_ConvertInterfaceGuidToLuid
    _IPHelper_ConvertInterfaceLuidToAlias
    _IPHelper_ConvertInterfaceLuidToGuid
    _IPHelper_GetIfEntry2
    _IPHelper_GetIfTable2
    _IPHelper_GetNumberOfInterfaces
    _IPHelper_Open

    Example:

    #Include <Array.au3>
    #Include <IPHelper.au3>

    _IPHelper_Open()

    Global $Table = _IPHelper_GetIfTable2()

    If IsArray($Table) Then
        _ArrayDisplay($Table, '_IPHelper_GetIfTable2')
    EndIf

    _IPHelper_Close()

#ce

#Include-once

#Include <WinAPI.au3>

#EndRegion Header

#Region Global Variables and Constants

; "Type"
Global Const $IF_TYPE_OTHER = 1
Global Const $IF_TYPE_ETHERNET_CSMACD = 6
Global Const $IF_TYPE_ISO88025_TOKENRING = 9
Global Const $IF_TYPE_PPP = 23
Global Const $IF_TYPE_SOFTWARE_LOOPBACK = 24
Global Const $IF_TYPE_ATM = 37
Global Const $IF_TYPE_IEEE80211 = 71
Global Const $IF_TYPE_TUNNEL = 131
Global Const $IF_TYPE_IEEE1394 = 144

; "TunnelType"
Global Const $TUNNEL_TYPE_NONE = 0
Global Const $TUNNEL_TYPE_OTHER = 1
Global Const $TUNNEL_TYPE_DIRECT = 2
Global Const $TUNNEL_TYPE_6TO4 = 11
Global Const $TUNNEL_TYPE_ISATAP = 13
Global Const $TUNNEL_TYPE_TEREDO = 14

; "MediaType"
Global Const $NdisMedium802_3 = 0
Global Const $NdisMedium802_5 = 1
Global Const $NdisMediumFddi = 2
Global Const $NdisMediumWan = 3
Global Const $NdisMediumLocalTalk = 4
Global Const $NdisMediumDix = 5
Global Const $NdisMediumArcnetRaw = 6
Global Const $NdisMediumArcnet878_2 = 7
Global Const $NdisMediumAtm = 8
Global Const $NdisMediumWirelessWan = 9
Global Const $NdisMediumIrda = 10
Global Const $NdisMediumBpc = 11
Global Const $NdisMediumCoWan = 12
Global Const $NdisMedium1394 = 13
Global Const $NdisMediumInfiniBand = 14
Global Const $NdisMediumTunnel = 15
Global Const $NdisMediumNative802_11 = 16
Global Const $NdisMediumLoopback = 17

; "PhysicalMediumType"
Global Const $NdisPhysicalMediumUnspecified = 0
Global Const $NdisPhysicalMediumWirelessLan = 1
Global Const $NdisPhysicalMediumCableModem = 2
Global Const $NdisPhysicalMediumPhoneLine = 3
Global Const $NdisPhysicalMediumPowerLine = 4
Global Const $NdisPhysicalMediumDSL = 5
Global Const $NdisPhysicalMediumFibreChannel = 6
Global Const $NdisPhysicalMedium1394 = 7
Global Const $NdisPhysicalMediumWirelessWan = 8
Global Const $NdisPhysicalMediumNative802_11 = 9
Global Const $NdisPhysicalMediumBluetooth = 10
Global Const $NdisPhysicalMediumInfiniband = 11
Global Const $NdisPhysicalMediumWiMax = 12
Global Const $NdisPhysicalMediumUWB = 13
Global Const $NdisPhysicalMedium802_3 = 14
Global Const $NdisPhysicalMedium802_5 = 15
Global Const $NdisPhysicalMediumIrda = 16
Global Const $NdisPhysicalMediumWiredWAN = 17
Global Const $NdisPhysicalMediumWiredCoWan = 18
Global Const $NdisPhysicalMediumOther = 19

; "AccessType"
Global Const $NET_IF_ACCESS_LOOPBACK = 1
Global Const $NET_IF_ACCESS_BROADCAST = 2
Global Const $NET_IF_ACCESS_POINT_TO_POINT = 3
Global Const $NET_IF_ACCESS_POINT_TO_MULTI_POINT = 4
Global Const $NET_IF_ACCESS_MAXIMUM = 5

; "DirectionType"
Global Const $NET_IF_DIRECTION_SENDRECEIVE = 0
Global Const $NET_IF_DIRECTION_SENDONLY = 1
Global Const $NET_IF_DIRECTION_RECEIVEONLY = 2
Global Const $NET_IF_DIRECTION_MAXIMUM = 3

; "OperStatus"
Global Const $IfOperStatusUp = 1
Global Const $IfOperStatusDown = 2
Global Const $IfOperStatusTesting = 3
Global Const $IfOperStatusUnknown = 4
Global Const $IfOperStatusDormant = 5
Global Const $IfOperStatusNotPresent = 6
Global Const $IfOperStatusLowerLayerDown = 7

; "AdminStatus"
Global Const $NET_IF_ADMIN_STATUS_UP = 1
Global Const $NET_IF_ADMIN_STATUS_DOWN = 2
Global Const $NET_IF_ADMIN_STATUS_TESTING = 3

; "MediaConnectState"
Global Const $MediaConnectStateUnknown = 0
Global Const $MediaConnectStateConnected = 1
Global Const $MediaConnectStateDisconnected = 2

; "ConnectionType"
Global Const $NET_IF_CONNECTION_DEDICATED = 1
Global Const $NET_IF_CONNECTION_PASSIVE = 2
Global Const $NET_IF_CONNECTION_DEMAND = 3
Global Const $NET_IF_CONNECTION_MAXIMUM = 4

Global Const $tagMIB_IF_ROW2 = _
		'uint64;' & _
		'uint   InterfaceIndex;' & _
		'dword;' & _
		'ushort;' & _
		'ushort;' & _
		'byte[8];' & _
		'wchar  Alias[257];' & _
		'wchar  Description[257];' & _
		'uint   PhysicalAddressLength;' & _
		'byte   PhysicalAddress[32];' & _
		'byte   PermanentPhysicalAddress[32];' & _
		'uint   Mtu;' & _
		'uint   Type;' & _
		'uint   TunnelType;' & _
		'uint   MediaType;' & _
		'uint   PhysicalMediumType;' & _
		'uint   AccessType;' & _
		'uint   DirectionType;' & _
		'uint   InterfaceAndOperStatusFlags;' & _
		'uint   OperStatus;' & _
		'uint   AdminStatus;' & _
		'uint   MediaConnectState;' & _
		'dword;' & _
		'ushort;' & _
		'ushort;' & _
		'byte[8];' & _
		'uint   ConnectionType;' & _
		'uint64 TransmitLinkSpeed;' & _
		'uint64 ReceiveLinkSpeed;' & _
		'uint64 InOctets;' & _
		'uint64 InUcastPkts;' & _
		'uint64 InNUcastPkts;' & _
		'uint64 InDiscards;' & _
		'uint64 InErrors;' & _
		'uint64 InUnknownProtos;' & _
		'uint64 InUcastOctets;' & _
		'uint64 InMulticastOctets;' & _
		'uint64 InBroadcastOctets;' & _
		'uint64 OutOctets;' & _
		'uint64 OutUcastPkts;' & _
		'uint64 OutNUcastPkts;' & _
		'uint64 OutDiscards;' & _
		'uint64 OutErrors;' & _
		'uint64 OutUcastOctets;' & _
		'uint64 OutMulticastOctets;' & _
		'uint64 OutBroadcastOctets;' & _
		'uint64 OutQLen;'

Global Const $tagMIB_IF_TABLE2 = 'uint NumEntries;dword Alignment;' ; & $tagMIB_IF_ROW2[n]

#EndRegion Global Variables and Constants

#Region Local Variables and Constants

Global $__IPHelper_Dll = -1, $__IPHelper_Ref = 0

#EndRegion Local Variables and Constants

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_Close
; Description....: Cleans up resources used by IPHelper, and closes library.
; Syntax.........: _IPHelper_Close ( )
; Parameters.....: None
; Return values..: Success - 1.
;                  Failure - 0 and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related........:
; Link...........: None
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_Close()
	If Not $__IPHelper_Ref Then
		Return SetError(1, 0, 0)
	EndIf
	$__IPHelper_Ref -= 1
	If Not $__IPHelper_Ref Then
		DllClose($__IPHelper_Dll)
		$__IPHelper_Dll = -1
	EndIf
	Return 1
EndFunc   ;==>_IPHelper_Close

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_ConvertInterfaceAliasToLuid
; Description....: Converts a network interface name to the locally unique identifier (LUID) for the interface.
; Syntax.........: _IPHelper_ConvertInterfaceAliasToLuid ( $sInterface )
; Parameters.....: $sInterface - A string containing the network interface name.
; Return values..: Success     - LUID for the specified interface.
;                  Failure     - 0 and sets the @error flag to non-zero, @extended flag may contain the nonzero system error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or above.
; Related........:
; Link...........: @@MsdnLink@@ ConvertInterfaceAliasToLuid
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_ConvertInterfaceAliasToLuid($sInterface)

	Local $tLUID = DllStructCreate('uint64')
	Local $Ret = DLLCall($__IPHelper_Dll, 'uint', 'ConvertInterfaceAliasToLuid', 'wstr', $sInterface, 'ptr', DllStructGetPtr($tLUID))

	If @error Then
		Return SetError(1, 0, 0)
	Else
		If $Ret[0] Then
			Return SetError(1, $Ret[0], 0)
		EndIf
	EndIf
	Return DllStructGetData($tLUID, 1)
EndFunc   ;==>_IPHelper_ConvertInterfaceAliasToLuid

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_ConvertInterfaceGuidToLuid
; Description....: Converts a globally unique identifier (GUID) for a network interface to the locally unique identifier (LUID) for the interface.
; Syntax.........: _IPHelper_ConvertInterfaceGuidToLuid ( $GUID )
; Parameters.....: $GUID   - A string representation of the GUID. The string should be in the following form:
;
;                            {00000000-0000-0000-0000-000000000000}
;
; Return values..: Success - LUID for the specified interface.
;                  Failure - 0 and sets the @error flag to non-zero, @extended flag may contain the nonzero system error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or above.
; Related........:
; Link...........: @@MsdnLink@@ ConvertInterfaceGuidToLuid
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_ConvertInterfaceGuidToLuid($GUID)

	Local $tGUID = _WinAPI_GUIDFromString($GUID)

	If Not IsDllStruct($tGUID) Then
		Return SetError(1, 0, 0)
	EndIf

	Local $tLUID = DllStructCreate('uint64')
	Local $Ret = DLLCall($__IPHelper_Dll, 'uint', 'ConvertInterfaceGuidToLuid', 'ptr', DllStructGetPtr($tGUID), 'ptr', DllStructGetPtr($tLUID))

	If @error Then
		Return SetError(1, 0, 0)
	Else
		If $Ret[0] Then
			Return SetError(1, $Ret[0], 0)
		EndIf
	EndIf
	Return DllStructGetData($tLUID, 1)
EndFunc   ;==>_IPHelper_ConvertInterfaceGuidToLuid

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_GetIfEntry2
; Description....: Retrieves information for the specified interface on the local computer.
; Syntax.........: _IPHelper_GetIfEntry2 ( $LUID )
; Parameters.....: $LUID   - The locally unique identifier (LUID) for the network interface for which information is to be retrieved.
; Return values..: Success - 1D array containing the information for the specified interface. This array is similar to an array
;                            which returns _IPHelper_GetIfTable2() function.
;                  Failure - 0 and sets the @error flag to non-zero, @extended flag may contain the nonzero system error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or above.
; Related........:
; Link...........: @@MsdnLink@@ GetIfEntry2
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_GetIfEntry2($LUID)

	Local $Row[39], $Ret, $Lenght, $Offset = 1
	Local $tMIB_IF_ROW2

	$tMIB_IF_ROW2 = DllStructCreate($tagMIB_IF_ROW2)
	DllStructSetData($tMIB_IF_ROW2, 1, $LUID)
	$Ret = DLLCall($__IPHelper_Dll, 'uint', 'GetIfEntry2', 'ptr', DllStructGetPtr($tMIB_IF_ROW2))
	If @error Then
		Return SetError(1, 0, 0)
	Else
		If $Ret[0] Then
			Return SetError(1, $Ret[0], 0)
		EndIf
	EndIf
	$Lenght = DllStructGetData($tMIB_IF_ROW2, 'PhysicalAddressLength')
	For $i = 0 To 38
		Switch $i
			Case 2, 18
				$Row[$i] = _WinAPI_StringFromGUID(DllStructGetPtr(DllStructCreate($tagGUID, DllStructGetPtr($tMIB_IF_ROW2, $Offset))))
				$Offset += 4
				ContinueLoop
			Case 5
				$Offset += 1
				ContinueCase
			Case 6
				$Row[$i] = ''
				For $j = 1 To $Lenght
					$Row[$i] &= Hex(DllStructGetData($tMIB_IF_ROW2, $Offset, $j), 2) & '-'
				Next
				$Row[$i] = StringTrimRight($Row[$i], 1)
			Case Else
				$Row[$i] = DllStructGetData($tMIB_IF_ROW2, $Offset)
		EndSwitch
		$Offset += 1
	Next
	Return $Row
EndFunc   ;==>_IPHelper_GetIfEntry2

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_GetIfTable2
; Description....: Retrieves an information about a logical and physical interfaces.
; Syntax.........: _IPHelper_GetIfTable2 ( [$iType [, $fHardware]] )
; Parameters.....: $iType     - The interface type. If this parameter is 0, function retrieves information for all interfaces on the
;                               local computer. This parameter can be 0 or one of the following values.
;
;                               $IF_TYPE_OTHER
;                               $IF_TYPE_ETHERNET_CSMACD
;                               $IF_TYPE_ISO88025_TOKENRING
;                               $IF_TYPE_PPP
;                               $IF_TYPE_SOFTWARE_LOOPBACK
;                               $IF_TYPE_ATM
;                               $IF_TYPE_IEEE80211
;                               $IF_TYPE_TUNNEL
;                               $IF_TYPE_IEEE1394
;
;                  $fHardware - Specifies for which interfaces retrieve information, valid values:
;                  |TRUE      - Only hardware (physical) interfaces. (Default)
;                  |FALSE     - Logical and physical interfaces.
; Return values..: Success    - 2D array (table) containing the information for an interfaces:
;
;                               [0][0 ] - The number of interface entries in the array (n).
;                               [n][0 ] - The locally unique identifier (LUID) for the network interface.
;                               [n][1 ] - The index that identifies the network interface.
;                               [n][2 ] - The GUID for the network interface.
;                               [n][3 ] - A string that contains the alias name of the network interface.
;                               [n][4 ] - A string that contains a description of the network interface.
;                               [n][5 ] - The physical hardware address of the adapter for this network interface.
;                               [n][6 ] - The permanent physical hardware address of the adapter for this network interface.
;                               [n][7 ] - The maximum transmission unit (MTU) size, in bytes, for this network interface.
;                               [n][8 ] - The interface type ($IF_TYPE_...).
;                               [n][9 ] - The encapsulation method used by a tunnel ($TUNNEL_TYPE_...).
;                               [n][10] - The NDIS media type for the interface ($NdisMedium...).
;                               [n][11] - The NDIS physical medium type ($NdisPhysicalMedium...).
;                               [n][12] - The interface access type ($NET_IF_ACCESS_...).
;                               [n][13] - The interface direction type ($NET_IF_DIRECTION_...).
;                               [n][14] - The flags that provide information about the interface, valid bits:
;                                         0 - Set if the network interface is for hardware.
;                                         1 - Set if the network interface is for a filter module.
;                                         2 - Set if a connector is present on the network interface.
;                                         3 - Set if the default port for the network interface is not authenticated.
;                                         4 - Set if the network interface is not in a media-connected state.
;                                         5 - Set if the network stack for the network interface is in the paused or pausing state.
;                                         6 - Set if the network interface is in a low power state.
;                                         7 - Set if the network interface is an endpoint device and not a true network interface that connects to a network.
;                               [n][15] - The operational status for the interface ($IfOperStatus...).
;                               [n][16] - The administrative status for the interface ($NET_IF_ADMIN_STATUS_...).
;                               [n][17] - The connection state of the interface ($MediaConnectState...).
;                               [n][18] - The GUID that is associated with the network that the interface belongs to.
;                               [n][19] - The NDIS network interface connection type ($NET_IF_CONNECTION_...).
;                               [n][20] - The speed in bits per second of the transmit link.
;                               [n][21] - The speed in bits per second of the receive link.
;                               [n][22] - The number of octets of data received without errors.
;                               [n][23] - The number of unicast packets received without errors.
;                               [n][24] - The number of non-unicast packets received without errors.
;                               [n][25] - The number of inbound packets which were chosen to be discarded even though no errors were detected to prevent the packets from being deliverable to a higher-layer protocol.
;                               [n][26] - The number of incoming packets that were discarded because of errors.
;                               [n][27] - The number of incoming packets that were discarded because the protocol was unknown.
;                               [n][28] - The number of octets of data received without errors in unicast packets.
;                               [n][29] - The number of octets of data received without errors in multicast packets.
;                               [n][30] - The number of octets of data received without errors in broadcast packets.
;                               [n][31] - The number of octets of data transmitted without errors.
;                               [n][32] - The number of unicast packets transmitted without errors.
;                               [n][33] - The number of non-unicast packets transmitted without errors.
;                               [n][34] - The number of outgoing packets that were discarded even though they did not have errors.
;                               [n][35] - The number of outgoing packets that were discarded because of errors.
;                               [n][36] - The number of octets of data transmitted without errors in unicast packets.
;                               [n][37] - The number of octets of data transmitted without errors in multicast packets.
;                               [n][38] - The number of octets of data transmitted without errors in broadcast packets.
;
;                  Failure    - 0 and sets the @error flag to non-zero, @extended flag may contain the nonzero system error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or above.
; Related........:
; Link...........: @@MsdnLink@@ GetIfTable2
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_GetIfTable2($iType = 0, $fHardware = 1)

	Local $Row = 'byte[' & DllStructGetSize(DllStructCreate($tagMIB_IF_ROW2)) & ']'
	Local $Ret, $Table, $Type, $Flags, $Lenght, $Num, $Offset, $Struct = ''
	Local $tMIB_IF_ROW2, $tMIB_IF_TABLE2

	$Ret = DLLCall($__IPHelper_Dll, 'uint', 'GetIfTable2', 'ptr*', 0)
	If @error Then
		Return SetError(1, 0, 0)
	Else
		If $Ret[0] Then
			Return SetError(1, $Ret[0], 0)
		EndIf
	EndIf
	$tMIB_IF_TABLE2 = DllStructCreate($tagMIB_IF_TABLE2, $Ret[1])
	$Num = DllStructGetData($tMIB_IF_TABLE2, 'NumEntries')
	For $i = 1 To $Num
		$Struct &= $Row & ';'
	Next
	$tMIB_IF_TABLE2 = DllStructCreate($tagMIB_IF_TABLE2 & $Struct,  $Ret[1])
	Dim $Table[$Num + 1][39]
	$Table[0][0] = 0
	For $i = 1 To $Num
		$tMIB_IF_ROW2 = DllStructCreate($tagMIB_IF_ROW2, DllStructGetPtr($tMIB_IF_TABLE2, $i + 1))
		$Type = DllStructGetData($tMIB_IF_ROW2, 'Type')
		$Flags = DllStructGetData($tMIB_IF_ROW2, 'InterfaceAndOperStatusFlags')
		If (($iType = 0) Or ($iType = $Type)) And ((($fHardware) And (BitAND($Flags, 1))) Or (Not $fHardware)) Then
			$Table[0][0] += 1
			$Offset = 1
			$Lenght = DllStructGetData($tMIB_IF_ROW2, 'PhysicalAddressLength')
			For $j = 0 To 38
				Switch $j
					Case 2, 18
						$Table[$Table[0][0]][$j] = _WinAPI_StringFromGUID(DllStructGetPtr(DllStructCreate($tagGUID, DllStructGetPtr($tMIB_IF_ROW2, $Offset))))
						$Offset += 4
						ContinueLoop
					Case 5
						$Offset += 1
						ContinueCase
					Case 6
						$Table[$Table[0][0]][$j] = ''
						For $k = 1 To $Lenght
							$Table[$Table[0][0]][$j] &= Hex(DllStructGetData($tMIB_IF_ROW2, $Offset, $k), 2) & '-'
						Next
						$Table[$Table[0][0]][$j] = StringTrimRight($Table[$Table[0][0]][$j], 1)
					Case 8
						$Table[$Table[0][0]][$j] = $Type
					Case 14
						$Table[$Table[0][0]][$j] = $Flags
					Case Else
						$Table[$Table[0][0]][$j] = DllStructGetData($tMIB_IF_ROW2, $Offset)
				EndSwitch
				$Offset += 1
			Next
		EndIf
	Next
	DllCall($__IPHelper_Dll, 'none', 'FreeMibTable', 'ptr', $Ret[1])
	If $Table[0][0] < $Num Then
		ReDim $Table[$Table[0][0] + 1][39]
	EndIf
	Return $Table
EndFunc   ;==>_IPHelper_GetIfTable2

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_GetNumberOfInterfaces
; Description....: Retrieves the number of interfaces on the local computer.
; Syntax.........: _IPHelper_GetNumberOfInterfaces ( )
; Parameters.....: None
; Return values..: Success - A number of interfaces.
;                  Failure - 0 and sets the @error flag to non-zero, @extended flag may contain the nonzero system error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related........:
; Link...........: @@MsdnLink@@ GetNumberOfInterfaces
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_GetNumberOfInterfaces()

	Local $Ret = DLLCall($__IPHelper_Dll, 'dword', 'GetNumberOfInterfaces', 'dword*', 0)

	If @error Then
		Return SetError(1, 0, 0)
	Else
		If $Ret[0] Then
			Return SetError(1, $Ret[0], 0)
		EndIf
	EndIf
	Return $Ret[1]
EndFunc   ;==>_IPHelper_GetNumberOfInterfaces

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_ConvertInterfaceLuidToAlias
; Description....: Converts a locally unique identifier (LUID) for a network interface to an interface alias.
; Syntax.........: _IPHelper_ConvertInterfaceLuidToAlias ( $LUID )
; Parameters.....: $LUID   - A LUID for a network interface.
; Return values..: Success - A string containing the alias name of the network interface.
;                  Failure - Empty string and sets the @error flag to non-zero, @extended flag may contain the nonzero system error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or above.
; Related........:
; Link...........: @@MsdnLink@@ ConvertInterfaceLuidToAlias
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_ConvertInterfaceLuidToAlias($LUID)

	Local $tAlias = DllStructCreate('wchar[257]')
	Local $Ret = DLLCall($__IPHelper_Dll, 'uint', 'ConvertInterfaceLuidToAlias', 'uint64*', $LUID, 'ptr', DllStructGetPtr($tAlias), 'uint', 257)

	If @error Then
		Return SetError(1, 0, '')
	Else
		If $Ret[0] Then
			Return SetError(1, $Ret[0], '')
		EndIf
	EndIf
	Return DllStructGetData($tAlias, 1)
EndFunc   ;==>_IPHelper_ConvertInterfaceLuidToAlias

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_ConvertInterfaceLuidToGuid
; Description....: Converts a locally unique identifier (LUID) for a network interface to a globally unique identifier (GUID) for the interface.
; Syntax.........: _IPHelper_ConvertInterfaceLuidToGuid ( $LUID )
; Parameters.....: $LUID   - A LUID for a network interface.
; Return values..: Success - A string representation of the GUID, in the following form:
;
;                            {00000000-0000-0000-0000-000000000000}
;
;                  Failure - Empty string and sets the @error flag to non-zero, @extended flag may contain the nonzero system error code.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or above.
; Related........:
; Link...........: @@MsdnLink@@ ConvertInterfaceLuidToGuid
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_ConvertInterfaceLuidToGuid($LUID)

	Local $tGUID = DllStructCreate($tagGUID)
	Local $Ret = DLLCall($__IPHelper_Dll, 'uint', 'ConvertInterfaceLuidToGuid', 'uint64*', $LUID, 'ptr', DllStructGetPtr($tGUID))

	If @error Then
		Return SetError(1, 0, '')
	Else
		If $Ret[0] Then
			Return SetError(1, $Ret[0], '')
		EndIf
	EndIf

	Local $Result = _WinAPI_StringFromGUID(DllStructGetPtr($tGUID))

	If Not $Result Then
		Return SetError(1, 0, '')
	EndIf
	Return $Result
EndFunc   ;==>_IPHelper_ConvertInterfaceLuidToGuid

; #FUNCTION# ====================================================================================================================
; Name...........: _IPHelper_Open
; Description....: Initializes IPHelper library (IPHlpApi.dll).
; Syntax.........: _IPHelper_Open ( )
; Parameters.....: None
; Return values..: Success - 1.
;                  Failure - 0 and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related........:
; Link...........: None
; Example........: Yes
; ===============================================================================================================================

Func _IPHelper_Open()
	If Not $__IPHelper_Ref Then
		$__IPHelper_Dll = DllOpen('IPHlpApi.dll')
		If $__IPHelper_Dll < 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	$__IPHelper_Ref += 1
	Return 1
EndFunc   ;==>_IPHelper_Open

#EndRegion Public Functions
