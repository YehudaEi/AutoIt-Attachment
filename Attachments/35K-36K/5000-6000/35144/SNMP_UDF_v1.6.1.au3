#include-once
#Include <String.au3>
#Include <Array.au3>
;-----------------------------------------------------
;Credit for idea of this UDF and alot of work on it:    ptrex
;						Thank you ptrex
;version 1.6.1 - (30.08.2011)
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

Global $SNMP_CmdArray				= ""
Global $SNMP_ErBlk					= 0
Global $SNMP_ErrorID 				= 0
Global $SNMP_ErrorIDX 				= 0
Global $SNMP_OID_Length 			= 0
Global $SNMP_Community_Length 		= 0
Global $SNMP_Answ_Packet_Len 		= 0
Global $SNMP_Answ_Version 			= 0
Global $SNMP_Answ_Comm_String 		= ""
Global $SNMP_Answ_PDU_Type 			= 0
Global $SNMP_Answ_PDU_Len 			= 0
Global $SNMP_Answ_RqID_Val 			= ""
Global $SNMP_Answ_Err_Val 			= 0
Global $SNMP_Answ_Err_Idx 			= 0
Global $SNMP_Answ_Varbind_List_Type = 0
Global $SNMP_Answ_Varbind_List_Len 	= 0
Global $SNMP_Answ_Varbind_Type 		= 0
Global $SNMP_Answ_Varbind_Len 		= 0
Global $SNMP_Answ_OID_Type 			= 0
Global $SNMP_Answ_OID_Len 			= 0
Global $SNMP_Answ_OID_Len 			= 0
Global $SNMP_Answ_DataType 			= 0
Global $SNMP_Answer[10000]
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
;					$GetBulk - (hex) how many OIDs to return (50 MAXIMUM recommended)
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
	Local $dataLEN  	= ""
	Local $2RwArray[1]
	Local $OID_wr_ARR 	= ""
