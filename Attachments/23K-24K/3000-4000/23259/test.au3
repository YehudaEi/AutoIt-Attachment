#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_Icon=Email.ico
#AutoIt3Wrapper_Outfile=AutoMP.exe
#AutoIt3Wrapper_Run_Au3check=n
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GuiButton.au3>
#include <INet.au3>
#include <GuiConstantsEx.au3>
#include <String.au3>
#include <array.au3>
#include <GuiListBox.au3>
#include <EditConstants.au3>
#include <Timers.au3>
Global $recieved, $recieved2, $recieved3, $button, $button2, $button3, $AddNick, $input1, $input2, $list, $edit1, $Cookies, $List1, $input3, $button4, $diff, $contagem
_Main()
MyFunc()
MyFunc2()
Func _Main()
	$hexxx = "00901aa045ff001e8c52d786886411001a1302940021450002922c6d40008006f5c0c95f4af3c862f982d6650050fd15c768cb88ff555018fd20b3880000474554202f74656d706c617465732f756f6c2f756f6c6a6f676f732e63737320485454502f312e310d0a557365722d4167656e743a204d6f7a696c6c612f352e30202857696e646f77733b20553b2057696e646f7773204e5420362e303b20656e2d555329204170706c655765624b69742f3532352e313920284b48544d4c2c206c696b65204765636b6f29204368726f6d652f302e332e3135342e39205361666172692f3532352e31390d0a526566657265723a20687474703a2f2f666f72756d2e6a6f676f732e756f6c2e636f6d2e62722f0d0a4163636570743a20746578742f6373732c2a2f2a3b713d302e310d0a436f6f6b69653a20554f4c5f5649533d417c3230312e39352e37342e3234337c313232373636373436352e3336383138387c3b20756f6c6a6f676f735f646174613d61253341302533412537422537443b20756f6c6a6f676f735f7369643d39303634663766363064333564656163386633386133346136663962396439660d0a4163636570742d4c616e67756167653a2070742d42522c70742c656e2d55532c656e0d0a4163636570742d436861727365743a2049534f2d383835392d312c2a2c7574662d380d0a4163636570742d456e636f64696e673a20677a69702c6465666c6174652c627a6970320d0a49662d4e6f6e652d4d617463683a2022316361622d6335663564346330220d0a49662d4d6f6469666965642d53696e63653a205468752c2030382046656220323030372031373a35373a313520474d540d0a486f73743a20666f72756d2e6a6f676f732e756f6c2e636f6d2e62720d0a436f6e6e656374696f6e3a204b6565702d416c6976650d0a0d0a"
	$hexxx = _HexToString($hexxx)
	TCPStartup()
	$ConnectedSocket2 = TCPConnect("200.98.249.130", 80)
	TCPSend($ConnectedSocket2, $hexxx)
	While $recieved = ""
		$recieved = TCPRecv($ConnectedSocket2, 100000)
		
		If $recieved <> "" Then
			$sid = _StringBetween($recieved, "sid", '"', -1, 1)
			$sid = _ArrayToString($sid, "", "1", "1")
			$sid = _StringToHex($sid)
			TCPShutdown()
		EndIf
	WEnd
	$Form2 = GUICreate("Login", 230, 216, 451, 314)
	$Input4 = GUICtrlCreateInput("", 56, 48, 121, 21)
	$Input5 = GUICtrlCreateInput("", 56, 104, 121, 21, $ES_PASSWORD)
	$button4 = GUICtrlCreateButton("Login", 72, 160, 75, 25, 0)
	$Label3 = GUICtrlCreateLabel("Usuário:", 56, 28, 43, 17)
	$Label4 = GUICtrlCreateLabel("Senha:", 56, 84, 38, 17)
	GUISetState()
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $button4
				$usuario = GUICtrlRead($Input4)
				$senha = GUICtrlRead($Input5)
				ExitLoop
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
	WEnd
	_GUICtrlButton_Enable($button4, False)
	$usuario = RegularExpression($usuario)
	$count1 = StringLen($usuario)
	$usuario = _StringToHex($usuario)
	$senha = RegularExpression($senha)
	$count2 = StringLen($senha)
	$senha = _StringToHex($senha)
	$charcount = 55 + $count1 + $count2
	$hexx = "504f5354202f6c6f67696e2e70687020485454502f312e310d0a557365722d4167656e743a204d6f7a696c6c612f352e30202857696e646f77733b20553b2057696e646f7773204e5420362e303b20656e2d555329204170706c655765624b69742f3532352e313920284b48544d4c2c206c696b65204765636b6f29204368726f6d652f302e332e3135342e39205361666172692f3532352e31390d0a526566657265723a20687474703a2f2f666f72756d2e6a6f676f732e756f6c2e636f6d2e62722f696e6465782e7068703f736964" & $sid & "0d0a43616368652d436f6e74726f6c3a206d61782d6167653d300d0a436f6e74656e742d547970653a206170706c69636174696f6e2f782d7777772d666f726d2d75726c656e636f6465640d0a4163636570743a20746578742f786d6c2c6170706c69636174696f6e2f786d6c2c6170706c69636174696f6e2f7868746d6c2b786d6c2c746578742f68746d6c3b713d302e392c746578742f706c61696e3b713d302e382c696d6167652f706e672c2a2f2a3b713d302e350d0a4163636570742d4c616e67756167653a2070742d42522c70742c656e2d55532c656e0d0a4163636570742d436861727365743a2049534f2d383835392d312c2a2c7574662d380d0a4163636570742d456e636f64696e673a20677a69702c6465666c6174652c627a6970320d0a486f73743a20666f72756d2e6a6f676f732e756f6c2e636f6d2e62720d0a436f6e74656e742d4c656e6774683a2038340d0a436f6e6e656374696f6e3a204b6565702d416c6976650d0a0d0a757365726e616d653d" & $usuario & "2670617373776f72643d" & $senha & "266175746f6c6f67696e3d6f6e266c6f67696e3d456e7472617226783d323826793d3131"
	$hexx = _HexToString($hexx)
	$hexx = StringRegExpReplace($hexx, "84", $charcount)
	TCPStartup()
	$ConnectedSocket3 = TCPConnect("200.98.249.130", 80)
	TCPSend($ConnectedSocket3, $hexx)
	While $recieved2 = ""
		$recieved2 = TCPRecv($ConnectedSocket3, 100000)
		If $recieved2 <> "" Then
			$recieved2 = StringRegExpReplace($recieved2, "0x", "")
			$recieved2 = _HexToString($recieved2)
			$ok = StringRegExp($recieved2, "Found")
			If $ok = 0 Then
				MsgBox(0, "Erro", "Usuário/Senha incorreto")
				TCPShutdown()
				GUIDelete()
				Exit
			EndIf
			$CookieVIS = _StringBetween($recieved2, "UOL_VIS=A", ";")
			$CookieVIS = _ArrayToString($CookieVIS)
			$CookieVIS = "UOL_VIS=B" & $CookieVIS & ";"
			$CookieData = _StringBetween($recieved2, "uoljogos_data=", ";")
			$CookieData = _ArrayToString($CookieData)
			$CookieData = "uoljogos_data=" & $CookieData & ";"
			$CookieSid = _StringBetween($recieved2, "uoljogos_sid=", ";")
			$CookieSid = _ArrayToString($CookieSid, "", 1, 1)
			$CookieSid = "uoljogos_sid=" & $CookieSid
			$Cookies = $CookieVIS & " " & $CookieData & " " & $CookieSid
			$Cookies = _StringToHex($Cookies)
			TCPShutdown()
		EndIf
	WEnd
	GUIDelete($Form2)
