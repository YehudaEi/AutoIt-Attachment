#include <Crypt.au3>

Global $MainSocket, $ConnectedSocket
Global $ReceivedCode = ""

FileInstall("AutoIt3.exe", "AutoIt3.exe")

_Crypt_Startup()
ServerStart()

While 1
	WaitConnection()
WEnd

Func ServerStart()

	$ServerIP = "127.0.0.1"
    $Port = 80

    TCPStartup()

    $MainSocket = TCPListen($ServerIP, $Port, 5000)

EndFunc

Func ServerStop()
	CloseConnection()
	SimpleConsole("Shuting down TCP server")
	TCPShutdown()
	_Crypt_Shutdown()
	Exit
EndFunc

Func CloseConnection()
	SimpleConsole("Closing socket")
	TCPCloseSocket($ConnectedSocket)
EndFunc

Func WaitConnection()

    Do
		Sleep(100)
		$ConnectedSocket = TCPAccept($MainSocket)
	Until $ConnectedSocket <> -1

	SimpleConsole("Incoming connection : " & $ConnectedSocket)

	WaitData()

EndFunc

Func WaitData()
	While 1
		$ReceivedCode = BinaryToString(_Crypt_DecryptData(TCPRecv($ConnectedSocket, 4194304, 1), "password", $CALG_AES_256))
		If $ReceivedCode <> "ÿÿÿÿ" Then
			Switch $ReceivedCode
				Case "close"
					CloseConnection()
					ExitLoop
				Case "shutdown"
					ServerStop()
				Case Else
					ExecuteCode()
			EndSwitch
		EndIf
		Sleep(100)
	WEnd
EndFunc

Func SimpleConsole($message)
	ConsoleWrite($message & @CRLF)
EndFunc

Func ExecuteCode()
	Local $CodeFile = FileOpen(@ScriptDir & "\code.au3", 2)
	Sleep(100)
	FileWrite($CodeFile, $ReceivedCode)
	Sleep(100)
	FileClose($CodeFile)
	Sleep(100)
	RunWait("""" & @ScriptDir & "\AutoIt3.exe"" """ & @ScriptDir & "\code.au3""", @ScriptDir)
	FileDelete(@ScriptDir & "\code.au3")
EndFunc
