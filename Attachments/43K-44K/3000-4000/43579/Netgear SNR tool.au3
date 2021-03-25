
;                                         

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

Local $msg, $status, $modem_status, $bearer_downstream_rate, $bearer_upstream_rate, $link_power_state, $mode, $tps_tc, $trellis, $line_status, $downstream_snr, $upstream_snr, $downstream_attn, $upstream_attn, $downstream_pwr, $upstream_pwr

GUICreate("Netgear SNR tool", 450, 400) ; will create a dialog box that when displayed is centered

$tweak_snr = GUICtrlCreateButton("Tweak SNR", 10, 20, 100)
$reboot = GUICtrlCreateButton("Reboot", 120, 20, 100)

;	$myedit = GUICtrlCreateEdit("First line" & @CRLF, 10, 50, 400, 200, $ES_AUTOVSCROLL + $WS_VSCROLL)
;	GUICtrlSetData($myedit, $modem_status)

$waiting2 = GUICtrlCreateLabel("Before Tweak", 120, 70, 100, 20)

GUICtrlCreateLabel("Status :", 10, 50 + 60, 100, 20)
$status = GUICtrlCreateInput("", 120, 50 + 60, 80, 20)
GUICtrlCreateLabel("Downstream Rate (kbps) :", 10, 70 + 60, 100, 20)
$bearer_downstream_rate = GUICtrlCreateInput("", 120, 70 + 60, 80, 20)
GUICtrlCreateLabel("Upstream Rate (kbps):", 10, 90 + 60, 100, 20)
$bearer_upstream_rate = GUICtrlCreateInput("", 120, 90 + 60, 80, 20)
GUICtrlCreateLabel("Link Power State:", 10, 110 + 60, 100, 20)
$link_power_state = GUICtrlCreateInput("", 120, 110 + 60, 80, 20)
GUICtrlCreateLabel("Mode:", 10, 130 + 60, 100, 20)
$mode = GUICtrlCreateInput("", 120, 130 + 60, 80, 20)
GUICtrlCreateLabel("TPS-TC:", 10, 150 + 60, 100, 20)
$tps_tc = GUICtrlCreateInput("", 120, 150 + 60, 80, 20)
GUICtrlCreateLabel("Trellis:", 10, 170 + 60, 100, 20)
$trellis = GUICtrlCreateInput("", 120, 170 + 60, 80, 20)
GUICtrlCreateLabel("Line Status:", 10, 190 + 60, 100, 20)
$line_status = GUICtrlCreateInput("", 120, 190 + 60, 80, 20)
GUICtrlCreateLabel("Downstream SNR (dB) :", 10, 210 + 60, 100, 20)
$downstream_snr = GUICtrlCreateInput("", 120, 210 + 60, 80, 20)
GUICtrlCreateLabel("Upstream SNR (dB) :", 10, 230 + 60, 100, 20)
$upstream_snr = GUICtrlCreateInput("", 120, 230 + 60, 80, 20)
GUICtrlCreateLabel("Downstream Attn (dB) :", 10, 250 + 60, 100, 20)
$downstream_attn = GUICtrlCreateInput("", 120, 250 + 60, 80, 20)
GUICtrlCreateLabel("Upstream Attn (dB) :", 10, 270 + 60, 100, 20)
$upstream_attn = GUICtrlCreateInput("", 120, 270 + 60, 80, 20)
GUICtrlCreateLabel("Downstream Pwr (dBm) :", 10, 290 + 60, 100, 20)
$downstream_pwr = GUICtrlCreateInput("", 120, 290 + 60, 80, 20)
GUICtrlCreateLabel("Upstream Pwr (dBm) :", 10, 310 + 60, 100, 20)
$upstream_pwr = GUICtrlCreateInput("", 120, 310 + 60, 80, 20)

$waiting = GUICtrlCreateLabel("After Tweak", 220, 70, 100, 20)

