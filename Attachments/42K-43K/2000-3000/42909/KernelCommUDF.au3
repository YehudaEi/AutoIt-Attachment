#include-once

; #INDEX# =======================================================================================================================
; Title ...............: KernelCommUDF.au3
; AutoIt Version ......: 3.3.10.0
; Language ............: English
; Description .........: Communications Resource Management (serial ports, parallel ports)
; Author(s) ...........: Harry Pavlic (Lecdev)
; Requirements ........: AutoIt v3.3 +, kernel32.dll, Developed/Tested on Windows 7 Pro
; UDF Version History .: V1.0 Harry Pavlic 29th Dec 2013 03:30pm
;						 V1.1 Harry Pavlic 29th Dec 2013 09:30pm added _CommResourceBufferQues()
; ===============================================================================================================================

; ------------------------------------------------------------------------------
; This software is provided 'as-is', without any express or
; implied warranty.  In no event will the authors be held liable for any
; damages arising from the use of this software.
; ------------------------------------------------------------------------------

; #VARIABLES# ===================================================================================================================
Global $hCommResourceChannel[1] ; array to store communications resource channel handles, [0] is not used, elements are added by add function.
Global $hKernel32dll = "kernel32.dll" ; this variable alternates between this string and a handle to kernel32.dll depending on whats going on.
Global $ConsoleWriteRX = 0 ; change to 1 to write all rxed data to console
Global $LastErrorString ; on failures this variable is set to this threads last kernel32.dll error string
; ===============================================================================================================================

; #CURRENT FUNCTIONS# ===============================================================================================================
;	_AddCommResourceChannel()
;	_CommResourceUpdateChannel()
;	_CommResourceReadASCII()
;	_CommResourceReadASCIIArray()
;	_CommResourceSendASCIIArray()
;	_CommResourceReadChar()
;	_CommResourceReadLine()
;	_CommResourceSendLine()
;	_CommResourceClearBuffer()
;	_RefreshCommResourceChannel()
;	_CommResourceBufferQues()
;	_CloseCommResourceChannel()
;	_CloseAllCommResourceChannels()
;	_LastErrorMessage()
;	_ListSerialPorts()
;	_ListParallelPorts()
; =====================================================================================================================================

#region Communications Structure definitions ; Intended For Internal Use Only ***
Func _COMM_CONFIG($dcbStruct) ; Example! ~ $var1 = DllStructCreate(_DCB()) _ DllCall($hKernel32dll,"long","GetCommState","HANDLE",$porthandle,"ptr",DllStructGetPtr($var1)) _ $var2 =  DllStructCreate(COMM_CONFIG($var1))
	Local $_COMM_CONFIG = _
	"DWORD dwSize;" & _
	"WORD  wVersion;" & _
	"WORD  wReserved;" & _
	 $dcbStruct & " dcb;" & _
	"DWORD dwProviderSubType;" & _
	"DWORD dwProviderOffset;" & _
	"DWORD dwProviderSize;" & _
	"WCHAR wcProviderData[1];"
	Return $_COMM_CONFIG
EndFunc
Func _COMMPROP()
	Local $_COMMPROP = _
	"WORD  wPacketLength;" & _
	"WORD  wPacketVersion;" & _
	"DWORD dwServiceMask;" & _
	"DWORD dwReserved1;" & _
	"DWORD dwMaxTxQueue;" & _
	"DWORD dwMaxRxQueue;" & _
	"DWORD dwMaxBaud;" & _
	"DWORD dwProvSubType;" & _
	"DWORD dwProvCapabilities;" & _
	"DWORD dwSettableParams;" & _
	"DWORD dwSettableBaud;" & _
	"WORD  wSettableData;" & _
	"WORD  wSettableStopParity;" & _
	"DWORD dwCurrentTxQueue;" & _
	"DWORD dwCurrentRxQueue;" & _
	"DWORD dwProvSpec1;" & _
	"DWORD dwProvSpec2;" & _
	"WCHAR wcProvChar[1];"
	Return $_COMMPROP
EndFunc
Func _COMMTIMEOUTS()
	Local $_COMMTIMEOUTS = _
	"DWORD ReadIntervalTimeout;" & _ ; time between bytes in before ReadFile returns as completed, 0 is disable, -1 is maxword?
	"DWORD ReadTotalTimeoutMultiplier;" & _ ; multiplied by the total requested number of bytes to read for max timeout
	"DWORD ReadTotalTimeoutConstant;" & _ ; added to the product of ^^
	"DWORD WriteTotalTimeoutMultiplier;" & _ ; multiplier for total write timeout, multiplied by number of bytes to write
	"DWORD WriteTotalTimeoutConstant;" ; added to the product of ^^
	Return $_COMMTIMEOUTS
EndFunc
Func _COMSTAT()
	Local $_COMSTAT = _
	"DWORD fBitFields;" & _
	"DWORD cbInQue;" & _ ; input buffer byte count
	"DWORD cbOutQue;" ; output buffer byte count
	Return $_COMSTAT
EndFunc
	;*** fBitFields in order ***
	;fCtsHold 1 bit true false
	;fDsrHold 1 bit true false
	;fRlsdHold 1 bit true false
	;fXoffHold 1 bit true false
	;fXoffSent 1 bit true false
	;fEof 1 bit true false
	;fTxim 1 bit true false
	;fReserved 25 bits reserved
Func _DCB()
	Local $_DCB = _
	"DWORD DCBlength;" & _ ; dllgetstructuresize()
	"DWORD BaudRate;" & _ ; actual baud eg. 9600
	"WORD fBitFields;" & _ ; must be true
	"BYTE wReserved;" & _ ; reserved must be 0
	"WORD XonLim;" & _ ; number of bytes allowed in buffer before flow control is activated
	"WORD XoffLim;" & _ ; minimum number of free bytes allowd in input buffer before flow control is activated
	"BYTE Parity;" & _ ; 0/1/2/3/4 = none/odd/even/mark/space
	"BYTE StopBits;" & _ ; 0/1/2 = 1/1.5/2 number of stop bits
	"BYTE ByteSize;" & _ ; number of bits in byte usualy 8
	"CHAR XonChar;" & _ ; the value of the xon character for TX/RX
	"CHAR XoffChar;" & _ ; the value of the xoff character for TX/RX
	"CHAR ErrorChar;" & _ ; the value of the Parity error character
	"CHAR EofChar;" & _ ; the value of the end of data delimiter caracter
	"CHAR EvtChar;" & _ ; the value of the event character
	"WORD wReserved1;" ; reserved do not change
	Return $_DCB
