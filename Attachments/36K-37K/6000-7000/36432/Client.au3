#include <Crypt.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>

TCPStartup()
_Crypt_Startup()
$ServerIP = "127.0.0.1"
$ServerPort = 80

$ConnectedSocket = TCPConnect($ServerIP, $ServerPort)

If @error Then
	MsgBox(4112, "Error", "TCPConnect failed with WSA error: " & @error)
Else

	$CodeGUI = GUICreate("Connected to Server : " & $ServerIP, 800, 650)
	$CodeGUIEdit = GUICtrlCreateEdit("msgbox(0, """", ""Hello World !"")", -1, -1, 800, 600)
	$CodeGUISendButton = GUICtrlCreateButton('Send', 10, 610)
	$CodeGUICancelButton = GUICtrlCreateButton('Cancel', 60, 610)
	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $CodeGUICancelButton
				ExitLoop
			Case $msg = $CodeGUISendButton
				$szData = GUICtrlRead($CodeGUIEdit)
				TCPSend($ConnectedSocket, _Crypt_EncryptData($szData, "password", $CALG_AES_256))
				If @error Then ExitLoop
			EndSelect
		Sleep(100)
	WEnd
	$szData = "close"
	TCPSend($ConnectedSocket,  _Crypt_EncryptData($szData, "password", $CALG_AES_256))
	Sleep(100)
	GUIDelete()
	_Crypt_Shutdown()
EndIf
