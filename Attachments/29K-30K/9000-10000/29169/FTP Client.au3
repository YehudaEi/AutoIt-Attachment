#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FTPEx.au3>

#NoTrayIcon

$Inputstyle = $WS_TABSTOP
$InputstyleEx = BitOR($Inputstyle, $ES_READONLY, $WS_VSCROLL)
$InputstylePa = BitOR($Inputstyle, $ES_PASSWORD)

GUICreate("Smart FTP Client 1.0.0.0", 800, 700)

GUICtrlCreateLabel("", 1, 35, 799, 2, 0x08001000)

GUICtrlCreateLabel("Host: ", 10, 10)
$server = GUICtrlCreateInput("", 40, 7, 110, 20, $Inputstyle)

GUICtrlCreateLabel("Username: ", 160, 10)
$username = GUICtrlCreateInput("", 217, 7, 110, 20, $Inputstyle)

GUICtrlCreateLabel("Password: ", 337, 10)
$password = GUICtrlCreateInput("", 394, 7, 110, 20, $InputstylePa)

$okbutton = GUICtrlCreateButton("Connect", 710, 7, 80, 20)

$Status = GUICtrlCreateEdit("", 0, 35, 800, 150, $InputstyleEx)

GUICtrlCreateLabel("", 0, 185, 400, 150, 0x1000)
GUICtrlCreateTreeView (1, 186, 398, 148)
GUICtrlCreateTreeViewItem ("Local DIR Treeview here", -1)

GUICtrlCreateLabel("", 400, 185, 400, 150, 0x1000)
GUICtrlCreateTreeView (402, 186, 398, 148)
GUICtrlCreateTreeViewItem ("Online DIR Treeview here", -1)

GUICtrlCreateLabel("", 0, 335, 400, 150, 0x1000)
GUICtrlCreateTreeView (1, 336, 398, 148)
GUICtrlCreateTreeViewItem ("Local File Treeview here", -1)

GUICtrlCreateLabel("", 400, 335, 400, 150, 0x1000)
GUICtrlCreateTreeView (402, 336, 398, 148)
GUICtrlCreateTreeViewItem ("Online File Treeview here", -1)

GUICtrlCreateListView("File Name | File Size | File Date | Completed (%)", 0, 485, 800, 150)

GUICtrlCreateLabel("File: ", 5, 650)
$fileu = GUICtrlCreateInput(@DesktopDir, 60, 650, 200, 20)
$fileb = GUICtrlCreateButton("Browse", 275, 650, 80, 20)

GUICtrlCreateLabel("Ftp path:", 400, 650)
$path = GUICtrlCreateInput("", 460, 650, 200, 20, $Inputstyle)

GUICtrlCreateLabel("", 0, 680, 800, 20, 0x1000)
GUICtrlCreateLabel("Status: ", 5,683, 40)
$statbar = GUICtrlCreateLabel("Idle", 40, 683, 700)

GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $okbutton
			_ftp()
		Case $msg = $fileb
			$file = FileOpenDialog("Choose file to upload", @DesktopDir, "All Files(*.*)")
			guictrlsetdata ($fileu, $file)
			guictrlsetdata ($statbar, "New File Added")
	EndSelect
WEnd

GUIDelete()

Exit

Func _ftp()
	GUICtrlSetData($statbar, "Reading")
	$ff = GUICtrlRead($fileu)
	$fs = GUICtrlRead($server)
	$fu = GUICtrlRead($username)
	$fp = GUICtrlRead($password)
	$path2 = GUICtrlRead($path)

	$Open = _FTP_Open('FTP connection')

	$Callback = _FTP_SetStatusCallback($Open, 'FTPStatusCallbackHandler')

	$Conn = _FTP_Connect($Open, $fs, $fu, $fp, 0, $INTERNET_DEFAULT_FTP_PORT, $INTERNET_SERVICE_FTP, 0, $Callback)

	_FTP_FilePut($Conn, $ff, $path2)

	$Ftpc = _FTP_Close($Open)

	If @error Then
		GUICtrlSetData($statbar, "Failed to upload.")
	Else
		GUICtrlSetData($statbar, "File succesfully uploaded")
	EndIf
EndFunc   ;==>_ftp

Func FtpStatusCallbackHandler($hInternet, $dwContent, $dwInternetStatus, $lpvStatusInformation, $dwStatusInformationLength)
	If $dwInternetStatus = $INTERNET_STATUS_REQUEST_SENT Or $dwInternetStatus = $INTERNET_STATUS_RESPONSE_RECEIVED Then
		Local $Size, $iBytesRead
		$Size = DllStructCreate('dword')
		_WinAPI_ReadProcessMemory(_WinAPI_GetCurrentProcess(), $lpvStatusInformation, DllStructGetPtr($Size), $dwStatusInformationLength, $iBytesRead)
		If GUICtrlRead($Status) = '' Then
			GUICtrlSetData($Status, GUICtrlRead($Status) & "Status:" & @TAB & (_FTP_DecodeInternetStatus($dwInternetStatus))); & ' | Size = ' & DllStructGetData($Size, 1) & ' Bytes    Bytes read = ' & $iBytesRead))
			Sleep (100)
		Else
			GUICtrlSetData($Status, GUICtrlRead($Status) & @CRLF & "Status:" & @TAB & (_FTP_DecodeInternetStatus($dwInternetStatus))); & ' | Size = ' & DllStructGetData($Size, 1) & ' Bytes    Bytes read = ' & $iBytesRead))
			_GUICtrlEdit_LineScroll($Status, 0, 100)
						Sleep (100)
		EndIf
	Else
		If GUICtrlRead($Status) = '' Then
			GUICtrlSetData($Status, GUICtrlRead($Status) & "Status:" & @TAB & (_FTP_DecodeInternetStatus($dwInternetStatus)))
						Sleep (100)
		Else
			GUICtrlSetData($Status, GUICtrlRead($Status) & @CRLF & "Status:" & @TAB & (_FTP_DecodeInternetStatus($dwInternetStatus)))
			_GUICtrlEdit_LineScroll($Status, 0, 100)
						Sleep (100)
		EndIf
	EndIf
EndFunc   ;==>FTPStatusCallbackHandler
