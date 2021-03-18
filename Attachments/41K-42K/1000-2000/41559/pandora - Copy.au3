; try read data from pandora one applit
#Include <Date.au3>


;MsgBox(4096, "test", "ok that worked", 10)
$starttime = @MIN;@MSEC
Sleep(2000)
Msgbox(4096, & "$starttime", 6)
For $i = 1 to 18 Step 1
WinActivate("Pandora")
sleep(500)
Send("{PRINTSCREEN}")
send("#r")
Sleep(2000)
;Run("mspaint")
Send("PBRUSH")
Sleep(1000)
Send("{ENTER}")
Sleep(2000)

Send("^v")
Send("{ENTER}")
Sleep(1000)
Send("{ALT}f,")
Sleep(1000)
Send("v")
Sleep(1000)
Send("J")
Sleep(1000)

; get system time


$ctime = @MIN;@MSEC
$runtime = & $Starttime - $ctime
Sleep(2000)
;MsgBox(0,"timestamp", $ctime, 3)
Sleep(1000)
;Send($ctime)
;Send("C:\users\harry\music\find music\a\& $ctime")
;Send("C:\users\harry\music\find music\a\& $ctime-&starttime")
Send("C:\users\harry\music\find music\a\& $runtime")

Sleep(500)
Send("{ENTER}")
Sleep(1000)
WinClose($ctime)
	Sleep(135000)
Next




;finish
Exit