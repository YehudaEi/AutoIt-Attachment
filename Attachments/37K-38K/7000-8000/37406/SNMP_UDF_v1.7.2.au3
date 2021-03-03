#include-once
#Include <String.au3>
#Include <Array.au3>
;-----------------------------------------------------
;Credit for idea of this UDF and alot of work on it:    ptrex
;						Thank you ptrex
;version 1.7.2 - (16.01.2012)
;OID Arrays are no longer supported: they didn't add anything to UDF's value and were only complicating the scripts
;-----------------------------------------------------
Const $SNMP_data_INT  		= "02"
Const $SNMP_data_STR  		= "04"
Const $SNMP_data_NULL 		= "05"
Const $SNMP_data_OID  		= "06"
Const $SNMP_data_SEQ  		= "30"
Const $SNMP_data_IP	 		= "40"
Const $SNMP_data_COUNTER	= "41"
Const $SNMP_data_GAUGE	 	= "42"
Const $SNMP_data_TIME	 	= "43"
Const $SNMP_data_COUNTER64	= "46"

Global $SNMP_Received[1500][3]
Global $Varbind_content[1000]
Global $SNMP_Util[1000][3]

#region ~~~~~~~~~~~~~~~~~~~~ BUILD SNMP Packet ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;===============================================================================
; Description:      Build SNMP Message
; Syntax:          _SNMPBuildPacket($snmpOID, $snmpCOMM, $snmpVER, $snmpReqID, $PDUType = "A1")
; Parameter(s):     $snmpOID - Object ID (OID) ex: "1.3.6.1.2.1.1.1"
;					$snmpCOMM - Community String -> the default values are "public" for read-only and "private" for read-write
;					$snmpVER - SNMP Version (3 versions available, 1, 2 and 3 - this UDF handles only SNMP v1 and v2c)
;						1 = SNMP v1
;						2 = SNMP v2c
;						3 = SNMP v3 -> NOT WORKING
;					$snmpReqID - Request ID - an Integer that identifies a particular SNMP request.
;					$PDUType - PDU type ("A0"= GetRequest, "A1"= GetNext, "A2"= GetResponse, "A3"= SetRequest, "A5"= Get Bulk))
;					$GetBulk - (hex) how many OIDs to return (50 MAXIMUM recommended) - if you request too many OIDs you will get an error.
;					$dataTYPE - data TYPE to be written 	(for SetRequest) - refer to "const" values at the top
;					$dataVALUE - data VALUE to be written  	(for SetRequest)
; Requirement(s):   Must be used from withing this UDF (calls other functions)
; Return Value(s):  On Success - Returns a hex string which is to be send
; Error Code:		1 = SNMP version error (GetBulk request used with SNMP v1)
;					2 = wrong data type for SetRequest
;					3 = $snmpOID is an array (arrays are no longer supported)
; Author(s):        enaiman <naimane at yahoo dot com>
; Note(s):          None
;===============================================================================
Func _SNMPBuildPacket($snmpOID, $snmpCOMM = "public", $snmpVER = 1, $snmpReqID = 1, $PDUType = "A1", $GetBulk = "32", $dataTYPE = "05", $dataVALUE = "00")
;~~~~~~~~~~~~~~~~~~~~~~~~~~~ building the packet backwards ... ~~~~~~~~~~~~~~~~~~~~~~~~~~~
	_Init()																		;resets global variables
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If IsArray($snmpOID) Then
		MsgBox(16, "OID Array", "OID Arrays are no longer supported.")
		Return SetError(3)
	EndIf
	Switch $snmpVER
		Case 1,2
			$_SNMP_Req_Varbind 	= _Build_Varbind	($snmpOID, $dataTYPE, $dataVALUE)
			If @error Then
				MsgBox(16, "Unknown Data Type", "Unknown Data Type: "&$dataTYPE)
				Return SetError(2)
			EndIf
			If $PDUType = "A5" And $snmpVER = 1 Then
				MsgBox(16, "Wrong SNMP Version", "GetBulk request cannot be used with SNMP v1.")
				Return SetError(1)
			EndIf
			$_SNMP_Req_PDU 		= _Build_PDU		($snmpReqID, $PDUType, $GetBulk, $_SNMP_Req_Varbind)
			$_SNMP_Req_Message	= _Build_Message	($snmpVER, $snmpCOMM, $_SNMP_Req_PDU)
			_WriteArrayValues($SNMP_Received, 1, "SNMP Command", $_SNMP_Req_Message)
			ConsoleWrite($_SNMP_Req_Message&@CRLF)
			Return $_SNMP_Req_Message
		Case 3
			MsgBox(16, "SNMP v3 Not Supported", "SNMP v3 is not supported yet.")
			Return SetError(1)
		Case Else
			MsgBox(16, "Wrong SNMP Version", "Unknown SNMP Version: "&$snmpVER)
			Return SetError(1)
	EndSwitch
