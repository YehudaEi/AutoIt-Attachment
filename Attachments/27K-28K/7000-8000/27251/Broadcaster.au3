#cs
	Very simple broadcasting script.
	Opens connection to unlimited amount of clients and sends binary data to them
#ce

#include <StaticConstants.au3>
#include <Array.au3>
#include <WinApi.au3>
Opt("GUIOnEventMode", 1)
TCPStartup()

Global Const $sIP = @IPAddress1, $iPort = 45672
Global Const $iBufferSize = 2 * 1024
Global Const $hBuffer = DllStructCreate("byte[" & $iBufferSize & "]")
Global $sFile, $ListeningSocket, $Connections[1][2], $bBroadCasting = False, $hFile, $FileSize, $iRead


$hWnd = GUICreate("Broadcaster++", 400, 150)
GUISetBkColor(0)

$label1 = GUICtrlCreateLabel("Status:", 10, 10, 380, 30, $SS_CENTER)
GUICtrlSetColor(-1, 0xffffff)
GUICtrlSetFont(-1, 24)

$label2 = GUICtrlCreateLabel("Not broadcasting", 10, 45, 380, 50, $SS_CENTER)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlSetFont(-1, 24)

$button1 = GUICtrlCreateButton("Start Broadcasting", 200 - 75, 90, 150, 40)
GUICtrlSetOnEvent(-1, "StartStopBroadcasting")

GUISetOnEvent(-3, "close")
GUISetState()



Do

	If $bBroadCasting Then

		$tempsocket = TCPAccept($ListeningSocket)
		If $tempsocket <> -1 Then
			ReDim $Connections[UBound($Connections) + 1][2]
			$Connections[UBound($Connections) - 1][0] = $tempsocket
		EndIf

		For $i = UBound($Connections) - 1 To 1 Step -1
			_WinAPI_SetFilePointer($hFile, $Connections[$i][1])

			_WinAPI_ReadFile($hFile, DllStructGetPtr($hBuffer), $iBufferSize, $iRead)
			$Connections[$i][1] += $iRead
			If $iRead = 0 Then
				ConsoleWrite("All data pushed. See ya!" & @CRLF)
				TCPCloseSocket($Connections[$i][0])
				_ArrayDelete($Connections, $i)
				ContinueLoop
			EndIf

			$tempbuffer = DllStructCreate("byte[" & $iRead & "]", DllStructGetPtr($hBuffer))
			ConsoleWrite("Sending " & $iRead & " bytes of data." & @CRLF)
			TCPSend($Connections[$i][0], DllStructGetData($tempbuffer, 1))
			If @error Then ; Client disconnected
				ConsoleWrite("Client disconnected." & @CRLF)
				TCPCloseSocket($Connections[$i][0])
				_ArrayDelete($Connections, $i)
				ContinueLoop
			EndIf			

		Next




	EndIf


Until Not Sleep(10)


Func StartStopBroadcasting()

	If Not $bBroadCasting Then
		$sFile = FileOpenDialog("Audio file to broadcast", "", "MP3 Files(*.mp3;)")
		If $sFile = "" Then Return
		$ListeningSocket = TCPListen($sIP, $iPort)
		$FileSize = FileGetSize($sFile)
		$hFile = _WinAPI_CreateFile($sFile, 2, 2)
		GUICtrlSetData($label2, "Broadcasting")
		GUICtrlSetColor($label2, 0x00ff00)
		GUICtrlSetData($button1, "Stop broadcasting")

	Else
		_WinAPI_CloseHandle($hFile)
		$hFile = 0
		For $i = UBound($Connections) - 1 To 1 Step -1
			TCPCloseSocket($Connections[$i][0])
			_ArrayDelete($Connections, $i)

		Next
		GUICtrlSetData($label2, "Not Broadcasting")
		GUICtrlSetColor($label2, 0xFF0000)
		GUICtrlSetData($button1, "Start broadcasting")
		TCPCloseSocket($ListeningSocket)

	EndIf

	$bBroadCasting = Not $bBroadCasting



EndFunc   ;==>StartStopBroadcasting


Func close()
	If $hFile <> 0 Then _WinAPI_CloseHandle($hFile)
	For $i = UBound($Connections) - 1 To 1 Step -1
		TCPCloseSocket($Connections[$i][0])
		_ArrayDelete($Connections, $i)
	Next
	TCPShutdown()
	Exit
EndFunc   ;==>close