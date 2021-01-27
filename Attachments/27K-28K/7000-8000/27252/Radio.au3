#include <StaticConstants.au3>
#include <Array.au3>


; Due to a bug in version <=3.3.0.0 the script will notfunction correctly in these warnings
If Int(StringReplace(@AutoItVersion, ".", "")) <= 3300 Then
	MsgBox(16,"Error!","This script is NOT compatible with this version of AutoIt!"&@CRLF&"Script will now exit!.")
	Exit
EndIf

; Bass constants
Global Const $BASS_STREAM_BLOCK = 0x100000 ;// download/play internet file stream in small blocks
Global Const $STREAMFILE_BUFFERPUSH = 2
Global Const $STREAMFILE_BUFFER = 1
Global Const $BASS_FILEDATA_END = 0
Global Const $BASS_FILEPOS_BUFFER = 5

; Startup bass & create callbacks
$bass = DllOpen("bass.dll")
DllCall($bass, "int", "BASS_Init", "int", -1, "dword", 44100, "dword", 0, "hwnd", 0, "ptr", 0)
$proc = DllStructCreate("ptr;ptr;ptr;ptr")
$cb_close = DllCallbackRegister("Bass_Callback_Close", "none", "ptr")
$cb_length = DllCallbackRegister("Bass_Callback_Length", "uint64", "ptr")
$cb_read = DllCallbackRegister("Bass_Callback_Read", "dword", "ptr;dword;ptr")
$cb_seek = DllCallbackRegister("Bass_Callback_Seek", "int", "uint64;ptr")
DllStructSetData($proc, 1, DllCallbackGetPtr($cb_close))
DllStructSetData($proc, 2, DllCallbackGetPtr($cb_length))
DllStructSetData($proc, 3, DllCallbackGetPtr($cb_read))
DllStructSetData($proc, 4, DllCallbackGetPtr($cb_seek))




TCPStartup()

Global Const $iPort = 45672
Global $bListening = False, $Socket, $DataBuffer, $hStream = 0


Opt("GUIOnEventMode", 1)
$hWnd = GUICreate("Radio Client++", 400, 150)
GUISetBkColor(0)

$label1 = GUICtrlCreateLabel("Status:", 10, 10, 380, 30, $SS_CENTER)
GUICtrlSetColor(-1, 0xffffff)
GUICtrlSetFont(-1, 24)

$label2 = GUICtrlCreateLabel("Not Listening", 10, 45, 380, 50, $SS_CENTER)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlSetFont(-1, 24)

$button1 = GUICtrlCreateButton("Start Listening", 200 - 75, 90, 150, 40)
GUICtrlSetOnEvent(-1, "StartStopListening")

GUISetOnEvent(-3, "close")
GUISetState()




