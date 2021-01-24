TCPStartup()
Opt("TrayIconDebug" , 1)
Global $MAX_SIZE=4*1048576;1 meg
Global $TRUSTED=False
Global $SAVE_DIR=@ScriptDir&"\recv"
$_L_SOCK=TCPListen(@IPAddress1,8081)
If @error Then Exit MsgBox(16  , "WSA:"&@error , "Unable to hook port!")
Global $pass=InputBox("Security", "Please select a password for connections","" , "*M")

_listen()


Func _listen()
	ToolTip("listening" , 0 , 0)
	While 1
		$_tcp_acc=TCPAccept($_L_SOCK)
		If $_tcp_acc<>-1 Then
			_start_recv($_tcp_acc)
		EndIf
		Sleep(1)
	WEnd
EndFunc
Func _start_recv($_sock)
	While True
		$_recv=TCPRecv($_sock,$MAX_SIZE)
		If @error Then Return
		If $_recv<>"" Then
			If Not $TRUSTED Then
				If Not auth($_sock,$_recv) Then Return TCPCloseSocket($_sock)
			EndIf
		EndIf
		If $TRUSTED Then
			$file=_get_file_data($_sock)
			If @error Then 
				$TRUSTED=False
				Return
			EndIf
			$location=FileSaveDialog("Save "&$file[0],$SAVE_DIR,"Files(*."&_get_ext($file[0])&")",16,$file[0])
			If @error Then
				$TRUSTED=False
				Return TCPCloseSocket($_sock)
			EndIf
			$fhandle=FileOpen($location,18)
			_start_download($_sock)
			Local $downloading=True,$bytes=0
			While $downloading
				$_data=TCPRecv($_sock,$MAX_SIZE,1)
				If @error Then
					FileClose($fhandle)
					FileDelete($location)
					$TRUSTED=False
					Return
				EndIf
				$bytes+=BinaryLen($_data)
				FileWrite($fhandle,$_data)
				If $bytes=$file[1] Then $downloading=False
				ToolTip(Round($bytes*100/$file[1],2)&"%",0,0)
			WEnd
			TCPSend($_sock,"GOT_IT")
			ToolTip("done!" , 0 , 0)
			FileClose($fhandle)
			TCPCloseSocket($_sock)
			$TRUSTED=False
		EndIf
		Sleep(1)
	WEnd
EndFunc
Func auth($_sock,$_data)
	If $_data<>$pass Then 
		ToolTip("sender has sent bad pass!",0,0)
		TCPSend($_sock,"BAD_PASS")
		Return 0
	Else
		TCPSend($_sock,"OK")
		ToolTip("sender has sent good pass!",0,0)
		$TRUSTED=True
		Return 1
	EndIf
EndFunc
Func _get_ext($file)
	$reg=StringRegExp($file,"(.)+\.((.)+)?",3)
	If Not IsArray($reg) Then Exit MsgBox(16 , "Error" , "Bad file name: "&$file)
	if UBound($reg)<2 Then Exit MsgBox(16 ,"Error" , "Bad file name: "&$file)
	Return $reg[1]
EndFunc
Func _start_download($_sock)
	TCPSend($_sock,"START_UL")
EndFunc
Func _get_file_data($_sock)
	TCPSend($_sock,"FILE_DATA")
	ToolTip("getting file data!" , 0 , 0)
	Local $_recv="",$data[2]
	Do
		$_recv=TCPRecv($_sock,1000)
		If @error Then Return SetError(2)
		Sleep(1)
	Until $_recv<>""
	$_data=StringSplit($_recv,":")
	If $_data[0]<2 Then Return SetError(1)
	$data[0]=$_data[1]
	$data[1]=$_data[2]
	ToolTip("")
	Return $data
EndFunc
	
	