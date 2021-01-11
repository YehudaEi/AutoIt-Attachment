#include <GUIConstants.au3>
#include <String.au3>
#NoTrayIcon
opt("TrayMenuMode", 1)


;FileInstall("J:\AutoIt\mail.wav", @ScriptDir & "\mail.wav", 1)
Dim $acc_1[100], $acc_2[100], $acc_3[100], $acc_4[100], $messagecnt[100], $labeln[100], $editbt[100], $delbt[100], $stringtl[100], $indicator[100], $indicator2[100], $msgnew[100], $msgrecount[100]

Global $line = 1, $text, $messagecnt, $text2, $top, $num, $msgedit, $editm, $rt, $mainopt, $error, $rt2, $linecount, $editacc, $reserv, $num2, $number, $msgrcv2, $number2
Global $msgc, $msgrcv = 7, $msgrecount = -1, $text3, $newm

$traymenu3 = TrayCreateItem ("Account & Options")
TrayCreateItem ("")
$traymenu1 = TrayCreateItem ("Check Mail Now")
TrayCreateItem ("")
$traymenu2 = TrayCreateItem ("Close")
TraySetState ()

$pass = InputBox("Master Password", "Enter Master Password:", "", "*M", 200, 120, -1, -1)
If @error = 1 Then Exit

Do
	$linecount = $linecount + 1
	$mfile = FileReadLine(@ScriptDir & "\accounts.ini", $line)
	$stringtr = StringTrimRight($mfile, 1)
	$stringtl[$linecount] = StringTrimLeft($stringtr, 1)
	$line = $line + 5
Until $stringtl[$linecount] = ""
$accountc = (($line - 1) / 5) - 1
$reserv = $accountc
$hightcount = $reserv
$accountc = $reserv
If $accountc = 0 Then addaccount()
$rt = 0

$accountc = $reserv
Do
	$acc_1[$accountc] = IniRead(@ScriptDir & "\accounts.ini", $stringtl[$accountc], "user", "empty")
	$acc_2[$accountc] = IniRead(@ScriptDir & "\accounts.ini", $stringtl[$accountc], "pass", "empty")
	$acc_3[$accountc] = IniRead(@ScriptDir & "\accounts.ini", $stringtl[$accountc], "server", "empty")
	$acc_4[$accountc] = IniRead(@ScriptDir & "\accounts.ini", $stringtl[$accountc], "accountname", "empty")
	$accountc = $accountc - 1
Until $accountc < 1

AdlibEnable("start", 1800000)
Start()

$accountc = $reserv
While 2
	$msg = TrayGetMsg ()
	Select
		Case $msg = $traymenu2
			Exit
		Case $msg = $traymenu1
			If $hightcount < 1 Then addaccount()
			$rt = 0
			Start()
		Case $msg = $traymenu3
			option()
	EndSelect
WEnd

