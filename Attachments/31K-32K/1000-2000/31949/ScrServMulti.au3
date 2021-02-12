
#Region header and includes

;#include <ScreenCapture.au3>

#include "GDIPlus.au3"
#include "WinAPI.au3"
HotKeySet('{end}', 'bb')

#EndRegion header and includes
; header and includes


#region
Opt("TrayMenuMode",1)

$accept = TrayCreateItem("Accept Incoming")
TrayCreateItem("")
$stop = TrayCreateItem("Stop Connection")
TrayCreateItem("")
$close = TrayCreateItem("Close")

#endregion


#Region Tune it here
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Global $nPORT = 80 ; 1-(255*255)
Global $MAX_CONNECTIONS = 3 ; 1-10? limited by network bandwith
Global $JPEG_SIZE = 0.5 ; 0.01-1
Global $JPEG_QUALITY = 80 ; 1-100%
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#EndRegion FEEL FREE TO CHANGE THIS
; Settings



#Region TCP Globals
;@@@@@@@@@@@@@@@@@@@@@@@
Global $szIPADDRESS = @IPAddress1
Global $MainSocket=-1, $ConnectedSocket
Global $recv
Global $SOC_DB[$MAX_CONNECTIONS]
Global $CONNECTED = 0
$MAX_CONNECTIONS -= 1
For $i = 0 To $MAX_CONNECTIONS
	$SOC_DB[$i] = 0
Next
Global $TCP_ConnectTimer = TimerInit()
;@@@@@@@@@@@@@@@@@@@@@@@
#EndRegion TCP Globals
; TCP



#Region Streaming initialise
;@@@@@@@@@@@@@@@@@@@@@@@
Global $iW = _WinAPI_GetSystemMetrics(78) + 1
Global $iH = _WinAPI_GetSystemMetrics(79) + 1
Global $iWa = $iW * $JPEG_SIZE
Global $iHa = $iH * $JPEG_SIZE
Global $fTmp = @TempDir & "\tmp.jpg"
Global $_hWnd = _WinAPI_GetDesktopWindow()
Global $_hDDC = _WinAPI_GetDC($_hWnd)
_GDIPlus_Startup()
Global $_sCLSID = _GDIPlus_EncodersGetCLSID('jpg')

; set paremeters for compression
Global $_GtParams = _GDIPlus_ParamInit(1)
Global $_GtData = DllStructCreate("int Quality")
DllStructSetData($_GtData, "Quality", $JPEG_QUALITY)
_GDIPlus_ParamAdd($_GtParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, DllStructGetPtr($_GtData))
Global $_GpParams = DllStructGetPtr($_GtParams)
;@@@@@@@@@@@@@@@@@@@@@@@
#EndRegion Streaming initialise
; Streaming



#Region Main Loop
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
TCP_init()
AdlibRegister('TCP_LOOP', 100); has to be large enough to let enything else to execute in between
Func TCP_LOOP()
	$ConnectedSocket = TCPAccept($MainSocket)
	If $ConnectedSocket == -1 Then Return
	c('Connect request')
	$recv = TCPRecv($ConnectedSocket, 3)
	If $recv == '' Then Return
	c('Connect request receved')
	If $recv == 'GET' Then
		$free = TCP_getFreeSoc()
		If $free == -1 Then
			c('No more connections available')
			TCP_respond_full($ConnectedSocket)
			Return
		EndIf
		If TimerDiff($TCP_ConnectTimer) < 5000 Then
			c('Connecting too often.')
			TCP_Send_HTML($ConnectedSocket, "Try Connecting again in 5 sec.")
			Return
		EndIf
		c(Stream_init($ConnectedSocket))
		c(TCP_Add($ConnectedSocket, $free))
	EndIf
EndFunc   ;==>TCP_LOOP

While True
	$msg = TrayGetMsg()
    Select
        Case $msg = $accept
            TCP_init()
        Case $msg = $stop
            TCP_Exit()
        Case $msg = $close
            bb()
    EndSelect

	Stream_Send()
WEnd
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#EndRegion Main Loop
; Main



#Region TCP functions
Func TCP_init()
	if $MainSocket<>-1 then TCP_Exit()
	For $i = 0 To $MAX_CONNECTIONS
		$SOC_DB[$i] = 0
	Next
	TCPStartup()
	$MainSocket = TCPListen($szIPADDRESS, $nPORT)
	If $MainSocket = -1 Then Exit
	$ConnectedSocket = -1
EndFunc   ;==>TCP_init

Func TCP_Add($soc,$free)
	$SOC_DB[$free] = $soc
	SetError(0)
	Return 'Added Socket index: ' & $free
EndFunc   ;==>TCP_Add

Func TCP_SendToAll(ByRef $Packet)
	For $i = 0 To $MAX_CONNECTIONS
		If $SOC_DB[$i] <> 0 Then
			TCPSend($SOC_DB[$i], $Packet)
			If @error Then c(TCP_Drop($i))
		EndIf
	Next
EndFunc   ;==>TCP_SendToAll

func TCP_RecvFromAll()
	For $i = 0 To $MAX_CONNECTIONS
		If $SOC_DB[$i] <> 0 Then
			TCPRecv($SOC_DB[$i] , 1024)
			If @error Then c(TCP_Drop($i))
		EndIf
	Next
EndFunc

Func TCP_Respond_Full(ByRef $soc)
	; let it talk
	while TCPRecv($soc, 10240)
		sleep(10)
	WEnd
	Local $Packet = Binary("HTTP/1.1 200 OK" & @CRLF & _
			"Connection: close" & @CRLF & _
			"Content-Type: text/html" & @CRLF & _
			@CRLF & _
			"<br><br><center><h2>" & $MAX_CONNECTIONS + 1 & " available connections are bizzy.</h2></center>" & @CRLF)
	TCPSend($soc, $Packet)
	TCPCloseSocket($soc)
