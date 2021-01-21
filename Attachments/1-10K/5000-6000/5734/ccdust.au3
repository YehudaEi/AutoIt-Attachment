Opt ("TrayIconHide", 1)
#include <GUIConstants.au3>
Local $PublicIP = _GetIP()
Local $NetworkIp = @IPAddress1
Dim $start=1
GUICreate("JFDuke3DST", "210", "250")
GUISetIcon("duke3d.exe", 0)
GUICtrlCreateLabel("Choose map:", 15, 5)
#Include <File.au3>
#Include <Array.au3>
Dim $vsebinamape = _FileListToArray (".", "*.MAP")
If (Not IsArray($vsebinamape)) Then
$vsebinamape = _ArrayCreate(0, "No maps")
$start=0
EndIf
Dim $listamap = _ArrayToString($vsebinamape, "|", 1)
GUICtrlCreateLabel("IP of server:", 15, 75)
$mapaS = GUICtrlCreateCombo("", 15, 20, 180)
GUICtrlSetData(-1, $listamap)
GUICtrlCreateLabel("Num. of players: ", 15, 55)
$sigS = GUICtrlCreateInput("1", 92, 50, 20, "", "$ES_NUMBER")
GUICtrlCreateLabel("Num. of maps: " & $vsebinamape[0], 120, 55)
$ipS = GUICtrlCreateInput($NetworkIp, 15, 90, "180", "", "$ES_UPPERCASE")
GUICtrlCreateLabel("Player name:", 15, 115)
$imeS = GUICtrlCreateInput("", 15, 130, "180", "", "$ES_UPPERCASE")
$IpLabel = GUICtrlCreateLabel("", 15, 160, 180, 30, $SS_SUNKEN)
GUICtrlSetData($IpLabel, "Public IP: " & $PublicIP & @CRLF & "Network IP: " & $NetworkIp)
$start = GUICtrlCreateButton("Join", 20, 200, 50, 30)
$skrij = GUICtrlCreateButton("Exit", 140, 200, 50, 30)
$server = GUICtrlCreateButton("Server", 80, 200, 50, 30)
GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()
	$mapa = GUICtrlRead($mapaS)
	$ip = GUICtrlRead($ipS)
	$sig = GUICtrlRead($sigS)
	$ime = GUICtrlRead($imeS)
	Select
		Case $msg = $start
		   GUISetState(@SW_HIDE)
			RunWait('"duke3d.exe" -name ' & $ime & ' -map ' & $mapa & ' -net /n0 ' & $ip)
			GUISetState(@SW_SHOW)
		Case $msg = $server
		   GUISetState(@SW_HIDE)
			RunWait('"duke3d.exe" -name ' & $ime & ' -map ' & $mapa & ' -net /n0:' & $sig)
			GUISetState(@SW_SHOW)
		Case $msg = $skrij or $msg = $GUI_EVENT_CLOSE
			Exit
	EndSelect
WEnd

	

Func _GetIP()
	Local $ip, $t_ip
	If InetGet("http://checkip.dyndns.org/?rnd1=" & Random(1, 65536) & "&rnd2=" & Random(1, 65536), @TempDir & "\~ip.tmp") Then
		$ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
		$ip = StringTrimLeft($ip, StringInStr($ip, ":") + 1)
		$ip = StringTrimRight($ip, StringLen($ip) - StringInStr($ip, "/") + 2)
		$t_ip = StringSplit($ip, '.')
		If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
			Return $ip
		EndIf
	EndIf
	If InetGet("http://www.whatismyip.com/?rnd1=" & Random(1, 65536) & "&rnd2=" & Random(1, 65536), @TempDir & "\~ip.tmp") Then
		$ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
		$ip = StringTrimLeft($ip, StringInStr($ip, "Your ip is") + 10)
		$ip = StringLeft($ip, StringInStr($ip, " ") - 1)
		$ip = StringStripWS($ip, 8)
		$t_ip = StringSplit($ip, '.')
		If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
			Return $ip
		EndIf
	EndIf
	SetError(1)
	Return -1
EndFunc   ;==>_GetIP