Func Start()
	If $hightcount < 1 Then Return
	$text2 = ""
	$text = ""
	$text3 = ""
	$newm = 0
	$error = 0
	$accountc = $reserv
	If $msgrecount = 2 Then
		$msgrecount = 1
	Else
		$msgrecount = $msgrecount + 1
	EndIf
	Do
		If $acc_1[$accountc] <> "erased" And $acc_2[$accountc] <> "erased" And $acc_3[$accountc] <> "erased" And $acc_4[$accountc] <> "erased" Then
			$messagecnt[$accountc] = _mailchk($acc_3[$accountc], $acc_1[$accountc], _StringEncrypt(0, $acc_2[$accountc], $pass, 5))
		EndIf
		$msgnew[$accountc & $msgrecount] = $messagecnt[$accountc]
		Sleep(1000)
		$accountc = $accountc - 1
	Until $accountc < 1
	If $error = $hightcount Then
		MsgBox(4112, "Wrong Master Password", "Master Password you entered is not valid.")
		$pass = InputBox("Master Password", "Enter Master Password:", "", "*M", 200, 120, -1, -1)
		If @error = 1 Then
			Exit
		Else
			MsgBox(64, "Master Password", "Check e-mail from tray menu.", 15)
			Return
		EndIf
	EndIf
	If $msgrecount < 1 Then
		$text = "You have: " & @CRLF
		$accountc = $reserv
		Do
			If $acc_1[$accountc] <> "erased" And $acc_2[$accountc] <> "erased" And $acc_3[$accountc] <> "erased" And $acc_4[$accountc] <> "erased" Then
				$text2 = $text2 & $messagecnt[$accountc] & "   total message(s) in your " & $acc_4[$accountc] & " account." & @CRLF
			EndIf
			$accountc = $accountc - 1
		Until $accountc < 1
		TrayTip("Total E-mail", $text & $text2, 10)
		SoundPlay(@ScriptDir & "\mail.wav")
	Else
		$text = "You have: " & @CRLF
		$accountc = $reserv
		Do
			If $msgnew[$accountc & (- ($msgrecount - 3)) ] = 0 Then
				$msgnew[$accountc & (- ($msgrecount - 3)) ] = $msgnew[$accountc & $msgrecount]
			EndIf
			If $acc_1[$accountc] <> "erased" And $acc_2[$accountc] <> "erased" And $acc_3[$accountc] <> "erased" And $acc_4[$accountc] <> "erased" Then
				$text2 = $text2 & $msgnew[$accountc & $msgrecount] - $msgnew[$accountc & (- ($msgrecount - 3)) ] & "   NEW message(s) in your " & $acc_4[$accountc] & " account." & @CRLF
			EndIf
			$newm = $newm + ($msgnew[$accountc & $msgrecount] - $msgnew[$accountc & (- ($msgrecount - 3)) ])
			$accountc = $accountc - 1
		Until $accountc < 1
		$accountc = $reserv
		Do
			If $acc_1[$accountc] <> "erased" And $acc_2[$accountc] <> "erased" And $acc_3[$accountc] <> "erased" And $acc_4[$accountc] <> "erased" Then
				$text3 = $text3 & $messagecnt[$accountc] & "   total message(s) in your " & $acc_4[$accountc] & " account." & @CRLF
			EndIf
			$accountc = $accountc - 1
		Until $accountc < 1
		If $newm > 0 Then
			TrayTip("New E-mail", $text & $text2, 10)
			SoundPlay(@ScriptDir & "\mail.wav")
			Sleep(10000)
			TrayTip("", "", 1)
			TrayTip("Total E-mail", $text & $text3, 10)
		Else
			TrayTip("Total E-mail", $text & $text3, 10)
			SoundPlay(@ScriptDir & "\mail.wav")
		EndIf
	EndIf
	Return
EndFunc

Func option()
	If $hightcount < 1 Then addaccount()
	$hight = 40 * $hightcount
	$editm = GUICreate("Edit Accounts", 300, $hight + 80, -1, -1)
	$menu = GUICtrlCreateMenu("Add Account")
	$addmenuacc = GUICtrlCreateMenuItem("Add Account", $menu, 1)
	$changetimer = GUICtrlCreateMenuItem("Check Every...", $menu, 2)
	$top = 0
	$num = 0
	$accountc = $reserv
	$msgrcv = 8
	$msgrcv2 = 7
	Do
		Select
			Case $acc_1[$accountc] <> "erased" And $acc_2[$accountc] <> "erased" And $acc_3[$accountc] <> "erased" And $acc_4[$accountc] <> "erased"
				$top = $top + 40
				$num = $num + 1
				$labeln[$msgrcv] = GUICtrlCreateLabel($num & ".  " & $acc_4[$accountc], 40, $top, 160, 60)
				$indicator[$msgrcv] = $accountc
				$indicator2[$msgrcv2] = $accountc
				$editbt[$msgrcv2] = GUICtrlCreateButton("Edit", 180, $top - 4, 40, 20)
				$delbt[$msgrcv] = GUICtrlCreateButton("Del", 240, $top - 4, 30, 20)
				$msgrcv = $msgrcv + 3
				$msgrcv2 = $msgrcv2 + 3
		EndSelect
		$accountc = $accountc - 1
	Until $accountc < 1
	GUISetState()
	$number = $msgrcv - 3
	$number2 = $msgrcv2 - 3
	While 4
		$msgc = GUIGetMsg()
		Select
			Case $msgc = $GUI_EVENT_CLOSE
				GUIDelete($editm)
				ExitLoop
			Case $msgc = $addmenuacc
				addaccount()
			Case $msgc = $changetimer
				timerchange()
			Case $msgc > 0
				chkmsg()
			Case $rt = 1
				GUIDelete($editacc)
				GUIDelete($editm)
				$rt = 0
				ExitLoop
			Case $rt2 = 1
				GUIDelete($editacc)
				GUIDelete($editm)
				$rt2 = 0
				ExitLoop
		EndSelect
	WEnd
	Return
