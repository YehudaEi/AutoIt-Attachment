#cs
	UDF cfx.au3 
	serial functions using kernel32.dll
	V1.0 
	Uwe Lahni 2008
#ce
 #include-once
Global $dll
Global $hSerialPort
Global $dcb_Struct
Global $commtimeout
Global $commtimeout_Struct
Global $commState
Global $commState_Struct
Global $rxbuf
Global $DEBUG=0
Global Const $STX=chr(2)
Global Const $ETX=chr(3)
Global Const $EOT=chr(4)
Global Const $ENQ=chr(5)
Global Const $ACK=chr(6)
Const $NAK=chr(15)
Const $DLE=chr(16)

;====================================================================================
; Function Name:   _opencomm()
;
; Description:    Opens serial port as configured in cfx.ini
; Parameters:     none
; Returns:  on success 0
;           on failure returns -1 and sets @error to 1
;
; Note:    
;====================================================================================
func _opencomm()
	$DEBUG=get_config("Debug")
	$dll = DllOpen("kernel32.dll")
	$dcbs="long DCBlength;long BaudRate; long fBitFields;short wReserved;"
	$dcbs&="short XonLim;short XoffLim;byte Bytesize;byte parity;byte StopBits;byte XonChar; byte XoffChar;"
	$dcbs&="Byte ErrorChar;Byte EofChar;Byte EvtChar;short wReserved1"

	$commtimeouts="long ReadIntervalTimeout;long ReadTotalTimeoutMultiplier;"
	$commtimeouts&="long ReadTotalTimeoutConstant;long WriteTotalTimeoutMultiplier;long WriteTotalTimeoutConstant"

	const $GENERIC_READ_WRITE=0xC0000000
	const $OPEN_EXISTING=3
	const $FILE_ATTRIBUTE_NORMAL =0x80
	const $NOPARITY=0
	const $ONESTOPBIT=0

	$dcb_Struct=DllStructCreate($dcbs)
	if @error Then
		errpr()
		Exit
	EndIf

	$commtimeout_Struct=DllStructCreate($commtimeouts)
	if @error Then
		errpr()
		Exit
	EndIf
	$CommPort = "COM" & get_config("CommPort")
	$CommBaud=get_config("CommBaud")
	$CommBits=get_config("CommBits")
	$CommParity=get_config("CommParity")
	$CommCtrl=get_config("CommCtrl")

	$hSerialPort = DllCall($dll, "hwnd", "CreateFile", "str", $CommPort, _
									"int", $GENERIC_READ_WRITE, _
									"int", 0, _
									"ptr", 0, _
									"int", $OPEN_EXISTING, _
									"int", $FILE_ATTRIBUTE_NORMAL, _
									"int", 0)
	if @error Then
		errpr()
		Exit
	EndIf	
	If number($hserialport[0])<1 Then
		consolewrite("Open Error" & @CRLF)
		return (-1)
	EndIf
	$commState=dllcall($dll,"long","GetCommState","hwnd",$hSerialPort[0],"ptr",DllStructGetPtr($dcb_Struct))
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct,"DCBLength",DllStructGetSize($dcb_Struct))
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct,"BaudRate",$CommBaud)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct,"Bytesize",$CommBits)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct,"fBitfields",number($CommCtrl))
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct,"Parity",$CommParity)
	if @error Then
		errpr()
		Exit
	EndIf	
	DllStructSetData( $dcb_Struct,"StopBits",0x0)
	if @error Then
		errpr()
		Exit
	EndIf	


	DllStructSetData( $dcb_Struct,"XonLim",2048)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct,"XoffLim",512)
	if @error Then
		errpr()
		Exit
	EndIf	

	$commState=dllcall($dll,"short","SetCommState","hwnd",$hSerialPort[0],"ptr",DllStructGetPtr($dcb_Struct))
	if @error Then
		errpr()
		Exit
	EndIf
	consolewrite("CommState: "& $commstate[0] & @CRLF)
	
	if $commstate[0]=0 Then
		consolewrite("SetCommState Error" & @CRLF)
		return (-1)
	EndIf	
	DllStructSetData( $commtimeout_Struct,"ReadIntervalTimeout",-1)
	$commtimeout=dllcall($dll,"long","SetCommTimeouts","hwnd",$hSerialPort[0],"ptr",DllStructGetPtr($commtimeout_Struct))
	if @error Then
		errpr()
		Exit
	EndIf