EndFunc
#endregion
#region ~~~~~~~~~~~~~~~~~~~~ EXTRACT SNMP Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;Returned Data in is 2 Arrays
;$SNMP_Received = Contains a more detailed range of data (educational purpose)
;	<< NEW >> - now $SNMP_Received has an extra row, showing raw data for each PDU (delimited string)
;$SNMP_Util		= Util information received:
;		$SNMP_Util[0][0] = "Error Code"
;		$SNMP_Util[0][1] = error value
;		$SNMP_Util[1][0] = OID
;		$SNMP_Util[1][1] = Value read from OID
;	If more that 1x OID were requested then the next results will be added
;		$SNMP_Util[2][0] = OID
;		$SNMP_Util[2][1] = Value read from OID
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _ShowSNMPReceived($rcvDATA)
	Global $SNMP_Util[1000][3]
	Local $_sPacketRecv_ = $rcvDATA
	Local $_PDUcontent 		= ""
	Local $_ExtractedDATA
	Local $_IsError = 0
	Local $_PDU_content = ""
	Local $_delimSTR_ = ""
	_WriteArrayValues($SNMP_Received, 1, "SNMP Answer", $rcvDATA)
	$rcvDATA = StringTrimLeft($rcvDATA, 4)			;strip 0x30
	Local $_l_pl = _GetPacLen_(StringLeft($rcvDATA, 6))
	Local $_pacLen_ = StringLeft($rcvDATA, $_l_pl)
	$rcvDATA = StringTrimLeft($rcvDATA, $_l_pl)	;strip packet length
	_WriteArrayValues($SNMP_Received, 2, "(Total) PDU Length", $_pacLen_)
;------------- SNMP Version Block -------------------------------------------------
	_WriteArrayValues($SNMP_Received, 3, "SNMP Version Block", StringLeft($rcvDATA, 6))
	$rcvDATA = StringTrimLeft($rcvDATA, 4)			;strip 0201 from SNMP ver block
	Local $_snmpV_ = StringLeft($rcvDATA, 2)+1				;SNMP Version
	$rcvDATA = StringTrimLeft($rcvDATA, 2)			;strip SNMP Version
;------------- Community String ---------------------------------------------------
	$rcvDATA = StringTrimLeft($rcvDATA, 2)			;strip 04 from community block
	Local $_commLen_ = Dec(StringLeft($rcvDATA, 2))*2		;Length of community string
	$rcvDATA = StringTrimLeft($rcvDATA, 2)			;strip community length
	Local $_commHex_ = StringLeft($rcvDATA, $_commLen_)	;community string (hex)
	Local $_commTex_ = _HexToString($_commHex_)
	$rcvDATA = StringTrimLeft($rcvDATA, $_commLen_)
	_WriteArrayValues($SNMP_Received, 4, "Community String", $_commTex_)
;------------- PDU Type -----------------------------------------------------------
	Local $_pduT_ = StringLeft($rcvDATA, 2)
	_WriteArrayValues($SNMP_Received, 5, "PDU Type", $_pduT_)
	$rcvDATA = StringTrimLeft($rcvDATA, 2)
	$rcvDATA = _StripPacket($rcvDATA)
