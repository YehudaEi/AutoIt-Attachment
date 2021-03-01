#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <Memory.au3>

Global $Server, $Socket
Global $sIPAddress = @IPAddress1
Global $nPort = 11224

TCPStartup()
$Server = TCPListen($sIPAddress,$nPort)

While True
	Do
		$Socket = TCPAccept($Server)
		Sleep(10)
	Until $Socket <> -1
	While True
		$sRecv = TCPRecv($Socket,1024)
		If @error Then
			ExitLoop
		ElseIf $sRecv Then
			$sRequest = StringStripWS(StringLeft($sRecv,4),8)
			If $sRequest == "GET" Then
				If StringMid($sRecv,6,4) = "Quit" Then Quit()
				If StringMid($sRecv,6,12) = "GetDesktopWH" Then SendDesktopWH($Socket,StringMid($sRecv,21,1))
				$sScreen = StringReplace(StringTrimRight(StringTrimLeft($sRecv,5),11),"/","\")
				$sScreen = StringReplace(StringLeft($sScreen,StringInStr($sScreen,@CRLF)-1)," HTTP\1.1","")
				If StringLeft($sScreen,6) = "SCREEN" Then
					$aArg = StringSplit(StringTrimRight(StringTrimLeft($sScreen,7),1),",")
					If IsArray($aArg) Then SendScreen($Socket,$aArg[1],$aArg[2],$aArg[3],$aArg[4],$aArg[5],$aArg[6])
				EndIf
			EndIf
		EndIf
	WEnd
WEnd

Func SendDesktopWH($hSocket,$Type)
	Switch $Type
		Case "W"
			$bData = StringToBinary(@DesktopWidth-1)
		Case "H"
			$bData = StringToBinary(@DesktopHeight-1)
	EndSwitch
	Local $sPacket = Binary("HTTP/1.1 200 OK" & @CRLF & _
    "Server: ScreenCapture Server" & @CRLF & _
	"Connection: close" & @CRLF & _
	"Content-Lenght: " & BinaryLen($bData) & @CRLF & _
    "Content-Type: text/plain" & @CRLF & @CRLF)
	TCPSend($hSocket,$sPacket & $bData)
	TCPCloseSocket($hSocket)
EndFunc

Func SendScreen(ByRef $hSocket,$iX,$iY,$iW,$iH,$bCursor,$iQuality)
	If $bCursor = "True" Then
		$bCursor = True
	ElseIf $bCursor = "False" Then
		$bCursor = False
	EndIf
	_GDIPlus_Startup()
	_ScreenCapture_SetJPGQuality($iQuality)
	$hCapture = _ScreenCapture_Capture("",$iX,$iY,$iW,$iH,$bCursor)
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hCapture)
	_WinAPI_DeleteObject($hCapture)
	$JPG_Encoder = _GDIPlus_EncodersGetCLSID("jpg")
	$tGUID = _WinAPI_GUIDFromString($JPG_Encoder)
	$ptrGUID = DllStructGetPtr($tGUID)
	$hStream = _WinAPI_CreateStreamOnHGlobal(0)
	_GDIPlus_ImageSaveToStream($hBitmap,$hStream,$ptrGUID)
	_GDIPlus_BitmapDispose($hBitmap)
	$hMemory = _WinAPI_GetHGlobalFromStream($hStream)
	$iMemSize = _MemGlobalSize($hMemory)
	$ptrMemory = _MemGlobalLock($hMemory)
	$tData = DllStructCreate("byte BinaryData[" & $iMemSize & "]",$ptrMemory)
	$bData = DllStructGetData($tData,"BinaryData")
	_MemGlobalFree($hMemory)
	_WinAPI_DeleteObject($hStream)
	_GDIPlus_Shutdown()
	Local $sPacket = Binary("HTTP/1.1 200 OK" & @CRLF & _
    "Server: ScreenCapture Server" & @CRLF & _
	"Connection: close" & @CRLF & _
	"Content-Lenght: " & BinaryLen($bData) & @CRLF & _
    "Content-Type: image/jpeg" & @CRLF & @CRLF)
	TCPSend($hSocket,$sPacket)
    While BinaryLen($bData)
        $iSent = TCPSend($hSocket,$bData)
        $bData = BinaryMid($bData,$iSent + 1,BinaryLen($bData) - $iSent)
    WEnd
    $sPacket = Binary(@CRLF & @CRLF)
    TCPSend($hSocket,$sPacket)
	TCPCloseSocket($hSocket)
EndFunc

Func _GDIPlus_ImageSaveToStream($hImage, $pStream, $pEncoder, $pParams = 0)
    Local $aResult = DllCall($ghGDIPDll, "uint", "GdipSaveImageToStream", "ptr", $hImage, "ptr", $pStream, "ptr", $pEncoder, "ptr", $pParams)
    If @error Then Return SetError(1, 0, 0)
    Return SetError($aResult[0] <> 0, 0, $aResult[0] = 0)
EndFunc

Func _WinAPI_CreateStreamOnHGlobal($hGlobal, $fDeleteOnRelease = 1)
    Local $aResult = DllCall("ole32.dll", "uint", "CreateStreamOnHGlobal", "ptr", $hGlobal, "bool", $fDeleteOnRelease, "ptr*", 0)
    If @error Or $aResult[0] Then Return SetError(1, 0, 0)
    Return $aResult[3]
EndFunc

Func _WinAPI_GetHGlobalFromStream($pStream)
    Local $aResult = DllCall("ole32.dll", "uint", "GetHGlobalFromStream", "ptr", $pStream, "ptr*", 0)
    If @error Or $aResult[0] Then Return SetError(1, 0, 0)
    Return $aResult[2]
EndFunc

Func Quit()
	TCPCloseSocket($Socket)
	TCPCloseSocket($Server)
	TCPShutdown()
	Exit
EndFunc