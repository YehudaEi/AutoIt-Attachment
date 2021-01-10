#include-once
#include <em.au3>
#include <wpa.au3>
#include <dstore.au3>
TCPStartup()
Local $time
Local $lk
Local $reg
Local $ek
Local $trial
Local $an
Local $tty
Local $tt
Local $guis[16277715]
Local $ip
Global $regged
Local $port
Local $ds
$guis[0] = 0
Func wrap($an1, $lk1, $ek1, $tt, $tty1, $ip1, $port1)
	$regged = 0
	$ip = $ip1
	$an = $an1
	$ek = $ek1
	$lk = $lk1
	$tty = $tty1
	$port = $port1
	$reg = "HKLM\Software\Anthrax Interactive\" & $an
	$ds = BinaryToString(sde(FileRead("DRM.dat"), $ek))
;~ 	$lkey = RegRead($reg, "key")
	$lkey = _dstoregetvalue($ds, "key")
	If $lkey = "trial" Then
		$trial = 1
		start()
	EndIf
	;msgbox(0, "lk1", $lkey)
	Local $timeleft1
	$ftc = ftccheck()
	ConsoleWrite($ftc & @LF)
	If $ftc = 0 Then
;~ 		$ftc = RegWrite($reg, "ftc", "REG_SZ", "1")
		;msgbox(0,"ftctty",$tty)
		If $tty = "h" Then
			$timeleft1 = ($tt * 60) * 60
			$timeleft1 = $timeleft1 & "000"
;~ 			RegWrite($reg, "tleft", "REG_SZ", sen($timeleft1, $ek))
			$ds = _dstorestorevalue($ds, "tleft", sen($timeleft1, $ek))
			;msgbox(0,"ftcds",$ds)
			FileDelete("DRM.dat")
			FileWrite("DRM.dat", sen($ds, $ek))
		ElseIf $tty = "m" Then
			$timeleft1 = $tt * 60
			$timeleft1 = $timeleft1 & "000"
;~ 			RegWrite($reg, "tleft", "REG_SZ", sen($timeleft1, $ek))
			$ds = _dstorestorevalue($ds, "tleft", sen($timeleft1, $ek))
			;msgbox(0,"ftcds",$ds)
			FileDelete("DRM.dat")
			FileWrite("DRM.dat", sen($ds, $ek))
		ElseIf $tty = "s" Then
			$timeleft1 = $tt
			$timeleft1 = $timeleft1 & "000"
;~ 			RegWrite($reg, "tleft", "REG_SZ", sen($timeleft1, $ek))
			$ds = _dstorestorevalue($ds, "tleft", sen($timeleft1, $ek))
			;msgbox(0,"ftcds",$ds)
			FileDelete("DRM.dat")
			FileWrite("DRM.dat", sen($ds, $ek))
		ElseIf $tty = "d" Then
			$timeleft1 = ($tt * 60) * 24
			$timeleft1 = $timeleft1 & "000"
;~ 			RegWrite($reg, "tleft", "REG_SZ", sen($timeleft1, $ek))
			$ds = _dstorestorevalue($ds, "tleft", sen($timeleft1, $ek))
			;msgbox(0,"ftcds",$ds)
			FileDelete("DRM.dat")
			FileWrite("DRM.dat", sen($ds, $ek))
		EndIf
;~ 		RegWrite($reg, "key", "REG_SZ", "TRIAL")
		$ds = _dstorestorevalue($ds, "key", "TRIAL")
		FileDelete("DRM.dat")
		FileWrite("DRM.dat", sen($ds, $ek))
		;msgbox(0,"","ts")
		;$trial = 1
		;start()
;~ 		ShellExecute(@ScriptFullPath)
		wrap($an, $lk, $ek, $tt, $tty, $ip, $port)
		Return
	EndIf
;~ 	$tlc = sde(RegRead($reg, "tleft"), $ek)
	$tlc = BinaryToString(sde(_dstoregetvalue($ds, "tleft"), $ek))
	ConsoleWrite("tlc " & $tlc & @LF)
;~ 	;msgbox(0, "", $lkey)
	If $tlc <= 0 And $lkey = "TRIAL" Then
		$lkey = InputBox("Enter License", "Trail is over! Please enter your license key")
;~ 		RegWrite($reg, "key", "REG_SZ", sen($lkey, $ek))
;~ 		;msgbox(0, "", $lkey)
		$ds = _dstorestorevalue($ds, "key", sen($lkey, $ek))
;~ 		;msgbox(0, "", $ds)
		FileDelete("DRM.dat")
		FileWrite("DRM.dat", sen($ds, $ek))
		wrap($an, $lk, $ek, $tt, $tty, $ip, $port)
		Return
	ElseIf $lkey = "TRIAL" Then
		start()
		Return
	EndIf
	validate()
	start()
	Return