;------------- Request ID ---------------------------------------------------------
	$rcvDATA = _StripBlocks($rcvDATA, 6, "Request ID Block")
;------------- Error Block --------------------------------------------------------
	Local $_sErr_ = StringMid($rcvDATA, 5, 2)
	If $_sErr_ <> "00" Then
		_ThrowError($_sErr_, $_sPacketRecv_)
		Return SetError(1)
	EndIf
	_WriteArrayValues($SNMP_Util, 0, "SNMP Error Value:", $_sErr_)
	$rcvDATA = _StripBlocks($rcvDATA, 7, "Error Block")
;------------- Error Index --------------------------------------------------------
	$rcvDATA = _StripBlocks($rcvDATA, 8, "Error Index Block")
;------------- PDU Total Len ------------------------------------------------------
	$rcvDATA = StringTrimLeft($rcvDATA, 2)
	$_l_pl = _GetPacLen_(StringLeft($rcvDATA, 6))
	Local $_pacTotLen_ = StringLeft($rcvDATA, $_l_pl)
	$rcvDATA = StringTrimLeft($rcvDATA, $_l_pl)					;strip packet length
;------------- PDU Data -----------------------------------------------------------
	Local $_snmpR_idx = 9, $_snmpA_idx = 1
	Do
		$rcvDATA = StringTrimLeft($rcvDATA, 2)								;cut "30" (data type: SEQ)
		$_l_pl = _GetPacLen_(StringLeft($rcvDATA, 6))						;length of Data PDU
		$_pacLen_ = StringLeft($rcvDATA, $_l_pl)
		$rcvDATA = StringTrimLeft($rcvDATA, $_l_pl)							;cut length
		$_PDU_content = StringLeft($rcvDATA, Dec($_pacLen_)*2)				;get what is left from PDU
		$rcvDATA = StringTrimLeft($rcvDATA, Dec($_pacLen_)*2)				;remove that from message
		$_delimSTR_ = "30|"&$_pacLen_&"|"									;build delimited string
		If StringLeft($_PDU_content, 2) = "06" Then
			$_delimSTR_ &= "06|"
			$_PDU_content = StringTrimLeft($_PDU_content, 2)				;cut "06" (data type: OID)
			$_l_pl = _GetPacLen_(StringLeft($_PDU_content, 6))				;Length of OID sequence
			$_pacLen_ = StringLeft($_PDU_content, $_l_pl)
			$_PDU_content = StringTrimLeft($_PDU_content, $_l_pl)			;cut length
			Local $_OID_val = StringLeft($_PDU_content, Dec($_pacLen_)*2)	;OID (hex)
			$_delimSTR_ &= $_pacLen_&"|"&$_OID_val&"|"
			Local $_Decoded_OID = _TranslateOID($_OID_val, "2d")			;OID (dec)
			$_PDU_content = StringTrimLeft($_PDU_content, Dec($_pacLen_)*2)
			Local $_data_type = StringLeft($_PDU_content, 2)				;returned data type
			$_PDU_content = StringTrimLeft($_PDU_content, 2)
			If StringLen($_PDU_content) >= 6 Then
				$_l_pl = _GetPacLen_(StringLeft($_PDU_content, 6))				;Length of data sequence
			Else
				$_l_pl = _GetPacLen_(StringLeft($_PDU_content, 4))				;Length of data sequence
			EndIf
			Local $_raw_data = StringTrimLeft($_PDU_content, $_l_pl)
			Local $_RealData = _ExtractData($_data_type, $_raw_data)
			_WriteArrayValues($SNMP_Received, $_snmpR_idx, $_Decoded_OID, $_RealData)
			$_snmpR_idx += 1
			$_delimSTR_ &= $_data_type&"|"&StringLeft($_PDU_content, $_l_pl)&"|"&$_raw_data
			_WriteArrayValues($SNMP_Received, $_snmpR_idx, "Raw PDU (delimited string)", $_delimSTR_)
			$_snmpR_idx += 1
			_WriteArrayValues($SNMP_Util, $_snmpA_idx, $_Decoded_OID, $_RealData)
			$_snmpA_idx += 1
			$_delimSTR_ = ""
		Else
			Return SetError(2)		;bad SNMP Packet
		EndIf
	Until Int(StringLen($rcvDATA)) = 0
	ReDim $SNMP_Received[$_snmpR_idx][3]
	ReDim $SNMP_Util[$_snmpA_idx][3]
	Return $SNMP_Util