EndFunc
Func MODEMDEVCAPS_TAG()
	Local $MODEMDEVCAPS_TAG = _
	"DWORD dwActualSize;" & _
	"DWORD dwRequiredSize;" & _
	"DWORD dwDevSpecificOffset;" & _
	"DWORD dwDevSpecificSize;" & _
	"DWORD dwModemProviderVersion;" & _
	"DWORD dwModemManufacturerOffset;" & _
	"DWORD dwModemManufacturerSize;" & _
	"DWORD dwModemModelOffset;" & _
	"DWORD dwModemModelSize;" & _
	"DWORD dwModemVersionOffset;" & _
	"DWORD dwModemVersionSize;" & _
	"DWORD dwDialOptions;" & _
	"DWORD dwCallSetupFailTimer;" & _
	"DWORD dwInactivityTimeout;" & _
	"DWORD dwSpeakerVolume;" & _
	"DWORD dwSpeakerMode;" & _
	"DWORD dwModemOptions;" & _
	"DWORD dwMaxDTERate;" & _
	"DWORD dwMaxDCERate;" & _
	"BYTE  abVariablePortion[1];"
	Return $MODEMDEVCAPS_TAG
EndFunc
Func MODEMSETTINGS_TAG()
	Local $MODEMSETTINGS_TAG = _
	"DWORD dwActualSize;" & _
	"DWORD dwRequiredSize;" & _
	"DWORD dwDevSpecificOffset;" & _
	"DWORD dwDevSpecificSize;" & _
	"DWORD dwCallSetupFailTimer;" & _
	"DWORD dwInactivityTimeout;" & _
	"DWORD dwSpeakerVolume;" & _
	"DWORD dwSpeakerMode;" & _
	"DWORD dwPreferredModemOptions;" & _
	"DWORD dwNegotiatedModemOptions;" & _
	"DWORD dwNegotiatedDCERate;" & _
	"BYTE  abVariablePortion[1];"
	Return $MODEMSETTINGS_TAG
EndFunc
	;*** fBitFields in order ***
	;fBinary - 1 must be true
	;fParity - 1/0 = true false, enables parity checking
	;fOutxCtsFlow - 1/0 = true false, enables cts monitoring
	;OutxDsrFlow - 1/0 = true false, enables dsr flow control
	;fDtrControl - 00/01/10 = disable/enable/handshake, sets dtr flow control (2 bits)
	;fDsrSensitivity - 1/0 = true false, set same as fOutxDsrFlow
	;fTXContinueOnXoff - 1/0 = true false, opposite to fOutX/fInX, true = Xon/Xoff is dissabled
	;fOutX - 1/0 = true false, false = Xon/Xoff is dissabled
	;fInX - 1/0 = true false, false = Xon/Xoff is dissabled
	;fErrorChar - 1/0 true false enables replace character with Parity error with error character
	;fNull - 1/0 true false enables dumping of NULL character
	;fRtsControl - 00/01/10/11 disable/enable/handshake/toggle sets rts flow control (2 bits)
	;fAbortOnError - 1/0 true false when true on error stops communication until ClearCommError function called
	;fDummy2 - 0 reserved dont change
#endregion

; ####*FUNCTIONS*########################################################################################################################################################