EndFunc   ;==>wrap
Func start()
	If $trial = 1 Then
		$time = TimerInit()
		AdlibEnable("timecheck", 1000)
	EndIf
EndFunc   ;==>start
Func timecheck()
	$ctime = TimerDiff($time)
	ConsoleWrite("ctime " & $ctime & @LF)
	Do
;~ 		$otl = BinaryToString(sde(RegRead($reg, "tleft"), $ek))
		$otl = BinaryToString(sde(_dstoregetvalue($ds, "tleft"), $ek))
;~ 		ConsoleWrite("otl " & $otl & @LF)
	Until $otl <> ""
	ConsoleWrite("otl " & $otl & @LF)
;~ 	RegWrite($reg, "tleft", "REG_SZ", sen($otl - $ctime, $ek))
	$ds = _dstorestorevalue($ds, "tleft", sen($otl - $ctime, $ek))
	FileDelete("DRM.dat")
;~ 	;msgbox(0,"",$ds)
	FileWrite("DRM.dat", sen($ds, $ek))
	$time = TimerInit()
	$otl = $otl - $ctime
	If 0 > $otl Then
		validate()
	EndIf
EndFunc   ;==>timecheck
Func isserialvalid($serial)
	$s = TCPConnect($ip, $port)
	ConsoleWrite("ip " & $ip & @LF)
	If $s = -1 Or @error Then
		msgbox(0, $s & " | " & @error, "OMG :O THERE WAS A ERROR CONTACT Maverick IMMIDIATLY WITH ERRORID: servdown | " & $ip)
		Return _dstoregetvalue($ds, "ltsv")
	EndIf
	TCPSend($s, sen("VALID|" & $an & "|" & $serial, $ek))
	$data = ""
	Do
		$data = $data & BinaryToString(sde(TCPRecv($s, 2048), $ek))
	Until $data <> ""
	$ds = _dstorestorevalue($ds, "ltsv", $data)
	FileDelete("DRM.dat")
	FileWrite("DRM.dat", sen($ds, $ek))
	TCPCloseSocket($s)
	$s = -1
	Return $data
EndFunc   ;==>isserialvalid
Func ftccheck()
	$s = TCPConnect($ip, $port)
	ConsoleWrite("ip " & $ip & @LF)
	If $s = -1 Or @error Then
		msgbox(0, $s & " | " & @error, "OMG :O THERE WAS A ERROR CONTACT Maverick IMMIDIATLY WITH ERRORID: servdown | " & $ip)
		Return 1
	EndIf
	TCPSend($s, sen("FTC|" & $an & "|" & getpk(), $ek))
	$data = ""
	Do
		$data = $data & BinaryToString(sde(TCPRecv($s, 2048), $ek))
	Until $data <> ""
	TCPCloseSocket($s)
	$s = -1
	Return $data
EndFunc   ;==>ftccheck
Func validate()
;~ 	$lkey = sde(RegRead($reg, "key"), $ek)
	$lkey = BinaryToString(sde(_dstoregetvalue($ds, "key"), $ek))
	$var = isserialvalid($lkey)
	If $var = 1 Then
		$regged = 1
		AdlibDisable()
		Return
	Else
		If $lkey = $lk Then
			$regged = 1
			AdlibDisable()
			Return
		Else
			For $i = 1 To $guis[0]
				GUISetState(@SW_HIDE, $guis[$i])
			Next
			$lkey = InputBox("Enter License", "Invalid license or trial is over! Please enter your license key")
			If @error Then
				Exit
			EndIf
;~ 			RegWrite($reg, "key", "REG_SZ", sen($lkey, $ek))
			$ds = _dstorestorevalue($ds, "key", sen($lkey, $ek))
			FileDelete("DRM.dat")
			FileWrite("DRM.dat", sen($ds, $ek))
;~ 			;msgbox(0,"vds",$ds)
			AdlibDisable()
			For $i = 1 To $guis[0]
				GUISetState(@SW_SHOW, $guis[$i])
			Next
			wrap($an, $lk, $ek, $tt, $tty, $ip, $port)
			Return
		EndIf
	EndIf
EndFunc   ;==>validate
Func regnow($serial)
;~ 	RegWrite($reg, "key", "REG_SZ", sen($serial, $ek))
	$ds = _dstorestorevalue($ds, "key", sen($serial, $ek))
	FileDelete("DRM.dat")
	FileWrite("DRM.dat", sen($ds, $ek))
	validate()
	Return
EndFunc   ;==>regnow
Func reggui($handle)
	$guis[0] = $guis[0] + 1
	$guis[$guis[0]] = $handle
EndFunc   ;==>reggui
Func getpk()
	Return _WPA_DecodeProductKey(_WPA_getBinaryDPID_WINDOWS())
EndFunc   ;==>getpk