$status2 = GUICtrlCreateInput("", 220, 50 + 60, 80, 20)
$bearer_downstream_rate2 = GUICtrlCreateInput("", 220, 70 + 60, 80, 20)
$bearer_upstream_rate2 = GUICtrlCreateInput("", 220, 90 + 60, 80, 20)
$link_power_state2 = GUICtrlCreateInput("", 220, 110 + 60, 80, 20)
$mode2 = GUICtrlCreateInput("", 220, 130 + 60, 80, 20)
$tps_tc2 = GUICtrlCreateInput("", 220, 150 + 60, 80, 20)
$trellis2 = GUICtrlCreateInput("", 220, 170 + 60, 80, 20)
$line_status2 = GUICtrlCreateInput("", 220, 190 + 60, 80, 20)
$downstream_snr2 = GUICtrlCreateInput("", 220, 210 + 60, 80, 20)
$upstream_snr2 = GUICtrlCreateInput("", 220, 230 + 60, 80, 20)
$downstream_attn2 = GUICtrlCreateInput("", 220, 250 + 60, 80, 20)
$upstream_attn2 = GUICtrlCreateInput("", 220, 270 + 60, 80, 20)
$downstream_pwr2 = GUICtrlCreateInput("", 220, 290 + 60, 80, 20)
$upstream_pwr2 = GUICtrlCreateInput("", 220, 310 + 60, 80, 20)

GUICtrlCreateLabel("Improvement", 320, 70, 100, 20)

$bearer_downstream_rate3 = GUICtrlCreateLabel("", 320, 70 + 60, 100, 20)
$bearer_upstream_rate3 = GUICtrlCreateLabel("", 320, 90 + 60, 100, 20)

$modem_status = get_modem_status()
update_before_tweak($modem_status)

GUISetState(@SW_SHOW) ; will display an empty dialog box

; Run the GUI until the dialog is closed
While 1

	$msg = GUIGetMsg()


	Select

		Case $msg = $GUI_EVENT_CLOSE

			ExitLoop

		Case $msg = $tweak_snr

			tweak_snr()

			GUICtrlSetData($waiting, "Tweaking ")

			Do

				GUICtrlSetData($waiting, GUICtrlRead($waiting) & ".")
				Sleep(5000)
				$modem_status = get_modem_status()
			Until (StringInStr($modem_status, "Downstream rate = ") > 0)

			GUICtrlSetData($waiting, "After Tweak")

			update_after_tweak($modem_status)

			GUICtrlSetData($bearer_downstream_rate3, Int(((GUICtrlRead($bearer_downstream_rate2) / GUICtrlRead($bearer_downstream_rate)) * 100) - 100) & " %")
			GUICtrlSetData($bearer_upstream_rate3, Int(((GUICtrlRead($bearer_upstream_rate2) / GUICtrlRead($bearer_upstream_rate)) * 100) - 100) & " %")


		Case $msg = $reboot

			blank_before_tweak()
			reboot()
			Exit

			GUICtrlSetData($waiting2, "Rebooting ")

			Do

				GUICtrlSetData($waiting2, GUICtrlRead($waiting2) & ".")
				Sleep(5000)
				$modem_status = get_modem_status()
			Until (StringInStr($modem_status, "Downstream rate = ") > 0)

			GUICtrlSetData($waiting2, "Before Tweak")

			update_before_tweak($modem_status)



	EndSelect


WEnd
GUIDelete()



Func get_modem_status()

	InetGet("http://admin:password@192.168.1.1/setup.cgi?todo=debug", @scriptdir & "\test.txt")

	TcpStartUp ()
	$RouterIP = tcpconnect("192.168.1.1", "23")
	Do

	   Sleep(100)

	Until $RouterIP <> "-1"

	$modem_status = ""

	While 1

	   Sleep(100)

	   $TCPRecv = TCPRecv($RouterIP,"5000")

		$modem_status = $modem_status & $TCPRecv

	  ; ConsoleWrite($TCPRecv) ;for debug test

	   If StringInStr($TCPRecv, "Login:") > 0 Then

		  TCPSend($RouterIP, "admin" & @crlf)

	   ElseIf StringInStr($TCPRecv, "Password:") > 0 Then

		  TCPSend($RouterIP, "password" & @crlf)
		  TCPSend($RouterIP, "adslctl info --stats" & @crlf)

	   ElseIf StringInStr($TCPRecv, "adslctl") > 0 Then
		  ExitLoop
	   EndIf
	WEnd
	TCPShutdown()

	Return $modem_status

EndFunc