EndFunc		;==>_ShowSNMPReceived
#endregion
#region ~~~~~~~~~~~~~~~~~~~~ Add Packet Layers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _Build_Varbind($p_OID, $p_dTYPE, $p_dVALUE)
	Local $_result_
	Local $oidarr
	Switch $p_dTYPE
		Case $SNMP_data_INT, $SNMP_data_COUNTER, $SNMP_data_GAUGE, $SNMP_data_TIME
			$p_dVALUE = Hex($p_dVALUE, 8)
			For $_j = 1 To 3
				If StringLeft($p_dVALUE, 2) = "00" Then
					$p_dVALUE = StringTrimLeft($p_dVALUE, 2)
				EndIf
			Next
		Case $SNMP_data_STR																;STR
			$p_dVALUE = _StringToHex($p_dVALUE)
		Case $SNMP_data_NULL															;NULL
			$p_dVALUE = "00"
		Case $SNMP_data_OID																;OID
			$p_dVALUE = _TranslateOID($p_dVALUE, "2h")
		Case $SNMP_data_IP																;IP
			$p_dVALUE = _SNMPEncodeIP($p_dVALUE)
		Case Else
			Return SetError(1)
	EndSwitch
	Local $_sl_ = Int(StringLen($p_dVALUE)/2)
	Local $_p_dLen = Hex($_sl_,2)
	$_result_ = $p_dTYPE & $_p_dLen & $p_dVALUE						;data type and data value
	$oidarr = _TranslateOID($p_OID, "2h")
	$_result_ = $oidarr & $_result_
	$_result_ = Hex(Int(StringLen($_result_)/2),2) & $_result_
	$_result_ = $SNMP_data_SEQ & $_result_
	$_result_ = Hex(Int(StringLen($_result_)/2),2) & $_result_
	$_result_ = $SNMP_data_SEQ & $_result_
	Return $_result_
EndFunc
Func _Build_PDU($p_ReqID, $p_PDUType, $p_bulk, $p_varbind)
	Local $_result_
	$_result_ = $p_varbind
	If $p_PDUType = "A5" Then								;error Index
		$_result_ = "0201" & $p_bulk & $_result_
	Else
		$_result_ = "020100" & $_result_
	EndIf
	$_result_ = "020100" & $_result_						;error
	$_result_ = "020200" & Hex($p_ReqID, 2) & $_result_		;request ID
	$_result_ = Hex(Int(StringLen($_result_)/2),2) & $_result_
	$_result_ = $p_PDUType & $_result_
	Return $_result_
EndFunc
Func _Build_Message($p_VER, $p_COMM, $p_PDU)
	Local $_result_
	$_result_ = $p_PDU
	$_result_ = _BuildCOM_($p_COMM) & $_result_
	$_result_ = "0201" & Hex($p_VER-1, 2) & $_result_
	$_result_ = Hex(Int(StringLen($_result_)/2),2) & $_result_
	$_result_ = "0x" & $SNMP_data_SEQ & $_result_
	Return $_result_
EndFunc
Func _TranslateOID($input, $dir)
	Local $l_OID = ""
	Switch $dir
		Case "2d"
			Local $_dex_OID = _SNMPExtractOID($input)
			Return $_dex_OID
		Case "2h"
			Local $hex_OID = _SysObjIDToHexString($input)			;transform the OID in a hex value
			$hex_OID = "2B" & $hex_OID								;add "2B" in front of the string
			Local $len_OID = Hex(Int(StringLen($hex_OID)/2), 2)			;calculate the length
			$l_OID = $SNMP_data_OID									;1st element Object ID = ASN.1 type "06"
			$l_OID &= $len_OID										;2nd element = length
			$l_OID &= $hex_OID
			Return $l_OID
	EndSwitch
