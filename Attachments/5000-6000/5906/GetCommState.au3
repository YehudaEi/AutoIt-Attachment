#include <GUIConstants.au3>
#include <string.au3>

Global $DCBlength
Global $Comport
$FileAttributeNormal = 128 ; h80
$GenericWrite = 2147483648 ; h800000000
$null = 0
$OpenExisting = 3
$Comport  = "Com1"

; Create window
GUICreate("Digital Accuisition System", 500, 500) 
		$Dll = DllOpen("kernel32.dll")		
; CreateFile for COMx
		$result = dllcall ($dll, "int", "CreateFile", "str", $comport, "long", $GenericWrite , "long" , $null, "long", $null, "long" , $OpenExisting, "long" ,$FileAttributeNormal, "long" , $null)
		$hwnd = $result[0]		
; Create the Struct (DCB in MSDN)
		$DCB = DLLStructCreate("DWord;Dword;Dword;Dword;Dword;Dword;DWord;DWord;DWord;DWord;DWord;DWord;DWord;DWord;DWord;DWord;short;short;short;Byte;Byte;Byte;Char;Char;Char;Char;Char;short")
		$ret = DllStructSetData($DCB, 1, DllStructGetSize($DCB))
; GetCommState
		$ret = dllcall ($dll, "int", "GetCommState", "hwnd", $hwnd, "ptr", DllStructGetPtr($DCB))		
; Get the returned DCB
		$DCBlength = DllStructGetData($DCB,1)
		$Baudrate = DllStructGetData($DCB,2)
		$fBinary = DllStructGetData($DCB,3)
		$fParity = DllStructGetData($DCB,4)
		$fOutxCTSFlow = DllStructGetData($DCB,5)
		$fOutxDSRFlow = DllStructGetData($DCB,6)
		$fDTRControl = DllStructGetData($DCB,7)
		$fDsrSensitivity = DllStructGetData($DCB,8)
		$fTXContinueOnXoff = DllStructGetData($DCB,9)
		$fOutX = DllStructGetData($DCB,10)
		$fInX = DllStructGetData($DCB,11)
		$fErrorChar = DllStructGetData($DCB,12)
		$fNull = DllStructGetData($DCB,13)
		$fRTSControl = DllStructGetData($DCB,14)
		$fAbortOnError = DllStructGetData($DCB,15)
		$Dymmy2 = DllStructGetData($DCB,16)
		$wReserved = DllStructGetData($DCB,17)
		$XonLim = DllStructGetData($DCB,18)
		$XoffLim = DllStructGetData($DCB,19)
		$ByteSize = DllStructGetData($DCB,20)
		$Parity = DllStructGetData($DCB,21)
		$Stopbits = DllStructGetData($DCB,22)
		$XonChar = DllStructGetData($DCB,23)
		$XoffChar = DllStructGetData($DCB,24)
		$ErrorChar = DllStructGetData($DCB,25)
		$EofChar = DllStructGetData($DCB,26)
		$EvtChar = DllStructGetData($DCB,27)
		$wReserved = DllStructGetData($DCB,28)

; Show Struct
		MsgBox(0,"DCB Structure", _
		"DCBlength" & " " & DllStructGetData($DCB,1) &  @CRLF & _ 
		"Baudrate" &  " " & DllStructGetData($DCB,2) &  @CRLF & _
		"fBinary" &  " " & DllStructGetData($DCB,3) &  @CRLF & _
		"fParity" &  " " & DllStructGetData($DCB,4) &  @CRLF & _
		"fOutxCTSFlow" &  " " & DllStructGetData($DCB,5) &  @CRLF & _
		"fOutxDSRFlow" &  " " & DllStructGetData($DCB,6) &  @CRLF & _
		"fDTRControl" &  " " & DllStructGetData($DCB,7) &  @CRLF & _
		"fDsrSensitivity" &  " " & DllStructGetData($DCB,8) &  @CRLF & _
		"fTXContinueOnXoff" &  " " & DllStructGetData($DCB,9) &  @CRLF & _
		"fOutX" &  " " & DllStructGetData($DCB,10) &  @CRLF & _
		"fInX" &  " " & DllStructGetData($DCB,11) &  @CRLF & _
		"fErrorChar" &  " " & DllStructGetData($DCB,12) &  @CRLF & _
		"fNull" &  " " & DllStructGetData($DCB,13) &  @CRLF & _
		"fRTSControl" &  " " & DllStructGetData($DCB,14) &  @CRLF & _
		"fAbortOnError" &  " " & DllStructGetData($DCB,15) &  @CRLF & _
		"Dymmy2" &  " " & DllStructGetData($DCB,16) &  @CRLF & _
		"wReserved" &  " " & DllStructGetData($DCB,17) &  @CRLF & _
		"XonLim" &  " " & DllStructGetData($DCB,18) &  @CRLF & _
		"XoffLim" &  " " & DllStructGetData($DCB,19) &  @CRLF & _
		"ByteSize" &  " " & DllStructGetData($DCB,20) &  @CRLF & _
		"Parity" &  " " & DllStructGetData($DCB,21) &  @CRLF & _
		"Stopbits" &  " " & DllStructGetData($DCB,22) &  @CRLF & _
		"XonChar" &  " " & DllStructGetData($DCB,23) &  @CRLF & _
		"XoffChar" &  " " & DllStructGetData($DCB,24) &  @CRLF & _
		"ErrorChar" &  " " & DllStructGetData($DCB,25) &  @CRLF & _
		"EofChar" &  " " & DllStructGetData($DCB,26) &  @CRLF & _
		"EvtChar" &  " " & DllStructGetData($DCB,27) &  @CRLF & _
		"wReserved" &  " " & DllStructGetData($DCB,28))
; Free the struct
$DCB = 0
dllclose($dll)
Exit
