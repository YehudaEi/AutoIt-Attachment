#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=.\SSDPdiscover.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=(c) by Rainer Ullrich
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=Dateiname|SSDPdiscover
#AutoIt3Wrapper_Res_Field=Email|rainer@rainerullrich.de
#AutoIt3Wrapper_Run_After=del ".\SSDPdiscover*.au3.tbl"
#AutoIt3Wrapper_Run_After=del ".\SSDPdiscover*_Obfuscated.au3"
#AutoIt3Wrapper_Run_Obfuscator=y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Obfuscator_Parameters=/cs=1 /cn=1 /cf=1 /cv=1 /sf=1 /sv=1
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Date.au3>
#include <Array.au3>

Opt("MustDeclareVars", 1)

; --- MainVar-Deklaration ---
#region MainVar-Deklaration
; Für SSDPdiscover
Global $MyCollectedResponses ; Array with the collected Responses
Global $MyCollectedIPs ; Array with the collected IPs
Global $MyTimeToSearch = 15 * 1000 ; time to search in ticks
Global $MySendInterval = 3 * 1000; each x ticks the ssdp-discover will be sent
Global $MyResultDatei = ".\ssdp-discover-result.txt"
Global $MyTemp, $MyError, $MyReturn

; MsgBox
Global Const $Mnormal = 0 + 262144
Global Const $Merror = 16 + 262144
Global Const $Mquestion = 32 + 262144
Global Const $Mattention = 48 + 262144
Global Const $Mresult = 64 + 262144
#endregion MainVar-Deklaration


; --- Main ---
#region Main
; -- SSDP Discxover via UPnP --
$MyReturn = SSDPdiscover_V1($MyCollectedResponses, $MyCollectedIPs, $MyTimeToSearch, $MySendInterval) ; change here ..._V1 or ..._V2   <-------------
$MyError = @error
If $MyError <> 0 Then
	$MyTemp = "SSDPdiscover failed!" & @CRLF & @CRLF
	Switch $MyError
		Case 0
			; nix
		Case 1
			$MyTemp &= "UDPOpen-error"
		Case 2
			$MyTemp &= "UDPSend-error"
		Case 3
			$MyTemp &= "UDPRecv-error"
		Case 4
			$MyTemp &= "UDPBind-error"
	EndSwitch
	MsgBox($Merror, "error:", $MyTemp)
	Exit
EndIf


; -- Result --
; delete file
If FileExists($MyResultDatei) Then
	If Not FileDelete($MyResultDatei) Then
		MsgBox($Merror, "error:", 'the file "' & $MyResultDatei & '" could not be deletet!')
		Exit
	EndIf
EndIf

; Responses
If IsArray($MyCollectedResponses) Then
	$MyTemp = ''
	For $e = 1 To $MyCollectedResponses[0]
		$MyTemp &= $MyCollectedResponses[$e] & @CRLF
	Next
	If FileWrite($MyResultDatei, $MyTemp) Then
		; Quickhack un die Datei zu öffnen
		Run(@ComSpec & ' /c start "" "' & $MyResultDatei & '"', @WorkingDir, @SW_HIDE)
		MsgBox($Mresult, "result:", 'the result was writen in the file "' & $MyResultDatei & '"!')
	Else
		MsgBox($Mresult, "result:", 'the file could not be written in the file "' & $MyResultDatei & '"!')
	EndIf
Else
	MsgBox(0, "result:", "no responses via UPnP!")
EndIf

; IP
If IsArray($MyCollectedIPs) Then
	_ArrayDisplay($MyCollectedIPs, "Collectes IPs")
Else
	MsgBox($Mresult, "result:", "no IP-addresses found!")
EndIf

Exit
#endregion Main



