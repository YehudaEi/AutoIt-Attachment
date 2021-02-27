#Include <String.au3>
#Include <Array.au3>
#Include 'SNMP_UDF_v1.7.1.au3'

Global $dest_IP = "192.168.0.1" 			; Destination Address (change it)
Global $Port = 161 							; UDP 161  = SNMP port
Global $SNMP_Version = 2					; SNMP v2c (1 for SNMP v1)
Global $SNMP_Community = "public"			; SNMPString(Community) (change it)
Global $SNMP_ReqID = 1
Global $SNMP_Command
Global $Start = 1
Global $result

UDPStartUp()
$Socket = UDPopen($dest_IP, $Port)

;GetRequest for a single OID (add instance number - ".0" => OID=1.3.6.1.2.1.1 instance 0)  (system - sysDescr)
Global $SNMP_OID = "1.3.6.1.2.1.1.1.0"
$SNMP_Command = _SNMPBuildPacket($SNMP_OID, $SNMP_Community,$SNMP_Version, $SNMP_ReqID, "A0")
UDPSend($Socket, $SNMP_Command)
_StartListener()
sleep (200)
_ArrayDisplay($SNMP_Util, "GetRequest 1x OID")
_ArrayDisplay($SNMP_Received, "$SNMP_Received - EXAMPLE")

;GetNext for a single OID		(system - sysDescr)
Global $SNMP_OID = "1.3.6.1.2.1.1"
$SNMP_Command = _SNMPBuildPacket($SNMP_OID, $SNMP_Community,$SNMP_Version, $SNMP_ReqID, "A1")
UDPSend($Socket, $SNMP_Command)
_StartListener()
sleep (200)
_ArrayDisplay($SNMP_Util, "GetNext 1x OID")

;GetBulk (ifTable - ifDescr) 32 values returned
Global $SNMP_OID = "1.3.6.1.2.1.2.2.1.1"
$SNMP_Command = _SNMPBuildPacket($SNMP_OID, $SNMP_Community,$SNMP_Version, $SNMP_ReqID, "A5", "20")
UDPSend($Socket, $SNMP_Command)
_StartListener()
sleep (200)
_ArrayDisplay($SNMP_Util, "GetBulk")

Func _StartListener()
	If $Start = 1 Then
		$i = 0
		While (1)
			$srcv = UDPRecv($Socket, 2048)
			If ($srcv <> "") Then
				$result = _ShowSNMPReceived ($srcv)
				ConsoleWrite($srcv &@CRLF)
				;_ArrayDisplay($result)
				ExitLoop
			EndIf
		 sleep(100)
		WEnd
	EndIf
EndFunc

Func OnAutoItExit()
    UDPCloseSocket($Socket)
    UDPShutdown()
EndFunc