Func tweak_snr($snr_pcnt = 40)


	InetGet("http://admin:password@192.168.1.1/setup.cgi?todo=debug", @scriptdir & "\test.txt")

	TcpStartUp ()
	$RouterIP = tcpconnect("192.168.1.1", "23")
	Do

	   Sleep(100)

	Until $RouterIP <> "-1"

	While 1

	   Sleep(100)

	   $TCPRecv = TCPRecv($RouterIP,"5000")

;	   ConsoleWrite($TCPRecv) ;for debug test

	   If StringInStr($TCPRecv, "Login:") > 0 Then

		  TCPSend($RouterIP, "admin" & @crlf)

	   ElseIf StringInStr($TCPRecv, "Password:") > 0 Then

		  TCPSend($RouterIP, "password" & @crlf)
		  TCPSend($RouterIP, "adslctl configure --snr 40" & @crlf)

	   ElseIf StringInStr($TCPRecv, "adslctl") > 0 Then
		  ExitLoop
	   EndIf
	WEnd
	TCPShutdown()

EndFunc


Func reboot()

	InetGet("http://admin:password@192.168.1.1/setup.cgi?todo=debug", @scriptdir & "\test.txt")

	TcpStartUp ()
	$RouterIP = tcpconnect("192.168.1.1", "23")
	Do

	   Sleep(100)

	Until $RouterIP <> "-1"

	While 1

	   Sleep(100)

	   $TCPRecv = TCPRecv($RouterIP,"5000")

;	   ConsoleWrite($TCPRecv) ;for debug test

	   If StringInStr($TCPRecv, "Login:") > 0 Then

		  TCPSend($RouterIP, "admin" & @crlf)

	   ElseIf StringInStr($TCPRecv, "Password:") > 0 Then

		  TCPSend($RouterIP, "password" & @crlf)
		  TCPSend($RouterIP, "reboot" & @crlf)

	   ElseIf StringInStr($TCPRecv, "reboot") > 0 Then
		  ExitLoop
	   EndIf
	WEnd
	TCPShutdown()

EndFunc


Func blank_before_tweak()

	GUICtrlSetData($status, "")
	GUICtrlSetData($bearer_downstream_rate, "")
	GUICtrlSetData($bearer_upstream_rate, "")
	GUICtrlSetData($link_power_state, "")
	GUICtrlSetData($mode, "")
	GUICtrlSetData($tps_tc, "")
	GUICtrlSetData($trellis, "")
	GUICtrlSetData($line_status, "")
	GUICtrlSetData($downstream_snr, "")
	GUICtrlSetData($upstream_snr, "")
	GUICtrlSetData($downstream_attn, "")
	GUICtrlSetData($upstream_attn, "")
	GUICtrlSetData($downstream_pwr, "")
	GUICtrlSetData($upstream_pwr, "")

EndFunc