EndFunc

Func chkmsg()
	$accountc = $reserv
	$msgrcv = $number
	$msgrcv2 = $number2
	Do
		Select
			Case $msgc = $editbt[$msgrcv2]
				$accountc = $indicator2[$msgrcv2]
				GUISetState(@SW_HIDE, $editm)
				$editacc = GUICreate("Edit Account Settings", 280, 230, -1, -1)
				$accname = GUICtrlCreateLabel("Account Name", 20, 20, 100, 40)
				$accnameibox = GUICtrlCreateInput($acc_4[$accountc], 100, 18, 160, 20)
				$accserver = GUICtrlCreateLabel("Account Server", 20, 60, 100, 40)
				$accserveribox = GUICtrlCreateInput($acc_3[$accountc], 100, 58, 160, 20)
				$accuser = GUICtrlCreateLabel("User Name", 20, 100, 100, 40)
				$accuseribox = GUICtrlCreateInput($acc_1[$accountc], 100, 98, 160, 20)
				$accpass = GUICtrlCreateLabel("Password", 20, 140, 100, 40)
				$accpassibox = GUICtrlCreateInput("", 100, 138, 160, 20, $ES_PASSWORD)
				$savebt = GUICtrlCreateButton("Save", 20, 180, 100, 30)
				$saveexitbt = GUICtrlCreateButton("Save and Exit", 160, 180, 100, 30)
				GUISetState()
				While 5
					$msg = GUIGetMsg()
					Select
						Case $msg = $GUI_EVENT_CLOSE
							GUIDelete($editacc)
							GUISetState(@SW_SHOW, $editm)
							Return
						Case $msg = $savebt
							IniDelete(@ScriptDir & "\accounts.ini", $stringtl[$accountc])
							$readname = GUICtrlRead($accnameibox)
							$readserver = GUICtrlRead($accserveribox)
							$readuname = GUICtrlRead($accuseribox)
							$readpass = GUICtrlRead($accpassibox)
							If $readpass = "" Then
								MsgBox(4112, "Empty Password", "Password cannot be empty")
								GUIDelete($editacc)
								GUISetState(@SW_SHOW, $editm)
								Return
							EndIf
							$readpassenc = _StringEncrypt(1, $readpass, $pass, 5)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "accountname", $readname)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "server", $readserver)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "user", $readuname)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "pass", $readpassenc)
							$acc_1[$accountc] = $readuname
							$acc_2[$accountc] = $readpassenc
							$acc_3[$accountc] = $readserver
							$acc_4[$accountc] = $readname
							$stringtl[$accountc] = "MAIL" & $readname
							GUIDelete($editacc)
							GUISetState(@SW_SHOW, $editm)
							Return
						Case $msg = $saveexitbt
							IniDelete(@ScriptDir & "\accounts.ini", $stringtl[$accountc])
							$readname = GUICtrlRead($accnameibox)
							$readserver = GUICtrlRead($accserveribox)
							$readuname = GUICtrlRead($accuseribox)
							$readpass = GUICtrlRead($accpassibox)
							If $readpass = "" Then
								MsgBox(4112, "Empty Password", "Password cannot be empty")
								GUIDelete($editacc)
								GUISetState(@SW_SHOW, $editm)
								Return
							EndIf
							$readpassenc = _StringEncrypt(1, $readpass, $pass, 5)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "accountname", $readname)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "server", $readserver)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "user", $readuname)
							IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "pass", $readpassenc)
							$acc_1[$accountc] = $readuname
							$acc_2[$accountc] = $readpassenc
							$acc_3[$accountc] = $readserver
							$acc_4[$accountc] = $readname
							$stringtl[$accountc] = "MAIL" & $readname
							GUIDelete($editacc)
							GUIDelete($editm)
							GUIDelete($mainopt)
							$rt = 1
							Return
					EndSelect
				WEnd
			Case $msgc = $delbt[$msgrcv]
				$accountc = $indicator[$msgrcv]
				If $acc_1[$accountc] <> "erased" And $acc_2[$accountc] <> "erased" And $acc_3[$accountc] <> "erased" And $acc_4[$accountc] <> "erased" Then
					IniDelete(@ScriptDir & "\accounts.ini", $stringtl[$accountc])
					$acc_1[$accountc] = "erased"
					$acc_2[$accountc] = "erased"
					$acc_3[$accountc] = "erased"
					$acc_4[$accountc] = "erased"
					$stringtl[$accountc] = "erased"
					$hightcount = $hightcount - 1
				EndIf
				GUIDelete($editacc)
				GUIDelete($editm)
				option()
				$rt2 = 1
				ExitLoop
		EndSelect
		$msgrcv = $msgrcv - 3
		$msgrcv2 = $msgrcv2 - 3
		$accountc = $accountc - 1
	Until $accountc < 1
	Return