; --- Funktionsdefinitionen ---
#region Funktionsdefinitionen
; Function that performs a UPnP ssdp-discover and writes the results into an array.
; In addition, the IP addresses of the devices are written in a second array.
; V1: Receive-Socket = Send-Socket. Works on XP (independed how many networkcards are installed) and Win 7 only, when all network cards, exclude 1, are disabled in the device manager
; Error:
;   0  =  kein Error
;   1  =  UDPOpen-error
;   2  =  UDPSend-error
;   3  =  UDPRecv-error
;   4  =  UDPBind-error
Func SSDPdiscover_V1(ByRef $ResponsesArray, ByRef $IPArray, $TicksToSearch = 10000, $SendIntervalInTicks = 1000)

	; --- UPnP-Kommando ---
	Local Const $UPnPcmd = _
			'M-SEARCH * HTTP/1.1' & @CRLF & _
			'ST:upnp:rootdevice' & @CRLF & _
			'MX: 10' & @CRLF & _
			'MAN: "ssdp:discover"' & @CRLF & _
			'HOST: 239.255.255.250:1900' & @CRLF & _
			@CRLF
	Local $UPNPsendSocket, $UPNPreceiveSocket
	Local $SendCounter = 0, $ReceiveCounter = 0
	Local $ReceiveData, $NewIP
	Local $StartTimeoutTimer, $UsedTimeoutTicks ; Timeout-Timer
	Local $StartSendTimer, $UsedSendTicks ; Send-Timer
	Local $OldRemainSeconds = -99, $RemainSeconds
	Local $return = 1, $error = 0

	; Arrays "löschen"
	$ResponsesArray = ""
	$IPArray = ""

	; UPnP-Kommando ausgeben
	ConsoleWrite(@CRLF)
	ConsoleWrite("UPnP-Kommando:" & @CRLF)
	ConsoleWrite($UPnPcmd & @CRLF)

	; UDP starten
	UDPStartup()

	; - Sender -
	;    $array[1] contains the real socket, $array[2] contains the specified IP address and $array[3] contains the port
	$UPNPsendSocket = UDPOpen("239.255.255.250", 1900)
	ConsoleWrite("SendSocket: real socket: " & $UPNPsendSocket[1] & ", IP-address: " & $UPNPsendSocket[2] & ", port: " & $UPNPsendSocket[3] & @CRLF & @CRLF)
	; _ArrayDisplay($UPNPsendSocket)
	If $UPNPsendSocket[0] == -1 Or $UPNPsendSocket[0] == 0 Then ; documentation is somewhat vague
		; Error 1
		Return SetError(1, 0, 0)
	EndIf

	; - Empfänger -
	; Socket muß der gleiche sein, sonst geht es nicht. Allerdings funktioniert es nicht auf Win 7-Rechnern mit mehreren Netzwerkkarten :-(
	$UPNPreceiveSocket = $UPNPsendSocket

	; Timer setzen
	$StartTimeoutTimer = TimerInit() ; Timeout-Timer
	$StartSendTimer = -99 ; Notlösung, kann man schöner programmieren

	While 1

		; SenderPause berechnen
		If $StartSendTimer = -99 Then
			; Timer wurde bisher noch nicht gesetzt, daher UsedTicks setzen
			$UsedSendTicks = $SendIntervalInTicks + 10
		Else
			; Berechnen
			$UsedSendTicks = TimerDiff($StartSendTimer)
		EndIf

		; Senden
		If $UsedSendTicks > $SendIntervalInTicks Then
			$SendCounter += 1
			ConsoleWrite("UPnP Send Count Nr " & $SendCounter & @CRLF & @CRLF)
			UDPSend($UPNPsendSocket, $UPnPcmd)
			If @error <> 0 Then
				$error = 2
				$return = 0
				ExitLoop
			EndIf
			; reset timer
			$StartSendTimer = TimerInit()
		EndIf

		; kurze Pause (nach dem Senden)
		Sleep(100)

		; Empfangen
		$ReceiveData = UDPRecv($UPNPreceiveSocket, 1024)
		If @error <> 0 Then
			$error = 3
			$return = 0
			ExitLoop
		EndIf
		If $ReceiveData <> "" Then
			$ReceiveCounter += 1
			ConsoleWrite("-------------------- Received Response " & $ReceiveCounter & ":" & " --------------------" & @CRLF)
			ConsoleWrite($ReceiveData & @CRLF)
			; Wenn neue Responds, dann hinzugügen
			If AddItemToArray($ResponsesArray, $ReceiveData, 1) > 0 Then
				ConsoleWrite("-> hinzugefügt" & @CRLF & @CRLF)
			Else
				ConsoleWrite("-> bereits vorhanden" & @CRLF & @CRLF)
			EndIf
			; IP extrahieren und sammeln
			$NewIP = FetchIPfromUPNPdata($ReceiveData)
			If $NewIP <> "" Then AddItemToArray($IPArray, $NewIP, 1)
		EndIf

		; Verbrauchte Zeit ermitteln
		$UsedTimeoutTicks = TimerDiff($StartTimeoutTimer)
		; Wenn die Zeit verstrichen ist, dann raus
		If $UsedTimeoutTicks >= $TicksToSearch Then
			ExitLoop
		Else
			; Restsekunden berechnen und als TrayTip ausgeben
			$RemainSeconds = Ceiling(($TicksToSearch - $UsedTimeoutTicks) / 1000)
			If $RemainSeconds <> $OldRemainSeconds Then
				TrayTip("SSDP-Discover", "Search for devices via UPnP (" & $RemainSeconds & " seconds)... ", 5, 1)
				$OldRemainSeconds = $RemainSeconds
			EndIf
		EndIf
	WEnd

	; TrayTip schliessen
	TrayTip("", "", 0)

	; Socket schliessen
	UDPCloseSocket($UPNPsendSocket)
	UDPCloseSocket($UPNPreceiveSocket)

	; UDP beenden
	UDPShutdown()

	; Sortieren
	If IsArray($IPArray) Then _ArraySort($IPArray, 0, 1)
	If IsArray($ResponsesArray) Then _ArraySort($ResponsesArray, 0, 1)

	; Wenn error vorhanden, dann error zurückliefern
	If $error > 0 Then
		; error zurückliefern
		Return SetError($error, 0, $return)
	Else
		; Normaler Return
		Return $return
	EndIf

EndFunc   ;==>SSDPdiscover_V1



; Function that performs a UPnP ssdp-discover and writes the results into an array.
; In addition, the IP addresses of the devices are written in a second array.
; V2: Receive-Socket and Send-Socket are differ. I try many different ways, but nothing works :-(
; Error:
;   0  =  kein Error
;   1  =  UDPOpen-error
;   2  =  UDPSend-error
;   3  =  UDPRecv-error
;   4  =  UDPBind-error
Func SSDPdiscover_V2(ByRef $ResponsesArray, ByRef $IPArray, $TicksToSearch = 10000, $SendIntervalInTicks = 1000)

	; --- UPnP-Kommando ---
	Local Const $UPnPcmd = _
			'M-SEARCH * HTTP/1.1' & @CRLF & _
			'ST:upnp:rootdevice' & @CRLF & _
			'MX: 10' & @CRLF & _
			'MAN: "ssdp:discover"' & @CRLF & _
			'HOST: 239.255.255.250:1900' & @CRLF & _
			@CRLF
	Local $UPNPsendSocket, $UPNPreceiveSocket
	Local $SendCounter = 0, $ReceiveCounter = 0
	Local $ReceiveData, $NewIP
	Local $StartTimeoutTimer, $UsedTimeoutTicks ; Timeout-Timer
	Local $StartSendTimer, $UsedSendTicks ; Send-Timer
	Local $OldRemainSeconds = -99, $RemainSeconds
	Local $return = 1, $error = 0

	; Arrays "löschen"
	$ResponsesArray = ""
	$IPArray = ""

	; UPnP-Kommando ausgeben
	ConsoleWrite(@CRLF)
	ConsoleWrite("UPnP-Kommando:" & @CRLF)
	ConsoleWrite($UPnPcmd & @CRLF)

	; UDP starten
	UDPStartup()

	; - Sender -
	;    $array[1] contains the real socket, $array[2] contains the specified IP address and $array[3] contains the port
	$UPNPsendSocket = UDPOpen("239.255.255.250", 1900)
	ConsoleWrite("SendSocket: real socket: " & $UPNPsendSocket[1] & ", IP-address: " & $UPNPsendSocket[2] & ", port: " & $UPNPsendSocket[3] & @CRLF & @CRLF)
	; _ArrayDisplay($UPNPsendSocket)
	If $UPNPsendSocket[0] == -1 Or $UPNPsendSocket[0] == 0 Then ; documentation is somewhat vague
		; Error 1
		Return SetError(1, 0, 0)
	EndIf

	; - Empfänger -
	If @IPAddress1 <> "0.0.0.0" Then ConsoleWrite(@IPAddress1 & @CRLF)
	If @IPAddress2 <> "0.0.0.0" Then ConsoleWrite(@IPAddress2 & @CRLF)
	If @IPAddress3 <> "0.0.0.0" Then ConsoleWrite(@IPAddress3 & @CRLF)
	If @IPAddress4 <> "0.0.0.0" Then ConsoleWrite(@IPAddress4 & @CRLF)
	; $UPNPreceiveSocket = UDPBind("127.0.0.1", 1900)
	; $UPNPreceiveSocket = UDPBind(@IPAddress1, 1900)
	; $UPNPreceiveSocket = UDPBind("127.0.0.1", $UPNPsendSocket[1])
	; $UPNPreceiveSocket = UDPBind(@IPAddress1, $UPNPsendSocket[1])
	; $UPNPreceiveSocket = UDPBind("239.255.255.250", 1900)
	$UPNPreceiveSocket = UDPBind(@IPAddress1, 1900)
	ConsoleWrite("ReceiveSocket: real socket: " & $UPNPreceiveSocket[1] & ", IP-address: " & $UPNPreceiveSocket[2] & ", port: " & $UPNPreceiveSocket[3] & @CRLF & @CRLF)
	; _ArrayDisplay($UPNPsendSocket)
	If $UPNPreceiveSocket[0] == -1 Or $UPNPreceiveSocket[0] == -0 Then ; documentation is somewhat vague
		; Error 4
		Return SetError(4, 0, 0)
	EndIf

	; Timer setzen
	$StartTimeoutTimer = TimerInit() ; Timeout-Timer
	$StartSendTimer = -99 ; temporary solution, could be better :)

	While 1

		; SenderPause berechnen
		If $StartSendTimer = -99 Then
			; Timer wurde bisher noch nicht gesetzt, daher UsedTicks setzen
			$UsedSendTicks = $SendIntervalInTicks + 10
		Else
			; Berechnen
			$UsedSendTicks = TimerDiff($StartSendTimer)
		EndIf

		; Senden
		If $UsedSendTicks > $SendIntervalInTicks Then
			$SendCounter += 1
			ConsoleWrite("UPnP Send Count Nr " & $SendCounter & @CRLF & @CRLF)
			UDPSend($UPNPsendSocket, $UPnPcmd)
			If @error <> 0 Then
				$error = 2
				$return = 0
				ExitLoop
			EndIf
			; reset timer
			$StartSendTimer = TimerInit()
		EndIf

		; kurze Pause (nach dem Senden)
		Sleep(100)

		; Empfangen
		$ReceiveData = UDPRecv($UPNPreceiveSocket, 1024)
		If @error <> 0 Then
			$error = 3
			$return = 0
			ExitLoop
		EndIf
		If $ReceiveData <> "" Then
			$ReceiveCounter += 1
			ConsoleWrite("-------------------- Received Response " & $ReceiveCounter & ":" & " --------------------" & @CRLF)
			ConsoleWrite($ReceiveData & @CRLF)
			; Wenn neue Responds, dann hinzugügen
			If AddItemToArray($ResponsesArray, $ReceiveData, 1) > 0 Then
				ConsoleWrite("-> hinzugefügt" & @CRLF & @CRLF)
			Else
				ConsoleWrite("-> bereits vorhanden" & @CRLF & @CRLF)
			EndIf
			; IP extrahieren und sammeln
			$NewIP = FetchIPfromUPNPdata($ReceiveData)
			If $NewIP <> "" Then AddItemToArray($IPArray, $NewIP, 1)
		EndIf

		; Verbrauchte Zeit ermitteln
		$UsedTimeoutTicks = TimerDiff($StartTimeoutTimer)
		; Wenn die Zeit verstrichen ist, dann raus
		If $UsedTimeoutTicks >= $TicksToSearch Then
			ExitLoop
		Else
			; Restsekunden berechnen und als TrayTip ausgeben
			$RemainSeconds = Ceiling(($TicksToSearch - $UsedTimeoutTicks) / 1000)
			If $RemainSeconds <> $OldRemainSeconds Then
				TrayTip("SSDP-Discover", "Search for devices via UPnP (" & $RemainSeconds & " seconds)... ", 5, 1)
				$OldRemainSeconds = $RemainSeconds
			EndIf
		EndIf
	WEnd

	; TrayTip schliessen
	TrayTip("", "", 0)

	; Socket schliessen
	UDPCloseSocket($UPNPsendSocket)
	UDPCloseSocket($UPNPreceiveSocket)

	; UDP beenden
	UDPShutdown()

	; Sortieren
	If IsArray($IPArray) Then _ArraySort($IPArray, 0, 1)
	If IsArray($ResponsesArray) Then _ArraySort($ResponsesArray, 0, 1)

	; Wenn error vorhanden, dann error zurückliefern
	If $error > 0 Then
		; error zurückliefern
		Return SetError($error, 0, $return)
	Else
		; Normaler Return
		Return $return
	EndIf

EndFunc   ;==>SSDPdiscover_V2



; Funktion, die aus den ReceivedPacket die IP-Adresse extrahiert
Func FetchIPfromUPNPdata($Data)

	#cs Beispiel:
		
		HTTP/1.1 200 OK
		LOCATION: http://192.168.5.1:49000/igddesc.xml
		SERVER: WLAN_VDSL_Ullrich UPnP/1.0 AVM FRITZ!Box Fon WLAN 7270 54.04.74
		CACHE-CONTROL: max-age=1800
		EXT:
		ST: upnp:rootdevice
		USN: uuid:75802409-bccb-40e7-8e6c-001F3F56E239::upnp:rootdevice
	#ce

	; --- Einfach mit RegExp die IP rausfiltern ---
	; Local $IP = StringRegExp($Data, "LOCATION: http://\d+\.\d+\.\d+\.\d+:49", 1)
	Local $IP = StringRegExp($Data, "\d+\.\d+\.\d+\.\d+", 1)
	; _ArrayDisplay($IP)

	; Scheun ob es ein Array ist, wenn nicht raus
	If Not IsArray($IP) Then Return ""

	; Ich bauche erstes Element aus dem RegExp-Ergebnis
	$IP = $IP[0]

	; Überprüfen auf Gültigkeit
	If Not _IsIPv4($IP) Then Return ""

	Return $IP

EndFunc   ;==>FetchIPfromUPNPdata



; Funktion, die überprüft, ob es eine gültige IP4-IP ist
Func _IsIPv4($S_IP)
	If StringRegExp($S_IP, "\A(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])\z") Then Return (1)
	Return (0)
EndFunc   ;==>_IsIPv4



; Funktion, die ein Item an das Array (mit Zelle) hinzufügt und dabei den Counter in Zelle 0 um eins erhöht
; Ist das Array noch leer, wird es angelegt. Es wird der Counter zurückgeliefert
; Wenn $OnlyIfNew = 1, dann wird vorher geschaut, ob es schon im Array vorhanden ist
Func AddItemToArray(ByRef $ArrayWithCounterCell, $value, $OnlyIfNew = 0) ; Fügt zum Array ein Item hinzu und erhöht den Wert in Zelle 0. Ist das Array leer, wird eines erzeugt

	; Schauen, ob es ein Array ist. Wenn nicht, dann wird es angelegt und der Wert hinzugefügt
	If IsArray($ArrayWithCounterCell) Then
		; es ist ein Array
		; ggf. schauen, ob es bereits enthalten ist
		If $OnlyIfNew == 1 Then
			; Raus, wenn es bereist enthalten ist, also größer als 0
			If _ArraySearch($ArrayWithCounterCell, $value, 1) > 0 Then
				Return 0
			EndIf
		EndIf

		; Element hinzufügen
		Local $ret = _ArrayAdd($ArrayWithCounterCell, $value)
		; wenn ungleich -1 dann den Counter erhöhen
		If $ret <> -1 Then
			; um 1 erhöhren in Zelle 0
			Local $Count = $ArrayWithCounterCell[0] + 1
			$ArrayWithCounterCell[0] = $Count
			; Index, also Count zurückliefern
			Return $Count
		Else
			Return -1
		EndIf
	Else
		; Es ist kein Array, daher erzeugen und Wert hinzufügen
		Dim $ArrayWithCounterCell[2]
		$ArrayWithCounterCell[0] = 1
		$ArrayWithCounterCell[1] = $value
		Return 1
	EndIf

EndFunc   ;==>AddItemToArray
#endregion Funktionsdefinitionen