EndFunc   ;==>TCP_Respond_Full

Func TCP_Send_HTML(ByRef $soc, $HTML)
	while TCPRecv($soc, 10240)
		sleep(10)
	WEnd
	Local $Packet = Binary("HTTP/1.1 200 OK" & @CRLF & _
			"Connection: close" & @CRLF & _
			"Content-Type: text/html" & @CRLF & _
			@CRLF & _
			"<br><br><center><h2>" & $HTML & "</h1></center>" & @CRLF)
	TCPSend($soc, $Packet)
	TCPCloseSocket($soc)
EndFunc   ;==>TCP_Send_HTML

Func TCP_Drop($soc_index)
	If $SOC_DB[$soc_index] == 0 Then
		SetError(1)
		Return 'Socket is invalid'
	EndIf
	TCPCloseSocket($SOC_DB[$soc_index])
	$SOC_DB[$soc_index] = 0
	$TCP_ConnectTimer = TimerInit()
	SetError(0)
	Return 'Droped Socket index: ' & $soc_index
EndFunc   ;==>TCP_Drop

func TCP_Exit()
	For $i = 0 To $MAX_CONNECTIONS
		If $SOC_DB[$i] <> 0 Then
			c(TCP_Drop($i))
		EndIf
	Next
	TCPShutdown()
	$MainSocket = -1
Endfunc

#EndRegion TCP functions
; TCP


#Region TCP math functions
Func TCP_getFreeSoc()
	Local $i = 0
	While $i <= $MAX_CONNECTIONS
		If $SOC_DB[$i] == 0 Then Return $i
		$i += 1
	WEnd
	Return -1
EndFunc   ;==>TCP_getFreeSoc

Func countConnected()
	Local $i = 0
	Local $num = 0
	While $i <= $MAX_CONNECTIONS
		If $SOC_DB[$i] <> 0 Then $num += 1
		$i += 1
	WEnd
	Return $num
EndFunc   ;==>countConnected

Func isConnected()
	Local $i = 0
	While $i <= $MAX_CONNECTIONS
		If $SOC_DB[$i] <> 0 Then Return 1
		$i += 1
	WEnd
	Return 0
EndFunc   ;==>isConnected

#EndRegion TCP math functions
; TCP


#Region Streaming functions
Func Stream_Init(ByRef $soc)
	while TCPRecv($soc, 10240)
		sleep(10)
	WEnd
	$Packet = Binary("HTTP/1.1 200 OK" & @CRLF & _
			"Connection: close" & @CRLF & _
			"Content-Type: multipart/x-mixed-replace;boundary=myboundary" & @CRLF & _
			@CRLF & _
			"--myboundary" & @CRLF)
	TCPSend($soc, $Packet)
	If @error Then
		Return 'Failed to initialise a stream'
	Else
		Return 'New stream started'
	EndIf
EndFunc   ;==>Stream_Init

Func Stream_Send()
	If Not isConnected() Then
		Sleep(100)
		Return
	EndIf
	captureToFile() ; function takes all the time in the world to run
	$Packet = Binary("Content-Type: image/jpeg" & @CRLF & _
			@CRLF & _
			FileRead($fTmp) & _
			@CRLF & _
			"--myboundary" & @CRLF)

	TCP_SendToAll($Packet)
EndFunc   ;==>Stream_Send

Func captureToFile()

	; Capture
	Local $hHBITMAP = _WinAPI_CreateCompatibleBitmap($_hDDC, $iW, $iH)
	Local $hCDC = _WinAPI_CreateCompatibleDC($_hDDC)
	_WinAPI_SelectObject($hCDC, $hHBITMAP)
	_WinAPI_BitBlt($hCDC, 0, 0, $iW, $iH, $_hDDC, 0, 0, 0x00CC0020)
	_WinAPI_DeleteDC($hCDC)
	$hBITMAPscr = _GDIPlus_BitmapCreateFromHBITMAP($hHBITMAP) ; screen bitmap

	; resize
	$hBMP = _WinAPI_CreateCompatibleBitmap($_hDDC, $iWa, $iHa) ; create blank
	$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBMP) ; blank bitmap
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1) ; create blank graphics
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBITMAPscr, 0, 0, $iWa, $iHa)

	; Write to file
	_GDIPlus_ImageSaveToFileEx($hImage1, $fTmp, $_sCLSID, $_GpParams)

	; Clean
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hBITMAPscr)
	_GDIPlus_GraphicsDispose($hGraphic)
	_WinAPI_DeleteObject($hBMP)
	_WinAPI_DeleteObject($hHBITMAP)
EndFunc   ;==>captureToFile



#cs
	HTTP/1.0 200 OK\r\n
	Content-Type: multipart/x-mixed-replace;boundary=myboundary\r\n
	\r\n
	--myboundary\r\n
	Content-Type: image/jpeg\r\n
	Content-Length: 15656\r\n
	\r\n
	<JPEG image data>\r\n
	--myboundary\r\n
	Content-Type: image/jpeg\r\n
	Content-Length: 14978\r\n
	\r\n
	<JPEG image data>\r\n
	--myboundary\r\n
	Content-Type: image/jpeg\r\n
	Content-Length: 15136\r\n
	\r\n
	<JPEG image data>\r\n
	--myboundary\r\n
#ce

#EndRegion Streaming functions
; Streaming



#Region Other Functions
Func bb()
	TCP_Exit()
	Exit
EndFunc   ;==>bb

Func c($t)
	ConsoleWrite($t & @CRLF)
	Return $t
EndFunc   ;==>c
#EndRegion Other Functions
; Other






