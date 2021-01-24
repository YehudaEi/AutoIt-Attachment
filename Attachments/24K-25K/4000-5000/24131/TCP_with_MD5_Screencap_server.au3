#include <ScreenCapture.au3>

Opt("TCPTimeout", 5000) ; set timeout value

Global $connect = -1, $socket = -1, $recv, $send_ip
Global $exit = Binary("0xFFFF"), $capture = Binary("0x0001")
Global $enc_key

TraySetToolTip("TCP Screencap Server")

TCPStartup()
$socket = TCPListen("0.0.0.0", 50000)
If @error Then
	MsgBox(0, "Connect Error", "Error code:  " & @error)
	_CloseSockets()
	Exit
EndIf

While 1
	Do
		$connect = TCPAccept($socket)
	Until $connect <> -1
	
	If _Auth() Then
		While 1
			; receive command
			$command = TCPRecv($connect, 2, 1) ; binary receive
			If @error Then ExitLoop
			Switch $command
				Case $exit
					_Exit()
				Case $capture
					_Capture()
					ExitLoop
				Case Else
					ExitLoop
			EndSwitch
		WEnd
	EndIf
	If $connect <> -1 Then _CloseConnect()
WEnd

Func _Auth()
	Local $ret = False
	Local $authfile = @ScriptDir & "\tcp_key.bin"
	If Not FileExists($authfile) Then Return False
	Local $h = FileOpen($authfile, 16) ; open binary read
	$enc_key = FileRead($h)
	FileClose($h)
	Local $keysize = BinaryLen($enc_key)
	
	; receive encrypted key
	Local $recv = TCPRecv($connect, $keysize, 1)
	If Not @error Then
		; decrypt data
		$recv = _RC4($recv, $enc_key)
		If $recv == $enc_key Then
			; send confirmation
			TCPSend($connect, Binary("0x01"))
			$ret = True
		Else
			; send failure packet
			TCPSend($connect, Binary("0x00"))
		EndIf
	EndIf
	
	Return $ret
EndFunc

Func _Capture()
	Local $file = @TempDir & "\screencap.jpg", $hFile, $size, $bytesent = 0
	Local $buff, $data
	Local $buffsize = 2032 ; buffsize = 2048 (receive size) - 16 bytes MD5 data
	
	; send $cap to client
	If FileExists($file) Then FileDelete($file)
	_ScreenCapture_SetJPGQuality(80)
	_ScreenCapture_Capture($file)
	$size = FileGetSize($file)
	$hFile = FileOpen($file, 16) ; open binary read
	
	While $bytesent < $size
		$buff = FileRead($hFile, $buffsize)
		$data = _RC4(_MD5($buff) + $buff, $enc_key)
		; send data: MD5 + file data
		TCPSend($connect, $data)
		If @error Then ExitLoop
		$bytesent += $buffsize
	WEnd
	FileClose($hFile)
	FileDelete($file)
EndFunc

Func _CloseConnect()
	TCPCloseSocket($connect)
	$connect = -1
EndFunc

Func _CloseSockets()
	If $connect <> -1 Then TCPCloseSocket($connect)
	If $socket <> -1 Then TCPCloseSocket($socket)
	$connect = -1
	$socket = -1
EndFunc

