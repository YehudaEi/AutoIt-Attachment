Opt("MustDeclareVars",1)

Func xml_encode($val)
	Return StringReplace(StringReplace(StringReplace($val, "&", "&#x26;"), "<", "&#x3c"), ">", "&#x3e")
EndFunc

Func xml_makeNode($tag, $val)
	If StringLen($val) = 0 Then Return "<" & StringUpper($tag) & "></" & StringUpper($tag) & ">" & @CRLF
;~ 	ConsoleWrite($tag & "=" & $val & @CRLF)
	Return "<" & StringUpper($tag) & ">" & xml_encode($val) & "</" & StringUpper($tag) & ">" & @CRLF
EndFunc

Func _GetXML(ByRef $Struct, $Name)
	Local $val = DllStructGetData($Struct,$Name)
	If @error Then Return xml_makeNode($Name, "")
	Return xml_makeNode($Name, $val)
EndFunc

Global Const $tagIP_ADDRESS_STRING = "char IPAddress[16];"
Global Const $tagIP_MASK_STRING = "char IPMask[16];"
Global Const $tagIP_ADDR_STRING = "ptr Next;" & $tagIP_ADDRESS_STRING & $tagIP_MASK_STRING & "DWORD Context;"

Global Const $tagIP_ADAPTER_INFO = "ptr Next; DWORD ComboIndex; char AdapterName[260];char Description[132]; UINT AddressLength; BYTE Address[8]; dword Index; UINT Type;" & _
		" UINT DhcpEnabled; ptr CurrentIpAddress; ptr IpAddressListNext; char IpAddressListADDRESS[16]; char IpAddressListMASK[16]; DWORD IpAddressListContext; " & _
		"ptr GatewayListNext; char GatewayListADDRESS[16]; char GatewayListMASK[16]; DWORD GatewayListContext; " & _
		"ptr DhcpServerNext; char DhcpServerADDRESS[16]; char DhcpServerMASK[16]; DWORD DhcpServerContext; " & _
		"int HaveWins; " & _
		"ptr PrimaryWinsServerNext; char PrimaryWinsServerADDRESS[16]; char PrimaryWinsServerMASK[16]; DWORD PrimaryWinsServerContext; " & _
		"ptr SecondaryWinsServerNext; char SecondaryWinsServerADDRESS[16]; char SecondaryWinsServerMASK[16]; DWORD SecondaryWinsServerContext; " & _
		"DWORD LeaseObtained; DWORD LeaseExpires;"

Func _GetMac(ByRef $tInfo)
	Local $BinaryMAC = BinaryMid(DllStructGetData($tInfo,"Address"),1,DllStructGetData($tInfo,"AddressLength"))
	Return StringTrimRight(StringRegExpReplace(StringTrimLeft($BinaryMAC,2),"([[:xdigit:]]{2})","$1:"),1)
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

Global Const $NETWORK_REG_KEY = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\"

Local $dll = DllOpen("Iphlpapi.dll")
Local $ret = DllCall($dll, "dword", "GetAdaptersInfo", "ptr", 0, "dword*", 0)

Local $adapterBuffer = DllStructCreate("byte[" & $ret[2] & "]")
Local $adapterBuffer_pointer = DllStructGetPtr($adapterBuffer)
Local $return = DllCall($dll, "dword", "GetAdaptersInfo", "ptr", $adapterBuffer_pointer, "dword*", $ret[2])
Local $adapter = DllStructCreate($tagIP_ADAPTER_INFO, $adapterBuffer_pointer)
If Not @error Then
	Local $DisplayName,$ptr,$adapter,$adapterName,$MediaSubType,$PnpInstanceID
	Local $XML='<?xml version="1.0" encoding="UTF-8"?>'&@CRLF&"<ADAPTERS>"&@CRLF&@CRLF
	Do
		$XML &= "	<ADAPTER>" & @CRLF
		$XML &= @TAB & @TAB & _GetXML($adapter, "ComboIndex")
		$XML &= @TAB & @TAB & _GetXML($adapter, "Description")
		$XML &= @TAB & @TAB & _GetXML($adapter, "AdapterName")
		$XML &= @TAB & @TAB & xml_makeNode("Address", _GetMac($adapter) )
		$XML &= @TAB & @TAB & _GetXML($adapter, "Index")
		$XML &= @TAB & @TAB & _GetXML($adapter, "Type")
		$XML &= @TAB & @TAB & _GetXML($adapter, "DhcpEnabled")
		$XML &= _GetAllIPsXML(DllStructGetPtr($adapter, "IpAddressListNext"), "IP", False)
		$XML &= _GetAllIPsXML(DllStructGetPtr($adapter, "GatewayListNext"), "Gateway")
		$XML &= _GetFirstIPXML(DllStructGetPtr($adapter, "DhcpServerNext"), "DhcpServer")
		$XML &= @TAB & @TAB & _GetXML($adapter, "HaveWins")
		$XML &= _GetFirstIPXML(DllStructGetPtr($adapter, "PrimaryWinsServerNext"), "PrimaryWinsServer")
		$XML &= _GetFirstIPXML(DllStructGetPtr($adapter, "SecondaryWinsServerNext"), "SecondaryWinsServer")
		$XML &= @TAB & @TAB & _GetXML($adapter, "LeaseObtained")
		$XML &= @TAB & @TAB & _GetXML($adapter, "LeaseExpires")

		$adapterName = DllStructGetData($adapter, "AdapterName")
		$DisplayName = RegRead($NETWORK_REG_KEY & $adapterName & "\Connection", "Name")
		$XML &= @TAB & @TAB & xml_makeNode("DisplayName", $DisplayName)
		$MediaSubType = RegRead($NETWORK_REG_KEY & $adapterName & "\Connection", "MediaSubType")
		$XML &= @TAB & @TAB & xml_makeNode("MediaSubType", $MediaSubType)
		ConsoleWrite("+-> Mediasubtype: ( LAN = 1 oder 10 ?why? ; Network-Bridge = 1(aber auch LAN?why) ; WLAN = 2 ; IEEE1394 = 5 ; Bluetooth = 9 ; )"&@CRLF)
		$PnpInstanceID = RegRead($NETWORK_REG_KEY & $adapterName & "\Connection", "PnpInstanceID")
		$XML &= @TAB & @TAB & xml_makeNode("PnpInstanceID", $PnpInstanceID)


		$XML &= "	</ADAPTER>" & @CRLF & @CRLF
		$ptr = DllStructGetData($adapter, "Next")
		$adapter = DllStructCreate($tagIP_ADAPTER_INFO, $ptr)
	Until @error
	$XML &= "<ADAPTER>"&@CRLF