EndFunc

Func addaccount()
	GUISetState(@SW_HIDE, $editm)
	$editacc = GUICreate("Add Account", 280, 230, -1, -1)
	$accname = GUICtrlCreateLabel("Account Name", 20, 20, 100, 40)
	$accnameibox = GUICtrlCreateInput("", 100, 18, 160, 20)
	$accserver = GUICtrlCreateLabel("Account Server", 20, 60, 100, 40)
	$accserveribox = GUICtrlCreateInput("", 100, 58, 160, 20)
	$accuser = GUICtrlCreateLabel("User Name", 20, 100, 100, 40)
	$accuseribox = GUICtrlCreateInput("", 100, 98, 160, 20)
	$accpass = GUICtrlCreateLabel("Password", 20, 140, 100, 40)
	$accpassibox = GUICtrlCreateInput("", 100, 138, 160, 20, $ES_PASSWORD)
	$addsavebt = GUICtrlCreateButton("Save", 20, 180, 100, 30)
	$addsaveexitbt = GUICtrlCreateButton("Save and Exit", 160, 180, 100, 30)
	GUISetState()
	While 6
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				GUIDelete($editacc)
				If $hightcount > 0 Then
					GUISetState(@SW_SHOW, $editm)
					Return
				Else
					GUIDelete($editm)
					Return
				EndIf
			Case $msg = $addsavebt
				$readname = GUICtrlRead($accnameibox)
				$readserver = GUICtrlRead($accserveribox)
				$readuname = GUICtrlRead($accuseribox)
				$readpass = GUICtrlRead($accpassibox)
				If $readpass = "" Then
					MsgBox(4112, "Empty Password", "Password cannot be empty")
					GUIDelete($editacc)
					GUISetState(@SW_SHOW, $editm)
					Return
				EndIf
				$readpassenc = _StringEncrypt(1, $readpass, $pass, 5)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "accountname", $readname)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "server", $readserver)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "user", $readuname)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "pass", $readpassenc)
				$acc_1[$reserv + 1] = $readuname
				$acc_2[$reserv + 1] = $readpassenc
				$acc_3[$reserv + 1] = $readserver
				$acc_4[$reserv + 1] = $readname
				$stringtl[$reserv + 1] = "MAIL" & $readname
				GUIDelete($editacc)
				GUIDelete($editm)
				$reserv = $reserv + 1
				$hightcount = $hightcount + 1
				option()
				$rt = 1
				Return
			Case $msg = $addsaveexitbt
				$readname = GUICtrlRead($accnameibox)
				$readserver = GUICtrlRead($accserveribox)
				$readuname = GUICtrlRead($accuseribox)
				$readpass = GUICtrlRead($accpassibox)
				If $readpass = "" Then
					MsgBox(4112, "Empty Password", "Password cannot be empty")
					GUIDelete($editacc)
					GUISetState(@SW_SHOW, $editm)
					Return
				EndIf
				$readpassenc = _StringEncrypt(1, $readpass, $pass, 5)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "accountname", $readname)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "server", $readserver)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "user", $readuname)
				IniWrite(@ScriptDir & "\accounts.ini", "MAIL" & $readname, "pass", $readpassenc)
				$acc_1[$reserv + 1] = $readuname
				$acc_2[$reserv + 1] = $readpassenc
				$acc_3[$reserv + 1] = $readserver
				$acc_4[$reserv + 1] = $readname
				$stringtl[$reserv + 1] = "MAIL" & $readname
				GUIDelete($editacc)
				GUIDelete($editm)
				$rt = 1
				$reserv = $reserv + 1
				$hightcount = $hightcount + 1
				Return
		EndSelect
	WEnd