Do

	If $bListening Then


		If $Socket <> -1 Then ; Recieve data
			$verytemp = TCPRecv($Socket, 1024 ^ 2, 1)
			If @error Then $Socket = -1
			$DataBuffer = Binary($DataBuffer) & Binary($verytemp)
		ElseIf BinaryLen($DataBuffer) = 0 Then ; End of data

			Do
				$call = DllCall($bass, "int64", "BASS_StreamGetFilePosition", "dword", $hStream, "dword", $BASS_FILEPOS_BUFFER)
				Sleep(10)
			Until Not $call[0] ; Wait until the playback buffer is empty
			DllCall($bass, "dword", "BASS_StreamPutFileData", "dword", $hStream, "ptr", $BASS_FILEDATA_END, "int", 0)
			StartStopListening()
		EndIf




		If $hStream = 0 And BinaryLen($DataBuffer) > 8192 Then ; When we have recieved some initial data lets create the stream
			
			; Create data buffer
			$tempbuffer = DllStructCreate("byte[" & BinaryLen($DataBuffer) & "]")
			DllStructSetData($tempbuffer, 1, $DataBuffer)
			
			; Create stream (here comes the story of bass):
			; Even though I wanted to PUSH the data myself (you know, since we don't know when the data will be coming in),
			; but Bass still wants to call the read callbacks making life, uhm quite  annoying. See the Bass_Callback_Read function.
			$hStream = DllCall($bass, "dword", "BASS_StreamCreateFileUser", "dword", $STREAMFILE_BUFFERPUSH, "dword", 0, _
					"ptr", DllStructGetPtr($proc), "ptr", DllStructGetPtr($tempbuffer))
			$hStream = $hStream[0]
			
			; Start the playback
			DllCall($bass, "dword", "BASS_ChannelPlay", "dword", $hStream, "int", 0)


		ElseIf $hStream <> 0 And (BinaryLen($DataBuffer)>1024*10 Or $Socket=-1) Then
			
			; No need to copy entire buffer around, 256 kB should be enough.
			If BinaryLen($DataBuffer) < 256 * 1024 Then
				$tempbuffer = DllStructCreate("byte[" & BinaryLen($DataBuffer) & "]")
			Else
				$tempbuffer = DllStructCreate("byte[" & 256 * 1024 & "]")
			EndIf
			DllStructSetData($tempbuffer, 1, $DataBuffer)
			
			; Push some data!
			$call = DllCall($bass, "dword", "BASS_StreamPutFileData", "dword", $hStream, "ptr", DllStructGetPtr($tempbuffer), "int", DllStructGetSize($tempbuffer))
			
			ConsoleWrite("Pushed "&$call[0]&" bytes of data (Total buffer size: "&BinaryLen($DataBuffer)&")."& @CRLF)
			
			; Remove data that already have been pushed.
			$DataBuffer = Binary(BinaryMid($DataBuffer, $call[0] + 1))
		EndIf
	EndIf
Until Not Sleep(75)



Func StartStopListening()

	If Not $bListening Then
		$sIP = InputBox("IP of broadcaster", "Please enter the dotted ip address of the broadcaster", @IPAddress1)
		$Socket = TCPConnect($sIP, $iPort)
		If $Socket = -1 Then
			MsgBox(16, "Error", "Failed to connect")
			Return
		EndIf

		GUICtrlSetData($label2, "Listening")
		GUICtrlSetColor($label2, 0x00ff00)
		GUICtrlSetData($button1, "Stop Listening")
		$DataBuffer = ""


	Else
		DllCall($bass, "dword", "BASS_StreamFree", "dword", $hStream)
		$hStream = 0
		GUICtrlSetData($label2, "Not Listening")
		GUICtrlSetColor($label2, 0xff0000)
		GUICtrlSetData($button1, "Start Listening")
		TCPCloseSocket($Socket)



	EndIf

	$bListening = Not $bListening

EndFunc   ;==>StartStopListening



Func close()
	DllCall($bass, "int", "BASS_StreamFree", "dword", $hStream)
	TCPShutdown()
	Exit
EndFunc   ;==>close



Func Bass_Callback_Close($pUser)
	ConsoleWrite("Bass wants to close the file." & @CRLF)
EndFunc   ;==>Bass_Callback_Close

Func Bass_Callback_Length($pUser)
	ConsoleWrite("Bass wants the length of the file." & @CRLF)
	; Returning 0 means Bass will get the data when bass gets it. 
	Return 0
EndFunc   ;==>Bass_Callback_Length

Func Bass_Callback_Read($pBuffer, $iSize, $pUser)
	; Write data to the buffer pointer Bass supplied us with.
	; Hopefully bass don't want more than 8 kB (the amount of data guarantied to be in the buffer) 
	$tBuffer = DllStructCreate("byte[" & $iSize & "]", $pBuffer)
	DllStructSetData($tBuffer, 1, BinaryMid($DataBuffer, 1, $iSize))
	$DataBuffer = BinaryMid($DataBuffer, $iSize)
	ConsoleWrite("Bass wants to read " & $iSize & " bytes." & @CRLF)
	Return $iSize
EndFunc   ;==>Bass_Callback_Read

Func Bass_Callback_Seek($iOffset, $pUser)
	ConsoleWrite("Bass wants to seek the file." & @CRLF)
EndFunc   ;==>Bass_Callback_Seek