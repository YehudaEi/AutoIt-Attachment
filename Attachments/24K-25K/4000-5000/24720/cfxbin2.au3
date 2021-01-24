#cs
	UDF cfxbin2.au3 
	serial functions using kernel32.dll for 2 ports
	V1.0 
	Uwe Lahni 2009
#ce
 #include-once
Global $dll1
Global $dll2

Global $hSerialPort1
Global $hSerialPort2
Global $dcb_Struct1
Global $dcb_Struct2

Global $commtimeout1
Global $commtimeout2

Global $commtimeout_Struct1
Global $commtimeout_Struct2

Global $commState1
Global $commState2

Global $commState_Struct1
Global $commState_Struct2

Global $rxbuf1
Global $rxbuf2

Global $DEBUG=0
Global Const $STX=chr(2)
Global Const $ETX=chr(3)
Global Const $EOT=chr(4)
Global Const $ENQ=chr(5)
Global Const $ACK=chr(6)
Const $NAK=chr(15)
Const $DLE=chr(16)
const $GENERIC_READ_WRITE=0xC0000000
const $OPEN_EXISTING=3
const $FILE_ATTRIBUTE_NORMAL =0x80

;====================================================================================
; Function Name:   _opencomm1()
;
; Description:    Opens serial ports as configured in cfx.ini
; Parameters:     none
; Returns:  on success 0
;           on failure returns -1 and sets @error to 1
;
; Note:    
;====================================================================================
func _opencomm1($inifile="cfxbin2.ini",$Port=1,$baud=9600,$parity="e",$bits=7, $stop=0)
	$DEBUG=get_config("Debug")
	$dll1 = DllOpen("kernel32.dll")
	if @error Then
			errpr()
			ConsoleWrite("DLLOpen Error" & @CRLF)
			Exit
		EndIf
	
	$dcbs1="long DCBlength;long BaudRate;long fBitFields;short wReserved;"
	$dcbs1&="short XonLim;short XoffLim;byte Bytesize;byte parity;byte StopBits;byte XonChar; byte XoffChar;"
	$dcbs1&="Byte ErrorChar;Byte EofChar;Byte EvtChar;short wReserved1"

	$commtimeouts1="long ReadIntervalTimeout;long ReadTotalTimeoutMultiplier;"
	$commtimeouts1&="long ReadTotalTimeoutConstant;long WriteTotalTimeoutMultiplier;long WriteTotalTimeoutConstant"

	$dcb_Struct1=DllStructCreate($dcbs1)
	if @error Then
		errpr()
		ConsoleWrite("StructCreate Error 1" & @CRLF)
		Exit
	EndIf

	$commtimeout_Struct1=DllStructCreate($commtimeouts1)
	if @error Then
		errpr()
		ConsoleWrite("CommTimeout Error 1" & @CRLF)
		Exit
	EndIf
	if $inifile<>"" And FileExists($inifile) Then
		$CommPort = "COM" & get_config("CommPort1")
		$CommBaud=get_config("CommBaud1")
		$CommBits=get_config("CommBits1")
		$CommParity=get_config("CommParity1")
		$CommCtrl=get_config("CommCtrl1")
		$CommStop=get_config("CommStop1")
	Else
		$CommPort=$Port
		$CommBaud=$baud
		$CommBits=$bits
		Switch $parity
		case $parity="n"
			$CommParity=0
		case $parity="o"
			$CommParity=1
		case $parity="e"
			$CommParity=2
		EndSwitch
		$CommStop=$stop
		$CommCtrl=0x011
	endif
	
	$hSerialPort1 = DllCall($dll1, "hwnd", "CreateFile", "str", $CommPort, _
									"int", $GENERIC_READ_WRITE, _
									"int", 0, _
									"ptr", 0, _
									"int", $OPEN_EXISTING, _
									"int", $FILE_ATTRIBUTE_NORMAL, _
									"int", 0)
	if @error Then
		errpr()
		ConsoleWrite("Open Error 1" & @CRLF)
		Exit
	EndIf	
	If number($hserialport1[0])<1 Then
		consolewrite("Open Error 1" & @CRLF)
		return (-1)
	EndIf
	$commState1=dllcall($dll1,"long","GetCommState","hwnd",$hSerialPort1[0],"ptr",DllStructGetPtr($dcb_Struct1))
	if @error Then
		errpr()
		ConsoleWrite("GetCommState 1" & @CRLF)
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct1,"DCBLength",DllStructGetSize($dcb_Struct1))
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct1,"BaudRate",$CommBaud)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct1,"Bytesize",$CommBits)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct1,"fBitfields",number($CommCtrl))
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct1,"Parity",$CommParity)
	if @error Then
		errpr()
		Exit
	EndIf	
	DllStructSetData( $dcb_Struct1,"StopBits",0x0)
	if @error Then
		errpr()
		Exit
	EndIf	


	DllStructSetData( $dcb_Struct1,"XonLim",2048)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct1,"XoffLim",512)
	if @error Then
		errpr()
		Exit
	EndIf	

	$commState=dllcall($dll1,"short","SetCommState","hwnd",$hSerialPort1[0],"ptr",DllStructGetPtr($dcb_Struct1))
	if @error Then
		errpr()
		Exit
	EndIf
	consolewrite("CommState 1: "& $commstate1[0] & @CRLF)
	
	if $commstate1[0]=0 Then
		consolewrite("SetCommState Error 1" & @CRLF)
		return (-1)
	EndIf	
	DllStructSetData( $commtimeout_Struct1,"ReadIntervalTimeout",-1)
	$commtimeout1=dllcall($dll1,"long","SetCommTimeouts","hwnd",$hSerialPort1[0],"ptr",DllStructGetPtr($commtimeout_Struct1))
	if @error Then
		errpr()
		Exit
	EndIf