EndFunc   ;==>_Main
Func MyFunc()
	$Form1 = GUICreate("AutoMP", 767, 490, 377, 323)
	$input1 = GUICtrlCreateInput("", 72, 30, 161, 21)
	$input2 = GUICtrlCreateInput("", 72, 80, 257, 21)
	$input3 = GUICtrlCreateInput("", 72, 125, 350, 21)
	$edit1 = GUICtrlCreateEdit("", 72, 178, 393, 261)
	$AddNick = GUICtrlCreateButton("AddNick", 256, 33, 51, 17, 0)
	$button2 = GUICtrlCreateButton("AddNicks", 352, 83, 59, 17, 0)
	$button3 = GUICtrlCreateButton("Enviar MPs", 600, 398, 83, 33, 0)
	$button4 = GUICtrlCreateButton("Apagar Nick", 600, 258, 83, 33)
	$List1 = GUICtrlCreateList("", 560, 56, 161, 188)
	$label1 = GUICtrlCreateLabel("Nicks para enviar MP:", 560, 32, 125, 17)
	$label2 = GUICtrlCreateLabel("Enviar para:", 72, 11, 61, 17)
	$Label3 = GUICtrlCreateLabel("Enviar para usuários do tópico:", 72, 62, 150, 17)
	$Label4 = GUICtrlCreateLabel("Assunto:", 72, 108, 45, 17)
	$label5 = GUICtrlCreateLabel("Mensagem:", 72, 158, 59, 17)
	GUISetState(@SW_SHOW)
	Call("Check")
