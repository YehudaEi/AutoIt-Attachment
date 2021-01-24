#include <GUIConstants.au3>
#include <Array.au3>
#include "ftp.au3"
Opt("GUIOnEventMode", 1)

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("FTP Vundo/Monder Downloader", 306, 235, 195, 113)
$server = GUICtrlCreateInput("<server name>", 24, 32, 257, 21)
$username = GUICtrlCreateInput("<user name>", 136, 88, 137, 21)
$pass = GUICtrlCreateInput("<password>", 136, 120, 137, 21)
$Label1 = GUICtrlCreateLabel("Server Name/Address:", 24, 16, 132, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Username:", 64, 90, 64, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Password:", 64, 123, 62, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Connect = GUICtrlCreateButton("Connect", 112, 184, 75, 25, 0)

#EndRegion ### END Koda GUI section ###
$dllhandle = DllOpen('wininet.dll')
While 1
	GUISetState(@SW_SHOW)
	$nMsg = GUIGetMsg()
	if $nMsg = $GUI_EVENT_CLOSE Then
		Exit
	Else
		GUICtrlSetOnEvent($Connect, "FTPConnection")
	EndIf
WEnd
Func FTPConnection()
	$Open = _FTPOpen('Connect to Server')
	$Conn = _FTPConnect($Open, $server, $username, $pass)
	$threatDir = InputBox("Threat Remote Dir","Enter the Remote Threat Dir:")
	$localDir = InputBox("Local Dir","Enter the local Path:")
	_FtpSetCurrentDir($Conn , $threatDir)
	dim $file , $l_Context
	$temp = _FTPFileFindFirst($Conn , $threatDir )
	_ArrayDisplay($temp)
	$file = $temp[10]
	while 1	
		_FTPGetFile( $Conn , $threatDir & "/" & $file , $localDir & "\" & $file, 2 , 0,0x00000080 , 0)
		$file = _FTPFileFindNext($dllhandle, $l_Context)
		if @error Then 
			MsgBox(0,"Done!!!","no More Files to Download")
			_FTPFileFindClose($Conn , $threatDir)
			Exit
		EndIf
	WEnd
	$Ftpc = _FTPClose($Open)
EndFunc

;/Public/AutoItScript