;~ 	consolewrite($hserialport[0] & @crlf)
;~ 	consolewrite($hserialport[1] & @crlf)
;~ 	consolewrite($hserialport[2] & @crlf)
;~ 	consolewrite($hserialport[3] & @crlf)
;~ 	consolewrite($hserialport[4] & @crlf)

	return number($hSerialPort[0])
	
	
EndFunc

Func _closecomm()
	$closeerr=DllCall($dll, "int", "CloseHandle", "hwnd", $hSerialPort[0])	
	if @error Then
		errpr()
		Exit
	EndIf
	consolewrite("Close " & $closeerr[0] & @crlf)
	return $closeerr[0]
EndFunc	

Func _tx($t)
	if $DEBUG=1 then FileWriteLine("debug.txt","Send " &c2s($t)) 
	$lptr0=dllstructcreate("long_ptr")
	$tbuf=$t
	$txr=dllcall($dll,"int","WriteFile","hwnd",$hSerialPort[0], _
					"str",$tbuf, _
					"int",stringlen($tbuf), _ 
					"long_ptr", DllStructGetPtr($lptr0), _ 
					"ptr", 0) 
	if @error Then
		errpr()
		Exit
	EndIf
EndFunc	

Func _rxwait($n,$t)
	if $DEBUG=1 then FileWriteLine("debug.txt","Wait " & $n & " " &$t) 
	$lptr0=dllstructcreate("long_ptr")
	$rc=" "
;~ 	for $i=1 to $n
;~ 		$rc&=" "
;~ 	next	
	$rlen=1
	$jetza=TimerInit()

	Do
		$rxr=dllcall($dll,"int","ReadFile","hwnd",$hSerialPort[0], _
							"str",$rc, _
							"int",$rlen, _ 
							"long_ptr", DllStructGetPtr($lptr0), _ 
							"ptr", 0)
		if @error Then
			errpr()
			Exit
		EndIf
		$rxl=DllStructGetData($lptr0,1)
		ConsoleWrite("R0:" & $rxr[0] & " |R1:" & $rxr[1] & " |R2:" & $rxr[2] & " |rxl:" & $rxl & " |R4:" & $rxr[4] & @CRLF)
		if $rxl>=1 then 
			$rxbuf&=$rxr[2]
		EndIf
		$to=TimerDiff($jetza)
    Until stringlen($rxbuf)>=$n OR $to>$t  
	return StringLen($rxbuf) 
EndFunc 	

Func _rx($n=0)
	if StringLen($rxbuf)<$n then 
		$rxbuf=""
		Return ""
	EndIf
	If $n=0	Then
		$r=$rxbuf
		$rxbuf=""
		Return $r
	EndIf
	If $n<0 then 
		$rxbuf=""
		Return ""
	EndIf	
	$r=Stringleft($rxbuf,$n)
	$rl=Stringlen($rxbuf)
	$rxbuf=StringRight($rxbuf,$rl-$n)
	if $DEBUG=1 then FileWriteLine("debug.txt","Read " & c2s($r)) 
	return $r 
EndFunc 		

Func c2s($t)
	$ts=""	
	For $ii= 1 To StringLen($t)
		$tc=StringMid($t,$ii,1)
		if Asc($tc)<32 Then
			$ts&="<" & asc($tc) & ">"
		Else
			$ts&=$tc
		EndIf
	Next
	return $ts
EndFunc	


func errpr()
	beep(1880,100)	
	consolewrite ("Error " & @error & @CRLF)	
EndFunc

Func get_config($s)
	$g=IniRead("cfx.ini", "Comm", $s, "x")
	If @error Then 
		MsgBox(4096, "", "INI File Error")
	EndIf
	Return $g
EndFunc