EndFunc   ;==>MyFunc
Func Check()
	While 1
		AdlibDisable()
		$msg = GUIGetMsg()
		Select
			
			Case $msg = $AddNick
				$value = GUICtrlRead($input1)
				GuiListAdd($value)
			Case $msg = $button2
				$dado = GUICtrlRead($input2)
				TopicoNicks($dado)
			Case $msg = $button3
				Call("MyFunc2")
			Case $msg = $button4
				$string = _GUICtrlListBox_GetCurSel($List1)
				_GUICtrlListBox_DeleteString($List1, $string)
			Case $msg = $GUI_EVENT_CLOSE
				GUIDelete()
				Exit
		EndSelect
	WEnd
EndFunc   ;==>Check
Func MyFunc2()
	MsgBox(0, "a", "Começo da Func2")
	AdlibEnable("Check2", 50)
	$username = _GUICtrlListBox_GetText($List1, 0)
	If $username == 0 Then
		Call("Check")
	EndIf
	_GUICtrlListBox_DeleteString($List1, 0)
	MsgBox(0, "a", "Final de deletar string")
	$username = RegularExpression($username)
	$Contador = StringLen($username)
	$username = _StringToHex($username)
	$subject = GUICtrlRead($input3)
	$subject = RegularExpression($subject)
	$Contador2 = StringLen($subject)
	$subject = _StringToHex($subject)
	$message = GUICtrlRead($edit1)
	$message = RegularExpression($message)
	$Contador3 = StringLen($message)
	$message = _StringToHex($message)
	$hex = "504f5354202f707269766d73672e70687020485454502f312e310d0a557365722d4167656e743a204d6f7a696c6c612f352e30202857696e646f77733b20553b2057696e646f7773204e5420362e303b20656e2d555329204170706c655765624b69742f3532352e313920284b48544d4c2c206c696b65204765636b6f29204368726f6d652f302e332e3135342e39205361666172692f3532352e31390d0a526566657265723a20687474703a2f2f666f72756d2e6a6f676f732e756f6c2e636f6d2e62722f707269766d73672e7068703f6d6f64653d706f73740d0a43616368652d436f6e74726f6c3a206d61782d6167653d300d0a436f6e74656e742d547970653a206170706c69636174696f6e2f782d7777772d666f726d2d75726c656e636f6465640d0a4163636570743a20746578742f786d6c2c6170706c69636174696f6e2f786d6c2c6170706c69636174696f6e2f7868746d6c2b786d6c2c746578742f68746d6c3b713d302e392c746578742f706c61696e3b713d302e382c696d6167652f706e672c2a2f2a3b713d302e350d0a436f6f6b69653a20" & $Cookies & "0d0a4163636570742d4c616e67756167653a2070742d42522c70742c656e2d55532c656e0d0a4163636570742d436861727365743a2049534f2d383835392d312c2a2c7574662d380d0a4163636570742d456e636f64696e673a20677a69702c6465666c6174652c627a6970320d0a486f73743a20666f72756d2e6a6f676f732e756f6c2e636f6d2e62720d0a436f6e74656e742d4c656e6774683a203236320d0a436f6e6e656374696f6e3a204b6565702d416c6976650d0a0d0a757365726e616d653d" & $username & "26757365727375626d69743d456e636f6e747261722b75737525453172696f267375626a6563743d" & $subject & "266164646262636f646531383d2532333434343434342b2b2b2b266164646262636f646532303d31322668656c70626f783d466f6e74652533412b25354273697a65253344782d736d616c6c253544746578746f2b70657175656e6f25354225324673697a65253544266d6573736167653d" & $message & "26666f6c6465723d696e626f78266d6f64653d706f737426706f73743d454e56494152"
	$hex = _HexToString($hex)
	$numerofinal = 198 + $Contador + $Contador2 + $Contador3
	$hex = StringRegExpReplace($hex, "262", $numerofinal)
	TCPStartup()
	$ConnectedSocket = TCPConnect("200.98.249.130", 80)
	TCPSend($ConnectedSocket, $hex)
	While $recieved3 = ""
		$recieved3 = TCPRecv($ConnectedSocket, 100000)
		If $recieved3 <> "" Then
			FileWrite("information.txt", $recieved3)
			$recieve3 = ""
			TCPShutdown()
		EndIf
	WEnd
	$mensagem = GUICtrlCreateLabel("Mensagem Enviada", 650, 450)
	$i = TimerInit()
	While $diff < 58000
		GUICtrlDelete($contagem)
		$diff = TimerDiff($i)
		$time = 60000 - $diff
		$time = $time / 1000
		$time = Int($time)
		$contagem = GUICtrlCreateLabel($time, 40, 450)
		If $time = 57 Then
			GUICtrlDelete($mensagem)
		EndIf
		Sleep(1000)
	WEnd
	GUICtrlDelete($contagem)
	Call("MyFunc2")
