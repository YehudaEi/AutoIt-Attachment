#include-once

;=====================================================================================================

#CS
; Example script

Local $conn = StatsdOpen("33.33.33.34", 8125)
If @error Or (IsArray($conn) And $conn[0] = 0) Then
	ConsoleWrite("StatsdOpen - UDPOpen returned error: " & @error & @LF)
	Exit
EndIf
$result = StatsdGauge($conn, "autoit.gauge", 50)
$result = StatsdCount($conn, "autoit.count", 10)
$result = StatsdInc($conn, "autoit.count")
$result = StatsdDec($conn, "autoit.count")
$result = StatsdTiming($conn, "autoit.timing", 100)

#CE

;=====================================================================================================
; It connects to a StatsD server, and returns the connection handle

Func StatsdOpen($url, $port)
	UDPStartup()
	Local $conn = UDPOpen ( $url, $port )
	return $conn
EndFunc

;=====================================================================================================
; It closes the connection to the StatsD server

Func StatsdClose($conn)
	If IsArray($conn) Then UDPCloseSocket ($conn)
	UDPShutdown()
EndFunc

;=====================================================================================================
; It sends a message to a StatsD server
; 	$conn = handle obtained from StatsdOpen()
;	$stat = name of the stat, including namespaces separated with dots (i.e. "namespace1.namespace2.stat_name")
;	$value = a 32-bit integer value
;	$type = the type of the stat:
;			- "ms" for Timing stats, in milliseconds
;			- "g" for Gauge stats (i.e. the % of a given CPU usage, which is unique in a given time)
;			- "c" for Count stats (i.e. counting how many times a given event happened, value can be a positive or negative number, increasing or decreasing the count).
;	$sample_rate = normally 1.0, but for very frequent events it might be desirable to send only a fraction to reduce bandwidth consumption, and let StatsD server interpolate unsent events.
;	$addNewLine = whether a new line character should be added to the end of the message

Func StatsdSend($conn, $stat, $value, $type, $sample_rate = 1.0, $addNewLine = 0)

    ; if sample_rate is less than 1.0, toss a dice and decide whether we need to send the stat
    If $sample_rate < 1.0 Then
        If $sample_rate < Random() Then
			return true
		EndIf
	EndIf

	; normalize stat name
	$stat = StringReplace($stat, ":", "_")
	$stat = StringReplace($stat, "|", "_")
	$stat = StringReplace($stat, "@", "_")

	; prepare the message
	Local $msg = $stat & ":" & $value & "|" & $type
    If $sample_rate < 1.0 Then $msg &= "|@" & StringFormat("%.2f", $sample_rate)
	If $addNewLine <> 0 Then $msg &= @CRLF

	; send the message
	Local $sent = UDPSend ( $conn, $msg )
	If @error Then
		ConsoleWrite("UDPSend error: " & @error & @LF)
		Return False
	EndIf

	If $sent = StringLen($msg) Then Return True
	Return False
EndFunc

;================================================================================================

Func StatsdCount($conn, $stat, $value, $sample_rate = 1.0)
	return StatsdSend($conn, $stat, $value, "c", $sample_rate)
EndFunc

;================================================================================================

Func StatsdDec($conn, $stat, $sample_rate = 1.0)
	return StatsdCount($conn, $stat, -1, $sample_rate)
EndFunc

;================================================================================================

Func StatsdInc($conn, $stat, $sample_rate = 1.0)
	return StatsdCount($conn, $stat, 1, $sample_rate)
EndFunc

;================================================================================================

Func StatsdGauge($conn, $stat, $value)
	return StatsdSend($conn, $stat, $value, "g", 1.0)
EndFunc

;================================================================================================

Func StatsdTiming($conn, $stat, $value)
	return StatsdSend($conn, $stat, $value, "ms", 1.0)
EndFunc