;=============== _AddCommResourceChannel ===============================================================================================================================
; Function Name:   	_AddCommResourceChannel($PortNumber = 1,$BaudRate = 9600,$DataBits = 8,$Parity = 0,$StopBits = 0,$FlowCTS = 0,$FlowDSR = 0,$FlowDTR = 0, _
;										$XonXoff = 0,$FlowRTS = 0,$DumpNull = 0,$CheckParity = 0,$ParityErrChr = -1,$XonLimit = 0,$XoffLimit = 2048, _
;										$XonChr = -1,$XoffChr = -1,$EndChr = -1,$EventChr = -1)
; Description:    	Opens CommResource port
; Parameters:    	(all parameters are optional, see Note)
;					$PortNumber = port number for example 1 ( must be an available port)
;					$BaudRate = 110,300,600,1200,2400,4800,9600,14400,19200,38400,57600,115200,128000,256000 ( baud rate, dependant on hardware capabilities)
;					$DataBits = 5,6,7,8 	( data bits, *restriction* The use of 5 data bits with 2 stop bits is an invalid combination, as is 6, 7, or 8 data bits with 1.5 stop bits.)
;					$StopBits = 0,1,2 		( 0 = one stop bit, 1 = one point five stop bits, 2 = two stop bits)
;					$FlowCTS = 0,1 			( 1 = enable cts flow control)
;					$FlowDSR = 0,1 			( 1 = enable dsr flow control)
;					$FlowDTR = 0,1,2 		( 0 = disable dtr, 1 = enable dtr, 2 = handshake)
;					$XonXoff = 0,1 			( 1 = enable XonXoff (software flow control) )
;					$FlowRTS = 0,1,2,3 		( 0 = disable rts, 1 = enable rts, 2 = handshake rts, 3 = toggle rts)
;					$DumpNull = 0,1			( 0 = don't dump null character, 1 = dump null character) (when using nulls communicate with ASCII functions as null in char returns "" in autoit)
;					$CheckParity = 0,1					( 1 = enable parity checking)
;					$ParityErrChr = -1,Chr(ASCIIcode) 	( -1 sets none)
;					$XonLimit = 0 to 2048 				( The minimum number of bytes in use allowed in the input buffer before flow control is activated to allow transmission by the sender)
;					$XoffLimit = 8 - 2048 				( The minimum number of free bytes allowed in the input buffer before flow control is activated to inhibit the sender)
;					$XonChr = -1,Chr(ASCIIcode) 		( -1 sets none)
;					$XoffChr = -1,Chr(ASCIIcode) 		( -1 sets none)
;					$EndChr = -1,Chr(ASCIIcode) 		( -1 sets none)
;					$EventChr = -1,Chr(ASCIIcode)	 	( -1 sets none)
;					$PortType = 0,1						( 0 = serial commport, 1 = parallel commport)
; Returns:  on success, $hCommResourceChannel element number where handle is located.
;           on failure returns -1 and sets $LastErrorString
; Note: calling this funcion without any paramaters opens serial port COM1 with 9600 baud, 8 databits, 1 stop bit, no flow control and null inclusive communication
;==============================================================================================================================================================
Func _AddCommResourceChannel($PortNumber = 1,$BaudRate = 9600,$DataBits = 8,$Parity = 0,$StopBits = 0,$FlowCTS = 0,$FlowDSR = 0,$FlowDTR = 0, _
						$XonXoff = 0,$FlowRTS = 0,$DumpNull = 0,$CheckParity = 0,$ParityErrChr = -1,$XonLimit = 0,$XoffLimit = 2048, _
						$XonChr = -1,$XoffChr = -1,$EndChr = -1,$EventChr = -1, $PortType = 0)
	Local Const $GENERIC_READ_WRITE = 0xC0000000
	Local Const $EXCLUSIVE_ACCESS = 0
	Local Const $DEFAULT_SECURITY = ""
	Local Const $OPEN_EXISTING = 3
	Local Const $NOT_OVERLAPPED_IO = 0
	Local Const $NULL_TEMPLATE = ""
	Local $fWORD = 1
	If $FlowCTS = 1 Then $fWORD = BitXOR($fWORD, 4)
	If $FlowDSR = 1 Then $fWORD = BitXOR($fWORD, 8)
	If $FlowDTR = 1 Then $fWORD = BitXOR($fWORD, 16)
	If $FlowDTR = 2 Then $fWORD = BitXOR($fWORD, 32)
	If $XonXoff = 1 Then
		$fWORD = BitXOR($fWORD, 768)
	Else
		$fWORD = BitXOR($fWORD, 128)
	EndIf
	If $FlowRTS = 1 Then $fWORD = BitXOR($fWORD, 4096)
	If $FlowRTS = 2 Then $fWORD = BitXOR($fWORD, 8192)
	If $FlowRTS = 3 Then $fWORD = BitXOR($fWORD, 12288)
	If $DumpNull = 1 Then $fWORD = BitXOR($fWORD, 2048)
	If $CheckParity = 1 Then $fWORD = BitXOR($fWORD, 1026)
	If $PortType = 1 Then
		$PortType = "LPT"
	ElseIf $PortType = 0 Then
		$PortType = "COM"
	EndIf
	$hDCB_Structured = DllStructCreate(_DCB())
	$hCOMMTIMEOUTS_Structured = DllStructCreate(_COMMTIMEOUTS())
	$hOpenReturn = DllCall( $hKernel32dll, "HANDLE", "CreateFile", "str", $PortType & $PortNumber, "DWORD", $GENERIC_READ_WRITE, "DWORD", $EXCLUSIVE_ACCESS, _
							"LONG_PTR", $DEFAULT_SECURITY, "DWORD", $OPEN_EXISTING, "DWORD", $NOT_OVERLAPPED_IO, "HANDLE", $NULL_TEMPLATE)
	If $hOpenReturn[0] = Ptr(-1) Then
		If @Compiled = 0 Then ConsoleWrite("Open Comm Error" & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
	$UB = UBound($hCommResourceChannel)
	ReDim $hCommResourceChannel[$UB + 1]
	$hCommResourceChannel[$UB] = Number($hOpenReturn[0])
	$hGetCommState = DllCall($hKernel32dll,"long","GetCommState","HANDLE",$hCommResourceChannel[$UB],"ptr",DllStructGetPtr($hDCB_Structured))
	If $hGetCommState[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("GetCommState Error" & @CRLF)
		_LastErrorMessage()
		_CloseCommResourceChannel($hCommResourceChannel[$UB])
		ReDim $hCommResourceChannel[$UB - 1]
		return -1
	EndIf
	DllStructSetData($hDCB_Structured,"DCBLength", DllStructGetSize($hDCB_Structured))
	If @error And @Compiled = 0 Then ConsoleWrite("Error 1, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"BaudRate", $BaudRate) ; actual baud eg. 9600
	If @error And @Compiled = 0 Then ConsoleWrite("Error 2, " & @error & @CRLF)
	DllStructSetData( $hDCB_Structured,"fBitfields",$fWORD)
	If @error And @Compiled = 0 Then ConsoleWrite("Error 3, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"XonLim", $XonLimit) ; number of bytes allowed in buffer before flow control is activated
	If @error And @Compiled = 0 Then ConsoleWrite("Error 4, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"XoffLim", $XoffLimit) ; minimum number of free bytes allowd in input buffer before flow control is activated
	If @error And @Compiled = 0 Then ConsoleWrite("Error 5, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"ByteSize", $DataBits) ; number of bits in byte usualy 8
	If @error And @Compiled = 0 Then ConsoleWrite("Error 6, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"Parity", $Parity) ; 0/1/2/3/4 = none/odd/even/mark/space
	If @error And @Compiled = 0 Then ConsoleWrite("Error 7, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"StopBits", $StopBits) ; 0/1/2 = 1/1.5/2 number of stop bits
	If $XonChr > -1 Then DllStructSetData( $hDCB_Structured,"XonChar", $XonChr) ; the value of the xon character for TX/RX
	If @error And @Compiled = 0 Then ConsoleWrite("Error 8, " & @error & @CRLF)
	If $XoffChr > -1 Then DllStructSetData( $hDCB_Structured,"XoffChar", $XoffChr) ; the value of the xoff character for TX/RX
	If @error And @Compiled = 0 Then ConsoleWrite("Error 9, " & @error & @CRLF)
	If $ParityErrChr > -1 Then DllStructSetData( $hDCB_Structured,"ErrorChar", $ParityErrChr) ; the value of the Parity error character
	If @error And @Compiled = 0 Then ConsoleWrite("Error 10, " & @error & @CRLF)
	If $EndChr > -1 Then DllStructSetData( $hDCB_Structured,"EofChar", $EndChr) ; the value of the end of data delimiter caracter
	If @error And @Compiled = 0 Then ConsoleWrite("Error 11, " & @error & @CRLF)
	If $EventChr > -1 Then DllStructSetData( $hDCB_Structured,"EvtChar", $EventChr) ; the value of the event character
	If @error And @Compiled = 0 Then ConsoleWrite("Error 12, " & @error & @CRLF)
	$hSetCommState = DllCall($hKernel32dll,"short","SetCommState","HANDLE",$hCommResourceChannel[$UB],"ptr",DllStructGetPtr($hDCB_Structured))
	If $hSetCommState[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("SetCommState Error" & @CRLF)
		_LastErrorMessage()
		_CloseCommResourceChannel($hCommResourceChannel[$UB])
		ReDim $hCommResourceChannel[$UB - 1]
		return -1
	EndIf
	DllStructSetData($hCOMMTIMEOUTS_Structured,"ReadIntervalTimeout",-1) ; time between bytes in before ReadFile returns as completed, 0 is disable, -1 is maxword
	If @error And @Compiled = 0 Then ConsoleWrite("Error 13, " & @error & @CRLF)
	DllStructSetData($hCOMMTIMEOUTS_Structured,"ReadTotalTimeoutMultiplier",0) ; multiplied by the total requested number of bytes to read for max timeout
	If @error And @Compiled = 0 Then ConsoleWrite("Error 14, " & @error & @CRLF)
	DllStructSetData($hCOMMTIMEOUTS_Structured,"ReadTotalTimeoutConstant",0) ; added to the product of ^^
	If @error And @Compiled = 0 Then ConsoleWrite("Error 15, " & @error & @CRLF)
	DllStructSetData($hCOMMTIMEOUTS_Structured,"WriteTotalTimeoutMultiplier",0) ; multiplier for total write timeout, multiplied by number of bytes to write
	If @error And @Compiled = 0 Then ConsoleWrite("Error 16, " & @error & @CRLF)
	DllStructSetData($hCOMMTIMEOUTS_Structured,"WriteTotalTimeoutConstant",0) ; added to the product of ^^
	If @error And @Compiled = 0 Then ConsoleWrite("Error 17, " & @error & @CRLF)
	$hSetCommTimeouts = DllCall($hKernel32dll,"long","SetCommTimeouts","HANDLE",$hCommResourceChannel[$UB],"ptr",DllStructGetPtr($hCOMMTIMEOUTS_Structured))
	If $hSetCommTimeouts[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("Set Timeouts Error " & @error & @CRLF)
		_LastErrorMessage()
		_CloseCommResourceChannel($hCommResourceChannel[$UB])
		ReDim $hCommResourceChannel[$UB - 1]
		return -1
	EndIf
	If @Compiled = 0 Then
		$hGetCommState = DllCall($hKernel32dll,"long","GetCommState","HANDLE",$hCommResourceChannel[$UB],"ptr",DllStructGetPtr($hDCB_Structured))
		ConsoleWrite("Resource = " &$PortType & $PortNumber & @CRLF & "BaudRate = " & DllStructGetData($hDCB_Structured,2) & @CRLF & _
						"fBitFields = " & DllStructGetData($hDCB_Structured,3) & @CRLF & "XonLim = " & DllStructGetData($hDCB_Structured,5) & @CRLF & _
						"XoffLim = " & DllStructGetData($hDCB_Structured,6) & @CRLF & "Parity = " & DllStructGetData($hDCB_Structured,7) & @CRLF & _
						"StopBits = " & DllStructGetData($hDCB_Structured,8) & @CRLF & "ByteSize = " & DllStructGetData($hDCB_Structured,9) & @CRLF & _
						"XonChar = " & Asc(DllStructGetData($hDCB_Structured,10)) & @CRLF & "XoffChar = " & Asc(DllStructGetData($hDCB_Structured,11)) & @CRLF & _
						"ErrorChar = " & Asc(DllStructGetData($hDCB_Structured,12)) & @CRLF & "EofChar = " & Asc(DllStructGetData($hDCB_Structured,13)) & @CRLF & _
						"EvtChar = " & Asc(DllStructGetData($hDCB_Structured,14)) & @CRLF)
	EndIf
	$hSetupComm = DllCall($hKernel32dll,"long","SetupComm","HANDLE",$hCommResourceChannel[$UB],"DWORD",1024,"DWORD",1024)
	If $hSetupComm[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("Initialize Comm Error " & @error & @CRLF)
		_LastErrorMessage()
		_CloseCommResourceChannel($hCommResourceChannel[$UB])
		ReDim $hCommResourceChannel[$UB - 1]
		return -1
	EndIf
	Return $UB
EndFunc
;=============== _CommResourceUpdateChannel ============================================================================================================================
; Function Name:   	_CommResourceUpdateChannel($HandleToChannel,$BaudRate = 9600,$DataBits = 8,$Parity = 0,$StopBits = 0,$FlowCTS = 0,$FlowDSR = 0,$FlowDTR = 0, _
;											$XonXoff = 0,$FlowRTS = 0,$DumpNull = 0,$CheckParity = 0,$ParityErrChr = -1,$XonLimit = 0,$XoffLimit = 2048, _
;											$XonChr = -1,$XoffChr = -1,$EndChr = -1,$EventChr = -1)
; Description:    	change settings on an already open CommResource port
; Parameters:    	$HandleToChannel = Handle to the channel to update
;					$BaudRate = 110,300,600,1200,2400,4800,9600,14400,19200,38400,57600,115200,128000,256000 ( baud rate, dependant on hardware capabilities)
;					$DataBits = 5,6,7,8 	( data bits, *restriction* The use of 5 data bits with 2 stop bits is an invalid combination, as is 6, 7, or 8 data bits with 1.5 stop bits.)
;					$StopBits = 0,1,2 		( 0 = one stop bit, 1 = one point five stop bits, 2 = two stop bits)
;					$FlowCTS = 0,1 			( 1 = enable cts flow control)
;					$FlowDSR = 0,1 			( 1 = enable dsr flow control)
;					$FlowDTR = 0,1,2 		( 0 = disable dtr, 1 = enable dtr, 2 = handshake)
;					$XonXoff = 0,1 			( 1 = enable XonXoff (software flow control) )
;					$FlowRTS = 0,1,2,3 		( 0 = disable rts, 1 = enable rts, 2 = handshake rts, 3 = toggle rts)
;					$DumpNull = 0,1			( 0 = don't dump null character, 1 = dump null character) (when using nulls communicate with ASCII functions as null in char returns "" in autoit)
;					$CheckParity = 0,1					( 1 = enable parity checking)
;					$ParityErrChr = -1,Chr(ASCIIcode) 	( -1 sets none)
;					$XonLimit = 0 to 2048 				( The minimum number of bytes in use allowed in the input buffer before flow control is activated to allow transmission by the sender)
;					$XoffLimit = 8 - 2048	 			( The minimum number of free bytes allowed in the input buffer before flow control is activated to inhibit the sender)
;					$XonChr = -1,Chr(ASCIIcode) 		( -1 sets none)
;					$XoffChr = -1,Chr(ASCIIcode) 		( -1 sets none)
;					$EndChr = -1,Chr(ASCIIcode) 		( -1 sets none)
;					$EventChr = -1,Chr(ASCIIcode)	 	( -1 sets none)
; Returns:  on success returns 0
;           on failure returns -1 and sets $LastErrorString
; Note: will dump data in buffers
;==============================================================================================================================================================
Func _CommResourceUpdateChannel($HandleToChannel,$BaudRate = 9600,$DataBits = 8,$Parity = 0,$StopBits = 0,$FlowCTS = 0,$FlowDSR = 0,$FlowDTR = 0, _
						$XonXoff = 0,$FlowRTS = 0,$DumpNull = 0,$CheckParity = 0,$ParityErrChr = -1,$XonLimit = 0,$XoffLimit = 2048, _
						$XonChr = -1,$XoffChr = -1,$EndChr = -1,$EventChr = -1)
	Local $fWORD = 1
	If $FlowCTS = 1 Then $fWORD = BitXOR($fWORD, 4)
	If $FlowDSR = 1 Then $fWORD = BitXOR($fWORD, 8)
	If $FlowDTR = 1 Then $fWORD = BitXOR($fWORD, 16)
	If $FlowDTR = 2 Then $fWORD = BitXOR($fWORD, 32)
	If $XonXoff = 1 Then
		$fWORD = BitXOR($fWORD, 768)
	Else
		$fWORD = BitXOR($fWORD, 128)
	EndIf
	If $FlowRTS = 1 Then $fWORD = BitXOR($fWORD, 4096)
	If $FlowRTS = 2 Then $fWORD = BitXOR($fWORD, 8192)
	If $FlowRTS = 3 Then $fWORD = BitXOR($fWORD, 12288)
	If $DumpNull = 1 Then $fWORD = BitXOR($fWORD, 2048)
	If $CheckParity = 1 Then $fWORD = BitXOR($fWORD, 1026)
	$hDCB_Structured = DllStructCreate(_DCB())
	$hGetCommState = DllCall($hKernel32dll,"long","GetCommState","HANDLE",$HandleToChannel,"ptr",DllStructGetPtr($hDCB_Structured))
	If $hGetCommState[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("GetCommState Error" & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
	If @error And @Compiled = 0 Then ConsoleWrite("Error 18, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"DCBLength", DllStructGetSize($hDCB_Structured))
	If @error And @Compiled = 0 Then ConsoleWrite("Error 19, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"BaudRate", $BaudRate) ; actual baud eg. 9600
	If @error And @Compiled = 0 Then ConsoleWrite("Error 20, " & @error & @CRLF)
	DllStructSetData( $hDCB_Structured,"fBitfields",$fWORD)
	If @error And @Compiled = 0 Then ConsoleWrite("Error 21, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"XonLim", $XonLimit) ; number of bytes allowed in buffer before flow control is activated
	If @error And @Compiled = 0 Then ConsoleWrite("Error 22, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"XoffLim", $XoffLimit) ; minimum number of free bytes allowd in input buffer before flow control is activated
	If @error And @Compiled = 0 Then ConsoleWrite("Error 23, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"ByteSize", $DataBits) ; number of bits in byte usualy 8
	If @error And @Compiled = 0 Then ConsoleWrite("Error 24, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"Parity", $Parity) ; 0/1/2/3/4 = none/odd/even/mark/space
	If @error And @Compiled = 0 Then ConsoleWrite("Error 25, " & @error & @CRLF)
	DllStructSetData($hDCB_Structured,"StopBits", $StopBits) ; 0/1/2 = 1/1.5/2 number of stop bits
	If $XonChr > -1 Then DllStructSetData( $hDCB_Structured,"XonChar", $XonChr) ; the value of the xon character for TX/RX
	If @error And @Compiled = 0 Then ConsoleWrite("Error 26, " & @error & @CRLF)
	If $XoffChr > -1 Then DllStructSetData( $hDCB_Structured,"XoffChar", $XoffChr) ; the value of the xoff character for TX/RX
	If @error And @Compiled = 0 Then ConsoleWrite("Error 27, " & @error & @CRLF)
	If $ParityErrChr > -1 Then DllStructSetData( $hDCB_Structured,"ErrorChar", $ParityErrChr) ; the value of the Parity error character
	If @error And @Compiled = 0 Then ConsoleWrite("Error 28, " & @error & @CRLF)
	If $EndChr > -1 Then DllStructSetData( $hDCB_Structured,"EofChar", $EndChr) ; the value of the end of data delimiter caracter
	If @error And @Compiled = 0 Then ConsoleWrite("Error 29, " & @error & @CRLF)
	If $EventChr > -1 Then DllStructSetData( $hDCB_Structured,"EvtChar", $EventChr) ; the value of the event character
	If @error And @Compiled = 0 Then ConsoleWrite("Error 30, " & @error & @CRLF)
	$hSetCommState = DllCall($hKernel32dll,"short","SetCommState","HANDLE",$HandleToChannel,"ptr",DllStructGetPtr($hDCB_Structured))
	If $hSetCommState[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("SetCommState Error" & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
	If @Compiled = 0 Then
		$hGetCommState = DllCall($hKernel32dll,"long","GetCommState","HANDLE",$HandleToChannel,"ptr",DllStructGetPtr($hDCB_Structured))
		ConsoleWrite("*UPDATE*" & @CRLF & "BaudRate = " & DllStructGetData($hDCB_Structured,2) & @CRLF & "fBitFields = " & DllStructGetData($hDCB_Structured,3) & @CRLF & _
						"XonLim = " & DllStructGetData($hDCB_Structured,5) & @CRLF & "XoffLim = " & DllStructGetData($hDCB_Structured,6) & @CRLF & _
						"Parity = " & DllStructGetData($hDCB_Structured,7) & @CRLF & "StopBits = " & DllStructGetData($hDCB_Structured,8) & @CRLF & _
						"ByteSize = " & DllStructGetData($hDCB_Structured,9) & @CRLF & "XonChar = " & DllStructGetData($hDCB_Structured,10) & @CRLF & _
						"XoffChar = " & DllStructGetData($hDCB_Structured,11) & @CRLF & "ErrorChar = " & DllStructGetData($hDCB_Structured,12) & @CRLF & _
						"EofChar = " & DllStructGetData($hDCB_Structured,13) & @CRLF & "EvtChar = " & DllStructGetData($hDCB_Structured,14) & @CRLF)
	EndIf
	$hSetupComm = DllCall($hKernel32dll,"long","SetupComm","HANDLE",$HandleToChannel,"DWORD",1024,"DWORD",1024)
	If $hSetupComm[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("Initialize Comm Error " & @error & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
EndFunc
;=============== _CommResourceReadASCII =============================================================================================================================
; Function Name:   	_CommResourceReadASCII($ChannelHandle)
; Description:    	reads a single ascii code byte from the input buffer
; Parameters:    	$HandleToChannel = Handle to the channel to communicate with
; Returns:  an ascii code value (0 - 255)
;           on empty returns -1
;    		on failure returns -2 and sets $LastErrorString
; Note:
;==============================================================================================================================================================
Func _CommResourceReadASCII($ChannelHandle)
	Local $ReturnVal = -1
	local $hBytesRXed_Structure = DllStructCreate("long_ptr lpNumberOfBytesRead")
	$hDllReturn = DllCall($hKernel32dll,"int","ReadFile","HANDLE",$ChannelHandle, _
							"str","", _
							"DWORD",1, _
							"long_ptr",DllStructGetPtr($hBytesRXed_Structure), _
							"ptr","")
	If $hDllReturn[0] = 0 Then
		_LastErrorMessage()
		Return -2
	EndIf
	$RX_Length = DllStructGetData($hBytesRXed_Structure,"lpNumberOfBytesRead")
	If $RX_Length >= 1 Then
		$ReturnVal = Asc($hDllReturn[2])
		If @Compiled = 0 And $ConsoleWriteRX = 1 Then ConsoleWrite("Byte Rxed = [" & $ReturnVal & "] Length = [" & $RX_Length & "]" & @CRLF)
	EndIf
	Return $ReturnVal
EndFunc
;=============== _CommResourceReadASCIIArray =============================================================================================================================
; Function Name:   	_CommResourceReadASCIIArray($ChannelHndl,$EndDelimiter,$Timeout = 0,$Maxbytes = 0)
; Description:    	reads an ASCII code array from the input buffer
; Parameters:    	$ChannelHndl = Handle to the channel to communicate with
;					$EndDelimiter = the ascii code for the end of string value
;					$Timeout = time in milliseconds to check for data before returning and setting @error, 0 disables (with 0 can hang in loop until end of string rxed)
;					$Maxbytes = maximum number of bytes before returning and setting @error, 0 disables (with 0 can hang in loop until end of string rxed)
; Returns:  an Array containing the received string in ascii code
;           on empty returns -1 in element 0
;			sets @error to -1 on a timeout
;			sets @error to -2 when string exceeds maxbytes
; Note:
;==============================================================================================================================================================
Func _CommResourceReadASCIIArray($ChannelHndl,$EndDelimiter,$Timeout = 0,$Maxbytes = 0)
	Local $RxArray[1]
	$RxArray[0] = -1
	$Wait = TimerInit()
	$hKernel32dll = DllOpen("kernel32.dll")
	Do
		$byte = _CommResourceReadASCII($ChannelHndl)
		If $byte = -1 Then
			Sleep(10)
		Else
			$UB = UBound($RxArray)
			$RxArray[$UB - 1] = $byte
			If $byte <> $EndDelimiter Then ReDim $RxArray[$UB + 1]
		EndIf
		If TimerDiff($Wait) >= $Timeout And $Timeout > 0 Then
			SetError(-1)
			Return $RxArray
		EndIf
		If UBound($RxArray) >= $Maxbytes And $Maxbytes > 0 Then
			SetError(-2)
			Return $RxArray
		EndIf
	Until $byte = $EndDelimiter
	DllClose($hKernel32dll)
	$hKernel32dll = "kernel32.dll"
	Return $RxArray
EndFunc
;=============== _CommResourceSendASCIIArray =============================================================================================================================
; Function Name:   	_CommResourceSendASCIIArray($CommResourceChannel,ByRef $AscArray)
; Description:    	sends an ASCII code array to the output buffer
; Parameters:    	$CommResourceChannel = Handle to the channel to communicate with
;					$AscArray = the array to send
; Returns:
;			-1 on failure and sets $LastErrorString
; Note:
;==============================================================================================================================================================
Func _CommResourceSendASCIIArray($CommResourceChannel,ByRef $AscArray)
	local $hBytesWritten = DllStructCreate("long_ptr lpNumberOfBytesWritten")
	$UB = UBound($AscArray)
	$Count = 0
	$hKernel32dll = DllOpen("kernel32.dll")
	Do
		$hDllReturn = DllCall($hKernel32dll,"int","WriteFile","HANDLE",$CommResourceChannel, _
						"str",Chr($AscArray[$Count]), _
						"int",1, _
						"long_ptr", DllStructGetPtr($hBytesWritten), _
						"ptr", "")
		If $hDllReturn[0] = 0 Then
			_LastErrorMessage()
			DllClose($hKernel32dll)
			$hKernel32dll = "kernel32.dll"
			Return -1
		EndIf
		$Count += 1
	Until $Count = $UB
	DllClose($hKernel32dll)
	$hKernel32dll = "kernel32.dll"
EndFunc
;=============== _CommResourceReadChar =============================================================================================================================
; Function Name:   	_CommResourceReadChar($ChannelHandle)
; Description:    	reads a single character from the input buffer
; Parameters:    	$HandleToChannel = Handle to the channel to communicate with
; Returns:  an ANSI character
;           on empty returns -1
;			on failure returns -2 and sets $LastErrorString
; Note: nulls are returned as "", suggested to use _CommResourceReadASCII when nulls are required which will return 0 on a null
;==============================================================================================================================================================
Func _CommResourceReadChar($ChannelHandle)
	Local $ReturnVal = -1
	local $hBytesRXed_Structure = DllStructCreate("long_ptr lpNumberOfBytesRead")
	$hDllReturn = DllCall($hKernel32dll,"int","ReadFile","HANDLE",$ChannelHandle, _
							"str","", _
							"DWORD",1, _
							"long_ptr",DllStructGetPtr($hBytesRXed_Structure), _
							"ptr","")
	If $hDllReturn[0] = 0 Then
		_LastErrorMessage()
		Return -2
	EndIf
	$RX_Length = DllStructGetData($hBytesRXed_Structure,"lpNumberOfBytesRead")
	If $RX_Length >= 1 Then
		$ReturnVal = $hDllReturn[2]
		If @Compiled = 0 And $ConsoleWriteRX = 1 Then ConsoleWrite("Byte Rxed = [" & $ReturnVal & "] Length = [" & $RX_Length & "]" & @CRLF)
	EndIf
	Return $ReturnVal
EndFunc
;=============== _CommResourceReadLine =============================================================================================================================
; Function Name:   	_CommResourceReadLine($ChannelHndl,$EndDelimiter,$Timeout = 0,$Maxbytes = 0)
; Description:    	reads an ANSII string from the input buffer
; Parameters:    	$ChannelHndl = Handle to the channel to communicate with
;					$EndDelimiter = character for the end of string value
;					$Timeout = time in milliseconds to check for data before returning and setting @error, 0 disables (with 0 can hang in loop until end of string rxed)
;					$Maxbytes = maximum number of bytes before returning and setting @error, 0 disables (with 0 can hang in loop until end of string rxed)
; Returns:  an ANSII string from the input buffer
;           on empty returns ""
;			sets @error to -1 on a timeout
;			sets @error to -2 when string exceeds maxbytes
;			-1 on failure and sets $LastErrorString
; Note: nulls are returned as "", suggested to use _CommResourceReadASCIIArray when nulls are required which will return 0 on a null
;==============================================================================================================================================================
Func _CommResourceReadLine($ChannelHndl,$EndDelimiter,$Timeout = 0,$Maxbytes = 0)
	Local $RxLine
	$Wait = TimerInit()
	$hKernel32dll = DllOpen("kernel32.dll")
	Do
		$byte = _CommResourceReadChar($ChannelHndl)
		If $byte = -1 Then
			Sleep(10)
		ElseIf $byte = -2 Then
			_LastErrorMessage()
			DllClose($hKernel32dll)
			$hKernel32dll = "kernel32.dll"
			Return -1
		Else
			$RxLine &= $byte
		EndIf
		If TimerDiff($Wait) >= $Timeout And $Timeout > 0 Then
			SetError(-1)
			Return $RxLine
		EndIf
		If StringLen($RxLine) >= $Maxbytes And $Maxbytes > 0 Then
			SetError(-2)
			Return $RxLine
		EndIf
	Until $byte = $EndDelimiter
	DllClose($hKernel32dll)
	$hKernel32dll = "kernel32.dll"
	Return $RxLine
EndFunc
;=============== _CommResourceSendLine =============================================================================================================================
; Function Name:   	_CommResourceSendLine($CommResourceChannel, $Line)
; Description:    	sends a string to the output buffer
; Parameters:    	$CommResourceChannel = Handle to the channel to communicate with
;					$Line = the string to send
; Returns:
;			-1 on failure and sets $LastErrorString
; Note: can send single characters or any string.
;==============================================================================================================================================================
Func _CommResourceSendLine($CommResourceChannel, $Line)
	local $hBytesWritten = DllStructCreate("long_ptr lpNumberOfBytesWritten")
	local $hDllReturn = DllCall($hKernel32dll,"int","WriteFile","HANDLE",$CommResourceChannel, _
						"str",$Line, _
						"int",StringLen($Line), _
						"long_ptr", DllStructGetPtr($hBytesWritten), _
						"ptr", "")
	If $hDllReturn[0] = 0 Then
		_LastErrorMessage()
		Return -1
	EndIf
EndFunc
;=============== _CommResourceClearBuffer =============================================================================================================================
; Function Name:   	_CommResourceClearBuffer($Handle,$RxOrTx = 2)
; Description:    	Clears comm port buffers
; Parameters:    	$Handle = Handle to the channel to communicate with
;					$RxOrTx = 0,1,2 (0 = tx buffer, 1 = rx buffer, 2 = both buffers)
; Returns:
;			-1 on failure and sets $LastErrorString
; Note:
;==============================================================================================================================================================
Func _CommResourceClearBuffer($Handle,$RxOrTx = 2)
	If $RxOrTx = 0 Then $RxOrTx = 5 ; clear tx
	If $RxOrTx = 1 Then $RxOrTx = 10 ; clear rx
	If $RxOrTx = 2 Then $RxOrTx = 15 ; clear both
	$hPurgeComm = DllCall($hKernel32dll, "int", "PurgeComm", "HANDLE", $Handle,"DWORD",$RxOrTx)
	If $hPurgeComm[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("Clear Comm Error " & @error & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
EndFunc
;=============== _RefreshCommResourceChannel =============================================================================================================================
; Function Name:   	_RefreshCommResourceChannel($Handle)
; Description:    	Refreshes a comm port
; Parameters:    	$Handle = Handle to the channel to communicate with
; Returns:
;			-1 on failure and sets $LastErrorString
; Note: will dump input/output buffers
;==============================================================================================================================================================
Func _RefreshCommResourceChannel($Handle)
	$hSetupComm = DllCall($hKernel32dll,"long","SetupComm","HANDLE",$Handle,"DWORD",1024,"DWORD",1024)
	If $hSetupComm[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("Refresh Comm Error " & @error & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
EndFunc
;=============== _CommResourceBufferQues =============================================================================================================================
; Function Name:   	_CommResourceBufferQues($ChannelHandle)
; Description:    	gets amount of bytes in input/output buffers
; Parameters:    	$ChannelHandle = Handle to the channel to communicate with
; Returns:		on success returns an array containing amount of bytes in buffers, element 0 for rx, element 1 for tx
;				-1 on failure and sets $LastErrorString
; Note:
;==============================================================================================================================================================
Func _CommResourceBufferQues($ChannelHandle)
	$_COMSTAT = DllStructCreate(_COMSTAT())
	$hDllReturn = DllCall($hKernel32dll,"DWORD","ClearCommError","HANDLE",$ChannelHandle,"DWORD","","DWORD",DllStructGetPtr($_COMSTAT))
	If $hDllReturn[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("ClearCommError  Error " & @error & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
	Local $ReturnVal[2]
	$ReturnVal[0] = DllStructGetData($_COMSTAT,2)
	$ReturnVal[1] = DllStructGetData($_COMSTAT,3)
	Return $ReturnVal
EndFunc
;=============== _CloseCommResourceChannel =============================================================================================================================
; Function Name:   	_CloseCommResourceChannel($Channel)
; Description:    	Closes a comm port
; Parameters:    	$Channel = Handle to the channel to communicate with
; Returns:
;			-1 on failure and sets $LastErrorString
; Note:
;==============================================================================================================================================================
Func _CloseCommResourceChannel($Channel)
	local $hCloseAtttemt = DllCall($hKernel32dll, "int", "CloseHandle", "HANDLE", $Channel)
	If $hCloseAtttemt[0] = 0 Then
		If @Compiled = 0 Then ConsoleWrite("Close Comm Error " & @error & @CRLF)
		_LastErrorMessage()
		return -1
	EndIf
EndFunc
;=============== _CloseAllCommResourceChannels =============================================================================================================================
; Function Name:   	_CloseAllCommResourceChannels()
; Description:    	Closes all comm ports
; Parameters:
; Returns:
;			-1 on failure and sets $LastErrorString
; Note:
;==============================================================================================================================================================
Func _CloseAllCommResourceChannels()
	$UB = UBound($hCommResourceChannel)
	$Count = 1
	Do
		If _CloseCommResourceChannel($hCommResourceChannel[$Count]) = -1 Then Return -1
		$Count += 1
	Until $Count = $UB
	ReDim $hCommResourceChannel[1]
EndFunc
;=============== _LastErrorMessage =============================================================================================================================
; Function Name:   	_LastErrorMessage()
; Description:    	gets the last error code for the this thread from kernel32.dll and formats the message to a string
;					both returns the string and stores it in the global variable $LastErrorString (plus writes to console when not compiled)
; Parameters:
; Returns:			on success the last error string
;					on failure -1
; Note:
;==============================================================================================================================================================
Func _LastErrorMessage()
	$ErrorCode = DllCall($hKernel32dll,"DWORD","GetLastError")
	$hDllReturn = DllCall($hKernel32dll,"DWORD","FormatMessage","DWORD",4608,"DWORD","","DWORD",$ErrorCode[0],"DWORD",0,"str","","DWORD",256,"DWORD","")
	If @Compiled = 0 Then ConsoleWrite("Error " & $ErrorCode[0] & ", " & $hDllReturn[5] & @CRLF)
	If $hDllReturn[0] > 0 Then
		$LastErrorString = "Error " & $ErrorCode[0] & ", " & $hDllReturn[5]
		Return "Error " & $ErrorCode[0] & ", " & $hDllReturn[5]
	EndIf
	Return -1
EndFunc
;=============== _ListSerialPorts() =============================================================================================================================
; Function Name:   	_ListSerialPorts()
; Description:    	returns a string containing all installed serial devices
; Parameters:
; Returns:			a string in the format of "COM1|COM2|COM3 (In Use)"
;					if no installed serial devices returns ""
; Note:
;==============================================================================================================================================================
Func _ListSerialPorts()
	Local Const $GENERIC_READ_WRITE = 0xC0000000
	Local Const $EXCLUSIVE_ACCESS = 0
	Local Const $DEFAULT_SECURITY = ""
	Local Const $OPEN_EXISTING = 3
	Local Const $NOT_OVERLAPPED_IO = 0
	Local Const $NULL_TEMPLATE = ""
	Local $HKLM
	If @OSArch = "X86" Then $HKLM = "HKLM"
	If @OSArch = "X64" Then $HKLM = "HKLM64"
	$key = $HKLM & "\HARDWARE\DEVICEMAP\SERIALCOMM"
	$val = "\Device\Serial"
	$Nmbr = 0
	$ReturnVal = ""
	While 1
		$read = RegRead($key,$val&$Nmbr)
		If $read = "" Then ExitLoop
		If Not $ReturnVal = "" Then $ReturnVal &= "|"
		$read = StringRegExp($read,"(?:.*)(COM\d{1,3})(?:.*)",3)
		If IsArray($read) Then
			$ReturnVal &= $read[0]
			$hOpenReturn = DllCall( $hKernel32dll, "HANDLE", "CreateFile", "str", $read[0], "DWORD", $GENERIC_READ_WRITE, "DWORD", $EXCLUSIVE_ACCESS, _
							"LONG_PTR", $DEFAULT_SECURITY, "DWORD", $OPEN_EXISTING, "DWORD", $NOT_OVERLAPPED_IO, "HANDLE", $NULL_TEMPLATE)
			If $hOpenReturn[0] = Ptr(-1) Then
				$ReturnVal &= " (In Use)"
			Else
				$hCloseAtttemt = DllCall($hKernel32dll, "int", "CloseHandle", "HANDLE", $hOpenReturn[0])
			EndIf
		EndIf
		$Nmbr += 1
	WEnd
	Return $ReturnVal
EndFunc
;=============== _ListParallelPorts() =============================================================================================================================
; Function Name:   	_ListParallelPorts()
; Description:    	returns a string containing all installed parallel devices
; Parameters:
; Returns:			a string in the format of "LPT1|LPT2|LPT3 (In Use)"
;					if no installed parallel devices returns ""
; Note:
;==============================================================================================================================================================
Func _ListParallelPorts()
	Local Const $GENERIC_READ_WRITE = 0xC0000000
	Local Const $EXCLUSIVE_ACCESS = 0
	Local Const $DEFAULT_SECURITY = ""
	Local Const $OPEN_EXISTING = 3
	Local Const $NOT_OVERLAPPED_IO = 0
	Local Const $NULL_TEMPLATE = ""
	Local $HKLM
	If @OSArch = "X86" Then $HKLM = "HKLM"
	If @OSArch = "X64" Then $HKLM = "HKLM64"
	$key = $HKLM & "\HARDWARE\DEVICEMAP\PARALLEL PORTS"
	$val = "\Device\Parallel"
	$Nmbr = 0
	$ReturnVal = ""
	While 1
		$read = RegRead($key,$val&$Nmbr)
		If $read = "" Then ExitLoop
		If Not $ReturnVal = "" Then $ReturnVal &= "|"
		$read = StringRegExp($read,"(?:.*)(LPT\d{1,3})(?:.*)",3)
		If IsArray($read) Then
			$ReturnVal &= $read[0]
			$hOpenReturn = DllCall( $hKernel32dll, "HANDLE", "CreateFile", "str", $read[0], "DWORD", $GENERIC_READ_WRITE, "DWORD", $EXCLUSIVE_ACCESS, _
							"LONG_PTR", $DEFAULT_SECURITY, "DWORD", $OPEN_EXISTING, "DWORD", $NOT_OVERLAPPED_IO, "HANDLE", $NULL_TEMPLATE)
			If $hOpenReturn[0] = Ptr(-1) Then
				$ReturnVal &= " (In Use)"
			Else
				$hCloseAtttemt = DllCall($hKernel32dll, "int", "CloseHandle", "HANDLE", $hOpenReturn[0])
			EndIf
		EndIf
		$Nmbr += 1
	WEnd
	Return $ReturnVal
EndFunc

; ####*END*##########################################################################################################################################################