;~ 	consolewrite($hserialport[0] & @crlf)
;~ 	consolewrite($hserialport[1] & @crlf)
;~ 	consolewrite($hserialport[2] & @crlf)
;~ 	consolewrite($hserialport[3] & @crlf)
;~ 	consolewrite($hserialport[4] & @crlf)
	_setrts1(4)
	return number($hSerialPort1[0])
	
	
EndFunc

;====================================================================================
; Function Name:   _opencomm2()
;
; Description:    Opens serial ports as configured in cfx.ini
; Parameters:     none
; Returns:  on success 0
;           on failure returns -1 and sets @error to 1
;
; Note:    
;====================================================================================
func _opencomm2($inifile="cfxbin2.ini",$Port=2,$baud=9600,$parity="e",$bits=7, $stop=0)
	$DEBUG=get_config("Debug")
	$dll2 = DllOpen("kernel32.dll")
	if @error Then
			errpr()
			ConsoleWrite("DLLOpen Error 2" & @CRLF)
			Exit
		EndIf
	
	$dcbs2="long DCBlength;long BaudRate;long fBitFields;short wReserved;"
	$dcbs2&="short XonLim;short XoffLim;byte Bytesize;byte parity;byte StopBits;byte XonChar; byte XoffChar;"
	$dcbs2&="Byte ErrorChar;Byte EofChar;Byte EvtChar;short wReserved1"

	$commtimeouts2="long ReadIntervalTimeout;long ReadTotalTimeoutMultiplier;"
	$commtimeouts2&="long ReadTotalTimeoutConstant;long WriteTotalTimeoutMultiplier;long WriteTotalTimeoutConstant"

	$dcb_Struct2=DllStructCreate($dcbs2)
	if @error Then
		errpr()
		ConsoleWrite("StructCreate Error 2" & @CRLF)
		Exit
	EndIf

	$commtimeout_Struct2=DllStructCreate($commtimeouts2)
	if @error Then
		errpr()
		ConsoleWrite("CommTimeout Error 2" & @CRLF)
		Exit
	EndIf
	if $inifile<>"" And FileExists($inifile) Then
		$CommPort = "COM" & get_config("CommPort2")
		$CommBaud=get_config("CommBaud2")
		$CommBits=get_config("CommBits2")
		$CommParity=get_config("CommParity2")
		$CommCtrl=get_config("CommCtrl2")
		$CommStop=get_config("CommStop2")
	Else
		$CommPort=$Port
		$CommBaud=$baud
		$CommBits=$bits
		Switch $parity
		case $parity="n"
			$CommParity=0
		case $parity="o"
			$CommParity=1
		case $parity="e"
			$CommParity=2
		EndSwitch
		$CommStop=$stop
		$CommCtrl=0x011
	endif
	
	$hSerialPort2 = DllCall($dll2, "hwnd", "CreateFile", "str", $CommPort, _
									"int", $GENERIC_READ_WRITE, _
									"int", 0, _
									"ptr", 0, _
									"int", $OPEN_EXISTING, _
									"int", $FILE_ATTRIBUTE_NORMAL, _
									"int", 0)
	if @error Then
		errpr()
		ConsoleWrite("Open Error 2" & @CRLF)
		Exit
	EndIf	
	If number($hserialport2[0])<1 Then
		consolewrite("Open Error 2" & @CRLF)
		return (-1)
	EndIf
	$commState2=dllcall($dll2,"long","GetCommState","hwnd",$hSerialPort2[0],"ptr",DllStructGetPtr($dcb_Struct2))
	if @error Then
		errpr()
		ConsoleWrite("GetCommState 2" & @CRLF)
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct2,"DCBLength",DllStructGetSize($dcb_Struct2))
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct2,"BaudRate",$CommBaud)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct2,"Bytesize",$CommBits)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct2,"fBitfields",number($CommCtrl))
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct2,"Parity",$CommParity)
	if @error Then
		errpr()
		Exit
	EndIf	
	DllStructSetData( $dcb_Struct2,"StopBits",0x0)
	if @error Then
		errpr()
		Exit
	EndIf	


	DllStructSetData( $dcb_Struct2,"XonLim",2048)
	if @error Then
		errpr()
		Exit
	EndIf	

	DllStructSetData( $dcb_Struct2,"XoffLim",512)
	if @error Then
		errpr()
		Exit
	EndIf	

	$commState=dllcall($dll2,"short","SetCommState","hwnd",$hSerialPort2[0],"ptr",DllStructGetPtr($dcb_Struct2))
	if @error Then
		errpr()
		Exit
	EndIf
	consolewrite("CommState 2: "& $commstate2[0] & @CRLF)
	
	if $commstate2[0]=0 Then
		consolewrite("SetCommState Error 2" & @CRLF)
		return (-1)
	EndIf	
	DllStructSetData( $commtimeout_Struct2,"ReadIntervalTimeout",-1)
	$commtimeout2=dllcall($dll2,"long","SetCommTimeouts","hwnd",$hSerialPort2[0],"ptr",DllStructGetPtr($commtimeout_Struct2))
	if @error Then
		errpr()
		Exit
	EndIf
