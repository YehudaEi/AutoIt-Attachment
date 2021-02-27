#Include <String.au3>
#Include <Array.au3>
#Include 'SNMP_UDF_v1.7.1.au3'

; ----- CAUTION -------------------------------------------------------------
; This script will modify the value found at sysLocation (1.3.6.1.2.1.1.6.0)
; it is your job to write back whatever was there previously :)
;----------------------------------------------------------------------------

;In order to have a succesful script run you will need to be sure that:
; - you are using the "write" community string
; - the OID where you want to write is NOT Read-Only
; - the value type you want to write is according to that OID (if you try to write text in an integer type OID it will fail)


Global $dest_IP = "192.168.0.30" 			; Destination Address (change it)
Global $Port = 161 							; UDP 161  = SNMP port
Global $SNMP_Version = 2					; SNMP v2c (1 for SNMP v1)
Global $SNMP_Community = "private"			; SNMPString(Community) - you need the "write" community string to test this.
Global $SNMP_ReqID = 1
Global $SNMP_Command
Global $Start = 1
Global $result

UDPStartUp()
$Socket = UDPopen($dest_IP, $Port)

;Read value at sysLocation
Global $SNMP_OID = "1.3.6.1.2.1.1.6.0"
$SNMP_Command = _SNMPBuildPacket($SNMP_OID, $SNMP_Community,$SNMP_Version, $SNMP_ReqID, "A0")
UDPSend($Socket, $SNMP_Command)
_StartListener()
sleep (200)
_ArrayDisplay($SNMP_Util, "GetRequest 1x OID")

;Write value at sysLocation
Global $SNMP_OID = "1.3.6.1.2.1.1.6.0"
$SNMP_Command = _SNMPBuildPacket($SNMP_OID, $SNMP_Community,$SNMP_Version, $SNMP_ReqID, "A3", "32", "04", "My TEST String here ...")
UDPSend($Socket, $SNMP_Command)
_StartListener()
sleep (200)
_ArrayDisplay($SNMP_Util, "Write 1x OID")

;Read new value at sysLocation
Global $SNMP_OID = "1.3.6.1.2.1.1.6.0"
$SNMP_Command = _SNMPBuildPacket($SNMP_OID, $SNMP_Community,$SNMP_Version, $SNMP_ReqID, "A0")
UDPSend($Socket, $SNMP_Command)
_StartListener()
sleep (200)
_ArrayDisplay($SNMP_Util, "GetRequest 1x OID")


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