EndFunc

Func timerchange()
	AdlibDisable()
	GUISetState(@SW_HIDE, $editm)
	$timeenter = InputBox("Check Every...", "Enter Time in Minutes:", "30", "", 200, 120, -1, -1)
	If @error = 1 Or $timeenter = "" Then
		GUISetState(@SW_SHOW, $editm)
		AdlibEnable("Start", 30 * 60000)
		Return
	EndIf
	AdlibEnable("Start", $timeenter * 60000)
	GUISetState(@SW_SHOW, $editm)
	Return
EndFunc
;-------------------------------------------------------------------------------------------------------------------------
Func _mailchk($popsrv, $srvuser, $srvpass)
	
	Global $mail, $i, $disp, $recv, $str, $count, $check, $str1, $err, $recpoint, $bit, $mcount, $recpoint1, $error
	
	
	TCPStartup ()
	
	Global $socket = TCPConnect (TCPNameToIP ($popsrv), 110)
	If $socket = -1 Then
		MsgBox(8240, 'Error', 'Error; could not connect to server ' & $popsrv, 5)
		Return
	EndIf
	
	Do
		$recv = TCPRecv ($socket, 512)
	Until $recv <> ""
	$recv = ""
	
	TCPSend ($socket, "user " & $srvuser & @CRLF)
	
	Do
		$recv = TCPRecv ($socket, 512)
	Until $recv <> ""
	$recv = ""
	
	
	TCPSend ($socket, "pass " & $srvpass & @CRLF)
	
	Do
		$recv = TCPRecv ($socket, 512)
	Until $recv <> ""
	$err = StringInStr($recv, "-ERR")
	If $err > 0 Then
		MsgBox(4112, "authentication failed", "Invalid User Name or Password for " & $popsrv, 8)
		TCPSend ($socket, 'quit' & @CRLF)
		TCPCloseSocket ($socket)
		$error = $error + 1
		Return
	EndIf
	$recv = ""
	
	
	TCPSend ($socket, 'list' & @CRLF)
	Do
		$recv = TCPRecv ($socket, 10240)
		$recpoint = StringInStr($recv, ".")
		Sleep(1000)
	Until $recpoint > 0
	
	$str = StringSplit($recv, @LF)
	$str1 = StringSplit($str[1], " ")
	$check = StringIsDigit($str1[1])
	If $check = 1 Then
		$count = 0
		$bit = 0
	Else
		$count = 1
		$bit = 1
	EndIf
	
	Do
		$count = $count + 1
		$str1 = StringSplit($str[$count], " ")
		$check = StringIsDigit($str1[1])
	Until $check = 0
	If $bit = 1 Then
		$mcount = $count - 2
	Else
		$mcount = $count - 1
	EndIf
	
	TCPSend ($socket, 'quit' & @CRLF)
	TCPCloseSocket ($socket)
	
	Return $mcount
EndFunc