EndFunc
Func _BuildCOM_($comm)
	Local $hex_COMM = _StringToHex($comm)					;transform the community string in a hex value
	Local $len_COMM = Hex(Int(StringLen($hex_COMM)/2), 2)		;calculate the length
	Local $_comm_ = "04"& $len_COMM & $hex_COMM
	Return $_comm_
EndFunc		;==>_BuildCOM_
Func _GetPacLen_($sPkt)
	Local $pacl = 0
	Switch StringLeft($sPkt, 2)
		Case "81"
			$pacl = 4
		Case "82"
			$pacl = 6
		Case Else
			$pacl = 2
	EndSwitch
	Return $pacl
EndFunc
Func _StripPacket($spkt)
	Local $_l_pl = _GetPacLen_(StringLeft($spkt, 6))
	Local $_pacLen_ = StringLeft($spkt, $_l_pl)
	$spkt = StringTrimLeft($spkt, $_l_pl)	;strip packet length
	Return $spkt
EndFunc
Func _StripBlocks($spkt, $_el, $_eltxt)
	Select
		Case StringLeft($spkt, 4) = "0202"
			_WriteArrayValues($SNMP_Received, $_el, $_eltxt, StringLeft($spkt, 8))
			$spkt = StringTrimLeft($spkt, 8)
		Case StringLeft($spkt, 4) = "0201"
			_WriteArrayValues($SNMP_Received, $_el, $_eltxt, StringLeft($spkt, 6))
			$spkt = StringTrimLeft($spkt, 6)
	EndSelect
	Return $spkt
EndFunc
#endregion
#region ~~~~~~~~~~~~~~~~~~~~ Encode IP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _SNMPEncodeIP($strIP)
	Local $encoded_IP = ""
	Local $encoded_IParr
	$encoded_IParr = StringSplit($strIP, ".")
	If $encoded_IParr[0] <> 4 Then
		ConsoleWrite("ERROR: Wrong IP Format "&$strIP&@CRLF)
		Return SetError(1)
	EndIf
	$encoded_IP = Hex($encoded_IParr[1], 2)&Hex($encoded_IParr[2], 2)&Hex($encoded_IParr[3], 2)&Hex($encoded_IParr[4], 2)
	Return $encoded_IP
EndFunc		;==>_SNMPEncodeIP
#endregion ~~~~~~~~~~~~~~~~~ END Encode IP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#region ~~~~~~~~~~~~~~~~~~~~ Encode OID ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _BuildOID($oid)
	Local $hex_OID = _SysObjIDToHexString($oid)				;transform the OID in a hex value
	$SNMP_hexOID = $hex_OID
	$hex_OID = "2B" & $hex_OID								;add "2B" in front of the string
	Local $len_OID = Hex(Int(StringLen($hex_OID)/2), 2)			;calculate the length
	Local $OID_Arr[Dec($len_OID) + 2]						;build array to store values
	$OID_Arr[0] = $SNMP_data_OID							;1st element Object ID = ASN.1 type "06"
	$OID_Arr[1] = $len_OID									;2nd element = length
	For $i = 2 To Dec($len_OID)+1							;2digit OID parts
		$OID_Arr[$i] = StringMid($hex_OID, 2*$i - 3, 2)
	Next
	Return $OID_Arr
EndFunc		;==>_BuildOID
Func _SysObjIDToHexString($Input)							;convert OID to hex form
	Local $Output
	If StringLeft($Input,4) = "1.3." Then $Input = StringTrimLeft($Input,4)
	$aInput = StringSplit($Input,".")
	For $x = 1 To $aInput[0]
		If Number($aInput[$x]) > 127 Then
			$Output &= _encode($aInput[$x])
		Else
			$Output &= hex(Number($aInput[$x]),2)
		EndIf
	Next
	Return $Output