;~~~~~~~~~~~~~~~~~~~~~~~~~~ Dealing with different PDU Types ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~ PDU Structure: "30"+"PDU_Len"+"OID"+"05"+"00" ~~~~~~~~~~~~~~~~
	If IsArray($snmpOID) Then
		MsgBox(16, "OID Array", "OID Arrays are no longer supported.")
		Return SetError(3)
	EndIf
	Switch $PDUType
		Case "A0", "A1", "A2"
			$dataTYPE 	= $SNMP_data_NULL
			$dataVALUE 	= "00"
			$SNMP_CmdArray = _BuildOID($snmpOID)								;get the hex value of OID
			_ArrayAdd($SNMP_CmdArray, $dataTYPE)								;put $dataTYPE  (05)
			_ArrayAdd($SNMP_CmdArray, $dataVALUE)								;put $dataVALUE (00)
			$dataLEN = Hex(UBound($SNMP_CmdArray), 2)							;calculate $dataLEN
			_ArrayInsert($SNMP_CmdArray, 0, $dataLEN)							;insert $dataLEN (PDU Length)
			_ArrayInsert($SNMP_CmdArray, 0, $SNMP_data_SEQ)						;insert PDU Type = Sequence "30"
			_AddVarbindList($SNMP_CmdArray)
			_BuildPDUType($SNMP_CmdArray, $PDUType, $snmpReqID)
		Case "A3"
			ReDim $2RwArray[1000]
			Switch $dataTYPE
				Case $SNMP_data_INT, $SNMP_data_COUNTER, $SNMP_data_GAUGE, $SNMP_data_TIME		;(INT, COUNTER, GAUGE, TIME)
					$dataVALUE = _StringToHex($dataVALUE)
					For $i = 2 To StringLen($dataVALUE)+1
						$2RwArray[$i-1] = StringMid($dataVALUE, 2*$i - 3, 2)
					Next
					ReDim $2RwArray[StringLen($dataVALUE)/2+1]
					$dataLEN = Hex(StringLen($dataVALUE)/2, 2)
				Case $SNMP_data_STR																;STRING
					$dataVALUE = _StringToHex($dataVALUE)
					For $i = 2 To StringLen($dataVALUE)+1
						$2RwArray[$i-1] = StringMid($dataVALUE, 2*$i - 3, 2)
					Next
					ReDim $2RwArray[StringLen($dataVALUE)/2+1]
					$dataLEN = Hex(StringLen($dataVALUE)/2, 2)
				Case $SNMP_data_NULL															;NULL
					$dataVALUE = ""
					$dataLEN = "00"
				Case $SNMP_data_OID																;OID
					$OID_wr_ARR = _BuildOID($dataVALUE)
					For $i = 2 To UBound($OID_wr_ARR)-1														;skip [0] and [1]
						$2RwArray[$i-1] = $OID_wr_ARR[$i]
					Next
					ReDim $2RwArray[UBound($OID_wr_ARR)-1]
					$dataLEN = $OID_wr_ARR[1]
				Case $SNMP_data_IP																;IP
					$dataVALUE = _SNMPEncodeIP($dataVALUE)
					For $i = 2 To StringLen($dataVALUE)+1
						$2RwArray[$i-1] = StringMid($dataVALUE, 2*$i - 3, 2)
					Next
					ReDim $2RwArray[StringLen($dataVALUE)/2+1]
					$dataLEN = "04"
				Case Else
					Return SetError(2)
			EndSwitch
			$SNMP_CmdArray = _BuildOID($snmpOID)								;get the hex value of OID
			_ArrayAdd($SNMP_CmdArray, $dataTYPE)								;put $dataTYPE  (05)
			_ArrayAdd($SNMP_CmdArray, $dataLEN)									;put length of data to be written
			For $i = 1 To UBound($2RwArray)-1
				_ArrayAdd($SNMP_CmdArray, $2RwArray[$i])						;put $dataVALUE (00)
			Next
			$dataLEN = Hex(UBound($SNMP_CmdArray), 2)							;calculate $dataLEN
			_ArrayInsert($SNMP_CmdArray, 0, $dataLEN)							;insert $dataLEN (PDU Length)
			_ArrayInsert($SNMP_CmdArray, 0, $SNMP_data_SEQ)						;insert PDU Type = Sequence "30"
			_AddVarbindList($SNMP_CmdArray)
			_BuildPDUType($SNMP_CmdArray, $PDUType, $snmpReqID)
		Case "A5"
			If $snmpVER = 1 Then Return SetError(1)								;only SNMP v2
			ReDim $SNMP_Util[UBound($SNMP_Util)-1 + Number("0x"&$GetBulk)][3]
			$SNMP_ErBlk = $GetBulk												;refer to diff in pkt struct (err block)
			$dataTYPE 	= $SNMP_data_NULL
			$dataVALUE 	= "00"
			$SNMP_CmdArray = _BuildOID($snmpOID)								;get the hex value of OID
			_ArrayAdd($SNMP_CmdArray, $dataTYPE)								;put $dataTYPE  (05)
			_ArrayAdd($SNMP_CmdArray, $dataVALUE)								;put $dataVALUE (00)
			$dataLEN = Hex(UBound($SNMP_CmdArray), 2)							;calculate $dataLEN
			_ArrayInsert($SNMP_CmdArray, 0, $dataLEN)							;insert $dataLEN (PDU Length)
			_ArrayInsert($SNMP_CmdArray, 0, $SNMP_data_SEQ)						;insert PDU Type = Sequence "30"
			_AddVarbindList($SNMP_CmdArray)
			_BuildPDUType($SNMP_CmdArray, $PDUType, $snmpReqID, $SNMP_ErBlk)
		Case Else

	EndSwitch
	_AddCommunity($SNMP_CmdArray, $snmpCOMM)
	_AddSNMPVersion($SNMP_CmdArray, $snmpVER)
	_ClosePacket($SNMP_CmdArray)
	;_ArrayDisplay($SNMP_CmdArray)
	Local $cmd_string = ""
	For $y = 0 To UBound($SNMP_CmdArray)-1
		$cmd_string &=$SNMP_CmdArray[$y]
	Next
	_WriteArrayValues($SNMP_Received, 1, "SNMP Command", $cmd_string)
	;ConsoleWrite($cmd_string&@CRLF)
	Return $cmd_string
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
	Local $_PDUcontent 		= ""
	Local $_ExtractedDATA
	_WriteRecv($rcvDATA)
	If $SNMP_Answer[0] = "0x" Then	_ArrayDelete($SNMP_Answer, 0)
	_WriteArrayValues($SNMP_Received, 1, "SNMP Answer", $rcvDATA)	;~~ $SNMP_Received[1] = whole packet
	If $SNMP_Answer[0] = $SNMP_data_SEQ Then
		_DeleteIndexes($SNMP_Answer, "0")
	Else 																					;bad response - not a proper SNMP one
		Return SetError (1)
	EndIf