Func update_before_tweak($modem_status)

	$text_start = StringInStr($modem_status, "Status: ") + StringLen("Status: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringMid($modem_status, $text_start, $text_end - $text_start)
	GUICtrlSetData($status, $text)

	$text_start = StringInStr($modem_status, ", Downstream rate = ", 0, 2) + StringLen(", Downstream rate = ")
	$text_end = StringInStr($modem_status, " Kbps", 0, 1, $text_start)
	$text = StringMid($modem_status, $text_start, $text_end - $text_start)
	GUICtrlSetData($bearer_downstream_rate, $text)

	$text_start = StringInStr($modem_status, "Upstream rate = ", 0, 2) + StringLen("Upstream rate = ")
	$text_end = StringInStr($modem_status, " Kbps", 0, 1, $text_start)
	$text = StringMid($modem_status, $text_start, $text_end - $text_start)
	GUICtrlSetData($bearer_upstream_rate, $text)

	$text_start = StringInStr($modem_status, "Link Power State:") + StringLen("Link Power State:")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($link_power_state, $text)

	$text_start = StringInStr($modem_status, "Mode: ") + StringLen("Mode: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($mode, $text)

	$text_start = StringInStr($modem_status, "TPS-TC: ") + StringLen("TPS-TC: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($tps_tc, $text)

	$text_start = StringInStr($modem_status, "Trellis: ") + StringLen("Trellis: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($trellis, $text)

	$text_start = StringInStr($modem_status, "Line Status: ") + StringLen("Line Status: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($line_status, $text)

	$text_start = StringInStr($modem_status, "SNR (dB): ") + StringLen("SNR (dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start - 7), 3)
	GUICtrlSetData($downstream_snr, $text)

	$text_start = StringInStr($modem_status, "SNR (dB): ") + StringLen("SNR (dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start + 17, $text_end - $text_start - 17), 3)
	GUICtrlSetData($upstream_snr, $text)

	$text_start = StringInStr($modem_status, "Attn(dB): ") + StringLen("Attn(dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start - 7), 3)
	GUICtrlSetData($downstream_attn, $text)

	$text_start = StringInStr($modem_status, "Attn(dB): ") + StringLen("Attn(dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start + 17, $text_end - $text_start - 17), 3)
	GUICtrlSetData($upstream_attn, $text)

	$text_start = StringInStr($modem_status, "Pwr(dBm): ") + StringLen("Pwr(dBm): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start - 7), 3)
	GUICtrlSetData($downstream_pwr, $text)

	$text_start = StringInStr($modem_status, "Pwr(dBm): ") + StringLen("Pwr(dBm): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start + 17, $text_end - $text_start - 17), 3)
	GUICtrlSetData($upstream_pwr, $text)

EndFunc

Func update_after_tweak($modem_status)

	$text_start = StringInStr($modem_status, "Status: ") + StringLen("Status: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringMid($modem_status, $text_start, $text_end - $text_start)
	GUICtrlSetData($status2, $text)

	$text_start = StringInStr($modem_status, ", Downstream rate = ", 0, 2) + StringLen(", Downstream rate = ")
	$text_end = StringInStr($modem_status, " Kbps", 0, 1, $text_start)
	$text = StringMid($modem_status, $text_start, $text_end - $text_start)
	GUICtrlSetData($bearer_downstream_rate2, $text)

	$text_start = StringInStr($modem_status, "Upstream rate = ", 0, 2) + StringLen("Upstream rate = ")
	$text_end = StringInStr($modem_status, " Kbps", 0, 1, $text_start)
	$text = StringMid($modem_status, $text_start, $text_end - $text_start)
	GUICtrlSetData($bearer_upstream_rate2, $text)

	$text_start = StringInStr($modem_status, "Link Power State:") + StringLen("Link Power State:")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($link_power_state2, $text)

	$text_start = StringInStr($modem_status, "Mode: ") + StringLen("Mode: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($mode2, $text)

	$text_start = StringInStr($modem_status, "TPS-TC: ") + StringLen("TPS-TC: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($tps_tc2, $text)

	$text_start = StringInStr($modem_status, "Trellis: ") + StringLen("Trellis: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($trellis2, $text)

	$text_start = StringInStr($modem_status, "Line Status: ") + StringLen("Line Status: ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start), 3)
	GUICtrlSetData($line_status2, $text)

	$text_start = StringInStr($modem_status, "SNR (dB): ") + StringLen("SNR (dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start - 7), 3)
	GUICtrlSetData($downstream_snr2, $text)

	$text_start = StringInStr($modem_status, "SNR (dB): ") + StringLen("SNR (dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start + 17, $text_end - $text_start - 17), 3)
	GUICtrlSetData($upstream_snr2, $text)

	$text_start = StringInStr($modem_status, "Attn(dB): ") + StringLen("Attn(dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start - 7), 3)
	GUICtrlSetData($downstream_attn2, $text)

	$text_start = StringInStr($modem_status, "Attn(dB): ") + StringLen("Attn(dB): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start + 17, $text_end - $text_start - 17), 3)
	GUICtrlSetData($upstream_attn2, $text)

	$text_start = StringInStr($modem_status, "Pwr(dBm): ") + StringLen("Pwr(dBm): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start, $text_end - $text_start - 7), 3)
	GUICtrlSetData($downstream_pwr2, $text)

	$text_start = StringInStr($modem_status, "Pwr(dBm): ") + StringLen("Pwr(dBm): ")
	$text_end = StringInStr($modem_status, @CR, 0, 1, $text_start)
	$text = StringStripWS(StringMid($modem_status, $text_start + 17, $text_end - $text_start - 17), 3)
	GUICtrlSetData($upstream_pwr2, $text)

EndFunc
