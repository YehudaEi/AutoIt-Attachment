;#include <ScreenCapture.au3>

#include "GDIPlus.au3"
#include "WinAPI.au3"


HotKeySet('{end}', 'bb')
Func bb()
	Exit
EndFunc   ;==>bb


;@@@@@@@@@@@@@@@@@@@@@@@
Local $szIPADDRESS = @IPAddress1
Local $nPORT = 80
Local $MainSocket, $ConnectedSocket
Local $recv
;@@@@@@@@@@@@@@@@@@@@@@@


;@@@@@@@@@@@@@@@@@@@@@@@
Global $iW = _WinAPI_GetSystemMetrics(0) + 1
Global $iH = _WinAPI_GetSystemMetrics(1) + 1

Global $iWa = $iW / 2
Global $iHa = $iH / 2

Global $fTmp = @TempDir & "\tmp.jpg"

Global $_hWnd = _WinAPI_GetDesktopWindow()
Global $_hDDC = _WinAPI_GetDC($_hWnd)

_GDIPlus_Startup()

Global $_sCLSID = _GDIPlus_EncodersGetCLSID('jpg')

; set paremeters for compression
Global $_GtParams = _GDIPlus_ParamInit(1)
Global $_GtData = DllStructCreate("int Quality")
DllStructSetData($_GtData, "Quality", 80)
_GDIPlus_ParamAdd($_GtParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, DllStructGetPtr($_GtData))
Global $_GpParams = DllStructGetPtr($_GtParams)
;@@@@@@@@@@@@@@@@@@@@@@@


;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
TCPStartup()

$MainSocket = TCPListen($szIPADDRESS, $nPORT)
If $MainSocket = -1 Then Exit

$ConnectedSocket = -1
While True
	$ConnectedSocket = TCPAccept($MainSocket)
	$recv = TCPRecv($ConnectedSocket, 2048)

	If $recv == '' Then ContinueLoop
	If StringLeft($recv, 3) == 'GET' Then
		_StartStream($ConnectedSocket)
		Exit
	EndIf
WEnd
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


Func _StartStream(ByRef $i)
	$Packet = Binary("HTTP/1.1 200 OK" & @CRLF & _
			"Connection: close" & @CRLF & _
			"Content-Type: multipart/x-mixed-replace;boundary=myboundary" & @CRLF & _
			@CRLF & _
			"--myboundary" & @CRLF)
	TCPSend($i, $Packet)
	If @error Then Return 0

	While True
		$tt = TimerInit()
		captureToFile() ; function takes all the time in the world to run

		$Packet = Binary("Content-Type: image/jpeg" & @CRLF & _
				@CRLF & _
				FileRead($fTmp) & _
				@CRLF & _
				"--myboundary" & @CRLF)
		TCPSend($i, $Packet)

		If @error Then Return 0
		c(Round(1000 / TimerDiff($tt)) & ' fps')
	WEnd
	TCPCloseSocket($i)
EndFunc   ;==>_StartStream


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
EndFunc   ;==>tofile



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






Func c($t)
	ConsoleWrite($t & @CRLF)
	Return $t
EndFunc   ;==>c