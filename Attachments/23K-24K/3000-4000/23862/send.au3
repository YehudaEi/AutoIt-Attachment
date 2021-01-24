Global $MAX_SIZE=2*1048576
TCPStartup()
Global $pass=InputBox("Security", "Please select a password for connections","" , "*M")
If @error Then Exit
$file=FileOpenDialog("File to send" , ""  ,"All files(*.*)" , 1)
If @error Then Exit
$size=FileGetSize($file)
If $size=0 Then Exit MsgBox(16 , "ERROR" , "Bad file")
$name=_file_getname($file)
$ip=InputBox("Address" , "ip",@IPAddress1, " M")
$_sock=TCPConnect($ip,8081)
If @error Then Exit MsgBox(16,"Wsa:"&@error , "Unable to connect to the host!")
TCPSend($_sock,$pass)
ToolTip("Sending pass",0,40)
Do
	$recv=TCPRecv($_sock,1000)
	If @error Then Exit MsgBox(16 , "WSA:"&@error , "Lost connection!")
	Sleep(1)
Until $recv<>""
If StringLeft($recv,2)<>"OK" Then Exit MsgBox(16 , "ERROR" , "Bad password:"&$recv)
$recv=StringTrimLeft($recv,2)
ToolTip("Authed, waiting" , 0 , 40)
If $recv="" Then
	Do
		$recv=TCPRecv($_sock,1000)
		If @error Then Exit MsgBox(16 , "WSA:"&@error , "Lost connection!")
		Sleep(1)
	Until $recv<>""
EndIf
If $recv<>"FILE_DATA" Then Exit MsgBox(16 , "Error" , "Weird!"&@CRLF&"got:'"&$recv&"' from the socket")
ToolTip("sending file data" , 0 , 40)
TCPSend($_sock,$name&":"&$size)
Do
	$recv=TCPRecv($_sock,1000)
	If @error Then Exit MsgBox(16 , "WSA:"&@error , "Lost connection!")
	Sleep(1)
Until $recv<>""
If $recv<>"START_UL" Then Exit MsgBox(16 , "ERROR" , "weird!, got:"&$recv&" from the socket")
ToolTip("sending file!",0,40)
$return=False
$fhandle=FileOpen($file,16)
$bytes=0
While Not $return
	$data=FileRead($fhandle,$MAX_SIZE)
	If @error Then $return=True
	$bytes+=TCPSend($_sock,$data)
	ToolTip(Round($bytes*100/$size,2)&"%",0,40)
WEnd
FileClose($fhandle)


Func _file_getname($file)
	$reg=StringRegExp($file,"(.)+\\((.)+)?",3)
	If Not IsArray($reg) Then Return $file
	If UBound($reg)<2 Then Exit MsgBox(16 , @error , "you can't send dirs!")
	Return $reg[1]
EndFunc