EndFunc		;==>_SysObjIDToHexString
Func _encode($d, $r = 0)
    $Op_Result = ""
    $t1 = Int($d / 128)
    $t2 = $d - $t1 * 128
    If $t1 Then $Op_Result &= _encode($t1, 1)
    If $r Then $t2 += 128
    $Op_Result &= Hex($t2, 2)
    Return $Op_Result
EndFunc   ;==>_encode
#endregion ~~~~~~~~~~~~~ END Encode OID ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#region ~~~~~~~~~~~~~~~~~~~~ Initialize Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _Init()
	Dim $SNMP_Received[1500][3]
	Dim $Varbind_content[1000]
	Dim $SNMP_Util[1000][3]
EndFunc
#endregion ~~~~~~~~~~~~~~~~ END Initialize Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#region ~~~~~~~~~~~~~~~~~~~~ MISC Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;memo: improve _DeleteIndexes - it takes too long to delete/redim the array everytime !!!
Func _ExtractData($dtype, $tmpOUT)										;Extract clear data
	Switch $dtype
		Case "04"			;string
			Return BinaryToString("0x"&$tmpOUT)
		Case "02" 			;number
			Return _SNMPHexToDec ($tmpOUT)
		Case "06" 			;OID
			Return _SNMPExtractOID($tmpOUT)
		Case "40"			;IP Address
			Return _SNMPExtractIP ($tmpOUT)
		Case "41"			;Counter
			Return _SNMPHexToDec ($tmpOUT)
		Case "42"			;Gauge
			Return _SNMPHexToDec ($tmpOUT)
		Case "43"
			Return _SNMPHexToDec($tmpOUT)/100 &" sec."
		Case "46"			;Counter64
			Return _SNMPHexToDec ($tmpOUT)
	EndSwitch
EndFunc		;==>_ExtractData
Func _SNMPExtractIP($strIP)
	Local $extractedIParray [5]
	Local $extractedIP = ""
	For $i = 1 To 4
		$extractedIParray[$i] = Dec(StringMid($strIP, 2*$i - 1, 2))
		If $i = 4 Then
			$extractedIP &= $extractedIParray[$i]
		Else
			$extractedIP &= $extractedIParray[$i] & "."
		EndIf
	Next
	Return $extractedIP
EndFunc		;==>_SNMPExtractIP
Func _SNMPExtractOID($strOID)
	Local $extractedOIDarray [StringLen($strOID)/2 + 1]
	Local $extractedOID = "1.3."
	For $i = 2 To StringLen($strOID)/2
		$extractedOIDarray[$i] = StringMid($strOID, 2*$i - 1, 2)
		If Dec($extractedOIDarray[$i]) > 128 Then
			If Dec(StringMid($strOID, 2*($i + 1) - 1, 2)) > 128 Then
				$extractedOID &= _decode($extractedOIDarray[$i]&" + "&StringMid($strOID, 2*$i + 1, 2)&" + "&StringMid($strOID, 2*($i + 2) - 1, 2))& "."
				$i += 2
			Else
				$extractedOID &= _decode($extractedOIDarray[$i]&" + "&StringMid($strOID, 2*$i + 1, 2))& "."
				$i += 1
			EndIf
		ElseIf $i = StringLen($strOID)/2 Then
			$extractedOID &= Dec($extractedOIDarray[$i])
		Else
			$extractedOID &= Dec($extractedOIDarray[$i]) & "."
		EndIf
	Next
	Return $extractedOID
EndFunc		;==>_SNMPExtractOID
Func _SNMPHexToDec ($nbr)
	Local $extractedHEXarray [StringLen($nbr) + 1]
	Local $extractedNBR = 0
	For $i = 1 To StringLen($nbr)
		$extractedHEXarray[$i] = StringMid($nbr, $i, 1)
		$extractedNBR += 16^(StringLen($nbr)- $i)*Dec($extractedHEXarray[$i])
	Next
	Return $extractedNBR