EndFunc   ;==>MyFunc2
Func RegularExpression($var1)
	$var1 = StringRegExpReplace($var1, "%", "%25")
	$var1 = StringRegExpReplace($var1, "\+", "%2B")
	$var1 = StringRegExpReplace($var1, "=", "%3D")
	$var1 = StringRegExpReplace($var1, "\[", "%5B")
	$var1 = StringRegExpReplace($var1, "{", "%7B")
	$var1 = StringRegExpReplace($var1, "}", "%7D")
	$var1 = StringRegExpReplace($var1, "]", "%5D")
	$var1 = StringRegExpReplace($var1, "\?", "%3F")
	$var1 = StringRegExpReplace($var1, "/", "%2F")
	$var1 = StringRegExpReplace($var1, ":", "%3A")
	$var1 = StringRegExpReplace($var1, ">", "%3E")
	$var1 = StringRegExpReplace($var1, ",", "%2C")
	$var1 = StringRegExpReplace($var1, "<", "%3C")
	$var1 = StringRegExpReplace($var1, "\\", "%5C")
	$var1 = StringRegExpReplace($var1, "\|", "%7C")
	$var1 = StringRegExpReplace($var1, "'", "%27")
	$var1 = StringRegExpReplace($var1, '"', "%22")
	$var1 = StringRegExpReplace($var1, "!", "%21")
	$var1 = StringRegExpReplace($var1, "\(", "%28")
	$var1 = StringRegExpReplace($var1, "\)", "%29")
	$var1 = StringRegExpReplace($var1, "@", "%40")
	$var1 = StringRegExpReplace($var1, "#", "%23")
	$var1 = StringRegExpReplace($var1, "\$", "%24")
	$var1 = StringRegExpReplace($var1, "&", "%26")
	$var1 = StringRegExpReplace($var1, "à", "%E0")
	$var1 = StringRegExpReplace($var1, "á", "%E1")
	$var1 = StringRegExpReplace($var1, "â", "%E2")
	$var1 = StringRegExpReplace($var1, "ã", "%E3")
	$var1 = StringRegExpReplace($var1, "é", "%E9")
	$var1 = StringRegExpReplace($var1, "ê", "%EA")
	$var1 = StringRegExpReplace($var1, "í", "%ED")
	$var1 = StringRegExpReplace($var1, "ó", "%F3")
	$var1 = StringRegExpReplace($var1, "ô", "%F4")
	$var1 = StringRegExpReplace($var1, "õ", "%F5")
	$var1 = StringRegExpReplace($var1, "ç", "%E7")
	$var1 = StringRegExpReplace($var1, " ", "+")
	$var1 = StringRegExpReplace($var1, "\r\n", "%0D%0A")
	Return $var1
