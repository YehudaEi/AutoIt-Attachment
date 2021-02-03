#cs
	UDF cfxbin.au3 
	serial functions using kernel32.dll
	chr(0) can be sent and received
	RTS switching for RS485 communication via converter
	V2.0 
	Uwe Lahni 2010
#ce
 #include-once
Global $dll
Global $hSerialPort
Global $dcb_Struct
Global $commtimeout
Global $commtimeout_Struct
Global $commState
Global $commState_Struct
Global $RXBUF=""
global $RXLEN=0

Global $DEBUG=True
Global Const $NUL=chr(0)
Global Const $STX=chr(2)
Global Const $ETX=chr(3)
Global Const $EOT=chr(4)
Global Const $ENQ=chr(5)
Global Const $ACK=chr(6)
Global Const $NAK=chr(15)
Global Const $DLE=chr(16)

;====================================================================================
; Function Name:   _opencomm()
;
; Description:    Opens serial port 
; Parameters:     	$CommPort		Serial Port, use "\\.\COMx" for x>10  
;					$CommBaud		Baudrate 
;					$CommParity 	0=none, 1=even, 2=odd, 3=mark, 4=space
;					$CommBits 		4-8
;					$CommStop		0=1, 1=1.5, 2=2
;					$CommCtrl		0x011 
;									.0 fBinary always 1 for Win32
;									.1 fParity enable parity checking
;									.2 fOutxCTSFlow
;									.3 fOutxDSRFlow 
;									.4 fDTRControl 0=disabled 1=enabled
;									.5 fDTRControl 1=handshake, (don't use EscapeCommFunction)
;									.6 fDSRSensitivity 1=receive only when DSR active
;									.7 fTXContinueOnXOFF
;									.8 fOutX XOn/XOff during transmission
;									.9 fInX XOn/XOff during reception
;									.10 fErrorChar
;									.11 fNull 1=discard received NUL=chr(0) characters 
;									.12 fRTSControl | 0=disable 1=enable 2=handshake 3=toggle
;									.13 fRTSControl |
;									.14 fAbortOnError 
;									

; Returns:  on success 0
;           on failure returns -1 and sets @error to 1
;
; Note:    
;====================================================================================
func _opencomm($CommPort=1,$CommBaud=9600,$CommParity=0,$CommBits=8, $CommStop=1,$CommCtrl=0x011)
	$dll = DllOpen("kernel32.dll")
	$dcbs="long DCBlength;long BaudRate; long fBitFields;short wReserved;"
	$dcbs&="short XonLim;short XoffLim;byte Bytesize;byte parity;byte StopBits;byte XonChar; byte XoffChar;"
	$dcbs&="Byte ErrorChar;Byte EofChar;Byte EvtChar;short wReserved1"

	$commtimeouts="long ReadIntervalTimeout;long ReadTotalTimeoutMultiplier;"
	$commtimeouts&="long ReadTotalTimeoutConstant;long WriteTotalTimeoutMultiplier;long WriteTotalTimeoutConstant"

	const $GENERIC_READ_WRITE=0xC0000000
	const $OPEN_EXISTING=3
	const $FILE_ATTRIBUTE_NORMAL =0x80

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
	_setrts(4)
	return number($hSerialPort[0])
	
	
EndFunc

func _setcomm($CommBaud=9600,$CommParity=0,$CommBits=8, $CommStop=1,$CommCtrl=0x011)
	$dll = DllOpen("kernel32.dll")
	$dcbs="long DCBlength;long BaudRate; long fBitFields;short wReserved;"
	$dcbs&="short XonLim;short XoffLim;byte Bytesize;byte parity;byte StopBits;byte XonChar; byte XoffChar;"
	$dcbs&="Byte ErrorChar;Byte EofChar;Byte EvtChar;short wReserved1"

	$dcb_Struct=DllStructCreate($dcbs)
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
	if $DEBUG then FileWriteLine("debug.txt","Send " &c2s($t)) 
	$lptr0=dllstructcreate("long_ptr")
	$tbuf=$t
	_setrts(3)
	sleep(2)
	for $i=1 to stringlen($tbuf)
		$txr=dllcall($dll,"int","WriteFile","hwnd",$hSerialPort[0], _
						"str",stringmid($tbuf,$i,1), _
						"int",1, _ 
						"long_ptr", DllStructGetPtr($lptr0), _ 
						"ptr", 0) 
		if @error Then
			errpr()
			Exit
		EndIf
		sleep(2)
	Next
	_setrts(4)
EndFunc	

Func _waitrx($t=0,$n=1)
	$jetza=TimerInit()

	Do
		_receive()
		$to=TimerDiff($jetza)
    Until $RXLEN>=$n OR $to>$t
	return $RXLEN
EndFunc 	

Func _receive()
	$rc=" "
	$lptr0=dllstructcreate("long_ptr")
	$jetza=TimerInit()
	$rxr=dllcall($dll,"int","ReadFile","hwnd",$hSerialPort[0], _
						"str",$rc, _
						"int",1, _ 
						"long_ptr", DllStructGetPtr($lptr0), _ 
						"ptr", 0)
	if @error Then
		errpr()
		Exit
	EndIf
	$RXLEN+=DllStructGetData($lptr0,1)
	if DllStructGetData($lptr0,1) >0 then 	
		$RXBUF&=$rxr[2]
		if $rxr[2]="" then $RXBUF&=chr(0)
;		ConsoleWrite("RXLEN:" & $rxLEN & "$RXBUF:"& $RXBUF & @CRLF )
	EndIf
EndFunc 	


Func _rx($n=0)
	if StringLen($rxbuf)<$n then 
		$rxbuf=""
		$RXLEN=0
		if $DEBUG then FileWriteLine("debug.txt","Read " & c2s($r)) 
		Return ""
	EndIf
	If $n=0	Then
		$r=$rxbuf
		$rxbuf=""
		$RXLEN=0
		if $DEBUG then FileWriteLine("debug.txt","Read " & c2s($r)) 
		Return $r
	EndIf
	If $n<0 then 
		$rxbuf=""
		$RXLEN=0
		Return ""
	EndIf	
	$r=Stringleft($rxbuf,$n)
	$rxbuf=StringRight($rxbuf,$RXLEN-$n)
	$rxlen=$rxlen-$n
	if $DEBUG then FileWriteLine("debug.txt","Read " & c2s($r)) 
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


Func _setrts($x)
	$escr=dllcall($dll,"long","EscapeCommFunction","hwnd",($hSerialPort[0]),"int",$x)
	if @error Then
		errpr()
		Exit
	EndIf
EndFunc