; by Ward
Func _MD5($Data)
	Local	$_MD5Opcode = '0xC85800005356576A006A006A008D45A850E8280000006A00FF750CFF75088D45A850E8440000006A006A008D45A850FF7510E8710700005F5E5BC9C210005589E58B4D0831C0894114894110C70101234567C7410489ABCDEFC74108FEDCBA98C7410C765432105DC21000C80C0000538B5D088B4310C1E80383E03F8945F88B4510C1E0030143103943107303FF43148B4510C1E81D0143146A40582B45F88945F4394510724550FF750C8B45F88D44031850E8A00700008D43185053E84E0000008B45F48945FC8B45FC83C03F39451076138B450C0345FC5053E8300000008345FC40EBE28365F800EB048365FC008B45102B45FC508B450C0345FC508B45F88D44031850E84D0700005BC9C21000C84000005356576A40FF750C8D45C050E8330700008B45088B088B50048B70088B780C89D021F089D3F7D321FB09D801C1034DC081C178A46AD7C1C10701D189C821D089CBF7D321F309D801C7037DC481C756B7C7E8C1C70C01CF89F821C889FBF7D321D309D801C60375C881C6DB702024C1C61101FE89F021F889F3F7D321CB09D801C20355CC81C2EECEBDC1C1C21601F289D021F089D3F7D321FB09D801C1034DD081C1AF0F7CF5C1C10701D189C821D089CBF7D321F309D801C7037DD481C72AC68747C1C70C01CF89F821C889FBF7D321D309D801C60375D881C6134630A8C1C61101FE89F021F889F3F7D321CB09D801C20355DC81C2019546FDC1C21601F289D021F089D3F7D321FB09D801C1034DE081C1D8988069C1C10701D189C821D089CBF7D321F309D801C7037DE481C7AFF7448BC1C70C01CF89F821C889FBF7D321D309D801C60375E881C6B15BFFFFC1C61101FE89F021F889F3F7D321CB09D801C20355EC81C2BED75C89C1C21601F289D021F089D3F7D321FB09D801C1034DF081C12211906BC1C10701D189C821D089CBF7D321F309D801C7037DF481C7937198FDC1C70C01CF89F821C889FBF7D321D309D801C60375F881C68E4379A6C1C61101FE89F021F889F3F7D321CB09D801C20355FC81C22108B449C1C21601F289D021F889FBF7D321F309D801C1034DC481C162251EF6C1C10501D189C821F089F3F7D321D309D801C7037DD881C740B340C0C1C70901CF89F821D089D3F7D321CB09D801C60375EC81C6515A5E26C1C60E01FE89F021C889CBF7D321FB09D801C20355C081C2AAC7B6E9C1C21401F289D021F889FBF7D321F309D801C1034DD481C15D102FD6C1C10501D189C821F089F3F7D321D309D801C7037DE881C753144402C1C70901CF89F821D089D3F7D321CB09D801C60375FC81C681E6A1D8C1C60E01FE89F021C889CBF7D321FB09D801C20355D081C2C8FBD3E7C1C21401F289D021F889FBF7D321F309D801C1034DE481C1E6CDE121C1C10501D189C821F089F3F7D321D309D801C7037D'
			$_MD5Opcode &= 'F881C7D60737C3C1C70901CF89F821D089D3F7D321CB09D801C60375CC81C6870DD5F4C1C60E01FE89F021C889CBF7D321FB09D801C20355E081C2ED145A45C1C21401F289D021F889FBF7D321F309D801C1034DF481C105E9E3A9C1C10501D189C821F089F3F7D321D309D801C7037DC881C7F8A3EFFCC1C70901CF89F821D089D3F7D321CB09D801C60375DC81C6D9026F67C1C60E01FE89F021C889CBF7D321FB09D801C20355F081C28A4C2A8DC1C21401F289D031F031F801C1034DD481C14239FAFFC1C10401D189C831D031F001C7037DE081C781F67187C1C70B01CF89F831C831D001C60375EC81C622619D6DC1C61001FE89F031F831C801C20355F881C20C38E5FDC1C21701F289D031F031F801C1034DC481C144EABEA4C1C10401D189C831D031F001C7037DD081C7A9CFDE4BC1C70B01CF89F831C831D001C60375DC81C6604BBBF6C1C61001FE89F031F831C801C20355E881C270BCBFBEC1C21701F289D031F031F801C1034DF481C1C67E9B28C1C10401D189C831D031F001C7037DC081C7FA27A1EAC1C70B01CF89F831C831D001C60375CC81C68530EFD4C1C61001FE89F031F831C801C20355D881C2051D8804C1C21701F289D031F031F801C1034DE481C139D0D4D9C1C10401D189C831D031F001C7037DF081C7E599DBE6C1C70B01CF89F831C831D001C60375FC81C6F87CA21FC1C61001FE89F031F831C801C20355C881C26556ACC4C1C21701F289F8F7D009D031F001C1034DC081C1442229F4C1C10601D189F0F7D009C831D001C7037DDC81C797FF2A43C1C70A01CF89D0F7D009F831C801C60375F881C6A72394ABC1C60F01FE89C8F7D009F031F801C20355D481C239A093FCC1C21501F289F8F7D009D031F001C1034DF081C1C3595B65C1C10601D189F0F7D009C831D001C7037DCC81C792CC0C8FC1C70A01CF89D0F7D009F831C801C60375E881C67DF4EFFFC1C60F01FE89C8F7D009F031F801C20355C481C2D15D8485C1C21501F289F8F7D009D031F001C1034DE081C14F7EA86FC1C10601D189F0F7D009C831D001C7037DFC81C7E0E62CFEC1C70A01CF89D0F7D009F831C801C60375D881C6144301A3C1C60F01FE89C8F7D009F031F801C20355F481C2A111084EC1C21501F289F8F7D009D031F001C1034DD081C1827E53F7C1C10601D189F0F7D009C831D001C7037DEC81C735F23ABDC1C70A01CF89D0F7D009F831C801C60375C881C6BBD2D72AC1C60F01FE89C8F7D009F031F801C20355E481C291D386EBC1C21501F28B4508010801500401700801780C5F5E5BC9C20800C814000053E840000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008F45EC8B5D0C6A088D4310508D'
			$_MD5Opcode &= '45F850E8510000008B4310C1E80383E03F8945F483F838730B6A38582B45F48945F0EB096A78582B45F48945F0FF75F0FF75ECFF750CE831F8FFFF6A088D45F850FF750CE823F8FFFF6A1053FF7508E8050000005BC9C210005589E55156578B7D088B750C8B4D10FCF3A45F5E595DC20C00'

	Local $CodeBuffer = DllStructCreate("byte[" & BinaryLen($_MD5Opcode) & "]")
	DllStructSetData($CodeBuffer, 1, $_MD5Opcode)

	Local $Input = DllStructCreate("byte[" & BinaryLen($Data) & "]")
	DllStructSetData($Input, 1, $Data)

	Local $Digest = DllStructCreate("byte[16]")

	DllCall("user32.dll", "none", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer), _
													"ptr", DllStructGetPtr($Input), _
													"int", BinaryLen($Data), _
													"ptr", DllStructGetPtr($Digest), _
													"int", 0)

	Local $Ret = DllStructGetData($Digest, 1)
	$Input = 0
	$Digest = 0
	$CodeBuffer = 0
	Return $Ret