;~ 	consolewrite($hserialport[0] & @crlf)
;~ 	consolewrite($hserialport[1] & @crlf)
;~ 	consolewrite($hserialport[2] & @crlf)
;~ 	consolewrite($hserialport[3] & @crlf)
;~ 	consolewrite($hserialport[4] & @crlf)
	_setrts2(4)
	return number($hSerialPort2[0])
	
	
EndFunc


Func _closecomm1()
	$closeerr1=DllCall($dll1, "int", "CloseHandle", "hwnd", $hSerialPort1[0])	
	if @error Then
		errpr()
		Exit
	EndIf
	consolewrite("Close 1" & $closeerr1[0] & @crlf)
	return $closeerr1[0]
EndFunc	

Func _closecomm2()
	$closeerr2=DllCall($dll2, "int", "CloseHandle", "hwnd", $hSerialPort2[0])	
	if @error Then
		errpr()
		Exit
	EndIf
	consolewrite("Close 2" & $closeerr2[0] & @crlf)
	return $closeerr2[0]
EndFunc	

Func _tx1($t)
	if $DEBUG=1 then FileWriteLine("debug.txt","Send " &c2s($t)) 
	$lptr01=dllstructcreate("long_ptr")
	$tbuf1=$t
	_setrts1(3)
	sleep(2)
	for $i=1 to stringlen($tbuf1)
		$txr1=dllcall($dll1,"int","WriteFile","hwnd",$hSerialPort1[0], _
						"str",stringmid($tbuf1,$i,1), _
						"int",1, _ 
						"long_ptr", DllStructGetPtr($lptr01), _ 
						"ptr", 0) 
		if @error Then
			errpr()
			Exit
		EndIf
		sleep(2)
	Next
	_setrts1(4)
EndFunc	
Func _tx2($t)
	if $DEBUG=1 then FileWriteLine("debug.txt","Send2 " &c2s($t)) 
	$lptr02=dllstructcreate("long_ptr")
	$tbuf2=$t
	_setrts2(3)
	sleep(2)
	for $i=1 to stringlen($tbuf2)
		$txr2=dllcall($dll2,"int","WriteFile","hwnd",$hSerialPort2[0], _
						"str",stringmid($tbuf2,$i,1), _
						"int",1, _ 
						"long_ptr", DllStructGetPtr($lptr02), _ 
						"ptr", 0) 
		if @error Then
			errpr()
			Exit
		EndIf
		sleep(2)
	Next
	_setrts2(4)
EndFunc	