EndIf
ConsoleWrite($XML & @CRLF)
Func _GetAllIPsXML($Ptr, $Type, $MAC=True, $Indent=2)
	Local $Tab=""
	For $i = 1 To $Indent
		$Tab &= @TAB
	Next
	Local $return = $Tab & "<"&StringUpper($Type) & "LIST>"&@CRLF
	Local $IPArray = _GetAllIps($Ptr)
	For $i = 0 To UBound($IPArray)-1
		$return &= $Tab & "	<" & StringUpper($Type)&">" & @CRLF
		$return &= $Tab & "		" & xml_makeNode($Type&"_IP", $IPArray[$i][0])
		$return &= $Tab & "		" & xml_makeNode($Type&"_MASK", $IPArray[$i][1])
		$return &= $Tab & "		" & xml_makeNode($Type&"_CONTEXT", $IPArray[$i][2])
		If $MAC Then $return &= $Tab & "		" & xml_makeNode($Type&"_MAC", net_getMACIDFromIP($IPArray[$i][0]))
		$return &= $Tab & "	</" & StringUpper($Type)&">" & @CRLF
	Next
	$return &= $Tab & "</"&StringUpper($Type) & "LIST>"&@CRLF
	Return $return
EndFunc
Func _GetFirstIPXML($Ptr, $Type, $MAC=True, $Indent=2)
	Local $Tab=""
	For $i = 1 To $Indent
		$Tab &= @TAB
	Next
	Local $IPStruct = DllStructCreate($tagIP_ADDR_STRING,$ptr)
	Local $return = $Tab & "<" & StringUpper($Type)&">" & @CRLF
		$return &= $Tab & @TAB & xml_makeNode($Type&"_IP", DllStructGetData($IPStruct,"IPAddress"))
		$return &= $Tab & @TAB & xml_makeNode($Type&"_MASK", DllStructGetData($IPStruct,"IPMask"))
		$return &= $Tab & @TAB & xml_makeNode($Type&"_CONTEXT", DllStructGetData($IPStruct,"Context"))
		If $MAC Then $return &= $Tab & @TAB & xml_makeNode($Type&"_MAC", DllStructGetData($IPStruct,"IPAddress"))
		$return &= $Tab & "</" & StringUpper($Type)&">" & @CRLF
	Return $return
EndFunc
Func _GetAllIps($Ptr)
	Local $IPStruct, $Index = 0
	Local $IPArray[1][3]
	Do
		ReDim $IPArray[$Index+1][3]
		$IPStruct = DllStructCreate($tagIP_ADDR_STRING,$ptr)
		$IPArray[$Index][0] = DllStructGetData($IPStruct,"IPAddress")
		$IPArray[$Index][1] = DllStructGetData($IPStruct,"IPMask")
		$IPArray[$Index][2] = DllStructGetData($IPStruct,"Context")
		$Ptr = DllStructGetData($IPStruct,"Next")
		$Index += 1
	Until $Ptr = 0
	Return $IPArray
EndFunc

$adapterBuffer = ""
$adapterBuffer_pointer = ""
DllClose($dll)
