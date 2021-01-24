#include <GUIConstants.au3>
#include <Array.au3>
#include "FTP_Ex.au3"
Opt("GUIOnEventMode", 1)
$h_Handle = DllOpen('wininet.dll')
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Vundo/Moder FTP Downloader", 388, 264, 196, 127)
$s = GUICtrlCreateInput("sys1", 40, 40, 145, 21)
$u = GUICtrlCreateInput("plato", 80, 88, 105, 21)
$p = GUICtrlCreateInput("04aug08", 264, 88, 105, 21)
$r = GUICtrlCreateInput("/Public/AutoItScript", 96, 160, 153, 21)
$l = GUICtrlCreateInput("C:\Documents and Settings\Plato\Desktop", 96, 192, 153, 21)
$Label1 = GUICtrlCreateLabel("Server Name/Address:", 8, 16, 144, 17)
GUICtrlSetFont(-1, 8, 800, 0, "DejaVu Sans")
$Label2 = GUICtrlCreateLabel("Username:", 8, 92, 72, 17)
GUICtrlSetFont(-1, 8, 800, 0, "DejaVu Sans")
$Label3 = GUICtrlCreateLabel("Password:", 192, 92, 70, 17)
GUICtrlSetFont(-1, 8, 800, 0, "DejaVu Sans")
$Label4 = GUICtrlCreateLabel("Remote Dir:", 8, 164, 78, 17)
GUICtrlSetFont(-1, 8, 800, 0, "DejaVu Sans")
$Label5 = GUICtrlCreateLabel("Local Dir:", 8, 195, 64, 17)
GUICtrlSetFont(-1, 8, 800, 0, "DejaVu Sans")
$Button1 = GUICtrlCreateButton("Update", 288, 176, 75, 25, 0)
GUICtrlSetFont(-1, 10, 800, 0, "Sylfaen")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
	GUICtrlSetOnEvent ( $Button1 , "FTPConnection" )
WEnd

Func FTPConnection()
	$server = GUICtrlRead($s)
	$user = GUICtrlRead($u)
	$pass = GUICtrlRead($p)
	$localDir = GUICtrlRead($l)
	$threatDir = GUICtrlRead($r)
	$Open = _FTPOpen('Connect to Server')
	$Conn = _FTPConnect($Open, $server , $user , $pass , 0)
	if @error Then
		msgbox(0,"Error","Wrong Username/Password!!!")
		Exit
	EndIf
	_FtpSetCurrentDir($Conn , $threatDir)
	dim $file , $l_Context , $temp[12]
	$temp = _FTPFileFindFirst($Conn , $threatDir , $h_Handle , $l_Context , 0)
	;if not FileExists("lastmodifiedlog.txt")
	;	$logfile = FileOpen("lastmodifiedlog.txt", 2)
		
	$file = $temp[10]
	_ArrayDisplay($temp)
	while 1	
		_FTPGetFile( $Conn , $threatDir & "/" & $file , $localDir & "\" & $file, 2 , 0,0x00000080 , 0)
		$temp = _FTPFileFindNext($h_Handle , $l_Context)
		if UBound($temp) < 10 Then
			Exit
		EndIf
			
		$file = $temp[10]
		
		if @error Then 
			MsgBox(0,"Done!!!","no More Files to Download")
			_FTPFileFindClose($Conn , $threatDir)
			Exit
		EndIf
	WEnd
	$Ftpc = _FTPClose($Open)
EndFunc