EndFunc

; by Ward
Func _RC4($Data, $Key)
	Local $Opcode = "0xC81001006A006A005356578B551031C989C84989D7F2AE484829C88945F085C00F84DC000000B90001000088C82C0188840DEFFEFFFFE2F38365F4008365FC00817DFC000100007D478B45FC31D2F775F0920345100FB6008B4DFC0FB68C0DF0FEFFFF01C80345F425FF0000008945F48B75FC8A8435F0FEFFFF8B7DF486843DF0FEFFFF888435F0FEFFFFFF45FCEBB08D9DF0FEFFFF31FF89FA39550C76638B85ECFEFFFF4025FF0000008985ECFEFFFF89D80385ECFEFFFF0FB6000385E8FEFFFF25FF0000008985E8FEFFFF89DE03B5ECFEFFFF8A0689DF03BDE8FEFFFF860788060FB60E0FB60701C181E1FF0000008A840DF0FEFFFF8B750801D6300642EB985F5E5BC9C21000"
	Local $CodeBuffer = DllStructCreate("byte[" & BinaryLen($Opcode) & "]")
	DllStructSetData($CodeBuffer, 1, $Opcode)

	Local $Buffer = DllStructCreate("byte[" & BinaryLen($Data) & "]")
	DllStructSetData($Buffer, 1, $Data)

	DllCall("user32.dll", "none", "CallWindowProc", "ptr", DllStructGetPtr($CodeBuffer), _
													"ptr", DllStructGetPtr($Buffer), _
													"int", BinaryLen($Data), _
													"str", $Key, _
													"int", 0)

	Local $Ret = DllStructGetData($Buffer, 1)
	$Buffer = 0
	$CodeBuffer = 0
	Return $Ret
EndFunc

Func _Exit()
	_CloseSockets()
	TCPShutdown()
	Exit
EndFunc