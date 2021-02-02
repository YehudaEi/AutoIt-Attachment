#Include <FTP.au3>
#Include <Timers.au3>


Local $dic= '-sume dic-'
Local $server = 'ftp.leet-skills.com'
Local $username = '-censored username'
Local $pass = '-censored password'

Local $show = true

HotKeySet ("{F4}", "_sync")


Local $timer = TimerInit()
Local $dif



_sync()


Func _sync()
	
	
if $show = true then
ToolTip("Starting Sync...",0,0)
endif
$Open = _FTPOpen('LS_FTP')
$Conn = _FTPConnect($Open, $server, $username, $pass)


;_FTPDelDir($Open, '/')
;delete the dic on the server first (unknown if needed)

;$Ftpp = _FtpPutFile($Conn, $dic, '/')
;upload the dic

; ^these two dont work. -.-



$Ftpc = _FTPClose($Open)

if $show = true then
ToolTip("Sync done!",0,0)
Sleep(2000)
ToolTip("")
endif

EndFunc



While True
$dif = TimerDiff($timer)
If $dif > 10000 Then
_sync()
$timer = TimerInit()
Endif
WEnd




