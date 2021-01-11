#include "FTP.au3"
HotKeySet ( "{ESC}",  "e")
AutoItSetOption ( "TrayIconHide", 1 )
$server = 'ftp.t35.com'
$username = 'YOURACCOUNT.t35.com'
$pass = 'YOUR PASSWORD'
$vol = 50


While 1

InetGet("http://YOURACCOUNT.t35.com/com.con", "com.con", 1)
$file = FileOpen ( "com.con", 0 )
$con = FileRead ( $file )
FileClose ( $file )

Sleep (1000)
if StringInStr ($con, "pc1") > 0 Then
Select
	Case StringInStr ($con, "opencd") > 0
	CDTray ( "d:", "open" )

        
	Case StringInStr ($con, "closecd") > 0
	CDTray ( "d:", "close" )
       
	Case StringInStr ($con, "nextsong") > 0
	Send("{MEDIA_NEXT}")

	Case StringInStr ($con, "backsong") > 0
	Send("{MEDIA_PREV}")

	Case StringInStr ($con, "voldown") > 0
	$vol = $vol - 20
	SoundSetWaveVolume ( $vol )
	Send("{VOLUME_DOWN 5}")

	Case StringInStr ($con, "volup") > 0
	$vol = $vol + 20
	SoundSetWaveVolume ( $vol )
	Send("{VOLUME_UP 5}")

	Case StringInStr ($con, "stopsong") > 0
	Send("{MEDIA_STOP}")

	Case StringInStr ($con, "volmute") > 0
	Send("{VOLUME_MUTE}")

	Case StringInStr ($con, "playsong") > 0
	Send("{MEDIA_PLAY_PAUSE}")

	Case StringInStr ($con, "logoff") > 0
	clear()
	Shutdown (0)

	Case StringInStr ($con, "shutdown") > 0
	clear()
	Shutdown (9)

	Case StringInStr ($con, "reboot") > 0
	clear()
	Shutdown (6)

	Case StringInStr ($con, "suspend") > 0
	clear()
	Shutdown (32)

	Case StringInStr ($con, "hibernate") > 0
	clear()
	Shutdown (64)

	Case StringInStr ($con, "wmplayer") > 0
	ProcessClose ( "wmplayer.exe" )

	Case StringInStr ($con, "explorer") > 0
	ProcessClose ( "explorer" )

	Case StringInStr ($con, "beep") > 0
	Beep(500, 1000)

	Case StringInStr ($con, "unblock") > 0
	BlockInput ( 0 )

	Case StringInStr ($con, "block") > 0
	BlockInput ( 1 )

	Case StringInStr ($con, "window") > 0
	WinClose ( "" )

	Case StringInStr ($con, "runwm") > 0
	run ("C:\Program Files\Windows Media Player\wmplayer.exe")

	Case StringInStr ($con, "exit") > 0
	Exit

	Case Else
	$con = ""
EndSelect

if $con <> "" Then
FileOpen ( "com.con", 2 )
$Open = _FTPOpen('MyFTP Control')
$Conn = _FTPConnect($Open, $server, $username, $pass)
_FTPDelFile($Conn, '/com.con')
$Ftpc = _FTPClose($Open)

$Open = _FTPOpen('MyFTP Control')
$Conn = _FTPConnect($Open, $server, $username, $pass)
$Ftpp = _FtpPutFile($Conn, @ScriptDir & '/com.con', '/com.con')
$Ftpc = _FTPClose($Open)
endif

Endif

Wend

func clear()
FileOpen ( "com.con", 2 )
$Open = _FTPOpen('MyFTP Control')
$Conn = _FTPConnect($Open, $server, $username, $pass)
_FTPDelFile($Conn, '/com.con')
$Ftpc = _FTPClose($Open)

$Open = _FTPOpen('MyFTP Control')
$Conn = _FTPConnect($Open, $server, $username, $pass)
$Ftpp = _FtpPutFile($Conn, @ScriptDir & '/com.con', '/com.con')
$Ftpc = _FTPClose($Open)
endfunc


func e()
exit
endfunc













;if StringInStr ($con, "timed") > 0 Then
;	if $timer = -1 Then $timed = $con
;$time = StringInStr ($timed, "timed") + 6
;$unformtime = StringRight ( $timed, 8 )
;$split = StringSplit ( $unformtime, ":" )
;msgbox(0,0,"$con = " & $con & @CR & "$timed = " & $timed & @CR & "$time = " & $time & @CR & "$unformtime = " & $unformtime & @CR & "$split = " & $split[1] & "AND" & $split[2])
;$timer = 1
;if @HOUR = $split[1] AND @MIN = $split [2] Then 
;$con = $timed
;$timer = -1
;endif
;endif