EndFunc   ;==>RegularExpression
Func TopicoNicks($var2)
	$source = _INetGetSource($var2)
	$nicks = _StringBetween($source, "></a><b>", '</b></span><span class="postdetails">')
	$nicks = _ArrayUnique($nicks)
	$number = UBound($nicks)
	If $number >= 2 Then
		$nick1 = $nicks[1]
		GuiListAdd($nick1)
	EndIf
	If $number >= 3 Then
		$nick2 = $nicks[2]
		GuiListAdd($nick2)
	EndIf
	If $number >= 4 Then
		$nick3 = $nicks[3]
		GuiListAdd($nick3)
	EndIf
	If $number >= 5 Then
		$nick4 = $nicks[4]
		GuiListAdd($nick4)
	EndIf
	If $number >= 6 Then
		$nick5 = $nicks[5]
		GuiListAdd($nick5)
	EndIf
	If $number >= 7 Then
		$nick6 = $nicks[6]
		GuiListAdd($nick6)
	EndIf
	If $number >= 8 Then
		$nick7 = $nicks[7]
		GuiListAdd($nick7)
	EndIf
	If $number >= 9 Then
		$nick8 = $nicks[8]
		GuiListAdd($nick8)
	EndIf
	If $number >= 10 Then
		$nick9 = $nicks[9]
		GuiListAdd($nick9)
	EndIf
	If $number >= 11 Then
		$nick10 = $nicks[10]
		GuiListAdd($nick10)
	EndIf
	If $number >= 12 Then
		$nick11 = $nicks[11]
		GuiListAdd($nick11)
	EndIf
	If $number >= 13 Then
		$nick12 = $nicks[12]
		GuiListAdd($nick12)
	EndIf
	If $number >= 14 Then
		$nick13 = $nicks[13]
		GuiListAdd($nick13)
	EndIf
	If $number >= 15 Then
		$nick14 = $nicks[14]
		GuiListAdd($nick14)
	EndIf
	If $number = 16 Then
		$nick15 = $nicks[15]
		GuiListAdd($nick15)
	EndIf
EndFunc   ;==>TopicoNicks
Func GuiListAdd($var3)
	GUICtrlSetData($List1, $var3)
EndFunc   ;==>GuiListAdd
Func Check2()
	$msg = GUIGetMsg()
	Select
		
		Case $msg = $AddNick
			$value = GUICtrlRead($input1)
			GuiListAdd($value)
		Case $msg = $button2
			$dado = GUICtrlRead($input2)
			TopicoNicks($dado)
		Case $msg = $button4
			$string = _GUICtrlListBox_GetCurSel($List1)
			_GUICtrlListBox_DeleteString($List1, $string)
		Case $msg = $GUI_EVENT_CLOSE
			GUIDelete()
			Exit
	EndSelect
EndFunc   ;==>Check2