Func _rxByte1($t)
	Local $InBuf1 = dllstructcreate("byte[1]")
    Local $pInBuf1 = DllStructGetPtr($InBuf1)

	if $DEBUG=1 then FileWriteLine("debug.txt","rxByte " & " " &$t) 
	$lptr01=dllstructcreate("long_ptr")
	$jetza=TimerInit()

	Do
		$rxr1=dllcall($dll1,"int","ReadFile","hwnd",$hSerialPort1[0], _
							"ptr",$pInBuf1, _
							"int",1, _ 
							"long_ptr", DllStructGetPtr($lptr01), _ 
							"ptr", 0)
		if @error Then
			errpr()
			Exit
		EndIf
		$rxl1=DllStructGetData($lptr01,1)
;		ConsoleWrite("R0:" & $rxr[0] & " |R1:" & $rxr[1] & " |R2:" & $rxr[2] & " |rxl:" & $rxl & " |R4:" & $rxr[4] & @CRLF)
		$to=TimerDiff($jetza)
    Until $rxl1>=1 OR $to>$t
;	ConsoleWrite("RxByte: " & dllstructgetdata($InBuf,1) & @CRLF)
	if $to>$t Then
		return("") 
	else 
		return dllstructgetdata($InBuf1,1)
	endif 	
EndFunc 	

Func _rxByte2($t)
	Local $InBuf2 = dllstructcreate("byte[1]")
    Local $pInBuf2 = DllStructGetPtr($InBuf2)

	if $DEBUG=1 then FileWriteLine("debug.txt","rxByte 2" & " " &$t) 
	$lptr02=dllstructcreate("long_ptr")
	$jetza=TimerInit()

	Do
		$rxr2=dllcall($dll2,"int","ReadFile","hwnd",$hSerialPort2[0], _
							"ptr",$pInBuf2, _
							"int",1, _ 
							"long_ptr", DllStructGetPtr($lptr02), _ 
							"ptr", 0)
		if @error Then
			errpr()
			Exit
		EndIf
		$rxl2=DllStructGetData($lptr02,1)
;		ConsoleWrite("R0:" & $rxr[0] & " |R1:" & $rxr[1] & " |R2:" & $rxr[2] & " |rxl:" & $rxl & " |R4:" & $rxr[4] & @CRLF)
		$to=TimerDiff($jetza)
    Until $rxl2>=1 OR $to>$t
;	ConsoleWrite("RxByte: " & dllstructgetdata($InBuf,1) & @CRLF)
	if $to>$t Then
		return("") 
	else 
		return dllstructgetdata($InBuf2,1)
	endif 	
EndFunc 	


Func _rx11($n=0)
	if StringLen($rxbuf1)<$n then 
		$rxbuf1=""
		Return ""
	EndIf
	If $n=0	Then
		$r1=$rxbuf1
		$rxbuf1=""
		Return $r1
	EndIf
	If $n<0 then 
		$rxbuf1=""
		Return ""
	EndIf	
	$r1=Stringleft($rxbuf1,$n)
	$rl1=Stringlen($rxbuf1)
	$rxbuf1=StringRight($rxbuf1,$rl1-$n)
	if $DEBUG=1 then FileWriteLine("debug.txt","Read " & c2s($r1)) 
	return $r1 
EndFunc 		
Func _rx12($n=0)
	if StringLen($rxbuf2)<$n then 
		$rxbuf2=""
		Return ""
	EndIf
	If $n=0	Then
		$r2=$rxbuf2
		$rxbuf2=""
		Return $r2
	EndIf
	If $n<0 then 
		$rxbuf2=""
		Return ""
	EndIf	
	$r2=Stringleft($rxbuf2,$n)
	$rl2=Stringlen($rxbuf2)
	$rxbuf2=StringRight($rxbuf2,$rl2-$n)
	if $DEBUG=1 then FileWriteLine("debug.txt","Read " & c2s($r2)) 
	return $r2 
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
	$g=IniRead("cfxbin2.ini", "Comm", $s, "x")
	If @error Then 
		MsgBox(4096, "", "INI File Error")
	EndIf
	Return $g
EndFunc

Func _setrts1($x)
	$escr=dllcall($dll1,"long","EscapeCommFunction","hwnd",($hSerialPort1[0]),"int",$x)
	if @error Then
		errpr()
		Exit
	EndIf
EndFunc

Func _setrts2($x)
	$escr=dllcall($dll2,"long","EscapeCommFunction","hwnd",($hSerialPort2[0]),"int",$x)
	if @error Then
		errpr()
		Exit
	EndIf
EndFunc