EndFunc		;==>_SNMPHexToDec
Func _decode($s, $d = 0)
    $a = StringSplit($s, " + ", 1)
    For $j = 1 To $a[0]
        $d1 = Dec($a[$j])
        If $d1 > 127 Then $d1 = $d1 - 128
        $d = ($d * 128) + $d1
    Next
    Return $d
EndFunc   ;==>_decode
Func _WriteArrayValues(ByRef $ArrRet, $idx, $val0, $val1, $val2 = "")				;write entries in returned arrays
	;_ArrayDisplay($ArrRet)
	$ArrRet[$idx][0] = $val0
	$ArrRet[$idx][1] = $val1
	If $val2 <> "" Then $ArrRet[$idx][2] = $val2
EndFunc		;==>_WriteArrayValues
Func _ThrowError($sErr, $spkt)
	Switch $sErr
		Case "00"
			Return
		Case "01"
			ClipPut($spkt)
			MsgBox(16, "SNMP Error Code: 1", "Error Message:  Response message too large to transport."&@CRLF&@CRLF&"                (packet received placed in clipboard)")
		Case "02"
			ClipPut($spkt)
			MsgBox(16, "SNMP Error Code: 2", "Error Message:   The name of the requested object was not found."&@CRLF&@CRLF&"                (packet received placed in clipboard)")
		Case "03"
			ClipPut($spkt)
			MsgBox(16, "SNMP Error Code: 3", "Error Message:   A data type in the request did not match the data type in the SNMP agent."&@CRLF&@CRLF&"                (packet received placed in clipboard)")
		Case "04"
			ClipPut($spkt)
			MsgBox(16, "SNMP Error Code: 4", "Error Message:    The SNMP manager attempted to set a read-only parameter."&@CRLF&@CRLF&"                (packet received placed in clipboard)")
		Case "05"
			ClipPut($spkt)
			MsgBox(16, "SNMP Error Code: 5", "Error Message:   General Error (some error other than the ones listed above)."&@CRLF&@CRLF&"                (packet received placed in clipboard)")
		Case Else
			ClipPut($spkt)
			MsgBox(16, "SNMP Error Code: "&$spkt, "Error Message:   No Error message for this one."&@CRLF&@CRLF&"                (packet received placed in clipboard)")
	EndSwitch
	Exit
EndFunc
#cs
0
 noError
 No error occurred. This code is also used in all request PDUs, since they have no error status to report.

1
 tooBig
 The size of the Response-PDU would be too large to transport.

2
 noSuchName
 The name of a requested object was not found.

3
 badValue
 A value in the request didn't match the structure that the recipient of the request had for the object. For example, an object in the request was specified with an incorrect length or type.

4
 readOnly
 An attempt was made to set a variable that has an Access value indicating that it is read-only.

5
 genErr
 An error occurred other than one indicated by a more specific error code in this table.

6
 noAccess
 Access was denied to the object for security reasons.

7
 wrongType
 The object type in a variable binding is incorrect for the object.

8
 wrongLength
 A variable binding specifies a length incorrect for the object.

9
 wrongEncoding
 A variable binding specifies an encoding incorrect for the object.

10
 wrongValue
 The value given in a variable binding is not possible for the object.

11
 noCreation
 A specified variable does not exist and cannot be created.

12
 inconsistentValue
 A variable binding specifies a value that could be held by the variable but cannot be assigned to it at this time.

13
 resourceUnavailable
 An attempt to set a variable required a resource that is not available.

14
 commitFailed
 An attempt to set a particular variable failed.

15
 undoFailed
 An attempt to set a particular variable as part of a group of variables failed, and the attempt to then undo the setting of other variables was not successful.

16
 authorizationError
 A problem occurred in authorization.

17
 notWritable
 The variable cannot be written or created.

18
 inconsistentName
 The name in a variable binding specifies a variable that does not exist

#ce