;~~~~~~~~~~~~~ get packet length ~~~~~~~~~~ $SNMP_Received[2] = whole packet length
	Switch $SNMP_Answer[0]
		Case "81"
			_WriteArrayValues($SNMP_Received, 2, "(Total) PDU Length", $SNMP_Answer[1])
			_DeleteIndexes($SNMP_Answer, "0-1")
		Case "82"
			_WriteArrayValues($SNMP_Received, 2, "(Total) PDU Length", $SNMP_Answer[1]&$SNMP_Answer[2])
			_DeleteIndexes($SNMP_Answer, "0-2")
		Case Else
			_WriteArrayValues($SNMP_Received, 2, "(Total) PDU Length", $SNMP_Answer[0])
			_DeleteIndexes($SNMP_Answer, "0")
	EndSwitch
;~~~~~~~~~~~~~~ get SNMP Version Block ~~~~~~ $SNMP_Received[3] = SNMP Version(xx yy zz) xx=02(integer), yy=01(length), zz=00(v1) or 01(v2)
	Switch $SNMP_Answer[1]
		Case "01"
			_WriteArrayValues($SNMP_Received, 3, "SNMP Version Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2])
			_DeleteIndexes($SNMP_Answer, "0-2")
		Case "02"
			_WriteArrayValues($SNMP_Received, 3, "SNMP Version Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2]&$SNMP_Answer[3])
			_DeleteIndexes($SNMP_Answer, "0-3")
	EndSwitch
;~~~~~~~~~~~~~~ get Community String ~~~~~~~ $SNMP_Received[4] = community string
	If $SNMP_Answer[0] = $SNMP_data_STR Then
		$_PDUcontent = _GetPDUContent($SNMP_Answer)
		_WriteArrayValues($SNMP_Received, 4, "Community String", _HexToString($_PDUcontent))
	Else 																					;bad response - not a proper SNMP one
		Return SetError (2)
	EndIf
;~~~~~~~~~~~~~~ get PDU Type ~~~~~~~~~~~~~ $SNMP_Received[5] = community string
	_WriteArrayValues($SNMP_Received, 5, "PDU Type", $SNMP_Answer[0])
	_DeleteIndexes($SNMP_Answer, "0")
	Switch $SNMP_Answer[0]
		Case "81"
			_DeleteIndexes($SNMP_Answer, "0-1")
		Case "82"
			_DeleteIndexes($SNMP_Answer, "0-2")
		Case Else
			_DeleteIndexes($SNMP_Answer, "0")
	EndSwitch
;~~~~~~~~~~~~~~ get Request ID Block ~~~~~~ $SNMP_Received[6] = Request ID(xx yy zz) xx=02(integer), yy=01(length), zz=00(request number)
	Switch $SNMP_Answer[1]
		Case "01"
			_WriteArrayValues($SNMP_Received, 6, "Request ID Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2])
			_DeleteIndexes($SNMP_Answer, "0-2")
		Case "02"
			_WriteArrayValues($SNMP_Received, 6, "Request ID Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2]&$SNMP_Answer[3])
			_DeleteIndexes($SNMP_Answer, "0-3")
	EndSwitch
;~~~~~~~~~~~~~~ get Error Block ~~~~~~ $SNMP_Received[7] = ERROR (xx yy zz) xx=02(integer), yy=01(length), zz=00(error)
	Switch $SNMP_Answer[1]
		Case "01"
			_WriteArrayValues($SNMP_Received, 7, "Error Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2])
			_WriteArrayValues($SNMP_Util, 0, "Error Code", $SNMP_Answer[2])
			_DeleteIndexes($SNMP_Answer, "0-2")
		Case "02"
			_WriteArrayValues($SNMP_Received, 7, "Error Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2]&$SNMP_Answer[3])
			_WriteArrayValues($SNMP_Util, 0, "Error Code", $SNMP_Answer[3])
			_DeleteIndexes($SNMP_Answer, "0-3")
	EndSwitch
;~~~~~~~~~~~~~~ get Error Index Block ~~~~~~ $SNMP_Received[8] = ERROR (xx yy zz) xx=02(integer), yy=01(length), zz=00(error index)
	Switch $SNMP_Answer[1]
		Case "01"
			_WriteArrayValues($SNMP_Received, 8, "Error Index Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2])
			_DeleteIndexes($SNMP_Answer, "0-2")
		Case "02"
			_WriteArrayValues($SNMP_Received, 8, "Error Index Block", $SNMP_Answer[0]&$SNMP_Answer[1]&$SNMP_Answer[2]&$SNMP_Answer[3])
			_DeleteIndexes($SNMP_Answer, "0-3")
	EndSwitch
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	If $SNMP_Answer[0] = $SNMP_data_SEQ Then
		_DeleteIndexes($SNMP_Answer, "0")
	Else 																					;bad response - not a proper SNMP one
		Return SetError (3)
	EndIf
	Switch $SNMP_Answer[0]
		Case "81"
			_DeleteIndexes($SNMP_Answer, "0-1")
		Case "82"
			_DeleteIndexes($SNMP_Answer, "0-2")
		Case Else
			_DeleteIndexes($SNMP_Answer, "0")
	EndSwitch
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~ get Community String ~~~~~~~ $SNMP_Received[4] = community string
	Local $LpCounter = 9
	Local $UtCounter = 1
	;ConsoleWrite("Ubound SNMP Received: "&UBound($SNMP_Received)&@CRLF)
	;ConsoleWrite("Ubound SNMP Util: "&UBound($SNMP_Util)&@CRLF)
	Do
		If $SNMP_Answer[0] = $SNMP_data_SEQ Then
			$_PDUcontent = _GetPDUContent($SNMP_Answer)
			;ConsoleWrite($_PDUcontent&@CRLF)
			$_ExtractedDATA = _ExtractUtilData($_PDUcontent)
			_WriteArrayValues($SNMP_Received, $LpCounter, $_ExtractedDATA[0], $_ExtractedDATA[1])
			;ConsoleWrite("SNMP Received: "&$LpCounter&" "&$_ExtractedDATA[0]&" "&$_ExtractedDATA[1]&@CRLF)
			_WriteArrayValues($SNMP_Util, $UtCounter, $_ExtractedDATA[0], $_ExtractedDATA[1])
			;ConsoleWrite("SNMP Util: "&$UtCounter&" "&$_ExtractedDATA[0]&" "&$_ExtractedDATA[1]&@CRLF)
			$LpCounter += 1
			$UtCounter += 1
		Else 																					;bad response - not a proper SNMP one
			Return SetError (2)
		EndIf
		Local $PDU_raw_string
		$PDU_raw_string = _GetPDUrawString($_PDUcontent)
		_WriteArrayValues($SNMP_Received, $LpCounter, "Raw PDU (delimited string)", $PDU_raw_string)
		$LpCounter += 1
	Until UBound($SNMP_Answer) = 0

	ReDim $SNMP_Received[$LpCounter][3]
	ReDim $SNMP_Util[$UtCounter][3]
	Return $SNMP_Util
EndFunc		;==>_ShowSNMPReceived
#endregion
#region ~~~~~~~~~~~~~~~~~~~~ Add Packet Layers ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Func _AddVarbindList(ByRef $PackArr)						;add length and type (30) to the Varbind core
	Local $T_PacLen = _RetPackLen()
	For $z = UBound($T_PacLen)-1 To 0 Step -1
		_ArrayInsert($PackArr, 0, $T_PacLen[$z])
	Next
	_ArrayInsert($PackArr, 0, $SNMP_data_SEQ)
EndFunc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Func _BuildPDUType(ByRef $PackArr, $PPdu, $Rqid, $BlkNbr = "")		;add Error Index, Error, Request ID, PDU Type (Build Core PDU)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Error Index Block ~~~
	If StringStripWS($BlkNbr, 8) <> "" Then
		_ArrayInsert($PackArr, 0, $BlkNbr)
	Else
		_ArrayInsert($PackArr, 0, "00")
	EndIf
	_ArrayInsert($PackArr, 0, "01")		;len (1)
	_ArrayInsert($PackArr, 0, "02")
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Error Block ~~~~~~~~~~
	_ArrayInsert($PackArr, 0, "00")
	_ArrayInsert($PackArr, 0, "01")		;len (1)
	_ArrayInsert($PackArr, 0, "02")
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Request ID Block ~~~~~
	_ArrayInsert($PackArr, 0, Hex($Rqid, 2))
	_ArrayInsert($PackArr, 0, "00")
	_ArrayInsert($PackArr, 0, "02")		;len (2)
	_ArrayInsert($PackArr, 0, "02")
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Len and Type (30) ~~~~
	Local $T_PacLen = _RetPackLen()
	For $z = UBound($T_PacLen)-1 To 0 Step -1
		_ArrayInsert($PackArr, 0, $T_PacLen[$z])
	Next
	_ArrayInsert($PackArr, 0, $PPdu)
EndFunc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Func _AddCommunity(ByRef $PackArr, $snmpCOMMstr)				;add community string
	Local $T_PacLen = _BuildCOM($snmpCOMMstr)
	For $z = UBound($T_PacLen)-1 To 0 Step -1
		_ArrayInsert($PackArr, 0, $T_PacLen[$z])
	Next
EndFunc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Func _AddSNMPVersion(ByRef $PackArr, $snmpVersn)				;add SNMP Version
	_ArrayInsert($PackArr, 0, Hex($snmpVersn-1, 2))
	_ArrayInsert($PackArr, 0, "01")		;len (1)
	_ArrayInsert($PackArr, 0, "02")
EndFunc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Func _ClosePacket(ByRef $PackArr)				;add community string
	Local $T_PacLen = _RetPackLen()
	For $z = UBound($T_PacLen)-1 To 0 Step -1
		_ArrayInsert($PackArr, 0, $T_PacLen[$z])
	Next
	_ArrayInsert($PackArr, 0, "30")
	_ArrayInsert($PackArr, 0, "0x")
EndFunc
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#endregion
#region ~~~~~~~~~~~~~~~~~~~~ Encode Community ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _BuildCOM($comm)
	Local $hex_COMM = _StringToHex($comm)					;transform the community string in a hex value
	Local $len_COMM = Hex(StringLen($hex_COMM)/2, 2)		;calculate the length
	$SNMP_Community_Length = $len_COMM
	Local $COMM_Arr[Dec($len_COMM) + 2]						;build array to store values
	$COMM_Arr[0] = $SNMP_data_STR							;1st element Object ID = ASN.1 type "04"
	$COMM_Arr[1] = $len_COMM								;2nd element = length
	For $i = 2 To Dec($len_COMM)+1							;2digit OID parts
		$COMM_Arr[$i] = StringMid($hex_COMM, 2*$i - 3, 2)
	Next
	Return $COMM_Arr
EndFunc		;==>_BuildCOM
#endregion
#region ~~~~~~~~~~~~~~~~~~~~ Packet Length ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _RetPackLen()														;Return length (used for packet BUILD)
	Local $A_PacLen[1]
	Select
		Case UBound($SNMP_CmdArray) < 128
			$A_PacLen[0] = Hex(UBound($SNMP_CmdArray), 2)
		Case UBound($SNMP_CmdArray) > 127 And UBound($SNMP_CmdArray) < 256
			ReDim $A_PacLen[2]
			$A_PacLen[0] = "81"
			$A_PacLen[1] = Hex (UBound($SNMP_CmdArray), 2)
		Case UBound($SNMP_CmdArray)> 255
			ReDim $A_PacLen[3]
			$A_PacLen[0] = "82"
			$A_PacLen[1] = StringLeft(Hex (UBound($SNMP_CmdArray), 4), 2)
			$A_PacLen[2] = StringRight(Hex (UBound($SNMP_CmdArray), 4), 2)
	EndSelect
	Return $A_PacLen
EndFunc		;==>_RetPackLen
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
	Local $len_OID = Hex(StringLen($hex_OID)/2, 2)			;calculate the length
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
	$SNMP_CmdArray 					= ""
	$SNMP_ErrorID 					= 0
	$SNMP_ErrorIDX 					= 0
	$SNMP_OID_Length 				= 0
	$SNMP_Community_Length 			= 0
	$SNMP_Answ_Packet_Len 			= 0
	$SNMP_Answ_Version 				= 0
	$SNMP_Answ_Comm_String 			= ""
	$SNMP_Answ_PDU_Type 			= 0
	$SNMP_Answ_PDU_Len 				= 0
	$SNMP_Answ_RqID_Val 			= ""
	$SNMP_Answ_Err_Val 				= 0
	$SNMP_Answ_Err_Idx 				= 0
	$SNMP_Answ_Varbind_List_Type 	= 0
	$SNMP_Answ_Varbind_List_Len 	= 0
	$SNMP_Answ_Varbind_Type 		= 0
	$SNMP_Answ_Varbind_Len 			= 0
	$SNMP_Answ_OID_Type 			= 0
	$SNMP_Answ_OID_Len 				= 0
	$SNMP_Answ_OID_Len 				= 0
	$SNMP_Answ_DataType 			= 0
	Dim $SNMP_Answer[10000]
	Dim $SNMP_Received[1000][2]
	Dim $Varbind_content[1000]
	Dim $SNMP_Util[2][3]
EndFunc
#endregion ~~~~~~~~~~~~~~~~ END Initialize Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#region ~~~~~~~~~~~~~~~~~~~~ Build SNMP_Answer array ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _WriteRecv($rcv)
	Local $rcvd_content
	Local $counter = 0
	$rcvd_content = $rcv
	Do
		$SNMP_Answer[$counter] = StringLeft($rcvd_content, 2)
		$rcvd_content = StringTrimLeft($rcvd_content, 2)
		$counter += 1
	Until StringLen($rcvd_content) = 0
	ReDim $SNMP_Answer[$counter]
EndFunc		;==>_WriteRecv
#endregion ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#region ~~~~~~~~~~~~~~~~~~~~ MISC Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Func _DeleteIndexes(ByRef $Arr2DelIdx, $Idx_Range)
	Local $idx_arr = StringSplit($Idx_Range, "-")
	If $idx_arr[0] > 1 Then
		For $i = $idx_arr[2] To $idx_arr[1] Step -1
			_ArrayDelete($Arr2DelIdx, $i)
		Next
	ElseIf $idx_arr[0] = 1 Then
		_ArrayDelete($Arr2DelIdx, $idx_arr[1])
	EndIf
EndFunc
Func _GetPDUContent(ByRef $Arr2getCont)
	Local $_PDUlen = ""
	Local $_PDUstr = ""
	Local $_StOffset = 1
	Switch $Arr2getCont[1]
		Case "81"
			$_PDUlen = $Arr2getCont[2]
			$_StOffset = 2
		Case "82"
			$_PDUlen = $Arr2getCont[2]&$Arr2getCont[3]
			$_StOffset = 3
		Case Else
			$_PDUlen = $Arr2getCont[1]
			$_StOffset = 1
	EndSwitch
	For $i = 1 To _SNMPHexToDec("0x"&$_PDUlen)
		$_PDUstr &= $Arr2getCont[$i + $_StOffset]
	Next
	For $i = $_StOffset + _SNMPHexToDec("0x"&$_PDUlen) To 0 Step -1
		_ArrayDelete($Arr2getCont, $i)
	Next
	Return $_PDUstr
EndFunc
Func _ExtractUtilData($UtilContent)
	Local $_PDUlen = ""
	Local $_DEClen = ""
	Local $_OID_DATA = ""
	Local $_UtilOID = ""
	Local $_UtilDATA = ""
	Local $_ClearOID = ""
	Local $_ClearDATA = ""
	Local $_ClearRESULT[2]

	If StringLeft($UtilContent, 2) = $SNMP_data_OID Then
		$UtilContent = StringTrimLeft($UtilContent, 2)			;strip "06" = OID type
		$_PDUlen = StringLeft($UtilContent, 2)					;read first 2 digits
		Switch StringLeft($_PDUlen, 2)
			Case "81"
				$UtilContent = StringTrimLeft($UtilContent, 2)
				$_PDUlen = StringLeft($UtilContent, 2)
				$_OID_DATA = StringTrimLeft($UtilContent, 2)
			Case "82"
				$UtilContent = StringTrimLeft($UtilContent, 2)
				$_PDUlen = StringLeft($UtilContent, 4)
				$_OID_DATA = StringTrimLeft($UtilContent, 4)
			Case Else
				$_PDUlen = StringLeft($UtilContent, 2)
				$_OID_DATA = StringTrimLeft($UtilContent, 2)
		EndSwitch
		$_DEClen = _SNMPHexToDec("0x"&$_PDUlen)
		$_UtilOID = StringLeft($_OID_DATA, 2*$_DEClen)
		$_UtilDATA = StringTrimLeft($_OID_DATA, 2*$_DEClen)
		$_ClearOID = _ExtractData($SNMP_data_OID, $_UtilOID)
		$_ClearDATA = _ExtractData(StringLeft($_UtilDATA, 2), StringTrimLeft($_UtilDATA, 4))
		$_ClearRESULT[0] = $_ClearOID
		$_ClearRESULT[1] = $_ClearDATA
	Else 																					;bad response - not a proper SNMP one
		Return SetError (1)
	EndIf
	Return $_ClearRESULT
EndFunc
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
Func _GetPDUrawString($sData)
	Local $_PDUlen = ""
	Local $_DEClen = ""
	Local $_OID_DATA = ""
	Local $_UtilOID = ""
	Local $_UtilDATA = ""

	Local $retStr = ""

	If StringLeft($sData, 2) = $SNMP_data_OID Then
		$retStr &= StringLeft($sData, 2)&"|"
		$sData = StringTrimLeft($sData, 2)						;strip "06" = OID type
	;-------------------------------------------
		$_PDUlen = StringLeft($sData, 2)						;read first 2 digits
		Switch StringLeft($_PDUlen, 2)
			Case "81"
				$sData = StringTrimLeft($sData, 2)
				$_PDUlen = StringLeft($sData, 2)
				$retStr &= "81"&StringLeft($sData, 2)&"|"
				$_OID_DATA = StringTrimLeft($sData, 2)
			Case "82"
				$sData = StringTrimLeft($sData, 2)
				$_PDUlen = StringLeft($sData, 4)
				$retStr &= "82"&StringLeft($sData, 4)&"|"
				$_OID_DATA = StringTrimLeft($sData, 4)
			Case Else
				$_PDUlen = StringLeft($sData, 2)
				$retStr &= StringLeft($sData, 2)&"|"
				$_OID_DATA = StringTrimLeft($sData, 2)
		EndSwitch
		$_DEClen = _SNMPHexToDec("0x"&$_PDUlen)
		$_UtilOID = StringLeft($_OID_DATA, 2*$_DEClen)
		$retStr &= $_UtilOID&"|"
		$_UtilDATA = StringTrimLeft($_OID_DATA, 2*$_DEClen)
		$retStr &= StringLeft($_UtilDATA, 2)&"|"
		$_UtilDATA = StringTrimLeft($_UtilDATA, 2)
		$retStr &= StringLeft($_UtilDATA, 2)&"|"
		$_UtilDATA = StringTrimLeft($_UtilDATA, 2)
		$retStr &= $_UtilDATA
	EndIf
	Return $retStr
EndFunc