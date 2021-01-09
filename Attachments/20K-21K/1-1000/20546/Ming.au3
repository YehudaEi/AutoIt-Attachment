#include <ftp.au3>
#include <File.au3>
#include <GUIConstants.au3>
$x = @DesktopWidth/2
$y = @DesktopHeight/2
$user = 'ludocus'
$tmpfile = @Tempdir&'\40392kop.txt'
$tmpfile2 = @Tempdir&'\4636gus.txt'
Const $FTP_TRANSFER_TYPE_ASCII = 0x01
Const $FTP_TRANSFER_TYPE_BINARY = 0x02
Const $INTERNET_FLAG_NO_CACHE_WRITE = 0x4000000
$ftp_flags = $FTP_TRANSFER_TYPE_BINARY + $INTERNET_FLAG_NO_CACHE_WRITE
$server = 'www.0catch.com'
$username = 'mingsystem.0catch.com'
$pass = 'minger'
$dllhandle = DllOpen('wininet.dll')
$Open = _FTPOpen('ftp')
$Conn = _FTPConnect($Open, $server, $username, $pass)
_CreatePing($user)
$tokkie = true
local $tijd = 0
$Form1 = GUICreate("Ming", 468, 293, 191, 123)
GUISetBkColor(0x000080)
$title = GUICtrlCreateInput("", 24, 32, 121, 21)
$Label1 = GUICtrlCreateLabel("Title:", 24, 8, 36, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x00FF00)
$text = GUICtrlCreateEdit("", 24, 88, 353, 193)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x00FF00)
$Label2 = GUICtrlCreateLabel("Text:", 24, 64, 36, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x00FF00)
$Label3 = GUICtrlCreateLabel("To:", 248, 8, 24, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0x00FF00)
$ping = GUICtrlCreateInput("", 248, 32, 121, 21)
$Ming = GUICtrlCreateButton("Ming", 400, 256, 59, 25, 0)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetBkColor(-1, 0x00FF00)
GUISetState(@SW_SHOW)

while 1
	if $tokkie = true then
		$1 = _GetMingList($user)
	    $timer = TimerInit()
		$tijd = 0
		$tokkie = false
	EndIf
	$tijd = Round(TimerDiff($timer))
	if $tijd = 20000 or $tijd > 20000 then
		$2 = _GetMingList($user)
		if $1 <> $2 then 
		    _GetMings($2)
		EndIf
		
		$tokkie = True
	EndIf
	
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			
		Case $Ming
			$pTitle = GUICtrlRead($title)
			$pText = GUICtrlRead($text)
			$pPing = GUICtrlRead($ping)
			;msgbox ( 0, $pTitle, $pText&' ping: '&$pPing)
			;exit
			if $pTitle <> '' and $pText <> '' and $pPing <> '' Then
				Tooltip('Sending ming to '&$pPing, $x, $y, 'Please wait...')
				_SendMing($pPing, $pTitle, $pText)
				Tooltip('')
				msgbox ( 32, 'Ming', 'Succesfully send ming to '&$pPing)
			Else
				msgbox ( 32, 'Ming', 'Please fill in all the fields before sending a ming')
			EndIf
		
				

	EndSwitch
WEnd

func _GetMingList($sPing)
	local $sReturn
	local $count = 0
	$mings = _FtpGetFolderContents($server, $username, $pass, $sPing)
	if not IsArray($mings) then return ''
	while 1
		$count = $count + 1
		if $count = 1 Then
			$sReturn &= $mings[$count][0]
		Else
		    $sReturn &='|'&$mings[$count][0]
		EndIf
		if $count = $mings[0][0] then exitloop
	WEnd
	return $sReturn
EndFunc ;==> _GetMingList

Func _GetMings($sMingList)
	local $count = 0
	$stringie = StringSplit($sMingList, '|', 1)
	if $stringie[0] = 0 then return -1
	While 1
		$count = $count + 1
		_GetMing($user, $stringie[$count])
		if $count = $stringie[0] then exitloop
	WEnd
	return 1
EndFunc ;==>_GetMings

func _GetMing($sPing, $sTitle)
	_FtpSetCurrentDir($Conn, $sPing)
	$s1 = _FTPGetFile($Conn, $sTitle&'.txt', @ProgramFilesDir&'\Ming\'&$sPing&'\'&$sTitle&'.txt', $ftp_flags)
	_FtpSetCurrentDir($Conn, '')
	$sReturn = _FileLoadFile(@ProgramFilesDir&'\Ming\'&$sPing&'\'&$sTitle&'.txt')
	return $sReturn
EndFunc


func _CreatePing($sPing)
	_FTPMakeDir($Conn, $sPing)
	DirCreate(@ProgramFilesDir&'\Ming\'&$sPing)
EndFunc ;==> _CreatePing

Func _DelPing($sPing)
	_FTPDelDir($Conn, $sPing)
EndFunc ;==> _DelPing

Func _DelMing($sPing, $sMing)
	_FTPSetCurrentDir($Conn, $sPing)
	_FTPDelFile($Conn, $sMing)
EndFunc

Func _GetFolder($sPath)
	local $count = 1
	$search = FileFindFirstFile($sPath&'\*.*')
	While 1
		$file = FileFindNextFile($search)
		if $file = '' then exitloop
		if $count = 1 Then
			$sReturn = $file
		Else
		    $sReturn &= '|'&$file
		EndIf
		$count = $count + 1
	WEnd
	return $sReturn
EndFunc ;==> _GetFolder

func _SendMing($sPing, $sTitle, $sData)
	_FileCreate($tmpfile)
	_FileWriteToLine($tmpfile, 1, $sData)
	_FtpSetCurrentDir($Conn, $sPing)
	While 1
		$ftpg = _FTPPutFile($Conn, $tmpfile, $sTitle&'.txt', $ftp_flags)
		if $ftpg <> 0 then exitloop
	WEnd
	_FtpSetCurrentDir($Conn, '')
	FileDelete($tmpfile)
	FileDelete($tmpfile2)
EndFunc